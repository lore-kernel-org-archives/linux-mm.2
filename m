Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433B4606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RPptqa/K
Received: by kanga.kvack.org (Postfix)
	id 472E66B05B4; Sun,  8 Nov 2026 16:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C786B05B5; Sun,  8 Nov 2026 16:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5536B05B6; Sun,  8 Nov 2026 16:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E36526B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:07:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AFB7C04F8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:07:41 +0000 (UTC)
X-FDA: 85413188322.22.C1BA341
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA4D940002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:07:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="RPptqa/K";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794172059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=BMolsQJC9CetZ2XpcZ94BwZn4NnUxWw7RTHyDvRFIj0=;
	b=tob1pfDCIwk746qQop3p0bNVDPh7tCoVFFAf2R5vErzODoX91fmXjN92VpxdATh3/sHfBy
	0KX4zMXhs1d8BnIKoFKz871YKyJrU/8VdKVbH5KhmFX2HahEBbeydAVinqsv9Hf3PFbF84
	iQ0pKOyjodj5DeGyraUSFnGNRMQy8zs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="RPptqa/K";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794172059;
	b=Btn6ecJwi8hJ66nJmMV7KYqU7jKsawf8wfBioGN6uoLFMbjhqg9Dc89xWhGIN7Dx6UNUIy
	0rSsKhRFAtHVCCib9SyLPhuZ9ujc3mDi47MZhHwrwm825XHdUL1BNAA9fhJVDJgEoJsN5c
	flWoLkxrr0PKrnBWFI5TIMM/6q3CA4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794172059; x=1825708059;
  h=date:from:to:cc:subject:message-id;
  bh=0W5PIzKJjt/s6hHuIy1C1bJdlnEcFmVwPOcacXpEDRk=;
  b=RPptqa/K5BcB1PACWVuJckZV5xiQZDdjfRllaYBJMxh4LZLqH6pFOrJP
   Dn/8cNFGIevbg5FiyRKoWitwnxcHcguTR1HW9j1WVeJL55gyyP8iPQYBD
   RYkm6dWVOrMbb8igdQtyfzJo61xm0zRr7x3m7u4GOnrtxVxoNnGZ7PQMj
   iy6JpYGsA2a7n0rJRSNwnuoL5eWq4Hid2531N8j4Uvavgleb/OmpDnLPG
   j40jrtiQHHPpgroenhDCufPNxObKbe2W98GTNkssRMhAu7jcccSD8djxY
   2Tq9NI03LWFSlsWVnFnilzFt+VFPK/uPKDkJ/+xguX5Be88r4D4OxEKlf
   A==;
X-CSE-ConnectionGUID: x4uVG9LYQrWMg6LTHXD1kw==
X-CSE-MsgGUID: yKc/CmgjRLefrbDgyY6sHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11960"; a="2934275"
X-IronPort-AV: E=Sophos;i="6.27,202,1787036400"; 
   d="scan'208";a="2934275"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 13:07:37 -0800
X-CSE-ConnectionGUID: 8kNAcwHfTn2KBf7o3AMx6w==
X-CSE-MsgGUID: WWIl57W/RbOwbaDmdgXWrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,202,1787036400"; 
   d="scan'208";a="9488567"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 08 Nov 2026 13:07:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQA6v-00000000tOV-2Yyw;
	Sun, 08 Nov 2026 21:07:33 +0000
