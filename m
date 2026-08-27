Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28B1C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68846B008A; Thu, 27 Aug 2026 05:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2C36B008C; Thu, 27 Aug 2026 05:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BE26B0092; Thu, 27 Aug 2026 05:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F50D6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:39:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2E5BC036F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:39:20 +0000 (UTC)
X-FDA: 85146551280.02.9F3B895
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id D7D3A4000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:39:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npaoclik;
	spf=pass (imf27.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3E4rlqJ8DWtsJPMhxO6MmP2nf33NlSqugS9DB0Zuf8=;
	b=ak+Jm/gxBS5Bqfb6LJyumzRiruH/okhFOUP5EcXVpX15x8JP7CiFpNWpbRbwDmetPUr574
	GryPL8M4ntI+bO5nku39+4G3L+EcLveyeoMbj0ef2zhFIvZ3zDr9veEJ3BH5J33aiGthKP
	3eQF0Mziho11W/WbJdkePggX2Hn5LL4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npaoclik;
	spf=pass (imf27.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823559;
	b=C+r4MxlYJRKpZiHqdAGGsP9n6jok1yvoSdToBuLcbO/8iR+AtBKDbUgxGIINUCRAy4cLl1
	bqOIfHSdGX6dUsMRY7hQuxWRFxrk3Qt7VWxHg+t8MwvNF+IALDq94p/v0yLGlH5kfLCKqw
	Nk7g2XQFFxkpag6TlUvYk8ZqCUvyIL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u3E4rlqJ8DWtsJPMhxO6MmP2nf33NlSqugS9DB0Zuf8=;
	b=Npaoclik4QPiBO/xqs2OFLf4iHEQgnO54eacG6c/tLWgROB23Ios1luniCG+r32WfpxKhp
	6u2gA4QBEOLnYlZuCZGWtb0toPdLEChX1E0EMhu1H8rKvE/UbUi9+0y72V/v9Sil1dyLll
	bu1no/XlOsavsRPxYnb+f/9ogYtzTw8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-BRu3Mo4bN4K9PLAYtjhPdg-1; Thu,
 27 Aug 2026 05:39:14 -0400
X-MC-Unique: BRu3Mo4bN4K9PLAYtjhPdg-1
X-Mimecast-MFC-AGG-ID: BRu3Mo4bN4K9PLAYtjhPdg_1787823553
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97DEE18009C0;
	Thu, 27 Aug 2026 09:39:12 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D82343000223;
	Thu, 27 Aug 2026 09:39:09 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v3 08/10] netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
Date: Thu, 27 Aug 2026 10:38:23 +0100
Message-ID: <20260827093828.1956211-9-dhowells@redhat.com>
In-Reply-To: <20260827093828.1956211-1-dhowells@redhat.com>
References: <20260827093828.1956211-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: P5iwe3zbG-U8YKKn98-5ajXj2Z3E0r8_gsrGuOgkUZo_1787823553
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: att5mbzj1ttei6h7ogthcwtz7jbjxe7j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7D3A4000A
X-Rspam-User: 
X-HE-Tag: 1787823558-827799
X-HE-Meta: U2FsdGVkX1/5cUVE5qo7omvgVnkBkFIYL7F+X/nALtNPTpQ3oQlq8MDBIx+tfu0fjaONlFVDuKW3ok0dKp0N1k2Fk0tSyJiMYfkN0/276ma/2twyd6InQAPIEMlRXotc5H9jQaVBlgTXqRmlHgtrED+voN1kEZMUjI322EKPhHgEPCLCrW8Yd2Y7XbDh3IqqkKwKRXBU5bUYO0thnJPmDwph4ptN7LkgtiO4l2f+z6NWoyCxpGE0fmMTDbn6/+p+D+HdCeb6WeFGNLuNIQnTsUCyGjHltVq122T6FLVL5cHW1cFQF8Zje/ZLspq9rt+CRQ9rlrXqzsXdp2mCqMA88AEKQrHHYgtrwv/GlLG8c3dYu20wY/s1w4Lwc5WlaWPd30adyDxaRODNA6bCJLZEsSlHnxYtaalgmru6ZxBBqefIIa7agQvTSJLppWMUjCayxPg7Sv3IgTRAhapeCy/Qiiz/f8KBC6P2P/NwGLePyBoEem6M4nnXDVtY+S95jJAUerg6BCbUuWWwYYAaFt0YbRSdRtQART7XNJc+l8jCbLw4edeHz88cs5pefkDe2IhtwMEdjEVccb026pQwUHsTTyyPoRXxV0j///t/x4fxVrAzKu8yMDlHUxvbc1Tf8YHEWkWDmdXJHTY2+rq07uTcVeDR1UNBEkABkXT+3SOpC5N6QsBUM4gBQTavCm+x6YTmP0lDujCiXQY+ntIVlhZYPID3jvuY1ZM5XpWUxSKbn9btLVHVDjVgo0FdL6xkWJprYcO7hkbfBfvHSWakaEi3dfFQf9JHR0x8IRA4xjix6bJFGbPOGGGSforFrHXNc6d47EawetlgcPmBEwm7D150mACX2PIMH74uJGmHiZpDsAmyHq2hmFOaP8vvklRziQ6tnct3A6nHRYAjAPMEIVqCZxj9fmS62cZnjUSACzmnR5mGeZDYxQ31DZlItgqgwFgRJvKMPWSx6dINdANuDZ3
 CMkXeRuj
 yZoqS86N7ILNRgI4e1Mh5usGWbs1DlvzpebG28bskqkDienwyKsrrYUn6rBTazHkdvxhYxGs9md2pstwiFDGvjzTTlTXaOu1Q6ePLR2ykEcw9hfJ8l3MMITW7kSZbjCXMecr4tEtBD/ZDGEPPxp9oDTlB43gzgz6TZ+5E2zGqVcizAbjFe/VX9Rwl0tP9dWlRYhhHLMTQLWSzOdUKdDy7Vd1ccfKTTqdD9uwNY9Y4mGNlALPiorcTTSuEFW/71Pqs4VoawuGJFoJDdAltV5ACeDDHnbU/A9U9x1jwlmFqgRtBAPUOu1D/wvPaZXkLfZl0Z0jI5B8C05nm1WH923gzQ9L1LZLF4U3N5L7hBR6cfFv+VPhkIgssSEaJilO1Ffb7s7HaC400yexSBwOTFBloGw0wxwCpBPcM1Rzyd3MoLlLKZaryZRYTKxFLIDZmp+CAXXppwv2OFgZD2dKAMHzqu71VIoHRqJ9KcvxPp+ps35aTw/hEBrvSds+lzBa5S4xNOrP3Cg9c/0Gg3eGDGDoUc41TLvhUr9x/iMpsc0nKXv+IpMOJWMGE8xL7CAEI2GaA+OLpNr4IVWk/Jz/u3JR6v5pzjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark folios with COPY_TO_CACHE whilst issuing subreqs rather than when
collecting them.  This means that the collector thread doesn't have to try
and keep track of which subreqs contribute to which folios - and thus which
folios will need to be copied to the cache because at least one byte wasn't
in the cache.  Instead, this is marked on the folios up front and the
collector need only consider the folios.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     | 62 +++++++++++++++++++++++++++++++++++-
 fs/netfs/read_collect.c      | 40 ++++++++++-------------
 fs/netfs/read_pgpriv2.c      | 13 +++++---
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h |  6 ++--
 5 files changed, 90 insertions(+), 33 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 303fdce54fba..20f358209730 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -211,6 +211,55 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
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
@@ -218,9 +267,11 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  */
 static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
+	struct folio_queue *fq = rreq->buffer.tail;
 	unsigned long long start = rreq->start;
+	unsigned int offset;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret = 0, slot = 0;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -308,6 +359,15 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		}
 
