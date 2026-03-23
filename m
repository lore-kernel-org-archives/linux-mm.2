Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AD9F532C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AA66B00A7; Mon, 23 Mar 2026 19:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CDF6B00A9; Mon, 23 Mar 2026 19:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613FE6B00AA; Mon, 23 Mar 2026 19:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500006B00A7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E6C2B8A5D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:58 +0000 (UTC)
X-FDA: 84578995956.23.A964EAD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E03B8000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="c/mT2JgE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3vtPBaQgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vtPBaQgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG6U+6kAmFzvMZjga5OgV1LR5RVhGZN2WyiuuoZC9eg=;
	b=w8upFnR5JDjn+GDt01UZp+xQbotIBjaYdHwN0cko5jxn++nUGUSYBqc3QeTD4Gci/m+BMU
	ySAy1/93gk8sYyT7okIMGmQ4YnBdhAtVGlwsWS/s9DOEOVgbn0N8JHrTikOz/QmPasx0Yi
	WYgkpI00XWwFlK3HMJRTQ6PXgIq8p3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310336; a=rsa-sha256;
	cv=none;
	b=hE6MvNgvu0TacHJbqCm/BaHTtdL05hjSnTcxA/8YgZ+9GJtC+CUCvRuzwyDzQkPGVeOqeN
	2Ognkf7PjND/SjobJdBWy4x/MS7DrkCQ0QHHgdWLT8C6CnwVOIz6BL5p2rvoP+RkHl7fji
	J/jPYaJL0Vnj7mcLMBFw3TpCHSi9jts=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="c/mT2JgE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3vtPBaQgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vtPBaQgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35a0b51eb23so703215a91.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310335; x=1774915135; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UG6U+6kAmFzvMZjga5OgV1LR5RVhGZN2WyiuuoZC9eg=;
        b=c/mT2JgEmWoZuL3HkChHmpcl1keBgt974Mr0yZYBimTZEuiSsjMO3bIJkNLgmliXbd
         yJCmQ7grvvB7Eg6nCmfsphAW99sTssMcKZF7+rnPckgkOoN+krSfrwZDP9vs2y7hlN9u
         e8arTOU5GLZL4YU03QwOK84iAemCuxsmF8CYNc/SXoUNwWd3dGbGXYNJuFPxT0qYV1Pt
         +VhanEeef/VfJ3GeGQt5pWhLKFZzl6d7jdORQxo97cN9Irs2l/gAxiJ2PTEOQwvmvDhr
         bzj2nuNDa3mmrCbYoJPD021vkh0xgzjzsP8SGti4sCbEorCbNObsAd4wq/hy+gzScApH
         3Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310335; x=1774915135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UG6U+6kAmFzvMZjga5OgV1LR5RVhGZN2WyiuuoZC9eg=;
        b=asYe9GdDZi7vYepsbTWqlN/SIQXQTHi1281SZCrb3ZL12ztZSedfVe6FsTa9o8EPCp
         QIR6TZMIuhfnmAf3XIJNZktY7qyagJRmO09Jsw0matPceJE4KeiG2PzFP51yvYVHN5D+
         gx6r1YMVVqu6IDMtTeAmDuitU+Y8cibQvuDchkO9MaovKM9IfIbfu/pJWw14ZD7RuI/2
         F2dwocezDt54cunr4QNS93wfOMNysf1H/4ZAdePO+yTXTAtbdEXOaeZotg9WT1RIVbKP
         kRog6YjNIPQiHHAKSpvGD/cpw9VkxJ9awdminKK2pCs8nSzqG1c6Jh0RIuMCzhphKGSn
         EP7A==
