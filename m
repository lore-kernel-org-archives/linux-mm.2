Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C95D73E89
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A166B0098; Thu, 29 Jan 2026 16:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A196B0096; Thu, 29 Jan 2026 16:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6F16B0098; Thu, 29 Jan 2026 16:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF11C6B0095
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A21A8C1360
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:04 +0000 (UTC)
X-FDA: 84386231328.14.A97BD4E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id BCE4040015
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fx+KsZHD;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrqa+fxuwjNl7Vx5HUEIUV4yNFrGE6eFCuap5wTqfpc=;
	b=PGMdipfXS/gpNYygOw7Qr+W9ZllRnWzGAC4wvA4yNbNQLrFvVRI9jDoytB63M/jdBtcFKZ
	7ST/JmbJhV+06qZEGlz/PvxhfCmK0NPuZZkw+NvpZxm8LL/JmhSyMtcSsZlWdAw9QJapmJ
	O85kRGndBowQ3NVb+Clw5ddDZDJ3AGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fx+KsZHD;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720702; a=rsa-sha256;
	cv=none;
	b=PIPoZzJwMYNllCYzD4OBDCG93pQ7qSL+0mNMHUPLUZcBHpOm2istJxdGLeJofAVvg5gf7q
	xutRa2qX6yCENqiF1VDDO72q+P5n/jm35db+cVGw/o0oJOBHMLUMEfVitr7cBL2kSE31nz
	IfqXYDBTIk37E0VvgpE7ls1EySRnMq0=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c70c6b2bcaso152819485a.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720702; x=1770325502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrqa+fxuwjNl7Vx5HUEIUV4yNFrGE6eFCuap5wTqfpc=;
        b=Fx+KsZHDaP2hCU454GP9GQ57+oZeC/XJzCk/2vraEdzlZXnaeyW9V61t//iZ5Y1FGQ
         Xn1YyaMXKfyd6U9VBU6KIijavobC/gfBJv5biNsVS+q+yCL+YGnwwymW/yxCqQBl0BIb
         M0U1hs60d9ou1pp7RLe70QYWExtb9/1myq5iwf18JnSb7iA4wa9t3W1cJmEgKnVQYKzK
         KhuzAZM+1RRdumDUNFY/DlKPCbsCRKDMVE8x7XgpVmLj7fuJNXe74P0DX0jgbnlsqEcW
         /rHarJvObo5Nae1kkA5Qs8pEaJhnFZKKBdDfOruuUaXadouxs9AHxllKg5EfxHF+mgMw
         MFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720702; x=1770325502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrqa+fxuwjNl7Vx5HUEIUV4yNFrGE6eFCuap5wTqfpc=;
        b=ja2hizbOKRQM4rAG0qwkoF8+/H/gllKN5RKJv/6CBMwxZ+ncWQtFJStw+5YGW1OR2r
         LzsKKIpc/NgI3DVGfYaZ7mmMg2Hv7qcgozosmEJAp5wRfEHp+2Pdvg+mXiWOUKqvcnsN
         IclfBTVR7JPHdrw4q+A204G1IwjgztDJliCC/ruJgquOPF7b5r7rN849fNwCt41LfHbE
         Hr3ZnpdTRBjt970TVJHufERYd+ZtaGbzcZo24B7xvclur9GWEmx5KAKrkVEVrZ6JuLuY
         4azYE4e9gSNKz8IMkLQQuspxgxjiY0KoKlI/k4alzf2zdzvqQpDqgTj1tp9+l3VkHKPY
         9ijA==
X-Gm-Message-State: AOJu0YyOEci9/uLgA9eWJj3lJfCYM2ljszVUb0wQYvPO2sx7/4UhULJR
	Uw2rNayWz7kPdtonhELYu72WsHxo9RICySwPP+ol2vh0g5lnicysRot3f+dNctcz3PPd9TnHEJ8
	tZ6UIB88=
