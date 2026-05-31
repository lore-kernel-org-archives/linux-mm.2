Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8553BCD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E966B00E3; Sun, 31 May 2026 00:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF526B00E4; Sun, 31 May 2026 00:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEB56B00E5; Sun, 31 May 2026 00:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 792446B00E3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:24:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8706A120435
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:37 +0000 (UTC)
X-FDA: 84826423794.14.DB2E52C
Received: from outbound.mr.icloud.com (mr-2003c-snip4-7.eps.apple.com [57.103.69.10])
	by imf13.hostedemail.com (Postfix) with ESMTP id 888BE20002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=DhU3144m;
	spf=pass (imf13.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.10 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dismuyxgoUu32oVKxariHZH1KvI6gzuA1yZho9b0qn4=;
	b=8G1BTHkqdmyUKv5iPkGmDhCrwL6OFfFPjm4rOI8GhznCJgSZhYMQ2lh/NvUDns8g9IT2KC
	LPMU6bMP8S79vf2MDU+YAg3UwGfmNO7YpcfP2zKpWda3VlDy8co/CyVLjZQ3zPkhobaURD
	BRODqDyQbcZl4g7ckg2opRO509hO3Pk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=DhU3144m;
	spf=pass (imf13.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.10 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201475; a=rsa-sha256;
	cv=none;
	b=uyBS/F0w0IqoyvhX/rFriVQdfYfpGuRFs0PzlmOW2pmLM7AFH4rWjkJ8HZiCc5Fqqx+NcW
	8+fwYVyIuBeqoClsQB1tQmp+Z/6nTN7lL8BE6UW0Czr1kUHT+ZPzbp3rWauS5JN0c0qSp7
	nuVM0g90bfV3DY+pJG2CXO+LTDDegS8=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPS id 3EA2C180008D;
	Sun, 31 May 2026 04:24:32 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9DFB0ECw8IAEAKTQVfBitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201474; x=1782793474; bh=dismuyxgoUu32oVKxariHZH1KvI6gzuA1yZho9b0qn4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=DhU3144mRtDgJUjto6m8BwILlv/zoYCMe49V2Gy8TMWkzra2WifF/MsMlqH3rvV+HGPIHJCqbFD+FG8r73yeG79tK6dG0w7hH8HEfV6Yba6C1ylEXIEXrIEBG7+3IqCZaKTc+z+7JD1aioHx6bK6cvACpcRxPsSXKY5K8/zSGXG4OZ4OJ1ARgZwwqzV4q5FNqXhvH/gNw1dVbygG241lrVvx+TaA+WPSVTxNomD2Y1T4mu5DCo4Os9y0oWQyTwbDkvRxLlKUbGOlxCqEOU1N47vRz7ItOOFP1wyUkuwmsPVZrkQRxGfcGp6egjZTevgnvE/Qs0ttvqnS/WGrnqkNxg==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPSA id 75716180015A;
	Sun, 31 May 2026 04:24:22 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:23:51 +0800
Subject: [PATCH 3/5] mm/khugepaged: add deduplication when adding new
 collapse hint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-3-e7f8c2035621@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201432; l=7996;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=N3P/iJQ8BlWvrseSb9JBmO8QdT3darHooCxwnlA5qr0=;
 b=N16rmmaibecaLsuTfgCMAzS54slVGIDMGU7XMADvW98uC0Phb1GC1LsxzueBZyiyww/wFqM0z
 /OylNn/E+A2CrY6ODErobdOLfE9nvUqYkVf5oxyY4E7f5/6hL5/vEiP
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: j-_8UMnyrnxggoewd7hZP2Fd-kHmwmka
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NSBTYWx0ZWRfX2CB6DZu4Lezh
 6p9yMxfFFLCdad1JK3wA156ebueMVC0xfgjETodnsy4aLI0fFFtHUZf2iVBXWGo/MntYtvq1//K
 vHIhtGHx6hN02jdjdxmp6LZqT1hubMtY/YOf/GWb0p6nICAli3SzRrpmlS1ZcmtwMxyy4Osz1QX
 t8ZqaeXvU82obnA0MgYS0rwz/bEo0vdSAsO+tSX/kc8n970N4c0135QfXJ0/6kI2irpgmWNZUoG
 Lgtl3VAOpMihWO077RYGVLxgHRQgYepDlYDZe9V4IQBBGGP3SUqepr8MxLOI5rftCbpKQPlErQB
 1aSF71e1ZzUHHDHKJ7PGcrC+0V3FT6aEUro2MrhdY53K26apR5gS3kQSoLI0AY=
X-Authority-Info-Out: v=2.4 cv=K90v3iWI c=1 sm=1 tr=0 ts=6a1bb802
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=nMWqTqnFzTP9CSPNFE4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: j-_8UMnyrnxggoewd7hZP2Fd-kHmwmka
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 888BE20002
X-Stat-Signature: zm8pmz7xoz1myj9z6q8zyaqst7htssxt
X-HE-Tag: 1780201475-894835
X-HE-Meta: U2FsdGVkX18HVUrBPsW8fDYdmNk9qEJo+fYy8EB19EQPbApbs/eD1VGsMgJ/jil7FcqlAQIfYg/HQLAZHHuIpjhBv/4TqeiRLEsKhyxLflyNbMxjZ42WtPgMaofnI1+0wEVeHvb2kWHcXDzcdZRY+dP/smiRHOG0eS5WM1CAjnuBHJxwwrs3MqkF/nqTRJslEao57qG7DHM6XYKdgLupEvQmvs7dSRhbNot4ooXW8+vfL+Uo3aP+KNDs8x0NOaEZQPJqWuhTupqT/kmkwHkVDUd53Ic5Y3iS4cT4b1oOnqux469Xt73PRyInk27TmvjVS3wt8FSbyTcMR73tHf0fcGdmIoAm+6Wz3pJBxL/1d90nKkYWCx+8p+ABtgKOYyDqMxsjDdrKvMbf4Hp/yuPysxot3liMtdu9Kwh11ghDNbfsL3nlR24rcEekEbFxyIGCQuD/4t4uqwSlUALOlUc2zvWq6oyX4bmN6n1K5KrERZkR1E7uZJafGCa7Abs4GKLHblrYGfhianhSNgNW9oOdOgdZ2L8Q6ksYBrd/6nSWOlR99coiUB7DYfV4DJ+9dQxsjgds2DD2T1PplA9cpmK8ZpQWx1z8+PA7DdGoeHRHe4X9LRrO7H9RjVLBLSUp28DWo15PY/LVNgkd36qQYsd71dNRY5pOGx8eJMndoj5Cl06NUovhk/1LH3Rts1IMS/ExbaYstPX9opZwNjkxDD8B+f6vAcoE5iLm6SlCRe0CDnNER2Zl6ZAMXvTeXXIZ+T/y8LLsX4WMsgi7ksPJ0Lw5SvJ8wvh0r625P8L1Fpn3IY2S6tGuPM8PyzdFnwAQ73clwtXFQVJJP/3MTgQOVPu8NOPbjHO2whzMB3JiQpwQyEqmBjfPEwt6crK9/2pqz7QGB7u+7nkHAIHyFWxV1qTs8eHvob7oDafFMD1VCfs8o7jl5qIQcs/tpC/3CRX9HmeCbhsGzyRgd4coLK/r6cl
 rKsCZcs2
 3CtmmPRcCg6GezQqRBZqH00Z73UbulcoKdICbH26zYAopXPFUgY9Vz7GYzbRwkuj9QwsJYmclK5lodYK6F7z2luBWGWyT1t0mMMsU7B7IJTgUSsmEBITpNV8ZQCdRxOCofkzr9XhlNTvmnlwqBhmdPmWjLpSaDAU0YkhUx5yaNTrRV44mjtzhHIM46iWAWmF/oycqVePSpZ57/7/s1/AXKOGnh+euXEu0eT0JJZNdqn1+LidGHkofG1gg7FQoAuSV2P5jvuKmzYK354T3pLjcvyqSJsYFnTXrpQN/FSJDl7w9mvP8Rb+aprIZdK2h6uhZNKpXrYECDpbmSypSi0C4oGByasmuyaF41DAqS07xtIw0lIXw7o5geEM0wd+3fzEBNg5vUBfkkupHJnMV5SdL0uuP0zUuJGpssLcUD516oT9jx40fa6EhMaFzCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

We need to check for duplication before we add a new collapse hint,
and we want the searching and adding to be faster. So there are
several options for doing that:

Option 1. Add a Blooming filter for the hint addresses, but that
will make the hint hard to be deleted after handling.

Option 2. Add a hashtable for each khugepaged_mm_slot. But for a
efficient setup, the hashtable should have maybe 16 ~ 32 slots,
which will cost 128 bytes to 256 bytes for each mm_struct. Seems a
little wasteful.

Option 3. Add an xarray for each khugepaged_mm_slot, which only
takes 16 bytes for each mm_struct. However, each time when we try
to add a new entry into the xarray, it may cause memory allocation.
Collapse hint is supposed to be a best-effort machanism, introducing
xarray seems to be a little too heavy for the calling function.

Option 4. Add a global hashtable for all the memory hints, setup
key by their address and mm_struct ptr. The global hashtable mixes
mm_struct ptr and address as key, but the deduplication only looks
at address for saving memory. As a result, there may be collision
on different mms with a same address. But as we claimed above,
collapse hint is only a best-effort thing, and the collision is
also rare to happen because the address is always 0 for the lower
PMD_SHIFT bits, which normally gives mm struct about 2M size to
scatter (the key is calculated by (ptr of mm ^ pmd aligned address).

By choosing option 4, since the hashtable is global, we decided to
directly use a global lock (we directly use khugepaged_mm_lock here).
To avoid uncessary lock spinning, we used trylock when we try to add
a new hint, and exit when the contension happened. Still, this is
harmless for the correctness of the machanism.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 mm/khugepaged.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 04cf85ea5557..3f5eb8be06d1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -100,6 +100,24 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 static struct kmem_cache *collapse_hint_cache __ro_after_init;
 
+/*
+ * Global lookup table used by khugepaged_add_collapse_hint() to deduplicate
+ * pending hints against an existing address. The key mixes mm and address
+ * but the dedup comparison only looks at @address. As a result, two
+ * different mms hinting the same address may collapse. This is rare
+ * since the aligned_addr is always 0 for the lower PMD_SHIFT bits, which
+ * normally gives mm struct about 2M size for scattering (for 4K paging).
+ * And it's also harmless if the collision happens.
+ */
+#define KHUGEPAGED_HINTS_HASH_BITS	9
+static DEFINE_HASHTABLE(khugepaged_hint_lookup, KHUGEPAGED_HINTS_HASH_BITS);
+
+static inline unsigned long khugepaged_hint_key(struct mm_struct *mm,
+						unsigned long aligned_addr)
+{
+	return (unsigned long)mm ^ aligned_addr;
+}
+
 #define KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL 10
 
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
@@ -165,12 +183,15 @@ static struct khugepaged_scan khugepaged_scan = {
 
 /**
  * struct khugepaged_collapse_hint - one collapse hint for a specific address
- * @node:    list node on khugepaged_collapse_requests.hints
- * @vma:     hint pointer to the target VMA
- * @address: PMD-aligned virtual address inside @vma to attempt collapsing on
+ * @node:      list node on khugepaged_collapse_requests.hints
+ * @hash_node: hlist node on the global khugepaged_hint_lookup table, used
+ *             for deduplication.
+ * @vma:       hint pointer to the target VMA
+ * @address:   PMD-aligned virtual address inside @vma to attempt collapsing on
  */
 struct khugepaged_collapse_hint {
 	struct list_head node;
+	struct hlist_node hash_node;
 	struct vm_area_struct *vma;
 	unsigned long address;
 };
@@ -688,6 +709,29 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 		__khugepaged_enter(vma->vm_mm);
 }
 
+/*
+ * Unhash any hints still queued under @req. Caller must hold
+ * khugepaged_mm_lock so we can safely unhash each hint from the global
+ * khugepaged_hint_lookup table.
+ */
+static void khugepaged_unhash_collapse_hints(
+			  struct khugepaged_collapse_requests *req)
+{
+	struct khugepaged_collapse_hint *hint, *tmp;
+
+	lockdep_assert_held(&khugepaged_mm_lock);
+
+	list_for_each_entry_safe(hint, tmp, &req->hints, node) {
+		hash_del(&hint->hash_node);
+	}
+}
+
+/*
+ * Free any hints still queued under @req. No lock need to be held. Caller
+ * must make sure the hints are already unhashed from the global
+ * khugepaged_hint_lookup table and the mm_slot is removed from the
+ * khugepaged_priority_queue[].
+ */
 static void khugepaged_release_collapse_hints(
 			  struct khugepaged_collapse_requests *req)
 {
@@ -712,6 +756,14 @@ static void khugepaged_remove_priority_requests(struct khugepaged_mm_slot *khp_m
 		list_del(&khp_mm_slot->request[i].node);
 }
 
+static void khugepaged_unhash_all_hints(struct khugepaged_mm_slot *khp_mm_slot)
+{
+	int i;
+
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		khugepaged_unhash_collapse_hints(&khp_mm_slot->request[i]);
+}
+
 static void khugepaged_release_all_hints(struct khugepaged_mm_slot *khp_mm_slot)
 {
 	int i;
@@ -733,6 +785,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 		khugepaged_remove_priority_requests(khp_mm_slot);
+		khugepaged_unhash_all_hints(khp_mm_slot);
 		free = 1;
 	}
 	spin_unlock(&khugepaged_mm_lock);
@@ -1933,6 +1986,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		 */
 
+		khugepaged_unhash_all_hints(khp_mm_slot);
 		/* khugepaged_mm_lock actually not necessary for the below */
 		khugepaged_release_all_hints(khp_mm_slot);
 		mm_slot_free(mm_slot_cache, khp_mm_slot);
@@ -3001,8 +3055,9 @@ void khugepaged_add_collapse_hint(struct mm_struct *mm,
 				 int priority, int max_order)
 {
 	struct khugepaged_mm_slot *khp_mm_slot;
-	struct khugepaged_collapse_hint *hint;
+	struct khugepaged_collapse_hint *hint, *existing;
 	struct mm_slot *slot;
+	unsigned long aligned_addr, key;
 	int orders;
 
 	if (!mm || !vma)
@@ -3022,12 +3077,15 @@ void khugepaged_add_collapse_hint(struct mm_struct *mm,
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, mm))
 		return;
 
+	aligned_addr = address & HPAGE_PMD_MASK;
+	key = khugepaged_hint_key(mm, aligned_addr);
+
 	hint = kmem_cache_alloc(collapse_hint_cache, GFP_KERNEL);
 	if (!hint)
 		return;
 
 	hint->vma = vma;
-	hint->address = address & HPAGE_PMD_MASK;
+	hint->address = aligned_addr;
 
 	/*
 	 * Just use try lock to avoid lock contention because collapse hints are
@@ -3045,7 +3103,21 @@ void khugepaged_add_collapse_hint(struct mm_struct *mm,
 		return;
 	}
 	khp_mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+
+	/*
+	 * For deduplication. The comparison only checks @address here. See comments
+	 * above khugepaged_hint_lookup definition for details.
+	 */
+	hash_for_each_possible(khugepaged_hint_lookup, existing, hash_node, key) {
+		if (existing->address == aligned_addr) {
+			spin_unlock(&khugepaged_mm_lock);
+			kmem_cache_free(collapse_hint_cache, hint);
+			return;
+		}
+	}
+
 	list_add_tail(&hint->node, &khp_mm_slot->request[priority].hints);
+	hash_add(khugepaged_hint_lookup, &hint->hash_node, key);
 	spin_unlock(&khugepaged_mm_lock);
 
 	wake_up_interruptible(&khugepaged_wait);
@@ -3124,6 +3196,7 @@ static int collapse_scan_one_priority_entry(unsigned int progress_max,
 						struct khugepaged_collapse_hint,
 						node);
 			list_del(&hint->node);
+			hash_del(&hint->hash_node);
 		}
 		spin_unlock(&khugepaged_mm_lock);
 

-- 
2.52.0


