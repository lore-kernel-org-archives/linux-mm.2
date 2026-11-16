Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A795B606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kEOtxs0p
Received: by kanga.kvack.org (Postfix)
	id CC7466B05B2; Mon, 16 Nov 2026 18:59:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EEB6B05B3; Mon, 16 Nov 2026 18:59:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDF36B05B4; Mon, 16 Nov 2026 18:59:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95BEB6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:59:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A0A3140237
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:59:05 +0000 (UTC)
X-FDA: 85442650650.23.935EA9E
Received: from mta1.migadu.com (out-237.mta1.migadu.com [95.215.58.237])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC9F04000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:59:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEOtxs0p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.237 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794873543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSadUDURgH4Lbi9nZMvmw3ahEKdleuYDWzgA7XRD34U=;
	b=2Vc6n0FU9/Jj3nD578MDzzpY0ktRxoxouWJ6QzdjRyssP9F4+MyaJ6MC9/mnIDWU5Uq8Uy
	Ss+NVzLXZcdKSE0QC5lqU7t60Af7IlvdE8L/RMf3Eb7hYy+NhGL2Sfm9uRMM3zm7lxOQp/
	9GhTg9JSfDcFizNeFNIYug4zzXy7Ku8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEOtxs0p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.237 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794873543;
	b=YiHzS30mSUw5UzTjY5DQpBS20CDQg1ieF9Xn6pyXTxdFIwuuAG8nW6C61nv3xfMsnzIW7R
	GLl2IdoLvqxwceh/DBG5bz32hpFQY0/yVIwpCGpjk7SuPxvugGID/fRyASGDTcuWXn8c5K
	thoaI9k5q8zYgwoFlg5ZF/c9lpi1/dk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CPjJNVI09qZx5LOZ+4kHkEmqRQ/X0wQlgwCOQWXvOUc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794873541; v=1; x=1795478341;
 b=kEOtxs0pudHCQuaacseSJKyPu3XjHI/5t42rL6p4z57hnKJNiIEmS/iIy+Qb5djq4jqhbUAO
 pEa/nnXaz8DYdJJUgewj4ILnJVEqrmDGqArfTOyDJL5c/BAuUH4he2BcdIUtMZM0PkCVjTltXOX
 U0n4qeKL1cLWGN+L+2FD1kv4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2198a1f1efd9a491;
	Mon, 16 Nov 2026 23:59:01 +0000
X-Mizu-Trace-ID: 2198a1f1efd9a491
X-Migadu-Flow: FLOW_OUT
Message-ID: <8375728d-c1e7-4033-8096-5d98d1bc36e9@linux.dev>
Date: Mon, 16 Nov 2026 16:58:55 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
 <b4a82805-5b13-46d7-bdb6-0ad2eb70f148@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <b4a82805-5b13-46d7-bdb6-0ad2eb70f148@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ob93ucsjw99txa63pjsqurn3nuk7o853
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC9F04000D
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794873542-199190
X-HE-Meta: U2FsdGVkX1+eiX1f8DGaECnwRHssZlaYOJQq0p1L6Wu0vijtOjkj8ph13BfBuOn79v9ezGGZfTgie3gy8TxUqmKbjpgnj4DfUsCnsKBWV43AXg6NCBbPqdIZINUgWbEmb3wugzAt5V/k8rdXpekZcvBu9diiPFs07/t4kah7b9pAF21EHbOjYzQJ8xTduOoUVIxMNswUYubsrIaB0ugANOsGAXKeAi8CBnegMubQ0WDzv/3/XsVXPZrS3x96Xo33Z7JwJsP+eqTEhChGk8TCR8DKrc95mAlw6fON5gjz2MHDhrZkvmRLjWSdX21h3QDbMubaqDW4SMt4BKrcuhW+c1fWyWUFVhCmZ843QyFU4rMJ74JRScCqFsM3JX6O9Ze4zwHAb2OemAEH552aVVABwcdpX/g9FMpehZd7OBf1uJJIS9tzAhJfOip+DVG/pnuyyDCQEcSEBWGwb0I2zx10oN3PWgZrPcpxvULoXcATJnxogm2kmKl1CCuHekro6edekOaI3ZyrOiUAKK2koEhGVkBvCZnZpnFWdy+Y35np860MIH8WPe6cnJStF/0bHm/o1jue8b8ZlvkypVGcjoA6qk2hiNSNh1jWCxyvAD9RCVsy+4W3FprwSoW8KuiyfKUnH9eO+JgdX8n6Los/pXBOdGvUVBlJo8rNWFNmtyBCvrwtypQwqYJ0uh6Vt3GQlhUS8wch3xw4zeWt5Hp7OrymAEHk2CIkEl99R2G4LJXvODgN0tFqB07FENs/IbMGdATGakL/hksvxhqfhuRt/OHQ97wVk9qMchxEG6Gnmr0GU0lVjxb1pVs1o7LeZZwHaF+Sdk09qGI7VubkXKDFfh9xjAGEg7TF/sGMNjEJIfcCmeJzxKNqZ3K9/ptZdr45OtKxRfhI6lpGInSMw6jLDqb7yuUSN3Y8jFgLS+PPv9gGOL+Q7alvYwXIJMnV6axBr2b0sVznCR9nLaEPG0loKX0
 y5zYTI8P
 ieF0+sXYBsy8NKMUNf+wWYUONgv7xi4FCQq/OHa4d0jlPHUblQURuev0ZFcrOpRQDIIF7qAlNH/FclF6FlwNzSyByYoTBsulqtkFDeiGmgNZm6jjCfbWA3MkC61s6qsSCuO8Bsr3T/8dvbsFZq8UI2t+QcXcXfjtllSqQOha0ajlTXZkki1re0ZONthXworFq0h80XeMeCF+tToq6lZiHn2Z41N/U+BbeOwnF7hhvwJdkEdqL6LuA+n01SRWf0ZnXPEXQtNJvnmH+RY+2GDvxIIOqV5sU+hLmlMpRCa03yGsN368qv3G/BU8hlvf3IwBjIfp1n2Kz212TiuLF4yaWtGaaQzQVRoLh/8oZYuSMaMwc3OMUFMLGz2vqgPTht8jhmwP0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 3:21 PM, David Hildenbrand (Arm) wrote:
> On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>> when splitting isolated thp"), splitting an anonymous THP remaps all
>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>> This flag is set unconditionally for every anonymous folio split,
>> including splits triggered by KSM.
>>
>> When KSM is enabled with THP=always, this causes two regressions:
>>
>> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>>     split_huge_page(). The split remaps all 512 zero-filled subpages to
>>     the shared zeropage at once, freeing the entire 2MB THP when KSM only
>>     intended to process a single 4KB page. This bypasses KSM's
>>     pages_to_scan rate limiting, causing ~1GB to be freed almost
>>     instantly.
>>
>> 2. use_zero_pages=0: The same split side-effect occurs through the
>>     stable/unstable tree merge paths. Each pages_to_scan iteration
>>     triggers an expensive split_huge_page() that silently frees 2MB,
>>     while the scanner wastes cycles on tree searches for zero-filled
>>     pages that were already freed as a side-effect.
>>
>> Introduce current_is_ksmd(), which uses kthread_func() to check whether
>> the current task is the KSM scanning thread, and use it in
>> try_to_map_unused_to_zeropage() to skip zero-page remapping when the
>> split is triggered by ksmd.
>>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>> ---
> 
> [...]
> 
>>   static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
>>   {
>>   	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 7bdcdb57652f..c33ae3fa1043 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -305,6 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>>   	if (PageCompound(page) || PageHWPoison(page))
>>   		return false;
>>   
> 
> This really needs a comment like:
> 
> /*
>   * When the split is triggered by KSM, let it take care of scanning-for and
>   * de-duplicating the shared zeropage.
>   */

Ack! ill wait a day or two before sending a fixup in case others review.
> 
>> +	if (current_is_ksmd())
>> +		return false;
>> +
>>   	VM_BUG_ON_PAGE(!PageAnon(page), page);
>>   	VM_BUG_ON_PAGE(!PageLocked(page), page);
>>   	VM_BUG_ON_PAGE(pte_present(old_pte), page);
>>
> 
> I'm still a bit unclear of what happens when the split is triggered by something
> else in the system just before we walk into this THP.
> 
> Like, imagine the deferred shrinker scans for 0-filled pages and splits under
> memory pressure. Then KSM scans and essentially skips the (now-split) THP?

IIUC, we dont skip the (now-split) THP (ksm works by page, not folio), 
we would only skip over the parts that were remapped to the zeropage. 
and because the shrinker already split the folio, it wont end up even 
needing to split it.

Inversely, if ksm does run into a large folio, it splits it, but doesnt 
do the remapping. Which KSM will either eventually deduplicate itself 
(and in the case of use_zero_page=1, it will also do the zeropage 
remapping).

I asked our robot overlords if im missing anything and it did find this 
potential issue:

KSM could trigger alloc/reclaim that would then prevent the zero-page 
remapping for any reclaim done under the daemon.

It did suggest this fix `current_is_ksmd() && !current->reclaim_state` 
basically check if we are in reclaim and ksm. This would close the gap.

Or we could go back to adding a flag to split function (but i believe 
this is still somewhat cleaner and doesnt complicate the already messy 
split code).

Cheers,
-- Nico





> 


