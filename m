Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED78CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 20:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659558E0015; Fri, 22 Aug 2025 16:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630888E000D; Fri, 22 Aug 2025 16:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546388E0015; Fri, 22 Aug 2025 16:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42FE48E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:29:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E056C83035
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:29:28 +0000 (UTC)
X-FDA: 83805533616.06.CC76AB8
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00C0112000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:29:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MoBqskP5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755894567; a=rsa-sha256;
	cv=none;
	b=mpkfmbKeLgH3kMHJxkx4/n4Mdr7VETHRxRK47wTuYtsLK5AIO2MY06DixxiL6cZr8PZc1o
	0EYUDBFP9IkN1WWr9AAAkDEQfCEmy4q937nPZMZuJHh2UbRNO0UiQI/DcE3DO4CqQaBnet
	++5RZ7I9txnkRhZPozbtoXC+tgFlGCI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MoBqskP5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755894567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFW/ka6qBc+ExLqD+f/nxo2YH7Yq8nmI0R2bjFCfWYs=;
	b=fFCoulAkNLVap7etEScHnu+qKNV+ZRlFbThYMoY4GvUxXV/3tpN9l9Gx87zep+bNfjU2Ju
	hOBbaEPQxUvgqEccQEzqdE05tpAjYJjaflMJxtLZXngHKQa1gltBu3viCrUQa6yqEr9ABU
	Lr/pyLFf+vDmIsUvh4umg5+98guZfMc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b29b715106so25051cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755894566; x=1756499366; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFW/ka6qBc+ExLqD+f/nxo2YH7Yq8nmI0R2bjFCfWYs=;
        b=MoBqskP5bkzRvvEpicSU+HKl5qAnWgGrGBB8BQJwNOrjyShi3RS1uSABjWXPHpn3c6
         6fLIitPJtN2YrmO7HW8UGDf0vGHEZSXCNggu6lItjAEJ9Q3Guh2z0MXJqZBOxrlsUEc5
         h4VdmmNsaOww4Q2C3j1q4E2G7IoYcCqAfZy0yFph3slLMu/HxTifpcXjspkK3RupqHAo
         tNYqGLJXEvO7odIA7xnJTAlNJPVLCMlHpZQxupEXlp4z1AhiM4rlcR2IoNERnS1W5zu3
         WdYEecUkRSc+ynk1jkCcBe3Gb2sbNSYgX6pKTUh4WCmzTY5VHZrsAKbvE1CO/c1Yl/F1
         Gjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755894566; x=1756499366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sFW/ka6qBc+ExLqD+f/nxo2YH7Yq8nmI0R2bjFCfWYs=;
        b=eKIoQlCxQHV6ZhhM0JmD3VUUXyLFC8r9LSDlnAiBmLp5P37LllUp4cSPcCDVhIEoCr
         6/UjNOGRhqSD34GgSJjhT6kQBPrCU0Ar5LxD30+5P+1KcAe1Ogcb/AsLSU4qvXQVKeK1
         8hwJnT3jvKJDpkh50nKxBFNMlRM/aQdrGy7M8eLfhwf18Chd6ZaJQXU3DU86P6U0/Zhe
         TEAIZb1CKu8hLZkH6qGuQFOJFmyhb9Q6X8HqJxmdgFmGS6jhezf7nmVkKc57ZTDwSFDi
         TxfzJHgeFM18gkjHy8uMM4Ew2DK5/77EgI2hGvSnySjYLiblaDDNf+X+ImxiR5Olh2xV
         pPsw==
X-Forwarded-Encrypted: i=1; AJvYcCU6ZyVCxX7CV+ZrXH/h567xDNKSNpOQUxwS6eT40uS92icJFxYrosmvb9ptAh9sWuHzFXeP56dCxQ==@kvack.org
X-Gm-Message-State: AOJu0YwKQbTKl5CPuueCiYLROyX/yy9dX6asSZOl/fQ6itNv2PnFM7xt
	8jEj2Gegc1y/qC9AKyWpJha3XMvciZ5rnAHQaElVSuxlDrBw10dLrB4LirvkuK9g9eZb2p4ZSzO
	T1bLh46pKa59DOTRYxiK+tvPA1hMF45BH2X1smNTu
X-Gm-Gg: ASbGncsIBgKhcGSF8aIHnABOozDwz/jvrCHQ7lrG2VuoFFUEfE1C6KTFWPQ7SEc7P7B
	Ny/wkaZ3cr+c6QmXMP9K87SVzxZD8lIP1tTtvMKaT0NbcKicZMx3lY+3TfIGz/GGWvqBhbDJO6K
	fJZDWTNDc85WjS6svdgJyAHWIRlGLwTmDDQyvn8EEMMO9L5qyTvgNEM0DJ296U084PmkPmdTqEa
	T7VVB0WShq0
