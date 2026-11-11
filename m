Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD523606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=G52BS6fr
Received: by kanga.kvack.org (Postfix)
	id CC0C16B05B3; Wed, 11 Nov 2026 18:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C972F6B05C4; Wed, 11 Nov 2026 18:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD416B05C5; Wed, 11 Nov 2026 18:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 936C16B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:06:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 318F612047C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:06:42 +0000 (UTC)
X-FDA: 85424374644.01.68935A0
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id E085E100003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:06:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=G52BS6fr;
	spf=pass (imf14.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438400;
	b=M/Zf7YBjBuOLXTzfaVCtszApPEJRRS9tGnm9enlbGmEqs8KTm8YlA1eCv+RRFPSpOW+lae
	k9tmmIvPHhSCox1eKJwTcp6OwDBKxFvAqrg/N0MqdLr/xNIv2zIhG6/6NFtcBc2kG/C5Yv
	ARsjUig8IV8xI2XUMjT4XM+sVMDRVbY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=G52BS6fr;
	spf=pass (imf14.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMLQtoMK+FF9PMlISJsUmmPmSZAB3/0ZdR3/LW/bJ9I=;
	b=X8SnPrBBE/aDn/RuTSykyBMSZLR4HZ2aAekk7l8aPlTt8ddVPnt+KFNdLURjkdH1ZRPvdy
	8XwT7+hLNKj/gU/47djg/FZkn4t2Gsszwk8OvhXOGW8n+QtQxp5xa/FWb0mQ0izV0BJgbU
	Mw8C8coze5az15iHFQc2Uz6XAYbY2Xc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438400; x=1825974400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lMLQtoMK+FF9PMlISJsUmmPmSZAB3/0ZdR3/LW/bJ9I=;
  b=G52BS6frD7mS02tdjaUZNpOWkobolRbiielSd2uutH43p/QmYeLVrdWB
   aFZK5V10dVDCKkblkJhrP0728vTXpTIDjLy1UGxdNy/hyX9tYzCPq+tvv
   UcM2WCcOMJRYHKVq+5ZbLnMtq/LMI9tPj0jsr9X1QrUWJ7QvIo/jwVuzz
   f6fzqzTHMlkFnbSpAIkZYa10BnOa4wNfMXfYASryxfG3ynxaEloekrKwg
   cxq4dk7EhqW/YFMCbKxLK/x6FC8tMrC/38zB1BF8xSXFEe2K+YE492Ipc
   y76J08DhHtI1pv5FOgwXH9wbVmEmJhsYyiDR/seMFXRroihzVZQ7G6bLT
   g==;
X-CSE-ConnectionGUID: a0qphS5PSkW3vKQQb7o4Tw==
X-CSE-MsgGUID: puhEAopkQb68Udz8yNQ+5w==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33551130"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:06:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:16609]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 11ec9860-3c62-40c8-a31e-cc39e6372e83; Wed, 11 Nov 2026 23:06:38 +0000 (UTC)
X-Farcaster-Flow-ID: 11ec9860-3c62-40c8-a31e-cc39e6372e83
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:06:38 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:06:35 +0000
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
Subject: [PATCH 27/40] nitro_enclaves: Dispatch multiplexed interrupts to per-queue bindings
Date: Wed, 11 Nov 2026 22:59:31 +0000
Message-ID: <7cb23d5eb46abf8a1caa61b8887132837fe256c4.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E085E100003
X-Stat-Signature: peebtbm7dr87oy7yst3r71maebsjjj17
X-Rspam-User: 
X-HE-Tag: 1794438399-250702
X-HE-Meta: U2FsdGVkX18WC7UEmnfh1SKJMV1jFRtAsmx7xZ+OGDTVAtwUvuc19M9NTsqc4IiGvi4LL3beBIDMSzh1Fh6DowsnEcM3BnCjuadMIwj2M0huI3dmIefkxCyja2thUmr29q/Hz4Uy5rJaJcvtFFiAg+RIMJMEbQxWbMrbLdeNE/KZjpFQwI9tAaAFtVD9tjEWfLkFdWCCBK1J5rMZs+7/h07NJXi3LSy30tIVFlqlRBs4Met0N5e9uYIMu0cub+MvomNM+zVPjjytWKxztrlgGdPj1GqQ4e5DZsTWSXW7H4TYPrDw8BeUowCjflWrb6kg5OLnZnoHKx/l89mAqwjP/myfIIvGfPunGMHGdqAjNz+OpUWuEKrUSTVL27P9ndItWIIJ9DzEBYAzC0yieOq4m6arAstrHkTrnxM0qei7TOWUwaivLj5A/GDR7cJSwmQS/4/jkWrfcuKwDGpcVhnnW3dWC9n82zj4ybz/5uuIHnOHMAgWAAHWRSiSBhChYXHOTfylYKt+nQG3abQ8K5j+AxIOfVwqUiLfv18ugaLmMCzyMvdr6XwBOHPU1qRLp1d/K6tlWJvy+XMr+I69XJIYlHWr6PB9Ut/Z5ATWksufc0IxkunMqU6iv+f9g5H8CNQTjkxMz/uHiPDFXikxVq5GbYpGnZn9MGEtFtjikTUpwJXz0aA0+N2YCRflJfybcSeVunF4KbCYNesP2KYRjN8wSiQUX99mebPvLoUcc5FnhjXCk6Qid3povwQwJEl2jzDPIWAIviASDEHtd11IP9YioUTZln+XIlnDHTN4WgksqnRzwBPTjUpCvYXbPXJPadIzEfb+Akv8a0RWBw4nRanrV5DzQVqjhR9JONZ8FrQ8sg4qr34u5wubF2WmH33+yVdKMgwwn4ehZozPxVq2CjREgi3g9rAOXV89qnsbKySH6BhjHCWLfjmIdpjQmU1zrrgSH8sjT+V/G8WnfGMZ+FA
 dp/PZor/
 GPupMbXwxYwsU5ASU1sDjsuhHcrWhJ2hTwWujJ6Osc8rGTZMep5y0H/IVYp/a4QEYs8YLAVXrdlCuRz6VB0FtXpgkEb+A567VxgizT3GoVdqPeblmnj6kRPKieAuLIyZ0jehP61HE/IjmQjIZIdx/elWVE+wCZbcNFX+D5J+hbsiZsHSuFHcDt/3pyBW3tryytJFUP1jjV2NZbdhOHqwdrChjN8/l9k84FmoSefsbiXMVRFBbPAwNKtEPZyn3bm51Si0Na29iZU3rmQZpSBAzi18vW+4jTbgLJXo1FTcCA+bxJ+O5+npyb0ld4sX64OGPnbkhC5e3+NUBLxL6QmI7OutunbN0Kbi+dJwTfRSLZOqwGnZJ/mtHyLXEa+r9jeAhr0cCjd2fMsncn8eCucGVIEC0Gi4sNfYtfpn1ZYfdu9thsFuPn9P6KES1Hu2jJCKsYv2+jnr5uviJnSut11RPYikOF46UWmN9Cor5RLNg8/ksf/CpkYb4Hsg/4wDO3WT8ENRN2oRP5QaQoI5T7YtHdGLaZAAs8tP5zlfH4puxLGFPh3jaQHA2ADNfdI8Wj+jjuGb9cMNKtELf+1RDXgS15kMAc3PL6tq1As9WsLcbDzRPgQGrQQFbXXZIoDw65KotepKu/4TGAl2V9vevtmYbzOSoBXFfGrv5768ohrCzSbb2vjusiCfK6GG9XZ5XyD9nWaSW9ikUVr3zXvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes provide a way for user space to receive
per-device-virtqueue events. These are multiplexed through a
nitro_enclaves device built-in interrupt multiplexer. Implement logic to
support this multiplexer and distribute the respective interrupt events.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 179 ++++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h |  47 ++++++
 2 files changed, 225 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 0fafd42162f3a..de96d68906bbf 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -7,6 +7,7 @@
  * DOC: Nitro Enclaves (NE) PCI device driver.
  */
 
+#include <linux/bitops.h>
 #include <linux/cma.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -27,6 +28,7 @@
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/xarray.h>
 
 #include "ne_misc_dev.h"
 #include "ne_pci_dev.h"
@@ -551,6 +553,129 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 }
 
+/**
+ * ne_mux_binding_rcu_free() - RCU callback freeing one enclave queue binding.
+ * @head:	RCU head of the binding to free.
+ *
+ * Context: Softirq or process context.
+ */
+static void ne_mux_binding_rcu_free(struct rcu_head *head)
+{
+	struct ne_mux_binding *binding = container_of(head,
+						      struct ne_mux_binding,
+						      rcu);
+
+	eventfd_ctx_put(binding->ctx);
+
+	kfree(binding);
+}
+
+void ne_mux_binding_free_rcu(struct ne_mux_binding *binding)
+{
+	call_rcu(&binding->rcu, ne_mux_binding_rcu_free);
+}
+
+/**
+ * ne_mux_scan() - Deliver the bits set in the bitmap of a pooled vector that it
+ *		   has a binding for.
+ * @mux_vec:	Multiplexer state of the pooled vector.
+ *
+ * A bit leaves the bitmap by the same atomic read-modify-write that decides to
+ * deliver it, so a bit this vector has no binding for stays set. It is left set
+ * on purpose: a queue can be kicked before user space has bound an eventfd to
+ * it, and a bit taken out of the bitmap on the strength of a binding that is not
+ * there yet is a kick nobody can ever be told about. The bit waits instead, and
+ * the bind of that queue takes it and delivers it.
+ *
+ * So a set bit is consumed at most once, and exactly once if a scan finds a
+ * binding for it or a bind for its index runs. A bit whose index is never bound
+ * is consumed never, and stays set until the page is reclaimed when the device
+ * unbinds. A bit whose bind is still coming looks the same to the driver, so it
+ * holds both.
+ *
+ * The bound only ever rises, so a scan reads every word a binding has reached
+ * into and not only the words the bindings of the moment need.
+ *
+ * Context: Interrupt context. Called with the RCU read-side held.
+ * Return:
+ * * true if the scan found no bit it could deliver, false if it found at least
+ *   one.
+ */
+static bool ne_mux_scan(struct ne_mux_vec *mux_vec)
+{
+	struct ne_pci_dev *ne_pci_dev = mux_vec->ne_pci_dev;
+	u32 bits_per_word = BITS_PER_TYPE(*mux_vec->bitmap);
+	u32 nr_words = READ_ONCE(mux_vec->max_bit) / bits_per_word + 1;
+	bool empty = true;
+	u32 i = 0;
+
+	for (i = 0; i < nr_words; i++) {
+		u64 word = READ_ONCE(mux_vec->bitmap[i]);
+
+		while (word) {
+			u32 bit = i * bits_per_word + __ffs64(word);
+			unsigned long notify_index = bit * ne_pci_dev->mux_nr_vecs +
+						     mux_vec->vec_rel;
+			struct ne_mux_binding *binding = NULL;
+
+			word &= word - 1;
+
+			binding = xa_load(&ne_pci_dev->notify_xa, notify_index);
+			if (!binding)
+				continue;
+
+			empty = false;
+
+			if (test_and_clear_bit(bit, (unsigned long *)mux_vec->bitmap))
+				eventfd_signal(binding->ctx);
+		}
+	}
+
+	return empty;
+}
+
+/**
+ * ne_mux_handler() - Interrupt handler for one pooled MSI-X vector.
+ * @irq:	Interrupt line the pooled vector is on.
+ * @data:	Multiplexer state of the pooled vector.
+ *
+ * Context: Interrupt context.
+ * Return:
+ * * IRQ_HANDLED on interrupt handled.
+ */
+static irqreturn_t ne_mux_handler(int irq, void *data)
+{
+	struct ne_mux_vec *mux_vec = data;
+	u32 pass = 0;
+
+	/*
+	 * xa_load() drops its own RCU read-side before it returns, so take one
+	 * here to keep a binding alive for as long as it is dereferenced.
+	 */
+	rcu_read_lock();
+
+	/*
+	 * The device sets a bit and then raises the interrupt, and one interrupt
+	 * can stand for several bits, so a scan can miss a bit set while it runs
+	 * or one past the bound it read. The device raises for every bit it sets
+	 * whatever the bitmap holds, so such a bit has an interrupt of its own
+	 * still to come and reaches its eventfd on that one. Scanning again,
+	 * reading the bound again, delivers it on this interrupt instead, so stop
+	 * on the first scan that delivers nothing. Stopping on an empty bitmap
+	 * instead would wait for a read a bit no bind is coming for never gives.
+	 * NE_MUX_MAX_PASSES caps the scans either way, so a device that goes on
+	 * setting bits cannot hold the handler.
+	 */
+	do {
+		if (ne_mux_scan(mux_vec))
+			break;
+	} while (++pass < NE_MUX_MAX_PASSES);
+
+	rcu_read_unlock();
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ne_mux_teardown() - Take the interrupt multiplexer bitmaps back from the
  *		       device.
@@ -561,6 +686,8 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 static void ne_mux_teardown(struct pci_dev *pdev)
 {
 	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct ne_mux_binding *binding = NULL;
+	unsigned long notify_index = 0;
 	u32 i = 0;
 
 	if (!ne_pci_dev->mux)
@@ -568,13 +695,40 @@ static void ne_mux_teardown(struct pci_dev *pdev)
 
 	iowrite32(NE_MUX_SHUTDOWN_ON, ne_pci_dev->iomem_base + NE_MUX_SHUTDOWN);
 
-	for (i = 0; i < ne_pci_dev->mux_nr_vecs; i++)
+	for (i = 0; i < ne_pci_dev->mux_nr_vecs; i++) {
+		if (!ne_pci_dev->mux[i].bitmap)
+			continue;
+
+		if (ne_pci_dev->mux[i].irq_requested)
+			free_irq(pci_irq_vector(pdev,
+						ne_pci_dev->mux_vec_base + i),
+				 &ne_pci_dev->mux[i]);
+
 		free_page((unsigned long)ne_pci_dev->mux[i].bitmap);
+	}
 
 	kfree(ne_pci_dev->mux);
 
 	ne_pci_dev->mux = NULL;
 	ne_pci_dev->mux_nr_vecs = 0;
+
+	xa_for_each(&ne_pci_dev->notify_xa, notify_index, binding) {
+		xa_erase(&ne_pci_dev->notify_xa, notify_index);
+
+		eventfd_ctx_put(binding->ctx);
+
+		kfree(binding);
+	}
+
+	/*
+	 * Freeing the handlers above quiesced the readers that hold no lock,
+	 * and the loop above freed every binding that outlived them. Wait for
+	 * the callbacks a replaced binding already queued, so that none of
+	 * them runs once the module text is gone.
+	 */
+	rcu_barrier();
+
+	xa_destroy(&ne_pci_dev->notify_xa);
 }
 
 /**
@@ -631,8 +785,11 @@ static int ne_mux_setup(struct pci_dev *pdev)
 	ne_pci_dev->mux_nr_vecs = nr_vecs;
 	ne_pci_dev->mux_vec_base = vec_base;
 
+	xa_init(&ne_pci_dev->notify_xa);
+
 	for (i = 0; i < nr_vecs; i++) {
 		u16 donate_err = 0;
+		int irq = 0;
 
 		ne_pci_dev->mux[i].bitmap = (u64 *)get_zeroed_page(GFP_KERNEL);
 		if (!ne_pci_dev->mux[i].bitmap) {
@@ -663,6 +820,26 @@ static int ne_mux_setup(struct pci_dev *pdev)
 
 			goto teardown_mux;
 		}
+
+		ne_pci_dev->mux[i].ne_pci_dev = ne_pci_dev;
+		ne_pci_dev->mux[i].vec_rel = i;
+
+		irq = pci_irq_vector(pdev, vec_base + i);
+		if (irq < 0) {
+			rc = irq;
+
+			goto teardown_mux;
+		}
+
+		rc = request_irq(irq, ne_mux_handler, 0, "enclave_mux",
+				 &ne_pci_dev->mux[i]);
+		if (rc < 0) {
+			dev_err(&pdev->dev, "Error in request irq mux [rc=%d]\n", rc);
+
+			goto teardown_mux;
+		}
+
+		ne_pci_dev->mux[i].irq_requested = true;
 	}
 
 	return 0;
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 2cef40c627f9f..0dbce83cb06bd 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -9,12 +9,15 @@
 #include <linux/atomic.h>
 #include <linux/bits.h>
 #include <linux/build_bug.h>
+#include <linux/eventfd.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/rcupdate.h>
 #include <linux/stddef.h>
 #include <linux/wait.h>
+#include <linux/xarray.h>
 
 /**
  * DOC: Nitro Enclaves (NE) PCI device
@@ -201,6 +204,12 @@
 static_assert(NE_MUX_MAX_BITS / BITS_PER_TYPE(u64) * sizeof(u64) <= PAGE_SIZE,
 	      "the bitmap of a pooled vector has to fit its donated page");
 
+/**
+ * NE_MUX_MAX_PASSES - Largest number of times the handler of a pooled vector
+ *		       scans its bitmap in one interrupt.
+ */
+#define NE_MUX_MAX_PASSES	(4)
+
 /**
  * enum ne_pci_dev_cmd_type - Device command types.
  * @INVALID_CMD:		Invalid command.
@@ -648,9 +657,35 @@ struct ne_slot_pool_run {
  * @bitmap:			Page-sized bitmap in which the device sets a bit
  *				for every enclave queue that signalled through
  *				this vector.
+ * @max_bit:			Highest bitmap bit an enclave queue has been
+ *				bound to, bounding the scan of @bitmap. It only
+ *				rises, so a scan reads the words of bindings that
+ *				are gone as well.
+ * @ne_pci_dev:			NE PCI device this vector belongs to.
+ * @vec_rel:			Index of this vector within the pool.
+ * @irq_requested:		Whether the interrupt handler of this vector is
+ *				installed, which is not implied by @bitmap: a
+ *				vector whose bitmap the device already owns may
+ *				have no handler yet.
  */
 struct ne_mux_vec {
 	u64			*bitmap;
+	u32			max_bit;
+	struct ne_pci_dev	*ne_pci_dev;
+	u32			vec_rel;
+	bool			irq_requested;
+};
+
+/**
+ * struct ne_mux_binding - Eventfd bound to one enclave queue.
+ * @ctx:			Eventfd signalled when the queue is kicked.
+ * @rcu:			Head used to free the binding after a grace
+ *				period, so that an interrupt handler which
+ *				already loaded it can still dereference it.
+ */
+struct ne_mux_binding {
+	struct eventfd_ctx	*ctx;
+	struct rcu_head		rcu;
 };
 
 /**
@@ -672,6 +707,8 @@ struct ne_mux_vec {
  *				capability, and with it the multiplexer and slot
  *				pool registers.
  * @iomem_base :		MMIO region of the PCI device.
+ * @notify_xa:			Enclave queue bindings, keyed by the notify index of
+ *				the queue.
  * @mux:			Per-pooled-vector interrupt multiplexer state.
  * @mux_nr_vecs:		Number of MSI-X vectors in the interrupt
  *				multiplexer pool.
@@ -706,6 +743,7 @@ struct ne_pci_dev {
 	struct workqueue_struct	*event_wq;
 	bool			has_vendor_cap;
 	void __iomem		*iomem_base;
+	struct xarray		notify_xa;
 	struct ne_mux_vec	*mux;
 	u32			mux_nr_vecs;
 	u32			mux_vec_base;
@@ -750,6 +788,15 @@ int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
 		  struct ne_pci_dev_cmd_reply *cmd_reply,
 		  size_t cmd_reply_size);
 
+/**
+ * ne_mux_binding_free_rcu() - Free an enclave queue binding after a grace
+ *			       period.
+ * @binding:	Binding that has been removed from the queue bindings xarray.
+ *
+ * Context: Process context.
+ */
+void ne_mux_binding_free_rcu(struct ne_mux_binding *binding);
+
 /* Nitro Enclaves (NE) PCI device driver */
 extern struct pci_driver ne_pci_driver;
 
-- 
2.47.1


