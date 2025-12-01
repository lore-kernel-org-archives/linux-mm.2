Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6182BD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4622A6B009B; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D086B008C; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C636B008A; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 136C06B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C20E4B837B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:02:02 +0000 (UTC)
X-FDA: 84172124484.16.4A0B51B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB47E180014
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:02:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4Ygigxa;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXCHX/vEyi2LagIxyejx0iZg20K612Kv4wKL/Gs/Vtk=;
	b=TOHuTrZPf3pncJKLljWTcoYvj/TlwPeDJXVpsZE3VRtk8uj6QJAxG1OB0d+Pd72z0nVYNq
	aKlKD3v9Yy6+s1hBAbDhv6HhhTTeSypd2CzTKVQjbWRpdqSVJ3Ygt0In3FsmiHbhxTuzFt
	3oWRwGgaU+yAL6uRxJ5UGkXtwZ6nB4k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4Ygigxa;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622921; a=rsa-sha256;
	cv=none;
	b=FE5bQN4WcGbUam4/m+/az6kcXdvnaV9PhFfYSLBy29VRCmQT/rB7qWoWCiVD4eWrIJASUT
	i30HJsHlitrU3t5paRaxX/Ly4hUj010gxnewLa3FPzl/Vu+4wdg+mJhGwJ9cJXBWQiNLoo
	mZQGTh1oW6mcjYUZPjL5n9nVf6w/iKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 084CA443AD;
	Mon,  1 Dec 2025 21:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE767C4CEF1;
	Mon,  1 Dec 2025 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622919;
	bh=F8dsEH8LzOP5exYXTa3xg16NLIpugxfOznLwZuhVXug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4YgigxadJvN2JMHsDU+R/BEtZ8bFGBGmBgXFIJPYiBvStYlK6M1cnXRFnegtigRu
	 KUZiaTevjstN4jzw+2FZcBr56TnANRw/XzZtYQs621EuvKQF5QHPEDZZkXjwh9MhE1
	 7eOh+UG1r6tY9FQfgiqtbUqV77zXc5OvXVH2wu4MlhxhBR9QXzJ8xL7E2DeTRz4E9l
	 KgjY1RNz341yGIQm9+Yd7kIXgfpeA3winTyqz0YMZNdDxY21hUiDSPQqdu+VYvFPBx
	 et4lbIvcnmeZVFRC3gJVGH3MzSG0xinYNzdQ4VZbRcy+ybLfo3ebh/AEz7u/8X0R7w
	 QpmCBuWuG1cbw==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/4] f2fs: attach a_ops->ra_folio_order to allocate large folios for readahead
Date: Mon,  1 Dec 2025 21:01:27 +0000
Message-ID: <20251201210152.909339-5-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251201210152.909339-1-jaegeuk@kernel.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB47E180014
X-Stat-Signature: 6badcgoj7c191p69juwpac6r4qq95bjg
X-Rspam-User: 
X-HE-Tag: 1764622920-946252
X-HE-Meta: U2FsdGVkX195gBrng05PcsRaTYmrowyVE9N0hyLc3CyqnJoY3ZcyoXXQeCSdY1BHH+K3GO/OKR/siwKcZZZ+A2wEEDp3BrWxowzVkiZuLWifF++uoQSz0Ly0vGlEUPIzmSRLQ1B5BceoVXQR7aiYPzxEK/N/5V9gq1hxvBHq28sD+HCEgj9YXRhF7MLkYNOikcm2Ht2DTEfMFg9K4vWQR5rivhduRIdJ3MUtYTzj5KOydC5gaN3zUmQVw3osrwFArsI99CrwCf4CogrzbrdLw1qSpk3/2KbtiSsFZ3lIEWYg5/jY40FdGZrLt35HKYshQ2H8xP8L30KHBMosI1ZpdI7lubTE5ZT+NYgBYjCsDutkaLcrUehSMVCZgLx4rljZFX8N5sIAvQjtlRUodwnAJKmlgkvRF5g8+NfYxVCes+CCJB6yDzKXPR5Zhmv0KCG6UB9/vh5EPpVBAzt1TD9Ea4rXT751WIvAdzsTMfKTq/0jHUGq/lZX00jaV2xXHefVWxUZH6VB2LkzdoONxZnFSLNSRfghpIP2iabl7SzCpnh8veGd8pYKCpDYPGiS7CvdZ6BwfyYVcpY9N/jEvo0wlpJZ+aKTjfqg6TBYBTktN8t0LT6y7rscH0K2vZLNgv6EFJ7EaltcCHnwI/Od13MeD5Eus7vA0L2wSYYvlvowrUvjbMFN0cWV/BJISB4BCyBYKtNMyyLd6G/jn9MM4yVPcSMXM7YZaJMkbJSgE7/N+HpQ3FAo5XtfUrtHNOAidIKYu4Ob24fPm/wodvnZaJX9eIaW3D4w21sQPrILbyyq+uRiYddiLPuP4SZ1Fna+9RJqLTjOKZN+1zSgkfH+/rZW0UFqyPtYlHTt5H2N3PEFPd8aTeSleFpRk0H69yq0WRCVWnufTy3DKAyeETgHjEVJEQY+6lHimK749zriIhTjPsDX9lMOPLUBk8aePi41OQcNV48DX37ikWP3d4TvJoD
 YbnueQfX
 4GudYZw7XEJwMZ6AVnFoJqIZ7WkSQk8Uzu68cUAhr+r7zsd0ftSk9B7Q7tzyWPKFodg8dJO84c/wvvSQXRFVCLBh3DZWCuvRxF/L/IuLmygpViaqHSFNm2uD4aRm67zzw+PEeYQT2d7Ol6A0BULJQIqrITUoIkWO09WtNTr28YDChaCfKHNiuDb/2hvaN8S5yCnyijwKo8KhxN1GAeiDAN0ZPr0JItojmL2h0ZYt6N+erQRGlBP/Lio3VCDFrt9dCAjpNkGgI6U9Rf6yD27m4lxk4FHl+N51aVgbiJxAscYBQa7KRbke4X5vV2qbUOLZXfTA1h810NvsMFqkhqsn3pkqKfMCj/dnhahwlU3rQhyrb/ie6yASigxi/sH3jlUiam0lJHXSouA8Ik54=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a sysfs entry to change the folio order. Given ra_folio_order=9,
