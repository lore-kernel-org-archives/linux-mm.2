Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36EE4CA5FB8
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7939E6B047E; Tue, 20 Jan 2026 13:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C066B0480; Tue, 20 Jan 2026 13:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6229F6B0481; Tue, 20 Jan 2026 13:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5058F6B047E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:07:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DC471AE689
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:07:06 +0000 (UTC)
X-FDA: 84353123652.17.D0F90F4
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id A53A2A0015
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:07:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=owOfDtKw;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768932423; a=rsa-sha256;
	cv=pass;
	b=a+xpHY8lKhOiaShzw48KOKwSVOG8dg+SHZWiSqePc+MD1oD+G2WPqZ/FYjJV62Y4g9tdaR
	cLXpK/35z811tYjWR4N9c/4ZJy9mw7tRe6sPyjvpx9OaA0Z1WRtFsvnOwsaOUNvoHFFINK
	gcAtqfKUSBMV+j/NLZ42slpzVf7Hl6Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=owOfDtKw;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768932423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m4EgKcvHAigyFoIen3o4lxoSu/pBeXLeIue1VEAhmI=;
	b=ML4IctPDx+VNUF2LK7jMdRmYsxqZoH4Rkc54pFNSbCagsMinlIu6ZXLB/BzxrbnK0WFsj1
	5xE6+97xKN8yblgkEvIPzAlolwWxMD1yoKjuEy6VMjfqS8St3yWRPYIezmhC4FybENySMx
	pRqtZXhYNnWBpbfA90QOnJFb1mn0zaE=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so497a12.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:07:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768932422; cv=none;
        d=google.com; s=arc-20240605;
        b=Sq7ywtMrwe+YkvVQvZM/EIdl3Jt6y0d4mAHGB2+pt40GCKuZOklROR1b9HY/Jgks5t
         v1k/22bUmpAMY6uNqQxenCF13YsOMd2Jj6IXr0qZod/wAW6k0Cf6klXBhdl+fDpFtTF0
         Vm7GiosOZrSY+/5j0z9ipjoyxSXui9LFUy7H9LPjnI00GXholTwUzUKZJqsT9xtujoOK
         5EXhw6VPz+y8JBg9Tvxd23OEjpTUIcnqCbCoQRZkEDbxBsLU9Bvjl9mTpBm3AD4aqllt
         QLTY/YFKVuFN2fJmoP8YkkOlZgKjDM9ZwWXtgRvqKjRxo2ryEOTD40YpDXMWwat161re
         pfow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0m4EgKcvHAigyFoIen3o4lxoSu/pBeXLeIue1VEAhmI=;
        fh=S2Ynw3nfb8XJCSLrsKFLne86t3oIU5C5UE6KZfQPe/s=;
        b=cplmVmdJ79qcjWtlt9oCdNXRAtthR3YCO+h/Mv2A5ZEC6/5Jdw4wrxslPn0kLYRkap
         XqPgYMDMExGsFab9YBjCkORUOHcflvlUnib2fEYBu/HGGOYea+z9/q28TziM0Q3TylqV
         MUaDS9vHtTa9gKijgvRmM6KdaofoTfpBohlgtNQuNEAxrFQMuockE78bOrm7OViPX06z
         Uhy5u16V8x9QB2/Qa2c0uWu/gMWuLX8DBouk3ILERi0H+F6WuqneI6CVyx+IaDMc11fv
         HCgNqe1NoGmw4mdwKPIq0WI5peT9HM13zVKpWVUg4mT9zkqzFsEKnlViqZfSeE0D8ULz
         Y7iQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768932422; x=1769537222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0m4EgKcvHAigyFoIen3o4lxoSu/pBeXLeIue1VEAhmI=;
        b=owOfDtKwQaKUztbh41AflTb/DwV/rJSe5eud9ZCOyh6NRCI7yGfHPJSIAMH09EwGDo
         56Uf4KgubAyf9HR+MdbVJs2ctArhGa1WUW6Te08AoqFLx61jgdvYYsLOob2Ydowb7YEq
         BdMut7U6zBwUdi6DrqjkEQK6MQ5XWt8vTtGmJIjCeBsY9K5ELHGn2WrIqpKn5QxI6zYk
         yZN4FmcrD1E9ongWIu6bbIOyhQgOlVyXu3ERcvhCa+Sejhdv1fMzleVSI73zv8l3P9rf
         hVn0YmS9w1nAvl8PQonA1B8I3rwA7kRKTsdBLOShEtoVFljNmcZP2zIr3pAaLYu33UPX
         XiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768932422; x=1769537222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0m4EgKcvHAigyFoIen3o4lxoSu/pBeXLeIue1VEAhmI=;
        b=FwBlQnrQ2Y2fD7xzKuvhz6inKkKKV2Tg9KM9O8XRZOmAKCnIUW6GXC3ZdU/8WPHQd8
         SgyMDwlBHVHjEt35FdcBJXajt7Gbnw919nv0KN4aUJkvgdPYH0rsMsDL/swOvZHBwKGF
         +Z3gTAYe0eRKb2875aGj/mzHU6Inzh1ZXrAjLbJl5lHmucCFkAq3w/rq3JcwPG8J0XHs
         jDuVFbs96lqkRHuB27gwY9xNF4tySaJ2JI5wT7lISC+xYdpyFNChnsCdhNrDku8Sdjtm
         sZ4eFXXFUi5ItsQOBXshxKHzbOQ5LJucFLWyy/GvGL/VeY8nb1Yjyw0neAPlY6MZJ8dF
         iVJw==
