Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246C6FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFA06B0095; Thu, 30 Apr 2026 09:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670076B0096; Thu, 30 Apr 2026 09:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ADDC6B0098; Thu, 30 Apr 2026 09:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 485246B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:09:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2846F40B0E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:03:50 +0000 (UTC)
X-FDA: 84715239462.11.E6269CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 20ACE160009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:03:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/GHjLbS";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfQpL6EKM0+8eTVY47jHkc1LHHZCVyDVrjFXUWXnmCA=;
	b=SLRkUNC9RuY5Rj6hJcJz9sPT82S16SiaORLqak3UhPGkYnVdDDSWPc2lTcP1aPrfhSxZO9
	CFuUkM+5Yio/6NYGSlEj7R/5V+RcIMMHEfyCnm6nFH4JrQ5faW/1RmIuKyFzMRRzEqiD7w
	DbfSKLbbbS3Q0PHi/iJ1wZq5xD00vRY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/GHjLbS";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554228; a=rsa-sha256;
	cv=none;
	b=cCsEP754VJ9HWsnowq8u8GE6NTWn6pvmyWOtmmdJUcLHvqwosDwI+i7Fh3zrShKvQGbuBC
	F8VbLRUh1yOXtellWqGt132af6v+Bhf1yP2JcBLd1NBeyH/3ZVSsu1XmWeX+RsIrq5KjTD
	Oc9dm+3auIkYpPdkNE/J1MzupprHngA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB96640440;
	Thu, 30 Apr 2026 13:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC1C2BCB3;
	Thu, 30 Apr 2026 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777554226;
	bh=cBQTATODAw7GU5owkTlr0LLrjvqtSjmzxEuiN88xSno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P/GHjLbSzFjFrlVHylyxgW146QEiVuSbq9zns8CvEtQWM6rfKglawHpEP2u9xPcYD
	 n3OBk3+Ewlgqev591zz+QCAQgiLG/qP61tXvzAfUfEQLwdQHwTwAU25Aj5LWtq0ssC
	 Py4+RuG35KzGqQGDwDYrQBdOVZdxd0CJdMkCftbMMRJ+Vn4lj8BMpYe90ygfYSWXhL
	 QBkmykY+5Edz3mfHgsWFepJ+dgw1c9jtCr9bUrTjjQDuGQo/DV+Ac3KfT2VPxfrHbG
	 MQEorLNtV9QSlJs1xBmN8laC9jqntUFj6tSOuoQZVm/5hfg77vKNKa3lfHUZSpajL8
	 F0h9gjQtxZnXA==
Message-ID: <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
Date: Thu, 30 Apr 2026 15:03:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Content-Language: en-US
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
 llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
 Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
 KP Singh <kpsingh@kernel.org>, Matteo Rizzo <matteorizzo@google.com>,
 GONG Ruiqi <gongruiqi1@huawei.com>
References: <20260424132427.2703076-1-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260424132427.2703076-1-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 20ACE160009
X-Rspamd-Server: rspam06
X-Stat-Signature: 6nfrwszbjoo5gbmos7x33gpxrdrqg8fa
X-HE-Tag: 1777554227-298412
X-HE-Meta: U2FsdGVkX19nAei+IHD9/BfUYYDMZ1buUCjmrUG4wSt67F+hZ0wKLOBb70LFZJ8QqFDfCc1GSvHIoZ0IKyVfxBK//BchS0REWX0FgnaSzaRpD4oh1tsQuBdz6vkEbKZQMTVumA7m6njDLmYACaherhbHfaVBfWCn5uIYJgysdp1K2aJDvhFPXr1of8sYlerdnAPCTZFEAPeQCEyd69CpVXItBqqFqXdqzt6+3TiwlBqtoAHSAjGW5VMxAgwcgihzGBLwGZ2gWvRXVz7twhUoEwDrDX2aLPMGfnJEg8IZpORjPuBquHHErqN6CCvweE/wBFaTkbcNPSr+M6Ey84msMbknOK3mw81ebbE5fGc3RHuDyAuPWpOKuT1xAmec6yLQVR0UmAVIgy8Vws2VgC4oJVlg8aANAosWqi2MR8gfRL3Tm1tnNhFBHQalwdXuk3pMnlTYiMw1ZCvZ2HCrNdtaPTHfgxTtKpXQjIEQkQ2taG5x4UVRvm1DT7WsI756o/zeKP7Ir2S3mzutk9oG34zbdeLVfw5pMfFWzsQXMzo620jI0B9KEov0L1Kqb7qoiM//+2xKkBTrPeGUyt4hqr9LlDoA47PdphPw/lm3P9Q39bIp738VLOpk8AFW8n+LFjZRqlshhnJD09OrveRxxBorD0XrTbcDPrF28qLADlJYOW9eXTR4WMYQEjZXtlX+QoS9McZc+2LY8BU/f120F8zQiJDk4LBjz30dg/94HsgC3auwL4cA95lHFblASN+sBJ8NZtUxfAC5xus8gK6jQDrDLvAuXRPc6VSW/EDH+NjcqEnPZ/PJYvxZQAGfDoml8R2BRMaxRGaMNbgp8qyI7amBZPoYBM3LxadnGCyXRFGnPO3M4txfSdeLlDgJnTmBG5ctDHKndHPk0Kgv9g8zzUwe0ics03WN4DJJ03VrO5GWNeLg+bsVR8Fp8i1mSCb0jSmjOgXhWRUef3dKXkUiFSR
 fXe/0B50
 2LtrG4Pxsz55MxnkePgXGgFtxZrJBd2Y5dzfuVgtgT8EYA3tVK+riDerX0hSehJplVoVqCTIPe901vsDc4JAI1sFTYxBkrD7mIDvvpSJMJAmYyK32m2EPjTZT5ydWPZ7Y/j5HM+IS2pP4cSPfNXrysqBCIdJKJ0mNbuB0t64E7BEOrY1t7fsKHx1rkmIJBJu0613iOe1i+saT31/Z4kOC4ACQhqnaUr0Ay8o3NCg+7oM1x4Tz+3imki4+DsnSFgb/n4DxnUqAolyigKAQ4svROJr0Ymmad/gbvj8OhpEZLXu2rPfc+kB/8s/psbgMcTCx+jyrq1YziHfUgwM3bgyMpAxzxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 15:24, Marco Elver wrote:

> @@ -938,7 +968,7 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
>   *	Try really hard to succeed the allocation but fail
>   *	eventually.
>   */
> -static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t flags)
> +static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
>  {
>  	if (__builtin_constant_p(size) && size) {
>  		unsigned int index;
> @@ -948,14 +978,16 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
>  
>  		index = kmalloc_index(size);
>  		return __kmalloc_cache_noprof(
> -				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
> +				kmalloc_caches[kmalloc_type(flags, token)][index],

While reviewing this, it occured to me we might have been using _RET_IP_
here in a suboptimal way ever since this was introduced. Since this is all
inlined, shouldn't have we been using _THIS_IP_ to really randomize using
the kmalloc() callsite, and not its parent?

And after this patch, we get the token passed to _kmalloc_noprof()...

>  				flags, size);
>  	}
> -	return __kmalloc_noprof(size, flags);
> +	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);

... and used also here for the non-constant-size, where previously
__kmalloc_noprof() (not inline function) would correctly use _RET_IP_ on its
own ...

>  }
> +#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))

... and the token comes from here. With random partitioning that's
#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })

so that AFAIK makes the situation worse as now the cases without constant
size also start randomizing by the parent callsite and not the kmalloc callsite.

But there are many users of __kmalloc_token() and maybe some are corrent in
using _RET_IP_, I haven't checked, maybe we'll need two variants, or further
change things around.

