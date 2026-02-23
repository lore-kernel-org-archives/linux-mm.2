Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC6EEEC296
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9005C6B0088; Mon, 23 Feb 2026 17:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0406B0089; Mon, 23 Feb 2026 17:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABF96B008A; Mon, 23 Feb 2026 17:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E25E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:05:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9BBCB6EA0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:04:59 +0000 (UTC)
X-FDA: 84477102318.11.986B682
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B19E1C0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:04:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAu0elM9;
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771884298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHyrvIUwqGI/vsO/cw6CrNGSRQGELXRV70tcL/TCQBg=;
	b=FPHG/jPlryZJRPRQAwOsXwmLDPPu7L49xp8SeoRMytXhRvI4OPgFy+7MbEgoqePVqFrhNq
	BXyo8GEVjLpzevO5lyhCoZiIrzNM8EQjqqnX+zi+EJayr4Gb8h70xBTpjveb/6rELuaIbj
	CgDHGuDbMrOo/+LvSV+OthxArZBNbas=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAu0elM9;
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771884298; a=rsa-sha256;
	cv=none;
	b=MunueavyJoEI+Knif4UPPuwKnefoWL2EPLT2W5un+srrfteSv00cI6ac7rGACoXVIYrHU0
	w5q5B4VffdkdnBJihMgthJUB11aUMu2Zh34NBTmt3PO4m0e/jUiABEOQnvrbxZdPDIBkt9
	asiKvdlH6GWM4Ov0MY0Xn88SsxHVpQo=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a885af8ee7so6475ad.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771884297; x=1772489097; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHyrvIUwqGI/vsO/cw6CrNGSRQGELXRV70tcL/TCQBg=;
        b=RAu0elM9LsK2LU3ZAoBk/uiXqQ3nRsDChAH8u4/GgKc/Xjv4rdeQ0sZ5iNqf/UPuEF
         kOwBNG6nA+LMKzsCLxVPe49sr2u0C3YHC6FYM6emQ6Mk35OoGMqN5Z/OM626Yg02Abya
         oiYapZBkLtKCYOS/+9yNc041lFp5k4ZfDOzkTrHuJR+wHULyPWp/D7++kkFyFhWfLueY
         x0Uwg1uuqmCFnUmC2ynupBi3KUMerLosggOxDB7iHcBxCK0M5YoMvGc9y6J7Tm5TLh7B
         BUlwWhSAZZhWM0h9NIA4RQwwUvjASauB/n5gbXxl8aRKAazMllAq+RwFpvKxLWIY5C/E
         bJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771884297; x=1772489097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHyrvIUwqGI/vsO/cw6CrNGSRQGELXRV70tcL/TCQBg=;
        b=kRckH1qUv8t/7iK5Ob5Z2qOYIlVRRBV8RnJzNDr5C+9MkuyIcRzaK+WLQpclzs696C
         fL4bfuGz+ssh8wjUpEQwMm30bbXUDUqWTX0uzVL4r7mEGMGRfz9Tk/CEWFwhneW0/fga
         A+I4FcQu7GOCfbN/UFWdbl0o2JJKhGyB6e3Z2jtPcrp5z4S1+A5XyX94ERkSGR8Gw44b
         GSMlhyh1soroec0RVJTvBNZx9UatV2mpNBWSRljx/1XrrOguOWuvKCZZuuGUvJ9G9mlD
         da/2W0q30obdIVR6zRUy2pqss36c5c4ac8ITOHoC7+23ebzQ7M2zusF8oLP6lMqsNJbT
         4/TA==
X-Forwarded-Encrypted: i=1; AJvYcCVSoAhGLflNnkkycDPOb140OGewP6NkcwErGCKKPGeV9vklqFZ/9wqW09QRjMlhQXBzx3JUIm6j5Q==@kvack.org
X-Gm-Message-State: AOJu0Yy+vA+GlX8rCQ734KXg8JH7FxnhBfFpt76m/qiRkTdGPEMsSYZg
	pfgrApfYwipveP2tGD8rHJQqtPa8wmAuq/R1L7Llxm6uAbxv4ysheoiXjY/xHUrrXQ==
