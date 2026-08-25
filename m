Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB22C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03D16B00A7; Mon, 24 Aug 2026 22:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC396B00A9; Mon, 24 Aug 2026 22:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1746B00AA; Mon, 24 Aug 2026 22:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74DEB6B00A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B1B81C0A61
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:57 +0000 (UTC)
X-FDA: 85138206594.13.A4AAC79
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE4E21A0006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GP48R5NT;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qnSgN8ieQaK57/HpMwxcpo8p1qwX9bNA3TNfUlqUl0=;
	b=cBOAXr/K56Z5yHcSzehM0Hrh2DWs6+Rcopx5WKi9gHeKKb6gsagHvYSoXGcX816VLv/bhY
	bxPy/pHDF02sZtqH4MzBcZ7Nd05zL2wkIkZKLUWxswO5ecYu2nNIDIRxMmTa9oKYXuFJ1U
	xrBc1CrGcIxKjSzkNxk/0qsh2e5MiCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624875;
	b=6LFVhwKPlZFmumNJBdS3UhJgMOiyYwVaKPYZVIk21IIKwPdKExkKKO4SQAoYq6UqkLy82h
	XUOqakSK9cLcCk1KVfHA6S/8wPgPatUTkAB1TstM6TLLMQ+6b5x7jQkkI0MXRf3/5uQ8Wr
	xj3QnrZwKNwbSYd6L0+stje6IivGv/s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GP48R5NT;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624875; x=1819160875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vfx757PrKz0Q6r04Wq1LSBdOnlYkh38t0RKtlBGogL0=;
  b=GP48R5NT935X2G8NELAJonqhI6GsZMyJ1jj1mKYrCBrq8hqCukpru1sF
   WCPHzHyGGRMARfaH1bdf84NHWWuAi+RtWv/rc6l9Uxj0sZiZdvwFgfK+/
   op1c6hyDzllhTOGI7UFApJjoVgXPptb5lxxc1Nm2ncXBWlTDlUBdmJY8n
   v6dDHWgCJptlZLdal1dIa8fdfO2sOs6biej1ZOl7/tQZ8GJv2wpOfbAUM
   S/xx6B/DOX4VPa+ci/i0GXHmRfq14dgXxX9PITkeadxFAh1C3K/zWUWPe
   IOGjOY2DVDhD7RpS7aDIhHwLgx9fLLFYsbodW5BcbaM9w7Mh6vXfDuir5
   g==;
X-CSE-ConnectionGUID: XYqxyBfgSy6kRQPksdCkNA==
X-CSE-MsgGUID: RYzWLGfESyCzXYkAIM2gUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761180"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761180"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:54 -0700
X-CSE-ConnectionGUID: 01Xxo1LWT+6/FYg9bL0TTQ==
X-CSE-MsgGUID: EBvx3coUR5Sy8yZZqadSUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390114"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:47 -0700
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
Subject: [PATCH v2 10/13] PCI/CXL: Clear ACS SV across an SBR of a CXL DPort
Date: Tue, 25 Aug 2026 04:26:25 +0200
Message-ID: <20260825022628.3651434-11-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qiwufjjjjqbkzkx4f5eknk4s9pcxzm7x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE4E21A0006
X-HE-Tag: 1787624874-666506
X-HE-Meta: U2FsdGVkX18i6MZkQM/Rz99kdRXXzc5Bnw35URb5FnNynF2+PpE1RV3AaJmJixv6vQXbAw+qnOolOhGWRMpFAc2byhC/HOC66GCuBU4Gqdhz2DsRvJ2T6Rr7F18NbeUivc/q+NjIa46pedm1r8hJmJXwd+jMT2xo/JL8C1SXshIOa8Ay74FrhICO8K+wyzi/tx6B9PC/kakOdh44l1ahYVH23bvrpVZdlZFMEFvrl694NvC9eaChSW6hRH1B6ryEdf75b5OJJeqRgN8tPubilzF/WT4j7OY2v7rMhgZdx692/UkLtATLzUZudvxSljKSN+JIjF+mxeY8DDC5cW12xi91nep1hyk1CKE3LmMlZcKonpaGJLk2L8RA477x/rq+VT4Gfn+KFOKtP5Qe3F8d7l3L6QUnAm9U0DeY6A/BeTY/OTTuzrnh4KznD1d7NWSkhqQqqkSbir9S95T/MJKXG3shtseo3++VxLPHeIz9g2vpkjRe7KLh5/I122HrKWnW8aemGEXVN0JfOIo34eAqF+sbAypLAF7neqDVbZBgPiqUg0Z0dazlZ+qlL9BAItPtOOaw8opILIFMFI6fJ2VKDOIm1KwFta22IBATomYJJ819NUeQrDmZRajPtfU245a6/tkYW9NLCtafUl+Vd0meXE3WcIEw5onnLk0BYdoRZSSNXmnr2ujG9fTyVF+4ZD1CyDyVCOg8tVRoW/s7tJXtkCKuZZ+u4FOsC4FCIhxdIaN2T63lIeuOwWMXi6B8K1RCkSF/GJlAnsz18MFxrhvQmZj2lDpjUamkbJZqytBdH+7FF5j/tcKNeGlxrEkQmb73EBCwduheFu1k0uTEVzyngUplS1Vq8ykOj+VNEs6sX9cFfnMbRoXZ90YkrGaDcBqo9UbNR4i2O9AS/iknp45bBuCO9RhGQgkJUCiTaIVLKteZ/6zgSjgigC+Ddxq87UMsd+czBCdt1ZzeQXLLqwF
 pxOIZx5M
 OAXmB3W2+I19Zw1ObIhu64BAFaWUNefVdYh9NfPltar7tRK3kdB5eiohkkGY/7qfrHK9TWs9uuKwVDuUIj7tuigZ8wf0Ek1hxAC5AwKHB09BnsxJRTkcYLk/wwnisTyBYnHUOpw8bMrttiY4haT58oaU707gtSG+JluPwLz1URjxJgtI7R+DOZVzNkD3Vlwv5Rn6nZLU8PcaG7Ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset (SBR) of a CXL Downstream Port clears the
