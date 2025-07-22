Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08EEC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5E56B009B; Tue, 22 Jul 2025 07:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36ECC6B00A4; Tue, 22 Jul 2025 07:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DA36B00A5; Tue, 22 Jul 2025 07:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 136656B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:25:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FE72111CF8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:25:07 +0000 (UTC)
X-FDA: 83691669054.28.4AF950A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A41340004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:25:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753183505; a=rsa-sha256;
	cv=none;
	b=BYsegA8QY9pNc4PfqzlEIViKTCdY+MygztzQ2lcdpqlQOSnE4iNbleDXdpNxFegV/3ZC0l
	klJSL0oZQgcc4gDaEQI81JDIHLy33dWM3rVhyv9hpDP1jlrWu5958UuL/LAvWlOzLJaHS9
	mxj+px3gKhwcrNARhTac8/gVOf3427s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753183505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7FmrljgJWMqEho9n3tScbu6030nDFWUZ/1cCus/DR0=;
	b=ti3ZaufCONbgKje2zAp4CLLTs439yoHMLcqWIBosLaAJ09OQ/YJutGv3bed3lZ5HBbUduE
	XA81DqXYJH50i5oAFk60bfiDysc23o2Bm7HVUA52El2KaUfqNNMQ9N8kh0pl6mEJ91mJrv
	tXU52RIWjKS7pj985jxpV7DeY0UySL4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBEB8152B;
	Tue, 22 Jul 2025 04:24:58 -0700 (PDT)
Received: from [10.1.30.167] (XHFQ2J9959.cambridge.arm.com [10.1.30.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C27A3F66E;
	Tue, 22 Jul 2025 04:25:01 -0700 (PDT)
Message-ID: <dc0b5e94-f5aa-407e-bad2-150814dc4885@arm.com>
Date: Tue, 22 Jul 2025 12:25:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/7] mm: Refactor MM_CP_PROT_NUMA skipping case into
 new function
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
 <20250718090244.21092-2-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250718090244.21092-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A41340004
X-Stat-Signature: tzs1enuto9dzhp6xjcf9r6e5e8grkriy
X-HE-Tag: 1753183505-176750
X-HE-Meta: U2FsdGVkX1+7wOqjKzm/2ZzSAJDo6k19zSGAMHty0T9J1BA+YIBMwNlXqZL1MwX5rPjkpQ3kuDGNFj2ZniXBROR6wBIJqfWERo6fVYny9TV2sz4fRLNL89keo0RewMpRygQdbIMM8fBfzeaehom3C4sn+zvG1aYM+ij1DGbKIPGi2koHR6jPRoFPXofq1fCS37okl7mBKFEPuZ+hPIfbrJRKUgO9CXHsSeIB3CfcSp3V58mcgbHdQa5jUsk7tcUu9RkbmACbzZeJbrIRj3UpwLXNwWYDalI8jAgpgWoUylHCSNe5HX+1MiWJ/tbGvkq/FR23VAT9cE2yIrwNK3k3irXMnvSAeGtXcoFAlAWb6pVr0zGNYzUtOfJyZuCAFEEhD9p268ZWFLWIaW+IDqX4LIexDwGxMGXe1JtQmA+KK/6BtKbZh7SdRF8KwnocIKU9VXAf6OWK2X1he7P4MpXj/SdEvv8cIsHcNQB+Au2piqaGRa/cxWqDCAQzQ+pgVgbTmyht7P4ZFH8vZP1XjHSW6Oi245mFgxAVvSnyvt8luH5TKolP4c1y2buhtgSoEXP39Wq3li5i2dzKtA2pPgt4K7LoDf77KcMAz1czH9DL4Bxe0/z6VV6ODgGNDRyz0dq8jKuVOEE5/Jv05CDZTCeX06b+ZgGFW1ZJRnVPgb/rYYQP68rkR6+i+3todwgqll0ZrlEc/fZ7aQLXPAaaVG3EHcHI/NGeIkv0sLfCymmmxDDPxOTmTYtj/upLaQ2qLHLxW2MylhF1FhPORUsx64VBtJP10qESNdwZ9ipukw6igoAPjWAK3mJzkKbg0Qm7N4W3E5XjeM+xTAZfCHUK/DNdKn4dCUT36GxwVCufJWJAptY31WHtFUgtQvWHKpO4AmWjpSwJ+/dQanf2IbmvcFSP18KnMcN8+lpWz2O9iAW+43PnIS4CWUlugFdh2f8vdKq3BF0QAwvfsfRZqBa0UiX
 XyoJqHpx
 3xvp/aTTooIizoTz0kGxXrwWEYXjOeRjCmJtrcwh+JbKVAET3/UcJgL5On7MADbmZFGN1J/aZ+KT4zsEpo1kysbNihHhX7fH3tJ8v0C7oshW+j2i3+XwEEf3V+Aj1Jv1c0efBYgofIzMzjFz9gaVOpHgDNfWU1Ej9e1l6n36CWq+Exyc3Q2y98yQwjkjYGlA7WkpZ729oB+vvQaj59qt9PZy2RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/07/2025 10:02, Dev Jain wrote:
> Reduce indentation by refactoring the prot_numa case into a new function.
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 101 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 88709c01177b..2a9c73bd0778 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -83,6 +83,59 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return pte_dirty(pte);
>  }
>  
> +static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> +			   pte_t oldpte, pte_t *pte, int target_node)
> +{
> +	struct folio *folio;
> +	bool toptier;
> +	int nid;
> +
> +	/* Avoid TLB flush if possible */
> +	if (pte_protnone(oldpte))
> +		return true;
> +
> +	folio = vm_normal_folio(vma, addr, oldpte);
> +	if (!folio)
> +		return true;
> +
> +	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
> +		return true;
> +
> +	/* Also skip shared copy-on-write pages */
> +	if (is_cow_mapping(vma->vm_flags) &&
> +	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
> +		return true;
> +
> +	/*
> +	 * While migration can move some dirty pages,
> +	 * it cannot move them all from MIGRATE_ASYNC
> +	 * context.
> +	 */
> +	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
> +		return true;
> +
> +	/*
> +	 * Don't mess with PTEs if page is already on the node
> +	 * a single-threaded process is running on.
> +	 */
> +	nid = folio_nid(folio);
> +	if (target_node == nid)
> +		return true;
> +
> +	toptier = node_is_toptier(nid);
> +
> +	/*
> +	 * Skip scanning top tier node if normal numa
> +	 * balancing is disabled
> +	 */
> +	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
> +		return true;
> +
> +	if (folio_use_access_time(folio))
> +		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));

