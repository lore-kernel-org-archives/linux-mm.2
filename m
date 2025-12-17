Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0EFD65C73
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0812D6B0005; Wed, 17 Dec 2025 11:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E9E6B0089; Wed, 17 Dec 2025 11:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CEC6B008A; Wed, 17 Dec 2025 11:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D69BD6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:00:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8292D160B6E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:00:00 +0000 (UTC)
X-FDA: 84229424160.21.DBA853D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC07F1A001A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:59:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ckb3iZsO;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765987198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=xUyvqhU8aUIhMwYNJ4FtO3mb21aP+vz4SLoq2uYdhlA=;
	b=aMfQ6Gc3qcKE3DJBJKGyyACKRwsGBGzGtYtT7v9yJRU2OKBo6p1T7viaTFNMYb9IoyJ08p
	tFahdNqLa/wHPtXFNBAnr38MhDTQ2tMb/zqQdK9TlLreChIPvdRcEyUtFXol2sl2mkxYMl
	7DbYwsPgroscIKXs5q3VdeYBJpMyyQQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ckb3iZsO;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765987198; a=rsa-sha256;
	cv=none;
	b=m5XvI5LdB9Np1SFnwgD+hZ5iwLsJ1F4wWhNu994g+oPVpO6/PhryUDJ5rZCtS1ns4cmjgy
	/J5jceyjWzrhFMRWCAnRA3y1XJvsR3RNdDI7qTEDg5ZlWJEA6G7RDMShRZ0+Dc56sRkNJn
	SeHQAicMk6FqEvgUQWdEnPmJkf6n6LE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765987198; x=1797523198;
  h=date:from:to:cc:subject:message-id;
  bh=Cz72uo24UkUuRyQ5Yja7LSB+KC+05ljBon4saiI+Fpc=;
  b=Ckb3iZsOLdFkf6jmdoEzTKKb7qJMZitxaP08oBwClXvY+TZV4Npt+iK7
   Gaf4rT58GkVB1szTk11ijyN+VVFqnVBtfaH85qT+rCPlTEwQWjk7vQBsd
   YBzLdVNrf8/5BFKN2YCxbd6NLStV3j684K+bPEmcapXkOvN8SOF/QwaJf
   SHf/R9XceY87hdi8aeI1XQKZ3P0VdUoBWeJGX3ZCq6y28yLucqFkLrYgg
   Y8tSH1Cz5aEFoUfByOFalFGUjyvSiL29zRpyZNTyEt4KM44ceS2qlgTmz
   guDCcD0oNorhlItpqt5y4K2rMJbxWHqCHy3FkkcC0fK/RgUbWsTDlJDkb
   w==;
X-CSE-ConnectionGUID: n8LqEn65Qgyugacyl7wLDg==
X-CSE-MsgGUID: vbWYC66oTw6OLZ6R4tX9dQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67893633"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67893633"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 07:59:56 -0800
X-CSE-ConnectionGUID: VcRd/1sdRuKBFssKkzX/KA==
X-CSE-MsgGUID: OUNvzGZ4T/qycMEw5TofaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198407461"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Dec 2025 07:59:54 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVtwO-000000000s1-0Wx8;
	Wed, 17 Dec 2025 15:59:52 +0000
Date: Wed, 17 Dec 2025 23:59:03 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 12b95d29eb979e5c4f4f31bb05817bc935c52050
Message-ID: <202512172355.qiP8Qj6W-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Stat-Signature: 96o4br3hbid7rq4iz9ejjzzcogro64e9
X-Rspam-User: 
X-Rspamd-Queue-Id: EC07F1A001A
X-HE-Tag: 1765987197-235433
X-HE-Meta: U2FsdGVkX19Wnt0zX6Mt21uUh5NU5la6vhYcWWPuzDZi6FFz6ouIZmklcZvdpnn75QLdnHgvWxtL0Vse8BbuIoUvlDRdrm31sDw0596tblrRzynOHy8i1c1KvPNp+Ym22vKlDa+y0rPP+WZ1loY9M9kw5Pm1lcSTogqthPeKxqOmFidJ6huAMnzpruKXyEzEP0VbfnUtw+HjraOH3ghE39pdbjDzufiqRWcIYDjZPe0Irc7Vn/4h1UoXSH7CPxDQPU8SVABdCHDkudMasicRfIwKF5DqhTjHZH7gnGntWfJoSVDOAyyzQRHLK3i3Z66dd51LwOMNrGBjli8UO6NYzZsegr/WMadoo54j0oJHJnYFoGAnjtOb7AmjRjQ1ghbOPQ37o0aua24rPWACRdk7h3tM24R+4oLlvTAPv4Mp380nk8c+OosWy1eEzZGiUs0CHv4VVitYB4JwSg6AaTBBAMxB13yeQ6nAddCUt4flogWvvFGxPWk94ukVdvx41wRbcnszhJM+EJ0LFjrYvVWC3D5NdDsoF1rI34m7CuM4pR/HpVJR5PcSQ3+WBTKcEc+FI0L7R4uaEOU3UpOx/u4mkfa5/3vdOn38+U65RrIyjRuJcpj4TVIe8TZ7/rLCKkOvgFiEkyAOJ8n83lWAn+U3SUXnbKba00z0SDXzW2gEOOXL8/mzb8xaNsKYQc/B7EFsGDYVbU9QZ6dqHtX9CAv49OFwlzpP8n5IE3cd7RdTvJ9RwC9BRnXm7v4pcwG6qlG8FCMJcuB3W5SAYFhaVEM+x9MEAF/Gk8BwyeMnvN6MMBwal8Y6aT/o2ntCxItVRUhCAKMzMOBF6EdZGSReOUHCtjQ36SKVeYSm0hwLqkYO/DNuC7bdWPTAEdtyWJ4knmw8Z79vY27Ebv8VobWyRZxKkGtHGR/yvC9GagRQTYwDSq93CuA220QsG57K3FWYH5J1dNDYxHbuZRXB4obb6C1
 TKM26ZjO
 ON0ydiPo53bdL8GHhXMI67PtN+5DxicRwNZmUhzO9B9rtSOfGKqNBcEOsJfeb+smHxQ1v9Rs6hmzIE7PWRdKEGt6tIvZ6APZPOgrR+GVLra9rbt8e37IFjG1BextP+0DiHFVs2yGmDo/jmAE0FUhzvf4MPYiptlxm1Xce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 12b95d29eb979e5c4f4f31bb05817bc935c52050  Add linux-next specific files for 20251217

