Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0654D606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ox45Wigg
Received: by kanga.kvack.org (Postfix)
	id D31E96B05E9; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F9C6B05ED; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9FF6B05EB; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC556B05E9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3645B1A01EC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
X-FDA: 85406458914.22.838B6FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B14910000C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ox45Wigg;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011835;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wc3ZDddF/SoKim6dDvu+EZKuiq91csySlG+i1DCw1cw=;
	b=l4FA/ZoBEH9BMaXC+zaWAKMrSdWqyc0uEw6WmTheDb96HQPW/ZzkFBLzG9nxo0xCS1A535
	3QJaYqPd8cegkmM+2Q39jL7PAr9pnRRBvGdoV49AdwwzN7E7874dMDk5WGnuSlqiqudEbi
	98Nconkn2+xmSEqzPz20gYm61FfHIqI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011835;
	b=Tin+xZeYAWzAlYsEbnVz1PxicEqIlcPjOr57bt/ZrokG9YjXt/j9hlP81/rYuuQWAlF6x9
	W3H+jvOcI9Mc4+mV4tbsDLNKY3j5BAZtmuUAIZcV8zbxS30E25VHf8FvgTe2vf1L6YCePw
	aoc9faBgJjtYUsIIIs3iWQn7EL8jitg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ox45Wigg;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C280560E22;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011834;
	b=Zz5OI4UnS+Im9SbNjVgMQn2QG+mBRPyYISR4/XjNlKx9lz9I4vSHxpk7SRQjaz7IKEVf
	 x7XFcCe+NBA6E310meVaDkT82KGXrm6r57CvpEOzzW/60EqLWx/9/fixN0+PFJm/rf9jr
	 W8Z2ov8uLwpRltTNsewGKF9QGB51D/YULNlWxPnuAvT64dlVHebql5W05YZUlsFh1jdzr
	 ni46Y+jdhpNX1Ftk5kOMOmB+KPGt03f+hY1UHUHl9c9qsygjbfdi3Fs9wszFg1l7Nrh/6
	 lvhbDvMXwUmwyjcggOkSkgPq3mpaxVGjtK6mM1pvzoBV0fNTxRIunlfmN11Ce8znZEA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Wc3ZDddF/SoKim6dDvu+EZKuiq91csySlG+i1DCw1cw=;
	b=C8L5m0dXh0hoCyNkRT2rH1tCEvDcjR+CcvXmbyouKO50T9kNSzU2lm5RLwG9jF2ddCwb
	 61WqQw1W5HMvvBluTSJ101Ryw9iFqLRhiliRLFotgMFyvF/qYpcpzrT1Emub3FZTCRhxP
	 TfUQS+zknYSoE0JZBXZvt4PLVu21q/NwHy9YdwK42BKIRzbnG8JHmX7JHbP8UbS83r+wp
	 tibf5RqPeb5zR1p2lV+oM+qnkX734Re7HKFbH9yfTcSwZJwVLP6+JdcROpMTb4lACQeh6
	 mJy3g8cIbdcb1Ew3Ep+/w5TOntomgJo88zfeyOpCgJcyE4zo+7D9ODnNw+ofCInzofg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 821CD1F00931;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011834;
	bh=Wc3ZDddF/SoKim6dDvu+EZKuiq91csySlG+i1DCw1cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Ox45Wigg0rP/vYFLncB75Hq5AYXzucWZcIsHNiwt8ekt/v7HmVTnfF3LXVUH5R3g0
	 7F5zfz52rR9w28s8JAfi7vEZGVDUbVWSpryFcFsMV9bzniDKrJyboMv+gCE1M6fVfn
	 iOfqoTi+MCVS/tsxLb0FsaMVhsEwbA/VDEv/jyRnzkvgCFE2jMRMDsXsXeA7/2peWb
	 bcqfKNGvBjt1qC+DF0E7zj0KbNRL26/4FYBOgPQ97x00Wdze/+zUHwRNc8IGSAOB4Y
	 nVihah4Qq2K/aZKDvJXmByQv08cS3uaxTA4SJLCDeQaNLI81b8/Q9V+uA44E30kIf1
	 316D0DlA4nW0Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D5AC9479F4;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:32 -0800
Subject: [PATCH RFC v3 58/88] vfio/pci: Implement attach and release
 provider ops for guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-58-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4120;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=BlUGE6K++nDiJr8qPUVvPATO+O8fe24pYgQMxNdL00c=;
 b=NgSlL+6BQDukoZMQwJMCQVxrx2tW2tfdtYAwt2Mqe6zuF4vrIrK51yN6n7vJ+9KVephyFm5Wd
 nI/Gwn7eHXYBu4/2kJhD2xUzUg8WGqxthiF+W0hHlwEEnmJsIIb2avw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ojf5w1t61or1ytsszhq1bmeupsf7p884
