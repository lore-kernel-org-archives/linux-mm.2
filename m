Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2881E109B491
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AF76B008C; Tue, 31 Mar 2026 11:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6628A6B0095; Tue, 31 Mar 2026 11:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578B66B0096; Tue, 31 Mar 2026 11:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45D766B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:32:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14EEF1B722B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:32:46 +0000 (UTC)
X-FDA: 84606750732.17.FD1C791
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F25940011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:32:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sKZGMqC/";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774971164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+C4y+Sd7HEYKiCpd074wxzMXELc1k81DcNxRvKzgNU=;
	b=3xAAAMBcMfs6/JMfAQC11YVJpAcveEHH/pF6t5xM9qLchW6uLC76abXqc8IE77aCV3MLo0
	yHy3gOdhM8Ll/ftmPsZxSaBk6p++aaHpAAzzrW+zCZgvmi+ASQld1WLWZpHyRHrji5/fQm
	UzGdP+q0Gsu+A2SxWPf1GR031WQNP1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774971164; a=rsa-sha256;
	cv=none;
	b=Mp3yLa2y45Qhz0I4kO99OXMtLVvjAnBQY1h0J1FtHL+G1Etf6/D5YTsQZ+rrjxWAmUsOCr
	aPrvmeUkm1s8NMF4Gom6p4cR+gm+NI8JESS9kNdguGO/6qEUG1HDcd9ks1Yhdopv+pOvd5
	9/Z1xSFYN2rgBlSiwsSTwyKCfFOmyec=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sKZGMqC/";
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 31 Mar 2026 08:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774971158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t+C4y+Sd7HEYKiCpd074wxzMXELc1k81DcNxRvKzgNU=;
	b=sKZGMqC/Uvyj61yMCKaL651i5TTogdGlkkt7N3+McpC8oWHRAfvawOHR9ZUzGkxR1tcS4b
	zPGenokao5vS5odsctcupTepRR8NMQrqSRcQdL7U7DQrRjHC/g3fLxaJ5qk0MrOConMCNF
	/HnxTf+ZV1Z2k7OhTO/DDr7ARMYddRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-stable v3] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-ID: <acvnjCr26zpQUW0h@linux.dev>
References: <20260331091707.226786-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331091707.226786-1-hui.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: bdoiqi554q8j9poconf774utryazxbx6
X-Rspamd-Queue-Id: 7F25940011
X-Rspam-User: 
X-HE-Tag: 1774971162-399650
X-HE-Meta: U2FsdGVkX19iiyAWmRycTA6LUQq7pIXRmE+IBVgX0I/Ws4hkZz9ZcXQA9qRKzL8kZhw6YYe78RM5qYXzofXEHkD87U6v4/SnjMZCU6I0lGXB/5BvwMcWh0mkPm0FIfV1piUjFaJqf6PDShBFjnhcI3nPk3G5qqnIPB76fuW/1F5NL2vzOb5fd55EKSnrCjyAwl3ZmomBvgM5RrgL9kTjxoXbtOSHAM3B8JYdTMXNJU/FzhsRjZKL3Y6c5cgzCOOpedsl6mCSW5ZAG3BqncQmHHaQhTRrwKn2vQBNiEmBKoC//5u2ixiiHY6bOievagrirbaJ2KdAOKbeTQk/B2NoaYVsw5CSULDnniS4LFO5Xcjrs8jk8+tkcDMBQIl53zv+LbhLLvAzUIupHHjqPaspB/GTpqLv0V/yblCuNkUOXZ4SeAJeOaiaUB2ZZrgoI17/Q17fezlUjlgHiWl3rfe1UTKIisuZAgXxkFumLFg+Ewbvq47TYIWHfM/WShy7+c6TIAsBgBKFgkkK5jritQ73CX4iJanmuj9+tDP77NUhhbUavkGnUZ3QM59nExpAzr1wooOVAxyEbQAG05O2Ymtmt85u0h1msU8V8nkxuu8B31hs2nTxbCzML4NdOmidApjr2P7ESU9g9lK1xentRmAIU+vfWVthXUR1zIrKcb7u2hVJDVpFrP7+lTCkZsk0GO+vBS4VOmMoH7eiY6Wwe4JuljqYVoW1Ptv5mFO+FL/cs094v5AI1L7cSmYO+pgxOL0HKa4CiboWdlD0XXau+J2qNVIkvcZp1TItiCp+VyzX6YjvaArjRoLCajxyoE1ynab7H6bjJ4i1G8hyhVDqTAQ0pUkquEm4DpNiYye9BuC/BjlwAmW8fbEj+9+JwN4s8h05hp8irsWMG8bJ133jwwywFtRj5JP3i8gR9AmEj9iJBIejKqOtpVgep9l9D7EuvbOlnVedx8jHETJv10GUsw+
 PMUgwhPj
 q9LAeQhqFgs3LlZUzHTf39wdtrnsdpgMnuDhMcyuZzJoJI/ZtEGY/4x9lEdI3QQVHDGUMEdJinhn3/NXeyEVGMR1lq9+6xfscQszcLjEjVn6EoVSKansdbt0WukNooMoLGvBSkAzOkp1E8EZVhUl5c+Qxf6KVjGl6lqtb35OG3P4j11X+qdozeHgT7qTY/A8Xi9PElXs6dWNGhLSwOQ1BDKC1PFAJxpESDLX+7Gm854RioIprUak/pPwdPm0cDeHmg3xI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:17:07PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> at a time, even though consecutive objects may reside on slabs backed by
> the same pgdat node.
> 
> Batch the memcg charging by scanning ahead from the current position to
> find a contiguous run of objects whose slabs share the same pgdat, then
> issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> the entire run. The per-object obj_ext assignment loop is preserved as-is
> since it cannot be further collapsed.
> 
> This implements the TODO comment left in commit bc730030f956 ("memcg:
> combine slab obj stock charging and accounting").
> 
> The existing error-recovery contract is unchanged: if size == 1 then
> memcg_alloc_abort_single() will free the sole object, and for larger
> bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> were already charged before the failure.
> 
> Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> (iters=100000):
> 
>   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
>   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> 
> No measurable regression for bulk=1, as expected.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Do we have an actual user of kmem_cache_alloc_bulk(GFP_ACCOUNT) in kernel? If
yes, can you please benchmark that usage? Otherwise can we please wait for an
actual user before adding more complexity? Or you can look for opportunities
for kmem_cache_alloc_bulk(GFP_ACCOUNT) users and add the optimization along with
the user.

Have you looked at the bulk free side? I think we already have rcu freeing in
bulk as a user. Did you find any opportunities in optimizing the
__memcg_slab_free_hook() from bulk free?


