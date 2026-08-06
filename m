Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EF7C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E626B0096; Thu,  6 Aug 2026 02:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFB66B0098; Thu,  6 Aug 2026 02:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE766B0099; Thu,  6 Aug 2026 02:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00CDD6B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:33:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CB3C8067C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:33:00 +0000 (UTC)
X-FDA: 85069876920.16.0800F67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CCEB518000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:32:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JRats/96";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785997978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6qFF2yn3cgDfp9TANF2oSsBhwoLMJ4/lgtPA7iAlyA=;
	b=cRmTZKDzf36phX0Fl00P3Ftc77kONZ2uJ/ZlJWyrlxBpF3Um4/N9aWN42RJ9uIwdmsltaC
	OvY04xiQEUiq+Ezvuj6yjeSV2zHhY6emJO7j+FsO3pwoqJ8nw75jIV1v/EpvA/tgI8baYs
	vcdRv02rG8y7jsVEtvS1evUjVxQxsLE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785997978;
	b=i5aTKfSMGB1TquyYOmFRm3N7SkuClKZ5PLxHT/vpEhHkTgWg5bCQD+LE0UABiBvoU2eoRh
	F9EthiJXH5LV45LJFxoENPfGGwrIwfnxV1aG28YS5cdSDzYwG0S3oFQMitEkzmQ7yrWfEL
	ISbWtRjLuA3sWNXx57+L84QYX2gsSnQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JRats/96";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AF5160A64;
	Thu,  6 Aug 2026 06:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FE61F000E9;
	Thu,  6 Aug 2026 06:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785997978;
	bh=U6qFF2yn3cgDfp9TANF2oSsBhwoLMJ4/lgtPA7iAlyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JRats/966rraRL2gIAwE0tv8D/iOhAkemMsgC8/tVkgvwaBqt1gUsPmDFPQaO2rWl
	 ff3T9MIXbeiKUyyFJHUpQPqbGn+BngHA3W3yjTQwVr0yWHxgUxpjp5zYwOqavLLG6w
	 OweLaAGJaDx0NnlmYz8DGkKLMa3b8JbPaEt59RWZVdS4RQJETryzFip+x4y6z/H/qg
	 BGXXPpti33yIUY2NuKnU+Epx5BgV8F5RiyelpeuR9tG7/1if48LrCNaf7mGOdIGWAA
	 auS3MTsTjkx1sPFk2reoPEZB8jdkUo+hLO7M8WQKjREsrqhC1Hd1AM8q3Bhvxg05dx
	 4oHMhDuAbLtFw==
Date: Thu, 6 Aug 2026 07:32:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: dayou5941@163.com
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, Li Youhong <liyouhong@kylinos.cn>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
 min_order_for_split()
Message-ID: <anQqEfCEbWmm5vX8@lucifer>
References: <20260806032116.681060-1-dayou5941@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806032116.681060-1-dayou5941@163.com>
X-Rspamd-Queue-Id: CCEB518000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bru79mew3a94aw853mgm594f4pjqpffg
X-HE-Tag: 1785997978-816273
X-HE-Meta: U2FsdGVkX1+T/Vnr/MS38L62GHY51EEqFwzZRCu2ia+Av2ks7F8t9ih4Ct3CbKRhRq8rFHtcGt47+GXRHnW1ugWcMh8S520v1XAwQgTMOhTyzWK8r3dPhI8LeFT7zy4LVYIrzlKdmSVx52ntqLYnhx3Co4oYq0VvbiBCGVOsxhnEAKoYm4S88sXoqOY/zPa47pu4fwco88arCHqC8TliQNb6DiH6TPCNsDtj7SAQgRdVs0k/Arn8bIfpQQr5j2OR9bqmG+3p/xEbU5yMmS5BtQUQsr2D0hlZ9PWUNjVl2GMSTmmMC7ULgWjHAsnQy5R7RG/1Vv2w0tAUOrKPgstbQ0HZNRdUMACL21l7kudUEdx8rEljop+lX+K8zGpmvrN6URehydVB7/Ts4BdKto2LfJwTcl5MuXa49STNale4qSqQ9piD7JsJAohNdUrzjVQ80nplEuhTyd3v8rUInXKp2xY9Lrm76YcWCyhbi+8WGnCvnEvUOCw5RHUZuzCA9JbewsavCex+o/eu8RFoUo8m80uRUeehPMEv+M6bMNyvsrfKCryC7DGgScTbmRH7EFojJWLfChn1gC1rxzmONaFL77opZPfs/urXPkDf36KIaI+vRw7yOtuCTYBmeZu/7Qqy8Fb4ysTSbaTKmZkEWNT4RArBvVWF4JVKT3OdAkuoJTO3b8pONMMUGONalf8fAPLuEg2In6Ej2bUFaViUbBWB3VMYpV71/buyU0T3ZCETcTayXeVB5ILkjJBfzB3i7FuZ457ToPBKyXxmnHp13P7RP6dVPhMJZ1sILWWDQVISbf6j4qt/gM+GgXzKmoX/jqqn3T9LssilJST5LL0cz0I6nh6BUNWV+89E01NDc9S6xNZ4cVRiO0F+JnCjTFMFy1ijofTMti2uwbuRXZoZsUxVWPMfod3OwPtCkWB2bgIM46qmNZtQaMy8+F8/MMHDkhEiUUj6mT20VPZwJjodQu9
 Rmync9Qv
 TnX4IoM3jNUPl27Bwz1ry47sHIq8tKowl0aqz2eKWgd+EZVu5zWf1sWX682otVAF8WIpB2CbhKlM9ZhXnL8sQuxzbIAtyBod7KrujJ7PZWUplfdexXOvDOCiUuhMe6a+a97jOPyPHumd2AH34NNwWeD2n8D7aHd1IfWurZZFwqwADh1oHGiInAM51rQ6hGJvFEfyaoRkgWQLpLuqFP7XCydeRSyXkqPUjqx0VSBlFMN04b8msI9+4AG0DQMtlRC+CdzI5Ue2KazjUVu1BDf383QE5EGWKZGv7PrUrV6HF/gLoJXEltfeW17Hq0R8+WW7uYAUpaI/JZAiKYvUn4Vk+ZZIMXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sigh. NAK.

This will trigger immediately.

You're sending this separate from the fix that makes this make any sense,
and I literally told you to send it as a single patch.

Please do what maintainers tell you to do.

I'm pretty convinced you're just doing unacknowledged AI slopping here
because you don't seem to have any understanding of the basics.

Again inclined to just do the patch myself on that basis...!

On Thu, Aug 06, 2026 at 11:21:16AM +0800, dayou5941@163.com wrote:
> From: Li Youhong <liyouhong@kylinos.cn>
>
> min_order_for_split() expects to be called with the folio locked,
> but does not enforce this itself. Add a VM_WARN_ON_ONCE_FOLIO()
> check to validate this assumption and document the locking requirement.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 58cabe6af33d..e3f16dadc1d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   */
>  unsigned int min_order_for_split(struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (folio_test_anon(folio))
>  		return 0;
>
> --
> 2.25.1
>

--
Cheers, Lorenzo

