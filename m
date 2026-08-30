Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156E8C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA236B009D; Sun, 30 Aug 2026 00:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934296B009E; Sun, 30 Aug 2026 00:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823416B009F; Sun, 30 Aug 2026 00:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38CB06B009D
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87623A0251
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:27 +0000 (UTC)
X-FDA: 85156631574.21.EC3519C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1031C140004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ia8PDE2J;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063566;
	b=x4hw3UPWSvtaXii9qoXwzzgTKeo6RGDy6F2hILUAuY57bpfng9cHlhLcbNCI/nf8YrFpl9
	y/lRzxMQphxyLpdZTkMeEn2Xtk+fA6WgA7kgH9Ryt63COM91Tj6vj1w7v5fAl2t/WSHx2e
	xFMgIw5uTQDjFL6yoT0IfRNyJlHhqtU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ia8PDE2J;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX1YDxtUboff1x1jxC0V0517QCG7T5Er/z3xEiz/4yI=;
	b=XGcSEySBG3EjHSlvuUFpthdn/2fvNLRm4ABPp82rXEYoKxqBxeSbRfNNUzH0DGBSIP1yDT
	lhSv9bgP4RLwF4z97Ax7vE/JxLdQjVlz70sDGQADf94iAABimtSKWt2m5cOaWr8JoOzK1x
	Zn0iD/V+2V7v2CM0ydwtBolqiPUyma8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HX1YDxtUboff1x1jxC0V0517QCG7T5Er/z3xEiz/4yI=; b=Ia8PDE2J2L592KXDaHpWvWTj85
	NBPDULnBAmGG3IioI8moIoKt27O8MzhWpiF8X5mkvtK2f3gT2lxyE+rovkiLoGZtaNu8rpXjLzE1X
	y/qzn8ph0pq9AyJyutBn4yxdtnrIG0I8ie7p7DUyEhGMr3vxcqeAuXOXcrXgJKOhdbS019CrIK8kp
	ALBRFMAZRUNq78CHH7EUDPXo6vM6jpwZmR2bj/GcxFtVZUjPIQzsV5t3qGR6z1Toj4PBbKVodMH3Q
	ql0J0/GC6hH8KdGVCXhVvfOwE0SQ+c00DRGQ6Vfe2QpfB0R05sIakJVbP+ObSEpkWWLCLjwX4QaBC
	GqtlndIg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Y-000000000hM-42LV;
	Sun, 30 Aug 2026 04:19:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
Date: Sun, 30 Aug 2026 05:18:48 +0100
Message-ID: <20260830041901.2668-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1031C140004
X-Stat-Signature: hstffkinckrn575n6t3uqu7i4a94zdsm
X-Rspam-User: 
X-HE-Tag: 1788063565-176907
X-HE-Meta: U2FsdGVkX18y4aNAHEndxv0BfQl0nX/GWNjr2Wk/q7/suliDnJUzufElsu4FXRMkR4DropO24KGXmL3GunPDlhG2Tw5haSERKfm2IMZjilPH06tLsJsHSUG4Kqmh2CpgiNq2FItm5cKI29AGd1imXOSswDYHS27tiYCqcXBfDGACB8XocnhwYkx+HxA0MjceIsCJYy66zbNLrsWl2SMHIdEtcXbFUTcHKSX/bNH7xUXktYeNz/aXg85GnEI+3kwz9q/TGB7DbFot35winJqUc43NsHvX/RhLJwmeqhxzJY8u4cwBATIZQGqJboXit/+oI+ijzAh7ZMRF7FqtuLLNMkV8GQPxWmv/SbMt4mjNjWBpm5J5npi2pJ2AYsFYZ9+ATIlGyBOJU6AmSyphx3qaEvc+q2/EbNz6GTkekiJX+/vooEEtCuoSArjlVv4rPIwsmnU5sjIo3ve4ZGpecFZSHxfwidHGHMYGaoEfZNNbjFv4MWMvwNYle0Wnn/S5uSzdfkqbTwP92v//WnpEmKuoxYjdoM0RgJ21JLechScBgOKxmrZaTWu4KlPGfKqwYbiZXiTPi0BIbhi5pwmDRvaRycUqwwt99kSmGrYK/NFzejOzvt4XgfPRgDPtuSzq+9Yh6uWrz2eCbwnP6o+1UfedxYlGRMsJ14bfKj95ApiPBuVF0qxgc9L/XyPdY6K5JLIvBNqo1yhYbHYwGd0/sU6rPQ5cl8WsOZWbdW90xDe29n6NZJqnZptoublo+tMCSIgdEpFdKkwEqEAieT2Lesp0MaLqJLq8lgRK1jrS3uCYbDdCyHvmkmCaY6IffOdzkC1Xd0Wj6JIcVuiEG+wLXjyJd8yxAH8Y1NmKs/Yu5b8MrsVfPjbKXbV4QpPPWYRDOTODBcuLa56N377ixpjVmfaIvVGPTZ7YziHtcF44uu+CIalpT540VbWkzWXDfmXXm+RFvMkzfYtB4RG8OpAvwGw
 VF8p0+db
 7ob0q7RNoevlMTmisPTLxtABGLI25fiPAvK38snGSmNjy+v6cHl88eK4TkrICSdd04OFdj2XkTIuxOo8xeyYqkwHl5hhKAAWT+tTHGOy21GALvyL3Sn3FRg2Yh/rkS1NwRBoXa9EJarmAAvfaW75/ktFD1TU8I6OcV2q5oHmWus90rtZfg8RKH9bQHzMQycYCq55bg2oa8fCvBCeL6gxbbPXU7ik/Dmp+uMFjP4QIJtf57qJODV4gxXwbT/FjmtSwgdBJKQ/oSG3uMt/mOJzjwsPfCPHw+2pDHv5nvCybYFTNh5p7p6IIpxQuGmOjJMw2JRmWJA53Mz2R23oL24HKzgbYdavWxbxddKkjthmDEa7n0kMG85FOXcnCBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Talk about why someone should call this function instead of
