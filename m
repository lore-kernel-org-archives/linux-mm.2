Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A08FCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9A56B00BD; Fri,  6 Mar 2026 12:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B71F6B00BF; Fri,  6 Mar 2026 12:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC7D6B00C0; Fri,  6 Mar 2026 12:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687BE6B00BD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E6B71C8D3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:43 +0000 (UTC)
X-FDA: 84516300246.18.125726F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9403340008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngPuMDYO;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynoAr2XykGPqHoD8O4DsAQ7GXSbtpMnWgerNaVtuPrM=;
	b=ZJ88UMRMWArvv5StXp6rhMNENa3kkjGxrxuNFfoCEx7AUYWdXSiQTVwMva6Jke+oQSnTll
	WQtjw8VWCx9Mv0AbPCayRuWlURrmzgEP2qobH3YoPKs7r0F/lOK01BN3IL+tznH+SK6O1/
	ZkpguKxDDmzWFsestxKXP8q2sZGdaoI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngPuMDYO;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817581; a=rsa-sha256;
	cv=none;
	b=v2C/Etyd5yK+fnyt2CxkwXmHl4/vtDJyvcvCHw0Dmug+tMag77VwGLoj3RJfDDyCG+op0j
	Qtc4xv3QHfWCbO+QWIBmF1qHygYcANEq/F7ELWdmC3eUSjTcZyDCrRiMLS/U+JNohRY94Q
	t7OynpO8AK2XQcoUXgMlSk6VuK+EBZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D2E260053;
	Fri,  6 Mar 2026 17:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED3C4CEF7;
	Fri,  6 Mar 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817580;
	bh=D2z107Crk/aKX5jAkrVRRaT1KD/wz+I3gmrbuJFA7+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngPuMDYOlU0mS+ASFRSNx8uaRHF9kFKx0o8JB0Q8efPd7kbzUcnYwjsCOJjXJpfG9
	 zVkLPIpevfPpHikwzQ8vofWtaw8pOystr4JUYmsveUeFSZ27lHyXPw5IwgE34H3niA
	 6tViETw/ALirduugAdhngm9PvkddKiL8mR1puYQEBKKjXeFmqbS0PjRhhOyiIk2pLf
	 2ICVUi2AUzCNuukDh9OwdRURRDUsnfH9IHXfawgc4eaZcUzrU/genjD9gL8O0xAF8N
	 m5StoeImAE7EMg3Mih2E+7lLLKRY5i/yfXYNpa2RZDhsS13WvOMyEG+CX0bBmf/7Ax
	 rPWnW2MdDsOww==
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
Subject: [PATCH v2 12/15] mm: generalize handling of userfaults in __do_fault()
Date: Fri,  6 Mar 2026 19:18:12 +0200
Message-ID: <20260306171815.3160826-13-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9403340008
X-Stat-Signature: 3ky757kd4bzjo4cg4qdkrx358z89oeix
X-Rspam-User: 
X-HE-Tag: 1772817581-50684
X-HE-Meta: U2FsdGVkX19bvNi315s3J9koTcb3hjLGHUNQdYG4GXIVeNFSKwbHN/lPLfoXbbNu4Zb5S39ZOP/TtA+1iYAjfJ8pzKXciylobSSTg/WQ4hIZnBzcP72OSz4b1J8NXNhdYoTd1KmrvBECl6EnrWObzPRprMfFx0s15fKWr8St8zZAp1fQ+Q3SZyNjWJk7uBNPDzrOP0LmFBTAGkmxH1kxU3AYKPOxVpizNB5EmUztis1QOZWvzcfdmJiY5QEMHC1gAF+uM7UEi0taHub+tJ1XpFE/IhibWaSAIb/Atne4FX8H29tWZ35gEWo5CbJ42VF/3VJyDEF0R9xp0peJw+0rJJAAkKqM3cDKXna6z3mBajE3Uyv1vwOLSawH0kR3Pd6urgD1T7IN/5/crTpjbpXIp1TyX2qSFy/wKxJ/rZsjQwN5V/SVQP+uLyO2X8LdJBxo5H6c6kAO7Bd0GFb3tqNk7wp8ICUKcRv0JC3ZL7VBjqHX/4IdZUu1gNJ7QjCFrzPEqDvcTSyJnSND9Ban6rvVWHwwnjOQ/x5ivcQnVh1WMz+QyYK2iZQ9W7m4hpXGA14hiLB5RAqX6L7rs7KfYM4do3TUZtItgclgmvP+fa0jOCgxZjFeMaiasa2rn9aStpYhqqvQ/04Ae/traAzXTqnLUl2/1LctOaFhKJTwy6Ex9lhbg1s+cj+1JwSUKGtXVNXq1uFKNMqvtEltOzALSlGXZXsW85rZrnZsoI6xBC1GlkP4ARFQeDEbv3Canmn4amBfcANRi8U9v9zFKOWy8l6RyO9Rh9OeC6qRN0rqI+6gai+WD47P3rud5vnzFyQ0ag5mjB0KhBFjd4iGQJ/bniCS79ZbSMXp2OWMzOmK6MzNLVpR0UcdVXN9qiOUPo15fbSQbn4drao+aMdQ6j7/wst+Sm6SO1wqd8ObiuzGIzDkXVESILkL5NTy22maOpWZVGBbsAqdH1tqbd6uFGEFOMR
 EKEQJoHg
 reqiY7KYI58WHdl/zW645Rlmnmq864JybejKtarbnzHfjTtJ4FNsLR5wQmjvdoBHKMemrksjnRSXdCMishbuXnPX/EwPsCOQ4NIEu8Mt2i59o4V/gDVDamO2EnvCsDmsFGU/lFqkXYJPouymTYs/QFJW0ffwkkVOP0UGJjRhmKf4jC8gPgsduU8MBi8AKGJbuRNuMVEe8sI0O0wTkCn1RmZh8QPzxHDSuRbWhT6OKEMmIHOt63eQIYG1lWKdxQp6Oe42q+hQ9iu3FxZ9E9Y8gzqTte62zveSXoz5sfnzoziok4V7rDTBM15ECDBknQgAfGpx4IaSRhjcUqLDutLZO44mF7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peter Xu <peterx@redhat.com>

