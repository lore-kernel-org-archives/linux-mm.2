Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD357606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M+fgOzHk
Received: by kanga.kvack.org (Postfix)
	id E0DB96B05BC; Mon, 16 Nov 2026 05:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5806B05BF; Mon, 16 Nov 2026 05:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5376B05C0; Mon, 16 Nov 2026 05:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7E06B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:54:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1721A1C42F4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:54:44 +0000 (UTC)
X-FDA: 85440674088.07.07B7A95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 504F740006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:54:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+fgOzHk;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUXIEzzZbx+pvk5hQhC5uQsVJ+Wr1axlLvfdDODcWmE=;
	b=KUdPlYGz/FEh7LDc64QwNlsS+alibNpjNl73BhHFdzDhwGGtJ5eyceM3j/yBN6PBKwdMxe
	roK/NiN/CX3o3ZrEtFBH+xJzxAERdm6+uxtPxytodl6+mkWbFjkEoqXtQVPEv2A/T5uVAr
	/FYaiA9TJFdy/jpFSpHoJhilTtEtMfs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826482;
	b=FKhZ28YDBZvrbye0xJzfC13J7tBMong+egvj0SrDGpAtt1Xhj4/iA9u6hUlMVQMjLNjNQX
	dC1dhNdaZPoFuyOg2Apfq0B32L81gU1+kIVDkhq8kEch7KJrlXOebpoEQ4jA3rpcKo75Em
	IsnQMeFyZ2UXlHVsl1zmbfPMzAWmJSA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+fgOzHk;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BC9B45589;
	Mon, 16 Nov 2026 10:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D441F000C4;
	Mon, 16 Nov 2026 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826481;
	bh=rUXIEzzZbx+pvk5hQhC5uQsVJ+Wr1axlLvfdDODcWmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M+fgOzHkr8hBd2SC57MQPYOT+v3WbLVix+CbLh5WS/cVkG/7psr2ewW/ujd7whLPC
	 KMCUWnxBRjzZAI+xHnE2ZepI3e3xDp+IGS3IPiUC7tityO8okLOC6uUjomINEtSfS/
	 sGz43WsxfRT3XB2OUcNq41La+hScCru6Qtkfc8o8yac37EH7k1Et0aX0QMYV2pmaC3
	 0QgRezQDfsmcD6FzKQChjK96MP+R6LPBAtx9xG+3skEgxSR8W9nIQTZqaOIXIyyoV5
	 PscNH8WzGg1n7EHnvUNuAxTdN5N4pYUxwLFLvJq+D2x7L8GszeD4DGdsXH2i9mH8Fs
	 2PPBLKy4gEHvg==
Message-ID: <0e626675-c6f9-40d7-a4ae-de069154ada2@kernel.org>
Date: Mon, 16 Nov 2026 11:54:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Content-Language: en-US
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com,
 Breno Leitao <leitao@debian.org>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e89yjrn4erui8d614po3f69n7sbizi7h
X-Rspamd-Queue-Id: 504F740006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794826482-96486
X-HE-Meta: U2FsdGVkX18O0t4VkvsDH7pBo9GkHroGlbsTtIL6JmXb/XjT6x3L4ujFgTY1k5zM70BCTyddcNXegt/mIS4dEYQPdZWCWQDftxIrk6v8vMQmZE9cQlMfC2tusmmuxsw3LApvTota3+OMbnOFpGERXvaxmQOc77OEX1ezQLkL02+smtyN3fv2DqfX+LQB3A7mfPjsI3rwjnZHH18qJpxVhK3/WWaw4hd485f0/19TKWR7v6EzB66UWBNW16RFXZfUOZd1hI03R5rAPcr4VMirYuZfeNwgJ5EVPjy1UDBUu0Jhf94V2py05OPi2D+Vfh/SvlwtBU46OF0+3rJuf7xPeDEEnTRw+qMbOY5YmeYKEaC1fwtap2yvyKfVV2YM+cd3SzNeivq6Z7HTECB5W8iZhHYXT03NjFSFTQjgXvQBRIujRN1UMhAFTaUjeRhSSYfWG9FtnTIA7cD5/z8lXwaxFcVh69rz5qwn9ZbhBTjA9Qgx1qL5Sd/hG2ENgnsGXF94uCq9kPd+pZEI9UiXstjAX9bip7Tt826TUUfImHkUL1n4C7ob3GWdJLNFRCPf/6bqbY7vTRzqbu5n4SkYgDCp1sOd+HoaQMzaQlfvSAGnEGoo/0R4Pbe99TCBY8qB6RYaTxQOnX1H1wLwdb3qCYUyg2wjrNSklIjxDwwt8q7g+R82VqrarljsrjQn+jREJR+qoe3mvliuaIeI3UFMKR6LncU3Vmq0hCRdmQdZxa6MBc4j2RerSK4HtFjZriimzk0sRYHdjsAT6dpIPEvrGEAraZsxEpDmgSAj3hpJqjNyfu3px7NM3tND9WAUHUH2N+2RrCKwguaz3ObB8BQHarZavtPiHfRpdK0g45a5dk1nhyKF/0Rre+sZexxI700Ep175MpIk/r7zoJGRqR168/06MSc19PZnP2ILlQvxQX6wwW9nsgS8DbnU/IKTMVXvTh1qMfLOCCstykappRoFm+H
 QRgmTA65
 dcMyM9cjIzCsQOmYSIEKupng9SwUpKfkbZPpCwxsuquy0vZqlMqTlTEqZVObLn9G/bsyHbQE6UFuBJ2HmQKhd40hTFT1X4KCQ3JUr06IuYfHE5xroXspOIXltXd34CzwrS24zzasaNaj2/HwkAi/oR5XbKDICe3eBu07QsOZ0ErIpTPzEBF0kNIVu9Z9cyxujlcw48nGLLlBHgWV+VZlwsWRBavu0vF/hIFPK/94tXdsAAk875VBBxzwWsIQtX+SKEqkOVjiMoT0anAJSMc/BFekX12NFov38i+n8UCTkOKZcKSuxDnd9xDWEETOBdozZ5tVGnFnwnO4kw+kbZS+o2xxMoYF2WcUDTP04C1uzFC8wklZIZOnHKyywJh/GuWl4YqpBOpJn6lE1OF/BNRS7EB0/eguVDCIzIwlzY+Va3PYs4DDaLYmlsE8XeNRJPgwkyexeZJ0prygIhdIyNvS53rj5s2hKMenX1Vn88Eyhjhqr9NRabju96oyAGiMDehI+8ax5g+apIqMw4kxOAn9rokElCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+CC Breno

