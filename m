Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F03D31A26
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C89B6B0093; Wed, 14 Jan 2026 03:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379716B0095; Wed, 14 Jan 2026 03:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E83C6B0096; Wed, 14 Jan 2026 03:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB006B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F42914042E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:45 +0000 (UTC)
X-FDA: 84329953890.04.F5BDFDA
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11DBB40009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GKtgL7tb;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jiGG+pI5vJ9QdTZL/6UItyqMN2lMDN4VjpLN+CazVs=;
	b=hc57saNj8IPzFN9JGIDw4uaHXQqKsmIZAypwJ5i27G9fvwDso7HctpWwfqPdSl9UMsy/0r
	cJFXYY+79erukhNRkOI7+inUmOLUiopxm2LxgSxqbks5G1r0JJT2vmA1rrdeVdf01Woz0X
	7cXEqHBK7hcIOL37ri1wCf1n1sjaT3o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GKtgL7tb;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380764; a=rsa-sha256;
	cv=none;
	b=q8J6SwVM1n8zkO5Xzkhuk5KKPr4D04/CDGDbpU302pDl+5DKOtRZVCrWt8dLpJ07wgzVX2
	tPXOR/zJurDhZMqTwZmab14xshW1Qwl3taLY3X9WIBX0ln0ENwMnZPSV2ijJEtKU00R3jB
	lPUKkTZmK5QBHaHi3GnXq99tyOmWJ70=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50145d27b4cso10547531cf.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380763; x=1768985563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jiGG+pI5vJ9QdTZL/6UItyqMN2lMDN4VjpLN+CazVs=;
        b=GKtgL7tbfslxmnor9zqYlG1g0FGejHyjtd9GyrC56ZSi7RN60jEp71jvyuc8Eu4/DC
         XHnn7ASDr+c16LR72aEofg7EAcQmSzo9R04XFKmf0JwyWFVVWMONthIRSWLkwsaszwI7
         dffc32DujhtLIGWDZENdiarmBtrxOerWKz9vE9XgsW1PV7wlOiqhsY/v/qOd1W2Da6uv
         drDaGGNsJ6dv24uuZ8RGf+sZoOgJjmMsMooL2c8H0uJu68dADIj/+eBLE3bEoUKptr6m
         0SsBeRrolgLqBR/qHxfPkVASjWAiEvb08eaXy9Znkatc2LC9+cM2o74GkSjiWDTCZU1w
         MkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380763; x=1768985563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7jiGG+pI5vJ9QdTZL/6UItyqMN2lMDN4VjpLN+CazVs=;
        b=XIiJlrTQkDAHAXAK6CLIT3N4hiry07D+PJPwiWsO6bUHdnTBW+1n0TYeMiXXI9TgLT
         DNgodoOJ45ifd9LacUCWHsiR11nsEUdBnrhEA8Auhcb2zMQbO+BdaRWHmb/xYMbCzict
         CqO9WCkjU/xpF674nidQcAGmY1AvpJsmIlWOVPaPxeILBwTpW6s3HrNI7kPnwQWxPUB+
         n8nX3ugTpf0d10YRqxPvgOB8ml8iAwAVKXL/pf/RLgFsKRqbqVJuEhuIinjZWOZfyMD7
         0LwEj0uciwAI+Sd9nhnfLyetBKmjevZu8qL0MKCcQVqJLC88/sv2XV7mk6tWhCnPpldX
         9Rvg==
X-Gm-Message-State: AOJu0Yxe4MlG87aDmb1fxl5ihuqoyVTrTPEqTr1nXbEXCCorOwTDLVQ0
	WisD+bmrXSPhsQuGItGJv2kDdhUyQ3w8grq5HbAJQVFvjkDpe5Brrs/3JITy3w8palIVxR3mXs4
	7BU+TtPo=
X-Gm-Gg: AY/fxX6pRjw0TEvisxzzrMQU2VJCoTuetT9cLkv5dWC4I/ZJdTp4Q1UZch6zwtKQAPZ
	UXicUzYHf9A5KcR4wHQcqPND2T6jdqsISzfLiQ+2u7AN2H84SMZgwUeqARVfnoqhIRZ1dhqZ6ii
	YfZWctFlJQmiYE+NwF8rVC/35Ts85zGoOuORO23Bz2B2nii69SKKHf2hUewU+xeFNkyjm1Gbuzy
	3p15HymKcq71ud4G9rQ6vdBilwvkx5BOFP/2BIPbY5K+McG/zZI+uePVWop69Wgg4PQeUqFRjAM
	DyB4Vj+t8zK886X6+6JLJi5lF1k9GUTS37h0Dyvm4Ejf7vGpOrIqibDUSbIlrfBkesfNn3PRJBP
	baQzAnayznArJd/8AdDauSzxQX3gVc8cFxL1vFOxZzBcCzEm2DTbgkOC3PVI3IiK42SZuC5WdZ1
	iHmuGkCO9e53mCqUFGvZD35fag04H4PMGdF7Ek3rdS0cJc7PrmOv/6IXt8U0crc4JlMvZlFSiS1
	dY=
X-Received: by 2002:a05:622a:1b1e:b0:4f4:d295:1f53 with SMTP id d75a77b69052e-501484b9dabmr20297781cf.84.1768380762822;
        Wed, 14 Jan 2026 00:52:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:42 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 5/8] dax/kmem: extract hotplug/hotremove helper functions
