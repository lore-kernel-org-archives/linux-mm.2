Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E421ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146708E0006; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5EA8E0002; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27DE8E0006; Thu, 16 Oct 2025 06:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAA608E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:19:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80915119357
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:19:44 +0000 (UTC)
X-FDA: 84003581088.24.3FF354B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07A6940012
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:19:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RTyGuK3n;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760609982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbsHV8Lt4ewND6b6/O/ibDugHK4n5HWE1kiOkiKyBZA=;
	b=nzvOOoXT4A6hQ6f+SHeUX21I7J+/AIdQGSzCCZGBoXM/3KTMOfhrtTYxtcFulvHfNbz28b
	WNltSJvU/UJARXgxBq6EbkYgSxIWjF/L5RppcJZygnpW3H1C1xN6T7lSYVh+dtotiXaJt2
	PabHvHZbl5xEdRHAEHk9K25TZVqZ8tg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RTyGuK3n;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760609982; a=rsa-sha256;
	cv=none;
	b=isOLeEiJYv5CgrRqULqgLe/yBE5m4h+6oei02lAzXyxoNN6Qla1jL+gqXgmyh+LM0sfruE
	/FYfqut43o129N2Ajp4Ema1/GolYKecBsm6NinXF3JhvD96MaeoU9vqoF6FXgYwApldENl
	aLJS3QyKBkJZhLYnehiyIgIMUxTu9tA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Zb
	sHV8Lt4ewND6b6/O/ibDugHK4n5HWE1kiOkiKyBZA=; b=RTyGuK3n9H/qj8quj0
	+9Md62ChUCoXyi36uo1diiObr0Bm/HAUBsd0iW4+NlILHI8cXDRpnQu8jyg2/Jw0
	T4Af5u0+krsHNe+FoujzECY/doozxajmxQMcb6BSUU5y1cENc272rs45YdrrW4zt
	0wjM3KZIfFMZuTIrxlwGZukY4=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wC3v6GsxvBoxGKIAg--.5453S3;
	Thu, 16 Oct 2025 18:19:27 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	lance.yang@linux.dev
Cc: markus.elfring@web.de,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	wangkefeng.wang@huawei.com,
	qiuxu.zhuo@intel.com,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by migrating to healthy duplicate
Date: Thu, 16 Oct 2025 18:18:13 +0800
Message-ID: <20251016101813.484565-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251016101813.484565-1-xialonglong2025@163.com>
References: <20251016101813.484565-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3v6GsxvBoxGKIAg--.5453S3
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jw4kZr1UJw1fXrWxKr4kWFg_yoW3KF15pa
	yjk3s0yrWrJry8Wr1Iq340krWaq34vqw4UtFyfCa1Sk3Z0qFWvgFW8W3y7GF9xJr4UJ3WS
	grs0qF15WFWrtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ji9N3UUUUU=
