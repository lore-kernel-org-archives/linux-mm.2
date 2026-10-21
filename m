Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CC9606A327
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CIlEO3rF
Received: by kanga.kvack.org (Postfix)
	id E2DD16B072E; Wed, 21 Oct 2026 11:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05A36B0730; Wed, 21 Oct 2026 11:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6B96B0731; Wed, 21 Oct 2026 11:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7DF6B072E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EADA41C3D9B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:17 +0000 (UTC)
X-FDA: 85347052434.19.54A3063
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4589120008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CIlEO3rF;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGvKxLtVkj8aET1gCZB9vB9TUPm0s+OVrj/WLz6eC1s=;
	b=0URyMxuAmidmqhlGJd2+njQ410x5UDj0j3X5dnWBqsN9wfBIqJGyG4wFXpgFAcl1UYi4T7
	TGMBPVJFDzxu4ib/NUyFZsQf0sADQWmPZjGHa9DgWBKh2Z2N7afSFZEyszOBSo2ZRkNqx4
	ep6q2oTtl8wHnFd+bykgnEXEcHTLf+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597396;
	b=WoPizXx0e/ShDHPDqIwQptSFxnm95bYIZNY9p9Evh01WYpljHwQMzqcOhGO/b6isHcp/4z
	Di4rFFHUyb93IhO6T83KNQ6hMCMsFixCJhYelrAVcQirUzfrB3DdvFkQPleuUKwReQKve2
	HF9JOJ3FtgP6ear5rpps40ZlWPfLr8I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CIlEO3rF;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGvKxLtVkj8aET1gCZB9vB9TUPm0s+OVrj/WLz6eC1s=;
	b=CIlEO3rFm3daakJKtLQ/BzL/6x0Ov9KqoJ4CZP4o4/SnOWvTqiJzYnmBqdIREsuN+bNUzC
	KeHGjFyAwlh1l71PR0wW+pMAjkpso09UMPt6pFpgMGdrC9Ho03oryPaIsvSAW1dWa7GWkf
	Da+swkUUC9Pkymr06oIVafxdeOpGRc4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-bQW6sU6oM1ecRjRIWtI3tQ-1; Wed,
 21 Oct 2026 15:43:11 +0000
X-MC-Unique: bQW6sU6oM1ecRjRIWtI3tQ-1
X-Mimecast-MFC-AGG-ID: bQW6sU6oM1ecRjRIWtI3tQ_1792597387
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B1F11955F6F;
	Wed, 21 Oct 2026 15:43:06 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8DFF18002B1;
	Wed, 21 Oct 2026 15:42:58 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:23 +0200
