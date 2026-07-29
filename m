Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4372C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B956B009B; Wed, 29 Jul 2026 12:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52F96B009D; Wed, 29 Jul 2026 12:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968F06B009E; Wed, 29 Jul 2026 12:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5386B009B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AE21A1B56
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:59 +0000 (UTC)
X-FDA: 85042401318.02.5D35B11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4BE7712000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezieZRwB;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wv/sniJPWuh56MS+R6ZBAFTPkbJMWSe2po51lfbrZoM=;
	b=yztY4bagzmGpEPbVmAgnTI7LGPu3tUPJotmUkIp5os6Yy17SmFFqfk4A9kDB+Us1pHxuun
	wf5ZFOvQcYF0amh3syJLWK3ELYkUzSIC1S5F1M9YnF0is5AzSdZeayUlHqc+BWswEJ9anO
	IIQTPGamvjb5MRAXVdZjSolwbjHCKn8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezieZRwB;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343797;
	b=GaIi4g5SHCoWmru0mdjn00705gkjn8dJI1cHOsPfJdJFAbuMZjnkkCQTH7yAlcvsUx1sLd
	mjTrSERyqPl45uEMoEsO+uwAsHhpdUPz33KeVQ2/2zglYVXsVSl0KVPcU31lwIkK7cAq4j
	SDwOZ4iQXN5Ui7kFjJRqRmSZMrmtRgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEBB960204;
	Wed, 29 Jul 2026 16:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A001F00ACA;
	Wed, 29 Jul 2026 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343796;
	bh=Wv/sniJPWuh56MS+R6ZBAFTPkbJMWSe2po51lfbrZoM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ezieZRwBqp4dJi5beGZCf3o16ujw0K9FRJuqddHEAaxMfVTXVPytfXrCce9qOFilE
	 0xCn64UPYS1ziVZj/0UcYER2CYmjEQN989PQClninZouhDl4TfulK6EQZdLz2r/2lG
	 4fV7KtP+fycXi+Zk/NpqfXN1A+FG4WBIg27G+PrCVINq8C5W9l8tZQP/Tect6U8HU1
	 WyswDmKDt6BAAHqWSYSxYHgtEQseaCwXg9Mc7y5uc2iYjTDYtM13XP4Jy8rAOCxaES
	 XRQYn+k9294bcciDYwmeQyaMHnNAH7LWvjmhgv3KH8qzdQtx/Ql99SJ+9I3EFKvJwk
	 pkK0S5mNdxfTQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:41 +0100
Subject: [PATCH v3 06/15] mm: propagate VMA anonymous page offset on map,
 remap, split + merge
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-6-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19086; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qnJR4y1/TZ9RglJJZf0g0HAIDSXu7pSn0d01UT2siiA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H4cj+R+9Dx4bUbMS0a+ja+/P1dXZYiR/dmR1aj1/
 2616kTzjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykPIDhn6b6iRP37wi+EXho
 tZ3T7J/IrIXJTi4Xt6pddZNtmbAvyZvhn6LB0pw7IcuspwgyHXVZe1kg9V61W/3VqWL3n7jo6iX
 bcwIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BE7712000A
