Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B588610F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 11:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95526B008C; Sat, 28 Mar 2026 07:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D462C6B0095; Sat, 28 Mar 2026 07:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BF36B0096; Sat, 28 Mar 2026 07:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B63A76B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:38:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AFA616011F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:38:33 +0000 (UTC)
X-FDA: 84595274106.22.3373301
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3164B1C0015
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:38:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MzGcj1EL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774697911; a=rsa-sha256;
	cv=none;
	b=4+jSByiOrYz4o1Wy4qFWIccN9xcN8qA8nED2D6SES2IaMDYKMjz2VtCklzZqoF8+1BC/6b
	ZvV4nqlLkNNeCJgSEptiEuuUm78ycxnb+c7FXX4Fhwnzt/tXan22d8gpto9Z9kq+TvNbPR
	xMYKgdSN+nhjsV4Na92+dt9b7eGvnKQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MzGcj1EL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774697911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LF2CdVjlcjVcud/X95Bs9eYig4NF52XE4q7gRu0jEac=;
	b=tkc0CEmBP27OPqmj8qUxM5yWDVqvJyIliw6hhobO33vo0AljyOLzThoHEg7uxiNnrgsbhk
	CtVLQZ2nQaoemNhbAAvFsls53N41NhwTLqDIGebrb4XZzHUps3Bko5E4e3H4Su9X2PQJEC
	mMDoBl15cly/YWQyEFJzkSl36Qj4E18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774697910; x=1806233910;
  h=date:from:to:cc:subject:message-id;
  bh=5Rr4AooKKmfJgYDb66FBUnjjc6oJI+QMw2TI8Kc8uKQ=;
  b=MzGcj1ELOsfjQ2r+/npyPPaajiEB7uZCXdpSAUyZ31ed1Ko6uG6cF2gZ
   wRMh4zY2mOkb32g+1ctNVjB4tEWfuc6By65gkiwQigF+t2FpN3buD4r1k
   xUfjUO8rCaT1SvP78Te3iNl3Lfl31wRVh2bVhj6OVJHznxan+zK4XGh7w
   WuEZ52E1nUq3QsNA6gphEnxS21uEbnoKsz9G1xpo75DtXvs/g75TxOeNM
   8R/ZrtPRqx8Go2pnX2yG/1U2A3CHy2A2ANXZciHhp7KPb20V4tjcg5/6J
   Pi+zE4+8UuW5rowzccUNadq4cmZ7nrXmkEQ/WOC+hhKAJkMWYy1eG2fPj
   g==;
X-CSE-ConnectionGUID: jpXeQCulRdWveUVu895x/Q==
X-CSE-MsgGUID: 0p7QDJNbR+mrCG7xngmUVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75726242"
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="75726242"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 04:38:28 -0700
X-CSE-ConnectionGUID: qKA+b5gMQ+aazLXUe1E77Q==
X-CSE-MsgGUID: AQ48FAU6RsCV8gO72pW0ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="224593753"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 28 Mar 2026 04:38:27 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6Rzk-00000000BMl-0ryX;
	Sat, 28 Mar 2026 11:38:24 +0000
