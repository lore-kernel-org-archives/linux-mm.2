Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F4EC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FFAF6B00A0; Fri, 21 Aug 2026 16:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7AF6B00A1; Fri, 21 Aug 2026 16:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814B76B00A2; Fri, 21 Aug 2026 16:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBB96B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:13:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF3A8A0263
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:13:45 +0000 (UTC)
X-FDA: 85126377210.12.FF0584C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40EC9140006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:13:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="zgerzV/N";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787343224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qojg5moAHir/aPJEcXeYOPUXGyzZ1v9tB3WPUjtAaWk=;
	b=NVyGTC3VxppWduzoMpRBfH3MS3aqA53OI0MF8yJUnrygirJLiEQo5hBzqvSLZMtLqfT3F/
	giJru3tcZksZkX/fHZ0fPTKs5o5YpGCc+X9kZfFimUB1xenH3WobHIQY73zeNEiXIaq7sE
	xvVI/vZfsxNIr5gkECT47xGV8bPuBws=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="zgerzV/N";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787343224;
	b=kijqKbZi3/rHWZby4zBOjZNqXcYHE/MdGXAPzZWd5W386wTc1pCBFEi2VhkwU0RvfLbwQ+
	yCGR/z+uJsYCRnqt/hoVG3VeTjJ+R6ULgxaqR2hn+NkTIW1YDnBwrxNGhXJPp1P4yhH3LY
	ZDQDEhrlFcFiCpPKxS+jdrfDuI8QQEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qojg5moAHir/aPJEcXeYOPUXGyzZ1v9tB3WPUjtAaWk=; b=zgerzV/NWPll85Q6h4jy9kZ1Bk
	tyvf5/TgvYXM0FWCf3BEmBX0aYiDesylTU6S72e0YfVIZI73zryLG1EfoiOy4zvexaZAjpzVa2pfd
	wQ5fZ4uBMIEYQgNl7nInGVLQKzizHLGQP53BTkjH9PGgp6uFDMYRciUkJ90PNf/N4IlVMFoR+jV6O
	6eAQwn8SPQpHTp5I7dbPvuEbb2nR6znvroxt6rlpr2omHsAaxOuSMP8BzyOsedXjLkj0+n9llgY7A
	31ULM7rwOulO1DDxeqjnSQZnMIxiqjNy3yVtaihfFOUNrqgTKPB2TrR26a0qhEyVRL0Jc3rRWG360
	QKBhAE5A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtK-0000000E0od-47tv;
	Fri, 21 Aug 2026 19:27:03 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 14/19] maple_tree: Avoid mas_erase() and mtree_erase() failures
Date: Fri, 21 Aug 2026 15:26:22 -0400
Message-ID: <20260821192627.4085470-15-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f3kkif9qtqhzyhmfzf1mqxbaue6mgaso
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40EC9140006
X-HE-Tag: 1787343224-162302
X-HE-Meta: U2FsdGVkX18+JIHdHRj5iFoX7DsDZiOaUA5tpK1TARnqDvZ7XCqpowJ/29wJDDcZO4SsPH/9WPKf6UEGJI8qV6vbKImUyn+xdyzFWH1Nnqc4EyWa3ffGA7lp0M6LkXi4Bh8XtHixV8nEEIAFUN/3UMPnVokJZhBkRDP837xH1es4vhQQrhJkl/QQakuNhURweCKnckJTqol+CW0BBMHP04SstiabPLTl0s4GyQamntp/Jz/GQqrWvqPMi7A7NzSKBNDaI6vLkt9Nuubf82n3bGC3EQ+w3WP5c/ODg/G8EKdgUEHPA1Ul/rKRPcYuQYNhphAP7y5HfpFpnndp8TpEEHUSfd/x566RW2SWhT9xllQI0ctF6iZAM8DtadDEEmUa43kjxQ/Uyz+J07EMpINvI4i6+UC+QO5atR3vPknSF72w2ym8rKz++JSL5fVPe9ofHyFovetjo3ZZ8bvWlMcA+TqgKPwpO2MJd6twZMf270XFoy1ZJlxxaorpHeu0BEVXcK/2T0LgnrJsRfqDXwiyP4NGm5csU58vlvmgMhq/DunGxaBKLkX7CvDJfQf87hnl10BXDBeJ2TOsIpNVZQsQHge5hqDG0fJLw0XVO9Pv/boxEBVdDkEhxVWG86GSby6EZvfXSgFCKXqL6vw0lsxGZp8WST7HbyanUJeWu3tVcoslpQbLbZkrVuVZM8FF6JwBBb72e3WBdp+rV+r8fcQOnumVnZTzpD0XuYRLjvqSQKcNyJowBBS82554KoC8h55eDIs+mVJDKnWGQtlnQFWO65Rjz+mSuktYQOF7Oa49CKRkEoe5gJvucIL2xiyj8D/WonIPLmBNLKe+tckcNViORux8tn/q+lJPW7JCQC699T4lEpKpfm6NK/PeTB7pzMAHzhsm1vksxM9A1NNsS4u+CT2lHsn0hML95bmIQVdnw6TcRKenGQqCboGZ+jVJ60M+iwhXnKOluevJJsX9iBL
 OYJ6rIsZ
 MXvLEPJrGgSCzbGnak1zVo7lUOcZ6TKshUMDCSUO8qNQnQqQ/XKGmK5NPGx5nMGCQt4WLyGtw2xs/YStowK3UR5MixoIU/VidoYVFlCNwku26IdE/nEnL1U39Cs5keuj0V+JlT8pBjA1u4ObBgNL8wzvtM5ooOAELwO8CtQU2alEzZcToXJvq51Ussb+z0HInWOd4zJaKACzagxTQt4W7QwMbxPBstjnuNNuLGZqMwQ0MQZwOtRKL6B6NLlj4ltPCw5P6EQuI5+zr68qc+jzg/Is0QSaazG0DtklyNrybNocHMkFx0su4HMAenS8w5FGxmk+YQtRHzeMcRhOcoTvBqG75EmQCHke1ejMFgzZ+2JqmFGDva2kGm1oIkWc6Bu9LP+nK5lme/kIDNUAz5uW+u5wT+q3CvszMc4ptBChhQL0q8GGvuVLDSPVVmvtdcgyC9NWR5Ieq7r0aMtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Failures to remove entries using the two APIs to erase the entries may
result in allocation failures.  The failures may go unnoticed and an
unexpected entry may remain.  Instead, fall back to retrying with
GFP_KERNEL | __GFP_NOFAIL so that the entry will be removed.

Cc: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |  2 ++
 lib/maple_tree.c           | 68 ++++++++++++++++++++++++++++----------
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 14ca9ac775d99..173602e87c14b 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -570,6 +570,8 @@ int mas_alloc_cyclic(struct ma_state *mas, unsigned long *startp,
 		unsigned long *next, gfp_t gfp);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		      unsigned long last);
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 440863bdea267..d47d4304f781e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5658,9 +5658,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.  An externally locked tree must be protected by a lock that
+ * allows blocking for this API.
  *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
@@ -5672,8 +5673,8 @@ void *mas_erase(struct ma_state *mas)
 
 	/*
 	 * In low memory situations, the allocation is retried with the gfp flag
-	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
-	 * the external lock is not dropped.
+	 * GFP_KERNEL | __GFP_NOFAIL.  The internal spinlock is dropped in
+	 * mas_nomem_nofail(), however the external lock is not dropped.
 	 */
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
@@ -5689,16 +5690,8 @@ void *mas_erase(struct ma_state *mas)
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_preallocate(&wr_mas, NULL);
-	if (mas_nomem(mas, GFP_KERNEL)) {
-		/* in case the range of entry changed when unlocked */
-		mas->index = mas->last = index;
+	if (mas_nomem_nofail(mas, index, index))
 		goto write_retry;
-	}
-
-	if (mas_is_err(mas)) {
-		entry = NULL;
-		goto out;
-	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -5721,6 +5714,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5731,7 +5728,9 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation.
 	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
@@ -5740,6 +5739,39 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	return true;
 }
 
+/**
+ * mas_nomem_nofail() - Retry allocations with __GFP_NOFAIL, if the maple state
+ * has stored the -ENOMEM error.
+ * @mas: The maple state
+ * @index: The start of the range for the @mas reset
+ * @last: The end of the range for the @mas reset
+ *
+ * Return: false if @mas isn't in an -ENOMEM state.  True if the allocation
+ * happens, the state is reset.  The internal lock will be dropped and external
+ * locks must allow blocking.
+ */
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		unsigned long last)
+	__must_hold(mas->tree->ma_lock)
+{
+	gfp_t gfp;
+
+	if (likely(mas->node != MA_ERROR(-ENOMEM)))
+		return false;
+
+	gfp = GFP_KERNEL | __GFP_NOFAIL;
+	if (!mt_external_lock(mas->tree)) {
+		mtree_unlock(mas->tree);
+		mas_alloc_nodes(mas, gfp);
+		mtree_lock(mas->tree);
+	} else {
+		mas_alloc_nodes(mas, gfp);
+	}
+
+	mas_set_range(mas, index, last);
+	return true;
+}
+
 void __init maple_tree_init(void)
 {
 	struct kmem_cache_args args = {
@@ -6026,9 +6058,9 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.
  *
  * Return: The entry stored at the @index or %NULL
  */
-- 
2.47.3


