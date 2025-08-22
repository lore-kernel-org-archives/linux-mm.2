Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7A9CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD4C8E0013; Fri, 22 Aug 2025 15:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994778E000D; Fri, 22 Aug 2025 15:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAC08E0013; Fri, 22 Aug 2025 15:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5288E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:58:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00EB31A031D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:58:53 +0000 (UTC)
X-FDA: 83805456588.08.2ACE1C5
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5AE121C0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:58:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyYxQ+IS;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755892732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zbL7KxWZEdFtClBa6fqt36ZA0mgbM0HT/V3o4VWa5g=;
	b=lQOYx+i74OJ/evIyERu+/y0MqOEO/jpIkFW8cIDb0qaMEGKPU9A2BgM77v7Oa/FKyBNXLD
	SqFc1RA/gw9nhsoIvDocLWNm+hbQFtOD6frX0uFJpcCKQQddQ7a1Ul0Y1Ov3h9g2nGwNHa
	euUjrmOac9/HJWd62ORXib7tzLQS7ew=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyYxQ+IS;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755892732; a=rsa-sha256;
	cv=none;
	b=LldKrelZOut3rwFKItJ4P/V+QB2aEJu4cp4/JTZCrM+O48RpBF/s091yY171QQDJMlaMdJ
	06n4MtTXuaMHuisqZJOqyYQ5PJzM/MorqDHyuPVF7mreVZfFAKYYbtQZnHwy9XAazpKImr
	/t3SfgvQ5IIBTs8+WUCf9iKVNQBK6GQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso60491cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755892731; x=1756497531; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zbL7KxWZEdFtClBa6fqt36ZA0mgbM0HT/V3o4VWa5g=;
        b=ZyYxQ+IS7T3W6dvWaLfTdad2wQqeZPEZl5r3kmgObNKqk27uHq2I+Vp+QZsysyoNKk
         +5Mtf4LgungTNf51PZsH8bpYq7VC0k/HIrvdMNcEbBzDQ5VdQe1wiyHnKxQTAvzIhSJA
         kvcVxINhxUib2MZp2R+iwbkDoXx2uelakq4CYMdCf+V804hTfnJZBJj3J/y1udzPvNMs
         COjl7qSiUQxzYryUnNvuQLt1wLbAwymwlriWGV5jEA7Wm74X7VrIbtZ09w0Qa5XDXf/V
         N4TGOXLJQuVwrc9OVktzfyYFexoQ4Sx/08n4ZueENMOgmzGA5Wndaa9MxyURIuijT5sN
         EjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755892731; x=1756497531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zbL7KxWZEdFtClBa6fqt36ZA0mgbM0HT/V3o4VWa5g=;
        b=Zo2D3pEm2HsJ/Kj0HQRh8C3EkLKIO//FATo/FUhaS69HpW5GjufK7uPaEdcKqArL6v
         QlKvi+XFMDSQ/I/o3rdRDGD+FSsNQFDHqqUgP0r5bq0lKLr9K1i+c4AtstORBINptiFU
         fDWJbCBnm5Ff2R95kO40ndoCWPoeEhCIcunk0K5wGyXsocNkvyaaSNIFQeWSl/ngU1AW
         ojSIr604Vx+HTo/dM/iRcZ9gB5jdS15YRbOYiIHQXOOaK7m5edp+A4bDedf+LYheWSmM
         YU9VhlSNf/Q3IjRWpVqHC/e/jSr+2dH8WnoE/Hoso+237wrvIyfsoItiTTctjjKMevqd
         PsaA==
X-Forwarded-Encrypted: i=1; AJvYcCU5aXSGgeggmi+1OB0E3gnYkkS3H98YJ7fNr0Rxnpk8yRAg5bviZcVSNVEZ1btkmBtmQ/OTnDk71A==@kvack.org
X-Gm-Message-State: AOJu0YxW5eKK4s2j7o86ZHFlGHh33TnwG2FfpExy5OBzUJBzMtqwRTYi
	uvGmwDHy9erekmBYvAw3f61rrqcpE4l65lqeZsHTv4gju5tQGxMPiknMdd4D/ffNRJ8Q3vr+yfX
	MudZITV4AqwI9WKZaoRZv552o0IAXsAe0u4I10xiR
