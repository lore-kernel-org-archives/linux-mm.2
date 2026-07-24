Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC02C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CE06B007B; Thu, 23 Jul 2026 23:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D8E6B0088; Thu, 23 Jul 2026 23:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B976B008A; Thu, 23 Jul 2026 23:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B05676B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:24:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A754A0274
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:24:43 +0000 (UTC)
X-FDA: 85022228046.29.75D6818
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id A165C180003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:24:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NUEmSxl2;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784863481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mHmude6UeGkXjBzLk0hXCeTHQhOrGo/+cKGpc7rWg/w=;
	b=KtkfccBeqFIoytOJsQ4MbjtucpGXnTTecVeNtnYc3Li7o4bUYtrwWA0TCOvLuzS3sGhl3W
	/bOoh/Q/Uvau4LrZa8qKn1Efkbq/t1o22adQGqGZR5pKLhgu3D7ZDLBYE3zxqSWyPU6/Cn
	NWcNAPrZDd2YDhCdsS/GS+alMkwtaag=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NUEmSxl2;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784863481;
	b=VfbcepO5wIRAnnRnWZBprMk9JU+OgiaY/lpkkSVMX5hy1E30snu7AOXMV61surbxPhLlgt
	dRTJj7EgJH61idCNmXD6HNjh08lwwsTY+pna+zPKYzqiTw/tBamfHyPLva1e1mIwFy2gDR
	II7UNSNGodVGf6E+WQxNHdFo191N6hM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784863481; x=1816399481;
  h=date:from:to:cc:subject:message-id;
  bh=nPG1Tl1z3G6zT2+DF2QPCPY8DOD4TzJ7w3r7UpfKoGw=;
  b=NUEmSxl2fwhZ4j/u+g3h5LjU8OP3xccx5bAkjkl/uKxEKSNSDCn3ykHg
   AibU5W6Kq9RpThriwDIXwH5jZ5fSw/IKASLPGcFT/+1XKGHUYfIk28WLB
   isSAkpsSaMHy0l3ddqfRbnB8ynQcVgqHXPzbsN4toufSgIfIoN1iTk/lW
   1BU2yIC1sLfQiBt1efXVL5a30xbDGVLOOgL9FUr6mI1F1bvPobjuL5/A4
   zDrN71KvYLcKcJLMDfOpCKATj2E0hcH7cotZKRapX9XOdTQ3KYlTTpKWP
   spuYEM58eN46mHj7qpg9/I8zWs/QT9rzL2L7bvpqkP/d91OgW5047Aiwd
   g==;
X-CSE-ConnectionGUID: 0m9FxTpqRTK/DtAZ+FjmrQ==
X-CSE-MsgGUID: YvsDfUuLS92jUZW/owlPVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85617882"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="85617882"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 20:24:39 -0700
X-CSE-ConnectionGUID: x26MgaD3QyGg+Tc7t3AhAg==
X-CSE-MsgGUID: Kz9qdryFSEmlwIlFcANPKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="254264458"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 23 Jul 2026 20:24:38 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wn6Vs-00000000aSm-0gnV;
	Fri, 24 Jul 2026 03:24:23 +0000
Date: Fri, 24 Jul 2026 11:23:09 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:misc] BUILD SUCCESS
 d7bfd98ba01d2af48cc238d5525201c83fdef251
