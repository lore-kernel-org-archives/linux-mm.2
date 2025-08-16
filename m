Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C7FCA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9AD8E022D; Fri, 15 Aug 2025 20:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80198E0008; Fri, 15 Aug 2025 20:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC8F8E022D; Fri, 15 Aug 2025 20:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9BC8E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:57:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 511FF1DC6E7
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:57:50 +0000 (UTC)
X-FDA: 83780808300.25.6415257
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F70A20002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:57:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i6UxfmZ3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755305868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYu/uup21rCfZCYgTTuBgurt1yh1m35e9jlDv9CmMO0=;
	b=Rs2Nv3PKfXG0C7NBWzXpYFabV1X2gzaguTHU91O9xqBNyKx1RTG8lrJb2WpmBl1lLHjUaf
	PzznmdPi+XWeutRKtBPlzyGzFlyy24V1DKzoJiCRAvphotih9qpFQJQXDeUcfnasW++RDU
	vXlJGPUlBLtSt5wt8vQCC7Ss8Zs/UaQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i6UxfmZ3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755305868; a=rsa-sha256;
	cv=none;
	b=wNjq+WJ0zLiE/87MRJSQs0/8gGwzyF/+Yqj54kzkFnSE4KBtfVCpteBQkg1zCv58v0OnJ9
	zPl2E8AYEMMknGAzEvLEpNjEZO8SGbINZG2mZJQXITZjM85fq+54AG+73fIGIyZZPJ8pnl
	S8TklSC7SsYYgilZf9OvNVYzdy6WgIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755305867; x=1786841867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4yRdPc9V0nuMMCwNQ2HPQxK9Z42aO6f3cMEDFSNO1+Q=;
  b=i6UxfmZ3ogqFSFPUOTADbTjyoZzY9ISKm/+JQn8RXW6UGyoX0N6DmReX
   gzbpIByaQOtQzGqjoJHFB2pJF7+6rYxOGuIempoNl/goMtbqh/Mj7BL35
   F3BK75kyp5fO1MbUUR9CtfIh1zegw/Uxrww6WNXo/BfsH2zh8/CokQ5BM
   TwzzaKNpkcsjDIJ4NZMUBB9PIXeaoLUds11b02mMa/iXq86hDP8dH7rwn
   AgbxQHcYWXmnLScFTKBOgn7NTJETU1cTKNibqUmiBc+wTFg0GDte5i97M
   S5hGlLK0IMss2cIB29wc9NhBMPT36Ti9yddoO83ASRNAISIJup6yDzjrs
   Q==;
X-CSE-ConnectionGUID: 1j1PGIuiQHut0R3bgu6IYA==
X-CSE-MsgGUID: HSFF+NX6Q5mziyHXCN2GnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="57536991"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57536991"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 17:57:45 -0700
X-CSE-ConnectionGUID: ZNfZxbMcR1S4D5xE0QuGTg==
X-CSE-MsgGUID: 0OScScgjQIa7s+TsDBG+WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="197985617"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 15 Aug 2025 17:57:43 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1un5Er-000CSo-1V;
	Sat, 16 Aug 2025 00:57:41 +0000
