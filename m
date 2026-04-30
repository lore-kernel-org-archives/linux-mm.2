Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B58ACD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C726B008A; Thu, 30 Apr 2026 03:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD4F6B008C; Thu, 30 Apr 2026 03:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F44A6B0092; Thu, 30 Apr 2026 03:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF1A6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:16:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C79A1601DD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:16:28 +0000 (UTC)
X-FDA: 84714364056.29.ADF394D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3319D40007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:16:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VmGGCE3h;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777533386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMif5YaFdMKdpNExsymbLQ/P3y0xhUVDlzi/+K+RFcU=;
	b=Z44gXYufp2/ZtKszx716s/hql1WbkXc6Z7EmJDflSB9+QljLP+7DAIZRgNukIHPyLDQVb8
	fe9Vo0uYHTrXkG9aKYOOEhcjYUDoXtUD0XSSRk7nxXcTkUGMOEqxLJCnD8vjDZYf36a1SH
	jWkhjAr9qk1s1nHBqZ4E6E/flOqI9Us=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VmGGCE3h;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777533386; a=rsa-sha256;
	cv=none;
	b=GY2cEzLPAeXZnH4+pIs7pGuvGgQlw4hrRSPjt2ymSr/gujn/uLS1QvacjqoahFEvy1qVd/
	JBbRhUOOEgkfCf8DvtA21xt9vcH/osbZZnZkLHxcSwmjig01OTS2WgQuB0H+/z3KQi/zaM
	nxKsl82noDGrX47hGt3o7l+fgXq3+C0=
Message-ID: <37531e17-2a4a-44f5-af61-667331444ca2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777533383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nMif5YaFdMKdpNExsymbLQ/P3y0xhUVDlzi/+K+RFcU=;
	b=VmGGCE3hw6fcephCk88ccwFrZv4tJWQzk03j4PbAqmaZWra98yAYE9+jf/y3l24xYDaQAN
	kU/BEfw7RCxyiiuDgXV9/NiAaHE4G21dRSeQT+XDxkf2aokoEATDdJ/Hk2z0wBmrrGD4Ly
	VwLfuPqsWbgQFvxqZM7lRhVB2LcFbEM=
Date: Thu, 30 Apr 2026 15:16:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
 <20260430070217.39679-1-lance.yang@linux.dev>
 <6cdeb3e7-c399-4ead-e809-44e3d4d84bc7@loongson.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6cdeb3e7-c399-4ead-e809-44e3d4d84bc7@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3319D40007
X-Rspamd-Server: rspam06
X-Stat-Signature: hys31bw18wq7wfx46ft9rf9pn1joaemb
X-HE-Tag: 1777533385-390655
X-HE-Meta: U2FsdGVkX18sDD7xF+Sctsjy6v7fSN/JwG+2hbOE3Mq4xnxz160FaY0jieRSDJ2A+AvSzQkUaB+zJ0Uh7CwY9DMF+nOlipRahHE0LEA1xRe+Cgq5kNj/dSMuTnAWOcdlEHXpjV+spafItu/zG10ngZWU6i1j+NRxN3Eg6hTbtGhBwAR8Lg3roBudZkgK2tcW53Pr3SKWD6Mzn55onPn08MyHslQN/7+KigX207XMExE0x7m1hhSfy/dXHdSPiQi0jpDG4r5cboNy0JVISk0YdQoUXEvzMp8FkkDBz8PEwe7UvzZTU2+zyF0WaZjVBmu/Gd8iYf/WiCw1ABJwvdzvzQc5V1/R0Mb8ho6GF+5HRJs5JCPmxRFr19fQgGOrcJHZs9YjFXdc2EeMwWY7em29YiDiccy9mEM0RR0N8241pvYJSUrLXilRLrL9DAUqqnbyRW7p5EKltLO9FjgSPCn3p0fbdWI2hCWmGV1gKnySuPSjqz716S2skPQ5AXa5johHa5hMKuW9EbdsulEWEkFRzpQUs2RiJlSLdbyUCCvXgvDAQ7f4DYudTSPptiufD+veR0a+QJ3Yf9diEGXYJrP+yGzlHVagdLVjWzSbeTE0FpNlmaHWK4A8ZZS6ShTvEOarpR9az9ON//GryXqKvw2FNPuGXnEuJCBExNCDih0hhHhtCfJomZ3CxrqfAc/itZmkXhA4ZVvdhGgKf5TD75UtIKuPdv6sdIsdKms/f2pQ2oaVVvvTD0UZ9doi6ERFNtjpalBsTdJhC6gQy1i1zzxwsrJWvREEsaxjPP11+7GMja6m8wo8sitrqMV0XwDH4z5TPRojeNyONUmgylQlyPw0JT2AMAhWN9EeRnSgxE4DfxOBqOa7KxUK9VunGYpUW7IgguwMo1Dpduk9ueWP05KCfA/u+xojUiHHjcaiWmiylRJrQ/cBlAEipL0iJ049CoqtLU4KTGrFXLPNRznYw5j
 Hr1axSOD
 69YpZ4Et1ZZP5qztn5I76CxB9PN0UDMDH0eVMJ79wQhf47+LkLcTSm11APNGkUiCKF8wUA4t1tuFM7ZtvXbrsw4A+93sHGLWtue+KX7l0w/El34tQIGayayngqF/ULDz1XuZpprmVAVMPaK9xm1I0RFAuagriA841tiU4cd8GLaRQUobY7/b4KCwEgJBgiMy4kDmF+1xDpQmdMLVxZvdbb/bI4/MXIAfRYgX13awPBzPmpj1ssOVesFwPUA/DKDID7m+YElFf0pLLq22A3K3VTlRtkgTsIjU0f+BXfaMcXI5cX3WPbcLCAAuREEz6OoXBduB+rmHDvHBrFeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 15:05, Bibo Mao wrote:
