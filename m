Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E039EC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C536B00A9; Mon, 24 Aug 2026 22:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D9C6B00AA; Mon, 24 Aug 2026 22:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84CF6B00AB; Mon, 24 Aug 2026 22:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC2856B00A9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:28:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 611BAA029F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:04 +0000 (UTC)
X-FDA: 85138206888.28.CAE5098
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CF211A0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QdzY5BHv;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05Ed6q5NEEJ4G20xSHNOhijKox9Q69Rn2iIQYJ+Nw2A=;
	b=gRKnCQNVJ5ScbfF49aZztSgIHi/loWuSZM24iNfkjewbWjkfRri+srTecCGyhFB7IrWIlz
	5xlFCK3+MXrhYOetxr0EGrdxN+YVk/TO+muW+YPtCEPe34TCrTNPXARlFH0dkv/umTWeg2
	TVlQ0kt6ql4pGPwN2GWOU7wryWbB6mQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624882;
	b=al4zWnOFO4CXRSCbzvukV62bE0TbbPhkqoFiIIvDkoSnVkzbHKW7TJ6W1YGQWy3vuGHayV
	MeL9BMS6WJakb/Ydl5CitAQkre2AiQ2qeUKloRwRqy6Ti+KEa5B2fZhV0mrrktf5JFmJMk
	6SnoUOeZECe5VUP2HEU0vXMjaOk6SzE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QdzY5BHv;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624882; x=1819160882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lLAmS+6fx1hM9aMTHu0jgGA0tViKEKeCH7C1d/uKsLI=;
  b=QdzY5BHvkcr9IVaxz220VLzmwIigzxgrhFr8PdZmb7UBIx4k9SSWpiUF
   xN5eMOAwvCJBRjZOF4R7L4wNk/ulKekPDuHToIKE4FLoYuNPYTkHVHHiK
   JVi4Tuqrc0zwME2YrlW1ORmOrJ7od71YyslzwuoSOTktt25q4JGE86ptg
   oInjWNJ7izARffFXvnQ7RU6p+vr4XOVc9Ale+BTtlB5bfSwh5EmuIyMxp
   XIrqkZ/cP8JSQTLCaD3PHbJccq8MqD4n3L4q0UkmJXRKQPpZPc/b9g/Pr
   vnTblt733T1YbnTIpGASoU3hAHR4j+MOX4rlU2R5naKlrlQkx7lBCKU3/
   g==;
