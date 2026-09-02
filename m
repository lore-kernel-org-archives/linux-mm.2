Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68DDC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E773B6B00B8; Wed,  2 Sep 2026 14:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3D66B00B9; Wed,  2 Sep 2026 14:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA26E6B00BC; Wed,  2 Sep 2026 14:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFF86B00B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:01:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27BC51A0319
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:08 +0000 (UTC)
X-FDA: 85169588616.09.F419865
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 413204000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+7C8W3g;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWHcR5zNYr1EfV6OPtPzecEq9U3eP+YHB2G9CRdnHsQ=;
	b=1YTt+rPIqalFuIWUSGiqDzPHHqSGA9xhiDWyFGB8txEz0eMDztvY5m/XKCPJZ47zg3sKos
	KBnbWRQ4dchkkyow6Z4OoGkEzn9ROKLsPY976K4rnCElvU9CkOmQTFt/qCuBg9VrSFgIbn
	269UZ3sdAmm8rtBe9yoZM6AejuhhbZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372066;
	b=AkTMhI/0oSpGuy1Tm1mm2eVZhin2HzmrrivjoAaUzBdWK51ltCXptgNynfH142OkJNZFlZ
	3G5A2iMUxqzlKxelPyDTsG9ZuvFgyP0aQVQLlHH78fASNP7DqWGr1mDWAKc9gSmvMD/tvt
	Js0Dcfii0sTgxYrpqbQYioTBaAj+G3M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+7C8W3g;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E42743D66;
	Wed,  2 Sep 2026 18:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F4B1F000E9;
	Wed,  2 Sep 2026 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372065;
	bh=rWHcR5zNYr1EfV6OPtPzecEq9U3eP+YHB2G9CRdnHsQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F+7C8W3gRzDWl7YyOF49RAIH7xylwWxUddEtPGKB/5SR18jyMeKh4Kgdh0P7WzzL3
	 vWLQ0fgRcPDEtWxeeDy8SWUi5ppbN2L3E10Ys1m+OAjc+pUH58YTVjil3pgUQbgdUF
	 sYOQS8nYCW1Vj1rHDNHfPMnINo2ivjuiJ4TaK8jeCngAADq0oCvqdHk1WAv8p+mjEA
	 azLrh3XW5j/r0LEUvBPGop4OcHAFUDs4OdQMWuaQ1oiKUn8tngk9W1UG7yBuu3/NbP
	 s4Gaan2ebi/EPBXHsswTsWQzs9M8z69V9T8hkyg5u5TZ3UmPSKj+coab29kWrZfzWC
	 2rvKdC2vLbeEg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:21 +0100
Subject: [PATCH 4/6] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings
 truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-4-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8488; i=ljs@kernel.org;
 h=from:subject:message-id; bh=K4SvP05CqHzOvcJ4/3yF/wcyiiMwFp01ErJ9umXm+T8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHiFe83fvM3lSuKzumvztIzXtR6zOnnx+/fpXyd+f
 n8+eX2oXEcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmciKZ4X/q4h1VqQ8SEmf+
 +Tf7qf2Z1mgjxwsl3zb/D77N2W2pzTuLkeHptVtpfi9fGX40iZ7rnrQm+cMOpWlf+Wd5uam+d8i
 7FM0EAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 413204000D
X-Stat-Signature: tfnsaxe99mr1dndfeymc66jsx4z4tadq
X-HE-Tag: 1788372066-530393
X-HE-Meta: U2FsdGVkX1+IMBsBegn1raUFacsNteS8PlOoVkaLLbebMFS9pZ5rqslUlc3uAYzAS7s0fT5sYiT2fdfIzYLbx3E82+2+RQOc2XETNyE+d5uEv9VKqK5ZzARE12wNqL7Ao2m/lWnIvNCHCBH5gyH1MW4amcZjaC6IQ56rmsuuMLXNQkE7XTuPvdD2Bxdq5a+EMCG5dlZTd0dI+XU126h5TYfYD3xAkCn+ZDyHedCiZRE/l1mJMMwhsoORJToTtiJ1DWBnsncSf4znN9RO0f1n/iWCAl2ea3+NZjprt/SwT/6vvEpTQnFmYc+FXQlE7mw5t7fb+6tOSztzG841vpbK9CpK4ETiwz+eQh7vwIP1xJUQW1AyVhBC2zG0cZFcoTkjcLyPEF7IoRRTgUY1KPUxIFW590hQgsKdJd8cfuBIASUlufX+X+Vn/lMoYX+k/HK9GKQ5tVWuK2TwRZsdg/E1vvXkbxLK3kIcxW18ZeETIVp7xXB04npAvvXdjChceX6hw/q8UVCPrrKs4sKt7Ren39Hy3oItF0BB67NLOzN8fEzJ+xEzWnH8Rha29rGUJbI2mNsiCq3EUHK4oYfCY5YTiaPvGKa/enk27CbEg/FOziEsRnd6HRMYh3KSk5G1JsXft93kmzJmal9OrrdLgq5/J/xyfHo1NuPMLzQZLrdicmOnKVLTIpMl1EHmP0hdOIEKNUjtA6QIuIxPLmKj70qFsVN8JkA/lMnM5M0EwK8laH1jRWX4bwPN35YKgZQT4m4LukeOXfLs3NIRbCsMdcrn+WKCV+CS70b3BMFIQ2rNpv99oGBehGa00i4EkfknrIgvEfUvdHAlMY/MfR2vC7t/qs11GZ3+8AE+O6MjQyKlV3cpAnW4103ZYwllpxEU+6Q7W8ZdWwii8GCLoxc7t+q1GiO1xWiOlPoTqxBFZP70GpHSll8kcrUiYtGFVcRQybz1BpbMyWMKkilOhjZurGi
 h25PODyI
 ZPxnqAHzLimW7P1FIRhsJ/QdYxlTdNjqZlnwyHNy5695SlMfTsyAVuSQORbvfONqY2F4+2v7hEgVuZUYJtixscnTyOM+M3QHpS/kTqaAtg11ydFzvMli/lEa+zfRZwsUdnfN/IqSJnaDMN3Gt8/qMfIqam/NZVQ3S+DbMzxi6t5j/ijI7pUaLzDfdaBSpDHIPpmwdDvPKykG0nBXu5qakwSMY4qeE+wO+aJVU7AFaowNAjY8iHZrTPzVgbAXwUSMarzejO2SB4v7P7tRT0fy50+mxoiOg0mXmT3Kke63A01J2m7M=
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
 include/linux/mm.h                                 | 10 ++-------
 include/linux/pagemap.h                            |  3 +--
 mm/vma.c                                           | 26 ++++++++++++++--------
 mm/vma.h                                           |  3 ---
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    |  3 +--
 7 files changed, 23 insertions(+), 26 deletions(-)

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
index 4b8d430d9619..fa5ee026e03a 100644
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


