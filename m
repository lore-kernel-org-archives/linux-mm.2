Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54C8D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D3B6B0093; Thu, 29 Jan 2026 16:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1906B0095; Thu, 29 Jan 2026 16:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B886B0096; Thu, 29 Jan 2026 16:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2FF06B0093
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6B711B0B6A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:02 +0000 (UTC)
X-FDA: 84386231244.11.CE0D535
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2651C0002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WavEOP1m;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5ShTIweYFg1/ZuxvW60BAtA8gMRBxv7vwbNQNJLoKA=;
	b=q3KDdt6yul4MTMp59eB988f45w4NTgHDC1ZVq/yOI8Zdicip/6uqQwsdsVQ9pkdgJZt69a
	B/fB117Zc6XPoHvPHRjL/KQADZZqmfp3RBb38Iko1DKn/KahrKNvrYc8vYaRNazC2ASPEG
	vgVUzmIVhbviEiM5J66lDW5TGc21lzI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WavEOP1m;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720700; a=rsa-sha256;
	cv=none;
	b=dnVC76ssZ/y6diMFQW8QqGZ1/HtVtD7CKuk4CkmQ3oS+WVz11EoQKeauAdxzVHJts/GZf1
	CizgUESfOH9Y5Dd1LC/o26jq6+LqWgicItzRbEHo1tf5KmThAs7LwcF8MaZISei84NBNKp
	JriKwZKAqhfA8Z1iwLFptMUv5DiQe8o=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c6d8751c88so150743085a.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720700; x=1770325500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5ShTIweYFg1/ZuxvW60BAtA8gMRBxv7vwbNQNJLoKA=;
        b=WavEOP1mId3+FoQ5qDakEK1Gx/y2jEHtiUyGlGzCE3/s2SoO3ky5bXrvI1awibeW3n
         7uXl5zr3dwBjKVuDIlghZHyqlxi/xVdcFd4CoiqNgq32TlumMcgcGAPPVyWHZIemTCO1
         bNhyX98pa3S14iotDSrM/7dM+CjWanI0FcuH0YBdVsoawKZN/I7rGH/4CF7mFarnbNfH
         aQvmHv/x51Dyqnj0lij17dy6ZnKB7pokeycy4f8wV0TikWxgv2SkD3xfqfGsUUlbfM2f
         sd+tQ4tXGB+NrEFy61ZKJS3mTf4qNPdqSXGlcm8Bpjzj5u+oDmCfsGZSda0pa9APAG92
         pnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720700; x=1770325500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M5ShTIweYFg1/ZuxvW60BAtA8gMRBxv7vwbNQNJLoKA=;
        b=P/+H3pGWdFq/IskBO7eh5oUWXprw0R6UtqcbbWMHoM/ZtMQ0k9bcS6IpUKtmUy/Fri
         y6NjzooWsjSBtbm8e/YIUrFBvdGoSpwb57qW7kCeDCDwbqKIOTs3z0vlIC7lsIkedHcp
         tK3Yh3kpX9C9t22Wlr8he8fhiNqah/jdz752SzxxySKKtXuIgTI+RQ0WysiPkTwa2lzK
         GLWDSfnSKYuMBQXc1k9JK1218H+v3pyIJA1G28kM6qQiFdZKSnhsMCszzMVae7eeVcu2
         YoxLc4YRlzahAQ8/sJepOHsw6c7GU/c25UQQBHgYAkOPuu8/BagEQAQEzimM/8Ca5n/e
         1yZA==
X-Gm-Message-State: AOJu0YxWKuivHHbiNmAW0YItYeOOH+ktOFTjxfsnjcAmVhm/tg7jvtDm
	6ED0AQugIYyuskibfx8hRE4z42rPfEVhI/nmWv0zuimm87l5CHcZpNqv+UBsP7VCPT6oRcPd9Jw
	u0yO25P4=
X-Gm-Gg: AZuq6aKG0TkW1c2SNFFS7i5Cp0MDOw5jQmBPbm+j2wCsjId+EaGEaDDbURekssv1AGE
	7MGYN4K7y7QeOj3Axa5Jw321fd/L+T+m3Bfo4l0rdKLMvkd9MNXMcuZZr8Py8/8X9IAcefIO2LX
	nmJXQ2oRBnaXpa1oeKCotd4xAkDpdEfLhl20yfOXP/x0hazZA6j8EOBOJYaRSCSav5SE8Ab8//S
	/GGH9QRDoPQEHtPtzzOhL1M5jKM8VKlT1YWhumaUjSIhLhkXtrZO+qeL/LktQVr1L2UWsbdyFS5
	795pVk8jZGlS2f9eZgl0KXq6VSDeyZFu3iwQqnZFg6Kn/UXxsnFQnM8qn/EAJsYDXh4X8oPBMfn
	TW80l7CbZjtJxtiv0jrlXYmYQEhYeHYejxUBVEy0Mfo+gujzm5A6YbBwNtNrGL1rtIFsMRsCQ9R
	nBb+wZOn2YvDmx6sWF2stZp+sEYNMyNhj8zzq9owMOXwBkaTMnroWlPuIgghOR3Ig+njYaKqOeH
	/A=
