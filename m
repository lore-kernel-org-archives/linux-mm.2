Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1702AC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00576B0088; Thu, 27 Aug 2026 05:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1BF6B008A; Thu, 27 Aug 2026 05:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7AD36B008C; Thu, 27 Aug 2026 05:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8C656B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:39:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31ECA802C7
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:39:17 +0000 (UTC)
X-FDA: 85146551154.19.EEDB478
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 09178C0007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:39:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2FTEkCd;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823555;
	b=55rAfOiBVWO+8vXJdGAqdBF4WHnPsw/f/4HXFCD8rD6joe1aR878yhipHDn/+L5qQWQ/Cg
	fKM1X8KvzlI9Th/hJJ0E/ck95A5bIGGbSnT8mpnRikZApLrtRt5hP0LFk/hcWWQtxanJXs
	j20oyw+o6Pii/XnH/s2nogKC+4BsCaQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2FTEkCd;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=fFUqmToDXmDe5fHoFQEojZitcCuXNpjVLxPe1wqlw4ZJ+4lp7t9+8tcBTVFfV6O7CkWiGS
	sIhaSeUMUhECPnptT6FIQe5s6C0sJW5/Y6eVd7T2DGuX7D0zxAWyQuo/GR+4z1EHKjfefS
	Fcco1ZGR/fzJWpFZcnN0cqRYZtLxxUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=J2FTEkCdmXt4r34Rf9ruRihamB71FOFX4H1FcRWwr+fgFvaTo0rdeP/uLiWNz0PNT+jpiR
	mwrvVoa5v2P2s8ymS2PIrDfkI4raOwAyJyrOunshXexEfdj6vZrDy3huwfe/R+GbHqWzRP
	AAMMsZxX/3Y6qm7dxAhH/AbM5rs9zSI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-gX0u3OrVOjWmMNSQCnOfxw-1; Thu,
 27 Aug 2026 05:39:10 -0400
X-MC-Unique: gX0u3OrVOjWmMNSQCnOfxw-1
X-Mimecast-MFC-AGG-ID: gX0u3OrVOjWmMNSQCnOfxw_1787823548
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94A9D1835ADB;
	Thu, 27 Aug 2026 09:39:08 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A81FE1800346;
	Thu, 27 Aug 2026 09:39:05 +0000 (UTC)
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
Subject: [PATCH v3 07/10] netfs: Fix readahead synchronisation issues by loading all folios upfront
Date: Thu, 27 Aug 2026 10:38:22 +0100
Message-ID: <20260827093828.1956211-8-dhowells@redhat.com>
In-Reply-To: <20260827093828.1956211-1-dhowells@redhat.com>
References: <20260827093828.1956211-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: EJZ4QTJhCMIDbymeogSoTDT96MUiOlqe4V_PpPX8-Og_1787823548
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: fw7deenrktrskmnq47gdrpwb7tz3o5wi
X-Rspamd-Queue-Id: 09178C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787823554-905257
X-HE-Meta: U2FsdGVkX18q9JAwKjH2HsdQP69dCQq9Z3JcLjAFyZCo6eoztLGM67G0xqWfk8GSz3bVNmijuSokJvAnLi6DdlKuZJMGKZ7Fnd3WGzBhQ7xhuQXLrfyRv9+sZe0j+aQxDvHCRqUpILiFG+F6HtQ9lkqim4V9TwfPeU15IeecM1QdEgdGguI/P8VfqZqFB5Ip9hFemYQdLpGM+DjoQrK5ltze+mst92mSWNrX/viyfnYIVplFNc/OrVIWyZEdFz7SdtSHanXyY0Wqi6EZIsBZ73vQhkfOd/11l6pXrXJQUZpa6Jdi0MFIU6qothvvb2XMWqzmUwqj3kFaBG2jS/MKhre2aZlSj0da1q0Eqe4QSuaJR0dvQ1LCTu8uSTxxVkg3+0DjS8ZhtL++BF//CFb0BPt05lrHXXtz53TCW9dPz5zojtk5ye1Nwz+RAYDwxuyXeuCEMLAt9BKHBAf/YQ7QLMPhwtGGlEY+f5G4udedDaAEBqwqn/oxylsdDyXASWqXZAxqKhSd71gTdcSyfnzE8Un5l5XeYNuazPcHKDEQW+295LC7xXwKiYUByG1KklsuOFbnnt+CnZve/lfQDOUShvfzkwHp8gY9xe+sRb/s/spKmgq6Fm1JCYbSTrsoMLMC+D3D7vPEKsTTB4XUxdkExztB9KuOYFcVR+L2zZ3ee36+nOAyMs+LANQZC1fBORawEs7Vv+QTmpWD6Nwl+VW/ICLrzDFGAi1GA6uu2HuRTi//kNVPdRgvSKVRJ66bOinwCPN6EmuPy0z/D/b2nTmZcI6xxexaPquTDDGgGfClBazKiUbUI4QQOZSLr6D/+pjpDqB2xniSHO5Vzb1xWnoaYZ974ZBC5zLyxI0gHMMh1Psv9MceMFWKnkSsMs5e7HUlZvdYyTC+F4CmW5Tr53d+LenKBwjIL8kqFsWpXrmUUAn7EE3r60HHajUmyr9u8DPh7HK6aQgDH7Nty9pMIN+
 cmLM4uYc
 nNJsQN4cnAhwxbZuF0MAZZ7KoQxTDcCPHgHscZ7XB3JJsDU4f0uCibILIoalH1nFLg7i4OukA7Yts5KKBbI944N7dcWY+6+FoNXRXw0Zn1EgCWk/71GLpKtP/NCiDzelKlu8fzb1jghKs/ZVZVUDeDL6yQwUVhZ1NYv9ulayctoEGsntkwU3BVpSthrX1TFvNldQx08/fBkQwbkg5N8kczViBkzHG6pUqsH56y0OdvKTKZTZGPkq0kSrnhyd0j5lymTguUwpeggqr+3hsIl+K/aGNVj76Wkc9UQL9JIT/pftTT3lw9f/gGNABhBozMpHh6F9TkPm5+uXjt89a68AsvDg8mdA8jzbAJs02PoAtZ+E/uy13N6XAZ2zsxT4E5Ylt0Ku/w+NsOTFB4D2byzJha+BWKmfFT0Vj+yTrX/ZufpbLhNTuqd7RaduV/MbTRWtq4/ETakzJYRHvhaR9ZjkV7S5wsB9CdA//NXeKJqngrj3afiH+N8wAd5O1sxcNO5OHziSKYvZeWVYMkXJ0DrAW7IwUjFjvTtj1RAwzE6cpMci0qRIgORzWV6MXWoKUGkrV08dXjQFxue3U/gcRhDEQ0Z1PVfsUdKLEbKLzlz+2XEeMAxk9oKaa86bq4PL4yKQRIAzCts+1bp2OJgJe0YFJcKf1sg2w7zt3HTiChJp4f4FWTS6JClfXkuJIdPGh/M0ZJ3nSQnIi5jgrNTeZjF0XwVVZ3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some synchronisation issues that derive from the app thread
adding more folios to the rolling buffer whilst the collector thread is
looking at them or trying to clear them, such as determining the setting of
front_folio_order when the next folio hasn't been added yet,

The reason for the rolling buffer approach is that loading the buffer
upfront and then dropping all the refs just acquired is quite a slow
operation, and loading progressively allows some of the cost to be deferred
until after at least some of the I/O is started.

Instead, a better way is to load all the folios into the rolling buffer
upfront - and then drop the refs later, once the I/O is in progress.  (Even
better would be for the refs not to be there at all.)

