Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69992C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5346F6B0088; Thu, 20 Aug 2026 03:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E56E6B008A; Thu, 20 Aug 2026 03:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D50B6B0095; Thu, 20 Aug 2026 03:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7C16B0088
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:06:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F624160674
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:06:23 +0000 (UTC)
X-FDA: 85120764246.04.ED3150F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 729A680005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:06:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZkuTnBAq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787209581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSJ5BKrVQsiwQ6NExnR9GYYYXRVPl3OFkAnmP+WvLQE=;
	b=PB/kEdWIxsNvKxioi54zFIM2IKRL6JDbQp/aZlbHIfyoQaP3u8JOMadb07bNxHGGXLkqvX
	r8PzuN/YXrULyUiIPOc8Kpzh2iG2TgL5csqnpOJ1wVcqbyEqnggM9uYySVJhiIzd4z713+
	aUl4coEeP+AzI81VAIpMSApzGrtgSHI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZkuTnBAq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787209581;
	b=OCOizc3boXjUaCNrvus0SXXXF3ZZ0wV4mc4vQO/b9wteUbRetN6XZUejopqtDUb85NULzc
	bARgZ/08EEwbMoau9PgtXQjSaIDFIsSwW0KvwnB+ceJCPEsjK0W6GyLugJzOmPvk/x/JV6
	JKpa60LroyItDTPODz59+Ru+X6S4eTE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-499acf0fb55so10346715e9.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787209580; x=1787814380; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OSJ5BKrVQsiwQ6NExnR9GYYYXRVPl3OFkAnmP+WvLQE=;
        b=ZkuTnBAq3wGzF9c+FnXNT4hyCtyCoWP4kB2CrVtPfARO9Wk8qg9eNypMe/7J63EeNy
         YSr1k3FMxdXANSLyfclvzzQEvQ3c0IUpBMMGJYmMWU0/dAn6WGDOuFm93ibFE9se83rg
         MOPnaIH6Xj+KJHK48yRE2lq9Wlz/DjKeo0uCIPbapkjYAXGcTiODLsjpspi9lHbUP6Mz
         nad6FVpM3/dt8+G+CBc0dDee9jLFOiU8aZGYjgF344e2xUIpd4uLTUX3LCFW21gcWEG5
         fXKgIjr2+um14xtvUxGmH8rV8caPPk+i/5eTpEuPT8STCrFbsX7vstAbNeYTmh9xKEJm
         yaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787209580; x=1787814380;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OSJ5BKrVQsiwQ6NExnR9GYYYXRVPl3OFkAnmP+WvLQE=;
        b=P0MxKSmzzoAY6LhFt36zfn6on6CepU5s0kiu0HpI9hV0tDwTWJvLTvavhynhLIC0Ic
         OzZ0aFMxR+NsiHDCzfI416CJSfqp5tN3MnF0NBNLvXECshDEeKe6bZ7eAxAKt+Wx8yib
         lVmIP0GHr043jWsloFQfLTYEWuyywv765qDWelM1FRRiDC3VVkZqYICd+CE9yhDLTPRM
         Eu56bHJbykRPA32xcU7V3VzSpoxA4HJuVc77FEWiIeibaqXwpv4LmLFLDGpFEvLpV8aj
         q2PKDnILIS+a1zIvsPMjNlJc/hFFzfsQ1vMWa53ABFxviGp9MNaH3eB5MKFMlQisX5ZA
         lUiw==
X-Forwarded-Encrypted: i=1; AHgh+RrbRS3WbMk+nzeoX2vAdE0jrpIKaJBUKKMcVEjljZatF8JSL0sol4XLij52Iqqg+EsYSTV+lcLd1Q==@kvack.org
X-Gm-Message-State: AOJu0YxE4BruOcWCud4lSslOX51SKgfbmcK2cjhskA/iT6f89YSin405
	Svu5hQr5pOTPHvwEA+6FdqacZa3o8Dmggc8/C4Wqh0lGmE0hAVaWLg+xg/GPcWk0jgA=
