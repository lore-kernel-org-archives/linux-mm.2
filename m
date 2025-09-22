Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E46DCAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4888E000B; Mon, 22 Sep 2025 10:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E1B8E0001; Mon, 22 Sep 2025 10:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C628E000B; Mon, 22 Sep 2025 10:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0058E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:18:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5743BAA41
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:18:36 +0000 (UTC)
X-FDA: 83917091832.24.C2E8154
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6FEDA000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:18:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AQE+8QDj;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758550714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SOuRg8CAw4qdC6TljMIQSoNCuXerOjdSHs4nx/il8o=;
	b=NsoSOnTXTeeT6gHLzuI5CXhj0Bjh2vaG4C8uDBMKZcUCWegzZ4ngUkvofZb2ZwS6afjcjZ
	SryWSxosEF1++fOzGddZ+a8FNmMfvyO/idn/BFkeLHRDkxHZORcChWQ5WcUcUK/g2r7O4g
	ReBxyvjL52zXt5OVQFStHBqyFO4iuFw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AQE+8QDj;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758550714; a=rsa-sha256;
	cv=none;
	b=LMTq7FFGR/jpY2tEATmVdG4VNyIidRmPLiBteFHB3vO8lo7uGfw9Ep8wOKZGpSIbVvQ19g
	tDtaRim8QqnjvS71XsM3sarJQJjr2dT+9Tfko8VO6ixY+kEpi1MJomy/zvBy9cEoTTctxD
	Zysbh6tk5kh04jub9mtqNGrsBrMiqAY=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4d1c5c3f77eso1951491cf.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758550714; x=1759155514; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SOuRg8CAw4qdC6TljMIQSoNCuXerOjdSHs4nx/il8o=;
        b=AQE+8QDj/heeQiNGoIdKBE8AdeDSATwedTBIGf9IIFjC/uNTohzHvC1+2ErJ2UuQ5K
         hrF9FfYPuamH04/kRUnPNHJr9xbjCV8Vsc/XFWLFo/jFYHTAYxvpE84p3V5cjOL9weri
         jIB/deiSaUgon4v6M54q5rIB/RS16+UZkoDMCF8P5JJS9ge466zxDAOhYlC3BlUPGEis
         BS94gJWLmWO5vaBUmFws9DpLsLVcHUHoiKpeXmeHld475PWnd8va6ehA4zjCMCcFKZsA
         6K11qOhZU0hhS1QizQCPyDL3+4Ft423Sg8PWUxwMVe3oxFBFuKiedy22vp/mR6iHKMd/
         OBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758550714; x=1759155514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3SOuRg8CAw4qdC6TljMIQSoNCuXerOjdSHs4nx/il8o=;
        b=j8MRUJ+gLIGAnvqDxR1A4/PL5r4onjiRkerLOSc8eF9SB7I/bwuxLQ7T3oN90kZ+0v
         Z1gfXZrxVoAIpN0sDN4JEG7DyNzNxByR9m+BY6Np843IG4KXqCTxzgkhd6PsaKoYPvls
         4uKK+im9PhSZ1vRPIaEkH7bfcEREyx1bVB81TbmIhab4hMYYuGfOGXhRM6N9PNmA4XBH
         lB5S2BEg/El5Y7dz0Y2bSZfhXMmXzwRS/kwebvO8PaKQoXJxN/huFdx/L/T3UcvUSRcv
         ZY6VJTVfupb/fhgLrtYMFBZ03dw6p+xwC3QZXE9EhXWa1muC2SFrUl4Dq6p0vzBomOVm
         gxpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTUs35DlM9qoIOU4m2RxgZzpJWA8nmAHzjR/MO3jsERXOTtmDFrJcIn8+huuIGjiXtGJgT1OheEQ==@kvack.org
X-Gm-Message-State: AOJu0Yzd1pwsdKiCzQJf755Ny1kSr760rRZePpDtwFGY4z3x/vQJkGaK
	EcgagiYoprQppZJ4R6XNZ3HEOYsFVXvRDbya/zj16GKDBk1YsWqXg3g1PUIB3KqcmCr/DTdr1bR
	sRqcVNHotQhFsV+C5/lpS9dT96hCnB+LADYOKHs6JJg==
