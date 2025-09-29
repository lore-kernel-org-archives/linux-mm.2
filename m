Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9F4CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 00:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331D88E0003; Sun, 28 Sep 2025 20:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2688E0001; Sun, 28 Sep 2025 20:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8408E0003; Sun, 28 Sep 2025 20:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF9E8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 20:59:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B31BD1401FC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:58:59 +0000 (UTC)
X-FDA: 83940478398.24.1B9EDE9
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf18.hostedemail.com (Postfix) with ESMTP id D93781C0004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:58:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gu6wniZE;
	spf=pass (imf18.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORs2gycvYbnBEoguqR6oKSNFoMATmvXOvwD+L187YZo=;
	b=YnE1CLKBZqlpTuHH0g8g/04T/WlvsweIi5qFhOl8n0IGk96LUjuOv734q7Wn3T3QiIUISS
	RqsbS/mR9eILseMRg4rTyx2XlBOlLKw+8Qve9T5iGkCASRr0ApuUfp8311O2IaZmYLg+Wa
	jVu4u6DhRSCYGHfH1Pd8PIte2MiJ9Ag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107537; a=rsa-sha256;
	cv=none;
	b=QCqwbCoMOH5TNBwjFFpkK4+bHAGpc8MPqPs07I3wrun7as9O7uefmMWaBcXWjCvJGdFks4
	idxh0+SbEI+7tUhnvu+NRLHHJ/5QQgsgBBk+nggjjBC5dlUsoXfKdPWxkY6uCxRQ9q0gEb
	UgsBPq2rVo8vDWLNoiR7hVejFyL/aR0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gu6wniZE;
	spf=pass (imf18.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-279e2554b6fso32417325ad.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759107536; x=1759712336; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ORs2gycvYbnBEoguqR6oKSNFoMATmvXOvwD+L187YZo=;
        b=Gu6wniZEC5Ab1mhF7B5fK8/D/kFv/gNvfAzli/HOp3eoRnw6vGq/Vttv2ye3RMiuNK
         LxxfBlxEnWD0urxKp+RRwaJiYcv/5u+qMS19yhYnXveqjb2uW5KzYOLZWGPg4ijFfQmB
         DiYIbrQAkemFsC7ETw8+H6lDAtHwg3033JSuVy1aZL8nr6UaLM5OclKZvfq43TaAkG4a
         HeMQcCscMyA7kx51JT5SBb1QEG0wYlpNt20jIXLPn42/nXCLDaVgxMjvmPe56L9d2lhT
         /FdbjUJUr+dYraOfoJu4LSy7IPsCIi7JKHEIx5Vydal72Ob1ffkmUtLi1c3bBlLHntnI
         x9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107536; x=1759712336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ORs2gycvYbnBEoguqR6oKSNFoMATmvXOvwD+L187YZo=;
        b=Ns3E8ibkxLRtH1ytmL1pOjDFUQ+//MTU7jSUo4STIdCReQc1oQPOAHG6YnN6vUEOGh
         QAMP0qnbjVJBj/cbct+UC41c+uyEOLJGKUwmUEJIBngUn3DFbcPOfxQPTuf6Lv6NeqVy
         YwHhc8DvfdDBoGzqwfxMtUJQlnlt+i21RecJGcor5fmuvrrs9LdxSux0z6CNDQuk5Szz
         1DPixhRKDX+t8lxbc2wVg7q5fkx5Lwj3TW/43ixVodSUNo5MxpuXdeUcALWG3Iur+KIK
         Bkdg0Bxl+1Wz4jNb8vdx/rmCIIwPrAf/Ba77+MbNsiZDED6DGIZ3Ip/7O4aQSro5orJF
         ybdw==
X-Gm-Message-State: AOJu0YxseyV5l0jEwnvnDe18ViEzGYAFPs7Kpp3vjje4CVtIv61ECzQW
	qTRTY9yroJCQ7H1pnbxBqqK5VnM8pJ+ukHNG5TL2jfR4iqFhV++amj5AZVPfO4og46vvDUlfhax
	5gIegdmQsbdKaP2pAeNWINjC6peuOsVmwybUwN4VmJA==
X-Gm-Gg: ASbGnctPv/q36eOZyoG0a9Sw9GDof/CruPccE2kJrWXB2AZCodB9MP9bVwPhAv4UsrJ
	gI2jf9KQAg7mYLSU2qYhYrRJHZZNElTfwRJI98Huw+WYm+pgjg25QVPusP4tTYq7iT3Opq6LxYF
	rkhAF6Sj5zEkLhbk5xCw6p2fUC06dGdOovDh6XGruF39g30SsAblqjtVA3W5utL0BYASAY9QhRZ
	2KmKQa/foYcUELUpy97E/viEozC
X-Google-Smtp-Source: AGHT+IEdKd/2f3BIPX8+CygnGdwjwhF1+QMfyj3p0x4KG1dJssR+VKdv7FmMNZsXXawlRu74HGb/awoBUT3TBuZICKA=
X-Received: by 2002:a17:902:ecc3:b0:269:4759:904b with SMTP id
 d9443c01a7336-27ed4ade041mr179270045ad.58.1759107536398; Sun, 28 Sep 2025
 17:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250927064926.1496579-1-jianyungao89@gmail.com>
In-Reply-To: <20250927064926.1496579-1-jianyungao89@gmail.com>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Mon, 29 Sep 2025 08:58:44 +0800
X-Gm-Features: AS18NWAUhnnwQ1CHLLzDZsDFdPRBZuLB6p-5ELHUMzymLqEllF6uCWerrHJaZYU
Message-ID: <CAHP3+4B9LBqODc-YoLogQBLawzqCwBpABi0bNpQ6aNRWuDavtQ@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
To: linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D93781C0004
X-Stat-Signature: 8s6kt5zf7apj1dshbbrbte9tchxdy79p
X-Rspam-User: 
X-HE-Tag: 1759107537-273840
X-HE-Meta: U2FsdGVkX1+KUeW5VbXpbc1pe0+SkLgmDSow+uVFfvy/7/GDDTc/TAFFQ4SwlMlnfVZCHAlqPSFROR7YaXqrsiT09fiVWOusyAFG+Sg0DM9PfUE0WTSW7YbUYMAkZFav7BzYdnw3liRy2S1yj8K2TACKwY4TBSmdPd+tVX+sc1r1Z4I/RZaXNM2EYKDaBW/QzFy8IIT2tt/qUxpIWUBGxnN66KGmruZ36zYwT5TijyyBk7bIx+YNPv+yfFG1Sa+E/OrllookYgckVB/5Uk30zcf7miEUCXek+1uXe3WA+mwKYMbxVeMZUSJKgogi+A/6WhDu0YI8+eOYqJTWMGVL3G6m8oQ+qNwF8hZS9kGK+vxba3BT+4oLQCEkmD3ZqMJikigqlpmqGdM8svkzg6OOFp8Re65APDjedMFSrTKZ70SSIDWjygHImehVg3AfUu8nBMu4LJDfqu1zptS/LSu3Mtr66ZEkuJWI86ETzp9Q2L2XANYUqEb+TI/vqtyBRBwHqMetFDdl7FOlyQZwwJt48PS4KV2vTG2rQE2WaAi6mA9+dMXlMwAhyEUl8WtxMr9KV0pfInXZCo9bmmaCPZm12jQl0GGiGwwzUeyZmb4o9K64k8YPAsfupjKMMsW3wwbJa5kbMt4RxmtiU2bLxK1i8asXDEPl0dk6LIkLs6i1KoFT1XnfIf95P2+SFuY4DOhdIf1ULoyRl0ffOZwwYv0H9Md+agX6YQ6PpfoDJmau5c+wms2T+dstWnK6KGVwmzp4TxZnhESXU0nG+q8GvH/KtRi5aVequZNE9pPoOEqyCV6dc9vnNZ5zewWdDRFoHm/lwQQBdIp9otEDr6GxXwTHRs+0hLjB0wsnN8Kk3a4y78RpQxiceBUaAe2ac4e759FvIrpwdn0U8qKMSVuefpbnq1rz34FIcjydlCiLIFSFQWV+hgbHdeVcrexi90DL40BARPTiAhsApNN9FP9MwJ8
 KS+ZwsDd
 WqkQI1xUGL45AGbRncYkrWiG4CJ1f8Bx6UpCxFIhrjbvP1cVMoKwExCH/OU3Og9n65Vs6oebX+Qf82vuIsTG9O5f1W+eq9qlXPoiP90gS5WTmKJEQXyIUJn25sANQlg/0YJRp3DmncQaRCmAgiWcpWAujxM4P/6LgpfVrEc8D6p7ClcadFK1HJ6dvvSvm2WyUkk9FzMrXRUI4r9OK1djkHaNeuVXOcNEjPzrBlJ9Hds9Vw8WMSYp1YCdh6PhEpbC3eDcmdt/2IU/e+A8ZeBRw09zVkWHr+8Mc3Q6Mf+70DbWsNBam2N1FtSa2Y4RvudRf+0mxnKbnH+BYziQK1/j8WpGr4k7vu4iXLm/p8fBQcD0Z9VW8Mrl2SmJl3LlGdHxxamzuWgXvAowWmICOVh6Fp+gym9x3/29lmg4d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Superseded by: 20250929002608.1633825-1-jianyungao89@gmail.com .
Please ignore / Please drop.

Thanks,
Jianyun

On Sat, Sep 27, 2025 at 2:49=E2=80=AFPM jianyun.gao <jianyungao89@gmail.com=
> wrote:
>
> There are som typos in the code comments as follows:
>
>   differenciate =3D=3D> differentiate
>   refernece =3D=3D> reference
>   permissons =3D=3D> permissions
>   indepdenent =3D=3D> independent
>   Spliting =3D=3D> Splitting
>
> Just fix it.
>
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> ---
>  mm/hugetlb.c         | 6 +++---
>  mm/hugetlb_vmemmap.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index eed59cfb5d21..8ff9edd09504 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2954,7 +2954,7 @@ typedef enum {
>          * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
>          * that currently vma_needs_reservation() has an unwanted side
>          * effect to either use end() or commit() to complete the
> -        * transaction.  Hence it needs to differenciate from NEEDED.
> +        * transaction.  Hence it needs to differentiate from NEEDED.
>          */
>         MAP_CHG_ENFORCED =3D 2,
>  } map_chg_state;
> @@ -5998,7 +5998,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb,=
 struct vm_area_struct *vma,
>         /*
>          * If we unshared PMDs, the TLB flush was not recorded in mmu_gat=
her. We
>          * could defer the flush until now, since by holding i_mmap_rwsem=
 we
> -        * guaranteed that the last refernece would not be dropped. But w=
e must
> +        * guaranteed that the last reference would not be dropped. But w=
e must
>          * do the flushing before we return, as otherwise i_mmap_rwsem wi=
ll be
>          * dropped and the last reference to the shared PMDs page might b=
e
>          * dropped as well.
> @@ -7179,7 +7179,7 @@ long hugetlb_change_protection(struct vm_area_struc=
t *vma,
>                 } else if (unlikely(is_pte_marker(pte))) {
>                         /*
>                          * Do nothing on a poison marker; page is
> -                        * corrupted, permissons do not apply.  Here
> +                        * corrupted, permissions do not apply.  Here
>                          * pte_marker_uffd_wp()=3D=3Dtrue implies !poison
>                          * because they're mutual exclusive.
>                          */
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba0fb1b6a5a8..e6f79b2c63ee 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *h=
ead, unsigned long start,
>         if (likely(pmd_leaf(*pmd))) {
>                 /*
>                  * Higher order allocations from buddy allocator must be =
able to
> -                * be treated as indepdenent small pages (as they can be =
freed
> +                * be treated as independent small pages (as they can be =
freed
>                  * individually).
>                  */
>                 if (!PageReserved(head))
> @@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct =
hstate *h,
>                 ret =3D hugetlb_vmemmap_split_folio(h, folio);
>
>                 /*
> -                * Spliting the PMD requires allocating a page, thus lets=
 fail
> +                * Splitting the PMD requires allocating a page, thus let=
s fail
>                  * early once we encounter the first OOM. No point in ret=
rying
>                  * as it can be dynamically done on remap with the memory
>                  * we get back from the vmemmap deduplication.
> @@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct =
hstate *h,
>                 /*
>                  * Pages to be freed may have been accumulated.  If we
>                  * encounter an ENOMEM,  free what we have and try again.
> -                * This can occur in the case that both spliting fails
> +                * This can occur in the case that both splitting fails
>                  * halfway and head page allocation also failed. In this
>                  * case __hugetlb_vmemmap_optimize_folio() would free mem=
ory
>                  * allowing more vmemmap remaps to occur.
> --
> 2.34.1
>

