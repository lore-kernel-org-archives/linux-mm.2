Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C57CF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33726B0092; Tue,  6 Jan 2026 21:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3DE6B0093; Tue,  6 Jan 2026 21:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00D86B0095; Tue,  6 Jan 2026 21:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F42F6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:21:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FE5A8E4CE
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:21:23 +0000 (UTC)
X-FDA: 84303566046.02.45F972D
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6318C140008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:21:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TmSvfc3a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752481; a=rsa-sha256;
	cv=none;
	b=B0ruoXmG0qw3saKMlM3YPUMPpMj1J15hh4OPI0DeTEhE7P5ZZUr+TV3tPy5EiAiRZVo0Np
	XYtBw+YlZx5SGBywXmFkEi5GzhR8vJ+EY8wDGPUasPGuj0qYCvZvnfxIZBcJv4nqAV4xpz
	0v60Vb4Dt3uEIEYN8T+80ZDrSQwAznY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TmSvfc3a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9cpNlHN3hqxmzuHBR+IH1AWmpz8EK2C2/QSy6gpp1o=;
	b=EyD46jwgJmmud+QpQInOphsdqql8mPtVEXEOj4esskkiHAso1l1ROVz4aGWQ3MWHHhw14q
	Q7KVt8BY+aCxluRVayTCxF5hNNcid0Y8LbCrTp7N9GGUDvzcPEwVl3K/ahB+dMfbB6Yv5r
	8w8C/JSOy5KMCpxEth7htVcJ4N0147o=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88888c41a13so19022456d6.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 18:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767752480; x=1768357280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9cpNlHN3hqxmzuHBR+IH1AWmpz8EK2C2/QSy6gpp1o=;
        b=TmSvfc3a73nm224gAS1ZqSJknJDV5NCj7d3c/Ax2+dXXuW75UKkmPPWkpgDcMCJYUy
         KQhVF2l3/KW3oekN+sN4/DAsclgFup2ad35aiv2pTEJJ0FHbrumpnImv3xrVl6+o/D17
         6rwKa2aP1QlCJ2jfQtzEjAHMqpcKmFFTUrxofGaWtySWn1oTtKXjdXXel+u8+09/bxel
         dR2V0hAh2zJwVI5DUQ/08vG15WGXiDSOSotxLTPztVm7/jsqm8F/cQWdTRPTAb6FckjZ
         VUHo1TANRvJ9bIcJpXAXLDb2fNrDHMP5Q1ChZEw/A4VyVkXXDA5Z5mihfXbFkWncEyzd
         Bvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767752480; x=1768357280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U9cpNlHN3hqxmzuHBR+IH1AWmpz8EK2C2/QSy6gpp1o=;
        b=jC5Tg1VV11gpV5KMQG9YhHo2Kky+9XN+io2hOUtAFfGXdh4G8dooGfcmLpbc0NtjN1
         VTG6Yhu9jf3XLSF6h0oPvuPG9xsrJwwrCASKl039WQBpRF132VD59Y82Sr6kbNk64ebf
         tCrj2CZB3s2fYg67Mul/4se2WfpCRIr3Wkn/mdzrOh6jRZ0COK4qi0AvEtzN4UO7R1Bw
         iponHfPe+Tl1BhogNlxR059uX8whPrBr6Bz5SQfehEZkCoj2DYpQrFs4byWhk5Z0nvMG
         U08uQye5Sp1ACz6otcmvjL4xwXvTbEjOjJC4Nd7rM2Xye48W61bqWaJJWWylC4HOQMb3
         muEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV94zTXi4nN1lkDdg7LP+/eCyaKaiJqm45IkX5ZwOLVdcbblxqd0qGqqMsq832Ytm3Ou+DwyzdELQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc+K20XS+6X4My51D2vJ1bBpGZoY1FD++YXH4ZGucxrYanIvlh
	Aobu2EPQHvWQ8ey/A1Mfc5W6EHpWg5q42NMW1lAJOEEczvQy83wwEnbEY0unsvWARTFY9UBvu9/
	ZNdx780M42qxu/NpsXU/M/mtOcRBY3pU=
X-Gm-Gg: AY/fxX6XBZUVAmKD5d8/AjlY/FZu6DEWueWb6ZSrbcgVh9uqQyY7LUkiM3bP0MayEwn
	wBLOSykFf5sB9gmQL5LJqT7IgRL9TrGFguAOmfXudsQy/KWeTrZd2+KwveqfZbeAVpxAGX95/8g
	OqC8mojlb+KSSNxGV3zvZYYHpWDBtcFXvPKfBFvyd3/FYpqhnlyRCQb65dmfaTX6rnkBFojL+JH
	AJluWVMY5QTNYRT2U8VboNbBPqRjbcH6RhZaN08dsvcoT6SD+halshgS1UzePQirKaxMg==
