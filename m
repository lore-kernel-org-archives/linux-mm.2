Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39F7D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C116B0338; Thu, 22 Jan 2026 14:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68116B033A; Thu, 22 Jan 2026 14:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9010B6B033B; Thu, 22 Jan 2026 14:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6EF6B0338
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C590C33FD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:21 +0000 (UTC)
X-FDA: 84360596082.19.BAF7B1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48BBF120003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVLP0Mbs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110339; a=rsa-sha256;
	cv=none;
	b=nxzFICaHvheLYHbRFvoqJcMvWkqZHS77RvRX3aBoW0Pxdxpv9M7oibjNVhL/wAQg+jc65P
	3vkv5MRqW6nHjq2JgZDScwoiYcuuufnd9M3L/TgX2B09mw3++iltkqQgsFh3m6DWNn1QW3
	3+l6FtJSTmdQAk1FZdC//7XalDiv/9M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVLP0Mbs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wj7g+9fg4t0TFe+bLM+iGW1aK9feGlcSgA1AXMpzPwk=;
	b=ROhqq589LLUtx5zBKcsGxxlx1cfG706jy/s04up9CaqGX+zRU7xvluXm6aDeI9DRxY2XKr
	sh8b0x3+NuMoszwXFlxJAgeHN72Nuuk+ONVr3gSWsUaN3SH4NYGsOBU12eO+DYUJOnYmBG
	mwjVKSHThWlkYS8/nDj3JZ8jmCSpSMw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wj7g+9fg4t0TFe+bLM+iGW1aK9feGlcSgA1AXMpzPwk=;
	b=WVLP0MbsxFC9yJDcOxrintAgWFTNkA7Ag9xGq4xG5qRhbSzeddTXzMk64lHqvmyAgrL1e+
	G8sBn6u5IjIsRKiCFudZpdU+U0PZkBUaGc1TzI9CmmIBcGrMb1PjDPmNWdUhSWrqHAZWEO
	9o92PI9XvX2y0N9WBPcfm2TieGM30Jc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-j6_NzNJuM-Sa2bgvOclLvg-1; Thu,
 22 Jan 2026 14:32:16 -0500
X-MC-Unique: j6_NzNJuM-Sa2bgvOclLvg-1
X-Mimecast-MFC-AGG-ID: j6_NzNJuM-Sa2bgvOclLvg_1769110331
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCA861955D9B;
	Thu, 22 Jan 2026 19:32:10 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D92E21958DC2;
	Thu, 22 Jan 2026 19:32:01 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 13/16] khugepaged: Introduce mTHP collapse support
Date: Thu, 22 Jan 2026 12:28:38 -0700
Message-ID: <20260122192841.128719-14-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XcDFjyujMk_xAXFvdlSWsoCXJlkBPr--aFdjWPF6FvI_1769110331
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 48BBF120003
X-Stat-Signature: pjswakak598k1obdgxyhnokzx3h5bpza
X-HE-Tag: 1769110339-857586
X-HE-Meta: U2FsdGVkX1/IxXDid9514l+63ZDGJcuI1L6QwrlVU6M8X0LhgxCHMW0EwR1Swolq+wL5BIRGB3XmmyhK/bTFq++kftFgXeQZor4UmFQhmub8GUj3DAa55dWAlNR52KnyNnX6TADE9xtBsIXwWVE+gYc7dQoofWnUo4V+H+XMT32hTZ4ThsUUJYCLWCR9cSCYd7e2lHzJmudULtf4RahudvdCP64uB0KK5aDT9AGwKRo17so66IUJ6IenQuEoauPLizroUS58Br/CpnOlSPS190DmqYBozXDX6XjHmOOWhh0x0ukM1hoLApI82HuvlQH7R4Xd2V/AMXOA7WgwXXg03Rl68X628buV2fiHdxGNDVLM03ARt4QGkzMR9c/LEAcJ4o7pdP+YrAoyT0JS+TtEBIG/O93neiO/IzVS0dnQMziUthN4M6W+ldcJV9wKW7NTGLaxUcI/coHIMmZYO6nRLMFRdAPPBKLjIJO2V+Tm8BjRugryUUQTRMqz2TwNC0u06eSmOQgFQAgd4hbj7OBpqS1OfNRKgLgP9ToCNgGvJQiPu2IlI3fxqIKUIprpkGWRneFzg7NsHxd6eWepbQdT3ms4BoCAatnxlCmgwAWnzGNL1ozTq2T3QjwomhJswXyxLvCHj/OSFKV8pqL9oiRr+HbbKjnI1CRlt9qe16C104w9VFXgjZ20+WOVR3PLxSzBnBs1JoL2aH8u2MQ+DnUVcLcx8XoZdw61yjVTftCYQ9e5C/T1cYr9J0SbwKh+AVSbLuIBKPmv15vjsF0yjtBN8ONdlvcSnXm0EEOPJz93cVIwQfRCNrwQ9HmmwADIOgpenx/Dhefa7cbHCU5QqidCtOGD1rUA7B5fiGL9EZFLXk0M32ORuRTm/iRpNur0sM1AMNl/5ulzoun5Jm0AnA5e0qhFMLFb/wz287EC1mNAA4kdPvR4DgPiJy3EVrgrW0M/IQN7VOLV0GLaSD+YPKU
 BIJky4x1
 PeCzE4bTTz0bsgGnYD5LKFlT+AM7FOfgY+T7x6+8RLeSlmsfq4Dkt4aE8/jSZH8vtiGhVngIFPGa+wn+WhUa0COWaqfZc31kCopCSS+nsAY2STLxZ8bXfXg6dMSqKlmVg1paUq9shBTBo0iPmDDRUfgvpz3YsYHUjpbAlGYxlu1EgrtWoGIuTvzJRM4E2QXQzUvDEms/lVbWr3MutUx7LeO0QBABCFs8AX9pE+MqSKYt0MNeE+tzZXiQzUUcFWTUZNnmg7TpsCU43PklsrcNwcGMMTywTlOOY6x4ASPfevX4oBcIId1hGJ7f/S1abFOYflrFswBmLlCjY2bxNmx0I59jtZOazz6t+EE4N7+TTODukKeh1HyZxujo1Ma8AIDYu86rEx5PSG+itxEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable khugepaged to collapse to mTHP orders. This patch implements the