X-Gm-Gg: ASbGncttkbwSJWZG8JQRaHXq7LskycFAUROmHpMr1/XObi+aa4Wd1fKyDjXO/+T4+1b
	d34R9bj2unbeJ4fX/oLZjjDTPPn/UEyurx/zFrmdJdnONKc3Bu6RD6YDozK/jz+z0wyA6c54GCg
	xbIY2tzUbB6cch0XEyrc8Xxx9si3VuhZOC2bSFDTx/Z1Q7CFCxWY6WZmKFHv9uQaqZfWuIzJaCc
	y6y
X-Google-Smtp-Source: AGHT+IFhqTMUJ5QI5mJ54JxXg7+gUal2FzXiUL3S25XlFP+lq4CAYaIEkRLtdSJ+1NpX7UxhDL1AdOxDY9fOvqLaP/U=
X-Received: by 2002:a05:622a:989:b0:4b3:4e8e:9e32 with SMTP id
 d75a77b69052e-4c03c195262mr170546171cf.3.1758550713588; Mon, 22 Sep 2025
 07:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250921054458.4043761-1-rppt@kernel.org> <20250921054458.4043761-4-rppt@kernel.org>
In-Reply-To: <20250921054458.4043761-4-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 10:17:56 -0400
X-Gm-Features: AS18NWAGcHoTlig1ssHPBFP_C5vSdMZBQ76Hlsz-uZcoUPzzkP0cpDwB-jS3KKo
Message-ID: <CA+CK2bDFScwAwyKA2NNkQhvhrj5OsmHm4eTshw2B9e2muqBcvg@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc allocations
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6FEDA000F
X-Stat-Signature: 8rsrgc74ow87okt4a9kqpyrggoptn4st
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758550714-832370
X-HE-Meta: U2FsdGVkX19vyaS2wru24KRX8n3euBBAQhyUSMZa0MJgeYHG/0qBTbnMLZ4J2NIN0wUYnhm9tk0QnwJtQ5FKBW+fdROtopAatFS7WNslFBZlIs5pi8mUTF57oE09DE29ikiQwEY0WEXsm8zp0xyCkBtYd+LChCO+yYe6Y8BvFwWjAYLF5nufGbIwhwfvfb7Eprj8AHy3U9vtb7jxqYzd5EmegqvNuRpV4ZYlIC2O8PYvaGE9kkvqE2Yq7nptvAeQuDTEH7jNnEhtingSbcAMMgU4u2OY4lM7/DYNsOyBch5aAOINDOtQrOCsq/vmTldf+MsXDKYf5NOBkTBO+RWaqzwIkGcGuJG5psNXwyX2aXwzPsURtbCKp26jdFrU5BHlxlBGUNsbVkqGMEvsHX0eZsZBFKkiu1IBaJKnsPuyjwTaBEWBVrEpSTUhAv/KaoR3aLk3vy1SsJKQgJOR7ZB/9aWjlM0PibBjSRHlwa+XculIbS8mBDNyFUAkVHLiE4pPvYzaUVnhA3UsykfNtIqlJjJe99DlD/s7LIlu5Cz6CnIRqGHF7ozLZqjFY5HHkLMVHUNwvc3hfR1jNOHvTQcT6Z485snsv3TRaJWKGKmupuvAG2tqdmyIGn8ko5Uo5c3fVc0Vok6vbJBmrY44/CLoliPWP82qVR7pbiWiVnO8DExgyqJ4gLjx18RiMmJDZkAUY2XjXZtP41ZRTQX+BnJdQKldTMaM0cFeAcc3FwE0sZks6XTRf1HtRndu8saZWRnSIE9fg6oZSFbEEHt8cPFQwPM8I70KpqAqXvD8bjE0vVnOoVtELGMSsMxx39LgpaqO6085O8ulcdd86v2n/7MZEx4yFc9gamY/a47+ZeNsCfWYZbokNnnUeKf1r5c5FwYwT34YYmMP+3VxykfMNie+Vem6zaRjcZeZiWf3CO/Bg9M2hI01agOMBMI+SvRTFBsZOkxzBcWulhw0ZYymrU7
 K0rz9bVc
 zAfODGZbjOeJTfsfRMgh0GQX7GnpsJ3eVVIReMncD/DgHAOcxX3BViWHABXXHRKCdsFJ1GkSYSwEf8dVt0rxs6J+8WzmE5yTOggAjtkXvFhowcvLJpC+OznugPNh5bLS/MsbEk6G5lza/NNPeziRzlu/3gnkJ5cOZBobuluPM2hsEqw2CVfT3PlvXN3anItYuWXi43lEUKlKyB/kKwGZvewAycZ7u11mfdBjRHJxl0i8EZsWOlJxCkmpgmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 1:45=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> A vmalloc allocation is preserved using binary structure similar to
