Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207C5D116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8D46B002A; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B809D6B002D; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A495D6B002E; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9080C6B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:32:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39625B9848
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:20 +0000 (UTC)
X-FDA: 84172805640.19.D1037E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9C8531A0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ITwt/47d";
	spf=pass (imf19.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764639138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aE0HwMs18Vm+zeitaHi8xyIfgDHcAH908O8Y2KqWKvc=;
	b=0dtZxKeFOei6Ae57xHeveIdSF+5e2IJOBR5Hkb7YYjdAZ6+1L9UlRJMS8QHVstIq9LJmir
	4Y8yMPw2wdDb2Lvv8Eu8LO47Xltj2aDJbUKtglVre3OURjtlSyDzAyb4/Whf8CYHf9JISx
	YWzJn2MaX8E5OWq4kLRHB/tBIewZ85U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764639138; a=rsa-sha256;
	cv=none;
	b=Py4C8rEVKuGfAX3SlMt1nCXyRe38B6gceYtM3fDGeadSkJiRtHc7cYS9Haiw33vsGi6vgu
	+I5kiRj4FW1TksBzuSk5+EUDwmSu1PNc16GoE/havhocrHWvjieI+K6qZlgtyHGikSDOWX
	96P5ZaSfKApoUFhl7gEtYe8c+JTSGnM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ITwt/47d";
	spf=pass (imf19.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EE046018C;
	Tue,  2 Dec 2025 01:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7560C19421;
	Tue,  2 Dec 2025 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764639137;
	bh=BpU3vRCEK3UYtGGHaZpkgnwj8upX/nDTSQm3S16WZKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITwt/47d5odXjPpW5XsmIr+DppcqY0pR7w2OmyMxX/v9Vx+G5bblrfvU+3LW1uPv+
	 W+yq4wTfC97UROaid0R1bZ9j1N80QXn5A+jKF2SlL96b/I4oGr8gCEOcjFfEnBOiHv
	 PCPHEM8/Pf1yit1bd1W48L5cGbhjX9vty78//0ezC86uRWVYhR9mo2fyD4gFVlDmNU
	 ZyU4n2fPng8NyawGr8oc76ZyYOoO07QsBYQjMgL7nb5oUCR8TNrLSTkOrNcY564dH5
	 qiQuLPh50ysMiu+tjCCv3z2MzK4f5kTtuzYnB8RYzg+yxjUd+wF32DWNLXSDr1vZ17
	 F0GD94JUSw90Q==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] mm/readahead: use page_cache_sync_ra for FADVISE_FAV_WILLNEED
Date: Tue,  2 Dec 2025 01:30:12 +0000
Message-ID: <20251202013212.964298-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251202013212.964298-1-jaegeuk@kernel.org>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C8531A0005
X-Stat-Signature: bk77e6cd6xwr3sksjbpkktxw1ikf54i7
X-HE-Tag: 1764639138-364275
X-HE-Meta: U2FsdGVkX1+m0EhExynCRA8UQ7xm1VmByNdqsDwqwgDJL3xdjiDVYXXerTEx+cwU9zVspM4OAD7DEbpmMwhJyORKTkDJFPk3bI3hHIagWUNnYIAktLmyDDsigdAGEBkCHGH3fFV156C7LJeZxqQ6l0ElHH5gTBv56zrtp3YqwRn4twtS8Ma3PxcM0Wrbpz02WbMEJ7rlK/mHbKgmdMj4TTBiu42crk4qZ4Ggi/GI4PyC6+IukbaSlOpgngkaS0WvGDF5WSPIeaSt+OwEQ3lXgD7VERKwoUJw/75iBEPjIRJfXR74I/UJLUUP+8fe5WL9E6I06H+/puIGjYlXWBZHN3fFIcXmLYWpzL6KJIFxeewuPWUYGpGXywfwHlVuFU1vKJJBIfdBul3i2/7AKSHcSRVicyKEWuDp367n+EN7AzzcImAeNE1rfULkQvhLgqPUY9hF1Ct8EIo1eOzqBV+Iz/cL0VE+q5qQiusZO2Ia1320UQnM0iSz1YyHojMt6O4Toh9bq7yuR/og9LzfUMew1Ydd6M0APUcgFWtJrA7x7kDin+QcTGoqMhI1E4l4LnEF5ZGCgrjWQ3OJ32iq07wKVmgb4mnfD76vkXjRcqVg0GGYFXUgzuHxDWbd+mEjGB1sNrJ8st+diiTgU54dHf90zWOjZC8orr3OqR43oKfG+TAQUrSVrLJEqYgkBob+FqVQQnLfS22YwJXwqW+3hNc12EQMmChOs8h6XVAglvqPl5fYhhgPtFOUE2ol8tJa4C/0zEGxEl186Hgl8NURlY778y5SfoERtwHDhNuJQ1umBsSauoAlrcM+5xTLXQhieEQQFCu8Q8AwAZnG/P8ieI4efQj4w+B+iEEPrfSzRl4YaKEJjGMHeuzRN1Joj5/XjJ4daNu7Aeny9klffMjiqBaRz343zuY9GlJ8J73OmDi1eAARpzRb+8foG8CDvho3KSQ/O9ASKsQEmU5psJ/OcNI
 uEVK0ZOD
 VgTVwsmG9QZMmt0IWmSmdIDRNe9svHD6RQKtCjWkcglOugH9EQenqIm9CWCIaFpbQ2ZG+zcXi5zfax/fwoF8r9j9c2UJiDvX5wnLD5E94xqCb08UAd4TuM0U0xdeBG9J57qiwRRw6BjEfixel+SRaAv0uFsVzqmkj2ubPN3YcpzopTx644/FvgIenrWjWpnMHDbOiwRpCyqO3Kh6EQBh6fv0cahkNdZoFH5J/GlYzNXusTi9u2QMEBIwdTkn3dhyECVwSN56MzecViiFPmTJTqK4hcoqeVeuRN4geWv4/8eYSVkm5L4ESVENQMpuggygitdNdHhZbQWD47xfjsb+kjVi81MO0oxog4k57+0EQNBLmfo8TCPmLc424c8G31akxg7rs9NmJAsv9Dho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch replaces page_cache_ra_unbounded() with page_cache_sync_ra() in
fadvise(FADVISE_FAV_WILLNEED) to support the large folio.

Before:
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

Note, this is all order-zero page allocation.

After:
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:536870912, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=0 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
...
 page_cache_sync_ra: dev=252:16 ino=e index=129024 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=129024 nr_to_read=2048 lookahead_size=0

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 mm/readahead.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index e88425ce06f7..54c78f8276fe 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -340,6 +340,7 @@ void force_page_cache_ra(struct readahead_control *ractl,
 		unsigned long nr_to_read)
 {
 	struct address_space *mapping = ractl->mapping;
+	struct inode *inode = mapping->host;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	unsigned long this_chunk;
 
@@ -352,11 +353,19 @@ void force_page_cache_ra(struct readahead_control *ractl,
 	this_chunk = max_t(unsigned long, bdi->io_pages, ractl->ra->ra_pages);
 
 	while (nr_to_read) {
-		this_chunk = min_t(unsigned long, this_chunk, nr_to_read);
+		unsigned long index = readahead_index(ractl);
+		pgoff_t end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
-		if (do_page_cache_ra(ractl, this_chunk, 0))
+		if (index > end_index)
 			break;
 
+		if (nr_to_read > end_index - index)
+			nr_to_read = end_index - index + 1;
+
+		this_chunk = min_t(unsigned long, this_chunk, nr_to_read);
+
+		page_cache_sync_ra(ractl, this_chunk);
+
 		nr_to_read -= this_chunk;
 	}
 }
@@ -573,7 +582,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 
 	/* be dumb */
 	if (do_forced_ra) {
-		force_page_cache_ra(ractl, req_count);
+		do_page_cache_ra(ractl, req_count, 0);
 		return;
 	}
 
-- 
2.52.0.107.ga0afd4fd5b-goog


