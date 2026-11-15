Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D428606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j7YMoZFq
Received: by kanga.kvack.org (Postfix)
	id 70CAF6B00EF; Sat, 14 Nov 2026 19:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3D56B05B0; Sat, 14 Nov 2026 19:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3DA6B05B1; Sat, 14 Nov 2026 19:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2015A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:46:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74CEB1A04C9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:46:57 +0000 (UTC)
X-FDA: 85435513674.18.6108076
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E53340006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:46:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j7YMoZFq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794703615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3uprUB1h5DIU5Ngul5lkdyrCpBbTxrCzVcUaG4aZJaw=;
	b=nLhTxH+7anhxT0EJQclJKnAfRmQtqwxZB7jDWJnQj0YBCQ/pMMeuyiVNGBzWzicfbE0KpD
	nopDgTcXaWSBV7R2ZoOKURHzZ30jlciiR32JvpNUxaqV3GXQrPQE260wJJkM/FTR6XgvQY
	n14FZcj5vqLD9Gi+YsyKDmviZQHiIdc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j7YMoZFq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794703615;
	b=4zyzfQ/OaVUNErZ6/Y93Fv3gtWECnH7EZZ9uWvURe82aNC+FsbfmVHg6FYC8Y4WiWblV/q
	vnmba5R+xbp0TrYBQkqdG5o6P7+scdPrDcA2rHaB65IbgdFn4rlniP2NviWrtTZdREzGwX
	NIFjJEYfBHN2Z5tyXoquV4ngbKXLrSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794703615; x=1826239615;
  h=date:from:to:cc:subject:message-id;
  bh=8LH5I04qktnIHwma5jSULqntV2T1QKxJIY7qRp/36dE=;
  b=j7YMoZFqcvtgdYqHprEafzEBNVwa3l9eJ6vTNTtZR4cvvmlCjv5uHKft
   FkIcCc3pY1QP03fEHrWw+3AhlXB9Pv0QmDbubAYsMuHvH01xib5Zjnjb8
   xqJk9QpyvC0XR3vMYtkVRuR73H43mUOkybTRiMjegZf2mndgxslgM/YxN
   cFd1EKMyfCUYVM26QiBgLab2k0+++1y6ybmqjx6RL3oU4hvSpd4NNecMC
   qRuUh5H7bhFmo9VDXuS0fIXllMe6unu4nQbUdxzfTSXRBNdI1v+HDVV+4
   cUwCMo5uDceE2U7ZtwJPbzx0UQwMr6TVn/3oXDojwFSO9spOyupxxXiti
   Q==;
X-CSE-ConnectionGUID: r1xZVylBTnaeiBG/xjCIzQ==
X-CSE-MsgGUID: T5pvLZOMT7S5SHNdv/KLqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11966"; a="3507826"
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="3507826"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 16:46:54 -0800
X-CSE-ConnectionGUID: baFRVErQRSOP9YNWGr2CjA==
X-CSE-MsgGUID: 2KpqdwjhQCmVlH4pP60Guw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="9655165"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 14 Nov 2026 16:46:52 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSOOP-000000016EO-16Cz;
	Sun, 15 Nov 2026 00:46:49 +0000