X-Rspamd-Queue-Id: 2B14910000C
X-Rspam-User: 
X-HE-Tag: 1794011835-602791
X-HE-Meta: U2FsdGVkX1+Yq+5W3dN5vhWQ5uVvl3NJwxNQdva5Q42bjbdMkz9dmGTbOOCqIUxtHlFc+eOywdYhxNkCpjtCuaYDzR0mtL3PxV3vjcsi+3rD3OdCVVn4dphMLnSrNMsb0NWX2ZSSIjccrBXeukrZO3dUbEmszD+XekbHsgPJ+v5wRs2pyLigKXArJtcENoqkaSn5JfrVO2P5wvNNjySnZ0PHEK0icRdu1XlnjMn17JH/PNy9JuJ9vElUFdtbIOr1HJ4/hG/UXfT5w2j+xfbGnktnJKi8duE62DHQ9ks1CO2t3qPDgw96FeLoc+cYL9IE+GVbaIVVIA15Y4ptRNsAm19BJ1zIsZ24dnSwE6Ns5R7ATDEzQTAHxOqLzbprISJB4+B38OnmjmdmKIFWz3xMnJO14qBW0U3Jejg8MZ0F6faN6JJTJviibh+vw0UJOJyaEfjeaxu/CPS0WDBZOqlkKlLkPXU572LAYd49KHYAs0BowVkH0iadICC5lEB31k78F01RZvFM9K2IG3Jz4mD9CbRVBQKNeefoT6l9i6xDp7DDMOL7SEyMa18Z8kA6UVdgi5IPDc9cPqyershFofK1/zeUOqrnrJKsFUFwro1Xfy6KdhUOLaxRa9Pm3PF3cs336bn+o0Dv6uhmB3TxUygiJ/r8AYIHWCYiw8smdPFSDYyHYHG/Tr6NKiNzK5zShlczfuYlP1uGoj1ghA/id/Z8FLxLKK1csHnn8JZKirL7Obx04yExsf3eteBViFEPb6ZmBB7C2GMeGQlrluLih1o3sA8yJlWsnbg7NKEK4lC0fRWPBAAE+W5UIlT30S2pIDQ7alx8qOPk52RtMA6FeRhrH329QVEprIotAxshBKPZU6WlOPyuMkC0oERMVnq7A40VbNVb9rloAaR2h7HhggO55bEseIm+r7ICQeZVjuIfJSJnjn2nzmOMM607fwR6R+xkwg1udmiAdTZmRd0M1jR
 1vfmJbFA
 5bnxNjKaX6deHSsgiOEXHmr7eaEjFZVDVO9aytnXePRBHzYHgT2yS6QBaO4vzObCFW3g5wBTvQwb5FORN7w6S63DfX36uNx1Mrxn9BGImdT6DaOagvSdL9y8uUeK1OSRH20pO1Sqt68utAXf8o7xn+XDNsgm2W6PS2tkQDm05StuWL+VLOnGnDUMeATx1nFhgo4X7TOweTYzhS2OOLpdo105Wv5jdKZCCoz5TcFJPlkSevxdjqMbyUy34qkeB/FSryKk/HwSFuH+Amg+k4vi+KWhx5EhW8hkTkFikssl7uMly4Ko0d1rZDeXL0eSNRv3Peo52+rLpsH6b5AxvnXmmRf4BrPsZyh5LZJAdnSiqSfguoIIfQ65YruQbIzDW77xmXYDuAgxCpkH74jHA5X+gwbkRRWtp0JULFyqV1j4uD4/wdCzSjD/IBVqwcZrfRSoY7ja6yv+kxus0nFBRMbXZ6bSsw6KoKMKRmCsBEMHeJYHM8OcNfW2H6gNZogmdJG3DtfTMfMvnldp+r70ZoY/oQ+DwPGKsrGVYVQieIPDlXgR1FG3FpOFhX418rXAGDWNb7zbwQKebFJ2m8TqxAEaZktrm9U5wH0XtbrHEMjJI+AVS1h58gpxTtPmuct0hSMJ0rfxnlMweARZ6R4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement guest_memfd provider operations in the generic PCI VFIO bus
driver to support attaching VFIO PCI devices to guest_memfd.

In the attachment path, acquire the device memory lock for write to
initialize the BAR availability flag according to whether PCI memory
decoding is active and runtime power management is not engaged. BAR
resources are already mapped and reserved during device open at bind
time.

In the release path, acquire the device memory lock for write and mark
BARs unavailable.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci.c      |  4 ++++
 drivers/vfio/pci/vfio_pci_core.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  5 +++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 3dc232ee65491..96f438671db29 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -168,6 +168,10 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
 	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	.gmem_attach	= vfio_pci_core_gmem_attach,
+	.gmem_release	= vfio_pci_core_gmem_release,
+#endif
 };
 
 static const struct vfio_pci_device_ops vfio_pci_dev_ops = {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 907e6ab024acd..c7b67fbce4cae 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/eventfd.h>
 #include <linux/file.h>
+#include <linux/guest_memfd.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
@@ -2696,6 +2697,42 @@ static int __init vfio_pci_core_init(void)
 	return vfio_pci_init_perm_bits();
 }
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+int vfio_pci_core_gmem_attach(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	bool bars_available;
+
+	down_write(&vdev->memory_lock);
+
+	bars_available = __vfio_pci_memory_enabled(vdev) &&
+			 !vdev->pm_runtime_engaged;
+
+	/* Pairs with smp_load_acquire() in provider operations */
+	smp_store_release(&vdev->bars_available, bars_available);
+
+	up_write(&vdev->memory_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_attach);
+
+void vfio_pci_core_gmem_release(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	down_write(&vdev->memory_lock);
+
+	/* Pairs with smp_load_acquire() in provider operations */
+	smp_store_release(&vdev->bars_available, false);
+
+	up_write(&vdev->memory_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_release);
+#endif
+
 module_init(vfio_pci_core_init);
 module_exit(vfio_pci_core_cleanup);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1053774d2d659..c3c16459e14f4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -149,6 +149,7 @@ struct vfio_pci_core_device {
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
 	struct list_head	dmabufs;
+	bool			bars_available;
 };
 
 enum vfio_pci_io_width {
@@ -168,6 +169,10 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev);
 void vfio_pci_core_release_dev(struct vfio_device *core_vdev);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
+#ifdef CONFIG_KVM_GUEST_MEMFD
+int vfio_pci_core_gmem_attach(struct vfio_device *core_vdev);
+void vfio_pci_core_gmem_release(struct vfio_device *core_vdev);
+#endif
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 				  int nr_virtfn);

-- 
2.56.0.455.g6c5a503b38-goog



