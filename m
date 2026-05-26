Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE68CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 20:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E05F6B0005; Tue, 26 May 2026 16:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B83C6B008A; Tue, 26 May 2026 16:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880B66B008C; Tue, 26 May 2026 16:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78E816B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:57:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BC411A046B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:57:19 +0000 (UTC)
X-FDA: 84810781398.01.AC78341
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id F256EC0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:57:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LFtzUVc+;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779829037; a=rsa-sha256;
	cv=none;
	b=YsSsvRgBGyjMT9nmVOwrkJVecVDFG/Kzsy6ffhm6d1vptwIVNX8QwZt9qaJgbkXOVDQwcZ
	kJBP2/+nEdpTExvroMTIoT1KP9N95k3SH2SZNE0biRsFu9pH+ZS8PDmEsxM1ebc2jkOsEp
	1hFLbc+IkbmT+5oxfyJADhiLMs2wlow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LFtzUVc+;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779829037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ks4dTmlympIPYAqCrL2AXyLjzLfs8srlx+ar7BYAqs=;
	b=vWmdH0rfwxVPU32w69HiLa8xnLp/EDcSHE9o+AUgAHExaHaOY/9YmduVuitqeGhG13xyxv
	CvdyRqxmbXrq5Ae2gOZaiV2NqtF0SJbXXPBi5seVEe0jG3HvjgWb/hI4gq7ohtewWn8/S1
	S4nKu5gwJIwGoyJBxaOXLHB5in/Ti0w=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-449cdc12a8aso1258979f8f.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 13:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779829035; x=1780433835; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ks4dTmlympIPYAqCrL2AXyLjzLfs8srlx+ar7BYAqs=;
        b=LFtzUVc+M4EF9lGIR6kRVsB/kULQHbfFFXO171ykMDZJGU7qtIIiiPZ6IZYxISwfWj
         HogZfcxpTKLNJBN737pBSOQcWY3ZxXQu44bXZOml9ikHpn6M/3p44H+gCg2ehWcMNmxH
         ZMZ+YTtrhUDBFI7fMDE0BRt85onw3VGw+N7odqRaUFzf3cF76J4VE18TbZ0tGT64SRYX
         Aym0yZc5mCgTyK1sawAxton74SHr8Oxh0CVjc6f+uVrcvmbO+6s7di65g/unOaBxfQ5a
         snzclMY+KJZFvs2OjXOEh8hy6RY9RsrG9fiuejeMGN5dSDp+r682ldFg1Eq5Ow7dkmLN
         y/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779829035; x=1780433835;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ks4dTmlympIPYAqCrL2AXyLjzLfs8srlx+ar7BYAqs=;
        b=nQ8+r1eCxjATk9xRfFoUvx91+uboY39gVRNrUd6ij5ZA5ihYl+QLj3yWYCV0g8jTdX
         VaRFu/XqzGZj8EnaJ1bOSmm5tow+nZfFC3Z444nd6wjJyD+Cyp9DRhdR4yzTazxDl3nw
         2CbevB4welgSo8C7Wj7aQlBUbeL6PsCc7h/dw3Il33A2omAljfSB0OQIlFYnqSp0IEVb
         EuCjryw/R3wsYEmjD8+FYl4+5iOQGF6V43Xzi+eldKizz4tsVFtektlrrC27h2h4F2Aq
         BchvKq0vT3JeCKALNPPOXOfedOiYzr/ZC2EBidTe3lVe/YynPoILfdWTlSauzp3Xfo4y
         Qkqw==
X-Forwarded-Encrypted: i=1; AFNElJ8drZo7J14X8y+LSlXjD1XIDdlN67Eh9fYOc9Tyi+MpUatBmQpCkGbZ+yDUXWWoA0NIkM5+XXkKyg==@kvack.org
X-Gm-Message-State: AOJu0YxxdnoXELYq6aOK/wnmCZUihZR/6GMPgGI+hGHtw2yNFglsPpG/
	S7J/49Yp2HVv9fTgEwaSO3L5hZi54aq1rk6zppg4HpNSGdQoO6gFLFur/INGFonJJlU=
