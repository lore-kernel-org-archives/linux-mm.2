Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD93CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DF48E000E; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EB08E000D; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A83D8E000E; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50E3C8E0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD18D160B1D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:04:59 +0000 (UTC)
X-FDA: 83843574318.09.19DF4FC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CE884000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:04:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a3k8FlGw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sEJP8Xbk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oInuHaIi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mWkOX9xX;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPcqsVYfBq13gRo1p/CKZZuJuUOvh0vID2TgN8SxMHA=;
	b=smiEV9d5F2l82p+s/Tu4cSjhPzPKpCHt2QwOm7pBXedvmQgp34FjexxfFKB+bich0EtHoo
	noJYv/HWJlgkv5CugjT8GZFHfadZCqAQMyJ7aH7xvx96I6VMrJCCgh/mmDnDjVQ0bW1S5T
	WIBXmI92twg9HFRZevf46HVoTAF1Z10=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a3k8FlGw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sEJP8Xbk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oInuHaIi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mWkOX9xX;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800297; a=rsa-sha256;
	cv=none;
	b=2yZWgBFcAb/ezInkGD1AeJfVDQri+Q6QxCjCaKLSmA9PLNUxJqqAI1gQqIHmPh6t7dn30S
	GtIFePD8WSxD8FbYd0XwKbCH4mcDC6Cnwa/v7uyoPfRd4UFtDbYO7ipP+TusOjR2tfTVG/
	+nROV2VMOjrNf4Br/dbp599F9abPWvg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0454211ED;
	Tue,  2 Sep 2025 08:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756800295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XPcqsVYfBq13gRo1p/CKZZuJuUOvh0vID2TgN8SxMHA=;
	b=a3k8FlGwAfWd58o1m3YSHdwl+L8hHYMbdtPW2TBT7+8izJXsog3JGC9cawhlAUOAUrM0LP
	xZ3daa5k086hJdKIVlwMYpItX1YRjSafUHhjeuxLSUjOpU6nDJnqWmAKRWRVijgg94fpMF
	OdA6rWyH2j64+pliFuNu2nY+VqJ95s0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756800295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XPcqsVYfBq13gRo1p/CKZZuJuUOvh0vID2TgN8SxMHA=;
	b=sEJP8Xbk50aR7g/jeMvG1GiUdXYzBxINFpUGwbT7CpqEVStlTpuBJLNC7FKpN/GVadQzFQ
	vfPV5OoCcbgm8WAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756800293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XPcqsVYfBq13gRo1p/CKZZuJuUOvh0vID2TgN8SxMHA=;
	b=oInuHaIiEDxHfNGotp0RvDDUwTD8S1MpuUnk6e9W82FvnHvWTN1Kph3CCaLEgHRDh/J58S
	dOZGGXb167GrXsNBmooaBqqOhyj7dnntFffS3kVI7LRN9HO4QKDxoSdajToi5Ohg11cwtQ
	05vTe7x8y1t/KIb9S6cW6lYPO0awjdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756800293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XPcqsVYfBq13gRo1p/CKZZuJuUOvh0vID2TgN8SxMHA=;
	b=mWkOX9xXy/p2vYR2FmpLHfTsDX0S8cSc8+z41UueqSLua7n+VzotjwpLBA7vk88Mz7YWEM
	+SZ9HOeIB44HGJBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEC1213882;
	Tue,  2 Sep 2025 08:04:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 84z3NSWltmiAbgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Sep 2025 08:04:53 +0000
Message-ID: <4cb33d86-12c9-4b60-bcd4-e9f9ea5a0b16@suse.cz>
Date: Tue, 2 Sep 2025 10:04:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn
 aligned order
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org, vishal.moola@gmail.com,
 David Hildenbrand <david@redhat.com>
