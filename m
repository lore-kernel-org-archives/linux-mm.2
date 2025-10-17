Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E7CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017A18E0036; Thu, 16 Oct 2025 23:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBABE8E0002; Thu, 16 Oct 2025 23:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9B98E0036; Thu, 16 Oct 2025 23:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C30B28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:46:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AE5811A394
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:38 +0000 (UTC)
X-FDA: 84006219276.13.71CBDF7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id C257B140004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L6ZRrXUs;
	spf=none (imf23.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760672796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzhIS791DbWw/BkeeiAXVxsk/8OZmh8JD9FoPLYpoC4=;
	b=pKuXn/WcgfFiOtnEmbcGVuUABh9AtgLF/kh4YVkiiZ+XAqw5pFDWi1CVUV9HewW411Ob1N
	PdeAk12s7qvQ76fuQdQKdikIkjfUzYvSBg0wEyDwY6IIGTSsQ7BUgHpcoEQyt97DLEVKiO
	wuX+1hi3M9LkjbTAezxHatzNFSsjjOA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L6ZRrXUs;
	spf=none (imf23.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760672796; a=rsa-sha256;
	cv=none;
	b=K/aBe15kr3lARUmRARyW0x1SHucNr3/7wqw0FHXB62tavcxt/USSxCRm1IHuACzAmum6Fj
	FxvMFLg7feajaHopr0YljBUlaZnbHDHsOMlapfvD/ILbc+GQiRv3MgnQZNfD3XVLNbCAWl
	93TJlnWRP3XeXqyjuTtwvMYNMuSsNbE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OzhIS791DbWw/BkeeiAXVxsk/8OZmh8JD9FoPLYpoC4=; b=L6ZRrXUsGgGd6cwNkJ2KANK2wb
	ls0BUyl6KmamfjFMchiK3B0qzIvIWTHtiuoK5pUlLP9AbOHrFlSCeoB4NuNHr6eAKbTV5gLRWKOgL
	lJrw0i+C30z61rABpx7J4iBsaDku9jsb6HGieq4SckKhm998/z41jlbDE8OlAaimIhz3sE9pIqA7n
	y5+94uX2OECUs0PDzwSzlx0sMqhfDV6eObfKm4imcPOETfF2FWwyuNLOznDhmK1VKYi3Gv+YoDyxO
	4AP4k/wBtb81x2AJOvIpYCe2ZBlw7rRdfD1rzm1aqp9PWpOPdTuLgnYjc9+C/EIx4v8h1TcEVCpJc
	BpRDFYOw==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bQI-00000006U0W-2Y9j;
	Fri, 17 Oct 2025 03:46:34 +0000
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
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 3/3] xfs: set s_min_writeback_pages for zoned file systems
Date: Fri, 17 Oct 2025 05:45:49 +0200
Message-ID: <20251017034611.651385-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: zj6bkqskeu5r9qnafkc6mmec1zgkpfqw
X-Rspamd-Queue-Id: C257B140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760672796-25340
X-HE-Meta: U2FsdGVkX1/CxnQJ87kKCnplaUO9w/u1BpS1I5w/nXC1k20eSeJO0XOOIkT+bKGAWbOBbuqPy0bkG1pvl2ZQmrKa3w3J/XpK/NrlyfCPG06ypBO0OCBfD4G/WqkN/S0N+HN1C0Yhn58svJIYVWbiOBU0WjhxqjVfVKdzYULjxaTq23F/lje1401Z7VcsPrhMWnf7wBoDZ6E/dP4UBsWBz3SLZAB5yXo2dt6x6SNioARDHIa0mqS5GASOYeH5Ch4hwc0W1aHp4fZzgM7eRfVhpcLncLKK+BQALCH7hWrErHOrVT6vVKBK0QXo/Imy+WGQVWO2KduWG7KO7zY5AHV7mtg1n8dV7x+qA+CWteEsfkb8DlnAd1g2PKzNjVtD50iPZEhK9r149U8cR46+0MM8lXovd01dw69uFZo7OT6lWpeVksEX+fBZaALIs5gQPJ/+ZMRMtfN5g5Uft5E5l7K5/1RxcllSYp974hdKFH7aAlv6iKSv+e8hVY4M6T/BkyEr1XJKPIkkSyUxoCuH8kutE2h8EooL5gj5XW+RpK7Q4i//GpzeLSEd12hkO42p+mlhTkMTzb6n/4CdHZKdCQBOi52PqFWnzlpqAdNJTTbcM9NbSXvPgrSjeUN5sEhc1zTShWjuj6v4WE+dh92mGdtFjuzpuu89r5e2V2Hjf9XyFFWdwcB1GyAPh/DRDo+lPhdC1uNBioQ3i+5eM9GhlbwhniJxco6i3/Q/dP+hZjbK1B50biWzDg1hxYRQr16N8O3+CvNHaL+x6mzOnPFY6IfO+oOVvs9qw778zcAPWnVU5dUVfKtNe83wny5LO6mZPt0R2Wke6QlgN9W7bLf16NzONJMNTVZ3t9XwyiZKC1uzkj7gZ3VIjE8oRDNmZR8fUuuyMhoxi9qATX6uDWmm01rKj6u5LITWtz4FURhI24Pohz8R1xFwBBL3V4sRyJ9IERmQkieMcXHuj5nbYoka92p
 EDxUT04v
 P3W6dQyErp/zdA7qvcVjwzJeikHDWW821pPiGCgFHBvQB/ALOUK0y+mWQjUN2qQ1U2kO69OnCjIikAwpo2E/YcsK1yu/r30NydjiIA16VVwldTNt8Cdt/ykKdNzoUoUM5CzMjVFN4V1osUdeQnz7lZsQ1fwPgjFPM7Mqs93TK3EOlCGeaQlflViUFNpdM3tzGCkebBMptbaar9qzLRUqe9ITJkSFd4wT0rIUlJhSWcjRV7JIP9ciglRUYsaQkWBaaGz24B/jt15vmx/jwjKQ1CEnORGdt6GrbhOOsuSHlpOuz4lf3twCrn24fE1tFCj2FgzN7a8z1GzFWr5kIgYqjKTKbY2MPDktl3L175DtSPS1keEpNpRPQ0IYW71+Ozy1vrCnyxckg5ynp7uscxfGIa+IQry79oGwa9qxxGU+PX1nRdwFZH1GmTKWnStPSf3neDAB5P1949/e7uk+tjEtgNjBiH765r5rRTRFDlhcY1QEl3DqU7G9MI3oWaakVo8KQbG7kc7ODBaRNOUFI8WLhK8w2Sz5DnsexcuYt4ItQctCxxVvmoF2BGxyF6AK9JrL9wD8YPSNatcexV6XvcNeT9kkW0j0PH27pTjgy
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..c342595acc3e 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1215,6 +1215,7 @@ xfs_mount_zones(
 		.mp		= mp,
 	};
 	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
+	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
 	int			error;
 
 	if (!bt) {
@@ -1245,10 +1246,33 @@ xfs_mount_zones(
 		return -ENOMEM;
 
 	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
-		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
-		 mp->m_max_open_zones);
+		 mp->m_sb.sb_rgcount, zone_blocks, mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
 
+	/*
+	 * The writeback code switches between inodes regularly to provide
+	 * fairness.  The default lower bound is 4MiB, but for zoned file
+	 * systems we want to increase that both to reduce seeks, but also more
+	 * importantly so that workloads that writes files in a multiple of the
+	 * zone size do not get fragmented and require garbage collection when
+	 * they shouldn't.  Increase is to the zone size capped by the max
+	 * extent len.
+	 *
+	 * Note that because s_min_writeback_pages is a superblock field, this
+	 * value also get applied to non-zoned files on the data device if
+	 * there are any.  On typical zoned setup all data is on the RT device
+	 * because using the more efficient sequential write required zones
+	 * is the reason for using the zone allocator, and either the RT device
+	 * and the (meta)data device are on the same block device, or the
+	 * (meta)data device is on a fast SSD while the data on the RT device
+	 * is on a SMR HDD.  In any combination of the above cases enforcing
+	 * the higher min_writeback_pages for non-RT inodes is either a noop
+	 * or beneficial.
+	 */
+	mp->m_super->s_min_writeback_pages =
+		XFS_FSB_TO_B(mp, min(zone_blocks, XFS_MAX_BMBT_EXTLEN)) >>
+			PAGE_SHIFT;
+
 	if (bdev_is_zoned(bt->bt_bdev)) {
 		error = blkdev_report_zones(bt->bt_bdev,
 				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
-- 
2.47.3


