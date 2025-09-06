Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C5FCA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 02:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5EE8E0005; Fri,  5 Sep 2025 22:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066F88E0003; Fri,  5 Sep 2025 22:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5CF8E0005; Fri,  5 Sep 2025 22:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBEB68E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:14:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DCE11A03FA
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:14:34 +0000 (UTC)
X-FDA: 83857206468.11.81E105B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4D0A160002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:14:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OvStcudk;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757124872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7V8i+etKKHn87HVTkQ/Pc/jsMsaBMzsWgB7UCDIC4E=;
	b=WEB0ohu4S1IUHd43KyV6iI/Xwo30JJrxoIy8jSB5iq9mGMAaTiFXvO+ubbKZgg5No6nAq8
	28IEQfzVigVf/WPCAN77zObrr3ZmHigLa+6Qvcpul3c738wsItWKB29j4DkyBjKJQZO8Ff
	IJJnyDG8tGABkkaAALY8Dqp10vC2KTg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OvStcudk;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757124872; a=rsa-sha256;
	cv=none;
	b=F5jd957E9Oz4T56kqArUBpjiGTMfbKcnSA7NIyKlaEBdbvEEBGul/V9GRy1pkda0Twc1TZ
	ziK1G3cI3TTAMCptdU5GMP/QGenQe+W2Ml+2m8r5HUj6zmFyH4uFSnuFFWK9mQ4cnp6m01
	wVNQrQm4hXWSJrLF3Dl5AaJIAYJfzWg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E3CA602AF
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985AFC4AF09
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757124871;
	bh=g3DlQn4KklhNo1wDVC9prsucRrVcq1JkQunm7KfqZy0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OvStcudkWkCIw7WLotScd4gyyfOMc+UExFpzSL6/Gdn52LswO0P+9WNchdowzaSt6
	 I7+QRRlhr1wNAzLu1mRO/1tCGRKj6nqS3tZsN0ZfRt44AiUAPyhM8wL0p9piO74JzL
	 +AxrRIRc3E4MMbw+F3nkHmWzVPRBCchKzqQdlHJntTwTslvRKSOaXqLMFqRvuDvcOg
	 03m21t+2FVOEWIQotGeUklrPFKLDm7QO8wSkC2/ooLBT3HHSx9moU/1rzSKLaHxjS6
	 RqdtZybULbGsvESHIbStEfo3OOROM0KMjZRwKpXPuyBfqOerv8KuZxoimOZYlPSIiB
	 p9GZlMPzA874g==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45ddca76f22so17065e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 19:14:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YxVeUSfCzAKAZBI/zHyqUAvu8SHOwpkCUvM/bkPRWK59Qc/n2eX
	WhxlyAvlSwZiMT3x0qWfmdm/AvgjtfNr6P0aD/IW0oMTpYiGD/t9oNM7iDiFOiMzUSm2k6kUe3V
	N0GzT2Dd1pWIzjcfTaLnOtq3TEM32Frav9VffZXjF
X-Google-Smtp-Source: AGHT+IFqp8G3aCcPMUMN2b0PpCHnjwMvBKuu6o00kPN8nc0HwmPdM8mfKCIk6If8kQfqG4MuieSp/W2cZvum3TzoZxs=
X-Received: by 2002:a05:600c:4f50:b0:458:92d5:3070 with SMTP id
 5b1f17b1804b1-45dddad796amr664975e9.6.1757124870236; Fri, 05 Sep 2025
 19:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-8-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-8-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 19:14:19 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMKRbxd=4vNaCwOmKWRQtBRsGczzeoFa6tAj0HL1To0sg@mail.gmail.com>
