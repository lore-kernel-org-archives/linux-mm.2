Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A46C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBBD6B0093; Wed, 29 Jul 2026 12:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC91A6B0095; Wed, 29 Jul 2026 12:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00836B0096; Wed, 29 Jul 2026 12:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE83C6B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6511B160737
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:26 +0000 (UTC)
X-FDA: 85042399932.14.C74F884
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83380C0010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYyk+Q+G;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPbLai49bH0v33Ittvjqr9WRlcy9Qzii1B24A4wQ6as=;
	b=0+F8d6zzVMMyijLVC5JztvMDHFGBKY15RML6i5pTrLo2WZByS0RTq9gSJQaRGJ+pKJi2Lz
	DVVRuh4xxjp7piwr+NDF13pT86wcK8siqd0Uy7GQ4rIBF21U/XHivqOXJCWdhIDBwJjSTc
	bLedVdrYP3XpnykZnqh/3axKUvN+VD0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYyk+Q+G;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343764;
	b=auooaikzo0ymddYJYTnKLJ63r8ysKdmLMMvo8f15YnRQ64q33cMc5gYHeMsAIAqw7nRymw
	UspCSINJYc+MEEH2nEkdB4im5lhJRylUewAYEJm+t8Z+Vf2t+0WMTX3zxkgeq4gzfjBQPo
	zZQVg/p3DT+XCsOGDz1R4FqGN9K/UUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E04143D1B;
	Wed, 29 Jul 2026 16:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490331F00A3F;
	Wed, 29 Jul 2026 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343763;
	bh=WPbLai49bH0v33Ittvjqr9WRlcy9Qzii1B24A4wQ6as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FYyk+Q+GfJ6Vft2X2fBlBKfdEczY/qlaSQvavtfzu4DmEBkiTNufI29uSQVLX/5Ds
	 fTmRW6UM/CxkH662WCO7VzpwKPZ4JBna//mI7WBEB8QbKf5U52FBtNA4YcdBkq/I5E
	 R8wCw2KqnoBBgGS3LUtgFfp9OAmFO/eDSXcuf5SfWb0jrpMeyKNLbzqmByK4GGvuqJ
	 UfLByhQ84TF4QzQAmM0mlfYQR4OAGUz5kUQ3VX6BSp+0ja6zKjEsDUJ/QJOo2g7A5I
	 dkb2evTYBkNLupa2i+aGYMV74iArsg0jo4kV9iiT9k7BeldydYaOwnz7T4Ew65z1ad
	 Tzn0GfPEwujKg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:36 +0100
Subject: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field and
 add helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7771; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uUkE9gAhysK/nnjLeZ8l8BrdRNA2q/dMcD1c2dbX+2g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H7kanw5HpX61rBUvq62/sjzeUGPlJzm/79QkDCXq
 8nl0Om1HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIDkWG/3XuK97dUb1ZzXLF
 w5w95Iep1IYVW0L2xVdbRW6/dF6A+THD/zChmKl7d129sML0q49nxp8Nyjvm1aXOOpp14afW8Qe
 GG5gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83380C0010
X-Stat-Signature: 4gquzzcoirkcnhtckeb65j6gru76so9i
X-HE-Tag: 1785343764-874060
X-HE-Meta: U2FsdGVkX18hLlkDzeDOLmflAaguRHGEOPNIzvifaQvvHr1LNr5Yf4SAaRgRrDsOPMNL7QHwRCPhglMEwnn7hJBwLVt7dxzTbhk5UKKmT7D2N73FzEI2RnqkTWmnl0QsWJwZsCwRue1UBatKKhO9SvoLWD6ozuYbMHZ1wcJe0n23I1C1SpPX4IHRE/Q4r0dIqvB4l3zC9abieXQ6jIs3rEQMiLtHOBAlxAHC+GSIHsFpqytxgI5oxKBp60Wa20Ojihlb7SI0NuGqQGf0dn6qN2VMYjDZhs+8Dx1NbGKzKW9wTgUFsjyPiNyjCnOCaZ0MbCv7fqHcjGTOs2DOVBI5CXp4jgI9pL6ajr9bLLiodhohx3VztVdM+q7CpPpmrahCw7EKgDhjPpRoMK5HL3kyQu+0Lz0isgVajGXzlE6TC4ReKE5vOA37/eNZzDsO9hXeC9+2jDrpjWqLUR8WY+l0sAx/X54b6BNg8snJl+/50bpVjuT1MfjdA0O433X5fMj2RW+rBBO3x5k/BuKl0xl/9ho25pmzmo7z373w2bf6WuJiGST9CdK8YzG+iBFqvK85IJv+zvPew+V7hGExhcpHBQICnM6OSHmKDkiqCqTovhLY8mCxKH37JQ4s5GIm4XxynFCJW9dfO23v6moOcbC8GSp3iAk2yxstPjGC0nIKAUKQVkR53o92gh/eMH+uW8ZaUKYRklbrKnz2SLhjvHkJs5g7cZ4Uz1dhlDtyEZIrNaNC3IUbh/TY52xkBSgAhpX0FAzyK+0DwiXc/ehaUiiOZdUzYoj5wf/4E5WNWqh2Y+4eoy2qurBxj2+YY9PQ7/sYUZ1JsSo3P6Idhpu/OdG8n6bjL2vSgi74PxUKp58gNNy2y491FQwIuwdFsG4SDwIP/k6wmPJFWTd+B5kcuhYxUY8JM+h+ygFnCZySx/0XAntrZ00O1zARUWu3PpqqgKlMD/lCV2x7HwW4+rREAu4
 m+JG1P10
 9FB0rnmudjSYwkwpcbBXOjoFNv28rQRfPhIO2u+EGKEkTUecNiBvlrKFL6txTpxusenbrsf7loC1E2ykczKqRjnMymkXJOfaXN2F2eI09AxyT8pURdI8I7fw6Tz4cTbWozu9r1JZrZElO8/V5qYOXV/TKysuiDUVN56uluXffA0yoiftGrDnfLVs4ZY/4IkOZCypYXCrkKmGftm4qd1GDAiYB0BxQZo8d0bbfr3nGN/hLrHONm09dnchRkJ9mQfdrdAN7I7U2kjJIP9cVmcMR9wUQ4VPtPyhI5tZ24AT/glQ74m9zcZMkI2nQAhrobqWBgX8+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch establishes fields within the vm_area_struct type to store the
anonymous page offset of VMAs.

The anonymous page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
if they are unfaulted or were not remapped, otherwise it is equal to this
value at the point of first fault.

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
file-backed VMAs are tracked by their file offset. By adding anonymous
offset as a property of VMAs, we can now track them by their anonymous page
offset instead.

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
index 87feaa5a2b78..df78847f5f07 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 	return vma_end_pgoff(vma) - 1;
 }
 
+/**
+ * vma_start_anon_pgoff() - Get the anonymous page offset of the start of @vma
+ * @vma: The VMA whose anonymous page offset is required.
+ *
+ * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * anonymous page offset at the time of first fault.
+ *
+ * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
+ *
+ * This value is used for tracking MAP_PRIVATE file-backed mappings by their
+ * anonymous page offset.
+ *
+ * Returns: The anonymous page offset of the start of @vma.
+ */
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+/**
+ * vma_end_anon_pgoff() - Get the anonymous page offset of the exclusive end of
+ * @vma.
+ * @vma: The VMA whose end anonymous page offset is required.
+ *
+ * This returns the anonymous exclusive end page offset of @vma, which is useful
+ * for expressing page offset ranges.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The exclusive end anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+/**
+ * vma_last_anon_pgoff() - Get the anonymous page offset of the last page in
+ * @vma.
+ * @vma: The VMA whose last anonymous page offset is required.
+ *
+ * See the description of vma_start_anon_pgoff() for a description of VMA
+ * anonymous page offsets.
+ *
+ * Returns: The last anonymous page offset of @vma.
+ */
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 939b5ea8c9e0..ebf0d912be7d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -967,6 +967,11 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	/*
+	 * Low 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_lo;
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
+	 * High 32-bits of anonymous page offset.
+	 * See vma_start_anon_pgoff() comment for details.
+	 */
+	unsigned int __vm_anon_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
diff --git a/mm/vma.h b/mm/vma.h
index 0bc7d521e976..54ed7c744e3b 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	vma->vm_pgoff = pgoff;
 }
 
+static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+#ifdef CONFIG_64BIT
+	vma->__vm_anon_pgoff_hi = pgoff >> 32;
+#endif
+	vma->__vm_anon_pgoff_lo = pgoff & GENMASK(31, 0);
+}
+
+static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	__vma_set_anon_pgoff(vma, pgoff);
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 715feee283f0..baa7e82f47e3 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
 	dest->vm_end = src->vm_end;
 	dest->anon_vma = src->anon_vma;
 	dest->vm_pgoff = vma_start_pgoff(src);
+	__vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));
 	dest->vm_file = src->vm_file;
 	dest->vm_private_data = src->vm_private_data;
 	vm_flags_init(dest, src->vm_flags);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c52b23773cd2..26d9210b1e8b 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -577,6 +577,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_anon_pgoff_lo;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -612,6 +613,9 @@ struct vm_area_struct {
 #ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
+#endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_anon_pgoff_hi;
 #endif
 	/*
 	 * For areas with an address space and backing store,
@@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
 	return vma_start_pgoff(vma) + vma_pages(vma);
 }
 
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	pgoff_t pgoff = 0;
+
+#ifdef CONFIG_64BIT
+	pgoff += vma->__vm_anon_pgoff_hi;
+	pgoff <<= 32;
+#endif
+	pgoff += vma->__vm_anon_pgoff_lo;
+	return pgoff;
+}
+
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_end_anon_pgoff(vma) - 1;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


