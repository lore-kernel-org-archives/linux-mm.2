Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7669BCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 21:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BA36B0095; Thu, 15 Oct 2026 17:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC076B0096; Thu, 15 Oct 2026 17:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3CC6B0098; Thu, 15 Oct 2026 17:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E24B96B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:49:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78D991A01CC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:49:05 +0000 (UTC)
X-FDA: 85326201450.21.FDDDEFA
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C18740002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:49:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DweS30IR;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792100943;
	b=7yJWKrNXX0uoPx7mr99nYukp35y2Xv7iOGVJcXuUhEZPlpEqfiMqtfJwhk6zQS8celPqE0
	pjoW1aVFbqRV5EtGFF02H6KLRbsQUF9um5sm5Gy0atLovec2yC8K6UXdD5dPP3slKv3BV+
	U8X/Edq6SD4j8JZur7Uj6gR9AJbjijA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DweS30IR;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792100943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
	b=8ab/1jBykwNr8F1TUKxZ6+bfCTo2AMdrdoyEFRZ99bH72fblhHZoivWd69oxjseIv+/blh
	3neO/W4+04Cdpk941d99Z03XDU2KKmOvLhuWhoiT9nXV9LVS92tgfN9uzZur/UEsxagbnB
	D0wLZ8vxHS42yz77ffs7JhwabxpQjTI=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bccc73eea4so485207e87.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:49:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792100942; cv=none;
        d=google.com; s=arc-20260327;
        b=TGfuCZX6BbznBELpD63iJMv0H19TBe+X68pJZoc3enboXSgEnOCCEl7bFoe8c7kQKV
         pvSeYe24wb+tVXEZNJDYCO8Bh0rL4jzK+QC9bp7RSUqRmeK/l0YDcqfUuJbi+tHEbwTU
         C7XOTue7VEgdXGRTHyDcZ8Znb92G6a8M8X1XZxIYeaWiODctg3fvFPoFuxxFKFIDd05o
         isciWVKweJXf9jKGHt7qvKNAEqCs3fBExRkFax7godOtIAGTkbW63VBgrAsCgwsq8SKr
         VrbKWdx/ABh4lbae1fAliOKHw6QWvDSlD0xDEovHml5gfVBnwknvQtF0PZOoyPu0Xzx2
         htxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        fh=IDTimbkUcnqYLlPQmnTP5yNxfg15Pl2tUsIIlUJ4DHg=;
        b=AyVVfCBsWsk0Uzz0f28Dbu+ZdGd22AxKUvOcrGo6mBlWyQYJJFuTJBC/bjRtrTPV23
         0G+nQTP8pDJT44AxYTrsixiRtzKyqW6REzN58G5JJmor+cE1qSSAVv7UgaSnA6/QkKj7
         fzKNCn9ZmyqIccPHEO7q1qKZ8eYTKFmbV/Dz7YW2Bym+cYUpDm4GtlZmE37IRxHKAEhN
         HH+d4jtCZ6LBJiNf9PS/QJE5LcGEGjL/DNk4t2TBvd7QpY8odMKK31H7ptxS0Xdt5v3L
         E/gHDEribqyU6f7xJ6hlMTG8W0+oxYpBfs/L/P03tRXIjCl/DJgQXF++c+eOFdPSK5TB
         m+rw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792100942; x=1792705742; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        b=DweS30IRtYlseknkQfs6YJtUXWTtr4vTRPkjVySc5+XwKDfKp3K4OkvHil6nXchtb7
         vifFfhriXq7Ldr1qOCT8UPAFFqthX8Ns2YtbDdJKtFoV/vF6WRXHG4iHbKiankDTtALi
         Cnk3jaPrdHUnfQlY2M/Nq9/cYhsW+b3fAAVyqQJ2SB1sIaXWt+zi9KX0/kQMQF968y07
         aGzPOmdHKLof7BzzjX/YJB6Nl9YD7dmbkdrmgbT6XeC7/p0AARw8CbDiTr1rkFeZUR9Y
         DFtah/mP3Sw7GTwOSGcVPsTOs6mJmHq18naqeXs37GsSVj/Zbi5fXwVEsjuAOfiydX5G
         Z/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792100942; x=1792705742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        b=BvVZQl0Ao5/Foep/C+diLGhUmu4nmwlp6vC8G2zCkFU3KR9jO+60fqNoUKk7Ls0XuC
         ZzccDYOQYlttObgMQAtvfi3AFGKhB1W1SfsZ/I3ZZRwTVKhi93MCPtIFV26U/MKqUV+i
         h97041tWkCYbBD4zNBZCXkTgFpxy4FcLijWruIuAjirgz2uWXw5Q0kQJN0KLmw1OpWqy
         rdwlCaxjk2u5MLWkmZclEdszyoEpERl2U8+RQ+e3vCg+kfpGFdK6DYvnvHF6LwDVaz1L
         Y5+SB8pnQOCurpbw+oH8ObFv35lLUaMtOkZFP5DJVsfQA1h3arWiOUMcXolKjfAPW26t
         LCaw==
