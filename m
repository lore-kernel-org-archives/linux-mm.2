Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECD2FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C643E6B00A3; Mon, 30 Mar 2026 06:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14EE6B00A4; Mon, 30 Mar 2026 06:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B037D6B00A5; Mon, 30 Mar 2026 06:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99D3B6B00A3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 610945B07E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:16 +0000 (UTC)
X-FDA: 84602314272.08.13DDD8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D0CA92000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ey/Bug5Q";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ey/Bug5Q";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865534; a=rsa-sha256;
	cv=none;
	b=mXZGenKkqL9zBlipPOyWM4z9wVaL3zGxGvdc5KekBz3qMf90vGAjnQzLzjH4ggy2Lv9ZAG
	O/ncJCHa/wrbOEm/R+iclF/v1Y7nvTdeJczv6R9IWRNnH5TusrZkczX0HT2x8HuO/sQfiK
	f6wuuvix4URIlmrKKWKAjc+rNP6ZaXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kkfv24X+ztWChD7WQDcL92+RM8gh0RWTpJeeZqBKkIU=;
	b=MsfCkWDeZc/ARvE+tXIsfE4OdRQuCEvLPSnSHdU/j11YwkQNoflSB5Tj3CptjP7S987EOm
	W3v8EJfntTR9INrHrAWAb0N1eUwMmuht3LFoV39ZNAjpjdPnhcs8uVWYlf44rUhTL4d0IG
	Vi+Wgz8rMhuejUf8SG1lqNUuLmGykNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D36560054;
	Mon, 30 Mar 2026 10:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD6EC4CEF7;
	Mon, 30 Mar 2026 10:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865534;
	bh=u+ZOOG8J/28GYuaj/GsT8WwOacoYSYHh4DClfNVux6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ey/Bug5QrGP9V2IgRa0MSqT9jLiKN1z+1t1GyNFGLTkOqS1opMCTgDdbe48AefLMh
	 uRhgWjJ+4jGvSGiAqviMJS9hJwJVMLrpIcMtj0kxiYgOMCGzXba6s7b7BEp5Ph4TcG
	 vcxWCNz79bccbB8n0xzREh8YuHHoU0yv6yjfUzKdgPSj6GNq/5KlQAtPvMk8E0mNLy
	 cH082ASpezuITTOxHFDp21Vi672lNcVrRcjkAZA+A9NUj8Bp7uitBGCGr6ca32S9YT
	 a8Eqn6aoG5p14c3oIUbe0ZGUu6xr671VsulGVtpxazSy3/AGyoZvPkKP6RYUdyxDK5
	 Rzb5c6eoa05aA==
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
Subject: [PATCH v3 07/15] userfaultfd: introduce vm_uffd_ops
Date: Mon, 30 Mar 2026 13:11:08 +0300
Message-ID: <20260330101116.1117699-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0CA92000E
X-Stat-Signature: 3erp8eg1pjohsnmnpypt7fem1psiqpyc
X-Rspam-User: 
X-HE-Tag: 1774865534-33107
X-HE-Meta: U2FsdGVkX1+dbtqOP9E+pghNkbb5KWeLFy49CeTvlpfZ4JzcyR9HKtH0LMqDMSCL/IiuT25n5kIwgffpBCk0iB3vL5STr7yawVWzpDk9EwrNvdx5VReCe75b1QlMmRfTugHcVoPwwiWv43IF7xqj32X07ry7a5FQNnNcm1xDBtE9s9N9J7Rmoms2odPC+FZ5tOtCrf4l4kf5iBskowLb65cgzHmnLyfnXh2PlDWbIyVqpwizrzAYsWX1UVuf3SlnDqsnA3HJPYA2mYP/KyHWBAwvmWDy4peTIxGwwX4nq/vRg/JQdcj5eht1U5qicn0Oz9tcGCaVV0s76E4JS7TsiXnSuvjLijxuv7472C0PYsh9fRI9xTzZDcFmcL5O05a/nWoF4bQoVAx4xUKUpD9+n828tD8nJVKFoADXge3tpPHvfY2Ei5xrDerDLDePigMObyEO9CKDxf0FyXAOTGax22gcdsj0vSnDGETfL2fyChfNmR7OAggvcB36qzxGI5iWtbNyE3sk2fGdUG8O4vwBqrLn87Ahh9355blSjxIN3jse/mzlUoHKxjoZ99i2c3j7Q7M6c6MTbl2s0VGDY1O7nH/Qer1KGXKSRKq/lkQGDBjE8N5qOosOYpnSy8Ypqrs2j6rlLm8Qps/MLCNVkLS4gSNfmz0yxYhI3ls3qqBoJoLleRAZMw6TXSdavlHXwocQvYKRFsGnyDSwG8CxAhjRWVIgFbEAzPYkjSc+abt4Dfq7zDSupl7w6ubEpgwuDentkQEGWNiWhWaJHLSZkIyoV/G3OwvPdQjuTY3YmI9Qi7suHaoDs4jatV67YynEFzXjvYK9dT+KLEFQBSir6WtlSrlqw131TShnlR6fIyWImSdrMSWGhmjwNgx/UcAoQTaHQCzItU60CLq7RzeX75vZdWaFux7nvvrsMerPpzhekHuzZYRkC+mkBktsrQxgD6tSnLg7e2dPMa+q2Oh7m6U
 lyLbIZ5/
 MMeFRnrpgLUdojsF0d4Z1YDcoOCUJFim0JRd9TwED9JVU+3ruQmoa53j1CB1afbAminOmJ/sEk0elWOmLim2W8tiLoEwYpmMHbGIAf3as9MrKdAMyiRe0SncBIDf5gHWgXr4JK0EyxX+kMUmS++j5UoOfebJTD6Ym1CymjcpucvWNq6AXp2603xKqfaN4MF+qYSq8Jk6AWdekOEm5zzXrvjA1WK70Jw10HaSw03ygjkjg4uBOSafC1lgqJAoxIwzKW9KmOQmulZJVVM/g8rRtYCa7qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Current userfaultfd implementation works only with memory managed by core
MM: anonymous, shmem and hugetlb.

First, there is no fundamental reason to limit userfaultfd support only to
the core memory types and userfaults can be handled similarly to regular
page faults provided a VMA owner implements appropriate callbacks.

Second, historically various code paths were conditioned on
vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
these conditions can be expressed as operations implemented by a
particular memory type.

Introduce vm_uffd_ops extension to vm_operations_struct that will delegate
memory type specific operations to a VMA owner.

Operations for anonymous memory are handled internally in userfaultfd
using anon_uffd_ops that implicitly assigned to anonymous VMAs.

Start with a single operation, ->can_userfault() that will verify that a
VMA meets requirements for userfaultfd support at registration time.

Implement that method for anonymous, shmem and hugetlb and move relevant
parts of vma_can_userfault() into the new callbacks.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  6 +++++
 mm/hugetlb.c                  | 15 ++++++++++++
 mm/shmem.c                    | 15 ++++++++++++
 mm/userfaultfd.c              | 44 ++++++++++++++++++++++++-----------
 5 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..0fbeb8012983 100644
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
index 327eaa4074d3..530bc4337be6 100644
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
index d51e080e9216..e3024a39c19d 100644
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
@@ -2021,34 +2040,33 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
+	vm_flags &= __VM_UFFD_FLAGS;
 
 	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * If WP is the only mode enabled and context is wp async, allow any
 	 * memory type.
 	 */
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
+	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
+	if (!ops)
+		return false;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
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
2.53.0


