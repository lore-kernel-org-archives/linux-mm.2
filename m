Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51415C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3540D6B008A; Mon, 13 Jul 2026 05:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304D06B008C; Mon, 13 Jul 2026 05:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F6E6B0092; Mon, 13 Jul 2026 05:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93336B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A1FF140A76
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:13 +0000 (UTC)
X-FDA: 84983242386.20.A83D926
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4E26716000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N23/vW5H";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf08.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wcszhlnh+HYi/8t441HBGblr6KPlRWLy9kyix1in0C0=;
	b=oQYsqTnCdbUpLmWy9ZjTj0GfXiD26WI6veTLIVVAYVFcSfH73QyJOB0kb/AHVhrAv45Y7F
	evJNGOayX9IyXnm5WrIiEHmgy23as7gf+MB81eUgrtLvw6u9GNAMZA8bYiEEKxVqHhc2dL
	FqagrGFvVQpv9BdWG2XdooNzeVTr1Kw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="N23/vW5H";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf08.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935251;
	b=8WY6Q8/fd1SMV17OBQJ+0LkqKL3arhMzXDZsGB1GJTqvz2nEPNMurVgDxqvLNWiiSNA+UN
	ASEyn0/ryXvTFCdaUZB1/Peqa3dYraIj/P7moNjHYVhO6qIKmbVvzsekGWYD27SwoLj6oN
	BqrG/jrNbJ1vYEacc5a4pLEVQdvkEps=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wcszhlnh+HYi/8t441HBGblr6KPlRWLy9kyix1in0C0=; b=N23/vW5HpaPngWrRDYKaGv+iIf
	W/F/Iv3V7pKQ65oLZC/woEI5DZjQRKH+DW9qjDDOH0uvKSFKU4+Tilk9MXdU+lZLY4H4MQyxQKnXX
	MzDeUELYo40lJzqzp65uJBt9hsTxLWZcy/NFskIgXw2bAM3LMD2PIyWKORN9XXrQHhjlpLF13g240
	/+Xionr38/a5l1y/zVaVdBkwLoEo+Jr3jiZu1q4ttHVCVopFPVhv27IMZzaaCb6/lM45GGb3qf0uW
	AJ/9HdVWttH682sgKo5b4Y1sJbyic1LNppoOc0IdZUQaTLy8KLNte61aijIRDBW3em4NJ35+0U1Zp
	zV8OaRHg==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD37-00000008kfe-3D6u;
	Mon, 13 Jul 2026 09:34:06 +0000
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
Date: Mon, 13 Jul 2026 11:33:38 +0200
Message-ID: <20260713093350.2154226-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E26716000E
X-Stat-Signature: e87sfh3npohjr3s4ahwb3inh55wnaajj
X-HE-Tag: 1783935251-659321
X-HE-Meta: U2FsdGVkX1/SZjpihbd2OI72kS1B60HJAPtfSfxoLzdTEo4aWZAAG2i490+m2a0rmSqqsJeUGdKfLjw+Up3/LH6vpM1fMtcsb4eGENr3z77PsX2KFiSlJAAqr8sthISrpn/MYjl/BlWqdT/9L1yiLoSJliPuag/H8b7jvQ8KLnshUT0/fCmDpt55X3iQwJuWuYz2+8oKuAR6NNztqf93JTQNfD0dIIOjCqxNMv0Y7vC8RzSV0mNCGjKI2w3BRtQItn01Pxq7af5KlPvY6MRxZkx9c1y1stwia5dvUE7A4OXxrZ4DIbJX8f1br4dqwiW1jPzrfFvEucMVfQhOmxO9H7JoIhzQTeLs5CQBDGWvaVzeThd2Z/2iGeZXKmTx7XAQqvfuqCEyEvIUuimsFzsNb4F0avd28a5JY/HiKcefWJfgSsCkg6skpjHzttu1hcfEbKzntxIzorBsn3L+8qFrjK8j++0mM85QUzil4Hg9eIKLldTSt4e+5WfaWMmz26aeQbPhuolNT7QRelDNqzJcC3uokqmRLh58z6deUxEZN2yhtF3R7es86tNtkt0QlxEP+dQYU12dcVGJuivpakZkbNo07hjPo50hkllvFvFIWa1OJGTqmdRDk7zWIGeKuy9TuPMbr+sNtu7EVvXNVHwgz5IDGfV1XTMDEix2FAWz3H+oY1fQ7E2RLn+J14VXFIZRv2b9l8z3tUx1zgIoJfpHOmAG2zK3uKecdkTaOsITyHioP3bJV4bYANuMYuOdSrEhJA/vzczO+qEagOtxv59YQjNzGR/Yt++7KA9T8uGewRsgqKcU0+Ct9Qvf/jYnAPZUjQa5Wdb+gGjddEIvr8S3RzgslictBI1/ekD5sM45c4NoGg8PGXflpH9rRIuiY7mrAa6+naPO2+QiWsvmSjiDpdfwVfdeFNu1D8O/tS3Iri3BlDYfGFj13qENE6lmxI5RAaAKIql0K9iGr/PxLI4
 WBGBZ66T
 MD22lNmvHC2ku6v4MKVR2u4KexR0NDiZt8MXNi8iXuT5jcVSIcWPURqCs87MF+MJbE/tmkSItOA5PWhHVOoh/rDE6aDQzi0oKSEKXRBwXGd8Ll358KMsYyu1jF6+Py1DUxMT66cybbGRy0HwRYa77Nj6phh+PcOb5CIsusIVw4YUy+kTWQwHKNT1bC75R3/ZALzfk4UK1DfZ8QczAHFlHJyrCYqKZ6HZk6uLAyA0yi3Bajj0bsZnPcuN6S5pmIUxtWksWI/SEIpbREvseV8crHYfHT8q0Ad3sdrU6anYt9bmp+4uBg1IcLodLkNqQXTsxWssVj4arbXc6kzsuqHk4shywnzuggMKnU646v3vO1wKEipoEwLvDl/e1MsTh8ztt4JBh+dutAh6wyXRQgYQM1cfOD5CB+w4eNSnRpnLHFZvBTQIR6z41sZSkmeCQr5+/jtYdizeWhCrBrPlNSbv8NOdKC1XwNUcI0C9RqznzZdHmlwUIJcjK7CIGpQYQjroRQKaRvmxtizDgUigb5AX2bwsXAoNDDYtftao4otuoZFcjhre4DjspWAjN341gRD8xAA9sPfodWGPbH/kAjGeR2+xBHk7wUpRuGUVsqxPlB2767/Fwy6BJxPEHZQSWbpi4BC2ueKNO1DUVbSQf6DwLNhDO6sJXD+jCOdbzyX4Kgt/UcxBQmGHuFiB5yHY3FF+73CF0DsQAFUlc/D4=
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


