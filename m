Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A5CCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599B08E000B; Thu, 25 Sep 2025 12:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571348E0001; Thu, 25 Sep 2025 12:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE098E000B; Thu, 25 Sep 2025 12:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 377B08E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:15:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90966160405
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:15:05 +0000 (UTC)
X-FDA: 83928271770.27.7CFB211
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id AACA0C000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:15:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W5cx/4w8";
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758816903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wvr92HsSMV0G5ym3tjKs8WEbL98VD0E3AvAM53My1hg=;
	b=N+zP2rr6cL2ac3LT7P1jVE0vOqqijlqZl8gDuShU7sR8CSBwgPY52bj0vXcQ+0IqDq2Keo
	Pzam2esQf+yCt4mWpON7syKiPPMw8eNaFOsHvICQXG35Vxb50u7wbBDYJSij5qY27Fkl0I
	2x8rOfQAgjpiPS9w+5/PcqYv+aM/wVU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W5cx/4w8";
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758816903; a=rsa-sha256;
	cv=none;
	b=Tf3J9Q4opDKU332SGUfEO8xHUkYJbEWJCvgzH42N27RQtYiNzZypqzt8MLdwDqwPiyMdol
	jmW5XqT92P0If3LdBtNUY/0odqzQCXp+JygXr4RAgxLTelYsxoNyX/20clOKXtaPleMJb8
	Enhc9hO4GRrgyWaxcQ6Gy1v8QM0AXGY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b78657a35aso1295051cf.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758816903; x=1759421703; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wvr92HsSMV0G5ym3tjKs8WEbL98VD0E3AvAM53My1hg=;
        b=W5cx/4w8n10p9dpkbK8L/Pk/3bVhgbQULe04cI+T8sgLp19kgLDP88vqQjL+9eiKq7
         AqZq4BqsjdbJ0vsYMktvHRkxSd6iWi65shcrgAqVHZDA23W183HutPUfEjBmdFk/7sqx
         +3N3Mvp6LfYLaznKBQuTNGF466VlITajIRfC4TGujTFU59uZ5NAad04LvIEcJ3vKfoGL
         9ucSaj/qzJXCmigMQxrzEuwpVqm67tyCDOUsyItNg09RoWgZwwtr5u9MzvG4b77TI0uC
         /pUs6czQZYtEyZdTUYSZIHW7HL+otMr5QV6SWpXM5MZZS7wDHWybnihieSo+K5NIb3hh
         ISEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758816903; x=1759421703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wvr92HsSMV0G5ym3tjKs8WEbL98VD0E3AvAM53My1hg=;
        b=b5fZZpiuAmsQuCnPWvpZcPdt4TIAvlysiQRFZFI46o1EWhIE9egk9JVmdZcFEYejmH
         4j2XjVTE1dL6cshQsRB1srjm7UZJ0gZkSXeKBkdwyJ5XW1Hc9982fZ3g/wZ/A4rJzqmM
         FUJnKuvLLveLUcOG8I8355TyhFXrqsro7per6CpQ1Mhnky2Dv/3rtdziHcWoScItA6WK
         /7Frv+U4QiOAsjL7drYc0vpaXjkIxh+FyHKVXjATHZ43MHdtNg6rrXYCV3bzXtz/3dQ6
         9caDS4pX//6uCNOo4iMKbiACFHjChXNBFNaIMFcd/RFqaxHTnQeo+mrdlWTvlzfNTjhw
         tTvw==
X-Forwarded-Encrypted: i=1; AJvYcCWjkgsXfm5eqRmThX7hJ2E2z8DGJgE5tdFIhRign2YHf2NkIFTdcNMDcmUj2Mk+kR9eK1h8kM15Gw==@kvack.org
X-Gm-Message-State: AOJu0YxGLnm9Hk1PIMJjDdcVHyIpWWVZDt0zjL/m+UkcaFqbmnHFg9pc
	nLZmd6dwrE65l0BkuGsQfu8AXb2GsYjKf0TNgiCBl035yFEtNY/T7f9ROU2d5Z+tSASQ2qgNkTv
	Dbx5kKct+HJo0vjyIzCOgePbQTFMa6zvioMDdSEkA
X-Gm-Gg: ASbGncsCgccUoeyDd2jP0wYKn66KmiiyV4aMdvY9V2D0/walmKZSZ5uqj7oAfpU39J0
	Axthq3DopiuTxaUsKYsu7vBaBlqly1WVgYkpzwp+WGXjNieruyhIGqOClioJZhayPlPuTIgUy5y
	cZPmLl+u+Z8IG0DDODbpRtvi9MwhA9pugFy/0cGG9v7idE/RU797aUP0kJGBQN0I0k+FU6GlE4w
	CBjoRFinEAbJjjKIVufn7xzFmDMO4dRaCHUucCGgWeb6vMeGZj31Kk=
