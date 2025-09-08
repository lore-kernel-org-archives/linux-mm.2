Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03AECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486356B000E; Mon,  8 Sep 2025 11:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E5B6B0010; Mon,  8 Sep 2025 11:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374316B0011; Mon,  8 Sep 2025 11:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26A276B000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:15:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A90921601CA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:15:13 +0000 (UTC)
X-FDA: 83866431306.01.B10341F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id C784380003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:15:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nH9y+YEn;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXA2Jum3C80Q1Y4JkqkK6rtU/2eiC3aTbCjeS9iNmzA=;
	b=Vrau3bVPfLtiqKBVqDIz4d5HFnf239tLzDFa2K0VGuHC1kDVARBqSQkR3l1Gh/MQ6eq0MZ
	FzIyWqtIZSNZeL61XMJXT+vww/RoNaQPt2vmeKeXpI8cwFLQCGx7W1FGhDUVi9frRLuTJ/
	/LV3FNLSTuKFMSlbVxs00uiUO4a45B8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nH9y+YEn;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344511; a=rsa-sha256;
	cv=none;
	b=n4CgEYry+qpZBP/E2PxDNB5fwZGG5aSqT3GoD5G/ZJqdS9innLNd2lMYNCiGE3rbUN4App
	inNwl5RgpofyCd78wIU9vyoqZ2qSCr9I1fx18ADrFtjRI96URLhO0yoXGixd8Q8UH/VDKf
	QqYEaV3//1N9aiOjlb28Sa8unmhrNG8=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62733e779bbso1032358a12.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757344510; x=1757949310; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXA2Jum3C80Q1Y4JkqkK6rtU/2eiC3aTbCjeS9iNmzA=;
        b=nH9y+YEnWywti2TLKlX5uh6Hfq9rvmwooG7pK7dxvfsTxvlw57Jklt7Urm+ADLpG/4
         l5nFQe3bAA4QDOWAwWBjPaay4EnoAtVfxQxmv82COb5uex3IBKmlotJHXExwFmnl64eb
         tYxt3IODtqKIAilbUhVr1xhfnvAK9pNMOw7dxv2JtCGModRMBUkImWBwzDdbOlCuRfU9
         ckh7Ue3Jr4aXoADlAXsVqRf63Nw01t9emTZLJpTd06GqFIRgDmdAi6ocp0vB42Hbdu2E
         4OqTzHyRTCGNt/G9aUjiBSsTDPAFEhBfmo8K5QdGaA8bjcwKXKjdFndP87cuxn5m1jf5
         ss/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344510; x=1757949310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXA2Jum3C80Q1Y4JkqkK6rtU/2eiC3aTbCjeS9iNmzA=;
        b=RxByGmImQFT1D7swNSEfUSEL1ZDMXCgjgrgmUWlgQCQHzLrvaMFA7bi30LKFxTN3M1
         iMWkqvl/NH54EMQ/ngsSoTxos87Uubtn6fXrVeylYTEfGwdvVWCZHbufkMRWzoKgof4L
         0XGzfpocwl3oQvDZoob6ID4Bih5lKU9oU+yb/WUbDLrjoZ39uzZrrE4pJ+mW9/AE7cTK
         IvMGCwp0s3TVTlMRsH/zmj3H6Yf2VnXpgTEnC5P3cKlU0dXfMpzh7Y+Dm7fHmLTGAXvQ
         XnKMhozt+HyZUN8Y8Pf6JSBAym7acAXqBFaAG/y4IafpWx0NQVlZGZRu0TjNH2pP+0O2
         /+cA==
X-Gm-Message-State: AOJu0YyCySUPPovgUCO+hX4Wy1YuFKW/sNMBTv2WNJ1bNZP1VD/Lzw4f
	pAMBHdfxl2+2Zjx3hpJK5UZcQhgzyrK4xngKt2XWPQi1eQx/xWs4l0CZtRgXdKriN3TFSWrR1D2
	0p8wgX1W8tYPyqqN0zt8MHGpCb5qNB4Q=