Downstream Component's (DPort) captured Bus Number. CXL r4.0 sec 8.1.5.1
notes that if a Downstream Component issues PM Init messages to a DPort
with Access Control Services (ACS) Source Validation (SV) bit enabled,
PM Initialization may then fail to complete, and that a further SBR
alone does not recover it. PCIe r7.0 sec 6.12.1.1 makes that rejection
an error that is a reported as ACS Violation.

Reuse the recovery sequence described in sec 8.1.5.1 but make it
preventive, so that PM Init don't fail and don't need to be recovered.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/pci/pci.c             | 177 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/pci_regs.h |   2 +
 2 files changed, 172 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 417b6b44473e..f3781d1e8f6e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/logic_pio.h>
 #include <linux/device.h>
@@ -4857,21 +4858,189 @@ void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops)
 }
 EXPORT_SYMBOL_GPL(pci_cxl_set_sbr_region_ops);
 
+struct cxl_sbr_ctx {
+	u16 port_ctl;
+	u16 acs_ctrl;
+	u16 command;
+};
+
+static bool is_cxl_dport(struct pci_dev *dev)
+{
+	return pcie_is_cxl(dev) && pcie_downstream_port(dev);
+}
+
+static u16 cxl_port_dvsec(struct pci_dev *dev)
+{
+	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
+					 PCI_DVSEC_CXL_PORT);
+}
+
+static int cxl_sbr_prepare(struct pci_dev *bridge, u16 dvsec,
+			   struct cxl_sbr_ctx *ctx)
+{
+	int rc;
+
+	/* Abort before touching hardware if the regions cannot be disabled. */
+	if (cxl_sbr_region_ops) {
+		rc = cxl_sbr_region_ops->disable_regions(bridge);
+		if (rc)
+			return rc;
+	}
+
+	/* CXL r4.0 sec 8.1.5.2, Table 8-32: set Unmask SBR so the Port issues Hot Reset. */
+	pci_read_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL, &ctx->port_ctl);
+	pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
+			      ctx->port_ctl | PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR);
+
+	pci_read_config_word(bridge, PCI_COMMAND, &ctx->command);
+	pci_clear_master(bridge);
+
+	/* CXL r4.0 sec 8.1.5.1: Disable ACS SV bit before SBR */
+	if (bridge->acs_cap) {
+		pci_read_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL, &ctx->acs_ctrl);
+		pci_dbg(bridge, "%s: ACS SV %s\n", __func__,
+			str_enabled_disabled(ctx->acs_ctrl & PCI_ACS_SV));
+		pci_write_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL,
+				      ctx->acs_ctrl & ~PCI_ACS_SV);
+	}
+
+	return 0;
+}
+
+/*
+ * CXL r4.0 sec 8.1.5.1, Table 8-31: the Port sets PM Init Complete within
+ * 100 ms of link-up. Restoring ACS Source Validation before then makes the
+ * Port reject the downstream Component's Requester-Bus-0 IP2PM message, so
+ * poll for completion before restoring config.
+ */
+static bool cxl_port_pm_init_is_complete(struct pci_dev *bridge, u16 dvsec)
+{
+	unsigned long start = jiffies;
+	unsigned long timeout = start + msecs_to_jiffies(100);
+	u16 status;
+
+	do {
+		pci_read_config_word(bridge,
+				     dvsec + PCI_DVSEC_CXL_PORT_EXT_STATUS,
+				     &status);
+		if (!PCI_POSSIBLE_ERROR(status) &&
+		    (status & PCI_DVSEC_CXL_PORT_EXT_STATUS_PM_INIT_COMP)) {
+			pci_dbg(bridge, "%s: PM Init Complete set after %u ms, ext status %#06x\n",
+				__func__, jiffies_to_msecs(jiffies - start), status);
+			return true;
+		}
+		msleep(10);
+	} while (time_before(jiffies, timeout));
+
+	pci_warn(bridge, "%s: PM Init Complete not set after %u ms, ext status %#06x\n",
+		 __func__, jiffies_to_msecs(jiffies - start), status);
+
+	return false;
+}
+
+static int cxl_sbr_restore_config_space(struct pci_dev *dev, void *userdata)
+{
+	pci_restore_config_space(dev);
+	pci_dbg(dev, "%s: config space restored\n", __func__);
+
+	return 0;
+}
+
+/*
+ * The CXL region ops that run next read the HDM Decoders through a Base Address
+ * Register the reset returned to its initialization value, so restore the
+ * header of every device below @bridge first. Restoring also re-captures each
+ * Bus Number before the Port's ACS Source Validation comes back: a device that
+ * has completed no Type 0 Configuration Write since the reset sources Requests
+ * with Bus 0, which the Port rejects as an ACS Violation.
+ *
+ * Only the header is restored. The capability state each caller saved is its own
+ * to replay, and the ->reset_done() callbacks pci_dev_restore() invokes must
+ * fire once, from the caller that owns the reset.
+ */
+static void cxl_sbr_restore_subordinate(struct pci_dev *bridge)
+{
+	if (!bridge->subordinate)
+		return;
+
+	/* Parents before children: a child answers once its parent forwards. */
+	pci_walk_bus(bridge->subordinate, cxl_sbr_restore_config_space, NULL);
+}
+
+static void cxl_sbr_complete(struct pci_dev *bridge, u16 dvsec,
+			     const struct cxl_sbr_ctx *ctx)
+{
+	u16 val;
+
+	/* CXL r4.0 sec 8.1.5.1: wait for PM Init before restoring ACS SV. */
+	if (!cxl_port_pm_init_is_complete(bridge, dvsec))
+		pci_warn(bridge,
+			 "restoring ACS Source Validation before PM Init complete; Port may reject the Component's bus 0 traffic\n");
+
+	cxl_sbr_restore_subordinate(bridge);
+
+	/* CXL r4.0 sec 8.1.5.1: Re-enable ACS SV bit after SBR if it was enabled before */
+	if (bridge->acs_cap && (ctx->acs_ctrl & PCI_ACS_SV)) {
+		pci_read_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL, &val);
+		pci_write_config_word(bridge, bridge->acs_cap + PCI_ACS_CTRL,
+				      val | PCI_ACS_SV);
+		pci_dbg(bridge, "%s: ACS SV bit set\n", __func__);
+	} else {
+		pci_dbg(bridge, "%s: ACS SV bit not set (was not enabled before the SBR)\n",
+			__func__);
+	}
+
+	if (ctx->command & PCI_COMMAND_MASTER)
+		pci_set_master(bridge);
+
+	if (!(ctx->port_ctl & PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR)) {
+		pci_read_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL, &val);
+		pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
+				      val & ~PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR);
+	}
+
+	if (cxl_sbr_region_ops)
+		cxl_sbr_region_ops->enable_regions(bridge);
+}
+
 /**
  * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
  * @dev: Bridge device
  *
  * Use the bridge control register to assert reset on the secondary bus.
  * Devices on the secondary bus are left in power-on state.
+ *
+ * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
+ * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
+ * so that Port Power Management Initialization completes at link-up. The
+ * bits stay cleared until the secondary bus is back, then are restored.
  */
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 {
+	struct cxl_sbr_ctx ctx = {};
+	u16 dvsec = 0;
+	int rc;
+
 	if (!dev->block_cfg_access)
 		pci_warn_once(dev, "unlocked secondary bus reset via: %pS\n",
 			      __builtin_return_address(0));
+
+	if (is_cxl_dport(dev))
+		dvsec = cxl_port_dvsec(dev);
+	if (dvsec) {
+		rc = cxl_sbr_prepare(dev, dvsec, &ctx);
+		if (rc)
+			return rc;
+	}
+
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_bridge_wait_for_secondary_bus(dev, "bus reset");
+	rc = pci_bridge_wait_for_secondary_bus(dev, "bus reset");
+
+	if (dvsec)
+		cxl_sbr_complete(dev, dvsec, &ctx);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
@@ -4917,12 +5086,6 @@ static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
 	return pci_reset_hotplug_slot(dev->slot->hotplug, probe);
 }
 
-static u16 cxl_port_dvsec(struct pci_dev *dev)
-{
-	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
-					 PCI_DVSEC_CXL_PORT);
-}
-
 static bool cxl_sbr_masked(struct pci_dev *dev)
 {
 	u16 dvsec, reg;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index facaa324bd86..0eaa34db93ce 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1371,6 +1371,8 @@
 
 /* CXL r4.0, 8.1.5: Extensions DVSEC for Ports */
 #define PCI_DVSEC_CXL_PORT				3
+#define  PCI_DVSEC_CXL_PORT_EXT_STATUS			0x0a
+#define   PCI_DVSEC_CXL_PORT_EXT_STATUS_PM_INIT_COMP	0x00000001
 #define  PCI_DVSEC_CXL_PORT_CTL				0x0c
 #define   PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
 
-- 
2.55.0


