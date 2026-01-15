Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A672D4660E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E5F6B00D7; Thu, 15 Jan 2026 13:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F5C6B00D9; Thu, 15 Jan 2026 13:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71746B00DA; Thu, 15 Jan 2026 13:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFC116B00D7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:29:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 709198BA32
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:29:54 +0000 (UTC)
X-FDA: 84335037108.11.5480B08
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id AB4564000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:29:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3WgdBtKK;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501792; a=rsa-sha256;
	cv=pass;
	b=ty+9Y5YPi1YG+8wOYb8d2uTiE743gkioO5lW9dNF4Y8gCg/dZdbwM7OGRdWJ/aOUzS/GlS
	x1FqxO01pVHnbyOew6xrqmHLw3NgY1KKz+WYadQhYCILV+lPtl/ynqno6RTWNr/qykXwPk
	DwYXobiootUGQe+S7FjZiy2XjY7jF5Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3WgdBtKK;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzDvO5btyKMbXHvh+fdF66YfZxKG9GDFDtkL+8IwDJA=;
	b=xozfAluB7XZD5NePfXkyYaDaNSdz5TNSLn1o9zfB8e3sRMa6pRzMvAmUFLpcKamW4G/SV1
	D/xokx/wPirZF2GfHKoilwvojNmmaAPQMmQMddidznyHrmu4rAF+DVZHRB6kmazo6je7cA
	+WFt+d8ldXWn0dlMWSyp09pFj0AwZyU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014acad6f2so26321cf.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:29:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501792; cv=none;
        d=google.com; s=arc-20240605;
        b=SInXwsztgKW1rHeKKorIPHEe6FMHQ40EjyKmoRa7cTF7yXE94gRLV54AQoEXtbIrqO
         cZR0IboNgwMnrxvG/yP2YBXK7N26o8gKCxp1BdeVwlMsHWS4nlIwjcETcSv0zKNpLINB
         LE2j9wFjB6g8sHZJBmniPQ9ewPnjnpocFWiZrgDqGuzdLa19eBcYeI0CeBcJfn02B/Xd
         qjj+usVsUqQum9wDAWlJlK5tCoabFHfrGgPZjMKXudcNibdly7nVe1fk1iMvgKVAOp2g
         j95s33dNc0pZq2nLINjjZWm4B13jXti4U0y1Vu+iPMGICzuMn47641/7SdyoNjfzJQPu
         p7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PzDvO5btyKMbXHvh+fdF66YfZxKG9GDFDtkL+8IwDJA=;
        fh=/JdxFd7eVdZvHIhknRdabEq+x3Wqedhk/DpjSVY12Sw=;
        b=fdpstvyZ9K+lM83yqfDBxdy7XFlCnFxen4OkE5dV1nfo3VpAwakqLOfWspY7EAbyV4
         9hCCE93XIkhmNg7w2ndSShNgGlHK18OxgiRqvrojhz/WA9gyOoiYDVVeXgcGPKtALEL+
         rodWOZWiDELudlhxFpF9jPJHwgePLrY9Umm/gXJCSL5W2wWO9cM3fTqbYDfm1FXY+fGw
         K2VA57gV5hO8tcmo+N6eHggeA88SQfiG1x50rnXghg6coGDqhnD5uvGXi2dx7n7wHp2R
         mxXFAjWtUC5K/6BkdZBS+7mx/QsXxobuuh/okWlN3hGRxv82elmWPd89041ZX2+I9vk/
         l9wg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768501792; x=1769106592; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzDvO5btyKMbXHvh+fdF66YfZxKG9GDFDtkL+8IwDJA=;
        b=3WgdBtKKIWqrQdy3cIqJVCN0MQVRPJu7hijT2wrL32HHyZ65tI7iBUGJAvT2+1vvkA
         BR962Q8tnmUJqjT4mHTMAN1acjZC4vvWsoQoVn1FmBHs0lH8HDbrjK1xJOuj+ZgKYJ97
         PUA7VhgytW9d8HdkymgJcRPl/FLkKxr3Ct2BTWd9Oib5k9EvAFAWbkI//kxM9eFJJcCe
         pXbPuZVdGwTqXPrlPWQdtNfMldL7HGhbavNVlxzLOSJyH1I252WVv78kHrHI9Ao32WpK
         a51xaKGdHa8xxIRFazc7KSfodcSsusc8hYB3VrY8O+9AHrXqOCgfGmmp1dwo00CPUisw
         b4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501792; x=1769106592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PzDvO5btyKMbXHvh+fdF66YfZxKG9GDFDtkL+8IwDJA=;
        b=KqPFuC/jzSA1RoTNPHE8ZHX8msKyTcvYyW1EeY4oUdiPnb4fkopwBnQdIupTDVXGeE
         UmIFKqUy1KcfwV4ZiaUQR4HvXIcAklV9M2Qy+wOOd5eiUEPY5T3FH2lSr9WqSWJHBk8d
         RtVssUhrYYfWBxfUQtKm5CxUOrhO5kJ9M2wmoTbFy7jrzzAmKCwhjazhmzDAX+jlzKmN
         4etH4JPFmQmW93WRVCwNGctVapATusl3tzvLJK0vZgAwl3R5R8V20Z2OX0kHVsfDyAPZ
         h/jyIENG58EZhDJYqCwUo0WdFlmwV2PKsmIXve+AqVz/R3c6YqMBIZ7PmxAWOzUWawH7
         gTbA==