X-Gm-Gg: ASbGnct+oOds5jBalMPyaSR86CkrkV400h29MpoQb4mBKlKtzj9ZlPqpmmOn9SfgDdV
	p4UbH+KUNfF+KOxOgQMZ67zyu3tPHh6M69ZBf2/39G9FAu/vvmUoC7ennXdA1I2d9bcShpb8VlC
	ERppkWbCzh1ud374B4KQIbxR7+MCUAyB83F8r3PK1HnH+GcEhjXBpnfPTBsrza/rXSkYYRaXltz
	XTCiQCTaNKpRqet0npVLEg=
X-Google-Smtp-Source: AGHT+IFkGBfHZ2+PDQQ6XW2JA5HA4716qCgCxznra7rjS8t9rVJmfjNGxXpArpYN4u40i4cniAw7m/bxlDqhU+rScjw=
X-Received: by 2002:ac8:7f47:0:b0:4a9:e17a:6287 with SMTP id
 d75a77b69052e-4b2ba9faaefmr646441cf.7.1755892730905; Fri, 22 Aug 2025
 12:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 12:58:40 -0700
X-Gm-Features: Ac12FXxtiMpVk0VN-fqcAsXzDvd7uIQeiITE8KpMBbIe5MvmOPVwZb-kbSUcaTc
Message-ID: <CAJuCfpHdBJ+9zkT+8AbTkV+cGx4td5t9-Gdtf-jUW8G0RZHKHg@mail.gmail.com>
Subject: Re: [PATCH v5 10/14] mm, slab: allow NUMA restricted allocations to
 use percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5AE121C0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b1ctqi8on4hk4jkbfooedek79h6jraxe
