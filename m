Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DE7D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424536B0096; Tue, 27 Jan 2026 14:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1BB6B00A0; Tue, 27 Jan 2026 14:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B736B00A1; Tue, 27 Jan 2026 14:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2376B0096
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D30671A0332
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:33 +0000 (UTC)
X-FDA: 84378735546.16.72A6351
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F8444000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t5//S+1U";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUq9j91Agt6AORxnceB6Mww7Jrzkypy4tjWMdHnw3kA=;
	b=UzYgbr9lYxFrPtl6oIGcJmWoZeOpDJv0lmDEzEVfy4HXUnPr2Oe52cRdWRysVVr4uPzDqW
	zRXYEApg563dbDGUNlBdGERSlGYbHcEf5EBVmZOigsIeC+1fHbU8w1p5g8qKKDPbtnVv9P
	OCLuqhiGnQPu5rdDhpgb2Vz4V3t7efY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542232; a=rsa-sha256;
	cv=none;
	b=TkxCrvNW04yf0YWAq6t5lVAuo8D14slpswCAzYdk5KeHFSR7CVUbfHd4tyvDCWYkndCJbL
	AYsaGIt+OKHbaAPjdZVWMC8FR2UrB6LKROEZHnON+oQYYfyFTtJE+PTv35sWXfaTeT5xwj
	/SK1Pdbfm/u7R+b3SDP3tmgi8zYNwzA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t5//S+1U";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B133B601F4;
	Tue, 27 Jan 2026 19:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA792C116C6;
	Tue, 27 Jan 2026 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542231;
	bh=i5BbhYRwDwFgqsHdXlkHyjBIxCxCm4W2Vuq3+WqFKuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5//S+1UtIYnXDs6Hs6NxKOKKNNWqptdM+gvy6dRVE+BudwOJTk0JU18Kgu8Is/i8
	 S4mij5QllCQ0bLDP9j4PXhyhphk6rZsJnwO66kQ2KnBjlo98h9WsU+/CtVyuyfrDcb
	 YaDIC2cQY75LBXYYQ6dkdIl4lRxAqFoZ+QW+6+mHOUU/uxwZSmtZvmd9yKdmJePJbh
	 7icJnfNaiIn2NFwCBRLDTEeXkx8acI0L8/XRNxVWlWsjzzJK+zvIf6d5ZkMJ2/yiYO
	 82FLdFAV0IXtjX6eBrCoibCK0vbQ+FMcvnhGLpbqCi9QS6JQProWOOMP0S1nskNgaR
	 ARQpR/ChNCNDw==
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
Subject: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Date: Tue, 27 Jan 2026 21:29:26 +0200
Message-ID: <20260127192936.1250096-8-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F8444000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ziffdbjnmdshw4sbic47htm13k1noga7
X-HE-Tag: 1769542232-344556
X-HE-Meta: U2FsdGVkX1/ULNnUpFtBocZjeha88FwU33cu8uqw105EkuyBhhsx+N+KgAkMjBZ2WW4FLCPV9hLVBEDQuQp7k3e8GgkUraV+7FcjPKV2rGNzllIwWTn/QOEyZBkXY/aG7A9F4Iy9xjcWLHECMy0c5HN3V/ywZCsjJx92dDm0VdsFg2deSM/ttcuWNBaA2oG+cd2wnJkfV+19Nn8ILa9bfVx0RAJ3IK9nw09MNW07Z8GGQdiIDyvwCzvUEl6/NjlRTDO/6zUw6rba2oInbYECs3vWz2FliGA+vJ2eDQf2xAQYCdLg4Ck8UioTbNlaqNZvheuz8CEoaTAzEzw3VctqfIokQuth4cuCHHuXPjYrfNEjwKz+YEI8BWnEKEJXvFAf8UlH6PIBhMxRgPUt0x50NktNlSwFTVjmrbm4Q9xPAszkk9ByNF5xHPIcLyXcFIfHLM5kFR6oh9aC3s9DzqFpVFE2XMZwAvfy10qpEWGEYbFhMXxcJxPtRc4ysuB22HObInu0EwU4ic33CyM9qJNYIngb3qKy04l8mXWPzXOvjdxxPMeDtWYZHG0ghdqueApXF8Cx9g1pnvKrZFyapTIBJvSNa/mOJRo9NT6uQfDKBHM8dEesKrt2ShKcgzL8JIudvWDEhcG/cFUw9wI5VX02cHQBkREI73YTC/PERsP8D7PfI6nVpbNPDZ6alCtBbFkjZaOrvrx3wcaVyn95rYBDGROh2iO63yzvRAcCsRJllPECPBYbFv/1GoioLYbe+Lph/wL3SPn0FzBYRWyCP/m0i1mBjZcuAZo2Pw1IRN1KK+GSTLlW/m0Y41NUtW88KJMunLpsbdQj6GKrDIquO6mrOvj+zRjdbXw867E0ufb9NppD1pWwbTWsPg1mgaWZKAcQVORJ1cr/IiDAUK+rjC8KI1bANt8MhxNc19pXxoCANVli1z4eZg7pbd6VOWJoJaAWM2gbkNFYyOhgvOzYT+W
 yzWqY/bl
 7yBsTpZ6ErNoFFyR+YATtZ8JQYffLuA9qhUy82G7F9uyFGE0jWmBqYGpZWZG+371Zr7oFMy70lR7/QgyGfQR4Jf4huwRFEh02azyg2GnmXE4KV9o4zl0evD8BQ9elFTargpL3eW/+ZbVjAl/npoP1rmKqNLBWjL+Q9lHFHiU+d+rDbYXLpnhgaba3Tgl6YBEnTosL2BH9I/Vzsf2oNtmWtZoffAFvVuc+NM6R0zerA7iu33D3ijWvpSey+JohxYDCA1wLNmw4c9BPDoY3nFrRvVvy0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 include/linux/userfaultfd_k.h |  6 +++++
 mm/hugetlb.c                  | 21 ++++++++++++++++++
 mm/shmem.c                    | 23 ++++++++++++++++++++
 mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
 5 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..3c2caff646c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -732,6 +732,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -817,6 +819,9 @@ struct vm_operations_struct {
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
index 51273baec9e5..909131910c43 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static bool hugetlb_can_userfault(struct vm_area_struct *vma,
+				  vm_flags_t vm_flags)
+{
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then hugetlb is not supported.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
+		return false;
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
@@ -4810,6 +4828,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..9b82cda271c4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5290,6 +5290,23 @@ static const struct super_operations shmem_ops = {
 #endif
 };
 
+#ifdef CONFIG_USERFAULTFD
+static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+{
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem is not supported.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
+		return false;
+	return true;
+}
+
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.can_userfault	= shmem_can_userfault,
+};
+#endif
+
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
 	.map_pages	= filemap_map_pages,
@@ -5297,6 +5314,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5306,6 +5326,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 786f0a245675..d035f5e17f07 100644
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
@@ -2019,13 +2038,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
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
@@ -2035,18 +2056,8 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
-
 	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	return ops->can_userfault(vma, vm_flags);
 }
 
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
-- 
2.51.0


