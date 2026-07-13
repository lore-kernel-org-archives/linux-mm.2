Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1CFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02906B00E3; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D396B00E5; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B486B00E4; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9806B00E2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 726FA140180
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:02 +0000 (UTC)
X-FDA: 84983904684.29.E7B189E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 784B014000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:56:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0QDSdrL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7N6PlllbTvHO1g5IuTvCxlOA3ejXDi65k+Qzdhwvco=;
	b=bOjS5QSNaVpgOc0UvzeUdz+9WDQ78Ibc9RFxfA7k6gamsXszw8om8zUN0ql9+pg+uh7ode
	baSUlD2Lv1jEm3wFllOZBvIqWvimowriVw4+mLFuxWVLuHByirbV4IERM5BW/G9M9trXdm
	V8GgObf72+uf3v6QR2HQlhAWIufSi9I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0QDSdrL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951020;
	b=FZwujmxv0j0+1fRc5cXjeSJHv8HmGnoxwn9CbNGc9oNzzqvtjSjxJSkqE8LqTc40pxkr8m
	vfvLKynC+i+vWC1lN3AFNzn0cn8G0JOBWI/VQYWJUsWCULjV1vOLr7f+OGAuChBOFKoPqC
	0tNCNj5ighLbCYJyorwxup1W5zAuZkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783951018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p7N6PlllbTvHO1g5IuTvCxlOA3ejXDi65k+Qzdhwvco=;
	b=U0QDSdrLVp5okIL1Po2BiIPjhAzZrbKtypru+CEeWYbiuCIoyzSDuRbVn6SJ2Vrxu3EFxy
	FHXzn54hv0wBHttUqWjyb4WUhSmnoI51pCujDgn9b02Yyj0/O84PFKQI7W8ozcO0AwFSw7
	dAUiJ0m7GWRjHy2DvxgrMBVFstVFOrc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-fW4FkA7XOtm0E-_IHlKfrg-1; Mon, 13 Jul 2026 09:56:56 -0400
X-MC-Unique: fW4FkA7XOtm0E-_IHlKfrg-1
X-Mimecast-MFC-AGG-ID: fW4FkA7XOtm0E-_IHlKfrg_1783951015
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39ad42eaf7cso16237541fa.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783951015; x=1784555815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7N6PlllbTvHO1g5IuTvCxlOA3ejXDi65k+Qzdhwvco=;
        b=dLMbOY39wzX4mgE1UcQfAUcxyk+kdHZkUBI51RKsKuIJSbLkrUeYmTYvM3CrTX2tdk
         6smsVNx5Y19U7OaCHI9jv/yhxfxkeZ8u2M78oeHIPIm+YAXZFi0Kc/tLKHCsKdu94N1i
         3sQo7VKdqo9ImQwIkwRsgJPS+oKo3cY4odaVygDJhsx9t6MIt8FS7PO+cEDDvpkT0Qr/
         2vPBd9zedq1pUx5VjVqUHQ0VPBDnUf2APsZ4bRGfkcAJdUK7/R1IJVgJ1e8+Uix8RYwH
         84Hq8CjuGV1wr+dEr2jf/nO/4lG1MxrC91FErTXzLH7W9w/yhECnqg87TSyrxetrOb2M
         tlhw==
X-Forwarded-Encrypted: i=1; AHgh+RqQO6PZOS+GjZXPh5ILfu2VP3XRc5TaBB14al3+QEW/STmnURNh15y2NfjxMKGrCrmozbXm2oOTbQ==@kvack.org
X-Gm-Message-State: AOJu0YxbySZwAoFJ3c9cT62jepeIJasaAdpKmeSZDeeob59QQqD16YIR
	00c5d/08qhkpq0LnDC/UC1dQKQIbsWUoeGTB7mf06F50bZcbgL6s4bV3Xbh27E306pwA7mV5AsU
	XtvlZRu4HQED1ZCUP9EyyK5nT+lImDCgnxBuI2x+X3wlfeVAZE/YG9AhTxK4v3cPFI/UD7xIImt
	iVgtOvZQbjr4HsDF6HZs99N1+bvt2rsgKDT+w=
X-Gm-Gg: AfdE7cmMspspQQ0s/tjHgsty2gHSnhPB2AE92XUQMrWIz/OV9YhFLh7SndzQ+AWjbZF
	Km9Stu5rI3twfkYaR+zqpS5f8FmmioLu4BOYQxU+wbhqxJyr4OWUz4Vq5lJV+skooTaTzi2VIP+
	VG4UGGn8mBxVmIRScqJIzHIAZobjS5EetdAEl8+SAYXtul9YlbLcvES49ivvnZh6Cs
X-Received: by 2002:a2e:a5c1:0:b0:39c:9452:15e6 with SMTP id 38308e7fff4ca-39cae8a9999mr21110441fa.33.1783951014731;
        Mon, 13 Jul 2026 06:56:54 -0700 (PDT)
