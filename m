Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE67C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438016B0135; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABA36B013B; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B04F6B0138; Thu,  2 Jul 2026 20:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEDCD6B0135
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:59:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E35DA0246
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:51:23 +0000 (UTC)
X-FDA: 84944578446.29.2E4FBE2
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC4DB140006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:51:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iHurieKc;
	spf=pass (imf26.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014681;
	b=iTlV7kTUclK9bKVIGhPeeCvN3KOV+Nje3IIHg9oObkDAQrw4pXMk/S7cvUyDPPA/1C3hwh
	luCwvpzgocxbG1QQzTNgvGuh41kXMuNwytMuKOvfUQ/qiQGysMI9ot9qb8VNKOyhYIcjF/
	k+dUAWy6ivnjDBsC8KAjrjH3xNg3lKg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQXwRfNx0b+cTHhdSx5J83FGDt8YDjF1iSoBNLo1Qfw=;
	b=Dx+S33F8N/y3xOs8QEPXqMJ86mBGluPDTiRRhEKy+GWiolljuWrY6ro95wNN7IjbwwoYXj
	+r0hKMyEJc05gJhVv7FKDp+6TWH3nvjv7xSH7dsrLXwWW0QRSBAG479Xdz1peSm0yTe5lS
	3z7H8BU2s43FucfrqMkGxZ+cGMJvUyw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iHurieKc;
	spf=pass (imf26.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014680; x=1814550680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uQXwRfNx0b+cTHhdSx5J83FGDt8YDjF1iSoBNLo1Qfw=;
  b=iHurieKct5guGRUltMiN6xLJQ2Mru3GBQOOE1xk6fA7Whl0CRtxRd6A4
   b/R/szYxM9j8ZDZ5ByV1z4V4Rkg0gdRIA1nE/8TsFaEZC3csSYWx1Izyk
   Oye8D3stAJjXAmORVAXky4WCuKWgfQHNHVetdzETiMCFJaBw10DoCNHql
   wEIaRcW54HjdPpWEiRFQSVj1IWNBnOIdKdcUutbRBRNGCqdzttkgTAY2u
   Cnig1j62KoT1aEaHoeDYdAmoG4OoyImGvlhBYQofIb4+IEALzI5ruLOX8
   XZr3ndqmZI6T/mxb6wF3yifKaSDoyjbwMCBG/sIzKuPELJcVPG5YRdJc+
   g==;
X-CSE-ConnectionGUID: dyk/pfW6R6C9ZTRGbm3/QQ==
X-CSE-MsgGUID: fnYdymBqRpG9CyA4KMDJnA==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22963744"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:51:19 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:8808]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.125:2525] with esmtp (Farcaster)
 id d489353c-48c5-44c8-b75e-960692b706e6; Thu, 2 Jul 2026 17:51:19 +0000 (UTC)
X-Farcaster-Flow-ID: d489353c-48c5-44c8-b75e-960692b706e6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:51:19 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:51:16 +0000
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
Subject: [RFC PATCH 05/14] driver core: add struct device_sysfs_entry and walker
Date: Thu, 2 Jul 2026 19:51:05 +0200
Message-ID: <20260702175114.24659-1-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702174033.32116-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D033UWC004.ant.amazon.com (10.13.139.225) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC4DB140006
X-Stat-Signature: qc6tmbw8k6bjqc719sask4oqfq6k9gfd
X-Rspam-User: 
X-HE-Tag: 1783014680-420539
X-HE-Meta: U2FsdGVkX19Ak/ZEZBefZmAT3O0cAEZboI/80TOSP0V3gG+461/h87aSCOcgr6FHkskiUe97CM7VKAUHP/lYel+FG0LvPs+dyOrz8g28zh/lvvDJosgmmtx90CyZK/Ys6c4pWKXbZ9neNpuNbKIKAHbfA/NUh7XdhvePOyU/DOvEPOEvwr5bEFedNvH+L1haOBuMmnQSABvpBDCt9d/O7dmU5kahr6yFOVlV4MU7UUwx5DX8G9J2sw71Be9DPQ0DkcKDAcY0mRo17KPTiP+HFsiikhvJZi8zgDpzQaQDx6Ipr8ynbpXHk3cRGYdN5ipFC3wheoTp5249IY5quILm1tOCNkbeiJkMsjmZCc5cV4lwUF+G9coPoFXqnukF8AYpgJDxerx05xwtpo/f3B3CCfAFtcZZHsL6M7YGZXyMto1UPWpQdl00n7z6xHno9uRnR72MNJBFjO5qkRhrlnAahjoVK+e1268JYduschP63L5+OqS4lF+TbwyD+HvC++lh3lFcp9aVguMOwLuc7VBYXFnhU9tkCIuRpiLwj3KwdOi9DxW7g4Y7RECS9s8gfQ4B+ZBF22R243gXTdXNqKIYZeu+CdgkVdcvpF5U4VT4VKunqSWKla2BaxPQOcvyxY5QOfCNbNb/qdggDHeV8Gs07wCItlvlu9Z2M+4ChRI9YuENe2YgxQcQjEqea/R+POwmlRezec/wtyV9lEqYiBE3IeW2IxYm0KD3qLQ7IonlLcAmXu7cRzPqOMbnXgN/NaC6sEVaqwacoiI65SK0lL0fb6JLlqAdqhjXn5sJgglWxQUi2y1bjIeH1wKdKlBvhd6guYghW6B+mrd6KTrkarFRf6UTaqleOdkI3TRIbJjiL2SbGvfn0uujYy85STz6QLfcWhrRXDZMJ2/ZPoj+cp3EYFB0vmig5j6BczkwLYkdTtq1sgfEn0o2DcQahHR/vPgLGDp8/QiEWvZzk3l+/Do
 lfIiOKsb
 9m1zLWXlFHAggppb5JNP0QXYOUl/0zUkEIN6O8QCTnoh/z6001+B1/6WaGf33fiKGpbSQz68OclPLa5t77x0kN5A+as5tpMgKKMd4RjcDeeciEilEoe5td9todNAMhl6FU7IZpqkiHTzgmXTLUGu4XnBU43ys+OOgBGKuXj4VuVUbxHKOIBobaT2twR0ntewBxXjHu7oShvbqMytFOt8FI4UQfmEQuz2BGynTRArYv6ty9it/a3V6NfSHCsZEY6nqP/r5y+UArOV9AD/1qqPHp5A3lYm+kIVrW0bX2Nwkcb6jYQo7rhA4Q/0fYn24D36BPyxL1FfM93TK0OPclQk/37NYxSQhogzWp4p6rbo0gyDqljL+KZLUa4L5Lyw2tl5OcjFR3tawHOHv5jTenNl5T8b38UA1CeMpxiBDAqIb+cvG2ZS0pjK31woboQt+J6SWIl1YcmBLsFi/c0m5udtANGrdYrUKZ8c+K//nb/sMjhwigN3miU6Ya0TrWVN4iGct4jn5IWix3jZJytf75IdRfwRt5guagShKcHY37yJVgl7/wAR77bQ+KtkM2fXBwS4BW8+OWNnWP+iyRjC1kT4mYu7aquYtXF0gjC4KGWrrTtYRROuEnxeXiMF2/wM2sSyjxO7yqGCV/8PO60ojgMmOV65DM3sEzktDvQ5ZQazZNJW3sHwoqJI1NXXbiJ4JijzHBqDDR6kDxC6XqtkQJQR7ya4vVXnZN/ny80d5zL6enCe6QJiK8cQ+SB62GNA2aS4DuBuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the primitive for declaring per-device sysfs content as
table rows and a single walker that dispatches across eager,
lazy-populate, and teardown paths.

struct device_sysfs_entry { name, applies_to, create, remove }

  - name == NULL: wildcard row (create() does internal name
    dispatch; used for attribute_group-source rows).
  - applies_to: NULL or a pure, cheap, non-sleeping predicate.
  - create: implements ADD_ONE (name != NULL) and ADD_ALL
    (name == NULL) semantics; absorbs -EEXIST from concurrent
    racers to 0.
  - remove: reverse-order teardown.

device_sysfs_apply(dev, entries, action, name) dispatches
DEV_SYSFS_ADD_ONE / DEV_SYSFS_ADD_ALL / DEV_SYSFS_REMOVE_ALL across
the table. -ENOENT from a wildcard row's create() is treated as
"not my name" and the walker continues; any other error propagates
to the caller on ADD_ONE and is absorbed on ADD_ALL (best-effort).
REMOVE_ALL reverses the table and never aborts. The full contract
is documented in Documentation/driver-api/sysfs-lazy.rst (added
later in this series).

Shape follows cftype + cgroup_addrm_files (kernel/cgroup/cgroup.c)
as the in-tree precedent for table-driven attribute creation.
struct kobj_type grows a trailing .entries pointer; ktypes opt in
by setting it and wiring their populate / populate_all callbacks
to the walker. The field is at end of struct for source-
compatibility with positional initialisers of out-of-tree ktypes.

sysfs_add_file_mode_ns() and sysfs_add_bin_file_mode_ns() are
exported (kerneldoc added) so the walker can absorb -EEXIST from
concurrent create racers without going through sysfs_warn_dup().

Two static helpers - create_attr_in_groups() and
create_all_in_groups() - are added for use by attribute-group
source rows that the migration commit later wires up; they search
@groups by @name and walk every visible attribute respectively.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: driver-core@lists.linux.dev
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/base/core.c     | 319 ++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/file.c         |  41 +++++-
 fs/sysfs/sysfs.h        |   6 -
 include/linux/device.h  |  56 +++++++
 include/linux/kobject.h |   5 +
 include/linux/sysfs.h   |  24 +++
 6 files changed, 443 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6d0d917d4b1ff..aeb4985eb8838 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2574,6 +2574,325 @@ static void device_release(struct kobject *kobj)
 	kfree(p);
 }
 
+/*
+ * device_sysfs_apply() - declarative per-device sysfs dispatch
+ *
+ * Single walker over a sentinel-terminated struct device_sysfs_entry
+ * table. Intended to be invoked on every dispatch path (device_add
+ * eager, lazy populate_one, lazy populate_all, device_del teardown)
+ * so adding a new per-device file is one row, not four open-coded
+ * branches. Shape follows cftype + cgroup_addrm_files
+ * (kernel/cgroup/cgroup.c) and pci_sysfs_entries[]
+ * (drivers/pci/pci-sysfs.c).
+ *
+ * ADD_ONE:  first row whose applies_to passes and whose name matches
+ *	     (or a wildcard row whose create() does not return
+ *	     -ENOENT) terminates the walk. -ENOENT from a wildcard
+ *	     row's create() signals "not my name"; the walker
+ *	     continues. Realize callbacks MUST check existence (via
+ *	     sysfs_*_exists()) before calling sysfs_create_*() and
+ *	     return 0 if the entry already exists. Reaching
+ *	     __kernfs_create_*() for a name that another lazy path
+ *	     just created is forbidden under lock
+ *	     serialization. If sysfs_warn_dup() ever fires from a
+ *	     lazy path, it indicates a lock invariant
+ *	     violation or a non-lazy path creating lazy attrs (bug).
+ * ADD_ALL:  every applicable row's create() fires with name = NULL;
+ *	     per-row errors are best-effort - the walker discards
+ *	     return values and rows log via their own diagnostics.
+ * REMOVE_ALL: reverse row order; remove() fires for every row whose
+ *	     applies_to passes. Teardown never aborts.
+ *
+ * The full walker contract (error-absorption matrix, interaction
+ * with negative-dentry caching, lifecycle caveats) is documented in
+ * Documentation/driver-api/sysfs-lazy.rst, added later in this
+ * series.
+ */
+/*
+ * Create one named attr inside @grp; honours grp->is_visible.
+ * Returns 0 on success/hidden/already-present, -ENOENT on no-match.
+ */
+static int create_attr_in_group(struct device *dev,
+				 const struct attribute_group *grp,
+				 const char *name)
+{
+	struct attribute **a;
+	const struct bin_attribute *const *ba;
+	kuid_t uid;
+	kgid_t gid;
+	umode_t mode;
+	int i;
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	kobject_get_ownership(&dev->kobj, &uid, &gid);
+
+	if (grp->name) {
+		if (!strcmp(grp->name, name)) {
+			if (sysfs_group_exists(&dev->kobj, grp))
+				return 0;
+			return sysfs_create_group(&dev->kobj, grp);
+		}
+		return -ENOENT;
+	}
+
+	if (grp->attrs) {
+		for (i = 0, a = grp->attrs; *a; i++, a++) {
+			if (strcmp((*a)->name, name))
+				continue;
+
+			mode = (*a)->mode;
+			if (grp->is_visible || grp->is_visible_const) {
+				if (grp->is_visible)
+					mode = grp->is_visible(&dev->kobj, *a, i);
+				else
+					mode = grp->is_visible_const(&dev->kobj, *a, i);
+				mode &= ~SYSFS_GROUP_INVISIBLE;
+				if (!mode)
+					return 0;	/* hidden */
+			}
+			mode &= SYSFS_PREALLOC | 0664;
+
+			if (sysfs_kn_exists(&dev->kobj, (*a)->name))
+				return 0;
+
+			return sysfs_add_file_mode_ns(dev->kobj.sd, *a,
+						      mode, uid, gid, NULL);
+		}
+	}
+	if (grp->bin_attrs) {
+		for (i = 0, ba = grp->bin_attrs; *ba; i++, ba++) {
+			if (strcmp((*ba)->attr.name, name))
+				continue;
+			mode = (*ba)->attr.mode;
+			if (grp->is_bin_visible) {
+				mode = grp->is_bin_visible(&dev->kobj, *ba, i);
+				mode &= ~SYSFS_GROUP_INVISIBLE;
+				if (!mode)
+					return 0;
+			}
+			mode &= SYSFS_PREALLOC | 0664;
+
+			if (sysfs_kn_exists(&dev->kobj, (*ba)->attr.name))
+				return 0;
+
+			return sysfs_add_bin_file_mode_ns(dev->kobj.sd,
+							  *ba, mode,
+							  (*ba)->size,
+							  uid, gid, NULL);
+		}
+	}
+	return -ENOENT;
+}
+
+/*
+ * Per-group incremental creation. Tolerates partial state from
+ * concurrent populate_one. Best-effort: absorbs per-attr failures.
+ */
+static int create_group_incremental(struct device *dev,
+				     const struct attribute_group *grp)
+{
+	struct attribute **a;
+	const struct bin_attribute *const *ba;
+	int ret;
+
+	if (device_is_sysfs_lazy(dev))
+		lockdep_assert_held(&dev->sysfs_lazy->lock);
+
+	if (grp->name) {
+		struct kernfs_node *subdir;
+		kuid_t uid;
+		kgid_t gid;
+		umode_t mode;
+		int i;
+
+		subdir = kernfs_find_and_get(dev->kobj.sd, grp->name);
+		if (!subdir)
+			return sysfs_create_group(&dev->kobj, grp);
+
+		kobject_get_ownership(&dev->kobj, &uid, &gid);
+
+		if (grp->attrs) {
+			for (i = 0, a = grp->attrs; *a; i++, a++) {
+				struct kernfs_node *kn;
+
+				mode = (*a)->mode;
+				if (grp->is_visible || grp->is_visible_const) {
+					if (grp->is_visible)
+						mode = grp->is_visible(&dev->kobj,
+								       *a, i);
+					else
+						mode = grp->is_visible_const(&dev->kobj,
+									     *a, i);
+					mode &= ~SYSFS_GROUP_INVISIBLE;
+					if (!mode)
+						continue;
+				}
+				mode &= SYSFS_PREALLOC | 0664;
+
+				/* Existence check inside named @subdir (not a kobject). */
+				kn = kernfs_find_and_get(subdir, (*a)->name);
+				if (kn) {
+					kernfs_put(kn);
+					continue;
+				}
+
+				ret = sysfs_add_file_mode_ns(subdir, *a,
+							     mode, uid,
+							     gid, NULL);
+				if (ret)
+					dev_dbg(dev,
+						"lazy %s/%s: %d\n",
+						grp->name, (*a)->name, ret);
+			}
+		}
+		if (grp->bin_attrs) {
+			for (i = 0, ba = grp->bin_attrs; *ba; i++, ba++) {
+				struct kernfs_node *kn;
+
+				mode = (*ba)->attr.mode;
+				if (grp->is_bin_visible) {
+					mode = grp->is_bin_visible(&dev->kobj,
+								   *ba, i);
+					mode &= ~SYSFS_GROUP_INVISIBLE;
+					if (!mode)
+						continue;
+				}
+				mode &= SYSFS_PREALLOC | 0664;
+
+				kn = kernfs_find_and_get(subdir, (*ba)->attr.name);
+				if (kn) {
+					kernfs_put(kn);
+					continue;
+				}
+
+				ret = sysfs_add_bin_file_mode_ns(subdir,
+								 *ba,
+								 mode,
+								 (*ba)->size,
+								 uid,
+								 gid,
+								 NULL);
+				if (ret)
+					dev_dbg(dev,
+						"lazy %s/%s: %d\n",
+						grp->name,
+						(*ba)->attr.name, ret);
+			}
+		}
+
+		kernfs_put(subdir);
+		return 0;
+	}
+
+	if (grp->attrs) {
+		for (a = grp->attrs; *a; a++)
+			(void)create_attr_in_group(dev, grp, (*a)->name);
+	}
+	if (grp->bin_attrs) {
+		for (ba = grp->bin_attrs; *ba; ba++)
+			(void)create_attr_in_group(dev, grp,
+						    (*ba)->attr.name);
+	}
+	return 0;
+}
+
+/* Search @groups for @name. -ENOENT = not in this source. */
+static int __maybe_unused create_attr_in_groups(struct device *dev,
+				  const struct attribute_group *const *groups,
+				  const char *name)
+{
+	const struct attribute_group *const *g;
+	int ret;
+
+	if (!groups)
+		return -ENOENT;
+
+	for (g = groups; *g; g++) {
+		ret = create_attr_in_group(dev, *g, name);
+		if (ret != -ENOENT)
+			return ret;
+	}
+	return -ENOENT;
+}
+
+/* Walk @groups creating every visible attribute. Best-effort. */
+static int __maybe_unused create_all_in_groups(struct device *dev,
+				 const struct attribute_group *const *groups)
+{
+	const struct attribute_group *const *g;
+
+	if (!groups)
+		return 0;
+
+	for (g = groups; *g; g++)
+		(void)create_group_incremental(dev, *g);
+	return 0;
+}
+
+static const struct device_sysfs_entry *
+device_sysfs_entries_end(const struct device_sysfs_entry *entries)
+{
+	const struct device_sysfs_entry *e = entries;
+
+	while (e->create)
+		e++;
+	return e;
+}
+
+static __maybe_unused int
+device_sysfs_apply(struct device *dev,
+		  const struct device_sysfs_entry *entries,
+		  enum dev_sysfs_action action, const char *name)
+{
+	const struct device_sysfs_entry *e;
+
+	if (!entries)
+		return action == DEV_SYSFS_ADD_ONE ? -ENOENT : 0;
+
+	if (action == DEV_SYSFS_REMOVE_ALL) {
+		for (e = device_sysfs_entries_end(entries) - 1;
+		     e >= entries; e--) {
+			if (e->applies_to && !e->applies_to(dev))
+				continue;
+			if (e->remove)
+				e->remove(dev);
+		}
+		return 0;
+	}
+
+	for (e = entries; e->create; e++) {
+		int ret;
+
+		if (e->applies_to && !e->applies_to(dev))
+			continue;
+		if (action == DEV_SYSFS_ADD_ONE && e->name &&
+		    strcmp(e->name, name))
+			continue;
+
+		ret = e->create(dev, action == DEV_SYSFS_ADD_ONE
+					      ? name : NULL);
+		if (action == DEV_SYSFS_ADD_ONE) {
+			/*
+			 * A named row is the authoritative handler for its
+			 * name: return its result even on -ENOENT. A wildcard
+			 * row (e->name == NULL) may decline with -ENOENT, so
+			 * keep scanning for another handler in that case.
+			 */
+			if (e->name || ret != -ENOENT)
+				return ret;
+		}
+		/*
+		 * FIXME: ADD_ALL is best-effort and never returns the first create() failure to
+		 * the caller, so device_ktype_populate_all() latches populated=true after a
+		 * transient failure - the missing attribute is negative-cached forever (a later
+		 * lookup returns -ENOENT and never retries), contradicting the sysfs-lazy ABI.
+		 */
+	}
+	return action == DEV_SYSFS_ADD_ONE ? -ENOENT : 0;
+}
+
 static const struct ns_common *device_namespace(const struct kobject *kobj)
 {
 	const struct device *dev = kobj_to_dev(kobj);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5f3144e52ab72..8d0b8c2c2ee4d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -270,6 +270,25 @@ static const struct kernfs_ops sysfs_bin_kfops_mmap = {
 	.llseek		= sysfs_kf_bin_llseek,
 };
 
+/**
+ * sysfs_add_file_mode_ns - create a sysfs attribute file under @parent
+ * @parent: kernfs node for the parent directory (typically @kobj->sd)
+ * @attr:   attribute descriptor; @attr->name is the file name
+ * @mode:   file mode (low bits) optionally OR'd with %SYSFS_PREALLOC
+ * @uid: file owner UID
+ * @gid: file owner GID
+ * @ns:  namespace tag (may be %NULL)
+ *
+ * Picks a kernfs_ops dispatch row from (prealloc?, has show, has store)
+ * routing read()/write() through @parent->priv->ktype->sysfs_ops.
+ *
+ * Return: 0 on success, or -errno. -EEXIST means the name already
+ * exists and is treated as a caller error (it triggers sysfs_warn_dup()).
+ * The lazy populate path must not reach this: it checks sysfs_kn_exists()/
+ * sysfs_group_exists() under the populate lock before creating, so a
+ * concurrent ADD_ONE/ADD_ALL race resolves to a no-op rather than a
+ * duplicate create.
+ */
 int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 		const struct attribute *attr, umode_t mode, kuid_t uid,
 		kgid_t gid, const struct ns_common *ns)
@@ -320,6 +339,26 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 	return 0;
 }
 
