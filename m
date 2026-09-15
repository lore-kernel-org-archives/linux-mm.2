Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915F6C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4576B008C; Tue, 15 Sep 2026 09:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CAF6B0093; Tue, 15 Sep 2026 09:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A39D6B0095; Tue, 15 Sep 2026 09:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319CA6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:59:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4B791402D7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:59:17 +0000 (UTC)
X-FDA: 85216153554.12.2886131
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 181CEA000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:59:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmxnbBAh;
	spf=pass (imf25.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789480756;
	b=Pv1wDLO1rrRZsGb1tjlActt0LBkBD+wgbxx9QgP9aJyCVES5pASx/9aui0Uob06MtOacnO
	0AGunT4dLPAy8v/pXej/cMs2G4BEz5YbCEoWYEemH+8xyw43Kx1C5rmn1Vy/UTsF04b6Io
	7zgqCvKsQ8q+uolC6Zg/kHdi5HGO064=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmxnbBAh;
	spf=pass (imf25.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789480756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xt1pn2hZDDCJHs47h/vFTcvzZQctrx3Ka/dgj8KHcQs=;
	b=njpJbr9i4MCYcX5/RSmn3V4lj93eV+mMR24b0l/WWjIzEPqkh8S10aG5nC4bg1yeVYHKCb
	LU6fMd4tF0D4CvuvT4aBwOKgMxtuub7WmvildT1VbjCldPuRnVE8a0eeW4k0jvnm2x5xFC
	ro4xWHA4OKgXF6ICPUW3I6CvlkJkBEc=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f01363so23724015ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789480755; x=1790085555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xt1pn2hZDDCJHs47h/vFTcvzZQctrx3Ka/dgj8KHcQs=;
        b=GmxnbBAhdEA2B+5ooEaUydIaW2lN0XCdGgJtm8H+3H3ybfvQssSASvuQ/TRWfV4dxO
         gIIQ9/2C157kWDay7vC9L2uYw7NR53GEssHgIcTg7bvCF3DXOoHGNwoed5H9XNqJIUa+
         BSHxJAfeqpCWT9oR4loJ+B3J+ePAQ58CTyfs1e76ZtmCVsoy6duzwJZvEuA2wliu0crB
         KZyRp3pkokNSU6elHggsid86/g3WUmYX7ulaC+AJ1WukaGualOZFi8yyYtnV60CK0HOT
         E4ucbSgi+dKKXOTfzavd8B6CjoKgKZEMAjUhnaSYcUwZu61CLkI1XrlVEfZabw80YGbs
         NIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789480755; x=1790085555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xt1pn2hZDDCJHs47h/vFTcvzZQctrx3Ka/dgj8KHcQs=;
        b=HnBSyulzrtZrqUNpsSIWvMNB76+xbQkuPcXCa2Da4RsYCKWQbV3UDFa++r5VmG/TBw
         ipiBqJftnjNFMJYesPEcoILoNK3CV9paygL/QDX/6x20F/zpcqPvXbGPR94+jYd2oixB
         P0FKsAEAtpbbe0LE2NUK+fLbXN3yqi9m9eBMuGSiOhru9xgv9TULZsJYCzA+Exibybpz
         ca3E71sOjFfmCRbBJt3IHB4C2klYryxGFhv0h9r7X5wW+YA9Xv1woSCdf2XPWK/kZDxc
         dH/vToRiRhxACGti+A4zbtbMF0Z65IeR0Yfh1JZKt6NAvhJeOYvA55QIMvfhqC3F+BT7
         NUQQ==
X-Forwarded-Encrypted: i=1; AKwUvByuaKVjmnWp6+NhaVOLqVgbWJCM4DBvv1kFLq3Dqq4qS0kgJNawaMZz5Eiu6WhId6bxfVapSZLLWA==@kvack.org
X-Gm-Message-State: AFuF++nvtSQc6x2C112rnhqS8tCTqnyKvxcbjbV2cHdq7sUN4dlm4cmM
	7FELUPHFbCSbWUCwQbP7O7nuovOg2vRQVPCFWnKMVqtElsk8u2saRon8
X-Gm-Gg: AYBFou3S/2bn2Z1zmneaECXY+l0za/BJ0frj9Y20NO7EQRCBfepG7i9HOCE/jd0jsF2
	66V8OFdzH/xPZS++YXdE+ksx6Wm6CB2GEzAoTcTbl5dA4xJIo6rJs9dJhKsh4IyBlwDm/Lkpfe4
	J2NFKDjhua8FqbXdHCyTJq/s6/29kDi3ud3/7q2uhd75P72wF+4E32xmHrXXlskcu62x2hO/E46
	GfxuoAfv+gb0uLoyCTxitpjeG6VWK0Rl/PFpLN9tmM4+ZIwAnH5z66OgYmBYnnPk7Ok4T1+lLiR
	zCuNZsGnvnZSRQgTc2CWU0QAnzNxQPlMzb1dxz6sPFUWaFYxTYvT3EUGrKT/yM4Vc2zCbTmU01E
	wfJVo5DVETmevsmeD10kKBSGIjZ7ds+9AD4F64LEO6VAnPtraTjLYwB36KcA3ZHnDclx8QQGtE/
	Bw4vKfKb4ayES7EQGApEoGi5NsVDUHq4rv8fnJPLHhpOyT54DZkDztIK3Ky7Kv2RFsJXFnsvQtQ
	P9BUOrJBHLqhkFQLdx8IUVpWmpydd8pX3eocgSVy1mx1EOdOiBB0I2J6Zswph4A0pZCIKcpat5/
	K28kaVClnT5oHowvZ4AFoGrD8A==
X-Received: by 2002:a17:902:db0a:b0:2dc:fdde:30c5 with SMTP id d9443c01a7336-2dd6c73459fmr139178655ad.17.1789480754318;
        Tue, 15 Sep 2026 06:59:14 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd34c7f976sm65270435ad.81.2026.09.15.06.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 06:59:13 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/readahead: use large folios in page_cache_ra_unbounded()
Date: Tue, 15 Sep 2026 21:59:09 +0800
Message-ID: <20260915135909.1007-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 181CEA000C
X-Stat-Signature: t71ktonopuhbrxjq9919mjmj8q8dezjz
X-HE-Tag: 1789480755-9271
X-HE-Meta: U2FsdGVkX19OOHzE2aYPd/twst3XMtZcS9/fB64gOyIUTrhBHoHrUETozGEIjcSdbrbi0pSxkl+JRBH/g8Yzeqz50HDhvaZqh0lURql1sN6oBHc/bqxoPdsBXHmAOFH4MWaVHoZj2NgvK4dF9dxRy6ulLchy5yfJluHUt83TA8JWFweneP3Fe0kY8hWzNxwVTm/QT5t+cyZPXW1zUlDW+ZAQmZSJklbGVahABRXICR3rRV2VDwwKqDQzVBxWhCzJevX/cMqx0oe5Z/TwoSyv6FGe00n4DcLoIXnNvXVkknicVgA0f3pYV1IJEx7euylaia0G1sprf0iIEFmagP2yAuUcx7vpKHIuKB/S9mCmW95UiIzxaqZCRVRHQruLZB0Al9NtdSJv4s1sWO1iSfThYYsNBHzdfwTJORWyX3RezBKOZQEDzJzex4X/bPWnvdzC4rmClhPH4CccDodNkq8yuxFJ27MVGVXMEyWxEuBWYTKTkKyOIomNuTpML8DpjD0zHMo3//XQwDZ1bCfJDSQtRS82zrsE0szyUinPuMr6sOBvdu3pwzRIzQBogphMF+iJuNsz/aep7TggFQvQaeDwP2V0D7oHhoLxld0QCR6L0FIzDo+9NWno24TZlZEehJ3Hq9K5fglzz0dvRoAX7tZcCTAzFsxm+u4GTQPTtDCFZcLucFQAmDon1mjFjnfyj/RM+G9l/tx9ju4uZolThcNG0vtcwGj5yPsxOI/a0IAQezY/aox2DeoHtojsWGLJ8Qpsr61ZH4Mvy/gsI2UHYsBopWLkpYblDbS/UxlNnhq7T8+k+vN9EQEGKLmY3qiWdXC+STbQdGE7dGifRh7yQelPGNiLsxNvVMQYe+IB40Z7CycsF3oE5OZUbQmNLe8j7DZ+TSGAWw4JNT+BE0Kbva8loTXxJweu4oCZ2gVbLjiBl+Ofm3nhavNIoMr24TNsxU9wbTp+lzUGxKqjxVsqSse
 M+XRJGCB
 +M9xsmxX4E8F/+db5sT/Sxr6JEBUsVdkI9p/V5DxRHPpx23LEdsQjpaYx3MU6ihnA5dALalmPjS5Q9ggC2Uh2EbYNj5b/uhxqkVSguunao8AlrIycsCdC/il9ENiD8llq0ATXuI5kdfARzyB4O5ABYldeOCol/+zGEU7eDN90A5KuLeXN5yBSfcRYE89GyzNCQCTzL/c8YAWJBfWPGbIK+rUsRwWEjYyrmPAVBpIgEeLFcl/y1bZbLdXT6O4lWhoxP/EbwLaU241ax6QUjTizDFRo7k0EfBH4yGfCkQc00OH+xXRBMT3ZgD6Sjb0khPzg6z6zw8ZID7/3Fei/M3tTbU0uQsB+zYAn9cbuLeva2+F358sxq/0P62Y0OwnZhNa7wYkEbeJH+Dr4xno7FLX8QE6E7l+nU/dZmi9/LxLDJLrazgEVOZ1JyRYjDw3Pl7XcMj2mqH+vrYY4xJdblT0sNiIIGeluEj6tuRTBolizUQ3cQLkDRMYpdM/RdbTVL6L+Dz1utDgd8fepnvlx1SzfNzHQrO4Q/UXztkhn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forced readahead still allocates one folio per page.  Everything that
reaches page_cache_ra_unbounded() gets mapping_min_folio_order()
folios, which is order 0 on ext4, xfs and btrfs:

 - fadvise(POSIX_FADV_WILLNEED), readahead(2) and madvise(MADV_WILLNEED)
   on a file mapping, through force_page_cache_ra()
 - every read() on a file after fadvise(POSIX_FADV_RANDOM), and every
   read() when ra_pages is 0, through the do_forced_ra path of
   page_cache_sync_ra()
 - the "standalone, small random read" path of page_cache_sync_ra()
 - the merkle tree readahead of generic_readahead_merkle_tree()

Both the ramp-up path (page_cache_ra_order()) and the write path
(__filemap_get_folio()) allocate the largest folio that fits the range
and its alignment.  The same 1 GiB file read sequentially ends up 97%
in order-9 folios; read after POSIX_FADV_RANDOM it is 262,144 order-0
folios.  RocksDB (PosixRandomAccessFile::Hint(kRandom), ::Prefetch()),
WiredTiger (WT_FS_OPEN_ACCESS_RAND) and MappedByteBuffer.load() in the
JDK all take these paths.

Allocate the largest folio that fits instead: bounded by the mapping's
maximum order, by what is left of the request and by the alignment of
the index, never below the minimum order.  Nothing beyond the request is
read; for a forced read the request is exactly what the caller asked
for.  If an allocation fails, or filemap_add_folio() returns -ENOMEM,
do not ask for that order again during this request.  If
filemap_add_folio() returns -EEXIST for a large folio, something sits
within the range it would cover but the index itself may still be free,
so retry with a smaller folio and only skip the index once the minimum
size collides, as before.  ra_alloc_folio() already does the
allocation, the PG_readahead mark and the accounting for
page_cache_ra_order(); move it up unchanged and use it here too, so
the mark goes on the folio that contains the mark index in both
places.

1 GiB file on ext4, cold cache, x86-64 4K pages, medians of 15 runs:

                                          folios      minor faults to
                                     before  after   mmap it afterwards
  readahead(2), 2 MiB at a time     262,144    512    16,384 ->    512
  POSIX_FADV_RANDOM, 1 MiB pread()  262,144  1,024    16,384 ->  1,024
  2000 random 256 KiB pread()       105,996  9,346     6,671 ->  2,055
  madvise(MADV_WILLNEED), 8 MiB       2,048      4       128 ->      4
  sequential read() (unchanged)       1,433  1,433       761 ->    761

ext4 on a loop device over tmpfs, so that cold reads cost CPU only:

  fio psync randread bs=256k fadvise_hint=random:
        2,142 -> 2,977 MB/s, sys 57.0% -> 48.2%
  fio psync randread bs=64k fadvise_hint=random:
        1,051 -> 1,434 MB/s, sys 50.9% -> 45.1%
  4 processes reading the same file with POSIX_FADV_RANDOM, 64 KiB:
        6.9 s -> 1.1 s total, 552 -> 121 ms sys per process
  20000 random 4 KiB pread() (order stays 0):
        665 -> 580 ms

A warm read() of the 1 GiB file costs 92.5 ms when the cache was filled
through POSIX_FADV_RANDOM and 82.8 ms when it was filled by a sequential
read; after this patch both are 77-80 ms.

fs-verity on ext4 (300 MiB file, drop_caches, read, mmap, WILLNEED,
FADV_RANDOM) verifies with merkle tree folios of order 0 to 3.  No
change with CONFIG_TRANSPARENT_HUGEPAGE=n, where
mapping_max_folio_order() is 0.

Link: https://lore.kernel.org/r/aS4K3jGkJErj94R_@casper.infradead.org
Link: https://lore.kernel.org/r/aS9uod21hG_qq7Rd@casper.infradead.org
Assisted-by: LLM sparse
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/readahead.c | 123 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 48 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..d9ad081c72fd 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -204,6 +204,47 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 	return folio;
 }
 
+static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
+		pgoff_t mark, unsigned int order, gfp_t gfp)
+{
+	int err;
+	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
+
+	if (!folio)
+		return -ENOMEM;
+	mark = round_down(mark, 1UL << order);
+	if (index == mark)
+		folio_set_readahead(folio);
+	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
+	if (err) {
+		folio_put(folio);
+		return err;
+	}
+
+	ractl->_nr_pages += 1UL << order;
+	ractl->_workingset |= folio_test_workingset(folio);
+	return 0;
+}
+
+/*
+ * The largest folio that fits at @index: it must be naturally aligned
+ * and must not extend past the @remaining pages left of the request.
+ * Nothing beyond the request is read; for a forced read (WILLNEED,
+ * readahead(2), FMODE_RANDOM) the request is all the caller asked for.
+ * This is the policy page_cache_ra_order() and __filemap_get_folio()
+ * already use.
+ */
+static unsigned int ra_unbounded_order(pgoff_t index, unsigned long remaining,
+				       unsigned int min_order,
+				       unsigned int max_order)
+{
+	unsigned int order = min_t(unsigned int, max_order, ilog2(remaining));
+
+	if (index)
+		order = min_t(unsigned int, order, __ffs(index));
+	return max(order, min_order);
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -215,6 +256,9 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
  * not the function you want to call.  Use page_cache_async_readahead()
  * or page_cache_sync_readahead() instead.
  *
+ * Folios as large as the mapping allows are used, but the request is
+ * not extended to fit them.
+ *
  * Context: File is referenced by caller, and ractl->mapping->invalidate_lock
  * must be held by the caller at least in shared mode.  Mutexes may be held by
  * caller.  May sleep, but will not reenter filesystem to reclaim memory.
@@ -227,6 +271,8 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	unsigned long mark = ULONG_MAX, i = 0;
 	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
+	unsigned int min_order = mapping_min_folio_order(mapping);
+	unsigned int max_order = mapping_max_folio_order(mapping);
 
 	/*
 	 * Partway through the readahead operation, we will have added
@@ -247,19 +293,13 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	index = mapping_align_index(mapping, index);
 
 	/*
-	 * As iterator `i` is aligned to min_nrpages, round_up the
-	 * difference between nr_to_read and lookahead_size to mark the
-	 * index that only has lookahead or "async_region" to set the
-	 * readahead flag.
+	 * Folios start at multiples of min_nrpages, so round_up the
+	 * index that only has lookahead or "async_region" to mark the
+	 * folio that gets the readahead flag.
 	 */
-	if (lookahead_size <= nr_to_read) {
-		unsigned long ra_folio_index;
-
-		ra_folio_index = round_up(readahead_index(ractl) +
-					  nr_to_read - lookahead_size,
-					  min_nrpages);
-		mark = ra_folio_index - index;
-	}
+	if (lookahead_size <= nr_to_read)
+		mark = round_up(readahead_index(ractl) + nr_to_read -
+				lookahead_size, min_nrpages);
 	nr_to_read += readahead_index(ractl) - index;
 	ractl->_index = index;
 
@@ -268,6 +308,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	 */
 	while (i < nr_to_read) {
 		struct folio *folio = xa_load(&mapping->i_pages, index + i);
+		unsigned int order;
 		int ret;
 
 		if (folio && !xa_is_value(folio)) {
@@ -285,26 +326,34 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 			continue;
 		}
 
-		folio = ractl_alloc_folio(ractl, gfp_mask,
-					mapping_min_folio_order(mapping));
-		if (!folio)
-			break;
-
-		ret = filemap_add_folio(mapping, folio, index + i, gfp_mask);
-		if (ret < 0) {
-			folio_put(folio);
-			if (ret == -ENOMEM)
+		order = ra_unbounded_order(index + i, nr_to_read - i,
+					   min_order, max_order);
+		for (;;) {
+			ret = ra_alloc_folio(ractl, index + i, mark, order,
+					     gfp_mask);
+			if (!ret || order == min_order)
 				break;
+			/*
+			 * -ENOMEM: memory is too fragmented for a folio this
+			 * large, or the memcg would not take it; don't ask
+			 * for that order again during this request.
+			 * -EEXIST: something already sits within the range
+			 * this folio would cover, but the index itself may
+			 * still be free in front of it.
+			 */
+			if (ret == -ENOMEM)
+				max_order = order - 1;
+			order--;
+		}
+		if (ret == -ENOMEM)
+			break;
+		if (ret) {
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
 			i = ractl->_index - index;
 			continue;
 		}
-		if (i == mark)
-			folio_set_readahead(folio);
-		ractl->_workingset |= folio_test_workingset(folio);
-		ractl->_nr_pages += min_nrpages;
-		i += min_nrpages;
+		i += 1UL << order;
 	}
 
 	/*
@@ -456,28 +505,6 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  * it approaches max_readahead.
  */
 
-static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
-		pgoff_t mark, unsigned int order, gfp_t gfp)
-{
-	int err;
-	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
-
-	if (!folio)
-		return -ENOMEM;
-	mark = round_down(mark, 1UL << order);
-	if (index == mark)
-		folio_set_readahead(folio);
-	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
-	if (err) {
-		folio_put(folio);
-		return err;
-	}
-
-	ractl->_nr_pages += 1UL << order;
-	ractl->_workingset |= folio_test_workingset(folio);
-	return 0;
-}
-
 void page_cache_ra_order(struct readahead_control *ractl,
 		struct file_ra_state *ra)
 {

base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.43.0


