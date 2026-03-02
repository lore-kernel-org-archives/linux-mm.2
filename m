Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1AFE9B369
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354586B0089; Mon,  2 Mar 2026 06:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8656B008A; Mon,  2 Mar 2026 06:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182F26B008C; Mon,  2 Mar 2026 06:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02E0D6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:11:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B3F8140B36
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:11:32 +0000 (UTC)
X-FDA: 84500857224.07.F244D5F
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id B622F180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:11:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRKILuQR;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBQy7eZessix056CdtvHLZ0f+77kyGULYEb9Fwkrm4E=;
	b=shyarg5ae5X/2W65lLnS00VfwRj2yj+Xra+SIzmr3WG/rTIlGzxJqBGLogUJ5pyATEPcT9
	RiLsa8+czkL/9XYqQnVqXihqkkbgIPyDtc5DXjoQoP5mcKjfH5LmVFDgCgrkqOGTxrGjJp
	kfZwS2/1d5LB/rSbw0ROugSavvlD1ts=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRKILuQR;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772449890; a=rsa-sha256;
	cv=pass;
	b=DR1BJZs6oKHbHLPPIKKVPnS3xhRIARhVFsy/1+X7Qjys6RIAgP+gQ2GEn+ODiL/D86XkGv
	3j2In67OT0iyKBgWAZIHUxnosQXJstYHd9YLxjnLZlVx1TxgQmGi6ivFSw9Iduz4vTFT5M
	2MRlMyykjNiF3m/Pw8Z/bV+8gBIEAug=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8954c9daaeaso53250966d6.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:11:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772449890; cv=none;
        d=google.com; s=arc-20240605;
        b=IqKGQI+PjV43mNC8GcN42DEOg+oKLknkxBahzblYbS6kRmzLSHjhENEQZxOlQ1/Rsk
         hkTZqb3gth5tmfz5ocU6csDGJ+FCprcUEKKH+7fDEfCZDtsIS7vJxMUN1kvacv4xCHY5
         6q0IEZECC7M1i2d5a0mR2s8UgRq+kxxFIqjmDXgKYhs3M5cklz4yjv5yb12YyWjO3dig
         xXC1Oe9/LVGSkqAl/ffmVe+hUB4I9iiwnK51iHymXUaTkWIKJu9df2v8MMSWFwK5Jybp
         hF3rTNkzqjOR+31eZVf+iWs8s67btsfIAA92icDNkDDhrh4q+SvBXPhvbGVGUSiQblDW
         XLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iBQy7eZessix056CdtvHLZ0f+77kyGULYEb9Fwkrm4E=;
        fh=02cpICd3uJ5SYLGchF8XE0rIJ+s5rfjG8IVpQUFEOFM=;
        b=aM7FH0eD8xPd/m18ZNbNB3U+uw1DRTD6tVVVTbcoMadRWiANBOvvN/WNkV2vXZR3Zg
         Cfrb+V3lHugFBUGwptLYn9kLQFqu8T+n/O+p9WylnNUqgcCVEgyC6qtaDDUlfPgI53Ho
         v6KpWXF5xlY8egMHV6/bo9exchejfyCT8iQvxB2grWCch7Y5hUYVBrzAlIxZyKoR2q3R
         6OEA1rsHOKwBMe0tGxuTFsZYL3q06jXTOV5EcIw8pHsFxli1RGCICgKM+yMAR9NSGaCx
         7wJlw9kCqmGvNcx4g6gpRkFUimKqQxbr3jOlUIkgE6rQawO7H739MGXZadsHurRuq5sY
         fS+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772449890; x=1773054690; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBQy7eZessix056CdtvHLZ0f+77kyGULYEb9Fwkrm4E=;
        b=VRKILuQRtkvuMZdSZlzXp4ZtlRBzEfSMlV5ei3EGLM3J+cI+rpVc59QAjN6RlvvzXZ
         ySkqwvpppkaNx+QsFCKqvXp7L1Mifq5q/EnLQ6eBff1t0yNuoV6gYajpQOlq+COfJMsT
         LuWB+DcffI8C6qVnE86q46SmsJGs2T9nY1x1td3QOoxLBxEClYoeR2VxZt+wbl/8Kh95
         8k4m9NiT3TKpsTAA//DCvJO8YQmfUBNvkJcpAQ+ep19jVEWbVbG/GwCpMSdMh1eThPbv
         AGRRlEzOFhyUEQl2k1S3oYLCcKADSCk1xgvBs/urX7TWATnTayZ1EUsJ5ybw0ruB9W6H
         gxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772449890; x=1773054690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iBQy7eZessix056CdtvHLZ0f+77kyGULYEb9Fwkrm4E=;
        b=xEPosEBMfowJFhMPxt2PnFYKlCog7/rxpQIQIarnIf9i84a0nSgaRt/+XNOqwoSWZF
         ggEF3osum8XFmq9LUAYNhA89LY3xlN3NjQAIYU7J1dvCEHdKHujUHzNDlYkoyHecGJtv
         lZ5Qee1fJduX/9JxRSMprTt3bRBFpPFOvK+TgxK+Y/LbvBLqXpsrp8V/ZNEwelsSCWjH
         jFdb4OfLqWFskZAYe+09F5Gch0KZm2+i8+lxHC30L6zphZi54n8+G+NvsjXtpkf2jXqx
         wR1dkh2sfjrIWUfrozuKggNfoXITkDvwQB4mhvSnq9V/MEY0NQCJnfmf/4fTAeDfVGZu
         suiw==
