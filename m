Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E65CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39E58E0052; Fri, 17 Oct 2025 10:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10A18E003B; Fri, 17 Oct 2025 10:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26758E0052; Fri, 17 Oct 2025 10:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C02878E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:43:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 901091401F7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:43:14 +0000 (UTC)
X-FDA: 84007873908.27.1160B98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 360E040019
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:43:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlKUCMvi;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxj7lS1C95jhv85kif7t4WsLymDjCUu9zyZAz/6p1Bc=;
	b=CNVFbyUWrPCDdd8O2v2GED/KHveZPeDsKUO4mrIiG4s87+wXsNq4G+XWyV9RvkI2u6Eo4f
	eIf1zt/cJTMq7ICM7u55adfcelLffS5i9E3NWbFIVVq12p48a5jZMACGgneEkPW+ck5ETX
	rlOpHPcjxVf0oulNreH0vF6+NzwV45k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712192; a=rsa-sha256;
	cv=none;
	b=qLVwhOq7lGBiqPJzoTkeurMMA0Y217L2ZYHT9d6rsxT1azjyIOaUG+DRVPJRmNnwHFUZV3
	n3JU3WYBJOvBf+Zh3LM4EvnLO5u8/MZd2ddurxYKQIl2qNVYk+msP8Odja7FNkmJscbBlL
	CRwYO6bx1Jcs+eHsMNfvPRLKHP9Jc+I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlKUCMvi;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hxj7lS1C95jhv85kif7t4WsLymDjCUu9zyZAz/6p1Bc=;
	b=OlKUCMvicMNTBweJzUDo4y5piiGyv9k47uKSOzqLWo4uo7sCLeRncwQ6LolNaZqp4E40qn
	onMA6bQoaTOz5WvRFRJfj0Nm/ZF/1A9gonKLpvtm1jsuUCGfGD8loBaU7W4XrY+EJaSu+I
	NrtdphiBlW1/CgG+MIcyNnTFMu6ZwRQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-CzAaziSuN4KhdCxHWUPIuQ-1; Fri, 17 Oct 2025 10:43:08 -0400
X-MC-Unique: CzAaziSuN4KhdCxHWUPIuQ-1
X-Mimecast-MFC-AGG-ID: CzAaziSuN4KhdCxHWUPIuQ_1760712188
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-781353ba452so27057297b3.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760712188; x=1761316988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hxj7lS1C95jhv85kif7t4WsLymDjCUu9zyZAz/6p1Bc=;
        b=lI9VQO4BJ9F3iuSjwX4164c1/fbpsodVAMHjxHWb/AY1C+o1OKjcuXz8Xfd0OUkOnz
         3p7tOceDJ4sU3I4WgjnEkcHmXwsAfbkGRXSg5Bttm5ftboe+uwVQUriJaS7wrf6KGNTO
         /ql0XS8rm2/YRqSm2zFONw6XSOVdp+xjB8NJD/ZEsL1H0jAA0vpAA7ojzMhtxXynri1s
         ogU+YyVio09XkBG9wPRA6s5ycBwfvfeeAcfqDQ8NXFbz9sVT717/j6yIRA87AI4r/SAf
         6QIRANAMbgBaY3aIYfaPDAIKCJkm+/GaL5shnSrNasvYUCEgGEn2Tx1KctJjAxXtWzwn
         CsWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2YjuHw4opmoEPfFEmpqecAZB2BEStcI3FM/5TsGqf4muzvmEC1QlYRkJPrQetKTA0F5eXVABuXw==@kvack.org
X-Gm-Message-State: AOJu0YyLGR93x+xgGDgk1go41uIu+vHns4oW08O6ufinmKfIqBzBYiq1
	Pi7yk3v1/q69/+UyGJzl4si6DPRYYiKIYjGtTLldVdQwzD43KQpbPr+wEnlIEeRCgjU4iRV8N6j
	PhGltQmVCsrqtl5kGilWjP2H4b6CT+G4R8Zfkp0gf4q0rFsaSAeSlrM3nThEwWBTzmWcRC7figZ
	5XNWdxWlGgdSZaPiyv5l4ziMz6/2s=
