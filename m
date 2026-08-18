Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C17BC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA67E6B013A; Mon, 17 Aug 2026 23:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E575A6B013B; Mon, 17 Aug 2026 23:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70B46B013E; Mon, 17 Aug 2026 23:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9B576B013A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:20:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4064DA0A4B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:20:57 +0000 (UTC)
X-FDA: 85112938554.16.BADCFFD
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	by imf04.hostedemail.com (Postfix) with ESMTP id D377440004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:20:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U6CE/Y+k";
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787023255;
	b=WrYBjel6Y3gwALuYlhTem3YHOiwdT7uwsdwGTzCdDzxMjwgRg4XpVpFYgo1GNJjEKYCXmg
	3Jr7KfldDA/wd5yywYfDo6tOSE25nlTmZBgDU6qd430InjfEpC8RXTK3E/j2rD3T0zimLS
	USJMyjFrq9m8cqgz95GXuGFtssS3mS0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U6CE/Y+k";
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787023255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ml42erAzZaJsivMlHNNEw82oZ1gQRntfqRqpfkqjiY=;
	b=mHCru/rI5458ljd8tahYvqSFIRbgWM80MnjAniwbIExjD/VLabIs/k2T6ERSc5YotYqGUU
	DOupFbmW3mjePrLr3YSiiWvgc/gEbIIDff3fIjPcayqJ7LRJ4a+t9MsLh8kmfrpQ5Yt5Fr
	McQGxaRNTz8qIVrJaHdqNNyhekm+riY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=on55ZWazHyqpPiNAdH4Wavq80fcxZiwVjhF0oygLLiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787023252; v=1; x=1787628052;
 b=U6CE/Y+kCX4sPAsQolZY/+3rwiw2FBQkHlU6uXUZJLghMHsnVZ0WZYe9lvWpdkXsS7Gl9OmN
 Caq9RakqNh8xx5nAqogjHsMK0FybdLyjFHf5/xF57tU3c8IDT9zDhmwt0/xlRBTtopFThKM/yvV
 TIn7jG1uYVztOgwQ1rnN1rVA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 05ebf19c83237267;
	Tue, 18 Aug 2026 03:20:52 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 11:20:43 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 07/15] mm/mglru: move refault workingset activation
 into lru_gen_refault
