Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4E7F36BA5
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 08:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A2C6B0089; Sat, 11 Apr 2026 04:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAFE6B008A; Sat, 11 Apr 2026 04:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310786B0092; Sat, 11 Apr 2026 04:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD716B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:32:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FD681407D5
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:32:24 +0000 (UTC)
X-FDA: 84645608208.30.ADC97A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C263A16000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:32:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3ZEKvKj;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775896342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHB7NQf/UKAOynGNUe64UbxTWIHG2JFjU39vTHIzoLg=;
	b=5Dn5PL9/nJXEep21IW1L3u+ySG7WXRb8Oi1JrD/nmV6A5JZd8cjbpF0ij27p6TXPVxay60
	A4BTqRDjg3cdY32Vn2fluzyQt+FH/dmcmsU+Lyf24uU7tzqRvhm17coks3cEh7fXVYGXtJ
	jQlF6XWNsK+1piMSKdcxnCI9i9+hKxM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3ZEKvKj;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775896342; a=rsa-sha256;
	cv=none;
	b=uvgDGJb7RrhxO74SgWnRYJ2WYip0T5vwDpezgAU1O9Aei5zmPoqFxasRN2xbs8PWpnhS2w
	Ya9W0kwhK/zX9dRPWewW52zCf7EpyemjkZ1Mhq9ojGMHxFQi8xgZURkZVdK3u6TDS0zGkA
	KPrqAnkXej2zpDPhlg53QkHUhOJUmPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21F6E6014C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAD0C2BCB6
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775896341;
	bh=KPAmTaGpP3NlCIm6P8EYNwXFUqxILSkgHc3BlbK8kpc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W3ZEKvKjOcSjcph9WxBYLFs0b6tl5IcaJCAa+rlE0iOubh0ubk73LVQa0/IlchZVn
	 OsHgmLa5f+GNvAGrq4WUScxCV2pXrl7AuP2Zw5lEBKtC0ennZ0Mfq6Uvuo8Z20xiWe
	 gda9IPl141M3nSgcXnj2c+ERjlpHtAGqrY3vifLBlaDpW4YdyBDI/yc3AhDVaE6rfi
	 KEVx6xVjmyu5cTLkuRfCFhOKOnM9uX4sca6FUnkOtUzLh6X+bm93bQZIw02ntbZ6Py
	 Qk0W0po2I6I7zLB0P4W4Gr2k/IjF7d1X9iYOP4tFNkxUV23gHGoXe97xOXx/EkpX50
	 aGBvp5UO92P3Q==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a210c813f8so17314326d6.0
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:32:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXdHwJ/HF08qDVJfFsGmCYM8HwLXkucjkmSD66CfaxnSHUFF42RSxvIJkCmDXK4aR0FHMuPmgS2Yg==@kvack.org
X-Gm-Message-State: AOJu0Yy5g/VZ1BHHt4uK5FMw6YjBIIp92QnSjuC/4iFAuYhZg7IKB4kc
	YsDa+06cln3GlZRrQZ7CFpvT6f0E+4pxMZaWqBnAFM+Hw3D2lbnbtLl6bBM/rsfGZIrX/p8VbWa
	+peoFrxeRLS2o/37XPi9FailJFuk3YrE=
X-Received: by 2002:ad4:5e8b:0:b0:89a:1536:251f with SMTP id
 6a1803df08f44-8ac861ca80cmr103079466d6.28.1775896340889; Sat, 11 Apr 2026
 01:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
