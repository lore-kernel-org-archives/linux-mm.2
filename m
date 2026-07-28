Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9F2C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED86E6B007B; Tue, 28 Jul 2026 00:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89F76B0088; Tue, 28 Jul 2026 00:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FB96B008A; Tue, 28 Jul 2026 00:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4CE56B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:57:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25A12802A5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:57:49 +0000 (UTC)
X-FDA: 85036977858.11.7B1F5B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D23F1C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:57:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NucA1gG6;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785214667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWzC1kP1Q4s87XzupO6ZEYDwhb3dQbhX7Hsnw2TeRV0=;
	b=aRMOP85QK0WW/aY47O3pMQWlaklEgzrbvphHiZf3Z+DMSP/F+5+Y6zLKLHuHHAe/9USAp9
	KdxeMVsrYs+HcgYpZXPJCzhZBfIMfcS56qLcSCepqxe7LzjU+SNB7L3x4L58TOZ+G2Mrga
	vrVH6mosZ8ZLWqQR+9rzT9O19/uz84Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785214667;
	b=3EN655jEbK/7yxlIg5ysKGENC8P8wSXhK6R+ZYQ4/9Cl0x8nIcJZU6N5xiSkQlaNIdtcs9
	Z2Q1pW8p9e2G0EB3QGRFGUetgybIWoYQebzz4VyXgWWbHf9iomrhdLU1YOzbb1AASWg80/
	4dTo2KVrXr56W1Jq8OAQ5n4dXTdmAqw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NucA1gG6;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C54C042E57;
	Tue, 28 Jul 2026 04:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C17D1F000E9;
	Tue, 28 Jul 2026 04:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785214665;
	bh=wWzC1kP1Q4s87XzupO6ZEYDwhb3dQbhX7Hsnw2TeRV0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NucA1gG6z4Gdx6bBxy0rvoWXHPunbpzp8w5TnVbrFsczDXjaGx3GATlnIQ4mVDn7V
	 UjXXxuDW/PDe/0U6SeES5csr33D1Qo4AxEB39FHxXMOA1o0UHUgGe8kQuvxnrlCSzC
	 FkJv/ExheCk8oBKoLMwvBcGXrpKKin0EYxzrABSU=
Date: Mon, 27 Jul 2026 21:57:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, pasha.tatashin@soleen.com, vega@nebusec.ai,
 zhilinz@nebusec.ai
Subject: Re: [PATCH v3 1/1] mm/page_table_check: skip special zero mappings
Message-Id: <20260727215745.7fe8e9cf6a488bb29a842af8@linux-foundation.org>
In-Reply-To: <e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai>
References: <cover.1784717203.git.zhilinz@nebusec.ai>
	<e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D23F1C0004
