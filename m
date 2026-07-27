Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54603C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEB36B009D; Mon, 27 Jul 2026 14:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F516B009E; Mon, 27 Jul 2026 14:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5906B009F; Mon, 27 Jul 2026 14:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7F966B009D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74F68C016F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:25 +0000 (UTC)
X-FDA: 85035353970.29.D45C774
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E9D7B40009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l1O8HDqh;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=;
	b=l5nLzVH1HOAsVeNt9aaN+uyPuPB4lCxNUZHPtbG6oaAa0KY+pIkwlCyXbwfqMEq92wiE7J
	n2N3A9gw5uT2xEa3Jk3RuSFKhMq+55V1HvPdJlAp/p7s3xj82DjDRqjGvXm/KaX3EBrBGO
	zqnu3Q49nBPtA0exL3j93NCNrOFZkCk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l1O8HDqh;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176003;
	b=037l2x5l4d8syJzIpxTTEBhgwis+xNe1enkxAw0R6QUxIPrGNCxifEuiYKEuQHqv0bvJrw
	QJNeh4ITMAkNkl30XOt91mvK9i8QapM7OV9tmw6k11b1QlnvXnd7fI0Y+KdQv+5KbtsCal
	kOwcF4ABbgk5QXf3EkmLyOn6TVaa0wE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=; b=l1O8HDqhLw2tdBSLRlysRx56U0
	YEuakqpjtAFnIlcV2hyB5yEpwqfXJK4B9O8qZbAnqFiwD7aWLzAtIIiVp/m7N8VG+F3z0MkbWyHcY
	sk/33rExFC+VdwT6wXcLMKw40xOi2qrzKLfnZrlkBxFr5H4oCeg3RCFWEcRMqkQWcemzwYe5uyuml
	c9s5Wmjozp9kG1K2QbEuONhIK8A8umueMXvmOoKjXtCc1byG81nHSSoomfBo2wD/mqOBxFHS8kJXb
	mmYmF+DOSQptlHG+7UJLxt8bUPUsYVJ8CHPqkk/2SAGLGlxgYfqKblYaHV7enQ0fXblEBcD3Km5xZ
	/RVWYIQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7e-3EIQ;
	Mon, 27 Jul 2026 18:13:12 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v6 09/12] filemap: Remove checks in mapping_set_folio_order_range()
Date: Mon, 27 Jul 2026 19:13:05 +0100
Message-ID: <20260727181310.2671972-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9D7B40009
X-Stat-Signature: 5jut4aoseepyxkth5rs6caay4rbqkom5
X-HE-Tag: 1785176003-903960
X-HE-Meta: U2FsdGVkX1/UhvVdG1HPfBMmnV80HnXxk0EotcSVf3AFNV0WqWwEsdchpl6Ga8aFAr1sEDyV/ncz0ODmcsSE4rnHzrRADmL1pL8yP7nyslVGWsQb2Ae6TNvZzKK6OgnA8gkYf8qkwlctjuUKCcTRI9QhWX6FOmHgzAwxZzMbKM0gRZmo5wfWEfV8ZwalLklInMqpLQcCOb1Z1iF4XXQRg/VCRA/1NrFud3KZxOq6l/C/P1SZQokfvYxg/N6OUKyV5KYuBBJPWMdyzhnms+QbFpWkgbdWptCTSX+9Ldwo1JZc9tNjAkxy6PZFUrYJ4dTGLKjOYQq0YbXW6am0aXsW9W6LoTB5s3eR6dvPW1zcvWnjGHw7rIHIWgtOXO41iOX+IqHyXWBoMF6tvxOQzXczTtqz35zvBuG112r3euLwv8xVk4ZdOVTYvxcSH0IfyyxpOo7RcKJ/BLzirg5oQZha2jb4P5/QYcSfsnofZVS1FxwyFjEb5l8RlxL9fsnzprkrfVII2DYuf6PdL5RKqRd5cFeo16JsSrNJjVJb7qwcXJaL41G+Jnee51IspO3Wp/TxRKXe3C1CBG6LDR49qncLFWGlRP7D+63caKWXkpUq5pc5ZfjNNEUnyqVvGui/g/Y2kgfH/9ofZz++w7d6jGMAzEv+QhYvucQu+kOfTFEbgaG5oe+C3LruvRWbZSThBJ3rCLj2xZ6NIWWdYLA6FyFDO1Z4CW36BhSuJrlxg6Ocb0A0/X5Yo6s7GslAgNaJ+fbOBmWki3N4PeIRSJagptWHbeI5TBGdDlZznKEqV+EnBkZpPNb4R8oD0Opu6ivGEjGWAjNYtQUmcMqWrQGTO4GPHFv84/27lMmDqlYElbLYv8qM+e4MpnqpC7xyGMZuZ4OgM7Yn3U/Q66e5/phEBbzVSzigPZvvFnI00maKazpZ624NzfFmAazJKuyq5WEBupq8RE4jTOjbQ/Gx0xALlBM
 fwp8m+fu
 E0iWhowV/wUql+3QWQoJt/NgLKScazYnNABC1bDBkM7ClpBKEoItg1tgB64P1rx+a7/7pVMuTowaD1pePSOCHI6hE5zC1eacVeygA5aZN+Kcu9TTaEXqdTs2PsqWLVs8QjOcmYi8yTnAs4zEl1pReghBx598+2XuILJtkCN7krm8IFlyE0FSZ1VoigU7k2gCp+DaCAweVG0045s77CQSVPEzeMghZDu7V5/iaNqQ275MZ3GpKMLED2AiAZsOkjv+gVmCBIq+baj375Sd5NgvD1WDxyua83ODYX5Jvu4QexGzbiS0DrRZmIKLqcLSmuRA0vGN7THkBsnnHH7583Nb3fbtJut8yifuydk0uFuPA2DzfcFw9OEeoPqKdw51MJygBc533q4BympOOak99+r+zSoKtrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks make it impossible to use mapping_set_folio_order_range()
