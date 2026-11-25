Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE78606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hp+ABLEg
Received: by kanga.kvack.org (Postfix)
	id 9416B6B0AE9; Wed, 25 Nov 2026 16:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F18F6B0AEB; Wed, 25 Nov 2026 16:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0186B0AEC; Wed, 25 Nov 2026 16:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60CC36B0AE9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:49:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3F7E12012E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:49:41 +0000 (UTC)
X-FDA: 85474983762.14.17216AA
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 18D721C000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:49:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hp+ABLEg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795643380;
	b=lTYpyV9HYcdJIj+KlKWqpM3xNJGRgJSkg1/0ZPWbIf6PJoeUsVGqjGB5nRh7zeeP4lAWNB
	3Kv0lbZdFR4ktveKyvJnXHRrUrAbgv3B//kBqvzBXFKVDTzwQQexlF4FAM4JkRSB5VXc3v
	rbs7ylt5BJSvcgpHy2zJiLahplPO4UU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795643380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKJKbMnJNOGoE6D91lLl+V2hqik3/+jrS4TaB+PdqrY=;
	b=cCvQNjDPnTaKyx6gWNCJdWrv/B7jpa4oJuEbUbcjfoAvcNdi9mRX8fqz5sPTvpUstRKDUU
	wjIM7bHOG7nF26MCq+Hq0qq/GdmDjfdGBDu79r5WZUosAQsPGP+nG8kV96YcSe2G4s8oLF
	KB2whLyd5srW4rxbk1zYQSJtJWYxYLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hp+ABLEg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=23ukelReVlQPxc727XgPBvL052sL8fB47EA5Oas4FGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795643374; v=1; x=1796248174;
 b=hp+ABLEg0b/bekpWtfUCIxBHwN0MXCO6S4wZ3CEVtM0Pl76ygNMlY7EUHAzlYrzSXdhHjuhb
 4NWoyD4thz9BwCAc4OXMm8Fk99uWattQ73XKtwFMfPt6uACUcM9S55ibJwWn86W8pr2N9sbHH40
 M0f27pSLk2NCK/uUl//wHKrg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 61dfde814fe69c93;
	Wed, 25 Nov 2026 21:49:34 +0000
X-Mizu-Trace-ID: 61dfde814fe69c93
X-Migadu-Flow: FLOW_OUT
Message-ID: <1b0242ef-49ad-4d7d-820e-d1e6569eacf8@linux.dev>
Date: Wed, 25 Nov 2026 21:49:34 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Frank van der Linden <fvdl@google.com>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jiri Bohac <jbohac@suse.cz>,
 kexec@lists.infradead.org
