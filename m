Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B38C2A099
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 11:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338766B012A; Mon,  5 Jan 2026 06:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFA86B012B; Mon,  5 Jan 2026 06:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1E96B012C; Mon,  5 Jan 2026 06:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 094806B012A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 06:25:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E43B13CF78
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:25:55 +0000 (UTC)
X-FDA: 84297680670.22.1ACDB9E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1F557C0012
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:25:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkwVG1Uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/w9skyNn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkwVG1Uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/w9skyNn";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767612353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhC0QiQGoj/EOjzJZ8faxfoHih267ou3ZpLrHUX4jh4=;
	b=qqV1N4EuZc3FX34IFhyAw/ZJZiRw5QzKJrIdj8LPCLtSgi8ZD+vnq/LNExFhpa0/5i8glZ
	kwXoQavoaXNTRA0OVfPyyAkhGXdnqnSKrEHRf/a6kM0Z263VA/Bl/ylqckK5peh+b1PC76
	K9phpTm7G2hWjElqC/RPw3T+6Jx96+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkwVG1Uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/w9skyNn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AkwVG1Uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/w9skyNn";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767612353; a=rsa-sha256;
	cv=none;
	b=oZp1Q7MU+aZ3YpXCZFMNMwqUMPJeldWhJHBoKFvi3nDPWxQ/u5tVLDEQdzU63CKjLcuxW4
	BfeSYOQOGCrK/N1SK+8eUG6eiMr+Li8A4+bwgQamvOqZTgg2VMzKRgIngOTatgalpOMuTk
	weJZLVq1Y5wt2GeEnREv7yW6hBqp3KQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 046E633740;
	Mon,  5 Jan 2026 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767612351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qhC0QiQGoj/EOjzJZ8faxfoHih267ou3ZpLrHUX4jh4=;
	b=AkwVG1Uc2pCjRneqYnOBJAgxbKLuIfO7wJ3g+1C1TxNdK2fFfRv/9bt/LTxrG0kEZmkEV4
	6k8x3ncRXjBwtaVH0IG5QM4pmFGBvHPSrVlLjiEBc5yUzt9b0n6RHPyFfsAvyuDUsz3tzS
	3vYFrosPJlYLUx3sNMpngYgzpOBWZwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767612351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qhC0QiQGoj/EOjzJZ8faxfoHih267ou3ZpLrHUX4jh4=;
	b=/w9skyNn1qCCyYatfv451Gu5EeBO+zbKHYPiRR8Zhdw3O4XpX7ToQtchqQ91g5aktXpD0V
	saXZPUf0AfTyFDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767612351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qhC0QiQGoj/EOjzJZ8faxfoHih267ou3ZpLrHUX4jh4=;
	b=AkwVG1Uc2pCjRneqYnOBJAgxbKLuIfO7wJ3g+1C1TxNdK2fFfRv/9bt/LTxrG0kEZmkEV4
	6k8x3ncRXjBwtaVH0IG5QM4pmFGBvHPSrVlLjiEBc5yUzt9b0n6RHPyFfsAvyuDUsz3tzS
	3vYFrosPJlYLUx3sNMpngYgzpOBWZwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767612351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qhC0QiQGoj/EOjzJZ8faxfoHih267ou3ZpLrHUX4jh4=;
	b=/w9skyNn1qCCyYatfv451Gu5EeBO+zbKHYPiRR8Zhdw3O4XpX7ToQtchqQ91g5aktXpD0V
	saXZPUf0AfTyFDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DFFB013964;
	Mon,  5 Jan 2026 11:25:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IeqvNL6fW2laXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 11:25:50 +0000
