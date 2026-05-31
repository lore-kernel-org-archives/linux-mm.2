Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E866CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 20:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49746B0186; Sun, 31 May 2026 16:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAB16B0187; Sun, 31 May 2026 16:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7F26B0188; Sun, 31 May 2026 16:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D49B6B0186
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:18:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 117078D710
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:18:33 +0000 (UTC)
X-FDA: 84828827706.01.4E82035
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BF0840008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:18:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuraNp+n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780258711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oJD4MFiWJKAvd1Y1uNLeroAJlcqeh9bsxIYTnCdu2s=;
	b=QRBYwFTfFaEiL4gBXIiTbXOkm/AfKhHTxshSm8FCp1VwJQRduA/fg19T/DQER+J3Xeg0yY
	3asfMo/PR/hLFxuXZUxtqqYvNn3y6yzBJSjzzP2HMhvYeM6asvkygnzWcY/RpxQtIHrHsS
	ip1pdqiFLwrrQbcF51M6x+5OeiDS8K4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuraNp+n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780258711; a=rsa-sha256;
	cv=none;
	b=HjIbaPjuOyJg2XEvmaLkhEQGa4Ze2J/kC7GdfPUMPUZMGsxk3YoXMTgVr41VmY2OggU9/e
	5HKrM+8xcoLqKfXY29MSsg4D9MUFJ5P5/S7c1CKWK+vHmYxwj2BRIW7WXttDjCuLMkr47M
	03MV1ULqAmYQseWvjeeVRb650PC9W6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9055E601FE;
	Sun, 31 May 2026 20:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C6F1F00893;
	Sun, 31 May 2026 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780258710;
	bh=0oJD4MFiWJKAvd1Y1uNLeroAJlcqeh9bsxIYTnCdu2s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JuraNp+nvV/FZss9GmTbljR4/DaII9mHJtQWBFTelkHUiQcSU7fCvzP37CNPGJRhd
	 C/c2V+VkfbeA3CCEG4w/P2FdKzN8IsPUxVQ4ivVSQ2cwIwaGecFeKOHs1dDm8WoeiH
	 UVYJkvkT1S4g/6F7fN53c/ZrV5QJ8bKdLPvZoRtxdOCQlIcgeDl60GCrcTuPwUvo3O
	 +32fw8ZaPtMXA7tXYenmVzm1czbVytuhRVfUj6f8we9GNSMDz1bGIsbGIb56elCa6h
	 U72rn2bjrd7apVIWAtaSfa14kzTxvTV5ZKJly8SPLWgJ4QSbQUhh9XCdSJg3pvHHVV
	 rtBr6ac1LFYDg==
Message-ID: <b7ddff01-9adf-4ff7-84a6-021087936c34@kernel.org>
Date: Sun, 31 May 2026 22:18:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 10/14] mm/khugepaged: introduce
 collapse_allowable_orders helper function
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-11-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-11-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x5smyze4tytnjmgouym9t78cwft5kta5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BF0840008
X-Rspam-User: 
X-HE-Tag: 1780258711-544895
X-HE-Meta: U2FsdGVkX1+Fg75CnWIP5M90x4Q6ZQMnKos4gpNqhWAOjliygTIAx+qddkx1wnVtNPKRD6iXJMipBd8+XbdJCQr9r7EWWA68RG6eXXPtlS26qZXb71xSVh7y7xzvc4DetwklAgy5VdWN4LCkxxd8nDiRxw+byrOTe13nlrCEGi9/dvhQVWdMVfyOrdS14Bkh8j45oVTWdnYFucCK6OQ3/P0RIP5vgoshOUobZ/YXDXsai1CHeDSnMf3Ha31LE96AHVRH13N1OZXvmGFD2DyaC/QjzJdLzVODBwgyDzuAFde51YVIyC2RnFGTJdj8KV4pusZa3tWvrpX3iqPMWa36kssWf0kpTknYqvSb+K3oM039zyHgtQfkj4P4haNSQOiRZPSStGdcWsU3pitnEpskRoK2jiOiNAj+sIVwPYM2UPzfj12Vwr2OD5A3x9DaWREjdpgsnD3ndBh7lSWH/sWBwV1Tcqgh39WLMC/fh1GxpM2bfBbXfdBxDxotG4gxn3gNZXeJadYGaXqa8vmYxhArdyVI2QGCS1bYab2kkQUC6j2OVL4cGoWhXdRLWLVZTpkHtK/0KR7tAOU8ZisP6+8x3/B/rJZze52tlM9OZQjuFtUmpDhlzP7TP//Wptv87gzO8K31dkFzpkRC4J/iOfIsXlh6Lh8FmfgelJlWT7rWjawC1QTeODMFWuKpYJOBnuOfA1XXxFz61IbWNypdmcv8O+PyRnX8UpifWJPsRqNrxcHWTJH57Vzk2lsBiq/gNuL3Vxv/3cLMu6c/ut5Th4qR83rN43ZIkcA5cNZqU7JtUVpl0yeVMD06dBB+HBmYa80f6VEgMo1W2v6Ytif6Yp1c2sHAbfxkFRL2Uc8jgw41/U9kDTRT2bHzfdsmjMLsArQ4pmJ7jkp9zjRO8WLnX+7dSVQ0PpajBO0xyPTFDMVaBJU6H2okLU396rBuMgOeB//VUy2aWTsuE/p9s4/Yi5g
 lZyqWhUK
 E16B0NTEt3JQn7E9s4+pf7tv9rfNva04Gk6ZW2Xn1JW3ZXuINHvKd6EMhIIREsWWcj0C1bd/4BtrI5ofM2bsGvutfCKtz12DYY3tIOtL6NK11rO+gE9z5vx6QLtqL9E8bRqoWYFayAQ+/W2m7ZxDB8mhA5L59+q21R6rkfBpvA9VoZpf/9u4C9SQXUxTGk3E0RKUnrQ6DCwaJefd2WOU4sJcz6bvZDF/F8oBdAOSKu5uABVESNw36x1E+PDGXWjVTohg4xfU4rJ7jekHHoOnKAuJHsEENiZlnu2RF5Ha35P/HmX6lpFozgoupiNa8ZBoPoRvxg7CH3rySV4QKhYNTkPD3pL0cNeqvmXY1ORftfAqo6rfdW2wNgtiq8c99DGe2YJSIsd6Xq7YM+VHiufu3qA7d3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:00, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
> 
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.

It would have been good to describe here that, for now, it only ever returns
PMDs, and that it will be extended next.

Logically, this patch belongs to #12, not #11 ... so seeing it before #11 was a bit

... and there, it is clear that we don't even want to know the orders?

So can we just call this function

"collapse_possible" and make it return a boolean?

> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4534025bc81d..64ceebc9d8a7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -552,12 +552,21 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>  
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type tva_flags)
> +{
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2680,7 +2689,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  			cc->progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
>  			cc->progress++;
>  			continue;
>  		}
> @@ -2989,7 +2998,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>  
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
>  		return -EINVAL;
>  
>  	cc = kmalloc_obj(*cc);

Having a simple

static bool collapse_possible(...)
{
	return collapse_allowable_orders(...)
}

Would make the above slightly more readable.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

