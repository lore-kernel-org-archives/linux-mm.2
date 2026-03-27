Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D9C10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669966B009D; Fri, 27 Mar 2026 03:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640336B00B2; Fri, 27 Mar 2026 03:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F746B00B3; Fri, 27 Mar 2026 03:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2136B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:51:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E12B0160FE7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:51:49 +0000 (UTC)
X-FDA: 84591073938.02.059757E
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4ED5100010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:51:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUYYZ8wb;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUYYZ8wb;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774597907; a=rsa-sha256;
	cv=pass;
	b=KTW9I3oH3XavRFrBaIcEa72UeEM97WUwHQsbJFsWtzmixg1GwOaxQ+Li9fZpuTyyu44Wgf
	7/WFsWnMOGnwlYHfcj4o+U56KwenX3a2zYSI2iLiA8OCSkvgY9JyV1kQlXOWBeCy01TLd8
	kWPsKfoVivK3gHNTmuU55aXDlaobROg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGa7X7rQrdgZnzXDp1KQ3XkFFiEzn2FyYaMaNyp6UCY=;
	b=Eys+Cp+4kY1xDeLWOmVNvz5SS0phojHGFW//yf5t2QDz19z1jrxJao3lN3+oOO3YehHFsM
	zp6Hzi5eOpH2mudAcPeUcQEzmuD7FIEJf7xRRZ5+t/heyRyBaXZXJIo3p1j/rMMNFPg0WJ
	QwBzlYgLSinO84T9bEscqZaetPXQnZ8=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-66aa2204e9dso3928690a12.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:51:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774597906; cv=none;
        d=google.com; s=arc-20240605;
        b=aKoDx8n+0pAHw79IYT2p3LSzh8D/JlWwrvN5LACINxbdmgn7lXJQbKFQh2HGgdnLpu
         5D9Q5tAvcmhA4BYmyXT2wb0kUKcUFpt/vV52DNRGA+T8d3+jjB9BL1vju7+YEDqin9hY
         z/q0kjR/9K0rxUyuSfEH79wZwJix/QhVALTtoeD32xwccDGZ94WgzEsklnLBtEVeP8w/
         VF4V4AhrXTBVWAd80sHsw6/xF7Ag+i4oso011XTpQXQhGuimN8Xvx1eMKlPPIs9ddCYO
         YlCKZdMKppdcO7mq+Cdu6u+bjpNSGe3rppHkqaQAOcptW4+A166Ao4a1WI0ZGkwGIbkM
         nM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gGa7X7rQrdgZnzXDp1KQ3XkFFiEzn2FyYaMaNyp6UCY=;
        fh=zLkjzIH8S7iRAw6hTVnaGmLXHFuGPfbVt7CZgI4PzZg=;
        b=T1LB95dDF67pbvWHVRvb3WQwhHH7EQvyFmJywrGV/ECzq74IL9eDbQtSP0I87F3qRi
         L2fXc88a6XhrvTbGXh96KmBVJXzTUHYWqFS9X58mryV/Xye4p4Ul5WEY2rnWULgYgjC9
         J+CfIZDb0cvdC3FupPnDKzMh9UftMeq9Uc/gZOyaThw+hlG9PzjPxGJJF5BD1V9YioB/
         OexsO1Q8ZyBQGgrQzu0BM1UmRFHr11nENMkVJPtG/pHtx0mhHRKc/+V6dSP0JqwgwaPF
         jdXKj4kVDFDcPArEO4tD2khzce1T4PrhWY/hRXP5j6hJSXcTzuFEXsqH32z1f3aKqkIh
         01NQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774597906; x=1775202706; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gGa7X7rQrdgZnzXDp1KQ3XkFFiEzn2FyYaMaNyp6UCY=;
        b=IUYYZ8wbxWmJyzYnpEWh15OoJdbUvSq1jXolRmqfWYPHNZ4Nu2qlpD2TMkCcpINwX4
         gMgHQl86821MzrNKyHGJAhxlhaUvj/QdvAwlPBx6xaA6HMMOK3vULEp4Qa7BtUP+wkgr
         1wkkb3RVqkj66SKptgXgkrTXxTImHWJLApSFsClMumqrI/6reQWi9KAx0EKSn1xBb0BC
         hTxGzSm5KCW2qCFAFQC5lNzBmxz+NpV+LB4PsGMfjKoBa3z7P64U8zG/bGN/w+IN79i7
         vciI/OuGpk+xaMPtEM6z1olDw4qweWNjDl5gFtoWWQLCQ1L4ZjnhiGpAHEvViM6Hkgod
         bZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774597906; x=1775202706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gGa7X7rQrdgZnzXDp1KQ3XkFFiEzn2FyYaMaNyp6UCY=;
        b=aqaRAZqsujVfaQ0M1EVpDOvopl9lil6hatQr30ggFsfGa5F13LsdX4ZLtSnvtmHV0/
         glxjCfEjy16dFiHOHpg54JvPCr+d7hHOBLGgtHJaGFHBtYB6nKK53RrcHiy4u8G5rGjs
         cI7YLG1jdqKyBaxjikRhMmGC7N+2GYUhL0DxH3y3voIGSizP4HPQfkVSF65hGKWj+mKx
         8CMmmnbixS0Mq2ju19cZ96YHPfrWXb2e7AZhSug79ywcpNLkb+0n95HiTQf7NZDSHqaG
         MjRBAWhWjX59hfwCcTab0Oxi6tLzjbfNEUCK2rAZLgE0uIM6vSLxpEirBhGQZb52WSGY
         auZg==