Date: Mon, 09 Nov 2026 05:07:27 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 2c5dafa7f289d760f4492260b0988029aab478b0
Message-ID: <20261109050727.MEJyNecu-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA4D940002
X-Stat-Signature: triqybf53679hudgpm9u49j7surq63au
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794172058-547595
X-HE-Meta: U2FsdGVkX1++jRLcQeaB898Lq2wpZt9UbMcmRr6Un7Ig9VgCXDxaYtXg/2h/FDqENCONxHKp9cMiXVOtInBE9O76nWFq/rhCYcKtxzZSjo5mcP/mGrMQ+fUx/BbBT+KNFrPmwNhAQA+IBrnbR64IXLs5QrefRoUFLtujsz9FSFKLK7cam7jS/WZjAC2l/oiA015Q9SF59ftR7+D+llX9JsaOYxDN0SLpWoZ3Me+PCYLJSjvwSRwZ58q49kDYmqRnU7Pc9RTUYXBtA1KQdPN2zyJH+7cb6+ijXoX+HzBGwqbcEslJ7MpPmSCl7EwS4PZRfVpi3SLdY8yj7xkxbpmsZ73HTLLk6H+KVi/7M9m78npMlUqrLFI3Vx4tKBGPscUZCtcbx2lqQVoyEFROrZc3XvfnrwXmb4sZObmWOUNJD6LwlOT/J36JjYlf6QY4AUuCtvB81p5pH8I9plsCvfxvscrWL8wjbAmNNq1kXm4sz4f4TIkigfx6uxyY63HwyVgX/xLHIMZA4olpRhocr8iP10mu5zx5JhctSgAcm9buV9A67UcsdLJRcd2SvP78ek6r3iM+UyyQ8u8y74acV2Rte3f6abZBrrlkPT4UVwQGzajM6lzx8HRUG6nkeNPgXtVsTaPLhTpCvaYEUzkZMh2X8kgSxlQM50p4QrPmvjWa7q4SqqhvQ2arZhIPsUkD1IpSvDcgqetG6BIokLE1qk/WDEy+lYJE/fsY9OEM9wojKpVlDZNqLYHR8biKo3CjxK5ssEIe3SVpo9GtmgZjHXZpSbO/bHBt3reWQ9XSak2XuBl3maovxFqPz0Ki4CcmkbYL4g+Hn4hcEdwFX2RwtlLnaC+qm3XgrIRNr9lDD+C7kbVaFioe9O/BBoCJ2mr8vP46OJVblQ3ulLNEBg67BiurVkVBl3KR+TwU7j7JBwjHkhl50C8b4E1GS/2qfBoEdRMR2XYCHkihMsmFE3drQVq
 hiOoy1PP
 CAjNRxO69nPPPU/NjK8qO94/fg3e3KCdison/p2B5+Eny9Xx2WgKh6CLC/DZ5BsWgq3xmYqo8yWLGQUYjJPhIKfbbCsbc5ssswtM+n6onTms4vmZd6L2fRcOrgORomzglo+ObASbIhCFKU1HEKQGgXPEe8xDKdY10XHbFCMSZsgk81y5x2R91I/ELLUMXgE+HFT8d8IaY+QAfK7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2c5dafa7f289d760f4492260b0988029aab478b0  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1136m

