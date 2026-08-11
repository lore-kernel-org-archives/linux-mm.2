Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF195C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1BA6B007B; Tue, 11 Aug 2026 09:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8EC6B008A; Tue, 11 Aug 2026 09:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0016B0092; Tue, 11 Aug 2026 09:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84A266B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:56:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D41E40442
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:56:13 +0000 (UTC)
X-FDA: 85089137826.14.4D29340
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2B7F414000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:56:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OA5QFxd3;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuYy8FuJr7DliQIIV8888xSQ1tmR4U5LYUTVgrl5KMI=;
	b=ZFR7hMequCdvcCj/Csfvvit4uDZK1T9+Ay57FSWVWjYjzUDnuj3bVUmsoIZdrofFWXZdPR
	zq0uJ9VsafhZVs3xnAOswMBdIoVZcENwEEE10ad8pREDzLJ9aWvHjwwJrNv2HagjicyiL2
	hB3j48ESBxbEmVu7wrF51A7Z/+fCDw8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786456571;
	b=TwUaNiwQj3m71JYtNYWGarjXP48l55b0gqfiy5CbuZ3MkxFnPq7gLxfbB3actzCintvbHf
	AZu47sXvfXGF8uoggQ0MA0cA7tXH3dUb1A8sa6D/Nn/fx6tdlsG7w4O+iqIRuDVH067Jej
	7nLRh3zNFdmTMmBLkb7AuBu1SCrIBOM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OA5QFxd3;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b021916bd3so3601828e87.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786456569; cv=none;
        d=google.com; s=arc-20260327;
        b=JSND8pULs3Qc025jtIS/4T9rJcWKn1ui824+qc4tXnaTz7PJsu6XB6+BwZ09FPFi5Z
         eMiUEfH8b+ONqctI117/B7LCS/EeiLji59kOwKuiV3/ZKDx0RTt1Dfk87GXkPdwCPTHb
         Y2fKTMBAQUpdiUQpK4IURyoo6JpucR9emyOHI7Pvs++jgXE7qV/1q2Bxyjn0ezN/0W6W
         mnECBRI7lM9Gw4Zsuy8gVfUKFEhzIPk4aTZx1d42HJt/E/46jCItZJPSdZ8pWt36nsq+
         HxlqKPlOZHdquXc62wXNZOnF/xAoAt8oYHc0jHzdjYMu13kMD2YyQ+XtiyC1wekVm74u
         7zHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KuYy8FuJr7DliQIIV8888xSQ1tmR4U5LYUTVgrl5KMI=;
        fh=FnTeqw5Sda9ic5PBHx80WvyTnZ/LRzXghBjE4EN16bI=;
        b=X/GxuaPQDOSmfYAAQaCtgUKY0kWccJluJT13WnzhdD+YghQQPFCKgHWAYhgBYkDvmp
         ZRejvNS+yvfzKLC4EbWur90eAEF5Z888V1SjCrIhaTLHTGyKnNKljkB978j5ThWu934O
         lZsnV6kusX4oGUuQL1rT6WIf8YvbKPlPkUsMYmnbUgQixuN4P80ug9igo/7z+eSI5ctJ
         PGEIzDwhN97RwDIcQ1breGGhjCDEM8ufNhSrUlJivsZ9cLdva/mZ5s7N5vwG9vM2/Kes
         rN+6JzUXT506iLcqS+uO2a1+1zs2c7rNeDI/L3x/7jMrOIIwepaso5M6i4gK4PPxlSj4
         1S7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786456569; x=1787061369; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KuYy8FuJr7DliQIIV8888xSQ1tmR4U5LYUTVgrl5KMI=;
        b=OA5QFxd30IDfCKrFInBQmWCD8M/ZbJOMwqpYc1t4cMTysa8cbxgmDJTE4To8s3nmxD
         tLLr4hYN3lmbWcEnA0r8sAh4cWCkZf2PtPPALAq8fejCcoWUJ+WB6A7rL1F8YD6xf818
         8qQEjJcc6Hwzk99o6mAffFnrbjcuONikPHAlGVJG7Q1yZryfwiKOceM0bUtbxpD8vWIV
         VY6g+wAMZqi8xm0Ym8eadOzS/4FsVJwT1g+FhzWzzuT2TYPw1klMF2cxszF6peYFx83Y
         QfHqkYv/McUMLmC2HLM9EA2AnsUBPtBQy8vjz7jWSH82r0Z+lhc7hWwEBj+/Z/Ai1UEb
         P/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786456569; x=1787061369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KuYy8FuJr7DliQIIV8888xSQ1tmR4U5LYUTVgrl5KMI=;
        b=CdW/4zHJDyvlUuNkJ/e1D5OLu4aRACVlsK3ktOjg009EFL/z70yne4jBdEMScROE6A
         nkXUhJ5FBuMDKUJKEjSpf6Q5b1JOBZ7lxbAeYQ9Ze0HifSfGmROWPvOVi8r9FM8b16s5
         M9MC6oU9dec3Eg/KPA/UohQwHo2trJ4uXumlMiJx+KqRCc/q3lmM2R68zB9n0FgyEGhf
         Z9YgaY54f+O3UiBTpPTTSCHNtI5/lyKHG+/RhdP/5DA1dz9cKFDphJ7o3Ygqd+AvAW+I
         MGbNpFSm23U/d2Hew1usj6K1txAO4JFv2AOHBS24ky/h28gz34yHtv64rETISte3tyia
         +d8w==
