Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7C6C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DC26B00C8; Mon,  6 Jul 2026 11:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9253C6B00CB; Mon,  6 Jul 2026 11:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814846B00CC; Mon,  6 Jul 2026 11:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2D76B00C8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:34:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C75501A010B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:34:43 +0000 (UTC)
X-FDA: 84958749246.24.DD6FBD8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C442216000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:34:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUhCmptO;
	spf=pass (imf08.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Sv21EWkJG4y1NdW/epi1zofKllIyTNCWUikhQWb7UQ=;
	b=bCZE4UF3S4zDBcTW04agIhzXW4bojDQxOc8bD0yxvSvIJQGAOKqi5vLKDXW5VtSm7H/wxQ
	7DXFw1/NkYvP2zLHUUoDXNJwZeQCUzXxkYmfgQNXt/WMR7zXJU26KljK1QWH8SbYqBC1Sx
	T3GjMPypFA9OGTWFCh9IFomOClRQTsE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dUhCmptO;
	spf=pass (imf08.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352082;
	b=4u2xF8OooOgJGsZUqcHbSdF/P1NQOqyOY4bn2qPWtHbfIUK1VLgx+hpWN5jnjUhOtsXzpj
	vxqLnwuyIJmHxnixugWJ8an6kOcE9CWExRWX7bOZTyfvx0pddy/fvKSUkIPwugWJJ/DchM
	hvy7JTwXl+mduZ02TYpIRTe2qV0ZSEA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Sv21EWkJG4y1NdW/epi1zofKllIyTNCWUikhQWb7UQ=;
	b=dUhCmptOVyXN0B7amjJCXhRMgoecIFj8H/sQqLaO3NpBG/NTumImfJVBfI7KqwZBupscaG
	4wHF/twQ5EBEYcmbm8r8LEBgoymJvPxtxNuUhSe9CTtGMIsdckbT04CywXPlEM8qUr67Qb
	s/BdNiXnkIMt5KRzTZbDDeDqQui0R3E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-b0Z-9I6vPWmbjOPAMRzc-Q-1; Mon,
 06 Jul 2026 11:34:37 -0400
X-MC-Unique: b0Z-9I6vPWmbjOPAMRzc-Q-1
X-Mimecast-MFC-AGG-ID: b0Z-9I6vPWmbjOPAMRzc-Q_1783352074
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D3901955EAE;
	Mon,  6 Jul 2026 15:34:34 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA0BD36918;
	Mon,  6 Jul 2026 15:34:27 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 02/21] netfs: Bulk load the readahead-provided folios up front
Date: Mon,  6 Jul 2026 16:33:48 +0100
Message-ID: <20260706153408.1231650-3-dhowells@redhat.com>
In-Reply-To: <20260706153408.1231650-1-dhowells@redhat.com>
References: <20260706153408.1231650-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: UaX_OYdKjH_5dtVLIOvb5K0PSvfxTNL6V4InwTWN2ng_1783352074
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C442216000A
X-Stat-Signature: ck8ahno581rh7e3j39d96ceu5yj9u5yf
X-HE-Tag: 1783352081-418126
X-HE-Meta: U2FsdGVkX18aEyE3tTbyjLM2fksFXzq/pJIzrvLOCrNsC009moiVU2D6iFlQBazir3EGoAa6F4P2Wwa2K9h9/p2kjF3BKNneTMH0aNWLWYNSJMPD6SG/3TGVKM6UjEVxmjiC8tG1yHIC77mgeON/gWpgmlFpAIMx+7bCBLAjBhnehU2fm/TehOj8Xo+oX8Uv04cCFfIt8WEC9vDyw8TmEpfJbk8zW8TqIDWtVWR65ks2UP2cE1haeFs9uRvbM+ynFOv6sYOIBHWw8j3/mjQSNWl62d4NhozF4/lXAj1vepRb//r04WtUpAIeUpypDdu9QqgqBs3+PBE5f+xfebsFyYl4AdrwLTEdaL0TlrPzlfyJ84MKDrV7p+co/PGJWmLm8JCDfsfZFwWs79hFy+4BaC1/LuMnNN3+3d/bIz65ByX8hFvV48VLZTtj/JjJL86Th/yGGBmdyzUfzn6AxAS8uThUURH9oPo3+NoJOTVMS8sKdw0P6N2tB3Io4ltCTSliyPGqoOOCo82/884JszqNegu5fYbOmewdD9ZkfDTCa6rDYY75pupqetPmKWLatmtXrjKjFCAinCWps0a1Eyur0rxYAgovReoD+/iUOIOUJ8QPHNKx5BrItN+LUxafu9cPPEJ+TKbN3CizQjXBa/qn+f0ZXu7pjVega0Xr4ZG34R1lWqZ63MhAjXpqrf5zyD66OBfAh8MrcGu+d/C2mF7WuSgzk63EA/MBQcXTso/lnHktGD7xnT5Gyt73WjcupczqYeCr9tauercGbvZ73OduOaLFAN1eYcB52yCrtwpwTQW05CmsDDf8ozLlo0Wiqin1uU3APT71tKRJUelZ9/2SchEq2B4TKpR8YdTmx1WivmACbJ2zyiFbOIdeo/Q85oV1poYgcMZBDNPa/ER7uruItgfr9aNI9JSV6BmV0L16LtVNqfMNX8SDNFjeL8vFYtOeTkYOP8kXMhBEZrGHgNJ
 LALnoU8+
 EJNzdALa9aDDfax+11uUq+1CTAOECk6HmcE/Yg0w9aeAxI1Xgu/2kIDfD+H5A6ya/mJ28hxpp+Ce/zF8JMIFsiwWWrIJx7teE4AErXE3FWGnzhKP5SOlq0Qy6ucqArNM62rIIOF+nL2bryoqqOym90cDjwmnadfXIYJ6vwyY4a9hix6VT+pkf9YCwS5ruym8vnAkxL2A9DQ5E33O1YDIAtPR66WXLtE5Wmnw6lkH+pdQDpRqfDfZ3yAJmqtMtbjRpj8rvjWmg/yz7zioMepdEnwsOKvSLpEBfwzv/LBTvUVkDd4/ENKTjeeeJXWQADa7A+WCMv+Yp5gZ9ZlR6BKz6A5CYWsR1LBORptJiQauY8+h/6EEuND++56T9Ta5c4DOw4zNWFczjsLVOPnZ8vwSkuSkFRrfma86nQUQHFaPoI65OUk6txZ/h+7QAIYfcJrcEP29LIoNZX5xUiUQa+ptAyvN5RMCQ6cIM2nQT+AJAqxAN1rlZ4fJMMoguuNMa3+eo9KB6uW+cRuX5+51LZemO60a9mIdGhHDLOtaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Load all the folios by the VM for readahead up front into the folio queue.
With the number of folios provided by the VM, the folio queue can be fully
allocated first and then the loading happen in one go inside the RCU read
lock.  The folio refs acquired from readahead are dropped in bulk once the
first subrequest is dispatched as it's quite a slow operation.  The
collector waits for NETFS_RREQ_NEED_PUT_RA_REFS to be cleared so that it
doesn't unlock folios before the xarray has been scanned for them.

This simplifies the buffer handling later and isn't noticeably slower as
the xarray doesn't need to be modified and the folios are all already
pre-locked.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c       | 97 +++++++++++++++++++++-------------
 fs/netfs/internal.h            |  1 +
 fs/netfs/misc.c                | 19 +++++++
 fs/netfs/read_collect.c        |  7 +++
 fs/netfs/rolling_buffer.c      | 75 ++++++++++++++++++++++++++
 include/linux/netfs.h          |  1 +
 include/linux/rolling_buffer.h |  3 ++
 include/trace/events/netfs.h   |  3 ++
 8 files changed, 169 insertions(+), 37 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 24a8a5418e31..19e026ce5d47 100644
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
@@ -87,28 +119,6 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
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
-			if (added < 0)
-				return added;
-			rreq->submitted += added;
-		}
-		folio_batch_release(&put_batch);
-	}
-
 	subreq->len = rsize;
 	if (unlikely(rreq->io_streams[0].sreq_max_segs)) {
 		size_t limit = netfs_limit_iter(&rreq->buffer.iter, 0, rsize,
@@ -206,8 +216,7 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  * slicing up the region to be read according to available cache blocks and
  * network rsize.
  */
-static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
-				    struct readahead_control *ractl)
+static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
 	unsigned long long start = rreq->start;
 	ssize_t size = rreq->len;
@@ -286,7 +295,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		break;
 
 	issue:
-		slice = netfs_prepare_read_iterator(subreq, ractl);
+		slice = netfs_prepare_read_iterator(subreq);
 		if (slice < 0) {
 			ret = slice;
 			netfs_cancel_read(subreq, ret);
@@ -300,6 +309,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		}
 
 		netfs_issue_read(rreq, subreq);
+		netfs_maybe_bulk_drop_ra_refs(rreq);
 
 		if (test_bit(NETFS_RREQ_PAUSE, &rreq->flags))
 			netfs_wait_for_paused_read(rreq);
@@ -338,6 +348,7 @@ void netfs_readahead(struct readahead_control *ractl)
 	struct netfs_io_request *rreq;
 	struct netfs_inode *ictx = netfs_inode(ractl->mapping->host);
 	unsigned long long start = readahead_pos(ractl);
+	ssize_t added;
 	size_t size = readahead_length(ractl);
 	int ret;
 
@@ -358,11 +369,23 @@ void netfs_readahead(struct readahead_control *ractl)
 
 	netfs_rreq_expand(rreq, ractl);
 
-	rreq->submitted = rreq->start;
-	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST) < 0)
+	/* Load the folios to be read into a bvecq chain.  Note that this
+	 * acquires a ref on each folio that we will need to release later -
+	 * but we don't want to do that until after we've started the I/O.
+	 */
+	added = rolling_buffer_bulk_load_from_ra(&rreq->buffer, ractl, rreq->debug_id);
+	if (added < 0) {
+		ret = added;
 		goto cleanup_free;
-	netfs_read_to_pagecache(rreq, ractl);
+	}
+	__set_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags);
+
+	rreq->submitted = rreq->start + added;
+	rreq->cleaned_to = rreq->start;
+	rreq->front_folio_order = folio_order(rreq->buffer.tail->vec.folios[0]);
 
