Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C6BC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DDA6B009B; Wed, 23 Sep 2026 17:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF246B009D; Wed, 23 Sep 2026 17:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADE76B009E; Wed, 23 Sep 2026 17:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 695096B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:23:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFDB8C0134
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:23:35 +0000 (UTC)
X-FDA: 85246303590.21.996DD97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1533840006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:23:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2NXnhWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790198614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFOUdSvHwil/K0FhFzOket4pw49ZzFhiG+QLBkwjfts=;
	b=v6/yLVJM0cKAixBDsGKOURz4YY0g/stClWVeYTgrfRGNTK36N3TlimiC8/jpOBdci5i3C8
	BTuJSZJ+bXsKqcPzZXiB95azeNZaszR5ON8WRoTQWUQle6hz0WJDGZveG5/cBkHLD2tnt8
	spSGFpkbhrBj3WE5HapCUsPEV06WhlM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2NXnhWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790198614;
	b=Pi9YR7D9woq3ph1Ww/NJBwD6zgldRLRYqV64F5Nzw94NwZPRHPVs3O8nWljJ2xq8Ako28S
	qC/aHO24GRSFXSRumkbj3BpKt4kgZXjiuqZBG9vRfi+mTCT+NHrD5sRjJw5MMDVvOTVf5u
	bgItuKeY2WX3hQQiZNAliweIYm2q6z0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E48143E5B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361FA1F0089A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790198613;
	bh=pFOUdSvHwil/K0FhFzOket4pw49ZzFhiG+QLBkwjfts=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l2NXnhWk5v24WehMq4tSpmYi+d5xm5L5yI8aFPMPz4HayjF3RJ4ct2hxFlSr6eGvJ
	 0Dtw3flW+pOGjBESMhPfV/DI6fLstSCno88OFAUOcih9X39nhGNIm+VpXZpUCynB5X
	 +D7okYDBr1ytqcLJCoruXi0yL6W3PylDaJ4luGmUZJF5UlIpJep2khrcvpacTDYim7
	 IT05Utcze2c06jhGz6rpyFOWDLNJd1LCpKETbFh+ZE4BggMJqtOZYAweaXhTF8C/pj
	 MBU8+1dE75n0Jan3UlAQY4zyyjUWmsOME/jxXvmE57pTuE7aDqGqKM9u4ELTtwB8wP
	 qgVVtkJxP0phQ==
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfd70b08cso134375885a.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:23:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwbyIOFV9OtKo3i8MvKvmdTeIpBKzo+9Qb1v9UkC04JGSr5M6zc5Bg7ChdyWGuCYNKtuXcYmymeiQ==@kvack.org
X-Gm-Message-State: AFuF++kZ3RbVhHGaSsVXHP3I3sPNqw3xhvcSYQkwGYjpOxmS6OgYcz55
	iarhFS75ZXV2RqimKfNot1uqdIA549S/pcq0r9b9JAXK8+nQ114buquka+H5Xkpl4gghHTbRisM
	dgLd94ghhYfC5pFJLOYxc0hAFkhOXJxc=
X-Received: by 2002:a05:620a:2a04:b0:93b:d7a1:ba0d with SMTP id
 af79cd13be357-93c346ca45amr66989285a.56.1790198612443; Wed, 23 Sep 2026
 14:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-5-jiangwen6@xiaomi.com>
