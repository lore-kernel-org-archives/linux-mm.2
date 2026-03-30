Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543B9FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8306B00A4; Mon, 30 Mar 2026 06:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B785F6B00A6; Mon, 30 Mar 2026 06:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67DC6B00A7; Mon, 30 Mar 2026 06:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 910106B00A4
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3146813BB05
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:23 +0000 (UTC)
X-FDA: 84602314566.11.FBFB1E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8781D180002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aS25XSKy;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3O3nTbzGihVtxjjI/2f4S+asSKC/YGLteudu0vZgmM=;
	b=3l4h9gxBPYmMZbDnOtASCMSOmPD0UyrWQYP4uGnnDPpTuV9D3CXAEu0+I/0TpkjFTDpvjR
	vHKTTVVDxg8XlfvzoYce2xf71XHSBHB2HTlCF7tYU1fDZ0pGKrEQSirXneNGPJozHV6fYV
	6cCmRXcPUgXZ8bjetf/U6eky6u8Xjrw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aS25XSKy;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865541; a=rsa-sha256;
	cv=none;
	b=k/xTlwKqNCLyr0NXikcXA1rJ7f8eXTPIe99mPUpt3U5ANlF3KRw9Y64yyjzjvzMvNIODuw
	BQZMXhUU8UcXMlTwBSchBY/Q3RxpZ34RYTFPeDPSHP0+4BdxFqvqNMzgJljjUiW4P3IvF7
	VSyXhMdWbFLyTpkaUgHwxNxmuo1DBdA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B52A60054;
	Mon, 30 Mar 2026 10:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF22C4CEF7;
	Mon, 30 Mar 2026 10:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865540;
	bh=lxXvlQh8xQ0EBf3to4Jw9wikE7NXPrSIjYbQ7Uoyt4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS25XSKyFpLRnOPX75HHRFZnJUfjixxOpkn2kTiFc06LCUfoedxT59el843/Qqbu/
	 hdj96YV/8MKR8RoOHQO3cSOxL6i1h6/pKmv6pMaaVH09KWfD5LC5NpJMuxZyRhHNFv
	 OPlzbePKfMxLK71YRJjPAYBlBZNj3ztqyu7ADE3u4UK3sB8wOqPG1x81pa84IfP5ck
	 FAIYO65JKH8d2o209unwereERqUUjHXzSUydWn7nIIsEDVGMqCpbCsVMbTOPNpwHpk
	 HHJWD57DRZBfCNIdGHt99Pagc9jwhjvb0DWX4TxU51aQTEKG4dga61EpmCXGcZTjfO
	 ovs80lRwcCs4g==
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
Subject: [PATCH v3 08/15] shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
Date: Mon, 30 Mar 2026 13:11:09 +0300
Message-ID: <20260330101116.1117699-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8781D180002
X-Stat-Signature: du9q681kykyjxnnztubrmkn5sp1zo8a9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774865541-174723
X-HE-Meta: U2FsdGVkX18OPho0xws9bGvQfG2DwG/x8mRHOJaht1+IDoCf2XQIRKEOMaFHjqB92R6w8hNNtmAFKkyqQOG7Ih8K3KXahM7VzEiPgHcru+3zdLqX4X843Fqw7QETQjPHILpLlecIHFLtc4jHZH1Km1VC2DNcGWzqFND9QhSJQsTA8ZGAyZ6Tv+cCBQmFTJ/+Cqtz86wEyLRcZQV2hzebd6Scdv+Lo8mcoFzDxHK0+iAlgmb2nyZFdIL4OVlq6czpEEiqpNRnEDPUQ+WB1AhkJiUgXgAIB4/zJEXzI8K62pojBUzGE1i1TAbQ8kGGrVQytVcfAFZr1Z9s79Pz/iXW+Atyo1fbQ5hYm9BO06ojDBsyNpxL1proOINdHhItF6ozM7iuBpKIA7nSdPTR4WVPf9cAhgcWMd3IglZiN6qa1l7byIdsjRV9PMgYqSQIbnivLd6kbTIxmTCa0gJm5WazZNrgn2u8dg8GY7TS1Av2E2dlLh1XAmZD4I/2j+caVMbrugloZMWyuCu4zg3Wq7k3NfzS8c9giIwY4ELNEflAS5QALi0fm1D1KBC7cG5GiKAuj+ounkqVGDUlV2JRw9S0/7kHUUofKdc+iZ8V2Iciv/pDwrpCHFG3BIktCsx87z2o2DVt5SnvsTWGzvcYriQV2GOqlTDDflEDVwHiJXS1oelxGLMMyEXjemqyQ4AByL6YG7Nn7PM+Plhb+xr1z1dFrWtC3lKIP6vWzQ7hthQF3pFdUrCwpbUlrsRsDTkhULWJu0wNwFgD4vLrXPNK8s/5ZnKZZvsIBgOlsx5dxJ6J2yxPXA1bdjnOOqNw2+5/E1WtAOWaFapVxgsXrxvludUv6Qc7t2lZ7F5fBdabp9/mP2efZIl+1RcP683hqv+JTX4ziowuZDKZ519j3y6+6wOB1/g5TJxBJ+Yo3iOfyYfbX8ON2L/1ggRiXOetXB2FZRw6XjkS+DFy127GLNbQqBz
 nTf2rI14
 Qc8aN6JcAhvVIeA+U9nEBjWk1s3A/36dILlToNLnhNshf+SpTqUwhPZgvrgnlm6e9+40aES0xhvAZKfCk6DsOQ0iKUPqbZuh82Lf8lpCmF3n6YIoK2MT4FDoGgxobJqfy1wbOCgFb78hL4FlhcPVFmI4LSuOW8SikuEbzTAphgBSfz+GQK8gYoEVZnox2+tFeZDiF8TOvZoXRU7NXChL5QSvyeBkKjOuVo9EZiNLcosVMQPj/S4Gn6qY7jzvw0qjoLdk3MxsqSw5fPLVE648gGDOxV3yYdu3UVKnpAnp89Codoe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