configs tested: 236
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261108    gcc-11.5.0
arc                   randconfig-1000-20261109    clang-24
arc                   randconfig-1001-20261108    gcc-11.5.0
arc                   randconfig-1001-20261109    clang-24
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261108    gcc-11.5.0
arm                   randconfig-1000-20261109    clang-24
arm                   randconfig-1001-20261108    gcc-11.5.0
arm                   randconfig-1001-20261109    clang-24
arm                   randconfig-1002-20261108    gcc-11.5.0
arm                   randconfig-1002-20261109    clang-24
arm                   randconfig-1003-20261108    gcc-11.5.0
arm                   randconfig-1003-20261109    clang-24
arm                         realview_defconfig    clang-19
arm                         vexpress_defconfig    clang-19
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261108    clang-24
arm64                 randconfig-1001-20261108    clang-24
arm64                 randconfig-1002-20261108    clang-24
arm64                 randconfig-1003-20261108    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261108    clang-24
csky                  randconfig-1001-20261108    clang-24
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261108    gcc-16.2.0
hexagon               randconfig-1001-20261108    gcc-16.2.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261108    clang-22
i386        buildonly-randconfig-1001-20261108    clang-22
i386        buildonly-randconfig-1002-20261108    clang-22
i386        buildonly-randconfig-1003-20261108    clang-22
i386        buildonly-randconfig-1004-20261108    clang-22
i386        buildonly-randconfig-1005-20261108    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261108    gcc-14
i386                  randconfig-1001-20261108    gcc-14
i386                  randconfig-1002-20261108    gcc-14
i386                  randconfig-1003-20261108    gcc-14
i386                  randconfig-1004-20261108    gcc-14
i386                  randconfig-1005-20261108    gcc-14
i386                  randconfig-1006-20261108    gcc-14
i386                  randconfig-1007-20261108    clang-22
i386                  randconfig-1008-20261108    clang-22
i386                  randconfig-1009-20261108    clang-22
i386                  randconfig-1010-20261108    clang-22
i386                  randconfig-1011-20261108    clang-22
i386                  randconfig-1012-20261108    clang-22
i386                  randconfig-1013-20261108    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261108    gcc-16.2.0
loongarch             randconfig-1001-20261108    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                           hp300_defconfig    clang-19
m68k                           multi_defconfig    clang-19
m68k                             q40_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            gcw0_defconfig    clang-19
mips                             gpr_defconfig    clang-24
mips                   maltasmvp_eva_defconfig    gcc-16.2.0
mips                            xway_defconfig    clang-19
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261108    gcc-16.2.0
nios2                 randconfig-1001-20261108    gcc-16.2.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261108    clang-24
parisc                randconfig-1001-20261108    clang-24
parisc64                             defconfig    clang-24
powerpc                      akebono_defconfig    clang-19
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    bluestone_defconfig    clang-19
powerpc                       ep88xc_defconfig    clang-24
powerpc                    microwatt_defconfig    gcc-16.2.0
powerpc                       ppc44x_defconfig    clang-19
powerpc                      rainier_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261108    clang-24
powerpc               randconfig-1001-20261108    clang-24
powerpc                      stx_gp3_defconfig    clang-19
powerpc                      stx_gp3_defconfig    clang-24
powerpc                      taishan_defconfig    clang-19
powerpc                      taishan_defconfig    clang-24
powerpc                       tqm8xx_defconfig    clang-24
powerpc64             randconfig-1000-20261108    clang-24
powerpc64             randconfig-1001-20261108    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv              nommu_k210_sdcard_defconfig    clang-19
riscv                 randconfig-1000-20261109    gcc-8.5.0
riscv                 randconfig-1001-20261109    gcc-8.5.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261109    gcc-8.5.0
s390                  randconfig-1001-20261109    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    clang-19
sh                                   defconfig    gcc-14
sh                           r7780mp_defconfig    gcc-16.2.0
sh                           r7785rp_defconfig    clang-19
sh                    randconfig-1000-20261109    gcc-8.5.0
sh                    randconfig-1001-20261109    gcc-8.5.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                            se7722_defconfig    gcc-16.2.0
sh                              sh03_defconfig    gcc-16.2.0
sh                         sh7763rdp_defconfig    clang-19
sh                   sh7785lcr_32bit_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261108    gcc-8.5.0
sparc                 randconfig-1001-20261108    gcc-11.5.0
sparc                 randconfig-1001-20261108    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261108    clang-24
sparc64               randconfig-1000-20261108    gcc-8.5.0
sparc64               randconfig-1001-20261108    clang-24
sparc64               randconfig-1001-20261108    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261108    gcc-14
um                    randconfig-1000-20261108    gcc-8.5.0
um                    randconfig-1001-20261108    gcc-14
um                    randconfig-1001-20261108    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261108    gcc-14
x86_64      buildonly-randconfig-1001-20261108    gcc-14
x86_64      buildonly-randconfig-1002-20261108    gcc-14
x86_64      buildonly-randconfig-1003-20261108    gcc-14
x86_64      buildonly-randconfig-1004-20261108    gcc-14
x86_64      buildonly-randconfig-1005-20261108    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261108    gcc-14
x86_64                randconfig-1001-20261108    gcc-14
x86_64                randconfig-1002-20261108    gcc-14
x86_64                randconfig-1003-20261108    gcc-14
x86_64                randconfig-1004-20261108    gcc-14
x86_64                randconfig-1005-20261108    gcc-14
x86_64                randconfig-1006-20261108    clang-22
x86_64                randconfig-1007-20261108    clang-22
x86_64                randconfig-1008-20261108    clang-22
x86_64                randconfig-1009-20261108    clang-22
x86_64                randconfig-1010-20261108    clang-22
x86_64                randconfig-1011-20261108    clang-22
x86_64                randconfig-1012-20261108    clang-22
x86_64                randconfig-1013-20261108    clang-22
x86_64                randconfig-1014-20261108    clang-22
x86_64                randconfig-1015-20261108    clang-22
x86_64                randconfig-1016-20261108    clang-22
x86_64                randconfig-1017-20261108    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                           iss_defconfig    clang-24
xtensa                randconfig-1000-20261108    gcc-8.5.0
xtensa                randconfig-1001-20261108    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

