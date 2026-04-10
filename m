Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF365E99068
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AC16B0005; Fri, 10 Apr 2026 05:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B676B0089; Fri, 10 Apr 2026 05:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51136B008A; Fri, 10 Apr 2026 05:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3D056B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:51:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 555FAC1CD5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:51:14 +0000 (UTC)
X-FDA: 84642178068.28.B9AFFC2
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0829314000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:51:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EaWRdwuk;
	spf=pass (imf23.hostedemail.com: domain of gongruiqi1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YC5+Ls1swOHaWJ8ErNBeIulZ4tAA8sac7Dx5bn0SAs=;
	b=py0Ho68geq1NEDn8A1tcz52cVse4ajTox2h9GlnblqcCEJJmfyqfxIyy8cBJl5glhGE5Hj
	YPkic0AlnT0hp8LMt+UK0U7JiP618Vd1YwRZojKRICu9Yc+LXUK/265j3tjOP1ODJPc11b
	EDoh+hK+X2ZV4qTFUYQ/ZyjTQK18zRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814672; a=rsa-sha256;
	cv=none;
	b=hvqbZYgftPyA8+sHy8GM7u+e6UB+ssLwym2+6eAUKUNJbFrDkCpdVfnyHZuFpDWvAwNXHJ
	OwmhwrWMN43+KDtPgZ0nqg6KcL+qOP/b8X7oE6s4Hc/9II64Nlj6JWWitw2b9uTbU3vURQ
	kTXZ5GsBXzFe+WloY/1JA2SkD6OGR+U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EaWRdwuk;
	spf=pass (imf23.hostedemail.com: domain of gongruiqi1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9YC5+Ls1swOHaWJ8ErNBeIulZ4tAA8sac7Dx5bn0SAs=;
	b=EaWRdwukgWLF/ovt/GfYhXVnX9klWxHa038NdZau8kzA8ZAxqerDxQ/8SzCc4u9aMJzey1Qda
	2QXPpIswZbgspzkY/KgFpFHgDMv6EjcsNxAlP7CrMxlJJ1/+LSZc44wpRWJiouLTv9OUnyRr2Hi
	NNMJD569jlD1cmiZFSW0wiw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fsX2q2BcwzLlVQ;
	Fri, 10 Apr 2026 17:44:51 +0800 (CST)
Received: from kwepemk100018.china.huawei.com (unknown [7.202.194.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C8C3C40565;
	Fri, 10 Apr 2026 17:51:05 +0800 (CST)
Received: from [10.67.108.67] (10.67.108.67) by kwepemk100018.china.huawei.com
 (7.202.194.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 10 Apr
 2026 17:51:04 +0800
Message-ID: <69a902f1-3793-4c71-ac3c-27f8cd5eeef8@huawei.com>
Date: Fri, 10 Apr 2026 17:50:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Marco Elver <elver@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
CC: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
	<cl@gentwo.org>, Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Nick Desaulniers
	<nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, <linux-kbuild@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-hardening@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<llvm@lists.linux.dev>, Andrey Konovalov <andreyknvl@gmail.com>, Florent
 Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh
	<kpsingh@kernel.org>, Matteo Rizzo <matteorizzo@google.com>
References: <20260331111240.153913-1-elver@google.com>
Content-Language: en-US
From: GONG Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <20260331111240.153913-1-elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk100018.china.huawei.com (7.202.194.66)
X-Rspamd-Queue-Id: 0829314000B
X-Stat-Signature: dpt8huu1kousicf6z8km1xy37ajbnhfw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775814670-544117
X-HE-Meta: U2FsdGVkX1/F3SH0WjsT5Ok7n72xekX9XB5s5PCiZbzNlGu0bfy9RwRC9x7e0IZBHdAhTj7f/19jJVS7BfQP5u9AtyPFCNIfmGdzcT1XzI7QhVL5Kmj4TdgvxI9E/Nn39BVk9Y9hNKJbCjqut1qQ07oTM3iNsd6Nrzco7koZxIyp92uwoGZwIk/tjJ1UPzfRaSRvBw/bCaI84JeoQb+OHBCC4ytAy4sbib73Hb+eUEpJXgFDv8ZcuA4d1fmjRNPLvrA06Dz7JiWcjF0rfbQpvkUwFR/IkDD/cfd7rTJvg7slQN7x4IzuEKHwcB7VKQE4vZrU91l6fYjWv6S5ObU6bTwdcXhm+711xncvoQjAhdBxG3SZ8wqd5BBm8aff1JADB/ePePXcrTAxebOWU1YVZW0Ffha5X0X+g15tWndf6eWbesn/TrXx+P0+prRbAw3gfMFjCZOlDSXhvJy0Fkb4gU0rsOuSwHwZF33MmjmRHwrFyiLM33TjanueOrDHSklZqe7iLgSh37XuuUACCztqFbB7Ej/ymi5OxO12Fvkc1jn3DIBBqX1QjTS1onQ4eFFYS1KR13kwvjFlM3bbcN4hoSyo5uL02XE1tgCWswACWf4BiwxBkdjU+QGNLzs8nC3QusHKO9z8D4vx9pQ0WBTfhq/tOvI8L4GjfiTEb5BDeyYfYH6KkhA2x5Ul/oRKbmeNm5Ks33gv5a05piyZyEptq/E/F/6mILppVP+CvQQn7pR21Mu8C1fikew0Gv8IwoY4M4b4QQUmQOVzPtz8RkPH+EZLXGURT+5Bcsi/8y3dfsLFWolQClWZyvkKz2WxE6BN53y2t0c8/ev9DxNaHI7zWBFF1YycHeJqfk+i4wV+w+kpXVKsO1qNUbeiUgX4PjG1AzN330MeUgfc77lKQEBMNjSRI4KRjXWmsxTH9z2NybBvFwhZ1HWxcsHaDGp1zW2Od3qmonpjj2oDlc1/NUX
 JTWF9cuu
 5hotOjVVQAxipoqc5c5PgwT8vFE0fMab3haEFCqGIeSru/x+ilEvdvWQASaCWT5T7GaYlQgmgytUxJRH7HBwZlZ6KoudUSy3HB6eCtMGVbnIEXGggIQ8q/xuSCM6k3rVAcreTtt/P2KJ458A5PzTc5ILWZj+pwgPWT6YCkNA9Ihl0U3yQgjGuYEkzNwti990ehc7DJwynvGfBk1BBcZx622xj7g5gZ9veLeyUEbc0iISR2VF6Hey/0mfUouqimf8adc5oTW84Ap6DPNSxi9GaX3WFF3Mcjtv5ulYwmpN4beujT76BbTyBey9FxC8J8QerLBiM+apaoaKBcE4woWfF1GUd4Ly0x93R23Go3HPs/cQO3Px2DEQ9/Js6WqOqkqmpylqw6uc366sgeIadaZbZ5COAzr6CSZIRXwD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/31/2026 7:12 PM, Marco Elver wrote:
> ...
> @@ -662,9 +662,20 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
>  	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
>  	(IS_ENABLED(CONFIG_MEMCG) ? __GFP_ACCOUNT : 0))
>  
> +#ifdef CONFIG_RANDOM_KMALLOC_CACHES
>  extern unsigned long random_kmalloc_seed;
> +typedef struct { unsigned long ip; } kmalloc_token_t;
> +#define __kmalloc_token(...) ((kmalloc_token_t) { .ip = _RET_IP_ })
> +#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
> +typedef struct { unsigned long v; } kmalloc_token_t;
> +#define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })

One tiny suggestion: we could use the same name for kmalloc_token_t's
member in both cases, which would make the code a bit more concise.

Acked-by: GONG Ruiqi <gongruiqi1@huawei.com>

> +#else
> +/* no-op */
> +typedef struct {} kmalloc_token_t;
> +#define __kmalloc_token(...) ((kmalloc_token_t){})
> +#endif
>  
> -static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigned long caller)
> +static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, kmalloc_token_t token)
>  {
>  	/*
>  	 * The most common case is KMALLOC_NORMAL, so test for it
> @@ -672,9 +683,11 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigne
>  	 */
>  	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
>  #ifdef CONFIG_RANDOM_KMALLOC_CACHES
> -		/* RANDOM_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
> -		return KMALLOC_RANDOM_START + hash_64(caller ^ random_kmalloc_seed,
> -						      ilog2(RANDOM_KMALLOC_CACHES_NR + 1));
> +		/* PARTITION_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
> +		return KMALLOC_PARTITION_START + hash_64(token.ip ^ random_kmalloc_seed,
> +							 ilog2(PARTITION_KMALLOC_CACHES_NR + 1));
> +#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
> +		return KMALLOC_PARTITION_START + token.v;
>  #else
>  		return KMALLOC_NORMAL;
>  #endif
> ...

