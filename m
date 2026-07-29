Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517E0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFF66B00AE; Wed, 29 Jul 2026 12:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489186B00B0; Wed, 29 Jul 2026 12:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C45B6B00B1; Wed, 29 Jul 2026 12:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7AB6B00AE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72EFBC05E6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:45 +0000 (UTC)
X-FDA: 85042403250.02.99F1B72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A8FB54000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BiGQ81HF;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6AfyeWGGpFpb+56M3NcL277b6pQKN8+Z8K+MSLUbwU=;
	b=2uJvtfdy7wSxsIJNlP8I2Gs7dpqoWpX9iHTHblWeZq264GRJUi4qIt7oySLX6b5EAT2sc/
	aqgdu4KZqvJwFR71bEVPVMAX4zzM0t7b6cpdPDeki4gSaWvgoiakR0NcENktKJc6GXlsLF
	ONLGjTK4GaN9lszLaM0haW0XJ1lLHSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343843;
	b=OHmoQCwe5ulYlVOOabKitAXTfNyFpYRLPvmOPSBF9u7KHTeD6XcsjsfXm9EA/hZzZl2o4j
	6HVastduCqRyZFzIHVL1CIanqp1KoHSlt9dT1Qqg5VCu3K1RysmwQCKlOjuXlBElhyUZJv
	YTJX1CGzYk5BMS7+RiwmIGbmPrwuzJU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BiGQ81HF;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43B49600AE;
	Wed, 29 Jul 2026 16:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63A01F00A3A;
	Wed, 29 Jul 2026 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343843;
	bh=I6AfyeWGGpFpb+56M3NcL277b6pQKN8+Z8K+MSLUbwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BiGQ81HFhIYFZ5RKdBuSaYYZHYbKpqKcK5BdeQ0FbB0+8AE21JhO9+BiI0jYTwCx9
	 j05jewDdLElhFQR7c9OP9YD5QufSRk23H5kZRGjBqpH3rGhicJDcCHRfdcaNUGZTXx
	 UrAD+LoLQ373xDZElwmV3jzmREO3Bj+8GsGIpcC7RDik3bco1OxwIWTUEyCFLFkJTM
	 ipFTLTGq7hY+XNQ6ixSxj/XYe8csaB60ZmQkg/Oc/oJgwX+o27OYw1ty/tBMcFZT8y
	 Wzf+m7Qr44L29cFn3g90HMlKN58KC61RiWcyUwXRBoOjrg1GoUHivYipsyf2vRRdEv
	 sauJZoy7y8vlQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:48 +0100
