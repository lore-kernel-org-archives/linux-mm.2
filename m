Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5478C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9126B0095; Tue, 21 Jul 2026 13:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0406B0098; Tue, 21 Jul 2026 13:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6F76B009B; Tue, 21 Jul 2026 13:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBF566B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:47:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5639FA0902
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:47:33 +0000 (UTC)
X-FDA: 85013515986.04.FC5CA06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id E1F5B80003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:47:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ax53tiJz;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656051;
	b=dp5bqosKqeSPYYV7ETGNloYkh43yv/gfXWD5ndpgL3pkFUZBaFueLKOkfLHjNldYNiF8co
	uNdjrho3M2vOMiENvQCEV7OlYwSMgK31V+09tIfrLbAYUpZe0g9cD/IYynOTlxqZ//jy8F
	Wi2mdSLBBYkCh8V3Hww8CyQUhX62E7U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ax53tiJz;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OngHp8TaNpxv7CdUVfeIUxgX3P7WDJwYMuU1X+eCUsU=;
	b=qEHvFIIc0PXHOmw7kIBEyc8JH9xB1iRlUTLYIHVPyH5Ayr5gKfPg4Wfye5SZ4JYwsranFJ
	YIsu2iAx/GDK57noMU3AYzQvLMRFuc8f5K0KiGbqtq1+rrdMX9ZoK1trqWOIbHxeLzR6pN
	4Z7M/mGJxoFVqY8XHE2Sn4wIbyqpS3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784656051; x=1816192051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v4Vt/yYRyCrs5YArEXYOsSp60kX8kyBYsb9DQf+l+6E=;
  b=Ax53tiJzcJmuK/RISbE1HYqe1aSyHkUfw2h5iwYNfIayoSG+6vVyK5jO
   PI4n9Zl+websIUh97mgi1D3lOuN5RSAm6esR2DqV50IEqomc8L2tmHNaL
   tpchyTL8/oyXoiInhO+fnb9lb4Kp5lPjNNvlrH3o29O9Ewr4HzPBdKPGa
   bRN5KufISFR3qpJm6lB1MMlNNRz/7Qg/kO4ghHCgrdGcl3IRWk3djZ2Z0
   WUl6M9TLyC8cDJjqDD4/FOb2dqERfwZV0epZ7joVSn4On4VqRdYCpdjw4
   7l3aD4JssvzIO+APmJbEGV6GzHm0lp3CZ86g+pFaHNdJW6mGQ/Rc/+UdM
   w==;
X-CSE-ConnectionGUID: hIJcmwuTQeiFcDzkZdMpGA==
X-CSE-MsgGUID: 1t8xAt3hQzGgMxwTrcLYhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="95920589"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="95920589"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 10:47:29 -0700
X-CSE-ConnectionGUID: 8Or/jpK3RNG3krwaVmCSCA==
X-CSE-MsgGUID: 4u2s0VJuSpqQqnSnB2iVKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="254418012"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 10:47:29 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] mm/shmem: add shmem_backup_folio() helper
Date: Tue, 21 Jul 2026 10:47:22 -0700
Message-Id: <20260721174723.1039395-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1F5B80003
X-Stat-Signature: ndbxko4jxi3tahuhsw7w3iwuxikzodpc
X-Rspam-User: 
X-HE-Tag: 1784656050-335616
X-HE-Meta: U2FsdGVkX1+hJlJ5AmwIgQseTvYeQj0B8MGjPwgNXtyHsEvvRVTOcA9WmHizGxoK1yxYMV/qcSWX+z6wvnOnIV8jgBG/20E0cd7YLzEviGrNwk9hMEJZ4KdYff7z7T6TMuOWQFBAYkb1Dce29jNWlWgMowu1icDOa8QA9dHxOoQj5lEijlT6W6tQkLoDEpnfU9ibN4dCiSzLO27XKmtK4OcGqTaFCBcS1zKHeXl0XVY4x3pc84Lw8t2LFbEDDpoQeyH3m96PDnkS469yYaylXpV+bKm4uL5DsJbfxXq9OBztb8lxK367Wb3E14zNAX2/BEYgNVL0jzwLlRKXjc3b1cvFDx32hkzoT4yvy8Cj74sGue6LDI3QFd6riJXVlgxU0KY3V1y6d6rmE31HyLWvNYC7vHJnDuKh8Vh7lcjJawqNnrNTtSaEq4GAwKaBp/A5AelvPAJMn2lFwZkpSJmMaNfxmV2e1Dlte2rPXAGRU7B3xWiS9abS6OyILUYbfrZrcR2TP/pJvWph/YlWHScUpR3lhrUtKerLXS7ddpmARAEllL94MK3mAQIB8SvvXMRLO6paEzL3VT38DmQpftb4yMbmh71dmNChnsLIXFEHSlQMAywt3HntfD24l+U7m5tIh91TaCDTElqoqPzha/B6SzP/nUSSKQY4lyGeNSCBSltmgaVH4hAco4lWzJpHJzhm+gh2hSqlk2mNRlde1Amc4GD11C3qXQf9Y9sLCZs9VOGwQvXH+f1eroSrOMjfPh5F5lxmHBBAOjEFtSnNnAUGLWLJr5Gu1VKV6gUirBj2w41qtrGRhJbr7ThCSVcZc5XR/ZEMH5m2He2/9StLQX0dUoaATlbrorZyIbzIds4Z0BVxraTFSIKwwh/katrFvRophY0SwROc24Kj12Y5PqBlePjCBsX3OMgLHLJoxXe1BzmggdDpP1qUQD8iDMUTilSbDcLfsVhCnTyh06Ck7Ih
 apCDiQyx
 fX0VkGQlCzHOdVhHBOwOx2JRiZGaC13uUKCmEVxt7Hwr49sn9+VTyH3HvL2COnSeGRWoq/00xsCKAZbnLE064LUsBIZShIuilXnE1HlinKrCuJ4HXcT5M1D+pEZx/iR/9JYciq/M8lK0xFw3/4/RuMbbS3R4iZfRxvoePoYSWIDem5nuO5dD3SfwCcnyjvsCeEwzIObxUShCTf6oEmIjNgT6E+EeylD6QkO40JYssgtbri6P4iuXh+8j9GhiRSpkOApxDBPELt0s2JtdIISd17fBCvTlbuUld80TwB+0xNxS9kQdUl+U0v+bT3ypN779sPBCeDLuSo3i3VU00R6adjVsqXOqF3vbvyVd0RXiiubnZHmIw3Tp6PN/mbg/8c35b2I11ksZoTWNHpd6vS8flFlvUr0jQ2WDrCO0Bu2T2895xTlWL/b6ibLI7eFldR+xw5I4vh2RJfkjSo23zalkH8feIezCM/crc/L7J6CjAhSgzMORg9OK1vjl5HvpN0SQRp4+N/YLxwc2tH2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new generic helper, shmem_backup_folio(), that copies the pages
of an arbitrary source folio into a range of a shmem-backed file,
optionally issuing writeback for each destination folio. It is
extracted from drivers/gpu/drm/ttm's existing shmem-backup loop so
that other subsystems (starting with TTM in a follow-up patch) can
share the same implementation.

Semantics:

  - On full success, 0 is returned and *nr_pages_backed is set to
    (1 << order).
  - On a mid-range -ENOMEM after at least one destination folio has
    been populated, the partial backup is retained: *nr_pages_backed
    holds the successfully backed-up prefix and -ENOMEM is returned so
    the caller can commit that prefix and decide how to proceed
    (e.g. via a reactive split-and-retry path).
  - On any other error, or -ENOMEM with no progress, the pages already
    written are truncated from the backup file via
    shmem_truncate_range(), *nr_pages_backed is reset to 0, and the
    original error is returned.

@order is passed explicitly rather than derived from
folio_order(@folio). Some callers (e.g. TTM) allocate high-order
pages without __GFP_COMP, so folio_order() on such a "folio-shaped"
range would report 0.

folio_mark_dirty() runs after the copy loop, matching the kernel
write-path convention of lock -> modify -> mark_dirty.

Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub-Copilot:claude-sonnet-5

---

The patch is based on drm-tip rather than the core MM branches to
facilitate Intel CI testing and initial review. It can be rebased onto
the core MM branches in a subsequent revision.
---
 include/linux/shmem_fs.h |   3 +
 mm/shmem.c               | 125 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e729b9b0e38d..541f1ab675b7 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,6 +127,9 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		struct list_head *folio_list);
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
+int shmem_backup_folio(struct folio *folio, struct file *backup, pgoff_t index,
+		       gfp_t gfp, unsigned int order, pgoff_t *nr_pages_backed,
+		       bool writeback);
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..bc11c4039b7b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5961,3 +5961,128 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 	return page;
 }
 EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
