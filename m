Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499E6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8C16B05BA; Thu, 13 Aug 2026 16:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AC86B05BB; Thu, 13 Aug 2026 16:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278296B05BC; Thu, 13 Aug 2026 16:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F30096B05BA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:00:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0E2BC027E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:00:20 +0000 (UTC)
X-FDA: 85097313000.29.A0F5EC0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id 000281C000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:00:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mff5HToP;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786651218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PFOj2T3Y4EGxKUxHVLR58yyIvAtW5OymNixeCrS83R0=;
	b=3UpDP75oMDLutaNe5aKp8s8b4foC9HlHZqOvn95nWH9zhtgno952XVNG0fmAFP0wEhIDnJ
	OGp4BnTAJvneOD6KnD6SlQ1vJ14liDtsCgsM/cH7y0RIYRfxW6RWBD2Sf95yQqq+MJmzVV
	LtfWodxCxC2TuoLRE5Iwnag4ZlgLfFg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mff5HToP;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786651218;
	b=gvW1ZaoxNHdECycWl272Vx7pOVO8WFR+rtGyC1fF/I9yy1ERE4hbTd46A7/1GPY3OUqHZx
	FwCjhCGzoKMx3nfhfpMiFqyna4/1+Bgixj0SdlBNDWRZDEFKs7FDg9d5CIxzNsuSpoUihO
	alSV/qNQKghgI0VIY0Jf/hm8hlDLWRE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786651218; x=1818187218;
  h=date:from:to:cc:subject:message-id;
  bh=9vzAxeBH2BtC0FH01hUcoTki5Yl0Y1uumD4S1t1C8BI=;
  b=mff5HToPlR4qJRmM5bPY0mR/CeNyrlOZW1OZWVnYFsYoO91Cw0fgkfTo
   Aym2BOTTc15ax8ORBC9FsMNrbeQNnKHPVnSjOuR0p6nw4aXQtfQw55O0w
   CDQ9u35Yv2YG9JfNKxP5hq2F2byiCvPDd2SK9D8iRP8lZHaj0nNC/YObN
   SJNoNNvIdztCnw96qmxxo3hYN5crkO/75RiKI4qI/DdSI0OpbnegIQq05
   7GyCSyE4q4S+TCcLvGbYE8I5CJJcMoEorOzc2ba2nkWamR7DXyKmsCsaa
   ptjjVbKlPkLm1qSCu+O3zraFVCM+YxewKyUUuQ8kFpoS+VqyLAHjRFNRJ
   w==;
X-CSE-ConnectionGUID: k3hyHUBmSMyXTm9oIt03gg==
X-CSE-MsgGUID: VbL8FV6RQ9ycw0NJwL+Xuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97900469"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="97900469"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 13:00:16 -0700
X-CSE-ConnectionGUID: jl44uicwQouakakoggUYlA==
X-CSE-MsgGUID: Si13IeYuSzKRAqQMJYAx9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="260224902"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 13 Aug 2026 13:00:14 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wubb2-00000000WSI-2MhB;
	Thu, 13 Aug 2026 20:00:12 +0000
Date: Fri, 14 Aug 2026 04:00:07 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7ba5daade5ab61776382020b708b1ef75c9af1ea
Message-ID: <202608140354.JfBGizlK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: g3go9zkqe6h9rs3dj5ma18rk49fxg33z
X-Rspamd-Queue-Id: 000281C000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786651217-201126
X-HE-Meta: U2FsdGVkX19dqE4t3z93qLOzEnZkaw9JWJ4GML+GBzoxMPXc+1ZPYk/uPnNE09jvNK8ONmz/gojGE/Ya36CPXoDp0RmRDC/3eAhs+VSphIV3LssO0GMRH+SJ8Od7aIVXK+9XZWW2WFX/lO3mMYdIxv8pbDwXk2hWs6hW/wXq7u81PvwAlbZvneesqgjAX51ozAezGbOSI6tvYOtlXICBVRDIT3UZ7H0OVwe6SkinN96KvipNlitzMjUlcSfEURWFArYR6YdtvZ4HFWr+CmNnU1mYLPwfFQwU2rFirvDQ2FkwFXjrhJBfiFGmLWcFp4jDFzLdZb9XwGMBgKa9YkJDJhlH9IUhj2v6yI3tYBBW2ss7D6b5n7ixPH3u0AAVh7dt9cR2dNtuI8t8e6FXNxMRBUsMHJ0XyGzv2SvljkyWUet84xTSRT/X/Y2G+x8fa+6o7Rekywdz7vry3rSzXMrkMr1Wz1/Z5R03bMHERAGKO6ZvzN2u7EOratB5SjTmlnS1SH4ZHAifqBggUwitAbAEVbma5VOE9Y5bcP+llAFEyP4SpRTwf645trqXKqcz3fFgvJfloP4eNOSbprZ/xD+UI84LMtMp90/WCE0vx0yVWcP+rZMVebpIwvumRd326nx+8Gj/p1EDXS2/w8cH1XPPOnFUFW2fBMFSEJimWIzQat6AnkXCGwRY6e47qT/PGUBAI3/QiwQggCv1TO66IGSnTmavfznV9ayDWqoEzedyw2EE4v+nLrX6iNJcmhwS9NyvdoW9fAzYW+0KJToocJAuTQtge6lgjQs9U9F7/mXdQBRjDRJbXVvh85L8aE7WWyBE2PBwpWm/VF3UC7sDQF4Ycsf+0VPiVv6BfDitqPoPmhjiqc3AkxMVkFW5MQ6Fd7rEab29L+whyLEKBmZc6jTFyaG3P0pAipwfYbnoqAQZCjPr8c4JYoIIiH/+1ZPxwfAbzVA92qJN03utx8jM2Pq
 M833ncM/
 yny8eNWPJXkKkAhWJCqvIHMQPTSle5CXWbsZ4PaLbfv0BVS+RCZm+Z3nsOFtm1Sg12ZkX00tFrYvxrjP5Vh/b8JAA3tCUZpSITlgfT2/TWV24ZkY3CLhCf6ZG/IHPNYVvU25kLT6UrzcF8jLp4WZCAC1jSspuCkBSP8u4bALUZ2LNGdZXk+BmT6JOrSuo9BebmOVJdpfrpIQtnr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7ba5daade5ab61776382020b708b1ef75c9af1ea  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 786m