X-Gm-Gg: ASbGncteICj4GlZMnZ9V+hVZcZfwioPsZzSAnoIA17xixjuonASLKJfFxJKf9pZOh4j
	56p/QG3LLxN23I7bjL7tznNPk9D7iSrfp+8MOvZaR5/RA7PXmyGetl0GZOZMH0i4EKefgki2ser
	apb44kIIbaa6oLKvdnSxRlx33DgIy3y49+6K4IpUDmqqBdXRTO8ClwPaspC4ALp2haWqSqLg==
X-Received: by 2002:a05:690e:1443:b0:63e:1c4c:302b with SMTP id 956f58d0204a3-63e1c4c307fmr1674707d50.47.1760712187537;
        Fri, 17 Oct 2025 07:43:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs48qDAMhz4D4LbgvFTtDvQVRQBswskN83/kSgWqI6wIc76qg7MoUwbuH0PX+UqeptgQovfUG/kTE2lMO7H2w=
X-Received: by 2002:a05:690e:1443:b0:63e:1c4c:302b with SMTP id
 956f58d0204a3-63e1c4c307fmr1674677d50.47.1760712186942; Fri, 17 Oct 2025
 07:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251017093847.36436-1-lance.yang@linux.dev>
In-Reply-To: <20251017093847.36436-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Fri, 17 Oct 2025 08:42:41 -0600
X-Gm-Features: AS18NWCBKfGK51DZT3g62G_clfCY9edECXjl7uUSq0bR_PlTrl1LHPcNQSK0gDo
Message-ID: <CAA1CXcBSCezWLFNJFf+7yw8aVSAvbAMWe4OUa9EJ14yX=MjfPw@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Wei Yang <richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7ibFANpDpFpHjuZy637q2y9S8o4T71Y6KF0iQDQBzic_1760712188
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 9hdq4m11my7iifpsszs9ujhfddt3j8p7
X-Rspam-User: 
X-Rspamd-Queue-Id: 360E040019
X-HE-Tag: 1760712192-460893
X-HE-Meta: U2FsdGVkX19jSGk6dGJotaouEe5R0DxF6/Sr45lnTzqw3n8H+edTEc6iAqQORFQlhOEJfHBChQbh8mJLdyCo4BHOObSyYmFZRD+UpoDGqEjAGfPJCDTXjKhrbpSBPVVyP6YTKU3uAVbr3+C263qZRw/mehZU2OlWA9+VvtwzRifrXUGBkT5ADCqMoWcBBWln7Roshep70WXrLIo+SnYqwGWkPApyJa+Iz46n/AiKtDupc8xcrngfzaqBBhGCi8TKzZS1jRLLIOmiI5IrUKgB28SGVy98t3stxVCNkAlQRHqoAuaOCLoULZ1jHtYMoafybiU+2lkq0wFIRsdWttQ9ZRrmlfvQSW4dw5XoL4qAqa9G2S6RkaaUqZTIgUfL5BTwMQF1tXPJjAzEu2UfAmnBy3WClo/eSyTyVwk05/V4FcxBVs8VLxOFkGpA3iXIdfKFqIZp8L608obtDpXhUWCJMFWVqXLuFiGJYVOcFnc/UrlslmBaKnvzYZ9sMsINJSpLRSKIS2JFuStPSlI/kI7G+qctspXy5vcxycfKRZNP2fgK4a15bKGC4S1eI2inKUBO4oipZNYuQ/ziM5wiefoimsJIQQFXJzzewRbXHWAeLOX27LqhYR1iuPmai5SZjK0tqEYPHqgPN27k9ELPDfU1/ZmFFNNbXV3gNDVWOILuXbsJWYp0VvABTWtbake8Wqbu1hxtf46MFTE5qPMmEA6ainyzoH77VT7I9xZPwy8+JqlCj4xOJUNW/RJorDOgMUExDKygxZpsmtHzbDHyC7MPKt8GKbW6mcieBd1qvUCgwHFPuM4+60yYhR+EBQRai4MqOeMbv0SIPHH63NiB0g7Ss6ROjTc50cVzMHkec+Op2BnMM8JCRv5tV6hlJHMDMEq8HOsP9a/tMLPW7quwLnA6p/P/RK8Z+n+pLU6tx9TijrUu3K+ry2zc6FutliFrZpRFNHFbULmCfpUpwfkHtrl
 6KUZfRGH
 55X4JkGAVwndgmAp2sX/exZUgVOejtP4kTcDjp7jT9K5WiGM3qbH/8Z2wwwDUFjR54hz4mdUMkOYdwsoh+vYVgP8EmfWlyyirBmqmEg1LM7ePI3suhLGi21aEp9zXlErR9oYvuiPYMJjv1Rjep5yfvOf335gbZ6LVChE0mUJagZpLt+maSBZKco+Ikmcrh2GvFnNZ+HOBwSihl7OBY+3r7fheIgw9zpqmTrkH27QdXsZq+k+gcSUoBDIeY0yZDSHVzRcKeXd6u995Trpm0zV4XYPC4wNQ1sJWn2V1INxKSX4VoKzFbcTLF664TO0S4cq83ioqoXmSDYAoWrSrf656TmmSTCiJtBNkuY9fjKwVTV7Ayl9juC/fgC4BK7fEJOQE/Z/GJNYt6L7KTLLyltIaCsrwE5+kVf//y+TmxzUMlt/8vcBJJtXCFjwxoug8S33Zh9cH+k0isF5KiysGJfuGjfRsJqOIW82iF2LovcdVIU7yuYNHEWZIXZ0uBDEe92/EtC88UH/mFv8O3fsC3/5faB26GhUNW/twxo3qh0Ay+2uBafM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 3:39=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> From: Lance Yang <lance.yang@linux.dev>
