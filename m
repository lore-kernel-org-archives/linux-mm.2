Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16FAD4A603
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 05:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D306B0088; Fri, 16 Jan 2026 00:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBA26B0089; Fri, 16 Jan 2026 00:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5216B008A; Fri, 16 Jan 2026 00:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDB1C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:45:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECEEA140562
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:45:39 +0000 (UTC)
X-FDA: 84336739998.11.38F093D
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17F34100005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:45:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=grarBrjT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768542338; a=rsa-sha256;
	cv=pass;
	b=OjVatJEUgZossTLTsOFkUKL2LKGOp4/mFmCf9DmHpQIrMU8imokO6mrNANnftPjtEvr43B
	5swQpxnMm+nwIbCDUXbttH9tYSfcV6VIyzcCpbX0vFYjfTtqmnU9/EuwxGTvU7UugAuE/g
	5DvwD44n8i28qgk16VyLBs1lqakRCD4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=grarBrjT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768542338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD4lKTyPruUjM+2ZGAjFWRV4Lq8q1KPCB1ITiVRP8FE=;
	b=fjfiatshf17TheodwenVi20xiDlAMnuEdNBDRhhjndGp4H7OrHIw+Spy1rv/+rYlyyjSmD
	Xko4mP0zrX32l3tESQH5nuMxcC784o65IUGq8rOiHhmfdDUB8w/w0nM8AyYxQHgOyDfv/Y
	D/J1e2Wri9KalJDxGXtk7MaBJ8Xai58=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014acad6f2so227881cf.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:45:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768542337; cv=none;
        d=google.com; s=arc-20240605;
        b=M94N3yhF3xeEto2z5b202b0KqC1fMGJw5Z7YMX8OSd6KPsXEr/+FaVRabtnP/H9sWW
         sKJScr2mvbSCthNIL99kfSTt1rUFrELD/Vxh+Ot9jITDk0oT1FHGmYczT7L7ify+/8zu
         V7s6SUN4eu5WY7QgEaamsp4jHHAfZ4mp6/lGQkwvN2oEF19qCbDjNA8TuZ0Ccmv05MKM
         KCRE39YbCHjOmDFsPKq42UJ4BaryngXKlb8uT+/u5A3TvVGOJ4TbuRb8cyKSc8EiSg7/
         F4GlDPcuZQo4qx488w0BCgwkyBET71tgv8iLtl8bupo3+c2ggH4XhhJsuYXGFp1H6svh
         LK9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oD4lKTyPruUjM+2ZGAjFWRV4Lq8q1KPCB1ITiVRP8FE=;
        fh=qQYi905PnJBNgpyxLc8gl7/GUgIvqnzmGMSDgiPjiig=;
        b=cLIZlBfGa97ec1yL1mQHKPLmOg1FfTpAlK/gsWgYoeaB+H6P4PEYfZKbvkCj/xma7K
         5/BkRxHssgv1+OZSAqR8/GfTvIzDB6TZH0ww0Umv1oMVLmUIyKZdHMmrUYfItQqJNYI8
         kGpNpl6s63W40SeAW6bNr2kBYYhtSoPlWh7eJ4uXygT9a3qqOX4U8B8G91OlDzBJ/SEe
         Ra2GC2b77heyDY0uNfU111SHXeq9ruw9mW/WodZRtsANN8ZP0HVg6YAzcdi8U9YZ+17Q
         4zXmakSUgtPXZsIYmofDLMig/hAchAnKxsg3EuEVyT/YoB632qK5XsnQZTkKFDUp8GXM
         GnOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768542337; x=1769147137; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oD4lKTyPruUjM+2ZGAjFWRV4Lq8q1KPCB1ITiVRP8FE=;
        b=grarBrjTV2aCDWc7abR1EytN+gECdSIjMjzFG/OytCmsrRaVG6CimNVTWGN7eGywR4
         pQPIyB+Jkkc3+j7ADopgY/uC1aJ+SRzqBZAy89F6dE7Hz2biPQBKJhsfoXQ76ofwPnH4
         S36fVWB1VswONwIQ9AA08Ve4qVrJIQPk4JYgMaqD3DlmYtF1kttflD1y0vOJMm48WZZ7
         bUicNUl2wc51hOhHrX10dAqA+V/EcSnBiD3RmzS3mIt/UwH6YCDZFAQNzfy9+ieoApb/
         8bFoe8ZIN3hod86SgqsCbJNcm0ExZWgW3nYHFYW+dZDNJ4rnmxJJKMkFe3pTyulR8zAg
         vHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768542337; x=1769147137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oD4lKTyPruUjM+2ZGAjFWRV4Lq8q1KPCB1ITiVRP8FE=;
        b=OeScUx+RuxazF851WEanVO7lQqSzRsFKlFrBIl9aXznS9DGSd9kml4CweyfELZRTmb
         kkZxG+EYHzmNFwkIGQ0GaeyRZdbgJXqNtVoTnb6jSa3Me7WkePxGDAk405MRX3bE2oDx
         aFcQiFqid8RkNoNUjXoyOBuIbXPRejPIG894CZiurcIACRWioFm+v0igV0Wu7CEyl0BK
         isnLxK5jbWh5u7l5NAgzl2L/qj6HfuBx/Nw/dG2j4Yvu8w/EJbrX1DB/xI+j8nlhtYEu
         TEIDLyi90MrGGOHn9KiJoFvmO62n9dngKhpQ59N1f5KmEYn+z7dkYdBBkmqrG/c7Ol6A
         Ee5A==
