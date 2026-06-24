Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37ABDCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18626B00A3; Wed, 24 Jun 2026 12:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE226B00A6; Wed, 24 Jun 2026 12:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF586B00A8; Wed, 24 Jun 2026 12:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86ACF6B00A3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:01:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB82A1C1EAE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:01:15 +0000 (UTC)
X-FDA: 84915270510.16.C4B96C4
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id D4FD340017
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:01:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ip/GCyla";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782316873;
	b=cr3mDecRZAffr5vnyFiHk6gq3akPb5d06W/UAi92c5ERrN3k+mAeQOavKfTF+tUQScW76G
	xaYVLRxkGkYu1uGWbud4R8JI8bpIaElkIARy5fA6l5JITIo0fqNk+LCtamDC0demcVjhd7
	JHDbEFAcugzoXSCIMNy9FkylpX5ShcU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782316873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0crqmBAoFv3Z4GgPIvpGFroTATsgJ+vxtDpZskBYhQ=;
	b=mLnKtc4LpCOuF26EsPJL8qQuLflRj2bN0q4VX0UzpVYk9xYuigq/WbBXlZ6fmk2ytuZ28B
	Bce9XvnsGCbrqi8UXx4PN9UUCJVxhZEX3FeekHa30Z301N7w1jKHuvcPFSbjsKOuUwVx09
	UWNN2dT0qfhqS3GUjcJHR8GLJyyLaO0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ip/GCyla";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5177d1ff061so326861cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:01:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782316873; cv=none;
        d=google.com; s=arc-20260327;
        b=BiWrRLWqv9FDMOtnm+RVVq7IDPh2SPAxG0zFkcVcQHPFLPjWJKIjewCU01CgbZ34ub
         H9M+naMj+nnH81QcXxSZCG3/3B1riTpgJGzkTp7Usx5UWiPYF/rw+9PcAdjMFVl2YVzQ
         AcX1WcGVBT6/K139JZDNvPHO3CCGjt8H//YqQFRjcH6bvxp6mK5hLRB7XyOx3UdNgGEb
         xLB2sPpirKFfS2dEV9pMcV8xJMpT5SyQslxWSjPMZv3O6wQQY5A51+zkvzAJlGXlh3yX
         1sHnyhqzvMsQ350NeSnu1BaKXOYD7QvoM5mKEgFni0jRtK9RRmPrI/L6ByA22IyTUzL8
         zkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m0crqmBAoFv3Z4GgPIvpGFroTATsgJ+vxtDpZskBYhQ=;
        fh=BA8mmuPV/XJgwrBKOJpa31aVyVyVEP5xSg2cybcAC3g=;
        b=qvCeIhFP8j4/rILJ5PDcE9YyVeDkEuiKz4PYjDC/ie6ZI5D/JJxbFFbiNTQOBd75aT
         4mRhAIGomaFN3inlVwzgW/zCiKSKMT75aLJhWwsFS0kbYOabqWmW72qTEg2oTmKKHHn7
         JFXyUprqtVW5vcXbeBhdDCsr1mMhclse4lLOawwu8mMFkM69W7deycRLTYyHyWBTYAW5
         GUwmSTmY39JYD9qrpgQmz3A0D+HRKIfVBez9uxkTZhhTZye/tMwqPeNXIkHoReEPv6j9
         CdY443iFkLq+S9rCm4vvLW7C+Fye/VIgOkY0Bn3J6gjqso5kJw2dHOHDceulSevQRkHk
         06gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782316873; x=1782921673; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m0crqmBAoFv3Z4GgPIvpGFroTATsgJ+vxtDpZskBYhQ=;
        b=Ip/GCylaV77nUfzUDq9oJUalOiI8wysgyu3/kdOnW5mqs2fMwmpN8468EzgE5udP7u
         w6e+3pmaH6HFK9PoHGT8XWlWNLHQxFHPNJM7rPUz2uzfRrFFPRtolP7vvU2EUVN2Yglv
         IFSeTM21a6bWTBlaAU8XGB26E3zO+Ye/w+SeB85nrJ0auNTRxhnBnQwwrULGl1FZUtoU
         vsYGwXnRGipbiWMRLfs4xtjpx5jX7cIEPaVFhObfbx71ee4m19Ehdhe50+f45d02U3Wq
         nqp0bEzNQlm/QeS5qDe05JrLi0x1OI+TT12I5gOz0BcaFIpu+oradVkQD75VNgJAknXt
         tufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316873; x=1782921673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m0crqmBAoFv3Z4GgPIvpGFroTATsgJ+vxtDpZskBYhQ=;
        b=dhTEuPJO3knWpVftm6J3BLsXBxcgivvECPLlbe2va872ezwHibRJnA6gTbWFpogbug
         AMq/jHJPpOahkTfduc/1Aoup22uhowcsBpSgWMLxPVJg6ZIMoh0Gn3zRk/m7XjGSgCGo
         PSOqjXx7rhvEZTu6sjERnP8xLxQzIq4cN5Z65uWI5InpWfTW6ktcNp5woM403oXSZzu3
         +Uy2EmFquexZknYO7cyKE4yXr7Gfpq9Lyml9Ug3s9yCV9+fPkW+kw5iF/7y5JB1NDBQ5
         bYRiT1zM6eHekjQj8be1WML3WEh9q/0Z7MyOjmSu21lh1nN9DDzcLNM7nEgKUD1Ep5to
         uUdQ==
