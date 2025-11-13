Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A185ACD6E71
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B990B8E0002; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A820D8E000D; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970BD8E0002; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 782C68E000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B7F713BF9A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:22:30 +0000 (UTC)
X-FDA: 84105799260.06.1D93819
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id E79E240008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:22:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IKayPnVO;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763043748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwxfDbLynV4Pge589M5EkoTAig21qmpfoAdYFMPa6jc=;
	b=lpQFEFbiKxsImfbfkQwYxCIyKnKcy/kby2DDfkq1dol+Flo0QUVDhFYgu1eVePtz7TK1GJ
	sRuRUwifJgdPzGvGQaZOwntaFR3lU+7CItO1A9afuaNbTRkTjTCG3df/7jAhBLY3J+pktL
	ePF2xonFj5Q8cq9Lxy5n8A5zUlNX9V8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763043748; a=rsa-sha256;
	cv=none;
	b=UVMgKvEohXm0tzajxzxvrwCGDrLoyrRyziENKmTGeS+fLAl3kZyvqYQlVcLAtZCNeMQ2U9
	WODpV2LQV+W+/bPhYXwRI7kxCJiUnZJcyUqgtrMIq+rrSVNKd5UJ8J+7/DFXPTau+0eLom
	8ZDExpdI01WhIbPsuquB2wV06rV4hQw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IKayPnVO;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763043748; x=1794579748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xnnsvmsynLhCJA8kqZ6OTK0ZZJoL8EJpbcjlNFMyjpQ=;
  b=IKayPnVOJ4MI0iq5XrJJhP69Sm9ZabycyMwjdha5kvzPuyMJyQOtu0ms
   EbIRaEgmK3Z8v0UpPSPf8/g43b3/sCclahcj7vkCuGn3cNNg07dIlAlJH
   cvQ3euseVMkRgj9WJrbKV7p9n7H7ESKdDgTi3UPDPT8wnEileOIAwkYIo
   IMQCNo51La0OOfKDs92WbLlyf7gQ7T9bHPZVxQzGz0+Mv4/DVo9o3UqqN
   n/bHQ1TBOegeEf14rHeDW4qPa41p4QbteF5IYTVnj45JZ3HCeVN8vI+Zr
   0zvLuPEZjiAmbjH5UMcGtujdsll/ApXTtuQCHO2tYO/q9YYPxJqgjv/bA
   w==;
X-CSE-ConnectionGUID: 6Ef6v3wpRV6YRrWFhQhexQ==
X-CSE-MsgGUID: WP7qT+CPQEy5tAgl10TbNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65030935"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="65030935"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 06:22:26 -0800
X-CSE-ConnectionGUID: fDQyYIHgThyX/u+ldziGTA==
X-CSE-MsgGUID: riG7g50QQkKnxx+WkBLq3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="220313534"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Nov 2025 06:22:21 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJYDL-0005QI-0m;
	Thu, 13 Nov 2025 14:22:19 +0000
Date: Thu, 13 Nov 2025 22:21:52 +0800
From: kernel test robot <lkp@intel.com>
To: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zach O'Keefe <zokeefe@google.com>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, shivankg@amd.com,
	Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <202511132138.jhG6hoZ4-lkp@intel.com>
