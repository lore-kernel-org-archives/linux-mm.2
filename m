Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7145ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D50B6B0088; Tue, 26 May 2026 15:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985DE6B008A; Tue, 26 May 2026 15:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BC96B008C; Tue, 26 May 2026 15:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1A86B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:56:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A8411C0254
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:56:56 +0000 (UTC)
X-FDA: 84810629232.06.95C50DD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6477240007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:56:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="f/kO/ASE";
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779825414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=stajXrnLImJ69kdplbVA8o2xyDnAh+X0bK3e8ykidGA=;
	b=US3iFcJPynIPKvj7oTkOG0ePGSrLCTXZwm5ujbE7j8DdWrrVSBKCac9wZy2dbdBxMP1MJZ
	yEv52fSYPCTPl2mo5hP/+V92xdLa4bXkok3Zi+/wLEnmGagf9yHFJYWD5ylE3h/w40h9dz
	bxQUFRt8mrpY2RiffnEFGqx73tQcsG8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="f/kO/ASE";
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779825414; a=rsa-sha256;
	cv=none;
	b=Bja1C/QqJPxjV3rWWMjiwIoAy0RsdRYxuBmiA700LZvBxBivNl5t+X/k063eZ1uPY7ks9M
	97LZqM5dW+Zwwy3DIc3QZot3JwIsEzBQZL0BRxxt1TSFSjA+JFq6jgeFczmZIXKZ1XQG2X
	1n0kx5x/Gtg262NcicFRPSwuscS3VGg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=stajXrnLImJ69kdplbVA8o2xyDnAh+X0bK3e8ykidGA=; b=f/kO/ASENe4ZAHJiN6xGXxnfST
	myHp0ZcKWBb5McEgv2ZOJYfczHEHRV4YbXSg4V0p1PjsTnvyU3tXoHcz4kqGkjHMRY7ew9EnNfUSq
	3yaOXEhllSDZEYAAVCDCdFNay5Yk4HUIgtpcNk9qton5/Ey3mdjdoAcZY+KvI016L1sqWyUBelBFf
	0jSE5sVuBT0SUGmnYb/H0J5xOuKXA6b+uPPUkYa2FBnj6996fKaE+5eubm8zVhJxy1kXgv5IKts8t
	dT4f+31DdmqhgFOaU9avFXemH8ZUqLoqCOjpRBFziAEHkNQO9Annfd2O0wYco6TTWdvdl683qgrM+
	osiLlI1A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRxtT-00000001Tsr-23Jy;
	Tue, 26 May 2026 19:56:51 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm: Remove mentions of PageWriteback
