Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C5CCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048DE6B0088; Mon, 11 May 2026 04:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BEB6B0093; Mon, 11 May 2026 04:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51D46B0095; Mon, 11 May 2026 04:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D35E36B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:31:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0E80A0619
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:31:43 +0000 (UTC)
X-FDA: 84754470486.27.E8747E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD5E0100007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:31:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+NV15du;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekT/gbP4JMj6P+ztcq09DgH8Y9RlV2LLqTncRqeC5wY=;
	b=LlLtjuo2tlbUQTorS9gAs63bPdccWx4XRpYl4BREjnme1AA3X8uhBI/UoGV5OsHKdBsHr+
	fQzQyQIeUKAoDNdpL3Vgh2ocdW5fgaOALBGhqLiMVwNJhahMN8S9EhNzYbrXN+/qPBGU2v
	s2qkiHB0wOVCWsNgewmyaiv3OJYP2Vw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+NV15du;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778488301; a=rsa-sha256;
	cv=none;
	b=lTzraxutspTrakQ+9jubui9+y9tM2gGUM239J0Wfv6IlDnib1Jo0i7mEV+bYr3O510QjpQ
	CH/LB+xN6IVAyFWPQDUDIy1VBQmbrR/0POpsBbS5PwfeGxNHSa/eQDe7HOuxrNXElbJMWh
	l27BmZMgu629N64YnrNWP2lgnQxm4U0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 546CB6001A;
	Mon, 11 May 2026 08:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9EEC2BCB0;
	Mon, 11 May 2026 08:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488301;
	bh=W2ygD+/z3RlK3HF7zT5mQCUgbAvqMl8VdS2THByT95g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A+NV15duwlz6Ndqvdm4yPwCd4z9GzDWQ8L4aeo4shak/0LxcZJUH+ile8v5Wzuigb
	 LGQWBRY8et9jUhNZSeJergMJ0DiVoojpnzIioMQsBvJJe1LwmjFlzFOzQhU/LCALZD
	 l9ankpw9UUTZVHn4KiSrYXzI8E2KiZ7FSiw+qAiBZembo50ncEe89P6h5NgZwHP5Dq
	 Tg1ZG9EYhq9nm1MCIWXWAqKg2CnFb+79oAK7g4xz3eL4PmmNzLGqZsWL7wXhJ8wBZa
	 EnGM2aUHLHlS14Pt8GlSWf0/4/gjKBA4hntKPt5L378RytYha4qFu87gh1HLm1uthW
	 Q08x09X2Z7E5g==
Date: Mon, 11 May 2026 17:31:38 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <rz7dt4wghum6beghfgm6suqje6jeivrensojjalfis5zeuyen7@6bj7kfpqb4q5>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
 <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
 <afz7pZADZPD4mKJr@MacBook-Air.tail10959e.ts.net>
 <af3xcFjrZSZFG846@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3xcFjrZSZFG846@elver.google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD5E0100007
