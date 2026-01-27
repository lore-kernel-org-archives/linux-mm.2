Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C35D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6666B0089; Tue, 27 Jan 2026 14:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E026B008A; Tue, 27 Jan 2026 14:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0506B008C; Tue, 27 Jan 2026 14:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD2896B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:29:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66C8E160216
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:29:56 +0000 (UTC)
X-FDA: 84378733992.03.EF2EFF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D90094000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:29:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzu2dY0F;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLseMfE2LRuo3JxDLOr0OXcWO0lmhSYypQgOjOmlOCg=;
	b=KQQjuFGvv+I0Eifr+NAqhXOCUXZ7GSAyj+QCQN1fkkzvgDV5S3Z7HUkHFEel1wEAaRAmZp
	J4OQh5hOF/wel/Bxvvw9XiRVYa41GnTFK16QuCNRs1vTn5H3w+px6lj08oQlBGP77MhSw2
	yvoG0ndrTSe5FTPtMmRsiJbQUobpy9c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzu2dY0F;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542194; a=rsa-sha256;
	cv=none;
	b=QcsIxPg/301NQ2EcerE2SuNrhU6KmXiU6lM+ngOiXNmpUQoX9bAZ4OwS7tN/wWbKbCoCPt
	T/DVVtR6Ys6Obhso9K6D55bCjNXLosFDybwCgN8YsIsum4EF2/ogByms/vcewyYjtVZbnW
	f01RCt1oZpGqVggezCmOIGIi0fZXIrc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9F5C601EB;
	Tue, 27 Jan 2026 19:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53D3C19425;
	Tue, 27 Jan 2026 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542193;
	bh=aI4WO62kph2VvKe2gJ7QoMhXLXNy49H9C+58Y9P8ebA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzu2dY0FD8NP7vGfp5IudjeX8x6QiJOSfV1oxxuPXDUvu4rBKpUTNA49h5T9Wohpy
	 pfEABMoxK6o/yC7roNa0yXjcHxBqwtIkm+UYpNDDQd1qRNy4ch60sgcDSqaVtG27wK
	 K+UqBFc5dhddJewp0K/vzuLPF2PxpQi8HyATmV0Xi9XEzGTqVFNmA9w4LSuWcFXoVg
	 QrYaAotmrdV0CDUshJOjvcVA2VrJFYEjysfOFyw5eFeR2wtvfX00eoewjFdNTtWcua
	 +mBnHhBZ1o53N7kxZ4CnCivm92wleRp8YgLjcWxCGw1GfNjWI6wCViPGzu/VwKzk7f
	 /HCrBMvTm8PjQ==
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
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 01/17] userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Tue, 27 Jan 2026 21:29:20 +0200
Message-ID: <20260127192936.1250096-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zcz5xecbmj9xttyhhxsfem3a1hwrqhyk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D90094000F
X-HE-Tag: 1769542194-929160
X-HE-Meta: U2FsdGVkX1/hgOesDML+afmARZj7haFujYlUiXTbpoWpG48FMLoERndBFAcFIowqUmpbcRyeuG3bLWg3Slad/kGsFR0iUaSRLSJ/A1tp3jqH9jCY61fhaWcBtpryw7ZAwVKgvaCEnlaTzqHbkF3zLYueUZlrgLpWv+1LcT5/qpxtuuM9s7w7T9tKItuVt9N/kEHCqrVAqTSRa/GwlZozDFmdZTcM1h3Z7zcDdTc/DvCc9lfiUR/qjy6rF9SRIyblRMEbiSqTgwNDpwKcd7xKNF8hTYRM7MOS3wn2iIxT1ZPJUbxirT0gt3lbjn5X8fkD8VfkbK2BD6lWLVTFCo5HDLrm2czi3p6JK1+LK2YnuHqlQ22gDjBei/IjffdVU/tbFFs8tE9qr/zVuk6LIIDEpAn/uqtI23C5ZarE6wVJ+z/BmQj0GF7HPypnzoUzTAaQx+sb/v0kVJdSll2HlusPM570HfaDnmf9vv679sswPymzj/mghG7JsfvfCHvjq0bVIkdThMPWWKJsdOVgJ5zvOHltWM6OSdLCmplWnzmoA4EtR5ZdZcbwp9x4KlwYr0JNPLH55yvEAnvAnUFzADXQ7WwXoDLnqCTt7S0KBQ4Jv0bUa+sl0cdQYD0NHl3z0JyRqTE6ZcYeRp0+gMGAmToCHVzGsAp/fyL3IvR+agLm2ZiNUTwGQCW6Al5FzctbwlDlj7Pw8/4fiCQDSxMKKFgHOhGNifm2d3XoB+AuLD+nTcACsxPuFjzrnJbPu1bqvms/w3rb5FkdR1edmjrQjBhM3c5Higs6pY4rUv35iZUHVBA5NIxPNQs/F5RETJcu4gFER10LdSdeyqZMLYxljiZNAFMsHgfa8b8zNk8KHDC9Yj/eOV4kUwO15hXLp7/rWKyhwKXxOL/Xc0/8tlFHw7uUJBzo+CJsiyp+L/+8+cyHBPw8dD5vQnwQX1/c2B3ggPm2XSZCWWibqtP8AuBK3tv
 S3RAcSZ6
 H5PRiI6n93Kl3/9vJSDBkDqXxsnwWUAAXlAuVK1Pq+52DHPjuZzWFrYUH8PqPbUMCe90tQ8hyJ4ynwpf/ydAFaGlyYhIOeiKERG082nV9xA15yPArWT+7Avzlr4rpk5DAx2W4WKliM4j6SLpt1ZSI4HHgLGIzooKWQJ+n2vFW481xnvrJi6LPgxGTyNgzrGlMauRHhHWip0Qzb49PAjs7U7ycPC5w3KHZ/7qNRw8qzhkOEiXNyD/ZjqNqHhOV7amXUDk2SCE1aDnlXtGiDCy88KCXvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28acd..a0885d543f22 100644
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


