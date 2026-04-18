Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF28FF99C63
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD80C6B0172; Fri, 17 Apr 2026 22:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88D56B0174; Fri, 17 Apr 2026 22:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78216B0175; Fri, 17 Apr 2026 22:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A40AE6B0172
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:30:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3327CB9160
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:30:26 +0000 (UTC)
X-FDA: 84670097652.07.98D6F15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 286B740007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:30:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qf5RI/8q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776479424; a=rsa-sha256;
	cv=none;
	b=bOS2j8Gs9P/o2i54De0VVK8ZAx1rEgX5c8aNhAgZSV6tkht1rD+JPfRnobp6CUOvAtpHMh
	iEhTfZwcSEFCECJsT1NwJmR7f2oBizDMDwirKQpD1MU5UCuTEGd/cMN+Hqfmzcf7NO8Cu6
	ui5gbld8yNeEItGy0/mKlmDnLhwsLwE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qf5RI/8q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776479424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VW4qVl7GKadzvfqtPtDvpnRac88gpO5boSoxcn1xsSU=;
	b=ubYiGPa7J1hrB6/DFFYemOnYIWT92Hum+V+c5bxnjxtNga8OXFLyQXIgO9xo7C2KCvJYkf
	1VbcptuknPwVqd94xeDQvRw8FMzrBHC0rzquZaTRXrYusAOrK9fDlUcKalvFt0fP2GwZ27
	XUjsE73CyJqEVZE4/TVeIZS+jHX2owM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB3CB435B5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FF9C2BCB5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776479422;
	bh=eToN/1fh8G7TVca5VvDYz2A+dmffiLHNuPrbYY8uLVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Qf5RI/8qRzWddc5JhF6JyZ6l3zC8lhjvT8r26k6SGRvPRbtSKyG/pyD7Mx4tm3ZKT
	 uOgfhouyCrTtyhz/ZvHyHuAqqzJ3A3vFJAWJV0A6idlgdjPuGieQLX8qc9jEWucmXc
	 UfE7ZdbEXOTALH1Z8hWNIKAq5RGCMf6VGzdN7dfoD7kLTYpZfUGEoNkHTPPgaJs1d2
	 SxwOzicOuJ5ex2796+IgDgHs3hPjLnHEJ3LbOEXNShkMUfdKuMhx956v04b/hdPjhm
	 NebZufjaL47JkwqpWwqatqVTeMc2OeP8WxdRtfC0Suor8Ffvk7CL/AqTu/kiGYX1uA
	 5m4lwZkjfzmrw==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-652f220595fso1417142d50.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 19:30:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGnErvXfAe1FAZ3e29Nv+of7qmatxOoTiiiD+H1EU1p3/kUQAS
	aSvdBbUI02UGzzGvjeYAr6spFdfqhBOfQdUZvE1WAi4lVkJ6XtEi4GfkFi0l8P5Ur9Hawd+cySm
	eeS14uuP87jVszCPuibqyu7GkOOxhTfQjiLHgRrWsag==
X-Received: by 2002:a05:690e:4849:b0:64e:8d4a:d0c with SMTP id
 956f58d0204a3-653109b4ea1mr3584850d50.31.1776479421743; Fri, 17 Apr 2026
 19:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260417033951.1111038-1-baoquan.he@linux.dev> <20260417033951.1111038-3-baoquan.he@linux.dev>
