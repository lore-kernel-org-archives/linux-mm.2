Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F43C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B588B6B0092; Mon, 13 Jul 2026 06:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17C36B0093; Mon, 13 Jul 2026 06:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55976B0095; Mon, 13 Jul 2026 06:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81C8E6B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:25:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EAC21C9782
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:25:31 +0000 (UTC)
X-FDA: 84983371662.12.6577BB2
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEC8B40009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:25:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN6l9GTE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783938329;
	b=vObTaqRtDr9Y6RdTNKENqL2yKqfAbJx8b7pg4C/bndpq/B2WFbX/qzaNPDPUZbhVCtotUt
	jGmPJPffrrOT32NEdAxoizR/RaVVNOPFpFmT4sC48g+QXfcqPeYCN8x9vQ4ZOQvAlJ5JhP
	JbzFGneUeX8T+1cMcsdoHp1GuYENE/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN6l9GTE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783938329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bis2MuGXWFD5TpnswdWqxFN7wnvNbqtWSAdebpKoWII=;
	b=78bP5VbD9QJdZXZB237j3mN6vngCLyQHhbktoyDNxxU/dOMEEcFlv20eqXi4sXNxyw7NJe
	KBdfzk6t5IkW6mbvj6yKLpq8vrrC3R+90pJ4sY5ZoPb2h58hqLFC+sawCuhA3f329sIsbL
	o6ZoxgRYgr64/VdK6ePT4+x/4Zm9g5Q=
Message-ID: <e24b7c7d-27d6-4bd6-9746-37d9b9b34297@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bis2MuGXWFD5TpnswdWqxFN7wnvNbqtWSAdebpKoWII=;
	b=sN6l9GTEytX0lp2CAY/Anp4qUSVkuPKf2U4INDn4nV90Pn732VdVEz8fSkZiKY6lYnxSm7
	Pl2JoorWdT9H4F4J0460Qmjlx7fMD67LccUIuQ47d2Nuwe1T76Rtdrqjr1pgClyVxHdrFx
	uekrnxwt0gZbZ1eg4AJkuRe/gMoHXg0=
Date: Mon, 13 Jul 2026 18:25:11 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BEC8B40009
X-Rspam-User: 
X-Stat-Signature: gded8tkbhgzykmccz43tqdr43qo95yyu
X-Rspamd-Server: rspam03
X-HE-Tag: 1783938327-698379
X-HE-Meta: U2FsdGVkX199ReKC6EJ3xxLHdO8VFLyI4PMBNDqJBfvtH/QB4TsCgjpA9yx7e0nZjH5bXcaUXlX97NiNjNVuWAtYwvitdYKOOZkNsC8lAwj+sxMu/Hx4Ia6A5z51YnRd+mc0oTp7GiQZxjbkLd1MOMGGIi3sTfTJ+E5LmiJTKzoz/oDaBicw+5I3u2Wt1kZ8r+z/r6miF+wQ2ugTN+s7G6kbsRxNvAjAM2eEdWwzprOi5MkPUl5UAGRZewjD5QFdBsXGBOgSndCBkEfGFCi3Fxwd6w/lp7oLCWi25rqHPZ8PnFxWjzONlAhZC4BbWc7ZtuxMY+qYM7Jo09nlpNZybC/bRQPS5IQQTnIQDnoiXaC3fEoc1vqSBSO1ESYDFaKqZojuyMWlCMkt0qCv94m1TKoxCU6pYGC2sRae+/H5Q1pFVatGmpQG4yOPY/ZeuLfOMSOfMR6jCkMaLZMhhKy0aWTbIRT+OU+dgDqygGPuA1S/qNEL4IZ3vZcc5/KIxG2xYzlY9K6IvbQC33DwcKPs+HJCjmEeg8W3ASy+weYzoNBVDzGwXWocCwdddeLrPorfxjMjOqXNrlE8PwzKKHJlzPv+8kzDZXVGDAFaQKA3RK9HwABvBUxfBeaG8GJa6aX347YOnPbxyvGwLs2Ucn14y5vRIg9DdPpbP4TmceElIzqEc4SBHSmprBcAecuFdOKB2CmE/aBKKa5w2Y2av//1ZQQ/d8q4HAE7tniAsh4wZgOXn8AZJC5L5XBV9Ukf9qham6jMVNgcedNoFAOZ8AOfkwvEl4ND1idMu5WsorAsQ+HQwsSs6Olb/rWX0ZlXyhCrgPCOsIew+Ip4vfJtoevkvNYK7R8L5lrw/8JvJORWW6L3vVYWg+I3vFrT8uw0UqluBzW6EB727JkqylaCSXESor0mJrfBHz/EU313/nmi8HoV4HcXmr61wh8xayEtOiemrvTjSbdOaZ7O8B3XfMb
 7k/ChM+x
 fnDPZdRN6eu2N6P0NW/prciG1M/NMiZ4CbxOsitrgFX4Ou0acr/EbnzpNofvKWkW7rEwf2nzIQ3F7Bga/KyzAPoC3vTpGYu/FssHnGpuVP24HfOkogOez70CSRyH6wbkBVmSCaNKTZnnhAt696LVQ/KiLVVzlnn1FytD5Aj+s5NVNRUlBFNIITuTVmBQM8t/2dkmHlK3mK5NZ98fyKBA9UHG5yC9rLWN4FY2ahLRQkRxbfyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/13 17:03, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.
Acked-by: Tao Cui <cuitao@kylinos.cn>
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22f55aeb94f3..86acfe55a201 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -137,6 +137,14 @@ bool mem_cgroup_kmem_disabled(void)
>  
>  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
>  
> +static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> +{
> +	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> +	memcg1_account_kmem(memcg, -nr_pages);
> +	if (!mem_cgroup_is_root(memcg))
> +		memcg_uncharge(memcg, nr_pages);
> +}
> +
>  static void obj_cgroup_release(struct percpu_ref *ref)
>  {
>  	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
> @@ -172,10 +180,7 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>  		struct mem_cgroup *memcg;
>  
>  		memcg = get_mem_cgroup_from_objcg(objcg);
> -		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> -		memcg1_account_kmem(memcg, -nr_pages);
> -		if (!mem_cgroup_is_root(memcg))
> -			memcg_uncharge(memcg, nr_pages);
> +		memcg_uncharge_kmem(memcg, nr_pages);
>  		mem_cgroup_put(memcg);
>  	}
>  
> @@ -3329,10 +3334,7 @@ static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
>  
>  			memcg = get_mem_cgroup_from_objcg(old);
>  
> -			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> -			memcg1_account_kmem(memcg, -nr_pages);
> -			if (!mem_cgroup_is_root(memcg))
> -				memcg_uncharge(memcg, nr_pages);
> +			memcg_uncharge_kmem(memcg, nr_pages);
>  
>  			css_put(&memcg->css);
>  		}


