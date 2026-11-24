Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7054B606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZnFlRN+y
Received: by kanga.kvack.org (Postfix)
	id 786406B06B9; Tue, 24 Nov 2026 08:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DBC6B06BC; Tue, 24 Nov 2026 08:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679046B06B9; Tue, 24 Nov 2026 08:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23346B06B9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 251D5120B3C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:41 +0000 (UTC)
X-FDA: 85470031962.10.569F30A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B5BB40010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZnFlRN+y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525479;
	b=kZe9CPf6646ykU5IAwG8UCfHrRoflu1n/P4fmoiNaBITr9xcSMnYC/lUSHfWb03KKY/WPj
	er/Q9aqHhtZgA8hU9wy7gP+/VcXZMDv9qkLrOC6MCjjdYP32I2EVWkLEI31jxsygvFmwGQ
	JdHzlmzfOzJUUWKHZxEYG1uc6cyRrV8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nizJcVA7Wa81h6Gn6h+RSYkTffjHDTHqLXMBz9MWQMg=;
	b=GzsGoxgqsMKMEk/X23ro2E9WGw1srplqkU154RyK91t400+64+zfqNKTZQz2VM89vdUA3m
	7hwDfJbATSHhCPF6Gv/hz201u6X9T45Fp9/GJFylA4iQ5USZVSAi7j4eHlHUupeNqs1El7
	6F7Hgr+6nQ+QXJEAqm1Wxmz64e/EYLg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZnFlRN+y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nizJcVA7Wa81h6Gn6h+RSYkTffjHDTHqLXMBz9MWQMg=;
	b=ZnFlRN+yXt7lyO5SS/w2U+p+2ziMEAPBM9eKPyD5vdtgsL3tZpLkmNe3OdOZcSBa77pU1M
	UPjWEao2OllgGUNoOPGEK3rsiJzt4UJNxxJl5Jocis6gxMZ5VQHIbOPMmI6JP7PRN/Qw6R
	7rFZd4XVYlxxOxT1rawtKGakvpLWwXA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-PM1dzi6PMNW-6zAeF51P7g-1; Tue,
 24 Nov 2026 13:04:31 +0000
X-MC-Unique: PM1dzi6PMNW-6zAeF51P7g-1
X-Mimecast-MFC-AGG-ID: PM1dzi6PMNW-6zAeF51P7g_1795525466
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2EE71801316;
	Tue, 24 Nov 2026 13:04:25 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BB5F195B3C0;
	Tue, 24 Nov 2026 13:04:17 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:37 +0100
Subject: [PATCH v6 3/7] dma-buf: transfer objcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-3-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
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
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=9901;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=p0gUDnyZxEE/RD7TRA22Oh714OsUUJihNEZjS3+jQCw=;
 b=tFt2efyJ1342UemkrkkLe8IblmieANe0xYR/akIIYTpAJAjyL4Hq9eNUmZE4oBXW5i5LtZN6E
 HUJG1QBdo/5DxMHNib12rzCBon3iRU9VGfYp2+Y9A1MMAApHS27V3dt
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: XnlxXHlsNe6zGoWmxOoiXafLbt0pMXAcNCwS7r4-TyU_1795525466
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B5BB40010
X-Stat-Signature: wq94ie17ym81s3qef3fju3tuak86p3ik
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795525478-70557
X-HE-Meta: U2FsdGVkX19JNWOdWgJQ0MnpnaZ9lrbsbV33BJ1qua1DrZ6BhXHIcn98aL3ClYcOQ2wEAq/x7zPRRbb2nuOJY3Dl2GRM5iGPdS/N60aJfZq1tJqKfqeLut5X74yA2vX00qmHjAe5AlDRB8Q7MF29m/u8HhZSYrBv5N5KKXI1l3X36qPTAyXKzHgraK/pPRRRk1U5SJvQZH0LdH6zYNeZ9W+zVsC2YfHJMEn1FPHjkbZDjc/6ViS79JPlho99c5VEEzs1vdsfF7hu4Y0Gd0Kbv6GRx3MmPc2Pkrcuq8VpVCDPjyc08Ls65WSY/WF26Vg2SvHlUk76o5FCC3CCmYhOZrh8/MSlQHo8bsy7xpiK7XcBQtMuTlaUH4mOOP6Gm0KJPqgY++OURc5qQZagFysgZ5Vj7Q1GUKv86mLRzS9aFE8it05xqoYeoFeHCdCMQBpkgoPsSNxOmgJNkQUZJ7IFprBfaFnKRCSY5x/khoc/GSxs/HG1zh0oeJbq/MI1gOg86VyRnUSSzOmwORwJuwH27c+srz70hNFJPZjz66QiB1tLw4+UHhsJb9Pa90XdOkHlCBQocZLkSxFz5ooJYZwQ9JljhPQeiVeGMWc+92R70aBRXMrNYILRcxznnr1N+oNT1n2UwoJAT3jHl4eUO24otQnNNAd3/2lC+Eo4ilHrg3NgWvPhiXB4FQMRy5ZF2GR0ZLumtdVkVLZZLycLqOWHD0l4g8hMfdAOJfsm0vrvTnULBXkdmGXE/ErQep/1q25dAEcxlcnOaLt78EYI+uDcSJkYvlfK6M5K2tobyGy2DL0nd/5jvEfWG18T6ZtLbDcDJd5ODVOyLjsK159IyqtLkZYciBYo6kTJcYtoKpgNHiuqIGAvWmBXD3RYWmAVxEjK52byeEanJjyx25BvswAATmhmqdR7hSnRWRKu32Vzdj4zUQQqR7u7LiOkxDlrxplx+fMqWxbwuFqoMiFBsR7
 HmaVYNnZ
 2zacr1+xcZUow4/Qos6KbeOJYWP4ArzLMS8O9pW733skGbauN+NaLaKgLaNIXgX/lnmBQWeOEFxotanGmimdqPvcqZy4qeSpAx//pUjluE4xDCpkh0O92IvhWpJNhC0a9ISXNhRMXiJZdAlBChYFDs+VrwgoelRDCrhPX+ZpY1ODeLSH3jepQUGakIdw3OY5pv+abDfvX2v2SUyLq3MPIySkKuxA8gGzQ3IdnstmKeFYSJjK6Cg+NH5eh53IzDLNY7dFEkCnLqNaEBZP1/9WL+xTFuuxkPnHFm190XdS1wpFUPvYT/MER8AWVWb37x4snRrbFRJdpt5Ql5zqNAr57e1v6RUxeShZLWR3bvCRPRVQBeSdvVprVcqIqN6YyEd1ejUdXnH9tL9DcW02MhVEFCoBK8JXRsC/CMgvQ+VEYyB7QOk66tZb2epTdvzFn1RRFhcoaj94hSml6CpHazU9ZBRE97zAfyKGcjCIWG6gEmaa+CUUKxyWExKy24kIPJIWpQEtI8gj9M5XSWM/Y4LlYyfLziVQ2k+J2N8cj+h/Dwj8nVscJ0u48lgcS/adYk6tFxwIj8NPfEcEnprSwowkrvB3O4LLyA0MUdun7EvcIg8WEVOqI2L4DQQd+cKdweeTByTMzQmudfpbWIaK4gv8Q5vpFEsgu+pEyvPxuBQni5EEiEbkRFO9T9Q+2K4L1VhF3IWsP5rU8iCAhCcOoQ0SRJ0OeMUiYo6KfdToXJY/NcG1OYHFALm7gppQYiJzyo7I6f1LhJuDZpvpfNnrXE2Zc1SA6bxy0gk7sfc2SYQqs9YnpabDi4NqnhXkmVuRvQm2KU+NrBm1rNc0kUeV60JhdzIp3SgzsO5G/oIDGy86ud+AuX2sryWkdicdaibDGkpV29GJz6dh3F7DG1C5a/TdUj6xO+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dma-heap already supports charging a specific cgroup at allocation
time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
originate from any exporter (DRM, V4L2, etc.), and the allocator may
not know the final owner at allocation time.

Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's objcg charge
to a different cgroup after allocation. The target is identified by
charge_fd, which may be a cgroupfd or a pidfd.

The transfer charges the new cgroup before uncharging the old one,
preserving the original charge on failure. Concurrent transfers are
serialized by the dma-buf reservation lock, so lockdep covers the
locking order of the charge path early. The transfer implementation
is generic (obj_cgroup_transfer_charge) and not dma-buf specific, so
it can be reused by other subsystems.

Not all dma-buf exporters back their buffers with reclaimable system
memory. Some represent device registers, VRAM, or carved-out pools
where size is not a meaningful memory cost. The xfer ioctl returns
-EOPNOTSUPP for buffers whose objcg is not set. Exporters opt in by
passing a objcg through dma_buf_export_info at export time. Currently
only the system heap sets it, other exporters can opt in as needed.

Usage example:
  int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);

  struct dma_buf_transfer_charge xfer = {
      .charge_fd = cg_fd,
  };
  ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
  /* charge now on app1's cgroup */
  close(cg_fd);

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  2 +-
 drivers/dma-buf/dma-buf.c               | 39 ++++++++++++++++++++++
 include/linux/dma-buf.h                 |  3 +-
 include/linux/memcontrol.h              | 13 ++++++++
 include/uapi/linux/dma-buf.h            | 26 +++++++++++++++
 mm/memcontrol.c                         | 58 +++++++++++++++++++++++++++++++++
 6 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c6bf2e435d74..8d10ff7ac745 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1670,7 +1670,7 @@ The following nested keys are defined.
 		Amount of memory used for exported DMA buffers allocated by or on
 		behalf of the cgroup, this currently includes system heap
 		allocations. Stays with the cgroup regardless of how the buffer
-		is shared.
+		is shared, unless moved with DMA_BUF_IOCTL_XFER_CHARGE.
 
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 3184e31d9e4c..da76f758e9fd 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -540,6 +540,42 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 }
 #endif
 
+/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
+static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
+				const void __user *user_data)
+{
+	struct dma_buf_transfer_charge arg;
+	struct obj_cgroup *objcg;
+	unsigned int nr_pages;
+	int ret = 0;
+
+	if (copy_from_user(&arg, user_data, sizeof(arg)))
+		return -EFAULT;
+
+	if (arg.flags != 0)
+		return -EINVAL;
+
+	objcg = get_obj_cgroup_from_fd(arg.charge_fd);
+	if (IS_ERR(objcg))
+		return PTR_ERR(objcg);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	if (!dmabuf->objcg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	if (!obj_cgroup_transfer_charge(&dmabuf->objcg, objcg, MEMCG_DMABUF, nr_pages))
+		ret = -ENOMEM;
+
+out:
+	dma_resv_unlock(dmabuf->resv);
+	obj_cgroup_put(objcg);
+	return ret;
+}
+
 static long dma_buf_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
@@ -590,6 +626,9 @@ static long dma_buf_ioctl(struct file *file,
 		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
 #endif
 
+	case DMA_BUF_IOCTL_XFER_CHARGE:
+		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ff4678d00d8c..916d73ae6a51 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -508,7 +508,8 @@ struct dma_buf_attachment {
  * @objcg:	object cgroup to charge for this buffer's memory. Set only for
  *		buffers backed by system memory, not accounted elsewhere, where
  *		@size reflects the actual allocation in bytes. The buffer takes
- *		over the caller's reference.
+ *		over the caller's reference. Enables charge transfer via
+ *		DMA_BUF_IOCTL_XFER_CHARGE.
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8e016d9b91bc..37c81be349b8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1827,6 +1827,11 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
+bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+				struct obj_cgroup *new_objcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages);
+
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
 {
@@ -1930,6 +1935,14 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 	return NULL;
 }
 
+static inline bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+					      struct obj_cgroup *new_objcg,
+					      enum memcg_stat_item item,
+					      unsigned int nr_pages)
+{
+	return true;
+}
+
 static inline bool memcg_bpf_enabled(void)
 {
 	return false;
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index e827c9d20c5d..0aaf2e7d593b 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
 	__s32 fd;
 };
 
+/**
+ * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
+ *
+ * Any holder of a dma-buf file descriptor can perform a
+ * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
+ * cost to a specific cgroup, or move it from one cgroup to
+ * another.  The ioctl charges the new cgroup before uncharging
+ * the old one atomically.  On failure the original charge is
+ * preserved.  If the buffer has no existing memcg charge, the
+ * ioctl returns -EOPNOTSUPP.
+ */
+struct dma_buf_transfer_charge {
+	/** @flags: Reserved, must be zero */
+	__u32 flags; /* unused for now */
+	/**
+	 * @charge_fd: File descriptor identifying the target cgroup.
+	 *
+	 * May be either a pidfd, in which case the charge moves to the
+	 * memory cgroup of the referenced process, or a cgroupfd obtained
+	 * by opening a cgroup v2 directory, in which case the charge moves
+	 * directly to that cgroup's memory controller.
+	 */
+	__u32 charge_fd;
+};
+
 #define DMA_BUF_BASE		'b'
 #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
 
@@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
 #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
 #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
 #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
+#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
 
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7826bc21bea9..bf5b2672c0c7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3254,6 +3254,64 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 	return objcg;
 }
 
+/**
+ * obj_cgroup_transfer_charge - move a charge between object cgroups
+ * @ptr_objcg: pointer to the object cgroup to transfer from
+ * @new_objcg: target object cgroup; caller must hold a reference
+ * @item: memcg stat counter to adjust; must not be a node stat
+ * @nr_pages: number of pages to transfer
+ *
+ * Transfers @nr_pages of charge from *@ptr_objcg to @new_objcg and, on
+ * success, stores @new_objcg in *@ptr_objcg. Does nothing if both resolve
+ * to the same memcg; *@ptr_objcg is left untouched in that case.
+ *
+ * Updates to *@ptr_objcg must be serialized by the caller.
+ * Returns %true on success, %false if the charge against @new_objcg
+ * failed.
+ */
+bool obj_cgroup_transfer_charge(struct obj_cgroup **ptr_objcg,
+				struct obj_cgroup *new_objcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages)
+{
+	struct obj_cgroup *old_objcg = *ptr_objcg;
+	struct mem_cgroup *old_memcg = NULL, *new_memcg;
+	bool ret = true;
+
+	if (!new_objcg || mem_cgroup_disabled())
+		return true;
+
+	new_memcg = get_mem_cgroup_from_objcg(new_objcg);
+	if (old_objcg)
+		old_memcg = get_mem_cgroup_from_objcg(old_objcg);
+
+	if (old_memcg == new_memcg)
+		goto out;
+
+	if (try_charge(new_memcg, GFP_KERNEL, nr_pages)) {
+		ret = false;
+		goto out;
+	}
+
+	mod_memcg_state(new_memcg, item, nr_pages);
+
+	if (old_objcg) {
+		/* Uncharge old cgroup */
+		mod_memcg_state(old_memcg, item, -nr_pages);
+		if (!mem_cgroup_is_root(old_memcg))
+			refill_stock(old_memcg, nr_pages);
+	}
+
+	obj_cgroup_get(new_objcg);
+	*ptr_objcg = new_objcg;
+	obj_cgroup_put(old_objcg);
+
+out:
+	mem_cgroup_put(new_memcg);
+	mem_cgroup_put(old_memcg);
+	return ret;
+}
+
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
 {

-- 
2.55.0