In-Reply-To: <20260417033951.1111038-3-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 17 Apr 2026 19:30:10 -0700
X-Gmail-Original-Message-ID: <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
X-Gm-Features: AQROBzDY_FvI0uUn-g02NhLG5N6XPtNJ50k-mqzMsB7ZoCB-CfBTWFlwBO5ERSo
Message-ID: <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: reio6mcwfrg7s8x8uj6ehmihr1ob7fxb
X-Rspam-User: 
X-Rspamd-Queue-Id: 286B740007
X-HE-Tag: 1776479423-865613
X-HE-Meta: U2FsdGVkX1/IO014qdy6swIkgo2CTBbysBsrXXFm0BpfS8T8hebbORICfCZOmFSoYW/CKkYW2vYJn8Z0Zl07vGi5stkSX64v4EM4fh5bdMQw5ppK39HMhjMpNuCy/RWICiiEwJAlDItTso2ioyRVCmSL7oAod7lsM9zFhc7yKNMaryxwkd5K/jjg9ncrh0qWdvDbpE9cWUqWPnD53bzPHzpFxqSKwHQQxH6oQWMRwyFBuOBJrdEHQQ68yOk09PxOQr96li3h9R9An+YwXfxl+5dlsuSCIa8akA0u9T62Hc7qE/TckdGV4roogO5vnIsAzJsV8IaiAjhx3iRTF4kwSsDPkdgATEjypIci+ZJvM/2/tQnj4X2ln28VzvSIdCSPqsnp1gFKeFLFz3MWbjbZidSCl32TK46TlhUqZB9z3H0PYY3j2aXBaERjRC/waCEt+VUxpDex6vFrrSGxsm9adVz/6j0l90nJkruwjC7V+Qgs6Ak3pWeXM1j8OugQBSNa/za1NKa2qPdeqqzk3abEBhvaVY2eI2txgD9qLrD74xall2yeImux3Fm/Hcg50+PW0VEJTHRlj6JT3WewPJwhYHj1SzEysxaF4NTDy6p45dhghzfJ2VQuRKmpWcm0hbVn/hIiGgW40DAA8NyJg2i9FTZrMmiaPWEF76akbFM2FHRgTJ+wpCekxeEpgOJmYZzYnJRLh5Dwk64XjXZP4qYn8Yja5FLc4Ptk57tCm5gjcJrn4br511ny84c3tJdB4qYVnnCrKcIcv6SNKYDM84ERR7GODZn+p4uzfy6+Rgd1rSLTnCZP0+HGmcC3hgLuv5kGisQ/urNx58JXS8Ud/JWrNCXvLMqMDu88a/a+V5uZsbiFfkhkc6s+cvh83pjmq7JeZ7j40M5u8BQvzMYlwzVNyxqZR1pZq+jtjmKYZw/XN/hgEDLvp6i2Nv+KR1CLTlDOBCa+dpyhIkNlSn9j5Lr
 YJBfB0b0
 LYgvJvRIoxcgczCxJbGJ4pZOhOORqLu6hGwKCdQRDq6dXzrB3E+DHZfhBPxqV6ZpIj1W0B96JDCT0Iwdg96rL60JAcJK7Bd01xTi7NGtvALtLutgRSh/lKQ59cULZGWZz5Ar2WZIlynTGOMSceYESUYIAn35IVXPDxNbSzTlGMT9sga1/jkQCPOjqyvH+qKQIXO8+CqRNsL/TF57biQ0y7376QbXEVXm+ZiCXH2flwR+s83tp9i76nQW2AG2VGl4Or4dfKFiQWQklFz3cqDTzRB236TKMDIw+2h0oeOwxN9sNIView5WMR9V/opwcKW7rVxwUYTBjcHuoyNgxiKhaxrVq9Y2y9SL7w7CTlZCiAYyx6dC0yBrA5y/LJHWlLvCNg+ks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 8:40=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate operations adapted into swap_ops.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Co-developed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

Overall looks good, I have some nitpick follows.

Acked-by: Chris Li <chrisl@kernel.org>