Date: Tue, 26 May 2026 20:56:48 +0100
Message-ID: <20260526195650.353196-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6477240007
X-Stat-Signature: h5xn7kgxjp6rckotk9m9r4a35unsqw3o
X-HE-Tag: 1779825414-133611
X-HE-Meta: U2FsdGVkX1/sPWKL294z4Xv29eljek6OKC/RdQ2Ad1OF9WBWD3LpyxWshW+r2MhFl2OGbwlfjigrRavIdhGb7R+NJPrhs7MZppqCT9nFoZ0T/VwfLGsIEy8UcfRQBG6rsqpTCP/GTmUYzkIjl6MGBAiUokqbMahscWdcvw0J8lW3Fymr9i85ipnfcdrzCHV0i6JcFaJfUXp0IrmimlzB94/F5HsJDr0t6BHxYBy1VScTu1p+kjmlg5Gr89/AicX7rEyapeal7g3FpRGUQTmwfzNgkK6uDlpCrEfWZXwFdg15m3G0IWLqQoNNNesCGrHPxPxOcwBUaz+aICp/hW78HtDnECfH5DE/KbIBrNT5MWn3GFYF45Bc5Ejb7Rj03zgcaZPQhzoje+w0mlEf5auVdhISDg7YwA04wO54dLCNNOa1imc4fbe8ClOkMW0YYkWGUZknEZAwtnErBYwJ3o92hbdKTcROG106hrUdHsz1l4h44mSK5HuJ7yJZxcdKonKCh3/xlB83s5xoyY/Ix/pB7MUtLWLFbmKJU7VH8Kh79ZTiLDupfKTnkciNJvoeGthLr2TDlNfVkVrUe02vhzAXQhNMGoRUSfqdOl0r1nM1Q4bs52D7SdQ00IBdP9eB9qxGab/7KZ3m/fejTFUrijHV7EMZvupYsQLINLBEBKsRIXziu8mAkrGK4j9mqDTaQSOHvWZZ8VAKW8qLVXZea8L7cldJMfwkDV9NgBN9n7sdMOOqm6RDGblBwx6QQigMTRpaEuUJXVjCajcmkDingnpO8IOEiL8HxMjQZ0Blch5iK8JEi+dBPF/6mwgwgEi6PohloAxqQZTLVRVTpfG5mvKKn1Ww7pgFCTxicn2bsXD8T6530/5Ak4Qp77R2DlqebwmmpYNR+veOKXqIugZFUXWnW3Zn1XMAmbPC+eyPni1TKWTQCX1LB2ut1gVXGnVQtnvs4qiz8GY6jVmUB7/hZAu
 3Osvihrb
 Mn7SuOlWlqtnA8On/nt+JgXFD+mwyRGWsLZoUFp8SWcQH6Spe6e1sGr3HZsWiYMe3bpDYGiGanbzAXZG0vRoXtTer2XnmUDCtQjXBWuEJJDtOmMTRCpcVCP2x99cwsRxH4JWK0CF21gOV0HVp+Kh/RLbRTh9k6ncewi/ffeO8ft+ZeS28CRvyw727VVlIr8YTMw9/2qb3CBzHPxtAj7XWmZU8m74yGW0DhLYAPFQN1Kb7YqUbvviSWVpsyyrF4Nz7IWqEzbIudpd7UX8DK+JLYVIvLtnWPKFYYkteOWedslUWv9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update two comments to refer to writeback in general instead of the
specific flag.  Convert the large comment in memory.c to be entirely
folio-based.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/compaction.c |  2 +-
 mm/memory.c     | 20 ++++++++++----------
 mm/migrate.c    |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c807..d607f6846e0d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1123,7 +1123,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * To minimise LRU disruption, the caller can indicate with
 		 * ISOLATE_ASYNC_MIGRATE that it only wants to isolate pages
 		 * it will be able to migrate without blocking - clean pages
-		 * for the most part.  PageWriteback would require blocking.
+		 * for the most part.  Writeback would require blocking.
 		 */
 		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_writeback(folio))
 			goto isolate_fail_put;
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..37484bf3e934 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5451,18 +5451,18 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	/*
-	 * Preallocate pte before we take page_lock because this might lead to
-	 * deadlocks for memcg reclaim which waits for pages under writeback:
-	 *				lock_page(A)
-	 *				SetPageWriteback(A)
-	 *				unlock_page(A)
-	 * lock_page(B)
-	 *				lock_page(B)
+	 * Preallocate pte before we take folio lock because this might lead to
+	 * deadlocks for memcg reclaim which waits for folios under writeback:
+	 *				folio_lock(A)
+	 *				folio_set_writeback(A)
+	 *				folio_unlock(A)
+	 * folio_lock(B)
+	 *				folio_lock(B)
 	 * pte_alloc_one
 	 *   shrink_folio_list
-	 *     wait_on_page_writeback(A)
-	 *				SetPageWriteback(B)
-	 *				unlock_page(B)
+	 *     folio_wait_writeback(A)
+	 *				folio_set_writeback(B)
+	 *				folio_unlock(B)
 	 *				# flush A, B to clear the writeback
 	 */
 	if (pmd_none(*vmf->pmd) && !vmf->prealloc_pte) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..fedba0f1f0ef 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1258,7 +1258,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (folio_test_writeback(src)) {
 		/*
 		 * Only in the case of a full synchronous migration is it
-		 * necessary to wait for PageWriteback. In the async case,
+		 * necessary to wait for writeback. In the async case,
 		 * the retry loop is too short and in the sync-light case,
 		 * the overhead of stalling is too much
 		 */
-- 
2.47.3


