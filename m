Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71573C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA436B0131; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ACD6B0135; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5786B0139; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE4386B0131
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:59:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1B42A0237
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:52:32 +0000 (UTC)
X-FDA: 84944581344.16.64DC575
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97BF620009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:52:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ktoOoLqF;
	spf=pass (imf03.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014750;
	b=FGKPaStuHbpCCdMTwbBJUSBV1x4PxQe1+71MxPuotyZ62s1VIoDxUwVwrAjrEo8Hhglv8z
	/wdTbHNfXNByCE9p0VDcERoIs8b9ym0EfDxnoPTS7lxLVyfQ9RbBWBE6LBxt/fv9HmiUaj
	9whiCa3CmiPLFnLIws/8fXmUO4Khybw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxIxQ6sd0HIaZszAs69MPmohJ488piDlmBi7gszGRjI=;
	b=HYgnbZdfF/pccZTBRELl0SoF6iL7XFRNL1VfKcCKu6kBJma48WCGrQXIU7rpYD9Mqluv8V
	TGHRKfULqZvaaUQSbXB/7ytdKPgmxObUUVnmbtIS3xnTNn+zjUaqm/JvcdzZiQ/qwQRE9I
	VNUzmj1yWzCRXhyZj4ntKja7FR5Ec70=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ktoOoLqF;
	spf=pass (imf03.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014750; x=1814550750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxIxQ6sd0HIaZszAs69MPmohJ488piDlmBi7gszGRjI=;
  b=ktoOoLqFwtZJ4OlBDhy59wN/gYYPj5wf9yWOnbHjXxEzmSN+YdqobDep
   RefO3NMT4ueQ40kyxL/7+ejQD+PBhno8xqfVg+ot+VOC/TtdSeO4KK2ZB
   I1AEXWiX0LqOPm5mZ3+7oGK8QO8UHtP93TeCGmQ73BEv5tQecLAosa0Zf
   ynMxdsUrnilenqm8CMd9JI3RYkN1f3Arhzc8tcO97f3cn6v+E/5UGUIUb
   YfY0sstuVfLAxvuIUaQrRxTnpWlsC46pGJz+XH+2N/6kG6/TEO1d3xXWj
   r+cU3XMfMBu//IyMYdG6pJnTsiVUcoVuT3e6OC39J2ToSjYmiDEBZBhhA
   A==;
X-CSE-ConnectionGUID: W+AccSSBTBqbltx0ldfFzQ==
X-CSE-MsgGUID: tAwu0UhLQKq7hh3drA1Elg==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22965701"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:52:26 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4969]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.237:2525] with esmtp (Farcaster)
 id 953db913-8e31-472a-a3fd-058bd9bf5b03; Thu, 2 Jul 2026 17:52:26 +0000 (UTC)
X-Farcaster-Flow-ID: 953db913-8e31-472a-a3fd-058bd9bf5b03
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:52:26 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:52:23 +0000
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
Subject: [RFC PATCH 07/14] driver core: migrate device sysfs to device_sysfs_entry table
Date: Thu, 2 Jul 2026 19:51:07 +0200
Message-ID: <20260702175114.24659-3-sakacpav@amazon.de>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 97BF620009
X-Rspam-User: 
X-Stat-Signature: hazzfwnskyd3rmtf9hzjb65rtxmdkd8s
X-HE-Tag: 1783014750-648069
X-HE-Meta: U2FsdGVkX19E+OjLcCpQ3DOZ9JkiQXDKreEF08MjEo5WGZou9JYfZ2mXltoQ2GYYNoHIWTjAhzUHIQIVR+yrXZjbnFMpfHe7n4Y+SPUSpX5JEmNbDSPIcnIgSIYe56o/XNu1XNR8uc0VZzhT7LcPr6F+WrDx4ocrU5MOwnfNtdrdMSMPNfgT16y8vc83SybP8IsJX1ljH8euoBAOmOQwsb6sZ9X1tmhjmV/Bfg7HnTAfiD+zNp+VK3+E8Z8xt4ZDja8E+b8MCuxHXfoq15y+H/W9GYe0Lw1Vh8IEWKbn3qrr8n8tqPxPonMUje9FHmy9Xp9PoooYS89xonwIBBswbM1fkhW4PtVKNxKn7NZAPA51Rkak5hhLklB8dQTnhEfFBhDK9Oq6JCYtlMmq0GT0Jz/gairHPF6VBNBpv+1DK5uURiQj/9B0ItekOml0W6+GmSLH2L0v4fIrD8N/lS0rk2qT9wTNAxPzJF/5sI7zlE52kDZ9yBi66gWuTh6iKi/wYYmgAR9YIdf+DOWTWaJDcPVng8Fa2xAnrPBUNcESoY6WdIBSJLMPkkfiDHAA8kZH088yyre8gYA45RN1D+9+BsDkFAtdjRezTfUa8XAKOTDWuf4Jj6pmAbVe3U4slke0/35DW5r7Mt4MVU7pdREAblpL/KneB086Kv2FNmh8DqpDLZ5WHQMTu/dadR4f46RBLq6z4DAo0sQG+36KOpm8Bm+99JiEp31JhU61B5fqRbX88VcxhfIP1M9mGR3A4Q3BAB5ukNRL0msHTxFZst+2m2L1sKieOZsTAd/P4w9tBfH0gtiG9eafcCMxnlgP8gPc8hnFGFp41+c6ojQE/YorgEYKZA/0Lu3GtRmRj3n98/qwWaqlPJm1BCqdawReC+MO8tey0a/KQ52koA7I8J5UH1ylcz30dgnXwQAmnbNT/mn1KvRX4lnh1PbBAN9HpkWRQ3KiJY7p6RJloWXpNx1
 0C92ZBha
 k6ua35J8n54YNAUGQZM+889ymCfwe6wAnl4Div/7abRnxD0x0/SAZ8ynicEoTiORXBkmL73q6TNMW6upIQ6UhPgDvex6XNk0mOCJ4rDCWit3fgNEHiJUL0vJCMDNd5Mei6xnIFQf/eiXBopPFGIeTB/xrL/GNzQbhmMRKEIhS/yXuhwlMe9G8sa2kwwKp7VRLTrKe6kYEP8UkYXTR62Mkuaws888hmr3gLBlhKNGM3eljVpHlxE6feYW2W266q7zeLPydPNUnOBFfnQ/bIdzNhdCt6O7NVz3UBvKcBeJJs1s5wVluEOauMceSWcWlciUp/hnka5Dwsc5coLQicTK6/3QnqsoznmhHdqUpRTBV4NXKyvQNxMw2v/LPeeKAWLIuTNNq2FCJjyCd7GJF0L+7P8nfb/7rgs+5oH1LymZchnHPW5lHrVCQOAuSpMCGEaTG9IWW62p33SwHBYRssVICL0SRgmLaZQ2WZqWI9xCXJnYQHPX/nrhUHSHx1XdfOehFVcVtp7MQZtzlsYltYoGFr2J9qvtMqvxJLwsR2lMFsfGn/UDwvWT5ZeJum1YJuEjlzKez8J5NbEm+FHuevSYaMIHrwHSFKlzEqVTI3rAiNuyXbxz/yUJhfTZNKrGYiy/8TEVkQ8wsnZTBK3lsMZzpUOX2A6nYTQg9rlxO6g5lyGzwqZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migrate driver-core-owned per-device sysfs to the declarative table
introduced earlier in this series.  Every standalone file, synthetic
symlink, and attribute_group source visible at the top of /sys/<dev>/
becomes one row in driver_core_sysfs_entries[].  Row order matches
the eager device_add() readdir(3) order (ABI).  The walker runs
ADD_ALL forward in device_add() and REMOVE_ALL reverse in
device_del().

power/ stays eager.  dpm_sysfs_add() runs unconditionally from
device_add(), for lazy devices too.  In-kernel callers
(wakeup_sysfs_add(), dev_pm_qos_*()) sysfs_merge_group() into an
existing power/ directory at driver bind, before any userspace
access, so deferring power/ would break those merges.  device_add()
sets ->power_added on lazy devices; the power/ table row then no-ops
in create_power() (the latch is already set) and remove_power() is
its reverse-order teardown pair, calling dpm_sysfs_remove() only
when power/ was actually added.  Eager devices (->sysfs_lazy == NULL)
also get power/ at device_add() time, and create_power() returns
early for them.

device_del REMOVE_ALL.  device_del() and the SysEntryError unwind
path drop the imperative dpm_sysfs_remove() call and reverse the
table via REMOVE_ALL.  As a consequence the power/ subtree is now
torn down LAST (it is declared FIRST in the table and the walker
runs in reverse on REMOVE_ALL); the device is already dead
(dev->p->dead under device_lock) before the walker runs, so no
caller can observe a partially-torn-down state.

bus_add_device / bus_remove_device.  The bus's dev_groups and the
dev->kobj/subsystem symlink are now materialised by walker rows
(create_bus_groups, create_bus_subsystem_link).
bus_add_device() and bus_remove_device() keep only the bus-
directory back-link (sp->devices_kset->kobj/<devname>) which
targets a kobject other than dev->kobj and therefore cannot be a
per-device row.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: driver-core@lists.linux.dev
Cc: linux-api@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/base/bus.c     |  41 ++-
 drivers/base/core.c    | 708 +++++++++++++++++++++++++++++++----------
 fs/sysfs/sysfs.h       |   1 +
 include/linux/device.h |  50 +--
 4 files changed, 578 insertions(+), 222 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8b6722ff8590d..4ca1bd0cf4904 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -563,34 +563,35 @@ int bus_add_device(struct device *dev)
 
 	pr_debug("bus: '%s': add device %s\n", sp->bus->name, dev_name(dev));
 
-	error = device_add_groups(dev, sp->bus->dev_groups);
+	error = sysfs_create_link(&sp->devices_kset->kobj, &dev->kobj, dev_name(dev));
 	if (error)
 		goto out_put;
 
 	if (dev->bus->driver_override) {
 		error = device_add_group(dev, &driver_override_dev_group);
 		if (error)
-			goto out_groups;
+			goto out_kset;
 	}
 
-	error = sysfs_create_link(&sp->devices_kset->kobj, &dev->kobj, dev_name(dev));
-	if (error)
-		goto out_override;
-
-	error = sysfs_create_link(&dev->kobj, &sp->subsys.kobj, "subsystem");
-	if (error)
-		goto out_subsys;
+	/*
+	 * The bus's dev_groups and the dev->kobj/subsystem symlink
+	 * are created by the driver-core walker through the
+	 * bus-groups wildcard row and the bus-bound "subsystem" row
+	 * of driver_core_sysfs_entries[] (see create_bus_groups()
+	 * and create_bus_subsystem_link() in drivers/base/core.c);
+	 * teardown runs through the REMOVE_ALL walker call in
+	 * device_del(). Only the bus-directory back-link
+	 * (sp->devices_kset->kobj -> dev->kobj, named after the
+	 * device) stays here - it targets a kobject other than
+	 * dev->kobj and therefore does not belong on the per-device
+	 * walker.
+	 */
 
 	klist_add_tail(&dev->p->knode_bus, &sp->klist_devices);
 	return 0;
 
-out_subsys:
+out_kset:
 	sysfs_remove_link(&sp->devices_kset->kobj, dev_name(dev));
-out_override:
-	if (dev->bus->driver_override)
-		device_remove_group(dev, &driver_override_dev_group);
-out_groups:
-	device_remove_groups(dev, sp->bus->dev_groups);
 out_put:
 	subsys_put(sp);
 	return error;
@@ -644,11 +645,17 @@ void bus_remove_device(struct device *dev)
 			sif->remove_dev(dev, sif);
 	mutex_unlock(&sp->mutex);
 
-	sysfs_remove_link(&dev->kobj, "subsystem");
+	/*
+	 * dev->kobj/subsystem and the bus's dev_groups are torn
+	 * down by the driver-core REMOVE_ALL walker call in
+	 * device_del() (reverse order over
+	 * driver_core_sysfs_entries[]); only the bus-directory
+	 * back-link sp->devices_kset->kobj/<devname> is removed
+	 * here because it targets a kobject other than dev->kobj.
+	 */
 	sysfs_remove_link(&sp->devices_kset->kobj, dev_name(dev));
 	if (dev->bus->driver_override)
 		device_remove_group(dev, &driver_override_dev_group);
-	device_remove_groups(dev, dev->bus->dev_groups);
 	if (klist_node_attached(&dev->p->knode_bus))
 		klist_del(&dev->p->knode_bus);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 975b6e0c4dabd..15a2dcf922d4b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2556,12 +2556,15 @@ static void device_release(struct kobject *kobj)
 	 */
 	devres_release_all(dev);
 
+	kfree(dev->dma_range_map);
+	kfree(dev->physical_location);
+	kfree(dev->driver_override.name);
+
+	/* Free per-device lazy state; kfree(NULL) handles never-opted-in. */
 	if (dev->sysfs_lazy)
 		mutex_destroy(&dev->sysfs_lazy->lock);
 	kfree(dev->sysfs_lazy);
-
-	kfree(dev->dma_range_map);
-	kfree(dev->driver_override.name);
+	dev->sysfs_lazy = NULL;
 
 	if (dev->release)
 		dev->release(dev);
@@ -2575,40 +2578,6 @@ static void device_release(struct kobject *kobj)
 	kfree(p);
 }
 
-/*
- * device_sysfs_apply() - declarative per-device sysfs dispatch
- *
- * Single walker over a sentinel-terminated struct device_sysfs_entry
- * table. Intended to be invoked on every dispatch path (device_add
- * eager, lazy populate_one, lazy populate_all, device_del teardown)
- * so adding a new per-device file is one row, not four open-coded
- * branches. Shape follows cftype + cgroup_addrm_files
- * (kernel/cgroup/cgroup.c) and pci_sysfs_entries[]
- * (drivers/pci/pci-sysfs.c).
- *
- * ADD_ONE:  first row whose applies_to passes and whose name matches
- *	     (or a wildcard row whose create() does not return
- *	     -ENOENT) terminates the walk. -ENOENT from a wildcard
- *	     row's create() signals "not my name"; the walker
- *	     continues. Realize callbacks MUST check existence (via
- *	     sysfs_*_exists()) before calling sysfs_create_*() and
- *	     return 0 if the entry already exists. Reaching
- *	     __kernfs_create_*() for a name that another lazy path
- *	     just created is forbidden under lock
- *	     serialization. If sysfs_warn_dup() ever fires from a
- *	     lazy path, it indicates a lock invariant
- *	     violation or a non-lazy path creating lazy attrs (bug).
- * ADD_ALL:  every applicable row's create() fires with name = NULL;
- *	     per-row errors are best-effort - the walker discards
- *	     return values and rows log via their own diagnostics.
- * REMOVE_ALL: reverse row order; remove() fires for every row whose
- *	     applies_to passes. Teardown never aborts.
- *
- * The full walker contract (error-absorption matrix, interaction
- * with negative-dentry caching, lifecycle caveats) is documented in
- * Documentation/driver-api/sysfs-lazy.rst, added later in this
- * series.
- */
 /*
  * Create one named attr inside @grp; honours grp->is_visible.
  * Returns 0 on success/hidden/already-present, -ENOENT on no-match.
@@ -2990,12 +2959,32 @@ static int device_ktype_populate_one(struct kobject *kobj, const char *name)
 	const struct kobj_type *ktype = dev->kobj.ktype;
 	int ret;
 
-	/* Device is being torn down; do not populate. */
-	if (dev->p->dead)
+	/* KERNFS_LAZY implies dev->sysfs_lazy was allocated by device_set_sysfs_lazy(). */
+	if (WARN_ON_ONCE(!dev->sysfs_lazy))
+		return -ENOENT;
+
+	/* Fast path: directory fully walked, kernfs has authoritative state. */
+	if (device_sysfs_populated(dev))
 		return -ENOENT;
 
+	mutex_lock(&dev->sysfs_lazy->lock);
+	/* Re-check under the lock against a concurrent populate_all. */
+	if (device_sysfs_populated(dev)) {
+		ret = -ENOENT;
+		goto out;
+	}
+	/*
+	 * FIXME: dev->p->dead is device_lock-protected and a bitfield (so not
+	 * READ_ONCE()-able); this lockless re-check is a benign KCSAN data race.
+	 */
+	if (dev->p->dead) {
+		ret = -ENOENT;
+		goto out;
+	}
 	ret = device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
 				DEV_SYSFS_ADD_ONE, name);
