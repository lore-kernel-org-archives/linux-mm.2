Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D227ECCD187
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 21:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094A98E000F; Fri, 10 Oct 2025 17:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CBF8E0002; Fri, 10 Oct 2025 17:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB4F8E000F; Fri, 10 Oct 2025 17:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEC938E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:18:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7712645ADA
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:18:38 +0000 (UTC)
X-FDA: 83983468716.28.AE5C359
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5098320014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:18:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dN3MEaMn;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760131116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhsIn855p1oZCRhdBdJaCy1sJIcZ6/9DADcO2j8TyyY=;
	b=hNggQs0EirGuML1U6emMDpF+X4EPwHcjS24084q0b6yWRItaPx6tzJBCuiYgvC9os3lOiM
	NFTutHUglWRWsDItpflWuQ3o1oWEvoNyrPiOYXpZ2xIEOIxechhMIpqQO5wjFJTZqs2FkH
	R15ojcuVieZQQUbNoj/JyXW/5Qlpa6w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dN3MEaMn;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760131116; a=rsa-sha256;
	cv=none;
	b=NICwbGPxYRe4a/hCR88FrnhB79GE1Db8Yi477N8stc7CPq2csZdNkdBJjG8rHnGpIEsEqI
	yqW5cwyYTu5oqE3Ttpg94IiukbcPZKt/ZJXbdQPrBvdDo+ctoKIqIeVBXm79G/5/maeiKM
	cZCk3zkVJW0YSjRjyTcrwt9cr/hNAHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760131115; x=1791667115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GN7rcJAiHiN13Nol7hN0X++FKuoiO/51+O8PBd+pOZc=;
  b=dN3MEaMnW8LhcnjPqXT1nAeqsH4+8mA9+qdzM9NA8KsVwMk/yhanPo/4
   43bXRgd7XQG6d3Fjs6Ho4LtVRsSfWC6m5Hrepb3HdMSA+7vSxZrRvKWoj
   hSdPO8tayfMw4vT15BBbU2UgpC8bml9aYFiCUAFICYTwJ/SaxJFw+LcaE
   FSeg1rI2hzA6kqs9AUKuKgZIugcEUR6vZouf/XoxS6uz4UadUnrbEkOKb
   boA2+vM9bMG7U6xT42iW/Bfac8/5+vydfzD2hxkqoPlIYOplpUMto+d3y
   ySjM9MKwfBhrzpwJf/7hq+DvTvCzEasWtcTuJO/9+hVGcU/iOusEN3Sod
   w==;
X-CSE-ConnectionGUID: 698Vp2t6T8SYX9evzCPvVg==
X-CSE-MsgGUID: OzIhhTH/RXelm5/cG27OaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62386928"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62386928"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 14:18:34 -0700
X-CSE-ConnectionGUID: JObruKedS+20xN/RXkZcDQ==
X-CSE-MsgGUID: UCTRP3WUQ8esTkwdSkvYUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="180653183"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 10 Oct 2025 14:18:26 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7KVM-0003B9-13;
	Fri, 10 Oct 2025 21:18:24 +0000
Date: Sat, 11 Oct 2025 05:17:56 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org,
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk,
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org,
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com,
	robin.murphy@arm.com, hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: implement cleancache
