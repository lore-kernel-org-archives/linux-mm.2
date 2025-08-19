Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04569CA0EE9
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839636B00ED; Tue, 19 Aug 2025 00:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811696B00EF; Tue, 19 Aug 2025 00:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8FB6B00F0; Tue, 19 Aug 2025 00:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 545A66B00ED
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:19:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8127160238
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:19:38 +0000 (UTC)
X-FDA: 83792203236.21.EB20CD8
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id F0F8940007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:19:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wLq3cPmN;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755577177; a=rsa-sha256;
	cv=none;
	b=5YdHce6Id4wpxgcNcBf5rKuExvcfzHiIDD/3yFngc+aQ5t3sPQrQpwvIit9khO4NxvHxX7
	EDj+0/xg+DMLVtP0tuF5Q6TvSlpNp7GKZbh5beZrQROfOeC/XWThP7h77uXyl1GrmgH2Ex
	b0rox4ngiR/kb7xt1xbFufPPXK8NetU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wLq3cPmN;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755577177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtQvR+r/1B+RY2SaV/3tyd2mFrbwanhaOhDf2mnCTgg=;
	b=ugtwNuyAVjeCk3VkjgA8MmWjGykkHr85yfVDPelEa4xvcW/7DdtUf3IumFVUJPKfZBSbKt
	3wHohYn13Rzkui7WDBxSxb5gdiQNkXM5DcUujcdUjaDhdZTI7FAbzK8RW62la7t7uHbWDs
	P0A/xKGxaskVKcnqH0ONQOJp/n+y3f8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b0bf04716aso151481cf.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755577176; x=1756181976; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtQvR+r/1B+RY2SaV/3tyd2mFrbwanhaOhDf2mnCTgg=;
        b=wLq3cPmNiuhJJ+B3PFz/zHCN5oTgvaPwcCoR7dLZEDA9sQehZQTjsz7V10zzysiBv2
         pNprl0Tc46KDPNdd2uo+xy1Txxi04UgXdW62Q2fpjoeSczu1XAzozY1umsvFrOrRAAbT
         e7t+Wl+bLtt7BIzEm5gxUY+S/Lrk/KKGP+axVWBqI8TDCwg4jM5DFDmMxo/gz0aApzwJ
         3yRfjxSJAHfPIELPzLkQ/MIS3nvT7dhSSR9b5jiCNxJyFMSnTNCypCgJa31m8aINny2g
         pCSwnH5a4HmlXQKoeoiv+EZHsp4NX8A9GzBUqfJjvZCTnOnaKrFqajgfdgj35jbxln1f
         ZDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755577176; x=1756181976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RtQvR+r/1B+RY2SaV/3tyd2mFrbwanhaOhDf2mnCTgg=;
        b=WFdkYTusjv+LHCKGPS16Bi+q9vAzeQcTGUEp1Yp5Qo/m8Ac3qk7XTIKJt682u988jH
         OzcTHNT7KeGzdxQkICVeDt/2GOh09+pKsOEuA15+QS776h3VIsOePvHC3DHLLqwNQpIN
         1JJKthYzZ3lHWzzcoTRGscFmUzcufNXfJYdYB/Xm5TSelKDLeJPc2JWpDxX999HyqBEF
         JyNkdHxQBodtcwQLU5wzgJd+MdixsarWdab3altiSwXT3a/yT6qIUbsEUROaleA83PEM
         7lL5tTQPL3uItr+cT2iWHTfiYe/R/8KK1peBmhq7bp7JnJNyWqW4zb/bqDrnpqpZ16qh
         U2ag==
X-Forwarded-Encrypted: i=1; AJvYcCXjYF6ZW58y3EZGXIu8EDE0ta5OmihEcLTioARtkNrlVKWq0iTOE395PXkyFSHydblAL3ruYyFLMg==@kvack.org
X-Gm-Message-State: AOJu0YzaP2PpinLcM/+q4h2rDzXgplvkBWM1AjWDXvD2VTGkWiKsjR8w
	tk8vPkYs+y5b55CtDNhJiUCuVzK/ycAgyPeI8gHOnPIjMnlI/59ybLfB2y7vKbI/FLLrmHrY4Bn
	sHIBfjXYddpFUJDCdQx7VphD2QfitiJIYQgCOXGFH
X-Gm-Gg: ASbGnctZNIxRH9edkmsm0tL8iZh038Z8AHRBmuKXR5NtmYHnozlqd19yRVZ7UFKO3iZ
	tQkKm1W93pWyKuLiG93vBGK7PFictTvB+F6BNzf71FZhrf/tO5/dZlAUDccfgOJ+vhUMkKc3Sqv
	QLht/NpsOO+nd9vS4kr0JpcvT5G5Zz+lbMhECEVzn/d83nCPmMBoqmFNZotOU7m3b/2GSZpEoH2
	L4o94UCdh2FXpdKkLkZTgo=
X-Google-Smtp-Source: AGHT+IE/MMrEwXrtrXpwd5NWme0SVt/1/Gn7UnQ6FdtdsnFs+oYuqBhKlvBrPCe7OGp+3lJ32hG+d0a+NMSTxCfPkqY=
X-Received: by 2002:a05:622a:144d:b0:4ae:d2cc:ad51 with SMTP id
 d75a77b69052e-4b286cd30bemr2192291cf.1.1755577175219; Mon, 18 Aug 2025
 21:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 Aug 2025 21:19:23 -0700
X-Gm-Features: Ac12FXyNJ4RTO2e8MwHd1kDL0-WUOKScquwSWOz5-2kn6gNdbPPfPE4d6mftxNA
Message-ID: <CAJuCfpG5+oJY0aaE3=VOGtRxEoCgjejg-WTqrXU0TffFQ+7TQA@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0F8940007
X-Stat-Signature: yyacf6dd1x9dsyp1ehrfgd5jk5kuajec
X-Rspam-User: 
X-HE-Tag: 1755577176-782508
X-HE-Meta: U2FsdGVkX1/sXQlaVxqQG3xZ9cOs4Vpo69TPDlFrvefbbkdW1CJw7mkI/ctCmu4hpFfLpoRG9k6dma+PtWxuize8+Iui7GpajqAqlLzcP2a25QFlSEOby+UVOMZNB+1VnSDLTKRBVyptHfOykf8/ZYPO/UPRS7lSDey/nh0fLTUZdSYhN/z2eaBsjsZnvDKRokjEAEWWWhzEGXHhC31jUEUl/zKAd55CpuTRr6VbaypUSmyrPWQ9Km4+qTPo1y+j2Busc/aqFAbRZkbY2Tslflhy5UFzda7MhHkYwkITLByZwRm+RXqiDmKQmsGu79wKQuCw9VmsgHYUv7sNMjJeUGODYwoISuCeVzXrJToE2f2LzqUvWUTOk3QxsjMbuvkaclpnKQ1e1pY7bwvNk6YmeGFHARz1kHG/lurD87h9MAXlfHXtS8Uul3SnsSBSVqCAbrRp4B6XOi1aZgAknZMA3SjwrGp10Qp3fPy0L69rhqwlv509Ug/tGeOTLw8PhCgX8P69k6nCrUd616brnigJm1d9nnFyVxyV0frvhiQR9btPI1bkEIvld5G8kDLjNaGv75c7yzUCP+6As2W3AIw6CHO1uf8rQOKu5Y6O4pGuHx632uMTGtxdrPhGsERjwgYNtAkyjPNMT6pbTKhhT0KFzlHAtu23dvx1kxpkK2wn/fyVnXw8IHI1SYCwWqL3kVYnHwRvFHPE8Eb9xjBXN7R9donwpRWkCfaP1WkMvgzzF1ckrkLLuxZWpqbj7DdH13QiRMkgpUcLXiCmNMT48BdgHKukryrbgrsoRTHBHgDiGez4VBDovhnkDFRQ0Nea/J+iaf1obJ4YUuwaSDRNArt94fs/70BTDUe7xBn0esMBbE+4bHedrXU7THs8sg6UA0e3p7jTlPlF6mXOcIJNFsX7TDl40q+mdOu9Bxt7S/6nWA2Bnr9VGw1p7FoaXEo54btDd40AQ57HlTAIK/FXUOo
 n7cV6s0L
 0KCNjK1+AmOVqdEHkh7cGGgfYoCbKXtT77VqejcdxF7Lej0e9k/F1+XmjSVpfsBx/Fz1LJj4z1XBFzIeQolfIBSiwb1IFbVYJY/icb4gve+GMCs7yAjsjzf44fmsV3nqGi+b2b89LxwMIKoaiWdShEJ8HMdPh0XBUMwYf9mzPZELZZtVM5Txy7TBYNNZdf2Wh7HMl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Specifying a non-zero value for a new struct kmem_cache_args field
