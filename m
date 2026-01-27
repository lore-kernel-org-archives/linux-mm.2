Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1981D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7086B00AB; Tue, 27 Jan 2026 14:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58ACB6B00AD; Tue, 27 Jan 2026 14:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7AB6B00AE; Tue, 27 Jan 2026 14:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B7A6B00AB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6237D3524
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:17 +0000 (UTC)
X-FDA: 84378737394.06.C8A98FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 393AC1C000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aL8Ud7ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfGHcYnJJb4JzbCV6G7AlGGM9xhxCvWSHXTUiog57Ug=;
	b=coX8XCLGSLuanqKNxW5jRHRNBT+BUxPYVJpkhBz8gHl4/2IgW/nzVqSQZoDpcpne3EhfyS
	8kvdU/vXcxzbyHz+17twMo1NreKvW3WSofkmaOP2Rp6lUMAj25g7iBG2KDO/q2Vgfuqoe8
	HiRUH9VR7DQvLh7MVNEAwJzaWdbS1aA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542276; a=rsa-sha256;
	cv=none;
	b=r9x3UnrPUMaI1odVm/7R7r8YnZkOi7tP1pZmHS0naF8h7lDZ4wacLA057ycnnUNe43jF1o
	806e4XXvowHF1YliXDRUMicm7LhWtxjiD+nuK3t0//wQ+D9Sed0T11weIIaoxYpUO5qtrN
	y5HaMMs0HNSjiiqtPitsuU4JFJkdmHQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aL8Ud7ZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5236601FC;
	Tue, 27 Jan 2026 19:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13DFC19425;
	Tue, 27 Jan 2026 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542275;
	bh=mw7CGKFvx9FMe3BW36n9yIoK6eLgZ7r0YBQzEf/E1b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL8Ud7ZHfQ4ni3W9TzUjcO4neGENPtoWsNsKBI7VRTQuCI23PUjuSBLAZ1aN1GyaB
	 vFN7k/Vu9D2wGsSu8iQWIGu2ynUywvwZFTHrPKEAjb3d/c0voxyjrRPlwDWRKHN2yJ
	 q/nh3xFx76c2uTqJYr3FUFEnTkXgqPngXmCl2odtLwn0tntuQy9klzz3kcXtDXEnFt
	 752XLRVFkzKgxxE2Gjwi+WxKUqKgsUihtNV9KgWPbUFok1BDtVxsYfgH+MAQgTu2BA
	 Ye9tzP0J8YOhcuP03PhQP4JI42fQP5Zyv+8lZy9B9agBHAOs0e++FT3hToTRTMprNI
	 WwiZAnbQka6Lg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 14/17] KVM: guest_memfd: implement userfaultfd minor mode
