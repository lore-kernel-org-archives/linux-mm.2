Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DF0C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B016B0088; Thu,  3 Sep 2026 13:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC2D6B008A; Thu,  3 Sep 2026 13:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801D36B008C; Thu,  3 Sep 2026 13:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61F7B6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:51:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D7F81605B6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:51:24 +0000 (UTC)
X-FDA: 85173192888.19.F41707F
Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	by imf11.hostedemail.com (Postfix) with ESMTP id 226AC4000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:51:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hfl5XIDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788457882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EV+11ON4I9XQkQhNAZop8t2Jq5AeV+epPjqJbwxTt0=;
	b=fTHcqC7cJZlmIFoYdWg4Lt+sAldDVGKm1knR8EVhC7uYtp+rA6tdH+sOKsYuxWiW3kHpQ6
	GFiuQEVfwdbqlItn3XeCUvM5mZ2KikQ9jlcP1X6UQKBSbVkxotQsuczJWoPsy05T6/bFSN
	A3Ar9V3nOLhQbpOhEc9iXqmzuLJqZ7o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hfl5XIDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788457882;
	b=KwWMGq9j6EtZTC8o8AcqpsshvdDihYg8C4jFwIzveIC1opYhMZnk/WYC6FV4CJpZIngjwz
	oB+PCop7ILZeo3gK1QwEcGweMFG/fFoYIIoHga4dp96B+OmBLam3890N+rPwdiv0JOD8Il
	+NsOplui6RmZ2CJl9DuyJizHi/VYFYw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q76IA5wKfZVmQPtYRc+wwddVBWZgCaJsAP54HPFaqac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788457880; v=1; x=1789062680;
 b=hfl5XIDnO9tqeCkLXliayjUADfQtrvWt+83kmm0nyf4e00RNGgf3K32YLqyoQogjzXAFFQu+
 JHwRmJcCD6Pf+TgWFgtbVtsQZBGSS0iD3j9Ksec+5FfESEe8cJWY7i8u13ap22RXw3QDbH+etlW
 pZPM/5v2krwPlJ1G4VB56bpE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c3d49bd8c8bbf0fa;
	Thu, 03 Sep 2026 17:51:20 +0000
X-Mizu-Trace-ID: c3d49bd8c8bbf0fa
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:51:18 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-ID: <apmzXFZfMGas9RWe@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
X-Stat-Signature: kc4mz7sejkjx5hztxmkqcc7upmoqihf5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 226AC4000A
X-Rspam-User: 
X-HE-Tag: 1788457881-87240
X-HE-Meta: U2FsdGVkX1/BntGeAd5OXuZTdXh1jkslZtvgMG/hAaClxGRRpmDbV0bJr7M9DwZuE1j1ZYqoRPmS0poW9gF0bT+IR+eW0T8IcWQEvvWd6vB8LpFKJmHZzPtDQsNBR9QvQx9TWWaI6GU2RmBciBbyuFvchTfgKYiJ4fl2wkVusiqJCZE3LFqzSZg569E6uJa9J1AFB4rmOE3Q5fvetUupM6A77yXBsh1DDESDx86IkN0+W/oKcQSSxXCCekpJZiuIFnqX0XVu7v3d5MFxielpnA/4cpONEKrzmlDS219UnDWpIwlA2rbpk8QunUMsrFZM+8SxNadfIm+elglBDuOstnv0LaIjUfdrVuE1wxRmE1S9uAwlsQsq351rwBVJfiC7V4D3bfksFGtcS+ceWekHQzcSM1jlO+GdJqAfm9J/0lUbkXQe2t+BNmTmSt97EBaNIqXofNmPYmaaP4Ph3xld68yPnpR0c8X/0CUZjXvNkn5MMHWIV0ci55xWpseSbZxbpg7xvbt3JPh1rXz7KJBfGjnCt6lPQv5AGVQ9lCMidiNUX1rFwhKjk/ASrl2tgfiDm+JlEiSV01FP8XjKODZC8OtgUahZ1Pdpp69UuR7tS4/29WfHxuy4LzwLBsVsvNhjNqDM1EjwbV4OhMHBlA1ywoNdxglkQ1FyFtij5GmSrgKf55YAS6miEC7Gr9Iu9LDXr1ejQ2shWVxaF7LzKwd/oMvL8tJUH5M0LHMuDrKEIWouMN8D5U2gbbqHbtn3z2ue3AbY1E28qNCP00TKi9VqFNK75q/N8yxmxQEH726ovFfHlOnABxUFMjnw+X/DG3znOFuUEtbdc12+VaH6qjWMcvOG/+KaRo503gm+5AuMldc/3+Z+GmueYGPwVIGI07LiuGhTPbbOsfgo49DSAFKrT3vsamCemfqVyJgJLouWUPIcdz5cNEuBvbz+T9lEXTMM8gi7l5aw4CL0ehmWfhy
 3IpklWvS
 6L3PWtY9mLsaEUcKqD5J8xWO8gM0Ovh0wKkXEmC/TYRzkw4J186ghSez3/MlTfgWFf+LmZFHMlQ620RGyvp24VIAQgBSOyQrFO38HLTbhhXgg+5cAIkBeqPIJABm+S8d3xrTy8OHCXL+QYqYs2PufJCjJTBqTBFUzOiY9swYIHqj0Ec3XOQ/e2FjMKAZMXz4qjpe+DSkVvGRksbiTti0hk4tE6sYbJ/SMJ2muQMmg11p9+gKJvdc/xJfnmxKuRNYh3a+gpToQ8Owg+bQx7l6FMnF9dxUHunbUpBcMkM/mMJtqvWeZe1sNNVHdH9YygzEYOUrjQY+DqL+yaBsV3/tKzS1m8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:09PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.
> 
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Make this patch at the end (or after 2nd) of the series as it is only correct
after the 2nd patch of the series.

> ---
>  mm/workingset.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index f351798e723a..85a4e14e95d5 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -693,10 +693,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
>  
>  		mem_cgroup_flush_stats_ratelimited(sc->memcg);
>  		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
> -
>  		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
> -			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
> -
> +			pages += lruvec_page_state_local(lruvec,
> +							 NR_LRU_BASE + i);
>  		pages += lruvec_page_state_local(
>  			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
>  		pages += lruvec_page_state_local(
> -- 
> 2.53.0
> 

