Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E4BC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F7E6B008C; Thu, 17 Sep 2026 19:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FDD6B0092; Thu, 17 Sep 2026 19:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EB96B0093; Thu, 17 Sep 2026 19:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327B36B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:16:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD04E1404EA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:16:04 +0000 (UTC)
X-FDA: 85224814248.16.C579986
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF26C40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:16:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ExMyIKZw;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.4 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789686962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=J8d3PArW5jGfRQ5CGpYgDYv6PWLaN1tht/TCWGQep8M=;
	b=lVJIVPHyT59n9fxGGOLaVo1quHIZAu/WFmtnO0qn1o1cLYAkQmQ1hdMvkQkExLbYHb238u
	UBlx6uNn8te5g8y+Nl26eKfXPVdd8FetvdL2qw6W1K7mAAfJarSruxi2jj22HtQLJsFFfk
	RACCS08qBJadTRBenzIK1gVGrrke4LA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ExMyIKZw;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.4 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789686962;
	b=fRdW+8gbu+fENvTRKu3gW1NZiprDLSDZOwkRL2J1I+l3EcHntAU7ulG+2qxMbllA1P3Wd5
	A0uKWbYPjMJ5LOSCPG/oDshZQFw7o9Ga48242BP97WHQnzn5oNCzfCZURh8RBdyaxG1ZHm
	Nt/TVIyHLRLL4uAmvs39T/ernQlV4H4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789686962; x=1821222962;
  h=date:from:to:cc:subject:message-id;
  bh=NmhNJST80iDMhCabvU24j4PdEgXLSQYIpEV28y/ojdA=;
  b=ExMyIKZw+4g0juBo8ljUSY6kd1lYzqK/P1hreQZ98wZxRVVgTMVtgu29
   n28f+D7D/tm5lNImHWGO9LXd+D/QFyTJKwM3gNlwxJSzjYnhCiKFGi8dw
   6R3/ZcccPHtwP0Syx3sgsI1DmHhCq3UjmKG+r7SNWin7RqwAoEWngBc4+
   km8iiV/KG5qch1kQ5q5O0V815bYrA0QNxGmeL7oDk7fjp0xHOXXPlLYvW
   FuFx2qJ+Msnyu1Qm+dJASA7iBkRDrFA5rUTb8aNuVGTHZlSjfw7ngrGyK
   Xw7hBijncZCDZi9ovLri5yuRZ43LUFAwHyMY7TsysH0rDdszbtq2kHePX
   w==;
X-CSE-ConnectionGUID: CkM0COiySmOoX9DY7VO5gw==
X-CSE-MsgGUID: l6srd09ZR8GIODqCRBnPlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="670373"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="670373"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 16:16:00 -0700
X-CSE-ConnectionGUID: 1tvRa8NyRQiePly2b/Cy4A==
X-CSE-MsgGUID: bhkjDghxQZu9J44CEU8yFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="2501314"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 17 Sep 2026 16:16:00 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x7LKf-000000008h3-1JAv;
	Thu, 17 Sep 2026 23:15:57 +0000