+out:
+	mutex_unlock(&dev->sysfs_lazy->lock);
 	return ret;
 }
 
@@ -3004,14 +2993,33 @@ static void device_ktype_populate_all(struct kobject *kobj)
 	struct device *dev = kobj_to_dev(kobj);
 	const struct kobj_type *ktype = dev->kobj.ktype;
 
-	/* Device is being torn down; do not populate. */
-	if (dev->p->dead)
+	/* See device_ktype_populate_one() for the invariant. */
+	if (WARN_ON_ONCE(!dev->sysfs_lazy))
+		return;
+
+	/* Fast path: directory already fully populated. */
+	if (device_sysfs_populated(dev))
 		return;
 
+	mutex_lock(&dev->sysfs_lazy->lock);
+	/* Re-check under the lock. */
+	if (device_sysfs_populated(dev))
+		goto out;
+	/* FIXME: same racy dead read; see device_ktype_populate_one(). */
+	if (dev->p->dead)
+		goto out;
+
 	device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
 			  DEV_SYSFS_ADD_ALL, NULL);
+
+
+	device_sysfs_set_populated(dev);
+out:
+	mutex_unlock(&dev->sysfs_lazy->lock);
 }
 
+static const struct device_sysfs_entry driver_core_sysfs_entries[];
+
 static const struct kobj_type device_ktype = {
 	.release	= device_release,
 	.sysfs_ops	= &dev_sysfs_ops,
@@ -3019,6 +3027,7 @@ static const struct kobj_type device_ktype = {
 	.get_ownership	= device_get_ownership,
 	.populate	= device_ktype_populate_one,
 	.populate_all	= device_ktype_populate_all,
+	.entries	= driver_core_sysfs_entries,
 };
 
 
@@ -3271,6 +3280,25 @@ void device_remove_groups(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_remove_groups);
 
+/* Like device_remove_groups() but skips uncreated named subdirs (lazy). */
+static void device_remove_groups_if_present(struct device *dev,
+				      const struct attribute_group *const *groups)
+{
+	const struct attribute_group *const *g;
+
+	if (!groups)
+		return;
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	for (g = groups; *g; g++) {
+		if ((*g)->name && !sysfs_group_exists(&dev->kobj, *g))
+			continue;
+		sysfs_remove_group(&dev->kobj, *g);
+	}
+}
+
 union device_attr_group_devres {
 	const struct attribute_group *group;
 	const struct attribute_group **groups;
@@ -3317,101 +3345,447 @@ int devm_device_add_group(struct device *dev, const struct attribute_group *grp)
 }
 EXPORT_SYMBOL_GPL(devm_device_add_group);
 
-static int device_add_attrs(struct device *dev)
+static ssize_t dev_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
-	const struct class *class = dev->class;
-	const struct device_type *type = dev->type;
-	int error;
+	return print_dev_t(buf, dev->devt);
+}
+static DEVICE_ATTR_RO(dev);
 
