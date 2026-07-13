Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF6EC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0896B008A; Mon, 13 Jul 2026 06:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681CE6B008C; Mon, 13 Jul 2026 06:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597C46B0092; Mon, 13 Jul 2026 06:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 357DF6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:24:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADADEC7458
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:24:31 +0000 (UTC)
X-FDA: 84983369142.29.A5A31A4
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id 329FB160006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:24:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvMmJ6cU;
	spf=pass (imf08.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783938270;
	b=VDm8GcjTVajDrsUXSVcuqIDvRQrGNZfKfqZs/QzAC4TOx51eZZlYfDzZAAPvtc6/Lzj2wE
	Oyh5CuQ+J8WFn9UqTvi1WKQJjCF9+t8O4BjUy1igakcfE/Vr6odasQPQgeWf90lu6moMgT
	aADNlzJyUsFitjNiKFntEYa/Zq0kygQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvMmJ6cU;
	spf=pass (imf08.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783938270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nlpe1/nwJgVHs+1CgELsGk74K3Ki4WuxEiQer53NK8w=;
	b=YQU7Ox8IBa8MBvVaj4InbUqGeNJ/D1ZD2P/aS5SO+Ln4+CKKEwokOOHZoajUeEV6bdtmO2
	1FOkngmNsNDQ8e7FCSPtjcYMRZrFB/tMO0yBSOl24ivRrA5g5T79UZsuq6ZJdss14gm4dR
	N70qE1dE4jW7j4wEArsYgiS4HBvnOAw=
Message-ID: <1bd1dd99-4db0-4120-bebf-b1da42977778@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nlpe1/nwJgVHs+1CgELsGk74K3Ki4WuxEiQer53NK8w=;
	b=uvMmJ6cUAyBsmzFEXhT9EaxuwrEH+WOZ9I2vr8S7uIrGuNyoIhqebiAcV8/uYTDFI52Mop
	rtyUJEmCxdapuezObmHKvTA8N7XA0oUHZ5RTvMJX3BMHFgoH0swoYx44FF89YtuVo3kVxh
	zW3velkdD7gVnpzhzlfybnpoaCRkLyg=
Date: Mon, 13 Jul 2026 18:24:14 +0800
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 329FB160006
X-Stat-Signature: gded8tkbhgzykmccz43tqdr43qo95yyu
X-HE-Tag: 1783938269-215296
X-HE-Meta: U2FsdGVkX1/i1oW5XL1+esEY0c6RhEWc9xGuCY+M4YieY36IqkrakNBRxe+949BUIkbR5T3f3/HNqFy9SLZikec4idT5CqDlKZLlQ+nqBvq4WsHI2HpSb5Bn1Mwy6GyK6+iZQO2SCzZeQOngRbgyA8mSUCZ29/bGnk0HnCSlYG70+UBg7UvKyksAClbF66jsOWX23AItLAaiSqd8SUTHAeWLwfVGeEr+R0geTwnYjw2BqP6MiiBhAFGK7hp2ej63v1XoBMKj/og8/Tc28+Ru1z+khPHtImbjjXe5iKYzMITvmv6ndwaWeDZBH9qUC/pBFO0mJ+GMgubTNjXtNpp+bHwo/dEkqkHDXEECcUys7oDg6zrbqDPF19nJccHSfg5vRT0t9IsPwRJnuaC4KTTexrU81Se2Ux6d54OvlNN18KjX5jN8vdlLz9x2x5RiUd5W1zEWMkvLx9HUcRx9zCx+yOfprD4C9vMBzAms/MFC/yFQyGCDroKwv6tGmLr4El1VGr68DM0ufZufSGIgMQkYXT5Vx7hEgZo6Jd3l/LlM5Tq58U/5/EaJi3WeHjItQP+shFGLwSjyFEP0PkqRlWbLiU6UCJoI/wFQWlyIqIPRjGencejDbBBAfytUAm4I5qnhrcIq/d8qaKIq5tjvSKyPL94mVqQg/yUgakznQBURc9FgvgKalObC9SOH+ewq6c6NEllXZC3V+7SYE5wWdLD0mHyad0lVMOXzlCjqWZrfhvq+yu5esvoewL/hgtrcoUYO3dTvceMiIsN0DaWl5IWnTdwnktocsefJR3Yje2QFr3O7N9xAMUG7zuw2mzY7ChGnPcgjIJuQdY4xGlnUiogjKsA7DJ4srmTAsWSlVbAy9B9KSfYG6pPs9T6pAPdg3bEgOndWHXtGnseb/+qSiwCOmP3cOwPeH+g5YQf0Umj76NMeUqilPuJk+LpmYjs7eSuyyoIaoo/s/s5nS47qIWc
 0hYLej6X
 vZUSqiuVZcne4DVdFGf1addEYdQIFwQbqbuYd/NJH4dcbGja7ZxyA9gLwmD8hR/uDQ6Dc8s53/cIexAxbjW5EAxT8Z/B11ZiEM076OidiMwnIYTcVsLfS0A5WiOpwNCgjyOEQvCDgYrCdQlxlf3TXGMMxlsHZOMRpMhHcpCU4qK61sg3Aedvc3UagNoP5PuYVXnITQIE8X9YWcbSIRE/TsTP3+wNBnWXwzP1zzeV+TxmJv1k=
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


