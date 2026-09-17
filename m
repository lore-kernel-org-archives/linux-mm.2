Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08382C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA2D6B009B; Thu, 17 Sep 2026 11:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A286B009D; Thu, 17 Sep 2026 11:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7144B6B009E; Thu, 17 Sep 2026 11:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5EA6B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:30:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2B8B1403C5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:48 +0000 (UTC)
X-FDA: 85223641776.18.35B33E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D873820010
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iQDA90xp;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659047;
	b=nglH4t3XnYHLiKEF97QETy0YotR+35g5RJoR6V0v68fRzjePHvMVd9EvuxOeILwW+kZuBe
	vCe1I+feGtF1zEHYgNQ6sTqujeI21UYpLVco5nthnL9ITcqVVRi37/brbMiv1gZxHjkUoh
	Osb9mfpoWPRZZP+50C2zIeWcK7Vlrfg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iQDA90xp;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fLK7XjatI06hcjpyIEYmuQxh2KfI18xNUyIIl0+iuQ=;
	b=wtmzzX+tJ2ajasx1IzFyYTYVSf17cLSPSPt0oh9/fHC3sSY0oY7y+6gBOwUKklTS//hsMi
	OatwZTcj1tvGlWHG5zBgUic13kBqqKB0IObb2/LbPO4mW1J1d1CLtv46To5RdJb8Jcc/hR
	TSh8F1APRZ1+44bENdQnV8kZxmIcNRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6361260214;
	Thu, 17 Sep 2026 15:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945901F000FF;
	Thu, 17 Sep 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659046;
	bh=0fLK7XjatI06hcjpyIEYmuQxh2KfI18xNUyIIl0+iuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQDA90xphzTA0s0KCUFq76VSjKbgEwi1oyXMSxJpR+L0gzll4HRvCmL8I9BjI09+L
	 jCvs9VjXgm+xAy1OJfPSVFkdJlisk8Wdtz7JidGRQmHdT+vFIDHF7OAUkjjZqDuUpt
	 YSdU1Plqez0Ma5D1lmxeEPRBHqhJ1Mv29xlOAmck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 086/733] netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
Date: Thu, 17 Sep 2026 16:06:34 +0100
Message-ID: <20260917151353.047219849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D873820010
X-Stat-Signature: tz4g15wtt7wfqengsc4z4dtahtja3rhy
X-Rspam-User: 
X-HE-Tag: 1789659046-670730
X-HE-Meta: U2FsdGVkX18nEqKo8rzaz1TxvS8PgNNeUyrpHncwadVclRgeYiNbeUkUMIA7UEdq/yjrqZ/KAhuDx5fAb7+SU7qUddQgNIA2CV5uL3cg2vysi7c5ZLoKa8F87hAHlKzVowAIxJPbTPfaK9H428x7GOVmAWFtnYj6r2zPffdeKrNY2U5UyQQRMzfWHZomtxQoIQfcSZsDliqPA82SV77REuTaJpUsxH+mWpOxBfdt8YtD32BuP2XYsaV/gspduEkzSMJSo7rFYzAkRI53lya5YIF10capbNo9OEHgj4Fw2fD90C/bw+KJhP0zURsAMLP893SpbPvSFs+GaeQD21PPDoJG7HEfs7lHFnIwLT0Ii1Vt5CIUJ6qH+5ks+RNlyCXS8kj2DYbly36Smth4Rw5bCERqmpCZvoR7t0KnWV/OR2rslceUT1PRyWoC+F6zaU1C6TC2z1L37Qjb6JI++Lb5wUrZ73THF48Y9SwRtgsZ/ljqJEF12PIsDfCw7IcpzDZg5O9zAtB1Cvoc1t858weYiCj/qS3qev/EPjj6yK+JdNj1y/rJZqOOIPwiY1bbMTcU2rHPebyPa447tceaMrOAmWbWN6VXWNt/7bAgQfuvnLS6b9mCmdJR7x+AExzLQt3qU1a8SSGvxeLEW8V1zGhbADDoZxVCja9gA8Fphi4905RslfSVJvPnn1Enj1CfQAve6kOQ9lN3JgtiAFvlJdlVpm+ehfOyCXzsMJIMfBknfPZM197WWQsFQdqmSVSN9guM4Ek6WkkgAYkyuPL6CLLSDbhO9omwF0EXOkfxqvujrJw+D3UCQABCQl5Bi3Oc1oAZZfFURKz9OgrF9IvGk29RegGQ32L68mJBQtWv8OtDiBNaOAGM+8QicDgXwXxL4yBfaPU+qfOx+z91uT3HwBxtZeBSSfSKPNZHfTDnxM54DA2Wa1Er6sgTjw04MX2mTtPDTCqLBjGHdb70+GKM5u9
 tcatFoOk
 GMSc6vffv1UjnAx5bSJdYxymyStlJqqVQ+c93iOkhlKMgb8x1hrQcJyjs1leyFXuWXx0L17LKKFojczRQg5KQEFcYRoLloAW5f2CyCsLVWRoPbEmIejC4qzGTnSuji5BbrZxXZ14KZGM6l58Y3JjQOZEB36dUPpKfw05gEuyj0ASRY5/PaLQdzhVXs8skY0ffnnikKYn6G/W2qmpV2riKrXn11vezUAzLgwjxnRLkUTt/fxgJz4DLiVA3sZ3wP5gVyPEWefPnPZm+xla7xjZ71AbsmvId0ob13I7VopcOay8SoDU8Apt/fCQgCh6IqFCXLGbZmjnZ76YRtO4xS8SQRmRIybz/BmZWw7IZUkv9ZPN8zdhNsJ/d3DTyrcUSNeW+tWPIvT4rO3z6PFvXs3yTquF3byCVc1S/peAVy0mlgEqnOBtEIBfsyxot5/cR5pk5q9FuJtKyQLBBgAvLOEskb7G4mvqX9D4cAKqKRZogvoFb7MFQ7EDZOV684JuRRuQz3FitLFDU839brKtzzwypwlAVy2xWaIjEyNuE/CAdeRp6fiPWMcIJO9R9DL5b6Aak4Av+X5CbnEXsuaF+lExmLUeGSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 533203c4183123dad8ffecd694e7573a0ccd0da0 ]

