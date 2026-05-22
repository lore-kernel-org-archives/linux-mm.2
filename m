Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5879FCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0966B0093; Thu, 21 May 2026 23:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7D46B0096; Thu, 21 May 2026 23:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04796B0098; Thu, 21 May 2026 23:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8D06B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:00:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40A101A09B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:00:17 +0000 (UTC)
X-FDA: 84793552074.05.EAAED35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66294140010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:00:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdhhnA8vEjdFXaLOuAUDq/tNb/CAaWxDa9KGNAIetpM=;
	b=ivbMNOR55Vi4WtHgFo6JMKWlEeGpbIsw8gqa5lSoX+Sw8ifjS51a7s3cofOa1C2wT0ovm6
	Gil7wTekVDXChvh8TXuQp9aqFbRPC0PMztFCN/4Ncw+6El1fZt1UDsIsleYWsT6vj+X5IT
	JCKlEZAmE3SXnRN0H1GcQYSYqr6ujZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418815; a=rsa-sha256;
	cv=none;
	b=MtDzNa9vcJFBBRpyWBSt23mVYZDA9Ij36e5BbqvIGGpZ2jf+e7IcOH8C/sXkTblxZroYdK
	gZa1DH/gj26TSCGk4Om1If5+5eX8hoF2cuCbz7h2W2ltmcILjJDxPniFt5/jL6WFWoSOp5
	yeDOeYte05E/m55lseNBkRu6yKFHYKo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gM94X2kvPz57DCh;
	Fri, 22 May 2026 11:00:12 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 64M301FL013137;
	Fri, 22 May 2026 11:00:01 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 11:00:02 +0800 (CST)
X-Zmail-TransId: 2af96a0fc6b2973-1fed6
X-Mailer: Zmail v1.0
Message-ID: <202605221100025182H60-ttQ2fjhaBEFVOBRm@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 11:00:02 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDQvNl0ga3NtOiBhZGQgcGdvZmYgaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64M301FL013137
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 22 May 2026 11:00:12 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC6BC.001/4gM94X2kvPz57DCh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66294140010
X-Stat-Signature: gjywdqud8fdng3776cwpydcmj75id8zy
X-Rspam-User: 
X-HE-Tag: 1779418814-638148
X-HE-Meta: U2FsdGVkX1/pEAtXl0FfXv/bOQxZsgb0n/De2FKXUqtX85zi0aucDdkxp1uAGzLMvYNrzJwoJ+XWJ3Xe5JX2Ur/uBEhIUchk6E8afmdY6i46KnN/JIUjDFFP2lAytSUkIJRq6vOoLT1he00JL0LDQ5G4+LWp0CPhKbApvHW/kAsPphMKMMdXVypfYDTslwYbyBRvCYQEfxSbXjT/99fbUKYCxuKueB1sQqJZTCteYws6/LNCho6Og+7TR6Fi/rwUrOXSqNSy40jQ6OO1mIUnBmMHo6DUKkg1ym0MkrrF+ROedIvw4rYwtTJivfjA5y4H4oUfaqyFe/bxWEvZV+HOEw2vaijMwYBZ8ztA1dg552ptAB2XNDSsBm3XqzUVUKxCIUUgTLTRdwqXvklJNvk9Op/1bCQRhAhIWZW+T3bBOxRQAFOfUTmq/o8CNEOqmdAzzeSfwAseBX+UDUo+rGNY23fH+Csme5ret76goK/3k1Q3iwil1BPvALeo3+cZiug7Dt8/xy6O7gkiunM/40GWbtH48Cbf09ZQfuMboVMpUKV2ohVVZWPrpxxCoMeyZGQi6GoTAxQsbTbbTbi/4c7XTrrqaTs6xcMlZRWKWpK+Ifj+Qvekyi08+zhzRSM7UnZ5MYEakExxaDLMKIaL+ybuM7f6CYhxbK2ZkVLbVb+qVHVC+9pNi22rc4hxPThQMvdcSpRSuWDTwAkmYOUhLavEPdIeAJAQ4BD24wZtHelzOITTuakZ6lhAjCqNGeDgol3fMwZn0iCnfH7VWkqytU/vHh70RvpCELEPic5im9xvL1ClddYE1H5pg68xaTXzcaW2oth0D9GncDqBfVBIhpXUVUFg209zEMR/dJOKSdMBaqaqfWRG5Alr2fJ/eccDvDEXwtj7a1f4LOiAhjBXAucSnUXDF5lbdym11zAiYtvHHqJZAdYgMUcNxx7UbrTkE0e/KiUmv009jaHBUJflqw2
 TuIa64K3
 5amvFDT8mHzyWXboQeL74nSlMWQqsp/VPOyzdBwP6BNou0WQa/++tZFM5lXCmfvLnVPOWdCUNRHgPdt6Vkm9GIVSC8xISaN5O93JyoVjWA6DtEruJlZrrZG4kPOR/7DFv7nAArj68wxtvkNSJs58AA44JeEJ6cDO94ZCXhU9YWJiVfF6DCWdgpnDITZgpeGL65gWObU76Jl+u85j0L8o7axv2d1zBe96S5w6QxLUynaU4h+OikJ6r4BAbEKvecfgLEVNgq+frDKv9NU5s9oAdSyOWFXKe7Ns9KRF/nP41rOlu9lX3cObhL+KDz9gS89vQw0nw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

