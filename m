Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC087CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13AFC8E0011; Wed, 10 Sep 2025 10:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EABF8E0022; Wed, 10 Sep 2025 10:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAAA8E0011; Wed, 10 Sep 2025 10:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC1958E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:50:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7517F1DF7CD
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:33 +0000 (UTC)
X-FDA: 83873626746.06.E0C9293
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id DED954000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5MRSmpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sR2052Rg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5MRSmpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sR2052Rg;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X5Dx6lIpHPQBl1SABmPYmTa+oUjzujV8/ZSE4ZEdRE=;
	b=4+9dIoz5j67TupVW2JSXe6ovo/76Tz5iufGXscrtN1pJO1gzacyxsCsUFDTAh86F5HkMVA
	NzopgVvzj9d04wX5r5aLkZZ0WX04cF0Kno80fpMBEgE3u9gx5n+Wdm2xmRh6R+UXB4cMtR
	bZuKl1WUylIXwPEZwfFFL0s6QDOWrm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515831; a=rsa-sha256;
	cv=none;
	b=CS6lcgFf4VMAg6x8Z8jQ4O8QYVO/ySLzlYyp4vKIylffS12yhgNaiXPvFfOxam7lUWMD9j
	61TgthMsT9j4OpOg3EkfdhShfl8N1ClOJfngeGtyNIO5zu91yg8zcKJS6XSCZ3J/+5VTfl
	9YkzWkTH3LtlFnxRGhCBKjA4PBL4+6w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5MRSmpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sR2052Rg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E5MRSmpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sR2052Rg;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A13860A84;
	Wed, 10 Sep 2025 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/X5Dx6lIpHPQBl1SABmPYmTa+oUjzujV8/ZSE4ZEdRE=;
	b=E5MRSmpxEWQ8U5qwD8S9j19D7NmpYKr0hyGCz4VsUNEaOwhrlyVrgh02MvAXnGd/V6fF8K
	sy3GUwxORYuoqGRhcgb9+9fSjgWBl9HtS7WPKbPH1cs27b0IGcuKu0jvd4eO1IExesu4C6
	adClPOkl3GHq4H0xNwfnSP71QVxQTTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/X5Dx6lIpHPQBl1SABmPYmTa+oUjzujV8/ZSE4ZEdRE=;
	b=sR2052RgCdkW4e0myK0p5BYzOQ40JdUO/F7z2FPJNPcQGAQEj85kikhhyNoV12NDr7hEBl
	lgz7Ce4W33UWQUAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/X5Dx6lIpHPQBl1SABmPYmTa+oUjzujV8/ZSE4ZEdRE=;
	b=E5MRSmpxEWQ8U5qwD8S9j19D7NmpYKr0hyGCz4VsUNEaOwhrlyVrgh02MvAXnGd/V6fF8K
	sy3GUwxORYuoqGRhcgb9+9fSjgWBl9HtS7WPKbPH1cs27b0IGcuKu0jvd4eO1IExesu4C6
	adClPOkl3GHq4H0xNwfnSP71QVxQTTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/X5Dx6lIpHPQBl1SABmPYmTa+oUjzujV8/ZSE4ZEdRE=;
	b=sR2052RgCdkW4e0myK0p5BYzOQ40JdUO/F7z2FPJNPcQGAQEj85kikhhyNoV12NDr7hEBl
	lgz7Ce4W33UWQUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28E5913301;
	Wed, 10 Sep 2025 14:50:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a1SyCTSQwWgkKwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:50:28 +0000
Message-ID: <fb3ed48f-af19-4f5c-b807-9602167b6972@suse.cz>
Date: Wed, 10 Sep 2025 16:50:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: Remove page->order
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Alexei Starovoitov <ast@kernel.org>
References: <20250910142923.2465470-1-willy@infradead.org>
 <20250910142923.2465470-4-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250910142923.2465470-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DED954000B
