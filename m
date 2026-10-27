Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A0A606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F6smgmbB
Received: by kanga.kvack.org (Postfix)
	id 8EE4F6B073C; Tue, 27 Oct 2026 09:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C58B6B073D; Tue, 27 Oct 2026 09:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803016B073E; Tue, 27 Oct 2026 09:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57B7F6B073C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4C3B4098A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:14:51 +0000 (UTC)
X-FDA: 85368451182.08.9507A5F
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18B2B160002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:14:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F6smgmbB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2uWa8OCp+JmIWz9LyNPjeXGN6Nre3MtmULmcDT63fA=;
	b=zm8pBujxlBfaPkru4GZzpDEYy911topbEjOEtnXnx2zKTtATuTV35Bfpz4+Bkpe6RVXtya
	d2AYjU7r6piIDKKNwIzMa6LnpU7tvs3o4DfvZoA+9r2sg8ZeBQSiQ8o4fcpRLwiCcEDaqz
	b9K73W32b+qNm8X9Wbh4BADTwhhxf+k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F6smgmbB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106890;
	b=veg/QqObRXMitYvqADN8dH8UuDw01KS8wmwQY/yqlmbpYmhYNCEo7g8CeDjX7nRlO42wq8
	J9S5mBhZHeav5a8brRIcIr8jSUDmKGsHaAAhEVDPH24qiEUlHs1qELvNY1/XdfaWHNCC5h
	YKqNRW2Y2ivqLqBv6EvDkqzUbX4KZCQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c414e5d282eso484972466b.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793106888; x=1793711688; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p2uWa8OCp+JmIWz9LyNPjeXGN6Nre3MtmULmcDT63fA=;
        b=F6smgmbBrViBYr+DXScJ6I78+P+laa0LDwx/k3t21zDmXoV9euIgbM81X/JGlRQnRq
         hw8l+5xsAWUehnrREkRhyGg7d9YdlI91Liam2C/hinJHbh8nLnW9mYKBuzcqaCEyVATc
         GpXRj3po7huwarpw+9s9UeZecsnJQEkJV39XukBIgTZPgGCOU7ffmnXjYhud7dAQyC25
         MzAA+NzeMYlo0GPTo+dgRlHru72b+4J84iS2LTPayWZDc7Kbsx5EyDC3viPWzPK6r2uB
         DY75o+CWfrDfYbX75zgU0u/hqzQnYd7RB6579QU+JNACecJFYTt0IgV/cuE2WmvEOI4Y
         nhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793106888; x=1793711688;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p2uWa8OCp+JmIWz9LyNPjeXGN6Nre3MtmULmcDT63fA=;
        b=Mo7QLmSuHSmcdqiw5KOhwnxBHRy1qDhcS0Zn9IrmUmploT3tEh6hyouybA006eMuUn
         HY8Z2gUBN+SbD9KZptTnSOH5/uu0qf3p88pXKYjehvBGDyhpg3PocnCKj/C6giZ2PlGl
         jnjP9QtS81ASwspr0Fq1FAMOIsJ7IeqfH0ypZCuoP51oYiLX6OnCg39JkyW9MJcCTO9u
         5uWICeUMZOpMkky/TAyiG57vV/zK2dRMq4DKJsTU6D/RKRZem+4kvCGrnx2s7l4XDtQN
         7n5Nnqyj/10QgZ1elKyFRgK6W9mh9oiIxRWetoR03ZCruDoCn7obqF6p6u/fCHRnouy1
         xSwQ==
X-Forwarded-Encrypted: i=1; AKwUvBw9Q/84/J9k/k4uYRrkXOX3/fPFsjYGfsnfO2nJTgTD5ANnxIDA0FAq+k0oYwtx3IoqcSJVe0rcGQ==@kvack.org
X-Gm-Message-State: AFq9FYK1qrHZTaFXr5k6UZdTHOFgvTWeXQaOokzvk0sFipBEpgGdcHLQ
	GSnZu4QMmjz5lji8vFjQWiQ823s9U/BhJSOFlhLtZynjoAriLtamSMx5
