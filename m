Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6690CC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5AE6B00A6; Mon, 24 Aug 2026 22:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6959D6B00A7; Mon, 24 Aug 2026 22:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAD96B00A9; Mon, 24 Aug 2026 22:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2D66B00A6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCCA91C156F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:49 +0000 (UTC)
X-FDA: 85138206258.13.CD0C624
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id 850871A0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bh+h1HKv;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY/aFj/stJo1CE7RylgoJbEoIPDAMPyqnpDBZzXjraM=;
	b=5HjJEger+ez9kgUE9qGMuBYVCcvreaI8EKFO6TcoglqPKTZt2cZpzTxifDC20LuXd6rHqq
	w5agAvObpaXDFLpN0P5RUbzS/xEStZ5hOoqrgqf6ITPAtnsfCzAvdjrlc0W3bggIUpNPzw
	jeUkiA13rlTjZPZM3nsB5A0tHFJ+wBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624867;
	b=k+6Rnq5Ox/RLNiyt7IbpOXpUN7UX0a9edYawN0L13OD320GY3IiO7Al/T/XgfI95KrnnRk
	arKMddsW7kHOmR/Yw0ECUlExEI5Zf+O0cnrJuZFHDb4VPqSx7XxsgmHZh/P+KNpBjQYQS0
	Hk89ZoF8Hziv5WXljmFQBiX+Vv+rNKs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bh+h1HKv;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624867; x=1819160867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0VoRnnTQayChxBzG4acN6XeGhlm8VUhd+VjdCd1S3xA=;
  b=Bh+h1HKvPzSIsMn2zyw8nncGmNBaPprn1lilUWCXUhy8y3bQBgLt89A5
   TTIKR52P7oILluUWE4p2PzeBSO6sywbS/OEFj2q8nMN4J+nnHDDeV84Br
   PmyME1KgmECRB81wj2xIm+aSHa+14CBDdTYl3lBDOwDMzXGtsgw2z40hp
   MI3iM9k8E1Hx8hBHF6iV4mwvgDJSw+SVE3NlsVAg3JfICF3aZ+pDYSPJp
   Isdnste84OScgDNpT8rUDnPLM0EpsHvmpnqU2HNYRxEn1mVwj77AZY6cg
   Hw2rsiQZhXOBvmkNKTIuFNNpSNIg8G4ZU9bQcwCGNJymDL5sLqcZW2Ebj
   g==;
X-CSE-ConnectionGUID: 3QaJW1sCTKWi6fa6XwaoQw==
X-CSE-MsgGUID: wSXjp2nHS7y0TYl1k9GgHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761152"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761152"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:47 -0700
X-CSE-ConnectionGUID: FzrjbiKsTl227JOq1FD4UQ==
X-CSE-MsgGUID: IuaxB+CZRSy5ERI6aEK7+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390111"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:40 -0700
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
Subject: [PATCH v2 09/13] PCI/CXL: Disable and re-enable CXL regions
Date: Tue, 25 Aug 2026 04:26:24 +0200
Message-ID: <20260825022628.3651434-10-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jdi8emdtgcwgyeornpxo3zwoducua733
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 850871A0008
X-HE-Tag: 1787624867-120156
X-HE-Meta: U2FsdGVkX1/5HeM3UZmNy4NufB9Mec37CaSR9Ete9S9NA/x73NqG6G5aGeksIRo8QUJaXXMAD3tHwsAX526QcX29V3xS+/5gjVBZBDWkn318tXTV3pZ+I6yEGFaTghy/Zm0nlzNlFwTC9KWjDGZkos91x59Firi1oBkW7HiWzRVfG8/JDaVuTL7TEbY4wKa5LQ0c7rV+0aSOIxy1iz4CXkb3CV5VltSi3NDhBlU2wYLZ2Zn8kka+1ojZkaSKZEnropD+ozCKSRLzFhwswdW8axXoORa3zpyD2yWhiDnabEeYEgWSa+X6tmnwJp/kADO+tT6RNDitM7TtmF4CG+gdQOdHreDLJEoauxSJLs2SZtckKrl4H0wDPLsnb0XtXVDWedITj9XVxmHi3+bsPMVhwDH8+nXcSUdVyRFOSz6Eog9Ea5+qBYo3drgPXlEcjqh7R1zw6FKX7U5OTZLODeO5NkjiLeX9Jv9X1EgJkQyJciJhI648TKo+ZOfuWs+DcG8u1DPSIMjorF7F4Y0uJdstbVeSjaKILzUjOjVIUAWkkIPG4s2C9RwzjW4iYjfdeTgeBGBYgWgrcRI62s7VThoQJ8Pzu91CGfG2ksNrTEQcpSgXOPcHJxLj9eAz0kq3NjZFbxTPd+TI5e3b0eOVOmQfQpZJN9uSyOExbmZsAg35nyRMWcX5LoNt4+RMCtNJYr9xIfJ0QV3kZWBVOaCLUhykA5aKIf68wDRABMOIELhTlT/RyPbMY8uEwZpYSrIWPg5eHGfCbSBolGpSQebRQ0bcxGlgXdil1abhoxUGXAbnR6+hoUid7P2YyfaBOXYvPIEFxZhrVwm7S3vbB3JiRZIocmEsSxJLB3Q6rs3KyelGP9/qkHBuM/HN2/7Ezp2mggpJmgx3CUwGX9eb96JsuvFf9a5x75lEA4vVhrQdq1toeHJlXNfwWEZj0juPs5Ls0lVZBIKF4SNhdUbU7awXbwi
 JwpVTsOH
 1MKWDGF3aQvf8g+YDwCIdFbhc3sPFNTxcwpsSccLtS6aogV5Ch+uOFj6yz6lGqGPx76nsj9a0RjYjOTrbR6hQZYFwoXEJ09u89aIr6nYybAX2rHVwbT1mZzv0mlmdzlB5woobGwLmpeHSmo0mOEb9UsOippCPtuo2Isje0pjp4XzIXYrgjgkp7NsLVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset of a CXL Downstream Port needs every CXL region
