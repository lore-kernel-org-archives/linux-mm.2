Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26461CA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 01:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9765A6B008A; Sat, 10 Oct 2026 21:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927B46B008C; Sat, 10 Oct 2026 21:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE846B0092; Sat, 10 Oct 2026 21:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 513C86B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:53:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35C071205A8
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:53:01 +0000 (UTC)
X-FDA: 85308672162.27.07AA7F4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 78C9440003
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:52:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A8VfS/Dn";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791683579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wud7YOEWdnEo0hD2QGXl9+nEPD95Q6BZ4H5imOwnwls=;
	b=OVJXZ5GdtFrgIm71+cH/t147rbPnR/TXevM4hM3s8oDCHDptkk4ODFceT4RMpjwZgQB0VA
	XlI7tFfxrw0ELu+O7tdl3ehi7XI0jaDYcINS4i4Gsoat4HiPyYpDXxwN/oWjN38BgWYtz7
	e8xyOyIaRJrpiVlkHUBopEVcKA7ibiQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A8VfS/Dn";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791683579;
	b=azE7jxDiwhcixirGDmrz5v/uOb3CI5XHFrGKDPMh7IBXABFQoqQlbFm8TJMrJBZboq7NA0
	1gBFDWti3Ik8ILSTGmIESBFso3uXHfeQaP4PWzjYuiCahfKPQbQDILk4OUl+Fg403sMNVV
	WSuQi70/Y/ZTDdWOI6hr1ttLFcB50RA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791683579; x=1823219579;
  h=date:from:to:cc:subject:message-id;
  bh=a4ucmR6xRbGbwRuIhjY0mWNlLGJvjzd4lrJ0ustrcYM=;
  b=A8VfS/DnjFc/5EN0oHvAdgHPkP7tH4Rg2w7BJx5GF77lsaAfn+MR72+u
   HOZwkOxudZ45wmFjde7sGV/zFsv8Nj4mgiAAe0NBZKUiv7MkOr+csaNs9
   Jj4Db49/mxsisQBiHGy/qCDEnYjve1CJiHU2BhBRtAbmS6oU5t3tnBXBN
   5khsFAGHtSJU5z5WrScMbb4IqYSTGqLU5Gxwi/dpAyyeLTGDHrFJtfVuM
   wpmo102Xme3wq6Ex9QwCCPxHLJEKGawSWZ1DsNYHc26EF3bb1ZYhIHb2e
   09PQPc/3M5GzA+WnnC0GCH6mjp20aZSsq/qTolBfjlsOJ+VBlw3y3B9Ew
   A==;
X-CSE-ConnectionGUID: O1H8yW5hSMq2ItjTKpFO/A==
X-CSE-MsgGUID: 9Y0SZjKFTZix11657JbdSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="426691"
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="426691"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2026 18:52:57 -0700
X-CSE-ConnectionGUID: xaZpM/BIQQKAaIGEPNoFRw==
X-CSE-MsgGUID: u8CHvlwUQSSfgNAJvLA98Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="969762"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 10 Oct 2026 18:52:56 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFik9-00000000AEW-0aEk;
	Sun, 11 Oct 2026 01:52:53 +0000
