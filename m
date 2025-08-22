Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F315CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 20:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E938E0014; Fri, 22 Aug 2025 16:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8CD8E000D; Fri, 22 Aug 2025 16:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0D58E0014; Fri, 22 Aug 2025 16:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6ED28E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:18:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 767571DCA8F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:18:23 +0000 (UTC)
X-FDA: 83805505686.05.AD88914
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70C64C0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:18:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r0rs/NIS";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755893901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNVaWGbgXX2aITu7IMT6bbpj/tnNjxMHrJ23UfgBI2M=;
	b=ERlFD/TULQjO1VQO7Rq2QNmWbplOBm+hxQxQVCF3tTkkyON52S0Pg0ud3k/OQVzO/617zg
	rXkBqbJAlmU/EbscjoTt8b3xCwWrMk6Ai06bY8212nkWh7IC3/W00ciGEFygVBstsHEkXO
	ZxYOWZIdBGjmPnIUwUJ6gw9IN+lupAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755893901; a=rsa-sha256;
	cv=none;
	b=Hl1kbXv9RuGkZ5zZhMmtEmAxABo8r4Ru1bkCXoPbGjDlnvXrk3uqG/anZzHiyMEncAB6/L
	R2dQx4iD1DZXM1mQfPfFl2v2QxKkheq82ZtMhoXQiiO6sD+a8mP7Lko8ei4h+mZtHg/1Yq
	BTloFIyXBzNr66K86BNQUico8oygLdE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r0rs/NIS";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso66071cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755893900; x=1756498700; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNVaWGbgXX2aITu7IMT6bbpj/tnNjxMHrJ23UfgBI2M=;
        b=r0rs/NISk6/H+5ONYJOoSIk8VjoTUvyP1IbA2DSMQcApmi+wbRjQXXOAwWMMkt85v8
         hHtGG+coxt8uhsHkNy05tJyoTfKJKRF2tbxWBu5gy1566fcfdrdffmIdoCupLbMNwDby
         NlSwDXzdIDY6yRX8jD0MgGdaB6zaUm59VXWiPatlZCSSckGPkKZ+A+jA9QynA1Ejpg0c
         UZaOCFbJqoUo7lwVoKfozIHMve4CmxFrp6ARl3x06UHnOOOiqkrAmoQO0Eg9W6Bat4r/
         AubXMoZmtA8e3J0PEkErCgt0nZJ1suB2hrnRZfNar19636yOOnNpbmMA06Ppigz16Ews
         RKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755893900; x=1756498700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNVaWGbgXX2aITu7IMT6bbpj/tnNjxMHrJ23UfgBI2M=;
        b=VEMKDdSUHQa7+f8d9QMBt1wTjcyp8YwuCihSwm9X3NK1f5LHojR3yywRh+zzHbWhpj
         zLfWU3FdI8bTAmPBQtiBgIiCA9lzRKOymX9OrB0q4aP5Byz6mkEej6YiohSZLx5nbHXH
         3XufV7LdVm+YAU8flrX6vEE3NqCZ2dxh6Xo5HiDKt4Sw7bASttlYdgxDQ5I1MxPm0RLg
         fpe7PfnYaNo2q6hicLmAVYMN414UUBbnZ+KdQAT2TIu+r8ZLqiD00Or6E9ft5E4L8vfr
         xFrze3Agt2gNNz8xi/4HZDXCz7NWmJhuEw6SOI5GQEQb5c4gqr/FCWz9F2G48Hu41uMo
         3CPg==
X-Forwarded-Encrypted: i=1; AJvYcCXsFSNDbqBf9ncwDbwNsUFzx2F91cZTS2PzXQ75hlX62g6xtEKXvGpU2e5MpyBxukg7CBx29H8a/Q==@kvack.org
X-Gm-Message-State: AOJu0Ywb4JSioWrLkj/rBrAOVYMAQxz3KeGa4l/mvrpecJTf76RueifZ
	tZcBxha896IobGaCrg3ozOguQ0YBBOfdgPSD4mg8ze0McjfmmEaccBu8rilkLt00ooWUf3d3vt2
	FTWJ1zqZvS8H06OSdC16i1aeRyqbRXlOrdSqPnFtL
X-Gm-Gg: ASbGncvFyXvhCnOI784I10Af1NGgfDBYBq8vkNLGrgISsZ5WVk8SpuQTuoHDfglONBz
	LmfmwoLOifo65Xo4De514+ZLJ+YgrGPGpRdVRwNHWsfocZ6n6UKKDDSdJbxWmtQM91pKKDlJVL4
	bG/Bn1XnvF8nqKlIImbwY18FnibO1D3IP6kNyO5/VsfjWSwc3/wwTqtpzeZpDRdpQnD+firSUnv
	fK4iyaQKpKl
X-Google-Smtp-Source: AGHT+IGTd5DU1rWd+wSPhoeCDWzB9vXvMl+Mk6F5B8whS8lDM7sDUvFFAHYzgazfwMrv4wloERhYpv3j9mUgznxTGq8=
X-Received: by 2002:ac8:5751:0:b0:4b1:22f0:8016 with SMTP id
 d75a77b69052e-4b2ba6efbcbmr903351cf.2.1755893899612; Fri, 22 Aug 2025
 13:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 13:18:08 -0700
X-Gm-Features: Ac12FXzKrXZ60Y-Dw0RXdWgm9HvfnNqv4rLm2sYAGgcwiZHNLMzPpl3z2M2X7No
Message-ID: <CAJuCfpFKjKAAyXgW_SFBXEp9N55txYdayw2h+=cSLO7wLvO2Pw@mail.gmail.com>
Subject: Re: [PATCH v5 12/14] maple_tree: Sheaf conversion
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
X-Rspamd-Queue-Id: 70C64C0005
X-Stat-Signature: ez3bmcqrituc4u5a9z4xhsr19ofsm189
X-HE-Tag: 1755893901-820525
X-HE-Meta: U2FsdGVkX19Eg19YpEi2ouIzZZmCVhnfMOm6L/s8/tj8Lr+nyaXZpOORkvs40UE+9agrMbjKEr8BBwze5DciCvabeydjHHXt0thvz0oAnMgC7CatwX5QIRRL5kwROvsjWxYUC8D8ndacWyHUrEUxSmj7YardJl+MdSd4b2T/MLQxYCUYe/IKM+H8RPVYhgcjhBvbUHZ2CDG6+0ZBEwOEayQdvSRYTiEPFiwpzV7TmVZx2Y6wq6gYOJEyDiVLN2vR89BZSAV00QaqJRIPa+Cw+PRDYcAYsiBfPl9DMhQW7fRt9wd9ChhqZ/shlAYFOgkB8gqxPPgJAx9NuKwIp3JACix2YpM1Zi69v5uz5UQFBOkrbwkD20UWE3pshEIrP7D0gq7sK+YLzLB2tnUoGs2Yo4mDagWeLiUx3QW9oPinlhHRL8mv0V79T60ApsiEwEF8ScEjFhRZMar95inPS5HcjcrDWSALmg8nnfGqCTLBTaNLM5d4NBpHZzrV2fTPY5mVJ7VN0TqTfWH8UqMUfExh/o6AwZLsDy6QlzUVYWbfNIgseau1cZIH1P1bbM6lr4Js8tWMSp+PGXxqrdEF5l3+n5duzu0eptcb/HhBCWWBhni2UfIl4ZoNJ8mf7wA4zAGtAIkIT5YEWIKHhyTEOfSqa1yQ2DzhhXtJ5L74NXhDIr64gDvfJiwDqGVddXivs8mO7RKwjozNTS4qi/i5AvEUA8uRHMFDKGBm2o7cq7QlBf0UBJWA4lVDT5f5sTSVlgVXxRBhSmFjhBcIqbFZcs/pBXj479E5FMprP2apexxFXSyK1TxVSB055jPxC2Ps32k2qoMMkiKcrooDMZUgEp5YqCx/R11DVtX2yqy2UveAl4Q6SPKJS9y+RjfWxfqjBNZh6nsEZjj/YJ2tCqUIgVgv29gzEOHq1C8q5nyjk6QnF0eezCR5/Ltoz8vJosHNVcFkQL8q/DMq9BnUkfrdnAX
 nm68Gquc
 65GfBsQqqZGsA4Z3OS75L04/b1RCRFyGt6CGZgK7aY60LD5AGypbBtRxtqrBJVdn6h24oO4Wk8mQMFfNcZwVZQ6LUHxCL2uBT2QQlusTij1MsrWDm1pmHXmqZJSOPCU6cY7R6Hf2QwaGNT5KQGs5T5k0XVpKzXW3De4mU+SSr2qMlEdQOahra4mF4uu2xEiC9ZYq2gln73J9wp2xmTnD5z7QZ0getN5AQC4dPnxl9vwqdgWsy720ktWvuZLfb46SzNnR4M7zdcAHe4Xw=
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
> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>
> Use sheaves instead of bulk allocations.  This should speed up the
> allocations and the return path of unused allocations.

