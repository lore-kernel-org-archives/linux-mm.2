Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9569EC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9E16B00AB; Mon, 20 Jul 2026 10:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986AE6B00AD; Mon, 20 Jul 2026 10:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FB16B00AE; Mon, 20 Jul 2026 10:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 584826B00AB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0A51801DA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:09 +0000 (UTC)
X-FDA: 85009412418.15.C78D7A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0363A2000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZlZZOG;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558348;
	b=ljwl8EItkJloLJwWnjghI3flIUD9WbvwhlUa/+lEThGr/8Jrk/9EdQ5gNSkHCz4/k+aZ+1
	nq2yG10Czd2CYKhFuqiXMitVb92ZAWlKv5YXLVBrDhVgslfwUnJG8aXzxhpluJM6u58WiN
	zHC9h0fL0HEHMVffiQHSAIWrVkZ0ThA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZlZZOG;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gbq62ZDTRhCU0YYyw6w+yG11IaOwmiuOudw94XdE/s0=;
	b=WSJgQVaa8CNCFafXhbMwD3es+VxdU8fbgyoWlLw5Es80bWBqun5bAG3+w9oKSFZb6+QedV
	U9rt5wqXCUyHZB3+ossQJSaVbGs/Src6yrsXsKTJzw9kSkyRvenB3k1JF3baQ8nhljJora
	Uu2eN7q0sf8s7KIIfc73xWk6LWCXRFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F20644F3E;
	Mon, 20 Jul 2026 14:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D8F1F00A3A;
	Mon, 20 Jul 2026 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558347;
	bh=Gbq62ZDTRhCU0YYyw6w+yG11IaOwmiuOudw94XdE/s0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=osZlZZOGLkdT/VjNc5AjRiQDVrvEmWggcAzB54K3FiYINmGj21FQ2PtKSqCHOQas5
	 PEHk/cqs7PQRnngMGvOoWPGHupow00Oxay++KIiuOGHrrkXfAI6YXzorjj9IeMsO6S
	 0/dJjsxDj27u9w72GLMaAtbajp9PPuH/HUrJCZKCUjropzwLvP/jsY0GQKaxPicX6J
	 jkWRO9VwNQPMW2ysKm/+wVeQX3+STPZ4no08iFKw8dHx7h1ty9ca66H1PXvir7xFZH
	 luAyIvX8ChQtyTTIBD5M/Clp9A6UKVbpVV5zk4w5//lB7yGD4beBDSK2wxwBpGTGcM
	 +B9ZyoEVFDiZQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:27 +0100
Subject: [PATCH v2 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7731; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7nUSzDYe5At50qqwDX1UDOeE1maYkC5Z33uE3D/X3Pg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijF4z1an460w/fzkvhq/s0s5dB8yznz7efPqD86fPD
 k2qWSGPO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRqQsZGS5NYLnK+yn9bMfk
 8vclM2v3Z9TerlpleStfcuO6TYHuKyczMuz4o+QkJ37M/Mbu6qp3jtOjZn8/UTo54KGmMdullYo
 2mrwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0363A2000B
X-Stat-Signature: d7rfo1p3rjpjxaczu4op8x3wcxumrmae
X-Rspam-User: 
X-HE-Tag: 1784558347-845309
X-HE-Meta: U2FsdGVkX1/W8jfvQ6m0nsR1U/aHC05XvHf+GlXAMw1dNZlMyYsKvtCfgWm1gmf9KJWGQojj80Hhl+5+WIlDdi4/xytSJzho9TUO7pFcSpkRYpDi7h7pVE/RqLe4VdjAZck89tDvreTTpcEAqj4L3+JtyQu7vpTKtg0+0pUVk/8J0d98kIa6Np+Lq8t199AJIK4+nn+GCk25WXZOtTwYxDyZOCOGvkJlFaRkInIMpiaIPg0G4fD5UFYHnoZVMm1I0eoO5TDZCv5vbDBZyt+Hr/XL+sr8iLQTwUsvKVVHIVNXLXxomrts0eY8h/pal9D3EcEPRaE9XLDNrRl3v4jKcd6mZTOE3uIgVFezHMfWtSudiKIcDOidfoFBqtXyGPUrvJSUakzaXxtB29kpcWi9ufYWR0P/wu4rKSZMJdERp4zgdp8oX8hHAR/geT6oFW2XfKSTcY1psK1ce7JvAF5VnaNvrQFOvV/ayPKzj95IXW9sDEN5vOR5HQS0j0HUidUuyAuq1MPOT45H3v2OJKjLyeeedkO4xsjJWm3xEowXUigFlfeJ8zbNoMcGbTjlW7s+micTxXvWkhWBjRvDVfEW0RkA7oSc+FuV+f1wsOUZL2F+js5qzpRgzt682NmENQloiJmZG+6w8HegX7xtdy9eXl1240IJRQWeiSeUgG/T/pxmxivrauQknjKsYcFbukWJyWNUgfaVtOPxdyCt13GdPa11agiucbkEmmRhoqSqgTbRWWyBVYIFR2TIdcUA4QA2dV02JvbE/jecO01u8aqjSUJ7Ysd4Pm7v+pdPmMehY2pwaGfilhPrQiscxcqNUZlPDDKuzJk4YbLjAH5zOrN7st4xBClEae4+F1p3ihI9JtRb240h8SpA+rFUIXZ1Tt7C2U2A+ofDr0E4Rt6MWwyHD5W8Eh7Agk6jF5qeXWBelQ/1PCkKeEaz43fpeBNCxuiMm/dc9YvpWEXRj6WwhSN
 kBV/mKk9
 03b2F/LoP+cnSS+20c4O0mkbFIsXKiI8tHs8fogzfZb0nmLNfDv1l3ZWIgoR06DWHdgyCGV+1zslM5CJ85Vm2FfQskCyWDy0PVsvA/mCzUnWahPCOu6Vil0q/6q6OVdso1SB+KC7Hr9EITMgJaoTS5DqKgQxrBjSe7+f7V1vkjvRrve6ZLORkP3yJneX49odJq+kt+NGLlb4lFhrms4VPPl7xDL04j5qMo8r0CNH2BgfCU3UAZbHvt+g4EyC3FeeL4aH8Hy7jX1zGoEpe1rAfhxEsRXozRsM6hozJRLZyRKuNHrDaRXIlsSR3xAoMn+nZVUqx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch establishes fields within the vm_area_struct type to store the
virtual page offset of VMAs.

The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
they are unfaulted or were not remapped, otherwise it is equal to this
value at the point of first fault.

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
file-backed VMAs are tracked by their file offset. By adding virtual offset
as a property of VMAs, we can now track them by their virtual page offset
instead.

By tracking this, we provide the means by which to eliminate this
inconsistency, and more importantly lay the foundations for future work for
the scalable CoW anonymous rmap rework.

This patch simply adds the fields and some simple helpers. Subsequent
patches will update mm code to make use of these fields correctly.

The fields chosen are packed in the VMA such that, for 64-bit kernel
builds, no additional space is taken up.

The first field is present on cacheline 0 containing key VMA fields, and
the second on cacheline 3, which contains file-backed reverse mapping
fields.

Given the relative time spent accessing reverse mapping fields as well as
updating them, there shouldn't be any performance impact here from false
sharing.

Update the VMA userland tests to account for this change.

No callsites are updated yet, so no functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h        | 12 +++++++++
 mm/vma.h                        | 14 ++++++++++
 mm/vma_init.c                   |  1 +
 tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..59b98cc60402 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 	return vma_end_pgoff(vma) - 1;
 }
 
+/**
+ * vma_start_virt_pgoff() - Get the virtual page offset of the start of @vma
+ * @vma: The VMA whose virtual page offset is required.
+ *
+ * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
+ *
+ * This value is used for tracking MAP_PRIVATE file-backed mappings by their
+ * virtual page offset.
+ *
+ * Returns: The virtual page offset of the start of @vma.
+ */
+static inline pgoff_t vma_start_virt_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_virt_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_virt_pgoff_lo;
+	return pgoff;
+}
+
+/**
+ * vma_end_virt_pgoff() - Get the virtual page offset of the exclusive end of
+ * @vma.
+ * @vma: The VMA whose end virtual page offset is required.
+ *
+ * This returns the virtual exclusive end page offset of @vma, which is useful
+ * for expressing page offset ranges.
+ *
+ * See the description of vma_start_virt_pgoff() for a description of VMA
+ * virtual page offsets.
+ *
+ * Returns: The exclusive end virtual page offset of @vma.
+ */
+static inline pgoff_t vma_end_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_virt_pgoff(vma) + vma_pages(vma);
+}
+
+/**
+ * vma_last_virt_pgoff() - Get the virtual page offset of the last page in
+ * @vma.
+ * @vma: The VMA whose last virtual page offset is required.
+ *
+ * See the description of vma_start_virt_pgoff() for a description of VMA
+ * virtual page offsets.
+ *
+ * Returns: The last virtual page offset of @vma.
+ */
+static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_virt_pgoff(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 939b5ea8c9e0..b5d4cd3b067b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -967,6 +967,11 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	/*
+	 * Low 32-bits of virtual page offset.
+	 * See vma_start_virt_pgoff() comment for details.
+	 */
+	unsigned int __vm_virt_pgoff_lo;
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
@@ -1041,6 +1046,13 @@ struct vm_area_struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
 #endif
+#endif
+#ifdef CONFIG_64BIT
+	/*
+	 * High 32-bits of virtual page offset.
+	 * See vma_start_virt_pgoff() comment for details.
+	 */
+	unsigned int __vm_virt_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
diff --git a/mm/vma.h b/mm/vma.h
index 0bc7d521e976..04c5c1c546f6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	vma->vm_pgoff = pgoff;
 }
 
+static inline void __vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+#ifdef CONFIG_64BIT
+	vma->__vm_virt_pgoff_hi = pgoff >> 32;
+#endif
+	vma->__vm_virt_pgoff_lo = pgoff & GENMASK(31, 0);
+}
+
+static inline void vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	__vma_set_virt_pgoff(vma, pgoff);
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 715feee283f0..710b18849a36 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
 	dest->vm_end = src->vm_end;
 	dest->anon_vma = src->anon_vma;
 	dest->vm_pgoff = vma_start_pgoff(src);
+	__vma_set_virt_pgoff(dest, vma_start_virt_pgoff(src));
 	dest->vm_file = src->vm_file;
 	dest->vm_private_data = src->vm_private_data;
 	vm_flags_init(dest, src->vm_flags);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c52b23773cd2..00d416d79ec1 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -577,6 +577,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_virt_pgoff_lo;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -612,6 +613,9 @@ struct vm_area_struct {
 #ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
+#endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_virt_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
@@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
 	return vma_start_pgoff(vma) + vma_pages(vma);
 }
 
+static inline pgoff_t vma_start_virt_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_virt_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_virt_pgoff_lo;
+	return pgoff;
+}
+
+static inline pgoff_t vma_end_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_virt_pgoff(vma) + vma_pages(vma);
+}
+
+static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_virt_pgoff(vma) - 1;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