X-Received: by 2002:ac8:7d4b:0:b0:501:47f8:982d with SMTP id d75a77b69052e-505d223dfcbmr11826491cf.52.1769720699550;
        Thu, 29 Jan 2026 13:04:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:59 -0800 (PST)
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
Subject: [PATCH 5/9] cxl/core/region: move pmem region driver logic into pmem_region
Date: Thu, 29 Jan 2026 16:04:38 -0500
Message-ID: <20260129210442.3951412-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D2651C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: zqusuq87d4n7s3xhgwqwaz4cpopsk9s8
X-HE-Tag: 1769720700-307912
X-HE-Meta: U2FsdGVkX1/QLdXNrJO+qcFozBgs6ujkBZnNKrwwa66kbMODF2kwzhVkO+77ZfTROBAja7C4CvGrZG9/JcryCjnMsGz3CXkK+aYBRl3DtAiW+/L+72cKN79FWyQRID1oIGExGO0Bg2vjKhisqPu4CqvMSjLnrK4mzrmWv3Ustw0gLMVPKvfAgUSTHXwJ0x94DfhzZTUaCPeq476DlffcCP76wh34lLdaoZoOScJ2TdqpGoA093i5p/TTJIrFc2vlLJh3kAP8MuiTjkr+Qp6NDuZ+elwBrig+jn2K3d4qNt+wzOsQ5U+nfADsjJv2Pp6z5Is4r2H7Nq09VOWVh9zTv614Wxjv+Nsuihu9H0p+P0odJrOSkLwTCcGyl8nvG/9JZP0xK1jaxC9tepdQL0Y0GgmAH8mJ7Fyf3akWzzQzgrfaMX1FwgKV2aysnEWXBCPJBvzKZhFxgaoUcJnqzz4R45XQhQHmKi/HoFCiXQ4YNoBRejFR51iDOEVyW9UoFCm1QDHPMT14kcBH3KBrhpjc97PiEnJ1RhOUb/QJGBakra/L3f3W6ajUyNCGC9xJp5ZD6r+6knnMtpEWAHV4d93pzLxPk4DE0zRFZca7LcDiZNOI7sZc2BnzFiAF11fZ2HHrMYvluCDYoJt3ZlM6s0gbB2gZvq2Yx6C63DcaWcjVXJH1iDuG8xWbK/WFMTNHlzs0Hg9ShP3ZhC+j00vvvkjb9sSBaHzpQXJEcDNLgKnYtRcaOcn0g3UW9FJCiqf/Jchr1pMChysOu1mQRJciiYfGmbRtKsNEcUJ055g4DYvhANthR4KYxxT1REUb91IZo4PC/uEGambHEm4S6vejfGNIh1DBU03imPLLSdQ7DTetLFfH39O9XzWW9pyH2/ahnKQgT9xgY8dRUQw4wEn8t/SG7ZJ2WtOQcf+PJP1X9S802sR7piLx3i+cfAllNHV/ljBqNYYfuKt0hSzzFh4BXLK
 HhWJWcR2
 buBXwW4zc/Z6cSp+6B9ez0SiNKpdPfFwat+0MKjKa0tSNTlWcOrquYmplJFE7UxwyqrtlHLJdbf/mwFY2oU/lg3Bx+EqNi8z3c9vS2otipjiI/BGIyY9EqkbeVA8gFKPGV+b1Oi7Ye0JT2c2i8GBw6RIpqZ0UlxK8iimcutRlOJqYhnJVt42XVW4vCWXwoDX0o3g+eN+F4BrrHzihOhCGPIihmWUPFrQTLAzAW0ThI5LZUEl+GhUv8SlEf0o/gvR997+d2wOWKh0I4tu7uhH/p4qF4ZaRR14asgsBOxli6wMx9Vu6I8HVIzxP6nBrHCQvgMs+M0p1HqJH3ybabuyF81evahD9EHODTFLgNYkRanTR6swV8zF7e5Q7iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the pmem region driver logic from region.c into pmem_region.c.

No functional changes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/Makefile      |   1 +
 drivers/cxl/core/core.h        |   1 +
 drivers/cxl/core/pmem_region.c | 191 +++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c      | 184 -------------------------------
 4 files changed, 193 insertions(+), 184 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 5ad8fef210b5..23269c81fd44 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -17,6 +17,7 @@ cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index dd987ef2def5..26991de12d76 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -43,6 +43,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
