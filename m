Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB960E6B244
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 21:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35176B0005; Mon, 22 Dec 2025 16:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8B36B0089; Mon, 22 Dec 2025 16:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA596B008A; Mon, 22 Dec 2025 16:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B79E26B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:36:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63835B8B85
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:36:32 +0000 (UTC)
X-FDA: 84248416224.09.65E3806
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D860140012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:36:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Px0g27Rf;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766439391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsefXJ4KipxZIgZ3+WStAOI/ItAHnWqRJxteZDI57M0=;
	b=JWtIYabZXSQWLq78aS3fbRn44F8wQJrXaoIYm3R5/ggmNjvu37I5rKr95uJ/kpRgLaOns/
	ryU7wqjYimZM5ohEh+TrxfKk3aDW9KHlbMwFtvRGAHwT0ahN1HpQ3nn8FmNt0tIgBPrDle
	9btkZwViAg0a2WVoE0plccS+1MIXfHI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Px0g27Rf;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766439391; a=rsa-sha256;
	cv=none;
	b=Qcr58PbWgCirkvIC3QCm+IJAYsjR7EGDNkzZphYK43HCT5h9V1zRi0tWc0ie1co2FIrZFo
	zPff5bXkFAx1y6OQBtN5dXq5U2e4/lqvcw12SMLb20eabRyz72VFzQ4H1S1g3GKqpGuAe5
	UYjYJR8dW2Dw+51nONoTmWuVtNO36nw=
Date: Mon, 22 Dec 2025 13:36:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766439388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VsefXJ4KipxZIgZ3+WStAOI/ItAHnWqRJxteZDI57M0=;
	b=Px0g27RfwypVGEVCIEA1bR0D/IOF2AnMmpDn/uIpKPCykX7WcCtn6xTDaXRtOx9EFjCynI
	9KAKYXv3FnayRNLzGouHCzY7D9LPHwApDAaGG2pcbKfyhm5KYAXROXEpqNFQcuYkJ696Hs
	PsabLK+H4u0y3qIsCFs2VTbOv/tapd4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen
 and non-lrugen
Message-ID: <7kwk3bkvhvflsyxgljnxzvrxco2u2rxjcdwqooeboyrkf2oxjj@2nywxl2sc6g5>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
 <20251215211357.GF905277@cmpxchg.org>
 <6c69c4d9-f154-4ad3-93c8-907fa4f98b27@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c69c4d9-f154-4ad3-93c8-907fa4f98b27@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D860140012