X-Google-Smtp-Source: AGHT+IE4pKQt99yfD8phfxzg64h26jRgQtXjKYToOS/x0NhTO00qhgEpbXPpJ20CmT3cAcOxNgN3tfWpuWfg/a8bQMc=
X-Received: by 2002:a05:622a:253:b0:4a5:9b0f:a150 with SMTP id
 d75a77b69052e-4b2ba82db6fmr837361cf.16.1755894565605; Fri, 22 Aug 2025
 13:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-14-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-14-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 13:29:14 -0700
X-Gm-Features: Ac12FXzd89CHC2aRvtwVoiHY-2WtL8K1s3anAhQP19TUMIyfZkmLWoeYPfL7oE8
Message-ID: <CAJuCfpH4PNCaMQ4k3iOvt7BK-+nDzVV1p3PcH++7DFGGvg9=fA@mail.gmail.com>
Subject: Re: [PATCH v5 14/14] maple_tree: Convert forking to use the sheaf interface
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 00C0112000A
X-Stat-Signature: 93wwzsa4y7ixsnho9biffcyoz6xniwua
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755894566-344988
X-HE-Meta: U2FsdGVkX1+ZdTcR2C0Pv+HjYcoK3wnVUeKUHwQuwJJxB5lD3c5BJNgDt0d9orTW9h0y7CYZRX6W4O86tcTHC6emOQocdJrbk/KJ55IcII88RHABQyx/RWn5sQQjNhlhHq+imPE6wJqvpTO4MirwKU0gDsn9OFZQODyEE0iqYpwfM/VTuNCWU9qrf0LKLxiBINSiTRstLzPb59Xc7qbfkSHjCnlrdlfPjDUpsG6qpz2tjgNea0X54sF0gieFV+FTb3rjR5Re97I6w8e75pjMi+Px4MYyDVQRO6OM/zXnpsCR6Kxg8drnZjR/qSeBWNmkuvZG9S5Yg8yWX2kbUeND7v16T8LneaXpEt44/H0dV4KOEv3HFZaLTs1yzrZ9wueqsKQZhVxkQdUQRT+3LyVQwDp7tgGAyPOrEkOhFLgfEn/fozIb20ynDxSvGMRWun45Pzovu2eYqJeAQktOKQjKXaVhHIHzplKV96/VtSaRDjYtqhmr+SKVdK9oDez9q/VLn9e4wbtaf+cAYGeDFeUzwjCGymzrSp5gk0dFaLjXOGtwCVCvopkYkqUZGqKMJw2Grx8CRFBe1/ryZQE/K4tkyKwhabzufdStWkmz9VrX6SHAsm9/nL+dkvy/2XMP15bu30G0uy5T4ZqgGccvYsbUsu46KNAHtsCHxrTFnd6GwAMhf7MhvevmisADGbekHhEMDWQ+JE6ahZGajOW/k6HiO8OqMJEpSRE1KMLOl5HOGHRfYxeLJlYTY8tY+AA4NzdvBVnMnmBdx7ortBOJnuEmtYSZdC8lnmbchoy4emRJ2m/b7ZqIjJAB7OvKLjQ+0iTy7cQgfY94FZX0fDlZQXyoEZXE5G/nKmgLp1xX3bAt9+ormIKF2BKZ38q68LY/qF2nw7p3YGqE3O/d00ilYPL9RkJRhdOov3f75k3a5O7ZYjJz6AduQMIKyNaLnNXyJFW7stbRshsCN6b4YaiXBZ8
 yYTqaJFw
 o88J1Nm2f3gqasTLGQ7xqqY8hmcEA9/UB9ZrE5eZUy+IwSdz7TvAjfbBkIV201uXCmRCJSf5pzywmrM+b6WixRcuV50UUANhCjjXW8hbKz6IRssSbi32OulfTkUNgPjZDLHF1Ryrt8T10vfypLYYrMpaKbhP2Kze8Pnzp2dLBf/TMwPyvb+ohQKZ5OEQnuIJ/7KfalkHT7i2qqA7j89Lv0ytKMCys2LOjFP8RXFG/gAK/U97OuxJyhySvkMlv03dEqRVFr7Sy3PkfacYFcal6IWzzvuOeCEMhQvqAcgCXHEQF1MK0lEv8zANfp2+4CYaT7mZ8
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
> Use the generic interface which should result in less bulk allocations
> during a forking.
>
> A part of this is to abstract the freeing of the sheaf or maple state
> allocations into its own function so mas_destroy() and the tree
> duplication code can use the same functionality to return any unused
> resources.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  lib/maple_tree.c | 42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 9aa782b1497f224e7366ebbd65f997523ee0c8ab..180d5e2ea49440248aaae04a0=
66276406b2537ed 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1178,6 +1178,19 @@ static inline void mas_alloc_nodes(struct ma_state=
 *mas, gfp_t gfp)
