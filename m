Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09321C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2DE6B016E; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D0C6B0174; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5056B0173; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B20D76B0171
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 569C91C1A07
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:52:35 +0000 (UTC)
X-FDA: 84944581470.11.B33452A
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C806100007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:52:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Gms9Ke7V;
	spf=pass (imf14.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014753;
	b=kH+lUDdPuKH8W/qSh4ywcTppae16dVo/BDGTaspBfqUiJyau6oBy7YkVP3/LTNGkQyZi2z
	8QlHg3P4ezmREYNgwxOfX4rT7SFzqSTHYo8S9KBx3QP+uUgNlTJadgUUyGEJofz5uPsw/K
	2xw/v0ikqCqII6I/qmk2ASogMRzfdHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZpJWU7bWP3TnMKbhRD4tSanxWL1/wKELMMx2GijRAo=;
	b=ZNIHQXarDOATOTud8B9BoM3a9dycT9B4QqzoHD87nDBbRnWCmI8WhaOFS4GuLKT+Pzg9/Y
	WXkMAkGAB6UsfBq+aqaeiiyI3kvyQqqlXnsGbrQARThScxLddVFwNVNEczM2w/FGm0pbm7
	5JgIE9iwTO/lPz5U5WensBreaV05ipQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Gms9Ke7V;
	spf=pass (imf14.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014753; x=1814550753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZpJWU7bWP3TnMKbhRD4tSanxWL1/wKELMMx2GijRAo=;
  b=Gms9Ke7VlnKEQYBMpH+OKoYudce3TEbmaP1B/4+bsLniSWkvzaUE4Wsw
   QrV//XlGbDO6AmMl3apP6QSBuU8pgaOBlP1cYQQGYqcbOZNyZeINXcCtK
   oZWeNr6yQ9sHAMtrPFnr5hbENC0ERoU+GvdkzSSeZ0W/j/SFhYgnbl0Zq
   wJD1UyFvRZDqj3Bdir/gtVB95OTLlsnkVMCsV32ebYzVGKUkD/f75T/BE
   yNYE270GQJnvEbIPGpTRUIU1Tj6hHabOK4YJr72QyciSNqelsO4R55Oy4
   0t4kOoePw72yhfKzyIlb0/3z6t6C0nzF4ZPW1lThwT29fIsk9grYY9jU9
   w==;
X-CSE-ConnectionGUID: SR24hoQITuOMAJzVJBVdIA==
X-CSE-MsgGUID: ZJWhzoOhQFuQi+2qvaoZLg==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22928692"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:52:29 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:14188]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.237:2525] with esmtp (Farcaster)
 id 625d448e-6f93-4707-9a43-6fd4341498e2; Thu, 2 Jul 2026 17:52:29 +0000 (UTC)
X-Farcaster-Flow-ID: 625d448e-6f93-4707-9a43-6fd4341498e2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:52:28 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:52:26 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 08/14] PCI/sysfs: migrate to device_sysfs_entry, defer physfn symlink
Date: Thu, 2 Jul 2026 19:51:08 +0200
Message-ID: <20260702175114.24659-4-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C806100007
X-Stat-Signature: 75dmf5knm1nji784df5qt7d36489t3xh
X-HE-Tag: 1783014752-561576
X-HE-Meta: U2FsdGVkX18LH4V8ZFs36SMTHYUS9CR/rjLvmkn4dZPd09IAMgW3/Ik6kKVemBG5NttRrymh4lQJFAyYWFMnttJ2PJy16qMWnU/Cln5cvzOokdQBbb+6UPnS38yVEkhx7GVUqeIK+wpU0QKJwquoPHpFDdm2xocJJeoT/TX/p0lm837fnUp6kWabRKczP64pu1xV06cf3J2Tq680JzUHl6WuiG+OuS1eFsdeQHnU/bHoXw/sN7m2bl/N5zrAW4UHcKIy4r0xh/RlRMgSWDC/lF0RxgeOG0J3UI5zQEGZYOns5uADw6EZNkNtOF/WZHldLQ/UWLRHdMCMQi5/FShVQjf30KbjZAwyFz7Su8nia96T+85bEzfmUm7UESOKtxMS8fcaX/QuYStvpqmv7hd4xgkqOGr9AezVGVVPbtwDHRRbKGxe69JrO8YCCj+bZl2TjnZXKQTlDdBzGV9L5IaYF63j9hdsssF5UR3Eje3P1phGUeSnHrqabpzctCshMj2CcrpPJVW0bHiFXTX+tE39LcrlPVGYUbXoJemhKZGCTHJJwzS1xk6eysBTRzJ3ycHS+0kF0fBpMBxzzd9LKPxjK+EPghlZgav+gksBbSdp20QpB7ERKpQHUcAXHgsrGQNQxFzPraOCcygOOxsMdRuPhgnjtC7vogpfl2jiEvYsHLkWEai/TuzNUYQh5J7VLEeblD7ZVwBIGaEAwQ4s9TcYQyNcet1CfObgc2BMuttfEiTe5z30hisPxmqvzUQCZCPb1071ZDYxH6LxdCG+ZtcrcMj4C1ekGxiMkU5YhO40LHGjIgP8RYGL0MwpzMcAlsSNNRMWaZaGte3/ddZa92Wpe+27JqW9PJ2dubOrdgx+MnbjO7C/CeByM1dg6tRwRV5o/olgoMF2n+mgqwU3XGU/nWWeyZpaZnNWQ8PqynRRn05Jq7UVYWdSRiyQcfWmGUlsfz1TXPYZUCtNbyNvgfS
 FlURAuy2
 HnEtW9BbvnX3Rf0m1QZ3xz7L1qF2lY5mnAJLvDoDM5Kt5GRmMS6W4qShV/6lEWN9bx/wlYKWV7EAHC5p/iP+yj0EEg3OiOWJkkJMHPHTqrheiQzG+hjDMUjstc+dXZ5qcqGhOpHnwidnxEYrLsQAu52MeVLBzAGliitFPvtBUS3ATX9d8qRgyn+5Pn1cBQO+7G/SpSo9ejxAd9+NQfnQEaDBMwOc0m+to36rhBfAsl9YDaLJih9oob34sEPPT7m3BGxFdyJ97vA4lDTHSwy4t/5OsqQnKjl5QhgAkp7ikTZ9lfgdMkGWVLaUvPy+ZGTMroDT7feGaojOLzHsedKj6/puJHfkWLEKY72kJ2s3LKYq9nk7lQBSddSCZ6NvdaKUdc7apqtcPm5GLs0kY15eWoCsKVjwKAG1/mbC4/PTc7ZRD2uy8KDNtQG+Bjdkurmh7AqT1OB4Zpfl1zw1Q11jaQPDFkXuTZZ6wcWgcYPdmKX0U0sXEC1A+OVSgzrN3BMGXuxVubGcDoHGMK6TFwlB4DCtMXVwkQvaLIbCf019QOOmpeieg7/09nsccoYPxzNWMHF95h1RFN3sHb9pAQ4WeclIqHI6CjbxGRDb+aLGk0fMlpJBZX72upbMJZRU7nnOEKKKBzw84HXpSi8a4r7Q2tZioEWxEVNx3xhTc4CztVKGO4eI3HNOg3CeSb0NCN/GkEjOk/eMR8iG/CXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migrate PCI's per-device sysfs to the declarative walker, and as
part of that wire the bus/type dispatch chain via two new struct
device_type hooks.

  - struct device_type grows .populate / .populate_all hooks
    consulted by device_ktype_populate_one /
    device_ktype_populate_all when the driver-core walker returns
    -ENOENT.

  - PCI's bus/type-owned per-device sysfs content (resource%u /
    resource%u_wc files plus the physfn back-symlink) becomes
    pci_sysfs_entries[] and is dispatched by the same walker.

  - Lazy populate skips eager pci_create_sysfs_dev_files() so VFs
    materialise their resource files only on first userspace
    access.

The physfn symlink moves from per-device add to the wildcard row
on the VF; eager devices still see no change. Idempotent
re-creation is required by the VF lookup-then-readdir VFS order;
sysfs_kn_exists() provides the existence check.

No userspace ABI change.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: linux-api@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/base/core.c     |  10 ++-
 drivers/pci/iov.c       |   5 --
 drivers/pci/pci-sysfs.c | 149 ++++++++++++++++++++++++++++++++++++----
 drivers/pci/pci.h       |   5 ++
 drivers/pci/probe.c     |   4 +-
 include/linux/device.h  |  32 ++++++---
 6 files changed, 175 insertions(+), 30 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 15a2dcf922d4b..6c5d1bb66c8f4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2811,9 +2811,9 @@ device_sysfs_entries_end(const struct device_sysfs_entry *entries)
 	return e;
 }
 
-static int device_sysfs_apply(struct device *dev,
-			     const struct device_sysfs_entry *entries,
-			     enum dev_sysfs_action action, const char *name)
+int device_sysfs_apply(struct device *dev,
+		      const struct device_sysfs_entry *entries,
+		      enum dev_sysfs_action action, const char *name)
 {
 	const struct device_sysfs_entry *e;
 
@@ -2983,6 +2983,8 @@ static int device_ktype_populate_one(struct kobject *kobj, const char *name)
 	}
 	ret = device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
 				DEV_SYSFS_ADD_ONE, name);
