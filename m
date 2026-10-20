Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F2A606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=j5/EAjpb
Received: by kanga.kvack.org (Postfix)
	id 8B0E86B056E; Tue, 20 Oct 2026 18:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862166B0570; Tue, 20 Oct 2026 18:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7299A6B0571; Tue, 20 Oct 2026 18:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3108D6B056E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94B681C2BA6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:57 +0000 (UTC)
X-FDA: 85344382914.12.D4026D3
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DBD3A0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="j5/EAjpb";
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf25.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUJUf2XHU25x2noX8Uf7Y4DKlKoCjH6yK/uRcd1adlc=;
	b=rIBWH5QXSlQ/HKJtdKj0bSpv+hmxYWLviUUy3x+fTNWwTWXwTIDTwJSBQaZvKAy5yPsKFu
	pvQPD9UyZ1xk42CnCVIQHZ7hX8gQ/Y8zwlsDbsZgMNsf/SysL2zR4bACYxVRZF6uOgQ9gy
	BVphERFKVJ3U9MuaWaNpUiK5k59tx28=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="j5/EAjpb";
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf25.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533835;
	b=zrF6XTutLvy8JaGLTdLwRhuCFNcaDt+14c4CBJ6oRSsnIyLpOR5D3JovNLNfp7AnALoiwW
	L+fRsjAdCS5c+UsvCoFWDRmop8MXi3YPVsx6vWSRLCEv4WlKRHR2KGXgDBp+x2kcetFKHF
	FmwjTmMYxChg+OAWlh1NY+DYhr9pGDU=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f259cdc86so8997485a.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533835; x=1793138635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fUJUf2XHU25x2noX8Uf7Y4DKlKoCjH6yK/uRcd1adlc=;
        b=j5/EAjpbsSMuNDCli7C7lqzD2zhacFZ//zFHnGOxyQ4o03E/95zp8Ez9tcngMAzVHF
         zH+jiTDb1o4AeLQIyRv0knPLDU6ZIqVaV+bPaPFTcoP4rpI6ALnFNAJdfinKbYrYTmdG
         o/CTXpESUu2PBfUzx0zIY6kJBA6tyIW4sIQpDFO0pN6TZdSXm7ZahJjjvhP0JiMzNcAW
         B6Y1V0tnn1zGx9Thgil3+6Zw+yHL/swaPkGVCpdyf3OkukknGbPeKHeWOf2hRTnaJWu6
         DMcrNbEC/xX/N2Feh1PCKo89xdK6JXN6vJSzQU+fl7gBnHb271WrPBUpgO7fd/69SkWN
         K1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533835; x=1793138635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fUJUf2XHU25x2noX8Uf7Y4DKlKoCjH6yK/uRcd1adlc=;
        b=PGnpJrTynT4/0SdMd4CaYWSi7Aq6dtl0rK8L+6lcPYQW8t7GcxhqZ9cWE6o9zu4YUD
         35DAUkYE6OpHiUXqoU2RVYsgyIdppZAG+y6ff5qb0mo0wt0WuxNbELjfK8PAQ1q/qtUP
         krMb1NaD9b5uwUs96I8iFuawX8CF3rn+aI6CscjOIr6ql9P4rjwTwP5w90mK4ta3uTxx
         8Snnr6ZJiMh4th7P0dYcE6jVMvpJeDcBnHiNjsQSeoIWDAOWBRSRWc/eB1RxgwWrvaop
         HEHyP07aiVC0vAHOksu6D2fyP5J35xLBaDidaaZpGvlV/brA7ydf2SYFwdWv7vk5Y/BR
         P2ow==
X-Forwarded-Encrypted: i=1; AKwUvBw0AsCCe8LKK36avaJ3nTra+znl2wtjdpu/pa2W9qqCYvJl5yFlpFWKrUAtAjRhkGZSpGHvw6/NFA==@kvack.org
X-Gm-Message-State: AFq9FYJVXvKH/AOoeVzmvEL9B+eQOhFE9Ju26NwazViZyQEm3mRi/+JQ
	zeS8nK+/yOIUKxhEMcWOnnvbfjki67hZk2+OF8wAuquKBPrhE2pSoLMirmScIPWkjkM=