Fix this by changing the rolling buffer loader to load all the folios
selected by the VM for readahead upfront into the folio queue.  The folio
queue is allocated a batch worth at a time as we don't know how many folios
are involved (the readahead_control struct, alas, has a page count, not a
folio count).

The folio refs acquired from readahead are then dropped in bulk once the
first subrequest is dispatched as it's quite a slow operation.  The
collector waits for NETFS_RREQ_NEED_PUT_RA_REFS to be cleared so that it
doesn't unlock folios before the xarray has been scanned for them.

This simplifies the buffer handling later and isn't noticeably slower as
the xarray doesn't need to be modified and the folios are all already
pre-locked.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c       | 101 ++++++++++++++++++++-------------
 fs/netfs/internal.h            |   1 +
 fs/netfs/misc.c                |  19 +++++++
 fs/netfs/read_collect.c        |   7 +++
 fs/netfs/read_retry.c          |   7 +++
 fs/netfs/rolling_buffer.c      |  81 ++++++++++++++++----------
 include/linux/netfs.h          |   1 +
 include/linux/rolling_buffer.h |   6 +-
 include/trace/events/netfs.h   |   3 +
 9 files changed, 154 insertions(+), 72 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7fdfa4f27e34..303fdce54fba 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -54,6 +54,42 @@ static void netfs_rreq_expand(struct netfs_io_request *rreq,
 	}
 }
 
+/*
+ * Drop the folio refs acquired from the readahead API.
+ */
+static void netfs_bulk_drop_ra_refs(struct netfs_io_request *rreq)
+{
+	struct folio_batch fbatch;
+	struct folio *folio;
+	pgoff_t nr_pages = DIV_ROUND_UP(rreq->len, PAGE_SIZE);
+	pgoff_t first = rreq->start / PAGE_SIZE;
+	XA_STATE(xas, &rreq->mapping->i_pages, first);
+
+	folio_batch_init(&fbatch);
+
+	rcu_read_lock();
+
+	xas_for_each(&xas, folio,  first + nr_pages - 1) {
+		if (xas_retry(&xas, folio))
+			continue;
+
+		if (!folio_batch_add(&fbatch, folio))
+			folio_batch_release(&fbatch);
+	}
+
+	rcu_read_unlock();
+	folio_batch_release(&fbatch);
+	trace_netfs_rreq(rreq, netfs_rreq_trace_ra_put_ref);
+	clear_bit_unlock(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags);
+	wake_up(&rreq->waitq);
+}
+
+static void netfs_maybe_bulk_drop_ra_refs(struct netfs_io_request *rreq)
+{
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_bulk_drop_ra_refs(rreq);
+}
+
 /*
  * Begin an operation, and fetch the stored zero point value from the cookie if
  * available.
@@ -74,12 +110,8 @@ static int netfs_begin_cache_read(struct netfs_io_request *rreq, struct netfs_in
  *
  * Returns the limited size if successful and -ENOMEM if insufficient memory
  * available.
- *
- * [!] NOTE: This must be run in the same thread as ->issue_read() was called
- * in as we access the readahead_control struct.
  */
-static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
-					   struct readahead_control *ractl)
+static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
 	size_t rsize = subreq->len;
@@ -87,30 +119,6 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 	if (subreq->source == NETFS_DOWNLOAD_FROM_SERVER)
 		rsize = umin(rsize, rreq->io_streams[0].sreq_max_len);
 
