Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B0610F3DF4
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483F26B008C; Sat, 28 Mar 2026 15:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B886B0095; Sat, 28 Mar 2026 15:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371616B0096; Sat, 28 Mar 2026 15:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2397B6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:45:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B972456787
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:45:22 +0000 (UTC)
X-FDA: 84596500884.24.12FC313
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6635140009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:45:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hhiefQEF;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOT5aN6Yy5qJKZewfMWcjccfRN+5rZDXSfjUVT7TFfA=;
	b=bbpiR0Yo04XSa7frQYOTFfHmhOWCGAB15afyvLGN2mFoGUWwt/bW94+3pDr7N3DWRsndN6
	R/CVrTeXE+6/MY78YdZVbm1+TcocwzrilDw6i/G7Qht03mCM2yOzEiZfwj3fbGTq7m/h0t
	SRKMFDgPG3NVkMp3mqo8HK5NZ/qH1BE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hhiefQEF;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774727120; a=rsa-sha256;
	cv=pass;
	b=yBgSp1Yw3VcQsd2HlxU9NUO3CqY3/x1sy4SyBjF6T1KBxHgCcYwOEmyC/oyHNacZchP3TU
	NE0fQVdE3fCRzCUmLrTJ0Pm+b+KIrqQilXqtxHQFLmxBxLm2qktrbUR4ZaGFBcPIM0tNbq
	zlyQw5pWaLL5o64MQbign+ve2+listM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509062d829dso442321cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:45:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774727120; cv=none;
        d=google.com; s=arc-20240605;
        b=MlE0s1HGLTOYFGNrjnUwfYtqPDTc7EWiv9Not5amz2sSiu4UdHmhyjeIV7yAwHVS1z
         kT7jWME2ez+G+vAAeKD4FMaWBjFaxLx/2uyShUupH/HTgdNCpmSN8VjHv3Kwmk5sRUeK
         CvGCPLQHnOblmvpkXO40pb9UiQukdoUWw+SArsiQ/K7JvqbitfPCzzQZpWNynbnPMzEA
         rvoKiTGfupeZrE6/Kggy+MS53XQv8MmU94954Z9eTmwYDcwDotXMW+uwGNOnNTPibZ8O
         ShZjuvBKQrDLiY+fbFgpUsB5opcmhyvxs3iC1hc4/OmB2Mf5HlRX7ra5Tz1YcgI3nreg
         I46A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wOT5aN6Yy5qJKZewfMWcjccfRN+5rZDXSfjUVT7TFfA=;
        fh=ZrVCdPvH1JWhxOFrnbGtvq1lgO3m7Jv2vUJT56UcbMo=;
        b=O80zHQUVgM2jE/WxIUDIxkwA5eVnaqJHABrdRsmuIeIW6Rs06MLKZqzVdQjg9DOH7M
         AfVkyTNtOouJu33oDAU3oHE3EAZ9Yg9I2E7lbuEIgkaFb/GLSA1r2STnnyesgJLokvZ+
         y9y8sTohNZrkgH0rp3DUNJ4SsB0L9ScnSJiPnM6ho3pywPPzfcmfeTyTXhunllHVQnx9
         qs5cVkgV9w1ulhtKdzSgkG23F268xG10Xtk6vCD1kCgIwoL34ePYg31fh45Py/apUdf2
         xAe4QfQKy1Wn/e/UyWFU6V9CLibGghCLgfr8rciH0crehRAFlRRoK1RylWx3IHiRx68M
         guzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774727120; x=1775331920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOT5aN6Yy5qJKZewfMWcjccfRN+5rZDXSfjUVT7TFfA=;
        b=hhiefQEF/52sZXvkrAa/qIRR0Pd30VIwhlzfchIr5OR6flQ8tUNq05G0mAhOYD4EQe
         Pqhhm9V/2RZ0gPHHK5/b2sPvLAGxTosNTJROswoIRbtXt6x9XwIJEW0iChfBUIVfqz+g
         l3bchXdEUpW8a5swUt+4DeIde29YjpXNVybbojFjLvgVWY3o3D2RxNk+4zq+HXeSkVbm
         b0xcmFDVL2j9cQd/OmUCSthU9SLHsF3/LFui+2A8ptR9l8Xs+r5EuEPU+r5yyHfLX3q/
         d9ynSZBpE1tNR9EesvT+saEOQ1RO2JLZS9ey7d/50cPWWxFp1TC/DCv3JJTOjJvEY+33
         XBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774727120; x=1775331920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wOT5aN6Yy5qJKZewfMWcjccfRN+5rZDXSfjUVT7TFfA=;
        b=jl77O5v8d+OyvGtodHb8eIQebN//P0oN3lPjj1U3PBwOMtkKMxWzmYPsXHY53FqHrC
         0qZBWyNkBDbQ+YgQdJsS4KOykvfS6wQuPESlIdv2VariJSDev0zGUTu6KlCfi09PCLY5
         VElYaZ+Ex0akVYCsLNg/aM4ofRj1T7mssjvWfO2qY0X9gyeGi0ledXMAFSxqsCsmwhDv
         x8WuxshKVPGWYNXk9FJiNsBezIEcz6T9uR6LCcJlhOoYfsFb+mt0WaV93Au3dtlDhI1b
         Qv2kWtyXdxSeLnlh3jc9MLKUg3t65whLKR43fo5fNy1JT+DnD+3kC9Z3qwHp8oqT/APd
         o4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP24aZ1ArXu3Pig+u2874aqsc8UAG7wCPMjIMcY0/rwj+DwzMgNK6fnfJxZwVW/8rkfhrM+cuEHQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+wyoKQyae2gLys9kesXu7sUOeCiXCjjBO42BSFObSr6EI272C
	qyJQCdfDeDZHFhQ3WsbZwVVD6XZLMR70gOf7bhE8S8zGr7kwAkIJvS5Q2xX2wxPC0LAh6bCudoj
	ujqIPTedX3iTMOqjGkjbM+xvySKs9jpN/zojrecdv
