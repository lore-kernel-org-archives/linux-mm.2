Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53FACCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CDF8E0055; Fri, 24 Oct 2025 04:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B051A8E0042; Fri, 24 Oct 2025 04:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C178E0055; Fri, 24 Oct 2025 04:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 923308E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:06:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C88D13C393
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:08 +0000 (UTC)
X-FDA: 84032274816.08.B798A88
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDFE314000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k5lOzMG0;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCwoA6+ChcsIaRaI3yMWo9YEdWFV0agcuinYhHfWt00=;
	b=ShSby1+FIRXkL4NGJwpw2Uum4RlVOjpgg4GxHU+ojFz0jqntW+1k+9W/oYy5x4sd/jPqek
	+dlI/OmMJkHWeBC+SpbV/9hAhHN4p/ZSLI3R85+LEFnDShfs6EviQxkigDBlKPKWYPkxPb
	WOzDMDc4Fx5POorGI87SGIL34i3EIdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293166; a=rsa-sha256;
	cv=none;
	b=M9+Et5YPGi0sor8ju4LdbID8YzvJ4ZMpqzdGpgML1OydpA+t5JVG/dRfpiKKGPRiEQY782
	zbukUkpHIXZkV73V5Dk/tMRQSHkmz0GAGbfH51UcasSyLvZVNEp/qdA3waLmIlkY3LgUPS
	alGsRTSLxTGNkGsMjPAXY8QKadvjGtg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k5lOzMG0;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gCwoA6+ChcsIaRaI3yMWo9YEdWFV0agcuinYhHfWt00=; b=k5lOzMG0Ppf0+EZXIOQFf73oUb
	2iS54DPXlzj4+9rvCxXFtFSCBiWsn6gsEOrglZ00o2PPG1gLXP5K+6EqxFGvGDQ5C4YWIcaT/e23N
	nReVeiyprQQAiUVnGi1FMD5vO4kGJZF3lCdPivkpLvvWY5+y3aEtDUui9lNBrGMqh7gDJIVniH4u5
	xrjhtX6CUo5QGsYFF3/j9lXmwzqzG+fNvNPuX8mG3Zce1KrTA09mP/Qjlf//4J2rbTgDBq3VG7Gb6
	1F1z2Y/yOY5Dr2JTGHeTnfhPXKLZNZAL95pItESpEC3sVU5rZpgGYgp70Ob16Ubxplk3No8g/vBB7
	qMXVco+A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCoD-00000008cJg-2y2A;
	Fri, 24 Oct 2025 08:06:02 +0000
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
Subject: [PATCH 08/10] mm: remove filemap_fdatawrite_wbc
Date: Fri, 24 Oct 2025 10:04:19 +0200
Message-ID: <20251024080431.324236-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Stat-Signature: t1pe18ajwbz94bs5jmtepqsy5ijr6h4b
X-Rspam-User: 
X-Rspamd-Queue-Id: BDFE314000A
X-HE-Tag: 1761293166-490581
X-HE-Meta: U2FsdGVkX1/lcFo1QWVnvzLGCKWQ9gYQnVlblYpxulxHTum8/jdELouJyf/NLtdZPGq0ilQ7UbQ1o9LuImKg4h/bZkdnyjjpFNq0agj7vHdq4YqrA/+Rhh7cem3lDFyLCBXDRWJxVtLh8wfN2noHkpnHMpmQE+sm3/7NLLVsnemy2mrPmxntiWvI6ywT78p8JVdJedvCO7x4KZ3WRdUedD1NtMf9cdVGi5UO9CLZ3GPmctf/q4Kf9EgJnV8v1eIdgFDFSArDqjIK/ltUDIP3diL6vY19yvitujna2gEbYh4cvODWZqptkl7inzG9JkjbZNO6hK6FZm1aV/F+Z0hjCjSCWpsxpB1TEzzIW24BL7TwBF3LEZRep89gN6rGdTcHZj9dHdbAbnDbjSsPDd6UtZzAlI4IibBoXnlKaQPOE0OObSmzhB3H8TGGolHVaBkMrK3UmcjaMhkb/r+HbBDhMfdPNBvQiO/Vw2aCyR1zIwGwK6OM+UOzfs31yMFmH/8TujL4wvjL5iy/HhANq94L2WcPx20ywMDl5PGB3N3AbGfOxlOGZXHat9Sj8BEO3BaiPpqEk10iBTzNfup7E6WsF5oodMkwxYU3UPd5SDComn7dA4TPuGoVetyBxYjhp7vyRohHf5D68lrzcjAKCxBvl2Kf7aE3tReqd5Mr7ijOHE+eoG1TkZptyy7Ljlpk/96KbXfq+hxEaUJVvw4hSofv14D8d/gVs3b8SahRpTHXjbNlEkKBt2SQFsWWmIF6MK1SIg173djIPJsyWSpiYUi22ZBqkUCxL4ZNTYiZhE8oOvN96+Kd1k2OUmJXhDbRjdD+EfhL2Ou8yVRaSZ0h211vp9QpItz6imAUm9Du3EBRpNflB2luORw+Vme8FBAti0r2qSsWl5bPFQfTeLshzKgGx3UZPFPEFSAFnk+3NowCwsXV3JD3xvtbG8Em8Wkfva3RNVsLmJKR7ggy0YQxmUZ
 ksop7AiU
 BxU0lrwqwTNHX9UWtEmDTtk9TvQzn8BQj4VVY3XceM+VSkf/xQJ3bkHKubjI3dlOGPr1uvlH3jeYKXwrL6PeT7pR2ufwIm3sOObSaWA83/WCbEFJDk9HZ7HkrN/KKSARKTW40Qrn/FaoKqambh5cPdZZSbC7JlIPsGhKxwXluRHY3p79AZas6bW7gN4jYCbg2gzAe0WlLCAW01orXBTzMYpku+FtcqVMEwPLJtTx7XJswuao5WSr3pYP7ZGUy5SNBGdfjomGzfxjzZBoJsgwmNKxsGLR2ERp8TbuLNCgMMqNE4bqdxSovC6f+DBy5anJuMJIT3Q4ms50yyiM09jExmhD/xdhWpH8bXcOkOUYh7k6O81lkIB9IjRzXYaoHOIHu6XBqlBLgyXDLd1urW6lKjvPzgvNzL63fOqPlaPtE8ERxm4IPXXRR33mUNGb7qfby52FMtSr9Li4cuDxG5Ep45ZHRFdPCtQNddUSaJMiBHufVe87H9dR7yp6BEmUioWPo05gHi2DzTKMkmSyFn79Wd5zep8pbppGc8roxBfhIV4dk02K3VhUJmSPg5lkSW0lX0MzQcuviuCOnUamU/uFNI3qShL6N2uwBQ2uchpJZ0PM73OqUGMAgPhiE+DNlzSmsei/Pi05gxk1NzWHqXRch7in7TH/3gXnOGjvy9C1n+jbieNX0KHCVJ/+JK4SKc7pfNHLQG5TTcMSW6Dcc70it3JIT4zYQJF7yxDud4tavRFUUYsr/JfqPAKCwNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace filemap_fdatawrite_wbc, which exposes a writeback_control to the
callers with a filemap_writeback helper that takes all the possible
arguments and declares the writeback_control itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/fs-writeback.c       |  6 ++---
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 54 ++++++++++++++---------------------------
 3 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..d40b47132de3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -807,9 +807,9 @@ static void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
  * @wbc: writeback_control of interest
  * @inode: target inode
  *
- * This function is to be used by __filemap_fdatawrite_range(), which is an
- * alternative entry point into writeback code, and first ensures @inode is
- * associated with a bdi_writeback and attaches it to @wbc.
+ * This function is to be used by filemap_writeback(), which is an alternative
+ * entry point into writeback code, and first ensures @inode is associated with
+ * a bdi_writeback and attaches it to @wbc.
  */
 void wbc_attach_fdatawrite_inode(struct writeback_control *wbc,
 		struct inode *inode)
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cebdf160d3dd..678d8ae23d01 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -60,8 +60,6 @@ int filemap_fdatawrite_range(struct address_space *mapping,
 		loff_t start, loff_t end);
 int filemap_check_errors(struct address_space *mapping);
 void __filemap_set_wb_err(struct address_space *mapping, int err);
-int filemap_fdatawrite_wbc(struct address_space *mapping,
-			   struct writeback_control *wbc);
 int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 
 static inline int filemap_write_and_wait(struct address_space *mapping)
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4c4a96c586..7126d0587c94 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -366,31 +366,30 @@ static int filemap_check_and_keep_errors(struct address_space *mapping)
 	return 0;
 }
 
-/**
- * filemap_fdatawrite_wbc - start writeback on mapping dirty pages in range
- * @mapping:	address space structure to write
- * @wbc:	the writeback_control controlling the writeout
- *
- * Call writepages on the mapping using the provided wbc to control the
- * writeout.
- *
- * Return: %0 on success, negative error code otherwise.
- */
-int filemap_fdatawrite_wbc(struct address_space *mapping,
-			   struct writeback_control *wbc)
+static int filemap_writeback(struct address_space *mapping, loff_t start,
+		loff_t end, enum writeback_sync_modes sync_mode,
+		long *nr_to_write)
 {
+	struct writeback_control wbc = {
+		.sync_mode	= sync_mode,
+		.nr_to_write	= nr_to_write ? *nr_to_write : LONG_MAX,
+		.range_start	= start,
+		.range_end	= end,
+	};
 	int ret;
 
 	if (!mapping_can_writeback(mapping) ||
 	    !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	wbc_attach_fdatawrite_inode(wbc, mapping->host);
-	ret = do_writepages(mapping, wbc);
-	wbc_detach_inode(wbc);
+	wbc_attach_fdatawrite_inode(&wbc, mapping->host);
+	ret = do_writepages(mapping, &wbc);
+	wbc_detach_inode(&wbc);
+
+	if (!ret && nr_to_write)
+		*nr_to_write = wbc.nr_to_write;
 	return ret;
 }
-EXPORT_SYMBOL(filemap_fdatawrite_wbc);
 
 /**
  * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
@@ -412,14 +411,7 @@ EXPORT_SYMBOL(filemap_fdatawrite_wbc);
 int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end, int sync_mode)
 {
-	struct writeback_control wbc = {
-		.sync_mode = sync_mode,
-		.nr_to_write = LONG_MAX,
-		.range_start = start,
-		.range_end = end,
-	};
-
-	return filemap_fdatawrite_wbc(mapping, &wbc);
+	return filemap_writeback(mapping, start, end, sync_mode, NULL);
 }
 
 int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
@@ -475,18 +467,8 @@ EXPORT_SYMBOL(filemap_flush);
  */
 int filemap_flush_nr(struct address_space *mapping, long *nr_to_write)
 {
-	struct writeback_control wbc = {
-		.nr_to_write = *nr_to_write,
-		.sync_mode = WB_SYNC_NONE,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-	};
-	int ret;
-
-	ret = filemap_fdatawrite_wbc(mapping, &wbc);
-	if (!ret)
-		*nr_to_write = wbc.nr_to_write;
-	return ret;
+	return filemap_writeback(mapping, 0, LLONG_MAX, WB_SYNC_NONE,
+			nr_to_write);
 }
 EXPORT_SYMBOL_FOR_MODULES(filemap_flush_nr, "btrfs");
 
-- 
2.47.3


