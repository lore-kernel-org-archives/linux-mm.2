Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91684C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E77F6B016C; Wed, 12 Aug 2026 09:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5975D6B016D; Wed, 12 Aug 2026 09:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488D36B016E; Wed, 12 Aug 2026 09:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 211936B016C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:48:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B051416037B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:48:40 +0000 (UTC)
X-FDA: 85092747600.03.B211206
Received: from mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97C3B80011
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:48:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqt6VLL2;
	spf=pass (imf30.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.249 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxJE5C6YtFE0Ee+SEe2FvdZ5LddPaUuMhy07fXctXXI=;
	b=7i9gjvCmrj4Kf9CYphuyTxSe8vf2ARMy1qaOBSRnkBOiyXA9+dUSueQEIsb7H32ogB7FCB
	7vkW6ZK/oCSnzVU0qgbhhtnSa1/oim5FHY9CF2rVQjlekWhwVBrL+UjfLnV6XURJRbuZVr
	+G5bIf0w6F2IrHMzqXWGMmPXdV27XEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542518;
	b=XYontf64F16sJ7DPpa6VSPbEi0HP3G3KS2QkWfw/Cx885OpOuaar3/8mjLR5tShA7jknY6
	GsNear3Nv4GvfMiJiDvBOfTZ7xGtr/VePKyWPPOKVfjq9Cwqoyzx425Ew453OfXGRK0sSb
	D3Is0dAgllgt1frtmizCDpwnkfKFnZA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqt6VLL2;
	spf=pass (imf30.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.249 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ASMCgRYWFh1U8hGKVOolQ/aTQ/PK231J3u3FwxsWacs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786542517; v=1; x=1787147317;
 b=bqt6VLL2oPMWtajSw0sxl/NU0Mo2Oiu8rit8fZeSxMtlJERaEfHNKZKZGumb5o1F/v0QRCK2
 qUUzXNLihvi8GGJFN+FA5creF05Y21skfBl4r/uq1Rk1GluMrGOYCYW47E7+tLQu4EMtBrQmm9x
 8hNvs/6pH89NGSVYK7fZ3GIY=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.1.116] (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 18dd0f5011e94cb8;
	Wed, 12 Aug 2026 13:48:37 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <3ab5e2cb-0660-4b20-9e67-cb47e17ae554@linux.dev>
Date: Wed, 12 Aug 2026 21:48:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Harry Yoo <harry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sdnoeegqfj4faejoxq6hwz89j6qcpzrd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97C3B80011
X-HE-Tag: 1786542518-158702
X-HE-Meta: U2FsdGVkX18T2T/n3rSUGAuRMamJGLowgy+MM+zFCt5lAiz/cZDKM6GChDt3ezXcAjn2Jd4onDi79WT8KPpyQXDq5PxqbcJR0fM8Av7t2YZW38A6XWb4Uk2U4hxy0VK4Kp4Dg2K52AzC8EUkeShWR92TAnxsDM0qoPgGVwj78WYxpCPikvhtoCQN1wz9MgcQIN3KMtNEoQsFZK6IJ+DfTZZkKjlY9H9OtYsP70EgeAnmfMaU3UFvBGKeuhGEkepBljfZtzVpENArJijwVCyZoPPdw5DIAeO6adc8+G1yL7BBmWdP484Wl1xzAdAFbse3EPdwT4LD4UMOSa2rSUb5udK2fxAWd2Lvov+ETLiF6iCnBI1/JMgWHmKkI2wIFT0Fplvxp9QsfiatYYRziruRRBc4DIJ2wurmgWY0/IifF+VTfn5THv0ZDQLoP5JaS2qnNe99PZxDtpyqwJA6d1JJXMOH01QHnq/xU5EMft1hhVaVc6MKMG07nbO+ibQ9gDY+5pbpEL222RWPdcY4V9w40CSI9sLJt6gjeWbLOZX60CtsqQY2dKKLXzASEoGMXiXmpB0k8JXdm5Kp98jZcVhzinV3K+QY7N93MNpr4NKKOKPSBfl0oEVuNFsKHUDEI78STFGjfie3tMMdSZMGaO+C7kEYDJDFhRfbcj8i6dA+mq8LIzqOg/21AoaQswSOWiu1v4qKHEbq5n9lKQsYH8mXDTC4M3VQbu72h3EtqvyUiaU3Tssk9aAspnU1IRRuMr87RQe5ocS0ok3tF/JFHeHYzg/1fMe6TYVek3TupdaW2k1YWJZepgrbVtdimGxeiBaKxjt764k5w1yfJKbAp0o+2/v10ioURmQAQXS6cgpaDJRqUvglg/yTVbfs7MOSKq6mSlnS/X9ugljlTvoCP80/oLxqzsvOpU4AAuOjk6Zke1cebwo2Nk1gg8Ab9mFN82HJw8SOeYOwlwf2glBLCzF
 J2legl37
 51zAkRqHpU+Uv11VHvZV7LIZuG4yMYC/48nHPnJJzjIagQRO0eYatuR67N+KjVY8lcJdXLgaKx8TYVfa4ttjSsZTqWF09mFFrWZM/qsQJkLbd6AIge8Gx3j0qLmT36Pg6G28J9oCWJ5ExdgPolOa9lOqlH3+UEjYNQTAEPfHf3AOM9mSzDuAgpOHc7YngPdGY29fQAZQWUXHyy4akGg0J7aypdKGH8Sfi59OKh06jG26qlkG2wGIuG/NyFbBAFzeWdSHyYyPDQgoZudu0zpJN9HgCx2J+q81/WDaHQvqfIbFlbG0c5KXnnPvTZWpTLG61uSUus8DzvtkCXx7nEvG+zAFB4ARej9bysaEDOS5WbQ8VTdm3QbZsWxfDc/SeNMwDNv8rl1Mar2AbSawNQ9M+Tiw+AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/12 20:48, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d1312441a02b..aef480f46891 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  	refill_obj_stock(objcg, size, true);
>  }
>  
> -static inline size_t obj_full_size(struct kmem_cache *s)
> +static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
>  {
>  	/*
>  	 * For each accounted object there is an extra space which is used
> -	 * to store obj_cgroup membership. Charge it too.
> +	 * to store obj_cgroup membership. Charge it too, unless it is stored
> +	 * in object padding already covered by s->size.
>  	 */
> +	if (obj_exts_in_object(slab))
> +		return s->size;
> +
>  	return s->size + sizeof(struct obj_cgroup *);
>  }
>  
> @@ -3539,7 +3543,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  				  gfp_t flags, unsigned int slab_alloc_flags,
>  				  size_t size, void **p)
>  {
> -	size_t obj_size = obj_full_size(s);
>  	struct obj_cgroup *objcg;
>  	struct slab *slab;
>  	size_t i;
> @@ -3580,6 +3583,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  		unsigned long obj_exts;
>  		struct slabobj_ext *obj_ext;
>  		struct obj_stock_pcp *stock;
> +		size_t obj_size;
>  
>  		slab = virt_to_slab(p[i]);
>  
> @@ -3590,6 +3594,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  				continue;
>  		}
>  
> +		obj_size = obj_full_size(s, slab);
> +
>  		/*
>  		 * if we fail and size is 1, memcg_alloc_abort_single() will
>  		 * just free the object, which is ok as we have not assigned
> @@ -3632,7 +3638,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
>  			    void **p, int objects, unsigned long obj_exts)
>  {
> -	size_t obj_size = obj_full_size(s);
> +	size_t obj_size = obj_full_size(s, slab);
>  
>  	for (int i = 0; i < objects; i++) {
>  		struct obj_cgroup *objcg;
> 
> base-commit: e7f630142df2afccce90555e4972e60008222311
Reviewed-by: Tao Cui <cuitao@kylinos.cn>


