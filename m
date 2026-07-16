Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA13AC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839186B0099; Thu, 16 Jul 2026 17:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8C56B00B1; Thu, 16 Jul 2026 17:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA7D6B00B5; Thu, 16 Jul 2026 17:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 309286B0099
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:35:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DB831C02D0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:35:53 +0000 (UTC)
X-FDA: 84995947386.01.2FA2B47
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23C01C0007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:35:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=brGSyxkl;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784237751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9lGnkfd0zXd7/NOFmodQ6hyFFAfXEwrJtoqb972WifA=;
	b=VJeidXEEgD8srRgh1GpH7m9oASDpmV90wXs5lPSOGqoggwNb1YAi3Hm61ubqaDo4Yuyx6b
	pyW87ap9CRoJKogZtUeZzlVzxOHE/fxCh3NlUoN7kIB7RCQ6+X8dxalAXOGC3GOfwmeOZd
	W5Zg9EBZPzAueRfwIeggWA5w+grn5Ig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=brGSyxkl;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784237751;
	b=seOZYEhGcEdGLoTJmMkz9MuL2v50dnAxOcNT1wFV/s0MZgX+/v6GzVJZtgySDXBYXxXUkt
	BANPLDD3efLTMabX2LQYa5KCE76qk8arX6faobdfr7ZkkmcV7GhBUs4wFeQYzp3YgM+LsT
	ezroK06GPYY3LhtYuWRosx5e8qgowoU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784237751; x=1815773751;
  h=date:from:to:cc:subject:message-id;
  bh=a6yFI7aDgAffL/bIbOD7svnq1zNIaV7l335CCnMyWZE=;
  b=brGSyxklg8FDyjNgcFkLF9IB9PQEJb98IcxihImt+K/MTkRkTN00ABdS
   mhYlQUL3PT8COVCvzAyq31bo7LrLMB2paKvgz72/ltqfBjC+udtWFTTbg
   wed3apYXubDbV/kUoou8GcaBTDhvTS7DoJcPXzl/sdNSR2/gwbeO8/H9f
   EgxTmY/egI6c9vX7tfzTND8ZaovzXp4nW+IKfJMWTuq07BMGyQuNbrS/n
   qAvugbe8EDuNHf+u1MBdTS8SprUizjYL6QiDHzAroLhhDz09zIQwYFiFC
   dpxKFIc1ic8OkChSeHUomCCzVB1OOF5agFSp78tSPcsT31+K4BiKNrtBb
   g==;
X-CSE-ConnectionGUID: ByGsKul/TOGRpuxH+8C9pg==
X-CSE-MsgGUID: SFKuh7rNQiG6xViNNGORzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="85002918"
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="85002918"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 14:35:50 -0700
X-CSE-ConnectionGUID: OWAnvAM3RXiUbF3VLwutpA==
X-CSE-MsgGUID: aZrc3psrRtC+vxqqMbw+Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,168,1779174000"; 
   d="scan'208";a="252614856"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 16 Jul 2026 14:35:48 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wkTk1-00000000QGS-2fzV;
	Thu, 16 Jul 2026 21:35:41 +0000
