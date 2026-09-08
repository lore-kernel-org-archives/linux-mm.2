Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43101C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B1A6B00A1; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652EB6B00A2; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590076B00A3; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38F9C6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D248120446
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:55 +0000 (UTC)
X-FDA: 85190027790.26.469972D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8FF1C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZJ1UnmfM;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858713;
	b=Oem4b7ajjAZSusn5Ux/VIB5ftH4V0BS594JKJ4CeeqYBbF7fjEz2rGtpFet09vybYks9vA
	eXzMrUO0UN9xEEn7dlsC/gUHvhgf8g6gbU9MJ88w5CVdPANQa8zkgpUp6aerq5JxDCs4A6
	TVLJFQDNLUlOvNaHoIu1SUptj9GeTj0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZJ1UnmfM;
	spf=pass (imf28.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxO7FEkCCz/20KjVrg30v5ozCynNyOtWLTOKJ0S48jc=;
	b=ddwP9QAgkh2VfhVKT2/fycIoCDl9lw7c3OCPZt81f/fWGnu41CQZg7UzGUOe/bqg3VWfez
	OEAVMlB1a7hywqk7cl7vPnXA0p9n9WmHPqX8Uzcm5cjIWHYSx0KFdIk/SbDnYm8oBjmtGR
	BqWRKP6doRWrjK5MACFkZb+FuBenmuE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788858712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sxO7FEkCCz/20KjVrg30v5ozCynNyOtWLTOKJ0S48jc=;
	b=ZJ1UnmfMG8zg9xOqAGcGEwCaSkXLns+ZtZxJjnO9pzGn44NpVO62SBFT2u+S2Z6iK8Hm83
	7cXXOskrkI7WXG2QHb1mYFc91zN6AsYL1bzNGOq1WAqruTjufB3pZ6QJhwFYooppalRngq
	vHoxX59qIBqU63CYpVB/481K35K6Nrk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-8YNJsXH9MtiWIpWsQgpP2g-1; Tue,
 08 Sep 2026 05:11:47 -0400
X-MC-Unique: 8YNJsXH9MtiWIpWsQgpP2g-1
X-Mimecast-MFC-AGG-ID: 8YNJsXH9MtiWIpWsQgpP2g_1788858705
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 017AC195DB9B;
	Tue,  8 Sep 2026 09:11:45 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 260CF1800605;
	Tue,  8 Sep 2026 09:11:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
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
Subject: [PATCH v12 8/8] netfs: Set subrequest->source at alloc before trace emission
Date: Tue,  8 Sep 2026 10:10:29 +0100
Message-ID: <20260908091031.1506798-9-dhowells@redhat.com>
In-Reply-To: <20260908091031.1506798-1-dhowells@redhat.com>
References: <20260908091031.1506798-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: NQDsvcIOQJ6Lsnia-eu_yPCfGG8hvVnbfV3pLp_TaGI_1788858705
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8FF1C0002
X-Stat-Signature: orn9a13dmjtt7trh9z8r17rd3a1o3h8d
X-Rspam-User: 
X-HE-Tag: 1788858712-142030
X-HE-Meta: U2FsdGVkX1+3HuvyRhAisozxZhj1Ub7InYok6KZs8QhzrmvY/FTVMaupwdNUnN4F2MVT14r4bXRV/rVnvUFjwFGQ2KE5RCA2MCYiefzixB2lenNFHB7ybdBDMNGg9NVeatR9NpGOpxarZAoEDDN+WJIEm6YRwNMJw2GRisda8dZ3WDPlEm/HdiN8aZXxyGuKWqNiXx9zMsZOpE9AvfGFz5qpHpLbu94Is4k7w7DVWl35i4xx12vsKH/jDKcUFkOu3tpwbyhyyBwo0FI+K50A3m1ql93CweF9CaKjiJ2bXA/Zlf0KajxQpi7soKCbt9q73Tz9kFOL7E5djSEwNOZXy7aEQSK8aAtu36EGO3Ndc6BEzBIcJCl+HZvJnIRwsYCJ6lRoQVGWoezT3s7sggwI7blxlHvxdVA9NP1cFguyoVmfxKCf4Qp00UV/Bs4clROx58N4FqXANelkDjPAbQojRvvtArzY5UTKH5nKoZvTaMXahp2b2Ouo3tptXX/fRgnqo5FNkjclXjPYVWgWkEvgX1ttcT6TLP5mSrmWfw1vf8zc56GeZrrPizVeaPpEnLNariOmGF1B9jKHYrRl5C2jyfC5XhTBKsF+O+nLiZW+no/yMrBAXqL74dYCUAB0+FoxFusw/pVeV84lmvbkBqECC/mlHhk1TpkRoCDjp7HjNVO6Ka/CfD3mnUO9bFURJrYRPBXHRBGmmzkGFAimqkStrCYKXNj/kBoHOolhlkDdx0hInkGvmapBxzhdFA0SlWCMqZgswKRp6419lkiV30CHzupjyCjWBQVQdn23AYa1QcQdocCoK+nLtuI5X3HDKxj5dmgqYbFnvEn3HbogGuTjDtJP5RdB3/oejEvP+JjCp6YBv1ANkT3tqteMsFq8x2O89qvPJc97PnaH3v7cYaFcOoy8GDlUUnRzO3MMon+hzj/rhytGxC8wEPGgobBQJ0kDplVdzfhVJM4T3V0/+sG
 E8LEQYaQ
 OvfpHtQ7A9SQoRQrfXS1tjqCrLV6ojm9JCiMI3NZR1xSoeGr2mlDahz+/4b76xTLYvQYZFqgJn5i5pvVgDezIVF4VDZmabkpdF06lAxpltznhUpk2zNswJK2/nMK7EolZiCT+97vQgluHSahoZX8N7qLl1c/oyVkgKBrc6sGrzNbVsB80Ore7v5IsznugtmFP2prI5oLdB8QLC4a31ccffGVigym4VWaJJ0+cHipKi6dXAuO7hUvcUU5bVlXg3c+ang2KzWpxtJS2Rswc6KpQdiB3mZZnU6En+YWBS+u3idZvAyGcrAZpSWnhYHQ6uRj7InjDECOg84ehnY4pbTW4ofKxzewJO3+jzwRym4IJdP7eO7WeJnWnGtyh+u1PfOVzu9zfgEdSQqmmWJR6tp8pNDuKiZ8420pXZGlQSyJtsZS4ULtd5deSGraBd7BKQ2KtKQ9d/Ry2wsH1NUUk8c6bgFIqFgssjpYpNVfM
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
 fs/netfs/read_single.c   | 2 +-
 fs/netfs/write_issue.c   | 3 +--
 fs/netfs/write_retry.c   | 3 +--
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index e7fa30376862..f88b87c8303e 100644
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
index e0aa0ea510e9..ec520c948420 100644
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
index ccb5fc809d99..50775370d13d 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -92,7 +92,7 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	struct netfs_io_subrequest *subreq;
 	int ret = 0;
 
-	subreq = netfs_alloc_subrequest(rreq);
+	subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 	if (!subreq)
 		return -ENOMEM;
 
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