it needs to get a folio that already exists in the pagecache backing that
VMA.

Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
method to 'struct vm_uffd_ops' that will return a folio if it exists in
the VMA's pagecache at given pgoff.

Implement get_folio_noalloc() method for shmem and slightly refactor
userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
this new API.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 include/linux/userfaultfd_k.h |  7 +++++++
 mm/shmem.c                    | 15 ++++++++++++++-
 mm/userfaultfd.c              | 34 ++++++++++++++++++----------------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 56e85ab166c7..66dfc3c164e6 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -84,6 +84,13 @@ extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+	/*
+	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Should return the folio found at pgoff in the VMA's pagecache if it
+	 * exists or ERR_PTR otherwise.
+	 * The returned folio is locked and with reference held.
+	 */
+	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/shmem.c b/mm/shmem.c
index f2a25805b9bf..7bd887b64f62 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3295,13 +3295,26 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	return ret;
 }
 
+static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
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
+
 static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 {
 	return true;
 }
 
 static const struct vm_uffd_ops shmem_uffd_ops = {
-	.can_userfault	= shmem_can_userfault,
+	.can_userfault		= shmem_can_userfault,
+	.get_folio_noalloc	= shmem_get_folio_noalloc,
 };
 #endif /* CONFIG_USERFAULTFD */
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e3024a39c19d..832dbdde5868 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -191,6 +191,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	struct userfaultfd_ctx *ctx = state->ctx;
 	uffd_flags_t flags = state->flags;
 	struct vm_area_struct *dst_vma;
+	const struct vm_uffd_ops *ops;
 	int err;
 
 	/*
@@ -232,10 +233,12 @@ static int mfill_get_vma(struct mfill_state *state)
 	if (is_vm_hugetlb_page(dst_vma))
 		return 0;
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+	ops = vma_uffd_ops(dst_vma);
+	if (!ops)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+	    !ops->get_folio_noalloc)
 		goto out_unlock;
 
 	return 0;
@@ -575,6 +578,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
 	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -584,17 +588,16 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
-	/* Our caller expects us to return -EFAULT if we failed to find folio */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
-	if (ret)
-		goto out;
-	if (!folio) {
-		ret = -EFAULT;
-		goto out;
+	if (!ops) {
+		VM_WARN_ONCE(1, "UFFDIO_CONTINUE for unsupported VMA");
+		return -EOPNOTSUPP;
 	}
 
+	folio = ops->get_folio_noalloc(inode, pgoff);
+	/* Our caller expects us to return -EFAULT if we failed to find folio */
+	if (IS_ERR_OR_NULL(folio))
+		return -EFAULT;
+
 	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
 		ret = -EIO;
@@ -607,13 +610,12 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
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
-- 
2.53.0


