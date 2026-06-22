Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5C1CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A26C6B0005; Mon, 22 Jun 2026 12:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5535B6B008A; Mon, 22 Jun 2026 12:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468F36B008C; Mon, 22 Jun 2026 12:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAE96B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:09:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2A621401E8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:09:47 +0000 (UTC)
X-FDA: 84908034414.25.F0C46C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DFCC520005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:09:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVHQ6i+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782144586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0e4H8un72P7utlsdRFKK8ZAiei7imnL4GEsD+HSMyk=;
	b=u/jAZ0k7o3oAeRVyr2kdzPPErZWtJEvNnw8w98Kayc+/OnfyNu1HYU6xGB4kNNU54eEkuq
	1Dk4GhJqw+0FN5YWnxj/97UVOTZWTlZizpjjd8cIikRlvjW9THuGvlUk75cwKY2F7rdfOt
	EWqotIWn5NLe+EZmcZcvkkoA1DSFCgo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVHQ6i+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782144586;
	b=JdKCnbY1ildOOv93Cl/Z5px4YCW77BKi8ZqrPJPSLuhzobAjOeQ/8Zxe0n2WPMih+wJR0q
	w/llZtZFlbssKXsZptoxABt6jr1xVReRw+aTn1DX23+8eSEcQ+eegrPGc/4iGGr/h5orWm
	meagx9kikTvgqHi7VZmFpL1Lmpo+nHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A44740AD4;
	Mon, 22 Jun 2026 16:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130791F000E9;
	Mon, 22 Jun 2026 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782144585;
	bh=f0e4H8un72P7utlsdRFKK8ZAiei7imnL4GEsD+HSMyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RVHQ6i+CJe5H/ZUGsbVMkm5Xd3EW00ob3EScvIuinhoGeuRZ4bH9vk8wDyftKtpoJ
	 JCJTxiXyeXivk2ng0fO/R2oTjR971Lt/fDU5V00Tj1M1A9onDYf1zrZCj8hqNI82xY
	 vzSZUwEPPubmlXN1jpe8YrizmMgQyjaorSx/nN8dpm/zVZA9nDZhjul5XDaS9/DXHY
	 ERl6MPlxc6YY1arSWFbA9mV16mCh8lJcBbHscTaXditM/V+eranmolqHFODK0LjFvL
	 nucx55ilTb4Xq42imN7dU+Pww40OPD36tdXODMTLo64moUcHLV238r+kttu36zxj3D
	 70dHxxchE7jTQ==
Message-ID: <c1acc870-76d3-41f0-84f5-2dd8ca36697c@kernel.org>
Date: Mon, 22 Jun 2026 18:09:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <liam@infradead.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260622155913.280355-1-ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DFCC520005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ocishg35suso1dtcromar6x3ytxixkju
X-HE-Tag: 1782144585-536148
X-HE-Meta: U2FsdGVkX1/zE/lBcJMaFew635FgV2zsnMebaFNPkNWgcX43SFVF/TlEYrFTZmpBsDxo6bRCQItlEO97dHPMc72Fa9uSW1FOoX5LSCVIQmNEcriIrXFOfgRyDxE/4scAvI1N9uR2mOKPtm7Isx6iQQHDbQ8nT0Pds315e/XlDySACZCi06+v0o9T8hEus3rj9J9z15VQqqPer5m6CvoXXKsZJ+hgkRm+VmNownwBV8RTN1eTfgE/dbcmMVYmhQswK83bePRyOlDckxPl49J0A02uEAtlQMT3hAboWWLUa54rJkNsHGuiR+x3ugx3zGXJMKjkMTBS3JofuliMjrQdWbX9ZNFQc1zgzycuRn3YTBUBKLUB/FG9NgP03E0W94jq8hHm57lniGjKsE+iro/saccK0+cmcJRsUa/tRfidQ7kBjhTqdam3SiZEi09PaNcyZf2I9+OH/jY80MYfDVnDKXwXLvUBAaQgvtlERnng/rvrDYcxgwtq16xqVZK0z0Fenl3uKjypSGrV8uaK3clSCdwmZr540GMrbashIErXndzOqlQK8mhEjsWlXr9M5gMktxucWUyePwmBAWYc+6xEwspgRNKqCcBFNGlnKgQm0DCQ+c9jPp1y5eo0Spl2vUdaPHldYx1V3mVAZHk5ZTyujalJtrztH0X2HTBCVl3T+5W/Hv+a3ltTWo9zkC8tmKTeA1wHxxScS5Pnkpf4MPTw97RXJEhyIOWiR3rsraZeI4C8mgFTsUBs4YCfuI/bNDHyvM3qckBfOJx5AKn5zvk8FBS5o+fKe5Y+3zfik6J8rD2O5md2C23FJFxcLpdESHK1mMkttu00TALyIkQzmFTBBS95gjyi0cOwm8L5VlkS2ePFv1kan/pHiAh4YCHFN4Q9mx3VUk5zNdcsGOpLmQ9ot8gs3USN/gV0IOdK5bzpPLGBokiSOl9BGXIuafH0h7K+xJKck+R0z+FP1s8B6vG
 DAIP8XFv
 CPL9X4UtX6eawI7PVYOyB8oUND9flZ6djxJpowHkaeahuhDnqdcwXIGcxhnzibuFoFuf287cTOFcMgglNqodQU99+r+asL7Moq3P7n3xf6O4SBhr2oLlptL0XWDzEm/9+X9YBqG9x7KvosytlvYULBBl085qDivEZQczVqCR7z0lAaWyCir06BFFEg14PcxW+PpdV6FZ6UdmTQsPg4gefLBsU53hBxW1ihfCjRFtb8qjHoF6XWUnJZiuuz+cFx1LRkwyqr1QD1W9em9ZIqV7bEMBbC3qVFzUvvwtyFLWNoV0sODQZD++g6Z7F0ksj455Oz8eHw29CdBAcYBIVEz6WewLHh8Kqo8qmvuBr5U3F/VJop9Eq/KS85WHGSg54P/m6PYoGiTDjw0uCzb9DZAgs/Ly3blaCyGOPD5obFR85kAuZeII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 17:59, Lorenzo Stoakes wrote:
> Lance has been doing excellent work reviewing rmap series and has proven
> himself to be a great member of the community in general, so add him as an
> rmap reviewer.

Great!

> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65bd4328fe05..dd963b72c614 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17024,6 +17024,7 @@ R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Harry Yoo <harry@kernel.org>
>  R:	Jann Horn <jannh@google.com>
> +R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h


