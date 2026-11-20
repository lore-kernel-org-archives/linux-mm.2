Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC836606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XWLNBU2n
Received: by kanga.kvack.org (Postfix)
	id 957CA6B00EF; Fri, 20 Nov 2026 00:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92EE46B05B0; Fri, 20 Nov 2026 00:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C5B6B05B3; Fri, 20 Nov 2026 00:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54A616B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:45:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C39C216054F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:45:55 +0000 (UTC)
X-FDA: 85454411070.28.9656720
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf02.hostedemail.com (Postfix) with ESMTP id AAC2B80004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:45:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWLNBU2n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795153554;
	b=LLQC2Ikj27RVur4f+oq/lX2q37B/gFYHLu/SlkBSILTxo+WKOZN4DVbKGRtevytL94x1JB
	+36+feFStKFz2WgwDQN6rrELUCGqlnr8mGzN8fSZgZ0Xh5X2Prvh8+qQ2+ZRJwB3D9chkp
	XkEQR/4+pJhDjCfMwCK8jNaFT2QH9fo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795153554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vQWVv+Wg/WG0fo9yZQewcLpDeRqvrAZXwdWLu1wXdIc=;
	b=5j04VsPQnRRUbWxSenzgUAgcBRN0sPMac8Yv0+1w54FFy7DCiX7sgIpEVndV2Jrhct2zwB
	Bg5SFrcJyYGDRDkctFKoX4WuhDyZjC6CfynmaWQ0sSmrHDqQ+AHOCH4GXAapVbrj24nal6
	Fxz7IV+MPDQ7PO78sv9nUuL9iiHMjTw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XWLNBU2n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eSR3rU1fyPP9d9Xw/Xci8K+WmM5Afd8iPXlwguo1i4Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795153551; v=1; x=1795758351;
 b=XWLNBU2n70Cr55/Q/A9rMIW0gC5+4McEXcH2rA1M97NSar8Mxsdg+sMsH4XNE6/W+K0GXqPO
 1oGPkp3KUS+TrOJJ9zoCR9dQPOjJVBQCWPOKgN4jDThjUI8MPYHlkYAfVRYdAvSEeYc/eI+3XvL
 PyZSka26LAzW5BA22sBIRXXU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 42a3411e7df6d71e;
	Fri, 20 Nov 2026 05:45:51 +0000
X-Mizu-Trace-ID: 42a3411e7df6d71e
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Andrey Drobyshev <andrey.drobyshev@virtuozzo.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v2] vhost: account the per-device kernel allocations to memcg
Date: Fri, 20 Nov 2026 13:45:17 +0800
Message-ID: <20261120054517.526275-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 57efdfyfiygm163y8m8ehogqoiq3w479
X-Rspamd-Queue-Id: AAC2B80004
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795153553-649571
X-HE-Meta: U2FsdGVkX1+/6YP5BfVqBpVAyaNYkM9wF8E8QxwwHi7RYjY2eD6n3zmthyC8ipHGYhnReGIz1/o77c2tCnGISoWYuwWNqe+u0AZXlSZtZ5GQRurp6/BPNin1DAh8oOzrM08/sspp+yGRFKV6STp2jaGZVTWyO8MiUxNzuo77mjjcFm8RjaDjd8tQIPXBEx3+tGPwdF98ZSbzzJbD3kFLPnnWw6dJjYHQnKAmJjh8uGImKx/B8poUK9VUhoEB2DrZoRs948ZQwm+HJ6pfNyv+TDiVRJU8uUjxPyWksRCeqecSaeLd8vBWFSVL+YY6NcGF9HqDfAIWLEGFNkxcmwUK1AL1min3Z3PlPTq2waGzAmUNuoI8QbO7Axy+hTTn/2KOvwekdewcma6hn8o51kbOaAbuH/DPgRM3CQI2McjvlN8N5n7AuTPxBCNnmE2N00udY2VOg+q2svZQdc9LHJy6VSnY5SEgfsd3o+08WL6MIuVNYqlQ/fsP5/A0KkrK/glXRgJjeoZfhweTp5GmZVztdeTwCTCcPkV++qxSySrK/sjMiYUNR79g5RoEJ0g2R8iicY9PxEfXIq5nX//a7s4zUCB2CBhthv7PeTdqsWwrQRzw7WVFqFDcVzE6+DHcSZodaj8wFzZEGOsCdx6pFJjnKjQAc/nBttWYv0udEykXV7/ku5oGBQygkFr7EWAV7a/hBp8FV75hY3EfM6QeVaGzPFLQbqZ1JWaUTnfDI2dz46cftUhOIWpKuU/WGRaXDhHBF5BweE4A+ChPOebepFhPibCNFENzKa8kUkMvYmvE666u9+yPJaN9mKUKYxWnRh1hHgwmzaMoBOVSOSPJ9EvdWKyFUBx+0mm+o2ayjVecTH31aXZE7a3EYrKofmhXb6Px31/JlNeL6qk1YuXXOeImzPZ7Ep7HvFd8fqCkYDE4SSjeo8679Ixjx3UT0WsQMFaBCgkXn3zdp9SOMILuybt
 PvWOqMS0
 mWH5aHY61LXaVs3w7nxgYNH13tzS362hpgqbdkz1oOxPLN8V9L9HZmLaYiBAkFSpbVG/+OIreDw9BA2FUmix4dFWRzMLwRtDfkfNUAJFux1kJVaP7eWp3rdJhWgsC2WgaywvBWZrOs/f2Z7yw7Kn9oiOI5qx1FLHbL/j0zP3Xmmn2/Mh8m0U8fwoj74lV1TxhMVIMX/mqMD4hMw17m55zSgKDPWpx03lxIcHwlXQRxeuo+tImZbjYRZ9SjFVEv9wXorkHUpTAjDoo/jJx4ZfsGfi/c9epccNd1MXGiTDJ7f+N0SYCnh7T/xxOwpnLjU3+GPCP7zgS0FozBlLNUUv1kvIwWinT2ZALUnOoiuKRA7gWfZZqmQ5jDSoqzJMtYBGhl8bp1u8J2XaK1Qrt5yTFFbIZ6s3pbLZkDLY99vty0UV2Gz8xQK9sQ1eMucmipBgi85uGCQsPpyAsy1uNxb35t1XfYP17xw1m2kscOPUwNaD+bbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

