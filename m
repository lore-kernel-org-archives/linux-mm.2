Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F64D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CFA6B008C; Tue, 16 Dec 2025 01:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C656B0093; Tue, 16 Dec 2025 01:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441C06B0095; Tue, 16 Dec 2025 01:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 347D96B008C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:32:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9DB5590C0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:32:22 +0000 (UTC)
X-FDA: 84224364924.13.D66559D
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id E2F7F40006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:32:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqWfDUFi;
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGRzWPEKfvmJEejOwoCNNsiv9yu7sGL4JB/S9GrfrcE=;
	b=FDn67YslsvIzdVfQwB4qiNmsfEKM9TsvqUr6leGJL0pan0YTjmvAGe99F4V1MHPi762yL/
	nBkKTaJ6Y6XYkUXABvE4hEC6UMsWyr2a+NVcRjF5Lx8P9iAEKJAK+kRShlnS3UThyZx9Cg
	02ikJXgZ0hgZTWQp7nLZ5v3rbZ9vmmQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866741; a=rsa-sha256;
	cv=none;
	b=KsuqtlQLViGvacm417lOjTkVLTSEY/iAeWXedCO/oZ+E3Y5Qfw9JZEu9BrYELYO/xbge0o
	+Y9u0mMhsBodhQxnLQ6cDtH8Xk3E2/+O/bNreu7043ybdLLxxH0VnECRHPMESiUkR9rQk+
	5gEU+XjOdQWiCcWQH/g9BPq7y0qhE2Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqWfDUFi;
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c2f335681so2363697a91.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765866740; x=1766471540; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AGRzWPEKfvmJEejOwoCNNsiv9yu7sGL4JB/S9GrfrcE=;
        b=XqWfDUFia/zb3hnMq6AfMqaSrrqQAeMxC2bjEYvx3W+vTgUw6AIdDEmFFpxJH6aJwm
         dEDX8mz4JJm0AETjCj7gjOiwBDIALXGEdymruy9H3k1xPXlBZ3xEU1qdUiTmKB7qMhvl
         yX05UAkE8bm7Svww70eWrPn7g4Tl5RDwv5U/mRFJZuqwi1s3SyJf2CG1KOaA3pCB1R7E
         tKrHU1LTVwtplDihEIFXoRXJ6hlT31t2T4tK9l/QPWV3sQBTEp0hqp3hevopT2ezb/2W
         3lMJRno+C1aiegRrGPAJfjoT99qpHSQe/pKZ0/sU1aYVCInB2dzyf987WTp0cZlYL7kI
         gR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765866740; x=1766471540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AGRzWPEKfvmJEejOwoCNNsiv9yu7sGL4JB/S9GrfrcE=;
        b=QoltxVXx6oYwz2jjBfjMA5I+qcahn8ckae9LGcfRMB6tsAT/XciiH3nr0C8VOtQjEZ
         RzzK/Z5fe5d667LrXO16FYefvpG46tTBZoKw5otTv4ON9fsDyMOMec9ZbPA1eP9SO16y
         spZlB+r4d+lBCGFpgSLYE5/KPeg7idxp6j2zysCGGSi65SyKc8ZjTTi9yLnpanEZL7mn
         XBw/ZRURirmoPiFzaldnaF/jC9ZYAz/HGZToc9G1ix/FYGMt2JA2SADccRQmLA7m4PKg
         FQXUys+baI618p8cKO/hGUkKC2JKKKYHnVp61uwsbSVCKVjT0DR4RkbXw8dXN5jq9kjh
         IapA==
X-Forwarded-Encrypted: i=1; AJvYcCUpjVMQRfnVVCjNxJdegqt+WPqYUmpmhF8R/Xhy//hcjAzAqz9WKvxNoYQJot5KPrlMTKB240NkmQ==@kvack.org
X-Gm-Message-State: AOJu0Ywt/KYzeAKxtg+jRvxemJzERWV82UZ6R0+cbO+vfNJ7qpHp5ZhI
	XDH0EfRu4brOIAB38oqUnIC5E/YDe9xT3ISWitMfebzyIttLLjbZkVdV