X-Gm-Message-State: AOJu0YyGcoo+m7UAxDuAMt2Z1cS1T4RSFEI34devz8wRt9SZUszFExS0
	zCTgvjwFFyjmAfKVY6yTcg7unj0IBNEPRTP+faAwuvfi2mUL3pyK++h1FuGFMoItNONUrCGPDrm
	3LSyUodRWk9AYkMnTAdr41VgWweNP/Lw=
X-Gm-Gg: AR+sD113wpPtsDDt7/cMHh1uAuBOvfE57dxoTjvMc5iTlh6eo6N2axq5JWUK9ITYO2o
	z6NZTmhoAfNoapF4UkaTCCBsmdLCTPh+IQElBeRnA4kOPvM3Gg+mbrTegni9ps0nLWRrKMYBaZU
	RIu2yeWKckpsbmR8cvMKG09gr0xUWw0ph5cHAS381f/Q0j6KZ5B6qE79/ExvMJKXeTwVeOPyazY
	Akh5nJmxuFIQtY5gsQH1kaA+Glqemy4R2R3JI7sZ8Kk91/74pol+eWZHAp97HAHwqmvtHjTrOeF
	V/lWjuVheNEl+nu8cQ9L9YpmHOOjj/Zs74kBp9XECcBwpTWOfVSSQaFAqVGN+QxFdnnpq8W2ZVk
	3RObWxoBh
X-Received: by 2002:a05:6512:3b82:b0:5b1:5a90:25b4 with SMTP id
 2adb3069b0e04-5b448602617mr601874e87.19.1786456568904; Tue, 11 Aug 2026
 06:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com> <anpnowepnexrNea_@google.com>