X-Forwarded-Encrypted: i=1; AJvYcCWEC7DZjRlyLMS/weyQ/JrI2dKL6aZdl8GSNJTTKywgsCZWJmYW+HgW/hW1/885Crp0R5sA/6nLqA==@kvack.org
X-Gm-Message-State: AOJu0YxaKPyzDVzRxjpbTMEn4Oy+24ptp1jD+RhUxXyEYL9XZPUt4/+y
	Sj7rpF6D+/Z7FeazQzcpVl6tTR+MzDe4HAoUVO4c9nhwmRyyIJ7N8xBZxuGitT/KsWtitBz8JbE
	D1VXJGHig2ulNZW1y6F8A/kfvD/OSKPc=
X-Gm-Gg: ATEYQzzQ/bcjhao3WmPkvskgSu5GuzPvHCw+2BG419shxD9fziA6RxA/kqC/auMqqu+
	ZT9mI5c/iPAKLjsH4XA/FvyUUN5IlPkM1qqpwXNlHE5+gUCBHZ2Vu6B+GYfhxjB/94hnUVfnbJv
	4SljQr0QiAAy4RndrY7Jmdtm6P6y18E2nC4k1uN1Z0ZW2HoDn0KKhXNqh7hEKFhbC3WI1AMow/U
	uy3TOWmv2rmYE10Jwnr1IxVbN3YV+ZpPZmoqaI7WAB1VWdzgvjCDaudE1r3tHeVndZN43+ZW2zQ
	bOpmVlExPK2ZlFnZP40pBf+XRzxbPA4QzqWAyk0=
X-Received: by 2002:a05:6402:438e:b0:65c:5def:26f2 with SMTP id
 4fb4d7f45d1cf-66b2af38173mr670316a12.11.1774597905622; Fri, 27 Mar 2026
 00:51:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260318200352.1039011-1-hannes@cmpxchg.org> <20260318200352.1039011-8-hannes@cmpxchg.org>
