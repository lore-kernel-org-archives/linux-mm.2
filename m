Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D869D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82996B008A; Thu, 29 Jan 2026 16:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19F16B008C; Thu, 29 Jan 2026 16:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30216B0092; Thu, 29 Jan 2026 16:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC646B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A1A6C1361
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:44 +0000 (UTC)
X-FDA: 84386283408.05.56B70CF
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 31CF440017
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R+06xpeL;
	spf=pass (imf11.hostedemail.com: domain of 3VNB7aQgKCDcWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VNB7aQgKCDcWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgSWc2a8f762WhttrAnnu8Gpn5PakSPoQMEwyGUxMj4=;
	b=TgicWtTN+ecsWujEgohnlhXjhrwIr6gi+DLsH7NSvaM8MKJ1rHAsDzphMOEq7u4zYFrF8j
	p2tjQLizMqdWR2SY4xGTwxy1gXMPFq9mjiwSUyheGA6XTl0ZVM/cv9AmHuA5zMCghOoMRZ
	qOiJRHvA3pSZyXnQKpalh7BSZ8m42bA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R+06xpeL;
	spf=pass (imf11.hostedemail.com: domain of 3VNB7aQgKCDcWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VNB7aQgKCDcWfTmeTVdZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721942; a=rsa-sha256;
	cv=none;
	b=uSm+oq4sRbtzHTxBviF0jOheBhHCYEdFKKe5Ct/VpiNlXk8zxX08/L88GHGTkrZMThUhAj
	ctWyfREdPd6EScSWxkw9sgn/4u+4WJvsm7DK6JneFgBIbwOmLXjcm1f/9fgu+bziBCmUHx
	t3L9Sc9xMb6pUeb32Lx6Ztw3copQx60=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso1508709a91.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721941; x=1770326741; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgSWc2a8f762WhttrAnnu8Gpn5PakSPoQMEwyGUxMj4=;
        b=R+06xpeLM2TPAJhwMQSaKfGo2EtA6q9rnpsYsbG9U7nM15QLSNWYcrutk9LeAvCG59
         /NFnmcOv9rGawF0jJjRpsQr8XF7cfuBSk+a2GXBswEJxrMecAP04nH3mpmXIn0K0/2IX
         R5dzmyNwUBxwT2Vwpf7c3106vr0BjoycQTpTRWEivEszU8jMdTyNqlutvdOEJJYvWA02
         PuQeyV93WaGGL9nfEANEef9WT3ECSnLk4pwd/7e667ifSptDTNqGbkn1Pg2QDF/ma4uh
         Ib6O2SW15dYX8jVfFiavz2VIlmqj0UlzUG1jZL11SFPRG68Y3J0tc3ohODegZDrMG2gG
         Us4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721941; x=1770326741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgSWc2a8f762WhttrAnnu8Gpn5PakSPoQMEwyGUxMj4=;
        b=ZWvvUEsVqo0CxV10VH25/rtSCkiUzclZfQyOftt+ZA0JSH4zM12+g/yfkZT541kYIW
         Szx5eJz4e86RPZZN4kfayXzksoh1gg26bTVX7PNSJN4ZRbIRaWxAHTRPsbwDOlP3Y2Ea
         /SijaB43rVH7Pff51LIP91Aifjoq0AwoqLZFv01fd9eFJQOQgepHA+qz4YKawtsqae37
         msxxRF1itu5ASkZ+cdIRBCRMhibYNAtby052mn47RxZEvRhebg67/KLPCZxYgf9FTnEt
         5ILnFdBuUnZncDtkdaIAPP+pwor+CpX/yV2vocausloMDBCw3cCdnIDFUnol/veVi+MP
         QKPw==
X-Forwarded-Encrypted: i=1; AJvYcCXqKGPv90rFGUXzvAMDWRj0I/fdqIuPf5eMkuGiFtiPRcsXlKXhSBxpi+9c78NB3omwpQkmWGsKgw==@kvack.org
X-Gm-Message-State: AOJu0YwENRzIkGm0FCXARuWcPTUu65S7q5iuvM1WFLuqrW+ocr3kgssp
	1KI/ZIP6mJgzb8Yas9Om4zUJ1tDGu0VyYThHS7XVWwuYt3xEq1zW2SaOSk99rduqy4MiJ/lAXrn
	wvxpiVEMs4tcGZA==
X-Received: from pjbha8.prod.google.com ([2002:a17:90a:f3c8:b0:34c:34ab:8fd9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a82:b0:34f:6312:f225 with SMTP id 98e67ed59e1d1-35429b0007emr3496453a91.14.1769721940932;
 Thu, 29 Jan 2026 13:25:40 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:49 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-3-dmatlack@google.com>
Subject: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved across
 Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tm56h6xyz38idd1zb3usmjptpaedmwr3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31CF440017
X-HE-Tag: 1769721941-247280
X-HE-Meta: U2FsdGVkX19tEXNepdKOv5075BF79HgqLEGUyA0PleRJBjzql/VBs9794zfIslAKjkUMSMX3IXkQO1HdBrLCLCpobMKeEqbrXxKE8YuYE4s9Z/tN1ED/z3VAsaKP013EOlCDOPi0+o5dUlymXTkQQdLV426GCJ4Yr96OW+eyAeTxJgjKOQlywLT4Z+ys2WikBGcS1GoAEFpxAXUsOhSKLCfKDdXvPKutDh6JZf+e3edCT6dLXEBs9n+/5N13nqCHGRcXR4KUQA6ZpvvdRI2ENYpQNXPVAPBfNqi8KNnOTHQ3Z/3w79ch+myQnQL7fnnWi6RXTpEBhD+zAztfuic25nUuC5qtXgSu6/irakO+wZr7skMvXylTZzKpxgKML1OT4EGsn1qQmNDBwwqKTTeuo0A2YPO5hVl5z2D5ajt/Gs10dLMPj6tM3f+n4xPpLcBlvuIBFRIUO/0884asZxDWZz/xVbe3lMxeixcvjT3T8j8CNpQnvP2SNvY77vdIyxuhMPXW20S29qtJbk9O8bteNiOimDzO0Q5/RxXwH5L4wAm4mG374QsReL/Gvooa+WvZpeUlL/ECNMlP+A63adXN7etTAsFQR+I1DoPfdxZv7xOSWOQ59gFmKioeV1gl8TXEcMAvr2gZX08ZywTaGFINY4ehPXbDyGPxmAIKwVWKZI3K3bhnuhCq5CUakZRj25SB9he1W4Vr+odf+zI1vkSscr/hinVeGx2ArOrnJ9QHLgO/+ymaTs/xArlHnuI9DxuYU9wvPYdT/lCvbms80aGVAZFb1YqH5fO3NqCWPv5NW+M9dJYRG6JrQ8S89aMUNqJtOQhhKzljwLVyukdS2jMeTLOLKsX9kvkhga6Bqm8g3igC+TSmiDS+GfNAY7rGzLCmgwmQ57YHb+3KxOsnccwimXsWQOx4iMKMI/sV3M/6i4HS99Cxux3zo1R1moDEPL7ySGm7jNPTPZmEjbUuYym
 5AxDzIh+
 DbUenue5Y9p5Kkmf9DqM57z1VE8yjO6ipOSA6hozRamZbEHxGUYeuvPXKMP4NxKtI3h5871dSHzuIY+heoRcLlTXFm6UDBXJ0ofgVfEeCqzGGlx01oBKlR/iEbWG+owNVujwj/NRdWOMGPv6gMAkvpDux1yDmcAYf0RnvRBCxN+a1TwwS1rgjhS/EUb1u5zPvoVnR53hiUXBwb38akH3fP1jP7BzKGleJiHAvEZBTQb7EdJwhskht/H29u60Ps0wc6EgVDl74e3D7FolEpRgWJ5f2pUY3+4v5j1GQLlzjU/6mewE10ZB6X2bGJ/k5anZP0JL5kP0Dcf4DXTN22I69gq8YVIkYx0GfKErJEjzsBbdUIGusp6S6S7bGu4K6sUW/elW8Jm4bckvRYYNJPVx9lFXT3XeHtIZswZRr/naeAitIUSCGT7XBeyWsV0VEFw5bCD/SsSehWv9wo5Hud+XUtwUD7J8WGZIoQNavl4vVHZsuy8lecrnGZM0g9IQPwgq0KKPOno9TS5RCcg8ky3+3I56IxhQ2Mixm4FU7o6jK/xMJ9KRdvVPKTthpcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API to enable the PCI subsystem to track all devices that are
preserved across a Live Update, including both incoming devices (passed
from the previous kernel) and outgoing devices (passed to the next
kernel).

Use PCI segment number and BDF to keep track of devices across Live
Update. This means the kernel must keep both identifiers constant across
a Live Update for any preserved device. VFs are not supported for now,
since that requires preserving SR-IOV state on the device to ensure the
same number of VFs appear after kexec and with the same BDFs.

Drivers that preserve devices across Live Update can now register their
struct liveupdate_file_handler with the PCI subsystem so that the PCI
subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
to track the list of incoming and outgoing preserved devices.

  pci_liveupdate_register_fh(driver_fh)
  pci_liveupdate_unregister_fh(driver_fh)

Drivers can notify the PCI subsystem whenever a device is preserved and
unpreserved with the following APIs:

  pci_liveupdate_outgoing_preserve(pci_dev)
  pci_liveupdate_outgoing_unpreserve(pci_dev)

After a Live Update, the PCI subsystem fetches its FLB global data
from the previous kernel from the Live Update Orchestrator (LUO) during
device initialization to determine which devices were preserved.

Drivers can check if a device was preserved before userspace retrieves
the file for it via pci_dev->liveupdate_incoming.

Once a driver has finished restoring an incoming preserved device, it
can notify the PCI subsystem with the following call, which clears
pci_dev->liveupdate_incoming.

  pci_liveupdate_incoming_finish(pci_dev)

This API will be used in subsequent commits by the vfio-pci driver to
preserve VFIO devices across Live Update and by the PCI subsystem.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/Makefile        |   1 +
 drivers/pci/liveupdate.c    | 212 ++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c         |   2 +
 include/linux/kho/abi/pci.h |  55 ++++++++++
 include/linux/pci.h         |  47 ++++++++
 5 files changed, 317 insertions(+)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 8c259a9a8796..a32f7658b9e5 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
 obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
 obj-$(CONFIG_ACPI)		+= pci-acpi.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
+obj-$(CONFIG_LIVEUPDATE)	+= liveupdate.o
 endif
 
 obj-$(CONFIG_OF)		+= of.o
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
new file mode 100644
index 000000000000..182cfc793b80
--- /dev/null
+++ b/drivers/pci/liveupdate.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+#include <linux/bsearch.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/pci.h>
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/sort.h>
+
+static DEFINE_MUTEX(pci_flb_outgoing_lock);
+
+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_dev *dev = NULL;
+	int max_nr_devices = 0;
+	struct pci_ser *ser;
+	unsigned long size;
+
+	for_each_pci_dev(dev)
+		max_nr_devices++;
+
+	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
+
+	ser = kho_alloc_preserve(size);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->max_nr_devices = max_nr_devices;
+
+	args->obj = ser;
+	args->data = virt_to_phys(ser);
+	return 0;
+}
+
+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	struct pci_ser *ser = args->obj;
+
+	WARN_ON_ONCE(ser->nr_devices);
+	kho_unpreserve_free(ser);
+}
+
+static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
+{
+	args->obj = phys_to_virt(args->data);
+	return 0;
+}
+
+static void pci_flb_finish(struct liveupdate_flb_op_args *args)
+{
+	kho_restore_free(args->obj);
+}
+
+static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
+	.preserve = pci_flb_preserve,
+	.unpreserve = pci_flb_unpreserve,
+	.retrieve = pci_flb_retrieve,
+	.finish = pci_flb_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_flb pci_liveupdate_flb = {
+	.ops = &pci_liveupdate_flb_ops,
+	.compatible = PCI_LUO_FLB_COMPATIBLE,
+};
+
+#define INIT_PCI_DEV_SER(_dev) {		\
+	.domain = pci_domain_nr((_dev)->bus),	\
+	.bdf = pci_dev_id(_dev),		\
+}
+
+static int pci_dev_ser_cmp(const void *__a, const void *__b)
+{
+	const struct pci_dev_ser *a = __a, *b = __b;
+
+	return cmp_int(a->domain << 16 | a->bdf, b->domain << 16 | b->bdf);
+}
+
+static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
+					struct pci_dev *dev)
+{
+	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
+
+	return bsearch(&key, ser->devices, ser->nr_devices,
+		       sizeof(key), pci_dev_ser_cmp);
+}
+
+static int pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+	int i;
+
+	dev_ser = pci_ser_find(ser, dev);
+	if (!dev_ser)
+		return -ENOENT;
+
+	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
+		ser->devices[i] = ser->devices[i + 1];
+
+	ser->nr_devices--;
+	return 0;
+}
+
+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
+{
+	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
+	struct pci_ser *ser;
+	int i, ret;
+
+	/* Preserving VFs is not supported yet. */
+	if (dev->is_virtfn)
+		return -EINVAL;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	if (dev->liveupdate_outgoing)
+		return -EBUSY;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return ret;
+
+	if (ser->nr_devices == ser->max_nr_devices)
+		return -E2BIG;
+
+	for (i = ser->nr_devices; i > 0; i--) {
+		struct pci_dev_ser *prev = &ser->devices[i - 1];
+		int cmp = pci_dev_ser_cmp(&new, prev);
+
+		if (WARN_ON_ONCE(!cmp))
+			return -EBUSY;
+
+		if (cmp > 0)
+			break;
+
+		ser->devices[i] = *prev;
+	}
+
+	ser->devices[i] = new;
+	ser->nr_devices++;
+	dev->liveupdate_outgoing = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_preserve);
+
+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	guard(mutex)(&pci_flb_outgoing_lock);
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	WARN_ON_ONCE(pci_ser_delete(ser, dev));
+	dev->liveupdate_outgoing = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
+
+u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return 0;
+
+	return ser->nr_devices;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_ser *ser;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
+	if (ret)
+		return;
+
+	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);
+
+void pci_liveupdate_incoming_finish(struct pci_dev *dev)
+{
+	dev->liveupdate_incoming = false;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_finish);
+
+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
+{
+	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_register_fh);
+
+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
+{
+	return liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_fh);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 37329095e5fe..af6356c5a156 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2060,6 +2060,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
new file mode 100644
index 000000000000..6577767f8da6
--- /dev/null
+++ b/include/linux/kho/abi/pci.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_PCI_H
+#define _LINUX_KHO_ABI_PCI_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
+ *
+ * This header defines the ABI for preserving core PCI state across kexec using
+ * Live Update File-Lifecycle Bound (FLB) data.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
+ */
+
+#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
+
+/**
+ * struct pci_dev_ser - Serialized state about a single PCI device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ */
+struct pci_dev_ser {
+	u16 domain;
+	u16 bdf;
+} __packed;
+
+/**
+ * struct pci_ser - PCI Subsystem Live Update State
+ *
+ * This struct tracks state about all devices that are being preserved across
+ * a Live Update for the next kernel.
+ *
+ * @max_nr_devices: The length of the devices[] flexible array.
+ * @nr_devices: The number of devices that were preserved.
+ * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
+ *           to be sorted ascending by domain and bdf.
+ */
+struct pci_ser {
+	u64 max_nr_devices;
+	u64 nr_devices;
+	struct pci_dev_ser devices[];
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7e36936bb37a..9ead6d84aef6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -40,6 +40,7 @@
 #include <linux/resource_ext.h>
 #include <linux/msi_api.h>
 #include <uapi/linux/pci.h>
+#include <linux/liveupdate.h>
 
 #include <linux/pci_ids.h>
 
@@ -582,6 +583,10 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_LIVEUPDATE
+	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
+	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
@@ -2854,4 +2859,46 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 	WARN_ONCE(condition, "%s %s: " fmt, \
 		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
 
+#ifdef CONFIG_LIVEUPDATE
+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev);
+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev);
+void pci_liveupdate_setup_device(struct pci_dev *dev);
+u32 pci_liveupdate_incoming_nr_devices(void);
+void pci_liveupdate_incoming_finish(struct pci_dev *dev);
+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh);
+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh);
+#else /* !CONFIG_LIVEUPDATE */
+static inline int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
+{
+}
+
+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+}
+
+static inline u32 pci_liveupdate_incoming_nr_devices(void)
+{
+	return 0;
+}
+
+static inline void pci_liveupdate_incoming_finish(struct pci_dev *dev)
+{
+}
+
+static inline int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* !CONFIG_LIVEUPDATE */
+
 #endif /* LINUX_PCI_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog


