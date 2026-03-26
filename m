Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F752106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADF26B008C; Thu, 26 Mar 2026 05:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C854C6B0092; Thu, 26 Mar 2026 05:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2646B0093; Thu, 26 Mar 2026 05:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A978D6B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:19:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45C748CDE3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:19:40 +0000 (UTC)
X-FDA: 84587666520.13.A27096F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC2C440006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:19:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER9HF96A;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER9HF96A;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516778; a=rsa-sha256;
	cv=none;
	b=sUe1Ojh1+efqYmtPgza1M2eq8/pEw2FO8+p+G8aFhWuGhZg/m+m9FZa3fKl7mzqOdDNFHc
	c5ObSCk0o15rAXTgcRXL3H7SlkbwGGbXdCQqLs6YokbjxWdo/gcQT2QD+3uQtzNSIB4fGs
	ItRbbXgvUMx3XTK/opkbJdi7KmvFpqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fykiYZDC7iPWvpjWf1+IyUJ12dbaUPthEbc/16Rt8Kk=;
	b=zG+4OKe8GpeaXBnrEgQFswP4iAqY33foGRnbz4C8n6mnGDrY5oxbnkbzhVUMdxNpFpHUpV
	H6BnKgUSOfFYFOjjGs/f6Fj91wGF/Ob+cKor1AjIfQ7McEpkdghE2GdrLMMcJltAPhPXHm
	xjB9erc5oAPebhqYBpe+taF3+SrF/Pk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C02460103;
	Thu, 26 Mar 2026 09:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A0DC116C6;
	Thu, 26 Mar 2026 09:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516777;
	bh=yfs11smsIZq3UwfvmiNxz7T6cNBk0gtg0FCG2iKFu4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ER9HF96A7VDTgHU9B+tGpO8h4S1ABwBaTxloVPzHLeGQJ/97Himkw8Z0QSeeUYYIr
	 b959i81Toxc4fqIr8ACodW/C6xCuCNFCFSmp9QIYjimotcGXPd5cTEOrxuw3x6lYg6
	 jrOI5lfaeogvKpBkBkJnN5LXVECayqpvlJW+9Fr9C4RYdgnibXa/w5K8KTae0uH0oL
	 ++L5ZW1R9+6HKZG3NngBNUvyi+FyaadzguHcOXsv7j9JzVD6dc9vck3QEhVII/2PlI
	 XQyaIP1K779uAZJ9d93nbcuc29km6b5FYirS55NKIGnAR4gi4oODZAFCBkNfxVojCX
	 Ws0UpvJGyXXgQ==
Date: Thu, 26 Mar 2026 09:19:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 2/4] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
Message-ID: <ac9c3d78-6244-424f-82b0-d5501145484c@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <5c42058df0e52a4698da005e502deb2fae7bf819.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c42058df0e52a4698da005e502deb2fae7bf819.1774447069.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC2C440006
X-Stat-Signature: yasepjn78mfbcuykuyk74aa6w63wj585
X-Rspam-User: 
X-HE-Tag: 1774516778-505608
X-HE-Meta: U2FsdGVkX1+3Vb95eD3Fi2c9oE91B624DYlMq+uZ/Mwye0iKkAh7+yfVtVUfy2nOjhNzwxMfhQmZsRFJ0Zsd4AF51nK4gP04t4M7LXWsfVJk8N+1rlSeXLMtjXp3Ftv+pE9oF0medbAj1Wp3Pas6WhGFZTQjD4KgD3YcFgMMC0rZdYizPVwpB/FerYSwmqmz15U3QgVtCqTP0K9SNtXs7lE4bqi1Gxt8Hdih0LJoY4ZhuZXWs+QgU3+EGUqlNVrixu/epax4EpPoxMi+3fPXTE1JE7+W9XGoto78aiGf8VY9pVQ2xh+/Nu53/hI08M7mX7RB/nrxmWvzmDqkOlMWyV2UEf6OJ9T7Bnn8NgnyIn4BOleSBVyiMOY4igH/Yy6GolbWhszbJ+MErLpW8scpTMT/PMXRcKPZuPKeWpiCNucxGa9HPiHBWKussNK+RLEnYfUCgnMffz7rtWSfjQ6nMMmdC/kZr9aQU8+Z6Cgb0iVIqW/15xOj0Qg79GOvyu6iwabWWoF2j6ryEdwnkdABm4SgftVHNg2btt7h2hSH8NYgxrEaLTUlAw5WYaKX4m2xAyYn/HvVXMarRMGVgsn/yrd+XLj5NI0Zf4Zo8XnlcM8+9SXTYTNFKsP/dCZzBmJWvA7RsM2aNo+Xqp5mC/S8Xtn7eU4Gvl67owpNDpmG853sJesAc3j4ealXVblapATQ/69LTevOJL4LsVnbwIJI54KQEDrh6dMl0b9+oF8k8RrZjmUrG4e7pjaEmhNZd1+j5YOrQESNZ0TJ7DkwUUb5GShKm39SRtSk3pGHPgb1MXYQPuXAn26xfD+5p0MNF/WxOEfVhfqNvnatiWoAUytFO3Cayt+1iLo7Rl0TWmd6DXorvlWdVHpqA5BGjHnj8SMi11TjCJSfqs8pTQnqpqSILzZWiSFmIFz5UzsSU5sRO/CwAlCLKC50KQoO3aLRPMnjnw0348w+Ma5AANjJIrP
 0g0NdkHR
 CBvx/SB5CeASInFGOk1dLugeigTQxj2b+fQRD0b2o8RT6vyVuXSLui9tmMQ7xdA6wRqos/tm5PyBu3kbQpfXTHBVvRT7gfSdc/F1cdxsBYPOwIvMPQGK13MrYY64/gzIeWotE+1uQ2r7hUT8myeVofsWG+XiMxifwHdC1nEFJ7KelVUWxj/PQy0s19e0HSsjGbDHyGJ48hMyufi3YcVvtYHR80r8Pdl8S/a3dkkfyrUjR2f+pGi2mnUda0G3gNqTXCKcvwyrWTff0kHZ2/OsrGU0SnOL1VvLVosI5g+OdgDOBlsd87RLZzeVnhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:13:23PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
> used to reparent non-hierarchical stats. In this scenario, the values
> passed to them are accumulated statistics that might be extremely large
> and exceed the upper limit of a 32-bit integer.
>
> Change the val parameter type from int to long in these functions and
> their corresponding tracepoints (memcg_rstat_stats) to prevent potential
> overflow issues.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/trace/events/memcg.h | 10 +++++-----
>  mm/memcontrol.c              |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/trace/events/memcg.h b/include/trace/events/memcg.h
> index dfe2f51019b4c..51b62c5931fc2 100644
> --- a/include/trace/events/memcg.h
> +++ b/include/trace/events/memcg.h
> @@ -11,14 +11,14 @@
>
>  DECLARE_EVENT_CLASS(memcg_rstat_stats,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val),
>
>  	TP_STRUCT__entry(
>  		__field(u64, id)
>  		__field(int, item)
> -		__field(int, val)
> +		__field(long, val)
>  	),
>
>  	TP_fast_assign(
> @@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
>  		__entry->val = val;
>  	),
>
> -	TP_printk("memcg_id=%llu item=%d val=%d",
> +	TP_printk("memcg_id=%llu item=%d val=%ld",
>  		  __entry->id, __entry->item, __entry->val)
>  );
>
>  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val)
>  );
>
>  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val)
>  );
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7fb9cbc10dfbb..4a78550f6174e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>
>  #ifdef CONFIG_MEMCG_V1
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val);
> +				     enum node_stat_item idx, long val);
>
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  				       struct mem_cgroup *parent, int idx)
> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>   * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>   * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>   */
> -static int memcg_state_val_in_pages(int idx, int val)
> +static long memcg_state_val_in_pages(int idx, long val)
>  {
>  	int unit = memcg_page_state_unit(idx);
>
> @@ -831,7 +831,7 @@ static inline void get_non_dying_memcg_end(void)
>  #endif
>
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
> -			      enum memcg_stat_item idx, int val)
> +			      enum memcg_stat_item idx, long val)
>  {
>  	int i = memcg_stats_index(idx);
>  	int cpu;
> @@ -896,7 +896,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>  #endif
>
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val)
> +				     enum node_stat_item idx, long val)
>  {
>  	struct mem_cgroup *memcg = pn->memcg;
>  	int i = memcg_stats_index(idx);
> --
> 2.20.1
>

