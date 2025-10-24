Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25043CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C04C8E004E; Fri, 24 Oct 2025 04:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697928E0042; Fri, 24 Oct 2025 04:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510598E004E; Fri, 24 Oct 2025 04:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34E758E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:04:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E338C140D77
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:04:57 +0000 (UTC)
X-FDA: 84032271834.24.F30AC66
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id D1E1F2000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:04:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OJ7tYu38;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293094; a=rsa-sha256;
	cv=none;
	b=lyQ4Zc7d0RlJp7ostHyhQ0EMClLNPu2ipqu7ofjDYYzk1k0imsIraBkKKBb/GgU9poJUKe
	IqkDiQS+NV58Fv4BMZfJzFCvGqGBOs8kC1Vqx07aFHY/Z+Q41/BIVTogCxgK3cXEYXLUb1
	eVig+z+wX6oWH3xL7TT3dsp1CvRazQs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OJ7tYu38;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYNTxYIvfkheoJqN9754McBKPDeXnK4exyWJDqYAb+Q=;
	b=AAD447hHFf1kQNp8lGrtEpC9wMU0HhtQAoxRrSvWo+4Za/GhnmcQ+AXxXOA3IxK7+aIuFL
	G1MflClcOcS/bLdp+LIBVjUT0/r3DgiRXOO1pFpN2NOaaJttkxuuxgWVUzH363C+eq9OMo
	jX4PLN4OwS967JQV8HymgKNMJbEb9r8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jYNTxYIvfkheoJqN9754McBKPDeXnK4exyWJDqYAb+Q=; b=OJ7tYu38O/M/EmCj56S9HyxwM+
	j/MgDY2cewA4DHdbgZD5+lsfdRKWYE/thmo+DAAhTEQJvcx94qZtN5GUp//euqbZRrUAwub+7D/ip
	BwH6Z2MPj6e9TBe09HjUYdUpwV314GvopmTdoe6bjiT0hcxtSHZCE9+2QbDGVtA+2WW65fYjlI5Sg
	UFbHzmBdpwRNvAHbYFJd4jgnj2Yw5q9nJAgB4ZrGcAap7PO12c6ltZJyTpogW6/htvsVKPTrGP5Ow
	3SvSCyiGRQfpMC0paMwsE+z+lcv6VFfZSYkbRECS1l/nrIY6dzsv1ZcYw3B2hDw9NPdeEgxNIB8Uk
	vQC81CeA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCn1-00000008c2S-1B1p;
	Fri, 24 Oct 2025 08:04:47 +0000
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
	David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in filemap_invalidate_inode
