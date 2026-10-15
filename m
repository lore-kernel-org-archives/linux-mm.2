Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82797CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6732B6B0088; Thu, 15 Oct 2026 12:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624006B008A; Thu, 15 Oct 2026 12:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A0E6B008C; Thu, 15 Oct 2026 12:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 303C66B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:47:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 366BC1A014F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:47:21 +0000 (UTC)
X-FDA: 85325441082.13.D982918
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E4F2C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:47:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Cb6XZ+;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792082839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TgTdmbdNunwh4BUXo3hMM2/ke1MBTDNI7seN15BAQw=;
	b=MXZxcDFoHt63HQ2IEQXlpcnFGWJxv39plQErY6/cLxHpwNpW8YCHuVNozZUlAzgRgxXLqh
	LGCR7/YPozKRHxOLCY6F4rA3orFu8JKM3lQrKUjeAA6oBeVzlnjGSLz+aQ3Xw6Es9TifO0
	MMpX5ESIkGhQpviKR7hz6RjR6zl9uEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792082839;
	b=8HKH4wuYmHniXi9Vg2XwruMwvBFMO+zn6hri01bEK9UF6kZA+0GsJoxLFJYZqYAZStMDmX
	5gDg5Ruh0D82TvQwwPjDtDMHp0COq5oooRSbKfvCRTprWPs+Y8JZcodCJWq0rlZQlJ//Ch
	DOnaABEf7iRHhcq+2tM1WDAkRpp2sW4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Cb6XZ+;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 035C360267;
	Thu, 15 Oct 2026 16:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CC11F000C4;
	Thu, 15 Oct 2026 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792082838;
	bh=2TgTdmbdNunwh4BUXo3hMM2/ke1MBTDNI7seN15BAQw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q1Cb6XZ+yCNE2dqg4oFZEsejxSK8qmDhJ9qEH5U7kwG8exMHtomAVngfn84FHrpiH
	 Crue1/GAN6blJk/5iWA0EyUN4+zwWK7l9ZaE2iviSXNO1pU6jVvMlDj8HFiQVsEE7s
	 0L5eRAmhabTPpZEYzkJ2DxTDPxpK1pp7wqHs2vK8MayT5Dg2wSuGdvH85xwnyezDzO
	 vJLGqcJ4nNuaINUFqjMIePNLCJ7Aou43z48qi1MYqYYJv80pwmEcD21V92fBrGXW2+
	 AO1sE55E4Qx5izoy0MhsiIkBDxq5457H5ScKxqNzcQ+kq/TpgFNkJ2iFYrDjc09OzI
	 SJm5eJpnOhkxQ==
Message-ID: <ee35da8d-03b2-4a19-ae7f-c62c1103f0aa@kernel.org>
Date: Thu, 15 Oct 2026 18:47:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: initialize the free pointer of the bootstrap
 kmem_cache_node