> global KHO memory tracker. It's a linked list of pages where each page
> is an array of physical address of pages in vmalloc area.
>
> kho_preserve_vmalloc() hands out the physical address of the head page
> to the caller. This address is used as the argument to
> kho_vmalloc_restore() to restore the mapping in the vmalloc address
> space and populate it with the preserved pages.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  include/linux/kexec_handover.h |  28 ++++
>  kernel/kexec_handover.c        | 281 +++++++++++++++++++++++++++++++++
>  2 files changed, 309 insertions(+)
>
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handove=
r.h
> index cc5c49b0612b..49e36d4ae5dc 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -39,12 +39,23 @@ struct page;
>
>  struct kho_serialization;
>
> +struct kho_vmalloc_chunk;
> +struct kho_vmalloc {
> +        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
> +        unsigned int total_pages;
> +        unsigned short flags;
> +        unsigned short order;
> +};
> +
>  #ifdef CONFIG_KEXEC_HANDOVER
>  bool kho_is_enabled(void);
>
>  int kho_preserve_folio(struct folio *folio);
>  int kho_preserve_pages(struct page *page, unsigned int nr_pages);
> +int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
>  struct folio *kho_restore_folio(phys_addr_t phys);
> +struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
> +void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
>  int kho_add_subtree(struct kho_serialization *ser, const char *name, voi=
d *fdt);
>  int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
>
> @@ -71,11 +82,28 @@ static inline int kho_preserve_pages(struct page *pag=
e, unsigned int nr_pages)
>         return -EOPNOTSUPP;
>  }
>
> +static inline int kho_preserve_vmalloc(void *ptr,
> +                                      struct kho_vmalloc *preservation)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
>  static inline struct folio *kho_restore_folio(phys_addr_t phys)
>  {
>         return NULL;
>  }
>
> +static inline struct page *kho_restore_pages(phys_addr_t phys,
> +                                            unsigned int nr_pages)
> +{
> +       return NULL;
> +}
> +
> +static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preser=
vation)
> +{
> +       return NULL;
> +}
> +
>  static inline int kho_add_subtree(struct kho_serialization *ser,
>                                   const char *name, void *fdt)
>  {
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index fd80be3b12fd..e6380d8dce57 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -18,6 +18,7 @@
>  #include <linux/memblock.h>
>  #include <linux/notifier.h>
>  #include <linux/page-isolation.h>
> +#include <linux/vmalloc.h>
>
>  #include <asm/early_ioremap.h>
>
> @@ -274,6 +275,37 @@ struct folio *kho_restore_folio(phys_addr_t phys)
>  }
>  EXPORT_SYMBOL_GPL(kho_restore_folio);
>
> +/**
> + * kho_restore_pages - restore list of contiguous order 0 pages.
> + * @phys: physical address of the first page.
> + * @nr_pages: number of pages.
> + *
> + * Restore a contiguous list of order 0 pages that was preserved with
> + * kho_preserve_pages().
> + *
> + * Return: 0 on success, error code on failure
> + */
> +struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
> +{
> +       const unsigned long start_pfn =3D PHYS_PFN(phys);
> +       const unsigned long end_pfn =3D start_pfn + nr_pages;
> +       unsigned long pfn =3D start_pfn;
> +
> +       while (pfn < end_pfn) {
> +               const unsigned int order =3D
> +                       min(count_trailing_zeros(pfn), ilog2(end_pfn - pf=
n));
> +               struct page *page =3D kho_restore_page(PFN_PHYS(pfn));

This line breaks linux-next build because, kho_restore_page has a prototype=
:
void kho_restore_page(struct page *page, unsigned int order).

> +
> +               if (!page)
> +                       return NULL;
> +               split_page(page, order);
> +               pfn +=3D 1 << order;
> +       }
> +
> +       return pfn_to_page(start_pfn);
> +}
> +EXPORT_SYMBOL_GPL(kho_restore_pages);
> +
>  /* Serialize and deserialize struct kho_mem_phys across kexec
>   *
>   * Record all the bitmaps in a linked list of pages for the next kernel =
to
> @@ -763,6 +795,255 @@ int kho_preserve_pages(struct page *page, unsigned =
int nr_pages)
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_pages);
>
> +struct kho_vmalloc_hdr {
> +       DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
> +};
> +
> +#define KHO_VMALLOC_SIZE                               \
> +       ((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
> +        sizeof(phys_addr_t))
> +
> +struct kho_vmalloc_chunk {
> +       struct kho_vmalloc_hdr hdr;
> +       phys_addr_t phys[KHO_VMALLOC_SIZE];
> +};
> +
> +static_assert(sizeof(struct kho_vmalloc_chunk) =3D=3D PAGE_SIZE);
> +
> +/* vmalloc flags KHO supports */
> +#define KHO_VMALLOC_SUPPORTED_FLAGS    (VM_ALLOC | VM_ALLOW_HUGE_VMAP)
> +
> +/* KHO internal flags for vmalloc preservations */
> +#define KHO_VMALLOC_ALLOC      0x0001
> +#define KHO_VMALLOC_HUGE_VMAP  0x0002
> +
> +static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
> +{
> +       unsigned short kho_flags =3D 0;
> +
> +       if (vm_flags & VM_ALLOC)
> +               kho_flags |=3D KHO_VMALLOC_ALLOC;
> +       if (vm_flags & VM_ALLOW_HUGE_VMAP)
> +               kho_flags |=3D KHO_VMALLOC_HUGE_VMAP;
> +
> +       return kho_flags;
> +}
> +
> +static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
> +{
> +       unsigned int vm_flags =3D 0;
> +
> +       if (kho_flags & KHO_VMALLOC_ALLOC)
> +               vm_flags |=3D VM_ALLOC;
> +       if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
> +               vm_flags |=3D VM_ALLOW_HUGE_VMAP;
> +
> +       return vm_flags;
> +}
> +
> +static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_ch=
unk *cur)
> +{
> +       struct kho_vmalloc_chunk *chunk;
> +       int err;
> +
> +       chunk =3D (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL)=
;
> +       if (!chunk)
> +               return NULL;
> +
> +       err =3D kho_preserve_pages(virt_to_page(chunk), 1);
> +       if (err)
> +               goto err_free;
> +       if (cur)
> +               KHOSER_STORE_PTR(cur->hdr.next, chunk);
> +       return chunk;
> +
> +err_free:
> +       free_page((unsigned long)chunk);
> +       return NULL;
> +}
> +
> +static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk=
)
> +{
> +       struct kho_mem_track *track =3D &kho_out.ser.track;
> +       unsigned long pfn =3D PHYS_PFN(virt_to_phys(chunk));
> +
> +       __kho_unpreserve(track, pfn, pfn + 1);
> +
> +       for (int i =3D 0; chunk->phys[i]; i++) {
> +               pfn =3D PHYS_PFN(chunk->phys[i]);
> +               __kho_unpreserve(track, pfn, pfn + 1);
> +       }
> +}
> +
> +static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
> +{
> +       struct kho_vmalloc_chunk *chunk =3D KHOSER_LOAD_PTR(kho_vmalloc->=
first);
> +
> +       while (chunk) {
> +               struct kho_vmalloc_chunk *tmp =3D chunk;
> +
> +               kho_vmalloc_unpreserve_chunk(chunk);
> +
> +               chunk =3D KHOSER_LOAD_PTR(chunk->hdr.next);
> +               kfree(tmp);
> +       }
> +}
> +
> +/**
> + * kho_preserve_vmalloc - preserve memory allocated with vmalloc() acros=
s kexec
> + * @ptr: pointer to the area in vmalloc address space
> + * @preservation: placeholder for preservation metadata
> + *
> + * Instructs KHO to preserve the area in vmalloc address space at @ptr. =
The
> + * physical pages mapped at @ptr will be preserved and on successful ret=
urn
> + * @preservation will hold the physical address of a structure that desc=
ribes
> + * the preservation.
> + *
> + * NOTE: The memory allocated with vmalloc_node() variants cannot be rel=
iably
> + * restored on the same node
> + *
> + * Return: 0 on success, error code on failure
> + */
> +int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
> +{
> +       struct kho_vmalloc_chunk *chunk;
> +       struct vm_struct *vm =3D find_vm_area(ptr);
> +       unsigned int order, flags, nr_contig_pages;
> +       unsigned int idx =3D 0;
> +       int err;
> +
> +       if (!vm)
> +               return -EINVAL;
> +
> +       if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
> +               return -EOPNOTSUPP;
> +
> +       flags =3D vmalloc_flags_to_kho(vm->flags);
> +       order =3D get_vm_area_page_order(vm);
> +
> +       chunk =3D new_vmalloc_chunk(NULL);
> +       if (!chunk)
> +               return -ENOMEM;
> +       KHOSER_STORE_PTR(preservation->first, chunk);
> +
> +       nr_contig_pages =3D (1 << order);
> +       for (int i =3D 0; i < vm->nr_pages; i +=3D nr_contig_pages) {
> +               phys_addr_t phys =3D page_to_phys(vm->pages[i]);
> +
> +               err =3D kho_preserve_pages(vm->pages[i], nr_contig_pages)=
;
> +               if (err)
> +                       goto err_free;
> +
> +               chunk->phys[idx++] =3D phys;
> +               if (idx =3D=3D ARRAY_SIZE(chunk->phys)) {
> +                       chunk =3D new_vmalloc_chunk(chunk);
> +                       if (!chunk)
> +                               goto err_free;
> +                       idx =3D 0;
> +               }
> +       }
> +
> +       preservation->total_pages =3D vm->nr_pages;
> +       preservation->flags =3D flags;
> +       preservation->order =3D order;
> +
> +       return 0;
> +
> +err_free:
> +       kho_vmalloc_free_chunks(preservation);
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
> +
> +/**
> + * kho_restore_vmalloc - recreates and populates an area in vmalloc addr=
ess
> + * space from the preserved memory.
> + * @preservation: preservation metadata.
> + *
> + * Recreates an area in vmalloc address space and populates it with memo=
ry that
> + * was preserved using kho_preserve_vmalloc().
> + *
> + * Return: pointer to the area in the vmalloc address space, NULL on fai=
lure.
> + */
> +void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
> +{
> +       struct kho_vmalloc_chunk *chunk =3D KHOSER_LOAD_PTR(preservation-=
>first);
> +       unsigned int align, order, shift, vm_flags;
> +       unsigned long total_pages, contig_pages;
> +       unsigned long addr, size;
> +       struct vm_struct *area;
> +       struct page **pages;
> +       unsigned int idx =3D 0;
> +       int err;
> +
> +       vm_flags =3D kho_flags_to_vmalloc(preservation->flags);
> +       if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
> +               return NULL;
> +
> +       total_pages =3D preservation->total_pages;
> +       pages =3D kvmalloc_array(total_pages, sizeof(*pages), GFP_KERNEL)=
;
> +       if (!pages)
> +               return NULL;
> +       order =3D preservation->order;
> +       contig_pages =3D (1 << order);
> +       shift =3D PAGE_SHIFT + order;
> +       align =3D 1 << shift;
> +
> +       while (chunk) {
> +               struct page *page;
> +
> +               for (int i =3D 0; chunk->phys[i]; i++) {
> +                       phys_addr_t phys =3D chunk->phys[i];
> +
> +                       if (idx + contig_pages > total_pages)
> +                               goto err_free_pages_array;
> +
> +                       page =3D kho_restore_pages(phys, contig_pages);
> +                       if (!page)
> +                               goto err_free_pages_array;
> +
> +                       for (int j =3D 0; j < contig_pages; j++)
> +                               pages[idx++] =3D page;
> +
> +                       phys +=3D contig_pages * PAGE_SIZE;
> +               }
> +
> +               page =3D kho_restore_pages(virt_to_phys(chunk), 1);
> +               if (!page)
> +                       goto err_free_pages_array;
> +               chunk =3D KHOSER_LOAD_PTR(chunk->hdr.next);
> +               __free_page(page);
> +       }
> +
> +       if (idx !=3D total_pages)
> +               goto err_free_pages_array;
> +
> +       area =3D __get_vm_area_node(total_pages * PAGE_SIZE, align, shift=
,
> +                                 vm_flags, VMALLOC_START, VMALLOC_END,
> +                                 NUMA_NO_NODE, GFP_KERNEL,
> +                                 __builtin_return_address(0));
> +       if (!area)
> +               goto err_free_pages_array;
> +
> +       addr =3D (unsigned long)area->addr;
> +       size =3D get_vm_area_size(area);
> +       err =3D vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, s=
hift);
> +       if (err)
> +               goto err_free_vm_area;
> +
> +       area->nr_pages =3D total_pages;
> +       area->pages =3D pages;
> +
> +       return area->addr;
> +
> +err_free_vm_area:
> +       free_vm_area(area);
> +err_free_pages_array:
> +       kvfree(pages);
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
> +
>  /* Handling for debug/kho/out */
>
>  static struct dentry *debugfs_root;
> --
> 2.50.1
>

