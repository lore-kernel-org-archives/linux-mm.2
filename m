Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA9BC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436A96B009D; Sun, 12 Jul 2026 11:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF0D6B009E; Sun, 12 Jul 2026 11:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B096B009F; Sun, 12 Jul 2026 11:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAD76B009D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2988B169E45
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:32 +0000 (UTC)
X-FDA: 84980549304.21.FB84FBC
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5718BA000D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZhG6XbH9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9m4Re3kSEFpR6uNzVdviqzECHvX8FpKIStu+nZnUI9c=;
	b=aIMyilXTeDahPFARppuaxytEGpsmZmmgzdm9fFJj+G9LJqzw/M7MaSLoomWNA4t7dEUwkg
	LVCzVnV5ZiYVRMcplA8Tqox4528f3l6zgsD8ri2TrDz/9l6ovtsRy0RXF8qOG7u1ubXoxF
	orJPGg6EKI3/KTDYeoBNh81LiqECUM8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZhG6XbH9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871130;
	b=i4YXDqp5lcy91AECkLObAPrpQRanUjONJ5OVQwl5U/XrZpqjY0PWzEapHEvgZs7rcsKOnu
	e4HfQrPiDx1kN+A6P0+3pxiXBObql/W+YDEAe/y3RYRcnP42Vo//FTAU8hMvSLIscIpKeE
	XVyvo3ddkP8M3dTZxnhhTM8zzOeHRMs=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e50a650a0so114562885a.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871129; x=1784475929; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9m4Re3kSEFpR6uNzVdviqzECHvX8FpKIStu+nZnUI9c=;
        b=ZhG6XbH96tAiHKf/Xr57jz1kZ+qX+KyjMwJ8/v1v8D76czKG8DXz6HsB9IJk+Sixu4
         5qJM01oIvIQi+KXSFCxR0MAZ+LbLIj/sV5UnAvvdwhldoYzitE+OeF03Q74gzjZdenZS
         domidDSio4xMyXfjo1A/5gRLw+PoEfEGyszRox0tdL5FUqKjBvKJn88fNC6A883vOq+P
         4BmhoJitAevphVUY4XLtalajpI04H6SzZnJv4EJwT+1q6EUx8dpk6B7cersZHAOvP9Ib
         8uoCDiT1p8q9NAOQuF8sLeFzMGgPy5I67xqqsl6ZJePp8oHeOcVm7UHDTVy8V/WYyBvW
         bC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871129; x=1784475929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9m4Re3kSEFpR6uNzVdviqzECHvX8FpKIStu+nZnUI9c=;
        b=oCk61Fe1+6/eIGGahQzxL6IGln5yoQRMiIK65ZQVCNsHp96i5PuHXpvNnOTBizWgQt
         44gzJ59f8C30597yeAiZW5WUubwr3EgoLh2eYbtP2G/VnTfp8vK56lCvjq1ypo3s1ifI
         ETqSsYNXv5QLA41+Q0ZqH+J7S3DW8MZDV/4JLlpMGQJVUY95XAbvXxRuzDc+rnlcwt8v
         8uhwoJOHCafI+P+ePxVbj7yXEt14Ln0POnnOEI7vynSpjBPkI/OdZqeFVONNw7tKVuBC
         HsHVZEiSQ9EL//TLphNG8HK/IBAr5L9r0kqk70QojpiO+hu0augwhrZGrCUiHO7MgqG1
         vnWQ==
X-Gm-Message-State: AOJu0YzIsUYqnPmLXkLhIUY3XjGZDY179XyTNo/fuZ/IMR78AIy2L7G3
	UOOb522Dgpw1YedSY+lwAWmT3UBNAFplbQ2TdZFchGHtPqHtFEDvg0g0QXQnk1UW/lnXAcZ0plU
	TV3Su
X-Gm-Gg: AfdE7cnYoUOywLMdhYB8yVpB1g+eUCVEWD3HWKVk9ucXAibilHKq9mZaPb2+sq+70/F
	3Cx6/vyFsdyRbEtupVnDFjftWB3ne5SJFaSOvM5mLWWYeCT22/Sz6NTqQaoW+pQUItGjFAdVE4f
	anHQKnGkfCLP5YUTod4SND/T9ZscGNkox32Uwhgj+l9Mh9C48G24RYirR3v5WiBttQqY3vMEo9o
	RExVHr3iPRJIP7BPEQCRmMb4wBCUlm4fQ2L2efO3Mv4muzQWxPgqvpaWsPmOQalqLvGd842ek6f
	iVaE3CZoaiWtZ/GdLe5ZPpOIxK8VXICIoyanHQQ/Sd8KShvsYS5yOln0PbOukxoa/GwzH1FYxG7
	KQWg9jxoUM4PSnHTsk4KKwozoGbB5aGj/c1aKET73Qgdcmm7w9gV3Uy5s/SLOqkB2/qte9xtDlp
	h7oY/usOlrycl2lPxbojf0E/whxTjDAl8dqGKogD5NZeNzFGYUycaKObjmU5HvAPqYSyijg0CkV
	g==