Nice cleanup!

>
> Remove push/pop of nodes from maple state.
> Remove unnecessary testing
> ifdef out other testing that probably will be deleted

Should we simply remove them if they are unused?

> Fix testcase for testing race
> Move some testing around in the same commit.

Would it be possible to separate test changes from kernel changes into
another patch? Kernel part looks good to me but I don't know enough
about these tests to vote on that.

>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/maple_tree.h       |   6 +-
>  lib/maple_tree.c                 | 331 ++++----------------
>  lib/test_maple_tree.c            |   8 +
>  tools/testing/radix-tree/maple.c | 632 +++++++--------------------------=
------
>  tools/testing/shared/linux.c     |   8 +-
>  5 files changed, 185 insertions(+), 800 deletions(-)
>
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 9ef1290382249462d73ae72435dada7ce4b0622c..3cf1ae9dde7ce43fa20ae400c=
01fefad048c302e 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -442,7 +442,8 @@ struct ma_state {
>         struct maple_enode *node;       /* The node containing this entry=
 */
>         unsigned long min;              /* The minimum index of this node=
 - implied pivot min */
>         unsigned long max;              /* The maximum index of this node=
 - implied pivot max */
> -       struct maple_alloc *alloc;      /* Allocated nodes for this opera=
tion */
> +       struct slab_sheaf *sheaf;       /* Allocated nodes for this opera=
tion */
> +       unsigned long node_request;
>         enum maple_status status;       /* The status of the state (activ=
e, start, none, etc) */
>         unsigned char depth;            /* depth of tree descent during w=
rite */
>         unsigned char offset;
> @@ -490,7 +491,8 @@ struct ma_wr_state {
>                 .status =3D ma_start,                                    =
 \
>                 .min =3D 0,                                              =
 \
>                 .max =3D ULONG_MAX,                                      =
 \
> -               .alloc =3D NULL,                                         =
 \
> +               .node_request=3D 0,                                      =
 \
> +               .sheaf =3D NULL,                                         =
 \
>                 .mas_flags =3D 0,                                        =
 \
>                 .store_type =3D wr_invalid,                              =
 \
>         }
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 82f39fe29a462aa3c779789a28efdd6cdef64c79..3c3c14a76d98ded3b619c178d=
64099b464a2ca23 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -198,6 +198,22 @@ static void mt_free_rcu(struct rcu_head *head)
>         kmem_cache_free(maple_node_cache, node);
>  }
>
> +static void mt_return_sheaf(struct slab_sheaf *sheaf)
> +{
> +       kmem_cache_return_sheaf(maple_node_cache, GFP_KERNEL, sheaf);
> +}
> +
> +static struct slab_sheaf *mt_get_sheaf(gfp_t gfp, int count)
> +{
> +       return kmem_cache_prefill_sheaf(maple_node_cache, gfp, count);
> +}
> +
> +static int mt_refill_sheaf(gfp_t gfp, struct slab_sheaf **sheaf,
> +               unsigned int size)
> +{
> +       return kmem_cache_refill_sheaf(maple_node_cache, gfp, sheaf, size=
);
> +}
> +
>  /*
>   * ma_free_rcu() - Use rcu callback to free a maple node
>   * @node: The node to free
> @@ -590,67 +606,6 @@ static __always_inline bool mte_dead_node(const stru=
ct maple_enode *enode)
>         return ma_dead_node(node);
>  }
>
> -/*
> - * mas_allocated() - Get the number of nodes allocated in a maple state.
> - * @mas: The maple state
> - *
> - * The ma_state alloc member is overloaded to hold a pointer to the firs=
t
> - * allocated node or to the number of requested nodes to allocate.  If b=
it 0 is
> - * set, then the alloc contains the number of requested nodes.  If there=
 is an
> - * allocated node, then the total allocated nodes is in that node.
> - *
> - * Return: The total number of nodes allocated
> - */
> -static inline unsigned long mas_allocated(const struct ma_state *mas)
> -{
> -       if (!mas->alloc || ((unsigned long)mas->alloc & 0x1))
> -               return 0;
> -
> -       return mas->alloc->total;
> -}
> -
> -/*
> - * mas_set_alloc_req() - Set the requested number of allocations.
> - * @mas: the maple state
> - * @count: the number of allocations.
> - *
> - * The requested number of allocations is either in the first allocated =
node,
> - * located in @mas->alloc->request_count, or directly in @mas->alloc if =
there is
> - * no allocated node.  Set the request either in the node or do the nece=
ssary
> - * encoding to store in @mas->alloc directly.
> - */
> -static inline void mas_set_alloc_req(struct ma_state *mas, unsigned long=
 count)
> -{
> -       if (!mas->alloc || ((unsigned long)mas->alloc & 0x1)) {
> -               if (!count)
> -                       mas->alloc =3D NULL;
> -               else
> -                       mas->alloc =3D (struct maple_alloc *)(((count) <<=
 1U) | 1U);
> -               return;
> -       }
> -
> -       mas->alloc->request_count =3D count;
> -}
> -
> -/*
> - * mas_alloc_req() - get the requested number of allocations.
> - * @mas: The maple state
> - *
> - * The alloc count is either stored directly in @mas, or in
> - * @mas->alloc->request_count if there is at least one node allocated.  =
Decode
> - * the request count if it's stored directly in @mas->alloc.
> - *
> - * Return: The allocation request count.
> - */
> -static inline unsigned int mas_alloc_req(const struct ma_state *mas)
> -{
> -       if ((unsigned long)mas->alloc & 0x1)
> -               return (unsigned long)(mas->alloc) >> 1;
> -       else if (mas->alloc)
> -               return mas->alloc->request_count;
> -       return 0;
> -}
> -
>  /*
>   * ma_pivots() - Get a pointer to the maple node pivots.
>   * @node: the maple node
> @@ -1148,77 +1103,15 @@ static int mas_ascend(struct ma_state *mas)
>   */
>  static inline struct maple_node *mas_pop_node(struct ma_state *mas)
>  {
> -       struct maple_alloc *ret, *node =3D mas->alloc;
> -       unsigned long total =3D mas_allocated(mas);
> -       unsigned int req =3D mas_alloc_req(mas);
> +       struct maple_node *ret;
>
> -       /* nothing or a request pending. */
> -       if (WARN_ON(!total))
> +       if (WARN_ON_ONCE(!mas->sheaf))
>                 return NULL;
>
> -       if (total =3D=3D 1) {
> -               /* single allocation in this ma_state */
> -               mas->alloc =3D NULL;
> -               ret =3D node;
> -               goto single_node;
> -       }
> -
> -       if (node->node_count =3D=3D 1) {
> -               /* Single allocation in this node. */
> -               mas->alloc =3D node->slot[0];
> -               mas->alloc->total =3D node->total - 1;
> -               ret =3D node;
> -               goto new_head;
> -       }
> -       node->total--;
> -       ret =3D node->slot[--node->node_count];
> -       node->slot[node->node_count] =3D NULL;
> -
> -single_node:
> -new_head:
> -       if (req) {
> -               req++;
> -               mas_set_alloc_req(mas, req);
> -       }
> -
> +       ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT,=
 mas->sheaf);
