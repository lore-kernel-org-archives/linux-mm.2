Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BC6E7E0C9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA7C6B0005; Mon,  9 Feb 2026 05:58:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1726B0088; Mon,  9 Feb 2026 05:58:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADCA6B0089; Mon,  9 Feb 2026 05:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA73C6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:58:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33C828C3DB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:58:30 +0000 (UTC)
X-FDA: 84424619580.13.F6A81B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82585180011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:58:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d39AbULa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770634708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5b5z8StpHUwzQz1ibw1pvTn6wMwCNVe7bbhLoYcjLI=;
	b=V0IN5htCm9sxynj5fFHlV//oFhtV1hSlFdZcp5l+y/jcR8srrXzB6ffPXUDr0zQsWPEKPF
	V6na2U3k5N4N5Uuio0NHsCValME1OWHZXv0FLnTo4oRFZgYcHJ396Qz7KohVHOAyp3rRAR
	fNmcxOjWAH8G2rg6tN7Q4fdtEIpbQtY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d39AbULa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770634708; a=rsa-sha256;
	cv=none;
	b=kvPuJhJo6A+vDFSey+rg1VtEf0Kf5dPe9mWIikat7BrC3WS+t6Sp6QuRNhuEAm4zaOKMea
	FN7OCLU3TBt9ZxCUteetm0TQo5OS+hTlJLnOTLRAcbdmwAKDTNdw2Zo6gDpYhpVwkmlhRE
	WnPOe8nLzviBlwbJcVKoTxYLnOOPaCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F216A60008;
	Mon,  9 Feb 2026 10:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C685FC116C6;
	Mon,  9 Feb 2026 10:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770634707;
	bh=a1q0Q1/gBdV3sFnnGa8SAvl2LXoQkQCC/VQ3Tn+B3pI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d39AbULaWTxHR69m1JKeOsmspto3HCcwxUHZ8hYeOSf2twIHEp9q0LF2UwS/CKzJs
	 mAL7JXhCOj69MhzumwiVKU+CkfQSLeqYf6X2w9CbY59cNrq2F1V9f49u/iSklok/Y1
	 /s8exz9tR4Z6lEiU1Yz1acsa2ff70/f4XV45GlS8NyaxVyLlgrgZJD0cIBpA1rGvDU
	 sNR401hsTdbg+zrZC53pnJcfbvsEM5f3i5jOrsT3fZ9M2AOwMFhfz4e8NJvEHYuUMJ
	 zmKmUZEIfIrHc9NH4ga+hdBSYQ/JV6UUM33niB2J0Cm/o3HdNfhC3WGGN4lUA3/+ra
	 bkuLSIJlefT7g==
Message-ID: <7e5f27b5-392e-43bd-8a47-b81395dbf9a7@kernel.org>
Date: Mon, 9 Feb 2026 11:58:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: rmap: skip batched unmapping for UFFD vmas
To: Barry Song <21cnbao@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, catalin.marinas@arm.com, dev.jain@arm.com,
 harry.yoo@oracle.com, jannh@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com,
 vbabka@suse.cz, will@kernel.org, willy@infradead.org
References: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260116162652.176054-1-baolin.wang@linux.alibaba.com>
 <e5175f66-56fd-437b-a183-b2ccc3f54f94@kernel.org>
 <CAGsJ_4w95tTGfanb0NdG5B+ajOUA4LaH7uh+Uxcq0ZNVaqK-Vg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4w95tTGfanb0NdG5B+ajOUA4LaH7uh+Uxcq0ZNVaqK-Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gfqzjta9hxcnxu33caxim3y9ercn33hn
