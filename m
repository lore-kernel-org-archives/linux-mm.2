Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8FDC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1098E0005; Tue, 22 Jul 2025 10:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71848E0001; Tue, 22 Jul 2025 10:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960F18E0005; Tue, 22 Jul 2025 10:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 823D08E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:09:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 280711121B9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:09:29 +0000 (UTC)
X-FDA: 83692083258.16.EFA6D88
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FBCB40009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:09:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMBCEbZQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z72Y4lywtzmWJK50j4gaS5KcylDNvYHYQchCkK6Shzo=;
	b=okCeGujIZIA21EWiY2LKMJP/3ICfeSj7WKsK8a0L1KKb0hgK8pOnXfp19JtmB9woRAIzJe
	+iv2jdKCY2SWX+7qRHc0mGlvimYZgr5BI/WpkTKafNWDeObgdX7tIRm0h266SNrkU/aQ+D
	wQn/lOIcUnOb5/lUH2VVpD7mRc1Cwho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193367; a=rsa-sha256;
	cv=none;
	b=hc0p7i+l/VZqc5qUNTa7MPnH+9UCiUWo/YXfngUBQfqGUm21IOqcW/wp5n/4+KxrRUBaHU
	oFeea+E0zpEdzMPp9uP+JSeJbzEZhFpZmc3BCVqttllFErLhO+3TIK+ss1K6hh6nbC/BxH
	FQtpxC8Y02enlhz8OMtGBb6SIsXeo8I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMBCEbZQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-32f1df58f21so56308191fa.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753193365; x=1753798165; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z72Y4lywtzmWJK50j4gaS5KcylDNvYHYQchCkK6Shzo=;
        b=AMBCEbZQl33ammeTR7FCh/ezlB2Cn6x0CHXWDuIbyGwt7Y752VMoB5OsUMStKd/nLs
         P7KaH0DpR1Jq8vww1b771t/ghhiDFu+rzSC1zePJ97mZ3TVnaegbYm7Gin2mBb8r8d1P
         imYBEojsiF8d9tZTUfwENVY+kcRL2t8Ou6CkZS7U4Twup8Wg0YlRdK+37dcgo0HjTuZ9
         Dv6UbE78mWoZo4k3WHvNn4JZQ0hskAPh8PTNEX08GXk/Jp1fdtm8281WQjsWmOwqS1Hx
         tw0nlx9gAVs/+EqXbqwOGt9kcg4559COFfMfmbcGctiKusvDCZPy4O/5JdKsQ1n03dar
         cgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753193365; x=1753798165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z72Y4lywtzmWJK50j4gaS5KcylDNvYHYQchCkK6Shzo=;
        b=ngrFVHVjqgLUr828H7MZjED1CKck0X3IjU8xYQfkX6WNCEbNWiGOFmBhUQdYHpZ6xw
         uMtmXsLfPtnW7xNiPqiVbSPbzVyoNt6kToVCUXXbQooNXOhVJTzdSL5hpFEikb0LHomQ
         hGZhiU6oK8+dt4x9JO4XzMFqiUwuy5kJBe6DilJFbJ5IOI8HGHPu0tiuBDzHU/LjWqgh
         AHnYfPWveuXO+/q6YpuhDFo9PbyBhagkSalZjvrcH2pwc/CFo5He+eDW+3cMeCpEl0t3
         4b+hBYU0rPXJB6I7O5O85Ihc3TR/pN9c2J7QuJuLHwRV1y0MPIYm4SOEDg6S1vPVgbgc
         rtTg==
X-Forwarded-Encrypted: i=1; AJvYcCXFLZoRF2eN0uZcSyIml/3OVYDTo5Ulpi5C9F7vbpgE3u7cI+iPbhqcrAsbnatGTBE6kDOOdnvNCg==@kvack.org
X-Gm-Message-State: AOJu0Yy6kU99+CT35etlzQGE+HgojVV9eWI23tdivumRCMZh0+pnN8w9
	z9a4EEvkkVT6pVc3X2cRl15PWDjlpeE3N/7kIrtXKHx2zHwHT+CPyD8xq9bGs/A59bQthCLSp1z
	0L6vAyzMxqnfvP44ZdT8jBEoCCSrkl3Q=
X-Gm-Gg: ASbGncuKDEKly+61fScqDRJIuGPOQzF1jTRTCAAMiDLteiU+cChDyv2E4aKtC8BjV44
	+KQevA957E/eXF2pLORSh2EJ9sKwAld3o9FRXodGydJYivYVjOAn8MjxYickjx8ZPm1f2QXI4yz
	0byVACZWUPhdiIupj2MXWnydOQmqWRYZG/Lp4q6UVUe7UIGaz9DgCmn/aEVRW4wFmaFpdufipl0
	mejy/o=
X-Google-Smtp-Source: AGHT+IHxVK00NMC1GHSpVq/sT2EfSuq7omX6wX24xSvgGhrc9yg0F8isqB5neLuF1et0yPorDOiVEfN1u9rtptu/xSU=
X-Received: by 2002:a05:651c:4110:b0:32a:885b:d0f with SMTP id
 38308e7fff4ca-3308f5e2852mr36383791fa.24.1753193364861; Tue, 22 Jul 2025
 07:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250717142732.292822-1-snovitoll@gmail.com> <20250717142732.292822-8-snovitoll@gmail.com>
 <c8b0be89-6c89-46ed-87c3-8905b6ccbbeb@gmail.com>
In-Reply-To: <c8b0be89-6c89-46ed-87c3-8905b6ccbbeb@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Tue, 22 Jul 2025 19:09:07 +0500
X-Gm-Features: Ac12FXxpDsEYsUfFuRK9xdlLStcuqGTW4Nrf9JrgjFdTiyEs4CW8gE7SGsQYdo4
Message-ID: <CACzwLxgjKz-bc1w4SvGu-EeoMvK9Dh=2WpB-A_zC-u7H38QqVg@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] kasan/loongarch: select ARCH_DEFER_KASAN and
 call kasan_init_generic
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com, 
	agordeev@linux.ibm.com, akpm@linux-foundation.org, glider@google.com, 
	dvyukov@google.com, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k9fpon8sma99yje5nnta99fho5xu3ibi
X-Rspamd-Queue-Id: 2FBCB40009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753193366-51905
X-HE-Meta: U2FsdGVkX19BbeOACuSh/kohmt2wZQoMITEuBdm6XLiu0IMPxbaagfSyL1t+C0Tjav9bKVrj4ZDoBYl9FWImgoM32e+vvXsfz3fzU3cut1ePcu85qjDi2uLm/C0KrNC1/31ZYgvSJfNiS2BthLz/dN/Yvc5gdaliBiArPG1PcvRIm5kYW2P2bZs9gqb5rryWtrx2DC6zQCUzSaZ3fl/mbGJrJDdbvi5HXqulBo9K4tQ3MVlDEomf4KUaE/YP6+W5P5xaUd1lfZgoW4rb2jDFttRZiUH5nUgzP13Spd1CDod06lSy0XnxXeQAenIijU2H35YgRx9zuSh9MI6pjYGHBuGlCMlAoSjtP/KKeawO8DrT3aVXtUSNPNKr85FsDTeNUb5stUDen7o00F79Xnt/WWNdRWcSDiX8pZivEHT6LjiFNOQQ6P34oEh1fOSTofGKrLeUcKYfhA/lNcDN4cU15uwfIRhTAcRQCnXg0QOZ1rj/qJsCn7dcB5oqikQ3SMrXNB9ohXSLU/SR/2sd7rSQreo6gPyiBu4uFFGk5Fr3Kj3a1XVOQwCGO4ECupRrUnT95vJFxyoXo74YHk03/2cgEJyMCSvJHmryMvYnwODdah0NVhB9aGnGHZ3+CZmZ5NuqLkYCda+TBFIKKX1aTqSN2jnNNGe1RlyGFSAH74NSkQ0Cu5GmldUQfh8IlH0qHYQeJ60rmljwkqorKDXf53qgX7SEeECUMIC88Y1Lyginl6ahdyJEh5ibSpg66RDFmmQ/Lx00B+ICWom2y7gkjTZ8dldsfn8kBqGrB5iZJHjC9irlAZ9NIlctPSofRCiGg1sHM9GRnvbWSLOmc0OqNW6gWJ5f0udrteTZjGSdRHHLe4flMise5rNMEWAbe9l9pI4B8dwPUgQYSBKF8SQ3Z4nswhq+0SHvJF4EiO1u6vsJz/hi9Je97o0WrMwgiTcJ5zd3PBUMd6PXUyRN9vAz3dQ
 gVHlrtpC
 qRS8L4awyNxvxKgfOu2WRmxrgbmVoNW2T531Hr9sV2bd21RRV2dukyIHx2NUrJYtDwu+A2aVmMkx3pRp7ATXqwy2pOf7uvg3d1qs9eQKYehtvraUyyp1QMp2XR9P9o8FQWbCYmqZeitzVbIDTUNXN/cg9MwT8bGulELxLfQ16xBy3Ni4E4cPf6Vibz0GiSuTz60wHLmSATpuSsz+9dEdagNq///Se0OpogaUzadWs1eqDTb1Q+kiHuNuh7VlE1vjeqDVDmw8oQhT+jVjD1sNZyknIL44Kt/hOBzC3MKwDOftRRkiRJC705m4BJ/9JMQ1LQR6XrPvbrwUljWRp01b7586w4yDKFsJtEp3qMMwnjncaDe0GDGMVsk+oXRRaqYiS8RJezFjLS267G/Xz6DZ0yZYTXXiXGHA/adkwoiZUJYKXuUrD4VHuHPOyr7qGHyDnwL4/3U1L7nLX1lamtXtWldgW+EcT4S/vdbG16h4+X48CipX0EmTvprHynw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 4:00=E2=80=AFAM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
>
>
> On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
>
> > diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/includ=
e/asm/kasan.h
> > index 62f139a9c87..0e50e5b5e05 100644
> > --- a/arch/loongarch/include/asm/kasan.h
> > +++ b/arch/loongarch/include/asm/kasan.h
> > @@ -66,7 +66,6 @@
> >  #define XKPRANGE_WC_SHADOW_OFFSET    (KASAN_SHADOW_START + XKPRANGE_WC=
_KASAN_OFFSET)
> >  #define XKVRANGE_VC_SHADOW_OFFSET    (KASAN_SHADOW_START + XKVRANGE_VC=
_KASAN_OFFSET)
> >
> > -extern bool kasan_early_stage;
> >  extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
> >
> >  #define kasan_mem_to_shadow kasan_mem_to_shadow
> > @@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *addr);
> >  #define kasan_shadow_to_mem kasan_shadow_to_mem
> >  const void *kasan_shadow_to_mem(const void *shadow_addr);
> >
> > -#define kasan_arch_is_ready kasan_arch_is_ready
> > -static __always_inline bool kasan_arch_is_ready(void)
> > -{
> > -     return !kasan_early_stage;
> > -}
> > -
> >  #define addr_has_metadata addr_has_metadata
> >  static __always_inline bool addr_has_metadata(const void *addr)
> >  {
> > diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_i=
nit.c
> > index d2681272d8f..cf8315f9119 100644
> > --- a/arch/loongarch/mm/kasan_init.c
> > +++ b/arch/loongarch/mm/kasan_init.c
> > @@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata _=
_aligned(PAGE_SIZE);
> >  #define __pte_none(early, pte) (early ? pte_none(pte) : \
> >  ((pte_val(pte) & _PFN_MASK) =3D=3D (unsigned long)__pa(kasan_early_sha=
dow_page)))
> >
> > -bool kasan_early_stage =3D true;
> > -
> >  void *kasan_mem_to_shadow(const void *addr)
> >  {
> > -     if (!kasan_arch_is_ready()) {
> > +     if (!kasan_enabled()) {
>
> This doesn't make sense, !kasan_enabled() is compile-time check which is =
always false here.

I should've used `!kasan_shadow_initialized()` check here which provides
the needed runtime behavior that kasan_early_stage used to provide.
Will do in v4. Thanks!

>
> >               return (void *)(kasan_early_shadow_page);
> >       } else {
> >               unsigned long maddr =3D (unsigned long)addr;