Date: Sat, 28 Mar 2026 19:37:58 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 3b058d1aeeeff27a7289529c4944291613b364e9
Message-ID: <202603281945.WmgE4oTf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 3164B1C0015
X-Stat-Signature: qjcqkjxzoa9pg8mk4muwgqmdyu1x8ozo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774697909-136056
X-HE-Meta: U2FsdGVkX1/H0pMBD2GocGyilYIWue70ugN0ZvOybUfxByaE9WLaP3Ohzo9FkuOXBJVP+hzC5w4h6t2xnTusmzTImJwKO6iIerKRVb2VyuHL9SvdPmNd+qggvQ5Oz4O65oXCS7kUEP1kQBZML9hnhcwa2Ohn68vUj2n65IXxU+5hqs63BGXHPzR1jXHaUL6GxnnnFZ6NDAMAmUlOZr7t2orfIjfcim6n1TpvuH5itskA6pjYZTRYixIE8Obk1zaVRSEWhdlMKWw8u1cZ22iVt543SpH9e7XWLK/zAX//OX/YOcrHzLuDOl+IAR3JPnFC9DnAIA4Dpujja3RVRdrOKktEpAI17f0Q1chDs3vB/Gi07BhlBvjkQZtiOQrnwW8YdBy3Qh6msibYid43ua+QOrB/sLL6flKlutifZfIIVz6zIKkq2aowVjObQXdik4cnAKUaNlD9iyvMYO9W1FMuAm7BE7MPLrBwXnjsOaQsNKVsjcFLWeHm38hiVYkGM5StOkm8Ul46M8DVTmGDPb/jwOct00RUrpqKqj75kfOWY/tU/ySB5Roklh5wn5OOGsiYDlKxY8JBIGBH80o8WDP9+loiKLZJGrUJonMc/YobJrXwbLg9JE9xjDJzSfSfAlxwFUT7C3ivkxF8U4BWXg2Fb0oUV0JNbIPVfRnMM4JtPnPCe6hDGn1t5kRyt8HR+Jqd3K4y1pqOHtOQFl35Qgzi9SVjS6pYC1OAdsAQRCv+zlC46QKcrIAcnAWnPYNrdddbItGauzho1+LCrw0ZhO9/bM1JQkK6xq3THhLjqdOXQoHzIGdV85Av0f6vmFYtVrj9dmLAm6XUjNeqnRbwc2H21zYRP2o3fmheLl7oIohWrh5xZ5pyOJkUGBEhjFlVvdfirHouJeluIUDl+bOqHnQsJvA4I5qqc8ueA++P4dFWwrZAJU8oU+pTLqLdYVsAR2g3imNHVlk1D3Ogqy9xd42
 owPt/8g+
 K4zgYUqOunT76s5yTU6WSlWS30inRa3ppe0lnIBWoInDIuy6fp3KhZOkuGSn1ij72ZNo6WZonE4kvbopy6zBrm8qf1g5TwJcgsqX11A69QKsOUfJsL65gcuhXyL8fq1dVumnUUk7p/4ZrQ4yjXwAQ34HJcBp5/cteretS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3b058d1aeeeff27a7289529c4944291613b364e9  Add linux-next specific files for 20260327

Unverified Warning (likely false positive, kindly check if interested):

    drivers/iommu/generic_pt/fmt/../iommu_pt.h:908 vtdss_map_range() warn: impossible condition '(paddr > 18446744073709551615) => (0-u64max > u64max)'
    drivers/iommu/generic_pt/fmt/../iommu_pt.h:908 x86_64_map_range() warn: impossible condition '(paddr > 18446744073709551615) => (0-u64max > u64max)'
    drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:476 mt7996_mcu_ie_countdown() warn: possible spectre second half.  'cdata.mphy'
    drivers/pinctrl/renesas/pinctrl-rzt2h.c:518 rzt2h_pinctrl_pinconf_get() warn: subtract is higher precedence than shift

Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r073-20260328
|   `-- drivers-pinctrl-renesas-pinctrl-rzt2h.c-rzt2h_pinctrl_pinconf_get()-warn:subtract-is-higher-precedence-than-shift
|-- i386-randconfig-141-20260328
|   |-- drivers-iommu-generic_pt-fmt-..-iommu_pt.h-vtdss_map_range()-warn:impossible-condition-(paddr-)-(-u64max-u64max)
|   `-- drivers-iommu-generic_pt-fmt-..-iommu_pt.h-x86_64_map_range()-warn:impossible-condition-(paddr-)-(-u64max-u64max)
|-- riscv-randconfig-r073-20260328
|   `-- drivers-net-wireless-mediatek-mt76-mt7996-mcu.c-mt7996_mcu_ie_countdown()-warn:possible-spectre-second-half.-cdata.mphy
|-- s390-randconfig-r111-20260328
|   `-- drivers-fwctl-bnxt-main.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-error_code-got-int-assigned-rc
`-- um-randconfig-r112-20260328
    `-- include-linux-bitops.h:sparse:sparse:cast-truncates-bits-from-constant-value-(fffffffffff000-becomes-fffff000)

