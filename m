Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F3BC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A806B0088; Thu, 27 Aug 2026 09:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B226B008A; Thu, 27 Aug 2026 09:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ADA6B008C; Thu, 27 Aug 2026 09:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A63576B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:43:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 297541A0414
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:43:47 +0000 (UTC)
X-FDA: 85147167294.14.36276B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09B03180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:43:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bBuaQ+Oq;
	spf=pass (imf24.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=WLfhqjEaLXJamD9kUq23eICiIprmWdc9uCxva6MPWO6Gp7YYnM5MKAQEy2EFyCmdigZogR
	jb5XDxD55f+Yqw2zq3CSpst0Pov3WchyrmbEKvsxlNPoWFnvGFu/WM1Xd3LXkKV6Jpcrma
	WMiHnEa+3xdJ5ZkXZ4D7ATDxjV+ImUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838225;
	b=humIP/9snRqbIwTrcF0Q3rUq7PUps+cH9Yn0KmWFCE87wYBrW2SOPgoqI/Hlv9NExXyqja
	bkmGhRF+8xPyPK02LOZJ8lfEFbJHQfI1FQfrCPB/T+jzWtR/4EMOug5pQTr6cPn4ATyy4l
	NlzCnclxc9QwYR6cNH1C/Yuppt3/lqY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bBuaQ+Oq;
	spf=pass (imf24.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787838224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=bBuaQ+OqKODg7ejpDX44ZIJoAn9+FMn1qzBkZeVuquxIsnIDV/j9o2XoR+BR237cTsh3jY
	OMBUArcqeozn+nNyYGM+iku49nIvoICwPQiTI8WR/OqC7jogEl7CNDQqslf6Q1vjXPTOn4
	W4/MrEdwB9KTaS+VQMH8p+16aRZnDyA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-OSezVYWxOt-e2M6gmcCOig-1; Thu,
 27 Aug 2026 09:43:39 -0400
X-MC-Unique: OSezVYWxOt-e2M6gmcCOig-1
X-Mimecast-MFC-AGG-ID: OSezVYWxOt-e2M6gmcCOig_1787838218
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E43519540D8;
	Thu, 27 Aug 2026 13:43:37 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C40081800348;
	Thu, 27 Aug 2026 13:43:34 +0000 (UTC)
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
Subject: [PATCH v4 07/10] netfs: Fix readahead synchronisation issues by loading all folios upfront
Date: Thu, 27 Aug 2026 14:43:00 +0100
Message-ID: <20260827134304.2075713-8-dhowells@redhat.com>
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: _TCjqWclc8Dd8I_-Ds3waUW1k57RsZbBzawFe62rIGM_1787838218
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09B03180009
X-Stat-Signature: 7tig55zy6th3tgxyyw69kdp8jsd8g96q
X-HE-Tag: 1787838224-522073
X-HE-Meta: U2FsdGVkX1+qBQS+KFgrYcK7NJ6Ntumm7lieeFuRPmLKci2Y98iOhVDIVd6yMMN/Znpshau5va6cGE+pSXkdzogwouU7oVjWR0AukM392NlUkRWysjjigpdjDCK++Ad382cx1M69MCYuSokGbCB4bv8ocuSy8EVkmEsCysgmJgbyP2k2Z8KMW5Kf0OU8SH+/aXEOUcKQ2eB+KXXfELpkxLkTMKcaUhM3rYSe0Z/kxt0eRrOHGQ8b6zF2viSHtF3W8Nq1l9o3qGhv4ilUwjkjMfzE5gjFKu+qk1jTcP8QENi/bDY+46nkA7rpXXiOYtdVvm14pSqvzVjlqUeqopcsG0lTi9znum8EifLZSBSYiDTsjlbm1SDNofm+yEwlFRaQ6fWV38y41uQJIbnIUt+/Mrx5vj7+ZrjqkkJGIJCSjMkRHdyUK3z5/38b93g4iwTZiZrOqRW+3ohzF/6AOQiV7Pk+i6C4ci+VuELvLZ4Z03fo4T/NAlXj3RT56NndTbnpkUbQkkEPD1y+xA/poJsrRceDvmXQl2yqDOgcKNsjIa7ofNodi3KVlRQZksTAKPRhg4CEKc7pYNTV2//2cB/nDYMHcRG20euEK+njHaJObI74KAM4dbOGvwOcHaS53QLowIijNAscHcOsw6TN7H/f53HIXX0qaGPpeG1b/1yYho38Ri7Z5vxO9Z/X09txJLebJB8XVEqOrVHFAURiU6oPwliO0pvCzPH3MlfThcmB/PvGrrM2G3bP2aJtjQ/2btVmpgjccCqtsyYCFfi13gLnoMCe50kqjnyFe72Ry932Jk3AphtjlXriDDq+yn4A3FRvPxN2TFmlI6FRG+Nw6i8VKP5iF+/u+yhK9yW3mYL64O/07cb0Wl5Dwoy1bWknQdRojcZRBagAkalPQHd9nlgRClY7Ev5aMSRLCfH05Ggy5YuqLw8HLEo+Ws+QveJp3BwUBwTwFkU9pL7C/vdGGj6
 rPlqHOMU
 ly4cMoPvC4sGW0+NI4bEri2dbtif0SssqqAmQFeceyl8YuAQ/J8LjuNkBAHGLWelxzTFjS80ab3b/jzS55oJUbXiaEYH9oqCoC34efVAOTiePKck7apOdNNDTn06qrQvh5any4eFxLHlA4JQUHr4ny9NAH81cgF8/5XjBQAArr/EHhe0TWTV2WQhnP9xwJ/ly2MuhSqVrup6zBq2qNOWimcXDO21aByCfmSYaADhXYM2K2KAzHOl9RVWNW0O+GCY6VgTo6f9WnTm9UHid66JXCKLyhycLrkHJL2njkUKDnf3Fe5yRak4UkZtWVT+PMYPJuTiRClwFbt0fRXkDDf/5nfS8tJuiJGSGX7GYvH2gPjMVvWtOS0IpVCaHu38BTOzA/TAgp4Udb/lNeGGyavDYBCW2CcVnXzwY6CqtAfNcC696KBDYHoc91HgOfoU2KYZWOmoZCQy0JoNCVXBsUPHo3ugVyvVafTjVbpK2b5U7eC2KP8Z50uBwtah9PtdkoMERqgFs0MF4FJDDEMqDG/IhP3na5iZAn4IYbipHp/Hvk/Bgwetxh4lfCZ60KFxEbVXeQ1T9eQNvheJNXTtwpyu4wpyDE2vMPjJsRkMhIBJLAX0qd3F6ndeELPr31qJC7b7spW8BI2cyUnWHs8AUTbx86bIqONPyITNTMSa4cmk16GHCw6vbVhxWHw0FZoTnjuDp18s/dRM+HXVMO39NiQixaKScaxlHLsMUKKJR
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