X-CSE-ConnectionGUID: L64JwOzfRe+KFUNkIkNF9w==
X-CSE-MsgGUID: yiI/ggUmRa6dkAfapsQcUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761213"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761213"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:28:01 -0700
X-CSE-ConnectionGUID: 7kvMfD87SW+PktZoskkogA==
X-CSE-MsgGUID: T0wshLSRTB+ulYRvr8Pn5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390121"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:54 -0700
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
Subject: [PATCH v2 11/13] PCI/DPC: Unbind regions for DPC recovery
Date: Tue, 25 Aug 2026 04:26:26 +0200
Message-ID: <20260825022628.3651434-12-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gddm56d1noa9gip3o7kbpb5z3wowm76a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CF211A0005
X-HE-Tag: 1787624881-36135
X-HE-Meta: U2FsdGVkX191mGmbPv3eLMZLclm/elpulYRx3voR3wQ/QNAYycrlEfBG7ZRvViXlUyy2CKLF0cgdLm6ZDI2UjqmTAgCSWs7hgCknSznIkluLqZF2DHhvrf5MGrtc/lUzsnsmdEeE9srEAgcWOdcl1acHklzyUBRZ9b7+HRxrFUcWlD7phZHcGJwJ7h2/Bdvzri8JwI6d9bdtGjzbXr4MU5KCzC4HMTP4XiGsoz2sTFK/8KQh6hiV/l7OZlk2AEIKwMgM5d/Fs4mOV9LmyOl+dZJAm90ynszfMS1mwSDrMYZ2uYeWpbphjvydF08qVIoLG6MeBvD0Eg4BMBkuJnHNT8skVXZcdg/8u+SEDTfzqeB0Mh3JnfjygZ0DeKIEdvUGGY459rwbYaLDJ5mw9Fou0cHmM3cWPpiuU5ls3WAZfGHJcJQgPgYqOVM+HWt8jY0PaVWLSZW7W6FngSgJJu+vqrXy/kd3DDZ9VaGWDt80uDhuAftvOJg1oE5DQ+a6UUIPpPGwLn5kgi8n6iAljACoOn1Ji7selzLa1OOHyvFZxZKZlE/kOZAi+SS+5RQYt59f5c7rZRgNMrc8EyPCjI/CKIFjhhTlNIQeuPcPN0tPq73ZpJ6VTVoRqsWS6z2Ag5XOeauO1SQaOHfM0b2WTQtir3/MOtsuIuCy2JabuX4HjkP8iO1xjjuWnEustiiHNjtnBGCHydNj8yJbPB68bkfGpDKElK73bk1JCrnCozvPH9tHM+zK6efkxeMK19yCJqcr9rqDUnt1nPTUwA90UxclOU+VmA/naSvlPDPFUy+haN7Mob5HBRIf7Ryc0kFztGVmYv1ujub2fv3OLTgk569B82xnQv5+Z1V+VCA9ysAIa0KN9rrbSAwrwpXJDTLCzdEMDUqjEaqBNqw3mRroW+bikt1KR+RdwicM8kD3LjnKFtAAFKMBNsF5oe9itjqVnf/cxszvcaAPaCdboQb30MI
 Q7XAbPy7
 bDAQSL1PlQQMlLlWzIXfwlN1Xjke2jQH5SrHx0gXMdsFOLTS4hRYLar17LhhO2zv7G2QSDtUo2/pccv/t0THooM6ZYyj22HUKdpjpVxmTfPSqVcW1gzcZ/iJPmMUHPszVV5CaJHzguxToGxhVq4J6Zwofhbasu5vNv7/gktD9ru1uADO8Mge2LE4Sxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CXL r4.0 sec 8.1.5.1 lists Downstream Port Containment among the
conditions that reset the Downstream Component's bus number. DPC
recovery needs to wait for the link to come back up, but if Access
Control Services Source Validation bit is enables PM Initialization will
fail to complete. 

Have dpc_reset_link() reset the secondary bus of a CXL Downstream Port.
Split pci_bridge_secondary_bus_reset() so the reset takes an action
saying what to do with the CXL regions routed through the Port, and pass
the action that unbinds them without offlining their memory. Offlining
migrates the memory that the memdev back and on a contained link are not
addressable.  Don't release the memdev driver in cxl_error_detected(). 

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/dport_sbr.c | 57 ++++++++++++++++++++++++++++++++-
 drivers/cxl/core/ras.c       | 10 ++++++
 drivers/pci/pci.c            | 62 ++++++++++++++++++++++++++----------
 drivers/pci/pci.h            | 15 +++++++++
 drivers/pci/pcie/dpc.c       | 46 +++++++++++++++++++++++++-
 include/linux/aer.h          |  9 ++++++
 include/linux/pci.h          |  3 ++
 7 files changed, 183 insertions(+), 19 deletions(-)

diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
index 2b6f840e22a7..823b63012f45 100644
--- a/drivers/cxl/core/dport_sbr.c
+++ b/drivers/cxl/core/dport_sbr.c
@@ -9,6 +9,30 @@
 #include <cxl.h>
 #include "core.h"
 
