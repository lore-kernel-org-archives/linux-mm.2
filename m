Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAF4CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E58A6B009B; Thu, 18 Jun 2026 10:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE696B009D; Thu, 18 Jun 2026 10:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FADC6B009F; Thu, 18 Jun 2026 10:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54A156B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:56:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2A3A1649D9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:56:07 +0000 (UTC)
X-FDA: 84893333574.22.C22857B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 117C6180007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:56:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiS9zC0m;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLkvsKDIpeWJXlgIYVB32lBoMRPSa8FWaCkX6ep+JFE=;
	b=Dl8g6NK08W2iEZih9e5TdQC4GPz9Qn1evvFiTdLUDZaJvnxxFiFEFMnkarB+hPt07/+WQi
	PLy+zVKgSB2G6vg8fBhd81I3PV36FqBokfXRprt14dzyaqywtKkWK5xGYmVU5b2LoEQKid
	yPhfvN3IzAYF/sX68G0lw7za7OSeJGU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiS9zC0m;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794566;
	b=Uqt6rYjjlHYIw048O915kReXG/l6Eiz7bysTFAQGcUh4/+1f8V3ReDHGARp+qyTjxs/7Ed
	LcRZssTQyOHR9NuHAv6/7VuQvXpdVqu6svgAXXxmqUP8FJa8P/21MuBaNdy39QagYlBW/i
	JJr/CJ6GCRnaqQpSyWNv5qenLo8HYQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2889E40B86;
	Thu, 18 Jun 2026 14:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08AB1F00ADE;
	Thu, 18 Jun 2026 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781794565;
	bh=ZLkvsKDIpeWJXlgIYVB32lBoMRPSa8FWaCkX6ep+JFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CiS9zC0mrDh/0aoZXVQlorcFy6xmC+PCNOp3WuHTuz7cdZdKqY8RZ2otrmhx7ilt+
	 kIrAL0YoWayGg6SSJqFJT5f9Eh9oIGcnNdzHpBQRnl3c2/WfZ4LM2vuIKOqqAkGEUj
	 NDJB8DUpQA1lkobsFnslqkvEOy5zMLrgKRnbLff158C2wJTlH5xul1+y5iKpcdNTsB
	 3DWE5fktuj4CP0/jGg2sBuK9UbsvmLZlxxdebJLeUn/4j34uChqgRK32ids1MtFfv8
	 EOZygVeh0uzawE5mlLvgEiXlA5R2HqcRssivaz80PI4lZ5SltFiuNK9pFN01ztFZSP
	 G3sDreBjx60xA==
Date: Thu, 18 Jun 2026 15:55:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, Anthony Pighin <anthony.pighin@nokia.com>, 
	linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajQDVAu9b-LX8gUQ@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617192928.GB231643@ziepe.ca>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 117C6180007
X-Rspam-User: 
X-Stat-Signature: oapu87hnw9wda6yjb1m6by9gjtud1mds
X-HE-Tag: 1781794565-294577
X-HE-Meta: U2FsdGVkX19qnOU4GlrCiep9Hi1RqpOQlPyubwzf0ehm0TzqIFShI3222TibvQMZF5wmFScpmJLwqc7cLxnAFFGZ4mo9gocickMJacl60c3Y9/hUNzaP6OOp+5VPNveqq+3WhqmPN07ierXkrGpz6NGo7abKI9hWxwuwm2PqeTrEPmJ0MqmtX8rsHaYEK71vr1FWeU2Q2oAt7WzPSw4GuEhm+GqUyQ5hWlwY9ysJ2hRU4eUUb1PWNe7Sp8Nv8qaxcgzuZ1mHFamF6Q8qeueIXZ20kLvJvxkHnMWe01MpdJOCWllf9JJktEv2n67EtH9qAyZEBOwiuCseorTA/eljBPPn1rtHCGjHpBeuskVAytRUXBtZHtbALLsJnzlrSUnMLlagnTEpKDLBCmt04RuXlD+hftNNpRIiGK6w/1QyPv5o1rnsIA0JjC1dLotWd0iwOvm4E+NRg2/MrOtCNzqNSo26SMnX4Qrc9fL01xu5VVDN7ELtgSPEJfn0JbFIchZPzO+FpBSnNctPZB2WYsap8zWo388Omk2WsEiyZTzjpGEjtzxflFR1Fpb/gmELynrWPvlQ38q40t5T0OJCJQbKha6NntbOnWwmJNKM/wTH0f+zCwtkWeezEtJe63NOVndAkiOj7DiS4ubpHwg8C9hMfdxrskt/ngJVw1Tt+02VbIHXZWGFcBCB2zps2OIz37Dik49dkk8++TU7ahegGgHAzoe2G14KRgPqlpD6zatxImcEau66xuW9WzmVZ52Xs9AsjBBvALhN+vKsBTrYjjdIShHoOz8THOT6Tim0Y6ZMvRmy9ICgDp1+LTx/rwwiaVCanSzBXfQ7ZzSiJhLj7juhjCmu+K33QbWX4y/wIVQXvutS9fVVrEb0n9JNF7ClxXNjUAWHHYcIvKyFyNkOBH06uiwDjTJ2fAHxLl1IxGBCN48AwlgZpaDIZIXGREjbkdozrR+Vveq2UvlE/1XVwmK
 DXpPSTUR
 kkDF9KQgLSjn26uFabeST9e2QWneWeqY8qBQd7vrtNPrcXRzyXYm5pAIY2Zevg0DZbmhExSisG92xw23dsoWx7r+pz2OyYTPsFRkcy3F7xnFyfFNYFbzrUplIssTWqqlzBYYX0KL415OdUIzAIwlIcoLz8+il/ZyWsI+sw5XTzw/S1oPd+XeoYgrAFNsqA3q1x9qFrqxhC69GfWldzg9iEDrDXTiWpn2tyu4H2j1QG5NhJ6MwQNmm2tKsWhTyb2KdP7+J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Ryan for contPMD