X-Forwarded-Encrypted: i=1; AJvYcCWE1oG4+kKKMDq/5kx7GSR5uOG0+ZHm1FroMObRESrenNL8y6xJhalJvy0Vu2VFuLSizV4Wmqlicw==@kvack.org
X-Gm-Message-State: AOJu0YxgUy2DpbTu/ib2F3lwBm/zNZ+XA7e/RfbeAMczfLdb3PFXqZLg
	vVaUIYBk00Vwc1n63/GRS7Q77/IqBpCHIjhy5eKoKlLTn6i+Qdufk3/4sOAgiuKd5DsZP1cypFq
	vJDgN3tT5V7SQ/g==
X-Received: from pgcp23.prod.google.com ([2002:a63:7417:0:b0:c74:1130:c2ea])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:5493:b0:39b:f026:6f7c with SMTP id adf61e73a8af0-39bf0267ba0mr8201078637.49.1774310334903;
 Mon, 23 Mar 2026 16:58:54 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:02 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-11-dmatlack@google.com>
Subject: [PATCH v3 10/24] vfio: Enforce preserved devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD
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
X-Rspamd-Queue-Id: 5E03B8000B
X-Stat-Signature: wdkayzg8hdjphbteuqeb8f64f51nqr6u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774310336-272030
X-HE-Meta: U2FsdGVkX18dyNdOFHvSWcYHOcA9+FgkLGQib07yhGzpGH7irFCwQL27fkwGpf+jgB0CjVrthCH2ro+tnzWN2oLhg2qaH1pBFq9xjQNl2iWztoJ8oVnON9Y62uwIxsrtC/nA38R9qYQDjy0GEieSx0yDXC7Tx4V8Crdk4V6CJPWMOTHcOWV0p/gw+6ZphVebM9M4bHnrW1Jl0u8OSv6J4PlK3BqyVNqHlXosda6FqPYvTQss/j3/S9K7tBQg/1pkootdjxvrbZ+R4VPyhCsJJEescxxZ1FxfLKfJiw2+IvOzV3auV8WW6ub4UE7KwW3mFUybfA8JVlpcNMYqDu9qRJvPqa1h/gvMTOLWhghyCQMHWazx066RXTEtEtb9eVwPx1V/H0bKHyqjUqnoetR1bC+ZqYop+f1k1i4THwX7yHlbTt5pCdVfp7cVdskwl9hRsS7fPk2IFG7YuTBK6jvuZkXtm6iLpvhUw5wUZcLAhW+3BEoZQ+Ew/kGw0Milkm9+LcCkXEsX9Cnq8JwCH7GrdrxN78CsN0/ad4UoT4wfHoTLNnAyqjJJQ1Mzc0I8piT8EvpIOB+h5ThGEzsNue/dpefZhVBaX0nHKEoNmh+xGfFkiYzTlqZtNo7V7Qy5KohqP4W49xs4c7YqXdHU3WetBp9VDtxb1ia0CrZQSmgHujVLYXm+kct00n8Ztsy+AnKlUgDCiXYJP7EFZ3PDep7qsPkh7RNGlcftpmzVLean+yE9HZoCcv720ZHkfTVLoNBcIbIItz8Xc5/kORb/renMRTWJm00p71HhJSYoRZL5oRrqOH3mrizVJVxQD9PeuFh7V1pFJYpmCEgsP+3kWWxyU6t6d44Y3rWq2nCjJyr4hJi+mebRveaYGa4uJTaY8R31uPI+U8H/9U+TEZx60EnakRh6Lg497youiXmh5m+WUDkMeoLbg5y7U5qqbgemiY7i6aWOvwlBUnVYFj0Sq4c
 A34215h0
 wB6kDs56AaYS51MtSD+6kQ7QIwaonNNYxHeUn6BE91lDV6jKyw3OF7JXjxX2q1fKmX778iP6zmSpo9CZ3bQW8Tj1ScTrlUf5O1KsfAasOB8itBAvggmpk4RFgl6Ckbha9FkzTFrsdxloDUp5JRl7yuZ6ilD/QfkHNGgHt0G44+ntPWpiJy3gmvwKQd9XOVWIO2dDYlyy5dEeeJ2Itgpe5lI+qt0IZ/kI+/w0l/vJTyfw313fBEOFL956iVf7+cvkyAOy6ezm/zDMO35TuveZQXukZ30vZSFes3bBfo23tL7SEd75ZWnqHMwV1CUmrIp4gP/YfIXJWNL+i5ttfxjSa39XV+pAw9Y0lke9Zz1T9aOIgDg10HydeRJJQOopemcPxFUGNkEqIx+Zm5qT8v2bCzeLlNlaulGmujObYspEvueHVKlXS8uQMlqVgE0wsO3juOhBIj+428i3AL5eS5vIRopkNoaZ9y8NbCxYkffecb5iVb+JqwKuMQE5v8epTukzlGnK+lNONDASEUGMzUGVK1AGQzPn9GnXDZrrMVD4wXI4MlehXsu3QQdsuO2TmAER8KAdslqX9n6zuF0k3N7sKIW5rd/zKRAtbQN34P3zwH1i0RvavDEKiZJ1X9KW8E5D59hsGTexXxQizQZ60XNj70DD7cj0B5Mfs6N4xz+pNy/5nMfhnQfwdykcA5wgjVqRBl43g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enforce that files for incoming (preserved by previous kernel) VFIO
devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
opening the corresponding VFIO character device or via
VFIO_GROUP_GET_DEVICE_FD.

Both of these methods would result in VFIO initializing the device
without access to the preserved state of the device passed by the
previous kernel.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/device_cdev.c             |  4 ++++
 drivers/vfio/group.c                   |  9 +++++++++
 drivers/vfio/pci/vfio_pci_liveupdate.c |  6 ++++++
 drivers/vfio/vfio.h                    | 18 ++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index edf322315a41..6844684a3d8e 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -91,6 +91,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
 	struct vfio_device *device = container_of(inode->i_cdev,
 						  struct vfio_device, cdev);
 
+	/* Device file must be retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD */
+	if (vfio_liveupdate_incoming_is_preserved(device))
+		return -EBUSY;
+
 	return vfio_device_cdev_open(device, &file);
 }
 
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 4f15016d2a5f..0fa9761b13d3 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -311,6 +311,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	/*
+	 * This device was preserved across a Live Update. Accessing it via
+	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
+	 */
+	if (vfio_liveupdate_incoming_is_preserved(device)) {
+		vfio_device_put_registration(device);
+		return -EBUSY;
+	}
+
 	fd = FD_ADD(O_CLOEXEC, vfio_device_open_file(device));
 	if (fd < 0)
 		vfio_device_put_registration(device);
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index b960ec3ffbf2..6f760ace7065 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -47,6 +47,12 @@
  *   ...
  *   ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
  *
+ * .. note::
+ *    After kexec, if a device was preserved by the previous kernel, attempting
+ *    to open a new file for the device via its character device
+ *    (``/dev/vfio/devices/X``) or via ``VFIO_GROUP_GET_DEVICE_FD`` will fail
+ *    with ``-EBUSY``.
+ *
  * Restrictions
  * ============
  *
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..8fcc98cf9577 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -11,6 +11,7 @@
 #include <linux/cdev.h>
 #include <linux/module.h>
 #include <linux/vfio.h>
+#include <linux/pci.h>
 
 struct iommufd_ctx;
 struct iommu_group;
@@ -462,4 +463,21 @@ static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
 static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
 #endif /* CONFIG_VFIO_DEBUGFS */
 
+#ifdef CONFIG_PCI_LIVEUPDATE
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	struct device *d = device->dev;
+
+	if (dev_is_pci(d))
+		return to_pci_dev(d)->liveupdate_incoming;
+
+	return false;
+}
+#else
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	return false;
+}
+#endif /* CONFIG_PCI_LIVEUPDATE */
+
 #endif
-- 
2.53.0.983.g0bb29b3bc5-goog