X-Rspamd-Server: rspam01
X-Stat-Signature: 11x9u3nyo48w5g8uy9axxydzu61ju7ns
X-HE-Tag: 1785343797-503435
X-HE-Meta: U2FsdGVkX19GH+W4XS6HKnKrkYNmQD2QrwNUZkW0TQnD9WHRVccyc/yR9fyxLY2St/ubzgHmDjqvHQ0ESah+1Ff2jpN3NSt1aZXE4pjQsCicqVOwQbRLOkJYJ6sK6h7MfHy6aYF11+FblN+ju8NVh4XyTh34qWxNWdIfowqbNE4x1Lii8LH6f1nqcatfBDL0pkk5VJ9rLdGUdLl3Najxzwst6b/NranUwp1fuBSZ1oHwpO7nUB+BXq+pl7eB5wYZGU0bv191FSK5NmCWwVwH68UZfrZOf6Y5BnP/udI/yafmLGVYElpt10Scm51S5bC8aeh5M/H5SbuuTmEuLRjjUgdPmeUDN3cS2INSJ6NZU6zLW0KLJWswyOvgVf7Ubu2krclDDJObym5uzWhCXwZKcHYLkZyooL2FHGd0NrhTLlexWYqATxsw+UBl+wwkEoIrUblXCF2jC8jSEllZO4luY5pFn3pPyHBtFkQVbb5dTk8Nkf6x06cTDpcVtjUecPqhJ1854ONxf/PcJs4yhHLN8xGkFOXp62ZTiL16H0QsPOXZ1ctqvSTKPT7RmdFPDwv+8yG+XL6BWwTXR/cJE8+prdKI0PUswijYbNzu67wN1hAM9mfhMM+LCAIKoKcxI6bZmkzePJmWtyULYoy0ZbR2CKx+ooxHaSSJG1Q3DBWxE8PwKantpdXC5VfyLNqEikoTUFsKiiCYWLXd8Nf6o51c+pysdbRg3b7rw0Wl3zR1Jr99ye+CymDyigzf8BFVwKj7QB0umD0+8fAjHamMPxjO+xrWaBJHY9WE7vv8Ug//94AUb3LHD2B65tlpt9eboIbvMTJ1+33LyqB2k1uIJEXMpyytmWZKLdptaLBgppoIftbXWyOdcOYJEuKGyDp/h7udoCsv1xsDuxaolzkrHhJ9jg7Nr/SWQSZLHRN2359YH0CKr/nVUKePpo6PCVq9jVX8CSKIcbZeeUSyIogoPbQ
 jPUE/XGS
 As/pF7lqzIPkfbTC4D+JO2pynkyf7JvIAwGm5jkPgXHHo1xjiHtQZq9LPhc2CSEwQxjVaoPhu723Ui6xzPsBVnjMTeBvRDqMflSh4hConUZQGKINS9MLYmlLDah4A3GQbzRtjNqGRt3vnvT6m01FXSoWGfjbnYphVw0T6KiokUEscPO/NEQBe3I+Bnq7THBwcpaCV8AE/2nm+ZYZy768uxj1FETNm8j+y7tQsQMjzS/62nhkW0Z/tKslcreaFKEttBffFtKuzSlyHiY4vf499fqIzpbOCWBGIQrdxhAMknig19Xa8spsm+BBLIiRX1m9KBDoy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We must correctly update VMA anonymous page offset state on all VMA
operations that would result in it changing, with special attention given
to remapping.

We cover most cases by simply updating vma_set_range() to do so (with a new
anonymous page offset parameter), but also notably must update the merging
and mapping logic to propagate this parameter correctly.

The remap logic remains the same - we may update the anonymous page offset
if the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
mappings too, so we update the code to reflect this.

Note that we use __linear_anon_page_index() upon remap as the VMA may be
shared, in order that we update the field consistently regardless of VMA
type.

Similarly, pass through anon page offset to the merge logic, updating the
vma_merge_struct struct to propagate it, and also use
__linear_anon_page_index() to obtain the anonymous page index so it can be
safely used for both shared and MAP_PRIVATE file-backed mappings.

Finally, we update insert_vm_struct() to correctly set the anonymous page
offset on insertion of a VMA.

We simply ensure state is correctly propagated here, so no functional
changes are intended.

Also while we're here, replace a VM_BUG_ON_VMA() with a
VM_WARN_ON_ONCE_VMA().

