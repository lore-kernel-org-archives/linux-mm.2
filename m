Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD68EB3636
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520A76B0095; Mon,  2 Mar 2026 16:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB256B00AC; Mon,  2 Mar 2026 16:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD306B00AF; Mon,  2 Mar 2026 16:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 272226B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:21:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82A7CC17E9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:21:16 +0000 (UTC)
X-FDA: 84502393752.20.BCFD794
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5CF12C0007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:21:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Df59BZ5O;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772486474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rj//DqjxAeWOyrU3qor7kSeQVHwAAXXIB5/6CLr4Ym8=;
	b=TBCuQdoydMqrMqM/rZYL9N8WocZSJLw+ADFPe4+RYOmsEdjAha6uLh0gd9tSLj5Ft5BtSA
	+CeJb4vS7uRvqCoDw6bvPwt8QPeFNV5VUubcQDwcONmyeq4dPb7gb9NZOUc3kOaRd3S6NU
	wtVsFqWVBw3V+z7Ap9eVwtBU45znewc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Df59BZ5O;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772486474; a=rsa-sha256;
	cv=pass;
	b=sJHYB38rhnzW7DRniZfVu+xW0Gg5d7PLXDyP/YjuG0Uez1kyyZAW62xsib3wC9BV385OUP
	mrkX3pi9DIior4AYXCjTr0qXOCASAcZ5HApb8j0RqsiLkZiGXYB1emdMrOJKRnMvxccf21
	FdjM7O0raXd8j9P6RiB/oLYYiwjn9tA=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-437711e9195so3830601f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772486473; cv=none;
        d=google.com; s=arc-20240605;
        b=gv0n9bQ7zx2182ybEzU9l/PamE1+QH3wOhs3OxYEm5S5kAA/EmHK5l/bLtjVdWzcyd
         +izmlpss+EuXQbiU7hXJvMDjF9+fBELXd7CyxCBBiYM1E26vFdKxi3fcvw/bDROpNCb8
         g5nHitT3AHRoiY5J73tW4Xjz7HY0fUOsfxCLl4Q+6bQarJoGPvl5CaEEtLu+QGnzmz8H
         HT8sRXnCZU1/WOXvl5PuoMNX/wVKA1EurdC4mzO1uHvnjBckpNIaUIOR0BOBEEEEQK8m
         WTWfrJO7gQU8sc0ODmXC0d5L/cNuf28g2CbCEtZZjv50acZ/8rA4FI701l4mAu+fo9ZU
         zY0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rj//DqjxAeWOyrU3qor7kSeQVHwAAXXIB5/6CLr4Ym8=;
        fh=O+CE7iRGKkb/ak1ZvvOjbFXXY/p362zF6Vta9wjv9FU=;
        b=P/YANhoC7NDpaMDxfMLU9htt5xOBVko0MJRxTZVtI8BsA8jraniTtujK3DGa+yKrQj
         rtD7AvL//RdUIuTbGyhVyxOZkiPyHsGO4WfArwtW/ycDb2/hCMXCh4nTa3sAR1PyC+Ie
         B/JluUAbfvzBH+MJH99TryNzBuKdxbp4U4PQilD+LD819kMnJkURTnzN5k8E4TfNFCtO
         2HI/AhrIMP9zstdXS2cS8xWsf5x7cEEw3ioGvmsWX9W+AQzpwmMRrSLLjf3lREwQry2b
         2gIegLb1fF7IX3u1oNcH+3KLfTp2q5w/KEC7sERBUkjfBYMo4L0NXfayXKQeOFLyEEQS
         D8Xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772486473; x=1773091273; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rj//DqjxAeWOyrU3qor7kSeQVHwAAXXIB5/6CLr4Ym8=;
        b=Df59BZ5OJAH9HqiW4IcQc1ARP0h+bKMm/hXbI4EF6KCJkb/vo6sarrug2yLujjBUx/
         TiPsv9txtjgcAslivajUMT8Q6jBGEMvmukWDKp8OC7eB85EFq0fRUZCk+sgXodIUIQI7
         2y9ZPUljPg8iFgIxPbkebv8ne2yiBtTD4Elxg+700QNmGWxdGzW0/A2Xu+ZgXLCfek2h
         hTHz2erehxn5rDEY9+r5Oq/ayKKjdSjwWh/uvdxP/edOIQsz4/k3kcbBvWb++V1RTMUp
         SDrvEhENrglkmgnh5L5txV8O5mLBXvIjgsindp18D+Fa2eO9UN4ELYTpjF53o5Ch2SNF
         hfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772486473; x=1773091273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rj//DqjxAeWOyrU3qor7kSeQVHwAAXXIB5/6CLr4Ym8=;
        b=FxH1NycG5ij4MrRyNJax9DGk+hp+foFWoolBqFDOUm7XYccCsN7yTzi0t5mX6KOI9U
         tvIL2rFJZbyjBqroNI60XqZgFVU2TJQr3OBphyU0DqnrNzqzBSFIkv974H72Ct0H9ni6
         KgRFxn/7AWUGvRrhpsMnptwQjbUXRKWER+VvbXmqOxDp5sFls4dCnmh4hzYFdm8ZORc/
         19nfCCJ5uYBlpcQMrD6D2a0nQasghPforTjw8kr4u/TGGmEf6nlhU8syRcfBqdIDP2HH
         gckJPx9RWuDw277j2TgHhe5STrYv31R5kkorI0u0woQJUv552kpq/jY2RsVBkv7ZcRS6
         G3Ow==