> ---
>  include/linux/swap.h |   2 +
>  mm/swap.h            |  10 ++++-
>  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
>  mm/swapfile.c        |   5 +++
>  mm/zswap.c           |   2 +-
>  5 files changed, 76 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4b1f13b5bbad..5fdda26f5c1d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -242,6 +242,7 @@ struct swap_sequential_cluster {
>         unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
>  };
>
> +struct swap_ops;
>  /*
>   * The in-memory structure used to track swap areas.
>   */
> @@ -282,6 +283,7 @@ struct swap_info_struct {
>         struct work_struct reclaim_work; /* reclaim worker */
>         struct list_head discard_clusters; /* discard clusters list */
>         struct plist_node avail_list;   /* entry in swap_avail_head */
> +       const struct swap_ops *ops;
>  };
>
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swap.h b/mm/swap.h
> index 161185057993..29bdc679fa98 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -217,6 +217,15 @@ extern void __swap_cluster_free_entries(struct swap_=
info_struct *si,
>  /* linux/mm/swap_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> +struct swap_ops {
> +       void (*read_folio)(struct swap_info_struct *sis,
> +                       struct folio *folio,
> +                       struct swap_iocb **plug);
> +       void (*write_folio)(struct swap_info_struct *sis,
> +                       struct folio *folio,
> +                       struct swap_iocb **plug);
> +};
> +int init_swap_ops(struct swap_info_struct *sis);
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
>  void __swap_read_unplug(struct swap_iocb *plug);
>  static inline void swap_read_unplug(struct swap_iocb *plug)
> @@ -226,7 +235,6 @@ static inline void swap_read_unplug(struct swap_iocb =
*plug)
>  }
>  void swap_write_unplug(struct swap_iocb *sio);
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)=
;
>
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __read_mostly;
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index a62c02ab0551..1b054a122f53 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -238,6 +238,7 @@ static void swap_zeromap_folio_clear(struct folio *fo=
lio)
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>         int ret =3D 0;
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>
>         if (folio_free_swap(folio))
>                 goto out_unlock;
> @@ -279,7 +280,7 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>                 return AOP_WRITEPAGE_ACTIVATE;
>         }
>
> -       __swap_writepage(folio, swap_plug);
> +       sis->ops->write_folio(sis, folio, swap_plug);
>         return 0;
>  out_unlock:
>         folio_unlock(folio);
> @@ -369,10 +370,11 @@ static void sio_write_complete(struct kiocb *iocb, =
long ret)
>         mempool_free(sio, sio_pool);
>  }
>
> -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **sw=
ap_plug)
> +static void swap_writepage_fs(struct swap_info_struct *sis,
> +                             struct folio *folio,
> +                             struct swap_iocb **swap_plug)
>  {
>         struct swap_iocb *sio =3D swap_plug ? *swap_plug : NULL;
> -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct file *swap_file =3D sis->swap_file;
>         loff_t pos =3D swap_dev_pos(folio->swap);
>
> @@ -405,8 +407,9 @@ static void swap_writepage_fs(struct folio *folio, st=
ruct swap_iocb **swap_plug)
>                 *swap_plug =3D sio;
>  }
>
> -static void swap_writepage_bdev_sync(struct folio *folio,
> -               struct swap_info_struct *sis)
> +static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> +                                    struct folio *folio,
> +                                    struct swap_iocb **plug)
>  {
>         struct bio_vec bv;
>         struct bio bio;
> @@ -425,8 +428,9 @@ static void swap_writepage_bdev_sync(struct folio *fo=
lio,
>         __end_swap_bio_write(&bio);
>  }
>
> -static void swap_writepage_bdev_async(struct folio *folio,
> -               struct swap_info_struct *sis)
> +static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> +                                     struct folio *folio,
> +                                     struct swap_iocb **plug)
>  {
>         struct bio *bio;
>
> @@ -442,29 +446,6 @@ static void swap_writepage_bdev_async(struct folio *=
folio,
>         submit_bio(bio);
>  }
>
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> -{
> -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> -
> -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -       /*
> -        * ->flags can be updated non-atomically,
> -        * but that will never affect SWP_FS_OPS, so the data_race
> -        * is safe.
> -        */
> -       if (data_race(sis->flags & SWP_FS_OPS))
> -               swap_writepage_fs(folio, swap_plug);
> -       /*
> -        * ->flags can be updated non-atomically,
> -        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_rac=
e
> -        * is safe.
> -        */
> -       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> -               swap_writepage_bdev_sync(folio, sis);
> -       else
> -               swap_writepage_bdev_async(folio, sis);
> -}
> -

Nice

