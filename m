Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29309CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 13:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699688E0010; Fri, 10 Oct 2025 09:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6238B8E0003; Fri, 10 Oct 2025 09:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB1F8E0010; Fri, 10 Oct 2025 09:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 363CB8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:55:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2D56140338
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:55:53 +0000 (UTC)
X-FDA: 83982352986.06.FB932F1
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id E2CC080015
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:55:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xI5Zj1LN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760104552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WezYJv/TQcaWcgp9xK9sF6BvbI2Dj8h1xqPvqxsmVPk=;
	b=74PSZFP8OscPyfAQvyV2P03d60WDopy8HEm1VJeQOFGYpq3aD4pAsd1HlpoTcAVKoxWrCx
	7koPSndlKpn7SEDaezY9eml9eaTn8zFwOKc/eqtXaNEv41msn5unPEPW5b/8pc9msu3ytC
	rganh3iBxQMJyHrj5o8l2pkO3TozglY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760104552; a=rsa-sha256;
	cv=none;
	b=VtItOl/coGC7yAxJaV2bMLSERoDhExMBcX8UgjnQ5xus8DYjWUD1dye+/+FJa24CFGFb7j
	lS0Q8BOtXQgUCH6jGaIKOCfW9KQLOR7iuhLxkusBvpXcw2NW0gsLmxBQXg6e9zk8yNu6Vr
	vjBh3p4J+GbPPP0GIU/oyuI/VijkOhI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xI5Zj1LN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <ed89aa31-a70a-4ad4-aa20-2e130b1e9975@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760104549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WezYJv/TQcaWcgp9xK9sF6BvbI2Dj8h1xqPvqxsmVPk=;
	b=xI5Zj1LNgN/99YsxuLbpMaw39XGggpmkiJVWP2Vq2VBFmz5GpA3oZuwb8bCBmgi+ccwPMk
	sFciYzubaLyMi54rXx2vzFlzKFeQz48PpElY/mo2h0hqZ4G6cVmU/qSSq1B5BQtoX9e4/7
	SLENs2JF4g0Zqh94MqatcPQIZMXaMig=
Date: Fri, 10 Oct 2025 21:55:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
 <20251010132950.yx6bmvub3a46gcl3@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251010132950.yx6bmvub3a46gcl3@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E2CC080015
X-Rspamd-Server: rspam02
X-Stat-Signature: exuf554q4b76sqrrye65s9zjejeych4c
X-HE-Tag: 1760104551-973781
X-HE-Meta: U2FsdGVkX1+nq/3k2J6XWevNNjff89gQciOkB7Zlo+SlwQL/Mo0XvZBtkrP68VnjniRlWRLUDmerEgr6WD5Vpd8iTMiGdrxxsMtI2SeKUCqQjkuikAS4XDQNnnEVozN1XVPKKUcnBxEK+tkZWR7p6XL3RNcrxxddnLKOdKZ+/6dGwP9j/DmMRkdTbjCT0Kguly5/qn7rfnT5A1XRTVGqbhJbi/t65Qo6p7qpaFUXntqxgbmLKRgn86nNJvDGBIOAUjrdIwtre4ZWC1sf33LWsJpuyfvgysbCgWMmKCFHODx0GRO3j4+35jIyFhk424O1LxS1iUuIhbdbd5lGfIRQCYgci0fZmwML14aWnC3DO/olAm2XWBJkN6FB/vs4DOiHl09lwzQAEDR8WpJ20mJyt/wBeyk2J53tvOlIDu7rYqsbplQd6eoNBx9WvOrd70gMhI/Nfa+VZ4PLtdKQ1h6ZzfhOG1s4kD7w+SplsZtpRQ0U4gt8Yn4fAYceh5m0683rWRQXf1xMa8espmfeIc9So6REgp9hBFgZdaLt57xmNXm0RtcoII34a7+YI5A7v+YjRChpehL/UvDsgTWdFL2wxopFKOtCHMUiHfGl1kOpARqzXoG4oTkhvu9d1ISWOPzfM5p3NKzy3XgJ+Vt6VJL1chbUPBYpGXLU4ISUXdmAlNW09jWXKYyObD3J9hVLO6lmpIVFs/3d0v7k72IBaqQDouUJo7ne4a6DPdO6bZ5E1a/0iZBZNpQ4fLZhKhXtUqUFKKOKh6hqrt9f6Yp8e6SGKJFNwB8AdwKD9OMXyj3Zx0W1OdCW6J91eNekq7oFLv+R4+6NPfOur+VdzYd+wvT5vu/ArbPKOpnjqah6JlMBCvm1BX49qctYTVvFCGyyNCMCZDYu7g+2boKBekW5MN0LVf7M4PoTDpZFPMfC7tQSvELt+u7BBs2zWVY1WISWdeL0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/10 21:29, Wei Yang wrote:
> On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>> and __collapse_huge_page_isolate() was almost duplicated.
>>
>> This patch cleans things up by moving all the common PTE checking logic
>> into a new shared helper, thp_collapse_check_pte(). While at it, we use
>> vm_normal_folio() instead of vm_normal_page().
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
>> 1 file changed, 130 insertions(+), 113 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b5c0295c3414..7116caae1fa4 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -61,6 +61,12 @@ enum scan_result {
>> 	SCAN_PAGE_FILLED,
>> };
>>
>> +enum pte_check_result {
>> +	PTE_CHECK_SUCCEED,
>> +	PTE_CHECK_CONTINUE,
>> +	PTE_CHECK_FAIL,
>> +};
>> +
>> #define CREATE_TRACE_POINTS
>> #include <trace/events/huge_memory.h>
>>
>> @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>> 	}
>> }
>>
>> +/*
>> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
>> + * @pte:           The PTE to check
>> + * @vma:           The VMA the PTE belongs to
>> + * @addr:          The virtual address corresponding to this PTE
>> + * @foliop:        On success, used to return a pointer to the folio
>> + *                 Must be non-NULL
>> + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
>> + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
>> + * @shared:        Counter for shared pages. Must be non-NULL
>> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
>> + *                 PTE_CHECK_FAIL return. Must be non-NULL
>> + * @cc:            Collapse control settings
>> + *
>> + * Returns:
>> + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
>> + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
>> + *   PTE_CHECK_FAIL     - Abort collapse scan
>> + */
>> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
>> +		unsigned long addr, struct folio **foliop, int *none_or_zero,
>> +		int *unmapped, int *shared, int *scan_result,
>> +		struct collapse_control *cc)
>> +{
>> +	struct folio *folio = NULL;
>> +
>> +	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>> +		(*none_or_zero)++;
>> +		if (!userfaultfd_armed(vma) &&
>> +		    (!cc->is_khugepaged ||
>> +		     *none_or_zero <= khugepaged_max_ptes_none)) {
>> +			return PTE_CHECK_CONTINUE;
>> +		} else {
>> +			*scan_result = SCAN_EXCEED_NONE_PTE;
>> +			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +			return PTE_CHECK_FAIL;
>> +		}
>> +	} else if (!pte_present(pte)) {
>> +		if (!unmapped) {
>> +			*scan_result = SCAN_PTE_NON_PRESENT;
>> +			return PTE_CHECK_FAIL;
>> +		}
>> +
>> +		if (non_swap_entry(pte_to_swp_entry(pte))) {
>> +			*scan_result = SCAN_PTE_NON_PRESENT;
>> +			return PTE_CHECK_FAIL;
>> +		}
>> +
>> +		(*unmapped)++;
>> +		if (!cc->is_khugepaged ||
>> +		    *unmapped <= khugepaged_max_ptes_swap) {
>> +			/*
>> +			 * Always be strict with uffd-wp enabled swap
>> +			 * entries. Please see comment below for
>> +			 * pte_uffd_wp().
>> +			 */
>> +			if (pte_swp_uffd_wp(pte)) {
>> +				*scan_result = SCAN_PTE_UFFD_WP;
>> +				return PTE_CHECK_FAIL;
>> +			}
>> +			return PTE_CHECK_CONTINUE;
>> +		} else {
>> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
>> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>> +			return PTE_CHECK_FAIL;
>> +		}
>> +	} else if (pte_uffd_wp(pte)) {
>> +		/*
>> +		 * Don't collapse the page if any of the small PTEs are
>> +		 * armed with uffd write protection. Here we can also mark
>> +		 * the new huge pmd as write protected if any of the small
>> +		 * ones is marked but that could bring unknown userfault
>> +		 * messages that falls outside of the registered range.
>> +		 * So, just be simple.
>> +		 */
>> +		*scan_result = SCAN_PTE_UFFD_WP;
>> +		return PTE_CHECK_FAIL;
>> +	}
>> +
>> +	folio = vm_normal_folio(vma, addr, pte);
>> +	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
>> +		*scan_result = SCAN_PAGE_NULL;
>> +		return PTE_CHECK_FAIL;
>> +	}
>> +
>> +	if (!folio_test_anon(folio)) {
>> +		VM_WARN_ON_FOLIO(true, folio);
>> +		*scan_result = SCAN_PAGE_ANON;
>> +		return PTE_CHECK_FAIL;
>> +	}
>> +
>> +	/*
>> +	 * We treat a single page as shared if any part of the THP
>> +	 * is shared.
>> +	 */
>> +	if (folio_maybe_mapped_shared(folio)) {
>> +		(*shared)++;
>> +		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
>> +			*scan_result = SCAN_EXCEED_SHARED_PTE;
>> +			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>> +			return PTE_CHECK_FAIL;
>> +		}
>> +	}
>> +
>> +	*foliop = folio;
>> +
>> +	return PTE_CHECK_SUCCEED;
>> +}
>> +
> 
> This one looks much better.
> 
> While my personal feeling is this is not a complete work to merge the scanning
> logic. We still have folio_expected_ref_count() and pte_young() check present
> both in __collapse_huge_page_isolate() and huge_collapse_scan_pmd().

Yep, good catch!

There's definitely more that can be done. For now, let's keep this patch
as-is to avoid making it too complex. Let's get this one in first, and
then we can work on the next step :)