>  #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
>  
> -void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
> +void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node);
> +#define kmalloc_nolock_noprof(_s, _f, _n)	_kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _f, _n)
>  #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
>  
>  /**

<snip>

>  
> -#ifdef CONFIG_RANDOM_KMALLOC_CACHES
> -#define __KMALLOC_RANDOM_CONCAT(a, b) a ## b
> -#define KMALLOC_RANDOM_NAME(N, sz) __KMALLOC_RANDOM_CONCAT(KMA_RAND_, N)(sz)
> -#define KMA_RAND_1(sz)                  .name[KMALLOC_RANDOM_START +  1] = "kmalloc-rnd-01-" #sz,
> -#define KMA_RAND_2(sz)  KMA_RAND_1(sz)  .name[KMALLOC_RANDOM_START +  2] = "kmalloc-rnd-02-" #sz,
> -#define KMA_RAND_3(sz)  KMA_RAND_2(sz)  .name[KMALLOC_RANDOM_START +  3] = "kmalloc-rnd-03-" #sz,
> -#define KMA_RAND_4(sz)  KMA_RAND_3(sz)  .name[KMALLOC_RANDOM_START +  4] = "kmalloc-rnd-04-" #sz,
> -#define KMA_RAND_5(sz)  KMA_RAND_4(sz)  .name[KMALLOC_RANDOM_START +  5] = "kmalloc-rnd-05-" #sz,
> -#define KMA_RAND_6(sz)  KMA_RAND_5(sz)  .name[KMALLOC_RANDOM_START +  6] = "kmalloc-rnd-06-" #sz,
> -#define KMA_RAND_7(sz)  KMA_RAND_6(sz)  .name[KMALLOC_RANDOM_START +  7] = "kmalloc-rnd-07-" #sz,
> -#define KMA_RAND_8(sz)  KMA_RAND_7(sz)  .name[KMALLOC_RANDOM_START +  8] = "kmalloc-rnd-08-" #sz,
> -#define KMA_RAND_9(sz)  KMA_RAND_8(sz)  .name[KMALLOC_RANDOM_START +  9] = "kmalloc-rnd-09-" #sz,
> -#define KMA_RAND_10(sz) KMA_RAND_9(sz)  .name[KMALLOC_RANDOM_START + 10] = "kmalloc-rnd-10-" #sz,
> -#define KMA_RAND_11(sz) KMA_RAND_10(sz) .name[KMALLOC_RANDOM_START + 11] = "kmalloc-rnd-11-" #sz,
> -#define KMA_RAND_12(sz) KMA_RAND_11(sz) .name[KMALLOC_RANDOM_START + 12] = "kmalloc-rnd-12-" #sz,
> -#define KMA_RAND_13(sz) KMA_RAND_12(sz) .name[KMALLOC_RANDOM_START + 13] = "kmalloc-rnd-13-" #sz,
> -#define KMA_RAND_14(sz) KMA_RAND_13(sz) .name[KMALLOC_RANDOM_START + 14] = "kmalloc-rnd-14-" #sz,
> -#define KMA_RAND_15(sz) KMA_RAND_14(sz) .name[KMALLOC_RANDOM_START + 15] = "kmalloc-rnd-15-" #sz,
> -#else // CONFIG_RANDOM_KMALLOC_CACHES
> -#define KMALLOC_RANDOM_NAME(N, sz)
> +#ifdef CONFIG_KMALLOC_PARTITION_CACHES
> +#define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
> +#define KMALLOC_PARTITION_NAME(N, sz) __KMALLOC_PARTITION_CONCAT(KMA_PART_, N)(sz)
> +#define KMA_PART_1(sz)                  .name[KMALLOC_PARTITION_START +  1] = "kmalloc-part-01-" #sz,
> +#define KMA_PART_2(sz)  KMA_PART_1(sz)  .name[KMALLOC_PARTITION_START +  2] = "kmalloc-part-02-" #sz,
> +#define KMA_PART_3(sz)  KMA_PART_2(sz)  .name[KMALLOC_PARTITION_START +  3] = "kmalloc-part-03-" #sz,
> +#define KMA_PART_4(sz)  KMA_PART_3(sz)  .name[KMALLOC_PARTITION_START +  4] = "kmalloc-part-04-" #sz,
> +#define KMA_PART_5(sz)  KMA_PART_4(sz)  .name[KMALLOC_PARTITION_START +  5] = "kmalloc-part-05-" #sz,
> +#define KMA_PART_6(sz)  KMA_PART_5(sz)  .name[KMALLOC_PARTITION_START +  6] = "kmalloc-part-06-" #sz,
> +#define KMA_PART_7(sz)  KMA_PART_6(sz)  .name[KMALLOC_PARTITION_START +  7] = "kmalloc-part-07-" #sz,
> +#define KMA_PART_8(sz)  KMA_PART_7(sz)  .name[KMALLOC_PARTITION_START +  8] = "kmalloc-part-08-" #sz,
> +#define KMA_PART_9(sz)  KMA_PART_8(sz)  .name[KMALLOC_PARTITION_START +  9] = "kmalloc-part-09-" #sz,
> +#define KMA_PART_10(sz) KMA_PART_9(sz)  .name[KMALLOC_PARTITION_START + 10] = "kmalloc-part-10-" #sz,
> +#define KMA_PART_11(sz) KMA_PART_10(sz) .name[KMALLOC_PARTITION_START + 11] = "kmalloc-part-11-" #sz,
> +#define KMA_PART_12(sz) KMA_PART_11(sz) .name[KMALLOC_PARTITION_START + 12] = "kmalloc-part-12-" #sz,
> +#define KMA_PART_13(sz) KMA_PART_12(sz) .name[KMALLOC_PARTITION_START + 13] = "kmalloc-part-13-" #sz,
> +#define KMA_PART_14(sz) KMA_PART_13(sz) .name[KMALLOC_PARTITION_START + 14] = "kmalloc-part-14-" #sz,
> +#define KMA_PART_15(sz) KMA_PART_14(sz) .name[KMALLOC_PARTITION_START + 15] = "kmalloc-part-15-" #sz,
> +#else // CONFIG_KMALLOC_PARTITION_CACHES
> +#define KMALLOC_PARTITION_NAME(N, sz)
>  #endif

We're renaming the caches visible in /proc/slabinfo. Maybe it's fine as
people who care will just adapt their tools without complaining. Not the
first time we've changes something here.