Perhaps this bit should be kept in the original location? It's got nothing to do
with determining if the pte should be skipped.

Thanks,
Ryan

> +	return false;
> +}
> +
>  static long change_pte_range(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> @@ -117,53 +170,9 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
>  			if (prot_numa) {
> -				struct folio *folio;
> -				int nid;
> -				bool toptier;
> -
> -				/* Avoid TLB flush if possible */
> -				if (pte_protnone(oldpte))
> -					continue;
> -
> -				folio = vm_normal_folio(vma, addr, oldpte);
> -				if (!folio || folio_is_zone_device(folio) ||
> -				    folio_test_ksm(folio))
> -					continue;
> -
> -				/* Also skip shared copy-on-write pages */
> -				if (is_cow_mapping(vma->vm_flags) &&
> -				    (folio_maybe_dma_pinned(folio) ||
> -				     folio_maybe_mapped_shared(folio)))
> -					continue;
> -
> -				/*
> -				 * While migration can move some dirty pages,
> -				 * it cannot move them all from MIGRATE_ASYNC
> -				 * context.
> -				 */
> -				if (folio_is_file_lru(folio) &&
> -				    folio_test_dirty(folio))
> -					continue;
> -
> -				/*
> -				 * Don't mess with PTEs if page is already on the node
> -				 * a single-threaded process is running on.
> -				 */
> -				nid = folio_nid(folio);
> -				if (target_node == nid)
> -					continue;
> -				toptier = node_is_toptier(nid);
> -
> -				/*
> -				 * Skip scanning top tier node if normal numa
> -				 * balancing is disabled
> -				 */
> -				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -				    toptier)
> +				if (prot_numa_skip(vma, addr, oldpte, pte,
> +						   target_node))
>  					continue;
> -				if (folio_use_access_time(folio))
> -					folio_xchg_access_time(folio,
> -						jiffies_to_msecs(jiffies));
>  			}
>  
>  			oldpte = ptep_modify_prot_start(vma, addr, pte);


