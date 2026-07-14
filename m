Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D95C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7752F6B00DE; Tue, 14 Jul 2026 11:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7253E6B00E5; Tue, 14 Jul 2026 11:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614196B00E6; Tue, 14 Jul 2026 11:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4956B00DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9788F1C03B1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:14 +0000 (UTC)
X-FDA: 84987730548.23.DC33E40
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id D67B5140013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duFsHKao;
	spf=pass (imf09.hostedemail.com: domain of 3f1JWagcKCNYNAHAFK98GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3f1JWagcKCNYNAHAFK98GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1UFdHONMaUW3i8xUAtShYLn0EA7imz4HjKdEgIKF0Q=;
	b=wqc5zqtioeCsNzBIrW+HhHB1B2AXp2lOLthFZGIbdVpUxKZOToj3SWFYfTUv18n3Myzk6z
	gznR/eIHSbqKudxxvsCy/j6fT7FGxfTPadOUwbS1OJGCOvUWf8TzTtL9fvWLidwF8SRdwT
	4LXOoDPum5goOCF7WHmu/TuKV0DMdQo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duFsHKao;
	spf=pass (imf09.hostedemail.com: domain of 3f1JWagcKCNYNAHAFK98GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3f1JWagcKCNYNAHAFK98GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042112;
	b=dTWafIzLSVPfA9uvyYTQ0a1SJ7hzCVwFsZjm/u8vhjKb7NaisS55FbDXw5i3ryqoCI7ukn
	I+eLpV2iia4YU3YtS/AKbmeK4RQQezTWJR8CUdlHo40legv0xDm0OD3Go5clx90/Kfbyl6
	kmSFnTW6YS+OXBh/hz77VZxYEF+7K14=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8482fd61e83so8628388b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042112; x=1784646912; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1UFdHONMaUW3i8xUAtShYLn0EA7imz4HjKdEgIKF0Q=;
        b=duFsHKao6s2cD48xine1x/c/xu+2bkmNNJpmpwrdbd2m4dBZjN5Y4e2S/bK0wBjFuc
         /jYgtMXl5pVMBLSUS1Jix2jWO6pcHLvfJ1qD8yM4Kz4ksEY3TjaosOkoLnn56xtqe4tp
         F4HKU/888wtJ/X0QIFZZgNuf3Oks7pJdpxpudeLLk3G1NeZxQW6kdeVR9DIEZVrRjJiR
         L3AxqgPAe96NjC5OUezZWQ6qsbiS6EfQRp3Y7KxnacICDXcab7kp2SCWOg9YdM84I5dC
         rAZsRiqHukkonTviTdP+yZiw1p0NgNBJI9nphzdZKYzQBQs+ahXjTQ1a2PtsSnxq3hwr
         11rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042112; x=1784646912;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S1UFdHONMaUW3i8xUAtShYLn0EA7imz4HjKdEgIKF0Q=;
        b=ADPeGE40d7/0XCobvZdwYqcrqhyYnnBopcl7odNC/de7THQY1+eB9QRcLgTBafG7kv
         WyEyKBXE9cCwB1efvE/xeqhe2HQSOyju6g1x3HdcU5V84yHVnDE18TS67jhsRuHR3RzA
         CFDKvNPY2nc5yx+5FslZE2iVfuMsB2q9XfultlTPSjHjS3wBLLRpjI4ZsvQNG8Admvma
         SwM61VbT76BJ1nnamnw6bOGckgQ3uB/R5tBogWzEsJtjvZ1Lb0euXr8O0QFzaGjTdBuN
         BzMoAHL4ppsAgZjERzHpQV1ZrKFbAimprvnJ13HTJcvx5u3L8RL+UhJLWzYJPJtV5as7
         CjVQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro2DrW7wMAFA8AV43cU+fiFJ0N2iQIQrB7S6eZB8tsbtPJQBIvAK4Juc5tw3JXmhChNEB3ADNmcEQ==@kvack.org
X-Gm-Message-State: AOJu0YwvZmE2awr4qLS6DqVOXuNVG4LHCfNwUTzGBOSNSokJJgFig8jf
	jIZZ1rxIDexAshOkHKOv3QoKG60ZaieaJUq1+rfsvC88IMwFkqcre+PpBD5cptHjxYPUTH8jZza
	vyO+N49NqJg==
X-Received: from pfbdi5.prod.google.com ([2002:a05:6a00:4805:b0:848:4690:d658])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e93:b0:848:19f4:3b52
 with SMTP id d2e1a72fcca58-84a516062d4mr3676620b3a.38.1784042111640; Tue, 14
 Jul 2026 08:15:11 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:47 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-3-vipinsh@google.com>
Subject: [PATCH v5 02/20] vfio: Export various helpers from VFIO
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: onwsjg9o5jc9rhuh1mya3mswz9i9rg1i
X-Rspamd-Queue-Id: D67B5140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784042112-971562
X-HE-Meta: U2FsdGVkX18GN23oaEVcGDLtV7LSPteHzEKSoEUkxayfsX9qrTfZlU8xhhpjm3nKDc0zs4o6oH8Oa4LUTy/4Ak4/Ew1E39PQud3jLEor0pR08dVzK214L+80eVkCvC+oOvknHc/FFpwnAd1lZvzhrdp8P83bUItTsg7gKZI8Mur3o+smDE3PZJwkj+AhE6nTd29frmNb6nk4SqIySC2S85WBWBFI4HoXDzOO56wzTA8tgwoodFWTKLW2R7OWrjtL/n5Ioz6WxdY44Ni2Gbhx6QmMo26n6A5xbs54sKMzri60oE6eE2OO2Fj87Y7Awgzm747LACcfhjDDCo6rSXFWqrJ3E3NxbjqhAQduwHiVbvT+3Yyrwh4qZDYYNYZplgOu47pGMN3kWHyZT9sOeNAmFySAf6ayNeab/sFtEoRRXFQjQtciRj8vtmo0tkSj3aHhGPtkeQ0lKoUKfvjxr8cU+WYC9C95bF8a75Q/kpjWdt7Uj8Ccvc56ZZuB9H3EUpLsiju5X2FjyTyjQQGKXqrNC4cWo5agpolCpLyl90wGj9yhsZtJjoH2G50sIKMO2khPn0BNkm1CKTd+8KafxvWs4Hn5nVr7oE28scvMkb2gidFk8ncC02ZFwwtcVlqbo+nbnzapes/CPiocFph/ttFwrfEP/JWR6piTnG13LANSMaYTqNyLNW8J8TptNofOoLl6Z6PIyoQS7weH0sB3okz5SZePX4urX/ux5GkAm8zDUZ02t/zXTCO4KIrLAMb765mniQgVen4Y/j/JB94EXrfLHMs0/wac+/pzMdw1Q3qfhaIMhfvZPCG8k+9Fy6eS9TC+f3mtSYHfYASfiskPw3RG0e899RW5UbXdac0luDAAaOPrR/bo/2sy3/TLeIQiDOixrGnjVkAZZJtPstL6mJJCd0UBY958ffeRQw2fyiReDRPVGyWHo45Ucgh5VjZaDn+PVjF1QbuzodNmhq0QQOQ
 ysab8KlS
 Pb5JfHtsn7tEdrpfDRJzLMl01MaUBwdXj6joYLJKIGkXc7xO4iMT3xQ0u9hKwkkaN62VAq4k0dHQMqfI1wUHQbP5u3rvl4CbGvCz6bQGuYmgotz6sXwBgp9aygyLOHuVLPvgCKASueAdfGytKdwfTNqWlVYYXOAMKgRjYlQDi4vUzI1y54+GwnmLP7Jv/Nqx8J2h0RAkPo/MNFwZ0zMKiq2fYw6WlPLIhItACefzFSdcLXamx5a7t6WkpvZ8CqY9+NDPjn7KlsK2+erQbTXffyjh4uCOSdzGg8UJzjPt9KNOk0x5B7WMqNNGJvCzUZG0NP4JjVCBJE0G5A2UDa4NvazrqdYTOxx/nnUMvC7gRZNd774Lb056wPWJqPay75wRKa8w6yxAxXzI2H4lAVcvNQfhqaDtc07vBb7bXQzCpNzPQLe/YYI6Xw7jcKu+6P04UpTAK2rngaPsUiUsNGAtHsiFN2jWGYGO5Yp2y3AfDHRMW/Gsp/wjuqA+XEuqKJqoD9MvGcaf0zMzPIUvmVANPcVPtelEfJeV4pI4bzSCBNWKpaqV0naK2Hb61Xz1/88JSu2Gs+XgmKzH8cGJ74gHCLWzHRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming VFIO live update feature needs to access various helper
functions for its logic which are not exported by default.

Export these functions and variable for other modules to use them.
Remove static from their declaration and add them in
include/linux/vfio.h and drivers/vfio/pci/vfio_pci_priv.h header files.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci.c      | 2 +-
 drivers/vfio/pci/vfio_pci_core.c | 6 ++++--
 drivers/vfio/pci/vfio_pci_priv.h | 5 +++++
 drivers/vfio/vfio_main.c         | 3 ++-
 include/linux/vfio.h             | 1 +
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0c771064c0b8..1fb4b276afe7 100644
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
index 3c8b990ee92f..f31e59e5badb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -623,7 +623,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
-static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct pci_dev *bridge;
@@ -674,6 +674,7 @@ static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
 out_restore_state:
 	pci_restore_state(pdev);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_try_reset);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
@@ -1657,7 +1658,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
-static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
+void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_device *core_vdev = &vdev->vdev;
 	loff_t start = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
@@ -1666,6 +1667,7 @@ static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 
 	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_zap_bars);
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
 {
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index fca9d0dfac90..85bc1666cb0e 100644
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
@@ -73,6 +75,9 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					u16 cmd);
 
+void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev);
+
 #ifdef CONFIG_VFIO_PCI_IGD
 bool vfio_pci_is_intel_display(struct pci_dev *pdev);
 int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5e0422014523..2437af031169 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1467,7 +1467,7 @@ const struct file_operations vfio_device_fops = {
 #endif
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1475,6 +1475,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 31b826efba00..cf0d941d0410 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -378,6 +378,7 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+struct vfio_device *vfio_device_from_file(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.55.0.795.g602f6c329a-goog


