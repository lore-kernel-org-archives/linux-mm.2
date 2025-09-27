Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F90CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 01:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D598E0003; Fri, 26 Sep 2025 21:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164BC8E0001; Fri, 26 Sep 2025 21:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2038E0003; Fri, 26 Sep 2025 21:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED3078E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC949C04CF
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 01:17:22 +0000 (UTC)
X-FDA: 83933267124.15.2132C77
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F5E94000C
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 01:17:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4kG/5kb7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758935841; a=rsa-sha256;
	cv=none;
	b=kKieChK7cTfo13kBYwZ2Y4vwtsCzt7YX+pL8jt5ZIqYu2HqFZLwnVgZBdOcWE+Y0ZxcwER
	1eCntwOEPIBJm95iJQw6gF3NjTOexTD4VPENsORpm/JWuusOSNKGhPftL2+BYbDaw6748t
	p+zjceKQDSZ75Ziuiw9sDnhZPyXNa8s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4kG/5kb7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758935841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JP6jNuOzuaZrN4jqHuCq7vrrzkS8UserW/hueLrBex8=;
	b=IRoYAK9qzsichNrt6O8eZkpvt77rB+lE+zAwNN3m7Rp3bGneQh/FBzEMS1P8uk0sxbLmOy
	CclM0UlsHuqo38bBUayViboI0PdMqB5TmWb3l4ZQbGJ+cOBl5YRe2/P7fYxyZYPgSqoyI/
	/F+nRai1vAwi+ZISWMwyWjrzs19HVcg=
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42451cc9deaso57775ab.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758935840; x=1759540640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JP6jNuOzuaZrN4jqHuCq7vrrzkS8UserW/hueLrBex8=;
        b=4kG/5kb7sAJ3fa7jU4SbLf5TAZHPOOwTSdRkyfyEfC4npcjcL6mrUe/jZ7OYG8ZFA2
         tdjAUL1Pi7L4C/sRf5tgpWlSdJPQCKXgzqDpclGG6stCV8S0HyIX/5+x3+9ZvIaAfQlb
         2cGYuFpjkWWtvohHU+9aq+NxXHYzbg0lP1GlRXH2dPQ2wpclH1+jnFPMxRTS+KBxJmhk
         I3guQGXiF3l+iKVRG0CrUa7dj8KRTyvkAvlvyE8QhiCDqZ9SehXtaZhC6RufS5/s9ljs
         2RDPICYfUVaespRbh7ChYQ6Ci6dNneqy3V9Zzx8gXniRsrpcFnWeY2Y0e7+9keLfemQJ
         axqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758935840; x=1759540640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JP6jNuOzuaZrN4jqHuCq7vrrzkS8UserW/hueLrBex8=;
        b=QYihzwN9dGuIzPSuKoDHd6knR8MBMHK0XduG+r9XEA0kipYjGDrvEOArxvita0Juwx
         EN/V4SwsOYZc5gSquQBWgOrlQgXvQepHL5j2LMyJB18fLr/wVIOmG1Ay9frjRXqrFgs5
         PbqLFPKoqC2WzmyKB83+BkrtNkHUFuah5meRq9rPjCwFByUGo0BoOAYZJCrlF39VdqMP
         +oTK5Q8z3uhXSz4VvpANiG46LoJTIbB04lx48rI2QFo44bdKcpL+TyHXRNlAIfu3LVDB
         KAV3PdxncKxf0f1DwehOPSH+hkZFsnwZkSwbwFXX+lRHrSztQY0Sz1wP7I0pbwZFqd9m
         5A4w==
X-Forwarded-Encrypted: i=1; AJvYcCUpn6nlCKs8Hc1/b/w33n6pZllu/EuNXn7o2cDaDRLq4pFqjyxnLLPsTJPqS/8XNmmW814aCv+MjA==@kvack.org
X-Gm-Message-State: AOJu0YxR7DydA5dFGWCO7+G9fAyDl+8FtcYOCLwf8LCM7KICrfUPGbUE
	PxxzRhknImkD+sbCLGf8Eg9ttukFffuro0mbREZmNVZuMN8T/TXNUxdB9A6aCtn1NiyG9AIddZ5
	JPQ6pNkrU2yi979mYzMq70xMThpOwcKt/JW9jb6Wb
X-Gm-Gg: ASbGncss5V6S+v0CPhf34bRxn88ob1Rhzzz0klP8/5ps3JpDBA9HOWZuNwq4lS/ZYPr
	8iE8To6D7Uvd2dGmbCONe1nL7vpCoQGSbUULDzNER55ItUe0H5yzqlq6DF4V8UlqeyQZaLHj0C2
	QBPwhihyjYbkCN99YNOHe2Ct2HNDA/ZtH7teOqZU2e6dE1xXhfPUwNae/3jSBQ257slk02bF8Kj
	4mTXXVBeqwc