X-Forwarded-Encrypted: i=1; AFNElJ9R/3a5M+dnJdteEFpcwM4U8VtanSEgGyv2yuP6z8MB27lwp69EMj3aaPlXAWBk+mz8pavdbjg5QQ==@kvack.org
X-Gm-Message-State: AOJu0YyZWMASyOYwAiTPsvzh9qXPKAmCTkYd8wrOxy1j2bTwiQgO+fGW
	hyG0LVWCkaHI+SFyL/oscc4q4a9zS7fxfBhJSgt9d+RrmyaltIsvLTWlaiTOvM0Rx7R8MsqkGG+
	59y4B6ysmv5a+7Adu5ozyHrIpe6sSv7dLnboXpJJf
X-Gm-Gg: AfdE7cm7jCyU0OAeSMXa70Z7qhJ+gX9rFr4wJrzIk4lVqa+LCoMyDjTYsiwvfavIEss
	LcmDRYEh3t4zN1LtDwyuOkggWYRmWJtUI8SsFJejm70w/ygx8+iUvmO7a0FRacujjZByTyDGPnk
	T9T1DExbASGcjS1zErt0phDZ6cwzjlXfu9Ge6w5Qz5wK86ScXmLD4nJLXc7Sk6qrdTTDY3FSiL8
	U36e/Blrc9w29bvpDwOHLTyTkD4t/kbmVgaS3gAVy4YeAKLYDlCH7dTEEQUOQxZh/8po/oN5ReR
	nykhQy3zVYqcFhW8Xf3m4yZpk/Q=
X-Received: by 2002:ac8:590b:0:b0:517:99ea:ab79 with SMTP id
 d75a77b69052e-51a628b1f04mr9806651cf.25.1782316870622; Wed, 24 Jun 2026
 09:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <20260622-alloc-trylock-v2-3-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-3-31f31367d420@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 09:00:59 -0700
