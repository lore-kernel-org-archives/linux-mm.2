Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608E4606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fjqK563G
Received: by kanga.kvack.org (Postfix)
	id 16EEF6B00EF; Thu, 29 Oct 2026 23:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140056B05B1; Thu, 29 Oct 2026 23:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055CC6B05B2; Thu, 29 Oct 2026 23:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2FD26B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:19:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2C19C0549
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:19:17 +0000 (UTC)
X-FDA: 85377836754.11.F311485
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id E302C100003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:19:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fjqK563G;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793330355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
	b=yIGyGbfLAkPRWrM5Jw1cV8QLV7nWfi7RvlXKO0z614GWDHBmfPII6noRCgxcMh5/u6/uld
	zukP1+xQ6zDiYXTWSP1BRwRy6iB/Y5bojRh+mKja0yXF5/79akP2zsuXHXEMyEJeEwMucN
	tlbPQq5jFCtrmnZoJCV0mYcMvTRpYb4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fjqK563G;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793330355;
	b=QCG07mSod+q+a7qviexPnDFf95qCM0h/yMsOArY4F3ayLdRy+P2tgdXIHcAzgBcLBoYW02
	Ht/Tokwnfs1iGcRN5Qnz0V60RGe9cAwh0YlV7QUreoV6e3E3whXUi4kIVZVEH2W1XhE4fi
	uJCJ3oQunhYjNMar7T+xmKjlUe8wu0c=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ab53a99771so2697781fa.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:19:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793330354; cv=none;
        d=google.com; s=arc-20260327;
        b=U52Huez25pwGhTvgStgt1H6HTx0cK4V8XhfIYkCKqxpmguWmdopoLR1lXWkkH/FO5v
         8dOiDC9d/ZjCcpXHJEMR9Igba1LrWttimCmNXEWsimh9sPFRohbv1dunxoBi59XzVg67
         xrNIaumWBAnP/vU7eUeemmlMnbABIWYrHihTfD1wtIWvIOdEZ1BMd6wse50dC0y9h3QV
         LmOCk1/viiYeACXxgJXN3jK7U5SlGNuTdCN0ZarBJTy6qCB1vEUS2tAXF72XYjVa4yDe
         5F/s06G436U3J8r/uQUOH9z6VMJDk+/pvoU3F5rVCUlW5rmr7aqHbfHvfrBvkY6O2mDc
         sfuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        fh=/fVzctBTyIb0c9CdbF0gEqckYczBN7l/1xrv9lPUV8g=;
        b=b2fewUriM92BngBI5CWkgQftInEFq3/E0dIAEtzcuBTaH6P8rOh9DmfKifgsZkhOZR
         23MzYS5PutFa5Xkh0cFFms4+EQx+qV3umeHDxEJxrgciZ3Gc5yHmAokanWC47lGjpUOJ
         9/OUs8wb3PBxvkzNQfGcNcWq1SSDWyaQ+vKDy+KGA5E5/7sLgZw04VqwYaSmlvqYDZdT
         qKc3l9Qk7LsZnPpzVj1/gM1R2o/Wx3ZPexlRP/Z2Q0IvxfHQrIXsrOhzTXuU4GnwAqUl
         IdO/1uXa90N16Z6dbhDT/TEuixarGrkM50riF9ygHN0WXLkpA3I7MUE8rOombSySnsV3
         z8qA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793330354; x=1793935154; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        b=fjqK563GZV92ClE/ZkXFygdtkwkV58KbTJfrXR2o4fwfzzrrEAg21BU97w8Yz08Ao0
         34dIOiO2RcpqEoiK/tobzXt8ZtRS/L/a5woF1basWNs6J81zpP38RHZpZQhzYDEECsSi
         IjcebEDd4B8cIr8NSNvAROd65pP81mDz1Y7sIjLvzafwxmyA3NzGnht4rjjFDHlvED2V
         GgtFD7iaBOL0n6UjMoi7chtti3Ze/5An740+ee2RpXbgSJcE7GRZYJs4wSiOeQd1g72j
         +KYma3KdfMLseits+PfDdeH9Rqt7xYJTtmwFpwJysZq9rIjCzlmLKoob/MGiE6vEBzpm
         GVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793330354; x=1793935154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvFyOlYWWcM4bfjI5ZFYq0uA7WbLDYElCyWjZqS03Gw=;
        b=fohd/hQcSbft7KcYFUlDD4NgBXQojOtVdjeA2wnv/PJ9Fh72bg4meTK97Pu/shxMjE
         1sKsGlrus27Z1Nq2LvJjNTny0y93/s7iA+ZBPSfGNA0aeAbBzwi5fhUMDXdTAO00qc6k
         S5/YZoW6+mu5vtJjcPY1LntluLgC7K0RG2KpWGoaQyEdyj38XWvPOhdIRPI0L9CFT/MZ
         Tw36cDIf/lffXdgNxrcSuoNAgm4GkhF9zoB9yCXiwH3LnsWb5cfujLcQKxj6+Zz8PNM0
         XVYx7nP1BTXhYbrYJWouBf3LBNclUdg3AzwoSzlKjM42tPiU+Ul2ZQZYj9U0slOoNtji
         gtaA==
