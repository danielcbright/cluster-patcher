function bump_version () {
    curr_number=`grep number ./config.toml | cut -d "=" -f2`
    new_version=`echo $(date +%s)`
    sudo sed -i "s/number\s*=\s*$curr_number/number = $new_version/g" ./config.toml
    echo $new_version
}
function config_apply () {
    apply_version=$(bump_version)
    hab config apply <svc_name.grp_name> $apply_version ./config.toml
}

config_apply