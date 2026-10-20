Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77F2606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=V1cETtN/
Received: by kanga.kvack.org (Postfix)
	id 4B8FD6B056C; Tue, 20 Oct 2026 18:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A196B056E; Tue, 20 Oct 2026 18:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BB36B056F; Tue, 20 Oct 2026 18:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAD6D6B056C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2265A1A0376
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:56 +0000 (UTC)
X-FDA: 85344382872.08.D314993
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 349A41C0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="V1cETtN/";
	spf=pass (imf21.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533834;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAW+AstcWY6xdbUMT8c6ejV79mSagbIvsiRflolJ1vg=;
	b=ohK26jfUE6AlFqIxyKp6F1mgBPo7gisw6a7RwSqJB5r0vSFOHbbUXG7UtivV+85Z9gkdd9
	fXwhvVxGwgIPckCbpW0wAdHUa8RkikICdvKUuLBfbsu1+MAK81G0jrhQc3Tgg5BnuPnQIV
	KaVyj8bXtXU7vEFvijg4VU6MTkzRNHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533834;
	b=ZGA/e15geOdwX0mxCZo1wBF/yIBdOSrLK4lYjih8CyMPA30AQ7Ig/IUxT/mPolQi8TMshs
	+YsZe7uc1Wmh+imXCJyO7HNQZRfojkRL73o4BOo/N+LmPjVga42/xHsFBP5XSbyAJHnLTs
	jDKMjqCxbOFoA2zkH8uZrH2RhMQuYjY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="V1cETtN/";
	spf=pass (imf21.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9178d514951so1254736d6.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533833; x=1793138633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XAW+AstcWY6xdbUMT8c6ejV79mSagbIvsiRflolJ1vg=;
        b=V1cETtN/o7KiAiX1MRQU1mJVVjIYemvXl+Ir8+ZvOHAjQ+OLH5J5n2wF1Xej1Glxr8
         bSl6sFtHciopRrgGUqhihoDcwSulw8/ddQpXa6sby19UwPiPo0geL5xEepsemBZTNCjw
         d66IUJ2i3pErhJoTO+9ziZOHo1w1JrlKGblskwjHK5nci+Mm1T3NfjR5qskAOdoKUId0
         eK1ozwmJCjhrosoju2AYAJch9DOs2RCEXu1Itt3fjWm4u9d8DAsXSy9zFmmuFwj6ttzl
         otjobJXmUCIwQGv8L+pBg8SciRt1YefhESbzrz7oYXJHHHci7uTrcTO7Ue11j3t7Pqzg
         VJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533833; x=1793138633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XAW+AstcWY6xdbUMT8c6ejV79mSagbIvsiRflolJ1vg=;
        b=fHErY4SkKga/lTuh09D4YR3GY8pqE83U2S4GfXZtQcQ9TQojRi2W1aFHIjgHSoUAa+
         9PhW7kxIrf3j/clCV/8SPO8LwPZ2/CkxUZ2ovrSx+XgWnhFV/YqKAKhJ7OmkL4JhUACG
         B/FZqnJVCSv6v8YqRViMK7n2MJCpWaFcb2ZOmuROTvE7kTK/Q4Hh0NUf782UY9fsG1dt
         OF+oOmQNE7DwbPooNYY2JnOgUFOZ45dS+VT5M+sDQ+GsdvKN+bfiHz6Zxs8dFrJgVybD
         aTUOBwN29OTxAHO6lCn7eds4lAOU1pv9qNnOqijQyVreYg3rdX7WYxnA3OG3KIi7tXdX
         3zpg==
X-Forwarded-Encrypted: i=1; AKwUvBxcKCxhuf9KJOyaGHevDE43+qk6o9dp70yuLHPR0Ftk4TgR/8RtT8tNsV8AJWKCMcpbktqX978o4g==@kvack.org
X-Gm-Message-State: AFq9FYL0Bbfqb2WGiG3FmKtYP6z+cDLBwwFRGXfvDzb9es+ZZDWc+N5x
	0MlfYzCdIDQkWu/fkaWjAksRiYO/ttQ3PiZ1h71dhMGUJAv/nug1DV0mhLbpJlkAicM=
X-Gm-Gg: AYBFou3AXuoW+6Wo9bcfk6+pEY1IB9UGXjhHRwZl86xx1/9CKp5z1SAwxNoP/DA/3Ym
	/9DN0/PhE8D3WcmKjLrPLFq3Ok+CA5k1lNYh50uGSAtbDCDt3YzHIyD99lGO4fUntzs7DRX8gS8
	DERntxseSyNeXlhfZDZ3nHWZ3UJ/FNx3RMl1OXJDR989E1QoamRY1szmiYMVJwMEj+9jTuUBmtC
	aO4M3ed/mDkkdYb96HBWKVpCurBaU7qime5ZssdmwmKcqYdQ4YjQiImEkSurwhedR51dco1bp/3
	afFzuHHWh3ii5WFJJegmJchtmNyVyRr65KjWuzBKoHlZodSLHMqN6iVovdYDADu8AR59586pTPu
	DDqOXncMkCnw4MZUNsvJRsy1uRc8zK4o3Wj4A6OKXkitpXbMOcZJAj9WX/RFFIShRA30PsyKfNZ
	jZ72X08cP9/iPvmXw1f+mWr+c/gbDRwuSnpN+vDHKayPxV9nlqzfNQL6c+Tib4IJSws9xo1pcCO
	yIg0xWik5E46XV3hIgO286ncLJyD4KgKzicq/z5cta9x/M/0gbi5Uv8RO19MmTBi0zOW2AnSA==
X-Received: by 2002:a05:6214:3c86:b0:91b:5d3a:5105 with SMTP id 6a1803df08f44-91c12f580cemr2460656d6.51.1792533833063;
        Tue, 20 Oct 2026 15:03:53 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10bd5d8csm8763286d6.24.2026.10.20.15.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:52 -0700 (PDT)
From: Mike Snitzer <snitzer@hammerspace.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v7 3/5] mm, iomap: keep a partly covered page until an uncached write completes it
Date: Tue, 20 Oct 2026 18:03:44 -0400
Message-ID: <20261020220346.28020-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261020220346.28020-1-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 349A41C0007
X-Stat-Signature: 1ypxjusfr9fq1whqho5rpxky88kz6z5u
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792533834-851841
X-HE-Meta: U2FsdGVkX18NMyNdUR9/sainTxt0j48UotzgkdX3887KCXibBf4a9PfJo0hvqfkgm6/us58Pwy7u82M/7VXzxv1XXWB+a9m0KAOsG1UqLhILeVEX3A+RvF33CysP7SL7qQcDnom1eBPJCNvvi+NTqR60kRItQ+GLLnjgI3RN5l1qwq3TjBoam8+aOxypT0tjKIN13R5i3hfD4BRtrK+7psZqIpzwJy+eVdZPp+/9TvZvfAJ2ylxHLIBi1sj5NdoVhlrRmxt6Tc16nMNP0GiT2udYQo96KUzNsMA9nMksn9B9tH+KuUHy9c9W7XoRwbrWqZQ5F+D1Y7g5GCqw5C5CiZvbKcOaEJikIlb3qhMZGs6/XMle2O+l1gpCkVzEskCQATwqQ0wZMJlhTIUwRddr62KxxpjYINM3BVMIpjgiBP0IhIFUK7e6EmVu/l6zVQ6TRbmPk6yGDSBPlE4p7sQb3AASTt5yQmpmfy4vVttYq17DO3nT4BZJ4ScvueUiNnSBiHzSiywseaJFb3V4DYX1jWdNIvJAJ8Hqe66D1I4joZFzPX7onUXat19mXzsG8K4aFHvRoV+LTAtZ2O4Bk+LVyGBaTi3y2vQcpI8yFS7f8zAraKgFAXztvwosjfJJVHRRUEOU0zCPYVYQ84Q8/+qzFM1iqYUvmUWpKLx3ZEknqkGUZj6LF5aZEYBAZZO/LhgmeTkGJGvfjcw76N2WHbcCnff8n1QE1un8KAfkHrs+bR6NLNL6JyXdDgpUpLzq4nTmXgpf+5CERCu5lVQ0G/x1WBVXCzY/YNMQALCJGuynttYGwTo5OhMkMJZYdiag01fZtBDpF0Fkejj5EEaAzmuLJshewfJEOamAfQO7L+a1JhyM420XN+o6Hg6vwyLIViz4HiEJVz8gHgsl4YS02n8tJDkXhzz22F4oIRp4rfYxuQepwDlqZMY6RF4AjyVQeqk8tI4xxYX2qaCPhR0UF6t
 GvbvINYk
 WXdbPY38SWya9/Ns3QUwOyC0eCvenlnFnxKIHaqm0tM5jPUMd+EaYzG4qaS+Cp1H1Rfovt68VaG/8rdqf2esT+QFrpi8gR02fXVztZA4PLGhh0bPvEe/A6T6T6Bawd516IB9s4UtGN52RbxTAmH/VJNBuVRwgpKsnsTNNP4hpEmBNsZcycr/NW1wtgYzqD9tnGbKOu6mO9bvvVFaxg/E53PFv0LCF/IiZR/5SZBmnOefwSuQWHhyMXeJ3uWPtAzH0P8DHZEpqw5dhntV5SOm9SLl4qLaazyKTPIHAWeEHQkrf+XG0XUVuG+ADSJ6NnAbMAd5InjTWE2V/+4nDOc6fmwdGD6PDyCrXIjECT4K3ngKSNl3U2bvBQENr6gNyNIm+OtV2bFCt9RpAVRpLbIxnisEAIgGhkK21+4JW3Fm0ZxKswkMry1tJrFY8VV0H5TqWCDd6FMtorHa02Cw9+wN0xeV7GwfkRY4l7PGXoZPCbBMl1jNEB1zp6VNA0ISjvcR6Kdr5+STkz/k47RYIhVNHLGryAl45lfYxs3SizAnR4C1VHFZMBue4tJkVUoxuVwbJrPlNFw37yjqiu1XwiMNIcK3WkbLizIPEP1vzcEIOr8eEx2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An uncached (RWF_DONTCACHE) buffered write marks drop-behind every folio
it creates, so writeback drops each one as soon as this write's data is
on disk.  A page the write covers only partly is usually shared with the
neighbouring write, the one that ends or starts in it.  Once the first
of the two has been written back, the page is gone, and the second has
to read the block back from disk before it can write its part: one read
per misaligned write.

Measured locally on XFS (emulated 4Kn NVMe, 4 KiB pages), 32 threads
writing interleaved records to one file with pwritev2(), 1 GiB per run,
before and after this patch:

  record  flags                     4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.000     831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.000     601     1227
  6000    RWF_DONTCACHE             0.97     0.000     121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.000      90      206

Before this patch every write waited for its read, and because XFS holds
its IOLOCK exclusively across a buffered write, the other 31 writers
waited too: both record sizes ran at about 20 thousand writes a second,
one device read per write; after it nothing is read back.  With
RWF_DSYNC each write still waits for its own sync, so the gain is
smaller: the uncached write now runs as fast as the same write without
RWF_DONTCACHE, 1237 and 209 MiB/s against 1227 and 206 in the table.
Records of 49152 bytes, which cover only whole pages, read nothing
before or after.

NFSD DIRECT issues the misaligned ends of a WRITE as buffered uncached
segments and gains the same way.  Without any handling of the shared
page, 32 interleaved writers of 47008-byte records read 45144 blocks
for 45664 WRITEs; with this patch, and no NFSD code for the shared page,
0.0001 to 0.0008 blocks per WRITE whether each record is sent as one
FILE_SYNC WRITE, as two one after the other, as two together, or as two
UNSTABLE.  The page cache then marks the completed page while it is
still dirty, so each segment of a stable WRITE wakes the DONTCACHE
writeback kick (23 to 65 thousand rounds a run); the next two patches
let NFSD mark it after its sync instead.

Let the write path say which pages a write covers only partly
(FGP_DONTCACHE_EDGE, set by iomap when the write starts inside a page or
ends before its end) and get such a page as a single page.  A folio
created for it is not marked, so writing back this write's part does not
drop it.  A folio found uptodate is the neighbour's, already written:
this write completes it, so mark it, under the folio lock and before its
own data goes in, and the writeback that cleans both writes' data drops
it.  The folio lock orders the two writes, so the second always finds
the first's data in place.

A page whose neighbour never writes, such as the last page of a file,
stays cached until reclaim.  A partly covered page another task had
cached and that is uptodate is now dropped after the write's writeback,
where before an uncached write never dropped a page it did not create.

Only iomap file systems say which pages a write covers partly so far;
write_begin_get_folio() users such as ext4 and the NFS client do not.
With blocks smaller than a page, a write that crosses an extent boundary
inside a page asks for it as two partly covered halves, so the page,
though one write covers it whole, stays cached until reclaim.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  | 12 +++++++++++-
 include/linux/pagemap.h |  5 +++++
 mm/filemap.c            | 19 ++++++++++++++++++-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..780a0186045d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -802,8 +802,18 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
-	if (iter->flags & IOMAP_DONTCACHE)
+	if (iter->flags & IOMAP_DONTCACHE) {
 		fgp |= FGP_DONTCACHE;
+		/*
+		 * A page this write covers only partly is shared with a
+		 * neighbouring write: get it as a single page, which is
+		 * kept until the write that completes it.
+		 */
+		if (offset_in_page(pos) || len < PAGE_SIZE) {
+			fgp |= FGP_DONTCACHE_EDGE;
+			len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
+		}
+	}
 	fgp |= fgf_set_order(len);
 
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3012bd95812a..0c1d6bd09aa0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -701,6 +701,10 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
+ * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers this page
+ *   only partly, and a neighbouring write may complete it.  A folio created
+ *   for it is not marked drop-behind; a folio found uptodate is, as the
+ *   write that completes it.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -715,6 +719,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index ed7e4dbea653..0397ec771547 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2016,6 +2016,16 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 	if (fgp_flags & FGP_STABLE)
 		folio_wait_stable(folio);
+
+	/*
+	 * An uncached write that covers this folio only partly, finding it
+	 * uptodate, is the write that completes it: the neighbouring write
+	 * that left it here has written its part.  Mark it now, under the
+	 * folio lock, so the writeback that cleans both writes' data drops it.
+	 */
+	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
+	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio))
+		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
@@ -2053,7 +2063,14 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
-			if (fgp_flags & FGP_DONTCACHE)
+			/*
+			 * A folio the write covers only partly is left
+			 * unmarked, so that writing back this write's part
+			 * does not drop it before a neighbouring write has
+			 * written the rest.
+			 */
+			if ((fgp_flags & FGP_DONTCACHE) &&
+			    !(fgp_flags & FGP_DONTCACHE_EDGE))
 				__folio_set_dropbehind(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
-- 
2.52.0