+/**
+ * sysfs_add_bin_file_mode_ns - create a sysfs binary-attribute file
+ * @parent: kernfs node for the parent directory
+ * @battr:  binary attribute descriptor
+ * @mode:   file mode (low bits)
+ * @size:   in-core size of the binary attribute (passed to __kernfs_create_file())
+ * @uid: file owner UID
+ * @gid: file owner GID
+ * @ns:  namespace tag (may be %NULL)
+ *
+ * Picks a kernfs_ops dispatch row from a 5-row matrix on @battr's
+ * callbacks (mmap > rw > read > write > empty).
+ *
+ * Return: 0 on success, or -errno. -EEXIST means the name already
+ * exists and is treated as a caller error (it triggers sysfs_warn_dup()).
+ * The lazy populate path must not reach this: it checks sysfs_kn_exists()/
+ * sysfs_group_exists() under the populate lock before creating, so a
+ * concurrent ADD_ONE/ADD_ALL race resolves to a no-op rather than a
+ * duplicate create.
+ */
 int sysfs_add_bin_file_mode_ns(struct kernfs_node *parent,
 		const struct bin_attribute *battr, umode_t mode, size_t size,
 		kuid_t uid, kgid_t gid, const struct ns_common *ns)
@@ -816,5 +855,3 @@ ssize_t sysfs_bin_attr_simple_read(struct file *file, struct kobject *kobj,
 	return count;
 }
 EXPORT_SYMBOL_GPL(sysfs_bin_attr_simple_read);
