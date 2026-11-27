Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F9A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 04:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=omijfA5C
Received: by kanga.kvack.org (Postfix)
	id 652306B05B0; Thu, 26 Nov 2026 23:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6025A6B05B1; Thu, 26 Nov 2026 23:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518236B05B2; Thu, 26 Nov 2026 23:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269336B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 23:05:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8852BA761A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:05:43 +0000 (UTC)
X-FDA: 85479560166.24.AFE09F3
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id B14CD80004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:05:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=omijfA5C;
	spf=pass (imf02.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795752341;
	b=w7Xaxy+rThQkr7LcYEIFFa3a5FydUaqWiK+w9t5AM/UaYtz3yYorvUc9g1TJ1Q0JDKsz6d
	0BfN65ljygPt05d+VG+mL1VLzdsaQ32Hr+OL4S97zoeLQzW+jwg2AxCiGghzbedEr1eltU
	i+0UAyUoHYhcGy0ckSEEJnAdxlwR760=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795752341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ma+f5p80haJszFPPAIIEC1l3WLdFdBqpV7MIoNSrF48=;
	b=clPWtVoZlX2LoGhFAtG1Pna7Mw43eFMShmRDjXE695Rrk2NA2sVJw0m6PMh/fs0tCYFPM6
	ESjy85T8J0Q903a338nzmJkqrwE+IUOj429Okm5Ul/dTUQIRwj07SxSkh/9h7I7UXUGWSN
	mauHeikqqsm0jpSGCIiltoP0qYTQS5M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=omijfA5C;
	spf=pass (imf02.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from [192.168.1.70] (unknown [52.172.102.222])
	by linux.microsoft.com (Postfix) with ESMTPSA id B8EB620B7166;
	Thu, 26 Nov 2026 20:05:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B8EB620B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795752334;
	bh=Ma+f5p80haJszFPPAIIEC1l3WLdFdBqpV7MIoNSrF48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=omijfA5Cc+HumzTDcN5RSmmeizr3nKcpgIVYDhAvwS//fyO3Q0ZVB9vJcRC2PgeEF
	 wHmv+J2D80WDkMAfjOng7PYGhhK8l6++MR12DNtgPLS4XD/KyuXdoc345KtLyBkKrL
	 aqpWukiJnUHIJRehA/GrQzwhk3naYp9gHsqHHn9Y=
Message-ID: <74edd490-26bd-41a4-81ee-cd18b9f28154@linux.microsoft.com>
Date: Fri, 27 Nov 2026 09:35:34 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iov_iter: Fix direct I/O across compatible device pgmaps
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oscar Salvador <osalvador@suse.de>, Logan Gunthorpe
 <logang@deltatee.com>, Leon Romanovsky <leon@kernel.org>,
 Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261126053433.88531-1-namjain@linux.microsoft.com>
 <5cc60faa-002c-4c96-97e3-46d3002718c9@kernel.org>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <5cc60faa-002c-4c96-97e3-46d3002718c9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B14CD80004
X-Rspam-User:
X-Stat-Signature: zqyymz688thocy6rgazw9c3wx6f6dtx7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795752341-820441
X-HE-Meta: U2FsdGVkX1971faZODPgo8I1NtIbksaOSSmWQyjL5h6vdu7RUpRqF8VloceM1lGACWlx+u/9fGzOzPRyWKM83TT5rA/ILj90Mb75TGDdmOmV5yJdxkMgFxmiqssB7NB94uCgs/LIggh/2j4jyXGLmKgUOfNT4vyXfHeNmiIu07G9KrZw6DCzL158fvkgyoENkAE2C6wz03nJUERqZRsgO3TCdMsTkbh69RmI2B6UIuhQ6cVF28iuKIXV6k2gkW1sn2DBWp+j8Wn3iOyT3Ey1rADesF+bO7ruVVvnaliBKEdMjF+gZC8no6LzWn6CMIAugsjdJOrQL6NW43sqs6979UH/LOLxq6hys9LdmxSkbL1hB/jiwqe5cA/wjYbOsWlbmIAgrZ6GPbQp9O5V/9QyC2DNcUJWdzgIRNQHs1SSgpLQIpdXeE6g+OS5N2TaGWB9e94ZYbLlKZbZLk/kjR2Zh0rBB1pdl9SRiZ5Z+4cY6af3zibBPlhGQzG48KpUyI4KLz1n6Uazm9tps4xaIes6dgxQJUypwsQWseug/wBHEWZA/nuKsm3VRd9fGABf30jN/Day7gUSXYJ5373gmgTpNDRNiOrw/BAhEAlgwykCtEi1Ije+cdJTjdT0HrBUkUA4vzUUP7ka3qyAWNm+XND/hsuk6GOr7RmTnCuDPz7qhp2KyIbfLSxzvBuzpsDUSDgb85/hhfIBxfCLRZE9oKb7XqMoZvSqrCeMGqg6F8wae7eleSGKJo0XTOATNmKHw+8bZVGs5AdRtbAjF3UHTYKjmmsOCKexDYxqv0G+D/b3MLWeIlGlx2Bn/96YYuX55H5K04aHg79XxsgcbjmCxCHg61q/CWrR/LsdpTy8/Mby+ccb6JTMaZlfMo4eUgXjnswY084+n827atxoiL1WvrNNnk/uI8LKusl+K7Xsqld9wsi8L3WFLpi7NRmg9Tw0b0Cj5/E+X0c47OY3Ub+Bhgm
 cHLj9/sL
 xdvcZAzsvJa0L1hhVrk0rm4lUgPwtNnnbNH+tZd05ySFyEz0AptZBxMubhufIYG457ZIT+dJ1QE9j2tfvEQ5wNTdctu14u+nAYbBvFDoiOu2bmkOnsG8jIPzniIvaXeDSRqdSUBvISeBK3MIs0p3zIMqmStyBXdRR2+SF6+nCYjKF4LfW4+M46+MmykiKfmM47dQHtDeif0u3jJQI8FZ1HhEZ1k0bHRGlRsBO2V9bFfPgfNJx1f7Ua25Vcy2kNbQvYVTnl75/QRSzmScS34qgixOy/jDvraMexToR1JwGux/E/t8/i6PKM5GAgR1L28zRNHaouZK50wUz+W6/z8CF4NkE8WZkGZnnAFUYtngZtjUT+sN9BFUewGPa1fn1+reqbXoU2+frK4cCktLghsu6Z4F9KVxE9844tfm0rN6QekKg43t+5FrKLlhFU6sJaO7QSe+BYlS8jrGc5QNAggWk1ujQie0lnmLBrpowYDWLDZ4cxb5wiHJivvP63hHHMaTBZMhEFgVio7VlgT4cIRoFgUOH/4HLn8ozsmQAmVC4A+3OuI4OoUabyF5LCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>



On 11/26/2026 6:42 PM, David Hildenbrand (Arm) wrote:
> On 11/26/26 06:34, Naman Jain wrote:
>> Commit 38446014648c ("block: don't merge different kinds of P2P transfers
>> in a single bio") made bio_add_page() reject pages from different
>> dev_pagemaps. This was needed for PCI P2PDMA, but also rejected pages
>> with compatible DMA mapping requirements.
>>
>> Commit 41c665aae2b5 ("block: relax pgmap check in bio_add_page for
>> compatible zone device pages") allows these pages in separate bvecs.
>> Commit 13920e4b7b784 ("block: add pgmap check to biovec_phys_mergeable")
>> prevents physically contiguous bvecs from different pgmaps from being
>> merged into one segment.
>>
>> But direct I/O now fills a bio using iov_iter_extract_bvecs(), which
>> retained the original restriction and bypasses bio_add_page().
>> For a non-atomic request handled by a single bio, only the data before
>> the pgmap boundary is submitted. The rest is not transferred, and the
>> request completes with fewer bytes than requested.
>>
>> Fix this by moving zone_device_pages_compatible() from blk.h to
>> memremap.h and using it in iov_iter_extract_bvecs(). This allows
>> compatible pages to be added as separate bvecs without relaxing the
>> same-pgmap requirement for PCI P2PDMA.
>>
>> Fixes: 38446014648c ("block: don't merge different kinds of P2P transfers in a single bio")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
>> ---
>>   block/blk.h              | 19 -------------------
>>   include/linux/memremap.h | 19 +++++++++++++++++++
>>   lib/iov_iter.c           |  3 ++-
>>   3 files changed, 21 insertions(+), 20 deletions(-)
>>
>> diff --git a/block/blk.h b/block/blk.h
>> index 50abfd9328861..460c064f1d1b0 100644
>> --- a/block/blk.h
>> +++ b/block/blk.h
>> @@ -142,25 +142,6 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
>>   	return true;
>>   }
>>   
>> -/*
>> - * Check if two pages from potentially different zone device pgmaps can
>> - * coexist as separate bvec entries in the same bio.
>> - *
>> - * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
>> - * state from the first segment and applies it to all subsequent segments, so
>> - * P2PDMA pages from different pgmaps must not be mixed in the same bio.
>> - *
>> - * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
>> - * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
>> - */
>> -static inline bool zone_device_pages_compatible(const struct page *a,
>> -						const struct page *b)
>> -{
>> -	if (is_pci_p2pdma_page(a) || is_pci_p2pdma_page(b))
>> -		return zone_device_pages_have_same_pgmap(a, b);
>> -	return true;
>> -}
>> -
>>   static inline bool __bvec_gap_to_prev(const struct queue_limits *lim,
>>   		struct bio_vec *bprv, unsigned int offset)
>>   {
>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>> index c8a4979d4c780..a1d447a847990 100644
>> --- a/include/linux/memremap.h
>> +++ b/include/linux/memremap.h
>> @@ -202,6 +202,25 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
>>   		folio_is_pci_p2pdma(page_folio(page));
>>   }
>>   
>> +/*
>> + * Check if two pages from potentially different zone device pgmaps can
>> + * coexist as separate bvec entries in the same bio.
>> + *
>> + * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
>> + * state from the first segment and applies it to all subsequent segments, so
>> + * P2PDMA pages from different pgmaps must not be mixed in the same bio.
>> + *
>> + * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
>> + * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
>> + */
>>
> 
> Can you convert this to proper kernel doc while at it?
> 
> Also this should all be working on folios instead of pages. But that will need a
> zone_device_folios_have_same_pgmap() so we can defer it, not suitable for this fix.
> 

IIUC, you want me to change this comment to kernel doc, something like this.

/**
  * zone_device_pages_compatible() - Check if pages can share a bio
  * @a: First page
  * @b: Second page
  *
  * Check if two pages from potentially different zone device pgmaps can
  * coexist as separate bvec entries in the same bio.
  *
  * The block DMA iterator (blk_dma_map_iter_start()) caches the P2PDMA
  * mapping state from the first segment and applies it to all subsequent
  * segments, so P2PDMA pages from different pgmaps must not be mixed in
  * the same bio.
  *
  * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys()
  * path as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
  *
  * Return: %true if the pages can coexist as separate bvec entries in the
  * same bio, otherwise %false.
  */

I can do that in next version. Thanks.

Regards,
Naman


