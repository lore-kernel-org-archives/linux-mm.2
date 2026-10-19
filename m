Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7934F6084858
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9CLWqxz
Received: by kanga.kvack.org (Postfix)
	id 358EB6B02A2; Mon, 19 Oct 2026 11:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3416B02A3; Mon, 19 Oct 2026 11:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D19C6B02A4; Mon, 19 Oct 2026 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E18746B02A2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:07:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6063A80720
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:34 +0000 (UTC)
X-FDA: 85339704828.23.3768B79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A94882000E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9CLWqxz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAW+AstcWY6xdbUMT8c6ejV79mSagbIvsiRflolJ1vg=;
	b=XXQOOJXTFKmRqtwWlWA9w4G9Xf+ekzrG5+AnooJyHZysu08un+1wrLJdOklFeYSyvYCJVU
	VN9AA7rnvYuS4xYZDdHJQOQ61RNWk5FHxIqUuKUorAbqnDHyGgxWS7VeTOV0ElqFsvtTyl
	DFZLymn3bI3vFnyr0l6pFshkY8K4Lfk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9CLWqxz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422452;
	b=oqobkgWG8qQwSqSHl59CjoNLvHMt4f85WGZ3PM9cmSEuqCZ3YcOo/ygIqHapePQYXaDmiQ
	EfGbnxxtLV9gdyk/9071HN2tOP9ri83pT2rYHCDC7nGRk8WQoQ8oqyAlBEqE12IzOkyO6U
	wQjRGQzEjvvqBneA/6kUiC1NXmIEHSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C7436021A;
	Mon, 19 Oct 2026 15:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14DE1F000C4;
	Mon, 19 Oct 2026 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422451;
	bh=XAW+AstcWY6xdbUMT8c6ejV79mSagbIvsiRflolJ1vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9CLWqxzzRjvfuihRqvaLRG+rbfVKJu2ObMot/c0U3Lo0hdtcwZNtfKO29/O2Bu/b
	 videMyr2SxDpPaQyRShXtzk1ZPsoo0UILYTwfkx/cpPLi4AMu2+9HDhiXC0GdvyLgM
	 wP0Z4ThjZPKUDicGiqUKq8nuv3t0LGi90/YoSZTOgjOju/GO3HnER5M/jbUYL2x0lp
	 dgQLxiefE80zbHvh8k5gOkT00LVb01Y2HW2zNWB0opiTQdboTU9ZofIQ3Pz4LvyyFe
	 pC0mYnJii/23DUipruQXPnjK6FEYC6ZGbE9/dWwkK7bHL8hTBYvqTuKalRTsv5lJiy
	 IxveDDQCRuqMA==
From: Mike Snitzer <snitzer@kernel.org>
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 4/6] mm, iomap: keep a partly covered page until an uncached write completes it
Date: Mon, 19 Oct 2026 11:07:23 -0400
Message-ID: <20261019150725.1507-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261019150725.1507-1-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A94882000E
X-Stat-Signature: k13ig5kzafuik3894odtmtj1rxae8ftr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792422452-25564
X-HE-Meta: U2FsdGVkX194ychDOONwDbZGYQ68mQ70D6qEcxj7ynJAhSn24I/Hr8it0x65AxnSNv4h92QzDYIVtl6wKiaKOmKidQfIdsObMsyxLxpRXJqxLygqaii4CERXWaBg14Rl4fINma+AHHhErcxThx46HzxR3VUSsANU8in/i7VEBMira0eeUWyUJVw/b9Pazkr4fMZDy3VoXdMcv2aASPvtI1/glrInwEte+Pqa1Usyh+jWWmPNhzWBFkW9DeuzljLshyCozila1befZP6huYxPyP0BazqPetDSvvqL0VWW88CUuGggsMSh1pmaDf2n0K4LsKhPzcskvBDaN0Op31qomarwS9UFXArEfzZFAMFeg5+VSKHzQuex1OigAA1yPSNoePa3xbKYtk4a2bQ4K7MX1PPCr4flcdygiG/+wR9VdE8X4jxW8CyTefBv6NkG1ZuSqHYvy7Zbc9llBck1UTjisjjFAyF9dz6ESj6XoP98vWco2CApHaace2Lv3SyYJf0T0o7r++Fo52XG+O5KzmbsBfj+2vUUIuSXYdQkRzgWc6Sk0OaCqoBm+LWEI+NhkHzXRP9eJ/0fCtCx2f12zE9N/1FoldmlvnUMe7OLmXXPZKYIM4oVm+gRrX/H6g2BTslDqnvnr2r98y6yYKIj73Go+5JBCa9GSpiZYXufqiGRkQCooQd7OIBUoMhVKivC7ufwF5ElDtTpY2t22m5kOIqlN7PudN0DshMehZAF3rEmxBjGNtqxjZc5DUwQ0hdiuxXn0gdKr7dTn8+9g07NGOVetxZVIYeAJ4lR174MfMC8d3LR13ZI/wtXg06fsq2gWx0m5hIPv3Xp7/n+c1vCxOBbZCqtf90AfsndlBRQuLqXAtlmzxFjzIVlrPcYZ7vDWWhdWkpf5138/VhEExqijAoJuaRie9SEQFcLu7/GUoQraNqyaILxE8DfgDCKNXVsicQQ4B/fi6y3btgKOL0CJGg
 OU4VIDQM
 GlMmEw1GkPgTl2qam48Td0onlsn6ubslZcL05IOq0AzeN8BBvq04odjRHCC0Zit6/c4BkkfX96wCAbwVeErv+ZzBwg5z9pV5H7MgYAxXx+DUELY/2ecl9wcm6Q/lRbtTgibhqyOSqxgcEiHLzMchrOQER0XXQheYMm2QqxisOCKzr458BG+bs42COp30LyOWGG5CW0dyNqK2HxljqT/9TZS2y9AwCDyw6v+ghOF/kHptuj9XPGByTHiTuYL+PgJs0y3DTLsjHVMBqUGbDS7lpAFrYLZFzD3ZOb+V23jutkocUJt1nCU7EdLxRtQ==
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


