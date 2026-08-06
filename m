Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C23C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B62F6B009E; Thu,  6 Aug 2026 04:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366AB6B009F; Thu,  6 Aug 2026 04:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EC56B00A1; Thu,  6 Aug 2026 04:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25FB6B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:51:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 869F280668
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:51:13 +0000 (UTC)
X-FDA: 85070225226.09.B08216A
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2E4916000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:51:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUFqczCE;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786006271;
	b=vZs7e0tXFNhQQfmTLH6tGa1Nw6xuQp0TMZlvjVkEcgQDUV0uZPv1gsNGU9jmhfP1fPglMp
	Zp3ZPRWQOod/e+GKpit+IicSKkSkmGMb1A6Hz/DHVt4835whGWwXe7Wkza7YiT/1xL6/5/
	KgLm4XQ5B43c6rWwBtDypsnVCUvll8w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUFqczCE;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786006271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Avz2UJlhCHkynyE4R7iSfC5vbrndaS9xUbSktAymKgM=;
	b=frd4xF/BrpfatqZ3YsSZjJyZcsfYkZTs4h+yUbyeJjJMqk2hNoYAOOle7L+3t29BfUtbL3
	gjMZNZEH35j9We4UTHZrVgtWNfXeamf+NyclEZCZtgrxE5yMbX2mw6FA1zOeCHtgGe7L8Z
	ANYbQO2Y4sjgaQcIyiKKig1PeMDI20s=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c197e7e4e94so346524866b.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786006270; x=1786611070; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Avz2UJlhCHkynyE4R7iSfC5vbrndaS9xUbSktAymKgM=;
        b=OUFqczCE9HyxxEb4LmJJLUcOvBzryQCxfnft9kqxDKo57VXmAVWlBefMvTELyzpSwC
         8o+5ePzYum8DVNDzb1WbtlNx5sl97JWR375GAn8eVwFXc3r6iVM0IEAkjxB0ZOvR9KgG
         Aiex9ZSrWK5aRObMmxlS9oDxJOf89y4VaPJIJ5Kypxl0+tnW1D3rft3NJQfvUsHlGE37
         FfHN3e9TQpxbqWFXPAdbE0AYZinGpSM4OUXwMByxqacL1iQ3FeUlIAmkHLMYWAtCtisH
         XkF4/FLPDHKNGe6Y7rC3dLFaTaiXWKx7lu1kUUW4ch3kH2uX39GPA5GACvoy/GDsA1SG
         QAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786006270; x=1786611070;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Avz2UJlhCHkynyE4R7iSfC5vbrndaS9xUbSktAymKgM=;
        b=DJ8ZbAhurlW2Jjk7ir6OD+0PShO1S/mY19/Q++qVW+ZzmksWuJEVtLTSNSkx7pCfNj
         PrZuSfiAavZFzfyfPbLCNPRHulePIUXuAwukh0D3xX7DPLB6FKR0Mwr7YKlbdqqeEMTU
         PL54MRm90ecJVy4PHHiVeo7GOT//YTTAfJwBeFPghVanzmlGYwLrfzBmj5PXk0t261tV
         72LpOoWJYzX3XS8mIXq5t51WjwVJLnJfCji3dw5diKwMXRQKJ3T5fiuzBSYDfgxnhikT
         dWEsgwEDnMrLzK2H0F39TeqqAD9bfLHbjSNHCdMsYPcqzp0uJbGDBLNfa4E7ndbUi38i
         5M8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoE9zgfsAK12u/fmabkeXsTPY8PXpdaiOWf9tGTaEaEPA+UAEzLgfSPWmIL/wQ7CtyI5kqMLwmE/w==@kvack.org
X-Gm-Message-State: AOJu0YxiVKJrixTw5iMIIW0g2Yw5qVMxVHUGiRHZyoG8gMveFrPffXBm
	bLqn3z+mldLBNIn9DcwvMfpJvob1FXqK20QSP6oKnB+IDcYDXh7/V00v
X-Gm-Gg: AR+sD13G641yJAagrFJ5Z+VGeP+cc3KyMULnocBBFrVkPs10Rew4OytJzCD7Dy5zp2J
	kgjBeg2o5Fa3a6f+KSU31KUUX08BJWOfnoQGKwd6TxjMAudIz0+yOnTzHbDWovA//3Amoev/nbG
	kuhsd5x2jtyzUPDm1SgF4t0S5haIFBXkwOhCvfTvQsa0VcmPhRb9j5xcu3pXTX0eT/AcTdItBHt
	LxEedADFHJ5/Ch3WEzwakFm9HyaZaLCPf+IUETO0JEQHbYbXvEyquVrfbnQUY23INz/GA0N82FG
	i5Waj4/m10yKyW1k4IPJlQl0HTbCcoml40kJcYfr5Jf7W+UgXwJVO9rMkUWU7t7gr1X1kmwzAyf
	BDOxXwviOqfb0R9VW/OXiGxWtG6Z6ZYfFK/s36XNuq48j+ifsS7DEAFRw3lWfOtzh8DGIsAGqwf
	WtTl43hNSHbyN5ERACcUJcG7qX/Gs=