Date: Sat, 16 Aug 2025 08:57:27 +0800
From: kernel test robot <lkp@intel.com>
To: Huacai Chen <chenhuacai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Message-ID: <202508160823.9dRNF1Rc-lkp@intel.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815090539.1578484-1-chenhuacai@loongson.cn>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F70A20002
X-Stat-Signature: 3szqxbyxqazs4ftonikrjik39um9zxni
X-Rspam-User: 
X-HE-Tag: 1755305866-594452
X-HE-Meta: U2FsdGVkX1+Jtygr9NfjuuAgBayB03T1lluiWsiBoJSecJHHUkzZ+oC96/68IpNf0a4gghCJAJgA4+Av1u5u0y0KA5w1bCNimXLB4mlO9Tr4ma8Mw4afscn8S+ca2EFFfmITtloL7NSgCqZBGouWn/XYTP2LZHwwojniZHeqkltNQQK/ZgNJsTQdrjLWLt1duoxxclqdyU6Ne1At57NNnYUkn0nutfblpvp7Hy9KM21GHPZzdP2Hkr2J0DacDCszosrl3ejM5RS1Ln6FOV/mOPiJH8/x0wuxIjQU0ER6SH1/3fwkdXtlODCou1DIe0cng5jY5HCrRl786HBV/GS2leoSxkxYLnJ7cRmUP/ezc7/DruSX75sd62ycy+T2fWobnUE8PS7sFr/zX7E+91waPSyrgvyGB6y1MO4x/e68uJPwTjF+vvw8ewNkDADhCyQaQSG+GoccbTiusTEmLl3N2ny6YIgP3WbZtky4xrorqTlkploW30s5QYpFF7/grV42FOOPv/t3JgfvFsX6+/2UmBYo5uccNoZW1UkrW98kHjFqpEpWpI/BV/fPM1VyqdIHgwz1I5axsJ6UR7wZL30vJP4Bd9IgVLosMfXGIU9QkcIsWIG4egiktViolR5Jfi90hPeTPCOhsCP1/SdZjkazcLLGyiJjF3OFErA96/IrvwMWLKARuclOHgadVhwMWJgN75NKgoeIqwKESHdeHzWQsTPvEeGciCOtImbOQpIpKg3Twrml0ezctJT7r986QBxISoUzEn5wI2EYzF3L0++dtD+zx7YhuDIHx29RdRR9Agh7TtRI5RUcY2ppFzm1ydFcX9T3815KnnA72H2+DKQN2LNrfkxGmK9p/Fa6Tths0yWSG6xhabN/oN/xD8LL5zfTLXQafoc9k8UoVj9BkIjrsWqbQQ8oI6u064ZSxRBaBpYTPSbUZAdFttu4PY6PKLwiDrcY4gD4Kj/rpLwnrOe
 WZUZf8qL
 ovhY7ZSkVMr+uxBmokili30+KcwXJDxhwdAy3RbCVh867pfqcXceq57VtVhW8+Y2X0Xo2zmnhknw/MFwOM3vBtXX+WPJcRlHSCiX5oYmksdbfHeJCdSnOfe/UNEgmS5zDRC+nDfzQXSef54nhjzOrtzW9lQ6HKwGS3kE4KqIvnh5utnQavHgsyaYWYuojq3zkGBH9pCM9JOFi6dCSUIvOKor30u/0E1IQJ8Gs6Bu0EXd5WRaJ2XlA6NN6ATnIoDFQm/633az1F6+y1aAz1sLfkoPH/H76Wyn4KHxKl0fmq105/+fvgn1nYMk7obKWaaCJypMuwmwZAeH5QtQRPaqt+3D2mmWQJBux/pxZNaD6Kl4dB65haoiiTCCJEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Huacai-Chen/mm-migrate-Fix-NULL-movable_ops-if-CONFIG_ZSMALLOC-m/20250815-170745
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250815090539.1578484-1-chenhuacai%40loongson.cn
patch subject: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
config: sparc-randconfig-001-20250816 (https://download.01.org/0day-ci/archive/20250816/202508160823.9dRNF1Rc-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250816/202508160823.9dRNF1Rc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508160823.9dRNF1Rc-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc-linux-ld: mm/zsmalloc.o: in function `zs_init':
>> mm/zsmalloc.c:2250:(.init.text+0x8): undefined reference to `zsmalloc_mops'
>> sparc-linux-ld: mm/zsmalloc.c:2250:(.init.text+0xc): undefined reference to `zsmalloc_mops'


vim +2250 mm/zsmalloc.c

  2246	
  2247	static int __init zs_init(void)
  2248	{
  2249	#ifdef CONFIG_MIGRATION
> 2250		movable_ops[MOVABLE_ZSMALLOC] = &zsmalloc_mops;
  2251	#endif
  2252	#ifdef CONFIG_ZPOOL
  2253		zpool_register_driver(&zs_zpool_driver);
  2254	#endif
  2255		zs_stat_init();
  2256		return 0;
  2257	}
  2258	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