> sheaf_capacity will setup a caching layer of percpu arrays called
> sheaves of given capacity for the created cache.
>
> Allocations from the cache will allocate via the percpu sheaves (main or
> spare) as long as they have no NUMA node preference. Frees will also
> put the object back into one of the sheaves.
>
> When both percpu sheaves are found empty during an allocation, an empty
> sheaf may be replaced with a full one from the per-node barn. If none
> are available and the allocation is allowed to block, an empty sheaf is
> refilled from slab(s) by an internal bulk alloc operation. When both
> percpu sheaves are full during freeing, the barn can replace a full one
> with an empty one, unless over a full sheaves limit. In that case a
> sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
> sheaves and barns is also wired to the existing cpu flushing and cache
> shrinking operations.
>
> The sheaves do not distinguish NUMA locality of the cached objects. If
> an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
> with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
> the sheaves are bypassed.
>
> The bulk operations exposed to slab users also try to utilize the
> sheaves as long as the necessary (full or empty) sheaves are available
> on the cpu or in the barn. Once depleted, they will fallback to bulk
> alloc/free to slabs directly to avoid double copying.
>
> The sheaf_capacity value is exported in sysfs for observability.
>
> Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
> count objects allocated or freed using the sheaves (and thus not
> counting towards the other alloc/free path counters). Counters
> sheaf_refill and sheaf_flush count objects filled or flushed from or to
> slab pages, and can be used to assess how effective the caching is. The
> refill and flush operations will also count towards the usual
> alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
> the backing slabs.  For barn operations, barn_get and barn_put count how
> many full sheaves were get from or put to the barn, the _fail variants
> count how many such requests could not be satisfied mainly  because the
> barn was either empty or full. While the barn also holds empty sheaves
> to make some operations easier, these are not as critical to mandate own
> counters.  Finally, there are sheaf_alloc/sheaf_free counters.
>
> Access to the percpu sheaves is protected by local_trylock() when
> potential callers include irq context, and local_lock() otherwise (such
> as when we already know the gfp flags allow blocking). The trylock
> failures should be rare and we can easily fallback. Each per-NUMA-node
> barn has a spin_lock.
>
> When slub_debug is enabled for a cache with sheaf_capacity also
> specified, the latter is ignored so that allocations and frees reach the
> slow path where debugging hooks are processed. Similarly, we ignore it
> with CONFIG_SLUB_TINY which prefers low memory usage to performance.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h |   31 ++
>  mm/slab.h            |    2 +
>  mm/slab_common.c     |    5 +-
>  mm/slub.c            | 1101 ++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  4 files changed, 1092 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index d5a8ab98035cf3e3d9043e3b038e1bebeff05b52..6cfd085907afb8fc6e502ff7a=
1a1830c52ff9125 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -335,6 +335,37 @@ struct kmem_cache_args {
>          * %NULL means no constructor.
>          */
>         void (*ctor)(void *);
> +       /**
> +        * @sheaf_capacity: Enable sheaves of given capacity for the cach=
e.
> +        *
> +        * With a non-zero value, allocations from the cache go through c=
aching
> +        * arrays called sheaves. Each cpu has a main sheaf that's always
> +        * present, and a spare sheaf thay may be not present. When both =
become

s/they/that


> +        * empty, there's an attempt to replace an empty sheaf with a ful=
l sheaf
> +        * from the per-node barn.
> +        *
> +        * When no full sheaf is available, and gfp flags allow blocking,=
 a
> +        * sheaf is allocated and filled from slab(s) using bulk allocati=
on.
> +        * Otherwise the allocation falls back to the normal operation
> +        * allocating a single object from a slab.
> +        *
> +        * Analogically when freeing and both percpu sheaves are full, th=
e barn
> +        * may replace it with an empty sheaf, unless it's over capacity.=
 In
> +        * that case a sheaf is bulk freed to slab pages.
> +        *
> +        * The sheaves do not enforce NUMA placement of objects, so alloc=
ations
> +        * via kmem_cache_alloc_node() with a node specified other than
> +        * NUMA_NO_NODE will bypass them.
> +        *
> +        * Bulk allocation and free operations also try to use the cpu sh=
eaves
> +        * and barn, but fallback to using slab pages directly.
> +        *
> +        * When slub_debug is enabled for the cache, the sheaf_capacity a=
rgument
> +        * is ignored.
> +        *
> +        * %0 means no sheaves will be created.
> +        */
> +       unsigned int sheaf_capacity;
>  };
>
>  struct kmem_cache *__kmem_cache_create_args(const char *name,
> diff --git a/mm/slab.h b/mm/slab.h
> index 05a21dc796e095e8db934564d559494cd81746ec..1980330c2fcb4a4613a7e4f7e=
fc78b349993fd89 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -259,6 +259,7 @@ struct kmem_cache {
>  #ifndef CONFIG_SLUB_TINY
>         struct kmem_cache_cpu __percpu *cpu_slab;
>  #endif
> +       struct slub_percpu_sheaves __percpu *cpu_sheaves;
>         /* Used for retrieving partial slabs, etc. */
>         slab_flags_t flags;
>         unsigned long min_partial;
> @@ -272,6 +273,7 @@ struct kmem_cache {
>         /* Number of per cpu partial slabs to keep around */
>         unsigned int cpu_partial_slabs;
>  #endif
> +       unsigned int sheaf_capacity;
>         struct kmem_cache_order_objects oo;
>
>         /* Allocation and freeing of slabs */
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index bfe7c40eeee1a01c175766935c1e3c0304434a53..e2b197e47866c30acdbd1fee4=
159f262a751c5a7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -163,6 +163,9 @@ int slab_unmergeable(struct kmem_cache *s)
>                 return 1;
>  #endif
>
> +       if (s->cpu_sheaves)
> +               return 1;
> +
>         /*
>          * We may have set a slab to be unmergeable during bootstrap.
>          */
> @@ -321,7 +324,7 @@ struct kmem_cache *__kmem_cache_create_args(const cha=
r *name,
>                     object_size - args->usersize < args->useroffset))
>                 args->usersize =3D args->useroffset =3D 0;
>
> -       if (!args->usersize)
> +       if (!args->usersize && !args->sheaf_capacity)
>                 s =3D __kmem_cache_alias(name, object_size, args->align, =
flags,
>                                        args->ctor);
>         if (s)
> diff --git a/mm/slub.c b/mm/slub.c
> index 31e11ef256f90ad8a21d6b090f810f4c991a68d6..6543aaade60b0adaab232b225=
6d65c1042c62e1c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -346,8 +346,10 @@ static inline void debugfs_slab_add(struct kmem_cach=
e *s) { }
>  #endif
>
>  enum stat_item {
> +       ALLOC_PCS,              /* Allocation from percpu sheaf */
>         ALLOC_FASTPATH,         /* Allocation from cpu slab */
>         ALLOC_SLOWPATH,         /* Allocation by getting a new cpu slab *=
/
> +       FREE_PCS,               /* Free to percpu sheaf */
>         FREE_FASTPATH,          /* Free to cpu slab */
>         FREE_SLOWPATH,          /* Freeing not to cpu slab */
>         FREE_FROZEN,            /* Freeing to frozen slab */
> @@ -372,6 +374,14 @@ enum stat_item {
>         CPU_PARTIAL_FREE,       /* Refill cpu partial on free */
>         CPU_PARTIAL_NODE,       /* Refill cpu partial from node partial *=
/
>         CPU_PARTIAL_DRAIN,      /* Drain cpu partial to node partial */
> +       SHEAF_FLUSH,            /* Objects flushed from a sheaf */
> +       SHEAF_REFILL,           /* Objects refilled to a sheaf */
> +       SHEAF_ALLOC,            /* Allocation of an empty sheaf */
> +       SHEAF_FREE,             /* Freeing of an empty sheaf */
> +       BARN_GET,               /* Got full sheaf from barn */
> +       BARN_GET_FAIL,          /* Failed to get full sheaf from barn */
> +       BARN_PUT,               /* Put full sheaf to barn */
> +       BARN_PUT_FAIL,          /* Failed to put full sheaf to barn */
>         NR_SLUB_STAT_ITEMS
>  };
>
> @@ -418,6 +428,33 @@ void stat_add(const struct kmem_cache *s, enum stat_=
item si, int v)
>  #endif
>  }
>
> +#define MAX_FULL_SHEAVES       10
> +#define MAX_EMPTY_SHEAVES      10
> +
> +struct node_barn {
> +       spinlock_t lock;
> +       struct list_head sheaves_full;
> +       struct list_head sheaves_empty;
> +       unsigned int nr_full;
> +       unsigned int nr_empty;
> +};
> +
> +struct slab_sheaf {
> +       union {
> +               struct rcu_head rcu_head;
> +               struct list_head barn_list;
> +       };
> +       unsigned int size;
> +       void *objects[];
> +};
> +
> +struct slub_percpu_sheaves {
> +       local_trylock_t lock;
> +       struct slab_sheaf *main; /* never NULL when unlocked */
> +       struct slab_sheaf *spare; /* empty or full, may be NULL */
> +       struct node_barn *barn;
> +};
> +
>  /*
>   * The slab lists for all objects.
>   */
> @@ -430,6 +467,7 @@ struct kmem_cache_node {
>         atomic_long_t total_objects;
>         struct list_head full;
>  #endif
> +       struct node_barn *barn;
>  };
>
>  static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int=
 node)
> @@ -453,12 +491,19 @@ static inline struct kmem_cache_node *get_node(stru=
ct kmem_cache *s, int node)
>   */
>  static nodemask_t slab_nodes;
>
> -#ifndef CONFIG_SLUB_TINY
>  /*
>   * Workqueue used for flush_cpu_slab().
>   */
>  static struct workqueue_struct *flushwq;
> -#endif
> +
> +struct slub_flush_work {
> +       struct work_struct work;
> +       struct kmem_cache *s;
> +       bool skip;
> +};
> +
> +static DEFINE_MUTEX(flush_lock);
> +static DEFINE_PER_CPU(struct slub_flush_work, slub_flush);
>
>  /********************************************************************
>   *                     Core slab cache functions
> @@ -2437,6 +2482,359 @@ static void *setup_object(struct kmem_cache *s, v=
oid *object)
>         return object;
>  }
>
> +static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t =
gfp)
> +{
> +       struct slab_sheaf *sheaf =3D kzalloc(struct_size(sheaf, objects,
> +                                       s->sheaf_capacity), gfp);
> +
> +       if (unlikely(!sheaf))
> +               return NULL;
> +
> +       stat(s, SHEAF_ALLOC);
> +
> +       return sheaf;
> +}
> +
> +static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sh=
eaf)
> +{
> +       kfree(sheaf);
> +
> +       stat(s, SHEAF_FREE);
> +}
> +
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +                                  size_t size, void **p);
> +
> +
> +static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
> +                        gfp_t gfp)
> +{
> +       int to_fill =3D s->sheaf_capacity - sheaf->size;
> +       int filled;
> +
> +       if (!to_fill)
> +               return 0;
> +
> +       filled =3D __kmem_cache_alloc_bulk(s, gfp, to_fill,
> +                                        &sheaf->objects[sheaf->size]);
> +
> +       sheaf->size +=3D filled;
> +
> +       stat_add(s, SHEAF_REFILL, filled);
> +
> +       if (filled < to_fill)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +
> +static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t g=
fp)
> +{
> +       struct slab_sheaf *sheaf =3D alloc_empty_sheaf(s, gfp);
> +
> +       if (!sheaf)
> +               return NULL;
> +
> +       if (refill_sheaf(s, sheaf, gfp)) {
> +               free_empty_sheaf(s, sheaf);
> +               return NULL;
> +       }
> +
> +       return sheaf;
> +}
> +
> +/*
> + * Maximum number of objects freed during a single flush of main pcs she=
af.
> + * Translates directly to an on-stack array size.
> + */
> +#define PCS_BATCH_MAX  32U
> +
> +static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, vo=
id **p);
> +
> +/*
> + * Free all objects from the main sheaf. In order to perform
> + * __kmem_cache_free_bulk() outside of cpu_sheaves->lock, work in batche=
s where
> + * object pointers are moved to a on-stack array under the lock. To boun=
d the
> + * stack usage, limit each batch to PCS_BATCH_MAX.
> + *
> + * returns true if at least partially flushed
> + */
> +static bool sheaf_flush_main(struct kmem_cache *s)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +       unsigned int batch, remaining;
> +       void *objects[PCS_BATCH_MAX];
> +       struct slab_sheaf *sheaf;
> +       bool ret =3D false;
> +
> +next_batch:
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               return ret;
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +       sheaf =3D pcs->main;
> +
> +       batch =3D min(PCS_BATCH_MAX, sheaf->size);
> +
> +       sheaf->size -=3D batch;
> +       memcpy(objects, sheaf->objects + sheaf->size, batch * sizeof(void=
 *));
> +
> +       remaining =3D sheaf->size;
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       __kmem_cache_free_bulk(s, batch, &objects[0]);
> +
> +       stat_add(s, SHEAF_FLUSH, batch);
> +
> +       ret =3D true;
> +
> +       if (remaining)
> +               goto next_batch;
> +
> +       return ret;
> +}
> +
> +/*
> + * Free all objects from a sheaf that's unused, i.e. not linked to any
> + * cpu_sheaves, so we need no locking and batching. The locking is also =
not
> + * necessary when flushing cpu's sheaves (both spare and main) during cp=
u
> + * hotremove as the cpu is not executing anymore.
> + */
> +static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *=
sheaf)
> +{
> +       if (!sheaf->size)
> +               return;
> +
> +       stat_add(s, SHEAF_FLUSH, sheaf->size);
> +
> +       __kmem_cache_free_bulk(s, sheaf->size, &sheaf->objects[0]);
> +
> +       sheaf->size =3D 0;
> +}
> +
> +/*
> + * Caller needs to make sure migration is disabled in order to fully flu=
sh
> + * single cpu's sheaves
> + *
> + * must not be called from an irq
> + *
> + * flushing operations are rare so let's keep it simple and flush to sla=
bs
> + * directly, skipping the barn
> + */
> +static void pcs_flush_all(struct kmem_cache *s)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +       struct slab_sheaf *spare;
> +
> +       local_lock(&s->cpu_sheaves->lock);
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       spare =3D pcs->spare;
> +       pcs->spare =3D NULL;
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       if (spare) {
> +               sheaf_flush_unused(s, spare);
> +               free_empty_sheaf(s, spare);
> +       }
> +
> +       sheaf_flush_main(s);
> +}
> +
> +static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +
> +       pcs =3D per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +       /* The cpu is not executing anymore so we don't need pcs->lock */
> +       sheaf_flush_unused(s, pcs->main);
> +       if (pcs->spare) {
> +               sheaf_flush_unused(s, pcs->spare);
> +               free_empty_sheaf(s, pcs->spare);
> +               pcs->spare =3D NULL;
> +       }
> +}
> +
> +static void pcs_destroy(struct kmem_cache *s)
> +{
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               struct slub_percpu_sheaves *pcs;
> +
> +               pcs =3D per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +               /* can happen when unwinding failed create */
> +               if (!pcs->main)
> +                       continue;
> +
> +               /*
> +                * We have already passed __kmem_cache_shutdown() so ever=
ything
> +                * was flushed and there should be no objects allocated f=
rom
> +                * slabs, otherwise kmem_cache_destroy() would have abort=
ed.
> +                * Therefore something would have to be really wrong if t=
he
> +                * warnings here trigger, and we should rather leave obje=
cts and
> +                * sheaves to leak in that case.
> +                */
> +
> +               WARN_ON(pcs->spare);
> +
> +               if (!WARN_ON(pcs->main->size)) {
> +                       free_empty_sheaf(s, pcs->main);
> +                       pcs->main =3D NULL;
> +               }
> +       }
> +
> +       free_percpu(s->cpu_sheaves);
> +       s->cpu_sheaves =3D NULL;
> +}
> +
> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
> +{
> +       struct slab_sheaf *empty =3D NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       if (barn->nr_empty) {
> +               empty =3D list_first_entry(&barn->sheaves_empty,
> +                                        struct slab_sheaf, barn_list);
> +               list_del(&empty->barn_list);
> +               barn->nr_empty--;
> +       }
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +
> +       return empty;
> +}
> +
> +/*
> + * The following two functions are used mainly in cases where we have to=
 undo an
> + * intended action due to a race or cpu migration. Thus they do not chec=
k the
> + * empty or full sheaf limits for simplicity.
> + */
> +
> +static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_she=
af *sheaf)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       list_add(&sheaf->barn_list, &barn->sheaves_empty);
> +       barn->nr_empty++;
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +}
> +
> +static void barn_put_full_sheaf(struct node_barn *barn, struct slab_shea=
f *sheaf)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       list_add(&sheaf->barn_list, &barn->sheaves_full);
> +       barn->nr_full++;
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +}
> +
> +/*
> + * If a full sheaf is available, return it and put the supplied empty on=
e to
> + * barn. We ignore the limit on empty sheaves as the number of sheaves d=
oesn't
> + * change.
> + */
> +static struct slab_sheaf *
> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empt=
y)
> +{
> +       struct slab_sheaf *full =3D NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       if (barn->nr_full) {
> +               full =3D list_first_entry(&barn->sheaves_full, struct sla=
b_sheaf,
> +                                       barn_list);
> +               list_del(&full->barn_list);
> +               list_add(&empty->barn_list, &barn->sheaves_empty);
> +               barn->nr_full--;
> +               barn->nr_empty++;
> +       }
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +
> +       return full;
> +}

