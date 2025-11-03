Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C04CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720DF8E0099; Mon,  3 Nov 2025 10:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D05C8E005A; Mon,  3 Nov 2025 10:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DF58E0099; Mon,  3 Nov 2025 10:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9DF8E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:16:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB73F86148
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:16:45 +0000 (UTC)
X-FDA: 84069647970.24.C1AE5C0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDC0A4000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:16:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762183004; a=rsa-sha256;
	cv=none;
	b=i6XVuQbMlWxJ5QbjpvPnlvxV/5aYL91U65eqZJy2gbUtKMeSKr1bt0FrvewZCKFropiDv6
	D2OjsXtl3VnS/rncMrdjKW7otkwe8iWCdeMXSfbMFxmu7ugUrQjLLbg4R7TKLJP6qfwWft
	pGI6Bvrsfqjql6rhkFgrhNhTVQMoUYE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762183004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H2s1CHlMb6V97LwZF8gARKfPdNzkAsxp6lCWSalbOxo=;
	b=Lj+G2Y9QGaEEk3ciTscZuTwfGYjwokBOtbRCreLyKWRHPeanEEd4ne3QgupCOhn80ZNQvp
	hjn9YvwKAunTE4z+CKtckacfj4rUIEOQxZT635uNvOlzGiQa5fYemGtRWJ6Fi4ReUGVmPj
	KN1X6v945CFvY4umQii6i0D0r0vcYHg=
X-UUID: 155f44ceb8c811f0a38c85956e01ac42-20251103
X-CID-CACHE: Type:Local,Time:202511032251+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:bdc83ded-1af2-4292-9933-bbc194ec4bc4,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:6dbaf3e990165deede37a2367159576d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|15|50,EDM:5,I
	P:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 155f44ceb8c811f0a38c85956e01ac42-20251103
X-User: xialonglong@kylinos.cn
Received: from kylin-pc.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xialonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 907537677; Mon, 03 Nov 2025 23:16:34 +0800
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
Subject: [PATCH v3 1/2] mm/ksm: add helper to allocate and initialize stable node duplicates
Date: Mon,  3 Nov 2025 23:16:00 +0800
Message-ID: <20251103151601.3280700-2-xialonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251103151601.3280700-1-xialonglong@kylinos.cn>
References: <a675d644-38d0-43d7-be42-8bc3753c74ee@redhat.com>
 <20251103151601.3280700-1-xialonglong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDC0A4000C
X-Stat-Signature: jp4uxpkhxbkrytghz7d91x8jc45scrai
X-Rspam-User: 
X-HE-Tag: 1762183002-960639
X-HE-Meta: U2FsdGVkX199blImG2ccEl11+fgeuSS7RLDYfGEBerXnB2jUSuwG2AF47Ipojr0ukDFH6RZnjniglZPBYbjeNEIr5ArDqtJpwhoiBfhW3ciF71Tw7YNqVAoR2vyw9Duc7QxEaDFQRnP728Eur+lHjQePZH5HIwYOJmcaincrAYJOOKvAtLa7IHM0TaU80KYpbCg5loX8goT5K1P8ulMD7zJoi0gQHHDrWqvQEviMkzShhMbkLmUQ14kSTTHu1FSmKJInGz4Gt8a4uwewCqklGOU1I1NbjXpjinaWPU5UQ3it5bASDj0XTDoXPetwZ9VBQfqsyt2cW5zy1aXnOLJQUyKPpyZ92EnYmfT21K6/OxIJYyUf4bOEW9lGj+tZnpKYlgUkkXWnfT5ndA4xdAqMwLiLXoRvcg5qZQthDJoQP+qOv9kZTs6rVzdkcIslA2khJyAValNWLitQI7ikcPZQWXjGNlXXReDA83lkgnm4tXig1badARLniz0wkB3GqxxOmCwTKhsglpXksNT5f5i3g1KdjhtWDx0SQYmT/4Fs6L5vmzrtez9clRx5ZNXGMQvXQISJAThfpdR8fqEtBHNPkAXYTsfnkcAVSjmQCm3+OgygD2Sg/xrpvtOd7Ttdze+TsUYHZa5nv+AcUGZKK9hsXUo8gl2vqAonUKW0k8DXMSvGHgh5NgdCR4H86GSZQ4Z7weDW2q+MFeK28K8qUPUoesSDcKYkMJYPmEZgn/SYlh29Tss0atIpmYbwms31ydn674vKNd1UnAWNW/v9BoOghoSlrfd9JtJ6+PwZYychc8G3DNT8NiZBjHUUV98S7kr5YqBDAGfR9hI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate the duplicated stable_node allocation and initialization
code in stable_tree_insert() into a new helper function
alloc_init_stable_node_dup().

Also refactor write_protect_page() and replace_page() to expose
address-based variants (_addr suffix). The wrappers maintain existing
behavior by calculating the address first.

This refactoring prepares for the upcoming memory error recovery
feature, which will need to:
1) Allocate and initialize stable_node duplicates
2) Operate on specific addresses without re-calculation

