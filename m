Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6759DD6554F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11636B0005; Wed, 17 Dec 2025 06:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFA46B0089; Wed, 17 Dec 2025 06:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893CC6B008A; Wed, 17 Dec 2025 06:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7699E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:12:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20075C09AF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:12:54 +0000 (UTC)
X-FDA: 84228700668.06.E106F1D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 96218A000F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:12:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/fOlfKn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cjcIet5p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0lJioIsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=57YlfKzL;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765969972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNLPo0Suitq1KGHF8phiMQLQOqtB/rYxJchQQ9gBr6k=;
	b=4mW5r0eZ4ElAHvwG+DeUp9zm53a6KrcSUdDuWAnKMqcPBHdhv3DLIl8cnuoh1w9BFgWgdf
	nO1SueSzr0MfFrf+XMC8wG50S+BNz29rzbye//qAZhcwkPzBWVv+aWe0zhIJWT2v3pT7nv
	gVYvxbqFdhxDBQRrmOIKlddDCnBcs1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="x/fOlfKn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cjcIet5p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0lJioIsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=57YlfKzL;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765969972; a=rsa-sha256;
	cv=none;
	b=cc175YA6A5oSA5cHYf56sCKZRihaxcAWNek8+P/zQ6Xv3mkQijib6Ui24iHdMlwJ+60ESF
	zJkExHy+v5nEmaPPeNRHqB981elCdC80mzzJqx2shYUFttOdcKAyAIovD88fKhdhNo5YWG
	eHRWzBQywJFWuLp2JwwyKa1mOWJSrkc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D59D2336A2;
	Wed, 17 Dec 2025 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765969970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uNLPo0Suitq1KGHF8phiMQLQOqtB/rYxJchQQ9gBr6k=;
	b=x/fOlfKnxpxa5mK46r+OIgIJ26MUK6UAwjDCEnfXmAiSr4PipmAwNH2VFtT+XOXPHW8cOC
	X5SK223QF9fbbkfbphztIIoso25HIRo8t227TYy2pOV92N1zG1MOngllm07WGE6nZQ93Tv
	T7MEc5G0oXqD2nzkAeTCayXJm5ULkIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765969970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uNLPo0Suitq1KGHF8phiMQLQOqtB/rYxJchQQ9gBr6k=;
	b=cjcIet5pCprl0byxQOJIKXTgmP+WJKRlDh6h+5RL8CQOKLvtdDIxGzTCS0n8FrU9HktQD3
	YEjnlBir4B+C3CCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765969968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uNLPo0Suitq1KGHF8phiMQLQOqtB/rYxJchQQ9gBr6k=;
	b=0lJioIsXRtZuod/OWQo63LUD97wW4vaZbvYVCrLKUkP3v2T+xlOc8HX6LSiIqChU4zeql7
	wds5jCR1zvjLVyb4OfJB5/gKtr5nNBpqsgCeUdWhEENKv+kLsZoZqJBQ7E9XIUhx4YYomi
	Ku7eTMq5eBmE3C823pQo8NayCIPhQos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765969968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uNLPo0Suitq1KGHF8phiMQLQOqtB/rYxJchQQ9gBr6k=;
	b=57YlfKzLWBOUqeY+BjdrtrjMyiJ8gUigfamd5y1DIe/yzjfs3i9zKjKrHU9y+MCiEc13sn
	tCrzw4sjoXK/LMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB06E3EA65;
	Wed, 17 Dec 2025 11:12:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SQVrKTCQQmmxUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 11:12:48 +0000
