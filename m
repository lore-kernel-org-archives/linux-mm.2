Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D4F606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pLjM4hBp
Received: by kanga.kvack.org (Postfix)
	id 3CADE6B0643; Tue, 24 Nov 2026 03:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C166B0645; Tue, 24 Nov 2026 03:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8186B0646; Tue, 24 Nov 2026 03:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F29A06B0643
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:34:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA0CC14097E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:34:26 +0000 (UTC)
X-FDA: 85469350932.03.53753B9
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89C34180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:34:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLjM4hBp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795509265;
	b=o+Za/HwdFEMhlg45D10p7mcow2//mV5a7iC+zLTW/Ny6DedCZ5pvjEF12v/XqO5TlgG7qo
	kmkVNqPSL4mG6CASH8HnvGEAKATR6PGAfU+UeLWzGyj7t4lvGCx9o3HGe7vNbQYlLxNXxx
	Mtv3TmjGfb6/6OlZbSWJCdxAwiQ+ggY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795509265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiVmxcFE4X1AS/dj3Y+jSeRqEGkTDYD4KqKrXIC4USs=;
	b=On4YSmbX4J+SkZUynPptEd5w+OLyRPF69de15SsnDgTK0CoYE07Y0Be+6jNQbQGWwFzChA
	QrYiuhNQx59gjlns5ucHIV6HFjW0J3eWkpxa0Nk15yCmC80U5PblLTOy7xtcxY1kDqetBE
	xlFTKPMNt2YniJ40q1SVKaXIjg+/S7Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLjM4hBp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5JJmSg68DrRJ70easqv1Ad4WfbubqNBenKyplETxRFc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795509263; v=1; x=1796114063;
 b=pLjM4hBpAwJL6xEzflMFy9VQHWAJEMEgDKCr0yoCRmdJ/6Ns/daVkfsiY27OU+QvITqhbrYx
 zbH1y/eD/pgkp24dDFcTkZnjkqNYPVVNiMLYdSII5s9HdJTGpMmuq4xZ3L6DSsU090A3e2Pz8gB
 /7q/C0KSSbwuOo8aI7wCQrPI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e39605e69979267c;
	Tue, 24 Nov 2026 08:34:23 +0000
X-Mizu-Trace-ID: e39605e69979267c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 16:34:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <awVL_81P_oujI3Ct@bogon>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
 <20261120085806.781225-4-baoquan.he@linux.dev>
 <sashiko-outbox-226850@kernel.org>
 <awVGycKHzXzW5OF1@bogon>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awVGycKHzXzW5OF1@bogon>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 89C34180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rr55wntkfdyk1qi6wz6cnc99dzup9haf
X-HE-Tag: 1795509264-523361
X-HE-Meta: U2FsdGVkX18WxNvWadWs5D0aJFwRY7FT8aSJD7Szcnv3he7XmH3yWp8gTww5rrP7eCPEhMKa8oj8LUAYpgafydSlpWJZdB2bBCdvHCFqKkaBBOgAqs1X/5TVuoFlj0UmRn6RQw6gwDuZika5kuCnQAbnf19aogyudRUGhsPOjgTLB6m33vxB/vUO2wK/s5+HrQEsVHi5t3HapllmFiTyYrMHoP2p6CQCybUftZXuJAL1Od6JdbR+PbcwruQF9xPdigF2jgdw7kzgafCzB8pi+rl7grdx8eQ3PT+oZdcB2ROr9EuG/GLRuced3unaTnEyrFcjcOvKIGQmTyca3+Gjah5dTyM/xLL5QcROz9gm3r2K+qFetewUVXZe+VidnutKemxRSGcuo6pC5v26qYBTTavyucvLHznE7WizBE55AScAN9OaoKYypjY6qWsnD8KRO7toz71SUZfWhF6EwaXZ8C8W3iosXpR2VJlgBI3B7KQrHZOEGNSB199vVB5NfcSUp9dkpbtZqWNb/Iq1cYGiYC/E7BiuQ+YCW1VwR6pa01MnO7SJkmhyPyeqo9JAh52wNHRYnKAyH0jJJHK+BDViJOZs7y7FJhXAZOdMH4jJPZqEslz4km+LIkEeI83Um3jCKjDCjr3YGziq6I4UrvxLIPF1VRsgnvlUmx2g9HAW4Ro5isUhjv5tUqwsVlAttEy7MnOTli9+HSYzNOCiSyqfFaj79pQ00qsErADrCHj8YUaAe6inBb1IyT2yLKh95/2xJtSzT43aUaDLz6dig4UQEWdKcEEZlfttEJo8DVP2V8GaYdb87JpPsFkUN9lYce/12zYcSZXr1AVl08ifPddZ3d6f+WcDkCxHH0qBBLL4qnLz8CEuwxJSjTCGZAPHofd+R/WsTPhzv8aEsa00zOemjTyMP08VUJEiwQOBSTQgb5gZUHvrO7r6WqHFXILuETgr1JpC7yxneYylq3UgSg2
 Jp3zCTup
 JcdaKlPzmNXO1kHUJvhzd5p/QwgvkJQ4PeSLSkz4PBbWFAS6Iv4ljPH+xVufoN2YeHVMKADlGKWslPYX/VG6evQb5orvRRczBeMSsAY1oOiP3nOLoksTyFrBwYk3FePTJhRfd37jAzUKhjqMHtp4oRes2oisuoYmr5Au3GzMl6I3R365bwCvMeC2zPZsNIQ5au3tcvCPu6AWHHvhVqArVn4vxI+8us8ERFKjo/GgDfa16p+vVtgCwNkRfRMhFsJTHOvxWiY58yhgdxSWAhyxrIO+9EAIXyCMTKbZqGBe9vx+f6VRQSn94VHBFW91GFIVka+IoIHIBDVoLelPCz5WCjslkbKTMh0madSMEmmmp4ysrkZA3yfmrNAae5rz2edY41iKQdTfHvInB9FfmfH9YhAr8r+sxVJz7kYTIaoOQpZ65KEPWqLpbTqGI7wwT1XCQFMSOLhF08rLZ52KwHDpcFCRqmTMshzLdjUXlcpmooKbqvjaqNU6zQcYHoxSasAb129aZa7V9hDhe64MbQy9ouaH1nbEFmTkQv3geTP/6s+5vB/Ra7csB1If3nxqSXnB1E7wlzTsHBZhcNUrhc6eUu8OfDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 at 04:12pm, Baoquan He wrote:
> On 11/21/26 at 08:59am, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [Medium] mm/mglru: walk_pmd_range() drops young status of THPs flushed
> >   at non-leaf PMD
> > --
> > 
> > commit 807f1bc14298f872f3bf880156eb7f9c34a7f570
> > Author: Baoquan He <hebaoquan@kylinos.cn>
> > 
> > mm/mglru: skip cold PUD subtrees during aging
> > 
> > This commit introduces a PUD-level Bloom filter to MGLRU page table aging
> > to skip 1 GiB PUD subtrees that had no young pages in the previous
> > generation, while updating the filter from the page table walk and rmap
> > feedback paths.
> > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index a4c64a1903912..2cd3f28f74288 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > [ ... ]
> > > @@ -3626,11 +3637,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
> > >  	return suitable_to_scan(total, young);
> > >  }
> > >  
> > > -static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
> > > +static bool walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
> > >  				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
> > >  {
> > >  	int i;
> > >  	bool dirty;
> > > +	bool young = false;
> > >  	pmd_t *pmd;
> > >  	spinlock_t *ptl;
> > >  	struct folio *last = NULL;
> > > @@ -3644,13 +3656,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
> > >  	if (*first == -1) {
> > >  		*first = addr;
> > >  		bitmap_zero(bitmap, MIN_LRU_BATCH);
> > > -		return;
> > > +		return false;
> > >  	}
> > >  
> > >  	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
> > >  	if (i && i <= MIN_LRU_BATCH) {
> > >  		__set_bit(i - 1, bitmap);
> > > -		return;
> > > +		return false;
> > >  	}
> > [ ... ]
> > > @@ -3755,7 +3771,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> > >  			walk->mm_stats[MM_LEAF_TOTAL]++;
> > >  
> > >  			if (pfn != -1)
> > > -				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > > +				young |= walk_pmd_range_locked(pud, addr, vma, args,
> > > +							       bitmap, &first);
> > >  			continue;
> > >  		}
> > >  
> > > @@ -3777,15 +3794,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> > >  			continue;
> > >  
> > >  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> > > +		young = true;
> > >  
> > >  		/* carry over to the next generation */
> > >  		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
> > >  	}
> > >  
> > > -	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> > > +	young |= walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> > 
> > [Severity: Medium]
> > Can walk_pmd_range() drop the young return value when batched transparent
> > huge pages are flushed at a non-leaf PMD?
> 
> This is a real issue even though very corner case. I thought it won't
> happen when making v5, but I was wrong. It happens when all below three
> conditions are met:
> 
> 1. at least one huge page whose folio is in this lruvec is queued in the
>    batch, and it is young;
> 2. the call that crosses the MIN_LRU_BATCH boundary comes from the
>    non-leaf branch, i.e. the PMD 64+ entries after *first is a page table
>    with its accessed bit set;
> 3. no other PMD of this PUD sets young on its own, neither before nor
>    after that PMD.
> 
> Fix is quite simple, take the returned value to assign to you too for
                                                            ~~^
                                                           typo s/you/young/
> non-leaf PMD. This will be done in the coming v6.
> 
> > 
> > mm/vmscan.c:walk_pmd_range() {
> >     ...
> > 		if (!walk->force_scan && should_clear_pmd_young() &&
> > 		    !mm_has_notifiers(args->mm)) {
> > 			if (!pmd_young(val))
> > 				continue;
> > 
> > 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > 		}
> >     ...
> > }
> > 
> > walk_pmd_range_locked() buffers up to 1 + MIN_LRU_BATCH entries in first
> > and bitmap across loop iterations, returning false while buffering.  If
> > earlier iterations queued PMD-mapped THPs and this non-leaf PMD call lies
> > more than MIN_LRU_BATCH entries past first, it flushes those THPs and
> > resets first to -1, but its return value is ignored.  If no later PMD in
> > the PUD sets young, walk_pmd_range() returns false and walk_pud_range()
> > leaves the PUD out of BLOOM_FILTER_PUD, skipping the 1 GiB subtree on the
> > next aging pass.
> > 
> > -- 
> > Sashiko AI review · https://sashiko.dev/#/patchset/20261120085806.781225-1-baoquan.he@linux.dev?part=3