-	if (class) {
-		error = device_add_groups(dev, class->dev_groups);
-		if (error)
-			return error;
-	}
+/* Per-device sysfs catalogue (creation order; reversed on teardown). */
+#define N_DRIVER_CORE_SYSFS_ENTRIES	14
 
-	if (type) {
-		error = device_add_groups(dev, type->groups);
-		if (error)
-			goto err_remove_class_groups;
-	}
+/* applies_to() predicates: cheap, non-sleeping, lock-free. */
+static bool dev_supports_offline_enabled(struct device *dev)
+{
+	return device_supports_offline(dev) && !dev->offline_disabled;
+}
 
-	error = device_add_groups(dev, dev->groups);
-	if (error)
-		goto err_remove_type_groups;
+static bool dev_has_fwnode_devlink(struct device *dev)
+{
+	return fw_devlink_flags && !fw_devlink_is_permissive() &&
+	       dev->fwnode;
+}
 
-	if (device_supports_offline(dev) && !dev->offline_disabled) {
-		error = device_create_file(dev, &dev_attr_online);
-		if (error)
-			goto err_remove_dev_groups;
-	}
+static bool dev_removable_valid(struct device *dev)
+{
+	return dev_removable_is_valid(dev);
+}
 
-	if (fw_devlink_flags && !fw_devlink_is_permissive() && dev->fwnode) {
-		error = device_create_file(dev, &dev_attr_waiting_for_supplier);
-		if (error)
-			goto err_remove_dev_online;
-	}
+static bool dev_has_physical_location(struct device *dev)
+{
+	return !!dev->physical_location;
+}
 
