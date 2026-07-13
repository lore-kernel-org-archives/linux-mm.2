Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018DCC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1066B008A; Mon, 13 Jul 2026 16:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C6D6B008C; Mon, 13 Jul 2026 16:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BCF6B0092; Mon, 13 Jul 2026 16:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCF66B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:49:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B103A401A0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:45 +0000 (UTC)
X-FDA: 84984944730.02.42E2AB0
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0AC1E100005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KQd0d8kI;
	spf=pass (imf05.hostedemail.com: domain of 3Zk9VagUKCLMikTTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--praan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Zk9VagUKCLMikTTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783975784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzJzBgZ7BaDqZpOvHA29oVPMSyBnofRxze7m51B0LYQ=;
	b=JVvwR3Mad7MeAq3QUVkOyIsJ3IYNBJ8zdoIXWzo6eFdiwm/1IezwnHpw6f5QiIR7waJJgD
	rmJpzZWtYAxLQwBnR6Hh86+I199UblFmnyS6HdBYVxgtKp4BgCPeeJgfQsmH2K5FWiv4nW
	bLZmiKOx6nTfyr8gg7mFo67I70m1ukQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KQd0d8kI;
	spf=pass (imf05.hostedemail.com: domain of 3Zk9VagUKCLMikTTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--praan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Zk9VagUKCLMikTTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783975784;
	b=Tfya1dmHJIDgsUn8XmLdvyF4yrdUkdIOpUpK9/17eTNXzZYEll1MRlVyRsSsTiHhFQ/pIl
	xnzfCRhYjsIx0A/Oi2/ethCbJhGoXduugA4/mWt+ir4DKSwPbGgZd7gbRT//d4JhM8BTdb
	0WbUKJj0/yANqF/ghbxPfecxbOS+BbM=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso3273056a12.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783975783; x=1784580583; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xzJzBgZ7BaDqZpOvHA29oVPMSyBnofRxze7m51B0LYQ=;
        b=KQd0d8kIX3bVciFoN/kYP1g15HLNhf0aQ3+FA8uCWhAXtEdUIF/lejLQnVahSEvIuR
         gcl4VLX3FQ0QnS7NwkvBkUTzx1JymOmULjySMdCIuEQfbGG0B91Rrs6XbQEolBy+zdyR
         dmeOBbR6cqyIDWtkj3d9A1lqEZIExFMnPjcddW6iWlHxiA0hnQizQQliJgGdPyAcs2k+
         yrvwELn8nuWjbkamYd1U/sNDmntvYkClsquG6Sd5lJssv/VrGlcoFRBAturmDgVNwvQp
         SM5s+cnY95UQFkQJq2SCnvgAw6Mpwr/JiGCNJI+jZ+ztRjKkTTr191lDpp6F2rFXd5RT
         ktdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783975783; x=1784580583;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xzJzBgZ7BaDqZpOvHA29oVPMSyBnofRxze7m51B0LYQ=;
        b=WL7WvkvWUS8WnTy9gYyIsx9wqhoKff3QAM/HK7SAvqTkdQ3Uoo/67KyBFDYKnIKqgW
         aX0BseUJnUFd7ZflnlKzAFuP/44hKQh/h6ofB/yh0zLT7x7oA6tBu083jn8VCX4lLOkJ
         ywJXlUeom6G6DKxclLAOSdVd4PBI1y13kbLMFgnYF5FNy8j/OWM6Kje9N0tO/QVcU1hL
         Ir7QuuflRWygFqQL0323IzNC/FISmXKaq7Dq/zSN2PsKZXXWgl2ZHgt6GL5B446FKySl
         VMtiRPwPQDRBnBDixJ5zjh2i85SGC/NCyIVyNqzlv3TCn3qoIrqkbDHar6U7WSJbc3Tm
         eg/g==
X-Forwarded-Encrypted: i=1; AHgh+Ro8yMl4Wj5HW2qt113bKFClgrI3XICN92UhDGFvNgpPIinU7NQMNnU6RmkV4RHJic32If88J66aHg==@kvack.org
X-Gm-Message-State: AOJu0YzhUy83jvdfe6B4wzFqNpKAGuE3P8ZHu5IcfeSCIBmpJo6uOCzO
	KYVNWoL2CrjmrpV+QYSauuZq54VL9qSgsaQyfRrogsjaJCIUrw5yzRVNkwpI6mHF/tWKu9JLQM6
	OmA==
X-Received: from pgh2.prod.google.com ([2002:a05:6a02:4e02:b0:c86:2164:9671])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c6cb:b0:3aa:c964:3c27
 with SMTP id adf61e73a8af0-3c34d719d0bmr820808637.46.1783975782789; Mon, 13
 Jul 2026 13:49:42 -0700 (PDT)
Date: Mon, 13 Jul 2026 20:49:35 +0000
In-Reply-To: <20260713204935.3069000-1-praan@google.com>
Mime-Version: 1.0
References: <20260713204935.3069000-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260713204935.3069000-3-praan@google.com>
Subject: [RFC PATCH v2 2/2] kho: Introduce preserve/restore APIs for unsplit pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ugkm5pkdp73ou7xuxrnjztpcjfkjk5t9
X-Rspamd-Queue-Id: 0AC1E100005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783975783-303559
X-HE-Meta: U2FsdGVkX19V6XQ7gkMtIHjEnATjfukCPbJNX2p4ssS/urXss+k6CWL/zK3q6NH/5ZwEMrNB2xRh4ikx0zd4t4Lt//tZreR5FlpfBvlq/sk3V6o/8wL2PHMj2QkUyreuYPUiS3pkqPc5J8hLxwQ1sGuCnvnZoLrNjjejqog6W932iENLTgQO4wwt+gcJfNanvcB3edbY1gCivwK2/+IsX1x1DnqPVASe5haqnCCHC8TkAJzHWu3/IC6PPWmpo9SSZx+ZqrsdkHVmvpmw+6JCKg/q01G9CLjySKtj+1SuEoRALUbAfp8CjPWHruBe87/+sUsnXthRpY1ExS7p4K1WhbJPfotYH5PnRsxszXIlATpzPF3bKIKZ3fm4+4zFEoo+BIdsI4JzhVjbgTPTC7reRtGnAKkCiZsUnzkqQ66KvLq2EL/yoAyBfKxzXFBglKXCBVetMUXSUbn24h4bZxQUJzKyLOlPEv+lOSF/SYu6/Nd2ww/g3KJb+ijMTqepLA/8+PRl6cp9YhJVATl39v8cFd3p/k+A42UKEvKSw+TPKOz7MbV42FvcDivVqwJ55mpobY2/mNq3Q9F2PJQwVPJlI3U1XZFtvBNhOTaS5ttbeXOvnI9NOB/qnmmUtVNmbC3Bk8SvJIDyxxv939uISjNTHyfN6m+bYn6HJRuy1Wx1PvthkX70InWhKkYe8YhKwPbcsFtel9ZHyLZJRfl/5UbhotVzPu99iQPcWJrLOeEdwxfHF6fGFutSOEUGQt78FUzK2n1+L+3oZq3/wAzFwaMNscKFY/lhslqlceOQoqEllulgMV3t76DooySeBqXUgvGo03EZnocZtgWs7KikK/JxBX/Haoq/EkzCKOCtKfiGDZBXReGO4WAOLEq6esA8Omuf+h4vI6NhzKxl3pyafHShFhwi8HQqSgaa4wn8PEVWeK9bpwQwOWTrGtoYchthbEhioGMFpSM/xPxa7uQTdlD
 6KJR/57n
 epGUZXHPCF+xBaPdknBanRxJ+A4bEsmaqEjjAYLwotddPJprW80mnT8OIaWpHK5FtQpcfszelWeGr+vmd2gItb6FBnlp5ceNEuaBGfG8eBy56sDd79pJ0bFV00pMUoCS2fBXSAEliTHrO+TDbhOEXdR5ZvBs9TT5UkEm5LTf5VV2TFo5yv/XZc+vs50hM3GKj7+wvRHb3YhHdFezAMGVE66007ZOabLlIqptfHQy/dGC2JRX+OHqbKDRIkOX8aGi8AlvgJEZUbkhy2KFySGXbBn4W7fS0DbRfMjwGKOw0ZvoQC8+VdCOl+N/yUEhy65jVPq9VVbwBF4szeY9e8TaBd++BHbKoN7RcdCsU8Hbc70u5jfbwHmQhMV/T2BMrzkCHQso3SQ/DZoUcHtSnJBDii7YVgVRfIAEuwyzJCcyQhjZVxEhDAi4H/v26MsTF76GOqgKwcXxFXAMlByrEpeQR2UnaZayAC8/Cl+Vu62Zr2KvCYjNb7/Xh5ZsnBy3Lbv7hMRsiwsRGJTmM9DHEs5X/PF+uIZTAHjJo2cvxDkrqWHx/8uoN7cCCK0Ol4IzGv7syM/Qd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
that multi-page blocks are split into independent 4KB pages during
restoration. This is incompatible with high-order non-compound pages,
such as DMA buffers, which must be restored with tail pages having a
zero reference count.

Introduce explicit preserve and restore APIs for unsplit pages,
which preserve and restore a high-order page block as a single unit,
applying a refcount of 1 to the head page while leaving tail pages at 0.
Rename the existing internal helper to __kho_restore_page().

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 include/linux/kexec_handover.h     | 10 ++++
 kernel/liveupdate/kexec_handover.c | 86 ++++++++++++++++++++++++++++--
 2 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..6e2c75b16209 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -22,6 +22,8 @@ bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
+int kho_preserve_page(struct page *page, unsigned int order);
+void kho_unpreserve_page(struct page *page, unsigned int order);
 int kho_preserve_pages(struct page *page, unsigned long nr_pages);
 void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
@@ -30,6 +32,7 @@ void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
+struct page *kho_restore_page(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
@@ -65,6 +68,13 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 
 static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
+static inline int kho_preserve_page(struct page *page, unsigned int order)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void kho_unpreserve_page(struct page *page, unsigned int order) { }
+
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 07f6f453cd69..43ae3e2de5da 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -393,7 +393,7 @@ static void kho_init_folio(struct page *page, unsigned int order)
 		prep_compound_page(page, order);
 }
 
-static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
+static struct page *__kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
 	unsigned long nr_pages;
@@ -432,12 +432,44 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys, true);
+	struct page *page = __kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
+/**
+ * kho_restore_page - restore a higher-order unsplit page block.
+ * @phys: physical address of the first page.
+ *
+ * Restore a higher-order unsplit page block that was preserved with
+ * kho_preserve_page().
+ *
+ * Return: the head page on success, NULL on failure.
+ */
+struct page *kho_restore_page(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned long nr_pages;
+	union kho_page_info info;
+
+	if (!page)
+		return NULL;
+
+	info.page_private = page->private;
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
+		return NULL;
+
+	nr_pages = (1UL << info.order);
+	page->private = 0;
+
+	kho_init_unsplit_pages(page, info.order);
+	adjust_managed_page_count(page, nr_pages);
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(kho_restore_page);
+
 /**
  * kho_restore_pages - restore list of contiguous order 0 pages.
  * @phys: physical address of the first page.
@@ -457,7 +489,7 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
+		struct page *page = __kho_restore_page(PFN_PHYS(pfn), false);
 
 		if (!page)
 			return NULL;
@@ -890,6 +922,51 @@ void kho_unpreserve_folio(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
+/**
+ * kho_preserve_page - preserve a higher-order "unsplit" page block.
+ * @page: head page of the block.
+ * @order: order of the allocation.
+ *
+ * Instructs KHO to preserve a higher-order contiguous allocation (like a DMA
+ * buffer) as a single unit. It must be restored using kho_restore_page() to
+ * ensure the tail pages are correctly initialized with a zero refcount.
+ *
+ * If a driver needs to split a block that has been preserved with this
+ * function, it must first unpreserve the block using kho_unpreserve_page(),
+ * perform the split, and then re-preserve the individual pages using
+ * kho_preserve_pages().
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_page(struct page *page, unsigned int order)
+{
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
+	const unsigned long pfn = page_to_pfn(page);
+
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
+	return kho_radix_add_page(tree, pfn, order);
+}
+EXPORT_SYMBOL_GPL(kho_preserve_page);
+
+/**
+ * kho_unpreserve_page - unpreserve a higher-order "unsplit" page block.
+ * @page: head page of the block.
+ * @order: order of the allocation.
+ *
+ * Instructs KHO to unpreserve a high-order block that was preserved by
+ * kho_preserve_page() before.
+ */
+void kho_unpreserve_page(struct page *page, unsigned int order)
+{
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
+	const unsigned long pfn = page_to_pfn(page);
+
+	kho_radix_del_page(tree, pfn, order);
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_page);
+
 static unsigned int __kho_preserve_pages_order(unsigned long start_pfn,
 					       unsigned long end_pfn)
 {
@@ -927,7 +1004,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
  * @nr_pages: number of pages.
  *
  * Preserve a contiguous list of order 0 pages. Must be restored using
- * kho_restore_pages() to ensure the pages are restored properly as order 0.
+ * kho_restore_pages() to ensure the pages are restored properly as order 0
+ * with each page having a reference count of 1 (split).
  *
  * Return: 0 on success, error code on failure
  */
-- 
2.55.0.141.g00534a21ce-goog


