Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E25CF532C2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8C16B00A1; Mon, 23 Mar 2026 19:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107FF6B00A3; Mon, 23 Mar 2026 19:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B796B00A4; Mon, 23 Mar 2026 19:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC6976B00A1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A689C13C291
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:52 +0000 (UTC)
X-FDA: 84578995704.10.BBF8136
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF6188000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KAoL2YwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3udPBaQgKCLwfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3udPBaQgKCLwfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310331; a=rsa-sha256;
	cv=none;
	b=iqGm2Q49NZiJWC9q37v0V+NqSBZcsYiLnnxwY1pTD/38lneQbcqQOAXUxi391Ld51d1RK4
	l77GRYJ3DcKT1zdfnjtxv7CgyV/BfGI8nWAFhx+Kx5u8iahEdaFYr8lrYfGidTFQm3kKot
	6hDlJPxKaMj2FV6oFJB0AwRcvFGgjOc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KAoL2YwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3udPBaQgKCLwfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3udPBaQgKCLwfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7yaJ9779yd/8dNUYbHNz1geAYfqq+6PqCMDWCMvl5g=;
	b=LvCR+yaoTqnRnN4CGn8DcTOXwxZzrzBwiwbnkcSMSKGxGrpMzZPAIwZoMUbH2A/mdZrrmY
	BzZrsgAL7JjCRIEri7/MHJBVGk9RqgJeQMFvE+c3nSLaLzHd8IcLULqQ4PF/QDctcp0zhM
	nKEwTDQqDcoKpzy0Jfvv6q1gwc1t3fM=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35449510446so772722a91.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310330; x=1774915130; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g7yaJ9779yd/8dNUYbHNz1geAYfqq+6PqCMDWCMvl5g=;
        b=KAoL2YwUMcgE5sDSFvRd3Xn/pDCzcixMOK69d1ydwzxAU4G8KLKwZLpkgeyHq7rKRE
         oWYrtrw47o+S/yp0ZeaKMYwZIauh6XovelO2YV0nAGkt7YIS+1qmL/wtXxYmNODV1IT5
         JOUDAFZJo1eJew85L5lY5pQK1Tc5eXwhMGpLUs0Yy35UyN2yTo4yrermYCUhMq35EWPj
         AoempRm73qckWpqdn9VGG7cXikAqWg2t8OsbicwuwGH/QzMplmfsNXNtYw4jchy/+h8b
         0yTyR6tBjJr0dzcDLk4A9ec7PR9YAa7Cai8tnhSjys6IwqGand3RPfB4fw2ady7h/w2j
         ieOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310330; x=1774915130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7yaJ9779yd/8dNUYbHNz1geAYfqq+6PqCMDWCMvl5g=;
        b=T/lEasLJQxqgb1zkNkHPl7/jX4lzZ4oEf7hvm42h9GQoTLj8nbs+4wFr4nW0pW/uAD
         ZzgCFT5psRFVdgFITxRjb4+ViUE2RkUk7b6xrJRVQm0tMQKahzaQdPaAlVdWahX4Y86/
         Icyishez2RqY6AaLKIZTTkx6vFql74Ut2KbyEg2g5QSRBmHKOa1d4S0qM/C8gzhpneyL
         pbJdJryM1mtSAnkAU0ldHPSYt9NESncSFiUKjFy+tExkLiqSIyGiJ1pTUqFZg13rvNMy
         OQvVqVehRB7rr6XIOO0G3KESBLh92Mnu3u868raskJ22YMHh1YR0cR6WhooMWjV+qXoP
         J3IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc84+JPYFC6e4mHxZRgwsrzkXf/t5jhAD5/OGJKm/0hFHZIiD8/pKxZTgTJV4w5XSo0QvTPAWarA==@kvack.org
X-Gm-Message-State: AOJu0YzEkMU2Z54woMSr/TwaxFt/Ftx6MapZy8sj4My7GfLrF4VZzj9y
	l5BYMfzJiGhdxNPsQfB9uWqhuK56/iIT+/EKH6o9NKDBne10pNVX/zofy8Qlf//esZk+AMEXja6
	8tFZUUoEwZK6xVg==
