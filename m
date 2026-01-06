Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4242CC47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F816B008A; Tue,  6 Jan 2026 06:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66C66B0093; Tue,  6 Jan 2026 06:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973066B0095; Tue,  6 Jan 2026 06:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8375F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:08:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F87FB9B5C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:08:02 +0000 (UTC)
X-FDA: 84301264404.27.C5FA540
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1E8CA0007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:07:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V7uy6eIl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767697680; a=rsa-sha256;
	cv=none;
	b=ELLVH7J94djD2g3BR3hJD7RhTomdfPkwdsek4pl1JM5YpCDolit9Ly5TqAllQRHz8hgkEN
	1mT0LCpYt7Zz9aOuNnuZt9NAqtCPgipD8ALUCKDfNpm2AD2GJWLe9G7IHYMqYVysa73b/r
	QvoYRzYfUIZ7btA86LY/TwF/y4Ae3Uo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V7uy6eIl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767697680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=teZj7Nu0rmXT8+YLTIZDsc3CbkyVjPdaaQR+vwuEtF4=;
	b=5887xw8Yz38+ln5OCVMXUbXfKEWN0T6g5UvmeXb9QH+E9oDJZko8aJJdZBSBv/DWFXD8+u
	PEEtTFj96KG8ckJvNgrpe8oSlxTCKzDct9jcpEdN8K/U8KenRiC9K3+ieIpU935Q+kZc3Y
	rO6oxcyt/0Vc2xD21V30/nNa5QiPOgE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767697680; x=1799233680;
  h=date:from:to:cc:subject:message-id;
  bh=rQvUs0wGMdZodkft/Q7JejfhF7Wq6pHNNtAcsU7drcI=;
  b=V7uy6eIlaX7UR2lLEyemQiPK/1aTv7NJDY+U95FJfpb+iT3mMwdc3nzA
   5q6sXWXyj0hta/GwUrnIB3SlEoLBv9R91aev2vpdiaVQ2Fw/kTJkeLxDj
   LyfeDbCi0VJQNfs3qjFQ4lrDkrw9f8cPpLE7qNXw6JMi1PFq9I460lxO6
   +sWoxF1d8ruoTR0ZNrBH+XbqeXwJY81J8TE2v/USi72aW5qFM60/9IHvI
   bDdzQwghBEAD34d0XVnZ471HDtpIKLX9R3wwNsZg/oL/wrBZpJrkJYSGx
   aK+50B9F2TYCmYCwNR12NSbH3nC5Uhvpxs8tk8rfDiygOHBkbNCJJfxIy
   Q==;
X-CSE-ConnectionGUID: 2hYDkk9WSoSHElL2DP8v2g==
X-CSE-MsgGUID: s6Ob2XSLTZWal74WOXFMsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="69104246"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="69104246"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 03:07:58 -0800
X-CSE-ConnectionGUID: w1Hac9YcTJu1pxYKcHe+3w==
X-CSE-MsgGUID: t6it4S6gRfugzdwVq5MejA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207671959"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 06 Jan 2026 03:07:57 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vd4uo-000000001sx-2Zzn;
	Tue, 06 Jan 2026 11:07:54 +0000
Date: Tue, 06 Jan 2026 19:07:52 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 be05f571464404432a0f8fe1c81a86a0862da283
Message-ID: <202601061944.q3iEScXJ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1E8CA0007
X-Stat-Signature: d47o948pq3zbjdthjd4t5prt98j3q3wj
X-Rspam-User: 
X-HE-Tag: 1767697679-392567
X-HE-Meta: U2FsdGVkX1/2i9xa4C2ldxQmbpCRS8bWKA6/6a1BIUvx8tnuUpIMJRzXb0EiDVYeZrndFU/k/40TvKsFc8JAawwX2ryKC3HuA7C3tKhi8QAHFkUyHzGOmhzotEWVDD2x+sr9AAdXlutOuiZ2iYDmn8hCuAgefQn1u3rNApJpgE0iG5i6YCtc/nV9Gk7y1RgagNwTzkqEITdPYBbBIMFtbrNS4KEYtEhZbNOZuI6e3FjXklnHCxnpHwRa00hkWhipt9ZSBei5idcslSYff0SiRrOsbjDIL3pxg4hrzAe1oDfzLnw2MTBexHMA12RQBo9xPSgbsBe49zz5obLuuriiDVStaNxB9MX/xLcjCx8deNtLLuZ7C9GP8Fb3vqJgEzMxHCagYq08Y/iG4yUKOONNI5T/VjvObtXyJ4M5BnTirbuIPNPYNOv3/QLeMG/h7C53CmVqeMyG0lrUzDK3UEDelG2SZqQW3PKtKYoaYx3HHZ0V7DbC6uIksywcRRZ4WtAeGiXdi+0YwdmhqmVakqiuJorERxMq4M1xt1B11O7KLmT2YaeC7ZEv8Ls//QvwbNgLm18OhccYxAnXFzFTthB6CPewzPJGxfJENeGeNhLwnJ249KQ9U4s2YBzl8UkBN04NLc53L6jlOYPASARlEcSmIvs6BQdPrkli0+3mXs9HiP6hre/NzAAMOVyMEccO4hM3HVOgRd/sj+D8PDWk5TlRRFz0gI+iB/0wtjmLzSsEJC7WmOKYjGxslSXe0PYtDH3Z8mzBPGNpbQ5RhHfAJK40BQZOoEvNK0OL+/0Th9viWiv0q7CBYJwVA3JyTc2rNMM8rI2S+ky/a5hObTWARhWe3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: be05f571464404432a0f8fe1c81a86a0862da283  memblock test: include <linux/sizes.h> from tools mm.h stub