In-Reply-To: <20260318200352.1039011-8-hannes@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Mar 2026 15:51:07 +0800
X-Gm-Features: AQROBzDxkCS5-TDRRL6Zby41jB5N8rIsE2fKLhqoPn0u1nEkx5Fm3K5uoAfvrcA
Message-ID: <CAMgjq7BA8BHMEwK-QVpH+gDgu9fHEKxs4p1A3CeY9p7G98xhPg@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4ED5100010
X-Stat-Signature: wjcf6ksgsqpp3zib67uq8khs6bapngpy
X-Rspam-User: 
X-HE-Tag: 1774597907-371695
X-HE-Meta: U2FsdGVkX1/UrGfYvaiyd6/vE2s8O7SkGM1EX2K4I9d4n9A1BoCParHJc99P41KmNHw+d0s7nF5kqSmNneP5CvPELgOU4qGqgPiQ/cOdi0RyB8bXBR8srAYi8LdNNVmOgLsVtgJIu36gB0W/FBuD+xXFiK+BOp/8V9psdzE6D9Md/NNzSUeLqx2Y4jaKX1YheKEBIQR0rYWQZWBWg9C2z21IzoiOFog0Gz2kF6L1EnDn+kLEc50MN+C680qKzeeqYbsZYvEfVXGtBA5thhFfO6AsFmwIIrJWfkuCYJm7Gt/LMon77m4gew72gmb+uNI9ypsxn+shjeTKvzGkW8p3GhEePM5uHr3nnOOQgVJRzmQ/xuKCFtWy5ttdv/7VMlqwA146J2leu6gXxUYXDunRajf/SCtado3K+eVQREL3Nudbrgb1mxU7GxeTCPQNu3/s4cPahwWclHbIu7cDV4L1bRQBc+bGpgjqLq6TgthtdWj5PhonpTz2f5TzSBVncyva8YN5QJmRE/Advb/YvsJULoVuIkQ6CsQeXclpYCum1xU3zIOye8delR8ut8xZ6X9d32BbgQZgWOIlFxUxRK8kdVfkkcRtgL2ReV75fIhVitUKOYuGGU6M32s5cZcEOFPsngM1DXV96gNpsJIsbtbiP+V9pgl3fxWtFRMDgnOpd+1TqN51N1RdcVksmxDpDuKNC7tGBAEZwGi/A78aNSRAA109cyQSnhJHA8kJDHlxD2cdv8IRZ5Zmw6eofgNp1nKiWLG6gTA6SG3QNXPVp2CyHx0ERTN2vwo9+16gOP7uL8RZubYT6+gvuPKLP4KXQUkxstit3maAA2yJjTYGJmslIzJn6fOA5YCFi8h+fs4TS7EfF5Qnqh1aValHnWsgm/urQgrBTQg6RZf/xj8Vl6gWirrrA0UAIXXPpnbSGsgmmMgi7kjz4kUGxWGPDaegBysxYPWHFQIFHdRujeWOKg6
 Fh2T1/KL
 bzjMGIRDLqHK94Y+nEfjL11w37GnJMx/lUssyMJWSNumvgJp1SXMxYVmOCnELaiEFpqsKFUDcvOOcymfumc+dZq/eBjPiQ39VsRydPw2++PrBimzOQGcWLdm4zmbiG69UaZdfUEKfzKucgusHpNc1FuPdh0TmkLDGvmtnmUrOtYJyhRiTZhhAXsFRYDfOLH4UsFfRPZKhudpmhUeF9aVunWS/27cydZXMa7PSw5vJx/VX665fJ1JqfNZZF1TsrDrEoxWg7iQ71t7x7l73idkDtwDyVFYDfva94Zi/RYSYhoOP+yq14Bc7GatG4KZOTl/QGufMv8QN5MmmJRhJ8hbH10NBjTB9ZIbE5n/0P0HHKBIZzHA9b4QVH7viGj6EMQJZyUvtkUQYM7I6l594mpt79bRjFjOVVKaEqDYZstqDvTFOeyjTVjZ65ci6q+WV5pSmAC/ucQ1x5TbKM1k7CHoruLyfKMIfWWW0NFmRerI7PlGGGCYmPJTtf+3Gs7caDOSVG5dHb5Q3FWQoC/3UUsufiMOpMmvM6e59vhFNS9ZK1CHDrU40SWED1SlQvJyVR0wwnSHB570GcEbjkH+EcxXJWh9SLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 4:05=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
