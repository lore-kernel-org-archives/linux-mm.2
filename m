Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23E2D31A25
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959A76B0095; Wed, 14 Jan 2026 03:52:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5456B0096; Wed, 14 Jan 2026 03:52:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725916B0098; Wed, 14 Jan 2026 03:52:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62D096B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 272FA13AF85
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:47 +0000 (UTC)
X-FDA: 84329953974.25.43B3852
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 829B1C000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="cHr+/AwY";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkgGAvtlp4w6GbvGEuWsv0IzEAPVl0Fov3QmaIKpKpw=;
	b=i5CqlHWHlPOPQLnTsCDD7lvJNRxdC/mLXUikTcInTHvW25nM9TYOhBIg98YpIzNy1UnxSq
	O7X3iNI3jeHGHl5z/Erur8V5eUxMXM34UTaSG3MJ2FGGpy7VzVbzdbE/RasyyE8tzJch2q
	Rih2cGKxWHO+sYHIH8XThirLXY7rJDc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="cHr+/AwY";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380765; a=rsa-sha256;
	cv=none;
	b=vZ98IQ1IcwnASbTwqvOdNIdEWbjL3Q3DRO1a9PAskqvvksL1jGLfQ7+oZC6xLSoryYqpKR
	rjYoliGqlU6Rd1c8kUVaHxhjXjYYaypfXkfCXr4CQqMkgz1HMvN8fsmZ8T1oB9pmY9GHYq
	jMMFRj5SIzceo41gocn6EhRQLMMFCyQ=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4f822b2df7aso114292621cf.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380764; x=1768985564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkgGAvtlp4w6GbvGEuWsv0IzEAPVl0Fov3QmaIKpKpw=;
        b=cHr+/AwYhBlPGx1jtuWgyRNaCif+ZoUL+C2T3A9vwFoRmFBQSpJxQLaebEB5i1DNY5
         9DxUqudSrqGmVALJpyDc7c6au5CKdDcYhMlEa948MsRtmxDOBLZRePvbD30VwdNMJvre
         20NCLwkjqDX3DKqbqhiA33IbYPEXi0yTvalerVDmnFxylKL87brWk5sewnCJ9czogIML
         9C6UfoQu+2AR47iaUeQ/ssbsYZZBArymGzBGxPK0kmi14/GxSZ2Td4Xr2gOJIex4RnR/
         4Xzm8pCizSsN3vdNGlyhSR8mNySTr2gx+unsaGCqtB6XX7G0CH/RyQ56v5901CHA0Jqb
         0Tmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380764; x=1768985564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AkgGAvtlp4w6GbvGEuWsv0IzEAPVl0Fov3QmaIKpKpw=;
        b=U9ytyhZnrVeHOA++AFjmM5LolVdZ7YBlz6EeBZsN73Fh9j191MbUX797gMtyKXqVRi
         zoqWqZnkIqamPKpBDaQWz75TNWfotiEicUXTih8alB7LCHRV8ZaxKH2kyaPDumVs+MLj
         LZEhEqIJm3yWFBhBmhSYHlmHJZHFM2CB0jYlDoXXXZ6tCAB/SyFIYjIxYxtapzGERMA9
         MTKAIJ4yJV8hV+gjEWrqwfeSs4agxFzVbudkjUwganVCfzZL2+EMdxpP0U6vbP5oVE5q
         7co5Hoa8C9NpTnYVB8sBVAIM/ThCWYEGYTsCZc2S2B14BxSfRKsICKTfB8uSHGbpCbGK
         eLPQ==
X-Gm-Message-State: AOJu0Ywn/i8QzHhWDKk0YLNtmWxm81ksqI58VMwQwxvwJGBl4zXTrtrL
	YdW7zX+uwV3Y4kBr6ym4q3AQ7upmvrw9G50uY1kAznIP3Bt/zOdeJBZsAWbJPb+GEDjtvxYRyv9
	vBuawU1A=
X-Gm-Gg: AY/fxX7HfF7aaQ+quDTVZqBeJGuzrubck5uhQPA1/MTA8FHN4t2PjRnPo9FMq6i9CI0
	BcrTNaV0KdW9H1Q9lbZOqwpeoXVcHpy2Z3NoZ5URPEtlD0os2nXfm6Gq/Fn/6DOp4JhX8iYNVSm
	I3RFX9+IOmSZRgwVCZp8QVNN7QiCLZy8/3V5NWcnenuj0SIpDA4//4hzwQMOfYBYVl47eYufXOc
	GJT9cB0Hsc4ntCzGCUQO3zlwaKYnqOGcyqRHPqyfHzrS35quwaLd+7i7vwCMwyMEoJJkLVRVmTo
	gN/iQi1a7dO2C1igR7I0oo6l6jEFYjYTzgQEtgSh6o5yrfLU7dfE4kAw9c449lQTrNgVSK1CO53
	bnilndUMO9+NaHtcnD8Adkoxe58MRYzmZW2ORpeMY94uVEey0BStufa407II7Bv47MmWXaIL7xO
	IEFm4JiEcAE7CL23M4q16kC8y5HL8ArZ9bRpAW2eOddg3g0FhTQVhPcmvs1MprybtZLWa36p1TW
	YY=
