Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C040C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 23:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA556B0095; Thu,  6 Aug 2026 19:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484106B0096; Thu,  6 Aug 2026 19:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DBA6B0098; Thu,  6 Aug 2026 19:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC76B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:13:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC9251C024E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:13:15 +0000 (UTC)
X-FDA: 85072397550.12.226D1F0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id D8DCE40002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:13:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDBTHI9W;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=n1a4/Jg2fE0Cj2tgSyyj6rvWvXb+KZ1G0wEUSMZeXbs=;
	b=61l/vEd44zfctT0prMksvLKD69y0Lw8ZSMPBodME0m0/c1vt2zT+TXXZojR2XUK6Sa5QpC
	oG8E2pAQ3DdRcpR3fMdW+EW3Q+bMtw4lwmBDzd5oqBbOR203bD4Vttx3beE1bTESmS5/HP
	EGF+SphNQ3RQ++qh1835a+4PKjuzKpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057993;
	b=vjrxyg+46NcOuaniV/vXHK3hzQvBg9DrnWEmZa4eecB8Sqa777PW9wp3coldb8VlVj7GsN
	DNSAjlKH6FmKCWoHhxXHOe6NOvjMTFRYassd/Bdqu4SSD5IsNblV2EUgnWWipPUr7efstV
	kKFlLszpAPXMp0Erv3eIvVO5TpB+kaw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDBTHI9W;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786057993; x=1817593993;
  h=date:from:to:cc:subject:message-id;
  bh=teCkrAmoo6hgkt2QOgVoP40Zm2UrvjBI1z/3Fi0Cb8I=;
  b=FDBTHI9Wzp21DfiLU+E2glyE/Br9EvsCaWryvJS3yG9fZKdj4SQc8Zkg
   aiPrug+vUGMeDt21fSJbLgFIunuanV7WRu2MYKmeeiLBEqCdY6Qum5cBj
   rjpctAlTEtU5AR0W3+fEyp4kNQs/1GHwOs7bv61/aZVta2Obg7/3SbDqY
   MzcN1SsGL9N1xtx07lDXDrYYJwu2lNdpOe3b2rd5mW0aeMzPen199Cy3W
   hoxpGvp5q+Q2Xgt/OoUQhkeqdW8yoOSynXkQ5CI6VWHXqVSu8Uv/dGSRP
   /IdDj5fsbhODr7x8Nr/3GWhUBbBcK9IOjHKI3KZswtHZtifYzuPDnLxLM
   g==;
X-CSE-ConnectionGUID: 9Xup1J/MT52edE5S7bmBpw==
X-CSE-MsgGUID: dKNlIvLpRiWwUyzVlcL9kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="85636240"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="85636240"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 16:13:11 -0700
X-CSE-ConnectionGUID: zJXmgz1PRxu19IvuAVDscw==
X-CSE-MsgGUID: aWwJTnNDTeqWg83XAFA3Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="257929535"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Aug 2026 16:13:02 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws7Gl-00000000GXN-346p;
	Thu, 06 Aug 2026 23:12:59 +0000