Message-ID: <202510110501.92Srmvgx-lkp@intel.com>
References: <20251010011951.2136980-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010011951.2136980-2-surenb@google.com>
X-Rspamd-Queue-Id: 5098320014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yrrr1sp7g6e6pzocekjq6rdbanfd87is
X-HE-Tag: 1760131115-58634
X-HE-Meta: U2FsdGVkX1/9YjEoLZTDUKXnwWEGMCJgbEeAIZ21RqcrNCH5bLMKSXGF07mlZOcYf5xpWwAW5z5+Skvdhg04bodHTceKiWPFKCPNkrwWVmSDZdIWIdGJ83s8i7gYRNEzeqT1QF6pVjdZSBTHpBBLi2lLHC3TYmwIdDbBuP64xCr3rJLJUhZqNcvFUp98/P08kmkNdc96tOWFzJtLGshD8TaxgeIl1JODWvv9c3eriI7MpH9G4fWPDwdvIhniglEDKCRSP7aCo9hgkwbDAZTm5dUgaYL7NiOjddUmJJsl42zOMJK4LMaSEMOCVtzrQXa/Fr/ZgCRRDj7dCigSzMWRRu+78Kz2/h2LD9E+dH2pRP4SR5WU+nEq0IvNY3Opr2GkyTWKhfi9hP37MLfHPhZDRy5OHC0btkS0tnijRnmC9hx7tSl7m4kxnWcmzGNPIfooInL8vrigTN78g9vk3JLsFoVE9A3a6Hz65diSJiqFnTlmLLBvcIzNonbXpuG3Wo9Epik55oKV+sgtBiz/z1toBz1Fwd7Eumvi4EpSIjpWfwQEi8lVknKPl77p2/9Uv2L3PrtGqdgz5dA0PJL+MnBesqJAbNmBI6kINYAIf96St7Y31pYPwlz4XXVgemV4XTIiqXKWTybL06wUVlpetESAPVYwDCArFj71r3qlkwwKMwOgNGvztny+7pWVw4wOr1GNrGXOrg8rCL24Q3/4+roIPi+2RJb0VZLmlHVqh03nXs3/NVphyXK8f8qoqFctAOVFCEK6uXwg6eAbaPWK6XL0g4kND7NRaYNkSHvE1GqoGb/tTHi571YajBPy9ATDX2aqUBqLKbeSDXZIWYTIOq9ybJKc894iqcJxFbAZY0rRkDazKnEWrMt3fBI3Ncl6FeBPy1EaBgOoU2AbRJdbp3jS0um7zuZByZ2IpY1nofdI0EvB4ds00NEiTUWYu+DFUaNN6E+AVCKdR1YNk387+J7
 /VL2iswz
 NqoLO+Le0D2G9MCB4q0E2WddI+5E0UDC74A42GQ8bpXOo2sZVUQblXvbbHd/P9t5ltaKDlxkvSwpox0lj5qAAHqf/0WoRVIG+eRFOiwpgustdQINNeNE/Kppfu2c4hXYmA2n0D9xmBuZoUGAhesVHrCOfQyBojpHSVRikaNVnOBiVKX5BxlUBpO4L1B1nxUhFHp2k9P8H8fQcOtOAK2S/UAvMdd5pFOs8BlsxaY8txVqbySUmBAs2GHpZPorRhgZa7MONsMPKDTc5pfHUS5Nsb5/xuYkOqLgmNAbHSLPqvPR/HA1BznCPhnrh3j3Mq+9qmbu+BsTHnQNHSKfFBAWgWkwEn72d7nKqI+J5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build errors:

[auto build test ERROR on 70478cb9da6fc4e7b987219173ba1681d5f7dd3d]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/mm-implement-cleancache/20251010-134501
base:   70478cb9da6fc4e7b987219173ba1681d5f7dd3d
patch link:    https://lore.kernel.org/r/20251010011951.2136980-2-surenb%40google.com
patch subject: [PATCH 1/8] mm: implement cleancache
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20251011/202510110501.92Srmvgx-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110501.92Srmvgx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110501.92Srmvgx-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/cleancache.c:119:13: error: casting from randomized structure pointer type 'struct address_space *' to 'struct cleancache_inode *'
     119 |         *ccinode = (struct cleancache_inode *)folio->mapping;
         |                    ^
   1 error generated.


vim +119 mm/cleancache.c

   113	
   114	static void folio_attachment(struct folio *folio, struct cleancache_inode **ccinode,
   115				     unsigned long *offset)
   116	{
   117		lockdep_assert_held(&(folio_pool(folio)->lock));
   118	
 > 119		*ccinode = (struct cleancache_inode *)folio->mapping;
   120		*offset = folio->index;
   121	}
   122	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

