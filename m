Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82898CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 13:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE5E8E0006; Wed,  1 Oct 2025 09:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EFF8E0002; Wed,  1 Oct 2025 09:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DE08E0006; Wed,  1 Oct 2025 09:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96A3D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:17:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 155B4BCA3F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:17:16 +0000 (UTC)
X-FDA: 83949596472.30.95BB3FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id C5B1C4000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:17:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sxSyGSR/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ItTL2eou;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nBTKxE2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ga03/4WG";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759324634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmRrN30rfew7e/j2Ph45WjnBsE+EVhv1bOJ8ZOYpilQ=;
	b=Mz1GMERWjolbQjB23+mzvykHCU0wsAi6LvaRJ4jjVHDe6ZcWzIvr9v/4/kg1OnB4OhvI3G
	BZUKxhGhfUDmLy9VGmGxyPwmMSNmvP51tc1mFjkFmVkDgyrxbbJMVFBLIy90yTl9czfal7
	CVI6vvsz9zlc/XYOEhzpKVeJ5Y6hwtA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sxSyGSR/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ItTL2eou;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nBTKxE2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ga03/4WG";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759324634; a=rsa-sha256;
	cv=none;
	b=KL1ztZMIpWiHAeEIECCSkGT/X68HvGetnJbMwwBQZuuuL5e3sQqNRp4BbCkkhE7kU9wGXL
	EE8emdrM2L09uCdvQyoHZQPSlTwLzYEebYsb6cnZvB/2g4UNS2Xlf96zfSLyN3jq6K1yBO
	eJAiqMSeOe49+LQIXuuaLWFBZoJpF88=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FF2D1FB66;
	Wed,  1 Oct 2025 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759324632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmRrN30rfew7e/j2Ph45WjnBsE+EVhv1bOJ8ZOYpilQ=;
	b=sxSyGSR/05AfwtKZW9+4jdwaNmsSnhB+gyiMe3kPKkWQRjNCOHzM/oypF7Fj1JqOE9wddo
	jMZ9UPUxIYrdvaivVhEZGQdjwLV95/0+mtQiRKalZYizeuJNUWnDPvjtkQ7mbhRtJBRn94
	4i020G8YVJscSoxjdsdpBysieOezSoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759324632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmRrN30rfew7e/j2Ph45WjnBsE+EVhv1bOJ8ZOYpilQ=;
	b=ItTL2eou8Wl55gSlsfk2xBhlGn0fW9gOu1DjoPIU2fQvVhlvsKKo9OqhD9qepKtTf8FQU1
	KBO/dXpB0OX89uCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759324631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmRrN30rfew7e/j2Ph45WjnBsE+EVhv1bOJ8ZOYpilQ=;
	b=nBTKxE2CepeBww3zK1xK18HiHHlmS4yHFNTHwMb33LlWKEKzQY8gWCEeGovIsS2ceib6uR
	zQkWjlKYcc7Yk8GP4UL90bXvD6LpWtYtZ20wH3BggZayt8ChXYkIUSXv6zvmFg+2YOP7/o
	TF3Sglo9FpWe4fR/YNvnvHMWuI3qZeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759324631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmRrN30rfew7e/j2Ph45WjnBsE+EVhv1bOJ8ZOYpilQ=;
	b=Ga03/4WGFp5aYpkn4UvpK3mtiZ39QXlhD6z5ou2eOXXgFe2Yb0LM1NA+Yu+zWdkKHihxLZ
	E9VIWO+maVJCeFCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A18613A3F;
	Wed,  1 Oct 2025 13:17:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZsoyIdYp3WjqDwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 13:17:10 +0000
Message-ID: <5e057255-ccd4-4250-8653-73040e14354f@suse.cz>
Date: Wed, 1 Oct 2025 15:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_owner: Rename proc-prefixed variables for
 clarity
