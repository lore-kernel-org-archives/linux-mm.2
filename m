Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FE6EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 03:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222BD6B0088; Tue, 30 Dec 2025 22:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D03C6B0089; Tue, 30 Dec 2025 22:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8D86B008A; Tue, 30 Dec 2025 22:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED69E6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:03:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80834C1CF7
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:03:56 +0000 (UTC)
X-FDA: 84278271672.21.5CD43D4
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B1CA140006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:03:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UnQ3nijP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767150234; a=rsa-sha256;
	cv=none;
	b=V+Nxn35TBy53+JaVK5iDYzXyM6rZaMbnJJp26u7Ow6+Ef5JuHfAvPRO5y7ELNqzu5sOYYk
	NHIzv8E5GXrbAb/2iTCHuBMq9NEI1LNDUFbvKKc9hY1H5qb9fExV+3L39p0m3tyla4VhnG
	LNN8/fK9WH1HHF0kA2EkZFnO2w/nwZM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UnQ3nijP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767150234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWAvq8dov7INFoDSveKxp8LJoL97QfNYZbwnUjDG4hM=;
	b=bVOfNvD+c/jAFOsYIeYh2Jb/WRN7TZ0iAzk/kK555Eir4HpSNbcCh34dUQ0Ws55X1wrYbW
	psx0CNu3c71G6n+PwbyKOnG9AIrpf/h4CL7Od9iMgjQdhbQ7ZLlMLt0pYyRKrl24lmdGGZ
	xB2y/XVnEIdT/GeM1/U4jvzPaBNvjoA=
Message-ID: <dafd2f83-c242-4d60-8270-8e52e2e066e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767150231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWAvq8dov7INFoDSveKxp8LJoL97QfNYZbwnUjDG4hM=;
	b=UnQ3nijP6X0/b80mQR948EKNaJrCZarFp2fTfHeiSDk84uHzXtZJ2uV6Xetixo917rL93u
	1YCs1wkbcEpQskFZ9WFMzZ4LbTB6oBFIPc86SXcd4Q0/KM1eCVW7oZUekXGoOBs3RexWxs
	4qdflp3C1Jn82CTaW7XnSF1hlEd/+8E=
Date: Wed, 31 Dec 2025 11:03:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] mm: embed TLB flush IPI check in
 tlb_remove_table_sync_one()
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <20251229145245.85452-4-lance.yang@linux.dev>
 <f4d5548d-6045-47a3-b233-0a67702bb477@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f4d5548d-6045-47a3-b233-0a67702bb477@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8B1CA140006
X-Rspamd-Server: rspam03
X-Stat-Signature: pxpdeha4wgdyow34ojm8hut3hswochdg
X-Rspam-User: 
X-HE-Tag: 1767150234-322096
X-HE-Meta: U2FsdGVkX191H4OEYSHk7n8qBX8Lu4sEjIZ4gN7uA500SbJ4JaXGjIswYrBrejs/lLanVULa/olxoZHfuA9LrbebpdOGJzom07z5xF8YNSG+LGpYR2ykSnzz1fatCoCO1dXo01IrCrYLX44VPsTtCBvefyrZmlCQqTbM13hORi0R9XSHdv6wnvsMC5N4FNl0ZZPxvGMQJg2kVOa4BEzQhJlnR899HZ+dTZLU8QreEPksCcTFuHOBMph3arso+JB4b6cPcFy4fzzJ3Lk4LdisA9a9qazpj0fxFO4Ty8oh8lKIPCtEunXsq/lTucbUeykXXZaXjbWTy0jparH2FtXidrPl6Wq18gIeB+4PtwAggJ4oIhKwKCg35VuZEMoRWFg1UtJR7tGs4VN+LhIUKPI9uehO+js/ON+oZBWqy39RudGmvQwZA+8W2j8mTuOzacdU/Yhcq4gS08cRCHa2pGRoCGg8GVGcqBbaV/dqW3jgSgLbu6+XMHO5czjnpbmqgE0b45a/k8rwsm8pOXiM8q7RcysQGR5kFaCsIGpUr6Z4XJrH824aW++I8J3wKaOkUn6QSezGQGp8oD6M4T38O7z0iZ0rAADu5JKCcGwTQOeo7Ju8r3kHoJ3VDcgttY/pkVYNDCWwflTxkdeQCxwDeafyL03++1g14mS6HeWcTxIMmwhKfYJ94NitiCAdqybPekASO9QAZlJVEl9Nkgm/nS/uUEtIqkNTgH/LDh10CHzxM0z4PyYU9wf58Rr2+OX+Fh6eBkAxN+AdFyqCtKwv4+vEMt7ohlZHENehYm8d+9Pw7ByQZzsO6CopZ5NYJSoj82JAaYUm/5ZJtGEl395oFPDJJDaKcwnnk4uPc5BPGp7riGQOXV1sytWzk5Qzpg6nBbp+XSn72frdLlmBGWNiVSIkiPjgYJXqOwDeFSHynpG1ftVA6LhS2L+ZhZyYzMn34haz1aQVrrFlw5O8FAmo6ir
 /LhaAWT8
 mHQdD0u95TbJYxFQAiqHXoQ8KiMA9LKw+CIBhKXJ7diJEzMmCRJeWkrpex8JFBRIYF1TKPnFHnKFRnwai+dtpbUPets8QohA6mJ9Pq/NJOql9D4VKBtKyrGPFjkypoZLw4pMhtBIxWWnv5QffxUH8qKGBliHf4RKDa3zQzkb0VsUyni/HdG92TYYROSwdsvvFPsJPM5nI4YimTLQLx45yXeGEEkZ0fTAirMEKkpSN/5Fg7HhOPjGQpMQjnj/pbqZrVJOC+TDqc5w5YYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/31 04:33, David Hildenbrand (Red Hat) wrote:
> On 12/29/25 15:52, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
>> tlb_remove_table_sync_one() instead of requiring every caller to check
>> it explicitly. This relies on callers to do the right thing: flush with
>> freed_tables=true or unshared_tables=true beforehand.
>>
>> All existing callers satisfy this requirement:
>>
>> 1. mm/khugepaged.c:1188 (collapse_huge_page):
>>
>>     pmdp_collapse_flush(vma, address, pmd)
>>     -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
>>        -> flush_tlb_mm_range(mm, ..., freed_tables = true)
>>           -> flush_tlb_multi(mm_cpumask(mm), info)
>>
>>     So freed_tables=true before calling tlb_remove_table_sync_one().
>>
>> 2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):
>>
>>     tlb_flush_mmu_tlbonly(tlb)
>>     -> tlb_flush(tlb)
>>        -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
>>           -> flush_tlb_multi(mm_cpumask(mm), info)
>>
>>     unshared_tables=true (equivalent to freed_tables for sending IPIs).
>>
>> 3. mm/mmu_gather.c:341 (__tlb_remove_table_one):
>>
>>     When we can't allocate a batch page in tlb_remove_table(), we do:
>>
>>     tlb_table_invalidate(tlb)
>>     -> tlb_flush_mmu_tlbonly(tlb)
>>        -> flush_tlb_mm_range(mm, ..., freed_tables = true)
>>           -> flush_tlb_multi(mm_cpumask(mm), info)
>>
>>     Then:
>>     tlb_remove_table_one(table)
>>     -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
>>        -> tlb_remove_table_sync_one()
>>
>>     freed_tables=true, and this should work too.
>>
>>     Why is tlb->freed_tables guaranteed? Because callers like
>>     pte_free_tlb() (via free_pte_range) set freed_tables=true before
>>     calling __pte_free_tlb(), which then calls tlb_remove_table().
>>     We cannot free page tables without freed_tables=true.
>>
>>     Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
>>     (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
>>     ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").
>>
>> 4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):
>>
>>     Same as #1. These also use pmdp_collapse_flush() beforehand.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> LGTM. I think we should document that somewhere. Can we add some 

Thanks!

> kerneldoc for tlb_remove_table_sync_one() where we document that it 
> doesn't to any sync if a previous TLB flush when removing/unsharing page 
> tables would have already performed an IPI?

Fair point. Would something like this work?

---8<---
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7b588643cbae..9139f0a6b8bd 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -274,6 +274,20 @@ static void tlb_remove_table_smp_sync(void *arg)
  	/* Simply deliver the interrupt */
  }

+/**
+ * tlb_remove_table_sync_one - Send IPI to synchronize page table 
operations
+ *
+ * Sends an IPI to all CPUs to synchronize when freeing or unsharing page
+ * tables (e.g., to ensure concurrent GUP-fast walkers have completed).
+ *
+ * If a previous TLB flush (when removing/unsharing page tables) already
+ * broadcast IPIs to all CPUs, the redundant IPI is skipped. The 
optimization
+ * relies on architectures implementing 
tlb_table_flush_implies_ipi_broadcast()
+ * to indicate when their TLB flush provides sufficient synchronization.
+ *
+ * Note that callers must ensure that a TLB flush with freed_tables=true or
+ * unshared_tables=true has been performed before calling.
+ */
  void tlb_remove_table_sync_one(void)
  {
  	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
---

Cheers,
Lance

> 
>> ---
>>   mm/mmu_gather.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 7468ec388455..7b588643cbae 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
>>   void tlb_remove_table_sync_one(void)
>>   {
>> +    /* Skip the IPI if the TLB flush already synchronized with other 
>> CPUs. */
>> +    if (tlb_table_flush_implies_ipi_broadcast())
>> +        return;
>> +
>>       /*
>>        * This isn't an RCU grace period and hence the page-tables 
>> cannot be
>>        * assumed to be actually RCU-freed.
> 
> 


