Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD321094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D44D6B00CF; Sat, 21 Mar 2026 11:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9786B00D0; Sat, 21 Mar 2026 11:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6A66B00D1; Sat, 21 Mar 2026 11:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7A06B00CF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B416413B2E1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:24 +0000 (UTC)
X-FDA: 84570391248.17.C6A22B6
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id EFA0C1C000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KiOu5tW0;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KixtzO6qBa+4sBSVnEmaKMzBG/EvPApyoC742IFx6xs=;
	b=G4AZrpw8k13vpnR32TVQsqh+NDBGtkztwFBHigck6e7YC4HM8yOgggKKNOikGeTyU+n/Lv
	GZQnDHl+Qz5bL2b4HswQulKCcjClx1fixlmehLPBNER8Tt0aBB4thWMfarcfYQBCuZivNH
	Dit0Y+YymiT2SJ7FK3xNdjdG6Ou4gNU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KiOu5tW0;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105463; a=rsa-sha256;
	cv=none;
	b=eerSX7JNlxZ247Hriw0mGTVIHXt+b3dsGvtwJQD22MMm/1oWJxdsh/oEL4u7sMyrnijUAG
	hzfw/vX8CCwq2i0cld9Fba8KPMlNwTH1pzxsXJT2j8xc5mFtGh3jReTjjNvsY47UMPL9lm
	0LBU5yrXp0dY8KNLm0yBNeZSZgIBPgk=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cd7c372929so242987285a.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105462; x=1774710262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KixtzO6qBa+4sBSVnEmaKMzBG/EvPApyoC742IFx6xs=;
        b=KiOu5tW0UYl1Bs5lYInvdp5t83XI8FtzUn1OVbb/7i7gmCMWqN8C5LKSivTl6jl3r9
         20cfSPslSWHlpa8MGXfh7mk/dOSKcBK8/hEEo7Tx92JdO14MunnK88mVjSB+JDOuaqFX
         pACWGTEq1ignpvHBbMt7qT+DsjrzX+GAf8dJVF0EnkC/LxYyFd9pkAOlSp0f2FqGhoNS
         9FSRUGLsuY5b6GLDShwTOUaIQU6zfZTZJ2MMYAmnGdqAnZf20VVG5Ds38RVpFboVS5Eo
         Vfgoqrye1kSwCFgYkz8SAPcnwDdI7I/Kf4JX8laFMgWPw5CNONgNLlW1l6HOrGBMSt3/
         XE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105462; x=1774710262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KixtzO6qBa+4sBSVnEmaKMzBG/EvPApyoC742IFx6xs=;
        b=WeGeL1BKQWebPdLP8QTwWVSybI7quwhPvVbUdGtq2swgUx0ieA0NM2k9JhT7McNVxy
         3s6/cSpK7pwR7XHp0FKENB2V9mhNIYNEVRL8x1uTbwpHSR/A+cB8rz6bsKpFbsZ+7rJM
         OPaV5/YZUylp9lfhaG1U5NZyT8jII98SxPFr2ksxGgpLDGK46jSKg/XLkdW5IB8dOiZx
         Hd2gUn5QoQ7IV07CdRYh1WCR6z44m83Sa6U3SaUVu7d+uWXkyyMJVu2OuVmK0HhPQP1C
         nGnIG7JmF0kZPaAAP2caKDVaIq+vX0HG+ZwcsmFSB0c0KaWJUx/In1Ia6oLzhirZVQC/
         x0Lw==
X-Gm-Message-State: AOJu0YyEDY7XmpbzES6v+LOC44QNnoew/h3Z/F4KkdH6av/kPdQSM09w
	w/tS9+9zin9AQYiH+FCKTdYT/MHB4KxJL29Ph+ba7Bf8OyjoezbagGbqUQxDKxfjaRLhg7xEJT9
	ODebA
