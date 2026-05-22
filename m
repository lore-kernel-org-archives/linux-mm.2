Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C35CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8526B00A1; Fri, 22 May 2026 01:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E426B00A2; Fri, 22 May 2026 01:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EA86B00A3; Fri, 22 May 2026 01:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E56246B00A1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2D5EC2B75
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:26 +0000 (UTC)
X-FDA: 84793935492.23.2BDED16
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA586A0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJjzg+/5mPtbxuJQNZvMHl/OOVnIvCYRjrUsOQhDVZM=;
	b=Mnl5URSlTEpyMDRRew3IMSKBfU3BnrFyK2me2q82OV1OAGNkQBQxGvYQ4yUOFZsLXfCNbQ
	yGBnGeOBM/DaGQQlG0F7L45oeLDeaQeLBCv5E6V4IokOofz026ukw+liLCISw2MP9VTZcc
	XycduL3inheS4jFqlPd6aIV8y4cfK5o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427944; a=rsa-sha256;
	cv=none;
	b=QFavY1egTYQtJ+1+57CQWpOcSwnOlIIQ4gGwiLzvhU0WcMdjG8mE5Sjz9tQ8rHQjh8SKkJ
	e8U4cn4F7KKVGChxKDzZZVOKUo7TBZ0PTaNQwFBjQTYOHZ/wNTyl7Pwxxfs4/kbXg5D3pS
	EPshcN06KyAPIDSKXWJ3bSiWBa7Z0S4=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gMDR530SdzYQtL8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:31:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AEADF40576
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:32:16 +0800 (CST)
Received: from [10.174.179.37] (unknown [10.174.179.37])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1pY6g9qirPHDA--.53518S3;
	Fri, 22 May 2026 13:32:12 +0800 (CST)
Message-ID: <b7098272-a348-d918-774a-d5d2645fc7f4@huaweicloud.com>
Date: Fri, 22 May 2026 13:32:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: yezhenyu2@huawei.com, zhurui3@huawei.com, will@kernel.org,
 akpm@linux-foundation.org, npiggin@gmail.com, aneesh.kumar@kernel.org,
 peterz@infradead.org, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, zengheng4@huawei.com
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <ag8fHYL-S26uO0yZ@arm.com> <ag8hmZ3kjtJINyIT@arm.com>
From: Zeng Heng <zengheng@huaweicloud.com>
In-Reply-To: <ag8hmZ3kjtJINyIT@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3_1pY6g9qirPHDA--.53518S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWry3Cry3ZFWxCryrGryUZFb_yoWrWw13pa
	43CF9xtFZYgryUA340qw48JFyaya1DJw4Uury8ua4FvFnFvr1vgF4vyryF9F95ArW8Gr4f
	WFWj9F17ZFWjvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: p2hqwxhhqjqx5xdzvxpfor3voofrz/
X-Rspamd-Queue-Id: EA586A0009
X-Stat-Signature: hf916cu5tagyi5xrgwsif4o5zxzurim6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779427940-532815
X-HE-Meta: U2FsdGVkX181FWwE1cr/oekeCLvdgXvl9opdfe/kNREjMG63sFLGKZdoMCZInDdLXezFCCiyEDxUwHjnU1a4LY69IAG8JR1FIh2mO0JB/HkqzoWvAmxJvLT8COK+RqFeUTWobhVe9uNwuom92nLUtiGqVe69l5wYPSOg0EBF40moCi74qp5IECg0E670lQkIzmNupQVGjICHVrEx+cWgoOBTEYSUYcSBIEh5W/AEFN6wEEzUgm/UbSzAyFVvORWLPMOZN+h4nnU2BzcLpk1npd8rTRZ6KxNfRNO5BYRfnNS5UwYunKvktURJYHB2X9C9BL5p11uZeVgirOtRe5bAIEgJFcc1rhuTM9DZTZAUqFLPFxU8KbiL2UV7vDtz4ZPqAnr/pV3qzVZBAT7enu1FMv2iTeBwX91ifupSfB/rBnGdi1WnUzQKjLycDFXMBjvv0MvItkqtuWAkbOJ90GwcRy7czVkuPxA3H5gfFqUMk4s53YoO5t+J7R0gALlUmRE8VXyX5P0HCx2uhvBJy7g099F+UI56FYBwVpDbW2f5NAftafWY+FxNcXZm5FitBwEH+Ma3BsWgbfGHGPCoHldhWzN0oc7p32EbCmvlvwBYqH080O6HVB8WtC0MyMsA6jpKLYg3PggAuhKR/gzzx0rBHANXYpIX+FhsvQO8T78yVtQSjeUXgPZpUC6aj1g3St5p+Zhbl7SXGG5fuCZJd9S28tWrRCdenJrFsLAvLAgANsGxaBKsmA07sgU/lH7TCtoTcBltWIRWc8PCEnbCS90RbMxLJb5HczDo2E2SdQOmVrHtyC53/SSYe0/A9gfafjQ8hcSSD3hiOzxpVznODLC+0iEKA+UoBeCVCPDubY5JZjPzk83S0wzX7WDxHZRv3LhdrpljFF+XtKe8DFvS6tsjbmE01/4empFl4ikiRw7iTFUhvJCPW2Kc4gsZ4pPlOGg3iPKj+509EPqmPHayyrX
 TLll9HTB
 C1TBWsrL+x/wRAI0WvcmCL9ErEBVeG3goCrgEtp9SlarMt+rcjKdZ5/Odkp4MuW7BpiuJtoACP/8uRue37G5ffNpvy8F3y2CHVm9ogsnhSbjWc0RgRGC3f/lNfoIxrV3gNFaSPultR0yFWYji0ozR2r+HOhOvjw2E0OBTi/eZuCfv2QwV31wUHKnnM1mEw4dSHK+A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/21 23:15, Catalin Marinas wrote:
> On Thu, May 21, 2026 at 04:05:07PM +0100, Catalin Marinas wrote:
>> + David H.
>>
>> On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
>>> From: Zeng Heng <zengheng4@huawei.com>
>>>
>>> When huge_pmd_unshare() is called to unshare a PMD table, the
>>> tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
>>> but the aarch64 tlb_flush() only checked tlb->freed_tables to
>>> determine whether to use TLBF_NONE (vae1is, invalidates walk
>>> cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
>>>
>>> This caused the stale PMD page table entry to remain in the walk cache
>>> after unshare, potentially leading to incorrect page table walks.
>>>
>>> Fix by including unshared_tables in the check, so that when
>>> unsharing tables, TLBF_NONE is used and the walk cache is properly
>>> invalidated.
>>>
>>> Here is the detailed distinction between vae1is and vale1is:
>>>
>>> | Instruction Combination  | Actual Invalidation Scope                         |
>>> | ------------------------ | --------------------------------------------------|
>>> | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
>>> | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
>>> | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
>>> | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
>>>
>>> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
>> The fix looks fine but does it need:
>>
>> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
>> Cc: <stable@vger.kernel.org>
>>
>>> ---
>>>   arch/arm64/include/asm/tlb.h | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
>>> index 10869d7731b8..751bd57bc3ba 100644
>>> --- a/arch/arm64/include/asm/tlb.h
>>> +++ b/arch/arm64/include/asm/tlb.h
>>> @@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
>>>   static inline void tlb_flush(struct mmu_gather *tlb)
>>>   {
>>>   	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
>>> -	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
>>> +	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
>>> +			TLBF_NONE : TLBF_NOWALKCACHE;
>>>   	unsigned long stride = tlb_get_unmap_size(tlb);
>>>   	int tlb_level = tlb_get_level(tlb);
> Do we need this as well?

The proposed fix has been validated against the issue scenarios and
works as expected.

Per the ARM Architecture Reference Manual, whether only the last-level
page table entry is invalidated is determined by the instruction used
(vale1is for leaf entry only, vae1is for walk cache including leaf entry 
and
non-leaf entry), rather than the TTL field. The TTL field merely specifies
which level the leaf entry belongs to.

Setting TTL to 0 always works fine, however, hardware must assume that
the entry can be from any level.[1][2]


[1]: vae1is instruction introduction by ARM spec,
https://developer.arm.com/documentation/ddi0601/2026-03/AArch64-Instructions/TLBI-VAE1IS--TLBI-VAE1ISNXS--TLB-Invalidate-by-VA--EL1--Inner-Shareable
[2]: rvae1is instruction introduction by ARM spec,
https://developer.arm.com/documentation/ddi0601/2026-03/AArch64-Instructions/TLBI-RVAE1IS--TLBI-RVAE1ISNXS--TLB-Range-Invalidate-by-VA--EL1--Inner-Shareable?lang=en


Best regards,
Zeng Heng


>
> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> index 10869d7731b8..3f4ab38cfd6e 100644
> --- a/arch/arm64/include/asm/tlb.h
> +++ b/arch/arm64/include/asm/tlb.h
> @@ -24,7 +24,7 @@ static void tlb_flush(struct mmu_gather *tlb);
>   static inline int tlb_get_level(struct mmu_gather *tlb)
>   {
>   	/* The TTL field is only valid for the leaf entry. */
> -	if (tlb->freed_tables)
> +	if (tlb->freed_tables || tlb->unshared_tables)
>   		return TLBI_TTL_UNKNOWN;
>   
>   	if (tlb->cleared_ptes && !(tlb->cleared_pmds ||


