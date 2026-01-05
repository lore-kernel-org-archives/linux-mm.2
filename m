Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F39AC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143AB6B00C3; Sun,  4 Jan 2026 21:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1E06B00C5; Sun,  4 Jan 2026 21:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0071C6B00C6; Sun,  4 Jan 2026 21:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3F7A6B00C3
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:10:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6673B5FFF1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:10:08 +0000 (UTC)
X-FDA: 84296280096.10.7809284
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 710CA180007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:10:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SeYuEAp8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767579006; a=rsa-sha256;
	cv=none;
	b=KOFZUin9bG+HVqzryw+WCmEyDK0TKH7Y8xXv8IAKbpt2fiFfsfHCpdzq/fLABMO3rDdJv1
	FRCF0DbHDplxIdQsHgq5bfK2fa/rp6AxDmDvIdKaTd8b5dVzj6p2BbL8V+K+NkZglYpfZI
	0TyXBrMl7oW6cC08V/Cs0RNDy/HNP+g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SeYuEAp8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767579006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sP6fXFcdgxKyYuwx0pUV0nFQlSLA/4Pmeje033F4dlk=;
	b=Gpw1MLPLt130v7mDjUbyvmK1vtXfIFXc3zpJ7/jtIOaYIhZaYkzBdPqi8BGttw+QALXGmG
	ZvvR/21Uaj4HTGSJHdwiEc1LGXZGJbP56pN4L8JS4dgATeq30Y0u8VeIpFyLfdiSWcLWcn
	ldvQ5KsIwNVIe+3ihpGkhWJti3slJOQ=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59445ee9738so10876709e87.3
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 18:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767579005; x=1768183805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP6fXFcdgxKyYuwx0pUV0nFQlSLA/4Pmeje033F4dlk=;
        b=SeYuEAp83x5hr6JEM3VRKlWlMPHLOmdn9dD2pkbunxKHSxybETAKz1POoUOR78wzSy
         vjdz4nZVb8w1Rr9SMacZoGqWBjFwhHrJBRFh1kTt9/ah+aboqW0m5PG+3euWhVpE07vv
         sESzyNOeHQf2gzw9XXYi2ABoSQr7v/LKNBpzHuJoPlvCitZpYjga/X9NICWhdYX0Qlbq
         YP1dQpfYpeZhiax+M0miEHNfy3PBD6r7vnKctuaUumu1wG6eF7Vdk9qKxGQnuZ5+zD+r
         UQO688J5IpXQWCMjFlBz/ZfrEMJg+Nf0p1Io5T+QVj9qllRAiTSBqFMCsXFVm3vkImME
         4ObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767579005; x=1768183805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sP6fXFcdgxKyYuwx0pUV0nFQlSLA/4Pmeje033F4dlk=;
        b=tKPQ5OUq0L7AMxBnzAjtRDbv89LG8m2z3cAnYYkjHvQQyFoIcAbVrD38E9fQ0OtLIk
         Gbq1zdEduzP5j6wHJSMRaNu+2+6hnPUPR4nC96F7vVlVrLYICP4Vg9qlFzrHVaH5dwrk
         uf5n3kcHYrPTsu5Yesz2qNT9tzlpXl7imaviv1731h200nk+XTiueIVBWBgEl300If9j
         1MrP2U0AWUICookOlhfNcmShCR8kB5sD6oc6rQRCP05PEs7jotP1+TPAJ8Eo4k8GUAyY
         itDvUXyQhSqrN6rImUrG5Mj0Jgs6SyT7/GDvHMDb2K9GVC9CDAvuHkMovgLoYbzrmT8I
         Wcow==
X-Forwarded-Encrypted: i=1; AJvYcCWtcAx06LtoXJNRji7ONPTCv6SvKsfztk3l7e2fJYcWubcpV12K9EFFBV1WN3+xvAqsUfuBj1Nz7w==@kvack.org
X-Gm-Message-State: AOJu0YwDdBu/0YMD5apCQAPqDdiD2DARFRs87ce5PA3iI3wcMj5kcyDJ
	OGQOW+4Xg6dZEYG4pzUuJrPeqC5qOjV3dbHv7cXRCEKaIlciQPjvpD+kXtSnSxSPeq0erxU4nWH
	h1yKJ3pGu7hUcvbsjq1fz2N13zTBxrF0=