what this function does.  This makes the long comment in mm/readahead.c
obsolete; replace it with a comment about which case we're protecting
against.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
 mm/readahead.c           | 14 ++------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index d7c6a942aa7e..f76be1141b06 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -372,13 +372,26 @@ static inline void memalloc_noio_restore(unsigned int flags)
 }
 
 /**
- * memalloc_nofs_save - Marks implicit GFP_NOFS allocation scope.
+ * memalloc_nofs_save - Prevent recursion into the filesystem.
  *
- * This functions marks the beginning of the GFP_NOFS allocation scope.
- * All further allocations will implicitly drop __GFP_FS flag and so
- * they are safe for the FS critical section from the allocation recursion
- * point of view. Use memalloc_nofs_restore to end the scope with flags
- * returned by this function.
+ * All memory allocations between calling this function and calling
+ * memalloc_nofs_restore() will be prevented from calling into filesystems
+ * to reclaim memory.  Clean page cache memory can still be reclaimed,
+ * but (for example) inodes will not be.
+ *
+ * The primary reason to do this is that the caller has taken a lock
+ * which would be needed by FS reclaim.  While we could theoretically
+ * call into a different filesystem in this case, it can be a deep call
+ * stack so it is better to avoid all filesystems.
+ *
+ * Filesystems often choose to incorporate a call to this function as part
+ * of starting a journal transaction.  While not a lock in the normal
+ * sense, it has much the same effect as nested journal transactions
+ * are either prohibited or expensive.
+ *
+ * Also call this function if you need to allocate memory while holding
+ * a file folio locked.  High order allocations (such as those requested
+ * by slab) can trigger compaction which will attempt to lock the folio.
  *
  * Context: This function is safe to be used from any context.
  * Return: The saved flags to be passed to memalloc_nofs_restore.
@@ -389,10 +402,12 @@ static inline unsigned int memalloc_nofs_save(void)
 }
 
 /**
- * memalloc_nofs_restore - Ends the implicit GFP_NOFS scope.
+ * memalloc_nofs_restore - End filesystem reclaim scope.
  * @flags: Flags to restore.
  *
- * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
+ * Ends the implicit memory allocation scope started by
+ * memalloc_nofs_save().  This may not enable access to filesystem reclaim
+ * if it was already disabled at the time memalloc_nofs_save() was called.
  * Always make sure that the given flags is the return value from the
  * pairing memalloc_nofs_save call.
  */
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..9c116d4ba963 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -227,17 +227,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	unsigned long mark = ULONG_MAX, i = 0;
 	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
-
-	/*
-	 * Partway through the readahead operation, we will have added
-	 * locked pages to the page cache, but will not yet have submitted
-	 * them for I/O.  Adding another page may need to allocate memory,
-	 * which can trigger memory reclaim.  Telling the VM we're in
-	 * the middle of a filesystem operation will cause it to not
-	 * touch file-backed pages, preventing a deadlock.  Most (all?)
-	 * filesystems already specify __GFP_NOFS in their mapping's
-	 * gfp_mask, but let's be explicit here.
-	 */
+	/* Allocating with locked folios */
 	unsigned int nofs = memalloc_nofs_save();
 
 	lockdep_assert_held(&mapping->invalidate_lock);
@@ -512,7 +502,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 
 	ra->order = new_order;
 
-	/* See comment in page_cache_ra_unbounded() */
+	/* Allocating with locked folios */
 	nofs = memalloc_nofs_save();
 	filemap_invalidate_lock_shared(mapping);
 	/*
-- 
2.47.3


