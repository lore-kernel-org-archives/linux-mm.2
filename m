Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58C1C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906D86B00A3; Mon, 24 Aug 2026 22:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE026B00A4; Mon, 24 Aug 2026 22:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F4A6B00A5; Mon, 24 Aug 2026 22:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 517B36B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF3A3A02D3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:34 +0000 (UTC)
X-FDA: 85138205628.27.83D6054
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9AF2540005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LSqWKhxW;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624852;
	b=vbN42UHic08xpjut/+3kWfX2sUGgb5EMHs2YTz9Cg3AAfdpMqpK/cUqTrwHqroufeuu1nT
	dc3jzRHMb4GkJCiZ7gl/Kqo0F8KD2jish/yoDxgAnBcGoU406oH5rmK5OtzhU5zQ9zigjd
	mqLVbMbyV0pnjLuhMx3zlvFPiQ4qSes=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LSqWKhxW;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gg63PhMraaFvL8DloQlOafHaxDCdsaa0LL08JCLdwZ0=;
	b=qw0LGdyBjarjZw+10teD/d+Nf8Rko5jvntcD0jFDvNVx8tHa4kpAKQ5rAhAPnKO6qdeGhZ
	TcyrFhHWRFO0ZDtYaJ7C+B+geTMoqDL58F7wCMcx6UyWMhOp1G8TCW9XWnPOxwUYo9Ljzr
	kZnjuCNjQCX8PjqEx0smAIpfobr/CBI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624852; x=1819160852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWL2Fx2f1XZ+ch7E4+5dIo1Wx0My4gYiTT+UYgnRcCg=;
  b=LSqWKhxWagvIIkOZDUSWCV0Hw+87KSAXzVOpc9MdyXkfZnBgfLgMfBN8
   kaQVxXxxNZYfsAJU4P9WFUnmIy/Wnv+n9pEZhqhxjtBKYTQj61ukxfjOc
   O1m3iOwTJdRj+nCbnCdVi9awJjVgxBEVNfUnsHpkOPScaMuO+6DeWLbfC
   yDWRi0gz0TZhsPAyIdVeQB3YXGY3L6F6W+RCuCDAsK5Z2PJpw/cHgdFI7
   6rjtOl2/uDDgA2XhN6yVoYTu5voltH0uCRwsdJx6izR8srvvbDhPaTsvL
   IfhO4yX/Af9fp6t8xER6dqC2KsDbOKmLsagMmwPZI/EAKJtCi2K4/sTK9
   A==;
X-CSE-ConnectionGUID: 3u7yq89rSKS6Ne/FhuRWTw==
X-CSE-MsgGUID: eanMcn/AQgm+rbuZUpKfvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761125"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761125"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:32 -0700
X-CSE-ConnectionGUID: 7NtM2xUoQvWwCT7qK5iedg==
X-CSE-MsgGUID: cG6ZbR99R2KFBRJD6RIbrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390100"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:25 -0700
From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
To: linux-cxl@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [PATCH v2 07/13] cxl/core: Add region disable and enable for a DPort SBR
Date: Tue, 25 Aug 2026 04:26:22 +0200
Message-ID: <20260825022628.3651434-8-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AF2540005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: prmq7z15iawddmwyr87iyg7xtrsjdp7q
X-HE-Tag: 1787624852-382653
X-HE-Meta: U2FsdGVkX1/VizpWHW8w5oW7gYv3UK2TSMd6B9FYdy9KgmWOb9qg6r2Xu+Ro44H2pr51k9L+7B7wVAccsj1NpJ66fytT1F+Dj8TmiAagbnypJNd7oV21SP9h5D9E8l2h8S98KYnSdD+GblLF/uS9VDOjEEeISE5NOO7+FFVxKZP69xp2r425MlrOu/MyZQcRC/BQfqfydYPHZrUuujTlUE/yw98jw6BCw9JHVBp8XW/3OIpVokZ3R7a18xErAIY4Imbm9lSw2vFA/V5i5aBws/IH07MgKsnSe1pWPNnvAkB09XVAKjYhW4JOd10zY5zFAQ8/Kvc98HkU6BryjEEDEBx+mu72QvMvwDECZDXrujM5GN5XhexOy3cPhwFw4YNGvLZ/irAiqoxxEQj9DKN5T0hU7orRWZy4OtywjZ7Y7mFy7+MqiN0vMm62ZkXzfRV2HBtcGxjfnJvdsyV1vXez8KLcX0ylMU7Y7otZIRXBEvJ0L/FVfOu2C1yfLEKDylX1qvucrSaILt6W37jgbDOwNwYYzxvKAJnY76YUecI6VefIU4/BOi1u0ujZw90RDIhn/fEznkqQZ8U7v0yxbBJfT8NIXLTO8MRoy/V5/evuc6XcBiGuO+StC0RJ30BCyHS1BptjWQNtNNpf7fYKtrMBSxdZW1Z6kMyE+HTD+Wk3+xQZKEEAMqey4uFR8WJTNZEw96QV2/YIWnQI8UxhwErqXTs8CqNouHdP93N6x1kN+URTPADPSwU/AsA4ipfCVxFgETrGDxm1W4h4qJPwI/c0hfQ4BDoghoPsXmn+klPJtSxLgupL3qI6rXp2oJxb9OP8M3ncuXyR/p9jMXuTv5E+FKMJfujBdU/dDafVJ7Ejnkm4WddVvvRs2VAleQwbAm3GdMmBPnpYcXDZsEzYW8zRlJXAlhI7vE0cagbumxQczgAh7z1LV5IG5pMEnXbIEmVJ9qE8hBBh36frmNn0YAN
 jMInWg7J
 Ua/e8C4NYwk+Jzn3LDTJSc3AYP4Nwi0VcTeJISC9bmlVBjGZL9P24WSwsCNJ5yyPvnsxFNhPQGv7mbdRTco0u8/ihsX2KcZ0jEhmtBEeibjNiIUiIJrmXGv8Qjo9o44GtxR+q6c5+1gL0i9xaeAZ10oE+j/szqzga6R/Dz4lVnvcGu4WJ4NLt8s+EAgyfPdAduQ2s8G7gRQwAtLmmQrDbZfMbnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset of a CXL Downstream Port removes the downstream
