Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014EDCD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E3D6B00DE; Sun, 31 May 2026 00:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDED6B00E0; Sun, 31 May 2026 00:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386526B00E1; Sun, 31 May 2026 00:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21D6E6B00DE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:24:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E7C5C1911
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:18 +0000 (UTC)
X-FDA: 84826422996.12.B99C560
Received: from outbound.mr.icloud.com (mr-2006g-snip4-11.eps.apple.com [57.103.70.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86CF540007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=wypV5h7J;
	spf=pass (imf17.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.53 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201456; a=rsa-sha256;
	cv=none;
	b=2Qe+ERuQZ37Rq6z8MBRowunDPGDav+HBB8a9OWJZ478C4/H7Z/pDck9N38XbDPBSm6nKea
	HrSzHa2/zTIYj0kA5y4/7Z91KkALD6X30PLpkesdLOHgfpk93OD49t5Wb129yQGsey19TA
	SQPyhdlrKsg3eT6vjVcZCOkjnik1Hss=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=wypV5h7J;
	spf=pass (imf17.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.53 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oGvyeNEYGpSfA/4MLm942YXzmR0k9AWn0ouuVGHwI8=;
	b=Y7abMCXuL9nOWuEoyKEVUhNJhcmr1WJjrII6Me4NKQv1vBjr/aebKUgNn2FQ7tR2YtjVpw
	zEFEvAk+DdNtT4bgldaCEUeYa///aTqkHd4np0uZ8nlCLt88+TLJIjxoitMBDZKy0Usa3j
	HBUbG3lGKsQlBUrB8gXiSCuvJxU3km8=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPS id 15F8F1800123;
	Sun, 31 May 2026 04:24:12 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9BFB0ECw8IAEAKTQVfBitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201455; x=1782793455; bh=8oGvyeNEYGpSfA/4MLm942YXzmR0k9AWn0ouuVGHwI8=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=wypV5h7JaTNk4EyciWAgTrPd46NxszHXG2KgKc8RAn3kFzDVXoT/M3AQ0RdCVIsJytExn0oWVspGdZj/DQ+hN81cykA+BuR5QMZNLm0BXRWkLhsS7o/JjpsGZDyz9jAP9L0mzoYmymeIPHRx70WeDGz7rljWpbdON35K4s3Px/u81e3yKiD+6RPhq03QArooww1EEb0ech8U7DQMKFTBnXRgfVRrxySwvzpjKzjk44AWnpUVwR2p0NQGVns8d/bN+ybyS1YPZChSru0c8XdyhsuwQNhA2ZM7NrzijHBuWG8lIACWzUBc5i86s/u67ugPn8xPLxYzBdplQFol8iu4FA==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPSA id D08FB1800114;
	Sun, 31 May 2026 04:24:02 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:23:49 +0800
Subject: [PATCH 1/5] mm/khugepaged: add framework for khugepaged collapse
 hint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-1-e7f8c2035621@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201432; l=20295;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=Qc6j7M54Jdgp5Rr/qpD9Ky5jlwdbb7ICSoG/i3XfXBk=;
 b=ueNG9BkLYGSvkOmLZxR9qS5RHAiBOqKNY5LJngbZw5NXAsnXGegZfujewL5z0N/soTAAsynkQ
 NucUBjr1mhODePpFi8TvE64uTli0LX5Ri2FWG5CxmvvXc1vh/YfxUSU
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: 1nbZfc1am_-6BkSuZLjlAuYA-K56_Jfv
X-Proofpoint-ORIG-GUID: 1nbZfc1am_-6BkSuZLjlAuYA-K56_Jfv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NSBTYWx0ZWRfX9EFG1i/ng1os
 gaeOwyDxelTW1HxTdkgrL6oQ+FEDNDOFuo0Hf2b8RXoHDd2mMyXz0Ml1Kkk9RpSxrCkdTZwxHJR
 dv+H90fAMHkHW/4hz9Cu13zE+Sj65uPX0dq0jMxYLE4LerZbimMCaQcVSgIbsQrbioEc6xMzibq
 FbTYg/pft2XN5Bkq172gHn/38xBU11vvfWEUe5cXkaUbHNVUZaNC7kQ3u7MWUxZyw43e0yDT1yi
 4VSG5ZHB7sbbN80f/X/ikuNs6ZZo1UPGZDvvUUDgHajDYrkw3oR24mn6MW06sUU0chgot2jk3Qr
 Q0onhOvW4GY/TSz6qrdBIUsPHIcoeT52X/qEVM/CM5uNp+MKQzf0+pslMIoxlk=
X-Authority-Info-Out: v=2.4 cv=Xc+EDY55 c=1 sm=1 tr=0 ts=6a1bb7ef
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=ptP84xlJL3H7308lbwQA:9 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: 86CF540007
X-Rspamd-Server: rspam03
X-Stat-Signature: nysjaau7spfs95tonien8i7ep45dofok
X-HE-Tag: 1780201456-651056
X-HE-Meta: U2FsdGVkX1/Q8NLT89PRMEypNdrZn0ct5REFA/Yqp20odgX/A+bw88SzYSxt9vOclb29MaKA0PsfiVz+p+XB1nTroT0FmKJ1kIHWwG8fSvwv1xWahG5yL+fksDiNxHU/yumE08orn9ScQEjiGvj/kWUyJs/bw9ELnd+I0oTwBjupzENzGI6R0Zfe4qcIz28/q3ZunCuAFDO+wpB4HkzfMBW8Em6wf0niPhGu+cFYNkXfIJJQZnITz0hniW31nAMooX3gRUcq4Hbs4hZAzHUXFeilMiA7adottD12mFkPQcu8pT6AXBYefYCBzs+S/ODS7gmTF4Ph9CLzzxahrLPIIrwZNuWxvynzuRmeSNfymnXA6AIeg/rgnfyWGP+y4xscVICT9rc33c3iX6CdroNpK0/DZAKb6AU7CWLx26UJ4ZmCF7bgXmnlbf7LJFPYcxwDf1cwBCLXfbjiZ25vWZkPFtM933KBlLcLQaeTr+FfLkgd4TZeYmDnisjGbXU14o50FjG+ahhdcsp9KwRgD+QzoL/aRZ8+ZCoPMN36p5SIWxbIHPWSeNpZFgfk4hOibYkO41IS3/+CIvA+NcI8rcdmK6ythK5uFxRRiUh5XSocgxTa3XfpGI/2dWBqXo9UqjWD50sYIPvJXFUzIE5yhZNoNZPJDYXTvWQk0fiTCoPNIsuN9R8F2+DS9duYGN9fT1BpfulwUvdJHahB4PWi0epVg2Y9S8VCrMg/FWoIygMJNOHInrJoaLoEPK+rE5kNkzIYiImuaOAzFSO+79G8NdNBlB67pEbUfNnWgyKeR3bqQNuLKfaJJaxzlDhUIkWbAOfgGlF0AZPTT0Cp24ytw9At836fVV3rgIT7eBsORAd1bSeS19ReJFrBClxt+1ocQIUQlm8kEpSEYaPFGuy5AuozZzZ3lA4nt/l/uEvn6MWqQE+BNPgUXv6x/K/JxrQvuWEnyVp150eWu7snZ9Rs2uw
 VE6PvnL7
 15fa0SLzzA4iHUbBCXMGPsfCbpOczPg3TRHviplVP1DDGXrOlTsRlC/HA1pX6LZb9qNf0hTf/MNndjzlepTiY4QVTsg5JDlFZMjTrvGssRJ6rhH54yYHFCEEb77d6pXfT+t5a9AXtN4kLsnDYAipf0YmZIIDDmuEw3rRufANDbKtp73uzOAGJyCtVT6xXRkfFUlDaIH6H06XwFJVxBif86pPCcVB3bSeL3sk/2HUH/r/xuvl2MxAWR2xJ8ZFfyzYToq2fbqRbxBLl0jbsTFjT+Rr0BhVsLt2JGpPqP42omnIv35GU9xYrN8tiqKY3vCGjX3ZXZmR6qUzXJx28ArKnsVaAFSNOR1NtsaUnealX3kAsRRbvlRnvtOeYUhDqi5J/U///WlISusj6Y0355rjXi3pEF3gMp9fRqnzVUusQK+qrFKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Currently we just have a simple Round-Robin scanning for all the
feasible mm_structs in khugepaged to do collapsing. It is not very
efficient when memory space is huge, and it may waste precious
large folio resources on some cold memory areas that are seldomly
accessed. While at the same time, khugepaged is a very useful tool
for asynchronous large folio merging.

So we introduced khugepaged collapse hint framework in this patch
to try to give khugepaged some priorities for the hot memory areas
when doing collapsing. The hot area indications are regarded as
"collapse hint". Each "collapse hint" has an address and a vma
associated with it to represent a specific hot area that is
preferred to be collapsed. All these hints are aggregated by both
priority and their belonging mm_struct. When khugepaged tries to
collapse, it will first scan the global priority queues that store
these hints, and find the first khugepaged_mm_slot (We added struct
khugepaged_mm_slot and wrapped the old mm_slot for each mm_struct
inside it) that has hints inside it, then try to do collapse on
the address given by the hint. One example is like below (the
mm_slot represents khugepaged_mm_slot I mentioned above):

prio 0 ------()----------------------------------()---------------
            mm_slot0(process A)                mm_slot1(process B)
               |                                               |
           hint0---hint1---hint2---hint3       hint4---hint5---hint6

prio 1 ------()----------------------------------()---------------
            mm_slot0(process A)                mm_slot1(process B)
               |                                               |
             -------                                       hint7---hint8

The khugepaged will firstly try to scan queue of prio 0 (lower prio
number means higher priority), then go through the list, and check
the first khugepaged_mm_slot, which is mm_slot0, then go through
all the hints in it (hint0 ~ hint3 in the above graph). After handling
this hint (no mater success or fail for collapsing), the hint will be
deleted. If one khugepaged_mm_slot doesn't have any hints in it,
khugepaged will scan the next mm_slot; if there is no hint in prio 0
anymore, khugepaged will scan prio 1; if there is no hints in any
prio queues, then it will fallback to do Round-Robin scanning like
before.

We added a number of NR_KHUGEPAGED_PRIORITY_LEVEL(which is 2 currently)
struct khugepaged_collapse_requests into each struct khugepaged_mm_slot.
Each struct khugepaged_collapse_requests is used for this mm_struct
to be put into the global priority queue. We give each mm_struct a node
in each priority queue for hint dispersion and balancing that may be
introduced in the future and for a better lock pattern. Currently the
khugepaged_collapse_requests[] are linked into the global queues in
__khugepaged_enter() and will live there a lifetime of the mm_struct.

Caller can call khugepaged_add_collapse_hint() to add a new hint for a
specific mm_struct. There is still no callers introduced in this patch.
We will add callers in the following patches.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/khugepaged.h |  13 ++
 mm/khugepaged.c            | 348 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 355 insertions(+), 6 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index d7a9053ff4fe..815ae87f0f8e 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -17,6 +17,10 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
+extern void khugepaged_add_collapse_hint(struct mm_struct *mm,
+					struct vm_area_struct *vma,
+					unsigned long address,
+					int priority, int max_order);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd);
 
@@ -31,6 +35,9 @@ static inline void khugepaged_exit(struct mm_struct *mm)
 	if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
 		__khugepaged_exit(mm);
 }
+
+#define NR_KHUGEPAGED_PRIORITY_LEVEL 2
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -55,6 +62,12 @@ static inline bool current_is_khugepaged(void)
 {
 	return false;
 }
+static inline void khugepaged_add_collapse_hint(struct mm_struct *mm,
+					       struct vm_area_struct *vma,
+					       unsigned long address,
+					       int priority, int max_order)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_KHUGEPAGED_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 35a5f8c44c18..5090ffae73f3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -99,6 +99,8 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+#define KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL 10
+
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
 /*
  * mthp_collapse() does an iterative DFS over a binary tree, from
@@ -160,6 +162,53 @@ static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+/**
+ * struct khugepaged_collapse_hint - one collapse hint for a specific address
+ * @node:    list node on khugepaged_collapse_requests.hints
+ * @vma:     hint pointer to the target VMA
+ * @address: PMD-aligned virtual address inside @vma to attempt collapsing on
+ */
+struct khugepaged_collapse_hint {
+	struct list_head node;
+	struct vm_area_struct *vma;
+	unsigned long address;
+};
+
+/**
+ * struct khugepaged_collapse_requests - per-mm, per-priority collapse hints list
+ * @node:    list node on the matching khugepaged_priority_queue[] list
+ * @hints:   list of pending struct khugepaged_collapse_hint for this mm at
+ *           this priority level
+ *
+ * Each khugepaged_mm_slot embeds one request struct per priority level. At
+ * __khugepaged_enter() time, every request is added to the corresponding
+ * khugepaged_priority_queue[] list and stays on that list until the mm
+ * exits khugepaged. While queued, hints for the mm at a given priority are
+ * appended to that priority's @hints;
+ */
+struct khugepaged_collapse_requests {
+	struct list_head node;
+	struct list_head hints;
+};
+
+/**
+ * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
+ * @slot:    hash lookup from mm to mm_slot
+ * @request: per-mm collapse requests, one per priority level, each linked
+ *           into the corresponding khugepaged_priority_queue[] list
+ */
+struct khugepaged_mm_slot {
+	struct mm_slot slot;
+	struct khugepaged_collapse_requests request[NR_KHUGEPAGED_PRIORITY_LEVEL];
+};
+
+/*
+ * One queue per priority level. Lower index means higher priority. The
+ * scanner drains queues in ascending index order, so all hints at higher
+ * priority are processed before any hint at a lower priority.
+ */
+static struct list_head khugepaged_priority_queue[NR_KHUGEPAGED_PRIORITY_LEVEL];
+
 #ifdef CONFIG_SYSFS
 static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 					 struct kobj_attribute *attr,
@@ -500,10 +549,15 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
+	int i;
+
+	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		INIT_LIST_HEAD(&khugepaged_priority_queue[i]);
+
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
 	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
@@ -560,21 +614,27 @@ static bool hugepage_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *khp_mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
+	int i;
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 
-	slot = mm_slot_alloc(mm_slot_cache);
-	if (!slot)
+	khp_mm_slot = mm_slot_alloc(mm_slot_cache);
+	if (!khp_mm_slot)
 		return;
 
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, khp_mm_slot);
 		return;
 	}
 