-	if (dev_removable_is_valid(dev)) {
-		error = device_create_file(dev, &dev_attr_removable);
-		if (error)
-			goto err_remove_dev_waiting_for_supplier;
-	}
+static bool dev_has_devt_major(struct device *dev)
+{
+	return MAJOR(dev->devt) != 0;
+}
 
-	if (dev_add_physical_location(dev)) {
-		error = device_add_group(dev,
-			&dev_attr_physical_location_group);
-		if (error)
-			goto err_remove_dev_removable;
-	}
+static bool dev_has_class(struct device *dev)
+{
+	return !!dev->class;
+}
 
-	return 0;
+static bool dev_has_bus_no_class(struct device *dev)
+{
+	return !dev->class && dev->bus;
+}
 
- err_remove_dev_removable:
-	device_remove_file(dev, &dev_attr_removable);
- err_remove_dev_waiting_for_supplier:
-	device_remove_file(dev, &dev_attr_waiting_for_supplier);
- err_remove_dev_online:
+static bool dev_is_class_child(struct device *dev)
+{
+	return dev->class && dev->parent && device_is_not_partition(dev);
+}
+
+static bool dev_has_class_dev_groups(struct device *dev)
+{
+	return dev->class && dev->class->dev_groups;
+}
+
+static bool dev_has_type_groups(struct device *dev)
+{
+	return dev->type && dev->type->groups;
+}
+
+static bool dev_has_own_groups(struct device *dev)
+{
+	return !!dev->groups;
+}
+
+static bool dev_has_bus_dev_groups(struct device *dev)
+{
+	return dev->bus && dev->bus->dev_groups;
+}
+
+static bool dev_needs_pm(struct device *dev)
+{
+	return !device_pm_not_required(dev);
+}
+
+/* Per-row create()/remove() callbacks. */
+static int create_power(struct device *dev, const char *name)
+{
+	int ret;
+
+	/* dpm_sysfs_add() already ran from device_add() on the eager path. */
+	if (!device_is_sysfs_lazy(dev))
+		return 0;
+
+	lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (dev->sysfs_lazy->power_added)
+		return 0;
+
+	/*
+	 * FIXME: unreachable today - device_add() adds power/ eagerly and latches
+	 * power_added for lazy devices too, so the power_added check above wins.
+	 */
+	ret = dpm_sysfs_add(dev);
+	if (!ret)
+		dev->sysfs_lazy->power_added = true;
+	return ret;
+}
+
+static void remove_power(struct device *dev)
+{
+	/* Skip dpm_sysfs_remove() on lazy devices that never materialised power/. */
+	if (device_is_sysfs_lazy(dev) && !dev->sysfs_lazy->power_added)
+		return;
+	dpm_sysfs_remove(dev);
+}
+
+static int create_class_subsystem_link(struct device *dev, const char *name)
+{
+	struct subsys_private *sp;
+	int ret;
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, "subsystem"))
+		return 0;
+
+	sp = class_to_subsys(dev->class);
+	if (!sp)
+		return 0;
+
+	ret = sysfs_create_link(&dev->kobj, &sp->subsys.kobj, "subsystem");
+	subsys_put(sp);
+	return ret;
+}
+
+static void remove_class_subsystem_link(struct device *dev)
+{
+	sysfs_remove_link(&dev->kobj, "subsystem");
+}
+
+static int create_bus_subsystem_link(struct device *dev, const char *name)
+{
+	struct subsys_private *sp;
+	int ret;
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, "subsystem"))
+		return 0;
+
+	sp = bus_to_subsys(dev->bus);
+	if (!sp)
+		return 0;
+
+	ret = sysfs_create_link(&dev->kobj, &sp->subsys.kobj, "subsystem");
+	subsys_put(sp);
+	return ret;
+}
+
+static void remove_bus_subsystem_link(struct device *dev)
+{
+	sysfs_remove_link(&dev->kobj, "subsystem");
+}
+
+static int create_device_backlink(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, "device"))
+		return 0;
+
+	return sysfs_create_link(&dev->kobj, &dev->parent->kobj, "device");
+}
+
+static void remove_device_backlink(struct device *dev)
+{
+	sysfs_remove_link(&dev->kobj, "device");
+}
+
+static int create_uevent(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, dev_attr_uevent.attr.name))
+		return 0;
+
+	return sysfs_create_file_ns(&dev->kobj, &dev_attr_uevent.attr, NULL);
+}
+
+static void remove_uevent(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_uevent);
+}
+
+static int create_online(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, dev_attr_online.attr.name))
+		return 0;
+
+	return sysfs_create_file_ns(&dev->kobj, &dev_attr_online.attr, NULL);
+}
+
+static void remove_online(struct device *dev)
+{
 	device_remove_file(dev, &dev_attr_online);
- err_remove_dev_groups:
-	device_remove_groups(dev, dev->groups);
- err_remove_type_groups:
-	if (type)
-		device_remove_groups(dev, type->groups);
- err_remove_class_groups:
-	if (class)
-		device_remove_groups(dev, class->dev_groups);
+}
 