On 11/13/26 16:18, Nguyen Ngoc Thang wrote:
> kmemleak reports full rcu sheaves as leaked:
> 
>   unreferenced object 0xffff88810005f600 (size 512):
>     hex dump (first 32 bytes):
>       e0 79 f0 2b 81 88 ff ff 20 00 b4 81 ff ff ff ff
>       00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00
>     backtrace:
>       __alloc_empty_sheaf mm/slub.c:2854 [inline]
>       alloc_empty_sheaf mm/slub.c:2874 [inline]
>       __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
> 
> The second word is rcu_free_sheaf and the size equals the capacity: the
> sheaf was handed to call_rcu() by __kfree_rcu_sheaf() and is waiting for
> a grace period. At that point the only reference to it is the ->next
> pointer of the previous callback in the rcu callback list.
> 
> That previous callback may live in memory kmemleak never scans, e.g. the
> rcu_head of a struct slab queued by rcu_free_slab() for a
> SLAB_TYPESAFE_BY_RCU cache. Slab pages are frozen (page_count() == 0),
> so kmemleak skips their struct page. The chain from rcu_data is cut and
> the sheaf, typically allocated long ago and recycled, looks unreferenced.
> Since the sheaf is then not scanned either, the objects it is about to
> free can be reported as well.

I don't get this part. The previous object can't be that much gone, RCU
still needs to get to this sheaf at some point, so there has to be a live
pointer somewhere?

> Sheaves are allocator metadata and are always owned by a pcs, a barn or
> an rcu callback. Mark them with kmemleak_not_leak(): they are never
> reported but still scanned, so objects queued in them stay referenced.
> Allocations that can't spin are not tracked by kmemleak, so skip them,
> as alloc_slab_obj_exts() does.
> 
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Reported-by: syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=527fed49e5b988882c9a
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

I wonder if we should rather do this at the moment the sheaf is handed over
to rcu.
Or if it's a generic problem that should rather be solved by kmemleak having
visibility to the rcu queues.

> ---
> Reproduced in QEMU (syzbot config, 2 vCPUs, numa=fake=2) by stalling a
> grace period with a preempted reader on CPU0 while CPU1 interleaves
> rcu_free_slab() (filp slabs) and rcu_free_sheaf() (maple nodes freed by
> kfree_rcu()) callbacks, then running two kmemleak scans:
> 
>   before: 16-18 sheaves reported per run, rcu_head.func == rcu_free_sheaf,
>           plus maple nodes held by them
>   after:  no sheaf or maple node reports, no new warnings
> 
>  mm/slub.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cd671b934719..e01416ae0b4a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2856,6 +2856,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (unlikely(!sheaf))
>  		return NULL;
>  
> +	/*
> +	 * A queued rcu sheaf may only be referenced by an earlier rcu callback
> +	 * in memory kmemleak doesn't scan (e.g. struct slab). Never report
> +	 * sheaves, but keep scanning the objects they hold.
> +	 */
> +	if (alloc_flags_allow_spinning(alloc_flags))
> +		kmemleak_not_leak(sheaf);
> +
>  	sheaf->cache = s;
>  
>  	stat(s, SHEAF_ALLOC);