+	slot = &khp_mm_slot->slot;
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		INIT_LIST_HEAD(&khp_mm_slot->request[i].hints);
+
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
@@ -583,6 +643,12 @@ void __khugepaged_enter(struct mm_struct *mm)
 	 */
 	wakeup = list_empty(&khugepaged_scan.mm_head);
 	list_add_tail(&slot->mm_node, &khugepaged_scan.mm_head);
+	/*
+	 * Link this mm into every priority queue.
+	 */
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		list_add_tail(&khp_mm_slot->request[i].node,
+			      &khugepaged_priority_queue[i]);
 	spin_unlock(&khugepaged_mm_lock);
 
 	mmgrab(mm);
@@ -613,23 +679,59 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 		__khugepaged_enter(vma->vm_mm);
 }
 
+static void khugepaged_release_collapse_hints(
+			  struct khugepaged_collapse_requests *req)
+{
+	struct khugepaged_collapse_hint *hint, *tmp;
+
+	list_for_each_entry_safe(hint, tmp, &req->hints, node) {
+		list_del(&hint->node);
+		kfree(hint);
+	}
+}
+
+/*
+ * Caller must hold khugepaged_mm_lock when removing the request nodes from
+ * the priority queues;
+ */
+static void khugepaged_remove_priority_requests(struct khugepaged_mm_slot *khp_mm_slot)
+{
+	int i;
+
+	lockdep_assert_held(&khugepaged_mm_lock);
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		list_del(&khp_mm_slot->request[i].node);
+}
+
+static void khugepaged_release_all_hints(struct khugepaged_mm_slot *khp_mm_slot)
+{
+	int i;
+
+	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
+		khugepaged_release_collapse_hints(&khp_mm_slot->request[i]);
+}
+
 void __khugepaged_exit(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *khp_mm_slot = NULL;
 	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
 	if (slot && khugepaged_scan.mm_slot != slot) {
+		khp_mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
+		khugepaged_remove_priority_requests(khp_mm_slot);
 		free = 1;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
 	if (free) {
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		mm_slot_free(mm_slot_cache, slot);
+		khugepaged_release_all_hints(khp_mm_slot);
+		mm_slot_free(mm_slot_cache, khp_mm_slot);
 		mmdrop(mm);
 	} else if (slot) {
 		/*
@@ -1804,6 +1906,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 static void collect_mm_slot(struct mm_slot *slot)
 {
+	struct khugepaged_mm_slot *khp_mm_slot =
+		mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1812,6 +1916,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
+		khugepaged_remove_priority_requests(khp_mm_slot);
 
 		/*
 		 * Not strictly needed because the mm exited already.
@@ -1820,7 +1925,8 @@ static void collect_mm_slot(struct mm_slot *slot)
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, slot);
+		khugepaged_release_all_hints(khp_mm_slot);
+		mm_slot_free(mm_slot_cache, khp_mm_slot);
 		mmdrop(mm);
 	}
 }
@@ -2848,6 +2954,211 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * khugepaged_add_collapse_hint - enqueue a collapse hint
+ * @mm:          target mm
+ * @vma:         hint pointer to the VMA covering @address (treated as a hint)
+ * @address:     virtual address; rounded down to HPAGE_PMD_SIZE
+ * @priority:    priority bucket the hint should land in. Lower number == higher
+ *               priority; must be in [0, NR_KHUGEPAGED_PRIORITY_LEVEL).
+ * @max_order:   max order of continuous pt entries inside this target pmd, used
+ *               to decide whether we need to collapse it.
+ *
+ * Tell khugepaged to prioritize collapsing the PMD covering @address in @mm.
+ * The next time collapse_scan_mm_slot() runs it will drain these entries
+ * before the regular round-robin scan, walking priority queues from
+ * highest priority (lowest index) to lowest.
+ *
+ * Hints are aggregated per-mm and per-priority: __khugepaged_enter()
+ * pre-installs one collapse_request per priority level on the matching
+ * khugepaged_priority_queue[] list, and this function appends a
+ * (vma, address) hint to the request that matches @priority.
+ *
+ * Caller must keep @vma alive across this call (mmap_lock, per-VMA lock,
+ * or a corresponding rmap-side lock such as anon_vma_lock_read /
+ * i_mmap_lock_read are all sufficient).
+ *
+ * @vma->vm_flags is read with collapse_allowable_orders().  When the
+ * caller does not hold mmap_lock or a per-VMA lock, the result is
+ * advisory; the real validation happens later in
+ * collapse_scan_one_priority_entry() under mmap_read_lock.
+ *
+ * Caller must also guarantee @mm is alive across this call so the underlying
+ * mm_slot cannot be freed while we append.
+ */
+void khugepaged_add_collapse_hint(struct mm_struct *mm,
+				 struct vm_area_struct *vma,
+				 unsigned long address,
+				 int priority, int max_order)
+{
+	struct khugepaged_mm_slot *khp_mm_slot;
+	struct khugepaged_collapse_hint *hint;
+	struct mm_slot *slot;
+	int orders;
+
+	if (!mm || !vma)
+		return;
+	if (priority < 0 || priority >= NR_KHUGEPAGED_PRIORITY_LEVEL)
+		return;
+
+	orders = collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED);
+	if (highest_order(orders) <= max_order)
+		return;
+
+	/*
+	 * Make sure the mm is enrolled in khugepaged so that its embedded
+	 * collapse_request[] entries are on khugepaged_priority_queue[].
+	 */
+	khugepaged_enter_vma(vma, vma->vm_flags);
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, mm))
+		return;
+
+	hint = kmalloc_obj(struct khugepaged_collapse_hint);
+	if (!hint)
+		return;
+
+	hint->vma = vma;
+	hint->address = address & HPAGE_PMD_MASK;
+
+	/*
+	 * Just use try lock to avoid lock contention because collapse hints are
+	 * just "best-effort" optimization.
+	 */
+	if (!spin_trylock(&khugepaged_mm_lock)) {
+		kfree(hint);
+		return;
+	}
+
+	slot = mm_slot_lookup(mm_slots_hash, mm);
+	if (!slot) {
+		spin_unlock(&khugepaged_mm_lock);
+		kfree(hint);
+		return;
+	}
+	khp_mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+	list_add_tail(&hint->node, &khp_mm_slot->request[priority].hints);
+	spin_unlock(&khugepaged_mm_lock);
+
+	wake_up_interruptible(&khugepaged_wait);
+}
+
+/*
+ * Each enrolled mm owns one request struct per priority level, all of which
+ * live on the matching khugepaged_priority_queue[] list for the lifetime of
+ * the mm_slot. The caller iterates priorities from highest to lowest, and
+ * call collapse_scan_one_priority_entry() to process all mms at this priority,
+ * and handle pending collapse hints for each mm. Repeat until either
+ * @progress_max is reached, the per-mm-slot failure exceeds certain threshold,
+ * or no hints remain for this mm at this priority.
+ *
+ * Caller must hold khugepaged_mm_lock.
+ *
+ * Returns 1 if an mm was processed at this priority, 0 if no mm on
+ * khugepaged_priority_queue[@priority] had any pending hints.
+ */
+static int collapse_scan_one_priority_entry(unsigned int progress_max,
+					     enum scan_result *result,
+					     struct collapse_control *cc,
+					     int priority,
+					     int *fail_count)
+	__releases(&khugepaged_mm_lock)
+	__acquires(&khugepaged_mm_lock)
+{
+	struct khugepaged_collapse_requests *iter_req;
+	struct khugepaged_mm_slot *khp_mm_slot = NULL, *iter_slot;
+	struct mm_struct *mm = NULL;
+	bool lock_dropped = true;
+
+	/*
+	 * We have to call mmget_not_zero() under khugepaged_mm_lock so that
+	 * __khugepaged_exit() cannot free the embedding khugepaged_mm_slot from
+	 * under us once we drop the spinlock.
+	 */
+	list_for_each_entry(iter_req, &khugepaged_priority_queue[priority], node) {
+		if (list_empty(&iter_req->hints))
+			continue;
+		iter_slot = container_of(iter_req, struct khugepaged_mm_slot,
+				    request[priority]);
+		if (mmget_not_zero(iter_slot->slot.mm)) {
+			khp_mm_slot = iter_slot;
+			mm = iter_slot->slot.mm;
+			break;
+		}
+	}
+	if (!khp_mm_slot)
+		return 0;
+
+	spin_unlock(&khugepaged_mm_lock);
+
+	/*
+	 * Drain hints for this mm while we hold mmap_read_lock.
+	 * collapse_single_pmd() may drop the mmap_lock; if so, try once to
+	 * retake it for the next hint.
+	 */
+	while (cc->progress < progress_max &&
+	       *fail_count < KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL) {
+		struct khugepaged_collapse_hint *hint = NULL;
+		struct vm_area_struct *vma;
+		unsigned long addr;
+
+		if (lock_dropped) {
+			if (!mmap_read_trylock(mm)) {
+				(*fail_count)++;
+				continue;
+			}
+			lock_dropped = false;
+		}
+
+		spin_lock(&khugepaged_mm_lock);
+		if (!list_empty(&khp_mm_slot->request[priority].hints)) {
+			hint = list_first_entry(&khp_mm_slot->request[priority].hints,
+						struct khugepaged_collapse_hint,
+						node);
+			list_del(&hint->node);
+		}
+		spin_unlock(&khugepaged_mm_lock);
+
+		if (!hint)
+			break;
+
+		cc->progress++;
+		addr = hint->address;
+
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
+			kfree(hint);
+			break;
+		}
+
+		/*
+		 * Re-validate the cached VMA hint under mmap_read_lock. If the
+		 * address is now covered by a different VMA, or no VMA at all,
+		 * drop the entry. Note that the vma may be a different object
+		 * than the one passed in at enqueue time, but that's a false
+		 * positive that we can safely ignore.
+		 */
+		vma = vma_lookup(mm, addr);
+		if (!vma || vma != hint->vma)
+			goto skip_hint;
+		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED))
+			goto skip_hint;
+		if (addr < ALIGN(vma->vm_start, HPAGE_PMD_SIZE) ||
+		    addr + HPAGE_PMD_SIZE > ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE))
+			goto skip_hint;
+
+		*result = collapse_single_pmd(addr, vma, &lock_dropped, cc);
+		if (*result != SCAN_SUCCEED)
+			(*fail_count)++;
+skip_hint:
+		kfree(hint);
+	}
+
+	if (!lock_dropped)
+		mmap_read_unlock(mm);
+	mmput(mm);
+	spin_lock(&khugepaged_mm_lock);
+	return 1;
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2858,10 +3169,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	int priority_queue_fail_times = 0;
+	int prio;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
 
+	/*
+	 * Drain explicit hints in priority order before the mm_slot scan.
+	 * Iterate priorities from highest (lowest index) to lowest. For each
+	 * priority, handle every mm with hints queued at that priority
+	 * before we move on to the next, lower priority.
+	 */
+	for (prio = 0; prio < NR_KHUGEPAGED_PRIORITY_LEVEL; prio++) {
+		while (priority_queue_fail_times < KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL &&
+			cc->progress < progress_max) {
+			if (collapse_scan_one_priority_entry(progress_max, result, cc,
+				prio, &priority_queue_fail_times) == 0)
+				break;
+		}
+
+		if (cc->progress >= progress_max ||
+		    priority_queue_fail_times >= KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL)
+			break;
+	}
+
+	if (list_empty(&khugepaged_scan.mm_head) ||
+	    cc->progress >= progress_max)
+		return;
+
 	if (khugepaged_scan.mm_slot) {
 		slot = khugepaged_scan.mm_slot;
 	} else {

-- 
2.52.0


