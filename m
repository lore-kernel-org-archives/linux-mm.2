Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C52DD116FF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654806B0030; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4604D6B0062; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301476B007B; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1435F6B0062
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 901C313ABBF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:02:00 +0000 (UTC)
X-FDA: 84172124400.11.5E93EB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E240010000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJzhg7L0;
	spf=pass (imf14.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBBkS70aNOWzOmLRBcx2jU7eZG4brn/wTwZeRfMvNMM=;
	b=5ChGut7YKeoZnu/QS5r22TTGV/jfRrb6MJxtPg+nGECcI0p5DNBukV9gFJidPSJrpbfp+1
	ydf/tZpZN/ZsRGfT1+GTOcad0ZJS1wxkhB0JMldTCXLUIh9OirqWGkyluB9TbowD00RHvv
	9aj7BN/FiuVa4w3veLhTEm7pn0n+ddk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622919; a=rsa-sha256;
	cv=none;
	b=Z21dTERBhZLDKJ7MXmNYbIUaL7H6O3m92xSmtT32MIABKVH3KjIX9Sb1yd6Quul57rHy6Y
	qtrllo+Q3Zy0gvibizP2qR0rKyS+X7L7r0svj/xj/55C+5rD2RGTC5BhRMNdJhcGYqnG7j
	Y4Y4Em4WRWlUapbMMNbw4+3loj3JpxM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJzhg7L0;
	spf=pass (imf14.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F2F860159;
	Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11722C4CEF1;
	Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622918;
	bh=ymCaVvYBxLZ105+ok6O11I72/6m8odE5XYgiapzJKeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJzhg7L0deFEQE7KVhFIIkZcgXrvIaEEh6AyeUPb6Ol1+OxV6f0hfF+BLEK+i2nld
	 jp7DZsh7aWmrzp+W3v9ReOgv7nCjzjz9kRREFnqbw0CQQvQ3Tg1Ao8DHMKcm/HTNQY
	 eKUuTZlxxua436Lk6mP+nowy93oxot6Jo6ihn+04s9E/860ao/1Z0I12B6TCJL5veW
	 0vLVbgz7Cag+Ew2DqacqmbgXpMY6Znb5gxZsNb60YkByr5z5BWFMwt7mgUGJeg/0lS
	 8P5JQ86CytVCJEQJltAtbjBFnbM5zj6uK7H5mnBMZk6SjSlD4u4lM57qzUSxtaa58E
	 elvpFPYXsdnhA==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] mm/readahead: use page_cache_sync_ra for FADVISE_FAV_WILLNEED
Date: Mon,  1 Dec 2025 21:01:25 +0000
Message-ID: <20251201210152.909339-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251201210152.909339-1-jaegeuk@kernel.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E240010000B
X-Stat-Signature: j7eqj95cx9fmbfbe8p11ngsq8xwqmd5p
X-HE-Tag: 1764622918-49963
X-HE-Meta: U2FsdGVkX1+p6A/nvrg8RJP97RPHTJxfHmWB19gTd3nThOY2dM0bVkNUi/noejZ2jrzxBtGWKYtEfoUyzmDBOWN+O4n6cTrB8DVe3IGrc2fFuTb3sUiRcE47NYLO2EcP9vXZVBykuxWslb//S+6C5PQ8npsvewUqAL3PRL8mw53CryeO0uoln3zCVlh+1SLITzk4a7WriLdjqOz9i3WKEMAxMZ/NKPQmsBOA1jKv0egCoQwRdSVwWPZnTSFwVmZ0MF1tN+isjjY8cEITZrK22TuVMezyA5Qz721NTQhzOAhI5sbA+6iCyVcgasPcoN/mmBL0On239YvFdJAhepOJ6JHHd09/8SNQHIrNwxWPuBMRIcMCCdTtcUYFSk0Rr1d6ZH+sdTzN9ZR4dYoWcEJ7WLPEZnKZy0eCF/kt9o6d2WRMoFBuEH75CyH4nAGJ4RKdIiP+FxsNUienZjAgVC0EVVG4SohD5xk/UArxa10R/W/ZVwfzzSElZwx/tEsdZY9pDbjcVvF05F3g/9avvod/6rh77HLolOYxnHD7A3LkxdUGoo0e4lGc+E4Liv3Y9vsmDVfW6u0/Xk+UInvhb7kLzTDvrse9pzXATTyvlLVnuUQqU1u4OnWczfvKKW6EOWlF1Lr+zaNSdrqzh3YhSEohFfc2kDaRM+Wz9OHda9NUbKyAxB0rRRxoaRbE+j72T0IG2duwtxCSH9OMuhhwMDmgUw80NNjC9wqWuwSF0MeN0mkGLd46ccR3CsdOsoNr98xezNBlPSDeQzrk48mumAIYcyEk40d0fsPcIXDFkNlbYcV4b4qP+Ay0VorRCoS284Xri6oKPsumLRT7CK3qKaAhaY7tkPlN+VTczNhE6BPycNQR2GGfhu1Acc4Irc0iWKPeRE2oCsnzxRG4cXv60nxU4Vcg2zd2DfEg6tM1s1FF8+VI5fk4BGhcuyPKW5hpZB/B3mjeJAGI+W72SoX10pp
 WKSJYu9l
 MBkxLymr8yBi8bgUIEODQ6gg6xjlWcNaNDY3MF9+WB6aHpKVbLO/qmuC+A/TpOLJDpn/Gz/WjmYX9267ePcYHjveRFdybb3nDlcsa5hglq/lBHfU+tXec/98BSBKLEyLVvlTuO4rUZYyP2w4v6sNvh7srXl7zY9kqS0+vuK9ugmqw3ttG4T0fJDXB0Xi+zL6yXKRdns1DBMn45fHSY/u3dggLzUYC2RRjfkaMH/XoZA0mDxmEE2oPHDnhX9C07T3/LKDD4rdJPysv1kkeZOjI7/nKkgHcXWzdrdYi4bhUWTMPpXzwv8tYR2s5MrQtcQpz0Gw7MPMyvtcaFbtWdmi9Am5qA1FX5n/YdzANGQDLouboN6okCS05VyzliYvOjezhI++aGtLq73B3BkQ=
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

This is all zero-order page allocation.

After (order=0 by default):
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

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 mm/readahead.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index c0db049a5b7b..5beaf7803554 100644
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


