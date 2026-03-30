Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C29AFB3CF8
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118726B0095; Mon, 30 Mar 2026 06:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C87F6B0096; Mon, 30 Mar 2026 06:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3376B0098; Mon, 30 Mar 2026 06:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D92C06B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:11:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85460140606
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:36 +0000 (UTC)
X-FDA: 84602312592.10.53B5A4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0ED98000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNyD+lRi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fVNQITXaKPhp1TvGhahEVbTKg2c4l7V/Wc6cTAIBa0=;
	b=ZIpGGldSHrRLfS3CprqiU3fPz+OM4T8gDm6nyyz8MJtjBihmKHBO96FvQX5SBAYNao0Xgr
	tzCe99by8BC5wAoLo9iWao2VPUnmxCQoHTk1H1vuH0y3xE5LwH7L1dji46XaExUqQUERGa
	1XeZ3Px5msYrSxON47zMlZQ8fzTLSd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865494; a=rsa-sha256;
	cv=none;
	b=KlTKVhdDRaQ45yQ+WjSGVh8R1MAIrUKreaCZ07rQF47yRMRcYrMh9+B/GQkdPu7nv7EzQh
	EBV2ATtxLsEhcHYR3vB+o84vCdmzkJ48e5ud7cH1Tp1sxJYQ19YXvsRwfs7k17lswNXVN/
	apoXGjsG2YwXJDp1UBdbkuxvCObAX+c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNyD+lRi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B44AF432E6;
	Mon, 30 Mar 2026 10:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E06C4AF09;
	Mon, 30 Mar 2026 10:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865493;
	bh=QyXpu9HXbfbZXv1V/Q6cFWUb/O2hxT2SCUEnl/mL9Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNyD+lRitJL6FQ08aJ2Ko9YEkn9XcqCTCToMIMy6KXBGYHirerrqpnx9wQJ/lbQUf
	 jrjAH/939HGIiB+8//xJ6BkneVvgQgOOgrdOykR4LH2DxFcm84JgXOdgO6R6qN3eI1
	 fvzfe5DRsDPoqMPWtX4PgjizstOvrWWqRw4kYAJ+vnLsPYo02rCuCY0ghBouNvClfw
	 nbZvA/MDezrrO0jmOynPpaB4RfA6Zm3JCOPztbjhB2LpcahiUwF/LJkbKbNDyoO0zo
	 S7kU7amZbd7ez6V+LWcgIvyX25AoJjwsorPuTIcrD46phatb3RO/99PEaJpHoDmI9f
	 AG1AA5cDImkQA==
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
Subject: [PATCH v3 01/15] userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Mon, 30 Mar 2026 13:11:02 +0300
Message-ID: <20260330101116.1117699-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0ED98000A
X-Stat-Signature: r1fyhma1tbdfi1kn3zbanz5cin53q7t1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774865494-380945
X-HE-Meta: U2FsdGVkX18K30bwXG5BiZCMGsvZskMLTdRg1phD0Ly2ywzg/efl6/HmktumKXK8pHju3cSOcqS06Omsyhs/PN3OtdYCh0/8kvAIHgOU9pbHLem/94TT1nFYd+HHmXWfCLdDhIsOCaU1oFsQzd0i7Cl1WLq1bEafU+t24Dy3AybmgfMJaipmIr2GuLJUa339b/IFSm9mFLXX1bo35SR2bwwXwVbiLdxXkuiE9CijBubM2TAPEwNA8R4LcFkjzU+BPC8dHazk0lJPy3We6s6jzDuk1CMkc06PDtMT9r6eab3mofkWyB1QhQYxFboR86hXQLicA9WIa/xKsZtW0QGvcVgiatVPuDS3Zz0tZNA6hl3NQZdWbeKqN/hL9fBQ7UfvD/67pCT+WVA83tLdPBXBZgvjqRjWk1vF+hRGfWzi86P20cbh7I9+iqJZhG1BBN01nCp88pK73GtTFQ+2wqc5bs4LzI04wIz+xSbqWZb4DHC4ddMCazXZg4IpFMPUgSXdUlMRv1P0sZvCmL9tUWlyJU4gswfqyGXINW5LYGEyxKN/hA/CdAQsW1b8sfXN39yyLDcxg3ad01Dg9ragRn9LQ6IqkxgHYDk/yO20qYBg2XIJkXcAflYQWomE4jhNQRs8v/Y2w4Qk3JFDvTK0TbAytlwHGm0LrBBz4bLqJQL9L7Xi+TGHo3HuZWW/ICXbnNJqJT8ZeFIFGABVuDD7wl9N+XveinePYzcZ6V3uCxnk3sH0aSiKYxD7yjHEZzxnljv6z1JAOYqsb/e3ZdI01UfIcoF51rLDZnrDCRdvHr8sSX+SHmx5YZhGu1d/bP9JGNV0K1Q9ifPb9eKNZB+XI/QoTVm/8pSjtt7J+tVq+SvaN65HfXu4lZEIeQN5bzQs484uKp0kUDw0z3acGzO8u6flMn8LMcxJi+uXAoAnU++PPVPShPOuaaozEJDx2c50WxXJTGY8pQf438kGn9fVpY8
 5wYyJaty
 qukpHpBs7soXzXnXeSwsZyOKQGC4xb+lU9Bi462HoxBV/WkS3X+sauqm+XyhyrBVh5Gs6A3Y3CLlECovMyfPopPgB45alYLvndhhaPdyju6B0W7XvGv9tvjd1i67N4oAkVuF74qIjMbDllXURc01S0ivkiKwHn4BnIDQ9p0j0sFsGoFpX3C7r2B7nKeKgowqc3P09u+xSoJDlGw9CIgGs1E9gdoyBFd7Q9ndiGSFVuQxqzDClzAU+Xa6Ic3OCJc5kJ9ak6igVHLgfRCx/zFDSNDXq8rUsY6EXUEbeuaBbcBuKYZMLSbp8jiG7BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Split copying of data when locks held from mfill_atomic_pte_copy() into a
