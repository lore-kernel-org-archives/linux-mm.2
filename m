Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EA3C4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C68F6B00D8; Mon, 20 Jul 2026 10:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DDA6B00D9; Mon, 20 Jul 2026 10:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D866B00DA; Mon, 20 Jul 2026 10:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32B916B00D8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:41:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1A38A022B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:00 +0000 (UTC)
X-FDA: 85009417080.16.9F98824
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10ED2180005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gg6VsMK1;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOjALeQWfktNGatwQ3HQJN++izkD/DEyca508iKFhig=;
	b=01mzxwLEjR6k7Go07+l1QTv9+v7EccPZFkJatECIUW8JLqhGVH3EyuOg93QAb5oz/UmTFh
	02dSwsWA8hjhS1SOPaHISTj4QPpBZpTp8Bih7UhwELkfq5gm+F+lxiRqeUFw1FTZSutPmP
	C5LbZfpf16xkcnasltLEMuEOTpH21vY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gg6VsMK1;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558459;
	b=kQ3ZTZLbD+KRl8oHafXod0rGQ+1w8vRG5GEhROHMFnbkVY7msGyhU2OiuOqXEY0fHEQ8ac
	YWljK4kcLebVZbN46FRKIKvTmYDGg6WpQG8IeIuF5RibNG8cr4F1+Wo4xoCapt9TTKOgAq
	SLrtfraEpcZUcbevUhL4yBndEjN+N/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E5F7601DE;
	Mon, 20 Jul 2026 14:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9008E1F000E9;
	Mon, 20 Jul 2026 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558458;
	bh=TOjALeQWfktNGatwQ3HQJN++izkD/DEyca508iKFhig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gg6VsMK1SCGe5SxVnYjGxisra5ktU6YiVprScyZR1y4clbBZMlvyhNqQyrQPT/mhH
	 eYNqFkmwx/K54oABhXAF1bIqO259lxX0yqG0NvJ5tZOwkNQvQNa6OUWxmDAP81jwfz
	 4IPj89rLt03ICnSg/GHNhlirUu6mXd+CtkgRCjwzRv2oDs94hWBVv3ieKIj3yc5Kcn
	 Y8+pnjMtDGnY6ursuz7mblpFgLQdH+tOP3W4Cqr9iPH51fPuSxcv57dk7sJSVdFzT5
	 n84VfDHlwPqSbjX38E7Iyhqzj4k8kuYBqGh/LSn4mNlLaokQFVDWydB+P1rWqhFo8N
	 h2liIwL3AYwwA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:39 +0100
