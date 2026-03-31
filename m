Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F20B1061B2F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492A76B008C; Mon, 30 Mar 2026 23:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443996B0095; Mon, 30 Mar 2026 23:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3320C6B0096; Mon, 30 Mar 2026 23:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6516B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:31:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC0AE160A20
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:31:07 +0000 (UTC)
X-FDA: 84604932174.02.49D0D35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8FE516000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:31:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlGmFtDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774927865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ce3pyw9coygVv44v/SQ4tDrY670P9k5ZhQkMYijfYOM=;
	b=RDSL+6abHpCELtJ7wNrajbOjZ/IIN9SdRSs7S4f0eK95JXOo4x0hEaJ5OroMbIZ9BYUCLZ
	msE6pG6Diw66ZD2LO3H56MCQxZBGx09DJnVnB2B16EFdNrrscukCsznA3XcOEB4Fpz/Dih
	NckQ1hWsl8cFSSi7dsKSIrPoOrImrKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774927865; a=rsa-sha256;
	cv=none;
	b=eZUy11xxQt975rIUrJYjuMJiTozfXq/n3a4xAjtjCVSc6/FRrELqBj9Yxo/qt1AC8UYBsD
	af8XEFH8UqaQH2xa4o5R0eWtnLswBKiXiVFdycWHkZSgthMhgNbyuOH3c/01XrSAZXzMEg
	Sg72lGnhDZsBuFjeSGqLuSDCKHrzuEA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlGmFtDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EEA6600CB
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE584C19423
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774927864;
	bh=0em3NEGe9Wx3RX87NOxfsc+6U/Frvh0gxHDMvTKfYg0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jlGmFtDtAO690pxU1LqJ/2FYlTN3a4UgM6cU0YBVnPOJhwWu3Spzn+7oVaF1PtX9D
	 90i0q1PazAfp35uyHimLxPKmRZu1mfXokMRdZUg0gUYpHwfDySVu6vCwX7QGkpl8GU
	 aMrIHWzcdrnvZgRAEpSQj77mOi+EroxexeHngzHqEQF6IkfklOo+QDbZoo2B2gnhLt
	 1RpMwi9ECvkQgDxgU8wGZkSsbdjPAfUopx8GelY17MM2vTHwuVaL8qU/hkjT1EPfYC
	 h1WlBtsoQHoZjGrMk2WlBOh8lPh/8B2XZzknKzdYM90Jdbie87NbOLB0zI0Gxlmkh9
	 2YXcecDFIIQMw==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64e87a81639so7533451d50.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:31:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVuiwIZjSAqH6Aa7hhIyPQXNJfKS6N/6ArDYG6zPZl23n/MS0zumBSgORjOHB8S0dBXfNAmQq1iSQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9z8sgg3ffRXJTlKP9KguLou/cxb+FoLZ6HRvcrgrZvdIyBlZ3
	0rIEcpGhwP1oo60zv77FF5+KKqj1VW3dS3ACzghetCf5OGrgGR1bUaCb3s3FG/V+XIJqAsS9Xem
	utiqadlRfgr8KQowOs4UwIHYRpNLs2XMOWqwN4dmePA==
X-Received: by 2002:a05:690e:16a1:b0:649:b31e:8f54 with SMTP id
 956f58d0204a3-64ff71eefbfmr14801262d50.24.1774927863995; Mon, 30 Mar 2026
 20:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-3-21cnbao@gmail.com>