X-Gm-Message-State: AOJu0Yxw2bI/jubyYSPQk8KkbP+vpTVk8gC+QP5qYqGyWMmBfK0UK+KZ
	4+uGN2Y4w6IyaF8niBPkcesidFznDYdGw/opE1Eny0c30qTW+Ks42JgLxq6EmCkoL4wYFFkSS17
	XDB0w6uZ86+3Jn68xQep25RlXQjuCrJQIgZU2lN8=
X-Gm-Gg: ATEYQzzexb8rme+LTSk736ROdIE0ybErTGuYRkYCbCUxeI0WERrVpa5ligieZZxMDI3
	Za2yS2EOJgTSWvuX8YbTJwdPfZWbCKedSfcv3/V+ayy+uPUMQ4VonPyDWacQq+IHjYyH+Z5iH+b
	G8QOuBx8AnpmenpJ/cSIrDggk7LJ+ZZq5TiJhbBTWqMbeW9RsGbhZvJGGTU+fN8faUjsUmFRiZ8
	yCYzyqQQAW4VSDA+G0vRpD/R7ZjUkjEVDoQk0qiFQMlCQcw0XeFSgs8YL+oE/MXUJr65Lqdwt5E
	1ABHIuIHgxF0VaQSezWl41EGV9Xfzo6gphC/9wM=
X-Received: by 2002:a05:6000:1885:b0:439:bf2f:123e with SMTP id
 ffacd0b85a97d-439bf2f1426mr1431024f8f.11.1772486472653; Mon, 02 Mar 2026
 13:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-3-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-3-bhe@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Mar 2026 13:21:01 -0800
