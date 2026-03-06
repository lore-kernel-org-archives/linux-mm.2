Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D895FCC042
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB11C6B0005; Fri,  6 Mar 2026 12:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68116B0096; Fri,  6 Mar 2026 12:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B951B6B0098; Fri,  6 Mar 2026 12:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8C916B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B5B6140354
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:35 +0000 (UTC)
X-FDA: 84516297390.16.5F312D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85A2340010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qlgt/S7N";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0OppPmx2rJax4Z9XcM7Nl0rFuW6t9kg9pPAGlrfPGU=;
	b=B+7C3sHBdYEFjAb8eARTa2OrERQ9N9Zh02k++LMjIhjJjQkeiqIKedXc9c8oVSuqmhltRu
	g/St8NXXoDkqbnj7tF8qinUyaNxrt0LGRENRXaejZz3XTGqu3lhUuYUldXHUPL9US/AnB+
	ll15ym31qKlO8+r1DGA+lqt4dCAMEDM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qlgt/S7N";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817513; a=rsa-sha256;
	cv=none;
	b=WGfD6T9z0jEY6x2LHI8h7mULAC4fu+jtPQU+fc9IJg09YwzJXOcmU+6P9P5N5iHUh/tPhe
	jA1ynUlBf4dRTsbzUVUgfAG+DnVb0hoJTKPwO2hegP6g+zsNlaiRJnzsFMHuHo10k03z0d
	kkCqpvKhsHS67D05rz+/OY3Gm6D3Ldk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DC77435A7;
	Fri,  6 Mar 2026 17:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FC4C19425;
	Fri,  6 Mar 2026 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817512;
	bh=397VT2bfh6JH5zOk4Jxb7yq714cVzynRATwQAJO9BEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlgt/S7NpfdH9Gc2ob6Yr+X4acOZFl+ppk+KjxulPRuaUSHFTt73uEkMag9iY5yIz
	 1GpAvrz0u6jWLxVT9Z22rBux3z43wReozPGjEW85ySNEd3UqjR+SmL5yvTfdTUMx9L
	 XZC4kDjJWwnTx29xciv0A0sFCet6yI935Z5QveQ2t5qv760fRg/66ESPkblNAbqePS
	 K01DQoBLLfXsJym5tB2nQs8RXFzzqr0izenV+bthd2rxCE+/Gj/Lu8IWoTwwV0PZ5F
	 FiRkc3/nQ88NSFaw7E97Nb9fGgjdAZr7Gq8s42T/IdDiSmPXjcojmg/YawtOCP+PN4
	 METWUMJIiGr5Q==
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
Subject: [PATCH v2 01/15] userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Fri,  6 Mar 2026 19:18:01 +0200
Message-ID: <20260306171815.3160826-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 85A2340010
X-Rspamd-Server: rspam08
X-Stat-Signature: qm18owwdfwh1f5utcu4niumsfm531866
X-HE-Tag: 1772817513-815275
X-HE-Meta: U2FsdGVkX19EM5zQHZiEHkZ8KEFKCWJCvF5UwB2UHhA6qDD9u0pMutWUl/CXMt5OUCH9/Xbb69FNkrSQYYUGwYc/iMx6Rv3xe3Yb6COR74to6XG9zovEhsvKhFHKkZEkMBdDCn6PTf7tEonnSxG86MVasVb1T901CWYP4CA70KRVTTL81yH4qhTFHScsCcEm39KZF87LXFDm0sE699TzxGa6P/11A9+pSYVNbhlnFQCwMQ3NeXH3q3+vznuWhA/fGJjk8aVVzDKYXokhyrD4IaAMar0Y+UZkWNVNd5vsdK43jGnuYX4ASim6oORaubVYs+t1ZHmB2npE4XEv172zRfTyg+u55o8UkDbhoOF3wuqkxaNZvbsIcMlo70QEu2pyTiJ83UEEMKmdoMMR8xR+vR5rDVGwh/S4DgR2oGXJgVi3PkGZxNDQs76IiaAUrFhYgeLbE0Lj0XhC5RVhsbHYqb85EEKf8iiz1DVg8HRi8Qw4g1nNOpCHR8Cw2ofiTzE/NV3fo10Ok70j2+pYW0+HyAGIC1fj3K+w+FYY5P5SBUAxFtSwxhltNdicH4umaWRbHjK18SFXgjPfIj6xwsbrXotoa3TNqGk5fNugL84SNu9ITrkOzzlSAN611q/Y3oARKHBQFuDmaj7XkbHMNOAPD8hsy9NOGBU2yutv3eyBr2+WCgez+WVl5Hk6SEBEGTuF+GH96xGY5eur9Ct5ayrye0iw6mMnGHRlhHWfzBLteBjjzoCqvBF7OvklV9zSvcLwNQOHrmCJQG6NGXXF8ZWO9ZsRYUz8M6kAZ5Dv7Dl/Uz5Olpg+9Wnc9cmAIEm14bFG9gv3pTpbUhCRsGPDI58TTht19cslMWDusK66X6UfWrQ/DeUSZMmuYSXfRGrF67y6Ev0JhjYkEeHpwAdOL1OgBT8jZj5f9BQvBzlbYv8zP/yctAswnhsUH23mpgIdjn002r21CFw2r8vI2knchRg
 GIu0g1GI
 sITR/SUfGo+StXpI6nF23ToDw+MHKHBI6vnaaa6WeHkGnm++jhBwSl8XTjY0ZPUT5CYSIGWOnr1g3oItU93GedU/HBhNCs/IVpWcZp2HPjucy0jr/voLgHr4nFjAAGewBjodfb5kVm131Ae0qNydhw2YVhGwB0MhqQPp3lYkH7/XUWSQwtXYcRd5AWLPg7TbSyBbAL0uA+tGKAld/77PIoF+oB5/6HB77O07UtPT6pM/xtCcJEHeE/+92/jGc21LhLSrF2Z7t7vYs64jrh/wlEByIYUrYwycpWwFyq/cSjWS/oKaHGxdMTtLlyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Split copying of data when locks held from mfill_atomic_pte_copy() into
a helper function mfill_copy_folio_locked().

This makes improves code readability and makes complex
mfill_atomic_pte_copy() function easier to comprehend.

No functional change.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
2.51.0


