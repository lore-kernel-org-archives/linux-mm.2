Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788AAD46C0F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3DB6B0005; Wed, 28 Jan 2026 17:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91B66B0089; Wed, 28 Jan 2026 17:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73466B008A; Wed, 28 Jan 2026 17:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE0AD6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:59:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F8AE138F32
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:59:52 +0000 (UTC)
X-FDA: 84382891824.07.3B7FDB1
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64307180006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:59:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ORAO29vl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769641190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6l9v6nvekI3IglgDHWcmVVwUUBXm23W2GZ36y4REus=;
	b=SiKIG+Qsm9NX2WlpToSSOffpfvhsybcLtjThTwtA4+1mnOtnlj4SiymUONKOKm/LdIJMj0
	ZuHO6TQRR6gopAbCibLyQmVTaWexF2VEeDi+7gSrkFExQHukBWJoNvZNv6jPrN5FUZvEAA
	hNbkPAK7Bys32K53jx2c3Czxm8qXVBs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769641190; a=rsa-sha256;
	cv=pass;
	b=EDJlHn6Em0B+bAdIozda0l0u5dGZ6ZrPCgl/r3xLpltuJXBtl2hjD+nYo9QvizcjGWorfH
	GJoPP2hTALO6Fy3B7HTS5lOa/QTX3fpy+m+pqiSIiwq4emsuqHATlGd+djPZyMGrR+aQIR
	JcBMgTG1Z1fDYGxKwEYKkinMkXkY3iA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ORAO29vl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0d06cfa93so12335ad.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:59:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769641189; cv=none;
        d=google.com; s=arc-20240605;
        b=T6uW33XpeNv4Se6wogqAlXu757vlDVymuHHmr9uTksD1MMTFpAxOCn1whByvlOUqd3
         ydiHwtsyIRAOayw8wY2rFCWz2Rq724zbPYgZ6rDxqp0YX3lAh7xheSW4mraEVLJtrw4e
         YNyzd7rSAfcSoMN24sIN4hNQRqYGeZgbJ3DUhsa/078Es1/dIsfT4YpCBLqnYD4YurPk
         5hJ/N8x8CSbmCPyR9/VpcbM869ermi0AliF4GJRgmbDX4++yKwryVxKFcDh7hVMzEuWj
         KM9Cmy8Et0FhBrBvkbw9T5dm4GruaeXkF08NI4l4gGHPceYs5YGs/oMhEACqG4/vz/xG
         r1Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X6l9v6nvekI3IglgDHWcmVVwUUBXm23W2GZ36y4REus=;
        fh=+ySk581tit2yEcNOu/FkixReTI9O1N+LlvqciWqwVxE=;
        b=bhYsgtoVK2geu99wOrX9U/by8jgJya9VL3A4a06Sq86mzuDQPCNk0a+pv4zB+Lt5q8
         tBmYZ3bqAhD5QA+exhfuY3aaC/qMVgBH0P+2pTEGB/IoVPPpme2cwoXxZ34y8cRhQgWa
         pW2/V0azL+PL9jtVp07Ckr8HNGqzZqQ2La1gOU6/VyQwFk3ngZrj59tXg3aXwIjbQMcU
         AyzK9tcg69ozDAG6UpPBuXLnkOQ2eqQWi1fsEkdewJfkDLYXYojTaUgrglX5KPg0qHRY
         WBHCB1EWjdH6dA2+B8nzJbsalW/GstVrfZRfsXkbJoTTnMAQcoWSSAggnNsxzO4rzZT5
         PI7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769641189; x=1770245989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6l9v6nvekI3IglgDHWcmVVwUUBXm23W2GZ36y4REus=;
        b=ORAO29vld6Y9kqfqr+xAC2XUl/4/epGVsqqgwuXRDPbYuw3+I+IypuujGVHYiSFx6L
         Hw/Bw/SZteh3AXG8h1rS25J6rSpp1/DYaK1iP1tfeiGCMhGpSE92IXIVW94B0yyWSM6G
         NrZMZ0/cK/rNT90NPtxsJODbymWbRrquERcH19C/xEvxpNX7dXmh+OebRnrfUONLs514
         P5tBRsd80pTatahXiIqVMRbMH2UTtZ2v63n6QGu4e0TBz/qmWfAZuKbTLPa6LmcHiGGD
         p65omzZFAPxdt5ELmJhfVxtVDIR9aUNUpR4Aqa546v5oK74TiErKp/IPHC/XHvL+dPwY
         wWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769641189; x=1770245989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X6l9v6nvekI3IglgDHWcmVVwUUBXm23W2GZ36y4REus=;
        b=rt/0YFzEPrFRbjwWpgVdqVbff5jKkI4syxtPl3bp3FJAmLFGc+FoBBQf2ac9+Ktgs8
         wGa12PxVuMAP23K0N1Ft0Ge3U6rIn9DWNw4CFvBdxPIQ8u8qfRCW4C2vzwQjSvQnkUyJ
         GTeLRcPIiGvHxC/RcND9uEwqKNvUsHQ/EK1464l+66209puB/tSSgmXmYU43BYRU4Clx
         yDLK4ruOOXKMRA5HZGS/BzkmJCtG+bQNc4epOEUI2aeNQJzNuH2TtG6RExYY1EWc31nD
         aH1fW2Pc3TPFgWyCGuRfR7rqPioO3rSbrRA3YcGgrg9KSZanqq63SigKaI6zMkBiS9od
         pTBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoNshboZcIjelmv4X3pwfpKwkWrZM6MQ1CadAx6EQ+z2z1YMeac5t6cCnmJdz3TT9hStyDvThh/w==@kvack.org