Content-Language: en-US
To: Karl Mehltretter <kmehltretter@gmail.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shengming Hu <hu.shengming@zte.com.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261010203906.93156-1-kmehltretter@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261010203906.93156-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E4F2C0003
X-Stat-Signature: 9jhkzzm5zwiwyz41akjkurk8ycya66gn
X-HE-Tag: 1792082839-196442
X-HE-Meta: U2FsdGVkX1/OVOQfxmkICpsoKclUJhLa/DQIJaMsY+XZh5MNTANgN0xwqk2Z5jmYIVvkbvyNkJQIvmr205gbOQL7pT1ekDM18B8unnZmKeA5leArTa38JK0uq8npXIizGdNz9U4ki2wrwTvD3KsogPOYTK9JRZ/xIWYVhdS3tGmulg/ysafoQfDqmclmWaD1NtFqI1u4Ieh/F+3wkU/9YdOxsQixXmJEiEvXIyTKNLHdSmjZ+GxX77fB3TVxDqN2MDSKkwQyEqpdTeOTqgh/G2bvmoGhWrclfEq2NM5dwlwM1f7GsE9Kij9+hk3ysOqdxGRfk2NirR6dosRXcV2I72pfJ8pAtMODhbJ1rfLWlAzlMcV5qVRQyG9bktlpzjs9r14fcTAKLeR13Ep1k83WfmmXHqpni2LxPxtg4f1l/lymfzJNsQHuYzAqIjooon8jaqE9dKQ9h/xSJt8cw+ohpgqLKBy8mcuoikJRMesuT0nbsR+Ksgk0hfMmBx40ok2wHy2ueMpMrWj21NTxLXAiJY9cnin39YrK6L6g9VQ+jpFGI/IZRIGdlbNTwDsZuT1u5W0QRhUaHgEZuJv790rxVshnh+xBtPEn27pHYt49RIlAbzBgCrZAhbcTE1riGI1Vj8xZro3VXQlvXpiWSEI81FiHxvNXmHFcpUK4cUugX+8mxS5GxX52EWS4z7+VRmfXr+Oq2NwqJ/2niGPqhq4BB/W3eiJSvgiQBdvjIMoufTeA/vNjtk2pPCE9ctg7ttXjSwFaC5k0H9YdXG40Chpc8gVCr0eIc0EaDCH53xWmaWlx9GtI+3YLB6FFu6HKgoRtliFfwJ1RYnBQHbL9fVEX9TSD0yGaynXopfdEF+vUtWAnEbdOI/BB9Cpf9OUspAR+JdzhNStZfXebBIjBfCpYjJO84fjFgPsgbs8sBL4LQp7bqZDjqkAWrdaIuTlgvDIHjv0PgIpDEgZ26VnF6iS
 8I5mLocV
 bzJWN/K7K0FunXzbQPgKmIyVnsHxsOcX4Gw90h5PG22p9c/iotB1mtTt/kds5505nOIKjuT3ZxEG+Ga79ubfQkZt76ylftYM0CeExXOtq+jXHIdt6JRfNz7aDhnwVZT+aGWaicg1kXi0tVqtmZYEAupea2eQWrm/CAH2xkQmCkYNt2VlQBe8xD4BeuyuDiYGbdt+xsWc9MiGscXwqaQ26vL6zs1WUC1pXKcV6juqJqMLFYg05nMePOx8zJndAhc0C8pvc6Dr1eOoMF/6i6o7iHpM0rlhVtpn/pwKkD/rP95Cp3efcB0qoWIdhSD/efK076TzVlBO5L94Il4m5/gQjCn3rJvKqie+ukksw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 22:39, Karl Mehltretter wrote:
> With slub_debug=FZPU, validating kmem_cache_node reports
> 
>   BUG kmem_cache_node (Not tainted): Freepointer corrupt
>   Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a
> 
> and taints the kernel. Poisoning places the bootstrap object's free
> pointer outside the object, where check_object() checks it even while
> allocated.
> 
> early_kmem_cache_node_alloc() previously took this object from a
> freelist with an initialized pointer. It now takes it from the slab
> iterator and builds the freelist only for the remaining objects,
> leaving its pointer filled with POISON_INUSE.
> 
> Initialize the bootstrap object's free pointer to NULL.
> 
> Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> QEMU x86_64 and custom QEMU SH7785LCR model, slub_debug=FZPU:
> validation reports "Freepointer corrupt" before the fix, clean after.
> 
>  mm/slub.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 54ec125033571..9a20aa820bb0f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7777,6 +7777,7 @@ static void early_kmem_cache_node_alloc(int node)
>  
>  	n = next_slab_obj(kmem_cache_node, &iter);
>  	BUG_ON(!n);
> +	set_freepointer(kmem_cache_node, n, NULL);
>  
>  	slab->inuse = 1;
>  	build_slab_freelist(kmem_cache_node, slab, &iter);