X-Gm-Message-State: AOJu0YwQbvwxaHN1CeUlGNg2gIYUVdoHvmODIn4Rz7ye2+OygPXuS5Ze
	3Zpi1ieId+40jWovp8e203Sbp+v641QF0ijlCKLpgzTELxEFmrCw/YuGaa+FiIFmkhwfHH0hhbr
	lBV29Ucpi3CxNC1hCMOM3wnOCra4k5NI=
X-Gm-Gg: ATEYQzzA4vh54kLE5H+fHHFuhV1HrglideyRBL3fSlMFys2jKBzHK5LV2agjeeBxXkb
	Xc4z4u+ZwgN0pwP2eTEnG0sJPBEQzFELAGKn63XPR3yzNM6RBvx+57XWnpvPiWTCoiIfQFg8dPq
	wwokDX3VSy+xXgMkCEFXg2Gf1Z+BOPPMOfrQldzCE20xRPZFJzI1VbWZGN6Ztbw4XckIl8R0cpA
	+55d4q6nnfqHUfkZOrsvXlSwC9WlUpgY+I/CoqzM6YnB8i/gQSNrHusEXAPq6ScU55CY/QrOEKe
	gmQAZ27DJBtxh4L6
X-Received: by 2002:a05:6214:529a:b0:888:3d3b:c9f8 with SMTP id
 6a1803df08f44-899d1e3b43cmr181749236d6.32.1772449889484; Mon, 02 Mar 2026
 03:11:29 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-3-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-3-bhe@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 19:11:17 +0800