-	return error;
+static int create_waiting_for_supplier(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, dev_attr_waiting_for_supplier.attr.name))
+		return 0;
+
+	return sysfs_create_file_ns(&dev->kobj,
+				    &dev_attr_waiting_for_supplier.attr,
+				    NULL);
 }
 
-static void device_remove_attrs(struct device *dev)
+static void remove_waiting_for_supplier(struct device *dev)
 {
-	const struct class *class = dev->class;
-	const struct device_type *type = dev->type;
+	device_remove_file(dev, &dev_attr_waiting_for_supplier);
+}
 
-	if (dev->physical_location) {
-		device_remove_group(dev, &dev_attr_physical_location_group);
-		kfree(dev->physical_location);
-	}
+static int create_removable(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
 
+	if (sysfs_kn_exists(&dev->kobj, dev_attr_removable.attr.name))
+		return 0;
+
+	return sysfs_create_file_ns(&dev->kobj, &dev_attr_removable.attr, NULL);
+}
+
+static void remove_removable(struct device *dev)
+{
 	device_remove_file(dev, &dev_attr_removable);
-	device_remove_file(dev, &dev_attr_waiting_for_supplier);
-	device_remove_file(dev, &dev_attr_online);
-	device_remove_groups(dev, dev->groups);
+}
 
-	if (type)
-		device_remove_groups(dev, type->groups);
+static int create_physical_location(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	/* NULL on non-ACPI nodes; safe under kobj reference. */
+	if (!dev->physical_location)
+		return -ENOENT;
 
-	if (class)
-		device_remove_groups(dev, class->dev_groups);
+	if (sysfs_group_exists(&dev->kobj, &dev_attr_physical_location_group))
+		return 0;
+
+	return sysfs_create_group(&dev->kobj, &dev_attr_physical_location_group);
 }
 