X-Gm-Message-State: AOJu0YwCw10jGpCuEHCC39KijCDitRfiaVJG8dVBCopuCU7fhakYU6ZR
	adEd/Kr0U6SOidWW6sbKAcol3ZZUqu+FCefNOoejz/CmJBTi1iLED3rD0/noyDAbBrvDbiJvQcQ
	UFOnif11iTGQDbmdmIIx54KhT7VDx8UqhqVnmupiH
X-Gm-Gg: AZuq6aIRvyRIbAbWblhY6wGzVpgISS078L4e64UdNdVRPekSDtfFJiAfl7uCaxWH/cC
	87rESK3Vc807q5ic840/BvIWpwmbXjoMRj4x+CxNDqUEUIoAx0ItUm6zkIFjdcdPJt34bEnSHI2
	RYqU0WfZ3HTw6ke0/GYUji89CFRPDN5j1sid7H2bp8oPjLbMgo2tWVwkw3wTn5KboJdWaKVD7x7
	TRHfhBwlzkIDO3U06la/yZ4SAFoLLQhxVv9CURhxxVeCYG0LFOHUqLXtKNbG+hCBhpA3MaHI5YO
	g2pLZ+EfJF/8xid4qYRhNJ8FCglYSGbgxj9wERNrb7Cy48CmnR84NvPH
X-Received: by 2002:a17:902:cec3:b0:2a7:7ca1:8622 with SMTP id
 d9443c01a7336-2a8c0535dbfmr381645ad.11.1769641188528; Wed, 28 Jan 2026
 14:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20260128225648.2938636-1-greenjustin@chromium.org>
In-Reply-To: <20260128225648.2938636-1-greenjustin@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Wed, 28 Jan 2026 17:59:12 -0500
X-Gm-Features: AZwV_QgU09LccZD18zBqk96rhfhFyiBkdkVIEJNhoW8BgX9BrqCNfPu6xEKNxDs
Message-ID: <CADyq12wpDTjHVGs7CTQ3SPNMO_ovmMk-rN7L4i_AGvdoLYQLnA@mail.gmail.com>
Subject: Re: [PATCH] mm: Refactor vma_map_pages to use vm_insert_pages
To: Justin Green <greenjustin@chromium.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, greenjustin@google.com, rientjes@google.com, 
	arjunroy@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 64307180006
