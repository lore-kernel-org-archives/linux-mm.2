Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B370FC61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D906B00A0; Mon, 24 Aug 2026 22:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64986B00A1; Mon, 24 Aug 2026 22:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D5A6B00A2; Mon, 24 Aug 2026 22:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABD66B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3E45A02D9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:20 +0000 (UTC)
X-FDA: 85138205040.29.89157CC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71AC440002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A/h3yFp4";
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624838;
	b=EI56qE4gNIjLlUFWv8aQRur4rqauk4dUWblSmhiogM6tesTRGu/G7PWYIXg8+554cxZrxp
	8+YsUCyLXv0vS9eAdvcS7ScG/MFn10cLioldOvdxurJViRX+z8Zf8MPELmxNyYYVOroQzg
	F6EMB50IH9IUe6zvD8MbCL9cQLER0lk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A/h3yFp4";
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jeLjlOYa7PXwb2mErSpf6zXoDgFdbgFFzGGOuic07s=;
	b=59/1UQuuZ5U6T834Gn11e/rmV2kSsWyWUUfk7AdhX4F+yZNmYtlPYByz+dSmYeWeG6KCNx
	Uk7RIkvDvAt6WYWoOaAYrXt+W0z3/Of2AP4y3c5/0J1pbW7jrun1BmDIGNeTDd/kS8vE+k
	S+aA5FT0ic5QqUdv64PIp/KF0FksdNc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624838; x=1819160838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aXTtEnO6MnuWppdHZS1gvwOd5SjDHPsW8ORjbcfJWQQ=;
  b=A/h3yFp42yOuaB4r5WNBUvIHBAuco+IQWf6/TzTCYrQZf/oikilJrukD
   eWqx4vVWWILpl0+MHERb57oS0O6iuG7AfT0I4mxQPIJj9EuNAPQ0ooFxH
   VQ8LzaBM8FMYAzgcbULqOkOoH9zy8zyQQ5j8qtApHxwb6nuDAQA4Ak7W5
   5fpWWjP8B9PZ4GmZTDj9LoUsBwURfAb8XIN7zJVEOeA4ISDAfpHwGVBng
   hXImBk/dLj0p7NgzjXx+yv9xFdoFdig2kSesh7NQ3mndPCvMIOqp9UtXp
   vuxhDiQEVoge2xEFHUBue/sSMVFk0n8tBA0A/B5UPYIqT7hkjrBSffggT
   g==;
X-CSE-ConnectionGUID: KVi+l2HZQmGkk5c8Bxgrgg==
X-CSE-MsgGUID: Icy8XRtKTLy0XZ1u0RG67Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761078"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761078"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:18 -0700
X-CSE-ConnectionGUID: bh8BLriISryoZmUmpOxQeQ==
X-CSE-MsgGUID: pETfxswFQYytmM6PaR59QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390086"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:10 -0700
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
Subject: [PATCH v2 05/13] cxl/core: Restore the HDM decoders below DPort
Date: Tue, 25 Aug 2026 04:26:20 +0200
Message-ID: <20260825022628.3651434-6-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71AC440002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ncbt6oss3173dsymo5s11bmedc1stncs
X-HE-Tag: 1787624838-878265
X-HE-Meta: U2FsdGVkX18d3+MwWLAzByXv93igdaF6nq+Scs28xNSyGW1k3bumVUfQ8mNpe6mA78iluGSsa6AjslZeiIecEXosQ5GoJVNnIPxOaT/PmVHrR2q4gSxm/yV2TVHLy4ucqyF47o8McHmIHxgLzuw2tnPMzAoIZbonPzTkf/QTMiac4av0rAQVHuG7oKugizOGz1d6UcQBPaWi6DsHxywMPtaJIKdyO4GBPOCpAn7wOtKO1kEEaRB3iJrF//90TtpSKwgE91duVb8QLrrJYN2XTfUhas19syrGfOuUDJkB0egkcXR4tuYK0heZo6mynOa0h69zLvxS8UGQ7gI4e8hJZ7ZOXQ0/Is/Wa1AYbWPYllOnwxjH67eyiXfa3iBXFiSjGVv6vAAIyVkn9M1YnbXDEeWIu4QryZF/zlAVnfzOfOdgoB5SxD6hSczhofqGObYyCCixz7avY7qBJQ/rcWPmEjQqNio+FWKZhCQOsBgeXrxp6yAlNigzI1XYatrcCOTnlRJrgoP1Gd6feJ/ePAKyGo/Om1xoyM8kR6SHXeAM6nZdoqJa336/sE0DGAc1Z+tiyWFjishSrM9DE3/+0ibxIowxaU32gWZfuFxbnlSsgD0btZnF/madKDJU7YQwOaXeAZ13tLl7x9hJR3IDSjiYAJFaE1QxR35KkaZ214N+kz56va7oyRotIc6sF0LVHl1JQIuGF0T6KWfemj4PHnEDJN3vNuPN5XwXt/24UEqiJYAn9/H6b1h9N4SCpAci5XKirp1jjmNwTLXZHXvfzf/qOJXV+N11nXs5SIO+5LHsFl6y/VPjW7vsnhQSXj3nS31Usq+hIeXyDKp2V2KkZdqL2w35jhQF6/wnEkmxPIKRx7nQRutYJ4c8FVw6+4u1MvwhbvUSMXNgYCjWqRQWTfS1847MGLJQwITN9wsd9bJtNseyu2932leaIuMrdT1Cb9MYRJUvZfqiLsTJZ71wWDT
 Qt8k30G6
 23Q1xfht3WNRwAGqy+WKmhjyHN8lG8mfVoc3R4NbhAkQxR4xmmHvCFh9YjCBEibXllVQPvwGQLyBwa/JqgpTENr3Yqpf38Nv1qQ+AGOasc2GRSJMbqMLhRqTZJuInHd12c8in1ffMx6TYZxgFSBMBD3w23O6rPQ/dQQ566CcpJjDRN6NETwOn0EM9Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset clears the HDM Decoder registers of every CXL