X-Stat-Signature: xspymgyohb9pbhh1njmry44xo816b6ak
X-HE-Tag: 1778488301-689310
X-HE-Meta: U2FsdGVkX18kxw00P/RzubuR1qU6F90rKP5fMrsDgG7Rq7CEMG5WDqtV4/YRp+0JScjRtEqDPBmJ6YkIi+pVpe1hFETX5VmzPXj6QPaAThhy3DwbNvUa4e2kfZU60IEN61kff75N2X7UH5bY4HBRyBO7uz2b2rq8RnZRy7Id9WT01C9qO7qk+l/EIEDEqp/Mx1iDIOUINwKj9G4Qr2pF2XGJUjC/nWPUiSoJAZXXkqxIWgvo951V8qf0bFsx0YttPSzVz68QMhmLdTNf47xB7b2+mfUzRWngVFwZZKsCB7ol2/t+/kMzxvfTvf7Lx4ku/8kzaO+wPlPMwXL9czVguzNl5ihGImPEJk6xulnGlxYp0qng9GvsfEYT/mIlIuf6QezJbm3ab67ncrDi3/IXgdT4yv9WZbpkgSwB9SjlnDFrqtCk71do7OKSoyNvz5FwVMOZtbU+tJf2yOTe8qW1lNi4ZnX9GPUplNYzO9cP72MTMkZiCZQQApnKjAkpovWCjIL8eFpWDgBDmYsuClAHKCyWGuOoW5GnDM2swAmfsso2uKPR8frg5ZVF6mLi0mKppJyncX583p0FFctyT1hth7/6LnYV/Vpo25hLlGKDOwAOqzj/XTEKkaa3HC5D1w/WQKcBgGr0YhgpJX+gejwD02Jb1Y9PrMIStpnmdC94Q6Kwc9wOUwKW0elH/lIXM3kt1SFu42G6lgk3JJwTLMiPFo6DkUsJtScZxTEltMmqKqb1aMjnaEjSgoMLzqV4HsGwiYuv5ISrFPUWphwscIv9jXofmd+fJm368bArOM92I/iGVryHHtj3AXkErFHh2xSS9WkuDXXZEqY7LmAyDlO45yyGtT3DdlcrZAvEC6w4VZHUfmKRdwQ+w6ta2OzFwyN3vtRoP9Xl7oaYe+X7Sd+nficiIPD/y3l3cG1AkDSIHQMAphGRYoh+C1MLevy0m4txt6pHYMCcvaaEIniNj17
 SYLsHY4b
 3KF0/Cc6ZY/gBLi0F7x91YnURjHu+37RlIAEwClDnpckFLG70F7pmM6jA8Qi3KrrPxPHAstH4ixhPGEPrMiw4I9bIqipSims71VAbq3UAr3jflqyxomMDzAhByvIQPS6wAic+jUrfW7XOqsdA2UbDB9hxUZWMjgy+olANPtUz/Azf/JuuNbeHnPYRV5chL8goCDiw/Ai81Nh/Sdrn2Kz3KU9KN2sm2COl/I4cSv1Zje6iUv6EeRtgY37ZC6xNc85e6A2m8pmYazpN7X0AC9Ff42fsJVTQPx07fmIWTXfxN2SmZ1wAvJMBuBwYVRTtFEuuOuWiKAnj6+FD/tmRq4GmyiI1FHDo78VsJCL34zOZP1se3eDJrNfy3Pehaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:21:36PM +0200, Marco Elver wrote:
> I think I have a solution for this mess, see below.
> 
> I would not send it as 1 series, but only include the slab changes (+
> instruction_pointer.h change to introduce _CODE_LOCATION_) as one
> series, to go through the slab tree. The rest of the patches would go to
> respective arch maintainers.

I'm assuming this will be a follow-up and reviewing patch 1
(and waiting for Jon's thuoghts on patch 2)

> diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> index aa0b3ffea935..dfe73aafddb8 100644
> --- a/include/linux/instruction_pointer.h
> +++ b/include/linux/instruction_pointer.h
> @@ -8,6 +8,30 @@
>  
>  #ifndef _THIS_IP_
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> +/*
> + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> + * and Clang [2]. In particular, the address of a label is only expected to be
> + * used with a computed goto.
> + *
> + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> + *   [2] https://github.com/llvm/llvm-project/issues/138272
> + *
> + * Mark it as broken, so that appropriate fallback options can be implemented
> + * for architectures that do not define their won _THIS_IP_.
> + */
> +#define HAS_BROKEN_THIS_IP
> +#endif

As long as _THIS_IP_ is broken on some arches, it cannot be used anyway
when in a general API that can be used by arbitrary users?

Is it something that can be fixed in all arches over time?

> +/*
> + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> + * which guarantees uniqueness and resolves to a constant address at link time,
> + * avoiding runtime overhead and compiler optimizations breaking it.
> + */
> +#ifdef HAS_BROKEN_THIS_IP
> +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })

Nice!

Yes, we don't really need the exact code location
for partitioning kmalloc caches.

IIRC lockdep does a similar thing to define lock classes (unique for
each lock init location)

> +#else
> +#define _CODE_LOCATION_ _THIS_IP_
>  #endif

Probably we don't need this fallback?

>  #endif /* _LINUX_INSTRUCTION_POINTER_H */
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 5e1249e36b0d..a4bf1585411f 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  typedef struct { unsigned long v; } kmalloc_token_t;
>  #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
>  extern unsigned long random_kmalloc_seed;
> -#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> +#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _CODE_LOCATION_ })
>  #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
>  #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
>  #endif

-- 
Cheers,
Harry / Hyeonggon

