Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151DBC79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580E36B019A; Mon,  5 Jan 2026 11:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DF46B019C; Mon,  5 Jan 2026 11:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430C36B019D; Mon,  5 Jan 2026 11:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31BD96B019A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:49:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0ED985EB1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:49:30 +0000 (UTC)
X-FDA: 84298496100.13.233270B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1402F1A0014
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:49:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bfAKs4/B";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767631769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IzfCHdiJzKkBoq2pYh3uxR9Qt7WuNkqXZ3aOpibuJc=;
	b=y8Yt8Am84G7WHzYkVz0D5zXZcTTAUReh6HwKe/8h2HgYXIzfYJKdQXfreeyZUGEgoMwN6Q
	ZW9P1puSxDMtL8Oj1JzLxVli+F4xvR8qOX0Bkx+EqzDW25y8M7g6SG02M+IoKLPgs05f+D
	/y5lugBA9klgP6QBamF2sFN8qTb+6mc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bfAKs4/B";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767631769; a=rsa-sha256;
	cv=none;
	b=515ZLaLoAJ28gDXXZvLSP3QN636eZEWcKUgP6vOBWxyfTxR15hS8qSvQNnV+CeFPqc+q7/
	l5Gmd27AX1gvbuwN6gwDnvxnQMQHHv0SzhgQ7jPpr9BijoaNOfPXFgPbpyyUhyCO0BSNr0
	ej9pRDjcMknh3n0WQZWcobDn9tjBd6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A182406F8;
	Mon,  5 Jan 2026 16:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32254C116D0;
	Mon,  5 Jan 2026 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767631767;
	bh=q4jProQTOr60sLsG+h2XK+ynEstH6XLCXVz8oALa8gY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bfAKs4/BGFyCRwCH+PUoi6dKBrSOT1OFhGke+NhSx+WHx0963FCJyFW9CzbIfyul0
	 hOaELtLEe+yU5C6nghjzsZ6zR6U2DWzOpHJOwEoXQG8AEulvCx1D0ObpkA7/jHr6OT
	 xOoDoUl51JNPx5ccOEpxo2YuH04x9+m4mqhdP81qLxKKadekAhvUgBlb+S9F+OpZ3t
	 JuEH9aIcSI1hdd6QRsU1vhw5eekBF8of1d8GaKhp9DH8rW2x3dWE6pFMjjnoqS1Odr
	 I5qX/9KyfZDx8lDcpND3h+qGgAWlruBELpSZXJNsbe25wY42iV+4pZmnYFSviuU4oQ
	 lUKBIxiULVFUQ==