Date: Sun, 15 Nov 2026 08:46:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 84abb955b1015477aa11a96e2f3ac1b938b77f48
Message-ID: <20261115084624.OkSIe5ZA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E53340006
X-Stat-Signature: mbwpcgnrm96871owjxa9e8yz97iqdea3
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794703614-997209
X-HE-Meta: U2FsdGVkX1/AsDsWfgeHjUn4oH3Aq2mm5GOFNDI29txOyRuGE3LkbqsnOjLBjNVI/AXFo1LJP4gj9goBB8p1MqEmpzvMCJhozzsJddlv13DT52nnoWDRa1WvBWzKIwMT90a291O2yx8N2RfFpcuVHErZrwXXWJ7VhNtHUdT2OtAwrtp0Losb4qJSWsxEhhL8MRQiKsPQuz4WkUUs5+H6fjcbfeUC6ea6QTF/0eUwyTP3qj2abjsj5VIVgx/qXVLthqiiVm+fMUkoduSfZhzO1KEoRbCjZEM0TUSkqtF/KdSgi9pPwKUGS+8lTkBj/7ko/iU8snSNDjYb1Q0V4BB2/hyH+LPyJJ8ml0JWqDJdU0Bf0sy5s+YRgTXh+EnyEsc1EOQw9Nq8xuvqepZ9QGeBGEq3rZp3mreetyM3tLpOMfURGKEMWM2mJJWELbr4SbAxrzhYBmivGiGBf/feXkpyrDXIJdKAA78iOK8GBg9o4YQSWSTV0pQxyH75NHTLQHSPGt5I9YnebevHI5lsaXxq66DyYe3CEFiMeMRgsKqtxz6HvAY3XnbPY4VGZAOT9Ufd2UUmjUcUSkwBO8UK182EuP17Dlspsjo3DcxoTpIn8NaWlGK0GmXRGRqZutwvlSA6Tms7WJBkYlIzL0hyuwpIYQeWrrojBp2fzhxPy4R+Y4+RJkb78HmPL+ocYIDoevomUAKERrr8J+UeEWvnuCOoQsPNTNbkQ5bOABQQmGKoEFPOvdeRPDcW7eA3n7Qv974HzsZYSwEQurmFk7CYAot8d+ArONQEmn+JzTWeBbSkCQ7yrUaGSfFdGPudiixFfLqLh2rXB6I7/tbRBvoyV681bkDjkxtY96eSgILFjpD5KsfrLGeiTDMhUWEhtUtik8st0Gbw1Nk6E4HPKlzjhRS9Rp5euJTr4g0PV/aD2eivaEgQDMDC26Yir06fJ7HjS30spPUcjQ3dORxpX6gp8HC
 R/j9edBv
 Q+wElIvqR4alwUaIBx6li7+woDyP0iNDmh+q9tJLrrhGXqDk39x4WhXF+lBbxNoHFfAO4y2PEPnW3fu/OaTeR4mMnu8iZ0ikey1xpdsnOlMb0Shd5X0ewQNZyK3niN6wntBWiMVmOOzRHzphwrLgEMSsI8gdCZ40WSY9PmGsohIFBxlySjCMYY8C3I8jpGsRB9gpggChKJgcQDCQGFMlwkB2805IVck05kdwO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 84abb955b1015477aa11a96e2f3ac1b938b77f48  Add linux-next specific files for 20261113

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611140423.DcT56YPN-lkp@intel.com

    arc-linux-ld: leds-asus-aura-scsi.c:(.init.text+0x8): undefined reference to `scsi_register_device_handler'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202611132300.Vj25JGD0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611140551.WyqUtpYj-lkp@intel.com

    drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c:259:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    lib/maple_tree.o: warning: objtool: mas_validate_child_slot+0x24c: unreachable instruction
    lib/maple_tree.o: warning: objtool: mas_validate_gaps+0x174: unreachable instruction
    lib/maple_tree.o: warning: objtool: mas_validate_limits+0x694: unreachable instruction
    lib/maple_tree.o: warning: objtool: mas_validate_parent_slot+0x2a8: unreachable instruction

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r2106-20261114
|   `-- arc-linux-ld:leds-asus-aura-scsi.c:(.init.text):undefined-reference-to-scsi_register_device_handler
|-- loongarch-randconfig-r2109-20261113
|   |-- lib-maple_tree.o:warning:objtool:mas_validate_child_slot:unreachable-instruction
|   |-- lib-maple_tree.o:warning:objtool:mas_validate_gaps:unreachable-instruction
|   |-- lib-maple_tree.o:warning:objtool:mas_validate_limits:unreachable-instruction
|   `-- lib-maple_tree.o:warning:objtool:mas_validate_parent_slot:unreachable-instruction
|-- loongarch-randconfig-r2303-20261113
|   `-- drivers-platform-asus-asus-wmi.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-val-got-restricted-__le32-usertype
`-- x86_64-dcg_x86_64_defconfig-func
    `-- drivers-net-wireless-broadcom-brcm80211-brcmfmac-feature.c:warning:the-frame-size-of-bytes-is-larger-than-bytes