X-Gm-Gg: AZuq6aJQOREBDgDbEFM7XUXU6qB3yuweKyL2pEZJS/Ge5xII/ckFnzYi24/WjZXqLiG
	89F+3A7/ABcJjOq55Ahyt06zrY6Uv/rE4HrLiGf35CYJk+iegZvcjCy0cyIOfOaOBXo7sTWnMAZ
	AwaoWcy7DsHJPsDjS9ojSmGU5J/8hBOouuXtnXkmjf0/eEYT9k6AB398huGFfIdTNp445oeenT+
	CRD0tDfP44n3+tQ9/ctB7fSzDcvn/TiEWQuZhgDCME+aeJ5HqbrWj1iD43Sq4FU1VOpl96ceJEs
	74aJyd2aB9MFWR4SsDjHBxVkbXP3rGtUmWXoKxtKeVNMRhDerq5fTlU1Y89lJ5L3z6JoooA2epT
	RzyQfxTj0ehiq69oBHj/tG1wvFjSSf3KSLXXsLKtWTFxCxvOz6vh5NpyuoEZTPiu7W2UbR3nUOk
	lxSzTz8McH021QcFmdJE7/KbGJp1VaB9lZYxLd+qy+nl/is06DSJLPnU8VMHNPirkWCkUEbJ+Ya
	5A=
X-Received: by 2002:a05:620a:4591:b0:8c7:1af9:b868 with SMTP id af79cd13be357-8c9eb28d35cmr167526085a.36.1769720701558;
        Thu, 29 Jan 2026 13:05:01 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:01 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 6/9] cxl/core/region: move dax region device logic into dax_region.c
Date: Thu, 29 Jan 2026 16:04:39 -0500
Message-ID: <20260129210442.3951412-7-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ph5838esg5ac9b6th4mkra3zostqegg4
X-Rspamd-Queue-Id: BCE4040015
X-Rspam-User: 
X-HE-Tag: 1769720702-931794
X-HE-Meta: U2FsdGVkX19UrwQZGTEbcEaf0OiJlilefX73H7lwKHgYKBdd9RVfykVsr2y0hU1NuOTqFy+mY7Lb+B8LeObyzB8BCsUnbvMYyvYZAiQ9dcOuOIfGXKBhtZcPKVmg2d5TV74na8qwe/EmyfiLpX63s7D425aiTIs+bK1iAFLbfswy/Z0j3+3Kh+m19trUuo+vZwgAx0FClZs0y/BubNNG6w6DO5cDM4Ab3sBVddVlYe5Uj/faN2/FCad2pJLlUs3fkaSUZTOnpJWSSIvJbZBtP4KjTeqtYHK42A4BmhkamOSInRsBzMq48ckMdEdGWOPq3wuCTtWQ9RU3vSG7nV2uyAT5uTeRJGQqu66u3fENNZ/2U70VTwwzzY/NMNrwqsrB2IOzKtR1g/p+EL0wHpEoyHwrsJT6Wd/L8g9Q0/rFGToc7f0MnTvSWfuNLDT11GpXL8mN2bxOqZrfp4b7X5vFMzjLX9m1P4os9PSO2rvCAcduouWTGMaWEXplLuzOgeWiIQlDgjmcMa9ep+Za/Hn82olB/mKww+DwxARWyu/Mm4CaArxqKhE+FE8JxCZE6bZLk5uSehJFf9ANOsmf6K/HNVDTc8jXCIc72VjXsRIxr4AZDE/dmtnxI8lFbFdFYUff7WL/7V+Lspuoa9Bu3DFyNWklAsl5KW3rtBZF7w4qyEba519HsJdDqN7CnXIg2QcnmPbFMdKxKUc31S0LTy5ZwK6yq2Hr10nslSPii3dbFZ/U6MEUns7eVfYpuCpAAPKNt+LJtr2S0SqCC70PYdjS9mj/t1UxbPnh1qrnXQZVyjr6lDZN0HAp7DS20S/AawOJDuqsLTltSKaUKKBLrt1B3JYJczzx/AbyJbdf78ukqh9cw1JEerpY8Fr6ZLPypaQCUr2wKoevgRuAgiZ5bYgjbZGx/awwL025lFLPrdxPgqGJWn77SslZG85LddQ+BH/pXKmK5jHAClmk4+SqH3H
 l3xw8B9m
 GOrlw1sbjQhglfV6GXGy9Yb0UogpzmTNNp9NtC/c9sC1QgCNatxbgTSnS2bypIJi7Lo2DdMUCekLGFx3iZSaa9cVHG52zOdydnF5gM0Rp2zZ3vzGcesqJ1VEHwXbUOsghhUuXQYJs77B7KoBSc8iiwN3zsZJLhhOqM7+mVw+OSTpTF1KNns392MixNfzfAVu9JYD72mKcywuuklXNZSEBez0lTeFWmuWsWRHIFjd4V1XIV0OzoBo4G8IrBcvWvWdq3hSS9+orwAapzq35sTCI7YTKMz0UouFlPRws+eBnX8zUIXc+DgB0MNVvmidkz2sY21doLzbdikXFWprnL4EnRU7V/wu3An3as+UMtk9m97uh9zos2b1hUES28Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the CXL DAX region device infrastructure from region.c into a