nit: missing new line

> +/*
> + * If an empty sheaf is available, return it and put the supplied full o=
ne to
> + * barn. But if there are too many full sheaves, reject this with -E2BIG=
.
> + */
> +static struct slab_sheaf *
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +{
> +       struct slab_sheaf *empty;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       if (barn->nr_full >=3D MAX_FULL_SHEAVES) {
> +               empty =3D ERR_PTR(-E2BIG);
> +       } else if (!barn->nr_empty) {
> +               empty =3D ERR_PTR(-ENOMEM);
> +       } else {
> +               empty =3D list_first_entry(&barn->sheaves_empty, struct s=
lab_sheaf,
> +                                        barn_list);
> +               list_del(&empty->barn_list);
> +               list_add(&full->barn_list, &barn->sheaves_full);
> +               barn->nr_empty--;
> +               barn->nr_full++;
> +       }
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +
> +       return empty;
> +}
> +
> +static void barn_init(struct node_barn *barn)
> +{
> +       spin_lock_init(&barn->lock);
> +       INIT_LIST_HEAD(&barn->sheaves_full);
> +       INIT_LIST_HEAD(&barn->sheaves_empty);
> +       barn->nr_full =3D 0;
> +       barn->nr_empty =3D 0;
> +}
> +
> +static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
> +{
> +       struct list_head empty_list;
> +       struct list_head full_list;
> +       struct slab_sheaf *sheaf, *sheaf2;
> +       unsigned long flags;
> +
> +       INIT_LIST_HEAD(&empty_list);
> +       INIT_LIST_HEAD(&full_list);
> +
> +       spin_lock_irqsave(&barn->lock, flags);
> +
> +       list_splice_init(&barn->sheaves_full, &full_list);
> +       barn->nr_full =3D 0;
> +       list_splice_init(&barn->sheaves_empty, &empty_list);
> +       barn->nr_empty =3D 0;
> +
> +       spin_unlock_irqrestore(&barn->lock, flags);
> +
> +       list_for_each_entry_safe(sheaf, sheaf2, &full_list, barn_list) {
> +               sheaf_flush_unused(s, sheaf);
> +               free_empty_sheaf(s, sheaf);
> +       }
> +
> +       list_for_each_entry_safe(sheaf, sheaf2, &empty_list, barn_list)
> +               free_empty_sheaf(s, sheaf);
> +}
> +
>  /*
>   * Slab allocation and freeing
>   */
> @@ -3312,11 +3710,42 @@ static inline void __flush_cpu_slab(struct kmem_c=
ache *s, int cpu)
>         put_partials_cpu(s, c);
>  }
>
> -struct slub_flush_work {
> -       struct work_struct work;
> -       struct kmem_cache *s;
> -       bool skip;
> -};
> +static inline void flush_this_cpu_slab(struct kmem_cache *s)
> +{
> +       struct kmem_cache_cpu *c =3D this_cpu_ptr(s->cpu_slab);
> +
> +       if (c->slab)
> +               flush_slab(s, c);
> +
> +       put_partials(s);
> +}
> +
> +static bool has_cpu_slab(int cpu, struct kmem_cache *s)
> +{
> +       struct kmem_cache_cpu *c =3D per_cpu_ptr(s->cpu_slab, cpu);
> +
> +       return c->slab || slub_percpu_partial(c);
> +}
> +
> +#else /* CONFIG_SLUB_TINY */
> +static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
> +static inline bool has_cpu_slab(int cpu, struct kmem_cache *s) { return =
false; }
> +static inline void flush_this_cpu_slab(struct kmem_cache *s) { }
> +#endif /* CONFIG_SLUB_TINY */
> +
> +static bool has_pcs_used(int cpu, struct kmem_cache *s)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +
> +       if (!s->cpu_sheaves)
> +               return false;
> +
> +       pcs =3D per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +       return (pcs->spare || pcs->main->size);
> +}
> +
> +static void pcs_flush_all(struct kmem_cache *s);
>
>  /*
>   * Flush cpu slab.
> @@ -3326,30 +3755,18 @@ struct slub_flush_work {
>  static void flush_cpu_slab(struct work_struct *w)
>  {
>         struct kmem_cache *s;
> -       struct kmem_cache_cpu *c;
>         struct slub_flush_work *sfw;
>
>         sfw =3D container_of(w, struct slub_flush_work, work);
>
>         s =3D sfw->s;
> -       c =3D this_cpu_ptr(s->cpu_slab);
>
> -       if (c->slab)
> -               flush_slab(s, c);
> +       if (s->cpu_sheaves)
> +               pcs_flush_all(s);
>
> -       put_partials(s);
> +       flush_this_cpu_slab(s);
>  }
>
> -static bool has_cpu_slab(int cpu, struct kmem_cache *s)
> -{
> -       struct kmem_cache_cpu *c =3D per_cpu_ptr(s->cpu_slab, cpu);
> -
> -       return c->slab || slub_percpu_partial(c);
> -}
> -
> -static DEFINE_MUTEX(flush_lock);
> -static DEFINE_PER_CPU(struct slub_flush_work, slub_flush);
> -
>  static void flush_all_cpus_locked(struct kmem_cache *s)
>  {
>         struct slub_flush_work *sfw;
> @@ -3360,7 +3777,7 @@ static void flush_all_cpus_locked(struct kmem_cache=
 *s)
>
>         for_each_online_cpu(cpu) {
>                 sfw =3D &per_cpu(slub_flush, cpu);
> -               if (!has_cpu_slab(cpu, s)) {
> +               if (!has_cpu_slab(cpu, s) && !has_pcs_used(cpu, s)) {
>                         sfw->skip =3D true;
>                         continue;
>                 }
> @@ -3396,19 +3813,15 @@ static int slub_cpu_dead(unsigned int cpu)
>         struct kmem_cache *s;
>
>         mutex_lock(&slab_mutex);
> -       list_for_each_entry(s, &slab_caches, list)
> +       list_for_each_entry(s, &slab_caches, list) {
>                 __flush_cpu_slab(s, cpu);
> +               if (s->cpu_sheaves)
> +                       __pcs_flush_all_cpu(s, cpu);
> +       }
>         mutex_unlock(&slab_mutex);
>         return 0;
>  }
>
> -#else /* CONFIG_SLUB_TINY */
> -static inline void flush_all_cpus_locked(struct kmem_cache *s) { }
> -static inline void flush_all(struct kmem_cache *s) { }
> -static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
> -static inline int slub_cpu_dead(unsigned int cpu) { return 0; }
> -#endif /* CONFIG_SLUB_TINY */
> -
>  /*
>   * Check if the objects in a per cpu structure fit numa
>   * locality expectations.
> @@ -4158,6 +4571,199 @@ bool slab_post_alloc_hook(struct kmem_cache *s, s=
truct list_lru *lru,
>         return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
>  }
>
> +static struct slub_percpu_sheaves *
> +__pcs_handle_empty(struct kmem_cache *s, struct slub_percpu_sheaves *pcs=
, gfp_t gfp)

The naming is a bit ambiguous IMO. Maybe __pcs_replace_empty_main() ?

> +{
> +       struct slab_sheaf *empty =3D NULL;
> +       struct slab_sheaf *full;
> +       bool can_alloc;
> +

Can we add lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock))?
More for documentation purposes than anything else.

> +       if (pcs->spare && pcs->spare->size > 0) {
> +               swap(pcs->main, pcs->spare);
> +               return pcs;
> +       }
> +
> +       full =3D barn_replace_empty_sheaf(pcs->barn, pcs->main);
> +
> +       if (full) {
> +               stat(s, BARN_GET);
> +               pcs->main =3D full;
> +               return pcs;
> +       }
> +
> +       stat(s, BARN_GET_FAIL);
> +
> +       can_alloc =3D gfpflags_allow_blocking(gfp);
> +
> +       if (can_alloc) {
> +               if (pcs->spare) {
> +                       empty =3D pcs->spare;
> +                       pcs->spare =3D NULL;
> +               } else {
> +                       empty =3D barn_get_empty_sheaf(pcs->barn);
> +               }
> +       }
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       if (!can_alloc)
> +               return NULL;
> +
> +       if (empty) {
> +               if (!refill_sheaf(s, empty, gfp)) {
> +                       full =3D empty;
> +               } else {
> +                       /*
> +                        * we must be very low on memory so don't bother
> +                        * with the barn
> +                        */
> +                       free_empty_sheaf(s, empty);
> +               }
> +       } else {
> +               full =3D alloc_full_sheaf(s, gfp);
> +       }
> +
> +       if (!full)
> +               return NULL;
> +
> +       /*
> +        * we can reach here only when gfpflags_allow_blocking
> +        * so this must not be an irq
> +        */
> +       local_lock(&s->cpu_sheaves->lock);
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       /*
> +        * If we are returning empty sheaf, we either got it from the
> +        * barn or had to allocate one. If we are returning a full
> +        * sheaf, it's due to racing or being migrated to a different
> +        * cpu. Breaching the barn's sheaf limits should be thus rare
> +        * enough so just ignore them to simplify the recovery.
> +        */
> +
> +       if (pcs->main->size =3D=3D 0) {
> +               barn_put_empty_sheaf(pcs->barn, pcs->main);
> +               pcs->main =3D full;
> +               return pcs;
> +       }
> +
> +       if (!pcs->spare) {
> +               pcs->spare =3D full;
> +               return pcs;
> +       }
> +
> +       if (pcs->spare->size =3D=3D 0) {
> +               barn_put_empty_sheaf(pcs->barn, pcs->spare);
> +               pcs->spare =3D full;
> +               return pcs;
> +       }
> +
> +       barn_put_full_sheaf(pcs->barn, full);
> +       stat(s, BARN_PUT);
> +
> +       return pcs;
> +}
> +
> +static __fastpath_inline
> +void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +       void *object;
> +
> +#ifdef CONFIG_NUMA
> +       if (static_branch_unlikely(&strict_numa)) {
> +               if (current->mempolicy)
> +                       return NULL;
> +       }
> +#endif
> +
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               return NULL;
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       if (unlikely(pcs->main->size =3D=3D 0)) {
> +               pcs =3D __pcs_handle_empty(s, pcs, gfp);
> +               if (unlikely(!pcs))
> +                       return NULL;
> +       }
> +
> +       object =3D pcs->main->objects[--pcs->main->size];
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       stat(s, ALLOC_PCS);
> +
> +       return object;
> +}
> +
> +static __fastpath_inline
> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void=
 **p)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +       struct slab_sheaf *main;
