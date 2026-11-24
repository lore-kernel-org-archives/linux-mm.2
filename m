Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75673606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LBnu8YYw
Received: by kanga.kvack.org (Postfix)
	id 93E566B062F; Tue, 24 Nov 2026 03:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914A66B0631; Tue, 24 Nov 2026 03:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851896B0632; Tue, 24 Nov 2026 03:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC066B062F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:12:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EE1F1A0A61
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:12:46 +0000 (UTC)
X-FDA: 85469296332.22.939550D
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4CFC9C000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:12:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBnu8YYw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507964;
	b=bTHDlwqCZyM01B4xKtHfxJ3LaAxeEIWUiApUUAUA1k8T34mc4mXNCtrDaNpPPzPdgNiBnq
	fUYM/SMklDLfaUIZVt9dQDyHn8XQhshPv9gJxzwz0QHCQUlv9jW5Aa1lS/Hyt10HVO6ePQ
	BaDGrQPFYzKBp4RjWW/grZSf7P259AM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9v/aquPA29KXdA96PEW/4XyKP1194pH+JbPW+CE9BhA=;
	b=SOsREnZbcX8/sKZ/YYv6AahojlHc5rHYez67hvt7TVWFFMNj6KXFsalGQsneEsraT6HuOy
	Db82G/NWjonEeFxC+ZoDmcmUL28R/LMQtiyP/DXGFVxzjZE78HVJ3VcQSeSFnoVH9e1LZ6
	g/xK9gVelPQySfi0AHXprgmzzdLjZLM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBnu8YYw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kfJ4WtKy7pZ4fGs2zEWka3cP1XCH3IaMwALqV+AeTpM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795507962; v=1; x=1796112762;
 b=LBnu8YYweN6gPg5w0MqZtOQi34gJYQE1f/pekFwWo68fLWZOAM9TeO4o6kJlgpjazZqEi+NZ
 5UTJxwZ0uav+MeXz6HYDTqVyguceNx6jEBp1SWik+MtBtOIZ7CO7CCkcH34i/ca3lZ0syAQFyoL
 xYrLTEq+pOjpNKZ5HWfPBR+s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6c42f0ddf956d8ce;
	Tue, 24 Nov 2026 08:12:42 +0000
X-Mizu-Trace-ID: 6c42f0ddf956d8ce
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 16:12:30 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <awVGycKHzXzW5OF1@bogon>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
 <20261120085806.781225-4-baoquan.he@linux.dev>
 <sashiko-outbox-226850@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-226850@kernel.org>
X-Rspamd-Queue-Id: 4CFC9C000A
X-Stat-Signature: m779hgod6m5ewmun3mco3mcqufmd61on
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795507964-538604
X-HE-Meta: U2FsdGVkX19dCdCmr2iXh3pPlW2zbEQ2ZGD1gioqMCUzPiBMEsu/t9dLLhnvmm3+KhmI5ftCfXpB92VDAXSdPmHIkud9Ws47c2tJNUImTh/d0rk6GWB0g1L2o1Z+zX/Wj1kEsFmjMWC0yOtwPPUPiZ+vj9z9iMnk4qdQyYdOg/ZEg2es0J9FWs1zRPy7Mg0BtilEhXEFMoZXRMfUx8vZDdNgsjqgLXUREzqqaRA1Y/nt9FP26HVn2ZJsbnCbKf2Qlq7d2iw//swhGj0q86IkwhlGHI/tkx1Q6LINXcvaLvNUpiSZNB+63o77fra/bUoQaEPhbBhAWumqSUXxIMEusuM7f8VsWgwYJpzfMmIYU0D1zDh8b6gtntWx9M3WtirbxE3LH7ZfMpXyPrDaALqdMDH7/jiTNLrEnyvgimKAtLQZmYXtlvKjyPAsoolEiCg2pwPquIO84XsC4xwkm2AxwL8VKcX8yp1DT51cLKMtqGpTdMsPgdNEy3PZVXufWxyUy+A0KSdpyZ/VHgMyUp5ukKzRggziO7lz/WCEPixCDIGI/VIBqOfTVSEhsnqAVMRgYGisk9uTEfDVjx5U5RAKxzj+jqnPOYDqwD/lsutdNOXn98SG1U8Lmpp1hOJ07YhbZ9mZcWpKYKUqdZ3IMco/3cZcPrQ1fyh7ms4reIB5eKxcSKigkckxIo/DrL4s9JX7F3YWVIDBdNcBNRokwnjHK+Z6lorU4Hq2AVCJlkKxE2rDEgUCewD4VEr5HkXgL/AnhvPJigcnceJdiZioIpChFAxBDq5bkMGXBh1w6NWvoc73jM0qz8czS1KoECMz3HeETnQIczmm9TtZ0m4Zl1cVs68FxkW0gCy5C7z3IFGuEYPVL2y7xG7rSOinZZSSJjiEodMgqcPx8Jt/BiviZwvb0BzBV2u620zHaNwa8ebowEFJwW2ZSokFxQCqdbbp6MkX0w+11R4w/ClPaglFLCh
 mqfivnxD
 SO/GyX4FYdsKQhtgh0/JuGZRK1kxuu6vrdJdQSis0QXARJdiMiZS6UXlNVbUhmq4QcDiNUN5cu/TJES5WNQstWScxE55ShtkzeyVpCM4odD4h/U2FGHVjnmmXkrvmTHpLTjTbft+eYJe5Es/kEAoGLV10mfdG+WtXKgZCZI4LoMtobUjsQ0gRG3Zos70XtRhhjaoCO/ANyaFSuBQTf6Yp0tbME9HnYjDj7TkHvgXelbOdi6kLsgYGL2eIDcWAwLgMjS790D8qgberR6C2tHHoc3PoFL+wPT0ZzXx9zlxlrS9nmeSqSlMCMHW/R9205T+h+R/u7x6R6LdenKBWiKZrhvr8dQ0+VWy+OZ4c/vwCWad8OLy3EtOk1XF1ZWCFflYm4Dv5LB3Yx/CB4brsXws42Pf6f5x3p5Q51zKe30G/sIviZJr+zc16WGOUfeoFyv2sn11ga5j2FZT50yr4CNk+NtF0LcFQgC0yXQnMgpMwUP/WQSlKdk1sFOvFvWlzY4lxHGg+t/KKuqNkMc0zq5Q9fGZWN9Lfxni+N6vZjgyQ6CZ0ANhe3OUnU1/z7kOotPrOUvhWI525Oe/CT0gCdnJma/tAYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 at 08:59am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: walk_pmd_range() drops young status of THPs flushed