Subject: [PATCH v3 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-13-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8545; i=ljs@kernel.org;
 h=from:subject:message-id; bh=K5858xQinST9YJkcs/CtiCVe+WShQT71sYmpJaf+2Ps=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H4apJo1mlUqbmB6KiZv1HqaYdJKW04m+0Ol91eUh
 OzwrZvYUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlMX8rIMOfBDIazEa53clM/
 Zn+bnBhnXL1A4808rX/nDtgxZp1wtWJkOPy5bM+pdJe1bwK4qzYFbzE2D5vbK9O69k7ivfQnui5
 9HAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8FB54000D
X-Stat-Signature: 96yt1soebaigqbmwetky3t8bzuirzkex
X-HE-Tag: 1785343843-268880
X-HE-Meta: U2FsdGVkX19jB7zTLqYVfJGgbIMDkKvACPjmgZjqzTNNmlZ4tJmErqgOLOTOauQmjWpCxXg7w7VJn1KXt0cVNVYgMHxvjyI95b9Vuidjip5wpBAroWD6Q3yJ7anzyv7qe0w526lj7LGLSbRUl3oV/Vg3GCU8R1FNeOEq070KO/aiiLrbbVduf6xVyi3Cwm6WMPcruiH+s+CUBhOp98hf0E2L0TzmeHSS9y4D253xyPmGoD0epz8aBjfAqUKDhLbC61YES4RqQYI7l7BmD27VuIjLTuIvGUFVhVdHJfpSGI6vSLcML7rX+07DmwxGA6ILhvrNtAwZG5X+p/7TNgUW/Am7sZCDk8m+Kv+S+QljK4OklZCephExMGKOVA9eq4Qs1sZ8QWxHqAZfFscBKu/Nof13vfJiXXr+rcqOp/N9gtKOZZfyCcS1UAVjZOxYcnMSEVCDZhUb9B4mXLxPSmJEh6dhimlWqCoD7XVVUvye/VyFSnUC8WelbVRg/tPKjdhnc/jJSKUQh1a10ls7C/sUxisusKiD8VFAsKfWi94uWwSwGO1nEogReLhFbkLX1sgJaw5X9/cxKmeS0SR5K5rG/aXHvYKjatjPRcwPpsnEeYj+oNLq4uCEAaOlBkfmOR5MzhTh5vrWGeNrjXvxUFjyYAyPHkGGe/Ir0ihVmwYKVcA6ntL2+COIILZbxmx9aN1p4xlqiiijyzfiRXWTo8rJ806wyJpg7Vv+Uqcs2gEaKUluY4fDqiMwOOGs4PUwfxFcifoQ3wFo6SiLzX0uQkflAFDh8URJzaoO39Sxjns5r+bmR56uO9FAaq9jrFNkoL8ngZ+RfVB8YqrKy5l7mtmzzqXLRB/D+JGVx4bcjeb6iHAC+udFaGZHFYILg5G40UTxOeCdikhc8Ytzg+vZUpJpIwBJK+4KhkfMDh67CBTMrIgGfKEbUuKNDZQcEaq4Raw45gJJT2AedVpHWg9g5t/
 Ytco9sxV
 zaTvj2NfWj/KGS6/Cm9YxrGdlDZmlcXcIzGjZ2xs5yjbmPJC7emOuNzt1g2uu9zW2nFRf7XSu917nm78LatpZ5yiL9ISZ/YrWR68+U5MkEwpezm/fqwXU+oPV+JEESTDo77IFGi+repMnjFqvvPSpqkvFzknV3Nayi0YvnxjASiNRuaITOzE2oJl3QubafwAxCH7sgLkUc2Xl1exhkp8dKDAE0mxHPZrjk9NgiZJ111SKHRuOd7AdcI2ikpC10E+tyQVJ3uS05y7LPtlVvEoDUwNLdIb9uAXDBZM21Fnilz8ccTTemDRujvcw1LLEnuc3SBnGVB7Bp7+FzDD20B15hJTcs94jnyjNjIoydZ8Rt2ORwrh9RDFafoOjYw==
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

The introduction of anonymous page offsets and their subsequent use as
indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
thing with these but we are left with inconsistencies.

The vma_start_pgoff(vma) == vma_start_anon_pgoff(vma) invariant is true for
all other anonymous VMAs, but not these.

These VMAs are also observable as files in /proc/<pid>/[maps, smaps,
map_files] but otherwise behave like anonymous mappings.

Therefore let's make these VMAs actually anonymous at mapping time which
will activate the anonymous code path for mappings.

This means we no longer have to account for this discrepancy anywhere and
no longer have to think about these at all.

This is user-observable, as MAP_PRIVATE-/dev/zero will no longer appear in
procfs as a file-backed mapping, but the impact of this change should be
low as likely nobody is relying upon this.

However in any case, in using MAP_PRIVATE-/dev/zero they are explicitly
asking anonymous memory, so no longer seeing these as file mappings is in
fact correct.

A previous commit gave us map_is_dev_zero() to positively identify these
mappings, so we expressly only do so for these alone.

Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
linear_anon_page_index() to reflect the change.

We make this change in call_mmap_prepare() alone as /dev/zero has been
converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
mapping of /dev/zero.

We also remove the now defunct vma_desc_set_anonymous() and eliminate the
temporary bisection hazard fix from the previous commit.

Also update the VMA userland tests to reflect the change.

Finally, update the procfs self tests proc-self-map-files-001 and
proc-self-map-files-002 which both intend to map an arbitrary file
MAP_PRIVATE then assert procfs state, but happen to choose /dev/zero.

Fix them by updating these to /proc/self/exe which is guaranteed to be
present if procfs is mounted.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h                                 | 10 ++-------
 include/linux/pagemap.h                            |  3 +--
 mm/vma.c                                           | 26 ++++++++++++++--------
 mm/vma.h                                           |  3 ---
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    |  3 +--
 7 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a65371d05e89..660e1004a6f7 100644
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
index 939b8850df49..4b6ce8affe89 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1136,8 +1136,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
diff --git a/mm/vma.c b/mm/vma.c
index bb68fef2393b..9b565a1967c8 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2632,6 +2632,13 @@ static bool map_is_dev_zero(const struct mmap_state *map)
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
@@ -2639,10 +2646,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || map_is_dev_zero(map);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2674,7 +2678,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2692,10 +2696,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2824,6 +2824,14 @@ static int call_mmap_prepare(struct mmap_state *map,
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
index 024fabe63560..e97bd2dfa786 100644
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
diff --git a/tools/testing/selftests/proc/proc-self-map-files-001.c b/tools/testing/selftests/proc/proc-self-map-files-001.c
index 4209c64283d6..bbca9f9e2743 100644
--- a/tools/testing/selftests/proc/proc-self-map-files-001.c
+++ b/tools/testing/selftests/proc/proc-self-map-files-001.c
@@ -51,7 +51,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
diff --git a/tools/testing/selftests/proc/proc-self-map-files-002.c b/tools/testing/selftests/proc/proc-self-map-files-002.c
index e6aa00a183bc..5786cdffbbf6 100644
--- a/tools/testing/selftests/proc/proc-self-map-files-002.c
+++ b/tools/testing/selftests/proc/proc-self-map-files-002.c
@@ -57,7 +57,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1713602e93cd..556a57c48a75 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1648,8 +1648,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;

-- 
2.55.0