> +       unsigned int allocated =3D 0;
> +       unsigned int batch;
> +
> +next_batch:
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               return allocated;
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       if (unlikely(pcs->main->size =3D=3D 0)) {
> +
> +               struct slab_sheaf *full;
> +
> +               if (pcs->spare && pcs->spare->size > 0) {
> +                       swap(pcs->main, pcs->spare);
> +                       goto do_alloc;
> +               }
> +
> +               full =3D barn_replace_empty_sheaf(pcs->barn, pcs->main);
> +
> +               if (full) {
> +                       stat(s, BARN_GET);
> +                       pcs->main =3D full;
> +                       goto do_alloc;
> +               }
> +
> +               stat(s, BARN_GET_FAIL);
> +
> +               local_unlock(&s->cpu_sheaves->lock);
> +
> +               /*
> +                * Once full sheaves in barn are depleted, let the bulk
> +                * allocation continue from slab pages, otherwise we woul=
d just
> +                * be copying arrays of pointers twice.
> +                */
> +               return allocated;
> +       }
> +
> +do_alloc:
> +
> +       main =3D pcs->main;
> +       batch =3D min(size, main->size);
> +
> +       main->size -=3D batch;
> +       memcpy(p, main->objects + main->size, batch * sizeof(void *));
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       stat_add(s, ALLOC_PCS, batch);
> +
> +       allocated +=3D batch;
> +
> +       if (batch < size) {
> +               p +=3D batch;
> +               size -=3D batch;
> +               goto next_batch;
> +       }
> +
> +       return allocated;
> +}
> +
> +
>  /*
>   * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_al=
loc)
>   * have the fastpath folded into their functions. So no function call
> @@ -4182,7 +4788,11 @@ static __fastpath_inline void *slab_alloc_node(str=
uct kmem_cache *s, struct list
>         if (unlikely(object))
>                 goto out;
>
> -       object =3D __slab_alloc_node(s, gfpflags, node, addr, orig_size);
> +       if (s->cpu_sheaves && node =3D=3D NUMA_NO_NODE)
> +               object =3D alloc_from_pcs(s, gfpflags);
> +
> +       if (!object)
> +               object =3D __slab_alloc_node(s, gfpflags, node, addr, ori=
g_size);
>
>         maybe_wipe_obj_freeptr(s, object);
>         init =3D slab_want_init_on_alloc(gfpflags, s);
> @@ -4554,6 +5164,274 @@ static void __slab_free(struct kmem_cache *s, str=
uct slab *slab,
>         discard_slab(s, slab);
>  }
>
> +/*
> + * pcs is locked. We should have get rid of the spare sheaf and obtained=
 an
> + * empty sheaf, while the main sheaf is full. We want to install the emp=
ty sheaf
> + * as a main sheaf, and make the current main sheaf a spare sheaf.
> + *
> + * However due to having relinquished the cpu_sheaves lock when obtainin=
g
> + * the empty sheaf, we need to handle some unlikely but possible cases.
> + *
> + * If we put any sheaf to barn here, it's because we were interrupted or=
 have
> + * been migrated to a different cpu, which should be rare enough so just=
 ignore
> + * the barn's limits to simplify the handling.
> + *
> + * An alternative scenario that gets us here is when we fail
> + * barn_replace_full_sheaf(), because there's no empty sheaf available i=
n the
> + * barn, so we had to allocate it by alloc_empty_sheaf(). But because we=
 saw the
> + * limit on full sheaves was not exceeded, we assume it didn't change an=
d just
> + * put the full sheaf there.
> + */
> +static void __pcs_install_empty_sheaf(struct kmem_cache *s,
> +               struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty=
)
> +{

lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock))

