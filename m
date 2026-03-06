Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019CDFCC079
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 21:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7876B0005; Fri,  6 Mar 2026 16:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84E86B0089; Fri,  6 Mar 2026 16:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59716B008A; Fri,  6 Mar 2026 16:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A13446B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:07:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D29E1406EC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:07:28 +0000 (UTC)
X-FDA: 84516874176.18.52AE992
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5086E14000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:07:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iC6BLlB2;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772831246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dv/UW2GkYnjd7ljmBiu2DiN4ZeUG4vxqQWP+FlCaVsE=;
	b=dk1z/EI7iuYmHEZOTbShTJjMOS/QvVP/L06WVGcRK7zNy4ffq5GcFG7/qIA+hsavG587s2
	HFXSINEGlOX287/rXUu8CSph9eosgScXdjZJoKqMGIks9ZgB7/wdue1A4LkDKF482EEACm
	V0kIu6dIrHOGBVsfCL5hO9AcBrk48ho=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iC6BLlB2;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772831246; a=rsa-sha256;
	cv=pass;
	b=WAr6/cwqdJs4UsUL4r5pQ5FCHjEuiDmXtjb1skpoBjMhL5/719zG4s6eYdk8zeEzUALzJ4
	z1D174p1L4MnFmh7r9glW3jsUbeiQp1kIt7idaMLrwIUiUMd9d+kBma8Ac8g/OG9I+8Dw2
	l6/cljOEnoCRy/n5cepS45s5g6d6XCw=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd751a4e93so26526585a.0
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 13:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772831245; cv=none;
        d=google.com; s=arc-20240605;
        b=STFcFRCNMEiZkk//ndI1EncjsaWf4BuuByC+dPf7KBdkhA6BoPzZdrS6WCHyU6AKQ8
         +59k+IzgeVpPUzgUhTTMBrMfH9wL1Hb+YUFOVf9clyNuAj2BY2j58qdMqKZc9Qma2Ahi
         qpxzdgRWWEAEO8D+EmpmwiyLjc4pyvsRgCaqI0P+rniE70QAt4L1uhQSGNFvgvpD338f
         aXwIFT74AZHoULyJ0HO9iC7WKWSdFt7saGS+US8FYyXf8aPiBq4KQyVXiH94HMDWQEzP
         Xq4dyso9nErNsuAd2PT4guYopnTy2OkYgu+vutW4rSxZOEOtw2oo3833yT7wVGRiz/Aw
         0l/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dv/UW2GkYnjd7ljmBiu2DiN4ZeUG4vxqQWP+FlCaVsE=;
        fh=y2Uln9dEjIhmkwoaaoAsx3V1p6F7VAsl//KA3QFyYvg=;
        b=aBucvcg9/2PV58i7nj3ELs0iaWFiVcJzuaI5WWSyC+x5Y8bcU65SltK4qlzz4wJxnP
         jCsqw6bfxC2S2pGt+lYGBy5vmv4h0TBkGimGVboS4tucuVG+JtQsWUWG+zGdOTxDlVv0
         xvLdPPaSBE16/kUYA1c+VcreJH/JBczTGINVVpt7QDFKcXcB7+VB2vc+vSc8/eEAJxus
         kgjJm4t11UGmWN7Iq/7013FQjZu7rZdTsa04aFwAqBRM3HQyk6Ggq5muLbUCpcoDZ0VA
         Sqnlt/V9dwVoREX3t5CZA7lHtpE1SNqegjQpIWYKuzi1qxJosQ9hpHto/RVEHc+pdTli
         hQTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772831245; x=1773436045; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dv/UW2GkYnjd7ljmBiu2DiN4ZeUG4vxqQWP+FlCaVsE=;
        b=iC6BLlB2pg11PJXtxrYt5tZKuQ4q3/vdpgV4gyobJbi2M8BRk4T94/5gSzsDaw3IpW
         Z7ku+l/YjWKbhFDxbxvMkUN1ShAavZBMCzbQqQdAqPeJ7fyKBjTr/HUU0hz++AypRzj5
         jtvFbvFOpaKG0dGUJZqJ7piwyJLOGo6ZjpJZwqEZgO7g2TthdDMI9IBcADu8YjzOxke6
         ED/05kcHI13NOMQrnvNzSgUCV1hndaQeCbpA2/3iyta3pm2RXw9WX9URLp/ZxWml7XQh
         PvEIx1Xq8DTxQo94VTu3fUZ2o8+FU42SKhSaJnuqXUx1bVj80bHQDNSCUnOuLNVyXGw/
         LyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772831245; x=1773436045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dv/UW2GkYnjd7ljmBiu2DiN4ZeUG4vxqQWP+FlCaVsE=;
        b=qUlTppwnWRLTbM3wik8i23WRDh7ovChx1Ak9hzS1PUY2CC93Bq8N8+HH7PF5OjxKM1
         VcrPNt06nunHxlRlbjLKkOuF2NNxFAzd1AveihwL6gxoJd6Qtz7X94jTLiiQqbiYmES1
         FBDxme3eSHm7pifYUuJg4RrOOHHKGnF95j0mnTyAzfuwRtpp9VfV2KgiznF88OxHIh0D
         J75/n9QSAS+Hy2wWbgx5nyUgBU1AcQJGysnAcp6grZ8G94VFpHGTosAwC7PTV+qYJjEr
         Lbvrs4jisDbxeaHC7bXrFRbuC+TctbEOkmv66acwBoQrPZePykurMA8l/rMoQLmXjLF3
         H66A==
X-Forwarded-Encrypted: i=1; AJvYcCXfR+64BP8maoLYJnhnAQ4KrEHbZjyJkAUAKsjPFSY/JhMKoj6ohnia5AmZl9CkIAWZFussY42ZaQ==@kvack.org
X-Gm-Message-State: AOJu0YySG4zF3exw+dz8Qneb5GMNaSvxMFef6IYF2+reZzBO8/t3qyxv
	s9m19/ke6TE6QtV0esGhqUKS9MSqnjeAcmDLR2quF5O4YnRoUJ9Fqw6IplnRK+0Rilqzu4FSI2T
	YxihskXB9bq6o4zf5eNuPgc+bZqfhXfQ=
X-Gm-Gg: ATEYQzzP1MmLayIfOuUpdIFI5Rov49IDhf9fA0MZXHw9W6X6l7J2ToLCGOA8EnN9ClA
	MqsIbPPs7IcjzBbJklDo3WzDSeV7Kkw5FbORPmM9aol9bVAQX3CJmZ+SUNIinPJSe9bE8L0o1R7
	VEml1Le3tokhEcTUAUe1PPym7IqbJOX0xch7tgPZAozlIN7riSiIXTyN9QMXINxWEJcV2VkvBwE
	0Xdpme/kgs1h8uKF7H9D3LgKBqXFWpjDHHfoIBE0GemwFfvZOsgn6oT+wNweex7GsttuiWsFODA
	3OkfEw==
X-Received: by 2002:a05:620a:1aaa:b0:8cb:3870:5c1d with SMTP id
 af79cd13be357-8cd6d36dc64mr466631885a.27.1772831245013; Fri, 06 Mar 2026
 13:07:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com> <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 7 Mar 2026 05:07:13 +0800
X-Gm-Features: AaiRm5151EfBymLyRlhPC4FnFR4OyGEYd8ZUdO9wgCPfV6jTdSKsfU7KlZGNXtg
Message-ID: <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5086E14000A
X-Stat-Signature: 633d36ecw9t4gnm11su5dz7csjpdq3bm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772831246-118999
X-HE-Meta: U2FsdGVkX1/lparBjvdtTeegHaZRfDcC0BpnLe73HFks73LLCBWrfmbD8c/VqyE4WrGCd+WdcTNPaKC2x/Zqhp8/JugxrqV575xEL43ri97ROarT98fh3SbsY1Aq1omtPQH0VKJs2PEYL+tlbNfr5mnvyoLuFkXpY1xutgZ5bqWaLc/vB0aG7bqEl0KeGb6b1Ocbv1Znnt3uSpPqAD7Q3yiLeCDpxT2m8ZdBlOH2cX/1tPMHb9x+umIc0lBEkf1lgkmRUkW0I85D0yHc0EcPgAOgH3fXWpXwiitE0bm67Eyp9x1e3YGD+NmYLWVJ0VXV5HmJAWYGEhQo21bTXd+aavzNc3hWjreVE3xm0Wofaz790dN0yIWrc+ApREMcWj/uS/qLbAkdHaQDm2uga+eeWyRUEk4zxNl+VQNWiUewTd/dopHHIIK3S6DAsyzQwExchyihAooIrCgsBP/+tecXAxnYZxRugkORdAYq+ah4/s70JslRvATn2uK25n5x9Gl29y/nlPkvrT8P5nsLw4OJbp2NZeapKeO+hwmcypF+guppu7Yzs6SXuj/9E2q8khiSjkUasna3TmOBoRuOWNg3dV7DSj76T/6sYVQSWI7Kpc95TXuLKZP/Ivp87SZk9XxpSyXiJCaS4DegwcJ5sEUZeWwmaG7ZK+FlHCJZFOrfPx7bW8wyGZA5K24ucoCvZ/WTOIwGVEjHffZ65+uqDhsoy3Kid1dfPfL233sOyiKb0kKvkOHmyHMTD128i+8+S+InIiei0bLTNrMuH/JKjmV1VLeAbJU1duX0CJarsfHusqRY/SoQQK/QNcn7vbkESAtulSof53UppAlT4ahR++DMC2Q3yGYhyCsNlC4tpJ8WhnmkA5trv42HKLht6m/qIEeBcFQ46F6ddoa1KpVsfvyq4tORZ3uxHMxNrgqndJjKPIcB/DwExFJfyyP0yPACa5KravG6TJvhCAOOYzguf9x
 HfjrXXBl
 gwqW/+stkRftT+dECJ7VBhtd7zApyCJ5cywXXHSOwc5AMV3rbyHyRzL+oEJIAckMFtauu7yQ6LhRtS/i9keW8rDlZYB8FYJGftOBrbjJmsskji1d0LzP7Om2rL+zKE3/0ndde9a6lJ9S3pbYRSR2reWM83wfRIwkQzsnnNUm9t5do4ahJeVaA9+V3qIj8y0XT2W11QL/utsKM7pXRhkspdYCudTBIF4qp4bBMyUPQ7EgJ8yE5Ow5y0hqPjoBkijW9X7YxwPllDa2kPCKMsqCpARWpZJvDEXFwOU0kTlQGPwxH5eV/PXMz+VJdoOVmTDTqKEu/s4F1pmL90GPmo87enpTGMcjh2MZSOCzI0eLXn547C8HH9sGSocww/7ff7N3Vz+z4NZlDZOJSB1aVw7eQ88CAM0QWtyRZdVJZnjDZkcZTvaNonMrfJDMnYlNHYbqRnH3d31p/v4qBac5Hm/62pIP5mxjU5DgEzJVDrFdbURKPZUmtpbhjWKURk8/uqMwtdv8I2SwKTl9kfmza9L7Io+zRx0Gp9WjyxfV+aBzL4A8BjN+PwQE1RkqnXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 10:07=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Currently, folio_referenced_one() always checks the young flag for each P=
