Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60F9D116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408EA6B0008; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0736B002A; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D256B002D; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8526B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8C1C16042E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:19 +0000 (UTC)
X-FDA: 84172805598.18.6680A49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DCB820007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMdF5Nvq;
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764639138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaBQAyD3scJHzdwp7Z7vsEt/q+jdM2FxcSbIvG0ArPg=;
	b=zCDtY/VevOTpMpS1UeocYtKaX4fVmD5dBoIisiJ1QEiALthHH+RR/IR6bvbVHaIHBIFJ/d
	/WIoDKs/RfHoHN6nYOVkJRe3ejbPDkroLob31ZvCcaBo8SjkqUAHQDLb0wqSGixzJZB8L3
	+8Qlb5ast6H5q/d6GHARR4d8wvohhKo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMdF5Nvq;
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764639138; a=rsa-sha256;
	cv=none;
	b=O67bzHcRrf/6UgYL8Ng6ucNW/zKQe/D5fUEMpC0CM5hbUBac7ALAzhnRsAVlkM5CB+9xTr
	l7vgjA3Yp9ZWqgWj7gtR9Kq4M9FtJJZdSIzAffMtToJ9qS10Y51by7YOmRV6oOy2oLsc95
	nAHBT2CW1PxvLNNu/2q70IfkD/EpkxE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBADD4424C;
	Tue,  2 Dec 2025 01:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BEEC4CEF1;
	Tue,  2 Dec 2025 01:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764639136;
	bh=z6z126FwDohXSBIi//EiTH/Ua9V8Bx+8xe2h++oSC/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMdF5NvqRQkK+ZJ0ZjCy1m6t6TvoYZOVzc4ugrFnriNRhJSKdHn487GhC1afnkTVw
	 IBcD2j8tohMqJnyCo+2V443u+tIACDE5iGt9sos1gYQBwGnzQQaGEKMz0eowUIacyx
	 vREAcGpa3Zge8LmKIeQDw9BRV+ORe6IVaHkwzGu/+BAPnXjSB5cD2Qw49LGMcACSJs
	 SUBV3IfHXWUxQOruHghEareLoVTbBN3Iwg2nrfe/jeeP4lpXFJFla3OkEmGTToqivj
	 TWwsSeYa/0inI9n1Hp0eVmBx/2el8JNXDmXyC3jgvQjetbnGueVQKyclGbJvp0URzM
	 KrA99eL5jxlSA==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] mm/readahead: fix the broken readahead for POSIX_FADV_WILLNEED
Date: Tue,  2 Dec 2025 01:30:11 +0000
Message-ID: <20251202013212.964298-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251202013212.964298-1-jaegeuk@kernel.org>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DCB820007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: grcgj61ex95fy3y4sxgt4w4sgkis5549
X-HE-Tag: 1764639137-6947
X-HE-Meta: U2FsdGVkX1+j5/N97MaNAAOmHWJ6sOI7VjWRdbV78iK3/q4WdsIv1kZwfFvk5Bsle7u/ii3LJsuEBFDzbBGWeAvs5Ye5+NMUWRURY2pY/GseQ4O8WEo1539lQlOJXMXjzdLIl+4PvZTQH5dj9eEfbn7XrcTvSipsM8kBF/lN0UrfMj42LBwGoAjwwhRpsUbymWIg7KFF7Nw4ApHUDf+JnxNrAfth/D47V/OZOyjhqYdMstgQr5L8n+4w/HawGnQpr9Kf/ZOYgVLXyJxQIERU3gBsRHqTA/QFkDx22Kjch4/5YXVFCpgEgHWfsp2Nx8ktC6XlnM9rkB4dkWTe0e+rPQXFLzObw5iacaQsU8TPmwjJMFXrKvoNtwRXGOktRB70xlmd/At6etONcR1za/EsUjfnkvnKOPhPwpywh9TbJ50WkGUD3rQvQbg6VJJuQtZu78HIHAAc/NSpoOVmp7grg1StEMbRExu9JJV6VOLfYb+1d4q2idAnNw+5E8H20JoENkKBQgKG4NOGdT/XRvj7CaJdWspyE7x7FVoCvSP/oCH0pFsZGK134rFv+7AVVHXQY4njnWIuxpgcuwdweNJih0gqpBOY5ZaEGt3AgER6fHRQAeJlb5A8MdVFVhs6hg9d9NA5915gDJ7MI0dugJEcIkZq9+p3cxamUgQa1GTFCe+hlgFt0au0eXLWzck1fcwVX4zMgmyL2WwoGWihIMvN1DRdbrCq2pAwwcERGb9mZIB2lEDaU4B3PlpCC3HmCxgO03+lfQSLUIA39CDIDnSHgqb7au3QnqftVSW68jx1COutlj+8eqG9N/QoY52dXsAXdC1fjkCDtl2zguZPjyFc4DyU3RPDYzlCBCpfsmfUt994ypDt10uHKUyLlEKdM6VZPunotP9SQJ8i8uHvavDVT4xMX7+irMZ9KlGur/cduz2ZP9WhIQyiSuDJ4ma2FOuG3uPLqfl45jzG9jIQ1JN
 cyhxTmhN
 ox4X1R3Ldo6YekgI5vyN4sdnXBZqqtnZH+dyut5hPdVc1x7VfQ69DWcdHhAQU87HTOAJPhawMEeioP+vBIOpTatteHrx0wsITq/SrID7Kdvj0xAWSOh4yEhkWllWK3JygcpoVTyf5vy9qc/2dfJVAWJnvUA3jw8GI4XkggRvCw8vl/V27Ll9G+ST5cjlkL/fchl02PJ83hYFRzL0I36q1e2bBlTS4w0G8E332zPnJaXG4prZhyOUDexYnaT9xwfu1AQOGf5fGHWzTsYbTu5m8xccHhwvNTcuBhQiaI0vxC6DR8UHeHONy8/LF5EQO48NzqVEMf0KrxYJSl+yqsdoay8/TbW7bMyU4wlGDIvRm3n+ut4q5L35CP5Z5DMcoDu433ZfjL+6l9obshQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch fixes the broken readahead flow for POSIX_FADV_WILLNEED, where
