Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F86FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894736B00AE; Mon, 30 Mar 2026 06:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844AF6B00B1; Mon, 30 Mar 2026 06:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734116B00B2; Mon, 30 Mar 2026 06:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF7E6B00AE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 267B7BB47B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:57 +0000 (UTC)
X-FDA: 84602315994.19.D4E6F6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C9BB1A0005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hILcN0Xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYZjEoG0VIXFRWYqvsu2d7vVA6Pl9EnjVO6o6/KzmSE=;
	b=VZ8V/L0MDu2Fjq9aA3wJHPuq7MO2U7YKPussbeS8uokLZUrWLJIDf+I9ObLtkwAPmsRZes
	/830GZ4xlVZ5vAVRTamXVTTPH/8K/a2s0L0M5+VD8fW4wlUOHBcZao1Lw47zDXRx48dA2g
	yKyWnLIAP7EF4XK8T57EN3jtTBqtjHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865575; a=rsa-sha256;
	cv=none;
	b=XbBVzAyB795sCP9a9LuoRrX+vygIfxggaFEBJCW6TWagp6wlQClZJhQO6xfXcuaRMFBBdM
	NvSYWPd8wGKfWXgJl+N/YzwZKVhF0nyzi3WMwgDFXWW/rSGq9nsO7PPEn5/JR1G/onUXoS
	Yxh8caAfpfydgwdA902x84zTTiwzJqw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hILcN0Xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F7FA42ACB;
	Mon, 30 Mar 2026 10:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFAAC4CEF7;
	Mon, 30 Mar 2026 10:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865574;
	bh=sgqKlJf5BnGeophpkDo1XgppS/PlXJsOousdP1fvs+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hILcN0XeFbdlxHlruu2Besehj8PrHaiqK2pb5lcwSpeVPh4meHqmzavwE3/p7aJt0
	 MokaJ2fCycJrIYhZY6Ie+dyEedEdXN+hvlrNFeS2KLvGsYJitJY9EvJ2iZTQ3e+kKE
	 3wqe0tgp54GvzlHGrcrn8SGkf8ikX4AvblOSQiobkJ7Zg90ggh8y1BDJkqH/SkPRKn
	 3hV8fHIVNx7T2coeFmjILwXqtVcXJjiqjOwvLcCHlTsWdFbPL/0xNn1nrdV646OgkM
	 8U7MFS2K3y1tJH4yhnB3ILQUJjBvSqvGMhai2e8ofZhGWHI1RgRyDgbl0C0H1i+WpN
	 Xeyx6IIGE6ETQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 13/15] KVM: guest_memfd: implement userfaultfd operations
Date: Mon, 30 Mar 2026 13:11:14 +0300
Message-ID: <20260330101116.1117699-14-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C9BB1A0005
X-Stat-Signature: hy47yku9y8fehowmd6q6eewhfb7qpoea
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774865575-89212
X-HE-Meta: U2FsdGVkX18gBQYTabRkICVgSVIKTu6GBulyYcJm/Zx4KQ3qRuiNcoEUNw/KmkxzErd3N7Wj5VRRe+1nSdmaCkUDW9TsVMf1NnanAKzH+dJNvlON23HPo2YjGyp7z6gEA6XcFkOavL4FJegydjSjFgS+XQbApIsWE654gtgVjdCSr3h53RYTUaoR8Gba0G01OZ0H6LNR3Gc+3cVa+zb8/K+vBPcSX3J+7Tmttnh8n8VI9K7BOSKZzM8KdtNAOTZconMamQxBny2wDG/NZzJmkns5QjoUTR0JMvTa33hexgSXYihuij0/OlYnsNr9NfbIT/Ymo9CUg7IpZOUNf4rObPhx+n1bISMQA6dUCcMWKtv5Rg4x9Z0VfBD5SbC+CzxbwZOUI6G7HNL3IyAUs1ihqTU5LQlz/RfHalZzRwQL+E3q12Wwq/8iZguOM3jAZbkEYYrTPMtqabk4iNem7jdW1k0NvLKqjTQF2GCootN/KlN5rEDtwiFpRXGTf3Ya4E1C1dCqM0Ywpmzj5Bz+HbIPcyOiIu4EZdva7vszSQrt7MXqSLdaosNK0K5hJCUSNqDUDBJ382e6fa8fMUe930MA09ze569z2LYbdI28IAaX6n9qSmcSM8v1vo4i01iQUq5JPat8OEiBkCVBi9gdmTQ32/clPHyEhJNmltsdMOV6CQsMXCvvU5xVF8eNsM7b/6ZuT7PDI4iPGqs4ZDZMwhv/w4P4/OGuMtwaMlXpQY7aXm7+Cwu/miVfjbW0WRYDD5KzWdRyOEwV++FmpizV6NEUQr32JEqcs4obknszsf5BfnPudnvf777KMbeMY30NY+V1O7ZcrtMMIV+bzM5V9DEhy4TJljJOTOU3jJj5n/E670m/pZ+8BCEQu1z8bgHbEIGe5QeJ1F2y6Lyxj2w5qPYQxZNDtrS5HhXFHUp4SPqSX3q5zHPGxd9Xsjg1sTvCAViRCqkbe82TlQ9yXXOxmn5
 Mcgi+Nyy
 t3xK/iQvou3nFauNMCLuLsFVXXYIaalRj5TBkVP3l7K90wt96FH/6rv9xE2zncFME719qmjjhTbPK/3PjrK0TOqjg9/Wd22MNQhpxledxwRu9iJWUXISDvgV4AUxj7wdV/FqOOhOUB+EtQ2DjapxTkIkDp4tSoD6AOZxc8wJT0am68mlgigk0Znh58iauicX+AiI4xPgmMOSnLp5+HBHF2E8cIsTEn371GQvilDCTujuOVgeuc99Dj9EQ0hRIPa9dF8bpZDrwToukhp8piJ4eneB7sy0UpycQYv5FPERgqxIuNhAFdbJiGb/KYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

