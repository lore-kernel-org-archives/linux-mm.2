Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FC310A1E64
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063296B013F; Thu, 26 Mar 2026 06:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A4F6B0141; Thu, 26 Mar 2026 06:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92B86B0142; Thu, 26 Mar 2026 06:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8BE36B013F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6886F5CC65
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:47:44 +0000 (UTC)
X-FDA: 84587888448.12.96BC350
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 48A608000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:47:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JRog2Z5p;
	spf=pass (imf30.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JRog2Z5p;
	spf=pass (imf30.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774522062; a=rsa-sha256;
	cv=none;
	b=dIA92Qvx2vjSs8A10EzBre4c17Bbp9fIeQu8TYz9v8wnT7RiCwZ+4zrhk0+kb0yyNJRKsO
	tDAuLD2bqI3MHIj/KgqgC2ErP35P1uJ7Wt4Qooh2r0cIFVXUzik7D2m52aWXH3FtP3iVWM
	cYAobE11T74U3CWc4pkeykhtsnB50sk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774522062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzGei/xBTUYREFiynnCgIfE37SpwP1mzY41m1gTiMBs=;
	b=3RDB2HOXnZJPVg4IHsdOkmeWfvST9YbbjEB2bq6KbiCqTsgpdo6p1YoEG+Q1NVziOEJXHI
	pZSZoHWlzsiQBtbEBCllhFusMJOln/C/U2D66uJ6vAPwZvrCndqzO9jX3HxjU1udJEeeyp
	NIcUMKMEZI6+LfJyqScVq6fXlHXv/cc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qzGei/xBTUYREFiynnCgIfE37SpwP1mzY41m1gTiMBs=;
	b=JRog2Z5p12OdT+HEkSYgB6682wiDZIpw0IIk5iO7DALFPF1DEE/1CFBorQdbcnNGITL2cf
	ZrbyYfGNSd+0XMgsho4UGpNNyu3u9RsvMc0uTG1Skfrk2DAaCgUuI37PA1uDk5eFLGaPy3
	l/5Sr2eU6SePiyup/nhgQqZiQAE9Bm4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-m2zo_54vN3yDFY_z3Bv5eA-1; Thu,
 26 Mar 2026 06:47:38 -0400
X-MC-Unique: m2zo_54vN3yDFY_z3Bv5eA-1
X-Mimecast-MFC-AGG-ID: m2zo_54vN3yDFY_z3Bv5eA_1774522055
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A126E18005BD;
	Thu, 26 Mar 2026 10:47:34 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E21EC1800671;
	Thu, 26 Mar 2026 10:47:27 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	linux-mm@kvack.org
Subject: [PATCH 10/26] netfs: Bulk load the readahead-provided folios up front
Date: Thu, 26 Mar 2026 10:45:25 +0000
Message-ID: <20260326104544.509518-11-dhowells@redhat.com>
In-Reply-To: <20260326104544.509518-1-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: cCdMkTDqt8hmlWStXHs9zsATC-IIfl4VkhLHwIT4zR0_1774522055
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48A608000E
X-Stat-Signature: df7154yoa48xs5r8ktwnnti7gd1erhoj
X-Rspam-User: 
X-HE-Tag: 1774522062-80212
X-HE-Meta: U2FsdGVkX18wAjXqQka1++8dp4TsXUmvHHG/F9awJLJIP0NNPm5ELpwcL2aiOjs6Rxce7h2oxCoapk9YT/VaPliN7ReYotBHC/255G2dV17KV/aL0M2Eg2tMioj22yCBYypRsoQ7CI2onMAdEEiky44idzRNZk06K820C7mcHJeqkAqmCaZYcmZFXfzluVw5WA00O7CCoJIgupS/SCMvamf679nYD/+8wMzbUoUooYYPYEGjV2EaTfJOgTpaRBc4WNfSi9q6Zelz+L+AMXXlIrkMGcdlqJKsCuX6DWM5DNYtzSTp4LbPoaabjQt8685AlCLRFq6PmZtZx4vvRvamP2SksFdEDOusnzdE5JiPMcQL7fVKZn2GGtSPD6l3zYIIjIfx1Fne79A3tTTEdmTkQP6FxuWxzVziApsGsLorQE3/vFpCoVnFDxxJLjDA8cIZwsG4uxmMuFq7J9KYl4wZ3ezo25RFpeTq/O3fm79RSNNG0O72nKNEdXLMp6h0f+lNS5fj27wpnd5D5fW/u+WiLx5vxQVG9mHycDrwQJKYSd4tyxTFjy0g+9fh9wByky2FNPv+upyS8sWW579uDV3kSP+E+ZblOXg6YyHiz2ws9HCnKukPvXBLWvx60xhIdpilWt4U0zLEkcgJnoVHHBMeNAhNt3sZXGiOL/SmEnZrw2RT32ooSGlGosASEnb2wdR7qb8f1do35bsKE9unSqAD2GDcWAkcghUe5gMJ9sHensRs66JU+Pwr/4M5DDgFrC5TKzJ5+JdTcYxfx/R1SukZcy2kjYh3SxDrbgMbeOwXCblvC/9uWJqGILc1mnHtdNE6iZpUAqmBpMpLlIyiWaebqqNeYqrwrYaifUw7Rv8Bmi7Votd6IuEh/LRHjXoN4xmgfOMgMgIHzD56JXOYnAyh7SUCiyU7kbCYYR+B+FVf7DqQJMIXOIiuF61YhIxOqQ8auDSI/4Fcd0IMZi9Ohsr
 Y/v0PqP6
 CMsgZmws0dnaxehoXNAKuflq/D4i3ngkWaztZJJSmrr6dAp6bmFK5jd38LEcDn3XmG4suZ9KzsFPx5RZtiEwKyDP4vgnUw4yEolgN8Qd6t9DX/9LQ8JFwH3rr5Y4CflPQKpiO3vEYvZCscbUt8nqHOC6PITib2EmU0vCZcuoRj2UnR7bCBWO+Z+VZjU74sin5CTEzvHxjrSFBM8dCvtne7p4CGxdj8IAvj+5++SpMLL1MTodOgiIwL8JtAAvrzKaZVzrsQIwVbcZtVi9ociVGBFa0QKoBV/W8MPc7Ua1UZ/3uI69FbhK2WdHrZLvsedznwlX4DXvhX0j6TMfo09dYRxKcjJ4Bbb4CaqxtZupinj+bW2xCTj+Hjfp+v2mOpZlvkirBllW+8oO+s99E4H1OkYlyYhh9OMYF4InW7QmcLspkaqSX1K9C3/fxv2VPhjcSlB/rA8wwgyuFeMAb/Rdah6bpVV8aQWxYA1NJnakiILO/VsXkLa4Hit8pZUMhg9DYNP5I4m5mXzCvo4DvQm1XNtKF/kcv4Z1D4+JI
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
first subrequest is dispatched as it's quite a slow operation.

This simplifies the buffer handling later and isn't noticeably slower as
the xarray doesn't need to be modified and the folios are all already
pre-locked.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c       | 95 +++++++++++++++++++++-------------
 fs/netfs/rolling_buffer.c      | 75 +++++++++++++++++++++++++++
 include/linux/netfs.h          |  1 +
 include/linux/rolling_buffer.h |  3 ++
 include/trace/events/netfs.h   |  1 +
 5 files changed, 138 insertions(+), 37 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index aee59ccea257..abdc990faaa2 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -54,6 +54,40 @@ static void netfs_rreq_expand(struct netfs_io_request *rreq,
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
+}
+
+static void netfs_maybe_bulk_drop_ra_refs(struct netfs_io_request *rreq)
+{
+	if (test_and_clear_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_bulk_drop_ra_refs(rreq);
+}
+
 /*
  * Begin an operation, and fetch the stored zero point value from the cookie if
  * available.
@@ -74,12 +108,8 @@ static int netfs_begin_cache_read(struct netfs_io_request *rreq, struct netfs_in
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
@@ -87,28 +117,6 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
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
@@ -209,8 +217,7 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  * slicing up the region to be read according to available cache blocks and
  * network rsize.
  */
-static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
-				    struct readahead_control *ractl)
+static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
 	struct fscache_occupancy _occ = {
 		.query_from	= rreq->start,
@@ -345,7 +352,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 			trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
 		}
 
-		slice = netfs_prepare_read_iterator(subreq, ractl);
+		slice = netfs_prepare_read_iterator(subreq);
 		if (slice < 0) {
 			ret = slice;
 			subreq->error = ret;
@@ -362,6 +369,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 
 		netfs_queue_read(rreq, subreq, size <= 0);
 		netfs_issue_read(rreq, subreq);
+		netfs_maybe_bulk_drop_ra_refs(rreq);
 		cond_resched();
 	} while (size > 0);
 
@@ -395,6 +403,7 @@ void netfs_readahead(struct readahead_control *ractl)
 	struct netfs_io_request *rreq;
 	struct netfs_inode *ictx = netfs_inode(ractl->mapping->host);
 	unsigned long long start = readahead_pos(ractl);
+	ssize_t added;
 	size_t size = readahead_length(ractl);
 	int ret;
 
@@ -415,11 +424,23 @@ void netfs_readahead(struct readahead_control *ractl)
 
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
@@ -511,7 +532,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	iov_iter_bvec(&rreq->buffer.iter, ITER_DEST, bvec, i, rreq->len);
 	rreq->submitted = rreq->start + flen;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 
 	if (sink)
 		folio_put(sink);
@@ -580,7 +601,7 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	if (ret < 0)
 		goto discard;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -737,7 +758,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	if (ret < 0)
 		goto error;
@@ -802,7 +823,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index a17fbf9853a4..292011c1cacb 100644
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
index 77238bc4a712..cc56b6512769 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -280,6 +280,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
+#define NETFS_RREQ_NEED_PUT_RA_REFS	13	/* Need to put the folio refs RA gave us */
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
index cbe28211106c..b8236f9e940e 100644
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


