Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A2ACDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DC06B00AD; Wed, 24 Jun 2026 10:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45926B00AE; Wed, 24 Jun 2026 10:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DBE6B00AF; Wed, 24 Jun 2026 10:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6466B00AD
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:40:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F4208A02BC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:40:15 +0000 (UTC)
X-FDA: 84915066432.14.F94991E
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id DB2641C000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:40:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDACoV8g;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782312014;
	b=WtJnyQfWW0TFE/XXwFC7c12RHcx0lUyxWbScD/RP+EW+JqNJK5elBHLIUPBn47TReLLq7m
	MhetCFdCOyX/jXeyQv0vek++rV75MiQLz00d3QtUKUv1B12jfx38ekFCnFwUn+KOzsi0ZO
	9L6DkK0pfCd+6g+Cg3ZBobzdasWxJ7Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782312014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWKf6qA0xOoZavhdVF11AAUEP+ZjFUXbTVi5tLLPk6w=;
	b=jP1zAbMPl2Yo2ZZW8JJFoUgOPPGTUfT7kE8Rq6TmPgNtmb4PjQD/b5XrHOjz7w8FVP4hh/
	xDncT/mlvm7PEsJdBsmRiZy+NbVnlyTCP7sZNRLWUU0UnTI6O4qu45bdGOSB+WefovKnKI
	WMu60SaKGng966azUv+6gNP/fmyrnDY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDACoV8g;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-695469b574eso9493a12.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782312012; cv=none;
        d=google.com; s=arc-20260327;
        b=hLiDAyIuvKv2FUZyUdrstlZHpQYpLrKFGbZF4DoVrNhHbIbM754QduUp6xhCLLjMbb
         Rj1o8wMESzAd2cPsQJ4WR02uERU6VFwLHfOLqVrM1lKgbF4zin4HAStQ10yP8iVz2k0e
         eG0zKhwhEI6NWStbhsfL882go2iuEbLP2u7kIwcZpVpepELkgusglGIkCdw3vugDvfbP
         4vXu0J8XaNmtn74eN7RRQ9VRKjxqsvXTptK05hwV53K8TX/OAHHXgouDdpB9o4uz2b3g
         hVbgsU9cJ/kgROUiJ9CLqexpF02abuC44UmSl8k5GpzxVPdDtfVA7Y+TxiteHPf5GaDp
         Kvow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FWKf6qA0xOoZavhdVF11AAUEP+ZjFUXbTVi5tLLPk6w=;
        fh=JADx4NCXP2yFPE8KiXN8J/mSrgfG9o5U0tvnh13oAzc=;
        b=cFRvkTBA/bxPNVtNLYR0gEHKUaECMiMe+9Edh+p7Hg9r2AfAQi6AXgiZRqvQnOvWkE
         OKPZpl8KBFj5c5ZUT0I0hVe09LME8jqvU9bjqceq272n9uVil2lky4knNzenZfR9rIlu
         mWNT7h4sHlwN/JycGR2i39gGsBFGbqSRpQqFeTrGur9yS5fbiFVH7xD2RMWttt+dOGQh
         hsVBikEBD5Wl4i5P7DPyLOGWbf//C2l9ilZ/r8sm0XuNSWIygnfgYSR8WdmJ20DLUhef
         qKJosKSd7PhvPv61Khwo2SpmFAkxq4gr6yWH7GftP0UQnBFzRuBTBFqS3o42qad5Kwgj
         bhbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782312012; x=1782916812; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FWKf6qA0xOoZavhdVF11AAUEP+ZjFUXbTVi5tLLPk6w=;
        b=wDACoV8gGK2TqRcRYqpsYblsND0xUorXYy21gSc/5zcnBMMp0wpAu8yDRXYI5UlTBZ
         wfHg5ZeN4eG+AvBMaoQ1X/fbjQsbeI4EftaQdQlgckJHm+FLXKUv8SKhNgm5Ivxc9kgf
         dW4nnFT6gR7DlIUMk+6TUq7xR8IapEyRudflLhkxrUyfB+hwlRPHVoqPp8AMhbWgniLC
         dwWT6U1jFjIo0HJUruDVLxItj8jiQhm2io/y1ylnAE5uTfsylEhBh01Lka/fxHkg1C8n
         /tDU5Ub83R+4RqRK5a7FcQVfG73uHQlNQuQj2XZ8wRl0gMQf1nrndIKFYxmq6K76O2eQ
         6nvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312012; x=1782916812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FWKf6qA0xOoZavhdVF11AAUEP+ZjFUXbTVi5tLLPk6w=;
        b=jVflO9AXpksjBIsjWnfZQ7RoXzRW7eQv3J37shtrJiaaFB8LO/a8qxr24esNBWqgKb
         lqNwr28GgquL/srPDPGLpPjgfjuGWZugTNBrSzXxrkluVmthi7mgd3wmBzeOqaSo76Bd
         XfCLolWC/KIDpLzMp8vDDuUQhE9BQCRmaU6GmxD/Ae6wdGcm5qi/l3BXK5sl7Om+9OEK
         RgLUPDtksAin2GXI8/4OrhA70oxgwkl2R7e7ETo5/QPugeSOuDt9A2NmHIzuunXDogv0
         0hgbM9e1v0IOSIKotG4chm8czKY14E8wcKvrq7xuNoWuMsPxPPiX4YoElHbgn4Sj2O7p
         HKHA==
X-Forwarded-Encrypted: i=1; AHgh+RozXcmWfTAmzAjoLKrLbX4greVorO/Whtf54RaPfXq+T7r8vZwGnlDmqNV2Ax3Tw1qDO4S8VApY7A==@kvack.org
X-Gm-Message-State: AOJu0Yx1sRUOPqpTmJ5mx0r0IFLEtVeaD6lbWIgTYQo1d2CXL7uovxCj
	lPLPTi/b3p2Xf2ZpeL32yMeGI4sM40wPA6Jh6urYA9KKuTjw1iLl/8yyMIdBYuk4Q7EhyUv1KUP
	kkrRUHJ1Z/8KhpwagxiCP7J8igZYVOB3MGKzQQX6X
X-Gm-Gg: AfdE7ckdNgzAC0q7AIiFh3BQ8nIYOgxVHGTqCGC44Jk6dXkzBn8slYib1mdq/p5vQxa
	yq/aoICEWEbAh4u0oUUW4PryuVLC7iO/rtAvbhWHjnss/i5mHYuy+bxlgsfh8bBLZnpg9ypiMzO
	qvRR/td9La1jgvLsH+KTrnmjCbmQN/ajUQnNvOAf58713PoihKbjT9Ocg5xlpZOxrMxHKjhN3iU
	qoFk89BFuVkZNfZoN7iakcHCLf6nV8m3EQRehmjROe3teP04q74sJBsEvlQ8QiJe3DHe0wNPslS
	+WZSYKcnnWgnGJftAkCJSGFBPw==
X-Received: by 2002:a05:6402:21d2:b0:698:a99:445 with SMTP id
 4fb4d7f45d1cf-6980a990b18mr2980a12.5.1782312011716; Wed, 24 Jun 2026 07:40:11
 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 07:39:56 -0700
X-Gm-Features: AVVi8CfeFSgyEnsm1Ac-SNfll3gB7dPsvM-OhL8M7_84xc3d-jjBQh-OL4XyQHk
Message-ID: <CAJuCfpHrxk+fA8WsSh3mG9Fj9ttrLrf4RH=BtVbJwmAgE2ZSZQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
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
X-Rspam-User: 
X-Stat-Signature: emdj7heq8frbp5dusdzr3do7rruxm1h4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB2641C000D
X-HE-Tag: 1782312013-958694
X-HE-Meta: U2FsdGVkX19J2Cqp+mMLLXa9oAs+NS7LYZk+LlH1BU4Yb9a/pPWqtPJVLEcBvIuu65srxL6Fqe/ejWUgjOKzQQPWv56KMnAcuH5yoA7O3rYDByc7ITmB20ba6qs+1sfm9Ac13vnmwgUxlmYPJk76MBVEE08q63VIpbIeKFmus3wKo+bQL4XpxnDlyHTY263YSWwiGgxFf+oNWosVAYCpUGpGS1RzWGenMy3GTwx5Sd42BHWbBrpckRTGVZzhek1g0hcbgwdN7zA+v/aYtAUBXT11Dxw2dQv0j8FG38XUAfzLlMz5onyLOdq6XoKCEVgQLZiQUQnQlVNntG5K0krllw0IIGkofplVPzjP3el0nke0r0ReHVqrGTbXqrt6y83Enqso6LltmmSzi/NWuuuZSJJ4ryDxmKXxanBk9JsiAu/C0F9HLd6TAqTnq1OJRPQ5Z1IKbM0ERlSa0OIzcS80rBNTRquD0jf4d//j6g0qsVKPx5ffZrCIF5O/AC3DliLD7yzhK9zl3BFhoQUjmlfPTBxWt8XbxF5qWA3wV0w13MWCopomRO4hCkdcOUY5Az2ypSAz9Eqd+CQjBJVdht1Pd2HWxLKTt70FcF4EsyEzK7Y0Ap6TjSVtjfrGald8yM19WOQsC52y8IrZj4hC9akUjzElp2lJzSl+pOxAYuH2yXJOcg9UyPdRhplxfVpITvJ9Qwisx0EYZgxUx3bAWHUWoR5+AG93G6qJsltFRjg+puD9rIeEij/h0Alt1swhN+1X6lMVoYsAogbM+DzTrYJx3GSPEMYSOaG6aIY1VYlNTmmanlvCJFe8EOm0VAVTEojXLKbCTefSLonvdJGY6DjdMZQG2RVky/xTAXcGSbNvYOvbEkoXpiAlsJnIRVvQTAdxW8mkM9l0lHLKauLIxYtpVynQ8VMFAtuGonV9pSrqnwhh4y5E89XuoTIskg5YXHCuAIXzUjVqg5Dd6VMUMKw
 xYc27bCn
 c+pRw6m4OMT/RnUvtq46ZxaicQX9cUTrn51pF+k+T2FTTSUTfvGoGVN7Y2mnQWzt+3Uv3aiTQcnyrEXtUYzm9PoZ8bWVkL379QZy759MG4f+h7WPrF8rYeZWbKD3Is7tYX76wi1j+NlPXYUIWglTUDDNShq55XvrHQXfS89BGg3ijA5rkQf1RBvBiV0s82CpHFo5VenPg6MopGLTXRTxoPQVaGmARhBpMnZ39HvCMb1yqmHLkE8uNtN2nT3slInc6SKvyRNnooE123J7I0Jx+diDvfsG42ahiJNTAc9nV2bUDDgLuBpUHODly5ZEa37ovp0DrRtKYDFAZ+aHxlA4ol+ygSwDf5oG1URA9NXaGcNQulqUprvqoV+vnaOt4w7F+cz0lOxMninEtgXsAgyBHa5aSWwtEj5mhBH0d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:01=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> It's confusing that the function is called "nolock" but the flag is
