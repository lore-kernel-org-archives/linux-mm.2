Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17951CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5BC8E0012; Mon, 29 Sep 2025 06:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD6E8E0002; Mon, 29 Sep 2025 06:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409CC8E0012; Mon, 29 Sep 2025 06:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3127F8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:39:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBCC313A932
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:39:36 +0000 (UTC)
X-FDA: 83941941552.07.08B87C2
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D9EE2000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:39:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBI8fDiw;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759142375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tRivF3ombVQYJawRtepV/JQ0btJYvTDaYlGunrZe20=;
	b=hvIVwub52c19fFMTUNXdULl4UZjKg6SPc07mijr2SAMJ7MXRgKI0YKiimD1mad5IccyK7b
	xX/uF+XLdHFj7nZc/09HVs2b/hF8NakDHbFVsMukMsqKuoQvL3IxYIW7zwantje6a4xcu5
	3dBfokVzJPzfQs3qeQjPRpHrTcjb9DI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759142375; a=rsa-sha256;
	cv=none;
	b=44cFDEP6OL6hCv7GQWW0GgSgXgb5h3++WDfcs4u8aK7MwcRBpZ1AuPT8Snk/Pt9F8fO0Vb
	Un1mITzvV9xIqEe4owuS6Vtxum1OWp1mJECVj1PSNBLK4KlC02v4JMas0kuDdQxhHPqMTh
	1K0veOcTlWyAAn/5C3+F8W1/yx5IMUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBI8fDiw;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a51e9c33-60b1-47ca-b060-73f5d7827629@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759142372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6tRivF3ombVQYJawRtepV/JQ0btJYvTDaYlGunrZe20=;
	b=BBI8fDiwmJ6GAn1K8t3xVH9h4BpkyzZs9aej2sEyzDvIKkxEypDhGAZ4uuTgO4puxIQ/TK
	L81SdgtPNL++7q7oqjnFNd2/j/ZFau9JClPAjhr1q7HczPnduGjTnYsZZL51VF92OelFMA
	1cwzF6mXFs5jI+9W4wKz3LJlRDl54BI=
Date: Mon, 29 Sep 2025 18:39:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap
 entries
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com,
 akpm@linux-foundation.org
References: <20250924100207.28332-1-lance.yang@linux.dev>
 <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
 <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
 <d7012c9c-f4a9-4d49-a921-2cc175f3411d@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d7012c9c-f4a9-4d49-a921-2cc175f3411d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D9EE2000E
