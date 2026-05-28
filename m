Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F04CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1156B0092; Thu, 28 May 2026 08:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399396B0093; Thu, 28 May 2026 08:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6256B0096; Thu, 28 May 2026 08:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C79E6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1746925C4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:23 +0000 (UTC)
X-FDA: 84816801846.12.9CC6FD9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A278140011
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v2uu4bSe;
	spf=none (imf26.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972382; a=rsa-sha256;
	cv=none;
	b=OxynUHWcVz+eVZ13Il++irfH7MtAS3BBUu7MGwEUIx6gk6uLSeF5z2pDLTKLoeHJLpYjCJ
	z/gb2bXcgrrVsezCku4fMSUtatNrMtk27iPqib+jOTqtCKlmNgU9uPk0oo44OPfegTrxGJ
	Tu5g3/ktoJrzACB/MBPMw5Z6TGkfy6Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v2uu4bSe;
	spf=none (imf26.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uDjbxhnXT1B5UBko/8emCOPXTVRTk3e4XerfQ/YaXs=;
	b=dmSf/OBt1WcZ9m/jHBF9UpVsGcANxxjFhPhU6JDFrEwlAqkOjaaJrdXj3A5xcy/VHo5LTM
	OpVH3oTCJQo11p+tad6TXyuPn806baYCrhVWGvdy5LBw34AeZdcaXVRpXGppg3Xvnsk7AJ
	9YJEzyeBXc8irb8V81WMijabqwb4oHc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+uDjbxhnXT1B5UBko/8emCOPXTVRTk3e4XerfQ/YaXs=; b=v2uu4bSeO8XV8HbcrBpWAjs/ro
	XE9ovc1q7K5L7PCLn226qxI4NCwFHguhSGUxkTeB3PJY9EGkgbgA8whO6Eq6a1+lcPr+rNLuepePW
	qhNPZxpyzzg1rF6MCbDO3E2D65OpYzaDItSf0oi94In6BZsB4vEvCAkRictUIk1gaxcS4Y+WrDArZ
	DFLqCVaJEFf9wx5i4eCDFW8LR3XTpp3B1SkBUAPlOcMu8th8GW1TMYkooSvuWbl4jlwZvbBSDelwK
	/6z2tHvERLrXQVzRsA1Dy/j62Q2cM1cyPBTGecmXUmcjm4l7HHWY2KQL7TRXXswQsw4RhNQ7XNV3N
	DsrfEj9g==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa7p-00000005jdo-24Mb;
	Thu, 28 May 2026 12:46:14 +0000
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
Subject: [PATCH 02/10] shmem: provide a shmem_write_folio wrapper
Date: Thu, 28 May 2026 14:45:18 +0200
Message-ID: <20260528124559.2566481-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A278140011
X-Rspamd-Server: rspam03
X-Stat-Signature: xqww16wcq5hzjbq33gzqpdw7ndgkou9f
X-HE-Tag: 1779972382-965330
X-HE-Meta: U2FsdGVkX1+GaXFUVf0V/Jt2SQMMzkAweVmJCDRqdPetI3qCQKUvVCDYwxigIhGlkLrYbC8gYVjFcY+t1VMKSgRfL9CZxb9pDCBwoMj9Nwpy9SYPnyYDLRxpY/nCMuGoKhCX3l8AuVN2QyNzfQwhBfVrdyNo1euD/XYo52SGUXVDgTXEBUc/ctYlRM/YRoVXAheLjvB5WwEiiEqVDwtQBwL3hQ1n5RM9tYAsRlcsRjKSPjiKCLXqZYGQ0mMsS0w6gQ/bA7E7DwEErGYy9LZ3gCBs8pju2zhVkyNwWYTw9wUCTSAL9y/K3Zjjrm9Yz3F8aku20lbunHst6oWm/PKcdDiiF50qbajOGalJ6MtL+o9mGR366uCHKGikqMOsgQ2iZxfA3sNwvdo1pya5U00Zm1RdgrPxryv7UbsYyiDeO1UVPmABmRQW4wzREBdAWbukoZFcLC47y36cyH6pRP+V+rFVVYQXC4WdLrCGT1P0yGgp3IioQRFDV6OrIxX1UIoLhnE9oBYFNXYduL3WpuZdztPa6jd4snYt1VwUIGg6IVFccpdSphjN4l4VQAyS4VQBRAvHWKbio0F9MFBja/nVpXQ9mVBULGs0ZS96WY5OhLdrBSeVpfMFFxHSfkeydEBl5Ew0y4TKBAQqVDcYlGKMy5WkbiWv7jsa+UcFp1Tjme/WjSTEO4ErnoMsdg5TEgDGUrZObnELN+J4reLynJzpdP1z71hitx4fxXNmi/OX0fTIl0bGlGR0oI6Ic0MLOYanB+2HHLp7pa947T87/tDvyR3Y3qaQ5TietMP4NTZX4B9dlSM/L9GYjeouQru5cYwI5cA24coyElzV6YCMyZslow8wl2NNwUhs9GJjUajXQnv0RViQZ1Uujn/mB3TxZqDVIUXg1PrTmbEQzxW4s1zLVOdL00hyQnhBndhUax9B+ZplL8g7D5JBy1w2BL6xBcewig+GWKCl9louYE5HbnT
 OR/nNqBt
 Gv0Fr+JfPcMLsrY5vxnxx0zHeWpLguasTjgLBugTDCv/bXhz9YIRKEzKaYvBJBG10VXBvkTf43F/bqIICjFEBcEO4QEUFBK3CTq7kTWj0G4UCORB1SGIABG/OJXhj7wa3cpdkW0JsYRQnMouDMLdWUbx9ndxufJ6anpHQ00PGmSm3hGdpuykTEGZrYbWufBComhMfCjpXcdcete5eY0A5tXziZvnOPaCUGpRbhWejHq5djkD7//Q4ZE4UoXZ/XPcLv4jJxzWGfJ7MZ0Qkrw3Ihz/TsTlVWxLH5M6eYz8Hj8C/Su7cv3QFfSrADjORjSp/9iBQq2TVcJI8HpxmPvVStSsD/fZvCfyZpbxWYed+vFic5+46XI6cKXgmDWo3h/oCzgC+ledWRyM9T1WFFW30SAednzw98juhcDRpYdXogOgzgAQu3na5RZvZDV84kGTThPlyHAPFu+tk+4zbjIfdb9HLiY+s7iOF9bbbGR7WUYWHIO+63W6Lw/b94wXPVj9e+l+Gv/NMD0kYNmc8kFMksLM808a4GO2x9ro0WO3lzR1vDNjphgu8uh4sv12zPyjowz4dBU3dMEXBhP5lFNWeucdWCOCVfM/sPNum
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
index 77a3e28e5160..3b6381f0a487 100644
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
index 900a539c63f0..e306523efdd0 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -478,4 +478,8 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
 }
 
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
-- 
2.53.0


