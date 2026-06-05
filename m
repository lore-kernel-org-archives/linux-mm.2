Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AF0CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4648C6B009E; Fri,  5 Jun 2026 17:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDF06B009F; Fri,  5 Jun 2026 17:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2673C6B00A0; Fri,  5 Jun 2026 17:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1208B6B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2F7D1202B9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:32 +0000 (UTC)
X-FDA: 84847125384.24.82EB237
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id E657D40011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GJO4oDDY;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1H+lnA3hHkYKrmCU4qT2yVGlOrCCjEQC0F6y9K5Vd5I=;
	b=E6lsbi7DaJZNNqAXKCM2F/5Z+9UtriAaCVHMHhpUdz03Aw1BK1kPlq8azV/5E+z5A/mXFg
	YTntWxJ2JKWVOX4+vFM5kVwhl7KSY3R7uvZlwlJ+RneLBUJ+A+Qji7uxNfuvbjdHzX5Deo
	Omg601O6UQsQrYLq8T2oa0E/EriF7RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694370;
	b=qZTLqt0WO6I6dzieKyC6xvIRslEQN24N0jKKntmxYGMEyZiTGlzhzFxlLE51MC8oMlLHz4
	o907FoaGtZvC+RGmgNAimYx3XJNYyk9r99bxRraUTrQJoB2OYUaAcuesgGI8G0WQUqA1Uj
	QgNrTlf71iRgZwX+ALdnFZbGcW32GXg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GJO4oDDY;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ccf0fa0aacso28686466d6.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694370; x=1781299170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1H+lnA3hHkYKrmCU4qT2yVGlOrCCjEQC0F6y9K5Vd5I=;
        b=GJO4oDDYW4bllpodTC4c/VvcWq8AXpduPaoB9b8eK3FsKNkNsZFgtDNXyZCwQJBQJo
         gKEHRjADRGCyY+9k/+qHPgZByLo+9LXZCja5GYz5pF27IhZy9ltqgkUL0Zl8w7N3BwX8
         R66Gqpxy5epVaTJn/dSBzxFbPCn1mgwoZWqcxnFCD/n+8uhcETGUY7c2QWZ/FsAIB/3j
         Tlu/RpfbpYPwTsjdDGopAtYhCDUcYKXKgYf4YK38/mVMwoC6bBOUy+py9ZDG0sCHh3aq
         dTLx8+wdEVu1fxW0aT+rn1pfK0fYQP9+Y04UYbaiLHQBg9OtesO3+7wBlunnUs7w4EML
         9cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694370; x=1781299170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1H+lnA3hHkYKrmCU4qT2yVGlOrCCjEQC0F6y9K5Vd5I=;
        b=p1vcwL7UVqZ7mFMrVKf4diakvTDW6BJ4c9T4pz6ge+jimYr4ZtnCFTzAhgj1+ykykQ
         hwOFeLw1Hkqf3f//NLGN+GSZrLE90+GFa589wJnp+88MH8q8/6l8Jinjgg9GpaPioQXt
         lh3J03XJ2Rqh3RO7rQWoQezPyUUeE2VSXcS/8OW4iRMQ1Q9CDKFu1Pl6RxfKSeXcot6s
         kb0vK9zNIjUNcVCXjUKwxH1V2mp1iNXrlWCV+XamBmDqgGOD7gZHjweJUJUY6tg1m+wu
         hoqmMAJDEUpSMErEOFPnSAUIXVpD6RdkWdHBgvYreFQ8NbPbJri1m5BFfczrQJDYoD1J
         nnrw==
X-Gm-Message-State: AOJu0YxhQ6bHGUPAONCohCSK9h3HjI5VSGNrJ9uMmesx79yGs5A6Hxm1
	nbxTRNC21Jnh2dNEvY4s9xEx2kZaFWf3zEaS4HP0Npr6wZKhrNyyQ/WHWepmyEY3EQGRcoGgwYU
	YYO7Bac51qA==
X-Gm-Gg: Acq92OHkC0USV0+hHcG+19F49lQxgpdO0mjccOPydfP4iqVmwYi2VNAHYTyxqkiHPCN
	CPYUhV8bzY+1SQvfKxcTB7voqpVAxMRwBiF83tPaJ6E5ORxQ4Tj3h2JHA3anI/L5DUQibwAl8Vw
	Put8t2TDJUltmx4NGWjCRdQA4qB6r2UKIN5ypN3M/6wbyhii+21J8KxvRZNfA5KMHxjL9lcPb7D
	ac1+g58JyL46QLsd5Jhp8kLHJkoKUGy/+E3hQ4Ma195SR4C0GcpJrmwBwzlu6/t9ohHw0zWA9/g
	nNSW19YUi2U/kVP1VoD1/nDWDQdieiSqp/A+sj6SPxAh8O8tuF6JURwzT3tNbhrntU4T0L5baQz
	EUjeeWRwkT03h9EZwPx1NIiDVTKZtlu+dyg+1BTfuiu0Ys6V+2h64w7oUwlRYu9ulIX82j03ZJZ
	GUsJ6pGDtYxVoPcwhj7aRXRH4BE2Lg5Mgzv1OMCq5YHIPfOQ2w84wEb9YU1Q2e2Jak9bIy/1jn1
	49sXoXp91LSZGfxPGqtPbBjkfIPnox3Bw==