X-Stat-Signature: efhp9fgt53ienzjq6jcqo7osbt1xm5u7
X-HE-Tag: 1766439390-688105
X-HE-Meta: U2FsdGVkX19ZVOMIcVoq4STrxXjpbAsH5ENHlfcS6sLBGAEtJo60WXT6lXqT4ZJKlyT93iz8g7ap9nLl1ZDP9IiOBobtMbz36uhajVR9RriXE93hgSkL19DEtv+VWWQAS7l4dtrCJvfzLOjXt7w4cJw+pwWkIAop2/cgCb+EDP/SLXImX3fTavQEefwE7yIgKkcDjPvOzZa8mINKA1l27dujob0dxWn7ncLN2jbQsIThctJ13iYT9J3P1uSB7YufVL1Zkv6fPs+c8PyT1SYfTQeTiJ2PASXKpRSiTo4lSs13fFaax0rHwWGlO1IhLlGapHP+sXCXKpi5GD/GhcSFW9B/k+KxV3OoLHPLHc8aJt4KRr/Nvj1chBNdWtQ3qMr9Asfw8rCtHPG36qtKfcyo8nAejRqWMSgDCArbF6tPGkx7rTXHWoRw2jknBAEY9FCWhNp2ianklXETxupky7Wzpdo7bBOcQYxbY5Y0Ote1yDkVLggk0xqBXMIMs05LLq1vfKaCiBVEQQWA6VLZl8s5b/Cb4DkYkbPohaFVP9TmaJ1ZqmC/HGtyI42+OCxN4OsrOeHhr3PPKNLPiGz1CFmmWIdOzIKvLeoCr4eQKOW/Jm/+SM7H7cyo3LTrsCMcyAZAG9OgXi3s7nqPApTMLBobk29zslVlAMHgWLN7s7DLP+TAH+UBapeRow3AX+oD5pZpLJW2UafAs3lPAXlLVZ4UqNsViu6gw4QQHedU9JgMXZQuIcDwUBK4bOrw5Sm3xzy3WNS1ESgSbneW4vWZqIp7gYwMpH/R5VaP3vYEC3o4jTPoFd6BgcF9HTOcCj6JGiDxUYE2/AM70Cd4fNoBXt+5SFVVN5zqRLLDlA9rtqcNWvtqFDn/6ohQx60Qk38RcFVxBof3lHGp/njN2IznqnXEEPUPiNF2ecny
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 09:14:45AM +0800, Chen Ridong wrote:
> 
> 
> On 2025/12/16 5:13, Johannes Weiner wrote:
> > On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
> >> From: Chen Ridong <chenridong@huawei.com>
> >>
> >> Currently, flush_reclaim_state is placed differently between
> >> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
> >> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
> >> only after all lruvecs have been shrunk.
> >>
> >> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
> >> after each lruvec. This unifies the behavior and is reasonable because:
> >>
> >> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
> >>    sc->nr_reclaimed.
> >> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
> >>    when nr_to_reclaim is reached.
> >> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
> >>    does nothing in that case.
> >>
> >> After moving flush_reclaim_state into shrink_node_memcgs, shrink_one can be
> >> extended to support both lrugen and non-lrugen paths. It will call
> >> try_to_shrink_lruvec for lrugen root reclaim and shrink_lruvec otherwise.
> >>
> >> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> >> ---
> >>  mm/vmscan.c | 57 +++++++++++++++++++++--------------------------------
> >>  1 file changed, 23 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 584f41eb4c14..795f5ebd9341 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -4758,23 +4758,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >>  	return nr_to_scan < 0;
> >>  }
> >>  
> >> -static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> >> -{
> >> -	unsigned long scanned = sc->nr_scanned;
> >> -	unsigned long reclaimed = sc->nr_reclaimed;
> >> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> >> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >> -
> >> -	try_to_shrink_lruvec(lruvec, sc);
> >> -
> >> -	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
> >> -
> >> -	if (!sc->proactive)
> >> -		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
> >> -			   sc->nr_reclaimed - reclaimed);
> >> -
> >> -	flush_reclaim_state(sc);
> >> -}
> >> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
> >>  
> >>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
> >>  {
> >> @@ -5760,6 +5744,27 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
> >>  	return inactive_lru_pages > pages_for_compaction;
> >>  }
> >>  
> >> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> >> +{
> >> +	unsigned long scanned = sc->nr_scanned;
> >> +	unsigned long reclaimed = sc->nr_reclaimed;
> >> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> >> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >> +
> >> +	if (lru_gen_enabled() && root_reclaim(sc))
> >> +		try_to_shrink_lruvec(lruvec, sc);
> >> +	else
> >> +		shrink_lruvec(lruvec, sc);
> > 
> 
> Hi Johannes, thank you for your reply.
> 
> > Yikes. So we end up with:
> > 
> > shrink_node_memcgs()
> >   shrink_one()
> >     if lru_gen_enabled && root_reclaim(sc)
> >       try_to_shrink_lruvec(lruvec, sc)
> >     else
> >       shrink_lruvec()
> >         if lru_gen_enabled && !root_reclaim(sc)
> >           lru_gen_shrink_lruvec(lruvec, sc)
> >             try_to_shrink_lruvec()
> > 
> > I think it's doing too much at once. Can you get it into the following
> > shape:
> > 
> 
> You're absolutely right. This refactoring is indeed what patch 5/5 implements.
> 
> With patch 5/5 applied, the flow becomes:
> 
> shrink_node_memcgs()
>     shrink_one()
>         if lru_gen_enabled
> 	    lru_gen_shrink_lruvec  --> symmetric with else shrink_lruvec()
> 		if (root_reclaim(sc))  --> handle root reclaim.
> 		    try_to_shrink_lruvec()
> 		else
> 		    ...
> 		    try_to_shrink_lruvec()
> 	else
> 	    shrink_lruvec()
> 
> This matches the structure you described.
> 
> One note: shrink_one() is also called from lru_gen_shrink_node() when memcg is disabled, so I
> believe it makes sense to keep this helper.

I think we don't need shrink_one as it can be inlined to its callers and
also shrink_node_memcgs() already handles mem_cgroup_disabled() case, so
lru_gen_shrink_node() should not need shrink_one for such case.

> 
> > shrink_node_memcgs()
> >   for each memcg:
> >     if lru_gen_enabled:
> >       lru_gen_shrink_lruvec()
> >     else
> >       shrink_lruvec()
> > 

I actually like what Johannes has requested above but if that is not
possible without changing some behavior then let's aim to do as much as
possible in this series while keeping the same behavior. In a followup
we can try to combine the behavior part.

> 
> Regarding the patch split, I currently kept patch 3/5 and 5/5 separate to make the changes clearer
> in each step. Would you prefer that I merge patch 3/5 with patch 5/5, so the full refactoring
> appears in one patch?
> 
> Looking forward to your guidance.


