Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B17DBCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 04:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA606B0093; Fri, 22 May 2026 00:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B9B6B0095; Fri, 22 May 2026 00:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982526B0096; Fri, 22 May 2026 00:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86B9E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:44:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A338140186
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:44:11 +0000 (UTC)
X-FDA: 84793813902.30.076F97F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B1E710000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:44:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779425049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wYb7vYqAepxFRoH2FPAszzpLKYcZBm7rEVsl9vC3Ll0=;
	b=BCWcH6yTxCfiKGY8aeZ1cOBsAzMXBE6k8H+scRnKEWGpmOPNPLOTtfMjuDVInw8JR8doe0
	XdnkhkOcEohLlyrQxuVGhw+6FHQo+nY4k6AT6jD3A3MXxNpAmz6nM4mvi7YQ8gRV2m1JcW
	t2Ktuw0d7BUM740tbd2uZcjJnmQwIgI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779425049; a=rsa-sha256;
	cv=none;
	b=L8fPA6w5VeTjA/4iA0UtWFyzYfC/NBQrCG3GL8zHDXmTXl87dqa2RiSAQAYu/cgZyEt6zF
	llofpQBLTVl+u13rDrP1xyvfeq0YL5i0W/wKG5LkH5r08agYOmBA6Mz/tAalug3Aeical1
	+r8ohh2Q2HmZsrJ09A57oFM5NLtCKeQ=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gMCND6HNQzKHLv5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:43:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0541F4058C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:44:03 +0800 (CST)
Received: from [10.174.179.37] (unknown [10.174.179.37])
	by APP4 (Coremail) with SMTP id gCh0CgBnL1sL3w9qXpfDDA--.53130S3;
	Fri, 22 May 2026 12:43:57 +0800 (CST)
Message-ID: <d78ebf12-075c-5abd-d83e-f66f0f45e92e@huaweicloud.com>
Date: Fri, 22 May 2026 12:43:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
 aneesh.kumar@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org,
 David Hildenbrand <david@kernel.org>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <ag8fHYL-S26uO0yZ@arm.com>
From: Zeng Heng <zengheng@huaweicloud.com>
In-Reply-To: <ag8fHYL-S26uO0yZ@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBnL1sL3w9qXpfDDA--.53130S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWkGw4UCr45Cr43Cr4Uurg_yoW5Jr4Upa
	43CF13KFZ5Wr1UtF1vqr4UXFy3Can8Jr9ruryrZasYvF12yF1vgFWvyryruFy0yFZ5tr4f
	WF1j9FnrZF4UZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B1E710000D
X-Stat-Signature: kwfr5hbxe8ku4jn79c1btytza5ddwtfw
X-Rspam-User: 
X-HE-Tag: 1779425047-315517
X-HE-Meta: U2FsdGVkX1/juE+/iSeITVQY6T68eoBvXuAAKbaK0oJ565JMiR70WDhL/Zsk06oemwSSoFZhnPCqaQFxQaBCOlOdYVjVzL8zaaV7PHhwq1N3xHJbY9PGPjKIQwz3/7YmOgYcDCSybbPXbC9EKlaxXwIvV63dvpv7DJfWdn7/g9fSCod6SznEwKOjETcm9HktBidNVSWoQdoX01qAbPawLH+Vg+x7wKtsLbgx0UpnJSfuXQ1i1dWi0QNFUQZ2LN/SR6LltihV0GifeH5FG/sMYoNHG2TskJZ5YZEEEGfhuH/vYQ/Yy9/NnuXBhuHrDgSaPwVlIfddGdUWGRB8jGV8s6wvYt0Jaqy9MGkABSFyUXNaw+OuIaiV8t9q+mHrkYN7Eo2TrZ0eSHavhPYWB87QC9VG6916ZVq8EZgGSZJqSNPJKbXVXA1HC9TU8SrULGt9szzkvtvXL7qIqSl0+/820i0S4TlJagINcaw/s1nxsLi6dey+A8lqJQwtUzWz2m6i+K/1dv4Ffeit9sl54bTuz8j3oEHcT9f9sXvZfeRiniUE4U1rAUQZFnyeEpTVnUmhu7SvYce5R3OxH8RAvxCmmBFLHkMcqWbs/tXnLRPg9PWNStDya3OlLoizxd2nGZcgqQroUm4VwiISW+1gFea2pS4E4VxYDyGUkBzc0bGMAsDCOI2fSi3GACHtFlgxLe2z6Oi2AT6gDfwhddhKZLsw6EkiX1aw0RQrBLMBrEVaGZgfXBZKAdUS/vrB7QlumLBvdXjdDjE4tsBt3qmkTGLwGiBNkdmaSo5dHg2fWNxmDl65osv08SN0TXCkMdqWHRwASR8u0rwwRbZ9SHwzYpLFn4ZcpPTvpryxht9vTIlPF+8+bnrexvUi/8jDDy1p+9xgHDQpH/X1yRFsGRDf8g+uiYdvsy76m1JgD9x6AE9XhbYTks9LvEyeszGaN9nKwM7q8MX6nr5qDLYcaPJ0D3/
 QPqHbVO2
 0v6S/aQx+4E3lvscjwJAeOCpoAElpv/iddO3c8Mz9EL5r/p8Tp/WTwzauYxO7R+XiaOotUdfqXMveN3+OxX/fJwbC/6fK/9R6ogNx1LFCdFHToFcrpCHbBJivRsQ6j7wzy5kK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Catalin,

On 2026/5/21 23:05, Catalin Marinas wrote:
> + David H.
>
> On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
>> From: Zeng Heng <zengheng4@huawei.com>
>>
>> When huge_pmd_unshare() is called to unshare a PMD table, the
>> tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
>> but the aarch64 tlb_flush() only checked tlb->freed_tables to
>> determine whether to use TLBF_NONE (vae1is, invalidates walk
>> cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
>>
>> This caused the stale PMD page table entry to remain in the walk cache
>> after unshare, potentially leading to incorrect page table walks.
>>
>> Fix by including unshared_tables in the check, so that when
>> unsharing tables, TLBF_NONE is used and the walk cache is properly
>> invalidated.
>>
>> Here is the detailed distinction between vae1is and vale1is:
>>
>> | Instruction Combination  | Actual Invalidation Scope                         |
>> | ------------------------ | --------------------------------------------------|
>> | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
>> | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
>> | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
>> | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
>>
>> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> The fix looks fine but does it need:
>
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: <stable@vger.kernel.org>

It makes sense to me. Thanks a lot for that.


Best regards,
Zeng Heng

>> ---
>>   arch/arm64/include/asm/tlb.h | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
>> index 10869d7731b8..751bd57bc3ba 100644
>> --- a/arch/arm64/include/asm/tlb.h
>> +++ b/arch/arm64/include/asm/tlb.h
>> @@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
>>   static inline void tlb_flush(struct mmu_gather *tlb)
>>   {
>>   	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
>> -	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
>> +	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
>> +			TLBF_NONE : TLBF_NOWALKCACHE;
>>   	unsigned long stride = tlb_get_unmap_size(tlb);
>>   	int tlb_level = tlb_get_level(tlb);
>>   
>> -- 
>> 2.43.0


