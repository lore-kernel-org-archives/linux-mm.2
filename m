Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C575DC61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB756B00B9; Tue, 25 Aug 2026 09:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44B86B00BA; Tue, 25 Aug 2026 09:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5AC6B00BB; Tue, 25 Aug 2026 09:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 832E36B00B9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:21:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEB0912043E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:21:36 +0000 (UTC)
X-FDA: 85139853792.03.C8526DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA930180008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:21:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tm2IMadG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=urwo1rKcqJYvUEIKJZu98ymjEnk8jlG/JZNDjgALfBspSN4KJPoUrNsubNk42xJcL5Dq+C
	YTw8+OSimZIH6meaFxhd6zZdlXzCLUuZm+k+5piQxDPApmsG6MvVFPSGVPXo80ykEL+QRl
	K0udNjywi+w4+SEV46xTvIm7zik/qYQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tm2IMadG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664095;
	b=qy9eGJ1W9nKAlKcw7ZNR17Hwi1xAELWxv6Id7nj6mTkNxRpHYhFm2YH/5IdxiDPgWgr8I6
	dXqKmIxJCzMsyaChtwmzs91FqjODXDNUHd5vLy6xYRbURyiQo8cPh4mSrPK7MLL/jxPVvl
	V54tt9B8fqLMd8Mt2ymR746u2Fm5EWc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9iZolUQoXRsjj7Xv9NSqZ4No1AkzqqiBCElDUTpjbA=;
	b=Tm2IMadGMbECLYwsR+ouTp42492jXEB/xwt6y8vta8H0hGHmrosmAPu/tu8VfEs47ubi6x
	FoOKqVnqX6RMR0OLkM5MRjIfMnEbjLaZYJ7Q8HsSZ6EHRDAUSybEVnWNiw0whNHgoL7xDy
	JHTUWYOdPAFxRZXBTmOyDIhqw0VY+Nk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-275-Wl32SQHQO_SZnzAOPr6cCQ-1; Tue,
 25 Aug 2026 09:21:30 -0400
X-MC-Unique: Wl32SQHQO_SZnzAOPr6cCQ-1
X-Mimecast-MFC-AGG-ID: Wl32SQHQO_SZnzAOPr6cCQ_1787664089
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68D9E195DE0F;
	Tue, 25 Aug 2026 13:21:28 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E137A7D6;
	Tue, 25 Aug 2026 13:21:23 +0000 (UTC)
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
Subject: [PATCH v2 7/9] netfs: Fix readahead synchronisation issues by loading all folios upfront
Date: Tue, 25 Aug 2026 14:20:41 +0100
Message-ID: <20260825132045.1000787-8-dhowells@redhat.com>
In-Reply-To: <20260825132045.1000787-1-dhowells@redhat.com>
References: <20260825132045.1000787-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 1apuoORV6k_JcZTremp5lMvCA5Ru3h6nslpfqhYQgwE_1787664089
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: CA930180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8iqxkht9qnc686d6x46mctcwo1rxfmsa
X-HE-Tag: 1787664094-13002
X-HE-Meta: U2FsdGVkX19/vIuVKrJAihWspmeVFsBmpFFzMUAnS01VYtzhYJ0XQcca4JPjWvRWk0XHl5SPvoB+bkEvWed8Pq9FN6jE1TrrGtgewOAERXBoLsF3H+ZRENr8P3t/rNtd8Zp81nTk+FGzx7fiYxTys2q3NJw1opyXC/LY7mq13rabUKv6n3R2vf2t0/1vRyAwOTdKwsiPHoR/PK5Y/YYSXDEmXHfJdlKgxBu8zRwlueG/at1jn7gbT6n8CSPnFYNxC4WUKWLh++fyjh2hy+SstbYN1ReC8V3pxB6mjPigWKQdxXC2aEDGbcYResOxEKrldQhcjV38AzderKsan+EsLhHOKzjNfMfiWFxgcxOb2CdVGJwb2qpC1zx7Qq51g6IAukQxmAPVtEVYBkwnYxYIV/FBgfoOKjuxw3Kcuz2ZkzZbT/sOgfWyazOOwmYYjmnhkE6innHrlgTl8IG+a6U0dwH+4LElDX9A8Iz8vFe+Q+3NevBbacfujIAuiH4lucA767T2lP6gw3ExClUmGT9GwG7a0x1rC6bjjyp7A0E4KijDpdlffnSLDkkDsTzwKKh5Xn/TyJIiMgjaIodghscVQWo8R2HOrbYYVAuZFiBMRxaZkb4E8mBXmRjM8Kclrtp1Fv+j+C4iVbkbFbZZDHC/AIAsUZGeGeEjvxJWcPBOfVKHH3ZR37BHqqU0RbtPbLMyLsrxhdQAOkkLUOQLybBLg5u4GcpwhZVNrHfwStqDuxa9rAinXGSroKu/AXB/FLHJBee9Ch5l7GmKTTiWB+goBQf0HXl1eMoSvfeY9q3PvDaMJfGOiju88wsTGrwa5kK2IYPIPCjzyBz8DDAL3L1LDlQBFdWcWKuUXqJfy/RUVRFG3lyVyLpBDNgV+g11gsy+lN5lG1Wgg3+tE290QI4XW7RaWTNmWnb/ilt8C8fr1NKsO6Oj67U/BhivLbKB+9Vfjq8w2sgScVRNOTljts2
 mtKcXdhq
 CyDLWwJT4T9Xpo2Qs8mB1zgR7gPkpmblurODPpKgxTcLVDzN10xRgl75QYAV5aNic07NX+Y1iV06mbFzy+Z+X/f036G3Xe1skrvYQtdb/jYEWcIwWxU96G89GQe8QorXVPvaOuFOnEqfVtQ/41QkiDu+s1fVorib5BjsIfH4qKxj3Vki8CjePaydbR8vkct4FukdWFJB7p4lcZX0PW2O2xu5Y7OqtApphg7hVC1ei7TV+HKZgPl7BLvS2vxocP1YwXR7U9J2UEJ0djYN+64FnX0C64pAWH4BTzlOA5QycibjM/Zwl/U0OpWpPP0Ko+sZjtYlFzUro5J/1kHq24/kR/3LFT3UWBjIrEVF0NIbHIS0kEKp0GVNGO2aQ5FIa1RlOAmQCsrBNaW3tj0RvjvgZgTFQsESSXJmlfLn/ZpoGMy9CWgGWbrxR/hZyAryKQg/pztcweSN0VmgDtpickwU6R4f26dxVdWk8YygaVPLXgGd5y9U5NlaworDfQkSWBarGP/wDjWJjcl/mNbpZ7ar2jGdFZHDNUKHA4Rhm0na6sd/ijw4ituGSnMU/G/eTSyCacILqlPd57ErGr1MtsRi1QZCRYisDs6nff71U
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