When a VMA is registered with userfaulfd, its ->fault()
method should check if a folio exists in the page cache and call
handle_userfault() with appropriate mode:

- VM_UFFD_MINOR if VMA is registered in minor mode and the folio exists
- VM_UFFD_MISSING if VMA is registered in missing mode and the folio
  does not exist

Instead of calling handle_userfault() directly from a specific ->fault()
handler, call __do_userfault() helper from the generic __do_fault().

For VMAs registered with userfaultfd the new __do_userfault() helper
will check if the folio is found in the page cache using
vm_uffd_ops->get_folio_noalloc() and call handle_userfault() with the
appropriate mode.

Make vm_uffd_ops->get_folio_noalloc() required method for non-anonymous
VMAs mapped at PTE level.

Signed-off-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c       | 12 ------------
 mm/userfaultfd.c |  8 ++++++++
 3 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..e2183c44d70b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5328,6 +5328,41 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode;
+	struct folio *folio;
+
+	if (!(userfaultfd_missing(vma) || userfaultfd_minor(vma)))
+		return 0;
+
+	inode = file_inode(vma->vm_file);
+	folio = vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
+	if (!IS_ERR_OR_NULL(folio)) {
+		/*
+		 * TODO: provide a flag for get_folio_noalloc() to avoid
+		 * locking (or even the extra reference?)
+		 */
+		folio_unlock(folio);
+		folio_put(folio);
+		if (userfaultfd_minor(vma))
+			return handle_userfault(vmf, VM_UFFD_MINOR);
+	} else {
+		if (userfaultfd_missing(vma))
+			return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
+
+	return 0;
+}
+#else
+static inline vm_fault_t __do_userfault(struct vm_fault *vmf)
+{
+	return 0;
+}
+#endif
+
 /*
  * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
@@ -5360,6 +5395,14 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * If this is an userfaultfd trap, process it in advance before
+	 * triggering the genuine fault handler.
+	 */
+	ret = __do_userfault(vmf);
+	if (ret)
+		return ret;
+
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
diff --git a/mm/shmem.c b/mm/shmem.c
index 68620caaf75f..239545352cd2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2489,13 +2489,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio))
-			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
-		return 0;
-	}
-
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
 					   sgp, gfp, vma, fault_type);
@@ -2540,11 +2533,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
-	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
-		return 0;
-	}
-
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
 	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
 	if (orders > 0) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 7cd7c5d1ce84..2ac5fad0ed6c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2045,6 +2045,14 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	    !vma_is_anonymous(vma))
 		return false;
 
+	/*
+	 * File backed memory with PTE level mappigns must implement
+	 * ops->get_folio_noalloc()
+	 */
+	if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
+	    !ops->get_folio_noalloc)
+		return false;
+
 	return ops->can_userfault(vma, vm_flags);
 }
 
-- 
2.51.0


