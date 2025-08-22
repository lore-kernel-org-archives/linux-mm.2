Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3918BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDADE280023; Fri, 22 Aug 2025 12:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB21D8E009D; Fri, 22 Aug 2025 12:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA13C280023; Fri, 22 Aug 2025 12:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5DB98E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:28:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 853AFB785C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:28:36 +0000 (UTC)
X-FDA: 83804926632.08.59A34BC
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7A5BC000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:28:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8ZbCkDM;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755880114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wf+lgLCtUqo6j13pKWPsvYiNR6tNGJ0wVHF5rG3wEgE=;
	b=wh6eesvIorynnGTEkdloa8WmdGU9tug/pqXD/5p0yRiX/Aq4gIdCMCHpqz2s/OoXZ5OJgv
	oGuh4c/JufCHRvj7dVDruXPXWTYmcU8WGH0NEPhwSKUBTddcEhu/nXdz2yG05xy38dFPU9
	Jy/QA5CrG2a5vCYopicLjWXadGdd2+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755880114; a=rsa-sha256;
	cv=none;
	b=b1+qXc0kkU0VmJp0oRYebpDK7muEJLcmpPFaZPOQB9mjzuMkt2Hh8cYtba22hKDrlRVwzW
	Aal/NDvWtkHdr4iH1mSwbascALskl7h+DwA4ChSkcNqTzYoJlSZYi8j9VocumBSuNh7Syn
	uHInHrfJeP8yS9qjsSLoAdRriqIWpzc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8ZbCkDM;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b29b714f8cso329421cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755880114; x=1756484914; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wf+lgLCtUqo6j13pKWPsvYiNR6tNGJ0wVHF5rG3wEgE=;
        b=R8ZbCkDMb4h7Vw3auFzsg2bqFBqNsdlqtl//qNnOw51RAUwdnwhemS8eWJWH4qYDvs
         AmQ467hAtDa1DNnd9Y8a75VsZ1gT7P9gfX7v9q/s4z39nayijMppO/P2kIjn/DSwSuA6
         Iuk6I06iyzsrHRg60JPl0iIkn9LiQRbTDOXazYQzi5C92C/s1zhhMOzOcJuw/oFdcPNk
         76dcYn5DZ/CCfsPaoaYme3e7FjmxBwsJ72kcFM8whbZiHKTsRKKzKOhW7LnZwfl4M/7h
         rFweFpRizesmMlCUoc8RmcvSvI4n3+Uzf5pPP+ilXMUljBkql/XiOGSzm3gWY5nDiZAm
         sT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755880114; x=1756484914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wf+lgLCtUqo6j13pKWPsvYiNR6tNGJ0wVHF5rG3wEgE=;
        b=n3wmJ95Dgkp6eyCFJuJktOhccHXR3yxUfI7ovhBvXFv5PzZpnLIRmQ+FT5oe4eT9If
         yjlKVJh2ajSlDtHvbLQrdPP7Ij/dX+qZIYhKKNau20rk5LwdOnFlsUhQn1mfPfqgHwBR
         ut03Ebapv1XHUxiK9EjpFXCQdskVtZ9DViOxc5livxNcPTPhiC9QNsV0FAxWG41SWaVO
         /Z6JJsiteKJhtl25LZv3wvJqio/Zw7RSHoCAqgUJI+GNNRDboEhpRphgFqqvT+oRPJq1
         03kx/jtnuW4mLLGcmqGQLo6icUvRUu+MWFEC6TpM9yHtP15pxgb0rMbIvK2WpHfALhvO
         qU7g==
X-Forwarded-Encrypted: i=1; AJvYcCVA0BGPLP7yjr6i9fXzkgNpeS2GbdCsG8Cof95X8kDsi8vcdr/6S6yzz3wOhP1Tg/leicSHl5q5Lg==@kvack.org
X-Gm-Message-State: AOJu0Yzj6wgcbpJvfMSzHi67w8YtXx3dGh/VzBEy27zKkW+EOSrpjVhJ
	/mRfk6d9gK+zHKSmsGQZ7N7jHoM0sk9xFTIyy9zEeaMkwZD3UAA0MeugSPIBUSBarwUOOKmFVKG
	ULzgUx2pIY2zI3z/BhOz+TvANMGoNxsu5ST4Y/u56