X-Gm-Gg: ATEYQzzQwKO8MykZ8KNYmRD7pgPKGSrKowbDi7h5zn90Z01vpACpqdj7Ni9ckshgM/P
	dFXxORQL/yyxVvCpzPyBpaIyxvlgVagM+/xSy2UpJ1BdqEd3ucA7USESRPt9ayjXoZChImJ9y9A
	c2vRkX9FsWQbkzoCUmRIrxuzV6YrE3nHaPkH5sxjbw1JqSOwLrNaFJCwOHAXm51k/+/OSvRf303
	okgnwavuMkMfLv7I4A1RI0ad0WP/UnYakmjLQ1a1eEBcSMJIQXmXMXCafp3AYJWzH67r3iPOTVn
	98IdZg==
X-Received: by 2002:ac8:7f90:0:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-50bb3d40d81mr10448451cf.7.1774727119188; Sat, 28 Mar 2026
 12:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
In-Reply-To: <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:45:08 -0700
X-Gm-Features: AQROBzBe7wmE_LywvyOSjvh0vtGoVDqrkmnr6QHNpG3Sc1BM2A4FO5RBot8Ad3s
Message-ID: <CAJuCfpGDWLtUHpXLyB7UA9wva9q7RjG7coOiFaL-Os_x8BNr-g@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
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
X-Rspam-User: 
X-Stat-Signature: a4acramcs3q16oxc7hcay6fnyiqocaf7
X-Rspamd-Queue-Id: C6635140009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774727120-543719
X-HE-Meta: U2FsdGVkX19pqvv4KZi5YCDCaHeLL7ot14EwT0oHCSP3vibtfESzWzhAvvlXi0F90x7uffyn9AjEBtukzLCfMk0JHyv9YaM51wwTWkg8MNV6bgSQPcRMykFrU5zGnqFRrMPEspeWcJagE1f0SarYDz5D1P+SN4DJSD1K2376C1SXxyAU0reZ18CKIMAYYOJSakVH3DD8U9bu31ncEM5Qt2ROu2L0q1G2RyZEO4oMVQ3sjlS0knp6mSF2Bc9itPyK/nrdYz8xyZp5DBZ6s8ood0NYINNyEaB1WTxQJpxNQ4E0uc5YQXbduOAIGHjyKJjODcV5H3NxP1DoSjwUOG6ukylOd9ZSZDJ58d90vD98022hhDxYp3Vy1okZ7KiKDuQ2o5ZOAYhIOva3ipULi+a9EnL5Bny6Bf8+oO4DSD/O8FxzJ8Mu+d883+t/oal/WPLmOLYnK8jBp8IeyMMCITeqBmPas6Sq6s3GKQwoGd1kbIyNT+d9oG0UMY7/o3WBk4/62NyYxPghy1h6bo34aj8TRsA5ethKJCoFxOgclzaiHr1nI8G61fCrLij090sBkdtqlDk8ehSKyKppEth0ofmkf49C/Lybytw13Y2iuuh0gGa+XLgi/1iCfS5UOmXoUKlV8gvDYOvYvrTy7hZlvhKcdx9FBb92bkYAqwmBoxV+6qWPTxeLMDo8L3RGaQnzFCw3WDmJiVZeqKT/A+JnscFn/hBXGMJMjcoRDmUlpoUjrcfgzI7AWB/ji/fxkU6TdTAbvDklynT8qK3z0rJysRJWRiMZUD8TSRG/yubumk1sBjYKggcPH6pdcSjd6qTZJanFtJosQbTyyWifUZOwmLOmUHxVQRAW9ixHGEam3K2qQiiwq4c6vPZ4WNwpi9hawXK6T7oTX4stXpDPSyOgQJM7bxxLGy95ecfa1wngVprxEkAvWHY6AFHl++Xd9144U01hWCQ0dyJTsD10buuXQ0b
 xOOBDBLS
 nFLsh8ucerfY02S7pxzXyVoCZcdr9THmRSk4hvqi1xIzv9JksD7a3JwvvjJWwBN5aQj2P+jP9JvatJAIkY+jpQkAByFhAwvJQUizK+1bN45gF5ixe2UgxXAbIrSujFURZCOhZkDOTN6jqvP3PxalxGDhEA2Xan7oyiJfwaA5E/VwwCQa1NwJcMwG4aMXY/9rdJIOFLzhAPWHTkm4Qr7rEuqBkm8Eh2zb8t+uTo8+kHPi75w9vmqnoq7isy7/YouyqsxZxFRGBM7Fxw1/JOJXkawcowcxdZ2SVvjccDEdxf4eI3NUQhgsmRqTxuIC5RMKRo4JBPGZPY9f/tBwGQSpXpbgoV5zIS1dR3c6ZvCkexYoaaQ2xZ59yysaZ1VPxyNHJiNz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:08=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> Now we have pmd_to_softleaf_folio() available to us which also raises a