-
-
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f4583dcafcd1e..94b8aca20bffc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -27,12 +27,6 @@ void sysfs_warn_dup(struct kernfs_node *parent, const char *name);
 /*
  * file.c
  */
-int sysfs_add_file_mode_ns(struct kernfs_node *parent,
-		const struct attribute *attr, umode_t amode, kuid_t uid,
-		kgid_t gid, const struct ns_common *ns);
-int sysfs_add_bin_file_mode_ns(struct kernfs_node *parent,
-		const struct bin_attribute *battr, umode_t mode, size_t size,
-		kuid_t uid, kgid_t gid, const struct ns_common *ns);
 
 /*
  * symlink.c
diff --git a/include/linux/device.h b/include/linux/device.h
index 39e08e8c950c6..e5485bfbc6c84 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -88,6 +88,62 @@ int subsys_system_register(const struct bus_type *subsys,
 int subsys_virtual_register(const struct bus_type *subsys,
 			    const struct attribute_group **groups);
 
+/**
+ * enum dev_sysfs_action - verb selector for device_sysfs_apply()
+ * @DEV_SYSFS_ADD_ONE: realize a single named entry (lazy populate_one
+ *		       miss path); walker stops at the first row whose
+ *		       @applies_to passes and whose create() returns
+ *		       anything other than -ENOENT.
+ * @DEV_SYSFS_ADD_ALL: realize every applicable entry (eager device_add
+ *		       or lazy populate_all); best-effort, per-row errors
+ *		       do not abort the walk.
+ * @DEV_SYSFS_REMOVE_ALL: tear down every applicable entry in reverse
+ *		       row order (device_del teardown).
+ */
+enum dev_sysfs_action {
+	DEV_SYSFS_ADD_ONE,
+	DEV_SYSFS_ADD_ALL,
+	DEV_SYSFS_REMOVE_ALL,
+};
+
+/**
+ * struct device_sysfs_entry - declarative per-device sysfs content row
+ * @name:	Attribute or symlink name at the top level of the device's
+ *		sysfs directory, or %NULL for a wildcard row whose
+ *		create() performs internal name dispatch (typically a
+ *		group-source row iterating an attribute_group array).
+ * @applies_to: Optional predicate gating row eligibility for this
+ *		device. Must be cheap, non-sleeping, side-effect-free, and
+ *		monotonic for a given device state. MUST NOT acquire any
+ *		lock the walker's caller may already hold (notably
+ *		device_lock()). %NULL means unconditional.
+ * @create:	Required. Creates the row's sysfs content. For a named
+ *		row (@name != NULL) the @name argument equals @e->name on
+ *		ADD_ONE and %NULL on ADD_ALL. For a wildcard row the @name
+ *		argument is the ADD_ONE target (or %NULL on ADD_ALL) and
+ *		the row's create() matches internally, returning -ENOENT
+ *		to signal "not my name" so the walker continues. Must
+ *		convert -EEXIST from concurrent racers to 0.
+ * @remove:	Optional reverse-of-realize teardown. Called on
+ *		REMOVE_ALL in reverse row order. MUST NOT fail the walk.
+ *
+ * Rows are declared in file-static, sentinel-terminated tables whose
+ * base pointer is published to the walker via struct kobj_type.entries
+ * (device ktype shares a single driver_core table and dispatches to
+ * dev->type->entries as well). The row shape mirrors cftype +
+ * cgroup_addrm_files (kernel/cgroup/cgroup.c) and the
+ * pci_sysfs_entries[] at drivers/pci/pci-sysfs.c (added later in
+ * the series); see Documentation/driver-api/sysfs-lazy.rst (also
+ * added later in the series) for the full walker contract and
+ * error-handling matrix.
+ */
+struct device_sysfs_entry {
+	const char *name;
+	bool (*applies_to)(struct device *dev);
+	int  (*create)(struct device *dev, const char *name);
+	void (*remove)(struct device *dev);
+};
+
 /*
  * The type of device, "struct device" is embedded in. A class
  * or bus can contain devices of different types
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index cec6de1720076..c724d86e1a049 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -61,6 +61,8 @@ enum kobject_action {
 	KOBJ_UNBIND,
 };
 
+struct device_sysfs_entry;
+
 struct kobject {
 	const char		*name;
 	struct list_head	entry;
@@ -130,6 +132,9 @@ struct kobj_type {
 	 */
 	int (*populate)(struct kobject *kobj, const char *name);
 	void (*populate_all)(struct kobject *kobj);