X-Originating-IP: [101.82.139.53]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/1tbiFAPo+GjwwdduuwAAsc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07A6940012
X-Stat-Signature: zqd3oifncnn956cq1cqs4wfburu8qcwq
X-Rspam-User: 
X-HE-Tag: 1760609981-945604
X-HE-Meta: U2FsdGVkX1+7jF5U5Wq/vk8c7r16Z6fy12bcbV/7YPgqnF27BO1+Gk6OQzOv5v/9W5E6oJ3L+JbDkV9C8Trnn2nrndY7W4gTaleMF6EVpDWssa+/jZHh31ydPYuJMOQcKN+yJoemMgiMbLepBRDVtxcLE2JFQ5SmCb5lEr9Vjrn8fEYkvSizL44WSyJnfwVbsm4b6N/6LGA1qg7QtTlIRm6GjiOe+SV4ypp5fayt8kG6xmbqvek6RrOgk18LLrj7mAEKwuJM0wpGfh+gdafqbMhmVmh2x2D2bALdWo7vm8n7TvC/Egr0rExy62GEnTAmHXy+6HvZzkBzEPtWSILJ0VhK/aIoXDtHe06pVT10jdy01vGKqEoNV0KcA0DkOyQDn+SvgCTXwy5UQ52XZtQi3qXmgqm+K3qkEwNpoimEGLEkJs5Xz65Ym3USW29oNnq6OVIe1clAADrjUQLro8nG8iSk+DtCdMsGTJhT/PdIJJ4OVNGGSKX40jdVBFQF1Gp4kdG8mYwGc4iYg7zE6+NlPwl0g5TYl1K2dVxSiE9zv19FPqySDQiO7yh23h0+Ym7LbJ9YK0YTIovkZ8Sk7T7Ndkxk1Sho4jYiwc86a7aAwLcW/YBREpO61MH7hrUi7QPOPfw/OFfuhC8NKONbyOVXR5qaLUay3ZsUmJPwve94k9FuSEVC4o6ac/URft2x7eEzLPJL2zbz2BbDS9F+SXQjHI/KmNdymZrCiBBq6FKvy3Gjt/AMBaebqwBjXkwwdgy7Pg3zQXkMXW52hONulzlcFDO2ytKGAkH6YOGA1EpTFmHJnBm71yH7dNzckJvAuVNkFYTZqqnp56qUprl8NDGmzSfLZLRiLkzf7MecRm7ETxvlMKxbrBZPXbDucpjqlCINLyubV1/42fhP1yH7t1TNQvVO4jZfP4StyN4Vz9bYs7wyeVMuXe9jvhhz3o8pebdGY+ZoN6puzqvKivHYmxU
 zRANcr4V
 5g1c+52X5vG5qLuyvAh52unGNi4emcp4LYrPADS2I91r+Xg04ZueKHea522qzXmG6mqoN0VB3t+T4/Lb9x/bBKaV4DWjcoT+/rufPdEN0z0IuDpc2/p13VZmb754MEr1CywZcuoM5HKn5ayNe+xAERxpMasoAcJ5rGhfJCZG+n1oPYflwYUad4MAjWCxC2oSAoeGbfGDuEmMa5lPtpj8IVlbB7C/0YuWDtIT+WAnXLXaC3X+goux21GIVZHlyswh3jtNnRXl8v6CFtDPNn1Yk9tfyMA2VIK4yKxovnlyh74D+UpKFA0/i71qTKRpdYLgAM9lf/2XFg3qJzPamkP2e3mpHJMvV1fpat1UUBVTYJPdS//v0yObBNlBdhyL/1D5vDQkc0OTr5DT9SMMiwHEsXtcT592K5UQc16kkongNLudOvZ4Fsnes52pFvfnolv9fA+ud
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

This patch introduces a recovery mechanism that attempts to
migrate mappings from the failing KSM page to a newly
allocated KSM page or another healthy duplicate already
present in the same chain, before falling back to the
process-killing procedure.

The recovery process works as follows:
1. Identify if the failing KSM page belongs to a stable node chain.
2. Locate a healthy duplicate KSM page within the same chain.
3. For each process mapping the failing page:
   a. Attempt to allocate a new KSM page copy from healthy duplicate
      KSM page. If successful, migrate the mapping to this new KSM page.
   b. If allocation fails, migrate the mapping to the existing healthy
      duplicate KSM page.