X-Forwarded-Encrypted: i=1; AJvYcCW4/phebh85Ikutht/jrwYnLltqUcQLdutNEn/zPLka9pahCDyuj+v/x9MMm1Dhmp7BqMOwF5Ax8w==@kvack.org
X-Gm-Message-State: AOJu0Yxx9WR03Rr855jUOiVFoeXRuUlty1JJbihEp+iQsYhG5FyvRfc2
	9k37uliPyeGDAtNRkjjUdlI3zjlEL4HLRpkAAont2p91Bsq7sZ7X0avbSZLB3H2uW9nMWC3B+KA
	v6tZxzZJbNtTiObeeP0J6/Apy0gcRSRtbykbeOSoK
X-Gm-Gg: AZuq6aIIwvntWBRc1JHb3FiW6DvQzXVMC9cqEkWOd9NjbOJ8fPF8gGlLDDD/NKW6fy6
	a24cpEIFk82CfaOmpN8UWSmCAPSp4hl7QTF9s9UyhRtsQbmoLMbkPZkUhL79BfTkFrwh7E7VXmK
	CE1IE1SdqHC5DHfm4eFRqDZo5hl0Uo0HdHc+v5y8X6jtorAmsdTQ3G3H72b0pAdHRtnO+C0dFL1
	QSZ5vZN5HCd1Y1w1n+WbtkMczkuajByCRoUZUDWxorbXSMxS7hXvya085p7h4DJe4O+KWSbP5gI
	7raxIfhv9nLVDilFGF4ixSk=
X-Received: by 2002:a05:6402:1659:b0:658:e7a:6fa7 with SMTP id
 4fb4d7f45d1cf-6581398f92amr1073a12.4.1768932421563; Tue, 20 Jan 2026 10:07:01
 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-10-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-10-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 20 Jan 2026 18:06:46 +0000
X-Gm-Features: AZwV_QhAI_v8nb72cx00QIZiPM3CMYUd_28UNx83-h0Ivydma0yfYiVC7xf4sY0
Message-ID: <CAJuCfpEEUs98yCiNA=QOPY6Qk7=QhSBF+gqPn5a+B+bYbQwvsQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/21] slab: remove cpu (partial) slabs usage from
 allocation paths
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
X-Rspamd-Queue-Id: A53A2A0015
X-Stat-Signature: sb4ms4qpzrnt8yu56sryyn4whp47aut3
X-Rspam-User: 
X-HE-Tag: 1768932423-437045
X-HE-Meta: U2FsdGVkX1982KkMEvqdwZaQaauSzC3YwXFJSWW5g1Cki5mtm7f95YnkGyjRX7wDyK0a2NdsF8M/mL+7LmI25Yi0eeZdtvjB7puXbBSCwNlif+M3Tf4x5ifbjbRM8NBdPt/AmXovN5WvXsqU/J9FQmN1QBlGC+4EpkxlSP5HfZJI3v91n+4D4DvsOFfxo80eMPDFUyhjAxQBoogszop1V/RZc0KSDOS0m1Gs2zACytM9CaH4Qbdzwf4sofNpVoZzl4F8ZpLfxzv/oEvLUGjIGdHCC7PzX+sYSWKvacZ++DjVN/fCIZQYy9IwgF8/8mGn8Xsedz99kHLIncvq6Wc1IwOSFssdqVXVmbwec3cGg8QC4UxWUe8lGnaYBYBne+tIWUxZgmKHB7V+gHicoaniuNuNSVMYF/gSG778PlyAD4PuD1DMMD6hJDpaXo5T2M3eALygROPrKA/ua9jv2CdgAHa6aWkZy8QvkM7cFlCwGmubndlp5AVOGSgPhV3Wgxuxnz2L/Bm5riZHkC2L1U+XMjz4W6pr+sHvENSXKOMYm+6xn2Saw4BTNI7wtF6L/W0GIdf8XUaUu8yPOEY08Ix9vTpv404vcPj3QqPbOzbI3gyETat2bYGKzmNX9Wa95df/HgdyPNh/VY3/92xQiGjaRVRA+N06aCQP1AqtyDJzIA1GORdnZ9wFnPxpltTnxTfSH7r3aedf9Nf+0qukWbte5J5yIQ5sL1/78UI5c874s2FKlBnYolTBN9Vs9OVMXnuoVereJf6wWqbe5ChiIksu1i28OBnwMH1m5TzV6q3uJZWk1SVc2usHgl7UdmFNXC/ZQWaOdRVh/IGKurkTGa8PjeAfWoMMZgP+4baPNgNBuEqa9yuMPopDL7CDnLnfVN0sKQBJm2WhNU2mzFFzmVdQNllQkzsLeEBIb1V0s5Tz4TI+GxhjjSRRVUOC4fgg1x97MLPWk45s92mAMtIUhLP
 UK15k639
 hWF1Jd0ulAfe1AOuQkjY95LWprhi5q6KilxSy/EhdKwgmVRamW77/g1GMS50hoyn5tIBbd30k+wL+iCyJ7VD7X0pJ2L9uhxRis/DuMgRZRB+BB0kCldnRtfXJJpFP1IzrMxwFp8rQGyYeWkwjHvymQtBzJea02a8ROmUrEtGdkFPDOunxcOU0oc//hios+/M7+TnC7npCda+JoFaU/2QUIrwDNZ54VPRxHIw8HrB5STaev4Ba5eLWswuV2o+A81N3ga6sj42MxTD6D0UvuI5deINnAeUOWnmRBYFmPgxsxThg3TxUC1w/+tjmKlJnfFNUfL6M/P+9HDc7MYoIqP6KgEjgSjs+WRgsfLhO
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
> We now rely on sheaves as the percpu caching layer and can refill them
> directly from partial or newly allocated slabs. Start removing the cpu
> (partial) slabs code, first from allocation paths.
>
> This means that any allocation not satisfied from percpu sheaves will
> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
> slabs, so it will only perform get_partial() or new_slab(). In the
> latter case we reuse alloc_from_new_slab() (when we don't use
> the debug/tiny alloc_single_from_new_slab() variant).
>
> In get_partial_node() we used to return a slab for freezing as the cpu
> slab and to refill the partial slab. Now we only want to return a single
> object and leave the slab on the list (unless it became full). We can't
> simply reuse alloc_single_from_partial() as that assumes freeing uses
> free_to_partial_list(). Instead we need to use __slab_update_freelist()
> to work properly against a racing __slab_free().
>
> The rest of the changes is removing functions that no longer have any
> callers.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