X-Forwarded-Encrypted: i=1; AKwUvBwvX2VjkPImiUlmvAL1ZbXvVhw92bJTKnXcJZRvION9sqvZcsaIy5qSon4b/srOhpcK9b170B/FNA==@kvack.org
X-Gm-Message-State: AFq9FYL1o6mPOEPAoxfgD87dy6Mh/L4Hs09mz6pVUwZDvsZHfBQOKOF6
	pE5Lzmnyc61lnSQxIqvBZ0Ym3dHJqYEx7F6w1V1Ua5wW5l+kaglmohK64qQLmKjjvGk7+kM2N1y
	Of2GUHaNy6pTkgR6sQZsYZejaSjEcAZQ=
X-Gm-Gg: AYBFou3ylo3laSAH/La8xwOCFrOxD+6s/JiuFMVLyoCC7gVNISGdFoc5fQVCSpQwDOs
	AdmhrH+FMN+exCkhljicJwFHWs61NPsh/EoF2Xn4GNyuA7fA7RBdq03OClQm5bzdjuoGr1mxk8a
	rLB8RmkphZAu/3EJQp5368HuCcw0jQd0YqAHal+xPx8S2fPqeVYov6phSeqgGN/TAfngH8HlwN0
	HjbD9M1wUfN2NV1ksszaQRv5FSOVzzg5OrZ1rh5YdljWnL0RDUfUr64Dq/E288/DF3zi+aFVyjL
	cVUhpOsgyvTdAmjYafD1WeAH2a5zeurBFTHIS5aNrdhYcxEcgdsGSfRggIsRr5a41Brvh/KAkEh
	7Yw4izH2k+yV4OVxysN1rmrBnkRJfcb0YCILb
X-Received: by 2002:ac2:4f14:0:b0:5bf:ce1f:672c with SMTP id
 2adb3069b0e04-5bfd9564e0fmr238085e87.22.1793330353814; Thu, 29 Oct 2026
 20:19:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188660@kernel.org>