X-Gm-Gg: AY/fxX4GgiNuDvUvYEz4w4qbUgVs8eWY9jAQznvKuZLMWDq22whWmxLDUkx0JJuMuWg
	3+eojtzxjzSd4HBMDwtzNzTC2B8rdvWcwaEd+F+z+PzBsSL8dbgFhmsd1oSIeJOIqN8xCfT55sy
	MZLCrq5YlKYqW6jlWSUedzlaIboI4CvKqn/iXbfi/ZSavOfuf84iQbgALsZOef2Cb5XsUeihPRD
	Bml6psJ5sqYmgpSk68T64AS5poCmPGQuxbAwy2sGzqE8fhb0JCs6+mJpxt4hZOGpIXoSjyoVFKq
	BP0oSvxhukf+YVX0A1eQzx1LM+2fnZxgnNPHJg0ykG0kk8jmfvfWbP+KswAtZFcpbKPdHPRT7pN
	lcGUh/YHE8fepFbapaU5hSLK8r1zmX5PBb+7UN7s4y5VEegQlhGwTdK1qgfzJZdRECcDUD3++3v
	jZoKb6q4WqtGyGFsZwNnlRoK1Q
X-Google-Smtp-Source: AGHT+IH0RJh5kqJSJv790DptQ94gJw8dQltu7R6cFNQxP50wNZy+EDL8VlxiC3V8XcLubLzCcwnbYA==
X-Received: by 2002:a17:90b:3ec7:b0:34c:97ea:e4d with SMTP id 98e67ed59e1d1-34c97ea1008mr5248729a91.28.1765866739668;
        Mon, 15 Dec 2025 22:32:19 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe3a27b5sm10739839a91.1.2025.12.15.22.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 22:32:19 -0800 (PST)
Date: Tue, 16 Dec 2025 14:32:12 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <k4eiyf5cxqpv24n6l4v44zskxpgkmxpdmx7aunqna6c43iwvvo@hwxvwyvj73rb>
References: <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <202512160619.3Ut4sxaJ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202512160619.3Ut4sxaJ-lkp@intel.com>
X-Stat-Signature: eii7ddpiqhn4i1zadc6jifgk1e9nhajj
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2F7F40006
X-Rspam-User: 
X-HE-Tag: 1765866740-919582
X-HE-Meta: U2FsdGVkX18rwVSdhNyd0EXajac3bLx7m+JWO6w9ubcE+DFWPGD39kIE04IF8Um/ZIy3E9BDrsRbMeYcNUlWGyfzJRioB6YnPLd3d7TB2cUqSNOErCPoOX4qrVqzFnvkDFy61Qpp6YNKxutIlZbjL2oMqYjsZKvMLK8fT5FbBXupYw6T4d3VWfi/JfXslX784skVrUfdLfT4TbiqbtCAHjEM8Y2ANU0fXp/OgoYYLX/WKREUPdZJv+5k/DGhWxyRd6O+T7fvhU+ENTObD7WBY6ArAa7CjVjCF1Ww0auCH1RcjsAUgYB9lNqzP4nzZtA7GxWai0Yjk/mm27AiJvNmVAjn7uuGrUh4Nq60xtyhZgneD9uPcogIE8vPfVLFdPCnT92VrmPfhHAqpQLuyPhsL73MORt5IL7l562fdkUMhU1qwIpI2CaASRcOPSAk5jpQFRcfKgB6WkvBPbOPjL4pCMRzqBPAT07L8zm4KbuQYWW/eZ9kIVHZ6i+wFo0f3pykutlkjRPq2VE2HHLqIiM6QPAOu+zPQ74Z0wo0wrraPXDci/iI8yOfT1rZbut8hNdvbrjBe0Bp5FvrlHtKXxk7vJ+pHAtSgI5j47BFuVMdSgNXw2HC2F01UWTQG7vTA9DEsajE4FKUjlg8/P71rC6tzasau+ggmwnuP0/b55i/1O1itKvuPVzOf1HH+WWvLaWcynswr4UDP0HLcrzxFzVjuy+rEi2fpqGoav94PM00173xUJdD1VY7ZX95VL+yNvR+0mT1/HFELBrNbOnu28zrY+iTKC/qFVMUBZnImg7o6qkD5fxW8Z8OU05qWDazva6Aj02NsmL8fXKiTNDZcPZEKeXTxgkEeHxn2sazZDq6l2YEbuGJ/0S9LweLJDwVis7zvKRPwIExOoPC59h1BeKUJpxcY6JWuBbZ8PIVUo4rxQr81FAke2YOcXx0+Xbg+gHiFAdlq1dnp94Vicj43tg
 Dk+p+0Ju
 izLNPCkypuORKptWY/FxxsPc7A6hDG+ajahLTlMCVkhYifizLV3AZTCoPLo5ep3z5LDajxVtmMljTmahJd8izQIMUcnV7IZIyGQdqPiZ6wSFRIJcKkPQ275x9+ODuGgYv0qO6sySh5IPuuWGM76iFdSkFOmD/WjZhtO4f6y2+mCZCsFpeSruwLvf75RUJo2JaqOAQAbVW0kL/zr0agdl4oLjLlGCOjeXP79rA2Jc5F9/6l8G0jgqTAAnOxmttUm0IUNbEzHI7D7fDxKamZXfJQNtKyy9peBXxs4jA2HynT3uVlEJB2KI5c30yVR8fTZ4OLTs7IuP9EwXIJIU1EkEbeX1sQL05zHdWWc5Oc5sx6hK/xorwtjrNEPa2HjaOUd56nFPYIaxxKAI4etBJH+Dk+oAzWcu22XiSOe/muRQfbG3LsW4pAVVrET4fnGb3MGa83p1XkjIx62EhDjjzI9I6kwVCtsRD7j4dY/rLKFmYOBTl4P44l3M3VotLcl2/SGIyQylso06/TaoTc0PPS9AT0dAPkibm0sRWQ7z62fNKr1OqFcGdN2j9NhAa1X872Fz9P+KLh4AabDVAlteTGqr2gCjjbm6fNnWjKA3b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 07:01:18AM +0800, kernel test robot wrote:
> Hi Vernon,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.19-rc1 next-20251215]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251215090419.174418-3-yanglincheng%40kylinos.cn
> patch subject: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251216/202512160619.3Ut4sxaJ-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160619.3Ut4sxaJ-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512160619.3Ut4sxaJ-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/khugepaged.c: In function 'khugepaged_scan_mm_slot':
> >> mm/khugepaged.c:2490:30: error: 'SCAN_PMD_NULL' undeclared (first use in this function); did you mean 'SCAN_VMA_NULL'?
>     2490 |                         case SCAN_PMD_NULL:
>          |                              ^~~~~~~~~~~~~
>          |                              SCAN_VMA_NULL
>    mm/khugepaged.c:2490:30: note: each undeclared identifier is reported only once for each function it appears in
> >> mm/khugepaged.c:2491:30: error: 'SCAN_PMD_NONE' undeclared (first use in this function)
>     2491 |                         case SCAN_PMD_NONE:
>          |                              ^~~~~~~~~~~~~

same above, Thanks.

>
> vim +2490 mm/khugepaged.c
>
>   2392
>   2393	static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   2394						    struct collapse_control *cc)
>   2395		__releases(&khugepaged_mm_lock)
>   2396		__acquires(&khugepaged_mm_lock)
>   2397	{
>   2398		struct vma_iterator vmi;
>   2399		struct mm_slot *slot;
>   2400		struct mm_struct *mm;
>   2401		struct vm_area_struct *vma;
>   2402		int progress = 0;
>   2403
>   2404		VM_BUG_ON(!pages);
>   2405		lockdep_assert_held(&khugepaged_mm_lock);
>   2406		*result = SCAN_FAIL;
>   2407
>   2408		if (khugepaged_scan.mm_slot) {
>   2409			slot = khugepaged_scan.mm_slot;
>   2410		} else {
>   2411			slot = list_first_entry(&khugepaged_scan.mm_head,
>   2412					     struct mm_slot, mm_node);
>   2413			khugepaged_scan.address = 0;
>   2414			khugepaged_scan.mm_slot = slot;
>   2415			khugepaged_scan.maybe_collapse = false;
>   2416		}
>   2417		spin_unlock(&khugepaged_mm_lock);
>   2418
>   2419		mm = slot->mm;
>   2420		/*
>   2421		 * Don't wait for semaphore (to avoid long wait times).  Just move to
>   2422		 * the next mm on the list.
>   2423		 */
>   2424		vma = NULL;
>   2425		if (unlikely(!mmap_read_trylock(mm)))
>   2426			goto breakouterloop_mmap_lock;
>   2427
>   2428		progress++;
>   2429		if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>   2430			goto breakouterloop;
>   2431
>   2432		vma_iter_init(&vmi, mm, khugepaged_scan.address);
>   2433		for_each_vma(vmi, vma) {
>   2434			unsigned long hstart, hend;
>   2435
>   2436			cond_resched();
>   2437			if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>   2438				progress++;
>   2439				break;
>   2440			}
>   2441			if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>   2442	skip:
>   2443				progress++;
>   2444				continue;
>   2445			}
>   2446			hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>   2447			hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>   2448			if (khugepaged_scan.address > hend)
>   2449				goto skip;
>   2450			if (khugepaged_scan.address < hstart)
>   2451				khugepaged_scan.address = hstart;
>   2452			VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
>   2453
>   2454			while (khugepaged_scan.address < hend) {
>   2455				bool mmap_locked = true;
>   2456
>   2457				cond_resched();
>   2458				if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>   2459					goto breakouterloop;
>   2460
>   2461				VM_BUG_ON(khugepaged_scan.address < hstart ||
>   2462					  khugepaged_scan.address + HPAGE_PMD_SIZE >
>   2463					  hend);
>   2464				if (!vma_is_anonymous(vma)) {
>   2465					struct file *file = get_file(vma->vm_file);
>   2466					pgoff_t pgoff = linear_page_index(vma,
>   2467							khugepaged_scan.address);
>   2468
>   2469					mmap_read_unlock(mm);
>   2470					mmap_locked = false;
>   2471					*result = hpage_collapse_scan_file(mm,
>   2472						khugepaged_scan.address, file, pgoff, cc);
>   2473					fput(file);
>   2474					if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>   2475						mmap_read_lock(mm);
>   2476						if (hpage_collapse_test_exit_or_disable(mm))
>   2477							goto breakouterloop;
>   2478						*result = collapse_pte_mapped_thp(mm,
>   2479							khugepaged_scan.address, false);
>   2480						if (*result == SCAN_PMD_MAPPED)
>   2481							*result = SCAN_SUCCEED;
>   2482						mmap_read_unlock(mm);
>   2483					}
>   2484				} else {
>   2485					*result = hpage_collapse_scan_pmd(mm, vma,
>   2486						khugepaged_scan.address, &mmap_locked, cc);
>   2487				}
>   2488
>   2489				switch (*result) {
> > 2490				case SCAN_PMD_NULL:
> > 2491				case SCAN_PMD_NONE:
>   2492				case SCAN_PMD_MAPPED:
>   2493				case SCAN_PTE_MAPPED_HUGEPAGE:
>   2494					break;
>   2495				case SCAN_SUCCEED:
>   2496					++khugepaged_pages_collapsed;
>   2497					fallthrough;
>   2498				default:
>   2499					khugepaged_scan.maybe_collapse = true;
>   2500				}
>   2501
>   2502				/* move to next address */
>   2503				khugepaged_scan.address += HPAGE_PMD_SIZE;
>   2504				progress += HPAGE_PMD_NR;
>   2505				if (!mmap_locked)
>   2506					/*
>   2507					 * We released mmap_lock so break loop.  Note
>   2508					 * that we drop mmap_lock before all hugepage
>   2509					 * allocations, so if allocation fails, we are
>   2510					 * guaranteed to break here and report the
>   2511					 * correct result back to caller.
>   2512					 */
>   2513					goto breakouterloop_mmap_lock;
>   2514				if (progress >= pages)
>   2515					goto breakouterloop;
>   2516			}
>   2517		}
>   2518	breakouterloop:
>   2519		mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
>   2520	breakouterloop_mmap_lock:
>   2521
>   2522		spin_lock(&khugepaged_mm_lock);
>   2523		VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>   2524		/*
>   2525		 * Release the current mm_slot if this mm is about to die, or
>   2526		 * if we scanned all vmas of this mm.
>   2527		 */
>   2528		if (hpage_collapse_test_exit(mm) || !vma) {
>   2529			bool maybe_collapse = khugepaged_scan.maybe_collapse;
>   2530
>   2531			if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
>   2532				maybe_collapse = true;
>   2533
>   2534			/*
>   2535			 * Make sure that if mm_users is reaching zero while
>   2536			 * khugepaged runs here, khugepaged_exit will find
>   2537			 * mm_slot not pointing to the exiting mm.
>   2538			 */
>   2539			if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>   2540				khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>   2541				khugepaged_scan.address = 0;
>   2542				khugepaged_scan.maybe_collapse = false;
>   2543			} else {
>   2544				khugepaged_scan.mm_slot = NULL;
>   2545				khugepaged_full_scans++;
>   2546			}
>   2547
>   2548			collect_mm_slot(slot, maybe_collapse);
>   2549		}
>   2550
>   2551		trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
>   2552
>   2553		return progress;
>   2554	}
>   2555
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--
Thanks,
Vernon

