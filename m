Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3407CCAC5BE
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 15:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAE28E0005; Tue, 30 Sep 2025 11:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2248E0002; Tue, 30 Sep 2025 11:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7558E0005; Tue, 30 Sep 2025 11:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF9E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:20:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE40744702
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:20:39 +0000 (UTC)
X-FDA: 83946278598.16.D6F11D7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 786AB180009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:20:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wa3ooWwz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iMDiVHkC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wa3ooWwz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iMDiVHkC;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759245637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gd2qT68HUE4EIRZvibhNEqpEUn00xzNgkHBgMBOCgts=;
	b=aMG6m5wiUNCrHnCTf5TRZ86dOC3lfDRyn4tLybg5c/9xWYsmG0HFMA2/5FGQ0obb4x/l+q
	4B0CdtatiwaMPNtwbxmC5TbW1pMKnFui77gYmW9LFEbUW3LvhSL+obf8K1DWTeCrQCmWmC
	fbveVCHnXq0vZm5eMzj/5nlXMg2+4cY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wa3ooWwz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iMDiVHkC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wa3ooWwz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iMDiVHkC;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759245637; a=rsa-sha256;
	cv=none;
	b=wacH/dOlqal2+EYakqixf+HY97fh3s67Q4gee+G65vUuoG1hKVQkCJCcIStmJD0uppIg0P
	87rYaPOqUxQ8gTLlhOunRPhHlEkPemcU8hZedTRh6DiodLE5w5xOjy1IXw7wdaQRivf+Ih
	VJJmPzdyCd9djHbhFCX+R6TZICvchYA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4845E33694;
	Tue, 30 Sep 2025 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759245635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gd2qT68HUE4EIRZvibhNEqpEUn00xzNgkHBgMBOCgts=;
	b=wa3ooWwzTJsztv853h+TJU4PhMezZDPlASPLWLPPWi9hrK9eZzsFf/HezvGFP0lV1VHDUB
	RA+ZDby28/38iCKSN89M/zqnXs6I5F8MTI7596a6tWLbTLOYhg6cW28dpeArbNbiiDhG92
	vdmmQ4OkVjjwGprXuq+9lF/NuBmGhlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759245635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gd2qT68HUE4EIRZvibhNEqpEUn00xzNgkHBgMBOCgts=;
	b=iMDiVHkC3gUrFDletyifwdSwtGl2Rz/jIG3SVSOq9+i1DJY3i0am4wcMDJ79825NWAi4yG
	79Jm/LdWVm3eb6Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759245635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gd2qT68HUE4EIRZvibhNEqpEUn00xzNgkHBgMBOCgts=;
	b=wa3ooWwzTJsztv853h+TJU4PhMezZDPlASPLWLPPWi9hrK9eZzsFf/HezvGFP0lV1VHDUB
	RA+ZDby28/38iCKSN89M/zqnXs6I5F8MTI7596a6tWLbTLOYhg6cW28dpeArbNbiiDhG92
	vdmmQ4OkVjjwGprXuq+9lF/NuBmGhlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759245635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gd2qT68HUE4EIRZvibhNEqpEUn00xzNgkHBgMBOCgts=;
	b=iMDiVHkC3gUrFDletyifwdSwtGl2Rz/jIG3SVSOq9+i1DJY3i0am4wcMDJ79825NWAi4yG
	79Jm/LdWVm3eb6Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 275F21342D;
	Tue, 30 Sep 2025 15:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u8rBB0P122ijaAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Sep 2025 15:20:35 +0000
Message-ID: <5181a289-eee7-42c1-8bdb-7b7bb463babc@suse.cz>
Date: Tue, 30 Sep 2025 17:20:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, liulu.liu@honor.com,
 feng.han@honor.com
References: <20250925085006.23684-1-zhongjinji@honor.com>
 <6fa0e2e3-045e-446f-8ef3-955711b6aa82@suse.cz>
 <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 786AB180009