Subject: [PATCH RFC v2 2/8] dma-heap: charge dma-buf memory via explicit
 memcg
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-2-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=7192;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=pji/4sq7BscjELUksmBSA71bWOhvozaMRbSph78T9cQ=;
 b=Isdo/bRMmwngdlwtW8H3L+1rYgtwEY7gCEZPRlMy/eV+nPd/KFWzKnKRx2Oor82bt0qG6Ijpg
 l/zwH9kDfobCRGZtlStUwCFYOit2gLeFZK57CEEvUUod+4QEjeq+xXW
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: iHUeP3EptVOzYGJjjKrSrl5PfDLKFaOgNsomar3Mjhk_1792597387
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4589120008
X-Stat-Signature: oss1xj5ziawbq7xrzx6d66c8wp8s1bni
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792597395-796275
X-HE-Meta: U2FsdGVkX184hh3OL05FJ2akMl8tTz28LglGAu9A04a8WP9idNFCT2ME4+X4nbV9MmR5QnVZ5QKx+siqE1+ye8W4b1XVdI2udCofeyJQhxGj2N5p1VbSIv8KYO07FpyvvaQIeCUoQ2PIF6Ivhmhrz1L0A3X4RSKAvtlYh/PBn33DGcb6mP/hqTSlSoP7ANHDsFlH/79RnuFmeUJ2S+RkaBQTHNY90P398qB29KpqW22iWEiwyuy/8X4ijRIQMZZiRt9lBl+WxYYDBAKP1sEJzK5UnNLdPuw7hqiAaPQP9ShCJheq+uNWGXMqFofRJ7xEDVsfRVrMU+k1Q3llS1X8V2/IoMYx0IfQza8Jni5rtoC+HnewqLoAjLrLxBrpESSn42IlvnGrCHQIIyytMPyqRdnGWmp27R9JLicZ9wYA+YEQi+L44BOBxvfOAu+VEyasoDFKyaiPD+aVtAs1TF18iGtQCetRB2vjdfxcaM9k392xHG4sUuJ4x9Un5dWdZJH6huQ1AW0TWVPK9kbvhaHAEvv6R0Q3o39mLAUhE3e0jSxJk6cBiouzZktaO+wmCsuNSHxSwO1+VnvIrwwdTxGPN7F0M5Mx8sWINO9dvjdSt2wbwIL5DyOSqdPamKSrDc+xT3w7g5Zr3h5g/Wi30RA89nkmPVrpeQEtTXsTisqwnmdMtU34PWP9i2lDyNPGJDCX1LkoPPcDDiOMqA9iexMp76Knkf4PX58YCdY41sjuB+ru9D26GVje1w99Y3QsUykzjlm4eQeo7HyOVVStGvIIiS52uaYv+a1FswfgMNNLL4TFOLap5ujvHkEtp3JRz0QpuDsUDQm289ebzg8Ujg5o/H/ulH+A6R20PjRZmptSVG4K+Bn1v2254Yv1B5YKJEmWm8X2dnMGxh7tsP39tdZ2Hundpk7Qw5v8FIcXvmQBJH28HD1QaFvzZ0wQEb76PrCsmFuXiUMTfxMTOyRJaZn
 lDpi5v8o
 k+zwZ0ydprjOnDpsKVH0W7AbfSCTfbirw+UQJNMQxdlAVjsOUVhzuD2gdF4cegkpErNk2ZqOBZRBL0i5TJNS12hOayqZEgnlRuwvbc1wiuUvzjiKQYdQMAuF5Y+dcj2DRhG3RsL0RZ3NAdxVUY9r4k1khZqLbd89VaSm9I0zj+Fq7iWHTCgreSgn/q4IE22JWncNJ1F2lKVq4mnlGmecPIbXPezFmsjtD6S2vRb68sqI+STpqPd4SzRmp+sMTJwbPMWOYR3o4JL7ZmU/IvA1U1OaPMpLk647LlxuLqbVpYrfFkK5wX6pPCCsX+Io9ZH2Mzq+pGZ+i3RtxszNNMhpYtJJLQWma/fdXqsb3A+q8t4W1s6P7kIZfqZDp1v5GNYIhygAgvCRR6cXHyMUgjIO5To9lf1aCukqqSrfslXrteSQHMKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On embedded platforms a central process often allocates dma-buf
memory on behalf of client applications. Without a way to
attribute the charge to the requesting client's cgroup, the
cost lands on the allocator, making per-cgroup memory limits
ineffective for the actual consumers.

Add charge_fd to struct dma_heap_allocation_data. When set to
a valid pidfd or cgroupfd, DMA_HEAP_IOCTL_ALLOC resolves the target
task's or cgroup's memcg and charges the buffer there via
mem_cgroup_charge_dmabuf() inside dma_heap_ioctl_allocate().
Without charge_fd, and with the mem_accounting module parameter enabled,
the buffer is charged to the allocator's own cgroup.

Usage examples:

  1. Central allocator charging to a client at allocation time.
     The allocator knows the client's PID (e.g., from binder's
     sender_pid) and uses pidfd to attribute the charge:

       pid_t client_pid = txn->sender_pid;
       int pidfd = pidfd_open(client_pid, 0);

       struct dma_heap_allocation_data alloc = {
           .len         = buffer_size,
           .fd_flags    = O_RDWR | O_CLOEXEC,
           .charge_fd   = pidfd,
       };
       ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
       close(pidfd);
       /* alloc.fd is now charged to client's cgroup */

  2. Default allocation (no pidfd, mem_accounting=1).
     When charge_fd is not set and the mem_accounting module
     parameter is enabled, the buffer is charged to the allocator's
     own cgroup:

       struct dma_heap_allocation_data alloc = {
           .len      = buffer_size,
           .fd_flags = O_RDWR | O_CLOEXEC,
       };
       ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
       /* charged to current process's cgroup */

Current limitations:

 - Single-owner model: a dma-buf carries one memcg charge regardless of
   how many processes share it. Means only the first owner (and exporter)
   of the shared buffer bears the charge.
 - Only memcg accounting supported. While this makes sense for system
   heap buffers, other heaps (e.g., CMA heaps) will require selectively
   charging also for the dmem controller.
 - Charging CMA-backed heaps to memcg charges unreclaimable memory:
   when a cgroup hits its limit, try_charge_memcg() may trigger a
   reclaim pass that cannot free CMA pages. This is consistent with
   other unreclaimable memcg charges. A refinement for the next version
   could move charging into per-heap callbacks and skip the futile
   reclaim.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  5 +--
 drivers/dma-buf/dma-heap.c              | 54 +++++++++++++++++++++++++++++++--
 include/uapi/linux/dma-heap.h           |  7 +++++
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a3265a4a953e..66ddba678784 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1663,8 +1663,9 @@ The following nested keys are defined.
 		structures.
 
 	  dmabuf (npn)