>  void swap_write_unplug(struct swap_iocb *sio)
>  {
>         struct iov_iter from;
> @@ -533,9 +514,10 @@ static bool swap_read_folio_zeromap(struct folio *fo=
lio)
>         return true;
>  }
>
> -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **p=
lug)
> +static void swap_read_folio_fs(struct swap_info_struct *sis,
> +                              struct folio *folio,
> +                              struct swap_iocb **plug)
>  {
> -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct swap_iocb *sio =3D NULL;
>         loff_t pos =3D swap_dev_pos(folio->swap);
>
> @@ -567,8 +549,9 @@ static void swap_read_folio_fs(struct folio *folio, s=
truct swap_iocb **plug)
>                 *plug =3D sio;
>  }
>
> -static void swap_read_folio_bdev_sync(struct folio *folio,
> -               struct swap_info_struct *sis)
> +static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
> +                                     struct folio *folio,
> +                                     struct swap_iocb **plug)
>  {
>         struct bio_vec bv;
>         struct bio bio;
> @@ -589,8 +572,9 @@ static void swap_read_folio_bdev_sync(struct folio *f=
olio,
>         put_task_struct(current);
>  }
>
> -static void swap_read_folio_bdev_async(struct folio *folio,
> -               struct swap_info_struct *sis)
> +static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
> +                                      struct folio *folio,
> +                                      struct swap_iocb **plug)
>  {
>         struct bio *bio;
>
> @@ -604,6 +588,44 @@ static void swap_read_folio_bdev_async(struct folio =
*folio,
>         submit_bio(bio);
>  }
>
> +static const struct swap_ops bdev_fs_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_fs,
> +       .write_folio =3D swap_writepage_fs,
> +};
> +
> +static const struct swap_ops bdev_sync_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_sync,
> +       .write_folio =3D swap_writepage_bdev_sync,
> +};
> +
> +static const struct swap_ops bdev_async_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_async,
> +       .write_folio =3D swap_writepage_bdev_async,
> +};
> +
> +int init_swap_ops(struct swap_info_struct *sis)
> +{
> +       /*
> +        * ->flags can be updated non-atomically, but that will
> +        * never affect SWP_FS_OPS, so the data_race is safe.
> +        */
> +       if (data_race(sis->flags & SWP_FS_OPS))
> +               sis->ops =3D &bdev_fs_swap_ops;
> +       /*
> +        * ->flags can be updated non-atomically, but that will
> +        * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> +        */
> +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +               sis->ops =3D &bdev_sync_swap_ops;
> +       else
> +               sis->ops =3D &bdev_async_swap_ops;
> +
> +       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> +               return -1;
Nitpick:

For int type error return, you should use  -EINVAL or some thing with
error code. If you don't care about error code, change the return type
to bool instead.

> +
> +       return 0;
> +}
> +
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> @@ -638,13 +660,7 @@ void swap_read_folio(struct folio *folio, struct swa=
p_iocb **plug)
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>
> -       if (data_race(sis->flags & SWP_FS_OPS)) {
> -               swap_read_folio_fs(folio, plug);
> -       } else if (synchronous) {
> -               swap_read_folio_bdev_sync(folio, sis);
> -       } else {
> -               swap_read_folio_bdev_async(folio, sis);
> -       }
> +       sis->ops->read_folio(sis, folio, plug);

Nice.

>
>  finish:
>         if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..af81fa212f1e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,6 +3518,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto bad_swap_unlock_inode;
>         }
>

> +       if (init_swap_ops(si)) {
> +               error =3D -EINVAL;
> +               goto bad_swap_unlock_inode;
> +       }

Assume you return the error code above. Here can be
error =3D init_swap_ops(si)
if (error)
     goto ...;


Chris

> +
>         si->max =3D maxpages;
>         si->pages =3D maxpages - 1;
>         nr_extents =3D setup_swap_extents(si, swap_file, &span);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0823cadd02b6..b699413a2526 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1061,7 +1061,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         folio_set_reclaim(folio);
>
>         /* start writeback */
> -       __swap_writepage(folio, NULL);
> +       si->ops->write_folio(si, folio, NULL);
>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> --
> 2.52.0
>
>