> 
> 
> On 2026/4/30 下午3:02, Lance Yang wrote:
>>
>> On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>>>
>>>
>>> On 2026/4/30 下午12:28, Lance Yang wrote:
>>>>
>>>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>>>> when executing command "make check" with qemu software, there is
>>>>> error report like this:
>>>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES 
>>>>> val:-4096 Comm:bios-tables-tes Pid:27802
>>>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES 
>>>>> val:-2048 Comm:worker Pid:27815
>>>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES 
>>>>> val:-2048 Comm:qom-test Pid:27825
>>>>
>>>> Good catch!
>>>>
>>>>> The problem is that when application exits, rss counter is calculated
>>>>> with huge_zero_pmd huge page, instead it should be skipped.
>>>>
>>>> Looks like the same problem[1] we discussed recently.
>>>>
>>>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99- 
>>>> d5521f39df2a@google.com/
>>>>
>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>> ---
>>>>> mm/huge_memory.c | 3 +++
>>>>> 1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 970e077019b7..3cbea344d4a2 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct 
>>>>> mm_struct *mm, struct vm_area_struct *vma,
>>>>> {
>>>>>     const bool is_device_private = folio_is_device_private(folio);
>>>>>
>>>>> +    if (is_huge_zero_pmd(pmdval))
>>>>> +        return;
>>>>> +
>>>>
>>>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>>>> vm_normal_folio_pmd() as a normal folio. If it reaches
>>>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>>>> decision ...
>>>>
>>>> So I don't think we should special-case it in zap_huge_pmd_folio(). 
>>>> That
>>>> only avoids this RSS decrement :)
>>>>
>>>> Could you please check whether the fix[2] also fixes your QEMU test?
>>>>
>>>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334- 
>>>> ac7e-2758586393b2@kernel.org/
>>> yes, I think it will solve this problem.
>>>
>>> Only that I think that there should be tlb flush operation after
>>> pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so
>>> tlb_remove_page_size() should be called. Is that right?
>>
>> Calling tlb_remove_page_size() is not necessary there :)
>>
>> zap_huge_pmd() already marks the PMD range for TLB invalidation right
>> after clearing the entry:
>>
>>     orig_pmd = pmdp_huge_get_and_clear_full(...);
>>     tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> Yes, it is. I forget the tlb_flush_pmd_range() calling in 
> tlb_remove_pmd_tlb_entry().
> 
> So the fix solves this problem. And thanks for your explanation.

If possible, can you test the fix[1] with your QEMU workload and
provide a Tested-by? That would be very helpful :D

[1] 
https://lore.kernel.org/linux-mm/4d950326-6944-409b-b108-a4e67256857f@kernel.org/

