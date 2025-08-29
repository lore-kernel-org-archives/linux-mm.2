Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F03C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 04:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBB86B0011; Fri, 29 Aug 2025 00:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC5E6B0012; Fri, 29 Aug 2025 00:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C23F6B0022; Fri, 29 Aug 2025 00:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1006B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:56:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C136F139FBC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:56:45 +0000 (UTC)
X-FDA: 83828584770.13.62B6A9B
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5C4E80007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:56:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpQFfd35;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756443403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNryYBJJVfQELDTrjz1KnvzL2xecRXp3PVwLzaUrbpo=;
	b=Is61f2MvErRENHgh9JgZdhSTnryc5OPLHDJ8Sme6OT3gBi2bCSO0Y2zyzRlt9O8JmPwoeq
	JqjMT4JDwEaP9myoEuhJW+OPKCSOYZIYnTBclKlFIvn9kvk3JvsdUSw7Eq5XWjbd2gdvR4
	kzpaQQigG+og1RYEETAGsD+6GCYHdjY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpQFfd35;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756443403; a=rsa-sha256;
	cv=none;
	b=kL5cIsUfS89rbkdYvkKv/At+1dEAfVD0XLtyITBpoD38s1x+0kCQvgXbFCAAvWBDb1t4C6
	8kIJ/DtKwz7uLRByBFfH4dCsZwkRRZkHQcMiW8+QzQZvLHhpHm8Whr3v/RhcxS1fMnwa6u
	Untv/1ms/2izr3EC7WKFhHd2JvLZMaA=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e86faa158fso182967785a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756443403; x=1757048203; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNryYBJJVfQELDTrjz1KnvzL2xecRXp3PVwLzaUrbpo=;
        b=LpQFfd35LxtbV57XEaugKWI0ciWl5mCix/dyCjviks8UJuOT5hTxixo24NigEzAzHy
         1/idictikn/uM5QQpChBMz7QkAy1c68h61ZodmNZxCZvnAthAXHgiN34OQLTX5KJWLrQ
         F6kYilweaFHqcQav2iHtFlXBBpmd/zINzMTGg8V7sxn/0ukrt5sr1CuLXHdBmSWfF644
         Fsh9g8SIm/DPunSL020nQ9fEzRt/1SJ1KOUtK0SWRgkG7ggwWOsWaNLoR7pQ5pc+SKnN
         lsd01W/VRqHHAYalER/ZsytMOmi2KyvE7lyXnAWUpx1xYNeNcI13WUCbcTf3wIfG6WVT
         bFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756443403; x=1757048203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNryYBJJVfQELDTrjz1KnvzL2xecRXp3PVwLzaUrbpo=;
        b=bqSzEYp5TrtkTujG7N1Caz6tV4z9zndUf10XCEpVbBh1Xf/PwQjRfGPNefKYPcVKca
         sA0pccA2NySNu4DM+X9Qqh5oOcYNNN8rPqepDPhKwnl3sxJCR41g+wEQjOuLdyWoDAfl
         aoCOD8JGcpmCyMXZNPLJFnNoqZh5rCR8aHTpSkTuqVgYrG2DcejHx7e63jf0G6mHr+gZ
         clPkjkt7dTlX2ppjZooviSXAG6T+Gx7oNSm/j7IXo4U4spjhmTY3sVQ+UbgpBzfmS6FY
         4omhjErLiu0IUheDMcivmWHoAT1DUrAKj4jtK5ZqND1xUgU6J72MvqWrM7K2N4SVBu5L
         xKEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHJ+kECWjaWD9roDQaY9tLZ5ueCUCuComuwkZkIpUFx5g3ch9+B9G+ThL27DIJ+Q/s7fgbttPTIg==@kvack.org