X-Gm-Gg: AY/fxX4TmNcffJvJrOSdG7OGSIdKmhwx1PkE7yDlwLANSAKPJmtwHaJpgcA+arMMdiU
	JqNkNsO+uYJlzAgjwWLILA4UutFbnM9s7eiGmYJc1RJmzqyJWgzvjIH1oQGrsT3rPNAkvK/ge0p
	nzZseszOwgy6ib3JHcewV7dXy+KDVVhyfFBJmyOPchRJs+A9tctCXASZMee8Ne+lWo+oG0KXrHN
	vGFIUSl3GEJxhiDD5FXtituRUN6L4o1aYxaOqP0XV3RMHKAXY8WxbEwTl0TnsRNDInADjE=
X-Google-Smtp-Source: AGHT+IF77YjkXmtVex/sVlR4Ne36oCr+3wNVHeHT/LNJIKi9cu3zPP+PCSutRgEjmTY0eBVt4e6VdMIa4pehys0SDY0=
X-Received: by 2002:a05:6512:3d91:b0:594:33fc:d52b with SMTP id
 2adb3069b0e04-59a17d67bbemr15216293e87.36.1767579004027; Sun, 04 Jan 2026
 18:10:04 -0800 (PST)
MIME-Version: 1.0
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-5-yanglincheng@kylinos.cn> <b79c4a9b-2d19-442c-969a-7479a8ed9dc7@linux.dev>
In-Reply-To: <b79c4a9b-2d19-442c-969a-7479a8ed9dc7@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Mon, 5 Jan 2026 10:09:52 +0800
X-Gm-Features: AQt7F2qN-KHJImLRlipROAKYhJA4j4ppS3Dh4laUKD6G8HyaXzOsZnFcj37ez0g
Message-ID: <CACZaFFNyqMD7oJv1Jqf4udFarozbQ=TPkaSMt_4Vmrq9rhoHxg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm: add folio_is_lazyfree helper
To: Lance Yang <lance.yang@linux.dev>
Cc: baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, richard.weiyang@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 710CA180007
X-Rspamd-Server: rspam03
X-Stat-Signature: 9nygft7yc7w9xe7r43pfkxko8n4zwxws
X-Rspam-User: 
X-HE-Tag: 1767579006-152695
X-HE-Meta: U2FsdGVkX1/rdfLt0V0erwWA48tJ+kczSNKGz8FjM3WZANoMRyRpjhmqMvEEPsn37smfaIhFa9MP8PNW+wKqYar5il4cjZgwtKquCFU/1uA9HtNXKc8B99YMjP22VbGd0csBozgbW8NiWUReE0IdouR50DGB8dSWlcfq69QzK1daF7snv46U9prLc0hW8YJTbitNEtWdZyIQqgmcaJ+p82i0xclbLc+PbdGgZVVmSZvQfN6qJJZN2zihDffHfhVE2++u3yofLfFtWNHh2i31qKXzZIYdFRrOT94g5TrEGKwqDd2sPFiHsx5WaxqXPV5QRHQr8NI0aiCe1t7hwVchOaC3tXjnwYxyIPTEjy0/pcaoJ6elW/Ph7EL8BcAK3laEk8iEqfBpiG3dZMaU7NmfRzqCT6URl8AYKoVMGVYrrTch2WgWulHgLdNCr1R4dXk75i9vQKTr9LyQBKgMtnmqtnBN2gJ17i+zjd855U+Se0qcz8LsGZA8AHrcPxxnfBm/KJsiYMV6Uqa45ZPh3Qw2FvbPgxF2iN+kpLvVaGxXMLKTfyEbPN8SkE/SQwaKcNTzGqDQvjvmUqEnsU/tJTv4YHkjl26dNHZiucIBxdfUzqIv873tBlyhNYXNesZEqg0lVTdLqOVaE87z269sT4nQJpETmXHcB0aCsXURzTucCICfC4nJE3frfJ9yc4BiOeAYnHtrU8idulztql8XDescJNsBGs0Us+UN5hkGqX3mwPqeBsYRalEJ8lF1fe2g/5lv0XBVNPk6n1ZMKuAhVrljxd3r2YmIbQS5qg3zj2lK2ZBXYEhmPrvAk567r6rWgcCwLAYjqtKI6z/T/SsBQWFU1fKXOhuCBxqFqa4glhRVSqb1XezxVN93ln9qSObWNg/KmC5Rl/j5qBSxNsu1sZIPjnugeVWk1K7wBNom+BpHF+eLZNuFGhruYifdclYFOxzyOzruFwcLIN6Pnpo10/H
 BzOqOco1
 MykfR7uffcqdb+EFsQpSopMvYP5j2aWNNNdgNADpmZ1DvZkRSfNU+UxsY1KW5HQgRW83BnXudHuS/+EPLULBt9Fsc933AT16n8i25GNbg4YCRjMMRMv/2WFCbeIulpw3r0cMLc8SjcglI7WoA2zFgAf42M2fYT2LzZiwr5t1diNFv3xv3TZ2AodbwWSAQUYQq/PofbtmUIVqTOzZDbu2xBo58xJtdDWTvomnaCLNa0U4bLUWn+Rp8qYhUrn+ygxcIjIHD4aHWeBEol5fv1SW/0h+Co6BFp8LzyF2Si9x7YlK4MUMV2hCoMKbU3+v3UYjiV/ab+YZwYt53mZ8gnblISbsubu63PS5dyTGWVAFnbt5mURM7brbuLjIsa7+JDciR4i8n/3uNqVytYfnQbCqlBv05PdHtAkL6kA9Fr5mtPjkYUblORcfK8RYSlF0ydcL1aC86q2KXP9XkiY8zFmHQM6a05Blq4fKFfgyeAhDE0HUR1p+DTXMZ1fznSZBcpc8gWbOwITx6+ZcIwW6oVKOQOhnZHkED21rXvUjOUQl9izapKXzdUoxeRyfvcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 4, 2026 at 7:42=E2=80=AFPM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
