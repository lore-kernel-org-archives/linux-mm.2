Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE24CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09246B00A1; Thu,  2 Apr 2026 00:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0C66B00A3; Thu,  2 Apr 2026 00:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1DBB6B00A4; Thu,  2 Apr 2026 00:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B357D6B00A1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A3D1B8DA5
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:10 +0000 (UTC)
X-FDA: 84612295740.23.C35349A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B877D100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jRmA6e+4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6OUUEyWX874G1Pjz6/BYPXra+/59w4Q5cUZOgY1teM=;
	b=OE8R6e1/l3sXxwCkzoqv6fwsG9pD9cloxkKSETiYKJNNA6LP5KuQDB6lk7HajaWnIL2Ev7
	+l9wUfjqPKI5BXn/EjXhd7tbEJC/fNMej2ysDx0jRxWfinwZY+3pEXy/Vj570A/bgiRqh7
	ejRSIp9r8WN74u0uTrJQbHrhyaspiSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103188; a=rsa-sha256;
	cv=none;
	b=REMmffLKY2tK/hYLIRI0NA/IdQKA1SY8Eo+8+9ZffEbsjWUpaqCpN99E4RlUahP6a6LiQN
	Vk+z3O9ADZY+bnF9se1kuWfSmyp2Tf725XpbHBenehhp7V4ORmlAaYTj5IdBYu/IrDx5Q4
	F7UKh1eG1WD0ujn6Q/uNRJCTx8HGG1s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jRmA6e+4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E35D2435E2;
	Thu,  2 Apr 2026 04:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829EFC19423;
	Thu,  2 Apr 2026 04:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103187;
	bh=Ye6Z7TrGAOPgV52cgsTw8VTKwOK2VRWtWU0AJXFZvYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRmA6e+4sI6CWSR9vvx2sEwae/Tyg7OdWgDWdkkAJFLADbySZ3w+Kc8qIHWijyYyt
	 td9MCBLaKdb3hyaXy02gu20EvmzZBDuuI0ToIaNoDa+tsc0I9v+0G5ugQIk24cNKD+
	 AJF3CpeE0Pa5rXKocaVkb7XlBwvPjSJso9uiDvDfRIAuidLrSvXdo3p4FoVSHkr/Yt
	 akIdcT4DA/H5AlfRVGz0Vt7EXbuoIIz4Z81yyg0DtMVnL+sNHatuHUsw4idz+ja8Nu
	 P205Jo18lZ8hRXOvp/l/MPYLlQlGN1Q3CFHpgbgac7eCwkc9AUEYgtNg4dlcYwLa81
	 DzwMaDHl0HrlA==
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
Subject: [PATCH v4 09/15] userfaultfd: introduce vm_uffd_ops->alloc_folio()
Date: Thu,  2 Apr 2026 07:11:50 +0300
Message-ID: <20260402041156.1377214-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B877D100005
X-Stat-Signature: 4fef7d7zourbnkh466tynem33kkn9w6b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775103188-129844
X-HE-Meta: U2FsdGVkX18wjYo3fX8bdlN/d4bhgTSBtVzyYqnXMnf7qJmAAz6UBzLvYn+8x+OPilIINEo2IPqHRBkr2wmjOI99bZIjtPOnTf7HJNUmjyXXexbXD75aZfOyvcUzqSFN9Nwdm1RKweGbv15g9QdCZYj/lzNc7Oh4d+op8lCerc9tEoojtHPWkdN7prTeyxM6qggxg9Xmuza9XVvlgP6aNij/J0HEQA+LYU0m7imQwiOi6DTZrEQSb5dwIrGt01U7vKRoY5Y+sTHu5WvZyHX1kQL86fjAaS1LkTIMQWwoqPr6FSDk8qRRrWPODstMDmUdwtPFusfJb8mwdmHK16hdLUAyDIV7JgMlrYeuwPWiD91rv3LUkhGHj52rwK5669HNmBIcU9VuhpYjIocfA2YkuvrtyabW8HbRAPsdUkmTbe+TajqA8wgpBpmHxmz9CUqjnAne71b9twxjtn52BUiaJmc26HBrEwWFoeEUbRlJSsiLmLQDq7L255Ch/V6WHWajOQjQFAdvWAlTjrsgnkh7dDBSixYDYggk50C8ZbOlWAz1dCpqRsK4McIEfHmriRrePE7hl4uaIYAkXj2c7mGtWwfdzDlFTn3dopIGfftX1KZac8l0bTiD6zhqjfxF2W4zkCuTj+Sbk1JrxlhY5BVC7ytzjtB66Ub6le0ldG1oQT5vWQ5vSWkdhpeaf68V5FUt0NJGnuoeXjJo26UULqUmJOz8NEN7cWCzYhMNgy/TJnimQs6+Wt/I4UCW3K5cgK51RW7ouF0e+MkDpomRFOpqoa+DcGHHRDwc4GAZMi0/1xUEYP6FXT/4rmRHGAbF+V9FxCXJKZQJIeFPyk2NKVhmfiSH3NGQinOR9cB3LrHUsUcuX0biYWqrZ4/f2Qk0pDzHMxmDRPmDuvpwkpBt/fNnxlNTShIaH985CmiaPaLig8eoyaY1GVY+NS48I8wDtrlI+T/b6RxDskoz5yhR4aR
 Kp848jxl
 Rnr0iWF5mBMSxBzqLbaIFyI8TwqlBd8H7LoLzjRI+koKgYTGRE8Ih0eNSmzv/puJAt0aXiHL+b/N/5PoJh/9ZbLHz1psQrT0xXwwf/uEIFH8Mc5ne6HL1zZefSYLdpZUz2GCmEFjGzfa9Zby6M9/0W/sDXiLmBT7O4LYsw5TkGyYbnMa6xV797dg3q3gC/LFcuHtIdwuv6hYP8H794AkEkcDbXqHAot+dm9MG1cDAUXl1JxfOWqZUmRHRg5IYD2+goObVlTfe0/9dTVx42W62M9io+60+YN7o3e9OkZqg6CA5s1BSCc4YxZ2ODw==
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


