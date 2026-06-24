Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E400ACDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEFF6B00B2; Wed, 24 Jun 2026 10:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75F16B00B4; Wed, 24 Jun 2026 10:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2666B00B5; Wed, 24 Jun 2026 10:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9496B00B2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F6B9C1B1E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:13 +0000 (UTC)
X-FDA: 84915111666.21.E028E16
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D06D80003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dByCxo/6";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313091;
	b=aZn6k+vJJ+4h8J5PVh+6x+zQdYMOjzxJQf3jQnWD+NhcRWu6pqWf10u+Bakf3jnacA0iYr
	ibv0zI062SOs+9vlOiR25oIPzjKsrNqV34nZF5XktSaOM9CAvYPAyxZEQLaflRs4bl9WXH
	Nd2M8naOeI/DHQktQQudajlA0N2CUXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKpasY2KJpfbg8w//6XxF8BOdkJDqDfdQCZLET/ejMU=;
	b=auQ2NLxRk9bqUe9pS3CZOYYh/kWYZme6JBtbtL/kAqEpb9NjTSra0pmm9cg5Ke2hHmlki1
	RJ0ZosGAiKkRG0OOQ/n/NyYHtH6iB+kogJOzRcff5B3OHzBvxaEPhCCezmBwyCM1Fc3Q0b
	1TFQ4qcMBO9jDXSvRb8EQD2+SLu0upM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dByCxo/6";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-519f9f13b06so9229071cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313090; x=1782917890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKpasY2KJpfbg8w//6XxF8BOdkJDqDfdQCZLET/ejMU=;
        b=dByCxo/6ApV5y9LjfEBQFUBSDXdXMbn25E/YcBRKWvc8m5b6TRq/RUVu2r3Cg6JC/+
         ZEKefwAqRmNiLNwkJ/f3m0aPMMp/JZatoBlIf3021/QVAx2DNvo2yDjdBMh+OB9fzzJZ
         G1TvZhyySbkF4sNZgsRh0+Q7pLm3lI4G2HEnE9P2Ec6iasQ6ZIZz8DJCNsqVq2He8z4o
         Hc6f2s3UpWdFfL9wvAwsJuyegMp1MZ5TkHQSCTJnOB8Clcm55HBdOnLjI1ZIL7VYnGE9
         aHFoLQV0mjsemwgBPwVZsQxjhxtFALznLEUOLB9Qb1gwDbyYkwFaZgO9s423Idt87IW4
         xC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313090; x=1782917890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RKpasY2KJpfbg8w//6XxF8BOdkJDqDfdQCZLET/ejMU=;
        b=HlibG3wBseayg53ldjO3YMdiGLVnQnkQ+y3dpUVhRQjjh//xI8DYzceQamPAq5qZfe
         J+8hInhiGpgQh7Al6gQIzbSZc2nd8HkHze10BDzkcillRXBvuiObcilG1gaIo3UmFh77
         7xSjnylANRhMJSh2BgtN41QdhBDAyKs8hg52123j544KSraClMDqRjTT+xMVzeulvl7c
         hitz27YDW+fcNt3GMPZqvh2HxQlRTNq5MTwVoFyP2XZ6iRpAd1Iqe4AGkcu/8iHfV/NB
         lQBjPT28UDvicJmrem4RwbDk4wRRQ/r35QiQKDEk51+QV5jc1STe3FrUXMvaMb50AXGv
         EkGA==
X-Gm-Message-State: AOJu0YzujmiaVrYTl6lsNfxZWtP7sI2Bv2z4GL0ZIubg7kgtQ/IarVnh
	CWhXuUYORekfw38Lxeyz1x/FMVB+SYBEZL2h7IvBUSu/H9dYRMInPS5j5nKaLa0lGppO6a26Yt5
	Pk3n6
X-Gm-Gg: AfdE7cmHtXxtvxF6K5/bYI74tjfOaeUBuEwgHESJdqP9Xot9JCIWjfTH6vGj/CKcBED
	jYYcuADH35hkhpdo3yNklK0i9/9/p/rsNY7mDm4j3SlzVze+oLyO8mhDaIYXP+s60eDaqDEhyUH
	62gcQtj3wXG57gnH7wWzocBbYEzFX3SjLHy4ShiXS+C5YFF57asweGvU3R1M+Nm/CFgwaXM8SlX
	QZMjtgJi+OsMJ+9BR9RXWF0VVF2J9si3Efz8DsTJ3ZTyg+G9NB78KDfGBwZK6gxQ6R0asB5d4VL
	jy79D1xzWMmN4dn9hKH/x9U6WnddvLMyouFcCjkxja9Y+fypinggNpr5XyMBUIys3IY5GPrcQ2K
	mJot0GDyQ3wsRTKSUocgP5/1LdmG7NumaMFXbAW2vHIH3t0W82V3cY0TjPrQkDfA2kWUBzI5RGH
	AytOfsJBt256rXPOyoOHwZv8noOLmbnj5NOMXT3+N8Y43FWPjW41jAlrASi2uZUbKd7EgYktL3j
	NMsOpaeCwu0
