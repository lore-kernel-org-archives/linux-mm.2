Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B41CFB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04BA6B00A6; Mon, 30 Mar 2026 06:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4D46B00A8; Mon, 30 Mar 2026 06:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D7E6B00A9; Mon, 30 Mar 2026 06:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 814766B00A6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32194C2965
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:30 +0000 (UTC)
X-FDA: 84602314860.21.0098D2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 633EF40007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lu59ZX2u;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6OUUEyWX874G1Pjz6/BYPXra+/59w4Q5cUZOgY1teM=;
	b=idTNd0rq5cD3HFzvre/ht073p5GiPH9P+2uzW/26kOVNhLAI3WZ6RB9j16VJ+EWm9qq7Xb
	4C2cIkGuIaln9OaLrkP7oJ8sP5bipD3rxZ/Y3xp/97mT+h1sFGLVXGA02LdANv8JC2L5ko
	SZW46J/UJasvqUeGhPo03SYvhc6x46w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865548; a=rsa-sha256;
	cv=none;
	b=tjafob0sQjhD1VS0X/OqGcVMgsht60HyNikUFpK875Vz/wlnMM2RAEXUb4mHv3EeSaTNbk
	en5mOzdFCkuNboILPcLutRzNd2BnB1YRzvWfZ8W7t5OKhadfr4gXTReg9lUssEWmQPtHhN
	4BjisMvLm7F6ScMApxmCfXTf++2Ev0M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lu59ZX2u;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 926B040A5D;
	Mon, 30 Mar 2026 10:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C476C4CEF7;
	Mon, 30 Mar 2026 10:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865547;
	bh=Ye6Z7TrGAOPgV52cgsTw8VTKwOK2VRWtWU0AJXFZvYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu59ZX2uIJSAIeywrbsygWg/5qzBa3IGe/RNVZ7WYLUz4Xw5N5r0bIAABe6VFbP8O
	 NtvKLDmvOZTz7qbBMsAPf/3U5xw7mvmT14XtWNEFof/m2zDo3fr2yPWC1tOqk9f9+y
	 ELzQHIM5cBjVZSVPFUkiFgzGXGWXPBRk6Ig9Kok7voNr2Q+48CH2wFCbk9Ppf7Odsp
	 4mBV6rOhbzSAfBYSXV9ppyddFAaRhWFeGAPj8AKJP6mU3btMnqVtJV9pHMdnAitQVX
	 LE6JlgEMOx98MNXXHElnfiP4Ss2smtFP/c27xZsZopXraSOUFqIynaqSs07w2x3gdX
	 ZFbtPlVAcNraQ==
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
Subject: [PATCH v3 09/15] userfaultfd: introduce vm_uffd_ops->alloc_folio()
Date: Mon, 30 Mar 2026 13:11:10 +0300
Message-ID: <20260330101116.1117699-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kozhodnzypmbekj3364hygqs99k61e1o
X-Rspamd-Queue-Id: 633EF40007
X-Rspam-User: 
X-HE-Tag: 1774865548-708581
X-HE-Meta: U2FsdGVkX1+wKmUYfeRMYPhQcXCRmTKdmTRyps9Li2/myPPixEiFd8jX6OSyHTVta321KaHYzH1+t5Y9u49DUEWTNNaEjqDmgXpznzTqEG5IreAkMsQKCN6pwpn1zo4qkPnL0EbgTShuoRpejP3Zsl+JYvzpaaWoug7mGN55eab2lNg6PBM7E3McKVVNixRgQzVg6/ZpspUaNPcZEnlaz98aka3wFJwhY2BZgi5YkqqZfgrAJP1fbpAdBjH0Cx+/qcA8vO7wKh9aEJwO5QuD4rG5JYeG/IMbsS7+4f0HaFakRVRuWXJAw7aveme9y+QeGGCwwMwUqIlHUg4eZ720+/RblVFMC52uTZEFA5MomePkjREeyDpRIqwwsy03DlfHAiZt5qwRjInoKjZgi4wTgJzLaMV8G76hFoE09UWjoY12U+I/cr71vlP91Sp+HBsCa5HdtLofBbICPkPYPXgJPb4++DGSUw/JUHJMafg1GzXqIoRsHY3MIjGtbavNprKgNYxzSSeCLI4BByC0w8LeSOcHwJQP1vCP/qttFZGlwfYYgTTz50e7NVj12ZtiM65X1yXyoKNRbBfY1zh+P4SoROdf1fafTSrYXrb7sB/wFscAwSOwJ3KraLYYjBxmXqqAHBdrgUFDBp6hVr8Zvd2J9QwBtcDsaAXkfOB1H04AoTLXHNgqB9KkxcOiUZ2oFxBKkAXDLhHMB72y2Qdn5XYPI66AOVWjftnx8mIjEolhiY3WcVg6ifRwR6EuCVdAoihOSTdOMpmDB/7i31//ScX3SZCcXRE+X6OGRkMoUMEhxdNfc7lLPZpNl85v2C6Mdcr4LazAS5mlUXxkR7fF/XZzHNfhiJw67r1w+p5+Yp5pvZ+Oe2ERCIT7qQhMDrGQx7ztA3g4fVrLBcTb1ZLgWCNWe1zayiHZMjemvnAv2n/F0ABs/IsW9BfnNakquQ2c/IhQcJmsWAXKKskXIgJ322C
 /prxJJAT
 FCCWMD4G/D+135lA4KluxGeCBHsTJOc55iYy4z5lx6kuAmVF/Bt3e8G7cZ4SHM4HgvzLAU5vuyPxChhvv7Wy5ucRHQpiYEn/lO8kNoYS8uBqiAOjBjwWcHahV6qRLRHTi8k/jyCQcl3tcIkFAzk3+jicWqLKs+AGmLe7zd4iYv8YDMssCcWpsSJ79z1nrxUncv1ppRQCrLRu4gxXtADKkF5mv6sxlr8r9hV0us5EBiUNzBDzTCWbbkd91hExsmnGYlTR83HJeEMWYCtLP5+QcZLk0qGhs41X134U59xE+OAwaw4oCg4Xy02f3Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

