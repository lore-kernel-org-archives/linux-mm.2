Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EBECCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5DF8E00DF; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D628E00B2; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9748E00DF; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0688E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF47F4A1DA
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:40 +0000 (UTC)
X-FDA: 84052133760.19.008D3D2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id F289910000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xyu3s2aB;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761765998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFBxXamqegeZuPH4GTzer8UcN5UYf9wwvq0gPZaGL04=;
	b=i7AwrGFBH3FZ55VnQV23rAHEpFYascwvNXOhn9g7jWs3Ga/zSGzSerLDGk0Le6PURIbjpJ
	+4q6GvXcFihBEkMpwDnH5cqTKctKeQxEb1pEI6bmdgdhDk895Gh1WDFp4YY024pS+jc0D+
	++0+nyKjDJpmqGRsK5282PoX84EiE7U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xyu3s2aB;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761765998; a=rsa-sha256;
	cv=none;
	b=fyv1FGk0yChwhtZwSBUPR5cG6DmnfFlIR2HJy82N8nXucXm+PjqKQhCRW3nPZbb2k/kCPE
	B1CHAeHEGygvw15WYgZ/9WosWI+abL1a17SrO4nxKTlwg90dGQdvOhxtnltQmrxz7dfrCI
	XaZsQgYZZ8lcOHCdVPKAGwAn3b2Wuac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761765998; x=1793301998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uy+drdtVdosduK/AJC4iAB2kc+vSCfEplarqfnqelgI=;
  b=Xyu3s2aBOAqiPOTZy7V2Ikp31gTyiImHr+JxdIpopI5rAAzj6V+PbPxp
   IXfQ8vA+xiZ2UxLX+sFx/yxZ1bg9tFMzkTNLBGURW39QfY98ZmXrurNch
   bdOiaoRVMjc8ejnnr8A666jo6681JFNaROfa0sgVXwwRHIZ3QyHTCvGwD
   pCJQ6zICmKwa+isXNnGKVxfdrEhZoqA9AMFItDmaigazIlajsFxCALsfA
   BmJF6Je5pZv0OqJBjwMPsGiwxj54Z6fS7XvH294+nq+ugj1C7UHBHyKls
   B7UgR+7fDuA+XuCZrphR/karU93RSO0/bObDKJW7Aip2UeR5z/LK/DEH0
   Q==;
X-CSE-ConnectionGUID: 1qymaLNDTxiNN2z1jaBFwA==
X-CSE-MsgGUID: Vosm+nlmTFOJtS3sAPIT7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="67550385"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="67550385"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:26:36 -0700
X-CSE-ConnectionGUID: Jg+onkHIRu2k5UjUCoLZ4Q==
X-CSE-MsgGUID: CblukQ1NQKq4m7sq0hXFtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184998754"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 29 Oct 2025 12:26:32 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEBoT-000L5w-2l;
	Wed, 29 Oct 2025 19:26:29 +0000
