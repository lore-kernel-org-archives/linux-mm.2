Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3ECD37497
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301A76B02E8; Fri,  5 Dec 2025 15:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1BC6B02E9; Fri,  5 Dec 2025 15:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8406B02EA; Fri,  5 Dec 2025 15:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEFE6B02E8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:44:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A023458577
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:44:25 +0000 (UTC)
X-FDA: 84186595290.20.D8B8AF6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1363140012
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:44:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hMDf9XKE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764967463; a=rsa-sha256;
	cv=none;
	b=oi35biXwmuXKOigbF0y0FGlcc+crLwr0emxo2nlbap5/011FCHat9SrS6k+O1Lcxv5BY09
	kasA4Db9pIAJe+TxFDB53FPPhbqvxS6lV+UUjkoWAffNZdeCwELsg90JZtdCv6Qusb18eP
	sJyt2ihZ6+6HQeWlA2BclwV+JvZY874=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hMDf9XKE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764967463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CHeIBO8nQs3EU75fELoZtcW453PnQpQpBOKrwlgU79Y=;
	b=f6NZkIYof3eHs2xJSJwvSfoITlEHCBOztB0ST9Gqrvr5gLyn3BQrSP4JzznwZR88Cob1uX
	iC3zp+QnGJGndeBlx2ZcY+ep/22BKATHW8A5xrqfnhOYvdED6rJqS5raoXKD7f6s7sFlCi
	Mva15I9lFputyPnTNLxNkZg+YVypBNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764967463; x=1796503463;
  h=date:from:to:cc:subject:message-id;
  bh=uoRbJpstVoO08kRcWBGZu7ezZTc189W+YxkwEQ0KyUY=;
  b=hMDf9XKEvi4GoaCOhIcbagvMOaWSpnsnjKr3Ujs4h/dFdZl7v8kqxpqC
   qA31w3JQxPEObC8epDaKA2QSrmbFcTlwFi+pDdgkxnUBqCCLe04fjb8Hi
   U9mea2hQ30jTdAD35gqZHoavcv1TqO+GXcwRybLzrhYd/iEQDALM93ODV
   KmJ6XaTpLanYtaIuOqWVXg+Wb2IaIxNiXEa5iYlR1K+JktyVAe69wwDi9
   0v/hzUr8frYQdSXzHvq3jnAzOupphIZ+3iBk9dfD+ENMLrkvyNn+JWxJm
   ECbD5NYuJSDNSPzek8jCTaZnpnlldcWDGnmLPxUzfzdZfZ05BdoHCEU1N
   A==;
X-CSE-ConnectionGUID: 3ozOAHDYQFWxsY6l6SL4Uw==
X-CSE-MsgGUID: jQvUxTM2TdaqH8F3b4UBOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="70854422"
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="70854422"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 12:44:22 -0800
X-CSE-ConnectionGUID: AlYitR/fRzKNI6tqQ5H9iA==
X-CSE-MsgGUID: m7YnCU7WSmqWR/4TimXyMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="226037761"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 05 Dec 2025 12:44:20 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRcf3-00000000FXB-3sEy;
	Fri, 05 Dec 2025 20:44:17 +0000
Date: Sat, 06 Dec 2025 04:43:29 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 83c8f7b5e194eaf3fb268c513e23e23e892de8ed
Message-ID: <202512060423.7JmHo9SB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: me4ux3oa3e5ce7tgrfo7szqsdzpsjdsr
X-Rspam-User: 
X-Rspamd-Queue-Id: F1363140012
X-Rspamd-Server: rspam01
X-HE-Tag: 1764967462-463731
X-HE-Meta: U2FsdGVkX1+Q/DeFqw/eZLu50/tMS9qR/9rsVAQc7r9ZRHNf747EsK4H+7yiO/drGnOG2Iol7SDw6cH49MtAlD7gUcmk7CFOZOjbBiUxbj62nPFlY8B5p3vD8Y9pMMlju4SWtjIhy/8jyppyE+8HUM7MmtjH8BBxwCKe3pgio8iHSUv8tiOG29Nd3Omz7ztGZEmeT4HDHs+a3yZ/GfZrXhOJ3gUbdRgOMYEiyoToeVYLfjzXsaMq+4dxZNpaALZRo+D1TT13Sp3sqvbCtCy4GXPH/d/RwHADERjlaLB92s5G5ZusYrjbyoj9wUpnAtE7x2S7q67t4xtju5QlUF2DxA3j0Up21SfSzyrVz0AGPz5RGndnRoMg15DWyb+ztJeKGlfPrpVAsnOBAuIFuY6FS/1pWJwuIg25+EiETzTpz0yXMRz64cb9Js0wfSksb87dftS2avvJB5r4gC5aicXyEVFLIO4S2QQbC8IRkmQlWSMgFjkeAYYyVMhTszPyxQLjq1BFJv+i53bY7zSPVzFUNTEUaKFDMwRJW8sIXAlKxBD2U7nWK2FYgtknSQpqDlvaodpnbSMqPXzILFKLomEUrtosoC2+jyA8+MFp/Lz6I9Lt9A+q3vH94UZbcCSx/20e74uplZAYZg1ZtkdExSmMv+DM4SBT6sAV1HO59PnBVxcNRonHqQR1Aeylm3nxBMtB7oj4uL7olxYOfkwaNXUKUoJJUoxZiDLpm/e/rEatTfOudAlObrkh+1tOrH6+KjHzxDqnMNnv1L11Lr3Ja1mwyIcOGcOD/mqNYBsya+u16nD5cijFcKsQbkJLSxSQH1Gap7JdCou5TULeIJ7fz1+CJYb1eyW7gNtdLR/jHojiJW5TX1aLn5LjT5ACKzjbV4+twCVy+pfrCDszi7kFqM1m1SPOFghofFIwbTTEL1Zb89dzeZYh67AzYKYY5NIZ5X3BuS0mvJCmba9cnbcx0op
 xMW2SAtM
 l/G2csfANCwnoR3V2p6Sw2mobRBsaL+J+x//51P91JOKORuvDDJ6A0f0cfBZddMgDT4Zya8rVlLqVgsKWda6lhFS0JYURQzuu8VBvDuihlsO1pn3vdbSiqHuABg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 83c8f7b5e194eaf3fb268c513e23e23e892de8ed  mm/mm_init: Introduce a boot parameter for check_pages