X-Forwarded-Encrypted: i=1; AKwUvBwSAW0rfd0QVXmMEXIa4P7myluW66pzhfrAF3ppNUw1/Tv51LE4Dw+Sg8tYQazewhhqKP5xyXU2Qg==@kvack.org
X-Gm-Message-State: AFq9FYJ/eTZ0MdaKfRXMCBsgmCvv9ntCJEBQyn5RddMTvoaeydTJFpVr
	vlfXfIy4cDm6mAT7+p4pTgWkNkY3o6VwtWRFvh533YU1/vhzrF3WLThaHzRyBsxCORWIpNcXfbL
	E8TdesfVtZrkvG9n5/HY6CLL3GVPyBl8=
X-Gm-Gg: AYBFou3f1pPnQQRaS8p3dz0rfX+OXazjlNlcQPKuuRy8JOvLH0SAjj40qmrhF1svgE3
	wuR4rAdkMRSUgV/61GtXDM+7W97XtbqDrqb9NAl5httcLlL5xKVGussxMTJiT2Pci/zdiCP/27M
	RxiV6w7sY2Wq9XnPDIZWH33XZ1AolEnByY16StorrsPbKY83VQDgTjxsqbe5vUXNhdB3PMCPnz1
	r4pIiKK2c6UFP2pfIbHCz2/PS86HB1aNNdYJ7DPBVXlfRFKGJxlt9gFiukZ0Khb16AWbaq0cHKe
	Y76xdhABvD7oPRKLIEr+GEo3mfjTexlG1a02sR6Qe1y8zHqgOO8wQDU=
X-Received: by 2002:a05:6512:6c3:b0:5b6:10bc:dc44 with SMTP id
 2adb3069b0e04-5be47919a66mr371981e87.27.1792100941493; Thu, 15 Oct 2026
 14:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
In-Reply-To: <as-izeIj5bP01bna@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 14:48:49 -0700
X-Gm-Features: AclHuK9kJdMeQIt5SjytQ3uY2AY9vgRZt5bGu_tW5kkaC9v8cX-axyE2p_KzZ08
Message-ID: <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C18740002
X-Stat-Signature: ryzampn57g4wge18nnp6r6ysadrhthi5
X-HE-Tag: 1792100943-863251
X-HE-Meta: U2FsdGVkX1+Y0iBeK9Hfm39f/jWW54oZlN27upn8MyFn01hGswnboasqc2FUuJ5cSsz0eitDcOkDtAWKGeU3R/QYGKI4gQJCIkCytjrIK4EsJIBFzU6aSCFKG5GbBOHh5eZS8Ame3psZj877bXhUQLszzPZRwHHNaUY6rs0S15DtiV/Hnyh87gxpGnG0Zkc5P9CHi0K2dCswQV5Cqv8ItFrP3s9aPRtjKVwQLDVAzBFP7hvK3504HxVs7kOjAc1Vt3gIA7e5CVFlOSc9BGHZ7iBFSDsEfzAFn2Goqm38MkX4HLOaw1rHCwXM0DzMnvWd9yqsrXTy2Wvwzuq8F5uX7EdoKVCGwzY/rHxcUHaMi5WZ1434nWiVmXts+J7QysnQAJImRgr6YdwfS2u1/RV8Dz4uIzmtMKFJGwkuCc3jPIRtoE9HFazwla5raEH2BlrZ1dSzNpvGHDcFtSI/JaNH6lziBpKEia8A9BfKzUaVt/HGhujdVxsv+9q50ernFfA/ZKNnKDdocAxZUmR31bhwTYVfX2NGRXGr3FTeI14s7+1mXnL0JEu/0eJBvMh0auKVBBvcWZ/VOYv77eNY4Qa61TgYJ9ApsGytgDcm0jgfTpqtufay8hu+nk8AXTskmd7M82raqB7yD9vhB9ztptW3syF5YuSPpl/nZBamXDxlyp0dJvVxP6uLJLLgUcUZ9+KMnXG/5HzbxXMWoCUcF9NXj627mt2M/9yly9VhPsXmew+MbLdrYmZ1avxa0nGNaVPBunDQx2/oPXqnUiiF5TgkPwGN/D4weuf24C1l0jJB1EEpw2/c1RmKlP5xqnGvY+LMzha/7+heFBvBuZw5Zmo+XpYCcI/Q0QROa5YWRh1yuloFSjrCulv6DSElRfbB0K56SIjdgC5R9rwL1yzbbzAl9xpbVn259WeyNAgS9zyI+NiQuCXLC//QUn4w1McWjxgjvV5QubPb8+earp8wfHg
 +vNCZy9j
 e/6PlcDeVA+nP7T7z7R+4MIqiM1q+eCpVvz/ZIAfF31F4ejji9Bc19WFeRl9wNtcayGqC4dlMcXRK+MfIwNm0sDDjr347FNthRPfd89WQI5KX8lrjzeJyQEF5L9YaTUZUAXwM0+g9DifuOaCegpTfbU1cJMWMZCcjGZkFNN9JPqQSR266xKDJ3A/UCngwZXyjcKx6WiHfSRTEjRdy+5eW0XV7cpkeZk4P9GSB3f91jOnWMQot3xKmSaGXO/oH27E6vBvd7Lh9Ha1vLx38ihULWCUPJnoR2xaor6AgvYYxGGp/RjZA0P/nYeCZezmSjQTmJ57txZ9X8dfeIc1dyksixn+LRwQjMpyEaQgrNgDiLqU9c5tW3lKHX8ueRHBJwhPZXOxSfzZkp6likRS2aLWDy0fbAtuol+DDHizmmIs8+ziC9BSUwCk7YOBo92xGoyJmtQejjNTxjsdNvXnV9vzscdEvZIh0xiPLKoBbW2yEeCK5Wax/ng2w3ZYp4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > Place and align the members of struct zswap_pool and struct zswap_entry