Also update VMA userland tests to reflect this change.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c                      |  6 ++--
 mm/vma.c                         | 47 +++++++++++++++++--------
 mm/vma.h                         | 75 ++++++++++++++++++++++++----------------
 mm/vma_exec.c                    |  2 +-
 tools/testing/vma/shared.c       |  3 +-
 tools/testing/vma/tests/merge.c  |  4 ++-
 tools/testing/vma/tests/vma.c    |  4 +--
 tools/testing/vma/vma_internal.h |  1 +
 8 files changed, 90 insertions(+), 52 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index b64aa1f6e07e..9ea1707eafa5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1265,7 +1265,9 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 static int copy_vma_and_data(struct vma_remap_struct *vrm,
 			     struct vm_area_struct **new_vma_ptr)
 {
-	const unsigned long new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_anon_pgoff =
+		__linear_anon_page_index(vrm->vma, vrm->addr);
 	struct vm_area_struct *vma = vrm->vma;
 	struct vm_area_struct *new_vma;
 	unsigned long moved_len;
@@ -1273,7 +1275,7 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   &pmc.need_rmap_locks);
+			   new_anon_pgoff, &pmc.need_rmap_locks);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
diff --git a/mm/vma.c b/mm/vma.c
index b5bc3eec961c..91bb1c6160a0 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -18,6 +18,7 @@ struct mmap_state {
 	unsigned long addr;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t anon_pgoff;
 	unsigned long pglen;
 	union {
 		vm_flags_t vm_flags;
@@ -46,13 +47,14 @@ struct mmap_state {
 	bool file_doesnt_need_get :1;
 };
 
-#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, vma_flags_, file_) \
+#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
 	struct mmap_state name = {					\
 		.mm = mm_,						\
 		.vmi = vmi_,						\
 		.addr = addr_,						\
 		.end = (addr_) + (len_),				\
 		.pgoff = pgoff_,					\
+		.anon_pgoff = anon_pgoff_,				\
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
@@ -67,6 +69,7 @@ struct mmap_state {
 		.end = (map_)->end,					\
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
+		.anon_pgoff = (map_)->anon_pgoff,			\
 		.file = (map_)->file,					\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
@@ -82,10 +85,11 @@ static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
 }
 
 static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+			  unsigned long end, pgoff_t pgoff, pgoff_t anon_pgoff)
 {
 	__vma_set_range(vma, start, end);
 	vma_set_pgoff(vma, pgoff);
+	vma_set_anon_pgoff(vma, anon_pgoff);
 }
 
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
@@ -812,7 +816,8 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	 */
 	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
-	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
+	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg),
+		      vmg_start_anon_pgoff(vmg));
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
@@ -982,6 +987,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		vmg->start = prev->vm_start;
 		vmg->end = next->vm_end;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * We already ensured anon_vma compatibility above, so now it's
@@ -1000,6 +1006,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 */
 		vmg->start = prev->vm_start;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		if (!vmg->__remove_middle)
 			vmg->__adjust_middle_start = true;
@@ -1022,12 +1029,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		if (vmg->__remove_middle) {
 			vmg->end = next->vm_end;
 			vmg->pgoff = vma_start_pgoff(next) - pglen;
+			vmg->anon_pgoff = vma_start_anon_pgoff(next) - pglen;
 		} else {
 			/* We shrink middle and expand next. */
 			vmg->__adjust_next_start = true;
 			vmg->start = middle->vm_start;
 			vmg->end = start;
 			vmg->pgoff = vma_start_pgoff(middle);
+			vmg->anon_pgoff = vma_start_anon_pgoff(middle);
 		}
 
 		err = dup_anon_vma(next, middle, &anon_dup);
@@ -1137,6 +1146,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 		vmg->start = prev->vm_start;
 		vmg->target = prev;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * If this merge would result in removal of the next VMA but we
@@ -1908,7 +1918,7 @@ static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks)
+	pgoff_t anon_pgoff, bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long vma_start = vma->vm_start;
@@ -1919,11 +1929,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
 
 	/*
-	 * If anonymous vma has not yet been faulted, update new pgoff
-	 * to match new location, to increase its chance of merging.
+	 * If a vma has not yet been faulted, update its anonymous pgoff to
+	 * match the new location to increase its chance of merging.
 	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
-		pgoff = addr >> PAGE_SHIFT;
+	if (!vma->anon_vma && !vma_test(vma, VMA_SHARED_BIT)) {
+		anon_pgoff = addr >> PAGE_SHIFT;
+
+		if (vma_is_anonymous(vma))
+			pgoff = anon_pgoff;
 		faulted_in_anon_vma = false;
 	}
 
@@ -1940,6 +1953,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		return NULL;	/* should never get here */
 
 	vmg.pgoff = pgoff;
+	vmg.anon_pgoff = anon_pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
 	new_vma = vma_merge_copied_range(&vmg);
 