X-Gm-Gg: AR+sD13VvwuiMoHVXiPUw1zUNYyqFwxQEq6dWcHb/FBcaw9eU9dfQvYg1ATvppIQQnI
	DA0K2eanJWF8XVflyV8qeGIBiUlnlNWEJbzcyouaB6CkM3aDV15jvh0lhpXCyav3pmoWC5OkXUk
	a8JjpLSFTS5Ep1ApC3cdqz4tUSJSkgDIt7klFks4GktyDMeFtoOWTd5C9gAYjsZ2UILvSV/18RU
	3neGyHbRjXUyvG0K+6U3smdZuMJva5t0b/ousNZAE0BTejNtJl2RCcpc1JFkmo+FkwUIHTqL4w9
	M6ggzLsyuvvvFoRVFA0EiiMqg26xXA8inoXMNK3zEpUbTMSvnWricJIvNY2zcurPJs3/t9ZWa4A
	e2zH7INx9Ap6UJnpkPqtCCqrpMgi9/itwElQFuFDdkfnXc+CmfkNC9liXWdjR2425YRiIc6Bkkx
	r3BGCOGOKeaTcpFXSAJ2OJPIxAsn/7YhDaO+SLJYdkZqquh0gu4tbQulV9p+/SLsJ2rst7E68zl
	z9FMEhkUgX+
X-Received: by 2002:a05:600c:6211:b0:499:a760:722f with SMTP id 5b1f17b1804b1-499aa1ba0b7mr188614485e9.13.1787209579825;
        Thu, 20 Aug 2026 00:06:19 -0700 (PDT)