-static ssize_t dev_show(struct device *dev, struct device_attribute *attr,
-			char *buf)
+static void remove_physical_location(struct device *dev)
 {
-	return print_dev_t(buf, dev->devt);
+	/* dev->physical_location is freed in device_release(), not here. */
+	device_remove_group(dev, &dev_attr_physical_location_group);
+}
+
+static int create_dev_attr(struct device *dev, const char *name)
+{
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (sysfs_kn_exists(&dev->kobj, dev_attr_dev.attr.name))
+		return 0;
+
+	return sysfs_create_file_ns(&dev->kobj, &dev_attr_dev.attr, NULL);
+}
+
+static void remove_dev_attr(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_dev);
+}
+
+/* Wildcard rows for the four attribute_group sources. */
+static int create_class_groups(struct device *dev, const char *name)
+{
+	if (!dev->class)
+		return -ENOENT;
+	return name ? create_attr_in_groups(dev, dev->class->dev_groups, name)
+		    : create_all_in_groups(dev, dev->class->dev_groups);
+}
+
+static void remove_class_groups(struct device *dev)
+{
+	if (!dev->class)
+		return;
+	if (device_is_sysfs_lazy(dev))
+		device_remove_groups_if_present(dev, dev->class->dev_groups);
+	else
+		device_remove_groups(dev, dev->class->dev_groups);
+}
+
+static int create_type_groups(struct device *dev, const char *name)
+{
+	if (!dev->type)
+		return -ENOENT;
+	return name ? create_attr_in_groups(dev, dev->type->groups, name)
+		    : create_all_in_groups(dev, dev->type->groups);
+}
+
+static void remove_type_groups(struct device *dev)
+{
+	if (!dev->type)
+		return;
+	if (device_is_sysfs_lazy(dev))
+		device_remove_groups_if_present(dev, dev->type->groups);
+	else
+		device_remove_groups(dev, dev->type->groups);
+}
+
+static int create_dev_own_groups(struct device *dev, const char *name)
+{
+	return name ? create_attr_in_groups(dev, dev->groups, name)
+		    : create_all_in_groups(dev, dev->groups);
+}
+
+static void remove_dev_own_groups(struct device *dev)
+{
+	if (device_is_sysfs_lazy(dev))
+		device_remove_groups_if_present(dev, dev->groups);
+	else
+		device_remove_groups(dev, dev->groups);
+}
+
+static int create_bus_groups(struct device *dev, const char *name)
+{
+	if (!dev->bus)
+		return -ENOENT;
+	return name ? create_attr_in_groups(dev, dev->bus->dev_groups, name)
+		    : create_all_in_groups(dev, dev->bus->dev_groups);
 }
-static DEVICE_ATTR_RO(dev);
+
+static void remove_bus_groups(struct device *dev)
+{
+	if (!dev->bus)
+		return;
+	if (device_is_sysfs_lazy(dev))
+		device_remove_groups_if_present(dev, dev->bus->dev_groups);
+	else
+		device_remove_groups(dev, dev->bus->dev_groups);
+}
+
+static const struct device_sysfs_entry driver_core_sysfs_entries[] = {
+	/*
+	 * Rows are in eager device_add() creation order: ADD_ALL creates
+	 * forward, REMOVE_ALL tears down in reverse, matching the eager
+	 * path. The lazy tree exposes the same set of names and file
+	 * contents as an eager device; readdir(3) order is kernfs name-hash
+	 * order (kernfs_sd_compare), not table order, and is not ABI.
+	 */
+	{
+		/* Created early on the eager path - keep at table top. */
+		.name		= "power",
+		.applies_to	= dev_needs_pm,
+		.create	= create_power,
+		.remove		= remove_power,
+	},
+	{
+		.name		= "uevent",
+		.create	= create_uevent,
+		.remove		= remove_uevent,
+	},
+	/* Class-side rows. */
+	{
+		.name		= "subsystem",
+		.applies_to	= dev_has_class,
+		.create	= create_class_subsystem_link,
+		.remove		= remove_class_subsystem_link,
+	},
+	{
+		.name		= "device",
+		.applies_to	= dev_is_class_child,
+		.create	= create_device_backlink,
+		.remove		= remove_device_backlink,
+	},
+	{
+		.applies_to	= dev_has_class_dev_groups,
+		.create	= create_class_groups,
+		.remove		= remove_class_groups,
+	},
+	/* Groups + standalones in eager device_attrs_create() order. */
+	{
+		.applies_to	= dev_has_type_groups,
+		.create	= create_type_groups,
+		.remove		= remove_type_groups,
+	},
+	{
+		.applies_to	= dev_has_own_groups,
+		.create	= create_dev_own_groups,
+		.remove		= remove_dev_own_groups,
+	},
+	{
+		.name		= "online",
+		.applies_to	= dev_supports_offline_enabled,
+		.create	= create_online,
+		.remove		= remove_online,
+	},
+	{
+		.name		= "waiting_for_supplier",
+		.applies_to	= dev_has_fwnode_devlink,
+		.create	= create_waiting_for_supplier,
+		.remove		= remove_waiting_for_supplier,
+	},
+	{
+		.name		= "removable",
+		.applies_to	= dev_removable_valid,
+		.create	= create_removable,
+		.remove		= remove_removable,
+	},
+	{
+		.name		= "physical_location",
+		.applies_to	= dev_has_physical_location,
+		.create	= create_physical_location,
+		.remove		= remove_physical_location,
+	},
+	/* Bus-side rows. */
+	{
+		.name		= "subsystem",
+		.applies_to	= dev_has_bus_no_class,
+		.create	= create_bus_subsystem_link,
+		.remove		= remove_bus_subsystem_link,
+	},
+	{
+		.applies_to	= dev_has_bus_dev_groups,
+		.create	= create_bus_groups,
+		.remove		= remove_bus_groups,
+	},
+	/* Late rows. */
+	{
+		.name		= "dev",
+		.applies_to	= dev_has_devt_major,
+		.create	= create_dev_attr,
+		.remove		= remove_dev_attr,
+	},
+	{ }	/* sentinel */
+};
 
 /* /sys/devices/ */
 struct kset *devices_kset;
@@ -3861,30 +4235,17 @@ static int device_add_class_symlinks(struct device *dev)
 	if (!sp)
 		return 0;
 
-	error = sysfs_create_link(&dev->kobj, &sp->subsys.kobj, "subsystem");
-	if (error)
-		goto out_devnode;
-
-	if (dev->parent && device_is_not_partition(dev)) {
-		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-					  "device");
-		if (error)
-			goto out_subsys;
-	}
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&sp->subsys.kobj, &dev->kobj, dev_name(dev));
 	if (error)
-		goto out_device;
-	goto exit;
+		goto out_devnode;
+
+	subsys_put(sp);
+	return 0;
 
-out_device:
-	sysfs_remove_link(&dev->kobj, "device");
-out_subsys:
-	sysfs_remove_link(&dev->kobj, "subsystem");
 out_devnode:
 	sysfs_remove_link(&dev->kobj, "of_node");
-exit:
 	subsys_put(sp);
 	return error;
 }
@@ -3899,9 +4260,6 @@ static void device_remove_class_symlinks(struct device *dev)
 	if (!sp)
 		return;
 
-	if (dev->parent && device_is_not_partition(dev))
-		sysfs_remove_link(&dev->kobj, "device");
-	sysfs_remove_link(&dev->kobj, "subsystem");
 	sysfs_delete_link(&sp->subsys.kobj, &dev->kobj, dev_name(dev));
 	subsys_put(sp);
 }
@@ -4061,38 +4419,44 @@ int device_add(struct device *dev)
 	/* notify platform of device entry */
 	device_platform_notify(dev);
 
-	error = device_create_file(dev, &dev_attr_uevent);
-	if (error)
-		goto attrError;
-
 	error = device_add_class_symlinks(dev);
 	if (error)
 		goto SymlinkError;
-	/*
-	 * device_set_sysfs_lazy() only allocates ->sysfs_lazy_state for
-	 * non-namespaced devices, and device_is_sysfs_lazy() guards opt-in
-	 * here, so kernfs_set_lazy() should always succeed.  WARN_ON catches
-	 * a regression in those preconditions.
-	 */
-	if (device_is_sysfs_lazy(dev))
-		WARN_ON(kernfs_set_lazy(dev->kobj.sd));
-
-	error = device_add_attrs(dev);
-	if (error)
-		goto AttrsError;
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	/*
+	 * Create power/ eagerly even for lazy devices: in-kernel callers
+	 * (wakeup_sysfs_add(), dev_pm_qos_*()) sysfs_merge_group() into an
+	 * existing power/ dir at driver-bind, before any userspace access.
+	 * Mark it added so the lazy create/remove path treats it as done.
+	 */
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto DPMError;
+	if (device_is_sysfs_lazy(dev))
+		dev->sysfs_lazy->power_added = true;
 	device_pm_add(dev);
 