Mark folios with NETFS_FOLIO_COPY_TO_CACHE whilst issuing subreqs rather than
when collecting them.  This means that the collector thread doesn't have to
try and keep track of which subreqs contribute to which folios - and thus
which folios will need to be copied to the cache because at least one byte
wasn't in the cache.  Instead, this is marked on the folios up front and the
collector need only consider the folios.

For PG_private_2-using filesystems, PG_private_2 is set instead of
NETFS_FOLIO_COPY_TO_CACHE, but otherwise it works the same.

The NETFS_RREQ_COPY_TO_CACHE is replaced with NETFS_RREQ_CANCEL_CACHING, which
is now set if caching fails somewhere, thereby causing the collection thread
to cancel the copy-to-cache marks on the remaining folios.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-9-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: e00827a4d0cf ("netfs: Fix read progress reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c     | 61 +++++++++++++++++++++++++++++++-
 fs/netfs/internal.h          |  1 +
 fs/netfs/read_collect.c      | 67 ++++++++++++++++++++++--------------
 fs/netfs/read_pgpriv2.c      | 15 ++++----
 fs/netfs/read_retry.c        |  6 +++-
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h |  6 ++--
 7 files changed, 121 insertions(+), 37 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 303fdce54fbaf..16d4db776f6ae 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -211,6 +211,56 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
 	}
 }
 
+/*
+ * Mark folios that we want to copy to the cache.  For filesystems that use
+ * netfslib fully, we set folio->private to NETFS_FOLIO_COPY_TO_CACHE;
+ * otherwise we set the deprecated PG_private_2.
+ */
+static void netfs_mark_copy_to_cache(struct netfs_io_request *rreq,
+				     struct folio_queue **fq,
+				     unsigned int *offset,
+				     int *slot,
+				     size_t len,
+				     bool copy)
+{
+	while (len > 0) {
+		struct folio *folio;
+		size_t fsize, overlap;
+
+		if (!*fq)
+			break;
+		if (*slot >= folioq_count(*fq)) {
+			*fq = (*fq)->next;
+			*slot = 0;
+			*offset = 0;
+			continue;
+		}
+
+		/* Determine how much the subreq overlaps the folio, if at all. */
+		fsize = folioq_folio_size(*fq, *slot);
+		overlap = min(len, fsize - *offset);
+
+		if (overlap > 0 && copy) {
+			folio = folioq_folio(*fq, *slot);
+			if (unlikely(test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags))) {
+				if (!folio_test_private_2(folio))
+					folio_start_private_2(folio);
+			} else {
+				if (!folio_get_private(folio))
+					folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
+			}
+			trace_netfs_folio(folio, netfs_folio_trace_mark_copy);
+		}
+
+		len -= overlap;
+		*offset += overlap;
+		if (*offset >= fsize) {
+			*slot += 1;
+			*offset = 0;
+		}
+	}
+}
+
 /*
  * Perform a read to the pagecache from a series of sources of different types,
  * slicing up the region to be read according to available cache blocks and
@@ -218,9 +268,11 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  */
 static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