In-Reply-To: <20260328075812.11060-3-21cnbao@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 30 Mar 2026 20:30:52 -0700
X-Gmail-Original-Message-ID: <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
X-Gm-Features: AQROBzDjcq5LFUTDQlTkUx6qx-K_zDFB4BC-EQ_Ub8mamnoY66QGKwV_f9Vielw
Message-ID: <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8FE516000B
X-Stat-Signature: w9meq1wkutzumz4xr7x1ujm95q9tw34y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774927865-213102
X-HE-Meta: U2FsdGVkX19Uyr4gZjojjXlDyj8qGYkIMh/UMyGcfMVicNSP/F8T1Kl9tQzi6IhwCpcXvieSXWLywASVxC5nsH7VTkcZp//IBN6WMOM6+w+yYiVYicNZ/UFY2EqVgmP7H4j9FCH5JfUKu11oUGoM0EDsCNIXlK1qPiy+znV3vw8d34fp8DTRuCH6+Si9oAr/CcFJRqUG6Zfy+eJeGySZO2JaO71oGGhHHlGXhnDdaRfKSqQE7fsbrtBYpPBWoH9MkDwhPqaGkrTPCrGsiqxc9lf60xwfGo2jbeN1Visfs+na7U6e14d5sX4ID1BNvCHZKHSw9zHJ+62qBsjp849h1UGeJB1E9nNlZIScqAd+8QTLjpc2E9xizBc6wqxmGopSxtUz7P5vrhfYhGeo1q5zfJQYayx65Zlo2wRK4i3XEckp+LypItc+WNetWDEQAtPfN6bl9Z/gJwzvwTHA6ZEM3skqAQvDmDzWbKu2gBO1JRUNTVK790PzH0u+fwTgNWwm8rJcN+hM7aA1TYXY16AOe4EdQmxlFcyN4AFo2pBFONJiwP02/8VBhapqb7g81lEmfO1kIZwWwo+xtYsqe9kY70bWymnPeJl5bEy0vukydlZN5DcL1tnhEn8yFS2JHoOa160wvpdf5hInd0ihlRNQFt5x4L8FtNi3F21wrXWmj9xLJ6icAzZB9fZ6fYoiN+ZqIzciUPAQy3yfnsuPn8HLR+5cfy5J9OyB8z9gCUHpuVlXKu4P0nL2iGhl9H6M98snkTrKh6KxA+59QLRcEAB9DZucH8sx8+9SCOBe8EACosZ6gKHisrpUQpQGJxdUPMa396f1ec6y7BvN92E5ani6KrXXBDlyVOVKy9WPuNBrlI2AKj6+Jv87nbwanhnxJA9jflAfem9lbSP5cy2x4OnAaPyvsA4JYt2U836kcDNQyo29MVJUKXb7zcmaXZvrtQTLyP0cQKp8rIWNRLbC00q
 /gTMaqmK
 5jr8qkzDn+x5USo/X4PuDeB1T2KFF3Cy76IKH1SSBPJn6npKPeGbNqF1oj+7qTMn/MLSZPAooJRE/jPlA/9S+b9FjvWmCADhSGWrzwdvcf3XozUgQxxaQ5xag1ygzYGIlDW5iMgIh4uvKZltE8cHdyf8Ye3KBRSG/7YemIqCnCPxYwMfR0qxwg40GpZCt0fB6T1LNrLgienqFxxF5oXcW/Yz4S/oxtkz+U8UkPyIAutD9px/PYJvFO7YILAGLQ5Rv4idER9PW0RZtn65eIGZnmggchH4F2J36coYV8/dD0ixhkudx1bRjztQvcwlRLwtPUMbFlt5DFmyum+2klSV4c4qWdgO3jqK39jKZGubhU53WswH5cqTkh95OX+A6werhozWvcp0xhLQkZt34oOV467HdOse4WX6AwIfnDDJqXzisigtH8Z8U4sklgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 12:58=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
>
> From: Baoquan He <bhe@redhat.com>
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.

Should add that there is no functional change expected from this patch.


> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Co-developed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Barry Song <baohua@kernel.org>

Have some nitpicks follows.

