Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A746D606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DFDvma7V
Received: by kanga.kvack.org (Postfix)
	id AC6C46B05B1; Mon, 16 Nov 2026 12:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76886B05B2; Mon, 16 Nov 2026 12:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FD56B05B3; Mon, 16 Nov 2026 12:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADCE6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:40:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF1F9A7657
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:40:05 +0000 (UTC)
X-FDA: 85441695570.17.C9462AA
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id E0EA610000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:40:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DFDvma7V;
	spf=pass (imf14.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794850804;
	b=Fe96XLLlthskMkVLEhORH61hRZRL1f/2v+EESu1gdEWVATX59T4Hk00l3xxcltbebgRx0m
	ZxAi1chN08Ja90gGDagdVyfbU35c41kA9DBQWhC79J2gV2ut0Vp4XE5qWgRJhCjtWDUIP6
	nq8B2qbclF6jtu/59GPDVICp0j5MFmk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DFDvma7V;
	spf=pass (imf14.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794850804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
	b=eEv/WzhQTQ2L33bCTWSGPoZlDmVsfVcsDHvnnJDqH9PTbu57qBiCAUspT2HixLzwEUVX5S
	ri+oWAUh02uo9nu4NdUfTY1FHQu5THp8KIVRSY2TtIDPwKgmUL8fTLNyqZUXJVqMr0I4e/
	jdJ64TGYQwZGEx2z4vZLMUVnp7EC4lI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb5b33e2ffso72645e9.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:40:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850802; cv=none;
        d=google.com; s=arc-20260327;
        b=Pf/Cy/rxKkNQiEeT8w6WZh4hn3wr3dfb3Jws4sbiVSLMccAfo/EXq8fzESVEw5JdGG
         2BYCYaUUWqcAm6OEzr6jlRBSlo2F+evPx/nGRyQgcqZnaixEnYWTfgb0L0hBFUakmzM6
         vEAAQIc/zLd9vNy79kUmRgOk8n7BCbzk43bckq02n8REDeuybS6xsgdXXtzeUxzPY3Kq
         9DLJZ3tseIDaynthdSEOGJdmAIcIUu0aNpj7jC2x7WvmFzShSbkDD4imsJYnS9VNIQOr
         FxnYZcDa2dvBMUlGX+nfB4cAA2k0AYnVcCJ6V20bJBOayELLdrbgZe/hwWk0JtB8HaSQ
         uCZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        fh=yqNpgTojFDIQXzHeszx3GsJxAslrUX5pjXtmD8J47NA=;
        b=LBXit7lD8T5t5GFS3oKOObm7JY2Cui4GKYbiHjWYq0+T+9K8BGf9ggGTTtzOFKgMeG
         LzycnIiWbrbS88eSH4KHvjajQRTq4Gf5M9MHXAD9wcyaI6PtXKMiNLxBqz/J+M2Xl+tR
         dAyFDJHamFGX9xGPKAwWc/+CfZHCJWKRc3DKlPzlCPFLisVRb9fmphmyjsBjhjXQwcYb
         YGmeKxPgiqSTbOYk29h8kie5C0aDioJFM9BcPIUlxPlERpMlR8opYPMlnOEIcLNLd8qi
         vDrNLYAk92RLNzON3Zcpdgk1kTVfsO7F5l66Wgk+u3+pajKsQ5nhE5gJNl2fJdiuQgPL
         qh1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794850802; x=1795455602; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        b=DFDvma7VLRjR6uilzesjmv80d+V5MBWNAusWYBbeWRk2f2IpLgm9SpY0YcuHv2Sfgx
         aNklmfxm4PaStt5/dEhXXzWxUMQ1v7PZCZmdyvLyeSDPfWH6iVDB1dblP6MAkY/1f9CR
         +lFYIrxZqiUoAwh62bBkqiRKrgsmz8UqetSHo7t8kqINHljGqx4hT3UuFCye+FxxPs++
         QWDByqfCHlCH+nc0H+SeNCGkEsAmf066uXdHSYBy2m80kqCW/qcQpeekTjfvsJWdkci4
         F8Nk3Sw5gDtg6yZ9hOjWMknrGjBSPs9g8vzH58Wsj33C22k4FHHT3ouZrI6COujR+b7J
         yYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850802; x=1795455602;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSwHlQDyP7wkj805UeQxgqOCUOA9IwLfucPHoVu5Fz4=;
        b=DnuguQrYUyKW3ygNE5nnDj1GGrZ5+mev44hoDYiLJcJS67daJPTiU8Zo3+dkYVYRst
         Qg7MLaawL/qu3CA+Z138JzE77IB92QiOrntdaq+5A1ckIpUYbaLyfbjMzB+SZK7VWmog
         6PhgoqIR6j0HxGegKkkxLFAUuj3sVzD57+YRxgTSBmhtqh9Yfq6CNDeiIwHoKbvOuoZz
         +wovi2vIY4WhtZPYUToIXcMJvPtONAm9vsmTc2w1XXwwlZqIPhtYKrFeJU4Qp9L/tuPS
         1sA1tfyS4ENjtXkK+X5+bSMdOKr3INXxkSQ2xb4In6q/7KlJ8jKCKYr/rRhQN0t7oJLM
         Phmg==
X-Forwarded-Encrypted: i=1; AL+hErEAjwaYFvXpSQ4N7JoCa1elWZegu4mvveOAwTrgRq94X5nS9jFyORtUcxnFIkG9LJra/K5LnwsXqg==@kvack.org
X-Gm-Message-State: APuU4Z94jBhzpSflpeu+/aCkTEmViXfOFS+aBHDCrA3HdoNWxGdYTFUC
	lGeGtsT4D+ru4B5o3MmYi44dYh5PwvT4Rtrtthu/TFVDA/z6l2xiYOsiLM3cBc4wWqHvWNhTfdM
	2DAIXrzhrTelcTAEdNQuCMXx5lpKIrEtmRKYSR8yn
X-Gm-Gg: AYBFou2u9FUAwfUPbZRaDnve/wr3k3sJPneqkGQov42aS7M2SY5NetSp4nd2mZhr2Gn
	YxlMgcWVH0pJvx5Iw2M+3N2qZ+jM0/lUsmVKmIBaVZ76cJDlAccAXa0LRIGR6e5yr9ZfZDWERUo
	h7QLhWTDTMjZrIcUBWKZUS1bHiJRsP+QpsiJQxOcigr36GODTZ11Mh/VkfCVzbqhUEbOphP2h2+
	6K2P6gDf2Mfewoh78lDYJ6inanREywOX93LUPbADmlFlyXcP8BFwqVXpu456JHRB6YDbNOdW2rM
	CW/GJXUkZjGIng6LyIuCCz4sM18+mR2YYbAS37ASV1DdtFX5n0d6UHDOBskgkB2wYjVjqfFbxKx
	z1uH30E0vcntmi5lrRAi7qVBey3BcA8ivOdNUr55Ihi3m5IhVvKCY0QpOhdlRtdywlGy5yqEwwx
	j7vp9d6PLOr9fJC8cjcsj+wA==
X-Received: by 2002:a7b:cbd8:0:b0:4a1:fb0b:1c9c with SMTP id
 5b1f17b1804b1-4bb62f74fd6mr2275405e9.10.1794850802012; Mon, 16 Nov 2026
 09:40:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com>
In-Reply-To: <20261106235904.1092712-1-tjmercier@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 16 Nov 2026 09:39:48 -0800
X-Gm-Features: Aa3M54oxYc8a6LIuSto1TMcfd-6pEIfEVrjDl0LEFJ6mfcOIGgTGdyYmUpGfP1M
Message-ID: <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jaewon Kim <jaewon31.kim@samsung.com>, Jaeseon Sim <jason.sim@samsung.com>, 
	Youngchan Kim <ycshark.kim@samsung.com>, Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eiqb4wo9kzekgdk14dtmsmzqzrkwefa7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0EA610000D
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794850803-518512
X-HE-Meta: U2FsdGVkX1/WuE8qTgbN02QyIwPfOGh2Auuf0WkvKjGX4DbcaBRQWuNkuo6ahfhMT1gMO40l2PTOcE3SkFhRFSQfgyURhgJnOuXCgUsqajZeYpu9U4VNHZvqEeCfNts8BR2nVAQvMSsh5LUSicnfptdSDQ3BV6wuYx52rSo+nnH7GHzqQR0BRIPL1N1bBKHNQ7PFvfKIe+V+HFJG+xnDJg3TI6lAwaNIPoYG7HNxJvJtw+MNSpCu52+RJL5ogCaW97MmneJkzu+Ji8eOBSVMVr6H+xvQxK96bIc34JpiDEqGUQ/m0qGCIudJICIZZyXN0Uk1BbOmZVD7IncjZDWrAJUkiZKYZLZ114YKRm3xMXPRBUcd7HWnqfv+tqGpzCYjCnaYSIv9JDoJuTsMKl0R23KES8D8pPi88KFlPlh50vRkPtK4sO9a1m74vQ98E4oObescvZiA+Ku6HwsXN7KeImiZxWgYO1ZfnuQiU5i1YU5Mtcwy2jFXnHsa5GL3BZh66sYix1T7YE1VZLEjIed3mjYNnf4owR5CrNus9KstNlamzbLOzzfQjCYwhA+T2oVHM0vTbvfkIVjXfCf52GTG+lmNHfm9LDWigeg8beNYH92uYETMgBkHWaiW6bqkkGha+L85/w7TxvZBYp4/b3F+bUV3bDUyRWSXoZ84HYQb6RVATuP9a2ea+2Qp4/bIMeLkl9I2nztVKg9OpC1pneT4TVZLOO7Ad5th81V5ZoDF/QbkzoFSmuHiIyUpXQ+60wtunYs6+ajB52fW0jX+HH/s70HU9dltAK1XDfdN06vjtD2CksBC9DWQ2zUAZJAlimj5AoGeSGx7FTSdc5Qt9snbap4l7RvoVbU/f6riWP8YdiEn24tZudCOq6tkxLF2HGVUEOyef5EiYeUcnxjuRqrBmH6SWkZNMPvI8M74y4mUeSUdI4F/YUxhWpSs2oRbfKZJLZlPqDAABN0urhpZH77
 AKnfdcOz
 GyTKc7xMRU8dnbiftFK8ggCtEMfmOWdkRF+KVhzkdWjkf9XM5cWfMfQP3aL2YJZA4L7NiKSXhxE8v+06djgsY5/LmMCDXUlqwFMjJphTBDnzgt6KhLmSq8ZxV8IouSuh4mzQt+iz6gnhiL6Whcm2CTwamLom45j2uTzUtl+JvcPh3JAQEmQio+6q/8uywaViCeGdaLhYEqQTKE+GASdEcq/wumPROJqWzDHPsHKDR+mq4uMrspEvypyTRVCq5EKSW2EPXIaqd4N33Zd5JEeinG9RCgyPHg7iQrJYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.com> =
wrote:
>
> count_shadow_nodes() limits the number of xarray nodes holding shadow
> entries to 1/8th of the pages that could be using them. For a memcg, it
> counts the LRU and slab pages local to that memcg.
>
> With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes are
> not charged to any memcg and __list_lru_init() makes the shadow_nodes
> list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> node shrinker, which shrink_slab() only invokes for the root memcg.
> count_shadow_nodes() therefore compares every shadow node on the NUMA
> node against the pages local to the root memcg.
>
> When most tasks run in child memcgs, the root memcg only holds a small
> fraction of all pages, so the shadow node limit derived from the root
> memcg page count is far below the number of shadow nodes on the NUMA
> node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab() cal=
l
> trims about half of the "excess" shadow nodes. Most refault information
> is thrown away, so refaults of recently evicted file folios are not
> detected. Refaulted folios lose PG_workingset and the workingset_refault
> and workingset_restore stats drop.
>
> In testing on devices with kmem accounting disabled, moving tasks from
> the root memcg into per-application memcgs dropped workingset_nodes from
> ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> pgsteal_file rose by ~12%.
>
> When kmem accounting is disabled, compare the shadow nodes against the
> whole NUMA node, as is done without memcg. Behavior with kmem
> accounting enabled is unchanged.
>
> Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

I'm guessing there aren't many other nokmem users?

> ---
>
>  mm/workingset.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 1504f91cdca5..87d5e55dd684 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -682,7 +682,16 @@ static unsigned long count_shadow_nodes(struct shrin=
ker *shrinker,
>          * PAGE_SIZE / xa_nodes / node_entries * 8 / PAGE_SIZE
>          */
>  #ifdef CONFIG_MEMCG
> -       if (sc->memcg) {
> +       /*
> +        * Without kmem accounting the shadow_nodes list_lru is not
> +        * memcg-aware. So the count above covers the whole NUMA node, an=
d the
> +        * shrinker only runs for the root memcg, whose local pages can b=
e a
> +        * small fraction of the node's when most tasks run in child memc=
gs.
> +        * Compare the shadow node count against the memcg page count onl=
y when
> +        * the shadow_nodes list_lru is memcg-aware. Otherwise use the NU=
MA node
> +        * page count as is done without memcg.
> +        */
> +       if (sc->memcg && shadow_nodes.memcg_aware) {
>                 struct lruvec *lruvec;
>                 int i;
>
> --
> 2.56.0.455.g6c5a503b38-goog
>