In-Reply-To: <anpnowepnexrNea_@google.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 11 Aug 2026 21:55:56 +0800
X-Gm-Features: AUfX_my2v15-obhgPi2ojZ0MvlbGd-5o9mqJhOjkcIewTr4Uge0i_1aSVXQxeIU
Message-ID: <CAJxJ_jgBK+jkGztHevvGiNx1YLVHdHqnwVenycx9wd-3Vffa3w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B7F414000F
X-Rspam-User: 
X-Stat-Signature: gjzg1dax4j5wgkpuks76dxokrtxteduu
X-HE-Tag: 1786456571-80511
X-HE-Meta: U2FsdGVkX19VZw5W5dEfK7KMhTwFKnz86aOYLUzC5jLBeDPP2ao0Z0F+U4tMvGHyfoHdsyZdrp9kzGzfcY4uBt5/+g4S8eI55g/p+yXVzhhLPWTp95M9BS5wvuIDvCZa7BtC04Wm3XzsjIDDNkTp3Zl9055RzcnqXtR/1MxBuSDskQdxwVTAI8mYT5sExkIVabZKqLUD+CkJ3Wm04fRgCug6KmGnDWNw2BDJvbp3e7aKcqRB2usOCqFUPDE4iU5lO8JP1h0+kh2PrcBfgzSh8eXTRrVXxTfYS7n9tQAX9gjwzGNXjBDVSif0IGHMz8BQbCvgZ1CHwu3OyNKVRjDsbookpFTeLOZ/7KEwYQohjOMyyvEBI42I0Y3Y3WYTERXeyd4zjzyJ8NB7XuGBGarrT5TNjVzRSEQ5ayvwt7PamwYnYhWeleypfwo7eyJcfR8NtzCvOLTG8223kxgmdynFOlJiti16pS1IKwSCACmgmgXgnzuzh/xl+J7+iM/T1EBmG8NXZqO9twDHo96TL0DsdxxQ/aW/BKKWGsArenOS/2Vsw81YDyHlPODo3HHcDDkK2LNnbzSbmuUPsYLgHJ0DggFWIY4PcmHdxKXDKvutD15kwbsNXF3Z/OQjG0VolQr/E6WQLOxBEDKhdAkd48oX6RUi3Wiafmk7Sxr4G6gqdXNWWW9sP346tZONJZNJfirvFGcTYY4hbeix6/JmlOMs8xm+znrxcAoBeAr7AISqyTwfxjxQzRLlGby5uueIUYAKP1q/X1wbplh4K2m60hvWTQDfNFcKHfMhcxoKfP1443nGWsPSvB/QLA0QiINkG/bEqpUkIaul5gBzwEspg1DNWkWpH2MLtgOHuUwfjgQiQ6KqnEiQfanHxRetYVmF6afg0wHWEqmLDxFkvsB2CZYz8n5zvlcztC4RWQQxI+OmJppbOUUvxuIFjRoZbUzhOUktIwLwDOHndssABr8jErS
 OWc0P4qc
 HI301tpXeoOKl/3cHAxn/F5LQDlSu1i4HvdrtyfLRGLWLp4BkqPUFF2X1EjHS0E6GHH6HunLzFsy7s+RgR9w163Wgi/dByYv8Pya1H10qNew/Jh1uXMFaaV4RebXj3E8k28Ef+HcVMCjHWaiVX8pLyeve+CxsUbaSHzvfh7SKEBWZceIAFk1+G7QEnMreBaKv0weg9Wf2Z29l4OLqOdQO2xGiOWDg3oEgcoxzHGrTKCSVnOLmKr5zsn7PSnTpVDiqMwkBPdcjWl05nFNsOYOTqY8UC7OLp01waJYbuC8FbPfIk2a5q/4Bxp707RYZWf+Hppt53XX3xGuWQmJKbVjFIVyzDE/cFoYIzSo0BL+wmWGnpezgYY/kMv0IfFPvKKfzlVNoJNbicR0lvgQHd4xWTVPtt/btddic8gegc7LE9MtzIJ/uBm03HohFfAYIakhGt6QBdlNuv+yXAXqWgf+nQgEHTJYmP2eq1WpUPXIx0T9R1gfQwXheUpEo9fgXWAK7ukVOnGsS4FR/rj7CjWS+54et3eyhwebZGn+yOmGluM+Ch+tqyj7bAPxQru7XMi4BS20w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 8:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Jul 31, 2026 at 08:32:47AM +0800, Jianyue Wu wrote:
> > Originally zswap holds its pools on an RCU list whose head also serves =
as
> > the "current pool".  Only a handful of pools are ever live at once, sin=
ce
> > a new pool is only created when the compressor is (re)set and pools are
> > reused across compressor switches.
> >
> > A later change wants to store a reference to each entry's pool in every
> > zswap_entry, where a pointer would cost 8 bytes but a small pool index
> > only one.  To make that index possible, the current change holds the
> > pools in a fixed ZSWAP_MAX_POOLS-element array so each pool has a stabl=
e
> > slot number, and tracks the current pool with a separate rcu-protected
> > pointer.
> >
> > The array keeps the same RCU publish/retire discipline the list had, so
> > lookup and teardown stay equivalent.  Newly created pools are published
> > into the array before they become current, so zswap_total_pages() can
> > observe an empty pool briefly; that is harmless.
>
> I don't follow. A newly created pool is empty anyway, so not being
> iterated in zswap_total_pages() should be normal. Why do we need to call
> this out?
You are right, zswap_total_pages() can observe an empty pool briefly
is not needed, it is obvious.

> > This also caps the
> > number of live pools at ZSWAP_MAX_POOLS (16), which is plenty in
> > practice; pool creation warns and fails if the array ever fills, and th=
e
> > limit can be raised.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  mm/zswap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++-------=
--------
> >  1 file changed, 67 insertions(+), 21 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4e76a4a87cdc..b203934d3be8 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -154,12 +154,20 @@ struct zswap_pool {
> >       struct zs_pool *zs_pool;
> >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> >       struct percpu_ref ref;
> > -     struct list_head list;
> >       struct work_struct release_work;
> >       struct hlist_node node;
> > +     u8 idx;
> >       char tfm_name[CRYPTO_MAX_ALG_NAME];
> >  };
> >
> > +#define ZSWAP_MAX_POOLS 16
> > +static struct zswap_pool __rcu *zswap_pools[ZSWAP_MAX_POOLS];
> > +/*
> > + * The current pool (NULL if none): an alias of one zswap_pools[] slot=
.  It
> > + * always holds a ref, so it is never retired from under us.
> > + */
> > +static struct zswap_pool __rcu *zswap_current_pool;
> > +
> >  /* Global LRU lists shared by all zswap pools. */
> >  static struct list_lru zswap_list_lru;
> >
> > @@ -200,9 +208,7 @@ struct zswap_entry {
> >  static struct xarray *zswap_trees[MAX_SWAPFILES];
> >  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
> >
> > -/* RCU-protected iteration */
> > -static LIST_HEAD(zswap_pools);
> > -/* protects zswap_pools list modification */
> > +/* protects the zswap_pools array and zswap_current_pool */
> >  static DEFINE_SPINLOCK(zswap_pools_lock);
> >  /* pool counter to provide unique names to zsmalloc */
> >  static atomic_t zswap_pools_count =3D ATOMIC_INIT(0);
> > @@ -270,6 +276,25 @@ static void acomp_ctx_free(struct crypto_acomp_ctx=
 *acomp_ctx)
> >       acomp_ctx->buffer =3D NULL;
> >  }
> >
> > +static int zswap_pool_reserve_slot(struct zswap_pool *pool)
> > +{
> > +     int i, ret =3D -ENOSPC;
> > +
> > +     spin_lock_bh(&zswap_pools_lock);
> > +     for (i =3D 0; i < ZSWAP_MAX_POOLS; i++) {
> > +             if (!rcu_access_pointer(zswap_pools[i])) {
> > +                     /* Set idx before publishing so readers never see=
 it stale. */
> > +                     pool->idx =3D i;
> > +                     rcu_assign_pointer(zswap_pools[i], pool);
>
> Sashiko points out a seemingly real problem here because we add the pool
> to the array before actually making it the current pool.
>
> https://sashiko.dev/#/patchset/20260731-shrink_zswap_entry_v2-0-0-v2-0-e7=
2083aa8734%40gmail.com
>
> What if we just reserve an index here but not actually assign the pool?
> We can add a marker to the array or sth (e.g. (void *)-1UL)).
That's a good idea, thanks. This is a real race the list version didn't
have. Publishing the real pool pointer at reserve time makes it visible to
zswap_pool_find_get() before the pool is committed as current. A concurrent
writer to the compressor param can then find it, take the else branch,
percpu_ref_resurrect() an already-live ref (hitting
WARN_ON_ONCE(!percpu_ref_is_dead())), and go on to kill what it believes is
the old current pool -- exactly the use-after-free you describe.

I'll define ZSWAP_SLOT_RESERVED as -1UL to claim the index at reserve time,
the real pointer is stored only once the pool is committed as current,
under zswap_pools_lock.
All array walkers skip the placeholder, so a concurrent zswap_pool_find_get=
()
no longer sees the not-yet-ready pool and the resurrect/kill/UAF chain cann=
ot
start.

>
> > +                     ret =3D i;
> > +                     break;
> > +             }
> > +     }
> > +     spin_unlock_bh(&zswap_pools_lock);
> > +
> > +     return ret;
> > +}
> > +
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> >  {
> >       struct zswap_pool *pool;
> > @@ -313,19 +338,27 @@ static struct zswap_pool *zswap_pool_create(char =
*compressor)
> >       if (ret)
> >               goto cpuhp_add_fail;
> >
> > -     /* being the current pool takes 1 ref; this func expects the
> > -      * caller to always add the new pool as the current pool
> > +     /*
> > +      * After a successful create, the caller makes this the current p=
ool.
> > +      * If the caller fails, it kills the ref to free the reserved slo=
t.
> >        */
> >       ret =3D percpu_ref_init(&pool->ref, __zswap_pool_empty,
> >                             PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> >       if (ret)
> >               goto ref_fail;
> > -     INIT_LIST_HEAD(&pool->list);
> > +
> > +     ret =3D zswap_pool_reserve_slot(pool);
> > +     if (ret < 0) {
> > +             pr_err("cannot create more than %d pools\n", ZSWAP_MAX_PO=
OLS);
> > +             goto slot_fail;
> > +     }
> >
> >       zswap_pool_debug("created", pool);
> >
> >       return pool;
> >
> > +slot_fail:
> > +     percpu_ref_exit(&pool->ref);
> >  ref_fail:
> >       cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
> >
> > @@ -388,7 +421,7 @@ static void __zswap_pool_release(struct work_struct=
 *work)
> >       WARN_ON(!percpu_ref_is_zero(&pool->ref));
> >       percpu_ref_exit(&pool->ref);
> >
> > -     /* pool is now off zswap_pools list and has no references. */
> > +     /* Slot cleared in __zswap_pool_empty(); synchronize_rcu() draine=
d readers. */
> >       zswap_pool_destroy(pool);
> >  }
> >
> > @@ -404,7 +437,11 @@ static void __zswap_pool_empty(struct percpu_ref *=
ref)
> >
> >       WARN_ON(pool =3D=3D zswap_pool_current());
> >
> > -     list_del_rcu(&pool->list);
> > +     /*
> > +      * Clear the slot before scheduling the release so new readers ca=
nnot
> > +      * see it; __zswap_pool_release()'s synchronize_rcu() drains the =
rest.
> > +      */
> > +     rcu_assign_pointer(zswap_pools[pool->idx], NULL);
> >
> >       INIT_WORK(&pool->release_work, __zswap_pool_release);
> >       schedule_work(&pool->release_work);
>
> Not related to this change, but I wonder if we can use call_rcu() or
> similar here instead of the manual synchronize_rcu().
Agree, will use call_rcu() to replace workqueue + synchronize_rcu(),
so it no longer synchronously waits on an RCU grace period.

> > @@ -435,7 +472,8 @@ static struct zswap_pool *__zswap_pool_current(void=
)
> >  {
> >       struct zswap_pool *pool;
> >
> > -     pool =3D list_first_or_null_rcu(&zswap_pools, typeof(*pool), list=
);
> > +     pool =3D rcu_dereference_check(zswap_current_pool,
> > +                                  lockdep_is_held(&zswap_pools_lock));
> >       WARN_ONCE(!pool && zswap_has_pool,
> >                 "%s: no page storage pool!\n", __func__);
> >
> > @@ -468,11 +506,14 @@ static struct zswap_pool *zswap_pool_current_get(=
void)
> >  static struct zswap_pool *zswap_pool_find_get(char *compressor)
> >  {
> >       struct zswap_pool *pool;
> > +     int i;
> >
> >       assert_spin_locked(&zswap_pools_lock);
> >
> > -     list_for_each_entry_rcu(pool, &zswap_pools, list) {
> > -             if (strcmp(pool->tfm_name, compressor))
> > +     for (i =3D 0; i < ZSWAP_MAX_POOLS; i++) {
> > +             pool =3D rcu_dereference_protected(zswap_pools[i],
> > +                                     lockdep_is_held(&zswap_pools_lock=
));
>
> We already have an assertion that we are holding the lock above.
Exactly, the lock is already asserted previously.
Will simplify to rcu_dereference_protected(zswap_pools[i], true);

Thanks for the review!

Best regards,
Jianyue

