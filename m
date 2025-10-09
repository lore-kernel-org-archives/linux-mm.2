Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED30FCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A8C8E0019; Wed,  8 Oct 2025 21:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB5A8E0002; Wed,  8 Oct 2025 21:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138548E0019; Wed,  8 Oct 2025 21:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03B478E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:07:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89B768849B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:48 +0000 (UTC)
X-FDA: 83976788616.15.FED9981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3247120004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RmoNemMU;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759972067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD5cxroVw2bq0vRFFh3JOWosLq19draSMV5zCV6Bx9M=;
	b=LUeBM12gS5M80VbeuddHIca493H2N2xBOlXfAFuX5Afnh/xoLdSamb/gZ/w0d/WmcvPD6E
	iaEKzCWOMQVqqJSMr1IbtJXPxP01QJLwV6XPwL3tYUJfcIqMeZNQQLsd6yS7P+f+kyy0Xw
	iczT1I6QO1oyvub2cfEdivW09ppvQUI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RmoNemMU;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759972067; a=rsa-sha256;
	cv=none;
	b=k0KAaJRW47XTE44mk/lJ4rL69mBmepargX7SBoYoXM3rRA0l6ObxcTEau4Be6zKLUCuTfe
	nhdzHeBwpIfL4sL/HHmLdRRi+XJC/eH3bdq13zVHwqBE01CjBzFUKyVwe94W2plKtiqlkK
	bvkG7G+I9knYAXXlHFr2loGP4yxwiXw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 367E062137;
	Thu,  9 Oct 2025 01:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AC7C4CEE7;
	Thu,  9 Oct 2025 01:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759972065;
	bh=wUrk6XKY/1u2QS7MA+SbXv3W7CyWgdmZhrUV2O13MM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RmoNemMUl1sw1JOPWhVSmESnBtwY1VrPO/I9sWWI9ZARdWfoHuKCcSDnVrOkHjazk
	 z2i+CNKwtjiY+GMjqll+fCd7a2Iimzob44CQSFXocON4Qe2xHIP8L3AO0n7ZN+BP1x
	 eIQnQNCUW88YNkR19rYBD6YtlIfmvSYo0Q+FOf1M=
Date: Wed, 8 Oct 2025 18:07:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Message-Id: <20251008180744.008424134fbc29e9616899ad@linux-foundation.org>
In-Reply-To: <20251008043748.45554-4-lance.yang@linux.dev>
References: <20251008043748.45554-1-lance.yang@linux.dev>
	<20251008043748.45554-4-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3247120004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3773gb4t1e48bbequcp4pob59bmxsks3