X-Gm-Gg: ATEYQzzi5ZILxV8S9ux1j+oAICCeSwUs0uhb9rmZfoRl0HQ9UdlPEfq82hKzN54jGgk
	GEH+7OWrD+up5nV1jIfPfBQngZgC1nyi3dhlx7r9PUAApBDMVbQPlHLB8dPrPSjwtYVS8bJPZzo
	RU7p8hLCYZf92dhCoIxGafSQ8eaaNsnRFB+UIORt0tyWO+soA6sDIgy0Khzu0lzoU9sSkCEVXgU
	9a7VqLlLSgEFP6DQR1jVWiFF6CEoDFbhP6MbV7XpVZyEJGJb7NyYiLU4zzNQYmk+SCnC35Mve1G
	8z6BM/otgUDSJomDpHdt3SbgSpOr8ksS3WH5NtRq/6YkjbrMUCSu+iHsqMpYFaYWEgKtN+NyyNN
	HproGBXYmXJnB5rOzdszDj2uTDks8eC2UZZ7StQgNQgf7J3NuqteMrBpfMtNZk64E+fhQ8NTDHa
	vqc9Ngldw6yTyodr54upqeO4h8FmVqu2lDI9gxn4d2VMh0BjvWPx5fyxDUcFWnEg==
X-Received: by 2002:a17:903:38d0:b0:290:8ecf:e9f9 with SMTP id d9443c01a7336-2ada346b6a8mr76155ad.7.1771884296114;
        Mon, 23 Feb 2026 14:04:56 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503fdc9sm87224705ad.80.2026.02.23.14.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:04:55 -0800 (PST)
Date: Mon, 23 Feb 2026 22:04:51 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-3-dmatlack@google.com>
X-Stat-Signature: y5dhck9tko5n5r8wkeuscidpsju4dans
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B19E1C0012
X-HE-Tag: 1771884297-69507
X-HE-Meta: U2FsdGVkX195vIwGKQGjnV62eDOE23EDBi9ZGPzqoKenK0lcy6mGedOOHSAx6e/S9vJFZMaUafLxRIeH9SZogoyDVz61nOxvyv6T720UEoXUIPrDK/kEiLywUx1/GMqAClYe5+ptz7pR9ufrQenLEY42I2DPursjCZKFv7ynqE6DV0CxhTTFXkWSbLvtXESBfaw7o34r3iTXTtB5XROqpfYqchxC2wekXfNBnowpI15xyeMTL93KhalhJsGchcplZW5ObugxeDcFPOcXA5yOsT8EafudBVxsXqd8n6QJOOHbwfjHUHbfjCS9ZvFmdPH+p/Om1aSL0HJc5IlbFyca94n4cqsTNbvDDOl7i3XajxnjrcSQyYMoFiGRyOcT5VPLO8e8FROtTdqh1lA1Tj+/fhSXNB6bum3XBOD/c4n96tIWTZXTIvWu7QeMqwiKRoxy/VUjF1aeS9bJUDN6rxY+zERlbB12GCWUh+rqeTCWxJGDbbRQNwVrdi4x9p0PEYsLxf7DiChJ/15hDulArObcwIqnDveIRgPQy8GSbBJi6UCo88Fl03jjsBwqlwtkmToCI6A04FJ370ZlSOcpwGFzx9CVCaUxK6k//MOtGR6Y4k+NfrHGGEvCZOH7Ie/o5lKfPQi20gFt4Os/+OJJFFc4VZB5Yk97+hxPpvjhAH7WNWCRiRXgmptsfWtNG2wwjN2RZrR+y71eLFdOlL0ugaG0S0KGgxS0Q6okqZmBvO9RLuvoLH1hwXHYbXV0QKwbSz/0gd2zZuiIAOS4JwWUq9N4hgcBi01v6hRzkhY11/BfR139miW6a5+4NpUm0Wjg65jiS98bCPXL4ZMAn4uHDYLYhAEr8sw91McsRL4TCe1xIzv6NDBtyhiFp2JN7zib0+7Dyh/yLqfXWWrc+dmFhDT/f1p5lyi8lG+1+Aj5Z0yHqFUbWowfERcXgEIWkMEuvm5DhzWD/U2DfM6qbHbGG/T
 8TVkSN84
 QRlkUYv7dNuv0hXwHeiTqD0r2VeKM7yt7lJpqXYMRSH0eCExvK6R8pzf+YxJ/jQdMiirkVDHyUp6xsqsDXeNjIrSeuF0pHidt2bfbxhl/qgwRxraNeH1SudCGZtWovTSDSaUGSdcC63SFTLVKaS9HvDYP/iNBW8JbDW18XOxUriWNswEnBn0cxEDv7804cLOPi/JXXELHWnEhGbRlFxnex6EmW/kei1CGiH/jDLSkcT5OpSJQkeWp29EVmARTljQx8DTR7ZwEM0HKEGuiUFX4TmEwidmPMAN6LiQ+k9h55KIWxqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