X-Forwarded-Encrypted: i=1; AJvYcCUlSzl/VsqIGJKhbtwylVjd9s/avc9mHW7+PkisUSMzQFBgdCpIm47EkKV5Qj7zU9PBvQRFOKNIEw==@kvack.org
X-Gm-Message-State: AOJu0Yxr1ArCt+ONKVx7febdqafNwihRs66fP5AfSYOHZmHPZvsneZr3
	+35gaquBD+BKb0oQ/r6fUnx1xeXQuv07uZ5q1ZInEhAa62WQzzADZTKW9ed4KJj9uPw4243Pqoh
	YE8Sa7DWYuXWs/AxWAr0auaUAxm+NNsYaaKyoneqI
X-Gm-Gg: AY/fxX7wKSml/y0st8T0nxdbS+WjC1TAd9SuY9c5hcqU6xsGMUDQuOriKyezc6DmS4f
	urF58hFe3lmh6Ce+tdSLW8ZmfPBgU93r7g56lCX3LCOdYUPT3GvjbwPj/lOghw+fRie6lvJx4Wi
	tXbaqeqxUBEsMdyugsFlxTDbpJORV/eUKUe2JJVuiudOcLwy87W9hNMGYDT4jaUbl5CkEKtXWFt
	1MsEbJY+R2jZq2vz9QtkO2W4jqpWQmeSQ8sB/A0cgkSq1PYc8SvqXf5ESYZ0MgsEBsOAlXd9A3w
	U/WFnS4jDXc4JshHGdPrIY2c
X-Received: by 2002:a05:622a:1803:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-502a246672amr224351cf.9.1768501791194; Thu, 15 Jan 2026
 10:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-2-jiaqiyan@google.com>
 <44A610FC-3154-4FF4-A940-12ECB63068D5@nvidia.com>
In-Reply-To: <44A610FC-3154-4FF4-A940-12ECB63068D5@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 15 Jan 2026 10:29:37 -0800
X-Gm-Features: AZwV_Qg1jQTPIdJKVN_cS-noKZGXMyLJC40bXf3dB5FKBb_nkAJO5jHD8AA2yMM
Message-ID: <CACw3F53EJCi1EasevMptcQs_TBy7-7qEaKxZEzH8GP7QzunMQA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/memory-failure: set has_hwpoisoned flags on
 HugeTLB folio
