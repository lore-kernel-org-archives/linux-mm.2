Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA08CCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A368E0008; Sun, 12 Oct 2025 22:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142748E0002; Sun, 12 Oct 2025 22:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058578E0008; Sun, 12 Oct 2025 22:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6C8B8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E8421DE24D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:44 +0000 (UTC)
X-FDA: 83991583368.01.90E4376
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id DBB95120002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FDfBpYZN;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf29.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQZOPAAeeds/w0ZlIXWjsgocvBDsAHF4UQnFeVZIJl8=;
	b=1uwtUvdUJFLI0UuTbLG04QW+OgNiAauDH7n2ZiASCjlgkJblLj1MzPPpG+BpTqq/sMR79R
	piuqsBZnM8w2w7WCsWI0Orvzflqaxe35Dn14NJCRsHJ3LrCA7qcKvClUhqmjdjIAfnuNvF
	74stoornw3a1xrAPCsm8wBLygUPT+0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324322; a=rsa-sha256;
	cv=none;
	b=WVzWvUXpEe5Q1FDKuxPQKjmEKeS6D40RNbQFbzMqqHVt/JyoOPhqF6Jxy5YbFis4hqjOxn
	TcrI9ahK6roPgTyjSL6grSufVStKCYPmBhm0WzxxsdkAjfZKVLiMon9NjTsBv+zIe9iZW5
	Za0brn7EA8bVOc+eUlxHx+CVFhVxTOc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FDfBpYZN;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf29.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dQZOPAAeeds/w0ZlIXWjsgocvBDsAHF4UQnFeVZIJl8=; b=FDfBpYZNHkGYl26RqtPTH1d2z0
	0grd2UwV3PK7DTQrexZXFT2MSdKVpYRL+Gjc3eFSuxeb03ctH5iPyQKpzIO6edBYs5CLd9PefOSSM
	i+j8w8lTD4MZx5T8BNzqhQjwiPzFGW4QohpQ8TOsPSGb5ECwtiYghElUUuDsSmqULiAgDmPuLdwDj
	pE95DuAtsOpzDNx6YaGtSTFWpMCalmXOLEyUGHDbBZ2vFQKi0Hg9HE1rwYeigBs5zic7UhFJ9nSVl
	VJUIaBI9dI/hwo2OaxbrpcOR0PsHLKqRYJcCmgouWBRYW+9tyuOye5gNQ/srvuYKJiOGWhaYnd0Oq
	epabVJjQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lh-0000000C87W-3jg1;
	Mon, 13 Oct 2025 02:58:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] ocfs2: don't opencode filemap_fdatawrite_range in ocfs2_journal_submit_inode_data_buffers
Date: Mon, 13 Oct 2025 11:57:58 +0900
Message-ID: <20251013025808.4111128-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: DBB95120002
X-Rspamd-Server: rspam02
X-Stat-Signature: 3amnforhahmspo7hq41ruih3brqrrwg6
X-HE-Tag: 1760324322-464216
X-HE-Meta: U2FsdGVkX18A7I5iDLDA+ooAwFr3ZtyMj1pr/dMTPyREj+bNsHs6NL9W/w1feh1X05Wz3TO8xaWSc/08azjxqvaBpLcI+MXCZwLFbSH10/hAWSxSaLm4BCbO4H8p714xzUb17Hq4Q9vf2b4Mh+zhV1Vl37Dm+nMP58dILriomKPdHFZDfFDrm64tjeYc37vBM79RfpZRpYDNjAq3syKqJ8IXz6K84cdwKyDEUZ6+lJTkfVbVOkfdiEhPsBAER0EQolxhbrxc06649e6SO/tpwtkwYmIX1rBY4Mwm3lZujfigvIdIeAhuCrfPqTdwFxjCVy+CAsO3E1WW97FI/tIuQQ4yELuLueg7INWexWuXF+WnFChVaIOOV2ZeI/ta8yB3Gl/c7tNQB8VCsFckHXxvl4MMaMsPnNcuksiHiTCMwxW4bp6uy6VtAvJ2oDvXyPQae49hBKtFP9LP9Y6pzYAotpb0c2DCYsE63FracC2MAzdF+nHm1orLBt498ArrLGrCSDukXeJqjC6O8xqVx2P8WMpQyj8rtRGamOxTDV/U1rktgzs+7LvD8qq6hUT8USxfuRu64JxNimVtJEWkNMPn+8KTgHcrYeawgm6HZPmZTapJUytdcbzNKCZ2V4+gOs3jmnbPrqEc4fPiggDKWlyWoWA52EJRaL8PdRSCf/+FD6JX2iV01V/Si1q03q2JhIAKr+S3SgKCD1zIiL9z4MkexmexblZC/uv9hKrdBT0Z4C+z+PuiI7WQ6QqzfgaVXY3GH7QQSmXf/ddqf7Ew//1KkLqDtmFgafwIbxQ1bsYpL4sdKlTUtQjiCPfv87qlo1ICd79iA+NyBIiR8ELdfR5sMko8DQJDixbmkIx5b5bWEeg12zn8pckNmnmr7Pd6IpGDQfjou3eD4QZ0crF5s2QarfNbZ9tEnqXoGGHLol9K4JOWVsiW5HA06bOVcU4l/BNQ/pDKztyIE7JGaeTXWVE
 nzZU6lot
 qHAxAh0mrcb0z0svsIDdYQ79b2j7ji55V0Xq4io015L8/IoTcZErPuP87zPxNPlUc51tRovfo35iVNHqYZaRbmYmb5Qp5rExUV+AepVYpeLDCjmQj4KrevEkaBAO1wVtazq0Ln+mhatZxrX5lnYriS2fGw2ot8nHM3R0FQeEJhh8zltKdfgMEW6f4ZnmgkwbFYZBcPfWJDPVokEpj4+IpMX5sztr5BFIZ7HHSoMgz2FcqlwEVZNNsxjI4oCJx6K9XibaaaO2nfCj9EwYCNISg8oUxFcDuagLIpk1kIEgQkLWby1KdVYxUvBv+sV8f3CJpPUow5ls8781HPnt26qOR9pp2uXWPpktoh73tgxMH6Cb1AnkNLh5ZEEYb1dgABjGb8vgGWDWY9SQw3WbtH7+THrj504YGkH5uIj7PyroyRRDS80glWyiULR2qUeejEaEkyjHXOzn2SX0Z4vJ/reg6QP1hmqpKVw35UMwnpryu05L2koGRDLSvx7igUYvXivCfrlpgKAmbBfdkk0Hl+PcgOZUrPHtdmL2E0TNRgs+WkGhtYsmjj8GY0Awbz9yfe0CkNFmv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range instead of opencoding the logic using
filemap_fdatawrite_wbc.  There is a slight change in the conversion
as nr_to_write is now set to LONG_MAX instead of double the number
of the pages in the range.  LONG_MAX is the usual nr_to_write for
WB_SYNC_ALL writeback, and the value expected by lower layers here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/journal.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e5f58ff2175f..85239807dec7 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -902,15 +902,8 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 
 static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
-	struct writeback_control wbc = {
-		.sync_mode =  WB_SYNC_ALL,
-		.nr_to_write = mapping->nrpages * 2,
-		.range_start = jinode->i_dirty_start,
-		.range_end = jinode->i_dirty_end,
-	};
-
-	return filemap_fdatawrite_wbc(mapping, &wbc);
+	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
+			jinode->i_dirty_start, jinode->i_dirty_end);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
-- 
2.47.3