Message-ID: <92c5d1ae-5b02-44dc-a7cf-a6490191ab76@suse.cz>
Date: Mon, 5 Jan 2026 12:25:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/vmstat: remove unused node and zone state helpers
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20251225210213.2553-1-richard.weiyang@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251225210213.2553-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: akuswjkmp6zjhh6xieejhu535rbdeomt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F557C0012
X-HE-Tag: 1767612352-586265
X-HE-Meta: U2FsdGVkX1+TsvZmu+gBQAETXEJgfP48oM3Ct81NDmVDyh46OcooTnqZNhtloWT6zu0t6ehbmQJs5BNloTY8I8Bd8tClPVsrq/DKAXp0xixs9W9cLuPVivv0OHfqYHVhrtkivI/NvJT0StVatHS6enc7h1sIve3wToHoX4pgDF+q1UVwMWZ4wPdDMuc1N2o588xn7VEE3CBLPSb0E3+512myNlrHqFZZXx7sZnVTM8Z62jciOS8WRG3Nt/8IWJV3NLAcAHdfewK9FS8+jzrkG1JsKJO5z7SzlqHGjrPa77hCkLHGo0sGv0F8keAmACVnRHnCwdelK9W2cUNr6BBz7bqKmHToWODRzoWrka+EeqBTQfgpfxLGpNyT6PzYyBvaGTAKwqDlEOmG55iu0HrfjHH/epFvYBp1/aJC4eWtMXNTOV89EvMC027EZ82tmXv55JY3zIoqr2BHHki5kCq50Zuu/UwiCQ3POBaVy2iaKrk3IQCqA/viI+jQoPH1MLB31+8aOQwTMcG+q+Iu0b2aafryMM3RLAlCrX74nZIEX1cJlflc0MvxODus0ls/+lFZXUUg6a7aQeey3D+WqA9v7RX/yeoSlozx8dTt7nP9NRqfENS64U+xzhMBN3e69UppNj+l9QwM7mCJEkKPxYFH2UzQF0FyjR9TDezn9uaQCLJgMYBSo/9Zi4IrjlywH1OD2LZ1zJTrX0tgpC1DZWRL5OE0JkzqlJXFB7NZCyDlxCtRcm1TRlmOGnmTqmR8jNxVUGfbtWE7DPPwdUzWXan+AT9qFWUtgqkvEbYzwmmCc9gpojHB0Xy7xtWXJtNZHtPyypivLQJn0NURmw7/opq4ZC5mOTtvlGRs8RLsV30IvVFq5/m+08RrUrP4UZom1O/5ZXtRy/qRweHOerKMZFlJvPaG1U3ot19jod4Us2cKcJON7xykuCLXpRM47i/HrB5eeIqgqLI+ify2XwZSlqZ
 6GqVxNtw
 dgJVVP42Xqjyc/ba7GVJ09nLjpE7xuh9zM3sMeDM0PAjIuwoJ0tV5a5dtsP3sdUbwwWqqRFBp1QNnGejM/a0uzunXEVmRePVrbi76eSCAgZjj1U+RDMzj0VzXWlwC0havzF0S/vTU2NPyR0Ai9Jn+U2y3HV8HsGhLNhYz943iiw+ZAHCw/Yc7SPczJawJHOw1yARfF6cHIrHmYpMeh3DfP2VWnkLYk6jF7OCVerw5iSCZ37aI1h80mwbI3cmUpuA7c1j0BoYXj+YMgQxdVmGTbCLUeDXWfPjSGqEJOibU8Ddfn3xzj8msVEEMnKi8yOmNP4mhLLljtLX9LX3CvvTdUq5JPg4ytceRqT24u1VY0eQjzvTYfLTYOk3vsMBiYPoFJJOO3FBiNWHcsbO8/PkRWf4J8USqX2yCEpTQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/25 22:02, Wei Yang wrote:
> Several helper functions for managing node and zone states have become
> obsolete and no longer have any callers within the kernel.
> 
>   inc_node_state()
>   inc_zone_state()
>   dec_zone_state()
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/vmstat.h |  6 ------
>  mm/vmstat.c            | 15 ---------------
>  2 files changed, 21 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3398a345bda8..cf559e2ce1d4 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -286,10 +286,8 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
>  void inc_node_page_state(struct page *, enum node_stat_item);
>  void dec_node_page_state(struct page *, enum node_stat_item);
>  
> -extern void inc_node_state(struct pglist_data *, enum node_stat_item);
>  extern void __inc_zone_state(struct zone *, enum zone_stat_item);
>  extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
> -extern void dec_zone_state(struct zone *, enum zone_stat_item);
>  extern void __dec_zone_state(struct zone *, enum zone_stat_item);
>  extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
>  
> @@ -394,10 +392,6 @@ static inline void __dec_node_page_state(struct page *page,
>  #define dec_node_page_state __dec_node_page_state
>  #define mod_node_page_state __mod_node_page_state
>  
> -#define inc_zone_state __inc_zone_state
> -#define inc_node_state __inc_node_state
> -#define dec_zone_state __dec_zone_state
> -
>  #define set_pgdat_percpu_threshold(pgdat, callback) { }
>  
>  static inline void refresh_zone_stat_thresholds(void) { }
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 090b5c5294b9..16b7cb24d411 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  }
>  EXPORT_SYMBOL(mod_node_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	mod_node_state(pgdat, item, 1, 1);
> -}
> -
>  void inc_node_page_state(struct page *page, enum node_stat_item item)
>  {
>  	mod_node_state(page_pgdat(page), item, 1, 1);
> @@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
>  }
>  EXPORT_SYMBOL(dec_zone_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__inc_node_state(pgdat, item);
> -	local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(inc_node_state);
> -
>  void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  					long delta)
>  {