configs tested: 98
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260813    gcc-13.4.0
arc                  randconfig-002-20260813    gcc-8.5.0
arm                  randconfig-001-20260813    gcc-8.5.0
arm                  randconfig-002-20260813    clang-19
arm                  randconfig-003-20260813    gcc-8.5.0
arm                  randconfig-004-20260813    gcc-10.5.0
arm64                randconfig-001-20260813    clang-24
arm64                randconfig-002-20260813    gcc-8.5.0
arm64                randconfig-003-20260813    gcc-9.5.0
arm64                randconfig-004-20260813    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260813    gcc-16.1.0
csky                 randconfig-002-20260813    gcc-16.1.0
hexagon              randconfig-001-20260813    clang-24
hexagon              randconfig-002-20260813    clang-17
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260813    gcc-14
i386       buildonly-randconfig-002-20260813    clang-22
i386       buildonly-randconfig-003-20260813    gcc-14
i386       buildonly-randconfig-004-20260813    gcc-14
i386       buildonly-randconfig-005-20260813    clang-22
i386       buildonly-randconfig-006-20260813    gcc-12
i386                 randconfig-001-20260813    gcc-14
i386                 randconfig-002-20260813    clang-22
i386                 randconfig-003-20260813    clang-22
i386                 randconfig-004-20260813    clang-22
i386                 randconfig-005-20260813    gcc-14
i386                 randconfig-006-20260813    clang-22
i386                 randconfig-007-20260813    clang-22
i386                 randconfig-011-20260813    clang-22
i386                 randconfig-012-20260813    clang-22
i386                 randconfig-013-20260813    clang-22
i386                 randconfig-014-20260813    clang-22
i386                 randconfig-015-20260813    clang-22
i386                 randconfig-016-20260813    clang-22
i386                 randconfig-017-20260813    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260813    gcc-16.1.0
loongarch            randconfig-002-20260813    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260813    gcc-11.5.0
nios2                randconfig-002-20260813    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260813    gcc-12.5.0
parisc               randconfig-002-20260813    gcc-10.5.0
powerpc                      holly_defconfig    clang-24
powerpc              randconfig-001-20260813    gcc-8.5.0
powerpc              randconfig-002-20260813    gcc-13.4.0
powerpc64            randconfig-001-20260813    gcc-10.5.0
powerpc64            randconfig-002-20260813    gcc-11.5.0
riscv                randconfig-001-20260813    clang-24
riscv                randconfig-002-20260813    gcc-15.2.0
s390                 randconfig-001-20260813    gcc-8.5.0
s390                 randconfig-002-20260813    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260813    gcc-11.5.0
sh                   randconfig-002-20260813    gcc-9.5.0
sparc                randconfig-001-20260813    gcc-14.3.0
sparc                randconfig-002-20260813    gcc-8.5.0
sparc64              randconfig-001-20260813    clang-24
sparc64              randconfig-002-20260813    clang-20
um                   randconfig-001-20260813    gcc-14
um                   randconfig-002-20260813    gcc-14
x86_64     buildonly-randconfig-001-20260813    gcc-14
x86_64     buildonly-randconfig-002-20260813    clang-22
x86_64     buildonly-randconfig-003-20260813    gcc-14
x86_64     buildonly-randconfig-004-20260813    gcc-14
x86_64     buildonly-randconfig-005-20260813    gcc-14
x86_64     buildonly-randconfig-006-20260813    clang-22
x86_64               randconfig-001-20260813    gcc-14
x86_64               randconfig-002-20260813    clang-22
x86_64               randconfig-003-20260813    clang-22
x86_64               randconfig-004-20260813    clang-22
x86_64               randconfig-005-20260813    gcc-13
x86_64               randconfig-006-20260813    clang-22
x86_64               randconfig-011-20260813    clang-22
x86_64               randconfig-012-20260813    gcc-14
x86_64               randconfig-013-20260813    clang-22
x86_64               randconfig-014-20260813    clang-22
x86_64               randconfig-015-20260813    gcc-14
x86_64               randconfig-016-20260813    clang-22
x86_64               randconfig-071-20260813    gcc-14
x86_64               randconfig-072-20260813    gcc-14
x86_64               randconfig-073-20260813    gcc-14
x86_64               randconfig-074-20260813    gcc-14
x86_64               randconfig-075-20260813    gcc-14
x86_64               randconfig-076-20260813    clang-22
xtensa               randconfig-001-20260813    gcc-14.3.0
xtensa               randconfig-002-20260813    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

