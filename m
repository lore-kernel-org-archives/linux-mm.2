Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5E6CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD2E6B00EC; Sun, 31 May 2026 00:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5846B00EE; Sun, 31 May 2026 00:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB6B6B00EF; Sun, 31 May 2026 00:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCEF66B00EC
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:28:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E9BD1C1960
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:15 +0000 (UTC)
X-FDA: 84826432950.03.1D6953A
Received: from outbound.mr.icloud.com (mr-2001c-snip4-11.eps.apple.com [57.103.68.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A4151C0008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=y1Jjwsgf;
	spf=pass (imf20.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.73 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201693; a=rsa-sha256;
	cv=none;
	b=SGqqhOHtTf/RZK8c0rY2gx1Erlh/d/uu+ATIYvaqkSWlGe5fveMhEOWMKlLeI4WzrDEM1n
	F0Y7IJoo5K7rEv6LoCKz/2VRpJIA+YzFlfddHO8kpw7da5zHlL7AB0utB5icduiWMZx3AN
	hyUEvLBPxqtaDh9TU/EtuAtyrJO5KLI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=y1Jjwsgf;
	spf=pass (imf20.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.73 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dismuyxgoUu32oVKxariHZH1KvI6gzuA1yZho9b0qn4=;
	b=zZl33N4sOebwFin3Is71dyH8cToFoYby9XQ9rLnUMuPSSEsU/3T0TmihmcYvDrYYV/ZipK
	K6HnxhJ4AEN00gowBx/O/8AQ7a6599NQwqP56jSTz/yKw9mLFq9IKoVVbNBoTG4mauI37C
	cWoLj+3kidz6Uo480xQlshkZmEtKAQM=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPS id 158A11800119;
	Sun, 31 May 2026 04:28:06 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9DFEAFWwRYCxNdTFBfVitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201692; x=1782793692; bh=dismuyxgoUu32oVKxariHZH1KvI6gzuA1yZho9b0qn4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=y1JjwsgfBvMs52AxyxBeGlVUqgjCWgV0TX+Nzge/UYjFeQWgOQY+NMXTkzUNM2qPb/L7wHfJ9KVyQa3HnewtBs2VrANFUg7rlHoW9T1eMCuSiZc3GFG0EGdI38rmOdhLGjI8WD4Lw38iwOx73fK26I4Hilh4//l/jICZ71sjtGvOiwlPwA1fvxve5FO+6PSWK3yecYS7JhAkkZffUMxHsRlMXfH0uqgMuHqM6d2VZpMPJhzx2W3Xfrm5yxNvuBgkXc3LtnY0rlgMU/K7ffgRsRm0R851O/YcIF9pwef/VTvdnODYaNCjcQ0iNb+BoJ/tTdssYGk6BSgiiulJs+hLuQ==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPSA id 7EF4E18000A8;
	Sun, 31 May 2026 04:27:55 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:27:19 +0800
Subject: [PATCH 3/5] mm/khugepaged: add deduplication when adding new
 collapse hint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-3-866339cd4c2a@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201643; l=7996;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=N3P/iJQ8BlWvrseSb9JBmO8QdT3darHooCxwnlA5qr0=;
 b=i5egUqtHfUbtbATcvTL8RDNSKrSYd3FUakErTbxmly9nv8AO94Z/hCdS8r0+l/XMoUa1O1SKH
 fgD9aPwDeTiBnAYX2j6+OH3DtOeUICslAoC2Ed3/S0y7SMtuuUCHH5O
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=F9xat6hN c=1 sm=1 tr=0 ts=6a1bb8da
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=nMWqTqnFzTP9CSPNFE4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3TSgtxcgck9PoY_i5WmbPItoV4rX2K--
X-Proofpoint-ORIG-GUID: 3TSgtxcgck9PoY_i5WmbPItoV4rX2K--
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NiBTYWx0ZWRfX8vlJYMDh8xS4
 Kkwu3bFmLwfyB5pwK7bGaUVIJ6ShuM6wgX0voWelHxDosLbaLHhTTgDH9R6CK21Sa13FH5cGhyI
 6jgDXmnqapoLJfQZ2/ZDbZr/eSsjmi1ELRPbH3K9g18mGKuWF05xCllDc/vFPu2UEGXEu4zdMdH
 0ipt2lQ2EU+50Cs0x7/iQ7js7ht04CHmVm6uVpAUHh3zXBGoAhZmrv6TwZRfQgSo4FS/mb3REqq
 eernGYxQBgoiuPGhW4JaXSNrX+qKcWUl727Ntq1xVsep6tME+ApQKCqdnH3AOWYNwp9v7Da1LoM
 gMxVQlDOQnGwgV0sgrfAdB6q2VzIf9N2J3faJnrxgJzCyWFft0a3fEW/Dv8Lzc=
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A4151C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: zm8pmz7xoz1myj9z6q8zyaqst7htssxt
X-HE-Tag: 1780201693-585095
X-HE-Meta: U2FsdGVkX18D5HgNMQ7W27qsvViQj1apJtLx4k6YKtqlsMfkZ7iUOKW1zGZv75ElC/Ry29yZcFmf98bDspSIF8ShpvGKFK4UMIfFYPuVdJ2V05lU1OqMm/24M/iqc8yzAT7/xCSpYjE3O4BjpLwgrXhYX+11/TLkExx7OPu9PArn2BvohEYvmjcDu/Zz9b1JMKi/UNyxDviJNk5uxnuMtH5od7XLdeqrA8s7u5rsHtvJT5qp/Xb75OfY1mP40xwSapSsfOTjG8gAXZJ9u0UCBgae9qE/ZyU1LlFxXL9wdkALDiwOqBWry8QW1i6WAWVCJonaQLTMUq9I4Dz0rSFugUjmzl504J/Y4f+4/P+f43piboE2bayEZgziKMYxNW3vOtSZ5VPG7gmHmDTYwUvDYHW8A9afe8XCt61OMCvMZ1E0vXzqlO+B1IMJ86XnTyfOhia/RkUq96flXoQLmBd7wS/02tgBVvfr4WKEgphOfipTfVPs7O5s2G2/Mrci2v3ib2axWq+71RN576sd17GpQGOlss7JP4rt4aTsnmpvyfrJUaMOLRZYQbgnMJlBqxx0KC1NR1D8j9M8SYiu4OhYh6uX6UZGewIEJlKBKk2G3rQIyuvV5uG1M3PLCj2k8V4pzZdpRhf8HyJ7cH47aBkPLgpjSAZi1TdhGbQBLyvp/Dxr5g6YXYxlHW6paP0SDXtYOR19XHoQCfQEdifNeXw925ZpBTGTdACCstMarN8dr9Z9YZOfIBNMJLePLDeFF9P3dCr0Xz3lAbL4popfOE1ndpt09tW76vDDvasgxTAEgYCXXylBsJUOd/C6E+QwZzyER61bEhbmEL6niWxKrWCEtW1/AbVyDVUmj9SwqBYuvxa1PN3IY1y3YngwQd9Ok1m/FaCymRyAiOLO+q4kMAv0CuyYeDxDkc+1K3nGCVXPiBoaDjA8Ba3c9mvjKvFshmIl/B068K2m8yhYPYhjPFF
 rFyCPWQw
 gzKoqZHaYe+mtwFLUt1zBnyiAObPjHpv5NYReUlwyjQ+/IYXaLoLcxorTj6H/17XBZ+oU2qfBRarX4KKUhxkhR+QYA2OfNO3oo7rjj6E94JcquQxEi/GwjVcevE3oIXT9awR5FjE1GDjjYoGz/8EYKtVlgMhUHKTTwi0kAICHZLGmpGZ8OMS8TmrtDivX2nIHSA9oNbSFPMLuZho7jMIIlC6QKlH/N6E//EvPFcTPcFoMnFjxdEgUA7ye+4d2jkIEWAIWr9mvbS99LYND8K6/tcvpjQRWzOwDDUU4gQZshgEBhpskbwKNX4VBTxUScy60xavM2DATDhmcmsDnU7sAV0qUWrdgc8VmdadDdGG2BilOJuDodBiLXEaTJzPwNV96NbjYeoAI5b570o/+4B1AAMR7/hHhWXd66trJIO5JFpqvKlk8YL43sKIQUw==
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