Date: Sun, 11 Oct 2026 09:52:01 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 becb95e45ef0dda9ffb35156d909d3da7a2789c3
Message-ID: <202610110958.uv3YBqqY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78C9440003
X-Rspam-User: 
X-Stat-Signature: 7tytkmmdafrtpyto34e4766ei1q4sb1n
X-HE-Tag: 1791683578-295901
X-HE-Meta: U2FsdGVkX199sGhvHspo6k4XphG+KwdTVKkcUOlZFuWFJp1k9LBrbIqNXMhQXF7wHEZ50SVuK/P2/KGwphMgrXkr0zsOaPuVbXGLyDkeNO7pmkb0M6bV+ZSanNvyCxLblQBLIbxYFtvOsaMJNrGUSUGUBeLXJpIprHwkygUVnDMUEODwcYArOTIwfCEyryQZSdP0tjuUk+bUodLydj0oysav2fT9Rdv1nzsxB2vvJgLT31a90oNvzyfeNe3zDg8Dy/X67URv9Ev80pchjIikACfx4vzLdL6rv58q4fsKpKucKk9z/ZhRaUf73GdRIyTQkjuB+tyb1uz6wobnq5q3ILUO3xnF47uUMl0y/p6HV8dZHkQudOSZ0tIvdRamgTWMX0I0ngq3NfuerGr3xaFRsjXwtVRBRt8XgVWeo5zrTdeFhj4U95FEqooy4LAudfun0+MxKbKT49UC6IuXKSqT1SealcgjOYthj5oLu1HQ8S8lapvepxaCu58FzNlwNd7g5BbMjf5vC+xsYoaPuMszvXZ4wKp1VDLSNnqHn35idOdsguhOK2ZBwVs4HT14uZxV+sW9yePwr4Qa6xqadGRsdl+mP7BWv6A9cWH9qRQR1CduLdBY/+dGf9kqOXjlhx3H4Oq4owexBcdQz0h1NNqIoB/X6Xu7IQumUTlg1bnwxgkSjmmRC1AXN9lN00s5wCBhLB7RKz3qdHyFFm0LN3U4QfzfO5J4sWhhtk2NYhC6VxspK8eEnFt+zPE+4/719l9cY8+mPoLtDKXLl4vcX3Cx7ENukhp0F86cYtKHW2ypaKq/m75fF5lmhNtaPeg7yOLnVZx1X4yMdYFLS4c5FsK6ycJvXendzJV9CyJo0kAsJII1I3uaG0tFxsoW8i7ozvuk4td7fqvy2R4aiFKhMtys+QmGfC7YL8Q11VHynQNUgQ2JAiwFn9fYyHrjZFC2lCyoCPUP95QXF8dvI7ch7LC
 H52XRaBG
 Vv2yI8UgGmx8x180+ik4jU9YaxRnmp4l8TWZ7yf3tDkGS7IthH4Iwa7pulK0NOQFef86fruwIlWMJUncRvWEm9E+g5ag1JLO9R8KYPSOAF9FN/9bNOCZ6qzAx9pQ8Oc2uYCBkg+6wNmcBdHkpvyZPAfAN5xB+8Xwp8tJ1wiaz5bQf01MTzvlatkpdEojOemdvAH/NUKNyWyt1g845PzsY1+gSpfnEnzhdPt+i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: becb95e45ef0dda9ffb35156d909d3da7a2789c3  Add linux-next specific files for 20261009

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202610110511.Nk1sZ8SG-lkp@intel.com

    drivers/iommu/hyperv/hv-iommu-guest.c:574:(.init.text+0x17c): undefined reference to `pci_request_acs'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r2101-20261010
|   |-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:arch-arm64-mm-init.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-generi
|   |-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:lib-kunit-test.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-generic_pt
|   |-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:lib-kunit-try-catch.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-gener
|   |-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:lib-maple_tree.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-generic_pt
|   |-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:lib-string.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-generic_pt-fmt
|   `-- warning:linking-module-drivers-iommu-generic_pt-fmt-kunit_iommu_bcm2712.o:Linking-two-modules-of-different-target-triples:mm-vmstat.o-is-aarch64-unknown-linux-gnu-whereas-drivers-iommu-generic_pt-fmt-
|-- x86_64-allnoconfig
`-- x86_64-buildonly-randconfig-1004-20261010
    `-- drivers-iommu-hyperv-hv-iommu-guest.c:(.init.text):undefined-reference-to-pci_request_acs

elapsed time: 1230m