new dax_region.c file.

No functional changes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/Makefile     |   1 +
 drivers/cxl/core/core.h       |   1 +
 drivers/cxl/core/dax_region.c | 113 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c     | 102 ------------------------------
 4 files changed, 115 insertions(+), 102 deletions(-)
 create mode 100644 drivers/cxl/core/dax_region.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 23269c81fd44..36f284d7c500 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -17,6 +17,7 @@ cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += dax_region.o
 cxl_core-$(CONFIG_CXL_REGION) += pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 26991de12d76..217dd708a2a6 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -43,6 +43,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
+int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 #else
diff --git a/drivers/cxl/core/dax_region.c b/drivers/cxl/core/dax_region.c
new file mode 100644
index 000000000000..0602db5f7248
--- /dev/null
+++ b/drivers/cxl/core/dax_region.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright(c) 2022 Intel Corporation. All rights reserved.
+ * Copyright(c) 2026 Meta Technologies Inc. All rights reserved.
+ */
+#include <linux/memory_hotplug.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+static void cxl_dax_region_release(struct device *dev)
+{
+	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
+
+	kfree(cxlr_dax);
+}
+
+static const struct attribute_group *cxl_dax_region_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	NULL,
+};
+
+const struct device_type cxl_dax_region_type = {
+	.name = "cxl_dax_region",
+	.release = cxl_dax_region_release,
+	.groups = cxl_dax_region_attribute_groups,
+};
+
+static bool is_cxl_dax_region(struct device *dev)
+{
+	return dev->type == &cxl_dax_region_type;
+}
+
+struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_dax_region(dev),
+			  "not a cxl_dax_region device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_dax_region, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_dax_region, "CXL");
+
+static struct lock_class_key cxl_dax_region_key;
+
+static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_dax_region *cxlr_dax;
+	struct device *dev;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return ERR_PTR(-ENXIO);
+
+	cxlr_dax = kzalloc(sizeof(*cxlr_dax), GFP_KERNEL);
+	if (!cxlr_dax)
+		return ERR_PTR(-ENOMEM);
+
+	cxlr_dax->hpa_range.start = p->res->start;
+	cxlr_dax->hpa_range.end = p->res->end;
+
+	dev = &cxlr_dax->dev;
+	cxlr_dax->cxlr = cxlr;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_dax_region_type;
+
+	return cxlr_dax;
+}
+
+static void cxlr_dax_unregister(void *_cxlr_dax)
+{
+	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
+
+	device_unregister(&cxlr_dax->dev);
+}
+
+int devm_cxl_add_dax_region(struct cxl_region *cxlr,
+			    enum dax_driver_type dax_driver)
+{
+	struct cxl_dax_region *cxlr_dax;
+	struct device *dev;
+	int rc;
+
+	cxlr_dax = cxl_dax_region_alloc(cxlr);
+	if (IS_ERR(cxlr_dax))
+		return PTR_ERR(cxlr_dax);
+
+	cxlr_dax->online_type = mhp_get_default_online_type();
+	cxlr_dax->dax_driver = dax_driver;
+	dev = &cxlr_dax->dev;
+	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
+		dev_name(dev));
+
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
+					cxlr_dax);
+err:
+	put_device(dev);
+	return rc;
+}
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index fc56f8f03805..61ec939c1462 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3196,108 +3196,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
 	return -ENXIO;
 }
 