In-Reply-To: <sashiko-outbox-188660@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 20:19:00 -0700
X-Gm-Features: AclHuK84KRmP1xwOhmrGiQO4Cat7L-CCE95Y-VrA1yHRRiXcHtlToSwVQTzv2M8
Message-ID: <CACpmpoeHQ8QjFB_2UtGhib9EYToLcXx_e59t+hot+sorUvnMyQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E302C100003
X-Rspam-User: 
X-Stat-Signature: 1c4xf6kkuomwcjezbzgteqxjo4fsim4u
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793330355-929000
X-HE-Meta: U2FsdGVkX19WpX+liG3TOv31AYYTiHSUSpQcXEpDFCzbrAhKHxo6ZPjtyMiQ4vMayGFquL89rvns3My9aH9TLKuwQS0bmCHYyUyVpC1HqcGjPsBWupKzgBlh+33WVeonBGlcyBGTNAxEBsC8WGpU2HXXeMVxvCDEoHgzZnzoCgeuJs0oY/4f0OwAEN4Pr8MMRC5M4CESt7eh5joteZHexPTDoulc6dKb1TF3SbvrNRTquR14a84FqwczlA9P8CWH25X1mOmUCRYj5E1KbjgNT58/Sj2PwprcodDtGbyVWt23essKP+mi2kU3saWJ/fgKvbh0stVCUYXApBO+6RdoYj2LElZieBnu01PsbMJefAvU585iqO1yH2+i3ju4bdIUcWS1RJffSj56V9BGQRDgt3693ttTd2bvsOAnlUlMK6L3CMrwr+WPdKSuCmz7GrWpl+HvlMcnpIRATj68cdpRekJ3gt9t1BJ3N1ByPh7XUxSpDQ7h/AicbA2K2LKOG0ATHaUZKE6QHILdQuv9aStgwKqBwLSO8imEvIAYlUeKWDdIHtIZIzOxumoFUKUSTYPI+Q4g6lKwtOKdUQLlvtUVzV5g9Vzl1L0jFrQPNmNEGoyF150aAVZcHZ5yzvHfo2dQOjQHaa0pF6/Ce+/sTSzjPiQDz5MDoc5Khyw4rKDMzduq03NLTccI10MztcD56CzhlR2C7bgwb4cJEqVFc3cHGrD8c/D+E78nTWE9WLZ0JL7NvXNkBzMXs3GBvVCNEJxptVziWxt5gQYZs6cVN8MbvVPFDrPYzX/gpao/hzxVEAxfYJCeRrZLEZrv7rVgNqxcME0BlMLEsUIUNXfHhAEbeEc8nwWqDoHJ4VHrpwQt53TnUtBYcJk9GCC93husywuavJ/2fjT12ohIWVA/RtEQ8vwcMBrLnjBsFA6Xl4F9ILw7feuBt2adxarvO7BWRm07TarKP67a1U4wWpd53XE
 gd9xqXpu
 QFJDD2NEIZgKLjAB2ruVKYfWegX34kEY4dagze84L1LO0bUNFfH7ix94IrrXrtgw3k/do3/YB1+C6AiKze7aOboxWR6HWBrizuGOLxaWmGhHCkiiTOiMFrgA92kKD+PYgdyjoWUV7Pl2r+RxrRK3KDo/kVKfVZFrx2LUD7Hif93GiRoI3RnVq6qywOGuD4ZbQ5ol2t6/Q9vDWTClkFmtf2kvVzqgLnKcSvEldZaHIXQgPpIxYJ+2LJe/2njCOOj47oSG+taJqf75EeiFnAjLaC4cxN3FGWiNFAjAvyfrU3T53xFJrEyE8w1+p0UOHmRoebAR/JBRp+2rPu0U1QITbFYibMYfcfiulJYkZbmPYZHYvl3oxxxmDqoJfj90CZN6gAVYfYuJ2u06XIew0ENhixULaygFb/WYBJbpojVw3r/JedG2uHF7WYaKNDJem0Ek7Ek/Q2vPX36ma/Vw5P4uomXgeRyz8XsjNhaYtZRwE8pwJOFG/JsbieM7cZnJrOeGT1dZ3T7lcUI6N4yxxwYn7YdogdgrtjmnTmzzCIMFyz5el+YA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] mm: zswap: memcg counter corruption in zswap_account_stores()
> - [High] mm: zswap: missing zs_free() of prior sub-batches when zswap_com=
press() fails
> - [Low] mm: zswap: unused zswap_pool_get() retained with __maybe_unused
> --
>
> commit 5a1c181c752a45f404bc7cfeb7961fd6accb0903
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
>
> This commit refactors zswap_store_pages() into smaller helper functions
> (zswap_init_entries(), zswap_tree_stores(), and zswap_account_stores()) t=
o
> process batches of pages when storing a large folio. It also batches pool=
 and
> obj_cgroup reference counting, memcg charging, and zswap_stored_pages upd=
ates
> across the batch.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4476fb4aeb5fd..2831284cfc903 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -504,12 +504,18 @@ static int __must_check zswap_pool_tryget(struct =
zswap_pool *pool)
> >  }
> >
> >  /* The caller must already have a reference. */
> > -static void zswap_pool_get(struct zswap_pool *pool)
> > +static void __maybe_unused zswap_pool_get(struct zswap_pool *pool)
> >  {
> >       percpu_ref_get(&pool->ref);
> >  }
>
> [Severity: Low]
> Since the only call site in zswap_store_pages() is replaced by
> zswap_pool_get_many(), zswap_pool_get() no longer has any callers in the
> file. Could zswap_pool_get() be removed outright instead of marking it
> __maybe_unused?

