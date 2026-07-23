Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5022C4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA786B0088; Wed, 22 Jul 2026 22:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1B46B0093; Wed, 22 Jul 2026 22:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB6E6B0096; Wed, 22 Jul 2026 22:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 672AD6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:27:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E008DA0395
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:27:16 +0000 (UTC)
X-FDA: 85018454472.18.4641E9D
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA786140005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:27:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TPOocp7E;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784773635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkcumUgk1ANWHXgVO66BrCeyROSAiTypIfEMcbMxo1s=;
	b=JTF7LkElDAo039tOkbUWJ0aPCe7eij/nyHW7gm3Q3GRBfs4c97CeTl3ubqHicNg4R++AO7
	ogXkHt4yqqn/bQx1JZabuwDCB93Ll9h965TPyR9mSD6na00m9pkQF82umIURHBlQaKZxIQ
	/6R+J3LBWQwekZtOSu6Xrd8NF/4DJIE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TPOocp7E;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784773635;
	b=EddAe2SZz/wb7jZlUOVJBc7vz3/+z1k3QvPusolDG0mVgU5Jz5WGadQCa0k1Pu1EeyD4K8
	NcuEoUuoRrJKrjzAS6waZMtoV+uDxxWcPvnII3xQvg1bHPDMOAsizp7RJfoEF4Zj1NLg+w
	/BcjH5W6QOVXSryp45y2KtWvodHlvt0=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930f618435cso16690185a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784773633; x=1785378433; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nkcumUgk1ANWHXgVO66BrCeyROSAiTypIfEMcbMxo1s=;
        b=TPOocp7EjQhMGaENiD1+AdM0P/Q4oNqSG0bDdaFvJkZXRNm8yPOJdXxYY3+7h6MSq+
         npNzqCAuV8TZdRaUmFg0xa1HZOWKTBw0FvcTUV3WwU49A7lsV/JVxVGKjQYVx2sURaHh
         8gHEM7fL4vousa6oM3Zxci++hM05sG12nov+gFRl+U/Ynjxz6xm61f3Trh13C6bjsaS7
         lXVpCITVcDXa+MxCnFHLHAk56opL3IB6pXPHSlIfMD3sD0V8VWxRUJPMn3I9Vk7AyaaM
         wcMFTnaIZCQ4mKyjicR6zHkKvpJ1qPSFccEYhfY6HsF+NFkQmamLyy3U1Q9ooYLQVZ3E
         BZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784773633; x=1785378433;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nkcumUgk1ANWHXgVO66BrCeyROSAiTypIfEMcbMxo1s=;
        b=T5tb41fQDx7ImiZjjuHMT9zXZ3B/TUsL0brdgOAljjRmJqNcz9zkEDXlmZ9YmCYG1Z
         gMjfl3xMWlTLBRv3TzGzzS6ubYgPET93A/rXHqK3fGI4ioC5bvjUpcoQuEnRsIJ1/xMj
         Yi7wrcdmHtqiH0ZJACeuFXuYtop5V2iF21UVwrhLHuumcP9VWrya1vpkdBF21vSHtmLp
         BuniwHHXrMNjyTFpHRD6r6SEvyFnEwmraz7vkQvyAU/Hv2tGloq9Ucetr+KTaDiGEQ15
         b+0JOcnzDOvHbeL5Y8LmAdZGBGJxlh5NPpgqPFgKtULhKotBJYbecPAGmwGkLkA+jB55
         B23Q==
X-Forwarded-Encrypted: i=1; AHgh+RquSu396CIc2dkGi1E1Qj2x/CmgZeR98f9fElWfZBxpSHmLlu8Zi0Opz2ov3nBWhR1QkZZV8DZj8A==@kvack.org
X-Gm-Message-State: AOJu0Yw67NEjVueYxL0wX5mDY1gkQ2LwEXSvY/fIHJwzbN1RTP+XfL+c
	GH/Ob77zCuvMfbkYUE0SMZP9WzMekpnQPDyWmPY94BBrf49jmqWK1Ew/+MsTDBY5iGY=
X-Gm-Gg: AR+sD12aHe3uqzAo4SVSpu4ee3yiihzEqoDA4QJN/F0dIrhsGZEg1bR2O3VWSPLaDnz
	ey6Zue3sslW8PMmC6vXvI7P+Pp/gWeEctlp3g3Ki+VHKZ5c6tPvxOze5jYClR1PV1yNyWAeDzmU
	Iob+U++tAs10QW2P0PYb3uioD5nsHNbiEhco//viGchHoE8oj0cnSa4CEmsrMS2woHA9cw52sHK
	TXPzOjwxW5pli25VFElU8vJT4riqBG+RTeFGWeLbXwU5FUNSpHjSxVXORC9ytMBl6mDGpM+ogsI
	fsIEiBqBIvT5vkx07JWtbJVO/L4Y64hh2H1iJYm7mNZ9PDl51l49nP5ZOaNdRcw7Z5k4qHAzP50
	lSqyNxgzVp1IEX1JR2v10WKEkZTFndpSTNrLkbPZAejJeDeqazH5Mkc7FY11FCNCwxGilOuYzpz
	WbsDAxa9uvtgo=
