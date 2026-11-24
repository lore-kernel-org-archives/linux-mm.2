Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8173E606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mTJM0zfX
Received: by kanga.kvack.org (Postfix)
	id A32D26B072B; Tue, 24 Nov 2026 09:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3ED6B072D; Tue, 24 Nov 2026 09:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D30A6B072E; Tue, 24 Nov 2026 09:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61C326B072B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:24:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0C0FA0C68
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:23:59 +0000 (UTC)
X-FDA: 85470231798.23.4DED0FE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5756A000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:23:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mTJM0zfX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795530238;
	b=2fObW0E6Rd9wPwXiyD2su38zHeFHsWjOBQA40he+h86ls+lwKac6p2+KDsw2tIEhXnZmOw
	Gv+nsCV7zKyIpCV7ePGXBxV0vwqUNyimr3m1DNCZ52DZHbpkhzmz3eJKW6txU6mXyxIFkY
	K95k9cXxFSK8eob8Dyd4/xbBbKZOywc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795530238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WjFKwnRv9dA3gO2hK2vM2vi+SBxayF7oDi6Ic6VSKV4=;
	b=Np7V+1DBoSE0Fb6QO5LKT4UmV0Z4Ag5aOsjwy02W2xUVNOokxBFTEaDCjSnwBCXPIv93DT
	CWyJdzf468iO9ldRiAD4NfoWbNMpXrYY6OorNXymv046JIOoRprFm+zPWrhEYQqJQKnebU
	7gsMBhddOJJs2fb4C9+Vhtaxic9+sw4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mTJM0zfX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795530237; x=1827066237;
  h=date:from:to:cc:subject:message-id;
  bh=68PDM57s6Z2iX1ZLnvMDXS9N73Dx57kncNuJZslG5N4=;
  b=mTJM0zfXWn9DEfSi7nONJE/0Hy9Nj+xWqqx3JIf4Pp+uq53vrEC8F5WE
   3egGLdI7s8vDNdu95WNCvzjqeIPpv3v3JkUoNoWAUZaIfjR89tTnOoo3r
   ePGVjlU0CbQsuEvHhlVbXHc5+JqSZZpBCposLThoCNj4Ql6LVw34DqMky
   gL7A2KAHX7Yl7Y/khSVp0cfiQDa0sk8z0u5ZLaRaJjN/ZYPXILzAQDgz4
   3fWlyU0Vq/iBIRYoyEkz2qa1T5Z+6AEKdwb+B7+Tusg5GgPtzd62P4y/+
   43aiaHljQ2xmC0Do4fbDhNcLfiGDGAeBldZqKsFowAmpHKercq4bn4nHX
   g==;
X-CSE-ConnectionGUID: fVcAVwo1QKmef7YnTRX3Jg==
X-CSE-MsgGUID: wCyfmVNhRb+IOnrH+JiREg==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4390627"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4390627"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 06:19:46 -0800
X-CSE-ConnectionGUID: daZUpnQ/SxqVz2ELiybvrg==
X-CSE-MsgGUID: VITMU7FgQqCiy7j8SMA+4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11570302"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Nov 2026 06:19:44 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVrMz-00000001PSk-42hU;
	Tue, 24 Nov 2026 14:19:41 +0000
