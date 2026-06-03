Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A79BCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB806B00BB; Wed,  3 Jun 2026 12:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792DE6B00BC; Wed,  3 Jun 2026 12:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9316B00BD; Wed,  3 Jun 2026 12:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 560F86B00BB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:22:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CE4E1C1A6B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:22:48 +0000 (UTC)
X-FDA: 84839120016.10.89260C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2DA7A1A000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:22:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KmKmrL6P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780503766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxPhfVSO1PMBoWPiKi9ZwlNxfl6TXOtrDKfoICaOCcw=;
	b=QfPT+in/fuKIXkt5Twe40388/bvcqcXTgXxG7l3kSCd4FCFYLJC1OAiiH+NIAwEfCxOhNd
	APYP7XNwIPdyu0uf+JbUyyaUDn0jUmizfbXz3HvmJuT2H/zA6mFzajI7TeubYl1RTsAwcq
	jkYVm/TPGNkPvzRe5dX6Jwfgjxe7Trw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KmKmrL6P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780503766;
	b=5WgUafsEY+Qd89qX54VmvKoOSixE4mdDad1c9FnAn+mrT9+/7L6rxl4zgIUW+C2V4gaZIn
	82/uZ5LXDFCOwyC44mvbxvywb3TxEF7PYiG/MAkYFjm/yRDWky6E13Lt8kZFxQhLdKM4E0
	Gg9awDjMwR7ABgC50b3Nyw9We5Qn3rA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 146E34169C;
	Wed,  3 Jun 2026 16:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024BF1F00893;
	Wed,  3 Jun 2026 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780503765;
	bh=CxPhfVSO1PMBoWPiKi9ZwlNxfl6TXOtrDKfoICaOCcw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KmKmrL6PswCLcYojvpvZX8QoCfztwKuJFaEFgpHaGxc3Vpz4WNJTGjNXUOdXgBMPG
	 pfvWqWoQhPOk9xY3gH/FSWhOZBMAJNdcTVkuJHaEyWSr/cUJ25JOb/wA87+CGgvHXq
	 8XHpMxjqKz57R+JVa29dzsNEtBi83+f6n5FGjxq9GGtG+zV1XSEVZ0JvFzn7ctkqvQ
	 65peuRFmiA22Veq9kCRGtqCIkm4VxBh1KBgl3MiXlW5TUyQq5VtyopJIJTmDuMz5A9
	 m6OudFzZkl4NQNqflq8rui6SMZo0KpZecbcFwKBdkVPTowovyF4pt6+gQEpKWBADT1
	 yIzkRHuRwpS8g==
Message-ID: <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
Date: Wed, 3 Jun 2026 18:22:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de>
 <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
 <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DA7A1A000A
X-Stat-Signature: 7qwsg9wbyy6cp7upbp5oxmtq98csbhei
X-HE-Tag: 1780503765-252931
X-HE-Meta: U2FsdGVkX19tNdkMHZYwXevyEs7ZN9uTBVnO5NszkUOypPLveshI84LfmP0n46wClBVXmmq+yds7U2khtPzCSEUi32hnW6+EJuLOSZ2PqSziGU0h4U+B43r5Bkzqjlmz5+s6u501Vg7MmkZaph4pMOtydmyviui3Kv9jnsCxbY2od7n0LonqEspfjXuAi1yPJtCBjTKz0H/W7rZRCKw0LCDuA2L7NJrp4b5FKu3uiJFGBR9mBypSsXujQFUEp7uQ96vC9ewXD8a20n6XM9Ovvg9/AtsaDbLoAjn8imivBamjtVO3lCzW9JI8NzZl1S72lukgO7jJ4ULp8aYTNXe7y+QlurLj7/FmHdXPAt7zzYvBXL5qt7+Jnw0Y+iPVo3uxLflVa6kreOzIV5cYBoftUnxo+sxmK/UAlmGOF+LOl6xi5ClOXma6sMTEcDGvNFt+//q5764ZNxLpF4C4EGMBmjJYya2D7qxkSd+robnfORZxFonL7hCXE2TcufmrEllJIsfrrv+m3Vgm/w5rONuIRlRA16Z23HBWXfpi4p/DmEk4Sd0lru12a8SVNG9qgKlr1BLRgbnwmmvLe6ptBZgS7N+ajLqdiiJZOVF5gvA2g35OUt8KWUq7swruJdwssF5kw8Up/8k8JP6qOjBqh/4eh7nh1Iv1MGcG0u6F5mDArPIWkwwZZRxJkl+QrgXDbvK3g2PRoNmvp0lTBN5swvdovFJY2UQDmYoFvX0n/lwZjY6fpmZ98r/h6y6Nz2MhmZfEmjqI5PzhXzW0L5AIc+cRTbbF4rZMT3lmLnCdwaTV3DHK8LYWS8nrHHz0Tv9aedAFNm2CVtt0zP6Fbkgojt1Ny2PqLPojH1x0+8YZDwEqIJkGDKtdAH2JXJJj58LmKDyTxNjw4h/qBoPhoRKGhUHY/B385R4Yb4vwDddZ3WAnnvR4A8NwYZMTsexn2vpZo4uID4KMtRpWP6od6sd/8qF
 82tpidu9
 ejrRIqEmiNzXBGQFofbmCxGKkm1pSUGVVldG4BBN1e8V0En3dznC889ADwmxtBrADPNF0j5974+Yy9lpkPh56ScdXhicu9wYbOpj+r2St2xrmeVLlQsaKb9N5h3SwyfLz/l8hEAL1jt12P4EVW+pB+HgV47wzSQ5HAHk7amubDzwDvSmwNW3vgNTNpgFIFz5kPn8ArR5T4EUY37rZdwqfwbORtc5rrq5yqexNBCqRyLcvJsq/vBqDX+qHIStOVGWL4fa2Q14gi1NsGzLmHPdHuEpiG082Edg1ExeDebzBghqrSHOzd64T3e8VPQssxhMIZWeEIvIc5b02Y7zwjLq2+e3ANzN+7nZ41iD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 13:13, Rob Clark wrote:
> On Wed, Jun 3, 2026 at 2:17 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>>
>> We know p->pages is NULL in this case, right? Because it was allocated by
>> vm_bind_job_create() using kzalloc().
>> And the job can't be reused with a leftover value?
>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
>> Or should we set p->pages to NULL here.
> 
> Correct, the job is not reused.  But I suppose setting p->pages to
> NULL would make things more obvious, so no objection to that.

OK, did that, just in case. Thanks.

> BR,
> -R
> 
>> > +
>> >         p->pages = kvmalloc_objs(*p->pages, p->count);
>> >         if (!p->pages)
>> >                 return -ENOMEM;
>> >
>> >         ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages);
>> >         if (ret != p->count) {
>> > -               kfree(p->pages);
>> > +               kvfree(p->pages);
>> >                 p->pages = NULL;
>> >                 p->count = ret;
>> >                 return -ENOMEM;
>>