To: Hu Song <husong@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250930092153.843109-1-husong@kylinos.cn>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250930092153.843109-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5B1C4000A
X-Stat-Signature: da3tqtkrqgcddhz5gk3cssm8dut7twot
X-HE-Tag: 1759324633-878165
X-HE-Meta: U2FsdGVkX1++U4l3dCtFVPrx2DFKr0NPfUJuDIOE1SoShnY2E66etGSK6lawydokOIRO9SBIt7UoegWGtTfvwWA1FpplqbUW7UYMxzQ573oEH1KLnWjoCMQuz5vuhZGMjL2gZyD1A99dyFTPUX8G9w221yIqSe6KaThkkEXhxHSCO1MwHgSHSjkPR2sGxC1gsV5ZPEoB+CA/AjEivbdZg3FyDej6CfhqoJupPaFO5Yq2FfX01+Kg8loagBszT1Va9+gKRHcSoZf2mEFAglt4fs2AJkNkcCR/4WxOvxa9r+DliUL4QhexxtQuBHrLYF0QxreD6/EXi5pPkoWrW9y7J0zie+VUlYe233oW6GRCBu4qiNrqLNIZbO2exfbIEK1uZfmuBwx8miIdL5fXfhjor1G1p5Kvc4jpyk4av1DUxZFiIMY/zowGsjpcsDVZBqsJ5gywYk0473EdH0F3qIPxC/WwBCUcPcASpTnad9nh6ihYzua3FgcCnHgTWZCbhhxnWloRDDGALlK3qP4LHupsQLjGcphP8kQj5Z7vko5FcZDfJJb8+z0BzIcxLNarHw4qsl3Imjl7UcIu4pB2s41bgjMl4zZNvBA/cOqoeG6Y2FtTl7MSLVeImjfZewVWgPwbD1iSsv+KeAeVP2+zRS77ZM+aBMUl1ed/PFfi7yXbI2tUj6+DE59Re9fKePDjdTPHmdpGw+vLRLmAFSzuGsSdUOlC2NzJ+LnghvE8E8oJ5uivV3B5PZiHXHkLt9D9KOnFK+aWT3NrpogZRFnEhba4xoD0mPAsUIiFd8zMLlm8l43cW2Pr6AtoQ0F7n4oXHxVIZ5Ho5urDLD4QTAkKu6xMyNRD7jx2XfT74sEjP5yXsZsxEsMtanGC/WeppzFQE5pY54YiU1uAG5ISRHON7xbA8HBNtyZBY9RgnpwgOf732hQze8TUr/XSPNcMxF6DUT7GhFbtkedfLQNzcfuMvDZ
 YJp3Wpy7
 9UcnNywCRxUaeYsU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 11:21 AM, Hu Song wrote:
> From: Song Hu <husong@kylinos.cn>
> 
> The `proc_page_owner_operations` and related variables were renamed to
> `page_owner_fops` to better reflect their association with `debugfs` rather
> than `/proc`. This improves code clarity and aligns with kernel naming
> conventions.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

how bout going even further and renaming to:

show_stacks_fops
count_threshold_fops

static means we can't collide with other files using the same name so no
need for page_owner prefix everywhere

> ---
>  mm/page_owner.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index c3ca21132c2c..bb88b72b6062 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -848,7 +848,7 @@ static void init_early_allocated_pages(void)
>  		init_zones_in_node(pgdat);
>  }
>  
> -static const struct file_operations proc_page_owner_operations = {
> +static const struct file_operations page_owner_fops = {
>  	.read		= read_page_owner,
>  	.llseek		= lseek_page_owner,
>  };
> @@ -929,7 +929,7 @@ static int page_owner_stack_open(struct inode *inode, struct file *file)
>  	return seq_open_private(file, &page_owner_stack_op, 0);
>  }
>  
> -static const struct file_operations page_owner_stack_operations = {
> +static const struct file_operations page_owner_stack_fops = {
>  	.open		= page_owner_stack_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> @@ -948,7 +948,7 @@ static int page_owner_threshold_set(void *data, u64 val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(proc_page_owner_threshold, &page_owner_threshold_get,
> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>  			&page_owner_threshold_set, "%llu");
>  
>  
> @@ -961,13 +961,12 @@ static int __init pageowner_init(void)
>  		return 0;
>  	}
>  
> -	debugfs_create_file("page_owner", 0400, NULL, NULL,
> -			    &proc_page_owner_operations);
> +	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>  	dir = debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir, NULL,
> -			    &page_owner_stack_operations);
> +			     &page_owner_stack_fops);
>  	debugfs_create_file("count_threshold", 0600, dir, NULL,
> -			    &proc_page_owner_threshold);
> +			    &page_owner_threshold_fops);
>  
>  	return 0;
>  }