Date: Fri, 07 Aug 2026 07:12:20 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 1fb556c523f6c18b43b1f52fb366f61c9963ce06
Message-ID: <202608070759.0EhTGUkj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8DCE40002
X-Stat-Signature: rnkgrud5juwchie8tw8a1c9m47a9bxja
X-Rspam-User: 
X-HE-Tag: 1786057992-459431
X-HE-Meta: U2FsdGVkX1/e7re5tu2JlGKU15hGFANLV8RXQztH3ZY/3BJwAQCRIh4/VBHlB8Z4q70cAQ2Aq/WFkj05WJuJ6vRlMvahDT9RufWYtGWUJcw29chIWbsi/TVRdq83igqzPRk1VHiOkqq4BIWZ+DKVMer6r63hcr37yKBDsL5/ParNlVbT02jOcDMDUEQfJjOVVW1YURlaZ3gyu1c8kgS0R2r9nYEuIBh5vO1YIAKDgOMcKZjqdSUQ1PQ4XM13v6rc4jfvJpdvb/EqRSmYaiFQD5ebgNfrjp4+nMwXJ1SerocVAa9u8hfc4s+dIkvba26iKHrxdI8Y/zWwnukUvr4rlEwzHmk0+h3JtSmd4Vvksjcre/K/sTUK0f6K0+BELg9oN8k/VEkkE9T2nGsvNHFtY98eZRw9LZvahaCzBM7o5icDk9/baASKk2BDZvzNmmxhxlrqXoCZimastZgytBuIKxDSYpb3GcwofLA8eGITL5/Utau7Nd3uSu3LgSZBl9ja0iHfN7mpjsuWEzzHuIyUjWYtSLj55uv6U4/T5pnXhHp/FfHJ7XaIy5H4NL2ZOBKmcbT99OVrnPIgLR7NgdBYBs6ugupN7IsyTyfVCIpAhSvEheTkJTwXVRidjKrrwxFBqpNbL5n3nun5siudz9F8EAG16Blxc7RseDXsqFndHeZ9nJWV8MxKBk2mG2tt7Yp+V7AXRo0GGO0+B/UZjN7KzkGxPUQU8C5OcvMd4ABFub0p6B47KP0Sdfoctd/cmtU1QebyhNjTGhIOM3Fm8Yk+yMWQ3tOObyLhWFfmrXSIK77y9F22i39hg1BMx5i+Z/GD3cqBUIKzRa+kXLWS3F49vGtVHbFgfrlmb92Hs9+5mvbUKhxKe7K30Hp/1liYP7SAi08qsiOXqkMy9l4147tSobiOcdSXGBPtTZptatB6pG2uB0Zitbpi3Bodg6tu33sRnZf/0OQA9wgr9yYQ2uW
 ufuTL91W
 rptcjCdPdHjsmg4ZL2rO8TPeA0JeDeRPJTXswtRyx4mTO9O+SfRfPFXDXtpDSmnjNyrAgoyVIiH/TXlYzdNa+8iRNyW+fHLvOwuBnRVO4kEmbMxBrqkBBf8r2Ik0+EgXJFbgDRM5fzPRQQggIRR/YiauKdqhT3Z8wiMftcuCvmKZJiIk9nGcX2/Ei3ornn5hXs8sBWfOXjB3FEY+jOHNIp53MBKS8yRWmAjah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1fb556c523f6c18b43b1f52fb366f61c9963ce06  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- i386-randconfig-141-20260806
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 1494m

