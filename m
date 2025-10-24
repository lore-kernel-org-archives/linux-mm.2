Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6107DCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C338E0057; Fri, 24 Oct 2025 04:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53AA8E0042; Fri, 24 Oct 2025 04:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BAF8E0057; Fri, 24 Oct 2025 04:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92FD78E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:06:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F7AB12A126
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:31 +0000 (UTC)
X-FDA: 84032275782.08.71A3237
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99176A000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=D6AogjIs;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK4+A+XQ8xSWXf+Z9tTtAvh9OT31XsHF6kx6Btc5iA8=;
	b=pNzpuYNbqAAVrQtCWej10T9WmWCARcNP/NKHgugaGZ5MBO4iCUEk68TSYJPwwJtd3R+tXk
	7lrRyJ8MxK6dF3GNIto17QW3y2+OsedZ0S6KhZ1adqzbl9tbWWRjaO3G8nuTaEDRf/uwlR
	yQo5or9QiqkfH4c0rFyNZIuJW2crXx4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=D6AogjIs;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293189; a=rsa-sha256;
	cv=none;
	b=qTXYFlqXtaT2gAw2XwPvlOIqcr2YhR3C/OKJc1Y0MQROY9XwzJBOi9rLRpg7WA2dBV4KXE
	Q2FcddNrWB5lUHicSjJAK0d3/RKqAumrP72aZa2FtapUFLLBMZ/dzlLyPvaRNa+2PUhDzq
	QFWVRJsFzuGBKxHFXJQ1J3MD/xi/tuA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CK4+A+XQ8xSWXf+Z9tTtAvh9OT31XsHF6kx6Btc5iA8=; b=D6AogjIsaOXIaEKMP8+nYzb2S/
	Oi9fBsDLQ/QDLj8zWUOszOIZUXoUGJEGD6oOe3/gwwa36ob+z5Y4jnXIMl/I47R2yybCHjHy9PVpp
	u9rk8NVCJvRsT7wc5scuOjf+d0qjgiv7xQKVzrHmYhwZolySV+SEki+Hm9VEk4MYwcBCOKWh8kE/L
	vlzlOWvLC6nPNVOCQn/9gA1eRi4wHGrw+7X1beFwTeRlaIDXxs6ij8o/wGIbY6gxmKmEmayQZ5noV
	iBvVRW/cRH9N2cvm1YrB7NcZkATFE2g0crlK/d+n5Fpb75Kk12b+O+FG+yCLdiKH/xMwQRP6Ju0xM
	N9qYV9hw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCoa-00000008cQn-37yb;
	Fri, 24 Oct 2025 08:06:25 +0000
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
Subject: [PATCH 10/10] mm: rename filemap_fdatawrite_range_kick to filemap_flush_range
Date: Fri, 24 Oct 2025 10:04:21 +0200
Message-ID: <20251024080431.324236-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 99176A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 68bbfmmtwpfar47oc3ubb5xgb68ydkwb
X-HE-Tag: 1761293189-84447
X-HE-Meta: U2FsdGVkX18mEg9M6K6LPmMYg3S5MOVp6Jk0nkvn1jJBFZ2LifjVLp+Jk5u4IMWcBgQ/LFOCtGqi5RGuIR61mfbJn4r8e/lAxCNskcDKLg9Be2zRVFyU8/U3wSzYyrq+eoWd5VahAA6PuOrQ7/qzfaMgW/bpA8zxbgRIxqYqjkcU9hTdTeLk1IoJ8AAOOcehtq0wWgMwi7dLEqBkqiO14t57IFOVL0ReXz6VqO3W6lOalOXQciVq7KyoZSWtclsSKhnlG4/FDchoT+O5w+trIh2IctuLqnVjvdPR6hUQOHNLcTu7hk0jLYeOqUGjV2O/tB2/OBlHvsO0KOMGwV6hEiFH2bm2ufivkEFQKxO45cP/fQc03AtXgin4scA19p1+Fd913Px0SPcVpbOUno42oNQ3Sh0l0ty5EeyFmVabOLUyqIhqLP96Gsls2iewgq5SJkeIXRuN7CX+piwbDbtz6kEV9kxXNUIUGoJBr9KEfbTiv2lbiNOm++Vua/n5rmVN40sgwzxbHNjpCKusVZw6Y3LMkIs4zakDg8fpdXJ/O6iVoqqUbpDOkg1XpTqXMrcR1gd+JLi8+x1dIBgxiITO+hrecI+kFZnFmUECcgcQ2WtXB9UYHXEbqQ1eZLR9JYsgY6dbjP8TRJNzZzybSmjJGpimYkCeoRvuSwPqrF5KLDhvCpGWAmR7dyj15/hCaVAtUKmpcr6jP0z57mWMNYNViTtOgTpl4SXMqV4ZDtfbuzdKPeLaHw/O1RCkfETGUKpnI8cggvPwHywpke3sRnabjlghdDceBU6q0kmQLG6xxdAmxElTz/J4SJDzTP8VajM+48w+Y/YCzet8GRkTVn360wFx8XS+t3niABIEl4Ru5YibUHurcGbh0XER/GX8splS0s6XYnMBauE+WWOuuU3aMpolyiMx1MIX0QJmIiY6x/xCT+u8J9A6S+eDI2iIAbbfkFlaCbqUce2fv8B29da
 dwM6Mqsd
 MkTbvpLpPtTgpHt8v/4KedD83cJktruWk8z9LvZKD1QmZdREYUzqDuZ00Em/sChw5WAA0532PvZpFeJ1k6el4StLKBLl5qrQq81TsOrdD4+OHhfTGIQHifCI6HqpsfOwCMs0kZON5GwJZmVBRUjBcOEc6bZMS8sqa2OqfiKR6yQAjaSXpS7Y7sS3XpyWs5OhoJFzhiL6NYonIZdcEZBBg39Fn8RIY0UvjAoXNahe/0zSjphVHYMJm//x2U7QcgQdvesNWCTXoVSKluKco2yKLiYvELfl6hGctWzfwLwnRTIgtXOzk3Ups/RSITHVzOg52pHwWZIbQe+lx1aKBYs2T3Ec8PIIpM/QnIFVHEBIkd5deOlPT/eX27w5HeDXIb7307iUEE0XNoHIRsuY3DvLeZ67yCvSu1C6QoV+qTyNx0S1PlhHbdQYevMQUh6QYAFNWOG0WrQ82XiYcpnNN5FhWeXeBfoOJd11CEXnKmLPvTdRsw+nfDQOhC66KO8d1XGO29W1xj/r9R2WhaoySSjLwgcV8w+ZW0qmVHF3lBiCLA9hFhGBZopQUUcnbtqi0EZlxMzcYE+6d5yRqMEUIt0Pw0zySEdi3u+DgstVNQIXar7G8HRa+D34y7kVxX+Wxld+XHIhWF5nZNBf1i1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename filemap_fdatawrite_range_kick to filemap_flush_range because it
