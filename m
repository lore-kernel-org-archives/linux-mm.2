Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59955CE9D6C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8766B008A; Tue,  6 Jan 2026 10:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85BE6B0098; Tue,  6 Jan 2026 10:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967A76B0099; Tue,  6 Jan 2026 10:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 841316B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:50:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30328140354
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:50:03 +0000 (UTC)
X-FDA: 84301975086.11.CD6F41B
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F87940010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:50:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=re5kITb0;
	spf=pass (imf17.hostedemail.com: domain of smostafa@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767714601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4u/XP2Qb+qQvDlOXEIcff9WsDxL9SWsqniXEl78vuPY=;
	b=4VEMpl16i4Rk1q6yWTHfyL9/pvhSuQzUz7Pwj8m0VAr5d+0EIblHLuuWcN5Wscn7LxFeoJ
	a8CKWf+O0AOSv2FdyZG6sMUE/bps3cZsmYsUGzEY6PXxIHAMB4/peBj4aj4lmYAWGgRapi
	YOHoyG0jpI7yKJzawsvBlcmHccrQffA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=re5kITb0;
	spf=pass (imf17.hostedemail.com: domain of smostafa@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767714601; a=rsa-sha256;
	cv=pass;
	b=N1OHUU8Y+5bqVVfRWlKGE5LIfxrihCfmCW60J0CU3RgYxIWj/UoW6eQyAuGtzm9GZbuNRX
	Lokth8DzahFsdEciQbzqD7rvrmkpbso5wC/mk7rwgmB9FkyGJsjVkyaoHgvYKykW6P2sMV
	YDhCbPJJjQ5CPB347cTY/0QbIJ4GNe8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee243b98caso433651cf.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:50:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767714600; cv=none;
        d=google.com; s=arc-20240605;
        b=buuGliNi+3QvDG2eAmMmGoBK3JOnLySmAeySXB3WM0SLp0I1WlcCTu7EFFsn8PuhxG
         hWcfpLidzhSKm9CLMGeQSKpMRUCQsoz2Eo/tp7fqYH0Iqhzgy1A8ZoB5V0Z2SOsq3BNO
         n3Ye40dOP9vJFuv6hg6bUbAmKExruTuNusZFnXmupmROSNyiAtWFJQ7jvy1XwPy7bWQ2
         me2UelSusNFJ3Ni48zRfjjU8WRHTCYHjIk8qQCOEz/TzcSZJRQ5oOBPPIj5850beQcB3
         MxOb430ytzRHBYuAtcbM/BlXtd+/nToi2GVqLWil2dJhja4cTlnjVxYQhnrlciJMVKi7
         QpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4u/XP2Qb+qQvDlOXEIcff9WsDxL9SWsqniXEl78vuPY=;
        fh=p4j2kzS1EdXIq2Ml70yX5WC5oz6ta1lhPSKxZoFDECs=;
        b=fJTiehOaGat2zH72yZXfRPbDlgRAz80yYlHGoWnUJNBdw37ICn7Zv420les3b/nviT
         /TP/Zu4jKiq/cEGQ3c0dq6XTfeziYJyHuUmiiYidXV5/TO6w4VPVAb5hjzSjukn1UeAJ
         0X1fjOH6b+lkNSaOubKpeDZMMLcpi+kfzMPQqaGdYunbFtBZYRnUiTzvIniz4KgJBmbO
         MoZMBxqkoyvtbskHMAHfKNCbIVhjAD0LjLSWmQPKBp+TkmlgAm/rg1HpuIMjKdPJIZHV
         4298iZ6FARUj6HemnnfLPKt7fa7PfJnIS75iLlPTQ+xxNHHJnwugE8rNiYKU+4BJlTYr
         qfZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714600; x=1768319400; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4u/XP2Qb+qQvDlOXEIcff9WsDxL9SWsqniXEl78vuPY=;
        b=re5kITb00e/1/Jtq9XXdtLSVvBtdIELITkAfTr0PsWvfXEYLi51jm4AHdV7DDexoMs
         PF4bhMdyhDeqXQs+ORwXsCui14/enapwy4E5OqiRALUcxKIheadLOKalTMAf+eszjuAd
         QcFiSZ7YnDtyr2C5ZYJclWJlqQ6hqfLeFTUc6oh5uPeYCBQcvmVF3edje0AP8atMiEUJ
         0eWSduckPZH7prEDz+zxWFNlqTvBYCj131akM/PYT7JSUyA/hX0OoXsqMwZ3u4FbREoW
         UcgKdPHBl8ujB1bXkMn3eiQLanjrckEWmrkSDgo38JG/NDd90lLpgyofInMaZuQYeR2y
         jZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714600; x=1768319400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4u/XP2Qb+qQvDlOXEIcff9WsDxL9SWsqniXEl78vuPY=;
        b=kN/1GySdoeOrKDJKHjEA+tJSqGbKcYDn8irR1fswXCJUOEwRT7N6Zn0Fv8WTWYZyrl
         NW8zI34qdzz6K4YiT/8jxiIZIM2hN8Nt0z32u2bUp3qSP+lwD38WVSoDjfaaUy56LZPQ
         ExiHGwq9ilFPxI91NEcYZHq3BDXVDbfnEAK+dxLX/ezUgZZfpF4X9fYCdzLDPus9kYXf
         eY2lfULPHC7grQwGYxbLa2jtwwyNnE1TK73rpldVx0acNChiuCOGmjjKh2iSQQpfZSE9
         Uj63Jc+lSS8NteBBS0JEa3Se+1c5uKcg9f4x9aWg2BNdax+zSwXIxEsbEyN0Fpi3HrM6
         jCgg==
X-Gm-Message-State: AOJu0Yx17IOCvfc5tYLS576VOEID0Ifh68XlwqGT93kr+Vp5ENE7lSFf
	iBJEioESgGknocWWp7pegaJ9beRawvbZpXb9jeUglykZsBmvd17bW23i3w8KoWH5sXJTIM02SfV
	c7bkJwUDGdJvL5Ii5mX1COpynwhAPm9Sl+LUhmSIryoPM4c6jHKveGO6hw9g=
X-Gm-Gg: AY/fxX4fRfGwV4z16GJotzDQ+FXZZrBBIHXKov8NRpxxtHsS2igQC0djkDwbiMjvd5i
	wSyR8eygb3rA3xNGOCT9HrGYQ26MEU+TEv4ttew6pxCdAKI/rLVdFCtDkCYDVWgJF+TYjFhgKYN
	/wKDANY+VzWXXxCp2q3/CsLUduLW9QkWyyrriAKYH1WRg8gIeL8O728mCKNwktZ/UGNSfyesaPM
	XGElEFYAPm59TUbgfcGEK2CPYB69QRs7y2k1WBykm1in5ipPkGt1NkTsrgaCAMpNtLinMh81/7Q
	T8iMTjR8ryvhzdZqSWldkOkTUg==
X-Google-Smtp-Source: AGHT+IHbCEXPRNDYInsMRbyk944URhHinQrSqdn9SMJ0HiaUkC2VNjD/GTcHUOOXarpMrOxvUsEyl1eweg53sx9OpUM=
X-Received: by 2002:a05:622a:90:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ffa961f4cdmr5690451cf.7.1767714600009; Tue, 06 Jan 2026
 07:50:00 -0800 (PST)
MIME-Version: 1.0
References: <20251211125928.3258905-1-smostafa@google.com> <20251211125928.3258905-2-smostafa@google.com>
 <341bbfd9-e6bb-4d1e-b9c0-9077dc3eaba3@linux.intel.com>
In-Reply-To: <341bbfd9-e6bb-4d1e-b9c0-9077dc3eaba3@linux.intel.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 6 Jan 2026 15:49:48 +0000
X-Gm-Features: AQt7F2oA1CBb4GrIbCitr-B-G-VTljeq1aZHCjWlK0-2EsS6hRvCfN68ucTwj3A
Message-ID: <CAFgf54r76=RF0TAkJ42VDnRkwYf0=bjRk-pO1dq3zzvxGBThww@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a4xesygc79gu6s69sgimba4hrimpxfpt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F87940010
X-HE-Tag: 1767714601-440621
X-HE-Meta: U2FsdGVkX1+tAZ+xRbD6CwFxywfTNzeLyECRJjGeHGAs6WKB48IGAbreJdFuNvo3dhW4zKSwv7Wl+2+Z7PA5GRvwctlfl6VGApVD/h3xbBx0tlpwCXnPiaXqxA57quuntvk0dgEDtB+nb6ydM2pzPgKE42v6N4GLjIO4Mlxwd+4zk9kmhpCxoA+74DE69nyEEhrZmD66Ve6mIDw20v8wl7ZNr4OYCyYngVN2Cd7zWUBHbp9lUA8e9m/THr6WeIgd0IUv3U5kOVDXpNfk7Rt9gkYgb110WjxE0iYcrC2nOmLSyheMFMBGSh5RWbdYEKcj6WU2DFaohx7OVKZTzLPFngK9GA3Jh9lkawflIlH7t22XzLOHDOnAr3pNE8eSA0cMx9HdVVxVh6KgXdqVHBaZ/InzgECdR+GuBAaHha2kZyu3RH+YwEZUIob0/gAcstDTeCD1h82bjkkDnjPy0bQ7cT+4ycNuXK52qg6QdADWUCzhdqASzG4MczzAgNnSM0dDeUv7hNN/c4/WDjnD7bZkjv9afT01+/VATvmwna5viKpVk400cE752jnQDum8pSWNauBbNCM/bWkL/6pmXT+E+xtBDoeK05mDporFKFp9tDkkIWc4Pki3VlMPl1l3NUy5724QEw130clrXIwRFhYrdyOZoHQS3olGWHVXlTF5NscwtXJXI8NIZkrmvedL6RW2t02C1CssJyO2F93z5eNEwxf4gSjVKXtN4Yg1UR5mS3jXerAyT2rQ1ValnCjL8iYo9yjueMtyWJexbxkIbrR/SkLtCRMZCbRGKKABSZ20bBciUmGRROl9aFFoZdwDB9IkFWrasmZc586vPuk2TaAK1V4zLyNqKc5/vCwmKrnEw7dR51c7vz4N98T80DPkLtwjxPg84hiujZgJXewwYMDpwgsMcgGSozPQRNalwRLGX6f1zuPJ3bG6v679aMeNYqm1dZ7TCusiDMOQQCH1rtC
 eyPpLVNp
 TkfIMTpc3hSQxvxg1mVPxJgiqRaEPJha8+5romuh9MKd4yOvvftnYn7l1PgvR2AjeXrmEyziuZWY2yssbtEOAM46HWgqYqioQScHIQ89d6tIV3ymJm1bIMMgvN3uq5iLJ5ZywFnoNlzdUs2TYQWdbiMB4RXjDMBQEXTdD8q2Mh9+Ry+dl8XUYud0WaA+adDXfzrcdSfRmPz4t82vj+zJKbgkHJebvE4uO1KSy3KqnsO3RdxZKAqXYDoJUdA+Px1IqZMunXcOkGXtGdphSrdaC3x0mDa9pPL3vCXE1Jfphyv6Ysq8zC8o7xgHpJ2Iy4XQFHRF+dtzb9hb0XaU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 2:22=E2=80=AFAM Baolu Lu <baolu.lu@linux.intel.com>=
 wrote:
>
> On 12/11/25 20:59, Mostafa Saleh wrote:
> > Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> > page_ext.
> >
> > This config will be used by the IOMMU API to track pages mapped in
> > the IOMMU to catch drivers trying to free kernel memory that they
> > still map in their domains, causing all types of memory corruption.
> >
> > This behaviour is disabled by default and can be enabled using
> > kernel cmdline iommu.debug_pagealloc.
> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   .../admin-guide/kernel-parameters.txt         |  9 ++++++
> >   drivers/iommu/Kconfig                         | 19 +++++++++++
> >   drivers/iommu/Makefile                        |  1 +
> >   drivers/iommu/iommu-debug-pagealloc.c         | 32 ++++++++++++++++++=
+
> >   include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> >   mm/page_ext.c                                 |  4 +++
> >   6 files changed, 82 insertions(+)
> >   create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >   create mode 100644 include/linux/iommu-debug-pagealloc.h
>
> Do you need to update the MAINTAINERS file, since a new file (iommu-
> debug-pagealloc.h) is being added?
>

Sorry I missed this last time, that should be under the path of "IOMMU
SUBSYSTEM",
I am happy to maintain it, but it's up to Joerg and Will.

Thanks,
Mostafa

> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
> > index a8d0afde7f85..d484d9d8d0a4 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2675,6 +2675,15 @@ Kernel parameters
> >                       1 - Bypass the IOMMU for DMA.
> >                       unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHR=
OUGH.
> >
> > +     iommu.debug_pagealloc=3D
> > +                     [KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is =
set, this
> > +                     parameter enables the feature at boot time. By de=
fault, it
> > +                     is disabled and the system behaves the same way a=
s a kernel
> > +                     built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> > +                     Format: { "0" | "1" }
> > +                     0 - Sanitizer disabled.
> > +                     1 - Sanitizer enabled, expect runtime overhead.
>
> "iommu.debug_pagealloc=3D0" has the same meaning as "unset". Would
> "iommu=3Ddebug_pagealloc" look more appropriate?
>
> > +
> >       io7=3D            [HW] IO7 for Marvel-based Alpha systems
> >                       See comment before marvel_specify_io7 in
> >                       arch/alpha/kernel/core_marvel.c.
>
> [ ... ]
>
> Other changes look good to me.
>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