>Add an API to enable the PCI subsystem to track all devices that are
>preserved across a Live Update, including both incoming devices (passed
>from the previous kernel) and outgoing devices (passed to the next
>kernel).
>
>Use PCI segment number and BDF to keep track of devices across Live
>Update. This means the kernel must keep both identifiers constant across
>a Live Update for any preserved device. VFs are not supported for now,
>since that requires preserving SR-IOV state on the device to ensure the
>same number of VFs appear after kexec and with the same BDFs.
>
>Drivers that preserve devices across Live Update can now register their
>struct liveupdate_file_handler with the PCI subsystem so that the PCI
>subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
>to track the list of incoming and outgoing preserved devices.
>
>  pci_liveupdate_register_fh(driver_fh)
>  pci_liveupdate_unregister_fh(driver_fh)
>
>Drivers can notify the PCI subsystem whenever a device is preserved and
>unpreserved with the following APIs:
>
>  pci_liveupdate_outgoing_preserve(pci_dev)
>  pci_liveupdate_outgoing_unpreserve(pci_dev)

nit: Preserve and Unpreserve can only be done from outgoing kernel, maybe
remove the "outgoing" from the function name.
>
>After a Live Update, the PCI subsystem fetches its FLB global data
>from the previous kernel from the Live Update Orchestrator (LUO) during
>device initialization to determine which devices were preserved.
>
>Drivers can check if a device was preserved before userspace retrieves
>the file for it via pci_dev->liveupdate_incoming.
>
>Once a driver has finished restoring an incoming preserved device, it
>can notify the PCI subsystem with the following call, which clears
>pci_dev->liveupdate_incoming.
>
>  pci_liveupdate_incoming_finish(pci_dev)
>
>This API will be used in subsequent commits by the vfio-pci driver to
>preserve VFIO devices across Live Update and by the PCI subsystem.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/Makefile        |   1 +
> drivers/pci/liveupdate.c    | 212 ++++++++++++++++++++++++++++++++++++
> drivers/pci/probe.c         |   2 +
> include/linux/kho/abi/pci.h |  55 ++++++++++
> include/linux/pci.h         |  47 ++++++++
> 5 files changed, 317 insertions(+)
> create mode 100644 drivers/pci/liveupdate.c
> create mode 100644 include/linux/kho/abi/pci.h
>
>diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
>index 8c259a9a8796..a32f7658b9e5 100644
>--- a/drivers/pci/Makefile
>+++ b/drivers/pci/Makefile
>@@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
> obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
> obj-$(CONFIG_ACPI)		+= pci-acpi.o
> obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
>+obj-$(CONFIG_LIVEUPDATE)	+= liveupdate.o
> endif
>
> obj-$(CONFIG_OF)		+= of.o
>diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>new file mode 100644
>index 000000000000..182cfc793b80
>--- /dev/null
>+++ b/drivers/pci/liveupdate.c
>@@ -0,0 +1,212 @@
>+// SPDX-License-Identifier: GPL-2.0
>+
>+/*
>+ * Copyright (c) 2025, Google LLC.
>+ * David Matlack <dmatlack@google.com>
>+ */
>+
>+#include <linux/bsearch.h>
>+#include <linux/io.h>
>+#include <linux/kexec_handover.h>
>+#include <linux/kho/abi/pci.h>
>+#include <linux/liveupdate.h>
>+#include <linux/mutex.h>
>+#include <linux/mm.h>
>+#include <linux/pci.h>
>+#include <linux/sort.h>
>+
>+static DEFINE_MUTEX(pci_flb_outgoing_lock);
>+
>+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>+{
>+	struct pci_dev *dev = NULL;
>+	int max_nr_devices = 0;
>+	struct pci_ser *ser;
>+	unsigned long size;
>+
>+	for_each_pci_dev(dev)
>+		max_nr_devices++;

This will not work for SRIOV as new devices will be registered when
sriov is enabled and the max will increase. As we are not handling VFs
with this patch series, this can be fine?
>+
>+	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
>+
>+	ser = kho_alloc_preserve(size);
>+	if (IS_ERR(ser))
>+		return PTR_ERR(ser);
>+
>+	ser->max_nr_devices = max_nr_devices;
>+
>+	args->obj = ser;
>+	args->data = virt_to_phys(ser);
>+	return 0;
>+}
>+
>+static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
>+{
>+	struct pci_ser *ser = args->obj;
>+
>+	WARN_ON_ONCE(ser->nr_devices);
>+	kho_unpreserve_free(ser);
>+}
>+
>+static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
>+{
>+	args->obj = phys_to_virt(args->data);
>+	return 0;
>+}
>+
>+static void pci_flb_finish(struct liveupdate_flb_op_args *args)
>+{
>+	kho_restore_free(args->obj);
>+}
>+
>+static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
>+	.preserve = pci_flb_preserve,
>+	.unpreserve = pci_flb_unpreserve,
>+	.retrieve = pci_flb_retrieve,
>+	.finish = pci_flb_finish,
>+	.owner = THIS_MODULE,
>+};
>+
>+static struct liveupdate_flb pci_liveupdate_flb = {
>+	.ops = &pci_liveupdate_flb_ops,
>+	.compatible = PCI_LUO_FLB_COMPATIBLE,
>+};
>+
>+#define INIT_PCI_DEV_SER(_dev) {		\
>+	.domain = pci_domain_nr((_dev)->bus),	\
>+	.bdf = pci_dev_id(_dev),		\
>+}
>+
>+static int pci_dev_ser_cmp(const void *__a, const void *__b)
>+{
>+	const struct pci_dev_ser *a = __a, *b = __b;
>+
>+	return cmp_int(a->domain << 16 | a->bdf, b->domain << 16 | b->bdf);
>+}
>+
>+static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
>+					struct pci_dev *dev)
>+{
>+	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
>+
>+	return bsearch(&key, ser->devices, ser->nr_devices,
>+		       sizeof(key), pci_dev_ser_cmp);
>+}
>+
>+static int pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
>+{
>+	struct pci_dev_ser *dev_ser;
>+	int i;
>+
>+	dev_ser = pci_ser_find(ser, dev);
>+	if (!dev_ser)
>+		return -ENOENT;
>+
>+	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
>+		ser->devices[i] = ser->devices[i + 1];
>+
>+	ser->nr_devices--;
>+	return 0;
>+}
>+
>+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
>+{
>+	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
>+	struct pci_ser *ser;
>+	int i, ret;
>+
>+	/* Preserving VFs is not supported yet. */
>+	if (dev->is_virtfn)
>+		return -EINVAL;
>+
>+	guard(mutex)(&pci_flb_outgoing_lock);
>+
>+	if (dev->liveupdate_outgoing)
>+		return -EBUSY;
>+
>+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
>+	if (ret)
>+		return ret;
>+
>+	if (ser->nr_devices == ser->max_nr_devices)
>+		return -E2BIG;
>+
>+	for (i = ser->nr_devices; i > 0; i--) {
>+		struct pci_dev_ser *prev = &ser->devices[i - 1];
>+		int cmp = pci_dev_ser_cmp(&new, prev);
>+
>+		if (WARN_ON_ONCE(!cmp))
>+			return -EBUSY;
>+
>+		if (cmp > 0)
>+			break;
>+
>+		ser->devices[i] = *prev;
>+	}
>+
>+	ser->devices[i] = new;
>+	ser->nr_devices++;
>+	dev->liveupdate_outgoing = true;
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_preserve);
>+
>+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
>+{
>+	struct pci_ser *ser;
>+	int ret;
>+
>+	guard(mutex)(&pci_flb_outgoing_lock);
>+
>+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
>+	if (WARN_ON_ONCE(ret))
>+		return;
>+
>+	WARN_ON_ONCE(pci_ser_delete(ser, dev));
>+	dev->liveupdate_outgoing = false;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
>+
>+u32 pci_liveupdate_incoming_nr_devices(void)
>+{
>+	struct pci_ser *ser;
>+	int ret;
>+
>+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
>+	if (ret)
>+		return 0;
>+
>+	return ser->nr_devices;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);
>+
>+void pci_liveupdate_setup_device(struct pci_dev *dev)
>+{
>+	struct pci_ser *ser;
>+	int ret;
>+
>+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
>+	if (ret)
>+		return;
>+
>+	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);
>+
>+void pci_liveupdate_incoming_finish(struct pci_dev *dev)
>+{
>+	dev->liveupdate_incoming = false;
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_finish);
>+
>+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
>+{
>+	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_register_fh);
>+
>+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
>+{
>+	return liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
>+}
>+EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_fh);
>diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>index 37329095e5fe..af6356c5a156 100644
>--- a/drivers/pci/probe.c
>+++ b/drivers/pci/probe.c
>@@ -2060,6 +2060,8 @@ int pci_setup_device(struct pci_dev *dev)
> 	if (pci_early_dump)
> 		early_dump_pci_device(dev);
>
>+	pci_liveupdate_setup_device(dev);
>+
> 	/* Need to have dev->class ready */
> 	dev->cfg_size = pci_cfg_space_size(dev);
>
>diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
>new file mode 100644
>index 000000000000..6577767f8da6
>--- /dev/null
>+++ b/include/linux/kho/abi/pci.h
>@@ -0,0 +1,55 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+
>+/*
>+ * Copyright (c) 2025, Google LLC.
>+ * David Matlack <dmatlack@google.com>
>+ */
>+
>+#ifndef _LINUX_KHO_ABI_PCI_H
>+#define _LINUX_KHO_ABI_PCI_H
>+
>+#include <linux/compiler.h>
>+#include <linux/types.h>
>+
>+/**
>+ * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
>+ *
>+ * This header defines the ABI for preserving core PCI state across kexec using
>+ * Live Update File-Lifecycle Bound (FLB) data.
>+ *
>+ * This interface is a contract. Any modification to any of the serialization
>+ * structs defined here constitutes a breaking change. Such changes require
>+ * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
>+ */
>+
>+#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
>+
>+/**
>+ * struct pci_dev_ser - Serialized state about a single PCI device.
>+ *
>+ * @domain: The device's PCI domain number (segment).
>+ * @bdf: The device's PCI bus, device, and function number.
>+ */
>+struct pci_dev_ser {
>+	u16 domain;
>+	u16 bdf;
>+} __packed;
>+
>+/**
>+ * struct pci_ser - PCI Subsystem Live Update State
>+ *
>+ * This struct tracks state about all devices that are being preserved across
>+ * a Live Update for the next kernel.
>+ *
>+ * @max_nr_devices: The length of the devices[] flexible array.
>+ * @nr_devices: The number of devices that were preserved.
>+ * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
>+ *           to be sorted ascending by domain and bdf.
>+ */
>+struct pci_ser {
>+	u64 max_nr_devices;
>+	u64 nr_devices;
>+	struct pci_dev_ser devices[];
>+} __packed;
>+
>+#endif /* _LINUX_KHO_ABI_PCI_H */
>diff --git a/include/linux/pci.h b/include/linux/pci.h
>index 7e36936bb37a..9ead6d84aef6 100644
>--- a/include/linux/pci.h
>+++ b/include/linux/pci.h
>@@ -40,6 +40,7 @@
> #include <linux/resource_ext.h>
> #include <linux/msi_api.h>
> #include <uapi/linux/pci.h>
>+#include <linux/liveupdate.h>
>
> #include <linux/pci_ids.h>
>
>@@ -582,6 +583,10 @@ struct pci_dev {
> 	u8		tph_mode;	/* TPH mode */
> 	u8		tph_req_type;	/* TPH requester type */
> #endif
>+#ifdef CONFIG_LIVEUPDATE
>+	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
>+	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
>+#endif
> };
>
> static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>@@ -2854,4 +2859,46 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
> 	WARN_ONCE(condition, "%s %s: " fmt, \
> 		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
>
>+#ifdef CONFIG_LIVEUPDATE
>+int pci_liveupdate_outgoing_preserve(struct pci_dev *dev);
>+void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev);
>+void pci_liveupdate_setup_device(struct pci_dev *dev);
>+u32 pci_liveupdate_incoming_nr_devices(void);
>+void pci_liveupdate_incoming_finish(struct pci_dev *dev);
>+int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh);
>+int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh);
>+#else /* !CONFIG_LIVEUPDATE */
>+static inline int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
>+{
>+	return -EOPNOTSUPP;
>+}
>+
>+static inline void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
>+{
>+}
>+
>+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>+{
>+}
>+
>+static inline u32 pci_liveupdate_incoming_nr_devices(void)
>+{
>+	return 0;
>+}
>+
>+static inline void pci_liveupdate_incoming_finish(struct pci_dev *dev)
>+{
>+}
>+
>+static inline int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
>+{
>+	return -EOPNOTSUPP;
>+}
>+
>+static inline int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
>+{
>+	return -EOPNOTSUPP;
>+}
>+#endif /* !CONFIG_LIVEUPDATE */
>+
> #endif /* LINUX_PCI_H */
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

