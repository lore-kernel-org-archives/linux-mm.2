Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D945ED116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD976B0024; Thu, 27 Nov 2025 23:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D9A6B0029; Thu, 27 Nov 2025 23:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D2F6B002A; Thu, 27 Nov 2025 23:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3E6E6B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:32:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D57CC0366
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:32:01 +0000 (UTC)
X-FDA: 84158743242.29.A5C4EF0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4AEDC0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:31:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jD80r9Le;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Pejq4Wq3xa5ZWnLgZhSBX/3Cknwl1ewas+40ie9s6LM=;
	b=e3+OP47ICK1ii0f9HFrPN364h3ZJ6gdvaSH6JngC8jFy4slyTpSOCf224RtCIvugtTt7Tg
	9BLwyo5a+JRtyUT/Al58c0QqyAUZJs+vM0ErXKmO9tzpB7ga/oqgnSn4xBdL19lgQxK1q4
	AYyOdLkWdXZURoObiFmYiMWBV2KtTfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764304319; a=rsa-sha256;
	cv=none;
	b=w7KnIePbSwG7e0LEQr3Z8s8QeimXTClCr6Zho2NFNDyfv9acHnKzZDZBFnyNNmBkGDw75l
	qw0ZpDErYfH3WPCcN0A1mbzRSVSsnhm9WFcVCE9KwKL6WDmVaZE6YZYSSsxLKnH7Qo9AF+
	3qAxSUJStk7/DTmFbNV/hm8os/P/Wp4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jD80r9Le;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764304319; x=1795840319;
  h=date:from:to:cc:subject:message-id;
  bh=IWoqr0yjY7EXmfUarQC2XFbOBAIONMQs3QWn8hIFZvw=;
  b=jD80r9LeRhTsAIZpe3kmf6SqAb3ao5W/5mulQn30mImLzjJp7kCK65XU
   RG120t055yWj9SdIuVVjz79e9VxKvuY4yTCnpFakU9tRboBDBR4saQoAo
   qYsYJRMM7d7VCVlTQlChREZ7I2oydczTDm3RPCfRQgERPpB45QzmCuq2z
   O7lz/0pXDcNjY6bJkfjkBd1rNzYoOrUaIU8slDgOvggdYLwuT3V8w9Zrf
   CB4iJH/FNzeoFjXONAmtr9cR37BNtIcvQ7uH+5iSyAHBnZxZs8ZpSDpxP
   a8uUFR334IZ9nPohokjDWIl5GiR6bGb8c6oSfUWLrrTXUlaIDQJMdcbtB
   Q==;
X-CSE-ConnectionGUID: OyTaf+qRSMio6pv1cds7Zg==
X-CSE-MsgGUID: U5DlsSt2SJSwwQngSfyutQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="76970562"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="76970562"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 20:31:57 -0800
X-CSE-ConnectionGUID: /YgKr9VoTHyz9MPFWbIkVg==
X-CSE-MsgGUID: bm04xxrTSQ6+sheGAOUm8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="216726952"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 27 Nov 2025 20:31:56 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOq9B-0000000062P-1dbA;
	Fri, 28 Nov 2025 04:31:53 +0000