To: Zi Yan <ziy@nvidia.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	harry.yoo@oracle.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: eoauhhjwayyh8971smg8mayjmjjtpn6h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB4564000A
X-HE-Tag: 1768501792-7150
X-HE-Meta: U2FsdGVkX1+uGJRdZ1NAWDWj+aV+UJX+ACNxZw1z/yq5yZONwFtyxxTz+KcQ939622qkgygxQpGRFGPTa/a98EBTi+XXdDihdAr5LZrgv1N6ZX2FfVmGe7eW/ykG7qhlpwTEQmMUxoMff5gUdoPZun/gbGUj1yz8a0p/nLI5xVN1txbFI06M3ADJ0g9bgxxtBhDS5GsnuER7jOLzboeScABY1zfGyHTo/UB6T8L1jfnjLXGPzgKP/31eA0/DZPaqevcg81HiHGagfSSXkkg6KjeiBP8o/MoGy1fhW0DNpIxxkF0JOAXkKwKUAt9GAK/Id9bpiAuB/8YEnJivy6NQiKB4pIHKIfSfXmfESB0rdJgpYm9DNpaqN/DeAA3PtOG+hd03x1r1TpKPgbTyMbUWjyX7pa9SErjQA9IU8nTuqVfLyFanl+iZmgJQv1Ub4x/zZsJTv3+34RlILJfWHCWLWfOoQSVSb8gfm/wpyruffLFAlrAA3izOiFk4Y6ghuhm+gxHEm5lhtAp+NgrQQRll+gLopFBdKk0FK+TUKClhQCpYS1L1E9y5OP+Vsl/PR2290JjBExZl0B0FSHRRM/y7NuRn/P6D7B8UrNvxFAKEahd5s2UAQj3HruKpqrOYFN6ynwirui3MWPA//kJu5VVXfLT/AGvDtR9cPFut4gsZTlIaDoAMvdiu1vDkYKc42NyONwLWCtECWrTY08oXtHwgU2uKKLxgbr4F+SWvNDzzNM45G4nC1/CxijaC5Ss32cfY2TBgMbJ/K6Hf1Xci1zVRx5+MeeMyeW5UNQrgUNaNIKwW/IH9nHfo12J4dbbYuGbNt/Ucv54m6FghiPjWRMvqI1t0jcKIGMhnRl+546ml//OO/cXnUBE5cweMdkWJRYcY1CJM29v1aVfzLpi+mOoBnJ5BSegtlKONitf/CgI+GskmDc5dRveoVPJE2O0D39PvFG+dzN5yoxsDh7xzbaq
 S1/lnSYq
 okaAM4NAuNnwhtV9BvWcT0+683/HrRcDp/VW/ZU2+BaFpKx2Yz7zlNQ33Chy+3k53gftia+DIgVh8Ji447u4sLO5IJsA1YiUmOZmK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 6:50=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 11 Jan 2026, at 19:49, Jiaqi Yan wrote:
>
> > When a free HWPoison HugeTLB folio is dissolved, it becomes
> > non-HugeTLB and is released to buddy allocator as a high-order
> > folio.
> >
> > Set has_hwpoisoned flags on the high-order folio so that buddy
> > allocator can tell that it contains certain HWPoison page(s).
> > This is a prepare change for buddy allocator to handle only the
> > high-order HWPoison folio differently.
> >
> > This cannot be done with hwpoison flag because users cannot tell
> > from the case that the page with hwpoison is hardware corrupted.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  include/linux/page-flags.h | 2 +-
> >  mm/memory-failure.c        | 1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index f7a0e4af0c734..d13835e265952 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -904,7 +904,7 @@ static inline int PageTransCompound(const struct pa=
ge *page)
> >  TESTPAGEFLAG_FALSE(TransCompound, transcompound)
> >  #endif
> >
> > -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEP=
AGE)
> > +#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGE=
PAGE) || defined(CONFIG_HUGETLB_PAGE))
> >  /*
> >   * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned=
 in the
> >   * compound page.
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index fbc5a01260c89..d204de6c9792a 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1952,6 +1952,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *f=
olio)
> >       if (folio_test_hugetlb_vmemmap_optimized(folio))
> >               return;
> >       folio_clear_hwpoison(folio);
> > +     folio_set_has_hwpoisoned(folio);
> >       folio_free_raw_hwp(folio, true);
> >  }
>
> Should this patch go after Patch 2 where has_hwpoisoned folio handling co=
de
> is added?

Hi Zi, thanks for the comment. Will reorder this one.

I initially thought this patch was for preparation. However, if I look
at patch 2 differently: it enables page_alloc to handle
PG_has_hwpoisoned folios generally, not only for HugeTLB, but also for
split-failed THP compound pages. Then this one can be just to make
HugeTLB start to use patch 2.

>
> --
> Best Regards,
> Yan, Zi

