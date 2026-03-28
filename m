Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E2F10F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF8E6B008C; Sat, 28 Mar 2026 15:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6975B6B0095; Sat, 28 Mar 2026 15:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACC16B0096; Sat, 28 Mar 2026 15:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 480716B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:08:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D2781B6F9A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:08:56 +0000 (UTC)
X-FDA: 84596409072.14.21A1C23
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4380C180005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:08:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sEbxqwm8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774724934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeQgtsY95tJLXbmh4bHAGhhQnJn2Sav5FMf3jVrtoeI=;
	b=sfSVvw2pGXhEARrLSAXbuC7JPwJAJ0rmzwayizi3P0JkeIBf7FrIBpgytjw/7HTiPuS0Pi
	PXxKdBEQpqFYQBE1VotXO+x2ZNZsvfL6Ps2o55HYJucQRvUBGJyF0DEjSdvbWy4w0yAOX0
	rmsN1N7EggW7t8qGS7gzju994n4HVD0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774724934; a=rsa-sha256;
	cv=pass;
	b=fobNXWpqMR63sRL4dsHcdZo3117BhHtEaYAR0OJpc0uEcYqFHapxUSrvbhzfrX8MS9YHsC
	vni9ojJ3wDijHWT5thY2Zm+pDDjwod4D90rYxu+P+uBf8fdyugQRbkphgKfhVlgIvyWM2V
	wbl2q6Gs8LYsvTkkM9otHxYoxcGP0Ys=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sEbxqwm8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50b6c45781aso500071cf.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774724933; cv=none;
        d=google.com; s=arc-20240605;
        b=cfJ7iamH/HetU9zWhEzNCgTpavfTQUj68lB6kKaxgHh6NnaPVFw8x3Igb0eRApogtA
         Nx7a+nOaZXZcN9cW0EPwDKfwDrTEi/m3KKK1OBpcr9QEs8dUx9S6Ifa8uTBMUlFXeeii
         7ekbruQBWc5TN77Rht2a8Hethdm+m58faali3aseDmCoe/1IpqYytyp8VhJ2Bp/gOcPB
         4VVc4n7oj7vf/rcrJFe74nNgnKXjoxGKqgO/GYw1sF4UIgZAl1OSc4rclkCRmcG6H2dF
         X8ePRQQ2ODWPFALLPdC6laj0nLRhcXlWWA2gViwCTcoPN81dtbWV2A3VqWgMBZRsQiML
         NZ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZeQgtsY95tJLXbmh4bHAGhhQnJn2Sav5FMf3jVrtoeI=;
        fh=G36/o3KbK1HyupcqGHRhVSKE5eremDaaNpq51PfmUK0=;
        b=O1AxbB46swy4qqluWuqoHC9d3K5iU2ecZ3kfiNQMja6hdkZCguUoG+MmhLPKeQkG7g
         BB4la3bV6KwJqciQYE23FLRorrV/uM+si9+zxEwkm7lx9c7W36Zk7rbVHmkTP/aOcDGa
         BVRDhPfI1j2g2BTVYKeuwyvAsyTbtvi8zi9gsiOqhs3bdso7iRsx+EAIMvR5vuTccN5H
         eq9R3tf05I71kABNmmJ60RVnjhSUldBVW8jRS0f9iHFKttXPcqh1fAQYyg3qhXCsaHyi
         qOAG8vLMNaCSWWv7dP8IAt2Yj3tABoEy7bSTRQa338+PFTVqkEtmifLWs+X/zhcw1hkr
         iV4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774724933; x=1775329733; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeQgtsY95tJLXbmh4bHAGhhQnJn2Sav5FMf3jVrtoeI=;
        b=sEbxqwm8sYO9l8N/o1rIIfP2r/QjLRMqpFiRxKxIsCqtiGmDM9FqCVr5d0kNs9NC+m
         nzZHO9yx7yNhAhtZVUxERrGZkGUJQAVa8n02hgP4kdRWHsJoPyFjN0g7hAosMzV6HaPC
         aNWV0n44LWZ+dJxHmbCyrX7EmTWuW+eMvmmgBjyF7dXv0nhULmrFZMqKTflcdOKkFr2D
         P4di2JSHT+0pKSWG2xO8GmRbVhSfDDa8Rap2at23jzYq2h3woNoz9qZ2KAkjYJTcU836
         e9I2T3kM33FRpRT95RrliuCm7l0GYJK0Q8MEnwA6AZkBKgOqt89vXsMTa2NDyyxvcms6
         BCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774724933; x=1775329733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZeQgtsY95tJLXbmh4bHAGhhQnJn2Sav5FMf3jVrtoeI=;
        b=e8z/dD8SquMHBcweSz1z5Q4U+0+QT5rdE8Low464GecC/czhTxZYbAsG4/LncZFI5b
         5zFiUUpmmiyoQGJ8GGAXH9EpaQuN1RPVGPFvafqiNFNw+17NtN6DOE3tj3nROPip0iyv
         Z6Mks2RdEvOldtgYvdvCC+GDqhkiga6q7Xgr0KRJ0pOvQkOhpvR1AZvYYu1J4PxeZcDS
         uDrmyuwTSxcF46KthqN2IY/cpeMSOVCS9fy8Y2Afi6IS379VvDbeCOvjlu8dVnicahdo
         y31KMneEb6jgtA3Il3tyWMsO5kujiTo4KHa1w/3Nwv9CNDsRBiJxxZ5jq4Zu+DCOdPap
         2Kxw==