X-Gm-Gg: AYBFou1bFXHQyE/+x5/L4DolhrJD3Rwdh1ZJN5mlqGraqKGsifWBsPQRR+ngTX1z99m
	xsL8eFwUNyR9r06QYjTn/J0h12ooctpNxQGWOa2i4bjHvfYK4o0otSaK1di32QqeB7de8FrvTu1
	PN1VEWAV3BUBiU3UyGHOXqMV5VYbkuydsYpBYA8OOcb0B72g1WbsIDfPIye4N7L1q+X9U7VRXot
	j9rB2TB/dRWSDHnc/avHGvEYuvzRclBko3m9rh/Q2Qcs3802XX0fLPZBbcrPJOcGZHOamb6ULyL
	z8HZkVGBIhKlQB425r0FSfXB+wroHJvzM/RhrwrftjI3ua3NVj9h/teCAE9SG1OBLtEtZA0noMk
	8fRkbnt9d+56KTJWJXWlHmem5TjxLMYRdzksGvC3FaVKzPVquvHDFrV8Hb2GvBWtDF1aBNRGa5x
	18mSB2zQY6J4uDpZt0xKKKYIYXcSIz/5Gmvx4gT1iJrnS493ImMVshodqZk3jVICx/i5veuQzLg
	Pt1akyVIIZl14QHAVOD
X-Received: by 2002:a17:907:6012:b0:c49:b85d:f035 with SMTP id a640c23a62f3a-c49b85df51emr22738966b.32.1793106888182;
        Tue, 27 Oct 2026 06:14:48 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd795bf8sm450327566b.70.2026.10.27.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:14:47 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 27 Oct 2026 14:14:45 +0100
To: sashiko-reviews@lists.linux.dev
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Message-ID: <auCjxUJEOMzmcoga@milan>
References: <20261026102503.30860-1-urezki@gmail.com>
 <sashiko-outbox-186354@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-186354@kernel.org>
X-Rspamd-Queue-Id: 18B2B160002
X-Stat-Signature: ww85rambxtpqnokqp331cizdmqj9qn3u
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793106889-156144
X-HE-Meta: U2FsdGVkX19iLtJDLDfPiI5fO+oWiwZIEREjit3V0IR5yruvPR20pHychMUKXVMRiWllW6xLjro9GVqrTl0jmXZ+XfJg4Qe+2S1ADQsvQd8MYBTP0SG+iig/FOKDgbgKxhMSa5eenIOAcnmkTvl9/qMmYjhqr1yllY3ZPbz/LepyEX/Tpg39HRtc19GwRRObh5xRTyVHK5BExKHq6kPpG7/CuoBVoqc2p8DUiBt1vt0qt81X93u/4AfL5+SLcZfEYcT8HjzYn1AsQL+Ex89p8AZXy+5lZHYBZbGHRp8QR6fNxoAo913/P2Is11TFcQdV5sEKc+a2UKR2dZ0oWnw/TOy05N4e+Eh1e/sDtJaO5s/wAg1Y+L+u5lbwsizcmAcL5y2mW9dQQbFhpUNSX1BWNEkLFvYGXvYD2XBJj6K7T1nGTtJ+ejfrkKVU92uZSWDSh8W7gBvrf7PvmNI7LQSsVBh/71Dv0W9v0CcmhWFr+EvKXOU8SH3c/VJcqoqp1L4iX6yPIj5lbGhTNVf6qk8B1ncPn4eas75v7L95rX+nVCTmNHiYQrhKQJ7+NwbP+dqhltVt+wI4droVxwoie5A/N55sAAAvpqFkLBg3v3gi/QJyOWJrjMO+k7+jNCLA0DoVBrwpaWqVE5qXz65NtGhDCWad2z0RCpbNiG5GewDnC6UQf4Ngm2uS97tTce1yJYiM7l91JyXCdJ9eRAFdIjh4YIZ/5mgrF9V7ffJmRwN/diXTWJev3qXgKNs/zP+GUEYXQyFQjvJ9hlH4bwYJb6WBuXZbTIb0LAdZlyggvWhdm0HuIabz1fKkx24fvqECpq59g0K0ckfEzfwH6ruhrm5ZFGYhnZEn89YIs2t+alOhmbC/jIg4pYhmzX/0jjXjeEHLtbWoc362l3FNoalHbfwOvVq/NaqioRC+WEtHBG+TTteJs15ZgnkTPahkYgKq1lUebbSUPI1gIa681oBuAaw
 FVMofq9F
 WC942gRpHHGLC6e50eZGjpyj21Qga0bD5MGxX1TYKI3sSZYQnwB6GXAvb7Qm3low2kY2t8gbo6CVmvpgIhisJgY28GpT/6MGXXf4aAhmpSVYuQqOmSeXUEyC9P0QOPiHZDjXHvjG/oFJ2schJ5nBfovLHQO2BKIfW0QyQHkz0Cb5fOETCbIPv5cJOZ7w0EN1+ff5dEbDGnLE/lze7V0ft5KN5PBQYG6tic3Mkn0TizsLHQS2z0Dcl/bH+MVghPp1tZkG6AwMLD2BAbbszjLgE1jClVZCaFCZ3ntdOcvwS/9z5VFiGf2lC5NWY2YtPCnAYv9bzTvIN7PDSHhlhh0EYCwJJT9wbVsED0xnb515GBOIgrM9y35Zto15NO+IagESvHRDGVNlOul0+Ujx9EYiMmYcwIK5US1li4Tf1yQ8NKzAPOziHXAroc2s9TD8CRWIIuVvkUOcn8wy/0PxUUBEstK2hcpKTnFqhPHeqIG63Xf1FPVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:25:23AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mm/vmalloc: ABBA deadlock when calling vmalloc() with BH or IRQs disabled
