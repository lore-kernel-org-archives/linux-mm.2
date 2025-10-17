Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F377ACCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 19:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25918E0009; Fri, 17 Oct 2025 15:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD798E0006; Fri, 17 Oct 2025 15:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39DF8E0009; Fri, 17 Oct 2025 15:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B38518E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:11:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FAF31DF223
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 19:11:34 +0000 (UTC)
X-FDA: 84008550108.03.366CD57
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DEB1120002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 19:11:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WzOsduJI;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760728292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhR7N/1fveVtt6wxaFP4nn/bZMr+K94/sut3rmsfdTg=;
	b=b180NaF5nfbAeOaI/rx4gG0jVPyG+hXzi5CvKPrXtv0kTCZDo09ghwSzLQjVMDG5e7D12I
	QV2Q8fKgiMe3593zFPy2tQGvYSQMMYyzZTl5DBbPipbM0RKY7Wpkila2RqqnzPy9ZQl7aH
	uzJho8O+zq1+4nDLIl4mYAVPoIqwCNA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WzOsduJI;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760728292; a=rsa-sha256;
	cv=none;
	b=UfUdFQcsbaf0x+bnDTNkNeIEQDQwlTqsCCf+9Tqu9LMXuwo32VIEK2YqH50Bf0emDqjgNn
	ASyZasA/F8ImsL72M4oyLIvn6sL+SRyuP9lqiTOAtY5uxBe6BwdToQ4BskGgtUCvXPellu
	sK0mepbm/c/WSk8d3n8UGEZJuLT+YJM=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso439995466b.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760728291; x=1761333091; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhR7N/1fveVtt6wxaFP4nn/bZMr+K94/sut3rmsfdTg=;
        b=WzOsduJI5Rl5l4Tu+Nr2A32hdH62qi8J2CYdbKnXgBCJm3eVoVUySsh+vCKjnxM4My
         gkyc7KKm/RkbMwdfCSX6/vF8hj02MgiHsZLvxdku/JLC6kg9+T8SSAvh0nUdhM6P7dyX
         AVMK+mUC7mVXXNT9Va9UDJG4kKbgw97uR5wLGk6h9qv1zgaFuQTt7SZ6WpxeCYUwySI1
         JG/GtP/mmdR4BsVGscQ2SC4pw7vaaRwtSyQyWc0JEHFvHOjkFSB/J8xu9zPhXqKgvBCO
         mr2uyaI/AH9b10BWgm4XcK0au07sd51BW831HpdAHel2bEOY0YekINB+QdpjRFx2/EDR
         fLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760728291; x=1761333091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhR7N/1fveVtt6wxaFP4nn/bZMr+K94/sut3rmsfdTg=;
        b=RZybwyavJzkUj5vrqu6gJFhuX/Qsx2jn75oqpuwz789Xz/kNjnLCp31N5H0ath9DK1
         pnBypnB709JOuQTnRdRhKSwmOTejOvWJ4p0lvaywHNo1OePM2taAw0j/UpnHqh96CMt/
         1ByIZ9yGQsh0QUMNmGjJve1RpailsDph24nLqWXkwsXsKHNzkxSZup+fYQfsxA961ejM
         8FWbpHUsSV4T13c1cP/I9qLrbVBfqBYeDWY+hMCGEMGIGoCHDGdZQa49T0SrXPwzGZdm
         GVk1j5PdRoNnbCQWDjT7Uju9QNAWHhHbymjptpzn4KSEh1YjNk67IKldu7vykDRvtzX7
         w4ig==
X-Forwarded-Encrypted: i=1; AJvYcCUvm7whQ0PNhzwJL3h+xkphfz1cdWD2lwHwv5z5LmWYimCAIPgg7MYmtTB7Un24m0FOb+CVBOADSw==@kvack.org
X-Gm-Message-State: AOJu0YwE0zf4l0w0TxmGt3vYlYZJZuDLstF1U54AarCtf+RbDT2u3wOn
	Qau5jF5rgkVROJKNSea/hL+EtjFUVTqAYt/MM5ZMJvY6UZoOzeHU25tOJ2mdSyBbTH8pNSa7f4A
	RSS4m3qcLLGBvGnCMqBgip5mBKStljrg=