X-Forwarded-Encrypted: i=1; AJvYcCX1sW0ReRhNw4UhMr2vfWBdhWMjJcC9t8C1UINFFMyCtsf41ED3Hl9wNCW72rRvY39EnOBNdvQvcw==@kvack.org
X-Gm-Message-State: AOJu0YyUoxqe3CcyVNxVXD+zR/s9zEaQtrdDedH+bLspAONLj5+4vUb2
	UXM+zPtIBqUeDu2WtPp4Di/IsXpJgggFPmOxlDuOuvdxjs0SadeO8vvURB2XQtT0b+grsGlHYHq
	/bZ2VKSsiEcBXPdtRD07SaZL+xCXC6nt2KpjLk863
X-Gm-Gg: AY/fxX5ga7/NatRIdF2CaOK7mYvgTHTfCit4kDOJDujkO/aW5lR7uuTlBwiqLutdh8Y
	tEJ1XcSmdVCiULVDyX6icdywpkiglYZUIp94L0K012JeQVZwi2/cGwN0p46r2ipUnbswMIW7Whd
	4L6HyCfLnBv/sXm6TFO9JoIAYDH9qDMI3KChi3sAJ3Bzixyn6wWYooKissnJEiHBoMLDIscxkq5
	iMNkqBZKNzjd8KJsdf3QqPfBrUWuH38k6ZKOM0ZhHnZU9DHyalKPUTkWxtyc1bLWWFZymu50dj0
	+oPPumEatloJcQUmoIQrTbfLLARlX6J8Ig==
X-Received: by 2002:ac8:5a93:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-502a23ba0bemr6815851cf.12.1768542336851; Thu, 15 Jan 2026
 21:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz> <20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 05:45:26 +0000
X-Gm-Features: AZwV_Qj313U65TQKJGcZKomalyp4G4s3S9dwtw3N-deAJ8pCUFL8HFCSglYguDc
Message-ID: <CAJuCfpFKKtxB2mREuOSa4oQu=MBGkbQRQNYSSnubAAgPENcO-Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 04/20] slab: add sheaves to most caches
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17F34100005
X-Stat-Signature: bsue5akj7rddidk6uq7f79jackuit7u4
X-Rspam-User: 
X-HE-Tag: 1768542337-135717
X-HE-Meta: U2FsdGVkX19Cm291JrIcG2JsYDmYCN3Tj8Ygfzug2kQ5+pTFRsyNGmFI8EzSn4l/XquaSknBkKTgcYIzRo7iEGAG6lb7aW1zLLH3wVSuwDfLMl9bdfjGb7E8bgsKl/t6lfTp3puoWr/yP+4DVld2nwG0VZTU0VNV78RJ3RuZiWkhelIVJHCDG8DKEVmTs9zHaXfprjrMjmIAte+oIoQzWMVFUSeKIorn7IB2zk4xnt0j0i8RKFjPlOWs7AKQfGsLCWEmIOomWnTTZUqbxmsOIYQhDoXgAhTVg3ukMWILGpeA7zK8U0z7IMu+7A+x9y0jjF0qI8Vx2MIoVzmHOxdJBRdX/nanEqw1ycmvNK6Jk5ZI9fUf4dG/O9JwkTNa3z3i9qtjcF6sXmDTyqqtj8Iq1ZFs7xS9gIwaR204GsBIQmgz+EvcfY08cFl1SQHxZ7BdxbuJFyqg41E0ENZS4ZxM+ETwOrw6jzbn4FHlDiokD02c7Qo8Xo66+/Re4RTxqZ9+4JMOy0PXbRSw1kvvj8vk/0ygvl/IouNqcXhTYcjkOhLjnShY8TxkOnxS8zYgjrdOAnZ1x6Xfsgj3+imdI86gqfGkmgdtFpqfTGX2wIDltQGTnHx8OoRYDoklkIojvThWU9NZhKeLeYUI+0g1g5gYjMS0F7hjNbzeNkRHTD7DMJ7IlDCYCkgYOONrDQliBUpi9g/ldE/+CLYCbEdkwqEEkC9O2/Bu0tm04fRKMlyU+pK5Zdi7oKbO5ZDmV65IsHGMVvLa/rU8V6BT9IRi2ZL2YH9Lmr38HsRXfQO3jy2veBhTz5r7CnJh3uoCUhshTRCfxXQ1a0+boVTddxWqKCyb3T80zH1D+r13zCbwoQoCBBWjQGF3q0bh/cwgM8IVd/+4DCaoKF45N8ioU4+YYbH53IBj/JjtwhbJ1fZrCl+5/QfpqVrt4bI9UIedTzNBoKDW2tn2WGB9Tbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 3:17=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().
>
> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
>
> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> even for !CONFIG_SLAB_OBJ_EXT.
>
> This limitation will be lifted for kmalloc caches after the necessary
> bootstrapping changes.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