+	if (ret == -ENOENT && dev->type && dev->type->populate)
+		ret = dev->type->populate(dev, name);
 out:
 	mutex_unlock(&dev->sysfs_lazy->lock);
 	return ret;
@@ -3011,6 +3013,8 @@ static void device_ktype_populate_all(struct kobject *kobj)
 
 	device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
 			  DEV_SYSFS_ADD_ALL, NULL);
+	if (dev->type && dev->type->populate_all)
+		dev->type->populate_all(dev);
 
 
 	device_sysfs_set_populated(dev);
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 91ac4e37ecb9c..ec2fca8209593 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -212,16 +212,11 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
 	if (rc)
 		goto failed;
-	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
-	if (rc)
-		goto failed1;
 
 	kobject_uevent(&virtfn->dev.kobj, KOBJ_CHANGE);
 
 	return 0;
 
-failed1:
-	sysfs_remove_link(&dev->dev.kobj, buf);
 failed:
 	return rc;
 }
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d37860841260c..5a779ebaee326 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1247,6 +1247,13 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	res_attr->attr.mode = 0600;
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = (void *)(unsigned long)num;
+
+	/* Idempotent: skip if a concurrent populate already created this slot. */
+	if (sysfs_kn_exists(&pdev->dev.kobj, res_attr->attr.name)) {
+		kfree(res_attr);
+		return 0;
+	}
+
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
 	if (retval) {
 		kfree(res_attr);
@@ -1264,8 +1271,6 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
  * @pdev: dev in question
- *
- * Walk the resources in @pdev creating files for each resource available.
  */
 static int pci_create_resource_files(struct pci_dev *pdev)
 {
@@ -1283,21 +1288,65 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-		retval = pci_create_attr(pdev, i, 0);
+		/* Skip slots already materialised by populate_one(). */
+		if (!pdev->res_attr[i]) {
+			retval = pci_create_attr(pdev, i, 0);
+			if (retval) {
+				pci_remove_resource_files(pdev);
+				return retval;
+			}
+		}
 		/* for prefetchable resources, create a WC mappable file */
-		if (!retval && arch_can_pci_mmap_wc() &&
-		    pdev->resource[i].flags & IORESOURCE_PREFETCH)
+		if (arch_can_pci_mmap_wc() &&
+		    pdev->resource[i].flags & IORESOURCE_PREFETCH &&
+		    !pdev->res_attr_wc[i]) {
 			retval = pci_create_attr(pdev, i, 1);
-		if (retval) {
-			pci_remove_resource_files(pdev);
-			return retval;
+			if (retval) {
+				pci_remove_resource_files(pdev);
+				return retval;
+			}
 		}
 	}
 	return 0;
 }
+
+/*
+ * Resolve "resourceN" / "resourceN_wc" and create the single file.
+ * Returns -ENOENT for unrelated names or out-of-range/empty BARs so
+ * the walker continues to the next entry.
+ */
+static int pci_create_resource_file_by_name(struct pci_dev *pdev,
+					     const char *name)
+{
+	unsigned int num;
+	int wc = 0;
+	int n = 0;
+
+	if (sscanf(name, "resource%u%n", &num, &n) != 1)
+		return -ENOENT;
+	if (name[n]) {
+		if (strcmp(name + n, "_wc"))
+			return -ENOENT;
+		wc = 1;
+	}
+
+	if (num >= PCI_STD_NUM_BARS || !pci_resource_len(pdev, num))
+		return -ENOENT;
+
+	if (wc && (!arch_can_pci_mmap_wc() ||
+		   !(pdev->resource[num].flags & IORESOURCE_PREFETCH)))
+		return -ENOENT;
+
+	return pci_create_attr(pdev, num, wc);
+}
 #else /* !(defined(HAVE_PCI_MMAP) || defined(ARCH_GENERIC_PCI_MMAP_RESOURCE)) */
 int __weak pci_create_resource_files(struct pci_dev *dev) { return 0; }
 void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
+static int pci_create_resource_file_by_name(struct pci_dev *pdev,
+					     const char *name)
+{
+	return -ENOENT;
+}
 #endif
 
 /**
@@ -1661,26 +1710,88 @@ static const struct attribute_group pci_dev_resource_resize_group = {
 	.is_visible = resource_resize_is_visible,
 };
 
+/* Per-device PCI sysfs catalogue. */
+
+/* physfn back-symlink - SR-IOV VF only. */
+
+#ifdef CONFIG_PCI_IOV
+
+static bool pci_applies_to_virtfn(struct device *dev)
+{
+	return to_pci_dev(dev)->is_virtfn;
+}
+
+static int pci_create_physfn_link(struct device *dev, const char *name)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, "physfn"))
+		return 0;
+
+	return sysfs_create_link(&dev->kobj, &pdev->physfn->dev.kobj, "physfn");
+}
+
+#endif /* CONFIG_PCI_IOV */
+
+/* resource%u[_wc] family - wildcard row, create() dispatches on @name. */
+
+static int pci_create_resource(struct device *dev, const char *name)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (!name)
+		return pci_create_resource_files(pdev);
+
+	return pci_create_resource_file_by_name(pdev, name);
+}
+
+static void pci_remove_resource(struct device *dev)
+{
+	pci_remove_resource_files(to_pci_dev(dev));
+}
+
+static const struct device_sysfs_entry pci_sysfs_entries[] = {
+#ifdef CONFIG_PCI_IOV
+	{
+		.name		= "physfn",
+		.applies_to	= pci_applies_to_virtfn,
+		.create	= pci_create_physfn_link,
+	},
+#endif
+	{
+		/* wildcard: "resource%u" / "resource%u_wc" family */
+		.create	= pci_create_resource,
+		.remove		= pci_remove_resource,
+	},
+	{ }, /* sentinel: .create == NULL */
+};
+
 int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
 {
 	if (!sysfs_initialized)
 		return -EACCES;
 
-	return pci_create_resource_files(pdev);
+	return device_sysfs_apply(&pdev->dev, pci_sysfs_entries,
+				 DEV_SYSFS_ADD_ALL, NULL);
 }
 
 /**
- * pci_remove_sysfs_dev_files - cleanup PCI specific sysfs files
+ * pci_remove_sysfs_dev_files - cleanup PCI sysfs files for @pdev
  * @pdev: device whose entries we should free
- *
- * Cleanup when @pdev is removed from sysfs.
  */
 void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 {
 	if (!sysfs_initialized)
 		return;
 
-	pci_remove_resource_files(pdev);
+	device_sysfs_apply(&pdev->dev, pci_sysfs_entries,
+			  DEV_SYSFS_REMOVE_ALL, NULL);
 }
 
 static int __init pci_sysfs_init(void)
