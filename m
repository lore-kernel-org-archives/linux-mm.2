Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64050C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FB06B0095; Wed, 16 Sep 2026 08:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6020F6B00C4; Wed, 16 Sep 2026 08:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFD26B00C5; Wed, 16 Sep 2026 08:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E2B6B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:08:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8D8B1406E1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:08:31 +0000 (UTC)
X-FDA: 85219503222.09.52DAD6D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id 08AF8C0012
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:08:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MU1WFwOl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MU1WFwOl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560509;
	b=Ckd2IqHhbbZ6/K/DarISFrOEiROUyi6zVpxLJvzLXGbNgV362kQZ/OvA9vmzmgJ89yUvYc
	bzXbA/TGrfzVERsuUI0v6V52P06omU6jEDk6kgIQH59Fbm6q++v1R+xclVnnFp3l6pVord
	dvS3eKvGZYPaZzDV3D0nyAO2votLJBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Dx1ebcBI5HjNHBmqlgN4TZRpTnGWWSAe/4bdghxepGY=;
	b=qSwuXBX2nuVGQFGDlQNmQe3J0HPUvicx+OJ4ojVrcjS3Ubbxpb2uD8xJhwcWoNzejD99WL
	9Ze80V8bll1m4AHvL1d3Kk5WpTED5PUIsCw1vrj4aXXmvJdy4hArl4+e6x0yDGj0SlecvH
	UPVHAx6203eAFNDLGRwnZEK3g9JGRkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789560510; x=1821096510;
  h=date:from:to:cc:subject:message-id;
  bh=TghH4XulWa23VyOfCcaY+lV7aJfuDz9cEi4ZOHNcLD0=;
  b=MU1WFwOlVUedZ/zTKSVTEZ6caoUWAN7tzz75sip4PohtFcZQ9962fbqv
   AsEDThatc6qSrzrc6U8FtJHsJoi/RmxWeticwM4G559Hs5Rk03sFOHyhJ
   izTGYbqIwX/5p4M92yCiaRrUbWi/GRq7QfLQ46wwaDXeraHLK4p7mzkAm
   eSyZ54ek0Rc577ehZduTJy0Pf/zWip3cimnDn4syJFYzpbqvtWfnQNw9W
   tBMVMXc3YZHPykccap3oY5VxGfALPmD8AejiBn8+xN+JnpxfGaKxUhlcE
   rXDx8/XDqjrJbzG+dcNAo342yhPJKF12Fm1anO+5OEbj6fWBU09Dm8bRV
   A==;
X-CSE-ConnectionGUID: GchVtNl4SOONNVeUUxAjXw==
X-CSE-MsgGUID: zGndqLYySlO/6pI2YNZ0Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="101452224"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="101452224"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 05:08:28 -0700
X-CSE-ConnectionGUID: VFTy8kAgS16XZI3fwlQPWQ==
X-CSE-MsgGUID: M0JvM8MWRo2a6O1bJ4+jYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="267109325"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 16 Sep 2026 05:08:26 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6oR5-0000000060X-3rbD;
	Wed, 16 Sep 2026 12:08:23 +0000