Everything except the worker struct is allocated with plain GFP_KERNEL:
the per-vq iovec and log arrays at VHOST_SET_OWNER, the memory table at
VHOST_SET_MEM_TABLE whose size follows the user supplied region count,
the pending message nodes, and the vhost_net/vhost_vsock device structs
with their fallback to vmalloc.  The worker has been accounted since the
vhost_task conversion.

A container that can open /dev/vhost-net or /dev/vhost-vsock, which
device plugins hand out with passthrough, holds roughly 150KB of
resident kernel memory per device after SET_OWNER.  Charge the rest the
same way the worker already is.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
Changes in v2:
- rebased on next-20261118, where the vq->nheads allocation now uses
  kmalloc_objs(); the flag addition follows the new form.  No
  functional change.  Carries Michael's Acked-by from v1.
Link to v1: https://lore.kernel.org/r/20261106131829.3228926-4-cui.tao@linux.dev

 drivers/vhost/net.c   | 14 ++++++++------
 drivers/vhost/vhost.c | 17 +++++++++++------
 drivers/vhost/vsock.c |  5 +++--
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 435d8ed3851f..390858056d20 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -249,7 +249,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 	/* No zero copy backend? Nothing to count. */
 	if (!zcopy)
 		return NULL;
-	ubufs = kmalloc_obj(*ubufs);
+	ubufs = kmalloc_obj(*ubufs, GFP_KERNEL_ACCOUNT);
 	if (!ubufs)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&ubufs->refcount, 1);
@@ -302,7 +302,8 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
 		if (!zcopy)
 			continue;
 		n->vqs[i].ubuf_info =
-			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV);
+			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV,
+				     GFP_KERNEL_ACCOUNT);
 		if  (!n->vqs[i].ubuf_info)
 			goto err;
 	}
@@ -1340,17 +1341,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	struct xdp_buff *xdp;
 	int i;
 
-	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+			 __GFP_ACCOUNT);
 	if (!n)
 		return -ENOMEM;
-	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX);
+	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX, GFP_KERNEL_ACCOUNT);
 	if (!vqs) {
 		kvfree(n);
 		return -ENOMEM;
 	}
 
 	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
-			      GFP_KERNEL);
+			      GFP_KERNEL_ACCOUNT);
 	if (!queue) {
 		kfree(vqs);
 		kvfree(n);
@@ -1358,7 +1360,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	}
 	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
 
-	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
+	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
 	if (!xdp) {
 		kfree(vqs);
 		kvfree(n);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dc973287567c..e8f9dce52aa7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -526,10 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
-		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
-		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
-		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
-		vq->nheads = kmalloc_objs(*vq->nheads, dev->iov_limit);
+		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
+					    GFP_KERNEL_ACCOUNT);
+		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
+				       GFP_KERNEL_ACCOUNT);
+		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
+					 GFP_KERNEL_ACCOUNT);
+		vq->nheads = kmalloc_objs(*vq->nheads, dev->iov_limit,
+					  GFP_KERNEL_ACCOUNT);
 		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
 			goto err_nomem;
 	}
@@ -2052,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		return -E2BIG;
 	if (max_iotlb_entries <= 0)
 		return -EINVAL;
-	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
+	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
+			       GFP_KERNEL_ACCOUNT);
 	if (!newmem)
 		return -ENOMEM;
 
@@ -3407,7 +3412,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
 {
 	/* Make sure all padding within the structure is initialized. */
-	struct vhost_msg_node *node = kzalloc_obj(*node);
+	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
 	if (!node)
 		return NULL;
 
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 88a310390eb0..2fa205967f8a 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -719,11 +719,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
-	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+			     __GFP_ACCOUNT);
 	if (!vsock)
 		return -ENOMEM;
 
-	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs));
+	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs), GFP_KERNEL_ACCOUNT);
 	if (!vqs) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.53.0