Message-ID: <202607241151.sNgCwxsd-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A165C180003
X-Stat-Signature: n9iwykah63dwj5cqqscdxdxdn7fqxdrj
X-HE-Tag: 1784863480-256151
X-HE-Meta: U2FsdGVkX1/5qMv71cU7Orm7NnevjyHEkhoPGHygDGLDeuzVjBgNrQnGzlsYToNZouAKeX/JcVhom2FS180AV+PzGvJol7/XmzPj9JgKpRCn3eQTTQSLvhUmgaEOa+1jEvvwEklNuw6WQ4RqsRSjqfQwe1E5B3cTmi1QwOqGjRn3LmVg9qw54HZZ15hQVI7cGWIjp58fHrvfCtWZFz+0GK3zzpDSmk84darO/n2m0/jVngHPtXd4bgvPLz99C6nJYyU6gzo+CB8+l34ga1Gb4jceoQduAAMCyGhLa6s7eO2tRsvu8wXqdtqEiGGUP5Qx3cSSloaRYCAbKSrU1ZzG8qOOQcntXxvVP8yfA/Ci3F71zFgJgoVIBrnqt3rLY4A4JuSKFqujOdcu5e+05TtEFTCYDa18rAhf9814nG8UQh3rmOTXYeI5uhyEUTx7MXUIzpaJyFmMO7Zcl8KCRqL93uEOmPAbSSAwgECVnoYeXoWHymZgzN+7thxxEA1xnPUmGOtVmyVXzC9oAEKBJVCu/A8r7jAtk2bUhgbNLiEtUzlhOsMnMVGkJqUxCFK7tdQe6GLAvBiFBlAEg19EUw0/sMCVHlEXfNRXSaHAmJaPb5MILj7IqyPZLuaDFwdA50gDvJZGJ8aThqm0DsOrkfSEFXX50Oyydg7aDZr7G4YZns9P3CJS1k0W54z6dMDHqCDzzEinv4HCUU22dO5+iG7DR2B0JNiL7HcfvR8wgZtk9xwIEO0Af8pZv+VeCRxDjXwRru/Zz3MB9DgbsUZL3nSrUpA+GOZ8iXxU9pZyzdS521p7TFqgABJNPIO0+HjQs6KYLsPgJuVI2QQM2X2wH4xqGPtl7H9iuho93mDVz8SjiVASOFaiDUdnmqu8abt1Zq4UlScjEHaZf/2VwF5jpVnHfxR3V9YCEtZXjQVAcdPXyzg0mmq5qa/2r9G5G//XmoYpzOaV/xFih8m9QYObI85
 src7s269
 K/bFiWIRODHYtDXpPzrul6E1Qs1G3RQ0+FzvdqK8zyyDq0usaJrETJFIyZGE37P+KDKGlGqba2/fL4RrMyR3l4Cx3IE7adwI2hOiri+4D/dZ+bbURJ+lUfrw7dMtJHZrBC7sIJRhzgHNpcKfzjwSEQx/v9gPd1Zt66s+ujZe2UdHDO4o3GCriaMJQXZvjx4i8KD41iONnA9LZOXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git misc
branch HEAD: d7bfd98ba01d2af48cc238d5525201c83fdef251  mm/mm_init: remove redundant memset in free_area_init()

elapsed time: 1145m

configs tested: 36
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260724    clang-24
hexagon              randconfig-002-20260724    clang-24
i386                            allmodconfig    gcc-14
i386                 randconfig-011-20260724    gcc-14
i386                 randconfig-012-20260724    gcc-14
i386                 randconfig-015-20260724    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260724    gcc-16.1.0
loongarch            randconfig-002-20260724    gcc-16.1.0
m68k                          virt_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260724    gcc-8.5.0
nios2                randconfig-002-20260724    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
riscv                randconfig-002-20260724    gcc-16.1.0
s390                 randconfig-001-20260724    gcc-8.5.0
s390                 randconfig-002-20260724    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260724    gcc-16.1.0
sh                   randconfig-002-20260724    gcc-16.1.0
sparc                randconfig-002-20260724    gcc-15.2.0
x86_64     buildonly-randconfig-001-20260724    clang-22
x86_64     buildonly-randconfig-003-20260724    gcc-14
x86_64     buildonly-randconfig-004-20260724    clang-22
x86_64     buildonly-randconfig-005-20260724    clang-22
x86_64     buildonly-randconfig-006-20260724    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

