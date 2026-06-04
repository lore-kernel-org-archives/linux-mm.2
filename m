Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D41CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC766B0088; Thu,  4 Jun 2026 03:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D276B008A; Thu,  4 Jun 2026 03:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682DB6B008C; Thu,  4 Jun 2026 03:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 569206B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:35:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAC14C220F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:35:44 +0000 (UTC)
X-FDA: 84841420608.02.1A25528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2682D20005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:35:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDwBqXnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780558543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTbdFo/eiGyuAmjSs4sKcnxBavN3f7YIKZ6weBXs2/8=;
	b=ERUpNRvMEoLGhz+ubnxVgYZgxdT8SfHqpmWcJvn8U7Zr9ccMKNHbtuIDY9guLWR1rEvsO6
	nGNEb8+DQu+QLBuTPbpPmsxeRtMZpddZcY4TvrBzyFw5tiaRCSRPvZNE7axv0DZgxBNi6u
	kDVY6Fo/CejdPU6CDTDRlqrxtw826So=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDwBqXnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780558543;
	b=s1U3/5+xLOYNRUAyAlQPn/kODIDvtgwEo9RpyX2pafi5Gow0jcu7J/Y6RwjxblVJGKDJh5
	16NfCYlzZIJtoi9uKplR4mSkwu9L6j7kBmaBYVoWeFvbnjZBePXaMuU7lr7J4UEzVZWzXh
	MYkCQShm6HGBiCNA1otAVZ0S37vMedQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 519B04367F;
	Thu,  4 Jun 2026 07:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6704A1F00893;
	Thu,  4 Jun 2026 07:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780558542;
	bh=tTbdFo/eiGyuAmjSs4sKcnxBavN3f7YIKZ6weBXs2/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jDwBqXnKhVbnpDUK6fabMTZB0oLrH8R46x1dZH+YW9dHF0YaaQxDOmP4Vktvy3GLX
	 do3byvDj3Qpg6mxJ+LhYcl5uSt5HR28PZv5CL7KRuIsw0tWc0yg6wY5+rHD6qhsP+r
	 POFWnngBRtW/nP5iMbIGojzavGOtmwJxD+ylJDWzCITG7o5UQ5zbFJm5hjZ+UfGsC3
	 R+AR6WVYtQOtNIU+crVHPpUUDrBBnZP0n1D7qab63UjG0S63idM7lyWW/itp6z+LVD
	 fNcm7RpMLx8d3x/hkJZf+cjb35ywj3QwRr6tmqoAkjf/WaIz8BIvzuOqklV92M6MK4
	 G/UGnMh2UocKg==
Message-ID: <29bd5886-15c7-462b-8a39-f2ff25269ddf@kernel.org>
Date: Thu, 4 Jun 2026 09:35:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
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
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
 <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 85yiyij5hrrczmdnr5h3kzfbowpugdq3