Date: Fri, 28 Nov 2025 12:31:18 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 ef68bf704646690aba5e81c2f7be8d6ef13d7ad8
Message-ID: <202511281209.7WmTdk5W-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: kr7f7hhzgjpwaf6caok8pcc156uyu361
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4AEDC0005
X-HE-Tag: 1764304318-39480
X-HE-Meta: U2FsdGVkX18Hn45A+bagdxxpbJUoJEkKNGPJ974gc16LaG0Yffbg+LTNXppV82uuGe0Ha0RjZyG3yeaELdouP/gA5xZPsNpHIKFEhckvuV9QaMbzYA0FYYBmRmLvQ95m/k5ATAYVc0wl0fcUxjrW/6wl97ah0s7a3PBLBNnz2fK3pYHcluUajLoKDRZjWNIXG/K9/cWhZa6t1s3XZFK2ezd1EHV9IuS5V7CBcei6Ej6mkPMj13JuoWNX9Jl1ivV1JmxsSmGcy9WffLJQucOE8Ssv6HZ8spoUR7skXe2OL3FG+pvc6+APqa3ltSAbVH06jg+eNvpdxM0+hHr1aVxwwOreLfKL/oHh9gNs8CkqTixaU1/Kwb2/4Hbpw9h1nBv6I8XPR970enyvvsr/dxYk2IHSRxYUABtjDN8XPuzxoEyIV+sjTTLIl3Ap4RiBXqCiDaubOEO1lxbrg5UttQseequ5icNPdANMrb35Q351NfZZnlbcapT4HY58sHdbJk2o2Z+VQEqnq2jlpm/qMmBu+0xdNrrmjhWP59t+kSJd9jP1NaLA+YBTaLpjxhIkbIQ5Fde+mY7bmhmwV3qnp31W1cd8YwzCpzZqQbuZl/ZhV+ipsRLKJPN4EQ19Kw51I2v0D31WR63JaMAdkkqGXesMzNWN9FtJPNqnpNmXvtkOlXLS4ufmddmSL9SW/nepNcAj4RUiEmwXbg+kAy2XKjq09rDXcgVxKA01FcHSYwh5Lr8VG/g0+Sb0Iiry4/H8iMVQxqhjD8hCiAqf+6tCl1baHXWsUxVTHMIMfzbPqV2o2e8xO1sTC7nVyQVo4G0XIVrds1MPRCCX8rTtb01kw2pegs8HC9fksg8OF6QtrGl0eNZuFCRcu8DSJXC17KG87iUfGHrcxMOJIAUFqz6xa/NP0/iGhh8FEC4yzAU+aDY/i9PQQd9j1U6u9BsbprrFzOyFdawRNF15VMkKDphM8kB
 OKSr1xTE
 qNQZbb1ItcPj4yV5tDgt4mCQx/I0GcygQEzBbUno46un9NMrLWLfRUyoGcj5GgVs1u9KhCoBxtPRv45xqRcEEG70F2cRmq5jmyUVL1xr8ubtuOKZJ0mZg0yGJtbLOy+T4Vt6rUdzBSLGcODg+up8cTw2Z4q5uIcAW/JQ7G3RrM1tl3xk0csFsvfwRQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: ef68bf704646690aba5e81c2f7be8d6ef13d7ad8  Add linux-next specific files for 20251127

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202511271353.g6GYVUt6-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511280520.ML76oQvR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511280822.i2fveMpR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511281223.DDs12LiC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511280417.SqtqiPAw-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511280420.y9O4fyhX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511280515.nM9JstZ7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511280839.LVVxce0P-lkp@intel.com

    ERROR: modpost: "hid_add_device" [sound/soc/sdca/snd-soc-sdca.ko] undefined!
    ERROR: modpost: "hid_allocate_device" [sound/soc/sdca/snd-soc-sdca.ko] undefined!
    ERROR: modpost: "hid_destroy_device" [sound/soc/sdca/snd-soc-sdca.ko] undefined!
    ERROR: modpost: "hid_input_report" [sound/soc/sdca/snd-soc-sdca.ko] undefined!
    ERROR: modpost: "hid_parse_report" [sound/soc/sdca/snd-soc-sdca.ko] undefined!
    ld: include/linux/pinctrl/pinconf-generic.h:235:(.text+0x57ded5): undefined reference to `pinconf_generic_dt_node_to_map'
    ld: sound/soc/sdca/sdca_hid.c:114:(.text+0x41b3f4e): undefined reference to `hid_add_device'
    sound/soc/codecs/nau8325.c:430:13: warning: variable 'n2_max' is uninitialized when used here [-Wuninitialized]
    sound/soc/codecs/nau8325.c:431:11: warning: variable 'ratio_sel' is uninitialized when used here [-Wuninitialized]
    sound/soc/sdca/sdca_class.c:216:(.text+0x41b954a): undefined reference to `__devm_regmap_init_sdw'
    sound/soc/sdca/sdca_class.c:300:(.exit.text+0xb38c): undefined reference to `sdw_unregister_driver'
    sound/soc/sdca/sdca_class.c:300:(.init.text+0xcfc2e): undefined reference to `__sdw_register_driver'
    sound/soc/sdca/sdca_class.c:32:(.text+0x41b8e19): undefined reference to `sdw_slave_read_prop'
    sound/soc/sdca/sdca_hid.c:117:(.text.unlikely+0x400212): undefined reference to `hid_destroy_device'
    sound/soc/sdca/sdca_hid.c:160:(.text+0x41b4346): undefined reference to `hid_input_report'
    sound/soc/sdca/sdca_hid.c:37:(.text+0x41b3c34): undefined reference to `hid_parse_report'
    sound/soc/sdca/sdca_hid.c:95:(.text+0x41b3cb5): undefined reference to `hid_allocate_device'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_guc_submit.c:2256 guc_exec_queue_unpause_prepare() warn: iterator used outside loop: 'job'
    drivers/regulator/pf1550-regulator.c:399:8-33: WARNING: Threaded IRQ with no primary handler requested without IRQF_ONESHOT (unless it is nested IRQ)
    kernel/liveupdate/luo_file.c:558 luo_retrieve_file() warn: iterator used outside loop: 'luo_file'
    lib/tests/liveupdate.c:130 liveupdate_test_register() warn: passing zero to 'ERR_PTR'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- hexagon-randconfig-r064-20251128
