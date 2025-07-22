Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64199C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63476B00A8; Tue, 22 Jul 2025 07:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14006B00AA; Tue, 22 Jul 2025 07:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50C06B00AB; Tue, 22 Jul 2025 07:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A61EC6B00A8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:38:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56E591A03AA
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:38:02 +0000 (UTC)
X-FDA: 83691701604.21.4D34245
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3A2640009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:38:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753184280; a=rsa-sha256;
	cv=none;
	b=ikBnOFeb1z6SZz9G5jHGDt2jo7Zsu0c1oGQ3Y3erGu1Z5SfnIssH4mGfpPl0O333n1qUC0
	nHfTmGNzXxFuuZiQV230RfK5dp2vZ71HawWk2xjVSaP4ZDIzgxPL8TIHKczzyWpnSTDvlo
	AujTowhs0V2QTyxN79nSn/R+2+TSp28=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753184280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjvIu0AiEF6PoDheUCu9bA6PNVJuFkAx1z0Y/h5wkUg=;
	b=IfDDlF3ScI0LFX8LyH3C+Nd9SXTC8KvXDTskl7p9iUBMc1IDlkXj5dlYV08I47qrzCl3kp
	z+4j6Nfns/LUXR4Lx+IlAueqH7LkpDQQRaXhZCH/zZdn84ZF5g2Dd/TVA7lm5ff2P9HPmV
	0dWFHRLLAI7b8L2X8H/XBc3MVo5dpkU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 852BF152B;
	Tue, 22 Jul 2025 04:37:54 -0700 (PDT)
Received: from [10.1.30.167] (XHFQ2J9959.cambridge.arm.com [10.1.30.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C77853F6A8;
	Tue, 22 Jul 2025 04:37:56 -0700 (PDT)
Message-ID: <ac0b2fcd-6f90-4802-be46-dc1c20d55d2e@arm.com>
Date: Tue, 22 Jul 2025 12:37:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] mm: Introduce FPB_RESPECT_WRITE for PTE batching
 infrastructure
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: david@redhat.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-5-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250718090244.21092-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3A2640009
X-Stat-Signature: fd99xuypokcfgg5sacj5xa165qyirbrt
X-HE-Tag: 1753184280-891827
X-HE-Meta: U2FsdGVkX18T1OuN+ib4yXSX6YyB6OTlQPYJNg/5WEttMUwBb4oGF6+B+CSiFyvX2WJ1VUMoy1ycKh1iDveKkxOZy/CbzTXpLrQmcRLuk7csuHPWye386VLEyMG1hXtSNI9tchmDXTVfId5ba4EDkr8FgwiHEUgSrgYkZwtD97cn16Nb4i3H+VIpK2PBSoaNcTKxqT959YiN5R77q8Lww72vtJUeXfYqXLrl3Ea+Y0hhQdPlGEbV1R4yxqOin6g89+YwOztcXxHFXVTfmUCR8wy10mYbWAQw5hMYt7ePOiOEiCHbRmV3MeFlQ0mjDNavt8t8lRS6wZpb8DVRRm+/2/eSzFQDZdtHPVygCL+EOhp0G1ZA2tTZZYS6u6Idej+DDFOIdZzNs0br+p2qenNukWdM4Z1C7YSvfY9VZYehGYoY4YIFPriLP09eKt+VyoGkgzF+rOBLZ2u2h77hLPFGcQ2OejItgmUN+7MxnxCFTHFJh7OSa/Rqz2rQWYjmu9BmxNajeuQLlHkEqvCf+6na4uAQ7UL//aR/7GfD+ab7oTLfpD3AQAv04hIPa3GCoJ5smFSyYbiGPiPp0Tpwz0f1Cxh1PyqkItN+dW+fuCgNjqAobxFsEs+imij9UlHoQTzgRynrnlOwKGJ46uZ48PzJSU88Q23nV+1J3JprjPCKWoF+ZxdflmZrYRQUdBykGTJsMrBFJ2fMRjAyMsC7AwKGt3zOIgh210Ltr1yTOkaQbBB9YMEn5wt5ceq4ez+bQJq3DzurrcZNCt6vC/EBIFkIqGVzSmdge0BpHvW9jcjA1fZ5Z426cYtEzT0NzLyY3PfS1lzcH0CprOvOy4NtUknWeC9JeGcncX2ojhrmhGXEBimqH6MglXBiibgMW9fWWyxpVqZFPtEygFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/07/2025 10:02, Dev Jain wrote:
> Patch 6 optimizes mprotect() by batch clearing the ptes, masking in the new
> protections, and batch setting the ptes. Suppose that the first pte
> of the batch is writable - with the current implementation of
> folio_pte_batch(), it is not guaranteed that the other ptes in the batch
> are already writable too, so we may incorrectly end up setting the
> writable bit on all ptes via modify_prot_commit_ptes().
> 
> Therefore, introduce FPB_RESPECT_WRITE so that all ptes in the batch
> are writable or not.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  mm/internal.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 5b0f71e5434b..28d2d5b051df 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -208,17 +208,20 @@ typedef int __bitwise fpb_t;
>  /* Compare PTEs respecting the soft-dirty bit. */
>  #define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
>  
> +/* Compare PTEs respecting the writable bit. */
> +#define FPB_RESPECT_WRITE		((__force fpb_t)BIT(2))
> +
>  /*
>   * Merge PTE write bits: if any PTE in the batch is writable, modify the
>   * PTE at @ptentp to be writable.
>   */
> -#define FPB_MERGE_WRITE			((__force fpb_t)BIT(2))
> +#define FPB_MERGE_WRITE			((__force fpb_t)BIT(3))
>  
>  /*
>   * Merge PTE young and dirty bits: if any PTE in the batch is young or dirty,
>   * modify the PTE at @ptentp to be young or dirty, respectively.
>   */
> -#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(3))
> +#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
>  
>  static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
>  {
> @@ -226,7 +229,9 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
>  		pte = pte_mkclean(pte);
>  	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
>  		pte = pte_clear_soft_dirty(pte);
> -	return pte_wrprotect(pte_mkold(pte));
> +	if (likely(!(flags & FPB_RESPECT_WRITE)))
> +		pte = pte_wrprotect(pte);
> +	return pte_mkold(pte);
>  }
>  
>  /**