X-Rspamd-Queue-Id: 2682D20005
X-HE-Tag: 1780558543-883035
X-HE-Meta: U2FsdGVkX1/PkZk/FPE/khV5twmffl8lsJ7s+7rxKeAYiN0HnwcvRjNUUPPFAbbKUoNxVbshqxYmnCwy/SnRHzsHfzOnr4iQVvrXDv7hA/r/8J6ZH6G95TwqsMLCjGv9hcJ0QIri+QS8dV9ha0efNsZitvIyJ5mNC20cG3fKJxrF2TxLF0LJSXCX70cTqkgiLqx8fTG2SG9IZk5QsGv4rKGt2SMfBDWdOLn1nC0vDjcBLwERhOlMLgbXW93bkkv8E1cS9pRRaFEQR3q2A2tWieDE3LRAwIvKHOy/ULtmjSCLaYAQICpH1f0NyIZT9MfccHRxWx+tkoXQHE/daYF7H6l5WsJnvkBeE7Ci9z+D/xoODE6AcbxUr7qWcuE9+Fj6qFx1pZPXHWrFRMquIyhKsOakDBa5BXJBQe5baSZfS5XY9bz8zBFbJSII3duL4d0s3JnV9ZGSmRc3XTX9gL4CoxnRhbSLLx3nFqRKtkbq6aBWBq1cMV9p+mIJ1GOC5TSfGis3ZfWHwMTWaPd5SjesbA+phOYdw3xwoCJoB8eG/3u3IKWQGClWZWt049z+JtBesUT6wFAi8Q0dTugiZF7xtroEUECVjMzGdGlG0qt+jHYB8yUCUdvY5Bnz2ZYOgfZC9r/nO3lll+uRYqBIEiCwAzrVDQChgRT5Q9ccmh5M8cXcGW9CIgvmuk8MLfl+jB6bgmLarETmohqulbEkDP3b+CyDmOyKpAKhH6l2QfQtiVc8kyGtybt1FzrOFXJWvpy5nqtrdlg8lyCixGSZeokqwvwr2i9q5DgtZQLLMsJm1x6AXw8BE/68QleOpLjlyEcHxvFTh18JEfxlxJ3oWoPTSrv03v7ejOlN1t4/GtpVEf+9tAC+2rBWjc12USup74LE3zwLmP824fbkpy2vjZjB/e2qDdPKcDccDun9duNXuT9jxHVCxcCQ7ll9Orgt16OqUjupImsAuHuUiVP8Hgp
 N3FCHW8K
 8p8x5irkASsPWvMUtn9td80Sv4oLVXDt+fc/aJhR12Lti8+At9LkbyQOreHof3fe3kBfCo8Gukd13BjzaH7+wZe0q/7N7WhBjfWJM896CYab67JJdKZvIAXVkbHFLpQJ28NpqGVaof7SO5I4Z9XetbKsEtVHpq4/gUahBe0U3i7wH5/T9ipd3lIffdQT9pwl52EjvWuCuatCsR9IPutlktfMhF+fBZevZ58ThT1pIk3H43L3xVQQEr8EilVLS+WLuzAfwvE5s6HN7rcvQK8qjjWqqAD/DZguBAoWrIHovYe1/hhn9GGNZW4rK7VOXfPP7wPr7lz3Hnp4gvAMUcvdfisC/XzM+AXVuH1qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 09:10, Harry Yoo wrote:
> 
> 
> On 6/4/26 1:22 AM, Vlastimil Babka (SUSE) wrote:
>> On 6/3/26 13:13, Rob Clark wrote:
>>> On Wed, Jun 3, 2026 at 2:17 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>>>>
>>>> We know p->pages is NULL in this case, right? Because it was allocated by
>>>> vm_bind_job_create() using kzalloc().
>>>> And the job can't be reused with a leftover value?
>>>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
>>>> Or should we set p->pages to NULL here.
>>>
>>> Correct, the job is not reused.  But I suppose setting p->pages to
>>> NULL would make things more obvious, so no objection to that.
>> 
>> OK, did that, just in case. Thanks.
> 
> The kvfree() -> kfree() part should probably be a separate patch
> with Fixes: 830d68f2cb8a ("drm/msm: Fix pgtable prealloc error
> path") and Cc: stable?
> 
> ...as the commit landed v6.18.

Hm right, but realistically, can there be so many pages necessary, that the
array to hold their pointers would be over what kmalloc() can provide?

>>> BR,
>>> -R
>>>
>>>>> +
>>>>>         p->pages = kvmalloc_objs(*p->pages, p->count);
>>>>>         if (!p->pages)
>>>>>                 return -ENOMEM;
>>>>>
>>>>>         ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages);
>>>>>         if (ret != p->count) {
>>>>> -               kfree(p->pages);
>>>>> +               kvfree(p->pages);
>>>>>                 p->pages = NULL;
>>>>>                 p->count = ret;
>>>>>                 return -ENOMEM;
> 