routed through that Port disabled for the duration.

Add struct pci_cxl_sbr_region_ops, holding a disable_regions() and an
enable_regions() callback, and pci_cxl_set_sbr_region_ops() for the CXL
core to register them. The pointer is NULL whenever the CXL region code
is absent, either not built or built as a module that is not loaded.

Add cxl_sbr_disable_regions(), which collects the regions with a member
endpoint below the Port and disables each one. If any fails, re-enable
the whole collected set and return the error, so the PCI core aborts the
reset before touching hardware; re-enabling a region left untouched is a
no-op, which also recovers the one that failed midway.

Add cxl_sbr_enable_regions() for the other side. It restores the HDM
decoders below the Port before it re-attaches any region driver, since a
region cannot serve memory through decoders that are not programmed.

cxl_sbr_disable_regions() records the decoder registers before it
touches anything and cxl_sbr_enable_regions() hands them to the restore
and releases them. They are held in an xarray indexed by the Downstream
Port's struct pci_dev, so resets of different Ports do not share an
entry, and they are released on the abort path too, where
enable_regions() never runs.

Register both ops from cxl_region_init() and clear the pointer in
cxl_region_exit().

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h      |   9 +--
 drivers/cxl/core/dport_sbr.c | 152 +++++++++++++++++++++++++++++++++--
 drivers/cxl/core/region.c    |   3 +
 drivers/pci/pci.c            |  13 +++
 include/linux/pci.h          |  12 +++
 5 files changed, 175 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 077a2af9cf0c..b250fa346184 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -57,13 +57,8 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 void kill_regions(struct cxl_root_decoder *cxlrd);
 int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
-int cxl_region_disable(struct cxl_region *cxlr);
-void cxl_region_enable(struct cxl_region *cxlr);
-struct pci_dev;
-int cxl_sbr_collect_regions(struct pci_dev *dport_pci, struct xarray *regions);
-void cxl_sbr_put_regions(struct xarray *regions);
-void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
-			       struct xarray *hdm_state);
+struct pci_cxl_sbr_region_ops;
+extern const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops;
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
index 233499bc1fad..2b6f840e22a7 100644
--- a/drivers/cxl/core/dport_sbr.c
+++ b/drivers/cxl/core/dport_sbr.c
@@ -21,7 +21,7 @@
  * Context: process context. Offlining and driver unbind sleep and take the
  * memory hotplug lock, so this cannot run in atomic context.
  */
