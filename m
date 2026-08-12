Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA64C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B17B6B00B6; Wed, 12 Aug 2026 06:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061F56B00B8; Wed, 12 Aug 2026 06:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE21A6B00C4; Wed, 12 Aug 2026 06:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C445D6B00B6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:30:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E83EA2461
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:30:20 +0000 (UTC)
X-FDA: 85092247800.27.D3B1E2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B77AB1C000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:30:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9Pj1b9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786530618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znC2CN88BG6IQTXeBQOiLpi+lQCW+d8WSF+YoUrBydg=;
	b=jlGIRBO1KTzYDNofPBUFat6Gl3RT1IQ0yO764MZRdGzOIaqIgATBDhdz7sXOsFIrXJiPr2
	91IrLXffuHfRunANdBCdIoPx9n+7ODqPwtibdZ6tJ7Gc6TsY64PXy80s9C98SiJASO15yr
	rj8D3gmOOYXmlPiAl6cEccFyo04jrn4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9Pj1b9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786530618;
	b=rlMKQjZa4pgRqrlh0oB65kg1S3eSFH3SykCM+abquOsZVY7/bAxn90L0uNrsK1p3oKn6gX
	1tt1ggJRd6/YUYd0sOYL4SG4KXQ0cSoMm10VRbHZcGxYk5X2XKfrrvhkTJjImAlgnXdRhC
	FfUvrROSgNzX7048HVoxz9InMz5zxMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 000D6600E2;
	Wed, 12 Aug 2026 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5D81F000E9;
	Wed, 12 Aug 2026 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786530617;
	bh=znC2CN88BG6IQTXeBQOiLpi+lQCW+d8WSF+YoUrBydg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=g9Pj1b9ipHHG2W5U2n9DOTv9GT3WIObObGyVdg4AXrJMTok+rEBVU/yGd27pzGe5c
	 M+U9LUonA5FZR/MChw7GAMz2dR44WLdqo4V9UqTUZ75fQD1OztSVvZwOXk2jKGHEdK
	 vPvIjxARoEBj+06H5kiPp5fOXskYC4dU3sdCQfsmaoPIB5wV8QOhlrtQm8Ae8nAPHn
	 /C9wyKMIu7Syu8tKA0f7PxBIBWNGt4MzIIWY0szW++/8f5f1OKpQzYuLDc7BI2+N7W
	 I3939Qy2s8tP7lEcddCXfZ/UVBVT4qC1uDzZaqkuTRD9BrqiCACQGj/9N2Q1iZ8dR+
	 nYLEcUAy36iuQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Pratyush Yadav <pratyush@kernel.org>,  pasha.tatashin@soleen.com,
  rppt@kernel.org,  graf@amazon.com,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  kexec@lists.infradead.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 2/2] kho: unwind restored pages on
 kho_restore_vmalloc error
In-Reply-To: <20260812064428.GA144642@chenghao-pc> (Chenghao Duan's message of
	"Wed, 12 Aug 2026 14:44:28 +0800")
References: <20260807075128.542806-1-duanchenghao@kylinos.cn>
	<20260807075128.542806-3-duanchenghao@kylinos.cn>
	<2vxzcxvo518j.fsf@kernel.org> <20260812064428.GA144642@chenghao-pc>
