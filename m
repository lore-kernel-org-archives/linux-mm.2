Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951F4EC1EA9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077C26B009B; Thu,  5 Feb 2026 07:08:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0601A6B009D; Thu,  5 Feb 2026 07:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5EE6B009E; Thu,  5 Feb 2026 07:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE70E6B009B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:08:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F5D71404D8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:08:06 +0000 (UTC)
X-FDA: 84410279772.21.2CACA14
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74D3B180005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:08:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Crg60wv25jXHKuxNXIGjoQAGfAi3sfj+K49eQfX0K+g=;
	b=ZXGOI+bjENNVXMLVoKRLX01282MoQbghlU56errKT41jEC1K1lU6h+UlXu9ED6LzkkDtPF
	OK8leCSoZuHF2n86oCzdqi0DjkDpRjSFDj+d8BDZNdZK3f/fHqBbkgTS0RiJOG54mNSkqv
	XHkXuoRxnyegDOZzFVCGwcy5xYLh+nY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293284; a=rsa-sha256;
	cv=none;
	b=KYdR8CkZm2tplFtmSmqihbUFcPGERnOK4KijOSCyeMMkxr22Ex8d1dc1uCDiynQ37Gd79a
	ase92tCRX0Xm0Kd792GSqsXy0iZKkSGJMcsB0Wqix3qP7WmKh4g61Hy2fY1iPkOy2rARxP
	LiFq2dWGYNvj3I+auWJDDRVTsEgsiU8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2408339;
	Thu,  5 Feb 2026 04:07:56 -0800 (PST)
Received: from [10.164.18.70] (MacBook-Pro.blr.arm.com [10.164.18.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D68B3F73F;
	Thu,  5 Feb 2026 04:08:00 -0800 (PST)
Message-ID: <4f719bed-89bf-44f3-a1cc-39ddc7c66824@arm.com>
Date: Thu, 5 Feb 2026 17:37:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>,
 "David Hildenbrand (arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p49wrdixf3z4s8ouq3uddnwqobtqps5e
X-Rspamd-Queue-Id: 74D3B180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770293284-578505
X-HE-Meta: U2FsdGVkX1+5y2TiW3TKAOWJIgVdi89TQU7LDK0B+hmtTFE8UPlWhiSn+2krzo/y7B0jOwmQPCvCXX2VyOp40o1dyO7nw7Q3D4yS8CfeC2mVnngxTk3367/IXQ9FhFo9lnFO4N7TXVehkjro8FGF6u2QVvnxABiw5ulItjFeDMWyvNzAeU5vy/nXJ+0JBJJLDt5SR/hTp7R0KQAF5KeTh75FZYSiKNL8NJa8UYTpQUwIngUeoJFlkH5VJuz2+KuiWYjpG/PmfUuB/mfApENfPueznHyevbreicV5cezisOE4Xie3lu1TdFXACC6xVBSIFBqIA9b6ZWMqny7ElfDmkNSmKImagllWdS7gTQ85t+TdrwZNROres4Oo9TtDK6LwBYWz709CbViHRC4yBkuOzzeebGh81YrQpbPXGxQUxbFpmeo3faGrx/gN43sDedXmhJsFxj9ZpzYQID9zaecsXDFiRo2cL0zidCbchPVrhWBBqGT0g+tDywz8pQoCKXSlpW/1A3DeDyJ4AIiQx9LQEiu7wFyCKPczHZZbosUgLdlymXIcaCyk083WSzviqSclR3UwQTp3Li0+8ftYGrFvxJp4+pMkkgcwucgJsN1RZH3jOQDnIdyB1gnJZaxFiB8A5RID2YxzjzZKpY6mbONgYygMMqI0HfSx74So7BGOCSqCkOlwkhLm/S6Ah05GnODSIWZQFbbqxYILQ5KvvDpQu+B4eI8rrrR1w530jyrvDxlhvWF2GdWJGzSX4PFSYEkm46smQCah+iK+02bmfOnRdAMmOY5fY+SMmu1U+IyuUefCsOeEOirOqIZUvspstiWMiWno3wfR0tlXLVLs8XC52TBboagwdnaFx+GFsvlHtX0n+TQbB2Jg+dkqlE8yu31o61cGFDsCBb1UWEArWT18UMPdx3MSUDSM8wbOK3yxwV8XHtVpZxblwh5DRmDeJMZ5nX/Mk+E2qe3H7Z97C5B
 4mHJBdaW
 6pmcV8f1p8eC3neTnVV/6wgCarabxHnWZQiuperY0D86/SKJk+5JYi2CcwGr05uGRgDtwhwOYfxdXlWPOfmrXMndsOoft0KElU8LUZYQZt59kAdg1EcdaXroNsJcwOs/CP7mCPwlXG+TAe2u2oGUGqNCs6tJgWEYn4Q/ssupuvjuVfQMFpaw0SQRPNHhdCNSmArIK018B8P0EPx52lNTSUf+AuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/02/26 11:38 am, Vernon Yang wrote:
> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm) <david@kernel.org> wrote:
>> [...]
>>
>>> +     if (cur_progress) {
>>> +             if (_pte >= pte + HPAGE_PMD_NR)
>>> +                     *cur_progress = HPAGE_PMD_NR;
>>> +             else
>>> +                     *cur_progress = _pte - pte + 1;
>> *cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);
> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>
>> ?
>>
>> It's still a bit nasty, though.
>>
>> Can't we just add one at the beginning of the loop and let the compiler
>> optimize that? ;)
> I'm also worried that the compiler can't optimize this since the body of
> the loop is complex, as with Dev's opinion [1].
>
> [1] https://lore.kernel.org/linux-mm/7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com
>
> If you have a strong recommendation for this, please let me know, Thanks!

I haven't explicitly checked with assembly, but I am fairly sure this won't get optimized.
There are two cases where it could have been optimized:

1) Had the compiler inlined hpage_collapse_scan_pmd
2) Had the compiler done something like
   if (p) -> foo(), where foo() contains the complete for loop, with the increment
   else -> bar(), where bar() contains the complete for loop, without the increment

Both of which are highly unlikely because of the complexity of the function.

>
>>> +     }
>>>       pte_unmap_unlock(pte, ptl);
>>>       if (result == SCAN_SUCCEED) {
>>>               result = collapse_huge_page(mm, start_addr, referenced,
>>> @@ -2286,8 +2301,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>       return result;
>>>   }
>>>
>>> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>>> -             struct file *file, pgoff_t start, struct collapse_control *cc)
>>> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>>> +             unsigned long addr, struct file *file, pgoff_t start,
>>> +             unsigned int *cur_progress, struct collapse_control *cc)
>>>   {
>>>       struct folio *folio = NULL;
>>>       struct address_space *mapping = file->f_mapping;
>>> @@ -2376,6 +2392,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>                       cond_resched_rcu();
>>>               }
>>>       }
>>> +     if (cur_progress)
>>> +             *cur_progress = max(xas.xa_index - start, 1UL);
>> I would really just keep it simple here and do a
>>
>> *cur_progress = HPAGE_PMD_NR;
>>
>> This stuff is hard to reason about, so I would just leave the file case
>> essentially unchanged.
>>
>> IIRC, it would not affect the numbers you report in the patch description?
> Yes, Let's keep it simple, always equal to HPAGE_PMD_NR in file case.
>
> --
> Thanks,
> Vernon

