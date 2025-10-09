Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01AECCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754738E0044; Thu,  9 Oct 2025 03:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C858E0002; Thu,  9 Oct 2025 03:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530FF8E0044; Thu,  9 Oct 2025 03:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44C918E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:01:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F177C0AAF
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:01:05 +0000 (UTC)
X-FDA: 83977678890.07.3C2E67A
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86A1940012
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:01:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=B0BPfyJp;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759993263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NVwQNPurC1JbCrgHJgbE/7etOjmRopqYYw6BDynSEE=;
	b=BvUiisNFIICUQ1yHmeVc6PrbukLWUQvlgIBB4MQmdYAxaJ14GOJGoBjy1Q1rao6D4gOnrG
	6YgMf/ZeZT7A7+Ck3jYanknMSwb0lHiFhkSYgzkRbGv8LyeP4st9JxVp5WbNYHc3tlwxH6
	EKk0iY+jTFhVLQikFlAAX5HVl5KzVxM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=B0BPfyJp;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759993263; a=rsa-sha256;
	cv=none;
	b=BDGriqMuxuJ2EoDfiTkPoD8y2wphXdYM+GW7cAZv5MDrxyVzFTEtigHpxEb5FiYvyfHhDp
	RFbxzIR8VDmOvQB8x0qGU4qoVVf3inUJBTezFGscpAEG4nA58V/LFVZxbyswyHlJ9dulqm
	0E9pxAC+07UDeomUYmrLN8xvsT1f09w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=6N
	VwQNPurC1JbCrgHJgbE/7etOjmRopqYYw6BDynSEE=; b=B0BPfyJpezjQgAer1i
	O0ox7bG5oR4rW3jbigNoEIvY96rhXzDwn9koNCFd8ow8upXHyHDfRRbM+ulLOM4g
	XC7QmxtUugzLWfv1qxVTGi35A/ZnF67DP3hVOTBi8/2SJE0iygqW/aIo56xcI06Q
	R8KjFh9q7ebOCM3RRmVO08dt8=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAnV+CjXedocoQYBg--.7355S3;
	Thu, 09 Oct 2025 15:00:53 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	wangkefeng.wang@huawei.com,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory failures
Date: Thu,  9 Oct 2025 15:00:45 +0800
Message-ID: <20251009070045.2011920-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009070045.2011920-1-xialonglong2025@163.com>
References: <20251009070045.2011920-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAnV+CjXedocoQYBg--.7355S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw4kuF4xZF1xCr48Cr48JFb_yoWxXryxpa
	y5K3s0krWkJryIgr1xtay0kryFg34kWw4UJFWfCanak3WYqrWvgFW8Xay7JFy5Jr48Ga9a
	gF4DKF1UWF4rtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07beOJ5UUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBgAjh+GjnWsxDdAAAs-