|   `-- drivers-regulator-pf1550-regulator.c:WARNING:Threaded-IRQ-with-no-primary-handler-requested-without-IRQF_ONESHOT-(unless-it-is-nested-IRQ)
|-- i386-randconfig-006-20251128
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- i386-randconfig-053-20251128
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- i386-randconfig-141-20251127
|   `-- drivers-gpu-drm-xe-xe_guc_submit.c-guc_exec_queue_unpause_prepare()-warn:iterator-used-outside-loop:job
|-- loongarch-allmodconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- loongarch-allyesconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- riscv-allmodconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- riscv-allyesconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- um-allmodconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- x86_64-allmodconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- x86_64-allyesconfig
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- x86_64-buildonly-randconfig-002-20251128
|   `-- ld:include-linux-pinctrl-pinconf-generic.h:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- x86_64-randconfig-002-20251128
|   |-- ERROR:hid_add_device-sound-soc-sdca-snd-soc-sdca.ko-undefined
|   |-- ERROR:hid_allocate_device-sound-soc-sdca-snd-soc-sdca.ko-undefined
|   |-- ERROR:hid_destroy_device-sound-soc-sdca-snd-soc-sdca.ko-undefined
|   |-- ERROR:hid_input_report-sound-soc-sdca-snd-soc-sdca.ko-undefined
|   `-- ERROR:hid_parse_report-sound-soc-sdca-snd-soc-sdca.ko-undefined
|-- x86_64-randconfig-006-20251128
|   |-- ld:sound-soc-sdca-sdca_hid.c:(.text):undefined-reference-to-hid_add_device
|   |-- sound-soc-sdca-sdca_class.c:(.exit.text):undefined-reference-to-sdw_unregister_driver
|   |-- sound-soc-sdca-sdca_class.c:(.init.text):undefined-reference-to-__sdw_register_driver
|   |-- sound-soc-sdca-sdca_class.c:(.text):undefined-reference-to-__devm_regmap_init_sdw
|   |-- sound-soc-sdca-sdca_class.c:(.text):undefined-reference-to-sdw_slave_read_prop
|   |-- sound-soc-sdca-sdca_hid.c:(.text):undefined-reference-to-hid_allocate_device
|   |-- sound-soc-sdca-sdca_hid.c:(.text):undefined-reference-to-hid_input_report
|   |-- sound-soc-sdca-sdca_hid.c:(.text):undefined-reference-to-hid_parse_report
|   `-- sound-soc-sdca-sdca_hid.c:(.text.unlikely):undefined-reference-to-hid_destroy_device
|-- x86_64-randconfig-073-20251128
|   |-- sound-soc-codecs-nau8325.c:warning:variable-n2_max-is-uninitialized-when-used-here
|   `-- sound-soc-codecs-nau8325.c:warning:variable-ratio_sel-is-uninitialized-when-used-here
|-- x86_64-randconfig-161-20251127
|   |-- kernel-liveupdate-luo_core.c-luo_ioctl()-warn:unsigned-nr-is-never-less-than-zero.
|   |-- kernel-liveupdate-luo_file.c-luo_retrieve_file()-warn:iterator-used-outside-loop:luo_file
|   `-- lib-tests-liveupdate.c-liveupdate_test_register()-warn:passing-zero-to-ERR_PTR
`-- xtensa-randconfig-r072-20251127
    `-- fs-nfs-localio.c-nfs_local_call_write()-warn:inconsistent-indenting

elapsed time: 1475m

configs tested: 272
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251127    gcc-15.1.0
arc                   randconfig-001-20251128    gcc-8.5.0
arc                   randconfig-002-20251127    gcc-8.5.0
arc                   randconfig-002-20251128    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                         axm55xx_defconfig    clang-22
arm                                 defconfig    clang-22
arm                            mmp2_defconfig    gcc-15.1.0
arm                         mv78xx0_defconfig    clang-19
arm                   randconfig-001-20251127    clang-22
arm                   randconfig-001-20251128    gcc-8.5.0
arm                   randconfig-002-20251127    clang-22
arm                   randconfig-002-20251128    gcc-8.5.0
arm                   randconfig-003-20251127    clang-22
arm                   randconfig-003-20251128    gcc-8.5.0
arm                   randconfig-004-20251127    gcc-10.5.0
arm                   randconfig-004-20251128    gcc-8.5.0
arm64                            allmodconfig    clang-16
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251127    gcc-8.5.0
arm64                 randconfig-001-20251128    gcc-15.1.0
arm64                 randconfig-002-20251127    clang-22
arm64                 randconfig-002-20251128    gcc-15.1.0
arm64                 randconfig-003-20251127    gcc-9.5.0
arm64                 randconfig-003-20251128    gcc-15.1.0
arm64                 randconfig-004-20251127    gcc-14.3.0
arm64                 randconfig-004-20251128    gcc-15.1.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251127    gcc-15.1.0
csky                  randconfig-001-20251128    gcc-15.1.0
csky                  randconfig-002-20251127    gcc-15.1.0
csky                  randconfig-002-20251128    gcc-15.1.0
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251127    clang-22
hexagon               randconfig-001-20251128    clang-22
hexagon               randconfig-002-20251127    clang-18
hexagon               randconfig-002-20251128    clang-22
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20251127    clang-20
i386        buildonly-randconfig-001-20251128    gcc-13
i386        buildonly-randconfig-002-20251127    gcc-14
i386        buildonly-randconfig-002-20251128    gcc-13
i386        buildonly-randconfig-003-20251127    clang-20
i386        buildonly-randconfig-003-20251128    gcc-13
i386        buildonly-randconfig-004-20251127    gcc-14
i386        buildonly-randconfig-004-20251128    gcc-13
i386        buildonly-randconfig-005-20251127    clang-20
i386        buildonly-randconfig-005-20251128    gcc-13
i386        buildonly-randconfig-006-20251127    clang-20
i386        buildonly-randconfig-006-20251128    gcc-13
i386                                defconfig    clang-20
i386                  randconfig-001-20251127    gcc-14
i386                  randconfig-001-20251128    gcc-14
i386                  randconfig-002-20251127    gcc-14
i386                  randconfig-002-20251128    gcc-14
i386                  randconfig-003-20251127    clang-20
i386                  randconfig-003-20251128    gcc-14
i386                  randconfig-004-20251127    gcc-12
i386                  randconfig-004-20251128    gcc-14
i386                  randconfig-005-20251127    clang-20
i386                  randconfig-005-20251128    gcc-14
i386                  randconfig-006-20251127    clang-20
i386                  randconfig-006-20251128    gcc-14
i386                  randconfig-007-20251127    clang-20
i386                  randconfig-007-20251128    gcc-14
i386                  randconfig-011-20251127    gcc-13
i386                  randconfig-011-20251128    gcc-14
i386                  randconfig-012-20251127    gcc-14
i386                  randconfig-012-20251128    gcc-14
i386                  randconfig-013-20251127    clang-20
i386                  randconfig-013-20251128    gcc-14
i386                  randconfig-014-20251127    clang-20
i386                  randconfig-014-20251128    gcc-14
i386                  randconfig-015-20251127    gcc-14
i386                  randconfig-015-20251128    gcc-14
i386                  randconfig-016-20251127    clang-20
i386                  randconfig-016-20251128    gcc-14
i386                  randconfig-017-20251127    gcc-14
i386                  randconfig-017-20251128    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251127    clang-22
loongarch             randconfig-001-20251128    clang-22
loongarch             randconfig-002-20251127    gcc-15.1.0
loongarch             randconfig-002-20251128    clang-22
m68k                             allmodconfig    clang-19
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                          ath79_defconfig    gcc-15.1.0
mips                      loongson1_defconfig    clang-18
mips                          rb532_defconfig    clang-18
nios2                            allmodconfig    clang-22
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251127    gcc-8.5.0
nios2                 randconfig-001-20251128    clang-22
nios2                 randconfig-002-20251127    gcc-11.5.0
nios2                 randconfig-002-20251128    clang-22
openrisc                         allmodconfig    clang-22
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251127    gcc-8.5.0
parisc                randconfig-001-20251128    clang-22
parisc                randconfig-002-20251127    gcc-15.1.0
parisc                randconfig-002-20251128    clang-22
parisc64                            defconfig    gcc-15.1.0
powerpc                    adder875_defconfig    clang-18
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                      arches_defconfig    clang-18
powerpc                      pcm030_defconfig    clang-18
powerpc               randconfig-001-20251127    clang-22
powerpc               randconfig-001-20251128    clang-22
powerpc               randconfig-002-20251127    gcc-13.4.0
powerpc               randconfig-002-20251128    clang-22
powerpc                      tqm8xx_defconfig    clang-19
powerpc                        warp_defconfig    gcc-15.1.0
powerpc                         wii_defconfig    clang-18
powerpc64             randconfig-001-20251127    clang-20
powerpc64             randconfig-001-20251128    clang-22
powerpc64             randconfig-002-20251127    gcc-14.3.0
powerpc64             randconfig-002-20251128    clang-22
riscv                            allmodconfig    clang-16
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251127    gcc-12.5.0
riscv                 randconfig-001-20251128    gcc-15.1.0
riscv                 randconfig-002-20251127    clang-22
riscv                 randconfig-002-20251128    gcc-15.1.0
s390                             alldefconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251127    gcc-11.5.0
s390                  randconfig-001-20251128    gcc-15.1.0
s390                  randconfig-002-20251127    clang-22
s390                  randconfig-002-20251128    gcc-15.1.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251127    gcc-15.1.0
sh                    randconfig-001-20251128    gcc-15.1.0
sh                    randconfig-002-20251127    gcc-12.5.0
sh                    randconfig-002-20251128    gcc-15.1.0
sh                          sdk7780_defconfig    clang-18
sh                   secureedge5410_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251127    gcc-13.4.0
sparc                 randconfig-001-20251128    clang-22
sparc                 randconfig-002-20251127    gcc-11.5.0
sparc                 randconfig-002-20251128    clang-22
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251127    gcc-15.1.0
sparc64               randconfig-001-20251128    clang-22
sparc64               randconfig-002-20251127    clang-20
sparc64               randconfig-002-20251128    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251127    gcc-14
um                    randconfig-001-20251128    clang-22
um                    randconfig-002-20251127    clang-22
um                    randconfig-002-20251128    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251127    gcc-14
x86_64      buildonly-randconfig-001-20251128    clang-20
x86_64      buildonly-randconfig-002-20251127    clang-20
x86_64      buildonly-randconfig-002-20251128    clang-20
x86_64      buildonly-randconfig-003-20251127    clang-20
x86_64      buildonly-randconfig-003-20251128    clang-20
x86_64      buildonly-randconfig-004-20251127    clang-20
x86_64      buildonly-randconfig-004-20251128    clang-20
x86_64      buildonly-randconfig-005-20251127    clang-20
x86_64      buildonly-randconfig-005-20251128    clang-20
x86_64      buildonly-randconfig-006-20251127    clang-20
x86_64      buildonly-randconfig-006-20251128    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251127    clang-20
x86_64                randconfig-002-20251127    clang-20
x86_64                randconfig-003-20251127    gcc-14
x86_64                randconfig-004-20251127    gcc-14
x86_64                randconfig-005-20251127    gcc-14
x86_64                randconfig-006-20251127    clang-20
x86_64                randconfig-011-20251127    clang-20
x86_64                randconfig-012-20251127    gcc-14
x86_64                randconfig-013-20251127    gcc-14
x86_64                randconfig-014-20251127    gcc-14
x86_64                randconfig-071-20251127    gcc-12
x86_64                randconfig-071-20251128    gcc-14
x86_64                randconfig-072-20251127    gcc-14
x86_64                randconfig-072-20251128    gcc-14
x86_64                randconfig-073-20251127    clang-20
x86_64                randconfig-073-20251128    gcc-14
x86_64                randconfig-074-20251127    gcc-14
x86_64                randconfig-074-20251128    gcc-14
x86_64                randconfig-075-20251127    gcc-14
x86_64                randconfig-075-20251128    gcc-14
x86_64                randconfig-076-20251127    clang-20
x86_64                randconfig-076-20251128    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    clang-22
xtensa                randconfig-001-20251127    gcc-11.5.0
xtensa                randconfig-001-20251128    clang-22
xtensa                randconfig-002-20251127    gcc-10.5.0
xtensa                randconfig-002-20251128    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