Date: Wed, 16 Sep 2026 20:08:14 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 5728d3523f12826a2b180c1c5738f74e33197e14
Message-ID: <202609162011.Vn0W69BZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 08AF8C0012
X-Stat-Signature: 4qudfknouxxj165tkjk1yfin13pa8twr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789560508-707012
X-HE-Meta: U2FsdGVkX1/0LA76AgmRzvw+D92Sc9TxyK88Y7FRkAjlENs0G89oDiZoTzVStBzVLJla5GLxuOSPvEKhlCPTaH13OOBcPSEQ33VJMmEuLdjQW9Z7oNrieP0FwaGytiPAGmpzAy41Rje9xgcRyMgbTfvHVDzQZhbhZT3sjUxc8dHo9JHqehZ0bwSJYAc999FuJeO153cJlO2R62HN44HUaFe7zQSyX7lB/RUE6eAcS5/GLVjDO/NjSvcP3dQc9PpTyX/i/zTzfRVe0DNtyITezL15bi0fP2B/9LorsXe4oPTaKok1FIUkw5qMKUhCy/WhTzp0VsR3Sb/K1bUyob+H/lNn/lF8cZ3X5BAEGL9WmKT3GGixOxLqMYeZLqc/It5qVJsHGwUdLqnUJlIU1S4orvskcloLkeK9g8pdsESo+oGj4aKWR36XC3aHRZHssKbhYZl9bq1eI6+RX15QM3agHHeUtYMx/hyPz+gZN2d0WogIkF4ahK5Pu6OPYkSR9eSCxtoBN9MXe49O/2xqu2eiLDnH+ghmfRreHD3s6z0Ww5uGy9z53L7wYCHZAC8w1mkugFOLqyZtv9qZuqb18wynvo0/L2jVxGbu/L8VZCk6LdJI/azYkQD4COBzstX29AdEo71p5spH4/th5jPoIFd8uH37C+g0QCyIKmmPoGQhZ9cxwXGiGcD8RXwTh3+AVRkAhmW8ImbBn8GUjK0XpGyRO/zJtZObIqMnRhw9tH0/hwa0g4FzFd9niskckHyMFdJ3484fqMsHjr1jIcsXEgkZhpZml1V3LhZh0R37kEbyAlkmNalyjwmmQaKNpfYsJbJ6UM7uSYrkzYEVphn4JXr+iqmavp/Y80GQjqW0UVBrkLeu4c3PmLdFngjiVGb+SHY2hgM2iKKaiCW+BXwWPXOsw6DOD7NkAlcUetyimsuKUVjBHvWG+UjH+hQVehuVsz/0kuvve5x3P6rY/yf5lhQ
 BFsjL9Nj
 FKKeUKxObYh7h/XY/J6HHkG5fsmQJ/PjD7P/BqznwvTOlc/uE1x7RmGhG6IcHKFiVP7F0PPVS77ITv69E0PIBkfHSTWBB66hV7ubzp62tvyDVk+NFA+UhfTX88hWmbIro08DgQk/MbadAursRGdLDFWz7OIm47Zfles3uVZYwPnoXPZpjpwHDtFwI0YIL8sART3NmzULBqyMHhQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 5728d3523f12826a2b180c1c5738f74e33197e14  memblock: reject non-page-aligned reserve_mem regions

elapsed time: m

