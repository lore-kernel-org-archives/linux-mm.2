Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76DBFF8DFCB
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 21:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27746B0088; Thu, 16 Apr 2026 17:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D91A6B0089; Thu, 16 Apr 2026 17:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE656B008A; Thu, 16 Apr 2026 17:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5A16B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:58:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0786EC30E5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:58:49 +0000 (UTC)
X-FDA: 84665784378.22.F890D9F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2341D4000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:58:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOHknOXa;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776376727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfB7yq7FlvDsj7E7RUcfKGzlsn3Xjn7/O/KFA2Tgztw=;
	b=LWl5KhhEzP8YYxK3KEZSgimQg4aczK3OGerGWGQyCupjButzpDVak1icGTvVxhSqxHYcOl
	w3nhZEG9sS617eO6cCj3STfTGGxpQigjV1ra1AF3g1rEIu8UKOL9riGCqwbUUUvqr/Ddum
	S4p85a4dibnAJCSkRu2BD0ovCnEXqgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776376727; a=rsa-sha256;
	cv=none;
	b=TsEcfmDZXcyBa59CDh/jaTXD36EtSapCNdnLaWiFBAof3W/TYFeqwstyk1pbpWrU24cfgy
	Y/2gAUZ/vP8osnJ8/Yp/SQBGQnv57lpYHAszXwOfE1//vnIqePbjPeBi0UAkY/zPAgwguL
	UVHlLIye+SxzgepxqLIgl3NWzM+NR+0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOHknOXa;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 16 Apr 2026 14:58:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776376721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nfB7yq7FlvDsj7E7RUcfKGzlsn3Xjn7/O/KFA2Tgztw=;
	b=MOHknOXa1MVcRU46Icm27zBTaxGkHx2XgdKJ200CHpwza9iBh9YShQYCrjYlPykeix+6xC
	s9wuzFyfm5Vn6mK0DqJYEc550qXEZgd59qciSvM685E5DGtcOkjDusLRio9Pdq/kGP7cVO
	UVkWNz2IdfRjJQauhJirQFs9Ono8vDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aeFa7uIML6NmS6T0@linux.dev>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <CAGsJ_4x96rrt+T5efMEPR1YmhTY_Ce2S4mZwN3sqB3Hx01=URA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x96rrt+T5efMEPR1YmhTY_Ce2S4mZwN3sqB3Hx01=URA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ktkirbenu99fqxmxaezkfip7wtchj36h
X-Rspam-User: 
X-Rspamd-Queue-Id: 2341D4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1776376726-863013
X-HE-Meta: U2FsdGVkX1/zTZIBsmXlE7qw1u8In2iyGumHKOZmJ3d6gKocYs5gJPhNhYuvlzw1pXTLJFTZPpXUx3W09lgFPAulybRKiOnozZObzWTJXmDlMNsqzdEdp8enxMxBPOPyrYZ0+ryzhNKuknyi6L8C6Ecwh1IdaqnEIcjUMOHNUXjLCqdDst+AaYnvxRFh1v2JIvzM7oZ3BUDu/1rP4iUzY/TLE7b26S0vo4gIrPUGawCUr6Qm+QflDxbQxaUiIxlROg0o1BHKZEQwThzkL8NfsqroNKXgiI5tEjQF6HpVKW6IGAfCVlr/12Zr9qrWyQiw8lvAzUROsCnrAOYQ+o5ErB1qir9B8CfULxdxj9LOOecyMh0UYxRlHg5RR5sK2H5NRf3VYhAXUeh8Gc6rToaIOhIF82ErY/OSVTmnEaeP52ba/1HX+6FqMeD4LLcEVjyHL2hM1RwQ38Ip4nZWPfnnNRWKgWB2+ncffHBP4PbuC79i23varfyZUtt5aoQ99v3OvATvWxMRchk6Z7tmSSKc7X+LAVrS3FEzq/A2Qw4HfxCdAQgAcVG8MZq6Esm3spNx7ofq71pQyzHodj0qicNbUPCIDSY7nPDMN4n3lFcxvnRrXMizNMvUs0vd6QVxHb7FzLMnqS0wPzY+t8+9HpaubJ/xawalxR9q4sZTapwu/Q2HjQhOARgIc2dmVPAW6GqeSmGTwNO7B1hWK1n4AN2wgXwT7apx6ZeH8uA9SLI2mBv0wiS2cZelgebJPhHi3cC3Exps2WOXMckvEBy4G7+RVP1jq8G6LYlQBdBjiF8hSzHNck2vLTg0yGNIwNlRRLfXaV5xrUwRAgBK6R5AVayP1lVKeTxOs15BbqS3X9bVMcPHfKOYND13/r8GQkyRdHEe1FoHhzXOQmKjrco87/SFli0mlxGV6YGSXLWRW20GbTRkYbRo8QvVueQ8/8D5vuH7tuEZ3zFt7k+BEtSm9fR
 tPYFztGg
 HLhaipM3wUUISyhl3Ug9TITH7FrM1Q7S9MuALreBybq6OQpiAfuc4O2CSq2QwDvJkmZXJhHVdCQM1vyt2GFZbHaKIgFBR/VHICWjyKdGwP/HoLv8VLmhYsmtLgRrlRPFfRU/laRoG/Gl2RdUi/JLdp86jYMXKVeruv/VCG+Ipi/2+SM48c3uItkqfxq2UFhwKCQ099CiPL+CKTmktv7c3zzdw8riNHaxkDPtUghoSGEOHmnV4p6O5i3FAE9TXGDhWf0y9eeKIn/Nng+7XFmEyKxaiEmUiSAuyqBvH0BDJUZV+8Kp/DklM1y+9THED1qYTDQQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 09:44:55AM +0800, Barry Song wrote:
> On Fri, Apr 10, 2026 at 6:16 PM Matt Fleming <matt@readmodwrite.com> wrote:
> >
> > From: Matt Fleming <mfleming@cloudflare.com>
> >
> > should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> > retrying reclaim could eventually satisfy an allocation. It's possible
> > for reclaim to make minimal or no progress on an LRU type despite having
> > ample reclaimable pages, e.g. anonymous pages when the only swap is
> > RAM-backed (zram). This can cause the reclaim path to loop indefinitely.
> 
> I am still struggling to understand when zram-backed
> reclamation cannot make progress. Is it because zram is
> full, or because folio_alloc_swap() fails?
> 
> Or does zs_malloc() fail, causing pageout() to fail?
> Even incompressible pages are still written as
> ZRAM_HUGE pages and reclaimed successfully.

We should have counters for these, right?

> 
> >
> > Track LRU reclaim progress (anon vs file) through a new struct
> > reclaim_progress passed out of try_to_free_pages(), and only count a
> > type's reclaimable pages if at least reclaim_progress_pct% was actually
> > reclaimed in the last cycle.
> 
> I would rather detect what causes the lack of progress
> and implement a better fallback.

This is a good question. I think we have appropriate counters in /proc/vmstat
for cases where pages keep getting recycled in the LRUs instead of reclaim.

Matt, do you see anything unexpected in /proc/vmstat?