> called "trylock", align them.
>
> The function's terminology is more visible and has more mindshare so use =
that.
>
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f07972=
a1@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

That comment for ALLOC_NOLOCK about only using spin_trylock in the
allocation path could be rewritten to say that no locking or spinning
is allowed but it's a minor detail.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/internal.h   |  2 +-
>  mm/page_alloc.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a20..1483a4fcdfce1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1475,7 +1475,7 @@ unsigned int reclaim_clean_pages_from_list(struct z=
one *zone,
>  #define ALLOC_NOFRAGMENT         0x0
>  #endif
>  #define ALLOC_HIGHATOMIC       0x200 /* Allows access to MIGRATE_HIGHATO=
MIC */
> -#define ALLOC_TRYLOCK          0x400 /* Only use spin_trylock in allocat=
ion path */
> +#define ALLOC_NOLOCK           0x400 /* Only use spin_trylock in allocat=
ion path */
>  #define ALLOC_KSWAPD           0x800 /* allow waking of kswapd, __GFP_KS=
WAPD_RECLAIM set */
>
>  /* Flags that allow allocations below the min watermark. */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0111cdbdb5321..6c4eb6908bd95 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2528,7 +2528,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned=
 int order,
>         unsigned long flags;
>         int i;
>
> -       if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
> +       if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
>                 if (!spin_trylock_irqsave(&zone->lock, flags))
>                         return 0;
>         } else {
> @@ -3216,7 +3216,7 @@ struct page *rmqueue_buddy(struct zone *preferred_z=
one, struct zone *zone,
>
>         do {
>                 page =3D NULL;
> -               if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
> +               if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
>                         if (!spin_trylock_irqsave(&zone->lock, flags))
>                                 return NULL;
>                 } else {
> @@ -5042,7 +5042,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_ma=
sk, unsigned int order,
>          * Don't invoke should_fail logic, since it may call
>          * get_random_u32() and printk() which need to spin_lock.
>          */
> -       if (!(*alloc_flags & ALLOC_TRYLOCK) &&
> +       if (!(*alloc_flags & ALLOC_NOLOCK) &&
>             should_fail_alloc_page(gfp_mask, order))
>                 return false;
>
> @@ -7786,7 +7786,7 @@ static bool cond_accept_memory(struct zone *zone, u=
nsigned int order,
>                 return false;
>
>         /* Bailout, since try_to_accept_memory_one() needs to take a lock=
 */
> -       if (alloc_flags & ALLOC_TRYLOCK)
> +       if (alloc_flags & ALLOC_NOLOCK)
>                 return false;
>
>         wmark =3D promo_wmark_pages(zone);
> @@ -7878,7 +7878,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t=
 gfp_flags, int nid, unsigned
>          */
>         gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC =
| __GFP_COMP
>                         | gfp_flags;
> -       unsigned int alloc_flags =3D ALLOC_TRYLOCK;
> +       unsigned int alloc_flags =3D ALLOC_NOLOCK;
>         struct alloc_context ac =3D { };
>         struct page *page;
>
>
> --
> 2.54.0
>

