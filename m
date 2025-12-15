Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F58D5B86F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 23:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05496B0088; Mon, 15 Dec 2025 18:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5096B0089; Mon, 15 Dec 2025 18:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2226B008A; Mon, 15 Dec 2025 18:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42D86B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:02:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FE8F60124
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:02:53 +0000 (UTC)
X-FDA: 84223232226.18.4481A7D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf07.hostedemail.com (Postfix) with ESMTP id E6C5140016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:02:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NpWlFdL3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765839771; a=rsa-sha256;
	cv=none;
	b=FpZkf4OhlBqqnIgopTlo+cw4czHCHqTQ7j1Eynq2+52kL97QxwgOyDb910b+O+fHUAUoSx
	wM0iqemESXzS7ztV3ZgYnVi2L7aOAG9mN0bFIa/pxeKH7nZPQ6J3TdggesYY8E0Jf93ddH
	XghFobZT1cZUWDRKkfCq4wCgbxtBzMA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NpWlFdL3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765839771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffsUr8KiDutG9W7Ln/H78lmK6UTEHuP+5pMRbbbET4Q=;
	b=o5r3oQbQf9rMWb77zEwrb6WDUWQI56Bmh7Fliu/RVOvonzweh3hupV3PLXxpaN46woWgGt
	RQ+nqZEqOT9h+2zUETowCNZDMMSIhlq8eB6FGbtdwhQB1KaPJHg7440OvVs/DrCugd8uM5
	gaIRuhxwJNhe52+Cugr0JXpOgd/vHpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765839770; x=1797375770;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eYLKVU2QRAQA7OiP1IXrxC/XhVFr1pnu7mQaGQUH9Ds=;
  b=NpWlFdL3nIwDEyqqMwniBqLV1N3HGgf6k0CrqJ2pGElrT6YmONBI1+4g
   DWqMHUHzkuNE55yMjrNia415Elnmp3Dl7f8JnG3/0y10NVhmu8TRlQano
   e5Xh9cgCWz+zaH1StDPqJSTDSRHWOj2R/zwMZBKQ8Fe8m5ZRb3t0V655p
   nm+j0vN4G0SuJBlJJH09oGUOS+yQl2VBAGcD+kS8bK3y5EJGlaitjwK48
   SoQP+V4D8NYQaVTmbbWrKfwK6p48402/meyUz4WNU8pv81gZgGTm5xyis
   G1E5HboYj6PcU4m+GAHYbopbCqZv8bqGwyv6ro+7DsnwRbJuduzbXVdLs
   w==;
X-CSE-ConnectionGUID: mBC0IuV9Ss65f08XBWd+xw==
X-CSE-MsgGUID: q9CeqXG8SyimBMfZ/NVoNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="67636253"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="67636253"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 15:02:48 -0800
X-CSE-ConnectionGUID: 9bah/LqRSRSlXkmZaCSNUw==
X-CSE-MsgGUID: P98eHP8IQNerTmErFFb7rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="235255738"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 15 Dec 2025 15:02:45 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVHaU-000000000tr-2duy;
	Mon, 15 Dec 2025 23:02:42 +0000
