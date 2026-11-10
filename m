Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CACB606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQBitt5s
Received: by kanga.kvack.org (Postfix)
	id 142726B05C1; Tue, 10 Nov 2026 12:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119ED6B05C2; Tue, 10 Nov 2026 12:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FD66B05C3; Tue, 10 Nov 2026 12:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD6FE6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:05:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60BD7160997
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:05:09 +0000 (UTC)
X-FDA: 85419834738.02.6B60309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8EB1A40007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:05:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQBitt5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5OK7L+XHYDyvpdUN7iinyt/hLzBrVtJ/Mqo1j/GW2Q=;
	b=BrzPeNXhiKqU0x8/ywAZXVD4NsMLuYWAu1mcUPXAG4puIEfLr2Z5aWlK86KtMukuhd8wmh
	KoRW5+c5sgIO7OqcKISz30FyQnm3EJVHAlvySTxoz92qS/qDKSOvzFpKdwGxQvWduALcRa
	4kOWGvJulxq+cQJRurTZjX+SLI51mxE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQBitt5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330307;
	b=l6aLu58/pFNEOjqlrxGU68lbAqYe6Kgni3zW8xAgxsgDm3YiEKfyjE0xJvoVFPvh/yaqjT
	owVgIeRduMXC907yCrKXyDBn7toC5StOWRF7fEN6LvGGOK/VpfvYOKh7FyXYVa3NwcQOAd
	AaeFphDoe4E7YcRfXqwU5Ays8QhDCxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00C00612A5;
	Tue, 10 Nov 2026 17:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E61F0089F;
	Tue, 10 Nov 2026 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330306;
	bh=w5OK7L+XHYDyvpdUN7iinyt/hLzBrVtJ/Mqo1j/GW2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZQBitt5sjfK1x5mRbZ5LvBWqcEfWKKg2fwb/9fJFUVZkbWg9OQRzlp6S2u+Vof+wP
	 yRDyF9oMqKClI3QjvNbIpy03NMhhwC3N+yQyPoWKlDZg8FyzuCqcdje4b621f/LaIt
	 KBo3XKV3N3JS1l9RGDkIq6PkP2RjNNvMeeLWZOjEnH7QAn0fRENuEsp066FRlpsWUI
	 UQJnQyHwWbWJsYL4UffzXtXZnhlhctdCgLELWIgk0E6NWXTkC1uffkngQJ/E3dhj6p
	 kfEcs1Mxu1lSXXD8cZfC+0/xc4IR4kwOrpWCkBGGRjv1NiITlmwzRBMOndSt/0Tlkb
	 2FKVndk9ce78g==