X-Received: from pjbiq1.prod.google.com ([2002:a17:90a:fb41:b0:359:f249:13d5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4acb:b0:35b:a30f:8bf9 with SMTP id 98e67ed59e1d1-35bd2bf4cccmr12732243a91.13.1774310329456;
 Mon, 23 Mar 2026 16:58:49 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:59 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-8-dmatlack@google.com>
Subject: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DF6188000B
X-Stat-Signature: efmztukpi4zp8qd3gztu7mxza4ss8imz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774310330-175261
X-HE-Meta: U2FsdGVkX1/ioaW1s2rKE4u4EszT7zQwCDulgvk5VW569i92oAweucJXzs2af8MLX1breBOsLrjAnvC4UzR95Ei2+xrOvhthWRfblnUEl+rAi62QqZBUn+2i0c6+N5oN4XQ+u4iGeNQmULjXY8OX7bZSuTQg2UgiuS7F7rrRjEwpDiwzSIv7TwvbQQzzvM4qaIQHraPVSbDKJU5OUNjGhL9Ww9oIX4KLRZcLDQqWmJkQ9MI4fZHUiDjb/IIDc3y5sRKjrV9ID6C/HdB7oFQI5n1iflE9krvBDmCrkYPoGf96o5lw/Vnit78DD+2qRGqvp3h9xedovJmDKcn54Gg6FPMPg3bh4LSATtevQY9/SImM476snN+mfhP3wUoFPSwvRA96hiZijRDfPzUsIdBWk6rhYoSfUnKfB8D1HPd/b7s2ZUFZ+ByQc43fcEv4aLU4ugYBSO/4HJWSqFmpn+cOsn9FMdGemiJWA8GSCecwEsZhKQ12l7TSKu4w4YrgyRkcTfd7hW1HiAV9uvrtnm5J3J1vecle1/ScDEiqVtn2dNE47yn6dEn+Pu2b4VHB5Q3rCoO7jucgvH0WpE9kxDcKMWgSlQReM5etLCyRIfr9St57mr4yiGQTp1K0PzkNlPJkqxL6sM1sJD1g3uwAt1Tc1eY27v53BoEhVA8SZ2RPfirT8OE+r8BnnmwSwRmNNH272tSCJcp67g6aShAeW4DCT4EmsqT2PuIt4kviUPM3kwWX9clBrbFzGNK4sOs1h9qwE7l7sapitVil4154ruldt9BlGQwaX2C1jD1m3IgAaSDl3ptWIfZmZLZRAy/nBQKQkDraBiJ3eC4MnMYR9B4Hyj3zZ6STer5gU+GOcXh1ybgQJ8KoLKqcNGwfb2EG7YfmFcShVWPjdCOLgZgGCd35zFFGu+DhtX/jOk/XrU3ovA5L+yYxfbeCiE/cMNB/K3dGd8jH4ELE9b4YxqIUHpz
 dWd9xv+l
 aRDTfY6Pkdzs9Jl9V3sg/IhDPGIDfINN2SvyoZ2ZU4qrdt+f5LbVLU6fE6Alz5Y+aJOQLs+FAQ8UiFb1+eVLoqGKhMtdIRCA7WMKQsgN8wZk4+SJnSmIgR2l8DRVJOZ5mX/IIueNjgHRVVxz3PXDXEJR0XSpfUxCcSsqp6rKWDwYbmZi2vUppl9wM4qYJiAqT1uIyi5MYrluYiiwHceOn32DlN/pvwVnEJdsr3Vj36p7BoNJrHkDP/FWpfBEb18L9O00X399DZ8bFrHqfRgvCbGN7w5NIMJ4xVwygnqnF+DVUy2y0TWMy8v2R2Zecq/d9PEYE0IA2oR34iVvSDyDVu6j3tl2ptycaUuIDO3KNa7E4/kGQpSchwGxtd28EN/GoirkT2krWXhry6WlyB8cfT5UIptXSVl+pjWedz3CeNaYAt8eFmWmEbOaU6jItC+K4a0A52Kg6EFLiVVPx5NWCKNMnP0SD2RMF8bHgLFZ0PYeeI1LY6D4v7r5GYG/xSIZinzD8fg84W/6f41bCxtdGThctyG5I8/8Ii6NkRyYOO3mVhf4Kchb9KMhAJP3b8nClnkMYsTmmnAZhbpXrZfcLrJPwwOSoTlKjtlDiOZv9MjiH/KLLv6KiqPQEOtvTcbJrOFPtHm7OYuPx1uQ=
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
 drivers/vfio/pci/vfio_pci.c            |   2 +-
 drivers/vfio/pci/vfio_pci_core.c       |  57 +++++----
 drivers/vfio/pci/vfio_pci_liveupdate.c | 156 ++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_priv.h       |   4 +
 drivers/vfio/vfio_main.c               |   3 +-
 include/linux/kho/abi/vfio_pci.h       |  15 +++
 include/linux/vfio.h                   |   2 +
 7 files changed, 213 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 41dcbe4ace67..351480d13f6e 100644
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
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..81f941323641 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -585,9 +585,42 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
+
+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
+
+	if (!vdev->reset_works)
+		return;
+
+	/*
+	 * Try to get the locks ourselves to prevent a deadlock. The
+	 * success of this is dependent on being able to lock the device,
+	 * which is not always possible.
+	 *
+	 * We cannot use the "try" reset interface here, since that will
+	 * overwrite the previously restored configuration information.
+	 */
+	if (bridge && !pci_dev_trylock(bridge))
+		return;
+
+	if (!pci_dev_trylock(pdev))
+		goto out;
+
+	if (!__pci_reset_function_locked(pdev))
+		vdev->needs_reset = false;
+
+	pci_dev_unlock(pdev);
+out:
+	if (bridge)
+		pci_dev_unlock(bridge);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_try_reset);
+
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
-	struct pci_dev *bridge;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
@@ -687,27 +720,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 */
 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
-	/*
-	 * Try to get the locks ourselves to prevent a deadlock. The
-	 * success of this is dependent on being able to lock the device,
-	 * which is not always possible.
-	 * We can not use the "try" reset interface here, which will
-	 * overwrite the previously restored configuration information.
-	 */
-	if (vdev->reset_works) {
-		bridge = pci_upstream_bridge(pdev);
-		if (bridge && !pci_dev_trylock(bridge))
-			goto out_restore_state;
-		if (pci_dev_trylock(pdev)) {
-			if (!__pci_reset_function_locked(pdev))
-				vdev->needs_reset = false;
-			pci_dev_unlock(pdev);
-		}
-		if (bridge)
-			pci_dev_unlock(bridge);
-	}
-
-out_restore_state:
+	vfio_pci_core_try_reset(vdev);
 	pci_restore_state(pdev);
 out:
 	pci_disable_device(pdev);
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 5ea5af46b159..c4ebc7c486e5 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -6,27 +6,178 @@
  * David Matlack <dmatlack@google.com>
  */
 
+/**
+ * DOC: VFIO PCI Preservation via LUO
+ *
+ * VFIO PCI devices can be preserved over a kexec using the Live Update
+ * Orchestrator (LUO) file preservation. This allows userspace (such as a VMM)
+ * to transfer an in-use device to the next kernel.
+ *
+ * .. note::
+ *    The support for preserving VFIO PCI devices is currently *partial* and
+ *    should be considered *experimental*. It should only be used by developers
+ *    working on expanding the support for the time being.
+ *
+ *    To avoid accidental usage while the support is still experimental, this
+ *    support is hidden behind a default-disable config option
+ *    ``CONFIG_VFIO_PCI_LIVEUPDATE``. Once the kernel support has stabilized and
+ *    become complete, this option will be enabled by default when
+ *    ``CONFIG_VFIO_PCI`` and ``CONFIG_LIVEUPDATE`` are enabled.
+ *
+ * Usage Example
+ * =============
+ *
+ * VFIO PCI devices can be preserved across a kexec by preserving the file
+ * associated with the device in a LUO session::
+ *
+ *   device_fd = open("/dev/vfio/devices/X");
+ *   ...
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
+ *
+ * .. note::
+ *    LUO will hold an extra reference to the device file for as long as it is
+ *    preserved, so there is no way for the file to be destroyed or the device
+ *    to be unbound from the vfio-pci driver while it is preserved.
+ *
+ * Retrieving the file after kexec is not yet supported.
+ *
+ * Restrictions
+ * ============
+ *
+ * The kernel imposes the following restrictions when preserving VFIO devices:
+ *
+ *  * The device must be bound to the ``vfio-pci`` driver.
+ *
+ *  * ``CONFIG_VFIO_PCI_ZDEV_KVM`` must not be enabled. This may be relaxed in
+ *    the future.
+ *
+ *  * The device not be an Intel display device. This may be relaxed in the
+ *    future.
+ *
+ *  * The device file must have been acquired from the VFIO character device,
+ *    not ``VFIO_GROUP_GET_DEVICE_FD``.
+ *
+ *  * The device must have interrupt disable prior to kexec. Failure to disable
+ *    interrupts on the device will cause the ``reboot(LINUX_REBOOT_CMD_KEXEC)``
+ *    syscall (to initiate the kexec) to fail.
+ *
+ * Preservation Behavior
+ * =====================
+ *
+ * The eventual goal of this support is to avoid disrupting the workload, state,
+ * or configuration of each preserved device during a Live Update. This would
+ * include allowing the device to perform DMA to preserved memory buffers and
+ * perform P2P DMA to other preserved devices. However, there are many pieces
+ * that still need to land in the kernel.
+ *
+ * For now, VFIO only preserves the following state for for devices:
+ *
+ *  * The PCI Segment, Bus, Device, and Function numbers of the device. The
+ *    kernel guarantees the these will not change across a kexec when a device
+ *    is preserved.
+ *
+ * Since the kernel is not yet prepared to preserve all parts of the device and
+ * its dependencies (such as DMA mappings), VFIO currently resets and restores
+ * preserved devices back into an idle state during kexec, before handing off
+ * control to the next kernel. This will be relaxed in future versions of the
+ * kernel once it is safe to allow the device to keep running across kexec.
+ */
+
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
+	struct vfio_device *device = vfio_device_from_file(file);
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+
+	if (!device)
+		return false;
+
+	/* Live Update support is limited to cdev files. */
+	if (!vfio_device_cdev_opened(device))
+		return false;
+
+	if (device->ops != &vfio_pci_ops)
+		return false;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	/*
+	 * Don't support specialized vfio-pci devices for now since they haven't
+	 * been tested.
+	 */
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || vfio_pci_is_intel_display(pdev))
+		return false;
+
+	return true;
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
+	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_try_reset(vdev);
+	pci_restore_state(pdev);
+	return 0;
 }
 
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
@@ -42,6 +193,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.preserve = vfio_pci_liveupdate_preserve,
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
+	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index cbf46e09da30..fa5c7f544f8a 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -11,6 +11,10 @@
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
+extern const struct vfio_device_ops vfio_pci_ops;
+
+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev);
+
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
 	struct vfio_pci_core_device	*vdev;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 742477546b15..8b222f71bbab 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1436,7 +1436,7 @@ const struct file_operations vfio_device_fops = {
 #endif
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1444,6 +1444,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index e2412b455e61..876aaf81dd92 100644
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
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ */
+struct vfio_pci_core_device_ser {
+	u32 domain;
+	u16 bdf;
+} __packed;
+
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e90859956514..e9d3ddb715c5 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -81,6 +81,8 @@ struct vfio_device {
 #endif
 };
 
+struct vfio_device *vfio_device_from_file(struct file *file);
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
-- 
2.53.0.983.g0bb29b3bc5-goog


