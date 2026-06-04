Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AFECD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 13:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4F16B008A; Thu,  4 Jun 2026 09:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65ED36B008C; Thu,  4 Jun 2026 09:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526446B0092; Thu,  4 Jun 2026 09:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3B36B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:59:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D48AB90C0E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:59:29 +0000 (UTC)
X-FDA: 84842387658.13.7D28A16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 472B74000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:59:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne0UdLFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780581568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PK6He8yLNQWkv2PgUOFRWGLfoR85ne9HDtwMZbm83vQ=;
	b=GtBNZmM2djcujeeDE2Y02QfqRqIp+GbWqc8JX8eWpLGrzJRtQyTt1WQT0eC/KRUKMerRBW
	zci03pmA+Ow7jxtwfUyiIwHB/XHkEmtp1H2jo6qIUnFOt2xvKIp/ImCSFvvbQx4mNpZCpW
	E8sQWmq2dSC2oXeu3cM22nt4ed5AnYM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne0UdLFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780581568;
	b=KPmbVm18hEGbLo4VwPx3yUUY8GVn9geBxw01aBNqowyblRDkhffS1Gmq4ZTBwphsysEoGw
	KflwO74SJV5KXGqYPr8B4I0ua8QkKcfFZ2Oue27oBfKz3boeCw8l6BfE2KZjDkWdwXOCZ8
	PY4DaPNiIs72WYQ++ew3fv1ubkn/UhQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EED8600FC;
	Thu,  4 Jun 2026 13:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645231F00893;
	Thu,  4 Jun 2026 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780581567;
	bh=PK6He8yLNQWkv2PgUOFRWGLfoR85ne9HDtwMZbm83vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ne0UdLFWpvJWkgCN4U6kMVUmSl5yn7eBJrBejFttpqp1eeAWoilfDaobSDAYD/MZe
	 Qu58OZ9du34TwigHyeJKhthxSYbQuOFUEni9kL9NZo9/gFDBhjy1Ecb6TtMSHeTOAc
	 NogEJIX1l1Oc8+yPzuU7p1NYgglm+CTMutazKHD4RS6sT3KozcP8POsZZarGBJE+bb
	 SO9zBedXYpGR0TLjVuDkYsF1jSJKIfJKwmn+IbTewuxbltHIp5feLWZ/qgXLa8TFv/
	 /AkQELkUsRjAF+sodxr8+yokB/M9zOMqbHjj5MwKciQHdp6n4FhV6wLL12RwfKWsz/
	 sn762bjXClDJw==
Date: Thu, 4 Jun 2026 14:59:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <aiGEEcua8ebAKZWt@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <aiF25dvH4qd_C4aj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiF25dvH4qd_C4aj@lucifer>
X-Rspamd-Queue-Id: 472B74000E
X-Rspam-User: 
X-Stat-Signature: q4j9ng6xfzdog688846hkxdsyord7m9c
X-Rspamd-Server: rspam09
X-HE-Tag: 1780581568-886778
X-HE-Meta: U2FsdGVkX19vtSF5GdIHMxOnu80ytduo5fWFsnjPHS5uqZOcHURgciOp5nog3BEKVsMXK4FfPlZLlfugcV9jCv7U46ATkGp+Q6kD+IAQdcGsd8n0+yU66yjR5z9hJjH5V0ITpDtW+qne5QWvjACcRnUk9Y3GI23kVESpQBpXGh5jqcnWqZ+hi71rig20JTx1lsRN9I/TEY0RkOuyMIoSNii89ZXWxVLP5buFYw3m3zJuicvB3dMGQlZHsP6HqjvHsd98NaTrZCU6w+/ZokdFFMJW/CY84LQnBuphKJNhGIQZr7rYzjQ1jYrw8O1jTAFRFHMtGztGhy0yKCzoD9ZtO3EXoexiR4UchyY1089v0S5qlJjQm1IW0EePD4hK7fsmM/A7SCfyJlOz95ATmBrW7jiPrq59Xha1Ovv+RobfMrAb/IOwpmnwkDyBxTSNrygMZPZt3ZFJGQDEeYsgPLHTo+16416QqGY4vHCVHh1qMzPnHnU0pK7L2K8fs+xA4u2iTnNLVS7Yff19jns2iS60SwP3PxwfjUK2ikmRuLoMkukOkAdbpY41s4bmJ3UfR0xFfqNyfx24f9Z5f1Sr76srKiI2rfGRdeHu3AbSewTPQeoiN8An9el9nQn2HdfSG8LfE6bbPWRSvuhrgXot0FyVmuFvGE+wkq3ioV10uml9ymH0X0gWrcCOXPXFXnKl+rKuXE5BKJiJr2aqm3t+6wFUMOGrtPygaVLgc7mZcxxc7OLPl8+qfOqLb67SsK01N/a48WiT1TNlNgswyUL6+sV1I41V/BHa2a0XNKGi3HQgByc6Z8R7ObDQCHc3xUWH4t4z4HI8tFq0mr7Y9GMmad8cq5gucz10lsU/DKZm2qhfX4UG+6tu2Xj4BwTgVtmQhhh4kBK6wF7DJf9srBQgMCPrwU2NlYqrOfTaxD1WJh0cP5BKO+9nXFsXKe/pAi+I1BPadfSU9fDx0p1hsdHZbJ5
 py49ODyS
 uruI70uyZopq6XbkXCD0IpTbCXXN0thQl5dQWchpea+1u5X4bf7cLQWAXCBkX1BUz7zNTiz2573+8WsQp+3odOVgdQ2NBzcw2B3qpAP5EdomD4uyevxSKZNuMMqlkYIdmKwM5u5SvE86DK48RqQsaYn0T99IdLRDqKzHD38C98ww0WVi8rqcCnDjcJhvydbh0Ff86l9w+Jx2ALVwsTQGBxN72BEjaPJr/dFU/NwwmgARxA73TXDowIdTgoRKkN4gD7HvlV9s9E+hNYKf8iANkXfYLw0Ny2ZlrRb/oWEev3cwmEQIRwPqYe4fK4HE6jBA1gJxu+sNkd7T33+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 02:53:39PM +0100, Lorenzo Stoakes wrote:
> (Checking the algorithm here)
>
> On Mon, Jun 01, 2026 at 10:11:24AM +0200, David Hildenbrand (Arm) wrote:
> > On 5/22/26 17:00, Nico Pache wrote:
> >
> > Finally time for the core piece :)
> >
> > > Enable khugepaged to collapse to mTHP orders. This patch implements the
> > > main scanning logic using a bitmap to track occupied pages and a stack
> > > structure that allows us to find optimal collapse sizes.
> > >
> > > Previous to this patch, PMD collapse had 3 main phases, a light weight
> > > scanning phase (mmap_read_lock) that determines a potential PMD
> > > collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> > > phase (mmap_write_lock).
> > >
> > > To enabled mTHP collapse we make the following changes:
> > >
> > > During PMD scan phase, track occupied pages in a bitmap. When mTHP
> > > orders are enabled, we remove the restriction of max_ptes_none during the
> > > scan phase to avoid missing potential mTHP collapse candidates. Once we
> > > have scanned the full PMD range and updated the bitmap to track occupied
> > > pages, we use the bitmap to find the optimal mTHP size.
> > >
> > > Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> > > and determine the best eligible order for the collapse. A stack structure
> > > is used instead of traditional recursion to manage the search. This also
> > > prevents a traditional recursive approach when the kernel stack struct is
> > > limited. The algorithm recursively splits the bitmap into smaller chunks to
> > > find the highest order mTHPs that satisfy the collapse criteria. We start
> > > by attempting the PMD order, then moved on the consecutively lower orders
> > > (mTHP collapse). The stack maintains a pair of variables (offset, order),
>
> This is inaccurate, it's only consecutively smaller until you hit smallest then
> it starts bumping around 2 -> 3 -> 2 -> 3 -> 2 -> .. -> 4 -> 3 -> 2 -> 3 -> 2 -> 4 -> etc.
>
> More like consecutively smaller, then always trying for the smallest possible
> fit?
>
> Would be good to describe why we do this, presumably to get a best _fit_?
>
> > > indicating the number of PTEs from the start of the PMD, and the order of
> > > the potential collapse candidate.
> > >
> > > The algorithm for consuming the bitmap works as such:
> > >     1) push (0, HPAGE_PMD_ORDER) onto the stack
> > >     2) pop the stack
> > >     3) check if the number of set bits in that (offset,order) pair
> > >        statisfy the max_ptes_none threshold for that order
> > >     4) if yes, attempt collapse
> > >     5) if no (or collapse fails), push two new stack items representing
> > >        the left and right halves of the current bitmap range, at the
> > >        next lower order
>
> I notice the ordering is wrong here, you actualy push the mid_offset first then
> the offset (e.g. 'right', then 'left'):
>
> 			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
> 						 next_order);
> 			collapse_mthp_stack_push(cc, &stack_size, offset,
> 						 next_order);
>
> So that way you are popping the 'left' first then the 'right'.
>
> So seems you'll get:
>
> stack={0, 9}
>
> Pop (0, order=9):
>
> 	|----------------------------------------|
> 	|########################################|
> 	|----------------------------------------|
>
> stack={256, 8}, {0, 8}
>
> Pop (0, order=8):
>
> 	|--------------------|-------------------|
> 	|####################|                   |
> 	|--------------------|-------------------|
>
>
> stack={256, 8}, {128, 7}, {0, 7}
>
> Pop (0, order=7):
>
> 	|----------|-----------------------------|
> 	|##########|                             |
> 	|----------|-----------------------------|
>
> stack={256, 8}, {128, 7}, {64, 6}, {0, 6}
>
> Pop (0, order=6):
>
> 	|----|-----------------------------------|
> 	|####|                                   |
> 	|----|-----------------------------------|
>
> ...
>
> stack={256, 8}, ..., { 8, 3 }, {0, 2}
>
> Pop (0, order=2):
>
> 	|-|--------------------------------------|
> 	|#|                                      |
> 	|-|--------------------------------------|
>
> Then finally :) we get the offsets :)
>
> stack={256, 8}, ..., {8, 3}, {4, 2}
>
> Pop (4, order=2):
>
> 	|-|-|------------------------------------|
> 	| |#|                                    |
> 	|-|-|------------------------------------|
>
> stack={256, 8}, ..., { 12, 2 }, {8, 3}

