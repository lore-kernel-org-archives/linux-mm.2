Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6E0C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A466B009E; Tue, 28 Jul 2026 18:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A3A6B00A0; Tue, 28 Jul 2026 18:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6779F6B00A1; Tue, 28 Jul 2026 18:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36BB06B009E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E2A3404FE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:31 +0000 (UTC)
X-FDA: 85039580262.23.2A7D8E2
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id CBB7640005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pOM7VY8t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 31ChpaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=31ChpaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIyl1z6VbEjbpTwDm7dyBOXwnjYP7h00s7jMGOKLSmY=;
	b=a24jh+pjMGOdrTnfNIbFlSdyA+qlBbJVw+UcQSc/WL6cr1H8mTMVGdnwFxMPJoRYE7Ejtu
	8ZS1diuMp28M996Yy6l62X169WcYDXykPWcJRIzfHeEOji3j2C+2LJ9a/9xpe9GJ9c0GB1
	UkcsqNC/PltM1clU4sYHZRCLlsuWbt0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pOM7VY8t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 31ChpaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=31ChpaggKCCUENBUMBDLHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276629;
	b=kY0rLFWPaH2BTyl/1Z1QxVMOv2AOrDEYaSbit4QVLtuKP9V0AXpDI0Oj6qkkFjCYZL1xdh
	EgF7AXq//+qwpYNYeO/GArNOicniLpEG9S3egkGAmJJu4GB2WXb5BIRD5ecMno9On57bfJ
	diWxeeYCzy9bD/0ogghqIkXt0/QIPw4=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d001671a54so6967335ad.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276629; x=1785881429; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wIyl1z6VbEjbpTwDm7dyBOXwnjYP7h00s7jMGOKLSmY=;
        b=pOM7VY8tFskqbtWx/WrmAyo1CfwWN0PYr3yrF81OEonpT6/uZWMshS6NBENDuvxwfG
         GEkRAyfYRGDBO7k/ZIysz9uO+gzojmmIKk1/53OtrZqMC9900MgR9ateBs5/3/kDNeW8
         4efmcjTrEKqcZO0qVq3EFL9js+i23W4EjqEO2YqGQWLh/tN7kZSHlQecsv2XkIYEJCDT
         WRqtKw47ZBuUFaUJkgVKhzk+VvGABb66nEbsF4T2MaURPv7MdNQGW//Cb8K4PHqlNwPm
         d3ZGgK3dHzRGxntHTDlZBBetTdXFHRymJw2H+cZXrq45nAQyXp017R4O02E6uolI8H/v
         3BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276629; x=1785881429;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wIyl1z6VbEjbpTwDm7dyBOXwnjYP7h00s7jMGOKLSmY=;
        b=YMtVxGP//qzXEiFMmklP87UFtLPvYTNou663/mAPv/5nNCrAtGPR9rFym8LsPip4Uo
         iUJ2eTL3yUyxiTxozWc2YKgnE4YseS7n8tA01l7MfqsW4hgJcZqP/03LmzKc34kNXNML
         /jEE5fUoNBIf+s7CKUR6VlLRjHyYjEaIieTjRTwWUclesnef3RCmcoU/o0W3X39Tp8DE
         872lthYq5vMp6gvDtJYyoN5GJiK+YkECisgR3xJV6yL2FYhHPZRLTwrcLQw8KGsGJ+1v
         5DjG27NR37/yIQkQDxCmHJNojeXgCvVaEaTew1E4E5d1Bx7jG4m7vrTX9hQEd2eXGM5h
         NwvA==
X-Forwarded-Encrypted: i=1; AHgh+RoETCPXNePBylPh+h6Xi4RRIemAgYB5iOeBnoq6JcyoZN9iR9i0mqIwDHfGvmqcPYvAN9u2JoGqZg==@kvack.org
X-Gm-Message-State: AOJu0Yz2cdHZhkk5mYR0dIrf2V4nDr0SGU76qMreXgb7Uygh0SAh7PwC
	RBkh/XBO1GfHtdroItsu5fvNjfwjRKEFZuKf9QCBnIWOR2BlP6OvGvURjQU6xUfITmwJqBJU8SG
	Jw2ELnVDmmlsq5w==
X-Received: from pgbcp14.prod.google.com ([2002:a05:6a02:400e:b0:c96:c217:cd27])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3993:b0:3c0:9c19:65a8 with SMTP id adf61e73a8af0-3c8ba62a17dmr5198004637.64.1785276628580;
 Tue, 28 Jul 2026 15:10:28 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:03 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-10-dmatlack@google.com>
