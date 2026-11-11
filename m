Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C854606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=OOQ46D6t
Received: by kanga.kvack.org (Postfix)
	id 5413D6B05B0; Wed, 11 Nov 2026 18:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5187E6B05C0; Wed, 11 Nov 2026 18:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F5D6B05C1; Wed, 11 Nov 2026 18:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11A466B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:04:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97591140467
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:04:25 +0000 (UTC)
X-FDA: 85424368890.28.ED8AF8E
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3EE05140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:04:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OOQ46D6t;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOEMGTQJ+toDki7kvuJT6JtXyBGtOp4DrkKcaIoHHvs=;
	b=L0cSXVZQvRLpd6R8IxrAEfqhGwOaqiXV7c42XLlBEess1w+7/PGF7hN/DG+GWosCr4hmNe
	+Vm8qe/hQ659Ni6ppZblaCN3bLBvh0pjLLxEQiKOKnZsOuUYrodZw2IUMN2De8Py+lIizo
	VZvn4KJQgDMZb+Iwe1yAQ+NaGT/5Gi0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OOQ46D6t;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438263;
	b=OKkofFHBECT0Tph/IaUOBtnsTZ8gM95ghxOdQQgIxqpbs6ol3hWmfk7g5jDLO2cv79rWPy
	66iesjZew4vBQjo0omnrAos+0EySm8vMBLB3pbaqj0Dy8FNNbg5MMicIWiJhlqOTIBFFdG
	EVX0Wt6wffadtu1zdSrESYr9xBSyJ2Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438263; x=1825974263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rOEMGTQJ+toDki7kvuJT6JtXyBGtOp4DrkKcaIoHHvs=;
  b=OOQ46D6tROqqRPjZboKXIgK/4PyMLRj+6E1A+B8wbh7Y8KN+RS48HGKI
   1x7GaeRTPnaz2185cKEnYZvPPZIDPeq04sh6Bg/JwW2HW5+hVIoNIwfB+
   I79A4n6F+zLJCX38fCa5hvKzZUw2fov7AxW/SD2DWHIMMtKLEnHz3XR3x
   RiLFz4jkpm+W0M+CVNp90FIJmVJAABnShHD88WcCBxoqtAGnccP3/um+b
   LNT/nUgKCK/mvV54f7dGOcVKE+224VIvwi//nSbSB0cmqbFzikf7xlqjx
   SXSkFksRblMfpQ+bS1YBiOpmHKA+m1ChdEtyRYmk47adsaceEwa2bRUhm
   A==;