> CONFIG_DEBUG_VM warning if unexpectedly an invalid softleaf entry, we can
> now abstract folio handling altogether.
>
> vm_normal_folio() deals with the huge zero page (which is present), as we=
ll
> as PFN map/mixed map mappings in both cases returning NULL.
>
> Otherwise, we try to obtain the softleaf folio.
>
> This makes the logic far easier to comprehend and has it use the standard
> vm_normal_folio_pmd() path for decoding of present entries.
>
> Finally, we have to update the flushing logic to only do so if a folio is
> established.
>
> This patch also makes the 'is_present' value more accurate - because PFN
> map, mixed map and zero huge pages are present, just not present and
> 'normal'.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

One clarifying question below but I think I know the answer, just want
to double-check.

> ---
>  mm/huge_memory.c | 47 +++++++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 28 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9ddf38d68406..5831966391bd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2342,10 +2342,6 @@ static void zap_huge_pmd_folio(struct mm_struct *m=
m, struct vm_area_struct *vma,
>                 add_mm_counter(mm, mm_counter_file(folio),
>                                -HPAGE_PMD_NR);
>
> -               /*
> -                * Use flush_needed to indicate whether the PMD entry
> -                * is present, instead of checking pmd_present() again.
> -                */
>                 if (is_present && pmd_young(pmdval) &&
>                     likely(vma_has_recency(vma)))
>                         folio_mark_accessed(folio);
> @@ -2356,6 +2352,17 @@ static void zap_huge_pmd_folio(struct mm_struct *m=
m, struct vm_area_struct *vma,
>                 folio_put(folio);
>  }
>
> +static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct =
*vma,
> +               unsigned long addr, pmd_t pmdval, bool is_present)
> +{
> +       if (is_present)
> +               return vm_normal_folio_pmd(vma, addr, pmdval);
> +
> +       if (!thp_migration_supported())
> +               WARN_ONCE(1, "Non present huge pmd without pmd migration =
enabled!");
> +       return pmd_to_softleaf_folio(pmdval);
> +}
> +
>  /**
>   * zap_huge_pmd - Zap a huge THP which is of PMD size.
>   * @tlb: The MMU gather TLB state associated with the operation.
> @@ -2390,36 +2397,20 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                                                 tlb->fullmm);
>         arch_check_zapped_pmd(vma, orig_pmd);
>         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -       if (vma_is_special_huge(vma))
> -               goto out;
> -       if (is_huge_zero_pmd(orig_pmd)) {
> -               if (!vma_is_dax(vma))
> -                       has_deposit =3D true;
> -               goto out;
> -       }
>
> -       if (pmd_present(orig_pmd)) {
> -               folio =3D pmd_folio(orig_pmd);
> -               is_present =3D true;
> -       } else if (pmd_is_valid_softleaf(orig_pmd)) {
> -               const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
> +       is_present =3D pmd_present(orig_pmd);

nit: With this you don't need to initialize is_present anymore when
you define it.

> +       folio =3D normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_pr=
esent);
> +       if (folio)
> +               zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
> +                                  &has_deposit);
> +       else if (is_huge_zero_pmd(orig_pmd))
> +               has_deposit =3D !vma_is_dax(vma);
>
> -               folio =3D softleaf_to_folio(entry);
> -               if (!thp_migration_supported())
> -                       WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
> -       } else {
> -               WARN_ON_ONCE(true);
> -               goto out;
> -       }
> -
> -       zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_dep=
osit);
> -
> -out:
>         if (has_deposit)
>                 zap_deposited_table(mm, pmd);
>
>         spin_unlock(ptl);
> -       if (is_present)
> +       if (is_present && folio)

In which case would you have a valid folio and !is_present? Is that
the softleaf case?

>                 tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
>         return true;
>  }
> --
> 2.53.0
>

