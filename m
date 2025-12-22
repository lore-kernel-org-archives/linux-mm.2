Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA74EE67810
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76426B0088; Mon, 22 Dec 2025 14:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E736B0089; Mon, 22 Dec 2025 14:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A346B008A; Mon, 22 Dec 2025 14:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4E4E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:01:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64CE5879E2
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:01:32 +0000 (UTC)
X-FDA: 84248025624.20.737C786
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1D14F4002A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:01:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B0lXUSDM;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766430090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfLSJJv5GcA0LWmT8+XQi/IZdZhrUwDmj8TNPqKWWl4=;
	b=f1GdX2aS24F8LKbMP2/ER57G6NF1avKnU9gETFJrW5tSdELSyvjg0qMNbulPenf8uyoE7R
	OAni+zSm5Uu+kXISphq8aEJhQ4+ez5imHBLrhi/79Az3K7DIHHWfeGSRIeVm1lKay7oiut
	Gi6j8jYmnHe0xXdqaZkumN6fX+cnp0Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B0lXUSDM;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766430090; a=rsa-sha256;
	cv=none;
	b=28MUSvpLRhdnvotIXKipsqyVi2zTPOzDH50FagTrZe7dMWB6WtnVtlug2r5VRpxsLwOMyZ
	5NbBgTJxcm4LYJGPhrdj5JZR2tM87vnAS2Nx0Dpr+BOaJCc5wjLHyz5EIrnSx/KCZ9Vl0O
	o5mJakb4a5CRWLxIehlGUfKBu4Xgh2s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766430089; x=1797966089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gCUaVnNNzL98Z0n3IeKWDumZeZRS4YT4FSG1zqb02ZY=;
  b=B0lXUSDMzTV+a4mtpoDxocvYqa4r5CBhAe3l0OuSNZaWi1o909r5sGPn
   xZ3L1IYQuUHzWbuo3OW+tmHSiTPygeslAn+RC/sUTor/NujoDYFyTx7Bf
   5qiS6BQtdlsMrj3QMP5sbBUNLCVyztQGER5eSRq6VfQ+IYI36wAjHeZUc
   FGiygCYlzedfRFnL4C7/T98SJvZ/utt61jILf4h1dDXVXY3h6tUEi9DUQ
   bY9gZ6MKjTyiiCS8VMsw3NZGvSysiGaXuev7zR61dJdG/fYWakIzAnW6R
   WPBWj2/Z2BYsaRz3ta/ABZY23mEqPsBwVJraTLro8HFbtRlk/9A5aXakE
   w==;
X-CSE-ConnectionGUID: ygLRrCgeSySQkExVNyDQlw==
X-CSE-MsgGUID: iiKhPozISxyTeYfiSnCWEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="70865436"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="70865436"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 11:01:27 -0800
X-CSE-ConnectionGUID: CFicyTbcSamKlxtRRU24og==
X-CSE-MsgGUID: YsWEPHbVSpqCby4HE9YDOQ==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 22 Dec 2025 11:01:24 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXl9l-000000005aK-2235;
	Mon, 22 Dec 2025 19:01:21 +0000
Date: Mon, 22 Dec 2025 20:00:23 +0100
From: kernel test robot <lkp@intel.com>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, npache@redhat.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <202512221928.EnLvUgqT-lkp@intel.com>
References: <20251215090419.174418-3-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-3-yanglincheng@kylinos.cn>
X-Rspamd-Server: rspam02
X-Stat-Signature: 6a9rbsocdodrk6w487cdcksof19e5gh6
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D14F4002A
X-HE-Tag: 1766430088-445606
X-HE-Meta: U2FsdGVkX1//hXMG+hye8UETcV+Bec68mH9a1KV+n/wJt6odLSO/C7jG4UWS0RUEp9sSps8wGvZ8otT6ZwQKJ8NsikLvYW3O2ydds+ZIgXfYZ1evt311c9+efVIs0yHS/ZZPH2dJVVMH4/s2R1iNWmOFbDMA93dBCZlIwH9K5bDHOBkjqbo3q1qWcqpq+p50f8WZYgUtyHrPnNWtTPGLvIDqr59Zz6hrlKvvXVPtp7Gdfxx8hqkW054NkuXpEso3XFDXisBtrPcoSGEXJciCEIToYqCRXNZXon5db0t42+9zmaEKWzFAQC35cckptLfWY96ebwTB3ADQsAasFJs/6uOGI6gdCpjEosrs9VCSV84FNb2T89YgV1Kw0BmoIBhqiqppuLDwqB8KPYz4dzk7jZ84H4LtwoDXAJjx6bCMcbbMgOIPm17hU0pkgQUAkMlah4lX3F99mJUKRE2an++r8cuhIgYkN5kAw1sfxIVjd3hkNn74unbNlaKR14obdY+e0jIJFbHpEvfLiKDuCibk7I9L66Fs9o3Ql/NImeHMHrI2yEkTokLOGzRBf0o0Bdjaw3gzAkzZkoO4ML8BexMiq89kvCUx7n71eHWGhAV4RYv4Yo+YmiKez5q8mGUaZwOnNnqQh0u4jSd5Pj5w1HVer3YL+swwdynOPXHBRnbhOOFTa8rSmC1fpmXHdZ85o7prSdldbZj8ifigz5OJfY1o4mBarPWGzqRjNjQaF+euYbalO1rGzHc8upTbCbzowLFMwgFH8WLvfxz/R6bCvR8ea2yfco3c5mJE791FFDXgj67pz7fBJnQmQNmEysj2NLfmfLht+Cp70xEwv7v0Nh1q9f+czFjINREiy2yhGJqhFU4EH69207SHJML+KBw0MIvHztijeR2crrqT01kmv9rP/MyWMMkYfAISXgqLed2ojsJgogyxsNH2BFsR55DBSxZYQXvq8Im57B6XCathiU4
 PHRBPK+s
 u9PYhE1V1X6KBttz5hjWWZ10UOhhb3QYGMxTDeBqREXSdgG4dHlnv4ZAXk1R7F9qr3X+sxcF6p09Z/ZXFlzYjpfY/gvIvgKWdca+ZmVaUuyZRBbe75wxqLTnzKcXEVQFy/8MsXJp6NC/KiIwl/ycuTDhgQpniQW3A/TKByQYZ1VgRZ06ct/e6B7t0yeIP/gAFybMah6UPJKZwhy6kmTgUFhBx7uqOUTavgXEM1+bEWCJCQ4ESBj7OtRJZjissUZp2r8nJn4iq0xXMSh8/UA/GheofEDSi6dSuldkrAkVKx5giZWoMDGTde1/zEwJYaYESbIsB8dLhOA3TldvzLm1K0a9nr3X2EjZLwqsLXFvtAwQTVxA2vqQccUtcxkxqX8MTxuQ/
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
[also build test ERROR on linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251215090419.174418-3-yanglincheng%40kylinos.cn
patch subject: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251222/202512221928.EnLvUgqT-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221928.EnLvUgqT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221928.EnLvUgqT-lkp@intel.com/

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