elapsed time: 1497m

configs tested: 141
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20260106    gcc-13.4.0
arc                   randconfig-002-20260106    gcc-13.4.0
arm                               allnoconfig    gcc-15.1.0
arm                                 defconfig    gcc-15.1.0
arm                      jornada720_defconfig    clang-22
arm                         nhk8815_defconfig    clang-22
arm                   randconfig-001-20260106    gcc-13.4.0
arm                   randconfig-002-20260106    gcc-13.4.0
arm                   randconfig-003-20260106    gcc-13.4.0
arm                   randconfig-004-20260106    gcc-13.4.0
arm                         s5pv210_defconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20260106    gcc-10.5.0
arm64                 randconfig-002-20260106    gcc-10.5.0
arm64                 randconfig-003-20260106    gcc-10.5.0
arm64                 randconfig-004-20260106    gcc-10.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20260106    gcc-10.5.0
csky                  randconfig-002-20260106    gcc-10.5.0
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20260106    gcc-8.5.0
hexagon               randconfig-002-20260106    gcc-8.5.0
i386                              allnoconfig    gcc-15.1.0
i386        buildonly-randconfig-001-20260106    clang-20
i386        buildonly-randconfig-002-20260106    clang-20
i386        buildonly-randconfig-003-20260106    clang-20
i386        buildonly-randconfig-004-20260106    clang-20
i386        buildonly-randconfig-005-20260106    clang-20
i386        buildonly-randconfig-006-20260106    clang-20
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20260106    clang-20
i386                  randconfig-002-20260106    clang-20
i386                  randconfig-003-20260106    clang-20
i386                  randconfig-004-20260106    clang-20
i386                  randconfig-005-20260106    clang-20
i386                  randconfig-006-20260106    clang-20
i386                  randconfig-007-20260106    clang-20
i386                  randconfig-011-20260106    gcc-14
i386                  randconfig-012-20260106    gcc-14
i386                  randconfig-013-20260106    gcc-14
i386                  randconfig-014-20260106    gcc-14
i386                  randconfig-015-20260106    gcc-14
i386                  randconfig-016-20260106    gcc-14
i386                  randconfig-017-20260106    gcc-14
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260106    gcc-8.5.0
loongarch             randconfig-002-20260106    gcc-8.5.0
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    clang-19
microblaze                       alldefconfig    clang-22
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    clang-22
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260106    gcc-8.5.0
nios2                 randconfig-002-20260106    gcc-8.5.0
openrisc                          allnoconfig    clang-22
openrisc                            defconfig    gcc-15.1.0
openrisc                 simple_smp_defconfig    clang-22
parisc                            allnoconfig    clang-22
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20260106    gcc-8.5.0
parisc                randconfig-002-20260106    gcc-8.5.0
parisc64                            defconfig    clang-19
powerpc                           allnoconfig    clang-22
powerpc                    gamecube_defconfig    clang-22
powerpc               randconfig-001-20260106    gcc-8.5.0
powerpc               randconfig-002-20260106    gcc-8.5.0
powerpc64             randconfig-001-20260106    gcc-8.5.0
powerpc64             randconfig-002-20260106    gcc-8.5.0
riscv                             allnoconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20260106    gcc-8.5.0
riscv                 randconfig-002-20260106    gcc-8.5.0
s390                              allnoconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20260106    gcc-8.5.0
s390                  randconfig-002-20260106    gcc-8.5.0
sh                                allnoconfig    clang-22
sh                                  defconfig    gcc-14
sh                          r7780mp_defconfig    clang-22
sh                    randconfig-001-20260106    gcc-8.5.0
sh                    randconfig-002-20260106    gcc-8.5.0
sparc                             allnoconfig    clang-22
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20260106    gcc-8.5.0
sparc                 randconfig-002-20260106    gcc-8.5.0
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260106    gcc-8.5.0
sparc64               randconfig-002-20260106    gcc-8.5.0
um                                allnoconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260106    gcc-8.5.0
um                    randconfig-002-20260106    gcc-8.5.0
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260106    clang-20
x86_64      buildonly-randconfig-002-20260106    clang-20
x86_64      buildonly-randconfig-003-20260106    clang-20
x86_64      buildonly-randconfig-004-20260106    clang-20
x86_64      buildonly-randconfig-005-20260106    clang-20
x86_64      buildonly-randconfig-006-20260106    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260106    clang-20
x86_64                randconfig-002-20260106    clang-20
x86_64                randconfig-003-20260106    clang-20
x86_64                randconfig-004-20260106    clang-20
x86_64                randconfig-005-20260106    clang-20
x86_64                randconfig-006-20260106    clang-20
x86_64                randconfig-011-20260106    gcc-14
x86_64                randconfig-012-20260106    gcc-14
x86_64                randconfig-013-20260106    gcc-14
x86_64                randconfig-014-20260106    gcc-14
x86_64                randconfig-015-20260106    gcc-14
x86_64                randconfig-016-20260106    gcc-14
x86_64                randconfig-071-20260106    clang-20
x86_64                randconfig-072-20260106    clang-20
x86_64                randconfig-073-20260106    clang-20
x86_64                randconfig-074-20260106    clang-20
x86_64                randconfig-075-20260106    clang-20
x86_64                randconfig-076-20260106    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
xtensa                            allnoconfig    clang-22
xtensa                randconfig-001-20260106    gcc-8.5.0
xtensa                randconfig-002-20260106    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

