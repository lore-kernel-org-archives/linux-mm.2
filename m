Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DBF109190B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839716B0574; Thu, 19 Mar 2026 14:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EABF6B0582; Thu, 19 Mar 2026 14:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357EE6B0577; Thu, 19 Mar 2026 14:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8A86B0574
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B87238C293
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:25 +0000 (UTC)
X-FDA: 84563637690.11.546A8A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 21BEC20007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJK0BhPx;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpyrJDtEcfK31WekvvFctIFyXCehDJ45NDia2zmBN90=;
	b=6tg8STxGlD9ueQGctlo2iWDr14+AonGi2/kA3hu8YhdVf8ZiIz0uTABRJMSunw9uHqXYGx
	yzH1kJ+JX/R3ymnjlK2Kj7Nh8FaK4wD1OWLyhbFS53M8weG1CobzpUX9l/EcZSbW4081mC
	vM6cdvJ/MC3wOGW8uRQNAeTm5WdlPXY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJK0BhPx;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944664; a=rsa-sha256;
	cv=none;
	b=0iJuN6Vz9gyYj5MHnI5EqA0fxcJ84NIjTVzyfblc7QcnDTWhKS6MJlJxPIk0P7ZbkmXG/l
	s4gQkWyl+yfHr7T/WFUSx2pTvVarDLfWPGXWOH+YXzdGGt4t99OY2DqbLB6R3bDwNtlxIi
	iVcy1qtSMXu3lL7G4do0bbvAI+msVOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 426E74356A;
	Thu, 19 Mar 2026 18:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF46C2BCB0;
	Thu, 19 Mar 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944663;
	bh=xqeFdev8haZYqVKb9RyAQUT5x4QpuIREk0dFqk3m3oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJK0BhPxcSG+aCy4r2yWIpJpiiD03CkqXoBJOB64BOS0ViRvag8rx+Jnjfqk/SZPL
	 g666deEFztMfmq3C2UsflBp0Z2rTqhdAlTdDNUGmiieudG0ZHa+EzXuP/5tFceEa55
	 urFi/WhH8H3i0ZWA3A/GBJn03pACqTekFzJEFt10rJa4/OC48XV3WXeqEGudATQQ5M
	 3Kc+Ygte+TIBN5hdPiaxTnjkLug057IKcR1T+UZxAr5kZSRjh9IVPlBrlcE04TPAlZ
	 jtZ5xazL9mGvdIctT21/0EO4CW5WDNIhApQQ2fWM0waBBg86FbMH7cLNXxeIlGqvVE
	 9EEiACvAfrgqg==
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
Subject: [PATCH v3 13/16] drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
Date: Thu, 19 Mar 2026 18:23:37 +0000
Message-ID: <e300a15e0576ee4b51a519b51bcac7e4a0871442.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21BEC20007
X-Rspamd-Server: rspam07
X-Stat-Signature: z88iouo48oex9gfaqrd397up91ezkh4w
X-Rspam-User: 
X-HE-Tag: 1773944663-982377
X-HE-Meta: U2FsdGVkX19OSrn20Y7gu7Pgqb/aS0xRQr03wShOjOcENr9kKjDw57GrMNAKcbkg7EbaTI8fNO52dAceFVXCt240e4YGEf6xWxRRtgd088H94N5bwE92IDRxXdy5runAakIcJkCk35oHeD13H/KO9iCDf/UtGz9na/7Jqq9rJ0MX7ol3lgLcEXh2mvcGyTwKmcHUp3l+rag6tjw+rFp2h1z57FnBk1bxFS9w50673CuGFBVwO+t6/lC2EFifOmIl/ORJNXAsKD0A0FRl0PwF/48o5SAwXXPBu709c27y/hYYBNaSpw4Dl1+FF4P/qGq3vkHFSyl0+tRcH1rqhhCK4SOhs2Qy6WOGJWfM3yxNjr+k/SIP9bhIXdtWxd9ATPyVCr8WGjH+o8XXvT4YSzqxKprYIU3fD1x5Va6xR4OCwtgbvpmxTdGpLPsgC6QxoefWnk6MvL5b/TFq5NHulUpm6sIlquJ4N8oqnNcLybYps/+1K7umWEilYaCpTab80ICCHRNm0xZeemYjVzJmF5lp/13vVZWx2Wo2bLUKWCvsRQQsXE6XrXZ2CzzKdDRjKhLD/4Qw+CWFH4D17KivEtFWBofGoSK7Yt05E8OPGfwg8OwYI/7qCenvIey2FQzS2bcrHuqbMBvlXvRWoS9zkQooSmBVcNuqiTrUC7eCLPuJMiBDjeg2hgUYH3RxcqQZhdARoJJqUwB8qCDygQEvbOV4rsQp2fUMHEUe7n6nz/sCW9Ve4/BSjGQA033sRH+kG+NGcfFagcF7MNglHCfEB6MGh0T4eGC+Hjs335X8B11jdgmpfhpZ8sX0dvEeMt2wF/9/fGMi+pQZ48L6pcpYWih54gCV+p8vPNNqY3cZW5cvJL1UcW3kT4ER0/BBkxIyqxccjVRT14pPwik8ab/tr0k9B4NFnXFvnUFHLT2VFIWqIDTS3Lo1zBQ0X2zcwbKKPEnLxAO+g9Jr3+Ntn27JrVD
 lMi1/9Tl
 ZVLYGzZ05S62p/Cbgi9UPyuB2Io5bOToOxm9kTDvYsaRcDzhanSMzFkebR3oFjF8zXcX/JccIFm6K/YTMooHVmbNqDQ8OnNaP8gNtWlZ251amVw/bNRzYeJ6lax6qDVm/8/OpifTPyOlHGYsoMXBbc8D3lfpNIg3Je//T3aqwo2aS2WOwia67PiBvm7fZlSJgKOESfSX9V2msKbIMLHfavITmzk3++bn4IXwgu2QhhW7zA8OQvYIiDzZsmJy9LmGDRrEr9bCywmyFI5LjeDMEJOrAg66ZCP+NckG5lENvaOkU+HHzvvfFSvgRFoiEm3m78iqd6JEn031Rav6006E0psVafl5zbNW0Mc7+
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

The UIO HV generic driver is the only user of hv_create_ring_sysfs(),
which is the only function which references
vmbus_channel->mmap_prepare_ring_buffer which, in turn, is the only
external interface to hv_mmap_prepare_ring_buffer.

This patch therefore updates this caller to use mmap_prepare instead,
which also previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/hv/hyperv_vmbus.h    |  4 ++--
 drivers/hv/vmbus_drv.c       | 31 +++++++++++++++++++------------
 drivers/uio/uio_hv_generic.c | 11 ++++++-----
 include/linux/hyperv.h       |  4 ++--
 4 files changed, 29 insertions(+), 21 deletions(-)

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
index bc4fc1951ae1..45625487ba36 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1951,12 +1951,19 @@ static int hv_mmap_ring_buffer_wrapper(struct file *filp, struct kobject *kobj,
 				       struct vm_area_struct *vma)
 {
 	struct vmbus_channel *channel = container_of(kobj, struct vmbus_channel, kobj);
+	struct vm_area_desc desc;
+	int err;
 
 	/*
-	 * hv_(create|remove)_ring_sysfs implementation ensures that mmap_ring_buffer
-	 * is not NULL.
+	 * hv_(create|remove)_ring_sysfs implementation ensures that
+	 * mmap_prepare_ring_buffer is not NULL.
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
+ * @hv_mmap_prepare_ring_buffer: function pointer for initializing the function to be called on mmap
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