> On 2026/1/4 13:41, Vernon Yang wrote:
> > Add folio_is_lazyfree() function to identify lazy-free folios to improv=
e
> > code readability.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/linux/mm_inline.h | 5 +++++
> >   mm/rmap.c                 | 4 ++--
> >   mm/vmscan.c               | 5 ++---
> >   3 files changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index fa2d6ba811b5..65a4ae52d915 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page=
)
> >       return folio_is_file_lru(page_folio(page));
> >   }
> >
> > +static inline int folio_is_lazyfree(const struct folio *folio)
> > +{
> > +     return folio_test_anon(folio) && !folio_test_swapbacked(folio);
> > +}
> > +
> >   static __always_inline void __update_lru_size(struct lruvec *lruvec,
> >                               enum lru_list lru, enum zone_type zid,
> >                               long nr_pages)
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index f955f02d570e..7241a3fa8574 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1838,7 +1838,7 @@ static inline unsigned int folio_unmap_pte_batch(=
struct folio *folio,
> >       max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >
> >       /* We only support lazyfree batching for now ... */
> > -     if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> > +     if (!folio_is_lazyfree(folio))
>
> Please rebase against mm-new. Commit[1] already supports file folios
> batching in folio_unmap_pte_batch()

Ok, thanks! I will rebase in the next version.

> +       /* We only support lazyfree or file folios batching for now ... *=
/
> +       if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>
> [1]
> https://lore.kernel.org/all/142919ac14d3cf70cba370808d85debe089df7b4.1766=
631066.git.baolin.wang@linux.alibaba.com/
>
> Thanks,
> Lance
>
> >               return 1;
> >       if (pte_unused(pte))
> >               return 1;
> > @@ -1934,7 +1934,7 @@ static bool try_to_unmap_one(struct folio *folio,=
 struct vm_area_struct *vma,
> >               }
> >
> >               if (!pvmw.pte) {
> > -                     if (folio_test_anon(folio) && !folio_test_swapbac=
ked(folio)) {
> > +                     if (folio_is_lazyfree(folio)) {
> >                               if (unmap_huge_pmd_locked(vma, pvmw.addre=
ss, pvmw.pmd, folio))
> >                                       goto walk_done;
> >                               /*
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 670fe9fae5ba..f357f74b5a35 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct foli=
o *folio,
> >        * They could be mistakenly treated as file lru. So further anon
> >        * test is needed.
> >        */
> > -     if (!folio_is_file_lru(folio) ||
> > -         (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> > +     if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
> >               *dirty =3D false;
> >               *writeback =3D false;
> >               return;
> > @@ -1501,7 +1500,7 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
> >                       }
> >               }
> >
> > -             if (folio_test_anon(folio) && !folio_test_swapbacked(foli=
o)) {
> > +             if (folio_is_lazyfree(folio)) {
> >                       /* follow __remove_mapping for reference */
> >                       if (!folio_ref_freeze(folio, 1))
> >                               goto keep_locked;
>

