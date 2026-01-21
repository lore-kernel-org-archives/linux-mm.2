Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE318C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195766B00CC; Wed, 21 Jan 2026 13:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155DB6B00CD; Wed, 21 Jan 2026 13:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DF86B00CE; Wed, 21 Jan 2026 13:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62916B00CC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:30:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57D9BC34A4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:30:44 +0000 (UTC)
X-FDA: 84356812008.22.634EE38
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 418D3140002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:30:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ct3pCILQ;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769020242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hk+loGahu/yMxf2HTXU45I8jZGBJg9jz2G1ZhRfU2lM=;
	b=y0XBXDcGNoF/zDF4mBsec9J0+0QGFKxHvMYrHLA8JBfqmD7JfPj+oCAxKmgeTFQy4ho5ra
	50ul79nZOz6gs8/xA3Hd3co9n6dwGWtPJWXoKsuj/g1Ir0GefsQWAvhS+AUpO/GgJYoS/G
	g8HLJHFRXy9VS5Dtzv4eUnUGGUw0SCs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ct3pCILQ;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769020242; a=rsa-sha256;
	cv=pass;
	b=vrHgsu0655kc9wRAshxpCwuN0p3abPkzZvQJiRsOAO/jty3iG4f6hO3LAcKRFDwhXC2+mL
	c9M9ju49PUzSQiVcRpTgtk9dDU0ipySmxc+xA/OLz7SdzCVa0EbAoWkbW4QG28FjY6tEJT
	J21JaG+F1rth3GaHN/SE0xR6hfEbjf0=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50299648ae9so23791cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769020241; cv=none;
        d=google.com; s=arc-20240605;
        b=bhGbhRI1QoWu5OeBf+iY1C1S+49EDSKYkrmD2ReqtscnqXL+N0VACp83Z5s/uEDMuH
         3AhCnUk32MSF/K5xdog803ONS/dLuGdRrRnduu/u/7dxrpPIMkMokDiCLRSEoGIT3TdK
         kUA0FH6WFrQ0dgChXFQZBYDwvQqIdSk1lzRJ6OVKOE0oQToRfKidg/Xty2Do2F2/XqSC
         iuFHHzAZhkYTn8utrQbTkiS+yPj98q0Q8eQVd2mwo7PhVR8Pz2DA3cj8gEzV75d+oW+z
         b0dD7TYJjYXd14lCGG4tPgD+bqyR5OO7XzZpl183GdHKrgYex6VG0UdacxAuObz+JQYj
         q4Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hk+loGahu/yMxf2HTXU45I8jZGBJg9jz2G1ZhRfU2lM=;
        fh=VJQhSB1bPwtuYJPDBUZrJqoMwC+D7/ZmeIRskV/xPzA=;
        b=chbelz4v5KbUaJqoJ7F6tpz5LBpezYfZLTxE+zMAlhZFBDoEygEyFGU/gWvx9P7Uxg
         pvAX3Ti8Is1oI2gxNjEwVa3yy5phFLB+BITfX1SGwFUGHLR65+r/DB2UHwhNIGZZPjVm
         PHk00UBQuon1qDn0xk3C28l6xLrpfH8y3lobQ1z/dsXD9D/i9IyCVO2XZBYiwbxady/U
         /u7hgVW2LrbAR2JDPAMKQxiCkGGDBqqH1ibf3GV2FOUXswlEiD7IE0X6fZWZVZFS/saJ
         r5npoH7BpdBlz3kO1K8XbRC4KDF2AG9h0falq5bjY7mn6vXi4ZrIeVUo+09Ax2PfEdni
         EsWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769020241; x=1769625041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hk+loGahu/yMxf2HTXU45I8jZGBJg9jz2G1ZhRfU2lM=;
        b=ct3pCILQiCJ3kbf06gwiByWU7K+RWM8bU4EzJqZf7xi8wlhPjxwX0d+J17k/fGYsLJ
         08OJx3vJhNHx7MfYGH2ybaLLSwLI9xrzNLOj8JY+1YzHKtdq5P50dOSn892rWe41to/U
         Fpmzqb4Np5LQi+YC/eRJZQCWL+KAQWqRpU7J1r2jzLgAvdjQGKw9h7H9OOjOaEk5qVY4
         jdliEKCUMOd/TeAGd0oGnsqArjeDjasq+ijbQpoy/ZvPnE86UE2t0hnHsD/87MQM8wgc
         CwamopysB1D35YJTt55ntYTR1c2qfaqHEVqpgTU7ZbmSzi5/10o5Sa/uSDtRCxTAEZi1
         daTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769020241; x=1769625041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hk+loGahu/yMxf2HTXU45I8jZGBJg9jz2G1ZhRfU2lM=;
        b=qOmBqqWGM7ALz8ygpfjVZrJxkkqCguMjHYlz5w3tm34OHM4uO9Oqg7gQdus7Mq0r1k
         F5G60fVFSZdKWFPWOK5cgLu+xhGKOSmnkT6XqjEmiBJFxGF9Ka0Atkm6qXv3MoAPEE4W
         fKv9Vqwa1hS/JW99A+jDPp+i9Sgwf3z7DWo1LZtlIWdfdbBXq8MK3F8ldOo+v7Xc6A1M
         Pw+36SE65F/RiwJOZRei7gVPJ1rI+Zq5RTXe2wXR8X3Vo/Ss5axIGQeAb+QQ8hNlaPej
         mOfI/5vR/SNjLHbs3S4wMpg+2pCDZyv2M9462GIx58aFTIEllsBVukoqm2SaHB293LIp
         z44g==
