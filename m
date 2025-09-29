Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4508CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17BD8E0012; Mon, 29 Sep 2025 04:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9278E0002; Mon, 29 Sep 2025 04:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADEBF8E0012; Mon, 29 Sep 2025 04:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9663E8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:52:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 277E61602D3
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:52:12 +0000 (UTC)
X-FDA: 83941670904.14.7C65119
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E7741C0004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:52:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QnXKp6qk;
	spf=pass (imf20.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759135929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox5XqYTkHSlNm09+TIgA/LRiQ/Rrg11FqwzTsBJu9zo=;
	b=msumVkVIOEKS1hwshrcS5rndm+FA6OkbMu5qbvrI/R4rn7SYpwNQNmfhZ7bHm+Sh4niPfx
	jDKmPRY5bdMtXBaauepiYn8cAVDPi8A5cJg+2VCRXU90ZZnzDEEGXOsDua0QDPYOIjgLDd
	eRazVZ0G8yqqk+rimHsa8fNL+//JR/s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QnXKp6qk;
	spf=pass (imf20.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759135929; a=rsa-sha256;
	cv=none;
	b=1x4UH8ELtmJexOIGg1EyvNIz4j2JUzypuis1Am+y4fIpwXhbrsHxJLv234m650GVcmc35/
	om0NPnS9f023Z0EN7YRYGTt6mhRaVFi01h+7EWcNG5l7BgUCb4hZSP8uWLICKFLJEjh7Qc
	H65wr8cDf1VbxOGwrSXok0e+sFe4BBc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ox5XqYTkHSlNm09+TIgA/LRiQ/Rrg11FqwzTsBJu9zo=;
	b=QnXKp6qkX9nqEDsRjTKpTIMo8JydC8A86hWzAXXSXJM01TfubjoJ3wY7qb/Rg3K24ZYv97dZm
	PdyHh+bvYnmxZ2N/QaAKUMW7W1FMrTNtq8ePbT/nhfOTqch75B5ybjarSEAyr44XqUIkat3ICv8
	eXCrKH0PdYUDyzI2S+zxhog=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cZw0n6xz7z1prLv;
	Mon, 29 Sep 2025 16:51:53 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id C1B431400D4;
	Mon, 29 Sep 2025 16:52:04 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Sep 2025 16:52:04 +0800
Message-ID: <a0184970-f614-4e78-9952-f75737a45418@huawei.com>
Date: Mon, 29 Sep 2025 16:52:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: Is flush_cache_page() in wp_page_reuse() really
 necessary?
To: David Hildenbrand <david@redhat.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>
CC: <baohua@kernel.org>, <linux-mm@kvack.org>
References: <7a217590-1e37-4d80-9c5c-1f7d2c2b556c@huawei.com>
 <f775b4a3-77c4-46a8-92e2-17308097df3e@redhat.com>
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
In-Reply-To: <f775b4a3-77c4-46a8-92e2-17308097df3e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Rspamd-Queue-Id: 0E7741C0004
X-Stat-Signature: sx1jpowc5y6i8wjhsq38qtda6b148gnt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759135928-565586
X-HE-Meta: U2FsdGVkX19OvXF6ULxDUT3IvXikzLgAN+JPSbm8Me8YIpRNn1MySw3f0+9LU9dxW3ZM4lx14AIBKCkgWEhX5vQV7tUfD9HNJlSX3GFYw83bCt/tNormiytAGJO47Yb7YovZhun2MwVAiwforaqOmA79Uyk9jQb8+OMZ0NvEgouNw/EA3DpKO5l2vd/qHXdH/hEKl3Msdc77rhQGdxnbIhxDogBRzIVRfYcxecZ9vZHO8vWkvbpgE2RwGE/PaoPzbFaqzzNpg/8FJMLoHPDBkAbCk4Gsn5bA27CASXca84FtL52u0OQt8a3Og3sCj0+zra+BjQB+n1wb4NuRYfZUxoZOVKSFsERHMziFCMn848y+idEpMkNncEAUxQy0EHIuJOl1+2zdYr3SGgX6C8Kz3+h2mgXLCxRUj12VxhCv+5jJM29Kotua19MwwO7fdFU+5KrcEAtgvL1P8H4u3+/bTBM4mRgFcKV+ctBYwTnqnTHEwFnaRluIQt+SNX+qNXFLehQJbsj2fo7ZShaN9LQzPKf97BO4x83ea0J+aegUDlccuSGxEodHIV4FI+8obJESwi/kCEytKymoTfgBqDY3oJnV8dK3bIZOFjlVjG/x+xmlU+FHmsZHSNAcabC+LQOiDseRnsVWCZXXUKM850FwM164ZndBa6pXeD5dqpBCxdCspE5+pZPx8MAMgSW1nKPQ/No3/k5qC3yP3yApKes1wjS/StZSqIE0mdy3+1mZxlcNCDZuwxN+VxvrJAYiV9nXfwhiU6jz4VPNHrPfw9urCblCr4mDozkartckzejtQyuz8byKiT7hIlq7vzO1fLzbknii/lJ8fSVEigVktRHXZbPwTzELzcFZqwfN32cyjpISPamS6Cz8SJmhneHMza5YCBDByRqV2bxR1B/SFyfoSO7OxPJE6OOaRS4SddvVLLGFQNLbl4mmH3mL7H6bLZO90d6+wVaSNCWppaNU/Hh
 4bnQXY+E
 F7qYg8nNAKowwkFdUZgkryg8Y4DiQjZxwYSBNfq3XGob/tkRkNzzfD5Qps39F1w86SAYlkrbLzvjv1V+m0Yjdzw8yWum6SVjpiS9HWbDJVNvRXPL2F86QvvrEOlnWcDHVPneDoG91qRXjvaFy5vEnskLBrlUpnI6oHVMyV/AR4CBFKSBhIziizuLAGt3XMrHponzLhE8F3gF0BB+u7xYe3E6ZUMY6e1SUW15aLK7fB0zCP32jst1BJ4p6pB4JOgZ3WRE8VhPJ5FscEoMZ1xQ+dTehv1Y5eRvZmU2LG8gdq4gL4AmfyFOcm5ueX7EegSM6X5abu6CIP6Ma6zM2bbrhKQu20SvBPHrcx03zSSiifKdep1WFJboHMQX+gGnCvFauy+BXEcbf5tXXIY1cqXZQqrQsQs+M3mqfuCd+XENHrgS5Fuc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your reply and the pointers. I went through the kernel arch/ code
and looked into architectures that support PMD-level THP, such as arm64 and
x86_64 etc. I found that their flush_cache_page() implementations are all nop.

More precisely, for modern cache architectures (VIPT no-alias, PIPT),
flush_cache_page() is nop.

So the call in wp_page_reuse() looks more like a historical artifact, and it’s
hard to judge whether it was strictly necessary.

I really appreciate your clarifications!

Best regards,
Wuyifeng

在 2025/9/29 16:09, David Hildenbrand 写道:
> On 29.09.25 09:29, wuyifeng (C) wrote:
>> Hi Linux MM developers,
> 
> Hi,
> 
>>
>> I am reviewing the page fault handling code in the memory management
>> subsystem and came across a point that puzzled me regarding the use of
>> flush_cache_page().
>>
>> When I referred to Documentation/core-api/cachetlb.rst, it describes a
>> typical sequence in a page fault scenario:
>>
>> flush_cache_page(vma, addr, pfn);
>> set_pte(pte_pointer, new_pte_val);
>> flush_tlb_page(vma, addr);
>>
> 
> The number of archs that actually implement flush_cache_page() is limited, so likely there is not a lot of interest around optimizing some out.
> 
>>
>> That is, first the CPU cache is flushed, then the PTE is updated, and
>> finally the TLB is flushed for the corresponding virtual address. This
>> makes sense: when the virtual-to-physical mapping changes, flushing the
>> CPU cache is necessary to prevent stale or corrupted cache from affecting
>> the new mapping.
>>
>> However, in wp_page_reuse(), the virtual-to-physical mapping does
>> not change. The function looks like this:
>>
>> static inline void wp_page_reuse(struct vm_fault *vmf)
>> {
>>      struct vm_area_struct *vma = vmf->vma;
>>      struct page *page = vmf->page;
>>      pte_t entry;
>>
>>      if (page)
>>          page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
>>
>>      flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
>>      entry = pte_mkyoung(vmf->orig_pte);
>>      entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>>      if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
>>          update_mmu_cache(vma, vmf->address, vmf->pte);
>> }
> 
> Note that an "old" PTE might, depending on the arch, not actually have the hw-present bit set, so next access would trigger a page fault to maintain the clean/old PTE bit in software.
> 
> So it could easily be that we are transitioning from non-hw-present to hw-present here.
> 
> If that requires a flush_cache_page(), I really don't know :)
> 
>>
>>
>> Since the mapping itself does not change, I am puzzled whether this
>> flush_cache_page() call is actually necessary.
> 
> Same here. I have no idea if the scenario described above would require it, or only when we are changing something present to something non-present or differently-present.
> 
>>
>> A similar situation appears in do_huge_pmd_wp_page(), which handles
>> huge pages. When the system reaches the reuse branch after the relevant
>> checks, the code looks like this:
>>
>> reuse:
>>     entry = pmd_mkyoung(orig_pmd);
>>     entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
>>     if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
>>         update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
>>
>>
>> Here, flush_cache_page() is not called. Instead, the code relies on
>> updating PMD access flags and calling update_mmu_cache_pmd() to refresh
>> the TLB.
> 
> Does any architecture that cares about flush_cache_page() actually support PMD THPs?
> 
> I mean, looking at mm/khugepaged.c, I cannot spot any flush_cache_*(). Maybe it's implicit, but my best guess is that no architecture that supports THPs really requires it?
> 

