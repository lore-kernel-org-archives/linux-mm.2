Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81170CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA0A6B0095; Thu,  2 Apr 2026 00:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B7F6B0096; Thu,  2 Apr 2026 00:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8EE6B0098; Thu,  2 Apr 2026 00:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABBD46B0095
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F2AB58941
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:43 +0000 (UTC)
X-FDA: 84612294606.12.926319D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF2691A000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb8I1ZCl;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb8I1ZCl;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103161; a=rsa-sha256;
	cv=none;
	b=c3MQyvbOYUeSHHXzvE1lin/iphHkOwaf/mW9lfJdJmTQFPeU0dtShTaasfuqjrMQfLTQOG
	DQ8Td1jSkoTg80aXBksKVervd3z0xbvMyiNExOfRw1hjJ91d9Jf2aDC0IUJmINqWGxGRCb
	tPHCV8b7cQXeWTwL22OSfseNdvA/d30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KG9O15NEX//F7Y7M34uU3bVy0OPGvFNGxrIfN55SF7g=;
	b=IoIqhmLWfmA8QbUo+j+cNUM7Sd55lp28uew+lrrL5F6QsgMTXXrfnbHEur3Q2cVtNBFjQJ
	DX5J/Pa4iX3X3g2FvCkQPj8SQzJ47U3n7MwuS28M074/i0Cj+unnxJfYI5ZR3fAZ6sflzG
	9cebZtxD6E7S96xNHh/yKilUA3mdEaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5D51437A3;
	Thu,  2 Apr 2026 04:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63406C19424;
	Thu,  2 Apr 2026 04:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103160;
	bh=5SzGyiFXZk7l7ucReQ40iRkaPGcy2CcX6r/21eMkk2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nb8I1ZClTDvPDGKxLBHAn3NCmEgGMU/AnhVCCtaCop4gpA26w+lGeVCMGevXI03Z7
	 ouBoPoNz1kFRSoUMyRWbj1Uwc6X15ppsOD1eoF7JwetBZZkgI1ZHeU62VnAhCzCpdV
	 CgElsa9j93OX2uIsN8NVJVA1uAtcfmhXIYHd7hzfv5sMbFTLGYOor6KuIM1dcmms/p
	 2a0yzV0XuFg42PyKC66b+CK3kiM9NjbZh8qz+GI0RQX8A0MyIF++VDQ24nPRn6dKU8
	 da5kdRFrmmwwVlmhYmd9FFBvegTJuX2GBYV+d7U1E8pq8yGjXiCQIJ/Y82soByxhIj
	 z1dktaok5sFiA==
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
Subject: [PATCH v4 05/15] userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Thu,  2 Apr 2026 07:11:46 +0300
Message-ID: <20260402041156.1377214-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF2691A000E
X-Stat-Signature: i9f9sbikx1q4yjjb7odk6m7s8ruhca3k
X-Rspam-User: 
X-HE-Tag: 1775103161-459958
X-HE-Meta: U2FsdGVkX1+GGzGPABsyMRD/+D9uMYiKzHcj40ELStFtc8dcd0Mt7uYtIe5zbWU9lNqTooGOMNrCLQp/gG7jnjpfC6ccEQFHEphM2Xuqk49GE4ex+s0BByCt/bA4+N8L4BlkUcAoxfI9KXtj77qdQoBT4411+wYYCkVLmAn4V/ZGhPjNSKQP06axReta3AXvyu0XLsZe5S0w2tKad83X4AyvooXcGbHZ/mhMWKGQE7i68QlgLPzNJoB+V8bAdaNZeAG/YtkFvn5UqEtbwlKNhoQdIYKraHoj12JKlfPtrFw1RdepBHvn8CYEKKorZST7cgijDtpeA3KNAdRE9l4holbZOVa6fBgD+XwJhjK6FKeYtPtU7f/b82UnFRUj8sC31B5zwLCATOdRurwOBrLZWiqOQoKi7kuN8evd4qLL1qd6vxmql9j4FezLTe2dqe016CSusD5LyCcSze4k7leFeT89ARNDwz1c1U7zJ4BTVbE+Y9qde4HMW1BqzBUFSTC7kB5uENzpu397b2LVpAoeNdBfuYxJmYrB59Abe/8j1SKMKf12K+jmfa8CHFCGMuwMORagbvWL5/Bw5COB4rasNDZc3rUmvUff3WL0mSzxEaUrxTs4oGnMcBoCK38SC+3BILPPHveqFB9l7H+piGFJhRhF4Uzx6L3o2/j1PmJsrHt6V4vGh5nRzTxHBDcP0nV8gdLBPaBol/nDfDecHI7qc1LclPgvBQbEfLEMeAMIP4ITIOcd6eDY3GX7nKfaTwesVcAb/oYTMQ8wq4cMAaz4IAor+1VfOL3kR+JBhi8U+Hcfr+LB+tv2r4dx24kbaFx6R/5FE9XGyfee4RFUhQLRQu7bRwT5AKJFrXwfHB/tahmgP/4ajEl2ltzHMmwCC5o3b1CAhJD4C19ULt9MDD3sO1lQ2T8OzjYv//aQwJTFpyRQz/vdGq/aKLMU70YxLMzy1VcuCPPC9bMXLTFcTkL
 YGcRmjhQ
 xDo7ErXEzY6D9CaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Implementation of UFFDIO_COPY for anonymous memory might fail to copy data
from userspace buffer when the destination VMA is locked (either with
mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the data
with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it never
happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for anonymous
memory.

As a temporal safety measure to avoid breaking biscection
mfill_atomic_pte_copy() makes sure to never return -ENOENT so that the
loop in mfill_atomic() won't retry copiyng outside of mmap_lock.  This is
removed later when shmem implementation will be updated later and the loop
in mfill_atomic() will be adjusted.

[akpm@linux-foundation.org: update mfill_copy_folio_retry()]
  Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/userfaultfd.c | 75 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c6a38db45343..82e1a3255e1e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -405,35 +405,63 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+{
+	unsigned long src_addr = state->src_addr;
+	void *kaddr;
+	int err;
+
+	/* retry copying with mm_lock dropped */
+	mfill_put_vma(state);
+
+	kaddr = kmap_local_folio(folio, 0);
+	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
+	kunmap_local(kaddr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+
+	/* reget VMA and PMD, they could change underneath us */
+	err = mfill_get_vma(state);
+	if (err)
+		return err;
+
+	err = mfill_establish_pmd(state);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	int ret;
 
-	if (!state->folio) {
-		ret = -ENOMEM;
-		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr);
-		if (!folio)
-			goto out;
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
 
-		ret = mfill_copy_folio_locked(folio, src_addr);
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
+		goto out_release;
 
-		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
+		/*
+		 * Fallback to copy_from_user outside mmap_lock.
+		 * If retry is successful, mfill_copy_folio_locked() returns
+		 * with locks retaken by mfill_get_vma().
+		 * If there was an error, we must mfill_put_vma() anyway and it
+		 * will take care of unlocking if needed.
+		 */
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -443,17 +471,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	 */
 	__folio_mark_uptodate(folio);
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
+	/* Don't return -ENOENT so that our caller won't retry */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	folio_put(folio);
 	goto out;
 }
-- 
2.53.0


