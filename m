Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DACCA5FB7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C466B0468; Tue, 20 Jan 2026 12:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812C36B046A; Tue, 20 Jan 2026 12:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F56D6B046B; Tue, 20 Jan 2026 12:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 594216B0468
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:20:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B247D140611
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:20:12 +0000 (UTC)
X-FDA: 84353005464.25.74DE06F
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80E43C000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:20:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NETE/aaj";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768929609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjgInJxzHZA1FL2RVNq/kScJMYVHdTMpDmOcyNlB2Pg=;
	b=p5LQBNC5RN9CCga5Wah9VjtXr0D/1J0tC+GwuCzKaFeqnAHt8AFedURpjFMOfGJ4ypHDzn
	h0wZBPNHELcr1jt5Caxp6pttk2PxrcZ8oPbMdQk6RzDz699c/NgiBnG8zR03/W8Cy6rFGM
	aPEW4j6eE+WSMcau6ROgxbAX1UJHdN0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NETE/aaj";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768929609; a=rsa-sha256;
	cv=pass;
	b=O2TPi1+rY/cHetiBeWIbv8Nw6j/6TUSUuhPmP7xKvyT7wNb/HsiSg7s8dlMHsZr2vcNazm
	ZcUt5uE0TTq6KW9cxcdSxJZmj1fmdbjtrsJs51C5C6PS3O8A/K7QSz9xtvuE2tyuOcdJg2
	Qmdja28MOepNEhhg9NqBKziDaKYVeEY=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50299648ae9so1458421cf.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:20:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768929608; cv=none;
        d=google.com; s=arc-20240605;
        b=EkK9QLJgKKc8BUqktzldXV7XHaQI7YcOJ/Ff5eMFlb7eSEdLrX1OOOTgcHy3DzesTc
         KfXvx4p+0R5xRto7TeVUzn89HZB7oBssc88RjcS6luYCXeyuzt7xbsVRjHOwHhVh9+rt
         O6bctfTFxX+r5PXstD1u9SShhRVWSVbn2fk1lR6TpVpOKmfYspryoRpPPQgsVko/PZRw
         YsmfhtV1VQhBqkb/rJENLfcEiwGtBy3lkub9QB5xFQT06BtTji+PwOYVPm98mQtrrmU6
         RC9MVYv3AxdtOMjq/9TZJVUjk0f3R1HZqWSxlgdSUCtUFWnIuPkRnIObX0W1SQuzWH+a
         V//A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XjgInJxzHZA1FL2RVNq/kScJMYVHdTMpDmOcyNlB2Pg=;
        fh=8e7BvsbtjpRlE+DkSpX1OWhtV/F48qOLy/o91c/9jMk=;
        b=D4c+OsPZPFJDaZKIP1g7WyqJjHEq2EnmrIxrRN5YnlWz7Ax/dqXETUFQhx2FGsOaUg
         zt6ngI6Bq2Zw1lv+eatf0OOW2xPMv4xLXhleCY7SEwVLJjtwSnuzeulnvLnV9zZWz/0Y
         OlsU2zqy50vBJrFokhQllLQbZpRxKOC0FgtP7iNlANvcyX3EVAGWzLifAB+SbQAWhtU+
         0UwJGsOkq1i7jV3eq3X4Jqj+CUeeFNl3B+fMI4XICrV8kBj75ekwps5brFoXOvozfFwi
         pxupR5bQ7ebgGvMCBIcoXMoeXrh9BlvO/5b+sP8ec3SeoB72o/TRX4mHpAdDlKgyxi4R
         J06A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768929608; x=1769534408; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjgInJxzHZA1FL2RVNq/kScJMYVHdTMpDmOcyNlB2Pg=;
        b=NETE/aajBfDsK3jOc+bTjo+Jz7/yBTMAQyBeUSJ76PuEp/padtrm/px4ukDSRC5/+g
         AH47GMP8fUGpgWCwPQpHac5AFjfCcdrUTpDmYKLO7ksFe7kzvZbnQdPC8ltxxcycpOg1
         AGYMJxDhcGcs+vPG1TrTLHZo+Q2yMRmA+7B4zRrMEHBhs8hFuPVP97b1XcQGzYEpsF7s
         zmcC7ZADQxQ/A50x1OzGTkiey+oxwHjiA/WRy5rxbARFRYlnro1veJ6znehMkb7yL72Q
         r49OyRJH6ogoKDetJblN1kO2kWC5LpDamJeyiH/pnNrcLpmvxRqwFpWAb3B/ZaXlffFy
         Jz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768929608; x=1769534408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XjgInJxzHZA1FL2RVNq/kScJMYVHdTMpDmOcyNlB2Pg=;
        b=bRknJhK/7A0AdG7cLM/oAqnEQoToYVeui7oHAEZBxvTwX2TWLTJWV24mlT8xKAXQUm
         sI5uUlOHmad0QYyWB5c32zu3Aevr489r3slGxAOS0KqpSIKcc8ecnAlTK0a5yIbZXpIF
         PorngSIQJ5M1ouQGLyeAG/iFwNoUrNR7DzUprrcVLl0nJNBpJlh1+ARALgmUuh5JRZNA
         64f+1vDcp9SVN9VQPbAVO1mIwLtas8CJ1sKtjZez3g0cR6t7HAdv/2KBw818J0flIZ4g
         zR5DQ7ub/3UG5M4BbH+M6xKsYypt3XDroX2znsKYGEFS7cvVrah+iUbwc8Npd4G4zCD0
         KGUw==