Message-ID: <1cf7675a-2de3-425f-9938-af97f7c6436d@suse.cz>
Date: Wed, 17 Dec 2025 12:12:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to
 zone_set_pageset_high_and_batch
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>, Guenter Roeck <linux@roeck-us.net>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hpa6uouuu6jtatnhhq8pjxx1kjs46ow7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96218A000F
X-HE-Tag: 1765969971-82707
X-HE-Meta: U2FsdGVkX18PEe0+otwkrnx7pe0J7XYOFDPXPVFo49RDcItCFGW7bzAOQNC0i20QIMbVxUzKZrrJxrLOrl2vFbbv3rZ7fxAU2u26n3vS/vzOlEAaFiIiGKHMshBbYP4oNaY/U7czhBLKbwuu0nl2hyP0AbGolRFK7FsYsD84BUMIYFMT/HTgKTwvYJWgRqeZTvfldI5qryft9XoNXcESWPzoicx9Yw/m5jGUt2rqQdRi4433uOy09oE58bBZ2RR8qyqgnBFivz3wQrb/8aV8LP5RRw+ySdn2jOrJzMybLgKPhjYM+LjUlRdmaki7oYnPQoKF+39XCkqtc1o+bUYl1/42ZMb58vSV5X5JOawvU+ZC99P2fAdwX4di6JB+4Y9v9NiZ9f5GGh1YTWB0yxlI6Bf3N9grve/ug3TfYV+bS96VaPwXDrz4lZgV7mLkliFfChXcC314IiHzxtAT4Ry1WS0Qz1X/VL1yeBHhmVuVmC9M5gWQOy/XwtZ2iwzMmqUyxkyTZo5iKzNJrjXNf3z3XN4hbG1DzzjOSLsjiHWTJBHueidiV2wwR2YocI6Z3gO57wavnBxeVRRuzhJ9VOsRgSS3LYktRQYBCH6ns7csRDpXaW0TCh2yMbzU5sCmY5l56owe6Do0/T+DlY7kF/oTTJeZ/TM1w91c7rYC8/9BNvCrYcpyfSoZb3qDOD6ZMk5j0mIkKSgDoyw1HrTULfsKc5eG9wwQclfLHM6xPsCjDFuCFHAjBh87kLsvuGtzXdWg1uneckUooSTmq7xoZgq6/ZOVzP7Zz60iwlbTlmgoF3tMDjKyvVdMY2UP4MO0g9hgwri8iqehnWUiOATKvbxaR7j+Lkn+LOK25Z/QUAUeCyr6EnLTfK8rbPZ88nl1+8qnmjInvQmdWusF2tevrTctkljc+zMhqozR+cAkXH2maR697TsiO/aP69tiWANyGW4tb65ytQp460VEfxTkSfU
 rYhuMsNo
 JIWQgT1/NBLBdFsqTxDDU5Lw3yf3plsicH9NrkAAXs2J8fBraFTLTKIYI3dxfWmqPt+X1MxDM+FTw2bbL2U2n7zXY9kx5I6MpNhKQ6uXcqeUapRSq7Q3/yd4BEj8LbwJyyDQt1/SGHAN3BX0taGpWGwJYRqouva5CZ9xjyeUFnUxI5hsZLjDm74YiGJNpf4WE/UWAf90RFWb62/QMWldaKtWkTjSTmD6HGUxSCtH1meZZWWNIiSV+bTBjWR5OZv4ut8a43sYRiyU0fXYxFA1sOWVrFGhCX1U8FtLSlupLD+l9w0y0HEURQsP3IxaWMeAoNqEH/zFSbgbIuOxwMu5JaZvt8GBagTQwcWuy7H8lN41q8s6yo9IkGUO5ZwVIPvXzkdwvWUZnoHhL3vzd6UmNDgYbnKBqBBlb21f6OkZELrwjCxhGBVV8RW+UMYLDKZb/qLKONzt8o4vQ5Oa/ry3R8Q/p1qqcQ8yhDQ9Ujv6TNnFun07zUU+zlVqx+V+21f0zXr5a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 07:05, Joshua Hahn wrote:
> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> 
> Since in the NOMMU case the reported-to-user batchsize should still be 0,

Should it? The value is effectively set to 1 despite what zone_batchsize()
returns, because of that adjustment this patch reinstates. Also does anyone
care, really?

> we would only like the error handling to exist in the callsites that
> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
> 
> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
> on NOMMU systems.

I would rather make zone_batchsize() for !CONFIG_MMU return 1 instead of 0.

> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> Reported-by: Daniel Palmer <daniel@thingy.jp>
> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..10c1297fd3ea 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6045,7 +6045,7 @@ static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
>  {
>  	int new_high_min, new_high_max, new_batch;
>  
> -	new_batch = zone_batchsize(zone);
> +	new_batch = max(1, zone_batchsize(zone));
>  	if (percpu_pagelist_high_fraction) {
>  		new_high_min = zone_highsize(zone, new_batch, cpu_online,
>  					     percpu_pagelist_high_fraction);
> 
> base-commit: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb


