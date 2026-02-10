Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076DAEA8106
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 12:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45FFF6B0088; Tue, 10 Feb 2026 07:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4333E6B0089; Tue, 10 Feb 2026 07:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3392F6B008A; Tue, 10 Feb 2026 07:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 200106B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:01:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB5C0C1FF8
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:01:33 +0000 (UTC)
X-FDA: 84428407266.28.C18DCB7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA7FD18001D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:01:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770724892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ubwz3PJ5KFwF6j/mtmwUIbJPRZuOw2B/aSNEd0KC2Y=;
	b=pww1wA17TYSqXL29mxYJP4IIEIwBrb2M8YOw3tAgAETaeGpeNiQ0Ahu/RMAyvDwDhWT8YI
	2LHyA2s+H6RrdeaKh9e8/TLx8aNJ9bFpYtYK8aWGLsAPzMDjv0YZEtV3YsJ2QWqR0dZ3jQ
	CDrY4D2Kcton8iHYm/yJN/S+VvnoxBw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770724892; a=rsa-sha256;
	cv=none;
	b=pUFdfE2V94W1MTJGThwHhw4nveAmp9LxjVKC0hjXBCVnie9PkFiNC8hMeEt+qdAn/YKi3B
	ALq2tu+AIYnAYCgd4md68rx2FWMq8GYuaNw4vN/ROKRPSUMmuYMA+I32LQrSDLL6fdNnup
	tt+mJHBrBwAawnrn9zAdUDwXeZpHxXk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C1BA339;
	Tue, 10 Feb 2026 04:01:24 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A7E63F632;
	Tue, 10 Feb 2026 04:01:24 -0800 (PST)
Message-ID: <ceece57f-e845-4557-8ec8-0f4935f8d03d@arm.com>
Date: Tue, 10 Feb 2026 17:31:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: rmap: skip batched unmapping for UFFD vmas
To: Barry Song <21cnbao@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, catalin.marinas@arm.com, harry.yoo@oracle.com,
 jannh@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, riel@surriel.com,
 rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz,
 will@kernel.org, willy@infradead.org
References: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260116162652.176054-1-baolin.wang@linux.alibaba.com>
 <e5175f66-56fd-437b-a183-b2ccc3f54f94@kernel.org>
 <CAGsJ_4w95tTGfanb0NdG5B+ajOUA4LaH7uh+Uxcq0ZNVaqK-Vg@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4w95tTGfanb0NdG5B+ajOUA4LaH7uh+Uxcq0ZNVaqK-Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qtpnnz8iouux9q63anmdbp3bzgqs76x4
X-Rspam-User: 
X-Rspamd-Queue-Id: AA7FD18001D
X-HE-Tag: 1770724891-291796
X-HE-Meta: U2FsdGVkX18KXHP7M9d1zI/hMksBng5dmPLI5FGRMRfi9dwL+7RjOEcGq9uTZ0TJV4rC1cu/qo2A6fuXMoz5jLQx3KF+7fmMac+Qh8UrsgVduNG+0zc6882F7etwWk/0ZKGxe0nTKhcUMPgADXxfZ7m1y3vacYWySskoimgkq3AI4loMoO5rx/7fsu4i4m13Tn2dxDinQAeC5xm+9VRCqCP/778/fhg19Rc67jfkLRN8I2nzPNBMbcfrLj/QeAlxcwlgt8nCWInE/QX0zOOLVfg+pvT6j3T5xNV2fj8tWbhr/uVtZ+COHu8SVPjSXlPGMW93YnbJInIs/a85nvqldkdYzgUpG1uwydZeQEbCt37J/1p1s3kT4XrpKmuv+8DDjPUegxTL2xsdbrtLquxWh9vDwW/OkHU1QF6C7uIwI8bPQIUTYw0/Be3DW20Edn9D14nOsrj+H+xgzd0n80gFWK0Pu3ccdHXCfSTSS2KFBb+ASMT1vHV/0MLyskFAq57K4w7z48Rr7oEviBYRQszuBW6Hzt0OpZ2Wp1s8m4T2ILtNnIwODhvSKAA13/xp2/nvtojCzhKK9/rCE5xRkDcWgvHR2dCbbbgeION9/nb6L4fxk48+j2v2IJuP0SbNKsrk4gwQzdcUKsXAdEjC0EbxuBCx7dFaVqiZhCT6RmHiL41S18OnRkcwT/SC3c89zCt9/MFczi837E4MS52In2VEGFd0AT03OVsQIJC+utkFW7NgU/ai9/i7/w+tjYNEDcvJi+QHggoWnmk7RGag5hGOJ+W0TK6XgUdDUit9779S3t9qJq9V4PanODhynbw7ZBgwpF0qz8lwWVzhC5Z9ZGkxF67Hgjvm85W1XQicSZyicbCLTkQ+KEBReg87Lsqx93mm6g3dgH8WM9LOe3mPxEgnATJS0gJua4N5UR+F/RFhqIGtyvo6ouoWlZWmfYCD6qGpzvavkeu8uCIwu239VPf
 kXdWEdk+
 rD+6U2Hp5sFz85s9Y58kP8B9CUn3OB5l0Oo/vKs/Le7plEhCqAOxQrgo2Xojms+E+6YeWgFPT13veuhKbeweJOOr0kJh3l+vvKBLbuOtF2+dPZ1DOjocjqXPPLiXFsKNMGkq3D0F/8TuQ42Bmi+rlmwNLh+IvYe8MsXhOSuN5qXJ8HO9/SEsmf5keQSsEkK6SlLeKTr45yLxjvSPqpm0J8e48dMGAl7pVMhETvIruay/AGrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 09/02/26 4:19 pm, Barry Song wrote:
> On Mon, Feb 9, 2026 at 5:54 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>> On 1/16/26 17:26, Baolin Wang wrote:
>>> As Dev reported[1], it's not ready to support batched unmapping for uffd case.
>>> Let's still fallback to per-page unmapping for the uffd case.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/
>>> Reported-by: Dev Jain <dev.jain@arm.com>
>>> Suggested-by: Barry Song <baohua@kernel.org>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   mm/rmap.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index f13480cb9f2e..172643092dcf 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>       if (pte_unused(pte))
>>>               return 1;
>>>
>>> +     if (userfaultfd_wp(vma))
>>> +             return 1;
>>> +
>> Interesting. I was just wondering why we didn't run into that with lazyfree folios.
>>
>> Staring at pte_install_uffd_wp_if_needed(), we never set the marker for
>> anonymous VMAs.
>>
>> So, yeah, if one sets lazyfree on a uffd-wp PTE, the uffd-wp bit will just get
>> zapped alongside. Just like MADV_DONTNEED.
>>
>>
>> I'm fine with that temporary fix. But I guess the non-hacky way to handle this would be:
>>
>>
>>  From 53d016d6e6f624425dbdbc2fb1dec7c91fbef15c Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Mon, 9 Feb 2026 10:52:59 +0100
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>   include/linux/mm_inline.h | 15 ++++++---------
>>   mm/memory.c               | 21 +--------------------
>>   mm/rmap.c                 |  2 +-
>>   3 files changed, 8 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index fa2d6ba811b5..8a9a2c5f5ee3 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -566,9 +566,8 @@ static inline pte_marker copy_pte_marker(
>>    *
>>    * Returns true if an uffd-wp pte was installed, false otherwise.
>>    */
>> -static inline bool
>> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>> -                             pte_t *pte, pte_t pteval)
>> +static inline bool install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma,
>> +               unsigned long addr, pte_t *pte, unsigned int nr, pte_t pteval)
>>   {
>>         bool arm_uffd_pte = false;
>>
>> @@ -598,13 +597,11 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>>         if (unlikely(pte_swp_uffd_wp_any(pteval)))
>>                 arm_uffd_pte = true;
>>
>> -       if (unlikely(arm_uffd_pte)) {
>> -               set_pte_at(vma->vm_mm, addr, pte,
>> -                          make_pte_marker(PTE_MARKER_UFFD_WP));
>> -               return true;
>> -       }
>> +       if (likely(!arm_uffd_pte))
>> +               return false;
>>
>> -       return false;
>> +       set_ptes(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_WP), nr);
>> +       return true;
>>   }
>>
>>   static inline bool vma_has_recency(const struct vm_area_struct *vma)
>> diff --git a/mm/memory.c b/mm/memory.c
>> index da360a6eb8a4..0a87d02a9a69 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1592,29 +1592,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>>                               unsigned long addr, pte_t *pte, int nr,
>>                               struct zap_details *details, pte_t pteval)
>>   {
>> -       bool was_installed = false;
>> -
>> -       if (!uffd_supports_wp_marker())
>> -               return false;
>> -
>> -       /* Zap on anonymous always means dropping everything */
>> -       if (vma_is_anonymous(vma))
>> -               return false;
>> -
>>         if (zap_drop_markers(details))
>>                 return false;
>>
>> -       for (;;) {
>> -               /* the PFN in the PTE is irrelevant. */
>> -               if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
>> -                       was_installed = true;
>> -               if (--nr == 0)
>> -                       break;
>> -               pte++;
>> -               addr += PAGE_SIZE;
>> -       }
>> -
>> -       return was_installed;
>> +       return install_uffd_wp_ptes_if_needed(vma, addr, pte, nr, pteval);
>>   }
>>
>>   static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 7b9879ef442d..f71aacf35925 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2061,7 +2061,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                  * we may want to replace a none pte with a marker pte if
>>                  * it's file-backed, so we don't lose the tracking info.
>>                  */
>> -               pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
>> +               install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, nr_pages, pteval);
>>
>>                 /* Update high watermark before we lower rss */
>>                 update_hiwater_rss(mm);
>> --
>> 2.43.0
>>
>>
>>
>> Does somebody have time to look into that? We should also adjust the doc of pte_install_uffd_wp_if_needed()
>> and turn it into some proper kerneldoc.
> I'd nominate Dev, if he has the time, as he has been working on
> related changes and is already familiar with this area :-)
>
> https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

Indeed, I'll be taking a stab on the uffd batching, and the generic folio batching
(meaning anon folios now).

>
> I assume this could be treated as a separate optimization, as
> the current temporary fix seems acceptable?
>
> Thanks
> Barry

