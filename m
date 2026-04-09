Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE41F31E59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E236B008C; Thu,  9 Apr 2026 12:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF756B0095; Thu,  9 Apr 2026 12:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D676B0096; Thu,  9 Apr 2026 12:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E82906B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1525A1B7E29
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:21 +0000 (UTC)
X-FDA: 84639487002.28.B6B6872
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 000D7100005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3F3zcy+V;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxZjZnt4HjRp1aOZHRD4KUmIrZeKTs6gBzw7HkJfrWs=;
	b=GaGkoCirrc0pqUkxSKaXF9UCgQjxtl449I20xJeapNt+B10hniHlgxbcEodulErjPXfoM6
	Rlcpn5Khf2mqO1WrkQQQqUhVSUo+5J/xtWGrbPHlk9CuvRoI5g1WnopQrvOiJayLOst3Im
	zasMo8DmCphhg49PmbdKQNP9hpZTv0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750597; a=rsa-sha256;
	cv=none;
	b=NZrfbrLt1PjQxacSXipemNfOvkbDuQonaQhEWSh5Z4isiAuyFkXXtckuwrFv/k37z890C/
	Tm55/41PoWoHzDU9XsjKOelgpk+80swqVIxuRtDY8p3kyti11yLIrRPnIavO300Zzd/m3T
	B8MNM+HVf3GxPCRcBm9iguoDgJcB60Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3F3zcy+V;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UxZjZnt4HjRp1aOZHRD4KUmIrZeKTs6gBzw7HkJfrWs=; b=3F3zcy+Vfnn+iIk21Q50Vn0NAO
	Kxz/C96sZAacyVUlsx/NwKWbVCP6XH38MRwhySAW1NADMxHtNSXg33CaFaKkMAvaLv5RXUakaDTfV
	jEDqCCRNoH3LF4/qTXm0kdMgccpsqIofPS+KGFVKpaqqzC3IOrpClTxvgVSlHSHHsQYzvmjebFhDx
	qlNGxYoKHMnwpS0ELkP1LXDCDD7V0nQbfE3uSDqaG8wHH/6H2O6n6Pt8xXn9jBfh0ICR/75SIOLyA
	7qtN/ho/XjtBlYwj20NQ22uugbOsualVMrURjmEVr77rW3lkG567PhF3Ah1+0H/RAem4oueJ5cH+u
	a52yIa5A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqY-0000000At3S-0RLo;
	Thu, 09 Apr 2026 16:03:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
Date: Thu,  9 Apr 2026 18:02:15 +0200
Message-ID: <20260409160243.1008358-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 000D7100005
X-Stat-Signature: aptm84knjyf6joncm9bnj7txg7jpwgu1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775750595-991324
X-HE-Meta: U2FsdGVkX18crjaaD9sXuefUqgk+l7ub7txpNWAEBB9iDNbM2YUvEm+V9sA/jCwVpxOJaiGR5jjlsD6Tp9T3ykAbtjOoVa4zWP/O9v/mGcVMxcCrlutElO14PDlOy5CNbiD3JWQ8nq5ZJVfx1EIpjYLhpALYx1HtQtIe8Es2zi+5fPrxocw7GYIpIB3dSq3mEeJa1PbxYxmzceMHZifl4g/aHbMwG2koeRFEEpjYIq7UPN5VuvK25qzE9+T/TQHa/Xi95WUlVU2ROYXyFSPPJqg7VEQyWEl53b+EZk6XyEzbAGwAQnrHUciQ+jXPSOcpwHwSw2EVNbvWyrOclDNqYj3jUaOvdXdPI4c8EZrVGTId/4XEH/BTv09EQO0Tj5I9ilUsXMHaQkCfQ8Rk4nuzF3Kps73LJlQ6KyMh0MAVqplp7vkkEXBjksO6Zf+doPxXeDcems4GITjXcy2cEuVuC7+qluI5GV76D7sFQ1DE4sjZV7ssMR8iBzybgPmHhFtBNwRGQ5UWBzK10hX981fPT2aNraFNf6kjOpMnTsDZr/5/8rQNdFBzUux4vWD0Pc/2CUbEo+Caj3a4/+liHYJ2OIFWRx+kSCOHDoqy01aKqVir8ZcDBkGup7kCnPtLL+gR4mrwaOMvGREmHyQC4ycXdJsOYYVHp4nXUcnktgXWHn2xaLuzFd4YV6OPQw6CHSFideuUzdk3LHa9vySrlO+2TZHZNY8oxkyi54QFZKo2dMOXTLCQ3KHqYZzyArBOmrSt9oh572y/wpNf0U5O9ZKvlg3doMFAIX9x14TvJFVYy6wDEd5kjSWt6Sm6UUIOZ0mX70VcUkKBGrJDHeP4pp5VOduGvfw84fIUmSz3U8J9066x4YzeNw1Jta3RFElIiN57moA44SHAzmTfgMECeulCS6gtzArSHPjzJGHKNl7obgXPJJLsUY5o26xpffPD3d4FkCD2cGt/k/YEtXS9s9w
 GbMJcHCn
 jCDqXouusRDIN4lPhA5jQKJ4wsgxPEd/pp9MzdRhztAUin6ZFdIbc2O8/LpykfHEgSlEK2ziJzI88ZQYiM3z47bNStHC83trFMPAzk4caQ6s1vSrsnDar1lCH0FiQXMyHrhWmASqaBScsosGiCX/+ekTQDJgAfuwcZcDWi0DATD21v2LwkPIx8aMxPL+uPAPv3+eNnZ+/2wBRsky5Ehe5wqu7gEMOi4LJYcUdusSINmpd7iBxA1TtXU/P87PuwVF1xB3QfcJa2tcxvR8UAA07+dPu0IIfVKQZp23/hdHMlLGWbF/xC/yBqWltqYJ/rwygG84PpOgJqjpS87BfP3gGaMfcDG0ay+Stv4AELfxNW3xjSZdrUyoPREJ27RZuZmZtDyeT23n3G+wmdn19lfPhuPjnNcOaml7lMl9W+0Q41H+8dyPKdEgv4qxh2fLVhoO77X4F2E21GwceyPBzUeCDWzGvVstXfHRaqSH3c3DPElCWwm7m7hEC7c9ZV065qs7BKQJl3z+ZzumrMgT/9Ptt2dvu8JMCKNc1SGMz2EjL79vDJS9yPidBfU3qkIQ2ys1twfaxwfioyPowOTb4WfR+YOy5F5fBAkk8JIdq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tal Zussman <tz2294@columbia.edu>

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 6 +-----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..892dbfc77ae9 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -237,8 +237,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -255,6 +253,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f279055fcea0..0dcf78beae8a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -511,10 +511,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2c5685adf3a9..bf49ba71dd42 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -399,16 +399,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
-
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.
-- 
2.47.3