X-Gm-Features: AaiRm51Z0y_O0x1581sEd_xOgO2IUpiW2PFp2qlD6zGyDoBdq_t9D6tJIH3YswM
Message-ID: <CAGsJ_4z-TB3qZ1t0H1EgB8ir-eut9oLeFMP+tn2oM3PVco2h+Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B622F180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8ss85a9wntkenj4zi1zt45iupeckk4p9
X-Rspam-User: 
X-HE-Tag: 1772449890-483076
X-HE-Meta: U2FsdGVkX18QlRIwggYTqqCHGnvJSp8TVIZ5CRGhUHmcufeS5BpLxB0BUNgXB5ayGZQ5OsZCcwVKN40mpCbMxgXfh6jNnVAWhZzvjOF8dcGKyF90FCQa6e7u7007eGWb3xLUBVFbC6hwo25dXogjxVrMNooxCTxwB1HVi7/rWE/mAm3HrgFCYP2taKMVgBqYfnXxZQGicxvPew9InDwnUJrY8NjhZZRm2266x7JJfAn99mNj/n7c4LLKWPGblCXpjMuQ4xubUekfi1UYtJ9mEXNex7nz3lQxQcocpnDk24OMvsIwPbLjlhjJughbr5ob1CzzzX5LZBj+IqJ8JzgKV2nl+tXgVXaxBkfHvO7rVagqyEhmdsvLwOlMTH3sZK3DG6wSLhjxCbmUD4oA/JM8p6x6nwuSHD/UiWrlPlavs/vsiylSfXw9JvH8QglVFtPlA8BwjSaK18t0Z/1lOVNJm+ekDD8VOgg1Yfpd+ic//3Cqc9OmNenNsKpdxSbJaHoxuNB2fxAR57i1LOgGLggp2L0DnMPyjb03+HZHE4oCN4DobhLwyOI/P9oqLpOJV02Az2ICBOJcUDD5bg+IcyWhQG/r2YhRKvma1xOT9hTU8jH4fwadJhGieReNSz5c+qxK9unrhTIZCeDydr/ci51ESR6pOCvidFtudkiLxyNW5aKbc8JbUIX2xMq6yhMGQh6iEupZwW8pKqhbLsJnRaksaJKOZEuhL6DBD5Ta+UVofBRcYvlwD2fdbVRPhyDoSNAUds6327ZE3/4/u5DPuNp1WxlF06QmdGZ2knRdiZ1IAYDjUDkQzplwTW4Ibq7194uhLvZrZSwH1dgTf6REGrWsEWcUkj3HFMY881C7VS8dr9364GecwdWA3izlnZq7zRwbbWHv7jxU+NDBB0VM7wqSr+baur53LV3FEZXZGEm0BmeGp/7FwF2fXCyGo03NzkjyyhcYeQm9Q2Kkoh2Posi
 9r4bKcOP
 x6q+kvlTJ9KR2a2q1HsCbBwVIAPi+YAhga3beUKQHow2LlmAXHfsZuBpWhzDX3zAJ000awhKzbKKt/uchDzI0bVpdajFhbR2T8uRfRE/jZYp9dqZHmakaJ/ymbZ3PmWfDDd95djdgDCwA0qh1zZptqdAegCekrS9yFg4VIHkB+Ssnyx9arlI4POckaGpdw/g96jZe9kVizWxJd9Ohme9ZZFm0FDE9XUxnX7LJf6r4jbup9qxvkItLuMFAurtszZu0JsjnS3oUW48gTLyiPW/EAvcEdMznBfeH4ZH5RBzik5QCbLp8u8Fxn/LcjCf/nmIoQ0KkKMOtkKxKuS2y0/rEs8A1/AfmUAHYPSkc9kLENeyQXf4w+/+e94BzycM46Hbwxzku2zQ0KfYggQ3BvLkYuWa7RbW/u4fUD6LoAdGuNaEVtybo3CIp+qTsNLBs1n5c5IMj9NbxNShAzyx7YfpRhmF41ZCr1rmVD0r+xM6cictiLw9j6ipJSIPfQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:40=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
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

Does probe_swap_fs sound a bit odd?
What about init_swap_ops? Not sure if we have a better name.

Do we really want it, along with swap_ops, to live in
include/linux/swap.h? Could it be placed in mm/swap.h instead?

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

Do we want a swap_write_folio() wrapper?

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

const?

> +
> +static struct swap_ops bdev_sync_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_sync,
> +       .write_folio =3D swap_writepage_bdev_sync,
> +};

const?

> +
> +static struct swap_ops bdev_async_swap_ops =3D {
> +       .read_folio =3D swap_read_folio_bdev_async,
> +       .write_folio =3D swap_writepage_bdev_async,
> +};

const?

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

Can we move this to enable_swap_info(), or perhaps even
deeper into setup_swap_info()?

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

swap_write_folio() inline wrapper?

>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> --
> 2.52.0
>

Thanks
Barry

