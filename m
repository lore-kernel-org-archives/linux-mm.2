Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184ACC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24F546B00A6; Mon, 20 Jul 2026 11:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF356B00A9; Mon, 20 Jul 2026 11:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA616B00AB; Mon, 20 Jul 2026 11:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9AE46B00A6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:57:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E72A1A04F6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:57:36 +0000 (UTC)
X-FDA: 85009610112.08.421CE9E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED793C000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:57:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FpXOhmIn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784563054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KyJzAdpvvNft9Y4h33/V64POIpIo0Lhh3rE6JSsSJM=;
	b=aH2NukXm3J4QgjMqME8Zw//q+c61Kj3ZMGynCQygS5ygvh87HgyFjowBbNn9HhB7WH5ePe
	sBv5PjrQm094ZPkz69B62aWBdKIAlPifkCxW72M8Jv3csvHddCxiL56MxD1/bnW3yOoro8
	IjH73eKxOeDJVSLhnCj32IOqliw/ox8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FpXOhmIn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784563054;
	b=mP2zCpl9D4fh4zO/+C6rKIIm3Aou/Zjxwb/dIOLkX+3ACRd8HaShrJHIpG1ED1lgAJCoPW
	+oPzROZDPztbLUujEUktLEntEsGNn2qug8megGVPDpLuMLBqk4LWZzkgmfw4a6fUcEd2ax
	FAzEMJ3k7VOl1Hsnmx+qPs6pQZUIA0k=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49558ce01afso13388235e9.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784563053; cv=none;
        d=google.com; s=arc-20260327;
        b=egi6ntRDQYjtlm8pJ5/w2kzmMyQ1u9xu+L4hVBvzUNGkDMsnFXz/VQFaRgb5N0mr55
         kha9OXh02MxpGUOaWcjCgxvQ0uyu4lMmZ1H0C6NfxZOL1YA+xjmpMm9vmB/UrEXV6c8Q
         jSNFLsFqGc3My4xzncoeOV7hehhakHovlwYl7I3Pj765xrBJSTT33Z35Bpwk5jsGOA5E
         DOX+ylf/Ezm0Ppl4v9kkj1nI1s7M3Nnu3DpmJEvIQ6wQ7jZOzI3qJJfSqR4DK33874D7
         jAobXWLxTmF3dzCkncOgBBE1PXURDIAFLh4hfGwbYS/mXZ7TtFXxdqtksqdLFOmi7Mn0
         uldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0KyJzAdpvvNft9Y4h33/V64POIpIo0Lhh3rE6JSsSJM=;
        fh=FVvwRYjfz7/vx+uzCxKf7Xr1STrCjvlfUthu4imdOHE=;
        b=PtRF0x66R+FimaCTaBsGFy2Gqvsc/b8r1kfz+2iB/Nn74pLWTRwmBw8IfJ+qmJpo3t
         pfBLFqrXGjyu8CxOZ4jBT5bgE9l48A2HnoynXUfSkb+I2jRGZ8w/tsp2M1Sbz+aJnt9W
         V9fT2fOHbImYmAhJY9nmTCtD8hjxzXceA8sPt624YCz0cA1+ma02zta+i+Wgmsgurup2
         ncTYrChlJs1vLuSDKr2DWdzaH5dId+JRHS3Nx39TcXJzj7hfCksdPU7hspKT/8s3wE3i
         3yyHGjLCY3njxzwmEx3dLXmKqjzHV2Hha4HADGl1S/UA0iKSXmmE/gu39Ca/JYspNYa9
         Hn8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784563053; x=1785167853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0KyJzAdpvvNft9Y4h33/V64POIpIo0Lhh3rE6JSsSJM=;
        b=FpXOhmIn5nmLNa6cxO8WIWIeRpzeesxyj14TF7I28RGM+0zkfpv5bL2FYJPDsyBP9f
         ozO/N2dJu6yEfvDAaoYiUNbE7LRAHnn9ahCp07jGtoOKvfs+S0xx538+lW+HCobJRY3S
         yWlPpC6xSXtimjNmYVxIokvVtZuZquDiovqCGJzgpHondEBUmVt4DjYItDdl97/zMS54
         1LetQgRE6nUUNUL3u0LtxOPJSYlH9gnSSQrWHxSs5uePhbfInItrr7fqBdHfJk3wV54n
         cINt61k3KRWya2T5QvcR24KkwkH9IJ5Hl3c24H5QXEVgTLYWAkMOdwtDvW1pCyxBsogB
         qeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784563053; x=1785167853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0KyJzAdpvvNft9Y4h33/V64POIpIo0Lhh3rE6JSsSJM=;
        b=Yc8yG1QaZKRAsiF4mDxEAOARFJFY+XNT+FSvDrxBtMLON1R2/IhdyrfZBNvSWJ/7uB
         GjY3DXfyR+YPtTCl90rQMUr+yXtDseqz0a3+DNb8TxrrffXrMiJ1GvlPiduHu9YG1fSs
         yyqq0sPg6CBXNd+qW6uX/W0io6ab14oA3eWNnoBO7xmjbACeSujLgJyUXIS8h0E2YbZ1
         HHB1h6zfcR6SCveFYlkQZnVNSDQrsmXSsEXJUFoBHK4/QDcOGxtnoCVZVK5kjbXkBz+5
         bNE5pfJtZ0uG9AmbXzzTouYlpKXOcN4WpO/gZiEQAaQl/tVrWfMAsbrewzfst46T0cCt
         EcOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpGhgtTgn/Q9as2gm3vlWtAFs1dSAqf3/FU7P0tKwfRn/Uv6gZoLA9KwqGuVk0ZAWy6RE/pQIhBxg==@kvack.org
