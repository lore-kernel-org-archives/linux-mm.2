Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E865CC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 02:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C616B007B; Sun,  9 Aug 2026 22:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D196B008A; Sun,  9 Aug 2026 22:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4726B008C; Sun,  9 Aug 2026 22:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3429E6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:44:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79E02A2723
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:44:56 +0000 (UTC)
X-FDA: 85083817392.03.CF450F6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7854140004
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:44:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZH1ibE0w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786329894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Xy0DiHi6rp1kTW0lH93+tnafzgFo/aGJwfUlHNq/gAg=;
	b=auxVtw+7SvK4kQj1phdLNTkektHFogXrZd2h1UZsr2jfhs1asRe91/ejRbgksraHRtkutI
	nU4QogTYoVmMA1gvtUv+SPE+rImt+MQDJmWHpZsSZn95xp10sSlJD5pipqi9ldjFEIYmo3
	rPXD0u7yeOIYNkwxiln9tbmf+oH/W5Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZH1ibE0w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786329894;
	b=OG5tIm1yKZJpw3BeoEkqe8YVJzE/DvNk8GnM/KWj7zOkjyqafnXRCH5jmKiX0uND85novG
	EYkdEmd7aydNoKSgaej+B4lNdECo3e9WuloPRj+1RNMGHsEjuefRZ5kWNQQVTueCiJjoTz
	ERM6VTKA0XNKKGEX/GmG8CFRODjTZG8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786329894; x=1817865894;
  h=date:from:to:cc:subject:message-id;
  bh=dNibfJOjzfB6Rk3tx3l6uL60JnhSxzt2abciXXd1ork=;
  b=ZH1ibE0w6dJYZJ1G3CMnAUMpIJtvF9/hqvj99X73bpVDHwXGavV+/ppg
   8ZyKADohG9ZR4D3mkFIBg/4WuH442NOsqtaIkdePD/8JIBEqoHrFkMbDA
   lOihvNcIKLRlWAFz9eK1M0rG2zrjAq6Bwpgg6310qcPyh/cXR5RUZacy4
   l7T24Gx9/ux91402tW5O/9MBGbMz0vu2QkTeivTuutLw7FGghRX+VtAoz
   ujX38Xf9yb58TBnitwr2l8XmC7SAkv1K4zXUuqFcm4kPePH83NTa8JaPA
   rowoZ7liIl7musBv4sEjUtiv6x9dyxo611JPyrgXSJdHYMPxon3jVtKrl
   A==;
X-CSE-ConnectionGUID: acpTRdOvTmiJdTC/OJMzDg==
X-CSE-MsgGUID: Owddh9nQTliYm/uBzweM7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86846352"
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="86846352"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 19:44:53 -0700
X-CSE-ConnectionGUID: KZgL7WBwQayZLcwLgxo0Rw==
X-CSE-MsgGUID: 0LS2jt1XRLSB2e1r64fUGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,214,1779174000"; 
   d="scan'208";a="259593503"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 09 Aug 2026 19:44:51 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wtG0O-00000000Mc6-1PYP;
	Mon, 10 Aug 2026 02:44:48 +0000