-static void cxl_dax_region_release(struct device *dev)
-{
-	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
-
-	kfree(cxlr_dax);
-}
-
-static const struct attribute_group *cxl_dax_region_attribute_groups[] = {
-	&cxl_base_attribute_group,
-	NULL,
-};
-
-const struct device_type cxl_dax_region_type = {
-	.name = "cxl_dax_region",
-	.release = cxl_dax_region_release,
-	.groups = cxl_dax_region_attribute_groups,
-};
-
-static bool is_cxl_dax_region(struct device *dev)
-{
-	return dev->type == &cxl_dax_region_type;
-}
-
-struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
-{
-	if (dev_WARN_ONCE(dev, !is_cxl_dax_region(dev),
-			  "not a cxl_dax_region device\n"))
-		return NULL;
-	return container_of(dev, struct cxl_dax_region, dev);
-}
-EXPORT_SYMBOL_NS_GPL(to_cxl_dax_region, "CXL");
-
-static struct lock_class_key cxl_dax_region_key;
-
-static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
-{
-	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_dax_region *cxlr_dax;
-	struct device *dev;
-
-	guard(rwsem_read)(&cxl_rwsem.region);
-	if (p->state != CXL_CONFIG_COMMIT)
-		return ERR_PTR(-ENXIO);
-
-	cxlr_dax = kzalloc(sizeof(*cxlr_dax), GFP_KERNEL);
-	if (!cxlr_dax)
-		return ERR_PTR(-ENOMEM);
-
-	cxlr_dax->hpa_range.start = p->res->start;
-	cxlr_dax->hpa_range.end = p->res->end;
-
-	dev = &cxlr_dax->dev;
-	cxlr_dax->cxlr = cxlr;
-	device_initialize(dev);
-	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
-	device_set_pm_not_required(dev);
-	dev->parent = &cxlr->dev;
-	dev->bus = &cxl_bus_type;
-	dev->type = &cxl_dax_region_type;
-
-	return cxlr_dax;
-}
-
-static void cxlr_dax_unregister(void *_cxlr_dax)
-{
-	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
-
-	device_unregister(&cxlr_dax->dev);
-}
-
-static int devm_cxl_add_dax_region(struct cxl_region *cxlr,
-				   enum dax_driver_type dax_driver)
-{
-	struct cxl_dax_region *cxlr_dax;
-	struct device *dev;
-	int rc;
-
-	cxlr_dax = cxl_dax_region_alloc(cxlr);
-	if (IS_ERR(cxlr_dax))
-		return PTR_ERR(cxlr_dax);
-
-	cxlr_dax->online_type = mhp_get_default_online_type();
-	cxlr_dax->dax_driver = dax_driver;
-	dev = &cxlr_dax->dev;
-	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
-	if (rc)
-		goto err;
-
-	rc = device_add(dev);
-	if (rc)
-		goto err;
-
-	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
-		dev_name(dev));
-
-	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
-					cxlr_dax);
-err:
-	put_device(dev);
-	return rc;
-}
-
 static int match_decoder_by_range(struct device *dev, const void *data)
 {
 	const struct range *r1, *r2 = data;
-- 
2.52.0


