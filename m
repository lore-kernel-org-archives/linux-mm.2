Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A45C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BCB6B008C; Mon, 24 Aug 2026 12:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CAD6B0092; Mon, 24 Aug 2026 12:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51F76B0095; Mon, 24 Aug 2026 12:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE1326B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:27:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 476031C02DA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:27:29 +0000 (UTC)
X-FDA: 85136693418.19.D32610F
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id D88534000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:27:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dOsKaojr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787588847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzJ6XHR7RPzxOHzPX6pqURCT2JzPNVCYkKVRR5Klcis=;
	b=1akaGOejlZ7ZvuMuzIsrvvNQ/2PejtUVNBEBi/U6TneyOSMPh5yOsc78eajhgC9S+IHHs8
	RN4oE0AX7m6TG5+xT2/XyZMPnmmhpMknALp0doLiqbVZdePTsABakLz3sozxEb9dc3GpsE
	lfqPN4NFA11pGVe6+NuVuLI0CpBo8lg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dOsKaojr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787588847;
	b=gePl4JJTJWuo0EqVQLBEGc4Brz1s/Za3F6odNhnjKtKHdbCIkC18xUOijsVbKUXidHoLqb
	9OlAeq2HgVLbUuLkebvOVerOeQGpgxLxsT9qoorrsGSc/wiHUgLu/vQQVJ9sQWLxriQxr7
	2/WzwQ3w6EyDXVWipSInhiDqws1eZsA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sprgsfzrs/7IhK9Lar1M59wV3GF+sASkTuKp0ItDHos=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787588845; v=1; x=1788193645;
 b=dOsKaojrklmYM9mbcjvaMl5yKgdNfIHXL3ALW/3JyCeMyNU83YJOZ3VtkRLOWkwI3v2WvEP+
 /1sRNGP9DSKKMvu4BedGUFEd+5z+FCLapRUBQNg0eVqyz+87pHhnW5inQYpAR+k6z2Jwk81CSOw
 M52gVHrLTvnYOwy3k0uwebdk=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2601:282:1e00:c920::a061] (2601:282:1e00:c920::a061)
	by smtp.migadu.com with ESMTPS id ba7b8166db5dd483;
	Mon, 24 Aug 2026 16:27:25 +0000