+/*
+ * cxl_region_unbind - take a region out of service ahead of a reset
+ * @cxlr: region routed through the CXL Downstream Port being reset
+ *
+ * Unbind the region driver, which tears down everything built on the region:
+ * the dax region device, its dax device and the driver bound to it. An SBR
+ * zeroes the downstream bus number, so a region left bound would decode to a
+ * device in reset.
+ *
+ * The memory the region hosts is left as it is. A caller that reaches a live
+ * device offlines it first; see cxl_region_disable().
+ *
+ * Context: process context. Driver unbind sleeps, so this cannot run in atomic
+ * context.
+ */
+static void cxl_region_unbind(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+
+	device_release_driver(&cxlr->dev);
+	dev_dbg(&cxlr->dev, "%s: region unbound before reset, HPA %pr\n",
+		__func__, p->res);
+}
+
 /*
  * cxl_region_disable - make a region inactive ahead of a Secondary Bus Reset
  * @cxlr: region routed through the CXL Downstream Port being reset
@@ -58,7 +82,7 @@ static int cxl_region_disable(struct cxl_region *cxlr)
 		return rc;
 	}
 
-	device_release_driver(&cxlr->dev);
+	cxl_region_unbind(cxlr);
 	dev_dbg(&cxlr->dev, "%s: System RAM offline, region disabled before reset, HPA %pr\n",
 		__func__, p->res);
 
@@ -284,6 +308,36 @@ static int cxl_sbr_disable_regions(struct pci_dev *dport_pci)
 	return rc;
 }
 
+/*
+ * Unbind the regions routed through the Downstream Port being reset, leaving
+ * their memory online. Used on the DPC recovery path, where dpc_reset_link()
+ * clears DPC Trigger Status and enters the reset without waiting for the link,
+ * so the device may still be unreachable and the page migration that an offline
+ * performs would have no device to read from.
+ *
+ * Unbinding cannot fail, so unlike cxl_sbr_disable_regions() this never aborts
+ * the reset. The memory stays online across the reset with no region decoding
+ * it; cxl_sbr_enable_regions() reprograms the decoders on the way out.
+ */
+static void cxl_sbr_unbind_regions(struct pci_dev *dport_pci)
+{
+	struct cxl_region *cxlr;
+	struct xarray regions;
+	unsigned long index;
+
+	if (cxl_sbr_save_hdm_state(dport_pci))
+		pci_warn(dport_pci, "HDM state not saved, decode will not be restored\n");
+
+	xa_init(&regions);
+
+	cxl_sbr_collect_regions(dport_pci, &regions);
+
+	xa_for_each(&regions, index, cxlr)
+		cxl_region_unbind(cxlr);
+
+	cxl_sbr_put_regions(&regions);
+}
+
 /*
  * Re-enable the regions disabled by cxl_sbr_disable_regions(). Restore the HDM
  * decode first: a region cannot serve memory through decoders that are not
@@ -315,5 +369,6 @@ static void cxl_sbr_enable_regions(struct pci_dev *dport_pci)
 
 const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops = {
 	.disable_regions = cxl_sbr_disable_regions,
+	.unbind_regions = cxl_sbr_unbind_regions,
 	.enable_regions = cxl_sbr_enable_regions,
 };
diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index 99fb00949c2f..568a906f3b50 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -323,6 +323,16 @@ pci_ers_result_t cxl_error_detected(struct pci_dev *pdev,
 		}
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
+		/*
+		 * A Port on the path in DPC means dpc_reset_link() is about to
+		 * reset the link, and that path takes the CXL regions out of
+		 * service and restores the HDM decode itself. Keep the memdev
+		 * driver bound so the endpoint and its decoders are still there
+		 * to restore.
+		 */
+		if (pci_dpc_containment_active(pdev))
+			return PCI_ERS_RESULT_NEED_RESET;
+
 		dev_warn(&pdev->dev,
 			 "%s: frozen state error detected, disable CXL.mem\n",
 			 dev_name(dev));
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f3781d1e8f6e..eedd516f8484 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4864,24 +4864,37 @@ struct cxl_sbr_ctx {
 	u16 command;
 };
 
-static bool is_cxl_dport(struct pci_dev *dev)
+bool is_cxl_dport(struct pci_dev *dev)
 {
 	return pcie_is_cxl(dev) && pcie_downstream_port(dev);
 }
 
