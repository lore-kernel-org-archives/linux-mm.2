Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22138CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CF48E00AC; Fri, 22 Aug 2025 09:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544CA8E009D; Fri, 22 Aug 2025 09:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A938E00AC; Fri, 22 Aug 2025 09:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34A958E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:46:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC4D1137B52
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:46:37 +0000 (UTC)
X-FDA: 83804518434.20.BE01F09
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FF794000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:46:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AB0RtzGc;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755870396; a=rsa-sha256;
	cv=none;
	b=Qf+i2IfaLQNNkZfbJg48zjdhBJxoWc8AXJbz0gBg9k9S4uQkZ6n1W59kS/80UQc3zFdUMp
	G9rNz4V368hCXtmAfWBfxjam+B0wGrqTVfQnmjOQWTzAnwkx7ezb0GGXybi3vi1xdUoLYu
	ZYr1w3DvAZseXQyFoUs8PJvRobSO5Vw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AB0RtzGc;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755870396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSjeRSXfUslTRJdui5CeULjDMTfj1kFUvAr9GU+6UeQ=;
	b=7Inzl8yccrfjxUt6wK0FqOkXfRxTkHNhPkdzvBISC/+KSEZgs5J7tA95I79INbujWo8w05
	dl+r9SSxIyyV7Zcyl8xnUwxmolPOwlVQjlJqAb1cz2pkQkhW+uWzCyW4PWfmz0i1TN2UJI
	cwSthxbVsG5Obs7QRBXUgomk1eJC1zA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755870395; x=1787406395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J0+pZ+2m0Dv0vL74QouwXOMlr21iON6x4zZIvX0pgZY=;
  b=AB0RtzGclns5GZFBK1jNvoaZKW7DwFU2cIskaZlaExnMEdeeguM1kKXQ
   p4r0OXpNzwFxOr5rYKqty0yylyJpgbw9/EkyAysCYZJ5afFfLsc6rw8T6
   2zXhF3nX6B7htiZbRqDbbJXSD9MzSsXFnnyRcNYDiBS+9RCd4wUuJexcH
   8TIxwcrMxG06ADFr9OFnC6cGAjsUyimQbl96fw0nXb0hI+ec9X48aBqsd
   DY6O2quOwkaYMlMIiMcqgLELOIhabpypVnncWajuEC97rpY97a4wevg/w
   tL0csipK5P7qCuNfGgn56lEmNwKoosKQcY8DlRQJMfmZ2F6GuhZlfn+oQ
   Q==;
X-CSE-ConnectionGUID: A8KsDASiQUq2jjz3EpkfaQ==
X-CSE-MsgGUID: GNmh/eu7QQaemjvXmmto1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58127718"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58127718"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 06:46:33 -0700
X-CSE-ConnectionGUID: ZLmg3LI9Ra+rLL4muaRPrQ==
X-CSE-MsgGUID: DpwzIgtRQ9iTSF6OFHtLtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168614614"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 22 Aug 2025 06:46:30 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upS68-000LLR-27;
	Fri, 22 Aug 2025 13:46:28 +0000