In-Reply-To: <20260923062832.479455-5-jiangwen6@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 24 Sep 2026 05:23:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xiLScr2PrPu7Eem73GvPCtsuYd3J05kW3SC4QSs5Q4aQ@mail.gmail.com>
X-Gm-Features: AcwNN1U6u4upYBVse70ygcbBam77nB0znlsjMQqKiWEExUFJn-qljmWnP0sSc0Y
Message-ID: <CAGsJ_4xiLScr2PrPu7Eem73GvPCtsuYd3J05kW3SC4QSs5Q4aQ@mail.gmail.com>
Subject: Re: [PATCH v9 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 93ynomszcud163f6643hdgh1s4oiajjc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1533840006
X-HE-Tag: 1790198613-594140
X-HE-Meta: U2FsdGVkX19sON/ML+MTadvRK6LCENIEyZX/ElBZ9ZZdAxEMvqOnpGuzprO9NVvR6nPd8gAuGGs9DxB5ftlprkEWN1zbwNW2YleTgUgx2SrTSh2RQ3BMGgBhB8gUABhgrU8zi/oHReyznjaAzdEuK1wyeHgBPuAMyLLZw8tMhmhMbHipQfZzUuUyIO7ojCHO4JvXXnkS9mpCzqVIVmGJxXQOjeCdSZH6plPF0aPq3XyX6Onfko1TKTU6QH4P9w1DNoQfemqRfzemulVToljFCQ1BI1yUXFNWBv6z7yfOdCLyDpY236BufXA5qQg82vVT9lSdBbyJ/D6r6owdVV+qJ5PZ0kRTMERTwoFhpUyE6S/qaDPDVO4zeOoQAJxHXmMK3OKyJXGoHLhCVU/WGgOJstOLMGuwzLDT6MRjAzOH5SwZnlKEkCWemwoSaZcpU4PLIcT8l8Gn7FFsD0/EH0b3cUh1hy5/jZVlQJFRiPh9pxRb/16HeCQbUs1ttzlN2D6ZtAIVSLpV29jAISxk17IAXw6fRhUVrOx8t7Xo9GMCvsRp6Ml+GzSVzDPpewSnr3StNf1Rd6lDQvf/Xrs4D9qRdgeMa0sBQlzYH6qGZBeBs1UL/XO+UAooW4cVMn/MEmJsR6jwQzxoPXr+U/ZY/hlaAqoguAoQ6SIycJLgQ+oq+NT802NH/DXrUyhaFc/2FgREMv0Zs91U2yxY5Zbqe8epy7rMEGL+mIve6Biyxv+NL3XcE45rPujO59ywXgBizg/4nR/1S93AkmDbaJ5SDoXs8S+jjzh2quD/c14Ses2SvwjNkNPcO5epDq+GFM3P6e7acmG7QNZjx6qFDHeDqvlvyjrPSTyW7Em7rXWv5810BnJbi8ORLO/6kugGXu3AhdzES4IjgJ+cVl0qbSsSqYY46Nk06UMykJxUnIg9ZVnSTCtGSRzRkJrcA4QIYvP8fD/A+d0lyK7NbgAJn03Le54
 EIDbN0C7
 3S8cBgVEOTu8aAaLkYmKC/wBiboDAbr6zEfBkDFvtomZfs8EtTHIl/BShRVkvG/fVO7R/n2iNcQnUDmZCeMA4zakCeNId8vVDNO49fsGaC2xxV2CT9v/NBLlvM/I3qKNr4qB4Pgihnj4SsYToW6xkUUaxY9tAONJShskHJuLtbns8fBzuj3Q5/OxZY5a+ZaOgVX2Ly1eGo24N3kygVIBHkdHpqaNOmceIrulmAzT8QyiRfrj+enaBCy8T7aJNOgjncDYgKrfVEmKpIR87c+GjdRfNZVn1WZJD6//WrIAValvdh/eFpKLCfcjWXON2XJ7GnGjFwul0iwuiiSJSI3jBSDccINV8VHOstCCRazcv/qx+VRgLo1SxPkX8bMunDIns/FVtCMtIM0GrEP4TSrxCdN/Rq/Z6YQ9g7+aZNHbUxV0bNIvp9yy6gr/U0yKsvJlIOKT5lg1aFQWCvG/Bvw3Vx7Jq+KWIoQw/Mlu+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:29=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com=
> wrote:
>
> clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
> was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
> pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).
>
> Now that vmap uses pte_set_huge()/pte_clear_huge(), mm/vmalloc.c is no
> longer a caller of set_huge_pte_at() on arm64. The only remaining
> callers passing &init_mm are in arch/powerpc, which uses its own
> implementation. Remove the dead branch.
>
> No functional change.
>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

LGTM. Please see the comments below.

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  arch/arm64/mm/hugetlbpage.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa6..ce247b06fe03d 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct *mm,
>         for (i =3D 0; i < ncontig; i++, addr +=3D pgsize, ptep++)
>                 __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
>
> -       if (mm =3D=3D &init_mm)
> -               flush_tlb_kernel_range(saddr, addr);
> -       else
> -               __flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF=
_NOWALKCACHE);
> +       __flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKC=
ACHE);


For the vmap case, we are not mapping over a valid mapping, so there is no
case where `pte_present()` can be true. But I guess we can strengthen the
check in patch 1 by adding a `VM_WARN_ON()` for `pte_valid()` and some
comments.

/* For vmap, there is no valid -> valid transition */
VM_WARN_ON (pte_valid(__ptep_get(ptep)));

Best Regards
Barry