Subject: [PATCH v2 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6927; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/nslfZWyuZN0P4RSPwpZo1T/axp/aymDsCSAtPi80q4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN5Y7Nh6ecYbxte/bDfl5X04lay8Y5vMmor7/Jnej
 v/sToie6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBESiIZGc7fUYp6e3nXk7+G
 0ftLq38z8m3dtiRy2fXn893fP19U6cnF8Ff24P9tYQYqh9SvX8y4lfHR1WVm75TeiTq2e+aYqk5
 cO5cZAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10ED2180005
X-Stat-Signature: u316h74gg3rgdg8sw3gjyjapxf1micsk
X-HE-Tag: 1784558458-346178
X-HE-Meta: U2FsdGVkX19yLirUNn5BrCL88F/+YWe1VXN7i4iuvsue3ylZqpQtJ7iZpqr1n2SZnKL2hU9INOf70rRTKzgtnWLH/eN7JsjAqF9hPmG/jcOrg3Au40wxkCANa+PKBTPrXalfhrQ9Udv0Ov3lHC0Be6V7oOTCZ8M2inbBUP+byvgx57dwl1PWbcg+34KBMtBT/I346enbPwUWo4Aqo8Yj9cFvtHkanmnq4t6M+dvzYVxbFl4vjInqXUQ6hr8xqEkjg8qmzEM4Xg5kzNdXDZne+gsRu4D1KQBhAlGKm7DqORwHWb9N+Yo3+JLjUMtKciavO8S/e4r8Q5MTu9WHyXMpdnqQ4qNs4lpAbr69J+zifrlxGMlahbDFDchs32cU2OvF0PtHTszd3tRDg4UrmUzP4MujrQk7u5IRdaKg05X6G7gn2PXt2Pp9VJBOIXM3WWL8+ZBDxWrfOxLsH+Izzgbaaf5qFNr0DFIhFD2QrjTP8o3nWSWyPRUmJNvHrzBYDOTXoJvceLG3rFElwPWKSiG2GJigplqLSZp/sg337qJWZH0ZIxLQcyAkmnd1Z/j+FkLC6brMDwJzFFCBUHgMHq1NFuC+RGoVQ2ZeQrx37ghCRKUUyRGseDj4UyCG1ww0sVxcrddRf8+P3cahiNIuw5Ct7BS0o1pD5NnSfzPwzYetQ6gYecC3tDkYtEeUKfniBFQQh8FJ9297yx20idjB6UR2XdbRdjkm0hwO2uanmA7VoR9RKd4ZKhL5d9H6zQlIXMa8BOx9Qy1LjdtSBDUZxB3+cZUXHJEzKQw/Ga2DQ2O5cDR5qrWxNiHhZ+7+Fut/OuYeR6yeqxuD0J/61pXTCkMjqYqKDg8tCGQj3JVxLjO7PYDzV91mE2YF+qQVhWU9bMz4DdwgjeR8DQxGxF3hqHgXQ/Jp0pkWgFP8Afr1xa2IO/xF7e9ZcPchffWND+WRgmMR+m+7bzJyPbWGTMF8jHl
 6TZ/s4jo
 syUMsmgOX1mOwH6G8cuULYw1hQVliO1ygSj4mbMGMDPnVKHNt+xlJEJJYdlwoEkGDtS/paoeOyuIAXtagi0U/T6SHLlIxe8O/IHOQpyAzRBpeqNOPv2rh7FRmQ5qO0FeLoo3GTTIq4YE9TWdm/O0IJ30BrNkPOpa8vvRiVyhghbNbb8uy3p9tHdYRadb8A8S7CyvDk6lS3+RP+z3fWVI8LWvrKWTmRs9UHpdk4XJ1VvzTSC+ABf5yHkzGTjxqk5qfJHVjrfad9z5S6E81Sn8G0xyKope3nbBt6+FnGONB+DberFF3ULVTSWfGer6SurXIPsQXWU4bP+PqV7nlJtqEkPFcA1/KagFSyx+wVoOFEtxvh0Z4SyDXTUKdAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
originating from Linux's distant past.

These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
vma_is_anonymous() but otherwise resemble a file-backed VMA.

The introduction of virtual page offsets and their subsequent use as
indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
thing with these but we are left with inconsistencies.

The vma_start_pgoff(vma) == vma_start_virt_pgoff(vma) invariant is true for
all other anonymous VMAs, but not these.

These VMAs are also observable as files in /proc/<pid>/[s]maps but
otherwise behave like anonymous mappings.

Therefore let's make these VMAs actually anonymous at mapping time which
will activate the anonymous code path for mappings.

This means we no longer have to account for this discrepancy anywhere and
no longer have to think about these at all.

A previous commit gave us map_is_dev_zero() to positively identify these
mappings, so we expressly only do so for these alone.

The impact of this change should be low as likely very few are relying upon
this in any case, and in using them are asking for anonymous memory, so no
longer seeing these as file mappings in smaps should have no meaningful
impact.

Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
linear_virt_page_index() to reflect the change.

We make this change in call_mmap_prepare() alone as /dev/zero has been
converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
mapping of /dev/zero.

We also remove the now defunct vma_desc_set_anonymous() and eliminate the
temporary bisection hazard fix from the previous commit.

Also update the VMA userland tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 10 ++--------
 include/linux/pagemap.h         |  3 +--
 mm/vma.c                        | 26 +++++++++++++++++---------
 mm/vma.h                        |  3 ---
 tools/testing/vma/include/dup.h |  3 +--
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7614afe99c96..7fabe6c66b4b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1554,11 +1554,6 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
-static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
-{
-	desc->vm_ops = NULL;
-}
-
 static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
@@ -4352,9 +4347,8 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
  * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
  * page offset within the file.
  *
- * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
- * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
- * regions have their page offset set to the first PFN in the range.
+ * Edge cases: nommu does not abide by these and CoW MAP_PRIVATE-pfnmap regions
+ * have their page offset set to the first PFN in the range.
  *
  * Returns: The page offset of the start of @vma.
  */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3307c0551a0a..4e8b2b29f6d3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1136,8 +1136,7 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
diff --git a/mm/vma.c b/mm/vma.c
index 103a6a134dec..d3e0457a11a1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2622,6 +2622,13 @@ static bool map_is_dev_zero(const struct mmap_state *map)
 	return imajor(inode) == MEM_MAJOR && iminor(inode) == DEVZERO_MINOR;
 }
 
+static void map_set_anon(struct mmap_state *map)
+{
+	map->file = NULL;
+	map->vm_ops = NULL;
+	map->pgoff = map->addr >> PAGE_SHIFT;
+}
+
 static bool map_is_private(const struct mmap_state *map)
 {
 	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
@@ -2629,10 +2636,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || map_is_dev_zero(map);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2664,7 +2668,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->virt_pgoff);
@@ -2682,10 +2686,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2814,6 +2814,14 @@ static int call_mmap_prepare(struct mmap_state *map,
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/*
+	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
+	 * anonymous mappings. Rather than allowing these mappings to be odd
+	 * outliers, simply make them truly anonymous.
+	 */
+	if (map_is_private(map) && map_is_dev_zero(map))
+		map_set_anon(map);
+
 	return 0;
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index 94277837ce6e..44fbb50dc3fe 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -267,9 +267,6 @@ static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	 */
 	if (!vma_is_anonymous(vma))
 		return;
-	/* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file pgoff. */
-	if (vma->vm_file)
-		return;
 	/* If faulted in, could have been remapped. */
 	if (vma->anon_vma)
 		return;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c617ee2532bd..c5191b9718fd 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1648,8 +1648,7 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;

-- 
2.55.0


