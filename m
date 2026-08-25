Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53DFC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2176B00AC; Mon, 24 Aug 2026 22:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63456B00AD; Mon, 24 Aug 2026 22:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78DF6B00AE; Mon, 24 Aug 2026 22:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9226B00AC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:28:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BAC51A01D8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:19 +0000 (UTC)
X-FDA: 85138207518.15.C6E5545
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBCAC80003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EcsPSqjd;
	spf=pass (imf02.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624897;
	b=odvvu0ynM1hVMELZIYqEW1dxcjiEVkzam94d6wi574hLf4W79vdOjWDr6vST0YoQ3FdJ2u
	xRnKCzwezQbcnmsZQd/SdmHdzg/25RhJxujzHre8+3P+1ZM2ljq79s7+rObWRUOjMvRg0u
	S9SQP0wbyTfHMgF1at+L8K+3HnI33e8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EcsPSqjd;
	spf=pass (imf02.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFoGkw61yrTpvSi9Hrtm/h8z3f6hMLs6W1Ix5GODQJU=;
	b=7lJbqdq8PdBCsRmOCWfG9TPv3kSrJ0wNqFsob1Hb1S45BTH3xw41iTHXWfcSJlCBjSTLoC
	oVktK7miVNbIDMF6zYksUZkt6TuBW97Rnuway2EhBNb68G+d2lFY6r+Ykxh6lKJyne6eBr
	VhdYBtdlMQ4UDYVngTjZcHFhscmr1g4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624897; x=1819160897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p35ooKxDDEqYJs00+ywe+gwGYag0qhbr8UgYGTT8yA4=;
  b=EcsPSqjdcQzMIwzL8QuxbfHx6N9Ii29yYHQlqe1aQ19Ls0pDnqSIm2Yo
   ptVwERD7ScE0GRAxoeAJ1cYSqCv5Rz1w2a3qXOUdnxLqrN6aSdJisFn48
   fog6XSIZbjTrB2s4ojmdjZtmb4jPF4fUSNWNvDwnSs9eJN17JpWX7yeJj
   p19dJsfi85IPHOjqZlsgwko5J13G793JR+28OCRqh6Kb5Nd9P5i5UyRBm
   FRjXsDeCpB65FzDgWo/y0HxzpbE8v84TI4cwWfcjmH1XfRoEUBnqTMfnz
   6EkWAfnTlhQVHxXErLfHZOujR/U8ynKlwCMi1OSzVTMhVxcq2ZHfLPV/w
   g==;
X-CSE-ConnectionGUID: IxYRYC0DSSKkGJI9FmuK4Q==
X-CSE-MsgGUID: 4+EOrZX6QJG7OdFNvYofzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761238"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761238"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:28:16 -0700
X-CSE-ConnectionGUID: KQlGpQmQRWef0MiKW/Zq2g==
X-CSE-MsgGUID: n6NeHPHmT6KWhioKt0tOhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390156"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:28:09 -0700
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
Subject: [PATCH v2 13/13] PCI/CXL: Refuse an SBR of a CXL DPort unless authorized
Date: Tue, 25 Aug 2026 04:26:28 +0200
Message-ID: <20260825022628.3651434-14-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBCAC80003
X-Stat-Signature: suptxuq8655hd4ony9tchma93n3krcio
X-HE-Tag: 1787624896-52284
X-HE-Meta: U2FsdGVkX18bpSLqWIv/Ew5Tfzg1QesQX+qaj2cQbqvM3r2xjPOu4FJkXOkGe9Jwcro90CZjl5u85UL9QQ8uSwvAPYvWj10UUTCwV4xv2ZEw8tm28Pu7z4OhKxAJdD2PGBnhaPKHbp0UvS/uICJwn0Lrzxh6P/dsZtjcmI7iFdHCvCIfnyqngVK9w+9IBggCpF2Y+1fijrMJCO1+SCbTdocv+m+nyD7ejIZ0EjXzo/tb3JP0TVUm04KmrlyR727RULR12gYd7cLAZCMycehAU1jZs2keSERiE4aVl/XFFdOKX3eAjbgGpjVzcR7JrSjqiun9XMdSRga/YBYhJ8WoENvatUEO504xsU5TWPAgLG7uVb4c0Gch46AtL/c0MnZSTDCFBKrQKgMQW8zJiEoxNy3ZiSdtpXldw4YSt0E89GKGfytW0y89pC2Tv/ZQM8lx1TeOVSuoKcVURNi5ZlDU077GkQ5jFKCz9s1bvn21EgIw1DYJKQziQ/h96NZDQmTtYIB9v6GoZkZb+K7ElSE16QqcpTVBfla3kQI6U2R9LRq8Skv33JX86UaqueXlC0Vh3m12pA1/pGFJZ+cKUQPksIDMl07JWOb74o25nTkWz8r/MJl2SyLqxZqQqPMP7Hot2KPgyXo0WFJhrcDtuILGYd/QjMvBDnamF/jBtMyzwPoV2dkOr89kKpzfL0uRMzgG5KapDuiTtIaSNu+CAA0TJEZX/uDq3Ji0AV+fBJ9kyiU9LjvyKsNERmKl9nGJ6286fmoeamleW5aQl3oNv1bl7YsksOhfXulLIrPUvndy7ugBlfkkLOaZCaZd6omjLEvVeWugsSQx2CxxBBLcFybKoWk5OVGlY7K0CSQLSh4p9NecE/9JEM/sijUSzqBwVO2d95AoEWkxlJyGPzsCpqAThPlPUQGbuQyJJtfR/C82vqaRrwCljz2ZYfjoUmkngctIPJhSblrZ2Jo3GHSKcCp
 4EK+oozN
 1dmRNKUc2s/7K6p3jjB1QaFKJv1wbvq7gLWS4IzxxERl3ckqDnL7d2vj0lqwwhA1nkY0gtJAWsS3jIs82hFIexeXoLwOrNw865LLhNJ7fb30fMNehF4N+P7XqDkyLae2Sd9/fseZgyjufPJAaiO0kn3+Y61KnofX1ySPmbDFIJAR/1yLQDfjzS8f2+sNfvPzCJSEymuX4QNKZSLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CXL r4.0 sec 8.1.5.2 Table 8-32 describes a bit that makes the SBR bit
in Bridge Control take effect at all, so a Port left at the firmware
default is one the reset must not silently unmask.

Add cxl_sbr_allowed() to answer if SBR is allowed: check if a Port whose
Unmask SBR is already set needs no consent, as it happens with cxl_bus
reset.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/pci/pci.c | 26 ++++++++++++++++++++++++++
 drivers/pci/pci.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index eedd516f8484..08873ea3957b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4881,6 +4881,11 @@ static int cxl_sbr_prepare(struct pci_dev *bridge, u16 dvsec,
 {
 	int rc;
 
+	if (action == CXL_SBR_OFFLINE_AND_UNBIND && !cxl_sbr_allowed(bridge)) {
+		pci_info(bridge, "SBR masked, write 1 to cxl_unmask_sbr to allow a bus reset\n");
+		return -ENOTTY;
+	}
+
 	/*
 	 * CXL_SBR_UNBIND: the link is already down, so offlining the regions'
 	 * memory would take the reads that page migration performs as a machine
@@ -5138,6 +5143,27 @@ static bool cxl_sbr_masked(struct pci_dev *dev)
 	return true;
 }
 
+/*
+ * cxl_sbr_allowed - whether an SBR of a CXL Downstream Port may go ahead
+ * @dev: Downstream Port to test
+ *
+ * Per CXL r4.0 sec 8.1.5.2 Table 8-32 the SBR bit in a CXL Port's Bridge
+ * Control register has no effect while the Port's Unmask SBR bit is clear, and
+ * sec 9.12.3 says System Firmware may leave it clear "to prevent CXL-unaware
+ * PCIe software from resetting the device and the link". A Port that already
+ * has it set needs no further permission; otherwise unmasking it takes the
+ * administrator's consent, given by writing 1 to the Port's cxl_unmask_sbr.
+ *
+ * Return: true if the reset paths may unmask and generate an SBR of @dev.
+ */
+bool cxl_sbr_allowed(struct pci_dev *dev)
+{
+	if (!cxl_port_dvsec(dev))
+		return false;
+
+	return dev->cxl_unmask_sbr || !cxl_sbr_masked(dev);
+}
+
 static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
 {
 	struct pci_dev *bridge = pci_upstream_bridge(dev);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index b6d873b077ed..bea05acc58f0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -248,6 +248,7 @@ int __pci_bridge_secondary_bus_reset(struct pci_dev *dev,
 				     enum cxl_sbr_region_action action);
 bool is_cxl_dport(struct pci_dev *dev);
 u16 cxl_port_dvsec(struct pci_dev *dev);
+bool cxl_sbr_allowed(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
 int pci_try_reset_bridge(struct pci_dev *bridge);
 
-- 
2.55.0