X-Gm-Gg: Acq92OGm5S5IASMCAoNGyceZmzRAdCvfy85ru8anlA7uS2YmEN+F7nwIaAfp7Ccit4U
	uW6cgZJdPQKWh5wqAVxx9gYhHVtK0MoX+U3fub0I0SzP9qUdafe7j8t07oMFfZqohy2AwgVkjxV
	+An/RloOVnsGk2UkLo/RjC2MWlhR/VLXTMZftenNv46DjX5bFd3gVDoKBbZU36I8/0PdJudHOEJ
	NVN7RaoeVkxYDyTaRwYFMw7e+S9GUQam0Nlrrr0cezkFzBR5h4TT2egzq09wilYb0NTpPPdBiDv
	HhW4Slu7/AiKNFlDtviCEPbKuEuVuwiks/1e0FqKS9pjyxNrRI/fJ7A+lEHbn6cLsz6jk8wFdW8
	a1TWjcBjQewARnuhzheIZO2MAgnu8zj0is3FIgW8BSzR5WdxdeGvDOGAOehRRPrV9Tt8T5MBWqc
	qQkn1i9UhRRQ7fN2U9v25xIrOzQ6Wi2g58tl9Tbzp5+9hw3N1Z5EtA/tp6Zh/GblTrAzCJ
X-Received: by 2002:a05:600c:4706:b0:490:3fdd:d344 with SMTP id 5b1f17b1804b1-490424851e1mr156009965e9.1.1779829035120;
        Tue, 26 May 2026 13:57:15 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5584b8sm848568f8f.11.2026.05.26.13.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 13:57:14 -0700 (PDT)
Message-ID: <8b780901-8184-4908-8bda-56fac42fe6b3@suse.com>
Date: Tue, 26 May 2026 22:57:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org> <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org> <ahQX_JCgS9JWIhY-@kernel.org>
 <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
 <ahWwD0eqj3cUgaKn@casper.infradead.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <ahWwD0eqj3cUgaKn@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F256EC0002
X-Stat-Signature: dcmy7pugkm4dnak39bcbqpcmfcm7ko1y
X-HE-Tag: 1779829036-640766
X-HE-Meta: U2FsdGVkX19ec1xbUDD3Sqmk+tR0K4tD1TzokYDAJiM0oxfYJj18t6+2lmhslN+b24iEgiSo5B2kgq9klVSEz/TFEi1WQD3deuYPAisT+oioUCPbkHmtdhmOJG5kuRG2rcpbpoaQiigjB2pF2n4iCC+533eaD6hF3HFWZp1h+oxKcP2KfMO5zzsNH8Rrw7aP7a1i/VyvL7T9yZU5rUPOSOJawWsK8DXnshQ57WKEujD/PjwzZLaHXc+Z7zaqjPgvFT7qVbCDT8bDZvkFEu1qK8zS+YyZMp/kF33SgnyhTUIFDeAfW1+ygJPbOK747xaKwyzF9IJRUr38Rn09K0exzVt9JGBty0qg5VPwc+h2WjZyqccJ5jZCOhM1fNESmYGWaFOJXyPgjuHLCiwW0lp/kvbQk5kftKEROS3FXXcdDhN1i7z2Wq3zglVA2Cle7oOrAFiRHJHb2JIcgxrRqsloYbMipSN57i+m4ldEMpWGh63CQHJz+nfPee2NmHbF0iGEg1SAKikBBeghDtkaE0YgwAAshGWK5DN87Nf0SDtBG2OyQ3KlDyJ/FG4bfADYlWQtiuNNEvehedkATIfh9TSIg3I6eS39NeYsOJk79xxJfJKK5Kl0cSCt8HLqBtMzuLWmvgAD+V/Qmtm81pnnhUU6ui5dBO+tjXlzSUVm4QyJWPc/A+FzA1pgayHyvt1mln0N2bwQ7q/Cvk5A5sT4mCWARDmsQrnmnbnz6EksW1/+oybDMGbIGJRSbAK/GHDRRgOQlCbtBAKtt2Kb5weiOy/0T/gJaROBhud3CSPodieSmp6QeufIuoxOtd87BsAl9lai8AswBk1YPBRt/Iwu0EcVSOh2qNbArfD4m3IeTDmgN9twrNxGGmAGT4tVFtTLzpI6xNmUbYAdb8TBkoxqJn4oxSJpGD1aV+uVgTMM0f9/hbNY6+VLBP9gqEnIF/q5VruMidZeHFmRTH6ea1H84l/
 wJd3nuFN
 jY7xaxEqMHo1TTDFQIi48yyCOrkh+fLvLVZRBJnO6I0jPM0WQ7ppyquYNZlMjNLmpf0M0DTPWRCXkCWgO7CuhGGFg+2xK0T4dTwo5enA6cmxLXmsRHTSk76nvAa72QOg2TsRZ+nwOufZvfT8Vsy5f60kOYuuBhFsKYZI0vG4k8Iiz0/69z8WBc4/PHrJH3LpFCyY6lnwGVUh99WzMzPdmqqHA47se6Y//X69BnByyftNqw15+/7zgi+qZXIilyMYYk4fFjpNfqjnqbGVmZjqB/yEN0/OODVW2fUQzP6tRvzlhEyghNLbGThu8LllcAih21FiuaoWDv2nwXgWtVoFHUZkvOeex1OUH9aKedce5s4ODpewc5njrdiNypfR9Y1GEsAusBtMhbunz5fWqSZLd8je8I8BkYZwcX6gcJoW/SkDFyal+Hy7tMYvJZn95voIIZXIhWoScbni79iNsKmksdEzF7mXV6tjzXpgAZ5qhH0dUiyskmH7SxE4qSpqV/U07QsMOXew8fMIs6HCW0c+cNXT1h9WIVaSAp8n0H67TZMx1AuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 16:37, Matthew Wilcox wrote:
> On Tue, May 26, 2026 at 02:07:36PM +0200, Vlastimil Babka wrote:
>> The main reasons for switching AFAIU would be related with the
>> folio/memdesc conversions? If one needs just a kernel memory buffer,
>> kmalloc() it is, even if it happens to be page size. Page allocator
>> should be only used if you need e.g. the refcounting or anything else
>> that struct page provides. But then in some cases the memdesc conversion
>> would need adjustments at some point. With kmalloc() we can forget about
>> this user.
> 
> No, I think this is unrelated to memdescs.
> 
> I've seen a few people say slightly wrong things about
> folios/pages/memdescs recently, so let me try to clarify the end state.
> 
> I do not intend to get rid of the ability to allocate a bare page of
> memory with something like alloc_pages() or get_free_page().  It's
> just that the struct page associated with it will contain far less
> information (because it's smaller).

Alright, but isn't it still the case that if you don't need any of what
struct page provides today or will do in the future, it's better if you just
use kmalloc()? I thought you said so yourself?

https://lore.kernel.org/all/aPQxN7-FeFB6vTuv@casper.infradead.org/

So what exactly would your rationale for "Most of them shouldn't be using
get_free_pages() at all, they should be using kmalloc()." be?

> https://kernelnewbies.org/MatthewWilcox/Memdescs has a bit more
> information, but to distill it:
> 
> You get a u64 worth of data (technically one per page, but if you
> allocate multiple pages, they're all going to be the same).
> Bits 0-3 will be type 0 (to indicate that it has no memdesc).  
> Bits 4-10 will be subtype 2 (to indicate no information about owner).
> Bit 11 will be clear to indicate that this page should not be mappable
> to userspace.
> Bits 12-17 will store the allocation order.
> The top few bits will encode zone/node/section like page->flags
> do today.
> 
> That doesn't leave many free bits for the user, but that's OK because
> most allocations don't actually need any bits in struct page.  If you do
> want something like a refcount or list_head, see the "Managed memory"
> section on that page.  If you actually want a full-fat folio, well,
> allocate a folio, not a page.


