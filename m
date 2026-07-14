Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D82DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EACB6B0088; Tue, 14 Jul 2026 02:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BCB6B008A; Tue, 14 Jul 2026 02:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CDE6B008C; Tue, 14 Jul 2026 02:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF0CB6B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:45:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CCF7A0289
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:45:56 +0000 (UTC)
X-FDA: 84986447112.26.6071B7E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3592680002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:45:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjdADVBa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784011554;
	b=UE8oKFteWov87HLNPIFWziBpRptBBP0e42U8m/Bt8TIj9z1gcL/K9IF2wMYMv6kMR2u0km
	KSZBFUrqifaeqdBUC6G981tIk3QKXZieBZ2MCjr03smuPj0tMS++Ax56x3kwMI6tnDaEcl
	lmA7dq5n2h9NRRtrbPkFByqd0IlK6iM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjdADVBa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784011554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glghTutpEqXPnCOEeCh4W6AO1yrko6RLNG5OdFNkMv0=;
	b=JtS95QVJv6tR8XqA32Nrc6kRvzvEwY8zmbVK+2Pbzl83Q28qOy785mkDqATO25Af5pvSJ0
	LV4KAY9xs8QVTa+fVju1IDlai3wGVLOXAtb7cPmIxBq1JzOBz6H1Wy14cH9/vR9Sz3u7xU
	jY68cIVEVD5Rjiy7HZIHBQt1PHRqoEQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9BA11477;
	Mon, 13 Jul 2026 23:45:48 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B287D3F7B4;
	Mon, 13 Jul 2026 23:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784011553; bh=Hc0hzyscuk80FwBKUVOH73LX4dEOMupwQvGYeR9hS2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mjdADVBavbIfoQjjnjGAOKAsOn2SXw9RUkr+c9HkpzsjGg5F87xy9VajsbDz/hcD6
	 uKVLLFNAx7UapzoLhWhvYbppY8tZqx610mKhSI2M1QU0flV3xrwBv3jOGyHyM0n4mC
	 z1k1iHtkbnzeurZPkAHfsX9+cb2E+pFI9TkHTGgo=
Message-ID: <945bdf1a-10f8-41fd-956e-af40af809c7b@arm.com>
Date: Tue, 14 Jul 2026 12:15:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-5-jiangwen6@xiaomi.com>
 <85a3a79a-2a78-47ed-bd93-48e8f1967551@arm.com>
 <CAHKocdH0KYPaqkTOEE7n8vX4BFdgPvVbRsh3Vtb6MtvmCTn4XQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdH0KYPaqkTOEE7n8vX4BFdgPvVbRsh3Vtb6MtvmCTn4XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3592680002
