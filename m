Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152EA606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=NH2ndMX+
Received: by kanga.kvack.org (Postfix)
	id 00C596B05B0; Wed, 28 Oct 2026 01:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEAD6B05B1; Wed, 28 Oct 2026 01:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E155D6B05B2; Wed, 28 Oct 2026 01:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8E996B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:46:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B768280BBE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:46:34 +0000 (UTC)
X-FDA: 85370950308.24.9857C49
Received: from smtp153-162.sina.com.cn (smtp153-162.sina.com.cn [61.135.153.162])
	by imf11.hostedemail.com (Postfix) with ESMTP id E0BF040002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:46:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=NH2ndMX+;
	spf=pass (imf11.hostedemail.com: domain of eadavis@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=eadavis@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793166393;
	b=z+scoSECKAVTrhM0Va1yJ1Z/rmltE8RgCEs74Q1+Ub+yrXu95+gD2yLxRv6n7rkU9AWJOy
	c3pcVNJQoXGO2yHVXX8x4wpBxQOHb3nggaGphOt819Lwdx9UWocH7gfsXo9eN7Vw0aNvLB
	dAc0pn4s41HpXp/ztuSq510ki6wnBjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=NH2ndMX+;
	spf=pass (imf11.hostedemail.com: domain of eadavis@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=eadavis@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793166393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+BaKEUN1A0iZR51djdZ0NKvp4yNM6gbcP6zCVtqwiII=;
	b=eCi3oFOwa538cks8yT3Q4KhyPhgwiUVkiw7DCCAQHZSVLLqG/37EioElQJZqXmtrP1OKFL
	IeWZ1bbN/TBttb+88qJ5fjg9C82VBab1k7TxlRrindv0cQW46f12R3P4er/CEY6NJ2bEIH
	SVB/5mafMzD34UfXAj1zFJMHVNKJ5yY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1793166389;
	bh=+BaKEUN1A0iZR51djdZ0NKvp4yNM6gbcP6zCVtqwiII=;
	h=From:Subject:Date:Message-ID;
	b=NH2ndMX+sEl6crSTSd++A1zY8Uhk9ZDM49bshf8PTmPb69KG7OqfagPGf/13ZLNEP
	 8G45gzAXE39+KKUtrX4WARd9B8tSEDEEqcXLUhC3y8yn/A9qGST1ik2WOW/BmjzVRG
	 2noPXlEPv24v8WvWSjolWReXguCe+QigdYCix3bU=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.31) with ESMTP
	id 6AE18C2C00006D9F; Wed, 28 Oct 2026 13:46:22 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
X-SMAIL-MID: 7929796816419
X-SMAIL-UIID: 45F833F63E794FFCBC5CB29638C4D504-20261028-134622-1
From: Edward Adam Davis <eadavis@sina.com>
To: linux-mm@kvack.org
Subject: [PATCH for Sashiko] hugetlb: supports unmapping private mappings
Date: Wed, 28 Oct 2026 13:46:20 +0800
Message-ID: <20261028054620.275525-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E0BF040002
X-Stat-Signature: y4m1xxmrupqthccfymhzptuf5nddxjhs
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793166388-235994
X-HE-Meta: U2FsdGVkX1+Q1cer78YwHNAJ3umVuKBdKiOSqM8VSX8cRDJplIV4wE4sDywNIoEDXpc3MF5Z6Y6ctHtZZnn7ecq5iAndyY2Pbw8tHgdsDVgjrpobN5ierq/6+4ffw1yUada8iKNRFQ86m9zJO3bvoIihN407YsVy21ghKWRleSRH51AlVpVneoLnQvUWPxS9DjzNNUzbWfdUrGCZOOsuEveIvuMJDPH7e2E5BZ7Zh8/TPMRUlAdMF/rNVAuw5dPp0t2TJfOoG89PWzoSn6ri9BYjm//wU+dmarZCUuKmeV/XRiraWsT68W7US2r/K/2SJ+z4hBsuI9AM91kcESrsZRRa3/er4wJ6YTAC8GajvXLutsct/rxwqAsg/PZy70WiXk07LMF415xIHnBJsUDGtr3RZ2w4uWxiWC45DbtaYKVA2/GgFIlFzzwXUhpdGZ39DATXfNyLzyhwYJznWhb4t4kXF4BCgOoeKVt/TBj7ab1a4guS0bdPfrG7rgmLnOVS1LlmanH85H2QkgkKZw4wB9eHOlU+0KPSC7kdUoyvC4/1WkMK9v1pPx1AGeEypkZ9rok2EV1U5S+CI4paoijQDEB6rHu52Cak/dkwGQxFhG7VrtfJywt4v31mAvGR+ZLNG20gZ5ZkRp3lSDsKZl0C15QiNshdE/MVJwXK+KbMV96i5XHQILSn6JY5P1+nx2XMy8MLdGduZyuM+3zszRv0SwcGPASLijM+DlasMw9PhDIyrncxAnsRNfshpo0Pw4rPgDHr4LYgDZRak0DDjGg/0Mx2LpFlXjLr0oexlIjVEV8gKaqt3JCLRdUgJsKrOHYwkb5DdbkBP9mUSaAC23j3HsHPGM1FAOsH6YzwplRKE7wYYbOLdk7l0bLjye7anhPal84NaqTjzGq8pfIuw3XgZZGejWp4SlwWvGhsBH1IZo8xxAId8Q1Cff5eSYxXtNSKju59biUVHeNu9SXE3Mu
 H9CpHZ07
 cuJEI/ojVRuefp4e0hfVEqxbj8nPfqdg3rAG3bWVpamjqIjykHgspgfiU3wvyqONrNsURBowYytk2i0XIFgLIwGRMj0mw0R8vDNOKNZJIbl3W5K6WlBhmXMI9sYU4sHOtTZSDl/FsthtwSR6ox75Z391l8DgteoBmdcDTPz/ehXMJMBvgYSoKb7tSE1xBl8V4cg4PI5FHG2hBm3i+NFrLLuJAMq5dYYgrYdQqEpThcS7akwDxTLKGYe77eqoJjFlirDb5bgtWU97Y31wRf3C5zpqBDpT7zmn0CqQyK+IBCBlZUOrI+zKgSh4Udal49NNb42BSsUE+wyOperfT3g92SBuZ8SxEcOlpTKoVGJSzv3i5S+R6N+Y9gqYJKOXXehYBHqYxQASKbOeLdLu5apTKXzjIg678fgOzDV2ZjIZe7FvuA4p9gUpqmQ7qs2cz/qsotOKf2fTEd3cX3Ak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Note!
This patch only for Sashiko.

If a file has a private mapping, then truncating the file's original logic
will only unmap it according to the shared mapping method, potentially
hitting:

refcount_t: addition on 0; use-after-free.
kernel BUG at lib/refcount.c:34!
RIP: 0010:refcount_warn_saturate+0xf0/0x110 lib/refcount.c:34
Call Trace:
 kref_get include/linux/kref.h:45 [inline]
 hugetlb_unmap_file_folio fs/hugetlbfs/inode.c:413 [inline]
 remove_inode_single_folio fs/hugetlbfs/inode.c:512 [inline]
 remove_inode_hugepages+0xbdb/0x10f0 fs/hugetlbfs/inode.c:577
 hugetlb_vmtruncate fs/hugetlbfs/inode.c:621 [inline]
 hugetlbfs_setattr+0x4f0/0x6d0 fs/hugetlbfs/inode.c:856
 notify_change+0xbb8/0xec0 fs/attr.c:556
 do_truncate+0x1c2/0x250 fs/open.c:68

Add logic to handle the unmapping of private mappings.

Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Reported-by: syzbot+2fcec0eca7f4cade53b2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2fcec0eca7f4cade53b2
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
---
 fs/hugetlbfs/inode.c    | 58 +++++++++++++++++++++++++----------------
 include/linux/hugetlb.h |  6 +++++
 mm/hugetlb.c            |  3 +--
 3 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6656807ce437..166183b7ee36 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -382,6 +382,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 					struct folio *folio, pgoff_t index)
 {
 	struct hugetlb_vma_lock *vma_lock;
+	struct resv_map *resv_map;
 	unsigned long pfn = folio_pfn(folio);
 	struct vm_area_struct *vma;
 	unsigned long v_start;
@@ -394,6 +395,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 	i_mmap_lock_write(mapping);
 retry:
 	vma_lock = NULL;
+	resv_map = NULL;
 	mapping_rmap_tree_foreach(vma, mapping, start, end - 1) {
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
@@ -402,15 +404,21 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 			continue;
 
 		if (!hugetlb_vma_trylock_write(vma)) {
-			vma_lock = vma->vm_private_data;
-			/*
-			 * If we can not get vma lock, we need to drop
-			 * immap_sema and take locks in order.  First,
-			 * take a ref on the vma_lock structure so that
-			 * we can be guaranteed it will not go away when
-			 * dropping immap_sema.
-			 */
-			kref_get(&vma_lock->refs);
+			if (vma->vm_flags & VM_MAYSHARE) {
+				vma_lock = vma->vm_private_data;
+				/*
+				 * If we can not get vma lock, we need to drop
+				 * immap_sema and take locks in order.  First,
+				 * take a ref on the vma_lock structure so that
+				 * we can be guaranteed it will not go away when
+				 * dropping immap_sema.
+				 */
+				kref_get(&vma_lock->refs);
+			} else {
+				resv_map = vma_resv_map(vma);
+				kref_get(&resv_map->refs);
+			}
+
 			break;
 		}
 
@@ -421,25 +429,28 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 
 	i_mmap_unlock_write(mapping);
 
-	if (vma_lock) {
+	if (vma_lock || resv_map) {
 		/*
 		 * Wait on vma_lock.  We know it is still valid as we have
 		 * a reference.  We must 'open code' vma locking as we do
 		 * not know if vma_lock is still attached to vma.
 		 */
-		down_write(&vma_lock->rw_sema);
+		hugetlb_vma_lock_write(vma);
 		i_mmap_lock_write(mapping);
 
-		vma = vma_lock->vma;
-		if (!vma) {
-			/*
-			 * If lock is no longer attached to vma, then just
-			 * unlock, drop our reference and retry looking for
-			 * other vmas.
-			 */
-			up_write(&vma_lock->rw_sema);
-			kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
-			goto retry;
+		if (vma_lock) {
+			vma = vma_lock->vma;
+			if (!vma) {
+				/*
+				 * If lock is no longer attached to vma, then
+				 * just unlock, drop our reference and retry
+				 * looking for other vmas.
+				 */
+				up_write(&vma_lock->rw_sema);
+				kref_put(&vma_lock->refs,
+					 hugetlb_vma_lock_release);
+				goto retry;
+			}
 		}
 
 		/*
@@ -452,7 +463,10 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 			unmap_hugepage_range(vma, v_start, v_end, NULL,
 					     ZAP_FLAG_DROP_MARKER);
 
-		kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+		if (vma_lock)
+			kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+		else
+			kref_put(&resv_map->refs, resv_map_release);
 		hugetlb_vma_unlock_write(vma);
 
 		goto retry;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..f980191c651b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -268,6 +268,7 @@ void hugetlb_vma_unlock_read(struct vm_area_struct *vma);
 void hugetlb_vma_lock_write(struct vm_area_struct *vma);
 void hugetlb_vma_unlock_write(struct vm_area_struct *vma);
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma);
+struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma);
 void hugetlb_vma_lock_release(struct kref *kref);
 long hugetlb_change_protection(struct vm_area_struct *vma,
@@ -392,6 +393,11 @@ static inline int is_hugepage_only_range(struct mm_struct *mm,
 	return 0;
 }
 
+static inline struct resv_map *vma_resv_map(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+
 #ifdef CONFIG_USERFAULTFD
 static inline int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 					   struct vm_area_struct *dst_vma,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b017ae1dfd6f..def6aebc44fd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -141,7 +141,6 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, unsigned long start,
 				unsigned long end, struct folio *folio,
 				zap_flags_t zap_flags);
-static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -1152,7 +1152,7 @@ static inline struct resv_map *inode_resv_map(struct inode *inode)
 	return HUGETLBFS_I(inode)->resv_map;
 }
 
-static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
+struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
 	VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
 	if (vma->vm_flags & VM_MAYSHARE) {
-- 
2.43.0