X-Gm-Gg: ASbGncvlf1ihCzl5ReS1n1N2THgqrSHzoqcwSIlz4L/ch4lrcQW3gZjf0miJcIlDBJs
	DdvT8D6nRoZJ/N65Yst19Oyza5c3ZKRvwLiIVShsbLXRMJ2D1ZNE5ptp/kcnxtR4ewJhUuzt9FB
	UWmSHkkkQJp90ML3rSr/ekG4muqndnzPTIZvbt2J89bNCJhQJF48++lWcosg3Yrnsniq/AfmZMj
	WcB2XV2egJ3beUzovfIwFJI4fyqN0xPoC+rKO0QQbfHA0qPjXkhJ4xBFjZirwo7oblnzh9YCVjV
	1GIX0g==
X-Google-Smtp-Source: AGHT+IFDOlJ6XYwDeGzUOeuUv7tu/n9jNAnoTgbcA/YtbUqQ9ooDi0ZvO1Y7Lz1HWF/EaVHKgjB6T0ljyIDFi13wLII=
X-Received: by 2002:a17:907:940f:b0:b40:e687:c2c with SMTP id
 a640c23a62f3a-b647394ce7fmr469325666b.37.1760728290384; Fri, 17 Oct 2025
 12:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251016033452.125479-1-ziy@nvidia.com> <20251016033452.125479-3-ziy@nvidia.com>
In-Reply-To: <20251016033452.125479-3-ziy@nvidia.com>
From: Yang Shi <shy828301@gmail.com>
Date: Fri, 17 Oct 2025 12:11:17 -0700
X-Gm-Features: AS18NWBFTKLOBvlIpa6FLOiYX2FyPcTBMCd4lweftBhZd_zGhKkHrG1wKzTNxSo
Message-ID: <CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio handling.
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, 
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DEB1120002
X-Stat-Signature: 9jtb8ewgj3py8nptc9h35pd7h8kty71a
X-Rspam-User: 
X-HE-Tag: 1760728292-114286
X-HE-Meta: U2FsdGVkX19dRPkgJ7diS4Ap5SJAq2xa7GrrVaWa5oouHJAtQqPT66wGNhZS5R7K2FZY2zJ113HWJoimjd0zHzcH77Rjx4f4fV3KcuSZMpHMe6rsYL0BL/vMFgrTCi828vSxxIZ1jcq5Ge0rGKgG/a51XeBR3M2qY84HXoHaE8/4FddHPhpfMnvrzpKYAXEahf+nWJnej+75GXNwS4jylN5VRzPTYDg26ruWoub489msLU+JBnEXwaYxOZPaQYJ+2KKO6APeOrbT2Nbo8skFQw7dZISS4SLy4zBsHQRQsjD72WRkeBS+H6uqDWovM5/H8Nyq3SoJg0J+9pZvkoB0QaGcwhMPvNb2GxFgXQv2qwWYnRDAuhyp5nbGDlSL1dvepzCHjYSwXkvrFcXY9yank4c9f/8dAiZNIktTNDbCdgtZSwKkzM1bzc4XAzT8tHIPJFpKebyUVC2LQ5N8LGRYbKKvh0KOGb0YdIBa3SbP4bDWWvJhI08xP7LoNXZKUZL+yAtXUb9U2yW/YDsIVQaLcryixibFZ+2bMo0K8/vXJsYNUQHb+s874aMs7/j2VbBG1J7Xr+zsTKMoZScFQSPOfbZINJ0ZlJzWmIubmjrL1v7TMdojtgtxeVOTuzoO/0qV9K+cYEiPx+uUrKPnQjC/CnutNHw1lV5RmFYOGpNUzmfYxkI2ZoSmJt0dsu5xaZeetBUjZvRUNJPbmyIBmgayqaCB+sW1/xUX6IxQ4rtFHaYB9v0Q3wep9SIO1eBC1gUgwbGNF5xiSJyjr0tBgnOKxULAFGAoiSN0Th41Mx7CiC9sjr/cuAVwMweKnxACU3MLYdfV5o5mASCi6YQK3M24iwBndtA1KNn3dGq5RINJ6k2Q1xwRtOJuzY8AXxrCiU9gu4vYoiUAKRm0t12iGK+2G4qCKKE79CbepGjjLT3dGHvgByZdy1aM1J4w+9x09ykADfWcC8lRWoy+usfwvXx
 0I2crYsc
 qaKWa/NQf7rEEqLDxwioRvW3VtoU2e5zFM7cVfZ+m0LrL5BH6sPy1zCEWu9E+viQFYXLqJ35LEVCyT/q5YYeoAlAdmQjC4L7jw06ReKeff1j9iGP2wbhzpWz1hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 8:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
