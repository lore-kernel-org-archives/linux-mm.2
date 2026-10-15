Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A27DCCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 20:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23FC6B0092; Thu, 15 Oct 2026 16:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2EA6B0095; Thu, 15 Oct 2026 16:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F6D6B0096; Thu, 15 Oct 2026 16:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8EA26B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:13:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 976D7140188
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:13:50 +0000 (UTC)
X-FDA: 85325961420.18.4F9390D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED3E714000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:13:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFBprGoa;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792095229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeu7IPs+bOeo1bu+3Qb1TsSjju14FLD65wrejrRGqiQ=;
	b=jcQe7s412Y9/Byr71+m6c8rM3o33io0C1jOdQh5HYrY3WJSuMX+EzAl+dFg1uNrabOufOT
	y4AFUW/mshG43eQZ4u/yFFraL0FXXobArViSdPZzAI50s+JqgMj2Cm0NFSnMdWa1rzKjyV
	bQx/I0oT90g+IdfDf2JK/LYRASrCPd8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFBprGoa;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792095229;
	b=AfpE0SIO6jkCrMCR+DXLl2gATO9O9xBFeVrTZuR/0ofIaN0CJQITYBtJyEDPUMGGeeqgFW
	41IUKqUJpONI1+n7JY10VZcBTytBfSmN5VJoVEUj9jo6dKOthqyO4EciMcs8rNBexAXY3a
	5LguBQf/UzBNFdZGyW8eMwUIbitlSdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4872360239;
	Thu, 15 Oct 2026 20:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4BB1F000C4;
	Thu, 15 Oct 2026 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095228;
	bh=oeu7IPs+bOeo1bu+3Qb1TsSjju14FLD65wrejrRGqiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bFBprGoarmRriOKc11aeVf8OYnVppRM1CFkjd33Eiv7bO3CB4iTshpHO3W/nl33mW
	 c1x2ipeUrJ00b274FY2h1kpGmqoQEtTXdf1jefMU3D5kXzokz0vphK6t+Lvpv5tSXx
	 rNyo49R4YycPTkZ/EuM0zMbHZqYhmqTvdHa4Rc9D5wUI5AUiGWyOgEXle3502b8XrE
	 LDRY0yguY16AI8hSdELHV6JmJPCmBhBVc9Ya6n8WNDXnS0ccoWhIwmZ6+C6KlBUpqH
	 hDoGxaHy0YwdQf7AhEZtfYksTHJ7afF9RhqWmINWY27FOrzVZh2Il6RWQPdO0o6Q+1
	 w1cIAOXO2unmw==
Date: Thu, 15 Oct 2026 21:13:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 07/10] mm/hugetlb: tolerate uffd bits set without uffd
 for PROT_NONE PTEs
Message-ID: <atEzjnc734DMvFd9@gremlin>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED3E714000E
X-Rspam-User: 
X-Stat-Signature: escjsmbtqtughbi9a4g87898w1maqjoh
X-HE-Tag: 1792095228-920191
X-HE-Meta: U2FsdGVkX18NMx8N7VIm6z7BIc1EkckvgCmdGEVgaU7dY30IbVVPpG+RcVXUJp7qXsksQ956Cr7ucx661L2E+EuqVzYxso03lSn0J01O5MKrgRH2+EfwH6V6g4tSebZr1WLlQKIChRV0s9Q2QiPJSFiimtD8dSHNJw6Ua6451esHRV4C7ZYrpNx/bBhv7Lj/y6Rg/v1kdSJ0S9uPh0hmIRNT1gAvieZ6+5DBUXad6w6cARR2kOUkzk1X3iI+2Id4VI5kkBys2qgs/NBKy0D1iTPqBaWB1oO/R5ebUO288TosrNXDhqKCyUL23O+YQacT8jwi89Y4X2hvY6yeQkYjFuqaKlcbIn6oc5QZoNBchjsrhdNttc8bF8lzv3aKt6isVPYnm0uA1QmiJHky1mSoXrpS8UVMKFCqRTDPs9Zwmm2RaTUDyn0uxMdlsQoiCDYz+GGzohgSwOpNTPJccJAwj1zGDoFT9XwZR153F1Dd1HiytSS2+NFBpdTwIHzeo4UzMtXVzMif/AsuSK7yCUaVUu8Aamm8y9Hdkk0KX38JTyHwGcLm6TN72+2r8zUvVSIpmXLtrxnX+jUSgA0lNLiEgLj4TtW/a5bH6qN3y+AQphq10w18NGz3Rt6ogJRBQsIYEq+9rDdGJmClu71Pyn8+Rc0Ah21+nv8KC5dWTfVETKzNhk+EpYEJCUlFrypFAtlWiXqPNdPvFHXDInSQD8z7oE8MXP4qLgmDv47sGH2G1irtgU1pCBBoC8R/KJEMVeLuzwowE8S900wbYtxvgAsag56GmZITczpF3Oegv8aKWjCpXOQrlgea2dGSLyQRONIAElvzhMF3JjgpkXswpuXTcLX5QXHmYJ9lTX19vMP9vtCsueqgMvFK3eJlCLFICk+NQ8JFHANGxSPqeHuBDddPDUG9/8f/T9Y6Quy1O04mXzZwIHJQbmgmDZWCEgZOpoGCEYPF+V+b5HNRlJjFijm
 DOk/GDJ8
 Zb9qv7zjmYl2MQRn9nSz0Pfn1XwJgbXwgMUv8XYq2c3fGpIci0dJxfsCWPvTwCTQlnFDsBziiWKzwW3HQvs1WKRK4SSMuNlXZgNbWvTdCP6Q0ssv17wkd3RQv0+V6JQfD56y826RrOf+rC7hEiuBz/FbsYeY3jEtklVhZL417cPehzvvFmYbsFO0dTFKc0vPGYFWmLqUv9YYaPzNg/WRpJpyoq/nuUy6IHtkTBqgEuJvwSCRf32F8i4ukW0P2HKhHjI8FVawCIRLyLOhy3XGHt7FmkjEn5akgOXXs3Erh9vRTsdXUoW3cG2qYCIgm8n+QAfPiM+6y2sOPIRU06zb+jt2Kvr6gsg1oTfiY0op0BN/vDrirjXVGUTYwSk+/zli1Sxam/AeOk3bPSag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:07:13PM +0200, David Hildenbrand (Arm) wrote:
> The whole uffd handling when a VMA is unregistered from UFFD is shaky:
> there are still some scenarios where we might have stale uffd PTE bits
> in VMAs no longer registered for UFFD, which confuses other code.
>
> Let's just tolerate that for now and simply clear the PTE bit. Add a
> TODO to really clean up any uffd leftovers when unregistering a VMA from
> userfaultfd.
>
> The handling is now more similar to what we have in handle_pte_fault().
>
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Ugh what a mess. It seems like bad code makes any edits going forward
problematic because of the labyrinth of bailing wire and chewing gum left
behind.

Anyway seems sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/hugetlb.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c3823f1958568..ba6860b9b7f4c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6127,16 +6127,20 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 * NUMA hinting), so let normal hugetlb fault handling proceed.
>  	 */
>  	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
> -	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
> +	    huge_pte_uffd(vmf.orig_pte)) {
>  		spinlock_t *ptl;
>  		pte_t pte;
>
>  		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
> -		if (!userfaultfd_rwp_async(vma))
> +		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
>  			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
>
>  		ptl = huge_pte_lock(h, mm, vmf.pte);
>  		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
> +		/*
> +		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
> +		 * are no longer registered with uffd.
> +		 */
>  		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
>  			unsigned int shift = huge_page_shift(h);
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

