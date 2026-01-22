Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE607C44508
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 00:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3B06B008A; Wed, 21 Jan 2026 19:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477166B008C; Wed, 21 Jan 2026 19:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358E46B0092; Wed, 21 Jan 2026 19:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 220026B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:54:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2438161454
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:54:22 +0000 (UTC)
X-FDA: 84357778764.19.15E7FE9
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB97C40002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:54:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Q/3Mi5pv";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769043260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NqFR4vEi17NIt2eo657HYzQ+UfH+loYG1rnphf1kfI=;
	b=iTDOoDhtP3S0TyVh+ZvnBoPmrAPDR2ZkyI+68qgG7L4/ztGg4M4xpIFYuv3ot+nVYBfWGj
	ZU6yocdQ1eNmKlUPtlsSNOjNTgNZuyoi+vKjrIM5TYrubc+Abfo+ZIwoyFwMELcUhqLV2X
	ZWZX4YAVYmWWc6ena464IcUxiSeQptQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Q/3Mi5pv";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769043260; a=rsa-sha256;
	cv=pass;
	b=voxWs05OwFjPVWkUgdFHR4Jd9FMmsR/IMjW6SAhkre2iQ+Mc6NKV/IqCZs4UwnHzEu+vts
	scSnDjeCB1BGTKnJ67Zl3BXngeX6/gdDuwU7qK2C7Bul/i3HCLazPidBg7Y55vIi8AueMM
	vMlRZfaeu3MgAnuDvcbcJF25nWQa51o=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014b5d8551so100351cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:54:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769043260; cv=none;
        d=google.com; s=arc-20240605;
        b=X3HRYiLhG2KTQ3MKP/Y+u1ovOp+tGBqxutul9S3i4L2Yf+x9oMoysD7x2gEn8pkvnL
         a7wHanXYcum8RiSYShnRQd+JhkjmG3PUDUHHdHkB7WavDKYQXwU1fPxOKJc3CUC6TOgq
         4/ovqX/Ap9Hn4SqesRCqTlk6OyiVVoILrE1Wk8OECRzmIkzDdAI0ZODAqpSkkDitIKRf
         pMahpHFjmZkeOrd63MREvzDi7mEbSLxxJfGunDq9k7RstAyS748GlTWDGSAuoZZSHtzQ
         MbHz7BbVSAtyScmcJBVmlBWGcs1A/9M+W3pFQQVDDzIOXUdJDhzDwxh4lNqk3ggNw+3p
         p89g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+NqFR4vEi17NIt2eo657HYzQ+UfH+loYG1rnphf1kfI=;
        fh=AG9fdMPafxp+Zj5IxmiDAPk4YlPByck4tEY9BoO2ZYc=;
        b=V3pwvTAA2jSngf6ep0Q2umt8c+pCvJSUnftycKxl7yccgLvnCMapfqaKGkcoSzQDe1
         YEP/SQOxFXGSltUk5WQLcCwa0E+i0GJyK30z1l1bRNjugWbWg3pXYxbDj5Q2cEYqMUHK
         1iTvQMIYsi/MTZ1Sr0cPSGRjrPvh78lCaaGE84s4OPNoHQfVJZrKoC1X7kKwkYZ3tnbl
         1Sx0gCAJnHDBzv/kTqARB282dsyxBbNnJPm4oInkaWPQiTth23MVRmxFa8A2Nqcrncev
         5TEAfiQ/aKsy+ZkwaL4s2R+W+CJlIvwLr7V13jhtXR/bICgce1iK0Viy/2WtiZiE4HD+
         eWug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769043260; x=1769648060; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NqFR4vEi17NIt2eo657HYzQ+UfH+loYG1rnphf1kfI=;
        b=Q/3Mi5pv7kOVl8gpGI7kTRtBFzBwwGyz3MjprJA7n7d4ad8GVOJb+/61+96+VUIar7
         YD+l7MOZ12pklh7U3ikIxG4vZU0na/a/oM34/AI5PpTB8sJXR5zsDJnfspyhmc5jwoTN
         0VqvCQMiaDAMXIF0x6X5J/fFDOuZRuYCzlSI6MLH2P5hN0v+EFi+NULUOFmgCCMzNl3k
         cz791gCfJJRUTQjgSKY+GPqOa84UtBrOctJTr5IuT1JWgDMa7c04HOjMIl+FoXbrkx4D
         ykpOB75e5MM6Dx6WRi6+N1zZAILw64C6bacxBTOYa2IPeQOknPjTWa4X04pyp9wVSfAp
         POJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769043260; x=1769648060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+NqFR4vEi17NIt2eo657HYzQ+UfH+loYG1rnphf1kfI=;
        b=kl/IwmQwnswxwaoJ1oQoDIaaSlKHS4DdBVdd4okJ1eRo6cMZ+5Ycy1M92SEdYqpgFn
         87/ElAjz4wgXMf+XgCen3iXvSgjbkrOTflN2xr98Hq2YMQq69JWhyh4SlChYah37KT1c
         0Dqrtybqm3hr4vlVSFbo3FSw6492Sg54zYGH158VQRlttk5hkgamjuvdLO+hIyqLLqeI
         rGKB+k6jBW3g3Llrplsn7griwoqB3+Sn1kYqXSoKFCF1+1qaq/yn7j/g1V014ce5Wdl1
         PUX6SbuwblCOtAFsoeBR7E38QwwHYmVI4VtZGr96cuMK9QpJgji/1TC0KRnj91nhS6WH
         cD6A==