>
> For soft offline, do not split the large folio if it cannot be split to
> order-0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.
>
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  mm/memory-failure.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..443df9581c24 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn,=
 struct page *p,
>   * there is still more to do, hence the page refcount we took earlier
>   * is still needed.
>   */
> -static int try_to_split_thp_page(struct page *page, bool release)
> +static int try_to_split_thp_page(struct page *page, unsigned int new_ord=
er,
> +               bool release)
>  {
>         int ret;
>
>         lock_page(page);
> -       ret =3D split_huge_page(page);
> +       ret =3D split_huge_page_to_list_to_order(page, NULL, new_order);
>         unlock_page(page);
>
>         if (ret && release)
> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
>         folio_unlock(folio);
>
>         if (folio_test_large(folio)) {
> +               int new_order =3D min_order_for_split(folio);
>                 /*
>                  * The flag must be set after the refcount is bumped
>                  * otherwise it may race with THP split.
> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
>                  * page is a valid handlable page.
>                  */
>                 folio_set_has_hwpoisoned(folio);
> -               if (try_to_split_thp_page(p, false) < 0) {
> +               /*
> +                * If the folio cannot be split to order-0, kill the proc=
ess,
> +                * but split the folio anyway to minimize the amount of u=
nusable
> +                * pages.
> +                */
> +               if (try_to_split_thp_page(p, new_order, false) || new_ord=
er) {

folio split will clear PG_has_hwpoisoned flag. It is ok for splitting
to order-0 folios because the PG_hwpoisoned flag is set on the
poisoned page. But if you split the folio to some smaller order large
folios, it seems you need to keep PG_has_hwpoisoned flag on the
poisoned folio.

Yang


> +                       /* get folio again in case the original one is sp=
lit */
> +                       folio =3D page_folio(p);
>                         res =3D -EHWPOISON;
>                         kill_procs_now(p, pfn, flags, folio);
>                         put_page(p);
> @@ -2621,7 +2630,15 @@ static int soft_offline_in_use_page(struct page *p=
age)
>         };
>
>         if (!huge && folio_test_large(folio)) {
> -               if (try_to_split_thp_page(page, true)) {
> +               int new_order =3D min_order_for_split(folio);
> +
> +               /*
> +                * If the folio cannot be split to order-0, do not split =
it at
> +                * all to retain the still accessible large folio.
> +                * NOTE: if getting free memory is perferred, split it li=
ke it
> +                * is done in memory_failure().
> +                */
> +               if (new_order || try_to_split_thp_page(page, new_order, t=
rue)) {
>                         pr_info("%#lx: thp split failed\n", pfn);
>                         return -EBUSY;
>                 }
> --
> 2.51.0
>
>