>         memset(ret, 0, sizeof(*ret));
> -       return (struct maple_node *)ret;
> -}
> -
> -/*
> - * mas_push_node() - Push a node back on the maple state allocation.
> - * @mas: The maple state
> - * @used: The used maple node
> - *
> - * Stores the maple node back into @mas->alloc for reuse.  Updates alloc=
ated and
> - * requested node count as necessary.
> - */
> -static inline void mas_push_node(struct ma_state *mas, struct maple_node=
 *used)
> -{
> -       struct maple_alloc *reuse =3D (struct maple_alloc *)used;
> -       struct maple_alloc *head =3D mas->alloc;
> -       unsigned long count;
> -       unsigned int requested =3D mas_alloc_req(mas);
> -
> -       count =3D mas_allocated(mas);
>
> -       reuse->request_count =3D 0;
> -       reuse->node_count =3D 0;
> -       if (count) {
> -               if (head->node_count < MAPLE_ALLOC_SLOTS) {
> -                       head->slot[head->node_count++] =3D reuse;
> -                       head->total++;
> -                       goto done;
> -               }
> -               reuse->slot[0] =3D head;
> -               reuse->node_count =3D 1;
> -       }
> -
> -       reuse->total =3D count + 1;
> -       mas->alloc =3D reuse;
> -done:
> -       if (requested > 1)
> -               mas_set_alloc_req(mas, requested - 1);
> +       return ret;
>  }
>
>  /*
> @@ -1228,75 +1121,32 @@ static inline void mas_push_node(struct ma_state =
*mas, struct maple_node *used)
>   */
>  static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>  {
> -       struct maple_alloc *node;
> -       unsigned long allocated =3D mas_allocated(mas);
> -       unsigned int requested =3D mas_alloc_req(mas);
> -       unsigned int count;
> -       void **slots =3D NULL;
> -       unsigned int max_req =3D 0;
> -
> -       if (!requested)
> -               return;
> +       if (unlikely(mas->sheaf)) {
> +               unsigned long refill =3D mas->node_request;
>
> -       mas_set_alloc_req(mas, 0);
> -       if (mas->mas_flags & MA_STATE_PREALLOC) {
> -               if (allocated)
> +               if(kmem_cache_sheaf_size(mas->sheaf) >=3D refill) {
> +                       mas->node_request =3D 0;
>                         return;
> -               WARN_ON(!allocated);
> -       }
> -
> -       if (!allocated || mas->alloc->node_count =3D=3D MAPLE_ALLOC_SLOTS=
) {
> -               node =3D (struct maple_alloc *)mt_alloc_one(gfp);
> -               if (!node)
> -                       goto nomem_one;
> -
> -               if (allocated) {
> -                       node->slot[0] =3D mas->alloc;
> -                       node->node_count =3D 1;
> -               } else {
> -                       node->node_count =3D 0;
>                 }
>
> -               mas->alloc =3D node;
> -               node->total =3D ++allocated;
> -               node->request_count =3D 0;
> -               requested--;
> -       }
> +               if (mt_refill_sheaf(gfp, &mas->sheaf, refill))
> +                       goto error;
>
> -       node =3D mas->alloc;
> -       while (requested) {
> -               max_req =3D MAPLE_ALLOC_SLOTS - node->node_count;
> -               slots =3D (void **)&node->slot[node->node_count];
> -               max_req =3D min(requested, max_req);
> -               count =3D mt_alloc_bulk(gfp, max_req, slots);
> -               if (!count)
> -                       goto nomem_bulk;
> -
> -               if (node->node_count =3D=3D 0) {
> -                       node->slot[0]->node_count =3D 0;
> -                       node->slot[0]->request_count =3D 0;
> -               }
> +               mas->node_request =3D 0;
> +               return;
> +       }
>
> -               node->node_count +=3D count;
> -               allocated +=3D count;
> -               /* find a non-full node*/
> -               do {
> -                       node =3D node->slot[0];
> -               } while (unlikely(node->node_count =3D=3D MAPLE_ALLOC_SLO=
TS));
> -               requested -=3D count;
> +       mas->sheaf =3D mt_get_sheaf(gfp, mas->node_request);
> +       if (likely(mas->sheaf)) {
> +               mas->node_request =3D 0;
> +               return;
>         }
> -       mas->alloc->total =3D allocated;
> -       return;
>
> -nomem_bulk:
> -       /* Clean up potential freed allocations on bulk failure */
> -       memset(slots, 0, max_req * sizeof(unsigned long));
> -       mas->alloc->total =3D allocated;
> -nomem_one:
> -       mas_set_alloc_req(mas, requested);
> +error:
>         mas_set_err(mas, -ENOMEM);
>  }
>
> +
>  /*
>   * mas_free() - Free an encoded maple node
>   * @mas: The maple state
> @@ -1307,42 +1157,7 @@ static inline void mas_alloc_nodes(struct ma_state=
 *mas, gfp_t gfp)
>   */
>  static inline void mas_free(struct ma_state *mas, struct maple_enode *us=
ed)
>  {
> -       struct maple_node *tmp =3D mte_to_node(used);
> -
> -       if (mt_in_rcu(mas->tree))
> -               ma_free_rcu(tmp);
> -       else
> -               mas_push_node(mas, tmp);
> -}
> -
> -/*
> - * mas_node_count_gfp() - Check if enough nodes are allocated and reques=
t more
> - * if there is not enough nodes.
> - * @mas: The maple state
> - * @count: The number of nodes needed
> - * @gfp: the gfp flags
> - */
> -static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gf=
p)
> -{
> -       unsigned long allocated =3D mas_allocated(mas);
> -
> -       if (allocated < count) {
> -               mas_set_alloc_req(mas, count - allocated);
> -               mas_alloc_nodes(mas, gfp);
> -       }
> -}
> -
> -/*
> - * mas_node_count() - Check if enough nodes are allocated and request mo=
re if
> - * there is not enough nodes.
> - * @mas: The maple state
> - * @count: The number of nodes needed
> - *
> - * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
> - */
> -static void mas_node_count(struct ma_state *mas, int count)
> -{
> -       return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
> +       ma_free_rcu(mte_to_node(used));
>  }
>
>  /*
> @@ -2517,10 +2332,7 @@ static inline void mas_topiary_node(struct ma_stat=
e *mas,
>         enode =3D tmp_mas->node;
>         tmp =3D mte_to_node(enode);
>         mte_set_node_dead(enode);
> -       if (in_rcu)
> -               ma_free_rcu(tmp);
> -       else
> -               mas_push_node(mas, tmp);
> +       ma_free_rcu(tmp);
>  }
>
>  /*
> @@ -4168,7 +3980,7 @@ static inline void mas_wr_prealloc_setup(struct ma_=
wr_state *wr_mas)
>   *
>   * Return: Number of nodes required for preallocation.
>   */
> -static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *en=
try)
> +static inline void mas_prealloc_calc(struct ma_wr_state *wr_mas, void *e=
ntry)
>  {
>         struct ma_state *mas =3D wr_mas->mas;
>         unsigned char height =3D mas_mt_height(mas);
> @@ -4214,7 +4026,7 @@ static inline int mas_prealloc_calc(struct ma_wr_st=
ate *wr_mas, void *entry)
>                 WARN_ON_ONCE(1);
>         }
>
> -       return ret;
> +       mas->node_request =3D ret;
>  }
>
>  /*
> @@ -4275,15 +4087,15 @@ static inline enum store_type mas_wr_store_type(s=
truct ma_wr_state *wr_mas)
>   */
>  static inline void mas_wr_preallocate(struct ma_wr_state *wr_mas, void *=
entry)
>  {
> -       int request;
> +       struct ma_state *mas =3D wr_mas->mas;
>
>         mas_wr_prealloc_setup(wr_mas);
> -       wr_mas->mas->store_type =3D mas_wr_store_type(wr_mas);
> -       request =3D mas_prealloc_calc(wr_mas, entry);
> -       if (!request)
> +       mas->store_type =3D mas_wr_store_type(wr_mas);
> +       mas_prealloc_calc(wr_mas, entry);
> +       if (!mas->node_request)
>                 return;
>
> -       mas_node_count(wr_mas->mas, request);
> +       mas_alloc_nodes(mas, GFP_NOWAIT | __GFP_NOWARN);
>  }
>
>  /**
> @@ -5398,7 +5210,6 @@ static inline void mte_destroy_walk(struct maple_en=
ode *enode,
>   */
>  void *mas_store(struct ma_state *mas, void *entry)
>  {
> -       int request;
>         MA_WR_STATE(wr_mas, mas, entry);
>
>         trace_ma_write(__func__, mas, 0, entry);
> @@ -5428,11 +5239,11 @@ void *mas_store(struct ma_state *mas, void *entry=
)
>                 return wr_mas.content;
>         }
>
> -       request =3D mas_prealloc_calc(&wr_mas, entry);
> -       if (!request)
> +       mas_prealloc_calc(&wr_mas, entry);
> +       if (!mas->node_request)
>                 goto store;
>
> -       mas_node_count(mas, request);
> +       mas_alloc_nodes(mas, GFP_NOWAIT | __GFP_NOWARN);
>         if (mas_is_err(mas))
>                 return NULL;
>
> @@ -5520,26 +5331,25 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
>  int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
>  {
>         MA_WR_STATE(wr_mas, mas, entry);
> -       int ret =3D 0;
> -       int request;
>
>         mas_wr_prealloc_setup(&wr_mas);
>         mas->store_type =3D mas_wr_store_type(&wr_mas);
> -       request =3D mas_prealloc_calc(&wr_mas, entry);
> -       if (!request)
> -               return ret;
> +       mas_prealloc_calc(&wr_mas, entry);
> +       if (!mas->node_request)
> +               return 0;
>
> -       mas_node_count_gfp(mas, request, gfp);
> +       mas_alloc_nodes(mas, gfp);
>         if (mas_is_err(mas)) {
> -               mas_set_alloc_req(mas, 0);
> -               ret =3D xa_err(mas->node);
> +               int ret =3D xa_err(mas->node);
> +
> +               mas->node_request =3D 0;
>                 mas_destroy(mas);
>                 mas_reset(mas);
>                 return ret;
>         }
>
>         mas->mas_flags |=3D MA_STATE_PREALLOC;
> -       return ret;
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(mas_preallocate);
>
> @@ -5553,9 +5363,6 @@ EXPORT_SYMBOL_GPL(mas_preallocate);
>   */
>  void mas_destroy(struct ma_state *mas)
>  {
> -       struct maple_alloc *node;
> -       unsigned long total;
> -
>         /*
>          * When using mas_for_each() to insert an expected number of elem=
ents,
>          * it is possible that the number inserted is less than the expec=
ted
> @@ -5576,21 +5383,11 @@ void mas_destroy(struct ma_state *mas)
>         }
>         mas->mas_flags &=3D ~(MA_STATE_BULK|MA_STATE_PREALLOC);
>
> -       total =3D mas_allocated(mas);
> -       while (total) {
> -               node =3D mas->alloc;
> -               mas->alloc =3D node->slot[0];
> -               if (node->node_count > 1) {
> -                       size_t count =3D node->node_count - 1;
> -
> -                       mt_free_bulk(count, (void __rcu **)&node->slot[1]=
);
> -                       total -=3D count;
> -               }
> -               mt_free_one(ma_mnode_ptr(node));
> -               total--;
> -       }
> +       mas->node_request =3D 0;
> +       if (mas->sheaf)
> +               mt_return_sheaf(mas->sheaf);
>
> -       mas->alloc =3D NULL;
> +       mas->sheaf =3D NULL;
>  }
>  EXPORT_SYMBOL_GPL(mas_destroy);
>
> @@ -5640,7 +5437,8 @@ int mas_expected_entries(struct ma_state *mas, unsi=
gned long nr_entries)
>         /* Internal nodes */
>         nr_nodes +=3D DIV_ROUND_UP(nr_nodes, nonleaf_cap);
>         /* Add working room for split (2 nodes) + new parents */
> -       mas_node_count_gfp(mas, nr_nodes + 3, GFP_KERNEL);
> +       mas->node_request =3D nr_nodes + 3;
> +       mas_alloc_nodes(mas, GFP_KERNEL);
>
>         /* Detect if allocations run out */
>         mas->mas_flags |=3D MA_STATE_PREALLOC;
> @@ -6276,7 +6074,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>                 mas_alloc_nodes(mas, gfp);
>         }
>
> -       if (!mas_allocated(mas))
> +       if (!mas->sheaf)
>                 return false;
>
>         mas->status =3D ma_start;
> @@ -7671,8 +7469,9 @@ void mas_dump(const struct ma_state *mas)
>
>         pr_err("[%u/%u] index=3D%lx last=3D%lx\n", mas->offset, mas->end,
>                mas->index, mas->last);
> -       pr_err("     min=3D%lx max=3D%lx alloc=3D" PTR_FMT ", depth=3D%u,=
 flags=3D%x\n",
> -              mas->min, mas->max, mas->alloc, mas->depth, mas->mas_flags=
);
> +       pr_err("     min=3D%lx max=3D%lx sheaf=3D" PTR_FMT ", request %lu=
 depth=3D%u, flags=3D%x\n",
> +              mas->min, mas->max, mas->sheaf, mas->node_request, mas->de=
pth,
> +              mas->mas_flags);
>         if (mas->index > mas->last)
>                 pr_err("Check index & last\n");
>  }
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index 13e2a10d7554d6b1de5ffbda59f3a5bc4039a8c8..5549eb4200c7974e3bb457e0f=
d054c434e4b85da 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -2746,6 +2746,7 @@ static noinline void __init check_fuzzer(struct map=
le_tree *mt)
>         mtree_test_erase(mt, ULONG_MAX - 10);
>  }
>
> +#if 0
>  /* duplicate the tree with a specific gap */
>  static noinline void __init check_dup_gaps(struct maple_tree *mt,
>                                     unsigned long nr_entries, bool zero_s=
tart,
> @@ -2770,6 +2771,7 @@ static noinline void __init check_dup_gaps(struct m=
aple_tree *mt,
>                 mtree_store_range(mt, i*10, (i+1)*10 - gap,
>                                   xa_mk_value(i), GFP_KERNEL);
>
> +       mt_dump(mt, mt_dump_dec);
>         mt_init_flags(&newmt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN=
);
>         mt_set_non_kernel(99999);
>         down_write(&newmt_lock);
> @@ -2779,9 +2781,12 @@ static noinline void __init check_dup_gaps(struct =
maple_tree *mt,
>
>         rcu_read_lock();
>         mas_for_each(&mas, tmp, ULONG_MAX) {
> +               printk("%lu nodes %lu\n", mas.index,
> +                      kmem_cache_sheaf_count(newmas.sheaf));
>                 newmas.index =3D mas.index;
>                 newmas.last =3D mas.last;
>                 mas_store(&newmas, tmp);
> +               mt_dump(&newmt, mt_dump_dec);
>         }
>         rcu_read_unlock();
>         mas_destroy(&newmas);
> @@ -2878,6 +2883,7 @@ static noinline void __init check_dup(struct maple_=
tree *mt)
>                 cond_resched();
>         }
>  }
> +#endif
>
>  static noinline void __init check_bnode_min_spanning(struct maple_tree *=
mt)
>  {
> @@ -4045,9 +4051,11 @@ static int __init maple_tree_seed(void)
>         check_fuzzer(&tree);
>         mtree_destroy(&tree);
>
> +#if 0
>         mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
>         check_dup(&tree);
>         mtree_destroy(&tree);
> +#endif
>
>         mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
>         check_bnode_min_spanning(&tree);
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/=
maple.c
> index f6f923c9dc1039997953a94ec184c560b225c2d4..1bd789191f232385d69f2dd3e=
900bac99d8919ff 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -63,430 +63,6 @@ struct rcu_reader_struct {
>         struct rcu_test_struct2 *test;
>  };
>
> -static int get_alloc_node_count(struct ma_state *mas)
> -{
> -       int count =3D 1;
> -       struct maple_alloc *node =3D mas->alloc;
> -
> -       if (!node || ((unsigned long)node & 0x1))
> -               return 0;
> -       while (node->node_count) {
> -               count +=3D node->node_count;
> -               node =3D node->slot[0];
> -       }
> -       return count;
> -}
> -
> -static void check_mas_alloc_node_count(struct ma_state *mas)
> -{
> -       mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 1, GFP_KERNEL);
> -       mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 3, GFP_KERNEL);
> -       MT_BUG_ON(mas->tree, get_alloc_node_count(mas) !=3D mas->alloc->t=
otal);
> -       mas_destroy(mas);
> -}
> -
> -/*
> - * check_new_node() - Check the creation of new nodes and error path
> - * verification.
> - */
> -static noinline void __init check_new_node(struct maple_tree *mt)
> -{
> -
> -       struct maple_node *mn, *mn2, *mn3;
> -       struct maple_alloc *smn;
> -       struct maple_node *nodes[100];
> -       int i, j, total;
> -
> -       MA_STATE(mas, mt, 0, 0);
> -
> -       check_mas_alloc_node_count(&mas);
> -
> -       /* Try allocating 3 nodes */
> -       mtree_lock(mt);
> -       mt_set_non_kernel(0);
> -       /* request 3 nodes to be allocated. */
> -       mas_node_count(&mas, 3);
> -       /* Allocation request of 3. */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 3);
> -       /* Allocate failed. */
> -       MT_BUG_ON(mt, mas.node !=3D MA_ERROR(-ENOMEM));
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 3);
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       MT_BUG_ON(mt, mn =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc->slot[0] =3D=3D NULL);
> -       mas_push_node(&mas, mn);
> -       mas_reset(&mas);
> -       mas_destroy(&mas);
> -       mtree_unlock(mt);
> -
> -
> -       /* Try allocating 1 node, then 2 more */
> -       mtree_lock(mt);
> -       /* Set allocation request to 1. */
> -       mas_set_alloc_req(&mas, 1);
> -       /* Check Allocation request of 1. */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 1);
> -       mas_set_err(&mas, -ENOMEM);
> -       /* Validate allocation request. */
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       /* Eat the requested node. */
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       MT_BUG_ON(mt, mn =3D=3D NULL);
> -       MT_BUG_ON(mt, mn->slot[0] !=3D NULL);
> -       MT_BUG_ON(mt, mn->slot[1] !=3D NULL);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -
> -       mn->parent =3D ma_parent_ptr(mn);
> -       ma_free_rcu(mn);
> -       mas.status =3D ma_start;
> -       mas_destroy(&mas);
> -       /* Allocate 3 nodes, will fail. */
> -       mas_node_count(&mas, 3);
> -       /* Drop the lock and allocate 3 nodes. */
> -       mas_nomem(&mas, GFP_KERNEL);
> -       /* Ensure 3 are allocated. */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 3);
> -       /* Allocation request of 0. */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 0);
> -
> -       MT_BUG_ON(mt, mas.alloc =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc->slot[0] =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc->slot[1] =3D=3D NULL);
> -       /* Ensure we counted 3. */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 3);
> -       /* Free. */
> -       mas_reset(&mas);
> -       mas_destroy(&mas);
> -
> -       /* Set allocation request to 1. */
> -       mas_set_alloc_req(&mas, 1);
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 1);
> -       mas_set_err(&mas, -ENOMEM);
> -       /* Validate allocation request. */
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 1);
> -       /* Check the node is only one node. */
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -       MT_BUG_ON(mt, mn =3D=3D NULL);
> -       MT_BUG_ON(mt, mn->slot[0] !=3D NULL);
> -       MT_BUG_ON(mt, mn->slot[1] !=3D NULL);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -       mas_push_node(&mas, mn);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 1);
> -       MT_BUG_ON(mt, mas.alloc->node_count);
> -
> -       mas_set_alloc_req(&mas, 2); /* request 2 more. */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 2);
> -       mas_set_err(&mas, -ENOMEM);
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 3);
> -       MT_BUG_ON(mt, mas.alloc =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc->slot[0] =3D=3D NULL);
> -       MT_BUG_ON(mt, mas.alloc->slot[1] =3D=3D NULL);
> -       for (i =3D 2; i >=3D 0; i--) {
> -               mn =3D mas_pop_node(&mas);
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D i);
> -               MT_BUG_ON(mt, !mn);
> -               MT_BUG_ON(mt, not_empty(mn));
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -       }
> -
> -       total =3D 64;
> -       mas_set_alloc_req(&mas, total); /* request 2 more. */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D total);
> -       mas_set_err(&mas, -ENOMEM);
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       for (i =3D total; i > 0; i--) {
> -               unsigned int e =3D 0; /* expected node_count */
> -
> -               if (!MAPLE_32BIT) {
> -                       if (i >=3D 35)
> -                               e =3D i - 34;
> -                       else if (i >=3D 5)
> -                               e =3D i - 4;
> -                       else if (i >=3D 2)
> -                               e =3D i - 1;
> -               } else {
> -                       if (i >=3D 4)
> -                               e =3D i - 3;
> -                       else if (i >=3D 1)
> -                               e =3D i - 1;
> -                       else
> -                               e =3D 0;
> -               }
> -
> -               MT_BUG_ON(mt, mas.alloc->node_count !=3D e);
> -               mn =3D mas_pop_node(&mas);
> -               MT_BUG_ON(mt, not_empty(mn));
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - 1);
> -               MT_BUG_ON(mt, !mn);
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -       }
> -
> -       total =3D 100;
> -       for (i =3D 1; i < total; i++) {
> -               mas_set_alloc_req(&mas, i);
> -               mas_set_err(&mas, -ENOMEM);
> -               MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -               for (j =3D i; j > 0; j--) {
> -                       mn =3D mas_pop_node(&mas);
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D j - 1);
> -                       MT_BUG_ON(mt, !mn);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       mas_push_node(&mas, mn);
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D j);
> -                       mn =3D mas_pop_node(&mas);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D j - 1);
> -                       mn->parent =3D ma_parent_ptr(mn);
> -                       ma_free_rcu(mn);
> -               }
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -
> -               mas_set_alloc_req(&mas, i);
> -               mas_set_err(&mas, -ENOMEM);
> -               MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -               for (j =3D 0; j <=3D i/2; j++) {
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j);
> -                       nodes[j] =3D mas_pop_node(&mas);
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j - 1)=
;
> -               }
> -
> -               while (j) {
> -                       j--;
> -                       mas_push_node(&mas, nodes[j]);
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j);
> -               }
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D i);
> -               for (j =3D 0; j <=3D i/2; j++) {
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j);
> -                       mn =3D mas_pop_node(&mas);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       mn->parent =3D ma_parent_ptr(mn);
> -                       ma_free_rcu(mn);
> -                       MT_BUG_ON(mt, mas_allocated(&mas) !=3D i - j - 1)=
;
> -               }
> -               mas_reset(&mas);
> -               MT_BUG_ON(mt, mas_nomem(&mas, GFP_KERNEL));
> -               mas_destroy(&mas);
> -
> -       }
> -
> -       /* Set allocation request. */
> -       total =3D 500;
> -       mas_node_count(&mas, total);
> -       /* Drop the lock and allocate the nodes. */
> -       mas_nomem(&mas, GFP_KERNEL);
> -       MT_BUG_ON(mt, !mas.alloc);
> -       i =3D 1;
> -       smn =3D mas.alloc;
> -       while (i < total) {
> -               for (j =3D 0; j < MAPLE_ALLOC_SLOTS; j++) {
> -                       i++;
> -                       MT_BUG_ON(mt, !smn->slot[j]);
> -                       if (i =3D=3D total)
> -                               break;
> -               }
> -               smn =3D smn->slot[0]; /* next. */
> -       }
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D total);
> -       mas_reset(&mas);
> -       mas_destroy(&mas); /* Free. */
> -
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -       for (i =3D 1; i < 128; i++) {
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D i); /* check reque=
st filled */
> -               for (j =3D i; j > 0; j--) { /*Free the requests */
> -                       mn =3D mas_pop_node(&mas); /* get the next node. =
*/
> -                       MT_BUG_ON(mt, mn =3D=3D NULL);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       mn->parent =3D ma_parent_ptr(mn);
> -                       ma_free_rcu(mn);
> -               }
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -       }
> -
> -       for (i =3D 1; i < MAPLE_NODE_MASK + 1; i++) {
> -               MA_STATE(mas2, mt, 0, 0);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D i); /* check reque=
st filled */
> -               for (j =3D 1; j <=3D i; j++) { /* Move the allocations to=
 mas2 */
> -                       mn =3D mas_pop_node(&mas); /* get the next node. =
*/
> -                       MT_BUG_ON(mt, mn =3D=3D NULL);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       mas_push_node(&mas2, mn);
> -                       MT_BUG_ON(mt, mas_allocated(&mas2) !=3D j);
> -               }
> -               MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -               MT_BUG_ON(mt, mas_allocated(&mas2) !=3D i);
> -
> -               for (j =3D i; j > 0; j--) { /*Free the requests */
> -                       MT_BUG_ON(mt, mas_allocated(&mas2) !=3D j);
> -                       mn =3D mas_pop_node(&mas2); /* get the next node.=
 */
> -                       MT_BUG_ON(mt, mn =3D=3D NULL);
> -                       MT_BUG_ON(mt, not_empty(mn));
> -                       mn->parent =3D ma_parent_ptr(mn);
> -                       ma_free_rcu(mn);
> -               }
> -               MT_BUG_ON(mt, mas_allocated(&mas2) !=3D 0);
> -       }
> -
> -
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 1); /* Request */
> -       MT_BUG_ON(mt, mas.node !=3D MA_ERROR(-ENOMEM));
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 1);
> -       MT_BUG_ON(mt, mas.alloc->node_count !=3D MAPLE_ALLOC_SLOTS);
> -
> -       mn =3D mas_pop_node(&mas); /* get the next node. */
> -       MT_BUG_ON(mt, mn =3D=3D NULL);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS);
> -       MT_BUG_ON(mt, mas.alloc->node_count !=3D MAPLE_ALLOC_SLOTS - 1);
> -
> -       mas_push_node(&mas, mn);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 1);
> -       MT_BUG_ON(mt, mas.alloc->node_count !=3D MAPLE_ALLOC_SLOTS);
> -
> -       /* Check the limit of pop/push/pop */
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 2); /* Request */
> -       MT_BUG_ON(mt, mas_alloc_req(&mas) !=3D 1);
> -       MT_BUG_ON(mt, mas.node !=3D MA_ERROR(-ENOMEM));
> -       MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
> -       MT_BUG_ON(mt, mas_alloc_req(&mas));
> -       MT_BUG_ON(mt, mas.alloc->node_count !=3D 1);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 2);
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 1);
> -       MT_BUG_ON(mt, mas.alloc->node_count  !=3D MAPLE_ALLOC_SLOTS);
> -       mas_push_node(&mas, mn);
> -       MT_BUG_ON(mt, mas.alloc->node_count !=3D 1);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 2);
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, not_empty(mn));
> -       mn->parent =3D ma_parent_ptr(mn);
> -       ma_free_rcu(mn);
> -       for (i =3D 1; i <=3D MAPLE_ALLOC_SLOTS + 1; i++) {
> -               mn =3D mas_pop_node(&mas);
> -               MT_BUG_ON(mt, not_empty(mn));
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -       }
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 0);
> -
> -
> -       for (i =3D 3; i < MAPLE_NODE_MASK * 3; i++) {
> -               mas.node =3D MA_ERROR(-ENOMEM);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mas_push_node(&mas, mn); /* put it back */
> -               mas_destroy(&mas);
> -
> -               mas.node =3D MA_ERROR(-ENOMEM);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn2 =3D mas_pop_node(&mas); /* get the next node. */
> -               mas_push_node(&mas, mn); /* put them back */
> -               mas_push_node(&mas, mn2);
> -               mas_destroy(&mas);
> -
> -               mas.node =3D MA_ERROR(-ENOMEM);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn2 =3D mas_pop_node(&mas); /* get the next node. */
> -               mn3 =3D mas_pop_node(&mas); /* get the next node. */
> -               mas_push_node(&mas, mn); /* put them back */
> -               mas_push_node(&mas, mn2);
> -               mas_push_node(&mas, mn3);
> -               mas_destroy(&mas);
> -
> -               mas.node =3D MA_ERROR(-ENOMEM);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -               mas_destroy(&mas);
> -
> -               mas.node =3D MA_ERROR(-ENOMEM);
> -               mas_node_count(&mas, i); /* Request */
> -               mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -               mn =3D mas_pop_node(&mas); /* get the next node. */
> -               mn->parent =3D ma_parent_ptr(mn);
> -               ma_free_rcu(mn);
> -               mas_destroy(&mas);
> -       }
> -
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, 5); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 5);
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, 10); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       mas.status =3D ma_start;
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 10);
> -       mas_destroy(&mas);
> -
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS - 1); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS - 1);
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, 10 + MAPLE_ALLOC_SLOTS - 1); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       mas.status =3D ma_start;
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D 10 + MAPLE_ALLOC_SLOTS - 1=
);
> -       mas_destroy(&mas);
> -
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 1); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS + 1);
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 2); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       mas.status =3D ma_start;
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS * 2 + 2)=
;
> -       mas_destroy(&mas);
> -
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 1); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS * 2 + 1)=
;
> -       mas.node =3D MA_ERROR(-ENOMEM);
> -       mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 3 + 2); /* Request */
> -       mas_nomem(&mas, GFP_KERNEL); /* Fill request */
> -       mas.status =3D ma_start;
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D MAPLE_ALLOC_SLOTS * 3 + 2)=
;
> -       mas_destroy(&mas);
> -
> -       mtree_unlock(mt);
> -}
> -
>  /*
>   * Check erasing including RCU.
>   */
> @@ -35458,8 +35034,7 @@ static void check_dfs_preorder(struct maple_tree =
*mt)
>         mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
>         mas_reset(&mas);
>         mt_zero_nr_tallocated();
> -       mt_set_non_kernel(200);
> -       mas_expected_entries(&mas, max);
> +       mt_set_non_kernel(1000);
>         for (count =3D 0; count <=3D max; count++) {
>                 mas.index =3D mas.last =3D count;
>                 mas_store(&mas, xa_mk_value(count));
> @@ -35524,6 +35099,13 @@ static unsigned char get_vacant_height(struct ma=
_wr_state *wr_mas, void *entry)
>         return vacant_height;
>  }
>
> +static int mas_allocated(struct ma_state *mas)
> +{
> +       if (mas->sheaf)
> +               return kmem_cache_sheaf_size(mas->sheaf);
> +
> +       return 0;
> +}
>  /* Preallocation testing */
>  static noinline void __init check_prealloc(struct maple_tree *mt)
>  {
> @@ -35533,8 +35115,8 @@ static noinline void __init check_prealloc(struct=
 maple_tree *mt)
>         unsigned char vacant_height;
>         struct maple_node *mn;
>         void *ptr =3D check_prealloc;
> +       struct ma_wr_state wr_mas;
>         MA_STATE(mas, mt, 10, 20);
> -       MA_WR_STATE(wr_mas, &mas, ptr);
>
>         mt_set_non_kernel(1000);
>         for (i =3D 0; i <=3D max; i++)
> @@ -35542,7 +35124,11 @@ static noinline void __init check_prealloc(struc=
t maple_tree *mt)
>
>         /* Spanning store */
>         mas_set_range(&mas, 470, 500);
> -       MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) !=3D 0);
> +       wr_mas.mas =3D &mas;
> +
> +       mas_wr_preallocate(&wr_mas, ptr);
> +       MT_BUG_ON(mt, mas.store_type !=3D wr_spanning_store);
> +       MT_BUG_ON(mt, mas_is_err(&mas));
>         allocated =3D mas_allocated(&mas);
>         height =3D mas_mt_height(&mas);
>         vacant_height =3D get_vacant_height(&wr_mas, ptr);
> @@ -35552,6 +35138,7 @@ static noinline void __init check_prealloc(struct=
 maple_tree *mt)