4. If all migrations succeed, remove the failing KSM page from the chain.
5. Only if recovery fails (e.g., no healthy duplicate found or migration
   error) does the kernel fall back to killing the affected processes.

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 246 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..9099bad1ab35 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
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
+					struct ksm_stable_node,
+					node);
+
+			if (!is_stable_node_chain(stable_node))
+				continue;
+
+			hlist_for_each_entry(dup, &stable_node->hlist,
+					hlist_dup) {
+				if (dup == dup_node)
+					return stable_node;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static struct folio *find_healthy_folio(struct ksm_stable_node *chain_head,
+		struct ksm_stable_node *failing_node,
+		struct ksm_stable_node **healthy_dupdup)
+{
+	struct ksm_stable_node *dup;
+	struct hlist_node *hlist_safe;
+	struct folio *healthy_folio;
+
+	if (!is_stable_node_chain(chain_head) || !is_stable_node_dup(failing_node))
+		return NULL;
+
+	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
+		if (dup == failing_node)
+			continue;
+
+		healthy_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
+		if (healthy_folio) {
+			*healthy_dupdup = dup;
+			return healthy_folio;
+		}
+	}
+
+	return NULL;
+}
+
+static struct page *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
+		struct folio *healthy_folio,
+		struct ksm_stable_node **new_stable_node)
+{
+	int nid;
+	unsigned long kpfn;
+	struct page *new_page = NULL;
+
+	if (!is_stable_node_chain(chain_head))
+		return NULL;
+
+	new_page = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_ZERO);
+	if (!new_page)
+		return NULL;
+
+	copy_highpage(new_page, folio_page(healthy_folio, 0));
+
+	*new_stable_node = alloc_stable_node();
+	if (!*new_stable_node) {
+		__free_page(new_page);
+		return NULL;
+	}
+
+	INIT_HLIST_HEAD(&(*new_stable_node)->hlist);
+	kpfn = page_to_pfn(new_page);
+	(*new_stable_node)->kpfn = kpfn;
+	nid = get_kpfn_nid(kpfn);
+	DO_NUMA((*new_stable_node)->nid = nid);
+	(*new_stable_node)->rmap_hlist_len = 0;
+
+	(*new_stable_node)->head = STABLE_NODE_DUP_HEAD;
+	hlist_add_head(&(*new_stable_node)->hlist_dup, &chain_head->hlist);
+	ksm_stable_node_dups++;
+	folio_set_stable_node(page_folio(new_page), *new_stable_node);
+	folio_add_lru(page_folio(new_page));
+
+	return new_page;
+}
+
+static int replace_failing_page(struct vm_area_struct *vma, struct page *page,
+		struct page *kpage, unsigned long addr)
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
+			addr + PAGE_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+
+	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!ptep)
+		goto out_mn;
+
+	folio_get(kfolio);
+	folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
+	newpte = mk_pte(kpage, vma->vm_page_prot);
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
+static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
+		struct folio *failing_folio,
+		struct folio *target_folio,
+		struct ksm_stable_node *target_dup)
+{
+	struct ksm_rmap_item *rmap_item;
+	struct hlist_node *hlist_safe;
+	int err;
+
+	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
+		struct mm_struct *mm = rmap_item->mm;
+		unsigned long addr = rmap_item->address & PAGE_MASK;
+		struct vm_area_struct *vma;
+
+		if (!mmap_read_trylock(mm))
+			continue;
+
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
+		if (!folio_trylock(target_folio)) {
+			mmap_read_unlock(mm);
+			continue;
+		}
+
+		err = replace_failing_page(vma, &failing_folio->page,
+				folio_page(target_folio, 0), addr);
+		if (!err) {
+			hlist_del(&rmap_item->hlist);
+			rmap_item->head = target_dup;
+			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
+			target_dup->rmap_hlist_len++;
+			failing_node->rmap_hlist_len--;
+		}
+
+		folio_unlock(target_folio);
+		mmap_read_unlock(mm);
+	}
+
+}
+
+static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
+{
+	struct folio *failing_folio = NULL;
+	struct ksm_stable_node *healthy_dupdup = NULL;
+	struct folio *healthy_folio = NULL;
+	struct ksm_stable_node *chain_head = NULL;
+	struct page *new_page = NULL;
+	struct ksm_stable_node *new_stable_node = NULL;
+
+	if (!is_stable_node_dup(failing_node))
+		return false;
+
+	guard(mutex)(&ksm_thread_mutex);
+	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
+	if (!failing_folio)
+		return false;
+
+	chain_head = find_chain_head(failing_node);
+	if (!chain_head)
+		return NULL;
+
+	healthy_folio = find_healthy_folio(chain_head, failing_node, &healthy_dupdup);
+	if (!healthy_folio) {
+		folio_put(failing_folio);
+		return false;
+	}
+
+	new_page = create_new_stable_node_dup(chain_head, healthy_folio, &new_stable_node);
+
+	folio_unlock(healthy_folio);
+	folio_put(healthy_folio);
+
+	if (new_page && new_stable_node) {
+		migrate_to_target_dup(failing_node, failing_folio,
+				page_folio(new_page), new_stable_node);
+	} else {
+		migrate_to_target_dup(failing_node, failing_folio,
+				healthy_folio, healthy_dupdup);
+	}
+
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
@@ -3098,6 +3338,12 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 	stable_node = folio_stable_node(folio);
 	if (!stable_node)
 		return;
+
+	if (ksm_recover_within_chain(stable_node)) {
+		pr_info("ksm: recovery successful, no need to kill processes\n");
+		return;
+	}
+
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *av = rmap_item->anon_vma;
 
-- 
2.43.0


