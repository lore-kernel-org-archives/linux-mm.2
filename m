Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28370CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F37A8E0007; Fri, 26 Sep 2025 20:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3F38E0001; Fri, 26 Sep 2025 20:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393358E0007; Fri, 26 Sep 2025 20:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2717A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:28:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE3365A100
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:28:47 +0000 (UTC)
X-FDA: 83933144694.03.1E8CAE3
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id C97B514000D
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:28:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Uq2fgt+n;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758932925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lL1xNsKEteMXMKmX3O4zRiD5wAUnbo9gdCrODnH6YU=;
	b=kVZSTwg0GO+MI6bs31xx0Xd7hfdNm5+dRjcs20q39HMzvBreebPAm41nF2iAYkvfKnkWar
	U1HSdFapHkcHYWUBeADh6Phb1hh/Mb7slVOPGGugw6igC7nCROAciuC+Bo47dGqnNSSByv
	RJLpBgInqvqiG1iPU3Qzi0yT8IBzDN4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Uq2fgt+n;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758932925; a=rsa-sha256;
	cv=none;
	b=KF/huYGm0TxCd3Ldt5H1DQ6gL79H0z6U/hZj8ytyNn72oOc/fIt3rGOwDZ7LO3h2cQTqi7
	MtbLHHpvm1tmnffrei/0o9+Pqa5SFozejeNNM1Oe2jhtXwY5xD0YrAU21L8l4VD4JHZhNb
	TqcW2vrNSgyEuhDLvLLtgbN8MRaFwas=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4de66881569so149901cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758932925; x=1759537725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lL1xNsKEteMXMKmX3O4zRiD5wAUnbo9gdCrODnH6YU=;
        b=Uq2fgt+nctSbwMKJuEu64GRyi0pL+TN8v1kcbEm89qs/8JBmxNlFiMtIe+7XG9n0ly
         1+560rQMHGaiiP1FKkiqMk8cuWq4ZBp2zvnnLbznlNPuRwBrDgotwZizfwLVmOAoySRW
         2zGcMLMszuoEITFQPPx7z3QPuxr+lA/80hJ+mJjxFwFbHc0MYKqOKKM/zYbexAGolsTK
         02pbuTqiJ/SH/bUTJotSOE4cFBIWnhhsNA2hxK7eac3WDwd/ldhUgYniQKljdM6KoONy
         DuiC1UP/e98g9dQPTudYEFFRzfKo31jnoZ/oxJv5JIWvR9F6+r2yEJHMTyEjiSSTLZ8+
         7Dew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758932925; x=1759537725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0lL1xNsKEteMXMKmX3O4zRiD5wAUnbo9gdCrODnH6YU=;
        b=X7H+DX7XNaMD9ttsqzZEh1g6UFkFeiCeXVBImBZ4qTnReasi4C3SKbKLfZp8QIadha
         5MqLP8d89i6zRh9bZ+l9w+WFQx3dervUCzxOKir6gRjktqDGn6dtCiyl7ZYMeKlAiRp0
         VrDNwwTgkuUZKeo/0r6anNVyZUC/9yd6uZtCqTexGGBkDsjl/0ZCDmKDyahaltIVpTBA
         MID87kLGclTBS77FIUaKt5926Ts+l9lMVh+PL91vS8B8rzBLaPBx8zaQ8+Escr7OCbpP
         0p50X1btcL209ZUgRiv8XTtX7VTRoOUzNQxnGly0LrXeaPHZvO3dFY6iwhR6M1ZcFd8h
         T9+w==
X-Forwarded-Encrypted: i=1; AJvYcCVwAVhoPvK3rNvqm/ObBckBACuvMNLdbt3o7/BcrQVyUmpoxSbnZ0uw9vr2oajo/mFeObHDk8iacA==@kvack.org
X-Gm-Message-State: AOJu0YysDDKYQJKlrIKY/TpRAtXAw0spbxiGzK6/el8ARXKudGlGUSP3
	5bS5HJfIaQJPRjjCPYvpDsBvh0vxFx78Y8fsq6RBAaU1pHDe/BSWVk3wsZEDg+ISLZqMb0qBlYE
	IdEgW6983viLYd4g66q3WyQS5XBXLJU7wYPjL+8Cg
X-Gm-Gg: ASbGncvaCOzykP6TOPg8Fzp4AJvfXtMg0bcbac+QVsTlHVmzMbyaDdJS3sxuqHuFOWg
	VNCG0LSbiSTJB9cCoc/t5/np/UxEyCe5XJ8fFTuv+Gp5KAW2MCu8pqZarPP5zBrpWsuk+c0nrPr
	YhVTwc1+X6Ey/WyQ5U1FJL7n6EqwyGwY0E8g40YlYEkgMwFqabTCCbSpqrIkA8+Gr0vDKZ8SNs0
	d/gOQVEruwj
