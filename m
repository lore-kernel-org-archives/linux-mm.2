Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42890CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BAF8E002B; Wed, 15 Oct 2025 08:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863838E0020; Wed, 15 Oct 2025 08:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752468E002B; Wed, 15 Oct 2025 08:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 614988E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:47:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D79D714015C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:47:08 +0000 (UTC)
X-FDA: 84000323736.02.7C3337F
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDA9380018
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:47:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AcgJFodJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760532427; a=rsa-sha256;
	cv=none;
	b=rvtmRVrTnDSOjWC8tdeu5X3Fs0AewVD40w9EfgtEuHPzCQHhjQ2ghzRQvi529IAmGelN2D
	yXL55laC+7ZydMM8+2WNpDm9dfzNvBGFhOw4zJVyINxFDF7+ExUabLjM5Z9rW4dx99o+ZI
	IrtJ+8H0upzv8z+Uey4zMvTUpH56CUM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AcgJFodJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760532427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2rJf2s9a/90ejKbIMoBGAX/K6G3zekU+IsWPNH59pU=;
	b=4MS0fQoedd0X7MEIICeatVUP6R5qKJZ6v2MuGdM1wdwrWeDlPPMsl4b05B9htZSKRDudEr
	iOFZcLd5STNOsVEN4pu8UOe3Xrdbdk503hRIM0kAP9XsXKhdDwCf+K9T9JUd9Zl3+VkyCG
	4dO6T+JUlN7M/JBE+6czIQR5mNo72x4=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fca01f0d9so13266831a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760532425; x=1761137225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2rJf2s9a/90ejKbIMoBGAX/K6G3zekU+IsWPNH59pU=;
        b=AcgJFodJ9n/0lZzfihv/U33wZofGemCh4RNlzFeGFz9a8JdRbp5CtADX/NECNJfrOX
         Knj5K27CKrt5LIVl9pRIS+e7LgwAOwxHEjw3p86Fblp5tuMuJFVPltGal4Cy/eLYjaad
         0svdvtBCP3dZBQI4o479x1wGwgGC/UMVCzbE7fa8v8IQEzOoF7VYE1ECinSikSe10QvP
         nuDlzWBTk5pH/H0rCjlUfCZTlxCvNYrLUIJMcg4ggR3Sc6BTUVRRBLQKFqoB3+kEkt8c
         zyA9E4mIBo14RlIlYRzWSo/x2o6rTwtB4c+0OYnXJFlshCLU/ZRPEIcfgcuJNFPtsTFN
         QlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760532425; x=1761137225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2rJf2s9a/90ejKbIMoBGAX/K6G3zekU+IsWPNH59pU=;
        b=iZl8mM5WFcXrffMR9Z0ezfXYokHX2kHCWgXTbTOH+YKH5YqzobsFfqr6UpOpMqT522
         JWkAdC+SWiNvvH8pjWPsR2qltffEKRQBqd1T4xJoa7X38V55cmh4v4/MfgoBmo+Eocm3
         6KNe5XUClYq1aE2Xh97YonSuKhIouF+qrP6NAFyn/nSV/Jx4UO3KwAQ1Yc6uL0Ktt7xv
         aHobpW0p6N5QAvldit3GHHjQPi6VybESdLiSMzQAmcrEIM5gZZCrMZZ7I+RaIV2SCpI/
         /bD6ZOvHQeFZuQWJZhsjmGn595IDH6oqrcqOLWyHzeWuzoO7dZuvKdDjhTZOG/O5OBp8
         HUNg==
X-Forwarded-Encrypted: i=1; AJvYcCULKOrP2lsdbMhOE5ZqrkNEqJjQuFU8xM2SSBo3Sqq7Fg3qXXIto9luaR3dF91ET06SwBJFDsgaew==@kvack.org
X-Gm-Message-State: AOJu0YwAPgYsDG4/vpa7uGrq0AJcXWV18v1hugT90p/lVowOmRmhSEi5
	SfdZulhBjo5Zb//3pV+ujt0Nm7vDfu2gsZmOmi46n57RljPHQ8cs3wS/uNuMs+K9kYCTZuJLo2F
	MaT7MM4hgDxvrAwtfAPYVQAq8B0C8yxV9hSf6lT4fhg==
X-Gm-Gg: ASbGncsfcdfCkiUACIWAnr8kKWPgleogrmqEot+SEaQT5ZZuoZ5QV20O6nuNyrHFt4U
	PLiYin9RHuzs1YOFCWU+U9ImK+egc7kn5QwuQtxmsuOqjiSDByiAph+4rw8sdJWT3ZE+aWWz4RM
	bYDx66TzMz8vO6EP4IkvzJTbHtZCCZRzx5RZLa1psiu2zgIEHyoa6vcS4KboY2d9/vxWn31oq3Q
	NA3MVeWdKZLDcPy4iBYmudBxskn6vCzCg==
X-Google-Smtp-Source: AGHT+IGAFTqJVPwHxcA0ShT3fW/qoKauowy5jUJdRfRhyaAyJD7junVZzX8Qqs0XlApvrohmQUMYJX1KeVDcUbjxRvs=
X-Received: by 2002:a05:6402:210d:b0:639:e9a4:a5f1 with SMTP id
 4fb4d7f45d1cf-639e9a4c39amr26557075a12.27.1760532425223; Wed, 15 Oct 2025
 05:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <aO9dSizvhyTznMHZ@kernel.org>
In-Reply-To: <aO9dSizvhyTznMHZ@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 08:46:28 -0400
X-Gm-Features: AS18NWDCS4lqUlJea3J3apqOO7D5fdtAUaxHwzBnnNw5P6AFHB0NDa_9X__oGwk
Message-ID: <CA+CK2bB6GiivEhHYUg8roSug_cAnPBHJTc=J13nS+7iRJD7rTg@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hztmipmubmo19kbipsin98bef7p8g65o
X-Rspamd-Queue-Id: DDA9380018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760532426-404266
X-HE-Meta: U2FsdGVkX1/iAXiue5E0bQmXYzdScuZvqda9AtMbLIlHtO+M6AKQdSqW3H58SLIsEDhAmXFVbX8fUP7V/lpwGZWoVyqjV7c+pF7smyDuTLkRrcrHhbv3FYS3J3QZjetyLVXEJxu4DG20KN+fVnptwHx3juHSPUox1r/YVL2PurQ6i1mBeopJvZfj7mcLleCpRgDTO4Js+AJaVt+K407dRnRBvUlNZqVu35HJFS/zx8ZeI2gL8xPOlePGVPdq0/saiMYgYywRqko83VqYZoqyhj2MDcvxxoT3PfTZSErN+pSTn9asi9c7vXY2CQEg7uILWGBVnKr8FNPYyHU6RtPxvFlMCL0GfPT6AS+Xuv4mkALocbW+v7rlQz50PyjqnAxaSdcYxg41PzN5Q1++nbcCQ+boA/NlLbGyDYPWgCqdHLfDIsMHVQ2HPfdRZNYBiP4KIszAPqypuc1TQRGPf6m2qmRP3n5e0ONUKCC5yHehq6V4VGp2jVX1c0L9+0e9K7ech/S+/Kn2DJ+bUYxF8arSUBwqYb1beaFbxWP24usG5QfWeJLw3QzQ+W8a+P2DxD3i3IDyT2g8nzCZNT2A1LldNiJ9eE8TzOit4Ry+TUU30ACFY+ojkHLd1XycXQCAVCl3LOWW2VKnnIVFVIG8LpOrXdXGrYGLdBXlCfkfOwpzJ2QCmEi0r7MTSiwTZcnlZ7kpnEMz9nX1rpjzvgCObA5gCRu58mKHYfZbdIIrDynuMwe7RZpYngwlZAfJ5IK+Yb/tJb7eKTim9nMBmWmzZ9TC/4C8UytlrxOfy5/TLPINzTAQLjNEhjnBuCOMhAhe2TbFCry+LSUi5WOy0MRpKDYmER6/7u5v5cyaDeVjek8IGiP/gA16NQA3edvlBtD4pO9Fsm192APVpn1yNNStmwb9GM96tFGTk/3uq0m88Rb/Y5YNBmCJrryga0n72UHg9wz4zmo8gWuuRhXhdPt9TjE
 p2zyqUEi
 t2H6zMBVRDuWwIrOMZk4ypLrnrH1DGhWUZlpO/prFG5awRlx2ZZKeNdZoWB/aDaP2hOtRZiekCZ+b07Dgcdm+B/H5m1dBT4AYHaGGY6+INTjoCMxpqqcBmZs/UFicOmgMqx1OvfvwDONdvfQBsTVg6CSRQ2CHfGhxdve2n8TZYjVTQ4KGLaIigpbu1c/wYKuD0c1UDEWFgvXxAG8AfkSCOF7x1kHW2QZMI+H5FHy5rwPyThY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 4:37=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Oct 15, 2025 at 01:31:21AM -0400, Pasha Tatashin wrote:
> > KHO allocates metadata for its preserved memory map using the SLUB
> > allocator via kzalloc(). This metadata is temporary and is used by the
> > next kernel during early boot to find preserved memory.
> >
> > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > randomly intercepted by kfence_alloc(), which services the allocation
> > from a dedicated KFENCE memory pool. This pool is allocated early in
> > boot via memblock.
> >
> > When booting via KHO, the memblock allocator is restricted to a "scratc=
h
> > area", forcing the KFENCE pool to be allocated within it. This creates =
a
> > conflict, as the scratch area is expected to be ephemeral and
> > overwriteable by a subsequent kexec. If KHO metadata is placed in this
> > KFENCE pool, it leads to memory corruption when the next kernel is
> > loaded.
> >
> > To fix this, modify KHO to allocate its metadata directly from the budd=
y
> > allocator instead of SLUB.
> >
> > As part of this change, the metadata bitmap size is increased from 512
> > bytes to PAGE_SIZE to align with the page-based allocations from the
> > buddy system.
> >
> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation=
")
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index ef1e6f7a234b..519de6d68b27 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -66,10 +66,10 @@ early_param("kho", kho_parse_enable);
> >   * Keep track of memory that is to be preserved across KHO.
> >   *
> >   * The serializing side uses two levels of xarrays to manage chunks of=
 per-order
> > - * 512 byte bitmaps. For instance if PAGE_SIZE =3D 4096, the entire 1G=
 order of a
> > - * 1TB system would fit inside a single 512 byte bitmap. For order 0 a=
llocations
> > - * each bitmap will cover 16M of address space. Thus, for 16G of memor=
y at most
> > - * 512K of bitmap memory will be needed for order 0.
> > + * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE =3D 4096, the ent=
ire 1G order
> > + * of a 8TB system would fit inside a single 4096 byte bitmap. For ord=
er 0
> > + * allocations each bitmap will cover 128M of address space. Thus, for=
 16G of
> > + * memory at most 512K of bitmap memory will be needed for order 0.
> >   *
> >   * This approach is fully incremental, as the serialization progresses=
 folios
> >   * can continue be aggregated to the tracker. The final step, immediat=
ely prior
> > @@ -77,7 +77,7 @@ early_param("kho", kho_parse_enable);
> >   * successor kernel to parse.
> >   */
> >
> > -#define PRESERVE_BITS (512 * 8)
> > +#define PRESERVE_BITS (PAGE_SIZE * 8)
> >
> >  struct kho_mem_phys_bits {
> >       DECLARE_BITMAP(preserve, PRESERVE_BITS);
> > @@ -131,18 +131,21 @@ static struct kho_out kho_out =3D {
> >
> >  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, =
size_t sz)
>
> The name 'xa_load_or_alloc' is confusing now that we only use this functi=
on

Indeed, but this is not something that is done by this patch

> to allocate bitmaps. I think it should be renamed to reflect that and it'=
s
> return type should be 'struct kho_mem_phys_bits'. Then it wouldn't need s=
z
> parameter and the size calculations below become redundant.

I am thinking of splitting from this patch increase of bitmap size to
PAGE_SIZE, and after that re-name this function, and remove size_t
argument in another patch, and finally the fix patch that replaces
slub with buddy.

>
> >  {
> > +     unsigned int order;
> >       void *elm, *res;
> >
> >       elm =3D xa_load(xa, index);
> >       if (elm)
> >               return elm;
> >
> > -     elm =3D kzalloc(sz, GFP_KERNEL);
> > +     order =3D get_order(sz);
> > +     elm =3D (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
> >       if (!elm)
> >               return ERR_PTR(-ENOMEM);
> >
> > -     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> > -             kfree(elm);
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm),
> > +                                     PAGE_SIZE << order))) {
> > +             free_pages((unsigned long)elm, order);
> >               return ERR_PTR(-EINVAL);
> >       }
> >
>
> --
> Sincerely yours,
> Mike.