>   at non-leaf PMD
> --
> 
> commit 807f1bc14298f872f3bf880156eb7f9c34a7f570
> Author: Baoquan He <hebaoquan@kylinos.cn>
> 
> mm/mglru: skip cold PUD subtrees during aging
> 
> This commit introduces a PUD-level Bloom filter to MGLRU page table aging
> to skip 1 GiB PUD subtrees that had no young pages in the previous
> generation, while updating the filter from the page table walk and rmap
> feedback paths.
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a4c64a1903912..2cd3f28f74288 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -3626,11 +3637,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
> >  	return suitable_to_scan(total, young);
> >  }
> >  
> > -static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
> > +static bool walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
> >  				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
> >  {
> >  	int i;
> >  	bool dirty;
> > +	bool young = false;
> >  	pmd_t *pmd;
> >  	spinlock_t *ptl;
> >  	struct folio *last = NULL;
> > @@ -3644,13 +3656,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
> >  	if (*first == -1) {
> >  		*first = addr;
> >  		bitmap_zero(bitmap, MIN_LRU_BATCH);
> > -		return;
> > +		return false;
> >  	}
> >  
> >  	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
> >  	if (i && i <= MIN_LRU_BATCH) {
> >  		__set_bit(i - 1, bitmap);
> > -		return;
> > +		return false;
> >  	}
> [ ... ]
> > @@ -3755,7 +3771,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			walk->mm_stats[MM_LEAF_TOTAL]++;
> >  
> >  			if (pfn != -1)
> > -				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > +				young |= walk_pmd_range_locked(pud, addr, vma, args,
> > +							       bitmap, &first);
> >  			continue;
> >  		}
> >  
> > @@ -3777,15 +3794,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			continue;
> >  
> >  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> > +		young = true;
> >  
> >  		/* carry over to the next generation */
> >  		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
> >  	}
> >  
> > -	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> > +	young |= walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> 
> [Severity: Medium]
> Can walk_pmd_range() drop the young return value when batched transparent
> huge pages are flushed at a non-leaf PMD?

This is a real issue even though very corner case. I thought it won't
happen when making v5, but I was wrong. It happens when all below three
conditions are met:

1. at least one huge page whose folio is in this lruvec is queued in the
   batch, and it is young;
2. the call that crosses the MIN_LRU_BATCH boundary comes from the
   non-leaf branch, i.e. the PMD 64+ entries after *first is a page table
   with its accessed bit set;
3. no other PMD of this PUD sets young on its own, neither before nor
   after that PMD.

Fix is quite simple, take the returned value to assign to you too for
non-leaf PMD. This will be done in the coming v6.

> 
> mm/vmscan.c:walk_pmd_range() {
>     ...
> 		if (!walk->force_scan && should_clear_pmd_young() &&
> 		    !mm_has_notifiers(args->mm)) {
> 			if (!pmd_young(val))
> 				continue;
> 
> 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> 		}
>     ...
> }
> 
> walk_pmd_range_locked() buffers up to 1 + MIN_LRU_BATCH entries in first
> and bitmap across loop iterations, returning false while buffering.  If
> earlier iterations queued PMD-mapped THPs and this non-leaf PMD call lies
> more than MIN_LRU_BATCH entries past first, it flushes those THPs and
> resets first to -1, but its return value is ignored.  If no later PMD in
> the PUD sets young, walk_pmd_range() returns false and walk_pud_range()
> leaves the PUD out of BLOOM_FILTER_PUD, skipping the 1 GiB subtree on the
> next aging pass.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261120085806.781225-1-baoquan.he@linux.dev?part=3

