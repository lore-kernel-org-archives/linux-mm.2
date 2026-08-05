Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE55C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15FE6B008A; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8346B0096; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0186B0093; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 820D66B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE117C05AD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:08 +0000 (UTC)
X-FDA: 85068448416.19.458E37B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id A38B3A0008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SxLT+Y/R";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1Szv6zVQo+H3TFouZAg49iBW2w9R72pq8GXe73wFeg=;
	b=3uCHjZwzGUd1TFyanlNZFyqFKmz/m7tWVl5ufY6KjZ9ko7MHBrZzbOxg1eWFlSRvx4VPLr
	1o5rC80KxlKRFS3JbWRIa6oz07nbkqTgCHDmfa0aEpq/SS3/+OpfG0LusUxxQwqPESEw5a
	OLwlpucE9Ge71/CBYq9BIOIpHKYeOno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SxLT+Y/R";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963967;
	b=VPVFlGoiAeNqS55io5VBjCC2/B+2pb8GR6h1Nc8aMzH7rkCkyVB51zF+nA9XCWHS7dxuMZ
	z6LFzk0NzjV9GSxEFc+/O3CLg3a+ZGDzbUrC8/h98FvdVwZ01Js4nyn9pcDb8z6U3xNrGg
	zmPt9jag4fkk7CJbfBhsZ34H+sPk4C4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=g1Szv6zVQo+H3TFouZAg49iBW2w9R72pq8GXe73wFeg=; b=SxLT+Y/R/T3DhsUaw9cPfSxDOv
	vGrTK5cvi3uZsB6UJdQ2quDcUPIx/UjHtgdVAMEjxaVew6K3onehne8yg1A3exUlXbQKwTsUWnuVQ
	M2ETVQK+WFKwP8JMOetU3dAuSxPjGyRGOSOXIhPtU96p4e/l9EsqIEl2FqegZjxv3FGozY2Ix6FMr
	hqQzVcphh34/Tl+lHxODBgAGOgd6yXA4fKO7+ufOiDiFGWCuPAhgKt2Vo5LCNh9XvZhMz5UsTBAGE
	wjvyvtSDeAui3XaQt8DC7HsptI8itp6S6WOWBJhm8YIGXB61zKrI2rfSygfutYHXv0pj2etaNTrT1
	JIcnPRyw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6R-2GQl;
	Wed, 05 Aug 2026 21:06:00 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 12/15] filemap: Remove checks in mapping_set_folio_order_range()
Date: Wed,  5 Aug 2026 22:05:52 +0100
Message-ID: <20260805210557.1118966-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A38B3A0008
X-Stat-Signature: ec8g3fjzgaswraasizmbjm9h9gatpzmk
X-Rspam-User: 
X-HE-Tag: 1785963966-917625
X-HE-Meta: U2FsdGVkX1/+KcuoifN4u+S6QckHFBzBZph29hg+XqYwGoN8MpRFcEH+WgXCsps9XyLCiiWRFGpihXurQ+qxPLKC0SpJrvGVxmd/abTE/LavjIUIxtDNmYKiSQLzqm+SPqJO1tbUTgcBoy1tNE7H7pw84gIF7hzGyRy92E/I+y51hVMJ21bY6rXzK1g3SdpKS8Iv5zrXtbra9gtUQN7Z54pmpDLV7GbTssaUEMVcrVG6mEF2PCqT2/KYxvtrEQ8EuNqP4ARe66yXYJJbTnCSudw7PwLXSTMcAAa9Gx6L2Wr1kdiKTXaItpXgsEhGSxXwUHgHaCwd6+bs9X8QNcbe5Hf26HwJAoVzNV7OUsAMpyZnkyQdljtZgqHQEfgsgfL6NM1ry7w6cXuDnRUrJA12lmYunVvqOJC78IBEMycTNLbYL0WjJh4Hzh5gTPn+kNm+4dSUqj0CRvQeDCeP6O+cRlFXENXEwe+memEM+zfTRn8pQkhaNGT2ROwQAwalUhfkagDGSjWC7+BBNeYEwDUH7c/bTqAwMJ3KsI9951XdyI5j3Nfl2D0/xUGr3SgOIrKptx+2myPpIqtiJs7VSa95heEC6VpR3+hoJJmACg0KH+8ZTWXXGB1NVmgS46VG+6jccLKZZRBTGdmtfiyMRdVVFWbtZjFJ7mGMJqidvTCuCdLFFUrW5Ux6EfPhi2s6UedIjqh7uAIQTmv/ztG0TzEHMi4QEm5+VPFrtFjenSKHaN2m/aovzrlAr6/E57dSEPrvqVn1IQo1L5GD83XHtbLdfsTTEHau0WgsO4sV/DF4Yd53FQFVnj00w6duBfxSgvlpe0DZiBigHbvomOOIVC/BkAPAf0QbEvAsa/9E5/Bcfl+OydtaH4l2aGX3D1w1TsIkkNvUaotnsv/O4c67aWXs9gp8QN8YchyUDn8VQsA4jee//sWnNR+zAK8tutA1zKN7aeK0tsr6LUtuzZ+QLzW
 pGIo7WEb
 BmBWWcdQEcnU6AQAEMj3HFUFzlt5F6RKGd2oX2Uqb9CtESwQXPdSGGNHjWIO33YgKxdV1Ek3d5KGiRjl+dS5EIUZs8M9YZ78qdYK16A3XRXnSbSadi+qi+iooZ7klK5Wlyke/dKJxKZPQeSLLLgYouh+oV8VskKiRRjXPnfVUw9foRy+nZZEpmhodNChpfm52X2AjkKZ9eV6zjVW2zRba+DbHVi6hLDOmlHYrXEEXd+kd78yLEEjLgrg6C+la5i9qxcOn+KYkr0IKxC+3QJtXz8+GeXbNOBkoV0Ui/LPflSNF5Bgh99bFrBbg8Ehdm5IwqesEzPcxdr3F4GoGUXq2mDa/iX0ik7e4iEYaPJgEMjVei4+OExk6uZqNji691OSwkFshiySt4hZZt6x041NnQ9FHr8eRFrZX4C0YTQRZLA40IjdownIfCrDeHNxBqt4Hftw6imEBmZBAR0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks make it impossible to use mapping_set_folio_order_range()
in hugetlb.  They add very little value and can simply be removed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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