X-Gm-Gg: AYBFou1uv8UNQeF1sePNm3gSnzjgWyY9ULqlXZpM2zN7WmWhm7N9JVXH6hRp5z4ok2l
	GVviSAfecXClk9ypzWmoFGYobiRXoqZ7zmmLvqVfjLtk1tL8nUdD9Zg/vj7dd40o4QlVrFO7lDm
	rQmt+uKWXm4gx9obHLo6mgmkTtlyU39PVJBwWDRFdU8cAIo9ncPvlxMH7s/Q1ER7r7y8GNVpAwo
	P9MoLh42etS95nf5HuooENo0lw+hsUSEFUHhLJCzIGNUs5pFi/6sCY7+D2odNK5Ye1Vcvvq0iuy
	aFlHfI/wCEwd5dGBaBNEYUghbUI/KgDRpqORHEg/9IXNM9Y7Gz2gtvIkBQZOuUgNyCdMYVew/Xx
	NrLwNFEYYLAt2kXc1saGF0eiAwWLQ6nctNK7qLdsZtbV36AxuJ2FV0TJnMbkikbpomTCSl2+lIM
	MlCULURdLGreOp06IfIphE6KHZej1DaPNlItA2LQVcUBZ51AhQ1uKmGNbnfxxCv20WEopOIzFkB
	8cDU+OMSbI5eKTnG/PifcEMGIxuGqPX/Eom36fjdBMf9uBHYpggOj6ebaAVgNVItou7hiR2zQ==
X-Received: by 2002:a05:620a:4544:b0:93c:b6db:8c with SMTP id af79cd13be357-93f57dbe877mr120645885a.0.1792533834228;
        Tue, 20 Oct 2026 15:03:54 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d98577sm88755085a.9.2026.10.20.15.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:53 -0700 (PDT)
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
Subject: [PATCH v7 4/5] mm, iomap: let an uncached writer complete its shared pages itself
Date: Tue, 20 Oct 2026 18:03:45 -0400
Message-ID: <20261020220346.28020-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261020220346.28020-1-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DBD3A0005
X-Stat-Signature: y371ut9xhpt3gs8rrtnuokjaweznnrkt
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792533835-849792
X-HE-Meta: U2FsdGVkX18I9flXcqdW3Qbp+mu202ZM/ex50s1s/zcvcW9U2rcs3f1IMqCGnB7hd0CojK5XMg1Nvc9ftiJdNYtMHDtkIM4pUxYwpu0tcyfpMZReXUWjQA0E2Yy4lFHCkhx4ZHAfs4s9umJLz8seU2D2w2N5UBmEDN7Wge8leQr1KxTnXr0tZDEbpdNdqwyzXm0sMt5INAXSUHSQzdd8NSDdoIOJQ3kFQ4ktEZRCZeOO1K18IlRKCe7uTuWD1jK1BBsv10XvJ/qrfu3yy/fzmG4YPVIHfVxCzWwEUGZY4W+Wmrfh+HItdxfz5Eiz0zutZmV2ffGkXGsgdUs+whOWzFocXvyVUosAHn9SxCFC4Z3jzdlPRxsQtKsfo0Nl0007XbUFf4Lx0/4wlx7AabvC7t8qbnO2hPwZTo/bXcNpcOyTtpRvjptr9kjcEQIMyMTbcLMfHpgaMCOvFRXRlSec6bzO3cDkBZ5KlD4mW8Rn7ogSNK+smnxkcW6dN93p2/zEdIkb9lbbSKx2ZtEgX0TP96t0buNnekD1twVhgEw8vR87kLixHg5SptyKHLJwjEhcS3ZKnwl8QK8bwUVTZ7da8JW3N2WPc5a9TKKXtF+ngtSsp6JjQpondyEAuraAMe4rGk5BA68uRpKNK7nAkTHHe4VGjfaiwah1xYYSk+wdkyp5HLhvhEHXl5Q/BuEBKz94e71q2ZNNWcylCUc9A0IH5kVCo3SZ9lto4s31SP39tNtmDJrd27M5WY8F+TiXLFxYJn6o33959SRQ0KiadsyJCW+JRUtSyOrfQHfaonOzjBo5TattTij6vjfowWEhSDIQQZcgwHfzA/mHcFY3dHHKr8QqzfgKkKTk5Hb6yYtm5VGS4lZmBUCd5M8n+VsoejskupupbVUud3exHTgIIQK0f4gOnKO2yTDaGCEcGBVCVLpJQ7Noco4pOV4k1qe3iGy5dAM63cB0Z+VoH5Z3tXp
 VDNvKjdJ
 6/fgkwyJPBRqcRebF/6nNhBzL/8PPw6a7kKh0uloOZ5uwm3G7LNDiOHPAreAg1h1W+4jlir5MzbK7p6N7LI0cxRmsTo39jrYPAxeyd+4/LGN2IJVVPifnAPNvT25ejPrsIQThQGEYxb7IsSepRAWUo+nQ8F4f5zJcifcdVozAsXZeUXlxkoDOh2WLZgFIWRgHApGgOOL0dJ+ni77Om4iUtEFqtqtpy4ScqE2ecpqnAhCKV3zMhHY3kZMxWSOtrtdpwuTnkXNbjIIvLDXXvWFAO7FCzPznhrDcJZeTCK01P21MLp+L4Z6yvhreX/rCspbxuweKBi3f7BIdgnYlS7QLnaxCFh4Zn8jOzfGx4mkFBMhtE85ZRJDigSrR+LSFvbWP8W2NvQU/SLVsFkZi/j/5WwMsguRB1OgvZMpTRATHGUiYlMt/DJjhBoOlw49t63oDkFueRTHejc4d6nEuub4RLh295zWsyrJLmYCesah5AGElfaBn+FjUao5D08XGDcPmaJ85ElGWjlVnrYAFCKH+ntNE+R1rejgdve35y4OOmg2A+JSO5DlvO51hpijVpnNqpcIlQNUbp9+L+PIAYLGYoi3gbPP7qT97QjL0HuQQrHEloPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The write that completes a page an uncached write covers only partly