References: <20251110113254.77822-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110113254.77822-1-shivankg@amd.com>
X-Stat-Signature: r9giamxwpkyoohtyyzjhqabg8gym7cqg
X-Rspam-User: 
X-Rspamd-Queue-Id: E79E240008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763043747-916410
X-HE-Meta: U2FsdGVkX19s0RTuPXqefwEUokNGHj9RUBnt4QlCDCAI6MKqb9lvTKnK3OtlBSw5YsQsM/q/Ysn2Z8p4GAxwE7IMSLVclKSO6jxXsY47PmHnuKjPYfEaGbCXi0+LaOTmzBtL3ZSld7lMEtCeNMpBMQDFPJFUHXhBjtY9R/FC43IDzqYz1x3Rx5T6UAQWAyDoHtyb6slB2iF6hfvY2Qh4M5CL0an6z98nvkp30uWiztBGorTX6gib5/uv3IwJFuVuB/NgN+uOskkkPBqkf4Uad8DC6sJOzSsHv8clyerVOROLJee0C2rQ63xD1BCKuNTncp0huImNhuMKesSPXb20HWx8LwirvV05QVm+3taoMKhwdss3NmQewiQE9CrQnhUf5JEDmj3G5jviOH7n6A9slcxUoTeI1x8JR+Z/qG+FO4VWUVTQ0xs0GxCxp7zn4p8Ubijp6WfE58bX8reH9RDF5r1KpRUfo9zh1t3sWnhCBQGOvHiZdx6nkhY0dJT1zLCI2TAkYLtIGvRhfNGbrN6MiSwtTmHJx5StUeXZ2aquKukpJwsHoLWVppxxZ/ERQ4B6L3VYswQwgpBcw04hwZ7Tcf+lhLpba15QwaTynux/zD9SCIIwtxyYGWjsZh+VREkWYDcfkzOWxGd2SL6FWWayqHsRg6qU3lwlWgOsLwCmwLxYiL/gbYN+sdkOGCVO+fTjuwEoQapMW7ug5noKRjlK39nql654WjtR0HpMTEINEJHz95YfB0rL7eZIVBRGVP8PgIFyV70D/i2dj6Bir3WibS0GqnMwdyYliesMhQjWpf2bsn7wI62sz1+Q9vQ/2BLc/pH9pJ+yTcxn7KWo2Y9pVhPmTDvizuygMLYBtQ4nFpC77QUza1Wo50kSOc/GjoQKlFgXZJ7pGdvNLEhFVTJaiayqT1fTOookpHyCuMA2p34=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shivank,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivank-Garg/mm-khugepaged-return-EAGAIN-for-transient-dirty-pages-in-MADV_COLLAPSE/20251110-193519
base:   e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
patch link:    https://lore.kernel.org/r/20251110113254.77822-1-shivankg%40amd.com
patch subject: [PATCH 1/2] mm/khugepaged: do synchronous writeback for MADV_COLLAPSE
config: arm64-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251113/202511132138.jhG6hoZ4-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511132138.jhG6hoZ4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511132138.jhG6hoZ4-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/khugepaged.c:1867:7: warning: variable 'new_folio' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1867 |                 if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/khugepaged.c:2284:40: note: uninitialized use occurs here
    2284 |         trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
         |                                               ^~~~~~~~~
   mm/khugepaged.c:1867:3: note: remove the 'if' if its condition is always false
    1867 |                 if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1868 |                         result = SCAN_FAIL;
         |                         ~~~~~~~~~~~~~~~~~~~
    1869 |                         goto out;
         |                         ~~~~~~~~~
    1870 |                 }
         |                 ~
   mm/khugepaged.c:1847:39: note: initialize the variable 'new_folio' to silence this warning
    1847 |         struct folio *folio, *tmp, *new_folio;
         |                                              ^
         |                                               = NULL
   1 warning generated.


