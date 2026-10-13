Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6444BCC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CF26B00A0; Tue, 13 Oct 2026 12:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774696B00A1; Tue, 13 Oct 2026 12:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AB36B00A2; Tue, 13 Oct 2026 12:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4A76B00A0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEB5C80D0E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:51 +0000 (UTC)
X-FDA: 85318129302.06.9CA7B6E
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id D4C3C4000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YFAzfW4Q;
	spf=pass (imf12.hostedemail.com: domain of 3jFvOaggKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3jFvOaggKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908749;
	b=KmQ/nSgMRK7DdDWZ7/QsITN0O8IDpq0mp2FI6CUqXM6b5mEPUlGwhMEt+T8k9TRcF/w9SM
	44Xb99nKr+LZm6lPOnUMbw6ZsZG24U25slJU3TluYu8k0EPlG3M9Xb42wxyJn9CIYJVtr8
	g95nIFDljwrANbGDF+tFL8Q7dntGdLc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YFAzfW4Q;
	spf=pass (imf12.hostedemail.com: domain of 3jFvOaggKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3jFvOaggKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MskRkxPSFzbqMyyuEL+532dIkv44I1UDvOc3a8yN8g=;
	b=jgkvFQD/JJ0UO1QROzEve8ve9jTKHJl1okzsJcSdPhWHysynPvpdPFjSC8UwWDFkf3e9g0
	0aRa5U/1+WBMbZlxDIW6rJV0M5Rk4TdU4y7W6USMlq8rW0yqBjTe/nk8bWg/uATFCyy+4c
	V/TzDR+Vkils1gqg31iyJPbNponFXGc=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so39840985ad.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908749; x=1792513549; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7MskRkxPSFzbqMyyuEL+532dIkv44I1UDvOc3a8yN8g=;
        b=YFAzfW4QyQXZ5UEmqNyE36T/svYYygMk6Yj1Qlb1kfCqHL/MGNlkOj58vcDkY6DtON
         sHl5OZn/sGinU2GnNrgdtfeWk4xFKqyUte+3Kn11QtGPytLSOHO3B/x0eDgGZVhNbrB8
         7EXQGsv9H1sME2UMKSLRVwZ9WSbVLcPGrQHVBLOZ5ctoRgRKxl3v3yKfw0+mqPaMOJKK
         K7euDMZ5nVQ21Ll++Hm0e6ckOjjzN+1JYtMlpxNimI5XAU4k5BfEhIS+P5ZOhJzCpaJ4
         MDyAPfLmwygAvzcBsrcBFILHXZfEbbrfa50vjDbIRrCYejJo6Ox9DRs1gKdr1MhMOWrD
         Aizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908749; x=1792513549;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MskRkxPSFzbqMyyuEL+532dIkv44I1UDvOc3a8yN8g=;
        b=2nbLLO817OFHGVUJRql1glwCZFmIoJnAw2F8FUvi2lznLAZ36p464ZN+6+ODTg22qe
         ym3xlBgdCNdvuMLWh1I/nyJ3AR1CFbjFnNnxO9OZxSuI6yHqf/+aDngb7xgDHn/hdZVU
         yn2BkaQJHj5uQb9FNr24UXsCjvR/K/2aNWsu6ZQmsQ7fQl55SAHSs8zLSktTttfPTsTv
         THSbX/C14lxzvfhAVBbtH0GQ1BhTHaS9JmeJwB31FrUxhfIS43GADzqea7UKoUQJYCnh
         Zqeos3hcf4K/hYRm658VZ2sJ7UuKYe3i2YMI2N41o9P+mUcqqqxboj/uUt5YOIBHZJnw
         Os+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzjSP2mONtjrwiHCz8zMh/g4xQaxARmcE5XPRDHR2vw4hiCPDpx6ZidiJ1RXaqdsiLE6sWYpIg6lA==@kvack.org
X-Gm-Message-State: AFq9FYI//IJPWTj5JYR7gEYurU8bKNYlEGIlTqDDBaqvsmjzXv/CZ8iN
	kiST1qWYwQqD8Z2BcrPlOvhY2eSnFfhGtQBX9OnsWp6+OkBmo4wRIy9MljebF0QavvF4EVfVv7p
	YJ8I+6OhHuMCABw==
X-Received: from plbjk21.prod.google.com ([2002:a17:903:3315:b0:2e3:1af5:b57b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc4f:b0:2dd:c0ff:e726 with SMTP id d9443c01a7336-2e842dff5damr107249425ad.56.1791908748449;
 Tue, 13 Oct 2026 09:25:48 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:27 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-12-dmatlack@google.com>
Subject: [PATCH v10 11/13] PCI: liveupdate: Freeze preservation status during shutdown
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4C3C4000A
X-Rspam-User: 
X-Stat-Signature: sfbkp4dehpmfb7tar7fhf9ggnbaim3s1
X-HE-Tag: 1791908749-141819
X-HE-Meta: U2FsdGVkX19BxDZR3wCupvcmxNS26XCLtdkq9T/4o/xJbVC9K7qLIoUtFBKFMTvc1Py2WazbqJhBVG012LSxDvWwO99LewCmDp+eKgYqfYyHu8DsctpPQDYDhR03IWAgwKyQdpoN4cYpW4xhbOL1O6FZoFpAehlVGjp00gJrDtgnyqcbkGCd0dTC5WBC2sIKdziTcMTDEZGmh/ZEeitueXNHcIwIANslmiwpdLDhJs6uVkPtrwCIUj9Q3NQWZ1lKuaAbXNIuoNql8fHHNpOS+ZYpOVnhjtSMnoKKye78D2oZpAb2VDAtJmVTddIj8Uec8RS80esloZVchLRQzDTonNvcpDdWx9JiUdWvQp31zmGEFLJWUXhtICIvzWTD55EecrXjl5Xmz1o8jCOojzuzV0Oc82I1jqtB6sd3I4o1eAJnKA1vgBtbohpzQVJR7RXAQIyg/9sYGKFUrS8lkgopsxA8ioerVgMiaTQlRNY5a6Tsp8U8wfxjhCbiu/LArRUTRFP1YrG34F6QWi+dmZbRD3jezm4XszPGaFJT81a9eoenIMYmEbzkQ5/J1xy8Y7hYkUSGzb1nrYiSWW0tMJIlU+fphnx3h1DVODdW3oYpWJ9Soltb4YjCJBguM1ZE123h9kVIG/QEyLef4HMiQKnom02AqCoEOyuRt2xZ2UyUbEWbwjSWMQkleuYI6F16eIWmpHTtNIf4OOWwoYVO0/8bYzsq24vm09elRLKnIvIMPLIaVKmsZEpXHuMD3p+8c/iUnOvAhJtKyQne9LW8Ll3w/i91gRRSnb7UqO3hNq1fUl+rS43arA1bUnMsyHD5S5DMCtVAO2PdRxpZ6XcXpOcs90keyxBFm1sNOGoOISlIrl0M+wwJkS3tzBQIHPWFMtT+L6V3+/fs5wO9fwk8Y2DmJrKjjoEDdn798wu0y7xtCVGWCD3yp4RRETpGRf92NqEpqbhr6OQGbijp/WC4Kha
 tj43vYb4
 UC7dkjjacNOJIcgnyTe4KSZQev+irB6nJwo0ZWxilS4irwGY3VuxcgXnbpVFZjds90GiCClqsAaf9fo9YssePnabEO7D88LfOIpA7QHzEG0RbEBPU1/qLOsF8NPX/FcZBYqCht3/bcDF+R8o6HrfAbpSM4BnOR+ZvQFjsdd7lmaPf/xHj9BpPIz3m9pdgEGiRq7cSnw+19rXJeG1MLwi6lkrtHvLpuZFe9yNEy8em/tNVrND+w6ZOF1ZDIUFaxOtCVQUNoo6Ke7WljM/eCmqEyj4cnpMHJ1UCfwd+Hq27WYOu4WM7kBfiJQTQsT9UnPxSSdRTI1D5I7bw2dIQzDI5XHU6IAwUhGnoYo4cEDZ//vnGASmFJAMGKYwOhXlzATKqZXhSxVk9mjWkzB2dqSyX/AwxFOTYLxAWyFJyVr1mu5uWWml1HBGvAVO0M5kUgFrGBMxT/CXB5KxBc/Xp8tb0lR8V2NKL3icNjMsDxIl+v/O1whBaSZ4sbVdLUHdR3GC5zXHw+b8b74C/kyP0N1MRFYraO3K0mrtSKB7EUz6Q/Z0Fg3r9nxkYTPXtlu2e2giSBGVqKJehZSt2M9MwJ1tJkSbg0CilpDmD9A/TM5IDzfaiU/oK1oBnLnU3kRyLsHn73tPUj6YYz2qsbOMon+WO3CLTEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freeze a device's outgoing preservation status (preserved or not
preserved) during shutdown. This enables the PCI core and drivers to
safely make decisions based on the device's preservation status during
shutdown.

Note that pci_liveupdate_freeze() is triggered by the PCI core rather
than from drivers participating in Live Update so that all devices can
have their status frozen (i.e. prevent non-preserved devices from
getting preserved late).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 16 ++++++++++++++++
 drivers/pci/liveupdate.h       |  5 +++++
 drivers/pci/pci-driver.c       |  2 ++
 include/linux/pci_liveupdate.h |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index e640794cc8e6..38b7815fe7d4 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -499,6 +499,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
 		return -EINVAL;
@@ -565,6 +570,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (!dev->liveupdate.outgoing) {
 		struct pci_dev_ser *dev_ser;
 
@@ -815,6 +825,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
 }
 
+void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+	dev->liveupdate.frozen = true;
+}
+
 static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 90b2754ecc0c..5aac19f7bee6 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
@@ -26,6 +27,10 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+}
+
 static inline bool pci_liveupdate_preserve_bus_numbers(void)
 {
 	return false;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e16aa59dd7ac..dff60a03204f 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -21,6 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu.h>
+#include "liveupdate.h"
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -559,6 +560,7 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
 
 	if (drv && drv->shutdown)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index d45a5b524909..bb79348769b7 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -21,11 +21,14 @@
  *                set up, i.e. it was matched to state preserved by the previous
  *                kernel. Unlike @incoming, this is never cleared, so it stays
  *                true after the device finishes participating in Live Update.
+ * @frozen: True if the outgoing preservation status of this device is frozen
+ *          and thus cannot be changed.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
 	bool was_incoming;
+	bool frozen;
 };
 
 struct pci_dev;
-- 
2.56.0.385.gd3acb90ef8-goog


