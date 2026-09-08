Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9038AC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11FA6B0099; Tue,  8 Sep 2026 07:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E93F6B009B; Tue,  8 Sep 2026 07:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863056B009D; Tue,  8 Sep 2026 07:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53A496B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:25:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAD85160517
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:01 +0000 (UTC)
X-FDA: 85190363202.09.3B5DFCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE75DC0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Shx6TYO9;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yazDYPGF74/He2HfY4z5SarPY7lHKoZZ4RLl0CKyvnU=;
	b=bEZIqYmvewF0F0fMbmzWuln8SAa8ZnhRq7VJ7AbYqYzTeMIuccq3b4ioQ1LAU+Yz4z8Qp+
	zLzoi/LBA3zDyZRwegbxxQ0Bx7KEwkwN56YjwPZtu1ibqhJdWoeSKz2BBqXPCf0f+f66KZ
	MhaLVOz9DIJuviAkBtA0yJdV49d3YHk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Shx6TYO9;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866699;
	b=7x9dcY45SQSf901m30CPiaCVIjh8xYpZ5tykRpPvSHPU7cWH3XysfwrfXrL3wJm54DK7ew
	7qDjBGzPTAPE6SAL914laHi+WWBCWn28rGR/sNbre8j8epR5/vUXRB1pLfhyqRkwTQgPWp
	XMpTbEbZueRQ36aJki6NUPOALZSVmK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 275F140A28;
	Tue,  8 Sep 2026 11:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5D41F00A3A;
	Tue,  8 Sep 2026 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866699;
	bh=yazDYPGF74/He2HfY4z5SarPY7lHKoZZ4RLl0CKyvnU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Shx6TYO9mvVknBiNeE1awVt5bACs63+IwluoLqEbILXwSV0GnAGg/zCQYguEZPV3/
	 YSG/XwVcfKeoUwCEbzJGinZmaoim/xwflGCpdp7rgDPfytGeAyyqYAlvDnCzqi8s71
	 6gfz67uNjCjekFJZdCUUlBETd6R6NHl2KzziwNV36s6E8G8vqsClpw1qGKheiWo3DH
	 vdZ5VAhLQDMhTw5b+XwH9EF9gP1B7ZYV2M9SehZ9SEnMqNGfTdYxhYnCoDm8SGv8UI
	 ejd8G/zNy67z0o4CVUdfw6j8OtfnbDI6SfkKCtp3qM/Nx/u+BNJ+IdLxGJniUCeuOt
	 vyf/ZI0B/sPCw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:41 +0100
Subject: [PATCH v2 4/6] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings
 truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-4-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8751; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fzX9QdUHMfVqyUp8LMONbNp4Wr4hn8wKnpReBWJOVJ4=;
 b=kA0DAAoWz53NioHifxQByyZiAGqf8HGhBHI1/4E1m+mlBR2WBnzPmZM3BFyoWgm5ixrBuXusp
 4h1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmqf8HEACgkQz53NioHifxSYkQD/Zkkv
 vcbHKVb39aHTglqLTcA17mnJTgpVr4MM1HNCObMA/AvlmIqB6vU8C/V4+tHgRqUReLRpOOrMMc4
 TBhcDWPkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE75DC0004