-int cxl_region_disable(struct cxl_region *cxlr)
+static int cxl_region_disable(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
 	unsigned long block_size;
@@ -72,7 +72,7 @@ int cxl_region_disable(struct cxl_region *cxlr)
  * Rebind the region driver. The System RAM is left offline; bringing it back
  * online is a separate administrative step.
  */
-void cxl_region_enable(struct cxl_region *cxlr)
+static void cxl_region_enable(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
 
@@ -93,8 +93,8 @@ void cxl_region_enable(struct cxl_region *cxlr)
  * cxl_region_disable()/cxl_region_enable() run with the rwsem released (they
  * unbind and rebind the region driver). Hence snapshot the set first.
  */
-int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
-			    struct xarray *regions)
+static int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
+				   struct xarray *regions)
 {
 	struct cxl_region_ref *cxl_rr;
 	struct cxl_dport *dport;
@@ -141,7 +141,7 @@ int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
 	return 0;
 }
 
-void cxl_sbr_put_regions(struct xarray *regions)
+static void cxl_sbr_put_regions(struct xarray *regions)
 {
 	struct cxl_region *cxlr;
 	unsigned long index;
@@ -159,8 +159,8 @@ void cxl_sbr_put_regions(struct xarray *regions)
  * requires. The caller has already disabled the regions, so nothing reaches the
  * decoders being reprogrammed.
  */
-void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
-			       struct xarray *hdm_state)
+static void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
+				      struct xarray *hdm_state)
 {
 	struct cxl_dport *dport;
 	int rc;
@@ -179,3 +179,141 @@ void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
 	if (rc)
 		pci_warn(dport_pci, "HDM decode restore failed: %d\n", rc);
 }
+
+/*
+ * The HDM decoder control registers the reset is about to clear, held from the
+ * disable to the enable of one Downstream Port and indexed by that Port's
+ * struct pci_dev, so resets of different Ports do not share an entry.
+ */
+static DEFINE_XARRAY(cxl_sbr_hdm_state);
+
+static void cxl_sbr_drop_hdm_state(struct pci_dev *dport_pci)
+{
+	struct xarray *hdm_state;
+
+	hdm_state = xa_erase(&cxl_sbr_hdm_state, (unsigned long)dport_pci);
+	if (!hdm_state)
+		return;
+
+	cxl_port_put_hdm_state(hdm_state);
+	kfree(hdm_state);
+}
+
+/*
+ * Record the control registers of every port below @dport_pci before the reset
+ * clears them. cxl_sbr_enable_regions() consumes the set and drops it.
+ */
+static int cxl_sbr_save_hdm_state(struct pci_dev *dport_pci)
+{
+	struct xarray *hdm_state;
+	struct cxl_dport *dport;
+	int rc;
+
+	struct cxl_port *port __free(put_cxl_port) =
+		find_cxl_port(&dport_pci->dev, &dport);
+	if (!port)
+		return 0;
+
+	hdm_state = kzalloc_obj(*hdm_state);
+	if (!hdm_state)
+		return -ENOMEM;
+
+	xa_init(hdm_state);
+
+	scoped_guard(rwsem_read, &cxl_rwsem.region)
+		rc = cxl_port_save_hdm_state(port, hdm_state);
+
+	if (!rc)
+		rc = xa_insert(&cxl_sbr_hdm_state, (unsigned long)dport_pci,
+			       hdm_state, GFP_KERNEL);
+	if (rc) {
+		cxl_port_put_hdm_state(hdm_state);
+		kfree(hdm_state);
+		return rc;
+	}
+
+	return 0;
+}
+
+/*
+ * Disable the regions routed through the Downstream Port being reset. On
+ * failure re-enable the regions already disabled and return the error so the
+ * PCI core aborts the reset with the topology unchanged.
+ */
+static int cxl_sbr_disable_regions(struct pci_dev *dport_pci)
+{
+	struct cxl_region *cxlr;
+	struct xarray regions;
+	unsigned long index;
+	int rc;
+
+	rc = cxl_sbr_save_hdm_state(dport_pci);
+	if (rc)
+		return rc;
+
+	xa_init(&regions);
+
+	rc = cxl_sbr_collect_regions(dport_pci, &regions);
+	if (rc)
+		goto out;
+
+	xa_for_each(&regions, index, cxlr) {
+		rc = cxl_region_disable(cxlr);
+		if (rc)
+			break;
+	}
+
+	/*
+	 * On failure restore every collected region and return the error so the
+	 * PCI core aborts the reset before touching the hardware. Re-enabling a
+	 * region left untouched is a no-op, so enabling the whole set also
+	 * recovers the region whose offline failed midway.
+	 */
+	if (rc) {
+		dev_dbg(&dport_pci->dev, "%s: disable failed (%d), re-enabling collected regions and aborting reset\n",
+			__func__, rc);
+		xa_for_each(&regions, index, cxlr)
+			cxl_region_enable(cxlr);
+	}
+
+out:
+	cxl_sbr_put_regions(&regions);
+	/* No enable_regions() call follows an aborted reset, so drop the set. */
+	if (rc)
+		cxl_sbr_drop_hdm_state(dport_pci);
+	return rc;
+}
+
+/*
+ * Re-enable the regions disabled by cxl_sbr_disable_regions(). Restore the HDM
+ * decode first: a region cannot serve memory through decoders that are not
+ * programmed, so its driver must not re-attach before they are.
+ */
+static void cxl_sbr_enable_regions(struct pci_dev *dport_pci)
+{
+	struct xarray *hdm_state;
+	struct cxl_region *cxlr;
+	struct xarray regions;
+	unsigned long index;
+
+	xa_init(&regions);
+
+	cxl_sbr_collect_regions(dport_pci, &regions);
+
+	hdm_state = xa_load(&cxl_sbr_hdm_state, (unsigned long)dport_pci);
+	if (hdm_state)
+		cxl_sbr_recommit_decoders(dport_pci, hdm_state);
+	else
+		pci_warn(dport_pci, "no saved HDM state, decode not restored\n");
+
+	xa_for_each(&regions, index, cxlr)
+		cxl_region_enable(cxlr);
+
+	cxl_sbr_put_regions(&regions);
+	cxl_sbr_drop_hdm_state(dport_pci);
+}
+
+const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops = {
+	.disable_regions = cxl_sbr_disable_regions,
+	.enable_regions = cxl_sbr_enable_regions,
+};
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index fc0bec991a69..d1dd4924fba1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/memory-tiers.h>
 #include <linux/string_choices.h>
