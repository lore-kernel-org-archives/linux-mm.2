Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EDD606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N61KI5CH
Received: by kanga.kvack.org (Postfix)
	id 1612C6B05B2; Wed,  4 Nov 2026 01:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112086B05B3; Wed,  4 Nov 2026 01:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0000E6B05B4; Wed,  4 Nov 2026 01:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D57B06B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:47:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 697DC16066C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:47:03 +0000 (UTC)
X-FDA: 85396504326.12.2D676C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 78D4620008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:47:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N61KI5CH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793774821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Loz+p/M+jnoTqP1meBOYhbLrzGt57kks0nCU6EVr6Kc=;
	b=EBA0aZloWEweUfowUc+xLDdkt26MWpc2SDVa45srgs9bQZtF/+tA/hMRUzAYAuGcxeRZmm
	i9eJEnzbK+WVNSMqTyv9h9YfXaNHZmTOHQH6M/lSIpvauuSkSVfS8My6q1G/6yKu8UoaK1
	We5w25Xc2Hv42CgEPc6nzbLa5PynH68=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N61KI5CH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793774821;
	b=S2+CWmS6dU8W6/83bwVOzVm+pyYLj9e5Du8tww9m5FjJZUl0crHamgFJKX/ncn44HLUcT5
	61KLeEPOyPSivqK8x/+FoT+k26yOMtBYcPZ8GSCOW0C0lri4do2zqCLxndOZxRLs1rRJke
	/3q4AyNuBUQyDtDfaXjzRtqs0sSUVZs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D5F601F6;
	Wed,  4 Nov 2026 06:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD731F000C1;
	Wed,  4 Nov 2026 06:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793774820;
	bh=Loz+p/M+jnoTqP1meBOYhbLrzGt57kks0nCU6EVr6Kc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N61KI5CHDe5LYICh8Hl7RuN6JYH6LTql8ZDpZi22hXl4MpiUlrkCjGBsiQZSHWlzo
	 mHeYonZ58J/bQsegiSWgsVj+OLQqMLqAeW6Jh9ro4bGT+mFRthY8lY+D1Gd7GvIMH5
	 gKMuF9KmLOFzxBLpvY5VmInAAASKNPLMOkM7DFoI=
Date: Tue, 3 Nov 2026 22:46:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Qi
 Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, James
 Houghton <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] mm: Decouple folio-based vmemmap optimization
 from HugeTLB
Message-Id: <20261103224659.2865b9ff27d09994949edd78@linux-foundation.org>
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78D4620008
X-Stat-Signature: e87ioj14sgicyy18fz49zojhdwhktmjb
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793774821-856563
X-HE-Meta: U2FsdGVkX1/YrZO0OT0ZoOKG9ypiV5iq3daHMwYiBX/ZlG4GQnhq4Jm72HKINZnfLRvltHoiNHKPXQG5w2A8yXYmmPOBS4jZ5vsUcsTl0G6+17/7KiYIxp9FGDwToAm1CjcIOY4/7upI9DX0jql6zI3c0Tm+iMHXI4ljo6SHIDtJES79+aJgwDxn4ScQ+QVFHGr0S42r7jlLhFsQfvpfOMDOL3UW0MqiNrpGLZ+GKTA2Ukfng7eHmRewgkddT9EVUhSC/iB7DmvIrbXgna6JUtS8wrQ34A2iIQmmRiZYAfGUVnLka5R8tuTGGnJuBzJLTTT/z9iCi8DMovURFfZSMFBJKN09mXbLouG7Ck0TdX4BzmW1Frm9zOAVtxUbh1xR00E09/UGzn5G9CK0+gV/ErTilIxbp7i9dwfV1L0qQRQWA6epbocrlw9QFRb5UnJ+GxDnH/aIrzS9DKfwgpkq7ZVMvEGsV6r2fnJknm8re+4Ha5HuaveN/HGIMIQA43GN7GP04SraRf2s5dBvIXzLClYpOawRQ/adN2kWJVSinLIKCaaT4PVWj6bDdtcjLB1UXQCfWOEz9pFpSOPBSHC1fdv1lVlMmBE/CYyRG2LzhrgwveVuw9yqbK/9IgfoRhOBTzsFw1m0OyL1bWlbLGoduiBiX3Q+LSNwAf4yD8DsKdCaevEQe09VnzfMw3zxzf9jHgqfUFswsQqEX43GF5sWtTeF/9ISi4/5RhdWPrK2QbmObqnxWryT/drGhBndQpEOQ4kB9pDrPGzXdtuL+y7CMowuqg8ZcCTcKpJZfw0Lu/ER7N5xQEiFKSPPY0q+v1m1z0uS2OLYgJAl3doAv05kyQGpXpgu7ZctZZoABlw6/1ztHp207xHBuDAylJvQKmwA2lsdqXnFmlx6ANsF91giePWu5ROdU/6Nx/3ZcaEF/o7M8/hnf+xBCHey9UwRMEWWLm32HuC0B8Eqt+xrHd8
 k79D9in6
 EIslTj4sy1N16uQEDjg80zjCY+Jc1mY0t/W4sK6vZSiyG62Vn2YoQOLRosLU/4zIrspBv33l6wNpHyXksBM8bxoyk4+4iybEnMS6NXAL2vXO3rS8tFZsD0jtCZqfdZ9994CJuqESpjcNa+MQomUtn7KOMMXHEcsbiiB+eyQERJ7SK378x5u+dd64+XiB+BJcykggJgk6zlcGEnBf9NC6JOEZYpyn4nUcpu4tXLW5l2LwkbEqAp7/LC67bsXv1we2jdyr+YdZ4R9X9WHIze5uieGnXVXoogc+0Mrs44zYvK1vh8KmMTV6jHIVJq6D/voSHPV9kO0HlHzavgcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed,  4 Nov 2026 10:34:58 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> Hi,