X-Rspam-User: 
X-Stat-Signature: mzrmjqqhp8b3x5o5ay8tcymtcb1geszj
X-Rspamd-Server: rspam03
X-HE-Tag: 1784011554-614506
X-HE-Meta: U2FsdGVkX1+cJr1iYMEAw9zr7StTSnKrDXEIWW6zKqlO4Xqciiv+kf0lvip65GIZ2UjTZP9uoauBqimVk2b3TZXiZMcNk/NSHKcSp0CYMgah175w51H5Q/5uQt73pKTYtWwRueOvXlqyJrSwfhh8cCEJm0/GEtso2Wd8yIVSobnTIsvkRDQFUyLSuWTdQ4LMLqrBGIoW9zyopz1J1H0WhJs+Cn8NNXECiggzh0zyOeT4RGr+XK8HiWw6oqf3ndmAa1rv718eFCq1wmskByWBZb9YfYzH/j34rXl2nUkG5MTwFUy2ay4qiF4+IMXDG+8uki0a2m8Xi7vW8fW6TznXINBVHacNWKfQp1CJpF1A2CP5a+Rb3qa0ECl4ntClxO+CQJ9nQBka8I+rz+NP0/AXIvRuB8RNUR9BbEyd8nNiGLkrEm1h3gJ8x2mPZaq3xece/BxiRjVkGvTN3jzB01oss5Dz4hSWkdElHpX9yYWM1UwWUVshDItvVJXsUFp9srzf7zX+z5eyWnMkkF0auLuo4Q3Go0Egd/7Zmn8BndLP1rTwUfqb5XM7KfYeP/Axt6KA4ozjnYHmHqTpt4ZOa4xxV7R3CgZF+QonL4BGqeYnZNq8gagxJ58Cs9B74KcgWgUo1QjIS31CHYsri+MbV/ni3U7iDMfcoNf2YIabvKfKYG0xA9C+6dv65Lv8h1YW8d8TJWA1pqEs5bTUDknWuhnNKKXYv7F5OCh473Dqf6yP+cYzkWegBT5DOR5kA52WRTt59RG9GXcUUfQ0EKQDaDMQ8abdQN74ivOdkBsVWC5RsaivQjmdhLq159jWA882awfJ8zdIUGIxqFLylMQ/kFiFTZ+uz1R5QB0+Zd4f4botYNSRkMhUc1oJXvTHTWiQNmGbcliDWxqx5+dfiToeHhcBANOdHBg0zTADVVHj3mE14Rw7nXSPw5g97o4MIUTu+Wd/q3w3k36JUM/tiD1MrwM
 Y0RyB/nB
 e+r2zW2fQFt4Un7v4NOQ+FGCCdX9XvbGloZbo/IY/vUIwn6Q7KnlNY+mcAZED4LxcanwDbL0QGp8ehPtMM/QlmC6dbSESvhAGuPr/W1Gvist/UdyAQzOs30F7X+IAWrb9dAAzr0enbr6CkEsfcZLxobKwHeH+ZaxLdSV7BtE4pRzuT43Ne/1eP6TYOykNVYMnTk6wv+1mNWwysL44zoTmwhwrwR5109Mks0gvVdVPmhLRuEw8e3lalGXSt6JSFMdDOe0ENkTxIcMl21tu11E8WrZ2eYnkPYxZc/1b2PdH9WG6ttRJrbsRG5qva7xVF8/Ls2GgF7L4QqaPA2LWHysEkA+5I/iZqVsq2KE12IWa6YnDRKovNDS5PR9dwJKMnGTIRc7qFSv97bSWY03WNZLrVasiOO/dO9bdbQ6KCANxs2M7fz6t4R3rFeGN9kAJ400yDR3d1YDUhdOK+fSGfWaGmSWrTQnBGaqw43/AYeTqbJq/9M0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/07/26 11:40 am, Wen Jiang wrote:
> On Mon, 13 Jul 2026 at 21:49, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 09/07/26 1:08 pm, Wen Jiang wrote:
>>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>>
>>> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
>>> provides a clean interface by taking struct page **pages and mapping them
>>> via direct PTE iteration. This avoids the page table rewalk seen when
>>> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
>>>
>>> Extend it to support larger page_shift values, and add PMD- and
>>> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
>>> since it now handles more than just small pages.
>>>
>>> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
>>> iterate over pages one by one via vmap_range_noflush(), which would
>>> otherwise lead to page table rewalk. The code is now unified with the
>>> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>> Tested-by: Leo Yan <leo.yan@arm.com>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
>>>  1 file changed, 47 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index d7fef85b241c4..d2a4d649af549 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -125,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>       pte_t *pte;
>>>       u64 pfn;
>>>       struct page *page;
>>> -     unsigned long size = PAGE_SIZE;
>>> +     unsigned long size;
>>> +     unsigned int steps;
>>>
>>>       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>>>               return -EINVAL;
>>> @@ -147,8 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>               }
>>>
>>>               size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
>>> -             pfn += PFN_DOWN(size);
>>> -     } while (pte += PFN_DOWN(size), addr += size, addr != end);
>>> +             steps = PFN_DOWN(size);
>>> +     } while (pte += steps, pfn += steps, addr += size, addr != end);
>>
>> I think I had also recommended to put these vmap_pte_range() changes
>> into the previous patch.
>>
> 
> Hi Dev
> 
> I put this change in patch 4 following Uladzislau's earlier suggestion:
> 
> https://lore.kernel.org/linux-mm/ah3Cn3YnefIVJDo2@milan/
> 
> Uladzislau, do you have a preference on where this hunk should go?
> 

Sorry if I wasn't clear enough. I am not contradicting Uladzislau's comment -
separate patch 3 and 4 are good. I was just commenting on the specific change
you did here w.r.t vmap_pte_range.

The only bit you change above is to introduce a local variable 'steps'. You
can move this bit into the previous patch, so that patch 4 is completely
focussed on extending the vmap_pages_* functions to accept a 'shift'.


> Thanks,
> Wen


