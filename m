Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5D3CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A63A6B00F0; Sun, 31 May 2026 00:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0574D6B00F2; Sun, 31 May 2026 00:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFF66B00F3; Sun, 31 May 2026 00:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D911D6B00F0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:28:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BA9114025B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:33 +0000 (UTC)
X-FDA: 84826433706.18.0DA96B0
Received: from outbound.mr.icloud.com (mr-2005b-snip4-11.eps.apple.com [57.103.71.123])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DBD7140008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=bIgoOTdO;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.71.123 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJuP8KM5OC30RVX6IAZKOJALOHyJ5CznciVNyRZ7oso=;
	b=38/AQ0tF77qouh0XBdERNc3Jzdmznso9HyRWyGNehzKeb99RRAYNTYMzxhECc92kqpZtvi
	I5Ezo8TferQbPOmRSSQD3fgGaTHGZ4FwO87MrOZgE0kZXGQ9UPIlPRSyZ/anyn+QkL4gB/
	clUNpHAqZ1DZa0nwmZERpmnntHSDN3s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=bIgoOTdO;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.71.123 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201711; a=rsa-sha256;
	cv=none;
	b=AF7CicmqUhOO3O4IXD0BXfUXaLqRj1II5pg6TuQCUSF3L347ftRvtRSVt0xqlgAbk4k8De
	W+awEvdEuoBZxNJpSACIHjDuySy+ro41YcAKe528AfqLkjfhnsQ4iNfwvVmM8O4ANOvE9t
	j3mT4i/nMl0tlXRkwkvBK4Pmvb9/UUQ=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPS id 58840180016D;
	Sun, 31 May 2026 04:28:28 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9FFEAFWwRYCxNdTFBfVitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201710; x=1782793710; bh=aJuP8KM5OC30RVX6IAZKOJALOHyJ5CznciVNyRZ7oso=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=bIgoOTdOpAwylAwKjgQxuhyRzeag/KbhuUHNBEXFCDFP6Pjql+r4QMHTAJSx6q1/PWq+2uxxEjn/PcymrNxBjaqAGkbIox3Kbt3h7mp3TKh5LCkeZ/Prc1lUgLvuNojcdf3AMbybbm/FVGtxkAH5LG0PzxnsaZcSkM09BBmcBoel4rRybCxZDhwODeg3BcNvwEAobjRRX79G6Y1ChmVxFQ3Y3e0WDfsgm1hn0ICKehdo6NMp0EJ0JkygolNN6fpWLCXHLiersfwRuBgGPYGj0F7SS5wCas0sEguS+sSKkzHXZJuQnrXjITly+Fs2p3qzlOpFfPYfJcax9AziER6r7A==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPSA id 1AA7D1800172;
	Sun, 31 May 2026 04:28:16 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:27:21 +0800
Subject: [PATCH 5/5] mm/khugepaged: add khugepaged collapse hint in mglru
 reference checking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-5-866339cd4c2a@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201643; l=11044;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=EoL6aiFTXZnLAEbw4iXTl+sM+J/nPblpmXjGgAwVipM=;
 b=oVy+ULdgJO194sz343uXkhFD88xvpUSgqR8u90G61/cMZuZX8QMYmgOb/gX884rYQQ7PEFWSr
 CuBjstk1ETLBtNUXvC5Gcc++AnNBpcJgHASwl7auzluTwUV12U+cNSW
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-ORIG-GUID: bAljHtwMxCkq2ssXyWcEEq_Fx4voKYmt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NiBTYWx0ZWRfX7utu1cuWg6Mk
 YX90SsXpWD6LlExkptCSwgAph1bl1zbOVg6AAo/Ec4Xt8BbFT5/juy0QyoZVkN1wMqwrRu3o3hx
 TdOXUhwhOCcsJah6gJRi92YjUHb6pDX3KMlvR9UULjiBQUrBt7VRo11F1JGZYs2aEvcQV3OOyMK
 9OLvDvW8jrxwuxHkcpFHT1V2KNutBW+Gpk3km1i0evRw/IFBr844RAqaMAKnpnau8usRCDrxzRa
 X+R24heHLTKeBBHVWusgZgQTpcUAg2AZBNPlsqFeDL35OLqqTqtbBr6HSsTcGqeyNTnS5nukNzk
 TqjCcevBwPrTD+Di5BaoRj/sSdgb+fcmqWTxA6uQ3RWMdje71PNiL9tQOuRL7M=
X-Authority-Info-Out: v=2.4 cv=Jov8bc4C c=1 sm=1 tr=0 ts=6a1bb8ee
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=6HC9NpuDrtEngJUpRywA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: bAljHtwMxCkq2ssXyWcEEq_Fx4voKYmt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8DBD7140008
X-Stat-Signature: qennwe3ry5owuzu6o49dx53q5gznx719
X-HE-Tag: 1780201711-989855
X-HE-Meta: U2FsdGVkX18xwSXM917S1igWBWFv7cODHz7d/mVc78V8XxdC5JgUinPsJ4JdarTVBvNVCHlKewf4cPyB5IsfeCerhXKgUZSrY6cCx3vGAwldq5yt1UHo8MRsSToXvFldcnXmj0geLIrZAMWqGjghyl632WIgbr0za+8vJz9XglB9OLQZRZO8lwNpERykxD3GEso0lWHxAEXe2twEjdETNHKcuKZcPK//woaeWOUf1L2XtFv+4EAR9wq8Jw3vWQ/vhi9lM+u7G4xhLU027XPXJVlr/OGyTCnoJE41dOdU/9nzmxZ+0E5qYiuzR/EYoXkGKn/RalQrkJBMsY/bx0v3odo3bXFDjo/yKdG9bJ/FCY/TH6zV2o8xKHnjLhCE9tdpBfL3RabbSu1wjtUURh6HJdCbVVbtapoOxJEoTec3yBWBJkVxqia4M/NQYTpT9b33fNgM1V3CJv0wF1EDTZ8/lQnywuuTzVgLGMvABLYOhCSijmgaoUjZ2cgrRuIs6iILnkotJY3GaOtnNKD1qvPmaNHdWXdyVxNI9z10epV4/yK/E+6pDdna2YzXK8imlNQLVQjjzuviZtFcIyXx0tHuuGWhE87BK3sSLQhK/4+MZitMMcQxhbxeJ7E30xKlUxSv2VlnSCjlX7V+C4doAyNwM0IwspvjxapQbp7lMdCIZ7CkeHHk+m2eHlWxHOV6gYcdJmV49Av2am4XYUyCr/ffncx2DD+yYkuLcf3UiACRN1Toz1Aek7TGCvY9Jlx4uAFVqeRMD8VAeOzuFRRbOLRbaTLGC1oj+lu3VI0sOJeaKzBNaQVS7qHJCT+lYwvkHN0FlSfO4G8IqfFPZsnVUZCTAWDpRskXeXBCTe/PrPPseanH8i8YsMdhpUMKo+9+H25rO9oY5JGtRQvN0q2C87yjhwycvPhegJGNH5jFuXO/lwE9V90wU0qYfgpYAEN57A6eZez+ZAHTAZKPy56yu/G
 lgqTt3fA
 E5HI1DMRrF3U+3Wk5Jx+4RKMAVjhMQcS/Nlpo0r7bSNUYiiut2reKo3TnBhHAyybUft8NLOMfHgF9uusGRw2zUyyzeuBjLPnK0CkLnCrn9bose71QNQUjL8TQPxSIhOLpAOnLniEBcFJf29bMUUZ1JUS7PIsO/DgIbxRmVap957m1zcl0volRlN27dvySnd0gQRagrYye9wYMlMRYxQM21IC2NgDCjKYcsrjCt26kFEKIt+tngaYZ13iEMeK9EbJbSk4ApmzIiz6VUfwExZKweQZuEUz5rFJ/pMulRbM8qY4Bd1bKOY3LPvLh31RCOGVX4XTiRPN6h9Gl+MIP3LnSl4n5WIPx7Kv/I4LvwwcWD5zkoTca4RdXcNH4bmTsWPiFPXKiQ9CBVgdeZ9Smcl5VvLqdb7VoSE3YnRI0Pkjl0e1WbfkzwrBENrlYcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Function lru_gen_look_around() works for mglru, which is a good way