X-Google-Smtp-Source: AGHT+IGpoONlCIOAmMBpkfhbwwmRo6WPxhB3OyNDNkTIiNF4jxrBqrGuAWP/ZktJKaI8KQeNzgcj6VefKfyiJbBSYPU=
X-Received: by 2002:a05:6e02:2589:b0:425:7759:802b with SMTP id
 e9e14a558f8ab-42865823250mr3145845ab.3.1758935839686; Fri, 26 Sep 2025
 18:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-22-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-22-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 18:17:08 -0700
X-Gm-Features: AS18NWC10t7P1-gbNUaB2koz9Kn412M7cqwnvwuIUDJz-je5B49gAVgPRT2D2pk
Message-ID: <CAJuCfpGhv15YLyAm7X63t5gT9hkw+6PK3GZbWmOTng+AG7rEsg@mail.gmail.com>
Subject: Re: [PATCH v8 22/23] maple_tree: Add single node allocation support
 to maple state
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F5E94000C
X-Stat-Signature: 6o1bd8krsnx4nrkocygyah8s3zpt6w9f
X-Rspam-User: 
X-HE-Tag: 1758935840-274888
X-HE-Meta: U2FsdGVkX19w1Wc46gtplnK7pIuwew4lpHF+JyDZ6hi4te67TQ9JMt0H2t6J9ITuQoQkH0Ug6fjfla4/d87Xd/Lq4X1QyOmXBztarw2iU8mxSYAGAmLsC41n014x+HFgMNUCIpB6GEHfvsRAMQ6q31B2XYVLir4A+Vka8T6ktsoyElo4Tr8UQVhXzVKkLfJYyQodKuuBlLqKDkZvMLPe7dQicb7dZBIG+YWsfu5zHZyx04SQjHgQ/hELD5yGS0/2q0Ajq7kMTh7qbb02Y0TvPAKFce6t5uxe7XiOOZSDQ5Tvk/6ZTtRXV/ZtWyhOIegd83bFN5ze3/YoOan4ib1DlQH+V5EbkAVT71+FsJdiIej4HyV6CpMO7hiAudohviAcsQtQRFaDjr0+tTYSl1N1doly9trMOmQE4uY6LzDmOgayUnnjEfm3FMNjkffdjof3YoSFIhGOP0nl9jP5fbeF5r4M10jvnJ3VQv/CIGVjrwE65o8SgDutCW6PSreOcCHkdysHlxoBH77tTvtFqvUbAQ8Xdx5qAFaWTH4Xy/87XMa90TPRV0Iv5MWR1m1cCHCeg6V64dShqNf60qRSBpjWBTP1PGtJRNLxuSr27//rxeH+0S84JwBCxJlkVUDRabuZUKWYVe1jF0UlRO0FYH0zmp2TjhPkdnW3u0WFfzaWqSJOvXyHIO0xQgkd1g11HhU5j0swqeTn8cptP8pisN8X2NCoGDQePk4St3uiBAsJR9IUhCe6p9xvGDoz0YxrJymLb6UoNeVet1T5vw5hJpB25QrUaa/XfUQjufsC6z9TTSYN5OL29OOO4cFcOQ/Ov7zP1zN5Oz/nmCBTNIRdbnfn6fPIiyHBW5+j6oUiO5yU0F1hc6hAPpglhBpdMuwRqrvrctzpJ+eHWb+V5QaJnpkF7Nx64YlG78t5Dg3wrJ0F7kHe4UjaOon4lUT/lC9cyOgZ+HvBVwxrGiZ+m4mOBFM
 qxigNrYL
 6vOouW/OhoR8CyP8yajBW0QPQT2ABsiDes/FqsXs7j/G3S1+y76W4SJp4NIcDc2epavkDnpwIekSy95jb67xefYtgf6ZHPiA0yVkbYvqVQyaxpbZIS42rl8DB9RHaWFnwqaCX0sdjSFCUMt1e2v2pWcTM7t8Pf0nUaUzcbOxhHtgA4CY6MBv9jOu8F9ghykZKOa2qmroQFMdWJSFF+vXtD8DPy/wu5VsaV8ySQKTAJLyCAzQ+GzI4zVcZfqKeFfSZ3zQQJWagzRm6q9Y=
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
> From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
>
> The fast path through a write will require replacing a single node in
> the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
> special case the node store operation by just allocating one node in the
> maple state.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/maple_tree.h       |  4 +++-
>  lib/maple_tree.c                 | 47 ++++++++++++++++++++++++++++++++++=
+-----
>  tools/testing/radix-tree/maple.c |  9 ++++++--
>  3 files changed, 51 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 166fd67e00d882b1e6de1f80c1b590bba7497cd3..562a1e9e5132b5b1fa8f8402a=
7cadd8abb65e323 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -443,6 +443,7 @@ struct ma_state {
>         unsigned long min;              /* The minimum index of this node=
 - implied pivot min */
>         unsigned long max;              /* The maximum index of this node=
 - implied pivot max */
>         struct slab_sheaf *sheaf;       /* Allocated nodes for this opera=
tion */
> +       struct maple_node *alloc;       /* allocated nodes */
>         unsigned long node_request;
>         enum maple_status status;       /* The status of the state (activ=
e, start, none, etc) */
>         unsigned char depth;            /* depth of tree descent during w=
rite */
> @@ -491,8 +492,9 @@ struct ma_wr_state {
>                 .status =3D ma_start,                                    =
 \
>                 .min =3D 0,                                              =
 \
>                 .max =3D ULONG_MAX,                                      =
 \
> -               .node_request=3D 0,                                      =
 \
>                 .sheaf =3D NULL,                                         =
 \
> +               .alloc =3D NULL,                                         =
 \
> +               .node_request=3D 0,                                      =
 \
>                 .mas_flags =3D 0,                                        =
 \
>                 .store_type =3D wr_invalid,                              =
 \
>         }
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index a3fcb20227e506ed209554cc8c041a53f7ef4903..a912e6a1d4378e72b967027b6=
0f8f564476ad14e 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1073,16 +1073,23 @@ static int mas_ascend(struct ma_state *mas)
>   *
>   * Return: A pointer to a maple node.
>   */
> -static inline struct maple_node *mas_pop_node(struct ma_state *mas)
> +static __always_inline struct maple_node *mas_pop_node(struct ma_state *=
mas)
>  {
>         struct maple_node *ret;
>
> +       if (mas->alloc) {
> +               ret =3D mas->alloc;
> +               mas->alloc =3D NULL;
> +               goto out;
> +       }
> +
>         if (WARN_ON_ONCE(!mas->sheaf))
>                 return NULL;
>
>         ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT,=
 mas->sheaf);
> -       memset(ret, 0, sizeof(*ret));
>
> +out:
> +       memset(ret, 0, sizeof(*ret));
>         return ret;
>  }
>
> @@ -1093,9 +1100,34 @@ static inline struct maple_node *mas_pop_node(stru=
ct ma_state *mas)
>   */
>  static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>  {
> -       if (unlikely(mas->sheaf)) {
> -               unsigned long refill =3D mas->node_request;
> +       if (!mas->node_request)
> +               return;
> +
> +       if (mas->node_request =3D=3D 1) {
> +               if (mas->sheaf)
> +                       goto use_sheaf;

Hmm, I don't get the above logic. One node is requested and instead of
using possibly available mas->alloc, we jump to using mas->sheaf and
freeing mas->alloc... That does not sound efficient. What am I
missing?

> +
> +               if (mas->alloc)
> +                       return;
>
> +               mas->alloc =3D mt_alloc_one(gfp);
> +               if (!mas->alloc)
> +                       goto error;
> +
> +               mas->node_request =3D 0;
> +               return;
> +       }
> +
> +use_sheaf:
> +       if (unlikely(mas->alloc)) {
> +               kfree(mas->alloc);
> +               mas->alloc =3D NULL;
> +       }
> +
> +       if (mas->sheaf) {
> +               unsigned long refill;
> +
> +               refill =3D mas->node_request;
>                 if(kmem_cache_sheaf_size(mas->sheaf) >=3D refill) {
>                         mas->node_request =3D 0;
>                         return;
> @@ -5180,8 +5212,11 @@ void mas_destroy(struct ma_state *mas)
>         mas->node_request =3D 0;
>         if (mas->sheaf)
>                 mt_return_sheaf(mas->sheaf);
> -
>         mas->sheaf =3D NULL;
> +
> +       if (mas->alloc)
> +               kfree(mas->alloc);
> +       mas->alloc =3D NULL;
>  }
>  EXPORT_SYMBOL_GPL(mas_destroy);
>
> @@ -5816,7 +5851,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>                 mas_alloc_nodes(mas, gfp);
>         }
>
> -       if (!mas->sheaf)
> +       if (!mas->sheaf && !mas->alloc)
>                 return false;
>
>         mas->status =3D ma_start;
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/=
maple.c
> index 72a8fe8e832a4150c6567b711768eba6a3fa6768..83260f2efb1990b71093e4569=
50069c24d75560e 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -35085,10 +35085,15 @@ static unsigned char get_vacant_height(struct m=
a_wr_state *wr_mas, void *entry)
>
>  static int mas_allocated(struct ma_state *mas)
>  {
> +       int total =3D 0;
> +
> +       if (mas->alloc)
> +               total++;
> +
>         if (mas->sheaf)
> -               return kmem_cache_sheaf_size(mas->sheaf);
> +               total +=3D kmem_cache_sheaf_size(mas->sheaf);
>
> -       return 0;
> +       return total;
>  }
>  /* Preallocation testing */
>  static noinline void __init check_prealloc(struct maple_tree *mt)
>
> --
> 2.51.0
>