Received: from localhost (109-81-21-108.rct.o2.cz. [109.81.21.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b3c556a3sm10815435e9.3.2026.08.20.00.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:06:19 -0700 (PDT)
Date: Thu, 20 Aug 2026 09:06:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aoanalsTiGmL69LN@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820012010.2016086-1-shakeel.butt@linux.dev>
X-Stat-Signature: hfib15xtnn3w1nu5j9gya96hok6ooubr
X-Rspamd-Queue-Id: 729A680005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787209581-143412
X-HE-Meta: U2FsdGVkX19zIoGqKASfqHLnWapXzXXM/meP8tuSXlTVHrdIGGMArP4y3MTRR3fs2BJq5PE8fAAcA6fXUN0U4QV3M9ngfDT9936BcJkfRfzeFffpx+vgN7wsJx00Va8G42m6uxugmYo+U/8JJiGtX4s8f8TclnnO4153yhzvyHns0hOzl3odTfYkfbJSYBnBkJ51oqeurG4TnzpndSkw6o44wNI96HJQERJpEh94gAqjaP/Duodqn0tWXsFVGVQZSJld0G9+Depp3pEzhzWlUA4BldocjLaC4UB59cFXa0qUpLH8Ek6wOc4TPPNAdI2wAgp0PrnrNFfd2Wu40gQq9gDPBRomhH6R6eMSq8RAAfK1de7REalVOGh6Xdz3uWSqfRAEb0smg+OfRcG4GDzlnNsmMnIJACDaH7cJ1gbgClNHO4rSqukDy78OSi7WHR1wbW3IJJBPoR7UxDcPdo6gFaqmOsY3Ycx4kKwO7NNPhkbWlhUGtrnMeJSJXcYCCLNn+NdkzjDlE5iOAwC7OkpB7ecghjBbD26XGaVwU3lvt0P0HyASaqlbu0pC7k/uX6J2IOxtyrzZkjeIwSlX7A1aDMlSed4UZEwInLHIB1ZReXwVlo3nta/+YqvhZGa9IKGz0dHVf5zAZHYTdzaJU98UpFzs2oIWM6cx/9Z73qYpYEOlwiUzyMuyv36pXDDzgBLbd4YE3uHyNtPscXZckGrvoqnkFjSFTItv+HDv6z05qvJrICPC9G10BAXZOpQuUBZcV3f7QJFI+iZS9ibF9ZgEQGg0i4NpTAFvijSOzGLWkqS6r/LEaKiPRm01vF60vMEDvDod03u4V6rqxQK1wqmJKNzL7Llpe9ehh5torJgW1B/unQA1tb728CmUdlnP1+SCkEtm7MUauY7j+15YsNxvG5xfiu3vPsXQSM5KR3KBIB6YpgfdPzcuWRL3sRP0fuMK06d9qWDAYnXLwUw48ne
 7t4hXQ92
 Ft9J3b/K4yue8lo2UPX3XSBL6oactEFnOqQTeZEiHmt2UlN6OxnNEM4xIQAVWDsY9RXyZ3+vXUNNPpXcvsY+m/vukgRvvYoHiUFmElKW4Cflztf4OPNF3NQoe8AiDohDYLHH5kV0bFF+XW99aZL0kFVPLBdSVwvXrObykY8mZ9a7FLJg5OSMPEcWwafPOKWq7HENRQNWG31k8KIBSYllSqbzv2+sYcuv8dlH3DPcvetx5KzCoa+0e6yC2/Qjv21m7fC5LPBax8Peoud2kMHTtaYniHxBJopNNroC86Hk3mBrB+BBPWd2mCA90OJLodwmv4c1vUNfe5/3kEl0AJXbgfJjujIW0MM97DI/GN3jERbx66IcQeg8ZT/wa1rJuEVOLe9K/DMKNAIHG8PZvLguj8b1jCsFtokPPwr/jC8nRPYwZG9VbHrx7VtDZ47u5DhQAYAh8sWM6Ju0DZT5dxETh4Dyp21bjwBBHYL0pLlU6Udy/oPK/XbvJHJWWShk/uFmCnF+S/IAdycP19+KsfSA2PgHpSNMliYA3TQ+FqCFupXh2Tv+LNX0xRgj6nOKbA2mJxvvS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> Joy reported that an application generating a request/response traffic
> pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> for a range of message sizes, against 0.27% to 0.71% outside that range.
> Running from the root memcg, where socket memory accounting is skipped,
> recovers the performance.
> 
> Tracing the charge path showed that the application generates a pattern
> where the write syscall charges one page and the read syscall uncharges
> two pages on the same CPU. This hits a corner case in the memcg percpu
> stock code that thrashes the stock continuously.
> 
> In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> watermark and the emptying target, i.e. on a request to charge one page
> the kernel charges MEMCG_CHARGE_BATCH pages and caches
> (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> and refill_stock() then empties the cache completely. With such a
> pattern the percpu stock becomes completely ineffective.
> 
> Instead of a single boundary point for charges, use the technique the
> page allocator uses for its own percpu caches, which keeps the watermark
> and the emptying target apart: nr_pcp_free() frees between batch and
> high - batch pages, leaving at least pcp->batch on the list. Add a high
> watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> return only the pages above MEMCG_STOCK_LOW. The watermarks are
> MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> batch.
> 
> For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in
> future we will reevaluate if it makes sense to increase it.
> 
> Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
One minor nit

> ---
> 
> Changes since v1:
> http://lore.kernel.org/20260817234651.666540-1-shakeel.butt@linux.dev
> - Kept the upper limit of memcg stock same as before (Michal)
> 
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..58e4d23cf5e0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			empty_slot = i;
>  		if (memcg == READ_ONCE(stock->cached[i])) {
>  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> +			if (stock_pages > MEMCG_STOCK_HIGH) {
> +				memcg_uncharge(memcg,
> +					       stock_pages - MEMCG_STOCK_LOW);
> +				stock_pages = MEMCG_STOCK_LOW;

I would find it easier to read to keep the update in sync with
memcg_uncharge, i.e.
				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> +			}
>  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> -			if (stock_pages > MEMCG_CHARGE_BATCH)
> -				drain_stock(stock, i);
>  			success = true;
>  			break;
>  		}
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

