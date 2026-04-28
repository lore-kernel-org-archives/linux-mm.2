Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65291FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 17:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEDE6B0005; Tue, 28 Apr 2026 13:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E1B6B008A; Tue, 28 Apr 2026 13:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966696B008C; Tue, 28 Apr 2026 13:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 832816B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:25:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0031D1401F4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:25:01 +0000 (UTC)
X-FDA: 84708640044.01.14C3609
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BD98A0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:24:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GuDH+0ef;
	spf=pass (imf15.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777397100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rrqnMSkJK7r/cDlRpksXyGq7DpXCCWEbuMA7lgNfeg=;
	b=t1NcxvowHZV7LNvuVkjSH+CVpcAHjBj4ctzHJKmnp8FJQwW+5NwL0/9PuLlXfui4DBnHo6
	VkKdYAEq9BKiNreiQ4lV7yEDLuaPM2x+6xRbDDrzdSHkouNKuCG9gd5AXVov79nBj5AYVN
	f1fjLIq7J6wHJOc6UuSWW++PiN7Vsn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777397100; a=rsa-sha256;
	cv=none;
	b=UD2fGZ7A8qf5MgLIyouhmE40UtiXxMskCyl2a+GA4ELSRi0Shozs57HQ30wEDZMYU6H7vW
	QcOeziGkvaDVuNJO7P/JyZLB7oBJWuESQxaD7zH5+1SV9YSSElFdwqbsmJZmGe1odL/ER7
	h88g5H1/om9o6e+RUsiT+TxEc37zRZk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GuDH+0ef;
	spf=pass (imf15.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b2591757fbso23555ad.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777397099; x=1778001899; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3rrqnMSkJK7r/cDlRpksXyGq7DpXCCWEbuMA7lgNfeg=;
        b=GuDH+0ef+PI8QbczPvPPPnTaB/MNl9n9dhYYhSLhCF8s0YHTRM32ZnLjIVgf/3EWUd
         uoKbZjHxE6SJY8RHQ5NaDCz8S2ksTVNdB4fFRkyZOqpZwGnoKZDJkErU5M0ti6FpeCxC
         LXmroV9MtZLtl6C34V05Fjq5nSeQOQMQRnruzC7ntCnYnkQ2yCRUneGQ2K/XU++z5cKc
         rUymhLO8wN0KE+r4MUuPKcU3bs0wKM8zb+OlZ381QmzDgTts1fu0m9k67+CHuajPjAoW
         6moQRsxtsHFLZ6j0xLK7JCY27RL8rLr6uaQjKohutWtOSG9z34Bbk9+ByY4GeZtWzxlK
         SU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777397099; x=1778001899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rrqnMSkJK7r/cDlRpksXyGq7DpXCCWEbuMA7lgNfeg=;
        b=KfzvoKi0JCaaj4d76xOvOFdmOrriVllPq3aoeTsgbto/xoB4/dRJ8LOvWR4j1DSzyr
         Gcn6YNg68mtm3p0dmNPh5NRyKLgS4ImrjfzjEhkcRW3oF356HhR5uIugVR72Bn8kYQfP
         xlbK0xJWCbhMc/AalcM2IchT4s3xMauNiIrXpJHHDkr7ZxaMNzqRG3UllIGsAnW4Bkei
         0pTBCyObdZRF6qIA9unNf2vn9U8kpnTesv97A5SC8Fxakb3hAtDJHGiwsdZx3JnvRuZ3
         47JIPOQ7GzSovZdByBSarSLU1dlC5AQhglDg/O79Czk+aF8TwsFiw0ezfpzYiRx1C0kf
         uBgg==
X-Forwarded-Encrypted: i=1; AFNElJ+PuuSWpH78umYeyO3GRaTrRf6ghXgAYMHWSuSxtBs68IhSQZjbSZIc/WAl5Izf/0SbEdxbnRS+8g==@kvack.org
X-Gm-Message-State: AOJu0Yxk7KBym7KIav7gsv7kiSKozRcirX0i65X3op5WZCVBLNOKso+h
	42OBoCPgnyPbQYSj4CMcNdX8qYKsamHQdumbUCY+XoMb2sLDDCLLp0t+qgUFQ0/9wQ==
X-Gm-Gg: AeBDietugEVWyh8a8YGGFO/6bh38gg3/hSyZRlxsWVQO3fEnai9QB0WZQEN+3CsmZcE
	Gv8Rfh61UENtKKCfv2x55rrR2UA0r0rsKfBUyjRWRdgUuZc+sI21gGMI6/L7l9vrFC/zJ0CGyNu
	HXNFy+Wh1xoO+turyj3xrkXPRc8clHNM3t3EOa8Kjepnw7lV/k6g529S7KksobpToKmt3/ED82O
	oxQLd+woAlLeD+82O7jrJvWi97Mu1rHwPptRFZVg4XLMZzneyO/V0N+oY7ezCMd4xkha2MKkiui
	m/GbDpb3pDYF3A7iPLtFAUytRMHvXVhuCFQ9KIWArSgOWBrIaAyLdC99xDRUOy3p8FrCqLzARuI
	xznqsJCo5Py9PwHJ/tuwqjXHqqxEuAERgtSlzsF+CcvMkbsoTs+Jyxj/GY+QrlSdO17Ug3943gl
	YdRLBO7c+VlObiypCqi+SSVl0cyx1JEtpkEu6q8P/KgjcMivg+1Z9gVOyCOOHe2Ube6qG9XvbT6
	hOCvPiY6Rg=
X-Received: by 2002:a17:903:380e:b0:2ae:80a3:98a9 with SMTP id d9443c01a7336-2b987f6d05dmr24355ad.11.1777397097903;
        Tue, 28 Apr 2026 10:24:57 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97aca8369sm31190845ad.75.2026.04.28.10.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 10:24:57 -0700 (PDT)
Date: Tue, 28 Apr 2026 17:24:53 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afDqs6oqWlhoVqMN@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-3-dmatlack@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BD98A0008
X-Rspam-User: 
X-Stat-Signature: 187e9zhzrgatc5e39xz91qrd4huf81op
X-HE-Tag: 1777397099-87864
X-HE-Meta: U2FsdGVkX18ejhvwWC/W2kqpYP7sLrvZW15uSIwf6qbGAKOZpGTtXSRlJfuYDgad++uXXxwSO7tHhG9656GKUWMkgYapxk+kCJw1xTEGLLP0uuplq7bxuo3QG72Smglp9VmY1r5k4aXkrra8s92POT1cX2Tc8PcGrsoHtBDyXpxB5XQwdidpE4UAERUfl/s6DWMQLufv3gcBXl7kVNvDE2MLTSvV4ma4agbzNnvR5a6Bv80KDKS5RdJRz0hsTsqmJQalfQHm2wv0hOAJ6T+S0UY1fJ5PzDUtLX5m7T9SOKghotz85aJX3Wf73r1hWJRvNBEWLHKXBtIcmerdvmVBdjyLWmsfJI2OWH2boOwtA37GK96351XXuakZWF6YzDeSW3Fq8gaBiLAgjLOGUQHebM259BH7sHkaBmhchapdwxf9/LAYpWHhR2WD6oNyLprO7+5B4MJ5vKywbV2b/UlXVnWAIStk1Lgpz0iGgsNOiYb5JrIgVl1b3L6MDeC/ebLE2mL7/xEoleC0d6HRuyG9JaZ3kccrTRndoXPomwwwcMbcKSpaiic6/MJ6LAgUZvKLUepfKteec+LB/zH5ClsAUvdSJ8ofhnyT5+mxjHvGRj2xkV/KkplRYTnhinPalgV0dz0i6OJ55vtdzLxAXJZ98zaVpctQ5FxLyZQVtWVGjMMJQdH0corWmVic369PwVqMAYfXuQTdh/M5ciYO+m82nOzusGFGsIDaFT0Ego+4BTU+dnubUTNBDr+wBhaNGsBlWXT0gnBsTjWYg0nLmKovm01WYfqbCOHt3oaE/YKe1722ZgwJtgs/LgaquuOE3acsZMDdpXLO/PG+cEPvCfhg6HdGnSIzbFPbaMtf3DiOni/CdoysOdxqhlRY3sCGeuvq8Pf0Nsckfabr362X1WYcNhuvA2TrMrljEEGvNUQ8LLVd+RNr1IBhLheiF1twnwsv+yo1x3+o+frB+Czb4EV
 fGt+VdMy
 bh2DR5ppFxKsBi6VEM7d2ZJJ75szKQkB17qCML5DXkcglHo4Qn9zWv1/rpZQL1zbd7lCsJVCrFp2L6iFJVNOubKMgNL18ytbFMEAOl//JyPwN7kUBfS51R5QJahFek5oSC3n42Wer6yg/NBgxPQlXbQMTZIYF4qfPs6C/bL3Q6V+r10b6VRzsSwCyAVYJNTtMISodDXBKzLBIv2E6b+Z0ROSADxI/974XQCs7NS5q7ujZ9BqEuZ0F55goWAUQ+d1+HgmpDAEkl4tZ1nCEX1Zvs0s1K6Aa8ba3gB7CJep0/UBkIndC+SBn2BKnLUAu0u+3pH3G/BWxsbbzDJGtbJb1HwW6rBgHm2aDGU+blcrEZRyRL+SAd5zVxJjD8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
>Add APIs to allow drivers to notify the PCI core of which devices are
>being preserved across a Live Update for the next kernel, i.e.
>"outgoing" devices.
>
>Drivers must notify the PCI core when devices are preserved so that the
>PCI core can update its FLB data (struct pci_ser) and track the list of
>outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
>device must be preserved across Live Update. pci_liveupdate_unpreserve()
>reverses this (cancels the preservation of the device).
>
>This tracking ensures the PCI core is fully aware of which devices may
>need special handling during shutdown and kexec, and so that it can be
>handed off to the next kernel.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/liveupdate.c    | 101 ++++++++++++++++++++++++++++++++++++
> include/linux/kho/abi/pci.h |   7 +--
> include/linux/pci.h         |  26 ++++++++++
> 3 files changed, 131 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>index d4fa61625d56..2dd8daa2f17c 100644
>--- a/drivers/pci/liveupdate.c
>+++ b/drivers/pci/liveupdate.c
>@@ -43,6 +43,26 @@
>  *
>  *  * ``pci_liveupdate_register_flb(driver_file_handler)``
>  *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
>+ *
>+ * Device Tracking
>+ * ===============
>+ *
>+ * Drivers must notify the PCI core when specific devices are preserved or
>+ * unpreserved with the following APIs:
>+ *
>+ *  * ``pci_liveupdate_preserve(pci_dev)``
>+ *  * ``pci_liveupdate_unpreserve(pci_dev)``
>+ *
>+ * This allows the PCI core to keep it's FLB data (struct pci_ser) up to date
>+ * with the list of **outgoing** preserved devices for the next kernel.
>+ *
>+ * Restrictions
>+ * ============
>+ *
>+ * The PCI core enforces the following restrictions on which devices can be
>+ * preserved. These may be relaxed in the future:
>+ *
>+ *  * The device cannot be a Virtual Function (VF).
>  */
>
> #define pr_fmt(fmt) "PCI: liveupdate: " fmt
>@@ -57,6 +77,8 @@
> #include <linux/pci.h>
> #include <linux/sort.h>
>
>+static DEFINE_MUTEX(pci_flb_outgoing_lock);
>+
> static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> {
> 	struct pci_dev *dev = NULL;
>@@ -124,6 +146,85 @@ static struct liveupdate_flb pci_liveupdate_flb = {
> 	.compatible = PCI_LUO_FLB_COMPATIBLE,
> };
>
>+int pci_liveupdate_preserve(struct pci_dev *dev)
>+{
>+	struct pci_ser *ser;
>+	int i, ret;
>+
>+	guard(mutex)(&pci_flb_outgoing_lock);
>+
>+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
>+	if (ret)
>+		return ret;
>+
>+	if (!ser)
>+		return -ENOENT;
>+
>+	if (dev->is_virtfn)
>+		return -EINVAL;
>+
>+	if (dev->liveupdate_outgoing)
>+		return -EBUSY;
>+
>+	if (ser->nr_devices == ser->max_nr_devices)
>+		return -ENOSPC;
>+
>+	for (i = 0; i < ser->max_nr_devices; i++) {
>+		/*
>+		 * Start searching at index ser->nr_devices. This should result
>+		 * in a constant time search under expected conditions (devices
>+		 * are not getting unpreserved).
>+		 */
>+		int index = (ser->nr_devices + i) % ser->max_nr_devices;
>+		struct pci_dev_ser *dev_ser = &ser->devices[index];

nit: Maybe we can move this logic in a separate function as down the road
when we expand this to add VFs and Hotpluggable devices, this might
change significantly? It's good if it is self-contained.
>+
>+		if (dev_ser->refcount)
>+			continue;
>+
>+		pci_info(dev, "Device will be preserved across next Live Update\n");
>+		ser->nr_devices++;
>+
>+		dev_ser->domain = pci_domain_nr(dev->bus);
>+		dev_ser->bdf = pci_dev_id(dev);
>+		dev_ser->refcount = 1;
>+
>+		dev->liveupdate_outgoing = dev_ser;
>+		return 0;
>+	}
>+
>+	return -ENOSPC;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
>+
>+void pci_liveupdate_unpreserve(struct pci_dev *dev)
>+{
>+	struct pci_dev_ser *dev_ser;
>+	struct pci_ser *ser = NULL;
>+	int ret;
>+
>+	guard(mutex)(&pci_flb_outgoing_lock);
>+
>+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
>+
>+	if (ret || !ser) {
>+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
>+		return;
>+
>+	}
>+
>+	dev_ser = dev->liveupdate_outgoing;
>+	if (!dev_ser) {
>+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
>+		return;
>+	}
>+
>+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
>+	ser->nr_devices--;
>+	memset(dev_ser, 0, sizeof(*dev_ser));
>+	dev->liveupdate_outgoing = NULL;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>+
> int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> {
> 	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
>diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
>index 5c0e92588c00..5b4c8d9e462c 100644
>--- a/include/linux/kho/abi/pci.h
>+++ b/include/linux/kho/abi/pci.h
>@@ -23,19 +23,20 @@
>  * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
>  */
>
>-#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
>+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
>
> /**
>  * struct pci_dev_ser - Serialized state about a single PCI device.
>  *
>  * @domain: The device's PCI domain number (segment).
>  * @bdf: The device's PCI bus, device, and function number.
>- * @reserved: Reserved (to naturally align struct pci_dev_ser).
>+ * @refcount: Reference count used by the PCI core to keep track of whether it
>+ *            is done using a device's struct pci_dev_ser.
>  */
> struct pci_dev_ser {
> 	u32 domain;
> 	u16 bdf;
>-	u16 reserved;
>+	u16 refcount;
> } __packed;
>
> /**
>diff --git a/include/linux/pci.h b/include/linux/pci.h
>index d70080babd52..eb94cbd8ab9d 100644
>--- a/include/linux/pci.h
>+++ b/include/linux/pci.h
>@@ -41,6 +41,7 @@
> #include <linux/msi_api.h>
> #include <uapi/linux/pci.h>
> #include <linux/liveupdate.h>
>+#include <linux/kho/abi/pci.h>
>
> #include <linux/pci_ids.h>
>
>@@ -594,6 +595,9 @@ struct pci_dev {
> 	u8		tph_mode;	/* TPH mode */
> 	u8		tph_req_type;	/* TPH requester type */
> #endif
>+#ifdef CONFIG_PCI_LIVEUPDATE
>+	struct pci_dev_ser *liveupdate_outgoing; /* State preserved for next kernel */
>+#endif
> };
>
> static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>@@ -2880,6 +2884,14 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
> #ifdef CONFIG_PCI_LIVEUPDATE
> int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
> void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
>+
>+int pci_liveupdate_preserve(struct pci_dev *dev);
>+void pci_liveupdate_unpreserve(struct pci_dev *dev);
>+
>+static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
>+{
>+	return dev->liveupdate_outgoing;
>+}

Is this expected to be called under the outgoing lock?
> #else
> static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> {
>@@ -2889,6 +2901,20 @@ static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh
> static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> {
> }
>+
>+static inline int pci_liveupdate_preserve(struct pci_dev *dev)
>+{
>+	return -EOPNOTSUPP;
>+}
>+
>+static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
>+{
>+}
>+
>+static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
>+{
>+	return NULL;
>+}
> #endif
>
> #endif /* LINUX_PCI_H */
>-- 
>2.54.0.rc2.544.gc7ae2d5bb8-goog
>

