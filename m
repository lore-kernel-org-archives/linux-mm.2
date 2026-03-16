Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8456F53D9F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FE16B0396; Mon, 16 Mar 2026 17:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2476E6B0398; Mon, 16 Mar 2026 17:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1405A6B0399; Mon, 16 Mar 2026 17:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED3606B0396
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F867C21EC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:16 +0000 (UTC)
X-FDA: 84553179312.01.C1AB064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2F6840006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddRg00F2;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwV6zs9+k3empwzyfCoLglaQ1RygvjDO/a1Nzu2pYl0=;
	b=KhdZ4YxwdRsDhpvreMIXeBAw/gbTA14q/yrv5DIosbpEqsLguSq9//mCsfCv22EyIee0pD
	qPpGDvtu30Mb1j+nYBFIRa7ZE2N8I6HngE51iosiEPoiJYj++ygMZD+yeC/SATxYbqQcab
	tc3cg8FilpkHDdfyByPSBfJDTPiw5U0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddRg00F2;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695655; a=rsa-sha256;
	cv=none;
	b=EgM2h34GJ4D/BuC498Ce5BeFBmM183ZEdVK6oUH9azZGOvx06hSijwQpv/uMcaTa27f5nS
	tABvOflFhrpVO3OmGqXK56dUvP9O6AVlg1QODxL+3LxiYIfO/0Bafmeu7QakiAPl3DuTug
	qt95fe3iqaaPp69gDz3/SDQLRYN6yC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18593432B8;
	Mon, 16 Mar 2026 21:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE46C2BC9E;
	Mon, 16 Mar 2026 21:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695654;
	bh=BqZ3dGXi/uNWrhmwwDUsKyVr3VEa4KB4Sn9UhtSbJGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddRg00F2T/2uy5ssm0Qrl1iCxh7BiYFPZ+3xDhRUzcquIPd3ir2brMNsn2DeZO9Ik
	 4Or6QCwnUlB7hCUX2R5ljuls0LdC39uPeGcT47HKe4eC66YadayJAeNQ72y1Bm/Am/
	 XISyzTGiUG4jtxWzTXO2EztA9dIxx9DZvTNz+uiTyo4tS3dDguhT8W630F98FNBp5i
	 bH3GB47keYIYSY8EnfMKeMEfk5mFomJJoUqJ94b43jw2fjBsRpqgkusxxIki4YERaA
	 goihMbGCBxAFXIjI6pK/Vb7S1B++J5F97P25GT6KOflLAWtvBO1Ju6TrdWN03FJaWR
	 I1g0WcCHY9ajg==
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
Subject: [PATCH v2 13/16] drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare
Date: Mon, 16 Mar 2026 21:12:09 +0000
Message-ID: <816d3c06ca3ec201ac8439a83383b9cb5e407ee9.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E2F6840006
X-Rspamd-Server: rspam08
X-Stat-Signature: feepnjmc4yfh4he99f7r6fjuh63xrphp
X-HE-Tag: 1773695654-320411
X-HE-Meta: U2FsdGVkX1+YELfil/i80ieCIWEiBn6BDPOr09yP9KuJ6oAo6gQgrJ5Bi0OL7NocW3za2nTz11ad81CfXOP2BAb8Q2/cks+FHdcnl7HG2kQfasXBwExhC5/gl87cftUYv75sPzHZTWAIe6RkkgNifDSdKl8aDR7WOeNq3MS9GFOkwyTtxpvBKBMIfxRuFr7GGEHSaOcZ0Jvonc46bB74+Od5Hqz+Cj7PFCglOOs+7VhAUQ33OzLjJuKhwoixLQK1VwJxvQOUKJ0Nxiv5x/Bx2rbWdXcgcjca2b0iZPmSezgmzrMPiPSWrdAjGFVZAAnSsT043KhLwxAYflvhOpIKeYvXo9kqf6GWz6eFSeT0klRzOr9n7ILZonGdvdiYpJLJzPsZIE7/BQE50Tip6ZQJiyRP9EBy4arGnJ2/Uzf8g2sxhh31wOP+ZpkeqpSNYSkh317zgD8RTKsdVXmPkZcYdz6nT1hvLUzak4Ys7HzLghOzuwYZU3qYcgZArZVibrsGTOKGX0mKE2Gj9M1slhghG127TOkpH2oiwqIdcU1cbm0qrT4q3Ig+PW56JriHoy8d6UoNre0k7O4PvfAAqVdRXF+lxcfV3D8JBf5k6tspCr1BebzN6H757bbRZIZJDGeGbI77vTBb/mzRKVWi2kxzVAOZ79/ydNkiGxW8Z4k/gi3HdU29kgpOjUO2/emQ8f4hEksTm9dEtSUHh0fbAGXJT+u+d7qbHq2rHnXDNmnnnWuy9MbFOndU/3tRyzduJyL23BuTFKc+KRepJ3I73fwnbeuyfPuT/avHjCHE73CF2+Dalq5b3PXwpEa/Fh2Y2UKDkR+tpZP1YtVGfWB5YAIwXVIpCnx1qTnvsqCDk7O1DBnHaahp0+re/c34eJy6+Pmh5Rk3wBNoRqmFcqMISrbcVNWeN8g3jHPUipWn8z1pGPx8NMP10YILi1orkKP2UTn+6FLElDWimG81HU53bI1
 YnGrN1TO
 3vTP9gHUQ1eJaqAAbuHBzCyacE3G0ctVWzljevfO6H9KxfOnIy2I4mj/1Mn+6A2wyyx5cmNkN5sS/bdauukTJcUBRABa7vQSmi7Jvi36e70bjLEHRY9uR/13HwkJb9jIFfFZB2kNquUTu2JyogJcPUEyomyU6KExvJ6PUIysoLI+r1NTe4IeN4Faff2ylLQmI9ljh/f9DnqK0g9aP7CvfTzwPq2KtF1bq5FHO1yv9y7jC5wPpWKK+JoenZd8VkEJ07UHaocqGIH/qsgiKHiflpqqbIUZsNFYpRpY1yM9kNakL8fcZ/RV+J3KRYm/pzPiDJtmWdVhkNLCHpGu6vLTfhLf3ua8vjwlHT00FzhJLHm3STxoxe+X9UOCOhTdfAU5pH4E9caRKnEipiHAv5jCqbv4SnFr3lfV67aGLUV+BvXxMnlSMK0uFsmWa1SmSHHFwMkbPSzoWLzyNiJ0pMCIvst3Jjg==
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


