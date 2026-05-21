Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA2BCD5BB0
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C996B00A0; Thu, 21 May 2026 13:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6146B00A4; Thu, 21 May 2026 13:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADFE6B00A5; Thu, 21 May 2026 13:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05DFA6B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:47:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A9A714067A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:47:17 +0000 (UTC)
X-FDA: 84792158514.08.D08DE9B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BE8512000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:47:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hbGCxMAR;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZJ7ZpMWsOA/V2DS03sDmpEgRDT4qyYdCb3a4oTKfAE=;
	b=XcR25Qt4tCB4AsLMFKIoJXvMXL+GpFYwADbAGbqaHEFgLzmjYv2txaOJNJWgrIefsaGop9
	8OBswrIoZ95/79FHUosy+QdEjLICEd3trSqc4B9a+s0a1G6wgwZzoyxQRehlROkXIqo3tD
	tQbogWQI4KyWYh7EAJ2rMFA67rp98IQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hbGCxMAR;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385635; a=rsa-sha256;
	cv=none;
	b=KWuKpZ6tCbe47tQqMCtHqq3TsHiaJNw1sy/eLMumS7Cv4fsRxwaZ73a9pWDnK6zagWeEG4
	ReZuuKz2sIXNRH04NL+3a/oYiUWNAbjGeI37Sr2jT3t4sT0BBa9PTGqdr5/lXh60STk74l
	CgGQbHUn9311bBByY5UmDdcSdGP98m0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779385636; x=1810921636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SG/bi0uKIZA2q0jyofyNGZhvUNh6QNcGl1aw2pgczl4=;
  b=hbGCxMARBRW1z4vJTSJKr9ZnbXu7ijay5GULY4OessEogwJmh2dGvb8E
   oEKg/VY/+aGiZju9f3Ziful3nzmZ3nKGkGHS0n44wzNJ6CKz8ajs2JkMA
   0gMdi/T96hozvNfxUiDZC28AW+csGvRRXidVHaPd5WwJz6qegJ8p6mnqO
   vBJlHKTIUbU5AcEidVby+nP1JRm18Icieczt/u7njI4JRs2w7Yamqxo5I
   8B6w3/7wY6Pg/rvC8w93GgXvGPWcAf6rnA0IwNOaDl0stLextTrU7UXeJ
   3T7AoQYpz4dxmIHPUPejPbXw1hrl6WQ7uRoyJ02rGN6G/vQbkTGyRodg6
   A==;
X-CSE-ConnectionGUID: jKCcNcE1RJufSNrs4eQTWw==
X-CSE-MsgGUID: MvvWfo/dSmS4Jrpf69xAwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="91704586"
X-IronPort-AV: E=Sophos;i="6.24,160,1774335600"; 
   d="scan'208";a="91704586"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 10:47:14 -0700
X-CSE-ConnectionGUID: BUfBpWnQQDKT7FMYHEQecQ==
X-CSE-MsgGUID: CCLjpKE9Ri6/exGrWVbINQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,160,1774335600"; 
   d="scan'208";a="270951214"
Received: from lkp-server01.sh.intel.com (HELO fdb68b0ce653) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 21 May 2026 10:47:10 -0700
Received: from kbuild by fdb68b0ce653 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wQ7UB-000000000vB-129u;
	Thu, 21 May 2026 17:47:07 +0000
