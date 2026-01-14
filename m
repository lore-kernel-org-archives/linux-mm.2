Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE348D3CC8B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0056B008C; Wed, 14 Jan 2026 18:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D256B0092; Wed, 14 Jan 2026 18:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E926B0093; Wed, 14 Jan 2026 18:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965236B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66FA155EFD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:07 +0000 (UTC)
X-FDA: 84332217774.16.E9EA072
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9172080006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Oz9xyJXP;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7S5DUi0SDbWdByNH4HXVuUJVUsm+o81Wii/GbIa5ZU=;
	b=dWWleU69Pl7YgI0iRwlUBoXsGeJksuAKbh5SvR2jmLRNUpvDSUQswRWbMf/FFLKVAniope
	wMXT6a8q3GvbkvwymkT2x+BSc/NOtx2gZzHTSD38oLnSuhojifVdNAee4WsO4Y67rxdoQl
	yhH5mtS2LgtzusNpX91/Q8rvcz6ukhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768434665; a=rsa-sha256;
	cv=none;
	b=ki1ua4yt7wDZDDA/vhniYHOooGR/TexG9efXEK5cQg1BPIt6J2YYQp55a8IzqW7xDwiRAH
	E+HB5oQwkTXfT5NO+8MzEslA3mrQnfc4Ub+VzIn4JL/F2NH8maIgt5fCysvDuyzNSDwplL
	TE7GkDem3Kijh6q9mvX7DAngVkk14Hk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Oz9xyJXP;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8888a16d243so3203546d6.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434664; x=1769039464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7S5DUi0SDbWdByNH4HXVuUJVUsm+o81Wii/GbIa5ZU=;
        b=Oz9xyJXPGjxbVH0Xl5j/3Lr+ESq0YY5EPXLJ23EH91UOu5C+EXmOwh/+/JKB8bDBcN
         0r3SS44GVqGi9GOS2Giy4Y0SZ5sA1pFrLq2Bl8PZioyN2xOWoOpoAjYerlNBFegw74FC
         Y7EVfa9XsuZsnhelacMVLJ4jx4pgoReB89fpPCh+V+bO3p3/oIkexylOx7TOo4uJHTZL
         KqPHgIe5aAgS05/R5SPVEoKw95TyeevVsaOLoQi3PTze3gZzWSOfinKOFxvQ30U9Sdki
         G6IX4l0Gh/7Vj/Yay7Ru6OZcao8yjqZ8gbYW/STbpZq+6XuMWgJL57RdMiBWopgTAPSn
         G5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434664; x=1769039464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H7S5DUi0SDbWdByNH4HXVuUJVUsm+o81Wii/GbIa5ZU=;
        b=hF6XJumdgNfxs5hc/VioLohdJoRww8peUyjzgn1cJnX4K27lYO0t4V7vCNZnlY1ebO
         tKVzAzSWUrn6Tq8UcNM0nBXQ7deFYAP1FawjxtpUUKR2FRHKK/f5lZCRg7v20/MjJm5e
         QX5LOgETqegdxz4j8DVXtKtxaww3qq5DmcDE9mbqhgZQtdFIBAZhcKU3HMdIDJKpa1pw
         hpcu9BP7px7/MWf/d0nJY5yLA2uSywbbx/qvDETWzNfB8LiJTy/T3ZXBnJ2587irJSUr
         aeA92W3roQTE0cqQzYH1KXBZlBUTlhO3aSTd4LSmDlsfKbP9P8Wnd7F0ds9Bu9H6jH7A
         uyAA==
X-Gm-Message-State: AOJu0Yx1VIGPuB9sgfRD8JDepgYrsxl7MvaEqYOxEpe7Pwz0YbQD8bdE
	ho47j2EI/MkjVealYu5QBfftH2/XcIwkRxO7WBeloAY9B6bLB0h9HNqpuNbAxGzX9ETYKS1SgTO
	HcCAVOe0=
X-Gm-Gg: AY/fxX7XtRmL6PzVuhTUfGC0TqpX0m++9PqTQMD6sIuEWFFsxTroK2k/NxlTtgiwWf0
	M3OhCERRHH13mBAb16tzQzFbOJv0B/sXBJwTFXYSH5/gLi6JqnDeZMgzO7up0e8dqgiqczUSY1+
	FD5wrOT7EYkaMpcOIVdBvgIp4+v9HIldGoqRBKLawpjyg76d5A2i/jimzMfZ0no94ZyDkZErTEF
	42sRtmz6viUFxfNPuiGjVryt1wWqxi1lEroq77x4l6mCexLRFSOMwBSIug66L7dQfmMLHcALjaF
	6eWnliac/Rgz0fM+r8+CTU2jJSv/k9UOELe9wG7YccystWYH48+aHCeCDt2Dh6OBJyvD18OWmMy
	AJus5Pmf3ymOegSnqdQF+g/zRCHHTgevTPiQC1w8jPU8RHAR8XArbKb1RMtYP9Lxmlsf6CSFiOc
	9XqWyIaPt07IH8vvlyBQ14hGQvhbNwKgiPLcRn1JRY8npZoIE2f8Skc9l6N12BkSXruo2bc3SnU
	YE=
X-Received: by 2002:a05:6214:cc8:b0:88a:2fd1:b582 with SMTP id 6a1803df08f44-89275c28a5fmr45974356d6.47.1768434664338;
        Wed, 14 Jan 2026 15:51:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:03 -0800 (PST)
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
Subject: [PATCH v2 3/5] dax/kmem: extract hotplug/hotremove helper functions
Date: Wed, 14 Jan 2026 18:50:19 -0500
Message-ID: <20260114235022.3437787-4-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9172080006
X-Rspam-User: 
X-Stat-Signature: ugy17biy48itqr3om5s8tjsasf8yshza
X-HE-Tag: 1768434665-785362
X-HE-Meta: U2FsdGVkX1/AZs8RHyxrbZI6NjyylkoDxTMSBpqJq0h+vJTzydceLb+Cv3rNL9x2XQ/XETVzW/AJkju9SL7IOnysgK+zZdJu+P9yqz7qHi51k+TapHXmst5Qd+tn3t1WxCdcITEBvYSLA3IZPifYU01ay+5C8gfoHEWqajv/rAdbdsGEdllJH2Kzc8VOreZxfifKrXFu3b0//1XEqppVdumxey0PUY+wExLJ9FZ0tJv4tJ7qUTxF4512ihdj7Bh++oKXvjTzX0CN+w7EobYrI9oMszdFhBBsYxLu/nU8owZBJXupAbNknBloRs6EOXtAdmkcvcQHYo3UYUjHKuHeyoRLiPYToF8BxiI4x6a+v+lWMQ7NhGWeKvyzzm8V1IsyzYgQIt2z+0XK3W0Cy0qWxWgXwY5+K7GPmHVRIbeCu/KHzCVx+lxz5m8FrugZVvXr5KS1sfITuxtRH8cZSP3G0lheFhu5DX4uyLvCsqTsTtYevgQGeDWaTLQ1heV3Qb15OQG+NN1u82LYSBaKQXXYi/pTIH8d81WgABW0HQLGr+fNt0ral7zwKH9wZPoi7gnDS98yzKb8QFgVpbSxsBDc+U5Am6VDBsmyp/HxFTgc9j19s3d98vqYPFOrLf+mxOg3VQwoAk+BkAOZ1r0C5am0gLeYIZcFWlZEVU8+qYFnl8dApkiIcsur2gD0QZAyTXwbx5SF8TdrtysJfhSDrYVhHa3NjZj/eI+iaDlZI3kGUQwAV5T7ssNUvit0hLmX+wW7a8nF5CHZNRHV73i7hPZw5enBvj9X/lTE4KN3027haVdYxrwTjouBAdyCkOotv9CUZJfW3JzeDMvKzQwYVPlm5f22D5SfhaCEK1+ex3CjJfn6ianbkqQVpk8biaZKQ4DsHu+3CC2VKjVCZaR8sRsikQPlun5QUcp67bRzqKQAykkxu/kwA5KDjU2DmOz4YG3L2lfitGmBTE0QeWQMde3
 0oh6Wy2V
 63yKI+lhqIov54v7M9MwKkVE7StODOodrEdCCP1MtpW10wnZYCA2xpuqB30yV3a6kx9tnrvomQBx2rzrKdwsUQrF8DqL/1GXYUhjhDO1AIUJK+vBeW4uuIGku/hSeGuoq/R2NcYL+Bz3WrCw2QqQObXerphllJqKGvHh4cLhof9dqa/h3EoMzPm4foXOyV4Lf5EW9T2dhLg53Ow8Gx7dPFkCfVKbeQwmNepN22Jw3Lp6KT61Sa2Mz2Kxu5JYOzXS2jdlm3/dud1arZGjkCbqzPKx5NGx/kXgTDzDjOf/zk9B9FjWbivd6XtRGhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/dax/kmem.c | 300 +++++++++++++++++++++++++++++++--------------
 1 file changed, 206 insertions(+), 94 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index bb13d9ced2e9..3929cb8576de 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -65,14 +65,185 @@ static void kmem_put_memory_types(void)
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
+		rc = add_memory_driver_managed(data->mgid, range.start,
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
+	return -ENOSUPP;
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
 
@@ -134,68 +305,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
-				mhp_get_default_online_type());
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
+	 * Hotplug using the system default policy - this preserves backwards
+	 * for existing users who rely on the default auto-online behavior.
+	 */
+	rc = dax_kmem_do_hotplug(dev_dax, data, mhp_get_default_online_type());
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
@@ -209,7 +338,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -220,42 +349,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
2.52.0


