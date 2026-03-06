Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3513EFCC046
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1126B00BF; Fri,  6 Mar 2026 12:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8F56B00C1; Fri,  6 Mar 2026 12:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7C16B00C2; Fri,  6 Mar 2026 12:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7989B6B00BF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 041821A06A4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:49 +0000 (UTC)
X-FDA: 84516300540.18.534C798
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DF161C0019
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcaj1Lxw;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Fu4LHtuXEozQWNRfj8Wf62P5fLeynQ2j0vtWcss5LI=;
	b=p7d+vlN3EfLmRhwLq0kK9xe7LJHzS9z94SJAyTHGVTkdHEiOUkBWMBFCqnK0WZaObKOjZq
	C+sxJ1SuRB34GUhYzCZYKr/rlAL8grpidCRC8w0k0G1/9oUAKnaOgqEixmBqWHzXNuGiEJ
	QN+00O/8W45Cr6aa3iU36256WIUh0xQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcaj1Lxw;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817588; a=rsa-sha256;
	cv=none;
	b=QkdIJyDxsxMAfpftC8WAsAL29h+jALoMExP8RCDgCI03jDwkmNF46RAMGVfn6Q0i3sOMcV
	ygPkEOdkqniGvfCzVDH07ZKTJiWQaB+G0WrUPWnSQGlX7/pX9w7LgnYxXOQ8hbuUbUaD2x
	7iFseWDLFe+QcKtPtK03F96hiiCa1Hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B68A4165B;
	Fri,  6 Mar 2026 17:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA70C4CEF7;
	Fri,  6 Mar 2026 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817587;
	bh=4hcRW7GlxXluQlc26C/qvdD+bZFAR7n0L5fkslie5bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcaj1LxwcAYPRChevInQFpSIb2L6pDg0SXrwiAE+sU2PCjvTh0wAkWwxQ869+qJMA
	 K2AIVQWZB5co/YkXsN7BNFxZ7eDNEiXmWiW8pvh+quysUsbj8Ew0jj0rl5073qB4v4
	 htHDVj+bdVKUbmiVuBR/iUb1fqIbQNiWg4UBi9Jf99RKFM7Oz7FqaV4F1kg6HjRw++
	 ZVT9cwAT7sxnOfm1jOg7JJrjYZW2Ilng+T3NLQHZbnPTKiaqyxK+pC6KFROiRk8p5C
	 kEsB9gASp2XlJCZfutHB5hqxaxiNcmdX6eHMsSJtmZnL2T3yfESGTPRHbNdxdm61Z6
	 teCAKrn8yeJQQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 13/15] KVM: guest_memfd: implement userfaultfd operations
Date: Fri,  6 Mar 2026 19:18:13 +0200
Message-ID: <20260306171815.3160826-14-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF161C0019
X-Rspamd-Server: rspam08
X-Stat-Signature: mwritjcqrkkpeg9eemzgxq9az4siod14
X-HE-Tag: 1772817587-600192
X-HE-Meta: U2FsdGVkX18gGO98PRWoZGrGG7e4IornuB7BI/tZIkGn4mWlweH2yd0yAw5/ST9LMgHa54HmukuIj+ePYibI6uNE1P7ui4iIaS5RYtCk/8HlmcMIQhBSLAYxnw8e/2HcXwN2gsLZV0n1Vnk2z78GraH8+NjT7xNj6EoM1LVmJv21RtpDiwxnM2XIy/S0k3Y74QHNUMM9riSuNN+7Re0nJI8MZb8EiScrcQXFs6riCpKnx6jdFj+KLZXaPiBi9+5puxsModI7JcCOk/P7yROWryXt975vyjD0fbZP6i3Vi/FcIZTdp0jEdtHWecrDB1usitINhWINXfqzYE+hZm5ncO7fO5LdfDiIBEvb98dVFXy8FBAcb2nA2DoWuG9JMCzU2DddwvrRZ4wcQGUGgmpAF0GhwowkxrLBzL+1QXAbScdS9sVd5AhkNRjid/xkzA43wVtcmyxjJxJkei0WE9UKlzaPzz4M5YLoGzJyq6Os5IfMW9q0t9ewwW+5bDF4OUbzEgZuUZkglfqLjScOz+SJiCo+FVYRNQQKo4f3BnwhqgJ4/IVOARdQIE9rtAbaExihoveNBXSqh8hl6B+S3Hoarv/dly1YV8wjvmTiHNk+rM7/PUUPH1tZ5QNYkuKP8sqtcpZQ6FRLM4xq2rBQcIVg5RJadGvVQfClKHKmFW8EuphZ91JNLwB2IrFHMAkomrhLlXIF55IhhXF6z8cSXrbxF/cvZlqb9yeVBHo1HhWjC/a/7ymedwRUV/CX1vCNalX9wbmFtU+/IC+tt9LImvOLv1j5Ku3NUMk5v1JTe/Qd823V62OAEoic4wcZmP3zFDVDBRgy79JSh80L0V9djHFB3NDolLqydrKngVFbB2giaIxUDLZg322/N63sZVEo0fcG8L/6PcjR9IgBRjq3yhyhQ2r/cLA9xm6URVs6pMyCN1P/EwUettfBDRx6dphcGJJMdyMmxyRPsDhWL1037G6
 1j+ZJBkE
 f6g2h/PUIS9LZi3Qom3+rokTsYQLMYdgcD07jq72CVETYY9SOYboXYo7lHEVHmGLCHIiEcQfa/4Yy5UARwAzAmZXkfeNo9fHC0cEaf3/64QYdec4z/dlEzfoCqwPod514LKVMrRlnVyn5vef8vqxY96xS85sUBjI86D4dGDhUNWd/i+S43/HXBGkHDjw7qYsQbOJtJz7pvelddIoT9HpW0TECHAPxlvjrCsAxSuQInXZGRVn2/evfjuIHfujRvrmOf6dxuOhfdMnpmFEJ1IO+BmZALG5mCm1jJ0X4BXUJX+1NiVH3c7FGRtjdbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

userfaultfd notifications about page faults used for live migration
and snapshotting of VMs.

MISSING mode allows post-copy live migration and MINOR mode allows
optimization for post-copy live migration for VMs backed with shared
hugetlbfs or tmpfs mappings as described in detail in commit
7677f7fd8be7 ("userfaultfd: add minor fault registration mode").

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
index 6cd7974d4ada..19dfcebcd23f 100644
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
2.51.0