A couple of nits, but otherwise seems fine to me.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 612 ++++++++------------------------------------------------=
------
>  1 file changed, 79 insertions(+), 533 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index dce80463f92c..698c0d940f06 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -245,7 +245,6 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
>  struct partial_context {
>         gfp_t flags;
>         unsigned int orig_size;
> -       void *object;
>         unsigned int min_objects;
>         unsigned int max_objects;
>         struct list_head slabs;
> @@ -611,36 +610,6 @@ static inline void *get_freepointer(struct kmem_cach=
e *s, void *object)
>         return freelist_ptr_decode(s, p, ptr_addr);
>  }
>
> -static void prefetch_freepointer(const struct kmem_cache *s, void *objec=
t)
> -{
> -       prefetchw(object + s->offset);
> -}
> -
> -/*
> - * When running under KMSAN, get_freepointer_safe() may return an uninit=
ialized
> - * pointer value in the case the current thread loses the race for the n=
ext
> - * memory chunk in the freelist. In that case this_cpu_cmpxchg_double() =
in
> - * slab_alloc_node() will fail, so the uninitialized value won't be used=
, but
> - * KMSAN will still check all arguments of cmpxchg because of imperfect
> - * handling of inline assembly.
> - * To work around this problem, we apply __no_kmsan_checks to ensure tha=
t
> - * get_freepointer_safe() returns initialized memory.
> - */
> -__no_kmsan_checks
> -static inline void *get_freepointer_safe(struct kmem_cache *s, void *obj=
ect)
> -{
> -       unsigned long freepointer_addr;
> -       freeptr_t p;
> -
> -       if (!debug_pagealloc_enabled_static())
> -               return get_freepointer(s, object);
> -
> -       object =3D kasan_reset_tag(object);
> -       freepointer_addr =3D (unsigned long)object + s->offset;
> -       copy_from_kernel_nofault(&p, (freeptr_t *)freepointer_addr, sizeo=
f(p));
> -       return freelist_ptr_decode(s, p, freepointer_addr);
> -}
> -
>  static inline void set_freepointer(struct kmem_cache *s, void *object, v=
oid *fp)
>  {
>         unsigned long freeptr_addr =3D (unsigned long)object + s->offset;
> @@ -720,23 +689,11 @@ static void slub_set_cpu_partial(struct kmem_cache =
*s, unsigned int nr_objects)
>         nr_slabs =3D DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
>         s->cpu_partial_slabs =3D nr_slabs;
>  }
> -
> -static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
> -{
> -       return s->cpu_partial_slabs;
> -}
> -#else
> -#ifdef SLAB_SUPPORTS_SYSFS
> +#elif defined(SLAB_SUPPORTS_SYSFS)
>  static inline void
>  slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
>  {
>  }
> -#endif
> -
> -static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
> -{
> -       return 0;
> -}
>  #endif /* CONFIG_SLUB_CPU_PARTIAL */
>
>  /*
> @@ -1077,7 +1034,7 @@ static void set_track_update(struct kmem_cache *s, =
void *object,
>         p->handle =3D handle;
>  #endif
>         p->addr =3D addr;
> -       p->cpu =3D smp_processor_id();
> +       p->cpu =3D raw_smp_processor_id();
>         p->pid =3D current->pid;
>         p->when =3D jiffies;
>  }
> @@ -3583,15 +3540,15 @@ static bool get_partial_node_bulk(struct kmem_cac=
he *s,
>  }
>
>  /*
> - * Try to allocate a partial slab from a specific node.
> + * Try to allocate object from a partial slab on a specific node.
>   */
> -static struct slab *get_partial_node(struct kmem_cache *s,
> -                                    struct kmem_cache_node *n,
> -                                    struct partial_context *pc)
> +static void *get_partial_node(struct kmem_cache *s,
> +                             struct kmem_cache_node *n,
> +                             struct partial_context *pc)

Naming for get_partial()/get_partial_node()/get_any_partial() made
sense when they returned a slab. Now that they return object(s) the
naming is a bit confusing. I think renaming to
get_from_partial()/get_from_partial_node()/get_from_any_partial()
would be more appropriate.

