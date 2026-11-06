Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD74606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHS8idUP
Received: by kanga.kvack.org (Postfix)
	id 1561F6B05B4; Fri,  6 Nov 2026 05:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107FE6B05B7; Fri,  6 Nov 2026 05:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CE86B05B9; Fri,  6 Nov 2026 05:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2C586B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:04:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFF86A0CE1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:04:00 +0000 (UTC)
X-FDA: 85404258240.19.23A89F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23B1D20002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:03:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHS8idUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WwIP00I0ep3a7+h9alcgxM6A9Wjyx5EO3o9ThVwY78=;
	b=wbf1JrKA50sLJCA+KuFKJyyCkcMPpFz54tc2bVFmApXflTqtQnS+VsfHZajM5fMid32QAy
	29ToYaZZn7op5P75SmICZi10YUmSKN4NuUnFRxqS4HvrIAc1PaKYyYnlnBEqBPfToa3WVw
	RfkS05s7mF0ZSXOQCy8s3MmcWVlXGeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959439;
	b=4aao/va/Qvl7LU49V/1j66rx2T0WuzE6ms8lAiiQSupIZAB+FPyPsCZP5NxJfN/3t3J4ma
	TfMBZXg7dOFEYOCBbeTwSFZ1i2gxnnoRcMUbiTodPKpG/P0MvBRAW/qLIpROTeE2toyQiB
	l9oNd1viEwX0PWromAQj+ulahHaVMpQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHS8idUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D895601E3;
	Fri,  6 Nov 2026 10:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D91B1F0089F;
	Fri,  6 Nov 2026 10:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959438;
	bh=2WwIP00I0ep3a7+h9alcgxM6A9Wjyx5EO3o9ThVwY78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RHS8idUPuNjiwLrSPx6qJkTxU4VjR3X0geEV3JLFiZ3pPrZONy6gpLchihT1ow2lf
	 9youGO6+xshkF5PhEJBhBLNb3jP4220cS4O+antl8tJ3d/fi6JGe7JsnMLYxweXD8C
	 H+JEIzJAZM7RPb0a/6qtROcrJhm7W+fa3jSXerGh2Rrdqvwkn+IUUC9W3Zuh1+LMCC
	 yg/vEw8rriz5nmtD3n/Hc3BCruCxQRCt8oNeHytEeT8qREQHSq1NfVevyn0lk4TPAj
	 5xiQ+35Iii01PIluBnylWzb4lhSwPhUfTEqgKPUsTkAe1BFbSDgnk5e5eHVmkXBmgi
	 j3p6XxEMKEXgw==
