Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A689DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 00:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB3E6B009B; Wed, 19 Aug 2026 20:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B756B009D; Wed, 19 Aug 2026 20:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1876B009E; Wed, 19 Aug 2026 20:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 598E76B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:53:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE8A812069F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:53:54 +0000 (UTC)
X-FDA: 85119825588.18.5824F5A
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id E5854180009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:53:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gd1oT54b;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787187232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fE6H5l1H4Z77SfNfHyJjwQdIzwaFH1cGcv/CN95ewTQ=;
	b=jWL992oybGMCMi62zuA8iSwGNETAUWGVP1T7OGmcp9aPW5DLg0eR7aUPa26uTdgEZZRQwn
	vHrRm9xg/IyeKaeDcnu8zaK/fY2TNgoMX0Ad2aIC3NMoib6cl20wpWtiJlxq4RzckqNbQ7
	EAwRxJLsowETPu/K7HXztwKZ6qX37B8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gd1oT54b;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787187232;
	b=33x1caQpa16wW6SNr+s769m2xp/TLvw3A22F0cKfCU2N0g2VkuxgDwGK5zdCm1d4mqnzm4
	P/9vzot9DF29Z4DFkWGVu0a8Y495wp6cV5yDNyt41ErC74dxr2NqQbNLEldzwixmLfrUzw
	KJqQxLzjTI7SbfbF9whOFu5UlnJa33s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5IsuarZfSd5llKVGh9q2wBsTwYfZwdg1wFWVV1JFi6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787187230; v=1; x=1787792030;
 b=Gd1oT54bTIHe3E0RP534LE2QhfTdJeojPyc2umu0vFMBrBs+i1fDcF5vjz3LIkHmIuAXCvA2
 geWRCKcjGSvH629yMX0MjJAghTDRQSR/RzCSPKlF8AOhMUDB3OObqnFW8MQ3DVypy6YKw1xhEFm
 GSVJNkiKtd9h+Gqep64MDMGg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 07c8e31ddffe1a8d;
	Thu, 20 Aug 2026 00:53:40 +0000
X-Mizu-Trace-ID: 07c8e31ddffe1a8d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 08:53:35 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Message-ID: <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
X-Stat-Signature: dmh3g6bt7xk54wjuxtqzzje13tu3yxez
X-Rspamd-Queue-Id: E5854180009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787187231-293455
X-HE-Meta: U2FsdGVkX1824j4+ICLm2A1/OasoekHlwopIYqvmWNtOj/iVGqjSp34OTYEpA4Wu2A3WqwVtra7OKdxBLUc6AdIyRhijMkSr+p0tcBGa4xLdM8yEiPBKNqLHDimNe0TGvvik5X+81XQoSDSzc9HykHor8IdkvxmoGUkZwzCS35zwtiKclmk/EQ9siCjZyOUAYc3q/oKKdeZZWBcuiRDvzbQCSNqsrK/sqvEd6yFoxDc0nGNlHtM+ghSdIrTDsDMXnvLAp5oYKaibnwLn+NA6pG++HEj7sqa8qBr8Jt8dUJbf6SxltO2QmuI8fE6LNjU/A7Kk5mOhpwN6n+mpMxu1ibzADGCkhg4Ubiw6RNeVN+Jw/kklz8QvA6JgmcErQyOCDMBBkDGGnhmeeGL3MUm0FzV/KU5G+ixGJOUrrUnS77APIaW1I0BLaAC7CwMRcZpgHSe5m6sRbBc3cy4SmPUr6O8U6fnYMJCAhzu5SauYUrxi1eBzEcA3OwfWehsAcZIcvLF/ytrTjebOwRgc9J++0l7BCyDgT8/hgVmxHISKXBOcIw8pRTRMBnNZClg2bniwesWQJIIgVv29v5WrwKC0MMXgO7BrNmnSDBtWlW4La4FANgCOSE6bb54kfQMOvxSMcaWXbAgDN9yQElcEw2NEGrA/pxEXejA68JXaYxuT8UIxlPqd2hcbHxdX+A+6wHlMPpr+HxcYoKBthpiDEE58ZjlV/23XiJzZ9YssXhjJAuhsm/cA+5KsHK11Mcr3b8dikjlQBBv2OnBN92LAGd+ZA46d71/A7z2x665VWlAQOPqC2FFnLw/EKhVNTJS4AIxc99MsLJMcrJJ3XH8fhid7N8U3KZOlrTkHdy6b0vV2nVvbdgkW0oxYcPqE8qtKtcAn3iF5MUWER6HxeSHy1xZ6lLqiukeoenpfIBGzs261lFXdP+LyOtC12kwQ2S2nxB6BeWKURIePBvKIlNWqdCY
 tNLiPmDU
 obiQJLcpcwYKPBRg9cd4Sw4siNdyujgvDb/QtxnSelJv2OgRwWH0TZz0o/+b2vWlSOl6pTD6kE4ihJC84kz5X11mkBOAGel/CrRHD9JtUjpyWVzxn4nD9prPzsjNGNW73TY3sDKl5tEwh4QpFOVnbkZSAxPJsKLhpfKmZJTcTRtN23keb6oXplz1VbE3ZBtieCHktzcT93X803uZ7sv/o207QfChbDiAxg1UTTgORcosD6tICRhAflnA10vKlIi4T30FBjDaztkSq4KUL26DEVyGksRwhK0z3Y+1M7+9jbRHxLVXXDiIGa+A8KjZhx8WwYnsc7gmbVMACmu2ZUQ2DhbO89had2wsCgJR1QWDUJpQF0yJD3hs+z9Ltsk0rYNARaCThuYYIt9W9v0W3RQn1rIlBc08ZhArd6bvGxK0WhV2ISA1HWnVTh6gnXtlxx8xTRqfPdH79Pi/9DXLoYAz2JXDnIpkGKXubHc96/qBJxKVevn1sKCnBw6r4olt2/N7K1MX5BDtyDhFZDoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper should never be called for an off-list folio, and it always
> expects the folio to be in the oldest generation before doing any
> cmpxchg. Add a sanity check for the off-list case: if it is ever
> violated, bail out and keep the folio flags untouched to minimize the
> damage, instead of silently treating the folio as if it were in the
> oldest generation and promoting it updating the flags to an unexpected
> status.
> 
> Also rename the variables to clearly distinguish the folio's current
> gen from the oldest gen.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7169cac60869..7e3ae0c6cba3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>  {
>  	int type = folio_is_file_lru(folio);
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>  	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>  
>  	do {
> -		new_gen = lru_gen_from_flags(old_flags);
> +		old_gen = lru_gen_from_flags(old_flags);
> +		/* This helper should never be called for off-list folios */
> +		VM_WARN_ON_ONCE(old_gen < 0);
> +		if (old_gen < 0)
> +			return min_gen;

As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
could only happen inc_min_seq() call it. While inc_min_seq() call it
because inc_max_seq() need increase max_gen to max_gen + 1 and found
get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
be put in the lastest max_gen. It may not be expected.

>  
>  		/* folio_update_gen() has promoted this page? */
> -		if (new_gen >= 0 && new_gen != old_gen)
> -			return new_gen;
> +		if (old_gen != min_gen)
> +			return old_gen;
>  
>  		new_flags = old_flags;
> -		new_gen = (old_gen + 1) % MAX_NR_GENS;
> +		new_gen = (min_gen + 1) % MAX_NR_GENS;
>  		lru_gen_set_flags(&new_flags, new_gen);
>  		lru_refs_set_flags(&new_flags, 0);
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> 
> -- 
> 2.55.0
> 
> 