Date: Fri, 18 Sep 2026 07:15:09 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 ba13f1f32d96d7ce9069ae4f32404ecde8da89c4
Message-ID: <202609180705.0nnmFEww-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF26C40007
X-Stat-Signature: w995m1u1r4oyspg55q8fr58tqooywqen
X-Rspam-User: 
X-HE-Tag: 1789686961-329571
X-HE-Meta: U2FsdGVkX1+BJ+dPvOWURFZHJ9ETAMIHYR3afDvaVADhye0IPuJVcr8XJe1Usst3pAosvIZUSqNMlw2dw/iSGCFiP8bYEvgvPTo6pl3gUrl1pf4Z51mS649Ky1mF3vUZel769jsuJ6Cz5SMBrpLXmVXm9AtWADZ8sVSdk+FgkEeaXaAvEhhRBCXXUfvDKnjkcXfTTX2ogxX28cKCMFOQrqyfo7I0gSPf51Xl/+8feiqdcmaZi4LuJqyrh03SzkfKpTbBx30fqUaOty2qeREU0xJQULkQ9OVzbNOE+2vmj4eMCSF48/ZiqIiJqBL4jgYGXX/yvXCJAJuPS3y2TKLxKooCH8W2QaATZT+LsMcMwcgkanPNZpx8WFVp194mbI8H3ATvX+0sf4bsV2Vc/p3AJNFQ8XS6R4QORCOpzQW2rnpb5R27Wt1hiq2Ltc2Zv3RRP4riETAvUF1nQvLdkZOeTuDhmdN/bTChTq8wlCqiaqtQ9g/wGNawI42NMLFzOqmRVXAK+OfokFzbW4YynKI8sgSnDuYQtWgtDfIx9Z0nujqwnc6FNXu7pOeRuWnpHOifHRa6lWPR3/JUtSrIV0WKiLxfQv655uqRV81b0cgvgSY4hox63qKbVybEGxs8Bm6rfzjI2oH/yAJV4hybOQ7qAgTv8rrGpFKNcSCFeD0JlpjtUzOziTuvatmYmHtpnPUH/K8OfUa9KtUTi51nNNLvNAw0ViGlfn/VeIgOERRkLA2akYIykeyj3Nh7dOZY0dBztkC0twY6ss4JUWw9qY50VdzfD9OwSIJtrkrP8hAxBOKCGZYPgPrHTGdwrZao6MIGJjObpBo6+9gU1WCNgUrgMduRGKqPQ0Ayxtqu2E5+bLf43JIRX3c+y6bO8qNGM3YLoKH7r2kGAhreCfSh+bsLjfv47dg768wskAN+ed6ZdlwvaJYpaTu77q1Ayza5d/qoCiUVaKNrr89bUD2R7LE
 N/ba2Wcn
 fzPz/9u7IDmWNNTMX3F8pDq9LP/DqRceMOMKR8RAxtQAjUooaXXBu2O6BabuYxulB2Y5ZKAwwwZxVUj+pypwkqzdcSuux7A0Wu4SneS9Sh3W0k2y+2mq4U1Z3chmi3UlFIbWh85PkInjc22xng0eZAuDVGOmf2wcQJnkZFGAWmc9sMosGRUsgt7ztK7/WX9XPavPS/b0LD6+xII0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: ba13f1f32d96d7ce9069ae4f32404ecde8da89c4  mm: memblock: add missing HugeTLB flag name

elapsed time: m

configs tested: 289
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             alldefconfig    gcc-16.1.0
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                 randconfig-r063-20260915    gcc-13.4.0
alpha                randconfig-r1304-20260917    clang-21   sparse
alpha                randconfig-r1306-20260917    clang-24   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260917    gcc-15.2.0
arc                   randconfig-1000-20260918    gcc-16.1.0
arc                   randconfig-1001-20260917    gcc-15.2.0
arc                   randconfig-1001-20260918    gcc-16.1.0
arc                  randconfig-r1302-20260917    gcc-8.5.0  sparse
arc                  randconfig-r1303-20260917    gcc-8.5.0  sparse
arc                  randconfig-r1305-20260917    gcc-8.5.0  sparse
arc                            tb10x_defconfig    gcc-16.1.0
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                        aspeed_g4_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                        imx_v6_v7_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260917    gcc-15.2.0
arm                   randconfig-1000-20260918    gcc-16.1.0
arm                   randconfig-1001-20260917    gcc-15.2.0
arm                   randconfig-1001-20260918    gcc-16.1.0
arm                   randconfig-1002-20260917    gcc-15.2.0
arm                   randconfig-1002-20260918    gcc-16.1.0
arm                   randconfig-1003-20260917    gcc-15.2.0
arm                   randconfig-1003-20260918    gcc-16.1.0
arm                   randconfig-r071-20260916    clang-19
arm                   randconfig-r072-20260915    clang-17
arm                  randconfig-r1308-20260917    gcc-13.4.0 sparse
arm                          s5pv210_defconfig    clang-24
arm64                             alldefconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260917    gcc-11.5.0
arm64                 randconfig-1001-20260917    gcc-11.5.0
arm64                 randconfig-1002-20260917    gcc-11.5.0
arm64                 randconfig-1003-20260917    gcc-11.5.0
arm64                 randconfig-r053-20260916    clang-24
arm64                randconfig-r1306-20260917    clang-18   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260917    gcc-11.5.0
csky                  randconfig-1001-20260917    gcc-11.5.0
csky                  randconfig-r062-20260915    gcc-13.4.0
csky                 randconfig-r1308-20260917    clang-24   sparse
csky                 randconfig-r1309-20260917    clang-18   sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260917    clang-24
hexagon               randconfig-1001-20260917    clang-24
hexagon               randconfig-r052-20260916    clang-24
hexagon               randconfig-r054-20260915    clang-17
hexagon              randconfig-r1300-20260917    clang-21   sparse
hexagon              randconfig-r1301-20260917    gcc-8.5.0  sparse
hexagon              randconfig-r1304-20260917    gcc-8.5.0  sparse
hexagon              randconfig-r1307-20260917    clang-18   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260917    gcc-13
i386        buildonly-randconfig-1000-20260918    gcc-14
i386        buildonly-randconfig-1001-20260917    gcc-13
i386        buildonly-randconfig-1001-20260918    gcc-14
i386        buildonly-randconfig-1002-20260917    gcc-13
i386        buildonly-randconfig-1002-20260918    gcc-14
i386        buildonly-randconfig-1003-20260917    gcc-13
i386        buildonly-randconfig-1003-20260918    gcc-14
i386        buildonly-randconfig-1004-20260917    gcc-13
i386        buildonly-randconfig-1004-20260918    gcc-14
i386        buildonly-randconfig-1005-20260917    gcc-13
i386        buildonly-randconfig-1005-20260918    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                   randconfig-051-20260915    clang-22
i386                   randconfig-051-20260916    gcc-14
i386                   randconfig-052-20260915    clang-22
i386                   randconfig-052-20260916    gcc-14
i386                   randconfig-053-20260915    clang-22
i386                   randconfig-053-20260916    gcc-14
i386                   randconfig-054-20260915    clang-22
i386                   randconfig-054-20260916    gcc-14
i386                  randconfig-1000-20260917    clang-22
i386                  randconfig-1001-20260917    clang-22
i386                  randconfig-1002-20260917    clang-22
i386                  randconfig-1003-20260917    clang-22
i386                  randconfig-1004-20260917    clang-22
i386                  randconfig-1005-20260917    clang-22
i386                  randconfig-1006-20260917    clang-22
i386                  randconfig-1007-20260917    clang-22
i386                  randconfig-1008-20260917    clang-22
i386                  randconfig-1009-20260917    clang-22
i386                  randconfig-1010-20260917    clang-22
i386                  randconfig-1011-20260917    clang-22
i386                  randconfig-1012-20260917    clang-22
i386                  randconfig-1013-20260917    clang-22
i386                  randconfig-1300-20260917    gcc-14     sparse
i386                  randconfig-1301-20260917    gcc-14     sparse
i386                  randconfig-1302-20260917    gcc-14     sparse
i386                   randconfig-141-20260915    clang-22
i386                   randconfig-141-20260916    gcc-14
i386                  randconfig-r051-20260915    clang-17
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260917    clang-24
loongarch             randconfig-1001-20260917    clang-24
loongarch            randconfig-r1307-20260917    clang-24   sparse
loongarch            randconfig-r1309-20260917    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    gcc-16.1.0
m68k                          apollo_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                         m5272c3_defconfig    gcc-16.1.0
m68k                         mvme147_defconfig    gcc-16.1.0
m68k                  randconfig-r064-20260916    gcc-8.5.0
m68k                  randconfig-r072-20260916    gcc-14.3.0
m68k                           sun3x_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze            randconfig-r054-20260916    clang-24
microblaze            randconfig-r073-20260915    gcc-8.5.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                          cobalt_defconfig    gcc-16.1.0
mips                            gcw0_defconfig    clang-24
mips                            ip27_defconfig    gcc-16.1.0
mips                       malta_kvm_defconfig    gcc-16.1.0
mips                         omega2p_defconfig    clang-24
mips                 randconfig-r1309-20260917    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260917    clang-24
nios2                 randconfig-1001-20260917    clang-24
nios2                 randconfig-r053-20260915    clang-17
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1300-20260917    gcc-8.5.0  sparse
openrisc             randconfig-r1308-20260917    clang-18   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260917    gcc-11.5.0
parisc                randconfig-1000-20260918    gcc-8.5.0
parisc                randconfig-1001-20260917    gcc-11.5.0
parisc                randconfig-1001-20260918    gcc-8.5.0
parisc                randconfig-r052-20260915    clang-17
parisc                randconfig-r062-20260916    gcc-8.5.0
parisc               randconfig-r1302-20260917    clang-21   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                        ebony_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc                           g5_defconfig    clang-24
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260917    gcc-11.5.0
powerpc               randconfig-1000-20260918    gcc-8.5.0
powerpc               randconfig-1001-20260917    gcc-11.5.0
powerpc               randconfig-1001-20260918    gcc-8.5.0
powerpc                   storcenter_defconfig    gcc-16.1.0
powerpc                         warp_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260917    gcc-11.5.0
powerpc64             randconfig-1000-20260918    gcc-8.5.0
powerpc64             randconfig-1001-20260917    gcc-11.5.0
powerpc64             randconfig-1001-20260918    gcc-8.5.0
powerpc64             randconfig-r073-20260916    gcc-10.5.0
powerpc64            randconfig-r1305-20260917    clang-21   sparse
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv              nommu_k210_sdcard_defconfig    clang-24
riscv                 randconfig-1000-20260917    clang-17
riscv                 randconfig-1001-20260917    clang-17
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260917    clang-17
s390                  randconfig-1001-20260917    clang-17
s390                  randconfig-r063-20260916    gcc-8.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260917    clang-17
sh                    randconfig-1001-20260917    clang-17
sh                    randconfig-r061-20260915    gcc-13.4.0
sh                            se7750_defconfig    clang-24
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260917    clang-17
sparc                 randconfig-1001-20260917    clang-17
sparc                 randconfig-r051-20260916    clang-24
sparc                randconfig-r1306-20260917    gcc-13.4.0 sparse
sparc                randconfig-r1307-20260917    gcc-13.4.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260917    clang-17
sparc64               randconfig-1001-20260917    clang-17
sparc64              randconfig-r1301-20260917    clang-21   sparse
sparc64              randconfig-r1303-20260917    clang-21   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260917    clang-17
um                    randconfig-1001-20260917    clang-17
um                    randconfig-r061-20260916    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260917    gcc-14
x86_64      buildonly-randconfig-1001-20260917    gcc-14
x86_64      buildonly-randconfig-1002-20260917    gcc-14
x86_64      buildonly-randconfig-1003-20260917    gcc-14
x86_64      buildonly-randconfig-1004-20260917    gcc-14
x86_64      buildonly-randconfig-1005-20260917    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260917    clang-22
x86_64                randconfig-1001-20260917    clang-22
x86_64                randconfig-1002-20260917    clang-22
x86_64                randconfig-1003-20260917    clang-22
x86_64                randconfig-1004-20260917    clang-22
x86_64                randconfig-1005-20260917    clang-22
x86_64                randconfig-1006-20260917    clang-22
x86_64                randconfig-1007-20260917    clang-22
x86_64                randconfig-1008-20260917    clang-22
x86_64                randconfig-1009-20260917    clang-22
x86_64                 randconfig-101-20260915    clang-22
x86_64                 randconfig-101-20260916    clang-22
x86_64                randconfig-1010-20260917    clang-22
x86_64                randconfig-1011-20260917    clang-22
x86_64                randconfig-1012-20260917    clang-22
x86_64                randconfig-1013-20260917    clang-22
x86_64                randconfig-1014-20260917    clang-22
x86_64                randconfig-1015-20260917    clang-22
x86_64                randconfig-1016-20260917    clang-22
x86_64                randconfig-1017-20260917    clang-22
x86_64                 randconfig-102-20260915    clang-22
x86_64                 randconfig-102-20260916    clang-22
x86_64                 randconfig-103-20260915    clang-22
x86_64                 randconfig-103-20260916    clang-22
x86_64                 randconfig-104-20260915    clang-22
x86_64                 randconfig-104-20260916    clang-22
x86_64                randconfig-1300-20260917    gcc-14     sparse
x86_64                randconfig-1301-20260917    gcc-14     sparse
x86_64                randconfig-1302-20260917    gcc-14     sparse
x86_64                 randconfig-161-20260915    clang-22
x86_64                 randconfig-161-20260916    gcc-14
x86_64                randconfig-r064-20260915    gcc-13.4.0
x86_64                randconfig-r071-20260915    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.1.0
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                   cadence_csp_defconfig    gcc-16.1.0
xtensa                           iss_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20260917    clang-17
xtensa                randconfig-1001-20260917    clang-17

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