@@ -1961,7 +1975,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			 * safe. It is only safe to keep the vm_pgoff
 			 * linear if there are no pages mapped yet.
 			 */
-			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
+			VM_WARN_ON_ONCE_VMA(faulted_in_anon_vma, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
@@ -1970,7 +1984,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
 			goto out;
-		vma_set_range(new_vma, addr, addr + len, pgoff);
+		vma_set_range(new_vma, addr, addr + len, pgoff, anon_pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
@@ -2612,7 +2626,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	if (is_anon)
 		vma_set_anonymous(vma);
 
-	vma_set_range(vma, map->addr, map->end, map->pgoff);
+	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
 	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
 
@@ -2801,7 +2815,8 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	struct vm_area_struct *vma = NULL;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
-	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vma_flags, file);
+	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
+	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
 	struct vm_area_desc desc = {
 		.mm = mm,
 		.file = file,
@@ -2946,6 +2961,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
+	const pgoff_t pgoff = addr >> PAGE_SHIFT;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2970,7 +2986,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
 	if (vma && vma->vm_end == addr) {
-		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, PHYS_PFN(addr));
+		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, pgoff, pgoff);
 
 		vmg.prev = vma;
 		/* vmi is positioned at prev, which this mode expects. */
@@ -2990,7 +3006,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto unacct_fail;
 
 	vma_set_anonymous(vma);
-	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
+	vma_set_range(vma, addr, addr + len, pgoff, pgoff);
 	vma->flags = vma_flags;
 	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
 	vma_start_write(vma);
@@ -3382,6 +3398,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 		WARN_ON_ONCE(vma->anon_vma);
 		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
+	vma_set_anon_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 
 	if (vma_link(mm, vma)) {
 		if (vma_test(vma, VMA_ACCOUNT_BIT))
@@ -3437,7 +3454,7 @@ struct vm_area_struct *__install_special_mapping(
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
-	vma_set_range(vma, addr, addr + len, 0);
+	vma_set_range(vma, addr, addr + len, 0, addr >> PAGE_SHIFT);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
diff --git a/mm/vma.h b/mm/vma.h
index 54ed7c744e3b..024fabe63560 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -104,6 +104,7 @@ struct vma_merge_struct {
 	unsigned long start;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t anon_pgoff;
 
 	union {
 		/* Temporary while VMA flags are being converted. */
@@ -237,11 +238,6 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
-static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
-{
-	return vmg->pgoff;
-}
-
 static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
 {
 	const unsigned long size = vmg->end - vmg->start;
@@ -249,6 +245,11 @@ static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
 	return size >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->pgoff;
+}
+
 static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 {
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
@@ -283,6 +284,16 @@ static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	vma->vm_pgoff = pgoff;
 }
 
+static inline pgoff_t vmg_start_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->anon_pgoff;
+}
+
+static inline pgoff_t vmg_end_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg_start_anon_pgoff(vmg) + vmg_pages(vmg);
+}
+
 static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 {
 #ifdef CONFIG_64BIT
@@ -301,44 +312,48 @@ static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) + delta);
+	vma_set_anon_pgoff(vma, vma_start_anon_pgoff(vma) + delta);
 }
 
 static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
-}
+	vma_set_anon_pgoff(vma, vma_start_anon_pgoff(vma) - delta);
+}
+
+#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_, anon_pgoff_) \
+	struct vma_merge_struct name = {					  \
+		.mm = mm_,							  \
+		.vmi = vmi_,							  \
+		.start = start_,						  \
+		.end = end_,							  \
+		.vma_flags = vma_flags_,					  \
+		.pgoff = pgoff_,						  \
+		.anon_pgoff = anon_pgoff_,					  \
+		.state = VMA_MERGE_START,					  \
+	}
 