X-Google-Smtp-Source: AGHT+IH5IFJR77Y9edST6Xxl+0Cot4RzHoKBIGdLSAKbGPf4fsdiUsyYbAo8BpYxzO/JKdii+i+G1WOVfpK48XW3h2k=
X-Received: by 2002:a05:622a:2cd:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4dec6b1f86cmr2934011cf.5.1758932924368; Fri, 26 Sep 2025
 17:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-20-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-20-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 17:28:33 -0700
X-Gm-Features: AS18NWANsOMOuXdXD-T691vO4VKx0kp2e8h8yCDMUhco_cBrMY2tOuwxOaQ01iY
Message-ID: <CAJuCfpEQzHM8hwTLXj8evuWHcUWvsM+HecwkLgP3i-A30rAtHQ@mail.gmail.com>
Subject: Re: [PATCH v8 20/23] tools/testing: Add support for prefilled slab sheafs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C97B514000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8fswoaobfr4gmtgztobpi7bsw8tzk19j
X-HE-Tag: 1758932925-472231
X-HE-Meta: U2FsdGVkX19IL0QFEXvo3sZtrYGOR2z3kQKDZOyjZeEzd3fdzfBDCq7pv02E6+ZlrZOyydIG8K+rwEvIVM1wgTqM8LDjFBbctJn4S7SO4jNg0YVwclIdZt0Yvjxq9YpbrNe2S1qXRQeE0mJog3CJZQG+mVSMUwrcPEnB0GZ5F2FRqpKLfCFehpVPM7m0QAh8OWeyKaNnOayBegMJBatxbKu6E5bwwhwa4OQ1/qC+JWyumFnJXboOYCdWvya5fXidQ1A1B6bYmn7/385rChHsDHFjSkSts9eXXF+pn840BgYrc1wYou2JBvEIEOURYPtt9F9XQ97YIJPS4ox9ANGBWMJXaDrNcPdkINPlGG4Jb4uYPUyursUn4Ow/bkofrtWAh3nannZdRmWparXPRz0SrvgZTKWIxiov3vIsP6xvjY7MkXwZy2ycjTbvKHXc/zQAZk9oa1FrxTEUtFjmj2VGREUauoa2J1Qn/QP+N29HsEWSlzYiQeve5u8DeDDxD4xS2YS76/9W2xxzmsoKCkgkfRVhv9hA4vY5E5XukzuwjDdj6I7iJqS/FXt9xqWZePPFtoXUEvDmFXSefsnKIH2R8btbplE6eWDS6hgnCxP72xEjNkMN7LAEnPrrfQSPwrHcv52Af8kAahrLoRasaaZ/LG7fJVAJmjEQqEKTW+qKdxgA/SCcd8ms9sEt//pVXUaUZ9SHYpyCHKINA8Hpg2k6sTxUlp6Cci/RxWa/DtqOc/3Dqc2ajBC6FPlTYCQAwKRAEc+qQoigJEq/CyBywsyBx9WJwF1v6oVY6gini1bfc6eEWRQW6GTgrr8feWVhlialRFZ1PnuMvFtsBAtBgL1QRlopdnXNtBrstaSPodNJoZ/eijPDzm0PJ5go2XVKGrA/yWJDRAFfegwOK8Abky77fQqeVhbhG/OK3Rd+xlCQ9ekeHXe2H8oPJL6rxALc672lCUzEOmCpEDcuydKr/8Q
 Nw98Ua3G
 M6SM2Wd3uQ2xdBBu7fHpMT7zvmW99miONCKaS9AN8I7a4XPpzTCyBDVrst50zbeTs6J86JFJXJKFkxzFEpP8QyNleEpoAioF9elJ+QUaXevi6vHqQWBGdkQ8ykGpTnLjq+4X3PamLHgSlZnr9TdKwFv9cZcHidTcxP68yox8bjADrObn0yk3LjJ0L8yHroZmH9IqwIRo3OCcMYYM1HLGXtrhe24U8MYP+j5jVfwpSm9+bFZUd0pPQ+REUIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>