new file mode 100644
index 000000000000..81b66e548bb5
--- /dev/null
+++ b/drivers/cxl/core/pmem_region.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+static void cxl_pmem_region_release(struct device *dev)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	int i;
+
+	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
+		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
+
+		put_device(&cxlmd->dev);
+	}
+
+	kfree(cxlr_pmem);
+}
+
+static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	NULL,
+};
+
+const struct device_type cxl_pmem_region_type = {
+	.name = "cxl_pmem_region",
+	.release = cxl_pmem_region_release,
+	.groups = cxl_pmem_region_attribute_groups,
+};
+bool is_cxl_pmem_region(struct device *dev)
+{
+	return dev->type == &cxl_pmem_region_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
+
+struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
+				"not a cxl_pmem_region device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_pmem_region, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
+static struct lock_class_key cxl_pmem_region_key;
+
+static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct device *dev;
+	int i;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return -ENXIO;
+
+	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
+		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
+	if (!cxlr_pmem)
+		return -ENOMEM;
+
+	cxlr_pmem->hpa_range.start = p->res->start;
+	cxlr_pmem->hpa_range.end = p->res->end;
+
+	/* Snapshot the region configuration underneath the cxl_rwsem.region */
+	cxlr_pmem->nr_mappings = p->nr_targets;
+	for (i = 0; i < p->nr_targets; i++) {
+		struct cxl_endpoint_decoder *cxled = p->targets[i];
+		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
+
+		/*
+		 * Regions never span CXL root devices, so by definition the
+		 * bridge for one device is the same for all.
+		 */
+		if (i == 0) {
+			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
+			if (!cxl_nvb)
+				return -ENODEV;
+			cxlr->cxl_nvb = cxl_nvb;
+		}
+		m->cxlmd = cxlmd;
+		get_device(&cxlmd->dev);
+		m->start = cxled->dpa_res->start;
+		m->size = resource_size(cxled->dpa_res);
+		m->position = i;
+	}
+
+	dev = &cxlr_pmem->dev;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_pmem_region_type;
+	cxlr_pmem->cxlr = cxlr;
+	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
+
+	return 0;
+}
+
+static void cxlr_pmem_unregister(void *_cxlr_pmem)
+{
+	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	/*
+	 * Either the bridge is in ->remove() context under the device_lock(),
+	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
+	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
+	 * lock).
+	 */
+	device_lock_assert(&cxl_nvb->dev);
+	cxlr->cxlr_pmem = NULL;
+	cxlr_pmem->cxlr = NULL;
+	device_unregister(&cxlr_pmem->dev);
+}
+
+static void cxlr_release_nvdimm(void *_cxlr)
+{
+	struct cxl_region *cxlr = _cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	scoped_guard(device, &cxl_nvb->dev) {
+		if (cxlr->cxlr_pmem)
+			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
+					cxlr->cxlr_pmem);
+	}
+	cxlr->cxl_nvb = NULL;
+	put_device(&cxl_nvb->dev);
+}
+
+/**
+ * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
+ * @cxlr: parent CXL region for this pmem region bridge device
+ *
+ * Return: 0 on success negative error code on failure.
+ */
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
+{
+	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct device *dev;
+	int rc;
+
+	rc = cxl_pmem_region_alloc(cxlr);
+	if (rc)
+		return rc;
+	cxlr_pmem = cxlr->cxlr_pmem;
+	cxl_nvb = cxlr->cxl_nvb;
+
+	dev = &cxlr_pmem->dev;
+	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
+			dev_name(dev));
+
+	scoped_guard(device, &cxl_nvb->dev) {
+		if (cxl_nvb->dev.driver)
+			rc = devm_add_action_or_reset(&cxl_nvb->dev,
+					cxlr_pmem_unregister,
+					cxlr_pmem);
+		else
+			rc = -ENXIO;
+	}
+
+	if (rc)
+		goto err_bridge;
+
+	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
+
+err:
+	put_device(dev);
+err_bridge:
+	put_device(&cxl_nvb->dev);
+	cxlr->cxl_nvb = NULL;
+	return rc;
+}
+
+
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e4097c464ed3..fc56f8f03805 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2747,46 +2747,6 @@ static ssize_t delete_region_store(struct device *dev,
 }
 DEVICE_ATTR_WO(delete_region);
 
