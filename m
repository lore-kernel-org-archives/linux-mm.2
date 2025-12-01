Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56303D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943316B0029; Mon,  1 Dec 2025 16:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3E26B0030; Mon,  1 Dec 2025 16:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2B16B0062; Mon,  1 Dec 2025 16:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2186B0029
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:02:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F2F7897DD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:02:00 +0000 (UTC)
X-FDA: 84172124400.30.A291C08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5F7E040022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fCitQp+e;
	spf=pass (imf27.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=to5DpdS1O/WX2wNh5MDvRUBa2P+/Z35okR85bB46HvM=;
	b=Oal/pe4x3g7La/sPZi9ctg+vMseCMOlEsgLlcyCaamZ/JQglCz9Z/vrmAfvgD4WFooXmVS
	gqfNXX4jZwjRWr7Dio9WrRZ8A+wp3lk1vA+7NwI/6Iq3o4lKtm7Mbbj8fQj2C3raF8+H/B
	dPLUHtbgN/CAKZsCQG7XW32Loe7UQQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622918; a=rsa-sha256;
	cv=none;
	b=xXhImmKaQeeMGv0nVs5GysBTdzl0TotMpqesQvcW8I/vaH03DulRIPyNQ9CwJ8+ACXOroN
	V+jdLEAmZ3ZC2heyvuuILFOoIrNF8PKEY6KmvvJttdv3uSo1kkGgPq9ag+aHl7oRXEIX7G
	+zUrUgCmvZ8QC92vaFOdOclt9bjPPvs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fCitQp+e;
	spf=pass (imf27.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DF9B4429E;
	Mon,  1 Dec 2025 21:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB8CC4CEF1;
	Mon,  1 Dec 2025 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622917;
	bh=8ug+1yi+LQMFTT3mOnpEJdIWLd9u4ulukTjJaONrmZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCitQp+e9eyEJVDl5T1w8JSfJIXTa+Q1ad+QVYZeVTc0JxmC50gsbnpqfjof4KxA8
	 oNY+cBI7TZLVyQ90ZELeLVt+xHZYXfCjIKXcSXqDEVwqGXSsNRyvtd9QoUNFbR9Kcd
	 WP1AmZlhlBOhJTiGApbG6KRD4pt4670xvpcKKJrnBCH3UScgjDtXYLA4PBFreOf3wh
	 RuDMaZN8/rcm8RKGhJqTd3QmMoXxQVlJkJuX6K+m22tHjv0euUTNa0Q1LUesBG0FeB
	 Df28r+Jdh2IlmqpZEoGR+K4FRiLya8qcIbX/q/q+1+PkinVf4HMs7oN3bjfN08Mo4b
	 evDTa3ZOK7jxA==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/4] mm/readahead: fix the broken readahead for POSIX_FADV_WILLNEED
Date: Mon,  1 Dec 2025 21:01:24 +0000
Message-ID: <20251201210152.909339-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251201210152.909339-1-jaegeuk@kernel.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F7E040022
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: bpbngn3osxmp4mugqgu4i9bduingzm6f
X-HE-Tag: 1764622918-332440
X-HE-Meta: U2FsdGVkX187BFVB3GFUF04fyzPpmEkDOvA2rrfVZw3ryPAvBoQED1xk689posR/GWWS/uxn6eJNH3tGKrhEKmY+YVbkGfVxYsZlkDo2Rm+mqmpwiXv0ASTlgEcDJouxMIKvOJ3oJsjHJRo/NCs8YF1dsfQgIaxmZ/wfiw8W/qdbDjjp0iPeiHUKAenIG9GM2u/zDt1jfDzGjT/jdIcH5UCcNLUYHRZiZVbFauaDK0yVSXXK9adorCDHmf2gzkzr1siNUmYleLqA85gqJyBuuqYiu5VN6JDqQic9SC93p1NV4W7Lwjq9sAXPmBZMxy9hTjr7q3AEBwIbkTSCjJvmHC/oHyW0QsSwBRZbKtD+6kjAmaQd9ETOdiiEdtoKvUdez75US1wcTdt1USWKUrGdZjxtbrcCRe04OwJy6m3uAwLRzZpI9rKZS5j840yNsm4cKZPyQRBmQXQvH2pF3832t27H4Y8L/6rmGnVEGW+ySWZluMGOET6iaFckygDdlkWdCjVEizEMXQtoqzaQCvWmKafsW2/uA1pUcbGWhGewcjr8nCKhVmDxno1yq2Z8xNuwYRkBV5YyTnUlTGv/UdFgpkVsbCjuHgVFbiJ2H2F9xGNxAf+e3bIhavcxWlZKdkrQkjYS9cBvmot3AFN5vl1IbkzurD7D7lK4DITvszRL9o9M13Uj3k7rPX+cp0k2rpLxozuExmwyvkMRgatOqFBmQV04Q3j75t+BfVQhRn8fowejIG+iLsmZ4CuOprpAefuQrVkqCUYS5x14+Qcfp2pg1AFHAujnLDpjl5bSVUrlvTngP6NHpOCaY9/pRvZSVewt5uN8/RJ+eKlYlsf4KWgVOaQwj4KUw2AqIM4c5Jo6SC3pan0dlnpdM5pY2TSgD3+yLw06/5a+I84053mfzxypmiDg0xnofThywcRvSx9hrRtj2TenJa/fP/JPguD/58OND71Wi/Y3WqgEfvqANZk
 eqYMqXHL
 VH2D7ZNxlNfDtWMvCxmUXi69Y2cDaoswcGSXjEQqkmDAkTEm20gT5yINE/KxyrxopUIOp+5cWK+fH2YxZAb5WurqVEfv6MFJi4QxTcXnrbpwlSboo49jya++UQ3+AjvP6VBeuHxZJDVUdoXltup115cmICN8S4hR9SJ8JSaLGPMplgP81STCASgJdMH/7wlM81Cn/QI9mor9BkgRPYioHi3gEevRbS9parFwlCHz8IXSGC6EDvgLZCYV6t7gRkX8RJSf4iYG7tpMw0Fn4ewQVFdTJy119hJBGZvrNBv3qnwLiiKHjLOXfV2MvUURKp+jbaS7ISMFe8m7sXtGWohdUCWNz01s5qstJUwkFsgQTdaRU1FzQJhyjPzKQNUpZdnLEGPHuHvlp+Mt2BT4=
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
index 3a4b5d58eeb6..c0db049a5b7b 100644
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
+	 * Consier the optimal hardware IO size for readahead chunk.
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


