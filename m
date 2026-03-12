Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF433106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244816B00B0; Thu, 12 Mar 2026 16:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED556B00B2; Thu, 12 Mar 2026 16:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E186B00B4; Thu, 12 Mar 2026 16:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4D16B00B0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FF471C498
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:21 +0000 (UTC)
X-FDA: 84538548402.27.4546A70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13FCE1C0011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE1eoNLL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2h2/7B5SW1IOrm3FHhkF3Mr//C+9sr2Q38u6/IaUNY=;
	b=Z2lrmXLzJLmLrBp4JDhLqkOBZkhJg20ES2yG+fCM6wVb/CsBjSExojw7lewnanL81VJsdR
	FE1+DCge2+c2sgYO2hEGP8m4X1w4TtlxPZdgOXvxLBRiyXoYD1zUoySJzw5nDxqo+EvgEd
	80VbNqasJte5gntbasmKNfBXb0wJn78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347300; a=rsa-sha256;
	cv=none;
	b=pQR0C2zyyKGH8IwqGq3hZ756TxGMEzWwIIAcXRvr9c1g71a5+4Z+t5QERz7Qd1kxtWmPJk
	eAlKAh85YX9joTchydqwxNCDG7zorZFL4jFG3pQO+pHiua7yhxICYtfuK0cEojoJAT1xlS
	EunUB5HHjUifo7u05+aRYv2VwmIhF7Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE1eoNLL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92BDA61840;
	Thu, 12 Mar 2026 20:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE0CC2BC86;
	Thu, 12 Mar 2026 20:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347299;
	bh=3gkyUtsSx7jHel7cmRKZSxJv14d/Oyif1xbXqVSUag8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SE1eoNLLnCchG8HnK6XRvfFeHKhyfrzwwjiWm9QdAt5SsrbT5Uw9DpSpKd50HTu4X
	 xdndXitgm96uIJn7PRDHQ7k9Hgf4LZp/zIwyQxTDnU08FmxgNaGLbcUr/QaZemp3i6
	 DkSmTS08I/Wqy4/GCxky+IbGqrb4HTAtMgXkKY6chyfRut5Zuvanm3/fJh/KyDnajD
	 zgAsNGcfUqJVqPQsSSgeeaMqILTnr1t9nv9XdS8jqAAcPSUMs8GYDUPyMJIN6ryyR7
	 WipiB8AnSPEZcCIwFfuXFjLJFpnnAcxDM1jDa9nEcFSnQ+CAffoYMGMMWgKSaFy739
	 ZBR1/mSnh9p4Q==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 13/15] drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
Date: Thu, 12 Mar 2026 20:27:28 +0000
Message-ID: <1f0408ba81f455d35bcf510ccd3dc3cb939b55ca.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13FCE1C0011
X-Stat-Signature: mc8d3wswoqbhzbhcrdkwhj4h1s7b5onx
X-Rspam-User: 
X-HE-Tag: 1773347299-571021
X-HE-Meta: U2FsdGVkX18OhGrIXbVk9A4l4/xMqmbuflPfQGtMHNmUHf9wYiBvKfZ81ECM80FO7P8JtjVpyNuO8hoZHbjiP1gIxy4Q7V7609P7A4cpjAWAZHsYfNlsMtdd8E+YokmYGfNxlCh6N+1nbfRp78POUvw4hKwrgRD6Te0ccg96UzKE5HrR58qASwG8ugbmMd2UCgO2MyvTBbzMgot/bhrm+SNMqPbKbPXlMWsa+JqtnCDnJULrXKbFuwLuBIHnOwf+82axtXS4uDFsoKbgtbim2EucvS5CKt6Nf12nKTscQPaCvzuXbKhZfgSrmrM1tnm9bc7DyRdjhMvPqUIZu42TMXIQ5Cv0i5Rf10CEgTf9pwGGcDNGCDblEoCljz8zMNGrVzD4pqlfRAmXsaBGAn0DkwAvPHJmkQl516XpBTlyXG9vYIJPs1ZagBAz8pWy5JJQeIRzPYgA++eAxCWHuTwERZTwZ+4kuA8hvN+t/ONu16hSrRJtr7VGmcka267o12JNi+3q/gI7vBaA47JrI73F/mg1Mpqg6+Lbtpik3Z+TVjQaKKCwVdP4nNTHzY7KE7tIH5Egn5ImIzheEZj2sWaqPEgEYfDcoE5VTswukrb5HH+HHA/OMe0woQ7aPuq313/HJAlP/+/KFr0yBeOsWIiP7sR1uXKbfvxLe4fUXOwU3NPYFF15T0EmhJ7znP/W40HhjoEir4lOb+ahTQe60p3b2R9vsEOi8yLp+FZrluu8/hDvkZR8Ogd2Sp6P6f3beHLqj/Od37C5rHtAtYg2bDaKn0esiDsj8bVlMWKuZR72jLbSXU6sI0tuLy1aBS+9HJlxz2pTMSf+pkyv3xgR4x3g0ZhbHZR0l0J+VMWHLz0FSLbb13gR+SMzdrj4/KmF1yoxFSgMBPwNkBqlZA7iFi3RH0OkDaNB6qNZ7mFKokll25y1Ial0HJQ2mw8NIfTnDn4X8N4YH8bxAykrd0hGiOL
 x9xgy1vc
 GdBnrTtnB9rhqmludfm+3XV+dqwBQurQ7I43zLEjrEQxJTbhoiDblWH5sLO9391WjceJSmi+zXsIjNIOzCQLwpUugx9nYgyIsb7bkDmnN3FezJwB/N2HYv0R30PDYpC+H/EykKbTGEbkVRRir3JFkAlrkRVLEd+gIJKW+tFPc/mno3ru3dbMIXUxHuszvP3zavZy+DSxwRJuBg3qvIb+c0In8p3cRIdhV46iDIIrARxhS+KK+V8cy3nMTEgiU9FfRrzymreKxrQEjH30IIxnexQWmrMi0mRfLWDXS5ACJ77gWHFLWfdeU2TQcTBbL1x1c5/cyYGM64uDqfIGBgu3c7isRZIHcbGpepc1I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update the vmbus driver to use
its successor, mmap_prepare.

This updates all callbacks which referenced the function pointer
hv_mmap_ring_buffer to instead reference hv_mmap_prepare_ring_buffer,
utilising the newly introduced compat_set_desc_from_vma() and
__compat_vma_mmap() to be able to implement this change.

The UIO HV generic driver is the only user of hv_create_ring_sysfs(), which
is the only function which references
vmbus_channel->mmap_prepare_ring_buffer which, in turn, is the only
external interface to hv_mmap_prepare_ring_buffer.

This patch therefore updates this caller to use mmap_prepare instead, which
also previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/hv/hyperv_vmbus.h    |  4 ++--
 drivers/hv/vmbus_drv.c       | 27 +++++++++++++++++----------
 drivers/uio/uio_hv_generic.c | 11 ++++++-----
 include/linux/hyperv.h       |  4 ++--
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 7bd8f8486e85..31f576464f18 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -545,8 +545,8 @@ static inline int hv_debug_add_dev_dir(struct hv_device *dev)
 
 /* Create and remove sysfs entry for memory mapped ring buffers for a channel */
 int hv_create_ring_sysfs(struct vmbus_channel *channel,
-			 int (*hv_mmap_ring_buffer)(struct vmbus_channel *channel,
-						    struct vm_area_struct *vma));
+			 int (*hv_mmap_prepare_ring_buffer)(struct vmbus_channel *channel,
+							    struct vm_area_desc *desc));
 int hv_remove_ring_sysfs(struct vmbus_channel *channel);
 
 #endif /* _HYPERV_VMBUS_H */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index bc4fc1951ae1..a76fa3f0588c 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1951,12 +1951,19 @@ static int hv_mmap_ring_buffer_wrapper(struct file *filp, struct kobject *kobj,
 				       struct vm_area_struct *vma)
 {
 	struct vmbus_channel *channel = container_of(kobj, struct vmbus_channel, kobj);
+	struct vm_area_desc desc;
+	int err;
 
 	/*
 	 * hv_(create|remove)_ring_sysfs implementation ensures that mmap_ring_buffer
 	 * is not NULL.
 	 */
-	return channel->mmap_ring_buffer(channel, vma);
+	compat_set_desc_from_vma(&desc, filp, vma);
+	err = channel->mmap_prepare_ring_buffer(channel, &desc);
+	if (err)
+		return err;
+
+	return __compat_vma_mmap(&desc, vma);
 }
 
 static struct bin_attribute chan_attr_ring_buffer = {
@@ -2048,13 +2055,13 @@ static const struct kobj_type vmbus_chan_ktype = {
 /**
  * hv_create_ring_sysfs() - create "ring" sysfs entry corresponding to ring buffers for a channel.
  * @channel: Pointer to vmbus_channel structure
- * @hv_mmap_ring_buffer: function pointer for initializing the function to be called on mmap of
+ * @hv_mmap_ring_buffer: function pointer for initializing the function to be called on mmap
  *                       channel's "ring" sysfs node, which is for the ring buffer of that channel.
  *                       Function pointer is of below type:
- *                       int (*hv_mmap_ring_buffer)(struct vmbus_channel *channel,
- *                                                  struct vm_area_struct *vma))
- *                       This has a pointer to the channel and a pointer to vm_area_struct,
- *                       used for mmap, as arguments.
+ *                       int (*hv_mmap_prepare_ring_buffer)(struct vmbus_channel *channel,
+ *                                                          struct vm_area_desc *desc))
+ *                       This has a pointer to the channel and a pointer to vm_area_desc,
+ *                       used for mmap_prepare, as arguments.
  *
  * Sysfs node for ring buffer of a channel is created along with other fields, however its
  * visibility is disabled by default. Sysfs creation needs to be controlled when the use-case
@@ -2071,12 +2078,12 @@ static const struct kobj_type vmbus_chan_ktype = {
  * Returns 0 on success or error code on failure.
  */
 int hv_create_ring_sysfs(struct vmbus_channel *channel,
-			 int (*hv_mmap_ring_buffer)(struct vmbus_channel *channel,
-						    struct vm_area_struct *vma))
+			 int (*hv_mmap_prepare_ring_buffer)(struct vmbus_channel *channel,
+							    struct vm_area_desc *desc))
 {
 	struct kobject *kobj = &channel->kobj;
 
-	channel->mmap_ring_buffer = hv_mmap_ring_buffer;
+	channel->mmap_prepare_ring_buffer = hv_mmap_prepare_ring_buffer;
 	channel->ring_sysfs_visible = true;
 
 	return sysfs_update_group(kobj, &vmbus_chan_group);
@@ -2098,7 +2105,7 @@ int hv_remove_ring_sysfs(struct vmbus_channel *channel)
 
 	channel->ring_sysfs_visible = false;
 	ret = sysfs_update_group(kobj, &vmbus_chan_group);
-	channel->mmap_ring_buffer = NULL;
+	channel->mmap_prepare_ring_buffer = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hv_remove_ring_sysfs);
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 3f8e2e27697f..29ec2d15ada8 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -154,15 +154,16 @@ static void hv_uio_rescind(struct vmbus_channel *channel)
  * The ring buffer is allocated as contiguous memory by vmbus_open
  */
 static int
-hv_uio_ring_mmap(struct vmbus_channel *channel, struct vm_area_struct *vma)
+hv_uio_ring_mmap_prepare(struct vmbus_channel *channel, struct vm_area_desc *desc)
 {
 	void *ring_buffer = page_address(channel->ringbuffer_page);
 
 	if (channel->state != CHANNEL_OPENED_STATE)
 		return -ENODEV;
 
-	return vm_iomap_memory(vma, virt_to_phys(ring_buffer),
-			       channel->ringbuffer_pagecount << PAGE_SHIFT);
+	mmap_action_simple_ioremap(desc, virt_to_phys(ring_buffer),
+			channel->ringbuffer_pagecount << PAGE_SHIFT);
+	return 0;
 }
 
 /* Callback from VMBUS subsystem when new channel created. */
@@ -183,7 +184,7 @@ hv_uio_new_channel(struct vmbus_channel *new_sc)
 	}
 
 	set_channel_read_mode(new_sc, HV_CALL_ISR);
-	ret = hv_create_ring_sysfs(new_sc, hv_uio_ring_mmap);
+	ret = hv_create_ring_sysfs(new_sc, hv_uio_ring_mmap_prepare);
 	if (ret) {
 		dev_err(device, "sysfs create ring bin file failed; %d\n", ret);
 		vmbus_close(new_sc);
@@ -366,7 +367,7 @@ hv_uio_probe(struct hv_device *dev,
 	 * or decoupled from uio_hv_generic probe. Userspace programs can make use of inotify
 	 * APIs to make sure that ring is created.
 	 */
-	hv_create_ring_sysfs(channel, hv_uio_ring_mmap);
+	hv_create_ring_sysfs(channel, hv_uio_ring_mmap_prepare);
 
 	hv_set_drvdata(dev, pdata);
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index dfc516c1c719..3a721b1853a4 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1015,8 +1015,8 @@ struct vmbus_channel {
 	/* The max size of a packet on this channel */
 	u32 max_pkt_size;
 
-	/* function to mmap ring buffer memory to the channel's sysfs ring attribute */
-	int (*mmap_ring_buffer)(struct vmbus_channel *channel, struct vm_area_struct *vma);
+	/* function to mmap_prepare ring buffer memory to the channel's sysfs ring attribute */
+	int (*mmap_prepare_ring_buffer)(struct vmbus_channel *channel, struct vm_area_desc *desc);
 
 	/* boolean to control visibility of sysfs for ring buffer */
 	bool ring_sysfs_visible;
-- 
2.53.0