X-Received: by 2002:a2e:a5c1:0:b0:39c:9452:15e6 with SMTP id
 38308e7fff4ca-39cae8a9999mr21110261fa.33.1783951014291; Mon, 13 Jul 2026
 06:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260706154500.39178-8-npache@redhat.com> <20260706193556.876676-1-usama.arif@linux.dev>
In-Reply-To: <20260706193556.876676-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 13 Jul 2026 07:58:10 -0600
X-Gm-Features: AUfX_mzCabUIlX9TQ3gRocALmiHePfG2uYgZVzFveFv553hugDtYsgls4Kx902g
Message-ID: <CAA1CXcDjNnPuensEftae0mVNPxgpt2xeMNZPYyb2HU_bOp5Xdw@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/khugepaged: clarify a comment regarding
 max_ptes_none check
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sbi6iliq6b6DF2YnTGAjLaLEZvBMe4JlRZgojcqpCck_1783951015
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 558dst8k68i75t19xpsf3d6nith9djzb
X-Rspamd-Queue-Id: 784B014000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783951019-339327
X-HE-Meta: U2FsdGVkX18GDHi4pAhjqqAy66B9ce/gYPqoTR2NsxRkD8MAbl4s5ZJk2XdEdxAKTTgxLR+wvoD3NyOBCGHHWU7UP0ySWX+xVVAnplrccT0CpKWDhzcvnoRsEmErq2L0488qN706LF1h1yerrcBHFmlmciPJ9+D95r3gi6moaFurtEdIXECyx7CE6xa7owii2Jx1Ap398OADaW5OmsoNB+qCMhA6++PAV0myDV54di2Cjg3St/2MWraAnS9Vrfdq1Rm3XB4Mme/hKYtVHl3jEo+MrU1FUtrTgr5hy6pD9OvOKAxOJ60t23j3Z45oZIZxhUY5fQ+3YkrJLh0jCrkOQBLkNteQ6wMduIbgFl+e+Qc5tMhICS7UJKVFB9/jHnHSIhmG5SEUicrCZ3iwV7N6HSvdqmppS29lVxupyunylIpxV3jLn/v4eovTYLwNYBHC88D09Uyhj6xas9JLlIqDSwQQu29oNyAKG3jAoQk1qn0fN4QMiSWjBS1eNjhQn7ZGhrSG+QkvU5GaY+xTVyBxVYHiWAfR6jf7QfKHeWoKvg+cVUZgIzk1rll67TseMiI4ouYbhQNx1z6HG2xDSPGHsFTYTHsHfLeK7XPHXuQddJLefsSvQap/hPSLCCyV+vgQUZ5Lyctxic7WRBsCW++FdNNNw48unk8av8rAQIJG2UAi6MMv9cNLvmTvhwK53k7ZxG5gRxoxAwdq5CC+qu6cT/MVqUUzSY9doJbZsEt5qKMT67gpBpAiv/jE3b277LXz23pRpRoRHmY+l068IYeQrYwx0wjrMBiQKw0xx+/O67sZPjg1StZmgcBE86xvWIUEfoEFPzoHPgCoqL3rn76/rZE3RnXD6F433+2Vmoe1wJRZu/v1mTClO29uIkAgqLApQRqr42rBIsKHYn1Rm3gNzsNIqoR4jVy8UN+ysUPuQVF1mLbdaycCaGD1few8tHlxo7htDCQ4ung14B3EF5n
 VbqTmFNI
 9I6prDHUa+Rp9yon1ZlNRWk5FayqmV1+agrMEA4ZVXg0/cyqX+TjOUfO51YU7544x+2Qwl5OaE+TXHtg/qeYjjO3m2rq+9bE/rypfF+8s8Vae+TjklYandd8UUwtz9+81G6FZT1TWR1dIyh5KaBan+LoN3TN3QogJeUaGpx0BIDPccF3XllSPSaucLwycOrU1cvFKlimF8HHOyz8UunbRMij2l4HyU3hDdZE6g0GQMCCiwgTLyGMaA8ykRrjKC1j4DV4CBipijtIYoZcc2PdfRn86q5hMN2KqVUj3oYWM74f0TsaWZzlnPgdGww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 1:36=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Mon,  6 Jul 2026 09:44:54 -0600 Nico Pache <npache@redhat.com> wrote:
>
> > While reading collapse_scan_pmd, one may be confused on where the defer=
red
> > max_ptes_none check is done. Expand on this current comment by explaini=
ng
> > which function the max_ptes_none check is now done.
> >
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 3c6f1254deca..388045a524a3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1728,7 +1728,8 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >
> >       /*
> >        * If PMD is the only enabled order, enforce max_ptes_none, other=
wise
> > -      * scan all pages to populate the bitmap for mTHP collapse.
> > +      * scan all pages to populate the bitmap for mTHP collapse. The b=
itmap
> > +      * is then checked again in mthp_collapse() for each attempted or=
der.
>
> Could be combined with patch 4?

Yeah, sure :)

Thanks
-- Nico

>
>          */
> >       if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> >               ctx.max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> > --
> > 2.54.0
> >
> >
>