> Add the prefilled sheaf structs to the slab header and the associated
> functions to the testing/shared/linux.c file.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  tools/include/linux/slab.h   | 28 ++++++++++++++
>  tools/testing/shared/linux.c | 89 ++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 117 insertions(+)
>
> diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
> index c5c5cc6db5668be2cc94c29065ccfa7ca7b4bb08..94937a699402bd1f31887dfb5=
2b6fd0a3c986f43 100644
> --- a/tools/include/linux/slab.h
> +++ b/tools/include/linux/slab.h
> @@ -123,6 +123,18 @@ struct kmem_cache_args {
>         void (*ctor)(void *);
>  };
>
> +struct slab_sheaf {
> +       union {
> +               struct list_head barn_list;
> +               /* only used for prefilled sheafs */
> +               unsigned int capacity;
> +       };
> +       struct kmem_cache *cache;
> +       unsigned int size;
> +       int node; /* only used for rcu_sheaf */
> +       void *objects[];
> +};
> +
>  static inline void *kzalloc(size_t size, gfp_t gfp)
>  {
>         return kmalloc(size, gfp | __GFP_ZERO);
> @@ -173,5 +185,21 @@ __kmem_cache_create(const char *name, unsigned int s=
ize, unsigned int align,
>  void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void *=
*list);
>  int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t s=
ize,
>                           void **list);
> +struct slab_sheaf *
> +kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int s=
ize);
> +
> +void *
> +kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf);
> +
> +void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf);
> +int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf **sheafp, unsigned int size);
> +
> +static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *shea=
f)
> +{
> +       return sheaf->size;
> +}
>
>  #endif         /* _TOOLS_SLAB_H */
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index 97b8412ccbb6d222604c7b397c53c65618d8d51b..4ceff7969b78cf8e33cd1e021=
c68bc9f8a02a7a1 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -137,6 +137,12 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep,=
 size_t size, void **list)
>         if (kmalloc_verbose)
>                 pr_debug("Bulk free %p[0-%zu]\n", list, size - 1);
>
> +       if (cachep->exec_callback) {
> +               if (cachep->callback)
> +                       cachep->callback(cachep->private);
> +               cachep->exec_callback =3D false;
> +       }
> +
>         pthread_mutex_lock(&cachep->lock);
>         for (int i =3D 0; i < size; i++)
>                 kmem_cache_free_locked(cachep, list[i]);
> @@ -242,6 +248,89 @@ __kmem_cache_create_args(const char *name, unsigned =
int size,
>         return ret;
>  }
>
> +struct slab_sheaf *
> +kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int s=
ize)
> +{
> +       struct slab_sheaf *sheaf;
> +       unsigned int capacity;
> +
> +       if (s->exec_callback) {
> +               if (s->callback)
> +                       s->callback(s->private);
> +               s->exec_callback =3D false;
> +       }
> +
> +       capacity =3D max(size, s->sheaf_capacity);
> +
> +       sheaf =3D calloc(1, sizeof(*sheaf) + sizeof(void *) * capacity);
> +       if (!sheaf)
> +               return NULL;
> +
> +       sheaf->cache =3D s;
> +       sheaf->capacity =3D capacity;
> +       sheaf->size =3D kmem_cache_alloc_bulk(s, gfp, size, sheaf->object=
s);
> +       if (!sheaf->size) {
> +               free(sheaf);
> +               return NULL;
> +       }
> +
> +       return sheaf;
> +}
> +
> +int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> +                struct slab_sheaf **sheafp, unsigned int size)
> +{
> +       struct slab_sheaf *sheaf =3D *sheafp;
> +       int refill;
> +
> +       if (sheaf->size >=3D size)
> +               return 0;
> +
> +       if (size > sheaf->capacity) {
> +               sheaf =3D kmem_cache_prefill_sheaf(s, gfp, size);
> +               if (!sheaf)
> +                       return -ENOMEM;
> +
> +               kmem_cache_return_sheaf(s, gfp, *sheafp);
> +               *sheafp =3D sheaf;
> +               return 0;
> +       }
> +
> +       refill =3D kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
> +                                      &sheaf->objects[sheaf->size]);
> +       if (!refill)
> +               return -ENOMEM;
> +
> +       sheaf->size +=3D refill;
> +       return 0;
> +}
> +
> +void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> +                struct slab_sheaf *sheaf)
> +{
> +       if (sheaf->size)
> +               kmem_cache_free_bulk(s, sheaf->size, &sheaf->objects[0]);
> +
> +       free(sheaf);
> +}
> +
> +void *
> +kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf)
> +{
> +       void *obj;
> +
> +       if (sheaf->size =3D=3D 0) {
> +               printf("Nothing left in sheaf!\n");
> +               return NULL;
> +       }
> +
> +       obj =3D sheaf->objects[--sheaf->size];
> +       sheaf->objects[sheaf->size] =3D NULL;
> +
> +       return obj;
> +}
> +
>  /*
>   * Test the test infrastructure for kem_cache_alloc/free and bulk counte=
rparts.
>   */
>
> --
> 2.51.0
>

