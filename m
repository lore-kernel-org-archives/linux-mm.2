Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC7ACCFA06
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7218E009B; Mon,  3 Nov 2025 10:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF208E005A; Mon,  3 Nov 2025 10:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486C98E009B; Mon,  3 Nov 2025 10:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 353608E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:16:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5E9316021E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:16:49 +0000 (UTC)
X-FDA: 84069648138.21.DA3A165
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A717C000B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:16:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762183007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHsdcGL8LrQ4g28UhP+H0N9yRQ+/ngIVZw1EJAnx24I=;
	b=lh8zGE0rXuwuLwsvLEG8DPGzGQu82N8RI+bDLKB3SBKczvCSFALL4LGxCSH8O5mSs4I44h
	tvjkDUuuUSpSAPY/ANb+o+SgcG/IW2SV+jvWDOn3TcreNqWVQhdHzWICvvf/pQGDqWDBa2
	/oBLUvzr+8FHKVM0FX2aaWoW0KBjvbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762183007; a=rsa-sha256;
	cv=none;
	b=O3+pFzx0fu/EvqE5qafW8H4ebs8/+CynFf8IH/96Hyl7BepJHPjQZz/fPRPmAbEDyES8Az
	tpowy9HTCJdL281g5nxLX7nDIE9mcUBVIMaQdYRtyVU0/EvoAeS8CFl9nOHbI7RSbZ6QrQ
	ZfWhYfCy3ERd4rtKq0EkgZjqRtB+5R0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn;
	dmarc=none
X-UUID: 15d96f10b8c811f0a38c85956e01ac42-20251103
X-CID-CACHE: Type:Local,Time:202511032251+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:fe8abe30-5d31-4a1c-aa79-0cffbd54e809,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:1c788bfd0c645b1756616687fce26a2c,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|15|50,EDM:5,I
	P:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 15d96f10b8c811f0a38c85956e01ac42-20251103
X-User: xialonglong@kylinos.cn
Received: from kylin-pc.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xialonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1275873744; Mon, 03 Nov 2025 23:16:34 +0800
From: Longlong Xia <xialonglong@kylinos.cn>
To: david@redhat.com,
	linmiaohe@huawei.com
Cc: lance.yang@linux.dev,
	markus.elfring@web.de,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	wangkefeng.wang@huawei.com,
	qiuxu.zhuo@intel.com,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v3 2/2] mm/ksm: try recover from memory failure on KSM page by migrating to healthy duplicate
Date: Mon,  3 Nov 2025 23:16:01 +0800
Message-ID: <20251103151601.3280700-3-xialonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251103151601.3280700-1-xialonglong@kylinos.cn>
References: <a675d644-38d0-43d7-be42-8bc3753c74ee@redhat.com>
 <20251103151601.3280700-1-xialonglong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A717C000B