X-Gm-Message-State: AOJu0YxWVs9TjbIb9CQ71cUFL2RFqKweO9xHybeehQkYJ8X/+Y+LVKQ8
	A06/kVOlTQzZj7FmXBE3w7L3+SgxKxZGUi8S9IrdW9/UFkwHlaIqsRTjQmrYz/X9pNHLfAmzvhS
	2LrmwOfdhSMI8GJHSjMWkHVcxLQZAqN0=
X-Gm-Gg: AfdE7cntjy8rN380DV68SWWa/Oq34LqR738gOCooDdTKHf3fnjqVSVOK/7xnraayolH
	uTQ5YUhfnUZ28QkOOWdjZ7kaxY3y9KM8HMshFoZXGVHfUUxZV3lAHubDXm+tkYC2ljIkJWJSibM
	lbfWyNaQinq+JhtK5SzbkSe0X76UFJ+l9tcIaSw65DEb95cuOMObSWlKnh63Q/9DuMMAZ2d7zI2
	x7yiaVzFQVO2HIAMXkBrnQqj7Hv9ZnTRcUwAxRllYTbvfdBZsOmXhP/ajHd6NK6tSQjmH3YKJZ/
	rxhiU6/0BF+1lBBhXHbmqWL877jt
X-Received: by 2002:a05:600c:3b24:b0:495:5d6d:9cb3 with SMTP id
 5b1f17b1804b1-4955d6d9dcamr68483165e9.37.1784563053362; Mon, 20 Jul 2026
 08:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-3-alex@ghiti.fr>