X-Forwarded-Encrypted: i=1; AJvYcCWONovy/3w+7DrOV4pM+qtg/oLqfI0Ppy8CyflX9ULcbQPxCLwnLgRx8vF2vPUt3Gg3IwaLleiAkA==@kvack.org
X-Gm-Message-State: AOJu0YzPg0VylCOObfrvjZoYyWwwE07OOzyvsA3k8+A4vAi8bMDam0Bj
	zv49oVuBhGhjXnZxp7go4DSZltHNLWcTzCCbkMhjKbZPG5nQEcXM3TRlvqcUPlzPFuT6XqiQfLc
	WA+k5AOxrDMFUNtbzjbcHNCFhchW+QYhmyu6D0bCA
X-Gm-Gg: ATEYQzz7YYzmf0wjZypNirEq21kl1B6KRGTwB9U4FyvJSlqvoE76KPuONgpyv+9XWEw
	ifBxL+iDGN6wxwUUuOc9zx+TWyyWDxFe5nLrqUa6O5HE8zZ1xB+4+iZWmCiyb76ditXWi2mflGg
	rVoZWDcd20euUMyHgdEfuTg2ugdclkuxPpDzrEVhFiwoXoxX2+S3JhQ3VnDFlSH+umj+fFb3uvS
	E6CBxv7iFI7pZ1wpi0uEtn6E3ln/tsVoK9aVc1rfV+VzskjhrLjSzIGkgc9tT5dULf6SU5inGUg
	sRNPFQ==
X-Received: by 2002:ac8:7d4a:0:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-50bb2690bd9mr12246881cf.4.1774724932696; Sat, 28 Mar 2026
 12:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <6b281d8ed972dff0e89bdcbdd810c96c7ae8c9dc.1774029655.git.ljs@kernel.org>