helper function mfill_copy_folio_locked().

This makes improves code readability and makes complex
mfill_atomic_pte_copy() function easier to comprehend.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 927086bb4a3c..32637d557c95 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -238,6 +238,40 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	return ret;
 }
 
+static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
+{
+	void *kaddr;
+	int ret;
+
+	kaddr = kmap_local_folio(folio, 0);
+	/*
+	 * The read mmap_lock is held here.  Despite the
+	 * mmap_lock being read recursive a deadlock is still
+	 * possible if a writer has taken a lock.  For example:
+	 *
+	 * process A thread 1 takes read lock on own mmap_lock
+	 * process A thread 2 calls mmap, blocks taking write lock
+	 * process B thread 1 takes page fault, read lock on own mmap lock
+	 * process B thread 2 calls mmap, blocks taking write lock
+	 * process A thread 1 blocks taking read lock on process B
+	 * process B thread 1 blocks taking read lock on process A
+	 *
+	 * Disable page faults to prevent potential deadlock
+	 * and retry the copy outside the mmap_lock.
+	 */
+	pagefault_disable();
+	ret = copy_from_user(kaddr, (const void __user *) src_addr,
+			     PAGE_SIZE);
+	pagefault_enable();
+	kunmap_local(kaddr);
+
+	if (ret)
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+	return ret;
+}
+
 static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 				 struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr,
@@ -245,7 +279,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 				 uffd_flags_t flags,
 				 struct folio **foliop)
 {
-	void *kaddr;
 	int ret;
 	struct folio *folio;
 
@@ -256,27 +289,7 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 		if (!folio)
 			goto out;
 
-		kaddr = kmap_local_folio(folio, 0);
-		/*
-		 * The read mmap_lock is held here.  Despite the
-		 * mmap_lock being read recursive a deadlock is still
-		 * possible if a writer has taken a lock.  For example:
-		 *
-		 * process A thread 1 takes read lock on own mmap_lock
-		 * process A thread 2 calls mmap, blocks taking write lock
-		 * process B thread 1 takes page fault, read lock on own mmap lock
-		 * process B thread 2 calls mmap, blocks taking write lock
-		 * process A thread 1 blocks taking read lock on process B
-		 * process B thread 1 blocks taking read lock on process A
-		 *
-		 * Disable page faults to prevent potential deadlock
-		 * and retry the copy outside the mmap_lock.
-		 */
-		pagefault_disable();
-		ret = copy_from_user(kaddr, (const void __user *) src_addr,
-				     PAGE_SIZE);
-		pagefault_enable();
-		kunmap_local(kaddr);
+		ret = mfill_copy_folio_locked(folio, src_addr);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
@@ -285,8 +298,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 			/* don't free the page */
 			goto out;
 		}
-
-		flush_dcache_folio(folio);
 	} else {
 		folio = *foliop;
 		*foliop = NULL;
-- 
2.53.0


