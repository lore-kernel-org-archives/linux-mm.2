Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F462C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2DE6B00B1; Tue, 30 Jun 2026 17:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963076B00B2; Tue, 30 Jun 2026 17:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767016B00B4; Tue, 30 Jun 2026 17:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFE06B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C52789650
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:05 +0000 (UTC)
X-FDA: 84937844250.25.F36B280
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id D04172000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R6F+V+R0;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854343;
	b=cAgRLJ/kUOonwvy3fbv8c3jDKm5QsIrbw+nhz1vKCzEZCFYSEzp1qgimGlCbmwsfbshzBQ
	ta9z1sqlDNbVJnrJW5oNaITsWQD9X6be5W7vSWCfNWmCDpXDfywHHGBJed9wocUh6kAIB0
	T7s7+Y0pVBY83E1Tl5nxxoCR2PTduIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOkCWnqZVGJ7C+jdT75jmur1k0KIbep2C9BRrd2hTIw=;
	b=IF0t6zbSyM/bCMJrvHtWuo+FmwDU06/TH/01HIiGv3OMoVLqP6YfXGf6xnOxHXUCkhufrO
	bLsDnk9/cN51BuhPF1PRVAozYBDuDip+kvr5uxHA0WxJlYvK+OHd+RPdBfv+mRvXcqEKZi
	LmwP6/Eov9w2VCYGsZckTFgpjSxjU6Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R6F+V+R0;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e54f8c051so184117985a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854343; x=1783459143; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOkCWnqZVGJ7C+jdT75jmur1k0KIbep2C9BRrd2hTIw=;
        b=R6F+V+R0+C+VL4tgHtQjKPDFg32mUgojmXavWU7cDcF5QlyqXgLR25bmKRSShHJCC2
         CZhQJvb/Lc9TFGCOAVcXDrXlX13+IF6R5kTKBoRXXVbMIaclPlXkclPF1L/yyEIkltbW
         2/xP9IoqwTh2VgCRmvphdHjddCn/ERsBRrrvUHeLvk24lXavEbqavV8xjV6YRk7CzO0s
         csrKphyQCGFH14folzeDgemyapfXWGvJYDxADuE4Bd7AsWlxIobydaXfl4EciikORYfv
         OHrhuVTiKjoZDoBVlL7mBbNFlhy39rJPbW+LUANPL0SKbcgnFoHl5aiaILeQY1V3q9wn
         wwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854343; x=1783459143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NOkCWnqZVGJ7C+jdT75jmur1k0KIbep2C9BRrd2hTIw=;
        b=YtbcukURPDbequepgjMltkQ/WmMQcjQgIUVh9qFojxGl+AdOKw3IgybAEL44tV6J2d
         1cm3qQEUg85WdSyCLaCvIJgYL5f/vOiYIM7YE3aJLuq8t92LBlZgS2/KSpeINyTmX0kT
         LpfEmKjNYIXJfHNVwvXcTElmYvGkSB3KUytotWZ+1TjWBPPh+mGWS9TyksSGc9rIHxxe
         rDW7xeRLLd59yrEZajEsbkfQeXIIAPtWL+yIMnL6e7Ni9t+ZmudAtFGjP0nH9VxOayo3
         hUrXObPhwRCHhN9OqV+F1BpN6N6dK/rYjqwhoXVao6FyGCNknmwcqZ1NJo5v7yF9JH3c
         ETvQ==
X-Gm-Message-State: AOJu0YykVuX6UAUdYa0a/C9NKlQ1u0/poMX9sSE29BAyyxTQKnTzoI6a
	/qlaTg9FTLzG/4Xeb6jaSXcU27fzP3hnHcwuAMlzevWVgn2st9HoHeZ5Skq2b6bRVzZ372btDfr
	QjmpK
X-Gm-Gg: AfdE7cn1r+6/XyENFcOG/zkph7uWWKAP7HmCq2sSMC7GKbjA8qdzCHed3K4vCs613Z4
	2TMSuIIRrAKYvN48kYMc5mEn0Ppl8hoD5ku/rWhOByKFcfFhEhHJCiU8U8PShodhZPDOWUHPYMK
	Yz783nHMTGwTtyDys1z8av3UjTwGhQ5NyMHPhiUaPv1DobIpgfiEqpUy+lnGG1HwmjD3wRrEnr1
	k5NjGP9DVJpJjn2fUCfUN+w6NZzN+VhuBjOtr8Qt2WsATzHuanZJLUB+uZEhWiW78PnLjm1cvUk
	QgYqGKsshwh1gS+PGP+04fSaAiaXGSytI/CpOIfJgEKAExDthBz/elomHEybXsE/rKh0ypduOhm
	Ck6hH9/SB5O3xRt3whOSxCD8Hkk/rimSCAKpUM/H3ytYZ6HCFQXHuQDvmEjPU7r9G+XNK0q0i02
	NLYJiYo1n0pWNevBhOJ5iFBf+rNlcj749ikBpTgHWmVajFTdWO4IWHPOrp3+vmoN/sbhKpMBuln
	A==
X-Received: by 2002:a05:620a:4411:b0:92e:6c8a:2a1a with SMTP id af79cd13be357-92e6c8a3c36mr414263485a.7.1782854342795;
        Tue, 30 Jun 2026 14:19:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:02 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 08/10] dax/kmem: extract hotplug/hotremove helper functions