Date: Tue, 10 Nov 2026 17:05:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <avNOl0O5C9KW5R_3@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <sashiko-outbox-202266@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-202266@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8EB1A40007
X-Stat-Signature: u38shsj1irykc3fudiqeipwc18xsxadq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794330307-488860
X-HE-Meta: U2FsdGVkX1+Jl+XQV4U70Y0ND/Vze757OJj1q+0FZLrFSpXGsjxKTwtZkf5j4nIvaVxwPu4aJPQoJWQKYKbRw4sBZ+LMvDGnOAkeGYC7w5viTGLq/30ltOPi3zpR24YIpJ3aek+v3d01Cxp+EHBFDM/IXtpdWU8ME6LWPJU+TJ/QY9UHpkSrZlgFTD4T05LTME38XETPnbGIn2cnThwB4QftmmWJYgFV3cby1fn3MyktEmvC1Fsqek7s1JxsuT7gV4pl/jEfiPt+cQIIYnu79QvlqA8xkCEaiw1xeXNrjTm6lpLtj1AKXbTBZTdl7zdgRoL8PyhleGdGwr03x6t3og0R+SGtrGAHL1uG/MVhZFZKM/b9ea78cKoMHBIEKflAnOXlWY4Juu4jcxuJZ90bMvZhYuLesjk+nfVTlpCpa67SUmR2pukAjboAnhTgmZd9fUR3dsWYa1xkFgfw7REmwAk3j67JFwmLdxcDtxoFoDj1FXfjJ/veieIDc3SBwg9BTB+yd2G/esZfPU2AIpsZE9CM9UefMgusEAHOtTgAhBTL24KDhTp/JuhJCDuaWNdWd41sRdJirtRZ7Yvh+2yYHOMWYwCQt1fxlXarZVd/bgfrFbzuVUSg7pd8/fTkOb+/8v0eYsm2cpZy2C5RF7baeNovlptxOdSxGPbfvVaRtL9wrc9PptAd9hPjnTqLe29rtmCbsojVYRKMl4iBSrSVRyb/R5jjI0v/nXumu+RWhX5xkf7If4IlzFcRLC83KfBrEZaE2v9cS1AuQkTsU+goANOxGh72yA+8aRxaT08c8eRX1Jnyodd5LgPM16o4KbBN7DSI4Dj1ocWUs50dsFJWSmDyi/IMWmgcTBPenb78j1+3MFcwjD4+fM2hZVUEtEZy96xdSmbI7G0xfxWmrcFgeHrVXlNlJ6Uoc0tGmbNYK83RBU7BXJMeFytkujSONCspRTrmxwhiBOscTt9Okod
 gTXvmhOk
 8TSqsja/MmX5IeczjpOBE466zePZ9KG5wgeNIGTA+Nqa0Sl8ciwnUK2Z7cTm+PlHL8/JBZTHso9/EgXaJRSlu3IWu2M0vrCEoIM7DbGtu3px1a4iF8OFwQJFFFnlPOtTcKdPMDeYyVGbyUO+IG3Uhe6OxKzxqPA8YAayIRMKP0kmMNrht+t31z0wWSUJ/bSj+tsTjMwYcJ70EER6hvKkdm2+nOjXaY4BZ+4iB5ickLXXxSmJYOSRc2i/Y9lZTZT30VqgZG6zsqhHeP1xtLOn7ieMWXitnEMDLcOIiVmiaRTcYh5zmwENmZWYaxEHBV3wKYfJY82tLqH+54TG9Jw3+BPAvMjv2HgYO+yWvwcuSTnRehU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 08:58:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [High] mm/khugepaged: lack of forward progress in
>   collapse_scan_mm_slot()
> - [Medium] mm/khugepaged: sub-PMD mTHP VMAs bypass cursor advance and
>   overflow check
> --
>
> commit 9bc41c7859cdd4759479e883a9c557ea64a1a2c7
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> mm/khugepaged: release contended mmap read lock after scanning enough VMAs
>
> This commit periodically checks whether mmap_lock is contended in
> collapse_scan_mm_slot() after scanning a batch of VMAs, dropping and
> re-acquiring the read lock and resetting the VMA iterator to
> mm_slot->address. It also checks for unsigned long overflow when aligning
> vma->vm_end for ineligible VMAs.
>
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 216c4b8d28c40..eaa01dae5a030 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +/*
> > + * The number of VMAs to walk before checking for, and relieving, mmap lock
> > + * contention, as a function of the pages_to_scan budget.
> > + */
> > +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / 4)
> > +
> >  /**
> >   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> >   * @slot: hash lookup from mm to mm_slot
> > @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >  	struct mm_struct *mm;
> >  	struct vm_area_struct *vma;
> >  	unsigned int progress_prev = cc->progress;
> > +	unsigned int nr_vmas_batch = 0;
> >
> >  	lockdep_assert_held(&khugepaged_mm_lock);
> >  	*result = SCAN_FAIL;
> > @@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >  	for_each_vma(vmi, vma) {
> >  		unsigned long hstart, hend;
> >
> > +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> > +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
> > +			nr_vmas_batch = 0;
> > +			if (mmap_lock_is_contended(mm)) {
> > +				mmap_read_unlock(mm);
> > +				cond_resched();
> > +				mmap_read_lock(mm);
> > +				vma_iter_set(&vmi, mm_slot->address);
> > +				continue;
> > +			}
> > +		}
>
> [Severity: High]
> Can collapse_scan_mm_slot() fail to make forward progress here when
> mmap_lock is contended?
>
> In pages_to_scan_store(), khugepaged_pages_to_scan can be set to any positive
> value:
>
> mm/khugepaged.c:pages_to_scan_store() {
> 	err = kstrtouint(buf, 10, &pages);
> 	if (err || !pages)
> 		return -EINVAL;
>
> 	khugepaged_pages_to_scan = pages;
> }
>
> When khugepaged_pages_to_scan (passed as progress_max) is 1, 2, or 3,
> KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max) evaluates to 0. Because the batch
> check runs at the top of the for_each_vma() loop before
> collapse_test_exit_or_disable(mm) or any VMA handling, nr_vmas_batch++ >= 0
> triggers on the first VMA before any VMA is scanned. If mmap_lock_is_contended()
> is true, it resets nr_vmas_batch to 0, drops and re-acquires mmap_read_lock(mm),
> rewinds vmi to the unchanged mm_slot->address, and executes continue without
> advancing mm_slot->address, incrementing cc->progress, or checking
> collapse_test_exit_or_disable(mm).
>
> Even when progress_max >= 4, for an eligible VMA whose vm_end is not aligned
> to HPAGE_PMD_SIZE:
>
> mm/khugepaged.c:collapse_scan_mm_slot() {
> 		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
> 		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
> 		if (mm_slot->address > hend) {
> 			cc->progress++;
> 			continue;
> 		}
> 		if (mm_slot->address < hstart)
> 			mm_slot->address = hstart;
> 		...
> 		while (mm_slot->address < hend) {
> 			...
> 			mm_slot->address += HPAGE_PMD_SIZE;
> 			...
> 		}
> }
>
> Once the inner loop finishes (or if hstart == hend), mm_slot->address is left
> at hend, which is less than vma->vm_end and still lies inside that VMA. If the
> batch contention check triggers at the start of the next VMA (for example when
> progress_max is 4..7 so the batch threshold is 1), vma_iter_set(&vmi,
> mm_slot->address) rewinds the iterator back to the previous VMA where
> mm_slot->address == hend, which then does no work and neither advances
> mm_slot->address nor increments cc->progress.
>
> > +
> >  		cond_resched();
> >  		if (unlikely(collapse_test_exit_or_disable(mm))) {
> >  			cc->progress++;
> >  			break;
> >  		}
> >  		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> > -			/* Unable to collapse, skip to the next candidate. */
> > -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +			const unsigned long next =
> > +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +
> >  			cc->progress++;
> > +			/* Check for overflow. */
> > +			if (unlikely(next < vma->vm_end)) {
> > +				vma = NULL;
> > +				break;
> > +			}
> > +			/* Unable to collapse, skip to the next candidate. */
> > +			mm_slot->address = next;
> >  			continue;
> >  		}
> >  		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
>