> +       /* This is what we expect to find if nobody interrupted us. */
> +       if (likely(!pcs->spare)) {
> +               pcs->spare =3D pcs->main;
> +               pcs->main =3D empty;
> +               return;
> +       }
> +
> +       /*
> +        * Unlikely because if the main sheaf had space, we would have ju=
st
> +        * freed to it. Get rid of our empty sheaf.
> +        */
> +       if (pcs->main->size < s->sheaf_capacity) {
> +               barn_put_empty_sheaf(pcs->barn, empty);
> +               return;
> +       }
> +
> +       /* Also unlikely for the same reason/ */
> +       if (pcs->spare->size < s->sheaf_capacity) {
> +               swap(pcs->main, pcs->spare);
> +               barn_put_empty_sheaf(pcs->barn, empty);
> +               return;
> +       }
> +
> +       /*
> +        * We probably failed barn_replace_full_sheaf() due to no empty s=
heaf
> +        * available there, but we allocated one, so finish the job.
> +        */
> +       barn_put_full_sheaf(pcs->barn, pcs->main);
> +       stat(s, BARN_PUT);
> +       pcs->main =3D empty;
> +}
> +

IIUC s->cpu_sheaves->lock is locked when we enter __pcs_handle_full(),
it is still locked if this function returns a valid object and it's
unlocked if NULL gets returned. A comment clarifying these locking
rules would be great.

> +static struct slub_percpu_sheaves *
> +__pcs_handle_full(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)

__pcs_replace_full_main() ?

> +{
> +       struct slab_sheaf *empty;
> +       bool put_fail;

lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock))