X-Gm-Message-State: AOJu0Yz+OJHqUQKqS4C7cybOEE+1rAZ920Rnjf1u631sf1meNmnjrqH0
	tKAt3QC/oyd4Ia2MDV5CJeU76du2qm7JPmZloeU8WsDsoUM6W9wzELFhXvjK6symvhqRL2Jbz3E
	riepfIfnCWNSkAvP8YJaAZP7pHHo/zKg=
X-Gm-Gg: ASbGncuCsO6y6eN8XUvXILmD0hbIWXHKW3ZrVgXPlTeMfBEIgsD7JK4S7TewpZUSFrp
	RMmCGizZaOedw6P1QXWZB/vUm8wAK7S3LOnsy2A+bgf22u88ECLavJy/itRY/Lm60sIbiNl9B9B
	F8dj+T7SfyWCSRWf6SpmzHsZ3El5K78VDBszK31K9LZ+gBBWcGRJyHFMP6gKHFcIKEmoLsz7E2F
	K3MJsxXy7c4gS5ZZw==
X-Google-Smtp-Source: AGHT+IER+nM+4LqnTVVsRA0C/YRbwEY2iIeChjcQqyAqsqSfTBP1dTQx0YTtFem6RkzVwlWqhUcSmkomW7o4OpJu2UM=
X-Received: by 2002:a05:620a:2983:b0:7fc:8834:a8a6 with SMTP id
 af79cd13be357-7fc8834ab4bmr147951085a.16.1756443402922; Thu, 28 Aug 2025
 21:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-2-laoar.shao@gmail.com>
In-Reply-To: <20250826071948.2618-2-laoar.shao@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 12:56:31 +0800
X-Gm-Features: Ac12FXygzLGLDRPOyTzO4Xch95XvlKZwEGk1nOgFbtgG9eYsTL90i6vr2LXC7WA
Message-ID: <CAGsJ_4wa0gC7FQmUP9HQxbacheKFRCqMbnfXwugeyOzhOS4McA@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5C4E80007
X-Stat-Signature: exnqsqkwoda843og5y8pcxopr3cqrdck
X-Rspam-User: 
X-HE-Tag: 1756443403-819991
X-HE-Meta: U2FsdGVkX190j89zgBqufLutpL2zShxtG1swlzZSlHGHHq8jDkbv/9zA3byiDRGbZY6OjfAeJfM/RlerrigmCBLDUtjK74kvHmZt/cCU0NGiVd4zwFgqv4P4vVgvzuQ/pmZ2patdRrTrHy7dX0HPkNrkx/0wWFnEMqR3z/NPKSgaPMHumgATUHPT8nocnnb5lOC1XgL3L346Kq/GixT0xC41cUscW2vKTwgDNmGFK7F2swyGTWrLcDLxdqJWRvRT4LUXbX9hpGhInbXEZ7oD2XJk/8Tqf4mv461tQf9tZ9J7Vp74fu9TpfKPkvfVkXxUvlIvZRr1msuMYI4hMo6K7A+qcfnQE/lVnIkVAc0yi1GTcIwgBHv/0FkExxU3gLdknkvqLZIp35MRATq+HEceeOdmQo1tX3nh5EhiXswDlfVirfTLU4RqP2bEe2t4hX7ZQfjhGnXoSIUImSqDXLHjToY4YnxUt3fnJXZGuNyzXPadcr0J7mUDd7RcxRTyXywOMi3NtLvkh+kdkRnlr7hTf8Weqa11Bn8sPKBvRL/S5f2BTtrQaCEAX+ScjZohgrk0Fo1j1jDy01epS5Zb9rFWQxzsDpcmUtRMGxgoPEYrLt3T301Gh2t8e3+7k7VftoMnzFeLH0inf02fxUWIoVUDgaWCnbnBKAgAX2s+lcy7hGW9mCTFgUGasq2oxWdyS9I29sl7h4NZYd9SyWdfi/BVY5vA9v4DU7pAR7+5/oKlSi1aOVnFgSz28wqQgMYqz4rQEVhkCpA2wgZy83vscI1NmFKjU4XU/bx+EH+Qpikwh6LrpB2HO1RBxVNJPgatKnXAaqm27If61YUkfT3V1rELLpDnzHzXKjX20wDXxWd+bh0zfHRjBdgA5Qi5AwifivG8dHIjqRQLXxJAqiR0parT2LWb+kQmCGunqL9IEzMCRrC170H58kt4RwAgbHk+YtxoacnA2u8vju/HqgtG58C
 X9JSGhzs
 BQkY76fAFIzs8773QbT40R0bDbv7AWmBltJ1SVLSt3bLdQF6QiEwfwmNbsQjL3QJqsCsKjIncJe5d3OfAO0EhtroXjuamb7ZBntLqD8vt/d7Wg1qrYzTKKW+t/+dD3l5nRNGqkv61Rk2xLcAXSz/ASGnns9UfAKQqp9WNz84lQwNBZ3k1B5yiu2GYCPV4cfpyVUptMo5Ro9n6KCSUvndIyikkPxd6Bn9iPZfilqO9ZNZ6jTmkFt3gRwNfShfsJ5gi27tuAQ/HOEaUHvQJtmfDeEdZv4Anb+ZH+z7Fd3wzxtc2Up+qhpWfcOJnlOhqqZd2VDlGc6pGth2chI4T1OBqFbXl1tQLm5Yhl2LpIe7yelNIrfi0hkP1DiViD8cyZSwDglVNvAhSZC6Vk2FOwe9hPymHTz2H9l5isaWXoyquNCHuVfsTgRGU8PnFIEMNhQ1UL5sH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
