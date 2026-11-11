Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989B3606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=DqyMEiaz
Received: by kanga.kvack.org (Postfix)
	id B393E6B05B2; Wed, 11 Nov 2026 18:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FBF6B05B3; Wed, 11 Nov 2026 18:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24CD6B05C4; Wed, 11 Nov 2026 18:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 805386B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:06:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 236E0140463
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:06:10 +0000 (UTC)
X-FDA: 85424373300.25.819D64F
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5A251C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:06:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DqyMEiaz;
	spf=pass (imf21.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCaLFa9CYkOFRFmXmg91FFIbm1J83UWVSYubqF58HyQ=;
	b=4ceDzBIfcOI7DOiQOZCGnFKAfbdXUrRl7ZBKdTkpDbBMHWzTO+c5DZExEYxz0+Ka2xwVP6
	ghwxsDPswG0BsJzsQFvwIV5WRuk29a6Ocr2lyCxDU44+jQwgbtwf3MZJufOoL49Jn2T/fe
	4b+4ecr79eG8ZqOYvjRzF6FdiiB+1kA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DqyMEiaz;
	spf=pass (imf21.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438368;
	b=Bod5LO4CChdqRErujhL1dlP7Qds2QrA9Jpha22NlQTE47Jj3qPid9OnAcSa6HQMBmZX7WR
	/vcINPmUrlyqz4/lY33Ti3qm6lZ+uUqdqShe1hG1ri/p9n0MSOtNE0/ijpwpgCwDx/T4j5
	WlRrAZLiCmoUi2OQhdgWJ0ORPG0hGAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438367; x=1825974367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCaLFa9CYkOFRFmXmg91FFIbm1J83UWVSYubqF58HyQ=;
  b=DqyMEiazETKoIwhmxRIlkKKudYdihQiEkvIh9mnT4wRfryBbvupC6lle
   C9L3DNZdEC0uipMgC/IW5x6drp0uigPO0eTSyS1otcZ2LSn6S4lSPMu0m
   RJvR6tdOoDBtwIJMZhu3MX/5xc4dHQ243hsV5a7Yzbh+BHUZiDkzZfuA2
   O4nnS2p9MM2dELDoekcd6OF1xlEcapMP8PstySekqD39lVNbwufpQvfpU
   wVo6w4nDaWi3INGcm8fXh2MUCTn2aw9zzBQYn18rtrLXhHUxcEMiwQI4g
   z6eRZg+2zyyw2h8rfNjupLVBFBWCJC/6sa7v015s36/DxJ8qGTHE6z/f3
   A==;
X-CSE-ConnectionGUID: 0TBGixifTAqA5XIk+1vZEA==
X-CSE-MsgGUID: b7/OhfvVRVuQVjUt6CjSDA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33739341"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:06:04 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:29252]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 6abf2343-3b58-41f0-98ab-3c293919f51b; Wed, 11 Nov 2026 23:06:04 +0000 (UTC)
X-Farcaster-Flow-ID: 6abf2343-3b58-41f0-98ab-3c293919f51b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:06:03 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:06:01 +0000
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
Subject: [PATCH 26/40] nitro_enclaves: Donate a bitmap page per multiplexed vector
Date: Wed, 11 Nov 2026 22:59:30 +0000
Message-ID: <7777b78690114ea0563ea42daaf930f15de8def8.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: hwyiy6zdphhw73yt3ad9q54ydb9h1b5x
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D5A251C0005
X-HE-Tag: 1794438367-755595
X-HE-Meta: U2FsdGVkX1+FCB65WuC/S0EmdQnqpveMwctonCac2946xG63cm1wcE5CbmEKLRGWbTqFfQhEmytwsurywqDhlLDopyy/MJnjlVsi0ggVwSosXF/EnC3zJmawmvCLeWc+nyRnp8ZYVPDkslPfQQBBbMiUdKm8crUJmZQe4+XP27Lj773DGLd0QIsuS1cQdjep6YOYYM7zFN6+gKyNNG44yM3I3gN/gVa/boN6DSxd2ZYACUjWH4iop11B4ZHyHgL59uP8PgJSU3hk/d3d5V9/J0uwvByFN7Be2fyTVXX6yjudXsQBYSjgqHEgXXOgD8liKPAONhHWGATbe9yNdAqPpzofIBnQOoGegDi0kb+hIBDY9xICvdTUxJfn4GhnBwPwLomEhYlg91S3csDqqYX1WtUnBqN2zymqKudGu178l3CYTH56gYDC+rOes/yh2/jrxJ3UK7+EbRQdE21DdferCYFAkvdz/fUaQmq6G9dFDk6Rv+UfTYb+RhdV+MEZnT/oJOtarZS7OiUxKrGySmvLEGyBPhSlZk/GLRD+OilvzMteh9qFjOi3mJa7FmF7ZfH8mZs6iYKRsRzhQQ4SzzTr2NlkIQx6CiZAqBxAhsKZFXbPZewOF8bDJ5zfJsiKCjDmKzpUr0Hcx+zUr4EZJ2ef/oTjRZY1G5bwln9G92SgOackErOsOACiD2FzkFr5GBFPx4eAGcFLMEBPuWmsB+epa5mdBToAVmprKLY+CSa14WPh4yJSG1uFGCV9Ql/n8Bv1xgWYzGO7qPZrVv0saus4w6oa9Z3XBB4GI5ots/vWRIkm8qq2UqwzwMhG1JpcwQHfJkeKlkc1ssBlvTuow4m7o/hx5wxIEum56a7BoVauggbWravt2kF77m77rvthftzf/22xTnzLGGTHc69jpov73gKQpXp+HU4KBrmjTbPagndn8lWP9YqQ6FQ/2G717lT0Mz7ND+EPWMCM38cmosI
 ldfh4GFS
 +wk6S6jR1O+/meWxoZNqs1gK5l6Q9O4U38pd/zlOtnU1IOoIjJWorxpfx7wfGS/LqYYasuCqkREYDddcOq0G0BR+/ZrtOt70iOc5lzGY+6XiLaeSXmHrRRN1uo92yWHbXacr3fidx6RoLg1bH7ZnJYOdvCkJxggMGNWLjSFCo04RFDFqXHmz2TpcHkkSnqHQDTJ3Vss2KSMDhCmDWJpa/0imob4JydYnjLPm83bSZXXsmCk0UFKTb5XJG2NgeeQVujGXYGy6088ZmSoP/ynAZ4gyMy/BtlyaoA4dosjV+9y8oecNGIVkFVqEzdrIwPrsZC1EOElnvTu70my7GGTc71ymLhCZPvyFenggSgD5aaibglo+uncWglbS9QiqvrOV8jSAqAGTi974MOo8/Jk2hCooV+NJ8LeRMAiSLK7B8BZ+dKMG4pQfXbl7vZe69aOj+kuAovdqTmgztqp9vFNYqyd7wOOsYZ4rtr2lOZB+Zdail8KrDvNWETvNWiAojdwqBU3GVpMsMf0qc4vDN5vXdedNi1KjUQKAkwRsYkBBATKBiB1fv7nLRS4TR5ZeC+5ocTEk/BJmIgYwNYuJ3SRQNJaHRParJVVEfCeEDCfq4z7ppcir9EoPi7Ye6Qh/6iEsKm/3RKArg5ed7/N1sjACpeQO3jcwZkKAzrKgJsb6UnmmnXHLL2Egh2tzZb4OS5H5Wea4+OGP1QaD214Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support the interrupt multiplexer, give the device the
bitmaps it records events in. At probe, donate one zeroed page per
pooled vector by writing its address to the matching NE_MUX_DONATE_BASE
slot, and read the outcome from NE_MUX_DONATE_ERR. A page holds
NE_MUX_MAX_BITS queue bits. The device sets the bit of a queue and then
raises the vector even when other bits are set already, which the
dispatch code relies on.

On teardown, write NE_MUX_SHUTDOWN before the pages go back to the
allocator.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 87 +++++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 50 ++++++++++++++
 2 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 05dd3040afbc3..0fafd42162f3a 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/iopoll.h>
 #include <linux/jiffies.h>
 #include <linux/kstrtox.h>
@@ -550,6 +551,32 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 }
 
+/**
+ * ne_mux_teardown() - Take the interrupt multiplexer bitmaps back from the
+ *		       device.
+ * @pdev:	PCI device to take the multiplexer bitmaps back from.
+ *
+ * Context: Process context.
+ */
+static void ne_mux_teardown(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	u32 i = 0;
+
+	if (!ne_pci_dev->mux)
+		return;
+
+	iowrite32(NE_MUX_SHUTDOWN_ON, ne_pci_dev->iomem_base + NE_MUX_SHUTDOWN);
+
+	for (i = 0; i < ne_pci_dev->mux_nr_vecs; i++)
+		free_page((unsigned long)ne_pci_dev->mux[i].bitmap);
+
+	kfree(ne_pci_dev->mux);
+
+	ne_pci_dev->mux = NULL;
+	ne_pci_dev->mux_nr_vecs = 0;
+}
+
 /**
  * ne_mux_setup() - Read the interrupt multiplexer geometry from the device.
  * @pdev:	PCI device to read the multiplexer geometry of.
@@ -561,6 +588,7 @@ static void ne_teardown_msix(struct pci_dev *pdev)
  * Context: Process context.
  * Return:
  * * 0 on success.
+ * * Negative return value on failure.
  */
 static int ne_mux_setup(struct pci_dev *pdev)
 {
@@ -568,6 +596,8 @@ static int ne_mux_setup(struct pci_dev *pdev)
 	int msix_nr_vecs = 0;
 	u32 nr_vecs = 0;
 	u32 vec_base = 0;
+	int rc = -EINVAL;
+	u32 i = 0;
 
 	if (!ne_pci_dev->has_vendor_cap)
 		return 0;
@@ -593,10 +623,54 @@ static int ne_mux_setup(struct pci_dev *pdev)
 		return 0;
 	}
 
+	ne_pci_dev->mux = kcalloc(nr_vecs, sizeof(*ne_pci_dev->mux),
+				  GFP_KERNEL);
+	if (!ne_pci_dev->mux)
+		return -ENOMEM;
+
 	ne_pci_dev->mux_nr_vecs = nr_vecs;
 	ne_pci_dev->mux_vec_base = vec_base;
 
+	for (i = 0; i < nr_vecs; i++) {
+		u16 donate_err = 0;
+
+		ne_pci_dev->mux[i].bitmap = (u64 *)get_zeroed_page(GFP_KERNEL);
+		if (!ne_pci_dev->mux[i].bitmap) {
+			rc = -ENOMEM;
+
+			goto teardown_mux;
+		}
+
+		/*
+		 * On a kernel without a 64-bit MMIO accessor this write is two
+		 * 32-bit writes, low half first, so the device sees a complete
+		 * address only once the high half has arrived. The device is
+		 * expected to take the donation from the high half and not from
+		 * the low one, which is also what lets the outcome be read back
+		 * right after.
+		 */
+		writeq(virt_to_phys(ne_pci_dev->mux[i].bitmap),
+		       ne_pci_dev->iomem_base + NE_MUX_DONATE_BASE +
+		       i * sizeof(u64));
+
+		donate_err = ioread16(ne_pci_dev->iomem_base +
+				      NE_MUX_DONATE_ERR);
+		if (donate_err) {
+			dev_err(&pdev->dev, "Error in bitmap donate for vector %u [err=%u]\n",
+				i, donate_err);
+
+			rc = -EIO;
+
+			goto teardown_mux;
+		}
+	}
+
 	return 0;
+
+teardown_mux:
+	ne_mux_teardown(pdev);
+
+	return rc;
 }
 
 /**
@@ -1648,7 +1722,12 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto teardown_msix;
 	}
 
-	ne_mux_setup(pdev);
+	rc = ne_mux_setup(pdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in mux setup [rc=%d]\n", rc);
+
+		goto pci_dev_disable;
+	}
 
 	down_write(&ne_devs.lock);
 
@@ -1717,6 +1796,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ne_devs.ne_pci_dev = NULL;
 unlock_ne_devs:
 	up_write(&ne_devs.lock);
+pci_dev_disable:
+	ne_mux_teardown(pdev);
 	ne_pci_dev_disable(pdev);
 teardown_msix:
 	ne_teardown_msix(pdev);
@@ -1755,6 +1836,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 
 	ne_devs.ne_pci_dev = NULL;
 
+	ne_mux_teardown(pdev);
+
 	ne_pci_dev_disable(pdev);
 
 	ne_teardown_msix(pdev);
@@ -1797,6 +1880,8 @@ static void ne_pci_shutdown(struct pci_dev *pdev)
 
 	ne_devs.ne_pci_dev = NULL;
 
+	ne_mux_teardown(pdev);
+
 	ne_pci_dev_disable(pdev);
 
 	ne_teardown_msix(pdev);
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index aee22b4ed8b6e..2cef40c627f9f 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -94,6 +94,30 @@
  */
 #define NE_MUX_NUM_VECTORS	(0x01f0)
 