-		Amount of memory used for exported DMA buffers allocated by the cgroup.
-		Stays with the allocating cgroup regardless of how the buffer is shared.
+		Amount of memory used for exported DMA buffers allocated by or on
+		behalf of the cgroup. Stays with the allocating cgroup regardless
+		of how the buffer is shared.
 
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 8a6c2b6e0cc6..be77a4c168ab 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -7,14 +7,18 @@
  */
 
 #include <linux/cdev.h>
+#include <linux/cgroup.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
 #include <linux/err.h>
 #include <linux/export.h>
 #include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/nospec.h>
+#include <linux/pidfd.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
@@ -75,9 +79,14 @@ static int dma_heap_open(struct inode *inode, struct file *file)
 
 static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 {
+	struct cgroup *cgrp;
+	struct cgroup_subsys_state *css;
 	struct dma_heap_allocation_data *heap_allocation = data;
 	struct dma_heap *heap = file->private_data;
 	struct dma_buf *dmabuf;
+	struct mem_cgroup *memcg = NULL;
+	struct task_struct *task;
+	unsigned int pidfd_flags;
 	int fd;
 	size_t len;
 
@@ -90,15 +99,56 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
 		return ERR_PTR(-EINVAL);
 
+	if (heap_allocation->charge_fd) {
+		cgrp = cgroup_get_from_fd(heap_allocation->charge_fd);
+		if (!IS_ERR(cgrp)) {
+			/* charge_fd is a cgroupfd */
+			rcu_read_lock();
+			css = cgroup_css(cgrp, &memory_cgrp_subsys);
+			if (!css || !css_tryget_online(css)) {
+				rcu_read_unlock();
+				cgroup_put(cgrp);
+				return ERR_PTR(-ENOENT);
+			}
+
+			memcg = mem_cgroup_from_css(css);
+			rcu_read_unlock();
+			cgroup_put(cgrp);
+		} else {
+			/* charge_fd is a pidfd  */
+			task = pidfd_get_task(heap_allocation->charge_fd, &pidfd_flags);
+			if (IS_ERR(task))
+				return ERR_CAST(task);
+
+			memcg = get_mem_cgroup_from_mm(task->mm);
+			put_task_struct(task);
+		}
+	}
+
 	len = PAGE_ALIGN(heap_allocation->len);
-	if (!len)
+	if (!len) {
+		mem_cgroup_put(memcg);
 		return ERR_PTR(-EINVAL);
+	}
 
 	dmabuf = heap->ops->allocate(heap, len, heap_allocation->fd_flags,
 				     heap_allocation->heap_flags);
 
-	if (IS_ERR(dmabuf))
+	if (IS_ERR(dmabuf)) {
+		mem_cgroup_put(memcg);
 		return dmabuf;
+	}
+
+	if (!memcg && mem_accounting)
+		memcg = get_mem_cgroup_from_mm(current->mm);
+
+	if (memcg) {
+		if (!mem_cgroup_charge_dmabuf(dmabuf, memcg, GFP_KERNEL)) {
+			mem_cgroup_put(memcg);
+			dma_buf_put(dmabuf);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
 
 	fd = get_unused_fd_flags(heap_allocation->fd_flags);
 	if (fd < 0) {
diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-heap.h
index a4cf716a49fa..bfcd1c25bc7e 100644
--- a/include/uapi/linux/dma-heap.h
+++ b/include/uapi/linux/dma-heap.h
@@ -29,6 +29,11 @@
  *			handle to the allocated dma-buf
  * @fd_flags:		file descriptor flags used when allocating
  * @heap_flags:		flags passed to heap
+ * @charge_fd:		optional pidfd or cgroupfd whose cgroup should be
+ *			charged for this allocation; 0 means charge the calling
+ *			process's cgroup when the mem_accounting module parameter
+ *			is enabled, or skip charging otherwise
+ * @__padding:		reserved, must be zero
  *
  * Provided by userspace as an argument to the ioctl
  */
@@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
 	__u32 fd;
 	__u32 fd_flags;
 	__u64 heap_flags;
+	__u32 charge_fd;
+	__u32 __padding;
 };
 
 #define DMA_HEAP_IOC_MAGIC		'H'

-- 
2.55.0


