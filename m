Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D7BD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1A66B0096; Thu, 29 Jan 2026 16:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EF66B0098; Thu, 29 Jan 2026 16:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13BD6B0099; Thu, 29 Jan 2026 16:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A24AE6B0096
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B7991402BD
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:50 +0000 (UTC)
X-FDA: 84386283660.05.1A88655
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id A574BC000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2AGd79H;
	spf=pass (imf22.hostedemail.com: domain of 3W9B7aQgKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3W9B7aQgKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvBnrq4VVaLn6O5AYPXHhriXtNBsa9110uSNH/MSfDg=;
	b=KL7y8QNDvKV9rRmIMxATM6E29oGgI8yEuOXgvGNW5oyJB3gUQRxNKyv6/aP0rxvr1d3Ufc
	9mKek14wo2PfAuMK6EeyKLsCgdikEXtyUlUjncgzu25/ovK/ATfwtf9FI0c6IkzuFX/Sf4
	tikL62R3ep3ps4qBgnpUKet7sgXitNQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2AGd79H;
	spf=pass (imf22.hostedemail.com: domain of 3W9B7aQgKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3W9B7aQgKCD4irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721948; a=rsa-sha256;
	cv=none;
	b=MtqAZKbtB3vCauJ9gYxtSp74hmkh5d6UKMYTecIJIF4ajzGxAJk0rRxOV3Qz0o0Cr7HsOD
	mJGVEabciPjNdWlN7VwEYxuj8srqtCIuaOKzxSDW/4I+4dBfqB0sZHc+2CyIUDv78TgeQN
	cWdCeoBXCaut3p5wyDk0zaUOeYpZ6UI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352e214cce9so1146539a91.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721947; x=1770326747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvBnrq4VVaLn6O5AYPXHhriXtNBsa9110uSNH/MSfDg=;
        b=I2AGd79HyLouQrqGv0dJS7Dg6CMJhDFqU1XpT6xRlpmOMU/0C/qgz+wRwFGoCpmWS+
         Yz9gw+ChILURGmYHfiuBslYYAvYoMCPYtxvUtWXPxEuMNq/993HdyCAMyoS501Ds9ej/
         7TEd2mscF5vxtNEu7w79iEFNQeEki2fEPIgr0Ll1QBFgjfh8rW1w4cTuYPCcYhJ87Z99
         AS/sN5KG5wMW2ldCDT4veDhrjPTygouIk2/9lYIYukTaPT7ZdUecWyufGyItlGos8bMw
         zkE46J0pY8SpLLyELdPPGDB00KAZNzFz/pAWiPWM81U06gRNDYnGK1d526ZqziuBg74S
         cjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721947; x=1770326747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvBnrq4VVaLn6O5AYPXHhriXtNBsa9110uSNH/MSfDg=;
        b=DAbKGMp2DoTEo3Mgr2XK+yyQcfB7UDty1v2dHbjTLBSD/N5uQDLzsSfCoiIpwVeHYn
         7L6IixqOiTSZG3MuL0jPwCfO87MsJ0rxbHbwcVsnNk97rfTcf5vtr4/t/YaWEiApdPx6
         RGuhIfScJvOXUmYUDSW10ftMIKDhdimmzBM52pc8WvBuICtl4l+UeN/wuMz5w/bAW3fz
         n2603pSToiHDpHZ94Ju8UDypatEktMMq/115hzVrMeNjK85L9cTQ91+3776Alxmx3+Ye
         aE/YAx8Kw/YDunPE/vcDB90Kv0Ypwd0VD3eke2hI2Th6Jbvb/S4lFPSTnK2d0Nnh4RZ5
         anZg==
X-Forwarded-Encrypted: i=1; AJvYcCVDCy2LBQxZSxshuYDJSoLFCIvDuWgctD8qxDlWxhaeqVwEiLVfE4EAznot7D2FDaqEYLFo12YfBg==@kvack.org
X-Gm-Message-State: AOJu0YxlFaz1SrayenwLuM130sE3ZL19V1LZ5Y9I9QTQrouskf3Q556I
	mlBkweId0HaGBdmOO4Vz/eFmGJi/P4tb9RBHtG1UHk9WsxzBrBNo6s1glV2kydrId+dvhVrE8Vk
	U517B46Id74ceCg==
X-Received: from pjbcp23.prod.google.com ([2002:a17:90a:fb97:b0:352:e9d7:ffd2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d4d:b0:34c:9cec:dd83 with SMTP id 98e67ed59e1d1-3543b3d6641mr750618a91.27.1769721947474;
 Thu, 29 Jan 2026 13:25:47 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:53 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-7-dmatlack@google.com>
Subject: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after Live Update
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A574BC000E
X-Stat-Signature: 3iih51egsa9xckhcnn9r6f34duxnd71j
X-Rspam-User: 
X-HE-Tag: 1769721948-887565
X-HE-Meta: U2FsdGVkX1+c4AePzmwSErHuzKFzEjLrkadHdosI3VYgM1B64JQp/9VqfNHGGj78WDU4cssxhUpgkTYmCrOvuNimX14v2l09YXu9rX1bVvN5Gy3QbFwyTUpF4kQ3zmtvvyuI52VlmKukYBaYrWSN5tpbSxRrZPugrPP6SBiecCUhQNxIdesJ8cTEGzDKxxa7M0I5244nLydRzXc51J6X4sQR4HkIOKMZe6QnQ2aFff4OF05FlAm7PMu1WOnk4GqZj1g4CSd/63bAdAyf3uaZeUVuVpz8lT+tLpyAvcpblm3KeSImD8oT21IJu6Yt1VMhT/hc5Z+I0LgMQhz02U2With6htpu9qGK0ZFaFXrk702cHHGm+k9XUvNoa+uxrmUi97Yq0UxoTRgU2u2Sjgk5CH4/3BnuPtgLil2P5dRAq1M8IEosv3thxDzxsobo7hrvsLrMJFa4/ckASRYjwf2fSiNIBg0Jefc5lz/AnDL0c6C5tod1qGvbWMH6fJINIj1r9YQGrNNGW/sXXSsj8uZvNuXPDc030t+GGI/MLYQsv3JXbwkGojC1qHi487coSiH8ILqn7MJMs9wpFT+srYsn/BeKP/zz+3xQMSvl37IMUaufEnJParPILodLGxx+irWfzBQvL/kL3DqrpUXDXtRqrGdcn1OyuCMh7gialH6MQ5Z68V/QAGoYZHdC5tj4VNmSYhFxmkDZvX7vteE2cAryEKz3Qa/EkPPceB2o9PoEsmyb3ZwAAgXDLLrSI8Gn22O9fvtBjugguuluugoLfvgPnTKIxd0gbIj/h8wZILwxeozTSX27dcRLHLjBSG/T/lvvLQe2yIOSiAMMGtaS3+ScC79M8UBWlRM/pSto7T486TK385BLdnDGTteuWtmiIJw83oX0MrY3L2G9eWi6LGpyd5xV65/2ghi8D/Cmw4byroHg2inkaLtHBKBbS8XxCO1xq7VDkIpC3xc4aEtBx9g
 UDjok9Bw
 gKMJt1/GZ+BEPoj2mCK9N2I5OpNyIncciCSwWoW59LH3VjGyQCzUcbJWwCCr1kDmKF4E4H2SwZLotkwv+TXXxAh9WpJ819GgoFd0NaCn/Fe8WoNatyNc7/b/G4Eda25BmzVQ/xaJORglTiN/ipDWD1PHHS9ThkvJkB3nY7JPstkkOzl+Afpb2K1WHuRtefe2qOO/CyXGtFGmfhYm/rIbBOCHIv9LkKZqzhBnZ4FkRH6/x/u+7DajuU14xLrXd3c29h+Bnj/AiW+duf3imggjapKJPTqOFEnD7jOObigmY0L/QpN1zVl6cefwL954p2cG7Vmu1bMkWXWmz1Zrl0+BUG7tx0LjNzqarX1AJU6mSDiG4iiqtjXk6MkwJG0Pv8yslelsBXhjYAK6MYcz3XN8EFLnUuo3MucNzueC9CHAWZ+0ad8377T/7UzowwRvdXnsw1Ec7i34b4Z0t8WoIPk4HYrPhO/FpMTQideYHLSMLVLxK5LIcb5SZTHtIOZuNCHF63ryQZ20Jkiy2Pdj+4GEtQffKdG0t96PeLKqiW/gOjJmNBOS4ogtOU4ZmIvEIKf7At5MzwSZScEtzcYE0G+VB8wgAPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Enable userspace to retrieve preserved VFIO device files from VFIO after
a Live Update by implementing the retrieve() and finish() file handler
callbacks.

Use an anonymous inode when creating the file, since the retrieved
device file is not opened through any particular cdev inode, and the
cdev inode does not matter in practice.

For now the retrieved file is functionally equivalent a opening the
corresponding VFIO cdev file. Subsequent commits will leverage the
preserved state associated with the retrieved file to preserve bits of
the device across Live Update.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/device_cdev.c             | 21 ++++++---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
 drivers/vfio/vfio_main.c               | 13 ++++++
 include/linux/vfio.h                   | 12 ++++++
 4 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 8ceca24ac136..935f84a35875 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-/*
- * device access via the fd opened by this function is blocked until
- * .open_device() is called successfully during BIND_IOMMUFD.
- */
-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
 {
-	struct vfio_device *device = container_of(inode->i_cdev,
-						  struct vfio_device, cdev);
 	struct vfio_device_file *df;
 	int ret;
 
@@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	vfio_device_put_registration(device);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
+
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+
+	return __vfio_device_fops_cdev_open(device, filep);
+}
 
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index f01de98f1b75..7f4117181fd0 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -8,6 +8,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
@@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
 	return ret;
 }
 
+static int match_device(struct device *dev, const void *arg)
+{
+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
+	const struct vfio_pci_core_device_ser *ser = arg;
+	struct pci_dev *pdev;
+
+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
+	if (!pdev)
+		return false;
+
+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_device *device;
+	struct file *file;
+	int ret;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	device = vfio_find_device(ser, match_device);
+	if (!device)
+		return -ENODEV;
+
+	/*
+	 * Simulate opening the character device using an anonymous inode. The
+	 * returned file has the same properties as a cdev file (e.g. operations
+	 * are blocked until BIND_IOMMUFD is called).
+	 */
+	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
+					&vfio_device_fops, NULL,
+					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out;
+	}
+
+	ret = __vfio_device_fops_cdev_open(device, file);
+	if (ret) {
+		fput(file);
+		goto out;
+	}
+
+	args->file = file;
+
+out:
+	/* Drop the reference from vfio_find_device() */
+	put_device(&device->device);
+
+	return ret;
+}
+
+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
+{
+	return args->retrieved;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
 static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
@@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
 	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
+	.can_finish = vfio_pci_liveupdate_can_finish,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
 };
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 276f615f0c28..89c5feef75d5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -13,6 +13,7 @@
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
+#include <linux/device/class.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
@@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
+{
+	struct device *device;
+
+	device = class_find_device(vfio.device_class, NULL, data, match);
+	if (!device)
+		return NULL;
+
+	return container_of(device, struct vfio_device, device);
+}
+EXPORT_SYMBOL_GPL(vfio_find_device);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 9aa1587fea19..dc592dc00f89 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
+#else
+static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
+					       struct file *filep)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
+
+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
+
 #endif /* VFIO_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog


