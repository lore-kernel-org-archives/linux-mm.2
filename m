Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B471CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 08:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBA38E0053; Fri, 19 Sep 2025 04:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1F98E0008; Fri, 19 Sep 2025 04:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF108E0053; Fri, 19 Sep 2025 04:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28E548E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:27:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBF971605E1
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:27:18 +0000 (UTC)
X-FDA: 83905320156.20.7754D5F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64A4D14000B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:27:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BYbebIN2;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758270437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5IPepsPTCQyll6N7z1GGSXOwpevduVI0QCfANT/a9s=;
	b=kmfAcDKVx+nWvChxa5qtKRJGSBE+nf9BMgpjEFoL91sJREwdtPKiQ8jA8UcvBv0g+0gs/6
	nGv9/BkgF3ANt194vMqQEwAv7HgX/5xmQEGN9w19oc0yK+irEphw42doYbBL0BZEhHyDns
	w/EQ1XPV55eDocTQDohS+3Mz5B0up/w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BYbebIN2;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758270437; a=rsa-sha256;
	cv=none;
	b=zviTDU/6FHCFXBZ2d4fb9cpYn4ASxVZyHxLlnuCMnLrDHX8FG0CufwHcigwL+IMeedyJI+
	EhlvLuSHNYZp14TFnaOy9ElCKFry8V4NihaEjEqoEsosTy37RNDmtk7/a0Xy4x6p+SIkCz
	gRBSTa7FPaj3FybHTwGPPHZxZQn8WTY=
Message-ID: <f489325f-695c-4329-a011-60830b74bb4f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758270431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M5IPepsPTCQyll6N7z1GGSXOwpevduVI0QCfANT/a9s=;
	b=BYbebIN2TMeI3CzIO0kGNmy6bi/trltsui9GUgiNnqDYd+xqryUxxGZpg8R6sySGIAQ9e7
	TRPyoC0zhHmzHDEuFOI5GAE4d3OzaVbEFDSCtSqjo1EPu9Em0HVL+ZSgdQ5vi3f7JDB4Zb
	mwyxbKJeRKHMrL4AeOsx61IXzZEiNOw=
Date: Fri, 19 Sep 2025 16:26:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, kirill@shutemov.name,
 hughd@google.com, mpenttil@redhat.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
 <eabd866a-aed3-4e28-a139-13b7c1d4e715@linux.dev>
 <7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 64A4D14000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: id6qqa7iyk5mw1gggo7fjkuzaye4f1xa
X-HE-Tag: 1758270435-371559
X-HE-Meta: U2FsdGVkX19iWriPEf++OBVEytsM1Mt91XFh15xBy2Jrpm3KX9I9dIxJUjFtyGWVh70ebXmHHDnpz8zmdGeLXmtvoBh6ypnJw5Qq6ucuKMoqxnexZHSKHr+5QjJCAaTi+0szs6h5A74KI0HJRQPwB2CKqPYppiKzKgRXHbDH5syLv3fCLiQaS5G+mmavaauvAslGCwaEEXePeB/P27CXJ+KeZUVmDU8a0qNHrzR6gBUL/OiORfd41MVSXEQvGAM1h09scVGjN+/9QO82lXBRSBb+LfxfECwSVY402NTkKnD6mLqkR80A6wefYGpdu/wUOYRozpFnszkWwdlNcOYsuEcVO1DtdyjbL63DQfUkOUVCbO9VkdVf912RM4dM4rhmOfeOxdKVFV/iPS7yt0XKqqw8ackvtq+UL+CflbvvmDAPUVJg/STXi+oIlarcxZw94p3vaC5h7tnjzwOJuRDhRPVBd03biZ92WOLaHZlLZQ7icbESdbJ/xAdgT9cWkXuk/DsMW7/y0OY9V9rQVMXexz1k+D2auDTT5MgsnpUohr6icGYlPysm8sSBUds0ya50P78J8lka5+ZGZz//dvsIBDR13ZLzuHKlo9FlKa0bJ8be6OwV93/ea9zR+/vuTeH35PtLZ9nAkrd1C+vgqUX+3Zdqn+2CCCyxKHK5UPm99LtL+MDfavN/T/qCrfCm4KlWosycD9NqTbZoVBttgjPK6lnMxY9B8JbRc7tcpHzkZrZ2xqNBpVkkJjZ8TTPoOvafmpxpQQUgYoB6J26KZJPW/LiRrYgI6V+6p55HkbKuhydXniYwljZFPtzqQgZTl5oUdrMh9m7pgSyT8aQsJn589mb8K3E5s/fQj6B6EmfUiBaxZHDoU4isSeugHbCCuGAUJPrIznTWTSZ8Xp1agC0MLl88iqL/MRD0J1FQA7HES6nWzAlw6AsmA/cJt27e0vmr+gwP7UfIMenocW+ZDBZ
 zf07BzfO
 yDgZjINOUWM8I8hB5N8nxvR8JQsTv4l+1xTh03e+oH9mAElX3I2vXHi26RtydM4z+8D471Nh7EY8Lr8b+aLE8tl2fILpBd2AHT2ruhKRYEUJHQLYZBFjZrV4igk40mRlZAFVXQ8G342tS7O/1PJW8VJLMEGg7G/Hdkdg34AzsuepX0ekupLwEZNdUhv7gVufuHLXe2aTTf648Gz9ko95P1BpK4xZvUDbQGmKWYoOoB0KuJCHoKGaAX/5rpxUjdxySh+2176NIbaROzu/AOgActAY4I8JTb6NU70iNSjbQzGd4aohtcp7JeEWZFMvNrGbQF5QHFw4PUk3l+B0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 15:57, David Hildenbrand wrote:
> On 19.09.25 04:41, Lance Yang wrote:
>>
>>
>> On 2025/9/19 02:47, David Hildenbrand wrote:
>>> On 18.09.25 07:04, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>>>> lightweight guard regions.
>>>>
>>>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail 
>>>> when
>>>> encountering such a range.
>>>>
>>>> MADV_COLLAPSE fails deep inside the collapse logic when trying to 
>>>> swap-in
>>>> the special marker in __collapse_huge_page_swapin().
>>>>
>>>> hpage_collapse_scan_pmd()
>>>>    `- collapse_huge_page()
>>>>        `- __collapse_huge_page_swapin() -> fails!
>>>>
>>>> khugepaged's behavior is slightly different due to its max_ptes_swap
>>>> limit
>>>> (default 64). It won't fail as deep, but it will still needlessly 
>>>> scan up
>>>> to 64 swap entries before bailing out.
>>>>
>>>> IMHO, we can and should detect this much earlier.
>>>>
>>>> This patch adds a check directly inside the PTE scan loop. If a guard
>>>> marker is found, the scan is aborted immediately with
>>>> SCAN_PTE_NON_PRESENT,
>>>> avoiding wasted work.
>>>>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    mm/khugepaged.c | 10 ++++++++++
>>>>    1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct
>>>> mm_struct *mm,
>>>>                        result = SCAN_PTE_UFFD_WP;
>>>>                        goto out_unmap;
>>>>                    }
>>>> +                /*
>>>> +                 * Guard PTE markers are installed by
>>>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>>>> +                 * not touch them, so abort the scan immediately
>>>> +                 * if one is found.
>>>> +                 */
>>>> +                if (is_guard_pte_marker(pteval)) {
>>>> +                    result = SCAN_PTE_NON_PRESENT;
>>>> +                    goto out_unmap;
>>>> +                }
>>>
>>> Thinking about it, this is interesting.
>>>
>>> Essentially we track any non-swap swap entries towards
>>> khugepaged_max_ptes_swap, which is rather weird.
>>>
>>> I think we might also run into migration entries here and hwpoison 
>>> entries?
>>>
>>> So what about just generalizing this:
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index af5f5c80fe4ed..28f1f4bf0e0a8 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1293,7 +1293,24 @@ static int hpage_collapse_scan_pmd(struct
>>> mm_struct *mm,
>>>           for (_address = address, _pte = pte; _pte < pte + 
>>> HPAGE_PMD_NR;
>>>                _pte++, _address += PAGE_SIZE) {
>>>                   pte_t pteval = ptep_get(_pte);
>>> -               if (is_swap_pte(pteval)) {
>>> +
>>> +               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>> +                       ++none_or_zero;
>>> +                       if (!userfaultfd_armed(vma) &&
>>> +                           (!cc->is_khugepaged ||
>>> +                            none_or_zero <= 
>>> khugepaged_max_ptes_none)) {
>>> +                               continue;
>>> +                       } else {
>>> +                               result = SCAN_EXCEED_NONE_PTE;
>>> +                               
>>> count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>> +                               goto out_unmap;
>>> +                       }
>>> +               } else if (!pte_present(pteval)) {
>>> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
>>> +                               result = SCAN_PTE_NON_PRESENT;
>>> +                               goto out_unmap;
>>> +                       }
>>> +
>>>                           ++unmapped;
>>>                           if (!cc->is_khugepaged ||
>>>                               unmapped <= khugepaged_max_ptes_swap) {
>>> @@ -1313,18 +1330,7 @@ static int hpage_collapse_scan_pmd(struct
>>> mm_struct *mm,
>>>                                   goto out_unmap;
>>>                           }
>>>                   }
>>> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>> -                       ++none_or_zero;
>>> -                       if (!userfaultfd_armed(vma) &&
>>> -                           (!cc->is_khugepaged ||
>>> -                            none_or_zero <= 
>>> khugepaged_max_ptes_none)) {
>>> -                               continue;
>>> -                       } else {
>>> -                               result = SCAN_EXCEED_NONE_PTE;
>>> -                               
>>> count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>> -                               goto out_unmap;
>>> -                       }
>>> -               }
>>> +
>>>                   if (pte_uffd_wp(pteval)) {
>>>                           /*
>>>                            * Don't collapse the page if any of the small
>>>
>>>
>>> With that, the function flow looks more similar to
>>> __collapse_huge_page_isolate(),
>>> except that we handle swap entries in there now.
>>
>> Ah, indeed. I like this crazy idea ;p
>>
>>>
>>>
>>> And with that in place, couldn't we factor out a huge chunk of both
>>> scanning
>>> functions into some helper (passing whether swap entries are allowed or
>>> not?).
>>
>> Yes. Factoring out the common scanning logic into a new helper is a
>> good suggestion. It would clean things up ;)
>>
>>>
>>> Yes, I know, refactoring khugepaged, crazy idea.
>>
>> I'll look into that. But let's do this separately :)
> 
> Right, but let's just skip any non-swap entries early in this patch 
> instead of special-casing only guard ptes.

Ah, right! I missed the other non-swap entries. Will rework this patch
as you suggested!

Cheers,
Lance


