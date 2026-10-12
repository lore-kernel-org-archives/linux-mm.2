Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E02CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5E86B0095; Mon, 12 Oct 2026 04:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0675E6B0096; Mon, 12 Oct 2026 04:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFA56B0098; Mon, 12 Oct 2026 04:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3FEC6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:23:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35AEA40A2A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:23:23 +0000 (UTC)
X-FDA: 85313284686.04.7DE2A66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5BF4C1C0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:23:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUUX9kCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793401;
	b=OJt3MxgU9BXaPNJQI4dtktino8JhQm31reHWQLpoJCJrIMwrI6EZKKtFbyCdejz7bf602H
	00YfgTW9SzbZYp4C7dMzxZ6QOLHPJUDu31rTaOuTvp2OA1NmUait7ImBrZSvnc4RrJ/vav
	kYHmFCaATJmdWUiPQXgKSo7WAfhgMgg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUUX9kCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9z8HFwQLWdwCptSKIysBAuEW6nHmYa6sNljw2nHjPs=;
	b=RVo2kVZVPSn/Aomg/4yHZAOMUAAgwIlMTCKMW3A1wx/+S9Y0GG5Am6VZPkCA7yjxW+MO5n
	lmCfceblYucfsyvKgB4/UEOzgiS98pY6O8Sis39c6zGlbaFR16aF/e+kj/3p/liHjujsHl
	NJyyP888j0gm8OlZXlP3oao/VHhV+Ug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A24841144;
	Mon, 12 Oct 2026 08:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB70E1F0089B;
	Mon, 12 Oct 2026 08:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791793400;
	bh=d9z8HFwQLWdwCptSKIysBAuEW6nHmYa6sNljw2nHjPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oUUX9kCkrclnsjWl9hC+hEtT6yLc7og6n6BlGwkV8DjgO22JJg6rnVyWaom+nj7j3
	 YYnCdBpGcMtXyFgpJpNOcyJN89akeZ4BCXNocgqGs+byyflugG61jpPVcXpAnjPrYE
	 JDb/3KPVyPvkfkMdV2KDzE9BaYIRX8iftpwn4D5GHiqx+bt6h1kpsv5AA7Si8IkzYf
	 3eipqtxnUubCslBTZ+tAJluv/s02yRliiCYFeOOFQTmksuLz8y+T/jc+x2r5VzsZy4
	 Zom33FU2DnkA1dRR0qIS05j8drd8GtuabAtwsVIM76IwQ/uMgQZBFFAwxpUWOVLlEg
	 T4q3fX3ALfjow==
Message-ID: <5895ceec-df6a-4604-a7b9-8138212d786f@kernel.org>
Date: Mon, 12 Oct 2026 10:23:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
Content-Language: en-US
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Hao Li <hao.li@linux.dev>, linux-mm@kvack.org,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20261011014841.405327-1-ekffu200098@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261011014841.405327-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8pwqxq8oipmw4csbdpbi4n88or4ch754
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BF4C1C0004
X-HE-Tag: 1791793401-943005
X-HE-Meta: U2FsdGVkX19ME6i1aIfuBrlViGWjvxQnr8iqncksFfyydA/gSquu2zZhL/HtBlgSWjz5O8n0JsC+nhgLHIZ7a30YHigxBbycZe0KZ4qHSO5+UMU/qVvKpQWzq9cYHPM2q3Mlh4JSl3eJM0vBnHInNqW/Vo02l0+NHZjxXtbFAayc1qxu9uI1mnuAEzZGR2+YfTC47UcwxfflkM9EwRSGy6HjtiIvqgeuAnbWC2gMpQpfDaJbokD/Tj2gTXzuV2pRnq9KB1c4cxbN7HYvat4TmmvPxBcFuAcIa6CA57SBI3jZnXjX/H8XXHi3FxxBO0p5mPLx8th2FhwKu+Jqp2nnner8RlQJ/rf45qefR16LioajtTFSgEgnw+yPsGzx8rQiQhF5VKrYF5Um5Vv0cGVwyklfVVjyFLbe5VuSpRb5IGbp/bGCzAGPt+N9h5kdtvGgfaIjeDo3iax0KKqKR6DbMQqSewWzR7XJYueouIY6kPvg0999l0SxVbqGDmDV//PAd+S9rfAb4WZj5Lu2LQhiRig5kXBxeReCBf180nS/ihe6NEQoHd26an13qkAlFhEOzEaa2QTA6y5VPLRugYJCYxAiPT0IeBT77QxVtWJKo7IWS6LBNMEl1yOsgEU40bqBejWctp1ykkYE0l+1stdzlATwUSihTzYzjp/L9QsVWASm+zqMBUppkNyQMpFLtiwRq6FjdbiuOa+o5ZUjeGqTH0eHbF7+N2ePCAae/iDTh2zBppEfgfaxxJ48AF9/Indr0XWaB8HUSdUD0HchVuROuKUYVw6KBqUjDjbY1Qg74dSFBOvtDMmQsL4nSADG+dPGaFwy+pxyzV4/qBMNxtLEcvVJ5fk8kAMwderABDrrYZBUjlYKAq3ZOjTQJ47/Q0kegg3/rrMYhCZ0kHS6lKYD958U1B4J8NoyamrZ2yQq3bp8sm9QhfZJBqkkP88AkRv3Ilj6L2DlemKplLESBXG
 Gxk8D8Vv
 cZBUJ+qNxy77DGTA1c8sUrCuu0mzcnIoBAqA96ZfzocK7zZVvtyZKfQtpqEVt3+FFTLT13STn9tQ3NQQcnh0iT4ml3rXCTgO8VheOEPqRtfEdq2zHYd+8tmtM9sY1aoK4y7wmdYaIeDp6CTxqcw/uyCca/4vRoaYg4jN8LfLURPPdN3xT+Y44X35QL4Y0lA5GnPLTzaV8kT5cK+fiayhFkIT6qeD+3JkO3kUlB6XbOzTyGQQg9qtH05jxtnT9HqhbhiQ3xaKwA1Uj7j58daO/k6CHCDk/Gcoo6TpIuuWaUWMn+G8IbzsI/xT4psKyLT9s8/RchFTxPyhEZEAfP8PJ7bbDdOfdZSV1mC+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/26 03:48, Sang-Heon Jeon wrote:
> setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
> setup_slub_min_order() has no such clamp.
> 
> The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
> at once, so slab_min_order above it makes no sense.
> 
> If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
> boot or invoke undefined behavior in order_objects().
> 
> So clamp slab_min_order to MAX_PAGE_ORDER as well.
> 
> Fixes: 81819f0fc828 ("SLUB core")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Hi,

this is effectively part of my bigger refactor here:

https://lore.kernel.org/linux-mm/20260923-slub_tiny_rework-v1-1-a0e66d536eb5@kernel.org/

Thanks,
Vlastimil

> ---
> Changes from v1 [1]
> - Change fixes tag to 81819f0fc828 ("SLUB core")
> - Remove stable tag
> 
> [1] https://lore.kernel.org/all/20261007163403.1643768-1-ekffu200098@gmail.com/#t
> ---
>  mm/slub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 1559cbace469..8400df7c222e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char *str, const struct kernel_para
>  	if (ret)
>  		return ret;
>  
> +	slub_min_order = min_t(unsigned int, slub_min_order, MAX_PAGE_ORDER);
> +
>  	if (slub_min_order > slub_max_order)
>  		slub_max_order = slub_min_order;
>  
> 
> base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0


