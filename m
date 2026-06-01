Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31254CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966AC6B0369; Mon,  1 Jun 2026 08:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916F26B036B; Mon,  1 Jun 2026 08:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805ED6B036C; Mon,  1 Jun 2026 08:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6816E6B0369
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:15:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDAFAC2390
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:15:35 +0000 (UTC)
X-FDA: 84831239430.15.599B9FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5EA564000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:15:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F55OsVzb;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXkAepVa1/erCLfvymJS4sclZ5BQh2ct7L6wEI3zzIk=;
	b=q4hBX1iJhQRy4xbRm5jhqYEr9IQ4pJ/XOz1y7oZMgsSoLDNyCBOtWTHOFYMlh17Yc0Sxgm
	zXIuG+NP/q/QCR1SPt+n0/SKOH2sZqfzNjSUZ6J6sFOyeXnfSlLL9dOgdDFtZal7YQ8Lcm
	cJwMwXlEs85G27KJOitj977+5Fkf60o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F55OsVzb;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316134; a=rsa-sha256;
	cv=none;
	b=mX2quOiHWldBOwrCj6vdu5of4uc267n8nCazW7609TKhXZwVeih38BY6PDkT0K7Ti0KROj
	so+GuNIgZMbzkiJbqfEwoUm1wLdOnoRcenZA4nAO4R0VWwZAj6yoAQK5Lg12n4z8z0Z2r4
	qhFWK7pXR1m8rNiQV9RH70atsxJWTLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE0B76001A;
	Mon,  1 Jun 2026 12:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765E51F00898;
	Mon,  1 Jun 2026 12:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316133;
	bh=FXkAepVa1/erCLfvymJS4sclZ5BQh2ct7L6wEI3zzIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F55OsVzbB+sqFBKP7J+BrH1GvFPebPOdbR2Xge/GQqrDhiq6nT70vQBscS1ZeIMds
	 OedYpOxhrTriQ6Tjk7mkgfoCInabP2ZllSulKNe+yA3uTlHp61tqzBjp/aadhkwyyX
	 J1/wIuso3mvLmLHBEwRC7IwIo/89O/EqeNGzUnKZxQHeEDUUqy9SFEDIuHahiTIuSD
	 qAPyRTQgC/4jaAbr3H7z6jRj/qMPq74wdf7QngCRn32RJhLSiGrQTt1942aMoBCWAj
	 4iTQT+0UwzHKLgw2n8z8ksTOBU6RH9RiJCID2DipMbOv96pYXwm0yBL2l15LnO4tht
	 889wlCgfQX9ew==
Date: Mon, 1 Jun 2026 13:15:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <ah13yAwIl7vfHGjC@lucifer>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528075507.1821939-1-agordeev@linux.ibm.com>
X-Stat-Signature: 6prfnndiwui836fx6det3a564aujet6t
X-Rspamd-Queue-Id: 5EA564000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780316134-909863
X-HE-Meta: U2FsdGVkX18zcOV11SEeSYULoLFJ5hOSgimgbPFoClwRu3TVIgVArg295g3fpd7a3RS/O+tuMrfM75j92nHu83XEqhemGZQLrUapv9BwcHvlpaGQfQ4a/qsiFOmynjhsLUTGBbWZIJSgwyG8roeHEsDk6NBwIILhM9RhxzKAVEO8uLrpoG6+RXAq8Jm89KLhb11hgQYk+wnM3Nqj+8PH7CxRTeR9cRuEI4z8rIR8Ty99pH1bcoKpGbbh6JV8EhzsNV09HjtlQ+p4E0LG2UmhxhFvqpJQrP0Gx/f0NASk5w6Fkx3NT8D3kL8WqGxbJ/T36Yb/wCufAr0tv3WZJ6TJCS+BVP4F4UIWtpGKbPD40yR+Iqv/HvwUnEYte9aZS6IF1d87W8LOQI8bqyVMYtzjt1e23XLvok0vGoB/t2UMq1hYJAxPoFLS18NtlEnqRxlTnasaDinEg6X//LA76aZFBzM2TKpik9N3OTUVWY4QHbilkszzTX0UQc/lqYAlSureE3ovcY4KEAttPTmp2/njWac2DllTOqmlv5mEuQGFt9+Zypvd2EKO0ARZfSaHM+7885Ct4amAnpdgXWyspmiMvn8UokLDDME2PuFgcrViwIN3WklKJ3JR6KMN5MriKxv0uAUhOURoBrpThZx2OIcDda+Yf1CEL5PfjEjE91YpINthNWOgDyZ2Tyo9TwZGAcLiUzScN1g62pzvSM6LV7JOjxoapXX5oHfKpQL2VnsJsi8+MD6KXtTZEqS3irxdVSvxVOEhSRF+aRAuoqDLdB4JldjrMiNCb5097IJiZu5NkNlvGsiSfzVPiEzprpSjr3PtXUnEIQYr3eIvirmv3nQ61VrNBSvKpKqlM0sFjeMGHSl0g51HWbL6Qe+h1MAwub9ZvFXAyJoO3saDLhSVJySDWd+DTNH8YV6NfgTowy9z2JecnlzRVjuDQb1UgBJBCgRNPUt7cuTqW7zy1VJkVbl
 oJQcW+dG
 P9DhgHL0c7IP33jVOgdOKCm7isUFRN2HFGfxm5HN1bBDAMGYaBPIAm7IUj9apMQ9FPD1gxeLILBjGerdiCojQbJKddwpgZKdSawqYRPfyUYGnbcmPg6NQ5WFrISQ+IVYT58gcqmlJGRC6oQqJtOMlX21XQnc2bw7tIb85Ndrvpkwk2hbHXYGHnJYsCQHRdV9myZjQGFjqca6qMfHDYLWXqsFC/liKsj3RYLQIlGySkCOUrnuryVD0bnQYTdrVJoW1UVmXSkx0x0Dt2ESYBq6Q3CGWUkYxtqt2FJf+eLfrIpbICN5XPTyqk1UBjQL44LnKMoroCUhHWHOGRrfCSyF41hWm8HRxDkQPI+JyUaghi6Ha6eE0x5lo7ADVZW7besOLLxQTg4vPcttgtssxp0Q1xS/AYg6Yu2A+Vyg8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
> Switch from ptep_get() to ptep_get_lockless() accessor for
> PTE reads when no lock is taken.
>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>

Oh and the logic looks good so with the commit message updated, feel free to
add:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/page_vma_mapped.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..2ccbabfb2cc1 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>  	if (!pvmw->pte)
>  		return false;
>
> -	ptent = ptep_get(pvmw->pte);
> +	ptent = ptep_get_lockless(pvmw->pte);
>
>  	if (pte_none(ptent)) {
>  		return false;
> @@ -183,6 +183,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long end;
>  	spinlock_t *ptl;
> +	pte_t pteval;
>  	pgd_t *pgd;
>  	p4d_t *p4d;
>  	pud_t *pud;
> @@ -310,7 +311,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +			if (!pvmw->ptl)
> +				pteval = ptep_get_lockless(pvmw->pte);
> +			else
> +				pteval = ptep_get(pvmw->pte);
> +		} while (pte_none(pteval));
>
>  		if (!pvmw->ptl) {
>  			spin_lock(ptl);
> --
> 2.51.0
>