> - [Medium] mm/vmalloc: __get_vm_area_node() irq bailout triggers warnings and retry
> --
> 
> commit 9fea18279139941aa247a1a577dd5e101116871a
> Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> mm/vmalloc: Bail out if in softirq context
> 
> This commit restores a softirq check in __get_vm_area_node() using
> in_serving_softirq() so that vmalloc() bails out when invoked from softirq
> context while still permitting callers with disabled bottom halves. It also
> replaces BUG_ON(in_nmi() || in_hardirq()) with a WARN_ON_ONCE() check that
> returns NULL.
> 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 44e0eb32708f1..5a949525b9db8 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3271,7 +3271,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
> >  	struct vm_struct *area;
> >  	unsigned long requested_size = size;
> >  
> > -	BUG_ON(in_nmi() || in_hardirq());
> > +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> > +	if (in_serving_softirq())
> > +		return NULL;
> > +
> > +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> > +		return NULL;
> 
> [Severity: High]
> Can allowing vmalloc() in task context with bottom halves or interrupts
> disabled still cause a multi-CPU ABBA deadlock on vmalloc's internal locks?
> 
> In mm/vmalloc.c, alloc_vmap_area() acquires vn->pool_lock,
> free_vmap_area_lock, and vn->busy.lock (and __pte_alloc_kernel() in
> mm/memory.c acquires init_mm.page_table_lock) with plain spin_lock(), leaving
> bottom halves and hardware interrupts enabled:
> 
> mm/vmalloc.c:alloc_vmap_area() {
>     ...
> 	spin_lock(&vn->busy.lock);
> 	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
> 	spin_unlock(&vn->busy.lock);
>     ...
> }
> 
> Because __get_vm_area_node() only checks in_serving_softirq(), in_nmi(), and
> in_hardirq(), a task-context caller holding a lock via spin_lock_bh() (which
> sets SOFTIRQ_DISABLE_OFFSET rather than SOFTIRQ_OFFSET) or
> spin_lock_irqsave() (where irqs_disabled() is true while in_hardirq() is
> false) will proceed into alloc_vmap_area().
> 
> Using the bridge FDB path referenced by commit 04aa71da5f35 ("mm/vmalloc: do
> not trigger BUG() on BH disabled context"):
> 
> net/bridge/br_fdb.c:br_fdb_add_local() {
>     ...
> 	spin_lock_bh(&br->hash_lock);
> 	ret = fdb_add_local(br, source, addr, vid);
> 	spin_unlock_bh(&br->hash_lock);
>     ...
> }
> 
> net/bridge/br_fdb.c:br_fdb_update() {
>     ...
> 	} else {
> 		spin_lock(&br->hash_lock);
> 		fdb = fdb_create(br, source, addr, vid, flags);
>     ...
> }
> 
> If CPU 0 is in task context inside alloc_vmap_area() holding
> spin_lock(&vn->busy.lock) or spin_lock(&free_vmap_area_lock), and CPU 1 is in
> task context inside br_fdb_add_local() holding spin_lock_bh(&br->hash_lock):
> 
> 1. A hardware interrupt arrives on CPU 0, and on irq_exit() NET_RX_SOFTIRQ
>    runs br_fdb_update(), which spins on spin_lock(&br->hash_lock) before ever
>    reaching fdb_create() or __get_vm_area_node().
>
> 2. CPU 1 proceeds through
>    fdb_add_local() -> fdb_create() -> rhashtable_lookup_insert_fast() ->
>    rhashtable_insert_rehash() -> bucket_table_alloc(GFP_ATOMIC | __GFP_NOWARN)
>    -> kvmalloc() -> vmalloc() -> __get_vm_area_node().
> 3. Because in_serving_softirq() is false on CPU 1, it enters
>    alloc_vmap_area() and spins on free_vmap_area_lock or vn->busy.lock held
>    by CPU 0.
> 
My patch fixes self-deadlock on re-entry. 

<snip>
CPU 0:
 task
  vmalloc()
   lock(X)
     IRQ
      irq_exit()
       softirq
        vmalloc()
         lock(X) -> self-deadlock
<snip>

and we used to bail out in this case. So it just restores previous
behaviour which forbids re-entry.

> Similarly, a task-context caller holding a lock with spin_lock_irqsave() can
> enter alloc_vmap_area() with irqs_disabled() and invert lock ordering against
> any hardirq handler acquiring that same lock (and sleep with interrupts
> disabled on CONFIG_PREEMPT_RT).
> 
> Should __get_vm_area_node() also bail out when in_softirq() or
> irqs_disabled() is true?
> 
I think it is another patch:

    if (irqs_disabled() && !early_boot_irqs_disabled)
        return NULL;

> [Severity: Medium]
> When __get_vm_area_node() returns NULL due to in_serving_softirq(), in_nmi(),
> or in_hardirq(), how does __vmalloc_node_range_noprof() handle the NULL
> return?
> 
> Looking at __vmalloc_node_range_noprof() in mm/vmalloc.c:
> 
> mm/vmalloc.c:__vmalloc_node_range_noprof() {
>     ...
> 	area = __get_vm_area_node(real_size, align, shift, VM_ALLOC |
> 				  VM_UNINITIALIZED | vm_flags, start, end, node,
> 				  gfp_mask, caller);
> 	if (!area) {
> 		bool nofail = gfp_mask & __GFP_NOFAIL;
> 		warn_alloc(gfp_mask, NULL,
> 			"vmalloc error: size %lu, align 0x%lx, vm_struct allocation failed%s",
> 			size, align, (nofail) ? ". Retrying." : "");
> 		if (nofail) {
> 			schedule_timeout_uninterruptible(1);
> 			goto again;
> 		}
> 		goto fail;
> 	}
>     ...
> }
> 
> Since commit c6307674ed82 ("mm: kvmalloc: add non-blocking support for
> vmalloc"), __kvmalloc_node_noprof() in mm/slub.c falls back to
> __vmalloc_node_range_noprof() for non-blocking allocations (such as
> GFP_ATOMIC or GFP_NOWAIT) when size > PAGE_SIZE and __do_kmalloc_node()
> fails, while kmalloc_gfp_adjust() only adds __GFP_NOWARN to the kmalloc
> attempt:
> 
> mm/slub.c:__kvmalloc_node_noprof() {
>     ...
> 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
> 			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
> 			node, __builtin_return_address(0));
> }
> 
> Doesn't bailing out in __get_vm_area_node() lead to a few issues in callers:
> 
> 1. In softirq, hardirq, or NMI context, when !area is reached in
>    __vmalloc_node_range_noprof(), it unconditionally calls warn_alloc()
>    whenever __GFP_NOWARN was not passed by the caller (and if shift >
>    PAGE_SHIFT, goto fail resets shift = PAGE_SHIFT and jumps to goto again,
>    repeating the call and warning a second time).
>
Calling vmalloc() from nmi, irq-context or on re-entry is a wrong behaviour.

> 2. If a caller in hardirq or NMI context invokes
>    kvmalloc(size, GFP_ATOMIC | __GFP_NOWARN) (for example,
>    rhashtable_insert_rehash() -> bucket_table_alloc() in lib/rhashtable.c,
>    reachable from irq-safe rhashtable users and BPF_MAP_TYPE_RHASHTABLE
>    updates in rhtab_map_update_elem() in kernel/bpf/hashtab.c) and the
>    kmalloc attempt fails for size > PAGE_SIZE, __kvmalloc_node_noprof() falls
>    back to __vmalloc_node_range_noprof() -> __get_vm_area_node() and triggers
>    WARN_ON_ONCE(in_nmi() || in_hardirq()) even though the caller passed
>    GFP_ATOMIC | __GFP_NOWARN and handles NULL.
>
Caller is not allowed to invoke vmalloc() from NMI or hard-irq context.

> 3. In __vmalloc_node_range_noprof(), nofail is not cleared when
>    !gfpflags_allow_blocking(gfp_mask) (unlike in __vmalloc_area_node()), so
>    if __GFP_NOFAIL is set when __get_vm_area_node() returns NULL in
>    interrupt context, it will call schedule_timeout_uninterruptible(1) in
>    atomic context and loop indefinitely at goto again.
> 
__GFP_NOFAIL and NOWAIT or ATOMIC can not coexist together:

 * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block
 * indefinitely but will never return with failure. Testing for
 * failure is pointless.
 * It _must_ be blockable and used together with __GFP_DIRECT_RECLAIM.

--
Uladzislau Rezki