Date: Mon, 10 Aug 2026 10:44:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <202608101053.PhnVUM4u-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: c1xut41ohfmdtf3iiqp8jm6innm13qce
X-Rspamd-Queue-Id: B7854140004
X-HE-Tag: 1786329893-345272
X-HE-Meta: U2FsdGVkX1/DkG5hangUV30GK2amKcmvEi2vx796LwSm4EgaYATAZRWpoMgYcC/NoZ0a7y+829Z6yvfxuzUlsCVzBaSN7IaWNY36jdcJiQYXoL3fsk+J4g5TJVQDom25MRqb0tiTW/XeUYxqG8JvtUq362Fu80EPRzrjc14LuYAIm2FDOJtxuGHpcOfBuqfMIy+F679ROlx/w97kmo24HFxfs1dEIYo8nwy6EOxfoGK98MNFOAinE7mKwqWpcjXeEiFey83+wKaEkGgYIh9toIrnBAC27pJiARDONwodOMnKQIoNnN7RaBdeYuc3mUuOeQ3Vqy4nRoKGkTw1ezbaXAEiMch9HoansJ0ud1fTw315flWTfg8gDQBFRKQbS6BCvh0hBwM3fL62Qs8QkVG8Px9QXztWlov/ZTYBb91LC8Jp7qE05hwtvjs3ivY2CxDp8JC6XkKl/CbNin8ioLBImP5ESZIPQ3wlmUt88razCqFu4C7wzUf8n6DlqFuRN/mECphi9YAfT6kz3dwKJyYfK7Oa6hb7/3wiWmSGrpySLLaqLXwOtMW7W2o7oeOUQlNdrFZX7PMdp+wxHZl+nCg63/VlpnGgquYXZQugp5zvLyhewhvsr14uZESmlfdaE10p2kLNnCizospDojZ5H3CidAtamoz2Ddizg8KgycTIMlruhPbXVqdKSt7b7TBwcLOtJBL530M9lH0pRo6oDB/vecZ0X/Y45V2iimVg3cB7oA1rb5nh4VInwviMy0fhC/LmIAraoq8/lqMZqLFaz+XlERWbMXZLI//ByIjl2qBo/zVatnLEkjpH8pYhQVNGM4ONWzdzDPmc5rB4S/2MWxNyv9JPho5vkLuXxWB//y67eIvkhAc1+13wPiOuf8zJ7uDDkt/XC9zTAInNkGUc9ZGVV/73T0LGCR8o3tUJLdMP335c5QfmZqOqKIxnxuAfiUwAQOylhadHtv0CaLOeLqZ
 /DQouSVh
 eKqJnoiP1vlN2SvTuXl54ZelidAQWJs+GyF6fZ3pURtDBJW7KmdHzxezzWtTf6V38b56+uaNSxU1YBb1cOHgnagpnnC6jmzaYZUKA+6NGLXVcp5r0iMrUyqBWUZxSCv9b7wnUKd+h3z9PLPcWeRTL/pIO75dke0R8lcmGkNMCRpUuEUPWFDMC2Rcf4WyCNOAxpORud0DyNuzLiAr/S3dlGYwsrJaE9id5a0sM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- s390-randconfig-r071-20260809
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1506m