elapsed time: 780m

configs tested: 170
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260328    gcc-8.5.0
arc                   randconfig-002-20260328    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260328    gcc-12.5.0
arm                   randconfig-002-20260328    gcc-8.5.0
arm                   randconfig-003-20260328    gcc-8.5.0
arm                   randconfig-004-20260328    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260328    gcc-14.3.0
arm64                 randconfig-002-20260328    gcc-14.3.0
arm64                 randconfig-003-20260328    gcc-8.5.0
arm64                 randconfig-004-20260328    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260328    gcc-15.2.0
csky                  randconfig-002-20260328    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260328    clang-23
hexagon               randconfig-002-20260328    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260328    clang-20
i386        buildonly-randconfig-002-20260328    gcc-12
i386        buildonly-randconfig-003-20260328    gcc-14
i386        buildonly-randconfig-004-20260328    clang-20
i386        buildonly-randconfig-005-20260328    clang-20
i386        buildonly-randconfig-006-20260328    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260328    clang-20
i386                  randconfig-002-20260328    clang-20
i386                  randconfig-003-20260328    gcc-14
i386                  randconfig-004-20260328    gcc-14
i386                  randconfig-005-20260328    clang-20
i386                  randconfig-006-20260328    gcc-14
i386                  randconfig-007-20260328    gcc-14
i386                  randconfig-011-20260328    gcc-13
i386                  randconfig-012-20260328    gcc-14
i386                  randconfig-013-20260328    clang-20
i386                  randconfig-014-20260328    gcc-14
i386                  randconfig-015-20260328    gcc-13
i386                  randconfig-016-20260328    gcc-13
i386                  randconfig-017-20260328    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260328    clang-23
loongarch             randconfig-002-20260328    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260328    gcc-11.5.0
nios2                 randconfig-002-20260328    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260328    gcc-13.4.0
parisc                randconfig-002-20260328    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260328    gcc-13.4.0
powerpc               randconfig-002-20260328    gcc-10.5.0
powerpc64             randconfig-001-20260328    gcc-13.4.0
powerpc64             randconfig-002-20260328    gcc-12.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_virt_defconfig    clang-23
riscv                 randconfig-001-20260328    gcc-11.5.0
riscv                 randconfig-002-20260328    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260328    clang-16
s390                  randconfig-002-20260328    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260328    gcc-15.2.0
sh                    randconfig-002-20260328    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260328    gcc-14.3.0
sparc                 randconfig-002-20260328    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260328    clang-23
sparc64               randconfig-002-20260328    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260328    gcc-14
um                    randconfig-002-20260328    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260328    gcc-14
x86_64      buildonly-randconfig-002-20260328    clang-20
x86_64      buildonly-randconfig-003-20260328    clang-20
x86_64      buildonly-randconfig-004-20260328    clang-20
x86_64      buildonly-randconfig-005-20260328    gcc-14
x86_64      buildonly-randconfig-006-20260328    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260328    clang-20
x86_64                randconfig-002-20260328    gcc-13
x86_64                randconfig-003-20260328    gcc-14
x86_64                randconfig-004-20260328    gcc-14
x86_64                randconfig-005-20260328    clang-20
x86_64                randconfig-006-20260328    gcc-14
x86_64                randconfig-011-20260328    clang-20
x86_64                randconfig-012-20260328    clang-20
x86_64                randconfig-013-20260328    gcc-14
x86_64                randconfig-014-20260328    gcc-14
x86_64                randconfig-015-20260328    clang-20
x86_64                randconfig-016-20260328    clang-20
x86_64                randconfig-071-20260328    gcc-12
x86_64                randconfig-072-20260328    clang-20
x86_64                randconfig-073-20260328    gcc-14
x86_64                randconfig-074-20260328    gcc-12
x86_64                randconfig-075-20260328    gcc-14
x86_64                randconfig-076-20260328    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260328    gcc-8.5.0
xtensa                randconfig-002-20260328    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

