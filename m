Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA5CD73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DE26B0095; Thu, 29 Jan 2026 16:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942BC6B0096; Thu, 29 Jan 2026 16:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A546B0098; Thu, 29 Jan 2026 16:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 533B46B0095
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 014A4C1767
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:48 +0000 (UTC)
X-FDA: 84386283618.21.5EFF20F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id 287CC4000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PCBc8RVc;
	spf=pass (imf17.hostedemail.com: domain of 3WdB7aQgKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3WdB7aQgKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aO6tJGKcRtg/TIeiT23MNEgzxzjjKFBFfPz6SwCjTg=;
	b=GSYXg54pdrj9JGzj1DNn3yttjyGpzIrmWnz0zN5b6S/ePxMzn8YHeJ0LcUG+6e+V4SMtVW
	Ioi6VRYcpBAP4VXC2bmio9uM18A7Q2pVdlRHPtLJNrJ6olFpLo6qcwtEODSPF9iMS8uFuS
	VlEkgwK7Nv/GLqBB84phJGKVdKrGAU8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PCBc8RVc;
	spf=pass (imf17.hostedemail.com: domain of 3WdB7aQgKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3WdB7aQgKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721947; a=rsa-sha256;
	cv=none;
	b=ODmWr7gPgmXGO493uqRoiOTxmNJC+xfITG0DKkCJphReXMTuxpEi6WEZoifEZjUncObEV+
	jlz70+JhZ5LccFafuVaMcmVcef7A6OZmu2jJKw/H0m1zdfUeEbUBGOLc6bL7iGTTYSgxvv
	sAs4I0Krhba+ZnffO4JASBP7dQnM2xM=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a76f2d7744so12727335ad.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721946; x=1770326746; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+aO6tJGKcRtg/TIeiT23MNEgzxzjjKFBFfPz6SwCjTg=;
        b=PCBc8RVccMwCH1AWHhOOlNS2iREFdKfJDq37CQHGFmDOGE5A2lvy+GHvgLLlHJLbOg
         1V8duw1Dvq+AIOhd1Nn8H0n7dnOpNZ8HClyfGNIflwz3x4yq5RaiUpsIGBQQCr3gO1a7
         79dIuRuNQHD3/6ctd7dzCnetz55xyQxD9hB4Wuc1ukq2YjpHVoCRLyvJk9aal0HCUWyz
         +n6/c6dCO1jQcagVlMmY5Mh4w1mrlHp737CpVMlMlctbYGOr/ygvcl/tmCRIsKtAfNee
         5SNlz0wombD+GTduKfCcgL8Ujj4uU/PQ89UdfZYMmADcrUiZxFkaaSwkGXWFs4yf+aGw
         eohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721946; x=1770326746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+aO6tJGKcRtg/TIeiT23MNEgzxzjjKFBFfPz6SwCjTg=;
        b=CHM/1ACtREAsMfkRO+3vWbFlz1XRez8ieoJ8SWL0lSsjcOWkeydjvENZXoRm0JfFpe
         RpYFFWRqnlMJbqw3x5rZMw5DywciICeefnZ2lEOpDS/jHxoLQS2sW5Gy2sPr2YLUWD+u
         w0avTeLvLcWhKTar6j3Ml+zZQlQfqyvBI2XFnSMXq3eHhRwEyKv614xSGkTIdG9/GD8s
         IhIQBr/djsfCwVMZioSiOKxbDMn4nz7j6+oYk8hGC/8KtiIvUlVfKqf4fApiMLsxkURT
         w7lyXPjQN29R3pwFpZOcOYpxwC/nlFgAXlIeC8stMc0yaSAvPbSjgYciE9ZBtuBJoXAa
         6Dkw==
X-Forwarded-Encrypted: i=1; AJvYcCUmRQxpzJAWWw2jC5cophiMM2z4E76RWthwqY4KRokoxiK/cmamRaG+cgiSWLRJ5Wo9/vshc6TTJw==@kvack.org
X-Gm-Message-State: AOJu0YxIPGSP1by7bt/7Qf1Blg/R8Yu+IEJrtZ5TVVpI1Mu2tjMqQR0n
	QJpZjP5kFEUqxzd3PpiPLHER4ZLBrWBPsEPXdRFBj7J1yTPaG1snDHCKUd0cB7f8WZFBOI4eaNG
	PDrPJpb06o/e9Gw==
X-Received: from plrf4.prod.google.com ([2002:a17:902:ab84:b0:29d:5afa:2de])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c952:b0:295:3584:1bbd with SMTP id d9443c01a7336-2a8d8176d76mr6975245ad.41.1769721945885;
 Thu, 29 Jan 2026 13:25:45 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:52 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-6-dmatlack@google.com>
Subject: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across Live Update
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 287CC4000D
X-Stat-Signature: 8puo9y6x83915bc16ykr5gopmuijbzpk
X-Rspam-User: 
X-HE-Tag: 1769721946-988438
X-HE-Meta: U2FsdGVkX19TsHf/gBlY+aSvlPwdJ2g0nuyPyRVBUlxLIx4DTcMNlIZOqmEz21LmIlAYi6m1G4ftfWwDuqZoz4oNTVbFkbV0cBmMf1BVivdy2HjdY9khlK18+JSdGSW+8XE4gzLVPq3BC97oguDhburRsSlfKCLckQhs0lERR8mixAgqp8kd3H1lbO5Z4lP7BvlUYRUOT4QWyNm9sGLYPkSEh384A471e2JxRCapMg4nxpMq9pr//Oy0XYT9RjSoVv7Xkutfb/86S60nzTE7Lqr0uEbWplTi5l4VbzYK6YuqgTZLtB1PPPxQxiR/HYVC0KzirzcFJ2nunF6yXbzjmrzNlydxchmGNeYDHdMCqGwQtZLWL0ENvetu8VhJZ+BG+Ii0rgEmaTt92uaHn/u4PU+j9h/0IVB5zM1W6yPfHlg577iSSIoyPfQFPEUmARnbAWhv6hFdp7DIBtskg2rSjmp/SF2zNq3ZgUvsQ2ioqvuuBGjTKZ+pXmF0lBB2Mes40dCc4Liw8ZwTFiGTwmusuEw2Wd9icXZXG8PsC2KSUaoB7CEQSwbn8LmwWUepp2hz+JgeEOZ8fbmZ335HHBC6fm4nRgjuJSwXLSDxUgTZIGmGVv8bfzp4ZhQSJadWse5GOJ5XImF8SMuHl1tYLpTv5Kam7rTvaKGmk790zjFZwDrFf6z9YJJc7xwGlWTFMVtGvIhnmhRuhpyJWaZ6JCqWzeWraNuYzGwSmUD5RfuTUMTtn2J0gE9g7HrZAiCXpSAbhvokY4E5juBy6sOLMtMgkUL9MTzNv7AIicBWqSyU2wjYR1EyvBht0442WgXGbqycSIBTCJIw6RHxg4U5JyjOz1lsvnb2O9nc6DzXT3LXmtVrSCjTndCmTV4ed0Gap4a9cmcBr1L/Pj2DJXhsrX67V6ljubKwdFrNCCoLhkDIHdz/8lAY0IPIL7RbBAGbfatkmThLU5msHwWKwT37gy4
 s2+CtIfi
 DJWJKHPlAjAs9P2+87Cis+B+Ub89W9b5sWxImnnFmi10yriZ8Jg3R8h4ICl4qz5g4IEwU13n3hvyBU4N9xfjHr3wfPfdIsc3r/NsJUMtA68myRaCPdGW+08CL9dz8KzwX/H7tZmZOQwZXQrzyu/0Hu3dMtW3r/x2+URswpUO4wovFuMc43atBiynVFNxGKn/K3kUtNAKBc3EbJmJ/LXfjBi2SVvnCcYFChTVtUCHrwzoY4iPJl4ypY9rUfJ2XzmB81TUGz0qwNXD5ls15IKM5XQDoBtyP+OPVm5L/FQX6NpF5uaRHxLRP2hUvLcNs27zs92O+EKo/NISkFoZoMO/6blNxoRwq52TBVacrw0whnZgr20UXp22r59SYBIbV+dPdesjYbuI463ERcFeIAqS9zaQP5qD1mFhhD7uEB8X7jjNrKcgVWloxhZOaTAUxuCibB8jgPxpkmiEGuEC+Lb14CdhETevr+DlUo6PnowRFKg1vZlG9EKnKLUrbTiOYm+TWXAR4L0+myGdRbLQ+IibKeoIJSdAGwYWajU5f/rDw4+0FjvkeBjUlKrZnew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Implement the live update file handler callbacks to preserve a vfio-pci
device across a Live Update. Subsequent commits will enable userspace to
then retrieve this file after the Live Update.

Live Update support is scoped only to cdev files (i.e. not
VFIO_GROUP_GET_DEVICE_FD files).

State about each device is serialized into a new ABI struct
vfio_pci_core_device_ser. The contents of this struct are preserved
across the Live Update to the next kernel using a combination of
Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
Live Update Orchestrator (LUO) to preserve the physical address of the
struct.

For now the only contents of struct vfio_pci_core_device_ser the
device's PCI segment number and BDF, so that the device can be uniquely
identified after the Live Update.

Require that userspace disables interrupts on the device prior to
freeze() so that the device does not send any interrupts until new
interrupt handlers have been set up by the next kernel.

Reset the device and restore its state in the freeze() callback. This
ensures the device can be received by the next kernel in a consistent
state. Eventually this will be dropped and the device can be preserved
across in a running state, but that requires further work in VFIO and
the core PCI layer.

Note that LUO holds a reference to this file when it is preserved. So
VFIO is guaranteed that vfio_df_device_last_close() will not be called
on this device no matter what userspace does.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci.c            |  2 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 84 +++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_priv.h       |  2 +
 drivers/vfio/vfio.h                    | 13 ----
 drivers/vfio/vfio_main.c               | 10 +--
 include/linux/kho/abi/vfio_pci.h       | 15 +++++
 include/linux/vfio.h                   | 28 +++++++++
 7 files changed, 129 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 19e88322af2c..0260afb9492d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	return 0;
 }
 
-static const struct vfio_device_ops vfio_pci_ops = {
+const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
 	.init		= vfio_pci_core_init_dev,
 	.release	= vfio_pci_core_release_dev,
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index b84e63c0357b..f01de98f1b75 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -8,25 +8,104 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
 #include <linux/errno.h>
+#include <linux/vfio.h>
 
 #include "vfio_pci_priv.h"
 
 static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
 					     struct file *file)
 {
-	return false;
+	struct vfio_device_file *df = to_vfio_device_file(file);
+
+	if (!df)
+		return false;
+
+	/* Live Update support is limited to cdev files. */
+	if (df->group)
+		return false;
+
+	return df->device->ops == &vfio_pci_ops;
 }
 
 static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_device *device = vfio_device_from_file(args->file);
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+		return -EINVAL;
+
+	if (vfio_pci_is_intel_display(pdev))
+		return -EINVAL;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->bdf = pci_dev_id(pdev);
+	ser->domain = pci_domain_nr(pdev->bus);
+
+	args->serialized_data = virt_to_phys(ser);
+	return 0;
 }
 
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
+}
+
+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
+{
+	struct vfio_device *device = vfio_device_from_file(args->file);
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+	int ret;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	guard(mutex)(&device->dev_set->lock);
+
+	/*
+	 * Userspace must disable interrupts on the device prior to freeze so
+	 * that the device does not send any interrupts until new interrupt
+	 * handlers have been established by the next kernel.
+	 */
+	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
+		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
+		return -EINVAL;
+	}
+
+	pci_dev_lock(pdev);
+
+	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
+	if (ret)
+		goto out;
+
+	/*
+	 * Reset the device and restore it back to its original state before
+	 * handing it to the next kernel.
+	 *
+	 * Eventually both of these should be dropped and the device should be
+	 * kept running with its current state across the Live Update.
+	 */
+	if (vdev->reset_works)
+		ret = __pci_reset_function_locked(pdev);
+
+	pci_restore_state(pdev);
+
+out:
+	pci_dev_unlock(pdev);
+	return ret;
 }
 
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
@@ -42,6 +121,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.preserve = vfio_pci_liveupdate_preserve,
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
+	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 68966ec64e51..d3da79b7b03c 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -11,6 +11,8 @@
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
+extern const struct vfio_device_ops vfio_pci_ops;
+
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
 	struct vfio_pci_core_device	*vdev;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..6b89edbbf174 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -16,17 +16,6 @@ struct iommufd_ctx;
 struct iommu_group;
 struct vfio_container;
 
-struct vfio_device_file {
-	struct vfio_device *device;
-	struct vfio_group *group;
-
-	u8 access_granted;
-	u32 devid; /* only valid when iommufd is valid */
-	spinlock_t kvm_ref_lock; /* protect kvm field */
-	struct kvm *kvm;
-	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
-};
-
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
 int vfio_df_open(struct vfio_device_file *df);
@@ -34,8 +23,6 @@ void vfio_df_close(struct vfio_device_file *df);
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
-extern const struct file_operations vfio_device_fops;
-
 #ifdef CONFIG_VFIO_NOIOMMU
 extern bool vfio_noiommu __read_mostly;
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f7df90c423b4..276f615f0c28 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1436,15 +1436,7 @@ const struct file_operations vfio_device_fops = {
 	.show_fdinfo	= vfio_device_show_fdinfo,
 #endif
 };
-
-static struct vfio_device *vfio_device_from_file(struct file *file)
-{
-	struct vfio_device_file *df = file->private_data;
-
-	if (file->f_op != &vfio_device_fops)
-		return NULL;
-	return df->device;
-}
+EXPORT_SYMBOL_GPL(vfio_device_fops);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index 37a845eed972..9bf58a2f3820 100644
--- a/include/linux/kho/abi/vfio_pci.h
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -9,6 +9,9 @@
 #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
 #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
 
+#include <linux/compiler.h>
+#include <linux/types.h>
+
 /**
  * DOC: VFIO PCI Live Update ABI
  *
@@ -25,4 +28,16 @@
 
 #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
 
+/**
+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
+ * device.
+ *
+ * @bdf: The device's PCI bus, device, and function number.
+ * @domain: The device's PCI domain number (segment).
+ */
+struct vfio_pci_core_device_ser {
+	u16 bdf;
+	u16 domain;
+} __packed;
+
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e90859956514..9aa1587fea19 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -81,6 +81,34 @@ struct vfio_device {
 #endif
 };
 
+struct vfio_device_file {
+	struct vfio_device *device;
+	struct vfio_group *group;
+
+	u8 access_granted;
+	u32 devid; /* only valid when iommufd is valid */
+	spinlock_t kvm_ref_lock; /* protect kvm field */
+	struct kvm *kvm;
+	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
+};
+
+extern const struct file_operations vfio_device_fops;
+
+static inline struct vfio_device_file *to_vfio_device_file(struct file *file)
+{
+	if (file->f_op != &vfio_device_fops)
+		return NULL;
+
+	return file->private_data;
+}
+
+static inline struct vfio_device *vfio_device_from_file(struct file *file)
+{
+	struct vfio_device_file *df = to_vfio_device_file(file);
+
+	return df ? df->device : NULL;
+}
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
-- 
2.53.0.rc1.225.gd81095ad13-goog


