Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA9ED4335B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 01:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FFE6B0005; Thu, 11 Dec 2025 20:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2116B0006; Thu, 11 Dec 2025 20:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942976B0007; Thu, 11 Dec 2025 20:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77D416B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:31:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24E9B1403D7
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:31:15 +0000 (UTC)
X-FDA: 84209090910.23.8D7A5E3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 220471A0015
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:31:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aAY/tYGT";
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765503072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9CU4/kqlPOKIrhnVZj8TGGKSW4Jxidb27csxH3tO18Y=;
	b=zc2I1pN533hU0G9dIbqApVir+me6NF/WhTw/g2IXPDm6x9qDe85j4lkumALhBAAUFT8WUc
	wv5XL6I3j16CMOQfRmFagngZY5nFs0MY1xcPf4d0708fRPcnBff33yh1mh3CVKsqxUKSDg
	XyvmIGMzICVhYVrx5HoZp8V8eiZrFM0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aAY/tYGT";
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765503072; a=rsa-sha256;
	cv=none;
	b=KhTpKUd4KC+M2Gu/MkaRfSnDBWx3IUHhTsseWtpyq58P3JtBCaMGredTGD2oGec8b6KVun
	N7n/EBa9XNauLVNThs4gdJLr1zPiriFlf8BaK2kzdh81Z06h2pk/UsAEupQ91Vs55PXG2S
	32+8Bw/Tx4RVnirtPAVEgFdQgIIj4Kg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765503072; x=1797039072;
  h=date:from:to:cc:subject:message-id;
  bh=H9xYKVeCSiFiHreqwvcYp8S2Czdr2LMNj9szI9/P80A=;
  b=aAY/tYGTHIRsFGNETkF76h00bUUDQgsG71acs4S1+cNkTA757jWBqTcQ
   J7i1niPUi0JEkp/zG93NwATIc+y04LocMJhSCkqyBw+C6mhcbRQ6hQDfW
   zjg8DSNALX+Xbg2pvLLDuMVuY2aYlkQ94jcb4DVidTYvb6lujdWeL+3kq
   j17YJZ/SJU0/pc0k/ccXif7EyWt4fQXZP08j+7/yp/+bOCa4ztX7HyTTN
   Xz5WTZ06pKGVGii9nSFJb08BcyykHt9JOrdOmdIpYN97JqDJ4A7E4wMNJ
   RhW+T6jw+2ySZ0Co4bxMxBMfOu0TFq+nu25TjCD1ySjUicA9T3wADfHlR
   Q==;
X-CSE-ConnectionGUID: R2F/rkU3QpG0VM2cbvxTNQ==
X-CSE-MsgGUID: D08R5vD7TlumpDa8+R6MBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71363373"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71363373"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:31:10 -0800
X-CSE-ConnectionGUID: V4HuCrNLQ/apAgZGKwMJRg==
X-CSE-MsgGUID: Q5BKujBuQJCgPUF2IQE8Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197219741"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 11 Dec 2025 17:31:09 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTrzu-000000005JN-1lC2;
	Fri, 12 Dec 2025 01:31:06 +0000