elapsed time: 984m

configs tested: 499
configs skipped: 2

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261113    gcc-8.5.0
alpha                 randconfig-2000-20261114    gcc-12.5.0
alpha                 randconfig-2000-20261114    gcc-8.5.0
alpha                 randconfig-2001-20261113    gcc-8.5.0
alpha                 randconfig-2001-20261114    gcc-12.5.0
alpha                 randconfig-2001-20261114    gcc-9.5.0
alpha                 randconfig-2200-20261113    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261114    gcc-9.5.0  smatch
alpha                randconfig-r2100-20261114    gcc-15.3.0 cocci
alpha                randconfig-r2304-20261113    gcc-14.4.0 sparse
alpha                randconfig-r2308-20261114    gcc-8.5.0  sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261114    clang-24
arc                   randconfig-1000-20261115    gcc-11.5.0
arc                   randconfig-1001-20261114    clang-24
arc                   randconfig-1001-20261115    gcc-11.5.0
arc                   randconfig-2000-20261113    gcc-16.2.0
arc                   randconfig-2000-20261114    gcc-11.5.0
arc                   randconfig-2001-20261113    gcc-10.5.0
arc                   randconfig-2001-20261113    gcc-16.2.0
arc                   randconfig-2001-20261114    gcc-11.5.0
arc                   randconfig-2002-20261113    gcc-16.2.0
arc                   randconfig-2002-20261114    gcc-11.5.0
arc                   randconfig-2003-20261113    gcc-10.5.0
arc                   randconfig-2003-20261113    gcc-16.2.0
arc                   randconfig-2003-20261114    gcc-11.5.0
arc                   randconfig-2004-20261113    gcc-12.5.0
arc                   randconfig-2004-20261113    gcc-16.2.0
arc                   randconfig-2004-20261114    gcc-11.5.0
arc                   randconfig-2005-20261113    gcc-10.5.0
arc                   randconfig-2005-20261113    gcc-16.2.0
arc                   randconfig-2005-20261114    gcc-11.5.0
arc                   randconfig-2200-20261114    gcc-8.5.0  smatch
arc                  randconfig-r2100-20261113    gcc-8.5.0  cocci
arc                  randconfig-r2103-20261113    gcc-9.5.0  cocci
arc                  randconfig-r2107-20261114    clang-24   cocci
arc                  randconfig-r2311-20261113    gcc-16.2.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                           exynos_defconfig    clang-19
arm                            omap1_defconfig    clang-24
arm                   randconfig-1000-20261114    clang-24
arm                   randconfig-1000-20261115    gcc-11.5.0
arm                   randconfig-1001-20261114    clang-24
arm                   randconfig-1001-20261115    gcc-11.5.0
arm                   randconfig-1002-20261114    clang-24
arm                   randconfig-1002-20261115    gcc-11.5.0
arm                   randconfig-1003-20261114    clang-24
arm                   randconfig-1003-20261115    gcc-11.5.0
arm                   randconfig-2000-20261113    gcc-14.4.0
arm                   randconfig-2000-20261114    gcc-10.5.0
arm                   randconfig-2001-20261113    gcc-14.4.0
arm                   randconfig-2001-20261114    gcc-10.5.0
arm                   randconfig-2002-20261113    gcc-14.4.0
arm                   randconfig-2002-20261114    gcc-10.5.0
arm                   randconfig-2200-20261113    clang-24   smatch
arm                   randconfig-2200-20261114    clang-17   smatch
arm                  randconfig-r2101-20261114    gcc-15.3.0 cocci
arm                  randconfig-r2110-20261114    clang-24   cocci
arm                  randconfig-r2300-20261113    gcc-14.4.0 sparse
arm                  randconfig-r2311-20261114    gcc-8.5.0  sparse
arm                          s3c6400_defconfig    clang-19
arm                          socfpga_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1000-20261115    gcc-16.2.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261115    gcc-16.2.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261115    gcc-16.2.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261115    gcc-16.2.0
arm64                 randconfig-2000-20261113    gcc-14.4.0
arm64                 randconfig-2000-20261114    gcc-10.5.0
arm64                 randconfig-2001-20261113    gcc-14.4.0
arm64                 randconfig-2001-20261114    gcc-10.5.0
arm64                 randconfig-2002-20261113    gcc-14.4.0
arm64                 randconfig-2002-20261114    gcc-10.5.0
arm64                 randconfig-2200-20261113    gcc-8.5.0  smatch
arm64                 randconfig-2200-20261114    clang-17   smatch
arm64                randconfig-r2102-20261114    gcc-15.3.0 cocci
arm64                randconfig-r2303-20261113    gcc-14.4.0 sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    clang-24
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1000-20261115    gcc-16.2.0
csky                  randconfig-1001-20261114    gcc-16.2.0
csky                  randconfig-1001-20261115    gcc-16.2.0
csky                  randconfig-2000-20261114    gcc-16.2.0
csky                  randconfig-2001-20261114    gcc-16.2.0
csky                  randconfig-2200-20261114    gcc-16.2.0 smatch
csky                 randconfig-r2302-20261114    gcc-16.2.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1001-20261114    clang-24
hexagon               randconfig-2000-20261114    gcc-16.2.0
hexagon               randconfig-2001-20261114    gcc-16.2.0
hexagon               randconfig-2200-20261114    clang-24   smatch
hexagon              randconfig-r2102-20261114    clang-24   cocci
hexagon              randconfig-r2104-20261114    gcc-15.3.0 cocci
hexagon              randconfig-r2111-20261114    clang-17   cocci
hexagon              randconfig-r2306-20261113    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261114    gcc-14
i386        buildonly-randconfig-1001-20261114    gcc-14
i386        buildonly-randconfig-1002-20261114    gcc-14
i386        buildonly-randconfig-1003-20261114    gcc-14
i386        buildonly-randconfig-1004-20261114    gcc-14
i386        buildonly-randconfig-1005-20261114    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261114    gcc-12
i386                  randconfig-1001-20261114    gcc-12
i386                  randconfig-1002-20261114    gcc-12
i386                  randconfig-1003-20261114    gcc-12
i386                  randconfig-1004-20261114    gcc-12
i386                  randconfig-1005-20261114    gcc-12
i386                  randconfig-1006-20261114    gcc-12
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1007-20261115    gcc-14
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1008-20261115    gcc-14
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1009-20261115    gcc-14
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1010-20261115    gcc-14
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1011-20261115    gcc-14
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1012-20261115    gcc-14
i386                  randconfig-1013-20261114    clang-22
i386                  randconfig-1013-20261115    gcc-14
i386                  randconfig-2000-20261113    gcc-14
i386                  randconfig-2000-20261114    clang-22
i386                  randconfig-2001-20261113    gcc-12
i386                  randconfig-2001-20261114    clang-22
i386                  randconfig-2002-20261113    gcc-14
i386                  randconfig-2002-20261114    clang-22
i386                  randconfig-2003-20261113    gcc-14
i386                  randconfig-2003-20261114    clang-22
i386                  randconfig-2003-20261114    gcc-14
i386                  randconfig-2004-20261113    clang-22
i386                  randconfig-2004-20261114    clang-22
i386                  randconfig-2004-20261114    gcc-14
i386                  randconfig-2005-20261113    gcc-14
i386                  randconfig-2005-20261114    clang-22
i386                  randconfig-2005-20261114    gcc-14
i386                  randconfig-2100-20261113    clang-22   cocci
i386                  randconfig-2100-20261113    gcc-14     cocci
i386                  randconfig-2100-20261114    gcc-14     cocci
i386                  randconfig-2101-20261113    gcc-13     cocci
i386                  randconfig-2101-20261113    gcc-14     cocci
i386                  randconfig-2101-20261114    gcc-14     cocci
i386                  randconfig-2102-20261113    gcc-14     cocci
i386                  randconfig-2102-20261114    gcc-14     cocci
i386                  randconfig-2103-20261113    clang-22   cocci
i386                  randconfig-2103-20261113    gcc-14     cocci
i386                  randconfig-2103-20261114    gcc-14     cocci
i386                  randconfig-2104-20261113    gcc-14     cocci
i386                  randconfig-2104-20261114    gcc-14     cocci
i386                  randconfig-2105-20261113    clang-22   cocci
i386                  randconfig-2105-20261113    gcc-14     cocci
i386                  randconfig-2105-20261114    gcc-14     cocci
i386                  randconfig-2200-20261113    clang-22   smatch
i386                  randconfig-2200-20261114    gcc-14     smatch
i386                  randconfig-2300-20261114    clang-22   sparse
i386                  randconfig-2301-20261114    clang-22   sparse
i386                  randconfig-2302-20261114    clang-22   sparse
i386                 randconfig-r2106-20261114    clang-24   cocci
i386                 randconfig-r2111-20261114    clang-24   cocci
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1001-20261114    clang-24
loongarch             randconfig-2000-20261113    gcc-8.5.0
loongarch             randconfig-2000-20261114    clang-22
loongarch             randconfig-2000-20261114    gcc-11.5.0
loongarch             randconfig-2001-20261113    gcc-8.5.0
loongarch             randconfig-2001-20261114    clang-24
loongarch             randconfig-2001-20261114    gcc-11.5.0
loongarch             randconfig-2200-20261114    clang-18   smatch
loongarch            randconfig-r2105-20261113    gcc-16.2.0 cocci
loongarch            randconfig-r2109-20261114    clang-17   cocci
loongarch            randconfig-r2300-20261114    gcc-16.2.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    clang-24
m68k                       m54418evb_defconfig    clang-24
m68k                           multi_defconfig    clang-19
m68k                  randconfig-2000-20261113    gcc-8.5.0
m68k                  randconfig-2000-20261114    gcc-12.5.0
m68k                  randconfig-2000-20261114    gcc-8.5.0
m68k                  randconfig-2001-20261113    gcc-8.5.0
m68k                  randconfig-2001-20261114    gcc-12.5.0
m68k                  randconfig-2200-20261114    gcc-16.2.0 smatch
m68k                 randconfig-r2107-20261114    clang-17   cocci
m68k                 randconfig-r2110-20261114    clang-17   cocci
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261113    gcc-8.5.0
microblaze            randconfig-2000-20261114    gcc-12.5.0
microblaze            randconfig-2000-20261114    gcc-15.3.0
microblaze            randconfig-2001-20261113    gcc-8.5.0
microblaze            randconfig-2001-20261114    gcc-12.5.0
microblaze            randconfig-2001-20261114    gcc-9.5.0
microblaze            randconfig-2200-20261113    gcc-8.5.0  smatch
microblaze            randconfig-2200-20261114    gcc-9.5.0  smatch
microblaze           randconfig-r2109-20261114    clang-24   cocci
microblaze           randconfig-r2311-20261113    clang-24   sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                         bcm63xx_defconfig    clang-19
mips                            jazz_defconfig    clang-19
mips                            jazz_defconfig    clang-24
mips                         omega2p_defconfig    clang-24
mips                  randconfig-2000-20261113    clang-18
mips                  randconfig-2000-20261114    gcc-16.2.0
mips                  randconfig-2001-20261113    clang-22
mips                  randconfig-2001-20261114    gcc-16.2.0
mips                  randconfig-2002-20261113    gcc-14.4.0
mips                  randconfig-2002-20261114    gcc-16.2.0
mips                  randconfig-2200-20261113    clang-24   smatch
mips                  randconfig-2200-20261114    gcc-15.3.0 smatch
mips                 randconfig-r2106-20261114    clang-17   cocci
mips                 randconfig-r2108-20261114    clang-17   cocci
mips                 randconfig-r2301-20261114    gcc-16.2.0 sparse
mips                 randconfig-r2310-20261113    gcc-10.5.0 sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1001-20261114    clang-24
nios2                 randconfig-2000-20261113    gcc-8.5.0
nios2                 randconfig-2000-20261114    gcc-11.5.0
nios2                 randconfig-2001-20261113    gcc-8.5.0
nios2                 randconfig-2001-20261114    gcc-11.5.0
nios2                 randconfig-2200-20261113    gcc-10.5.0 smatch
nios2                 randconfig-2200-20261114    gcc-11.5.0 smatch
nios2                randconfig-r2307-20261113    clang-24   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc              randconfig-2000-20261113    gcc-16.2.0
openrisc              randconfig-2000-20261114    gcc-16.2.0
openrisc              randconfig-2001-20261113    gcc-14.4.0
openrisc              randconfig-2001-20261114    gcc-16.2.0
openrisc              randconfig-2002-20261113    gcc-16.2.0
openrisc              randconfig-2002-20261114    gcc-16.2.0
openrisc              randconfig-2200-20261113    gcc-14.4.0 smatch
openrisc              randconfig-2200-20261114    gcc-16.2.0 smatch
openrisc             randconfig-r2301-20261113    gcc-14.4.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                randconfig-2000-20261113    gcc-8.5.0
parisc                randconfig-2000-20261114    gcc-11.5.0
parisc                randconfig-2000-20261114    gcc-13.5.0
parisc                randconfig-2001-20261113    gcc-8.5.0
parisc                randconfig-2001-20261114    gcc-11.5.0
parisc                randconfig-2001-20261114    gcc-15.3.0
parisc                randconfig-2200-20261114    gcc-8.5.0  smatch
parisc               randconfig-r2103-20261114    gcc-15.3.0 cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                     gamecube_defconfig    clang-19
powerpc                     ge_imp3a_defconfig    clang-24
powerpc                    motionpro_defconfig    clang-24
powerpc                      mpc5200_defconfig    clang-24
powerpc                  mpc837x_rdb_defconfig    clang-24
powerpc                       pasemi_defconfig    clang-24
powerpc               randconfig-2000-20261113    clang-17
powerpc               randconfig-2000-20261114    gcc-8.5.0
powerpc               randconfig-2001-20261113    gcc-15.3.0
powerpc               randconfig-2001-20261114    gcc-8.5.0
powerpc               randconfig-2002-20261113    clang-18
powerpc               randconfig-2002-20261114    gcc-8.5.0
powerpc               randconfig-2200-20261113    clang-24   smatch
powerpc               randconfig-2200-20261114    clang-24   smatch
powerpc64             randconfig-2000-20261113    gcc-8.5.0
powerpc64             randconfig-2000-20261114    gcc-8.5.0
powerpc64             randconfig-2001-20261113    clang-24
powerpc64             randconfig-2001-20261114    gcc-8.5.0
powerpc64             randconfig-2002-20261113    gcc-15.3.0
powerpc64             randconfig-2002-20261114    gcc-8.5.0
powerpc64             randconfig-2200-20261114    clang-17   smatch
powerpc64            randconfig-r2101-20261113    gcc-8.5.0  cocci
powerpc64            randconfig-r2102-20261113    clang-24   cocci
powerpc64            randconfig-r2108-20261114    clang-24   cocci
powerpc64            randconfig-r2305-20261113    gcc-14.4.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                 randconfig-1000-20261114    gcc-15.3.0
riscv                 randconfig-1001-20261114    gcc-15.3.0
riscv                 randconfig-2000-20261113    gcc-11.5.0
riscv                 randconfig-2000-20261114    gcc-12.5.0
riscv                 randconfig-2001-20261113    gcc-11.5.0
riscv                 randconfig-2001-20261114    gcc-12.5.0
riscv                 randconfig-2002-20261113    gcc-11.5.0
riscv                 randconfig-2002-20261114    gcc-12.5.0
riscv                 randconfig-2003-20261113    gcc-11.5.0
riscv                 randconfig-2003-20261114    gcc-12.5.0
riscv                 randconfig-2004-20261113    gcc-11.5.0
riscv                 randconfig-2004-20261114    gcc-12.5.0
riscv                 randconfig-2005-20261113    gcc-11.5.0
riscv                 randconfig-2005-20261114    gcc-12.5.0
riscv                 randconfig-2200-20261114    clang-24   smatch
riscv                randconfig-r2310-20261113    clang-24   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261114    gcc-15.3.0
s390                  randconfig-1001-20261114    gcc-15.3.0
s390                  randconfig-2000-20261113    gcc-11.5.0
s390                  randconfig-2000-20261113    gcc-13.5.0
s390                  randconfig-2000-20261114    clang-21
s390                  randconfig-2000-20261114    clang-24
s390                  randconfig-2001-20261113    clang-18
s390                  randconfig-2001-20261113    gcc-11.5.0
s390                  randconfig-2001-20261114    clang-24
s390                  randconfig-2002-20261113    gcc-11.5.0
s390                  randconfig-2002-20261113    gcc-13.5.0
s390                  randconfig-2002-20261114    clang-24
s390                  randconfig-2003-20261113    gcc-11.5.0
s390                  randconfig-2003-20261113    gcc-8.5.0
s390                  randconfig-2003-20261114    clang-24
s390                  randconfig-2003-20261114    gcc-12.5.0
s390                  randconfig-2004-20261113    clang-24
s390                  randconfig-2004-20261113    gcc-11.5.0
s390                  randconfig-2004-20261114    clang-17
s390                  randconfig-2004-20261114    clang-24
s390                  randconfig-2005-20261113    gcc-11.5.0
s390                  randconfig-2005-20261114    clang-24
s390                  randconfig-2200-20261114    clang-24   smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          ap325rxa_defconfig    clang-24
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    clang-24
sh                             hp6xx_defconfig    clang-19
sh                    randconfig-1000-20261114    gcc-15.3.0
sh                    randconfig-1001-20261114    gcc-15.3.0
sh                    randconfig-2000-20261114    gcc-13.5.0
sh                    randconfig-2000-20261114    gcc-16.2.0
sh                    randconfig-2001-20261114    gcc-13.5.0
sh                    randconfig-2001-20261114    gcc-16.2.0
sh                    randconfig-2002-20261114    gcc-13.5.0
sh                    randconfig-2002-20261114    gcc-16.2.0
sh                    randconfig-2003-20261114    gcc-13.5.0
sh                    randconfig-2003-20261114    gcc-16.2.0
sh                    randconfig-2004-20261114    gcc-11.5.0
sh                    randconfig-2004-20261114    gcc-13.5.0
sh                    randconfig-2005-20261114    gcc-13.5.0
sh                    randconfig-2200-20261113    gcc-14.4.0 smatch
sh                    randconfig-2200-20261114    gcc-9.5.0  smatch
sh                   randconfig-r2103-20261114    gcc-13.5.0 cocci
sh                   randconfig-r2104-20261114    gcc-15.3.0 cocci
sh                   randconfig-r2105-20261114    gcc-9.5.0  cocci
sh                   randconfig-r2303-20261114    gcc-16.2.0 sparse
sh                   randconfig-r2307-20261114    gcc-8.5.0  sparse
sh                           sdk7786_defconfig    clang-19
sh                            se7343_defconfig    clang-24
sh                            se7751_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc                 randconfig-2000-20261114    clang-21
sparc                 randconfig-2000-20261114    gcc-11.5.0
sparc                 randconfig-2001-20261114    clang-21
sparc                 randconfig-2001-20261114    gcc-13.5.0
sparc                 randconfig-2200-20261113    gcc-14.4.0 smatch
sparc                 randconfig-2200-20261114    gcc-8.5.0  smatch
sparc                randconfig-r2100-20261114    gcc-11.5.0 cocci
sparc                randconfig-r2304-20261114    gcc-16.2.0 sparse
sparc                randconfig-r2309-20261114    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
sparc64               randconfig-2000-20261114    clang-21
sparc64               randconfig-2000-20261114    clang-24
sparc64               randconfig-2001-20261114    clang-21
sparc64               randconfig-2001-20261114    gcc-8.5.0
sparc64              randconfig-r2308-20261113    clang-24   sparse
sparc64              randconfig-r2308-20261113    gcc-8.5.0  sparse
sparc64              randconfig-r2309-20261113    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                    randconfig-2000-20261114    clang-21
um                    randconfig-2000-20261114    clang-24
um                    randconfig-2001-20261114    clang-21
um                    randconfig-2200-20261113    clang-24   smatch
um                    randconfig-2200-20261114    gcc-14     smatch
um                   randconfig-r2306-20261113    gcc-14     sparse
um                   randconfig-r2309-20261113    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261114    gcc-14
x86_64      buildonly-randconfig-1001-20261114    gcc-14
x86_64      buildonly-randconfig-1002-20261114    gcc-14
x86_64      buildonly-randconfig-1003-20261114    gcc-14
x86_64      buildonly-randconfig-1004-20261114    gcc-14
x86_64      buildonly-randconfig-1005-20261114    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1000-20261115    gcc-14
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1001-20261115    gcc-14
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1002-20261115    gcc-14
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1003-20261115    gcc-14
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1004-20261115    gcc-14
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1005-20261115    gcc-14
x86_64                randconfig-1012-20261115    gcc-14
x86_64                randconfig-1013-20261115    gcc-14
x86_64                randconfig-1014-20261115    gcc-14
x86_64                randconfig-1015-20261115    gcc-14
x86_64                randconfig-1016-20261115    gcc-14
x86_64                randconfig-1017-20261115    gcc-14
x86_64                randconfig-2000-20261114    gcc-14
x86_64                randconfig-2001-20261114    gcc-14
x86_64                randconfig-2002-20261114    gcc-14
x86_64                randconfig-2003-20261114    gcc-14
x86_64                randconfig-2004-20261114    gcc-14
x86_64                randconfig-2005-20261114    gcc-14
x86_64                randconfig-2100-20261114    gcc-14     cocci
x86_64                randconfig-2101-20261114    gcc-12     cocci
x86_64                randconfig-2101-20261114    gcc-14     cocci
x86_64                randconfig-2102-20261114    clang-22   cocci
x86_64                randconfig-2102-20261114    gcc-14     cocci
x86_64                randconfig-2103-20261114    clang-22   cocci
x86_64                randconfig-2103-20261114    gcc-14     cocci
x86_64                randconfig-2104-20261114    gcc-14     cocci
x86_64                randconfig-2105-20261114    gcc-14     cocci
x86_64                randconfig-2200-20261113    clang-22   smatch
x86_64                randconfig-2200-20261114    gcc-14     smatch
x86_64                randconfig-2300-20261114    clang-22   sparse
x86_64                randconfig-2301-20261114    clang-22   sparse
x86_64                randconfig-2302-20261114    clang-22   sparse
x86_64               randconfig-r2101-20261114    clang-22   cocci
x86_64               randconfig-r2105-20261114    gcc-15.3.0 cocci
x86_64               randconfig-r2306-20261114    gcc-8.5.0  sparse
x86_64               randconfig-r2310-20261114    gcc-8.5.0  sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0
xtensa                randconfig-2000-20261114    gcc-16.2.0
xtensa                randconfig-2001-20261114    gcc-16.2.0
xtensa                randconfig-2200-20261113    gcc-12.5.0 smatch
xtensa               randconfig-r2104-20261113    gcc-8.5.0  cocci
xtensa               randconfig-r2302-20261113    gcc-14.4.0 sparse
xtensa               randconfig-r2305-20261114    gcc-16.2.0 sparse
xtensa               randconfig-r2307-20261113    gcc-11.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