X-CSE-ConnectionGUID: BOL+KG0SQnitUQxlhr8h5w==
X-CSE-MsgGUID: eApXz3JaQyqH6tGmqN6HAg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33274440"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:04:22 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:27510]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 528610d0-34f0-42c9-9dfc-8b5d0d7b78d3; Wed, 11 Nov 2026 23:04:21 +0000 (UTC)
X-Farcaster-Flow-ID: 528610d0-34f0-42c9-9dfc-8b5d0d7b78d3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:04:21 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:04:18 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 23/40] nitro_enclaves: Add the device add command
Date: Wed, 11 Nov 2026 22:59:27 +0000
Message-ID: <94acc8f58f24e29912b8859859d739460cb74406.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3EE05140009
X-Stat-Signature: zjk1idht6bpyqdwzbkq3xy7te11c94ex
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438263-446018
X-HE-Meta: U2FsdGVkX1/o5Ru33OezWDMdo9w5BVegS3gnFHZ7MBroVAO4pwe/sko8QByUa8MhTpcOp7YjDrcZ85lt2lfLSlZF4kSNLmnmFeoQB29nli/RwT5M7lEnt295p+PhcTrtgspXbv+wmoZYLp3ENNxrRm5GIWrH2FN//EBrxNDLFziPh4CPDXy2zgyWG3PMpy5ufj4FAUbqyYCkWn1NkLc/WNhYkZIj2VBzzyl4vCZn08pvgl0DBCsQ+xsRYstIuoWfJ7gGyFpGi1PCbklBuc6llszC1RcLLbhEsBdJigfv3gbCpaYsjJ4PXraFqzmJRj9850eJjjpdqBMaXhrk+W6uE1cCg3ZvfZ0pKxjMyd0LsflIGvW8T7zLGTtsNC6uLtUexYOiriA4YzR6YcRTNWCFXV/jXDggxWvUl2BVv7JCfvPL2JKoWfkN4Qv6kPbYmNkhslmMao0lkwxf8p1mq+sIpMS0pnDAKuuZygAygjiiYN3SAj4wAA4D9LUrWHfaW/KVrxo1QXhesChHDHG2GqZp/RwcVv0/WP+CR5ObJgRj9YGNheuT945awqZLSMMBjVY2OS9wJTBMbuGmof5t6HYioaNDHpo0pKmf//GETMh/6J4eDXRyJ/6c62KuMfWYoVF6Kol06DAeQ9/KG+Dw3EH4hhTN7hnsvVHaDOT6v27rzSDYVATJu/5BrcsB9wrm+7VH/6wdf8i9KmlEPKg7Shdifl3CY4Vng59E65qjkMyizsKNsIGsLhB/lhCdEQhccrtpLVZTUa6uYQrK5R2XnxG69BtvNoysf2Z5zzz/vDVPH46AbeHYUqq0tpzrsl5mCE0kOXbP5SWCnfsnYAAQamZ3gJb1T+E1R19+qIDqLc/rJhTIOeFSIZ7HYMYRwaEV/EERdjl9MeO9rnEhsHH3t0Lb7xMhCfEm3jkgd4xVJIWMfkDOJyZ/QxaBoGKlyx74Cc3bZK8O+MeXFoer5h13ZtJ
 neukqdPF
 QOzwTyOVgJUHZxOYAh5exyXSSxZVogaJMreahLfQiHltmsyymFcWMuf40RpmzjxW3dZWWvLyDWtSWg3oiLGCJ32Es6+ZCwSgMKy9antcafPGwvESUwJG8ZnjldtdzuRIjWngUpsiEArNukKzJJ6LuQQhx6AXqvgFSXj0iV/g+G5ybGfRsiR4m74JnfVg+q8dLqIym19LqhCrrV6cj+pDpsef3ZL34F+9x5N/wOmK8KoxMNtjHUK18YDTAwA+h81gm+3EsoKnqIhqPUxH5FnTmVmtnarGXxwkkv6k47vDGMKXi8GuD5s6xV5L6p7TeuCLNQiFb52m82bD36GakzfX0pEVPh3rH+FEyIn3hxAPbxDJU4LsvjcwfVNF2Ilj91RFY2D2DlZTyzsGslNntOC9yJdg2rksV3vdc4PNWTdISrNUNUTtPOgQxGPXVUSlLea/RA3Wx7aDbtiBMvuQDFq9AMmb6lQCGmipzIxCQAE8S9WmA/9omNT2UDqQjLBu/IgQvCCh19pSuuFuvRUPdreznCOblaxKRDxxAiIgohG9w09OLvDdow7/+cn7OoQK6TiI8ypfBoxx2XgPqf++RQLpSO+bky0xkBpaSW8l+OA/5ZpRezZeSS5ESJNXtiAyLK7UTsxyBBosrGUMrnBGaRe9vI0ij2TgJRvlpCLl0si1vMGSLopqFxDR6TFQLjHMfdnrdFT450Z6yxwnKy9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support Nitro Sandboxes, which allow the parent to
back arbitrary virtio devices, add the command definition for adding
devices to a slot.

The device add command specifies the virtio device shape (type, nr VQs,
features, config space), but also allows to specify backing ranges for
DMB or SHM regions.

The full response with the device information is part of the info page
at the returned offset.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 88 ++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index f5cb24312d442..3445318b84672 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -161,6 +161,7 @@
  * @SLOT_ADD_BULK_VCPUS:	Add a number of vCPUs, not providing CPU ids.
  * @SLOT_ADD_INFO_PAGE:		Give a slot the info page, a memory region the
  *				device writes.
+ * @SLOT_ADD_DEVICE:		Give a slot a device the enclave will drive.
  * @SLOT_POOL_DONATE:		Donate one page of parent memory to the slot
  *				pool.
  * @SLOT_POOL_SHUTDOWN:		Give the whole slot pool back.
@@ -186,6 +187,7 @@ enum ne_pci_dev_cmd_type {
 	SLOT_ADD_BULK_VCPUS	= 11,
 	/* 12 is a command this driver does not implement. */
 	SLOT_ADD_INFO_PAGE	= 13,
+	SLOT_ADD_DEVICE		= 14,
 	SLOT_POOL_DONATE	= 16,
 	SLOT_POOL_SHUTDOWN	= 17,
 	SLOT_POOL_BASE_DONATE	= 25,
@@ -333,6 +335,73 @@ struct slot_add_info_page_req {
 	u64	info_size;
 };
 
+/**
+ * NE_MAX_VQS_PER_DEVICE - Highest number of virtqueues one device may have.
+ */
+#define NE_MAX_VQS_PER_DEVICE		(64)
+
+/**
+ * NE_MAX_BACKING_RANGES - Highest number of memory ranges one device may be
+ *			   backed by.
+ */
+#define NE_MAX_BACKING_RANGES		(4)
+
+/**
+ * struct ne_backing_range - One run of enclave memory a device works out of.
+ * @phys_addr:	Physical address of the run, in the parent's address space.
+ * @size:	Size, in bytes, of the run.
+ */
+struct ne_backing_range {
+	u64	phys_addr;
+	u64	size;
+};
+
+/**
+ * struct ne_vq_wiring - How the enclave reaches one virtqueue of a device.
+ * @msix_vector:		Interrupt vector the device raises for the queue.
+ * @notify_index:		Index the enclave writes to notify the device.
+ * @msix_entry:			Entry in the enclave's interrupt table holding
+ *				@msix_vector.
+ * @doorbell_offset:		Offset of the queue's doorbell in the device's
+ *				doorbell window.
+ */
+struct ne_vq_wiring {
+	u16	msix_vector;
+	u16	notify_index;
+	u16	msix_entry;
+	u16	doorbell_offset;
+};
+
+static_assert(sizeof(struct ne_vq_wiring) == 8);
+
+/**
+ * struct slot_add_device_req - SLOT_ADD_DEVICE request.
+ * @slot_uid:			Slot unique id mapped to the slot to give the
+ *				device to.
+ * @device_type:		Type of device to give the slot.
+ * @num_vqs:			Number of virtqueues the device has, at most
+ *				NE_MAX_VQS_PER_DEVICE.
+ * @device_features:		Feature bits the parent offers the enclave for
+ *				the device.
+ * @config_size:		Number of bytes of @device_config the device
+ *				reads.
+ * @num_backing_ranges:		Number of entries of @backing_ranges the
+ *				device reads, at most NE_MAX_BACKING_RANGES.
+ * @device_config:		Type-specific configuration of the device.
+ * @backing_ranges:		Runs of enclave memory the device works out of.
+ */
+struct slot_add_device_req {
+	u64	slot_uid;
+	u32	device_type;
+	u32	num_vqs;
+	u8	device_features[64];
+	u32	config_size;
+	u32	num_backing_ranges;
+	u8	device_config[64];
+	struct ne_backing_range backing_ranges[NE_MAX_BACKING_RANGES];
+} __packed;
+static_assert(sizeof(struct slot_add_device_req) <= NE_SEND_DATA_SIZE);
+
 /**
  * struct slot_pool_donate_req - SLOT_POOL_DONATE and SLOT_POOL_BASE_DONATE
  *				 request.
@@ -408,6 +477,15 @@ struct slot_pool_mem_donate_req {
  *				slot out of.
  * @limits.reserved14:		SLOT_POOL_GET_LIMITS. Bytes the device writes as
  *				zero.
+ * @add_device:			Fields SLOT_ADD_DEVICE fills.
+ * @add_device.device_uid:	SLOT_ADD_DEVICE. Unique id of the new device.
+ * @add_device.num_vqs:		SLOT_ADD_DEVICE. Number of entries of wiring
+ *				the device wrote to the info page.
+ * @add_device.reserved12:	SLOT_ADD_DEVICE. Bytes owned by other
+ *				commands.
+ * @add_device.vq_wiring_offset:	SLOT_ADD_DEVICE. Offset into the info
+ *				page at which @num_vqs entries of struct
+ *				ne_vq_wiring start.
  */
 struct ne_pci_dev_cmd_reply {
 	s32	rc;
@@ -443,6 +521,12 @@ struct ne_pci_dev_cmd_reply {
 			u16	slots_per_donation;
 			u16	reserved14;
 		} limits;
+		struct {
+			u64	device_uid;
+			u32	num_vqs;
+			u32	reserved12;
+			u64	vq_wiring_offset;
+		} add_device;
 	};
 };
 
@@ -452,6 +536,10 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply, start.enclave_cid) == 16);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, alloc.slot_uid) == 8);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, alloc.mem_regions) == 32);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.slot_uid) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, add_device.device_uid) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, add_device.num_vqs) == 16);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       add_device.vq_wiring_offset) == 24);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.enclave_cid) == 16);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.mem_regions) == 32);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.mem_size) == 40);
-- 
2.47.1