X-Gm-Features: AaiRm51T1hjAl14z4AYNkPz2aW3VHfz1PpQWmWz-HcnoBocbFDmd8xG2X70bdy8
Message-ID: <CAKEwX=Pb=W8WShjS5uq=8iWxZYjTiskhKUO-MgxJzD1HgHmX7w@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pmmwa4s1gsxd6e1ouiqqs3jsemeikt41
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF12C0007
X-HE-Tag: 1772486474-191061
X-HE-Meta: U2FsdGVkX1/sCRiu218NtBSVrCHCjFImCEqc6QMP5hx8RMg2R4mLpQWgkZHOcwQa8ftP7s6Ntl/BsUAuYRWJLTzMXIb+R9ZChyQl+k0L3wJefiU6x/TNfkaK0n0L7/gpt5agptw5drWL+M0PaNVPDsqrIaZSLT8eBGnaFPCop2n7VcQsUDbSjH89/oa1C4fJ87YKJ0JaDtB4v71U5IPJRmxI7KG7eYO714IsQBrSuUMItxt1fQXX12GqtmqUlxJRnQ/RI48BrokQPnhA/Plw79jfGZJnXKW3K5u3EjweY0pAhHUI8OOaNrYPsv/3SeFeovtyUyI5euoX6HAYrQF2+Ul4q6i5Uw+WXhufoTb2gzM21Kc1KZEcgc/lr7jzcOlZVq8dzaqMY5R+l34ZA5Q8XAjBMUhSIUn2vbSOfXDQZdMNLhqD4NuIfN2kQ57VDUBaJz7BJ0ZXaLYYvXHBumjH+3ff3qVmimrJgv08M1PjLg5+ttHz5Mgu7lriE9O337Amq+A/qkbQQN7wfwouTORyE9uZ72VQWMM+uYnxqxG/5xxlElISlH8HddiT42dRwCsLKSN5kwjfyaurB2koIHMZhRGNScCUuElxc3dqZ53KKZIl6nnP4tJycgi8Q2jBQCGemM3WrFouSz5XnTgbKoCGBDfHezYuQTDCRNbewmpeFB573cVabAatlEgiCTdc+VKaB3cHwqY+XGk37JdmlPdDAI4AJvOUxpJjWnThBfbh3KX5MISy2woIb/yMK3y7H/s1xNP2AnuZLxV3VU29U71vGfglpVZx91J4DdlxWFv4pv90+4a72jftzwmj6HGMzOR1IhnN8si8aXBbj30HKjfssyi2AXj9j/lez7OQGN0FV822AGVD+of5G+rZNLzIfZm0ktDby9vf230WZKtcarRbClt4kDcZCsK6LI2wAPMLP5eXdy4IZN1JZF7jurPLV6fzR3ouHFFdNPPk27ThO2m
 uHzXcL7H
 XvZetWGMkBTmvswaqdYaJsG1JCA1YG058JngvE28Y9mrkL2qm4FuLMiqLmnfaF9glsnFevGkzn5OMAmthRIv7zg+VUkhX00LT1a+JeRuWHobd0TdSg4a30GU+UBYXwN8+fQZ9+5RZNIFf30JzFaYovlSXUI4GqoR6v7Mht+KyfT6+CXjGzi/y1t+0xJ1mM3NploBHpCbUsu9kQiU4p5qXHAbsENQVEKF+cSyR5OmEhgJ0sT1xMeaK3iUirhjo8QmdQgNkqHYERDp8xC/R2k0KzZ/vqEXp4OA2ZzX5j2ygCp+4hzAsv8jzrvJgEu/i4I+QYkxOnSx93lk7MrmD0Wa569CZGbajrIiXrYS8EqhVGENIUTRe3ow8VZoT4SlaEQaa+2BJIOyEz2/vvvh1H9x/yHbrooXELPWpQfF2FtAHLtJAPdlAAf/2mndcjakS/LcXi7YQCNuAnAIWDsuaUPp1C3XtuldAmzsrA/ZW8EzrsAyGU7matvgZGlPuofgICYSGp/8Fn9+9m1qDz0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 2:40=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h |  13 ++++++