Unverified Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/sitronix/st7571.c:916:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/xe/xe_device.c:843 detect_preproduction_hw() error: uninitialized symbol 'gt'.
    drivers/mmc/host/dw_mmc.c:597 dw_mci_prepare_desc() error: uninitialized symbol 'desc'.

Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-r073-20251216
|   `-- drivers-gpu-drm-xe-xe_device.c-detect_preproduction_hw()-error:uninitialized-symbol-gt-.
|-- microblaze-randconfig-r073-20251217
|   `-- drivers-mmc-host-dw_mmc.c-dw_mci_prepare_desc()-error:uninitialized-symbol-desc-.
`-- riscv-randconfig-r111-20251216
    `-- drivers-gpu-drm-sitronix-st7571.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 729m

configs tested: 174
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251217    gcc-8.5.0
arc                   randconfig-002-20251217    gcc-10.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20251217    clang-18
arm                   randconfig-002-20251217    clang-22
arm                   randconfig-003-20251217    clang-22
arm                   randconfig-004-20251217    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251217    gcc-8.5.0
arm64                 randconfig-002-20251217    clang-22
arm64                 randconfig-003-20251217    clang-22
arm64                 randconfig-004-20251217    clang-20
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251217    gcc-15.1.0
csky                  randconfig-002-20251217    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251217    clang-22
hexagon               randconfig-002-20251217    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251217    clang-20
i386        buildonly-randconfig-002-20251217    gcc-14
i386        buildonly-randconfig-003-20251217    gcc-13
i386        buildonly-randconfig-004-20251217    clang-20
i386        buildonly-randconfig-005-20251217    gcc-14
i386        buildonly-randconfig-006-20251217    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251217    clang-20
i386                  randconfig-002-20251217    clang-20
i386                  randconfig-003-20251217    clang-20
i386                  randconfig-004-20251217    gcc-14
i386                  randconfig-005-20251217    gcc-13
i386                  randconfig-006-20251217    clang-20
i386                  randconfig-007-20251217    clang-20
i386                  randconfig-011-20251217    gcc-14
i386                  randconfig-012-20251217    clang-20
i386                  randconfig-013-20251217    clang-20
i386                  randconfig-014-20251217    clang-20
i386                  randconfig-015-20251217    gcc-14
i386                  randconfig-016-20251217    gcc-14
i386                  randconfig-017-20251217    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251217    clang-22
loongarch             randconfig-002-20251217    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                           virt_defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                         3c120_defconfig    gcc-11.5.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251217    gcc-11.5.0
nios2                 randconfig-002-20251217    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251217    gcc-15.1.0
parisc                randconfig-002-20251217    gcc-14.3.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                      chrp32_defconfig    clang-19
powerpc                       ebony_defconfig    clang-22
powerpc               randconfig-001-20251217    gcc-8.5.0
powerpc               randconfig-002-20251217    clang-22
powerpc64             randconfig-001-20251217    gcc-14.3.0
powerpc64             randconfig-002-20251217    clang-18
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                    nommu_k210_defconfig    clang-22
riscv                 randconfig-001-20251217    gcc-14.3.0
riscv                 randconfig-002-20251217    clang-18
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251217    gcc-10.5.0
s390                  randconfig-002-20251217    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251217    gcc-15.1.0
sh                    randconfig-002-20251217    gcc-12.5.0
sh                   secureedge5410_defconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251217    gcc-15.1.0
sparc                 randconfig-002-20251217    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251217    clang-20
sparc64               randconfig-002-20251217    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251217    clang-22
um                    randconfig-002-20251217    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251217    clang-20
x86_64      buildonly-randconfig-002-20251217    clang-20
x86_64      buildonly-randconfig-003-20251217    gcc-13
x86_64      buildonly-randconfig-004-20251217    gcc-14
x86_64      buildonly-randconfig-005-20251217    gcc-14
x86_64      buildonly-randconfig-006-20251217    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251217    clang-20
x86_64                randconfig-002-20251217    gcc-14
x86_64                randconfig-003-20251217    clang-20
x86_64                randconfig-004-20251217    clang-20
x86_64                randconfig-005-20251217    clang-20
x86_64                randconfig-006-20251217    gcc-14
x86_64                randconfig-011-20251217    clang-20
x86_64                randconfig-012-20251217    gcc-14
x86_64                randconfig-013-20251217    clang-20
x86_64                randconfig-014-20251217    gcc-14
x86_64                randconfig-015-20251217    gcc-14
x86_64                randconfig-016-20251217    gcc-14
x86_64                randconfig-071-20251217    clang-20
x86_64                randconfig-072-20251217    gcc-13
x86_64                randconfig-073-20251217    gcc-14
x86_64                randconfig-074-20251217    clang-20
x86_64                randconfig-075-20251217    clang-20
x86_64                randconfig-076-20251217    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251217    gcc-8.5.0
xtensa                randconfig-002-20251217    gcc-15.1.0
xtensa                    smp_lx200_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