X-Forwarded-Encrypted: i=1; AJvYcCVXKztGSmt/AM3q+EI2Ho13onJYeKds5earzTbfkR2XaKgPKEGNNcuHW/4w9ekry5exhneSH/WPBQ==@kvack.org
X-Gm-Message-State: AOJu0Yw96rTLd/t1AmVwKbaSM8GRaKArpxDqYiILzLc2WKMBAt+dy8qU
	ah1G/BM0CU08QjuMfxH9uCxaUN40jQdqGL3Hx5aIkaoIv9nKgW71SAxCl3c5v81U+FYDMFY2uEm
	wjCRdYWTepnYPClWg38F1pKAmn/UCaRXtgl0KoJMh
X-Gm-Gg: AY/fxX44NDImsOyBwskhpWmZS+usNz/l8BGZZj9f1+G/FXM6JYK0hTNMxA/H7USf5QM
	PUboI1Kt8nsSpxoLTTMUmT20SPPbJUFz0mSFz+nO84CBQMDTlbX38y8lo0aFmY01N3Hq3DRDaqj
	ZIqDJ3E/sDyXBW0kcarVuFxxn/bsp8+G7XufqODDwW4hXs5tjel5RhTY0928LJogMKPJxpVKjhU
	SIrHXKxFqW+XPWCXC/yvyVE1Gry6pMP32GlH+Wz9U89YJ3SLIfE0gXgxCM/DP/Ho2me6BJOlPqZ
	fwlZ4b1Meylox1a+EYnfUAs9jJln480gzg==
X-Received: by 2002:ac8:7f49:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-502b07275d9mr30014031cf.17.1768929607523; Tue, 20 Jan 2026
 09:20:07 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 20 Jan 2026 17:19:56 +0000
X-Gm-Features: AZwV_Qi9JsdZs4u4zpyMKVEbr1yatFKMUCA5FvcV_dcEEUthHo8JPVRpfNJYn0g
Message-ID: <CAJuCfpErRjMi2aCCThHiS1F_LvaXjkVQvX9kJjqrpw8YnXoNBA@mail.gmail.com>
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial list
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j8uq8ugwpmksysx3me7o8iadjdda1mqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 80E43C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768929609-581968
X-HE-Meta: U2FsdGVkX19whnKI+BMiWNQR3z2DPo2Kt8K7Od2Q4aTFhk0B9mJM3QsW9/AJBhUxcwN29H+PurIL2RPeQzEygMaw/ToyXgu9V09HHwLew/Gq0Gr6fKesXeOrERqErDTZub0uQVbHgG0vmvSDhegOaqEr2vSpjxt2plJr+B2U6gCQga8kFaMgD7wsdmCvoiBrUEC9tm5jl0otC98pCTZSXIZjaAC1ucyZcuz4FIGl2ZZNR5/NDwrZCj9ShEdaNkgC2k8byqEk/AHW/2chV5m75C/uwykmOrzIeahbHTdp+WySxKcxEDvFF27qUZ7eJnrf9/dMtXfenLAHKNroqef3KligpdOXPGHacZSCzf1TdmtfisWZjgj+tRRb7kHH+Uax9ydFPsa3YvJtmoAhUGSaai8xOxd557bTc/n9rVBvANSHe/QI/HfJejxxwrUWjHAXRR4yxyhDqFE1oIlXcnh0eODfBZT2jswTau0qTMrjN7pJc79dTXDjEaWDMfbykZBuDZHKDyge/b1w7x37lRlXjoX27FL26sfHxasjS6WeZutVzsge3QtYkALFQ8Q9nCuoqF7s2LYvZ6TcFifatWjfvKJPu79EXohXa9qb1Zz7XGHMEx0c4AMPMyzcP8SAj0tO9p4w4Py7sQ1/0U5dAwu0YG4SwlPtO4Nz+tXNMYPaQSP2hWV8RcX90fH/Q3x34hHqOY52luDMVOFtcoaB/Obhx3qLz/azw4ZW2Qdc6qeNWxbq3RGlkM8RC0d3IQQlHLyOKTr8xzB/JI4S+OPm7biDnRkNnZNQsBUuMzH3u/GfO3RXwmqgsV/JHaedTbILae4X80CWRa2/eplsPR3M+9u6O10WnlDn5LqQEwiDFEp+xgWjZ8Gu282WgK3B+XI2acb4KJA4DVtoPuWkPge2TtsQK9T1aBxQ0DYwVOPyx69Hb9rldrVouNcCZyYd7RBTSQRAf88IEm/+27L3vJnXq9A
 ftszAucF
 PQaUxwGD5H4JiL6viFlr2XVKopO+s/KpsCFFTkXYfNddrUP8hOCtcWVV6qIN9IhJeFFKRXWXIlfbl+Ekt/UW5UhbDs35hQkBJZeIxyrsTTi+2JW2THSLpD19Wxl/icQWRIKozujoBf0umJwCm7Gv8eMhTCewxxK8dzqp2vtFR0h4oRI2DrYoxQMiF8hc06D3LAPbiO+dPVOy8bx1gxBf9Eyo3F94V1++5JUqY00eGHksTTh3KYVb4vqC9j05TPgA5IqM5kJ7np39rzaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