+	struct folio_queue *fq = rreq->buffer.tail;
 	unsigned long long start = rreq->start;
+	unsigned int offset = 0;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret = 0, slot = 0;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -308,6 +360,13 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		}
 
+		if (fq) {
+			/* See if the cache indicated this should be cached. */
+			bool copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+
+			netfs_mark_copy_to_cache(rreq, &fq, &slot, &offset, slice, copy);
+		}
+
 		netfs_issue_read(rreq, subreq);
 		netfs_maybe_bulk_drop_ra_refs(rreq);
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index bd8b2d633f968..dfe7939f35f37 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -110,6 +110,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
 /*
  * read_collect.c
  */
+void netfs_cancel_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio);
 bool netfs_read_collection(struct netfs_io_request *rreq);
 void netfs_read_collection_worker(struct work_struct *work);
 void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error);
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index edf7cea7e2f91..12a786be1ea26 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,7 +19,6 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
 #define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
 
 /*
@@ -34,6 +33,30 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 }
 
+/*
+ * Cancel the copy-to-cache mark on a folio.
+ */
+void netfs_cancel_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
+{
+	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+		if (folio_get_private(folio) == NETFS_FOLIO_COPY_TO_CACHE) {
+			folio_detach_private(folio);
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		} else if (netfs_folio_group(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			struct netfs_folio *finfo = netfs_folio_info(folio);
+
+			finfo->netfs_group = NULL;
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		}
+	} else {
+		// TODO: Use of PG_private_2 is deprecated.
+		if (folio_test_private_2(folio)) {
+			folio_end_private_2(folio);
+			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+		}
+	}
+}
+
 /*
  * Flush, mark and unlock a folio that's now completely read.  If we want to
  * cache the folio, we set the group to NETFS_FOLIO_COPY_TO_CACHE, mark it
@@ -48,37 +71,37 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 
 	if (unlikely(folio_pos(folio) < rreq->abandon_to)) {
 		trace_netfs_folio(folio, netfs_folio_trace_abandon);
+		netfs_cancel_copy_to_cache(rreq, folio);
 		goto just_unlock;
 	}
 
 	flush_dcache_folio(folio);
 	folio_mark_uptodate(folio);
 
-	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
-		finfo = netfs_folio_info(folio);
-		if (finfo) {
-			trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
-			if (finfo->netfs_group)
-				folio_change_private(folio, finfo->netfs_group);
-			else
-				folio_detach_private(folio);
-			kfree(finfo);
-		}
+	if (unlikely(test_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags)))
+		netfs_cancel_copy_to_cache(rreq, folio);
 
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags)) {
-			if (!WARN_ON_ONCE(folio_get_private(folio) != NULL)) {
-				trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-				folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
-				folio_mark_dirty(folio);
-			}
+	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+		if (netfs_folio_group(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			trace_netfs_folio(folio, netfs_folio_trace_sched_copy);
+			folio_mark_dirty(folio);
 		} else {
+			finfo = netfs_folio_info(folio);
+			if (finfo) {
+				trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
+				if (finfo->netfs_group)
+					folio_change_private(folio, finfo->netfs_group);
+				else
+					folio_detach_private(folio);
+				kfree(finfo);
+			}
 			trace_netfs_folio(folio, netfs_folio_trace_read_done);
 		}
 
 		folioq_clear(folioq, slot);
 	} else {
 		// TODO: Use of PG_private_2 is deprecated.
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags))
+		if (folio_test_private_2(folio))
 			netfs_pgpriv2_copy_to_cache(rreq, folio);
 	}
 
@@ -131,9 +154,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		unsigned int order;
 		size_t fsize;
 
-		if (*notes & COPY_TO_CACHE)
-			set_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		folio = folioq_folio(folioq, slot);
 		if (WARN_ONCE(!folio_test_locked(folio),
 			      "R=%08x: folio %lx is not locked\n",
@@ -156,8 +176,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
 		*notes |= MADE_PROGRESS;
 
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		/* Clean up the head folioq.  If we clear an entire folioq, then
 		 * we can get rid of it provided it's not also the tail folioq
 		 * being filled by the issuer.
@@ -255,9 +273,6 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front->flags))
-				notes |= COPY_TO_CACHE;
-
 			if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
 				rreq->abandon_to = front->start + front->len;
 				front->transferred = front->len;
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index c31190993b762..a4b7bb88cbdb6 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -54,8 +54,8 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0, creq->gfp) < 0) {
+		set_bit(NETFS_RREQ_CANCEL_CACHING, &creq->flags);
 		folio_end_private_2(folio);
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
 	}
 
@@ -122,13 +122,14 @@ static struct netfs_io_request *netfs_pgpriv2_begin_copy_to_cache(
 	netfs_put_failed_request(creq);
 cancel:
 	rreq->copy_to_cache = ERR_PTR(-ENOBUFS);
-	clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
+	set_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags);
 	return ERR_PTR(-ENOBUFS);
 }
 
 /*
  * [DEPRECATED] Mark page as requiring copy-to-cache using PG_private_2 and add
- * it to the copy write request.
+ * it to the copy write request.  PG_private_2 should already be set on the
+ * folio.
  */
 void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
 {
@@ -136,11 +137,13 @@ void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *fo
 
 	if (!creq)
 		creq = netfs_pgpriv2_begin_copy_to_cache(rreq, folio);
-	if (IS_ERR(creq))
+	if (IS_ERR(creq)) {
+		set_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags);
+		netfs_cancel_copy_to_cache(rreq, folio);
 		return;
+	}
 