Message-ID: <aoPPi1Y0a8umZuEX@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>
X-Rspamd-Queue-Id: D377440004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4pdtckbf5qu5hh5ocgsffgpzbczr8u11
X-HE-Tag: 1787023253-256193
X-HE-Meta: U2FsdGVkX19OCIUhIvTOXlD2v+FTp3cEfJdrV/Issrvrza3u90FVvPWZQJGYvVt6Ph2ieJe6NyOccW6nj+eFvoZQwNw40DQNp133AZIBV21WbZ2x78P4Yxtf5LtY2DGdQqaqQ4A5h1vxSHnCteLYcXwFYoz+2CCIlanfvEuJYIvZ8LHewfJHVJbZXRWvpIdcx6wfREzqSrLzmt79Th08WVRqfdzlM6DcXUIkR2aon+j7/wHaDrVZOv50McWYow/J0uxOZVn0YSHS3Je71QYvxkiJ124avpd1Lx1f5On26jYh0f8WO/bIUr/R+NWQh94NXxhu9s4fbt0zrA04HwNDTOzAbTZ5ygfeg4yIWViaU6PwSKXxHx1oxeZyPNrsDgUqgPV+v9wWNdc3hVvvHmH/Ehm38x9iiDgN48svat6V48cMzXdPKguQ88G87kj+14FHok742t8NQ19GaJeLWtoICKvBLFfJs26kKB+EQLZE0XMYbf6bCubkYXIgSSBeF6L/7PsSgP1aowTvdwponPD8Spvxk1DwOLh4bkzivtAz2+lJzrL0ZPMAw3GfM4NhUJzdhGgwtRtTB3WQ4ZzQKcfpTUrA0+EbGcVAVlrAhGZy9+TyzgWaNIHl+uTw5zXz/ZqM7kS+OD5MYKj9fUkSepM+uI9cwSaW6NzkzyJjvJfo5Aaf9n7+TUUAZ1ejML5Xv86oSHJS6QKxPbsLn/aU9odxe/Hk3459C02hpgjGeHMwsi1H8NXSCtd4U6GMYzeueDRSszPC+bqpbDOHVWItfVfi5pA2B1u8cXwOFTvUYyYMMJmyPOR1tKJZXJL0JjjDWkTEiuHMf1pLXJ2AoI+qCDelvmvTYxLShl6HsHHgRBSqdqsSW519K8CTHlsfo2R6hcdQGF3GWpPltbCzAPJwRs7qZtFLvyjG3dfxgOlgaf/eH8hBw4Ac8jOh0SpNEz6DBRPEVoeVh14YKrip/+rEbTM
 yfvOLPKz
 U2wiCNcNX5tyjDdPibHkybpsydX9aqh0cQbv/1RFpHmvJgcCntsDenoyLe5OZ/Cv8ZKp4WsRBwV04cISfiII4W0SKYsE0VuxeXgcR5iFzikitXWzf51+Lc0n4T+aXJh2e39q40pefOJCrb0xA83H3XYEEegod1H5I2JaMYFdU8yvlOPDsCvIeSOm0Uje7fCrrsQpjWNhTpreX5PiNvdwUiod3I3mIBppNR5ZH4syMZGDGPDf3/LOWwyqruBkziSZyzPu316CdDD9B0JNNI1AiaNQcIUmlPIoZuoD+vlmNCKAPDOjIxI8h5Tjdk1yZsf4VBzl5F71YUDq2w0BriwTT9/LkAstpeRNCsZ1ZjSzGF2iNMys/jBU51se9ln1hTYlKwH37gkjsRMnTz+owVme09H6yyvHTyde1fo0HSqlKSxdGhLju6AjtrAEZJlt6J0JFW/rZ4krM6epTyoCQ0tvvDt3vBVa6JPO3Vem8HdzkgHApOjX9yZflVN6L6bMNc/WhTTRoyLRuAspRXGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Move the folio_set_active() for refaulted workingset folios from
> folio_add_lru() into lru_gen_refault(), where the refault detection
> already happens.  No functional change: the ordering and logic are
> preserved in all cases, and no other paths reach the removed branch.

It doesn't explain or even mention why it doesn't matter to
discarding these two checkings.

!folio_test_unevictable(folio)
!(current->flags & PF_MEMALLOC)
> 
> This is a preparatory cleanup for MGLRU-FG.
> ---
>  mm/folio.c      | 6 +-----
>  mm/workingset.c | 9 ++++-----
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index f90b7f86dbe3..fab00cb02970 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -474,17 +474,13 @@ void folio_add_lru(struct folio *folio)
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  
>  	/*
> -	 * For refaulted workingset folios, set PG_active so they
> -	 * can be added to active generations.
>  	 * For prefaulted file folios, folio_mark_accessed() sets
>  	 * PG_referenced so lru_gen_folio_seq() places them into
>  	 * the second oldest generation.
>  	 */
>  	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>  	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -		if (folio_test_workingset(folio))
> -			folio_set_active(folio);
> -		else if (!folio_test_referenced(folio))
> +		if (!folio_test_referenced(folio) && !folio_test_workingset(folio))
>  			folio_mark_accessed(folio);
>  	}
>  
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 7ac2b88c80ae..5438e9390011 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -320,12 +320,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
>  	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>  
>  	if (workingset) {
> -		/*
> -		 * see folio_add_lru(), where folio_set_active() is
> -		 * called for workingset folios
> -		 */
> -		if (lru_gen_in_fault())
> +		/* Send refaulted workingset folios to active generations. */
> +		if (lru_gen_in_fault()) {
> +			folio_set_active(folio);
>  			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
> +		}
>  		folio_set_workingset(folio);
>  		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
>  	} else
> 
> -- 
> 2.55.0
> 
> 