Date: Fri, 22 Aug 2025 21:46:04 +0800
From: kernel test robot <lkp@intel.com>
To: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	willy@infradead.org, mhocko@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v4 1/3] mm/filemap: add AS_KERNEL_FILE
Message-ID: <202508222105.tg88NxnV-lkp@intel.com>
References: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FF794000C
X-Stat-Signature: 51q9rh9j6pk7ay9ayejnyti8h7m5sijr
X-Rspam-User: 
X-HE-Tag: 1755870395-159951
X-HE-Meta: U2FsdGVkX1+/hY88F2xh6M8LqepKt07iGmP1R3FvB4kIYdmMXmIFJzcG+zadVqIZAm4d+JCLkxVdvZUP1E4oVNd0nVyCzqzHkmZgqkyUzoxbN86q4G1wQHRaMtZRBSMM2wEtDMo+Wv73JKT3pas96rh7WU3iPX2zOLCt0J2/ehMS5JIMhG94S+uS7Di31XxHEFSZlbb6Qv8EV8cw0pAZbpPqNuZiA1QQsr6GMsM/GR5/jHB5YD3rLHpSAwVPMEK4CZYh3waLT8h0mKV6YXuupwcZzd1OF9DCc8IHLQ9G8Niw4RqLWRJ/KXVJx/Udraxe0x3DZWrGDgJmQMxBaWxq/aNWTdqtfHK82AhWsrM5hlBoiONUWHo5dCLVkLrAXIO6SMvKmesJTvpSnneBrts8WDNWUm5dv678PXOaZXIbROWJ6cNChYbZgUGiQOqGCqoNTWikbA5MgILdtXxPx5/FpdT6v1Ft2/vNNq8Qeo6eNmdVuocpmI5xLl+9glKiio/bFIV5eNRD35lS5D1Zdq9w+UL7cheZsB/WAXDa7yoB/C0D8nGFmdy9qXyp+2Jwr7OEDxXw6T3EJdu1GwR/rvg2i3nFLnKqfIptZcxpifUKFAwaiSQs3j1blgeKPEvxQrqbZMpWVfHipXyzhYnVOQvbmGLRSqCheOyfYcI9opBDTfATM3ZG5h7nWpe5w9Kuq199dEpRsY3EPnzTFaVHUN/ePiznHXHjCAqIK/vBJuJkcnT2T7aAqzMcpUYEFWi+uPIlc+skEuMvGdrsIrv2xzJHzubrUBjZyXrh4qljCxG+tmCNk2qYqt+8uTPgmucyftqZ7REOjA4r4whe1bQ5gEY+ygqUE+VjHHkrOGclRWvOZ8zIPhbpo7OUwb3e6pKEn83CO+/ozTzFL0DFCENk41jcmjDtFA3AwvTMOmVHWXJntSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on kdave/for-next linus/master v6.17-rc2 next-20250822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/mm-filemap-add-AS_KERNEL_FILE/20250822-055741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris%40bur.io
patch subject: [PATCH v4 1/3] mm/filemap: add AS_KERNEL_FILE
config: x86_64-buildonly-randconfig-006-20250822 (https://download.01.org/0day-ci/archive/20250822/202508222105.tg88NxnV-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250822/202508222105.tg88NxnV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508222105.tg88NxnV-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/filemap.c: In function 'filemap_add_folio':
>> mm/filemap.c:967:40: error: 'root_mem_cgroup' undeclared (first use in this function); did you mean 'parent_mem_cgroup'?
     967 |                 tmp = set_active_memcg(root_mem_cgroup);
         |                                        ^~~~~~~~~~~~~~~
         |                                        parent_mem_cgroup
   mm/filemap.c:967:40: note: each undeclared identifier is reported only once for each function it appears in


vim +967 mm/filemap.c

   957	
   958	int filemap_add_folio(struct address_space *mapping, struct folio *folio,
   959					pgoff_t index, gfp_t gfp)
   960	{
   961		void *shadow = NULL;
   962		int ret;
   963		struct mem_cgroup *tmp;
   964		bool kernel_file = test_bit(AS_KERNEL_FILE, &mapping->flags);
   965	
   966		if (kernel_file)
 > 967			tmp = set_active_memcg(root_mem_cgroup);
   968		ret = mem_cgroup_charge(folio, NULL, gfp);
   969		if (kernel_file)
   970			set_active_memcg(tmp);
   971		if (ret)
   972			return ret;
   973	
   974		__folio_set_locked(folio);
   975		ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
   976		if (unlikely(ret)) {
   977			mem_cgroup_uncharge(folio);
   978			__folio_clear_locked(folio);
   979		} else {
   980			/*
   981			 * The folio might have been evicted from cache only
   982			 * recently, in which case it should be activated like
   983			 * any other repeatedly accessed folio.
   984			 * The exception is folios getting rewritten; evicting other
   985			 * data from the working set, only to cache data that will
   986			 * get overwritten with something else, is a waste of memory.
   987			 */
   988			WARN_ON_ONCE(folio_test_active(folio));
   989			if (!(gfp & __GFP_WRITE) && shadow)
   990				workingset_refault(folio, shadow);
   991			folio_add_lru(folio);
   992		}
   993		return ret;
   994	}
   995	EXPORT_SYMBOL_GPL(filemap_add_folio);
   996	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