+/**
+ * NE_MUX_DONATE_ERR - (2 bytes) Register holding the outcome of the last
+ *		       interrupt multiplexer bitmap donation (Read-Only).
+ */
+#define NE_MUX_DONATE_ERR	(0x01f4)
+
+/**
+ * NE_MUX_SHUTDOWN - (4 bytes) Register to tell the device to stop using every
+ *		     donated interrupt multiplexer bitmap (Write-Only).
+ */
+#define NE_MUX_SHUTDOWN		(0x01f8)
+#define NE_MUX_SHUTDOWN_ON	(0x01)
+
+/**
+ * NE_MUX_DONATE_BASE - (8 bytes per pooled vector) Array of registers to hand
+ *			the device the bitmap of one pooled vector (Read/Write).
+ *
+ * The device sets the bit of an enclave queue in the bitmap of the vector that
+ * queue shares, and then raises that vector's interrupt. It raises for every
+ * bit it sets, whatever the bitmap holds at the time, so bits a driver leaves
+ * in a bitmap never keep a later kick from arriving.
+ */
+#define NE_MUX_DONATE_BASE	(0x0800)
+
 /**
  * DOC: Device MMIO buffer sizes
  */
@@ -163,6 +187,20 @@
  */
 #define NE_MUX_MAX_VECTORS	(256)
 