>         mas_set_err(mas, -ENOMEM);
>  }
>
> +static inline void mas_empty_nodes(struct ma_state *mas)
> +{
> +       mas->node_request =3D 0;
> +       if (mas->sheaf) {
> +               mt_return_sheaf(mas->sheaf);
> +               mas->sheaf =3D NULL;
> +       }
> +
> +       if (mas->alloc) {
> +               mt_free_one(mas->alloc);
> +               mas->alloc =3D NULL;
> +       }
> +}
>
>  /*
>   * mas_free() - Free an encoded maple node
> @@ -5414,15 +5427,7 @@ void mas_destroy(struct ma_state *mas)
>                 mas->mas_flags &=3D ~MA_STATE_REBALANCE;
>         }
>         mas->mas_flags &=3D ~(MA_STATE_BULK|MA_STATE_PREALLOC);
> -
> -       mas->node_request =3D 0;
> -       if (mas->sheaf)
> -               mt_return_sheaf(mas->sheaf);
> -       mas->sheaf =3D NULL;
> -
> -       if (mas->alloc)
> -               mt_free_one(mas->alloc);
> -       mas->alloc =3D NULL;
> +       mas_empty_nodes(mas);
>  }
>  EXPORT_SYMBOL_GPL(mas_destroy);
>
> @@ -6499,7 +6504,7 @@ static inline void mas_dup_alloc(struct ma_state *m=
as, struct ma_state *new_mas,
>         struct maple_node *node =3D mte_to_node(mas->node);
>         struct maple_node *new_node =3D mte_to_node(new_mas->node);
>         enum maple_type type;
> -       unsigned char request, count, i;
> +       unsigned char count, i;
>         void __rcu **slots;
>         void __rcu **new_slots;
>         unsigned long val;
> @@ -6507,20 +6512,17 @@ static inline void mas_dup_alloc(struct ma_state =
*mas, struct ma_state *new_mas,
>         /* Allocate memory for child nodes. */
>         type =3D mte_node_type(mas->node);
>         new_slots =3D ma_slots(new_node, type);
> -       request =3D mas_data_end(mas) + 1;
> -       count =3D mt_alloc_bulk(gfp, request, (void **)new_slots);
> -       if (unlikely(count < request)) {
> -               memset(new_slots, 0, request * sizeof(void *));
> -               mas_set_err(mas, -ENOMEM);
> +       count =3D mas->node_request =3D mas_data_end(mas) + 1;
> +       mas_alloc_nodes(mas, gfp);
> +       if (unlikely(mas_is_err(mas)))
>                 return;
> -       }
>
> -       /* Restore node type information in slots. */
>         slots =3D ma_slots(node, type);
>         for (i =3D 0; i < count; i++) {
>                 val =3D (unsigned long)mt_slot_locked(mas->tree, slots, i=
);
>                 val &=3D MAPLE_NODE_MASK;
> -               ((unsigned long *)new_slots)[i] |=3D val;
> +               new_slots[i] =3D ma_mnode_ptr((unsigned long)mas_pop_node=
(mas) |
> +                                           val);
>         }
>  }
>
> @@ -6574,7 +6576,7 @@ static inline void mas_dup_build(struct ma_state *m=
as, struct ma_state *new_mas,
>                         /* Only allocate child nodes for non-leaf nodes. =
*/
>                         mas_dup_alloc(mas, new_mas, gfp);
>                         if (unlikely(mas_is_err(mas)))
> -                               return;
> +                               goto empty_mas;
>                 } else {
>                         /*
>                          * This is the last leaf node and duplication is
> @@ -6607,6 +6609,8 @@ static inline void mas_dup_build(struct ma_state *m=
as, struct ma_state *new_mas,
>         /* Make them the same height */
>         new_mas->tree->ma_flags =3D mas->tree->ma_flags;
>         rcu_assign_pointer(new_mas->tree->ma_root, root);
> +empty_mas:
> +       mas_empty_nodes(mas);
>  }
>
>  /**
>
> --
> 2.50.1
>