X-Gm-Features: AVVi8Cdv6pKmxpEnI9xiasIPnPCK-jdZ5ALtkKByHZ7f_PzXa-QK82QrMcBFDDc
Message-ID: <CAJuCfpE28TqZy2k5-X1ZEdd0HhTuc5i7+0kyxX5nXH4j+5JVfw@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p5kb6shq1z4ux6edz6cgtcdf518cxwwo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4FD340017
X-HE-Tag: 1782316873-758084
X-HE-Meta: U2FsdGVkX1/OPG7pmGME27ZxnFMnx3OEix3e4XWqlITPa4zifKsQZKYwcUKcZc9bgOA/6YDcDzTknL32SeYirAQWG64/0twVykxankCWcqJqyye2KtsoLQ23Sc7n9QPdEKkBityPpYcYN/Kvx5HVfHcJqyrNgAh2g8rGFyQUH5tukmhnaDHIWREr6riFSdK1hgOY8JseNl5d5Xi6wV3SEiAR4xgaRrOIwYajjLBSYojnd7YWEf8xzOhRz7GzsAVrp/VT3b/3fi7msooXYlo4SntI7vLsPOPR7iObu6j0EWoS8ym840imZ0d7UdtjFSKHCZCQgb/kB4zw5EaDZ/dFibJ+ZKNmpaiT6nPNKGr26VnL+J+Y0oA8RaZaa20qa3GBwEFfkSMvhkTDFP4SP+cdqW/iGBpl8JwZFw1obzRTHCe/HE7iW14+EIabswNpxBT/YF3RjkH46wy35rqPvK3QgolqSMqCULtl0kd9tyXCM+qVnFc18I7X9BdpeJ7ClZ2ndodqUZ61l1VKHXsarIGx4Wndo2Wy8bpKGqf0jU2bH9OGS+e/Q5+wGdjLt6pfIOZ6TzIkMn6je7RwBf3XGuIDWRuVf8P/w2JxTU+V27jocFnXGWOYe0INS/et8m1/JEpt9wpJc86SBONxi51pbSx5xSB6xUaCUT0rdGDMPoGkveFRjhDJWxoleiTjnxdR16KVmSYnoValfHy3aNrUc/2lbGyy6kWPJHqN+cwq9wlCl6ndurElIvZWLLJwKYYTlBzKGcvv3+QLrhifqHvBMZNEfKa4DgX4TV6ci2yG8N+sJrqKvSJybGwi5xyVLMxi/xcZ179P21pznGntY8j2jv7sOT2ApoORtiHn8lTuqtPkTeuf8bhk14Za1JOEApbDBL/JW0nlWARYxKYXQr13neHmJlicyOeSbH1qpIywj9lx/fOpT34hrGL5UUtMROpKuDBQpJZqvZgu898EH+1VTuR
 nUsrB6Mp
 HhIDqNGNTxhmJrHaADtwNj5rS9Id76x8gZci89P84ajcVT6K7V52t9ULcumxfXIR7w4DP8qBfy9wk3r96qhtIIHdciumN/NBlCyphzQWiIfZLgWyx6ulcQ7NtDsdGreQ42iJtyGKearcUyyPVzRl1JPXJ4NhABxAeYwEghbCHBgfrohB+4NDd68FIl5J9O5y9kKjrQatD/hrROXKK2Q843awO6fGZy+VyUXDcZfQEDybVKUxL4J15gURjy1kHBBqrP5/36u7NConej8Nu15XyUsNGZQBCUWVcTkTz6lruUmptybUafEs3bocNEFA+Pyke0brdp8f5Qc2v8m+hboXEPKZJW8Uh2WDKKmIvdGe9J9nun2AD7SmqC+ZRNMWm629FEaZM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:02=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
> main entry point function is significantly different from the normal
> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>
> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
> exposed to mm/) and then turn the nolock variant into a thin wrapper
> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
> how some of the wrappers in gfp.h do).
>
> Rationale that this doesn't change anything:
>
> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>    gfp_trylock.
>
> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>    previously in the nolock variant:
>
>    a. Application of gfp_allowed_mask; this only affects early boot, and
>       only flags that affect the slowpath get changed here.
>
>    b. Application of current_gfp_context() - also only affects the
>       slowpath
>
> 3. The slowpath itself: this is now just explicitly skipped under
>    !ALLOC_TRYLOCK.
>
> Ulterior motive: adding an alloc_flags arg to the allocator's
> mm-internal entrypoint can later be used to do more allocation
> customisation without needing to create new GFP flags.

Looks like a nice overall cleanup.

>
> While adding this flag to a bunch of places, create ALLOC_DEFAULT to
> avoid a mysterious literal 0 in most places. alloc_frozen_pages_noprof()
> is defined above the alloc flags so just leave that as a slightly messy
> exception instead of trying to fully reorder mm/internal.h for that one
> case.

Moving the whole alloc_frozen_pages() block down seems simple enough
and would avoid special-casing this.