Date: Fri, 22 May 2026 01:46:23 +0800
From: kernel test robot <lkp@intel.com>
To: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kees Cook <kees@kernel.org>, Harry Yoo <harry@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm/util: Use kmalloc buckets for kmemdup_nul()
Message-ID: <202605220158.VO5WnXl7-lkp@intel.com>
References: <20260521124026.work.036-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521124026.work.036-kees@kernel.org>
X-Stat-Signature: hn3g87upwhms8qf8adk5wdpz4knnjyej
X-Rspamd-Queue-Id: 5BE8512000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779385635-118231
X-HE-Meta: U2FsdGVkX1+A+i3qVBp0JyAPip64gaWEVJU/IERvAejb4W7SItYxiWnOahYF9vjXBJfm5J8B0mxk5msn/YYuik/Lc7Z+8lVqkla2gk1dTF4JsM8gEGAHAnP9VLYslPCeouR405CbvOaXc6IQHTBJqcRehsjwGbj72hS+OZh2iaylWeSrLOkuovXoQib+7jCFNz1gq1DoYi1UoCV1yaqWka4W3r59ZBmulf9ZGhcrgeyO8Aa7BqxM5gsWPgXCtfoAmYSNRKbq7b3OvPZd2UJhGlzLy3YbJXBgA81x94mDX54Fo/NhwH7ZT5ru9757EsQEFbmdd7oJZAR9cENSOWr+Xji+DTa/0FCULXAqexvgytX3LXdiJ1boDEedbXk3rv0SsCsKlT+BlE2mHWbEoxUsB5RJrgViRgsw4CphYbGNiEAngb5e2gSGImIQwyBfuLrZoqr7yaqHXIJq300rcEaJ91eu9Z6Girp/aCh4hP6ryjUA74ivIATX+dgmVjk+drpqjCvGzjUDOx5YVBc9uWXZjtCJWWOzn+/mjsHPSOzMZNeHzFnx0/pRTnJEQqDDCOrusHYBN8VQXwuy8zkqvNPhJX2ksLY7H9pXMtlyfZ/X0aI6eteID0ONAma5NBtwkIRQgDLRNY0rLltv5qoptndqztoNQ4QDOO6ptpBHb3NoIgWU7ut/m1LhG9bKDOPCmIHREn6Jkd9IMSTdAdraw8gyuUCYI/Zf6curObrsPL5R/sVqZkCWYZ2q6/ZmXEE8s/VJVWPqBo+0fv1/f9SDrs/8A0HnMPowlFUA9sGIsZDEdc4A/FawkMs4WDIxK9ADaASKCy7gnlHPjD4eDPbcKWGdXH3bPXkTQg4to6ZWWqnXqqy8K08oObz/1Ev4+qfjEOwLaGNJON9Feev1k1TK8zFgMwdrOBVExNi3YpR54cUop+elzdUxF0vqf60G5gaTPWyILee/iYPZ5rX96WDTaeA
 LPxaUIkd
 GOoNTonrrPU2EMvmO0dTdAMYgHQ3TXlgdGsmDk4DWwFWrhhuw9j0CQnvGHiqbDDEkFRhOwn24FTc9/JNN4sstmY2xrtlxrTkfxOCIos/Bh62+j1fWWsFtyxqM+wtpJXM4KH0KjKXXSqrChpBW9Z+7UCTv/XR2aRaeKXOri5zwkY4nzzn/Qiul/aOUuDgYjnK7/FARD2wnmnM68H7ZRqnxf93VGEogc2aL4e+SpZgnhnfnfoUZMOG31pywQ5Q1Y4MnKoJnqP68Xx0P8uKfp/JMzePBI56sWeBcM/JMs3toUxmsjLdj6wG6B8h579IcoLQGTR62WZFgw4r1lH5nn+I2W2MRzIZwQS2B4x/NR63oDb1MVm8l7pnptlOjrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kees,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Kees-Cook/mm-util-Use-kmalloc-buckets-for-kmemdup_nul/20260521-204404
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260521124026.work.036-kees%40kernel.org
patch subject: [PATCH] mm/util: Use kmalloc buckets for kmemdup_nul()
config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20260522/202605220158.VO5WnXl7-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260522/202605220158.VO5WnXl7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605220158.VO5WnXl7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/util.c:37:22: warning: variable 'user_buckets' set but not used [-Wunused-but-set-global]
      37 | static kmem_buckets *user_buckets __ro_after_init;
         |                      ^
>> mm/util.c:38:22: warning: variable 'nul_buckets' set but not used [-Wunused-but-set-global]
      38 | static kmem_buckets *nul_buckets __ro_after_init;
         |                      ^
   2 warnings generated.


vim +/nul_buckets +38 mm/util.c

    36	
  > 37	static kmem_buckets *user_buckets __ro_after_init;
  > 38	static kmem_buckets *nul_buckets __ro_after_init;
    39	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

