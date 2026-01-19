Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1058ACCF2D0
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A08F6B0145; Mon, 19 Jan 2026 04:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DF36B0147; Mon, 19 Jan 2026 04:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5453A6B0148; Mon, 19 Jan 2026 04:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C63A6B0145
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:17:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D95D8C2548
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:17:29 +0000 (UTC)
X-FDA: 84348160218.02.AA06199
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E903140003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:17:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wai4K+J7;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSuKq4vtiYSh+zXJzFy3zaTzhBwfPSV+9FyaCHAA774=;
	b=1Zx36n3ho4sh1657y1A2csCG9hqCGqwQyWqcrJEEC1X/INNlGaVlxUzZb9ZoijAl34/hvJ
	UwVMyuX2w3AItekkJKKMKgMYf8puE1L4oQNDUr/kU7txMiF16j/C+qkkVYsiYA1MdfpteW
	osZPiTVUXXwsz0AV3l2D/As/tZLE9zk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wai4K+J7;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768814247; a=rsa-sha256;
	cv=none;
	b=bfv+i9czMj/qGnUMiOhKVJUaPyKZs1bjv/xEpk9ZggAG9Y5BAXtLDIF4f6HnJstSgKXvgn
	iQP1ZzRKuzDF8l6elIHFvIxb/MGatm+vgUUlxG38flMfChlp2pCT2UEjmXVYCeS5pj8tcG
	lqTGGMwkcI5vMojlCZQ+bwnGI37jUDU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768814247; x=1800350247;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AU9JVoNnfRKsIj4AsW7oSKQlXRJhBnRLc/ccZNkzymE=;
  b=Wai4K+J7dJvf9H+zK+kaEnz7wzh4fDD2n4IIp4/KMGYmD24pXKxWjbVi
   J7hA6mbE36dO+ZD2OOnf1e/bhd3gCZNd796YEAF6j+vS24EU2mDh5koTP
   VWKi5K2FxPc4laRyujTD2pvg5iO9hai/y1fvSnLAsP0+3j/3FY+iRRBzX
   IuYBjvTvzPIY9k3QSJw9Frw/VP38YdKjsZ/GLL38dJ3zZh7zJWPZxGJFN
   IAo0c9ttY7mDtQOcgXbFTdtti4bLY9xxKTTWwrD3zgkTDp9oll1d85e7O
   GaBR+rFPnEHY+pVB2DRugn1tzRm0iCVX6DP//dFcvHnnEFmJPTbF9mAIb
   w==;
X-CSE-ConnectionGUID: PVzcnBvISyKregdowDKy/A==
X-CSE-MsgGUID: PCQYNlX6Q5iPEJlVg/sVUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73881378"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="73881378"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 01:17:25 -0800
X-CSE-ConnectionGUID: hDP+P3CzSqW+srxROFK3Pg==
X-CSE-MsgGUID: sXSNzcZUQDmRSiM+EyGXIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="206249073"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Jan 2026 01:17:20 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhlNu-00000000Ndd-1Vmo;
	Mon, 19 Jan 2026 09:17:18 +0000
Date: Mon, 19 Jan 2026 17:16:38 +0800
From: kernel test robot <lkp@intel.com>
To: Zhiguo Zhou <zhiguo.zhou@intel.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	willy@infradead.org, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org, tianyou.li@intel.com,
	tim.c.chen@linux.intel.com, gang.deng@intel.com,
	Zhiguo Zhou <zhiguo.zhou@intel.com>