References: <20261125155108.24098-1-ekffu200098@gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261125155108.24098-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18D721C000F
X-Stat-Signature: acsxpgqsta8ahsjf7ucmh1myykbc1iaf
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795643377-427184
X-HE-Meta: U2FsdGVkX19cb3A9NwgVrEWAl0Cl0LbuB34fe8kAc+MCO1u1S+F0hStQD16ZDolMxoXPOlAsGyM9luYNq9KZBLKxqsTIfSM9Cb0bXTYa2Eo9g9xIe8oRCzSCNA7imIScnmS59rEu5+d0995ei5aSWXHzDXdlUAHjnkSDY6RHMQJ/1ihd/xhY9ocociSRDoiAVTNjTuWBgwaV8NMccNk6+haSDL1G+8frsLhjR+K829gCXsgh0l4jNqwNiZPj+oXdz3qN51i0H65Bv1g08UMNrOyozAsl39OKvLpEH5MNHWTv04cmHJbqBD+8nSsIJ7sAZAO6WgZDwsauq9zMOXFyLV65BOWUeIDAOAfnCS7NLzzzgxKc4jiRm8IO1bxhMgw/OoxnizJ4Wp6/6Q46kBvOE2rKTLh7bXazqLFel9zFYtYuYW0O0qi6HadzBMYX2WdeaaJ879oz2Po3ily4qY6YBLB1Sad52jg0XqbyqE8ltkUdDLN4sItkVWxdbMnfdIy9We5ubIX4RhlMx/vqonfPvewHw7VLgSZ29wShHFIMLDmW/Qm2+Hc05U/wozke6eZosDRYVRkdnhyq+0Q1Uvx7XfjrKld0gb4U1QBxVvSkak2+WiSCwEz0MzR68BFq+NGw2L1+6uwqCVjVDpqDXwunAFMqlsBNdpoGFGMr2R51zGLcal4pRMnZSDFb/qiphGw0xSy5pvOZgzp/iG309DMGSbBkM1LG3WO8uAOY46U2OSF4iNbEGXHByY8UnTE9U/+iGZwr0AVg6GC4N7hVclwuckApIoSL0+iJli3xOgFn3bVN+Q63lh999iZIwOTtFF8hwoERbgNVRt4+3dFpiUBuDaBRpqJv+zVy8o7hrX8ROZbF1v0mtm0XbZDoA2Rg45xZcm2D36aySGFU7cT0WqNorHlNf1AzNK883a5jIzFH2IBJUrR+buxZ5NnVtNzsDr4g7/IPqFTcDaCFw59DPJb
 zkfaGRI1
 FfMbYYAUakNEQJoIGu8Af+mML0UNWFyecPygTWawKbLid0OnnNA6q3wq203V/YysgXfwKdDTv8UitR/d8v76qkrqY8deowxQVRaciy5cmJiwmBdU1uegfNQGNAp/QKigK3UfzwCQZ/7uORXZzD4H21XBzU206c1maB8VkxFNvZFcv5zaxrOSeLVFu7r2YHfSc0zvzRA6xPblDRm754U0NCoJbyV3SQUi6oVMOp8D+8gKB1SP/Qhos8Qaiw8MrdFewdzXkQh+kcR8X0pwM9NWEuFxMMSS4HQ2rd2B43lkpKSOmaGw6EU6XZLcXobzZiWyan1YjUQlCLY721LkaP1/BPA5eEuCLdc8cjL0VBbJ7sE7pFqmlbZ+szHV/GZbd+r+eUgYOG21h5Ate7koQO9IlYcGrLqRxpurL83bjfmqLvfNxf9i81+MTBNviCjr1IhqwsMORkq40M88TP8C6lxaJMuF3I11A995WwsmJdZb2LYO3+9zDyM3PnV75ViWN17ZG67WIx0WS99jaljwT13d+KR1a+PZzENreWBmZJ6Ze31t2YrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 25/11/2026 07:51, Sang-Heon Jeon wrote:
> crashkernel=size,cma uses existing hugetlb_cma memory, so
> crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
> from hugetlb_cma can be long-term pinned without being migrated.
> 
> After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
> but a device can still write to a long-term pinned folio.
> 
> So reject long-term pins of HugeTLB folios overlapping
> crashk_cma_ranges[].
> 

Is spending the workload to protect the dump the right way round for this
option?  kdump.rst describes it as

	This reservation method is intended for systems that can't afford to
	sacrifice enough memory for standard crashkernel reservation and where
	less reliable and possibly incomplete kdump is preferable to no kdump at
	all.

so the dump is the part the admin has already agreed to give up.

> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> The above scenario is only possible with the two patches below applied.
> Currently only linux-next, which is targeting v7.5, has both of them.
> 
>   "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)
>   "mm: gup: allow long-term pins of CMA-allocated HugeTLB folios" (mm-unstable)
> ---
>  mm/cma.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 0c97aadcfea4..cb4a92e2b9f5 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -32,6 +32,8 @@
>  #include <linux/hugetlb.h>
>  #include <trace/events/cma.h>
>  #include <linux/page-isolation.h>
> +#include <linux/crash_reserve.h>
> +#include <linux/range.h>
>  
>  #include "internal.h"
>  #include "cma.h"
> @@ -42,12 +44,33 @@ unsigned int cma_area_count;
>  
>  bool cma_folio_is_longterm_pinnable(struct folio *folio)
>  {
> +	struct range r;
> +	int i;
> +
>  	/*
>  	 * Explicitly allocated CMA folios own their CMA memory and can be
>  	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
>  	 * For now, only HugeTLB tracks these allocations with a folio flag.
>  	 */
> -	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
> +	if (!folio_test_hugetlb(folio) || !folio_test_hugetlb_cma(folio))
> +		return false;
> +
> +	/*
> +	 * The crash kernel uses the memory in crashk_cma_ranges[], but a
> +	 * device can still write to a long-term pinned folio after a crash.
> +	 */
> +	if (!crashk_cma_cnt)
> +		return true;
> +
> +	r.start = PFN_PHYS(folio_pfn(folio));
> +	r.end = r.start + folio_size(folio) - 1;
> +
> +	for (i = 0; i < crashk_cma_cnt; i++) {
> +		if (range_overlaps(&crashk_cma_ranges[i], &r))
> +			return false;
> +	}
> +
> +	return true;
>  }
>  
>  phys_addr_t cma_get_base(const struct cma *cma)
> 
> base-commit: a036649714c3446abfdc36d0ae483046432b16c5