-static u16 cxl_port_dvsec(struct pci_dev *dev)
+u16 cxl_port_dvsec(struct pci_dev *dev)
 {
 	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
 					 PCI_DVSEC_CXL_PORT);
 }
 
 static int cxl_sbr_prepare(struct pci_dev *bridge, u16 dvsec,
-			   struct cxl_sbr_ctx *ctx)
+			   struct cxl_sbr_ctx *ctx,
+			   enum cxl_sbr_region_action action)
 {
 	int rc;
 
-	/* Abort before touching hardware if the regions cannot be disabled. */
-	if (cxl_sbr_region_ops) {
+	/*
+	 * CXL_SBR_UNBIND: the link is already down, so offlining the regions'
+	 * memory would take the reads that page migration performs as a machine
+	 * check. Per PCIe r7.0 sec 2.9.3 the Port answers a Non-Posted Request
+	 * with an Unsupported Request or Completer Abort completion while it is
+	 * in DPC. Unbinding never fails, so the reset always goes ahead.
+	 *
+	 * CXL_SBR_OFFLINE_AND_UNBIND: the device is reachable, so offline the
+	 * memory first and abort the reset before touching hardware if that
+	 * fails.
+	 */
+	if (cxl_sbr_region_ops && action == CXL_SBR_UNBIND) {
+		cxl_sbr_region_ops->unbind_regions(bridge);
+	} else if (cxl_sbr_region_ops) {
 		rc = cxl_sbr_region_ops->disable_regions(bridge);
 		if (rc)
 			return rc;
@@ -5003,19 +5016,17 @@ static void cxl_sbr_complete(struct pci_dev *bridge, u16 dvsec,
 		cxl_sbr_region_ops->enable_regions(bridge);
 }
 
-/**
- * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
- * @dev: Bridge device
- *
- * Use the bridge control register to assert reset on the secondary bus.
- * Devices on the secondary bus are left in power-on state.
+/*
+ * __pci_bridge_secondary_bus_reset - assert Secondary Bus Reset on a bridge
+ * @dev: bridge device
+ * @action: what to do with the CXL regions reached through @dev
  *
- * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
- * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
- * so that Port Power Management Initialization completes at link-up. The
- * bits stay cleared until the secondary bus is back, then are restored.
+ * See pci_bridge_secondary_bus_reset(). Pass CXL_SBR_UNBIND when the link is
+ * already down, which leaves the regions' memory online because offlining it
+ * needs a reachable device.
  */
-int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
+int __pci_bridge_secondary_bus_reset(struct pci_dev *dev,
+				     enum cxl_sbr_region_action action)
 {
 	struct cxl_sbr_ctx ctx = {};
 	u16 dvsec = 0;
@@ -5028,7 +5039,7 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 	if (is_cxl_dport(dev))
 		dvsec = cxl_port_dvsec(dev);
 	if (dvsec) {
-		rc = cxl_sbr_prepare(dev, dvsec, &ctx);
+		rc = cxl_sbr_prepare(dev, dvsec, &ctx, action);
 		if (rc)
 			return rc;
 	}
@@ -5042,6 +5053,23 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 
 	return rc;
 }
+
+/**
+ * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
+ * @dev: Bridge device
+ *
+ * Use the bridge control register to assert reset on the secondary bus.
+ * Devices on the secondary bus are left in power-on state.
+ *
+ * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
+ * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
+ * so that Port Power Management Initialization completes at link-up. The
+ * bits stay cleared until the secondary bus is back, then are restored.
+ */
+int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
+{
+	return __pci_bridge_secondary_bus_reset(dev, CXL_SBR_OFFLINE_AND_UNBIND);
+}
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
 static int pci_parent_bus_reset(struct pci_dev *dev, bool probe)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c..b6d873b077ed 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -233,6 +233,21 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vmai,
 bool pci_reset_supported(struct pci_dev *dev);
 void pci_init_reset_methods(struct pci_dev *dev);
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
+
+/*
+ * What to do with the CXL regions reached through a Downstream Port before it
+ * is reset. Offlining their memory needs a reachable device, so a Port whose
+ * link is already down only unbinds and leaves the memory online.
+ */
+enum cxl_sbr_region_action {
+	CXL_SBR_OFFLINE_AND_UNBIND,
+	CXL_SBR_UNBIND,
+};
+
+int __pci_bridge_secondary_bus_reset(struct pci_dev *dev,
+				     enum cxl_sbr_region_action action);
+bool is_cxl_dport(struct pci_dev *dev);
+u16 cxl_port_dvsec(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
 int pci_try_reset_bridge(struct pci_dev *bridge);
 
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index 2b779bd1d861..ad74086bf82c 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -127,6 +127,44 @@ bool pci_dpc_recovered(struct pci_dev *pdev)
 }
 #endif /* CONFIG_HOTPLUG_PCI_PCIE */
 
+/**
+ * pci_dpc_containment_active - whether a Port above @pdev is contained by DPC
+ * @pdev: PCI device below the Port
+ *
+ * Per PCIe r7.0 sec 2.9.3 the Port's LTSSM stays in the Disabled state while
+ * DPC Trigger Status is set, and dpc_reset_link() clears that bit only after
+ * pcie_do_recovery() has broadcast error_detected. A ->error_detected()
+ * callback can therefore use this to tell a DPC containment from any other
+ * frozen-channel error, and to know that the link is about to be reset.
+ *
+ * The Port that triggered is on the path to @pdev, because the broadcast walks
+ * that Port's subordinate bus, so test every bridge above @pdev.
+ *
+ * Return: true if a Port on the path to @pdev has DPC Trigger Status set.
+ */
+bool pci_dpc_containment_active(struct pci_dev *pdev)
+{
+	struct pci_dev *bridge;
+
+	for (bridge = pci_upstream_bridge(pdev); bridge;
+	     bridge = pci_upstream_bridge(bridge)) {
+		u16 status;
+
+		if (!bridge->dpc_cap)
+			continue;
+
+		pci_read_config_word(bridge,
+				     bridge->dpc_cap + PCI_EXP_DPC_STATUS,
+				     &status);
+		if (!PCI_POSSIBLE_ERROR(status) &&
+		    (status & PCI_EXP_DPC_STATUS_TRIGGER))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(pci_dpc_containment_active);
+
 static int dpc_wait_rp_inactive(struct pci_dev *pdev)
 {
 	unsigned long timeout = jiffies + HZ;
@@ -149,6 +187,7 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 {
 	pci_ers_result_t ret;
 	u16 cap;
+	int rc;
 
 	set_bit(PCI_DPC_RECOVERING, &pdev->priv_flags);
 
@@ -174,7 +213,12 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC")) {
+	if (is_cxl_dport(pdev) && cxl_port_dvsec(pdev))
+		rc = __pci_bridge_secondary_bus_reset(pdev, CXL_SBR_UNBIND);
+	else
+		rc = pci_bridge_wait_for_secondary_bus(pdev, "DPC");
+
+	if (rc) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {
diff --git a/include/linux/aer.h b/include/linux/aer.h
index df0f5c382286..7ac029f01c25 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -66,6 +66,15 @@ static inline int pcie_aer_is_native(struct pci_dev *dev) { return 0; }
 static inline void pci_aer_unmask_internal_errors(struct pci_dev *dev) { }
 #endif
 
+#if defined(CONFIG_PCIE_DPC)
+bool pci_dpc_containment_active(struct pci_dev *pdev);
+#else
+static inline bool pci_dpc_containment_active(struct pci_dev *pdev)
+{
+	return false;
+}
+#endif
+
 void pci_print_aer(struct pci_dev *dev, int aer_severity,
 		    struct aer_capability_regs *aer);
 int cper_severity_to_aer(int cper_severity);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2feb0e355305..0d9832ce6f3d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1609,10 +1609,13 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 /**
  * struct pci_cxl_sbr_region_ops - CXL region callbacks for a bus reset
  * @disable_regions: disable the regions below @dport, 0 or errno
+ * @unbind_regions: unbind the drivers of the regions below @dport, leaving
+ *		    their memory online, for a link already contained
  * @enable_regions: re-enable the regions below @dport
  */
 struct pci_cxl_sbr_region_ops {
 	int (*disable_regions)(struct pci_dev *dport);
+	void (*unbind_regions)(struct pci_dev *dport);
 	void (*enable_regions)(struct pci_dev *dport);
 };
 
-- 
2.55.0


