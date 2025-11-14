Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38E8CE8D69
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E8F8E0048; Fri, 14 Nov 2025 12:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15F38E000A; Fri, 14 Nov 2025 12:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC7E8E0048; Fri, 14 Nov 2025 12:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6F418E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:55:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 710211403D9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:55:39 +0000 (UTC)
X-FDA: 84109965198.17.66937F9
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D2D4C0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:55:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ayAKNbti;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gEcuTmU00mCZqfk4m/VlByDhVR9d3CRF5yUAWb2ups=;
	b=6vXBJ3ITZV4ZtWIy8Ne9rxSZy4wZRQEdCGZ23eex9JBDnRoP1J27fwGd2elpce9rIbBDBa
	63oVQVoeCfrGbei4EGOsGnsoaQed+J8gPWWGp5jVis8A/C0cy97SX7aKpI4Mkz3VtSpTxW
	cZLSso6PRvs2gYiwu9AlAmZ4vPI1OSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763142937; a=rsa-sha256;
	cv=none;
	b=Zu1uQk5r316UfqEUR4KEIu9Xq7LKlbZsnRjacXHBbk5mKKuaePig8EOQe44Ljv3Ym6nGJm
	X3yn8FFsQO6CPacrvLpQXkIXV2YeOtaGePTrR+5ofobPHudnyh3rLyqVvA/sQwaINNuHHr
	hNrr+ItnpvnoR0uqPiY87TDOsWuEjY4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ayAKNbti;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso3908906a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763142936; x=1763747736; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gEcuTmU00mCZqfk4m/VlByDhVR9d3CRF5yUAWb2ups=;
        b=ayAKNbtip3LyloYjIci4b7U6XDAloi6idSmpljKuXLDNpzb5fM4MSzGevP9g5Ayud9
         sXDY0ejSZEY6JUDT3gX3xaB8JxxPZFi4Riv1UbVNM9a/e54F2Xa0jyUPBEWI2GIsQLk/
         tnCx+uB48XOG2eDqtgs8IxYhlgFLJ8xz5IXj+OgcRg74BLu94MteJQ6Q46qmb8SlcQRE
         ME2u9rTLuMYfLPAFaqwhxi4fKMX0RK7lIkspGoBt5b9Uun+De9+PaV82H9ad2R0LAzWE
         Hmr9jCeew1gwTByBQ0kyaHuwYWFbfRIIg7xZnCKndR4+yyB63vaoYr9A/qrdMxWw8krt
         TRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763142936; x=1763747736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5gEcuTmU00mCZqfk4m/VlByDhVR9d3CRF5yUAWb2ups=;
        b=WgIVwP5MdEX/ye4yVfs3SYYXjGyihw4Rwm6+48LUkN5cHZGiVBwZZM3T89o53wr6NV
         kJa8twc2hCMwrZPZKNsSXAyqKK/HCA0jOOAwNQAChf3k3CdUb67bemsjykfvNqbVLzQe
         XPgrvHyAhPFfNsiEM7PlyvCegsUZYORJCijlWhXZr1geZbWveUlU6CK9c7Q26WP4LhcB
         A2Mt01eXQ7bV56EZy2/bRGSUXS51GKZicbNNEwQUSVRBT0lrP/j431O1UJ2dk69xor1g
         ILjOxSJYp1LigeBRHdCI0cnGtfzot1753r1PQytpBZuihQ8i1xU4+kmXQ8x2RQmH05Pp
         8IuA==
X-Forwarded-Encrypted: i=1; AJvYcCUGIvMy+Mowrp2erLU/6HmreRDWPyd13+SaiJIGLY6loNDiDFp4JGiJ9CUkChMa0LiSjrLkZcjBjw==@kvack.org
X-Gm-Message-State: AOJu0YyeBbcjhdTgttKBGdRzqbeuCk1mTMDxhIddf96wqsCgdTD6jMDo
	J2ZJAKmEgJI8hRkpGeMBLCr0d9HqVKBSo/OmeG0g1E+14EaPv0K4uKFdIFhtPsAI8naLDafoBQL
	OgEBkUmoOyS03JpIbND98q8kW0C4SK/hWRuymKLCfFw==
X-Gm-Gg: ASbGncv0Hgh6DIRu6I7VEp8/Zeqb0pfJ/YTc4wPME8tby/Fe0wIxdkcFNY67oqX18Et
	TjLjqWVo7qiOmpKoK6M1XV0AojaSZQ2QiyegSIfO/G/3thuEeyi0qpVjM6CCy+ZYqSMB/iDjr2K
	y1GxIHMqkG4AkULhELIOG9IO94nAzko2NSE0h9OUloM/zr2qIqzxGOB+FjnxG4xAhqt5G5O8AdP
	VmihvocMnYO6uPJ2KGrp/MpjBjwszclDV0gYo/1p+EqYzy93tivalEwCMnhfQIReFha
X-Google-Smtp-Source: AGHT+IE/pUAFReDEhKsxRDV2cL6tpIxJ1mhw5f1DZB2MJBkBG0VZktDDpA84kaoQHR8TX4r0XzDH9lhrcuh4WEcb+1k=
X-Received: by 2002:a05:6402:2710:b0:640:6653:65c1 with SMTP id
 4fb4d7f45d1cf-64350e03876mr3623108a12.5.1763142935814; Fri, 14 Nov 2025
 09:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-14-pasha.tatashin@soleen.com> <mafs0qzu05wz1.fsf@kernel.org>
In-Reply-To: <mafs0qzu05wz1.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 12:54:59 -0500
X-Gm-Features: AWmQ_bnFnEkRgJfJSBtZx9VdxbTw3Y6MhHBaDkb1rPplthz1zT5z-mlity4cV_U
Message-ID: <CA+CK2bA9OKvJH+kwd8nWaOUayAzPOO1U74jW8x22t3GmA-wH7g@mail.gmail.com>
Subject: Re: [PATCH v1 13/13] kho: Introduce high-level memory allocation API
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: etkxgaymb5kgz8icq6y8h47dg8efr9ez
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D2D4C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763142937-521258
X-HE-Meta: U2FsdGVkX18ufIPyqQvbFKerRbchVJgXd4YLixvBWFmSMtvc25/qyXG4yL055hplITcEAfNGkZlOr+wGJMnENSD+QdqrrdSDbEAH0beanId4dWzrtQRKvMRNtGsRXJYX4Rc7+GL1WgdCJH8WclqAeSkwYQefZngCIBXoOPCKZmb4aJU5TDt14NgXLyVxbYkT34LnbF4035pMnquQMnp7eF9d0vTy223HipTZA4lweUlGIC6Jx+TrSHSIxr+mtnGD7d+nnN+9+u3Box/qpftvmDwLcI1k+AnxC3MzH0ivFofBfawFlRLvqhY3ZByhgg6jGAWUT6CS3NRGjriPG1CSEM6H1Ui7QchhEtuoUofhoi+Io+aeYPGljA+E9vCzU82koaiJE74TxNo3OxDtV4ZLH+nlFtRYP6M+kLe/3lje5h2nuFHuMsgNChiq7egcnt4SpXk4GwRRmEsdK/baLOI//PlFh3Mcxs/x1ivrAruBUOqZKhf+018uY/D9WqK6nrkci+YACyA+xCMeEzpX2Uuybrzb8ZustsJwZs7ZU4C+ZMFNKC6JB8qNsbvZLbf2CTPBSUSrIWzzWI+Hf2S/WU+iY695Wpw6EPRfH+67YZ36OhCNNzXBo+m64zEDeIB5TyO0x06YJNwgemclxyd4XJHBuADDyt4GgTc/IhNJqpc9rTwcAQWz654LxmCeEuYf32hgQxDdxBeWDntEGVy4Zc94BRv9BtLDuwvaLUcVTyTUj32S/pkmx7gveLxK1XO6+nvI1nmiHWUfO4dYlnHXq9j3TCXQFZaaniYDe1odNZygTVAhYOld+Oo6MtRzyHsZ9Rp+z0o9fnqoTMKXCC+M1FAUv1IyqxsF34wPidbTzWSL7vTeCXBRIgZlEJJO5rxHCtxS5zfXAQ4uImnQz5o/bTKtLmahbNTigm4JFZAowTSHV9zityULAqpD5P4e2b2WaUr0BHGu/cEIn5bcT0sKHGy
 5xVzDspO
 RUAAWBfR7K3rxJnfhDRnzrnGKMHwQjO1i5eJaXO5ZF+uyI1ZEPd6ndu+/D3DIPZbDTEoEklPb8qbuHfQ+qOpIgrcrVIfZ3aVpBO5nehm2ORnTtvvmoV7qwxktUdCBLdYiYbkadM+qkeQ6v8kTz+iSkWGaOjVm7LW4QjMcGeMeSdBIFCH4YzYhH/cm2n/TPGGpwIUuDCSqJwOv5D9d6os8eqhAgkrR5KVOzH3cB/UmJi2sw9x4Tgv6f3gXba1vnV+3g18L8GIfCbRQRE/6i5pOxXKj8BB/EPE0NrK3wyc/b2rEh/N2pgb9pRq5TYVwUzZQPos1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 12:45=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>
> > Currently, clients of KHO must manually allocate memory (e.g., via
> > alloc_pages), calculate the page order, and explicitly call
> > kho_preserve_folio(). Similarly, cleanup requires separate calls to
> > unpreserve and free the memory.
> >
> > Introduce a high-level API to streamline this common pattern:
> >
> > - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
> >   memory and immediately marks it for preservation.
> > - kho_free_unpreserve(ptr, size): Unpreserves and frees the memory
> >   in the current kernel.
> > - kho_free_restore(ptr, size): Restores the struct page state of
> >   preserved memory in the new kernel and immediately frees it to the
> >   page allocator.
>
> Nit: kho_unpreserve_free() and kho_restore_free() make more sense to me
> since that is the order of operations. Having them the other way round
> is kind of confusing.

Sure will rename.

>
> Also, why do the free functions need size? They can get the order from
> folio_order(). This would save users of the API from having to store the
> size somewhere and make things simpler.

Yes, size is not needed, I will remove it.

Thanks,
Pasha

>
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kexec_handover.h     |  22 +++++--
> >  kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++++++
> >  2 files changed, 116 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_hando=
ver.h
> > index 80ece4232617..76c496e01877 100644
> > --- a/include/linux/kexec_handover.h
> > +++ b/include/linux/kexec_handover.h
> > @@ -2,8 +2,9 @@
> >  #ifndef LINUX_KEXEC_HANDOVER_H
> >  #define LINUX_KEXEC_HANDOVER_H
> >
> > -#include <linux/types.h>
> > +#include <linux/err.h>
> >  #include <linux/errno.h>
> > +#include <linux/types.h>
> >
> >  struct kho_scratch {
> >       phys_addr_t addr;
> > @@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page, unsigned in=
t nr_pages);
> >  int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
> >  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
> >  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
> > +void *kho_alloc_preserve(size_t size);
> > +void kho_free_unpreserve(void *mem, size_t size);
> > +void kho_free_restore(void *mem, size_t size);
> >  struct folio *kho_restore_folio(phys_addr_t phys);
> >  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages=
);
> >  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> > @@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc(struct kh=
o_vmalloc *preservation)
> >       return -EOPNOTSUPP;
> >  }
> >
> > +void *kho_alloc_preserve(size_t size)
> > +{
> > +     return ERR_PTR(-EOPNOTSUPP);
> > +}
> > +
> > +void kho_free_unpreserve(void *mem, size_t size) { }
> > +void kho_free_restore(void *mem, size_t size) { }
> > +
> >  static inline struct folio *kho_restore_folio(phys_addr_t phys)
> >  {
> >       return NULL;
> > @@ -122,18 +134,14 @@ static inline int kho_add_subtree(const char *nam=
e, void *fdt)
> >       return -EOPNOTSUPP;
> >  }
> >
> > -static inline void kho_remove_subtree(void *fdt)
> > -{
> > -}
> > +static inline void kho_remove_subtree(void *fdt) { }
> >
> >  static inline int kho_retrieve_subtree(const char *name, phys_addr_t *=
phys)
> >  {
> >       return -EOPNOTSUPP;
> >  }
> >
> > -static inline void kho_memory_init(void)
> > -{
> > -}
> > +static inline void kho_memory_init(void) { }
> >
> >  static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >                               phys_addr_t scratch_phys, u64 scratch_len=
)
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index a905bccf5f65..9f05849fd68e 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -4,6 +4,7 @@
> >   * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
> >   * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kerne=
l.org>
> >   * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com=
>
> > + * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
> >   */
> >
> >  #define pr_fmt(fmt) "KHO: " fmt
> > @@ -1151,6 +1152,106 @@ void *kho_restore_vmalloc(const struct kho_vmal=
loc *preservation)
> >  }
> >  EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
> >
> > +/**
> > + * kho_alloc_preserve - Allocate, zero, and preserve memory.
> > + * @size: The number of bytes to allocate.
> > + *
> > + * Allocates a physically contiguous block of zeroed pages that is lar=
ge
> > + * enough to hold @size bytes. The allocated memory is then registered=
 with
> > + * KHO for preservation across a kexec.
> > + *
> > + * Note: The actual allocated size will be rounded up to the nearest
> > + * power-of-two page boundary.
> > + *
> > + * @return A virtual pointer to the allocated and preserved memory on =
success,
> > + * or an ERR_PTR() encoded error on failure.
> > + */
> > +void *kho_alloc_preserve(size_t size)
> > +{
> > +     struct folio *folio;
> > +     int order, ret;
> > +
> > +     if (!size)
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     order =3D get_order(size);
> > +     if (order > MAX_PAGE_ORDER)
> > +             return ERR_PTR(-E2BIG);
> > +
> > +     folio =3D folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
> > +     if (!folio)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     ret =3D kho_preserve_folio(folio);
> > +     if (ret) {
> > +             folio_put(folio);
> > +             return ERR_PTR(ret);
> > +     }
> > +
> > +     return folio_address(folio);
> > +}
> > +EXPORT_SYMBOL_GPL(kho_alloc_preserve);
> > +
> > +/**
> > + * kho_free_unpreserve - Unpreserve and free memory.
> > + * @mem:  Pointer to the memory allocated by kho_alloc_preserve().
> > + * @size: The original size requested during allocation. This is used =
to
> > + *        recalculate the correct order for freeing the pages.
> > + *
> > + * Unregisters the memory from KHO preservation and frees the underlyi=
ng
> > + * pages back to the system. This function should be called to clean u=
p
> > + * memory allocated with kho_alloc_preserve().
> > + */
> > +void kho_free_unpreserve(void *mem, size_t size)
> > +{
> > +     struct folio *folio;
> > +     unsigned int order;
> > +
> > +     if (!mem || !size)
> > +             return;
> > +
> > +     order =3D get_order(size);
> > +     if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
> > +             return;
> > +
> > +     folio =3D virt_to_folio(mem);
> > +     WARN_ON_ONCE(kho_unpreserve_folio(folio));
>
> This is what I meant in my reply to the previous patch.
> kho_unpreserve_folio() can be void now, so the WARN_ON_ONCE() is not
> needed.
>
> > +     folio_put(folio);
> > +}
> > +EXPORT_SYMBOL_GPL(kho_free_unpreserve);
> > +
> > +/**
> > + * kho_free_restore - Restore and free memory after kexec.
> > + * @mem:  Pointer to the memory (in the new kernel's address space)
> > + * that was allocated by the old kernel.
> > + * @size: The original size requested during allocation. This is used =
to
> > + * recalculate the correct order for freeing the pages.
> > + *
> > + * This function is intended to be called in the new kernel (post-kexe=
c)
> > + * to take ownership of and free a memory region that was preserved by=
 the
> > + * old kernel using kho_alloc_preserve().
> > + *
> > + * It first restores the pages from KHO (using their physical address)
> > + * and then frees the pages back to the new kernel's page allocator.
> > + */
> > +void kho_free_restore(void *mem, size_t size)
>
> On restore side, callers are already using the phys addr directly. So do
> kho_restore_folio() and kho_restore_pages() for example. This should
> follow suit for uniformity. Would also save the callers a __va() call
> and this function the __pa() call.
>
> > +{
> > +     struct folio *folio;
> > +     unsigned int order;
> > +
> > +     if (!mem || !size)
> > +             return;
> > +
> > +     order =3D get_order(size);
> > +     if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
> > +             return;
> > +
> > +     folio =3D kho_restore_folio(__pa(mem));
> > +     if (!WARN_ON(!folio))
>
> kho_restore_folio() already WARNs on failure. So the WARN_ON() here can
> be skipped I think.
>
> > +             free_pages((unsigned long)mem, order);
>
> folio_put() here makes more sense since we just restored a folio.
>
> > +}
> > +EXPORT_SYMBOL_GPL(kho_free_restore);
> > +
> >  int kho_finalize(void)
> >  {
> >       int ret;
>
> --
> Regards,
> Pratyush Yadav