X-Gm-Gg: ASbGnctrTBi8Fe0O7Zlt3MJpwBOLHk9iiMU2EM739sgWkrTyLsX9iCF4oezjSDFMeUm
	60FqLCE/wS0FTw8TUYXA+ghK7KvYc9a7pkQsouiMsabj9QWXl9d4GBQ+jjzXm0FUFXmWY9j8OSz
	hjtP8HHg325/j904mrg+XAx3AMIW1HTJBLNPXMxOeXStsDh6rNmDla2lfhJih0Bk84D5NSrt1vK
	lAlcQzvQw7A
X-Google-Smtp-Source: AGHT+IEeB9T4qbL+UK0u9FG3kDDzOikNRJHFqBW5WtIsltP7tBFpOKmY+dFwDmwerpPmhmqCXCSRQaTv+MbAq/hPPUs=
X-Received: by 2002:a05:622a:180b:b0:4a7:179e:5fec with SMTP id
 d75a77b69052e-4b2ac5b8096mr6202121cf.15.1755880113114; Fri, 22 Aug 2025
 09:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-5-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-5-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 09:28:21 -0700
X-Gm-Features: Ac12FXwI69etioIK7mYTuyWUpdhOHZOX0stE9nJoaN7MNJhvTMXHGKoJ0u9Mnow
Message-ID: <CAJuCfpHR=hceuAcnaCr3Hg-3mknvsmYy7jSScA8SATn7iwoN_w@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] tools: Add testing support for changes to rcu
 and slab for sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7A5BC000D
X-Stat-Signature: izxktunc41pj5k877fi17q9m3s49rw68
X-HE-Tag: 1755880114-278779
X-HE-Meta: U2FsdGVkX1+gybnlbiw8otmYOPQNdUV/rgiDeLXD9oNIalS7lQ2fAZ/e4zkfMjKvsHlUZmZthAnogQvomG38oFFfKJqtLo8gHVgfFitSARrlH4fDUjA6Jxj5CT5YT7Y3kXcms/IFfAd//aTYHS0tz/1gJcgPRly+oJqBV3VSbD3IjyzSCKvhwx2qQU5KBHhZ1dNSe8o01TcyULQEavhH0C0NuURPSMOCHalS8xbHlyOzfMH1n6knvCLkvsh5hTMK5ifafmA/nUuIIoerlSptE+zJY5x6R/CoLHFZGSWtMqBTFouSN9mH3vyjTbykEiZp3JzyZAHIQQVH8lOcMFX3MmNGUbFwIBJGXwXD43CCTGRGTXTjXs1b6P8beuxf00+7C5kuaLY7FXRBM3lFxJKHfStx0ultKFUyTrqHXJdzZpKuy6tul6cl/YepQThIV7eAjlYo8Q2xY0FaT4dTKarHHDY+6i5TQJomCTgVpIk/ARnTOG7Oy5mcok62GKx3W/jeXsSonvficwjs0XuV+IQ6tEYXVEJrlLuQJiDUK86OjvGDtdLtpkEUjXNV6gj+enuIrRUOnH2yIRgi/ladT4Dsy84o8aiWGk0FkHbj7VrWJeJLbwX3iT3dpcWr10YswXGTctD0LAtCkFnYBqI5VvOMaCGoI/cLb57gjbqUdIx9NALhMsiK5qj4K4w8GjypWByVBCEHn+4s88mK41nqCv62sNmM7kzwEZLbN5Fdt0su12oGGbGUs2JcUkiv7fzCl5cSRCqJskvCLf7H11CkxBfR8F+TOpCD3CchCAR3BmyiOBbs11o4fR5UXnf+h/iEGHwpdO+E5vERlgr1N41WwFfgmBEtlZSeLdlqxDyL8pdQfQ+sEICkjvPmYoWVk0SW/IvyscjwEmx7DE0HDtt/PD3C+JxuXvtGAkt4xSxsqe0Sy9DEMXw15ZT3g7IRpThsokgICzjQk87Y5vtMAta03sE
 WT7OKSlS
 bVq9sQicU3SJF9WyLIA7sf4FVF1uV/Ujo7uDvLSbXHN2KY9l1YOuhJySaQFes2i6Is4htr/I+UyU3SjISxJSfP3f7IrbS6KxgdAKZ632n3iDqw9b4kL8HtcDG8VPSCP9cloEVJ1W71ISaj1t6pJ4KKTAYdItgdCm/nqQh7sLWXP1gel9aqoq0SJeBvW1ZIzcAseumGNOQNjGm9yNf8ufU/841StFYLp+t7jY+1xkimwvsZ92Nz4Oje/D5YK8xeKkHlfYC7/j3FbLWXCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
