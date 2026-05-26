Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE51CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194D96B0005; Tue, 26 May 2026 02:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148316B0088; Tue, 26 May 2026 02:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D236B008A; Tue, 26 May 2026 02:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4F786B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:02:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99F461A02BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:02:34 +0000 (UTC)
X-FDA: 84808526628.01.ABCAD24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id ED32680005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:02:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoCIuHQ4;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779775353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIML6hcZOx6vGfksbYoDCW3080B/pxhLrq7CokdoqsU=;
	b=V6sanxQZVNAT4IhmPuHqkqTU+B13XS8sDeu0gG5FCdOIha5Hj6k5rc4Lh4uYUmIJeB2/fs
	LXh4mA+I9npVVPQoieFSIywUZdses/oChVwaKnr3hAIMZScm4VjjVexeQbwLpRMX5+FAhL
	Hk9WJliidC91cF3XakR9Kzy1Yg/Jhxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779775353; a=rsa-sha256;
	cv=none;
	b=FiJam6K/JVVHY2rFepFjP1Yt/WznhqMmxv44rDfb3M6jRNuQEPRPVYbDoUR/xC6Y3hZrgv
	95OPbyuN3CwN9luSZ12QjiWqZXxLGHNR8CvvCSJM35K0wvc0/+4kIR3BbnoYEGfJGu8iWY
	J+9PvnJr81wBzocpKHg/i0FzX8gf0FE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoCIuHQ4;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F27F441992;
	Tue, 26 May 2026 06:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD7B1F000E9;
	Tue, 26 May 2026 06:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779775351;
	bh=wIML6hcZOx6vGfksbYoDCW3080B/pxhLrq7CokdoqsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FoCIuHQ4Ojm6OkdDncOAQow5VjfnqV/DfcWzWqbK/Nvtt8oDhIE+z0TII334uPVGx
	 Z0cJTgA1CPnEVCvD9W2zPsHZLvc4ippyMi8vNAjhpQK8/Y68A69/WgkQNwpHHckGdB
	 BGcy4CBeT1LgpIlmXWIez4X/ZfG1pBrUH0wV8X1a9MPSswUyBvHTwOE4hkIC4vbD2P
	 3A1BXKoFCZFTcFNaimWUL3YF8StsORoJHdnrYU6HC7+gcYW7Y1xO6rd2LZ+xw/BDuO
	 ORGQyKWuCg0bc1sOV3BIHQ/naPFe8BRuCq6VaI4rNQxMixe/fBA90i8a41NQ9A0KSo
	 /hfWpcb5CbZaQ==