+
+/**
+ * shmem_backup_folio() - Copy a folio's contents into a shmem-backed file.
+ * @folio: Source folio whose contents are to be backed up. Must remain
+ *	pinned by the caller for the duration of the call. The source folio
+ *	is not modified; on success its contents live in @backup and the
+ *	caller may release the source memory.
+ * @backup: A file previously created with shmem_file_setup() (or a wrapper
+ *	such as ttm_backup_shmem_create()). Must be shmem-backed;
+ *	non-shmem files are rejected with -EINVAL.
+ * @index: shmem page index at which to begin storing the backup. The
+ *	subpages of @folio are written to consecutive indices starting at
+ *	@index. The caller is responsible for ensuring the range
+ *	[@index, @index + nr_pages) does not collide with other in-flight
+ *	backups against the same @backup.
+ * @gfp: Allocation flags used when reading/allocating the destination
+ *	shmem folios.
+ * @order: Number of source subpages to copy, expressed as a power of two
+ *	(nr_pages = 1 << @order). Passed explicitly rather than derived
+ *	from folio_order(@folio) so that callers may back up higher-order
+ *	page ranges that were allocated without __GFP_COMP (and for which
+ *	folio_order() would therefore return 0).
+ * @nr_pages_backed: Out parameter. Reset to 0 on entry. On any return
+ *	value, holds the number of source subpages whose contents are
+ *	guaranteed to be present in @backup and reachable via consecutive
+ *	shmem indices starting at @index. A value less than (1 << @order)
+ *	with return value -ENOMEM indicates a partial backup that the
+ *	caller may keep (see below).
+ * @writeback: If true, attempt immediate writeout of each destination
+ *	shmem folio after it is populated. This trades throughput for
+ *	promptly evicting the backup from page cache. Only meaningful for
+ *	unmapped destination folios.
+ *
+ * Copy the contents of @folio into @backup starting at shmem index
+ * @index, one destination shmem folio at a time. Destination folios may
+ * themselves be higher-order; the copy loop advances by the natural
+ * order of each destination folio so a large destination folio is
+ * populated in a single iteration.
+ *
+ * The function distinguishes two failure modes:
+ *
+ *  - Mid-folio -ENOMEM after at least one destination folio has been
+ *    populated: the partial backup is *retained*. @nr_pages_backed is
+ *    left at the number of subpages successfully copied so far, and
+ *    -ENOMEM is returned. Callers that support partial backup (e.g. a
+ *    subsequent split-and-retry of the source) can commit the returned
+ *    prefix by treating handles [@index, @index + *@nr_pages_backed) as
+ *    valid.
+ *
+ *  - Any other error, or -ENOMEM with no progress: the pages already
+ *    written (if any) are truncated from @backup via
+ *    shmem_truncate_range(), @nr_pages_backed is reset to 0, and the
+ *    original error is returned. On return the caller owns no valid
+ *    handles in @backup.
+ *
+ * Context: May sleep. The caller is responsible for any locking of
+ * @backup's page range against concurrent access.
+ *
+ * Return: 0 on full success (all 1 << @order subpages backed up),
+ * -ENOMEM on partial success (see above), or another negative errno on
+ * failure (backup fully rolled back).
+ */
+int shmem_backup_folio(struct folio *folio, struct file *backup, pgoff_t index,
+		       gfp_t gfp, unsigned int order, pgoff_t *nr_pages_backed,
+		       bool writeback)
+{
+	struct address_space *mapping = backup->f_mapping;
+	int nr_pages = 1 << order;
+	int ret, i;
+
+	*nr_pages_backed = 0;
+	if (!shmem_file(backup))
+		return -EINVAL;
+
+	for (i = 0; i < nr_pages; ) {
+		struct folio *to_folio;
+		int to_nr, j;
+
+		to_folio = shmem_read_folio_gfp(mapping, index + i, gfp);
+		if (IS_ERR(to_folio)) {
+			ret = PTR_ERR(to_folio);
+
+			/* All errors aside from -ENOMEM drop partial backup */
+			if (*nr_pages_backed && ret != -ENOMEM) {
+				shmem_truncate_range(file_inode(backup),
+						     (loff_t)index << PAGE_SHIFT,
+						     ((loff_t)(index + i) << PAGE_SHIFT) - 1);
+				*nr_pages_backed = 0;
+			}
+
+			return ret;
+		}
+
+		to_nr = min_t(int, nr_pages - i,
+			      folio_next_index(to_folio) - (index + i));
+
+		folio_mark_accessed(to_folio);
+		folio_lock(to_folio);
+
+		for (j = 0; j < to_nr; j++)
+			copy_highpage(folio_file_page(to_folio, index + i + j),
+				      folio_page(folio, i + j));
+
+		folio_mark_dirty(to_folio);
+
+		if (writeback && !folio_mapped(to_folio) &&
+		    folio_clear_dirty_for_io(to_folio)) {
+			folio_set_reclaim(to_folio);
+			ret = shmem_writeout(to_folio, NULL, NULL);
+			if (!folio_test_writeback(to_folio))
+				folio_clear_reclaim(to_folio);
+			if (ret == AOP_WRITEPAGE_ACTIVATE)
+				folio_unlock(to_folio);
+		} else {
+			folio_unlock(to_folio);
+		}
+
+		folio_put(to_folio);
+		i += to_nr;
+		*nr_pages_backed = i;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(shmem_backup_folio);
-- 
2.34.1