marks it drop-behind as it writes, while the page is dirty, so the page
counts as DONTCACHE dirty and the DONTCACHE writeback kick writes it
back.  A writer that syncs its write itself, once, after several
segments -- NFSD answering a stable WRITE, the NFS client's LOCALIO path
-- issues each segment without IOCB_DSYNC, so every segment's kick
writes back pages its own sync is about to write.  Measured with NFSD
DIRECT and 32 writers of 47008-byte records: with the previous patch
alone, 23,000 to 65,000 kick rounds a run, where NFSD marking the pages
itself after its sync had taken 51 to 274; with this patch and NFSD
using it, a FILE_SYNC WRITE wakes the kick not at all.

Let such a writer complete those pages itself.  IOCB_DONTCACHE_DEFER
(IOMAP_DONTCACHE_DEFER, FGP_DONTCACHE_DEFER) leaves a partly covered page
unmarked even when the write finds it uptodate.  Right before writing such
a page the writer asks filemap_dontcache_edge_completes() whether it is
uptodate already, which means the neighbouring write has written its part
and this write completes it; once the write and its sync are done,
filemap_dontcache_edge_complete() marks it and, clean, drops it at once.

Two writes that arrive together may both find the page absent before
either has written; that page is then left cached until reclaim, which
the folio-lock ordering of the default path avoids.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  |  4 +++
 fs/iomap/trace.h        |  3 ++-
 include/linux/fs.h      |  8 +++++-
 include/linux/iomap.h   |  1 +
 include/linux/pagemap.h |  6 +++++
 mm/filemap.c            | 58 ++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 780a0186045d..5ca82000e2ec 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -811,6 +811,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		 */
 		if (offset_in_page(pos) || len < PAGE_SIZE) {
 			fgp |= FGP_DONTCACHE_EDGE;
+			if (iter->flags & IOMAP_DONTCACHE_DEFER)
+				fgp |= FGP_DONTCACHE_DEFER;
 			len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
 		}
 	}
@@ -1318,6 +1320,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
 		iter.flags |= IOMAP_DONTCACHE;
+	if (iocb->ki_flags & IOCB_DONTCACHE_DEFER)
+		iter.flags |= IOMAP_DONTCACHE_DEFER;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_write_iter(&iter, i, write_ops);
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47..4f0343eeed1b 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -104,7 +104,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
 	{ IOMAP_UNSHARE,	"UNSHARE" }, \
 	{ IOMAP_DAX,		"DAX" }, \
 	{ IOMAP_ATOMIC,		"ATOMIC" }, \