Subject: Re: [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate
 critical section
Message-ID: <202601191620.O1a0T02o-lkp@intel.com>
References: <20260119065027.918085-2-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119065027.918085-2-zhiguo.zhou@intel.com>
X-Rspam-User: 
X-Stat-Signature: o6oexizpkui3t9wku59rszm78tf7q3wh
X-Rspamd-Queue-Id: 8E903140003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768814246-465919
X-HE-Meta: U2FsdGVkX197wTp2EIj8SHHyFq+4MuejLmCaKIjZPCCRSvzEtyge4Dv8Sd4PtNcgj03q89/eQ6/zyQP11ZERK8ggpb1RTDVRgzmF2NLe8Zcah+pOzJqpd4wlYw0qrhRSBv3EXv6Psr1HXhWErFFupMxJiLwVoK/pn1Aj/qNjyfsDTda7Pep7LG4HhHAUYEiaBbW8Td6aBAsBq4SKG/3sbq3d1j9vTc6CB0ONqYWWphe565lIAhAa4mhfsyFEavM3GB+U1pkjcvERtW8D29oPFTVgoeFVP3vxWVHMGr8vF9wayhAFSxGQWsyrInWpJjzlRJ3+3a15HitxgPnqIgrFoliSaNZPPnhHDl6eQOtzheWHhGWWGGq2qo8e8C82K16Rdw/UIbW/YY5MJM81QQEIPUXBiO8sdaQOUrg0uciEkg3m7GUh7LoxEGh+Fo70ctbHaEIDggBbIRIDdkyuYWFZE5V1TDom6Sh/uGOY0aYcB7C9WIXPAavMpxGlBPzKW2W4BMBCJTaEpepAES9uyONJY5OZrUKiLg3TkfCLlu1mGJ7A/Ni9EMpn0E4klCFNYx6/7c0bw4gzbINGBZV9oL7OZZthZnPW6Tku/aRfJPLYIk4ZHoOpQ5KoJmJzL1Mkgq3oCxXsAHtsyERvgJv1v9jvTEOPRqXXxAB5J5DCN4bJuZV+dV68QjQ8TBJYFNyDOtm2VKenEU/YfKBIOnKpC9WWfBTdZ0v3fMHK8pEpLuKMrIADK6i414lLWqXIuNdGCGJW60uqq5g6A970noh0o+TTM8Vz+aqy63zHAinZsCSASITCed5GRxCXqv9ozpX6EH0sIIh1PTO7O5GDibg1ZKfZqaKDFYxUNRhcICgLbYPBwJMoDpYPM9w8GBXg1nkGmwxZ73lzMpdxedRaIzDZ4ciJQYmWj/8iWDhFIAoGk54L+3JpNpOOzcLUGrAKprU7FnAZYwR8v9YiG0J68AXIsEE
 uUNVNnZ5
 2lPxCL9dZzoO3dOSue7KDqVTSbbvLn7TWc2hwtL75H5YFkMIagm2esEBLSzneCUgUACqFoUJs0jphcRopTF2J+Nx+sDcpEf7hx0NZymzB/t+AQa8G3f4cYfuO7/SO5VpykeCUiHSW/Uwlu5BpiVMIe7EFBoNB2kpsnV4eXr2SmvRXgYvQ8zzN+0gTJamym5gNfb/YUe01fpWQRJlLiFwUx/mTLSVPaHZQJjye7wHEv2gZNwTGWR/S1ujnCJQLczrT9HfEifRHHye+g1QMsBR1cl7arawr2+RQrZEfP8GbrRzIskbo8o5rMz3cpJg6ilxHCwrUFXQ2ZlDneLGVYxRbro6dpj/uz1rlPkhhliabPS/f7/YvPjm/XhI+r56xM6PsCVnLF3QEYLBrQ7jMZiNojshHx2KI3dSJXCZ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhiguo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhiguo-Zhou/mm-filemap-refactor-__filemap_add_folio-to-separate-critical-section/20260119-143737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260119065027.918085-2-zhiguo.zhou%40intel.com
patch subject: [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate critical section
config: s390-randconfig-002-20260119 (https://download.01.org/0day-ci/archive/20260119/202601191620.O1a0T02o-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260119/202601191620.O1a0T02o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601191620.O1a0T02o-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/filemap.c:861:2: error: member reference type 'spinlock_t' (aka 'struct spinlock') is not a pointer; did you mean to use '.'?
     861 |         lockdep_assert_held(xas->xa->xa_lock);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:285:17: note: expanded from macro 'lockdep_assert_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:52: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
>> mm/filemap.c:861:2: error: cannot take the address of an rvalue of type 'struct lockdep_map'
     861 |         lockdep_assert_held(xas->xa->xa_lock);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:285:17: note: expanded from macro 'lockdep_assert_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:45: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                      ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   mm/filemap.c:941:3: error: member reference type 'spinlock_t' (aka 'struct spinlock') is not a pointer; did you mean to use '.'?
     941 |                 lockdep_assert_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:285:17: note: expanded from macro 'lockdep_assert_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:52: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   mm/filemap.c:941:3: error: cannot take the address of an rvalue of type 'struct lockdep_map'
     941 |                 lockdep_assert_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:285:17: note: expanded from macro 'lockdep_assert_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:45: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                      ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   mm/filemap.c:944:3: error: member reference type 'spinlock_t' (aka 'struct spinlock') is not a pointer; did you mean to use '.'?
     944 |                 lockdep_assert_not_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:288:17: note: expanded from macro 'lockdep_assert_not_held'
     288 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:52: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   mm/filemap.c:944:3: error: cannot take the address of an rvalue of type 'struct lockdep_map'
     944 |                 lockdep_assert_not_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:288:17: note: expanded from macro 'lockdep_assert_not_held'
     288 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
         |         ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:252:45: note: expanded from macro 'lockdep_is_held'
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                      ^
   include/linux/lockdep.h:279:32: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/asm-generic/bug.h:110:25: note: expanded from macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   6 errors generated.


vim +861 mm/filemap.c

   847	
   848	/*
   849	 * The critical section for storing a folio in an XArray.
   850	 * Context: Expects xas->xa->xa_lock to be held.
   851	 */
   852	static void __filemap_add_folio_xa_locked(struct xa_state *xas,
   853			struct address_space *mapping, struct folio *folio, void **shadowp)
   854	{
   855		bool huge;
   856		long nr;
   857		unsigned int forder = folio_order(folio);
   858		int order = -1;
   859		void *entry, *old = NULL;
   860	
 > 861		lockdep_assert_held(xas->xa->xa_lock);
   862	
   863		huge = folio_test_hugetlb(folio);
   864		nr = folio_nr_pages(folio);
   865	
   866		xas_for_each_conflict(xas, entry) {
   867			old = entry;
   868			if (!xa_is_value(entry)) {
   869				xas_set_err(xas, -EEXIST);
   870				return;
   871			}
   872			/*
   873			 * If a larger entry exists,
   874			 * it will be the first and only entry iterated.
   875			 */
   876			if (order == -1)
   877				order = xas_get_order(xas);
   878		}
   879	
   880		if (old) {
   881			if (order > 0 && order > forder) {
   882				unsigned int split_order = max(forder,
   883						xas_try_split_min_order(order));
   884	
   885				/* How to handle large swap entries? */
   886				BUG_ON(shmem_mapping(mapping));
   887	
   888				while (order > forder) {
   889					xas_set_order(xas, xas->xa_index, split_order);
   890					xas_try_split(xas, old, order);
   891					if (xas_error(xas))
   892						return;
   893					order = split_order;
   894					split_order =
   895						max(xas_try_split_min_order(
   896							    split_order),
   897						    forder);
   898				}
   899				xas_reset(xas);
   900			}
   901			if (shadowp)
   902				*shadowp = old;
   903		}
   904	
   905		xas_store(xas, folio);
   906		if (xas_error(xas))
   907			return;
   908	
   909		mapping->nrpages += nr;
   910	
   911		/* hugetlb pages do not participate in page cache accounting */
   912		if (!huge) {
   913			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
   914			if (folio_test_pmd_mappable(folio))
   915				lruvec_stat_mod_folio(folio,
   916						NR_FILE_THPS, nr);
   917		}
   918	}
   919	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

