Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7892C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E956B00A0; Mon,  6 Jul 2026 09:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDFAD6B00A1; Mon,  6 Jul 2026 09:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5CA6B00A3; Mon,  6 Jul 2026 09:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7973C6B00A0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:22:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C93178DBC4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:27 +0000 (UTC)
X-FDA: 84958415934.15.C4A5860
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8BBA51C0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="bP7Nj/6K";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REXt9YCJ19JcmX4KYzCXvW7Q/+Sj9+pTne2Ktz2J2oE=;
	b=UlcLbsLVHRaYmMl35LEVqXsiRafGu/+McAj93JIMO4Gk7a5YxwmSzsPtBb0cMtVi54MAqQ
	gNtf9FkAKretjJvQa126NdDSO7C8Oh1rGBXLbwUy5oas6vXRQOkzbMBUVucuqw21BOk3SE
	VAp5+KXF+MdgtjTY1y2EKDDP1eB+1Ls=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="bP7Nj/6K";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344146;
	b=oWE94/cg+lzXra8+21mDQr7E7DocblYefDGZxQSnVk2sCWMKuFdnLvndidLAr/4VogULJn
	uq3CNAe5c/vj2IT5+KDdpdNIKwgRt1AOpvhP131lwM+a+FdvQ15SBELQEFglds8LKBsMiX
	KU3TCIXBdqlZfv777e0F2vWXd7BDtuY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=REXt9YCJ19JcmX4KYzCXvW7Q/+Sj9+pTne2Ktz2J2oE=; b=bP7Nj/6KVHklQi3bNjqHWbxCo6
	H3CLt3c184CU7PHDRRmNiU3aq8qLUG22TE3nhjKllWdQj0mX4tUiqsFPvaq4uI0jrBsW4TC4UxDdV
	PdZADb//jqkiiGvAXdnAYWOpQmvB1SYKHYptbEo83RO6LWN2UCziX5FMZW23uGgN2CADCQm1n6WeZ
	yamR5KgZ0ElimooNz09N/I7i/h0IV5fTLsRroIvTG4USEyR1iQd6iKOvMbUQg7rU88GFTCNhGgU7N
	37seW36ttFt2vqzyC9Hci/gwultSsQVTFdUgBDiXlreWxwajPV170xWiKAZqSHQ9dY3R/7sjvVmW/
	IbLcRJHA==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHA-0000000CaTG-43yI;
	Mon, 06 Jul 2026 13:22:21 +0000
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
Date: Mon,  6 Jul 2026 15:21:53 +0200
Message-ID: <20260706132206.935272-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BBA51C0003
X-Stat-Signature: fzxa76wh9jujhgjd8dcsyzy6c1x8qxa8
X-HE-Tag: 1783344145-566681
X-HE-Meta: U2FsdGVkX1/lx7NjrZOi42Te+sCdMPje3ZhMsm8vW5K35TGLvizaDfpBL5s6fsUIv3ZFz/VIOnxJoifBNxlxkVAYc3EPHZbODGull4soXHVzW9y6WtWR9rk1DaYGHku1/dUM7K8p9IZ+m6KXafDMPK+vdVs1d4/lxyN1mPPmAcjZkn+h+oW5ayjjNPklx3Eb6vfih5ZhC3iXij0ZJVJmCz4pmtbNnvtprgFaR4w55mnTR2ajjSHRI1QveRL/DJP6829Q1kpICdAF2CSI9Q5DRLZvDBLCLU8cLuQqxXQTPWnolCntxRTMAMSAJQWE+5UPD3dASod9W+TR2dwrVLHd2tFwhljhZLWAk7rtfqq21wG6vZj2mG4eibWsu8K/de+R4R1uQ4EOpZX2XqrTVFxtB0VqslraH3AlwAGayfIxos3ZE5rDQbb96lFBtlOrqmwlK3WXfr+ZP2HviyOFKW2YM8PaqROmfNBwyCNT21ejSP5kCaMIVdUNfUq2hyZpbQS68dJbA8nEAOEcYWiksgBEdxL4tB/Fx3BegWKCIDuVloca1h+SsnRNBpO8cKHXxQ82HHGcoSzE5iXt//7UbPoonjz2fkJqyntFWQqi8GrZjaTlKGRvTuN+SUAnXmMGg1oIpW4WO0vIzd1sjJlj6P9Aq+dtZGteW6EvoNLq78iLeBOFZbbGBR14echRiVRcQ2M/2urtGunFgcuefc3I9FcHSJVTmk8fcCnpCj3A34IchFpIegRZWY7K31v7yZbo6ohBBjt+G8c8sZ9Ay0h5DAqtpNeGPRcNRE2mvL0kJEyBYitsWUHM7b2t0xv6WFTK6QDKQKMjvtPqK/UUr8Wn/ee/aMUFZ1dZJ1D9LyKYc+sWn/EyG63X4QPeVLgadQr1dJHH5CRpOONs5p1hF80Uzcd7nyKv4pAFGVhnk0dFghuXJ0i2D/CzV5WrZhREvHyeqia5X0WigZlhEwCufpQ7TiE
 4LLXGbpn
 s7qu0h0ReNMt95p+ya4GaAElv/IBSwfZtVSte7WebB8gnItIz4Je2BPb9JqadFShvnTupKTBtgWV6P3qNjfDis99XJhJdAvuEir/OCb+Cj+i/9RungvDkRqIM+RHPxzOlrmqy9/veASNu8LyFL2g9I3clWn6Bc5IcUyHzw3AD/0e8HOeoM9kPYeTC9Jt73FfYJXbcPCCdDWOcTwqoyFAK1h/azyN5L1llNNahdugeusG1hxD/LKANtFj3l38V+Qp6PDQvqZ8Z7bU5g+3F+EtSg1V05NoS3mkThbT80IK4kSQro5ji81niqAsbzpu4/P56O4MMykc1TvbxVCpSD1EecRXUiQgrGHPv2XumYT/Kw51FaUlY1+5Osw3N1waaex9jANnEUPgwDHq0RqHT6f1iy4LRzv9+nlvUyzEwUaUcyRH0ktY3lVBa7apDoVgfDhFwgkEnQuMtr5cNLKIWzG23wU1XIYWRkRG3wjN3hXS1SwGvw48aL5EzvwDFYmSZR0mS7QaMtOK0Y9IJJy1rzxw7UsAJGHamHSEjazKBn8WMyd+LRIHnyrsHariGi0Ez+cZ38VtFhnacmAQy6rzBffvPYnfPAvAXLbXCxpHb1FbzcokJCrPTe7uvyGpEqN3thtZsvWu6EOjfv8nktoMLgbbk2ldbOQ==
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


