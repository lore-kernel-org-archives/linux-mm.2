Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDCCCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F866B0088; Fri, 15 May 2026 08:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98566B0092; Fri, 15 May 2026 08:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB956B008A; Fri, 15 May 2026 08:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 863A76B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E2BA90919
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:38 +0000 (UTC)
X-FDA: 84769512156.14.8AB635E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id A15691C0017
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=itchGDf8;
	spf=none (imf20.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH8IRyToMgLYbuHFBEYgI2g2wGkbYN8Jx+itHs7UUWI=;
	b=bHGAxO+auO888GcChz3kP058Omztp0JPlxokQzCjPzmhMvxL0B1pnQ2I+03V/R0dJrw1K/
	2LYOoC3/CzxpEFnZfo7qaaGSLzWdUY//jsTTtGK4TeJ+Hpf066lt9KCzX6rm0RvMdzWGIX
	dw7/hmVKr3MyPC1LKcWmSHZy8RLui2A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=itchGDf8;
	spf=none (imf20.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846436; a=rsa-sha256;
	cv=none;
	b=Uqp5clUGTz/yeAVYYRftQ4SeXrMOaReUtMIcYNE5e6x4knMhHx6mW59C/vuVaNOD2nEzR0
	zL7gnzudyI3QkXqr1Z/0nr8y9R293Bcs8iSKzTTNTnEgniXoGg9Hi1dHwJ0Eyo+KoJDvhT
	cp7xmbT9/6c7ScFP+Xkx3g+5dKJcp4Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aH8IRyToMgLYbuHFBEYgI2g2wGkbYN8Jx+itHs7UUWI=; b=itchGDf8eA+ye9/ncfbAIpmRpu
	n3yJezg8DvaQpo9htpXl/hi0gm/5LEeZuQ2sIKP/+lPl8JlddJeTFgEgv6t/tdjofsO1zB5wFE+NH
	teBeRGSDxSSEKSWXU+j76Dd+lTHnb83xTH4BGi23apVRvN9Ozd6fmlbCH8aPSl46UYqTSarSm35Q/
	DLPOrRUjgCYkEYxStAirNd56N85PC5kb621bgaoXrCzzjEKXghlK8tGT83pSlJ48mOZoINMPzQ8+Y
	ZPHZCd8UJKcYVscEySat4mNKpv4bdVIrBsW0eeRDBjQPWz48pHt9rHyY/Ysg8uo4wzywMStfxMk5J
	7dk1qVpg==;
Received: from [2001:4bb8:2d2:300a:b132:4044:9ee9:7f18] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNrDR-00000008GUB-0dCk;
	Fri, 15 May 2026 12:00:29 +0000
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
Subject: [PATCH 1/6] shmem: provide a shmem_write_folio wrapper
Date: Fri, 15 May 2026 14:00:06 +0200
Message-ID: <20260515120019.4015143-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
References: <20260515120019.4015143-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A15691C0017
X-Rspam-User: 
X-Stat-Signature: 3mu8t7m9rszfmikourbc7se54i7ua1w9
X-HE-Tag: 1778846435-162075
X-HE-Meta: U2FsdGVkX1+7yxWM5MNTI2DqKe38E1rp5PqZjO+Ho0S3X8VQ1eIRnQ7V6tLb5OadUFhOZTENhfDBtLIuJKRDNy5vVST7P/E/mV0VdzFC5Vqax3eMGaJ6Ni0wChYnZDBcYBQvQhjkwVOLr+tQd74b7qVM6+ev2emUG/MR/wKNT/voEk3UBD+pfocjCRIDbKnjXOvdeYGhkV2dea5P7qDdS3N8sBl9FEugDH0rwlKFilXxWInBLxkyUBoA0NVKZL/j0eH3n/V2whMVew7YfR7ymZM10rDJTNnpBZmi2q0t6/nVbl7BrkMicrbTdmCZQkS9NlhiTQkfCmqYXfpVPWn8ujVl4SEn2gKEHVT8hMt9bYN6/3M/bd+fXMO4l214FY6jY1uuuZCzJfeY2eOCbeV4cDrSIG/N07dFpcL4143nY8k0jXQejwz9DYtIpaCGI3+1ShaxzSi99saArEj6G/TqaGTdmeHrwpKbfVn/ZwSp0LfdroU0v9vOyFdM25hbqPIiCvvf9FV2AennG7qfz0W+g1lIEOCglBqVZ5SaK4XpWYr3v7aijhs8FrkolPPJGnmDy/ecy3k8YwLoh6TYex8lEv4zgDogR83kL9Ki0ZjChZtDXb6iOvv/fgwub1zsefHy/4atfOC8PzaOtDHhpnXHW2x+eGz/pkwkNk2TjqEY7n/IHzkqL1XYeyG/D+SmYz20ao0O/gDPnV+GQFw8ZesgzZReIqSBvOb+CxJHN46/e8Eab9vEzeMexivL4KLxjfdm0r/fOclOSsfUeWGYV2R5MeVoR0Amk1/gfUeFtBYX5tkFXrj7vPfSmSzQSSxTsqBDEEqrFfJnPab6I5ua89yNuelpRe/I4kkCCkyjPla3qf6EIAo/MTagf17YC+SeghAxMbr0DJusnDwslOZS1FINXW07/kEAT+KOjwVPRDVGv4AgqkecRtSQKDFEfR++xtUNGc+3oLxGZ3QQXpoc8LF
 7komEPEh
 59YLnnku1Br/21Lbpt0bOEUIb0zMx39F0/VoOIGXq6f8TNVTAuP8q0fuGIBD0ic71qRiTS839hMl9uc/Y3NKktMJ+Bw+O0xebtQ4ELsk9IcKq/6ZaMIdf2MQPx4m2mGkO6RhNwrpaN4DVGinn5BfCoUv9iZeUPgJV9s+6PfwSJOsH8uEIvThZ/+coUxuRZ3d61atibIYuT2YgmwAAIDz6ZrtcFsAbhwenCHL3sduSbjxUzBcoEj05eXp6yFvrOunCiMT54417qdEIpePYqhjOQC7KEVVqsTNByvP1LHmVyMc8tcpP7NqD5qjLwOlKOsdpvqQ4fiHPy4CbzAARu/ZicXiBU2cXpwBsxGKHGEBHx6s/ILfFPrqdEMFfW8kldlEQqVismTANxhZAGVDUDex7plcdfqS+pPC03tgJW5YV6wk6YyYt2arEJNMKldoEVn6mHbPPcPJaUsxCmqzVbQLGVDXnVIDQoCeur/SgxHdsremayWD052uLM151Ba8xZuU8pVPx8sHKegGV/xOmJYXqxE3wLYhZ6AKo6esCzc37iEs3DdDAI1PmL+PUdnXwQ2jxJ2rGJyh4x7gJ57n9NQe9yOTZSn+Gkc+Qi0Qo
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
index 93a0ba872ebe..ab404effa879 100644
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
index 3b5dc21b323c..b8becbd4beaf 100644
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
index a77016f2423b..b6db72fb9879 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -499,4 +499,8 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return 0;
 }
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
-- 
2.53.0