-	if (ractl) {
-		/* If we don't have sufficient folios in the rolling buffer,
-		 * extract a folioq's worth from the readahead region at a time
-		 * into the buffer.  Note that this acquires a ref on each page
-		 * that we will need to release later - but we don't want to do
-		 * that until after we've started the I/O.
-		 */
-		struct folio_batch put_batch;
-
-		folio_batch_init(&put_batch);
-		while (rreq->submitted < subreq->start + rsize) {
-			ssize_t added;
-
-			added = rolling_buffer_load_from_ra(&rreq->buffer, ractl,
-							    &put_batch);
-			if (added < 0) {
-				folio_batch_release(&put_batch);
-				return added;
-			}
-			rreq->submitted += added;
-		}
-		folio_batch_release(&put_batch);
-	}
-
 	subreq->len = rsize;
 	if (unlikely(rreq->io_streams[0].sreq_max_segs)) {
 		size_t limit = netfs_limit_iter(&rreq->buffer.iter, 0, rsize,
@@ -208,8 +216,7 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  * slicing up the region to be read according to available cache blocks and
  * network rsize.
  */
-static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
-				    struct readahead_control *ractl)
+static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
 	unsigned long long start = rreq->start;
 	ssize_t size = rreq->len;
@@ -288,7 +295,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		break;
 
 	issue:
-		slice = netfs_prepare_read_iterator(subreq, ractl);
+		slice = netfs_prepare_read_iterator(subreq);
 		if (slice < 0) {
 			ret = slice;
 			netfs_cancel_read(subreq, ret);
@@ -302,6 +309,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		}
 
 		netfs_issue_read(rreq, subreq);
+		netfs_maybe_bulk_drop_ra_refs(rreq);
 
 		if (test_bit(NETFS_RREQ_PAUSE, &rreq->flags))
 			netfs_wait_for_paused_read(rreq);
@@ -339,7 +347,8 @@ void netfs_readahead(struct readahead_control *ractl)
 {
 	struct netfs_io_request *rreq;
 	struct netfs_inode *ictx = netfs_inode(ractl->mapping->host);
-	unsigned long long start = readahead_pos(ractl);
+	ssize_t added;
+	uoff_t start = readahead_pos(ractl);
 	size_t size = readahead_length(ractl);
 	int ret;
 
@@ -360,11 +369,23 @@ void netfs_readahead(struct readahead_control *ractl)
 
 	netfs_rreq_expand(rreq, ractl);
 
-	rreq->submitted = rreq->start;
-	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST, rreq->gfp) < 0)
+	/* Load the folios to be read into a bvecq chain.  Note that this
+	 * acquires a ref on each folio that we will need to release later -
+	 * but we don't want to do that until after we've started the I/O.
+	 */
+	added = rolling_buffer_bulk_load_from_ra(&rreq->buffer, ractl,
+						 rreq->debug_id, rreq->gfp);
+	if (added < 0) {
+		ret = added;
 		goto cleanup_free;
-	netfs_read_to_pagecache(rreq, ractl);
+	}
+	__set_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags);
+
+	rreq->submitted = rreq->start + added;
+	rreq->cleaned_to = rreq->start;
 
+	netfs_read_to_pagecache(rreq);
+	netfs_maybe_bulk_drop_ra_refs(rreq);
 	return netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 cleanup_free:
@@ -457,7 +478,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	iov_iter_bvec(&rreq->buffer.iter, ITER_DEST, bvec, i, rreq->len);
 	rreq->submitted = rreq->start + flen;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
@@ -532,7 +553,7 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	if (ret < 0)
 		goto discard;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -689,7 +710,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
@@ -754,7 +775,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 420ee7b26580..bd8b2d633f96 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -79,6 +79,7 @@ ssize_t netfs_wait_for_read(struct netfs_io_request *rreq);
 ssize_t netfs_wait_for_write(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_read(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_write(struct netfs_io_request *rreq);
+void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq);
 
 /*
  * objects.c
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 5d554512ed23..f5c1c463f4ff 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -563,3 +563,22 @@ void netfs_wait_for_paused_write(struct netfs_io_request *rreq)
 {
 	return netfs_wait_for_pause(rreq, netfs_write_collection);
 }
+
+/*
+ * Wait for the readahead-acquired refs to be put.
+ */
+void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq)
+{
+	DEFINE_WAIT(myself);
+
+	for (;;) {
+		trace_netfs_rreq(rreq, netfs_rreq_trace_wait_put_ra_refs);
+		prepare_to_wait(&rreq->waitq, &myself, TASK_UNINTERRUPTIBLE);
+		if (!test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+			break;
+		schedule();
+	}
+
+	trace_netfs_rreq(rreq, netfs_rreq_trace_waited_put_ra_refs);
+	finish_wait(&rreq->waitq, &myself);
+}
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 23660a590124..edf7cea7e2f9 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -118,6 +118,13 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		slot = 0;
 	}
 
