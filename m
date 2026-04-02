Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26B4CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CDE6B0089; Thu,  2 Apr 2026 00:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F44A6B008A; Thu,  2 Apr 2026 00:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A936B008C; Thu,  2 Apr 2026 00:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 139B06B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF6B5B8D7C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:15 +0000 (UTC)
X-FDA: 84612293430.27.BAE4775
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 327314000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OW4DnM9v;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBcx8QA48/RktzwaPywJDvHNo+x2rijQjSSInu3Qu+s=;
	b=gc9U2NpYhAJHV7qTYsnxmSZriQe4SRhPXIUnS83EKr1DK0ECaKJm5j6RUZ5CJOj772ges2
	CKLinTYdXtTXgJoCcHn2nSACbHJ2onRzfo3R5XHamFaHxNSonECczXewiXTSfrNzuXYXyd
	XnwETb8w6mvHlIOHeq1N8Ise4iy73xo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OW4DnM9v;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103134; a=rsa-sha256;
	cv=none;
	b=bIakWd7DNVjBfj8OwT0R8G55rAzIUKz761XJEdHIAc2w9JA02LE0aJ9dhfAiwF//2vAlxg
	8RT/v4ohlY9kpXKOBMkxoaB+xTCGZ5k1rgUVUE0badKqoLq56saa6BqT5uUXamu+UTnEzA
	jJaW8Dqtnp+HV65FkErZOlgz/1TiMhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B07961865;
	Thu,  2 Apr 2026 04:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1472C19424;
	Thu,  2 Apr 2026 04:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103133;
	bh=ILAepUGKrqJkLKLRQyhDJaBdtTZkSW4gONujo05yQQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW4DnM9vSohN14okui8L6bWH/FbKehx9LYxnEhEvlgJYRmyYfwrbc3+OazmjCUduN
	 q5iaHI6A9ccmJhR1FhbZCdGG+JjPBLnqfihHFmJ6cZmt3a0p012TIIRGR5reSsL1uV
	 +KASP1vM3g1ZLLmdmWuRPfKa2El8WEFMAM6M/Iy683foM+qc7p3hFJNJixI7rqnn+B
	 LeZ5y9uDip13tqI/I0EsNBBV+zqbl/Yl0yV0i+UnBZx29Kf8i2Fz8TEUjWlcwJ87ao
	 nwTWmAC7t6+3EbkEauFaT8goH84O96EtEGMcb+kEu+IhdIBJthKeje94AH1dLDgriH
	 vLLQ40zXYEqrQ==
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
	linux-mm@kvack.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH v4 01/15] userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Thu,  2 Apr 2026 07:11:42 +0300
Message-ID: <20260402041156.1377214-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 327314000E
X-Stat-Signature: k1ecz4sdbp5woozksmdmhyrkwpc63e4k
X-Rspam-User: 
X-HE-Tag: 1775103134-577493
X-HE-Meta: U2FsdGVkX1/XsY8qn6pJ2NFObY+3QWCF9ll8HWtsL/glmzowecAfxmSy8YpWI9Ln7r+YLDz4k+bCwb7RECyukptw3gufDEOBFMOuvvOb5Z0yDr0Vcc+idD+Bml27R8R6ZXh00EUdp1lg4p0tagf6EEzXAMRlXuxhJeJLq45wIHFma0kVrLhrXZusnvw3Apdb/HDfpkewS4gaO86wSQsmUilnqD+kmdyDa3GIUd/m1a3j3RpKmfV/xVNUpb+YDX6U++FLGlXv4Hs3/ROcnMK7+f8j7FsRZZPsoJVVpEcbuZUS2ShCn3otqB3c4OK7MLx2kdY2r6UYJOpp+v0bKsvVd+TsH0wBYS+asslpQPC2SG3u+awg6ARrHax1g7f3nV27VMfwxYt8sW7vFYpyz9abWRJp+rN889Xx2vGpYBxGnDeukYKsztdZUE+W+vVGidejd+6aAcBUIYnjzmi7xkjoz/kj/8ZQF0JsQq2/H1aEtXT1necSzaqJOu6r1NIZDzKU2W7bR31DzbY5tBpL84wpTwOpKc0/wY5RiTVJBIbAwIKfV8ikCApi8tlNVfpIcsa0oHdDmGpa3gRTQxV8nbRFRDqJkhMIAz4AZQylSjzQztCSfwMND9D3phN7aNc9rsrXyRcGbBRvQKP7IcV4lwoN1se7orbLahgMNWhaMs7ebh4yRlS48C4Oon1gyubM3YYHZuOnl0TFZ10r1dXARUIc8eQAT6OVQ0lpKKhLDr7fFFLsyI4XLhd+Vdr0jpU1j3sM/96W+qrBiSBpxIjCQox4DNJ3IylsDNAODAH6BvCRM6zMlqOfFlXfuYOKtcFll5T9Pq8Bsc+rDee1188PqkqmgToJGcSN4zyvvlo6B/b0rv3wDL4LWz0TBY0PEJ8PZ99JYeH0fKSBUClgw9vN7N9LjC57jGtHsRx01gMXhuYbZ/uw5+T2slu9PiE53+4+1Jq2gerE9mMMTqPsRKPPuV/
 o7s0Cuh6
 TJBSEMT2945Tz3CxnANP8tVyrxMvK9utra4IbEEFHIgE2vBoLA9qxXQgGX00PYKiHif1VQNyEwRl9Q/vMAvltU1J/cN6SJh5b0cXeZQSKTPohYmwMTILaH3Prs8qhc+Wro6WU5qwRCfs7hD8HvrnI5J9jdYOaqIt4iNO+jlVdwWN3Szzbc+j9sRobCYx70K2XadyE58Nwf2KRvWimsT+Pxe3uDXAJHjuAfnRW3Om97ABR4gGNyj6v80yZ/JE3ZOtvSl0pOi1LHQGsHafUzNECmnG50obz59MO/3q4RSYY6EmY7/SWK/sF629Yhw==
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
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
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


