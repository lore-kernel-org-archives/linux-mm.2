Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26C4FCC046
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FA46B00B2; Fri,  6 Mar 2026 12:19:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2615F6B00B4; Fri,  6 Mar 2026 12:19:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156B46B00B5; Fri,  6 Mar 2026 12:19:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01F6C6B00B2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B94D61C76A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:12 +0000 (UTC)
X-FDA: 84516298944.01.47664FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 346731C0014
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cC/nwaq8";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHNRmaeFkq7BdczmEdv/hsmSWLoNtmEs8tbnt7S4dis=;
	b=Jm27T9qj8db8zl42OaOzmLHl2ICP7Rs7bpFV3YjLa8iQbCACsOJBsF/ewI4k6U21gwlFUv
	vMuSoj2sNSfpb8ErX2IXm8Kq5gFikazoabMqoy93ZzXQ4yGY/dTH2u4yItix6Ebm+HQ7B0
	c2hYVdGtEeQY8deWqlyAxfI7tIRJT/Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cC/nwaq8";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817551; a=rsa-sha256;
	cv=none;
	b=GH+NXtsNj+Be8FvBCj1dLMuzBfqkNvvOZCZHfzk+yuCDh+mObXhYe0rBxAafYdcpIj3ipr
	AZw3SNPQmta3cYVSafK1pXr0LsKg+iCjbKwsMczoaWpMXoFR0GUI7FPQhg7T4UhtBlihX9
	gsOkO1t8JcvF0C8Hfl15B3wGIGQBLe8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DEEC60132;
	Fri,  6 Mar 2026 17:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E47C4CEF7;
	Fri,  6 Mar 2026 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817549;
	bh=Sv4+9KeoC3sTffZxTlVqK+mroHcnok9qkJN7lo9ppOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC/nwaq8MfXxeznsUWyMc4//fJyQY6Gy3lmbfX8nvg3tpTSws3+Top8otjCejjNcz
	 +iWsx+MFM9OJXHtYj8yDDe0QsR5GgaNijUE+iH18yL/vd0qlWg0FF7YX9jHBrA75zI
	 ooH8y83jzoFddEdNKA/XO6hzr3o/XxzkGcb1OZA18Pla4pR/Ylv+jxmLxEudTXNt51
	 J6t1gnpJLyayOzNYMTy7o21c7x2lFPQRgWKLocKom/dMGuiHYhOjKAVLJDJ3RRJfuq
	 UOpxQs8qxizckrtpQY357vjvIl+aolRQ/CqSA0cSlaRNQ/UK+XYVR85D3sIBvnb5XH
	 S2TL/AJF5gjCw==
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
Subject: [PATCH v2 07/15] userfaultfd: introduce vm_uffd_ops
Date: Fri,  6 Mar 2026 19:18:07 +0200
Message-ID: <20260306171815.3160826-8-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 346731C0014
X-Rspamd-Server: rspam08
X-Stat-Signature: 8oyhu56naajtdh5mfakocj1zs7enoqec
X-HE-Tag: 1772817550-726935
X-HE-Meta: U2FsdGVkX1/Sg7ntkdVPyw688I7hk9od8RdQriJZU0xW+FesLsu56p/uJlK0/KmY17GgRTBWWMAcSbobMyQH7ii4HbsaU4DRl8xRZTI7MI+gM3cB8hiaDdNAkHu8z4+mT4iZE7FZrI5i3Uod7BpAKC8QiLVzhR5TgK+jrpPOwK7GVZE3Fg9FyAFyZjKvnNwbX4C2s1UVXaaJwjwzP/0mttS/aVC3BzOA0/U48HjD/twAZph3HggYCWNeGE/UtfApMK5P+8zpSqYDCxGFxvuH9TmjXha/2Qa8zLwG0kBZmgF6iPQLJPd2dGA6CI2Kw0JvwL0cys94fWHxrSGVhrd0EPM4QBs86i/yI0jM5ZLmYwk2/jtTw5UMYscYpU1KGe3UBIWFYIHZQHTbGVh4FDrpHbnMEnpwA+6U/tms53TrwMCoBCvkpS7HzJECX3fI2Cx0Bijrga+N0n50MCc2ypbhu+8ukZG2yGi2x/tFNSt3KLiewvAzK9a0UWPqFYEPsKq5VIuz/V/qa6ayCKW1Pz7uZpEvEngWyav+1D22g4X+ws+PO/Nm+eG/EkaEZFQCHfJjWGARSXsKF4O/FU/o6Tjj6xGcekeax1bNDOFYUd/Ss7f4NO33FUSjzcMha/1lY7qy4kw4ZUd2yISkJ6YesVUS8XAUkZAn8zO3DtzRFNtkR5MqT8aL2QoLh4Shm+CCbitfnhTLdUywwiV+CLtGUc0GNbKAt7xLZiD29Drhl09vsKLzaWqXOLTUQsTx68JY2bI8xKSWrDLAWsFF/jYG9rDSnmEcI79BJyu44e4DqX6ja6y+k/P996FstEHCH3Edb4SgxVScKVMLPw2hAhZMuTXvdjtdgjuWyTlyw7omdSwIVAaAKJQ2EYXw7QDzkv/nYHcNZhsY/tFs+fkiORfjxis3sdXg3oxTjMyMhCJ+Pcr9h+SnplgojYsMcXFDMra7m5AtWLPvewnkp6poCVdHaUg
 YRHuzuCH
 cAGoLxssYFYNwt5HWszLSoSrcRVKBggzb6eQRcMmEHrSYAF0Lf5RmXAdst//6T6JAYfEcLyocI8HeAZrWbeL/Ybl1ueqEvSLsniHDaPGiYeT3kCpmYyF3Fh8FOabDSplEiqLwgepWaxEfJenWybCjEYdN3dIW7M5U+VU6ruLW686yN+dNllmPZSX5VRyj+awGmmBT6kU2UuXPWhcRQ8isAsmXvrv5rQ8WvpBvkMASFFIsoO0bJjWNOav5/azEviP7dWglpC/zm0sRdNuwKCQuu2xvN1uL9ADUjSMb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Current userfaultfd implementation works only with memory managed by