Date: Fri, 24 Oct 2025 10:04:12 +0200
Message-ID: <20251024080431.324236-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1E1F2000E
X-Stat-Signature: ymsibj7d9c6kd3pwfh4yy3gbmg3acf57
X-HE-Tag: 1761293093-854814
X-HE-Meta: U2FsdGVkX19wqW2Mrk3aD32QymwXNtu+PplWnhAAuSGVF2FLFMQ4esw/bXJ7TA1EAYDGkcaRHMYHx/nvTq88sr/VHDFM6oIiOO6Yn5JLKgcpsg32PaDidhZAMXHuFzK1NQ+I+0CDJb+IqnJesR2ixxBoUQv5FrQBO3teC0VFkd1RDjrojOfSAQ0HhZtL/n4bPnzwnFlzi11iFIlIghzveU8miDyEsTvHIq9AZnDHNle9Yq+cW+lCCkGlUIEtEfKTQjISPZFSVjMtAQLqN1ApMsET/V3RoepRNkEGT9lkb3GkL8fORRZ2zSbH/yeycK7E/VnwdvAp0007UV/MkBM5+mipTmgmmert89dW0JGXEMXWHqCUEkuijIcdpdT/jirFZifWjiSDlIZ1gW/Tp09ntaMzXIg8vREAv9jdBFiRNTu9LC8ORADPw/8gkRh+kIfXseJahqUJGjYd+7Z/vC8R2UA6C+UOPfKaGRRPTTXEFsSc3qVCHc0jJ009L+d6UTC3caVPXA4c84elok7oJI26h/4EGmIhXYlMGdrGG7ZcT/359f1IQOHSDrH3f9hg8G5yjRmLEhZFAs/t+TAg3UBKByLJCHbjtmoIHEHuAvdZz7Ok0h4y2uR390jJh8nrXMGGT1QVgvSHSp9HFmWLn2+QnnnNLT5BuXLcjJBo5QEdTrA+DERMKl2R2vKVDK5ge24Lv4xY8ZucgMOAJLCsv7wABcAr7pKdl2IDPmv1pxZ64MWpF8hugGE+dpDH5M5W/jO2fAOb40q8hiqZlKQvOB7I9bz+xmch0WAcBqFxm9j/V1CCWESU+zmczMsobCFNT/1Sbb4lMHofVXDGFA8fGT7pePeNDEMIuShiHZHP94RR6J0hfQ8P6zfyn62oN4wfzd034M89/Uq4fgyS4CeqE0F47TED1aNdozy+zENzTZtC2zWgvd0bsEZwLYsD+enBBQxSNTzKBLiwCFg5tavmSfS
 DLNej2xD
 EpC2RrLGGQhS1f94kxMi6VAQUZKYuE+prP0GQJKnkY8EeZHy6F0jtJ4kNYCGXEtc0Mhim/WWzLk3a6SIr74RN+gJu1yEcMgVujv9ax37320R2rvnJJSeqbv1fmbOlltZiKmSwp2XlF2aK5y2BFSpMA8xK1jkljQSP3Cic7Hnoi58i2z3PjEUL6B/u+Fr3raBQOy8xbzJ5iXaBrDU7KqK7EcjhWbFnvb2HhzAu+FQDZYyJpyUgnId+0eZSsceM/+1iWGQGZIADH43beWqq2TkHkHZadgTVMXbZTd3FBW8Nc17qSCxLvCKR+9P3LEt20Ze7krWlabaDIjYdion+el3q0bO7clfbf0dbpiaNcFfJKS3BykVu/qWhE2bS0pJKOofWNXCISSWkJIV1V+qPd5ee6gxCySm5uYqOpnahRfbft50peAwnRXUXJelflglXaxBiFMPrbSc5mwsr3ONvv6iUWbFHUwcb5YInVjHdWxnFQ01+lsYEWADi8KjG0zlfc10cem2vcnXzlsc36cG7BQWD7/PJYSlclpIgIx7Hxc+VDEfGkwpCIYvCpwqwUHKHCZ6fvZ19S0Qsai+OLVWTEQ2KnzkSPUVk11fSASvNRsAiCtsxVOa84DsSDO0LTU1PVeIoa6w+0SvO9OeopoFM9/0Czq3nwBHmFOAZ+dMMKx07YxEV1WzCGg63SKNh/N5Sy7J9QHidr/i4XyGz4PdkGRfZvHXOKdnftiY2LekQBfNfkObfewqFcJ7gWlEM6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range instead of opencoding the logic using
filemap_fdatawrite_wbc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 mm/filemap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..99d6919af60d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4457,16 +4457,8 @@ int filemap_invalidate_inode(struct inode *inode, bool flush,
 	unmap_mapping_pages(mapping, first, nr, false);
 
 	/* Write back the data if we're asked to. */
-	if (flush) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_ALL,
-			.nr_to_write	= LONG_MAX,
-			.range_start	= start,
-			.range_end	= end,
-		};
-
-		filemap_fdatawrite_wbc(mapping, &wbc);
-	}
+	if (flush)
+		filemap_fdatawrite_range(mapping, start, end);
 
 	/* Wait for writeback to complete on all folios and discard. */
 	invalidate_inode_pages2_range(mapping, start / PAGE_SIZE, end / PAGE_SIZE);
-- 
2.47.3


