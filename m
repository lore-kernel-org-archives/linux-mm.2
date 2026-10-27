Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1743860A380B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iA1lTzmE
Received: by kanga.kvack.org (Postfix)
	id F3B6E6B0754; Tue, 27 Oct 2026 11:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEBF36B075E; Tue, 27 Oct 2026 11:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CE26B075F; Tue, 27 Oct 2026 11:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97D756B0754
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:03:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA06B1A0A1C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:40 +0000 (UTC)
X-FDA: 85368725400.25.FCC0F1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B78904000F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iA1lTzmE;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82TKVQ3RA7rJt5AaOCTz6U58syjqbmedRcBzenBhIQ8=;
	b=Xp7xORRGXAfIVdzP1uKyZy7IlIXsVCKGq+fl8F4IGaRzvS2rp8NlizobLWwEGngbK5YM4j
	XwbQjzaH1SnTlHu7udBvqxqfGbAbb64RbSyWZqiTFY+FiBdr7eVJ6tNr7DNIa59VB/4QZO
	F+LfpLL4KS2zBYnl38ytkDn0mnEO9F4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113418;
	b=iorSYyFYcc8JS+DheJ+ruMQ1WPYl5wkAJZ4MFW4VUB3t3SkE9cs5vC/Y/0tiAegK1KVO5P
	Yw2c8yZWps3MwFaKiaQgfar2w6ehtAeUdxbRn9lhSdm2KZg7+lFS0WtvNIyGEjwUMYQ9rk
	skE9ooNZX8TISpiAzhTufVlU9rtTgxk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iA1lTzmE;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=82TKVQ3RA7rJt5AaOCTz6U58syjqbmedRcBzenBhIQ8=;
	b=iA1lTzmEy955WfsSVJz6ai1vzw1cyHJKQDVoJkaVN/Jzrz9c4Elgzm0boeVcXZxiqSjL15
	SdrVWOXoUZ3KJ/01HcgPmje7LrwnKbiStG/02KeVowjanacwfDiNlS5I+75YhTnX3+I+1h
	0kVn8ZuPnaAM5UzQDT8aaXF72EMbFYY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-ICUhzKobO_CkPX3RppZ-Wg-1; Tue,
 27 Oct 2026 11:03:33 -0400
X-MC-Unique: ICUhzKobO_CkPX3RppZ-Wg-1
X-Mimecast-MFC-AGG-ID: ICUhzKobO_CkPX3RppZ-Wg_1793113408
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E9F61801373;
	Tue, 27 Oct 2026 15:03:27 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C8B318002B1;
	Tue, 27 Oct 2026 15:03:19 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:45 +0100