X-Received: by 2002:a17:906:fe05:b0:c16:9edc:612e with SMTP id a640c23a62f3a-c2039ce6007mr719138066b.3.1786006269984;
        Thu, 06 Aug 2026 01:51:09 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036254060sm234607666b.24.2026.08.06.01.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 01:51:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 6 Aug 2026 10:51:07 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Artem Lytkin <iprintercanon@gmail.com>, linux-mm@kvack.org,
	willy@infradead.org, shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-ID: <anRK-y0nBUnbli_u@milan>
References: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
 <20260801114915.115224-1-iprintercanon@gmail.com>
 <20260801115202.ccba41ddac9f7a4f6fb1ca9f@linux-foundation.org>
 <am9numIMZZ4s7UMl@milan>
 <20260803173935.132156ba2b86293ffecb0e8f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803173935.132156ba2b86293ffecb0e8f@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2E4916000C
X-Stat-Signature: 5fsq3nz364n5jr58t4gcgheimfq51361
X-Rspam-User: 
X-HE-Tag: 1786006271-919773
X-HE-Meta: U2FsdGVkX1+rHrnOSzkuNzt4p0/5TIjb5lPcXwDBc4pooeziLoXrsgoAkkj4OBH2BoLDz4Ciztt2GOakr6V8tCBuhMVxxnQ09xgl0tQkbpdR5z0OaY2I/QrTLria7mjPnEH9lt0GTpOzvK80F6iBr60a4Pn1/qbaxr8btZuEQp8wphsmQ0YxH71hWMqFI1rc3wUq+tepL4lI9tkK92AGQO6SmnLUK2QENE2p3BoxJluhYBfR5Ta/DZhCqjDpuVTtruGrnX3k3EZMGDtP3dZxtQnF2mbebLs3xopuplL1xD/8uzCY17y/bYUctqcyZTTiZHRSvNpkb+d7HZHMnKazV3n6wW3Ne5MHkRo266aj1zTUpL4bQdeAXY5+5wF9JxNL81zdo1Fy8JXY7UG1CfcqltJUs3ANtcwibWEoG0sn3MpiOGJKnsk8VQnwmW94Lb/IdeSELyNfelRtEGcfg8oqxEZa9cLpkGbkY+xilkP6FLIjroNzqKcHwrrGgaMgSfZny7+IfuBF+7UtUzP8v91AtXephynafRAcUG40cF1SkXp1OQlAxghzM39RQq3KFiNmnInHtqs/dqIZf9KD0ZR9w36LOiWEDWoaIBRG5xtkkCpx5U1b4kO/jOAhPYSvlNpGpVQXVXPB5cu5ZU+5h8d3OyI2gH5z2W9n3/gkfDr9f68uSJnXczj/hvLhRHo1nxcr5vYgz9apbyZ7OCXFcRRDl1/u2rnx08A5yx+mRrrCH8Ez/VfW0dcKPV+c9cmHGaZiaMh1FPSm0Q2sdZbrjANcYmDVVMo7fgpIkmN3uWP6sY3+uQIYdoHeiYtwF/nYBVCU2M9SuLoQHX2ITJBtXwXB3SSbR6HaAHyAYeju5YOqaCJqWW5HESx8PMIq7QYdwUCjIL/N5PAGZ0bktlgTl4qdOVzAN248/uiG6k4SW1Nx2qS+GvAQpoH7S8ScDDLYdnMrY73zQu7aWipDebEJMRO
 pn49PEqn
 s854s7DlTqZNOJnMIUhJ4JmgMpS40a22OrZgOTQGTcnJbWVocYPf+VS2+jKb/sAmTU2cjsha5lkP7+8h/wCvV6NTAhTxAFovoYBL7ltXJ4J3zC0D6TkEt72HQsH0qtCLhIOPm4/hCy/SeTnvX/EivLaG2ImoDyg4wPs7KU9GNSHyoZm4heCNhTWwU27Jk2yCf6wdnWsO2LdOp6vY+RhDqyvi0ikLdKo4CjudotxBQBakSUBnt5ckdxe0/ME2+fn2a5anFhfAm5TQ3KR+x5H8a8tWHJrXL9Bh1XNGm8crj5I5vnIOc1K4f8oH8Bldl0b/r9Qb0RHnvfeO03ql+uKNH8Zzm82xzJARCEfXuE6s96yaNToL3ix8r/1C6m7QTO65/x3U6okmtQ3DpL5ktBvHQnLivGTB510ooWRcjcgicePDPvPSGdX/l3JvtWSPl83Y6Ge3tEyVI005+gEym7GuTIPLSIG02yZZPmbByCzRRCouGOhoG1/MIz+1J6edl0MHf32jm4YHI+y3F8UT2+1X9xGkLY7lBQ/07lwJG25HVN8EBX34405y3a34vFmdPLIKKTNKN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:39:35PM -0700, Andrew Morton wrote:
> On Sun, 2 Aug 2026 17:52:26 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:
> 
> > On Sat, Aug 01, 2026 at 11:52:02AM -0700, Andrew Morton wrote:
> > > On Sat,  1 Aug 2026 14:49:15 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:
> > > 
> >
> > ...
> >
> > > Ulad, AI review suggests that vrealloc() has an issue handling
> > > __GFP_ZERO.  Can you please check?
> > > 
> > > 	https://sashiko.dev/#/patchset/20260801114915.115224-1-iprintercanon@gmail.com
> > > 
> > I have checked. I think the AI is missing at least one point.
> > AI argument which is:
> > 
> > <snip>
> > If a driver initially allocates memory using vmalloc() without __GFP_ZERO 
> > (leaving spare page capacity uninitialized), and then grows the allocation 
> > using vrealloc() with __GFP_ZERO, the caller expects the newly exposed bytes 
> > to be zeroed.
> > <snip>
> > 
> > In the vrealloc_node_align_noprof() header documentation there is a statement:
> > 
> > <snip>
> >  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
> >  * initial memory allocation, every subsequent call to this API for the same
> >  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
> >  * __GFP_ZERO is not fully honored by this API.
> > <snip>
> > 
> > AI argument violates the documentation, i.e. mixing __GFP_ZERO is not allowed.
> 
> Sashiko is talking about the initial allocation not using __GFP_ZERO
> but vrealloc() *does* use __GFP_ZERO.  The documentation you quoted
> doesn't address that case?
> 
But this is not allowed according to doc :)

<snip>
...
callers must ensure that, starting with the initial memory allocation
...
<snip>

Also, AI describes the situation like:

vmalloc()
vrealloc(grow, since need more) 

i.e. from the description:
<snip>
and then grows the allocation using vrealloc() with __GFP_ZERO, the caller
expects the newly exposed bytes to be zeroed.
<snip>

and it will be zeroed in fact, because the path would be:

<snip>
need_realloc:
	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));

	if (!n)
		return NULL;
<snip>

and not the one which AI pointed to.

The real scenario is:

1. vmalloc(!GFP_ZERO) - alloc size 10
2. vrealloc(!GFP_ZERO) - realloc to size 5
3. vrealloc(GFP_ZERO) - realloc back to 10.

3 - will not zeroed. As noted in doc ZERO should be used starting
from the beginning [1]. But in __most__ cases it will be zeroed
anyway because we free/unmap tail pages and if:

<snip>
		/*
		 * Free tail pages when shrink crosses a page boundary.
		 *
		 * Skip huge page allocations (page_order > 0) as partial
		 * freeing would require splitting.
		 *
		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
		 * be reset before pages are returned to the allocator.
		 *
		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
		 * mapping requests against the unchanged vm->size; freeing
		 * tail pages would cause vmalloc_to_page() to return NULL for
		 * the unmapped range.
		 *
		 * Skip if either GFP_NOFS or GFP_NOIO are used.
		 * kmemleak_free_part() internally allocates with
		 * GFP_KERNEL, which could trigger a recursive deadlock
		 * if we are under filesystem or I/O reclaim.
		 */
		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
		    gfp_has_io_fs(flags)) {
<snip>

is true the next grow with GFP_ZERO will be zeroed.

For huge alloc it will not be zeroed and for other conditions.

> Also, developers don't read documentation ;) What happens if some
> caller *does* use vmalloc(!__GFP_ZERO) then vrealloc(__GFP_ZERO)? 
> Silent misbehavior would be bad - it would be good if vrealloc() were
> to drop a WARN() then ignore the __GFP_ZERO.
> 
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -4294,11 +4294,6 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
> >   * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
> >   * reallocation and possibly disregard the specified @nid.
> >   *
> > - * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
> > - * initial memory allocation, every subsequent call to this API for the same
> > - * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
> > - * __GFP_ZERO is not fully honored by this API.
> > - *
> >   * Requesting an alignment that is bigger than the alignment of the existing
> >   * allocation will fail.
> >   *
> > @@ -4415,13 +4410,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
> >  	 * We already have the bytes available in the allocation; use them.
> >  	 */
> >  	if (size <= vm->nr_pages << PAGE_SHIFT) {
> > -		/*
> > -		 * No need to zero memory here, as unused memory will have
> > -		 * already been zeroed at initial allocation time or during
> > -		 * realloc shrink time.
> > -		 */
> > -		vm->requested_size = size;
> >  		kasan_vrealloc(p, old_size, size);
> > +
> > +		if (want_init_on_alloc(flags))
> > +			memset((void *)p + old_size, 0, size - old_size);
> > +
> > +		vm->requested_size = size;
> >  		return (void *)p;
> >  	}
> 
> OK, thanks, I'll assume you'll prepare this for real when convenient.
>
OK. I will prepare something and send out the patch after testing.

--
Uladzislau Rezki