Date: Tue, 24 Nov 2026 22:19:02 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
Message-ID: <20261124221902.KmPzJeuy-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: B5756A000A
X-Stat-Signature: mobcgotpygiadyd661y55q3gi4t4ttag
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795530236-634926
X-HE-Meta: U2FsdGVkX18kDpPK7qN0xW4AsELXdpTX8P+6IEWgEYuCecWdxB232QH0WRgCb9NtHiApAc2jdJISzoSlH+4OKgMNyOZLK9raBljBmXiEWXgjcYNWdL3AzIa4uwkTYofCnqdQQnRJXpQ7uryr6S3W6Y7nsaQMC5wQRoHzGsclrQ92vDFW8EIPLQ9MLlJIgOi2r9mibCwes+XEfNCrYbK94naoIAiv1FqRMhb8Hsw6OeUo4PayUVDIDZwxsiEsFM6hWn0Dyuro6op8GABKcuBSQVqeGxDpT4yc+qjY88aguh8H4FBunfOkGcX2AmZaLmeEM1h4nUjqBnVzwUTFDvNtukib3OzjDaGXZiKtIj3I9HOraLTAU970XRuA4SE/TjPa+5lkhkHj6IarOn5Wl+8R/d3rBMWRKmwwINf2aF/s1BQHxbNrkFY3IX0ceKtCenKlNEF//JXdbsMyEjTAYmIc4kuM4u+hg2dTBOYB2nK8HcUCPY5A57rnu0K5wOkdZpkl1n45KjPwoQRy9RwxufZMFklGao1OiVqWqEOHD8DCaxN1I2uP1Hzm+opwI6mZnHPhazQG/nbflyyvV4ZrqRDQvLU+WarqcfJ0biwPHYaiMtlThpq4EDzPgGq4gaB5iJMyxYIU+81ufcJ1L5LTdqQLEpMqr3Eko28u+HXzEl/OoHCT6A4wzkdYFoyMEwzoxqO+HqLRFZvbewItQYCTxg0qkERHEJf+7rdNbThwB19d3prRj00NNMJOqY/hba96gA3kIUIEiUgQMzjTMTRo6f+9fdnrcL6NLtrzHhu9CuIFTuura8AztKYaIK444sP7kwVx2X7rRK+/Ogf773CdwZelKJVP2RuQmleGXNNG5q5ykHInEdAfWfGw4BvFMH5lFJiAoneeaIH/xF2FCYhGz1iQeRVmLv10BdhuNo1DvMlcef0LpKYTeSP72AG7yKg5v7mkXwYq4jAokiAmZXhzIEM
 pkeRBZJj
 gpBFqt2IgeSjX0TYZxI1YT1RE8M8ewJ6aFTpXqesH5mqAl2NX1grGEs6abd2395c7Vn5ri8PSwLwP8Bo29uPflcykv1s6jBQ15fUbyT65bdw6lwqNl8RrdFHZs0MegwKrCPd/g1YvJSiaN9lKOihsNcdsdsDG5TnBOKFqcXQ70r7Mc8lhyLtRxxMukJCAnaabRyfMXQqgk/orhL9Ko4gOH/DkFnaLVXKZ/5bviLXhGWTlGPYSS2QR5jLsOZk4Cgsf363hiZTw75Q5tYfZLmwOPnCsrU/wSUlBtcLKHqpbwhHmKtD4hOYQi6kgJOzddYXRZ4eaJSVAtIVMKqdr85BhQzjW4o+r6YqpLC89yWrKb0S6brLPxPRqQIIuo7EJlX/cGCxbEZ3vW3r+VRL+qs8x2MSNdebsUBSEwA09vnWpdeL0K3rkamUYoGbqVwDynFZhkKUv0muUKZy8m6BlwJPVCFvAE4S6SUdwVyBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5  Add linux-next specific files for 20261123

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/phy/qualcomm/phy-qcom-uniphy-pcie-28lp.c:47:2: error: expected identifier

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- arm64-randconfig-1003-20261124
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- hexagon-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- loongarch-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- riscv-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- s390-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
|-- sparc64-allmodconfig
|   `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier
`-- um-allmodconfig
    `-- drivers-phy-qualcomm-phy-qcom-uniphy-pcie-28lp.c:error:expected-identifier

elapsed time: 1200m

configs tested: 422
configs skipped: 3

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261123    gcc-14.4.0
alpha                 randconfig-2001-20261123    gcc-8.5.0
alpha                 randconfig-2200-20261123    gcc-12.5.0 smatch
alpha                randconfig-r2101-20261123    gcc-12.5.0 cocci
alpha                randconfig-r2106-20261123    gcc-14.4.0 cocci
alpha                randconfig-r2302-20261124    gcc-15.3.0 sparse
alpha                randconfig-r2308-20261124    gcc-15.3.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                         nsim_700_defconfig    clang-24
arc                   randconfig-2000-20261123    gcc-14.4.0
arc                   randconfig-2001-20261123    gcc-12.5.0
arc                   randconfig-2002-20261123    gcc-8.5.0
arc                   randconfig-2003-20261123    gcc-12.5.0
arc                   randconfig-2004-20261123    gcc-14.4.0
arc                   randconfig-2005-20261123    gcc-12.5.0
arc                   randconfig-2200-20261123    gcc-12.5.0 smatch
arc                   randconfig-2200-20261124    gcc-8.5.0  smatch
arc                  randconfig-r2102-20261123    gcc-8.5.0  cocci
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                           ep93xx_defconfig    clang-24
arm                       footbridge_defconfig    clang-24
arm                           ixp4xx_defconfig    clang-17
arm                             mmp2_defconfig    clang-19
arm                              mxs_defconfig    clang-17
arm                            omap1_defconfig    clang-17
arm                   randconfig-2000-20261123    gcc-16.2.0
arm                   randconfig-2000-20261124    gcc-8.5.0
arm                   randconfig-2001-20261123    gcc-8.5.0
arm                   randconfig-2001-20261124    clang-17
arm                   randconfig-2002-20261123    clang-20
arm                   randconfig-2002-20261124    clang-24
arm                   randconfig-2200-20261123    gcc-8.5.0  smatch
arm                  randconfig-r2110-20261124    clang-24   cocci
arm                          s5pv210_defconfig    clang-17
arm                          s5pv210_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261124    gcc-8.5.0
arm64                 randconfig-1001-20261124    gcc-8.5.0
arm64                 randconfig-1002-20261124    gcc-8.5.0
arm64                 randconfig-1003-20261124    gcc-8.5.0
arm64                 randconfig-2000-20261123    clang-24
arm64                 randconfig-2000-20261124    clang-24
arm64                 randconfig-2001-20261123    gcc-8.5.0
arm64                 randconfig-2001-20261124    gcc-8.5.0
arm64                 randconfig-2002-20261123    clang-24
arm64                 randconfig-2002-20261124    clang-24
arm64                 randconfig-2200-20261123    clang-17   smatch
arm64                 randconfig-2200-20261124    gcc-16.2.0 smatch
arm64                randconfig-r2100-20261123    gcc-9.5.0  cocci
arm64                randconfig-r2306-20261124    clang-24   sparse
arm64                randconfig-r2307-20261123    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261124    gcc-8.5.0
csky                  randconfig-1001-20261124    gcc-8.5.0
csky                  randconfig-2000-20261123    gcc-14.4.0
csky                  randconfig-2000-20261124    gcc-9.5.0
csky                  randconfig-2001-20261123    gcc-12.5.0
csky                  randconfig-2001-20261124    gcc-16.2.0
csky                  randconfig-2200-20261123    gcc-16.2.0 smatch
csky                  randconfig-2200-20261124    gcc-15.3.0 smatch
csky                 randconfig-r2303-20261123    gcc-15.3.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261124    gcc-10.5.0
hexagon               randconfig-1001-20261124    gcc-10.5.0
hexagon               randconfig-2000-20261123    clang-18
hexagon               randconfig-2000-20261124    clang-17
hexagon               randconfig-2001-20261123    clang-24
hexagon               randconfig-2001-20261124    clang-17
hexagon               randconfig-2200-20261123    clang-24   smatch
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261124    gcc-12
i386        buildonly-randconfig-1001-20261124    gcc-12
i386        buildonly-randconfig-1002-20261124    gcc-12
i386        buildonly-randconfig-1003-20261124    gcc-12
i386        buildonly-randconfig-1004-20261124    gcc-12
i386        buildonly-randconfig-1005-20261124    gcc-12
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261124    gcc-14
i386                  randconfig-1001-20261124    gcc-14
i386                  randconfig-1002-20261124    gcc-14
i386                  randconfig-1003-20261124    gcc-14
i386                  randconfig-1004-20261124    gcc-14
i386                  randconfig-1005-20261124    gcc-14
i386                  randconfig-1006-20261124    gcc-14
i386                  randconfig-2000-20261123    clang-22
i386                  randconfig-2000-20261124    clang-22
i386                  randconfig-2001-20261123    clang-22
i386                  randconfig-2001-20261124    clang-22
i386                  randconfig-2002-20261123    gcc-14
i386                  randconfig-2002-20261124    gcc-14
i386                  randconfig-2003-20261123    clang-22
i386                  randconfig-2003-20261124    clang-22
i386                  randconfig-2004-20261123    gcc-14
i386                  randconfig-2004-20261124    gcc-14
i386                  randconfig-2005-20261123    gcc-12
i386                  randconfig-2005-20261124    gcc-14
i386                  randconfig-2100-20261123    clang-22   cocci
i386                  randconfig-2101-20261123    clang-22   cocci
i386                  randconfig-2102-20261123    clang-22   cocci
i386                  randconfig-2103-20261123    gcc-14     cocci
i386                  randconfig-2104-20261123    clang-22   cocci
i386                  randconfig-2105-20261123    gcc-14     cocci
i386                  randconfig-2200-20261123    gcc-14     smatch
i386                  randconfig-2200-20261124    clang-22   smatch
i386                  randconfig-2300-20261123    gcc-13     sparse
i386                  randconfig-2301-20261123    clang-22   sparse
i386                  randconfig-2302-20261123    clang-22   sparse
i386                 randconfig-r2103-20261123    gcc-12     cocci
i386                 randconfig-r2305-20261124    clang-22   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261124    gcc-10.5.0
loongarch             randconfig-1001-20261124    gcc-10.5.0
loongarch             randconfig-2000-20261123    gcc-16.2.0
loongarch             randconfig-2000-20261124    clang-18
loongarch             randconfig-2001-20261123    clang-22
loongarch             randconfig-2001-20261124    gcc-12.5.0
loongarch             randconfig-2200-20261123    clang-24   smatch
loongarch             randconfig-2200-20261124    gcc-16.2.0 smatch
loongarch            randconfig-r2300-20261123    clang-18   sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                           atari_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                         m5307c3_defconfig    clang-17
m68k                       m54418evb_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261123    gcc-15.3.0
m68k                  randconfig-2001-20261123    gcc-9.5.0
m68k                  randconfig-2200-20261123    gcc-8.5.0  smatch
m68k                  randconfig-2200-20261124    gcc-10.5.0 smatch
m68k                 randconfig-r2105-20261123    gcc-12.5.0 cocci
m68k                 randconfig-r2108-20261124    gcc-13.5.0 cocci
m68k                 randconfig-r2301-20261124    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261123    gcc-8.5.0
microblaze            randconfig-2001-20261123    gcc-16.2.0
microblaze            randconfig-2200-20261123    gcc-16.2.0 smatch
microblaze            randconfig-2200-20261124    gcc-8.5.0  smatch
microblaze           randconfig-r2303-20261124    gcc-8.5.0  sparse
microblaze           randconfig-r2307-20261124    gcc-9.5.0  sparse
microblaze           randconfig-r2309-20261124    gcc-9.5.0  sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           eyeq6_defconfig    clang-17
mips                            ip22_defconfig    clang-19
mips                     maltaup_xpa_defconfig    gcc-16.2.0
mips                       pic32mzda_defconfig    clang-24
mips                  randconfig-2000-20261123    gcc-8.5.0
mips                  randconfig-2000-20261124    clang-20
mips                  randconfig-2001-20261123    gcc-10.5.0
mips                  randconfig-2001-20261124    clang-20
mips                  randconfig-2002-20261123    gcc-16.2.0
mips                  randconfig-2002-20261124    clang-24
mips                  randconfig-2200-20261123    gcc-14.4.0 smatch
mips                  randconfig-2200-20261124    clang-20   smatch
mips                 randconfig-r2100-20261123    gcc-13.5.0 cocci
mips                 randconfig-r2107-20261124    clang-24   cocci
mips                 randconfig-r2108-20261123    clang-24   cocci
mips                 randconfig-r2109-20261124    gcc-8.5.0  cocci
mips                 randconfig-r2305-20261123    gcc-9.5.0  sparse
mips                            xway_defconfig    clang-19
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261124    gcc-10.5.0
nios2                 randconfig-1001-20261124    gcc-10.5.0
nios2                 randconfig-2000-20261123    gcc-8.5.0
nios2                 randconfig-2000-20261124    gcc-11.5.0
nios2                 randconfig-2001-20261123    gcc-11.5.0
nios2                 randconfig-2001-20261124    gcc-11.5.0
nios2                 randconfig-2200-20261123    gcc-8.5.0  smatch
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261123    gcc-10.5.0
openrisc              randconfig-2000-20261124    gcc-16.2.0
openrisc              randconfig-2001-20261123    gcc-16.2.0
openrisc              randconfig-2001-20261124    gcc-11.5.0
openrisc              randconfig-2002-20261123    gcc-10.5.0
openrisc              randconfig-2002-20261124    gcc-16.2.0
openrisc              randconfig-2200-20261123    gcc-12.5.0 smatch
openrisc              randconfig-2200-20261124    gcc-11.5.0 smatch
openrisc             randconfig-r2101-20261123    gcc-15.3.0 cocci
openrisc             randconfig-r2107-20261123    gcc-16.2.0 cocci
openrisc             randconfig-r2300-20261124    gcc-12.5.0 sparse
openrisc             randconfig-r2301-20261123    gcc-13.5.0 sparse
openrisc             randconfig-r2304-20261123    gcc-15.3.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-2000-20261123    gcc-8.5.0
parisc                randconfig-2000-20261124    gcc-8.5.0
parisc                randconfig-2001-20261123    gcc-10.5.0
parisc                randconfig-2001-20261124    gcc-8.5.0
parisc                randconfig-2200-20261123    gcc-14.4.0 smatch
parisc                randconfig-2200-20261124    gcc-9.5.0  smatch
parisc               randconfig-r2102-20261123    gcc-11.5.0 cocci
parisc               randconfig-r2104-20261123    gcc-15.3.0 cocci
parisc64                             defconfig    clang-24
powerpc                     adder875_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       arches_defconfig    clang-19
powerpc                       bamboo_defconfig    clang-19
powerpc                        ebony_defconfig    clang-19
powerpc                        ebony_defconfig    clang-24
powerpc                      kmeter1_defconfig    clang-24
powerpc                        ppc64_defconfig    clang-17
powerpc               randconfig-2000-20261123    gcc-8.5.0
powerpc               randconfig-2000-20261124    clang-17
powerpc               randconfig-2001-20261123    clang-24
powerpc               randconfig-2001-20261124    gcc-10.5.0
powerpc               randconfig-2002-20261123    clang-21
powerpc               randconfig-2002-20261124    clang-24
powerpc               randconfig-2200-20261123    gcc-9.5.0  smatch
powerpc               randconfig-2200-20261124    clang-21   smatch
powerpc                      skiroot_defconfig    clang-24
powerpc                     socrates_defconfig    gcc-16.2.0
powerpc                      tqm8541_defconfig    gcc-16.2.0
powerpc                      tqm8560_defconfig    clang-19
powerpc                       tqm8xx_defconfig    clang-24
powerpc64             randconfig-2000-20261123    gcc-8.5.0
powerpc64             randconfig-2000-20261124    clang-24
powerpc64             randconfig-2001-20261123    clang-24
powerpc64             randconfig-2001-20261124    clang-22
powerpc64             randconfig-2002-20261123    clang-24
powerpc64             randconfig-2002-20261124    clang-24
powerpc64             randconfig-2200-20261123    gcc-15.3.0 smatch
powerpc64             randconfig-2200-20261124    gcc-12.5.0 smatch
powerpc64            randconfig-r2104-20261123    clang-17   cocci
powerpc64            randconfig-r2304-20261124    clang-24   sparse
powerpc64            randconfig-r2310-20261123    clang-24   sparse
powerpc64            randconfig-r2311-20261123    gcc-12.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                     nommu_k210_defconfig    clang-24
riscv                 randconfig-1000-20261124    gcc-11.5.0
riscv                 randconfig-1001-20261124    gcc-11.5.0
riscv                 randconfig-2000-20261123    gcc-11.5.0
riscv                 randconfig-2001-20261123    gcc-13.5.0
riscv                 randconfig-2002-20261123    gcc-8.5.0
riscv                 randconfig-2003-20261123    gcc-8.5.0
riscv                 randconfig-2004-20261123    clang-24
riscv                 randconfig-2005-20261123    gcc-13.5.0
riscv                 randconfig-2200-20261123    clang-17   smatch
riscv                 randconfig-2200-20261124    gcc-14.4.0 smatch
riscv                randconfig-r2308-20261123    gcc-8.5.0  sparse
s390                              alldefconfig    clang-24
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261124    gcc-11.5.0
s390                  randconfig-1001-20261124    gcc-11.5.0
s390                  randconfig-2000-20261123    gcc-15.3.0
s390                  randconfig-2000-20261124    clang-19
s390                  randconfig-2001-20261123    gcc-9.5.0
s390                  randconfig-2001-20261124    gcc-14.4.0
s390                  randconfig-2002-20261123    clang-20
s390                  randconfig-2002-20261124    clang-24
s390                  randconfig-2003-20261123    clang-22
s390                  randconfig-2003-20261124    clang-24
s390                  randconfig-2004-20261123    gcc-15.3.0
s390                  randconfig-2004-20261124    clang-24
s390                  randconfig-2005-20261123    gcc-8.5.0
s390                  randconfig-2005-20261124    clang-24
s390                  randconfig-2200-20261123    clang-24   smatch
s390                 randconfig-r2109-20261123    gcc-13.5.0 cocci
s390                 randconfig-r2310-20261124    clang-17   sparse
s390                        zfcpdump_defconfig    clang-19
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                         apsh4ad0a_defconfig    clang-24
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261124    gcc-11.5.0
sh                    randconfig-1001-20261124    gcc-11.5.0
sh                    randconfig-2000-20261123    gcc-16.2.0
sh                    randconfig-2001-20261123    gcc-16.2.0
sh                    randconfig-2002-20261123    gcc-10.5.0
sh                    randconfig-2003-20261123    gcc-16.2.0
sh                    randconfig-2004-20261123    gcc-14.4.0
sh                    randconfig-2005-20261123    gcc-16.2.0
sh                    randconfig-2200-20261123    gcc-16.2.0 smatch
sh                   randconfig-r2103-20261123    gcc-12.5.0 cocci
sh                   randconfig-r2306-20261123    gcc-12.5.0 sparse
sh                           rsk7269_defconfig    clang-24
sh                           sdk7780_defconfig    gcc-16.2.0
sh                            se7721_defconfig    gcc-16.2.0
sh                            se7780_defconfig    clang-24
sh                         sh7757lcr_defconfig    gcc-16.2.0
sh                    sh7770_generic_defconfig    clang-17
sh                    sh7770_generic_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261124    clang-24
sparc                 randconfig-1001-20261124    clang-24
sparc                 randconfig-2000-20261123    gcc-16.2.0
sparc                 randconfig-2000-20261124    gcc-16.2.0
sparc                 randconfig-2001-20261123    gcc-8.5.0
sparc                 randconfig-2001-20261124    gcc-15.3.0
sparc                 randconfig-2200-20261123    gcc-12.5.0 smatch
sparc                 randconfig-2200-20261124    gcc-11.5.0 smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261124    clang-24
sparc64               randconfig-1001-20261124    clang-24
sparc64               randconfig-2000-20261123    clang-24
sparc64               randconfig-2000-20261124    clang-24
sparc64               randconfig-2001-20261123    gcc-9.5.0
sparc64               randconfig-2001-20261124    gcc-8.5.0
sparc64               randconfig-2200-20261123    clang-22   smatch
sparc64               randconfig-2200-20261124    clang-24   smatch
sparc64              randconfig-r2111-20261124    gcc-13.5.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261124    clang-24
um                    randconfig-1001-20261124    clang-24
um                    randconfig-2000-20261123    gcc-14
um                    randconfig-2000-20261124    gcc-14
um                    randconfig-2001-20261123    gcc-14
um                    randconfig-2001-20261124    gcc-14
um                    randconfig-2200-20261123    clang-21   smatch
um                    randconfig-2200-20261124    gcc-14     smatch
um                   randconfig-r2106-20261124    clang-24   cocci
um                   randconfig-r2111-20261123    clang-24   cocci
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261124    gcc-14
x86_64      buildonly-randconfig-1001-20261124    gcc-14
x86_64      buildonly-randconfig-1002-20261124    gcc-14
x86_64      buildonly-randconfig-1003-20261124    gcc-14
x86_64      buildonly-randconfig-1004-20261124    gcc-14
x86_64      buildonly-randconfig-1005-20261124    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261124    gcc-12
x86_64                randconfig-1001-20261124    gcc-12
x86_64                randconfig-1002-20261124    gcc-12
x86_64                randconfig-1003-20261124    gcc-12
x86_64                randconfig-1004-20261124    gcc-12
x86_64                randconfig-1005-20261124    gcc-12
x86_64                randconfig-2000-20261123    gcc-14
x86_64                randconfig-2000-20261124    clang-22
x86_64                randconfig-2001-20261123    gcc-14
x86_64                randconfig-2001-20261124    clang-22
x86_64                randconfig-2002-20261123    gcc-14
x86_64                randconfig-2002-20261124    gcc-14
x86_64                randconfig-2003-20261123    gcc-14
x86_64                randconfig-2003-20261124    clang-22
x86_64                randconfig-2004-20261123    gcc-14
x86_64                randconfig-2004-20261124    gcc-14
x86_64                randconfig-2005-20261123    gcc-14
x86_64                randconfig-2005-20261124    gcc-14
x86_64                randconfig-2100-20261123    gcc-14     cocci
x86_64                randconfig-2100-20261124    gcc-14     cocci
x86_64                randconfig-2101-20261123    clang-22   cocci
x86_64                randconfig-2101-20261124    gcc-14     cocci
x86_64                randconfig-2102-20261123    clang-22   cocci
x86_64                randconfig-2102-20261124    gcc-14     cocci
x86_64                randconfig-2103-20261123    clang-22   cocci
x86_64                randconfig-2103-20261124    gcc-14     cocci
x86_64                randconfig-2104-20261123    clang-22   cocci
x86_64                randconfig-2104-20261124    clang-22   cocci
x86_64                randconfig-2105-20261123    gcc-13     cocci
x86_64                randconfig-2105-20261124    gcc-14     cocci
x86_64                randconfig-2200-20261123    gcc-14     smatch
x86_64                randconfig-2300-20261123    clang-22   sparse
x86_64                randconfig-2301-20261123    gcc-14     sparse
x86_64                randconfig-2302-20261123    gcc-14     sparse
x86_64               randconfig-r2302-20261123    gcc-12     sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261124    clang-24
xtensa                randconfig-1001-20261124    clang-24
xtensa                randconfig-2000-20261123    gcc-16.2.0
xtensa                randconfig-2000-20261124    gcc-11.5.0
xtensa                randconfig-2001-20261123    gcc-8.5.0
xtensa                randconfig-2001-20261124    gcc-13.5.0
xtensa                randconfig-2200-20261123    gcc-8.5.0  smatch
xtensa               randconfig-r2110-20261123    gcc-10.5.0 cocci
xtensa               randconfig-r2309-20261123    gcc-8.5.0  sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

