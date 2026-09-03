Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5928CC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768526B008A; Thu,  3 Sep 2026 13:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F576B008C; Thu,  3 Sep 2026 13:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EFE6B0092; Thu,  3 Sep 2026 13:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4997F6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:52:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D5C4805B9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:52:08 +0000 (UTC)
X-FDA: 85173194736.28.48D61DF
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf04.hostedemail.com (Postfix) with ESMTP id 442F840004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:52:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JrPiCao8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788457926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgsYXpp/14AvPQJoFel/vanPQI3FcmO89yshrY6lOBQ=;
	b=Dfl9luV/FEsLvuVqU1UG13UASIIO/cSnd39wVIIEsIHFoYr4KGVosEtcXBIrctpbP4FtYF
	fso3KuCthDP5rF6u3bjDPXsfFq8aEhwcRP4CBxVqv5tlFmVq+K77e98Jt3L2EQ0vKl6E2t
	6e6e2o1LS+xVmuRLc2mKR97Fuq7Ovlw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JrPiCao8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788457926;
	b=wqkRTWkNSYeqfS5UNZOONjGcHZWNqYrgC6+QeLy7nmuML5OZh8i8CFgdSH/tLf06Ky5laG
	klsOThkehyHqK8cQBqVDud2tcVRovOdmzSawc4ejsQYcSqWv0/En2enscPSvvEPrHxd/Dh
	lVoNtSaIe1nnnCWrkwy3MGXhXuGyplw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nUSFGBKyQqAg2kJryhet0KktU3EGqcgJC/1t2sxjDPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788457924; v=1; x=1789062724;
 b=JrPiCao8yAfZM1HEVWuYw7+bqX9ray300lRKNPA4ODlCk1SclmxNTEpJB/hhTaXwPgy6S5TO
 FA6T2Lji0yC4tAa+X0q7pFZs9aQT4WGE3HERTLEP07j9WdKCWew6zheIOm5OhjX8k65gJNJdC8t
 NghsvqBZEROzZ+LIkfehq0iw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 06323b0187315531;
	Thu, 03 Sep 2026 17:52:04 +0000
X-Mizu-Trace-ID: 06323b0187315531
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:52:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 2/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
Message-ID: <apmzo9CNCZ-OGfFw@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
X-Stat-Signature: prkcqrz5ppdki131defuh7yrx9kyjpzi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 442F840004
X-Rspam-User: 
X-HE-Tag: 1788457926-902820
X-HE-Meta: U2FsdGVkX18HIH8Qr/uea49Mk5HtmQfN62hukn5LvdQbIwSG6us8WTCkChgkUcCyQKvdGpM5+/9KwTQTQZmZxOU06SQRQHlrKV2JmkBbw8VPegsJwgVGjZLKdlHU1J3p35bExkykBZvmCrX9VJ3cPbiHQ8d0wpFYJndmSQ6tflHVIluSLbSX739F2CHjIv8gy3rJJ9dqx1qq+8tpAfbqlK6wZJgXMJ4o/YfapS95W0ulcXE80lLQ8ex+jvrhBE0oSbIjGvnaIYizJTLzZKmHKAbJCfgtvtFuo65RpwBnBlO40zWdrSR2wIpLb3lmKoSa0UUE/+9CntTkF2KB+rsc0VnLMXKq3XVsNLj9RzYBQnqqTBJtPixtmoe0J7X1lu4BIZ7JoJggVvEu14No2ujBlUWu52KtF5VkzJWyCTvSxIpmv2y3HJw38M0wmF7OiZYPTp8UFLtp7e7EpoCBZva+P5rzGFnoU/Epc/Z4x06EFzHNPeXgGpQUoEG3bWbHHObrschKIGP7rS6FTfyGIcbLFDocxbbnb29q4uCrpFEs+mvA6xOgNnUmVGjaUqwW5pfAAsuEy61bhJ4W+t4XN7jg0faY5//CeRrH5BL0BnH6qrq9H2a3n4O/pXxbBVJ1K4g39MQ1te2OVvUM6TJj0OjHHHZZTiNfRKdG0fondMo6AVTpAmGnlRjsCVpb88JL2qcb+u2zhHoCNASVzFHamJIxEg1PZTzTXpaYksGoWYr9STBNQQM+Dom7yUpKn0WRgqkpQHamBCMm+G9hwWgWaIF69pYy5LX16f09lb7E/BKsNtkJTU+B+sIgIxV6tgmLO/dyalwkyrG0b7R3KAj1iu1Sy3u+VFe23rADFnnmyu39s6GRxuAYw/A33uUasxrBpZELC4KdjeNF0cYA7eQVpK38CtuA/Q46Wp02VmHzHZwysrFAuvo/hvuG9dWAd5hoZAAYLOeVVH2+22XX0bRp3Np
 M50hgv8N
 XEncFAiqvXsyqVFi+nJ/2efFB62ZjIwWoY84siI96JdmQC+2le6AsYqAwUa8p4kMwS+4C521VM6/qqDtiYBospfIsjxW6djDfnoTCL3SDPrCrDYIbYDh54RavUP9IZIa2eJ+31Nd1mdkWNGOjRg1Y+xdrihLJGNmoooAokuCmHrOGBFIEtEmuSizmWH5zOYofSiTk98A3S7E5t2y1CFt8iTNRA9Ji2ZJyb1IwE4lbJh7yKco+Z1fxGbhXH2syIwFQYjAh87VVI+J929cbQ/zIrm1b7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:10PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
> its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
> stats keep being accounted to the dying memcg itself.
> 
> The previous patch restored lruvec_page_state_local() in
> count_shadow_nodes(), which reads those state_locals on cgroup v2 too, so
> apply the redirection to all hierarchies.  Offlining is rare, so the added
> cost on the stat update fast path is limited to an rcu_read_lock() and a
> css_is_dying() check; the upward walk happens only while a memcg is dying.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

If we want to backport the first patch to stable trees then we need to backport
this one too.

> ---
>  mm/memcontrol.c | 30 +++++-------------------------
>  1 file changed, 5 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..b3d1ac3fe0aa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -805,20 +805,14 @@ static long memcg_state_val_in_pages(int idx, long val)
>  	return val < 0 ? -res : res;
>  }
>  
> -#ifdef CONFIG_MEMCG_V1
>  /*
> - * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
> - * reparenting of non-hierarchical state_locals.
> + * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race
> + * with reparenting of non-hierarchical state_locals.  Offlining a
> + * memcg is rare, so do the redirection for all cgroup hierarchies.
>   */
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> -							   bool *rcu_locked)
> +static inline struct mem_cgroup *
> +get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
>  {
> -	/* Rebinding can cause this value to be changed at runtime */
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> -		*rcu_locked = false;
> -		return memcg;
> -	}
> -
>  	rcu_read_lock();
>  	*rcu_locked = true;
>  
> @@ -830,22 +824,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
>  
>  static inline void get_non_dying_memcg_end(bool rcu_locked)
>  {
> -	if (!rcu_locked)
> -		return;
> -
>  	rcu_read_unlock();
>  }
> -#else
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> -							   bool *rcu_locked)
> -{
> -	return memcg;
> -}
> -
> -static inline void get_non_dying_memcg_end(bool rcu_locked)
> -{
> -}
> -#endif
>  
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
>  			      enum memcg_stat_item idx, long val)
> -- 
> 2.53.0
> 