> > such that members used together in compress/decompress hot paths are
> > able to share the same cacheline. Minimize holes within these structs
> > while doing so.
> >
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8ae67fd10522..ade84ac4076e 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> >  struct zswap_pool {
> >       struct zs_pool *zs_pool;
> >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > -     u8 compr_batch_size;
> >       struct percpu_ref ref;
> > -     struct rcu_work release_rwork;
> > -     struct hlist_node node;
> >       u8 idx;
> > +     u8 compr_batch_size;
> > +     struct hlist_node node;
> > +     struct rcu_work release_rwork;
>
> compr_batch_size is added by this series, why not just add it before idx
> to begin with?

In patch 0006, where compr_batch_size is introduced, I was attempting
to place it in the same cacheline as the acomp_ctx. This increased the
size of struct zswap_pool to 248 bytes. I later optimized this in
patch 0007, bringing back the size to 240 with the addition of
compr_batch_size.

As things stand:

Baseline mm-unstable:

struct zswap_pool {
        struct zs_pool *           zs_pool;              /*     0     8 */
        struct crypto_acomp_ctx *  acomp_ctx;            /*     8     8 */
        struct percpu_ref          ref;                  /*    16    16 */
        struct rcu_work            release_rwork
__attribute__((__aligned__(8))); /*    32    56 */
        /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
        struct hlist_node          node;                 /*    88    16 */
        u8                         idx;                  /*   104     1 */
        char                       tfm_name[128];        /*   105   128 */

        /* size: 240, cachelines: 4, members: 7 */
        /* padding: 7 */
        /* forced alignments: 1 */
        /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));

My latest version makes changes to struct zswap_pool in 2 separate
patches: the first introduces compr_batch_size without changing the
size, the second optimizes for hot-path members' co-location on the
same cacheline:

struct zswap_pool {
  struct zs_pool *zs_pool;
  struct crypto_acomp_ctx __percpu *acomp_ctx;
  struct percpu_ref ref;
  u8 idx;
  u8 compr_batch_size;
  struct hlist_node node;
  struct rcu_work release_rwork;
  char tfm_name[CRYPTO_MAX_ALG_NAME];
};

struct zswap_pool {
        struct zs_pool *           zs_pool;              /*     0     8 */
        struct crypto_acomp_ctx *  acomp_ctx;            /*     8     8 */
        struct percpu_ref          ref;                  /*    16    16 */
        u8                         idx;                  /*    32     1 */
        u8                         compr_batch_size;     /*    33     1 */

        /* XXX 6 bytes hole, try to pack */

        struct hlist_node          node;                 /*    40    16 */
        struct rcu_work            release_rwork
__attribute__((__aligned__(8))); /*    56    56 */
        /* --- cacheline 1 boundary (64 bytes) was 48 bytes ago --- */
        char                       tfm_name[128];        /*   112   128 */

        /* size: 240, cachelines: 4, members: 8 */
        /* sum members: 234, holes: 1, sum holes: 6 */
        /* forced alignments: 1 */
        /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));

>
> >       char tfm_name[CRYPTO_MAX_ALG_NAME];
> >  };
> >
> > @@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> >   * nid - NUMA node id of the page for which this is the zswap entry.
> > - * pool_idx - id of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> > + * pool_idx - id of the zswap_pool that the entry's data is in.
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > @@ -214,10 +214,10 @@ struct zswap_entry {
> >               bool referenced:1;
> >       };
> >       int nid;
> > -     u8 pool_idx;
> >       unsigned long handle;
> >       struct obj_cgroup *objcg;
> >       struct list_head lru;
> > +     u8 pool_idx;
>
> As mentioned previously, this needs to be packed with the length.

Done.

>
> >  };
> >
> >  /*
> > --
> > 2.39.5
> >

