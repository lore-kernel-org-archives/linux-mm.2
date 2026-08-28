Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2CBC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09466B008C; Fri, 28 Aug 2026 15:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9766B0092; Fri, 28 Aug 2026 15:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81296B0095; Fri, 28 Aug 2026 15:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 912546B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:08:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B316A3FAD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:08:13 +0000 (UTC)
X-FDA: 85151613666.05.B5EDBD7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3BA5240004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:08:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnkG8OlT;
	spf=pass (imf07.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787944091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaAS1sNmEmRB6xGut3oqqD3PYBl5B8b35AmgUg5X4uw=;
	b=d+tz2QivEvwo4tPvsO3OHzBbAYB78tMkApjOcB+2B0UWqgbmnTzKjzXEea7zc4wIBFwBaV
	Ois2JYRv9YATJ9eF2Yj/oi4XlYDSn/JkgWoI84GRp7gsklzQJzmhlL03Cvy3eIsOryKKD2
	0Q/RiAdGrW/R0rXByf/VES+CGawHIng=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787944091;
	b=HSIL9835wyykD2mB1s3NP5b9+Dw2DkfldJErt+WTzKHZ5Sfv41x6piSXnBCkuUJbH3Cbrx
	GjZq29gCJxQsdlA7rtQNIkX231ltdjFzYoxa99HiIxxA6r3T6+hEyB8PxcyRWuYSEkCtGy
	g8E+vZ8TnhjiO9kTeiGsojNOWlDVszw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnkG8OlT;
	spf=pass (imf07.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so4539404a12.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787944089; cv=none;
        d=google.com; s=arc-20260327;
        b=nIQ3KoJ4YRaLZqb9kldlnQKZYcZw0r6maIEELoL2VBSWIvTPXZ7C9wSZrOB7Nq+2cR
         Vu1Hfu1Twuc6FyTdewlsLAkxlHcf45uxGL8OR2MahGybetsQi1xvB57xIp6PXbE4EKcl
         k0LJ7fUEUa6WNb+iPulhyvYdEey87lyl7gsW7HGP+mGiQbbte3CnMiiDx0EmTJT+Dzfa
         BR5+0EMPKTTryKw8tXq5Lvt3Caw0JrxXRYzOS2JnLQgDKVswUqvAd0P8zn1NNpDsf5hV
         Py6kzNAPefjwQhIYFzEpyWc0ha7P+lkn1aczlNR5zxkd8EUZx5KRigyLcRkxB7v48ptD
         slzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TaAS1sNmEmRB6xGut3oqqD3PYBl5B8b35AmgUg5X4uw=;
        fh=v0VwNrnAL2x8CxXTzK0Pa+q11Pj1nTOKwxiFfCRF50I=;
        b=btdKGrBHcyel7BHjAUnuNQ+B8wNp/4NzlCEM+9IDmMCpaI4emGWc0h7R1wuArqwzUG
         ywLFoQfIB5qsddGZbFdfBOWG5DAwfL2n7LxCxzKo5v7kaZ/8r30/ztdnicGlQpokBJJP
         galFOXo0M1DkmA6VyP1oIqPnD0EDuMdDxKbv4036cZMm9HrjNh6XG2KagYusf4NMpNL/
         V9QgxwZy6ysuFvS+bDVIPEg3YXjQTR7h9IHWMpaBDeUOSe+Q1LCmd8rfa81SRvqV2afd
         fN0ibX4aUWuJv+wks3pXV+ZMSXA6o6+tE6iFC4EaP+HhP88GE1xVLEGWCf61QNSzGdUR
         ULnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787944089; x=1788548889; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TaAS1sNmEmRB6xGut3oqqD3PYBl5B8b35AmgUg5X4uw=;
        b=nnkG8OlTdkRTs6a67+ufVYO0UBtCXuby7C6626MajuUhfLwItyEJUtpwHm4waq9lIZ
         2ZHrKRTqZTTg55K9UqowJESyDCenWtVOJgZ9Z6vI0iwc9wX78P87lcYrTAGg+YKNfnBA
         YlBMIkvNeXB/RuIPx6dSjfM4d6/wpIU9GvczD1PQIk600Gyllv72DTrpF7dZxIhJSRjU
         LDn1fRVnebT5G6/j7PW35rVz3NHva/IspBUwzI+ZqX6e5PWwishBmh9VMlXfPypUQxPQ
         lNFs1GfA877PHq8VNBXhIA6n3b89qh3PjCMvQwNakZXqxjgroIHb9OJkrv17sso19Qiy
         bQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787944089; x=1788548889;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TaAS1sNmEmRB6xGut3oqqD3PYBl5B8b35AmgUg5X4uw=;
        b=ceAtnIKYrQAfUguxJRDrfKOraQjBK4ev8UHSh57gIpeeti66zD9wEp9wa4WJjngOr5
         JS4PVDFcuOeBbTbGA1vTIW+xQUuezT92wyn19kPHpqYHKxRpKYVrQXJ2oXfnY9gvHXCj
         3ObtONU5OxNoDpAuauUvb11Gmoj7LyGuQOOxGwGif33ra3I7lILkPs0U6RdBxXEvGvUr
         W/Ph3iAvQd3lJpGWczEWYCK8jhLslVTi0e4zkhyCmk9liLmnd/94Ot58wRy+TiaMgAb0
         XcDYUncP56bZIIUxHkcc3UuMqiTPCxUFP7nKxG54OE4dRpOX5UbNi7mcydT34kCCIP72
         SnKw==
X-Forwarded-Encrypted: i=1; AHgh+RqkjqfwtqAMZyOCVeOJyAaTazz+AQVLMpnqMdznYI9eqnJlWO7H4MDAZF/OD1o6oZJtbjj8HPzBVg==@kvack.org
X-Gm-Message-State: AFuF++l7YdOnHLOPOu97Er3WvjDVcTjPuTc4oRbDCWKxosQ4CCkUzSzJ
	smCn0KNl2O8V0/TLRaLBIxQfSjcN9rYAB61xwUQxk/pCVsNW3G+IVtIeqF3/IRa55fYGTxecg4T
	jspNdibMaoif9MAg+nXfeFQKJUHFIFUqKXUBi0FX5
X-Gm-Gg: AR+sD10hkQMMB1K/GIF+LQSieCg3pDwm9DKH33xiw4BAamBCwITSyUPgoGsi+iiI2dH
	cxtsLUqBZ+Gyw7onn/nOXYaPr8UcpxR2WdcTeGdsjfSNTU0FOIwVt/73vQVIrooxhXOszEKiAY7
	ZJYXufkFLXHGIbZBp8+kkpB74y3nJAmm0WF+/KKDo/qhYFcM9Wc2ZAijE6Uegsyuq2ssOjNRoAX
	KLAcm15UpxhMrV6t8SunrUvfascpiIYi6E3AxMGPiigBZjAP4U2eYbe+i49at41bb8ALWBC5lD8
	4wCXpLAJHwqp/pGhta0nqhIpAkfOKrjauuNKexZu9Fe/wwlnEzjAZwUTIlrVM7xtzdw/5mlQuzZ
	j/PrifhFI6z4mqhYB2LNfnVyZLHUV3pRxUiOo6snPqv1M7HM9Ku8D+5hpnwci6UoOMVeMG9GEgv
	gBrtTQJLF/SLYv
X-Received: by 2002:a17:907:c8c5:b0:c25:3c3f:22dc with SMTP id
 a640c23a62f3a-c253c3f238fmr1089282266b.13.1787944088979; Fri, 28 Aug 2026
 12:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260828005004.2870750-1-jthoughton@google.com> <20260828094703.11081-1-lance.yang@linux.dev>
In-Reply-To: <20260828094703.11081-1-lance.yang@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Fri, 28 Aug 2026 12:07:32 -0700
X-Gm-Features: AcwNN1UeBlJNZQTScnpGSIA84ceVmmw-Znp9Pros_d_DNJEw7LyIhxNwfMF_Hy8
Message-ID: <CADrL8HX+FT4ymeNOKLPQ+vE7HLMRwjdDJX=KjdqgY0f_YhmSiw@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, shy828301@gmail.com, 
	zokeefe@google.com, hughd@google.com, kas@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BA5240004
X-Stat-Signature: eosijto1tkdg1m93n766aaepm8o63k6h
X-HE-Tag: 1787944091-789091
X-HE-Meta: U2FsdGVkX1+gS24e6FyRgJVDKrsE4Rg3+feilrXNvzFRj1Ce+9YO3vF7zok+8FTW4Ws5c/BHb0tCR2GwOGzSVuhncIp+uAohwX8i2JyVJYcJmzfjGzPL7JFdQkiy62eUJozGyOc8z4Y+GKMlaDI7uOfQwYerzzqwNaOM8i4Cn82Fxxm/6TCliwO8H3PgVKuF0y/uXLc9UWg8p5x+vmdJwM9R3VltduNdufSBgd3R9XoEMQcuBW5jx2a1b6cWoedSbYu368piak/RjCrHDwLQ2btoFLQ0gQbK4l2a6e2+vdYVCbWBay2aLjbL7vqZ0xlZFpWPM32SLdrF1gR/8qAo3rj7C9DMOydRJT4in6FHm+DJXyyN0CL0pHh2OZC6hY1kFPowr48lXap9NUGDY23DZ2rkNCQVfBRHiT8czoKOCdwEdSthfwcLijHXqS+uj/1JUgoa7ncwjO2e6mG2VGzsgYuMe4zmjtZrixNCvpyYFppUyjoQMShdNNpvvFpZjz4CIYy/6go2J3cDSQqPwJ5SM7g6ZovsVkshvNZQiv7QxkoIv3r6hKvMSyG9S+QXjCCndndSH1jXyctQmIZiEL5NAeIdd2cKBZZDGxVog5BBL4eSxwgJEOjx3UKbdEEbdxDepE5NC5CZLSm0JOILhtULzW+SqzuN6HDo336t3r6ZQ8Rpg6NDoQe8GNBPI0+nFKqC5tHP0xY4L5ISdcwWEOYwk7SeMaBfh3wr+t+pfBhb4vsx8r7x2Z5gLNY+r0nIabAOCBKO8NJXxEGFbB8aghXV1rROztyyhL4JeAQWQ2tcw+tR2Y6XcnnaLu/JpEmSdfxL5qpcA7ih/KDZCBUywmKEJgEs9TBmTQT94xrLn+3jXiNLbJmvtarehoVD3gLeFki6NOCZr/o3SNjR8dEqfisAUWFgYKqtjBnfV3IYjOGF3sz6eaYSHkF9f4yq3jODhkKVge9kLQp0m58R9/a6otS
 PPPG87EJ
 FYeOeIs1KgNbseltHR6JC5TO1SbzYGQXGdafXgGpmToT6oZIHf9M9XOlz+aTZ8t+3TZ57ZrdJqUXW+oqt/hK/B+Avs0Krwaax8oRtD+21r5+XSPKg2NH5H9LN/UmTemHF0iF03xz+LLytMSHcfqcGoSWiQzrix/ORProehNZXSJvsrQ0G0JVBtI974XII//S6SJsXJD9Jzj5i+Z4PtZX8LEFI44rLVAeMU+CCEaMPgcT0ecc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 2:47=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
> >Userfaultfd minor faults provides userspace with the ability to manually
> >install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
> >map holes in the VMA when a naturally-aligned THP is present without
> >explicit action from userspace.
> >
> >This is a problem, as it bypasses userfaultfd minor faults that
> >userspace is expecting to handle.
>
> One basic question first. Should MADV_COLLAPSE refuse to collapse a
> UFFD-minor-registered VMA, regardless of whether all PTEs are present?
>
> I'd leave that to the maintainers :D
>
> Anyway, assuming the answer is yes, I wonder whether the new check is
> sufficient. See below.

I also think the answer is yes.

Theoretically you could optimize this and allow userspace to avoid
calling a bunch of UFFDIO_CONTINUEs and instead call MADV_COLLAPSE,
but let's wait for someone (probably won't be me, at least not for a
couple years) to ask for it. But khugepaged's own collapse routines
(and potentially other processes via process_madvise()) should remain
unchanged; that would reintroduce the bug being fixed here.

> static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> {
>         return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> }
>
> static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> {
>         return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
> }
>
> Emm ... userfaultfd_protected() only covers WP and RWP. MADV_COLLAPSE
> passes install_pmd=3Dtrue, so the SCAN_NO_PTE_TABLE case can still reach
> set_huge_pmd() after UFFDIO_REGISTER_MODE_MINOR has completed ...
>
> Maybe:
>
> ---8<---
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 33c41bc32af8..0eada7265d59 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1893,6 +1893,8 @@ static enum scan_result try_collapse_pte_mapped_thp=
(struct mm_struct *mm, unsign
>          */
>         if (userfaultfd_protected(vma))
>                 return SCAN_PTE_UFFD;
> +       if (userfaultfd_minor(vma))
> +               return SCAN_PTE_UFFD;
>
>         folio =3D filemap_lock_folio(vma->vm_file->f_mapping,
>                                linear_page_index(vma, haddr));
> --
>
> With that, LGTM.
>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks, Lance. This is how I should have written the patch to begin
with. :) It addresses both comments that Sashiko left as well.

I'll send a v2 soon. Thank you!