X-Stat-Signature: bsewhqujxor94timyxuw7zspo7chrbde
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769641190-467263
X-HE-Meta: U2FsdGVkX18EL8te43WLuhZEagELJgpx8FatEPpfjyJo0yrKR1H3sBTb+bTnvc49fWSxR+7ozqwYJxEVrn1Ol8mWFkhHaf7u+B75oLfcNWhQS3b0FbQ4vEeNBfCMhqhQGVJSfkBqf6smjSbGl/nFQA9+uTkR7ycnw54RkSlFCBL1VC4cQ6RH0vdgj6YFBomLwKqpJak7wyNwzA76YZ/PsfEQPw5+MkmsJr43owkUBH8mcCrzlg5tXsHOiLOO3lq5m+1xYjn+vRwxXzuaFH36MpmiNlbE8O0l9b25BT3bAdkP5QOSY0cW4XqKJvkpLPz6+QTd5UeGMYhDRI4iNK3OvHqjXWlNvnn+bsz+qZXvSV0aOEY781lWdAas7BLA2zUipgmimASfMzB9WGZ5FF9ps221L10Uvke3Puz9vc+QGlcCH2aedXPy3ZeWDkyZo5H9GSDgu3EwDeXXK0wv5WFNiSun6MbqU0SNbTIFHn3w5mUILiRMW2iW2Fh+TCLwSNgjzX6Sh52fV1BA+vf7/bI3uOXtPh03dFHgtARojAgk1iTzjLpYTNjMz9cJQla2I1Tsph8YV2abdk0zTwFUKOLlAq/wC44VlQiEKFRvpH+NOnTrqFel3lWwEqpaR7KbS8FBk1iVoDQPYZTp1zVbrxBxFAGzSf7vnOS9QZ0baoPBMZewqVAVDuBagmjwe75XvMzCTarsCXh5xC+ipTqyAPPl7eYZkq9dMX260ZPpW7NiuMTLpYF/RvRs397nC6VAETu95DTbYj8uAMo1pYiB77obWuyvHIdqKt8XePwHL/l8wSmDx1kIiN2yoFTuR/dvQSAWtHrmPaVMW+fZaE2OFmjVxGcFiA8neCvAU/rpmcRr8JpB8btVZsyFWJJioTQ2+futNGMlto5kdvDRjLWEpUzb5onK7D2+bXHysAs6kiYUymVPr8qFo/fEns/yq6aA1mDB0eNTWkNlJEZfJhIja5U
 YxPVG17L
 mLksbknsJnZiiYOxl1clqq9+68vujtFMN1urTvhpRjY0rwFry6pcEOpQY2uZbv/FlA2JZ311plcpm6T7T2zeQGBh32+M4n3/zoF7Lc4zbDkqX86qFoiDCyrCQ+bIAoci272NDEVq8C5mhJmjBkyaVbMHwBcr5DL9nmuSZX7EWM6ytp5I4dWGcGaa+MTsX2gBwTmrLwGScFx88bKZeINc8ZPQFsTIRR5Zr9sMM4BWIRT4+s40WTTw8J5hT8vIBWO5CC8zxlHeXisFNTjQkwdszoNIUQ7mYtef9bvNvSYmsUcimEGA/7chd860b1ldAPh+/KlD5/bqAl1451H+MtV2kqfEU8g9n2sxWuRF3iw1CeEvDzGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 5:57=E2=80=AFPM Justin Green <greenjustin@chromium.=
org> wrote:
>
> vma_map_pages currently calls vm_insert_page on each individual page in
> the mapping, which creates significant overhead because we are
> repeatedly spinlocking. Instead, we should batch insert pages using
> vm_insert_pages, which amortizes the cost of the spinlock.

This makes sense, I wonder why this wasn't done previously?

>
> Tested through watching hardware accelerated video on a MTK ChromeOS
> device. This particular path maps both a V4L2 buffer and a GEM allocated
> buffer into userspace and converts the contents from one pixel format to
> another. Both vb2_mmap() and mtk_gem_object_mmap() exercise this
> pathway.
>
> Signed-off-by: Justin Green <greenjustin@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  mm/memory.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..7ae6ac42e7d8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2499,7 +2499,6 @@ static int __vm_map_pages(struct vm_area_struct *vm=
a, struct page **pages,
>  {
>         unsigned long count =3D vma_pages(vma);
>         unsigned long uaddr =3D vma->vm_start;
> -       int ret, i;
>
>         /* Fail if the user requested offset is beyond the end of the obj=
ect */
>         if (offset >=3D num)
> @@ -2509,14 +2508,7 @@ static int __vm_map_pages(struct vm_area_struct *v=
ma, struct page **pages,
>         if (count > num - offset)
>                 return -ENXIO;
>
> -       for (i =3D 0; i < count; i++) {
> -               ret =3D vm_insert_page(vma, uaddr, pages[offset + i]);
> -               if (ret < 0)
> -                       return ret;
> -               uaddr +=3D PAGE_SIZE;
> -       }
> -
> -       return 0;
> +       return vm_insert_pages(vma, uaddr, pages + offset, &count);
>  }
>
>  /**
> --
> 2.53.0.rc1.217.geba53bf80e-goog
>