The reason for adding pgoff to ksm_rmap_item has been discussed in previous
mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
to obtain the original page's linear page index, so that during anon_vma_tree
travering, it can conditionally locate the VMAs and avoid scanning the entire
address space [0, ULONG_MAX].

To minimize the size impact of adding pgoff to ksm_rmap_item as much as
possible, a trick that David suggested is to use a UNION that groups the members
related to the unstable tree together with the newly added linear page index. The
members that valids only when in unstable tree include oldchecksum and age information.
However, the function should_skip_rmap_item() in the smart scanning needs slight
modification, since this function still uses the age information even when the
rmap_item is in a stable state (the page is not KSM), a situation that occurs
during COW faults. After using union, the size is still 64 byte without increasing.

We keep the same way to store the pgoff as rmap->anon_vma which is set when the page
is merged and become a KsmPage at try_to_merge_with_ksm_page(), and reset at
remove_rmap_item_from_tree() and remove_node_from_stable_tree() and reset when break_cow.

To be specially clarified, the reason for resetting pgoff at break_cow() is:

- When a page successfully becomes a KSM page (i.e., after stable_tree_append()
  sets STABLE_FLAG), both anon_vma and vm_pgoff are stored and remain valid.
- However, during the merging process there are several failure paths where a
  page that was temporarily treated as a KSM page must be reverted back to an
  anonymous page. Examples include:
    * The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    * stable_tree_insert() fails in cmp_and_merge_page().
  In such cases, break_cow() is invoked to break the COW mapping and discard
  the KSM state.

Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
to release the reference taken during the aborted merge. Because 'pgoff' is
logically paired with anon_vma (both are only meaningful when the rmap_item
is in a stable state), it must also be cleared (or reset) in break_cow() to
avoid leaving stale pgoff values that could confuse subsequent rmap walks
or scanning logic.

[1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
[2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..4761ca3fa984 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -195,22 +195,28 @@ struct ksm_stable_node {
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
- * @age: number of scan iterations since creation
- * @remaining_skips: how many scans to skip
+ * @age: number of scan iterations since creation (unstable node)
+ * @remaining_skips: how many scans to skip (unstable node)
+ * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
 	union {
-		struct anon_vma *anon_vma;	/* when stable */
+		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
 #ifdef CONFIG_NUMA
 		int nid;		/* when node of unstable tree */
 #endif
 	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
-	unsigned int oldchecksum;	/* when unstable */
-	rmap_age_t age;
-	rmap_age_t remaining_skips;
+	union {
+		struct {
+			unsigned int oldchecksum;
+			rmap_age_t age;
+			rmap_age_t remaining_skips;
+		};			/* when unstable */
+		unsigned long pgoff;		/* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	return vma;
 }

+/*
+ * break_cow: actively break the write-protect of the VMA. This is called when
+ * rmap_item has not yet become stable, but page has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/* Reset pgoff that might overlay age-related information. (still unstable) */
+	rmap_item->pgoff = 0;

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;

 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;

@@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);

-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * Must get reference to anon_vma while still holding mmap_lock,
+	 * We set these two members of stable node here instead of
+	 * stable_tree_append(), maybe because we don't want to hold
+	 * mmap_read_lock again. Here mmap_read_lock is already held to
+	 * find_mergeable_vma before merging.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2458,6 +2481,10 @@ static bool should_skip_rmap_item(struct folio *folio,
 	if (folio_test_ksm(folio))
 		return false;

+	/* There is no age information in stable-tree nodes. */
+	if (rmap_item->address & STABLE_FLAG)
+		return false;
+
 	age = rmap_item->age;
 	if (age != U8_MAX)
 		rmap_item->age++;
-- 
2.25.1

