Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C18606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=P/PjM8o5
Received: by kanga.kvack.org (Postfix)
	id 886B36B0981; Wed, 28 Oct 2026 00:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836C86B0983; Wed, 28 Oct 2026 00:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7744D6B0984; Wed, 28 Oct 2026 00:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 470896B0981
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:15:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75803160718
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:15:41 +0000 (UTC)
X-FDA: 85370721282.05.2E8867C
Received: from r3-11.sinamail.sina.com.cn (r3-11.sinamail.sina.com.cn [202.108.3.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 18AB940003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:15:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="P/PjM8o5";
	spf=pass (imf12.hostedemail.com: domain of eadavis@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=eadavis@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160939;
	b=Bbj7b2Mzl9DPaTr7YH25rT8UoBe1yjC78tpO4Oj/D1ua10YsiIV9tni8ulehBzd/7aMSTv
	+XEiWXI+wE0J81he+MTFGEwSct3+5lukV5YCN/uzeXs+jJtFCrqR/OUusK63FKOhZkO434
	3L/pA9Mt9395VKxAAi+2ReGv5SJ3VoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="P/PjM8o5";
	spf=pass (imf12.hostedemail.com: domain of eadavis@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=eadavis@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R29Lmn/UagSEpWGDP6TbuQgnJJqgxSk4PMDLCqmZ/bA=;
	b=QANzhRXWqdD+tvWX3RpWo7+ySS7WmjBc+2gE5Gap6/L+GQyetMyT4C2GrW5rSE2LemhXvt
	34/rG1G6/M8V4aCMVHJdRNKWG6Qc8mJLMMKh6XTgQKKhD4AKz7NmsjmNWav2koP8eQ0lYs
	xho6tVcR0EhXumGzfhcr+DvYa3Q39Is=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1793160937;
	bh=R29Lmn/UagSEpWGDP6TbuQgnJJqgxSk4PMDLCqmZ/bA=;
	h=From:Subject:Date:Message-ID;
	b=P/PjM8o5qvXus9LYbZluIhnw4nNxEEN1UkHdMS4IzciVhF3FQ8I98WATVlqNN3/yC
	 d5VByH9S8kEN5WWAZvqKXE7w7AiQNTqkaBm8yjQeOVi+E8MA+PTKMsCF0wadVARKjN
	 o/ETyPyK8LR6jdsBo8BziLp5KyBEDrGkSRCifQW4=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.34) with ESMTP
	id 6AE176E000005C67; Wed, 28 Oct 2026 12:15:31 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
X-SMAIL-MID: 1774476291735
X-SMAIL-UIID: C0FE910BFAFE4337B2FCA160B658716D-20261028-121531-1
From: Edward Adam Davis <eadavis@sina.com>
To: syzbot+2fcec0eca7f4cade53b2@syzkaller.appspotmail.com
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	mike.kravetz@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] hugetlb: supports unmapping private mappings
Date: Wed, 28 Oct 2026 12:15:28 +0800
Message-ID: <20261028041528.269829-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6adf3170.a6443767.132891.0077.GAE@google.com>
References: <6adf3170.a6443767.132891.0077.GAE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdmk37x9wgk5rd38pzcajktzhar59erp
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18AB940003
X-Rspam-User: 
X-HE-Tag: 1793160936-982831
X-HE-Meta: U2FsdGVkX19+x0+4ZzZ8ARqr+Kh5qqLbuA8H+YEKK/p9T7Uimyd66DXzn0hpM1YPQRDbSHySKbyiBxyZfQEP9smcYesN2c6CBNiK1P34j70lduffuYe4ShO6DjnKI5tRSPtw4Kb2aRRDDqsuNU+lxqma3olRdKBadaCAJJNDRJ2jUmLFG54vpjAWnulDVMuRf5ESNEtaisozLPGfJb5DER839zgJtBZ3NpwlAUA4XtHbaXyfm/JG2CKnOF6D8JFyOsT17MtgG8Y6dwExgcrZ2lqLXSHJXriaMep7FkjqyOnXbX0U2BFfeg0tOwO5NHLCdTH1Ccwpx6HZCSjN4pOPyoYypTbqWah/jiJbSNBfFKiZUIl24wPcYTi7IQ3dvlVl/7fPYDDwp1gD0L9hSfB7ctaxS5PrjI0WMzVDChTmAasGqyIr2tQHnv0saq88Hy0NfnVxNJFJ+AZsM99QjM6Kj9Qgi/eAPPRUsFHLVOKFftdnLeElLOtK4fqZu3aUp4XbkmqIvTJR4jSOT5bJ9545xHxFSW3OWFMh/gNxLb/AgttYZys2WjFvvG9Nsg19Ef++Ri98xLO62exxxk2BGpcvj1uS606SCtDDiaue3uR8yEad9jTC78Lcv6Zxp/YcVYdjXX6MX3tUNr4FKb1QaDxpmodWWxCgeGuhmYK+D0+5vRXtzMyI++5T4N35v9bZ4M1zj0LW4i2aw9L4vM7V1fOKOn2ZbmJJaZnoZEcKyNsb9oFZ02ax2A+QURFmD5OsOHF5DrI3M3BOsfe2oZY0S8abIFkuaaUPCKEqo9VBE/VG8tg88zSC4l+s72ZCGBKxm2sGF3wXpfHFyTGF4D/ZbGUKaa4bcdDxye4MNuHzyfYkhmagEy0+9TyxqKlj+AyofoZubQzKYAEgR5QtZTwGg9zhSl7RLohNJWc2HAPz3MdP0zsXzDLBCe+z8GrEiauyug3RnUHIzN6Pt4ia/rc8/5Q
 q8QAKCZr
 e4pOAcswHj8AH7SyrIlHtYf8htzx1MyFnhsjBD7EK2xOOx7VglSKUv3hQiHyemolxVWME973S/Bh2JTu3E9FtgCMGf4sCgFomvPhQOnglkt7upiTWJt0lk8UreeaAOICHE/fQjgiWjd9w6y/cn/QgC6XrqVR4KD3PNe1D30iGSfblY1RzagEuRKvJoczYrIb8exGqnQ6tSTBPIPs1lVR/8r7O6vSh/uMN3fCJ2BXp4XimVm3Ccv52YM1cK/oeG98v+u07D+HIFpzXM4PontE1pZ3SeO3Ke+CZfbodp7Rav4M2HjDIkfL7nKoPEGvytwbaFFq2ExW+9M4OYSYLitz2pQma2u2GwwK7Gns9pNDMuXlMUnxlOR5Kf6u8cvc+JpjJIIwrM7FRxvyAFIXyjT4Uh5j0iFg/HaGkaBcdbxSb2KNqRvknVDwIGpblQuQvckP/CUQxeOl8NSVPVmA/QYnt3C5R25XfFn2+2knB8IiRh2TJMfBr3AM8r6dG7JHki7pZ2a8YG3CtcxV8KnrFli93WWuWNt8szfyS6j76u9D1qCvu0Vl4nUCKMjlAQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
@@ -134,7 +134,6 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
-static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -1145,7 +1144,7 @@ static inline struct resv_map *inode_resv_map(struct inode *inode)
 	return HUGETLBFS_I(inode)->resv_map;
 }
 
-static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
+struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 	if (vma->vm_flags & VM_MAYSHARE) {
-- 
2.43.0