In-Reply-To: <6b281d8ed972dff0e89bdcbdd810c96c7ae8c9dc.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:08:41 -0700
X-Gm-Features: AQROBzCAAUiYF5sZCpFHCnjZu5d1J2aVEPhQ6RielJgLYciEvEnS79tUwQZwEng
Message-ID: <CAJuCfpEf239dKAW8iPPDn=nW3KrQ+LGnE8BzChuLrQc07_zXfg@mail.gmail.com>
Subject: Re: [PATCH v3 05/13] mm/huge_memory: add a common exit path to zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 66wy65tmo7k91j19nn5o31twf8jy9cqq
X-Rspamd-Queue-Id: 4380C180005
X-Rspam-User: 
X-HE-Tag: 1774724934-494676
X-HE-Meta: U2FsdGVkX18L5msBWb/X2gCMu4OQoLNZSq+/S/86BnAxfulJM02DNQjty0Mi9lI54JBCTUu7Yma2ab7w7UNUouIflghSnlyJxCiR/arvzLJout9rWy3rxbsaELDAuc73qD1cSqvzW3LMWu5NbKqSrvginNNPUqr11yK9+gHecHkatUARWUeNCi++g7Z1lRM7BLXL2N8bw94GH12s+RjK6X3ReZG9Ae5mjr47OdzeBq0fEcN44mgbv+g8rr7+RiH/S/cvZFjBKvgWV8cuK69IewiUQymtiR4gHGqkUNF0En1I00EMW/cf58Kd+s3GBd4g/iR2O0TvgfdA6DGGOHKpjj7+zImoi+5xXPhG3bqjbiNwHfDte4L1ggdG5GFpBwDhePtPD3O3vUk4qaPDma8aIdcG/g6RTlKaPD1C2pCAP14PGJCG/Ek/Dzfi6iBmc/B16huzuzpBpGUiNBteHCADnYW2ONeHzZyjLcCng9DzJRs4GzPk2HyOiWusmxrYjQzf6FHdc6xk8mw6uZQ1X+5FgqwjcclqrzuuUVU5/o0I4gJbh0edIrePnv8Q45XCYfhKQSDlmHIU2OgaNN4bvOYxFQnqmTwYPMpkiuVOntbjHz8H8wxLffud+o/RP8B2NdxnDRqIQNbekMX/QVpCNeSM/TFya3WuEBBN8OrRtnNWN4r4Kgd7EUz4JKh7yGgkbf2U4iVAvLNlePnw/LW+uji/o1V8t6u1r7/qDzVusvEdg1oqqUCvja4aJy4CQXjV68vhy9fmgROl8nNRMjSFfqfcMEXEsGK54QkGhsc7OfOulRxrCsk30KppvgcpkKUdLhe8n516uxMNI7zlNbgkWej/uhT15pL/c9gwLd7H3k5N7Q1uS8c+Yji+T/ZtvRYCw0AubUjU3Fqnt+nT+JTtw6TpHM5g7f2Qb+/GwlRzqRhUUivhvoXsVczPyQULWK2k/lBRytWpb22NWUtnqlJ9ikA
 SW8VjFzc
 jd73SkfbpBOs0hCPiDX9PVDq8H1uwkKao9Mwj5DU63uBGatdgcMsv/3CXkGqlKwp7AZg1ydHdWspFfzj7Fjx/pM5yAU1uzIV35FLpytTtL26k9X0IqqPrK4bijrocYLn7cW7wm6Nri4MsQIo0ZNtOivUEbCj37i9YBGE3va0AcgIlJhNbyon3IG18MK93mEUUA8liafJbsSohYVxdGxxBU2ptby6OepKbOYSTDPnUWXUCxBDyzk5/2fADYmBHakQVUQTyC/qbZ/w8GTAWQM+GSb6g0p8zAeJ51aEs0ImRmhc9CCINr5lgbD7JZVM5Dh7TWmfigvpZ7GrmPoZXyJS9gULdxVR7d9N3rK6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> Other than when we acquire the PTL, we always need to unlock the PTL, and
> optionally need to flush on exit.
>
> The code is currently very duplicated in this respect, so default
> flush_needed to false, set it true in the case in which it's required,
> then share the same logic for all exit paths.
>
> This also makes flush_needed make more sense as a function-scope value (w=
e
> don't need to flush for the PFN map/mixed map, zero huge, error cases for
> instance).
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0056ac27ec9a..b9d9acfef147 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2338,7 +2338,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>                  pmd_t *pmd, unsigned long addr)
>  {
>         struct folio *folio =3D NULL;
> -       bool flush_needed =3D true;
> +       bool flush_needed =3D false;
>         spinlock_t *ptl;
>         pmd_t orig_pmd;
>
> @@ -2360,19 +2360,18 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>         if (vma_is_special_huge(vma)) {
>                 if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
> -               spin_unlock(ptl);
> -               return true;
> +               goto out;
>         }
>         if (is_huge_zero_pmd(orig_pmd)) {
>                 if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
> -               spin_unlock(ptl);
> -               return true;
> +               goto out;
>         }
>
>         if (pmd_present(orig_pmd)) {
>                 struct page *page =3D pmd_page(orig_pmd);
>
> +               flush_needed =3D true;
>                 folio =3D page_folio(page);
>                 folio_remove_rmap_pmd(folio, page, vma);
>                 WARN_ON_ONCE(folio_mapcount(folio) < 0);
> @@ -2381,14 +2380,12 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                 const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
>
>                 folio =3D softleaf_to_folio(entry);
> -               flush_needed =3D false;
>
>                 if (!thp_migration_supported())
>                         WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
>         } else {
>                 WARN_ON_ONCE(true);
> -               spin_unlock(ptl);
> -               return true;
> +               goto out;
>         }
>
>         if (folio_test_anon(folio)) {
> @@ -2415,10 +2412,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                 folio_put(folio);
>         }
>
> +out:
>         spin_unlock(ptl);
>         if (flush_needed)
>                 tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> -
>         return true;
>  }
>
> --
> 2.53.0
>

