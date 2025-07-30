Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169F3C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 04:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA7E6B0088; Wed, 30 Jul 2025 00:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABD96B0089; Wed, 30 Jul 2025 00:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A696B008A; Wed, 30 Jul 2025 00:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21AF56B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:50:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E29F1DA45B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:50:15 +0000 (UTC)
X-FDA: 83719704390.11.F6949F8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf01.hostedemail.com (Postfix) with ESMTP id C967040006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:50:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZTe+FqaD;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753851013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qYtDj05HRSr2+Zdv+vEmuIHp8y1bY1UGEEvqofkBM5I=;
	b=JrFjcHBe766HUzFFJDcrXWCg6MG5622gDzEXq3X5rEdHamjuVZIA9MCXgx1VmKGE+O27Ca
	duOW/mA9gAy7EO88TWmbZNKaHvKkhJ/mIZnxbJuRk9iPveghuoc/Pl8q2n9bhAjbE5SU4D
	q2DCHGSBUeJ091iQtJqngR0UuWTplhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753851013; a=rsa-sha256;
	cv=none;
	b=xiAqAE8Vtr1xgyfU9e5p09a+8bBfWnP0WoBD/PXbE6CfqdbPkhceJnrnW8RMOqr0zm3tou
	dFHWbT+ElCTgXzYKHp61kfqBUpIP1QY9sxOag9DVNsjaHiiGqYK1djG2swcknh3J3TUUvr
	daGq9WEwl4xQZ//6MgkR4pvHJ6h6Iew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZTe+FqaD;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753851013; x=1785387013;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3qY2GXDtkUgoiX5+Yv3yizbtbvmmq1XZY6QhR449yRI=;
  b=ZTe+FqaDh6hKwqhpx8EowZ91Ho6JKFMveTA+68BeQqfVlyvXR9EfXP/W
   52Yh9501CQXo3r/MqAMOmNnnm9PF8qJjZFlccLcmKOVVhF7dOR0Wm3zqw
   CsT+4e+0i6wrdwD0TC5CFPLbxOmYBYY/vHxxP9In8LcM7v/IpfV13yje7
   TwIoS9zb3zwEOF6IRyLxX/hOdAjFVKgDT68aB55uBywTyZlTcSSUFU5cr
   3ILmwVv1RvlNuSjLGMcBw28cTefNo9fIEN2e5Nzgr4X9A1Gg8B1JUHArj
   c2j5gL6EmBjqAXRsBHmHZ9Z4nl58ogeZSRNQd6wdqyZfoIAggZU3ri3JD
   g==;
X-CSE-ConnectionGUID: VrmEyjITQUeegCTDujGSBw==
X-CSE-MsgGUID: EGKceLYSSg2ZSCFN7SjMiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="73729401"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="73729401"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 21:50:11 -0700
X-CSE-ConnectionGUID: SKNTQbR/Ra+F0cp8kTEaWA==
X-CSE-MsgGUID: RRZ2W68FTMyaZ6WpZzE51A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="200063786"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 Jul 2025 21:50:09 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugylS-00022k-23;
	Wed, 30 Jul 2025 04:50:06 +0000
Date: Wed, 30 Jul 2025 12:50:01 +0800
From: kernel test robot <lkp@intel.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [linux-next:master 10063/12827] vmlinux.o: warning: objtool:
 watchdog+0x418: sibling call from callable instruction with modified stack
 frame