Date: Tue, 16 Dec 2025 07:01:18 +0800
From: kernel test robot <lkp@intel.com>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, npache@redhat.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <202512160619.3Ut4sxaJ-lkp@intel.com>
References: <20251215090419.174418-3-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-3-yanglincheng@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: E6C5140016
X-Rspamd-Server: rspam10
X-Stat-Signature: y4jketapk11834ocxq4t643mtaq9jwmd
X-HE-Tag: 1765839769-896919
X-HE-Meta: U2FsdGVkX1+YyDpPL36tehq7JsNbJgzKdm5BSOaUneJH+Ycv7Luivkp6xF0rdMQjq9G6ETh6AK7BF4xTi9n3UKf73zEHEa+QwuJvkxnFF/PFlgPV2ZhY2nGvxRj6oH7MvHLbqFENDY6J5VxOXhaHT1ipTchn39S+kEzSIYhT8vd7PQFlTJlv2oiQh/ZsJZy+8Kl38NW4Ynp3K4UxRwi66a7JzW3uww/gVJS6vnURx4EPZ0uKclut9Th2aWTvaPxD/eNuC5fs9MBt/oApfnuEOcuLCBr4BvyXYFWBWzk2shP8tu+FlPI6GMnKIADOQq4v7fty5GP7qYQj6Da62YEYJ+4pZHShHYZf1FgltUpHRR+R10NuERTiGKK5f4y6MNQHgMMyLud2+loMaIpVBTLS+hKofeiFQyhhd0+4ktDTv7v4QmRqGLg9UIoB5DDQUcDJhzwSvXBnuSFA1N/w5ldTS5e+GxjvYJ8ylLG8RfLqtwmKsOPhmui7FWXEYOzypMeDuncDKfrTXbG2R9PmsLNEGusZYpEi0mL7psL7eNS0IXrwQyeqZ09QKj/hur9XVYZuq72obTXlV96RBorswRX6Rjd+YLeIvL4fnipV3D+DJ0GKMGDR35yQu+fff9X/4hX1xsyT63WbkpXEJPI7W7zDHpZBKxGoWiP56EBBBSFp4p114SClKvGm1fUbpmHrAx9ulq1tvbXwdfpEBusk4xhNitDhGJX968Mge9XlJNeachApmCkKmVH60rqZcHIhNobX1a6+96dic5lVQKkVA4x73R6gJ7fmRhfnCFixL3ZusyZXg0+CRun2zl9NnW8/KVV4fA98k8iaQMnokZ91vyODtfOtMALk8RSSBaw6BF5RIuZER09IaXTMONbHb4umylAgJ/YM7Z2lrno/dMd6pKnTKdSCy52HEGKCJbXehAs2GgrpS8zoHfu/ecE/G4hDEvxFhNU+yhJqDR/2+DV/VwS
 JMHpfs1g
 /jijMGBSuIohurIHiiKTG9HBwZMdCIphevIg4Av2sNPdOOuAu2QzKsDsu6DF//sESVppn+wQrTLvQf9eEY62XI66E0KYkJRJs3AhdCnNN2L0baZBeEk1stHmkmtwOaAqCfL6N8h2k/Y0F5XGFuCnUA8Z4oMlQ+pFRTAnzMDPBoLFDrPUOcy++oinXPBTG2yGWRvxAggVA1RIOdeijbrAdRTGuq2a00Htr5xe6Isms70OtFnpCJ2RHUCy4t+tmBbIPArZwhUfD6VnuHLnw4YaoCHOXv75WZmG+tUuLtbkvYTG62WFf0/eEF77dTBD7hQ2+5snQS2LKrTL2xBi6CK9Xs8Ha2880SsS7kVD1fJT9MldVj4rMDUMJ6D/VsBK/l3VHeh5C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vernon,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc1 next-20251215]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251215090419.174418-3-yanglincheng%40kylinos.cn
patch subject: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251216/202512160619.3Ut4sxaJ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160619.3Ut4sxaJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512160619.3Ut4sxaJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/khugepaged.c: In function 'khugepaged_scan_mm_slot':
>> mm/khugepaged.c:2490:30: error: 'SCAN_PMD_NULL' undeclared (first use in this function); did you mean 'SCAN_VMA_NULL'?
    2490 |                         case SCAN_PMD_NULL:
         |                              ^~~~~~~~~~~~~
         |                              SCAN_VMA_NULL
   mm/khugepaged.c:2490:30: note: each undeclared identifier is reported only once for each function it appears in
>> mm/khugepaged.c:2491:30: error: 'SCAN_PMD_NONE' undeclared (first use in this function)
    2491 |                         case SCAN_PMD_NONE:
         |                              ^~~~~~~~~~~~~


