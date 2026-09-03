Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E44C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3ACF6B00A2; Wed,  2 Sep 2026 23:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB436B00A3; Wed,  2 Sep 2026 23:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01946B00A4; Wed,  2 Sep 2026 23:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B80006B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:59:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41C5912040B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:59:50 +0000 (UTC)
X-FDA: 85171097340.11.14BDBC0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id B342B180003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:59:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=im6mkrvZ;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788407988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=eiyiQvqQvEIUuu+QsidZfEw/4iptbvZs0IG1bi3v1tY=;
	b=4T7p95Y54eV++9OXE0rsoZ07jMQCCdWoT8A1g9i6G5x4QSYpZWvXxbdYRShCnsHK1bGp7K
	H0dKCB8V1sCHNWI+YvHPSMV2zVW0JImp/HbdySoUs08nSwefLkUEVglHQLGwkwtre1jnEf
	SOhgQSOH3531sgH4HWr6zZRZvJ/uN/4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788407988;
	b=s0U27OpRpfCAtlOD2I7B7OIX+D7bIBHrQj80fLZBrY67c4RTT7i6NhNKFjRi1Ayo+rYH9q
	3dY+mtwfp+SNYT2KLnv5t9/+5MoNtLhw6ReDVbtrPTGbxIM8ZnyNI4Hggv84upQJXHVUUU
	a00SBlP3jjaIByfoRy2WXLrdQ9Fs9jU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=im6mkrvZ;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788407988; x=1819943988;
  h=date:from:to:cc:subject:message-id;
  bh=x/miJl0oAYZFvPHk/6OUvVYS8ADJFAo1h6IBOVB3S38=;
  b=im6mkrvZsa1vYWPJeEgdoaaGFHCGm0/qymnyC2ieINJNDGm7smz36wxe
   RCN5mWEqUBfRzIY8IUidy/ZYnSkg1VG6Rsu9VE5fMXE9Pe0PZGOSqE/Zg
   iiSUJlMBWjeBmUeNhuyq4wjprgu4aeARfeQIyTWtcmJMbOnKZPndWFjPU
   VQYr9cRIeN46iwJQkRyeZM7DAYU14li9wnkSX5AHur/KhLItFt2R67iNV
   HIX5cfSodXLNt+VgUe2fyRzUWhA8KOltlUuO7TO2gAP6AxqfjWPWJTvED
   JmyZrZk2iij3rX/56GKJNB1T+grdReVsKQM+G7UDnZULvhL/ArRzgQhwm
   A==;
X-CSE-ConnectionGUID: Rp1W702VRGyk+d3jcvcsUw==
X-CSE-MsgGUID: gzDvOSXRT96TRRUaT4KIHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="88909404"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="88909404"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 20:59:46 -0700
X-CSE-ConnectionGUID: GDvXDzKXQQeqrLAv9XUglg==
X-CSE-MsgGUID: wNjUY83bQY+9Cxk3ZOqXfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="274888906"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 02 Sep 2026 20:59:44 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1yc2-000000003wj-0mb6;
	Thu, 03 Sep 2026 03:59:42 +0000
Date: Thu, 03 Sep 2026 11:59:10 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de
Message-ID: <202609031152.McrmurCM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B342B180003
X-Stat-Signature: 6pwbdx1weah435iypheqsgofmabpj5tj
X-HE-Tag: 1788407987-781641
X-HE-Meta: U2FsdGVkX1/XT0dGDOIGdSBo2QleljXXhMAdqpdALbAEJJuQcvtJLJ1q4DNldNbtn+THBKVHFkL2ZdHGsMR0e6Vd3qplOx6xwEjTUkvaRkJwacvRPh52hByuv2a7P/bFqPiqAmfdvyyn/tX7OlUGqh60Bw1B+CSP7czWt+ep/uPziTL+rpi1zPlFpdDtcXiyKacHfmKCu+TPkHtaIgRpiCNBNN8r579t03iGiybv2o+aAO+L9mzOmDOX347y2kZmHWhZjbs6K3zQJ8xxwnmCTju0Q9dCOczKxdJ2cRGnRWEIRTv4YvwT15Bkonfb2eznLmsWx0oxhgabdvc+WLOXA31zwgA/iC+Iiln6V8AXBPwNkBTyMvoJqRCaNsSilOAIKRf1zgnXKhfr0fbpiimrFJPxR5MprcYgOGejzCII+dqM8RpKQIs1Zm4B0Eu2bGM+vcUezuyrjcilObPEcN33+eeW50ufpYqJgN70pPH77s7wLZUM3fCXKU7hZYV7jCrFNvEtKGqnFVcogqf+LvKhQUHWrxyLe3ih32m8yxLEciq/9kTj7DecMtqghQMdbmVtvQF3DEagXeBzwJcQoJMO0iUnjBBTZNKKS5PBtXH66tX2xZLtRJ6+4+juBQ5IK+FzAU7BzfygMbGLACQ9eXRYrc41ci4p58H0IZlSPXvnNyUczgvccRiPNvSoLp3K5q8mEd3k0i+dhZOTii2ofNwuxAe7JEvluC6GvjEchO+Ea9sYC6mEmm3hrXUNBf12Q9+71u/ivY0fOTWkuDxOkiZK9QBPPGu0oJ5hZBdneUoESaXmfFt26DpOUVhxQbzb+sjUnWAKKKWPoA0BF5MdxPkXS1eeJcO78HjWjUQqy+o4Dt3qEjoP3JLkpKycZ81AYSruePuZ8lMySMgjmlF9bEqoFYQbWD6bs07S5M7Gc30EgB6U2LsCjQFHzlqEn3TCmv4bIckU4ULyO0xDYlo2DTd
 aTkrCi1y
 MntaoaQ6CgJedyw7FTrYRMst5XwX0FdoIKgg3cmF7KtUJTqXGj9qbon/R3eCQEEi56rD41Bwpz4pCX2VnLORwGVAIFnr9meMjwE7tkYKdeoW0Yq24cu1BNIQe0dFnN84C/PQHPx/0zNgpPLkEhNoPsfqLZMJGXIQ/lz0h/lWw7F0xVfthy8QKVJwitr/h8Ee2/Ew2F1O+gnIqmGSwdAtAR7JL8FNFWK5Q5c++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de  Add linux-next specific files for 20260902

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609022215.1SXtHuum-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609030309.Brgg9wSf-lkp@intel.com

    security/selinux/selinuxfs.c:1577:(.text+0x4e2): undefined reference to `__udivdi3'
    security/selinux/selinuxfs.c:1587:(.text+0x562): undefined reference to `__umoddi3'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-013-20250413
|   |-- security-selinux-selinuxfs.c:(.text):undefined-reference-to-__udivdi3
|   `-- security-selinux-selinuxfs.c:(.text):undefined-reference-to-__umoddi3
`-- um-randconfig-r134-20260902
    `-- drivers-gpu-drm-amd-amdgpu-vcn_v5_0_2.c:sparse:sparse:invalid-assignment:

elapsed time: 908m

configs tested: 71
configs skipped: 0

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