Message-ID: <202507301256.cZlxQ10s-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C967040006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ttb1dwygup4bhg5b35uez7ujrb35x7rw
X-HE-Tag: 1753851012-119423
X-HE-Meta: U2FsdGVkX1/MlhrxtM7ALtbt05VSyzxAgWYbWTVAqKAuE01A6s++Ndn2s7FaPBaxv7TT0xRsp6Gy0a+vUoaLYxGp+qLADZQbaaqls47i++iLAxfUEpk9nHtsZXvBmIQoUiX0H+wQ95ma8widmWHfP3J84alyu44ZXXQ857sHnEF6Ij+IyFkDKl3pEEp9QTMQhk4yBL3YgJz0JhirekOP77AQ2UfasHOaj8KTMEpKAobZDxGBH7f8CFYuLlgfb22ZlItFOuDJriKlBi55mOihcLnbcnraXJ+0K09KO/dT0r+ZilwQAYeEYzY/8KgGI6fbms+LIZUB/DKb8GtnhQf/L/vhDafIVYsLYKz4p0DQEBZdYnGiQB4kXI6GMdq83VOHFji/BoSh8038IRoSSmOdhS8semRQqkM8ovRPQ4ApN/I3uwItiBsgYgiuEJ1FvOTo1zVtPa++V416opWi50kELtD4QPrFYH199qW0YWnbg7wY2SqQhfvQe/NgtU5/WC6QtYEEYcXCeAAYbIdrObJGMZ7FpBuhznD1TpYfPUh6v78IrGnDz6oAZ6GyQrh+qjti1DCadcTCVGQSOeAfyTpB8iTWpXKHBr+5F4U7IQGzbEnMX0CjQQ6/Zmus0vcjDiqJpkDKJ+MFVJcCVS80KwvTuu69tzN5UK7A6YsszP0C1DPmvSGn2GCP8Aj47cmsno2elvS8txkB58VvjNXVNueboaFPRXHLaPD1rWC/Jy1mIsv7XHQJOD1uVwHrQOHRS53UOn1RVm18MP+ftUiErfMwyYsUpULOOlZHkCCD0pNVtNdNTSjpSudg19RYWDs20mcFWUZU1YhAclV8U2KTjBqTfM/a4skY9pt54lu/qfeJwvOkO1W3sE2fW/ltQGsuDXFlk6aSFO9BtMiB9eshUhQDcUVM+rF+cdAFq9lEc7Bpmo+40Z1NmmoRoNUAJNMm4TMn/mj/znJX0TDXLqd1r45
 rKZeYSC/
 YHegeDCo6m56JV3NaBY94uL+k5kvKEPDbRbFuHZMe6mXEAabtybwmnVoOMjTLG6cbCb5LhZMbL2Akob3IFSTf247iDrV3btRxZCYS6vn1mE9U8AI1M9vsLd8CvNOFh7ZJzgA+GlfJ3D8J+s56n2kTWyKFsuFGbcS+6K+3UfUvhAFPozNz/UF5eNvPNbQdp+/zlb1PZCNpWXMMhSTRK1Oag20XkW5GlRXrYipal4lSiIrVHz9cIdlsXnRkQ97QSCB+GDMcvQnq1mlhHA16CT1whpHRJtkPNw0QJ7eE52c7c0CSa0f0Obst1KICl2UjnUCnDRN0nmbiRvcoYFdtZIUuZuS+x6ph80O91D+E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   54efec8782214652b331c50646013f8526570e8d
