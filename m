Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD6CCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD466B0336; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5A16B0337; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1125B6B0338; Mon,  1 Jun 2026 07:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 019F86B0336
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:35:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2C39120661
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:05 +0000 (UTC)
X-FDA: 84831137370.13.DA2BCEE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD3591C0008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Sch1pcMI;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJSGUUI/w2FCCrrgoq9+BQFr97pcofI53vNjpdJKHzA=;
	b=j0EwYmcWoacCaJn4NJHmkxJbDpzAUhZaAWslgwtPSpxTRQAAe+9icQLnd4ZAgm4MxZHAwQ
	Eqsl0br3zoM2cDzfo5aYLzM8ahFK+Mc/mABtVjZGcUBDfvxlAQHwhLiDErYjvHyIbEGKqA
	Ytk66xsJGcBrCAcqJYu4d7cS+LlRg4s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Sch1pcMI;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313702; a=rsa-sha256;
	cv=none;
	b=1sknmH84v86MmqbXoqx52YKWUwgroPcZsQL8PNe+M69adVCk/eudsTtvYNKUaaBd1uvaNp
	UkLYM3JOWuUUhMxknjrfcvijnaTSik3VIzpPTWWGjLbMVv0/v9bwQX9TBkISxJ6STNwkrT
	cjPuLo5j1DudrbX40I/+rBYy3jADMUI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GJSGUUI/w2FCCrrgoq9+BQFr97pcofI53vNjpdJKHzA=; b=Sch1pcMInzhNXjdES9dKZWlUK/
	HRyVuDkETqO4V3zMxUo1KWVHsaQrBSXLadfvNu/816vcncLzhyL7IsUJ0Kv7Eo1XyM+K2eyJQ2V5K
	z3KcHtdcgKhfpQ72wKC89bpUk6urg99sTDTWsXvHq3tT3kanDdIX0CKABxo91afZxQ4Iex7rcYzTk
	cZfPw6FaiWiBTeZ6EaUWNp/LvhTyjO42YEOFS0JpmIuov5ti1Q4RZsrfTB3dMhfVgatWiXr76OZO5
	PaMIqUGRVvvbdwCHoiy22xASiCOQSBqcj1DTVFiZFUTcHi8FFbGRM53i17fVP2aVaUS8Hf2uYpTx3
	KTpIJMqw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0v3-0000000AkZW-0GpR;
	Mon, 01 Jun 2026 11:34:57 +0000
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
	linux-mm@kvack.org
Subject: [PATCH 1/8] shmem: provide a shmem_write_folio wrapper
Date: Mon,  1 Jun 2026 13:34:27 +0200
Message-ID: <20260601113449.3464734-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD3591C0008
X-Stat-Signature: deur63zynxjy9hk93y1ox8pr5yw46fet
X-Rspam-User: 
X-HE-Tag: 1780313701-383375
X-HE-Meta: U2FsdGVkX18s1+0eodsg1LM1l2y+2Rc+65B221jvxp59PjhmiBsPBDRSNZIWfqqrhr5Ft9iRasExFiGrmPq/ycu5SvKcvko1llDd4gjNhkWKcb5G7IRpq1wZl8aikNTnMv7FbLAo1IIN8wpw3NlDslkrvxzkaL3I6Jg4GE9MwdLr3hWxKW0CBOQdXJJyOhmTVa1YAuyKQtOZM/FRTymF1LgMvJNcwfSDDg3xrYPgj5ubsRE5p3NwoCu3xpLWTij3APfzxXWoOCNGJ1M4AY0UTmnICyddogumXbju0dFsmsxf/0nuJhb3699cU1TqSO+vx7qhx8oiNREN/OqSU9421OrgwYrq5pNSTossKOkhwWUWv8GXcIA2rE8H9qMy+AcpMlYrRpoxEJwg0zBv5ewhAYFCBgX/YLH9gQle44Z9D1lumvTxgvnBp5+rS4wyVqJ1O3qY2KM+4Woyg/y10MyWGbIJO04K1YFUkHzctYSd3HP6gvHYjpNhT3HNznFWittyuevD3T4r3Hk/CTuxFF1GwY03SeIlz6ckcX/AaNUJpA3hC41ZGnf+pEOIgfgDPtvjOjjO5n+FpqyuzE3C4voZj9Ngmfl+171iod0PQ2P5Uw3hCaXxuMJme/bemMXYvVCIZ6CgmwqGykLNFNXDD+domBaAhKNXh0M0ajXAJn6TQ6iJA+blJg3eQ/X1Y+E/KcoQF3yGnaVi/X0H/+Nlh+2XQ+sC9l4sjuydeQ7QtXX1WnHKBLnaXRhp4tPcnSaiRZjW8hh0n/MxU3HhO141vakU6sytJJEv4K2qV6qbJb+d8tAW1c4CFI3QaBSnBoQKXVWNnb2wSVHuDq+kWorkIMVHOGz84MFWZqSVdczUYCn/laF0AriCga1u9gCDe28P9b/HUj3Cmv6r1TJGbOksxv6EwaxBCRqkaUPjQbcKZQ1MsfrMadOoMvbJVvEno4tL7/B2exBSflMod9ATLp9We8m
 Y0o1Gx0s
 CT1Skkx+ea9KhFF6y8Mp04O5nafJqWj6VyVeyvPyp+T7zd4hqlvNAb3NFbMPUjvE/0X5YS6t+fSZLMy2RhehTSYbi+xbpWZ4CGsRYxcPdEUfQhQHOLQGetXOBk9H32p710HpXjaYKTHkXg+1l+hh4MQQV1irzN6a8qrcu1j6oNj6SyPMBNAVI6Cs6iAwTRkr9xMF2yZJCEZI8Ncz4/pIoHRI/vH//DP/fI43RA0aidzPecA/zwnikKwIDK/3L/FWzpFuog8ki9O9iFDggLWcRvigSLgYPshvr8wRYbZomyhAuBdVJ7TGPOFKNYPvUdFOf5/5DQiONs5QYQ5hvkWLuRC3zQc6eB5ey4hNz/M1XfJsIDo0fMoDKr6mTBESQ9BzEH2zYiCn8k3N7gpDL2SArnR143b0BQnEebEGdcBujUU1YydQHQBM802UNXTTbagtAqEy609UbXGM8fOGT4B5BZLycMkZg37tye8Xc9C4+WOxILGVWKEsnPTGbZGcJ1AxZQUzEvCUyfzz2BIPR39rOd5ZvDAmfqu9rVAZqn+wsHsjY+ippvv22NL60tMBBvLuzRCHNNIUHYqezfvKivGuC5YBZ0GKlc+OgsG62
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a wrapper for the shmem abuses in drm to preparare for swap I/O
refactoring by keepin swap_iocb handling entirely contained in mm/.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index acb8dd961b45..f35c752f27af 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -12,8 +12,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/bits.h>
 
-struct swap_iocb;
-
 /* inode in-kernel data */
 
 #ifdef CONFIG_TMPFS_QUOTA
@@ -122,8 +120,7 @@ static inline bool shmem_mapping(const struct address_space *mapping)
 void shmem_unlock_mapping(struct address_space *mapping);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
-		struct list_head *folio_list);
+int shmem_write_folio(struct folio *folio);
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 56c23a7b15c7..d10735e49b25 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1738,7 +1738,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
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
index 77d2d14eda42..4f86ef338a60 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -473,4 +473,8 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 }
 
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
-- 
2.53.0