X-Stat-Signature: h76yi8fqtw45qspqbx9t7h176bj9b57o
X-HE-Tag: 1762183006-748663
X-HE-Meta: U2FsdGVkX1+J1AcYxNesfYrL0gzFWhyCnWmkMJx2kctln3NiMm9VPQUqDmHLRy/rFFvhOKiXXVMWETLiLuJ4K1/Gmk5L/16tnpQgrH+EEQkOWhijMjYMJjaNaQ0iWG14saGbE7OmvuDPgTOBP5yObf5ia26ldAv8uE8xQBodHP9PDKHZiMzcAfcBs+kFf2fXNCIqhYwMLghooAKJIAVoLoTTs+1d5HQ9kackDvpFeOkMv/wJhettPj8AD+p3w8P1Kiz1IqExidpygRDn91QT/+P7dUBXjAnsL7HvxQ0Yf1VYWRVlFAaIj3flzSJqURLlEvvsrqkYTR004PXxCn0QJHA47iGDs12upfUfppr+JzQePX7hkDLDDzlAMzlupLHs8iItC2g7oxj+uWoIMXTyAefjIm/LrzyyfkfruluwQNcmHvjgifof93PHWTIvFwCsGN0Vb8EEBrvAiQTF5ThimUXFifQJAIbv/1fgrSDY8rmjIeHwXEiOUDRgNX/qHIuH6z7b9Fxj8+D9KLbxX3JbzRLXhcQ6y/pGV7sIdtXKlKMg319AT8FlmKotG/j2hdJ1j4J6t/zmwMheaI3QbzScRncjhe2M53oZi3CfeDZ1RqmLe3igMJxUkra7OUGTzDgorx6Y7fv3PLmFfVZ2CrX5QqVPbFtsjMPMRAGYDmNW2VMLhohIbVYFyDLFfdYmx36gqsLJvPPaaZrhH3jQVnjQ15W9KTqbtCy0JqYiPlYy52cYiciRBKImY3/Mfmx7NxRzgWszC8L1SYkpj1zqN56g6oGuTNSQzz6r8vIdu5BocFmTfSiEQGJZTuoB/++1rzbWFDPG/fVEz6QSbq/5HS50LpkedGbq3QgxhXXwfA3deZfIXMDBwiPEQkzdYmAJFQdjVyPfD07iLVfJH5QElFa7jEdbi00SPH/Jc1VqqVbbL0k+1IOCV66JSiCXZ/Td+mE82IL5+HiGKgUigVSut8e
 A2VQH4yF
 8FRl2UoF0hFqURXKec79QdlK3jRgdlSuzvK3duSUre+E9ezPEv7z2TlAcuuN6oZzylJqmxq2grmmst2MBwjHm6vodVCkfm+d/99s9jb+0cGnPDhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/ksm.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 215 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 13ec057667af..159b486b11f1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3121,6 +3121,215 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