> ---
>  include/linux/swap.h |  2 +
>  mm/swap.h            | 10 ++++-
>  mm/swap_io.c         | 99 +++++++++++++++++++++++++-------------------
>  mm/swapfile.c        |  1 +
>  mm/zswap.c           |  3 +-
>  5 files changed, 70 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1930f81e6be4..b52f30dad72b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -243,6 +243,7 @@ struct swap_sequential_cluster {
>         unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
>  };
>
> +struct swap_ops;
>  /*
>   * The in-memory structure used to track swap areas.
>   */
> @@ -283,6 +284,7 @@ struct swap_info_struct {
>         struct work_struct reclaim_work; /* reclaim worker */
>         struct list_head discard_clusters; /* discard clusters list */
>         struct plist_node avail_list;   /* entry in swap_avail_head */
> +       const struct swap_ops *ops;
>  };
>
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swap.h b/mm/swap.h
> index 161185057993..219dbcb3ffb1 100644
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
> +void setup_swap_ops(struct swap_info_struct *sis);
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
> index 91b33d955e63..ad0895af6ed8 100644
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
> @@ -283,7 +284,8 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>         }
>         rcu_read_unlock();
>
> -       __swap_writepage(folio, swap_plug);
> +       VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
> +       sis->ops->write_folio(sis, folio, swap_plug);
>         return 0;
>  out_unlock:
>         folio_unlock(folio);
> @@ -373,10 +375,11 @@ static void sio_write_complete(struct kiocb *iocb, =
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
> @@ -409,8 +412,9 @@ static void swap_writepage_fs(struct folio *folio, st=
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
> @@ -429,8 +433,9 @@ static void swap_writepage_bdev_sync(struct folio *fo=
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
> @@ -446,29 +451,6 @@ static void swap_writepage_bdev_async(struct folio *=
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
>  void swap_write_unplug(struct swap_iocb *sio)
>  {
>         struct iov_iter from;
> @@ -537,9 +519,10 @@ static bool swap_read_folio_zeromap(struct folio *fo=
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
> @@ -571,8 +554,9 @@ static void swap_read_folio_fs(struct folio *folio, s=
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
> @@ -593,8 +577,9 @@ static void swap_read_folio_bdev_sync(struct folio *f=
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
> @@ -608,6 +593,39 @@ static void swap_read_folio_bdev_async(struct folio =
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
> +void setup_swap_ops(struct swap_info_struct *sis)

setup_swap_ops()` needs to return an indication of an error.
The error is that sis->ops is NULL or op->read_folio =3D=3D NULL or
op->write_folio =3D=3D NULL.
If there is an error, we should fail the swapon.

See my other comments regardin g the error checking at the dereference side=
.

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
> +}
> +
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> @@ -642,13 +660,8 @@ void swap_read_folio(struct folio *folio, struct swa=
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
> +       VM_WARN_ON_ONCE(!sis->ops || !sis->ops->read_folio);

WARN_ON_ONCE is not enough. If we hit a WARN here, the kernel will
crash on the next dereference of ops->read_folios().
In other words, we will get kernel OOPS immediately after the warning.
This makes no make sense.

We should refuse to swapon at setup_swap_ops() above.  Then no
checking here is needed.

> +       sis->ops->read_folio(sis, folio, plug);
>
>  finish:
>         if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ff315b752afd..c9eb95141c8f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3732,6 +3732,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         si->list.prio =3D -si->prio;
>         si->avail_list.prio =3D -si->prio;
>         si->swap_file =3D swap_file;
> +       setup_swap_ops(si);
>
>         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
>         enable_swap_info(si);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4b5149173b0e..9bacb1733e1c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1054,7 +1054,8 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         folio_set_reclaim(folio);
>
>         /* start writeback */
> -       __swap_writepage(folio, NULL);
> +       VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);

Again, WARN_ON is not enough, the kernel will panic here if a warning
is triggered.
Check at setup_swap_ops() and refuse to swapon if ops->write_folio is NULL.

With the other "sis" fix, the patch looks good otherwise.

Chris


> +       si->ops->write_folio(si, folio, NULL);
>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> --
> 2.39.3 (Apple Git-146)
>