X-Received: by 2002:a05:6214:55ca:b0:8cc:f3e7:7c1d with SMTP id 6a1803df08f44-8cee61473ebmr73558816d6.32.1780694369678;
        Fri, 05 Jun 2026 14:19:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:29 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 7/9] dax/kmem: extract hotplug/hotremove helper functions
Date: Fri,  5 Jun 2026 22:19:09 +0100
Message-ID: <20260605211911.2160954-8-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E657D40011
X-Rspam-User: 
X-Stat-Signature: zhdi9kfasr8cqimhj9igasnew3zef631
X-Rspamd-Server: rspam08
X-HE-Tag: 1780694370-818753
X-HE-Meta: U2FsdGVkX1/GNimIK9/TMGj9Gn4jvRMBJTdhAYBmvGiLjRAzEVJcKFXyt6npHm2/fyxCbmBXEUCsQ7iVcG+2Ea0b72eKqlo0giWNYIZKePKx7RUX27/z5gk3nKIi/CzScsuQGhjVgWYrMmNx0HPuj3CPH030Sii1sy2lFpAGk1beFPmmtTVv177Twnq2gh1899tr67ZCWZGiMLPdCVFrW3BmYhEzt2bpWjg8B2I2uF/lEn9GWSsc1MJOWSZMZ6JsAcAvbBxykMCzaiy7l6xSSMsSGXJYpNdp76WFGM4QuKqiwUQ9lCiiRPHhrt8707DVwfxbPVq7yLoFmEkhWDT/Mc35nhyDaGbkg//6C5jgA5S2epUgN2FAPrUEe8A0JkMV1w+47xwfJr2FD/reCKEtAm9oPBkdMSMrMcUBforqfinv/SDx41jP57hEjKwPXvqh5Gv4fNL/t8sm5oaQW1BGeayWx+USxnUPpwNwaxZ3oWCrFaOSJVerXy+a7eUBpeB4Sv++ZoIOY9/e0GqG2OwqQQEyqEZ27bB7IQ/RAnXsIzHr60ZLbfIqWJ6TQxMHMmoAMEhhV2dzAbJ3bkhLkfu0mGEWgVsve10PdRn8JWOh4w2f5+1wdyXSnp+jgD2cDW1RQqcea9XnbwpgzJOlQEU+AwOnKMWpzDeAYEYJ9fdM90HkD24Jv1k91v/C6mqpUaHaiv+kJhhL0r5BaG0rGJJtSiDvOaVUYmvb2V17evbHWVrKRnmqvH7vyB87f7uTzds6jacOSebTr1TZavfg3ecuQ1I4Ki3RFmHEO4kYBP4iUxqDS5Zn+lGZHplaZx1ZLThLD0o8pTHf0pdnlPJTXLLiQzcelwiBc65kHOfH9isOfnlCn1Wm89IB8hkHljOJ136GSMWDq+ExQ37QywdSWFykUUFR209Aj+v1r1fGIHy+KC8A8bsDk5CbYZgtqud8lM6NulLWhy9ULfowJh3C6np
 P3KvzTQR
 MkP4rCLdkLulLuu72gDmZV9wBipg/6DholmhUa3H5egL3GI1SZ5Rib+vtUtVYj00W0A0hvoCHT0yBTlo27UU+bvAwapclyz25dNVn2fHCiCCEtLhnU6SzdBZ3dmPMaPmp8xEGwyJS5hRvJ03PLZ5Sd0CWcNIICU1QXFvP9+RizUweyAR4p8OPgLDmWRg/ZkiMHqPzMcsgXvfaapT80St1mUE0Z5WsKizqckMsvW1nATQOre3XaSLk3unvy9XOxf8H1EKz03x9dzRoVXmr9FVxDEuQoN30D7eagBUVEIVmLktUzp2xYfTWjtEyXA==
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
 drivers/dax/kmem.c | 315 +++++++++++++++++++++++++++++++--------------
 1 file changed, 215 insertions(+), 100 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 41ccb618a146..5bf36ab73f86 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -63,14 +63,195 @@ static void kmem_put_memory_types(void)
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
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 
@@ -132,68 +313,25 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
-		rc = __add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags,
-				dev_dax->online_type);
+	dev_set_drvdata(dev, data);
 
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
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		goto err_resources;
 
-	dev_set_drvdata(dev, data);
+	/*
+	 * Hotplug using the configured online type for this device.
+	 */
+	rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
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
@@ -207,7 +345,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -218,48 +356,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
2.54.0