X-Received: by 2002:a05:620a:2552:b0:92e:8405:7ad2 with SMTP id af79cd13be357-92ef2be2c70mr599484085a.41.1783871129312;
        Sun, 12 Jul 2026 08:45:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:28 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
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
	gourry@gourry.net
Subject: [PATCH v7 08/10] dax/kmem: extract hotplug/hotremove helper functions
Date: Sun, 12 Jul 2026 11:45:02 -0400
Message-ID: <20260712154505.3564379-9-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4npn3dd4pfci4kaksihwm8hyuk4z9k1h
X-Rspamd-Queue-Id: 5718BA000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783871130-960326
X-HE-Meta: U2FsdGVkX18Bo0fJETz38m4housXsgw2tt08uaVHMDUEQBgjpMi9OCXMvOFJ5YDvYtb2+YW+eBQzOx7QEpK0QJ4yWsr9crrLfUZu0ppfnunI4uIwEvdfiCwbXdg26Slm8vIngrEIg49z+pxzXR1z5hPPaOuM6Jd3g+2LWkMOZuVXwGaEhFDDjrk0sZ9OQf8JG4619eXo2OU17RjXC4sxCj0AqnPw5f8ISQyDq+nRh1Z6boSUTGlMw6YPxTyCOTU+JQjKNIcjLxmExCX+NKcxdV4EUd1Ukg1TwKMgmMAhiCNpKbcgFG6RnrCVU6tPjMeOUMyB1h4IN4wMMSY8Wo7lER7294I36j26L40yFbYpR+tBfmT4pQ73/0RkYA0IhJryVeWoPs5H6BNGrZxFnFeRZJAmZJzAOwOjkQvjl7QdOXTBDylnWqDZbzuBhclU8s16h6WBl6FZfKxi9CY76xDgHZ9bJaDO9nSdFHXsd3DtOpAE9aXgrz6iMEnxPZTiDJGz6x4Ipfs1ve03H8SradD0StKyw5UBHod4yGYCw/CPBiUwT98E14wTSIzCnvNZ7ViR3VIXneRa+yuVWUimYAHzgkzt+8qwfpPRrbgC7GU9PR5b2nyNdOidll5YZjl6BWmW0V3b1Yq8Es/aMim1P0mTo/tb/MOjDp/S9MVZ/Ef0UIa33txmodmzpiHtg7wbRzLL5gI07tyqEXKGXUxY8LFD6YnzHrsdAxHqdK6GROVQyg9g7l/WRQtSpJSXrSqlJVN0MQ54dtr6850/iKkH4xtBeYdV7X8+LxC7NncutvuKvpt4kQ8CRMKogMn9XVSY/uIMYgT8aCUM5JJyVQVqr8quuVuTpU8xVD074db/8ahojT3fF0tJjplNYx8Z26GOb4ZDPr0o5KzG+VBGp/9LGFBrSdHmQn2M0lEqHtFFRMh4nzygMPGACVxtDs3LeB8a3ZjHPbMDhr/TQdOhtEE6tx9
 K9RMwVDd
 ymVphABtkKTgQBiOj6g4/dbT6V17NGodFmVqI7E6t+lGA5w0j4pquJFXoJl9l+2Ne4ywRjLF4JLd6/hllXsKYsZX0QPksZvjYKP5zG/rPUmTmW1P9KtSJWbhvvAcazgvELgtv2zXYHuuBmm4ki2/Smxlc5eR1FjfRe15V+ZLESMiNF3jNGjvfcOdvyk3hgm1iQRySnQIkSVpRDDenXG5T4fQBjz+tcicsYPIrQCrl4C7OSoNiAqyyrV/PAIWKuZNfdYL7+MrcWsUmg9AfaYWShs3qidU0n8TR1t99u0BMHaN1aQ9yHxt8KWV38RxxMHhGTbs94Z2jX5hoPKs=
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 323 +++++++++++++++++++++++++++++++--------------
 1 file changed, 223 insertions(+), 100 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 38ed5c4e9c83d..6174f7d3d05bd 100644
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
+		 * unknown to us that will break add_memory() later.
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
 	int online_type = mhp_get_default_online_type();
@@ -133,68 +325,22 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
-				online_type);
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
@@ -208,7 +354,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -219,48 +365,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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