+
+	/* Optional table of per-attribute entries (see device_sysfs_apply()). */
+	const struct device_sysfs_entry *entries;
 };
 
 struct kobj_uevent_env {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index de211563f3dec..aac2f773d5378 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -415,6 +415,12 @@ int __must_check sysfs_create_files(struct kobject *kobj,
 				   const struct attribute * const *attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj,
 				  const struct attribute *attr, umode_t mode);
+int __must_check sysfs_add_file_mode_ns(struct kernfs_node *parent,
+		const struct attribute *attr, umode_t amode, kuid_t uid,
+		kgid_t gid, const struct ns_common *ns);
+int __must_check sysfs_add_bin_file_mode_ns(struct kernfs_node *parent,
+		const struct bin_attribute *battr, umode_t mode, size_t size,
+		kuid_t uid, kgid_t gid, const struct ns_common *ns);
 struct kernfs_node *sysfs_break_active_protection(struct kobject *kobj,
 						  const struct attribute *attr);
 void sysfs_unbreak_active_protection(struct kernfs_node *kn);
@@ -558,6 +564,24 @@ static inline int sysfs_chmod_file(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_add_file_mode_ns(struct kernfs_node *parent,
+					 const struct attribute *attr,
+					 umode_t amode, kuid_t uid,
+					 kgid_t gid,
+					 const struct ns_common *ns)
+{
+	return 0;
+}
+
+static inline int sysfs_add_bin_file_mode_ns(struct kernfs_node *parent,
+					     const struct bin_attribute *battr,
+					     umode_t mode, size_t size,
+					     kuid_t uid, kgid_t gid,
+					     const struct ns_common *ns)
+{
+	return 0;
+}
+
 static inline struct kernfs_node *
 sysfs_break_active_protection(struct kobject *kobj,
 			      const struct attribute *attr)
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