X-Stat-Signature: 8e3piis6snwbxhdqh395imxkbb95xu1c
X-Rspam-User: 
X-HE-Tag: 1788866699-483287
X-HE-Meta: U2FsdGVkX18OsGYH27groI6qtOE65cBTd0AufSYVpMM5sjENUUTjlg1ZNvQmMfXrU+RyWLnsWqajSbIiNYjC0aE27pWBo8ucJzWVRCLpbx5yysTSw45pk1McBJ55WmQ/pPoPQAsZggz7wR9KLECnD4QXkIQm9PFigzRdSpp0xrnGp/xPxTPpZA+AKjmVmwQE2R9y7ZwyWM519sgfFl+ke+bYAX0luPOuBDfhp5crffBJ+hWUha9Wp5XeabjEgY49jm2xEGsVXd5UVg9ZDBYI2wvLj+t+TsWilCkek8W8h+1d0s9qZRZQRxVd6zQZOKrbME4M0cFvYjMlBsaMQo3LN9zOyfm4EpwFTwpSCre6Ka1tbtioZJz+bi7decjEvG5cL0K21vl5+EOqc3yeqgwnQFUOClN838jJ6xQUCOWbLwiEnv5XU1bQ3G8Hw1igXmmRCiqVY+S99Xmkbdc+3xr6DHftylC8D2NtYsrE0cLPaDQV4vQWr19WOJq3z9mZxc91q/C8TTGkF7N2bcml9CdmYmuBmKr9ocKkH98GRUi4GINdZIdfQNmJed0NfvQRBDM7ucAsx1od/n8qqRGo6xvHdXprRieeswO8D77RBlwkRWc7HDjpXIoA6cq4d2iM9FLIjNZCS4WlTq1/UFdtyr3fh/ywRSq+0q5+nu4FpHf3pvl/Fpnb1YT2r2oQT0erAFilD6TL05a9rfsRdwp1IS+eZ87MF+efdbKHezqA8AjDjSbAlbcS4qCi9WBbOgpJVi6nYqN+OCSJsNPDKVzm7cKEcYtbCzg4+TtYiTKL6wYe9i+HBw/ifWa+v/fvxXnzlSgtEoScRaE7bRTFCfth3K2DBbEGiKduqXX9eXO6j7JQZgmV5zhO0U8ZEfEQv1vd3xoIVx7i2mXK0mVVb1/2xl+PUdk0W477JnOsBVkFm4Hu1rMIEfWIEqoku6RVzHv9lI4YtbVOdxNq+yV4JaHu3z8
 9YitNTfD
 txqYVP4pSFkE4eFh+yHislY21E8aQ3USIl63FQ1/LnaD9wwEzmVAteYrx0KWQxwJFmz6KiaysSE1BE/ArUm0qjuDcQDooXxf4/5Tnim/oy4wrl1PI1KixMuR+6O0XTSeUzhznksLgRTNSb+oh+AdsjPJA5sfS8GOJxRFOzndx9v60tY7Dw6wRE1Kj5Hlph/3ErSQ6WZgkjVi2jIMYh48ZfF+p/9xXPZLg99PWXROnDn/TiC/cSrfH6+Q5u+N4dgi60BIzfxSa9V1xrm/LjqQ51he9Bj+/l4PnReWhO4k/JqQa5bo=
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

A previous commit gave us file_is_dev_zero() to positively identify these
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
 include/linux/mm.h                                 | 10 ++------
 include/linux/pagemap.h                            |  3 +--
 mm/vma.c                                           | 28 ++++++++++++++--------
 mm/vma.h                                           |  3 ---
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    |  3 +--
 7 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b28e6fc8d5d..9238b7d52198 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1539,11 +1539,6 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
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
@@ -4405,9 +4400,8 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
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
index 0adfa6605653..939f3a5e973f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1128,8 +1128,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
diff --git a/mm/vma.c b/mm/vma.c
index 4b8d430d9619..6fdce4852ce6 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2621,6 +2621,13 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	return 0;
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
@@ -2628,10 +2635,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || file_is_dev_zero(map->file);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2663,7 +2667,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2681,10 +2685,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2793,7 +2793,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
-	/* Hooks cannot mark themselves anonymous. */
+	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
@@ -2813,6 +2813,14 @@ static int call_mmap_prepare(struct mmap_state *map,
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/*
+	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
+	 * anonymous mappings. Rather than allowing these mappings to be odd
+	 * outliers, simply make them truly anonymous.
+	 */
+	if (map_is_private(map) && file_is_dev_zero(map->file))
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
index 0d1a2ac88922..16c09dac59d9 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1635,8 +1635,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;

-- 
2.55.0