-static void cxl_pmem_region_release(struct device *dev)
-{
-	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
-	int i;
-
-	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
-		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
-
-		put_device(&cxlmd->dev);
-	}
-
-	kfree(cxlr_pmem);
-}
-
-static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
-	&cxl_base_attribute_group,
-	NULL,
-};
-
-const struct device_type cxl_pmem_region_type = {
-	.name = "cxl_pmem_region",
-	.release = cxl_pmem_region_release,
-	.groups = cxl_pmem_region_attribute_groups,
-};
-
-bool is_cxl_pmem_region(struct device *dev)
-{
-	return dev->type == &cxl_pmem_region_type;
-}
-EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
-
-struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
-{
-	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
-			  "not a cxl_pmem_region device\n"))
-		return NULL;
-	return container_of(dev, struct cxl_pmem_region, dev);
-}
-EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
-
 struct cxl_poison_context {
 	struct cxl_port *port;
 	int part;
@@ -3236,64 +3196,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
 	return -ENXIO;
 }
 
-static struct lock_class_key cxl_pmem_region_key;
-
-static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
-{
-	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct device *dev;
-	int i;
-
-	guard(rwsem_read)(&cxl_rwsem.region);
-	if (p->state != CXL_CONFIG_COMMIT)
-		return -ENXIO;
-
-	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
-		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
-	if (!cxlr_pmem)
-		return -ENOMEM;
-
-	cxlr_pmem->hpa_range.start = p->res->start;
-	cxlr_pmem->hpa_range.end = p->res->end;
-
-	/* Snapshot the region configuration underneath the cxl_rwsem.region */
-	cxlr_pmem->nr_mappings = p->nr_targets;
-	for (i = 0; i < p->nr_targets; i++) {
-		struct cxl_endpoint_decoder *cxled = p->targets[i];
-		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
-		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
-
-		/*
-		 * Regions never span CXL root devices, so by definition the
-		 * bridge for one device is the same for all.
-		 */
-		if (i == 0) {
-			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
-			if (!cxl_nvb)
-				return -ENODEV;
-			cxlr->cxl_nvb = cxl_nvb;
-		}
-		m->cxlmd = cxlmd;
-		get_device(&cxlmd->dev);
-		m->start = cxled->dpa_res->start;
-		m->size = resource_size(cxled->dpa_res);
-		m->position = i;
-	}
-
-	dev = &cxlr_pmem->dev;
-	device_initialize(dev);
-	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
-	device_set_pm_not_required(dev);
-	dev->parent = &cxlr->dev;
-	dev->bus = &cxl_bus_type;
-	dev->type = &cxl_pmem_region_type;
-	cxlr_pmem->cxlr = cxlr;
-	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
-
-	return 0;
-}
-
 static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -3357,92 +3259,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	return cxlr_dax;
 }
 
-static void cxlr_pmem_unregister(void *_cxlr_pmem)
-{
-	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
-	struct cxl_region *cxlr = cxlr_pmem->cxlr;
-	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
-
-	/*
-	 * Either the bridge is in ->remove() context under the device_lock(),
-	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
-	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
-	 * lock).
-	 */
-	device_lock_assert(&cxl_nvb->dev);
-	cxlr->cxlr_pmem = NULL;
-	cxlr_pmem->cxlr = NULL;
-	device_unregister(&cxlr_pmem->dev);
-}
-
-static void cxlr_release_nvdimm(void *_cxlr)
-{
-	struct cxl_region *cxlr = _cxlr;
-	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
-
-	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxlr->cxlr_pmem)
-			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
-					    cxlr->cxlr_pmem);
-	}
-	cxlr->cxl_nvb = NULL;
-	put_device(&cxl_nvb->dev);
-}
-
-/**
- * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
- * @cxlr: parent CXL region for this pmem region bridge device
- *
- * Return: 0 on success negative error code on failure.
- */
-static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
-{
-	struct cxl_pmem_region *cxlr_pmem;
-	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct device *dev;
-	int rc;
-
-	rc = cxl_pmem_region_alloc(cxlr);
-	if (rc)
-		return rc;
-	cxlr_pmem = cxlr->cxlr_pmem;
-	cxl_nvb = cxlr->cxl_nvb;
-
-	dev = &cxlr_pmem->dev;
-	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
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
-	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxl_nvb->dev.driver)
-			rc = devm_add_action_or_reset(&cxl_nvb->dev,
-						      cxlr_pmem_unregister,
-						      cxlr_pmem);
-		else
-			rc = -ENXIO;
-	}
-
-	if (rc)
-		goto err_bridge;
-
-	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
-	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
-
-err:
-	put_device(dev);
-err_bridge:
-	put_device(&cxl_nvb->dev);
-	cxlr->cxl_nvb = NULL;
-	return rc;
-}
-
 static void cxlr_dax_unregister(void *_cxlr_dax)
 {
 	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
-- 
2.52.0


