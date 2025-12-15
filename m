Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D379D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CE36B0026; Mon, 15 Dec 2025 06:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCA86B0027; Mon, 15 Dec 2025 06:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2376B0028; Mon, 15 Dec 2025 06:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC256B0026
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:52:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30352160179
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:52:57 +0000 (UTC)
X-FDA: 84221543994.18.CE098E7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 14D2A2000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:52:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQzFIe1u;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cQYxfBPRJcF5S1TMSPza6K50zYaV10A2qSGRFJubCc=;
	b=UvFRS5hAfxOLiKCmYgTBrtRFx9at6FZMyioEoQOaPY5/b4v0btProFN5pHb8Oh0cJF24vb
	5gj+3MsJDype7NAo8sgAxWPTpUtoPPv3mg/iB6l6qj8MftLz6n3BWHNY2+jqtXR7I66hzF
	YpD2AfhBOUp0/jVf6VpB7xL1DN/LPNs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQzFIe1u;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799575; a=rsa-sha256;
	cv=none;
	b=KlpMvSlK1n2Pkpv4Sh2MdTJCe3ueCEsgwEU7rWnBM7a3ecZ5oPRdeKuy/XsiVp3e+2mRC8
	c2h9MpkfQ9XxWzRgX5jr1MGPMsL+i+yan83rzLsLI7uwxXUCiu+Zn5HCZRi75FIP5Zi1Jo
	kx5K7Mbb5LviyrQSQxAB0/15/GXfmPs=
Message-ID: <d03d6ea7-68fe-4eb5-aa28-1020f3382f4d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765799572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cQYxfBPRJcF5S1TMSPza6K50zYaV10A2qSGRFJubCc=;
	b=MQzFIe1uEhAs57vDWRBRX1GyH5711PK2mxahYZ+t5MSG54KCBwhdNQhem42uhVt9xB5Noc
	s5PAktEasWnBuqvRPkNW/2DV1FgsSBiaAGXtraF70nnoQWGDNwI3AIRFVsNrTROaEwoYmm
	TZGuRHnUXM9qUJUeEvL2QaiLNDT6wa4=
Date: Mon, 15 Dec 2025 19:52:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: ziy@nvidia.com, npache@redhat.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, david@kernel.org
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251215090419.174418-3-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14D2A2000D
X-Stat-Signature: sx7zxei3fpkmdasa7wqkzczwjf6w79k4
X-Rspam-User: 
X-HE-Tag: 1765799574-56427
X-HE-Meta: U2FsdGVkX18qpUzf6gsBfO0U+J26joWyZTL1qtWmt3yAY6EzD98tPLpZQCwaJW4mcnmLYfpBzcAuqUMx/7XUflY+/EievJQoR1PQhvKv394cFYExYcEvHePPYrlwmlMxxahDLLQbahTL+1JAhVjSt/Nlo+nAYZTrjrJCZyFdEyLpOuoXtZjEdmfQAJ6nU8q0Mhu+OJCAsjxkdpAgMm8w3ycr6+DjsduPxhm0TJ0jx6MWgTwejiNinjXWIC/Iji/CUuVNjjKRoRTnCV2rEe++7rw+VAPNS5vWkVcx2eydzlvXHVVx/720n+M14hYUvUL3aUQkIOiYVFFsYK31YWLuVrcxGACenbUrm51KdaMcRBzIrduFtqcWVdMb7yLgvDKXE8b4gPDv08XH4HDCMP1cGNyaysgh+7pLBqW8A6oByZIZ7dFxMUoVhoYcfEFKAd+PHG1QLT24kE2ozSIhX9/cVF0SmPWqeZqKaPO6uFcelK4eTo4TZ8nW9a3TmxGf2JhxT//mWve+43GAVMgtzD7jGCSu7uzExI7k+YLhkS2v3/n0rT0anmmD6HNdQItbN6V9MOwwpRa0w11/GFMZmYbn7z+Fn3KRJgFHhwGwd7SEjloCfbZyk0sb9HuawMdrfQUwzndrrqPc3CN+eSBrvBMaXffxwjQlYiKu41rkqVcUWAq+2RMEjYFju7zVNEeHCyCkHKNYbTjP1zLLdfaz3elZqA4HFDiYLwMSZ7q+ZISFkom0nld2TSP4xT2F9FIkAEYU5e86/IhRdHV6bmuD6y0HAp3kVi7UIoWM32h2b+4t0nwwCQTb6KdgeCcPD/qcaJqEOAdfzO+DpM/iCc3QhWxoVKCqmoZmSal0+i4gzPEVsWp3lSw5R+K5kykrFFd3YD1NCZjBAbyM+wdIfRwitO8xD9tQu8ltoaflTpXVYp8FrQgSPAw5ufCFb8Eghe/M98qP8KqdbS/g1S6zWz3Qr+l
 64xSwrjd
 ySZdS7sgvtxRkgjmrmDod6Lh8dFQvBmWTiUrgqDVvaKInzVfC1YPvsNNQpzaPiz5Xk/1OBDpINoKwxnZzrfD7UAyEdLLHiiFFs3kOZ2oUpyOwKeBkahqyjY0CXsbfUEbZqpW5tEdp1XJ6ygDw/EUqHUNCeZ+wIfzcxKYdzoDw5XShQRLHTgwnc2X5SpNJ4uhMXT2F6bmlV9Bbx0DtvI0phGaDI0UjaBjEA/HeJ5xOAAF1TKQ6RksH5uXObw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vernon,