elapsed time: 1456m

configs tested: 183
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              alldefconfig    gcc-15.1.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-22
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251205    gcc-13.4.0
arc                   randconfig-002-20251205    gcc-13.4.0
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                       aspeed_g4_defconfig    clang-20
arm                                 defconfig    gcc-15.1.0
arm                          gemini_defconfig    clang-20
arm                       imx_v4_v5_defconfig    clang-20
arm                   randconfig-001-20251205    gcc-13.4.0
arm                   randconfig-002-20251205    gcc-13.4.0
arm                   randconfig-003-20251205    gcc-13.4.0
arm                   randconfig-004-20251205    gcc-13.4.0
arm                        spear3xx_defconfig    gcc-15.1.0
arm                         vf610m4_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251205    clang-22
arm64                 randconfig-002-20251205    clang-22
arm64                 randconfig-003-20251205    clang-22
arm64                 randconfig-004-20251205    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251205    clang-22
csky                  randconfig-002-20251205    clang-22
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251205    clang-22
hexagon               randconfig-002-20251205    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251205    gcc-14
i386        buildonly-randconfig-002-20251205    gcc-14
i386        buildonly-randconfig-003-20251205    gcc-14
i386        buildonly-randconfig-004-20251205    gcc-14
i386        buildonly-randconfig-005-20251205    gcc-14
i386        buildonly-randconfig-006-20251205    gcc-14
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251205    clang-20
i386                  randconfig-002-20251205    clang-20
i386                  randconfig-003-20251205    clang-20
i386                  randconfig-004-20251205    clang-20
i386                  randconfig-005-20251205    clang-20
i386                  randconfig-006-20251205    clang-20
i386                  randconfig-007-20251205    clang-20
i386                  randconfig-011-20251205    clang-20
i386                  randconfig-012-20251205    clang-20
i386                  randconfig-013-20251205    clang-20
i386                  randconfig-014-20251205    clang-20
i386                  randconfig-015-20251205    clang-20
i386                  randconfig-016-20251205    clang-20
i386                  randconfig-017-20251205    clang-20
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251205    clang-22
loongarch             randconfig-002-20251205    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                           ci20_defconfig    clang-20
mips                         db1xxx_defconfig    clang-20
nios2                            allmodconfig    clang-22
nios2                             allnoconfig    clang-22
nios2                               defconfig    clang-19
nios2                 randconfig-001-20251205    clang-22
nios2                 randconfig-002-20251205    clang-22
openrisc                         allmodconfig    clang-22
openrisc                          allnoconfig    clang-22
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251205    clang-22
parisc                randconfig-002-20251205    clang-22
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                      arches_defconfig    clang-20
powerpc                    ge_imp3a_defconfig    gcc-15.1.0
powerpc                      katmai_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251205    clang-22
powerpc               randconfig-002-20251205    clang-22
powerpc64             randconfig-001-20251205    clang-22
powerpc64             randconfig-002-20251205    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251205    gcc-13.4.0
riscv                 randconfig-002-20251205    gcc-13.4.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251205    gcc-13.4.0
s390                  randconfig-002-20251205    gcc-13.4.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                        dreamcast_defconfig    clang-20
sh                    randconfig-001-20251205    gcc-13.4.0
sh                    randconfig-002-20251205    gcc-13.4.0
sh                           se7206_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251205    gcc-14
sparc                 randconfig-002-20251205    gcc-14
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251205    gcc-14
sparc64               randconfig-002-20251205    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251205    gcc-14
um                    randconfig-002-20251205    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251205    gcc-14
x86_64      buildonly-randconfig-002-20251205    gcc-14
x86_64      buildonly-randconfig-003-20251205    gcc-14
x86_64      buildonly-randconfig-004-20251205    gcc-14
x86_64      buildonly-randconfig-005-20251205    gcc-14
x86_64      buildonly-randconfig-006-20251205    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251205    clang-20
x86_64                randconfig-002-20251205    clang-20
x86_64                randconfig-003-20251205    clang-20
x86_64                randconfig-004-20251205    clang-20
x86_64                randconfig-005-20251205    clang-20
x86_64                randconfig-006-20251205    clang-20
x86_64                randconfig-011-20251205    clang-20
x86_64                randconfig-012-20251205    clang-20
x86_64                randconfig-013-20251205    clang-20
x86_64                randconfig-014-20251205    clang-20
x86_64                randconfig-015-20251205    clang-20
x86_64                randconfig-016-20251205    clang-20
x86_64                randconfig-071-20251205    gcc-14
x86_64                randconfig-072-20251205    gcc-14
x86_64                randconfig-073-20251205    gcc-14
x86_64                randconfig-074-20251205    gcc-14
x86_64                randconfig-075-20251205    gcc-14
x86_64                randconfig-076-20251205    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                           alldefconfig    clang-20
xtensa                            allnoconfig    clang-22
xtensa                           allyesconfig    clang-22
xtensa                randconfig-001-20251205    gcc-14
xtensa                randconfig-002-20251205    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