and use it to refactor mfill_atomic_pte_zeroed_folio() and
mfill_atomic_pte_copy().

mfill_atomic_pte_zeroed_folio() and mfill_atomic_pte_copy() perform
almost identical actions:
* allocate a folio
* update folio contents (either copy from userspace of fill with zeros)
* update page tables with the new folio

Split a __mfill_atomic_pte() helper that handles both cases and uses newly
introduced vm_uffd_ops->alloc_folio() to allocate the folio.

Pass the ops structure from the callers to __mfill_atomic_pte() to later
allow using anon_uffd_ops for MAP_PRIVATE mappings of file-backed VMAs.

Note, that the new ops method is called alloc_folio() rather than
folio_alloc() to avoid clash with alloc_tag macro folio_alloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 include/linux/userfaultfd_k.h |  6 +++
 mm/userfaultfd.c              | 92 ++++++++++++++++++-----------------
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 66dfc3c164e6..55a67421de0a 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -91,6 +91,12 @@ struct vm_uffd_ops {
 	 * The returned folio is locked and with reference held.
 	 */
 	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should allocate and return a folio or NULL if allocation fails.
+	 */
+	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
+				     unsigned long addr);
 };
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 832dbdde5868..771a1e607c4c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -42,8 +42,26 @@ static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 	return true;
 }
 
+static struct folio *anon_alloc_folio(struct vm_area_struct *vma,
+				      unsigned long addr)
+{
+	struct folio *folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					      addr);
+
+	if (!folio)
+		return NULL;
+
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(folio);
+		return NULL;
+	}
+
+	return folio;
+}
+
 static const struct vm_uffd_ops anon_uffd_ops = {
 	.can_userfault	= anon_can_userfault,
+	.alloc_folio	= anon_alloc_folio,
 };
 
 static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
@@ -456,7 +474,8 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	return 0;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
+static int __mfill_atomic_pte(struct mfill_state *state,
+			      const struct vm_uffd_ops *ops)
 {
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
@@ -464,16 +483,12 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	struct folio *folio;
 	int ret;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	folio = ops->alloc_folio(state->vma, state->dst_addr);
 	if (!folio)
 		return -ENOMEM;
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_copy_folio_locked(folio, src_addr);
-	if (unlikely(ret)) {
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
+		ret = mfill_copy_folio_locked(folio, src_addr);
 		/*
 		 * Fallback to copy_from_user outside mmap_lock.
 		 * If retry is successful, mfill_copy_folio_locked() returns
@@ -481,9 +496,15 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 		 * If there was an error, we must mfill_put_vma() anyway and it
 		 * will take care of unlocking if needed.
 		 */
-		ret = mfill_copy_folio_retry(state, folio);
-		if (ret)
-			goto out_release;
+		if (unlikely(ret)) {
+			ret = mfill_copy_folio_retry(state, folio);
+			if (ret)
+				goto err_folio_put;
+		}
+	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
+		clear_user_highpage(&folio->page, state->dst_addr);
+	} else {
+		VM_WARN_ONCE(1, "Unknown UFFDIO operation, flags: %x", flags);
 	}
 
 	/*
@@ -496,47 +517,30 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
-		goto out_release;
-out:
-	return ret;
-out_release:
+		goto err_folio_put;
+
+	return 0;
+
+err_folio_put:
+	folio_put(folio);
 	/* Don't return -ENOENT so that our caller won't retry */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
-	folio_put(folio);
-	goto out;
+	return ret;
 }
 
-static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
-					 struct vm_area_struct *dst_vma,
-					 unsigned long dst_addr)
+static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct folio *folio;
-	int ret = -ENOMEM;
-
-	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
-	if (!folio)
-		return ret;
-
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_put;
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	/*
-	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * zeroing out the folio become visible before mapping the page
-	 * using set_pte_at(). See do_anonymous_page().
-	 */
-	__folio_mark_uptodate(folio);
+	return __mfill_atomic_pte(state, ops);
+}
 
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       &folio->page, true, 0);
-	if (ret)
-		goto out_put;
+static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
-	return 0;
-out_put:
-	folio_put(folio);
-	return ret;
+	return __mfill_atomic_pte(state, ops);
 }
 
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
@@ -549,7 +553,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	int ret;
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
-		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
-- 
2.53.0