X-Stat-Signature: brhjcix3sds4xa7uc36e6hq4tdw87sxj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759245637-79917
X-HE-Meta: U2FsdGVkX19Zm8FZbSJ7JKBJ+4jODBnHG7CKh4b8sMJql3uT2qvM3JRfgqM6ltaUuR2SSehr2k53vd/ybx/eAnRH2k92KQCOxXs4rkYwgcEnZCEDO+OyYgOOl8/rEh+o4QhhSil+/AJf7M+aGEHvcT6EE33WOPDzHAv2ZcMwEQ9GqKf7D6qOO1eyfVeU+l5k6WMwAvDwiXGFY0jE9QiaTp6GZHLphFweU2BAU/0Xsx2LFCJnKYLlmZJQKpCaowbMG2LOZmpG7GSEolNFLAp3rCW9LfAOh3TV/L5wMDP6AEvq8l+WqGlHORQqdMxxo99m0qo+nS5YPnG10FU+cm/47D64wRWjkrGYf/SpYqsi0wcNfHGboH2+f3dijKCNk4YS1ssVqN5DSzow7EvwuRO4yiejj24/JYIaYCnRHDQRKSJf05Yl1VS2jldsu4popaGcI1mw1sPvpQaebwNQoVkeRvvt4344FOkKa5RGIxz3Ai1WgIbY0pU5lZsyxZBlXuS6NtJn6CkiQHyVNpV1KN9KNB4TAZq8p7fLd+xsqnGERbWtdldkRFGWRB70Q03W1pJH6Hp5b5jTTs7Sl0Q0ZXKt1/BHiFXmZffDoj+0R4ft5hj3otzgxjQci2aaVKSuKu/tn2UKnxHHi2Psuc4OdQoo8844BzA5Hwh6Vk2dUUUK/BcFPTDmWkuOv4VqwdjmEhJCOMnXr02STqz2ibSba+McE8NktNM63ESJWco4duKE6Pffbk9va/P+7Yrl+JRJSIKzk+lk4opyNvYKTIZoxOjVkPCAJQhoKOZdHfkDQY89PcTXiB3RhxOVi1SNAQ2iGDDv5W5gzW6iW2DPo/6p4FI5PkmWyqn2APqGA3bCpzIYCKgyN0uMZTHD97LyYJBGWwau+qLTJnvZwt1h/edEWOqPkH2qIaAZa/ioqNmLbI1dVGFAhsulIw/Zu7cV0qMfb2zUf1X2nJIXeInZOI5/Fz0
 49V6tuPH
 U4keGQkzWDHQwhbTlpM5180fY/jImeci7rplzKlIkVDK41WLreeHHkUx813de1oX1YAs5iGvbHXZGqE3uNwKsYTwKneCeRq7ROwCOsqc5wOp8YBmmvn3fbFOHQMBehgf7e5xqlifH6s3wZ3fCiINwLGAxe9rKNw/cdGqHF6CybYQoTZkwNwSToEEHY6OSmFLncCaLAqWHBNKhrXruWdnB+n7+miXikBl1Yn7qaZwkXeztIX8N+tlw93lHy345HOBRZmvMJmXP9J8W/KBNe3XlUXi7AkiJPfJIKzOQe2QPbfCvcfS1d2R+oSlJldn74c+ZHU+/gq8y29WEc60Yp9u/37Yo8QqLI1HslBG1VmDECQ9deDrN0/Wn6+oYgVUhHvLRTS2x4sMGTolg8vA5r2UgtNBt0QndE16QTj6z6oSGnktciDgLzDBOB7jzQIzBt0Q8AMMSEhJ2SAt43ELUfE6eHURSeiTZZSvng790
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 16:28, Zi Yan wrote:
> On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:
> 
>> On 9/25/25 10:50, zhongjinji wrote:
>>> It is unnecessary to set page->private in __del_page_from_free_list().
>>>
>>> If the page is about to be allocated, page->private will be cleared by
>>> post_alloc_hook() before the page is handed out. If the page is expanded
>>> or merged, page->private will be reset by set_buddy_order, and no one
>>> will retrieve the page's buddy_order without the PageBuddy flag being set.
>>> If the page is isolated, it will also reset page->private when it
>>> succeeds.
>>
>> Seems correct.
> 
> This means high order free pages will have head[2N].private set to a non-zero
> value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
> head[N*(2^M)].private is M and head[0].private is the actual free page order.

Hm right, tail pages...

> If such a high order free page is used as high order folio, it should be fine.

We don't reinterpret the private field in any of the first X tail pages for
folios? That would be bad too.

> But if user allocates a non-compound high order page and uses split_page()
> to get a list of order-0 pages from this high order page, some pages will
> have non zero private. I wonder if these users are prepared for that.
> 
> For example, kernel/events/ring_buffer.c does it. In its comment, it says
> “set its first page's private to this order; !PagePrivate(page) means it's
> just a normal page.”
> (see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_buffer.c#L634)
> 
> I wonder if non zero page->private would cause any issue there.
> 
> Maybe split_page() should set all page->private to 0.
> 
> Let me know if I get anything wrong.

Maybe we could postpone this optimization until struct pages are shrunk.

>>
>>> Since __del_page_from_free_list() is a hot path in the kernel, it would be
>>> better to remove the unnecessary set_page_private().
>>>
>>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>>
>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>
>>> ---
>>>  mm/page_alloc.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index d1d037f97c5f..1999eb7e7c14 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>>>
>>>  	list_del(&page->buddy_list);
>>>  	__ClearPageBuddy(page);
>>> -	set_page_private(page, 0);
>>>  	zone->free_area[order].nr_free--;
>>>
>>>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
> 
> 
> Best Regards,
> Yan, Zi


