Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5D0CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD296B0005; Mon, 12 Jan 2026 14:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B286B0088; Mon, 12 Jan 2026 14:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952E96B0089; Mon, 12 Jan 2026 14:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848A96B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:26:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 092BAC39F0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:26:03 +0000 (UTC)
X-FDA: 84324292206.29.28FC207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 21D0440004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:26:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dqa8vtCQ;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768245961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gV+bcjbK4PnMIGQaEnXSqV0x8twfcapgn6Vrm1mZ4I=;
	b=fFBAOLbd/j/LziwWE0PXKC1Ejl+LLinnKJE4fd3dArYzyNMDNMv2pwZVdGwmh6+Snkd9/m
	qebwY06w3+BPH/5Zm12MpEUVhPAl9KqmtWHhgbcAIVe7eZbs+/ZMkCXnaCxycLPcFGPqGL
	8qmFvH7kBsiyR+VhIhqvr6zpyyEoCQI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dqa8vtCQ;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768245961; a=rsa-sha256;
	cv=none;
	b=Fc3Mr/tFlFdhMKM0xRhuRJhgiM5qKJACrGKqWHT2WLnOrchbUAc0ZmpB8HCgjvV92hiE+7
	FsfOomwlFPa3nRev8SWFRQs2FTKKgMpUoyzz73WT3SpheBiEkbAWcorf49u/8IIZlC6Pbg
	UasANr7efgtO54wjYBebHgvTHLsUvd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2560743969;
	Mon, 12 Jan 2026 19:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41AAC116D0;
	Mon, 12 Jan 2026 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245960;
	bh=E8CzHK1RMCRRi4oUTzTRWax4o4HRBYfzVcys/KDe1Ik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dqa8vtCQfSAUu0dGXDk4G8flgS0z75/X9fJgyoiKZWKnCnzSIFZN1xnA/LWYGGXri
	 xmx7jNJVMagVyeR3W+JMUtddPSNNY6wEMz6e4GWwXfTZ6drlWTCqSICKqQP3NmT8Hu
	 kYF4hrpomyQhV3ILqtNlZcqHdz4T0KydTVOxCIBYe63TCs948aDzDnJj9awlRX4i95
	 SMiZsVPCNKy+5ihrb+IQzi75Y4SgZ4DLblC0Ac9Y4G1W1SZm1FcL+cZpINK7eG9QfF
	 Ny23TahE0lp64N6PKgha33xqnDf3vbcBwvYAVExuc/s7eTzfII52GtyUnVeHAaCARi
	 J6FXO/RNfIgmQ==
