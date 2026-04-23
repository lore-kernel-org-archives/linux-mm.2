Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FACCFDEE4E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB7C6B0099; Thu, 23 Apr 2026 17:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7628B6B009B; Thu, 23 Apr 2026 17:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624186B009D; Thu, 23 Apr 2026 17:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5303B6B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB71A1B8224
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:33 +0000 (UTC)
X-FDA: 84691097106.20.6C12CC2
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id EED9F4000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ByTOZ7il;
	spf=pass (imf12.hostedemail.com: domain of 30o3qaQgKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30o3qaQgKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979412; a=rsa-sha256;
	cv=none;
	b=AYU6QBWTPjxlCzRjEXRq2MEBT74ALdRFlXJfVF8MX68EDm1tB32+ucibISW7XQvRMgjY3k
	7UrjMev+kkyiiiQrryoEIiU7437GixHxvdVFmdB9zpocwwA7EHZ5VEPFuuHtHJ8nN3N0MD
	LabVn83JjrkUKu5OT058qi7vAHvC7Zs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ByTOZ7il;
	spf=pass (imf12.hostedemail.com: domain of 30o3qaQgKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30o3qaQgKCO0SbPiaPRZVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZtY+EWHg3/BRWz3H3Wx+cRr9MZM3880uCt4Dp7O+PI=;
	b=pZBaEKC8Av9m//3M/Du4fj2F55bcjA2hEo1NEoIAa2IAAiSSPNMgKvxipX2awMvP2RFLvm
	nK66zote69+WzEgdiKTg9M+kkaH44uuxCf3voaI3LD8MjE7nJAzmQOzyoqqMa12arhaLnO
	LTXoLoviPJBaEaZDWfgEkuMdjSvL6Gg=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b2e06219cbso90189555ad.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979411; x=1777584211; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZtY+EWHg3/BRWz3H3Wx+cRr9MZM3880uCt4Dp7O+PI=;
        b=ByTOZ7ilgjotAYOlBDDe35+66ep/KJnqaxNsnuJ3u4RAWJz4Vwg/G3C3QI8nbCxHcS
         di+9h27WmjWt4Bx0d6+1OmSEz7QcblWQOaGRXJ5V4zktXUMjw/4Tl9UDaZfBAN/GqDz0
         Ri7/KA5GB0uqgfb6fuiMcoz7H+MGsG6poy0QLcGjv/JLMRtsMAJ75PD5099Umorr3thY
         BIE/uODQ+ylB5uEc/Jq9r/DpTOq0DTE8NU9W6/ydDN4zaQF5Yz0DmRFi5pYsQr/LgrJa
         0TYnJ5t34QYv0WQG/SDg27wzN7Q1GKfdDQVw8oACZbL6ulU0RJmemSt0brtO4xIBFoHe
         ilvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979411; x=1777584211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZtY+EWHg3/BRWz3H3Wx+cRr9MZM3880uCt4Dp7O+PI=;
        b=qIzuQMIMrxUlxYHoGlNnsKbxfL0iJ34a11mb7s2aRBZz8CNsuA5CJrL7J+tO+/ZOOS
         +dhKPIoUQxL8efqGoZmzJN41EUUmCBSlSQMI2Eh+wXeRoXKGXw40gYZb5ey5WJAZ55X6
         LqkJ15Ks7h4RXeCY62AUgR/yDSs6dVq5mjX59zs7gdBR9MvhUBzulTGpyL1RfZ+YOFgd
         1nrsHk4r2KifZkyDSYBzuDSM58pXttVPZo+u3bUFzatWtDmSHzVg1u8Fk2C8wCEyOz5v
         2dBx29gCsmmB0K11Pr15BNuHH0T6GfaT1E0vN9EE5NEslP80DWLSveZShXl2OEKrw+BT
         E0bQ==
X-Forwarded-Encrypted: i=1; AFNElJ8w1Rb14Gdc6utSg1IZs42bPKIRz/fCeV49HSK+KPun6c1EpXSdhEKYRTkHZ3CMbK7xNzCvHrWcrQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc1DqZ3T1vxG+GO9VcqASm8qKtSTllLA7ZKlrUSImEXn2zwfSS
	dDbzbwI13BT5eqIKnMBf/ffauMP+Za5Mt+35QyfKsZpO+k+Fy0ebQ5fFXijbdf6sfHUDPl7c1J+
	sPfGsuabG/+JP8Q==
X-Received: from pghu17.prod.google.com ([2002:a63:ef11:0:b0:c74:321:201a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3949:b0:39f:27ab:2438 with SMTP id adf61e73a8af0-3a08d90bdbamr33243244637.48.1776979410524;
 Thu, 23 Apr 2026 14:23:30 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:10 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-7-dmatlack@google.com>
Subject: [PATCH v4 06/11] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EED9F4000C
X-Stat-Signature: paw6g9kxcqfhzq3aouy51xub9oeueuez
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776979411-472087
X-HE-Meta: U2FsdGVkX1+972k4vxvWO5WNAi44QK8u6Q29QZBTXSB30GsfFOsB4QGeFD+vOvuGCZ2q7w2Zo1tdDts2kUUnHOtdpTeV0YEumTtWlD6/Xv4hGc2guma2G4Hc1v5koO5cW0PUZcErNc3oiKV4d4/JwNuXCdYbGp2DEj4R4kUyiApmGxOvHVuLa6cAXVmIWe3fTJETbY9kQIlTWGrkaDc280+MT0XLpxHyhTaC0UxaNAjU6aajBMj741Kg5Wqu3Ez2IKap3EvFf1QI6xogTaCtQvKmeuWJqJvjN6+ZLCnEKxCh8SFKQamesVOaxA0+LECfeOxtqTZC6oSpHOxMNNqhxzrdnVvTTNmn+ZicVdqMWsHuPc7u8rBpICyKpKP1fe071Br7Z2ZNwgPCcFkjGo8g6YlCfoEwggFNMBVnRPZl8HJBW1lX99cOJW/ov7XFssOQFSFid5+qOLRhrnI5tarYfwQ+WzUebQKdTJRfqasnQLhUNfTT9TAcws3OvbHi4FKBeBacSBCOi5TxIgkhlKMvpSj3GRftVxednvnAnCQcZz2n1ynJPnIP72lu62v0jE/oOyntTKqPSXbjzZuyxrjY+zemTj+Vx0uE1nrhs5sJdjgGeqBwVB/rxvxzBZHtddJB0KnqRbaI/k3XMkQ6ixvG/yNfd0+VmuRCQrJdxOXu17xK0+qdDzSXvoDWduUjMfn2u4ypt5HV00vy5UD9niZeOcFzMhTZzMlFuD7KQuUOcT63mIIn5uHiEKaqOILlzFys6miVqvFVJgV8/jYukvCLYnTwGy3viUvAEnWpGn0uULpy2Dj3XHk5DbUfP5WNa0tff5ugrxJu6n6MyFDbAs84shecvjBflu48xjlC3NFZlJLK12ShPgruvqRGrm+3McV9dbdJiRBKpFybNHNYrXxPoIhwjNLLVWyyPmRTHHMz6hVekUZiRQZ5L9O6CLLrzZxuCtoprLe2ZHRvtO/uncK
 8uGaL+ua
 xmMNi5KlGg8I0iF0YIab+ur8vp57gM+Yy3Jaq7Zbi5ZIgoFPwAjAiRCiFw/QedjyARNi0NU/oleHhmfCyTifIc0VeDq5eRheZI3UYfQ+idiGIN2s9K1mCZ0LER71NC1AH6TK6l0yZ4y51Z1aQI4vKjSkMW0auPep0YG/6S6ocggEIY7wi1gIrISXJgmERcmqbeqgoM9Z+AkpX4u1ZRqm+UrTMMMT3jAk/bG0a+GW16s99NjR3FyzVF229xz6Cy+vcqsiUKZcFljAWO1wLNm0s0s+ET2YvC6pIb+NhMb6UHJKOWMrokbek9Ko4k/47lmcgztkP4q3Chdj1G3Qu9fpoVzCKyZejri8oIkIl4Ol8SP12zJFyviLjbfUdXbfg6H2spc67/gg9eBKRMW0MurSoCbkFyej1iItiSLlMvNcagvq+iRQhGjSlqTjc4YMOB4QwSheiur5DqPu6bi9aw4NXfXfKwaD4SRN60BDxiwtNwhiUdyIEXmEFiOkdbdSb91uVYYe5kpnya4nQsBdeFG40JgqYhLZbiEWv5E7s9CIDRKKXBTLh6IouI6TGa6N2KAm1M8Sh5Ci9NqW2vm5hbFXcl/cYhoorkJXBviAoGrn7kDw4vR8N1dkz91BtiJA/wWJKny8379R0qh5AreHuA7eJAR3RuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a PCI device is preserved across a Live Update, all of its upstream
bridges up to the root port must also be preserved. This enables the PCI
core and any drivers bound to the bridges to manage bridges correctly
across a Live Update.

Notably, this will be used in subsequent commits to ensure that
preserved devices can continue performing memory transactions without a
disruption or change in routing.

To preserve bridges, the PCI core tracks the number of downstream
devices preserved under each bridge using a reference count in struct
pci_dev_ser. This allows a bridge to remain preserved until all its
downstream preserved devices are unpreserved or finish their
participation in the Live Update.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 149 +++++++++++++++++++++++++++++----------
 1 file changed, 111 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index cf8cff134a75..88125f9a2c6b 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -106,6 +106,18 @@
  * If a misconfigured or unconfigured bridge is encountered during enumeration
  * while there are incoming preserved devices, it's secondary and subordinate
  * bus numbers will be cleared and devices below it will not be enumerated.
+ *
+ * PCI-to-PCI Bridges
+ * ==================
+ *
+ * Any PCI-to-PCI bridges upstream of a preserved device are automatically
+ * preserved when the device is preserved. The PCI core keeps track of the
+ * number of downstream devices that are preserved under a bridge so that the
+ * bridge is only unpreserved once all downstream devices are unpreserved.
+ *
+ * This enables the PCI core and any drivers bound to the bridge to participate
+ * in the Live Update so that preserved endpoints can continue issuing memory
+ * transactions during the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -233,25 +245,14 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
-int pci_liveupdate_preserve(struct pci_dev *dev)
+static int pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev *dev)
 {
-	struct pci_ser *ser;
-	int i, ret;
-
-	guard(mutex)(&pci_flb_outgoing_lock);
-
-	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
-	if (ret)
-		return ret;
+	int i;
 
-	if (!ser)
-		return -ENOENT;
-
-	if (dev->is_virtfn)
-		return -EINVAL;
-
-	if (dev->liveupdate_outgoing)
-		return -EBUSY;
+	if (dev->liveupdate_outgoing) {
+		dev->liveupdate_outgoing->refcount++;
+		return 0;
+	}
 
 	if (ser->nr_devices == ser->max_nr_devices)
 		return -ENOSPC;
@@ -281,11 +282,82 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 
 	return -ENOSPC;
 }
+
+static void pci_liveupdate_unpreserve_path(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev *upstream_bridge = dev->bus->self;
+	struct pci_dev_ser *dev_ser;
+
+	if (upstream_bridge)
+		pci_liveupdate_unpreserve_path(ser, upstream_bridge);
+
+	dev_ser = dev->liveupdate_outgoing;
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
+		return;
+	}
+
+	if (--dev_ser->refcount == 0) {
+		pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+		ser->nr_devices--;
+		memset(dev_ser, 0, sizeof(*dev_ser));
+		dev->liveupdate_outgoing = NULL;
+	}
+}
+
+static int pci_liveupdate_preserve_path(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev *upstream_bridge = dev->bus->self;
+	int ret = 0;
+
+	if (upstream_bridge) {
+		ret = pci_liveupdate_preserve_path(ser, upstream_bridge);
+		if (ret)
+			return ret;
+	} else if (!pci_is_root_bus(dev->bus)) {
+		pci_err(dev, "Failed to preserve up to root port\n");
+		return -EINVAL;
+	}
+
+	ret = pci_liveupdate_preserve_device(ser, dev);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	if (upstream_bridge)
+		pci_liveupdate_unpreserve_path(ser, upstream_bridge);
+
+	return ret;
+}
+
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ret;
+
+	if (!ser)
+		return -ENOENT;
+
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	if (dev->liveupdate_outgoing)
+		return -EBUSY;
+
+	return pci_liveupdate_preserve_path(ser, dev);
+}
 EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
 
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
-	struct pci_dev_ser *dev_ser;
 	struct pci_ser *ser = NULL;
 	int ret;
 
@@ -296,19 +368,9 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 	if (ret || !ser) {
 		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
 		return;
-
-	}
-
-	dev_ser = dev->liveupdate_outgoing;
-	if (!dev_ser) {
-		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
-		return;
 	}
 
-	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
-	ser->nr_devices--;
-	memset(dev_ser, 0, sizeof(*dev_ser));
-	dev->liveupdate_outgoing = NULL;
+	pci_liveupdate_unpreserve_path(ser, dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
@@ -428,6 +490,25 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_liveupdate_flb_put_incoming();
 }
 
+static void pci_liveupdate_finish_path(struct pci_dev *dev)
+{
+	struct pci_dev *upstream_bridge = dev->bus->self;
+
+	if (upstream_bridge)
+		pci_liveupdate_finish_path(upstream_bridge);
+
+	/*
+	 * Decrement the refcount so this device does not get treated as an
+	 * incoming device again, e.g. in case pci_liveupdate_setup_device()
+	 * gets called again becase the device is hot-plugged.
+	 */
+	if (--dev->liveupdate_incoming->refcount)
+		return;
+
+	pci_info(dev, "Device is finished participating in Live Update\n");
+	dev->liveupdate_incoming = NULL;
+}
+
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
 	if (!dev->liveupdate_incoming) {
@@ -435,15 +516,7 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
-	pci_info(dev, "Device is finished participating in Live Update\n");
-
-	/*
-	 * Drop the refcount so this device does not get treated as an incoming
-	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
-	 * again becase the device is hot-plugged.
-	 */
-	dev->liveupdate_incoming->refcount = 0;
-	dev->liveupdate_incoming = NULL;
+	pci_liveupdate_finish_path(dev);
 
 	/* Drop this device's reference on the incoming FLB. */
 	pci_liveupdate_flb_put_incoming();
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