Sure, this makes sense.

>
> >
> > -static void zswap_pool_put(struct zswap_pool *pool)
> > +/* The caller must already have a reference. */
> > +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
> > +{
> > +     percpu_ref_get_many(&pool->ref, nr);
> > +}
>
> [ ... ]
>
> > @@ -1750,24 +1732,30 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
>
> [ ... ]
>
> > +static inline void zswap_account_stores(struct zswap_store_context *zc=
,
> > +                                     struct zswap_pool *pool,
> > +                                     struct obj_cgroup *objcg)
> > +{
> > +     size_t total_batch_comp_length =3D 0;
> > +     u8 i;
> > +
> > +     for (i =3D 0; i < zc->nr_pages; ++i) {
> > +             if (unlikely(zc->entries[i]->length =3D=3D PAGE_SIZE))
> >                       atomic_long_inc(&zswap_stored_incompressible_page=
s);
> >
> > +             total_batch_comp_length +=3D zc->entries[i]->length;
> > +
> >               /*
> >                * We finish by adding the entry to the LRU while it's al=
ready
> >                * in xarray. This is safe because:
> > @@ -1778,20 +1766,78 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                *    The publishing order matters to prevent writeback f=
rom seeing
> >                *    an incoherent entry.
> >                */
> > -             if (likely(entry->length))
> > -                     zswap_lru_add(entry);
> > +             if (likely(zc->entries[i]->length))
> > +                     zswap_lru_add(zc->entries[i]);
> >       }
> >
> > +     /*
> > +      * The entry is successfully compressed and stored in the tree,
> > +      * and further failures will be cleaned up in zswap_store().
> > +      * For the batch, grab refs to the pool and objcg, charge zswap m=
emory,
> > +      * and increment zswap_stored_pages by @zc->nr_pages. The opposit=
e
> > +      * actions will be performed by zswap_entry_free() when the entry=
 is
> > +      * removed from the tree.
> > +      */
> > +     zswap_pool_get_many(pool, zc->nr_pages);
> > +     if (objcg) {
> > +             obj_cgroup_get_many(objcg, zc->nr_pages);
> > +             obj_cgroup_charge_zswap(objcg, total_batch_comp_length);
> > +     }
> > +     atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +}
>
> [Severity: High]
> Does calling obj_cgroup_charge_zswap(objcg, total_batch_comp_length) once=
 per
> batch corrupt the MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP counters when
> zc->nr_pages > 1?
>
> Looking at obj_cgroup_charge_zswap() in mm/memcontrol.c, it assumes @size
> represents a single page:
>
> mm/memcontrol.c:obj_cgroup_charge_zswap() {
>     ...
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
>         mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
>         if (size =3D=3D PAGE_SIZE)
>                 mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
>         rcu_read_unlock();
> }
>
> When a batch of zc->nr_pages > 1 pages from a large folio is stored via
> zswap_store() -> zswap_store_pages() -> zswap_account_stores(),
> MEMCG_ZSWAPPED is only incremented by 1 instead of zc->nr_pages, and
> MEMCG_ZSWAP_INCOMP compares the summed total_batch_comp_length against
> PAGE_SIZE rather than counting individual incompressible pages.
>
> Later, when each entry in the batch is freed via zswap_entry_free():
>
> mm/zswap.c:zswap_entry_free() {
>     ...
>         if (entry->objcg) {
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>                 obj_cgroup_put(entry->objcg);
>         }
>     ...
> }
>
> obj_cgroup_uncharge_zswap() is called once per entry, decrementing
> MEMCG_ZSWAPPED by zc->nr_pages total and decrementing MEMCG_ZSWAP_INCOMP =
for
> each entry whose length =3D=3D PAGE_SIZE.
>
> This causes both MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP to be miscounted a=
nd
> underflow, which also breaks zswap_shrinker_count() where MEMCG_ZSWAPPED =
is
> used as nr_stored to scale reclaim targets.

Yes, I see this, thanks. I have added a new
obj_cgroup_charge_zswap_many() that should address this issue.

>
> > +
> > +/*
> > + * Store multiple pages in @folio, starting from the page at index @st=
art up to
> > + * the page at index @end-1.
> > + */
> > +static bool zswap_store_pages(struct zswap_store_context *zc,
> > +                           long start,
> > +                           long end,
> > +                           struct zswap_pool *pool,
> > +                           struct obj_cgroup *objcg)
> > +{
> > +     bool ret;
> > +     u8 i;
> > +
> > +     zc->nr_pages =3D end - start;
> > +     zc->folio_start =3D start;
> > +
> > +     VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX_B=
ATCH_SIZE);
> > +
> > +     if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
> > +             return false;
> > +
> > +     zswap_init_entries(zc, pool, objcg);
> > +
> > +     /*
> > +      * Locking the comp_ctx mutex once per store batch results in bet=
ter
> > +      * performance as compared to locking per compress batch.
> > +      */
> > +     zc->comp_ctx =3D &raw_cpu_ptr(pool->acomp_ctx)->comp;
> > +     mutex_lock(&zc->comp_ctx->areq.mutex);
> > +
> > +     ret =3D zswap_compress(zc);
> > +
> > +     mutex_unlock(&zc->comp_ctx->areq.mutex);
> > +
> > +     if (unlikely(!ret))
> > +             goto compress_failed;
> > +
> > +     ret =3D zswap_tree_stores(zc);
> > +
> > +     if (unlikely(!ret))
> > +             goto store_pages_failed;
> > +
> > +     zswap_account_stores(zc, pool, objcg);
> > +
> >       return true;
> >
> >  store_pages_failed:
> > -     for (i =3D store_fail_idx; i < zc->nr_pages; ++i)
> > +     for (i =3D 0; i < zc->nr_pages; ++i)
> >               zs_free(pool->zs_pool, zc->entries[i]->handle);
> >
> >  compress_failed:
> > -     zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
> > -                                    zc->nr_pages - store_fail_idx);
> > -
> > +     zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
> >       return false;
> >  }
>
> [Severity: High]
> Can jumping to compress_failed when zswap_compress() returns false leak t=
he
> zsmalloc handles allocated in earlier compression sub-batches?
>
> In zswap_compress(), pages in [0, zc->nr_pages) are compressed in sub-bat=
ches
> of zc->nr_batch_pages (which is 1 for software compressors such as ZSTD o=
r
> LZ4 when zc->nr_pages is up to ZSWAP_MAX_BATCH_SIZE):
>
> mm/zswap.c:zswap_compress() {
>         for (batch_start =3D 0; batch_start < zc->nr_pages;
>              batch_start +=3D zc->nr_batch_pages) {
>                 ...
>                 err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
>                                       &zc->comp_ctx->areq.wait);
>                 if (unlikely(err && !zc->wb_enabled))
>                         goto compress_error;
>                 ...
>                 ret =3D zswap_update_entries(zc, batch_start);
>                 if (unlikely(!ret))
>                         return false;
>         }
> }
>
> Each successful call to zswap_update_entries(zc, batch_start) allocates
> zs_malloc() handles for zc->entries[batch_start .. batch_start +
> zc->nr_batch_pages - 1]. If a subsequent iteration with batch_start > 0 f=
ails
> at goto compress_error (when !zc->wb_enabled and a page is incompressible=
) or
> fails in zswap_update_entries() (which only frees handles in the current
> sub-batch starting at batch_start):
>
> mm/zswap.c:zswap_update_entries() {
>     ...
>                 if (unlikely(IS_ERR_VALUE(handle))) {
>                         ...
>                         for (i =3D 0; i < comp_batch_iter; ++i)
>                                 zs_free(zc->zs_pool, zc->entries[batch_st=
art + i]->handle);
>
>                         return false;
>                 }
>     ...
> }
>
> zswap_compress() returns false while zc->entries[0 .. batch_start - 1]->h=
andle
> still hold allocated zsmalloc objects. In zswap_store_pages(), jumping to
> compress_failed then frees zc->entries back to the slab cache without cal=
ling
> zs_free() on those handles.

Also resolved, thanks!

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D8

