Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CB7C5AC82
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C97B6B00C5; Thu,  6 Aug 2026 16:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A2C6B00C6; Thu,  6 Aug 2026 16:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7411B6B00C7; Thu,  6 Aug 2026 16:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45C936B00C5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:28:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC4191201F4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:28:26 +0000 (UTC)
X-FDA: 85071982212.28.29F6D0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 020F5180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:28:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oi8V/AQa";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s614eIYIfGzeFDcqmL80845cOq/GnH2yhXjc1z/Xs3o=;
	b=jBFMeLtzLRN2fpMMvFO5KG4via7LekYXlKmHEUaLrJ8BGSTfqdoRGOtV/MfpmAnvTnlhiT
	25h6k69qWe6Ows6kxvhGd6ZlL1Jr4F1HfZoG0recz56nw9vVAZaebyhtMmf+1lm0fPYfyM
	WwEM9MhnCgBPvZ4KD3t4vmygjTKYdLY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048105;
	b=kkXgK/EIYBGDDAwHXSbthSIRzFAOyc20WJnpl3aG0nEq3errtJLG3UHs4EkTfPXs76PPdr
	ZT1t8dOcSNfYCtqwhVLU9hAO/WzQ833BTxl2tVGigLJFQkMAaTE8EoViE8A2WJ6x7LnR/f
	T9OhPiTRz6cO5/TiLFe68UvyMDyhXXE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oi8V/AQa";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CBE4368A;
	Thu,  6 Aug 2026 20:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BC61F00A3A;
	Thu,  6 Aug 2026 20:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048104;
	bh=s614eIYIfGzeFDcqmL80845cOq/GnH2yhXjc1z/Xs3o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oi8V/AQazUITPY39thPVTqxXw0vxr3S3Qg2eMmuClvX+TlrdmvYfnj5YVnPZMVyJ+
	 17mHgRQlDSmUqgVu1vrg5lTcWmbbvW48uQfHxDmnuvMVU0mOFkfAsXHy03EOmjQ1rA
	 Ma5ZWc8LKU/U1AeUjVAuH4kR0pBWC+7XwuMV1BrSA/zO1mfs+Ik0u+7lEtUSV/SC2J
	 qV9vnDSkeKzTs5MSk/N4LeyaCAaXQUGMzjOl1/xZ6RzSIV12333ep3UU5Dw6mVw2gh
	 tVczRe067Sb/zlB+bP+/WkO1cdcmOwdpoQTziy0R/KEP3BRkdfsGV6etm/ILB6+4Hk
	 1uwbLeJxqT7Pw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:43 +0100
Subject: [PATCH v4 18/20] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-18-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8535; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xdiGzXr/KOMXOTiCtq5gy7iFQAvBdUR/MoFUcyPdwSY=;
 b=kA0DAAoWz53NioHifxQByyZiAGp07NGij7MenxMs4hFrbpxKbX4SONBw+Kwckur8VHwzrdiTh
 4h1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmp07NEACgkQz53NioHifxRpXwEAxEUt
 4VChWFpH3aNfi4wLpFOEqIUfcti8xIHdex2D0WAA/0SfNKmmDxjXLbVv2eFuKwrndL8TdVG0xQ2
 uBFNAth4N
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: r7pgir94993dk6aoosnacxg83x1jrrrb
X-Rspamd-Queue-Id: 020F5180008
X-HE-Tag: 1786048104-180203
X-HE-Meta: U2FsdGVkX18NwFHJ0Uz0wfJSbjCY6w2di+5i00H/r4mE0k9ckOqnr2QHxrRf/XPpIS9qatlDnEhzwgSB65cZglBmOuK/pcpAFxvMjhx+x2FpU3GyoHN5W9PCDwqywsDdRsUXF7sz0/01TDdkh20spzWlsRav2OpDT9AZDEdhnNdzqQkJigtCYLzAZ8l3vz0hAdednnrmogVesdXu4sFiUIfv3zctue5lxkidWggwigz7J612Lta4WGITICuwKHe9CuMbOJbZmqnwqLtzf7g15/cG4sxeW2NDhFh3GzaBOPtvb1IbwcCkeyojPeqOCIHuApqc5KesbIh1ql05vcFlpG8VNbu50hGKUHdm1GZNnq94r8S0Jb7IMNMtavkN4a4blkIGpzs84klc5D8+bUu1k2JRdrfCVwA1iEV1ZsHsAACgAFaAXl3c8atzqYZa6je0TAbHNcer/GTWLpVlmEychIGwh/bh46hWMsQ3KDtsFfUQ8P6QOWHU68s70SXciWt15sIVqF7TYSKa8VV4kPvG7noqpWZ0fl4+nDn1bGdG55pfaeU1b/r6xk1bsdcQcfWoERjvwRW3hLGv4/tmYG34bzwJ7m1bh3rO+k9UI7Dt4x71+EVieqhnI4oJfFtglw1aqHKexeTKWJ2dCs7+fO1iedTguQOmUfkLa6CujxLpHLt0yXh612YwD0aVSioY+ccep0PypXNNv+UiX7R8N04Grg3YCT72u8FtUZBM0JR0/Vm7Yg25D2EpsaM/S6gqyn9Y7LTVXXPKPLMy3bjEnqb+J2/sfb4riSz4B4PkTwGo+87+vFtIKnVStSpPZCkEkgO6rjOICrmegUSKStvIKK5ktmSPWtkbZvetvHLy+fvNI91S6VP+XyIUYka3yw8OZ01iHuGJouQFIPx3w3PKqfGJpPO7KVK3wids9wxL1/ze2llchh1PeOyRvtxeIGGUiG4Wjzp0asFstLIqHeCEavj
 iSEOOhdz
 o+pI7dLFCyOtNjXr14GKPl/ZYJx+pffgnhqDsY3vRZEX7nLd3KcXEEVqUH9uZTxhRa4RuhRAfiCRXn3QfGoxC4XFsMc0mhh1UccMQkwodSQHoqJdcKvmItOn+Nq4B+H2cwui1Mu17TOHZkz0lR/xEr5rtBjWSdZpl7fUlQjYT8eAcf7h88m6NkBRbA7/icen1Yu93iwAs9Pbn/rQ4eA3kAgdqzAzqZbd5m+0ZQA2NsrmdOSfv8qn/uZz9Kzyu8zWhrjtFw3ulx14qWJQlmkobMMT+IsHbqZWTwInFi5MvNwopnW/xJRJ7gmmFHijZQVX4iF0BFpHH0OBjqQwIX+RpKGtW7onT8iaRZIPiAcMeoRriHYJdNLllZPH5qA==
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
index b54bdbbf3906..0d21112a8b63 100644
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
@@ -4355,9 +4350,8 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
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
index 4271b5ff8137..6db84830e88f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2634,6 +2634,13 @@ static bool map_is_dev_zero(const struct mmap_state *map)
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
@@ -2641,10 +2648,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || map_is_dev_zero(map);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2676,7 +2680,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2694,10 +2698,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2826,6 +2826,14 @@ static int call_mmap_prepare(struct mmap_state *map,
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
index 7490e33f9316..aee36707abdd 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1659,8 +1659,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;

-- 
2.55.0


