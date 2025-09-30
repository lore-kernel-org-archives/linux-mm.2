Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885A4CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF27D8E000C; Tue, 30 Sep 2025 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BBE8E0002; Tue, 30 Sep 2025 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A7B8E000C; Tue, 30 Sep 2025 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A053E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:31:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35C711A0710
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:31:16 +0000 (UTC)
X-FDA: 83946154152.26.B3E05B0
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 362B240005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:31:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmNECBIo;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759242674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/P8UbV87J09tZL1h3UzmxkojtiXGLQJFOupY2v35F54=;
	b=6NdUhRwo8duGM0vNp8OGT2Ee2gBPaBeI1VkRhZ9IIL4ErT/ug007F1XrSD4LQpOVJb5I2u
	OoZCYCMRFXEToqU0eOHB/y84jB1AG469I3RQv2wjjwAccUriaOhXWr8UALwrCPIBX96RRv
	Aja3Gz0bto7q6J85K0tFCup8+1wqNRM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmNECBIo;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759242674; a=rsa-sha256;
	cv=none;
	b=T6Y93Y6kJdRreuI+6hZB89TlYUeepugbxEYbWwZMweMugpTRwpryux/73mFLnE4XXy8IRx
	Ree7J4pmRSrJ2ofp+z3/Ix25VaWK48Y0kYEmk2hmu+kex7ghIjv3lwV2+cxqWNHkF3QmzF
	SQEBDQ/jtgLLPC7znsgjQvvLSbuYyyI=
X-Gm-Message-State: AOJu0Yzbycravlk3Tj9NhfGPv1BE+7l0H+kAZ3ZTJLc41oX6OzonDjzc
	tAwWtI6zNaj6Ntn3LzTs4qHSS8++bZMwjmAB33Pite5NIURYw/t9jgRHz/b8vuNFAna1CeuhJ48
	bFIaeL5doyRfw3uZo2Wy07JYOVDf2kHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759242672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/P8UbV87J09tZL1h3UzmxkojtiXGLQJFOupY2v35F54=;
	b=DmNECBIoyXkG+izaS+XHWg8JfiiOWbi1iRSLsCeV6J30+D9ODSeJ+YNOMYB0X6Piojjj3P
	abUQboE0XasR5z907cfCOUBHho3ePzO74plpfkyVEaLId72a8mipqxXyhEgW++56X3OoEo
	oEyd5SA0Wyr8gJWTN4VMRmTymt/pv6g=
X-Google-Smtp-Source: AGHT+IFVSPZu6yh0Q16pHzVeahA0zVDamjBYekfddJu+S0nvsCyAm84127hmtyw+5HLmrZLl1Fidbc3JRjFYvkTCfPo=
X-Received: by 2002:ad4:5c65:0:b0:746:4ca1:fbc with SMTP id
 6a1803df08f44-7fc2fd7343amr298313466d6.23.1759242666456; Tue, 30 Sep 2025
 07:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
In-Reply-To: <20250930025246.1143340-1-anshuman.khandual@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Tue, 30 Sep 2025 22:30:28 +0800
X-Gmail-Original-Message-ID: <CABzRoyYvdeX562ob6tf50O8gRoMKPp9-62FR5mcjTUNyGZSoTQ@mail.gmail.com>
X-Gm-Features: AS18NWDSRA9_SfA-4xAgCAAwq9ckBLFuJLAQkfHgnyzZ7OPW9t0Fkeu1DptjuSI
Message-ID: <CABzRoyYvdeX562ob6tf50O8gRoMKPp9-62FR5mcjTUNyGZSoTQ@mail.gmail.com>
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 362B240005
X-Stat-Signature: bmjaf5iktwucck85kpmxosr6smizazhd
X-HE-Tag: 1759242674-502530
X-HE-Meta: U2FsdGVkX19Ih5suB2pm4Ws/daGYdou1nVnUEEM+Doy1Wf9MXFdPDsS5IQIBSTs9Pfjs548LKp1Dt+oJVFKQ7zUm4YU8FjoSDaJGutGu99ba0UvwUF69cD6LCvPBcp4OBAHwAU0lC/KBtoc6xnVTShSYQGnY4UJUVgkJTYmiGVvU7hgmy0o7CpM3CSdvldQHNHnLOeA+nOAkUBTl3JhED/gtyMTOIKVddQmhDcitCjd6iaXlrvVS6pjdcYb8TbKahWlI/N3NCUz+ExEGpgkbayznzOWYWsdaPc9yjyC1VjT0rjGfgfWbJng+QEUGtiQ0hI6hWbuCQmgRYDGQ1d2v+OraqRqQMFDXRwpKAgTtL5dSZ9lE0EO0e5Q3Ky6PZiREt4hWgCI1xlh4KNcLeraD+nyJ6RxFtVEXOGBowaK+iTv8n0VWclD9QQgxCSinVLGk8hDUd+c6c0F9uRWR5/0uMe+99PnN9OJtUwxZJ+mm/jT+o03o5xOfztIkaB2W2g/knmu5tKKJRgF2sj99GQsILsyU+pXliA1AOdIEvXhDhRMhFASscnV9aoXpm4pFtIdve34LcRk15F34JFja4m/kaJg1ljkdpiDmHS39pNmxHvCMVVLWNwiT/B1YlLWAP6HbmMs2UZcDEJWjVJM5nkD3VXAaLzOYSSguXfuPNP6rLGYIbDjuOLjq0cmLbYSM/UO7sUnpBr/tdgIpYBL9WCP52HqabQT6ItHDwm/hn57ki7rswkAwZ+y80nBwiv4YtJ1dd/pVoByLEYpZHjFlGh48DBJBNpmm1Qio30AEJP4eaiCqQERIvz0YJn+GlkU7rnJCtl0/SDDO1f96ByURJxYo6BT34+w/Rvi5F1HW2AL06OMYFPerzzxiCvR1/bwz23Dx73cB0CW5NbMeWwJMD620Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 10:56=E2=80=AFAM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() whi=
ch
> anyways default into READ_ONCE() in cases where platform does not overrid=
e.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Nice cleanup! I assume it's a no-op change on all architectures for now ;)
Acked-by: Lance Yang <lance.yang@linux.dev>

>  mm/ptdump.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/ptdump.c b/mm/ptdump.c
> index b600c7f864b8..18861501b533 100644
> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long a=
ddr,
>                             unsigned long next, struct mm_walk *walk)
>  {
>         struct ptdump_state *st =3D walk->private;
> -       pgd_t val =3D READ_ONCE(*pgd);
> +       pgd_t val =3D pgdp_get(pgd);
>
>  #if CONFIG_PGTABLE_LEVELS > 4 && \
>                 (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW=
_TAGS))
> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long a=
ddr,
>                             unsigned long next, struct mm_walk *walk)
>  {
>         struct ptdump_state *st =3D walk->private;
> -       p4d_t val =3D READ_ONCE(*p4d);
> +       p4d_t val =3D p4dp_get(p4d);
>
>  #if CONFIG_PGTABLE_LEVELS > 3 && \
>                 (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW=
_TAGS))
> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long a=
ddr,
>                             unsigned long next, struct mm_walk *walk)
>  {
>         struct ptdump_state *st =3D walk->private;
> -       pud_t val =3D READ_ONCE(*pud);
> +       pud_t val =3D pudp_get(pud);
>
>  #if CONFIG_PGTABLE_LEVELS > 2 && \
>                 (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW=
_TAGS))
> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long=
 addr,
>                             unsigned long next, struct mm_walk *walk)
>  {
>         struct ptdump_state *st =3D walk->private;
> -       pmd_t val =3D READ_ONCE(*pmd);
> +       pmd_t val =3D pmdp_get(pmd);
>
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>         if (pmd_page(val) =3D=3D virt_to_page(lm_alias(kasan_early_shadow=
_pte)))
> --
> 2.30.2
>
>