X-Gm-Gg: ASbGncuSEnwupMoCUYGTL1jbzF01Yxl5RNhBL7iZIMnPPfYVOqTtdefv1+nnwpz8WEZ
	NgxLa1WRQQcLuGF4NFJADTfuhkEdEuhy++DBCxwCjA/vI2MjRCjkh+Mv8orRL9QTo1pKCFTfdW3
	2SBYjfN4Bp5qmPp6sP5bIVVdQ4eme0ajQ95Y3ri0AfLVB5zwdv+6bryZuf0uBVZgsA8fNrt9Lon
	1DxZjT/rVG3s7tZVBnbqg==
X-Google-Smtp-Source: AGHT+IFfzgh7slkI9APLqBFcPALe6N6LfPwpqVZHZal2suURwJH/Q0oQbDMfDqtIwsdF4Gq5DaUCBzS9zexyL7jPqeM=
X-Received: by 2002:a05:6402:4415:b0:61e:a5c8:e830 with SMTP id
 4fb4d7f45d1cf-6237aec0166mr7232307a12.1.1757344510250; Mon, 08 Sep 2025
 08:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-12-ryncsn@gmail.com>
 <4e0847db-0503-406b-95b4-02ee7e8f9604@redhat.com>
In-Reply-To: <4e0847db-0503-406b-95b4-02ee7e8f9604@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 23:14:33 +0800
X-Gm-Features: AS18NWD12hxIhTxyJKTGDZ2indGJ3CbXeECCYM7JzuKXWB8xNJgaDKDEKpvdK3M
Message-ID: <CAMgjq7DwOe_OJ4qyfY-2=kmaY4tfvQGaedie+6NvPPX7YD0YGA@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xnkjrop3gruf87c3robhgo5qz3ceozuq
X-Rspam-User: 
X-Rspamd-Queue-Id: C784380003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757344511-298111
X-HE-Meta: U2FsdGVkX1+ZFCW2B/BEvtDvoG98ymXMGMm5VkPgrSIwL4vCCyrJgVvO5C9XOZov2BNQvaWzLUQ7QyF08tpeaYglYFJYmP88zmgyMviR2Rh4H/E8zpLFOO2aB1+IAQo220D+fu9ErWjA22tikhyVWXaVKQtuGYsQTXjq3Xy7TVRmP2odr363yDT0hgWsoZfGRw8UBCnP9bLD3LrX2izTb20etmoQl7IoRqpDofb0SlkmBxn/K9o76PHvrJzSbI8zXJ8rRzx9tC/bl9mQnUjZ4R/XSCIS4xSdO+/N8pFffvTRTUP47O3LpX4Rj/Lt1CQdqnfehCbcOYJaaDxo8E/I1az/kef9l7BRCA6GPW8dAlMcN6v00wpnr3acRoYTa30BLXsv5JgYx8X5aeGASVwdqkmclQei5xezKFibfiiiNKioC28KZDoq5fOa7i6EJhkAMxPD0mNht/p+3VF9LDBoPGv+wlLT1BRoXt+HZeZE2v5VJPdQ1euLjNFQoO4iUvYf9E9lOBMPSnRckk8w0TbMyPiAARwrrJsveiyyaR2kr+mLnfCj6jBL0PxrorRBUy+l5pF8dYqlQoqB2+9HoiSKAeY4lUW9aqA8uqgWbuGv2dRTd5zv16ED5Zf6EJWvfR8lZnUuq2V5h0wm7TvJ1IzOILkWpQ7g3pTnA5/k1Yp7vijmdLKzXyapuNi8UziB6ZvWr1e9wSa8yfY6Ln9CSjwQZeksXzMqgIbDOc0Z10Lzdkycq8cFMj2bWBfYcPfCoxgTcfiSMUPEABiMDtU+Wvkd8HAuPHw3TaR0lANFfHgvPuPvEWZY5lwHY2ddRWnCG0Enb+6Cp4l3PC0wtxxH7sgYmJlfhcRuom9osq5kN8hcATIqrzDS9bcU22BzHJBFgKiVrrqEahmjknT4KTIT8MW2/Hq7UXbZbAUVOc97Py2bV0A3sphg9WJeOXND5mikFHpgbcaTXTrIynzMfzOdWr1
 B8ukk2Uu
 2L+sgJPipCllvyei3ABAq7guUlii9ni65cB8gFaBs+qaTc/mo/HMIFJtcB4O+6lDyjmFsAIKT2oHGUd/VlZKQzG1UMV3BINGQmBAIcThGxKho54T6WPyzzPJxK80uuGinG3j1VizjvXgkwUlsw+jvrGOgucgps2IzaQBjyxNKIWEzdYeV5s7M7fQK+kGnBcxSdd0LTxZIIi9Ip16SacbQR72m/pGo5reuFnj52s7JUsQ0ZGu7zPnLWsmnTQ/1y71F5TQwBVHnYfKjY4Esj5/ge6WlI+LdXL756xNV1KAvUCjXI+p8fwqGqrnYNejllcFfwdbZwiyXAaBTpnjzSY1uOp7U9QorSyi4LaLoyacxtOS/3B9fHoyFQcoXj1cH/0fnASCgLRSyjP94D4p88MuLmjxf2LTwcV+Z1f8L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 11:09=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> > +static inline struct swap_cluster_info *swap_cluster_lock(
> > +     struct swap_info_struct *si, pgoff_t offset, bool irq)
> > +{
> > +     return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> > +             struct folio *folio)
>
> I would probably call that "swap_cluster_get_and_lock" or sth like that .=
..
>
> > +{
> > +     return NULL;
> > +}
> > +
> > +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq=
(
> > +             struct folio *folio)
> > +{
>
> ... then this would become "swap_cluster_get_and_lock_irq"
>
>
> Alterantively, separate the lookup from the locking of the cluster.
>
> swap_cluster_from_folio() / folio_get_swap_cluster()
> swap_cluster_lock()
> swap_cluster_lock_irq()
>
> Which might look cleaner in the end.

That's a very good suggestion.

>
> [...]
>
> > -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> > +struct address_space swap_space __read_mostly =3D {
> > +     .a_ops =3D &swap_aops,
> > +};
> > +
> >   static bool enable_vma_readahead __read_mostly =3D true;
> >
> >   #define SWAP_RA_ORDER_CEILING       5
> > @@ -83,11 +86,21 @@ void show_swap_cache_info(void)
> >    */
> >   struct folio *swap_cache_get_folio(swp_entry_t entry)
> >   {
> > -     struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> > -                                             swap_cache_index(entry));
> > -     if (IS_ERR(folio))
> > -             return NULL;
> > -     return folio;
> > +
>
> ^ superfluous empty line.
>
> [...]
>
> >
> > @@ -420,6 +421,34 @@ static inline unsigned int cluster_offset(struct s=
wap_info_struct *si,
> >       return cluster_index(si, ci) * SWAPFILE_CLUSTER;
> >   }
> >
> > +static int swap_table_alloc_table(struct swap_cluster_info *ci)
>
> swap_cluster_alloc_table ?

Good idea.

>
> > +{
> > +     WARN_ON(ci->table);
> > +     ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, G=
FP_KERNEL);
> > +     if (!ci->table)
> > +             return -ENOMEM;
> > +     return 0;
> > +}
> > +
> > +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> > +{
> > +     unsigned int ci_off;
> > +     unsigned long swp_tb;
> > +
> > +     if (!ci->table)
> > +             return;
> > +
> > +     for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> > +             swp_tb =3D __swap_table_get(ci, ci_off);
> > +             if (!swp_tb_is_null(swp_tb))
> > +                     pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> > +                                 swp_tb);
> > +     }
> > +
> > +     kfree(ci->table);
> > +     ci->table =3D NULL;
> > +}
> > +
> >   static void move_cluster(struct swap_info_struct *si,
> >                        struct swap_cluster_info *ci, struct list_head *=
list,
> >                        enum swap_cluster_flags new_flags)
> > @@ -702,6 +731,26 @@ static bool cluster_scan_range(struct swap_info_st=
ruct *si,
> >       return true;
> >   }
> >
> > +/*
> > + * Currently, the swap table is not used for count tracking, just
> > + * do a sanity check here to ensure nothing leaked, so the swap
> > + * table should be empty upon freeing.
> > + */
> > +static void cluster_table_check(struct swap_cluster_info *ci,
> > +                             unsigned int start, unsigned int nr)
>
> "swap_cluster_assert_table_empty()"
>
> or sth like that that makes it clearer what you are checking for.

Agree.

>
> --
> Cheers
>

Thanks!