X-Google-Smtp-Source: AGHT+IHEeDTyOy/N8XIYTCLhg64xhVYMnmI/eJHgFbD/6zfBItwvl/vVHLKIaYBVmNPgiNfq31Nq4Z95zjp/zZW2QKM=
X-Received: by 2002:a05:6214:2dc6:b0:890:7084:e32 with SMTP id
 6a1803df08f44-890841871e8mr15281806d6.9.1767752480217; Tue, 06 Jan 2026
 18:21:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master> <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master>
In-Reply-To: <20260107014601.dxvq6b7ljgxwg7iu@master>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Jan 2026 15:21:08 +1300
X-Gm-Features: AQt7F2oBRO9EL-TaBqBNZ53miS_qqh3dtM_egJf8cBa7y3uaGmOJ9tdSmO5VZyo
Message-ID: <CAGsJ_4xfVnPKSPvHYWa1cPK7kZC4F6hKreny9RsKfSCyC4RHuQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, willy@infradead.org, 
	dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6318C140008
X-Rspamd-Server: rspam03
X-Stat-Signature: cot51uzi8drahsokogbhe4n4zg4sykax
X-Rspam-User: 
X-HE-Tag: 1767752481-927708
X-HE-Meta: U2FsdGVkX1+hknuclRn0uH8q7JOpP6CjT6Nik3LDpiTAnsjeonsqexJn26IM6MtNmgl1VoqC1D5BDEyGh5mB3v4iAO5PZO7gtlYVhd9r2xMaYcNPWZpQPnzTMQPP4C+5MuFDdDaTQEsPR01ySXI5essk4yP2LPFW/kVnSB77OydlX/v86nYQA8AZOHtikHTUdrllk9VCLyKmvi686XUcgi2W82hXUkfqLC+JkIpRmTXVqYrKMBacSzRHco5JYoS14fImXxB/aIkmIaMdxxv807PXJ8RCdiVmCcWjAs1llamhUHl24H4L4yPoZZ80MhI9UBVUOWoDEiZPbjPICHZULmSbBwQGDzcy6k3UCGHKm6ey7apAfDCX7Pae/1LezVxyDg9O4EjjlQNAOKEFU5F75iKN+LrYvict5lrRpdSrqmTlquLK2dUYgwyL3KIqNS6R4Fgf1NILy2CoEwi3nQ80z/ii38H0eFGqllpzQAjGGSlc0s2pkvyyv1gOj0pLkse2c1111pc+XcmlWprjdOo3zj2ZYrK6aGVlg8S5fLCo2jmX0pK07KFi0Oh6oGfoS02ZJkmrl5Q4QLc2rSOCOMe6OXQn564OHAZYH1QhNikJjf4jPmIfZqyC/3oY370ShLKnBIpLzw/UsDIZQVCuQL8IoNuYqYHownbkgdLFcLEqjFzGw6e8A2To4p37pGMzhYROB46MCCShlsowEFCgtky1bh6XvRHavxP2aRezSUGQS8oJorx2zcj3fNBxXPNShcsKZJQdPdwkspgmSmA5ersSzxs+aCDbQ2Toky+YFCeV6QI76G1gTBMyDABEXoYxooZqtSZ12lp3BYRrc9sjS1bldg4UHs2NpmojSfawkLf4wsEfvKwUtP4jn0O8UfAdpYVr1A8e/6F8vLNijMJeTUSEjMBGvrevQVzYvjBT6Gcj1Stg3zPGbNrT7dG/+s6IQp/1xic0SidLIktfn0/fWf0
 i0VmudgX
 7UtERcZRUDeiSbAdHeRLb5ZkbP0F7+ehIn6ajsm8CPZJldIG9ywlSG+r72OEf7593w2FSMlXoYr6u0jk15lZ3rDI9Y/1mmsnOsaY4nuTqStBz75w15BNaVDA8tkOp1UofIpBikpRYOcLlmeeRngE4zbxojVHje70V3p6woe3JyTUNiiAyWmRUmFXBbVCAuym2D7UR31BH4ngDBDcoB6G4gjr0PfKWsShLwT7oQFw+0MLBTw3EwpFGcTIFm9NVlCTH45fKmvv62de/E4Kd5qpv9bP5X0oZGRtE634Y0t24pMcKczmveLPGtDISjrtijstzO0mJlHZyhFI3duYKQYgl7JiOkB1midfpNenmyeMP8D/vEMRDN5DvX/Kw2kLq0QpjbYctYU1jeA9tSrCXXEHzQbwvRvygj02zICn9biZAlZHCfiSaRSsnj6V3GNb4iIBwSmqh8OATMpjQXflcgWhVIbvlqA0Lmxhzp0UT32IxHLn9I7uvtQSA561MALpIb4Z5U+fEfq6xMAlwfPIFztI3HwcwQ720IATIvvx4w92B/VC5480=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 2:46=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com>=
 wrote:
>
> On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
> >On Wed, Jan 7, 2026 at 2:22=E2=80=AFAM Wei Yang <richard.weiyang@gmail.c=
om> wrote:
> >>
> >> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
> >> >Similar to folio_referenced_one(), we can apply batched unmapping for=
 file
> >> >large folios to optimize the performance of file folios reclamation.
> >> >
> >> >Barry previously implemented batched unmapping for lazyfree anonymous=
 large
