Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C6AC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0256B00BC; Fri, 17 Jul 2026 14:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679D86B00BE; Fri, 17 Jul 2026 14:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5696B6B00BF; Fri, 17 Jul 2026 14:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C95D6B00BC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:22:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B1D4160204
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:22 +0000 (UTC)
X-FDA: 84999088524.30.A6A9075
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3F97140010
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8eIgB7Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBERY1CFqX0D7t50CAbelyZ+L1fjNG+q7nyi8SSJxkg=;
	b=TBSb0rHWHkG7oEXgPjl/rpM9jmC5A22a9WoeBXm7pGz8zCmBvLUMkdQ4Snt3y1ZuUwpGIy
	fQn3rfXt46ZtcsNSV/ukMPWQcWlBp1Cu3Ut/clILxhYKLmaixJ//Z6kIi2fEjGBnogMcnP
	pWlaBzAipf+4Na+zXiwWfJI3RhvfzAg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8eIgB7Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312540;
	b=Hyvipy/EHmpBdra3WKuMk6BU+et9WTxXpu/BS6czCSfD42RX/oZ2oYhU+bYlGHfxoSUKmb
	x0nL3zaESfApQwd2naxp6rwX/9Kx4535WrbGbLp5jJgWNTjHBlcoGacMIdI96EhBbN0i2V
	l+6Eb0VFlQs2BjTN+fLM3lswIQGqmHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7DA0403A0;
	Fri, 17 Jul 2026 18:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6751F00A3A;
	Fri, 17 Jul 2026 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312539;
	bh=TBERY1CFqX0D7t50CAbelyZ+L1fjNG+q7nyi8SSJxkg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c8eIgB7QeydVoinrdlpcbGKnB55ieFOn62QyloUFSD/xDwVImtEpD1Uc6MjxCaPAZ
	 DZO3S9lVGYz8Zsd2OyvF2CCi/7g6ZvOhyIQmpetfb39EXpqZl69WbWiXJqF2wNhlYD
	 9BUIAH5kVtQrz7GZhGbhH21OAjE2/rphIeArw9PRPf4hJ/ZzqA1Rc6vbdRxdgvPFUw
	 /O9JtubscUgSdUVRM58U1xPiRDDye0Vdkyb2FU/J9x+Ce3X+bq+9Uif/ENzHO3iwj7
	 YDJEwmvXl2M94/Lux5lXAXJieBsCZ8/fCQcHsp6kkGQRuWSwAw34W9BeHqXThCf2Ae
	 6lYMHXjLnQoAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:39 +0100
Subject: [PATCH 01/15] mm/vma: introduce VMA virtual page offset field and
 add helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-1-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7578; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YXEfVWh2K58M+fDJD08jE97qBHPU4vg8rEAVLna7Ku4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZqG/FtFZhhy1e24Vpp0o5/93M/T/xeLvvOriQrg
 kvBev/xjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwkZjEjw4zN7Id9mz9d9RQz
 rXA98rNj95pNe5juJTP05vU1Lvv0mIfhf0jhxhlLu725b5zePG3itCiX2e/M0p43P2wU3ezTZfh
 agRUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: C3F97140010
X-Stat-Signature: 86n8igmp9fbijn3nzeb77mctxnhw44b6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784312540-543536
X-HE-Meta: U2FsdGVkX1+k9P60ilhwMkBuisU+fjtzayhwpRlCkAEF5D1kT5UZqAP5w6c3KtygFHupmBt/zJI+6q4gxo8fpj2KcR+wPq1oRGcV2o3uk5hSE6ayaKQUZ1oSeFIT7Rt1T4AUdHoNfLoKH7wfnBY6Xfq4ssZr3LD1TsBy4wJsj8bQ1NOSdKXJFnomap8ldLh55qjL0ZDQdky3O6Ys95RDEP2JnVBeZoMQVui7xCBh7XEcG56Nc43yD9PIL+PcIDbZ8ABb9i2pCNmRu15bFIR866mDTGkChATN7p30coO+RJqkXe0UWdcHj/G0al1Sr+N871WSxgdw1iO2TP+qwCYoE9luXoGWlsJ1mHDCOT9qFKAYyHwGAOUU+Q7IFnIN1L2j6djMLCWFQyNgnNXXBL3lpoKvifsQq3aYJ16ZiuwhXzZizJ6WkFp+33pwdA6FdMIo0nBvwYqUZL7/Q+tU9y4K/vDvTiuXlMdyEWbKjWqFlaH92xXg9kuzZ/BZpuEcTe3NcsujvJiEKEtnze+39R9tUMQ+Em7WwGrq11pEYBNLxdc+IZnod3WYtU2XKX824qACy75itwccAsU4YEk7itdjiBJ13oWlBThRkG7bbBEwnnUYpD1GISHBcqBRFG8J4q54cYh0I8t2s44xvkPG7V56F66gSLGd/edpIDWCPzJsi6e1+WEqvx9OAWKDerNlc25+wvnJVcamo+amZK2nmFsrUJACdwluUcVj2eYmv9X53yDtRXP56cFVN1VjK46w7FRamOt+xWP3MdTYo8IZb6ZtbNEjSc8InlSEyPbZJ36qP11RA35zlV2nxrUPdlWZ+j0MznJl5xGngd61mdjXr6quIXQJvQ3c18v3tLNmiVj0WiQo8a7qum7MAHsxGPi9ynJ4fNFfEnoQziKAi7ih6uTPq7kb77hR6cUkRngvI8Ypj/MJBmUbxHXy1q36hnkb0HjkfRlAKegtxidaXUXvg4t
 5iu39Bd6
 ieVwfioltpFJlk3QSBrKvgKcpQn1a2eGiJVe8G0VEMQEjBdJzB20miG62e91EpusQc0bVX17DKJUk+opOpr9CccNNePkJZjynC1NzCKVzIv2llb8lmnmWZYnpU1v7d67TbwyE/awMpXs6nYstKEfRlkWHJR1XczPRkK3i6mm1qb7y7Kki2fyp5+ztgnhHS1vZop0vQRBujPDFw7zQ4wa3pqK/XEsOWNI8MXZE0lAWlLfEXo6fI9Lld4a5VD3z7G8JEeD5jkILyRP//mv8O79WKVYxZ0hqKIBLibOB1S/7vIeozCF6KDU+G/ElalVCJBmm34ru
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
 include/linux/mm_types.h        |  4 +++
 mm/vma.h                        | 14 ++++++++++
 mm/vma_init.c                   |  1 +
 tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
 5 files changed, 104 insertions(+)

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
index 939b5ea8c9e0..2710628059b1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -967,6 +967,7 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
+	unsigned int __vm_virt_pgoff_lo; /* Low 32-bits of virtual pgoff. */
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
@@ -1041,6 +1042,9 @@ struct vm_area_struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
 #endif
+#endif
+#ifdef CONFIG_64BIT
+	unsigned int __vm_virt_pgoff_hi;  /* High 32-bits of virtual pgoff. */
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