Date: Tue, 30 Jun 2026 17:18:40 -0400
Message-ID: <20260630211842.2252800-9-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 89c9rfztfpcktgjmn7fw5xuqe55o8fax
X-Rspamd-Queue-Id: D04172000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782854343-880929
X-HE-Meta: U2FsdGVkX1+RRsboBmsmpUBoaYM3a1FemTIMW2pT48BP7tYNneo5TSKylCzXgkHTLRdqjm2FClTrKzr15Bybl1mwJuxZs16U+YMENRG4v7YMCXzXuo5SG9R0g5js+NqwTmYnRsk0yfdPuIX+scqTYLsn/Jl3wp1PzfamVSI3lCKIIU6EcQo7+Du91AbNx+JJyA1VkZcYIAlpcM9uZcuQbTdesZ0djLZraVYsIiKZcD2zi07hAGpJmepzTCubMjhM6crrIDZjVIxpb3RBKkTbZtgBOBCmoG1vl+XMQC4Is3OKa0rT3mQ/mv3gnbjnebfockYHGg5q5UV7gPIQwBX02o70Gda6FlLbYf1yi5G3aq/6OtLcOwtWQMPSqOaaPDjF+1QEjnxswO1+xLo6tym/jFWAkYTAn33zM1xp+5c3K3wLrkfuHCeiqczIr+iN8PmWDbXoUgxaTFx58yQfVQE12MJx7XDVnL+/O4PdOVvLEQmrwguXxuPdXpC2Z+W35h0HyZVWT1TDF78zcICy/vPUugLGs9U0t5iP8JnLP6KC8stLEAWU66GUMkFUe+U/rUGZ4SPtZLJ8ZIe30UtrY5iFpUXfomvTCyejFooi1senTTJdPEwnu7hoeHgKLfaM7zafQMLm6AF8GhRogmHpE80TdKh9UmQGV7ZTEUfWZKC+yRuwp/e9d/7ZGlkHEr5EBJSnBD9SAuId0AcR9f6GwCJ21+xOIAzwxp4EWQNYDOYgTLyVAVRPdPrXPVzmLNTCglQOn5S/7AcjarI7E4KEeEPLZQRSI2nLg7Y5whMY1XKiYE7cIrvsGTYIB2PCFTEwaxKSGHFgKeWEc4coWc4vxYsw7kG1ObmkybA4LCsamO608V90jkkgojC2d8JS2NaAFM6mZm1lDuvDTlGsXpEVzVZarvqB+lS3elimFdT7gk2fGnnfmjA5X7y0YDFMRz0APqmtwn7vyIyNvaDhPXFArPs
 hbWt5ND2
 stpqcL3LW2HAJMasuN34OTJeczUczv4+ytL0+VJ2fF2dmBqRZbiayrGqV/zgplpy2ZCNCDK/S/+CkuUJAAKRMApIli35ClD2zzHx7wRelQ6B/Az9Nu/+udBwsUihzq5tlkY/eH1F7+t/aSWULPucEuaNhhvxrtK+0cgebO41y2pNd+rVFskCrm9F0iGxkvTScewLemiRl1lqlErGl6/AJRDPK2m8WaAuy+DAbTnaDsch63YKTWqGavpCWHxMhDfUg+xiMoBKmuq54flldjZXCzI+7Mkuf/zahksCIZnz0kI6geDLsUlrbSRhkMQ==
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

We need to split hotplug/hotunplug and init/cleanup in order to have the
resources available for hot-add.  Otherwise, when probe occurs, the dax
devices are never added to sysfs because the resources are never
registered.

Detatching hotunplug/cleanup allows us to re-use the hotunplug code
without destroying the underlying resources.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 327 +++++++++++++++++++++++++++++++--------------
 1 file changed, 225 insertions(+), 102 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 0a184c0878dd..72dcccee41e1 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -63,14 +63,206 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
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
+		/*
+		 * init_resources() is best-effort: if a reservation conflict
+		 * occurs it keeps the range but leaves res[i]=NULL. For hotplug
+		 * on probe systems, this means kmem will partially online.
+		 *
+		 * We have to keep this behavior not to break those systems.
+		 * For those systems - atomicity only applies to valid ranges.
+		 */
+		if (!data->res[i])
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
+			/*
+			 * Release the reservation for the range that failed to
+			 * add so a later hotremove does not try to remove memory
+			 * that was never added.
+			 */
+			if (data->res[i]) {
+				remove_resource(data->res[i]);
+				kfree(data->res[i]);
+				data->res[i] = NULL;
+			}
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
+		/* range was never added during probe, count as removed */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
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
-	mhp_t mhp_flags;
+	int i, rc;
 	int numa_node;
 	int online_type;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
@@ -133,73 +325,27 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	dev_set_drvdata(dev, data);
+
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		goto err_resources;
+
 	/* Resolve system default at bind time in case it changed */
 	online_type = dev_dax->online_type;
 	if (online_type == DAX_ONLINE_DEFAULT)
 		online_type = mhp_get_default_online_type();
 
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
-
-	dev_set_drvdata(dev, data);
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		goto err_hotplug;
 
 	return 0;
 
-err_request_mem:
+err_hotplug:
+	dax_kmem_cleanup_resources(dev_dax, data);
+err_resources:
+	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
 	kfree(data->res_name);
@@ -213,7 +359,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -224,48 +370,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
-		/* range was never added during probe */
-		if (!data->res[i]) {
-			success++;
-			continue;
-		}
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
-		clear_node_memory_type(node, NULL);
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
+	clear_node_memory_type(node, NULL);
 }
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
-- 
2.53.0-Meta