X-HE-Tag: 1759972066-892464
X-HE-Meta: U2FsdGVkX1+h45pSHwMkO+J9/VBRAQUIFe39q92ftGgwoAx31sG+LYc1CULjbLOlwB4xqxme0gigt2prRFYJLCCMXAWhLS4XNlaY+NAttbJPa2tvNbB6VkUjkdVEajp/x8Rjac6xomthfuBtdxIzl4pqh+/kMOIpZSFijsMkFHGiygUx2oHJazRn9Au9TISiuU+rPWJDy1NXTNxoocyP9joW5a9oaDK87UyWS1LWjg278+uVB462aW5GDYWiqVQrnWl+5YXqhpUZ8uztjqDVcXu7Fo0G2wjBJUzFzcHqJATZCVRxXUVb33PZQmtVn+g1tjg5f175GookRilfcccV/EQdllyyOssunBgK8Hhj2jwz7F1pQ4BBef+vN3jTPuhDd+aYJHq9R9PW8Zx7QCc5Ju7MpLFbPCUIaiQNM0w93yG4yMUtGIvLduP+dNyTEgU2a/4uSI0webvY7j/K528hIlmN1/hI4dBvAmUF1CH8UYTWGQ13Jo/QhOZyS3/7fSZV20lRYndaipRUz6jOFVkp1Jm9tlHi6bJYCLlG1pJdKb7Q9EVaXAjCzrbVs9sn1du6Q3tVog/+muSqfqKx0JdN0QnFzvCaS5DOyc1nVSnkchtUXca4vDCHPwO2x0EYTor/3CKqL0ZN31cTOVNOPyQHdTJyUSa04/yPwHfjoHLxHYWbzbM1iPSK8ezCN9z3ftSTL0Nxfkd8nu2lTMzelx/+iAw3f4iIKJwTmmo8kb3kSVybtIgXXrnk+JNo7JhaW2u3Tj8UOgtJxVGZo0+t6PjLiMGrE9hRNyYXrjWxo5jRlb7BG9wWs5AKFgaoINr5RgS9K6Wf8348RTis+SqP3nxlO2lBwzXqXa8tTsApmj5eeEbo0Mst/9Wppjhh9ijj1yhVx6sWmBePgmS/rxfLgOeh1Oj/dKCOcL7F7A0hipAkPVKu00aJ0hAthIGxg4v8eYPbvPtmK/1TEODrqS4VqiM
 R3TgfWwK
 T1ufXF7NnY/3PvL3KDlAEwJZWtxCXGINSHLjMbnj5Po6HiqeQxVks03DF/ALyZ7uhAJvJbyuBQEPbIP7djSDlr4Pyh/fnaaB5jwDsM1b3qpJKWTSdcmUT5mRnQ6GmpcPopx2EQiDwZsHcu0deNYwpXmnMMTOa9mTBFAPVtESiPXgCc/qWGiwjvMiPkt312/pksFz+/boZCgbzLsMEbry38HlcLHxawiiV3bqs1OQwganH6PSP5k/9LWkAqrf7dNr23SRSAupXaKBeBfeb8rEY0wjod0S55dLrIzRvxJEGvVWsXoe01FjXpM/ZDFABudjttkAdodbprYDTumFv6AKPT3Ca5L8RZnA+mZgLQf+pN9DQ0NI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Oct 2025 12:37:48 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> +		if (!cc->is_khugepaged ||
> +		    *unmapped <= khugepaged_max_ptes_swap) {
> +			/*
> +			 * Always be strict with uffd-wp enabled swap
> +			 * entries. Please see comment below for
> +			 * pte_uffd_wp().
> +			 */
> +			if (pte_swp_uffd_wp(pte)) {
> +				*scan_result = SCAN_PTE_UFFD_WP;
> +				return PTE_CHECK_FAIL;
> +			}
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +			return PTE_CHECK_FAIL;
> +		}

I'm inclined to agree with checkpatch here.

WARNING: else is not generally useful after a break or return
#81: FILE: mm/khugepaged.c:574:
+			return PTE_CHECK_CONTINUE;
+		} else {

did you see this and disagree or did you forget to run checkpatch?

--- a/mm/khugepaged.c~mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
+++ a/mm/khugepaged.c
@@ -571,11 +571,10 @@ static inline int thp_collapse_check_pte
 		    (!cc->is_khugepaged ||
 		     *none_or_zero <= khugepaged_max_ptes_none)) {
 			return PTE_CHECK_CONTINUE;
-		} else {
-			*scan_result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-			return PTE_CHECK_FAIL;
 		}
+		*scan_result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		return PTE_CHECK_FAIL;
 	} else if (!pte_present(pte)) {
 		if (!unmapped) {
 			*scan_result = SCAN_PTE_NON_PRESENT;
@@ -600,11 +599,10 @@ static inline int thp_collapse_check_pte
 				return PTE_CHECK_FAIL;
 			}
 			return PTE_CHECK_CONTINUE;
-		} else {
-			*scan_result = SCAN_EXCEED_SWAP_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-			return PTE_CHECK_FAIL;
 		}
+		*scan_result = SCAN_EXCEED_SWAP_PTE;
+		count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+		return PTE_CHECK_FAIL;
 	} else if (pte_uffd_wp(pte)) {
 		/*
 		 * Don't collapse the page if any of the small PTEs are
_