X-Stat-Signature: ugnr5xqmye6om8hmqn4f4g7xu7ixb7n9
X-Rspamd-Queue-Id: 86A1940012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759993262-10867
X-HE-Meta: U2FsdGVkX18YOPyYKyly7ctCtIR4VQ2fM/evDWqmd7i0greV03/4sPAnBBbaZTLL90789RxxItLcdh2MALHBjwpW5GpxHtA2h8/3jrwsI+DXWcaI5cP643TrxzgdCg6eOlDBBNRaN8Ro32QyGDBihc5eTOA7u3/zjcZ2pY3FKN8LuedZKNY36B7Ey6OFvClTiUi/1v6kZ8k/NNTKZuho3f7csY7/2jxSjsFCMjZoQ+YeN5BrtX3zi7pVhgxpJtUzYh5kEETodFNiODZ4g0An1w+DsjVOLE/xOk0Chu+MMRtLuRPTvz9Y22UUnDT9mGWarImc1XPlFSFr1gcA75H590/TUcHPTh8F2YoE6Jpt0tsejHRzD5aSWqzqlnVSCaSfayr3eMc+GO72aUVpGXPlhFQKzqQ7XxVVjS5Rom7GixP1y3paOGipe48waDjL0UcXdQIrs76hOVs/hGlFiXpTpp6RStJsM+nyCKRv1QzEiXD5137P70d2Vj+z1gi2fEy0v1TfN+N1N6ITc+KsKBkfJvTV806OmOKukv8DSoIAx4qa8luQ6hEyqe8E81Ksra0T9xk0WzD9JMkKF17ZJNxKSaw4SrSIllL2QpRmuGh486LTSHlgXXwiBuFwIGNOZcxTrGw6/OXrfsGi56I9ZEUO7IDa14euHJJs9AggTrYJTMFAYb6NZcTFK/u4hy9k41J2a76uLu7t+b9B2E8ZD1safU1YM8OVbs8DXdKbVvREVxug3JSTiTZLR4YfCKegJajN59q1eeV8kJ72fVfpSujYMb36aDdnEKY8qE4bH3al04DWt8SRnDLipRkRMCgXwZJFlqX8pauuC0YIYWRe26QVRsnMkbIp35UEYzzfLE5hX7Zao0Ze6Iybou8y2LJzYIiKhsVCOCHVHHqi+VfrxJ7xYo2szm4+CdkmzgcZppl+7iCXcxD5pBCcdGaiwhkCKbIimo5gqzfzdCyAB5IehEp
 7OM/KMac
 MVI+enrZM+HfxYFpV3+M3QuGTaA2VoVDYV5Qirvhz2SmtkvkHWEBrX3jd5eDpOlCkvHxeTgBNkoIh9R4TK6k2EJJiMrcEFHoV8AF701dhTPip+nBXCJharj4pDN2Qb7DnT8KNhzdgveo7YwZqQJuxqpLZLV6xT4SczRmJ3QQB5AQBtGylwar7HiHuq2/zsDctx7Ng3p6wPx7OFPRxs3MWy2xPwcHP0YWYUj8V5jvrDFyof8bY+to3rJcKo1N9DCjbJUnp8Ycq9rJR5dDuy2Nozt7zP2iSW30z56wQoxtWhwXcbTAw5B6ZSEWUHnM2sNGiQ7iwZenRVWdsbr5ajxjzQDHj8N/8T7Hr9YQ7f2kCzDPxJ4ta531Zet+kJgfZmrYciXXCTQOZOIfWZ5sSF8rQSIoKA1nmQZRIlwBM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

When a hardware memory error occurs on a KSM page, the current
behavior is to kill all processes mapping that page. This can
be overly aggressive when KSM has multiple duplicate pages in
a chain where other duplicates are still healthy.

This patch introduces a recovery mechanism that attempts to migrate
mappings from the failing KSM page to another healthy KSM page within
the same chain before resorting to killing processes.