> 
> Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
> while folio-based optimization currently lives in hugetlb_vmemmap.c.
> The latter is tightly coupled to HugeTLB-specific state even though the
> underlying page-table remapping operates on one folio at a time.
> 
> To make these interfaces easier to maintain, the folio-based remapping
> mechanics first need a boundary that is independent of HugeTLB-specific
> state and raw address ranges. This will allow the mechanics to be moved
> into a common vmemmap optimization layer alongside the section-based
> interface.
> 
> This series establishes that boundary through three folio-oriented
> operations, each with a distinct role:
> 
>   - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
>   - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
>   - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
>     PTE mappings.
> 
> Together, these operations encapsulate the address-range calculation and
> remapping mechanics for a folio. HugeTLB wrappers retain policy decisions
> such as eligibility, optimized state, batching and TLB flush handling.
> 
> Patches 1-8 generalize the underlying vmemmap remapping infrastructure by
> removing HugeTLB-specific assumptions and simplifying remap control and
> resource handling. Patches 9-12 then establish folio-oriented operations
> for optimization, restoration and PTE conversion.
> 
> The implementation remains in hugetlb_vmemmap.c for now. A follow-up can
> move the folio-based operations into the common vmemmap optimization layer
> once the interface boundary is in place.
> 

Thanks.  I fed this into my evolving LLM-controlled testing setup and it
said

: I tested all twelve patches together in an x86-64 Debian VM under
: QEMU/KVM, with 4 KiB base pages and KASAN enabled.
:
: I grew the pool by 64 two-MiB huge pages and drained it again. With
: vmemmap optimization enabled, the kernel released 448 vmemmap pages
: on growth and restored all 448 on shrink, in each of three cycles.
: With optimization disabled, the vmemmap count stayed constant. I also
: faulted in a single surplus huge page. It released seven vmemmap pages
: and restored all seven when I unmapped it.
:
: I tested both boot-reserved and runtime-allocated 1 GiB huge pages.
: For the runtime case, I grew the pool from zero to one, drained it,
: and allocated again. I mapped the page and wrote and verified a byte
: in every 4 KiB base page. After unmapping it, I demoted it to 512
: two-MiB huge pages and drained the resulting pool.
:
: All twelve programs in the HugeTLB selftest group passed, including
: the cgroup reservation, fault-charge and reparenting tests. Both
: soft-offline cases passed, as did all twelve poisoned-page read test
: cases. I saw no HugeTLB warnings or KASAN reports.
:
: On a diagnostic build, I failed the head-page allocation and, in a
: separate run, interrupted optimization after three PTEs had changed.
: The trace showed rollback restoring the two tail entries to distinct
: backing pages. The folio remained usable in both runs. I also failed
: restoration after three of seven replacement pages had been allocated.
: All three were freed, the retry succeeded, and the metadata count
: returned to its starting value.
:
: I configured QEMU with two virtual NUMA nodes, each with two vCPUs
: and 4 GiB of RAM. On each node, I forced the batched pre-split to
: fail. The trace showed the remap splitting the same PMD and completing
: a range flush before replacing its first PTE. Folios on each node
: shared a tail backing page distinct from the other node's. I drained
: each node's pool in turn and verified data in a live folio on the other.
:
: Finally, on the kernel without diagnostic hooks, I grew and drained
: both pools during active page-cache reclaim. Over 40 cycles all 640
: folios optimized and restored, and the OOM-kill count stayed flat.
:
: Tested-by: Andrew Morton <akpm@linux-foundation.org>


