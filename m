Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA90DCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4200C6B008A; Thu, 30 Apr 2026 12:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0E36B008C; Thu, 30 Apr 2026 12:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299E76B0092; Thu, 30 Apr 2026 12:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1653C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:32:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54D6CA439C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:50 +0000 (UTC)
X-FDA: 84715743420.07.5F39B7A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E00A40006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cj+Ilerd;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=YiDwcJ00dtQ6mIh9BKiKfaGTwik8aRgvQQC7NcuF9h0=;
	b=rXQgmSh1Pkiv4v+SDo6dwCle/Z+va5sIPeS9mDxeLwpF22QoTKbmROXLN7boxmK9ICK/VR
	J9tYXUZh/O5Ki8cb0qPliymV3YdkSz2PRxX8o6f2NfexJcSOs6emoqM7eosTdOEYmAvljJ
	1DiG1HPBZecerPn1ynHOhKtFri1b1iA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cj+Ilerd;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566228; a=rsa-sha256;
	cv=none;
	b=sprwRvpBJHtxh0Eudngarkt2/Rdzx3eGZXGVe/M8DB/omeSOOiuyx/SYBnAYnSvsUjO0GH
	ZmUUKW+s/HlQucdpPvVbxvQ5nWvAtcGZhX7o9tms9qWG4WehI/Srf6vChTcoD2oaREpaO5
	g5ybCgpml7N0ZH+uk/bA94n5E2pVGzg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777566228; x=1809102228;
  h=date:from:to:cc:subject:message-id;
  bh=/Envm9+e5kYYnRUqkd87+vgvT88RN/ckGQ6J/wj4tRo=;
  b=Cj+IlerdZqk6bLQ7XyasblJKNTnUQfbATHgTnNSoZNaRAulcsu1iznP4
   c2w17FbjUtifSDNY/afRg7l7RT3o+5nK1yknwYGpaiOv/OlLXEohtK3Yr
   zfm5/XNFwQh3g+SSuUY+R2BcpJX3ig35H5dkxOimNQYfogq+1IDzaCXRH
   bmeNxdl/MkUpWEtxirXQcarkHB647Q+YfdUzlhh5NBDxb1kRplMWffnBJ
   KJw6uv2A+gUP4fZUqrkqH8/XO9ZgYQA7BDzxIUifoaQr6HPcmU71hJY5m
   h1c/UNWIokL9aCL+Q0GC4a3s/xEhvRbfaLMe7lAtT41tKRTSvaMDGOGgZ
   w==;
X-CSE-ConnectionGUID: upJSUgIcQ2+EkumKjWMqfw==
X-CSE-MsgGUID: GI5nY1elR7Cci00XEqtr5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="77689596"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77689596"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:23:46 -0700
X-CSE-ConnectionGUID: dMMcd4c6S7KpRS93v5eHmA==
X-CSE-MsgGUID: 4p6spdw+RD+RpRrR4B53wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="231501709"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 Apr 2026 09:23:45 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIUAx-00000000CdE-0bBd;
	Thu, 30 Apr 2026 16:23:43 +0000
Date: Fri, 01 May 2026 00:23:22 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 afd218bb1dd8b4d2ba99a84cfa71524da6dbab35
Message-ID: <202605010013.tr00OPkR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E00A40006
X-Rspamd-Server: rspam06
X-Stat-Signature: ai87ws3fuk7enyinsxd89g43szifioeg
X-HE-Tag: 1777566228-510587
X-HE-Meta: U2FsdGVkX1+2G29bJlzcRo05P8CznvbgAwRZ/HS6sF3uVRDpde9YqHn2N5LmzI2xM2y83KKCAL3R46bXZ/CVcZ/+tgHaRDabf22ljetBu7WPVlPIwAej+oqVa/MD9iIbiPJhl9jiYpYGJ5VSXyHvSShHaYMeq05vtItkKs2GYR7BcidTv5nLFIEF0Z3uWEQOOgVZ+ts6ZG33JTJYRhyauQJolR1ImIKEdq9jMLFuZokymmwHKcycFVdyDUpuT7YY+dKr75wolLCTwXWWJOC0asDoryKm+XW1yUAG9TawlG1QhgqJbvSCosTlvXiwId5MYzCuYc3jl2uyHG4uS4T0CgKdZQFxdoTviGKifDR8u/h4CHz/P3EJXQdla1TrCROWJZ783eARfMU4+wc9PVNYsPM9SklpgsCgm88C/8/2NtODV0dRB9igHlWMe6h0wnh4mrzHC+IdH4mHJHgJA1f/QAtwi0ZmBlkpE6xPvK/kFgM9sBaLArANIsBAFoPB2Go3E2qisCMer+gGVPl2tzg+uR6By8d+rqbdztxehuYwIZxyBHHG55p9VOh4nFzk6dKyOp901pgnC+vWSIrsIpV7vU8PhZIXNduADoZgUxb+qyntOdG7M+0jttAnEOeim4knvE4ETAylAkb13Y6VGzUHXfKtj6PasTzPBsOGREVcl+hn6tE6EDDR90SYKOFDB4jD0MZhezX97VB8cXzUtfyvoU7q7WZfIC7cv6Z/TNVMSX/y5GmLJaMmEOfK6iq72x5oFq0aQ0M+cEXD7i2E2jVSn57eohWt8YJPvjBCJwuN6Oz69+53Fe9sCXcVNrePljrdYTbdbwYtvPGLj3HxNaR6Yb9QzLZc35BuffM+nmtGB9aa42Rzv9Q7DksbhXdBUrZjGyLYB0ItUZlx5hToOkMzW6LbPrkIpMUH/DMVa27csCQGA8q1aCCfeae7EL/QaX9Ggi14+KwYubdrhgTkKMt
 5QRh8+Ia
 Uf6B/TUxtCuPWoI96WaXhfpfri4YRDGzAA9IUPD+ocYCuYzbcvt1dB1n/Ehx9MXbetDqC5Yo4FqQXkjCJEgwkrzpSxaWj+dY7FDUmznhR+smSV9pXIwcUB2qkon+xmKrQkeeqIf+OrBYCGl5bzCamrSLd2Cv8sajrfmMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: afd218bb1dd8b4d2ba99a84cfa71524da6dbab35  mm/fake-numa: fix under-allocation detection in uniform split