Message-ID: <ba03780a-fd65-4a03-97de-bc0905106260@kernel.org>
Date: Mon, 12 Jan 2026 20:25:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 hughd@google.com
Cc: wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wwnr1iu8ngcmubbzf3oahjus1qh4k1mu
X-Rspam-User: 
X-Rspamd-Queue-Id: 21D0440004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768245960-783916
X-HE-Meta: U2FsdGVkX18klXXI7n1moEMvY21YCIO3B+rB47Qb0V3aWUxHgvIpcvIJczPrHEpO0AfcnDyEl/gR/yCFUfELa97Z4Xpd3whb020sW+0EjN2jINPDWd124E5W2NOY1olpXMUPf1sPgnSFpwUFE26RD21u/Stzd/d1ZDzHUqbnR1UWPxQEtrCORkBqaS3BPhPII2ljtetaQtSKeSz3/8O04brUMRkCQickJZvX8h1YSiwn2xxP2iTn+v4dpaDRPCwGiEDS0O8JOBIEhjAZ8nF7xWx307c8dgY0ziO0CehEuFUmqDrnQQE9dWOTUaxdPO6TjId1ElpR3PW6rxY1Ych/rk48a0iJ9LKLcwjrCctb+OTe0jgRCOCLIscu2yn/EthCzbx3OSQZnxlJPnXuar3WieDAm8FLK9REHEkQhRjUYVCEe3nOawPhDAPzrhRkgaesvqbFac8aX7qqLsDptgU3t/UGvtgRPbfL50up9PTbaE7pCPB1uHh0oI3cBcolYvCo4OgO+AhEn7Mu/ZkFywI4biSOL0ip6fPR880TtNDVEf3V3lktYO6dixMInXc6JNKzY6KStOvxuoDso8+k2t0j/w3u5B4RcOkwy1XZIH0coTHRYNMH+6q8siN9igu1Tr1t0apqjffGKPtSdzwCmEjXT5qWx8BdkTYV6G+Hq/kzbXbUJQcyslLNfqz9omZhy4fuS0C0jsKSNBIWvadTAaJr9j3dMv2HBEuQVFC1h0FGjrLljJ5xQAXtXXmF2hNVh8rWRRrO87Q0A6zeF1T8codWu1oWnQExByNe+ZSARS+wf7lXXw/80KhthffeSj2t5zleqIpiw48zXwFn1e4QV9g8QCZ2KYume/vJmE88ZOndV5oCsldyjvY+ZW4jzrw+ZbFrYrSM1EvkIqIyOi+3j7HHIJUthoVnNuxXRO+gl4Nqh1kmkVzhQjK6bNJP+M9JdeNcX8ml9vle1NvWRDskuV/
 xRHdD70I
 5cs/lzPCMWqYCqdn3ejDTeRWcJfJVK+AYG52vaAbagLJ+6hix3wf3+nTc9RNoZLPPHoCqiUbyvhPancn2eou7AEUO3lFDOARJ6FWYDJDI17r5oXjR7SyLSI9kgXYOHyacO4E/hsqHHOOBqrY7I4ZSfqVpAt128KaKL5mopBMzeNvvySLMoCHNg5LVx+Z2ZuKUSQfTZrd7H8b3b6QZu1tMEdlPGcq1i0UuhFi5g8hKYCAtZ/YzCjDg4+vRDyOk5Bdka5By+pDUbwD0IFiRL+3BsWxBoAnbgBs5TTSa7ZZX9C5sWtq75moSHucmMSdF8IWuyb95lxIGMIXV0+Kr04j3CPosALOsY2R0hD6GRjxbPzObzD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 15:01, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Reaon
> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> In fact, we can significantly improve performance by passing a more precise
> range based on the given addr. Since the original pages merged by KSM
> correspond to anonymous VMAs, the page offset can be calculated as
> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> defining:
> 
> 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
> 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>              in a loop of anon_vma_interval_tree_foreach.
> 
> The result is as follows:
> 
>                   Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before patched:  228.65       22169                 22168                    0
> After pacthed:   0.396        3                     0                        2

Nice improvement.

Can you make your reproducer available?

> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>   mm/ksm.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 335e7151e4a1..0a074ad8e867 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3172,6 +3172,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>   		struct anon_vma_chain *vmac;
>   		struct vm_area_struct *vma;
>   		unsigned long addr;
> +		pgoff_t pgoff_start, pgoff_end;
> 
>   		cond_resched();
>   		if (!anon_vma_trylock_read(anon_vma)) {
> @@ -3185,8 +3186,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>   		/* Ignore the stable/unstable/sqnr flags */
>   		addr = rmap_item->address & PAGE_MASK;
> 
> +		pgoff_start = rmap_item->address >> PAGE_SHIFT;
> +		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;

KSM folios are always order-0, so you can keep it simple and hard-code 
PAGE_SIZE here.

You can also initialize both values directly and make them const.

> +
>   		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> -					       0, ULONG_MAX) {
> +					       pgoff_start, pgoff_end) {

This is interesting. When we fork() with KSM pages we don't duplicate 
the rmap items. So we rely on this handling here to find all KSM pages 
even in child processes without distinct rmap items.

The important thing is that, whenever we mremap(), we break COW to 
unshare all KSM pages (see prep_move_vma).

So, indeed, I would expect that we only ever have to search at 
rmap->address even in child processes. So makes sense to me.

-- 
Cheers

David

