Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86117C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23F06B0099; Thu, 17 Sep 2026 11:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9D66B009B; Thu, 17 Sep 2026 11:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E95E6B009D; Thu, 17 Sep 2026 11:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 618B86B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:30:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5B46403CB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:46 +0000 (UTC)
X-FDA: 85223641692.10.2FA71B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92A9A180018
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="gfk0nTg/";
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKEyMdEoeiIPIwtGyct2nf92DfrT25kTIa23Y2eS+wo=;
	b=U0u6KPQYStk/91xa5wzqlodUH2876PfrMy7tdUl3mrPKqO2uxv3zTfsqq24bFwUbFPLnGp
	dEwptoESFeJXqCbLG+PiVni2gQROWjPqBTQVPVyZlsSPo2fJP/DkEaYCm0i/knfRcGUmkc
	8Ir+PepYAucptQJBx5Sp85r+1MufuDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659044;
	b=vIkqHgkUePHtSUNtQ9H63psmL/GCZTgOJxEGuBHqX9Ti4rTw8pg+9TDoL/eHN4rKKRrUSh
	2qoQMTY3fnmupDDEBib3mv6Ea2ees3Rp7UVgFJjdXR0xSG3mwLb2Nonuq0dI+eKtvMuQJS
	IqYY1GcYh9VhcNpQUEK2jkYLEv32OIc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="gfk0nTg/";
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 437894097F;
	Thu, 17 Sep 2026 15:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A21F00898;
	Thu, 17 Sep 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659043;
	bh=eKEyMdEoeiIPIwtGyct2nf92DfrT25kTIa23Y2eS+wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfk0nTg/7mbcvnfR3Ek+wtTAKryGWxHMa3i8H0fu0AfHWzzNjsOeEK32kYm2LZHrm
	 8WG7hU45cr94XfHu2QiRysikleuvBvDct8hbsRqjX+pjtgT5k7Q87QJCt4n2CohDh0
	 HQnfsrdKxHLLnFS4YVgIJv3yW/47vPbo4VPc0vdU=
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
Subject: [PATCH 7.2 085/733] netfs: Fix readahead synchronisation issues by loading all folios upfront
Date: Thu, 17 Sep 2026 16:06:33 +0100
Message-ID: <20260917151353.018900325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 65a8sij941wt1ouwg8bi586psf8natbz
X-Rspam-User: 
X-Rspamd-Queue-Id: 92A9A180018
X-Rspamd-Server: rspam03
X-HE-Tag: 1789659044-872505
X-HE-Meta: U2FsdGVkX19chyS3JOo4XlW+QzU5GYsg+AJ/mrm03HQv1JpRcyfxTEoD4rCg13FmxprarP4sPT+1u6+hRJ6+L9/4Qexs3dn9AwiWhSaXR11ix1wkBMyQlkNAVj4A3UBaZ5IQ8hQMJ2e26Zijhwo/461yl/hYLQvqjSEFSuENqPYn9mjdpCG0MVQaocl3nACDwQ9lLWGs6p9s+GXFVmt89ZQeHwZnFEUIB0L+jNhxxG9Dz5fQRKOU2M1WD52Pv/68511R5zV/pyJFyPLFzaicUCWc94n+Bj6RVbx/d9JJUOoujIFZAoZihr6RTDsh387EjwzRT7kcPw8dWg8iy2+NAugQTA/TkXTnNH6JOFlrIlnDx/PicB0vg32JzApjV+fSlTndILWVYxpXsMHz/HV/UxXrgWoVCBPNgVKk/rpbR+r65XxPgbmcIcp4ah9upr0tB6RLRxL9AnAm5XydWCdIqWwsIf2AwurEwxB80rvGrWpjy/9t7JC+VAzauLYWpsy9Pm6kw+OkQ7FFDljxN55t5WXXaWmyw71rMMC8dSyi8I9fFxxp0RawlKGfTCbvP9edB+IU0G3UMZRlXvLL2+zWMwceU/DCOu+82Epd6vB9OldIVR1BQzaxqkaSlSqeMn3DIFb2bu1gGo7LgEgtwatR4QbvDjCQIcebZA26A7Wf+axIf800NpyC0B1tNDJku3qqAx8zT7G5JumTSCAXniTjigR8/LDkbfnsf9+9aKbusqFnNw3ESCBmODCE1Z7Xb9lXPDFo2c6ZozA0JfYtAgwkzz1bsd6egfmf98vN1lIhr3NSUbQ3Y8paP3EIhq4rj/VnGZezn1wWrysJJ7MtynRHlP//jZQmCQ4EmoQCwPOh3R3PY+avagIDd+JMALuN8UzH9xc5c78hkdw7qitBD2uPB4JsL54fTZB0z5tNMRZleGpIU3yYrndaM1CUC3eIjanCA52e7IX0TThAVLjAZ55
 8D5YAahU
 NNd6Gwg4uIvto1Fwe3s+a/KFeO/18ObTp+lAsR6AgBnsokqm/XSpqmBEtdSEybG141uaNTm0RusYDQcix1LUtzN/R/3QdGnGJjx1qyUKqQ3lliwIraHIN6fLhxLGmplL7pUzo3SRAbUGJbJ4R5ykTjk815yUi1IjF3WrsIkbBNNZS7yZL9L3GCkbdBmgWN88kW3Of4Mb8weeSs10dYCK8UEODfXVh6AiawXibC5gcU/4ZhrX/2FS7HQg0z48nCeg73XQdCjcr/7M03rjUJSq5ifTV2mi3DLJ/7ge/q3SrWjVwWnQbj5IyznB3Z/+tSMD4l4gIhcuDgMlFFtzm6ULyEZHHtSkxYVW6lwKzjtPRNP5Vu+8gI3dV0JIyWsZF5CB+dYfvihyKunA22B9ccRgldkPu8ihqV310gxvLq2eXdKDquWNBa5DH4mq2DQVz/dm6ibigDwJu27A78Jbvo1yJfrI7HxKZvLSbVW2VJMsYuz+mXhs4bLbTKN+HFDQajBwllXh+v2rk8MbSE9NsWFBkgirR013JTzIk/Z0egoLvo4raOicopesWQzRzZUmByS46DAt6GU9RfMgDIgDsGmTS7JQ49DVrp5RbsNNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit fed0b33e6c584986ba70018ec9f9787a98216e64 ]

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
Link: https://patch.msgid.link/20260827134304.2075713-8-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 7fdfa4f27e349..303fdce54fbaf 100644
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
index 420ee7b26580f..bd8b2d633f968 100644
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
index 5d554512ed23a..f5c1c463f4ff7 100644
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
index 23660a5901246..edf7cea7e2f91 100644
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
index 2b42758e01ec9..dd463a485139c 100644
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
index 8c0026836f9c1..424e77a9a1098 100644
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
index d0b62d53eea99..e60539f039f19 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -279,6 +279,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
+#define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
 #define NETFS_RREQ_USE_PGPRIV2		31	/* [DEPRECATED] Use PG_private_2 to mark
 						 * write to cache on read */
 	const struct netfs_request_ops *netfs_ops;
diff --git a/include/linux/rolling_buffer.h b/include/linux/rolling_buffer.h
index 9e5dad29669cf..a97f7cfaacaad 100644
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
index 082cb03c61316..9bda9302be90c 100644
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
-- 
2.53.0




