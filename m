Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D05BCC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05ECB6B009E; Thu,  2 Apr 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036C26B009F; Thu,  2 Apr 2026 00:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB55C6B00A0; Thu,  2 Apr 2026 00:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD3136B009E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99697589BA
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:56 +0000 (UTC)
X-FDA: 84612295152.27.144F36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C0B220008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdSj8YsX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kkfv24X+ztWChD7WQDcL92+RM8gh0RWTpJeeZqBKkIU=;
	b=US7Ql0kqvYjZ0J63L0J8RcyoQLiuIUnhevBn1WvsdBcAN0bIoGgucBlvfbFk5BmcGw5xKD
	7+ixmZIXPw3H1qDAoak5H+rtaEA8SAYIVlarE17ZAVQp0Jov13SSbP/mPuBugSzonEGNG7
	lnzoc+UbermY5Ce1CYV6Z8NpLiHedH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103175; a=rsa-sha256;
	cv=none;
	b=nN/Uou3LGRVZtuaNqa9rEmpCDc4m5eCQ7aAvzUnKP/3Be6w1l0lVXiG26prG7gB13HeJF5
	pAglZuucuvS+l5/YghtkXfJdyTH7WtY/cUl3nJPOvjAwizmYxV1/ilcAad3jIBD3cX1v0i
	ap1C23NxC4Hbjz6mXTktk3Ha+itdh1k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdSj8YsX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81EC16186C;
	Thu,  2 Apr 2026 04:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC46C19424;
	Thu,  2 Apr 2026 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103174;
	bh=u+ZOOG8J/28GYuaj/GsT8WwOacoYSYHh4DClfNVux6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdSj8YsXBms6JMAXx3iKSbSOLf55gYfGk7tRtNBmt2PPcCj1b72nOaSt/Gln8t2zP
	 XjsJg346ucFFyRRuzQXzhxyks7T2lEdZ7ogc9gnOrdgaQ5QjP8V0VvOE9a5FBTY1Cw
	 ORQqpoFHeKJ23FSOWzoATxDQaoQVb96FHm3eknirxT8Fkankpbs2lQ3wLr09EAukiX
	 WXPsaCuhxUxonyH+iV5G/7Yob6GwVhzWX+FTATjT4GetWJyJYxwYXy5IDebYViHGgV
	 Frk9QL5Uw5aOkd8BWjWdkNmuioCwS42Tt98HOL740axM7BFjNYNo/28E+iFJoKYRCz
	 ppKu1Rx0OwaRQ==
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
Subject: [PATCH v4 07/15] userfaultfd: introduce vm_uffd_ops
Date: Thu,  2 Apr 2026 07:11:48 +0300
Message-ID: <20260402041156.1377214-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C0B220008
X-Stat-Signature: aqssyj8pr8mhathgdp43nyphk73ooeg7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775103174-160051
X-HE-Meta: U2FsdGVkX1/CqUKiiVRIdoPCQo9vth/aKdBxSDGzDBfr4JRXl62je8yN0niZYaO5SdqWFqRRgM8Hhb58bNHDC8hehfOEbOpojsqmZyiL13uI9zMKWlhyy8ByduWFoVVLNMyv56sYepzU92iD7R6nojph151DKCsrMvtnBPg2BnhXou3p8mndVecHucr0xGcRsuqZgm8AgW0Y7eat7kMJy776JVzBIWB2ijCnie+hdnVUQARcxYyG+SwAU4zL/N7F2x+Aiy2/O8yqn+hGgl7Yl+fQfIibKW5OAy+D1IR8JysBamsL0K3EocD4cjpW/sJatZ3vlM5m5oAgWqcS2spcCd+FdEkptK6Po7HLj01T0dQehkh133GkozvZdKDtW4+Sq8pYwy88W8oyESq3nQkJBTH352sv5349Nl5i0CJFjJZjUiJMqDJuziMWAkF+rE/8fZS88U/3eEI0ZsM/4dmTonjPSQZvLS38LtqoR3vF9dBXkE8RIZOq1SFMVMJChL+Wb2RERO40VLj1c76drrTVg75myaq19QsXo4i8cpZSTy6m0nAfBCllEgFS20VKiPJMTew2egcPj2dOTODcBfoSWWESQjoJO3+3wuUHNmhxjqrtxbRnqUc0NM6A4kqGy+mDsr/nNxs2D2iBh/hoDHBTdudv8sP6Wj3Wz8+UeeEB0YAQ298p6/zlZh4plQPQaVjj5srEIqyL6/477/Kcbmknmymwuap2Cb/DiGFC2/0HyXGnNfK6KmVNWm+z/6LegaeDDYOb3ZfI3A9BXOb3UkzyRKD56ZyBqUc1gxRFBprIicQ885F3vriKC2JPCw1SqpQkOdChJ31i/3fryO//PYZ1eCIJiCMBZatN3kVLLJ1Q4qi4haeuwW/oebk7AW5FKZ5KypPZKOGpD8nmzQc32CjeXyduXZwc7Uqfsuxf6ZxMNdwYA1W4FzdAVu+bI2zbfvYcK/3J+snexP8pyREBQ6O
 FOcnORj7
 ccw5Rh8yy2CMPzWJzhN4mnGPXE9u+Cc/ulPfsF33eRCQswYCUQi/7gMBJng1O7QpEGQK8I39MekHnAYV+C6qjGtg0v9JtyXx2mUOti0KFmZWp9iCPIePDogndL7k9GqGTzx5fXNMdzpzC36YtGAPZ2CZ7ea6uJJ0SAB/Tl0rnkjIQ9aIks6yTnC1sV3XmSlR2Vu6IgLoBb6+RrbR54z85qf2Jf8JOYz+he83NOUPRsvcUBeYxvx8Xa19tO7G0F/BFX+pEvo5Ux0KLi/I4ZB+pMwiYQw==
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