> >> >folios[1] and did not further optimize anonymous large folios or file=
-backed
> >> >large folios at that stage. As for file-backed large folios, the batc=
hed
> >> >unmapping support is relatively straightforward, as we only need to c=
lear
> >> >the consecutive (present) PTE entries for file-backed large folios.
> >> >
> >> >Performance testing:
> >> >Allocate 10G clean file-backed folios by mmap() in a memory cgroup, a=
nd try to
> >> >reclaim 8G file-backed folios via the memory.reclaim interface. I can=
 observe
> >> >75% performance improvement on my Arm64 32-core server (and 50%+ impr=
ovement
> >> >on my X86 machine) with this patch.
> >> >
> >> >W/o patch:
> >> >real    0m1.018s
> >> >user    0m0.000s
> >> >sys     0m1.018s
> >> >
> >> >W/ patch:
> >> >real   0m0.249s
> >> >user   0m0.000s
> >> >sys    0m0.249s
> >> >
> >> >[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.=
com/T/#u
> >> >Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >> >Acked-by: Barry Song <baohua@kernel.org>
> >> >Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> >---
> >> > mm/rmap.c | 7 ++++---
> >> > 1 file changed, 4 insertions(+), 3 deletions(-)
> >> >
> >> >diff --git a/mm/rmap.c b/mm/rmap.c
> >> >index 985ab0b085ba..e1d16003c514 100644
> >> >--- a/mm/rmap.c
> >> >+++ b/mm/rmap.c
> >> >@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_bat=
ch(struct folio *folio,
> >> >       end_addr =3D pmd_addr_end(addr, vma->vm_end);
> >> >       max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >> >
> >> >-      /* We only support lazyfree batching for now ... */
> >> >-      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> >> >+      /* We only support lazyfree or file folios batching for now ..=
. */
> >> >+      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >> >               return 1;
> >> >+
> >> >       if (pte_unused(pte))
> >> >               return 1;
> >> >
> >> >@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *foli=
o, struct vm_area_struct *vma,
> >> >                        *
> >> >                        * See Documentation/mm/mmu_notifier.rst
> >> >                        */
> >> >-                      dec_mm_counter(mm, mm_counter_file(folio));
> >> >+                      add_mm_counter(mm, mm_counter_file(folio), -nr=
_pages);
> >> >               }
> >> > discard:
> >> >               if (unlikely(folio_test_hugetlb(folio))) {
> >> >--
> >> >2.47.3
> >> >
> >>
> >> Hi, Baolin
> >>
> >> When reading your patch, I come up one small question.
> >>
> >> Current try_to_unmap_one() has following structure:
> >>
> >>     try_to_unmap_one()
> >>         while (page_vma_mapped_walk(&pvmw)) {
> >>             nr_pages =3D folio_unmap_pte_batch()
> >>
> >>             if (nr_pages =3D folio_nr_pages(folio))
> >>                 goto walk_done;
> >>         }
> >>
> >> I am thinking what if nr_pages > 1 but nr_pages !=3D folio_nr_pages().
> >>
> >> If my understanding is correct, page_vma_mapped_walk() would start fro=
m
> >> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cle=
ared to
> >> (pvmw->address + nr_pages * PAGE_SIZE), right?
> >>
> >> Not sure my understanding is correct, if so do we have some reason not=
 to
> >> skip the cleared range?
> >
> >I don=E2=80=99t quite understand your question. For nr_pages > 1 but not=
 equal
> >to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside=
.
> >
> >take a look:
> >
> >next_pte:
> >                do {
> >                        pvmw->address +=3D PAGE_SIZE;
> >                        if (pvmw->address >=3D end)
> >                                return not_found(pvmw);
> >                        /* Did we cross page table boundary? */
> >                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) =3D=
=3D 0) {
> >                                if (pvmw->ptl) {
> >                                        spin_unlock(pvmw->ptl);
> >                                        pvmw->ptl =3D NULL;
> >                                }
> >                                pte_unmap(pvmw->pte);
> >                                pvmw->pte =3D NULL;
> >                                pvmw->flags |=3D PVMW_PGTABLE_CROSSED;
> >                                goto restart;
> >                        }
> >                        pvmw->pte++;
> >                } while (pte_none(ptep_get(pvmw->pte)));
> >
>
> Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), t=
hey
> will be skipped.
>
> I mean maybe we can skip it in try_to_unmap_one(), for example:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9e5bd4834481..ea1afec7c802 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, =
struct vm_area_struct *vma,
>                  */
>                 if (nr_pages =3D=3D folio_nr_pages(folio))
>                         goto walk_done;
> +               else {
> +                       pvmw.address +=3D PAGE_SIZE * (nr_pages - 1);
> +                       pvmw.pte +=3D nr_pages - 1;
> +               }
>                 continue;
>  walk_abort:
>                 ret =3D false;


I feel this couples the PTE walk iteration with the unmap
operation, which does not seem fine to me. It also appears
to affect only corner cases.

>
> Not sure this is reasonable.
>

Thanks
Barry