to reduce the rmap iteration. It is called in folio_referenced_one()
when it tried to reclaim a cold page. By the time it gets the page
table entry lock, it will also check the nearby ptes and try to
update their generation if they are also accessed because of locality
in most of workloads, and put the pmd that it thinks full of hot
pages into a Bloom filter, for the walk through in next aging.

Function walk_mm() is used in mglru during aging. It will go through
all the pmds of a mm_struct if certain pmd is set in the Bloom
filter, which is setup in lru_gen_look_around() above, and indicates
that pmd is frequently accessed in many pages.

Now that lru_gen_look_around() and walk_mm() found hot pmd area, we
can also use their findings as good sources of khugepaged collapse
hint, so we make up collapse hints from there.

Note that lru_gen_look_around() is called with ptl lock locked, so
we don't want to directly call khugepaged_add_collapse_hint() inside
it because it may try to allocate memory. So we introduced a new struct
area_access_info, and use it to get the access info from inside, and
do collapse after the ptl released.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/khugepaged.h |  7 +++++++
 include/linux/mmzone.h     | 17 +++++++++++++++--
 mm/khugepaged.c            | 12 ++++++++++++
 mm/rmap.c                  | 27 ++++++++++++++++++++++++++-
 mm/vmscan.c                | 33 +++++++++++++++++++++++++++++----
 5 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index 815ae87f0f8e..e0793569a9f0 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -17,6 +17,7 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
+extern int get_khp_collapse_priority(int total, int young);
 extern void khugepaged_add_collapse_hint(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -62,6 +63,12 @@ static inline bool current_is_khugepaged(void)
 {
 	return false;
 }
+
+static inline int get_khp_collapse_priority(int total, int young)
+{
+	return 0;
+}
+
 static inline void khugepaged_add_collapse_hint(struct mm_struct *mm,
 					       struct vm_area_struct *vma,
 					       unsigned long address,
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1331a7b93f33..643dd500c121 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -441,6 +441,18 @@ enum lruvec_flags {
 
 #endif /* !__GENERATING_BOUNDS_H */
 
+/*
+ * Used to get the young and total counts for a memory area,
+ * and also the maximum order of all the page table entries
+ * during scanning.
+ */
+struct area_access_info {
+	unsigned long address;
+	int total;
+	int young;
+	int max_order;
+};
+
 /*
  * Evictable folios are divided into multiple generations. The youngest and the
  * oldest generation numbers, max_seq and min_seq, are monotonically increasing.
@@ -689,7 +701,8 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr,
+			 struct area_access_info **acc_info_ptr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -712,7 +725,7 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 }
 
 static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
-		unsigned int nr)
+		unsigned int nr, struct area_access_info **acc_info_ptr)
 {
 	return false;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2f21c0b6ab46..50c363846720 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3031,6 +3031,18 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * The caller needs to make sure the pmd is at least qualified for the
+ * lowest priority of collapsing since this function will always return
+ * a legal priority value.
+ */
+int get_khp_collapse_priority(int total, int young)
+{
+	if (young * 2 >= total)
+		return 0;
+	return NR_KHUGEPAGED_PRIORITY_LEVEL - 1;
+}
+
 /*
  * khugepaged_add_collapse_hint - enqueue a collapse hint
  * @mm:          target mm
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..1cd111e7b299 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -75,6 +75,7 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
+#include <linux/khugepaged.h>
 
 #include <asm/tlb.h>
 
@@ -911,6 +912,12 @@ struct folio_referenced_arg {
 	struct mem_cgroup *memcg;
 };
 
+/*
+ * acc_info is currently only used to track access patterns for khugepaged
+ * collapse hints. 3 entries are enough for most cases, and it's totally
+ * safe if we missed some hints.
+ */
+#define NR_ACC_INFO_EACH_ITER 3
 /*
  * arg: folio_referenced_arg will be passed
  */
@@ -921,6 +928,8 @@ static bool folio_referenced_one(struct folio *folio,
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
 	unsigned int nr;
+	struct area_access_info acc_info[NR_ACC_INFO_EACH_ITER] = {0};
+	int acc_info_count = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
@@ -979,8 +988,16 @@ static bool folio_referenced_one(struct folio *folio,
 		 * simplest approach is to disable this look-around optimization.
 		 */
 		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
-			if (lru_gen_look_around(&pvmw, nr))
+			struct area_access_info *acc_info_ptr = NULL;
+
+			/* If the acc_info is full, skip the remaining ones */
+			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+				acc_info_count < NR_ACC_INFO_EACH_ITER)
+				acc_info_ptr = &acc_info[acc_info_count];
+			if (lru_gen_look_around(&pvmw, nr, &acc_info_ptr))
 				referenced++;
+			if (acc_info_ptr && acc_info_ptr != &acc_info[acc_info_count])
+				acc_info_count++;
 		} else if (pvmw.pte) {
 			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
@@ -1019,6 +1036,14 @@ static bool folio_referenced_one(struct folio *folio,
 		pra->vm_flags |= vma->vm_flags & ~VM_LOCKED;
 	}
 
+	for (--acc_info_count; acc_info_count >= 0; acc_info_count--) {
+		khugepaged_add_collapse_hint(vma->vm_mm, vma,
+			acc_info[acc_info_count].address,
+			get_khp_collapse_priority(acc_info[acc_info_count].total,
+				acc_info[acc_info_count].young),
+			acc_info[acc_info_count].max_order);
+	}
+
 	if (!pra->mapcount)
 		return false; /* To break the loop */
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..a0caf5cac951 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3463,7 +3463,7 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 }
 
 static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+			   struct mm_walk *args, struct area_access_info *acc_info)
 {
 	int i;
 	bool dirty;
@@ -3472,6 +3472,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	unsigned long addr;
 	int total = 0;
 	int young = 0;
+	int max_order = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3522,6 +3523,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 						   max_nr, FPB_MERGE_YOUNG_DIRTY);
 			total += nr - 1;
 			walk->mm_stats[MM_LEAF_TOTAL] += nr - 1;
+			max_order = max(max_order, folio_order(folio));
 		}
 
 		if (!test_and_clear_young_ptes_notify(args->vma, addr, cur_pte, nr))
@@ -3550,6 +3552,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	lazy_mmu_mode_disable();
 	pte_unmap_unlock(pte, ptl);
 
+	acc_info->young = young;
+	acc_info->max_order = max_order;
+	acc_info->total = total;
 	return suitable_to_scan(total, young);
 }
 