>
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
>
> Extend struct partial_context so it can return a list of slabs from the
> partial list with the sum of free objects in them within the requested
> min and max.
>
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list.
>
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
>
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions.
>
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
>
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
>

Some nits, but otherwise LGTM.
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 284 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+-----
>  1 file changed, 264 insertions(+), 20 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 9bea8a65e510..dce80463f92c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -246,6 +246,9 @@ struct partial_context {
>         gfp_t flags;
>         unsigned int orig_size;
>         void *object;
> +       unsigned int min_objects;
> +       unsigned int max_objects;
> +       struct list_head slabs;
>  };
>
>  static inline bool kmem_cache_debug(struct kmem_cache *s)
> @@ -2650,9 +2653,9 @@ static void free_empty_sheaf(struct kmem_cache *s, =
struct slab_sheaf *sheaf)
>         stat(s, SHEAF_FREE);
>  }
>
> -static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> -                                  size_t size, void **p);
> -
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int=
 min,
> +                unsigned int max);
>
>  static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>                          gfp_t gfp)
> @@ -2663,8 +2666,8 @@ static int refill_sheaf(struct kmem_cache *s, struc=
t slab_sheaf *sheaf,
>         if (!to_fill)
>                 return 0;
>
> -       filled =3D __kmem_cache_alloc_bulk(s, gfp, to_fill,
> -                                        &sheaf->objects[sheaf->size]);
> +       filled =3D __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
> +                       to_fill, to_fill);
>
>         sheaf->size +=3D filled;
>
> @@ -3522,6 +3525,63 @@ static inline void put_cpu_partial(struct kmem_cac=
he *s, struct slab *slab,
>  #endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>
> +static bool get_partial_node_bulk(struct kmem_cache *s,
> +                                 struct kmem_cache_node *n,
> +                                 struct partial_context *pc)
> +{
> +       struct slab *slab, *slab2;
> +       unsigned int total_free =3D 0;
> +       unsigned long flags;
> +
> +       /* Racy check to avoid taking the lock unnecessarily. */
> +       if (!n || data_race(!n->nr_partial))
> +               return false;
> +
> +       INIT_LIST_HEAD(&pc->slabs);
> +
> +       spin_lock_irqsave(&n->list_lock, flags);
> +
> +       list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +               struct freelist_counters flc;
> +               unsigned int slab_free;
> +
> +               if (!pfmemalloc_match(slab, pc->flags))
> +                       continue;
> +
> +               /*
> +                * determine the number of free objects in the slab racil=
y
> +                *
> +                * due to atomic updates done by a racing free we should =
not
> +                * read an inconsistent value here, but do a sanity check=
 anyway
> +                *
> +                * slab_free is a lower bound due to subsequent concurren=
t
> +                * freeing, the caller might get more objects than reques=
ted and
> +                * must deal with it
> +                */
> +               flc.counters =3D data_race(READ_ONCE(slab->counters));
> +               slab_free =3D flc.objects - flc.inuse;
> +
> +               if (unlikely(slab_free > oo_objects(s->oo)))
> +                       continue;
> +
> +               /* we have already min and this would get us over the max=
 */
> +               if (total_free >=3D pc->min_objects
> +                   && total_free + slab_free > pc->max_objects)
> +                       break;
> +
> +               remove_partial(n, slab);
> +
> +               list_add(&slab->slab_list, &pc->slabs);
> +
> +               total_free +=3D slab_free;
> +               if (total_free >=3D pc->max_objects)
> +                       break;

From the above code it seems like you are trying to get at least
pc->min_objects and as close as possible to the pc->max_objects
without exceeding it (with a possibility that we will exceed both
min_objects and max_objects in one step). Is that indeed the intent?
Because otherwise could could simplify these conditions to stop once
you crossed pc->min_objects.

> +       }
> +
> +       spin_unlock_irqrestore(&n->list_lock, flags);
> +       return total_free > 0;
> +}
> +
>  /*
>   * Try to allocate a partial slab from a specific node.
>   */
> @@ -4448,6 +4508,33 @@ static inline void *get_freelist(struct kmem_cache=
 *s, struct slab *slab)
