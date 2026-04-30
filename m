Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612BAFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789026B008A; Thu, 30 Apr 2026 03:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712656B008C; Thu, 30 Apr 2026 03:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9F96B0092; Thu, 30 Apr 2026 03:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 481556B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:08:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8762404C3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:08:56 +0000 (UTC)
X-FDA: 84714345072.11.9753795
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96510C0007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:08:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777532934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvBROOKiwSywWTWeQ5yb4upXZHRGZw1nxVW/gMo8cpk=;
	b=VnCV6/9dyB8jRqo4G0OHcPRH7pi0cHNz8omXy8c+i5OxnBouenTwz3GIGDodhhsDtr1mvi
	gc/g9RF4opakRqM6NokBocCuR9gVqw5AIghx1b7a6u5/5qXCnhivBkM8JffLJMTZ0k2FAS
	8eNwJZvMkRE3waIWyVgRkYYT3+A0zRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777532934; a=rsa-sha256;
	cv=none;
	b=ZXAI6WMsHkNJ00xY4cyT2JBQIsPzMBtFsBjFhBMvw8dj7rFfa0BCtJGxnBYkQhwiBUP4NJ
	lQsMpMScrSVCbMhycRRnBFGPvSUX0Pwd7adZubplKinJgRRU96XD5ILjuMpywjImpFMKmZ
	CV0W3oM+vAmxJRo/2Jcxs6fQCy51PAs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxX+v6__Jpl2kFAA--.18221S3;
	Thu, 30 Apr 2026 15:08:43 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxzsLy__JpuPJ3AA--.31891S3;
	Thu, 30 Apr 2026 15:08:34 +0800 (CST)
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
 <20260430070217.39679-1-lance.yang@linux.dev>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <6cdeb3e7-c399-4ead-e809-44e3d4d84bc7@loongson.cn>
Date: Thu, 30 Apr 2026 15:05:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20260430070217.39679-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxzsLy__JpuPJ3AA--.31891S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAF1rCr1UXryUJFy8Xw4UJrc_yoW5Cr45pF
	yUGFn0kr48tr9rJw1Ivw4Uta4FywnavFy5X343Kr4rZFn0yry2grsrGr4jkry0gr4rGF4S
	vF42vasavF9xt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jOeOJUUU
	UU=
X-Rspam-User: 
X-Rspamd-Queue-Id: 96510C0007
X-Rspamd-Server: rspam04
X-Stat-Signature: u99wdfqp5aepp7obhk6nw7xrah3nwxmz
X-HE-Tag: 1777532932-178444
X-HE-Meta: U2FsdGVkX19t2jM4MlF7z5BXEK1II7AQC5azjs5VFu5v6DmxzOzfUAc1EfF3Zvu5rzvT1AN3ISrh2szVSJpZMZrD8o6V6ynf/fgezU+j09PNW05YWiSprIraOQbu5Ure2U+OBKT/y/8oNQVzQWhDwjMtcVMI83cUwWHOp29fnJyw2qyVoF8Je+bPSuWeg+o0/KiAasyQOyHjaxp5Wkbao0O3Xl+74QvnO02QfAtDPcwZ176ppJxxLBWORRxBQKnaVh0VaYYnU3XcsJ130JYiFVTi8PURAHPQ4lk/kI+nv75XKKgl5q1HkZQFW8hyGvsBecJUUfBBOfYFFrif83vACXCRPstoj4EUpOAmtjcdgz3vvREQR3TS5FocTcU5fUje64M7frzvVOLIGakdCU8bEcTrlnUQjIln03FMkbCZ6RdQDYMQilN7WPwyq48YsofPmLyUztcKKJji82w4W9X4hA+P312YzbHDDUU96uDORtpmK+CygDchXSFkJBWUH4iKZTHqycmd1jP3PuBfaBhGkZB9KPhFWeMNe7a2TE7U1no1dts6UTDABIlU2MxDxm2ayTG4VeAxXhH1XGlLLj4uKwu0tEi1vWauGS8HElz8/zUMMwHgRFomxj1AOs3LI6ma700UX5+f/w9k1vhi95K3L/jKw5L4q1FNFZXh1L33VXt8Woqiu+5TqksoWu3iCwt0d4gEnc7EA3c0Kf8gwCSOuzsK6jAwawK2FoqRtgwF2garX5YKZFGPDvCJNtvH+0iHBvWnDJ2y7Fq4hJoM4jYutzDqyp3JYx1/chkaUFzTJRNF/vJtmkrRbrkK3I3cZ/Zhgf/6Ig22UjQddhpc014m/Gp7CQQXHxr8lw7yafW5OdEvDQpZdSlPy3w42nmkQAt51TluN9lD9Nbs0jE7FE+cGOMsQfaqioCSm2lwMqgtM8F8KzTDFPQgkIDjGyKYjKoDtaA53aQuOb78qwUk9S1
 3fA7Mwao
 wNexNbNCYAok55YY571X7f5iqUWOgFK5ZnJayIHoJlQT8QI54nPSfL9iLW4ekpv4wWLXky4wowgBwdg2wk766O9gB4lLBj8ZQSsS25eNQ8lsaS2Ckhf/SzfE7+0w9Fjp95nwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 下午3:02, Lance Yang wrote:
> 
> On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>>
>>
>> On 2026/4/30 下午12:28, Lance Yang wrote:
>>>
>>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>>> when executing command "make check" with qemu software, there is
>>>> error report like this:
>>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
>>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
>>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825
>>>
>>> Good catch!
>>>
>>>> The problem is that when application exits, rss counter is calculated
>>>> with huge_zero_pmd huge page, instead it should be skipped.
>>>
>>> Looks like the same problem[1] we discussed recently.
>>>
>>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/
>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>> mm/huge_memory.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 970e077019b7..3cbea344d4a2 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>>> {
>>>> 	const bool is_device_private = folio_is_device_private(folio);
>>>>
>>>> +	if (is_huge_zero_pmd(pmdval))
>>>> +		return;
>>>> +
>>>
>>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>>> vm_normal_folio_pmd() as a normal folio. If it reaches
>>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>>> decision ...
>>>
>>> So I don't think we should special-case it in zap_huge_pmd_folio(). That
>>> only avoids this RSS decrement :)
>>>
>>> Could you please check whether the fix[2] also fixes your QEMU test?
>>>
>>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/
>> yes, I think it will solve this problem.
>>
>> Only that I think that there should be tlb flush operation after
>> pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so
>> tlb_remove_page_size() should be called. Is that right?
> 
> Calling tlb_remove_page_size() is not necessary there :)
> 
> zap_huge_pmd() already marks the PMD range for TLB invalidation right
> after clearing the entry:
> 
> 	orig_pmd = pmdp_huge_get_and_clear_full(...);
> 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
Yes, it is. I forget the tlb_flush_pmd_range() calling in 
tlb_remove_pmd_tlb_entry().

So the fix solves this problem. And thanks for your explanation.

Regards
Bibo Mao
> 
> The later tlb_remove_page_size() is guarded by "is_present && folio",
> and is for the normal folio case after normal_or_softleaf_folio_pmd()
> return one :)
> 
> Please correct me if I missed something :D
> 
> Cheers, Lance
> 