>
> No functional change intended.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/hugetlb.c    |   3 +-
>  mm/internal.h   |   8 ++-
>  mm/mempolicy.c  |  10 ++--
>  mm/page_alloc.c | 178 +++++++++++++++++++++++++++++---------------------=
------
>  mm/slub.c       |   6 +-
>  5 files changed, 110 insertions(+), 95 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835e..2ce6169ca0dfd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1806,7 +1806,8 @@ static struct folio *alloc_buddy_frozen_folio(int o=
rder, gfp_t gfp_mask,
>         if (alloc_try_hard)
>                 gfp_mask |=3D __GFP_RETRY_MAYFAIL;
>
> -       folio =3D (struct folio *)__alloc_frozen_pages(gfp_mask, order, n=
id, nmask);
> +       folio =3D (struct folio *)__alloc_frozen_pages(gfp_mask, order, n=
id, nmask,
> +                                                    ALLOC_DEFAULT);
>
>         /*
>          * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> diff --git a/mm/internal.h b/mm/internal.h
> index 1483a4fcdfce1..6bc89ec62e527 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -913,7 +913,7 @@ extern bool free_pages_prepare(struct page *page, uns=
igned int order);
>  extern int user_min_free_kbytes;
>
>  struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int =
nid,
> -               nodemask_t *);
> +               nodemask_t *, unsigned int alloc_flags);
>  #define __alloc_frozen_pages(...) \
>         alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>  void free_frozen_pages(struct page *page, unsigned int order);
> @@ -924,7 +924,8 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigne=
d int order);
>  #else
>  static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned=
 int order)
>  {
> -       return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NU=
LL);
> +       return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NU=
LL,
> +                                          0 /* ALLOC_DEFAULT */);
>  }
>  #endif
>
> @@ -1440,6 +1441,9 @@ extern void set_pageblock_order(void);
>  unsigned long reclaim_pages(struct list_head *folio_list);
>  unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>                                             struct list_head *folio_list)=
;
> +
> +
> +#define ALLOC_DEFAULT          0
>  /* The ALLOC_WMARK bits are used as an index to zone->watermark */
>  #define ALLOC_WMARK_MIN                WMARK_MIN
>  #define ALLOC_WMARK_LOW                WMARK_LOW
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c22..40bbea614aced 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2425,9 +2425,11 @@ static struct page *alloc_pages_preferred_many(gfp=
_t gfp, unsigned int order,
>          */
>         preferred_gfp =3D gfp | __GFP_NOWARN;
>         preferred_gfp &=3D ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> -       page =3D __alloc_frozen_pages_noprof(preferred_gfp, order, nid, n=
odemask);
> +       page =3D __alloc_frozen_pages_noprof(preferred_gfp, order, nid, n=
odemask,
> +                                          ALLOC_DEFAULT);
>         if (!page)
> -               page =3D __alloc_frozen_pages_noprof(gfp, order, nid, NUL=
L);
> +               page =3D __alloc_frozen_pages_noprof(gfp, order, nid, NUL=
L,
> +                                                  ALLOC_DEFAULT);
>
>         return page;
>  }
> @@ -2475,7 +2477,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, uns=
igned int order,
>                          */
>                         page =3D __alloc_frozen_pages_noprof(
>                                 gfp | __GFP_THISNODE | __GFP_NORETRY, ord=
er,
> -                               nid, NULL);
> +                               nid, NULL, ALLOC_DEFAULT);
>                         if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>                                 return page;
>                         /*
> @@ -2487,7 +2489,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, uns=
igned int order,
>                 }
>         }
>
> -       page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +       page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, A=
LLOC_DEFAULT);
>
>         if (unlikely(pol->mode =3D=3D MPOL_INTERLEAVE ||
>                      pol->mode =3D=3D MPOL_WEIGHTED_INTERLEAVE) && page) =
{
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bc05d75a41627..e31babe2181a1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5204,7 +5204,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>                 }
>                 nr_account++;
>
> -               prep_new_page(page, 0, gfp, 0);
> +               prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
>                 set_page_refcounted(page);
>                 page_array[nr_populated++] =3D page;
>         }
> @@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, un=
signed long nr_pages)
>         }
>  }
>
> -/*
> - * This is the 'heart' of the zoned buddy allocator.
> - */
> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> -               int preferred_nid, nodemask_t *nodemask)
> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
> +                                      unsigned int alloc_flags)
>  {
> -       struct page *page;
> -       unsigned int fastpath_alloc_flags =3D ALLOC_WMARK_LOW;
> -       gfp_t alloc_gfp; /* The gfp_t that was actually used for allocati=
on */
> -       struct alloc_context ac =3D { };
> +       if (alloc_flags & ALLOC_NOLOCK)
> +               return pcp_allowed_order(order);
>
>         /*
>          * There are several places where we assume that the order value =
is sane
>          * so bail out early if the request is out of bound.
>          */
> -       if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> +       return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
> +}
> +
> +static inline bool alloc_trylock_allowed(void)
> +{
> +       /*
> +        * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which i=
s
> +        * unsafe in NMI. If spin_trylock() is called from hard IRQ the c=
urrent
> +        * task may be waiting for one rt_spin_lock, but rt_spin_trylock(=
) will
> +        * mark the task as the owner of another rt_spin_lock which will
> +        * confuse PI logic, so return immediately if called from hard IR=
Q or
> +        * NMI.
> +        *
> +        * Note, irqs_disabled() case is ok. This function can be called
> +        * from raw_spin_lock_irqsave region.
> +        */
> +       if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> +               return false;
> +
> +       /* On UP, spin_trylock() always succeeds even when it is locked *=
/
> +       if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +               return false;
> +
> +       /* Bailout, since _deferred_grow_zone() needs to take a lock */
> +       if (deferred_pages_enabled())
> +               return false;
> +
> +       return true;
> +}
> +
> +/*
> + * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
> + *
> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowe=
d.
> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
> + * is not safe in arbitrary context.
> + *
> + * These two are the conditions for gfpflags_allow_spinning() being true=
.
> + *
> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reas=
on
> + * to warn. Also warn would trigger printk() which is unsafe from
> + * various contexts. We cannot use printk_deferred_enter() to mitigate,
> + * since the running context is unknown.
> + *
> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
> + * is safe in any context. Also zeroing the page is mandatory for
> + * BPF use cases.
> + *
> + * Though __GFP_NOMEMALLOC is not checked in the code path below,
> + * specify it here to highlight that alloc_pages_nolock()
> + * doesn't want to deplete reserves.
> + */
> +static const gfp_t gfp_nolock =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NOME=
MALLOC |
> +                               __GFP_COMP;