configs tested: 218
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                         axs101_defconfig    gcc-16.1.0
arc                  randconfig-001-20260806    gcc-11.5.0
arc                  randconfig-001-20260806    gcc-8.5.0
arc                  randconfig-001-20260807    gcc-14.3.0
arc                  randconfig-002-20260806    gcc-11.5.0
arc                  randconfig-002-20260807    gcc-14.3.0
arm                  randconfig-001-20260806    clang-24
arm                  randconfig-001-20260806    gcc-11.5.0
arm                  randconfig-001-20260807    gcc-14.3.0
arm                  randconfig-002-20260806    gcc-10.5.0
arm                  randconfig-002-20260806    gcc-11.5.0
arm                  randconfig-002-20260807    gcc-14.3.0
arm                  randconfig-003-20260806    gcc-11.5.0
arm                  randconfig-003-20260806    gcc-8.5.0
arm                  randconfig-003-20260807    gcc-14.3.0
arm                  randconfig-004-20260806    gcc-11.5.0
arm                  randconfig-004-20260806    gcc-8.5.0
arm                  randconfig-004-20260807    gcc-14.3.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260806    gcc-13.4.0
arm64                randconfig-001-20260806    gcc-8.5.0
arm64                randconfig-001-20260807    gcc-16.1.0
arm64                randconfig-002-20260806    gcc-11.5.0
arm64                randconfig-002-20260806    gcc-13.4.0
arm64                randconfig-002-20260807    gcc-16.1.0
arm64                randconfig-003-20260806    clang-17
arm64                randconfig-003-20260806    gcc-13.4.0
arm64                randconfig-003-20260807    gcc-16.1.0
arm64                randconfig-004-20260806    clang-17
arm64                randconfig-004-20260806    gcc-13.4.0
arm64                randconfig-004-20260807    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260806    gcc-13.4.0
csky                 randconfig-001-20260806    gcc-15.2.0
csky                 randconfig-001-20260807    gcc-16.1.0
csky                 randconfig-002-20260806    gcc-13.4.0
csky                 randconfig-002-20260807    gcc-16.1.0
hexagon              randconfig-001-20260806    clang-24
hexagon              randconfig-001-20260807    clang-18
hexagon              randconfig-002-20260806    clang-24
hexagon              randconfig-002-20260807    clang-18
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260806    gcc-14
i386       buildonly-randconfig-001-20260807    gcc-13
i386       buildonly-randconfig-002-20260806    gcc-14
i386       buildonly-randconfig-002-20260807    gcc-13
i386       buildonly-randconfig-003-20260806    clang-22
i386       buildonly-randconfig-003-20260806    gcc-14
i386       buildonly-randconfig-003-20260807    gcc-13
i386       buildonly-randconfig-004-20260806    clang-22
i386       buildonly-randconfig-004-20260806    gcc-14
i386       buildonly-randconfig-004-20260807    gcc-13
i386       buildonly-randconfig-005-20260806    gcc-14
i386       buildonly-randconfig-005-20260807    gcc-13
i386       buildonly-randconfig-006-20260806    gcc-14
i386       buildonly-randconfig-006-20260807    gcc-13
i386                 randconfig-001-20260806    clang-22
i386                 randconfig-001-20260806    gcc-14
i386                 randconfig-002-20260806    clang-22
i386                 randconfig-003-20260806    clang-22
i386                 randconfig-003-20260806    gcc-14
i386                 randconfig-004-20260806    clang-22
i386                 randconfig-005-20260806    clang-22
i386                 randconfig-006-20260806    clang-22
i386                 randconfig-007-20260806    clang-22
i386                 randconfig-007-20260806    gcc-14
i386                 randconfig-011-20260806    clang-22
i386                 randconfig-011-20260807    clang-22
i386                 randconfig-012-20260806    clang-22
i386                 randconfig-012-20260807    clang-22
i386                 randconfig-013-20260806    clang-22
i386                 randconfig-013-20260807    clang-22
i386                 randconfig-014-20260806    clang-22
i386                 randconfig-014-20260807    clang-22
i386                 randconfig-015-20260806    clang-22
i386                 randconfig-015-20260806    gcc-13
i386                 randconfig-015-20260807    clang-22
i386                 randconfig-016-20260806    clang-22
i386                 randconfig-016-20260807    clang-22
i386                 randconfig-017-20260806    clang-22
i386                 randconfig-017-20260807    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260806    clang-22
loongarch            randconfig-001-20260806    clang-24
loongarch            randconfig-001-20260807    clang-18
loongarch            randconfig-002-20260806    clang-24
loongarch            randconfig-002-20260807    clang-18
m68k                      m5208evb_defconfig    gcc-16.1.0
m68k                         sun3x_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260806    clang-24
nios2                randconfig-001-20260806    gcc-9.5.0
nios2                randconfig-001-20260807    clang-18
nios2                randconfig-002-20260806    clang-24
nios2                randconfig-002-20260806    gcc-11.5.0
nios2                randconfig-002-20260807    clang-18
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260806    gcc-8.5.0
parisc               randconfig-001-20260807    gcc-8.5.0
parisc               randconfig-002-20260806    gcc-8.5.0
parisc               randconfig-002-20260807    gcc-8.5.0
powerpc              randconfig-001-20260806    gcc-11.5.0
powerpc              randconfig-001-20260806    gcc-8.5.0
powerpc              randconfig-001-20260807    gcc-8.5.0
powerpc              randconfig-002-20260806    gcc-8.5.0
powerpc              randconfig-002-20260807    gcc-8.5.0
powerpc64            randconfig-001-20260806    gcc-8.5.0
powerpc64            randconfig-001-20260807    gcc-8.5.0
powerpc64            randconfig-002-20260806    clang-22
powerpc64            randconfig-002-20260806    gcc-8.5.0
powerpc64            randconfig-002-20260807    gcc-8.5.0
riscv                randconfig-001-20260806    gcc-13.4.0
riscv                randconfig-001-20260807    gcc-12.5.0
riscv                randconfig-002-20260806    gcc-13.4.0
riscv                randconfig-002-20260806    gcc-8.5.0
riscv                randconfig-002-20260807    gcc-12.5.0
s390                 randconfig-001-20260806    clang-24
s390                 randconfig-001-20260806    gcc-13.4.0
s390                 randconfig-001-20260807    gcc-12.5.0
s390                 randconfig-002-20260806    clang-24
s390                 randconfig-002-20260806    gcc-13.4.0
s390                 randconfig-002-20260807    gcc-12.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260806    gcc-11.5.0
sh                   randconfig-001-20260806    gcc-13.4.0
sh                   randconfig-001-20260807    gcc-12.5.0
sh                   randconfig-002-20260806    gcc-13.4.0
sh                   randconfig-002-20260806    gcc-16.1.0
sh                   randconfig-002-20260807    gcc-12.5.0
sparc                         randconfig-001    gcc-8.5.0
sparc                randconfig-001-20260806    gcc-16.1.0
sparc                randconfig-001-20260806    gcc-8.5.0
sparc                randconfig-001-20260807    gcc-16.1.0
sparc                randconfig-002-20260806    gcc-8.5.0
sparc                randconfig-002-20260807    gcc-16.1.0
sparc64              randconfig-001-20260806    clang-20
sparc64              randconfig-001-20260806    gcc-8.5.0
sparc64              randconfig-001-20260807    gcc-16.1.0
sparc64              randconfig-002-20260806    gcc-8.5.0
sparc64              randconfig-002-20260807    gcc-16.1.0
um                   randconfig-001-20260806    gcc-14
um                   randconfig-001-20260806    gcc-8.5.0
um                   randconfig-001-20260807    gcc-16.1.0
um                   randconfig-002-20260806    gcc-14
um                   randconfig-002-20260806    gcc-8.5.0
um                   randconfig-002-20260807    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260806    clang-22
x86_64     buildonly-randconfig-001-20260807    clang-22
x86_64     buildonly-randconfig-002-20260806    clang-22
x86_64     buildonly-randconfig-002-20260807    clang-22
x86_64     buildonly-randconfig-003-20260806    clang-22
x86_64     buildonly-randconfig-003-20260806    gcc-14
x86_64     buildonly-randconfig-003-20260807    clang-22
x86_64     buildonly-randconfig-004-20260806    clang-22
x86_64     buildonly-randconfig-004-20260807    clang-22
x86_64     buildonly-randconfig-005-20260806    clang-22
x86_64     buildonly-randconfig-005-20260806    gcc-14
x86_64     buildonly-randconfig-005-20260807    clang-22
x86_64     buildonly-randconfig-006-20260806    clang-22
x86_64     buildonly-randconfig-006-20260806    gcc-14
x86_64     buildonly-randconfig-006-20260807    clang-22
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260806    clang-22
x86_64               randconfig-001-20260807    clang-22
x86_64               randconfig-002-20260806    clang-22
x86_64               randconfig-002-20260807    clang-22
x86_64               randconfig-003-20260806    clang-22
x86_64               randconfig-003-20260806    gcc-14
x86_64               randconfig-003-20260807    clang-22
x86_64               randconfig-004-20260806    clang-22
x86_64               randconfig-004-20260807    clang-22
x86_64               randconfig-005-20260806    clang-22
x86_64               randconfig-005-20260807    clang-22
x86_64               randconfig-006-20260806    clang-22
x86_64               randconfig-006-20260806    gcc-14
x86_64               randconfig-006-20260807    clang-22
x86_64               randconfig-011-20260806    clang-22
x86_64               randconfig-011-20260807    clang-22
x86_64               randconfig-012-20260806    clang-22
x86_64               randconfig-012-20260806    gcc-12
x86_64               randconfig-012-20260807    clang-22
x86_64               randconfig-013-20260806    clang-22
x86_64               randconfig-013-20260807    clang-22
x86_64               randconfig-014-20260806    clang-22
x86_64               randconfig-014-20260807    clang-22
x86_64               randconfig-015-20260806    clang-22
x86_64               randconfig-015-20260807    clang-22
x86_64               randconfig-016-20260806    clang-22
x86_64               randconfig-016-20260806    gcc-14
x86_64               randconfig-016-20260807    clang-22
x86_64               randconfig-071-20260806    gcc-14
x86_64               randconfig-071-20260807    clang-22
x86_64               randconfig-072-20260806    gcc-14
x86_64               randconfig-072-20260807    clang-22
x86_64               randconfig-073-20260806    gcc-14
x86_64               randconfig-073-20260807    clang-22
x86_64               randconfig-074-20260806    gcc-14
x86_64               randconfig-074-20260807    clang-22
x86_64               randconfig-075-20260806    clang-22
x86_64               randconfig-075-20260806    gcc-14
x86_64               randconfig-075-20260807    clang-22
x86_64               randconfig-076-20260806    gcc-14
x86_64               randconfig-076-20260807    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260806    gcc-14.3.0
xtensa               randconfig-001-20260806    gcc-8.5.0
xtensa               randconfig-001-20260807    gcc-16.1.0
xtensa               randconfig-002-20260806    gcc-16.1.0
xtensa               randconfig-002-20260806    gcc-8.5.0
xtensa               randconfig-002-20260807    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

