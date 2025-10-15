Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1868CCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696F08E0018; Wed, 15 Oct 2025 02:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C8F8E0003; Wed, 15 Oct 2025 02:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A95B8E0018; Wed, 15 Oct 2025 02:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 472558E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:27:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E384B160B6E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:49 +0000 (UTC)
X-FDA: 83999367858.30.1D77935
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 53293120002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YhXywWnl;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf29.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2S6yrGSJzKiMajpaUI8vM4I6Sy7cVl721scCL8BqWLo=;
	b=mfIPpEVGeE511UY5jXQ+QWUjg2DKF0shfbzCOGoJKH6Rtctaf5mPvyMCFkeWhPQeW5WK88
	3CGOL2ce75wv3beb67HTB4409pPYiERx5Lx9GKdihDIV8MY5FhaJ9ldv0zLQH8zptqx61z
	7sA900CMBI2ZygMj7tdpjmrjRGtSQV8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YhXywWnl;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf29.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509668; a=rsa-sha256;
	cv=none;
	b=skGPRlSWJAXM9VY/5G7oBKZwB9J8neibhMXxy/FmrVsQ269gB4dI/bhk4U+t4Cmq4oChE6
	phmcZ3wHk3nq8sXXO0ZYdGGcI4QUyNfIFLyBmP9aPojDFCwzYZemx7Bz4Kf4TY3ZuAdx0R
	47CdKj7DyHvmD9adXSsCsx312VHrzpA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2S6yrGSJzKiMajpaUI8vM4I6Sy7cVl721scCL8BqWLo=; b=YhXywWnlybvD+Q4MLlpCLaT2LP
	/4L8CGInDcz5hr848E1WMd9H5DoE5e4cJpQrERMBQbwMgatFu9AUs8KZ0jl1uAK/sY7vzZnReOlgQ
	NpEeLSEu4gUUOqmQfv/n6Otc7zAlh89rp8SZK0cdKAR5ZsC/8N6m80FjwQzXbR0TWv6S6BQsL/Dhw
	abVa4UcKzedtqqvuERs+eK1dSpWNcltYWGgaJsofQdtLFgyqL19+Iv8zb1kXeHGiYzXBT3DvTz/ep
	zeP7mdQBBN7l6P3PjCjrCw+DHgI2kVyD4cu8jkVI73Rs14Yuvq9cg19lSeJhlYcvoAyZvF75EltCL
	ce1xgY1w==;
Received: from [38.87.93.141] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8uzC-00000000bFA-2wTR;
	Wed, 15 Oct 2025 06:27:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: set s_min_writeback_pages for zoned file systems