-#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
+#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)		\
 	struct vma_merge_struct name = {				\
-		.mm = mm_,						\
+		.mm = vma_->vm_mm,					\
 		.vmi = vmi_,						\
+		.prev = prev_,						\
+		.middle = vma_,						\
+		.next = NULL,						\
 		.start = start_,					\
 		.end = end_,						\
-		.vma_flags = vma_flags_,				\
-		.pgoff = pgoff_,					\
+		.vm_flags = vma_->vm_flags,				\
+		.pgoff = linear_page_index(vma_, start_),		\
+		.anon_pgoff = __linear_anon_page_index(vma_, start_),	\
+		.file = vma_->vm_file,					\
+		.anon_vma = vma_->anon_vma,				\
+		.policy = vma_policy(vma_),				\
+		.uffd_ctx = vma_->vm_userfaultfd_ctx,			\
+		.anon_name = anon_vma_name(vma_),			\
 		.state = VMA_MERGE_START,				\
 	}
 
-#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)	\
-	struct vma_merge_struct name = {			\
-		.mm = vma_->vm_mm,				\
-		.vmi = vmi_,					\
-		.prev = prev_,					\
-		.middle = vma_,					\
-		.next = NULL,					\
-		.start = start_,				\
-		.end = end_,					\
-		.vm_flags = vma_->vm_flags,			\
-		.pgoff = linear_page_index(vma_, start_),	\
-		.file = vma_->vm_file,				\
-		.anon_vma = vma_->anon_vma,			\
-		.policy = vma_policy(vma_),			\
-		.uffd_ctx = vma_->vm_userfaultfd_ctx,		\
-		.anon_name = anon_vma_name(vma_),		\
-		.state = VMA_MERGE_START,			\
-	}
-
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 void validate_mm(struct mm_struct *mm);
 #else
@@ -520,7 +535,7 @@ void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
 
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks);
+	pgoff_t anon_pgoff, bool *need_rmap_locks);
 
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma);
 
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 7af1260689b9..586c52155942 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -41,7 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	unsigned long new_end = old_end - shift;
 	VMA_ITERATOR(vmi, mm, new_start);
 	VMG_STATE(vmg, mm, &vmi, new_start, old_end, EMPTY_VMA_FLAGS,
-		  vma_start_pgoff(vma));
+		  vma_start_pgoff(vma), vma_start_anon_pgoff(vma));
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
index bea9ea6db02a..4a39c9d50489 100644
--- a/tools/testing/vma/shared.c
+++ b/tools/testing/vma/shared.c
@@ -23,7 +23,8 @@ struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 
 	vma->vm_start = start;
 	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
+	vma_set_anon_pgoff(vma, start >> PAGE_SHIFT);
 	vma->flags = vma_flags;
 	vma_assert_detached(vma);
 
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index e357accc8499..48418b82b01d 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -45,6 +45,7 @@ void vmg_set_range(struct vma_merge_struct *vmg, unsigned long start,
 	vmg->start = start;
 	vmg->end = end;
 	vmg->pgoff = pgoff;
+	vmg->anon_pgoff = start >> PAGE_SHIFT;
 	vmg->vma_flags = vma_flags;
 
 	vmg->just_expand = false;
@@ -108,6 +109,7 @@ static bool test_simple_merge(void)
 		.end = 0x2000,
 		.vma_flags = vma_flags,
 		.pgoff = 1,
+		.anon_pgoff = 1,
 	};
 
 	ASSERT_FALSE(attach_vma(&mm, vma_left));
@@ -1431,7 +1433,7 @@ static bool test_expand_only_mode(void)
 	struct mm_struct mm = {};
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vm_area_struct *vma_prev, *vma;
-	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5);
+	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5, 5);
 
 	/*
 	 * Place a VMA prior to the one we're expanding so we assert that we do
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 754a2da06321..7ca5289e0f95 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -38,7 +38,7 @@ static bool test_copy_vma(void)
 	/* Move backwards and do not merge. */
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, vma_flags);
-	vma_new = copy_vma(&vma, 0, 0x2000, 0, &need_locks);
+	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks);
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
@@ -51,7 +51,7 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, vma_flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, vma_flags);
-	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, &need_locks);
+	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks);
 	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 4f6c5666ac07..8a48b231aa7a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -53,6 +53,7 @@ typedef __bitwise unsigned int vm_fault_t;
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_ONCE_VMA(_expr, _vma) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))

-- 
2.55.0