Date: Fri, 17 Jul 2026 05:19:51 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 4f032f512d9fc5a9ae438e6efd9d8e94fbaaa36c
Message-ID: <202607170529.cevcUTLV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23C01C0007
X-Stat-Signature: e31kk6819ykthfw1tt3p94uwbbtpqjfg
X-HE-Tag: 1784237750-68600
X-HE-Meta: U2FsdGVkX19a/Q4ScZfK+KUd9ui+SlGG97kbEYyz1k1fM33GceNwUlhCbOGkaHrzNIt12P9P079Kp/KOAEm8zIh7BZF3HIwK3qi/9YdywWRN9vmq+sx3qsQwhGt8xx+o6Vp2gLeqOtdf3kG3IL9TpvMdaWB8YbhSX9PEwxEeOSmVuO7oSPXTJ+fg+wVweWjkzdTqZGYaHE2zLs4Og8JIC9QHxOfpy1HrfBxKuG7qopn1MwbjlYJ04UD6WxPhDvdy1yPfwRyu6SKdX+/8RbdPxD9DnUrr01SjNO4/jt20l1xFUxUg2Ljqf/idvcdHelos69XaHLPjhr0QwcyupuMvJ/GW5u9ZMPkz1HnLvtKp0owWglS1rQJDV6bmCsOBarChT4+qG3e8tEFV18/DjB4P9d0Sr3cTiIlZusTcjPlCWoDBXarQSp6ORuA/knKcJ95dvWAbdbCHktpug1y0rtP7k/RgpDG0UV81ViuAKzthQ3QVsTblJA7VWAjJm7E/qXOVDC5GZGVt8hXsSxasoxLIv8bvpSvyOXzHhYjVp37nWNBlJIt7z/TniEVo9hm3BIFV75ZE2vEJgtBiYSuxjv86rCB9+bTRSwkkfVIauh+RUudq7xApXJOfy/lqLq4dDlQ+/x0ZL6YDQkeEF3wr44TBMUFgGRcC07u3NS/WqtGX3vpN53W7pmp34MmRTAoPBGj1ijxgiUOxE69gBFo0W2hzIrnNL6je2Ogia0aU64G5KOJKbp4+jDZmvhk+wck3WV74gwaNbcYnfDw37VBpjExEn3Y7sKWtEq1lUJ26FxmOX4Ri4BO46U5N2nsf9gsV1FwfzlNkwih//OlA3HNM6I+SUBG8Iht8We8PT83i4v9XGFia+JyieKVWOf6iBcKTr5A4jG7r4NUCwkkgc6YuhFM7f6J8qvdE3tDeQw1kHL2ByboIWayP2Q/y0hKi6gwZlOMFU9WiDHUKA3kYfqKRxqO
 BWT4JPeW
 6IJT2l7gVEGoZO0Ekns1ExpkbPJHbh9aLdpVELowWjYUUzNpzNGHHz9RfKUG0Kk9ze8XM6ExzaoeiLs59Ah4KF1BNere0icUpaOsbsYW43wqeflpSFfd046qa+HpRA2WcgzkvoZwiRCISWj1/tbl9wuqVVm10F9uhzxHlEUVbr7pS0+yalKBLBPyhgRQm0h4GgmWS0MJBCh/qPw8RMTGHuF7yDIKXc8o1/o6B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4f032f512d9fc5a9ae438e6efd9d8e94fbaaa36c  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:672 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 653)

Warning ids grouped by kconfigs:

recent_errors
`-- i386-randconfig-141-20260716
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1292m

configs tested: 191
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260716    gcc-14.3.0
arc                   randconfig-002-20260716    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260716    gcc-8.5.0
arm                   randconfig-002-20260716    clang-17
arm                   randconfig-003-20260716    gcc-12.5.0
arm                   randconfig-004-20260716    clang-24
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260716    clang-24
arm64                 randconfig-002-20260716    clang-22
arm64                 randconfig-003-20260716    clang-24
arm64                 randconfig-004-20260716    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260716    gcc-12.5.0
csky                  randconfig-002-20260716    gcc-14.3.0
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260716    clang-24
hexagon               randconfig-002-20260716    clang-24
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260716    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260716    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260716    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260716    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260716    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260716    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260716    clang-22
i386                  randconfig-002-20260716    clang-22
i386                  randconfig-003-20260716    gcc-14
i386                  randconfig-004-20260716    gcc-14
i386                  randconfig-005-20260716    clang-22
i386                  randconfig-006-20260716    clang-22
i386                  randconfig-007-20260716    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260716    clang-22
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260716    gcc-12
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260716    clang-22
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260716    gcc-12
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260716    clang-22
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260716    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260716    clang-22
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260716    clang-20
loongarch             randconfig-002-20260716    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260716    gcc-8.5.0
nios2                 randconfig-002-20260716    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260716    gcc-15.2.0
parisc                randconfig-002-20260716    gcc-8.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                    mvme5100_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260716    clang-21
powerpc               randconfig-002-20260716    clang-19
powerpc64             randconfig-001-20260716    clang-22
powerpc64             randconfig-002-20260716    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-001-20260716    gcc-14.3.0
riscv                 randconfig-002-20260716    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260716    clang-24
s390                  randconfig-002-20260716    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260716    gcc-16.1.0
sh                    randconfig-002-20260716    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260716    gcc-13.4.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260716    gcc-11.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260716    clang-24
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260716    clang-24
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-24
um                    randconfig-001-20260716    clang-24
um                             randconfig-002    clang-24
um                    randconfig-002-20260716    gcc-14
um                           x86_64_defconfig    clang-24
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260716    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260716    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260716    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260716    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260716    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260716    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260716    gcc-12
x86_64                randconfig-002-20260716    gcc-14
x86_64                randconfig-003-20260716    clang-22
x86_64                randconfig-004-20260716    clang-22
x86_64                randconfig-005-20260716    clang-22
x86_64                randconfig-006-20260716    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260716    clang-22
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260716    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260716    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260716    clang-22
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260716    clang-22
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260716    gcc-14
x86_64                randconfig-071-20260716    clang-22
x86_64                randconfig-072-20260716    clang-22
x86_64                randconfig-073-20260716    clang-22
x86_64                randconfig-074-20260716    gcc-14
x86_64                randconfig-075-20260716    clang-22
x86_64                randconfig-076-20260716    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260716    gcc-9.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260716    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