X-Stat-Signature: gskxxk79qbb1ftdp61yk6qyffx3oidc4
X-Rspam-User: 
X-HE-Tag: 1759142374-891156
X-HE-Meta: U2FsdGVkX19V91WmIiSOwKVuNGYsF79O5ESlLsniH90IRDv8iL/MaG5ewAzpQJNinMxRqsRkELVMTk6W0p2ExLN7nfzzd3l3lX2uIMCD95519iYmdsp1LTW4PcnbRfdbJyr4XzUDuGVP1mHD//3PpQqgkdPzJl3SRzujfNgDwNkQzXFFdDa5cYBPAnv6ecCoc1kVJlfVPvGr+Mx3Gi/wSGeQh1gVcuWamUm3xMVe+fejwkzMVv+aGf8MVhRiT6bsfsH4RHwmCLpRxBuoWLuSiePwJNsH++En/3x9oFwURW+wORt3WbbE5rcZPS4goycIAuNw6vJ5iv9ZfzN1gmVgVcqgSn191bHSWULVHOTSTw5Q2FvsLAMZKj4zaOosbHHjipTTb/kdnbkIOkE47hgY6eCkQUJ4VgY6zkd9XNvSorRD7QEh3MXv4b5+KG6wt6st/bhymr/O7qEn6YzzNgkVu7hQjhSJj81C38uGTNefXeagjzHB520tUPx1cWrFD9b+t9vQbR8uwSQ9xxyZC5eV1oL7GNAx9tWowd+nwQQITsn9P4XiEJFFAhBQMTEIIyvIp/1HuY8r0A2WtjV7gt1Q7q+WFkts3JhE4Kw8BnrZECrTHih00LFol6XuGSS9GU/NzbxXIKJ+SWPUV0mzf19lu1+7ODDi62wI8WNJPqIYhDZzTNwBeJIAxRM9ErBGQV/mOKZR3/itkud63YLOPPp3EpwMOnISF8llbNU3zMwWGGafyyU9Cgg0RjRdfBNb0yiptezGcsNlpjnUtQNBuEYDg2PfWitDK8+Kpjml6ROSHGhTTyGyoe+zAEA8OQz+VJfGXZYiNtad3eeHELaJ688TiUrnNHSBJnTfj5oyLhOlmXsh2AjCmgji596n/sKAuXrWqgGvAUJ3hSTszmnBYihxCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 18:29, David Hildenbrand wrote:
> On 24.09.25 13:47, Lance Yang wrote:
>>
>>
>> On 2025/9/24 18:10, David Hildenbrand wrote:
>>> On 24.09.25 12:02, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
>>>> markers. Other special markers (e.g., GUARD, POISONED) would not be
>>>> caught
>>>> early, leading to failures deeper in the swap-in logic.
>>>>
>>>> hpage_collapse_scan_pmd()
>>>>    `- collapse_huge_page()
>>>>        `- __collapse_huge_page_swapin() -> fails!
>>>>
>>>> As David suggested[1], this patch skips any such non-swap entries 
>>>> early.
>>>> If a special marker is found, the scan is aborted immediately with the
>>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>>> work.
>>>
>>> Note that I suggested to skip all non-present entries except swap
>>> entries, which includes migration entries, hwpoisoned entries etc.
>>
>> Oops, I completely misunderstood your suggestion :(
>>
>> It should be to handle all special non-present entries (migration,
>> hwpoison, markers), not just a specific type of marker ...
>>
>> How about this version, which handles all non-swap entries as you
>> suggested?
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7ab2d1a42df3..27f432e7f07c 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct
>> mm_struct *mm,
>>           for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>                _pte++, addr += PAGE_SIZE) {
>>                   pte_t pteval = ptep_get(_pte);
>> -               if (is_swap_pte(pteval)) {
>> +               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +                       ++none_or_zero;
>> +                       if (!userfaultfd_armed(vma) &&
>> +                           (!cc->is_khugepaged ||
>> +                            none_or_zero <= khugepaged_max_ptes_none)) {
>> +                               continue;
>> +                       } else {
>> +                               result = SCAN_EXCEED_NONE_PTE;
>> +                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +                               goto out_unmap;
>> +                       }
>> +               } else if (!pte_present(pteval)) {
>> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> +                               result = SCAN_PTE_NON_PRESENT;
>> +                               goto out_unmap;
>> +                       }
>> +
>>                           ++unmapped;
>>                           if (!cc->is_khugepaged ||
>>                               unmapped <= khugepaged_max_ptes_swap) {
>> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct
>> mm_struct *mm,
>>                                    * enabled swap entries.  Please see
>>                                    * comment below for pte_uffd_wp().
>>                                    */
>> -                               if (pte_swp_uffd_wp_any(pteval)) {
>> +                               if (pte_swp_uffd_wp(pteval)) {
>>                                           result = SCAN_PTE_UFFD_WP;
>>                                           goto out_unmap;
>>                                   }
>> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct
>> mm_struct *mm,
>>                                   goto out_unmap;
>>                           }
>>                   }
>> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> -                       ++none_or_zero;
>> -                       if (!userfaultfd_armed(vma) &&
>> -                           (!cc->is_khugepaged ||
>> -                            none_or_zero <= khugepaged_max_ptes_none)) {
>> -                               continue;
>> -                       } else {
>> -                               result = SCAN_EXCEED_NONE_PTE;
>> -                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> -                               goto out_unmap;
>> -                       }
>> -               }
>>                   if (pte_uffd_wp(pteval)) {
> 
>  From a quick glimpse, this should work. And as raised, we might be able 
> to unify later the scanning with the almost-duplicated code when we do 
> the second scan.

Sounds good! Let's get this one merged first, and I'll send a follow-up
patch to unify the duplicated code as you suggested ;)