Date: Wed, 15 Oct 2025 15:27:16 +0900
Message-ID: <20251015062728.60104-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015062728.60104-1-hch@lst.de>
References: <20251015062728.60104-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 53293120002
X-Rspamd-Server: rspam03
X-Stat-Signature: 979638to7ks11him3amueqresb14qtrb
X-HE-Tag: 1760509668-583506
X-HE-Meta: U2FsdGVkX19iUk5eVPjeFHm67dyJ5JWqc9Xdn0W+heUEPEHI4gbs+DgUVNRQbVoXOs2rlXvmNTl28i0fwpMNxPQg52wkPZghpZpLbGY5cG/jGrmUrad/Qm4vT94ped6IQGS7cnhutMIlJcDDtQhjv3vKSfqy5TRAuQB0ZKnApJouhM6l66A/8lAFvPp5nPTUw62JBENRH8o+Wte+aZZwY7vKprWSrqnIxJ5NLJtc4f8Q9BlRhQMyWtiYeZBv21PQppPjdbPvBSmcNO4ndR+V9bO5U5ULVmXJzHhD5X+UEnCmnKM4opMKiq5vC271dxZWTvwMUbhEJ5IuGPhXULu6f6bUtmmZT9HlRwjb+PCBWaejPVQe7ql3YrtFt5u2w+zwsf7zqO5TwiRuBhquSgPUYpTkraYd85S6Rn5d0KLC7e8tjppHeadLMuCtoVPqgFTYVOiEIzWaoYcbz/NyJGjmEUyWqvRDitrJq5MBHbxtPc8ZugijeqAchhWYg2Q22SzGB+T47UkUcy5sjGIztb75oiqBFSA6+B7IkCKyuqkmIEk5xMf19c2rdzchw4pO4EJIl+Fr1oSrWpaeGfiwAqQ4g+AOanglmEQkDJ7CoouB5mn+Ch1QnmBJLzMJeNkxO9FgdyL2lwaloRqjPltPEgqj0u+WFczXzFCk6HsX+OLeSasMPp/o9AKZbLUMhVmlhY3fNjiyMGDOOtl1OdD30X4Fk/FoauZqLZPNa09rShpEiI1WUohejdVsMzNLelgKCpDPvqtRgRCdpkoDqr5J/Tsd8Kb2Rgx5tPk+mb0+8tdCE43HSrOcF5shkBQrN9gG5l3dKUDwo4+VbgEq9rVvBN2/i0Fk2bH/PkrDINo1yt8E5yugp6dwoFq8XjB2fBFSO7V6Bj7TzpLdxnz7clMBpGdIjPbK9KWzOTADW/PhRStRhWmXVgPobE6Vhecpt8PQokjOhWMRCwiPM69wWO06p+Y
 boIhuc4y
 f8LHfpbsvcaP/6gaaTTPyD7Lwri9OhDSjiNSyoe96gm/2JZLcl1TNIc8aErWGgemaO7uNwrTWOdgtr/IWWttFY0Tkj8/lliPkOjFOMVUNtBtmcRdN19bWCE0rJo8fxD5s+nxp/ODzpe7FkVMs3iL+GH8qB01AX5VX3B8HL0oJ/VsShphCWDS/UgYIrPa1wPEi1GyL1XNGuV4iVLj0rbNvV4OD9u3Sgpr3NB2io8XJstfR+XdWyripL0AsU7MWHMvH+fBFsAXLpk3UyCD8JRAuxVEdpIJYgbwNdp5zg9rrPiH8JI80xUxVMbQ9qkwOpAiUdqmQGmp5CV0oWTSElXkB5ADdoKQIFxHMMX3KDRJrgvKalx3L16iWxBqIoUgg7Ua2PA9NqRQx9FWYrjwOpHePBGuYpuXisZzJBg6rebiMvL6gqa9sVaJUGiB9LRhLYHomqq357XEGO4CLovP4RkLGzQ7lMqf8rebZP1+xfmNT1dTBvQthsc4ZONNQT/zHQeTx3eC5j2K59YOtDo++7cwKukjbstFKmg1NtKZ5G7sfK5Dq91tFo8knma+plBp2+rGvuB7P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set s_min_writeback_pages to the zone size, so that writeback always
writes up to a full zone.  This ensures that writeback does not add
spurious file fragmentation when writing back a large number of
files that are larger than the zone size.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..0f4e460fd3ea 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1215,6 +1215,7 @@ xfs_mount_zones(
 		.mp		= mp,
 	};
 	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
+	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
 	int			error;
 
 	if (!bt) {
@@ -1245,10 +1246,12 @@ xfs_mount_zones(
 		return -ENOMEM;
 
 	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
-		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
-		 mp->m_max_open_zones);
+		 mp->m_sb.sb_rgcount, zone_blocks, mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
 
+	mp->m_super->s_min_writeback_pages =
+		XFS_FSB_TO_B(mp, zone_blocks) >> PAGE_SHIFT;
+
 	if (bdev_is_zoned(bt->bt_bdev)) {
 		error = blkdev_report_zones(bt->bt_bdev,
 				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
-- 
2.47.3


