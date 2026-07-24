Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C50DC53200
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE866B007B; Fri, 24 Jul 2026 09:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738936B0088; Fri, 24 Jul 2026 09:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFD56B008A; Fri, 24 Jul 2026 09:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 161626B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:29:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96B55160344
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:29:45 +0000 (UTC)
X-FDA: 85023752730.23.B219F5F
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0DAC740006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:29:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DSsA2Wny;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784899783;
	b=wfJKSPL4PM4Q53NuqOnXhiHQt72nuDADEJU95MskwmNeo70LZi8oWaUG6mFwOUDmQcJT16
	jL0JXpdthvDYY8HI6GSnymlkRRdDWIy+tyYpgIJx/IYHYvZPEZwr+uEowFHHEEi1vdBxq8
	ufAn0BuJECgwvY2z8Dd4ppfNQU7pqOw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DSsA2Wny;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784899783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zucbfngPhOG8+NfWm24EHKtd2gimDhzVjtuemjoJNMo=;
	b=rR55Lq3fS9UIqBr13lwKmXXzpAdF5djWKCrHCu606XltSWGicue4Vcw6KSa+euqWkdOTjQ
	LJkGdm5axZ/6RfpCFt+aRHRbFy3U4zlUQtTUboftb95rhur5N4JcBeLVhU9lUHid+EkImQ
	NLK2qFfNLgt9I7/x4QNBgqP94Yfzz6Y=
Message-ID: <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784899778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zucbfngPhOG8+NfWm24EHKtd2gimDhzVjtuemjoJNMo=;
	b=DSsA2WnyND/I6X0Gu06lHR30HIAj5CRkpTpduqBZJLueXi9jRtNuMc+kSezi9Y6wY/QGrQ
	Bvq0U7HL+ALJVEFH4Oa5EfvBXPKk4Cvx6Cw0ft3RAISKyhNXtHCowfKZC3TV9Fcz2yFtLV
	NdHeGecqFeQZAe9LRT/KPTTHfetvS4E=
Date: Fri, 24 Jul 2026 14:29:23 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, rientjes@google.com, kernel-team@meta.com
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev> <amK-ApfqfwkPheC5@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amK-ApfqfwkPheC5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dif61937nppdbuzduzcik4r9ogw7ud76
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DAC740006
X-Rspam-User: 
X-HE-Tag: 1784899781-419579
X-HE-Meta: U2FsdGVkX1/gkcNlUQjrZjtnoWIPA7OmZNTxzZ1Jqa76cg51cMypuXLrB1T8J8EdxDVM5ZX/AVHqRoEpEoAvFoGfQGK6811xNeOMtaRtExbY4ZUQdAEAHrQCscHcHNmcnmA0LyMkxDEsK4cd5KtwQ/MdZS/ylxc7Ezwva9hyLXU4DlOZUfQ+801zWlotUjRMyDSv2QC6bPR+qmKVGQD8nvXBGZjjkT4c/otjEGaDJzQEKEAU1MBNgTZIwuW985dDqW2l2jsrpVM56TK1kLxws/IR7RqusEJf2Iih6j7ttvcgZ02Ip3FfZ2+L9+qTQQ8IpDCrnRd3tzKFsWREcwI/uADvPU/MvhV8zuKLI9QclfaXDO9ntcCTLzVOTFhpO27XUbw0soWds90KhnLFphOZwfKRULTsJ8T1CF8qAfwLbLyeadw3fhb+c5jYjHiw3PjRFwWk4BA4/F+K2GIG5ix7eh0OQHHB06M9wh0VLJoaZzBNqhQXqIgo3q1t7ubn8Ei2JnSzXHhRZz6XcdDYnk6BqsRUUdawSvUTMJyuSxkV1yOq29XE8Nq1AjcOByNCvp4FBYhFcqZaGHAa+Ov8+6MmV1j7S6OVvumzDWkYfgAnORNmwppd4mnnzFO1BgV1yLm2XlckH+cUuv9tzew3Axb4g35Mz/afjEX10YRAQxe4Chfb0Q15XEK6w2WQWYgTU1uamisWaQKkMQxcdfnw9cPi4Dr7Y/FTMQG5kUwyWkclgWfIxrBRH6i8nC1CO5G+kL2pcW9jYCoiaXccDPnahAVb7KkKADZQvuBzZfZVOWbCSc1qh2Kg/7+QlK0DwN43FAREPMuABSXjc1l8EMiaD7uruv/i1SxWrGky8mc9IR+d3WoX5TNHffnsuz0mUW3wvtawt0D3GovBig2FnlAMfIQ3useVnqBaQflRR7rk2edp/KL8U8pilEZlcLXl40JJlqc3xUT0U16aAkWoG0KYp+c
 hl4EUM6/
 pYHjBCy6gqq11UCI/9v/A8OvFcznfMPJquETNcB2homZfWl9puRUSE6khDhyefDQoWvx3RQEXXSppFl8pfWBAG87A7LzQMMC7irA8gXmn/5niRgB7eaqBhXDK7FSIRPEfZkAcHtDoJuItfF0dDIyX911583Y1st8J+iofWtnUzEDrqRBsO+AqpJsBjFOFvLmsO6ng1jSiWl6GW0J381TidOzVCVFYPrBeAVK6wi8Vf6QCdx9b9xHCN7K3C5ijlQuCkIPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 02:53, Shakeel Butt wrote:
> On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
>> The anon/file scan balance in get_scan_count() is driven by two scalars
>> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
>> producer under lruvec->lru_lock. The acquisition sites for cost work
>> specifically are:
>>
>>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>>     nr_reclaimed). One acquisition per inactive shrink.
>>   - shrink_active_list() does the same with (0, nr_rotated). One
>>     acquisition per active shrink.
>>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>>     purely to record the refault cost. One acquisition per refault.
>>   - prepare_scan_control() takes lru_lock just to snapshot the two
>>     scalars into sc->{anon,file}_cost.
>>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>>     re-acquires lru_lock on each ancestor to propagate the update,
>>     adding O(memcg-depth) acquisitions per producer call.
>>
>> This hurts because lru_lock is already a heavy contention point on
>> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
>> and folio_add_lru() takes it. The cost work itself is trivial (two
>> scalar bumps and one comparison), but it contends with and causes
>> contention for actual LRU manipulation. The parent_lruvec() walk also
>> multiplies cost-update overhead by memcg hierarchy depth.
>>
>> Replace the producer-side accumulators with a read-side accumulator fed
>> from per-LRU vmstat counters. The old producer formula was:
>>
>>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
>>
>> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
>> already bumped by writeout() for the same successful outcome that fed
>> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
>> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
>> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
>> be sampled per lruvec and aggregated through the memcg hierarchy.
>>
>> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
>> producer-local input. They are bumped from shrink_inactive_list() by
>> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
>> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
>> lru_note_cost_refault() used to bill.
>>
>> Add a per-side struct lru_cost { count, last_rotated, last_io } to
>> struct lruvec. In prepare_scan_control() the two monotonic inputs are
>> sampled separately - rotated from PGROTATE_ANON/FILE, io from
>> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
>> raw per-side deltas are computed against cost->last_rotated and
>> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
>> Extracting the deltas from the individual counters (rather than from a
>> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
>> true per-counter growth, so a signed-long wraparound of any underlying
>> vmstat still yields the correct delta on 32-bit. The weighted delta is
>> folded into cost->count. Since one vmstat delta can cover many producer
>> events between reclaim passes, halve cost->count on both sides until
>> their sum is back within the lrusize/4 bound instead of halving only
>> once.
>>
>> Moving accumulation and decay to the reclaim side also improves the cost
>> model across reclaim gaps. With producer-side decay, events that happen
>> while reclaim is idle still age each other before reclaim ever samples
>> the costs. If a workload refaults a large anon set and then a smaller
>> file set before reclaim runs again, the later file activity can age the
>> earlier anon activity out of the cost model. The new scheme observes the
>> whole between-reclaim delta and decays anon and file proportionally, so
>> the scan-balance history better represents what happened since the last
>> reclaim pass.
>>
>> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
>> extraction, the cost->count update and the halving loop against
>> concurrent reclaimers in the same memcg+node.
>>
>> Hierarchy aggregation is now implicit in the vmstat accounting. The
>> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
>> existed only because anon_cost/file_cost were private lruvec fields. With
>> the cost expressed as lruvec vmstats, rstat propagates the underlying
>> counters through the memcg hierarchy and prepare_scan_control() consumes
>> the same ratelimited rstat view as the surrounding reclaim heuristics.
>>
>> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
>> no longer needed and is removed.
>>
>> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
>> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
>> The reported values only refresh when prepare_scan_control() runs and
>> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
>> they express is unchanged.
>>
>> Under pure MGLRU the scan-balance signal itself is not consumed (both
>> prepare_scan_control() and get_scan_count() are short-circuited on the
>> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
>> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
>> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
>> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
>> evict_folios() so per-memcg observability of rotation-driven reclaim work
>> stays consistent across both implementations.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Oh man too long commit message, please follow Johannes's suggestion.

Will do!
> 
> The patch looks good but I have one question. We already have concept of
> pgrotated through /proc/vmstat which represents number of pages we have moved to
> the tail of inactive LRU to make them next reclaim candidates. This patch is
> exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> the number of pages we scanned but didn't reclaim plus number of pages given one
> more trip in the active LRU.
> 
> Older and newer pgrotate metrics kind of represent something different. It may
> cause confusion. Now before suggesting to change the name, let me ask do we
> really need to expose these to the userspace? How exactly users can use these
> new metrics? I think you can use them here without exposing to userspace. So,
> does it makes sense to delay userspace exposure later when we have a more solid
> usecase for that unless you have it already.
> 

I do think the userspace counters have diagnostic value. They can be another metric
to show how much anon/file reclaim work is spent on pages that are not immediately
reclaimed, including pages retained on actie LRU. It could help explain if there
is elevated reclaim CPU usage.

But tbf, I don't have a concrete usecase, and I wouldn't put up a patch to expose
them to userspace if it werent for this patch itself.

I definitely dont want to create another hidden lruvec rstat infrastructure for this,
it would be too much code churn. If the stats really shouldn't be exposed to userspace,
would something like below be acceptable?


diff --git a/drivers/base/node.c b/drivers/base/node.c
index 3da91929ad4e..3321d4e62234 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -612,7 +612,7 @@ static ssize_t node_read_vmstat(struct device *dev,
 				     sum_zone_numa_event_state(nid, i));
 
 #endif
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS_PUBLIC; i++) {
 		unsigned long pages = node_page_state_pages(pgdat, i);
 
 		if (vmstat_item_print_in_thp(i))
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 85303c5867c8..ada3b136a65d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,8 +323,6 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
-	PGROTATE_ANON,
-	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
@@ -333,6 +331,10 @@ enum node_stat_item {
 	NR_KERNEL_FILE_PAGES,
 	NR_GPU_ACTIVE,	/* Pages assigned to GPU objects */
 	NR_GPU_RECLAIM,	/* Pages in shrinkable GPU pools */
+	NR_VM_NODE_STAT_ITEMS_PUBLIC,
+	/* Internal-only node stats must remain at the end. */
+	PGROTATE_ANON = NR_VM_NODE_STAT_ITEMS_PUBLIC,
+	PGROTATE_FILE,
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8693aad26ca2..fd1960eed732 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -420,12 +420,12 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
-	PGROTATE_ANON,
-	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 };
 
 static const unsigned int memcg_stat_items[] = {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 87d4a6781367..6b14136a6e51 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1300,8 +1300,6 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
-	[I(PGROTATE_ANON)]			= "pgrotate_anon",
-	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
@@ -1310,6 +1308,8 @@ const char * const vmstat_text[] = {
 	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
 	[I(NR_GPU_ACTIVE)]			= "nr_gpu_active",
 	[I(NR_GPU_RECLAIM)]			= "nr_gpu_reclaim",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
@@ -1771,7 +1771,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 	seq_printf(m, "Node %d, zone %8s", pgdat->node_id, zone->name);
 	if (is_zone_first_populated(pgdat, zone)) {
 		seq_printf(m, "\n  per-node stats");
-		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS_PUBLIC; i++) {
 			unsigned long pages = node_page_state_pages(pgdat, i);
 
 			if (vmstat_item_print_in_thp(i))
@@ -1948,6 +1948,11 @@ static int vmstat_show(struct seq_file *m, void *arg)
 {
 	unsigned long *l = arg;
 	unsigned long off = l - (unsigned long *)m->private;
+	unsigned long node_off = NR_VM_ZONE_STAT_ITEMS + NR_VM_NUMA_EVENT_ITEMS;
+
+	if (off >= node_off + NR_VM_NODE_STAT_ITEMS_PUBLIC &&
+	    off < node_off + NR_VM_NODE_STAT_ITEMS)
+		return SEQ_SKIP;
 
 	seq_puts(m, vmstat_text[off]);
 	seq_put_decimal_ull(m, " ", *l);
@@ -2025,7 +2030,7 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
 				__func__, zone_stat_name(i), val);
 		}
 	}
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS_PUBLIC; i++) {
 		/*
 		 * Skip checking stats known to go negative occasionally.
 		 */


> BTW really awesome work and I really like how these patches have reduced the lru
> lock contention drastically.

Thank you!!

