Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA85CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D3D8E000D; Sun, 12 Oct 2025 22:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E5A8E0002; Sun, 12 Oct 2025 22:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B818E000D; Sun, 12 Oct 2025 22:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95D4B8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:59:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5747BC0236
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:22 +0000 (UTC)
X-FDA: 83991584964.09.9F1B72B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2CE140009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KbGJyiH6;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9Quh20hMw6W9Qj1ot0jk9p8OG9NByjcr8PhG1KTTjU=;
	b=rMmJvZq7cMhNTU1qLV309Tk1z/+z+eI5V3RYJmiFuyIMVL62FFH0G2PLlyz0HSDWL+WWFB
	aIlvljQPSUkqexqYNXfaGIoMyjFGHfcGspkL32dAMXefHoO8n9BMiFAMY2SPJQxRIwWr6g
	RwLd4r3VEuB8e4j26DfAXOClaBBJuEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324360; a=rsa-sha256;
	cv=none;
	b=F025guhsXCjNSfAv7ytL/5MUAfpUHdwGwKf1PO960/UkBfBbKazyxqOsidiiUvK7umZuE8
	EAtDincDs/a4gWXCnskFtiFuvcNVf7GpnbnqPmZh8FzjWgpUWd8z+UmswSEouNDUpVleuU
	dUHbb5O8dhktngkuNh6i/dHObg/NXOg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KbGJyiH6;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I9Quh20hMw6W9Qj1ot0jk9p8OG9NByjcr8PhG1KTTjU=; b=KbGJyiH6VuiuLwWcwtTvpAbIsV
	9c08ehIVjJ4wCL4tPLDFSoVmuZjPrHSJ1BkqLGzGdOf/LoIJwOnH7r03ODP2B9FQUg/esvdgPimts
	BP4Eo9u4nqrxwHYQqCsWSY2TMIh4SKboqpMKanrjKEfP/uBeRDSCyWx8YEamIEK/jsvGekYEdmwee
	KNPENPtY+gch4zEMP79BYW5U4v7g6XAnKpUlLDO2enhu78cKN8Veqiqpth1ccLd+UhnFh+Cs0Di5/
	vVdDHZN4RSnQwUXiI7phr5dcuXH6SurbdovhYwjQ9m/4uLytnAWp90EQr890hOvNlIkv3sF1oN0bo
	hZIetDoA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88mK-0000000C8Ky-0q9r;
	Mon, 13 Oct 2025 02:59:16 +0000
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
Subject: [PATCH 08/10] mm: remove filemap_fdatawrite_wbc
Date: Mon, 13 Oct 2025 11:58:03 +0900
Message-ID: <20251013025808.4111128-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: B2CE140009
X-Rspamd-Server: rspam02
X-Stat-Signature: gbwips3ghtpnnbo86soz6fn4e3hiaiqu
X-HE-Tag: 1760324360-99155
X-HE-Meta: U2FsdGVkX1+/ExWhRYboMijkxb+tpg8GFRQQ6Zhgo9+0FKJXoPeCcACx1Hq8nXmO2S4VEnDEymiCdBlmNdXbday/DWIIcX7PibotRKdCn7je9z37vDUznXN69zJ66QGm2UpGy1knb1UhHl/bK+ZN1a5Y60d8RxWxlaZPkK4rfHA1h0Fx/LwG1xIlMfo+3vRaT51CF/opjFC5piTXb2j93/eHNp88cN277SIl/0XJCQ7HqKN5LQH/sayrouyyttLX4ARPWkcIKtskWMil2eoQxIVTiWqB67lP2tJg5ulXQ6LL/uOpkGiXuxYiiS73w0APdd++IpAEoExzlG7u5HIK9bkbjqubtyKX0yzSE43UdLZ/OMJxUFh1V54+1Sl54F/4wjMU0xTWOq1GVdrtrXwGdMeuNMsj5HHft5glkfDw4SOMrrndtDWs+bCAoEXS+vX4FU7gpq1RQ/A4NU21Dka/Dxr22zzm701h4AZp2yJbLhsUJb5lO5luiDr3Zjmw8iesvKwNxVJZx2c59DkYb5viSukbe6gk5Qq8C4RoB0lU9BJep9Ba0xDHu6RqtwTw1uDTRCqaFIV56qfib9y7O++DLT1UaRsdL44itWk/7r3BR6ZMhgcTN/S7PqdAxqAulKleafMT97KX0n+8RaGNBNTdNvfVnynjTQhOkGxdqmfoq5XAa0XeS2Xgr1afg6+/T8oUmDeoDK/JBFNhvDM76wyKyCfIN3hxK/Nri2JhRjTmQ+G4yOYIZy3SUenMj95unQaHktm4HK4AkOLUS0iLt0vdCTRSlH5NjLebdcKX2M9snjALjE1Va4vPSmu9TrYR3tyNA9qoSY1vVmNdACTfTxVu7RjgIgoYoTDRl2dHIGvdGbF4S6I/pDoG4KYIPgipHyKAATQwJWA7QRe+TM6En/Mbqws0tLXh/aIPycWH2dVpxBO9ShA2k0yLjZr1hSW2Ed/a7uzBYJgpPwg1lMGLgDm
 9VXsfoZQ
 BYFD670TMqBdI/Fz4PyS7oBBO+15TjvetmAT31tL+6b5az0HpLKq7HvucWDaGBLk0Z+vNlYTrnDTCg8UYByhmiyzARMTiLPzoS6YKpLIUk/FzcaHnSCkx2kZQAcGBGx7ZaLWYV0ObgOKR0mkEKSj1hDvKFcL1Ze5jZVfPo1zedIG/C+Lg+koHGyXCIa6FJDguTnfjI8Gm3XSY5k0uK4n094O3NO+eTwpKmxhrS5I3JJlr9ITIETF55BWurvgw96SlIv7lngJ/L7lBX72B73RdX3peF8tkcejT89sORNXc16ZyEQ3/SN6I0SVZxv7fODUaBcZiCfTeuRRMFbK5y11BS+7EC1uvqIAgrh70t738aGXYIv0gT+aviCbMjb3fWOHN42sRd+6IMGwkXUix+12zuI1FVN+UizRakOgUmpWg9VWZCl/GGM+QJMllYAapC45w63zAIkNWwCLOOBV1FeYYoZIJ8U7936cLRd0LEt8RK42wx0YfKGga7OisXTzbhznnYuIpsYDBRK1vZ0xZi7oC1TPsO94ZLHbsWKKlRykD9D0VAYidAPxmhGHun5yQjyOkoVwiq4JvWfkPJmY2Sj0B54R4NPnx4Ylh5zKyiaI3yqxVk/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace filemap_fdatawrite_wbc, which exposes a writeback_control to the
