Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4419606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DlSsuidV
Received: by kanga.kvack.org (Postfix)
	id 8294F6B05C3; Wed, 11 Nov 2026 18:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801D66B05C4; Wed, 11 Nov 2026 18:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E276B05C5; Wed, 11 Nov 2026 18:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4A36B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:05:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C80F11C3C2F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:05:33 +0000 (UTC)
X-FDA: 85424371746.21.4260DB9
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf31.hostedemail.com (Postfix) with ESMTP id 965A720002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:05:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DlSsuidV;
	spf=pass (imf31.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438331;
	b=YG+neafDy4AwKTwin4d+7qYjL6SHkO1lmQXoljvVy6wWXG9YY45gv2Vdq1pdzFRisCreR6
	RSnGj6ZM0ZK+QMRtaJKY7ueYX7YVMuPAT+MWTMrV3Pr3zGllZyL8siOYPnCEnAzY09lNCm
	BV4eiSNvHzmDXJCtHP9CAv6FtEXWgUg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DlSsuidV;
	spf=pass (imf31.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVsRJFejlalfnGx+DVuzjX9D+Tuo+9KGp3cwLygC1Hc=;
	b=GWyl/ojVVwJPtkJJrDvCNq6UkzkcfJmpK7yjJiXWThZ92F9vM1+iy6cnNMUpfLWvdxT2Uh
	a58w2YnFq2T/pWeq523fKas+WEXwQpR9xMfHPo2/hPJyfLuBalQStxmoO99EugOHtBZweK
	A4RD89h3Y+3uTUTJbMOrx+yf2cgrG9A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438331; x=1825974331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WVsRJFejlalfnGx+DVuzjX9D+Tuo+9KGp3cwLygC1Hc=;
  b=DlSsuidVI4L7B/k+Cmk87/ABtXhXl+vhMYMSs1ukP6yKsNeMbbFofFWU
   gggVU0HOtXoS3KLy6nCuIAzwLDUTfhK1JddpkEbDoDXscAjH9nCATaYHw
   5DWU8g7+jvIHWqcWS0I6GdNwcUwn67c7qHBTvhBMHxlUnE/WKf2+TocJs
   Rz867wgE7w2jqVtmqtyt0C2vLnzMR6ZGATkGvcef9xiVg8FfPDYiob8oB
   9waamEijKyelmfNkKJG1oINrAB/aFavyky9/0jdHrjrSpRIasbC5Pq4nv
   60adDJCig39cn9vcjzFn6yWZgMkOkVU79hZ5TYCVWnvUX6LQETjw24sO+
   w==;
X-CSE-ConnectionGUID: RSrBKcr1SjCY4ASv0S8OpA==
X-CSE-MsgGUID: PmJMOBprTRy6hyVlxLuJDg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33573525"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:05:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:25542]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 829b92ef-b808-42f4-90f9-68ea19d9a49d; Wed, 11 Nov 2026 23:05:30 +0000 (UTC)
X-Farcaster-Flow-ID: 829b92ef-b808-42f4-90f9-68ea19d9a49d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:05:29 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:05:27 +0000
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
Subject: [PATCH 25/40] nitro_enclaves: Read the interrupt multiplexer geometry at probe
Date: Wed, 11 Nov 2026 22:59:29 +0000
Message-ID: <8937871aae7d02a883af18bd9a8b0f5f3c8d39c6.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: xr6nsrn6zr5ttwmktdabto58wpafu6xi
X-Rspamd-Queue-Id: 965A720002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438331-257557
X-HE-Meta: U2FsdGVkX18TE50j9Gcv5puEHxnKWPJElAMizOJymLnrA/vV47BkbqE19OIESI0iNTU9b/tuowjYnAwk9XVaC1DOdyjTCs5b4VNQS0kfhm2xZVZegJl5bpo0an9yZM4Bm3O+INKq1q8MOsYJujMGNKBTyd0eN3vU5+WCDGiLIQXN4PHgqU3yzy+yVTWFkE91UOgPdXlgTYvxJ9cuEEg2dLUnq+OEUIa8PRdokQTr7HA3T/DLH8+WCWnO0Hg3nl9Mv8RpHohhmS0tZAE40Gc32982o9eu+TMuFU5oIkgu/71bhSHQOz1U/2cBE99x1iQUEQWdvpKcdlLAE0NE4AaVH9tHvJjx5/6XYPANU0sjbLimFagvO7nQ15Gp9lV1ecqzsxUQEifqZFaXo/u6DMOI5+TshRL+yjEkyPas8eJX/i4p2JdzfYz55sfGem0Ftsw4Cqw4jM4FzFY3TfKzilGxS2RrL8H1yDPmf543gQCvBhCjkaLYqBAIbNP3H8erWj5Q9+4tRC+l8c+S4jkFQPSIMIg1b65bOho+3gu2s/mbm5sPPyh9y+5G2f27f/tN7fZi8TEjHpcGhWX31dm9VI4zcBruB3iyEAAjetb4rS0d3gwEHA/TK+tgD9OGi5wW+WQpNfD08yRTj4pZcjnA/LmOP19Y6SJ45VoSastJpLaIvLJwuJTOxTXj/4AhRxSoPV7KJ6/aeDefUCO2XNfQomZV4IMuF2pPgiCQQcefkCSMFHVR7fXfNLtFzAFyfZ5rra8iMF9ph5aJHaArxcHOsc0CdJfcoSoBRFMzS7s1KhlHEJbwkc1G+b6KWsLXoDvpEWUm/T+tys5XZ10/xl7nBihPrI6XffoanSLq/ROqge/dBY2+zADozLGmU5+DUNlcLJwf5tufXyP8h43gASVUfNmOR/f1mGfIkbnlJWD5yGhXhd7cG4N1FwVrlqufBShvZeGKJCtHZ+2w3D2s8T+znYB
 cNMFXtam
 RsW74XuTRutr0HI7OhI4NwQFkZsUaD/APdN0KDFb4d4fAWirXlUfNx7AJcReWaPfcniv0zTuqXVvlmAqRbGFShiRJWO0p9EqmJSCO1Q+zwHOSKvf1BsGs+6xHxPirWpupOsZ/LqQR/14MyBs8XWXFwGg8S5BjeWPqfnxwMoGfqq8Pvruh1juB0IhWgRQvhcPQB28L75ubcIwSgSrsLCSbAnaTGA/Q70v4iARW2YtMVag+Kb7EWl8vcYZ/ZSOtSXUBYR+p2iOAkeO212rNUSv460BX541PE6bdtSyahsqBhBZJvqEensaoj3fKvsRoAHGKawhH2eAS5aBOXKYChGrAl+8t3FPz1MaaCAfzsNYPjcbG0buAhSXYxnDSbD4Ujr1q0y8e3nq90E77norNsUkRiNN2Rdnb5s0NQ1RVNkT6xA5ByRbAmIxdNDFIs7WNf/rBG0U3Wp7fuHHkIXKb5C/WnKMyJMxrOEoTMqvxuAgY509y+BM8ZWVoLnzeEc3xGWZP8sybsh2t0/i2dSZUA4m5qq8ShxswNM/126y6yy2dyVHVr2FCNYdgjKDbToci2j3PPTQWHCwmF4cQQEMRYIOwel6ZOsc2Ps3f5ZAGnalPN4CoSxGJ9QsIhguVtWKSYHI/ZhXdjw/JM8+I8Yqi/yUXrRQTAoHaMBTQ3wB3A1F7lhuZt6QQZDCBMsr6z0qpjJEG07vn2hkvoOpGRJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support per-virtqueue events for Nitro Sandboxes, read
the geometry of the interrupt multiplexer at probe. The interrupt
multiplexer is built into the nitro_enclaves device. It is a pool of
MSI-X vectors that the device shares between the virtqueues of every
sandbox: it raises a pooled vector and records in a bitmap which queues
signalled. NE_MUX_NUM_VECTORS holds the size of the pool and
NE_MUX_VECTOR_BASE its first vector.

Read them only on a device with the PCI vendor-specific capability that
defines them. Leave the pool unused when it is larger than
NE_MUX_MAX_VECTORS or than the vectors of the device, or when it
overlaps the reply and event vectors.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 60 ++++++++++++++++++++++--
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 27 ++++++++++-
 2 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 1aa4d5508dabf..05dd3040afbc3 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -550,6 +550,55 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 }
 
+/**
+ * ne_mux_setup() - Read the interrupt multiplexer geometry from the device.
+ * @pdev:	PCI device to read the multiplexer geometry of.
+ *
+ * The multiplexer registers only exist on a device that publishes a
+ * vendor-specific capability, so a device without one leaves the pool unused
+ * and reads no multiplexer register at all.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ */
+static int ne_mux_setup(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	int msix_nr_vecs = 0;
+	u32 nr_vecs = 0;
+	u32 vec_base = 0;
+
+	if (!ne_pci_dev->has_vendor_cap)
+		return 0;
+
+	nr_vecs = ioread16(ne_pci_dev->iomem_base + NE_MUX_NUM_VECTORS);
+	if (!nr_vecs)
+		return 0;
+
+	vec_base = ioread16(ne_pci_dev->iomem_base + NE_MUX_VECTOR_BASE);
+	msix_nr_vecs = pci_msix_vec_count(pdev);
+
+	/*
+	 * An enclave whose queues cannot reach the pool binds them to the
+	 * reply and event vectors instead, which costs interrupt throughput
+	 * and no functionality. Refusing to probe would take Nitro Enclaves
+	 * away from the parent altogether.
+	 */
+	if (nr_vecs > NE_MUX_MAX_VECTORS || vec_base <= NE_VEC_EVENT ||
+	    msix_nr_vecs < 0 || vec_base + nr_vecs > (u32)msix_nr_vecs) {
+		dev_dbg(&pdev->dev, "Unusable multiplexer pool of %u vectors at vector %u\n",
+			nr_vecs, vec_base);
+
+		return 0;
+	}
+
+	ne_pci_dev->mux_nr_vecs = nr_vecs;
+	ne_pci_dev->mux_vec_base = vec_base;
+
+	return 0;
+}
+
 /**
  * ne_pci_dev_enable() - Select the PCI device version and enable it.
  * @pdev:	PCI device to select version for and then enable.
@@ -1574,10 +1623,11 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ne_pci_dev->pdev = pdev;
 
 	/*
-	 * The registers past the command interface only exist on a device that
-	 * publishes a vendor-specific capability, and a read of a register the
-	 * device does not implement has no defined value. The answer holds for
-	 * the life of the device, so look it up once here.
+	 * Launch flags, the multiplexer and the slot pool registers are
+	 * implemented by a device that publishes a vendor-specific capability,
+	 * and a read of a register the device does not implement has no defined
+	 * value. The answer holds
+	 * for the life of the device, so look it up once here.
 	 */
 	ne_pci_dev->has_vendor_cap =
 		pci_find_capability(pdev, PCI_CAP_ID_VNDR) != 0;
@@ -1598,6 +1648,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto teardown_msix;
 	}
 
