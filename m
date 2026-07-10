Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCE6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DC26B00C0; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6746B00C1; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D2F6B00C2; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A04156B00C0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E00FC3187
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:34 +0000 (UTC)
X-FDA: 84974151108.30.F083E86
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 664C140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h79ceL4q;
	spf=pass (imf07.hostedemail.com: domain of 3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh0w4YZ9EkCKSJvWXCxWBgNBQIG8ERULbiy01R/Xx2Q=;
	b=0bLcvJVgqslX9Z2JELNAlm3Le+ilRhmav0OE5sA09UuLq7h9hC3F1elJ07e0TT6HYH5kh7
	f5qMoia9BdfXQUfRaLRsP5ybT4U4G9++1fVSV84X5aZ8Y1BgNNV6u1GxVoeHm9FkzxJVvk
	aXK24FCJUflaaP01P8lzX2ZJfwZ9oyU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h79ceL4q;
	spf=pass (imf07.hostedemail.com: domain of 3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718792;
	b=Lv+evHsBiugGBGkfuq5V2uRlWKLvJnONQTCNOzAlET5pKIUuuqKKPw5yz28w5UMcGZbCA9
	Gk3DzftNt5iL8MsiEBMLr2d+xbXS4rWeicxrghXyWvvR+3r+zjwAZsVREEo+PlpuJPu5ps
	5MjSwmNfSLiBeaa0XaoPcO/OSXapxDY=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8423f544944so1111667b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718791; x=1784323591; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vh0w4YZ9EkCKSJvWXCxWBgNBQIG8ERULbiy01R/Xx2Q=;
        b=h79ceL4qtCB2umUSUaVNe3RG6Nno0xMpN/mB//oaE56iXswWU/TEERfwRjUJNm82TL
         fe6M5FDZzAK+bu1F1/6BFiJb1dMT78fqrscSFkGu5GbImwU09eatVtLDLUznYllNCZJ1
         bGSSlAbbxI0Bflb/0YmIQKhALTOblp7HWQT83wvwIAWK/+rpGWQ8z12sqNmX0aUu6XqW
         oXuTiqjW7lnrarW4iyDgK255lhYNAvbSwf5ys8sdCTAX21IVEKRUMBX8W0w5OeJY+ESe
         xOB/2oqmGY3nfeF9A0eLUAlK5ZKN5csKfsk7KT2Quzi2GOzS2Ec4GhhTTzje+mIcdU9C
         mJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718791; x=1784323591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vh0w4YZ9EkCKSJvWXCxWBgNBQIG8ERULbiy01R/Xx2Q=;
        b=dygjaO3a1DpqAxWCf8HaBjWD2DdPdbN3VrlkVlWQD0oQeQWh7puKuigzj9AGrUSUT6
         XksPaWRM5qd2ocurJrIoWDVUBY+23ujQLhniBptP6p35ForS1DdhqfXht0/Lif/pYgLH
         jEuC2xB0GMlIGVYmAVbIrfIyRXhpQmFER/gJ+WEj7aWtI9+0oajz8g9AUwzLkrhII+0N
         fgKsw9HnU7XMi5vHgjiuXNcyQ09Azlweln6N+zyJ89XzHZrRH+ZB1RoYBqtNyeUfv54W
         j3gFPR1I4cw8gLMWRnNVaW03Hw6QSD7VyVbBOR0I3wMKNLMmFcqeXbD2k6Y3qBbXG8ZM
         iIgA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5dt3Caf1PD2wrNELea0H3zpY52YzZojmGAT+OujAeSjEocRkF1dkDVEqk7IoawgtLkN2VDnQepg==@kvack.org
X-Gm-Message-State: AOJu0YwqZSXrat/VTJ4FNqf42PiccXNy5c3gR3ObqTLk+gAzwqrP15DS
	wB+8U4tNiCNk9mtgEIPUeNfLFvcu0NkeNkrCwQhknzozw05Hw9Ox/+5NgwJP85BMr746JmcJXIr
	+TuVRMrBrdUqu2g==
X-Received: from pfbfe24.prod.google.com ([2002:a05:6a00:2f18:b0:848:401c:994])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:14c3:b0:847:9c06:2bef with SMTP id d2e1a72fcca58-8488971669emr605929b3a.29.1783718791168;
 Fri, 10 Jul 2026 14:26:31 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:13 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-11-dmatlack@google.com>
Subject: [PATCH v7 10/12] PCI: liveupdate: Freeze preservation status during shutdown
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
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 664C140007
X-Stat-Signature: c6i6zazf679swzwnyxpejax5z8zi6c8r
X-HE-Tag: 1783718792-48881
X-HE-Meta: U2FsdGVkX1/9HueQXU2/e5HiRGaf3ZKhdkXh+rt1EM8nkkLnYwJmxxIpnKjikAnp1O6qxDPMPw99ICW1l3t1UplThu16VdDIH8VIB77l6YWtGxr7OqCp1PAaVYMpT9uneUDHU880fmQXFMA+tCi+pXBVkWFGowQzTDqrGgpneGAeSfS1v6aI5PisVD9XeMUH1C90K6zfGoJpX47wOZ6wvcCao1LqlRZ5y88yTuj+0iZ4wXemKs0tXZyFFhmYxV95fohKepdkwJ6DpEt/KnBWcfCaIn5C+chlb7HaV/Ii6S8SZfeRSpHPtq25Sk9Gh6hIh4M0lzNvGnZUmIZPQCyX6gBW+kqhX/pYSz5OWim+SFEiQ35xKPaeQROKlGM+uwxMckDrWjsaCs6TKnsr+0CEiY4KGTW6qPX8Sx2fWgn2KZb08yngyUCBN5zxVDRoORDA+SOBzoHC3dtYKR2O7XMTLZzPaWZoCbPWCjIy2nCyqq10ViUROA4f/sRVNoAr9b0JbWyorQ7zCpN3bZrJtafiTaKrvutL3NNz9GpQqVi7Q4duIz2fUkKcsGuH763bUAC0oeShG0sIv0wmK7aj9k8ZOLsZZewR+SUkWF39bn6rqOqW6/UXxWY/3axvNUWO9zvxSQ6PDxDNr8ojSumkcPm0DRDAFGa3mm3nMMCnXDL5sA71Co5Z/NEjI8On7oeHT2dq5/S2hdtUg+udHRgwsR2BhAxt8ZFvuq8vbny6BHmrkxQfaYEqk4WAL4eaNXB5z2rQIqvinlGlGzaW2xKocSRzg3Cp0rUVgBL3kEIJFaYTEFdDPsYIUpPCnDEtl0RGfL9k1jJcktIsRwkiah4V/9sZyvK1WI/48D1i8cgsn8ZJQSiz8A9ii3WfyFO7z/nLTD5nycEH4N6pbPKRESatKOxxIOFw2rI+661Zj6DcxfiQtFiLT7IufwUp8kD8BfX5W5RQbyjVOYeMEVGr3riU/q0
 cweLrgWa
 C0MgrnGe2+nnvGHCH2EubAUDlQSaaD5YqmF9NdWrlQNmLI5KwaPNY0SAdW04acpKPrwskMJObA3W54s4bCR82NjbWe4T2J8tUJlUD3ECm/RsnjoOUOCQRN5MMLgU+y95g6mJR4eoeMCBKO/MjampbRZ76IiMCEy85KvhPT/pSxJEzMPhfISrUdsJB1r6EJ23di3L4B7JEU214aDaJ/KgK3bH5X/s07DM7k2XdbYljwgeoeY/HhQZ71EI0HImrkAB4YzkdzdUgsFpDUOdVMR6GOB6/cEQ6GZnAoYJQ3AxcVoi7fqfS1dsIJLFCknS1/6WnRszNWQeJV9q55KIkqOWURTHV+GvnW5gs7I/1NyMuWw8Els9LlGzuffCj4B6sg5HIxkfbQieHMxuWj1lQCDI1Zx36GgL18ycteUUACRVyvah09pEpHBVK6k1wzen55oyZ2/Z6k9zpdzDGa5b5NGMV4RUqbMk0OqMSYQkZuJoWxpVVyJbEf0q6GorQa//SQfX7buI4ryEQJVOWgCI7YmBBWO0Fax1DRanirEhQLC4et/JYJwUtukMXvV8YJoZJAyfLlrnYpbGEFSrrTZACYw/JLjJ24DF+F5n7XTRFnfV7sBQG1hojTVGecgK4ibAgEinQ5dUx
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
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 16 ++++++++++++++++
 drivers/pci/liveupdate.h       |  5 +++++
 drivers/pci/pci-driver.c       |  2 ++
 include/linux/pci_liveupdate.h |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 74a11e520f0d..64052892ea84 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -352,6 +352,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing, s
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
@@ -422,6 +427,11 @@ static int __pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, s
 
 static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing, struct pci_dev *dev)
 {
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (dev->liveupdate.outgoing)
 		return pci_liveupdate_preserve_device_again(dev);
 
@@ -713,6 +723,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	}
 }
 
+void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+	dev->liveupdate.frozen = 1;
+}
+
 static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 6f21ec50927b..bcb0bc73d684 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
 				      int pass);
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
@@ -28,6 +29,10 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+}
+
 static inline bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus,
 						    struct pci_dev *dev,
 						    int pass)
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..51616e4327d3 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -21,6 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu.h>
+#include "liveupdate.h"
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -536,6 +537,7 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
 
 	if (drv && drv->shutdown)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 2446c6d237ca..150993405754 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -24,6 +24,8 @@
  * @was_preserved: True if this struct pci_dev was preserved by the previous
  *                 kernel. Unlike @incoming, this field is not cleared after
  *                 the device is finished participating in Live Update.
+ * @frozen: True if the outgoing preservation status of this device is frozen
+ *          and thus cannot be changed.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
@@ -31,6 +33,7 @@ struct pci_liveupdate {
 	u16 acs_ctrl;
 	bool inherit_buses;
 	bool was_preserved;
+	bool frozen;
 };
 
 struct pci_dev;
-- 
2.55.0.795.g602f6c329a-goog