component below the Port, so the decoders have to be reprogrammed from the
settings the driver holds before anything reaches the region again.

Add cxl_sbr_recommit_decoders() to find the CXL port that owns the
Downstream Port and reprogram the decoders below it. It takes
cxl_rwsem.region for read across the walk: the walk reads the endpoint set
below the Port, each endpoint's parent chain and the switch decoder target
lists, all of which change only under that lock held for write.

The driver's cached settings do not cover the whole of either control
register, so the saved state that cxl_port_recommit_decoders() needs is
passed through as well, an xarray of struct cxl_hdm_state keyed by
struct cxl_port and read before the reset.

Put it in a new dport_sbr.c, which collects what a Secondary Bus Reset of a
CXL Downstream Port needs from the CXL core. find_cxl_port() loses its
static since the lookup now has a caller outside port.c.

It has no caller yet. It is used on the way out of the reset, once the
regions routed through the Port are back.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/Makefile    |  2 +-
 drivers/cxl/core/core.h      |  6 ++++++
 drivers/cxl/core/dport_sbr.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/port.c      |  4 ++--
 tools/testing/cxl/Kbuild     |  2 +-
 5 files changed, 46 insertions(+), 4 deletions(-)
 create mode 100644 drivers/cxl/core/dport_sbr.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index ce7213818d3c..4d4538182d81 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -15,7 +15,7 @@ cxl_core-y += hdm.o
 cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o dport_sbr.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index d23f0bbd7bf0..a8b9d7990d32 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -13,6 +13,9 @@ extern const struct device_type cxl_pmu_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
+struct cxl_port *find_cxl_port(struct device *dport_dev,
+			       struct cxl_dport **dport);
+
 enum cxl_detach_mode {
 	DETACH_ONLY,
 	DETACH_INVALIDATE,
@@ -53,6 +56,9 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 void kill_regions(struct cxl_root_decoder *cxlrd);
+struct pci_dev;
+void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
+			       struct xarray *hdm_state);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
new file mode 100644
index 000000000000..55c35386d0cb
--- /dev/null
+++ b/drivers/cxl/core/dport_sbr.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation. */
+
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <cxl.h>
+#include "core.h"
+
+/*
+ * The reset cleared the HDM Decoder registers of every CXL component below
+ * @dport_pci, so restore them from the settings the driver holds and from
+ * @hdm_state, the register fields the driver does not model, saved before the
+ * reset. Takes cxl_rwsem.region for read, which cxl_port_recommit_decoders()
+ * requires. The caller has already disabled the regions, so nothing reaches the
+ * decoders being reprogrammed.
+ */
+void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
+			       struct xarray *hdm_state)
+{
+	struct cxl_dport *dport;
+	int rc;
+
+	struct cxl_port *port __free(put_cxl_port) =
+		find_cxl_port(&dport_pci->dev, &dport);
+	if (!port) {
+		pci_dbg(dport_pci, "no CXL port owns this Downstream Port\n");
+		return;
+	}
+
+	pci_dbg(dport_pci, "restoring HDM decode below %s\n", dev_name(&port->dev));
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	rc = cxl_port_recommit_decoders(port, hdm_state);
+	if (rc)
+		pci_warn(dport_pci, "HDM decode restore failed: %d\n", rc);
+}
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 1215ee4f4035..66a6d513843e 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1392,8 +1392,8 @@ static struct cxl_port *__find_cxl_port(struct cxl_find_port_ctx *ctx)
 	return NULL;
 }
 
-static struct cxl_port *find_cxl_port(struct device *dport_dev,
-				      struct cxl_dport **dport)
+struct cxl_port *find_cxl_port(struct device *dport_dev,
+			       struct cxl_dport **dport)
 {
 	struct cxl_find_port_ctx ctx = {
 		.dport_dev = dport_dev,
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 2be1df80fcc9..f18d41b299fe 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -63,7 +63,7 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
 cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/region_pmem.o $(CXL_CORE_SRC)/region_dax.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/region_pmem.o $(CXL_CORE_SRC)/region_dax.o $(CXL_CORE_SRC)/dport_sbr.o
 cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o
-- 
2.55.0