X-Forwarded-Encrypted: i=1; AJvYcCUofd3bfNQSiLYPZLLCpAIP3nL5c45a3dT6Gmttd688arT77yupHZqvdK7rrSmJ7iXoeoNkV9O4uQ==@kvack.org
X-Gm-Message-State: AOJu0YwbSSyFT8Cuw/pqkDiM0fp4ivcjv4wRrGBwH4HXzTrGc2SNKAtH
	wxRO629454yrML2pZaXN6rvTXN4hGq+apIqgvnBBGvi3ImlDzCoEEv0XPvE6uKL+h9wRpLOvRE1
	OziKKsnHQiF9esM7AXINIUWqyycblar+/8wjWKpki
X-Gm-Gg: AZuq6aIm77tvUJoGk3jPENSqTy0acpdlVBMsttYYkUBFp6Uh9iXbINdJxalpH2yFmjg
	c9QpxgkN1I79CS4LQPcXz7k5TG5QHsZ5usByl/E4souvZ/lI1EGNQ8PlCGj/0qLSr7JJKm/5kiz
	zQWKvnHRnEtpPc7lUH7VJK3WuPbZ6o+7gch8MJg8u4tlNMhYTROj47eAFurRNUsYfC2yWNiK3K6
	zEIqlq5uJZ400YZSOXngvl7M+m0h47AQ5g1r/XwMETAPVWZ6mczl0bI8TF3hhZjt/daEkKIuRTM
	tpDB5Kz0J/D4Aedv6BJBpYpO17Ag7oE5Yg==
X-Received: by 2002:ac8:7f11:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-502ebd67f28mr5244541cf.8.1769043259374; Wed, 21 Jan 2026
 16:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 00:54:08 +0000
X-Gm-Features: AZwV_QiKaqX658yaaNclaMUDJFMuWaWyjwe3fGXZJxanEvpjJyRl1f7lSqjnfpQ
Message-ID: <CAJuCfpHggP+iefwGTOWnSxDma5U=uMROYNs8KS0A=u2w=1rq_w@mail.gmail.com>
Subject: Re: [PATCH v3 19/21] slab: remove frozen slab checks from __slab_free()
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
X-Stat-Signature: cakc15nh4hq7axda5hxj3o9twi9g51wk
X-Rspamd-Queue-Id: BB97C40002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769043260-372437
X-HE-Meta: U2FsdGVkX19wv3+D5f+hMsA1kQJateHFIS3+lk6cgXS3wUPGbZCdZs+6sD5KCFSUFW+2MN22gvwjuTkxPmqiRZ6JtDfaLiPnMC+DgaeYcxtAbweGvFMm/5vn5oDhUiXW9rKUz1pyvVXPSp75yFK/q/0MBDpyi3K/yrYBrP71kR2UuPb4MtXdUkLXEaSLorBNFTwTfSCJm60yHPdL4m6PaaW8qmibos3fE4Bh8gW+G9hJUqjKZ0N7sl55dgsjpa86oKO2iH38r4phj71+1ncYPKgrXg78Ey3CW5xeQNtyDHDxmUw4rNqtD4EYKL9lSDLzJwJBieaFF2JAG8z8MHk67FOQz22i20ovV0rZYyAf0yFIDz1SOcrXoMQpxUPNCMST9S225B77WezTeqjiieKG9ZKa3CgxEEaU5DALlPi599blF6yL7YYOwh2LEGg7Qm1Xh93MTSsXURU5IzRvp2h/k9BX+A8fCmtUaDFxlQVjSKrcdnQjbqOtLKb/xt8qJ3aqOUhVLqenfkdNowJ/C+Z3xG0x9l/SOlJ+mlWV1Vx7qPzA/t5oMyusEg69SrjPh/qo/a3PFUdblQ4+D40S6xDN0TN0/6P+N04GSKUjHW9u+V/7uSPj7qYZ/d1p3P7VQUQLKt37jGnJnD3KBIesQnM0ot3EBmzHAjCIxIl1qR5E6KmwBAfrC77iWvtAQGHOzafgQwTy7zKRJfelcR5U8OMKu0I96Tv9aUkhQItKDBTRe9FqnWl9Pj2ywEWrcaH1D9yQbN8BG+orQ5XFT3icX4AZt6PYaG3WwKXpHD0HwL5U9ru/ri91aFhpqwYy8efmj1QvEEWPEbOhuO/uNdZ6IKAUGGqJkCoyUILD7uVjdoUdKo/lgUFjfSumJt3X58cyWaIgl7xBFjAD8ONqJ9fOqwnQW8sNrs2XTNnaX24HTEwaHJIvrj5ELMzKoQVRgrVskUcyMJ0AKZQu9v3bGbU/Yqo
 4shXN5Qh
 1w4ctmDhQHP3nLZoRRHodjXSn/y2V2MPMn51e4vPllVjt9O5oh/MpzO8PUeYyCRJBaZZZuWZveeEik+2hXK+yiGd4J1qapl+mKfQU9QLxZMuLPe6fg/ug2OTqnR5gDy2qKRD/1mS4VZezIv/KfSeSZRY/nD9Yt4zvMrT57qqIiK9dU00PcLlmw/qU2lD+JS7Bs+ZZeq5DwKc9wcxIQjBe8se5qBh3preU2BXwR7HYtEsN79leW3AbZdn7cEMwSTT3gEwk7eYidwLEvbjcCoTlakM4ILolljE2s5kNG7GGtv01SbRPxbHeZ3kdQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:41=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Currently slabs are only frozen after consistency checks failed. This