[...]

> @@ -4510,13 +4510,18 @@ static struct folio *alloc_swap_folio(struct vm_f=
ault *vmf)
>         if (!zswap_never_enabled())
>                 goto fallback;
>
> +       suggested_orders =3D get_suggested_order(vma->vm_mm, vma, vma->vm=
_flags,
> +                                              TVA_PAGEFAULT,
> +                                              BIT(PMD_ORDER) - 1);

Can we separate this case from the normal anonymous page faults below?
We=E2=80=99ve observed that swapping in large folios can lead to more
swap thrashing for some workloads- e.g. kernel build. Consequently,
some workloads
might prefer swapping in smaller folios than those allocated by
alloc_anon_folio().

> +       if (!suggested_orders)
> +               goto fallback;
>         entry =3D pte_to_swp_entry(vmf->orig_pte);
>         /*
>          * Get a list of all the (large) orders below PMD_ORDER that are =
enabled
>          * and suitable for swapping THP.
>          */
>         orders =3D thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEF=
AULT,
> -                                         BIT(PMD_ORDER) - 1);
> +                                         suggested_orders);
>         orders =3D thp_vma_suitable_orders(vma, vmf->address, orders);
>         orders =3D thp_swap_suitable_orders(swp_offset(entry),
>                                           vmf->address, orders);
> @@ -5044,12 +5049,12 @@ static struct folio *alloc_anon_folio(struct vm_f=
ault *vmf)
>  {
>         struct vm_area_struct *vma =3D vmf->vma;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       int order, suggested_orders;
>         unsigned long orders;
>         struct folio *folio;
>         unsigned long addr;
>         pte_t *pte;
>         gfp_t gfp;
> -       int order;
>
>         /*
>          * If uffd is active for the vma we need per-page fault fidelity =
to
> @@ -5058,13 +5063,18 @@ static struct folio *alloc_anon_folio(struct vm_f=
ault *vmf)
>         if (unlikely(userfaultfd_armed(vma)))
>                 goto fallback;
>
> +       suggested_orders =3D get_suggested_order(vma->vm_mm, vma, vma->vm=
_flags,
> +                                              TVA_PAGEFAULT,
> +                                              BIT(PMD_ORDER) - 1);
> +       if (!suggested_orders)
> +               goto fallback;

Thanks
Barry

