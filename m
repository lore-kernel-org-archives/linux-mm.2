Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E33CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 20:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9843A6B00B0; Fri, 22 Aug 2025 16:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C826B00B1; Fri, 22 Aug 2025 16:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899C96B00B2; Fri, 22 Aug 2025 16:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDEA6B00B0
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:25:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 534A71A0348
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:25:45 +0000 (UTC)
X-FDA: 83805524250.10.9105807
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 766DF4000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:25:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lep1CuK4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755894343; a=rsa-sha256;
	cv=none;
	b=I2o1RmCL5IKfO2ddTtIFYgCuAVGs6K6oc9RM5QI46MA3WV9Yv8pYtTAT82tuOXa+BJ0/eq
	CCoMAtMHL0b+im9LQy2uHKqA8juWdqEBUOLMduVbzp5NZ7NV5h8+7ZChp0qgyMNAFaJr4m
	BDRkxmVS+NFVDkaEyFjDIw/6JyGoQM4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lep1CuK4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755894343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnLeUyDCv69RBYB1LT6B3iM9eFzgxTxAmCOD+3zz5xw=;
	b=pEqRM+cLqf7HFD4EkTn7twAM1TejNC54VrxPaHP1RqCC1rJB0HVUkIb/odpoU5lt6k+r5/
	5tgjxZX9h/BqF6ee5KVLk665eN7AvrwFCtKz6rxg/MkvyNwyBqPhISRkHmrDiEvSZoiLoE
	Gu9h2VKbyNMuz6AFutIv6S5DWE7RpcQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso67861cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755894342; x=1756499142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnLeUyDCv69RBYB1LT6B3iM9eFzgxTxAmCOD+3zz5xw=;
        b=lep1CuK47CLFtqpmGEoXqsIiafIZpioTIf7YAJSU+ANyxeFCPXjNyfr19gaxWvwqz6
         Xl0XAQwnJ1fbDcOXY7LyHRjOG40Xc37C7j8GMTH0R7H8CxAukpPlIygwoRlYpHompgrp
         3PKKDFDVSWpAVHH1OmikdPqIklxin4S6Wc2jI+ka7tEWjX7BopNtLQqo7lQuebTPC25d
         2QopFEcJWPiuJPO78hNC/rgVc93jhAvNWlWkVn64uM4CNYoAwZTwvapCEW1URxLzxsbr
         TNAYcKwympNltgY6sLoyvqwS479WYs9HhRYuJBfJwvOuOwG+h0GsdW6GZcwRDJmx3WA7
         wuyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755894342; x=1756499142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnLeUyDCv69RBYB1LT6B3iM9eFzgxTxAmCOD+3zz5xw=;
        b=CHH5Rru9Y9goWKMhckjt+2To2BRh6oU4qF/uO1SFDKISjLv0oxuie6MAb4kHICLSCJ
         PtEVRabR1AaWyGfQLbmi44j6MtojXNMwwzgyOXI+vJMSpptulOkYBiwbXgjwM4Zohil6
         JQbDCzOp0GAUEexlCLG91jG/DphnNbkxe/kYAv++1fLS5RzdTAv9YzMAKXyOtOJRkuJi
         ru0alapHW8q7Ll4zFTSod6zEvpjd5Q3p0yE41Agpzr4lWuLcK9X2BV71jDEhaSj8zz1k
         2xRAQSZg9YKhlitHeuG/6wo59f2ymXU7w5WvNzQGg0Y+0Ewb5M9+psGEkzdyZ4cpyaMh
         G0Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVuwuEkqUUUR7LXXX6TWFxgFx+boIJMZ5jEuQnFcjbDEmCvxDfpd7shb0PDwM7mZZbdvmsVlLGMWA==@kvack.org
X-Gm-Message-State: AOJu0YymT3lM1AsWdKHgeP6NSKzCjeryR/CNhQJLA/Eu+1B4h8z8ecjL
	dzBjETfwy65gCedZd4uBHwLBj9tqhEncAcHlfno790kSpoHm1F1n2lD/g+8XLyAqaID2QFGfbTe
	lha8bxt8UMFSLX7HdnyRpoJYc/LYYjcK0Htf4EsG7
X-Gm-Gg: ASbGncvgK2X7SemZMtTa1C27Fon8Oq9GUo1BKI4JppxEag6ix0HmqIJFHpQyDggZlkA
	Qpl/gR0PxYx3yYr+5s8LL2xbeK1lN6KOh5KMrbn1FroEkJdYEYIaUnbqHm1sNzH4qxyKdS/VtlM
	pOIQkWlyrNDAGIO+rY8HDiKa0uX37LULyy3j8yzIjnT6FOyrJQKykaTHC4J0qnQv2+EpGGuJBR6
	MIXd0Jdigd6
X-Google-Smtp-Source: AGHT+IHpcbSNYEbG4dMf2Ur+EvgyoAGIN6Q8D39CISAhHgiGDM6Pv/YSxa4huZIle8BMgUbZsNIx8jQJ2T56bctuf1U=
X-Received: by 2002:ac8:5885:0:b0:4b2:9b79:e700 with SMTP id
 d75a77b69052e-4b2ba6f09bdmr904771cf.4.1755894342112; Fri, 22 Aug 2025
 13:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-13-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-13-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 13:25:31 -0700
