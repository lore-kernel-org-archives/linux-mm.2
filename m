Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA42C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1BC6B0121; Mon,  6 Jul 2026 05:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5824B6B0123; Mon,  6 Jul 2026 05:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498086B0124; Mon,  6 Jul 2026 05:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 236026B0121
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:29:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97E4C1C7BB5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:52 +0000 (UTC)
X-FDA: 84957829824.29.D3A94DE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id D170880003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:29:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=waKnIOgl;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REXt9YCJ19JcmX4KYzCXvW7Q/+Sj9+pTne2Ktz2J2oE=;
	b=Pt6M69YTCtuROa03qhWIh2JnHJf7DmftqGfVv6Rj4M2imXKsNJhzdQ3mpcHZSF9xUc5Rxp
	Y/VFGfOVQJx9aOU2vmpEtSi3YLCRBIa2BT6Gt6HAs9+mvPEQ4knGqcVzl4Mv5DL9YfUJ9B
	Chr2H9WlDmB1KI7YjHkR/HxRNraMj/M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=waKnIOgl;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf30.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783330190;
	b=m5HZk++k6wWiv9qEOmTqgoXE4Pgv2Tc02zkKWy11HIzzlmu6hTOw9TPLsATnzNR9EiNVeQ
	8RobLbdK6W3gmXAJF3CeKmUuHeiCpgToKA1k777k+PTx9yUXUXfSbh6UPSf0q6GHbrx4DW
	vvmI+NQfRYRY0dwoDFG6qUTVXRGzl+I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=REXt9YCJ19JcmX4KYzCXvW7Q/+Sj9+pTne2Ktz2J2oE=; b=waKnIOglODF85QjxE8UVa41fRi
	Em1i14xKzMkUpKoxYjUja7yCr3HBvuuVDHOQQIpOHgceEkDJAG8NP6UfZFEcUdoCPtUVtipgJiVVL
	rPworpehccZ78AGqEJPR84dpfkWa/F+YN9d7UFm4tJ0n8BD6XlmzaANup/MLwltPIrCyN2RXWwV2x
	6YJ1sT1iBwKItqQNbAObL/vKYmFPLBoWd+AF4U7FvunEzdMVGax1pvVXNl3kcJcpuOX1xXOuEcDL3
	9Rs7ANnudlvEyGTePdaaiDNQb2ACxEOqGKC9BaQ3I/idnUROlhUMnIjV64FWj6zIpIQ0JJortRcec
	DfmheCLg==;
Received: from ip-185-104-138-120.ptr.icomera.net ([185.104.138.120] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgfe4-0000000C1a1-1jTC;
	Mon, 06 Jul 2026 09:29:44 +0000
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
Subject: [PATCH 1/7] shmem: provide a shmem_write_folio wrapper
Date: Mon,  6 Jul 2026 11:29:25 +0200
Message-ID: <20260706092933.766071-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706092933.766071-1-hch@lst.de>
References: <20260706092933.766071-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D170880003
X-Stat-Signature: ppd9opx1jxqw3pco1wpxaijewxj98m3h
X-HE-Tag: 1783330190-513142
X-HE-Meta: U2FsdGVkX1+g5DtESCLNM1vU4+114HEQglni5IWpiNGgEC+Hf4mVi27g8hfR1C5R8LeOfLWcApRYSwfZL7tdN5mqO883IkZZcWhugmGLwBkQhMibPLOdJxRTEwigzfwuFjb9Kppqqvi6JmXj0vCKubhqbDC1hTwSONqZGiJsnV3piDzmt5gkZThSsJ/6fukfTrFMTGTZPtA/SoLqyqTDPxugEHiWIp8LqiWjV5XBLXWQo4fwG4vefGmEbo2Evj0SKzO+NzR3p2FiQ+HIo/3RvxSvUBw/0L3EqAf+1AGZYyXMyfzYZQAwhqHeMeJm/xoEiZg8j7MHqhehlIVAM0QFRi9XhGSCfy402sAddC80V2jWTmjghsr1iLscYFtGcEgcqqj/njdx1AF1wWiRtoXBXihmnI5Dd47kaBfnyczB8L2wMnqBJTB95mLflFz/LjqNliXy1/HfSmx4wzLVOtbYkp1PE0u8a0jv31OpmPp59jbnmBtd1TG9Kt5Drkix5cVSvitMr1eEn//54uUfcBQvvdxdj4WHRjeMEIpsNlhLnfWmGyxrps+4/aPOuOW949CDl/8YylYNmaqWHgYGtDmwGQ0xKTon4ID/og2WaZous5CW1NeaqPNlzatsnFdoKEfnRWdtuevTKKa5UMqTV1r8KD3TB37JF4BKiE3jlz6B5ucZpMv6IDKVje664nzEe9GPJBI5DO6ir7HacijWP+IQG7X9hLV8p0vVzVXaAXHPwuNX9MAFZQcrjL+h/FxNvbzvGrM6I4VWk9xlb1Yljp4fZ/Rdyk4cftD4TIr+G8Hqe0nH9E9Bjhg28uwgfT5Y1464s0mmA37aSrY4DXycGMrU3axUs9o89NOq0qPIdCHhl4EJhNh/zSEy+QG6aIaNOfkdpgGY6ivldOaKC2lZYG5TYInegLzqr+gzTVAmgShIJtA8gaD7w0k+SmWnrUzI+3JrnF+Dcw3zYyV3LzNrHMi
 lFMLM4Wv
 NXhOgT6DRjUSG/CENFfsvBXMEnQA4MxA7Za6UHfTZKnnR8Wf3COB56tX+uFwZf9OhCQg9Kq1pDAXuJeEtLOxP5Be795AjRjEnPAglBWNk7JFZYU/DiaevkSSLdn7a6R+2K9R6IG7Mt1hpEy9lMgygRqT4H0LXuUiJnCE8XH3PaVR5/pjdb9Y30UZ5jdtPeALO1XUM6RbWB1ZmwJvdDAqFvQGfr9zBi1Wfv/PFUAVg+tE4WY8bhd7HHTPU6lDgZxNgos04fd1vMttMpuSS1Blv66SgJudCux7CC+MNEfZwr6XADowmMrn6UKN6BQsEfj/G76xpg8krcnF5SGX+Kq7JM6mWMTc008ZgSE5AK7U4CVpPYWkb9qHcJPqFXzCGFnlZayZDx5azg6jSEZkqNoWATuHafr5G6zjOt5VZ/7EO+yw+NzKQtYtJ6W4CWVXdefeRo+ZkXkJLHMT1sePhGQOcft0Tt4eD86a5lAaCxfkTB8knCxC8D1h3P31oibafTld/WYSj3jo/MUprauyyflJFuJP/mmMScOBIWfJi+m58cXRNqblFeR8TSlJEgFtZszg6l21SeI7vZ4mGQrwJgxaCrza4SpjkNMLlSrP6axq3SQlad7qQ5Ni1PqR2a41If3ijrY9kXglOc9fGqBZRObmSJq8Oew==
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
index b51f83c970bb..6011a7f729ae 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1736,7 +1736,12 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
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