core MM: anonymous, shmem and hugetlb.

First, there is no fundamental reason to limit userfaultfd support only
to the core memory types and userfaults can be handled similarly to
regular page faults provided a VMA owner implements appropriate
callbacks.

Second, historically various code paths were conditioned on
vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
these conditions can be expressed as operations implemented by a
particular memory type.

Introduce vm_uffd_ops extension to vm_operations_struct that will
delegate memory type specific operations to a VMA owner.

Operations for anonymous memory are handled internally in userfaultfd
using anon_uffd_ops that implicitly assigned to anonymous VMAs.

Start with a single operation, ->can_userfault() that will verify that a
VMA meets requirements for userfaultfd support at registration time.

Implement that method for anonymous, shmem and hugetlb and move relevant
parts of vma_can_userfault() into the new callbacks.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h            |  5 +++++
 include/linux/userfaultfd_k.h |  6 ++++++
 mm/hugetlb.c                  | 15 +++++++++++++++
 mm/shmem.c                    | 15 +++++++++++++++
 mm/userfaultfd.c              | 36 ++++++++++++++++++++++++++---------
 5 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..b63b28c65676 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -741,6 +741,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -826,6 +828,9 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	const struct vm_uffd_ops *uffd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a49cf750e803..56e85ab166c7 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -80,6 +80,12 @@ struct userfaultfd_ctx {
 
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/* Checks if a VMA can support userfaultfd */
+	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+};
+
 /* A combined operation mode + behavior flags. */
 typedef unsigned int __bitwise uffd_flags_t;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0beb6e22bc26..077968a8a69a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4818,6 +4818,18 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static bool hugetlb_can_userfault(struct vm_area_struct *vma,
+				  vm_flags_t vm_flags)
+{
+	return true;
+}
+
+static const struct vm_uffd_ops hugetlb_uffd_ops = {
+	.can_userfault = hugetlb_can_userfault,
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -4831,6 +4843,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..f2a25805b9bf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3294,6 +3294,15 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	return true;
+}
+
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.can_userfault	= shmem_can_userfault,
+};
 #endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
@@ -5313,6 +5322,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5322,6 +5334,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c5fd1e5c67b3..b55d4a8d88cc 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -34,6 +34,25 @@ struct mfill_state {
 	pmd_t *pmd;
 };
 
+static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	/* anonymous memory does not support MINOR mode */
+	if (vm_flags & VM_UFFD_MINOR)
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops anon_uffd_ops = {
+	.can_userfault	= anon_can_userfault,
+};
+
+static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return &anon_uffd_ops;
+	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -2023,13 +2042,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	/* only VMAs that implement vm_uffd_ops are supported */
+	if (!ops)
 		return false;
 
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
 	/*
@@ -2041,16 +2062,13 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
+	 * uffd-wp, then only anonymous memory is supported
 	 */
 	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
 	    !vma_is_anonymous(vma))
 		return false;
 
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	return ops->can_userfault(vma, vm_flags);
 }
 
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
-- 
2.51.0