X-HE-Tag: 1755892732-343876
X-HE-Meta: U2FsdGVkX1+6dRhUsRUiGMgPkH3JN88S6V5hXMwAV5QKx5YGM6m4kTjbmoORfyM8hTUjuj57VVhi5mPAnklw9uG0i9yZtDYoR/YMDVAwKSP7g5ItQuI+57vsyIUA05BT+EJ6MfcCDmrhv4eY7oPrK0yc1j6NJZpzWRewbuI4MVTxkLv9YjKYsAia4OHKxukf2e5hG3wsmHxVVUy+TekycZXIEGU5SWJS1qVZ12tIC7BBmuk9yrARseuBIiI9u//ZX2wBJG2HUAMKJnrilXJFoDzhtSnd3PslWAMZiKK+hSC55eLID25GdwACOq0xqfQ8pZCLFrjgBpLmTUY0ugG62oDDhEk3jfVEEPe34v+Sqq3wTTZL52SEz36yaJfWMVhQUh1C8ym2wrOjo2KT7gEWcz2X/y5gVG9B1eJqW+Mr7RM84XihaUGceJV/myg1uWvpjj4FD96orAJEhFNHPMZNvdoNqxKKi+2oPzMC2z3QIGV7YyR/48JDBQ1iAlsyII7c7TpWQUVC7DFd85zTfCAbM292E/QaMf8LP91ImyPGREy9lCSRjtEOguBxJzNlR6G2+yKxTepZywvaqAPF8f3z3JKuskb0x085OiiJC1KJRH19nkcr6HrK5CBF/kiaQvonWlSVs3IWNBezj8tLlUfl9FrvsE0YAfzQ6DxZjApqWKzAV+Mwb6RQsKNvTG1x+mvVXGF8ASl3vYWIsqbcv3IVSW4dWDcYgSoBYxlcXUP9qAcjBxLuqXu3WBOAS3JsGlAEYRKKHXtlBUU7+N/VfN8EoVFmB4lviypgS8t1ruTqq/AT9YvBanVaRsLu0TuJjZjVaxit9H/jVRpnDuE/5B2h91BG6h6xXKrdIs87mLJcspwrI5JyiXQmoz9Z3AsE5I+3DZRDxbGUIlEFdOKVhkQ4bKxRp6R+w3ER
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
> Currently allocations asking for a specific node explicitly or via
> mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
> contain mostly local objects, we can try allocating from them if the
> local node happens to be the requested node or allowed by the mempolicy.
> If we find the object from percpu sheaves is not from the expected node,
> we skip the sheaves - this should be rare.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 52 +++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 50fc35b8fc9b3101821c338e9469c134677ded51..b98983b8d2e3e04ea256d91ef=
cf0215ff0ae7e38 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4765,18 +4765,42 @@ __pcs_handle_empty(struct kmem_cache *s, struct s=
lub_percpu_sheaves *pcs, gfp_t
>  }
>
>  static __fastpath_inline
> -void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
> +void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  {
>         struct slub_percpu_sheaves *pcs;
>         void *object;
>
>  #ifdef CONFIG_NUMA
> -       if (static_branch_unlikely(&strict_numa)) {
> -               if (current->mempolicy)
> -                       return NULL;
> +       if (static_branch_unlikely(&strict_numa) &&
> +                        node =3D=3D NUMA_NO_NODE) {
> +
> +               struct mempolicy *mpol =3D current->mempolicy;
> +
> +               if (mpol) {
> +                       /*
> +                        * Special BIND rule support. If the local node
> +                        * is in permitted set then do not redirect
> +                        * to a particular node.
> +                        * Otherwise we apply the memory policy to get
> +                        * the node we need to allocate on.
> +                        */
> +                       if (mpol->mode !=3D MPOL_BIND ||
> +                                       !node_isset(numa_mem_id(), mpol->=
nodes))
> +
> +                               node =3D mempolicy_slab_node();
> +               }
>         }
>  #endif
>
> +       if (unlikely(node !=3D NUMA_NO_NODE)) {

Should this and later (node !=3D NUMA_NO_NODE) checks be still under
#ifdef CONFIG_NUMA ?

> +               /*
> +                * We assume the percpu sheaves contain only local object=
s
> +                * although it's not completely guaranteed, so we verify =
later.
> +                */
> +               if (node !=3D numa_mem_id())
> +                       return NULL;
> +       }
> +
>         if (!local_trylock(&s->cpu_sheaves->lock))
>                 return NULL;
>
> @@ -4788,7 +4812,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t g=
fp)
>                         return NULL;
>         }
>
> -       object =3D pcs->main->objects[--pcs->main->size];
> +       object =3D pcs->main->objects[pcs->main->size - 1];
> +
> +       if (unlikely(node !=3D NUMA_NO_NODE)) {
> +               /*
> +                * Verify that the object was from the node we want. This=
 could
> +                * be false because of cpu migration during an unlocked p=
art of
> +                * the current allocation or previous freeing process.
> +                */
> +               if (folio_nid(virt_to_folio(object)) !=3D node) {
> +                       local_unlock(&s->cpu_sheaves->lock);
> +                       return NULL;
> +               }
> +       }
> +
> +       pcs->main->size--;
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> @@ -4888,8 +4926,8 @@ static __fastpath_inline void *slab_alloc_node(stru=
ct kmem_cache *s, struct list
>         if (unlikely(object))
>                 goto out;
>
> -       if (s->cpu_sheaves && node =3D=3D NUMA_NO_NODE)
> -               object =3D alloc_from_pcs(s, gfpflags);
> +       if (s->cpu_sheaves)
> +               object =3D alloc_from_pcs(s, gfpflags, node);
>
>         if (!object)
>                 object =3D __slab_alloc_node(s, gfpflags, node, addr, ori=
g_size);
>
> --
> 2.50.1
>