@@ -1835,3 +1946,15 @@ const struct attribute_group *pci_dev_attr_groups[] = {
 #endif
 	NULL,
 };
+
+int pci_dev_type_populate_one(struct device *dev, const char *name)
+{
+	return device_sysfs_apply(dev, pci_sysfs_entries,
+				 DEV_SYSFS_ADD_ONE, name);
+}
+
+void pci_dev_type_populate_all(struct device *dev)
+{
+	device_sysfs_apply(dev, pci_sysfs_entries,
+			  DEV_SYSFS_ADD_ALL, NULL);
+}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4a14f88e543a2..9c884a158184c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -395,6 +395,8 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 #ifdef CONFIG_SYSFS
 int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
+int pci_dev_type_populate_one(struct device *dev, const char *name);
+void pci_dev_type_populate_all(struct device *dev);
 extern const struct attribute_group *pci_dev_groups[];
 extern const struct attribute_group *pci_dev_attr_groups[];
 extern const struct attribute_group *pcibus_groups[];
@@ -403,6 +405,9 @@ extern const struct attribute_group pci_doe_sysfs_group;
 #else
 static inline int pci_create_sysfs_dev_files(struct pci_dev *pdev) { return 0; }
 static inline void pci_remove_sysfs_dev_files(struct pci_dev *pdev) { }
