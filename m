Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B538606D82F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OBh2yzfS
Received: by kanga.kvack.org (Postfix)
	id 49CCA6B05BC; Fri,  6 Nov 2026 08:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4737C6B05BD; Fri,  6 Nov 2026 08:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AC36B05BE; Fri,  6 Nov 2026 08:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD8E6B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:19:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CBB4160D78
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:55 +0000 (UTC)
X-FDA: 85404751950.12.C90E80F
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	by imf13.hostedemail.com (Postfix) with ESMTP id A573D20004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBh2yzfS;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYfB1FwPouVvSzabiejXQPBqorI59dDF0aM5IPAqcsI=;
	b=FJYtmV17Lq+vxerfU56B9kC10aBjrOpbBzW36KZKjAx4RtyG1CiZAbm5W7aEM6osR3pmG7
	lEdxP28psbPXpydhoxaC5F3bFH2JUMJtqdleX7kHZocqtGGJjd28R6AyZ6G7PJDGmMrDik
	QvXjF8MjtNBNcMdSdebKsOZfv+a9dn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971194;
	b=v8r0j7L+N8xnku2DyQzdcoyLRbi+ztgCJ+0+MJEpwBd4JssX2cfPmubFZVRlcUsJi+Z+kD
	QX2ldDt0M9SwRfQVOwN8Xn+wpUn2zEHHXFA6jOFFf2mafflOMxIVX0u9rpn2fBowATJ1qU
	uxQBAumL7C/MvE6fbxlfSeKqEghCzsE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBh2yzfS;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=73QCibDvpuaBGtRTNbIkxL+btURCG2VkLUsjiT9bmAg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971192; v=1; x=1794575992;
 b=OBh2yzfS4sOkxhGkT+JBPca55NoqbHEL9VIcAcbEj1J1rXgOoQHQgV3Mcnc02kQNXVO902W+
 noDVT/X6o8QePW+IXif0wVhRtAIt7pCstFsBd5LRqmTL17bi9HehYz49UEdj6gHklLbJYcIOxCM
 FPVWpW0g4r5YYg1Ao8bNZ4dk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b2c073d8feb08521;
	Fri, 06 Nov 2026 13:19:52 +0000
X-Mizu-Trace-ID: b2c073d8feb08521
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 3/7] vhost: account the per-device kernel allocations to memcg
Date: Fri,  6 Nov 2026 21:18:25 +0800
Message-ID: <20261106131829.3228926-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ys8iwf8y4fx95z5i8i773itw6y1r3jt3
X-Rspamd-Queue-Id: A573D20004
X-Rspam-User: 
X-HE-Tag: 1793971193-853745
X-HE-Meta: U2FsdGVkX19WGcY0IcTxWuLAnWh3D1CRpwNlducNPTOqmMv8rptej74NO5M4UChJunmOGP2WMwCe6rJXrbD8hBj17hJgZM3QDml+j+0XTfyjjAmVUn0ooox2JiLb2yAgD1XiD+gVjyyIM/SQGDaQQHPh2VoXbotzgp5BYLn8oW9Gy34CA75ep/NaoWjR9e8aiO9e0Bx9kZDC+oUXyO8BZ9XMIAGQqS20r8RkkHzE/M2Y2wUMCscdX4KUycPStjNrkXjTqZoEoYlF3ErWMZ39BoNqBpbvTVDw3hOUa09XqquTMZANHBjSVJo6wvZFXFarY2TaDi2A4ilzYp/fXbeUQQAweXqpv7LG6PgCzTagnKxmzSANN1m88S3WepEMCtrrunCghrrqhwLDoiEyETJWeWwCRjSfxMzM23JL45by67HkFThEbUhTVZQZrYgTBPMPdCshSt02QnVWLRhbeKfrX/Zd0ifg9FEiPhPn/0mZo70sjAPXNTK6mRYJ5vwHTbezhTgXTvi8gUGQM77OhVPHOIRgF7Z2VuM/jLQiAY6Lwhi1S3iiF8J5i1lb9smpptISjBV/U/YLFa+1z94Rr8+KPvIaPKpt4KP+iO2Z0AEismqvlMKHPwLsqtkS31/AHpADgHZTJoYWipUtubV1vpaxjWxEDV5KzOwQUiJBitzYh95zz2soT+H45iOoOD9NUwCbeCHte3kqNiidA59v2n1QZkxK4zCFbKoUWx3RhmiwHNznP0I4845OB5lud+GQxakRTgnWBVgBUECTGqNWCbUwwQlH0poyuUGzBXv4/VydSKtXFVGKtseVJ4BczJnG9NyvYvLI6yp5v3PeIEUy5oiuOCZB+J9U1iNDzPOmrlDsCFiHrRLs/3kLTOHRjPfIaRzJSWOE+pWT/Qf441+VrFFyeB0mrxv0DoT52+EfLAlnAPlVBHByZYZm2pai5HXxbWrH0+SzD9mAH3MJnW3NvVT
 RkNGXbGe
 xlG0Txp9IE07VyLPEOdoJiV4pCGKvibrs52EgbvFPNQT/Au0BAt2jTySWNeRG9DGCdgiqZYaGPtErTnXXFt5I+3iFfOUFbaMICBR02sRjMCQvhFwOXzw9RzCxQYs8N8MjA3tkj6ijKk7zjdC9az5h8FPvrKTzH1KW/K6WfBKlhKruhCNaUx8LGZBlxU9ldnCIyP5EOHW3uUqKPhqLdFeCh9C7WajZ5F1/+M1L6dI9UsFqay7SYCTVKMuSIzFC3DVSKzACd9Gn7VpjAz+LEEuGUBxUZ9NpM69HGB4e0VpI31OhvgiLq6NwpJmcSQ==
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

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/vhost/net.c   | 14 ++++++++------
 drivers/vhost/vhost.c | 16 ++++++++++------
 drivers/vhost/vsock.c |  5 +++--
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 4570a4ffbab2..bab6597c696d 100644
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
@@ -1344,17 +1345,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
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
@@ -1362,7 +1364,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	}
 	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
 
-	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
+	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
 	if (!xdp) {
 		kfree(vqs);
 		kvfree(n);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ea127af58ada..d1274106ad5d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -526,11 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
-		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
-		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
-		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
+		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
+					    GFP_KERNEL_ACCOUNT);
+		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
+				       GFP_KERNEL_ACCOUNT);
+		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
+					 GFP_KERNEL_ACCOUNT);
 		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
-					   GFP_KERNEL);
+					   GFP_KERNEL_ACCOUNT);
 		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
 			goto err_nomem;
 	}
@@ -2053,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		return -E2BIG;
 	if (max_iotlb_entries <= 0)
 		return -EINVAL;
-	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
+	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
+			       GFP_KERNEL_ACCOUNT);
 	if (!newmem)
 		return -ENOMEM;
 
@@ -3405,7 +3409,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
 {
 	/* Make sure all padding within the structure is initialized. */
-	struct vhost_msg_node *node = kzalloc_obj(*node);
+	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
 	if (!node)
 		return NULL;
 
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 0cb87971d749..600daeb05e7b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -721,11 +721,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
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
2.43.0