X-Received: by 2002:a05:622a:1355:b0:517:580c:bcd5 with SMTP id d75a77b69052e-51a547035f3mr101298441cf.16.1782313089996;
        Wed, 24 Jun 2026 07:58:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 7/9] dax/kmem: extract hotplug/hotremove helper functions
Date: Wed, 24 Jun 2026 10:57:42 -0400
Message-ID: <20260624145744.3532049-8-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 57wrrshqopfsh79g34iej1kyumcg7k3b
X-Rspamd-Queue-Id: 3D06D80003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782313091-671020
X-HE-Meta: U2FsdGVkX18Wjz4yMl+VlrYDYj2w9KQlIdlEFUKi7SY52dkMltAQ9f1bUhRKyRCkxjAaDaR6cHNv+FApQx5ZZYiXTn5yK0vZgHuwDTzWrL7i7IpBkfVgC+VcyB9RJ7JOd9RsqCfWzjs2i0BJgvFeME7OeNeqGB2ld73UeSruQmmzcpSxA1lPOauYvNVkqWABBScMWUGnuh5egPWDkre00c+rvmVvI9wi19jslD1xRxfgKJtxjLvwxi26IBKkrZ95ozLmCYJTJJMWDIK+jwUy+rBhPZZ7FxAKxpU81Ddsc0hNBDg/TfaTpYazhWibAmmrrNgMcgSm52eGVG3eK8XXBoPLLaHCssDUF47XY3mkhQE1ErE4d3KIVbfOp9TZ0+XtsHm+qB627EfjRm7CUxJB3FLuH1LveDB4DdfmY6WErI2CyGYxlhsR/tddUYh7hqitwn4y5ZYi32YvQrpUur6m2mo1sILR/NbVUKILHl6YgYFTsPmUz2EtIe5m77xj3Ptsn2jzfbES8DaF7QHd3QufUjrvWeMXYjL+z5UGFgdRUjTWgWZuHp+Qif46FLy+6XEo2hTatWandzVZuilwf3O9jZLGdFLzzwSnNJNSndRniMP9TzWqcQI8pIUCmeaKw++ebZCQDdFBfvz9hImhBBp0BaQmVtaAFXBESXrNXzfJ9ErakeBq816fO5axVf+tWgWcOHYosDnxQuMOrV8v7NSH27JJd9VMajEiE19KPzNIXBxPQBJ+QGK5g9VFJF8D9SiJ+AWeczD2+w6XYxYGlJ1C8K7RzQZqLDT/u5aCJYBS0NBZNsXA1c+STA3vLISIpgGgHaP5isPH3zQ161Y5Q9gStUvnSc/FBWZpZjjG8kHYBaF1yG8OD6SUDrVodspOYaDD7YjZrLC9Tc0BPdDTx8/knBc6Q9CE4Y9QSxlT4mMQYyY6UE2lXbANJu9nZw3DbyIBzjVbF344kXMWfLLjJM/
 L3tP+QEz
 klC045R6lTO2DJeP+ZfeOWSaW4mNmqPs6K1UnWua9jlp1uXVuVcawcbnpTfnRctj+CFKJ+IYS7hQGYoVqJUq366LMpIQR1H1j5djRj1HXkgu/C5VC0v36vNfZm9YT0DUruY2ES9bIQdRLemrL02znZH3Vlm7Yt21G41NGKvy5+Lc5cFVjoGiqhSW8ks8xJxieJR0AQDA/NpXSRSKd63QUiKmrbZ+oe8bhqeKHTZV3/YaevMyqNj65lHRTBUcUkXPs4G/PtNNDVaT5qY4Jl+cWbxlCvoJ03bFUOIsg8Xd43To3E/tPH5XOxtAiCA==
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
 drivers/dax/kmem.c | 316 ++++++++++++++++++++++++++++++---------------
 1 file changed, 214 insertions(+), 102 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 0a184c0878dd..a45e50def537 100644
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
 	int online_type;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
@@ -133,73 +314,27 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
@@ -213,7 +348,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -224,48 +359,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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