+/**
+ * NE_MUX_MAX_BITS - Largest number of enclave queues one pooled vector
+ *		     multiplexes, which is how many bits the page donated as its
+ *		     bitmap holds.
+ */
+#define NE_MUX_MAX_BITS		(PAGE_SIZE * BITS_PER_BYTE)
+
+/*
+ * A bitmap is read in u64 words, so the words that span NE_MUX_MAX_BITS bits
+ * have to stay inside the one page donated for it.
+ */
+static_assert(NE_MUX_MAX_BITS / BITS_PER_TYPE(u64) * sizeof(u64) <= PAGE_SIZE,
+	      "the bitmap of a pooled vector has to fit its donated page");
+
 /**
  * enum ne_pci_dev_cmd_type - Device command types.
  * @INVALID_CMD:		Invalid command.
@@ -605,6 +643,16 @@ struct ne_slot_pool_run {
 	unsigned long		nr_pages;
 };
 
+/**
+ * struct ne_mux_vec - Interrupt multiplexer state of one pooled MSI-X vector.
+ * @bitmap:			Page-sized bitmap in which the device sets a bit
+ *				for every enclave queue that signalled through
+ *				this vector.
+ */
+struct ne_mux_vec {
+	u64			*bitmap;
+};
+
 /**
  * struct ne_pci_dev - Nitro Enclaves (NE) PCI device.
  * @cmd_reply_avail:		Variable set if a reply has been sent by the
@@ -624,6 +672,7 @@ struct ne_slot_pool_run {
  *				capability, and with it the multiplexer and slot
  *				pool registers.
  * @iomem_base :		MMIO region of the PCI device.
+ * @mux:			Per-pooled-vector interrupt multiplexer state.
  * @mux_nr_vecs:		Number of MSI-X vectors in the interrupt
  *				multiplexer pool.
  * @mux_vec_base:		First MSI-X vector of the interrupt multiplexer
@@ -657,6 +706,7 @@ struct ne_pci_dev {
 	struct workqueue_struct	*event_wq;
 	bool			has_vendor_cap;
 	void __iomem		*iomem_base;
+	struct ne_mux_vec	*mux;
 	u32			mux_nr_vecs;
 	u32			mux_vec_base;
 	struct work_struct	notify_work;
-- 
2.47.1


