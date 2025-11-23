Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F142BCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4DE6B0029; Sun, 23 Nov 2025 05:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5752A6B002B; Sun, 23 Nov 2025 05:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464DD6B00AA; Sun, 23 Nov 2025 05:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD156B0029
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2DE14F918
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:30 +0000 (UTC)
X-FDA: 84141495060.27.392C5B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 172B380012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZTgflsa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxC2bGjJwYCBPRTrjfeEpWoINVV82cZjkKN2dzgtmTY=;
	b=615G0oV5OfHSnaXDCAfw2M7Vo6MJRKEMbm9GaJdlyjabHHiyZghVp1Tfmx0PB+GSOGukSd
	q5nXY4w8gyOPQihBM4wrJL8hUSwExJoQA5RDrJ6/1gUEKHGojzhJ29TnbyieZAHj2fPgVl
	xPmCFderbaubmBySspxLHNDMNNO8QY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893649; a=rsa-sha256;
	cv=none;
	b=lmHyK9C2fTOUS62I+t4Y0FrsgS7DPTMjln7sjss3ztDwlQEVXbZ568mE/m1mU1fs2scuT3
	mlFQxPudEZuamFuhZ34rjlrKAgZLgVY4Vj5eKC7XMpxyYz/+/GA9zdDY+7m+k8vUqiVgWe
	ydMzb70VggLsJCEJY49n9/nkhQK+9wY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZTgflsa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FFCC441FC;
	Sun, 23 Nov 2025 10:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00A3C16AAE;
	Sun, 23 Nov 2025 10:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893647;
	bh=cDH3WIfWACYcFb+JNsVypvmaWJL8YVSC/VIGBsIP7Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZTgflsai+RK4Zq/pWWn6QNq2LiWZYRqrDYPT9j65y4wruY+BECYFyU7uv40G1iax
	 bW8fTBuk6Lu3BtOjYVCZBgljqgnggLSJQLHTcEXJ6IZitWiNRjw208mdn2MQQLh2Sh
	 Uijip1NAgBV/tx1nw01ieSTlJhwMLcgTdXQ3urou9mrAjr68CjG38L7B0/O6BfmNmh
	 +9cxH1/UbV7FKUHnOLvEdabqRt0LDWE79HfTpexORoxfTdJRRUZ0+eaCZhjTkPx/fl
	 oC85lh31Qq8xJ6BW8UEd910uVkyWCMUYP34vKXO2Or/ljADNSw0Gc/HD07w357QLN3
	 cquCKQ8xaHgdQ==
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
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/5] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
Date: Sun, 23 Nov 2025 12:27:04 +0200
Message-ID: <20251123102707.559422-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 172B380012
X-Stat-Signature: pxxsusyrogok7iczkteq8zsk8hdexepf
X-Rspam-User: 
X-HE-Tag: 1763893648-897483
X-HE-Meta: U2FsdGVkX18q9EIznMejbJ1hNmQM61KsKDiKwueBX67x0Su5GZAW4zpV+HhhhuOOK79448/3U8FutpxbvbUi+QOJcwbgjBjdGy/AiBlolC/JrPSqAcKslkRkGnvldQI965yud3EFXlJ7kfO7xxbF3YqzbcXLO7EoGaK0efWXlIn1lOjcrd+i0ijPulnnIIryb0YghjX+ImUsnf1RWSw5bMIku88/BZPsU7/hHvnEaZw8afutQrLY218k/3QzbotQnemDZ4sXwz6cCyhqdL8mfLFXeXK9WlhqX3/o5wnqydVlTxS7C2z2BKfIjz3i/NSCRbrRuEBnNl/SNwumfd9TB8h5HygMgcRMN+0/KYXrNh5bhFfdsOBf57IryDtMsx7c6Q0vuXncYu6tiVjbkPIyD5j31PBU8ZSmCDFHrGCm2WzRzfK0gp1X/unEShMxUrUEV50f2Ci17hbDEPiImkxOco1Q5VCxLn726/z6ff+ebg5y5jkbjhj+MiVD2JQCGgpr/47CwHktC0qgZAgahhylmFNDEQW80vexJ8/zxi4IcK4RQPGZdj5w9JOEO4eb16w/cbD4G1IGR/YYQBGEdhg0hp0q/8MTDajEV8aeaJWN4YJYr5KDL7o3PvGb8Hx1FaT5tnXGZnaefT8BfZDPgdy7AvpDB3J9XzbI7sHkfqzfsVkjBtxEgrNAMRdZASKgFQeTMGYnyAEopxvkEq/wXCHYanwQFH1SsRBNlPMYd2iQr7vIKgaQGfMpXfrTaHOYHJuyobt7tR3aUGEu+c3F55FNZTEM1H+l72TgzHDTXrWZKGmnZ62LH916sGNUY2x9qtJWNu5MB4U3WmfqY4TfssNl/I/Ofgf8wb/rQTHM5kGheem2gv0p0zPflod4hEWhR2/fsvIUhdf1G7ZDtfGfeOFrTtpn2YDZZN7dTDL+UfZ6Ph7a6oRaJmniuWf+iPFzIP47rOzQKpBaBCcf/BCw0mM
 H3OrF8g6
 G7DeP9Rp4GCowseyEWmMJSzV4yV4MclRgk0Ktb3wTUNJXA/Q1F1XIA6Y14QFx4tOR/jCbqCyYamD7QAnRltiKOSpTajcXRkuR4nK2g4UpQpc+a21fbuPGm3IokvxucAWkmt7/23FqRaI82nIqS/6wWrnzC6usr3ZNMmEFAoSOPZRk+OrSDMZelKaRAGVjGPRY6XsiJhn8h17EjIs9DUBoI4m9mAmDDIKKTHyw+DB5qdhgNrX1y2G/InMJEGu01sH3P23hEEH+EHTYal9DqmFaijzFHPh4byi45Iq53jgqcGek1jeqaq9LEDHceQ689pvZsGSY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing
that VMA.

Instead of using shmem_get_folio() for that, add a get_pagecache_folio()
method to 'struct vm_operations_struct' that will return a folio if it
exists in the VMA's pagecache at given pgoff.

Implement get_pagecache_folio() method for shmem and slightly refactor
userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  9 ++++++++
 mm/shmem.c         | 19 +++++++++++++++++
 mm/userfaultfd.c   | 52 +++++++++++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..a5747c306cc2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -690,6 +690,15 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	/*
+	 * Called by userfault to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_shared_folio)(struct inode *inode, pgoff_t pgoff);
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/shmem.c b/mm/shmem.c
index 58701d14dd96..aaa21bb60f51 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3263,6 +3263,19 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static struct folio *shmem_get_shared_folio(struct inode *inode,
+					    pgoff_t pgoff)
+{
+	struct folio *folio;
+	int err;
+
+	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (err)
+		return ERR_PTR(err);
+
+	return folio;
+}
 #endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
@@ -5295,6 +5308,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_shared_folio	= shmem_get_shared_folio,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5304,6 +5320,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.get_shared_folio	= shmem_get_shared_folio,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8dc964389b0d..04563f88aab5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -388,15 +388,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	folio = dst_vma->vm_ops->get_shared_folio(inode, pgoff);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
+	if (IS_ERR_OR_NULL(folio)) {
+		if (PTR_ERR(folio) == -ENOENT || !folio)
+			return -EFAULT;
+		return PTR_ERR(folio);
 	}
 
 	page = folio_file_page(folio, pgoff);
@@ -411,13 +408,12 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 		goto out_release;
 
 	folio_unlock(folio);
-	ret = 0;
-out:
-	return ret;
+	return 0;
+
 out_release:
 	folio_unlock(folio);
 	folio_put(folio);
-	goto out;
+	return ret;
 }
 
 /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
@@ -694,6 +690,15 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	return err;
 }
 
+static __always_inline bool vma_can_mfill_atomic(struct vm_area_struct *vma,
+						 uffd_flags_t flags)
+{
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		return vma->vm_ops && vma->vm_ops->get_shared_folio;
+
+	return vma_is_anonymous(vma) || vma_is_shmem(vma);
+}
+
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long dst_start,
 					    unsigned long src_start,
@@ -766,10 +771,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+	if (!vma_can_mfill_atomic(dst_vma, flags))
 		goto out_unlock;
 
 	while (src_addr < src_start + len) {
@@ -1985,9 +1987,21 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
+	if (vm_flags & VM_UFFD_MINOR) {
+		/*
+		 * If only MINOR mode is requested and we can request an
+		 * existing folio from VMA's page cache, allow it
+		 */
+		if (vm_flags == VM_UFFD_MINOR && vma->vm_ops &&
+		    vma->vm_ops->get_shared_folio)
+			return true;
+		/*
+		 * Only hugetlb and shmem can support MINOR mode in combination
+		 * with other modes
+		 */
+		if (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma))
+			return false;
+	}
 
 	/*
 	 * If wp async enabled, and WP is the only mode enabled, allow any
-- 
2.50.1


