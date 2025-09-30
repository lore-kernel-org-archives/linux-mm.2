Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A776DCCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 13:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1248E000B; Tue, 30 Sep 2025 09:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998A78E0002; Tue, 30 Sep 2025 09:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE348E000B; Tue, 30 Sep 2025 09:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 793708E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:55:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2937C1A0700
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:55:31 +0000 (UTC)
X-FDA: 83946064062.22.03D1ECA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id A244D180004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:55:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7r0aD6Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTG4p3dy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7r0aD6Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTG4p3dy;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759240529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shkbnvvDYpZT9aPtv+GSxkGAU/4/Q0bYAxcbdOiTomw=;
	b=Qjk3qR/BjButg3QFVAyBzSv3TAdcXnrJWt7FuWcYVnpcj5xjJjaEgD3AijSMUFh/QeV3xw
	iFd88fFA1Tz7EFw+R0DwWMuhxIlTrgXUtvAS7P861MVRnW4XtTR54qBZKHiUlz4Br1BkyT
	yMvI4YyMrn7+0XNqJ3dxgRnyi792Zsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759240529; a=rsa-sha256;
	cv=none;
	b=g2rvNJBpFQxP/b15K898XrkW7WmH7sarpbXa7Isik0lhlLSagOF72jcLx8uuJ7BILNqIxh
	O3xlnANpok4Ue8Idg8XgKUX5tfZ/UIfA+VVGg9Hoigq9ZXyfdQHwLWGn0AG2nj8stCOjVu
	NBREfcwz5tAWlL8diDTNI9KBv9IJkAE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7r0aD6Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTG4p3dy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7r0aD6Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTG4p3dy;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF50A33694;
	Tue, 30 Sep 2025 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759240526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shkbnvvDYpZT9aPtv+GSxkGAU/4/Q0bYAxcbdOiTomw=;
	b=V7r0aD6QDr5xLQzdZg+gW91SS1a4MTs2i/wDKnukCKhs4n8ik7FfXoAXEN06qlmTL/drVF
	8atG5APsk5yWOPcZI/tXXDK5Ho79kqXTB+JMfe4XeKcZidL6DWwW7Kc1Z2pe/yFW/CWMpi
	rJIX1AMPfkME/LkbbcH+GvwUsYLHO5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759240526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shkbnvvDYpZT9aPtv+GSxkGAU/4/Q0bYAxcbdOiTomw=;
	b=gTG4p3dyH1VzVWZn4H9POt9My5D2CGK8Xfba5ARqVAKuysGcEMtLFIrIzMFP263aG+mUwj
	kSUVk4KelCSZYWBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759240526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shkbnvvDYpZT9aPtv+GSxkGAU/4/Q0bYAxcbdOiTomw=;
	b=V7r0aD6QDr5xLQzdZg+gW91SS1a4MTs2i/wDKnukCKhs4n8ik7FfXoAXEN06qlmTL/drVF
	8atG5APsk5yWOPcZI/tXXDK5Ho79kqXTB+JMfe4XeKcZidL6DWwW7Kc1Z2pe/yFW/CWMpi
	rJIX1AMPfkME/LkbbcH+GvwUsYLHO5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759240526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shkbnvvDYpZT9aPtv+GSxkGAU/4/Q0bYAxcbdOiTomw=;
	b=gTG4p3dyH1VzVWZn4H9POt9My5D2CGK8Xfba5ARqVAKuysGcEMtLFIrIzMFP263aG+mUwj
	kSUVk4KelCSZYWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F9F61342D;
	Tue, 30 Sep 2025 13:55:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id baQnIk7h22jQTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Sep 2025 13:55:26 +0000