>
> Make testing work for the slab and rcu changes that have come in with
> the sheaves work.
>
> This only works with one kmem_cache, and only the first one used.
> Subsequent setting of kmem_cache will not update the active kmem_cache
> and will be silently dropped because there are other tests which happen
> after the kmem_cache of interest is set.
>
> The saved active kmem_cache is used in the rcu callback, which passes
> the object to be freed.
>
> The rcu call takes the rcu_head, which is passed in as the field in the
> struct (in this case rcu in the maple tree node), which is calculated by
> pointer math.  The offset of which is saved (in a global variable) for
> restoring the node pointer on the callback after the rcu grace period
> expires.
>
> Don't use any of this outside of testing, please.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Couple nits but otherwise LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  tools/include/linux/slab.h            | 41 +++++++++++++++++++++++++++++=
+++---
>  tools/testing/shared/linux.c          | 24 ++++++++++++++++----
>  tools/testing/shared/linux/rcupdate.h | 22 +++++++++++++++++++
>  3 files changed, 80 insertions(+), 7 deletions(-)
>
> diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
> index c87051e2b26f5a7fee0362697fae067076b8e84d..d1444e79f2685edb828adbce8=
b3fbb500c0f8844 100644
> --- a/tools/include/linux/slab.h
> +++ b/tools/include/linux/slab.h
> @@ -23,6 +23,12 @@ enum slab_state {
>         FULL
>  };
>
> +struct kmem_cache_args {
> +       unsigned int align;
> +       unsigned int sheaf_capacity;
> +       void (*ctor)(void *);
> +};
> +
>  static inline void *kzalloc(size_t size, gfp_t gfp)
>  {
>         return kmalloc(size, gfp | __GFP_ZERO);
> @@ -37,9 +43,38 @@ static inline void *kmem_cache_alloc(struct kmem_cache=
 *cachep, int flags)
>  }
>  void kmem_cache_free(struct kmem_cache *cachep, void *objp);
>
> -struct kmem_cache *kmem_cache_create(const char *name, unsigned int size=
,
> -                       unsigned int align, unsigned int flags,
> -                       void (*ctor)(void *));
> +
> +struct kmem_cache *
> +__kmem_cache_create_args(const char *name, unsigned int size,
> +               struct kmem_cache_args *args, unsigned int flags);
> +
> +/* If NULL is passed for @args, use this variant with default arguments.=
 */