X-Stat-Signature: 3br47yifsp1dau9darmyy4jne9w1oq9y
X-Rspam-User: 
X-HE-Tag: 1785214666-341318
X-HE-Meta: U2FsdGVkX19iyUxLTHd2V7KQOCNOtFqtRiLWL8cuAzekX4HV0RgOfWUeii7jxoz1/GBdQCpWkGFQ7RaTZ9zCUOGETAmG92ixRcVM5NSvVYD3wwLZq/BdGx8CZvXl7ZloJAs051Go9XbsbVrGNLuwsmyIENEmns5RkkCpPIWUirbdCpc6q5zc+EJe5qS/ahD12ehJLOc0ZThHio7lsjm5xUbVNcRMtSvefKmLiuPrRdf6OtVArtC+t/Pvi/BJlwXRJbymo86tcEPtGipUPD4Lf+TfmLRV/0JvUP37QXG+f1peDA5OP3xeEZnPFjqPXO4dSh8bdSpsuwd+bUJmeJ2lTJkFfYT5GPNf3ILt6xqmmiEcfWURY3LzlBwJMKzDEdhAzCKAMkhTu1gF3NZQNy+4gJWuGyCsNBx09ZrdAIrRQ3ZUYszR+oGyKpsrSINkHPIajFdR9BSwhGCfKwr5E2JwUMFQF5qhP6r3HKelRG14A/+n3p+zY+g2wPsViCYt6Q3qW0dA6Ew793JbR0ZRY0MeRPwQDaYq1L3bVSiwJks16X7Tw5arOQE6ZZ8E+l9FQjwS9j2CxzEfa7/eSVOK8sNQD8WFu26LG4ZRf08K9YGPXpp91be0ka8wuVIdZq2rM5fSB3rsU1RTGxtlMPMYjBq36uUuN7yt10k0/tcosNcei5PtWvxAdeZOWq7OTmfRAnMPF7zTDXho3sMrbqJ9JboLaP5kSBb9kc2GNPXuNMEBSRJ3zYDbVjVU8Z6FAR2wgQ6uzyusISHzB2IYp7ml2vKcB1/d1d2bNKamDlByhaBoSGVSEZzcGMQFsQ+CYrc5qia5La7muk6Q+B3GeRX2b39EYLrd8O2bYpxjJ1Ye0dQxwCHLkbvSvvsyPG+qW8Vtc5goLlRBhrR42ZDaXVSOIpmIm3KpyP9A8g9sWmCOxjHPGI0adlgp2/qpiqO/tgmzSog11CZpbhLiws86kG2p/IS
 8gPAX7Qt
 InUr9WaCnwSGZoT+vGyDCdDmfpV8mhq7wxDF7xrQtjFcLS8SMOz6OpUFHRax6DKbj77jBe+QP6nZ/WwNx7wUMH6EOx0375a0ltV2Hn3A7t1pgqYf72VwoI/r7MIlaH+tl2+dQCnkZ4ALS3mlMe56ZvWNvuDf1AOSXVinbNBCCp+m7Z17bIpiDlkzGv4ls3mDKsQeDPDln6X/R0GwlvkKLxyeSlWYnycTej/FjapE8yJBH/9rETxUgrnBnDXBTunmTrjzAYARvzDFUbPvDhxndg/ryr+3iD/+OaNSTo/K84BFgDYbiXicp9y0x7gckAU0yJlKntos2CKmjeFwhgbg9Fmo4yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 00:48:13 +0800 Ren Wei <enjou1224z@gmail.com> wrote:

> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> page_table_check_set() and page_table_check_clear() account mappings
> based on PageAnon(). Shared zero-page PTEs and huge zero PMDs are
> special mappings, but page_table_check can still account them as
> file-backed pages.
> 
> An unprivileged process can populate enough zero mappings to overflow
> file_map_count and hit the existing BUG_ON(). The PTE path can do this
> with the shared zero page, and the PMD path can do the same with huge
> zero mappings.
> 
> Skip special zero mappings in the user page-table accounting paths.
> Keep the PTE-side pte_special() check, and identify huge zero PMDs from
> the mapped folio instead of pmd_special(). That covers architectures
> where pmd_special() is a no-op without adding huge_zero_pfn checks to
> the generic counter helpers.
> 
> Fixes: df4e817b7108 ("mm: page table check")
> Cc: stable@vger.kernel.org

Some review of this would be helpful, please.

>
> ...
>
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -151,18 +151,29 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
>  	if (&init_mm == mm)
>  		return;
>  
> -	if (pte_user_accessible_page(mm, addr, pte))
> +	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
>  		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
>  }
>  EXPORT_SYMBOL(__page_table_check_pte_clear);
>  
> +static inline bool page_table_check_huge_zero_pmd(pmd_t pmd)
> +{
> +	unsigned long pfn = pmd_pfn(pmd);
> +
> +	if (!pfn_valid(pfn))
> +		return false;
> +
> +	return is_huge_zero_folio(page_folio(pfn_to_page(pfn)));
> +}
> +
>  void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
>  				  pmd_t pmd)
>  {
>  	if (&init_mm == mm)
>  		return;
>  
> -	if (pmd_user_accessible_page(mm, addr, pmd))
> +	if (pmd_user_accessible_page(mm, addr, pmd) &&
> +	    !page_table_check_huge_zero_pmd(pmd))
>  		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
>  }
>  EXPORT_SYMBOL(__page_table_check_pmd_clear);
> @@ -208,7 +219,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
>  
>  	for (i = 0; i < nr; i++)
>  		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
> -	if (pte_user_accessible_page(mm, addr, pte))
> +	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
>  		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
>  }
>  EXPORT_SYMBOL(__page_table_check_ptes_set);
> @@ -238,7 +249,8 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
>  
>  	for (i = 0; i < nr; i++)
>  		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
> -	if (pmd_user_accessible_page(mm, addr, pmd))
> +	if (pmd_user_accessible_page(mm, addr, pmd) &&
> +	    !page_table_check_huge_zero_pmd(pmd))
>  		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
>  }
>  EXPORT_SYMBOL(__page_table_check_pmds_set);
> -- 
> 2.43.0