+		if (fq) {
+			/* See if the cache indicated this should be cached. */
+			bool copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+
+			if (copy)
+				set_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
+			netfs_mark_copy_to_cache(rreq, &fq, &slot, &offset, slice, copy);
+		}
+
 		netfs_issue_read(rreq, subreq);
 		netfs_maybe_bulk_drop_ra_refs(rreq);
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index edf7cea7e2f9..4e298b690219 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,7 +19,6 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
 #define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
 
 /*
@@ -55,30 +54,31 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	folio_mark_uptodate(folio);
 
 	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
-		finfo = netfs_folio_info(folio);
-		if (finfo) {
-			trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
-			if (finfo->netfs_group)
-				folio_change_private(folio, finfo->netfs_group);
-			else
-				folio_detach_private(folio);
-			kfree(finfo);
-		}
-
-		if (test_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags)) {
-			if (!WARN_ON_ONCE(folio_get_private(folio) != NULL)) {
-				trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-				folio_attach_private(folio, NETFS_FOLIO_COPY_TO_CACHE);
+		if (folio_get_private(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
+			if (test_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags)) {
+				trace_netfs_folio(folio, netfs_folio_trace_sched_copy);
 				folio_mark_dirty(folio);
+			} else {
+				trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
+				folio_detach_private(folio);
 			}
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
+		if (test_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags))
 			netfs_pgpriv2_copy_to_cache(rreq, folio);
 	}
 
@@ -131,9 +131,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		unsigned int order;
 		size_t fsize;
 
-		if (*notes & COPY_TO_CACHE)
-			set_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		folio = folioq_folio(folioq, slot);
 		if (WARN_ONCE(!folio_test_locked(folio),
 			      "R=%08x: folio %lx is not locked\n",
@@ -156,8 +153,6 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
 		*notes |= MADE_PROGRESS;
 
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
-
 		/* Clean up the head folioq.  If we clear an entire folioq, then
 		 * we can get rid of it provided it's not also the tail folioq
 		 * being filled by the issuer.
@@ -255,9 +250,6 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front->flags))
-				notes |= COPY_TO_CACHE;
-
 			if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
 				rreq->abandon_to = front->start + front->len;
 				front->transferred = front->len;
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index c31190993b76..fb57fc45b3fd 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -55,7 +55,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0, creq->gfp) < 0) {
 		folio_end_private_2(folio);
-		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
+		clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &creq->flags);
 		return;
 	}
 
@@ -122,7 +122,7 @@ static struct netfs_io_request *netfs_pgpriv2_begin_copy_to_cache(
 	netfs_put_failed_request(creq);
 cancel:
 	rreq->copy_to_cache = ERR_PTR(-ENOBUFS);
-	clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
+	clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
 	return ERR_PTR(-ENOBUFS);
 }
 
@@ -136,11 +136,14 @@ void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *fo
 
 	if (!creq)
 		creq = netfs_pgpriv2_begin_copy_to_cache(rreq, folio);
-	if (IS_ERR(creq))
+	if (IS_ERR(creq)) {
+		clear_bit(NETFS_RREQ_WRITE_TO_CACHE, &rreq->flags);
 		return;
+	}
 
-	trace_netfs_folio(folio, netfs_folio_trace_copy_to_cache);
-	folio_start_private_2(folio);
+	trace_netfs_folio(folio, netfs_folio_trace_pgpriv2_copy);
+	if (WARN_ON_ONCE(!folio_test_private_2(folio)))
+		return;
 	netfs_pgpriv2_copy_folio(creq, folio);
 }
 
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5c538d0c5d79..49fea3a30611 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -275,7 +275,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	8	/* Offload collection to workqueue */
 #define NETFS_RREQ_NO_UNLOCK_FOLIO	9	/* Don't unlock no_unlock_folio on completion */
-#define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
+#define NETFS_RREQ_WRITE_TO_CACHE	10	/* Need to write to the cache */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
 #define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 9bda9302be90..a22084813cb5 100644
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