X-Gm-Gg: ATEYQzwGWlx/ZdMpRn+ueWeCo/5m4sDpCNR9n0Dj9x3Dw3a+x+jS/I1jnXNZiPRKkNU
	m9XT/Dz/4aNXiS3rNPr22iyqmVNVRV9UZNIZXS3eYCAsGoDX421TJmF6CewliAGCpJhOLOBJBeB
	VDr4E2K5DWMkmogeEgQ5YXBagg4Y2zWX5lE61R98IrBitTrYRQH1LR8Iavs/Uf6mmmr3/XaYqHs
	jurd9MzCAkbbRSumSuJ/Zmz4jhKewSe6EE70K9dYLA5ZZ+r3WAjhRcPV12WVWq6kV2Z17VrFfu3
	5Zta/Et3azY1dhpSzrXIRY6FMXvyPmFE4BEC+Fije/RZIhifsYTS16r5FS4ty9LP0q+7zu9780E
	BItbOoD9o07z5hv2R2eH1xfBfRS3slTA3b1glLJiPTi0BtbRHlSJatGoRs9txvSjDqHgDBxSpvf
	KAXv61h3SK3thhycvWRu+iImKF71UP/F1VDQ94x80OyZAeHjCvy0a9GAvBVC8/HLGBUHy5XafNv
	1C3dRJG1oMC69A=
X-Received: by 2002:a05:620a:254c:b0:8cd:d91f:b61 with SMTP id af79cd13be357-8cfc7f6a4camr969415785a.51.1774105461527;
        Sat, 21 Mar 2026 08:04:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:21 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/8] dax/kmem: extract hotplug/hotremove helper functions
Date: Sat, 21 Mar 2026 11:04:03 -0400
Message-ID: <20260321150404.3288786-8-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFA0C1C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 6pb6i61c3q8r9fp4q35q4zaa1fxkwzmj
X-Rspam-User: 
X-HE-Tag: 1774105462-722652
X-HE-Meta: U2FsdGVkX18VHyuMjFAwBoNYLuMAPxDaRhunXV2tmY9ppaXvFCX/ihFYetkBdYmN7AHVD2zwRO3QhxvuxtZVcJrQeKf22iGATNv7SqTPjiw4DVqv3FoLZOTztwSm9zo9JyFnTveREAX0+p1SrfIRqBL/KDcNh5pfJrQOIeamJCERnvu4SyCU5Lq8AR92BfUSu69MIEbBr5B8f8wsPxALVADJa0G5U1Rzgj6c68SyzDJ5n7/cuTfZRbAVU3W/Z/gDTzrfwi5nL/nb4KU15HSDpJ5aLFkX4zGYxIviRhVScO4e6VuCe+WbEQ8Neb9eYKQndYzkdzOplw8tcVmIrq18OiQb69tht3k7E/lOWUzUlV9IYrOdAvAu3QrxeXJCgbBwPxFH1rU4sGHn+HrMNrvk3bMimD/3YS2j9vvL+KPtbaSWJzcHDSGRR1oIFxV1OwchVvZecnhwAMqBlCKICmrrnDi4GVDjfBnmH7sCiVTu4x7TDpwOTiG21oiBRfD3CDBtElDnBTCxy29mfq0RHTL+pfWNkvNQJ0RAUNBBAaJeZ3284xg5seKLJmbyZIdxx4PYqJPg6DdIQNtA+PXVM1TjoRWXsuUHOysDQPECkPgJdGpzAdHtUZpWZIJubJPViybp8brUYpjmCKz7DTuE6b5/a3Pm4hANKCIJULagSiQconj3tHS2x1uK7/9Le0/lStlSHJD3p3xVsDObqhM4L8RNukRwR8tOBgKTzovQrxUj6K8Oj7o7QoXkOFu/TPJnKaeocNVubxwdaItYWh+CSojDVDuhoy3gqNQZLLHYbq0C8I5z+OFH0OIkPL+K8FGhtUgUxMB+qBLvSNl/U+C49xYSXp09YlxQduvHgD34Njm7OS88sx/iePzAtZJEc+MKe9Ou0zzGSZYDBYAuNqQSFaioVM/2ZjEiDPImSkcWvhpMn01e34JUr54v4HzQDsKtapRyZqEl8ws6BJRapDuCrj7
 zus+iuk2
 sUJGCnfC4HLN67ymTVxla2jPsVkee+kYerCQ2MfaAOk9C4RchO9MCZhGVM9AREp7cicnYZG+TimT+MrchPZbOVo4esBbXYRXraApzSPe08p05yBH4/a/GLMoHfdMxfNlyAg5ZXc6lS5FQFlIdCSEauwegvJjLq7kPTQUKYJWYmr0ffQKN+J9oMTyLdVeJYW7QC+9IfBf/2ruLzLkwkExkcIW/ug+CHfGi3xeEWrCaRdI87T3SAF0e6J++tvPHgw3Ge1zH3dnSRFQhK76XBxL8HxpG7DeN7qoHyE7zbYbTa7jrJyoiEa4axgytfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor kmem _probe() _remove() by extracting init, cleanup, hotplug,