Date: Wed, 14 Jan 2026 03:51:57 -0500
Message-ID: <20260114085201.3222597-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 11DBB40009
X-Stat-Signature: k5595ddxa4awxynno1eq3oktn4bun4wz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768380763-92260
X-HE-Meta: U2FsdGVkX19ZFvYRAVZ5yvcs745X/b/PfGKrGmbVeLrCBihwirPEklk9FsI6l4hDgUBMT6BqBnnFUtjKGnqQ1V6LYYzHnOI1hpv+xuZpqMVeW2LQX+qy0HeKh1tKjq3h6xDZLGUvW/lY3++7qh7iaoUYVzOX3Cw2SFp9yiI9Wg3XfBjw176Whb9CQnaWEtyfrG9P81ZTM3yxF5Y8Fv33sEQRmzNXNBaK3RmUo3ToS74uPt3/rKC3KJTdhC3rLw4GaaEhXUalEaA1sjOiuzu9bxleI/b/mXUGGL85mA/n/kolmH3VnEW/ZeYxeeOFSLXYKVqXw3TdqxpPveUnduOBRQS9GoJ5r2mO7zIp3+dMhMhNPhIhBHEG/X79kfDvZvEpiGX9cSuATPQ3P3/qbDV3gMS57NqqPL6Lso0uQwlTw/FOYwZrNPi8RUrV28yzu1sk0IXwLfpAfBIJb2hhUBHSFdP9Jlzay6Q5PjePrqKdLUop/PG1LrYs2FaUW96aHVbJ7/lq3syso5dIjlWKNC4x+2+VvJw5L6zWINWn4sAB0EHe03kJnPOR/fyFgqF7rehvW7Lr9EfQVX6ZNwWF7R9w5gcbfOyof0HXGv1jo2CoK/wR4YhjSh5uFFcqdfDvNkrHGyqYSTMTXq56Ob+d2l9YP9hSKIApw0+j9LtPHTaHZYbrthpYHKfYNrqSZvMWWy7oxz7aS3s/k5SCR/kUQVB4klHQ9QxLm43TjzgV4zJIqp4gzTmyqbVT/zgPcBUJPzZxVtv9RGcTqeCKNOWTFIJBju8t0EwHtjP0lrA3HwB6X9DzYujeKYQVjxE0smPNHTbtpusEgGqsqTvFzxTVA0ahkvlBMVs5GdwBNvF94IvxaxhPDigJA0LRwunCMGXwOGIj9ep1TcnpNhNhGusIU/YplbkipX71iaEkOzJo7USXgY3OxtG6nn9jVYc0DAi7/irbsw5w3d1h59P4JJOthPY
 bYi7ekS6
 KDPHU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor dev_dax_kmem_probe() and dev_dax_kmem_remove() by extracting
the memory hotplug and hot-remove logic into separate helper functions:

  - dax_kmem_do_hotplug(): handles memory region reservation and adding
  - dax_kmem_do_hotremove(): handles memory removal and resource cleanup

Update to use the new add_memory_driver_managed() signature with
explicit online_type parameter, passing MMOP_SYSTEM_DEFAULT to
maintain existing behavior.

This is a pure refactoring with no functional change. The helpers will
enable future extensions to support more granular control over memory
hotplug operations.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 244 +++++++++++++++++++++++++++------------------
 1 file changed, 149 insertions(+), 95 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index d0dd36c536a0..5225f2bf0b2a 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -65,14 +65,138 @@ static void kmem_put_memory_types(void)
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
+			       struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, mapped = 0;
+	mhp_t mhp_flags;
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
+
+		/*
+		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
+		 * so that add_memory() can add a child resource.  Do not
+		 * inherit flags from the parent since it may set new flags
+		 * unknown to us that will break add_memory() below.
+		 */
+		res->flags = IORESOURCE_SYSTEM_RAM;
+
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
+		/*
+		 * Ensure that future kexec'd kernels will not treat
+		 * this as RAM automatically.
+		 */
+		rc = add_memory_driver_managed(data->mgid, range.start,
+					       range_len(&range), kmem_name,
+					       mhp_flags, MMOP_SYSTEM_DEFAULT);
+
+		if (rc < 0) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
+				 i, range.start, range.end);
+			remove_resource(res);
+			kfree(res);
+			data->res[i] = NULL;
+			if (mapped)
+				continue;
+			return rc;
+		}
+		mapped++;
+	}
+
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
+			remove_resource(data->res[i]);
+			kfree(data->res[i]);
+			data->res[i] = NULL;
+			success++;
+			continue;
+		}
+		any_hotremove_failed = true;
+		dev_err(dev, "mapping%d: %#llx-%#llx offline failed\n",
+			i, range.start, range.end);
+	}
+
+	return success;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
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
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 
@@ -134,68 +258,16 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
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
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags,
-				MMOP_SYSTEM_DEFAULT);
-
-		if (rc < 0) {
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
 	dev_set_drvdata(dev, data);
 
+	rc = dax_kmem_do_hotplug(dev_dax, data);
+	if (rc < 0)
+		goto err_hotplug;
+
 	return 0;
 
-err_request_mem:
+err_hotplug:
+	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
 	kfree(data->res_name);
@@ -209,7 +281,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -220,42 +292,24 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
-		clear_node_memory_type(node, NULL);
-	}
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
2.52.0