X-Gm-Features: Ac12FXzn0RX1gdFQALqCYuScgI2lXY1l58-FKpY_B4t9r6rpfwJpWxeLh4avL2U
Message-ID: <CAF8kJuMKRbxd=4vNaCwOmKWRQtBRsGczzeoFa6tAj0HL1To0sg@mail.gmail.com>
Subject: Re: [PATCH v2 07/15] mm, swap: tidy up swap device and cluster info helpers
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y5yksszkp87b8w7ybn7e4qog586zy3yo
X-Rspam-User: 
X-Rspamd-Queue-Id: A4D0A160002
X-Rspamd-Server: rspam05
X-HE-Tag: 1757124872-235636
X-HE-Meta: U2FsdGVkX19ZXt23GLkaKw/CLWP6FuX5jVb6mUHkYJwGq2sZ9/DysCFV2V/2b/v2XkBjJsSX0jUVVVrCPOu0jE2SOS3IAFYFmNCmjaCgl2BRK0+cJ8SWsShvfMOeQSWJvxvPqaj9dNYbK6NxYMvjlMnocGO6yVghUuJHm4Yqop1mEOcge+RVkbrmgwP1vKVGchiv+3jylfW8jaFCXvv5hg5ft7tCJ3/DIg7oVAqQlqpHZkOWsPQqkzONze8IPrikKoCuYgYPU0NIXqi3cK+dcxW+Eudo9LiJeHaNVNUdlk2IwESGyPI+i0BH0+iJXzmh9KYvCCVcCr+EmB4exxf0f90M7LnOGsDZ5r6REw4U7KFuNvJTMnlLFjS3LUeMs40Vmg58ntQ1NcjSRc7eaE2gNSm5zEYgvgIow1Yr2ipegjS/ZetEWWRxCNLvfL9FshWvRYiPQfgFX8oKTEiNCTeXJ/3mCXbpOZhfpor0phsqmjn8SM6zEmyn1tj4+uu94MtE4f9Tsjx1+JinC/I0dT3X3iRkMfU9fuI3vnCAphjPEx7AoZCQxtr/9zHBMp7z0IYKmaTYXlqVZpbzTzMTkrVvCh8eMTdkoAaOxYsimLR9gk47y8OPA6VdOilW4aOuvLgtFBvkaLQMPki0I7/vEjA0GY76Y+b8+kil0aYnkao3Zm85Y59v4ksyT7u61Y79xjGaiLGlQVMBH28n6RatUk1zSuziWegGVAEYXq92iDGIGgxsnfz1hihsPFdqJTZTgYLC8OsTDX5KTr5jtoh1PdpnMXIpC70XJn2lOV76kw2BOvbNIIniTo//OmYb7w9sH9HNN+0dezj9nycYdO/IsQIGe10ZFkcn/zn4e6Wz+ltn4zCZn6diIYXqFanXBcUiYDP/IR2GseIEKvtmil9+715caDTTNEnewh9+vTdRjeKSgDVtZxpEQ8xIrKOJ0C6gspg9uA/iDfNXG/5M+oJ1Rx5
 rxiP7Y0r
 Rat2IgsQCyejEsXwieqlFMibyVk9yISBSOoKrZuiHWdqIjz9oT7+88PfG/8jwKcR2t7DCEwaZohCm9OSboY0Sv6z9MxVenNJTK0Bf9hVDv60FivxGjlL/XF15HgMZnOfgJElN817dNp/IMcFMmTkWyDlgAEudWu848PYCJ8asngzBe27HDHSNWLQjl7BKDoikyvUd1dzP+jG8izKyayb5gOL47faoMARmU6CpkD4zhR5QHAFW1Sr0cVupPFPfGnr43/731JEE5MYvKH/+xCXuMWtLXDiwnOnBkVBd5rmobgdtF06nlsjU2625mggdH0A7cAyv9831QIuuULjHJIjvMjVmQGLmSFtJFcQL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> swp_swap_info is the most commonly used helper for retrieving swap info.
