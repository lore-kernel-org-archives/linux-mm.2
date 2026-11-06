Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317B6606D817
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AWU+oP3u
Received: by kanga.kvack.org (Postfix)
	id 561B96B05C2; Fri,  6 Nov 2026 08:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512376B05C3; Fri,  6 Nov 2026 08:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4000C6B05C4; Fri,  6 Nov 2026 08:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E79B6B05C2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:20:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4293C0D7C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:46 +0000 (UTC)
X-FDA: 85404754092.24.A806A8C
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DC0820006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWU+oP3u;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971244;
	b=KjiZJgXrxLvv0eBCH2IhlpTcdGeKHQuEY3iICfcyQADBj/schVD0/Pq7+8juVlWxBPen/P
	ARuFSsT9b0ei1GsyDJCcyNG9luyH+qmh5sgBEv5gGvbPm4CNoJ4+QMiEqVinYizOGnS+6q
	QJc85x9SQf3IQHnPKDJXTGtk1NpFfPM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWU+oP3u;
	spf=pass (imf13.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUXCYLhn52D7jjqtCGZ+7rWovE/XUiCSennV1JjWXTc=;
	b=GyY3hgoas6XECUC5BRRnj9bglD6kgi9aOUdvLGEFTHvcv9iSuvwMGzYt0c5tr/V56PLY+F
	CrNEZFZ2YG5uyGnUwBsMGFSFUU9hooXDFbP1nJ2fmOQl1dhnSOg+HgbrRctiqxrn26Sr85
	pqVaVgEWl0YK8lC2aZklOaiEohAhIRs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ojgBXCCljWWMx/by6O5nBZ1cYADUOJnAnHqRvmqKFno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971243; v=1; x=1794576043;
 b=AWU+oP3uE+Bp9M4NHthTv7q7awqULRAk7AJ+yUdGd8HP3gv4OZ3L3y2iim+wbp8ZY+SmjP6f
 RQOZ8k1aHyjLLkndQT62PYK+Mb5tL6fxCe7tCZ6NDOnwdYBj1Z+KZlsMEmliGrhC5h4dkKcDQnt
 /zsj+KNoWYeiGHHuaHTmkkzg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fd2f547758ebbf7f;
	Fri, 06 Nov 2026 13:20:43 +0000
X-Mizu-Trace-ID: fd2f547758ebbf7f
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
Subject: [PATCH 6/7] io_uring: account the ring context and SQPOLL thread data to memcg
Date: Fri,  6 Nov 2026 21:18:28 +0800
Message-ID: <20261106131829.3228926-7-cui.tao@linux.dev>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DC0820006
X-Stat-Signature: c3jjpbzr5c8rhhimfgjs5nqrt938dbs9
X-Rspam-User: 
X-HE-Tag: 1793971244-634513
X-HE-Meta: U2FsdGVkX19Hhz2NJOruxTn5RdvhIbFP60974wDNQ28zKIJsHMd9j3v6MmeuUmKFwEu9n3eJroJ3EA9LlyXmGbIxTDNcugeeK618S6zLvr7MLhIrXY98ClPX4QfWeihf8dabeki+3O/ZFlEcAF4UDWh2rFiCKXZIYvMcM0zlgpfcSgqXH2fo+Css2egly0pOkopkk/oKWn996V2AMh3jpfZ1PfOEQQ4s49mDhXlkyHaExOJXdH7zmLrgGCPqVVOKjzgrD9RvvDNo7mNJWwxe7ic2YXgkxYeFTiGWPHf5hXtlENGkcqdq3qrEtGEdMcwgeC6iKQzmCF0cOQRtLZow+I87KU8PRFSsWuYbPKcpM2AHMeiwrQBNKvSKOGEc0fNiCGpEGt/56vv+EG+ADPqm1ESqWApJLGFawWAETGwiZaQBdZra+8K6z3z9FXm7b3up9RMGpk9EgNqgwT+flup+n4MUvtlMnX9+efO5C3Sa0Dsx8SZIANTe4sS/aZJtCisjYqdoS1ABpiRNOvgsgLZiEx8xMj9GmUQofty7gZx+EKOBhL/Y+PkdpoRzI/bDIA8pPHlj2w/3nYnGeme5qfZrvkWd9ecG7bzl9gYnaH7XmebWoyq5sd1clDnTxxysu8MQ8Sk3ksw04V5gOe8YYsxifnpLQMSUBHz1KgzUYpRl3HmAVk5/gno2h9uTCG4YBkFODItaAfT/wMFz0lu9FAz/pcWyVoCbg2YtWxVJm7sfOXbW5xVZQE69+vmJ74MekhSEEzZuJI4NBNeE0KvnEXO6A6Zdni1r279rNOqguXjw4LFx7U5GNZvPkOrdI9ITBzT7dVV3DxGVQQxfisavN3Pg/fb3nGVOuIaSfTVHW4QvRepb7ja3ZK1XzrBBdilHXOG2nojoj/yzo1WEG2TjfewXLe/5IIsrlWPUpchLFMrNwbJEmbYnkP+rWbcwy2VlY77F2EhPmp/L+5RTh0jGQ5K
 KIlB6XuV
 +/kYnEFLyI81oRczXLWTYFNLbTGI4JGj1ZNqzxXKMXDM8cxdoo3FhKoEJKev0DVhDFdQG+QnITy5eHFyWa+uIMr9bcTBnSHumwlYYolqMbbUNUqJKR7C1G0oWpaLXOvRyVJ6uF8ufTfOnGShWh9qMW76uh7v9DVW6KPvqXjC8Y2ShTk1AVOH0wH0x8qJox3wCVPj4JfxEh4Q9l+sDzJ2EtbxJDOWiUIYnxnml4S7mPxluVd4swuK/vDXrJKxYkLo82CqQ7rCO/VAsTOBV5suM1xgmytI7Byqp9Af46SncxwBHfTyJTrXuy2NHEiW92HicN3jIA+FiFjz5QYVWaQnued2vuMwxKmDYrb9NxLSOBZ9GHvrnx/qMaOTKwq7TVa4C9R8taz6uU9XSKvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

The io_ring_ctx and the SQPOLL io_sqd are the last per-ring allocations
made with plain GFP_KERNEL.  The larger surfaces around them are
already charged: io_mapped_ubuf and io_rsrc_node since commit
075d5837bafc ("io_uring/rsrc: charge buffer arrays and nodes to memcg"),
the tctx node and its XArrays since commit 0b34e7b20a48 ("io_uring:
charge tctx nodes and personalities").

Charge the context and the SQPOLL thread data the same way.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 io_uring/io_uring.c | 2 +-
 io_uring/rsrc.c     | 3 ++-
 io_uring/sqpoll.c   | 2 +-
 io_uring/tctx.c     | 4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 03724419c4e1..d39cdde49a9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -229,7 +229,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	int hash_bits;
 	bool ret;
 
-	ctx = kzalloc_obj(*ctx);
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e0345c3e764e..9a971c983686 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -825,7 +825,8 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 	unsigned i, j;
 
 	/* Store head pages only*/
-	new_array = kvmalloc_objs(struct page *, nr_folios);
+	new_array = kvmalloc_objs(struct page *, nr_folios,
+				  GFP_KERNEL_ACCOUNT);
 	if (!new_array)
 		return false;
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index d387488db2de..b82d3a285337 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -172,7 +172,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 			return sqd;
 	}
 
-	sqd = kzalloc_obj(*sqd);
+	sqd = kzalloc_obj(*sqd, GFP_KERNEL_ACCOUNT);
 	if (!sqd)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index b4fecea3ea47..6673393100ec 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -23,7 +23,7 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	mutex_lock(&ctx->uring_lock);
 	hash = ctx->hash_map;
 	if (!hash) {
-		hash = kzalloc_obj(*hash);
+		hash = kzalloc_obj(*hash, GFP_KERNEL_ACCOUNT);
 		if (!hash) {
 			mutex_unlock(&ctx->uring_lock);
 			return ERR_PTR(-ENOMEM);
@@ -85,7 +85,7 @@ __cold struct io_uring_task *io_uring_alloc_task_context(struct task_struct *tas
 	struct io_uring_task *tctx;
 	int ret;
 
-	tctx = kzalloc_obj(*tctx);
+	tctx = kzalloc_obj(*tctx, GFP_KERNEL_ACCOUNT);
 	if (unlikely(!tctx))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0