__alloc_frozen_pages_noprof() is the only user of gfp_nolock. Can we
move it into that function to limit its scope? (unless you plan to use
it elsewhere).

> +
> +/*
> + * This is the 'heart' of the zoned buddy allocator.
> + */
> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> +               int preferred_nid, nodemask_t *nodemask, unsigned int all=
oc_flags)
> +{
> +       struct page *page;
> +       gfp_t alloc_gfp; /* The gfp_t that was actually used for allocati=
on */
> +       struct alloc_context ac =3D { };
> +       unsigned int fastpath_alloc_flags =3D alloc_flags;
> +
> +       /* Other flags could be supported later if needed. */
> +       if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
>                 return NULL;
>
> +       if (!alloc_order_allowed(gfp, order, alloc_flags))
> +               return NULL;
> +
> +       if (alloc_flags & ALLOC_NOLOCK) {
> +               VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
> +               if (!alloc_trylock_allowed())
> +                       return NULL;
> +               gfp |=3D gfp_nolock;
> +       } else {
> +               fastpath_alloc_flags |=3D ALLOC_WMARK_LOW;
> +       }
> +
>         gfp &=3D gfp_allowed_mask;
>         /*
>          * Apply scoped allocation constraints. This is mainly about GFP_=
NOFS
> @@ -5291,9 +5365,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp,=
 unsigned int order,
>          */
>         fastpath_alloc_flags |=3D alloc_flags_nofragment(zonelist_zone(ac=
.preferred_zoneref), gfp);
>
> -       /* First allocation attempt */
> +       /* First allocation attempt (or, for nolock, only attempt) */
>         page =3D get_page_from_freelist(alloc_gfp, order, fastpath_alloc_=
flags, &ac);
> -       if (likely(page))
> +       if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
>                 goto out;
>
>         alloc_gfp =3D gfp;
> @@ -5310,7 +5384,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp,=
 unsigned int order,
>  out:
>         if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>             unlikely(__memcg_kmem_charge_page(page, gfp, order) !=3D 0)) =
{
> -               free_frozen_pages(page, order);
> +               __free_frozen_pages(page, order,
> +                                   alloc_flags & ALLOC_NOLOCK ? FPI_TRYL=
OCK : 0);
>                 page =3D NULL;
>         }
>
> @@ -5326,7 +5401,8 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsign=
ed int order,
>  {
>         struct page *page;
>
> -       page =3D __alloc_frozen_pages_noprof(gfp, order, preferred_nid, n=
odemask);
> +       page =3D __alloc_frozen_pages_noprof(gfp, order, preferred_nid, n=
odemask,
> +                                          ALLOC_DEFAULT);
>         if (page)
>                 set_page_refcounted(page);
>         return page;
> @@ -7856,80 +7932,10 @@ static bool __free_unaccepted(struct page *page)
>
>  struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, =
unsigned int order)
>  {
> -       /*
> -        * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not=
 allowed.
> -        * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of k=
swapd
> -        * is not safe in arbitrary context.
> -        *
> -        * These two are the conditions for gfpflags_allow_spinning() bei=
ng true.
> -        *
> -        * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not=
 a reason
> -        * to warn. Also warn would trigger printk() which is unsafe from
> -        * various contexts. We cannot use printk_deferred_enter() to mit=
igate,
> -        * since the running context is unknown.
> -        *
> -        * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page(=
) below
> -        * is safe in any context. Also zeroing the page is mandatory for
> -        * BPF use cases.
> -        *
> -        * Though __GFP_NOMEMALLOC is not checked in the code path below,
> -        * specify it here to highlight that alloc_pages_nolock()
> -        * doesn't want to deplete reserves.
> -        */
> -       gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC =
| __GFP_COMP
> -                       | gfp_flags;
> -       unsigned int alloc_flags =3D ALLOC_NOLOCK;
> -       struct alloc_context ac =3D { };
> -       struct page *page;
> -
> -       VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
> -       /*
> -        * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which i=
s
> -        * unsafe in NMI. If spin_trylock() is called from hard IRQ the c=
urrent
> -        * task may be waiting for one rt_spin_lock, but rt_spin_trylock(=
) will
> -        * mark the task as the owner of another rt_spin_lock which will
> -        * confuse PI logic, so return immediately if called from hard IR=
Q or
> -        * NMI.
> -        *
> -        * Note, irqs_disabled() case is ok. This function can be called
> -        * from raw_spin_lock_irqsave region.
> -        */
> -       if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -               return NULL;
> -
> -       /* On UP, spin_trylock() always succeeds even when it is locked *=
/
> -       if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> -               return NULL;
> -
> -       if (!pcp_allowed_order(order))
> -               return NULL;
> -
> -       /* Bailout, since _deferred_grow_zone() needs to take a lock */
> -       if (deferred_pages_enabled())
> -               return NULL;
> -
>         if (nid =3D=3D NUMA_NO_NODE)
>                 nid =3D numa_node_id();
>
> -       prepare_alloc_pages(alloc_gfp, order, nid, NULL, &ac,
> -                           &alloc_gfp, &alloc_flags);
> -
> -       /*
> -        * Best effort allocation from percpu free list.
> -        * If it's empty attempt to spin_trylock zone->lock.
> -        */
> -       page =3D get_page_from_freelist(alloc_gfp, order, alloc_flags, &a=
c);
> -
> -       /* Unlike regular alloc_pages() there is no __alloc_pages_slowpat=
h(). */
> -
> -       if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
> -           unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) !=
=3D 0)) {
> -               __free_frozen_pages(page, order, FPI_TRYLOCK);
> -               page =3D NULL;
> -       }
> -       trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
> -       kmsan_alloc_page(page, order, alloc_gfp);
> -       return page;
> +       return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, A=
LLOC_NOLOCK);
>  }
>  /**
>   * alloc_pages_nolock - opportunistic reentrant allocation from any cont=
ext
> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d0..b9c1284844a0a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3275,7 +3275,8 @@ static inline struct slab *alloc_slab_page(gfp_t fl=
ags, int node,
>         else if (node =3D=3D NUMA_NO_NODE)
>                 page =3D alloc_frozen_pages(flags, order);
>         else
> -               page =3D __alloc_frozen_pages(flags, order, node, NULL);
> +               page =3D __alloc_frozen_pages(flags, order, node, NULL,
> +                                           ALLOC_DEFAULT);
>
>         if (!page)
>                 return NULL;
> @@ -5236,7 +5237,8 @@ static void *___kmalloc_large_node(size_t size, gfp=
_t flags, int node)
>         if (node =3D=3D NUMA_NO_NODE)
>                 page =3D alloc_frozen_pages_noprof(flags, order);
>         else
> -               page =3D __alloc_frozen_pages_noprof(flags, order, node, =
NULL);
> +               page =3D __alloc_frozen_pages_noprof(flags, order, node, =
NULL,
> +                                                  ALLOC_DEFAULT);
>
>         if (page) {
>                 ptr =3D page_address(page);
>
> --
> 2.54.0
>
>

