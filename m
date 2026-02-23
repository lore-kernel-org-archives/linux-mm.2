Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF97EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B566B0088; Mon, 23 Feb 2026 07:59:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FE86B0089; Mon, 23 Feb 2026 07:59:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB006B008A; Mon, 23 Feb 2026 07:59:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 484826B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:59:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E47B3B5796
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:59:05 +0000 (UTC)
X-FDA: 84475726650.24.D3F7D09
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf29.hostedemail.com (Postfix) with ESMTP id E9B63120008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:59:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6sxuzEr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771851544; a=rsa-sha256;
	cv=none;
	b=B1UTc3vR8E1cc0jIDo5wCzfNGxhJ2Oa6LkpJsH7PHWmFuA81eNxpA4yidzDMIIYtZZMGEy
	wc8zuUt91n8u/KpQt0j7595NZqGkYPhd0EV2As3eZwo9k8duo4g1uWRvElTkV5nrs6YNkK
	Kuq14IOtYho1rzXDAGkoJcVcU15RZQ8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6sxuzEr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771851544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY8rg80vENS74DCDq2wg3LcsPVEGgVZEiZlEKxhHQW4=;
	b=PSShu2cyvNXx86TTLJc7GV0yOhX1cIED6tnbZQAJp8b0SqVtH0OybInCJHvZU9I5F5qGlV
	3SAkRSnm9DepnqFXsPCspXypXSJSYduTZvq5cryU21DKSYe4bJ/oKt1hrOKDKM7Rtf2JJj
	0tnSSWkWp7b0aqOCruVrQOIVZnKmIHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771851541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PY8rg80vENS74DCDq2wg3LcsPVEGgVZEiZlEKxhHQW4=;
	b=g6sxuzEr7b2yqLLl+dbiWwg5XE22KaWXK0xMhuBXMLgQMJxtoVQhwGJwdOauwdJy9RBxt2
	edKAlnHmpJMJlrxCFpfFcFIMjDZ8Vs6DHCX7WCak09ff7JczBnutPHoSSk6f9W2tJfWHLj
	dzgY+Q0LrVtoGldS7EV7fMXNWr1DsxY=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	dave.hansen@intel.com,
	lance.yang@linux.dev,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	will@kernel.org
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
Date: Mon, 23 Feb 2026 20:58:26 +0800
Message-ID: <20260223125826.28207-1-lance.yang@linux.dev>
In-Reply-To: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g1f6phpfxoasuskhbfxr4uudha5aywnr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9B63120008
X-HE-Tag: 1771851543-941883
X-HE-Meta: U2FsdGVkX1/awwo1O+7eWMK5j460nM/n4pBdv3k2l+RbIiBUmBKVTtqY/3EWa1+AH7SrUbosbttdCyXQY02Q8t4vcS1ncc9WtiE0hNwUT36o2+9KzJzO7HZWuadCHVns7ARjaSPhp+zogw8P5UBSWfHeyZem9444stP8tqGQeesnKKoIwGdGkB57FbSGeqNy/ztbGQ43T9TTz684fDIAeDIO7rhJj5xTZRl3+MKLKuJjJRw9irzUHVgZpJnfdFkfvkJcIHndqdyiRQycKUEjGDXCocSt4udK7k7BCYVxgljFXF3L2i1lBIhvKRv667wdPj9uBEi3HosWw0VTVYzgxqt2QO6dNvLBkGoCum+W5JkAKxmZR+xv2vrHKxe2L3m1FUdIwLXdYZhfLH6tG54lz2Eo5j4ydJu+d6aoQIXqVK+5vLWUCOrBCTUQ1FyhrEwFB7unQPNHLwE/Is3zYZW4zpoW8Ln1b9iSDs8jEPTpUy73dEywSPKq320x1UdNWOZCcTVjFWRKw5E5H92qOoi54TBsgPUUfNLGR+Dc6+80CTyBrayyihJ2h50+XJ3OKF5yyf+QWR8PwhbZ3J62Z+GZMO3miie0YIe+SM83eV59NpIWx0CVsqv4k+cMHxLTInqgmlHTYmkmOCw76YWjMi4eNLSP7MwO2/xT/HnXzx99L06nMnhBpZkzCD0MZ1J9JFjWJAepqAzXRvi3d62VzsmeN9P0hW7kVWVPqM54Zn/rJjloiwxiY3L+wdBY8mjQ7uO6hy91wYWdgEEeEPuJE992ChEweyYlCZb6Grj/U0JCuFJyIkz/kPVgv1sZRdSJoHYUIhNnELtqErcI8QtVTv0AFmDTE4KvmVxA6jFxl3IPiCiPPvt0Z2eN/yPKxnesy5/R2htJFMOb9qzkINYPF/50o3D9H/QxwBUsyfxy/mpzS5bZbnBa23A+nJWNCoc0bVZxdpBI5L8dXni2JU5LPwv
 KNvJ3Lwn
 Y6HIyDzFLLCmbeQeitnNBrNrHxq2hyEcLo2uEZmsYdzwiV4luQOuP3K732UbgI8rMNBWD0EEQ1Kmco3/zNCRClBZ2TfVL4vEyhw/VJb1/n2JoAKWI3hcFgFoaIcYXKHHoeDJJAlPrr0mlF6rSCQ+CNZym1rRNXS9Xy9dVCjKtYhgSivp0lj2lmNl7oM6gd2rSnvOb0E5rdEy1lVikxyAu9rzA3f725ER7yj1rFhGh06ZY23+Gx5qGJchlPPagFl8HHdlHp7dyJqthStJySa6CjZhe8tWYKZB8KE920vzpsG529R60mybq2GFmruweb3NG3KEQw3Cc3XNzdV6CXvKHaeq+6i0TD0qgOEpZmjStZqXRvBd3skphsPWqo4PSmUv9BHq2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Feb 23, 2026 at 10:29:56AM +0100, David Hildenbrand (Arm) wrote:
>On 2/23/26 04:36, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> When freeing page tables, we try to batch them. If batch allocation fails
>> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
>> batching.
>> 
>> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
>> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
>> process is unmapping memory. IPI broadcast was reported to hurt RT
>> workloads[1].
>> 
>> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
>> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
>> local_irq_disable(), which is also an RCU read-side critical section.
>> synchronize_rcu() waits for all such sections to complete, providing the
>> same guarantee as IPI but without disrupting all CPUs.
>> 
>> Since batch allocation already failed, we are in a way slow path, so
>> replacing the IPI with synchronize_rcu() is fine.
>> 
>> We are in process context (unmap_region, exit_mmap) with only mmap_lock
>> held, a sleeping lock. synchronize_rcu() will catch any invalid context
>> via might_sleep().
>> 
>> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
>> 
>> Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
>> Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
>> Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>
>I think it was primarily Peter and Dave suggesting that :)

:)

>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/mmu_gather.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index fe5b6a031717..df670c219260 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -339,7 +339,8 @@ static inline void __tlb_remove_table_one(void *table)
>>   #else
>>   static inline void __tlb_remove_table_one(void *table)
>>   {
>> -	tlb_remove_table_sync_one();
>> +	if (IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE))
>> +		synchronize_rcu();
>
>That should work.
>
>Reading all the comments for tlb_remove_table_smp_sync(), I wonder 
>whether we should wrap that in a tlb_remove_table_sync_rcu() function, 
>with a proper kerneldoc for the CONFIG_MMU_GATHER_RCU_TABLE_FREE variant 
>where we discuss how this relates to tlb_remove_table_sync_one (and 
>tlb_remove_table_smp_sync() .

Good point! That would be cleaner and better ;)

How about the following:

---8<---
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..ea5503d3e650 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -296,6 +296,24 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }

+/**
+ * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
+ *
+ * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
+ * broadcast. Should be used in slow paths where sleeping is acceptable.
+ *
+ * Software/Lockless page-table walkers use local_irq_disable(), which is also
+ * an RCU read-side critical section. synchronize_rcu() waits for all such
+ * sections, providing the same guarantee as tlb_remove_table_sync_one() but
+ * without disrupting all CPUs with IPIs.
+ *
+ * Context: Can sleep/block. Cannot be called from any atomic context.
+ */
+static void tlb_remove_table_sync_rcu(void)
+{
+	synchronize_rcu();
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */

 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -303,6 +321,10 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 	__tlb_remove_table_free(batch);
 }

+static void tlb_remove_table_sync_rcu(void)
+{
+}
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */

 /*
@@ -339,7 +361,7 @@ static inline void __tlb_remove_table_one(void *table)
 #else
 static inline void __tlb_remove_table_one(void *table)
 {
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_rcu();
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
---

Thanks for the suggestion!
Lance