callers with a __filemap_fdatawrite helper that takes all the possible
arguments and declares the writeback_control itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 54 ++++++++++++++---------------------------
 2 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index fc060ce2d31d..742ba1dd3990 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -61,8 +61,6 @@ int filemap_fdatawrite_range(struct address_space *mapping,
 		loff_t start, loff_t end);
 int filemap_check_errors(struct address_space *mapping);
 void __filemap_set_wb_err(struct address_space *mapping, int err);
-int filemap_fdatawrite_wbc(struct address_space *mapping,
-			   struct writeback_control *wbc);
 int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 
 static inline int filemap_write_and_wait(struct address_space *mapping)
diff --git a/mm/filemap.c b/mm/filemap.c
index bbd5d5eaa661..26b692dbf091 100644
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
+static int __filemap_fdatawrite(struct address_space *mapping, loff_t start,
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
+	return __filemap_fdatawrite(mapping, start, end, sync_mode, NULL);
 }
 
 int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
@@ -475,18 +467,8 @@ EXPORT_SYMBOL(filemap_flush);
  */
 int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
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
+	return __filemap_fdatawrite(mapping, 0, LLONG_MAX, WB_SYNC_NONE,
+			nr_to_write);
 }
 EXPORT_SYMBOL_FOR_MODULES(filemap_fdatawrite_kick_nr, "btrfs");
 
-- 
2.47.3