X-Received: by 2002:ac8:7dc1:0:b0:4ee:ccd:7215 with SMTP id d75a77b69052e-501481206a5mr26400211cf.0.1768380764400;
        Wed, 14 Jan 2026 00:52:44 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:44 -0800 (PST)
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
Subject: [PATCH 6/8] dax/kmem: add online/offline helper functions
Date: Wed, 14 Jan 2026 03:51:58 -0500
Message-ID: <20260114085201.3222597-7-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 829B1C000A
X-Stat-Signature: 9htuq4iw4p5gbundaht37we3mahpoeu8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768380765-743384
X-HE-Meta: U2FsdGVkX188XtLmOlRz92/74kdNHAGH9IBEphrQMnSLJ+G5v4bw2VcjLizUG4xmbAA+lswGWDG3pzDM6v8+LM5OPggQyebichab55ZjeLAUIzhoMeZ9DL9C9pIA0zlVOrah4yeDmMsOhGzCGsqJCfryfB6cVwj5cSDeUaZYogo24cOoGFK2ySur3esKAk4Q32n43aMl0MO+WzDTL11FeaAb7SwRJb5N6DLq5o2ysN9FKWx1OishMYCDVOMgUIIu1MtImhHPY1FaD4r7ZTEM9eiYuV/QUEkVMArW885IrnihvSl73yb1JBDDW3k05Uv5VZVdlvRNWN2vTLR3S7i6+Yf076e6x+Sw5cFnFj2LZsGLSm3byDJIivPvrKoiWtMclcuaCmBBPhZ7E3ksYNrsNEuxNI5W8fuq5ae6b7X73SShkzzZ+vp0EYfrq3OuHypWpEXQbZB/QN1MfB0RlMjzG99Jozvm07KauZlpdAXXrOb7TSD+ocfZamkFOUmfK4zY4hPmFZ9Ombx0IbEhVk4UfgULqkPJrjRuS1rDfaBv9AT5wRRMNXeIhOqe0xdmcl64ew0xgNyf4qy9J2UMVihIqI/e31rPgZZIbf5lFcp7MgKqmCx9ZuACzG1hXoKVvBGYCV+hnSIvzEmzXtCP5qLk3Fmyh6ggnyq+6ZiKhRiIpkPnSBpLfCrmhdbRQkJpXZjBzW38n2731cOtZC26Ccazl4fNWdx94zyjry8Ft5ltQpgTSY4WwUtuN2TdihPYBdbx3hjrcd1cbyeG41oJFQATBULXApwAgJgD/yuldjiQLHZ/b9/6B4Ya9FoPS/S0NLkM26qq6dSbtPWrHOpTtejNJ+GvYjor46rWA5D1GiysR2ZFLP/yRkvtiQ4Hmj0DCRxb88kjDb3EBzjC2H3GDyXSpmRNpXvgmFTPBsTm/yDjDqv7WVQ/CBTTtNic3R7aikTbmBx6MOvv/j+pAmymttv
 w/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helper functions for onlining and offlining memory ranges:

  - dax_kmem_do_online(): online memory with specified type (MMOP_ONLINE
    or MMOP_ONLINE_MOVABLE) using online_memory_range()
  - dax_kmem_do_offline(): offline memory using offline_memory()

These helpers use the memory hotplug APIs from the memory_hotplug
refactoring and will be used by the upcoming sysfs interface to allow
userspace control over memory state transitions.

No functional change as these helpers are not called yet.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 103 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5225f2bf0b2a..30429f2d5a67 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -190,6 +190,109 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+/**
+ * dax_kmem_do_online - online memory blocks for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+ *
+ * Onlines all ranges in the dev_dax region with the specified online type.
+ * On partial failure, previously onlined ranges are rolled back to offline.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int dax_kmem_do_online(struct dev_dax *dev_dax,
+			      struct dax_kmem_data *data, int online_type)
+{
+	int i, j, rc;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		rc = online_memory_range(range.start, range_len(&range),
+					 online_type);
+		if (rc)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	/* Rollback previously onlined ranges */
+	for (j = 0; j < i; j++) {
+		struct range range;
+
+		if (dax_kmem_range(dev_dax, j, &range))
+			continue;
+
+		if (!data->res[j])
+			continue;
+
+		/* Best effort rollback - ignore failures */
+		offline_memory(range.start, range_len(&range));
+	}
+	return rc;
+}
+
+/**
+ * dax_kmem_do_offline - offline memory blocks for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Offlines all ranges in the dev_dax region.
+ * On partial failure, previously offlined ranges are rolled back to online.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int dax_kmem_do_offline(struct dev_dax *dev_dax,
+			       struct dax_kmem_data *data)
+{
+	int i, j, rc;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		rc = offline_memory(range.start, range_len(&range));
+		if (rc)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	/*
+	 * Rollback previously offlined ranges. Use MMOP_ONLINE as a safe
+	 * default - the original online type is not tracked per-range.
+	 */
+	for (j = 0; j < i; j++) {
+		struct range range;
+
+		if (dax_kmem_range(dev_dax, j, &range))
+			continue;
+
+		if (!data->res[j])
+			continue;
+
+		/* Best effort rollback - ignore failures */
+		online_memory_range(range.start, range_len(&range), MMOP_ONLINE);
+	}
+	return rc;
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-- 
2.52.0