Thanks for the patches!

On 2025/12/15 17:04, Vernon Yang wrote:
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> khugepaged.
> 
> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> total progress size: 701 MB
> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> 
> The khugepaged_scan list save all task that support collapse into hugepage,
> as long as the take is not destroyed, khugepaged will not remove it from

Nit: s/take/task/

> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
> 
> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> list. If the page fault or MADV_HUGEPAGE again, it is added back to
> khugepaged.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
>   1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 0598a19a98cc..1ec1af5be3c8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -115,6 +115,7 @@ struct khugepaged_scan {
>   	struct list_head mm_head;
>   	struct mm_slot *mm_slot;
>   	unsigned long address;
> +	bool maybe_collapse;

At a quick glance, the name of "maybe_collapse" is a bit ambiguous ...

Perhaps "scan_needed" or "collapse_possible" would be clearer to
indicate that the mm should be kept in the scan list?


>   };
>   
>   static struct khugepaged_scan khugepaged_scan = {
> @@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	return result;
>   }
>   
> -static void collect_mm_slot(struct mm_slot *slot)
> +static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
>   {
>   	struct mm_struct *mm = slot->mm;
>   
>   	lockdep_assert_held(&khugepaged_mm_lock);
>   
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
>   		/* free mm_slot */
>   		hash_del(&slot->hash);
>   		list_del(&slot->mm_node);
>   
> -		/*
> -		 * Not strictly needed because the mm exited already.
> -		 *
> -		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> -		 */
> +		if (!maybe_collapse)
> +			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>   
>   		/* khugepaged_mm_lock actually not necessary for the below */
>   		mm_slot_free(mm_slot_cache, slot);
> @@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   				     struct mm_slot, mm_node);
>   		khugepaged_scan.address = 0;
>   		khugepaged_scan.mm_slot = slot;
> +		khugepaged_scan.maybe_collapse = false;
>   	}
>   	spin_unlock(&khugepaged_mm_lock);
>   
> @@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   					khugepaged_scan.address, &mmap_locked, cc);
>   			}
>   
> -			if (*result == SCAN_SUCCEED)
> +			switch (*result) {
> +			case SCAN_PMD_NULL:
> +			case SCAN_PMD_NONE:
> +			case SCAN_PMD_MAPPED:
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
> +				break;
> +			case SCAN_SUCCEED:
>   				++khugepaged_pages_collapsed;
> +				fallthrough;
> +			default:
> +				khugepaged_scan.maybe_collapse = true;
> +			}
>   
>   			/* move to next address */
>   			khugepaged_scan.address += HPAGE_PMD_SIZE;
> @@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	 * if we scanned all vmas of this mm.
>   	 */
>   	if (hpage_collapse_test_exit(mm) || !vma) {
> +		bool maybe_collapse = khugepaged_scan.maybe_collapse;
> +
> +		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
> +			maybe_collapse = true;
> +
>   		/*
>   		 * Make sure that if mm_users is reaching zero while
>   		 * khugepaged runs here, khugepaged_exit will find
> @@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>   			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>   			khugepaged_scan.address = 0;
> +			khugepaged_scan.maybe_collapse = false;
>   		} else {
>   			khugepaged_scan.mm_slot = NULL;
>   			khugepaged_full_scans++;
>   		}
>   
> -		collect_mm_slot(slot);
> +		collect_mm_slot(slot, maybe_collapse);
>   	}
>   
>   	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> @@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
>   	slot = khugepaged_scan.mm_slot;
>   	khugepaged_scan.mm_slot = NULL;
>   	if (slot)
> -		collect_mm_slot(slot);
> +		collect_mm_slot(slot, true);
>   	spin_unlock(&khugepaged_mm_lock);
>   	return 0;
>   }