X-Received: by 2002:a05:620a:44d3:b0:931:1d6:8a98 with SMTP id af79cd13be357-931038c7f92mr142596385a.41.1784773633581;
        Wed, 22 Jul 2026 19:27:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a03834sm304453585a.30.2026.07.22.19.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 19:27:12 -0700 (PDT)
Date: Wed, 22 Jul 2026 22:27:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amF7_GB5Rl6OJmt4@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085151.22822-3-jiahao.kernel@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AA786140005
X-Stat-Signature: u691p1s8rsgi31nk4nk8ar4ifcdrttqk
X-HE-Tag: 1784773634-875459
X-HE-Meta: U2FsdGVkX1/9CrwLEmYgH360yf/EPrBU1vQo/OzogpcoTs6vy3EyJMeiplJPO4pGfPZsW8OyJEhuQvLyQJlyuRlnyfYxudwG5B6CtI5wQsmOw9yj1wlvjs2sjWN19EoYPHLoIR+xskpH8BMhc1FlLLVa+VekfVyTjrFFT1cezbhkHLxI7xFxz7qezgRosfuvrw1xBwdMcTqv9z5Fq66HmlZuFYFEK3cJMB7FWfDuEKWeUUu8bTYBkDclFpaXwCZ0vwgJeyaGY9lu7n1f46wyjzIdRX8ncCCd6/OQu9MqhB1fklP9LHVVAACf6+6YDNE3GqKaxJ2Mjosidk3xjxZq0ppDjzz62/HMtCu/szcodPKNmon3Wpd955uYCW1ImH6XOHrkhL6ZwTjBrHK6Axz6knFXov1c9xwgdsdmee1HVasO2jwPPuDxRgvigpyvVx+kZNivjEYiTjflebRr6+MAkSJrdEMKci3Ib+e08DsP0qrINoQBm1WUsJFZp8EO0M3bdHGEMA4VgOp4prGkJGpLWgRubxHueFiY+dNfG7kruS+HV/EScrljtol9bptPoeQevhQcRQZTOKgyBmhqwEUM4adHo31s7raqMMZWmFa4IESQtE2cMcj8+keGjc8LYuS8ajqNi6/9gB8CfHyTc8ZcGzYcXpbDbb667L7jrZz2eCVsYsuQjTK8yHpT7fM8+USoXq+I0x21v85MR+nFNg6juUugYR/Beax09aiz8KGJQOuRu7/9AXa/K3KXKpKk08WyOaU/diyZxISydMUku0qaxL96ETktViqTGkg8CTrdpDjEQvP6UtSAPbFG/6enXTRjSkrgXFBVSV1M2aeLANStiymYlZJdRUhKCy7C9Xl4Kfem98ExxKk1SEHOwcOpxtAy69z9jSzEJdRgruYfXZPfbbQ/lPeikLJRBFJ2LUeAtlBJ/XijZH4X31Or+fQwIa1gBS4ed/Z9oBOLo4Lv/tW
 nAfqKlb3
 nc0uhUKnnyZmjFryCXXfskx4V32txQFkUm/DnLcP++U6eHb2StjBUsGP9+oW3A9wp8ZAzY7ho0/Qz0lsOVQWDGGuArrL3dN595BjsnVt9HnT4IIpfcwsMDJrtwKrgnx3b3Myg8VPR7NyU8a2CRV5kpBDIkXVQ74lVG7AVjcMFv3aBdPPcXXdeiMl3cWKOi7vT7WHaIN9Cz3xE6sEuSgpDpQE1BO/96u7PYaLjrtqJpDMU+7ev8e3hADn9ipkRy2dkvRcVCeEwvt4BwGLUpPGvgMHFYuOy6Z2lIAzPYl8l07KrE0yGolqQmbjfSQc9mRzemJ3BWkC1qm5lUYG6BxJWWZnyv3E8eL00+I2YKymVVyMSDNh7fSi91HqBpm5LqThfgoStBHpyG6mTVcFqeoIBWMo8wp7WrvItxSWdLG84kDi/ns7nhOuF524jTnGbZPHaKYpBhwX5auGpy6i7ygiwp3/t/32XdMOGJkbpmxPOqmBdlRxUGy0WEM9iBDyS63LUHvytDCbUWVRgWUR0d4uyIgwS8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
>  			goto resched;
>  		}
>  
> -		ret = shrink_memcg(memcg);
> +		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>  		/* drop the extra reference */
>  		mem_cgroup_put(memcg);
>  
> @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
>  	objcg = get_obj_cgroup_from_folio(folio);
>  	if (objcg && !obj_cgroup_may_zswap(objcg)) {
>  		memcg = get_mem_cgroup_from_objcg(objcg);
> -		if (shrink_memcg(memcg)) {
> +		if (shrink_memcg(memcg, 1)) {

Why 64 for the global limit but only 1 for the cgroup limit? That
seems arbitrary in multiple ways.

Direct reclaim, kswapd, proactive reclaim, cgroup limit reclaim use
SWAP_CLUSTER_MAX for the batch size near-universally. It's magic too
to be sure, but at least you wouldn't have to make up new magic?

Otherwise, the patch looks good to me.