In-Reply-To: <20260718093723.153324-3-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 20 Jul 2026 08:57:21 -0700
X-Gm-Features: AUfX_mzE9oSx9gAUE_0Haa5WsqXuVdTKlLnp73bYqy-q2AYPJ21KT8MxigUKzsY
Message-ID: <CAKEwX=NY=Uvcfm2BT-HGqu8B3OaoC0eePW1M7fW1qH4wpjQ8gw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: zswap: deferred dropbehind free of writeback folios
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED793C000B
X-Stat-Signature: rd67osqrnzjifd31kz6bzeqm7g94opy9
X-HE-Tag: 1784563054-126780
X-HE-Meta: U2FsdGVkX1/52H9e2hjIX28BSevIj2LwGQuQss5DS6M+R/V01uPg/yb1W/EsR9PpsPCQaDVkVWHVkxtsFJ2/4cWXyBU39XC2m6WceCB3KDMAZUYerLTf+7HBy9nNxbH5MPRhIAFulI7QZ45TrK1H0zWqoHCT767aih7H04mvrrj05byruTwEYpEp5xGauFAFymSINz3v3UByNZRjKqvjms7Ouz53j3BaI3axgBgz9pXCKt73hTLDfeNEBV0fdFLApX+Q/SVSwduYM2lmKngWKKu8w4o0CGJg9RArjXM+0nhwT0sM8J7DE9t/MaWQD3C47qJmr4YrDUwpqymDPJq/bnbLvf1JQ3GgrNWpIYDx5YmKrPxWvDRb2yJxbYRREwHO5ROV2nL1mT9LHZmdEG5/J21DIe7/wRe99dvjvE6W8fUXTX56TQwFcFQZz90ne1VdrGkmmmW9Iob3w2XsbyJrQrPebqhgcSFEOhBHv2nOFHt3lku/IEmvCc5HBhCX0RipWjGgWuS0/cD0308jRg8cF34GZZGpH1Mj0t2YpI6OAXsuOvrelTvKJpdX+5lCtH6mUGqhkKcg0Jwx4yFd7c/fRYdOFX+sc04HNoBtOg6J9vcP2y106cKS+GFVzy9Qe9reuthB3yyJhX9VFmYBUj9bZPImlac3OPfMLddu+NfFaAkCfbReyXywoMh0en4X+MYSHNim4oVNeIOMUNCZkEpsYc3rgYgwWZ8FamO5dRDRe92N48VeabvJC3+kza+1Dst0k2PFS6B9MeZPYNDIyGIembPrVR95raxNckoXRQ4p1OZd71Nv4ygxkYEVrn3l2nKfFGLnsgCMx2v/Dfv/Ijc60kPx5HtIU4HpFHrCDLGi/KCRTQGUwPNx/6Qm2UBDGPrkZd5U1DH8FGvIfytJHVml4dFvC33QAjODiVFAPjD9NchbKbuoKC1Eljh1seCAV42LhEZ28qHo6BTOxJI5wX2
 Pxqy0Z6s
 CU3pq5/+DxUM+5Nubn9Z7t4CyvYdz006LlAGH3RvCrIKByGNws0W76t/M6XWGEz0YGkxt8CmTB2ZgH6FqjIrMVw0aw/nQ+2OwxMMcV29QTuQxI21G6I4fh4nIvDOyqtlv67gChwJSGtvX49j3HlWKLNvOyUujFnUX3O8t7O7TGhKha6k5Jm3ECskiHYmrjogZRWE1no9e3ZOqtG8fslPhJM5U/ksHuajudVCAWlTVO3zMNPPlb7/2RhW6y4sd13A/lT6kaIel/cncyaJ+SrG4RaGW5oijQuHKctuUG7zAlkmTNRkMyR4VPsWJaX/Vhv2Ry+jrhEo0nom0eakeR+BCTxzmyA8ekqv0VHPE+vIoUc/nuySepKmDSXE/p8PS8z9FWqO9G1bIvV+GaV/qVc8eywi8aJGzk3hvbAyDmbUnz80Z1wyhhTX2vUh/pqR8q4LD7zk3ObWR7T3x0b4kRQD5vcuCpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 2:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> The previous change frees zswap writeback folios promptly for
> synchronous-IO swap, where writeback completes in the calling context.
> Asynchronous block devices and filesystem-backed swap complete
> writeback in interrupt context, where the folio cannot be freed, so
> those cold folios are still left on the LRU for reclaim to clean up
> later.
>
> Free them promptly as well by deferring the work to a workqueue that
> runs once writeback has completed.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

