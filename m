Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B69FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1466B008A; Thu, 30 Apr 2026 04:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8C36B008C; Thu, 30 Apr 2026 04:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6796B0092; Thu, 30 Apr 2026 04:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEFD6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:12:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A502C1C09D6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:12:43 +0000 (UTC)
X-FDA: 84714505806.17.9D8A33F
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf14.hostedemail.com (Postfix) with ESMTP id 30729100013
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:12:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EzNY8XoEEipR505reYHawe6VXqEXcgYWaDsnmO6NLmU=;
	b=g6B9ZXTB/W4bg/ztKguwDcVIlNucG1Ou9WLZj7Q5fP5CRAi05VyHbftpJ3qMj5MUdr39VM
	T/Xgxyft0I2w7IB5a5Tbt6GEuUghbI8RujkTrpFxT7oiodf64NqvB2xK6XXhwKla10arG5
	PJYYWJOuV74CDhzBepj92gV1NrF+ERc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777536761; a=rsa-sha256;
	cv=none;
	b=zLb3uZxJcNs30GEyEf2ckxZBHb0+mN32fBUn0iwv3Cmjr2FosuVVneE4eFPbG+wUpDTytS
	fVaONhE0K2DmVZ7P3LQQLzhz2S13C2dv/cRe9HqY3unpo0irPNaGQRbKrosjws88bY45WY
	ExdZmoumJ493GoMIxuXG3EQJPiSURqw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxP+rqDvNpV24FAA--.17970S3;
	Thu, 30 Apr 2026 16:12:26 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxvsLlDvNprvt3AA--.31479S3;
	Thu, 30 Apr 2026 16:12:23 +0800 (CST)
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
 <20260430070217.39679-1-lance.yang@linux.dev>
 <6cdeb3e7-c399-4ead-e809-44e3d4d84bc7@loongson.cn>
 <37531e17-2a4a-44f5-af61-667331444ca2@linux.dev>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4807181d-c111-5568-b040-140706e56b4f@loongson.cn>
Date: Thu, 30 Apr 2026 16:09:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <37531e17-2a4a-44f5-af61-667331444ca2@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxvsLlDvNprvt3AA--.31479S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWr17XFW3tFWkCFWDJw15WrX_yoW5KrW7pr
	y8JF1jkr48Jr95Jr1xtw1jyFyYywn2ya4UW345Jr15ZFn0vr1jgr4UJr1j9ry0qr4rGF4I
	vFWjvF9avFyYq3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jOF4_UUUUU=
X-Rspam-User: 
X-Rspamd-Queue-Id: 30729100013
X-Rspamd-Server: rspam04
X-Stat-Signature: 9oehzajezpk34cxwmhb53zrpxfifwoc3
X-HE-Tag: 1777536759-18437
X-HE-Meta: U2FsdGVkX1+clT9ZPmdSDJvzjMDKT37hYHZ1h9jdLN+5/FZavLmE+QvD4eNp7fLi56qppnpb/h5tNDplwb82gc/Qcf/aiFndfc2Y6mWnYvl0Sr4RbDRr38E65bdUWE9YXYIbEVeWYL2nfn8p3nVDjIEbNwWZBcsK2RZXtrJxC6FkPrJ9WIa22B66Uy/mdcDfo7hpOqTC2SNBGL2IhxdBim0FXJOStCO5BvfCV1DZHt4KGd4H2upqHA7B82MotCkflTIdqmofoGwvx0I1VCYO6PbbnzjiU5rj5lfbNfidX4jv+us2XmdfpJwfszpiVswUl465ezwC0Uvy0AQWk3Nq1BVxq/YyT3VQAfHfz8K5MWHjA23FMjNyKqeVsR5gPc9O3sz3mjGdCyLMR1qKRZ0FY2wxj4rOOxP0o/cgN1R5QlDe7ECalGCX18eO4HyC0lDPad7H6Q9CBYlQq31Y+QXhA9WRYySOdeAMd3lC/F2wZJHkOAyaBo3T/NZGkM2jxDIlH+2sYggkPn4M9L+/cgoQRFTJn3jPQJElDsIyRheanO7uXy07o1FxNESh3HBb5TMzLstFwVFXKMCyjXrxfeONSMmCQG+4zvC5B0RxhCyGqkwRVBNzVnaUnDHNH0rVDZm4r+/0CxHJC3LBzyD6o+aXqhTDnHZFsZv9FNrpCSrZva1tuiBeye5AN9wc5DXZ1nBL2wL1o907oEcyvercHhrrhXuMiB6qTgczdMNJxsEc5KSYLy19az0JUhKBNqIBpNeSLKitbU4sUXrsKLUDHuUuegHMXlCUetTmiGozMZ7ETwiJTEKqr0T3FbcuCjpW28HY5u9QymaH0hjg5N/Vn+Wyjx+MWN+6frfwtOdFwjXzBwTxSmWS/2/LVVZ+buyIPJUi4vnYHEQoW+9TO+DbpcJWBl+2MsWeJL+1YfWlEjgXzteba0M8fFz/xyeSbeOyV/+QEZLmoCLzOIEWyo2JAns
 fW7D8sC2
 Yzt28lX1oI6NV/uJlVXR1DAD7i2zBwMjVHSGz0xnotdYWwbvnZGao/pi098ky1LITgY7YE8fMhr9QQ0sxIaEjk4BLKPT2rb/xF02SQXDWvspBUUkhvRCUCMqWA/9reaHYytzxC9zqFh/XcTrzQJIK7OhbEFX8y0Cuywnartk0ImiYMMgc1qxKTiItE9CVQpF83PHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 下午3:16, Lance Yang wrote:
> 
> 
> On 2026/4/30 15:05, Bibo Mao wrote:
>>
>>
>> On 2026/4/30 下午3:02, Lance Yang wrote:
>>>
>>> On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>>>>
>>>>
>>>> On 2026/4/30 下午12:28, Lance Yang wrote:
>>>>>
>>>>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>>>>> when executing command "make check" with qemu software, there is
>>>>>> error report like this:
>>>>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES 
>>>>>> val:-4096 Comm:bios-tables-tes Pid:27802
>>>>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES 
>>>>>> val:-2048 Comm:worker Pid:27815
>>>>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES 
>>>>>> val:-2048 Comm:qom-test Pid:27825
>>>>>
>>>>> Good catch!
>>>>>
>>>>>> The problem is that when application exits, rss counter is calculated
>>>>>> with huge_zero_pmd huge page, instead it should be skipped.
>>>>>
>>>>> Looks like the same problem[1] we discussed recently.
>>>>>
>>>>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99- 
>>>>> d5521f39df2a@google.com/
>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>> mm/huge_memory.c | 3 +++
>>>>>> 1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index 970e077019b7..3cbea344d4a2 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct 
>>>>>> mm_struct *mm, struct vm_area_struct *vma,
>>>>>> {
>>>>>>     const bool is_device_private = folio_is_device_private(folio);
>>>>>>
>>>>>> +    if (is_huge_zero_pmd(pmdval))
>>>>>> +        return;
>>>>>> +
>>>>>
>>>>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>>>>> vm_normal_folio_pmd() as a normal folio. If it reaches
>>>>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>>>>> decision ...
>>>>>
>>>>> So I don't think we should special-case it in zap_huge_pmd_folio(). 
>>>>> That
>>>>> only avoids this RSS decrement :)
>>>>>
>>>>> Could you please check whether the fix[2] also fixes your QEMU test?
>>>>>
>>>>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334- 
>>>>> ac7e-2758586393b2@kernel.org/
>>>> yes, I think it will solve this problem.
>>>>
>>>> Only that I think that there should be tlb flush operation after
>>>> pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so
>>>> tlb_remove_page_size() should be called. Is that right?
>>>
>>> Calling tlb_remove_page_size() is not necessary there :)
>>>
>>> zap_huge_pmd() already marks the PMD range for TLB invalidation right
>>> after clearing the entry:
>>>
>>>     orig_pmd = pmdp_huge_get_and_clear_full(...);
>>>     tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>> Yes, it is. I forget the tlb_flush_pmd_range() calling in 
>> tlb_remove_pmd_tlb_entry().
>>
>> So the fix solves this problem. And thanks for your explanation.
> 
> If possible, can you test the fix[1] with your QEMU workload and
> provide a Tested-by? That would be very helpful :D
yes, this patch solves the problem. I do not subscribe 
linux-mm@kvack.org mailing list, please feel free to add

Tested-by: Bibo Mao <maobibo@loongson.cn>

Regards
Bibo Mao

> 
> [1] 
> https://lore.kernel.org/linux-mm/4d950326-6944-409b-b108-a4e67256857f@kernel.org/ 
> 


