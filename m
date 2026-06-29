Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25F8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55DD6B008A; Mon, 29 Jun 2026 14:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E916B0092; Mon, 29 Jun 2026 14:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945A86B0093; Mon, 29 Jun 2026 14:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 623C86B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:33:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5B8CA0201
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:33:39 +0000 (UTC)
X-FDA: 84933798558.27.D36E909
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3F5DC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:33:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfsMOuqV;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782758018;
	b=GOk90k1tILKHF9xXJVWLtRlZ7wauoqryI5uGkH53o1FPUldqrcoSjd2HBTfEJFa315uU2B
	r88B9LNMV9jWnxQNHH//WuuVkBOZKAYCZEEsbm2S1BDuHyfwEMOA6gRviYvPR4LNkbFF54
	HVhdPS3aG4eAe7c1RXSiPtmdiaCBsPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782758018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIt0MX12ycDk124SAeYfFyNpLYyys/OHkSbkyqFSd78=;
	b=r14Ntvlw7N4hXXouU2tMgWyzzThXfr9+u4snLhJx1SQEAk/yES+nQQDuAqeXbh1y3238eQ
	eEubB2qxNT+0ZrqFKphtpgzAx9AKlIFQ3gyT8LWXdwRa8mttDADHfUcnUxhBM112awF1Wm
	djDqZFs3FdWwLs0eQfsrp11aRpreImI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfsMOuqV;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D694189C;
	Mon, 29 Jun 2026 18:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0D61F000E9;
	Mon, 29 Jun 2026 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782758017;
	bh=kIt0MX12ycDk124SAeYfFyNpLYyys/OHkSbkyqFSd78=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mfsMOuqVYVS9UEV1G+8hUcr0Tigrrwz1wkeQMOTs6i6G5h2N5jU+93Zs7uQJ1KRU1
	 0fL9nbfq3qm0fpsIYs1Fv949GutXWWyFhS5GZbu4n1/2OYfcYGv62dkSd52Y7wfQ4t
	 CIvt/YvXmWyaNWCeuZBiYDAB4zDWbTS6q2sgX/Abi6n9teX+qMPUNvkmNCfQIKlSJw
	 ITM9tJbMI5xUhV0XW/PTfW534cF04h5795BPrnzjsSK6EqagfYMikk+OtObnpQcDYL
	 cEPhKemQ2PH9y1vo9u/pwW7VQFyapb4ZoEarPk8I3hf05cC2sGJEVUGPd2wRB0zw7k
	 gYw4j9d8JykPA==
Message-ID: <e18f075a-2203-4ebb-8f4e-713d386d0ef3@kernel.org>
Date: Mon, 29 Jun 2026 20:33:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260629163337.1264881-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3phc8txm6jigtmrysztw7wkdx7e8xy39
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3F5DC0002
X-HE-Tag: 1782758017-932741
X-HE-Meta: U2FsdGVkX19N/4240WomaQc1SMmw+ll0xQGNgjHKi4BtS5BWt/wC/PYh6FoUvCnP/mDN4xuJMsYMyT9UM+21qie45nn8v8u1lLd4KE8a6H7COGdqFLY89+ZMdFQHP6jHyllBQkYLkDbF4cvFxWTvan/7Kd2o4JIaNUuDjrowK4VdDlPyyn6SA5VBGHFNuKtFbZBmrFZszUvADAINh3iuV7tLu0KBKW3xipFZ+bfi3TDqiZDW6mGHgLaACn9RLYx9IqRU2q+lj3LMKlie6t8X3oJaSsTXyRekVOhPyz+g+k6pUTVkyrpN/7GL36uvbGcnG0txb8BURI7TdhFIBGFo15lJXWa8kPPdfGLSRt5MzxQ+AiZzFNBcRsCyzwy0o7PiENJzMWXhNECQ+gPS4KCWe5pVfdpV39sQ951CXe8fHoW23xA5ONUcGUK8jyFNd0e2yvyUQUPukeufVqRVLLDo1LFJADIrdOaDmQTjJYwqWeegTntJ1nYNTvaf4kxZBypmuu4yFN2Wgs3AuE/NX9kkDh50UvhHrqqpHQ+ABtVvTSq3DpKRXOaUFQvqfMq93HDQut3fD3H9gjOjVzj6Rs0GtP+oe1tjcSad+GMezOB3ZsoR+Ns1Wj2ZLyjV5P08/BgZOghVTfbch1WgSnwbf7enyZw8HJWLWFR8GDJiIXhcxRY/hHj+gljaTns36sD81TQFkbqYxXWcfErvvhI5XC3nZf5nsGl4uLRrHbk/uKhkjzeR/64xy7/rx6SmDPhFKEXwKNqSi1Nnywdzh8+qomXBuEOE9PJD+i4XDF+RjDp144Wz56nDZ/zF9NQ/x81y+SucwvHfYLBY7vNg8GrLxqv+RlECcVoYluDq/gJnUmp37I7XL+Hfj0cvvTu7ND1TAxLiV2xk4n2M7RMs159ss4cJtCWE0y4i7zM57jxXXh1NPEFtccTUntbekGkYt8IgtXlFH0JB/9tD1ABD7/pXOBI
 HAmAgTPU
 wtyLiESEcp555IAQ6MvLSyQ1ThI7PejLSj1hwf4j4YVbf43+Rm++3cc4cLdYSTyun8C22Gtwhd/wcB0HGDRJv0JblX4IrSu6DNwlQ7ynNOYld1J0/7ZUsdUwTdhKuodOMJ3yA1yuBms3V7qUSehxAXxMruNg8ddMTkOYzjVMNtp0S1qgCVC1u5nslA01XhPZBpsUa08VWP0uGfPyAK0HTJve0dec/71lPgfQ7jOBKMJFgEI4vttL+K/EviB4wjERovCinLi6qoY9LJQqRYEIL6NmH1MiJXUKgDUDonXIY/jDwz9VdqhFSmEmbtJP7bT2r6HGN8dZCWjhC6G/RwDVIhlMi46Mkjw0N3PcHPNvbEpjF/KnP3STmvVMbmNFzzKOkdFotaabdSIUC4sBDij+I++tLYzsqD2PCQY9ii3mn2tgtHKSxDA922f9YY9byU8aV7Aj0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 18:33, Johannes Weiner wrote:
> Neha reports that mapped shmem aren't considered for NUMA balancing,
> noting convergence problems and bandwidth bottlenecking for cachelib
> based workloads on tiered memory systems.
> 
> Looking at the code and going through the git history, this doesn't
> actually seem intentional:
> 
> Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> motivation was a real usecase: Oracle was pinning shared segments with
> mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> 
> The handling of NULL from vm_ops->get_policy, however, treated "user
> explicitly opted out" the same as "user never specified anything." For
> VMAs whose shared policy is absent - the common case for shmem - the
> scan was disabled too.
> 
> This issue is old. It probably hurts less in conventional NUMA. But it's
> very noticable on tiered systems, where entire tmpfs workingsets can get
> stuck on lower-bandwidth memory.

Sounds bad enough to warrant CC: stable?

> 
> Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> thereby handle the fallback to task policy (-> preferred_node_policy()
> has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> already handles it this way, the scan-eligibility check was the outlier.
> 
> This preserves Mel's intended fix: don't scan stuff the user explicitly
> pinned. But allow default policy vmas to participate in balancing.
> 
> Reported-by: Neha Gholkar <nehagholkar@gmail.com>
> Tested-by: Neha Gholkar <nehagholkar@gmail.com>
> Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")



> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/mempolicy.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c2..bba65898aee1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2057,24 +2057,15 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>  bool vma_policy_mof(struct vm_area_struct *vma)
>  {
>  	struct mempolicy *pol;
> +	pgoff_t ilx;
> +	bool mof;
>  
> -	if (vma->vm_ops && vma->vm_ops->get_policy) {
> -		bool ret = false;
> -		pgoff_t ilx;		/* ignored here */
> -
> -		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
> -		if (pol && (pol->flags & MPOL_F_MOF))
> -			ret = true;
> -		mpol_cond_put(pol);
> -
> -		return ret;
> -	}

Okay, we used the fallback of vma->vm_policy before (if vma->vm_ops->get_policy
was not available), which is what __get_vma_policy() does at well.

But if vma->vm_ops->get_policy now returns NULL, we fallback to get_task_policy().


Makes sense to me although this is a source of confusion for me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