and hot-remove logic into separate helper functions:

  - dax_kmem_init_resources: inits IO_RESOURCE w/ request_mem_region
  - dax_kmem_cleanup_resources: cleans up initialized IO_RESOURCE
  - dax_kmem_do_hotplug: handles memory region reservation and adding
  - dax_kmem_do_hotremove: handles memory removal and resource cleanup

This is a pure refactoring with no functional change. The helpers will
enable future extensions to support more granular control over memory
hotplug operations.

We need to split hotplug/remove and init/cleanup in order to have the
resources available for hot-add.  Otherwise, when probe occurs, the dax
devices are never added to sysfs because the resources are never
registered.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 308 ++++++++++++++++++++++++++++++---------------
 1 file changed, 210 insertions(+), 98 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index d4c34b2e3766..8be9286f0ea3 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -47,15 +47,189 @@ struct dax_kmem_data {
 	struct resource *res[];
 };
 
+/**
+ * dax_kmem_do_hotplug - hotplug memory for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Hotplugs all ranges in the dev_dax region as system memory.
+ *
+ * Returns the number of successfully mapped ranges, or negative error.
+ */
+static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
+			       struct dax_kmem_data *data,
+			       int online_type)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, onlined = 0;
+	mhp_t mhp_flags;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
+		/*
+		 * Ensure that future kexec'd kernels will not treat
+		 * this as RAM automatically.
+		 */
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
+
+		if (rc) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
+				 i, range.start, range.end);
+			if (onlined)
+				continue;
+			return rc;
+		}
+		onlined++;
+	}
+
+	return onlined;
+}
+
+/**
+ * dax_kmem_init_resources - create memory regions for dax kmem
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Initializes all the resources for the DAX
+ *
+ * Returns the number of successfully mapped ranges, or negative error.
+ */
+static int dax_kmem_init_resources(struct dev_dax *dev_dax,
+				   struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, mapped = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct resource *res;
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		/* Skip ranges already added */
+		if (data->res[i])
+			continue;
+
+		/* Region is permanently reserved if hotremove fails. */
+		res = request_mem_region(range.start, range_len(&range),
+					 data->res_name);
+		if (!res) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
+				 i, range.start, range.end);
+			/*
+			 * Once some memory has been onlined we can't
+			 * assume that it can be un-onlined safely.
+			 */
+			if (mapped)
+				continue;
+			return -EBUSY;
+		}
+		data->res[i] = res;
+		/*
+		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
+		 * so that add_memory() can add a child resource.  Do not
+		 * inherit flags from the parent since it may set new flags
+		 * unknown to us that will break add_memory() below.
+		 */
+		res->flags = IORESOURCE_SYSTEM_RAM;
+		mapped++;
+	}
+	return mapped;
+}
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/**
+ * dax_kmem_do_hotremove - hot-remove memory for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Removes all ranges in the dev_dax region.
+ *
+ * Returns the number of successfully removed ranges.
+ */
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, success = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+		int rc;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		/* Skip ranges not currently added */
+		if (!data->res[i])
+			continue;
+
+		rc = remove_memory(range.start, range_len(&range));
+		if (rc == 0) {
+			/* Release the resource for the successfully removed range */
+			remove_resource(data->res[i]);
+			kfree(data->res[i]);
+			data->res[i] = NULL;
+			success++;
+			continue;
+		}
+		any_hotremove_failed = true;
+		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
+			i, range.start, range.end);
+	}
+
+	return success;
+}
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -EBUSY;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
+/**
+ * dax_kmem_cleanup_resources - remove the dax memory resources
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Removes all resources in the dev_dax region.
+ */
+static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
+				       struct dax_kmem_data *data)
+{
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
+			continue;
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
 	unsigned long total_len = 0, orig_len = 0;
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
-	int i, rc, mapped = 0;
-	enum mmop online_type;
-	mhp_t mhp_flags;
+	int i, rc;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
 
@@ -116,72 +290,27 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
-
-	online_type = dev_dax->online_type;
-
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct resource *res;
-		struct range range;
-
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
-			continue;
-
-		/* Region is permanently reserved if hotremove fails. */
-		res = request_mem_region(range.start, range_len(&range), data->res_name);
-		if (!res) {
-			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
-					i, range.start, range.end);
-			/*
-			 * Once some memory has been onlined we can't
-			 * assume that it can be un-onlined safely.
-			 */
-			if (mapped)
-				continue;
-			rc = -EBUSY;
-			goto err_request_mem;
-		}
-		data->res[i] = res;
-
-		/*
-		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
-		 * so that add_memory() can add a child resource.  Do not
-		 * inherit flags from the parent since it may set new flags
-		 * unknown to us that will break add_memory() below.
-		 */
-		res->flags = IORESOURCE_SYSTEM_RAM;
-
-		mhp_flags = MHP_NID_IS_MGID;
-		if (dev_dax->memmap_on_memory)
-			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
-
-		/*
-		 * Ensure that future kexec'd kernels will not treat
-		 * this as RAM automatically.
-		 */
-		rc = __add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags,
-				online_type);
-
-		if (rc) {
-			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
-					i, range.start, range.end);
-			remove_resource(res);
-			kfree(res);
-			data->res[i] = NULL;
-			if (mapped)
-				continue;
-			goto err_request_mem;
-		}
-		mapped++;
-	}
 	data->mtype = mtype;
 
 	dev_set_drvdata(dev, data);
 
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		goto err_resources;
+
+	/*
+	 * Hotplug using the configured online type for this device.
+	 */
+	rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
+	if (rc < 0)
+		goto err_hotplug;
+
 	return 0;
 