X-Stat-Signature: ks36twca1sr4q9t5cuaipgde75ayw5to
X-Rspam-User: 
X-HE-Tag: 1757515830-511283
X-HE-Meta: U2FsdGVkX18y58SuP/MWjpZEatQ/SnOxv1j9aNZvAzPwn3poil/tRn+JRQQ5xxWFeOK9bapFPHKRW9hqz+pomXs6fvbxtq2cutCDmQ+82iotBpoXVrVQVbrUX9I1VJn6OGv7cyPsWfxl51/gsw/rmu4vqTaWCEJ2T2ySGa1yndc8rMWLHjw4+IUVtjxsJgl72Y/PXTA4eIJ7IAv7fRXjhmkdYwwZQY3SzLOneqwA+czyn40JPo1MJz64qcfAPyuZ7iNX46meUJLHUa/gFhhzyOVlV9kQ4abpTaebSj+WEVISnZW1GgwGcsfvyefe8zNW6D0y/sGKjQMJo0ldE5/CNTJJ+uVHWlozpZAjkwhhBK99u+PdXomOkjKjJYcSYRll5e0VrVoLl4/+bIpgHUATAYhkkcM54+xsqF42FvoHoTUyPV88oM+pkylqE1bF0eLOVyGB6R/JXCCJ8NpYrrL/C8DNcefj1XAJVaG2C86OF9iZgSRPG1j4APl2pNonJVEERVujoaIFcmg5kynaltPgbsUmvJfBALYVJHseyQMCe3o11OgGhlZTn5ShBZqapnugAcQsOjH4NpMJcT2cP3RtH9X6Ot/jSxf0LCpX2uWM9mTVH4nC3mp39sduBKFOktx71uJ1Cd3fwgxBAjKewOMbAZwUdZEmWRDNbK7Tt0UoxvmwYwwmtrMU74nagG8VocmL7Vn29uNlGWMtT4+bDU6v4BwORfLJlCPgqPZ/qke0mPt1fQi7M66hQW2TwVpq8YzxziRl80aXDfkelWqGvIftGMihLjd5Hq/TLTXF8/lLEA/8RQXxBAipNkxFA0RV++IpfkcgN5yPhrf3EK51cLZhS9Sm+uLFh8IOR24xNIAmzud+z4/9R+K6PCZjRIb+17KZoi2Po3BEL/H6etfsYvK3tp1AKU8GgY371HqNQjFPHUgys0TJgtE+SRxFY8nqN3fFnrrhd5Le9iV1az9Ijdu
 lhCDEV6/
 ysm8orAB+Pyl8/iK9J4q9ssN/D8Qa3EieekUeFu+DrTBOa8CA7ZulN60kxNb+EADrypamnn51zbjWBVmiH6ZRxYsedVY/gdN+0tNrizOIzcznEjMSgM6zqE+gUJEnwKFS1FaDpJDk7wmbLI1YuWvkF7yfHIZW2NAv8YlpfWODy4cpkjeot8nakZFp7stfXuXpniv/XvRY3UpLuj7ArBf+QULi1oANkll69DYVbXz1ZzcgYiNPuVZzPs5lauAiQSmKSzUeDeg1SMazQcebF3w8aXbXXndF7fFtLcybxXfs8icPFJojWkr7lmjYM15g1GMiDhCEYkAModdZ6biTCv6y4yAsGBt/1ylmozHc+k20xu4oKHjORtk9h/iZpBf2F3Ksj0KeYbH2hHs6lKPsdH0vxOaKew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 16:29, Matthew Wilcox (Oracle) wrote:
> We already use page->private for storing the order of a page while it's
> in the buddy allocator system; extend that to also storing the order
> while it's in the pcp_llist.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Nit below:

> ---
>  include/linux/mm_types.h | 8 +++-----
>  mm/page_alloc.c          | 4 ++--
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 4a441f78340d..569265d159a5 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -97,10 +97,7 @@ struct page {
>  				/* Or, free page */
>  				struct list_head buddy_list;
>  				struct list_head pcp_list;
> -				struct {
> -					struct llist_node pcp_llist;
> -					unsigned int order;
> -				};
> +				struct llist_node pcp_llist;
>  			};
>  			struct address_space *mapping;
>  			union {
> @@ -111,7 +108,8 @@ struct page {
>  			 * @private: Mapping-private opaque data.
>  			 * Usually used for buffer_heads if PagePrivate.
>  			 * Used for swp_entry_t if swapcache flag set.
> -			 * Indicates order in the buddy system if PageBuddy.
> +			 * Indicates order in the buddy system if PageBuddy
> +			 * or on pcp_llist.

In fact pcp_list too, so "or on pcp_list or pcp_llist" ?

>  			 */
>  			unsigned long private;
>  		};
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d21a411e807e..e71e23d1a747 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1520,7 +1520,7 @@ static void add_page_to_zone_llist(struct zone *zone, struct page *page,
>  				   unsigned int order)
>  {
>  	/* Remember the order */
> -	page->order = order;
> +	page->private = order;
>  	/* Add the page to the free list */
>  	llist_add(&page->pcp_llist, &zone->trylock_free_pages);
>  }
> @@ -1549,7 +1549,7 @@ static void free_one_page(struct zone *zone, struct page *page,
>  
>  		llnode = llist_del_all(llhead);
>  		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
> -			unsigned int p_order = p->order;
> +			unsigned int p_order = p->private;
>  
>  			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
>  			__count_vm_events(PGFREE, 1 << p_order);