configs tested: 431
configs skipped: 11

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2107-20261010    gcc-8.5.0  cocci
alpha                randconfig-r2111-20261010    clang-20   cocci
alpha                randconfig-r2202-20261010    gcc-8.5.0  smatch
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261010    gcc-15.2.0
arc                   randconfig-1000-20261010    gcc-8.5.0
arc                   randconfig-1001-20261010    gcc-13.4.0
arc                   randconfig-1001-20261010    gcc-8.5.0
arc                   randconfig-2000-20261010    gcc-8.5.0
arc                   randconfig-2001-20261010    gcc-8.5.0
arc                  randconfig-r2100-20261010    gcc-15.2.0 cocci
arc                  randconfig-r2104-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2107-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2308-20261010    gcc-13.4.0 sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           moxart_defconfig    gcc-16.1.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261010    clang-24
arm                   randconfig-1000-20261010    gcc-8.5.0
arm                   randconfig-1001-20261010    gcc-15.2.0
arm                   randconfig-1001-20261010    gcc-8.5.0
arm                   randconfig-1002-20261010    gcc-8.5.0
arm                   randconfig-1003-20261010    gcc-8.5.0
arm                   randconfig-2000-20261010    gcc-8.5.0
arm                   randconfig-2001-20261010    gcc-8.5.0
arm                  randconfig-r2105-20261010    gcc-8.5.0  cocci
arm                  randconfig-r2303-20261010    gcc-8.5.0  sparse
arm                  randconfig-r2306-20261010    gcc-8.5.0  sparse
arm                  randconfig-r2309-20261010    clang-24   sparse
arm                  randconfig-r2310-20261010    clang-24   sparse
arm                        spear13xx_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261010    gcc-10.5.0
arm64                 randconfig-1000-20261010    gcc-8.5.0
arm64                 randconfig-1001-20261010    gcc-10.5.0
arm64                 randconfig-1002-20261010    clang-20
arm64                 randconfig-1002-20261010    gcc-10.5.0
arm64                 randconfig-1003-20261010    clang-24
arm64                 randconfig-1003-20261010    gcc-10.5.0
arm64                 randconfig-2000-20261010    gcc-16.1.0
arm64                 randconfig-2001-20261010    gcc-16.1.0
arm64                randconfig-r2101-20261010    clang-22   cocci
arm64                randconfig-r2101-20261010    gcc-10.5.0 cocci
arm64                randconfig-r2104-20261010    clang-17   cocci
arm64                randconfig-r2105-20261010    clang-20   cocci
arm64                randconfig-r2105-20261010    gcc-8.5.0  cocci
arm64                randconfig-r2304-20261010    gcc-9.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261010    gcc-10.5.0
csky                  randconfig-1000-20261010    gcc-16.1.0
csky                  randconfig-1001-20261010    gcc-10.5.0
csky                  randconfig-1001-20261010    gcc-13.4.0
csky                  randconfig-2000-20261010    gcc-16.1.0
csky                  randconfig-2001-20261010    gcc-16.1.0
csky                 randconfig-r2103-20261010    gcc-11.5.0 cocci
csky                 randconfig-r2300-20261010    gcc-15.2.0 sparse
csky                 randconfig-r2308-20261010    clang-24   sparse
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261010    clang-17
hexagon               randconfig-1000-20261010    clang-24
hexagon               randconfig-1001-20261010    clang-17
hexagon               randconfig-2000-20261010    gcc-16.1.0
hexagon               randconfig-2001-20261010    gcc-16.1.0
hexagon              randconfig-r2100-20261010    clang-24   cocci
hexagon              randconfig-r2110-20261010    clang-20   cocci
hexagon              randconfig-r2306-20261010    gcc-16.1.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261010    gcc-13
i386        buildonly-randconfig-1000-20261010    gcc-14
i386        buildonly-randconfig-1001-20261010    clang-22
i386        buildonly-randconfig-1001-20261010    gcc-14
i386        buildonly-randconfig-1002-20261010    gcc-14
i386        buildonly-randconfig-1003-20261010    gcc-14
i386        buildonly-randconfig-1004-20261010    clang-22
i386        buildonly-randconfig-1004-20261010    gcc-14
i386        buildonly-randconfig-1005-20261010    clang-22
i386        buildonly-randconfig-1005-20261010    gcc-14
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261010    clang-22
i386                  randconfig-1000-20261010    gcc-14
i386                  randconfig-1001-20261010    clang-22
i386                  randconfig-1002-20261010    clang-22
i386                  randconfig-1003-20261010    clang-22
i386                  randconfig-1004-20261010    clang-22
i386                  randconfig-1004-20261010    gcc-14
i386                  randconfig-1005-20261010    clang-22
i386                  randconfig-1005-20261010    gcc-13
i386                  randconfig-1006-20261010    clang-22
i386                  randconfig-1007-20261010    gcc-14
i386                  randconfig-1008-20261010    gcc-14
i386                  randconfig-1009-20261010    gcc-14
i386                  randconfig-1010-20261010    gcc-14
i386                  randconfig-1011-20261010    clang-22
i386                  randconfig-1011-20261010    gcc-14
i386                  randconfig-1012-20261010    clang-22
i386                  randconfig-1012-20261010    gcc-14
i386                  randconfig-1013-20261010    clang-22
i386                  randconfig-1013-20261010    gcc-14
i386                  randconfig-2000-20261010    gcc-8.5.0
i386                  randconfig-2001-20261010    gcc-8.5.0
i386                  randconfig-2100-20261010    clang-22   cocci
i386                  randconfig-2100-20261010    gcc-13     cocci
i386                  randconfig-2100-20261010    gcc-14     cocci
i386                  randconfig-2101-20261010    clang-22   cocci
i386                  randconfig-2101-20261010    gcc-13     cocci
i386                  randconfig-2101-20261010    gcc-14     cocci
i386                  randconfig-2102-20261010    clang-22   cocci
i386                  randconfig-2102-20261010    gcc-13     cocci
i386                  randconfig-2103-20261010    clang-22   cocci
i386                  randconfig-2103-20261010    gcc-13     cocci
i386                  randconfig-2104-20261010    gcc-13     cocci
i386                  randconfig-2105-20261010    gcc-13     cocci
i386                  randconfig-2200-20261010    gcc-12     smatch
i386                  randconfig-2300-20261010    gcc-14     sparse
i386                  randconfig-2301-20261010    gcc-14     sparse
i386                  randconfig-2302-20261010    clang-22   sparse
i386                  randconfig-2302-20261010    gcc-14     sparse
i386                 randconfig-r2305-20261010    gcc-8.5.0  sparse
i386                 randconfig-r2307-20261010    clang-24   sparse
i386                 randconfig-r2308-20261010    gcc-16.1.0 sparse
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    clang-18
loongarch             randconfig-1000-20261010    clang-17
loongarch             randconfig-1000-20261010    clang-24
loongarch             randconfig-1001-20261010    clang-17
loongarch             randconfig-1001-20261010    clang-18
loongarch             randconfig-2000-20261010    gcc-8.5.0
loongarch             randconfig-2001-20261010    gcc-8.5.0
loongarch            randconfig-r2105-20261010    gcc-8.5.0  cocci
loongarch            randconfig-r2107-20261010    clang-24   cocci
loongarch            randconfig-r2304-20261010    gcc-8.5.0  sparse
loongarch            randconfig-r2309-20261010    gcc-16.1.0 sparse
loongarch            randconfig-r2311-20261010    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                         m5307c3_defconfig    gcc-16.1.0
m68k                 randconfig-r2103-20261010    gcc-14.3.0 cocci
m68k                 randconfig-r2307-20261010    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2102-20261010    gcc-8.5.0  cocci
microblaze           randconfig-r2103-20261010    gcc-10.5.0 cocci
microblaze           randconfig-r2104-20261010    clang-20   cocci
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                          bigsur_defconfig    gcc-16.1.0
mips                  decstation_r4k_defconfig    gcc-16.1.0
mips                     maltaup_xpa_defconfig    gcc-16.1.0
mips                 randconfig-r2100-20261010    gcc-10.5.0 cocci
mips                 randconfig-r2106-20261010    gcc-8.5.0  cocci
mips                 randconfig-r2107-20261010    gcc-8.5.0  cocci
mips                 randconfig-r2200-20261010    gcc-14.3.0 smatch
mips                 randconfig-r2301-20261010    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261010    clang-17
nios2                 randconfig-1000-20261010    gcc-11.5.0
nios2                 randconfig-1001-20261010    clang-17
nios2                 randconfig-1001-20261010    gcc-11.5.0
nios2                 randconfig-2000-20261010    gcc-8.5.0
nios2                 randconfig-2001-20261010    gcc-8.5.0
nios2                randconfig-r2106-20261010    gcc-8.5.0  cocci
nios2                randconfig-r2306-20261010    gcc-13.4.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261010    gcc-13.4.0 cocci
openrisc             randconfig-r2102-20261010    clang-22   cocci
openrisc             randconfig-r2201-20261010    gcc-16.1.0 smatch
openrisc             randconfig-r2301-20261010    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                 generic-64bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261010    gcc-9.5.0
parisc                randconfig-1001-20261010    gcc-8.5.0
parisc                randconfig-2000-20261010    gcc-8.5.0
parisc                randconfig-2001-20261010    gcc-8.5.0
parisc               randconfig-r2101-20261010    gcc-8.5.0  cocci
parisc               randconfig-r2305-20261010    gcc-13.4.0 sparse
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                         icon_defconfig    gcc-16.1.0
powerpc                      mpc5200_defconfig    clang-24
powerpc                     mvme5100_defconfig    gcc-16.1.0
powerpc                        ppc64_defconfig    gcc-16.1.0
powerpc                          ps3_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261010    gcc-8.5.0
powerpc               randconfig-1001-20261010    clang-24
powerpc               randconfig-2000-20261010    gcc-14
powerpc               randconfig-2001-20261010    gcc-14
powerpc              randconfig-r2100-20261010    clang-22   cocci
powerpc              randconfig-r2107-20261010    clang-20   cocci
powerpc              randconfig-r2302-20261010    gcc-8.5.0  sparse
powerpc              randconfig-r2308-20261010    clang-24   sparse
powerpc64             randconfig-1000-20261010    clang-24
powerpc64             randconfig-1001-20261010    clang-24
powerpc64             randconfig-2000-20261010    gcc-14
powerpc64             randconfig-2001-20261010    gcc-14
powerpc64            randconfig-r2306-20261010    clang-24   sparse
powerpc64            randconfig-r2307-20261010    gcc-13.4.0 sparse
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261010    clang-19
riscv                 randconfig-1001-20261010    clang-19
riscv                 randconfig-1001-20261010    clang-24
riscv                 randconfig-2000-20261010    gcc-16.1.0
riscv                 randconfig-2000-20261010    gcc-9.5.0
riscv                 randconfig-2001-20261010    clang-24
riscv                 randconfig-2001-20261010    gcc-16.1.0
riscv                randconfig-r2201-20261010    clang-21   smatch
riscv                randconfig-r2306-20261010    clang-24   sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261010    clang-19
s390                  randconfig-1000-20261010    clang-24
s390                  randconfig-1001-20261010    clang-19
s390                  randconfig-1001-20261010    clang-24
s390                  randconfig-2000-20261010    clang-17
s390                  randconfig-2000-20261010    gcc-16.1.0
s390                  randconfig-2001-20261010    gcc-15.2.0
s390                  randconfig-2001-20261010    gcc-16.1.0
s390                 randconfig-r2102-20261010    gcc-10.5.0 cocci
s390                 randconfig-r2106-20261010    clang-20   cocci
s390                 randconfig-r2307-20261010    gcc-16.1.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                              espt_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261010    clang-19
sh                    randconfig-1000-20261010    gcc-11.5.0
sh                    randconfig-1001-20261010    clang-19
sh                    randconfig-1001-20261010    gcc-13.4.0
sh                    randconfig-2000-20261010    gcc-16.1.0
sh                    randconfig-2001-20261010    gcc-16.1.0
sh                   randconfig-r2202-20261010    gcc-9.5.0  smatch
sh                   randconfig-r2302-20261010    gcc-16.1.0 sparse
sh                    sh7724_generic_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261010    gcc-16.1.0
sparc                 randconfig-1000-20261010    gcc-8.5.0
sparc                 randconfig-1001-20261010    gcc-16.1.0
sparc                 randconfig-1001-20261010    gcc-8.5.0
sparc                 randconfig-2000-20261010    gcc-16.1.0
sparc                 randconfig-2000-20261010    gcc-8.5.0
sparc                 randconfig-2001-20261010    gcc-16.1.0
sparc                randconfig-r2200-20261010    gcc-16.1.0 smatch
sparc                randconfig-r2201-20261010    gcc-11.5.0 smatch
sparc                randconfig-r2303-20261010    gcc-8.5.0  sparse
sparc                randconfig-r2308-20261010    gcc-14.3.0 sparse
sparc                randconfig-r2309-20261010    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261010    clang-24
sparc64               randconfig-1000-20261010    gcc-16.1.0
sparc64               randconfig-1001-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261010    gcc-8.5.0
sparc64               randconfig-2001-20261010    clang-21
sparc64               randconfig-2001-20261010    gcc-16.1.0
sparc64              randconfig-r2102-20261010    gcc-13.4.0 cocci
sparc64              randconfig-r2105-20261010    gcc-15.2.0 cocci
sparc64              randconfig-r2106-20261010    gcc-9.5.0  cocci
sparc64              randconfig-r2307-20261010    clang-22   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261010    gcc-14
um                    randconfig-1000-20261010    gcc-16.1.0
um                    randconfig-1001-20261010    gcc-14
um                    randconfig-1001-20261010    gcc-16.1.0
um                    randconfig-2000-20261010    clang-24
um                    randconfig-2000-20261010    gcc-16.1.0
um                    randconfig-2001-20261010    clang-24
um                    randconfig-2001-20261010    gcc-16.1.0
um                   randconfig-r2201-20261010    clang-17   smatch
um                   randconfig-r2309-20261010    gcc-13.4.0 sparse
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261010    gcc-14
x86_64      buildonly-randconfig-1000-20261011    gcc-14
x86_64      buildonly-randconfig-1001-20261010    gcc-13
x86_64      buildonly-randconfig-1001-20261011    gcc-14
x86_64      buildonly-randconfig-1002-20261010    clang-22
x86_64      buildonly-randconfig-1002-20261011    gcc-14
x86_64      buildonly-randconfig-1003-20261010    clang-22
x86_64      buildonly-randconfig-1003-20261011    gcc-14
x86_64      buildonly-randconfig-1004-20261010    gcc-13
x86_64      buildonly-randconfig-1004-20261011    gcc-14
x86_64      buildonly-randconfig-1005-20261010    clang-22
x86_64      buildonly-randconfig-1005-20261011    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261010    gcc-14
x86_64                randconfig-1001-20261010    gcc-14
x86_64                randconfig-1002-20261010    clang-22
x86_64                randconfig-1003-20261010    clang-22
x86_64                randconfig-1004-20261010    gcc-14
x86_64                randconfig-1005-20261010    gcc-13
x86_64                randconfig-1006-20261010    clang-22
x86_64                randconfig-1007-20261010    clang-22
x86_64                randconfig-1008-20261010    clang-22
x86_64                randconfig-1009-20261010    clang-22
x86_64                randconfig-1010-20261010    clang-22
x86_64                randconfig-1011-20261010    clang-22
x86_64                randconfig-1011-20261010    gcc-14
x86_64                randconfig-1012-20261010    clang-22
x86_64                randconfig-1012-20261010    gcc-14
x86_64                randconfig-1013-20261010    clang-22
x86_64                randconfig-1013-20261010    gcc-14
x86_64                randconfig-1014-20261010    clang-22
x86_64                randconfig-1014-20261010    gcc-14
x86_64                randconfig-1015-20261010    clang-22
x86_64                randconfig-1015-20261010    gcc-14
x86_64                randconfig-1016-20261010    clang-22
x86_64                randconfig-1016-20261010    gcc-14
x86_64                randconfig-1017-20261010    clang-22
x86_64                randconfig-2000-20261010    gcc-14
x86_64                randconfig-2001-20261010    gcc-14
x86_64                randconfig-2100-20261010    clang-22   cocci
x86_64                randconfig-2101-20261010    clang-22   cocci
x86_64                randconfig-2102-20261010    clang-22   cocci
x86_64                randconfig-2103-20261010    clang-22   cocci
x86_64                randconfig-2104-20261010    clang-22   cocci
x86_64                randconfig-2105-20261010    clang-22   cocci
x86_64                randconfig-2200-20261010    gcc-14     smatch
x86_64                randconfig-2300-20261010    clang-22   sparse
x86_64                randconfig-2300-20261010    gcc-14     sparse
x86_64                randconfig-2301-20261010    clang-22   sparse
x86_64                randconfig-2301-20261010    gcc-14     sparse
x86_64                randconfig-2302-20261010    clang-22   sparse
x86_64                randconfig-2302-20261010    gcc-14     sparse
x86_64               randconfig-r2103-20261010    clang-22   cocci
x86_64               randconfig-r2104-20261010    gcc-8.5.0  cocci
x86_64               randconfig-r2106-20261010    gcc-14     cocci
x86_64               randconfig-r2309-20261010    gcc-14     sparse
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
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261010    gcc-16.1.0
xtensa                randconfig-1000-20261010    gcc-9.5.0
xtensa                randconfig-1001-20261010    gcc-15.2.0
xtensa                randconfig-1001-20261010    gcc-16.1.0
xtensa                randconfig-2000-20261010    gcc-10.5.0
xtensa                randconfig-2000-20261010    gcc-16.1.0
xtensa                randconfig-2001-20261010    gcc-16.1.0
xtensa               randconfig-r2200-20261010    gcc-8.5.0  smatch
xtensa               randconfig-r2300-20261010    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