X-Mizu-Trace-ID: ba7b8166db5dd483
X-Migadu-Flow: FLOW_OUT
Message-ID: <9038f552-926b-4c4c-b023-69271f45e3d5@linux.dev>
Date: Mon, 24 Aug 2026 10:27:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
Content-Language: en-US, en-ZM
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kfeoacpnase6xqukmd834axb5ygciiwc
X-Rspamd-Queue-Id: D88534000E
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787588846-388657
X-HE-Meta: U2FsdGVkX18MXGLv2tMRTmlhHeYN9PfXkYIUfVgf61jeJE29BCSHZoUJJwChk48xp0FoRekjNNifvghpbB8H6q1kUupNAX7cIu+O1M1FffAKNDq24QycfF1r5o8GxbMHau1jNX2q3iiT/ZkusAgjEIKTaeyj6v/Mqg7Y/tTiAJbWkyxtxFJLxkEIyFVVFop82HaQmvDukkKlEIkonf6iUl4rEsIaMz4qsipxGQs9Nm0XQR9oSDEMyAt943uP2YjR6ZDMCfayApNah2u37pGH12gqz/bxdalJ7vXml17ClC6YnXaqbt226o6I4YIMOIViEirizyA7ygBeDxZMVYEN5VKfKutqEuqGYzENYnsAUpDXPyHBeA35cvrGgVQ0ffRtz8jWN1xW101aWmTOAW2ciYAX77rmLXW9+FHL7FvmIo37beF6yp69caCwzr2lYLhTNokoJsgD3BJJGw9ySVABDIomCr3mReAub9ONOBPUz0W1Dxa2B2UtvyImz9XTThXyjyzuEY5joR+ktCThbqOcKkLiMhVk9DBOT7K5PmsedpX6G/fQCvNvsyQoFx957+ElHQe0HpS++Q/FmFP6IdoqGsRJ48Shj0XtMUH48g0Q2xGhlxsedTbqZvkUFdQF0TGLhhkE1YJKUwjRKWdD0Nr+BXxv/TIP5fHG36a33hqYbu62zyAN7AC+XcVaVgJzOrjMXp410IY0XOvh8koNKXL7STwDG8gsZfUHrUtgWNSlofPOl7nJKVkKo4d047sp+t4ICdElDI2GdHRx9MFAU1l6z+uuTDT7sbPu1AOWd6TgwkCeHmatEoHvJB1FfA6tqIFnqKma9EMBXK3NY0zuV/4joT4sNM78DfbMv7MvtkeQvILLJzohSnr6A8ocyRozo+AZJnyJiYRv0+fbN0GiHy9a++bF9OxbXh6T/RoKwx2xDG5ipD36KbA7HYtUms7+kuLmkyRyW/u9c9vadpT+wf2
 GCP+U5KS
 HY9WipXLPdg3H1WOaIrMtcEyUMmTj2czG5cHaZZ++I9IUHAA2+4VDg70R9un27TplkQkdTzVJhGaLlteLLzHTDPXluARWR1dj+mmZyTwB5ruiNxBnfNO6xPJ8YDIvRQtuj/sQ3bECav2OZ2/DtFhjX7xsRWWOeGFwNT8CS0TMhefSpmXtNwx57BsvClNKWqc2HRG3FQyP5ww/Z3WcVwcIb1Ntg72uVOL2fD0TxD6/xMESHLnxxAghXZWpMcZf730KMSWbsrLt2qSzTMjD/H1yzMTxdnoU99JS5DOo/0H5f/WW2piupPIAnNXfF4V2GUfwYuvdCvl4LHPLKOFJcYG6zkMu7gJtlie5/7La
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 6:48 AM, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---

Hi Andrew, 

Can you please append the following fixup!

Thank you :) 

commit 20fa354b27d9be91e12c3c3144f6b3d8d38542f3
Author: Nico Pache (Red Hat) <nico.pache@linux.dev>
Date:   Fri Aug 21 04:27:18 2026 -0600

    fixup! mm/khugepaged: extract reference check into folio_pte_referenced() helper
    
    Drop the trivial helper kerneldoc and inline marker per review.
    
    Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8babd4c97db6..34654d1c1259 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -672,13 +672,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
-/*
- * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
- *
- * Return: true if recent access was observed through either the folio state
- * or the current PTE mapping.
- */
-static inline bool folio_pte_referenced(struct folio *folio,
+static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */


>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e26ea97381a..8babd4c97db6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> +/*
> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
> + *
> + * Return: true if recent access was observed through either the folio state
> + * or the current PTE mapping.
> + */
> +static inline bool folio_pte_referenced(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
> +{
> +	/* The folio was referenced previously ... */
> +	if (folio_test_young(folio) || folio_test_referenced(folio))
> +		return true;
> +	/* ... or the PTE mapping was recently used */
> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -810,14 +826,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (folio_test_large(folio))
>  			list_add_tail(&folio->lru, compound_pagelist);
>  next:
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
>  		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		    folio_pte_referenced(folio, vma, addr, pteval))
>  			referenced++;
>  	}
>  
> @@ -1766,14 +1776,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			goto out_unmap;
>  		}
>  
> -		/*
> -		 * If collapse was initiated by khugepaged, check that there is
> -		 * enough young pte to justify collapsing the page
> -		 */
>  		if (cc->is_khugepaged &&
> -		    (pte_young(pteval) || folio_test_young(folio) ||
> -		     folio_test_referenced(folio) ||
> -		     mmu_notifier_test_young(vma->vm_mm, addr)))
> +		    folio_pte_referenced(folio, vma, addr, pteval))
>  			referenced++;
>  	}
>  	if (cc->is_khugepaged &&
> 


