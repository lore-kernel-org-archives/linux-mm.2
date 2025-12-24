Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8579E7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2F46B008C; Wed, 24 Dec 2025 09:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0EE6B00A0; Wed, 24 Dec 2025 09:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D04F6B00A5; Wed, 24 Dec 2025 09:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6D06B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:11:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B72BF13191
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:11:30 +0000 (UTC)
X-FDA: 84254552340.23.89D8D3D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1F5240014
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:11:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766585489; a=rsa-sha256;
	cv=none;
	b=EE40p5/1r1xp5JHmXs0TZGEBL838/V62JOymjMVG4+xG3B/ZiXiwqC3wrVJV2F8ExJ18T5
	H9O1C4VDh9bByl92conNL6yV3ILRN2CnS+9WXikG1s0KB0Eu/0orHIrsFX+Loa9Zpd4/VK
	FfSc4kzVCok5vjsRRZlRg5jKPpJ6YA0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766585489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=engvTENbTkwyMwShxwwH2edffyeaZ701mnBGWNltMW8=;
	b=ccjlfkb3sFU6KN0NiK9/K8QiS+VxY5ie0oN58z8Q5AvHlBHewkgk2m6J6zcyb0hRQVmr0u
	HdRmrIGCrBt3pg5Vq1KMUkdyOJBNEU9jAPYRH6AKkAfZhkQHI8xWni4U8gzqIOWhoYcptc
	80gq6BeKnbtjkv5aA5hJEGHJztuvImk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0109C1424;
	Wed, 24 Dec 2025 06:11:21 -0800 (PST)
Received: from [10.57.93.190] (unknown [10.57.93.190])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 763F53F5A1;
	Wed, 24 Dec 2025 06:11:25 -0800 (PST)
Message-ID: <20821c02-e16b-4e5f-95b0-b3e8b9192117@arm.com>
Date: Wed, 24 Dec 2025 14:11:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] mm: rmap: support batched unmapping for file large
 folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <d869ae45a7be322f342ace62ffcdd4b47f4154fc.1766455378.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <d869ae45a7be322f342ace62ffcdd4b47f4154fc.1766455378.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F1F5240014
X-Stat-Signature: dhs77bt8w3cn5y957n7bes739uzcz8ac
X-HE-Tag: 1766585488-661297
X-HE-Meta: U2FsdGVkX1/Vkq7PsYsw6ejBNPPK3o2hizMKJn9gVrWbjM2RMdL4KVxJtpuhlOwSlbfseS+M9RE6I0Uil552l57Mgkp2XEmO+tinXIa9sAYXI/TPlO15zXkgehjKoy4vKqtkKuok91iQLo7OFD4CAl3X8VR9KvT/22LdkHgaw/KAyilY+Jn7ZU6HuPx3L90lfk8RHttl/LIg/1E3FJYBfj4OIBJPjRFAXIA4vk2Gvn1ODt9yeQPqywe7FVujvfxobDLfwbynBpFdr2FTDbLIgOnR5Mt8ePQpGRO88Xm1t/TkEtX2cxViPIIFLoXogfvuWPbY6Zs20+L7dihwaVruiyj9GO+4RrWjXw1pPNCb4YgN0Gl+pN2QXkEA9vNRqBCYtbOmkYRBnnZ4TTunCzrgZFTh1RBpwMwz99aikN4dzoMf4kgpwot17IWy45Z8C0gkh/+ZzUow+HUtHJnP3+LtrX2SOE/yMMGMLSqe/zPMqCRV1ADn/gMUK+eFgI/ESTykidzanMume9BZ0rZySY3v2HFRp6S2l2DJRXx0zsn8oCuoY1l2jfnzNtXjDXEMFXtQOrD+wCUhkUr/ALDoFUXK0v9M/HvnwyM5bvSgNnW4LUSDEIuAErZYJNCGvqPjkYREYcvQS2GK5Ygtl+Guu2dFSGyKGgGjLRWEbvOrkECl2TP/Is1qy6pkGT7RhBQbTYvahZnXftmIutGwH6aZjG/krVZcusWhTWAY4XH0gAuOrTVvkCv0Nm/S4qdNqV0hg5kM2Ke5Ppmnd8sn89H91qv8dWm5FAFNyRN7nK2bAJ+rWlUJOhUw2O1DZkwGCMxk07F9fYv1E3dWGdfwAhPnF+YYEE1dRoaJNke5aP/0GE47g5kbcVyKnRoZhhT//4EH2ttLv+urPxSsJ3R03l+ADsXPR4d+LZ6dxnSMr6jqYaiKmlzshYvTfjOMEBCLDyYRYhYPR3mathFXpuDK6f0XS9R
 VPE9F4di
 t/3PiCB5qHyDanQ36+7it4QMGZevYc83cI8ragX1HSd6hV18/skt1jNrX1X6rqo2jroeo41en46VveJ1xzNTn3Iqme0/ECLzE06J644VuFnXM94qkhmnmtjAu50RkhEpZ9r9CHcjA+HHtuP/YGxQyxD0x1zyradaoKanmAKXxV9cgM54rXcKYaaoqZbueW9nIWi8DUuz7Qg8gFbDpYI43jxfUuc1YJpq6G/bWg5qYj29wvmcsbjvkMMSCfvoXq+QtbDLvOU8y+ocNYVH9O6Z8uJOH1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/12/2025 05:48, Baolin Wang wrote:
> Similar to folio_referenced_one(), we can apply batched unmapping for file
> large folios to optimize the performance of file folios reclamation.
> 
> Barry previously implemented batched unmapping for lazyfree anonymous large
> folios[1] and did not further optimize anonymous large folios or file-backed
> large folios at that stage. As for file-backed large folios, the batched
> unmapping support is relatively straightforward, as we only need to clear
> the consecutive (present) PTE entries for file-backed large folios.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
> on my X86 machine) with this patch.
> 
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
> 
> W/ patch:
> real	0m0.249s
> user	0m0.000s
> sys	0m0.249s
> 
> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
> Acked-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  mm/rmap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a0fc05f5966f..7482121d4e92 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1862,9 +1862,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	end_addr = pmd_addr_end(addr, vma->vm_end);
>  	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>  
> -	/* We only support lazyfree batching for now ... */
> -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> +	/* We only support lazyfree or file folios batching for now ... */
> +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>  		return 1;
> +
>  	if (pte_unused(pte))
>  		return 1;
>  
> @@ -2230,7 +2231,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			 *
>  			 * See Documentation/mm/mmu_notifier.rst
>  			 */
> -			dec_mm_counter(mm, mm_counter_file(folio));
> +			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>  		}
>  discard:
>  		if (unlikely(folio_test_hugetlb(folio))) {