In-Reply-To: <20260411062152.2092967-1-lgs201920130244@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 16:32:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wLSLy_vZjGYiJpTEOBXtyTTTVdTr-wW+sKKb5b0S0Bhw@mail.gmail.com>
X-Gm-Features: AQROBzC1PacD7-eFcsH6x1hYNmbe4D2RNPxu2mWZ2SuIc-3EVI9AR0mRlqLqAJo
Message-ID: <CAGsJ_4wLSLy_vZjGYiJpTEOBXtyTTTVdTr-wW+sKKb5b0S0Bhw@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C263A16000B
X-Stat-Signature: 49xr1q3j3j3ykz8g1q56j7noikmr79rd
X-Rspamd-Server: rspam06
X-HE-Tag: 1775896342-905000
X-HE-Meta: U2FsdGVkX1/xM1yrJSUYIGXlhkLEQvDHhn4twptVkiWBsPZuKLlTWUrvzRkMzVPBQrhWKzb6czB7251VgY/7T55Uw7Fp8i8c8ZXymwj4KniiHYjZcjXCK7rCUJq9HeL+0u68Fa5wFCygZR6XPfYUrTLEMQgBOxFM/HFP+OpUPmfXXLZnESIAZTbAc0rb0Do6oO7EsYq6cXILRRTWmaXM7ePDJqX29kCfqNeBuVhB8lFZ8qwkblPn1umVPQsKylKFSZf6rLbsBQ7cWxANWpkAH+UNGvHcW4BYjVi5qrLnKcvGgZ4v1vds88GW3jloME9+bdmQdLbvUNDM/x8sIs3GG2ZLPsrKlbbhWbebmadoR92/Tte5Prylr+tUIwadwaPOEKXFf+nJyYimskwucAhzOha7fwdZlXC4o9jXBsng27yBvoQfxnVgJ8drDTMbkUjXdORLonRHttxxfrFQ04CTs/L0TnPiTzF68fi1ZgKz6N3/t+ayvwmPME5ybQI4IsFEToASVKQhRIkbIGWxfCYXuSnRL69cugzCbuyvkWKxrnr7Y9YbNgFX8V04Lvx3DOQbVb59hMHmSMv2H6G33Lz4Ngi63tLPghOgWKkXBVp9qviterH2LOTprq7UF+Kh4dmy63pvuA7wAGr4RDUgG5zmt303BOcaD8zuks+HnHABh5eOJPTMxONHQsQRfU+rZBdzeP1I5I9GUvuQPfoWMMJR925PyEk/Ht0ZNaY2LDvdfSGWHCr7hGUXMzjBFkJtraQ2thn7tQsPoc38busxMcAIctKbRebhPt1cvavRPQEs6+mV7/UNwddo3hxE3ODdXFScvbArHIm7OvUDm3DyOSsyy8y3oBuO6Iy6AEch8z2sUdMSYOEw7ZxzG+6CEAbjEckqSEnGhwgZdB3brUwIa0bdHHhqGEBIaht+mHUVPhSjbSzIy3GA/SCBBI/Xhj38kfa0Nss9IfVj3Z5GdG4ITNT
 PUhNFk9n
 pjNNrMoh0JM7ArfQmAq0kGavsx+dZqupUOBn9BAir/dnrSNz1tDwhB/dIx1Iam/Rs+ra4kWaH3wRFUb9ra/DYABc0eUI/208Z1XaBNj1MWKIWG8xAr/liR8byrU+wEr6YwkP8IClenncQHNUxJX4kOmpX2SbLWYL7tq4cYDAeFD26U/Xi2AGwZmK4S0gZaCLzOpvJ9gS6tiG8W1XRZaifSqRByU99+glQbNg2KLl1ken85ERucKLp0kuisIKQifr6gR4O707NWkSTxq8BmLzYOH6hVwbVQe+wK4H4XCmx4OZ1/R2OzaLNFrw9ec4G2K0ePfjRnuaYMFJADdSULOZ1Yl7couL/ZMiMxOfaZc0aEJE6f5DbRVc0BkCXrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 2:22=E2=80=AFPM Guangshuo Li <lgs201920130244@gmail=
.com> wrote:
>
> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
>
> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> directly with kfree() rather than releasing the kobject reference with
> kobject_put(). This may leave the reference count of the embedded struct
> kobject unbalanced, resulting in a refcount leak and potentially leading
> to a use-after-free.
>
> Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> letting thpsize_release() handle the final cleanup.
>
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

I=E2=80=99m fine with the patch, but could you send a v2 to drop
the err label, which is no longer used? Alternatively,
could you rename err_put to err?

@@ -825,9 +825,8 @@ static struct thpsize *thpsize_create(int order,
struct kobject *parent)
        }

        return thpsize;
-err_put:
-       kobject_put(&thpsize->kobj);
 err:
+       kobject_put(&thpsize->kobj);
        return ERR_PTR(ret);
 }


> ---
>  mm/huge_memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..ae6ed483cd53 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -726,11 +726,8 @@ static struct thpsize *thpsize_create(int order, str=
uct kobject *parent)
>
>         ret =3D kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, pare=
nt,
>                                    "hugepages-%lukB", size);
> -       if (ret) {
> -               kfree(thpsize);
> -               goto err;
> -       }
> -
> +       if (ret)
> +               goto err_put;
>
>         ret =3D sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
>         if (ret)
> --
> 2.43.0
>