main scanning logic using a bitmap to track occupied pages and a stack
structure that allows us to find optimal collapse sizes.

Previous to this patch, PMD collapse had 3 main phases, a light weight
scanning phase (mmap_read_lock) that determines a potential PMD
collapse, a alloc phase (mmap unlocked), then finally heavier collapse
phase (mmap_write_lock).

To enabled mTHP collapse we make the following changes:

During PMD scan phase, track occupied pages in a bitmap. When mTHP
orders are enabled, we remove the restriction of max_ptes_none during the
scan phase to avoid missing potential mTHP collapse candidates. Once we
have scanned the full PMD range and updated the bitmap to track occupied
pages, we use the bitmap to find the optimal mTHP size.

Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
and determine the best eligible order for the collapse. A stack structure
is used instead of traditional recursion to manage the search. The
algorithm recursively splits the bitmap into smaller chunks to find the
highest order mTHPs that satisfy the collapse criteria. We start by
attempting the PMD order, then moved on the consecutively lower orders
(mTHP collapse). The stack maintains a pair of variables (offset, order),
indicating the number of PTEs from the start of the PMD, and the order of
the potential collapse candidate.

The algorithm for consuming the bitmap works as such:
    1) push (0, HPAGE_PMD_ORDER) onto the stack
    2) pop the stack
    3) check if the number of set bits in that (offset,order) pair
       statisfy the max_ptes_none threshold for that order
    4) if yes, attempt collapse
    5) if no (or collapse fails), push two new stack items representing
       the left and right halves of the current bitmap range, at the
       next lower order
    6) repeat at step (2) until stack is empty.

Below is a diagram representing the algorithm and stack items:

                           offset       mid_offset
                            |         |
                            |         |
                            v         v
          ____________________________________
         |          PTE Page Table            |
         --------------------------------------
			    <-------><------->
                             order-1  order-1

We currently only support mTHP collapse for max_ptes_none values of 0
and HPAGE_PMD_NR - 1. resulting in the following behavior:

    - max_ptes_none=0: Never introduce new empty pages during collapse
    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
      available mTHP order

Any other max_ptes_none value will emit a warning and skip mTHP collapse
attempts. There should be no behavior change for PMD collapse.

Once we determine what mTHP sizes fits best in that PMD range a collapse
is attempted. A minimum collapse order of 2 is used as this is the lowest
order supported by anon memory as defined by THP_ORDERS_ALL_ANON.

mTHP collapses reject regions containing swapped out or shared pages.
This is because adding new entries can lead to new none pages, and these
may lead to constant promotion into a higher order (m)THP. A similar
issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
introducing at least 2x the number of pages, and on a future scan will
satisfy the promotion condition once again. This issue is prevented via
the collapse_max_ptes_none() function which imposes the max_ptes_none
restrictions above.

Currently madv_collapse is not supported and will only attempt PMD
collapse.

We can also remove the check for is_khugepaged inside the PMD scan as
the collapse_max_ptes_none() function handles this logic now.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 183 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 175 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 11eedd261285..5947faaba85f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -94,6 +94,32 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+/*
+ * The maximum number of mTHP ranges that can be stored on the stack.
+ * This is calculated based on the number of PTE entries in a PTE page table
+ * and the minimum mTHP order.
+ *
+ * ilog2(MAX_PTRS_PER_PTE) is log2 of the maximum number of PTE entries.
+ * This gives you the PMD_ORDER, and is needed in place of HPAGE_PMD_ORDER due
+ * to restrictions of some architectures (ie ppc64le).
+ *
+ * At most there will be 1 << (PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER) mTHP ranges
+ */
+#define MTHP_STACK_SIZE	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
+
+/*
+ * Defines a range of PTE entries in a PTE page table which are being
+ * considered for (m)THP collapse.
+ *
+ * @offset: the offset of the first PTE entry in a PMD range.
+ * @order: the order of the PTE entries being considered for collapse.
+ */
+struct mthp_range {
+	u16 offset;
+	u8 order;
+};
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -102,6 +128,11 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/* bitmap used for mTHP collapse */
+	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
+	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
+	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
 };
 
 /**
@@ -1371,6 +1402,121 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	return result;
 }
 
+static void mthp_stack_push(struct collapse_control *cc, int *stack_size,
+				   u16 offset, u8 order)
+{
+	const int size = *stack_size;
+	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
+
+	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
+	stack->order = order;
+	stack->offset = offset;
+	(*stack_size)++;
+}
+
+static struct mthp_range mthp_stack_pop(struct collapse_control *cc, int *stack_size)
+{
+	const int size = *stack_size;
+
+	VM_WARN_ON_ONCE(size <= 0);
+	(*stack_size)--;
+	return cc->mthp_bitmap_stack[size - 1];
+}
+
+static unsigned int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
+						 u16 offset, unsigned long nr_pte_entries)
+{
+	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+	bitmap_set(cc->mthp_bitmap_mask, offset, nr_pte_entries);
+	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+}
+
+/*
+ * mthp_collapse() consumes the bitmap that is generated during
+ * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
+ *
+ * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
+ * A stack structure cc->mthp_bitmap_stack is used to check different regions
+ * of the bitmap for collapse eligibility. The stack maintains a pair of
+ * variables (offset, order), indicating the number of PTEs from the start of
+ * the PMD, and the order of the potential collapse candidate respectively. We
+ * start at the PMD order and check if it is eligible for collapse; if not, we
+ * add two entries to the stack at a lower order to represent the left and right
+ * halves of the PTE page table we are examining.
+ *
+ *                         offset       mid_offset
+ *                         |         |
+ *                         |         |
+ *                         v         v
+ *      --------------------------------------
+ *      |          cc->mthp_bitmap            |
+ *      --------------------------------------
+ *                         <-------><------->
+ *                          order-1  order-1
+ *
+ * For each of these, we determine how many PTE entries are occupied in the
+ * range of PTE entries we propose to collapse, then we compare this to a
+ * threshold number of PTE entries which would need to be occupied for a
+ * collapse to be permitted at that order (accounting for max_ptes_none).
+
+ * If a collapse is permitted, we attempt to collapse the PTE range into a
+ * mTHP.
+ */
+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		bool *mmap_locked, unsigned long enabled_orders)
+{
+	unsigned int max_ptes_none, nr_occupied_ptes;
+	struct mthp_range range;
+	unsigned long collapse_address;
+	int collapsed = 0, stack_size = 0;
+	unsigned long nr_pte_entries;
+	u16 offset;
+	u8 order;
+
+	mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
+
+	while (stack_size > 0) {
+		range = mthp_stack_pop(cc, &stack_size);
+		order = range.order;
+		offset = range.offset;
+		nr_pte_entries = 1UL << order;
+
+		if (!test_bit(order, &enabled_orders))
+			goto next_order;
+
+		max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
+
+		if (max_ptes_none == -EINVAL)
+			return collapsed;
+
+		nr_occupied_ptes = mthp_nr_occupied_pte_entries(cc, offset, nr_pte_entries);
+
+		if (nr_occupied_ptes >= nr_pte_entries - max_ptes_none) {
+			int ret;
+
+			collapse_address = address + offset * PAGE_SIZE;
+			ret = collapse_huge_page(mm, collapse_address, referenced,
+						 unmapped, cc, mmap_locked,
+						 order);
+			if (ret == SCAN_SUCCEED) {
+				collapsed += nr_pte_entries;
+				continue;
+			}
+		}
+
+next_order:
+		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
+			const u8 next_order = order - 1;
+			const u16 mid_offset = offset + (nr_pte_entries / 2);
+
+			mthp_stack_push(cc, &stack_size, mid_offset, next_order);
+			mthp_stack_push(cc, &stack_size, offset, next_order);
+		}
+	}
+	return collapsed;
+}
+
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			     struct vm_area_struct *vma,
 			     unsigned long start_addr, bool *mmap_locked,
@@ -1378,11 +1524,15 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int none_or_zero = 0, shared = 0, referenced = 0;
+	int i;
+	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
+	unsigned int max_ptes_none;
 	struct folio *folio = NULL;
 	unsigned long addr;
+	unsigned long enabled_orders;
+	bool full_scan = true;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1392,22 +1542,34 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
+
+	/*
+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
+	 * scan all pages to populate the bitmap for mTHP collapse.
+	 */
+	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))
+		full_scan = false;
+	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);
+
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, addr += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		_pte = pte + i;
+		addr = start_addr + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    none_or_zero <= max_ptes_none) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1475,6 +1637,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
+		/* Set bit for occupied pages */
+		bitmap_set(cc->mthp_bitmap, i, 1);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1531,9 +1695,12 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc, mmap_locked,
-					    HPAGE_PMD_ORDER);
+		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
+					      cc, mmap_locked, enabled_orders);
+		if (nr_collapsed > 0)
+			result = SCAN_SUCCEED;
+		else
+			result = SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-- 
2.52.0