+static inline int pci_dev_type_populate_one(struct device *dev,
+					    const char *name) { return -ENOENT; }
+static inline void pci_dev_type_populate_all(struct device *dev) { }
 #define pci_dev_groups NULL
 #define pci_dev_attr_groups NULL
 #define pcibus_groups NULL
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b63cd0c310bc0..ff7e6016c896f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2499,7 +2499,9 @@ static void pci_release_dev(struct device *dev)
 }
 
 static const struct device_type pci_dev_type = {
-	.groups = pci_dev_attr_groups,
+	.groups		= pci_dev_attr_groups,
+	.populate	= pci_dev_type_populate_one,
+	.populate_all	= pci_dev_type_populate_all,
 };
 
 struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
diff --git a/include/linux/device.h b/include/linux/device.h
index c0a2ee429280c..948c3ea8055e5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -118,14 +118,27 @@ struct device_sysfs_entry {
 	void (*remove)(struct device *dev);
 };
 
-/*
- * The type of device, "struct device" is embedded in. A class
- * or bus can contain devices of different types
- * like "partitions" and "disks", "mouse" and "event".
- * This identifies the device type and carries type-specific
- * information, equivalent to the kobj_type of a kobject.
- * If "name" is specified, the uevent will contain it in
- * the DEVTYPE variable.
+int device_sysfs_apply(struct device *dev,
+		      const struct device_sysfs_entry *entries,
+		      enum dev_sysfs_action action, const char *name);
+
+/**
+ * struct device_type - The type of device, embedded in struct device.
+ * @name:     if set, appears in the DEVTYPE uevent variable.
+ * @groups:   attribute groups always present on devices of this type.
+ * @uevent:   type-specific uevent handler (may set DEVTYPE or other).
+ * @devnode:  populate /dev node metadata (mode, uid, gid).
+ * @release:  release callback run after the last reference drops.
+ * @pm:       dev_pm_ops vector for devices of this type.
+ * @populate: lazy ADD_ONE for type-owned synthetic attrs/symlinks.
+ *            Called from kernfs populate; device_lock NOT held; may
+ *            sleep. Returns -ENOENT for unknown names.
+ * @populate_all: readdir-time counterpart; best-effort, retry-safe.
+ *
+ * A class or bus can contain devices of different types like
+ * "partitions" and "disks", "mouse" and "event". This identifies
+ * the device type and carries type-specific information, equivalent
+ * to the kobj_type of a kobject.
  */
 struct device_type {
 	const char *name;
@@ -136,6 +149,9 @@ struct device_type {
 	void (*release)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
+
+	int  (*populate)(struct device *dev, const char *name);
+	void (*populate_all)(struct device *dev);
 };
 
 /**
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


