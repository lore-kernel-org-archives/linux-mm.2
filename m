Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B5AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE40D6B0179; Thu,  2 Jul 2026 21:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC9E6B017B; Thu,  2 Jul 2026 21:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2226B017C; Thu,  2 Jul 2026 21:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6146B0179
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:03:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B740C0856
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:53:39 +0000 (UTC)
X-FDA: 84944584158.15.AC96267
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A7FD16001B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:53:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BUBa7NTm;
	spf=pass (imf08.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014817;
	b=pWsNHcvj4zxu+VRc4Q5CHF5KJX1n8G4JkfzxhF6Np69+23LRyeFymPTZZNyTlc56eu349P
	8DR4zF7npDXz7b349EGiyOI2R62aAWznR21ppFSWfrOU5oJ2dwM4rEAgOADbs+vpA1Mjw3
	cBIPLBLtGgGP2DrsXkZZoQh2GFuFcDA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSlTPPRGfH8uX0Q/+Vq9kwU7nczCfGQ8R9eS8+/KnEA=;
	b=uMy1CNxs5q20ZsVp8fADEbHM49/foBd101zPtKx5ia26IGQIFijRsu0tY1FliTuLsmjPvu
	q1h3aqLvl+kOPZsLPgg+zKxWjoGKH4C1Ot4VbpdFA0Lqz5vSlyCt7kzdAh6JV3tRldKkW7
	Wed6XiPCFl/Ag0M6/M6e1HCjsjvHjC8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=BUBa7NTm;
	spf=pass (imf08.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014817; x=1814550817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sSlTPPRGfH8uX0Q/+Vq9kwU7nczCfGQ8R9eS8+/KnEA=;
  b=BUBa7NTmvGA1AqLDMH+dRd6miA2a6Fq9GkWwuvedELgepB9OnuNVOBBt
   RIA7j27hTzP8eTb5U4w9bCQxqZ+mhHxeh79QTnJJR7Z7Ibru7kwGzR8jd
   ErzxdHDcvy6xV0pR1GaMDXzVDKWTgMkiNqrNQeQu++FLO7V4W/9ZfHD2/
   1lcp5vUUm24RC5cMC0lkQeQZYutIYrAUlD/1HGOHAC2ainJbIDxWDVQ6U
   vz2649LWfPbEuZwGVWQtcxWuWIVekEykbkRLrEvbMhDg4l8A205dEvn1t
   CdJRycG7xFX9WAoT2qmEAdJb7kCFvyAuC4V/rPFECPiweiepEUeH/tr4H
   g==;
X-CSE-ConnectionGUID: pOZNzN7bQxC5C5HyldoDbQ==
X-CSE-MsgGUID: gb9pcWjVSPGNDOJgrRcVHw==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22717676"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:53:33 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:13460]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.112:2525] with esmtp (Farcaster)
 id fd164244-2329-49ff-88a8-fff81b2dba1f; Thu, 2 Jul 2026 17:53:33 +0000 (UTC)
X-Farcaster-Flow-ID: fd164244-2329-49ff-88a8-fff81b2dba1f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:53:32 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:53:30 +0000
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
Subject: [RFC PATCH 09/14] iommu: lazy-populate iommu_group reserved_regions/type attrs
Date: Thu, 2 Jul 2026 19:51:09 +0200
Message-ID: <20260702175114.24659-5-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s7yonytd1rw1za6az4oy9113pj13skf6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A7FD16001B
X-HE-Tag: 1783014817-191040
X-HE-Meta: U2FsdGVkX1+5YBr2mkb805c/0FJziGaD8rZwhE5/fRC9au7PiWq6JvGXuZM6Rw31A5jmD1+qbH4ew018RSqOJ5T0gcucgydobEUAjes8+aA8GQcSBm6mipeEswSwsVlzTvypo2b71PExZrdQcMo3wLtO344Gb1E1BI5lqjIwsGJCxAq/0uSKX9kBEzAmQ5c66qQrpHm7sO96nnlEHaqM1XikwVoXlSI0ODzQP0zat8gwwX20Elvdr9PY2XYuU+gDklUgwJK0Lzh3C2KZOH8hoBkEWkvKJ8aDO3SE+BMvn/EE2Qvkj+MxQlIko8hDVMKVf/NaBEsTu4Uz6nCXb9ilM0E/conAFADAMblAv8jZ53KCfRuzQ+9TH2XgsXAq2Nkk+COPHsJb0tyYnaYdXUx/lb8g8/oKOWzF/TeRxwud7vNTL1D2keQ9N0ZCY3lDcNzGM7hiirZp7fz039LMqH3ueQhQIJSpN9ZwE58zGo1nXYS62zUbGkJNqqVmMzMIxPuXbpYCDnepi9XW3nlPktLCVxaofXp/TDntDJhltZKaxtkveoaNMClZOBIWHOt50gzMrveOy9EEeP4hewmWxQW62USRMIyAqndGBQrF4+O0YAQf48+fKNLaEMrPXzwHXhbLZv8va3ajebYp+CETuFqSAFrD6BJcOGzZqX/PyEBGmhuUqmD/rtdNRxtvmdJFH+w9k3JqQGNZScC3r8/iTGlhWmUtwstWdAnsY/Pd904tm70kFHQvoCKHLVi0qtC71oY6gtSskfDE4KwaDqcL7aqXoeFO1CNB0goiKywa+PwGE4BYBPshFHa6UBkc1paJRyC83pSWL/vKMBcDA+Hsc8TkX1dKkwjZpJovAcIu07UZprtvcOGcS6Eb+lIVVmUzMVDlyVcMzCNQOBNh0qfPfYsz5qqpKtwMhiZgoCZWM9q4edQIi854Z3tdRmbzjYIfDqrAmQxLqTxNQhXAx66SgJn
 LTIchBjJ
 UhQhdW7prF0/vi866Kx3jt0FgzGtNcthDhcL2aEehM2PGQpZcYk2uSy/A96GXAsRqw/9CpzGkecs7K1LpMCcWxd9B0ajcCadiib68xNoimHfCWziY3kn1mtKR0qb/wPmLxZM+yogdOXU6yL4j/bUMZFLYUqcYbQ/7CT2GW81GqzPAiKYlVrQWXKrtj6NCJc54MtQt9Z9I/X0gzQkto4IUzi5w2PL1o0QljyikkHg1kFv4LIL8O2QptIdccWCAF+1Z0ReHrzjuq9PyaSdkX14qEEQyfOTkXv5k4Ev0A1ROaN/e69Ok3ZvN98i62c9CEFbhwG7KKFMRP+FCHtV/w3gsMdSdFE7AWNuVAxqSY/5CwItWGTMDvQLnzzMDxkyhYG2+3qEd1shlfBkP9xnD77GEiLIs8hjbtwnpKKKuYfQQVWnA/aJkZsjSRwuDu4ZPLUTZjnLjcXd9zYMHE1WFKHY3M22IhKD3ibXA1OpPLU9gETnn37evxDdY+mUT0MwLm3hBrQG4wuW7B12bULZiKalJkgfc+EIYVAIleOBCBsAw8boD9BClJQvcBcFIYJhWLAc1IIqAIZe0/D9BDAlfAji/kRN7RAre4uB3pt+r7fJpLn41wjXZ672Tqzja53hsf2nlX5FDLRC7kfYwyGGwoMFXBlv7k0U9/6XZ+b043jyo7Ze9lZu5d+/NMh9o04AY2JmzuwoQ77Q/PPLZWHPRpch4kM4Mwhl0kSJTE09CYk4X/G8iBPh/Jj6rD7FMVDV43HAtlSBvbKH66qcpg3s81+ZADWdMEr943fAfkMdzyYYDiV1AGQVt2XrgZtI8w56Mi1eou49/nnAp4chFjz32tTnkt2nYPnEH1VPeq4h2oGAQwREoqoDgwygdysi8SYjObuyz3+SL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

iommu_group_alloc() eagerly creates two attribute files -
reserved_regions and type - that are read only on the VFIO /
iommufd ioctl path (VFIO_IOMMU_GET_INFO, iommufd type query).
On systems with thousands of SR-IOV VFs each VF typically gets
its own iommu_group, so deferring these two attrs eliminates two
kernfs nodes per group at boot.

iommu_group_ktype is the first non-device_ktype consumer of the
populate mechanism: wire iommu_group_populate_one /
iommu_group_populate_all and call kernfs_set_lazy() on the
group's kernfs node immediately after kobject_init_and_add().
See the in-diff comment at the kernfs_set_lazy() site for the
ordering rationale (must precede kobject_create_and_add("devices")
to interact correctly with kernfs_inc_rev()).

Both callbacks fast-path on iommu_group_sysfs_populated() so
re-entry after the directory is fully populated is cheap and
cannot fire sysfs_warn_dup().

The name attribute is created on demand by iommu_group_set_name()
on a separate API path and is not handled by these callbacks;
groups without a set name return -ENOENT on lookup of name.

No userspace ABI change.  A selftest for this deferral is added
later in the series under tools/testing/selftests/sysfs-lazy/.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: iommu@lists.linux.dev
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/iommu/iommu.c | 132 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 119 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 61c12ba782066..7a8dd43f0a09a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -21,6 +21,7 @@
 #include <linux/iommufd.h>
 #include <linux/idr.h>
 #include <linux/err.h>
+#include <linux/kernfs.h>
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/bitops.h>
@@ -71,8 +72,22 @@ struct iommu_group {
 	struct list_head entry;
 	unsigned int owner_cnt;
 	void *owner;
+	/* Embedded lazy-sysfs state (every iommu_group is lazy). */
+	struct sysfs_lazy_state sysfs_lazy;
 };
 
+static inline bool iommu_group_sysfs_populated(const struct iommu_group *group)
+{
+	return READ_ONCE(group->sysfs_lazy.populated);
+}
+
+static inline void
+iommu_group_sysfs_set_populated(struct iommu_group *group)
+{
+	lockdep_assert_held(&group->sysfs_lazy.lock);
+	WRITE_ONCE(group->sysfs_lazy.populated, true);
+}
+
 struct group_device {
 	struct list_head list;
 	struct device *dev;
@@ -1033,9 +1048,99 @@ static void iommu_group_release(struct kobject *kobj)
 	kfree(group);
 }
 
+/* Lazy iommu_group attrs (excludes "name", managed separately). */
+static const struct {
+	const char			*name;
+	struct iommu_group_attribute	*attr;
+} iommu_group_lazy_attrs[] = {
+	{ "reserved_regions", &iommu_group_attr_reserved_regions },
+	{ "type",             &iommu_group_attr_type },
+};
+
+static int iommu_group_populate_one(struct kobject *kobj, const char *name)
+{
+	struct iommu_group *group = to_iommu_group(kobj);
+	size_t i;
+	int ret = -ENOENT;
+	bool name_present = false;
+
+	/* Fast path: directory fully populated; kernfs has authoritative state. */
+	if (iommu_group_sysfs_populated(group))
+		return -ENOENT;
+
+	mutex_lock(&group->sysfs_lazy.lock);
+	/* Re-check under the lock against a concurrent populate_all. */
+	if (iommu_group_sysfs_populated(group)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/* Materialise the whole table (2 entries); cheaper than per-name dispatch. */
+	for (i = 0; i < ARRAY_SIZE(iommu_group_lazy_attrs); i++) {
+		struct iommu_group_attribute *attr =
+			iommu_group_lazy_attrs[i].attr;
+		int rc;
+
+		if (sysfs_kn_exists(&group->kobj, attr->attr.name))
+			rc = 0;
+		else
+			rc = iommu_group_create_file(group, attr);
+
+		if (!strcmp(name, iommu_group_lazy_attrs[i].name)) {
+			name_present = true;
+			ret = rc;
+		} else if (rc) {
+			pr_warn("group %d: lazy-create %s failed: %d\n",
+				group->id,
+				iommu_group_lazy_attrs[i].name, rc);
+		}
+	}
+	iommu_group_sysfs_set_populated(group);
+
+out:
+	mutex_unlock(&group->sysfs_lazy.lock);
+	return name_present ? ret : -ENOENT;
+}
+
+static void iommu_group_populate_all(struct kobject *kobj)
+{
+	struct iommu_group *group = to_iommu_group(kobj);
+	size_t i;
+	int ret;
+
+	/* Fast path: directory already fully populated. */
+	if (iommu_group_sysfs_populated(group))
+		return;
+
+	mutex_lock(&group->sysfs_lazy.lock);
+	if (iommu_group_sysfs_populated(group))
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(iommu_group_lazy_attrs); i++) {
+		struct iommu_group_attribute *attr =
+			iommu_group_lazy_attrs[i].attr;
+
+		/* Existence check absorbs the populate_one race. */
+		if (sysfs_kn_exists(&group->kobj, attr->attr.name))
+			continue;
+
+		ret = iommu_group_create_file(group, attr);
+		if (ret)
+			pr_warn("group %d: lazy-create %s failed: %d\n",
+				group->id,
+				iommu_group_lazy_attrs[i].name, ret);
+	}
+
+	iommu_group_sysfs_set_populated(group);
+out:
+	mutex_unlock(&group->sysfs_lazy.lock);
+}
+
 static const struct kobj_type iommu_group_ktype = {
 	.sysfs_ops = &iommu_group_sysfs_ops,
 	.release = iommu_group_release,
+	.populate     = iommu_group_populate_one,
+	.populate_all = iommu_group_populate_all,
 };
 
 /**
@@ -1060,6 +1165,7 @@ struct iommu_group *iommu_group_alloc(void)
 
 	group->kobj.kset = iommu_group_kset;
 	mutex_init(&group->mutex);
+	mutex_init(&group->sysfs_lazy.lock);
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
 	xa_init(&group->pasid_array);
@@ -1078,6 +1184,19 @@ struct iommu_group *iommu_group_alloc(void)
 		return ERR_PTR(ret);
 	}
 
+	/*
+	 * Defer reserved_regions and type - both are read only on
+	 * VFIO/iommufd ioctl paths, so let the populate callbacks
+	 * materialise them on demand.
+	 *
+	 * KERNFS_LAZY MUST be set before kobject_create_and_add("devices"),
+	 * which calls kernfs_inc_rev() on this kobject's directory and
+	 * would otherwise leave a stale negative dentry cached for a
+	 * missing reserved_regions/type child.  WARN_ON because
+	 * iommu_group_alloc() controls all group kobjects directly.
+	 */
+	WARN_ON(kernfs_set_lazy(group->kobj.sd));
+
 	group->devices_kobj = kobject_create_and_add("devices", &group->kobj);
 	if (!group->devices_kobj) {
 		kobject_put(&group->kobj); /* triggers .release & free */
@@ -1091,19 +1210,6 @@ struct iommu_group *iommu_group_alloc(void)
 	 */
 	kobject_put(&group->kobj);
 
-	ret = iommu_group_create_file(group,
-				      &iommu_group_attr_reserved_regions);
-	if (ret) {
-		kobject_put(group->devices_kobj);
-		return ERR_PTR(ret);
-	}
-
-	ret = iommu_group_create_file(group, &iommu_group_attr_type);
-	if (ret) {
-		kobject_put(group->devices_kobj);
-		return ERR_PTR(ret);
-	}
-
 	pr_debug("Allocated group %d\n", group->id);
 
 	return group;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