vim +2490 mm/khugepaged.c

  2392	
  2393	static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
  2394						    struct collapse_control *cc)
  2395		__releases(&khugepaged_mm_lock)
  2396		__acquires(&khugepaged_mm_lock)
  2397	{
  2398		struct vma_iterator vmi;
  2399		struct mm_slot *slot;
  2400		struct mm_struct *mm;
  2401		struct vm_area_struct *vma;
  2402		int progress = 0;
  2403	
  2404		VM_BUG_ON(!pages);
  2405		lockdep_assert_held(&khugepaged_mm_lock);
  2406		*result = SCAN_FAIL;
  2407	
  2408		if (khugepaged_scan.mm_slot) {
  2409			slot = khugepaged_scan.mm_slot;
  2410		} else {
  2411			slot = list_first_entry(&khugepaged_scan.mm_head,
  2412					     struct mm_slot, mm_node);
  2413			khugepaged_scan.address = 0;
  2414			khugepaged_scan.mm_slot = slot;
  2415			khugepaged_scan.maybe_collapse = false;
  2416		}
  2417		spin_unlock(&khugepaged_mm_lock);
  2418	
  2419		mm = slot->mm;
  2420		/*
  2421		 * Don't wait for semaphore (to avoid long wait times).  Just move to
  2422		 * the next mm on the list.
  2423		 */
  2424		vma = NULL;
  2425		if (unlikely(!mmap_read_trylock(mm)))
  2426			goto breakouterloop_mmap_lock;
  2427	
  2428		progress++;
  2429		if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
  2430			goto breakouterloop;
  2431	
  2432		vma_iter_init(&vmi, mm, khugepaged_scan.address);
  2433		for_each_vma(vmi, vma) {
  2434			unsigned long hstart, hend;
  2435	
  2436			cond_resched();
  2437			if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
  2438				progress++;
  2439				break;
  2440			}
  2441			if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
  2442	skip:
  2443				progress++;
  2444				continue;
  2445			}
  2446			hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
  2447			hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
  2448			if (khugepaged_scan.address > hend)
  2449				goto skip;
  2450			if (khugepaged_scan.address < hstart)
  2451				khugepaged_scan.address = hstart;
  2452			VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
  2453	
  2454			while (khugepaged_scan.address < hend) {
  2455				bool mmap_locked = true;
  2456	
  2457				cond_resched();
  2458				if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
  2459					goto breakouterloop;
  2460	
  2461				VM_BUG_ON(khugepaged_scan.address < hstart ||
  2462					  khugepaged_scan.address + HPAGE_PMD_SIZE >
  2463					  hend);
  2464				if (!vma_is_anonymous(vma)) {
  2465					struct file *file = get_file(vma->vm_file);
  2466					pgoff_t pgoff = linear_page_index(vma,
  2467							khugepaged_scan.address);
  2468	
  2469					mmap_read_unlock(mm);
  2470					mmap_locked = false;
  2471					*result = hpage_collapse_scan_file(mm,
  2472						khugepaged_scan.address, file, pgoff, cc);
  2473					fput(file);
  2474					if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
  2475						mmap_read_lock(mm);
  2476						if (hpage_collapse_test_exit_or_disable(mm))
  2477							goto breakouterloop;
  2478						*result = collapse_pte_mapped_thp(mm,
  2479							khugepaged_scan.address, false);
  2480						if (*result == SCAN_PMD_MAPPED)
  2481							*result = SCAN_SUCCEED;
  2482						mmap_read_unlock(mm);
  2483					}
  2484				} else {
  2485					*result = hpage_collapse_scan_pmd(mm, vma,
  2486						khugepaged_scan.address, &mmap_locked, cc);
  2487				}
  2488	
  2489				switch (*result) {
> 2490				case SCAN_PMD_NULL:
> 2491				case SCAN_PMD_NONE:
  2492				case SCAN_PMD_MAPPED:
  2493				case SCAN_PTE_MAPPED_HUGEPAGE:
  2494					break;
  2495				case SCAN_SUCCEED:
  2496					++khugepaged_pages_collapsed;
  2497					fallthrough;
  2498				default:
  2499					khugepaged_scan.maybe_collapse = true;
  2500				}
  2501	
  2502				/* move to next address */
  2503				khugepaged_scan.address += HPAGE_PMD_SIZE;
  2504				progress += HPAGE_PMD_NR;
  2505				if (!mmap_locked)
  2506					/*
  2507					 * We released mmap_lock so break loop.  Note
  2508					 * that we drop mmap_lock before all hugepage
  2509					 * allocations, so if allocation fails, we are
  2510					 * guaranteed to break here and report the
  2511					 * correct result back to caller.
  2512					 */
  2513					goto breakouterloop_mmap_lock;
  2514				if (progress >= pages)
  2515					goto breakouterloop;
  2516			}
  2517		}
  2518	breakouterloop:
  2519		mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
  2520	breakouterloop_mmap_lock:
  2521	
  2522		spin_lock(&khugepaged_mm_lock);
  2523		VM_BUG_ON(khugepaged_scan.mm_slot != slot);
  2524		/*
  2525		 * Release the current mm_slot if this mm is about to die, or
  2526		 * if we scanned all vmas of this mm.
  2527		 */
  2528		if (hpage_collapse_test_exit(mm) || !vma) {
  2529			bool maybe_collapse = khugepaged_scan.maybe_collapse;
  2530	
  2531			if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
  2532				maybe_collapse = true;
  2533	
  2534			/*
  2535			 * Make sure that if mm_users is reaching zero while
  2536			 * khugepaged runs here, khugepaged_exit will find
  2537			 * mm_slot not pointing to the exiting mm.
  2538			 */
  2539			if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
  2540				khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
  2541				khugepaged_scan.address = 0;
  2542				khugepaged_scan.maybe_collapse = false;
  2543			} else {
  2544				khugepaged_scan.mm_slot = NULL;
  2545				khugepaged_full_scans++;
  2546			}
  2547	
  2548			collect_mm_slot(slot, maybe_collapse);
  2549		}
  2550	
  2551		trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
  2552	
  2553		return progress;
  2554	}
  2555	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