>
>         alloc/unmap
>           deferred_split_folio()
>             list_add_tail(memcg->split_queue)
>             set_shrinker_bit(memcg, node, deferred_shrinker_id)
>
>         for_each_zone_zonelist_nodemask(restricted_nodes)
>           mem_cgroup_iter()
>             shrink_slab(node, memcg)
>               shrink_slab_memcg(node, memcg)
>                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>                   deferred_split_scan()
>                     walks memcg->split_queue
>
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
>
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
>
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
>
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   6 +-
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 342 ++++++++++++-------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   7 +
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |  52 +++---
>  mm/mm_init.c               |  15 --
>  9 files changed, 151 insertions(+), 301 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index bd7f0e1d8094..8d801ed378db 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
>  {
>         return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
> +
> +extern struct list_lru deferred_split_lru;
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> -#ifdef CONFIG_MEMCG
> -void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> -#endif
>
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>                 unsigned long address, bool freeze);
> @@ -650,7 +649,6 @@ static inline int try_folio_split_to_order(struct fol=
io *folio,
>  }
>
>  static inline void deferred_split_folio(struct folio *folio, bool partia=
lly_mapped) {}
> -static inline void reparent_deferred_split_queue(struct mem_cgroup *memc=
g) {}
>  #define split_huge_pmd(__vma, __pmd, __address)        \
>         do { } while (0)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 086158969529..0782c72a1997 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -277,10 +277,6 @@ struct mem_cgroup {
>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -       struct deferred_split deferred_split_queue;
> -#endif
> -
>  #ifdef CONFIG_LRU_GEN_WALKS_MMU
>         /* per-memcg mm_struct list */
>         struct lru_gen_mm_list mm_list;
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..232b7a71fd69 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1429,14 +1429,6 @@ struct zonelist {
>   */
>  extern struct page *mem_map;
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -struct deferred_split {
> -       spinlock_t split_queue_lock;
> -       struct list_head split_queue;
> -       unsigned long split_queue_len;
> -};
> -#endif
> -
>  #ifdef CONFIG_MEMORY_FAILURE
>  /*
>   * Per NUMA node memory failure handling statistics.
> @@ -1562,10 +1554,6 @@ typedef struct pglist_data {
>         unsigned long first_deferred_pfn;
>  #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -       struct deferred_split deferred_split_queue;
> -#endif
> -
>  #ifdef CONFIG_NUMA_BALANCING
>         /* start time in ms of current promote rate limit period */
>         unsigned int nbp_rl_start;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3fc02913b63e..e90d08db219d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -14,6 +14,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
> +#include <linux/list_lru.h>
>  #include <linux/shrinker.h>
>  #include <linux/mm_inline.h>
>  #include <linux/swapops.h>
> @@ -67,6 +68,8 @@ unsigned long transparent_hugepage_flags __read_mostly =
=3D
>         (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>         (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>
> +static struct lock_class_key deferred_split_key;
> +struct list_lru deferred_split_lru;
>  static struct shrinker *deferred_split_shrinker;
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>                                           struct shrink_control *sc);
> @@ -919,6 +922,13 @@ static int __init thp_shrinker_init(void)
>         if (!deferred_split_shrinker)
>                 return -ENOMEM;
>
> +       if (list_lru_init_memcg_key(&deferred_split_lru,
> +                                   deferred_split_shrinker,
> +                                   &deferred_split_key)) {
> +               shrinker_free(deferred_split_shrinker);
> +               return -ENOMEM;
> +       }
> +
>         deferred_split_shrinker->count_objects =3D deferred_split_count;
>         deferred_split_shrinker->scan_objects =3D deferred_split_scan;
>         shrinker_register(deferred_split_shrinker);
> @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
>
>         huge_zero_folio_shrinker =3D shrinker_alloc(0, "thp-zero");
>         if (!huge_zero_folio_shrinker) {
> +               list_lru_destroy(&deferred_split_lru);
>                 shrinker_free(deferred_split_shrinker);
>                 return -ENOMEM;
>         }
> @@ -953,6 +964,7 @@ static int __init thp_shrinker_init(void)
>  static void __init thp_shrinker_exit(void)
>  {
>         shrinker_free(huge_zero_folio_shrinker);
> +       list_lru_destroy(&deferred_split_lru);
>         shrinker_free(deferred_split_shrinker);
>  }
>
> @@ -1133,119 +1145,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area=
_struct *vma)
>         return pmd;
>  }
>
> -static struct deferred_split *split_queue_node(int nid)
> -{
> -       struct pglist_data *pgdata =3D NODE_DATA(nid);
> -
> -       return &pgdata->deferred_split_queue;
> -}
> -
> -#ifdef CONFIG_MEMCG
> -static inline
> -struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> -                                          struct deferred_split *queue)
> -{
> -       if (mem_cgroup_disabled())
> -               return NULL;
> -       if (split_queue_node(folio_nid(folio)) =3D=3D queue)
> -               return NULL;
> -       return container_of(queue, struct mem_cgroup, deferred_split_queu=
e);
> -}
> -
> -static struct deferred_split *memcg_split_queue(int nid, struct mem_cgro=
up *memcg)
> -{
> -       return memcg ? &memcg->deferred_split_queue : split_queue_node(ni=
d);
> -}
> -#else
> -static inline
> -struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> -                                          struct deferred_split *queue)
> -{
> -       return NULL;
> -}
> -
> -static struct deferred_split *memcg_split_queue(int nid, struct mem_cgro=
up *memcg)
> -{
> -       return split_queue_node(nid);
> -}
> -#endif
> -
> -static struct deferred_split *split_queue_lock(int nid, struct mem_cgrou=
p *memcg)
> -{
> -       struct deferred_split *queue;
> -
> -retry:
> -       queue =3D memcg_split_queue(nid, memcg);
> -       spin_lock(&queue->split_queue_lock);
> -       /*
> -        * There is a period between setting memcg to dying and reparenti=
ng
> -        * deferred split queue, and during this period the THPs in the d=
eferred
> -        * split queue will be hidden from the shrinker side.
> -        */
> -       if (unlikely(memcg_is_dying(memcg))) {
> -               spin_unlock(&queue->split_queue_lock);
> -               memcg =3D parent_mem_cgroup(memcg);
> -               goto retry;
> -       }
> -
> -       return queue;
> -}
> -
> -static struct deferred_split *
> -split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned lon=
g *flags)
> -{
> -       struct deferred_split *queue;
> -
> -retry:
> -       queue =3D memcg_split_queue(nid, memcg);
> -       spin_lock_irqsave(&queue->split_queue_lock, *flags);
> -       if (unlikely(memcg_is_dying(memcg))) {
> -               spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
> -               memcg =3D parent_mem_cgroup(memcg);
> -               goto retry;
> -       }
> -
> -       return queue;
> -}
> -
> -static struct deferred_split *folio_split_queue_lock(struct folio *folio=
)
> -{
> -       struct deferred_split *queue;
> -
> -       rcu_read_lock();
> -       queue =3D split_queue_lock(folio_nid(folio), folio_memcg(folio));
> -       /*
> -        * The memcg destruction path is acquiring the split queue lock f=
or
> -        * reparenting. Once you have it locked, it's safe to drop the rc=
u lock.
> -        */
> -       rcu_read_unlock();
> -
> -       return queue;
> -}
> -
> -static struct deferred_split *
> -folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags=
)
> -{
> -       struct deferred_split *queue;
> -
> -       rcu_read_lock();
> -       queue =3D split_queue_lock_irqsave(folio_nid(folio), folio_memcg(=
folio), flags);
> -       rcu_read_unlock();
> -
> -       return queue;
> -}
> -
> -static inline void split_queue_unlock(struct deferred_split *queue)
> -{
> -       spin_unlock(&queue->split_queue_lock);
> -}
> -
> -static inline void split_queue_unlock_irqrestore(struct deferred_split *=
queue,
> -                                                unsigned long flags)
> -{
> -       spin_unlock_irqrestore(&queue->split_queue_lock, flags);
> -}
> -
>  static inline bool is_transparent_hugepage(const struct folio *folio)
>  {
>         if (!folio_test_large(folio))
> @@ -1346,6 +1245,14 @@ static struct folio *vma_alloc_anon_folio_pmd(stru=
ct vm_area_struct *vma,
>                 count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHAR=
GE);
>                 return NULL;
>         }
> +
> +       if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) =
{
> +               folio_put(folio);
> +               count_vm_event(THP_FAULT_FALLBACK);
> +               count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> +               return NULL;
> +       }
> +
>         folio_throttle_swaprate(folio, gfp);
>
>         /*
> @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>         struct folio *end_folio =3D folio_next(folio);
>         struct folio *new_folio, *next;
>         int old_order =3D folio_order(folio);
> +       struct list_lru_one *l;
> +       bool dequeue_deferred;
>         int ret =3D 0;
> -       struct deferred_split *ds_queue;
>
>         VM_WARN_ON_ONCE(!mapping && end);
>         /* Prevent deferred_split_scan() touching ->_refcount */
> -       ds_queue =3D folio_split_queue_lock(folio);
> +       dequeue_deferred =3D folio_test_anon(folio) && old_order > 1;
> +       if (dequeue_deferred) {
> +               rcu_read_lock();
> +               l =3D list_lru_lock(&deferred_split_lru,
> +                                 folio_nid(folio), folio_memcg(folio));
> +       }
>         if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>                 struct swap_cluster_info *ci =3D NULL;
>                 struct lruvec *lruvec;
>
> -               if (old_order > 1) {
> -                       if (!list_empty(&folio->_deferred_list)) {
> -                               ds_queue->split_queue_len--;
> -                               /*
> -                                * Reinitialize page_deferred_list after =
removing the
> -                                * page from the split_queue, otherwise a=
 subsequent
> -                                * split will see list corruption when ch=
ecking the
> -                                * page_deferred_list.
> -                                */
> -                               list_del_init(&folio->_deferred_list);
> -                       }
> +               if (dequeue_deferred) {
> +                       __list_lru_del(&deferred_split_lru, l,
> +                                      &folio->_deferred_list, folio_nid(=
folio));
>                         if (folio_test_partially_mapped(folio)) {
>                                 folio_clear_partially_mapped(folio);
>                                 mod_mthp_stat(old_order,
>                                         MTHP_STAT_NR_ANON_PARTIALLY_MAPPE=
D, -1);
>                         }
> +                       list_lru_unlock(l);
> +                       rcu_read_unlock();
>                 }
> -               split_queue_unlock(ds_queue);
> +
>                 if (mapping) {
>                         int nr =3D folio_nr_pages(folio);
>
> @@ -3982,7 +3889,10 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
>                 if (ci)
>                         swap_cluster_unlock(ci);
>         } else {
> -               split_queue_unlock(ds_queue);
> +               if (dequeue_deferred) {
> +                       list_lru_unlock(l);
> +                       rcu_read_unlock();
> +               }
>                 return -EAGAIN;
>         }
>
> @@ -4349,33 +4259,35 @@ int split_folio_to_list(struct folio *folio, stru=
ct list_head *list)
>   * queueing THP splits, and that list is (racily observed to be) non-emp=
ty.
>   *
>   * It is unsafe to call folio_unqueue_deferred_split() until folio refco=
unt is
> - * zero: because even when split_queue_lock is held, a non-empty _deferr=
ed_list
> - * might be in use on deferred_split_scan()'s unlocked on-stack list.
> + * zero: because even when the list_lru lock is held, a non-empty
> + * _deferred_list might be in use on deferred_split_scan()'s unlocked
> + * on-stack list.
>   *
> - * If memory cgroups are enabled, split_queue_lock is in the mem_cgroup:=
 it is
> - * therefore important to unqueue deferred split before changing folio m=
emcg.
> + * The list_lru sublist is determined by folio's memcg: it is therefore
> + * important to unqueue deferred split before changing folio memcg.
>   */
>  bool __folio_unqueue_deferred_split(struct folio *folio)
>  {
> -       struct deferred_split *ds_queue;
> +       struct list_lru_one *l;
> +       int nid =3D folio_nid(folio);
>         unsigned long flags;
>         bool unqueued =3D false;
>
>         WARN_ON_ONCE(folio_ref_count(folio));
>         WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio=
));
>
> -       ds_queue =3D folio_split_queue_lock_irqsave(folio, &flags);
> -       if (!list_empty(&folio->_deferred_list)) {
> -               ds_queue->split_queue_len--;
> +       rcu_read_lock();
> +       l =3D list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg=
(folio), &flags);
> +       if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list=
, nid)) {
>                 if (folio_test_partially_mapped(folio)) {
>                         folio_clear_partially_mapped(folio);
>                         mod_mthp_stat(folio_order(folio),
>                                       MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,=
 -1);
>                 }
> -               list_del_init(&folio->_deferred_list);
>                 unqueued =3D true;
>         }
> -       split_queue_unlock_irqrestore(ds_queue, flags);
> +       list_lru_unlock_irqrestore(l, &flags);
> +       rcu_read_unlock();
>
>         return unqueued;        /* useful for debug warnings */
>  }
> @@ -4383,7 +4295,9 @@ bool __folio_unqueue_deferred_split(struct folio *f=
olio)
>  /* partially_mapped=3Dfalse won't clear PG_partially_mapped folio flag *=
/
>  void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  {
> -       struct deferred_split *ds_queue;
> +       struct list_lru_one *l;
> +       int nid;
> +       struct mem_cgroup *memcg;
>         unsigned long flags;
>
>         /*
> @@ -4406,7 +4320,11 @@ void deferred_split_folio(struct folio *folio, boo=
l partially_mapped)
>         if (folio_test_swapcache(folio))
>                 return;
>
> -       ds_queue =3D folio_split_queue_lock_irqsave(folio, &flags);
> +       nid =3D folio_nid(folio);
> +
> +       rcu_read_lock();
> +       memcg =3D folio_memcg(folio);
> +       l =3D list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &fla=
gs);
>         if (partially_mapped) {
>                 if (!folio_test_partially_mapped(folio)) {
>                         folio_set_partially_mapped(folio);
> @@ -4414,36 +4332,20 @@ void deferred_split_folio(struct folio *folio, bo=
ol partially_mapped)
>                                 count_vm_event(THP_DEFERRED_SPLIT_PAGE);
>                         count_mthp_stat(folio_order(folio), MTHP_STAT_SPL=
IT_DEFERRED);
>                         mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_AN=
ON_PARTIALLY_MAPPED, 1);
> -
>                 }
>         } else {
>                 /* partially mapped folios cannot become non-partially ma=
pped */
>                 VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), foli=
o);
>         }
> -       if (list_empty(&folio->_deferred_list)) {
> -               struct mem_cgroup *memcg;
> -
> -               memcg =3D folio_split_queue_memcg(folio, ds_queue);
> -               list_add_tail(&folio->_deferred_list, &ds_queue->split_qu=
eue);
> -               ds_queue->split_queue_len++;
> -               if (memcg)
> -                       set_shrinker_bit(memcg, folio_nid(folio),
> -                                        shrinker_id(deferred_split_shrin=
ker));
> -       }
> -       split_queue_unlock_irqrestore(ds_queue, flags);
> +       __list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, ni=
d, memcg);
> +       list_lru_unlock_irqrestore(l, &flags);
> +       rcu_read_unlock();
>  }
>
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>                 struct shrink_control *sc)
>  {
> -       struct pglist_data *pgdata =3D NODE_DATA(sc->nid);
> -       struct deferred_split *ds_queue =3D &pgdata->deferred_split_queue=
;
> -
> -#ifdef CONFIG_MEMCG
> -       if (sc->memcg)
> -               ds_queue =3D &sc->memcg->deferred_split_queue;
> -#endif
> -       return READ_ONCE(ds_queue->split_queue_len);
> +       return list_lru_shrink_count(&deferred_split_lru, sc);
>  }
>
>  static bool thp_underused(struct folio *folio)
> @@ -4473,45 +4375,47 @@ static bool thp_underused(struct folio *folio)
>         return false;
>  }
>
> +static enum lru_status deferred_split_isolate(struct list_head *item,
> +                                             struct list_lru_one *lru,
> +                                             void *cb_arg)
> +{
> +       struct folio *folio =3D container_of(item, struct folio, _deferre=
d_list);
> +       struct list_head *freeable =3D cb_arg;
> +
> +       if (folio_try_get(folio)) {
> +               list_lru_isolate_move(lru, item, freeable);
> +               return LRU_REMOVED;
> +       }
> +
> +       /* We lost race with folio_put() */
> +       list_lru_isolate(lru, item);
> +       if (folio_test_partially_mapped(folio)) {
> +               folio_clear_partially_mapped(folio);
> +               mod_mthp_stat(folio_order(folio),
> +                             MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +       }
> +       return LRU_REMOVED;
> +}
> +
>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>                 struct shrink_control *sc)
>  {
> -       struct deferred_split *ds_queue;
> -       unsigned long flags;
> +       LIST_HEAD(dispose);
>         struct folio *folio, *next;
> -       int split =3D 0, i;
> -       struct folio_batch fbatch;
> +       int split =3D 0;
> +       unsigned long isolated;
>
> -       folio_batch_init(&fbatch);
> +       isolated =3D list_lru_shrink_walk_irq(&deferred_split_lru, sc,
> +                                           deferred_split_isolate, &disp=
ose);
>
> -retry:
> -       ds_queue =3D split_queue_lock_irqsave(sc->nid, sc->memcg, &flags)=
;
> -       /* Take pin on all head pages to avoid freeing them under us */
> -       list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
> -                                                       _deferred_list) {
> -               if (folio_try_get(folio)) {
> -                       folio_batch_add(&fbatch, folio);
> -               } else if (folio_test_partially_mapped(folio)) {
> -                       /* We lost race with folio_put() */
> -                       folio_clear_partially_mapped(folio);
> -                       mod_mthp_stat(folio_order(folio),
> -                                     MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,=
 -1);
> -               }
> -               list_del_init(&folio->_deferred_list);
> -               ds_queue->split_queue_len--;
> -               if (!--sc->nr_to_scan)
> -                       break;
> -               if (!folio_batch_space(&fbatch))
> -                       break;
> -       }
> -       split_queue_unlock_irqrestore(ds_queue, flags);
> -
> -       for (i =3D 0; i < folio_batch_count(&fbatch); i++) {
> +       list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
>                 bool did_split =3D false;
>                 bool underused =3D false;
> -               struct deferred_split *fqueue;
> +               struct list_lru_one *l;
> +               unsigned long flags;
> +
> +               list_del_init(&folio->_deferred_list);
>
> -               folio =3D fbatch.folios[i];
>                 if (!folio_test_partially_mapped(folio)) {
>                         /*
>                          * See try_to_map_unused_to_zeropage(): we cannot
> @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct s=
hrinker *shrink,
>                 }
>                 folio_unlock(folio);
>  next:
> -               if (did_split || !folio_test_partially_mapped(folio))
> -                       continue;
>                 /*
>                  * Only add back to the queue if folio is partially mappe=
d.
>                  * If thp_underused returns false, or if split_folio fail=
s
>                  * in the case it was underused, then consider it used an=
d
>                  * don't add it back to split_queue.
>                  */
> -               fqueue =3D folio_split_queue_lock_irqsave(folio, &flags);
> -               if (list_empty(&folio->_deferred_list)) {
> -                       list_add_tail(&folio->_deferred_list, &fqueue->sp=
lit_queue);
> -                       fqueue->split_queue_len++;
> +               if (!did_split && folio_test_partially_mapped(folio)) {
> +                       rcu_read_lock();
> +                       l =3D list_lru_lock_irqsave(&deferred_split_lru,
> +                                                 folio_nid(folio),
> +                                                 folio_memcg(folio),
> +                                                 &flags);
> +                       __list_lru_add(&deferred_split_lru, l,
> +                                      &folio->_deferred_list,
> +                                      folio_nid(folio), folio_memcg(foli=
o));
> +                       list_lru_unlock_irqrestore(l, &flags);
> +                       rcu_read_unlock();
>                 }
> -               split_queue_unlock_irqrestore(fqueue, flags);
> -       }
> -       folios_put(&fbatch);
> -
> -       if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
> -               cond_resched();
> -               goto retry;
> +               folio_put(folio);
>         }
>
> -       /*
> -        * Stop shrinker if we didn't split any page, but the queue is em=
pty.
> -        * This can happen if pages were freed under us.
> -        */
> -       if (!split && list_empty(&ds_queue->split_queue))
> +       if (!split && !isolated)
>                 return SHRINK_STOP;
>         return split;
>  }
>
> -#ifdef CONFIG_MEMCG
> -void reparent_deferred_split_queue(struct mem_cgroup *memcg)
> -{
> -       struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
> -       struct deferred_split *ds_queue =3D &memcg->deferred_split_queue;
> -       struct deferred_split *parent_ds_queue =3D &parent->deferred_spli=
t_queue;
> -       int nid;
> -
> -       spin_lock_irq(&ds_queue->split_queue_lock);
> -       spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH=
_NESTING);
> -
> -       if (!ds_queue->split_queue_len)
> -               goto unlock;
> -
> -       list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->s=
plit_queue);
> -       parent_ds_queue->split_queue_len +=3D ds_queue->split_queue_len;
> -       ds_queue->split_queue_len =3D 0;
> -
> -       for_each_node(nid)
> -               set_shrinker_bit(parent, nid, shrinker_id(deferred_split_=
shrinker));
> -
> -unlock:
> -       spin_unlock(&parent_ds_queue->split_queue_lock);
> -       spin_unlock_irq(&ds_queue->split_queue_lock);
> -}
> -#endif
> -
>  #ifdef CONFIG_DEBUG_FS
>  static void split_huge_pages_all(void)
>  {
> diff --git a/mm/internal.h b/mm/internal.h
> index f98f4746ac41..d8c737338df5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -863,7 +863,7 @@ static inline bool folio_unqueue_deferred_split(struc=
t folio *folio)
>         /*
>          * At this point, there is no one trying to add the folio to
>          * deferred_list. If folio is not in deferred_list, it's safe
> -        * to check without acquiring the split_queue_lock.
> +        * to check without acquiring the list_lru lock.
>          */
>         if (data_race(list_empty(&folio->_deferred_list)))
>                 return false;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4b0e59c7c0e6..b2ac28ddd480 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1081,6 +1081,7 @@ static enum scan_result alloc_charge_folio(struct f=
olio **foliop, struct mm_stru
>         }
>
>         count_vm_event(THP_COLLAPSE_ALLOC);
> +
>         if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
>                 folio_put(folio);
>                 *foliop =3D NULL;
> @@ -1089,6 +1090,12 @@ static enum scan_result alloc_charge_folio(struct =
folio **foliop, struct mm_stru
>
>         count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
>
> +       if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) =
{
> +               folio_put(folio);
> +               *foliop =3D NULL;
> +               return SCAN_CGROUP_CHARGE_FAIL;
> +       }
> +
>         *foliop =3D folio;
>         return SCAN_SUCCEED;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..f381cb6bdff1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4015,11 +4015,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct =
mem_cgroup *parent)
>         for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
>                 memcg->cgwb_frn[i].done =3D
>                         __WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
> -#endif
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -       spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
> -       INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
> -       memcg->deferred_split_queue.split_queue_len =3D 0;
>  #endif
>         lru_gen_init_memcg(memcg);
>         return memcg;
> @@ -4167,11 +4162,10 @@ static void mem_cgroup_css_offline(struct cgroup_=
subsys_state *css)
>         zswap_memcg_offline_cleanup(memcg);
>
>         memcg_offline_kmem(memcg);
> -       reparent_deferred_split_queue(memcg);
>         /*
> -        * The reparenting of objcg must be after the reparenting of the
> -        * list_lru and deferred_split_queue above, which ensures that th=
ey will
> -        * not mistakenly get the parent list_lru and deferred_split_queu=
e.
> +        * The reparenting of objcg must be after the reparenting of
> +        * the list_lru in memcg_offline_kmem(), which ensures that
> +        * they will not mistakenly get the parent list_lru.
>          */
>         memcg_reparent_objcgs(memcg);
>         reparent_shrinker_deferred(memcg);
> diff --git a/mm/memory.c b/mm/memory.c
> index 219b9bf6cae0..e68ceb4aa624 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_f=
ault *vmf)
>         while (orders) {
>                 addr =3D ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>                 folio =3D vma_alloc_folio(gfp, order, vma, addr);
> -               if (folio) {
> -                       if (!mem_cgroup_swapin_charge_folio(folio, vma->v=
m_mm,
> -                                                           gfp, entry))
> -                               return folio;
> +               if (!folio)
> +                       goto next;
> +               if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp=
, entry)) {
>                         count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_C=
HARGE);
>                         folio_put(folio);
> +                       goto next;
>                 }
> +               if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru=
, gfp)) {
> +                       folio_put(folio);
> +                       goto fallback;
> +               }

Hi Johannes,

Haven't checked every detail yet, but one question here, might be
trivial, will it be better if we fallback to the next order instead of
fallback to 0 order directly? Suppose this is a 2M allocation and 1M
fallback is allowed, releasing that folio and fallback to 1M will free
1M memory which would be enough for the list lru metadata to be
allocated.