Date: Tue, 27 Jan 2026 21:29:33 +0200
Message-ID: <20260127192936.1250096-15-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 393AC1C000F
X-Stat-Signature: hceod4f7ijkutm677snpqrg7s3isyzc4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769542276-635011
X-HE-Meta: U2FsdGVkX1/R4QL7MzcxLuJcFdiXDa9/fn20jPeQuUB+cwzzGldUA0qSkGyd0ENpGQ8WNI0VEJoMjbxkOhrN5w171TLX6W02q634w3MyV5/rLUNs+0e0TwL0Gibsau8lp8EXmkDrPbWTwoXGtItlSAFXMHbMob7w8+EeNFnPG+hoE2rgu+thpSAal1MV88j6XxCmi32Fr/NU1PQi3SFobybzbJtAYVHLcFnTyV0ENrMoEBoTktfuNgSFrLrQ8+0vJRmquZR6FSEV+9sdSW2cJtT5eTACKNNLpS117j34gX2pG5AXQcRrs7gKFnIBelwiPrPS1nIuw74ldDC/h/yVRouAfoz+zIlKnBGZlE1dbo4giP3uEOQxTXbJGQQESw7nFY8UaUnyAja70iiVE5MocCriwMoIn3TUdUh71D1qpv91O8a03y9MMJjZj9QP+bxU/wofAlkci7P6eW8GVhENtVMI5wTMz/czcanpXK0z0OU2zzyDD/5TcDxFAqmhser76XWeEzRxMTdEtetUXQFHaFD0aBNHfo22nJdwtky5Z6yhx98PL/w4hQOtZvyaGgFlg+iPPkQ73+tDblolPkbDQ+zmoq7Dpgz3zYMAIq/+3Wpu5rJaLDbmjMoHLO78euX8UnKH83HTBQPc4thB9qZBYguoulOVlzz8KBr/z+rmW56LmpSnzIz2oEA0cPvHJ/eTv58l4DcqpzKb9JAKFxuWDlDcS8odNK0q19bYujtASPuGWu8/iFw9uNpZ9dGmurCgVq7VUd5cS41Pr9rc8SSkXHs0nw4WgrDC9r83lUQYX+/xPNfDzdQ8/6ndbMZTAubZAqkDzD9N3TBc57Si7uqNnVikH1cWR3do+AFPvAMyq8ao9F4Odgpqact0DdDYcwJn1JIOW/1aK8Of60wRGPzBVGJECNO+dlrD6XxnrXIAOd3FtyykRa+A7X7yUiYQPWCFUwzeRYn7qVCQXQxbhu7
 oDdonMUt
 rH3saNCj89JSd8tGBIAVNCktUAu9K4gJca1aXYUzXOXZPDk8dYpJFrhO3dzlN8/TSC20Kg9I0kl+yCyGWIAZUZ8gK0geTjqSWLxVbkykVvTLdHPKxWvy0S1uqX9Vy1pfTpfFUZWRLl2KIMOAsWhSEXZHsJ0ibcxjvegISk6RAsbIsVUwFwkJIgB45rbMeFQ/3v50J8K9PwL6C5Nnf4LK4+EFewMqtwDI7X7zXjnHjN8J54JDMlM5wMGTUXWuFiemPyjT4DUhErBJoZqMd+fV+bcJzSd9inFMHK1NSmqWLXR9kVZU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

userfaultfd notifications about minor page faults used for live migration
and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
minor fault registration mode").

To use the same mechanism for VMs that use guest_memfd to map their memory,
guest_memfd should support userfaultfd minor mode.

Extend ->fault() method of guest_memfd with ability to notify core page
fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR)
to complete and add vm_uffd_ops to guest_memfd vm_ops with
implementation of ->can_userfault() and ->get_folio_noalloc() methods.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 virt/kvm/guest_memfd.c | 76 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..087e7632bf70 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,6 +7,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -121,6 +122,26 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
+static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
+{
+	return __filemap_get_folio(inode->i_mapping, pgoff,
+				   FGP_LOCK | FGP_ACCESSED, 0);
+}
+
+static struct folio *__kvm_gmem_folio_alloc(struct inode *inode, pgoff_t index)
+{
+	struct mempolicy *policy;
+	struct folio *folio;
+
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
+	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
+					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 mapping_gfp_mask(inode->i_mapping), policy);
+	mpol_cond_put(policy);
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -133,25 +154,17 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
 	/* TODO: Support huge pages. */
-	struct mempolicy *policy;
 	struct folio *folio;
 
 	/*
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = kvm_gmem_get_folio_noalloc(inode, index);
 	if (!IS_ERR(folio))
 		return folio;
 
-	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
-	mpol_cond_put(policy);
-
-	return folio;
+	return __kvm_gmem_folio_alloc(inode, index);
 }
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
@@ -405,7 +418,24 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return VM_FAULT_SIGBUS;
 
-	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
+				    FGP_LOCK | FGP_ACCESSED, 0);
+
+	if (userfaultfd_armed(vmf->vma)) {
+		/*
+		 * If userfaultfd is registered in minor mode and a folio
+		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
+		 * userfaultfd handler.
+		 */
+		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
+			ret = VM_FAULT_UFFD_MINOR;
+			goto out_folio;
+		}
+	}
+
+	/* folio not in the pagecache, try to allocate */
+	if (IS_ERR(folio))
+		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		if (PTR_ERR(folio) == -EAGAIN)
 			return VM_FAULT_RETRY;
@@ -462,12 +492,36 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
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
+static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
+	.can_userfault = kvm_gmem_can_userfault,
+	.get_folio_noalloc = kvm_gmem_get_folio_noalloc,
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