X-Rspam-User: 
X-Rspamd-Queue-Id: 82585180011
X-HE-Tag: 1770634708-466201
X-HE-Meta: U2FsdGVkX19/Wh2Lje5euMXVA/za+kb/Xk9Uc4HJ1j6qdNclU+8mHypGhwoYIjxqQC0dzwpaQdtWTs/vGO36DbQ4r6jMLoEAc20ruWOPcwdLEO2nC65Gi55MkJmuySzvJASVCc6HYFf1rcAyWOg+Xl84M+9tssjFYTwKb8NIrheWG+73EmLcn7mBpqEMY1X5e00CqS28SxSnd7JyNPg+Wvhq9PleQt2BycsSO7LXaaRZwmAm5NUX7Qm9vYo7zKZYhHopjXq2hLgPetFxg+x296GAzgey49dncLcZbZ1c5+iYlU0VdJz7LSs5f6VoipO7CldOVsnoRDmhwTBIOgArhE78k0Bty0QxoE4ox2UV4bkN7067XjIcw24MFEMivOpNrUobRMALm4qTsPmW/jYo5rHIDt8Uz6pgXDXVrLbMaWalpwNypqM8idslTSM1jhWvhASJOpXVP1KWzv+AZJ5n1ZEhEe6q4oJ++6NwAUE5Jicdvxss+0X6BhLmDQ5S2eTkSCfTq7gqAizq2JeL8bEVFB7lLmymedHop24rpVFsdEhyXHpMWQH0SbOAgJJ5teUljn59WCsolb1OaB4weY2LSMVg+/VX9CQy2EsKtUBLWYO9WXIt6o0/2eHU8S/cvFmMvlVEPqn43dnPwDnJt4HzrTNXJ540oe7ItCAj5UQyD2RO71GZRLLPGMbsFD2O3BMvCsybAbseE78Bo0x/e3sHQX1XYByn77nvyETWV8quSbvzZUhzBWbFmi90DIsZkjs2rhpNujLC7Gt1v3Ijd9NcvfIrsZnRhd9iEflz0iGuRT+2Tm48Jnoc8FMOn/ekMguXbGafjGQgJ6muPa86VUWb31WnYjLY44JZslSYmxs3xZRfPGPBRGeo6Z7wl4kXrXaZ3ZkE6h5sp4sNwLXqiE/1s9nZQJl9Vjqtt+eBqFvuZ+E9fj6+KUVp7QxwBokHfGEI3mP8Rvm5wtpek5yZ9KM
 SSqk3s7K
 pG1NrCfm9sUXtbopmQoIzCphA0+jLl+ClAeGOpYhmEj3rvST2BSjSm74Y6FpIDmGHP6R8y6KHxJhvmv45myG6EBShkS/OGMIj2M4EVyP1D2WYGtsHp7BXfP87e46jd/utg2G+0TyzeUI9kcIMQz+6SKHsY7SZK42jdF+yUTx7XV8m509SB6PA7TgCCqJoG9C0ZlKf0pEaZj+S20BxGnqY9vxfJNjxISv5ApKHG+dZGUF3Db761aSImRLkPMDUdGIKIhNdMSHEI3Cla5ENfJAf6MINGsGUYbnFFLB9r0yXlk1oWpyq20dSG68m0GQ1ZAE2gmt2jelEv517D0gEPOG1vY3dFcIO51lyElUA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 11:49, Barry Song wrote:
> On Mon, Feb 9, 2026 at 5:54 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 1/16/26 17:26, Baolin Wang wrote:
>>> As Dev reported[1], it's not ready to support batched unmapping for uffd case.
>>> Let's still fallback to per-page unmapping for the uffd case.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/
>>> Reported-by: Dev Jain <dev.jain@arm.com>
>>> Suggested-by: Barry Song <baohua@kernel.org>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>    mm/rmap.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index f13480cb9f2e..172643092dcf 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>        if (pte_unused(pte))
>>>                return 1;
>>>
>>> +     if (userfaultfd_wp(vma))
>>> +             return 1;
>>> +
>>
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
>>   From 53d016d6e6f624425dbdbc2fb1dec7c91fbef15c Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Mon, 9 Feb 2026 10:52:59 +0100
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>    include/linux/mm_inline.h | 15 ++++++---------
>>    mm/memory.c               | 21 +--------------------
>>    mm/rmap.c                 |  2 +-
>>    3 files changed, 8 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index fa2d6ba811b5..8a9a2c5f5ee3 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -566,9 +566,8 @@ static inline pte_marker copy_pte_marker(
>>     *
>>     * Returns true if an uffd-wp pte was installed, false otherwise.
>>     */
>> -static inline bool
>> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>> -                             pte_t *pte, pte_t pteval)
>> +static inline bool install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma,
>> +               unsigned long addr, pte_t *pte, unsigned int nr, pte_t pteval)
>>    {
>>          bool arm_uffd_pte = false;
>>
>> @@ -598,13 +597,11 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>>          if (unlikely(pte_swp_uffd_wp_any(pteval)))
>>                  arm_uffd_pte = true;
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
>>    }
>>
>>    static inline bool vma_has_recency(const struct vm_area_struct *vma)
>> diff --git a/mm/memory.c b/mm/memory.c
>> index da360a6eb8a4..0a87d02a9a69 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1592,29 +1592,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>>                                unsigned long addr, pte_t *pte, int nr,
>>                                struct zap_details *details, pte_t pteval)
>>    {
>> -       bool was_installed = false;
>> -
>> -       if (!uffd_supports_wp_marker())
>> -               return false;
>> -
>> -       /* Zap on anonymous always means dropping everything */
>> -       if (vma_is_anonymous(vma))
>> -               return false;
>> -
>>          if (zap_drop_markers(details))
>>                  return false;
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
>>    }
>>
>>    static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 7b9879ef442d..f71aacf35925 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2061,7 +2061,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                   * we may want to replace a none pte with a marker pte if
>>                   * it's file-backed, so we don't lose the tracking info.
>>                   */
>> -               pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
>> +               install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, nr_pages, pteval);
>>
>>                  /* Update high watermark before we lower rss */
>>                  update_hiwater_rss(mm);
>> --
>> 2.43.0
>>
>>
>>
>> Does somebody have time to look into that? We should also adjust the doc of pte_install_uffd_wp_if_needed()
>> and turn it into some proper kerneldoc.
> 
> I'd nominate Dev, if he has the time, as he has been working on
> related changes and is already familiar with this area :-)
> 
> https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/
> 
> I assume this could be treated as a separate optimization, as
> the current temporary fix seems acceptable?

Let's call it a cleanup, because the way try_to_unmap_one() sometimes 
respects "nr_pages" and sometimes doesn't (because it's hidden somewhere 
that nr_pages will be 1) is just nasty and provoked the bug you ran into 
in the first place. :)

-- 
Cheers,

David