+	netfs_read_to_pagecache(rreq);
+	netfs_maybe_bulk_drop_ra_refs(rreq);
 	return netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 cleanup_free:
@@ -455,7 +478,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	iov_iter_bvec(&rreq->buffer.iter, ITER_DEST, bvec, i, rreq->len);
 	rreq->submitted = rreq->start + flen;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
@@ -530,7 +553,7 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	if (ret < 0)
 		goto discard;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -687,7 +710,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
@@ -752,7 +775,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d889caa401dc..5e86417c88d4 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -78,6 +78,7 @@ ssize_t netfs_wait_for_read(struct netfs_io_request *rreq);
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
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index a17fbf9853a4..576b425a227d 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -149,6 +149,81 @@ ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 	return size;
 }
 
+/*
+ * Decant the entire list of folios to read into a rolling buffer.
+ */
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id)
+{
+	XA_STATE(xas, &ractl->mapping->i_pages, ractl->_index);
+	struct folio_queue *fq;
+	struct folio *folio;
+	ssize_t loaded = 0;
+	int nr, slot = 0, npages = 0;
+
+	/* First allocate all the folioqs we're going to need to avoid having
+	 * to deal with ENOMEM later.
+	 */
+	nr = ractl->_nr_folios;
+	do {
+		fq = netfs_folioq_alloc(rreq_id, GFP_KERNEL,
+					netfs_trace_folioq_make_space);
+		if (!fq) {
+			rolling_buffer_clear(roll);
+			return -ENOMEM;
+		}
+		fq->prev = roll->head;
+		if (!roll->tail)
+			roll->tail = fq;
+		else
+			roll->head->next = fq;
+		roll->head = fq;
+
+		nr -= folioq_nr_slots(fq);
+	} while (nr > 0);
+
+	rcu_read_lock();
+
+	fq = roll->tail;
+	xas_for_each(&xas, folio, ractl->_index + ractl->_nr_pages - 1) {
+		unsigned int order;
+
+		if (xas_retry(&xas, folio))
+			continue;
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+		order = folio_order(folio);
+		fq->orders[slot] = order;
+		fq->vec.folios[slot] = folio;
+		loaded += PAGE_SIZE << order;
+		npages += 1 << order;
+		trace_netfs_folio(folio, netfs_folio_trace_read);
+
+		slot++;
+		if (slot >= folioq_nr_slots(fq)) {
+			fq->vec.nr = slot;
+			fq = fq->next;
+			if (!fq) {
+				WARN_ON_ONCE(npages < readahead_count(ractl));
+				break;
+			}
+			slot = 0;
+		}
+	}
+
+	rcu_read_unlock();
+
+	if (fq)
+		fq->vec.nr = slot;
+
+	WRITE_ONCE(roll->iter.count, loaded);
+	iov_iter_folio_queue(&roll->iter, ITER_DEST, roll->tail, 0, 0, loaded);
+	ractl->_index    += npages;
+	ractl->_nr_pages -= npages;
+	return loaded;
+}
+
 /*
  * Append a folio to the rolling buffer.
  */
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 1bc120d61c5b..4f7571ea49bd 100644
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
index ac15b1ffdd83..b35ef43f325f 100644
--- a/include/linux/rolling_buffer.h
+++ b/include/linux/rolling_buffer.h
@@ -48,6 +48,9 @@ int rolling_buffer_make_space(struct rolling_buffer *roll);
 ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 				    struct readahead_control *ractl,
 				    struct folio_batch *put_batch);
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id);
 ssize_t rolling_buffer_append(struct rolling_buffer *roll, struct folio *folio,
 			      unsigned int flags);
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


