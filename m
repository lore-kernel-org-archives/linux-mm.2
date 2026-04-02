Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F686CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8CB6B00A9; Thu,  2 Apr 2026 00:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD02C6B00AB; Thu,  2 Apr 2026 00:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CF86B00AC; Thu,  2 Apr 2026 00:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2A3B6B00A9
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FD3658A73
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:37 +0000 (UTC)
X-FDA: 84612296874.01.EF05E10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6756C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvr2rNwH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103215; a=rsa-sha256;
	cv=none;
	b=acVBh+8lqd7wqGjRemIHlizHjw6G6rhwbS6I9NULIjKJ0IBh1GnAdfJnAqbPMAoz9fc/+5
	nKFYKPfdmdx4j7obpnhHXP3nbfTeZFv0gGAzUutmXmT19MN5ZI8f+Oxjaaq6p5PGGHSNy0
	t0+k7eOvfn/cb3t6OJRdBRfTi7GBiaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYZjEoG0VIXFRWYqvsu2d7vVA6Pl9EnjVO6o6/KzmSE=;
	b=d/S6t7ub7C6S8yztK86zEsBPzFEskLrs13XHoonbp5NOGF0Je7VNBjAhjg8jkSo3KaIG9j
	qY6D+RS7wmyapJTPo4Q/87rNCoy2zzI9nD6vfCUdPqy1pyEvisK3SnQHXov5nH4JNH3XXO
	tXxVtAFuPo73B0PQEGPSt+XlXimes7g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvr2rNwH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 372A061863;
	Thu,  2 Apr 2026 04:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A146DC19423;
	Thu,  2 Apr 2026 04:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103214;
	bh=sgqKlJf5BnGeophpkDo1XgppS/PlXJsOousdP1fvs+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvr2rNwH7jcgFyeELsMcovv2IN7DOgkkZipn+nmUsdhDY8PGn9xg1V65Cd3eDNjZC
	 yOfZo/FK5gNWjQOK3u/HyexXHHp+mGdIFZWjBYTU9DXbCPtneQww1q9LO2qSKMONAc
	 HKUotWOVqa3AjwFO9AHUHNX/Bhqo9JEmAz3n62YCJhKY/kf6nbNnCwyLVIE6y4DNzb
	 HQJK1LPHwqAN24jZAvyWUAZ8uftcU284unGBT8/FPvV0yKxMy2YxeE9/lf2hX0K61y
	 A2GiIRSfzoqJ2ODQtJr4M4/XVfD1KOD7mNJd1dtsWRQRW0UzuhdBcmuNMcXOvOVcUx
	 NR/HodG4P84ng==
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
Subject: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd operations
Date: Thu,  2 Apr 2026 07:11:54 +0300
Message-ID: <20260402041156.1377214-14-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6756C0005
X-Stat-Signature: ohrekrtn1dzx8nhmqpaxmeeznz9p9yj7
X-HE-Tag: 1775103215-731895
X-HE-Meta: U2FsdGVkX19nQKl5DXeaBoSOuRWvVf6jx3zs9KMFHWxMMQ9KsB4affeKPPF3VnChv8T1XBV0GRlvazXmSR5OlhMBkMclgRfPyuVUrBAJbH1mCcEiyBidCTdoU3WRkQIaUi7Q7pn5meGQgvGEOb4ozfacJ+qBo0DKDkZhjIPW+5b0paw4xD3ob2B1Iye4CW11Tr7jjRPPaxxDIGT4bNnLa1gqdodb2838/Zl3HDbe4LbinLjbu+sQHWgTU761dZPt/N1UN2GGaXNTKAjAJFG6c1famqEGhutiUxIRAOMNsAZdE5vyhqEU//9Jl7sazecK5izGdAC1Gc+CSVUu1rbr//osFGtXM6RYv9xL5CXkQWB1ommghQ/4ifTWMHQ725DF7zLLqP9mGBGWcTwcHN81zXOjWb72N5WVHeDA6yMkifvAJ4vFehDXOGK5LhyVxaipNxtko8AIngyBwN7/2jCe/tbNbHvJch4WYIlwurQuhdKiLc37tzwn8S3TZehMqTRegEC+BYwT7PqBoBQfUlRZ1XCkYEXNqa83IylnlaYkI9lhvPd+Eiyj5D+F10970YW+i0SH6UK0lnnjoebm5M5bixTBGG5Z/T+qdt7783k/uHTme3Sc0SyMgJLIENJlIk8QGhAXLasaiVRZCWeqy33XIVT2LeNHE7mjCSarB/Kp8SqqlqN34ImNYmEngDfA9r7BOdyDd7Qst3+kGxR1ISBdSuSNYuSIAtAZJWBBxzJVYgRw19XJhdDsGC5DbKCHejhsIReQO39fGx4PgEwlrTVH6ejabL6MTCOmNPOhHZWGXEAViCkT5i3kjRliF/qsXFFD6cXEczOo2cZBqKffIOXmOwH9gpbvZ+1iWrekcZN+yHRaQrvkAKjH2H3oWjFdz0Y3NddVIzDLy8t10rohtdge6hogJ0uQOaUcsoZTiMuYZhEkYjf2opPn0a9JWZ9GsT8H7x1e7/sYr7ckJSP+cc5
 d1eb4tFU
 yJeNIs5sPllbZZuFpqjsx2g8W1Qa7S6MJxGfcaC25AhR7UnghJ7rSw4oBXThZxFevBd+2N9iAf0YF+1wzuZlJQktk1bXiJq+BpNqN7meveLz45C8V+fanPYH1IjS3MQwzj+A8s17OJ+CxhhQPAbFIF+1cGChccaHDN9+FoTppDuRyAPWpLeiVMfS4UMZ1gq2eljlQOAc+Sss+jWf9q1HtmS7fe/fPbabdIPwEG0Lnwbrn0wKfigF4rAvWg17TUqPqrwNEqzU6hwDCsFOI/s8aofqdHcJksF0YiFCtKzfEFLIxwtU=
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