This is already addressed in newer revision.

> [Severity: Medium]
> As reported by Sashiko on v1 [1], what happens if an anonymous VMA does not
> span a full PMD (so hstart >= hend), but sub-PMD anonymous mTHP orders are
> enabled?
>
> In collapse_possible_orders(), anonymous VMAs are checked against
> THP_ORDERS_ALL_ANON:
>
> mm/khugepaged.c:collapse_possible_orders() {
> 	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
> 		orders = THP_ORDERS_ALL_ANON;
> 	else
> 		orders = BIT(HPAGE_PMD_ORDER);
>
> 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> }
>
> A faulted-in anonymous VMA that is smaller than HPAGE_PMD_SIZE (or does not
> span a full PMD) will return non-zero from collapse_possible_orders() when a
> sub-PMD order is enabled, skipping the !collapse_possible_orders() block:
>
> 1. If the VMA starts at or straddles a PMD boundary (so hstart == hend), it
>    sets mm_slot->address = hstart (< vma->vm_end), skips the inner while
>    (mm_slot->address < hend) loop without incrementing cc->progress, and
>    leaves mm_slot->address inside the VMA, so vma_iter_set(&vmi,
>    mm_slot->address) will rewind back to this VMA on contention.
>
> 2. On architectures where user mappings can reach the top incomplete PMD range
>    above ULONG_MAX - HPAGE_PMD_SIZE + 1 (such as 64-bit s390 where TASK_SIZE
>    is -PAGE_SIZE), a sub-PMD anonymous VMA with vm_start > ULONG_MAX -
>    HPAGE_PMD_SIZE + 1 bypasses the next < vma->vm_end overflow check above.
>    Then hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE) wraps to 0 while hend =
>    ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE) is ULONG_MAX - HPAGE_PMD_SIZE + 1,
>    causing the while (mm_slot->address < hend) loop to run from address 0 with
>    the wrong VMA and rewind mm_slot->address.
>
> Should the hstart >= hend case also advance mm_slot->address to
> ALIGN(vma->vm_end, HPAGE_PMD_SIZE) with the overflow check before computing
> hstart?

This seems liek a pre-existing issue. Are they being snuck in by not being
flagged as such now? ;)

>
> [1] https://lore.kernel.org/r/20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org?part=3

--
Cheers, Lorenzo