> can happen only in caches with debugging enabled, and those use
> free_to_partial_list() for freeing. The non-debug operation of
> __slab_free() can thus stop considering the frozen field, and we can
> remove the FREE_FROZEN stat.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Functionally looks fine to me. Do we need to do something about the
UAPI breakage that removal of a sysfs node might cause?

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 476a279f1a94..7ec7049c0ca5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -333,7 +333,6 @@ enum stat_item {
>         FREE_RCU_SHEAF_FAIL,    /* Failed to free to a rcu_free sheaf */
>         FREE_FASTPATH,          /* Free to cpu slab */
>         FREE_SLOWPATH,          /* Freeing not to cpu slab */
> -       FREE_FROZEN,            /* Freeing to frozen slab */
>         FREE_ADD_PARTIAL,       /* Freeing moves slab to partial list */
>         FREE_REMOVE_PARTIAL,    /* Freeing removes last object */
>         ALLOC_FROM_PARTIAL,     /* Cpu slab acquired from node partial li=
st */
> @@ -5103,7 +5102,7 @@ static void __slab_free(struct kmem_cache *s, struc=
t slab *slab,
>                         unsigned long addr)
>
>  {
> -       bool was_frozen, was_full;
> +       bool was_full;
>         struct freelist_counters old, new;
>         struct kmem_cache_node *n =3D NULL;
>         unsigned long flags;
> @@ -5126,7 +5125,6 @@ static void __slab_free(struct kmem_cache *s, struc=
t slab *slab,
>                 old.counters =3D slab->counters;
>
>                 was_full =3D (old.freelist =3D=3D NULL);
> -               was_frozen =3D old.frozen;
>
>                 set_freepointer(s, tail, old.freelist);
>
> @@ -5139,7 +5137,7 @@ static void __slab_free(struct kmem_cache *s, struc=
t slab *slab,
>                  * to (due to not being full anymore) the partial list.
>                  * Unless it's frozen.
>                  */
> -               if ((!new.inuse || was_full) && !was_frozen) {
> +               if (!new.inuse || was_full) {
>
>                         n =3D get_node(s, slab_nid(slab));
>                         /*
> @@ -5158,20 +5156,10 @@ static void __slab_free(struct kmem_cache *s, str=
uct slab *slab,
>         } while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"=
));
>
>         if (likely(!n)) {
> -
> -               if (likely(was_frozen)) {
> -                       /*
> -                        * The list lock was not taken therefore no list
> -                        * activity can be necessary.
> -                        */
> -                       stat(s, FREE_FROZEN);
> -               }
> -
>                 /*
> -                * In other cases we didn't take the list_lock because th=
e slab
> -                * was already on the partial list and will remain there.
> +                * We didn't take the list_lock because the slab was alre=
ady on
> +                * the partial list and will remain there.
>                  */
> -
>                 return;
>         }
>
> @@ -8721,7 +8709,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
>  STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
>  STAT_ATTR(FREE_FASTPATH, free_fastpath);
>  STAT_ATTR(FREE_SLOWPATH, free_slowpath);
> -STAT_ATTR(FREE_FROZEN, free_frozen);
>  STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
>  STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
>  STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
> @@ -8826,7 +8813,6 @@ static struct attribute *slab_attrs[] =3D {
>         &free_rcu_sheaf_fail_attr.attr,
>         &free_fastpath_attr.attr,
>         &free_slowpath_attr.attr,
> -       &free_frozen_attr.attr,
>         &free_add_partial_attr.attr,
>         &free_remove_partial_attr.attr,
>         &alloc_from_partial_attr.attr,
>
> --
> 2.52.0
>