> It has an internal check that may lead to a NULL return value, but
> almost none of its caller checks the return value, making the internal
> check pointless. In fact, most of these callers already ensured the
> entry is valid and never expect a NULL value.
>
> Tidy this up and shorten the name. If the caller can make sure the
> swap entry/type is valid and the device is pinned, use the new introduced
> __swap_entry_to_info/__swap_type_to_info instead. They have more debug
> sanity checks and lower overhead as they are inlined.
>
> Callers that may expect a NULL value should use
> swap_entry_to_info/swap_type_to_info instead.
>
> No feature change. The rearranged codes should have had no effect, or
> they should have been hitting NULL de-ref bugs already. Only some new
> sanity checks are added so potential issues may show up in debug build.
>
> The new helpers will be frequently used with swap table later when workin=
g
> with swap cache folios. A locked swap cache folio ensures the entries are
> valid and stable so these helpers are very helpful.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  include/linux/swap.h |  6 ------
>  mm/page_io.c         | 12 ++++++------
>  mm/swap.h            | 38 +++++++++++++++++++++++++++++++++-----
>  mm/swap_state.c      |  4 ++--
>  mm/swapfile.c        | 37 +++++++++++++++++++------------------
>  5 files changed, 60 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7e1fe4ff3d30..6db105383782 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -479,7 +479,6 @@ extern sector_t swapdev_block(int, pgoff_t);
>  extern int __swap_count(swp_entry_t entry);
>  extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t =
entry);
>  extern int swp_swapcount(swp_entry_t entry);
> -struct swap_info_struct *swp_swap_info(swp_entry_t entry);
>  struct backing_dev_info;
>  extern int init_swap_address_space(unsigned int type, unsigned long nr_p=
ages);
>  extern void exit_swap_address_space(unsigned int type);
> @@ -492,11 +491,6 @@ static inline void put_swap_device(struct swap_info_=
struct *si)
>  }
>
>  #else /* CONFIG_SWAP */
> -static inline struct swap_info_struct *swp_swap_info(swp_entry_t entry)
> -{
> -       return NULL;
> -}
> -
>  static inline struct swap_info_struct *get_swap_device(swp_entry_t entry=
)
>  {
>         return NULL;
> diff --git a/mm/page_io.c b/mm/page_io.c
> index a2056a5ecb13..3c342db77ce3 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -204,7 +204,7 @@ static bool is_folio_zero_filled(struct folio *folio)
>  static void swap_zeromap_folio_set(struct folio *folio)
>  {
>         struct obj_cgroup *objcg =3D get_obj_cgroup_from_folio(folio);
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         int nr_pages =3D folio_nr_pages(folio);
>         swp_entry_t entry;
>         unsigned int i;
> @@ -223,7 +223,7 @@ static void swap_zeromap_folio_set(struct folio *foli=
o)
>
>  static void swap_zeromap_folio_clear(struct folio *folio)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         swp_entry_t entry;
>         unsigned int i;
>
> @@ -374,7 +374,7 @@ static void sio_write_complete(struct kiocb *iocb, lo=
ng ret)
>  static void swap_writepage_fs(struct folio *folio, struct swap_iocb **sw=
ap_plug)
>  {
>         struct swap_iocb *sio =3D swap_plug ? *swap_plug : NULL;
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct file *swap_file =3D sis->swap_file;
>         loff_t pos =3D swap_dev_pos(folio->swap);
>
> @@ -446,7 +446,7 @@ static void swap_writepage_bdev_async(struct folio *f=
olio,
>
>  void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>
>         VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>         /*
> @@ -537,7 +537,7 @@ static bool swap_read_folio_zeromap(struct folio *fol=
io)
>
>  static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **p=
lug)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct swap_iocb *sio =3D NULL;
>         loff_t pos =3D swap_dev_pos(folio->swap);
>
> @@ -608,7 +608,7 @@ static void swap_read_folio_bdev_async(struct folio *=
folio,
>
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         bool synchronous =3D sis->flags & SWP_SYNCHRONOUS_IO;
>         bool workingset =3D folio_test_workingset(folio);
>         unsigned long pflags;
> diff --git a/mm/swap.h b/mm/swap.h
> index 39b27337bc0a..a65e72edb087 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -15,6 +15,8 @@ extern int page_cluster;
>  #define swap_entry_order(order)        0
>  #endif
>
> +extern struct swap_info_struct *swap_info[];
> +
>  /*
>   * We use this to track usage of a cluster. A cluster is a block of swap=
 disk
>   * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. =
All
> @@ -53,9 +55,29 @@ enum swap_cluster_flags {
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
> -static inline struct swap_cluster_info *swp_offset_cluster(
> +/*
> + * Callers of all helpers below must ensure the entry, type, or offset i=
s
> + * valid, and protect the swap device with reference count or locks.
> + */
> +static inline struct swap_info_struct *__swap_type_to_info(int type)
> +{
> +       struct swap_info_struct *si;
> +
> +       si =3D READ_ONCE(swap_info[type]); /* rcu_dereference() */
> +       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> +       return si;
> +}
> +
> +static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t =
entry)
> +{
> +       return __swap_type_to_info(swp_type(entry));
> +}
> +
> +static inline struct swap_cluster_info *__swap_offset_to_cluster(
>                 struct swap_info_struct *si, pgoff_t offset)
>  {
> +       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> +       VM_WARN_ON_ONCE(offset >=3D si->max);
>         return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>  }
>
> @@ -70,8 +92,9 @@ static inline struct swap_cluster_info *swp_offset_clus=
ter(
>  static inline struct swap_cluster_info *swap_cluster_lock(
>                 struct swap_info_struct *si, unsigned long offset)
>  {
> -       struct swap_cluster_info *ci =3D swp_offset_cluster(si, offset);
> +       struct swap_cluster_info *ci =3D __swap_offset_to_cluster(si, off=
set);
>
> +       VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
>         spin_lock(&ci->lock);
>         return ci;
>  }
> @@ -167,7 +190,7 @@ void swap_update_readahead(struct folio *folio, struc=
t vm_area_struct *vma,
>
>  static inline unsigned int folio_swap_flags(struct folio *folio)
>  {
> -       return swp_swap_info(folio->swap)->flags;
> +       return __swap_entry_to_info(folio->swap)->flags;
>  }
>
>  /*
> @@ -178,7 +201,7 @@ static inline unsigned int folio_swap_flags(struct fo=
lio *folio)
>  static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
>                 bool *is_zeromap)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(entry);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(entry);
>         unsigned long start =3D swp_offset(entry);
>         unsigned long end =3D start + max_nr;
>         bool first_bit;
> @@ -197,7 +220,7 @@ static inline int swap_zeromap_batch(swp_entry_t entr=
y, int max_nr,
>
>  static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  {
> -       struct swap_info_struct *si =3D swp_swap_info(entry);
> +       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         pgoff_t offset =3D swp_offset(entry);
>         int i;
>
> @@ -216,6 +239,11 @@ static inline int non_swapcache_batch(swp_entry_t en=
try, int max_nr)
>
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t =
entry)
> +{
> +       return NULL;
> +}
> +
>  static inline void swap_read_folio(struct folio *folio, struct swap_iocb=
 **plug)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9225d6b695ad..0ad4f3b41f1b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -336,7 +336,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                 struct mempolicy *mpol, pgoff_t ilx, bool *new_page_alloc=
ated,
>                 bool skip_if_exists)
>  {
> -       struct swap_info_struct *si =3D swp_swap_info(entry);
> +       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct folio *folio;
>         struct folio *new_folio =3D NULL;
>         struct folio *result =3D NULL;
> @@ -560,7 +560,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t gfp_mask,
>         unsigned long offset =3D entry_offset;
>         unsigned long start_offset, end_offset;
>         unsigned long mask;
> -       struct swap_info_struct *si =3D swp_swap_info(entry);
> +       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct blk_plug plug;
>         struct swap_iocb *splug =3D NULL;
>         bool page_allocated;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 547ad4bfe1d8..367481d319cd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
>  static struct plist_head *swap_avail_heads;
>  static DEFINE_SPINLOCK(swap_avail_lock);
>
> -static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> +struct swap_info_struct *swap_info[MAX_SWAPFILES];
>
>  static DEFINE_MUTEX(swapon_mutex);
>
> @@ -124,14 +124,20 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, p=
ercpu_swap_cluster) =3D {
>         .lock =3D INIT_LOCAL_LOCK(),
>  };
>
> -static struct swap_info_struct *swap_type_to_swap_info(int type)
> +/* May return NULL on invalid type, caller must check for NULL return */
> +static struct swap_info_struct *swap_type_to_info(int type)
>  {
>         if (type >=3D MAX_SWAPFILES)
>                 return NULL;
> -
>         return READ_ONCE(swap_info[type]); /* rcu_dereference() */
>  }
>
> +/* May return NULL on invalid entry, caller must check for NULL return *=
/
> +static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
> +{
> +       return swap_type_to_info(swp_type(entry));
> +}
> +
>  static inline unsigned char swap_count(unsigned char ent)
>  {
>         return ent & ~SWAP_HAS_CACHE;   /* may include COUNT_CONTINUED fl=
ag */
> @@ -341,7 +347,7 @@ offset_to_swap_extent(struct swap_info_struct *sis, u=
nsigned long offset)
>
>  sector_t swap_folio_sector(struct folio *folio)
>  {
> -       struct swap_info_struct *sis =3D swp_swap_info(folio->swap);
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct swap_extent *se;
>         sector_t sector;
>         pgoff_t offset;
> @@ -1299,7 +1305,7 @@ static struct swap_info_struct *_swap_info_get(swp_=
entry_t entry)
>
>         if (!entry.val)
>                 goto out;
> -       si =3D swp_swap_info(entry);
> +       si =3D swap_entry_to_info(entry);
>         if (!si)
>                 goto bad_nofile;
>         if (data_race(!(si->flags & SWP_USED)))
> @@ -1414,7 +1420,7 @@ struct swap_info_struct *get_swap_device(swp_entry_=
t entry)
>
>         if (!entry.val)
>                 goto out;
> -       si =3D swp_swap_info(entry);
> +       si =3D swap_entry_to_info(entry);
>         if (!si)
>                 goto bad_nofile;
>         if (!get_swap_device_info(si))
> @@ -1537,7 +1543,7 @@ static void swap_entries_free(struct swap_info_stru=
ct *si,
>         unsigned char *map_end =3D map + nr_pages;
>
>         /* It should never free entries across different clusters */
> -       VM_BUG_ON(ci !=3D swp_offset_cluster(si, offset + nr_pages - 1));
> +       VM_BUG_ON(ci !=3D __swap_offset_to_cluster(si, offset + nr_pages =
- 1));
>         VM_BUG_ON(cluster_is_empty(ci));
>         VM_BUG_ON(ci->count < nr_pages);
>
> @@ -1595,7 +1601,7 @@ void put_swap_folio(struct folio *folio, swp_entry_=
t entry)
>
>  int __swap_count(swp_entry_t entry)
>  {
> -       struct swap_info_struct *si =3D swp_swap_info(entry);
> +       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         pgoff_t offset =3D swp_offset(entry);
>
>         return swap_count(si->swap_map[offset]);
> @@ -1826,7 +1832,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int =
nr)
>
>  swp_entry_t get_swap_page_of_type(int type)
>  {
> -       struct swap_info_struct *si =3D swap_type_to_swap_info(type);
> +       struct swap_info_struct *si =3D swap_type_to_info(type);
>         unsigned long offset;
>         swp_entry_t entry =3D {0};
>
> @@ -1907,7 +1913,7 @@ int find_first_swap(dev_t *device)
>   */
>  sector_t swapdev_block(int type, pgoff_t offset)
>  {
> -       struct swap_info_struct *si =3D swap_type_to_swap_info(type);
> +       struct swap_info_struct *si =3D swap_type_to_info(type);
>         struct swap_extent *se;
>
>         if (!si || !(si->flags & SWP_WRITEOK))
> @@ -2835,7 +2841,7 @@ static void *swap_start(struct seq_file *swap, loff=
_t *pos)
>         if (!l)
>                 return SEQ_START_TOKEN;
>
> -       for (type =3D 0; (si =3D swap_type_to_swap_info(type)); type++) {
> +       for (type =3D 0; (si =3D swap_type_to_info(type)); type++) {
>                 if (!(si->flags & SWP_USED) || !si->swap_map)
>                         continue;
>                 if (!--l)
> @@ -2856,7 +2862,7 @@ static void *swap_next(struct seq_file *swap, void =
*v, loff_t *pos)
>                 type =3D si->type + 1;
>
>         ++(*pos);
> -       for (; (si =3D swap_type_to_swap_info(type)); type++) {
> +       for (; (si =3D swap_type_to_info(type)); type++) {
>                 if (!(si->flags & SWP_USED) || !si->swap_map)
>                         continue;
>                 return si;
> @@ -3529,7 +3535,7 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage, int nr)
>         unsigned char has_cache;
>         int err, i;
>
> -       si =3D swp_swap_info(entry);
> +       si =3D swap_entry_to_info(entry);
>         if (WARN_ON_ONCE(!si)) {
>                 pr_err("%s%08lx\n", Bad_file, entry.val);
>                 return -EINVAL;
> @@ -3644,11 +3650,6 @@ void swapcache_clear(struct swap_info_struct *si, =
swp_entry_t entry, int nr)
>         swap_entries_put_cache(si, entry, nr);
>  }
>
> -struct swap_info_struct *swp_swap_info(swp_entry_t entry)
> -{
> -       return swap_type_to_swap_info(swp_type(entry));
> -}
> -
>  /*
>   * add_swap_count_continuation - called when a swap count is duplicated
>   * beyond SWAP_MAP_MAX, it allocates a new page and links that to the en=
try's
> --
> 2.51.0
>
>