X-Forwarded-Encrypted: i=1; AJvYcCUBMrzKFkBHBWj+3UxDhXJEEs40SPydfZ6YsBJilJhUFKyxDKmgo2rLaqxbmy6Ng0buT22A/ffXMg==@kvack.org
X-Gm-Message-State: AOJu0YyH87pbyhICEd10aah2NMUFyiZKcD5Nd+VGH8mQx+vIVOzdO17j
	nhs29YUxbOuN9EzgjA8PyG81JGcsjf9aveu2UG7GOHfBO5TZS/dwuSI9mV0HorFJfTGgjoGlMwI
	K4odV5qHFhQvclTjUbrXaJzeWDtoVaZWwuFd4wJqH
X-Gm-Gg: AZuq6aI4KtXVrwEWKZ1XcyWnYa38KmZCprzF50QoWjh7HkHi/SAlv+NSqEKytVmo6xZ
	60cnhvruTL3yG9uhk67axGH9BDClesFOmBIQ/BKzjby/jraciuPJfIivcA6GhKneMpTDuAQN4DN
	ksJkWmKA63I5YEDDyG5Sbyo8AAd7lHtDZn0iDA6SDBD4tJw6Gmwq7Q58kkeZA02ckVWlCYyKWEP
	iwxw5NpfEBE2DomuEMWU4eHb0KJw+ebFd1rbtAhDDOHUqp3zziMfyBjjGwuq1B7uZGWccDLqWVd
	oybtToV0Ylhc7NzvbhoCToo=
X-Received: by 2002:a05:622a:1825:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-502ebddf1damr405151cf.1.1769020240526; Wed, 21 Jan 2026
 10:30:40 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 18:30:28 +0000