> +
> +restart:
> +       put_fail =3D false;
> +
> +       if (!pcs->spare) {
> +               empty =3D barn_get_empty_sheaf(pcs->barn);
> +               if (empty) {
> +                       pcs->spare =3D pcs->main;
> +                       pcs->main =3D empty;
> +                       return pcs;
> +               }
> +               goto alloc_empty;
> +       }
> +
> +       if (pcs->spare->size < s->sheaf_capacity) {
> +               swap(pcs->main, pcs->spare);
> +               return pcs;
> +       }
> +
> +       empty =3D barn_replace_full_sheaf(pcs->barn, pcs->main);
> +
> +       if (!IS_ERR(empty)) {
> +               stat(s, BARN_PUT);
> +               pcs->main =3D empty;
> +               return pcs;
> +       }
> +
> +       if (PTR_ERR(empty) =3D=3D -E2BIG) {
> +               /* Since we got here, spare exists and is full */
> +               struct slab_sheaf *to_flush =3D pcs->spare;
> +
> +               stat(s, BARN_PUT_FAIL);
> +
> +               pcs->spare =3D NULL;
> +               local_unlock(&s->cpu_sheaves->lock);
> +
> +               sheaf_flush_unused(s, to_flush);
> +               empty =3D to_flush;
> +               goto got_empty;
> +       }
> +
> +       /*
> +        * We could not replace full sheaf because barn had no empty
> +        * sheaves. We can still allocate it and put the full sheaf in
> +        * __pcs_install_empty_sheaf(), but if we fail to allocate it,
> +        * make sure to count the fail.
> +        */
> +       put_fail =3D true;
> +
> +alloc_empty:
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       empty =3D alloc_empty_sheaf(s, GFP_NOWAIT);
> +       if (empty)
> +               goto got_empty;
> +
> +       if (put_fail)
> +                stat(s, BARN_PUT_FAIL);
> +
> +       if (!sheaf_flush_main(s))
> +               return NULL;
> +
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               return NULL;
> +
> +       /*
> +        * we flushed the main sheaf so it should be empty now,
> +        * but in case we got preempted or migrated, we need to
> +        * check again
> +        */
> +       if (pcs->main->size =3D=3D s->sheaf_capacity)
> +               goto restart;
> +
> +       return pcs;
> +
> +got_empty:
> +       if (!local_trylock(&s->cpu_sheaves->lock)) {
> +               barn_put_empty_sheaf(pcs->barn, empty);
> +               return NULL;
> +       }
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +       __pcs_install_empty_sheaf(s, pcs, empty);
> +
> +       return pcs;
> +}
> +
> +/*
> + * Free an object to the percpu sheaves.
> + * The object is expected to have passed slab_free_hook() already.
> + */
> +static __fastpath_inline
> +bool free_to_pcs(struct kmem_cache *s, void *object)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               return false;
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       if (unlikely(pcs->main->size =3D=3D s->sheaf_capacity)) {
> +
> +               pcs =3D __pcs_handle_full(s, pcs);
> +               if (unlikely(!pcs))
> +                       return false;
> +       }
> +
> +       pcs->main->objects[pcs->main->size++] =3D object;
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       stat(s, FREE_PCS);
> +
> +       return true;
> +}
> +
> +/*
> + * Bulk free objects to the percpu sheaves.
> + * Unlike free_to_pcs() this includes the calls to all necessary hooks
> + * and the fallback to freeing to slab pages.
> + */
> +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p=
)
> +{
> +       struct slub_percpu_sheaves *pcs;
> +       struct slab_sheaf *main, *empty;
> +       unsigned int batch, i =3D 0;
> +       bool init;
> +
> +       init =3D slab_want_init_on_free(s);
> +
> +       while (i < size) {
> +               struct slab *slab =3D virt_to_slab(p[i]);
> +
> +               memcg_slab_free_hook(s, slab, p + i, 1);
> +               alloc_tagging_slab_free_hook(s, slab, p + i, 1);
> +
> +               if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> +                       p[i] =3D p[--size];
> +                       if (!size)
> +                               return;
> +                       continue;
> +               }
> +
> +               i++;
> +       }
> +
> +next_batch:
> +       if (!local_trylock(&s->cpu_sheaves->lock))
> +               goto fallback;
> +
> +       pcs =3D this_cpu_ptr(s->cpu_sheaves);
> +
> +       if (likely(pcs->main->size < s->sheaf_capacity))
> +               goto do_free;
> +
> +       if (!pcs->spare) {
> +               empty =3D barn_get_empty_sheaf(pcs->barn);
> +               if (!empty)
> +                       goto no_empty;
> +
> +               pcs->spare =3D pcs->main;
> +               pcs->main =3D empty;
> +               goto do_free;
> +       }
> +
> +       if (pcs->spare->size < s->sheaf_capacity) {
> +               swap(pcs->main, pcs->spare);
> +               goto do_free;
> +       }
> +
> +       empty =3D barn_replace_full_sheaf(pcs->barn, pcs->main);
> +       if (IS_ERR(empty)) {
> +               stat(s, BARN_PUT_FAIL);
> +               goto no_empty;
> +       }
> +
> +       stat(s, BARN_PUT);
> +       pcs->main =3D empty;
> +
> +do_free:
> +       main =3D pcs->main;
> +       batch =3D min(size, s->sheaf_capacity - main->size);
> +
> +       memcpy(main->objects + main->size, p, batch * sizeof(void *));
> +       main->size +=3D batch;
> +
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       stat_add(s, FREE_PCS, batch);
> +
> +       if (batch < size) {
> +               p +=3D batch;
> +               size -=3D batch;
> +               goto next_batch;
> +       }
> +
> +       return;
> +
> +no_empty:
> +       local_unlock(&s->cpu_sheaves->lock);
> +
> +       /*
> +        * if we depleted all empty sheaves in the barn or there are too
> +        * many full sheaves, free the rest to slab pages
> +        */
> +fallback:
> +       __kmem_cache_free_bulk(s, size, p);
> +}
> +
>  #ifndef CONFIG_SLUB_TINY
>  /*
>   * Fastpath with forced inlining to produce a kfree and kmem_cache_free =
that
> @@ -4640,7 +5518,10 @@ void slab_free(struct kmem_cache *s, struct slab *=
slab, void *object,
>         memcg_slab_free_hook(s, slab, &object, 1);
>         alloc_tagging_slab_free_hook(s, slab, &object, 1);
>
> -       if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), f=
alse)))
> +       if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s)=
, false)))
> +               return;
> +
> +       if (!s->cpu_sheaves || !free_to_pcs(s, object))
>                 do_slab_free(s, slab, object, object, 1, addr);
>  }
>
> @@ -5236,6 +6117,15 @@ void kmem_cache_free_bulk(struct kmem_cache *s, si=
ze_t size, void **p)
>         if (!size)
>                 return;
>
> +       /*
> +        * freeing to sheaves is so incompatible with the detached freeli=
st so
> +        * once we go that way, we have to do everything differently
> +        */
> +       if (s && s->cpu_sheaves) {
> +               free_to_pcs_bulk(s, size, p);
> +               return;
> +       }
> +
>         do {
>                 struct detached_freelist df;
>
> @@ -5354,7 +6244,7 @@ static int __kmem_cache_alloc_bulk(struct kmem_cach=
e *s, gfp_t flags,
>  int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size=
_t size,
>                                  void **p)
>  {
> -       int i;
> +       unsigned int i =3D 0;
>
>         if (!size)
>                 return 0;
> @@ -5363,9 +6253,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache=
 *s, gfp_t flags, size_t size,
>         if (unlikely(!s))
>                 return 0;
>
> -       i =3D __kmem_cache_alloc_bulk(s, flags, size, p);
> -       if (unlikely(i =3D=3D 0))
> -               return 0;
> +       if (s->cpu_sheaves)
> +               i =3D alloc_from_pcs_bulk(s, size, p);
> +
> +       if (i < size) {
> +               /*
> +                * If we ran out of memory, don't bother with freeing bac=
k to
> +                * the percpu sheaves, we have bigger problems.
> +                */
> +               if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, =
p + i) =3D=3D 0)) {
> +                       if (i > 0)
> +                               __kmem_cache_free_bulk(s, i, p);
> +                       return 0;
> +               }
> +       }
>
>         /*
>          * memcg and kmem_cache debug support and memory initialization.
> @@ -5375,11 +6276,11 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cach=
e *s, gfp_t flags, size_t size,
>                     slab_want_init_on_alloc(flags, s), s->object_size))) =
{
>                 return 0;
>         }
> -       return i;
> +
> +       return size;
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
>
> -
>  /*
>   * Object placement in a slab is made very easy because we always start =
at
>   * offset 0. If we tune the size of the object to the alignment then we =
can
> @@ -5513,7 +6414,7 @@ static inline int calculate_order(unsigned int size=
)
>  }
>
>  static void
> -init_kmem_cache_node(struct kmem_cache_node *n)
> +init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
>  {
>         n->nr_partial =3D 0;
>         spin_lock_init(&n->list_lock);
> @@ -5523,6 +6424,9 @@ init_kmem_cache_node(struct kmem_cache_node *n)
>         atomic_long_set(&n->total_objects, 0);
>         INIT_LIST_HEAD(&n->full);
>  #endif
> +       n->barn =3D barn;
> +       if (barn)
> +               barn_init(barn);
>  }
>
>  #ifndef CONFIG_SLUB_TINY
> @@ -5553,6 +6457,30 @@ static inline int alloc_kmem_cache_cpus(struct kme=
m_cache *s)
>  }
>  #endif /* CONFIG_SLUB_TINY */
>
> +static int init_percpu_sheaves(struct kmem_cache *s)
> +{
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               struct slub_percpu_sheaves *pcs;
> +               int nid;
> +
> +               pcs =3D per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +               local_trylock_init(&pcs->lock);
> +
> +               nid =3D cpu_to_mem(cpu);
> +
> +               pcs->barn =3D get_node(s, nid)->barn;
> +               pcs->main =3D alloc_empty_sheaf(s, GFP_KERNEL);
> +
> +               if (!pcs->main)
> +                       return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
>  static struct kmem_cache *kmem_cache_node;
>
>  /*
> @@ -5588,7 +6516,7 @@ static void early_kmem_cache_node_alloc(int node)
>         slab->freelist =3D get_freepointer(kmem_cache_node, n);
>         slab->inuse =3D 1;
>         kmem_cache_node->node[node] =3D n;
> -       init_kmem_cache_node(n);
> +       init_kmem_cache_node(n, NULL);
>         inc_slabs_node(kmem_cache_node, node, slab->objects);
>
>         /*
> @@ -5604,6 +6532,13 @@ static void free_kmem_cache_nodes(struct kmem_cach=
e *s)
>         struct kmem_cache_node *n;
>
>         for_each_kmem_cache_node(s, node, n) {
> +               if (n->barn) {
> +                       WARN_ON(n->barn->nr_full);
> +                       WARN_ON(n->barn->nr_empty);
> +                       kfree(n->barn);
> +                       n->barn =3D NULL;
> +               }
> +
>                 s->node[node] =3D NULL;
>                 kmem_cache_free(kmem_cache_node, n);
>         }
> @@ -5612,6 +6547,8 @@ static void free_kmem_cache_nodes(struct kmem_cache=
 *s)
>  void __kmem_cache_release(struct kmem_cache *s)
>  {
>         cache_random_seq_destroy(s);
> +       if (s->cpu_sheaves)
> +               pcs_destroy(s);
>  #ifndef CONFIG_SLUB_TINY
>         free_percpu(s->cpu_slab);
>  #endif
> @@ -5624,20 +6561,29 @@ static int init_kmem_cache_nodes(struct kmem_cach=
e *s)
>
>         for_each_node_mask(node, slab_nodes) {
>                 struct kmem_cache_node *n;
> +               struct node_barn *barn =3D NULL;
>
>                 if (slab_state =3D=3D DOWN) {
>                         early_kmem_cache_node_alloc(node);
>                         continue;
>                 }
> +
> +               if (s->cpu_sheaves) {
> +                       barn =3D kmalloc_node(sizeof(*barn), GFP_KERNEL, =
node);
> +
> +                       if (!barn)
> +                               return 0;
> +               }
> +
>                 n =3D kmem_cache_alloc_node(kmem_cache_node,
>                                                 GFP_KERNEL, node);
> -
>                 if (!n) {
> -                       free_kmem_cache_nodes(s);

Why do you skip free_kmem_cache_nodes() here?


> +                       kfree(barn);
>                         return 0;
>                 }
>
> -               init_kmem_cache_node(n);
> +               init_kmem_cache_node(n, barn);
> +
>                 s->node[node] =3D n;
>         }
>         return 1;
> @@ -5894,6 +6840,8 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>         flush_all_cpus_locked(s);
>         /* Attempt to free all objects */
>         for_each_kmem_cache_node(s, node, n) {
> +               if (n->barn)
> +                       barn_shrink(s, n->barn);
>                 free_partial(s, n);
>                 if (n->nr_partial || node_nr_slabs(n))
>                         return 1;
> @@ -6097,6 +7045,9 @@ static int __kmem_cache_do_shrink(struct kmem_cache=
 *s)
>                 for (i =3D 0; i < SHRINK_PROMOTE_MAX; i++)
>                         INIT_LIST_HEAD(promote + i);
>
> +               if (n->barn)
> +                       barn_shrink(s, n->barn);
> +
>                 spin_lock_irqsave(&n->list_lock, flags);
>
>                 /*
> @@ -6209,12 +7160,24 @@ static int slab_mem_going_online_callback(void *a=
rg)
>          */
>         mutex_lock(&slab_mutex);
>         list_for_each_entry(s, &slab_caches, list) {
> +               struct node_barn *barn =3D NULL;
> +
>                 /*
>                  * The structure may already exist if the node was previo=
usly
>                  * onlined and offlined.
>                  */
>                 if (get_node(s, nid))
>                         continue;
> +
> +               if (s->cpu_sheaves) {
> +                       barn =3D kmalloc_node(sizeof(*barn), GFP_KERNEL, =
nid);
> +
> +                       if (!barn) {
> +                               ret =3D -ENOMEM;
> +                               goto out;
> +                       }
> +               }
> +
>                 /*
>                  * XXX: kmem_cache_alloc_node will fallback to other node=
s
>                  *      since memory is not yet available from the node t=
hat
> @@ -6222,10 +7185,13 @@ static int slab_mem_going_online_callback(void *a=
rg)
>                  */
>                 n =3D kmem_cache_alloc(kmem_cache_node, GFP_KERNEL);
>                 if (!n) {
> +                       kfree(barn);
>                         ret =3D -ENOMEM;
>                         goto out;
>                 }
> -               init_kmem_cache_node(n);
> +
> +               init_kmem_cache_node(n, barn);
> +
>                 s->node[nid] =3D n;
>         }
>         /*
> @@ -6444,6 +7410,17 @@ int do_kmem_cache_create(struct kmem_cache *s, con=
st char *name,
>
>         set_cpu_partial(s);
>
> +       if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
> +                                       && !(s->flags & SLAB_DEBUG_FLAGS)=
) {
> +               s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_sheave=
s);
> +               if (!s->cpu_sheaves) {
> +                       err =3D -ENOMEM;
> +                       goto out;
> +               }
> +               // TODO: increase capacity to grow slab_sheaf up to next =
kmalloc size?
> +               s->sheaf_capacity =3D args->sheaf_capacity;
> +       }
> +
>  #ifdef CONFIG_NUMA
>         s->remote_node_defrag_ratio =3D 1000;
>  #endif
> @@ -6460,6 +7437,12 @@ int do_kmem_cache_create(struct kmem_cache *s, con=
st char *name,
>         if (!alloc_kmem_cache_cpus(s))
>                 goto out;
>
> +       if (s->cpu_sheaves) {
> +               err =3D init_percpu_sheaves(s);
> +               if (err)
> +                       goto out;
> +       }
> +
>         err =3D 0;
>
>         /* Mutex is not taken during early boot */
> @@ -6481,7 +7464,6 @@ int do_kmem_cache_create(struct kmem_cache *s, cons=
t char *name,
>                 __kmem_cache_release(s);
>         return err;
>  }
> -
>  #ifdef SLAB_SUPPORTS_SYSFS
>  static int count_inuse(struct slab *slab)
>  {
> @@ -6912,6 +7894,12 @@ static ssize_t order_show(struct kmem_cache *s, ch=
ar *buf)
>  }
>  SLAB_ATTR_RO(order);
>
> +static ssize_t sheaf_capacity_show(struct kmem_cache *s, char *buf)
> +{
> +       return sysfs_emit(buf, "%u\n", s->sheaf_capacity);
> +}
> +SLAB_ATTR_RO(sheaf_capacity);
> +
>  static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
>  {
>         return sysfs_emit(buf, "%lu\n", s->min_partial);
> @@ -7259,8 +8247,10 @@ static ssize_t text##_store(struct kmem_cache *s, =
               \
>  }                                                              \
>  SLAB_ATTR(text);                                               \
>
> +STAT_ATTR(ALLOC_PCS, alloc_cpu_sheaf);
>  STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
>  STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
> +STAT_ATTR(FREE_PCS, free_cpu_sheaf);
>  STAT_ATTR(FREE_FASTPATH, free_fastpath);
>  STAT_ATTR(FREE_SLOWPATH, free_slowpath);
>  STAT_ATTR(FREE_FROZEN, free_frozen);
> @@ -7285,6 +8275,14 @@ STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
>  STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
>  STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_node);
>  STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
> +STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
> +STAT_ATTR(SHEAF_REFILL, sheaf_refill);
> +STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
> +STAT_ATTR(SHEAF_FREE, sheaf_free);
> +STAT_ATTR(BARN_GET, barn_get);
> +STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
> +STAT_ATTR(BARN_PUT, barn_put);
> +STAT_ATTR(BARN_PUT_FAIL, barn_put_fail);
>  #endif /* CONFIG_SLUB_STATS */
>
>  #ifdef CONFIG_KFENCE
> @@ -7315,6 +8313,7 @@ static struct attribute *slab_attrs[] =3D {
>         &object_size_attr.attr,
>         &objs_per_slab_attr.attr,
>         &order_attr.attr,
> +       &sheaf_capacity_attr.attr,
>         &min_partial_attr.attr,
>         &cpu_partial_attr.attr,
>         &objects_partial_attr.attr,
> @@ -7346,8 +8345,10 @@ static struct attribute *slab_attrs[] =3D {
>         &remote_node_defrag_ratio_attr.attr,
>  #endif
>  #ifdef CONFIG_SLUB_STATS
> +       &alloc_cpu_sheaf_attr.attr,
>         &alloc_fastpath_attr.attr,
>         &alloc_slowpath_attr.attr,
> +       &free_cpu_sheaf_attr.attr,
>         &free_fastpath_attr.attr,
>         &free_slowpath_attr.attr,
>         &free_frozen_attr.attr,
> @@ -7372,6 +8373,14 @@ static struct attribute *slab_attrs[] =3D {
>         &cpu_partial_free_attr.attr,
>         &cpu_partial_node_attr.attr,
>         &cpu_partial_drain_attr.attr,
> +       &sheaf_flush_attr.attr,
> +       &sheaf_refill_attr.attr,
> +       &sheaf_alloc_attr.attr,
> +       &sheaf_free_attr.attr,
> +       &barn_get_attr.attr,
> +       &barn_get_fail_attr.attr,
> +       &barn_put_attr.attr,
> +       &barn_put_fail_attr.attr,
>  #endif
>  #ifdef CONFIG_FAILSLAB
>         &failslab_attr.attr,
>
> --
> 2.50.1
>