Message-ID: <69c9ac59-4fb2-42fc-a8ae-32f583e47de4@kernel.org>
Date: Mon, 5 Jan 2026 17:49:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-3-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260104054112.4541-3-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: sysp4rmfxikue3d57jqfy8wb4fuytd61
X-Rspam-User: 
X-Rspamd-Queue-Id: 1402F1A0014
X-HE-Tag: 1767631768-512170
X-HE-Meta: U2FsdGVkX18Npt1p60RE36HBjtsiRWFvICRGyhebklHq2/1pSuXUbxysYogJRdnMT4ij9suOdX8bLv9YtJdqCkVV0uAmnpEd6UaknbBrLkA9/tGfMAT7p0S5EflaZbqINIahdEWkOyjXxO/Db3XfadW1M8CFMatxYKfUqAIgd4EsUXAGa78PwcsJBWCtmem5LFjt7MqVrrldWQay/4Fk6Y0dZZ7TIsM8/ngb3JCCcJFaqd0aZYLUZz9L2+Pc2Eqh6sx8hEboyQ5kMifahtgVMwCtnPLV5DfTIYe0f/FQb7csJpTSqVFYMNiW3b+R5sil1/A3g+1jVdtl+zjfoSTfHnv6CCJCS/YL3fwrETGbwJpsdErKFrBO4tcMFhFSK3sxk/tQPoCtWuAkpADUwrau8b/+/YdY8Duuiah62lyRzi8Bfwa7cI0C7YZkPk8Xv0O3ri0avPqaFGZAyHAODBrw67Gy0cfFr06SlLLzvOHz4RS/ViC2Y9lvKobwLt47M9n60tEDhDuzy7JAJyNmckScR3In2qTuEe9MUm1FX8NBgk4t5wrOaaO7VeSvqA1MasHirZSJLcpKRzx6zMA5XSL/DW2N9pHTcJTzazsZOpAGqn0qPU3KCStMBWGBA4l4ArUnybCs2ACXb2WbhFW3r+NR3rcXyKYqqDxsUq4iqlr2J7+9i8yGfZteF3aKZC8Vf/flFHIr3yBOs9U3uQ2qYblorfRsDMKNKdv8QddJVw5AcwH+wm6Rpc7JXdeFbLb50XYM1b3eNfhjBdObxqjHHl98mTGq4cT9QT9Wx0iKBUg9eZ6iMhA8Np+Fh+LFSt0RL0NMw9ytoONvRmZ/s3hV+3TKXeQpGEVM6vRF0wLZ52XqwtXfeI06ne4yCju/Dtz7h3sRfzdkRjPsyU1pGc64H5/G6l6/juTNdIbjxruVOi7ipDrtPI8TVulh63OQKLLrfQ9bWwyeQLCCKGsa10q0U0u
 ue1UwdOc
 OZgqA13uRXu+Hhv0Q+dd0Wov5VowPBLeEPf6ACTnkxPz22bY0n8yoFqzfTRQVhMCRO5ZkljCx6neNNPVa5e5/jXk8jPFuBiuL22Z06RcMukit279b2idtoHPqLSRFdxa9OZauO4rAo36qkWOijO2llXsk+4Y5xanJk5eMweIiRZZi6F/YgrdTQdpjjT4eJFLhB4t3sfeYvOZY6B9PRTt4bf5ULgMloP5BupPZCBMxn1o1fK41Bdbw33pTTuRjsTB+fqChGPJK+UEVGFIv0KOYLyqvWlHDi8TqsU24Aclfr5jFiHWguIgeU19RDMTz6WNRDF0XLmWjLX3/bCFgN34k3AJ+FHBGZwNZ0u4ynmX2hbzLKGlMprHfGRtKipMjtA11qhRb9KEiFQVz6RuMdsz/UU0Kz78atk5qEuIv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/4/26 06:41, Vernon Yang wrote:
> Currently, each PMD scan always increases `progress` by HPAGE_PMD_NR,
> even if only scanning a single page. By counting the actual number of

"... a single pmd" ?

> pages scanned, the `progress` is tracked accurately.

"page table entries / pages scanned" ?

> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 31 +++++++++++++++++++++++--------
>   1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f99f61689f8..4b124e854e2e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1247,7 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				   struct vm_area_struct *vma,
>   				   unsigned long start_addr, bool *mmap_locked,
> -				   struct collapse_control *cc)
> +				   int *progress, struct collapse_control *cc)
>   {
>   	pmd_t *pmd;
>   	pte_t *pte, *_pte;
> @@ -1258,23 +1258,28 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	unsigned long addr;
>   	spinlock_t *ptl;
>   	int node = NUMA_NO_NODE, unmapped = 0;
> +	int _progress = 0;

"cur_progress" ?

>   
>   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>   
>   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> -	if (result != SCAN_SUCCEED)
> +	if (result != SCAN_SUCCEED) {
> +		_progress = HPAGE_PMD_NR;
>   		goto out;
> +	}
>   
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
>   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>   	if (!pte) {
> +		_progress = HPAGE_PMD_NR;
>   		result = SCAN_NO_PTE_TABLE;
>   		goto out;
>   	}
>   
>   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>   	     _pte++, addr += PAGE_SIZE) {
> +		_progress++;
>   		pte_t pteval = ptep_get(_pte);
>   		if (pte_none_or_zero(pteval)) {
>   			++none_or_zero;
> @@ -1410,6 +1415,9 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		*mmap_locked = false;
>   	}
>   out:
> +	if (progress)
> +		*progress += _progress;
> +
>   	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>   				     none_or_zero, result, unmapped);
>   	return result;
> @@ -2287,7 +2295,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   
>   static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>   				    struct file *file, pgoff_t start,
> -				    struct collapse_control *cc)
> +				    int *progress, struct collapse_control *cc)
>   {
>   	struct folio *folio = NULL;
>   	struct address_space *mapping = file->f_mapping;
> @@ -2295,6 +2303,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>   	int present, swap;
>   	int node = NUMA_NO_NODE;
>   	int result = SCAN_SUCCEED;
> +	int _progress = 0;

Same here.


Not sure if it would be cleaner to just let the parent increment its 
counter and returning instead the "cur_progress" from the function.

-- 
Cheers

David