Subject: [PATCH v8 09/12] PCI: liveupdate: Adopt ARI Forwarding Enable on
 preserved bridges
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CBB7640005
X-Rspam-User: 
X-Stat-Signature: kjwasoujqfcjchh6shnzbjqzx8xqbetc
X-HE-Tag: 1785276629-988955
X-HE-Meta: U2FsdGVkX19eWFY4RXPYxCTK9ChHjx7boL+UC0phI9ybZhdAID/U3CbPmHb9Nrt76dMZSVgN7xG7QxlYKa2gwXx8ryQbMGa43alWS8FWbMDq6C5NANbjgs4Y4r641MjG3prA5gjQcz9yzzaqjefz1jgCqwntzbPuKBYNNggsTTlptNZ3CqFjBmPeOp9neY2SZK+mPS7QchbRrmIrWSXa7+UKixh6sZ5UUX8tnxXKrJGSLl8tGOYip46FAbb+IqO78bJbwfyCNen/vZw+S3pltYnTyTMus9XVMDHuyDUm5VE4Am5WjQiqjMPZ89XjILYXErNBbRTkfxrzMvDwIjRsqcoUdoZXEHPNcd+U6S79eliMAe5z1o1QY4cZED1X/hxCUgZhkZPQG7oCoJDRQQEeKDWA4Mm+8e+JpJcpl9seX0Sl3JxWNfr97j9mb/5Xd3E94CmyXQ3tXOrs686KPo6nT2HqjkVK60QFo0E1XHRZKVD7omrvVGPTGJVAMbuuVPzFpFGVeM/tVlr/53sqn2M+5jWFJykc0Bhy8p4X3Zsvgo1CQ6j24rOn94MVsBjSiFKdH1CExPF4s7RdRlnP2zGbKMweYSrOfYEgrajPBZIrSiWjhxfqyBY86YoD/rgqvvnugrgLpl7RaMMCsOJEBvsgozC8jxUlI74wdk9WI2kxyZLpp9D42PsWRt0NFRRxtj1roU2Pws51sxON+cHZzntrzQgmLIj9DgfS0ljdAjOA+D1Pbtnwmzpxxm3G6kP6iHg96K7Jh4BmOxVlDga4yqr3N+fxvloOMGZrKATtWB9lTGPlzS/c+P+mB1Gj9PVL1E2AQz28qyq9FpFrVPc8fCuzYTre8Jeqz3dX19MyCUR5VNzKXGy1JESl9OMgA77GSzvOyr7uqlABVDfdMA4dW5scezx/VK0fhiOMk8IDe6Z0/JmAyNWeUBnMVJaUCGqWmrt/IUEFYnFJVzGEqRCMT31
 6qn8Zxfe
 8VD2IerN9m2HFcvMXgCo+UP6QO5FQyjdvkKN/1Y11xqkxLi6/Lg008QFd+h8IhkKIfAnK6Qvotg2t+pNhm2Sq19FEZCs/2jBCSoNlsLuP5HHFhruVwjcLRz/lAidbhNx/lgR8ll2AlaEx6NK4YDrOtzsovV3+f2/6EJ2y9MBhfGn3kNY9EAwsql8cwx2f64UXII8bKi4Hg1ZhTvTvCf30YBg+5sIvzj7YxWPM8eHdgdczMoPscfwymmm6wUUlkQdtyC4PDbn9g2qO3fhoXVniB/hVmqpfyKhinswuRrR1AkoLRUxUm0A+ay+/+YiYB/1OHbUjD7+buBGG5mtydnZaDB0Nus2D7nUDWE0pvAigjSSYaimZuQvEp5+4xtASIQVzZXQbYoaPPTrc9KucAAUJWN86lBVPGbL+iKBpixqJ3Jn4i/G7QeQ3JQMJkBKUefvyapT0UKLBjnF09lq8hmPpmQSKIJNwX1xJ7FKJx2xMmhK3sGm1GR6FhrvmXrS2CAUZqI9AU6bMOPSV6qlkY7W0fmr6fusvL2pPKw1jsdUjvFgoEHKZ9h9yGHmn6NCAGHA/TNzo2jF7RP3ksq0T8NuhCAEqSQWotyddPG6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adopt the ARI Forwarding Enable bit on preserved bridges and update
pci_dev->ari_enabled accordingly during a Live Update. This ensures that
the preserved devices on the bridge's secondary bus can be identified
with the same expanded 8-bit function number after a Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 30 ++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci.c        |  8 +++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index fb602dd3933e..744513ee11ed 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -128,6 +128,10 @@
  *    way after Live Update and ensures that IOMMU groups do not change. Note
  *    that a device will use its adopted ACS controls for the lifetime of its
  *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
+ *
+ *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
+ *    preserved devices to ensure that all preserved devices on the bridge's
+ *    secondary bus are addressable after the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -833,6 +837,32 @@ int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev)
 	return 0;
 }
 
+/**
+ * pci_liveupdate_adopt_ari() - Adopt ARI configuration
+ * @dev: The PCI device to adopt ARI configuration for
+ *
+ * For devices preserved across a Live Update, read the ARI state from
+ * hardware and adopt it. This ensures the device continues to use the ARI
+ * configuration established by the previous kernel.
+ *
+ * Return: 0 on success, or -EINVAL if the device was not preserved.
+ */
+int pci_liveupdate_adopt_ari(struct pci_dev *dev)
+{
+	u16 val;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!dev->liveupdate.incoming)
+		return -EINVAL;
+
+	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
+
+	/* Safe to modify dev->ari_enabled bitfield during enumeration. */
+	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index ac5b8bf2edf5..ccc23031e99d 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,7 @@ bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
 void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev);
 int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev);
+int pci_liveupdate_adopt_ari(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -45,6 +46,11 @@ static inline int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev
 {
 	return -EINVAL;
 }
+
+static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 22001bdf4c97..6922f361a89e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3528,7 +3528,7 @@ void pci_configure_ari(struct pci_dev *dev)
 	u32 cap;
 	struct pci_dev *bridge;
 
-	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
+	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
 	bridge = dev->bus->self;
@@ -3539,6 +3539,12 @@ void pci_configure_ari(struct pci_dev *dev)
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
+	if (!pci_liveupdate_adopt_ari(bridge))
+		return;
+
+	if (pcie_ari_disabled)
+		return;
+
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
 		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
 					 PCI_EXP_DEVCTL2_ARI);
-- 
2.55.0.487.gaf234c4eb3-goog