+	/* We have to wait for readahead refs to have been released before we
+	 * can unlock any folios as the ref-dropper walks i_pages and the only
+	 * thing preventing these folios from being removed is the folio lock.
+	 */
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_wait_for_put_ra_refs(rreq);
+
 	for (;;) {
 		struct folio *folio;
 		unsigned long long fpos, fend;
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 2b42758e01ec..dd463a485139 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -292,6 +292,13 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 {
 	struct folio_queue *p;
 
+	/* We have to wait for readahead refs to have been released before we
+	 * can unlock any folios as the ref-dropper walks i_pages and the only
+	 * thing preventing these folios from being removed is the folio lock.
+	 */
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_wait_for_put_ra_refs(rreq);
+
 	for (p = rreq->buffer.tail; p; p = p->next) {
 		for (int slot = 0; slot < folioq_count(p); slot++) {
 			struct folio *folio = folioq_folio(p, slot);
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index 8c0026836f9c..424e77a9a109 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -115,42 +115,65 @@ int rolling_buffer_make_space(struct rolling_buffer *roll, gfp_t gfp)
 }
 
 /*
- * Decant the list of folios to read into a rolling buffer.
+ * Decant the entire list of folios to read into a rolling buffer.
  */
-ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
-				    struct readahead_control *ractl,
-				    struct folio_batch *put_batch)
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id, gfp_t gfp)
 {
 	struct folio_queue *fq;
-	struct page **vec;
-	int nr, ix, to;
-	ssize_t size = 0;
+	ssize_t loaded = 0;
 
-	if (rolling_buffer_make_space(roll, GFP_KERNEL) < 0)
-		return -ENOMEM;
+	while (ractl->_nr_pages - ractl->_batch_count > 0) {
+		unsigned int nr;
 
-	fq = roll->head;
-	vec = (struct page **)fq->vec.folios;
-	nr = __readahead_batch(ractl, vec + folio_batch_count(&fq->vec),
-			       folio_batch_space(&fq->vec));
-	ix = fq->vec.nr;
-	to = ix + nr;
-	fq->vec.nr = to;
-	for (; ix < to; ix++) {
-		struct folio *folio = folioq_folio(fq, ix);
-		unsigned int order = folio_order(folio);
-
-		fq->orders[ix] = order;
-		size += PAGE_SIZE << order;
-		trace_netfs_folio(folio, netfs_folio_trace_read);
-		if (!folio_batch_add(put_batch, folio))
-			folio_batch_release(put_batch);
+		/* Allocate a folioq to put some folios into and attach it to
+		 * the rolling buffer.
+		 */
+		fq = netfs_folioq_alloc(rreq_id, gfp,
+					netfs_trace_folioq_make_space);
+		if (!fq)
+			goto nomem_unlock;
+		fq->prev = roll->head;
+		if (!roll->tail)
+			roll->tail = fq;
+		else
+			roll->head->next = fq;
+		roll->head = fq;
+
+		/* Get a batch of folios and note their orders. */
+		nr = __readahead_batch(ractl, (struct page **)fq->vec.folios,
+				       folioq_nr_slots(fq));
+		if (WARN_ON_ONCE(!nr))
+			break;
+		fq->vec.nr = nr;
+
+		for (int slot = 0; slot < nr; slot++) {
+			struct folio *folio = folioq_folio(fq, slot);
+			unsigned int order;
+
+			order = folio_order(folio);
+			fq->orders[slot] = order;
+			loaded += PAGE_SIZE << order;
+			trace_netfs_folio(folio, netfs_folio_trace_read);
+		}
 	}
-	WRITE_ONCE(roll->iter.count, roll->iter.count + size);
 
-	/* Store the counter after setting the slot. */
-	smp_store_release(&roll->next_head_slot, to);
-	return size;
+	WRITE_ONCE(roll->iter.count, loaded);
+	iov_iter_folio_queue(&roll->iter, ITER_DEST, roll->tail, 0, 0, loaded);
+	return loaded;
+
+nomem_unlock:
+	for (fq = roll->tail; fq; fq = fq->next) {
+		for (int slot = 0; slot < folioq_count(fq); slot++) {
+			folio_unlock(fq->vec.folios[slot]);
+			folioq_mark(fq, slot);
+		}
+	}
+	rolling_buffer_clear(roll);
+	roll->head = NULL;
+	roll->tail = NULL;
+	return -ENOMEM;
 }
 
 /*
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index f837a501008c..5c538d0c5d79 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -278,6 +278,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
+#define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
 #define NETFS_RREQ_USE_PGPRIV2		31	/* [DEPRECATED] Use PG_private_2 to mark
 						 * write to cache on read */
 	const struct netfs_request_ops *netfs_ops;
diff --git a/include/linux/rolling_buffer.h b/include/linux/rolling_buffer.h
index 9e5dad29669c..a97f7cfaacaa 100644
--- a/include/linux/rolling_buffer.h
+++ b/include/linux/rolling_buffer.h
@@ -45,9 +45,9 @@ struct rolling_buffer_snapshot {
 int rolling_buffer_init(struct rolling_buffer *roll, unsigned int rreq_id,
 			unsigned int direction, gfp_t gfp);
 int rolling_buffer_make_space(struct rolling_buffer *roll, gfp_t gfp);
-ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
-				    struct readahead_control *ractl,
-				    struct folio_batch *put_batch);
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id, gfp_t gfp);
 ssize_t rolling_buffer_append(struct rolling_buffer *roll, struct folio *folio,
 			      unsigned int flags, gfp_t gfp);
 struct folio_queue *rolling_buffer_delete_spent(struct rolling_buffer *roll);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 082cb03c6131..9bda9302be90 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -59,6 +59,7 @@
 	EM(netfs_rreq_trace_free,		"FREE   ")	\
 	EM(netfs_rreq_trace_intr,		"INTR   ")	\
 	EM(netfs_rreq_trace_ki_complete,	"KI-CMPL")	\
+	EM(netfs_rreq_trace_ra_put_ref,		"RA-PUT ")	\
 	EM(netfs_rreq_trace_recollect,		"RECLLCT")	\
 	EM(netfs_rreq_trace_redirty,		"REDIRTY")	\
 	EM(netfs_rreq_trace_resubmit,		"RESUBMT")	\
@@ -70,9 +71,11 @@
 	EM(netfs_rreq_trace_unpause,		"UNPAUSE")	\
 	EM(netfs_rreq_trace_wait_ip,		"WAIT-IP")	\
 	EM(netfs_rreq_trace_wait_pause,		"--PAUSED--")	\
+	EM(netfs_rreq_trace_wait_put_ra_refs,	"WAIT-P-RA")	\
 	EM(netfs_rreq_trace_wait_quiesce,	"WAIT-QUIESCE")	\
 	EM(netfs_rreq_trace_waited_ip,		"DONE-IP")	\
 	EM(netfs_rreq_trace_waited_pause,	"--UNPAUSED--")	\
+	EM(netfs_rreq_trace_waited_put_ra_refs,	"DONE-P-RA")	\
 	EM(netfs_rreq_trace_waited_quiesce,	"DONE-QUIESCE")	\
 	EM(netfs_rreq_trace_wake_ip,		"WAKE-IP")	\
 	EM(netfs_rreq_trace_wake_queue,		"WAKE-Q ")	\