component from the bus, so a CXL region reached through that Port has to
be disabled while the reset runs.

Add cxl_region_disable() to offline memory, invalidate the CPU caches
for its range and release its driver, and cxl_region_enable() to
re-attach the driver afterwards.

Neither function has a caller yet. Both are driven by the reset once the
set of regions routed through the Port is known.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h      |  3 ++
 drivers/cxl/core/dport_sbr.c | 79 ++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c    |  3 +-
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index a8b9d7990d32..ac55f9e8160e 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -56,6 +56,9 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 void kill_regions(struct cxl_root_decoder *cxlrd);
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
+int cxl_region_disable(struct cxl_region *cxlr);
+void cxl_region_enable(struct cxl_region *cxlr);
 struct pci_dev;
 void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
 			       struct xarray *hdm_state);
diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
index 55c35386d0cb..0f398ab0d3a4 100644
--- a/drivers/cxl/core/dport_sbr.c
+++ b/drivers/cxl/core/dport_sbr.c
@@ -1,11 +1,90 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2026 Intel Corporation. */
 
+#include <linux/memregion.h>
+#include <linux/memory_hotplug.h>
+#include <linux/memory.h>
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <cxl.h>
 #include "core.h"
 
+/*
+ * cxl_region_disable - make a region inactive ahead of a Secondary Bus Reset
+ * @cxlr: region routed through the CXL Downstream Port being reset
+ *
+ * Offline the memory blocks the region owns and unbind its driver. An SBR
+ * zeroes the downstream bus number, so a region left live as System RAM would
+ * be accessed while the device is in reset. On offline failure return the error
+ * so the caller aborts the reset; the memory is never force-removed.
+ *
+ * Context: process context. Offlining and driver unbind sleep and take the
+ * memory hotplug lock, so this cannot run in atomic context.
+ */
+int cxl_region_disable(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	unsigned long block_size;
+	u64 start, end;
+	int rc;
+
+	/*
+	 * Per CXL r4.0 sec 9.13.1 an Interleave Set has a Base HPA and a Size
+	 * that are multiples of 256 MB, while a memory block spans up to 2 GB.
+	 * A block overlapping either end of the range therefore also covers
+	 * memory outside this region, so round the range inward to block
+	 * granularity as dax_kmem did when it onlined the range. Offlining a
+	 * straddling block would migrate pages that the reset does not affect.
+	 */
+	block_size = memory_block_size_bytes();
+	start = ALIGN(p->res->start, block_size);
+	end = ALIGN_DOWN(p->res->end + 1, block_size);
+	if (start >= end) {
+		dev_dbg(&cxlr->dev, "%s: HPA %pr spans no whole memory block, no System RAM to offline\n",
+			__func__, p->res);
+	} else {
+		rc = cxl_offline_memory(start, end - start);
+		if (rc) {
+			dev_warn(&cxlr->dev, "offline System RAM failed before reset: %d\n",
+				 rc);
+			return rc;
+		}
+	}
+
+	rc = cxl_region_invalidate_memregion(cxlr);
+	if (rc) {
+		dev_warn(&cxlr->dev, "CPU cache invalidate failed before reset: %d\n",
+			 rc);
+		return rc;
+	}
+
+	device_release_driver(&cxlr->dev);
+	dev_dbg(&cxlr->dev, "%s: System RAM offline, region disabled before reset, HPA %pr\n",
+		__func__, p->res);
+
+	return 0;
+}
+
+/*
+ * cxl_region_enable - restore a region after a Secondary Bus Reset
+ * @cxlr: region disabled by cxl_region_disable() before the reset
+ *
+ * Rebind the region driver. The System RAM is left offline; bringing it back
+ * online is a separate administrative step.
+ */
+void cxl_region_enable(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+
+	if (device_attach(&cxlr->dev) < 0) {
+		dev_dbg(&cxlr->dev, "driver re-attach failed after reset\n");
+		return;
+	}
+
+	dev_dbg(&cxlr->dev, "%s: region re-enabled after reset, HPA %pr, IW %d, IG %d\n",
+		__func__, p->res, p->interleave_ways, p->interleave_granularity);
+}
+
 /*
  * The reset cleared the HDM Decoder registers of every CXL component below
  * @dport_pci, so restore them from the settings the driver holds and from
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 1e211542b6b6..fc0bec991a69 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -222,7 +222,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
 	return xa_load(&port->regions, (unsigned long)cxlr);
 }
 
-static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 {
 	if (!cpu_cache_has_invalidate_memregion()) {
 		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {
@@ -4273,4 +4273,5 @@ void cxl_region_exit(void)
 
 MODULE_IMPORT_NS("CXL");
 MODULE_IMPORT_NS("DEVMEM");
+MODULE_IMPORT_NS("CXL_MHP");
 MODULE_ALIAS_CXL(CXL_DEVICE_REGION);
-- 
2.55.0