we can see page_cache_ra_order getting order=9 when we submit readahead() as
below.

==== folio_order=0 ====
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=0 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=8192 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=8192 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=10240 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=10240 nr_to_read=2048 lookahead_size=0
 ...
 page_cache_ra_unbounded: dev=252:16 ino=e index=1042432 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=1044480 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=1044480 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=1046528 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=1046528 nr_to_read=2048 lookahead_size=0

==== folio_order=9 ====
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=2048 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=4096 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=6144 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=8192 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=8192 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=10240 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=10240 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=12288 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 ...
 page_cache_sync_ra: dev=252:16 ino=e index=1040384 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=1040384 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=1042432 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=1042432 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=1044480 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=1044480 order=9 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=1046528 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=1046528 order=9 size=2048 async_size=1024 ra_pages=2048

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c  | 9 +++++++++
 fs/f2fs/f2fs.h  | 3 +++
 fs/f2fs/super.c | 1 +
 fs/f2fs/sysfs.c | 9 +++++++++
 4 files changed, 22 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7a4f0f2d60cf..addef5a1fdb1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3995,6 +3995,14 @@ static bool f2fs_dirty_data_folio(struct address_space *mapping,
 	return false;
 }
 
+static unsigned int f2fs_ra_folio_order(struct address_space *mapping,
+				     unsigned int order)
+{
+	if (!mapping_large_folio_support(mapping))
+		return order;
+
+	return max(order, F2FS_M_SB(mapping)->ra_folio_order);
+}
 
 static sector_t f2fs_bmap_compress(struct inode *inode, sector_t block)
 {
@@ -4313,6 +4321,7 @@ const struct address_space_operations f2fs_dblock_aops = {
 	.dirty_folio	= f2fs_dirty_data_folio,
 	.migrate_folio	= filemap_migrate_folio,
 	.invalidate_folio = f2fs_invalidate_folio,
+	.ra_folio_order	= f2fs_ra_folio_order,
 	.release_folio	= f2fs_release_folio,
 	.bmap		= f2fs_bmap,
 	.swap_activate  = f2fs_swap_activate,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d7600979218e..06f90d510a01 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1932,6 +1932,9 @@ struct f2fs_sb_info {
 	/* carve out reserved_blocks from total blocks */
 	bool carve_out;
 
+	/* enable large folio for readahead. */
+	unsigned int ra_folio_order;
+
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	struct kmem_cache *page_array_slab;	/* page array entry */
 	unsigned int page_array_slab_size;	/* default page array slab size */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ccb477086444..bae02ca96c1f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4287,6 +4287,7 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 			NAT_ENTRY_PER_BLOCK));
 	sbi->allocate_section_hint = le32_to_cpu(raw_super->section_count);
 	sbi->allocate_section_policy = ALLOCATE_FORWARD_NOHINT;
+	sbi->ra_folio_order = 0;
 	F2FS_ROOT_INO(sbi) = le32_to_cpu(raw_super->root_ino);
 	F2FS_NODE_INO(sbi) = le32_to_cpu(raw_super->node_ino);
 	F2FS_META_INO(sbi) = le32_to_cpu(raw_super->meta_ino);
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index c42f4f979d13..2537a25986a6 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -906,6 +906,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "ra_folio_order")) {
+		if (t < 0 || t > MAX_PAGECACHE_ORDER)
+			return -EINVAL;
+		sbi->ra_folio_order = t;
+		return count;
+	}
+
 	*ui = (unsigned int)t;
 
 	return count;
@@ -1180,6 +1187,7 @@ F2FS_SBI_GENERAL_RW_ATTR(migration_window_granularity);
 F2FS_SBI_GENERAL_RW_ATTR(dir_level);
 F2FS_SBI_GENERAL_RW_ATTR(allocate_section_hint);
 F2FS_SBI_GENERAL_RW_ATTR(allocate_section_policy);
+F2FS_SBI_GENERAL_RW_ATTR(ra_folio_order);
 #ifdef CONFIG_F2FS_IOSTAT
 F2FS_SBI_GENERAL_RW_ATTR(iostat_enable);
 F2FS_SBI_GENERAL_RW_ATTR(iostat_period_ms);
@@ -1422,6 +1430,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(reserved_pin_section),
 	ATTR_LIST(allocate_section_hint),
 	ATTR_LIST(allocate_section_policy),
+	ATTR_LIST(ra_folio_order),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs);
-- 
2.52.0.107.ga0afd4fd5b-goog


