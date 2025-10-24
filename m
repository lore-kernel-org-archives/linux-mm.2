Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93792CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24258E0050; Fri, 24 Oct 2025 04:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4DE8E0042; Fri, 24 Oct 2025 04:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E119D8E0050; Fri, 24 Oct 2025 04:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0A508E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B02012923D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:22 +0000 (UTC)
X-FDA: 84032272884.16.932E23E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7F172000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SyZcOLm7;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P9bxasjyjeJJnWosoT8opCXvi31OW+wT7P6nXr4e1Y=;
	b=2e8Tl19xrXSzLJt3jBSMp6mdCbvB2BRTDVgsy6pwCWqxxOjcgwT5yp+e8X673V/JBbDNGf
	qaOcYCARDOd8c4xP28zUsWtFqVZDIevllRWk1qazq7NOtI7UqyEFZYwNl98mlvM65PP8qv
	2Fit761wFcBh9+wlfsbGnbE9cQ5lc2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293120; a=rsa-sha256;
	cv=none;
	b=5rFkONlYx7PcXXHleIPPQIfp+3sx9CH/udT268vIepPtUYQ3DgMKnFpbY0zbAE+W6HVAuR
	Q8QAW+teuHvf++nF55lyC+PprTXOK4teqPaYNk3BGoJ8whV8TZlf17z1a2StJly5274yLR
	FPrKPfNuQRBr+duRLD1dowvZAaTlj9M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SyZcOLm7;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2P9bxasjyjeJJnWosoT8opCXvi31OW+wT7P6nXr4e1Y=; b=SyZcOLm7azl5JrW08U5yz1c8Lh
	vix5yzp4RagXc9bFo+bUtELCBUfInp9awNVrH7BimMHQsmNxNbn2NfRCaB+UOT8Yzpo1fRvY/x+v4
	scFL4I92+OgnK2NMTDGidcI04vnqTxLbozymLpf16DX1dcb9AZNd/kBPz48GBE8wcZGIRtCbynCxs
	V+ivSs1pVpv02buP3YEMxeVD1DHHiEWZ5tH584nBd5oNKCviM/ud4X3bYCoY+pctji5tgfkQ+casz
	RRVwARP3a9ApjtC3sPfLGPUBRJi4K/6g7HBQaZCO2tqCJ/VIDcD2u1xN8Gp/WbneQcmiTEtJ87Uxn
	7QJDn4OA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCnS-00000008c5u-1C5z;
	Fri, 24 Oct 2025 08:05:14 +0000
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
	linux-mm@kvack.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/10] ocfs2: don't opencode filemap_fdatawrite_range in ocfs2_journal_submit_inode_data_buffers
Date: Fri, 24 Oct 2025 10:04:14 +0200
Message-ID: <20251024080431.324236-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Stat-Signature: 754czrcsp4wopgxd43x76kfwsxn9xnk8
X-Rspam-User: 
X-Rspamd-Queue-Id: D7F172000C
X-HE-Tag: 1761293120-366027
X-HE-Meta: U2FsdGVkX198I67rRyhvChH4wIHfkZMIqLyn8TH7Ngnfdz2t/6e/rqjE0Xcis3hZJ8DfBCMwSYcACBNU8v/cN4/Vd02QfJ/rXZvUor+tViWsTXw7Rzmwf87cyklwIQ+S175W7c6vYJ5olRZaGMVFbVc5/kLxGmj7dJ4TVU9+zbRHtM96zR77Lii8wD+P+rhjI5ooGCGsLk6Bt9ldUuRrTgppkWBCt2mdL3dx1ggOrL+2k9bTZmxxer0cuAs2kkTaXR8BladFMgfEr+XezUVyyzWgnU4lBBUxiv5ZVTeM8El6JX7xAAL792DTeKPWTFh3n17OomNpb4quioIQHS7gUOf4ddElM7PbwGkiMQMuJ/Uo3WP1WAP6Y/KwVjT3J1mQi+XfQEK/OSy0unBDEi16r//cg8GeiDoL++UrxNDf+2tdE/u1of95xAMv6rNB1pTv8TEUnx2IX3p37ugDLkO3O52w9VwH55J4JUh08dVMpoiwbbGN+KjHnqxMI+MhcHdz19ILGFOwR1f9NsxoZkq7wOmg0uN13IbhgeDrXhKV0bxFWZISaPkk6rf5/UJPsc/XOA4DKp7r/OBDmrJcOzZJAa0tl5R2NdwIALqU4+clr0bOJou8iBtn+1qQRrqDRxYm0/7Lh45DYQzeKDD9FfE8qSjRitl9+4YSyHgAvbwRMcwYNMBH6bIU+pPVpm4fKSYZobtzc/n5Md5l0+7ZOrJ69X67kWQTM7LsxQaLBwtpi5IPM+LItfJBxgqRvnru6uwcMoX6upD5oH3f+UtGrJWm/5JgXwDMY1xpvz5rg4/aPTIFaFKTQiltP4BhBCSekoS7f+jkv4JmZXF1U3F2Rkao1z4JB+JhcPVi8zaogfyekWEQIYkZdF2/QpOgNzrBqr8EYaKZL2Un3EQDJ292u6f/JZSJC+E6U7rSxxW8xuVonH+JK6SMT5Wdof1JesajyZFY782ioCLTTWZpdXW6h0H
 /Xc7JRiE
 6R3NOJWpBNyPlAwKZU1DLPm6dd9kUaPTloIFJ8uM6/Ix6jmBrU/hVoqFYyogCkL1Y4/ow8xxV9hjccgCwpqm3na2L0m1e7sj5kwvwl2hL1cZp54Ahwd+EL2Mg+uWaCdsvkleSIsVKuTDlXLFJM/MMtVK4cyKMe+RCCEqTRBG2I59c8V+YY2VftA4cibM9vD6/FzCVRUAYiOFseCbS4Ra2qPM6iPcQ155MHLznp8KuxYoq9lx/8vPhtPP+0ztjPQ5nQtmTgsbWnWf3VuY6GzkCD86m8XEQcAirIq4RuF4R60KKOTjaQx4BHeZJ8pbFSk6EoWMEWWkbOlQI9ZerazZu/6X5MXO7GyGmeiKtbG5W++wocnMOnKV5QlU0w4YeYSNqEzB6Jq8wVOWwJS4q8t+zFJxjZNRblYFJmI5XW3v63hygGg0Ue/0aXpZw3HF3nyi/JILzT0pB2VmkHBNv3do8DowqnYQ1HkUBtn/U1jnn7Bv1GPeo1Yzaz2UdC4jGIzmAY13lHUaGHe3q8wutXUB0i14HW4GM48XJhRqZUGRPX1xRPdRuDNLJN8MiKN3JQun47g96gTpI3pF/MccbE7jgPyPCc7NE/8oB8yJTJx/5FZLmimbtpim+BztmvwrG1EhQvYhbmHgihgSqB1b8JA09gi8c+ZhGlxXlfIfX
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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


