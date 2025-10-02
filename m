Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A27BCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 01:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8751C8E0007; Wed,  1 Oct 2025 21:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825EE8E0002; Wed,  1 Oct 2025 21:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762FE8E0007; Wed,  1 Oct 2025 21:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6222E8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:58:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00B331602D6
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:58:46 +0000 (UTC)
X-FDA: 83951515494.22.83846A2
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id EDF0D180003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:58:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBMo7NOK;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759370325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGJj77OJTJPdfBOSmZlqr5kypF1L3WfLsVzSKBfYABs=;
	b=JiidSxroNlNk9UQCAmEQOVcJG2zA87UNtn6ZvlBbTKgE9R5snHhWRVeSk63HJAmHy29g9a
	fuieZqBGYH/2PR98ioorCdJOBbi2Pt+w3BrLaKwTe5cGyvCO5qqSJnlB832IuWaOuLV6rP
	LKT8WWmu2WHjPhRqM0WP6Gnx82qO8HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759370325; a=rsa-sha256;
	cv=none;
	b=izKEbO52diZ8g2eTVlha/sVy0T/rj/XztEVNgelSUFYAjZ5jM9nyZu0GDLjB+okaDzahkT
	5GYy7D2bfouGNzyeSDGHiVzbgcRo6rlOeM3e0Vj9RIYnAGPp01DVATUPd0zfUk71ZHfB4B
	pbLcLO8DUl2hYIsfKaiLD4zYVgr1+HA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBMo7NOK;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a647617f-add7-499c-81c9-a5ed628e34f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759370322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGJj77OJTJPdfBOSmZlqr5kypF1L3WfLsVzSKBfYABs=;
	b=EBMo7NOKA303LIr+j3Uw8EFdp5qc6UaffZTX1Y1PftVy86HHaW+EYWawkURYOvRx+EvFsR
	uPHbv9w2XK2x6YoxacfI6ZjLgklN2baW8h+sVETQXeDZ4gQMNyQvuGAWfkA5uTjLilIyR4
	5YjGTQ06U2PzWD0/O8mHZxrDdkzA3+c=
Date: Thu, 2 Oct 2025 09:58:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/page_owner: Rename proc-prefixed variables for
 clarity
To: Hu Song <husong@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250930092153.843109-1-husong@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20250930092153.843109-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j5d7i6ct7odiznoyq6s1mzzfru148s59
X-Rspamd-Queue-Id: EDF0D180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759370324-456837
X-HE-Meta: U2FsdGVkX18aQfiqMu169U2GXln9WJZab9vy/LpwkrfRay1Bm4aeZW1ytLYwhbHw4/r6H62nzu+nl8ynCG87PzxMkd97K5ejrPsACgaHBZPRqM2o7Ts+e1stf/VMIIkyqUekzkMzNlAIU+8rSnmMBRk1kSSX+UQVw80en+Zl1lK5hfGKfxSSgk1UkFtBg2Y+Qj3Tw2w8x4n8Y0DQqTrWH7gaBCIV3bGmh2xx+CdxqKrbkb+9Da6prvm/PWMkKpc7l9wR+wzOA8/1U2j6eEr3EOc4VrYWa5HROSardX1XTVj/cI/3XB5hETEJl/a3G+/vVb3YOeHx4KAkFYt+IrYu+ZymSX4Gs85nRfCvL6f9OOJQtst8FdBzFurVMeFY6OSamGOQP+yuc2a2CB+uW3I2DHFtGqwqNq0w/kqZeRRbIlz/rL0kQxCsnPuFIgsDEBGpNGM5x0c/SJSJUUgku26tlAvPUWjHkD7ZuZwlqbHksNluPqQjQ+nIKh6pDO4vma5jX/yvEKWnDVthsZGShmJ+jqUhQ9CBpDLVztbVgxtOU8VdNa0U2qacatsH48rSSLTr7rjmoetQuWTTvbDaTneb6Ir0SieCUnP+PrEUUxBo/sangQgppClX6jEOv8Y4L31Agf7lYIIWEdMUbEZA46j/Vup2gmSuNm4GjpbzC1tRMLw/7rfKUeHi+d9ckPpQTtQfRvcADfnPD5jZoG1dZ0xsuZGRLJRj+aZVs5MwpRLc5o0NrI5mlctBhFYP0ot+33gwlGHo1btOaM4qM/prge/1WpRIaSHklvXORhht102y7vUkQ9CDQ4l552A7zyE1kQb0o4yigjBowyDXbFX93+aq+i3wGy5qI6At0joCmCsYFudURpFh8LUHhYXoNmiSe0zPSP8/7YxebUQ4uQ7aWfIdIjKw600wC0QIrn6/oruKEzIZmJ/3Pc+kXAy8UW01Hxpc0gLeEvtxHsutRmkwyMZ
 WPN/MA+s
 nEl2FrMLN9SlW4G4pzZbX+lts0x9gPfSxklUUg6OJbAMR6gPYQpl+o9DUyrpj8IUnlfTlquyHwQgK8iZvbJJjXWVb8FyTo0e9fcBfyFi4LaD/ywEIvwhE5Lwuf9mTRYD2/v8b3KkCi9yew1JEzP8M923R9x1BkSeBxo8r9ebRb8CJ6AF2GM532Uw1pSmoT2LGVJ+ANC57zIL9f/rI1N5vVPjr+hOgCKwNlbgYFDPV8sFY2UccIMkh7X4MTMReyd0HBPc4Irb4YqR6Tei/1uFJRTTmug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/9/30 17:21, Hu Song 写道:
> From: Song Hu <husong@kylinos.cn>
>
> The `proc_page_owner_operations` and related variables were renamed to
> `page_owner_fops` to better reflect their association with `debugfs` rather
> than `/proc`. This improves code clarity and aligns with kernel naming
> conventions.
>
> Signed-off-by: Song Hu <husong@kylinos.cn>


Reviewed-by: Ye Liu <liuye@kylinos.cn>

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

-- 
Thanks,
Ye Liu


