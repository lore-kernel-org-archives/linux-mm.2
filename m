Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F17ACD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8042A6B0096; Thu, 21 May 2026 20:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBC56B0098; Thu, 21 May 2026 20:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718996B0099; Thu, 21 May 2026 20:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC116B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:54:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AC40A08B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:54:42 +0000 (UTC)
X-FDA: 84793235604.11.BD615A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5FD7340003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:54:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2jnmSuI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779411280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2S3qdoFa1I+RLITQLUX1CsFtTUclF5hn7NIR5djnZeo=;
	b=WA5/JLS/grz/qVnAndTTB/cHpa6DC3Kqh4TNqj7vCaYPeL4wDWj4ZZfhWYdIEP5Fl/0jeh
	IebMvYtmhq/ZuzokNVex8E1hbfvRm0XSvw5zYIEZaAJk+P02FeFYEL/KnktmO1m/2paJtd
	M/Zsif5iA5AobennBZ9whviCGqdc9G8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2jnmSuI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779411280; a=rsa-sha256;
	cv=none;
	b=5PT0xw/0LMlpaFhEAjAYn+cQjwR9sF7xBBRsPIhDMslu71N+7EndADROoGNOBT32nPihpj
	iYyNFvvb45VScU0u1u1uag5wIaieydXs3ZdDX1k/vT1LN6l4vOerOxrLPqeFBlKipRZBmE
	DnoG0AAy471YpP037PSvzMqNDFJv1+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E51DE6014B;
	Fri, 22 May 2026 00:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7CD1F000E9;
	Fri, 22 May 2026 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779411279;
	bh=2S3qdoFa1I+RLITQLUX1CsFtTUclF5hn7NIR5djnZeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l2jnmSuIcu+aXD5Ww51h85HFKZpc+SCQLL7OzDtwOAxJN83QWbCjbS1jHRL/z4YoY
	 lKwgFWFPVBE03V0voly+KroM3f01t1Kf0hR8qbtFrikMfXR8CCXeCfo8q0Yiq6H2Wn
	 +ERt2+sPkEg+4Id9sX1EDzIHkzYhIrCc/dcuUO1D5A5s2ziTf2Q/LOgfHD53GXC2ID
	 Z4MtarjCTSYug0/H1iXajKuEFj5SKdtpzf8fSvANI79o4KL0vMFTC1iI6K4TT+NiUs
	 NrogldeUuL6tZHqFku4OFrHhyslijaATSa+1PqU18dTG79uTOzd2vGMGhVU69egd2i
	 Or/nY8MRJPQTA==
