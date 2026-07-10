Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034C4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE1E6B008A; Fri, 10 Jul 2026 02:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FB36B008C; Fri, 10 Jul 2026 02:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B472D6B0092; Fri, 10 Jul 2026 02:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E776B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:39:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 085F41C88F9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:39:46 +0000 (UTC)
X-FDA: 84971916372.22.6969489
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9E1B240002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:39:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OP35jvFv;
	spf=none (imf27.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665584;
	b=014Elbbgw7CvgC1H8ASq33sMwM5YEluBGmaq8hTfhwI9oZKViR7Yf6bQfF2UnQmN/Djzeh
	UUzKZmD3FpTBbDDuHBKbn8d0/HPfK/lPM3WJsGibGtkEbyJ271JhWPRcyiv3x/RPyN31aO
	RVC+hEdTvciJmQk3m/VPoOzl8eNGakU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OP35jvFv;
	spf=none (imf27.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wcszhlnh+HYi/8t441HBGblr6KPlRWLy9kyix1in0C0=;
	b=PsJP7LzDHGQunjS5SZiIJd4SzId33nsW9wewvQSGBYyAQiJtCpFnDnnF9A/V7ra1XMbP/F
	/kKR9fQwxyT1aq1lKA8V8uh5dk+T8kN2mKXPN1/HbvRnNNe6e710Voqk6RFZ3oewvmxBG3
	I357sMKzh7cUHfViwCI4AkMqXXIidgY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wcszhlnh+HYi/8t441HBGblr6KPlRWLy9kyix1in0C0=; b=OP35jvFvRT7i3O3Zi5ONUOEiaX
	DcrUPVsUJcgB5D+KXDj7OoqP1CjZ/r5rtOMbvSIYRBBwT8gB74DirlV14YP/6fJw+zgj9TAxlOMyy
	RYr8xcJKHwRmnvDwAElRtclEn+vtMeCUfD/EtFYwURIr/ChkILCfcVhj5HWSGPTA+flirXI3LGl3B
	FTLjevyB8CgI/Lf+ltTiSFzLPP10dp0G9zz0s/sLEJe/FFeld7U+fTmLeUABbHH5TRcWics1LhmJw
	ANXxv+CqAFAsEb/REFZKSB+L1csDz4EYO+pMQbsF4uyCgTslckSz6deyjeqJTJ0majQbN82XJRA0A
	MtyXToNA==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4td-00000004HOt-1CjP;
	Fri, 10 Jul 2026 06:39:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 1/7] shmem: provide a shmem_write_folio wrapper
Date: Fri, 10 Jul 2026 08:39:12 +0200
Message-ID: <20260710063927.1891452-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E1B240002
X-Stat-Signature: u9ph7g79iximyfci4r9mxtwzxqsgpynk
X-HE-Tag: 1783665583-211395
X-HE-Meta: U2FsdGVkX1+zyPL3iJfpOxH3RkhHfmg3j4byhIpGT5pU3lGcQOtBv/i0woUwMxEbjXeSWro0wdQKVJ+qTYo2FlxhyuzCoTpH5wmWVPjEVKX24pS9bkNbFxILNCdJAtvmGDdy1zrO7FOY4CiZCjPjQ19tt9B4PiCpDoiJteBNxxsbROySeKImXdlxy6BGLP5w/ji5Snd/uz6Y7yExbiW866flddjgdwB5+HKd7QHn5ibmwgG1LaCgdiTHlyObYIBHUB94OlSpqCtJHwGCBYMkOHv5Sk4GbKwhtGVno/9L5+nDKKJqKkv0eJ1dyqRvNQPtChzkUqIID6Vy3WqxaYAZtT6edsKvwCCsYDyHNpAPKMsUxslo9jxcpPetCzWAMvOi7ko7Q9+7c/etn2KlAW8tn5geSRSHTybdEuro4zD/0qpk00Crd5RPHgy+hVog/+tS99ivLpTJH8utyB/kMAJ4a7yiRqIya08QZGUW0Mc+nszQnptE3SRIS8TSpGlvC2tPz1b5DovbALdGHzqKz+lvZ/To5QzTUqLEBOXNumjvX6X+wKXAnXFLxNB3Y/pGt+71LE7gcKMW2Lw27NY+HeP7XPGBdbARHkXsIGL/6cUfjboU/Tba9okoafgjHcYk8a/WPYzoRLgHcuu0Rx/VhPT7ciqvsztKVjgU8zUZsp+pQkgC8TTTbmrxkOWGRnel+G8SDDpIMxqXMbRNpiFUlWcaKsWLPRN/L7jgygJhX0yEKHx3u10ZioCDvRbIlbPqvwbm4uI5Lnq3lcYgJEIvXP2lDvE8jdPf7u+OML0T5phmCzK9O04cPWKKpCS0xrCq8EXxEtfpOVXqq4+e4n28B9PgI8PAasT4GsFc7vgMMCn1C+5rzAJ+bTPyYPjbD0kIHq/5EemfIUjNE0w+lY67S4cX868+BNOlv/ZQbdZXC71QyJAHFrXervTsfWQD58NDzuR+43Ei36tZXDRWzUbOOZv
 MJFA0Qie
 Qn/tuvj/2n+4GhRwETizwoyBY3RKzYEM9+0Y9FS05LwYQL9O1l1GpS9vMSj48stGYwLvmnHgOWPsnxCsJshhe8+z98QQSMjSFHd9GCJa3rGXw/sWzsK0YD1CHnfXNm8dXnL23i8lr19HnitcaVgY4KqZdutExut3EkXB/bbphOnVQZEdIq9a1ONCJWUO0d0hKrQvG58gxTPzNMJ+LuG3aiXlYY2nTQ6UFUt0qoMxlMYdng2l/fF7S1u77YPk5XHsFqKYCAuYQciaPfHwHOuxolv2lCNHjWLSqhjn95c6p2/bvZatc/qcYTAPonZdjGvqVA9rh8Agss/Ut+dtirUTPbHc8kqXSOGhfsE9XL7fEW98TghXLdvObVUH7TpxWss7Sc1x7V2gf82PXlpI+uxMg8Hm1YutdaFXdGOLNpluicjAR0zLBuZ7abjT6FYjXdxd1pz9JE00pP2WlDRdK+GWRqQ9qA5c2BtE1DfBW7/o7ckBq7W4ZgUS62chUKQmmWsdyA4KOQY2XxCCAlAvGAQA54+IjbArXdTbNS/Lch2rrzKJ+Ez/dDl7J7DepnRKen0595GbDixTdIgIId7U3anc2hmlF08bx9SWKShiyKh073hK71ZStoFNIXCz8ZKxsmyq5jFG4qjIf04xvVEUONZRhT2QC22tqHPkKH+YOMxB1aXRat3x9QWBP4L77+qHL1d2EdhEmyghO8KiiW0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a wrapper for the shmem abuses in drm to prepare for swap I/O
refactoring by keeping swap_iocb handling entirely contained in mm/.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
 drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
 include/linux/shmem_fs.h                  | 5 +----
 mm/shmem.c                                | 7 ++++++-
 mm/swap.h                                 | 4 ++++
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 06543ae60706..ef9440166295 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -325,7 +325,7 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 		if (folio_mapped(folio))
 			folio_redirty_for_writepage(&wbc, folio);
 		else
-			error = shmem_writeout(folio, NULL, NULL);
+			error = shmem_write_folio(folio);
 	}
 }
 
diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 81df4cb5606b..c5b813a563e7 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -117,7 +117,7 @@ ttm_backup_backup_page(struct file *backup, struct page *page,
 	if (writeback && !folio_mapped(to_folio) &&
 	    folio_clear_dirty_for_io(to_folio)) {
 		folio_set_reclaim(to_folio);
-		ret = shmem_writeout(to_folio, NULL, NULL);
+		ret = shmem_write_folio(to_folio);
 		if (!folio_test_writeback(to_folio))
 			folio_clear_reclaim(to_folio);
 		/*
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e729b9b0e38d..5663dff53186 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -12,8 +12,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/bits.h>
 
-struct swap_iocb;
-
 /* inode in-kernel data */
 
 #ifdef CONFIG_TMPFS_QUOTA
@@ -123,8 +121,7 @@ static inline bool shmem_mapping(const struct address_space *mapping)
 void shmem_unlock_mapping(struct address_space *mapping);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
-		struct list_head *folio_list);
+int shmem_write_folio(struct folio *folio);
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 3fb6dbbfa20b..39521a364376 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1737,7 +1737,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	folio_mark_dirty(folio);
 	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
 }
-EXPORT_SYMBOL_GPL(shmem_writeout);
+
+int shmem_write_folio(struct folio *folio)
+{
+	return shmem_writeout(folio, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(shmem_write_folio);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_TMPFS)
 static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
diff --git a/mm/swap.h b/mm/swap.h
index b51ad3071a73..fe0b694a324d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -471,4 +471,8 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 }
 
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
-- 
2.53.0