X-Gm-Features: AZwV_QgJsx28PWNy6MDtA7PMODlO-XxW0gxWFH0Lcu8zvlUQSetLY7ny4kvP86A
Message-ID: <CAJuCfpHi_WqPkWvQuDqg3L1FNeV-P=E52uCakBCXz1AFmkHf=Q@mail.gmail.com>
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 418D3140002
X-Stat-Signature: p1xrup578eh8osea6jfbeibpio5f7erf
X-Rspam-User: 
X-HE-Tag: 1769020242-812930
X-HE-Meta: U2FsdGVkX1/j58zPPVpC6IudrgnZwA8FsG+JIJviRxm2CuVRgbQbODND+I4NTaralJ70eOYpkPciGhZaTdfh/Q1vNzciprDGAlPp/6eq4HCfXVpIYzpg6raGbzHRU2dlRaMbyEOHa7sraRqbP4eG2M52eJ/02yj14klciShTf4f3cSTKQCdJEfrRxKweoIRapM2d/xqOMQyNenRFVk6zorV2ylzRHbSAc/k3fghbQ+7mkoSLos17iS9x0h7NYTFpwywkmUguH4ddfHfjM9wvPTcuPlE7hVUkfDOMIF1MXtrAw/uEyWllpHzo8oRUZvmx9t2H2WDhxs6PVUyOBNNUfs2BidJL1fvgdQr+62tMEU7dph9QwxxIHl5ZJnn1D6tGr9nYU2B5KBYhEWsr+4sazgmKPfRXNVKPZLuOkeAyEk10v4bse5j8/NH3TvGVayjJlOwo2VdhR434AMJKbsa9QJ6/ISRr9ycdjXyclxJAVxdMv3sLLHYLGQUkwliqXq2ZUD78hTDw1vf1m/4ziBQthScSKxtY1uDpLnMSCM2hQsIlIRjOU0WaPcDqCKT7qHP8XhyrHOYdVAg8ktakLHi2+jyUs6RRyKht4NQzOfvRSYpgfn0woOqgPcJk/wzQCjEVRSTU3+3wh7Cz9mnrrCeHgMB7Jl31C1WJr//DLBfsumK3fxehdXKojgV2LP6fKmoayKZVt7ldl3FZ3j1sfj8lO9B5HH8xvEBO1HsB5sre/pmCiXRfT8v33AyNXV8BjhCDELsXCpX+F6a5o2qIIh2TITsvWifk1Fo03yBrO5JjEhHLb8cd/6T9ZK9jR+hJvG3O7bOd6zAY2Rokg6is1c6p4Kont3VQjthVofBAyGGLDc0rkRlF0/yffAYAsP/iIVCX27AuahakBle484DxIhw4XsSJ6LIWhfNUrc1lxHu6fy+5YqK0QvlfQ63Dgp/GAUmHYLPLY2bei8y1mSxVvPd
 Hy9huvaY
 i0x/ioikVZJ1+2tNhAIuF9D6Qth30/KlrH8VDLpKpfQzrgN1LgFiaVEj3NQ5t1Szy3XHZ3ztnRrWvhdSLlRn304LH9fRmJPQEIYiykzXN88j0SKSMnxAzMrHkybJBqdOnfyXilZAskiXidx8H81vd5aPqRB5FE+T7KMDlBiikeRfyfGrIzfaH5IELgvRGKJUfVMxXphA8zQWFY478+/MiQp9sdCIt2ofInGLsDqtz/+EkwfhtukBBYzkdSCoOHjEruTOB8te+mOAjqes=
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
> __refill_objects() currently only attempts to get partial slabs from the
> local node and then allocates new slab(s). Expand it to trying also
> other nodes while observing the remote node defrag ratio, similarly to
> get_any_partial().
>
> This will prevent allocating new slabs on a node while other nodes have
> many free slabs. It does mean sheaves will contain non-local objects in
> that case. Allocations that care about specific node will still be
> served appropriately, but might get a slowpath allocation.
>
> Like get_any_partial() we do observe cpuset_zone_allowed(), although we
> might be refilling a sheaf that will be then used from a different
> allocation context.
>
> We can also use the resulting refill_objects() in
> __kmem_cache_alloc_bulk() for non-debug caches. This means
> kmem_cache_alloc_bulk() will get better performance when sheaves are
> exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
> it's compatible with sheaves refill in preferring the local node.
> Its users also have gfp flags that allow spinning, so document that
> as a requirement.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 137 ++++++++++++++++++++++++++++++++++++++++++++++++--------=
------
>  1 file changed, 106 insertions(+), 31 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d52de6e3c2d5..2c522d2bf547 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2518,8 +2518,8 @@ static void free_empty_sheaf(struct kmem_cache *s, =
struct slab_sheaf *sheaf)
>  }
>
>  static unsigned int
> -__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int=
 min,
> -                unsigned int max);
> +refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int m=
in,
> +              unsigned int max);
>
>  static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>                          gfp_t gfp)
> @@ -2530,8 +2530,8 @@ static int refill_sheaf(struct kmem_cache *s, struc=
t slab_sheaf *sheaf,
>         if (!to_fill)
>                 return 0;
>
> -       filled =3D __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
> -                       to_fill, to_fill);
> +       filled =3D refill_objects(s, &sheaf->objects[sheaf->size], gfp, t=
o_fill,
> +                               to_fill);
>
>         sheaf->size +=3D filled;
>
> @@ -6522,29 +6522,22 @@ void kmem_cache_free_bulk(struct kmem_cache *s, s=
ize_t size, void **p)
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>
>  static unsigned int
> -__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int=
 min,
> -                unsigned int max)
> +__refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigne=
d int min,
> +                     unsigned int max, struct kmem_cache_node *n)
>  {
>         struct slab *slab, *slab2;
>         struct partial_context pc;
>         unsigned int refilled =3D 0;
>         unsigned long flags;
>         void *object;
> -       int node;
>
>         pc.flags =3D gfp;
>         pc.min_objects =3D min;
>         pc.max_objects =3D max;
>
> -       node =3D numa_mem_id();
> -
> -       if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +       if (!get_partial_node_bulk(s, n, &pc))
>                 return 0;
>
> -       /* TODO: consider also other nodes? */
> -       if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> -               goto new_slab;
> -
>         list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>
>                 list_del(&slab->slab_list);
> @@ -6582,8 +6575,6 @@ __refill_objects(struct kmem_cache *s, void **p, gf=
p_t gfp, unsigned int min,
>         }
>
>         if (unlikely(!list_empty(&pc.slabs))) {
> -               struct kmem_cache_node *n =3D get_node(s, node);
> -
>                 spin_lock_irqsave(&n->list_lock, flags);
>
>                 list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_lis=
t) {
> @@ -6605,13 +6596,92 @@ __refill_objects(struct kmem_cache *s, void **p, =
gfp_t gfp, unsigned int min,
>                 }
>         }
>
> +       return refilled;
> +}
>
> -       if (likely(refilled >=3D min))
> -               goto out;
> +#ifdef CONFIG_NUMA
> +static unsigned int
> +__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned=
 int min,
> +                    unsigned int max, int local_node)
> +{
> +       struct zonelist *zonelist;
> +       struct zoneref *z;
> +       struct zone *zone;
> +       enum zone_type highest_zoneidx =3D gfp_zone(gfp);
> +       unsigned int cpuset_mems_cookie;
> +       unsigned int refilled =3D 0;
> +
> +       /* see get_any_partial() for the defrag ratio description */
> +       if (!s->remote_node_defrag_ratio ||
> +                       get_cycles() % 1024 > s->remote_node_defrag_ratio=
)
> +               return 0;
> +
> +       do {
> +               cpuset_mems_cookie =3D read_mems_allowed_begin();
> +               zonelist =3D node_zonelist(mempolicy_slab_node(), gfp);
> +               for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx=
) {
> +                       struct kmem_cache_node *n;
> +                       unsigned int r;
> +
> +                       n =3D get_node(s, zone_to_nid(zone));
> +
> +                       if (!n || !cpuset_zone_allowed(zone, gfp) ||
> +                                       n->nr_partial <=3D s->min_partial=
)
> +                               continue;
> +
> +                       r =3D __refill_objects_node(s, p, gfp, min, max, =
n);
> +                       refilled +=3D r;
> +
> +                       if (r >=3D min) {
> +                               /*
> +                                * Don't check read_mems_allowed_retry() =
here -
> +                                * if mems_allowed was updated in paralle=
l, that
> +                                * was a harmless race between allocation=
 and
> +                                * the cpuset update
> +                                */
> +                               return refilled;
> +                       }
> +                       p +=3D r;
> +                       min -=3D r;
> +                       max -=3D r;
> +               }
> +       } while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> +       return refilled;
> +}
> +#else
> +static inline unsigned int
> +__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned=
 int min,
> +                    unsigned int max, int local_node)
> +{
> +       return 0;
> +}
> +#endif
> +
> +static unsigned int
> +refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int m=
in,
> +              unsigned int max)
> +{
> +       int local_node =3D numa_mem_id();
> +       unsigned int refilled;
> +       struct slab *slab;
> +
> +       if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +               return 0;
> +
> +       refilled =3D __refill_objects_node(s, p, gfp, min, max,
> +                                        get_node(s, local_node));
> +       if (refilled >=3D min)
> +               return refilled;
> +
> +       refilled +=3D __refill_objects_any(s, p + refilled, gfp, min - re=
filled,
> +                                        max - refilled, local_node);
> +       if (refilled >=3D min)
> +               return refilled;
>
>  new_slab:
>
> -       slab =3D new_slab(s, pc.flags, node);
> +       slab =3D new_slab(s, gfp, local_node);
>         if (!slab)
>                 goto out;
>
> @@ -6626,8 +6696,8 @@ __refill_objects(struct kmem_cache *s, void **p, gf=
p_t gfp, unsigned int min,
>
>         if (refilled < min)
>                 goto new_slab;
> -out:
>
> +out:
>         return refilled;
>  }
>
> @@ -6637,18 +6707,20 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s,=
 gfp_t flags, size_t size,
>  {
>         int i;
>
> -       /*
> -        * TODO: this might be more efficient (if necessary) by reusing
> -        * __refill_objects()
> -        */
> -       for (i =3D 0; i < size; i++) {
> +       if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> +               for (i =3D 0; i < size; i++) {
>
> -               p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
> -                                    s->object_size);
> -               if (unlikely(!p[i]))
> -                       goto error;
> +                       p[i] =3D ___slab_alloc(s, flags, NUMA_NO_NODE, _R=
ET_IP_,
> +                                            s->object_size);
> +                       if (unlikely(!p[i]))
> +                               goto error;
>
> -               maybe_wipe_obj_freeptr(s, p[i]);
> +                       maybe_wipe_obj_freeptr(s, p[i]);
> +               }
> +       } else {
> +               i =3D refill_objects(s, p, flags, size, size);
> +               if (i < size)
> +                       goto error;
>         }
>
>         return i;
> @@ -6659,7 +6731,10 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, =
gfp_t flags, size_t size,
>
>  }
>
> -/* Note that interrupts must be enabled when calling this function. */
> +/*
> + * Note that interrupts must be enabled when calling this function and g=
fp
> + * flags must allow spinning.
> + */
>  int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size=
_t size,
>                                  void **p)
>  {
>
> --
> 2.52.0
>