One nit but otherwise LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/slab.h |  6 ------
>  mm/slub.c            | 51 ++++++++++++++++++++++++++++++++++++++++++++++=
+----
>  2 files changed, 47 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 2482992248dc..2682ee57ec90 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -57,9 +57,7 @@ enum _slab_flag_bits {
>  #endif
>         _SLAB_OBJECT_POISON,
>         _SLAB_CMPXCHG_DOUBLE,
> -#ifdef CONFIG_SLAB_OBJ_EXT
>         _SLAB_NO_OBJ_EXT,
> -#endif
>         _SLAB_FLAGS_LAST_BIT
>  };
>
> @@ -238,11 +236,7 @@ enum _slab_flag_bits {
>  #define SLAB_TEMPORARY         SLAB_RECLAIM_ACCOUNT    /* Objects are sh=
ort-lived */
>
>  /* Slab created using create_boot_cache */
> -#ifdef CONFIG_SLAB_OBJ_EXT
>  #define SLAB_NO_OBJ_EXT                __SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
> -#else
> -#define SLAB_NO_OBJ_EXT                __SLAB_FLAG_UNUSED
> -#endif
>
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> diff --git a/mm/slub.c b/mm/slub.c
> index 8ffeb3ab3228..6e05e3cc5c49 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7857,6 +7857,48 @@ static void set_cpu_partial(struct kmem_cache *s)
>  #endif
>  }
>
> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> +                                            struct kmem_cache_args *args=
)
> +
> +{
> +       unsigned int capacity;
> +       size_t size;
> +
> +
> +       if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
> +               return 0;
> +
> +       /* bootstrap caches can't have sheaves for now */
> +       if (s->flags & SLAB_NO_OBJ_EXT)
> +               return 0;
> +
> +       /*
> +        * For now we use roughly similar formula (divided by two as ther=
e are
> +        * two percpu sheaves) as what was used for percpu partial slabs,=
 which
> +        * should result in similar lock contention (barn or list_lock)
> +        */
> +       if (s->size >=3D PAGE_SIZE)
> +               capacity =3D 4;
> +       else if (s->size >=3D 1024)
> +               capacity =3D 12;
> +       else if (s->size >=3D 256)
> +               capacity =3D 26;
> +       else
> +               capacity =3D 60;
> +
> +       /* Increment capacity to make sheaf exactly a kmalloc size bucket=
 */
> +       size =3D struct_size_t(struct slab_sheaf, objects, capacity);
> +       size =3D kmalloc_size_roundup(size);
> +       capacity =3D (size - struct_size_t(struct slab_sheaf, objects, 0)=
) / sizeof(void *);
> +
> +       /*
> +        * Respect an explicit request for capacity that's typically moti=
vated by
> +        * expected maximum size of kmem_cache_prefill_sheaf() to not end=
 up
> +        * using low-performance oversize sheaves
> +        */
> +       return max(capacity, args->sheaf_capacity);
> +}
> +
>  /*
>   * calculate_sizes() determines the order and the distribution of data w=
ithin
>   * a slab object.
> @@ -7991,6 +8033,10 @@ static int calculate_sizes(struct kmem_cache_args =
*args, struct kmem_cache *s)
>         if (s->flags & SLAB_RECLAIM_ACCOUNT)
>                 s->allocflags |=3D __GFP_RECLAIMABLE;
>
> +       /* kmalloc caches need extra care to support sheaves */
> +       if (!is_kmalloc_cache(s))

nit: All the checks for the cases when sheaves should not be used
(like SLAB_DEBUG_FLAGS and SLAB_NO_OBJ_EXT) are done inside
calculate_sheaf_capacity(). Only this is_kmalloc_cache() one is here.
It would be nice to have all of them in the same place but maybe you
have a reason for keeping it here?

> +               s->sheaf_capacity =3D calculate_sheaf_capacity(s, args);
> +
>         /*
>          * Determine the number of objects per slab
>          */
> @@ -8595,15 +8641,12 @@ int do_kmem_cache_create(struct kmem_cache *s, co=
nst char *name,
>
>         set_cpu_partial(s);
>
> -       if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
> -                                       && !(s->flags & SLAB_DEBUG_FLAGS)=
) {
> +       if (s->sheaf_capacity) {
>                 s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_sheave=
s);
>                 if (!s->cpu_sheaves) {
>                         err =3D -ENOMEM;
>                         goto out;
>                 }
> -               // TODO: increase capacity to grow slab_sheaf up to next =
kmalloc size?
> -               s->sheaf_capacity =3D args->sheaf_capacity;
>         }
>
>  #ifdef CONFIG_NUMA
>
> --
> 2.52.0
>