-err_request_mem:
+err_hotplug:
+	dax_kmem_cleanup_resources(dev_dax, data);
+err_resources:
+	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
 	kfree(data->res_name);
@@ -195,7 +324,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -206,42 +335,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	 * there is no way to hotremove this memory until reboot because device
 	 * unbind will succeed even if we return failure.
 	 */
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct range range;
-		int rc;
-
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
-			continue;
-
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
-			continue;
-		}
-		any_hotremove_failed = true;
-		dev_err(dev,
-			"mapping%d: %#llx-%#llx cannot be hotremoved until the next reboot\n",
-				i, range.start, range.end);
+	success = dax_kmem_do_hotremove(dev_dax, data);
+	if (success < dev_dax->nr_range) {
+		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+		return;
 	}
 
-	if (success >= dev_dax->nr_range) {
-		memory_group_unregister(data->mgid);
-		kfree(data->res_name);
-		kfree(data);
-		dev_set_drvdata(dev, NULL);
-		/*
-		 * Clear the memtype association on successful unplug.
-		 * If not, we have memory blocks left which can be
-		 * offlined/onlined later. We need to keep memory_dev_type
-		 * for that. This implies this reference will be around
-		 * till next reboot.
-		 */
-		clear_node_memory_type(node, data->mtype);
-	}
+	dax_kmem_cleanup_resources(dev_dax, data);
+	memory_group_unregister(data->mgid);
+	kfree(data->res_name);
+	kfree(data);
+	dev_set_drvdata(dev, NULL);
+	/*
+	 * Clear the memtype association on successful unplug.
+	 * If not, we have memory blocks left which can be
+	 * offlined/onlined later. We need to keep memory_dev_type
+	 * for that. This implies this reference will be around
+	 * till next reboot.
+	 */
+	clear_node_memory_type(node, data->mtype);
 }
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
-- 
2.53.0