in hugetlb.  They add very little value and can simply be removed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..968b791cfd14 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -373,7 +373,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  * assumptions about maximum order if THP are disabled, but 8 seems like
  * a good order (that's 1MB if you're using 4kB pages)
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_LARGE_FOLIO
 #define PREFERRED_MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
 #else
 #define PREFERRED_MAX_PAGECACHE_ORDER	8
@@ -394,7 +394,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
 	return PAGE_SIZE;
 }
@@ -405,29 +405,23 @@ static inline size_t mapping_max_folio_size_supported(void)
  * @min: Minimum folio order (between 0-MAX_PAGECACHE_ORDER inclusive).
  * @max: Maximum folio order (between @min-MAX_PAGECACHE_ORDER inclusive).
  *
- * The filesystem should call this function in its inode constructor to
- * indicate which base size (min) and maximum size (max) of folio the VFS
- * can use to cache the contents of the file.  This should only be used
- * if the filesystem needs special handling of folio sizes (ie there is
- * something the core cannot know).
+ * The filesystem should call this function in its inode constructor
+ * to indicate which size folios can be used to cache the contents of
+ * the inode.  This should only be used if the filesystem needs special
+ * handling of folio sizes (ie there is something the core cannot know).
  * Do not tune it based on, eg, i_size.
  *
+ * hugetlb calls this with orders larger than MAX_PAGECACHE_ORDER.
+ * Normal filesystems should not do this.
+ *
  * Context: This should not be called while the inode is active as it
  * is non-atomic.
  */
 static inline void mapping_set_folio_order_range(struct address_space *mapping,
-						 unsigned int min,
-						 unsigned int max)
+		unsigned int min, unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return;
-
-	if (min > MAX_PAGECACHE_ORDER)
-		min = MAX_PAGECACHE_ORDER;
-
-	if (max > MAX_PAGECACHE_ORDER)
-		max = MAX_PAGECACHE_ORDER;
-
 	if (max < min)
 		max = min;
 
@@ -460,7 +454,7 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 static inline unsigned int
 mapping_max_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
@@ -468,7 +462,7 @@ mapping_max_folio_order(const struct address_space *mapping)
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
@@ -524,7 +518,7 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
  *
  * Return: True if PMD-sized folios are supported, otherwise false.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_LARGE_FOLIO
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-- 
2.47.3