+#include <linux/pci.h>
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
@@ -4263,12 +4264,14 @@ static struct cxl_driver cxl_region_driver = {
 
 int cxl_region_init(void)
 {
+	pci_cxl_set_sbr_region_ops(&cxl_sbr_region_ops);
 	return cxl_driver_register(&cxl_region_driver);
 }
 
 void cxl_region_exit(void)
 {
 	cxl_driver_unregister(&cxl_region_driver);
+	pci_cxl_set_sbr_region_ops(NULL);
 }
 
 MODULE_IMPORT_NS("CXL");
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77b17b13ee61..417b6b44473e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4844,6 +4844,19 @@ void __weak pcibios_reset_secondary_bus(struct pci_dev *dev)
 	pci_reset_secondary_bus(dev);
 }
 
+/*
+ * Registered by the CXL core to disable and re-enable the regions mapped
+ * through a CXL Downstream Port across a Secondary Bus Reset. NULL whenever
+ * the CXL region code is absent: not built, or built as a module not loaded.
+ */
+static const struct pci_cxl_sbr_region_ops *cxl_sbr_region_ops;
+
+void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops)
+{
+	cxl_sbr_region_ops = ops;
+}
+EXPORT_SYMBOL_GPL(pci_cxl_set_sbr_region_ops);
+
 /**
  * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
  * @dev: Bridge device
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 64b308b6e61c..2feb0e355305 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1606,6 +1606,18 @@ int devm_request_pci_bus_resources(struct device *dev,
 /* Temporary until new and working PCI SBR API in place */
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 
+/**
+ * struct pci_cxl_sbr_region_ops - CXL region callbacks for a bus reset
+ * @disable_regions: disable the regions below @dport, 0 or errno
+ * @enable_regions: re-enable the regions below @dport
+ */
+struct pci_cxl_sbr_region_ops {
+	int (*disable_regions)(struct pci_dev *dport);
+	void (*enable_regions)(struct pci_dev *dport);
+};
+
+void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops);
+
 #define __pci_bus_for_each_res0(bus, res, ...)				\
 	for (unsigned int __b = 0;					\
 	     (res = pci_bus_resource_n(bus, __b)) || __b < PCI_BRIDGE_RESOURCE_NUM; \
-- 
2.55.0