Date: Fri, 12 Dec 2025 09:30:57 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 5ce74bc1b7cb2732b22f9c93082545bc655d6547
Message-ID: <202512120949.o1NbeCBE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 220471A0015
X-Stat-Signature: buh55m6dwwzbca3r1d6yriz6gh4ymmca
X-Rspam-User: 
X-HE-Tag: 1765503070-703231
X-HE-Meta: U2FsdGVkX1/0sfeE/vOoimG5/187YLpVrNKcbSrFRfMqKhqqwVb9gJ5geU9G0h797L5zOx7X2H2f/+HX1ld5UTVRmpiBTKBD3mN1QQOw/n1VpBtd2mbpASm/MDypERImqNpV93RSiAZRwwZM11RxIv6x+UIWYiBwD3VfADvHuHUR0K6NjszmCoMGsZdngWKWJXJSC6EY7nuREiNgS0/f3drNulfa393XIbfYbbz2Gf/0kDPnGy2ZYGJ/MdaKg/rXIQn0VC43sJB1viY1SDF5rp7tcHdsO4glDTfrRVnjnW0rqLy/Ma20NJDHhTIpmW82n2WF6VG1x7nkZfIKk2FSI4hsa2wuU5HLjKckvpDQeachMIKebewJzTpKFZ+LWJtM704duurfDAUfWqQTmCzAHaOYhkDuVs5liSGGFiaYZVjXIUnoNha5Gy7lbxYasNpzMP3D5dK3HVD5eitCVPsHzvNz1cA031OyMmpCF1ZfD16GWmqlxbKnHa+K9GSxCGTT2kFJU0F0PDCoVXfkSD6AF7virPeWdCZtbRYNeEhNPGwvWotqGZx/PO0VAlg+fK3ppffHhq47NWxSrjPL4MjmA7SqaZQupEvCu3LudsF+CAi3k0FLHeayyLC2sIej/mOS2YRSm+JmgGoYh9126Ds+ABmZTuslLd9IR9ffBlufyS7/0M/Ft+JwWVJiJDe+aODOrzc6TWwFtNRkh11weOS2VSq+q1ny/ALIrl0HihPDisiRrnIZHpAv69jJqK1ToI3IiXgyZrLZ2pD10C7ZzigR9M3c0j1eX4EGNDNR0eyg//DES9wmkUGFmi3allriFLSh3kmLbIeyZlHuh+D+i1IfoYgymVe234bCvVfp5Wawk7UpU4zZ0DOANWEG5uL9c4+CQP2A8WhbBKhWH2Jx1+oLIehI99GI+FH7+NwR6Gt7xUjrNI0UOnbrMh9+fLOHgYRfnl7xrb63dyw1kyi9BKl
 aStszt3Z
 Vv315zezoPATsb4Is6CxygCmXX9GAZGx65PrN9PnPVL45OI2ui5P9QmKUeaPMNpfEYB2dqCOGLEJY8u5S8rhd/O+xCKyPi/KW4sGkG4zEvzUCmOKjJVi0LzM0iKzRqJE3YjWLiYrq8jx/laLd71waKHeVT2wJVeH7/xRh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5ce74bc1b7cb2732b22f9c93082545bc655d6547  Add linux-next specific files for 20251211

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.exception.text+0x247): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: make_task_dead
    drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c:52:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/amd/amdgpu/imu_v12_1.c:35:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/amd/amdgpu/mes_v12_1.c:35:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/amd/amdgpu/psp_v15_0_8.c:34:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c:46:1: sparse: sparse: bad integer constant expression
    drivers/ufs/core/ufs-rpmb.c:253:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- x86_64-randconfig-123-20251210
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v12_1.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v12_1.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-amd-amdgpu-mes_v12_1.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-amd-amdgpu-psp_v15_0_8.c:sparse:sparse:bad-integer-constant-expression
|   `-- drivers-gpu-drm-amd-amdgpu-sdma_v7_1.c:sparse:sparse:bad-integer-constant-expression
`-- xtensa-randconfig-r121-20251205
    |-- (.exception.text):dangerous-relocation:windowed-longcall-crosses-1GB-boundary-return-may-fail:make_task_dead
    `-- drivers-ufs-core-ufs-rpmb.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 1362m

configs tested: 257
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251211    gcc-8.5.0
arc                   randconfig-001-20251212    clang-22
arc                   randconfig-002-20251211    gcc-14.3.0
arc                   randconfig-002-20251212    clang-22
arm                              alldefconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                          collie_defconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.1.0
arm                   milbeaut_m10v_defconfig    clang-19
arm                   milbeaut_m10v_defconfig    gcc-15.1.0
arm                   randconfig-001-20251211    gcc-8.5.0
arm                   randconfig-001-20251212    clang-22
arm                   randconfig-002-20251211    gcc-10.5.0
arm                   randconfig-002-20251212    clang-22
arm                   randconfig-003-20251211    clang-22
arm                   randconfig-003-20251212    clang-22
arm                   randconfig-004-20251211    clang-22
arm                   randconfig-004-20251212    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251211    clang-22
arm64                 randconfig-002-20251211    clang-22
arm64                 randconfig-003-20251211    gcc-14.3.0
arm64                 randconfig-004-20251211    clang-16
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251211    gcc-11.5.0
csky                  randconfig-002-20251211    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251211    clang-19
hexagon               randconfig-001-20251212    gcc-11.5.0
hexagon               randconfig-002-20251211    clang-17
hexagon               randconfig-002-20251212    gcc-11.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251211    clang-20
i386        buildonly-randconfig-001-20251212    gcc-14
i386        buildonly-randconfig-002-20251211    gcc-14
i386        buildonly-randconfig-002-20251212    gcc-14
i386        buildonly-randconfig-003-20251211    clang-20
i386        buildonly-randconfig-003-20251212    gcc-14
i386        buildonly-randconfig-004-20251211    gcc-13
i386        buildonly-randconfig-004-20251212    gcc-14
i386        buildonly-randconfig-005-20251211    gcc-14
i386        buildonly-randconfig-005-20251212    gcc-14
i386        buildonly-randconfig-006-20251211    gcc-13
i386        buildonly-randconfig-006-20251212    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251211    gcc-14
i386                  randconfig-002-20251211    clang-20
i386                  randconfig-003-20251211    clang-20
i386                  randconfig-004-20251211    gcc-14
i386                  randconfig-005-20251211    clang-20
i386                  randconfig-006-20251211    gcc-14
i386                  randconfig-007-20251211    clang-20
i386                  randconfig-011-20251211    gcc-14
i386                  randconfig-012-20251211    gcc-12
i386                  randconfig-013-20251211    clang-20
i386                  randconfig-014-20251211    clang-20
i386                  randconfig-015-20251211    clang-20
i386                  randconfig-016-20251211    clang-20
i386                  randconfig-017-20251211    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251211    gcc-14.3.0
loongarch             randconfig-001-20251212    gcc-11.5.0
loongarch             randconfig-002-20251211    clang-18
loongarch             randconfig-002-20251212    gcc-11.5.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.1.0
m68k                          atari_defconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
m68k                        m5307c3_defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                         rt305x_defconfig    gcc-15.1.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251211    gcc-8.5.0
nios2                 randconfig-001-20251212    gcc-11.5.0
nios2                 randconfig-002-20251211    gcc-8.5.0
nios2                 randconfig-002-20251212    gcc-11.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
openrisc                  or1klitex_defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251211    gcc-14.3.0
parisc                randconfig-001-20251212    clang-22
parisc                randconfig-002-20251211    gcc-8.5.0
parisc                randconfig-002-20251212    clang-22
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc               randconfig-001-20251211    clang-22
powerpc               randconfig-001-20251212    clang-22
powerpc               randconfig-002-20251211    clang-22
powerpc               randconfig-002-20251212    clang-22
powerpc64             randconfig-001-20251211    gcc-8.5.0
powerpc64             randconfig-001-20251212    clang-22
powerpc64             randconfig-002-20251211    gcc-13.4.0
powerpc64             randconfig-002-20251212    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251211    clang-22
riscv                 randconfig-001-20251212    clang-17
riscv                 randconfig-002-20251211    gcc-11.5.0
riscv                 randconfig-002-20251212    clang-17
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251211    gcc-11.5.0
s390                  randconfig-001-20251212    clang-17
s390                  randconfig-002-20251211    clang-22
s390                  randconfig-002-20251212    clang-17
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                               j2_defconfig    gcc-15.1.0
sh                    randconfig-001-20251211    gcc-15.1.0
sh                    randconfig-001-20251212    clang-17
sh                    randconfig-002-20251211    gcc-10.5.0
sh                    randconfig-002-20251212    clang-17
sh                          sdk7786_defconfig    gcc-15.1.0
sh                           se7712_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251211    gcc-11.5.0
sparc                 randconfig-001-20251212    gcc-8.5.0
sparc                 randconfig-002-20251211    gcc-8.5.0
sparc                 randconfig-002-20251212    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251211    gcc-8.5.0
sparc64               randconfig-001-20251212    gcc-8.5.0
sparc64               randconfig-002-20251211    gcc-8.5.0
sparc64               randconfig-002-20251212    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251211    clang-22
um                    randconfig-001-20251212    gcc-8.5.0
um                    randconfig-002-20251211    gcc-14
um                    randconfig-002-20251212    gcc-8.5.0
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251211    gcc-14
x86_64      buildonly-randconfig-002-20251211    gcc-14
x86_64      buildonly-randconfig-003-20251211    clang-20
x86_64      buildonly-randconfig-004-20251211    clang-20
x86_64      buildonly-randconfig-005-20251211    gcc-14
x86_64      buildonly-randconfig-006-20251211    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251211    gcc-14
x86_64                randconfig-002-20251211    clang-20
x86_64                randconfig-003-20251211    gcc-12
x86_64                randconfig-004-20251211    clang-20
x86_64                randconfig-005-20251211    gcc-14
x86_64                randconfig-006-20251211    gcc-14
x86_64                randconfig-011-20251211    gcc-14
x86_64                randconfig-011-20251212    clang-20
x86_64                randconfig-012-20251211    gcc-14
x86_64                randconfig-012-20251212    clang-20
x86_64                randconfig-013-20251211    clang-20
x86_64                randconfig-013-20251212    clang-20
x86_64                randconfig-014-20251211    clang-20
x86_64                randconfig-014-20251212    clang-20
x86_64                randconfig-015-20251211    clang-20
x86_64                randconfig-015-20251212    clang-20
x86_64                randconfig-016-20251211    gcc-14
x86_64                randconfig-016-20251212    clang-20
x86_64                randconfig-071-20251211    gcc-14
x86_64                randconfig-072-20251211    clang-20
x86_64                randconfig-073-20251211    gcc-14
x86_64                randconfig-074-20251211    clang-20
x86_64                randconfig-075-20251211    clang-20
x86_64                randconfig-076-20251211    clang-20
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
xtensa                randconfig-001-20251211    gcc-11.5.0
xtensa                randconfig-001-20251212    gcc-8.5.0
xtensa                randconfig-002-20251211    gcc-15.1.0
xtensa                randconfig-002-20251212    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