>  mm/swap.h            |   1 -
>  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
>  mm/swapfile.c        |   2 +
>  mm/zswap.c           |   3 +-
>  5 files changed, 76 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0effe3cc50f5..448e5e66ec5c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -19,6 +19,7 @@
>  struct notifier_block;
>
>  struct bio;
> +struct swap_iocb;
>
>  struct pagevec;
>
> @@ -222,6 +223,17 @@ enum {
>  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
>  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
>
> +struct swap_ops {
> +       void (*read_folio)(struct swap_info_struct *sis,
> +                          struct folio *folio,
> +                          struct swap_iocb **plug);
> +       void (*write_folio)(struct swap_info_struct *sis,
> +                           struct folio *folio,
> +                           struct swap_iocb **plug);
> +};
> +
> +int probe_swap_fs(struct swap_info_struct *sis);
> +
>  /*
>   * The first page in the swap file is the swap header, which is always m=
arked
>   * bad to prevent it from being allocated as an entry. This also prevent=
s the
> @@ -284,6 +296,7 @@ struct swap_info_struct {
>         struct work_struct reclaim_work; /* reclaim worker */
>         struct list_head discard_clusters; /* discard clusters list */
>         struct plist_node avail_list;   /* entry in swap_avail_head */
> +       struct swap_ops *ops;
>  };
>
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swap.h b/mm/swap.h
> index 161185057993..c390df3f5889 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -226,7 +226,6 @@ static inline void swap_read_unplug(struct swap_iocb =
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
> index d1cdb10ba133..47077b345ae3 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -240,6 +240,7 @@ static void swap_zeromap_folio_clear(struct folio *fo=
lio)
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>         int ret =3D 0;
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>
>         if (folio_free_swap(folio))
>                 goto out_unlock;
> @@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>                 return AOP_WRITEPAGE_ACTIVATE;
>         }
>
> -       __swap_writepage(folio, swap_plug);
> +       if (sis->ops && sis->ops->write_folio)
> +               sis->ops->write_folio(sis, folio, swap_plug);
>         return 0;
>  out_unlock:
>         folio_unlock(folio);
> @@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb, =
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
> @@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, st=
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
> @@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *fo=
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
> @@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio *=
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
> -        * ->flags can be updated non-atomically (scan_swap_map_slots),
> -        * but that will never affect SWP_FS_OPS, so the data_race
> -        * is safe.
> -        */
> -       if (data_race(sis->flags & SWP_FS_OPS))
> -               swap_writepage_fs(folio, swap_plug);
> -       /*
> -        * ->flags can be updated non-atomically (scan_swap_map_slots),
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
>  void swap_write_unplug(struct swap_iocb *sio)
>  {
>         struct iov_iter from;
> @@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *fo=
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
> @@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio, s=
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
> @@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio *f=
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
> @@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct folio =
*folio,
>         submit_bio(bio);
>  }
>
> +static struct swap_ops bdev_fs_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_fs,
> +       .write_folio =3D swap_writepage_fs,
> +};
> +
> +static struct swap_ops bdev_sync_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_sync,
> +       .write_folio =3D swap_writepage_bdev_sync,
> +};
> +
> +static struct swap_ops bdev_async_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_async,
> +       .write_folio =3D swap_writepage_bdev_async,
> +};
> +
> +int probe_swap_fs(struct swap_info_struct *sis)
> +{
> +       /*
> +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> +        * but that will never affect SWP_FS_OPS, so the data_race
> +        * is safe.
> +        */
> +       if (data_race(sis->flags & SWP_FS_OPS))
> +               sis->ops =3D &bdev_fs_swap_ops;
> +       /*
> +        * ->flags can be updated non-atomically (scan_swap_map_slots),
> +        * but that will never affect SWP_SYNCHRONOUS_IO, so the data_rac=
e
> +        * is safe.
> +        */
> +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +               sis->ops =3D &bdev_sync_swap_ops;
> +       else
> +               sis->ops =3D &bdev_async_swap_ops;
> +       return 0;
> +}
> +
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> @@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct swa=
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
> +       if (sis->ops && sis->ops->read_folio)
> +               sis->ops->read_folio(sis, folio, plug);
>
>  finish:
>         if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 915bc93964db..af498f9af328 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
>         enable_swap_info(si);
>
> +       probe_swap_fs(si);
> +
>         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%l=
luk %s%s%s%s\n",
>                 K(si->pages), name->name, si->prio, nr_extents,
>                 K((unsigned long long)span),
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a399f7a10830..7ce906249c7a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         folio_set_reclaim(folio);
>
>         /* start writeback */
> -       __swap_writepage(folio, NULL);
> +       if (si->ops && si->ops->write_folio)
> +               si->ops->write_folio(si, folio, NULL);

This one seems really weird to me TBH...

What's the point of a zswap writeback to a backend without writeback
operation...? We're loading the coldest zswap objects back into
memory...?

More generally, do you anticipate a swap backend with no write_folio?
I can't imagine such backend.

That said, if they exist, they should be exempted from zswap
writeback. At the very least, move this check to the beginning of
zswap_writeback_entry(), right after swap device pinning
(get_swap_device()):

1. If swap device has no writeback op, just bail. Don't even bother
allocate swap cache, decompression, etc.

2. If you anticipate that this case will never happen, add a warn.