>  {
> -       struct slab *slab, *slab2, *partial =3D NULL;
> +       struct slab *slab, *slab2;
>         unsigned long flags;
> -       unsigned int partial_slabs =3D 0;
> +       void *object =3D NULL;
>
>         /*
>          * Racy check. If we mistakenly see no partial slabs then we
> @@ -3607,54 +3564,55 @@ static struct slab *get_partial_node(struct kmem_=
cache *s,
>         else if (!spin_trylock_irqsave(&n->list_lock, flags))
>                 return NULL;
>         list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +
> +               struct freelist_counters old, new;
> +
>                 if (!pfmemalloc_match(slab, pc->flags))
>                         continue;
>
>                 if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) =
{
> -                       void *object =3D alloc_single_from_partial(s, n, =
slab,
> +                       object =3D alloc_single_from_partial(s, n, slab,
>                                                         pc->orig_size);
> -                       if (object) {
> -                               partial =3D slab;
> -                               pc->object =3D object;
> +                       if (object)
>                                 break;
> -                       }
>                         continue;
>                 }
>
> -               remove_partial(n, slab);
> +               /*
> +                * get a single object from the slab. This might race aga=
inst
> +                * __slab_free(), which however has to take the list_lock=
 if
> +                * it's about to make the slab fully free.
> +                */
> +               do {
> +                       old.freelist =3D slab->freelist;
> +                       old.counters =3D slab->counters;
>
> -               if (!partial) {
> -                       partial =3D slab;
> -                       stat(s, ALLOC_FROM_PARTIAL);
> +                       new.freelist =3D get_freepointer(s, old.freelist)=
;
> +                       new.counters =3D old.counters;
> +                       new.inuse++;
>
> -                       if ((slub_get_cpu_partial(s) =3D=3D 0)) {
> -                               break;
> -                       }
> -               } else {
> -                       put_cpu_partial(s, slab, 0);
> -                       stat(s, CPU_PARTIAL_NODE);
> +               } while (!__slab_update_freelist(s, slab, &old, &new, "ge=
t_partial_node"));
>
> -                       if (++partial_slabs > slub_get_cpu_partial(s) / 2=
) {
> -                               break;
> -                       }
> -               }
> +               object =3D old.freelist;
> +               if (!new.freelist)
> +                       remove_partial(n, slab);
> +
> +               break;
>         }
>         spin_unlock_irqrestore(&n->list_lock, flags);
> -       return partial;
> +       return object;
>  }
>
>  /*
> - * Get a slab from somewhere. Search in increasing NUMA distances.
> + * Get an object from somewhere. Search in increasing NUMA distances.
>   */
> -static struct slab *get_any_partial(struct kmem_cache *s,
> -                                   struct partial_context *pc)
> +static void *get_any_partial(struct kmem_cache *s, struct partial_contex=
t *pc)
>  {
>  #ifdef CONFIG_NUMA
>         struct zonelist *zonelist;
>         struct zoneref *z;
>         struct zone *zone;
>         enum zone_type highest_zoneidx =3D gfp_zone(pc->flags);
> -       struct slab *slab;
>         unsigned int cpuset_mems_cookie;
>
>         /*
> @@ -3689,8 +3647,10 @@ static struct slab *get_any_partial(struct kmem_ca=
che *s,
>
>                         if (n && cpuset_zone_allowed(zone, pc->flags) &&
>                                         n->nr_partial > s->min_partial) {
> -                               slab =3D get_partial_node(s, n, pc);
> -                               if (slab) {
> +
> +                               void *object =3D get_partial_node(s, n, p=
c);
> +
> +                               if (object) {
>                                         /*
>                                          * Don't check read_mems_allowed_=
retry()
>                                          * here - if mems_allowed was upd=
ated in
> @@ -3698,7 +3658,7 @@ static struct slab *get_any_partial(struct kmem_cac=
he *s,
>                                          * between allocation and the cpu=
set
>                                          * update
>                                          */
> -                                       return slab;
> +                                       return object;
>                                 }
>                         }
>                 }
> @@ -3708,20 +3668,20 @@ static struct slab *get_any_partial(struct kmem_c=
ache *s,
>  }
>
>  /*
> - * Get a partial slab, lock it and return it.
> + * Get an object from a partial slab
>   */
> -static struct slab *get_partial(struct kmem_cache *s, int node,
> -                               struct partial_context *pc)
> +static void *get_partial(struct kmem_cache *s, int node,
> +                        struct partial_context *pc)
>  {
> -       struct slab *slab;
>         int searchnode =3D node;
> +       void *object;
>
>         if (node =3D=3D NUMA_NO_NODE)
>                 searchnode =3D numa_mem_id();
>
> -       slab =3D get_partial_node(s, get_node(s, searchnode), pc);
> -       if (slab || (node !=3D NUMA_NO_NODE && (pc->flags & __GFP_THISNOD=
E)))
> -               return slab;
> +       object =3D get_partial_node(s, get_node(s, searchnode), pc);
> +       if (object || (node !=3D NUMA_NO_NODE && (pc->flags & __GFP_THISN=
ODE)))
> +               return object;
>
>         return get_any_partial(s, pc);
>  }
> @@ -4281,19 +4241,6 @@ static int slub_cpu_dead(unsigned int cpu)
>         return 0;
>  }
>
> -/*
> - * Check if the objects in a per cpu structure fit numa
> - * locality expectations.
> - */
> -static inline int node_match(struct slab *slab, int node)
> -{
> -#ifdef CONFIG_NUMA
> -       if (node !=3D NUMA_NO_NODE && slab_nid(slab) !=3D node)
> -               return 0;
> -#endif
> -       return 1;
> -}
> -
>  #ifdef CONFIG_SLUB_DEBUG
>  static int count_free(struct slab *slab)
>  {
> @@ -4478,36 +4425,6 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
>                                              &old.freelist_tid, new.freel=
ist_tid);
>  }
>
> -/*
> - * Check the slab->freelist and either transfer the freelist to the
> - * per cpu freelist or deactivate the slab.
> - *
> - * The slab is still frozen if the return value is not NULL.
> - *
> - * If this function returns NULL then the slab has been unfrozen.
> - */
> -static inline void *get_freelist(struct kmem_cache *s, struct slab *slab=
)
> -{
> -       struct freelist_counters old, new;
> -
> -       lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
> -
> -       do {
> -               old.freelist =3D slab->freelist;
> -               old.counters =3D slab->counters;
> -
> -               new.freelist =3D NULL;
> -               new.counters =3D old.counters;
> -
> -               new.inuse =3D old.objects;
> -               new.frozen =3D old.freelist !=3D NULL;
> -
> -
> -       } while (!__slab_update_freelist(s, slab, &old, &new, "get_freeli=
st"));
> -
> -       return old.freelist;
> -}
> -
>  /*
>   * Get the slab's freelist and do not freeze it.
>   *
> @@ -4535,29 +4452,6 @@ static inline void *get_freelist_nofreeze(struct k=
mem_cache *s, struct slab *sla
>         return old.freelist;
>  }
>
> -/*
> - * Freeze the partial slab and return the pointer to the freelist.
> - */
> -static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
> -{
> -       struct freelist_counters old, new;
> -
> -       do {
> -               old.freelist =3D slab->freelist;
> -               old.counters =3D slab->counters;
> -
> -               new.freelist =3D NULL;
> -               new.counters =3D old.counters;
> -               VM_BUG_ON(new.frozen);
> -
> -               new.inuse =3D old.objects;
> -               new.frozen =3D 1;
> -
> -       } while (!slab_update_freelist(s, slab, &old, &new, "freeze_slab"=
));
> -
> -       return old.freelist;
> -}
> -
>  /*
>   * If the object has been wiped upon free, make sure it's fully initiali=
zed by
>   * zeroing out freelist pointer.
> @@ -4618,170 +4512,23 @@ static unsigned int alloc_from_new_slab(struct k=
mem_cache *s, struct slab *slab,
>  }
>
>  /*
> - * Slow path. The lockless freelist is empty or we need to perform
> - * debugging duties.
> - *
> - * Processing is still very fast if new objects have been freed to the
> - * regular freelist. In that case we simply take over the regular freeli=
st
> - * as the lockless freelist and zap the regular freelist.
> - *
> - * If that is not working then we fall back to the partial lists. We tak=
e the
> - * first element of the freelist as the object to allocate now and move =
the
> - * rest of the freelist to the lockless freelist.
> - *
> - * And if we were unable to get a new slab from the partial slab lists t=
hen
> - * we need to allocate a new slab. This is the slowest path since it inv=
olves
> - * a call to the page allocator and the setup of a new slab.
> + * Slow path. We failed to allocate via percpu sheaves or they are not a=
vailable
> + * due to bootstrap or debugging enabled or SLUB_TINY.
>   *
> - * Version of __slab_alloc to use when we know that preemption is
> - * already disabled (which is the case for bulk allocation).
> + * We try to allocate from partial slab lists and fall back to allocatin=
g a new
> + * slab.
>   */
>  static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int nod=
e,
> -                         unsigned long addr, struct kmem_cache_cpu *c, u=
nsigned int orig_size)
> +                          unsigned long addr, unsigned int orig_size)
>  {
>         bool allow_spin =3D gfpflags_allow_spinning(gfpflags);
>         void *freelist;
>         struct slab *slab;
> -       unsigned long flags;
>         struct partial_context pc;
>         bool try_thisnode =3D true;
>
>         stat(s, ALLOC_SLOWPATH);
>
> -reread_slab:
> -
> -       slab =3D READ_ONCE(c->slab);
> -       if (!slab) {
> -               /*
> -                * if the node is not online or has no normal memory, jus=
t
> -                * ignore the node constraint
> -                */
> -               if (unlikely(node !=3D NUMA_NO_NODE &&
> -                            !node_isset(node, slab_nodes)))
> -                       node =3D NUMA_NO_NODE;
> -               goto new_slab;
> -       }
> -
> -       if (unlikely(!node_match(slab, node))) {
> -               /*
> -                * same as above but node_match() being false already
> -                * implies node !=3D NUMA_NO_NODE.
> -                *
> -                * We don't strictly honor pfmemalloc and NUMA preference=
s
> -                * when !allow_spin because:
> -                *
> -                * 1. Most kmalloc() users allocate objects on the local =
node,
> -                *    so kmalloc_nolock() tries not to interfere with the=
m by
> -                *    deactivating the cpu slab.
> -                *
> -                * 2. Deactivating due to NUMA or pfmemalloc mismatch may=
 cause
> -                *    unnecessary slab allocations even when n->partial l=
ist
> -                *    is not empty.
> -                */
> -               if (!node_isset(node, slab_nodes) ||
> -                   !allow_spin) {
> -                       node =3D NUMA_NO_NODE;
> -               } else {
> -                       stat(s, ALLOC_NODE_MISMATCH);
> -                       goto deactivate_slab;
> -               }
> -       }
> -
> -       /*
> -        * By rights, we should be searching for a slab page that was
> -        * PFMEMALLOC but right now, we are losing the pfmemalloc
> -        * information when the page leaves the per-cpu allocator
> -        */
> -       if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin))
> -               goto deactivate_slab;
> -
> -       /* must check again c->slab in case we got preempted and it chang=
ed */
> -       local_lock_cpu_slab(s, flags);
> -
> -       if (unlikely(slab !=3D c->slab)) {
> -               local_unlock_cpu_slab(s, flags);
> -               goto reread_slab;
> -       }
> -       freelist =3D c->freelist;
> -       if (freelist)
> -               goto load_freelist;
> -
> -       freelist =3D get_freelist(s, slab);
> -
> -       if (!freelist) {
> -               c->slab =3D NULL;
> -               c->tid =3D next_tid(c->tid);
> -               local_unlock_cpu_slab(s, flags);
> -               stat(s, DEACTIVATE_BYPASS);
> -               goto new_slab;
> -       }
> -
> -       stat(s, ALLOC_REFILL);
> -
> -load_freelist:
> -
> -       lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
> -
> -       /*
> -        * freelist is pointing to the list of objects to be used.
> -        * slab is pointing to the slab from which the objects are obtain=
ed.
> -        * That slab must be frozen for per cpu allocations to work.
> -        */
> -       VM_BUG_ON(!c->slab->frozen);
> -       c->freelist =3D get_freepointer(s, freelist);
> -       c->tid =3D next_tid(c->tid);
> -       local_unlock_cpu_slab(s, flags);
> -       return freelist;
> -
> -deactivate_slab:
> -
> -       local_lock_cpu_slab(s, flags);
> -       if (slab !=3D c->slab) {
> -               local_unlock_cpu_slab(s, flags);
> -               goto reread_slab;
> -       }
> -       freelist =3D c->freelist;
> -       c->slab =3D NULL;
> -       c->freelist =3D NULL;
> -       c->tid =3D next_tid(c->tid);
> -       local_unlock_cpu_slab(s, flags);
> -       deactivate_slab(s, slab, freelist);
> -
> -new_slab:
> -
> -#ifdef CONFIG_SLUB_CPU_PARTIAL
> -       while (slub_percpu_partial(c)) {
> -               local_lock_cpu_slab(s, flags);
> -               if (unlikely(c->slab)) {
> -                       local_unlock_cpu_slab(s, flags);
> -                       goto reread_slab;
> -               }
> -               if (unlikely(!slub_percpu_partial(c))) {
> -                       local_unlock_cpu_slab(s, flags);
> -                       /* we were preempted and partial list got empty *=
/
> -                       goto new_objects;
> -               }
> -
> -               slab =3D slub_percpu_partial(c);
> -               slub_set_percpu_partial(c, slab);
> -
> -               if (likely(node_match(slab, node) &&
> -                          pfmemalloc_match(slab, gfpflags)) ||
> -                   !allow_spin) {
> -                       c->slab =3D slab;
> -                       freelist =3D get_freelist(s, slab);
> -                       VM_BUG_ON(!freelist);
> -                       stat(s, CPU_PARTIAL_ALLOC);
> -                       goto load_freelist;
> -               }
> -
> -               local_unlock_cpu_slab(s, flags);
> -
> -               slab->next =3D NULL;
> -               __put_partials(s, slab);
> -       }
> -#endif
> -
>  new_objects:
>
>         pc.flags =3D gfpflags;
> @@ -4806,33 +4553,11 @@ static void *___slab_alloc(struct kmem_cache *s, =
gfp_t gfpflags, int node,
>         }
>
>         pc.orig_size =3D orig_size;
> -       slab =3D get_partial(s, node, &pc);
> -       if (slab) {
> -               if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) =
{
> -                       freelist =3D pc.object;
> -                       /*
> -                        * For debug caches here we had to go through
> -                        * alloc_single_from_partial() so just store the
> -                        * tracking info and return the object.
> -                        *
> -                        * Due to disabled preemption we need to disallow
> -                        * blocking. The flags are further adjusted by
> -                        * gfp_nested_mask() in stack_depot itself.
> -                        */
> -                       if (s->flags & SLAB_STORE_USER)
> -                               set_track(s, freelist, TRACK_ALLOC, addr,
> -                                         gfpflags & ~(__GFP_DIRECT_RECLA=
IM));
> -
> -                       return freelist;
> -               }
> -
> -               freelist =3D freeze_slab(s, slab);
> -               goto retry_load_slab;
> -       }
> +       freelist =3D get_partial(s, node, &pc);