Date: Fri, 6 Nov 2026 10:03:52 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au2lAPUNPlRtaeFY@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com>
X-Stat-Signature: jbr7nxqhq9b1xtooxbuzs8ruji3g6z1y
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23B1D20002
X-HE-Tag: 1793959438-208385
X-HE-Meta: U2FsdGVkX19C1qjW3AiLhmmmoADA49hCP0xWsih2ts01PUmr4yvAls4HwN6VZE1KM5g3edis5wAZmDjCy/Gzhg6aGzIrZ/PWnXxJzhCEcrG/dJ4OxysqTK1FwnH5jyzl2sXMhMPR0qPqdfT3ERzerrqM6qiwyapfic9fmGga5u8QBOEOVdmeMnKwrPDWcG3LbqpqoLDQYpq9EaRLD1tMoUE3XSgVnHPC7NE8cGCMzeqjLLLpIP5B5lLXd8Gu91+GwxSmivdhP0sL8oZQohc4GNrkKgZk2PpgYbGq1VPaEwrzRXrByuXn2+YJg+WF5ISLZ45RYpEz0blykKvIwW/l06+tAq8UfmIZbF88H4U0Jjt4mB8ZSk0QnLv2W5S8mIdgf5k0lK0iXQN+9KwSMbMZCKNjMiUD78UbXp0ggzjSSHU6EJRnnzMA1u55y3DgKZmktHIkkNK6EgutYmKKsnpky12ZzYfeMOwK2kO3+ssJhaTcGJzdF2EGJ1VVyrrC6nmutuyQeCLoLuHHOSDNjKbhcXZfZrxB/k6+U+DRzFm92/VRfC+d9ugGSyht1fySGOJCQGZR/mr4F7qkmG//n+FLHaCnHC89hcmfUqqwJ3NCVSW5fW8CfirhhrqiepLPMQDaJMVEESzVbsDe9v0PYLI3f79Ji3HQWTKZKu8/ERbkwrbAkWkD0NZca8EMkT9mQA3GzrMcUllYjPJHmzsN8tsPTff1VRi15SGJEzSatRlMGpQ5AaR8xZ5p/+7/6Ua47MUtlRHc5XhDzWrEJR0gx5WE066EklSMCcGzugcmVmHNRo5aNFOMU/Usi72p2GKc2+c32TE/iRJ2sCWqju6jiHql0x3EUf2mG8KcIfSYcNp4LJ8NZFklrD8jmpgPRARr6ScRX6zBF810MyT40umzvqzhr3qeC9A/tFGRhYro3oZaCf9On/lYPZJZtC+YufPUScx+tgTDyVSPKh/ZcAeAGw8
 yPGilC7G
 HQE4nGbTU0pdB4SKbPP2xL9VpCPKsUSx+v28teZIsTkbjREkKreH93u6Jevx3bIXopiIV6N0T7EW9B2KbOmk9oQo2dwhMXM2kf75+1oGRmH/DvUPTka1tKin9sVQvcjUmWn0B0uoUxl4AiIfzFdM+VTqYASKJfn3A1jg8C9sOMyRSfHqQs/ggH1KLMNGzdmcKuAsDIqstJWpyiOqS06xcp/epv2pvc57ANkWGGc3i8NVkhDpaJoSgrPTcRKZlgfWMei2Ehlxj1AP/F+MTBeupHiSlpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:53:13PM +0100, Jose A. Perez de Azpillaga wrote:
> On 11/5/26 9:57 PM, Lorenzo Stoakes (ARM) wrote:
> > khugepaged walks an mm's VMAs under the mmap read lock in
> > collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> > them if encountered.
> >
> > It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> > when these are encountered, however only checking this budget once an
> > eligible PMD-spanning VMA is encountered.
> >
> > It can therefore hold the mmap read lock for a long time if there are a
> > large number of ineligible VMAs present in an mm, over which time no mmap
> > write locks (and thus no VMA write locks) can be acquired.
> >
> > Address this by checking whether the mmap lock is contended after every
> > KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
> > pages_to_scan budget, and if so dropping and re-acquiring the mmap read
> > lock before resuming the walk from the per-mm cursor.
> >
> > As the walk is resumed from the cursor rather than the VMA that was current
> > when the lock was dropped, the cursor must never move backwards. A VMA
> > ending at the top of the address space causes ALIGN() to wrap the cursor to
> > zero, so treat such a VMA as the last in the mm rather than skipping past
> > it.
> >
> > This was tested locally with ~1M ineligible VMAs mapped ahead of a
> > collapsible region of memory, and resulted in a reduced mmap_lock hold time
> > of 170us down from 95ms.
> >
> > This was also observed to reduce mmap_lock stalls in concurrent threads of
> > a similar duration. Note that a reader re-acquiring the lock can currently
> > steal it from a writer that is queued but not yet running, so the full
> > benefit to writers depends on the separate rwsem change at [0].
> >
> > Local measurements indicated no change for ordinary use cases, so this is
> > all upside.
> >
> > This work came out of investigations into mmap stalls when getting latency
> > numbers for an unrelated patch series.
> >
> > [0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/khugepaged.c | 31 +++++++++++++++++++++++++++++--
> >  1 file changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 216c4b8d28c4..eaa01dae5a03 100644
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
> > +
>
> with pages_to_scan below 4 the batch is 0, so under constant contention
> we keep dropping the lock at the cursor and never scan anything, don't we?

This feels like repackaged AI review...

The mmap lock won't be eternally contended and if it is, with pages_to_scan
under 4, I think that's fine.

Alternatively could make that >= an == and the post-++ a pre-++ and the 0 will
never be hit in this case.

Or could have a minimum cap.

--
Cheers, Lorenzo

