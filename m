Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A13ED5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 05:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04736B0005; Tue, 16 Dec 2025 00:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D823C6B0089; Tue, 16 Dec 2025 00:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80B46B008A; Tue, 16 Dec 2025 00:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B17606B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:49:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 333D313B144
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:49:02 +0000 (UTC)
X-FDA: 84224255724.13.C1AC6F9
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14AEF16001A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:48:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ley2j58O;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765864140; a=rsa-sha256;
	cv=none;
	b=0wv9wRkRCkwOv664FRSwiBQxzj42ZwVa6/RogbdDuPbZqtxqMjr9hJ/rDbqYIfNyu6xi7U
	9rKekY/j1W7hmRUhCKauTRJO17tKWOWBuHPYdBTRLG/8mwxkoaQl0P24XERFtOJbtXMmER
	O1HQ8EpgZQ99KptvNVYPWzDYJIUdg7w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ley2j58O;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765864140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRhxoTZ+3IIdYwTnJoWC2Y2iVLI35ww6bqSlIUl0XxQ=;
	b=zeAjXiZaKkVzdaZTkvE+HubzVH4uNjXWq2ZiJbPUUuYXumVMzFpdYy9ppEwVBtlxgc5R5D
	Bqd16AGa58WMz7IIN77UeacSo6XR1J8ix1R7VNjBl/JJEIFwX99IZmihMvoZrdXoMverpF
	dh8g+3Ou5MwF7t7ahwr5IM3GN5zx4eU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765864136; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tRhxoTZ+3IIdYwTnJoWC2Y2iVLI35ww6bqSlIUl0XxQ=;
	b=ley2j58OCPEN3x20n8oxg6pFGJnGlk8GrMo6CL7d8+SvNvePqBKLUq2zNhA69T4xehYYRq+rk92Sb5AO9y9kgdahimDadEQI3sKh+agUOHv59vqzALUkG+xmRYVzLfABQHgGGMmxtztC3YRqcbWinHXYjt1b+HgXMU/N+v/YZE8=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wuxvaan_1765864133 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 13:48:53 +0800
Message-ID: <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
Date: Tue, 16 Dec 2025 13:48:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large
 folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14AEF16001A
X-Stat-Signature: eh3hbd38y9t58rpk599xc4u3jwikd5xj
X-Rspam-User: 
X-HE-Tag: 1765864138-882350
X-HE-Meta: U2FsdGVkX19+higqQQrNiQ4BbRT6kTXBNjv2nsjnm2Hyfq6tu6BAEO61/M/6EZ0bXNfNlCRM7MtEibXhDhBkTapwkCYD8H6qELl2++EzsZ9twRFv7ZHBrCn5bl8x1F+n4QBmKtfOSHSkUmxQssMxdt0hzjHvMRLlEckWZd/oLtso+OF9VyDLTgCyK3Ul+F69c7/XYlpffk2Fd7jihEj7yCvwYJ3Fk/i/5FMbiqRsC0SJsHstQdHTO79yuHERNWhJc7K4ZGVRHYfFT/2fnoIb1TGn8BenoQUEfNLMvb7qUqmDhjVb6SJl4/m8Pb4QmaQHAruSNRuI2yY/bJg2twKJ8CtJai4qiocuab8N2oTISE5Bdp/QoLfKLZeiSfoyr83Cvihnl6Qd5SU/MjmKVeKxRJLk+Gjy6YOll06mu68dGhacNkqNtfs51IR7enq4c7P5wDrg3hLgWhsGu9dh3YMfCH/IF9DbbW7biGvA47uVvLVGpUmRVGhuKyfGeAyc4XkaGGDwwJ92e3fq12+0un/yGXnvlumX1Ih0Wu3dZekDb0uex7NlEfGUUzYwmpre9ezr11sXS2UBwWXv7uR1LKPjF7L0OelD5NZoPY5v4jTNXaYxTIylkdmZI4tSkuewqedKn2uJ20G/b8XQBJK9+DS4yhhgKaNButWP5daRqwnHQz8/EVnipC+wQ2nR8QQ7YK2XOoPWqfGSjfEt0g9c/CtrY3c6UqKA5qZG6qC/Kn/fZS0w/doWVVExNKrH0mzDxD9g1YXx05wMeonlBB2xT0c8gKB5oFp/JEY8zbGSx9JNBp7+uIly2GMyKi+Fy67RFkSnGjP0HJHDfS2p1niRzCC/bPngxTRyWiUieRUnPxvOl/zdzokgxhrrVqLwSbcUPGN5689Q8xHV2bMlpe1znxP+7Z/L5BnLL/punvZda42FJVWcza3MyuLRgF/7bouiWcJJ6Vhium8bYpqb4nz6bXd
 yXotGnfJ
 TwDL7+MTKDG1UXVqJJ7LxLWO3FeujgODl2w+nkqiisHmMTNSRvI1BuX+ioiKj4vywkQZpmriHZa5vQEnE7kKS4I0hzde+SWKMNbFI0palhuUV3wVPJWT1cmX5TOoqV1m1aKsxWSj9lnQQpCnaYKQKkZ4RZmHt4dx2mXIUkEduU2/Xn5O4XLSdjZ+6mmrf8I4jkcS8axY/8fZja7/FBNy4g2bI3G2M6hDcphUCYCw+lX9DmLynqQZcJPTxmdj9eWQAGJFfLAD5AoQ1+LMuiYjW9i8CY5aajEIVyc77O5NUTjhpKdjBp8UNvSYZHxVYXg1yfq7U/R+K1GQUmV2HN1q9B7cZSg8545zywVWx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 20:38, Lorenzo Stoakes wrote:
> On Thu, Dec 11, 2025 at 04:16:56PM +0800, Baolin Wang wrote:
>> Similar to folio_referenced_one(), we can apply batched unmapping for file
>> large folios to optimize the performance of file folios reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> 75% performance improvement on my Arm64 32-core server.
> 
> Again, you must test on non-arm64 architectures and report the numbers for this
> also.

Yes, I've tested on the x86 machine, and will add the data in the commit 
message.

>> W/o patch:
>> real    0m1.018s
>> user    0m0.000s
>> sys     0m1.018s
>>
>> W/ patch:
>> real	0m0.249s
>> user	0m0.000s
>> sys	0m0.249s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/rmap.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index ec232165c47d..4c9d5777c8da 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>   	end_addr = pmd_addr_end(addr, vma->vm_end);
>>   	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>
>> -	/* We only support lazyfree batching for now ... */
>> -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>> +	/* We only support lazyfree or file folios batching for now ... */
>> +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> 
> Why is it now ok to support file-backed batched unmapping when it wasn't in
> Barry's series (see [0])? You don't seem to be justifying this?

Barry's series[0] is merely aimed at optimizing lazyfree anonymous large 
folios and does not continue to optimize anonymous large folios or 
file-backed large folios at that point.

Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous 
large folios. As for file-backed large folios, the batched unmapping 
support is relatively simple, since we only need to clear the PTE 
entries for file-backed large folios.

> [0]:https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u

[1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

>>   		return 1;
>> +
>>   	if (pte_unused(pte))
>>   		return 1;
>>
>> @@ -2223,7 +2224,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>   			 *
>>   			 * See Documentation/mm/mmu_notifier.rst
>>   			 */
>> -			dec_mm_counter(mm, mm_counter_file(folio));
>> +			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
> 
> Was this just a bug before?

Nope. Before this patch, we never supported batched unmapping for 
file-backed large folios, so the 'nr_pages' was always 1. After this 
patch, we should use the number of pages in this file-backed large folio.