@@ -3667,6 +3672,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
 		pmd_t val = pmdp_get_lockless(pmd + i);
+		struct area_access_info acc_info = {0};
 
 		next = pmd_addr_end(addr, end);
 
@@ -3699,11 +3705,16 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(&val, addr, next, args, &acc_info))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
+		/* When acc_info has valid value */
+		if (acc_info.total > 0)
+			khugepaged_add_collapse_hint(vma->vm_mm, vma, addr,
+				get_khp_collapse_priority(acc_info.total, acc_info.young),
+				acc_info.max_order);
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
 	}
@@ -4183,7 +4194,8 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr,
+			 struct area_access_info **acc_info_ptr)
 {
 	int i;
 	bool dirty;
@@ -4202,6 +4214,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct lru_gen_mm_state *mm_state;
 	unsigned long max_seq;
 	int gen;
+	unsigned int max_order = 0;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4265,6 +4278,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 			nr = folio_pte_batch_flags(folio, NULL, pte, &ptent,
 						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+			max_order = max(folio_order(folio), max_order);
 		}
 
 		if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
@@ -4288,8 +4302,19 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
+	if (mm_state && suitable_to_scan(i, young)) {
+		if (*acc_info_ptr) {
+			struct area_access_info acc_info = {
+				.address = start,
+				.total = i,
+				.young = young,
+				.max_order = max_order
+			};
+			*(*acc_info_ptr) = acc_info;
+			(*acc_info_ptr)++;
+		}
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+	}
 
 	mem_cgroup_put(memcg);
 

-- 
2.52.0