I think all this cleanup results in this `freelist` variable being
used to always store a single object. Maybe rename it into `object`?

> +       if (freelist)
> +               goto success;
>
> -       slub_put_cpu_ptr(s->cpu_slab);
>         slab =3D new_slab(s, pc.flags, node);
> -       c =3D slub_get_cpu_ptr(s->cpu_slab);
>
>         if (unlikely(!slab)) {
>                 if (node !=3D NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE=
)
> @@ -4849,68 +4574,29 @@ static void *___slab_alloc(struct kmem_cache *s, =
gfp_t gfpflags, int node,
>         if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>                 freelist =3D alloc_single_from_new_slab(s, slab, orig_siz=
e, gfpflags);
>
> -               if (unlikely(!freelist)) {
> -                       /* This could cause an endless loop. Fail instead=
. */
> -                       if (!allow_spin)
> -                               return NULL;
> -                       goto new_objects;
> -               }
> -
> -               if (s->flags & SLAB_STORE_USER)
> -                       set_track(s, freelist, TRACK_ALLOC, addr,
> -                                 gfpflags & ~(__GFP_DIRECT_RECLAIM));
> -
> -               return freelist;
> -       }
> -
> -       /*
> -        * No other reference to the slab yet so we can
> -        * muck around with it freely without cmpxchg
> -        */
> -       freelist =3D slab->freelist;
> -       slab->freelist =3D NULL;
> -       slab->inuse =3D slab->objects;
> -       slab->frozen =3D 1;
> -
> -       inc_slabs_node(s, slab_nid(slab), slab->objects);
> +               if (likely(freelist))
> +                       goto success;
> +       } else {
> +               alloc_from_new_slab(s, slab, &freelist, 1, allow_spin);
>
> -       if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
> -               /*
> -                * For !pfmemalloc_match() case we don't load freelist so=
 that
> -                * we don't make further mismatched allocations easier.
> -                */
> -               deactivate_slab(s, slab, get_freepointer(s, freelist));
> -               return freelist;
> +               /* we don't need to check SLAB_STORE_USER here */
> +               if (likely(freelist))
> +                       return freelist;
>         }
>
> -retry_load_slab:
> -
> -       local_lock_cpu_slab(s, flags);
> -       if (unlikely(c->slab)) {
> -               void *flush_freelist =3D c->freelist;
> -               struct slab *flush_slab =3D c->slab;
> -
> -               c->slab =3D NULL;
> -               c->freelist =3D NULL;
> -               c->tid =3D next_tid(c->tid);
> -
> -               local_unlock_cpu_slab(s, flags);
> -
> -               if (unlikely(!allow_spin)) {
> -                       /* Reentrant slub cannot take locks, defer */
> -                       defer_deactivate_slab(flush_slab, flush_freelist)=
;
> -               } else {
> -                       deactivate_slab(s, flush_slab, flush_freelist);
> -               }
> +       if (allow_spin)
> +               goto new_objects;
>
> -               stat(s, CPUSLAB_FLUSH);
> +       /* This could cause an endless loop. Fail instead. */
> +       return NULL;
>
> -               goto retry_load_slab;
> -       }
> -       c->slab =3D slab;
> +success:
> +       if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> +               set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
>
> -       goto load_freelist;
> +       return freelist;
>  }
> +
>  /*
>   * We disallow kprobes in ___slab_alloc() to prevent reentrance
>   *
> @@ -4925,87 +4611,11 @@ static void *___slab_alloc(struct kmem_cache *s, =
gfp_t gfpflags, int node,
>   */
>  NOKPROBE_SYMBOL(___slab_alloc);
>
> -/*
> - * A wrapper for ___slab_alloc() for contexts where preemption is not ye=
t
> - * disabled. Compensates for possible cpu changes by refetching the per =
cpu area
> - * pointer.
> - */
> -static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node=
,
> -                         unsigned long addr, struct kmem_cache_cpu *c, u=
nsigned int orig_size)
> -{
> -       void *p;
> -
> -#ifdef CONFIG_PREEMPT_COUNT
> -       /*
> -        * We may have been preempted and rescheduled on a different
> -        * cpu before disabling preemption. Need to reload cpu area
> -        * pointer.
> -        */
> -       c =3D slub_get_cpu_ptr(s->cpu_slab);
> -#endif
> -       if (unlikely(!gfpflags_allow_spinning(gfpflags))) {
> -               if (local_lock_is_locked(&s->cpu_slab->lock)) {
> -                       /*
> -                        * EBUSY is an internal signal to kmalloc_nolock(=
) to
> -                        * retry a different bucket. It's not propagated
> -                        * to the caller.
> -                        */
> -                       p =3D ERR_PTR(-EBUSY);
> -                       goto out;
> -               }
> -       }
> -       p =3D ___slab_alloc(s, gfpflags, node, addr, c, orig_size);
> -out:
> -#ifdef CONFIG_PREEMPT_COUNT
> -       slub_put_cpu_ptr(s->cpu_slab);
> -#endif
> -       return p;
> -}
> -
>  static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
>                 gfp_t gfpflags, int node, unsigned long addr, size_t orig=
_size)
>  {
> -       struct kmem_cache_cpu *c;
> -       struct slab *slab;
> -       unsigned long tid;
>         void *object;
>
> -redo:
> -       /*
> -        * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> -        * enabled. We may switch back and forth between cpus while
> -        * reading from one cpu area. That does not matter as long
> -        * as we end up on the original cpu again when doing the cmpxchg.
> -        *
> -        * We must guarantee that tid and kmem_cache_cpu are retrieved on=
 the
> -        * same cpu. We read first the kmem_cache_cpu pointer and use it =
to read
> -        * the tid. If we are preempted and switched to another cpu betwe=
en the
> -        * two reads, it's OK as the two are still associated with the sa=
me cpu
> -        * and cmpxchg later will validate the cpu.
> -        */
> -       c =3D raw_cpu_ptr(s->cpu_slab);
> -       tid =3D READ_ONCE(c->tid);
> -
> -       /*
> -        * Irqless object alloc/free algorithm used here depends on seque=
nce
> -        * of fetching cpu_slab's data. tid should be fetched before anyt=
hing
> -        * on c to guarantee that object and slab associated with previou=
s tid
> -        * won't be used with current tid. If we fetch tid first, object =
and
> -        * slab could be one associated with next tid and our alloc/free
> -        * request will be failed. In this case, we will retry. So, no pr=
oblem.
> -        */
> -       barrier();
> -
> -       /*
> -        * The transaction ids are globally unique per cpu and per operat=
ion on
> -        * a per cpu queue. Thus they can be guarantee that the cmpxchg_d=
ouble
> -        * occurs on the right processor and that there was no operation =
on the
> -        * linked list in between.
> -        */
> -
> -       object =3D c->freelist;
> -       slab =3D c->slab;
> -
>  #ifdef CONFIG_NUMA
>         if (static_branch_unlikely(&strict_numa) &&
>                         node =3D=3D NUMA_NO_NODE) {
> @@ -5014,47 +4624,20 @@ static __always_inline void *__slab_alloc_node(st=
ruct kmem_cache *s,
>
>                 if (mpol) {
>                         /*
> -                        * Special BIND rule support. If existing slab
> +                        * Special BIND rule support. If the local node
>                          * is in permitted set then do not redirect
>                          * to a particular node.
>                          * Otherwise we apply the memory policy to get
>                          * the node we need to allocate on.
>                          */
> -                       if (mpol->mode !=3D MPOL_BIND || !slab ||
> -                                       !node_isset(slab_nid(slab), mpol-=
>nodes))
> -
> +                       if (mpol->mode !=3D MPOL_BIND ||
> +                                       !node_isset(numa_mem_id(), mpol->=
nodes))
>                                 node =3D mempolicy_slab_node();
>                 }
>         }
>  #endif
>
> -       if (!USE_LOCKLESS_FAST_PATH() ||
> -           unlikely(!object || !slab || !node_match(slab, node))) {
> -               object =3D __slab_alloc(s, gfpflags, node, addr, c, orig_=
size);
> -       } else {
> -               void *next_object =3D get_freepointer_safe(s, object);
> -
> -               /*
> -                * The cmpxchg will only match if there was no additional
> -                * operation and if we are on the right processor.
> -                *
> -                * The cmpxchg does the following atomically (without loc=
k
> -                * semantics!)
> -                * 1. Relocate first pointer to the current per cpu area.
> -                * 2. Verify that tid and freelist have not been changed
> -                * 3. If they were not changed replace tid and freelist
> -                *
> -                * Since this is without lock semantics the protection is=
 only
> -                * against code executing on this cpu *not* from access b=
y
> -                * other cpus.
> -                */
> -               if (unlikely(!__update_cpu_freelist_fast(s, object, next_=
object, tid))) {
> -                       note_cmpxchg_failure("slab_alloc", s, tid);
> -                       goto redo;
> -               }
> -               prefetch_freepointer(s, next_object);
> -               stat(s, ALLOC_FASTPATH);
> -       }
> +       object =3D ___slab_alloc(s, gfpflags, node, addr, orig_size);
>
>         return object;
>  }
> @@ -7711,62 +7294,25 @@ static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t si=
ze,
>                             void **p)
>  {
> -       struct kmem_cache_cpu *c;
> -       unsigned long irqflags;
>         int i;
>
>         /*
> -        * Drain objects in the per cpu slab, while disabling local
> -        * IRQs, which protects against PREEMPT and interrupts
> -        * handlers invoking normal fastpath.
> +        * TODO: this might be more efficient (if necessary) by reusing
> +        * __refill_objects()
>          */
> -       c =3D slub_get_cpu_ptr(s->cpu_slab);
> -       local_lock_irqsave(&s->cpu_slab->lock, irqflags);
> -
>         for (i =3D 0; i < size; i++) {
> -               void *object =3D c->freelist;
>
> -               if (unlikely(!object)) {
> -                       /*
> -                        * We may have removed an object from c->freelist=
 using
> -                        * the fastpath in the previous iteration; in tha=
t case,
> -                        * c->tid has not been bumped yet.
> -                        * Since ___slab_alloc() may reenable interrupts =
while
> -                        * allocating memory, we should bump c->tid now.
> -                        */
> -                       c->tid =3D next_tid(c->tid);
> +               p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
> +                                    s->object_size);
> +               if (unlikely(!p[i]))
> +                       goto error;
>
> -                       local_unlock_irqrestore(&s->cpu_slab->lock, irqfl=
ags);
> -
> -                       /*
> -                        * Invoking slow path likely have side-effect
> -                        * of re-populating per CPU c->freelist
> -                        */
> -                       p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE,
> -                                           _RET_IP_, c, s->object_size);
> -                       if (unlikely(!p[i]))
> -                               goto error;
> -
> -                       c =3D this_cpu_ptr(s->cpu_slab);
> -                       maybe_wipe_obj_freeptr(s, p[i]);
> -
> -                       local_lock_irqsave(&s->cpu_slab->lock, irqflags);
> -
> -                       continue; /* goto for-loop */
> -               }
> -               c->freelist =3D get_freepointer(s, object);
> -               p[i] =3D object;
>                 maybe_wipe_obj_freeptr(s, p[i]);
> -               stat(s, ALLOC_FASTPATH);
>         }
> -       c->tid =3D next_tid(c->tid);
> -       local_unlock_irqrestore(&s->cpu_slab->lock, irqflags);
> -       slub_put_cpu_ptr(s->cpu_slab);
>
>         return i;
>
>  error:
> -       slub_put_cpu_ptr(s->cpu_slab);
>         __kmem_cache_free_bulk(s, i, p);
>         return 0;
>
>
> --
> 2.52.0
>