+	ne_mux_setup(pdev);
+
 	down_write(&ne_devs.lock);
 
 	/*
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index a0bca5863e2a1..aee22b4ed8b6e 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -54,6 +54,12 @@
  */
 #define NE_COMMAND		(0x0004)
 
+/**
+ * NE_MUX_VECTOR_BASE - (2 bytes) Register holding the first MSI-X vector of
+ *			the interrupt multiplexer pool (Read-Only).
+ */
+#define NE_MUX_VECTOR_BASE	(0x0008)
+
 /**
  * NE_EVTCNT - (4 bytes) Register to notify the driver that a reply or a device
  *	       event is available (Read-Only):
@@ -82,6 +88,12 @@
  */
 #define NE_RECV_DATA		(0x0100)
 
+/**
+ * NE_MUX_NUM_VECTORS - (2 bytes) Register holding the number of MSI-X vectors
+ *			in the interrupt multiplexer pool (Read-Only).
+ */
+#define NE_MUX_NUM_VECTORS	(0x01f0)
+
 /**
  * DOC: Device MMIO buffer sizes
  */
@@ -146,6 +158,11 @@
  */
 #define NE_VEC_EVENT		(1)
 
+/**
+ * NE_MUX_MAX_VECTORS - Largest interrupt multiplexer pool the driver accepts.
+ */
+#define NE_MUX_MAX_VECTORS	(256)
+
 /**
  * enum ne_pci_dev_cmd_type - Device command types.
  * @INVALID_CMD:		Invalid command.
@@ -604,9 +621,13 @@ struct ne_slot_pool_run {
  *				enclave state scanning and propagation to the
  *				enclave process.
  * @has_vendor_cap:		Whether the PCI device publishes a vendor-specific
- *				capability, and with it the registers past the
- *				command interface.
+ *				capability, and with it the multiplexer and slot
+ *				pool registers.
  * @iomem_base :		MMIO region of the PCI device.
+ * @mux_nr_vecs:		Number of MSI-X vectors in the interrupt
+ *				multiplexer pool.
+ * @mux_vec_base:		First MSI-X vector of the interrupt multiplexer
+ *				pool.
  * @notify_work:		Work item for every received out-of-band event.
  * @pci_dev_mutex:		Mutex for accessing the PCI device MMIO space.
  * @pdev:			PCI device data structure.
@@ -636,6 +657,8 @@ struct ne_pci_dev {
 	struct workqueue_struct	*event_wq;
 	bool			has_vendor_cap;
 	void __iomem		*iomem_base;
+	u32			mux_nr_vecs;
+	u32			mux_vec_base;
 	struct work_struct	notify_work;
 	struct mutex		pci_dev_mutex;
 	struct pci_dev		*pdev;
-- 
2.47.1