> +static inline struct kmem_cache *
> +__kmem_cache_default_args(const char *name, unsigned int size,
> +               struct kmem_cache_args *args, unsigned int flags)
> +{
> +       struct kmem_cache_args kmem_default_args =3D {};
> +
> +       return __kmem_cache_create_args(name, size, &kmem_default_args, f=
lags);
> +}
> +
> +static inline struct kmem_cache *
> +__kmem_cache_create(const char *name, unsigned int size, unsigned int al=
ign,
> +               unsigned int flags, void (*ctor)(void *))
> +{
> +       struct kmem_cache_args kmem_args =3D {
> +               .align  =3D align,
> +               .ctor   =3D ctor,
> +       };
> +
> +       return __kmem_cache_create_args(name, size, &kmem_args, flags);
> +}
> +
> +#define kmem_cache_create(__name, __object_size, __args, ...)           =
\
> +       _Generic((__args),                                              \
> +               struct kmem_cache_args *: __kmem_cache_create_args,     \
> +               void *: __kmem_cache_default_args,                      \
> +               default: __kmem_cache_create)(__name, __object_size, __ar=
gs, __VA_ARGS__)
>
>  void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void *=
*list);
>  int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t s=
ize,
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index 0f97fb0d19e19c327aa4843a35b45cc086f4f366..f998555a1b2af4a899a468a65=
2b04622df459ed3 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -20,6 +20,7 @@ struct kmem_cache {
>         pthread_mutex_t lock;
>         unsigned int size;
>         unsigned int align;
> +       unsigned int sheaf_capacity;
>         int nr_objs;
>         void *objs;
>         void (*ctor)(void *);
> @@ -31,6 +32,8 @@ struct kmem_cache {
>         void *private;
>  };
>
> +static struct kmem_cache *kmem_active =3D NULL;
> +
>  void kmem_cache_set_callback(struct kmem_cache *cachep, void (*callback)=
(void *))
>  {
>         cachep->callback =3D callback;
> @@ -147,6 +150,14 @@ void kmem_cache_free(struct kmem_cache *cachep, void=
 *objp)
>         pthread_mutex_unlock(&cachep->lock);
>  }
>
> +void kmem_cache_free_active(void *objp)
> +{
> +       if (!kmem_active)
> +               printf("WARNING: No active kmem_cache\n");
> +
> +       kmem_cache_free(kmem_active, objp);
> +}
> +
>  void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void *=
*list)
>  {
>         if (kmalloc_verbose)
> @@ -234,23 +245,28 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep=
, gfp_t gfp, size_t size,
>  }
>
>  struct kmem_cache *
> -kmem_cache_create(const char *name, unsigned int size, unsigned int alig=
n,
> -               unsigned int flags, void (*ctor)(void *))
> +__kmem_cache_create_args(const char *name, unsigned int size,
> +                         struct kmem_cache_args *args,
> +                         unsigned int flags)
>  {
>         struct kmem_cache *ret =3D malloc(sizeof(*ret));
>
>         pthread_mutex_init(&ret->lock, NULL);
>         ret->size =3D size;
> -       ret->align =3D align;
> +       ret->align =3D args->align;
> +       ret->sheaf_capacity =3D args->sheaf_capacity;
>         ret->nr_objs =3D 0;
>         ret->nr_allocated =3D 0;
>         ret->nr_tallocated =3D 0;
>         ret->objs =3D NULL;
> -       ret->ctor =3D ctor;
> +       ret->ctor =3D args->ctor;
>         ret->non_kernel =3D 0;
>         ret->exec_callback =3D false;
>         ret->callback =3D NULL;
>         ret->private =3D NULL;
> +       if (!kmem_active)
> +               kmem_active =3D ret;
> +
>         return ret;
>  }
>
> diff --git a/tools/testing/shared/linux/rcupdate.h b/tools/testing/shared=
/linux/rcupdate.h
> index fed468fb0c78db6f33fb1900c7110ab5f3c19c65..c95e2f0bbd93798e544d7d34e=
0823ed68414f924 100644
> --- a/tools/testing/shared/linux/rcupdate.h
> +++ b/tools/testing/shared/linux/rcupdate.h
> @@ -9,4 +9,26 @@
>  #define rcu_dereference_check(p, cond) rcu_dereference(p)
>  #define RCU_INIT_POINTER(p, v) do { (p) =3D (v); } while (0)
>
> +void kmem_cache_free_active(void *objp);
> +static unsigned long kfree_cb_offset =3D 0;
> +
> +static inline void kfree_rcu_cb(struct rcu_head *head)
> +{
> +       void *objp =3D (void *) ((unsigned long)head - kfree_cb_offset);
> +
> +       kmem_cache_free_active(objp);
> +}
> +
> +#ifndef offsetof
> +#define offsetof(TYPE, MEMBER) __builtin_offsetof(TYPE, MEMBER)
> +#endif
> +

We need a comment here that concurrent kfree_rcu() calls are not
supported because they would override each other's kfree_cb_offset.
Kinda obvious but I think unusual limitations should be explicitly
called out.

> +#define kfree_rcu(ptr, rhv)                                            \
> +do {                                                                   \
> +       if (!kfree_cb_offset)                                           \
> +               kfree_cb_offset =3D offsetof(typeof(*(ptr)), rhv);       =
 \
> +                                                                       \
> +       call_rcu(&ptr->rhv, kfree_rcu_cb);                              \
> +} while (0)

Any specific reason kfree_rcu() is a macro and not a static inline function=
?

> +
>  #endif
>
> --
> 2.50.1
>

