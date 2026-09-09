Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F31DC79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787916B008A; Wed,  9 Sep 2026 03:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711EC6B008C; Wed,  9 Sep 2026 03:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA576B0092; Wed,  9 Sep 2026 03:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEE96B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:22:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 704EA120120
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:22:35 +0000 (UTC)
X-FDA: 85193381070.12.00F7A7C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A014160003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:22:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NgGQP4Ox;
	spf=pass (imf08.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788938553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xgppktK1ya3AHkXZxi9vPI0IjVoDDvwcSOEfPSvP+w=;
	b=kteWBf64lzcPxHb9QOJiE8YQVwWzPETQF6Uelv77qL9WprTeEo/hihB1M5dqoaY+79Ml7N
	iC6uG2pfEj5dDe1+hP07AYrb4D3NThDJVgzjICUnUUhHLdvHaYfc8ltK++Ut7NglcNMfRL
	purJc9PGVhsz2nSv/nVXahb9Lo+JWzw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788938553;
	b=oqIyPiPSFJHXAhxl5Q7W4ieOBxehJBA3Vziw9Up+C/6yThpwpVSxsDVErV6mgqsYmbSbKA
	7uBQFNPnI+1sLZ+l2oJq9g2qmcPHd999uf9AvYVmEQoTxRJ21AmUTFsAd8TDBsgK73/Zqe
	NTe94Z09iP2p32U83jD9AxOGBMOZGfM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NgGQP4Ox;
	spf=pass (imf08.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xgppktK1ya3AHkXZxi9vPI0IjVoDDvwcSOEfPSvP+w=;
	b=NgGQP4OxowyKsuQEeiyP2qnAvXb6SxAMeOvMTaSLqCz7+HXs2Dc4ICyH3bHv6ojDJMhz+z
	U6QCNRNO/tD0m/W1r+iDUFNY1EN3qRu649TzTd5p0gK6n3zJbQ4R0rBaDE5R4XdatEFqbE
	Ru6LA/ugJlQw+8+rCCGYf9kwQX0Q10o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-jc9DiHqrPbe-2bcDCqYZSQ-1; Wed,
 09 Sep 2026 03:22:27 -0400
X-MC-Unique: jc9DiHqrPbe-2bcDCqYZSQ-1
X-Mimecast-MFC-AGG-ID: jc9DiHqrPbe-2bcDCqYZSQ_1788938544
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D94681800598;
	Wed,  9 Sep 2026 07:22:23 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57C9A195608C;
	Wed,  9 Sep 2026 07:22:18 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
Subject: [PATCH v13 8/8] netfs: Set subrequest->source at alloc before trace emission
Date: Wed,  9 Sep 2026 08:21:02 +0100
Message-ID: <20260909072105.1663687-9-dhowells@redhat.com>
In-Reply-To: <20260909072105.1663687-1-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: AqcmC3C8BDm8tX2IbqX-5HZtDF_FVqv8pMhD23apmRA_1788938544
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: pqiiponz7a1cqyfbg8j5t85ggt91rker
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A014160003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788938553-237580
X-HE-Meta: U2FsdGVkX19/6Q5ZPrj+qD1wP86fd7MZyKl2k3dCCoc/lZ2qNg5dKTErn0BA52F+BZMY47+0isgWXId9urXtz7wqm30+VRXTACY9A9DSi5iFVM0aeWgYnkWLFVppxq6mHB6sNPGAcuq0w2GYkMH7wHZK+os8MIaxz62QNKClQtWqAyK3xm562SYotn0gETutMvwZlrQFLJssGzcsGR7lrsC/0DlA3ZqX6xCSvAofRpZPadzbqQgFY2fvg2yBjSDFAktRZxV3rh7yrG/2zdIFAp9AePh0oKwEtVdO1oRLK6H1srL59FlPhF5fUy3q+r14ZdYDCnJeC4BU4Zw8SVGZtMk24uIpyrzsDiWypcuDIlk0A8ujHxV4hNHon9rlXRX6mEbhvIRhyzL5ZbVPEEP3U3Vn5W43pgh6YI1U4RfhAGd/43+4P9wccatILqaLCYWWoM3iM26RYKwxtexWBYQo4hmyXSCGYyULs9/hsv2hfn7PFJ9+2IA2ae4C8zhRDGdUoUQCYA4AUhLzzYJXHXyo55vehaGP+hpz9weOEEkDkA7yKP0osueV9iRyrgJkd+V4vsyQwf5TtllREnhKjNpqp6+OTPuQ8In6nLVQFwWPp/wnZjZ3dCLBLLRuck9Axdjlp1EspQjzNbq7f+OXQjEi3RTNLJBa6vom3UyRDwUeYBxKN2znvlzFyeQkQkYayxcftxFEAFzbXOqttAX46QeueIBA0qGIV2qOoocEa0QGKK5NSs3m9OCicwuqj8PYWR4eZS7Kxp5z28f/y++7hRwOdVM7cYUaN+wLyFZXM5RzBTi8dCDPbrfD0FkzpJzY4JUIWNNr+N+s5cGSsNwf+hAf9n9hoQ2fG4DgOw/Qe4RZIojEWVHe3edxISo61ANXF3m0UecNnf4k4zorJ2GvS03d1+3cxC97iB0rPj7t5BGJbu7vRLyUjD8N/RAwN1Yc4lfVzd+RNqatD1TelbYwtlN
 ZgW09CbL
 A5D8a8wI++YdFoiJIPqHx3SQMC7W8IdcyUMpSyw8/yaAMY4a79rTUTFc4Wtzkg+2W5uD9hJyAAqtXGoDPWz0z+v46gwwCk2x9/TbMtUwaK4XlD7DztyTlQULzhm0X9xKKejLm/Aw0YvfhC0dP6syU955BoO0Nui7rdgOrSBErmCGzUYzEB1CPjx48/9uSC5iIJvsd5Ezeg7IyqyeVzXqKFbSCVUjTzEuA4FuzNftEEjV8Wv1d8nPx7Mo1M7d3TCTWnNgGUEwuIFzfCW31Pyqcu8b3MhrDf68OxKVxdlFlXx8+bpGRQcju/zqH4tOn2Mf9P+UCLsT/eChlmQtJNbK0RmW/pKgJ4uQhBw+N77CMEX9XgsDdDJQRJq+k/nMNikZVcAsUGRFnhH3Kv6V4GS4sMYmlt4TIZqljuKk3Pyl47VOggOL6DSY7tRgvTAV060U/bT4ZeHczkA/Qv2yr6VyjuLckSoEIsXIyfgRP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set subrequest->source in netfs_alloc_subrequest() before we emit the trace
line indicating we allocated the subrequest.  Note that this requires the
allocation of the subreq in netfs_read_to_pagecache() to be pushed to after
the decision about what sort of subreq it should be.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/buffered_read.c | 4 ++--
 fs/netfs/direct_read.c   | 3 +--
 fs/netfs/internal.h      | 3 ++-
 fs/netfs/objects.c       | 4 +++-
 fs/netfs/read_retry.c    | 3 +--
 fs/netfs/read_single.c   | 3 +--
 fs/netfs/write_issue.c   | 3 +--
 fs/netfs/write_retry.c   | 3 +--
 8 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 887d45f3745a..68496e1a171f 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -276,10 +276,10 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 
 	do {
 		struct netfs_io_subrequest *subreq;
-		enum netfs_io_source source = NETFS_SOURCE_UNKNOWN;
+		enum netfs_io_source source;
 		ssize_t slice;
 
-		subreq = netfs_alloc_subrequest(rreq);
+		subreq = netfs_alloc_subrequest(rreq, NETFS_SOURCE_UNKNOWN);
 		if (!subreq) {
 			ret = -ENOMEM;
 			break;
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index 5405e108b7a3..8c15f3079723 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -55,7 +55,7 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		struct netfs_io_subrequest *subreq;
 		ssize_t slice;
 
-		subreq = netfs_alloc_subrequest(rreq);
+		subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 		if (!subreq) {
 			/* Stash the error in the request if there's not
 			 * already an error set.
@@ -64,7 +64,6 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 			break;
 		}
 
-		subreq->source	= NETFS_DOWNLOAD_FROM_SERVER;
 		subreq->start	= start;
 		subreq->len	= size;
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d579c5d79609..4891e6e3c5db 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -92,7 +92,8 @@ void netfs_get_request(struct netfs_io_request *rreq, enum netfs_rreq_ref_trace
 void netfs_clear_subrequests(struct netfs_io_request *rreq);
 void netfs_put_request(struct netfs_io_request *rreq, enum netfs_rreq_ref_trace what);
 void netfs_put_failed_request(struct netfs_io_request *rreq);
-struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq);
+struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq,
+						   enum netfs_io_source source);
 
 static inline void netfs_see_request(struct netfs_io_request *rreq,
 				     enum netfs_rreq_ref_trace what)
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 3460aa1c4af1..9c6ea718692a 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -207,7 +207,8 @@ void netfs_put_failed_request(struct netfs_io_request *rreq)
 /*
  * Allocate and partially initialise an I/O request structure.
  */
-struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq)
+struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq,
+						   enum netfs_io_source source)
 {
 	struct netfs_io_subrequest *subreq;
 	mempool_t *mempool = rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool;
@@ -224,6 +225,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 	INIT_WORK(&subreq->work, NULL);
 	INIT_LIST_HEAD(&subreq->rreq_link);
 	refcount_set(&subreq->ref, 2);
+	subreq->source = source;
 	subreq->rreq = rreq;
 	subreq->debug_index = atomic_inc_return(&rreq->subreq_counter);
 	netfs_get_request(rreq, netfs_rreq_trace_get_subreq);
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 46810d29f0c0..396a05432a7e 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -195,12 +195,11 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		 * and insert them after.
 		 */
 		do {
-			subreq = netfs_alloc_subrequest(rreq);
+			subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 			if (!subreq) {
 				subreq = to;
 				goto abandon_after;
 			}
-			subreq->source		= NETFS_DOWNLOAD_FROM_SERVER;
 			subreq->start		= start;
 			subreq->len		= len;
 			subreq->stream_nr	= stream->stream_nr;
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index ccb5fc809d99..81295c055ced 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -92,11 +92,10 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	struct netfs_io_subrequest *subreq;
 	int ret = 0;
 
-	subreq = netfs_alloc_subrequest(rreq);
+	subreq = netfs_alloc_subrequest(rreq, NETFS_SOURCE_UNKNOWN);
 	if (!subreq)
 		return -ENOMEM;
 
-	subreq->source	= NETFS_SOURCE_UNKNOWN;
 	subreq->start	= 0;
 	subreq->len	= rreq->len;
 	subreq->io_iter	= rreq->buffer.iter;
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 9a528da4bf9f..e7cb496f6324 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -168,10 +168,9 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 	    wreq_iter->folioq_slot >= folioq_nr_slots(wreq_iter->folioq))
 		rolling_buffer_make_space(&wreq->buffer, wreq->gfp);
 
-	subreq = netfs_alloc_subrequest(wreq);
+	subreq = netfs_alloc_subrequest(wreq, stream->source);
 	if (!subreq)
 		return;
-	subreq->source		= stream->source;
 	subreq->start		= start;
 	subreq->stream_nr	= stream->stream_nr;
 	subreq->io_iter		= *wreq_iter;
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index 6cd584242af2..d7d5348496fc 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -149,8 +149,7 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 		 * and insert them after.
 		 */
 		do {
-			subreq = netfs_alloc_subrequest(wreq);
-			subreq->source		= to->source;
+			subreq = netfs_alloc_subrequest(wreq, stream->source);
 			subreq->start		= start;
 			subreq->stream_nr	= to->stream_nr;
 			subreq->retry_count	= 1;