Message-ID: <2a53e936-f22f-47a3-b858-7431749d1bfb@kernel.org>
Date: Fri, 22 May 2026 09:54:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: use round-robin victim selection in refill_stock
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260521223751.3794625-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260521223751.3794625-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i4zu7pm3tn9fgso3grnhk3zmnwwd1qsu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FD7340003
X-HE-Tag: 1779411280-281769
X-HE-Meta: U2FsdGVkX18NKpwsSlG5DqaCrfRt/oRncO5flRlXzC7nC5wG9Lq3tuv9WV9ODePpTfq5RI/XfM3peAODPjazCnucvEdFCLyaz1iSzdm5PRO31ABnuG0St34sqkumd3AMaq7c7X6plM3zEIJsgmzeBnqMruvXYjDGcANxgLbVftIIbUZXX2PfPcmm1Qwxj9YwXm1KotmIlk8Xg+2iBDIFclXeUJLn2KBv3X/3eI309S3iS3nn7aYzJzU3L6h+cZfHnMPUwdJ/llloxUnK5RSmi7k3n4iDr3A0IZZUvk2/aPFmUYwjJUuNdJemlT5ydtEXpTMsAovY0DcUS9qUB/xq1xHk/U4ZNjEOG6K9SEUMBdAclwUrhc6MxJv61jWxm2yl9XxIQQ803zy1hmlc4yYVpPWvR0rMAelO1Yq1b+IXKILNEuvDDlDvgLgZwsmTnfUIr03UmwxR3DzWGDbHa130qpFHfuK4/Jvo5F8BZ58ZIA9A7v2HP/IFPKFS+rqSUB+QEYY2R0i6wh5UF6kAbqS6RYhXJiH0zZsGJTq8py1MxTPn+xOtK93EjvQhASV4x5qrkYGIkIzYoFxqCbifW6YdzRmC9Z6hHWLpoOr1mXJWh2K+atjFsin3hvwYqbVZHyk9D8U4p2IW06G2uQPH4HQtrkWACoQNciKTqcrmlz16X5ymN1H071MMWbZigVb8UiAeqGJ650ClJ1vRqKnWZ7A+4gRedSt6j61+HZXolny4/3KR/Q4fzXWPWrZqkvkYXd+Vo4YM5Uis3TQMsclZWWNbBvqhBfJWHtu+LQ7B28Q0o/WUy+n+/LCINk8zIgc1qREvWH1fEpREZ1KP6aLH/i442W3WfZ+qsueR3c22zaEVUSdYtymC35JuBuD+eW1b7Y83w07tAxCg56FYt0mQde28DOWI4ux6cSv+srXK7Im8SpFYnvNibuMdrfwVodEYM1UkSK2h1TDjGyhPDfW9qDu
 hUW62IlV
 T4Zc/TcPEFyj7TIHXNMOYWcIUAHiCXzogNK2NdOkoUHlNyrGQBZHj31ScHVK1Dp0xmsJ4BnDc7MHUd3Lq+5G+BmWW00Qnj5FgZDbTDNCSYIGTFjntevtGqt7lB14Ou+dqvbW+TWJqKqJVfKVB5xSa1dHY1cnbTPUc7IFkhWgchHqXiLD+si1qJBiOailAz59nPvHXbnOqVVWpOKDjTXQYBiMgw7ezT2EhC+AS6H3+8ubM84Nr4NV6fz9eJMkVeM7OFTBQRLR3SoPBUqZPqVT4jYs46WMjdPxJ4xfYEbTS9421naFxBoV3Mc/Mnve1Hzh25OX58J7e1Y8EbnfxoFwagyzGbOpzSRKnxU2Z4oSQawtgQcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 7:37 AM, Shakeel Butt wrote:
> Harry Yoo reported that get_random_u32_below() is not safe to call in
> the nmi context and memcg charge draining can happen in nmi context.
> 
> More specifically get_random_u32_below() is neither reentrant- nor
> NMI-safe: it acquires a per-cpu local_lock via local_lock_irqsave() on
> the batched_entropy_u32 state. An NMI that lands on a CPU mid-update of
> the ChaCha batch state and recurses into the random subsystem would
> corrupt that state. The memcg_stock local_trylock prevents re-entry
> on the percpu stock itself, but cannot protect an unrelated
> subsystem's per-cpu lock.
> 
> Replace the random pick with a per-cpu round-robin counter stored in
> memcg_stock_pcp and serialized by the same local_trylock that already
> guards cached[] and nr_pages[]. No atomics, no random calls, no extra
> locks needed.
> 
> Fixes: f735eebe55f8f ("memcg: multi-memcg percpu charge cache")

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

and perhaps

Cc: <stable@vger.kernel.org>

as it affects v6.18 (the latest LTS).

Thanks a lot for fixing it, Shakeel!

> Reported-by: Harry Yoo <harry@kernel.org>
> Closes: https://lore.kernel.org/4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   mm/memcontrol.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0eb50e639f0a..6392a2704441 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2031,6 +2031,7 @@ struct memcg_stock_pcp {
>   
>   	struct work_struct work;
>   	unsigned long flags;
> +	uint8_t drain_idx;
>   };
>   
>   static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
> @@ -2214,7 +2215,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>   	if (!success) {
>   		i = empty_slot;
>   		if (i == -1) {
> -			i = get_random_u32_below(NR_MEMCG_STOCK);
> +			i = stock->drain_idx++;
> +			if (stock->drain_idx == NR_MEMCG_STOCK)
> +				stock->drain_idx = 0;
>   			drain_stock(stock, i);
>   		}
>   		css_get(&memcg->css);

-- 
Cheers,
Harry / Hyeonggon


