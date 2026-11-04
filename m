Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECC5606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y0H8P+4g
Received: by kanga.kvack.org (Postfix)
	id AEA886B05C0; Wed,  4 Nov 2026 06:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A186B05C1; Wed,  4 Nov 2026 06:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963786B05C2; Wed,  4 Nov 2026 06:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6266B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:10:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0A83406AF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:03 +0000 (UTC)
X-FDA: 85397167086.28.FE6058A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id B517214000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y0H8P+4g;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRFrV7ENMJ5LsnXMo7Bt3vo81nmJTT70jiqw21jtF3Y=;
	b=TYtrwQSqSUoHShLLycqx0pz5w9aPn/vno/6jLlkYv+4+c4zFhciw8wtb+ekGAXkmkIHw1R
	LuYRmV64xgO7p4EtbrdV0bQKwIl1JzzJ52yYAUOmI02VFZwSjoroDTtvdGvrinNeJzVmfe
	sU+DgPQcH+KQW4nMerqM3dOgRKa5pcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790601;
	b=1sR2ACflxl8YOwu0pZ2ibTjcEuSyj6rU12Oa5aDP0yfAfVnUK49XVOqLXokCWDf4RqZ8de
	uaOS9v4m6W7wuedzEab/S82IgB4hkvZzNa5CLwYeDaoo75wQ5AhPWbxvVGtIPPWHWZbtzl
	4O9rMrPYi5ZJXd/pm6nXGFC+TcCggWA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y0H8P+4g;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRFrV7ENMJ5LsnXMo7Bt3vo81nmJTT70jiqw21jtF3Y=;
	b=Y0H8P+4gpZM//lWXvr1QTuTmnoTeQjw0cwE6jWdnaZJ+VuNVTyKgmUU2e4jwkFKJHo7hUV
	zxj36bP3Dl+0GHvMQmoUJTD5QmeEWufm31BZb/ns7iVYcVsKPpvRctsN4yzjmkj+T0ecwX
	CKYlljOnjuPw3Y7cWPas7N/cuXszJMk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-t1GqEaTBPf6DtFvsq88-OA-1; Wed,
 04 Nov 2026 06:09:56 -0500
X-MC-Unique: t1GqEaTBPf6DtFvsq88-OA-1
X-Mimecast-MFC-AGG-ID: t1GqEaTBPf6DtFvsq88-OA_1793790592
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DC1218002D1;
	Wed,  4 Nov 2026 11:09:51 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27C1F1956088;
	Wed,  4 Nov 2026 11:09:42 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:12 +0100
Subject: [PATCH v4 3/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=8607;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=7b0+zJ3htFo5FJ8j37pqBaxPzfj5jrrpbwrWzNLREDg=;
 b=j0Dgp2Tr0Vlcc+MkUpyF/M5cw1DzTsr771mvxuXLdMyoyxYz/Xn3H7/IHfWJkfa6VdR3liVmc
 lQpaBjdYQDeAaA9ibwt4QIvALgbOyF6shxv3Cqs2tZDsdiid64xxYoL
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: xWsWj5s4wdeuLjGJjOfFhZ-UuH_D140GdDA1xhyFnuA_1793790592
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dnw4k8j647kw8cctct7q5ngf9ay3atos
X-Rspamd-Queue-Id: B517214000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793790601-714147
X-HE-Meta: U2FsdGVkX1/aOQ/tMMqY1zmlFqvemSBvX96F4ogyIrdK5vxemMyDmo99xNCm9Mz5W0ln1MShBSKAoeCooUJaRrq6kZV+QYXEbjHHJdwG+60ZFsiafqcXWsTLRZzRQ2pQ6vXoSP0vCAjZgsn6ZaV0eHP8iUYuDAew2fXp9i0w+YymaHst+YJmR6lTHbpPBdzdxt/erqKtHQHStJyKmy/ygvvkD47bY+hgRMS3n3Hd2pzns2awYomv+Zu1rzRebPUXoM2SGCMC1gXXIAiwXQuUvQReEmFqS0DL9Gjdyo/edlh0P86VOUMTtZwT/ttoIwf45ZirhUWajsFkQ5e33Is0H9dkZZPADKRIAz2Sd6UA8Q7koS54rh2TA6I4DKGGZ/XzE0VY9lv6rrD+MP0BVVRent3u+wdl6i4L0ey2PCpYmURc8Hb6cvLuT0IRs62KfOjuilvbEcjSU48UOxSMf+vjVb8NbDc7nhiyi32YpsNpQ66P6NRGpdp8TdMnZywvTisAmGVqGJt2PnNT6ItjcNHjz1l9uMeAyiViJjSDpGLBk51uA+F1ECIWnhVXxs2RG9yV+uh/CkS6sIbJSHAzr3pU5pZhVjbCrpLAu6v6xgkVS41bcYhNm42Pkpye2ci5rWNgQFTJnYyQGK1T8Mo8HwKOBa+jw9UIpyEtYx4KUHdLCOiedBH2XxT/wdhG47yk3uq7wagtCWTtEh7vZ3Ir0x46JpCjlfpr1QV+R7GqwHcgVmBjGJs+Myn+YQPrIVpN/lkBwDZdDHUcynaEvwm/+h1whKfBPEpjNaNoCKy2A5/klXXnDvgYn/n2e981uxIK4M1AHb6/fROkrma6yH3R/2ywEFHUzY0zTJlKLX30j4HXs5ConUdeBg9KA2B7/srAF4HvJ3q6MtLYCAOmHmisOs45jkhNFzyLp0JEN6lXROSX0HPfhKUDeW+BNaP4CmQtpCRwr+nfx6rcVxaPRuq1mnh
 daAZBhfU
 deJ73/KVEfZ1pQCyejZ1u9Ao3A0N4mWIE5njwoN1MO8La3ov2/WATm3tMFIf9YN6zY56vba+qxZqzi+BJY8VFg4Nv879EWtlO2mZEe9Butb28bxQzQelKyuHt0IuGQY+gzW8iCyCvn2wlFyRJli+Un9hgfsiqLqvZGhfnOwmQ92VbMwiDOEcRu9QqVsnfZXXV86VDUCNdQOPLp4zVkXuGQuvm3QRB99JzUTaVorv7KdJlgFwAKAJv59KrGqNMH9B4xRXVhhRSx0lp0Ukg3tvOjSMwl3JijsC3FgxtctBI3EZR40X+xoloiz547ebXaIuHHDUFESvsaVHTNFXVVhCj1jj7gt+9UcfzcV9OgU7eZrJxTLP7n0tvX1DiQD2FwOXE8g2/LYWXpjNdG8eJrEJWhMOwlHwaGL+GI/lYveleuC9TbNgLGjWqBLx9Y91+zcd7SuxI9TJzOT2Af4Fp/376Sus38g==
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

Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
to a different cgroup after allocation. The target is identified by
charge_fd, which may be a cgroupfd or a pidfd.

The transfer charges the new cgroup before uncharging the old one,
preserving the original charge on failure. Concurrent transfers are
serialized by the dma-buf reservation lock, so lockdep covers the
locking order of the charge path early. The transfer implementation
is generic (mem_cgroup_transfer_charge) and not dma-buf specific, so
it can be reused by other subsystems.

Not all dma-buf exporters back their buffers with reclaimable system
memory. Some represent device registers, VRAM, or carved-out pools
where size is not a meaningful memory cost. The xfer ioctl returns
-EOPNOTSUPP for buffers whose memcg is not set. Exporters opt in by
passing a memcg through dma_buf_export_info at export time. Currently
only the system heap sets it, other exporters can opt in as needed.

Usage example:
  int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);

  struct dma_buf_transfer_charge xfer = {
      .charge_fd = cg_fd,
  };
  ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
  /* charge now on app1's cgroup */
  close(cg_fd);

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/dma-buf/dma-buf.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h      |  3 ++-
 include/linux/memcontrol.h   | 13 +++++++++++++
 include/uapi/linux/dma-buf.h | 26 ++++++++++++++++++++++++++
 mm/memcontrol.c              | 42 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 837666273550..3bd26fbb1109 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 }
 #endif
 
+/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
+static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
+				const void __user *user_data)
+{
+	struct dma_buf_transfer_charge arg;
+	struct mem_cgroup *memcg;
+	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	int ret = 0;
+
+	if (copy_from_user(&arg, user_data, sizeof(arg)))
+		return -EFAULT;
+
+	if (!IS_ENABLED(CONFIG_MEMCG))
+		return 0;
+
+	if (arg.flags != 0)
+		return -EINVAL;
+
+	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
+	if (IS_ERR(memcg))
+		return PTR_ERR(memcg);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	if (!dmabuf->memcg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (dmabuf->memcg != memcg &&
+	    !mem_cgroup_transfer_charge(&dmabuf->memcg, memcg, MEMCG_DMABUF, nr_pages))
+		ret = -ENOMEM;
+
+out:
+	dma_resv_unlock(dmabuf->resv);
+	mem_cgroup_put(memcg);
+	return ret;
+}
+
 static long dma_buf_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
@@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
 		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
 #endif
 
+	case DMA_BUF_IOCTL_XFER_CHARGE:
+		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 85dd747c9b36..b01149d26b44 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -507,7 +507,8 @@ struct dma_buf_attachment {
  * @priv:	Attach private data of allocator to this buffer
  * @memcg:	memcg to charge for this buffer's memory. Set only for
  *		buffers backed by system memory where @size reflects the
- *		actual allocation in bytes.
+ *		actual allocation in bytes. Enables charge transfer via
+ *		DMA_BUF_IOCTL_XFER_CHARGE.
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f8ec751b7d7b..af02d9777fe9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -676,6 +676,11 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
 bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
 			       unsigned int nr_pages);
 
+bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
+				struct mem_cgroup *new_memcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -1197,6 +1202,14 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
 {
 }
 
+static inline bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
+					      struct mem_cgroup *new_memcg,
+					      enum memcg_stat_item item,
+					      unsigned int nr_pages)
+{
+	return true;
+}
+
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
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
index 17fdefc56b97..3e717b5663c8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5752,6 +5752,48 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
 
+/**
+ * mem_cgroup_transfer_charge - move a charge between memcgs
+ * @ptr_memcg: pointer to the memcg to transfer from
+ * @new_memcg: target memcg; caller must hold a reference
+ * @item: stat counter to adjust
+ * @nr_pages: number of pages to transfer
+ *
+ * Transfers @nr_pages of charge from *@ptr_memcg to @new_memcg and, on
+ * success, stores @new_memcg in *@ptr_memcg.
+ *
+ * Updates to *@ptr_memcg must be serialized by the caller.
+ * Returns %true on success, %false if the charge against @new_memcg
+ * failed.
+ */
+bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
+				struct mem_cgroup *new_memcg,
+				enum memcg_stat_item item,
+				unsigned int nr_pages)
+{
+	struct mem_cgroup *old_memcg = *ptr_memcg;
+
+	if (!new_memcg || mem_cgroup_disabled())
+		return true;
+
+	if (try_charge(new_memcg, GFP_KERNEL, nr_pages))
+		return false;
+
+	mod_memcg_state(new_memcg, item, nr_pages);
+	css_get(&new_memcg->css);
+	*ptr_memcg = new_memcg;
+
+	if (old_memcg) {
+		/* Uncharge old cgroup */
+		mod_memcg_state(old_memcg, item, -nr_pages);
+		if (!mem_cgroup_is_root(old_memcg))
+			refill_stock(old_memcg, nr_pages);
+		mem_cgroup_put(old_memcg);
+	}
+
+	return true;
+}
+
 /**
  * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
  * @dmabuf: buffer to uncharge

-- 
2.55.0