the problem is, in force_page_cache_ra(nr_to_read), nr_to_read is cut by
the below code.

     max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
     nr_to_read = min_t(unsigned long, nr_to_read, max_pages);

IOWs, we are not able to read ahead larger than the above max_pages which
is most likely the range of 2MB and 16MB. Note, it doesn't make sense
to set ra->ra_pages to the entire file size. Instead, let's fix this logic.

Before:
f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
page_cache_ra_unbounded: dev=252:16 ino=e index=0 nr_to_read=512 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=512 nr_to_read=512 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=1024 nr_to_read=512 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=1536 nr_to_read=512 lookahead_size=0

After:
f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
page_cache_ra_unbounded: dev=252:16 ino=e index=0 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=8192 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=10240 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=12288 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=14336 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=16384 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=18432 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=20480 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=22528 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=24576 nr_to_read=2048 lookahead_size=0
...
page_cache_ra_unbounded: dev=252:16 ino=e index=1042432 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=1044480 nr_to_read=2048 lookahead_size=0
page_cache_ra_unbounded: dev=252:16 ino=e index=1046528 nr_to_read=2048 lookahead_size=0

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 mm/readahead.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 3a4b5d58eeb6..e88425ce06f7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -311,7 +311,7 @@ EXPORT_SYMBOL_GPL(page_cache_ra_unbounded);
  * behaviour which would occur if page allocations are causing VM writeback.
  * We really don't want to intermingle reads and writes like that.
  */
-static void do_page_cache_ra(struct readahead_control *ractl,
+static int do_page_cache_ra(struct readahead_control *ractl,
 		unsigned long nr_to_read, unsigned long lookahead_size)
 {
 	struct inode *inode = ractl->mapping->host;
@@ -320,45 +320,42 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 	pgoff_t end_index;	/* The last page we want to read */
 
 	if (isize == 0)
-		return;
+		return -EINVAL;
 
 	end_index = (isize - 1) >> PAGE_SHIFT;
 	if (index > end_index)
-		return;
+		return -EINVAL;
 	/* Don't read past the page containing the last byte of the file */
 	if (nr_to_read > end_index - index)
 		nr_to_read = end_index - index + 1;
 
 	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
+	return 0;
 }
 
 /*
- * Chunk the readahead into 2 megabyte units, so that we don't pin too much
- * memory at once.
+ * Chunk the readahead per the block device capacity, and read all nr_to_read.
  */
 void force_page_cache_ra(struct readahead_control *ractl,
 		unsigned long nr_to_read)
 {
 	struct address_space *mapping = ractl->mapping;
-	struct file_ra_state *ra = ractl->ra;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	unsigned long max_pages;
+	unsigned long this_chunk;
 
 	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
 		return;
 
 	/*
-	 * If the request exceeds the readahead window, allow the read to
-	 * be up to the optimal hardware IO size
+	 * Consider the optimal hardware IO size for readahead chunk.
 	 */
-	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
-	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
+	this_chunk = max_t(unsigned long, bdi->io_pages, ractl->ra->ra_pages);
+
 	while (nr_to_read) {
-		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_SIZE;
+		this_chunk = min_t(unsigned long, this_chunk, nr_to_read);
 
-		if (this_chunk > nr_to_read)
-			this_chunk = nr_to_read;
-		do_page_cache_ra(ractl, this_chunk, 0);
+		if (do_page_cache_ra(ractl, this_chunk, 0))
+			break;
 
 		nr_to_read -= this_chunk;
 	}
-- 
2.52.0.107.ga0afd4fd5b-goog