On Wed, Jun 17, 2026 at 04:29:28PM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 17, 2026 at 07:34:06PM +0100, Matthew Wilcox wrote:
>
> > I don't see this as being something that drivers should be involved with
> > at all.  The MM should be able to get this right without any hints from
> > the file-provider.  Yes, that means I also want to get rid of the setting
> > of get_unmapped_area in ext4/xfs/other filesystems.
> >
> > Looking at generic_get_unmapped_area_topdown(), I think we can do this by
> > making an additional call to vm_unmapped_area() before the existing two,
> > setting info.align_mask and info.align_offset appropriately.
> >
> > Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
> > then >= PUD_SIZE), but we should also take CONTPTE architectures into
> > account.
>
> The info.align_mask and info.align_offset do need information from the
> driver based on what it intends to map into the VMA that is being
> created.
>
> Filesystems probably have quite different requirements than drivers
> using remap_pfn() or vmf_insert_pfn() that have locked down pfn's.

I think part of the problem here is that we don't differentiate between
drivers and filesystems, and what might be sensible for one is perhaps not
sensible for another.

We're too generic really.

With mmap_prepare we have a lot of flexibility as to what we do. That
callback is idempotent and as limited as possible, and actions like remap
are achieved through calling a kernel function like mmap-action_remap().

With that interface, drivers are declarative more than imperative, and
_they can tell us stuff_ :)

That seems pertinent here.

And I'm more than happy to have features that _require_ mmap_prepare.

>
> A pfn driver often has a single already known physical range that it
> will use for the VMA and that range should drive the alignment
> decision of the VMA.
>
> vfio in particular has common use cases where you want to mmap from
> weird offsets, but we still want to achieve a VMA starting point that
> has pa % PUD_SIZE == va % PUD_SIZE. It is impossible to do this if the
> thing building info does not know pa.
>
> I do think it makes sense that no file provider should be computing
> the VA area itself, I think I made that case when Peter was last
> working on this. Now that we have Lorenzo's mmap changes maybe we
> should be talking about supporting VFIO by having a callback to obtain
> the starting pfn for the VMA. Usable only by drivers like VFIO that
> are working with the pfn functions.

Can't we figure this out from what the driver tells us when it invokes an
mmap_prepare action?

In general I have zero trust in drivers, the right basis for dealing with
them is that they will do the most insane thing possible (and you're
pleasantly surprised if they don't :)

Callbacks are problematic, they're not neutral (context/lock state/etc.)
and you can't necessarily make assumptions in calling code after a callback
is called that you could before.

Can't we figure it out from the PFN the driver tells mmap_prepare about?

>
> The starting pfn and VMA size is enough for the mm to setup info
> suitably.

seems so? :)

>
> Maybe other users would prefer a 'max order' callback and then the mm
> would assume the VMA will be popoulated with pgoff aligned folios up
> to that highest order?

Not in favour of that, fear it'll be seen as a new go-faster stripe.  Ask
somebody how many free pints they want and they may veer rather towards the
upper bound :)

>
> > And maybe there's a CONTPMD architecture we should also consider?
>
> ARM HW supports "CONTPMD" but I suppose it is not implemented..

Maybe Ryan has thoughts?

>
> Jason

Thanks, Lorenzo

