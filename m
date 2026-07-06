Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9371AC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6362D6B00C6; Mon,  6 Jul 2026 11:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6536B00C8; Mon,  6 Jul 2026 11:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487B76B00C9; Mon,  6 Jul 2026 11:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D05F6B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:28:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85710A00B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:28:27 +0000 (UTC)
X-FDA: 84958733454.05.D636288
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DE4440008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:28:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=brHdu+JJ;
	spf=pass (imf04.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783351705;
	b=UGQNn0WSPRnx+WrQ93fKnCKZn/4FP6icCAoTWaPferCC790OKkVbvn/px7pzWjZLzyo5tb
	pkWjy7eIQO15iRwlpGpDoRvav4LhSjl5ynj/eLgk0RuZoejKWxfn0PFWsTBFW9yo/CJGtp
	Zc2HESmEl9oJiHmn1itFhHssyKB5qPM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=brHdu+JJ;
	spf=pass (imf04.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783351705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Sv21EWkJG4y1NdW/epi1zofKllIyTNCWUikhQWb7UQ=;
	b=2ohD81y0vi/XpsriZUC2AUe8uZH5RZ6FqkjslJe0dKe2mn5AdRbEccASZeAzvAvUrqqMIE
	SNB/wPhPNJ55nec8iLPePWqsk0+6PBCp5vGq11X51sqF3kb7uqCZbUNZM2Eu0dn4yxwFvK
	yWxzHfg40AC7PXU6m5xlvGwlZHakP7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783351704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Sv21EWkJG4y1NdW/epi1zofKllIyTNCWUikhQWb7UQ=;
	b=brHdu+JJDxcbCOcaWbP9LL8tWDm+Nyndae53UI6N67L7lKjz+rfDc3r7pAd2Om529BsFr2
	1JLTMKXE6HWrQ+wsWxdI514dZoDxc+/bz2B1WfAbGjfaOvCzicKgYW4JrkSM9UPampA/EJ
	Op9pjrg9VDmnlEfcIT4jhp6VOvr7Ek8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-L5I6WuWTPWOoRXquUsOD_A-1; Mon,
 06 Jul 2026 11:28:19 -0400
X-MC-Unique: L5I6WuWTPWOoRXquUsOD_A-1
X-Mimecast-MFC-AGG-ID: L5I6WuWTPWOoRXquUsOD_A_1783351696
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DB2F1955D9E;
	Mon,  6 Jul 2026 15:28:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B91B1195604B;
	Mon,  6 Jul 2026 15:28:07 +0000 (UTC)
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
Date: Mon,  6 Jul 2026 16:27:17 +0100
Message-ID: <20260706152737.1231312-3-dhowells@redhat.com>
In-Reply-To: <20260706152737.1231312-1-dhowells@redhat.com>
References: <20260706152737.1231312-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: IhZhIDGauA-Hh4MRck4Kfdi-8qXnMv73ahaFCBAL-mY_1783351696
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7DE4440008
X-Stat-Signature: ck8ahno581rh7e3j39d96ceu5yj9u5yf
X-HE-Tag: 1783351705-796003
X-HE-Meta: U2FsdGVkX18EyoyuFhYNAMkWyjTiggH2wTl7ayk7SvNdf5kXVgnxptILDARV94VX1lpuyUypQ4a10HQhM+em5Vqwrg4RJajm06pIOJr5DOjQEZeDIDPFfEyEhdW8OQH/kjGD25dWUk/KcAjs2sWW2+InajZDHdYITeO1euS7ZQhL/dRMP8kkc1SZzae3QF1sQJNiyZMXOtP/wZ6RqirsOIzp485F9jNqWpkdN/mp9I2MX3anzmJ9xcqJztgFJmtGw1lSfzkbaKVOq2EBRIQO7ppiIZhQdxNJmiU1POiN2p2gBQ3mg46cQGMDhM0Z8EvBaomAznqKKlSGLya+e1UJUtmvjDPWE6ZnHCYhcjmBrB8XMh5T9Ao6U68ATrYtZ24l9te3MaG58+MsQbwVTboaGydHJzpzuEFXT1LeqT1Vq4ZIfihW5d8ef9hGJ5ThMWj0tQnUt3YvdrQCQw/d0zt6O7VGJvJ0Ey1KAzuOZ+rvDx0RtpqS088h/o4T4q20TPAyXN2ngcuWErg8er66ySTMjr4SvAyz1i1akUWIEqDxnO4Pmu31uMEz8Q2ydCl4SG3MDgEe684PlJVLIPqys9PK9ujtGELntKaEIOSYXm/Rpmh5GX+xd0TUiEUHsN13/Vt7j889R65QTgccdD7kID3qtc+erF2M6pqvasUz/dSgeR0vAk4CnpzPDbfM+k5dxjCWlPFL/WsbaxFrT2aEjT/1rbRWXMHsSBWd0caYjXzyFheRbmJPhysAczM9SUSXlxpsWHzFFJXV+JQyb5zhbGPfsquNxiYNzNOvOpkY3l9D9CjqJNugmZ6vo4IxrLj9zxkV9CZE4kVj2yUXthOKg16bgVBJyIOhJt0FJ7v15fOLCCw7RmjoMhvdWfLNfMRNQ+mAV4+BXM7rTI/iQXrROo6QiECBezVjPoeZ/tYjoJqsIXBEEcTT8T75s8dXiivs0O9AjgliKTXGtufo3yLPig/
 BJiC2xi3
 g9UjzN/4bHo1veOFdi4C6Pl1dddxQGJtprmjCsjLzKdTzNHtrbagVMEiG4RHGwfMMtZUnmDWs7+meSqQDVnnXEE5L7YUiINLEMkYduAvUZqOR1kPbaD3sujgezCoMXpFT0nGKBODO9gLuTuQOGVeATfvmZTMX/76VKab8FiHViuKrAD4TYLkRmW7Av6vxt5ayFUKuQgJWR4MY3lbW9Iax47qQPAEaMwrQkYRCN4o8RV4AuyzN2NbdawrHGYBkHEupbPkmywt/u3Ak+lbbuxdYOPKxxx/nWla/IcVbnPNvqbJvWeNIuBTrUV92hT3PbFzXGEMA6sSy20oyVqnVX7mYJENzyDkxZHexpKKUN91dj6AV3JzoPcUQlHMwt3xM712WEH10TJfh/kKOfzVcYcD88M+WfX9YY44dcbuhLv/33vobmNm3ha9ZoDr5D0hh1grf/cUU3iM7qoi/U3R7kpy7HAnUYGMC4bZWzjmzH+9WfBIjADVYywx/25zNBKHqSCn1lU5OJF8YpGRZvN7MlFsm+BsKU+lSNVgfNzUU
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


