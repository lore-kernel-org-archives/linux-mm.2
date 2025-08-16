Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63795CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E376B0399; Sat, 16 Aug 2025 03:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0E16B039A; Sat, 16 Aug 2025 03:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05E56B039B; Sat, 16 Aug 2025 03:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2EEC6B0399
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:27:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F35AB8D63
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:27:48 +0000 (UTC)
X-FDA: 83781791016.10.24388B1
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 039F980008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:27:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwNmQcRv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329267; a=rsa-sha256;
	cv=none;
	b=d3J+UfSDtyLU3XjlXNiR9rsjazDgb6qrLCG44arxKHOGFo7bLs6ywAAQMrXHQKphsVABX/
	Nlc7AL06WO0NaY5NoIHoiOzjJ5HwIwtXJ7zgt1Rn2ruX+5ql3OtIgIqWwxVixaOc5r2izN
	HxAehrjwzoNxSvNGnFuqYVXjvQxzLC8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DwNmQcRv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VK3S2HQnHIYKRdClnZTtz9r6rX8e/sKg8CH08PMYRQM=;
	b=W3bk3YH5CrETWHZYBC1V1p122l0zBNy/DoVd0A0YWIveCjpog0n5kmSsEgoR6bdVB+MURl
	JNfNgvt1ZSN+ui19obPua/2/toE9sRc/EsSUojKQg+W0n+XmULT6eYkGzWiW+1GLfeJeVh
	SEdqmDvskM2jCZO+W0KbbJpOT6nTuec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CAB675C48CD;
	Sat, 16 Aug 2025 07:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9BCC4CEEF;
	Sat, 16 Aug 2025 07:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755329263;
	bh=BnYohvptaGZB3VhqiXPQ4b4Ep+yyPU2M3Io47dY3YDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DwNmQcRv7mxNbBeAZGK4Q2LQ/w+qHBgOmDFNoTZUO9wKbE0+Nhs3OGrksj3YP7AHH
	 kYyeBtYrtq/cl5FbOAmUf6/Pg7xZE0d1bPz1QIwbZri44l6zwhIDTUVz9Oimd0gm2E
	 KtR6fp+zyFs1L/2wmRC46cMS5tJj4wLSMKYKT4E4=
Date: Sat, 16 Aug 2025 00:27:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: simplify lowmem_reserve max
 calculation
Message-Id: <20250816002742.5582d91edc4905e3af69480e@linux-foundation.org>
In-Reply-To: <20250815024509.37900-1-ye.liu@linux.dev>
References: <20250815024509.37900-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 039F980008
X-Stat-Signature: kqi69x6of1t6dxikieuoepjmr7hkxgg1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755329266-128360
X-HE-Meta: U2FsdGVkX18KBmqeStn44TtvPhWSlDvnZO82tyK8ki6fQOThvSSGP0g3oKgN0VXayOgOnigvC/eUJsQiwai3QWya4eQCdFw4KV08ctc+j8ZfjDCZXFxx89Y6Fxfvy0fwmFSbFebnVwIcMj/HZnoMVp6JRHsAhOIYhc5D/WhEjJdGd4alzN97vItNsW17HjQ67EngwF2imzi0l8IyuBmVn48GSGW1WFpfERFJuKyV2oArh98jRm2vEIeBJn1tlnWEfqK+ge4MPQS4EjZ8LjoCHHRLoBF35XXTdV35kHwdU3w5vLqI24pNg6uHPKsRSgh/ZdDvMumXSzR4ki4dmX+UKp4x6RRotbtHreCDCK5tKN3cO8Ftgw9AgouIny4sdhhvJgfZBf0kAsOxExYnqfPCS3+4hIoRE8nB/Yosnaj7exdSlpmc0gnombrzR75PDxpRhmMsPUrSD3ShD3ilkNbHSYrB1pOVVd9PdbmD4AIc+lXjQzF7YZGs3mwjC5TdYp9/qkyiSNaBoGSr5TrqSglTUoisUv0AZJu7pAGAX2Pr07WrkFw5gI9p8AHoSZRxyX1nXlN5mOqLtoUva0VAx7oR0P9xEjIfWTwcC0BlkNxfSxzRr6AS8TcBtcRpwCWAxgvn2Dr0wHHL4HEYBmU1CKnCc3DMZTRKvY3BIMYOMUzBQN/3zjova6Gx8Zc8Jpt2cPv99JtjNAmePUyx1gE2RByxXvik+NejiTRbhslVDFUSNWG3YRR5HG2l8Jrnw/y31QTafX9RTl8eNdviX74zLvxA8+eQ9WWUpks/dSFsYq4L37Ro1DYHl3qCWQZnmrTlEoD/dsWpG54M5J/xVo0uDVjm4C+4cXEyei49aA28TUqqtIRRNvEgVLYo//Cw47jUblBSmMqxfh7978UGXkA5cfLJAy/5wOaaRvzxj/8v+dQagZNcX3JL4hfOjt31s3sq78WcGp1dh3gYaQoh76BLaKI
 +6y9QNze
 gLz/ZdMWzp+HlTZD+Yv/kxSNbu02YyPTDQ1zNNmko7gz8pqkEo9T9TtpAvWFTcJ1k8FhbooFzL4BfIkosS9ZtGtcoqbqurxy23AdldJeX47a5FbvTJAEyiSgFhoASXtLqBBtzlNS8vgEtAt5s9ABUkf5e9/v+Lr2C31jcR8fMsUqbJ6QXMidrWt4Sk+WO4X1iRDAcI1NgV9YvXkDzKHvluxxkkHLv6VcPfwRtiVtTrkCzPhx0i0RkWhdpyEdzpmK+rQcc7zhAGPY2/dWg2suZXTSMVU85/httOcUV+KabL8UduF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 10:45:09 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Use max() to find the maximum lowmem_reserve value and min_t() to
> cap it to managed_pages in calculate_totalreserve_pages(), instead
> of open-coding the comparisons. No functional change.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6235,16 +6235,13 @@ static void calculate_totalreserve_pages(void)
>  			unsigned long managed_pages = zone_managed_pages(zone);
>  
>  			/* Find valid and maximum lowmem_reserve in the zone */
> -			for (j = i; j < MAX_NR_ZONES; j++) {
> -				if (zone->lowmem_reserve[j] > max)
> -					max = zone->lowmem_reserve[j];
> -			}
> +			for (j = i; j < MAX_NR_ZONES; j++)
> +				max = max(max, zone->lowmem_reserve[j]);
>  
>  			/* we treat the high watermark as reserved pages. */
>  			max += high_wmark_pages(zone);
>  
> -			if (max > managed_pages)
> -				max = managed_pages;
> +			max = min_t(unsigned long, max, managed_pages);
>  

Use of max_t/min_t is usually a sign that we messed up the type choices
somewhere.

In this case, I'd say that zone.lowmem_reserve[] should have been
ulong.  Oh well.