-	if (MAJOR(dev->devt)) {
-		error = device_create_file(dev, &dev_attr_dev);
-		if (error)
-			goto DevAttrError;
+	(void)dev_add_physical_location(dev);
 
+	/*
+	 * Subsystems that opt a device into lazy sysfs are responsible for
+	 * ensuring the device's kobj.sd is a non-namespaced directory: the
+	 * device_set_sysfs_lazy() contract states the call must precede
+	 * device_add(), and device_is_sysfs_lazy() gates opt-in here.
+	 * kernfs_set_lazy() should therefore always succeed; WARN_ON catches
+	 * a contract violation by an opted-in subsystem.
+	 */
+	if (device_is_sysfs_lazy(dev))
+		WARN_ON(kernfs_set_lazy(dev->kobj.sd));
+
+	/* FIXME: eager ADD_ALL return is dropped; a failed create won't fail device_add(). */
+	if (!device_is_sysfs_lazy(dev))
+		device_sysfs_apply(dev, driver_core_sysfs_entries,
+				  DEV_SYSFS_ADD_ALL, NULL);
+
+	if (MAJOR(dev->devt)) {
 		error = device_create_sys_dev_entry(dev);
 		if (error)
 			goto SysEntryError;
@@ -4169,21 +4533,23 @@ int device_add(struct device *dev)
 	put_device(dev);
 	return error;
  SysEntryError:
-	if (MAJOR(dev->devt))
-		device_remove_file(dev, &dev_attr_dev);
- DevAttrError:
+	device_lock(dev);
+	kill_device(dev);
+	device_unlock(dev);
+	/* REMOVE_ALL: the remove_power() row is the sole power-group teardown. */
+	if (device_is_sysfs_lazy(dev))
+		mutex_lock(&dev->sysfs_lazy->lock);
+	device_sysfs_apply(dev, driver_core_sysfs_entries,
+			  DEV_SYSFS_REMOVE_ALL, NULL);
+	if (device_is_sysfs_lazy(dev))
+		mutex_unlock(&dev->sysfs_lazy->lock);
 	device_pm_remove(dev);
-	dpm_sysfs_remove(dev);
  DPMError:
 	device_set_driver(dev, NULL);
 	bus_remove_device(dev);
  BusError:
-	device_remove_attrs(dev);
- AttrsError:
 	device_remove_class_symlinks(dev);
  SymlinkError:
-	device_remove_file(dev, &dev_attr_uevent);
- attrError:
 	device_platform_notify_remove(dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	glue_dir = get_glue_dir(dev);
@@ -4296,19 +4662,25 @@ void device_del(struct device *dev)
 	if (dev->fwnode && dev->fwnode->dev == dev)
 		dev->fwnode->dev = NULL;
 
-	/* Notify clients of device removal.  This call must come
-	 * before dpm_sysfs_remove().
-	 */
+	/* Must come before REMOVE_ALL tears down power/. */
 	noio_flag = memalloc_noio_save();
 	bus_notify(dev, BUS_NOTIFY_DEL_DEVICE);
 
-	dpm_sysfs_remove(dev);
+	/* Serialize against lazy populate callbacks. dev->p->dead is
+	 * already set so any populate taking this lock after us bails.
+	 */
+	if (device_is_sysfs_lazy(dev))
+		mutex_lock(&dev->sysfs_lazy->lock);
+	device_sysfs_apply(dev, driver_core_sysfs_entries,
+			  DEV_SYSFS_REMOVE_ALL, NULL);
+	if (device_is_sysfs_lazy(dev))
+		mutex_unlock(&dev->sysfs_lazy->lock);
+
 	if (parent)
 		klist_del(&dev->p->knode_parent);
 	if (MAJOR(dev->devt)) {
 		devtmpfs_delete_node(dev);
 		device_remove_sys_dev_entry(dev);
-		device_remove_file(dev, &dev_attr_dev);
 	}
 
 	sp = class_to_subsys(dev->class);
@@ -4325,8 +4697,6 @@ void device_del(struct device *dev)
 		mutex_unlock(&sp->mutex);
 		subsys_put(sp);
 	}
-	device_remove_file(dev, &dev_attr_uevent);
-	device_remove_attrs(dev);
 	bus_remove_device(dev);
 	device_pm_remove(dev);
 	driver_deferred_probe_del(dev);
@@ -4578,6 +4948,10 @@ EXPORT_SYMBOL_GPL(device_find_child);
 
 int __init devices_init(void)
 {
+	/* Compile-time row-count check (rows + sentinel). */
+	BUILD_BUG_ON(ARRAY_SIZE(driver_core_sysfs_entries) !=
+		     N_DRIVER_CORE_SYSFS_ENTRIES + 1);
+
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 94b8aca20bffc..e2ce9e6c12d84 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -28,6 +28,7 @@ void sysfs_warn_dup(struct kernfs_node *parent, const char *name);
  * file.c
  */
 
+
 /*
  * symlink.c
  */
diff --git a/include/linux/device.h b/include/linux/device.h
index e5485bfbc6c84..c0a2ee429280c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -89,16 +89,10 @@ int subsys_virtual_register(const struct bus_type *subsys,
 			    const struct attribute_group **groups);
 
 /**
- * enum dev_sysfs_action - verb selector for device_sysfs_apply()
- * @DEV_SYSFS_ADD_ONE: realize a single named entry (lazy populate_one
- *		       miss path); walker stops at the first row whose
- *		       @applies_to passes and whose create() returns
- *		       anything other than -ENOENT.
- * @DEV_SYSFS_ADD_ALL: realize every applicable entry (eager device_add
- *		       or lazy populate_all); best-effort, per-row errors
- *		       do not abort the walk.
- * @DEV_SYSFS_REMOVE_ALL: tear down every applicable entry in reverse
- *		       row order (device_del teardown).
+ * enum dev_sysfs_action - operation requested by device_sysfs_apply()
+ * @DEV_SYSFS_ADD_ONE: create a single named entry
+ * @DEV_SYSFS_ADD_ALL: create every applicable entry
+ * @DEV_SYSFS_REMOVE_ALL: tear down every previously-created entry
  */
 enum dev_sysfs_action {
 	DEV_SYSFS_ADD_ONE,
@@ -107,35 +101,15 @@ enum dev_sysfs_action {
 };
 
 /**
- * struct device_sysfs_entry - declarative per-device sysfs content row
- * @name:	Attribute or symlink name at the top level of the device's
- *		sysfs directory, or %NULL for a wildcard row whose
- *		create() performs internal name dispatch (typically a
- *		group-source row iterating an attribute_group array).
- * @applies_to: Optional predicate gating row eligibility for this
- *		device. Must be cheap, non-sleeping, side-effect-free, and
- *		monotonic for a given device state. MUST NOT acquire any
- *		lock the walker's caller may already hold (notably
- *		device_lock()). %NULL means unconditional.
- * @create:	Required. Creates the row's sysfs content. For a named
- *		row (@name != NULL) the @name argument equals @e->name on
- *		ADD_ONE and %NULL on ADD_ALL. For a wildcard row the @name
- *		argument is the ADD_ONE target (or %NULL on ADD_ALL) and
- *		the row's create() matches internally, returning -ENOENT
- *		to signal "not my name" so the walker continues. Must
- *		convert -EEXIST from concurrent racers to 0.
- * @remove:	Optional reverse-of-realize teardown. Called on
- *		REMOVE_ALL in reverse row order. MUST NOT fail the walk.
+ * struct device_sysfs_entry - per-device sysfs entry
+ * @name:	entry name; %NULL for a wildcard row
+ * @applies_to:	optional predicate gating row eligibility
+ * @create:	creates the row's sysfs content
+ * @remove:	optional teardown
  *
- * Rows are declared in file-static, sentinel-terminated tables whose
- * base pointer is published to the walker via struct kobj_type.entries
- * (device ktype shares a single driver_core table and dispatches to
- * dev->type->entries as well). The row shape mirrors cftype +
- * cgroup_addrm_files (kernel/cgroup/cgroup.c) and the
- * pci_sysfs_entries[] at drivers/pci/pci-sysfs.c (added later in
- * the series); see Documentation/driver-api/sysfs-lazy.rst (also
- * added later in the series) for the full walker contract and
- * error-handling matrix.
+ * Rows are declared in file-static, sentinel-terminated tables and
+ * walked by device_sysfs_apply().  See
+ * Documentation/driver-api/sysfs-lazy.rst for the walker contract.
  */
 struct device_sysfs_entry {
 	const char *name;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


