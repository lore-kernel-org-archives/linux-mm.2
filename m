Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B56CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986876B0088; Wed,  3 Jun 2026 05:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937166B008A; Wed,  3 Jun 2026 05:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEE86B0092; Wed,  3 Jun 2026 05:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 707CC6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:17:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0172C1202B2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:17:52 +0000 (UTC)
X-FDA: 84838049226.21.B5C7EF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 360531C0002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:17:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NkYh6RYz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780478271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0pUtaR4+MO5aeujygdu2I6w5ZAQoI82CxqwwUxfoiE=;
	b=ap5ktOXC8YNwvxTwDHx777YCC1iPozfbjbWXbSutXYZPjiW06+Y81baimn8DRYpTr8CgY5
	aZMVGQjKlAM6LclB8vTWt8IwMBxzBzqzMshwsQUf4U96l/hv84d+DjS4v9E0+aSvtmtJuh
	sFTE9auMFOl9Z2c403zaGLrDW6A+H8o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NkYh6RYz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780478271;
	b=XexcM4Gd/A+X+T/KPIVyE/sucZUzlxTQpocWqYxudVGUPoI3GCBx8pZ0A1XTedV8JOF9zm
	ejqH0H10cp6c8fb25pkrLAyLKZBJFbMrzfK3CKhQ4imG95W3NZ3HlsUJ/bx3y8nFYc7oOL
	2lXz2iIaXF8+50J9rZEqKSOvk+LUfmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4998A4099D;
	Wed,  3 Jun 2026 09:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491851F00893;
	Wed,  3 Jun 2026 09:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780478270;
	bh=M0pUtaR4+MO5aeujygdu2I6w5ZAQoI82CxqwwUxfoiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NkYh6RYztD/v9Cd5qUUF+73iEm/9P8Dxg515rIIt8cpNkQXn0uWsbSjzZ94uOOdJT
	 8lr2VDF/pFtEj8vN8v2caT9WCT2G9Z4Rq6UiHuCW/5CM0K/fYFpJlmzxzzvELk0/uq
	 BVOLqgNF9knDhwESnGP5ZFMste8UryYsCYqyJ7VFjS0OmKQkf1uy9VheypRjnl2pvZ
	 xlHfC6AbaKXzeHOGbNyuhpkqOZUsbCol0WdydURkXHIocM5fXBl244JSyT3vk5npBp
	 gRrddaqENxSHYNaMAO7aZvprpMklJyWR7Frr7S1uw1kJfHZkXs5zXbnpDTfZihHg04
	 6J50JPcqEnSKA==
Message-ID: <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
Date: Wed, 3 Jun 2026 11:17:44 +0200
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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 360531C0002
X-Stat-Signature: 9y7knzmx84piwmrngogumoob6pwcyjd4
X-Rspam-User: 
X-HE-Tag: 1780478271-957904
X-HE-Meta: U2FsdGVkX1/TI7OaQjc3eFY4lMw+RIlZCi1NKg0HYLZ9SUCvUsnVgBpE1EqT7y3jFelIPU0mCTvlwY0fUUdV4/OaoniXG9U0AHEFsS90daTP9Is8ZXNFXw4PRMJfkQr9/vYopVdA+LrIOhZrU149xnVYvdDdTm8Q8Cm7r/TmTVzEo2Um3XABrL91uKgnCZzXFRnCEr+AW6A7AuJ4jliRcL/eajgcDRNGEp3sBWPPxqAo7qwGw/siCe4QtlUk1/oX5nNzyOhr6aROGqBd8Fga0hZnGL9+tNbUEfriloYUJAQIDVpmTOxxbX70NHg+98PDAZdhwhxeZk3Vk3p7VYW2JlIJ23qO3JuxQxktACuMuQKK4RaNalKb4/9wJeoUqTdrMEAP9atTU8hWTaxV4HfHAGDbHXGdakO+O0lTzXeCRc9boBqp7KMlyedwl6MlqKLRsfTrmoiIXG2rfAjIWrMSyyvTazfM0kxCvAuJg7DdfW/doa8gq8h/CHLY1ZX4qGyPCXC412qOnixiCHpyptZNysLnv3VdJ9pEuLxa/zlV5sREEYH+tpg18bwwoOPFsAq2UXRb1MvGGgXafVICmmOagrRFtOdRODl1TJAjmQtde6LhP47HkxwghAgrkqM4Gtl6KLDNdxXU8VAKOAPdMZ7YzK46N04h5H+27l6IunQ19UB4x+CKbk8r5e1dY+pxlXyTNkjHE8D9Acmqe7zR+0brGjlQg8xXYXNWguOCExr7RkTws6QGSdneRziwTK23oFSmZswltgue/xrn9PuuZdRCFjO/JUI75bdhXGxV8rAhb13DZTgUNSBqW+MpFZrMXXsWM0AyXvR6SDPD1IMgReTzMRUREqVpikS8u6F4AWDhBuC1BpR4J2TOj6irykjsCFzMFLgux2V2TZjCXThqtEwQy8mTYRb8kYOG5apIBC9aE4qUOBjcLedZJgwtI+EAALyrdLzskpBnrKbq60BVqhb
 DKcG68Hs
 nTr2+Z2AXc3XYq5qTT/eOO25gCbyz0SJrL/QPAw2rFetD5js/01//7M5wDQeVXslaeodgrR/ajH7DfMoqRP4HuDVSK/KsIN1pDZ4XwW5YrAiph0kFuyiKxOzOygTAwfSdhF/84zp/4dtC61YCbXZVbBdJ/RWh2ZJqTjHmb+i+T6Rgd6jpuQRUjvuETmrBNtgqquI2fU+X7UT2T3Um9IYZ6SzYl1TJ8pCibuCiZTIt0QjGvw88MAqsbeMRT3TiLvPNVtSjMuSqEaxpsVyojZmvQUbQ+lhdUmZprsFfi9NJnLm5cFy/iiyQ5xRJxnsJpUtTo8Mu3O7FP58RVnl/gWqF896Tk57t91Sutv+QvCHMfBr/VfM5k4EqN3SiDN+rYHfAQbYk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 16:39, Rob Clark wrote:
> On Mon, Jun 1, 2026 at 6:32 AM Rob Clark <rob.clark@oss.qualcomm.com> wrote:
>>
>> On Mon, Jun 1, 2026 at 5:50 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>> >
>> > On 6/1/26 13:38, Christoph Hellwig wrote:
>> > > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrote:
>> > >> > kmem_cache_alloc_bulk() returning 0 was considered a success in that case.
>> > >> >
>> > >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
>> > >> > user sounds fine to me.
>> > >>
>> > >> Would it be wrong if we just returned true for size of 0? Would something
>> > >> else break?
>> > >
>> > > I don't think it is wrong per se, but it feels like the wrong kind of
>> > > API.  I.e. I don't think the MSM caller actually wants this, as they'd
>> > > also do a zero-sized kvmalloc.
>> >
>> > If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages ==
>> > ZERO_SIZE_PTR but then nothing breaks because nothing tries to dereference it?
>> >
>> > msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch so
>> > it seems it's considered possible. But then the rest of the functions also
>> > seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothing,
>> > kvfree() of ZERO_SIZE_PTR does nothing.
>> >
>> > It seems to me kmem_cache_alloc_bulk() returning true for size == 0 fits
>> > naturally in this world and is less likely to result in a gotcha?
>>
>> I think I was probably expecting kvmalloc(0) => NULL ... but it
>> happened to work out before
>>
>> Adding an "if (!p->count) return 0;" at the top of
>> msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
>> if you want, I can send that patch (but traveling this week... so
>> let's see what I can do)
> 
> Aaaaaand.. sending patch from hotel wifi doesn't seem to be a thing
> that works.. but I've tested the following w/ deqp-vk cts, and works
> as expected

Thanks, I will amend the commit in slab tree with this as the easiest way to
go foward.
Just a quick question though:

> ----------------
> 
> diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
> index 7d449e5202c5..ef744d154bbe 100644
> --- a/drivers/gpu/drm/msm/msm_iommu.c
> +++ b/drivers/gpu/drm/msm/msm_iommu.c
> @@ -332,13 +332,16 @@ msm_iommu_pagetable_prealloc_allocate(struct
> msm_mmu *mmu, struct msm_mmu_preall
>         struct kmem_cache *pt_cache = get_pt_cache(mmu);
>         int ret;
> 
> +       if (!p->count)
> +               return 0;

We know p->pages is NULL in this case, right? Because it was allocated by
vm_bind_job_create() using kzalloc().
And the job can't be reused with a leftover value?
(msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
Or should we set p->pages to NULL here.

> +
>         p->pages = kvmalloc_objs(*p->pages, p->count);
>         if (!p->pages)
>                 return -ENOMEM;
> 
>         ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages);
>         if (ret != p->count) {
> -               kfree(p->pages);
> +               kvfree(p->pages);
>                 p->pages = NULL;
>                 p->count = ret;
>                 return -ENOMEM;


