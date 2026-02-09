Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DCCE7E0AF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D777C6B0005; Mon,  9 Feb 2026 04:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA8A6B0088; Mon,  9 Feb 2026 04:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06926B0089; Mon,  9 Feb 2026 04:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0A8B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:37:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 667DCC26C0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:37:07 +0000 (UTC)
X-FDA: 84424414494.08.5F28FC0
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 948B94000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:37:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="MCYxIBI/";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770629825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMfba3FsPq67LjQUu31a/lCSuc8jZcI3oJ1xSlSxWtI=;
	b=lby64+uJmWx48QqibjQjdNahLxx0T/aDCrrE7d/8v/FTzBmdRzqN7YQ395ohNcHF9l0OuW
	XqlMI4yaMSca6p/qVwawjhmGrbBxtXqvKusP7zv8SdaJpbdS+ilEGb1WNaMcMteHKh31de
	JekxqVJZndWmezGq04Ge9k+IUJ1AiS0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="MCYxIBI/";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770629825; a=rsa-sha256;
	cv=none;
	b=fyMp//GUjNrNKaWkpYgQEl6CjVq75ZO3t34ShfSCaXrq46g9EKRUHWouTj7VdIPMH9vdDy
	TO6/BL5uf4+824wxP7jaCtGBeKb4IZMKY4sVDOXd8h4JDFfuuJ78FkS3HqGmlfvMafPl6p
	mqXUYUOcNlx7HaB3jISuFZ5BtGnejAk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770629817; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cMfba3FsPq67LjQUu31a/lCSuc8jZcI3oJ1xSlSxWtI=;
	b=MCYxIBI/yFb2t84oZWB0/nnRfrtEPFazz6f4DcCv4JizTYM+yTnHZ75/Y19G3YTiWkW9QHLSoqlqss+lPzxTaX4WgAtMQDuXm4HPdFtfI/SsmfWCVNJJraQXUUeoisDW6RE3m7SNP2jLZ8wa8iHz2JRBnh6vtUZ1dfkVsLIUN04=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyqQrzH_1770629815 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 17:36:56 +0800
Message-ID: <280ae63e-d66e-438f-8045-6c870420fe76@linux.alibaba.com>
Date: Mon, 9 Feb 2026 17:36:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260128114936.72280-1-clm@meta.com>
 <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
 <07d55759-a50a-457a-badd-85697174116f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <07d55759-a50a-457a-badd-85697174116f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ntxmzqkhgmn39w7b39q5d8mdixnkyrzg
X-Rspamd-Queue-Id: 948B94000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770629822-821187
X-HE-Meta: U2FsdGVkX1/qyGE28S5SogsKXUXHXtrv1XV5CNcHa7yLSHLoDwV0bOn1CVrVE0uDTaPYX0tgTEvPphrQdCOJt1kpDK9PbAdDSmimIQlPAssjkMTdI1B3U9kYigiWsGRyv/fKsSCDnmX2MV6qUOH/6xi7DYk7VUv6oiSAkpwBWCMJ5GuK45ECNXETpExVP+I8spr5omNCfZ3FDv87tqWno1MffW2kJ1tGnExJf2PQBvpvyKCSx/mMw5BhhwdFCpPmnWDgqx9Qp98guZbDmU9Nf8ejaEJHiaFoW/1tu1hJDYekVvRjl4aqVxHZtrAgbmLDoxjvaACtZR0D/bpdfYXQ/Ot0+GHjHuV4g/5weFj4e40TsLTr/8f2bJxdBvTqkNRAHvhsn5Yi+dmq7MpJvc8pC6RkCz2pKmdDCKXhNxcDGPNfI2z4fjTvxcyy7k0B/SFCISfIbGGVYR643teVKZT1+R6qE4vZoRzUSrDPzEWjWfPSwpbfT9GiAbF/YpyeDX26kt9CaLv5XWEbcqp90c0CYFNr7TUNG6s0NgjQh9CwYjl/bKZUqa9kz1U18NDvaI2AyMiHsz/9eB8prqwPYo1HoiY5JaK279D4zdWj0GyxTtMRp4ma5nUAgIhDMGoLqy1c53jSo/zic3CQHJhEZApcG+eX6e2lXPGlRRUpwGh9aIao+2yUveL8efiEwdMTIMEaSeBYtBaVFSALZForjkIYYnYLH8xf5qnQhkOBpyv5dynBdFrN1gnQkO1OPe+WqwXaR6ZBdt8WXZBxLg96hDbgupMlOunuCpHQJjeXLzeTJ+bFxeK9B89JTet6SKnmMG45lEjpCa/x/+qlXsLnMlz8tVmpGuiYb9qQWbp3UKS9B3Ju/FBDYuMT3TYH28CG1t9ctwxQp+upMJS1VWFN1cc/cgmEbRuC0i+1ZGRzkAxURd76FEojTuBwjztxG5DdUVdgQ3cWjcLjFmRESMBHP6b
 nyQl7qHN
 5PyHf5Z6n+JHxaEiwk4p4rIvALvEKIel2qEriKj4ouHLn+od8QjjjxRDFjYL0HcM5dFgSU8TQDuuLoocAz7Mi+grkiOP0/57JiF6Npe0FHR5vFJdwo1DTIY6m1ysk0qy0B4HfOkeO3L9CL8vDtI9lejSU3lWJgSTbOswkeTuy6TbTbNBD5Ztyd0Kfb7QETOZpV02y0GCvp+MFeizqgSb8qEDw2Ws1Mm6N12Pi+q22KvCyx69xk5TV90tNHnBX5XyW1rcRmNkM2y+uSLFDvlIJC4hmf8eb2kGT7TumOBLjCJwoXbbgX4cOyn5BqzA2Kf+Jf0aI03zG6BVUdhc+dGqFwKxU0iL2znz/aNt0ofcdjc4Sb9WvXAVDd1dk6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 5:09 PM, David Hildenbrand (Arm) wrote:
> On 1/29/26 02:42, Baolin Wang wrote:
>>
>>
>> On 1/28/26 7:47 PM, Chris Mason wrote:
>>> Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>>>> Implement the Arm64 architecture-specific clear_flush_young_ptes() 
>>>> to enable
>>>> batched checking of young flags and TLB flushing, improving 
>>>> performance during
>>>> large folio reclamation.
>>>>
>>>> Performance testing:
>>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, 
>>>> and try to
>>>> reclaim 8G file-backed folios via the memory.reclaim interface. I 
>>>> can observe
>>>> 33% performance improvement on my Arm64 32-core server (and 10%+ 
>>>> improvement
>>>> on my X86 machine). Meanwhile, the hotspot folio_check_references() 
>>>> dropped
>>>> from approximately 35% to around 5%.
>>>
>>> Hi everyone, I ran mm-new through my AI review prompts and this one was
>>> flagged.  AI review below:
>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/ 
>>>> asm/pgtable.h
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -1838,6 +1838,17 @@ static inline int 
>>>> ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>       return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>>>>   }
>>>>
>>>> +#define clear_flush_young_ptes clear_flush_young_ptes
>>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                     unsigned long addr, pte_t *ptep,
>>>> +                     unsigned int nr)
>>>> +{
>>>> +    if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>>>> +        return __ptep_clear_flush_young(vma, addr, ptep);
>>>
>>> Should this be checking !pte_valid_cont() instead of !pte_cont()?
>>>
>>> The existing ptep_clear_flush_young() above uses !pte_valid_cont() to
>>> determine when to take the fast path. The new function only checks
>>> !pte_cont(), which differs when handling non-present PTEs.
>>>
>>> Non-present PTEs (device-private, device-exclusive) can reach
>>> clear_flush_young_ptes() through folio_referenced_one()->
>>> clear_flush_young_ptes_notify(). These entries may have bit 52 set as
>>> part of their encoding, but they aren't valid contiguous mappings.
>>>
>>> With the current check, wouldn't such entries incorrectly trigger the
>>> contpte path and potentially cause contpte_clear_flush_young_ptes() to
>>> process additional unrelated PTEs beyond the intended single entry?
>>
>> Indeed. I previously discussed with Ryan whether using pte_cont() was 
>> enough, and we believed that invalid PTEs wouldn’t have the PTE_CONT 
>> bit set. But we clearly missed the device-folio cases. Thanks for 
>> reporting.
>>
>> Andrew, could you please squash the following fix into this patch? If 
>> you prefer a new version, please let me know. Thanks.
> 
> Isn't the real problem that we should never ever ever ever, try clearing 
> the young bit on a non-present pte?
> 
> See damon_ptep_mkold() how that is handled with the flushing/notify.
> 
> There needs to be a pte_present() check in the caller.

The handling of ZONE_DEVICE memory in check_pte() makes me me doubt my 
earlier understanding. And I think you are right.

	} else if (pte_present(ptent)) {
		pfn = pte_pfn(ptent);
	} else {
		const softleaf_t entry = softleaf_from_pte(ptent);

		/* Handle un-addressable ZONE_DEVICE memory */
		if (!softleaf_is_device_private(entry) &&
		    !softleaf_is_device_exclusive(entry))
			return false;

		pfn = softleaf_to_pfn(entry);
	}


> BUT
> 
> I recall that folio_referenced() should never apply to ZONE_DEVICE 
> folios. folio_referenced() is only called from memory reclaim code, and 
> ZONE_DEVICE pages never get reclaimed through vmscan.c

Thanks for clarifying. So I can drop the pte valid check.