elapsed time: 8625m

configs tested: 162
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260430    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260430    gcc-8.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260430    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260430    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260430    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260430    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260430    clang-23
arm64                 randconfig-002-20260430    clang-23
arm64                 randconfig-003-20260430    clang-23
arm64                 randconfig-004-20260430    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260430    clang-23
csky                  randconfig-002-20260430    clang-23
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260430    gcc-14.3.0
hexagon               randconfig-002-20260430    gcc-14.3.0
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260430    gcc-14
i386        buildonly-randconfig-002-20260430    gcc-14
i386        buildonly-randconfig-003-20260430    gcc-14
i386        buildonly-randconfig-004-20260430    gcc-14
i386        buildonly-randconfig-005-20260430    gcc-14
i386        buildonly-randconfig-006-20260430    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260430    clang-20
i386                  randconfig-002-20260430    clang-20
i386                  randconfig-003-20260430    clang-20
i386                  randconfig-004-20260430    clang-20
i386                  randconfig-005-20260430    clang-20
i386                  randconfig-006-20260430    clang-20
i386                  randconfig-007-20260430    clang-20
i386                  randconfig-011-20260430    clang-20
i386                  randconfig-012-20260430    clang-20
i386                  randconfig-013-20260430    clang-20
i386                  randconfig-014-20260430    clang-20
i386                  randconfig-015-20260430    clang-20
i386                  randconfig-016-20260430    clang-20
i386                  randconfig-017-20260430    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260430    gcc-14.3.0
loongarch             randconfig-002-20260430    gcc-14.3.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260430    gcc-14.3.0
nios2                 randconfig-002-20260430    gcc-14.3.0
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                 simple_smp_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                randconfig-001-20260430    gcc-13.4.0
parisc                randconfig-002-20260430    gcc-13.4.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc               randconfig-001-20260430    gcc-13.4.0
powerpc               randconfig-002-20260430    gcc-13.4.0
powerpc64             randconfig-001-20260430    gcc-13.4.0
powerpc64             randconfig-002-20260430    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260430    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260430    clang-23
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260430    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260430    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260430    clang-23
sh                             randconfig-002    clang-23
sh                    randconfig-002-20260430    clang-23
sh                           se7206_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260430    gcc-14
x86_64      buildonly-randconfig-002-20260430    gcc-14
x86_64      buildonly-randconfig-003-20260430    gcc-14
x86_64      buildonly-randconfig-004-20260430    gcc-14
x86_64      buildonly-randconfig-005-20260430    gcc-14
x86_64      buildonly-randconfig-006-20260430    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-011-20260430    clang-20
x86_64                randconfig-012-20260430    clang-20
x86_64                randconfig-013-20260430    clang-20
x86_64                randconfig-014-20260430    clang-20
x86_64                randconfig-015-20260430    clang-20
x86_64                randconfig-016-20260430    clang-20
x86_64                randconfig-071-20260430    gcc-14
x86_64                randconfig-072-20260430    gcc-14
x86_64                randconfig-073-20260430    gcc-14
x86_64                randconfig-074-20260430    gcc-14
x86_64                randconfig-075-20260430    gcc-14
x86_64                randconfig-076-20260430    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