Message-ID: <799bdd0f-2771-4fad-8617-fbe4165689d9@kernel.org>
Date: Tue, 26 May 2026 15:02:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 5c7ormsbsbdj3ss1nbu9nhfodxe5k4f9
X-Rspamd-Queue-Id: ED32680005
X-Rspam-User: 
X-HE-Tag: 1779775352-477324
X-HE-Meta: U2FsdGVkX1/yqZkN9aGbPaxFuebA9n5yTUp8hoIM7xpU2/OPtsy9TxdFHoE7mlnMlKsmkaWbhHpCnRzQTMJ1ve/oAsSwMkj447ug9uZNGoj+F7EjVp2ADLUFYS3MJuJUevWvo3pvNCNNvX6dZZQ8W+vXmBVw0UgnghBj8AIh0PBggW32xW/L1RoKj2uSkjSa41mkAdZTWrrulQBbCynIcVzipN10kWy0epByeLWcQlYhl+rYavPDGq4e2M/wc8ijjm8tQVN7EklrcgylfKnqbNqzUNmjU92kLAIJr/fkv4GN5HOM4yDFvMcPLupyo5tlreDP+iyNdGEx6dVhvovxNWhdsOKLPx++CJf+3dcidp6qLjh0ROP4aSMbM3BagQ9WzArPEhrYSxHpRw35D38UYQDakYucSjpa3dhEcqWL2hz9dBuhBX/VwtfPzEMnmzdAx8BmCSDB32yjklLygSMeA5AOJuXk2ggz0DQPQm7/WRccuzXdzucv3Dipul+7J/mOmvlNGLIW5/MfVdCFf6BFbUjVdYcPM92FoNXNAbKRJmUqC3cAo5SBeFHkdI1NB+mQGbgmeRdQ3JJm188rxVwNlVH8ZukuQAG0lcQxtaOaBqpjq89hDWt60j5KrrA3QYOAN9jsXFTLpu+lUZdiiQhomFngT/w3bFJwyKcGUVKF7iPZFJyps5c63ZN4Ot/dTUuOZ+/TZdZ8+en0mhbdtRLNTv/rFyWbpPoIYktTLVnOmeKK+BrLdfEnRas7n3vebJQ+lw3wL84IdpR/oNxvFb5S1VUet3DTLWV/8NYZUav9Ay/82dnBh/xmrA0UPtBswH4HzE0kkWINNdoGt1++uDe4MmlMgiK/2mDbgx/OeGrgPdSR1Kk89NoY5J1no783hNlM3K3uhI6viXd/x2/dGUZKNAtKHGzJiIAoi7lv3z9WqtAFLync06HPSKGW43RSJ1LTsqoW90NrAVBghut6E2h
 ogGvgEqo
 WXNBdTUdRrCiIdi7HWy+9XBOuKbO6ak5RzHsKW/ipcxwkPuEPtS8c9PbGipaozeTw0xiAwYcXp4MnXzkxz5LWbVz/sLPlw7PqSau6neVlZpPIIU0aJ4LmkVxQ2KVgwk2q1Y37NKljP3fQrB9KKKXIHoKog5OuWP5/hXl+nkPmJLprHIN9XsrkPx3CJ6/S9DVsxU2BjYmpzxdPG54An09nNfUzsfDAZkkkxmWeaI4xLraCyMPFHIg2S7HeHRd3BQSSp6ncxhS9KzjpwXm5xOMQ6cozGrkuLrsTFR5v8lfVMTA0hZrBe1RuCDQvOMnPPtiKKAlj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/25/26 10:10 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Empty sheaves allocated by alloc_empty_sheaf() should be released with
> free_empty_sheaf().
> 
> Move the empty-sheaf capacity initialization into __alloc_empty_sheaf()
> and use it for oversized prefilled sheaves as well.
> 
> This keeps the prefill paths consistent: after flushing an oversized or
> pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
> instead of kfree().
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>   mm/slub.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 04692a6f9128..f4c06bf43f2d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2782,6 +2782,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>   		return NULL;
> 
>   	sheaf->cache = s;
> +	sheaf->capacity = capacity;

the capacity field is only used by oversized sheaves (for now).
It should be outside __alloc_empty_sheaf().

>   	stat(s, SHEAF_ALLOC);
> 
> @@ -5015,21 +5016,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> 
>   	if (unlikely(size > s->sheaf_capacity)) {
> 
> -		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> +		sheaf = __alloc_empty_sheaf(s, gfp, size);
>   		if (!sheaf)
>   			return NULL;
> 
>   		stat(s, SHEAF_PREFILL_OVERSIZE);

So now SHEAF_ALLOC and SHEAF_FREE include oversized sheaves.
I think that's fine, but can we update the commit message and the comment?

the comment:
SHEAF_ALLOC, /* Allocation of an empty sheaf including oversized ones */
SHEAF_FREE,  /* Freeing of an empty sheaf including oversized ones */

> -		sheaf->cache = s;
> -		sheaf->capacity = size;
> -		/*
> -		 * we do not need to care about pfmemalloc here because oversize
> -		 * sheaves area always flushed and freed when returned
> -		 */

the comment is still worth having?

>   		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>   					     &sheaf->objects[0])) {
> -			kfree(sheaf);
> +			free_empty_sheaf(s, sheaf);
>   			return NULL;
>   		}

-- 
Cheers,
Harry / Hyeonggon