commit: 77da18de55ac6417e48905bec8b3c66f023b15a9 [10063/12827] hung_task: extend hung task blocker tracking to rwsems
config: loongarch-randconfig-002-20250730 (https://download.01.org/0day-ci/archive/20250730/202507301256.cZlxQ10s-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250730/202507301256.cZlxQ10s-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507301256.cZlxQ10s-lkp@intel.com/

All warnings (new ones prefixed by >>):

   vmlinux.o: warning: objtool: do_bp+0x94: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: do_name+0x150: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: memblock_init+0xb8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: recompute_jump+0x11c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: init_node_memblock+0x78: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: reboot_setup+0xf4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: rcu_torture_init+0x1a0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: acpi_parse_entries_array+0xdc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: control_setup+0x190: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: pnpacpi_add_device+0x43c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: pnpacpi_option_resource+0x5c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: isapnp_create_device+0x1c4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: create_one_pll+0x180: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: clk_starfive_jh7100_probe+0x290: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: jh7110_syscrg_probe+0x350: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: parse_options+0x9c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: ips_module_init+0x108: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: qla1280_setup+0x194: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: scsi_debug_init+0xd8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: it87_find+0x88c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: ibft_check_initiator_for+0x48: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: ibft_check_tgt_for+0x48: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sysfb_init+0xb4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: efi_esrt_init+0x168: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: of_unittest_parse_phandle_with_args+0x13c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: of_unittest_parse_phandle_with_args_map+0x268: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: of_unittest_parse_interrupts+0x198: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: of_unittest_parse_interrupts_extended+0xc8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: unxz+0x398: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpu_probe+0xf0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: arch_do_signal_or_restart+0x134: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: simu_pc+0xa4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: simu_branch+0x120: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: arch_ptrace+0xb0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: tso_write+0x7c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bt_address+0xc0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: reenter_kprobe+0x58: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: flush_cache_leaf+0x10c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpu_hotplug_pm_callback+0x40: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: kernel_waitid_prepare+0xa0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: ptrace_request+0xe8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sys_prctl+0xb4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: prctl_set_mm+0x358: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: jhash+0x134: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: jhash+0x134: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: jhash+0x134: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: jhash+0x134: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: task_work_add+0xe0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: register_sys_off_handler+0x138: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sched_balance_rq+0xe3c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sched_balance_find_dst_cpu+0x6a4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: kcpustat_field+0x1b8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: stress+0xf4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __msi_domain_alloc_irqs+0x4cc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: rcu_torture_writer+0x45c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: rcu_torture_fakewriter+0x124: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: rcu_pm_notify+0x24: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sys_kcmp+0x1d0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: second_overflow+0x60: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: do_timer_create+0x248: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: clockevents_switch_state+0xac: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: time64_to_tm_test_date_range+0x19c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cgroup2_parse_param+0x7c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __cgroup_account_cputime_field+0x60: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cgroup1_parse_param+0x14c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpuset_common_seq_show+0x7c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: update_parent_effective_cpumask+0xd30: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpuset_partition_show+0x5c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpuset_read_u64+0x50: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cpuset_write_u64+0xbc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: hungtask_pm_notify+0x40: sibling call from callable instruction with modified stack frame
>> vmlinux.o: warning: objtool: watchdog+0x418: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_record_free+0xbc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_record_dup+0x110: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_obj_free_fields+0xd0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_map_value_size+0x48: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_map_update_value+0x128: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_map_copy_value+0x88: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_sys_bpf+0x78: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: kern_sys_bpf+0x74: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_and_init_map_value+0x108: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __sys_bpf+0x1e8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: map_create+0x4e4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_load+0x268: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_attach+0x1d0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_detach+0x1ac: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_query+0xa0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: map_lookup_and_delete_elem+0x364: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: link_create+0x144: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: link_create+0x3a0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: map_check_btf+0x2e4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_load_check_attach+0x11c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: attach_type_to_prog_type+0x3c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_prog_attach_check_attach_type+0xac: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_raw_tp_link_attach+0x60: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_check_attach_target+0x210: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_check+0x2e04: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: resolve_pseudo_ldimm64+0x220: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_attach_btf_id+0x14c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: compute_live_registers+0x580: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __add_used_map+0x228: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: add_kfunc_call+0x444: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: do_check_common+0x1cb8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_mem_access+0xb8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: save_aux_ptr_type+0xf4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_kfunc_call+0x7c8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_helper_call+0x23dc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_return_code+0x300: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_ld_imm+0x290: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: states_equal+0x83c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: regsafe+0x128: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: adjust_reg_min_max_vals+0x490: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: adjust_ptr_min_max_vals+0x1c0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: sanitize_err+0x98: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_field_type_name+0x50: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __check_mem_access+0xfc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: atomic_ptr_type_ok+0xc4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_ptr_alignment+0x74: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_map_direct_read+0x98: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_stack_read+0x5fc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_stack_write+0xa7c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_func_arg_reg_off+0x8c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_helper_mem_access+0xa4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: is_ptr_cast_function+0x4c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: check_map_func_compatibility+0x6b4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: may_update_sockmap+0xf8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: is_branch_taken+0x464: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: reg_set_min_max+0xa8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: try_match_pkt_pointers+0xac: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: regs_refine_cond_op+0x68: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: insn_def_regno+0x50: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_any_put+0x3c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_parse_param+0xa4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __bpf_dynptr_write+0xc0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_dynptr_data+0xb8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_base_func_proto+0x5cc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_obj_new_impl+0x124: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_dynptr_slice+0xa8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __bpf_dynptr_read+0xc0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __bpf_strtoull+0xa4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: dynptr_type_str+0x40: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_iter_attach_map+0xa8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: htab_map_alloc+0x4dc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: htab_map_free+0x9c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: htab_map_free_timers_and_wq+0xa8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: htab_map_mem_usage+0xe8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_percpu_hash_copy+0x210: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: prealloc_init+0x58: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: htab_map_hash+0x144: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __htab_map_lookup_and_delete_batch+0xaa0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __htab_map_lookup_and_delete_elem+0x574: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __bpf_hash_map_seq_show+0x244: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_percpu_array_copy+0x200: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __bpf_array_map_seq_show+0x224: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: hash+0x158: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: cgroup_storage_update_elem+0x1dc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_cgroup_storage_alloc+0x20c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: bpf_ringbuf_query+0x48: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: print_bpf_insn+0x8c: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_type_skip_modifiers+0xf4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_type_id_size+0x3a0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __btf_resolve_size.llvm.8933087693230904082+0xa4: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_parse_fields+0x4c0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_is_prog_ctx_type+0x2e8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_ctx_access+0xc34: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_struct_access+0x1c0: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_struct_walk+0xbc: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: __get_type_size+0x178: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_check_type_match+0x514: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_prepare_func_args+0x998: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_validate_prog_ctx_type+0x4c8: sibling call from callable instruction with modified stack frame
   vmlinux.o: warning: objtool: btf_is_dynptr_ptr+0xf4: sibling call from callable instruction with modified stack frame

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