>         return old.freelist;
>  }
>
> +/*
> + * Get the slab's freelist and do not freeze it.
> + *
> + * Assumes the slab is isolated from node partial list and not frozen.
> + *
> + * Assumes this is performed only for caches without debugging so we
> + * don't need to worry about adding the slab to the full list

nit: Missing a period sign at the end of the above sentence.

> + */
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct s=
lab *slab)

I was going to comment on similarities between
get_freelist_nofreeze(), get_freelist() and freeze_slab() and
possibility of consolidating them but then I saw you removing the
other functions in the next patch. So, I'm mentioning it here merely
for other reviewers not to trip on this.

> +{
> +       struct freelist_counters old, new;
> +
> +       do {
> +               old.freelist =3D slab->freelist;
> +               old.counters =3D slab->counters;
> +
> +               new.freelist =3D NULL;
> +               new.counters =3D old.counters;
> +               VM_WARN_ON_ONCE(new.frozen);
> +
> +               new.inuse =3D old.objects;
> +
> +       } while (!slab_update_freelist(s, slab, &old, &new, "get_freelist=
_nofreeze"));
> +
> +       return old.freelist;
> +}
> +
>  /*
>   * Freeze the partial slab and return the pointer to the freelist.
>   */
> @@ -4471,6 +4558,65 @@ static inline void *freeze_slab(struct kmem_cache =
*s, struct slab *slab)
>         return old.freelist;
>  }
>
> +/*
> + * If the object has been wiped upon free, make sure it's fully initiali=
zed by
> + * zeroing out freelist pointer.
> + *
> + * Note that we also wipe custom freelist pointers.
> + */
> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> +                                                  void *obj)
> +{
> +       if (unlikely(slab_want_init_on_free(s)) && obj &&
> +           !freeptr_outside_object(s))
> +               memset((void *)((char *)kasan_reset_tag(obj) + s->offset)=
,
> +                       0, sizeof(void *));
> +}
> +
> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct sla=
b *slab,
> +               void **p, unsigned int count, bool allow_spin)
> +{
> +       unsigned int allocated =3D 0;
> +       struct kmem_cache_node *n;
> +       unsigned long flags;
> +       void *object;
> +
> +       if (!allow_spin && (slab->objects - slab->inuse) > count) {
> +
> +               n =3D get_node(s, slab_nid(slab));
> +
> +               if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +                       /* Unlucky, discard newly allocated slab */
> +                       defer_deactivate_slab(slab, NULL);
> +                       return 0;
> +               }
> +       }
> +
> +       object =3D slab->freelist;
> +       while (object && allocated < count) {
> +               p[allocated] =3D object;
> +               object =3D get_freepointer(s, object);
> +               maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +               slab->inuse++;
> +               allocated++;
> +       }
> +       slab->freelist =3D object;
> +
> +       if (slab->freelist) {

nit: It's a bit subtle that the checks for slab->freelist here and the
earlier one for ((slab->objects - slab->inuse) > count) are
effectively equivalent. That's because this is a new slab and objects
can't be freed into it concurrently. I would feel better if both
checks were explicitly the same, like having "bool extra_objs =3D
(slab->objects - slab->inuse) > count;" and use it for both checks.
But this is minor, so feel free to ignore.

> +
> +               if (allow_spin) {
> +                       n =3D get_node(s, slab_nid(slab));
> +                       spin_lock_irqsave(&n->list_lock, flags);
> +               }
> +               add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +               spin_unlock_irqrestore(&n->list_lock, flags);
> +       }
> +
> +       inc_slabs_node(s, slab_nid(slab), slab->objects);
> +       return allocated;
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -4913,21 +5059,6 @@ static __always_inline void *__slab_alloc_node(str=
uct kmem_cache *s,
>         return object;
>  }
>
> -/*
> - * If the object has been wiped upon free, make sure it's fully initiali=
zed by
> - * zeroing out freelist pointer.
> - *
> - * Note that we also wipe custom freelist pointers.
> - */
> -static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> -                                                  void *obj)
> -{
> -       if (unlikely(slab_want_init_on_free(s)) && obj &&
> -           !freeptr_outside_object(s))
> -               memset((void *)((char *)kasan_reset_tag(obj) + s->offset)=
,
> -                       0, sizeof(void *));
> -}
> -
>  static __fastpath_inline
>  struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags=
)
>  {
> @@ -5388,6 +5519,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_c=
ache *s,
>         return ret;
>  }
>
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +                                  size_t size, void **p);
> +
>  /*
>   * returns a sheaf that has at least the requested size
>   * when prefilling is needed, do so with given gfp flags
> @@ -7463,6 +7597,116 @@ void kmem_cache_free_bulk(struct kmem_cache *s, s=
ize_t size, void **p)
>  }
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int=
 min,
> +                unsigned int max)
> +{
> +       struct slab *slab, *slab2;
> +       struct partial_context pc;
> +       unsigned int refilled =3D 0;
> +       unsigned long flags;
> +       void *object;
> +       int node;
> +
> +       pc.flags =3D gfp;
> +       pc.min_objects =3D min;
> +       pc.max_objects =3D max;
> +
> +       node =3D numa_mem_id();
> +
> +       if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +               return 0;
> +
> +       /* TODO: consider also other nodes? */
> +       if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +               goto new_slab;
> +
> +       list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +               list_del(&slab->slab_list);
> +
> +               object =3D get_freelist_nofreeze(s, slab);
> +
> +               while (object && refilled < max) {
> +                       p[refilled] =3D object;
> +                       object =3D get_freepointer(s, object);
> +                       maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +                       refilled++;
> +               }
> +
> +               /*
> +                * Freelist had more objects than we can accommodate, we =
need to
> +                * free them back. We can treat it like a detached freeli=
st, just
> +                * need to find the tail object.
> +                */
> +               if (unlikely(object)) {
> +                       void *head =3D object;
> +                       void *tail;
> +                       int cnt =3D 0;
> +
> +                       do {
> +                               tail =3D object;
> +                               cnt++;
> +                               object =3D get_freepointer(s, object);
> +                       } while (object);
> +                       do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +               }
> +
> +               if (refilled >=3D max)
> +                       break;
> +       }
> +
> +       if (unlikely(!list_empty(&pc.slabs))) {
> +               struct kmem_cache_node *n =3D get_node(s, node);
> +
> +               spin_lock_irqsave(&n->list_lock, flags);
> +
> +               list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_lis=
t) {
> +
> +                       if (unlikely(!slab->inuse && n->nr_partial >=3D s=
->min_partial))
> +                               continue;
> +
> +                       list_del(&slab->slab_list);
> +                       add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +               }
> +
> +               spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +               /* any slabs left are completely free and for discard */
> +               list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_lis=
t) {
> +
> +                       list_del(&slab->slab_list);
> +                       discard_slab(s, slab);
> +               }
> +       }
> +
> +
> +       if (likely(refilled >=3D min))
> +               goto out;
> +
> +new_slab:
> +
> +       slab =3D new_slab(s, pc.flags, node);
> +       if (!slab)
> +               goto out;
> +
> +       stat(s, ALLOC_SLAB);
> +
> +       /*
> +        * TODO: possible optimization - if we know we will consume the w=
hole
> +        * slab we might skip creating the freelist?
> +        */
> +       refilled +=3D alloc_from_new_slab(s, slab, p + refilled, max - re=
filled,
> +                                       /* allow_spin =3D */ true);
> +
> +       if (refilled < min)
> +               goto new_slab;

Ok, allow_spin=3Dtrue saves us from a potential infinite loop here. LGTM.

> +out:
> +
> +       return refilled;
> +}
> +
>  static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t si=
ze,
>                             void **p)
>
> --
> 2.52.0
>