X-Google-Smtp-Source: AGHT+IEZX3AIsjneqU2jkzMxfJ1rwKeMkyXol2y5mWE/WbUduMbZkhlHGcC/mN/j9JEB5vlP4XKLW47PV44WdfJ9t1E=
X-Received: by 2002:a05:622a:38c:b0:4b7:9b7a:1cfc with SMTP id
 d75a77b69052e-4da2d8fb31emr8186661cf.10.1758816901473; Thu, 25 Sep 2025
 09:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-7-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-7-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 25 Sep 2025 09:14:50 -0700
X-Gm-Features: AS18NWAvEId5a1XW0xii0HqSmARldJg6moJt7e5uwfO2hVBiihb1I0PmhdfuWc8
Message-ID: <CAJuCfpHmDxgFj+Jh9+qK1nwnnGWGBvPYEFrLSdooCUy5ODRboA@mail.gmail.com>
Subject: Re: [PATCH v8 07/23] slab: skip percpu sheaves for remote object freeing
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: td7xq5zs158dx48zauay88m7ssc77eud
X-Rspam-User: 
X-Rspamd-Queue-Id: AACA0C000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758816903-239552
X-HE-Meta: U2FsdGVkX1/3cLHS7X2hfZbtrgTl+Ng5cfpR+N3136ZlE8l6PsyBBakZ2JpD/hINjs52gddWbBAf11q3IlvhaINxVqFSpzu0yy92+8LnALnj3A1ikZjPdE2ud/TEY9LBh1Gx9EKmYdk7wqPXp1GKOagQZw2I/wAmntUXlABIL3SayuzJgG6eTsu4Y8jx9NM2Posi6LHdyucL/iAPbMIFfI/O5PKjULGE8gr8WopaZH6XowQRHeOg0SP9vN7aSwfsuiuLXn+ZXTMA3ClMPz9OHIwsuwh4p8VGFs6tkfpE1uckya3cicCIp4uf2BVJJ1Ti2i1nK3pSDzuLKuul/sLmv50ANn5KqXfOsiEAyu+YVqQ9W7GTb2Aqj29bX+ZLSaOKiszlsmKsjqUZGoeHOdcfFZ4NRrRwvNrkprraf3KV4jNSVPzpWRbhZ1u4b9nlHXJoUnGmE5FQf6u1BsLgxTuFSWFb6GTzk4emz1GWhUgGeanVNbMirbtaKLNCvdD8nzKhP50/ZQozWsng0SvcuF/5T3gqFZOqHx3GVEmQev9lS/omBZ00VcYvX6wC75UjHqC3u0wQwTWzkxS/ruoanwghllmav8WcM5Y+4h9MW0OUPgUN/b8pz827mMNkeG1MQGLYjS4c97HpcWkdZIDgOwaloriCS5N9/AOB0Kp46Yzzu7SbtGx5OrWltXdSDHZE8QlNedfkwa2JykeqMJWqMpOe4n4mv9oUG6y8f6bcmBewoGWTXYZxgwVhNC3AktTHIuGtxZqQP5R8v8GspCDd1P0gApzCQndmr4w8pA1YEWtDE1f8pZ0xFwqlcXDw3jmxi7j+SJwkjvIOPmeXHGMu54WyyiTPd74H4wtgeFUdDpblVnBFCM8A2nB6czBcuMblXqvWpMsyAhfCj2uEb7QRqBGSnAxPfKrm2gmC2RJWvtKi/KCWwaPQesgxsXVbW4eR4LfzQ5YlZVMM0JpSbmiF1UV
 lNp+bH2d
 hDDs7o+y902L+8HzoMrfGABn1GECcg7zpoYwu7cqo80aix8y5huQ7z6Fa20PcJj0YPeniFRInkHOZm1aVZEvXoJegkQcwTGQ//UlR8jROlHdBiTCRu01NbUzV88IhR1No8HGY1W2PXgKmTzoscOnFeGP82x/dCKT1qP21zqeGRIHkNbRqglhBkXKwFwxxv9H30p6xTGhalArIzIc=
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
> Since we don't control the NUMA locality of objects in percpu sheaves,
> allocations with node restrictions bypass them. Allocations without
> restrictions may however still expect to get local objects with high
> probability, and the introduction of sheaves can decrease it due to
> freed object from a remote node ending up in percpu sheaves.
>
> The fraction of such remote frees seems low (5% on an 8-node machine)
> but it can be expected that some cache or workload specific corner cases
> exist. We can either conclude that this is not a problem due to the low
> fraction, or we can make remote frees bypass percpu sheaves and go
> directly to their slabs. This will make the remote frees more expensive,
> but if if's only a small fraction, most frees will still benefit from

s/if's/it's

> the lower overhead of percpu sheaves.
>
> This patch thus makes remote object freeing bypass percpu sheaves,
> including bulk freeing, and kfree_rcu() via the rcu_free sheaf. However
> it's not intended to be 100% guarantee that percpu sheaves will only
> contain local objects. The refill from slabs does not provide that
> guarantee in the first place, and there might be cpu migrations
> happening when we need to unlock the local_lock. Avoiding all that could
> be possible but complicated so we can leave it for later investigation
> whether it would be worth it. It can be expected that the more selective
> freeing will itself prevent accumulation of remote objects in percpu
> sheaves so any such violations would have only short-term effects.
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab_common.c |  7 +++++--
>  mm/slub.c        | 42 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 8 deletions(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 005a4319c06a01d2b616a75396fcc43766a62ddb..b6601e0fe598e24bd8d456dce=
4fc82c65b342bfd 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1623,8 +1623,11 @@ static bool kfree_rcu_sheaf(void *obj)
>
>         slab =3D folio_slab(folio);
>         s =3D slab->slab_cache;
> -       if (s->cpu_sheaves)
> -               return __kfree_rcu_sheaf(s, obj);
> +       if (s->cpu_sheaves) {
> +               if (likely(!IS_ENABLED(CONFIG_NUMA) ||
> +                          slab_nid(slab) =3D=3D numa_mem_id()))
> +                       return __kfree_rcu_sheaf(s, obj);
> +       }
>
>         return false;
>  }
> diff --git a/mm/slub.c b/mm/slub.c
> index 35274ce4e709c9da7ac8f9006c824f28709e923d..9699d048b2cd08ee75c4cc3d1=
e460868704520b1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -472,6 +472,7 @@ struct slab_sheaf {
>         };
>         struct kmem_cache *cache;
>         unsigned int size;
> +       int node; /* only used for rcu_sheaf */
>         void *objects[];
>  };
>
> @@ -5828,7 +5829,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
>          */
>         __rcu_free_sheaf_prepare(s, sheaf);
>
> -       barn =3D get_node(s, numa_mem_id())->barn;
> +       barn =3D get_node(s, sheaf->node)->barn;
>
>         /* due to slab_free_hook() */
>         if (unlikely(sheaf->size =3D=3D 0))
> @@ -5914,10 +5915,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void=
 *obj)
>
>         rcu_sheaf->objects[rcu_sheaf->size++] =3D obj;
>
> -       if (likely(rcu_sheaf->size < s->sheaf_capacity))
> +       if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>                 rcu_sheaf =3D NULL;
> -       else
> +       } else {
>                 pcs->rcu_free =3D NULL;
> +               rcu_sheaf->node =3D numa_mem_id();
> +       }
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> @@ -5944,7 +5947,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s,=
 size_t size, void **p)
>         bool init =3D slab_want_init_on_free(s);
>         unsigned int batch, i =3D 0;
>         struct node_barn *barn;
> +       void *remote_objects[PCS_BATCH_MAX];
> +       unsigned int remote_nr =3D 0;
> +       int node =3D numa_mem_id();
>
> +next_remote_batch:
>         while (i < size) {
>                 struct slab *slab =3D virt_to_slab(p[i]);
>
> @@ -5954,7 +5961,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s,=
 size_t size, void **p)
>                 if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>                         p[i] =3D p[--size];
>                         if (!size)
> -                               return;
> +                               goto flush_remote;
> +                       continue;
> +               }
> +
> +               if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) !=
=3D node)) {
> +                       remote_objects[remote_nr] =3D p[i];
> +                       p[i] =3D p[--size];
> +                       if (++remote_nr >=3D PCS_BATCH_MAX)
> +                               goto flush_remote;
>                         continue;
>                 }
>
> @@ -6024,6 +6039,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s,=
 size_t size, void **p)
>          */
>  fallback:
>         __kmem_cache_free_bulk(s, size, p);
> +
> +flush_remote:
> +       if (remote_nr) {
> +               __kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +               if (i < size) {
> +                       remote_nr =3D 0;
> +                       goto next_remote_batch;
> +               }
> +       }
>  }
>
>  #ifndef CONFIG_SLUB_TINY
> @@ -6115,8 +6139,14 @@ void slab_free(struct kmem_cache *s, struct slab *=
slab, void *object,
>         if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s)=
, false)))
>                 return;
>
> -       if (!s->cpu_sheaves || !free_to_pcs(s, object))
> -               do_slab_free(s, slab, object, object, 1, addr);
> +       if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
> +                                    slab_nid(slab) =3D=3D numa_mem_id())=
) {
> +               if (likely(free_to_pcs(s, object))) {

nit: no need for curly braces here.

> +                       return;
> +               }
> +       }
> +
> +       do_slab_free(s, slab, object, object, 1, addr);
>  }
>
>  #ifdef CONFIG_MEMCG
>
> --
> 2.51.0
>