>
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
>
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
>
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>
> ---
> Applies against commit 0f22abd9096e in mm-new.
>
> v1 -> v2:
>  - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>  - Reduce a level of indentation (per Dev)
>  - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@lin=
ux.dev/
>
>  mm/khugepaged.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d635d821f611..648d9335de00 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte=
,
>                 pte_t pteval =3D ptep_get(_pte);
>                 unsigned long pfn;
>
> -               if (pte_none(pteval))
> +               if (!pte_present(pteval))
>                         continue;
>                 pfn =3D pte_pfn(pteval);
>                 if (is_zero_pfn(pfn))
> @@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte=
_t *pte,
>              address +=3D nr_ptes * PAGE_SIZE) {
>                 nr_ptes =3D 1;
>                 pteval =3D ptep_get(_pte);
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +               if (pte_none(pteval) ||
> +                   (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))=
) {
>                         add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> -                       if (is_zero_pfn(pte_pfn(pteval))) {
> -                               /*
> -                                * ptl mostly unnecessary.
> -                                */
> -                               spin_lock(ptl);
> -                               ptep_clear(vma->vm_mm, address, _pte);
> -                               spin_unlock(ptl);
> -                               ksm_might_unmap_zero_page(vma->vm_mm, pte=
val);
> -                       }
> +                       if (pte_none(pteval))
> +                               continue;
> +                       /*
> +                        * ptl mostly unnecessary.
> +                        */
> +                       spin_lock(ptl);
> +                       ptep_clear(vma->vm_mm, address, _pte);
> +                       spin_unlock(ptl);
> +                       ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>                 } else {
>                         struct page *src_page =3D pte_page(pteval);
>
> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, stru=
ct folio *folio,
>                 unsigned long src_addr =3D address + i * PAGE_SIZE;
>                 struct page *src_page;
>
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +               if (pte_none(pteval) ||
> +                   (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))=
) {
>                         clear_user_highpage(page, src_addr);
>                         continue;
>                 }
> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                                 goto out_unmap;
>                         }
>                 }
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +               if (pte_none(pteval) ||
> +                   (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))=
) {
>                         ++none_or_zero;
>                         if (!userfaultfd_armed(vma) &&
>                             (!cc->is_khugepaged ||
> --
> 2.49.0
>


