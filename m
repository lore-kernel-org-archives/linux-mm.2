Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18ED3C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CAD6B00A2; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64A16B00A3; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04BC6B00A5; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7296B00A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A848416079B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:05 +0000 (UTC)
X-FDA: 85227966810.03.05DF80C
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC2C51A0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OnpcR0vo;
	spf=pass (imf19.hostedemail.com: domain of 35pmtaggKCC0MVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=35pmtaggKCC0MVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtzV4A7ubsZUgCkixUUqpezuoGcnB31d+FYFVqWSkUU=;
	b=fliW7auNxJmUkywXQFrThfUpJ42hPx9mTq0edZtDfjOe96AZlNV68InFau7fj8FeEl2vyL
	BOrmm6O5sAJXrC+qpKojdMGYPX+/ERqXN+/qqosrgGaUG6CvskU78fdg7GrfRxjXipIUp1
	/o6Kmn4tuTpp5yyJdYqO6mws+Hu5/0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762023;
	b=YKJas38TCUW5wlo6w8t7bXfbRLpAt5ckMsYv4lyiJdUHOd/EBXnsbTz5CCcCmBiKrIwY2e
	MvMilrPdcCmoqKi10EpRZVa32pW1pho0ctBiAra5GSDUSQhmROAbLautX1rSWFqsyIQaRn
	2lU6dlMC+5/r1C7EQgPAJj1+ptb6O9w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OnpcR0vo;
	spf=pass (imf19.hostedemail.com: domain of 35pmtaggKCC0MVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=35pmtaggKCC0MVJcUJLTPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc435388657so1531903a12.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762023; x=1790366823; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DtzV4A7ubsZUgCkixUUqpezuoGcnB31d+FYFVqWSkUU=;
        b=OnpcR0vo3emDjzEKB4mQ6nZmEghB9TDy8kH7DGr86GidvChRQPwMLAOcdMnQhLzbSf
         JcLwMQC4wilJ3ffEF2rQpovzbhI/49Pvg6KY+VUlnPXFeH7hjktQaP4QwN2WQiloQfja
         20R1dpk5KZPOwY+EFTXRVEYydGzi4ZZ55vQZE8oOsvhCq4hlUu5yrKxj0RSc5leelIYR
         do0731522WpHW7Cby/4OLvfuwN8Djmo9BAoH+5rySQeTFUap9jcfxnOYVxAFY5YR7fUN
         tg4mypi0X+NOL1pB8VTZMpKl1/ssqQjexHnFMzZzNwtMK8Mz/sCNf6v3rodXp2Bnoes/
         Eogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762023; x=1790366823;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DtzV4A7ubsZUgCkixUUqpezuoGcnB31d+FYFVqWSkUU=;
        b=sBSVFvFtmafiNDvTj7BfHqAmV026B9u0hTd11ykYzCtNL6JHfrXdABYj6znbiIffPo
         eGILJmcTak4YuqW1TBiOIw5iOPrws1Zqr3Ci3zOuW4sX/smPRusqnKDhvN1X8xYy9dkP
         JON989hPHtycqvy9dTS9VSTWUzfIZat8qGvsZ4RYimMdArHCUpiKylDLT0bLaIkdloVE
         yOXK8WN5CjXbSG6GLHF7xHx6PGTpLblcpygp2BOdaDBM8G7sKilIeKO7TYEAHQQUJzRo
         U82kQfODVwItrsO+6MALy1xWXpvEny1ZX9kroJNYlC+6NCyhiahFyJ7pLSs8xz2Fzijd
         HfGw==
X-Forwarded-Encrypted: i=1; AKwUvBwzrD1bqTDSTCf+wzyVpzMqoL3ejbzunDkKMMaw+0U6/N6B6I04CYLE92xp00qMJKQ5dwub+lTsJg==@kvack.org
X-Gm-Message-State: AFuF++kuDezsu2WqBdJygOgy375L+Pk9MihvfzU5jydDd3b+Y+CJHTOa
	bjNlaecrrQOS2VF1b5XUjGbr2WmtQxSgSRlzH/znb8PpapoIBMmKgb6RB5Y+b9Akrbz8HMhq9gK
	VEQ/12uzLfsWDAQ==
X-Received: from pgvc3.prod.google.com ([2002:a65:6183:0:b0:cc4:56ea:7ae7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1b81:b0:3da:bea4:6215 with SMTP id adf61e73a8af0-3dd8c52948cmr7756540637.19.1789762022690;
 Fri, 18 Sep 2026 13:07:02 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:37 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-12-dmatlack@google.com>
Subject: [PATCH v9 11/13] PCI: liveupdate: Freeze preservation status during shutdown
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
X-Stat-Signature: 9q3i4ad9qb3qk83gusk1q8doj3p33dus
X-Rspam-User: 
X-Rspamd-Queue-Id: EC2C51A0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789762023-526166
X-HE-Meta: U2FsdGVkX1+sGaqzVtT8+PY47JVbOhlGKHF/wLOUmbVH1MN6kFMo3NL+DyDeKaccZPGeu9iTkwa75/70Dik24ERFudtJo6otTe5bqIfKyVywj2chKp8Q3XQJ14hkTs0gFh74V4L5+0xzlhrMY9+GFpq47fSZ7YWfyFgDDXOLOWYoWMra8FEdl3LQ1j50G7MtP30vlb/plLmkdBgOtDrtzXe0J/nzV8Z/25eULYoiG+/dhVUQyLTr4G3OVt9m6a8Y6y+BGMlW2CdDYqqljnBeWl8aU1lYdxIQi+5ImmWM7wbTwjzn69CCDehI1Hy1fLvV6zp+GGy7hA8lK2Sapz65Rh1kkTFkt0GH9Ju6qO6/Q2DAF4Ph5Pn1ttkQwSMCWiKVXsuez3IPL2v9biuu3OGj4c8YPruxweyDsLMGaXBSXnSWx0/Hz1kT/luLDHXKXKqw/aziqQ3ZRhoi2SYuN6JVRquGhIQW+lzKXTKXRL6Ao5lyr/hg/IB43rfDJfursyDJWs/sNvnf11acNVFaw9VoiJ6TfzhV0NcAjQDb068Ec/YZecwRkGFWcyieQSS0cvVEhQXGRKxAB3M3TMfLjYYqAsjgxKDRg+mgEd71eZR7W8juLMBNGUa/+syhUJq9037CV9/jbqxQWNTC02NHEgp2mpNQpTfTTIWqiwXyqvgMumolepKo82Aa6fs94Ok2EMxQavkqZwQ2DXLHKBVN6+S7tXoKRy7/9qsCBoAvnVW5VJ1Zgip/ARiU0dgj+4AjPsxRRMKDg3mPAEoJHDD/dwSzTu84aLn7UbSzA0F45mXfjGd4aVY3aZ9oN6JHCJVRTDRS6leOq+KRD/1ZKzzqY+JoUuuA5TScZPBGgpu2wiSH0jGgqhb1Rpvh/DNtgQZp1IGaH1FK6k/oY3H2NSZdMryN6t+gYJxdjRACk7KOV1D/hQ+AH0GrVzH7+jrED0iecjY91uenvLb7pskce6jfdYr
 cGI+q5ul
 9EuL426YljdfswKFG8UhWPwO9MzTZG5oxdp9m0dClOt2rk1tZqNFuZnhBHYpu9ablS2frjKNQDoJqCDpGSlf00XnoohfHbi/Vkermrvcwpfw59a4eAmJH8JVg/1cgOOdXwGtDMXWIO4r3FK9A56uQ2c4ydypRhxaHpz9jOMv/RY6NDbz3DAdKr9av//3frREuzaaTQvDukz0v1iDK9yoAnw3WeRA8+maPsvL0LFvKor+GjISfG1fJyuIgQg8wNtzYj3PoY0jTweHfBTD9eWcdkuGVqR6U9fkiBfnHFGEZ4urcS1iWmEFcFtZ2iiDaUKij0GJnLPBDTXogt25oxnv009RGcLb/PpCysFGpk5uYVcz8auyKNPvl/c2y0V0hNNL4jz0micBuzbOqyQPwW9wP7lMxWp1YeQ7LeQJ41bboGz8UuY+LVX0F0okmsiPTCTAfil1cw7W7D+1WyZdOQbxtXG5creHN0n2PTd191JxGDKLDK1JfKBOhYYajQ/+Ux1hszhBd7kdBZ5xMo+scPOU4ivtbp1cgQ7WRLwOY4ko7KlJ1w9gMjHbwhyWZNujEir03ipneX00oZd5FmL7TAyMicxmaIbvHarTHmJKLCTTKtz9dvAZP9+RqFWnkg5e/yHl2HRpOEp/HR08VAu5AedMgL8HSAg==
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
index 3c9a10a892fc..496ba74c26ce 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -481,6 +481,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
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
@@ -547,6 +552,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (!dev->liveupdate.outgoing) {
 		struct pci_dev_ser *dev_ser;
 
@@ -797,6 +807,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
2.55.0.1082.g2b9226bbc0-goog