+
+static struct rb_node *find_stable_node_in_tree(struct ksm_stable_node *dup_node,
+						const struct rb_root *root)
+{
+	struct rb_node *node;
+	struct ksm_stable_node *stable_node, *dup;
+
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		stable_node = rb_entry(node, struct ksm_stable_node, node);
+		if (!is_stable_node_chain(stable_node))
+			continue;
+		hlist_for_each_entry(dup, &stable_node->hlist, hlist_dup) {
+			if (dup == dup_node)
+				return node;
+		}
+		cond_resched();
+	}
+	return NULL;
+}
+
+static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
+{
+	struct rb_node *node;
+	int nid;
+
+	if (!is_stable_node_dup(dup_node))
+		return NULL;
+
+	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
+		node = find_stable_node_in_tree(dup_node, root_stable_tree + nid);
+		if (node)
+			return rb_entry(node, struct ksm_stable_node, node);
+	}
+
+	return NULL;
+}
+
+static struct folio *find_healthy_folio(struct ksm_stable_node *chain_head,
+					struct ksm_stable_node *failing_node,
+					struct ksm_stable_node **healthy_stable_node)
+{
+	struct ksm_stable_node *dup;
+	struct hlist_node *hlist_safe;
+	struct folio *healthy_folio;
+
+	if (!is_stable_node_chain(chain_head) ||
+	    !is_stable_node_dup(failing_node))
+		return NULL;
+
+	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist,
+				  hlist_dup) {
+		if (dup == failing_node)
+			continue;
+
+		healthy_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
+		if (healthy_folio) {
+			*healthy_stable_node = dup;
+			return healthy_folio;
+		}
+	}
+
+	return NULL;
+}
+
+static struct folio *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
+						struct folio *healthy_folio,
+						struct ksm_stable_node **new_stable_node)
+{
+	struct folio *new_folio;
+	struct page *new_page;
+	unsigned long kpfn;
+	int nid;
+
+	if (!is_stable_node_chain(chain_head))
+		return NULL;
+
+	new_page = alloc_page(GFP_HIGHUSER_MOVABLE);
+	if (!new_page)
+		return NULL;
+
+	new_folio = page_folio(new_page);
+	copy_highpage(new_page, folio_page(healthy_folio, 0));
+
+	kpfn = folio_pfn(new_folio);
+	nid = get_kpfn_nid(kpfn);
+	*new_stable_node = alloc_init_stable_node_dup(kpfn, nid);
+	if (!*new_stable_node) {
+		folio_put(new_folio);
+		return NULL;
+	}
+
+	stable_node_chain_add_dup(*new_stable_node, chain_head);
+	folio_set_stable_node(new_folio, *new_stable_node);
+
+	/* Lock the folio before adding to LRU, consistent with ksm_get_folio */
+	folio_lock(new_folio);
+	folio_add_lru(new_folio);
+
+	return new_folio;
+}
+
+static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
+				  struct folio *failing_folio,
+				  struct folio *target_folio,
+				  struct ksm_stable_node *target_dup)
+{
+	struct ksm_rmap_item *rmap_item;
+	struct hlist_node *hlist_safe;
+	struct page *target_page = folio_page(target_folio, 0);
+	int err;
+
+	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
+		struct mm_struct *mm = rmap_item->mm;
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		struct vm_area_struct *vma;
+		pte_t orig_pte = __pte(0);
+
+		guard(mmap_read_lock)(mm);
+
+		vma = find_mergeable_vma(mm, addr);
+		if (!vma)
+			continue;
+
+		folio_lock(failing_folio);
+
+		err = write_protect_page_addr(vma, failing_folio, addr, &orig_pte);
+		if (err) {
+			folio_unlock(failing_folio);
+			continue;
+		}
+
+		err = replace_page_addr(vma, &failing_folio->page, target_page, addr, orig_pte);
+		if (!err) {
+			hlist_del(&rmap_item->hlist);
+			rmap_item->head = target_dup;
+			DO_NUMA(rmap_item->nid = target_dup->nid);
+			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
+			target_dup->rmap_hlist_len++;
+			failing_node->rmap_hlist_len--;
+		}
+		folio_unlock(failing_folio);
+	}
+}
+
+static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
+{
+	struct folio *failing_folio, *healthy_folio, *target_folio;
+	struct ksm_stable_node *healthy_stable_node, *chain_head, *target_dup;
+	struct folio *new_folio = NULL;
+	struct ksm_stable_node *new_stable_node = NULL;
+
+	if (!is_stable_node_dup(failing_node))
+		return false;
+
+	guard(mutex)(&ksm_thread_mutex);
+
+	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
+	if (!failing_folio)
+		return false;
+
+	chain_head = find_chain_head(failing_node);
+	if (!chain_head) {
+		folio_put(failing_folio);
+		return false;
+	}
+
+	healthy_folio = find_healthy_folio(chain_head, failing_node, &healthy_stable_node);
+	if (!healthy_folio) {
+		folio_put(failing_folio);
+		return false;
+	}
+
+	new_folio = create_new_stable_node_dup(chain_head, healthy_folio, &new_stable_node);
+
+	if (new_folio && new_stable_node) {
+		target_folio = new_folio;
+		target_dup = new_stable_node;
+
+		/* Release healthy_folio since we're using new_folio */
+		folio_unlock(healthy_folio);
+		folio_put(healthy_folio);
+	} else {
+		target_folio = healthy_folio;
+		target_dup = healthy_stable_node;
+	}
+
+	/*
+	 * failing_folio was locked in memory_failure(). Unlock it before
+	 * acquiring mmap_read_lock to avoid lock inversion deadlock.
+	 */
+	folio_unlock(failing_folio);
+	migrate_to_target_dup(failing_node, failing_folio, target_folio, target_dup);
+	folio_lock(failing_folio);
+
+	folio_unlock(target_folio);
+	folio_put(target_folio);
+
+	if (failing_node->rmap_hlist_len == 0) {
+		folio_set_stable_node(failing_folio, NULL);
+		__stable_node_dup_del(failing_node);
+		free_stable_node(failing_node);
+		folio_put(failing_folio);
+		return true;
+	}
+
+	folio_put(failing_folio);
+	return false;
+}
+
 /*
  * Collect processes when the error hit an ksm page.
  */
@@ -3135,6 +3344,12 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
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