vim +1867 mm/khugepaged.c

  1815	
  1816	/**
  1817	 * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
  1818	 *
  1819	 * @mm: process address space where collapse happens
  1820	 * @addr: virtual collapse start address
  1821	 * @file: file that collapse on
  1822	 * @start: collapse start address
  1823	 * @cc: collapse context and scratchpad
  1824	 *
  1825	 * Basic scheme is simple, details are more complex:
  1826	 *  - allocate and lock a new huge page;
  1827	 *  - scan page cache, locking old pages
  1828	 *    + swap/gup in pages if necessary;
  1829	 *  - copy data to new page
  1830	 *  - handle shmem holes
  1831	 *    + re-validate that holes weren't filled by someone else
  1832	 *    + check for userfaultfd
  1833	 *  - finalize updates to the page cache;
  1834	 *  - if replacing succeeds:
  1835	 *    + unlock huge page;
  1836	 *    + free old pages;
  1837	 *  - if replacing failed;
  1838	 *    + unlock old pages
  1839	 *    + unlock and free huge page;
  1840	 */
  1841	static int collapse_file(struct mm_struct *mm, unsigned long addr,
  1842				 struct file *file, pgoff_t start,
  1843				 struct collapse_control *cc)
  1844	{
  1845		struct address_space *mapping = file->f_mapping;
  1846		struct page *dst;
  1847		struct folio *folio, *tmp, *new_folio;
  1848		pgoff_t index = 0, end = start + HPAGE_PMD_NR;
  1849		loff_t range_start, range_end;
  1850		LIST_HEAD(pagelist);
  1851		XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
  1852		int nr_none = 0, result = SCAN_SUCCEED;
  1853		bool is_shmem = shmem_file(file);
  1854	
  1855		VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
  1856		VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
  1857	
  1858		/*
  1859		 * For MADV_COLLAPSE on regular files, do a synchronous writeback
  1860		 * to ensure dirty folios are flushed before we attempt collapse.
  1861		 * This is a best-effort approach to avoid failing on the first
  1862		 * attempt when freshly-written executable text is still dirty.
  1863		 */
  1864		if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
  1865			range_start = (loff_t)start << PAGE_SHIFT;
  1866			range_end = ((loff_t)end << PAGE_SHIFT) - 1;
> 1867			if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
  1868				result = SCAN_FAIL;
  1869				goto out;
  1870			}
  1871		}
  1872	
  1873		result = alloc_charge_folio(&new_folio, mm, cc);
  1874		if (result != SCAN_SUCCEED)
  1875			goto out;
  1876	
  1877		mapping_set_update(&xas, mapping);
  1878	
  1879		__folio_set_locked(new_folio);
  1880		if (is_shmem)
  1881			__folio_set_swapbacked(new_folio);
  1882		new_folio->index = start;
  1883		new_folio->mapping = mapping;
  1884	
  1885		/*
  1886		 * Ensure we have slots for all the pages in the range.  This is
  1887		 * almost certainly a no-op because most of the pages must be present
  1888		 */
  1889		do {
  1890			xas_lock_irq(&xas);
  1891			xas_create_range(&xas);
  1892			if (!xas_error(&xas))
  1893				break;
  1894			xas_unlock_irq(&xas);
  1895			if (!xas_nomem(&xas, GFP_KERNEL)) {
  1896				result = SCAN_FAIL;
  1897				goto rollback;
  1898			}
  1899		} while (1);
  1900	
  1901		for (index = start; index < end;) {
  1902			xas_set(&xas, index);
  1903			folio = xas_load(&xas);
  1904	
  1905			VM_BUG_ON(index != xas.xa_index);
  1906			if (is_shmem) {
  1907				if (!folio) {
  1908					/*
  1909					 * Stop if extent has been truncated or
  1910					 * hole-punched, and is now completely
  1911					 * empty.
  1912					 */
  1913					if (index == start) {
  1914						if (!xas_next_entry(&xas, end - 1)) {
  1915							result = SCAN_TRUNCATED;
  1916							goto xa_locked;
  1917						}
  1918					}
  1919					nr_none++;
  1920					index++;
  1921					continue;
  1922				}
  1923	
  1924				if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
  1925					xas_unlock_irq(&xas);
  1926					/* swap in or instantiate fallocated page */
  1927					if (shmem_get_folio(mapping->host, index, 0,
  1928							&folio, SGP_NOALLOC)) {
  1929						result = SCAN_FAIL;
  1930						goto xa_unlocked;
  1931					}
  1932					/* drain lru cache to help folio_isolate_lru() */
  1933					lru_add_drain();
  1934				} else if (folio_trylock(folio)) {
  1935					folio_get(folio);
  1936					xas_unlock_irq(&xas);
  1937				} else {
  1938					result = SCAN_PAGE_LOCK;
  1939					goto xa_locked;
  1940				}
  1941			} else {	/* !is_shmem */
  1942				if (!folio || xa_is_value(folio)) {
  1943					xas_unlock_irq(&xas);
  1944					page_cache_sync_readahead(mapping, &file->f_ra,
  1945								  file, index,
  1946								  end - index);
  1947					/* drain lru cache to help folio_isolate_lru() */
  1948					lru_add_drain();
  1949					folio = filemap_lock_folio(mapping, index);
  1950					if (IS_ERR(folio)) {
  1951						result = SCAN_FAIL;
  1952						goto xa_unlocked;
  1953					}
  1954				} else if (folio_test_dirty(folio)) {
  1955					/*
  1956					 * khugepaged only works on read-only fd,
  1957					 * so this page is dirty because it hasn't
  1958					 * been flushed since first write. There
  1959					 * won't be new dirty pages.
  1960					 *
  1961					 * Trigger async flush here and hope the
  1962					 * writeback is done when khugepaged
  1963					 * revisits this page.
  1964					 *
  1965					 * This is a one-off situation. We are not
  1966					 * forcing writeback in loop.
  1967					 */
  1968					xas_unlock_irq(&xas);
  1969					filemap_flush(mapping);
  1970					result = SCAN_FAIL;
  1971					goto xa_unlocked;
  1972				} else if (folio_test_writeback(folio)) {
  1973					xas_unlock_irq(&xas);
  1974					result = SCAN_FAIL;
  1975					goto xa_unlocked;
  1976				} else if (folio_trylock(folio)) {
  1977					folio_get(folio);
  1978					xas_unlock_irq(&xas);
  1979				} else {
  1980					result = SCAN_PAGE_LOCK;
  1981					goto xa_locked;
  1982				}
  1983			}
  1984	
  1985			/*
  1986			 * The folio must be locked, so we can drop the i_pages lock
  1987			 * without racing with truncate.
  1988			 */
  1989			VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
  1990	
  1991			/* make sure the folio is up to date */
  1992			if (unlikely(!folio_test_uptodate(folio))) {
  1993				result = SCAN_FAIL;
  1994				goto out_unlock;
  1995			}
  1996	
  1997			/*
  1998			 * If file was truncated then extended, or hole-punched, before
  1999			 * we locked the first folio, then a THP might be there already.
  2000			 * This will be discovered on the first iteration.
  2001			 */
  2002			if (folio_order(folio) == HPAGE_PMD_ORDER &&
  2003			    folio->index == start) {
  2004				/* Maybe PMD-mapped */
  2005				result = SCAN_PTE_MAPPED_HUGEPAGE;
  2006				goto out_unlock;
  2007			}
  2008	
  2009			if (folio_mapping(folio) != mapping) {
  2010				result = SCAN_TRUNCATED;
  2011				goto out_unlock;
  2012			}
  2013	
  2014			if (!is_shmem && (folio_test_dirty(folio) ||
  2015					  folio_test_writeback(folio))) {
  2016				/*
  2017				 * khugepaged only works on read-only fd, so this
  2018				 * folio is dirty because it hasn't been flushed
  2019				 * since first write.
  2020				 */
  2021				result = SCAN_FAIL;
  2022				goto out_unlock;
  2023			}
  2024	
  2025			if (!folio_isolate_lru(folio)) {
  2026				result = SCAN_DEL_PAGE_LRU;
  2027				goto out_unlock;
  2028			}
  2029	
  2030			if (!filemap_release_folio(folio, GFP_KERNEL)) {
  2031				result = SCAN_PAGE_HAS_PRIVATE;
  2032				folio_putback_lru(folio);
  2033				goto out_unlock;
  2034			}
  2035	
  2036			if (folio_mapped(folio))
  2037				try_to_unmap(folio,
  2038						TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
  2039	
  2040			xas_lock_irq(&xas);
  2041	
  2042			VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
  2043	
  2044			/*
  2045			 * We control 2 + nr_pages references to the folio:
  2046			 *  - we hold a pin on it;
  2047			 *  - nr_pages reference from page cache;
  2048			 *  - one from lru_isolate_folio;
  2049			 * If those are the only references, then any new usage
  2050			 * of the folio will have to fetch it from the page
  2051			 * cache. That requires locking the folio to handle
  2052			 * truncate, so any new usage will be blocked until we
  2053			 * unlock folio after collapse/during rollback.
  2054			 */
  2055			if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
  2056				result = SCAN_PAGE_COUNT;
  2057				xas_unlock_irq(&xas);
  2058				folio_putback_lru(folio);
  2059				goto out_unlock;
  2060			}
  2061	
  2062			/*
  2063			 * Accumulate the folios that are being collapsed.
  2064			 */
  2065			list_add_tail(&folio->lru, &pagelist);
  2066			index += folio_nr_pages(folio);
  2067			continue;
  2068	out_unlock:
  2069			folio_unlock(folio);
  2070			folio_put(folio);
  2071			goto xa_unlocked;
  2072		}
  2073	
  2074		if (!is_shmem) {
  2075			filemap_nr_thps_inc(mapping);
  2076			/*
  2077			 * Paired with the fence in do_dentry_open() -> get_write_access()
  2078			 * to ensure i_writecount is up to date and the update to nr_thps
  2079			 * is visible. Ensures the page cache will be truncated if the
  2080			 * file is opened writable.
  2081			 */
  2082			smp_mb();
  2083			if (inode_is_open_for_write(mapping->host)) {
  2084				result = SCAN_FAIL;
  2085				filemap_nr_thps_dec(mapping);
  2086			}
  2087		}
  2088	
  2089	xa_locked:
  2090		xas_unlock_irq(&xas);
  2091	xa_unlocked:
  2092	
  2093		/*
  2094		 * If collapse is successful, flush must be done now before copying.
  2095		 * If collapse is unsuccessful, does flush actually need to be done?
  2096		 * Do it anyway, to clear the state.
  2097		 */
  2098		try_to_unmap_flush();
  2099	
  2100		if (result == SCAN_SUCCEED && nr_none &&
  2101		    !shmem_charge(mapping->host, nr_none))
  2102			result = SCAN_FAIL;
  2103		if (result != SCAN_SUCCEED) {
  2104			nr_none = 0;
  2105			goto rollback;
  2106		}
  2107	
  2108		/*
  2109		 * The old folios are locked, so they won't change anymore.
  2110		 */
  2111		index = start;
  2112		dst = folio_page(new_folio, 0);
  2113		list_for_each_entry(folio, &pagelist, lru) {
  2114			int i, nr_pages = folio_nr_pages(folio);
  2115	
  2116			while (index < folio->index) {
  2117				clear_highpage(dst);
  2118				index++;
  2119				dst++;
  2120			}
  2121	
  2122			for (i = 0; i < nr_pages; i++) {
  2123				if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
  2124					result = SCAN_COPY_MC;
  2125					goto rollback;
  2126				}
  2127				index++;
  2128				dst++;
  2129			}
  2130		}
  2131		while (index < end) {
  2132			clear_highpage(dst);
  2133			index++;
  2134			dst++;
  2135		}
  2136	
  2137		if (nr_none) {
  2138			struct vm_area_struct *vma;
  2139			int nr_none_check = 0;
  2140	
  2141			i_mmap_lock_read(mapping);
  2142			xas_lock_irq(&xas);
  2143	
  2144			xas_set(&xas, start);
  2145			for (index = start; index < end; index++) {
  2146				if (!xas_next(&xas)) {
  2147					xas_store(&xas, XA_RETRY_ENTRY);
  2148					if (xas_error(&xas)) {
  2149						result = SCAN_STORE_FAILED;
  2150						goto immap_locked;
  2151					}
  2152					nr_none_check++;
  2153				}
  2154			}
  2155	
  2156			if (nr_none != nr_none_check) {
  2157				result = SCAN_PAGE_FILLED;
  2158				goto immap_locked;
  2159			}
  2160	
  2161			/*
  2162			 * If userspace observed a missing page in a VMA with
  2163			 * a MODE_MISSING userfaultfd, then it might expect a
  2164			 * UFFD_EVENT_PAGEFAULT for that page. If so, we need to
  2165			 * roll back to avoid suppressing such an event. Since
  2166			 * wp/minor userfaultfds don't give userspace any
  2167			 * guarantees that the kernel doesn't fill a missing
  2168			 * page with a zero page, so they don't matter here.
  2169			 *
  2170			 * Any userfaultfds registered after this point will
  2171			 * not be able to observe any missing pages due to the
  2172			 * previously inserted retry entries.
  2173			 */
  2174			vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
  2175				if (userfaultfd_missing(vma)) {
  2176					result = SCAN_EXCEED_NONE_PTE;
  2177					goto immap_locked;
  2178				}
  2179			}
  2180	
  2181	immap_locked:
  2182			i_mmap_unlock_read(mapping);
  2183			if (result != SCAN_SUCCEED) {
  2184				xas_set(&xas, start);
  2185				for (index = start; index < end; index++) {
  2186					if (xas_next(&xas) == XA_RETRY_ENTRY)
  2187						xas_store(&xas, NULL);
  2188				}
  2189	
  2190				xas_unlock_irq(&xas);
  2191				goto rollback;
  2192			}
  2193		} else {
  2194			xas_lock_irq(&xas);
  2195		}
  2196	
  2197		if (is_shmem)
  2198			__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
  2199		else
  2200			__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
  2201	
  2202		if (nr_none) {
  2203			__lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
  2204			/* nr_none is always 0 for non-shmem. */
  2205			__lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
  2206		}
  2207	
  2208		/*
  2209		 * Mark new_folio as uptodate before inserting it into the
  2210		 * page cache so that it isn't mistaken for an fallocated but
  2211		 * unwritten page.
  2212		 */
  2213		folio_mark_uptodate(new_folio);
  2214		folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
  2215	
  2216		if (is_shmem)
  2217			folio_mark_dirty(new_folio);
  2218		folio_add_lru(new_folio);
  2219	
  2220		/* Join all the small entries into a single multi-index entry. */
  2221		xas_set_order(&xas, start, HPAGE_PMD_ORDER);
  2222		xas_store(&xas, new_folio);
  2223		WARN_ON_ONCE(xas_error(&xas));
  2224		xas_unlock_irq(&xas);
  2225	
  2226		/*
  2227		 * Remove pte page tables, so we can re-fault the page as huge.
  2228		 * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp().
  2229		 */
  2230		retract_page_tables(mapping, start);
  2231		if (cc && !cc->is_khugepaged)
  2232			result = SCAN_PTE_MAPPED_HUGEPAGE;
  2233		folio_unlock(new_folio);
  2234	
  2235		/*
  2236		 * The collapse has succeeded, so free the old folios.
  2237		 */
  2238		list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
  2239			list_del(&folio->lru);
  2240			folio->mapping = NULL;
  2241			folio_clear_active(folio);
  2242			folio_clear_unevictable(folio);
  2243			folio_unlock(folio);
  2244			folio_put_refs(folio, 2 + folio_nr_pages(folio));
  2245		}
  2246	
  2247		goto out;
  2248	
  2249	rollback:
  2250		/* Something went wrong: roll back page cache changes */
  2251		if (nr_none) {
  2252			xas_lock_irq(&xas);
  2253			mapping->nrpages -= nr_none;
  2254			xas_unlock_irq(&xas);
  2255			shmem_uncharge(mapping->host, nr_none);
  2256		}
  2257	
  2258		list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
  2259			list_del(&folio->lru);
  2260			folio_unlock(folio);
  2261			folio_putback_lru(folio);
  2262			folio_put(folio);
  2263		}
  2264		/*
  2265		 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
  2266		 * file only. This undo is not needed unless failure is
  2267		 * due to SCAN_COPY_MC.
  2268		 */
  2269		if (!is_shmem && result == SCAN_COPY_MC) {
  2270			filemap_nr_thps_dec(mapping);
  2271			/*
  2272			 * Paired with the fence in do_dentry_open() -> get_write_access()
  2273			 * to ensure the update to nr_thps is visible.
  2274			 */
  2275			smp_mb();
  2276		}
  2277	
  2278		new_folio->mapping = NULL;
  2279	
  2280		folio_unlock(new_folio);
  2281		folio_put(new_folio);
  2282	out:
  2283		VM_BUG_ON(!list_empty(&pagelist));
  2284		trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
  2285		return result;
  2286	}
  2287	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

