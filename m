Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F17606BA79
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ah2WmDCR
Received: by kanga.kvack.org (Postfix)
	id 7EF296B064A; Mon,  2 Nov 2026 10:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A03E6B064B; Mon,  2 Nov 2026 10:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640786B064C; Mon,  2 Nov 2026 10:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF756B064A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9A1B120137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:15 +0000 (UTC)
X-FDA: 85390582830.23.CE960C3
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECC0EC0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ah2WmDCR;
	spf=pass (imf28.hostedemail.com: domain of 3KK7oagcKCIU4ryrw1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--vipinsh.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3KK7oagcKCIU4ryrw1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633833;
	b=nlyMleTeZXdzw787D+h7yNoU9vB4iGE0x06HGXjCMBHqgLb9rCEcjHq022BcxX8j3yFJhj
	7u5HtWmqClW+TlDe+s7q4hbCWi2wJpam2pm/wlDb6ei6dyzQwP/i84AuknM8Ua1CAz7D+U
	7pdtbXXjix66kilzizQkdS4cxFsVBOM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ah2WmDCR;
	spf=pass (imf28.hostedemail.com: domain of 3KK7oagcKCIU4ryrw1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--vipinsh.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3KK7oagcKCIU4ryrw1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym/wrmWFSlmP/Qd42BcsAsFY9ji592OmGMgA89zOpEo=;
	b=G0K/uistn3TpbN2K85MtsvbxDX+nLNkL8dZmdDi9Zhle40AZJTw8YAONxL6LcLScwfd9Fz
	AYo82R48QASwPqNU0GlKfMisVNxcs7L39zMBLmZ1X1eMMBrkKGGFuzlLkK4RC3yJuAZR1X
	qPOwgToLvNdOHBUs+z5m36ZnQZezFeI=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ada8bc8575so6718926a91.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633833; x=1794238633; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ym/wrmWFSlmP/Qd42BcsAsFY9ji592OmGMgA89zOpEo=;
        b=Ah2WmDCREjUqTAV35fb4NvRS4QhF/ERbX47cui2l68IifCx9c4yG+JyIAiRvGqDbRO
         VeoDzE/PXcA2Aydib9lwKCpo8HVAaXLNDRSjDvq4DpaGqkv6Bvsn7rRjKVVdgHvt58Bn
         yjxdaBasUSbgAJ+XdZUe3kZFZrLKN0Bgpxyv5nY/93IUASt+mwy4vrlMO6cNlGjie0hC
         a5Mmt17ewybvEKOPc53/OmxNNDRnnb8yD39ujam3wpmdSnBW1Cxnxm/JvSNq6Cw5p72B
         n/3MKg0+zIeHcpy6MELhCl4ZVWm2i1flLfkAt7N60oavMWeiETwsNECSAFWi7RwyzJ/s
         pZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633833; x=1794238633;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ym/wrmWFSlmP/Qd42BcsAsFY9ji592OmGMgA89zOpEo=;
        b=ILrHTWZDq+j90sLcSMDM1JeZE+OIdurb2VqwQLl1wLixEF0xrG856NJ3b/8qzsf6Rj
         XPvZtJ1c9O8iDX4CrjmaxkeYeEcjNDrhQc78E9LyEsW5VRejU8kYqDE3PuKX38cGo2G+
         rMrxqV7btFunxv8ZTFlbi9QEq4SSXd4BE2MfQ4b9vMNyXGisaA67E3Jy9lEWnxi6u5A7
         woc+mmPQwjfYTpNI+rYxlnywo26+8y7WYRCz7II1Rt75KzCMEkBmZub1JRE3LJAKa+bV
         OHNPO8MbR4TzZfBAjfB3U1hPDZVxYQsDfq/50cFku/OvNMqACMh129PV1kDEGoiBaMtV
         cLUg==
X-Forwarded-Encrypted: i=1; AKwUvBzrPQhzh30qMGFbLjvCmSvskrMOzKMEfmwp+ByMr+6/Zf9KiSsS4ZkmKqnv2q/FewThh64cJ7M7LA==@kvack.org
X-Gm-Message-State: APuU4Z9wh5pnC7wKClFe4yQFpCzvbzndZrDIA9K17E4gWwpCF5ygj+qc
	b5fGScV3TEuAHmw+gvWKe1GgQv6W6JRIEImHoXfX2hYiiA8vqUcIAZlqmTqyesH1Drkt+2KMi67
	0oBWJYu2sQw==
X-Received: from plhb8.prod.google.com ([2002:a17:903:2288:b0:2e9:84f0:65ba])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b47:b0:3ac:9f00:3bc7
 with SMTP id 98e67ed59e1d1-3ae8980dccamr9246672a91.33.1793633832641; Mon, 02
 Nov 2026 07:37:12 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:41 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-13-vipinsh@google.com>
Subject: [PATCH v6 12/27] vfio: Enforce preserved devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 11biuu7m6ec6189dhouoh5shj4rh5pj9
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ECC0EC0004
X-Rspam-User: 
X-HE-Tag: 1793633833-668144
X-HE-Meta: U2FsdGVkX19PMnCe2ksKf1D/qGxfgYfqYYuJ9n4jGBBqr5OflvYpN6KjCRe2lgBqFQgnLdS1YSE/GY01HwG+wyNgAaah1DpdE/U0UOM4n+ZtApVtj/0JYQfMYsMjGKhcG0T3c0rStNGuTtzWrBnGux9iPwtavHzHxw0bYrJpZCgoOTrvHU7fW2sKlAArX+NedZ9Orb+K3+hG1kMUHpDpMmPDeqXApxoGIUbvwiN/Eg6BD5w6gzaYn1gc/lOgclCwQ4FXBnEf6hRBu88ti25fSGmkxpVXz+Y43kmZ4E7g3UlprjAEeVJBWZ2uNPMLqxN3opikcFwkh1JPCM9+gcozqQW0BC/Jv8oz9nlmgV234kC/HuhIMPBOvJ+jZlPnL6kmZWsINPs3cH1XZGhlfAEsuUX3iTQOBkcoZQ7JZVn1mkFSwJYtlL+BEU70IXV6rhAxm/8XmKy1L55w6jsSx3jMbsMdry/z8LeRF4xJ9x1pSiQA+t15wWzu3MZ1GuT4XoFOqBQdt7N0UTnZkDjIkLOqPU/DOEG/aSgr/3fKglzalIwuaySwP0Jk9qMUCHCZZjvZ+EjQFy1oJOBpQUMiqLC3tZ/ybPEx28z+U4oBnxHpuZf2wwZgd5koRn21J5jFj+hEDUh2Z7dbpvyiflJbQiL06sIUhCyN8w6E7j6nOA1YZPCROKbnBYvsV22l8TYRkzKIsOolhbizTXt8Zm6scGcywBCmdlqUMQ5xNH2F+pGFR0fPeK5l0hgRojJmIltackRLZ5nh9Q4B4G4RiN9A2nxhyvad36w4regG3fh3pja3sXNZmzaAFYKSG3BIDchjCRDfzU3K4f+JXdnnfF0bQbSvCMZQ3429sbpVXcGuvme+cDLKU3lgq8M/aCgJBp2+rw4NLBKNz8iONuSGSXpFsjLvrPDkbD6z9Pq90x9FNzeEP7ueMoaPS+MbHSYtQ8U6tC287liFSBBCcXrVuQreL1A
 zRXxND2A
 fax76Z80FT+X+eX+y9xVKiWUyX99Kyz/VCnrvCpgQmGd+VyFyJ99PzUJS1jVhC7r9IfzDbNAwJpPJenwtxwkgpvEf50zHvKlgIqeB8DfyUSPIPRcTxTzoKeOpqqGqG3TpxE8Io/HdBJ8Tk67hxG5O/1MU4m0tOPGI9Ush+nfsoS+fY5nN9GcR0DU6waxJZm/oPJmZpM3qf2ZLfEqCgLnZQ4Xm8WmwMCJMhse0RfBmyBZH/CG9M8yD2f+NcdNvSaOIVab129Bk6u8mePkRWsAICoJzfvFBjNFPWppTmeq0rBylX/sLKw4Nh63aTQcO9hkDjS8WawPSND/rbzf2aSpHdN7RDvz4sQ9gtuvQrYlOInT9oz5k7/WKSShhdC/QtAHxmEPiw3FxrhZLQ06fpQ/mFRefKv+eNmZ31mHsiKvGxhAoBJj8F5Bosd3OT9z4e+0IF5ZthwJJTYDJ4vGnfQtlPZhUWH0n8KQf0p4fBvTCy6Jhx4lvCYS3WHsy8W2lSwYesEe9iifuu9huwXtEOZgMd10B6NeRcGQASDIKLITUl/uD/SSdX1GTlCEXBj6nN5duJ0DO2bGwFgngJ2aNZ7Vk8ol9NbotF02z15J0PowR/S9eP7Wu4SCTjd7MVliO/Ed4F6tb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: David Matlack <dmatlack@google.com>

Enforce that files for incoming (preserved by previous kernel) VFIO
devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
opening the corresponding VFIO character device or via
VFIO_GROUP_GET_DEVICE_FD.

Both of these methods would result in VFIO initializing the device
without access to the preserved state of the device passed by the
previous kernel.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c             |  8 ++++++++
 drivers/vfio/group.c                   |  9 +++++++++
 drivers/vfio/pci/vfio_pci_liveupdate.c |  6 ++++++
 drivers/vfio/vfio.h                    | 18 ++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 38e691eceab5..f0018eae3c4d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -58,6 +58,14 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep
 		}
 
 		*filep = file;
+	} else if (vfio_liveupdate_incoming_is_preserved(device)) {
+		/*
+		 * Since it is live update preserved device, it must be
+		 * retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD instead of
+		 * opening /dev/vfio/devices/vfioX.
+		 */
+		ret = -EBUSY;
+		goto err_free_device_file;
 	}
 
 	file->private_data = df;
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index b2299e5bc6df..62b4eaabc829 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -316,6 +316,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
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
index f13c757b4567..64810010f983 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -43,6 +43,12 @@
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
index 12557d45dfee..e6ca4c3fda06 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -11,6 +11,7 @@
 #include <linux/cdev.h>
 #include <linux/module.h>
 #include <linux/vfio.h>
+#include <linux/pci.h>
 
 struct iommufd_ctx;
 struct iommu_group;
@@ -446,4 +447,21 @@ static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
 static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
 #endif /* CONFIG_VFIO_DEBUGFS */
 
+#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	struct device *d = device->dev;
+
+	if (dev_is_pci(d))
+		return pci_liveupdate_is_incoming(to_pci_dev(d));
+
+	return false;
+}
+#else
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	return false;
+}
+#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
+
 #endif
-- 
2.56.0.317.g454f8302e1-goog


