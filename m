Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547D5C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2AF66B012E; Mon, 29 Jun 2026 11:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03D66B0130; Mon, 29 Jun 2026 11:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0DF6B012E; Mon, 29 Jun 2026 11:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 954B96B012E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAAB61A017F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:26 +0000 (UTC)
X-FDA: 84933271332.18.A3A43B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2ED444001A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFio7RIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745465;
	b=KlV8iTzuEyLiXCPOKiiqsQeJ6h1K/Dqo81ZxP/dkhU0TjxcShTfCtY5lZe13rGvlCO096+
	4386OXd0PMO+a7D2Ysc+TXu4MeWa4Tf5PLk9zRRvqn2IDvLfZY61dQXX7++LH+zrRVXMzx
	Y6NPfP63HwmP0MIde1t+iVDT2tqFQnQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njjcJ09hvKJm4DFqkApGQjO9fSrNvBtEtkEmL7ywa5s=;
	b=a2XPmmw6gDHxxy3Jx6pLnrRTdy3Anx4tqsdr6kIL56VfmBJubEF/I77xTKJ+9f6UgvBeT0
	BmQqqFcbaLkf6qilm8OOSVIf/SdauIcndgZZICObTai4KBCfq3jRxo4/V9lCwGXJEGtI5A
	sksgtndJR6xDVkK6Bi3BkGf/vN3cqaw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFio7RIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7416441ADE;
	Mon, 29 Jun 2026 15:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7841C1F000E9;
	Mon, 29 Jun 2026 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745464;
	bh=njjcJ09hvKJm4DFqkApGQjO9fSrNvBtEtkEmL7ywa5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFio7RIWh9qUVn1KVNLiBit78SH4LLPizL9FqW44jft3Vr2XWCwkPsbHTRqAbVO4i
	 DJXgerUwodYxfWKcGXfcssCek5si/ANwdkXnMZhQgEMPxruwf5PA6K88Y+YLkWYmPN
	 pqun5hdQ0I/Y2M9MfQ0ZvZe9JaGaCs26z9fzx3WJ4pk3cJhdxcqGKMPujyWgU3gMQ7
	 sgnf68WV4U9Hr9uUvEskGcjMWVcyQ/J+lolia5Ft96QzWnOSu1bbBaokxkY7TsUtjJ
	 PqkHMy1ywX/SP9fteMIBK0hpuqMI8GsM2dHkxcyofmZO9SiMt9YQnJl0R1Rsj0OhmM
	 NA6OfaQrULYbA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 08/10] mm: introduce and use linear_folio_page_index()