configs tested: 258
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r063-20260915    gcc-13.4.0
alpha                randconfig-r063-20260915    gcc-8.5.0
arc                              allmodconfig    clang-24
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                                 defconfig    gcc-16.1.0
arc                 nsimosci_hs_smp_defconfig    clang-20
arc                   randconfig-001-20260916    clang-24
arc                   randconfig-002-20260916    clang-24
arc                  randconfig-r062-20260915    gcc-8.5.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                           h3600_defconfig    gcc-16.1.0
arm                   randconfig-001-20260916    clang-24
arm                   randconfig-002-20260916    clang-24
arm                   randconfig-003-20260916    clang-24
arm                   randconfig-004-20260916    clang-24
arm                  randconfig-r071-20260916    clang-19
arm                  randconfig-r072-20260915    clang-17
arm                  randconfig-r133-20260916    gcc-16.1.0 sparse
arm                           tegra_defconfig    clang-20
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-16.1.0
arm64                 randconfig-002-20260916    gcc-16.1.0
arm64                 randconfig-003-20260916    gcc-16.1.0
arm64                 randconfig-004-20260916    gcc-16.1.0
arm64                randconfig-r053-20260916    clang-24
arm64                randconfig-r062-20260915    gcc-8.5.0
arm64                randconfig-r072-20260915    gcc-11.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260916    gcc-16.1.0
csky                  randconfig-002-20260916    gcc-16.1.0
csky                 randconfig-r062-20260915    gcc-13.4.0
csky                 randconfig-r111-20260916    clang-24 sparse
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260916    gcc-16.1.0
hexagon               randconfig-002-20260916    gcc-16.1.0
hexagon              randconfig-r052-20260916    clang-24
hexagon              randconfig-r054-20260915    clang-17
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260916    clang-22
i386        buildonly-randconfig-002-20260916    clang-22
i386        buildonly-randconfig-003-20260916    clang-22
i386        buildonly-randconfig-004-20260916    clang-22
i386        buildonly-randconfig-005-20260916    clang-22
i386        buildonly-randconfig-006-20260916    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260916    gcc-14
i386                  randconfig-002-20260916    gcc-14
i386                  randconfig-003-20260916    gcc-14
i386                  randconfig-004-20260916    gcc-14
i386                  randconfig-005-20260916    gcc-14
i386                  randconfig-006-20260916    gcc-14
i386                  randconfig-007-20260916    gcc-14
i386                  randconfig-011-20260916    clang-22
i386                  randconfig-012-20260916    clang-22
i386                  randconfig-013-20260916    clang-22
i386                  randconfig-014-20260916    clang-22
i386                  randconfig-015-20260916    clang-22
i386                  randconfig-016-20260916    clang-22
i386                  randconfig-017-20260916    clang-22
i386                  randconfig-051-20260915    clang-22
i386                  randconfig-051-20260916    gcc-14
i386                  randconfig-052-20260915    clang-22
i386                  randconfig-052-20260916    gcc-14
i386                  randconfig-053-20260915    clang-22
i386                  randconfig-053-20260916    gcc-14
i386                  randconfig-054-20260915    clang-22
i386                  randconfig-054-20260916    gcc-14
i386                  randconfig-141-20260915    clang-22
i386                  randconfig-141-20260916    gcc-14
i386                 randconfig-r051-20260915    clang-17
i386                 randconfig-r131-20260916    gcc-16.1.0 sparse
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260916    gcc-16.1.0
loongarch             randconfig-002-20260916    gcc-16.1.0
loongarch            randconfig-r072-20260915    gcc-16.1.0
loongarch            randconfig-r111-20260916    gcc-12.5.0 sparse
loongarch            randconfig-r121-20260916    gcc-12.5.0 sparse
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                                defconfig    clang-24
m68k                       m5329evb_defconfig    clang-20
m68k                 randconfig-r051-20260915    gcc-8.5.0
m68k                 randconfig-r053-20260915    gcc-8.5.0
m68k                 randconfig-r064-20260916    gcc-8.5.0
m68k                 randconfig-r072-20260916    gcc-14.3.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze           randconfig-r054-20260916    clang-24
microblaze           randconfig-r073-20260915    gcc-8.5.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                           ip22_defconfig    gcc-16.1.0
mips                 randconfig-r063-20260915    gcc-8.5.0
mips                 randconfig-r073-20260915    gcc-16.1.0
mips                 randconfig-r113-20260916    clang-24 sparse
mips                 randconfig-r123-20260916    gcc-12.5.0 sparse
mips                           rs90_defconfig    gcc-16.1.0
mips                        vocore2_defconfig    clang-20
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-24
nios2                               defconfig    clang-24
nios2                 randconfig-001-20260916    gcc-16.1.0
nios2                 randconfig-002-20260916    gcc-16.1.0
nios2                randconfig-r053-20260915    clang-17
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r071-20260915    gcc-14.3.0
openrisc             randconfig-r134-20260916    gcc-16.1.0 sparse
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260916    clang-24
parisc                randconfig-002-20260916    clang-24
parisc               randconfig-r052-20260915    clang-17
parisc               randconfig-r052-20260915    gcc-8.5.0
parisc               randconfig-r054-20260915    gcc-8.5.0
parisc               randconfig-r062-20260916    gcc-8.5.0
parisc               randconfig-r122-20260916    gcc-12.5.0 sparse
parisc               randconfig-r132-20260916    gcc-11.5.0 sparse
parisc64                         alldefconfig    clang-20
parisc64                            defconfig    clang-24
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                        cell_defconfig    gcc-16.1.0
powerpc                   currituck_defconfig    clang-20
powerpc                 linkstation_defconfig    gcc-16.1.0
powerpc                     mpc512x_defconfig    clang-20
powerpc               randconfig-001-20260916    clang-24
powerpc               randconfig-002-20260916    clang-24
powerpc              randconfig-r113-20260916    gcc-12.5.0 sparse
powerpc              randconfig-r122-20260916    clang-24 sparse
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260916    clang-24
powerpc64             randconfig-002-20260916    clang-24
powerpc64            randconfig-r073-20260916    gcc-10.5.0
powerpc64            randconfig-r112-20260916    gcc-12.5.0 sparse
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260916    gcc-16.1.0
riscv                 randconfig-002-20260916    gcc-16.1.0
riscv                randconfig-r064-20260915    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260916    gcc-16.1.0
s390                  randconfig-002-20260916    gcc-16.1.0
s390                 randconfig-r063-20260916    gcc-8.5.0
s390                 randconfig-r064-20260915    gcc-8.5.0
s390                 randconfig-r133-20260916    gcc-11.5.0 sparse
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                          lboxre2_defconfig    gcc-16.1.0
sh                    randconfig-001-20260916    gcc-16.1.0
sh                    randconfig-002-20260916    gcc-16.1.0
sh                   randconfig-r061-20260915    gcc-13.4.0
sh                   randconfig-r123-20260916    clang-24 sparse
sh                          sdk7786_defconfig    clang-20
sh                           se7751_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260916    gcc-14.3.0
sparc                 randconfig-002-20260916    gcc-14.3.0
sparc                randconfig-r051-20260916    clang-24
sparc                randconfig-r061-20260915    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260916    gcc-14.3.0
sparc64               randconfig-002-20260916    gcc-14.3.0
sparc64              randconfig-r061-20260915    gcc-8.5.0
sparc64              randconfig-r071-20260915    gcc-15.2.0
sparc64              randconfig-r112-20260916    clang-24 sparse
sparc64              randconfig-r134-20260916    gcc-11.5.0 sparse
um                               allmodconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260916    gcc-14.3.0
um                    randconfig-002-20260916    gcc-14.3.0
um                   randconfig-r061-20260916    gcc-8.5.0
um                   randconfig-r121-20260916    clang-24 sparse
um                   randconfig-r132-20260916    gcc-16.1.0 sparse
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-24
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260916    clang-22
x86_64                randconfig-002-20260916    clang-22
x86_64                randconfig-003-20260916    clang-22
x86_64                randconfig-004-20260916    clang-22
x86_64                randconfig-005-20260916    clang-22
x86_64                randconfig-006-20260916    clang-22
x86_64                randconfig-011-20260916    gcc-14
x86_64                randconfig-012-20260916    gcc-14
x86_64                randconfig-013-20260916    gcc-14
x86_64                randconfig-014-20260916    gcc-14
x86_64                randconfig-015-20260916    gcc-14
x86_64                randconfig-016-20260916    gcc-14
x86_64                randconfig-071-20260916    gcc-14
x86_64                randconfig-072-20260916    gcc-14
x86_64                randconfig-073-20260916    gcc-14
x86_64                randconfig-074-20260916    gcc-14
x86_64                randconfig-075-20260916    gcc-14
x86_64                randconfig-076-20260916    gcc-14
x86_64                randconfig-101-20260915    clang-22
x86_64                randconfig-101-20260916    clang-22
x86_64                randconfig-102-20260915    clang-22
x86_64                randconfig-102-20260916    clang-22
x86_64                randconfig-103-20260915    clang-22
x86_64                randconfig-103-20260916    clang-22
x86_64                randconfig-104-20260915    clang-22
x86_64                randconfig-104-20260916    clang-22
x86_64                randconfig-161-20260915    clang-22
x86_64                randconfig-161-20260916    gcc-14
x86_64               randconfig-r064-20260915    gcc-13.4.0
x86_64               randconfig-r071-20260915    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                           allyesconfig    clang-20
xtensa                randconfig-001-20260916    gcc-14.3.0
xtensa                randconfig-002-20260916    gcc-14.3.0
xtensa               randconfig-r131-20260916    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