No Suggested-by for poor Nhat? :(

Just kidding, of course - thanks for working on this cool idea :)

> ---
>  include/linux/zswap.h |  2 ++
>  mm/filemap.c          | 20 ++++++++++++++++++++
>  mm/zswap.c            | 34 +++++++++++++++++++++++++++++++---
>  3 files changed, 53 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..23dcde274964 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +void zswap_writeback_dropbehind_folio(struct folio *folio);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -58,6 +59,7 @@ static inline void zswap_swapoff(int type) {}
>  static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)=
 {}
>  static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
>  static inline void zswap_folio_swapin(struct folio *folio) {}
> +static inline void zswap_writeback_dropbehind_folio(struct folio *folio)=
 {}
>
>  static inline bool zswap_is_enabled(void)
>  {
> diff --git a/mm/filemap.c b/mm/filemap.c
> index dc3a0e960b9f..548e465b5b9a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -21,6 +21,7 @@
>  #include <linux/gfp.h>
>  #include <linux/mm.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/syscalls.h>
>  #include <linux/mman.h>
> @@ -1680,6 +1681,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind=
);
>   */
>  void folio_end_writeback(struct folio *folio)
>  {
> +       bool swap_dropbehind;
> +
>         VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
>
>         /*
> @@ -1689,7 +1692,24 @@ void folio_end_writeback(struct folio *folio)
>          * reused before the folio_wake_bit().
>          */
>         folio_get(folio);
> +
> +       /*
> +        * zswap writeback folios are off-LRU, so we must prevent a racin=
g
> +        * swapin from removing the folio from the swap cache and keeping=
 it
> +        * off-LRU: the writeback flag allows that. Afterwards a swapin m=
ay win
> +        * the race, but the folio is already queued and the worker puts =
it back
> +        * on the LRU in that case.
> +        */
> +       swap_dropbehind =3D folio_test_swapcache(folio) &&
> +                         folio_test_dropbehind(folio);
> +
>         folio_end_writeback_no_dropbehind(folio);
> +
> +       if (swap_dropbehind) {
> +               zswap_writeback_dropbehind_folio(folio);
> +               return;
> +       }
> +
>         folio_end_dropbehind(folio);
>         folio_put(folio);
>  }
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3c494c5a671c..d185da85bb68 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -34,6 +34,7 @@
>  #include <linux/writeback.h>
>  #include <linux/pagemap.h>
>  #include <linux/workqueue.h>
> +#include <linux/llist.h>
>  #include <linux/list_lru.h>
>  #include <linux/zsmalloc.h>
>
> @@ -990,12 +991,39 @@ static void zswap_writeback_free_folio(struct folio=
 *folio)
>                 goto out;
>
>         /* Raced: the folio is now owned by the swapin; put it back on th=
e LRU. */
> +       folio_clear_dropbehind(folio);
>         folio_add_lru(folio);
>  out:
>         folio_unlock(folio);
>         folio_put(folio);
>  }
>
> +static DEFINE_PER_CPU(struct llist_head, zswap_dropbehind_llist);
> +
> +static void zswap_dropbehind_workfn(struct work_struct *work)
> +{
> +       struct llist_node *pos, *next;
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               pos =3D llist_del_all(per_cpu_ptr(&zswap_dropbehind_llist=
, cpu));
> +               llist_for_each_safe(pos, next, pos) {
> +                       struct folio *folio =3D container_of((struct list=
_head *)pos,
> +                                                          struct folio, =
lru);
> +                       zswap_writeback_free_folio(folio);

nit: I wonder if it's worth doing some batching here for the free step.

i.e, after remove_mapping() succeeds for a folio, we can just add the
folio to a batch, then call folios_put_refs() in the entire batch :-?