Date: Thu, 30 Oct 2025 03:25:47 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
Message-ID: <202510300338.GvcdaiCz-lkp@intel.com>
References: <20251029-swap-table-p2-v1-12-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-12-3d43f3b6ec32@tencent.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F289910000D
X-Stat-Signature: jyxppgpb7yeoep8hyeycrr1dzyi4o87t
X-Rspam-User: 
X-HE-Tag: 1761765997-651765
X-HE-Meta: U2FsdGVkX1/Hr8WDOyIrlkJ9mkCGc4Yd/mZnSZ8SEmFS53G8ZEwJ2CHvASjUE4X++5nVYDWAl4DuaOdGRFrsEkRrwfN1xLO73jyHqLQJF10N7pBV7mP54KsyQ9fKFKRXV8dgJi8KSi66+aU6wnDLiiBlLGhixDz5EXvgZXBpAbwcloMUoFDLenjk4YRspFPPeo//rnLP2eHh4k8MVhMUF3lcBMjjxFS2mFpUbtaJd+FS/JxiaVp04Z+LUUEtyEQRKdMlbsOfr1FsPrMc6QrCZ1reSLFRY0xfajGzaHZGzm4E8wk7hS+5upy8sQn3tKmZ+3KZR3K0HEvI3ADvLhh3XX/0x2UUQBdyIISaitZn3IczdsINcX7VPVBYb1EW1LcYp4L4gdUevbtLBFSrmCkLGBzVUb/EllqaZveQelLTRIZDy03YUVTN3vp1NrXer7OxGCwdGeDwiRabNjqB73LNVwfGX64iILi32ACo0ExJD1zcJUBFhvQGBZMgZOSD/cRg6lgAEah6nRFdOLE8T2+hPK8JG9OH/fFPmom+AFqC0AD3qP9Q3KacKEsUmT3uwzANBih4cl2oLBtB/2pVuU9XPOJM5E35a2CVu7l6+MS0lugVh7hwB948pDvtYgEPC+KI2iLFAKGZ4VqiuXrRsdNoRKIKLCW4lBu3Q5LakyxR+u/bw5K0KGIJ01G5ZZFDqBxxf5p7dKoVaKIKmQ5My2K2pwnonCQm4TKbA82t1cpJUn+/1h8aGp61EbWAuCCFt4Cq7HQ3feTxZWqKQWA7W83+NHE4t+8KYYyALFCWc48DHkIUrrGMGlos44+3VAXjbTb6wV7Fi2eBwuRKi84+HD5ATC3dXVG8AWUxoHA8dxIGW945p+cyh3NeOR1x6OrX0nON3vTKVr7S5r0r/0wBPPxVuokVFShEaOoh6YDSXLNw8ndUJxIIkSCbPfaD2CwPCfy2k1Iu29JLmPljJh1BpXl
 jBEISTfP
 4NksnGNSAO+11tM2n6njNQaxfw6xgVTe35YVT14jRrJisdr3+6qBZMTJ/lGGsQzKyYTsaNLULfgw40RmJUHATrfA033UGoqnpNI+EkmUHQVAOwcLUtBDLoLSGMOTep9/R9u5zGBk9xuG3D/jXbHlB6u2vz1mqth56I+iYvI8hKWL1ac2YwNX0w9LE89ay53V+WicoaVxuqQassweYaneofuduZHepMFnm1jTblAVKv0pRU46dfzB3EYmHu9X+pRjtp7ecmbFR+HCuw3BWkXi5g87AMfpoD41Fgv8Kw9W2ujwJxOe6+aNyFj3wimYEbkcR+yhnhZRAYO67ZjmaHyfLMc0OJ2+ghPggQphO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f30d294530d939fa4b77d61bc60f25c4284841fa]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251030-000506
base:   f30d294530d939fa4b77d61bc60f25c4284841fa
patch link:    https://lore.kernel.org/r/20251029-swap-table-p2-v1-12-3d43f3b6ec32%40tencent.com
patch subject: [PATCH 12/19] mm, swap: use swap cache as the swap in synchronize layer
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251030/202510300338.GvcdaiCz-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d1c086e82af239b245fe8d7832f2753436634990)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251030/202510300338.GvcdaiCz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510300338.GvcdaiCz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/filemap.c:66:
>> mm/swap.h:428:1: warning: non-void function does not return a value [-Wreturn-type]
     428 | }
         | ^
   1 warning generated.
--
   In file included from mm/gup.c:29:
>> mm/swap.h:428:1: warning: non-void function does not return a value [-Wreturn-type]
     428 | }
         | ^
   mm/gup.c:74:29: warning: unused function 'try_get_folio' [-Wunused-function]
      74 | static inline struct folio *try_get_folio(struct page *page, int refs)
         |                             ^~~~~~~~~~~~~
   2 warnings generated.


vim +428 mm/swap.h

014bb1de4fc17d5 NeilBrown   2022-05-09  424  
2eaa2d7ed6e0caa Kairui Song 2025-10-29  425  static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
2eaa2d7ed6e0caa Kairui Song 2025-10-29  426  				       void **shadow, bool alloc)
014bb1de4fc17d5 NeilBrown   2022-05-09  427  {
014bb1de4fc17d5 NeilBrown   2022-05-09 @428  }
014bb1de4fc17d5 NeilBrown   2022-05-09  429  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