userfaultfd notifications about page faults used for live migration and
snapshotting of VMs.

MISSING mode allows post-copy live migration and MINOR mode allows
optimization for post-copy live migration for VMs backed with shared
hugetlbfs or tmpfs mappings as described in detail in commit 7677f7fd8be7
("userfaultfd: add minor fault registration mode").

To use the same mechanisms for VMs that use guest_memfd to map their
memory, guest_memfd should support userfaultfd operations.

Add implementation of vm_uffd_ops to guest_memfd.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/filemap.c           |  1 +
 virt/kvm/guest_memfd.c | 84 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b684..a91582293118 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -262,6 +262,7 @@ void filemap_remove_folio(struct folio *folio)
 
 	filemap_free_folio(mapping, folio);
 }
+EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
 
 /*
  * page_cache_delete_batch - delete several folios from page cache
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..46582feeed75 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,6 +7,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -107,6 +108,12 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
+static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
+	return __filemap_get_folio(inode->i_mapping, pgoff,
+				   FGP_LOCK | FGP_ACCESSED, 0);
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -126,8 +133,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = kvm_gmem_get_folio_noalloc(inode, index);
 	if (!IS_ERR(folio))
 		return folio;
 
@@ -457,12 +463,86 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 }
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_USERFAULTFD
+static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+
+	/*
+	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
+	 * This ensures the memory can be mapped to userspace.
+	 */
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return false;
+
+	return true;
+}
+
+static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
+					  unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	struct mempolicy *mpol;
+	struct folio *folio;
+	gfp_t gfp;
+
+	if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
+		return NULL;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+	mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
+	mpol = mpol ?: get_task_policy(current);
+	folio = filemap_alloc_folio(gfp, 0, mpol);
+	mpol_cond_put(mpol);
+
+	return folio;
+}
+
+static int kvm_gmem_filemap_add(struct folio *folio,
+				struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	int err;
+
+	__folio_set_locked(folio);
+	err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
+	if (err) {
+		folio_unlock(folio);
+		return err;
+	}
+
+	return 0;
+}
+
+static void kvm_gmem_filemap_remove(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	filemap_remove_folio(folio);
+	folio_unlock(folio);
+}
+
+static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
+	.can_userfault     = kvm_gmem_can_userfault,
+	.get_folio_noalloc = kvm_gmem_get_folio_noalloc,
+	.alloc_folio       = kvm_gmem_folio_alloc,
+	.filemap_add       = kvm_gmem_filemap_add,
+	.filemap_remove    = kvm_gmem_filemap_remove,
+};
+#endif /* CONFIG_USERFAULTFD */
+
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
 	.fault		= kvm_gmem_fault_user_mapping,
 #ifdef CONFIG_NUMA
 	.get_policy	= kvm_gmem_get_policy,
 	.set_policy	= kvm_gmem_set_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &kvm_gmem_uffd_ops,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.53.0


