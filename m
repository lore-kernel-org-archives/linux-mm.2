Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720B31099B4D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01FE6B013B; Fri, 20 Mar 2026 18:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4DA6B013C; Fri, 20 Mar 2026 18:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC4E6B013D; Fri, 20 Mar 2026 18:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4726B013B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5144B1603B9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:59 +0000 (UTC)
X-FDA: 84567913038.22.5379BF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C67DC1A0014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta1BWmG+;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpyrJDtEcfK31WekvvFctIFyXCehDJ45NDia2zmBN90=;
	b=rAZRV9Me1k0XM8j+P5dQolqFdHETyRl/Q8RJ2Rz9LTXzAqC7xjpfgHm8K4ZcDeuJlpIHWg
	vs9CSZ5hc4z1wnMAtZBippGG5wQ4uGMu6d9jFhQWTfDk+8KQcawj97aKnGU67xpMqJXt9Y
	RI3G1ciYiy6VvR+sSv2opkUsJSa/cqM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta1BWmG+;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046457; a=rsa-sha256;
	cv=none;
	b=bb3z+T/IQXBZvNj2LEgzii1P3mazvMlyQ1h9+O1Pc8bm5jt4cmox9cpdUVL1/SW3GyZwOo
	Va5i+/jucmsFbzXYyiJkbPvD+ac2UKWOSNrdHp6NmWrDqXpxFr7c4/Bg0W/LmcJDBtqwv9
	liGqfGF1UBeiASLaxxzYRb7s8XPMbEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D1046013A;
	Fri, 20 Mar 2026 22:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EBDC2BCB3;
	Fri, 20 Mar 2026 22:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046456;
	bh=xqeFdev8haZYqVKb9RyAQUT5x4QpuIREk0dFqk3m3oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta1BWmG+lKEvULUrkIqxcRrEauWLsPXM1vw43UOroW5hCg4QdgHQBNdQ6lzuTH5S5
	 DkWLqekfny+lspMP5VejVzvED04z2eHKToE6Rst7ECjJniAb8+zQKeFYZ1eJz77Idm
	 U42YuzuNtW+ULPShZpun08YIPI0Jt/5zTpLV0cwrmkGcSSIfW9R5R9apFNiqUqrLVl
	 XQPbMYRAwOp09T1kmPM6ucN6Nn6t50F7LM+mHsj+e20Uqv1tWX5lSbYyyVLdVjxSHv
	 bhJ88OMstEOxhd6UjedfwuzadWGPmjtL96PIa2yfgf63ZyMDdOgOrBMsFUvVRA3K3X
	 5P4jhUQTq4VaQ==
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
Subject: [PATCH v4 18/21] drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:44 +0000
Message-ID: <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C67DC1A0014
X-Stat-Signature: 4rut9b4dufhiuwcbmz4mr4adwo8tx6ks
X-Rspam-User: 
X-HE-Tag: 1774046457-813859
X-HE-Meta: U2FsdGVkX18Poxu0DfyDg6+MHc/hefrMgIt5bey82SkHnZNQT07YVOfmC5HKiFMDKu5un4vYSD9Z8gW+YmmHA+SwaBfSHNZLzOPfCHKtuJatQpzbW6f50UjR41hcfy3x1YH7BTgCwj58xsVvnTDOAlU7xFGfhI1Ua1YNitQ9J59i4HK0jl0uuzwlZ+9lrRnWXtO2cRbCkwDWXYVQiad4dyBfVyMA7ggARnm95vR9oHBvtKyfO4tbKlgdG8+B5YNwl+6eiHsiWG40ZRzHykFlVXeIe6FFDxDs+zukDclkmwr3QINplEJwYNelOLN/9VHa8prxsBuwK3RrSLvCE1mvyC8umOhWTi4R9T/g8J1me4mG0nUveV5ccZlRxnjjhFuA8QHvcz467ijzfNEzKe6398/PQ6D25zJwvuYZ3zK5o17vnnByYhgrFw2cHgLx+Skg59Ztf8GdhN9zuK4NotFlXFI9x8c4YIGlhCjMBBmKyXms3qgTL7KBtoZRwfHcf4TPuR5mZ11bnt18X9XgI35CAVtodKWckgYtanaa9kux7GPkweeUH+H5Q2KbQ9G1qDuVufiVASD+LoXXx/Fvz2T1RWi+Lwk++8SmYM1Wr/ZnWNwaRT5pdwSFAojwa0xP2YMMoEbHD+r7GDhRoNSYhpCTE3ieTZISGPOXiZN93V6bAgOLfm69ztD4Ij7HrorrSDHitV8RgINRXVzSDcrZRh4A9v8lQgvhxJAZmF4WtFQQhth0BI7uoNyNqtLzkiZiDWiPDZWFV5EzCE+amKFD5zRngm6+v4OMIsd99lCxDKmlSQJdPYeEfwM6jjWePAlOZBHKy6WnavIhEuXXRSZM5Ky7xI3NJnPnlBH2PLcCsowvV8d4vXTf5EJFWyv6hFM4qTmfuggPbqn7gzmlvQMxuAZGGXjnZCxByy1gsXpzl173xejb73KQzb+Qhls9CBvsayBGWadOYg0T3a9mcRzLgwX
 9sfOcKX8
 YagAxJ3r4C+Km3S6fu8uf3434iSXKc1mo78YrBz17mQCRvnLXsTE9zfVocKhkT3rLDJZI/t8Hh++9bPDg4N85d5aXMej80u4QaPqkLKdG4qk1MxPeeyEP1MKCS9zUNOgDP1/cqbVn667l9ETaqUvwN0fYuUL0+BeZE3VjUAOeUeMB6VQQy6bTC80k3rySFXeji6NrdZ6R/cpX1vrxebe2zSZ8ZTm5EzYESObA8V1HKZqUDs6IlPtf5g4ukXgKZb4MjevNDzl2KZiSQp91n5zr4uCAxQXAYdJ3KihL2FUlunB74Nv4I8qMgiyZoRY98+ycAxDbN2AjZXh686OD2Je2/lytBIViYswOLOuh
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


