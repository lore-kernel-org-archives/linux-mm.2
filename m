Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D98606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AeWGSHSw
Received: by kanga.kvack.org (Postfix)
	id 1DF2E6B05C4; Fri,  6 Nov 2026 08:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6736B05C5; Fri,  6 Nov 2026 08:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5F56B05C6; Fri,  6 Nov 2026 08:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E02A26B05C4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:20:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BF2C1C4880
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:59 +0000 (UTC)
X-FDA: 85404754638.10.1EBBD61
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E0EA40006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AeWGSHSw;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBQnCmi6lRqH8GAi8YV/xcgTg4V0TO+wKEtX2yDXFxQ=;
	b=69XOu7NRZ958Wqa1qy9mA6v0zzQr4E1QTuX03jQwRaif5lwiVxowexrlRRKbo1wY8c+SU3
	35RlwpZ0WyNCJcRWrF6B7m0M6tXUfprmvvMh5W/I1SCJomcXGohLceIq+w7hDx8tx1GAMj
	HPVRTr/bwHaw+jRdK9Sv+JTUG5hpzIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971257;
	b=MS4DmaRKEI99Bd+uz2lixGHW8hAa07ysHDmI1kJUMul8ZVCIKuA6XpfIfy94zw030Pq11b
	4bgAtoXAksFAD6+Z/6845hKjaGqXGhpEYqy5Wy5qWL9yooHid4pRJnNU0cc3De4E9UzzIG
	gx1A2xcprIbT1/cmjprp0+0CSSd3F+U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AeWGSHSw;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dKQ/3LCCVbNcrSr0Tnyt8Yullo0Ku/Vkln3W2FNUdns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971256; v=1; x=1794576056;
 b=AeWGSHSw5gCUCbueF62VSkT4cd4H1UWyOnuiftbsvsH889tMmC2ju0ZopLoCA7ztdQoWRGFj
 Ah9CMYssyGipSVl+fOz0aQ50JMH5mol+kXYjs90BTdwmZzGC1/1QzVy/MXrru2z9UISsupQEMQg
 oQNHTipoer+T01odkijK4tPs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 178d9492481963cf;
	Fri, 06 Nov 2026 13:20:55 +0000
X-Mizu-Trace-ID: 178d9492481963cf
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
Subject: [PATCH 7/7] io_uring: account the remaining per-object allocations to memcg
Date: Fri,  6 Nov 2026 21:18:29 +0800
Message-ID: <20261106131829.3228926-8-cui.tao@linux.dev>
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
X-Stat-Signature: 5pge353a3dey8h7cnt3qize9359tg91z
X-Rspamd-Queue-Id: 5E0EA40006
X-Rspam-User: 
X-HE-Tag: 1793971257-854572
X-HE-Meta: U2FsdGVkX1+2sQFmPkazDSumYVeguJFufRexFXDWcz+KwIjji8N/02FBxqA9acABb7m7Arh89DJ/VjwVMbEEmSHYvSK4TNYPWqTxJs+u/bUnv8x2uJPiRuYsd0Vf2oVRCiRth/IrLvoEcPE7Ar8MxZbTbLsjqrFhWWS7cA52Nz/hNogd/FWpNHeNDhsgGIuahp9i3AlB7iBUi5/Z1LA/BZBNdZixkBk7gPFUPZAagp7R6mpHucTzraYNSZzvcWC5uchIVMgVXaAbRbfQvK25McXUzsmwrJ53U/1eMRtcQaPsgWMh4gfYbnQl1+E+oL5sQnHarSdPBgCIX+SWtiKo55LfuorV1LIdMek4TNkuQJKjcqA0gLd/BNFZmC0GKKpAJy0k1vUH1draVGZBgL8k8Ol9FBpShuh4xmNpT61HzypLO7lEka8OEio4mnXgdWKJ1iCz2IDND05FGodNMCQUklMGe1OmVCtAFtS41Zi35+V0TDQ7ZyONz4WYzzKw4405RS3FqE9gdzCXs/pKA9ZcixmM9a0qDp4jZryLXhrVO5W0X44buR0DZU5FrFPg3bK+/5qag/qfHUPs3I0+srjiN+YhB/wuxez1K01CHp7ZMn8LtwlMvpAGlgeSSomZOAROjtG8xjLNFrZYdequVsiIF0suEr0kGV+mQVGvj4iwPXEA8YYT3czBwQzV9kahDZaXwsol0j8zLpSsiqrbRXViZlxM1V+B41GlUw8Ann8eyggL5/wj14nadYg+Q4E4fkWR9lc3aJPUQnbOsFpv6KK4SAxksqPAVD0I8EVshpREkMYv9hzH6V65ecQArXyNFtWv5+YhuE9GZWlCTCmMgukE5/vNbqR7qXrPzJvFTwcXmRQVRAnLAcVY8UHjlZ5GJnX8QJ8O51mgpU6uVu1v6WzvHPjNPXIjg5p3XayLzJt3e0F/CG50GuwynSLYt0FTK7ksg5UdOO2kQWoR9/QFlUi
 WnSAge/S
 qZLO5Q4OcCYeuWCriju432SZknKCvFRLHny4OBqPTp7wmP2+wq/OHcJhierq0tzxrlNGkiz4mxwV0+5xDTE4Yk6e0M0j6eWzyXaN4/oYo8oJphSfMZSYny/vaN+rI/xKAG+3H3CctUjw90Alt4YxrN2NLyICZ7aDqKSFu+KOlabWwcOz9iMEC95t7QeD1RZY0mj/UGx4zChTHp2aNBg9ZiBrjg4QYyhQSneFjHbp1ULeTwVbRq0azlNNlLHFXifA4586WfjHr91tL8arWVXXRY2aUUvD83qpJhZ3gN5bd33lJHRYyLlW594gRXfqhctk1sKRTijaCLMIGrK4qs3DjEX6IFo9w9KYcDCuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

A handful of io_uring allocations still scale with user controlled
counts on plain GFP_KERNEL: the per-ring io-wq and its workers, the
alloc cache entry arrays, the provided buffer peek and import iovec
arrays, and the registered eventfd contexts.  The tctx side is covered
by commit 0b34e7b20a48 ("io_uring: charge tctx nodes and
personalities").

Charge what is left.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 io_uring/alloc_cache.c | 3 ++-
 io_uring/eventfd.c     | 2 +-
 io_uring/io-wq.c       | 4 ++--
 io_uring/kbuf.c        | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/alloc_cache.c b/io_uring/alloc_cache.c
index 58423888b736..f41df1878633 100644
--- a/io_uring/alloc_cache.c
+++ b/io_uring/alloc_cache.c
@@ -22,7 +22,8 @@ bool io_alloc_cache_init(struct io_alloc_cache *cache,
 			 unsigned max_nr, unsigned int size,
 			 unsigned int init_bytes)
 {
-	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
+	cache->entries = kvmalloc_array(max_nr, sizeof(void *),
+				      GFP_KERNEL_ACCOUNT);
 	if (!cache->entries)
 		return true;
 
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 63fe6e5d79ba..52f5d5b85f30 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -132,7 +132,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (copy_from_user(&fd, fds, sizeof(*fds)))
 		return -EFAULT;
 
-	ev_fd = kmalloc_obj(*ev_fd);
+	ev_fd = kmalloc_obj(*ev_fd, GFP_KERNEL_ACCOUNT);
 	if (!ev_fd)
 		return -ENOMEM;
 
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 92df54c6f50c..98f3aa378baf 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -981,7 +981,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wq_acct *acct)
 
 	__set_current_state(TASK_RUNNING);
 
-	worker = kzalloc_obj(*worker);
+	worker = kzalloc_obj(*worker, GFP_KERNEL_ACCOUNT);
 	if (!worker) {
 fail:
 		atomic_dec(&acct->nr_running);
@@ -1358,7 +1358,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (WARN_ON_ONCE(!bounded))
 		return ERR_PTR(-EINVAL);
 
-	wq = kzalloc_obj(struct io_wq);
+	wq = kzalloc_obj(struct io_wq, GFP_KERNEL_ACCOUNT);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index abf44f5dba26..bc6e552a91dd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -288,7 +288,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	 * a speculative peek operation.
 	 */
 	if (arg->mode & KBUF_MODE_EXPAND && nr_avail > nr_iovs && arg->max_len) {
-		iov = kmalloc_objs(struct iovec, nr_avail);
+		iov = kmalloc_objs(struct iovec, nr_avail, GFP_KERNEL_ACCOUNT);
 		if (unlikely(!iov))
 			return -ENOMEM;
 		arg->iovs = iov;
-- 
2.43.0