X-Gm-Features: Ac12FXwIfUzsXFwXr2_zQQKQgHFazg_c-46Y0QfxCWOo6vu0LHzTb5q0mxFp2Dg
Message-ID: <CAJuCfpEjaw+4Ay-Yx=unHev+M4M9FmNmz_PSYmtsFn3EToLBxg@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] maple_tree: Add single node allocation support
 to maple state
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 766DF4000F
X-Stat-Signature: uqqrzm8kxs8apjkikzago714ong3gnzu
X-HE-Tag: 1755894343-185783
X-HE-Meta: U2FsdGVkX18/lC2BTTBQHkrNTb0BB1V5AtM9st/eht5PXkCI5FuR3PNWK5Vlfcp/8d7Nvc03yLCdsIp8d2aHoZ8qzsm1Ew+ZYESYh8eao8GQ77hVEwOIndh6ZftiaJwijaq4U+0MkvcYOxm0Eaw4qvErpe5aH8A49NdQfIpxFv3ImrEvfC0TtbBUXj3kagcPy8TXMsZC6SR/yPbqZ/VmF+RKTzol5e+kJBKxcMB11DEZOf+DjsCLr8Ka6DE/vFOMwHQIvV6onwIyB2fLYP49hiX1W2KbTHV0Ixn3JYOHLCp9fa/TC4f12Y4HkoGifU/lNX5QX6PvyobEPGj4NqbzUNvbtTkj61XWhpTDz/UmyFLMOYqzV3BXd4FY/d7r7Av1vvSTHDfsbKqmKl1cJ0sORIyp+yDGrcAtHXApyGMPY3sZrHO5ySuC+WNAXCNcy8Ho1YDfGUoCrmCexZmPSJnzUJ2cfe0vBAe4iyE7/9p4TaSCFT33oPHmNhjfw7JoDGlGc89IzOzPgNtJnDKgBwGNkBYULhbiIs1QC53NYseRIE7T29vrZSA9lYyfnFKNBrBQo0XMaQIr1MfEOUvwmyFDxlgR1/d8h7rW/kBwc2hHszK0+/Bfp4f3irzzyIWNNTy1XHZtuVUy20YyKY4+p2S8DstkMpi7PGAWfwOyeIfrp26bQHxA7AnN/3YAmh4wXoGG3HZM/2YMjcBisa4kqPE56R83aKVj1Cj23BfT3lj3f0N/L9l4LXQfGShZ0WR+X5Rc2jDn0dwqX2UKLZ3yDbpETg5vf513MCyQAjKdT7OFy/CWmknCAEcX+LNqFNYkI+GN/pgLZybY1Sigq66rUidZbFJdBp3eE4Fbnt6jfyDgMfBTz0ikW3KoBxtT1w1esmu/4ggr6S/mOgKj89FWoXrlHKlMlmM2DO6HYw8v2T8X2O0pPfysN/POs1HrwM27jBjl4+oKNfBg2UOOyA2e4A0
 WimI5tXz
 EwPJfZ7tcxW8rhJh/3PdocDR/rFT1YiA3xR2msW2VfmiiAZ33NoC4sPskWm7wNECfMdwuSysEtwYQ6k7awn3TKAb4bjpri0EjaszMqA+XcdMTV4D9B1pOpnZG9MPOI9oeg/85etlfE88HsQrt8ShOekeoG5TubiCZDV7yf+k2uWWKO+4WvVBe1eF1b5EDQq81OLllG/hOrw8ZZVdkpV2AJA1e0B03U9VEUPT7
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
> The fast path through a write will require replacing a single node in
> the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
> special case the node store operation by just allocating one node in the
> maple state.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/maple_tree.h |  4 +++-
>  lib/maple_tree.c           | 47 ++++++++++++++++++++++++++++++++++++++++=
------
>  2 files changed, 44 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 3cf1ae9dde7ce43fa20ae400c01fefad048c302e..61eb5e7d09ad0133978e3ac4b=
2af66710421e769 100644
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
> index 3c3c14a76d98ded3b619c178d64099b464a2ca23..9aa782b1497f224e7366ebbd6=
5f997523ee0c8ab 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1101,16 +1101,23 @@ static int mas_ascend(struct ma_state *mas)
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
> @@ -1121,9 +1128,34 @@ static inline struct maple_node *mas_pop_node(stru=
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

When would this condition happen? Do we really need to free mas->alloc
here or it can be reused for the next 1-node allocation?

> +               mt_free_one(mas->alloc);
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
> @@ -5386,8 +5418,11 @@ void mas_destroy(struct ma_state *mas)
>         mas->node_request =3D 0;
>         if (mas->sheaf)
>                 mt_return_sheaf(mas->sheaf);
> -
>         mas->sheaf =3D NULL;
> +
> +       if (mas->alloc)
> +               mt_free_one(mas->alloc);
> +       mas->alloc =3D NULL;
>  }
>  EXPORT_SYMBOL_GPL(mas_destroy);
>
> @@ -6074,7 +6109,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>                 mas_alloc_nodes(mas, gfp);
>         }
>
> -       if (!mas->sheaf)
> +       if (!mas->sheaf && !mas->alloc)
>                 return false;
>
>         mas->status =3D ma_start;
>
> --
> 2.50.1
>