No functional changes.

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 89 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 26 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..13ec057667af 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1247,11 +1247,11 @@ static u32 calc_checksum(struct page *page)
 	return checksum;
 }
 
-static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
-			      pte_t *orig_pte)
+static int write_protect_page_addr(struct vm_area_struct *vma, struct folio *folio,
+				   unsigned long address, pte_t *orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int swapped;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
@@ -1261,10 +1261,10 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	if (WARN_ON_ONCE(folio_test_large(folio)))
 		return err;
 
-	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
-	if (pvmw.address == -EFAULT)
-		goto out;
+	if (address < vma->vm_start || address >= vma->vm_end)
+		return err;
 
+	pvmw.address = address;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, pvmw.address,
 				pvmw.address + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1334,21 +1334,26 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	page_vma_mapped_walk_done(&pvmw);
 out_mn:
 	mmu_notifier_invalidate_range_end(&range);
-out:
 	return err;
 }
 
-/**
- * replace_page - replace page in vma by new ksm page
- * @vma:      vma that holds the pte pointing to page
- * @page:     the page we are replacing by kpage
- * @kpage:    the ksm page we replace page by
- * @orig_pte: the original value of the pte
- *
- * Returns 0 on success, -EFAULT on failure.
- */
-static int replace_page(struct vm_area_struct *vma, struct page *page,
-			struct page *kpage, pte_t orig_pte)
+static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
+			      pte_t *orig_pte)
+{
+	unsigned long address;
+
+	if (WARN_ON_ONCE(folio_test_large(folio)))
+		return -EFAULT;
+
+	address = page_address_in_vma(folio, folio_page(folio, 0), vma);
+	if (address == -EFAULT)
+		return -EFAULT;
+
+	return write_protect_page_addr(vma, folio, address, orig_pte);
+}
+
+static int replace_page_addr(struct vm_area_struct *vma, struct page *page,
+			     struct page *kpage, unsigned long addr, pte_t orig_pte)
 {
 	struct folio *kfolio = page_folio(kpage);
 	struct mm_struct *mm = vma->vm_mm;
@@ -1358,17 +1363,16 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	pte_t *ptep;
 	pte_t newpte;
 	spinlock_t *ptl;
-	unsigned long addr;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
 
-	addr = page_address_in_vma(folio, page, vma);
-	if (addr == -EFAULT)
+	if (addr < vma->vm_start || addr >= vma->vm_end)
 		goto out;
 
 	pmd = mm_find_pmd(mm, addr);
 	if (!pmd)
 		goto out;
+
 	/*
 	 * Some THP functions use the sequence pmdp_huge_clear_flush(), set_pmd_at()
 	 * without holding anon_vma lock for write.  So when looking for a
@@ -1441,6 +1445,29 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	return err;
 }
 
+
+/**
+ * replace_page - replace page in vma by new ksm page
+ * @vma:      vma that holds the pte pointing to page
+ * @page:     the page we are replacing by kpage
+ * @kpage:    the ksm page we replace page by
+ * @orig_pte: the original value of the pte
+ *
+ * Returns 0 on success, -EFAULT on failure.
+ */
+static int replace_page(struct vm_area_struct *vma, struct page *page,
+			struct page *kpage, pte_t orig_pte)
+{
+	unsigned long addr;
+	struct folio *folio = page_folio(page);
+
+	addr = page_address_in_vma(folio, page, vma);
+	if (addr == -EFAULT)
+		return -EFAULT;
+
+	return replace_page_addr(vma, page, kpage, addr, orig_pte);
+}
+
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
@@ -2007,6 +2034,20 @@ static struct folio *stable_tree_search(struct page *page)
 	goto out;
 }
 
+static struct ksm_stable_node *alloc_init_stable_node_dup(unsigned long kpfn,
+							  int nid __maybe_unused)
+{
+	struct ksm_stable_node *stable_node = alloc_stable_node();
+
+	if (stable_node) {
+		INIT_HLIST_HEAD(&stable_node->hlist);
+		stable_node->kpfn = kpfn;
+		stable_node->rmap_hlist_len = 0;
+		DO_NUMA(stable_node->nid = nid);
+	}
+	return stable_node;
+}
+
 /*
  * stable_tree_insert - insert stable tree node pointing to new ksm page
  * into the stable tree.
@@ -2065,14 +2106,10 @@ static struct ksm_stable_node *stable_tree_insert(struct folio *kfolio)
 		}
 	}
 
-	stable_node_dup = alloc_stable_node();
+	stable_node_dup = alloc_init_stable_node_dup(kpfn, nid);
 	if (!stable_node_dup)
 		return NULL;
 
-	INIT_HLIST_HEAD(&stable_node_dup->hlist);
-	stable_node_dup->kpfn = kpfn;
-	stable_node_dup->rmap_hlist_len = 0;
-	DO_NUMA(stable_node_dup->nid = nid);
 	if (!need_chain) {
 		rb_link_node(&stable_node_dup->node, parent, new);
 		rb_insert_color(&stable_node_dup->node, root);
-- 
2.43.0