is the ranged version of filemap_flush.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/sync.c          | 3 +--
 include/linux/fs.h | 6 +++---
 mm/fadvise.c       | 2 +-
 mm/filemap.c       | 8 ++++----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 6d8b04e04c3c..1759f6ba36cd 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -285,8 +285,7 @@ int sync_file_range(struct file *file, loff_t offset, loff_t nbytes,
 			ret = filemap_fdatawrite_range(mapping, offset,
 					endbyte);
 		else
-			ret = filemap_fdatawrite_range_kick(mapping, offset,
-					endbyte);
+			ret = filemap_flush_range(mapping, offset, endbyte);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..a5dbfa20f8d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3014,7 +3014,7 @@ extern int __must_check file_fdatawait_range(struct file *file, loff_t lstart,
 extern int __must_check file_check_and_advance_wb_err(struct file *file);
 extern int __must_check file_write_and_wait_range(struct file *file,
 						loff_t start, loff_t end);
-int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
+int filemap_flush_range(struct address_space *mapping, loff_t start,
 		loff_t end);
 
 static inline int file_write_and_wait(struct file *file)
@@ -3051,8 +3051,8 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
 	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
 		struct address_space *mapping = iocb->ki_filp->f_mapping;
 
-		filemap_fdatawrite_range_kick(mapping, iocb->ki_pos - count,
-					      iocb->ki_pos - 1);
+		filemap_flush_range(mapping, iocb->ki_pos - count,
+				iocb->ki_pos - 1);
 	}
 
 	return count;
diff --git a/mm/fadvise.c b/mm/fadvise.c
index f1be619f0e58..67028e30aa91 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -111,7 +111,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_DONTNEED:
-		filemap_fdatawrite_range_kick(mapping, offset, endbyte);
+		filemap_flush_range(mapping, offset, endbyte);
 
 		/*
 		 * First and last FULL page! Partial pages are deliberately
diff --git a/mm/filemap.c b/mm/filemap.c
index f90f5bb2b825..fa770768ea3a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -419,7 +419,7 @@ int filemap_fdatawrite(struct address_space *mapping)
 EXPORT_SYMBOL(filemap_fdatawrite);
 
 /**
- * filemap_fdatawrite_range_kick - start writeback on a range
+ * filemap_flush_range - start writeback on a range
  * @mapping:	target address_space
  * @start:	index to start writeback on
  * @end:	last (inclusive) index for writeback
@@ -429,12 +429,12 @@ EXPORT_SYMBOL(filemap_fdatawrite);
  *
  * Return: %0 on success, negative error code otherwise.
  */
-int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
+int filemap_flush_range(struct address_space *mapping, loff_t start,
 				  loff_t end)
 {
 	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, NULL);
 }
-EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
+EXPORT_SYMBOL_GPL(filemap_flush_range);
 
 /**
  * filemap_flush - mostly a non-blocking flush
@@ -447,7 +447,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
  */
 int filemap_flush(struct address_space *mapping)
 {
-	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
+	return filemap_flush_range(mapping, 0, LLONG_MAX);
 }
 EXPORT_SYMBOL(filemap_flush);
 
-- 
2.47.3