configs tested: 234
configs skipped: 0

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260809    gcc-10.5.0
arc                  randconfig-001-20260809    gcc-12.5.0
arc                  randconfig-001-20260810    gcc-8.5.0
arc                  randconfig-002-20260809    gcc-12.5.0
arc                  randconfig-002-20260810    gcc-8.5.0
arm                           hisi_defconfig    gcc-16.1.0
arm                  randconfig-001-20260809    gcc-12.5.0
arm                  randconfig-001-20260809    gcc-8.5.0
arm                  randconfig-001-20260810    gcc-8.5.0
arm                  randconfig-002-20260809    gcc-10.5.0
arm                  randconfig-002-20260809    gcc-12.5.0
arm                  randconfig-002-20260810    gcc-8.5.0
arm                  randconfig-003-20260809    clang-24
arm                  randconfig-003-20260809    gcc-12.5.0
arm                  randconfig-003-20260810    gcc-8.5.0
arm                  randconfig-004-20260809    clang-17
arm                  randconfig-004-20260809    gcc-12.5.0
arm                  randconfig-004-20260810    gcc-8.5.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260809    gcc-10.5.0
arm64                randconfig-001-20260809    gcc-14.3.0
arm64                randconfig-001-20260810    gcc-16.1.0
arm64                randconfig-002-20260809    gcc-12.5.0
arm64                randconfig-002-20260809    gcc-14.3.0
arm64                randconfig-002-20260810    gcc-16.1.0
arm64                randconfig-003-20260809    clang-19
arm64                randconfig-003-20260809    gcc-14.3.0
arm64                randconfig-003-20260810    gcc-16.1.0
arm64                randconfig-004-20260809    clang-24
arm64                randconfig-004-20260809    gcc-14.3.0
arm64                randconfig-004-20260810    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260809    gcc-14.3.0
csky                 randconfig-001-20260809    gcc-16.1.0
csky                 randconfig-001-20260810    gcc-16.1.0
csky                 randconfig-002-20260809    gcc-14.3.0
csky                 randconfig-002-20260810    gcc-16.1.0
hexagon              randconfig-001-20260809    clang-17
hexagon              randconfig-001-20260809    gcc-12.5.0
hexagon              randconfig-001-20260810    gcc-10.5.0
hexagon              randconfig-002-20260809    clang-17
hexagon              randconfig-002-20260809    gcc-12.5.0
hexagon              randconfig-002-20260810    gcc-10.5.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260809    clang-22
i386       buildonly-randconfig-001-20260810    clang-22
i386       buildonly-randconfig-002-20260809    clang-22
i386       buildonly-randconfig-002-20260810    clang-22
i386       buildonly-randconfig-003-20260809    clang-22
i386       buildonly-randconfig-003-20260810    clang-22
i386       buildonly-randconfig-004-20260809    clang-22
i386       buildonly-randconfig-004-20260809    gcc-14
i386       buildonly-randconfig-004-20260810    clang-22
i386       buildonly-randconfig-005-20260809    clang-22
i386       buildonly-randconfig-005-20260809    gcc-14
i386       buildonly-randconfig-005-20260810    clang-22
i386       buildonly-randconfig-006-20260809    clang-22
i386       buildonly-randconfig-006-20260810    clang-22
i386                 randconfig-001-20260809    clang-22
i386                 randconfig-001-20260810    gcc-14
i386                 randconfig-002-20260809    clang-22
i386                 randconfig-002-20260809    gcc-14
i386                 randconfig-002-20260810    gcc-14
i386                 randconfig-003-20260809    clang-22
i386                 randconfig-003-20260810    gcc-14
i386                 randconfig-004-20260809    clang-22
i386                 randconfig-004-20260810    gcc-14
i386                 randconfig-005-20260809    clang-22
i386                 randconfig-005-20260810    gcc-14
i386                 randconfig-006-20260809    clang-22
i386                 randconfig-006-20260810    gcc-14
i386                 randconfig-007-20260809    clang-22
i386                 randconfig-007-20260809    gcc-14
i386                 randconfig-007-20260810    gcc-14
i386                          randconfig-011    clang-22
i386                 randconfig-011-20260809    clang-22
i386                 randconfig-011-20260809    gcc-14
i386                 randconfig-011-20260810    clang-22
i386                 randconfig-012-20260809    clang-22
i386                 randconfig-012-20260810    clang-22
i386                 randconfig-013-20260809    clang-22
i386                 randconfig-013-20260809    gcc-14
i386                 randconfig-013-20260810    clang-22
i386                 randconfig-014-20260809    clang-22
i386                 randconfig-014-20260809    gcc-14
i386                 randconfig-014-20260810    clang-22
i386                 randconfig-015-20260809    clang-22
i386                 randconfig-015-20260809    gcc-14
i386                 randconfig-015-20260810    clang-22
i386                 randconfig-016-20260809    clang-22
i386                 randconfig-016-20260810    clang-22
i386                 randconfig-017-20260809    clang-22
i386                 randconfig-017-20260810    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260809    clang-18
loongarch            randconfig-001-20260809    gcc-12.5.0
loongarch            randconfig-001-20260810    gcc-10.5.0
loongarch            randconfig-002-20260809    gcc-12.5.0
loongarch            randconfig-002-20260810    gcc-10.5.0
mips                         ath25_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260809    gcc-12.5.0
nios2                randconfig-001-20260809    gcc-8.5.0
nios2                randconfig-001-20260810    gcc-10.5.0
nios2                randconfig-002-20260809    gcc-12.5.0
nios2                randconfig-002-20260809    gcc-8.5.0
nios2                randconfig-002-20260810    gcc-10.5.0
openrisc                 or1klitex_defconfig    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260809    gcc-15.2.0
parisc               randconfig-001-20260809    gcc-8.5.0
parisc               randconfig-001-20260810    gcc-8.5.0
parisc               randconfig-002-20260809    gcc-8.5.0
parisc               randconfig-002-20260810    gcc-8.5.0
powerpc              randconfig-001-20260809    clang-24
powerpc              randconfig-001-20260809    gcc-8.5.0
powerpc              randconfig-001-20260810    gcc-8.5.0
powerpc              randconfig-002-20260809    clang-24
powerpc              randconfig-002-20260809    gcc-8.5.0
powerpc              randconfig-002-20260810    gcc-8.5.0
powerpc64            randconfig-001-20260809    clang-17
powerpc64            randconfig-001-20260809    gcc-8.5.0
powerpc64            randconfig-001-20260810    gcc-8.5.0
powerpc64            randconfig-002-20260809    clang-24
powerpc64            randconfig-002-20260809    gcc-8.5.0
powerpc64            randconfig-002-20260810    gcc-8.5.0
riscv                randconfig-001-20260809    clang-24
riscv                randconfig-001-20260810    gcc-8.5.0
riscv                randconfig-002-20260809    clang-20
riscv                randconfig-002-20260809    clang-24
riscv                randconfig-002-20260810    gcc-8.5.0
s390                 randconfig-001-20260809    clang-24
s390                 randconfig-001-20260809    gcc-11.5.0
s390                 randconfig-001-20260810    gcc-8.5.0
s390                 randconfig-002-20260809    clang-24
s390                 randconfig-002-20260810    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260809    clang-24
sh                   randconfig-001-20260809    gcc-16.1.0
sh                   randconfig-001-20260810    gcc-8.5.0
sh                   randconfig-002-20260809    clang-24
sh                   randconfig-002-20260809    gcc-10.5.0
sh                   randconfig-002-20260810    gcc-8.5.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260809    gcc-11.5.0
sparc                randconfig-001-20260809    gcc-8.5.0
sparc                randconfig-001-20260810    gcc-11.5.0
sparc                randconfig-002-20260809    gcc-11.5.0
sparc                randconfig-002-20260810    gcc-11.5.0
sparc64              randconfig-001-20260809    gcc-11.5.0
sparc64              randconfig-001-20260809    gcc-9.5.0
sparc64              randconfig-001-20260810    gcc-11.5.0
sparc64              randconfig-002-20260809    clang-24
sparc64              randconfig-002-20260809    gcc-11.5.0
sparc64              randconfig-002-20260810    gcc-11.5.0
um                   randconfig-001-20260809    clang-18
um                   randconfig-001-20260809    gcc-11.5.0
um                   randconfig-001-20260810    gcc-11.5.0
um                   randconfig-002-20260809    clang-17
um                   randconfig-002-20260809    gcc-11.5.0
um                   randconfig-002-20260810    gcc-11.5.0
x86_64     buildonly-randconfig-001-20260809    clang-22
x86_64     buildonly-randconfig-001-20260810    gcc-14
x86_64     buildonly-randconfig-002-20260809    clang-22
x86_64     buildonly-randconfig-002-20260809    gcc-14
x86_64     buildonly-randconfig-002-20260810    gcc-14
x86_64     buildonly-randconfig-003-20260809    clang-22
x86_64     buildonly-randconfig-003-20260809    gcc-14
x86_64     buildonly-randconfig-003-20260810    gcc-14
x86_64     buildonly-randconfig-004-20260809    clang-22
x86_64     buildonly-randconfig-004-20260810    gcc-14
x86_64     buildonly-randconfig-005-20260809    clang-22
x86_64     buildonly-randconfig-005-20260810    gcc-14
x86_64     buildonly-randconfig-006-20260809    clang-22
x86_64     buildonly-randconfig-006-20260809    gcc-14
x86_64     buildonly-randconfig-006-20260810    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260809    clang-22
x86_64               randconfig-001-20260810    gcc-14
x86_64               randconfig-002-20260809    clang-22
x86_64               randconfig-002-20260809    gcc-14
x86_64               randconfig-002-20260810    gcc-14
x86_64               randconfig-003-20260809    clang-22
x86_64               randconfig-003-20260810    gcc-14
x86_64               randconfig-004-20260809    clang-22
x86_64               randconfig-004-20260810    gcc-14
x86_64               randconfig-005-20260809    clang-22
x86_64               randconfig-005-20260810    gcc-14
x86_64               randconfig-006-20260809    clang-22
x86_64               randconfig-006-20260809    gcc-14
x86_64               randconfig-006-20260810    gcc-14
x86_64               randconfig-011-20260809    clang-22
x86_64               randconfig-011-20260809    gcc-14
x86_64               randconfig-011-20260810    clang-22
x86_64               randconfig-012-20260809    gcc-14
x86_64               randconfig-012-20260810    clang-22
x86_64               randconfig-013-20260809    gcc-14
x86_64               randconfig-013-20260810    clang-22
x86_64               randconfig-014-20260809    clang-22
x86_64               randconfig-014-20260809    gcc-14
x86_64               randconfig-014-20260810    clang-22
x86_64               randconfig-015-20260809    gcc-14
x86_64               randconfig-015-20260810    clang-22
x86_64               randconfig-016-20260809    clang-22
x86_64               randconfig-016-20260809    gcc-14
x86_64               randconfig-016-20260810    clang-22
x86_64               randconfig-071-20260809    clang-22
x86_64               randconfig-071-20260810    clang-22
x86_64               randconfig-072-20260809    clang-22
x86_64               randconfig-072-20260810    clang-22
x86_64               randconfig-073-20260809    clang-22
x86_64               randconfig-073-20260810    clang-22
x86_64               randconfig-074-20260809    clang-22
x86_64               randconfig-074-20260810    clang-22
x86_64               randconfig-075-20260809    clang-22
x86_64               randconfig-075-20260809    gcc-14
x86_64               randconfig-075-20260810    clang-22
x86_64               randconfig-076-20260809    clang-22
x86_64               randconfig-076-20260810    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260809    gcc-11.5.0
xtensa               randconfig-001-20260809    gcc-13.4.0
xtensa               randconfig-001-20260810    gcc-11.5.0
xtensa               randconfig-002-20260809    gcc-11.5.0
xtensa               randconfig-002-20260810    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