-	trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-	folio_start_private_2(folio);
+	trace_netfs_folio(folio, netfs_folio_trace_pgpriv2_copy);
 	netfs_pgpriv2_copy_folio(creq, folio);
 }
 
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index dd463a485139c..4f6a36c6e214f 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -303,7 +303,11 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 		for (int slot = 0; slot < folioq_count(p); slot++) {
 			struct folio *folio = folioq_folio(p, slot);
 
-			if (folio && !folioq_is_marked2(p, slot)) {
+			if (!folio)
+				continue;
+			netfs_cancel_copy_to_cache(rreq, folio);
+
+			if (!folioq_is_marked2(p, slot)) {
 				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index e60539f039f19..029456e034849 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -276,7 +276,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	8	/* Offload collection to workqueue */
 #define NETFS_RREQ_NO_UNLOCK_FOLIO	9	/* Don't unlock no_unlock_folio on completion */
-#define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
+#define NETFS_RREQ_CANCEL_CACHING	10	/* Set to cancel caching */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
 #define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 9bda9302be90c..a22084813cb59 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -198,7 +198,6 @@
 	EM(netfs_folio_trace_clear_cc,		"clear-cc")	\
 	EM(netfs_folio_trace_clear_g,		"clear-g")	\
 	EM(netfs_folio_trace_clear_s,		"clear-s")	\
-	EM(netfs_folio_trace_copy_to_cache,	"mark-copy")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
 	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
@@ -209,16 +208,19 @@
 	EM(netfs_folio_trace_kill_cc,		"kill-cc")	\
 	EM(netfs_folio_trace_kill_g,		"kill-g")	\
 	EM(netfs_folio_trace_kill_s,		"kill-s")	\
+	EM(netfs_folio_trace_mark_copy,		"mark-copy")	\
 	EM(netfs_folio_trace_mkwrite,		"mkwrite")	\
 	EM(netfs_folio_trace_mkwrite_plus,	"mkwrite+")	\
-	EM(netfs_folio_trace_not_under_wback,	"!wback")	\
 	EM(netfs_folio_trace_not_locked,	"!locked")	\
+	EM(netfs_folio_trace_not_under_wback,	"!wback")	\
+	EM(netfs_folio_trace_pgpriv2_copy,	"pgpriv2-copy")	\
 	EM(netfs_folio_trace_put,		"put")		\
 	EM(netfs_folio_trace_read,		"read")		\
 	EM(netfs_folio_trace_read_done,		"read-done")	\
 	EM(netfs_folio_trace_read_gaps,		"read-gaps")	\
 	EM(netfs_folio_trace_read_unlock,	"read-unlock")	\
 	EM(netfs_folio_trace_redirtied,		"redirtied")	\
+	EM(netfs_folio_trace_sched_copy,	"sched-copy")	\
 	EM(netfs_folio_trace_store,		"store")	\
 	EM(netfs_folio_trace_store_copy,	"store-copy")	\
 	EM(netfs_folio_trace_store_plus,	"store+")	\
-- 
2.53.0




