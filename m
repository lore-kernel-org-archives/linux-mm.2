Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6998D606A33E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gwyc712m
Received: by kanga.kvack.org (Postfix)
	id 6F2FE6B05BE; Wed,  4 Nov 2026 06:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2ED6B05BF; Wed,  4 Nov 2026 06:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A1E6B05C0; Wed,  4 Nov 2026 06:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E2E6B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:09:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9147A8341
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:09:54 +0000 (UTC)
X-FDA: 85397166708.08.C07E5E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9962C4000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:09:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwyc712m;
	spf=pass (imf11.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790592;
	b=YfH7KtAzDMGn42Ur2AzWdZrjxMLm0eFy9Li4urkIYCqIqXJJ6oXLNRE2sMapwBnauraaGF
	FARCeBtmSA22z/zqKCCzWLAr0spzAj22V27hCjy4iqXVsX1Eu7WndAzY6f13dNaGzobyAw
	QrvMy4OmNkBJYk9eFJI+Fx+78viVQcc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwyc712m;
	spf=pass (imf11.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UM51c89/UmaBCXNBRMsivaNHcChBK56yw85bXom6IPY=;
	b=CgVgwXo+Dqz5YOwKrRJOaj4XGjHp2pCLPFpdzYSwkVfyvs477HYhuyAVr/Mtfo8InleRvm
	rlXpFZlmBnCVPvOcCmyqAUvP54lemrtq6m8LW3AAAGFwfTt/k0p6RkP5iOwnzVAfjKRIOy
	4EYFTuHHIIcu1PgV3q3hX4hUm7kCirc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UM51c89/UmaBCXNBRMsivaNHcChBK56yw85bXom6IPY=;
	b=gwyc712mADrYyAqU+xF56m+UxbHRI8mxhokzpCRfVSIXLD8UpZZO0UrpK16BJjGRzuhHN0
	9U9tTg02+JMJUQVxwMr3xG6dEjYal4Y7XaT53qlfpnf2zgdN/iVrT0U8y4iHafQG85V74y
	snM2gdGMvB2DXOtPziq2G5rg2jfmYHE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-j2FYyQ4WP6e3z36R_R_a9w-1; Wed,
 04 Nov 2026 06:09:47 -0500
X-MC-Unique: j2FYyQ4WP6e3z36R_R_a9w-1
X-Mimecast-MFC-AGG-ID: j2FYyQ4WP6e3z36R_R_a9w_1793790583
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C91C31955E97;
	Wed,  4 Nov 2026 11:09:42 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFC6E195608D;
	Wed,  4 Nov 2026 11:09:33 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:11 +0100
Subject: [PATCH v4 2/8] dma-heap: charge dma-buf memory via explicit memcg
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
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
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=14986;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=C1WvOXGSbPwxYYpDnGeUw5sn9a8sC864fXq1L5H6zD0=;
 b=tmFoMdRIWaLAeHEUxWGHFUWYleV89vP8gahxEJAVgRNa7TIzRHRzL9LJ17A+A6NoReZ3eqGPc
 0IB1Z0XaEylCiLrhi+bArPFIxA4kdNMEoRSxXZ5Wd0rdY4osNSIyN5E
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: aKUdrLaWNunqYOriOlkYT1GCGkclsdr9uo-BP-hBxaY_1793790583
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kcnedq7ohrmz5zig6szfmwk813f7ty5m
X-Rspamd-Queue-Id: 9962C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793790592-134988
X-HE-Meta: U2FsdGVkX1//LDW0cW1mvNnC//1s21wwULYnjUUy9Px0VGCBrd7bbnr2iL9GwAIHM3khjiOOSPCnaln3GQENGW27tsEqXZjCrwH3srx9GT1CjNxsYcV38jUHN5JsLtgN7gXkbKQ4szOBc/o5qEJOU17ETSxydv+fIL5rVipdw+aK2MQE9+FAXEMx7FNWm2xp41IhCBM8YLas0atRK+HwpoM/fgkMpSwbYWO5+Nud8k2rdQt74akfef7upYC7N0j7bJgXiju6+0lbNt+a9KJdVMM7USVz0osnwiGfzwJNSIxFzjXZ5up64G2srm1TreVKd2DjBkCfPqba3A+WSQZlqPoL+r+9dMv76/vb4eXz5gaEXvMgAOyUpK3P/EkcbtD3u4oyK5BeltsjSr3U2/2GvrWx43vGPXB/mO01dQOJBMMPSj6Km2HzdBlwHmWfo9Pqy6fP3cpKdKnPB6vmBKpRTuiLJwXxzIiFrQPMdZnsWA0Ytxvalxh0iXmFrfFhCgxekQfmeX319yDeghpZUXU3uPwCqWOW6bcwaA4JV+ocQNsayOlnh7rQKPmpW3SQBbx+llwtLaCHpcZNFyYWrQ0X3JLDSWjqr48rSuw1G1XTbiI94y6TSFaTYxD8gyqbVSNXcQJpiqskO6rmeoAWwTvMdEmABHnRR0udV3WIfsp/u3olTYfj1yrXFpsFpZhBAREl360aU4FIleCXbwGeA22Ic1YxI8SWJZg6snSnpRdKnb/VG5b/65I+2xpYRwUFQDdc1Z523LSGX2cP7dwyeE4f8LtUE7/XYIFHvqyOoSJkij72mP8+/OeKdCn3xeb9P9w9n5ctmGag8t9bMXRC7/S6oBGA5Y6vTSG0J/irzoJOhcvnFqLITbvxpjqgROL8c9B1MoA1Yg/vYOcuvRekvRp0QCIbUokHIk/SrD98P9RVxieI8O8Wfhyym77iBwIsKqZ9RHDljvrtxC+MOzcNyym
 vOXE9r+l
 s8BmKU9l/CjaLqLkCGReHDlufHW7FxUvIgowt2jK2SdFCEsXsnCM/HcmmhlBIDQm3gHB5NNiVtjoqKPKRXLYoruFlphzE+G4f5MI9Lt1zU3X49vhLi7ZmtBseiR+RS0lDbdLCsUDmfYvwwOzYsQyBZlyz4+uxn5kHkqMwqCUyMhwifIYYyrghKUdd0Bld0j8OPmhatxPO0Flq2UEosk/4U8DPLXpmnnT0b0nfCYRHzA57RABzXDQv+ymrq4qNTQGVDThPE5xajzKdv/W3kHJYI5U+uIevhd9jjOvmz76/8zzshzktTemr0SqnXd3cJa78+1m/D+aFRUliTBERwGpdx+RRtdR3wb84EdZT0BhPaa2o5wM/HN+QXTT549rFpPp5S/L/ysOcbLSMj0YsenY9HJRC/1gEdyaEwUz/KJicYgI9E7Y=
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
mem_cgroup_reserve_dmabuf() inside dma_heap_ioctl_allocate(). The
resolved memcg is passed through dma_buf_export_info so that
dma_buf_export() stores it and updates the MEMCG_DMABUF stat.
Without charge_fd, and with the mem_accounting module parameter
enabled, the buffer is charged to the allocator's own cgroup.
The __GPF_ACCOUNT flag is removed from system heap allocations
to avoid double counting.

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

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  5 ++--
 drivers/dma-buf/dma-buf.c               |  5 ++++
 drivers/dma-buf/dma-heap.c              | 28 +++++++++++++++++---
 drivers/dma-buf/heaps/cma_heap.c        |  3 ++-
 drivers/dma-buf/heaps/system_heap.c     | 21 +++++++++++----
 drivers/tee/tee_heap.c                  |  3 ++-
 include/linux/dma-buf.h                 |  4 +++
 include/linux/dma-heap.h                |  3 ++-
 include/linux/memcontrol.h              |  7 +++++
 include/uapi/linux/dma-heap.h           |  7 +++++
 mm/memcontrol.c                         | 47 +++++++++++++++++++++++++++++++++
 11 files changed, 120 insertions(+), 13 deletions(-)

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
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 1c6b9cee7ac2..837666273550 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -714,6 +714,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	struct dma_resv *resv = exp_info->resv;
 	struct file *file;
 	size_t alloc_size = sizeof(struct dma_buf);
+	unsigned int nr_pages = PAGE_ALIGN(exp_info->size) >> PAGE_SHIFT;
 	int ret;
 
 	if (WARN_ON(!exp_info->priv || !exp_info->ops
@@ -750,6 +751,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	dmabuf->memcg = exp_info->memcg;
 	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
@@ -771,6 +773,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 
 	DMA_BUF_TRACE(trace_dma_buf_export, dmabuf);
 
+	if (dmabuf->memcg)
+		mod_memcg_state(dmabuf->memcg, MEMCG_DMABUF, nr_pages);
+
 	return dmabuf;
 
 err_file:
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 8a6c2b6e0cc6..7bd416ae2c23 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -10,6 +10,8 @@
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-heap.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
 #include <linux/err.h>
 #include <linux/export.h>
 #include <linux/list.h>
@@ -78,6 +80,7 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 	struct dma_heap_allocation_data *heap_allocation = data;
 	struct dma_heap *heap = file->private_data;
 	struct dma_buf *dmabuf;
+	struct mem_cgroup *memcg = NULL;
 	int fd;
 	size_t len;
 
@@ -90,15 +93,34 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
 		return ERR_PTR(-EINVAL);
 
+	if (heap_allocation->__padding != 0)
+		return ERR_PTR(-EINVAL);
+
+	if (heap_allocation->charge_fd) {
+		memcg = mem_cgroup_get_from_fd(heap_allocation->charge_fd);
+		if (IS_ERR(memcg))
+			return ERR_CAST(memcg);
+	}
+
+	if (!memcg && mem_accounting)
+		memcg = get_mem_cgroup_from_mm(current->mm);
+
 	len = PAGE_ALIGN(heap_allocation->len);
-	if (!len)
+	if (!len) {
+		mem_cgroup_put(memcg);
 		return ERR_PTR(-EINVAL);
+	}
 
 	dmabuf = heap->ops->allocate(heap, len, heap_allocation->fd_flags,
-				     heap_allocation->heap_flags);
+				     heap_allocation->heap_flags, memcg);
 
-	if (IS_ERR(dmabuf))
+	if (IS_ERR(dmabuf)) {
+		mem_cgroup_put(memcg);
 		return dmabuf;
+	}
+
+	if (memcg && !dmabuf->memcg)
+		mem_cgroup_put(memcg);
 
 	fd = get_unused_fd_flags(heap_allocation->fd_flags);
 	if (fd < 0) {
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 3fb4b946c91a..04de88b468a8 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -281,7 +281,8 @@ static const struct dma_buf_ops cma_heap_buf_ops = {
 static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
 					 unsigned long len,
 					 u32 fd_flags,
-					 u64 heap_flags)
+					 u64 heap_flags,
+					 struct mem_cgroup *memcg)
 {
 	struct cma_heap *cma_heap = dma_heap_get_drvdata(heap);
 	struct cma_heap_buffer *buffer;
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..2bd245e1eab8 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/mem_encrypt.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/set_memory.h>
 #include <linux/module.h>
@@ -388,8 +389,6 @@ static struct page *alloc_largest_available(unsigned long size,
 		if (max_order < orders[i])
 			continue;
 		flags = order_flags[i];
-		if (mem_accounting)
-			flags |= __GFP_ACCOUNT;
 		page = alloc_pages(flags, orders[i]);
 		if (!page)
 			continue;
@@ -401,11 +400,13 @@ static struct page *alloc_largest_available(unsigned long size,
 static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 					    unsigned long len,
 					    u32 fd_flags,
-					    u64 heap_flags)
+					    u64 heap_flags,
+					    struct mem_cgroup *memcg)
 {
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	unsigned long size_remaining = len;
+	unsigned int nr_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
 	unsigned int max_order = orders[0];
 	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
 	bool cc_shared = priv->cc_shared;
@@ -416,10 +417,15 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct page *page, *tmp_page;
 	int i, ret = -ENOMEM;
 
-	buffer = kzalloc_obj(*buffer);
-	if (!buffer)
+	if (!mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL, nr_pages))
 		return ERR_PTR(-ENOMEM);
 
+	buffer = kzalloc_obj(*buffer);
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto cancel_charge;
+	}
+
 	INIT_LIST_HEAD(&buffer->attachments);
 	mutex_init(&buffer->lock);
 	buffer->heap = heap;
@@ -473,11 +479,14 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	exp_info.size = buffer->len;
 	exp_info.flags = fd_flags;
 	exp_info.priv = buffer;
+	if (memcg)
+		exp_info.memcg = memcg;
 	dmabuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dmabuf)) {
 		ret = PTR_ERR(dmabuf);
 		goto free_pages;
 	}
+
 	return dmabuf;
 
 free_pages:
@@ -498,6 +507,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
 		__free_pages(page, compound_order(page));
 	kfree(buffer);
+cancel_charge:
+	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
 
 	return ERR_PTR(ret);
 }
diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
index 007c00156520..83e2fbd6960b 100644
--- a/drivers/tee/tee_heap.c
+++ b/drivers/tee/tee_heap.c
@@ -167,7 +167,8 @@ static const struct dma_buf_ops tee_heap_buf_ops = {
 
 static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
 					  unsigned long len, u32 fd_flags,
-					  u64 heap_flags)
+					  u64 heap_flags,
+					  struct mem_cgroup *memcg)
 {
 	struct tee_dma_heap *h = dma_heap_get_drvdata(heap);
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 23ec0ff23fba..85dd747c9b36 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -505,6 +505,9 @@ struct dma_buf_attachment {
  * @flags:	mode flags for the file
  * @resv:	reservation-object, NULL to allocate default one
  * @priv:	Attach private data of allocator to this buffer
+ * @memcg:	memcg to charge for this buffer's memory. Set only for
+ *		buffers backed by system memory where @size reflects the
+ *		actual allocation in bytes.
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
@@ -517,6 +520,7 @@ struct dma_buf_export_info {
 	int flags;
 	struct dma_resv *resv;
 	void *priv;
+	struct mem_cgroup *memcg;
 };
 
 /**
diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
index 648328a64b27..2d69f8432bd2 100644
--- a/include/linux/dma-heap.h
+++ b/include/linux/dma-heap.h
@@ -23,7 +23,8 @@ struct dma_heap_ops {
 	struct dma_buf *(*allocate)(struct dma_heap *heap,
 				    unsigned long len,
 				    u32 fd_flags,
-				    u64 heap_flags);
+				    u64 heap_flags,
+				    struct mem_cgroup *memcg);
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d1e82cf0833..f8ec751b7d7b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -671,6 +671,8 @@ int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
+
 bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
 			       unsigned int nr_pages);
 
@@ -1178,6 +1180,11 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg,
 					     gfp_t gfp,
 					     unsigned int nr_pages)
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
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e53dd7eebc3b..17fdefc56b97 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5661,6 +5661,53 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * mem_cgroup_get_from_fd - resolve a memcg from a cgroupfd or pidfd
+ * @fd: file descriptor (cgroupfd or pidfd)
+ *
+ * Tries @fd as a cgroupfd first; if that fails, tries it as a pidfd.
+ * On success returns a referenced memcg pointer. On failure returns
+ * an ERR_PTR.
+ */
+struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+	struct task_struct *task;
+	struct mm_struct *mm;
+	unsigned int pidfd_flags;
+
+	cgrp = cgroup_get_from_fd(fd);
+	if (!IS_ERR(cgrp)) {
+		rcu_read_lock();
+		css = cgroup_css(cgrp, &memory_cgrp_subsys);
+		if (!css || !css_tryget_online(css)) {
+			rcu_read_unlock();
+			cgroup_put(cgrp);
+			return ERR_PTR(-ENOENT);
+		}
+
+		memcg = mem_cgroup_from_css(css);
+		rcu_read_unlock();
+		cgroup_put(cgrp);
+		return memcg;
+	}
+
+	task = pidfd_get_task(fd, &pidfd_flags);
+	if (IS_ERR(task))
+		return ERR_CAST(task);
+
+	mm = get_task_mm(task);
+	put_task_struct(task);
+	if (!mm)
+		return ERR_PTR(-ESRCH);
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	mmput(mm);
+	return memcg ?: ERR_PTR(-ENOENT);
+}
+
 /**
  * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf allocation
  * @memcg: memcg to charge (may be %NULL)

-- 
2.55.0


