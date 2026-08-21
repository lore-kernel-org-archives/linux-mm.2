Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4AEC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBC16B00AB; Fri, 21 Aug 2026 15:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3826B00AC; Fri, 21 Aug 2026 15:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1D86B00AD; Fri, 21 Aug 2026 15:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95BF56B00AB
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 273F51C0DFF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:04 +0000 (UTC)
X-FDA: 85126259568.29.A7A46BA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7858E140008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nbrGzFhC;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pS9OYDuK7fUXcF58dN1XuFhTjUyENn2k+dqhzY97MNw=;
	b=jPu+9xrFOEBhbcFtp3gwBEwbnjBF7/YTxf8ziFvBegdY2dE8KCiq9qiuziS0DxL0uRM1oe
	an19eBxvh491MvDFRs4QB0wH8aXFzvaNTKM90F5hDlZn3RZqua8bUiAAksQzzM3Wiu0U5v
	aGv8zvyI23tUKkeKshwA28Rxvt7h8BQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nbrGzFhC;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340422;
	b=rZoB4MceWxKrWRhUmzsF5sDQi/wU7CMw4NytTlVf8IhplsXKu6WzNO70upXp+chi3F27mP
	z0FDEYjAfsiD0OyApGrpvgtyfyDBc6RG/xIcpbTBLCrLs3qZOObgZuMBnZQyZ6ExoEOyz1
	6wW7qAvievipCDZPW4wG8MAXBznYPnc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pS9OYDuK7fUXcF58dN1XuFhTjUyENn2k+dqhzY97MNw=; b=nbrGzFhC0B2cyJWDmv8JCSTzit
	4UfILEj0QGRQqP1acEHW69DAUrvaeN176eCAXHg2SbokyM/YwcDfMjX1YXtELKFL9X9Dz+JD8Sv4b
	Ukm+j32KsZJTDhBKDAHo0skKOsNJ3uNnEPrPpl1UriFCn8Qm4i2+/eCujehxYiv+bUD2yI0/d3D+9
	8t0CmXKgivXWt5KzFwsGLoX1mpctjAXh59lIR82/qsq3N1kO4/OzEucMTJd3pi9Q2eSAXcM9OmKjc
	KuCvtFpuCi492uGQpNscvXgM+MmgK06cIsrb+XjR4mC2V+ygG95sU+5gTYGrwdiMHVzwoGsm28Crq
	rzulBrOA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtJ-0000000E0oA-0PVu;
	Fri, 21 Aug 2026 19:27:01 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v3 13/19] maple_tree: Document that erase may use GFP_KERNEL for allocations
Date: Fri, 21 Aug 2026 15:26:21 -0400
Message-ID: <20260821192627.4085470-14-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7858E140008
X-Stat-Signature: ee9pxgmmj974qkdj3j81n16e3h17kont
X-Rspam-User: 
X-HE-Tag: 1787340422-597156
X-HE-Meta: U2FsdGVkX1+RHbhSlAOmrRLX/ha5HJOVCfZsZCvTbCIz43YG2kxsFO+NzYIYml0M4nRScUIEN/mr9dQL/tCCpDFgvSQ5OI3u8F6/KIv1jy9a2MGmLc7JenklKQJCCEc0KhpjZrm9++7HQO5E7HPDQUfluT+6AOuDmGaVgBZFWLhVNnD5GPRgshMvIbQqLlH60JPaNbhRWaNGLFEyLR1NYd4xJD3fgc/1svQ8vG+ZTZdGocD3MVFripH6vf4kgytb0L4fEmgKsh1wwfBVJB9SYe1eXAsavxVvGVm3piTETc5y8NaCKztq7Xv3AnEYndRHcXhEsmfjUomdQ0aH2mi7IsFd2wG/sBwdPURdqJbJk6YKBjH0EacpTL9jbUPYI6tDQGyv883fWqSmaSL1v7/JtCjSqVZXPe113l9eBTBKD+eNxghAhJUvloWUJbe3KV/q4uPZ1w/3CNpubQdCoUKzjOcDYDMVMoOn28LSu5CvzM09fYQzzE7Wll1U8TMzXHqrCGevi2QcWEf5CdReoJaNzX5RMniPykloWyqmCRwKnPHV0moQVjjt96b9jj09+jvGOLXVSAjwL0fVx8miyafyr+pzjBuN8meuh1K1KI3sY4bdm2Mrox1zdFQycx2srCKxfZaITwdEZLoQnwrgaUJrPd2uKQYxnpR6sN+2dFu5I0QKkEgoYGy79CPs+MFYu3/UOT4+g4Qe+KybYZeFHba4TZ5nAiB9uKTVcf0LZ5Uw8PgtgwaWi08xNslxSVsEih5MYbSlAt3qgixwS/Kg0iDhoefux1F2JRHjPv+zkLYkzwxmd87a4an8XLVtPJ8s0GmFvRSYCmfm4weDI3KXzXzebXYfIgqrMgMf9dGYUs2oxdsMXJ5j22W9swkmm4Ya3wxFMkeVnpAGPGL/VmdbR9OBFTMQ+X/6ylM4CY413cZMjUBWks+UF+NjivXlA/dnvh9Lxp9qnFyJyTxRMLJoCJt
 phdtHtRI
 Zjlw3lMDwgQtGVjIuFgEzn77ZHZATW4bkBcWfpJ06X3pXR/XRvPv0wAhhjnGOXnbyWsGVxE8elyeqB8hucsG/XS69U8YaiLoITZthmimUrfkY2+pEQMJP1yir6z7EK2c5WIXvIV7qETXQ78t63XP1NKF2mH2zgKYEwEUAs7Q5smzxUD6x02/uq14U3piWA9NXiN/WKu6zc1CaXKF2/FjQvymsK91ZRVnlyJxO6avJAOSOC1nT4K3b8T1afDyKfN3S7eTQzFpaf6q+454bhjGf0hEzp1l5gmgXjVEn1lTIDiidnDMvLw5hWaJgjztAjDtUaX49CS9TtBaVzvaovvRZwaaaZy83kGTt6sroGvX8+JxpG6IuwMnb/t1JnQyoJdSzQ6ADWDIkh2xf0jMY+l9eP1Isy3JbmWskMQjZsSmaynAMmEoAYIw2Jx2qDztIfm32b5nL6zE13t3VelE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

State that the mas_erase() and mtree_erase() functions may use
GFP_KERNEL on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 190f480d68502..440863bdea267 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5658,6 +5658,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
 void *mas_erase(struct ma_state *mas)
@@ -5666,13 +5670,21 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
+	/*
+	 * In low memory situations, the allocation is retried with the gfp flag
+	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
+	 * the external lock is not dropped.
+	 */
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-		return NULL;
+		goto out;
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
@@ -5683,8 +5695,10 @@ void *mas_erase(struct ma_state *mas)
 		goto write_retry;
 	}
 
-	if (mas_is_err(mas))
+	if (mas_is_err(mas)) {
+		entry = NULL;
 		goto out;
+	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -6012,6 +6026,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: The entry stored at the @index or %NULL
  */
 void *mtree_erase(struct maple_tree *mt, unsigned long index)
@@ -6021,6 +6039,7 @@ void *mtree_erase(struct maple_tree *mt, unsigned long index)
 	MA_STATE(mas, mt, index, index);
 	trace_ma_op(TP_FCT, &mas);
 
+	might_alloc(GFP_KERNEL);
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
 	mtree_unlock(mt);
-- 
2.47.3