>         allocated =3D mas_allocated(&mas);
>         MT_BUG_ON(mt, allocated !=3D 0);
>
> +       mas_wr_preallocate(&wr_mas, ptr);
>         MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) !=3D 0);
>         allocated =3D mas_allocated(&mas);
>         height =3D mas_mt_height(&mas);
> @@ -35592,20 +35179,6 @@ static noinline void __init check_prealloc(struc=
t maple_tree *mt)
>         mn->parent =3D ma_parent_ptr(mn);
>         ma_free_rcu(mn);
>
> -       MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) !=3D 0);
> -       allocated =3D mas_allocated(&mas);
> -       height =3D mas_mt_height(&mas);
> -       vacant_height =3D get_vacant_height(&wr_mas, ptr);
> -       MT_BUG_ON(mt, allocated !=3D 1 + (height - vacant_height) * 3);
> -       mn =3D mas_pop_node(&mas);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D allocated - 1);
> -       mas_push_node(&mas, mn);
> -       MT_BUG_ON(mt, mas_allocated(&mas) !=3D allocated);
> -       MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) !=3D 0);
> -       mas_destroy(&mas);
> -       allocated =3D mas_allocated(&mas);
> -       MT_BUG_ON(mt, allocated !=3D 0);
> -
>         MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) !=3D 0);
>         allocated =3D mas_allocated(&mas);
>         height =3D mas_mt_height(&mas);
> @@ -36394,11 +35967,17 @@ static void check_nomem_writer_race(struct mapl=
e_tree *mt)
>         check_load(mt, 6, xa_mk_value(0xC));
>         mtree_unlock(mt);
>
> +       mt_set_non_kernel(0);
>         /* test for the same race but with mas_store_gfp() */
>         mtree_store_range(mt, 0, 5, xa_mk_value(0xA), GFP_KERNEL);
>         mtree_store_range(mt, 6, 10, NULL, GFP_KERNEL);
>
>         mas_set_range(&mas, 0, 5);
> +
> +       /* setup writer 2 that will trigger the race condition */
> +       mt_set_private(mt);
> +       mt_set_callback(writer2);
> +
>         mtree_lock(mt);
>         mas_store_gfp(&mas, NULL, GFP_KERNEL);
>
> @@ -36435,7 +36014,6 @@ static inline int check_vma_modification(struct m=
aple_tree *mt)
>         __mas_set_range(&mas, 0x7ffde4ca2000, 0x7ffffffff000 - 1);
>         mas_preallocate(&mas, NULL, GFP_KERNEL);
>         mas_store_prealloc(&mas, NULL);
> -       mt_dump(mt, mt_dump_hex);
>
>         mas_destroy(&mas);
>         mtree_unlock(mt);
> @@ -36453,6 +36031,8 @@ static inline void check_bulk_rebalance(struct ma=
ple_tree *mt)
>
>         build_full_tree(mt, 0, 2);
>
> +
> +       mtree_lock(mt);
>         /* erase every entry in the tree */
>         do {
>                 /* set up bulk store mode */
> @@ -36462,6 +36042,85 @@ static inline void check_bulk_rebalance(struct m=
aple_tree *mt)
>         } while (mas_prev(&mas, 0) !=3D NULL);
>
>         mas_destroy(&mas);
> +       mtree_unlock(mt);
> +}
> +
> +static unsigned long get_last_index(struct ma_state *mas)
> +{
> +       struct maple_node *node =3D mas_mn(mas);
> +       enum maple_type mt =3D mte_node_type(mas->node);
> +       unsigned long *pivots =3D ma_pivots(node, mt);
> +       unsigned long last_index =3D mas_data_end(mas);
> +
> +       BUG_ON(last_index =3D=3D 0);
> +
> +       return pivots[last_index - 1] + 1;
> +}
> +
> +/*
> + * Assert that we handle spanning stores that consume the entirety of th=
e right
> + * leaf node correctly.
> + */
> +static void test_spanning_store_regression(void)
> +{
> +       unsigned long from =3D 0, to =3D 0;
> +       DEFINE_MTREE(tree);
> +       MA_STATE(mas, &tree, 0, 0);
> +
> +       /*
> +        * Build a 3-level tree. We require a parent node below the root =
node
> +        * and 2 leaf nodes under it, so we can span the entirety of the =
right
> +        * hand node.
> +        */
> +       build_full_tree(&tree, 0, 3);
> +
> +       /* Descend into position at depth 2. */
> +       mas_reset(&mas);
> +       mas_start(&mas);
> +       mas_descend(&mas);
> +       mas_descend(&mas);
> +
> +       /*
> +        * We need to establish a tree like the below.
> +        *
> +        * Then we can try a store in [from, to] which results in a spann=
ed
> +        * store across nodes B and C, with the maple state at the time o=
f the
> +        * write being such that only the subtree at A and below is consi=
dered.
> +        *
> +        * Height
> +        *  0                              Root Node
> +        *                                  /      \
> +        *                    pivot =3D to   /        \ pivot =3D ULONG_M=
AX
> +        *                                /          \
> +        *   1                       A [-----]       ...
> +        *                              /   \
> +        *                pivot =3D from /     \ pivot =3D to
> +        *                            /       \
> +        *   2 (LEAVES)          B [-----]  [-----] C
> +        *                                       ^--- Last pivot to.
> +        */
> +       while (true) {
> +               unsigned long tmp =3D get_last_index(&mas);
> +
> +               if (mas_next_sibling(&mas)) {
> +                       from =3D tmp;
> +                       to =3D mas.max;
> +               } else {
> +                       break;
> +               }
> +       }
> +
> +       BUG_ON(from =3D=3D 0 && to =3D=3D 0);
> +
> +       /* Perform the store. */
> +       mas_set_range(&mas, from, to);
> +       mas_store_gfp(&mas, xa_mk_value(0xdead), GFP_KERNEL);
> +
> +       /* If the regression occurs, the validation will fail. */
> +       mt_validate(&tree);
> +
> +       /* Cleanup. */
> +       __mt_destroy(&tree);
>  }
>
>  void farmer_tests(void)
> @@ -36525,6 +36184,7 @@ void farmer_tests(void)
>         check_collapsing_rebalance(&tree);
>         mtree_destroy(&tree);
>
> +
>         mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
>         check_null_expand(&tree);
>         mtree_destroy(&tree);
> @@ -36538,10 +36198,6 @@ void farmer_tests(void)
>         check_erase_testset(&tree);
>         mtree_destroy(&tree);
>
> -       mt_init_flags(&tree, 0);
> -       check_new_node(&tree);
> -       mtree_destroy(&tree);
> -
>         if (!MAPLE_32BIT) {
>                 mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
>                 check_rcu_simulated(&tree);
> @@ -36563,95 +36219,13 @@ void farmer_tests(void)
>
>         /* No memory handling */
>         check_nomem(&tree);
> -}
> -
> -static unsigned long get_last_index(struct ma_state *mas)
> -{
> -       struct maple_node *node =3D mas_mn(mas);
> -       enum maple_type mt =3D mte_node_type(mas->node);
> -       unsigned long *pivots =3D ma_pivots(node, mt);
> -       unsigned long last_index =3D mas_data_end(mas);
> -
> -       BUG_ON(last_index =3D=3D 0);
>
> -       return pivots[last_index - 1] + 1;
> -}
> -
> -/*
> - * Assert that we handle spanning stores that consume the entirety of th=
e right
> - * leaf node correctly.
> - */
> -static void test_spanning_store_regression(void)
> -{
> -       unsigned long from =3D 0, to =3D 0;
> -       DEFINE_MTREE(tree);
> -       MA_STATE(mas, &tree, 0, 0);
> -
> -       /*
> -        * Build a 3-level tree. We require a parent node below the root =
node
> -        * and 2 leaf nodes under it, so we can span the entirety of the =
right
> -        * hand node.
> -        */
> -       build_full_tree(&tree, 0, 3);
> -
> -       /* Descend into position at depth 2. */
> -       mas_reset(&mas);
> -       mas_start(&mas);
> -       mas_descend(&mas);
> -       mas_descend(&mas);
> -
> -       /*
> -        * We need to establish a tree like the below.
> -        *
> -        * Then we can try a store in [from, to] which results in a spann=
ed
> -        * store across nodes B and C, with the maple state at the time o=
f the
> -        * write being such that only the subtree at A and below is consi=
dered.
> -        *
> -        * Height
> -        *  0                              Root Node
> -        *                                  /      \
> -        *                    pivot =3D to   /        \ pivot =3D ULONG_M=
AX
> -        *                                /          \
> -        *   1                       A [-----]       ...
> -        *                              /   \
> -        *                pivot =3D from /     \ pivot =3D to
> -        *                            /       \
> -        *   2 (LEAVES)          B [-----]  [-----] C
> -        *                                       ^--- Last pivot to.
> -        */
> -       while (true) {
> -               unsigned long tmp =3D get_last_index(&mas);
> -
> -               if (mas_next_sibling(&mas)) {
> -                       from =3D tmp;
> -                       to =3D mas.max;
> -               } else {
> -                       break;
> -               }
> -       }
> -
> -       BUG_ON(from =3D=3D 0 && to =3D=3D 0);
> -
> -       /* Perform the store. */
> -       mas_set_range(&mas, from, to);
> -       mas_store_gfp(&mas, xa_mk_value(0xdead), GFP_KERNEL);
> -
> -       /* If the regression occurs, the validation will fail. */
> -       mt_validate(&tree);
> -
> -       /* Cleanup. */
> -       __mt_destroy(&tree);
> -}
> -
> -static void regression_tests(void)
> -{
>         test_spanning_store_regression();
>  }
>
>  void maple_tree_tests(void)
>  {
>  #if !defined(BENCH)
> -       regression_tests();
>         farmer_tests();
>  #endif
>         maple_tree_seed();
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index e0255f53159bd3a1325d49192283dd6790a5e3b8..6a15665fc8315168c718e6810=
c7deaeed13a3a6a 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -82,7 +82,8 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, s=
truct list_lru *lru,
>
>         if (!(gfp & __GFP_DIRECT_RECLAIM)) {
>                 if (!cachep->non_kernel) {
> -                       cachep->exec_callback =3D true;
> +                       if (cachep->callback)
> +                               cachep->exec_callback =3D true;
>                         return NULL;
>                 }
>
> @@ -236,6 +237,8 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, =
gfp_t gfp, size_t size,
>                 for (i =3D 0; i < size; i++)
>                         __kmem_cache_free_locked(cachep, p[i]);
>                 pthread_mutex_unlock(&cachep->lock);
> +               if (cachep->callback)
> +                       cachep->exec_callback =3D true;
>                 return 0;
>         }
>
> @@ -288,9 +291,8 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t =
gfp, unsigned int size)
>                 capacity =3D s->sheaf_capacity;
>
>         sheaf =3D malloc(sizeof(*sheaf) + sizeof(void *) * s->sheaf_capac=
ity * capacity);
> -       if (!sheaf) {
> +       if (!sheaf)
>                 return NULL;
> -       }
>
>         memset(sheaf, 0, size);
>         sheaf->cache =3D s;
>
> --
> 2.50.1
>

