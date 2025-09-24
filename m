Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB102CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E34D8E0006; Wed, 24 Sep 2025 07:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAAB8E0001; Wed, 24 Sep 2025 07:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F88A8E0006; Wed, 24 Sep 2025 07:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB268E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:47:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0C2B87974
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:47:35 +0000 (UTC)
X-FDA: 83923968870.27.4F6A928
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBCA4180005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:47:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qY66QdpD;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdcuQ8Buyt2j7x4RPegt18kSFyuHpvpqm9DsW5GElrw=;
	b=uXgSVM2I7AhenfWvzpR7DwxoMC8UQO+doA8jLvyj3u1WJxdSxGqlZ1PBL7bw45vuimgG6T
	BYxbfpOPO0Is8ne++Uww1+pemrgS93To8pyvIA/bCISrQpfuAEe2PBmctlMqZbu1WztLML
	RFyQxGcGbSsInEDK8hCx1b30/STEsBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714454; a=rsa-sha256;
	cv=none;
	b=uQ7PjWAiktN4D9RZU3/CLoM0z0lqOHaZgfAp5RrZerEuNOCxmgLnSbrRxFaRdLkFTtkRBj
	4uk54AjssxrR2zrAJCFEcQd+fN6tBasM9imDf1H+kaXBfwHrV79alIrX9p10JTQXnMxctW
	6OG5WSuwtu/MhCZkQAydmlqchAasols=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qY66QdpD;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758714449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PdcuQ8Buyt2j7x4RPegt18kSFyuHpvpqm9DsW5GElrw=;
	b=qY66QdpDELzY/5yp8cWJGqLqn036vXC519/RCLb15ck8tZjNsuwyKNx9nflHkSV7+DPYdH
	e9f6ElixZrGIqXGYlkQLkmxtwRjfgnDllGf8+d+tIU2rcJFw9xLfT3SVBuWyphoDIqHiVu
	fNqjgNIPtDeQSenrm1+ei04ezkjb8No=
Date: Wed, 24 Sep 2025 19:47:11 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7gzirdrj6gc5j853z8s71ochr1ofsy3h
X-Rspam-User: 
X-Rspamd-Queue-Id: BBCA4180005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758714453-674222
X-HE-Meta: U2FsdGVkX19nWgjmVo+2CVZdmw9hs0ybeOU1hjzLLagOs3t8OPwzUsd/enYVq0VYO/Y9mMTENA8fTPNzCR9mct+to4r5qKwPl5gkkftyy2wj+gJHFAeNP4FzHi8K4ZQTP9/I35UJbzin4CePQFOB6XXvhvbhcry8SGvWk3h4k0J/hjQzWidAk9AOTbPONoLdiXWUeh6N9Avdurm0pjluWtnnNgqPchkgw12JyJWRI2tDoR6akaAn2bnknzPQGbB3UbkgySMiOwdGC994sKY3ajrgVRqe9ZipDJIEk/JdBT2swD0+SaSMbNQmRKcDjlS7zWuJQbWQ9ZmbRyTykdM93utUyYHP8/mZKnkclKIvZMzTo5jba7JYQ7FwbIxEkNA3x/V28LxX0/EjbdwUiMVHO0FtyTCA2sWdScSe04OEk2Xefhqik2JLz6CXd8qC75/tgAq5SesLsSKGQP65w6UuIqpJSLlgRBMz2kznA5bN1bJ/QZyrPnkbRi2QyXefyoySHD1mhoi5g4JLQ7HxMq7Bxpw8kfTNnDQ16xwXxGB0r4Kn5Yme4X1z7ONYKUj6LVxbV8BWjLU6yjXAKrXYQ4vxgk/0Z8243p9Mhj8O1t4POTB7gQygXitIVehWV5SmyedXWzL88dTUDOgK9DaNbcNwjfTnXfvqu2LePXMJE03laRwKvA2gTCTwktjBeX0ZJ8PWKpmmYyUvGXtNmFVDn8RXM6u955z9wNtgjB+NSXjDUCaPvYAZQnYe+S35OBdUND4Xo8kqLGeBgBVTgvUM3WRAo9Q8rev4KApK2PAKlsoA1dMOF6H5MCj3hYS+WuTUcwhccz5AnAVvUyTFzXtPtnam1IGYha+NLtpuGQZXMsfKN97prFS1UNCEgqbfamVSmRsaahJafuLZeCbeMqAsh2BJHWl3o3kHTL8uKSW3VrB5uKJkrpTKI0L64RhTM/j6xCdZrbqAAWJE50qFd6RDP9y
 Bp6w73Rm
 KoThZywlMJfJ6OswYOMxeMbSZzCrMRDhWCg3KEc9m4TtWm4lbqIi3P8QVTybf3JgqMV+QGTT4oVg0/76garetkj8TMqe4SiOwEZCx0YdAVTL5xTfumWjMntMX6Fa+y/OtNDGrnvJd55xH8I/8rqbM8baG2/qM4b4HQaMus8JbyoafBI1nxXeGBxVtC9TBomzPxzGTGPMyhV7/Cijm8h2tLmy7kVEEIPu1zZZx07zMx0z7GALgp0CIASeWBusheGZYuQyHDCz8HUMelCBrvSpYL4OaeRz6H0VGLKN5kO/tUnmI3vS04oa84L2qsfeRvSGJtrVm+g2dx1/xZnXL0fcdAmBxVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 18:10, David Hildenbrand wrote:
> On 24.09.25 12:02, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
>> markers. Other special markers (e.g., GUARD, POISONED) would not be 
>> caught
>> early, leading to failures deeper in the swap-in logic.
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> As David suggested[1], this patch skips any such non-swap entries early.
>> If a special marker is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work.
> 
> Note that I suggested to skip all non-present entries except swap 
> entries, which includes migration entries, hwpoisoned entries etc.

Oops, I completely misunderstood your suggestion :(

It should be to handle all special non-present entries (migration,
hwpoison, markers), not just a specific type of marker ...

How about this version, which handles all non-swap entries as you
suggested?

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..27f432e7f07c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct 
mm_struct *mm,
         for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
              _pte++, addr += PAGE_SIZE) {
                 pte_t pteval = ptep_get(_pte);
-               if (is_swap_pte(pteval)) {
+               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+                       ++none_or_zero;
+                       if (!userfaultfd_armed(vma) &&
+                           (!cc->is_khugepaged ||
+                            none_or_zero <= khugepaged_max_ptes_none)) {
+                               continue;
+                       } else {
+                               result = SCAN_EXCEED_NONE_PTE;
+                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+                               goto out_unmap;
+                       }
+               } else if (!pte_present(pteval)) {
+                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
+                               result = SCAN_PTE_NON_PRESENT;
+                               goto out_unmap;
+                       }
+
                         ++unmapped;
                         if (!cc->is_khugepaged ||
                             unmapped <= khugepaged_max_ptes_swap) {
@@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct 
mm_struct *mm,
                                  * enabled swap entries.  Please see
                                  * comment below for pte_uffd_wp().
                                  */
-                               if (pte_swp_uffd_wp_any(pteval)) {
+                               if (pte_swp_uffd_wp(pteval)) {
                                         result = SCAN_PTE_UFFD_WP;
                                         goto out_unmap;
                                 }
@@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct 
mm_struct *mm,
                                 goto out_unmap;
                         }
                 }
-               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-                       ++none_or_zero;
-                       if (!userfaultfd_armed(vma) &&
-                           (!cc->is_khugepaged ||
-                            none_or_zero <= khugepaged_max_ptes_none)) {
-                               continue;
-                       } else {
-                               result = SCAN_EXCEED_NONE_PTE;
-                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-                               goto out_unmap;
-                       }
-               }
                 if (pte_uffd_wp(pteval)) {
                         /*
                          * Don't collapse the page if any of the small
---

Thanks,
Lance