Date: Mon, 29 Jun 2026 16:03:48 +0100
Message-ID: <58b4246bd0cd8b58f86ae7ce2acd54f9f478445a.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2ED444001A
X-Stat-Signature: f4xagcqmz5hcmme9r13bukod5y7zp7td
X-HE-Tag: 1782745465-291921
X-HE-Meta: U2FsdGVkX18OEkPWPLn2iM7vs1apYnBcykaCC5A9CJvvVRqg4sfksuimGyHg8Lt+JnAwIuRbz7NLlQ1v/B9tuDS6Jl3nQyU+TZc6svztKO8pbWpRjWwTRfu5zrF3ck0YTLnx9dAmeJaLNQH71ukMStCQqwjvJx+Zm3nCMWMBQjuDmb7h7+mUuQaXy+abqVnzLr6iJrQECaxd2bKHXyb5Fr2mOn1Qi2vHc7vTbxVOBU52slbC8/1UUzcp17WGxd+SPdE9x4Qt/gQKJYtywtR5ryRsL+jjlK5vuoG9AXNtL3PrkpanzCxFOZg80hoXVCiMzovSSENVV/Jq3l5hHcGZYFVvlykb/g2vQ/5wzIDUy+I2iHbPApFZCa5vwJlGsg2+4XZSy5UJxs6Vv4nUcHnbgi8za26TOqvbt57mEfWBAiCl2urPP2en0LB47ZPICICvXYa/Aa/8I81y8JA3NmKQKQIMVEx5Y/H49PIFYSSOUHYnySlxBfHfMEdSYBfuxDv5vCNUNGw4RgKEDm25UgRdjL9JGIPDvoonlHbhPq+mCeVnr9/H807SU4p8B02xqH1dx8WBX9dcnAfCleZGhsLfW6UUwHn8eKavHj0aBgKx+PgapLrN79I9wGqA3YrBw3F3R8uGZfarHf6L1Cx+Otk24So/b85xWwi4ueVvz4WjNJT1wzXzpZl/IkpO6nIoGN1fhLJK5EpwcNhPiQH59hu0RZo5+OkRCOkSjhKkmTsLe8AJiFdmWYK8uDDRp4PJuNWhLwoVy/rH/jDvdJZBCD4qzuTkxsgTbfhHAgfOQx6L5+yMre1BG0k7py/e2F37FvANOvzqnxUDyp5C7M84ybdzJNV7iqyCJzuKRVeeUsX/ZScNeF5i+5XObRqHo0a1VtDjN/XcaVMnWMQl0D3J/MLffWKxiZRPtubzh5Q8RxmgSymE6RE+r82Kj/4fo3Qwlu2+ANkAZ85TFECeBOLMl3m
 iF2YDd6e
 KsSHGGpB9+qjBreWwjr1i3O44sX7eN/kYYlZLqxr2Obdz4SCMgVly+x9/YybJAAXjkz75qbeL38OZiZjfs8ZFJIpHcYUaExaIkQL0FuAYn6CagCtCFh3NWFlVRmE64euuXfqBINnJhFUGj+e2ukLj0RxycPQd65XlIciuMQPSn8x2dX0N8YAsWj9uCcSO3s0BTDCmu59Ql28lbWCv6lqwOKkhaZS9MR/CO19xnGj+TY8rw/Fymv3jvbD8d9gG35cAyShY4ZDG4zn7JdDu005r9qBjvfeaj8fG8JJTxKqwja9EEVvxj9v2LSUPz01b7ykqoRxEInSlwws+IOihWGMhTZSZFaAvoqa9Ob0dk+fgBGLq0yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is, for now, a placeholder; it will be used in future to
determine whether to use the virtual page index or not, based on whether
the folio is anonymous or not.

Currently it simply wraps linear_page_index(), so this does not change
behaviour.

We update callers that will, once the change is introduced to track
anonymous folios by virtual page offset if MAP_PRIVATE file-backed, need to
determine which index to use based on folio type.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/pagemap.h | 18 ++++++++++++++++++
 mm/huge_memory.c        |  3 ++-
 mm/migrate.c            |  6 ++++--
 mm/userfaultfd.c        |  6 ++++--
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 6e0d719d639a..e2affa57dadd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1146,6 +1146,24 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+/**
+ * linear_folio_page_index() - Determine the absolute page offset of
+ * @address within @vma from @folio.
+ * @folio: The folio whose linear page index is sought.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * For compatibility, currently identical to linear_page_index().
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
+static inline pgoff_t linear_folio_page_index(const struct folio *folio,
+					      const struct vm_area_struct *vma,
+					      const unsigned long address)
+{
+	return linear_page_index(vma, address);
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e94f56487225..1b3456a9ff74 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2832,7 +2832,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..4250a56e09c0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -358,8 +358,10 @@ static bool remove_migration_pte(struct folio *folio,
 		unsigned long idx = 0;
 
 		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
+		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
+			idx += linear_folio_page_index(folio, vma, pvmw.address);
+			idx -= pvmw.pgoff;
+		}
 		new = folio_page(folio, idx);
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index bf4518f4449d..9c6b1a678ca6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1283,7 +1283,8 @@ static long move_present_ptes(struct mm_struct *mm,
 		}
 
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */
@@ -1352,7 +1353,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	 */
 	if (src_folio) {
 		folio_move_anon_rmap(src_folio, dst_vma);
-		src_folio->index = linear_page_index(dst_vma, dst_addr);
+		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
+							   dst_addr);
 	} else {
 		/*
 		 * Check if the swap entry is cached after acquiring the src_pte
-- 
2.54.0