Message-ID: <6fa0e2e3-045e-446f-8ef3-955711b6aa82@suse.cz>
Date: Tue, 30 Sep 2025 15:55:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
To: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
References: <20250925085006.23684-1-zhongjinji@honor.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250925085006.23684-1-zhongjinji@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A244D180004
X-Stat-Signature: c6knodwdc33t8abwyobjf3hxxi5mn98b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759240528-941527
X-HE-Meta: U2FsdGVkX18YvGLHHUzJdFf4ohQ70yo+K4FynXIrFN0y9NV8ZZPFOXayrV2b1RrMXxQi/fCgSk1Rs25IWI9dMdzEz0AhRdLEX6EUSoAHSEDliGVkZObCtIVpGO+vkH9H/zGpd67HLL5mWeIgVa4dsCdLS0/KasBmWE1iGqkRd6HCNlDlhRUWLOrU+SIUM3Tz34JfsKXo6YexSxVFBmH61gXiyTJe0w6kKqfMaP1vGaBTua5c3opcsdv3Xo2ogherxL+Lrt/ZkfTS2ln1QnCTORZFUo6rs4xpsiG0YQbNTPtqxEmWYlEWlDyYMJBn0Aj9z9adsWtIcJfwaNVP3jZzFQ6aZWHaz3esGgy5lsgtOaitU7VNF8HZMCOVhmKhbheNKghWojHa8ixdhC6A5Mf2bRq5n6uX6zeZ1ol8AhQhn5TJk5fyltl9cM4C9M3i6YJwWJ5ARwoXBv99I8HdGwfLWkB2YH1FTen5PqSISyorqojplMH+qu03EYXohvHO/1Tj/FYFCJE+NaeCaXAHErTUAcBxzPUHxjTrOebWwSKyHvWiuKVKS/pR2Vzlmrg+p4daoDIdBv2ogO7XVmwE1QRMAj0UIuJjv7kqOMtOCcNBYo0rtQ0LchSz92iOuejgrlGRx3beWOkDKtOS1AexvhNGxrpucfvOdyBw8DAeT8VtTp7rEneAU78oq7Ta4trEAOoMZTnDJ8+mZuoygUpWVh6eLYPhoeZ9tJJMThb24l6Iy4tUXCsWBsXJVADUgBkpvJTRzS1UqJ640zM+S13nBM/NvLEfsH9/NkysmUyuI45KI8zpmZ4I+pTscXLJNHeZ/k9537UToOOQ3ezOAIVctm7peJir9f6sPopmi3kpj6+UMIAJ3DEG0RDhNC/ucsN5SRd+owhX2XbT1lajht9Lq+ZXI6D9DjfSxS6GUcBRmu/scUaGO3To6CVTiL/9xUdKrt6rFJM8fZU3cmBojBlqZ7K
 Z7dYjjsD
 3oDSqyEEzQaFzu0ybAiB3vUJr9ijxoQT7/HFQyNzC+eIP6bDMcI44bULmGOmhCdP+jf2bBSb1KDln+WoZidGWyHWOXzV1FRi1bHNooI/HvU5nOHDpQmLRzDLjFr/6+euOWoZia/WPju9Axx2yZI2k0VDhlCpedpREM4m5SU/iglyxI53Vs/Iil6xC2O4/QqsXj0wF660HIPsqTE0jDCr9ihqD2C8GDpe0B54m0fm1mllakKeBSckDwzVG2CUm40icB9cp6am8NDTDK5Lrt9MFMjxh7ImNkROjrDi74ryxjDvIJEgrJ+rTPB/j3kU9zpEoZhrq50Sxjl0KQyQgzQRuAviZmsGKU0R3etasYYIdWxVIy0Mr01+CdWkr7udDM+cHcOPLK3wG3pPgli8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 10:50, zhongjinji wrote:
> It is unnecessary to set page->private in __del_page_from_free_list().
> 
> If the page is about to be allocated, page->private will be cleared by
> post_alloc_hook() before the page is handed out. If the page is expanded
> or merged, page->private will be reset by set_buddy_order, and no one
> will retrieve the page's buddy_order without the PageBuddy flag being set.
> If the page is isolated, it will also reset page->private when it
> succeeds.

Seems correct.

> Since __del_page_from_free_list() is a hot path in the kernel, it would be
> better to remove the unnecessary set_page_private().
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..1999eb7e7c14 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>  
>  	list_del(&page->buddy_list);
>  	__ClearPageBuddy(page);
> -	set_page_private(page, 0);
>  	zone->free_area[order].nr_free--;
>  
>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))