The recovery process works as follows:
1. When a memory failure is detected on a KSM page, identify if the
failing node is part of a chain (has duplicates)
2. Search for another healthy KSM page within the same chain
3. For each process mapping the failing page:
- Update the PTE to point to the healthy KSM page
- Migrate the rmap_item to the new stable node
4. If all migrations succeed, remove the failing node from the chain
5. Only kill processes if recovery is impossible or fails

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..590d30cfe800 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3084,6 +3084,183 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
+static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
+{
+	struct ksm_stable_node *stable_node, *dup;
+	struct rb_node *node;
+	int nid;
+
+	if (!is_stable_node_dup(dup_node))
+		return NULL;
+
+	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
+		node = rb_first(root_stable_tree + nid);
+		for (; node; node = rb_next(node)) {
+			stable_node = rb_entry(node,
+					       struct ksm_stable_node,
+					       node);
+
+			if (!is_stable_node_chain(stable_node))
+				continue;
+
+			hlist_for_each_entry(dup, &stable_node->hlist,
+					     hlist_dup) {
+				if (dup == dup_node)
+					return stable_node;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static struct folio *
+find_target_folio(struct ksm_stable_node *failing_node, struct ksm_stable_node **target_dup)
+{
+	struct ksm_stable_node *chain_head, *dup;
+	struct hlist_node *hlist_safe;
+	struct folio *target_folio;
+
+	if (!is_stable_node_dup(failing_node))
+		return NULL;
+
+	chain_head = find_chain_head(failing_node);
+	if (!chain_head)
+		return NULL;
+
+	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
+		if (dup == failing_node)
+			continue;
+
+		target_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
+		if (target_folio) {
+			*target_dup = dup;
+			return target_folio;
+		}
+	}
+
+	return NULL;
+}
+
+static int replace_failing_page(struct vm_area_struct *vma, struct page *page,
+			struct page *kpage, unsigned long addr)
+{
+	struct folio *kfolio = page_folio(kpage);
+	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio = page_folio(page);
+	pmd_t *pmd;
+	pte_t *ptep;
+	pte_t newpte;
+	spinlock_t *ptl;
+	int err = -EFAULT;
+	struct mmu_notifier_range range;
+
+	pmd = mm_find_pmd(mm, addr);
+	if (!pmd)
+		goto out;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
+				addr + PAGE_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+
+	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!ptep)
+		goto out_mn;
+
+	if (!is_zero_pfn(page_to_pfn(kpage))) {
+		folio_get(kfolio);
+		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
+		newpte = mk_pte(kpage, vma->vm_page_prot);
+	} else {
+		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
+		ksm_map_zero_page(mm);
+		dec_mm_counter(mm, MM_ANONPAGES);
+	}
+
+	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
+	ptep_clear_flush(vma, addr, ptep);
+	set_pte_at(mm, addr, ptep, newpte);
+
+	folio_remove_rmap_pte(folio, page, vma);
+	if (!folio_mapped(folio))
+		folio_free_swap(folio);
+	folio_put(folio);
+
+	pte_unmap_unlock(ptep, ptl);
+	err = 0;
+out_mn:
+	mmu_notifier_invalidate_range_end(&range);
+out:
+	return err;
+}
+
+static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
+{
+	struct ksm_rmap_item *rmap_item;
+	struct hlist_node *hlist_safe;
+	struct folio *failing_folio = NULL;
+	struct folio *target_folio = NULL;
+	struct ksm_stable_node *target_dup = NULL;
+	int err;
+
+	if (!is_stable_node_dup(failing_node))
+		return false;
+
+	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
+	if (!failing_folio)
+		return false;
+
+	target_folio = find_target_folio(failing_node, &target_dup);
+	if (!target_folio) {
+		folio_put(failing_folio);
+		return false;
+	}
+
+	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
+		struct mm_struct *mm = rmap_item->mm;
+		unsigned long addr = rmap_item->address & PAGE_MASK;
+		struct vm_area_struct *vma;
+
+		mmap_read_lock(mm);
+		if (ksm_test_exit(mm)) {
+			mmap_read_unlock(mm);
+			continue;
+		}
+
+		vma = vma_lookup(mm, addr);
+		if (!vma) {
+			mmap_read_unlock(mm);
+			continue;
+		}
+
+		/* Update PTE to point to target_folio's page */
+		err = replace_failing_page(vma, &failing_folio->page,
+					     &target_folio->page, addr);
+		if (!err) {
+			hlist_del(&rmap_item->hlist);
+			rmap_item->head = target_dup;
+			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
+			target_dup->rmap_hlist_len++;
+			failing_node->rmap_hlist_len--;
+
+		}
+
+		mmap_read_unlock(mm);
+	}
+
+	folio_unlock(target_folio);
+	folio_put(target_folio);
+	folio_put(failing_folio);
+
+	if (failing_node->rmap_hlist_len == 0) {
+		__stable_node_dup_del(failing_node);
+		free_stable_node(failing_node);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Collect processes when the error hit an ksm page.
  */
@@ -3098,6 +3275,12 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 	stable_node = folio_stable_node(folio);
 	if (!stable_node)
 		return;
+
+	if (ksm_recover_within_chain(stable_node)) {
+		pr_debug("recovery within chain successful, no need to kill processes\n");
+		return;
+	}
+
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *av = rmap_item->anon_vma;
 
-- 
2.43.0