Date: Wed, 12 Aug 2026 12:30:14 +0200
Message-ID: <2vxzzeyr3a2x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: B77AB1C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: aypz8uheygfa8hwjhr438fexctihbr4i
X-HE-Tag: 1786530618-705562
X-HE-Meta: U2FsdGVkX18u1opaDzh6joDbu0RSNn5/NxCGDRBkpwv9l/rLyZA1LMHxHZvgC8A4obbFh3XAxlx2oZj8hKMcl4i+bxD7Xu5R6jLlq4x/EtWg6lz3uRQz9vnlhqIL5qi6gXnox0KIMLqgBpL77931XbDVX3v0tQ2m89eIKdQ5D3voN5coZo0kR5kVsS/4lEA9KH1eDY7hrFzErwSDGu5g+xV2pVFjWF3OL8GIGJLwfaKGD4EDWkQwW0tn69wpRBVftSrDyepVIqPVPFO1fHG2JH+0XH5V1mJqvwWQtx3QhcRfNIDz+I/IVoqNtoSjf6WNyZDv6SUbVYBYVB3X0iRfnySbtIOFHu3OPi6AjGoVEt2q1G/Yy+uE1/ZfZEV1urfGdaJl2QplqIsXcu2w44CzLxUu3wwlD4W40H1CAnF6us7k9ZusVkyq5mwnMP1xGV9Fb2rfVuYlEaFi7Hyk5Vjuez6QAnzgJFVC7l1HRpo5apU4h7xm8SMASvtM+9ql+pVHOn2H4zsZMBWDNwMeTa6O3M53GeU+rAq1Z2cd6ABAvvdDY9bgjOry5rGX5xX48/wY2Xmd5NEqG1vdMRHcb4pyqU8ziVjKtcVF+ZOrco/vynQZzoAU+dc4WjJwVgXzLd7eZsjXduHRHiWMQXRaFOWwhmiEs60ybvCkz9M2y0lCkHnO8Icv8xGGUQcVOnxhLGqXwLYp9bepzPfqo9xN9V7WEbRdyIkMuwA+4LHRg9/RirvhXzDr79Xl6j6p3OUaJ+ys026Y6fzhZKgXj3Py2q6t5LI9DkGzdBcq3kbT8ldY5wi911+9qwg91lFRMPkDcwv/a/d3g+egk7vPLU3EJb1/NS6u3pz/etFZzc/pRNd1bu1E1D7eoXLMtzDQn8wRxk/zWRGDM6P7DMAlgVw3IwZQabnmfacPFmMmrFaJKDJF42Y/aRXSAk4pg4dASBfYYAQMgD39givUnFsTUJAD7L4
 NUOTw16C
 JazHC3Bpf+8biAFCNSvcwDJ9sFO0c0tRZ7d+94DsJfL77W03+k6VgLz0LcFnPgLnPwD1yXYykjgaOjVBV/JDESRckt4h6JtEO5znTrCgD9xbeRe94FWwaOeGXrBF4gVrjtZXyk+hm+FzDjTo1C1SxP3SKKAdoA9hHZ7HUWwARHOlztJQ2C9WpLJ3WzfqmOI3Jtp9l5rkMGNYaZaWtoYexeMoSj6hEia2kiQ/0un2K4Y12who3gA0/TpnUS9/9zzB6n9dPtiMC+KRIZQ8/kMlrJ+pQBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12 2026, Chenghao Duan wrote:

> On Tue, Aug 11, 2026 at 01:46:04PM +0200, Pratyush Yadav wrote:
>> On Fri, Aug 07 2026, Chenghao Duan wrote:
>> 
>> > In kho_restore_vmalloc(), when kho_restore_pages() succeeds, the
>> > recovered pages are handed to the buddy allocator (via
>> > adjust_managed_page_count()). If any later step (e.g.
>> > __get_vm_area_node() or vmap_pages_range()) fails, the original error
>> > path only called kvfree(pages), leaking those folio pages.
>> >
>> > Fix by tracking how many folio groups have been restored with
>> > restored_idx. On any failure, use err_unwind_restored to walk
>> > restored_idx backwards and return each folio group to the buddy via
>> > __free_pages() before freeing the pages array.
>> >
>> > Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
>> > ---
>> >  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++------
>> >  1 file changed, 17 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> > index ba03ff5baa9e..ed35405f59ab 100644
>> > --- a/kernel/liveupdate/kexec_handover.c
>> > +++ b/kernel/liveupdate/kexec_handover.c
>> > @@ -1161,6 +1161,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>> >  	struct vm_struct *area;
>> >  	struct page **pages;
>> >  	unsigned int idx = 0;
>> > +	unsigned int restored_idx = 0;
>> >  	int err;
>> >  
>> >  	vm_flags = kho_flags_to_vmalloc(preservation->flags);
>> > @@ -1183,11 +1184,11 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>> >  			phys_addr_t phys = chunk->phys[i];
>> >  
>> >  			if (idx + contig_pages > total_pages)
>> > -				goto err_free_pages_array;
>> > +				goto err_unwind_restored;
>> >  
>> >  			page = kho_restore_pages(phys, contig_pages);
>> >  			if (!page)
>> > -				goto err_free_pages_array;
>> > +				goto err_unwind_restored;
>> >  
>> >  			for (int j = 0; j < contig_pages; j++)
>> >  				pages[idx++] = page + j;
>> > @@ -1195,13 +1196,14 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>> >  
>> >  		page = kho_restore_pages(virt_to_phys(chunk), 1);
>> >  		if (!page)
>> > -			goto err_free_pages_array;
>> > +			goto err_unwind_restored;
>> > +		restored_idx = idx;
>> >  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>> >  		__free_page(page);
>> >  	}
>> >  
>> >  	if (idx != total_pages)
>> > -		goto err_free_pages_array;
>> > +		goto err_unwind_restored;
>> >  
>> >  	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
>> >  				  vm_flags | VM_UNINITIALIZED,
>> > @@ -1209,7 +1211,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>> >  				  NUMA_NO_NODE, GFP_KERNEL,
>> >  				  __builtin_return_address(0));
>> >  	if (!area)
>> > -		goto err_free_pages_array;
>> > +		goto err_unwind_restored;
>> >  
>> >  	addr = (unsigned long)area->addr;
>> >  	size = get_vm_area_size(area);
>> > @@ -1231,7 +1233,16 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>> >  
>> >  err_free_vm_area:
>> >  	free_vm_area(area);
>> > -err_free_pages_array:
>> > +err_unwind_restored:
>> > +	/*
>> > +	 * Pages already restored via kho_restore_pages() have been given to
>> > +	 * the buddy allocator (via adjust_managed_page_count()). Return them
>> > +	 * to the buddy so that failure leaves the system in a clean state.
>> > +	 */
>> > +	while (restored_idx > 0) {
>> > +		restored_idx -= contig_pages;
>> > +		__free_pages(pages[restored_idx], order);
>> > +	}
>> 
>> This looks wrong. These are 0-order pages. You can't free them at order.
>
> Thanks for your review. I've looked into the preserve code. The order
> defaults to 0. When CONFIG_HAVE_ARCH_HUGE_VMALLOC is enabled and huge
> vmalloc allocation occurs (vm_flags & VM_ALLOW_HUGE_VMAP), order can be
> greater than 0.

No. Higher order pages are allocated with vmalloc_huge(), but they are
split into 0-order pages once allocated. See the split_page() call in
vm_area_alloc_pages(). kho_restore_pages() follows the same behaviour.

>
>> 
>> I sent a patch to do exactly this a while ago [0]. At the time it was
>> rejected with the below argument.
>> 
>>     Hm, I am not sure if KHO should be responsible for freeing the
>>     restored pages. We don't know the content of those pages, and what
>>     they are used for. They could be used by a hypervisor or a device.
>>     Therefore, it may be better to keep them leaked, and let the caller
>>     decide what to do next: i.e., boot into a maintenance mode, crash the
>>     kernel, or allow the leak until the next reboot.
>
> Could you advise if there is an existing solution to handle this scenario
> in the current logic? As things stand, taking the error path results in
> leakage of buddy pages.

I think the question is if we want to handle this at all. Do we want to
free the partially restored pages at all or do we just leak them and
bail? I feel we _can_ get away with freeing them, but I also see why
doing so _might_ be problematic.

>
>> 
>> Although thinking about this again, why would any device or hypervisor
>> use vmalloc buffers? They should only be used for metadata. So perhaps
>> we take another look at my patch? Pasha, what do you think?
>> 
>> [0] https://lore.kernel.org/all/20251118181811.47336-1-pratyush@kernel.org/
>> 

-- 
Regards,
Pratyush Yadav