TE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, whe=
re
> folio_referenced() is observed as a significant performance hotspot.
>
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is=
 already
> an optimization to clear the young flags for PTEs within a contiguous ran=
ge.
> However, this is not sufficient. We can extend this to perform batched op=
erations
> for the entire large folio (which might exceed the contiguous range: CONT=
_PTE_SIZE).
>
> Introduce a new API: clear_flush_young_ptes() to facilitate batched check=
ing
> of the young flags and flushing TLB entries, thereby improving performanc=
e
> during large folio reclamation. And it will be overridden by the architec=
ture
> that implements a more efficient batch operation in the following patches=
.
>
> While we are at it, rename ptep_clear_flush_young_notify() to
> clear_flush_young_ptes_notify() to indicate that this is a batch operatio=
n.
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/mmu_notifier.h |  9 +++++----
>  include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>  mm/rmap.c                    | 28 +++++++++++++++++++++++++---
>  3 files changed, 65 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..07a2bbaf86e9 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>         range->owner =3D owner;
>  }
>
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)         =
       \
> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)  \
>  ({                                                                     \
>         int __young;                                                    \
>         struct vm_area_struct *___vma =3D __vma;                         =
 \
>         unsigned long ___address =3D __address;                          =
 \
> -       __young =3D ptep_clear_flush_young(___vma, ___address, __ptep);  =
 \
> +       unsigned int ___nr =3D __nr;                                     =
 \
> +       __young =3D clear_flush_young_ptes(___vma, ___address, __ptep, __=
_nr);    \
>         __young |=3D mmu_notifier_clear_flush_young(___vma->vm_mm,       =
 \
>                                                   ___address,           \
>                                                   ___address +          \
> -                                                       PAGE_SIZE);     \
> +                                                 ___nr * PAGE_SIZE);   \
>         __young;                                                        \
>  })
>
> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy=
(struct mm_struct *mm)
>
>  #define mmu_notifier_range_update_to_read_only(r) false
>
> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> +#define clear_flush_young_ptes_notify clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>  #define ptep_clear_young_notify ptep_test_and_clear_young
>  #define pmdp_clear_young_notify pmdp_test_and_clear_young
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 21b67d937555..a50df42a893f 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct mm_struct=
 *mm, unsigned long addr,
>  }
>  #endif
>
> +#ifndef clear_flush_young_ptes
> +/**
> + * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the =
same
> + *                         folio as old and flush the TLB.
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a si=
mple
> + * loop over ptep_clear_flush_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For e=
xample,
> + * some PTEs might be write-protected.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecut=
ive
> + * pages that belong to the same folio.  The PTEs are all in the same PM=
D.
> + */
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +               unsigned long addr, pte_t *ptep, unsigned int nr)
> +{
> +       int young =3D 0;
> +
> +       for (;;) {
> +               young |=3D ptep_clear_flush_young(vma, addr, ptep);
> +               if (--nr =3D=3D 0)
> +                       break;
> +               ptep++;
> +               addr +=3D PAGE_SIZE;
> +       }
> +
> +       return young;
> +}
> +#endif

We might have an opportunity to batch the TLB synchronization,
using flush_tlb_range() instead of calling flush_tlb_page()
one by one. Not sure the benefit would be significant though,
especially if only one entry among nr has the young bit set.

Best Regards
Barry