-	{ IOMAP_DONTCACHE,	"DONTCACHE" }
+	{ IOMAP_DONTCACHE,	"DONTCACHE" }, \
+	{ IOMAP_DONTCACHE_DEFER, "DONTCACHE_DEFER" }
 
 #define IOMAP_F_FLAGS_STRINGS \
 	{ IOMAP_F_NEW,		"NEW" }, \
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..ad181b6ce6b4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -357,6 +357,11 @@ struct readahead_control;
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 22)
 #define IOCB_HAS_METADATA	(1 << 23)
+/*
+ * With IOCB_DONTCACHE: the caller completes the pages the write covers only
+ * partly itself, see filemap_dontcache_edge_complete().
+ */
+#define IOCB_DONTCACHE_DEFER	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -374,7 +379,8 @@ struct readahead_control;
 	{ IOCB_NOIO,		"NOIO" }, \
 	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
-	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
+	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }, \
+	{ IOCB_DONTCACHE_DEFER,	"DONTCACHE_DEFER" }
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..f3509d495a92 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,6 +212,7 @@ struct iomap_write_ops {
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
+#define IOMAP_DONTCACHE_DEFER	(1 << 11) /* see IOCB_DONTCACHE_DEFER */
 
 /*
  * Return the existing mapping at pos, or reserve space starting at pos for up
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0c1d6bd09aa0..a0a67e4c940b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -705,6 +705,9 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  *   only partly, and a neighbouring write may complete it.  A folio created
  *   for it is not marked drop-behind; a folio found uptodate is, as the
  *   write that completes it.
+ * * %FGP_DONTCACHE_DEFER - With %FGP_DONTCACHE_EDGE: the caller completes the
+ *   page itself (filemap_dontcache_edge_complete()), so a folio found uptodate
+ *   is not marked either.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -720,6 +723,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
 #define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
+#define FGP_DONTCACHE_DEFER	((__force fgf_t)0x00000400)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1316,6 +1320,8 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_mark_dropbehind(struct folio *folio);
+bool filemap_dontcache_edge_completes(struct address_space *mapping, loff_t pos);
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 0397ec771547..7d7c56a42643 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1675,6 +1675,61 @@ void folio_mark_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
 
+/**
+ * filemap_dontcache_edge_completes - will this write complete a shared page?
+ * @mapping: the file's mapping
+ * @pos: any byte offset within the page
+ *
+ * For an uncached writer that completes the pages it covers only partly
+ * itself (IOCB_DONTCACHE_DEFER).  Call right before writing such a page: it
+ * is in the page cache and uptodate when the neighbouring write has already
+ * written its part, and this write then completes it.  Two writes that
+ * arrive together may both find it absent; the page is then left cached,
+ * unmarked, until reclaim.
+ *
+ * Return: true if the caller is to call filemap_dontcache_edge_complete()
+ * once its write, including any sync of it, is done.
+ */
+bool filemap_dontcache_edge_completes(struct address_space *mapping, loff_t pos)
+{
+	struct folio *folio;
+	bool ret;
+
+	/* FGP_DONTCACHE: a plain lookup would clear a drop-behind mark. */
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return false;
+	ret = folio_test_uptodate(folio);
+	folio_put(folio);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_edge_completes);
+
+/**
+ * filemap_dontcache_edge_complete - drop a shared page both writes have written
+ * @mapping: the file's mapping
+ * @pos: any byte offset within the page
+ *
+ * Mark the page drop-behind.  If it is already written back, drop it now;
+ * otherwise the writeback that cleans it drops it.  A dirty page marked here
+ * counts as DONTCACHE dirty and wakes the DONTCACHE writeback kick, so a
+ * caller that syncs its write calls this after the sync.
+ */
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos)
+{
+	struct folio *folio;
+
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
+				    FGP_LOCK | FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return;
+	folio_mark_dropbehind(folio);
+	folio_unlock(folio);
+	folio_end_dropbehind(folio);
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_edge_complete);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -2024,7 +2079,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	 * folio lock, so the writeback that cleans both writes' data drops it.
 	 */
 	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
-	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio))
+	    !(fgp_flags & FGP_DONTCACHE_DEFER) && (fgp_flags & FGP_LOCK) &&
+	    folio_test_uptodate(folio))
 		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
-- 
2.52.0


