Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621CE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=lNaf6SLZ
Received: by kanga.kvack.org (Postfix)
	id 71DEC6B05BA; Wed, 11 Nov 2026 18:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F54C6B05BB; Wed, 11 Nov 2026 18:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632BA6B05C0; Wed, 11 Nov 2026 18:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 416166B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:08:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF8B61603CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:08:58 +0000 (UTC)
X-FDA: 85424380356.22.F7FC548
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf08.hostedemail.com (Postfix) with ESMTP id 985CF16000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:08:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lNaf6SLZ;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUp4hSPJVd2nb6nX2jrCTXpj2VQXaacU9dBBzQGocbM=;
	b=kcQ1DSrNYYHfjcdDA4KJXwi6DzsGb3eX7nvjghW9Mu2JYzpsUQY2e/u+c4Tpxg11qimYRU
	/vmlrgK3GRg/TWsdE5LdAdZQmp9oani4YlOVMikpGgjEz5GM6xGMN7prXYm7r67fr9+qPt
	haaM57HSYbFk8qd3lElgwct8trlYt2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438536;
	b=SErvIWzHGUMfXKk3vkUyQSRw/rcMWsts3+8EdE+4f7OpN6JSFXfBbDrbTFFqwCosT4eIhz
	op4BP9MmUwsQnuw/8+iwwnLeY2AEsxEWzVS/2gJ5H5nn8EHTUAVxy61ILZf8aI458yUKLI
	n9B63WG9q73fIKTI+zGz7erDPkCMvQ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lNaf6SLZ;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438536; x=1825974536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VUp4hSPJVd2nb6nX2jrCTXpj2VQXaacU9dBBzQGocbM=;
  b=lNaf6SLZnmDvWOK+XdUPLc7Fz6Cr/70pRllbS1FEn+2BOGoqi9s2yghB
   o96PXG/heugmPc3ZuFoIphoPZm8R7UVOEGf04uqJRvWlpMGrXskgwcYIq
   R4oPB/9UdnDdQT43Y7ooR8q0dMg6n/XrAHlfeZM5W7fNRQ4lY7jx3Kiml
   xmqRxbLqETYOn9n1Vdx+4iedHNuSlvE/MtNh6efa8wMMEjbOct6JutmDp
   PuqzYuJEcaNPhBVHvucXCMFfX0UUbZQu05syU5oRlRRq/RYTamUt9+Cii
   M33/8QqnkYhlz99KL9A8OziNz8PgNK0TpprEsjHPIn5ohUDSkjmVY8XPg
   g==;
X-CSE-ConnectionGUID: GmQR3KdLSIK2VGL9i1Vgww==
X-CSE-MsgGUID: Lv8CQC79SS26CvRd2fhFtw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33789838"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:08:55 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:12889]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 03263252-400d-47dd-9ab4-f24010c32c62; Wed, 11 Nov 2026 23:08:55 +0000 (UTC)
X-Farcaster-Flow-ID: 03263252-400d-47dd-9ab4-f24010c32c62
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:08:54 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:08:52 +0000
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
Subject: [PATCH 31/40] nitro_enclaves: Map the doorbell window at probe
Date: Wed, 11 Nov 2026 22:59:35 +0000
Message-ID: <8a8052b1943deb9139d1244e43d519fec83acf5f.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: xezmeztehhi8xt9efgcw9r4su3i9gjek
X-Rspamd-Queue-Id: 985CF16000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438536-349106
X-HE-Meta: U2FsdGVkX1/SwwjqthHrKvVutObCNPSJqPoBnKh8y1aenBWvMykkepaNsiJts7jrZBdRtGkemXtn1a0OCZD79g7I2iXwjzMDyel8TyQNjz5+PHTrGJ44qk6PYIPBfAGdGEea3GBgMdKu5DXIpfSgRMQxHZlBEhAXesJEFEybLTS4ElofrMfzgAOIiUeIuqifM1q2dyQ3HInxEF4k/1QNjBSj+YgNjWLLnp86ZO0vxJqogVBtCqg53ARluP3hJIlZUXz0MmIkqQaBCUOYTWIAELlZFlfsOV79LrttXgs4Hm8qSZaQ2g0+6Vxh9/pppUcwrLejcrt+rDCDSDWTdxL1IKRtsWiOMzVcuQ2N5D5YsDzNKrj2yI4NW7WJ1vk6dzcvA4znlZrO1rnqVIlLHBBfsI5WA9mqdsf69AHg8fK7ScQVzazzzsXX31bCDOLJg5JaSbCPNzmxUvA0nFD5Fs0oa50b1c31XnINb8TK0WJLw/t03uN8qmjUNeVNts8Pna2PynPr9ZzpMO2xS0Y7yuDzQP4mG9bAiznBEqINBJTorDcwWiB+eDkyzKTxcytvUvjewuMzQ+M8k4C5J9b9xUoSXZ7vgE00rq1J90Qt7iSrTXYHxK5nfmj3wUHmdgAYVhqtvn+5gvr9rCoMwKaDlg364d7ceDaBD94B7PK1iGtFI+BzPwW8Yxh8mVpMPZcmemC26Oowr8hEmzlvY5Yx9zKoQkrNCVjDGEh1uTlZ6Tb7qAKCatsE8EW00KCusR1qRb3HRV3xKShp3UTw/9EPz+awHy9wJy9JgLYwVZsSoExeudU2NIMJ/qMnLiB23rhCbca/DaaQUc4ZiJKOX7SRyD1Nz0XvliJDTR3LU5oP1UnvJL9HAviplFcW4hIn/mCfpkQcSysXTriLlZ0DuQNQYQAIlHVo1W+Psw00nMM7asIg+vi/Mg57h2Bre8v6zX6lihdxIUrXOlTBaOu4K7tOsH+
 2fBnFB7u
 5Ac5FjnIVClR0QUK2pph9jgRmoOod7naPTcQrkflX8CHADnmSPRQxzC7kq9KSHeJizh/cVt8flmo0VdnWn4WNKp3rv7mDsbbIAUyZsPSzvqgLuVgGySIbuTe0pfn4EYtdmMCUFF4WYwIq40/jRmEHYSl2mXqsGbPuK6w0XSdpL2qBC6oBOD282YopzPpy6T2AMOrerYwTUl+4Ck53ICrLtZTV9ImsXultG2T4gTqAD/LOvroKCnW7l3sRJbiwUB51+vzA9tHhpQouZ17vpDMJa5i+rPsAZVaP13zoUCHgBaHz3j43HGDHB1BnlhAdVkmXkc+azZBWWH+a/9fCmxq2F/0gxobUGUPUNnuUaRvwdkbQCtWfflmM71SOS2I6wdxhuluJa5qIUxhccZoN7+MMUEa8DHPCMG8afVIyqqiBOTcU2gvXZQXm7r1wUGpnQtAWjSaWDv7yRE8455pJwXyi/D/BDxgRC9qKhnk/RwXZch9aQKDgFDrwuAmI4y1wD/Bafrb4N4/zyW97Bb/cVNa2pQCdmkQxihjsQ0Q3TR3gVTbplRFEO6N2snG1oMfM0osoCB5fvh4x6ajD4wMz9liy4LYwV2HVPBw1Dc7coDQyx7wyg755H0Zlnc3xW4MnLdvGVp1Qh8tj/lik/lZDMCjypF18BjBZi2pVFdgFjXNSrthOBsLxfAWjlB4UrsexgWDUb4Dw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support notifying a sandbox virtqueue from the parent,
map the doorbell window of the NE PCI device. The doorbell window is a
second MMIO BAR of the device holding an array of two-byte doorbells; a
write to the doorbell of a virtqueue tells the device that the queue has
data waiting for the sandbox.

A device that does not offer the window serves every enclave operation
that does not involve a virtqueue, so keep the mapping optional and let
probe carry on without it. Record the length of the window so that a
doorbell offset can be bounded against it.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 17 +++++++++++++++++
 drivers/virt/nitro_enclaves/ne_pci_dev.h |  9 +++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 4678799998f4a..b5a7ecfffb4b6 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -1968,6 +1968,15 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto release_pci_regions;
 	}
 
+	/*
+	 * A device without a doorbell window serves every enclave operation
+	 * that does not involve a virtqueue, so carry on without one.
+	 */
+	ne_pci_dev->doorbell_base = pci_iomap(pdev, PCI_BAR_NE_DOORBELL, 0);
+	if (ne_pci_dev->doorbell_base)
+		ne_pci_dev->doorbell_len =
+			pci_resource_len(pdev, PCI_BAR_NE_DOORBELL);
+
 	pci_set_drvdata(pdev, ne_pci_dev);
 
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
@@ -2086,6 +2095,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ne_teardown_msix(pdev);
 iounmap_pci_bar:
 	pci_set_drvdata(pdev, NULL);
+	if (ne_pci_dev->doorbell_base)
+		pci_iounmap(pdev, ne_pci_dev->doorbell_base);
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
 release_pci_regions:
 	pci_release_regions(pdev);
@@ -2127,6 +2138,9 @@ static void ne_pci_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	if (ne_pci_dev->doorbell_base)
+		pci_iounmap(pdev, ne_pci_dev->doorbell_base);
+
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
 
 	pci_release_regions(pdev);
@@ -2171,6 +2185,9 @@ static void ne_pci_shutdown(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	if (ne_pci_dev->doorbell_base)
+		pci_iounmap(pdev, ne_pci_dev->doorbell_base);
+
 	pci_iounmap(pdev, ne_pci_dev->iomem_base);
 
 	pci_release_regions(pdev);
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 71aaa8f557679..5a92e0c565ba0 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -31,6 +31,10 @@
  * PCI_BAR_NE - Nitro Enclaves PCI device MMIO BAR.
  */
 #define PCI_BAR_NE		(0x03)
+/**
+ * PCI_BAR_NE_DOORBELL - Nitro Enclaves PCI device virtqueue doorbell BAR.
+ */
+#define PCI_BAR_NE_DOORBELL	(0x04)
 
 /**
  * DOC: Device registers in the NE PCI device MMIO BAR
@@ -724,6 +728,9 @@ struct ne_mux_binding {
  *				could not be made, and the calls that take it
  *				turn such a pointer down themselves, so it is
  *				kept as it came.
+ * @doorbell_base:		Virtqueue doorbell window of the PCI device, NULL
+ *				on a device that does not offer one.
+ * @doorbell_len:		Length of the virtqueue doorbell window.
  * @enclaves_list:		List of the enclaves managed by the PCI device.
  * @enclaves_list_mutex:	Mutex for accessing the list of enclaves.
  * @event_wq:			Work queue for handling out-of-band events
@@ -766,6 +773,8 @@ struct ne_pci_dev {
 	bool			failed;
 	wait_queue_head_t	cmd_reply_wait_q;
 	struct dentry		*debugfs_dir;
+	void __iomem		*doorbell_base;
+	resource_size_t		doorbell_len;
 	struct list_head	enclaves_list;
 	struct mutex		enclaves_list_mutex;
 	struct workqueue_struct	*event_wq;
-- 
2.47.1