(Shouldn't be {12, 2} there :)

> Pop (8, order=3):
>
> 	|---|--|---------------------------------|
> 	|   |##|                                 |
> 	|---|--|---------------------------------|
>
> stack={256, 8}, ..., { 12, 2 }, {12, 2}, {8, 2}

(Shouldn't duplicate {12, 2} there :)

>
> Pop (8, order=2):
>
> 	|---|-|----------------------------------|
> 	|   |#|                                  |
> 	|---|-|----------------------------------|
>
> etc.
>
>
> It seems to me that you're going to keep iterating down until you match an mTHP
> when a larger mTHP could have been had?
>
> So we're going:
>
> order 9 -> 8 -> 7 -> 6 -> ... -> 2 -> 3 -> 2 -> 4 -> 3 -> 2
>
> I guess the point is to avoid only getting the largest possible
>
>
>
>
> I guess if we did try to get the largest then we'd only get 2 of the largest
> possible then exhaust the whole PMD, should a PMD-sized entry not be possble.
>
> > >     6) repeat at step (2) until stack is empty.
> > >
> > > Below is a diagram representing the algorithm and stack items:
> > >
> > >                             offset   mid_offset
> > >                             |        |
> > >                             |        |
> > >                             v        v
> > >           ____________________________________
> > >          |          PTE Page Table            |
> > >          --------------------------------------
> > > 			    <-------><------->
> > >                              order-1  order-1
> >
> >
> > Reading this, it is unclear why exactly do we need the stack.
> >
> > Why can't you work with offset + cur_order?
> >
> > Initially,
> >
> > 	offset = 0;
> > 	cur_order = HPAGE_PMD_ORDER;
> >
> > If collapse succeeded, advance to next range.
> > If collapse failed, try next smaller order, keeping offset unchanged.
> >
> > 	if (failed && cur_order > KHUGEPAGED_MIN_MTHP_ORDER) {
> > 		/* Try next smaller order. */
> > 		cur_order = cur_order - 1;
>
> OK this matches the stack for the 0 offset entries...
>
> > 	} else {
> > 		/* Skip to next chunk. */
> > 		offset += 1 << cur_order;
> > 		cur_order = max_order_from_offset(offset);
>
> Then 1 << 2 -> 4 so go to offset=4.
>
> max_order_from_offset(4) = 2. so (4, offset=2) same as above.
>
> Then we'd loop back here and go to offset = 8, and max_order_from_offset(8) = 3
>
> And, yeah this seems equivalent.
>
> > 	}
>
> >
> > Of course, handling disabled orders. max_order_from_offset() is rather trivial
> > (natural buddy order, capped at HPAGE_PMD_ORDER).
>
> Something like?
>
> static unsigned long max_order_from_offset(unsigned long offset)
> {
> 	if (!offset)
> 	   return HPAGE_PMD_ORDER;
>
> 	return ilog2(offset);

Oops, we need the LSB so ffs.

> }
>
> >
> > What's the benefit of the stack?
>
> Yeah it seems equivalent. Good idea!
>
> Thanks, Lorenzo