References: <20250902025807.11467-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250902025807.11467-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: m99wqut7ec961py7px63nt6fon8nb75q
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CE884000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756800297-932734
X-HE-Meta: U2FsdGVkX1/8pZgEqUdxo1iwtPLS/OqflPQMB+i4uKCOVdaabMPKLKFRXU9v+x87lf+J30MDVYb4s9++J+h3MZ/3p6XhGyi+e0DbVFseJTXY6g46ANlODiuNXfFlB8Zyb7lVhP8XDkQDfWh/To4Ga0+qIJYby8L+9ixRVLBWRxykX+hgWkhX1PejRCPVoNVE9pyDLmUKbqvE7nTLzMx9lkjGd1K+T9+vtbSsWXGcBIrFia77Y96XfwYtQy1nbjbWDvql6/9jumKOAVt/yhhSikk2xfeyrkP9dvMtt2t3l6MUHw4fD5d6dsM4zybIIV2cFdkQ3wwOoz7hzCW9MIkBbDAxwGFbyZSCfANipgFL1qDTnSD9pAONmZU6sI+EyNUpwcbBNForZ/nvTZCrCymC+CfigFCI4K6RWXOAp+zjfUtMzACV7BWcu1FCf7ySdloUpN4/OBoCoSeuYzJqpUEyCzFZqgYDPvJChphW2qPLyIuF23zJPJBbnFmjER467f9gpQy27IPbwhf2s7ywVUe0hStSSNMn5PWQTkkUgUMAgte4YkJQz1Adht5B+Ks11oZrYT5FwsHoBU5p4B2ahG4sD08J3fIth1sOIuQ07ctdjIkCnEEry6NiQuJrOKG9FOvVAa8fNCitALRHCquiQzkb4NfLLyqdSVIvIOqeajI1cqXyr4B+vMYTOjbbKga4qHMv2olxLcFmPTuUvMDR5z5n5WgGzxqoeU+zrFHhNYXXdDDHqwTVArW/UtVK532AICukoi3ok9hFndjVzjNDR/GnQrc8EXAV5+Mm4rfduJGg0vxGpmNTMEaiWFNdWY6PlMxsFS0MFXOfaLBsml9N01SpPr0msCzIGcVBTvWyOQ2/ikpqp5lDepRmH5mcnOWVg7zN3HFtTDqdV21yVlwwhtJTcGHHNijhB0b6KvxXm4iUJDTbAKk/tWPzU/ZaxOJvXqqijvUR/Amzc+o62oWoP1T
 /VfH7VP7
 nh5/TGGbUSYuLvSoZlYj8pdZLSfxiME91HHw8S/0W8mFXIT97hqcyQ1AVOXbvhnJxjVtMRgn2yz7giIIW6O4NpXV9FiVbRZFk939XEJkIc8SgwXJWFbbIU7mE3MszZjqCi57oZp4DM57yBqmrBaQL3QsridqDJzLVyeCg//NIx3Zra3qsEqBTJgbghnmkDnNufet8uXjYeicq+BAzPrLT7zAUKGOfkaphs44PN9bWDmMABoWJ+xf4D1A2BMWa0giELiBe5lRgQMkYWo9KNssQ9od/60hqIK5WeVneiIioh0T/nMG9FQ4I0vPlFOqhuXwhj3hImxzHY93vds2Q91lzVRXCpH88RhIU/0PcFy/rndKetzUyEqZa4VWfwCXbj4yG2RBdWBMNRYRZ0QviMhzwGm/TGNoKKphq0dIIaOsZsrAIMubkjsI4wvWiVYYJvDuaPlOW+AWIaKCfvSDUpznyINEQaGQyEuwUiaXLKyZiLQNyUWJllYReSPCCO3x4DLf/pcfIkhF3547041slM1pp94M99eEc/24ic9OZFg1OaYpn9lXzDqx3ONH4zkXSibA/64NLF2q5j5+xmXGC7/fXGzhO6wnC4uO/1mkisb3vbHk/TXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 04:58, Wei Yang wrote:
> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
> While if the order is less than start_pfn aligned order, we would get the
> same pfn and do the same check again.
> 
> Iterate from start_pfn aligned order to reduce duplicated work.
> 
> Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> 
> ---
> v2: add comment on assignment of order
> ---
>  mm/page_alloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 07d79ae557f8..5d9ceca869e5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2033,7 +2033,13 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>  /* Look for a buddy that straddles start_pfn */
>  static unsigned long find_large_buddy(unsigned long start_pfn)
>  {
> -	int order = 0;
> +	/*
> +	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
> +	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
> +	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
> +	 * the starting order does not matter.
> +	 */
> +	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>  	struct page *page;
>  	unsigned long pfn = start_pfn;
>  