Subject: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit memcg
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
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
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=12560;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=HzmmxRZILCh8Iy7tjxJbFY89nUIHqBneEb2dXQeHbls=;
 b=8f+XzLeoTXM6NOCc/WXtepjahJg7GUR94F4cVavcvbqPgARPqkXQZTMs6LzqeKP30ePPqdHja
 EbSTrtl0054CynKv6QyC1fNkeAOfXHzCnE2M6m5iYwUMbotkgQiDaB6
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: UT7vQXXXGFGuTiG7zbpPOaOxWd6ZVFU1ORTAiZoPXW4_1793113408
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B78904000F
X-Stat-Signature: 3km1kjkmbhr4ywi75p1mgyr8ycd4kdjx
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793113418-446974
X-HE-Meta: U2FsdGVkX1+/OJ4aLwh1XkDavwlFt3JV9AprqadO+vtcY7GS6Ux0cWKnAR5Od0xFo48d66k/13ZPhO4ucbUULD2Oyycwm3Ssn72IXTzvlAHpH+deqou/6TF5CNx6O/fAIprxXZHawfqm28GHkhLfDRzYbHVblODHMPXof5vFGZ78FSkbW5n1PTIazQbuPofQTDA2kPFe7q6sRfyL1qZn2KPN8YcSAqqCGXfvNJVB5VlebDI4npx4EYctcvRq3Ka72AVB8Ic1BMaXWGqVbwq4xQutbh8pthENyOdkV44fkKu2PBntXqbWB2KI7WycowmpehEbKkEHU6ZRar7RbX4O8sxEhezzXBVm0jupmyW0L5K9lLiKGpbaTN0KMWjrPDZ3Tt8G0y8w1Yz4R5Jgagsw9seu92rhTtmjRiXllbMdvfQn3fPWk08zF2YyfpFlD9OMMX41iGpOS696QQ9CHmdB8JtWKWlzhgzsef0uxIIVtV3mdo70fTeacM21quzjXmT7b/wdkEfvHlvabBP+7AsStuzhrbtzBMhfKduAbNbVsjKWLY/l5Bu6K2EczcYerAM0HiWkAnrM5Ra6aFwPHRqGks+dIKl8zNvgh86ufGTXQkyIL0JmSZAkw/PN/2XQNvQDmPRLHrn1TM3x5XYGcHBrCEogaGhJW+Q/0/N7tLgzswA7Cn1R4t+0Zkha9pxAa8AWW1SkH1V1MG0lCrjnyXE6N4ET9DhXba0cSLWaI/87f0tR8oyOx5EuJU8zjupe6xQ3p+DwM+izXVHWSGzps8PyhsRta1gu2slHRq/iq5TtZ0n5ABfzGRcdg7CvR3lhUIBzIO3Mdbo7inPxJCWvqKMb+TsT0d2R53GhlpdF8tFG8lsXDe7uXhOcWQ17EuwHVD+UapXnsMzjVZVL4YHW5sECJqwlVXlii0V2nYt+x+f4xFeCVv7TE6/CQLV51OVUsTOGTvmzEOYn36X2AsQKiUO
 5GXZcXxa
 DaYaDAAuGK4zODyOUiffRGbduu165vhX+3QF9MU4S0h345zZQO2bJiqhqtnKuxTJC1gtgqUgmyiAKqFyLpB/84MnlH99hrTDKcvzv63c9uCzlUix5j+ZAKfllY/oe0E0KzfhDwAhf5nq5ob2GYrpltUm9+NyfYGTBLw6USXxLyPECXM2VwMYtKaiAqo2MTP+s9jHRH50hWW7ELXaJ2oBRTZi22U+BMdf0Yh93WUcjaflVHhIZkE6A/9ySaFgt/cTj5X/5H/6zUWFDEaHPbtVAS9KMdNXqRrYZWyLMSzbgWejgqR2sOrOSoHpDsnYv5PFDBEkWuMrCikHcBjvVP9XO5Fd3U1Eg9E/RT3KmJV6Zt8dctxXSrjXe3BLfNpjlqrlMrd4uiFfQwQlUj4d9EB3mLCYyIUYNzdSMvtOK5fz7l3ABO5k=
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
mem_cgroup_reserve_dmabuf()/mem_cgroup_commit_dmabuf() inside
dma_heap_ioctl_allocate(). Without charge_fd, and with the
mem_accounting module parameter enabled, the buffer is charged to
the allocator's own cgroup.

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
 drivers/dma-buf/dma-heap.c              | 28 +++++++++++++++++---
 drivers/dma-buf/heaps/cma_heap.c        |  3 ++-
 drivers/dma-buf/heaps/system_heap.c     | 21 +++++++++++----
 drivers/tee/tee_heap.c                  |  3 ++-
 include/linux/dma-heap.h                |  3 ++-
 include/linux/memcontrol.h              |  7 +++++
 include/uapi/linux/dma-heap.h           |  7 +++++
 mm/memcontrol.c                         | 47 +++++++++++++++++++++++++++++++++
 9 files changed, 111 insertions(+), 13 deletions(-)

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
index c8959eadc71d..adeea8cd328b 100644
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
@@ -478,6 +484,9 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 		ret = PTR_ERR(dmabuf);
 		goto free_pages;
 	}
+
+	mem_cgroup_commit_dmabuf(dmabuf, memcg, nr_pages);
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
index 4c8711fcf4fd..6b30baa79fa9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -671,6 +671,8 @@ int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
+
 bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
 			       unsigned int nr_pages);
 
@@ -1181,6 +1183,11 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
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
index bbd46ba40350..f66254f52b99 100644
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
+	return memcg;
+}
+
 /**
  * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf allocation
  * @memcg: memcg to charge (may be %NULL)

-- 
2.55.0


