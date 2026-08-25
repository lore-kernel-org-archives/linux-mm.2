Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE104C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A7C6B00A4; Mon, 24 Aug 2026 22:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61B36B00A5; Mon, 24 Aug 2026 22:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76E56B00A6; Mon, 24 Aug 2026 22:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89EDD6B00A4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D5DC402E3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:43 +0000 (UTC)
X-FDA: 85138206006.11.FD1B30E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id C05801A0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDVAK7Wq;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGejBX/jF835Z7IuXuPdOkPiAbyPz3KcX/iP21XURIE=;
	b=WFkoSXfQO7poNyTRG07qi3RTf+2UaSUDz6OrsWY67A694mS+yy5laOTpCor8rNZGywvCkv
	RGnRAIj2PL25RmeIDhQ7uAyBOBEOjbodbg/+K35yBSaNWpdMuyLi19m2wsqTg6TxbiSN9+
	RFjxMjotMKfabUwudNhUxgXbNPWnPRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624861;
	b=zuc/NEyyHe7oIw00EFclWrDTdyReuDnZHBdwVQB9XZAVY6vBlRpWy12UFaA8+40PUwK/04
	9TPA/BG4CCkxm+trTPe+eb+Gv/apG+3EA2616QJTI7f2PwPUmPZT87oonFAWJr1KchsPTz
	950I6G8YB0Vve2BBySQ1EAfzyNsF8/Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDVAK7Wq;
	spf=pass (imf19.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624861; x=1819160861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q3mRxBLSI2WW9TzR6U+x8ypVb6e1keaDDN/taWRABaw=;
  b=FDVAK7WqFu436oBZPqAxP949gVUBRKJW/fwZduWZheUWIT02Gzd6Ax7+
   WhohXchzXQbzYdsrkJ3Oef2FwZATpwuKRvyNWRlIZdIv1FpKrJ7E1sX5d
   YjI0jxHXyT2WIcqkrF4fjsCsO5kS2GbUWHL6ri8TRz4yyolqoQPLATElb
   mU0roCKrMcN1DHuTWItyFmS6SNcSXqnp3mco2imT+OCjs9/wckU2FCgrn
   xcBOKEFM8tw2nKkLBP/kUprHKJtYzwJvKbiNLLsbrZoK1CkIeq+hJ/Ns4
   BvthHUxQLyAdXOh1Is77bHWjJZy/hRVPv2Qz+yoiuyRGFvWPKZvAqy/ng
   g==;
X-CSE-ConnectionGUID: /19fh/z+Sn2PSc5KXUgshA==
X-CSE-MsgGUID: t6LCSw9AQjKKhF0Hjvg59Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761141"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761141"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:39 -0700
X-CSE-ConnectionGUID: XnmQbxFWQXSTf4T6etYNMw==
X-CSE-MsgGUID: 3BIjarGVQuW5Vhplv4Uj1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390104"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:32 -0700
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
Subject: [PATCH v2 08/13] cxl/core: Collect the regions routed through a DPort
Date: Tue, 25 Aug 2026 04:26:23 +0200
Message-ID: <20260825022628.3651434-9-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gttst81ttdcpmbphbhgr5xqgox1iee36
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C05801A0005
X-HE-Tag: 1787624860-128273
X-HE-Meta: U2FsdGVkX18Q0P5Wqwae7DI/Fp8VqAXM0UUiMFFVG7lNWpW501V/9ZhMWSfTDa5E2dW8NF6Z0xLQdF6+q02PhukN208Z+PHnoaJDhjYkvBbDmUucLzl771qYJ1PxP6vgHKoqLm2BllO/4PdeiSVs674i70zaJrYZETE2gAVst1QjDhaHDJ6u2q1GObXU7axgtGPRhaybUSIxRny/AVU7a4Uxnb+4ffmi4ntNtgQ6rm/KOn9EzvRXbevQWJ15e0MYlZGCYkHpErXiLjp5B5vIt+9cuBUi/KFClweGuzeUDcMwwtU4JDiJFPKxuKPwOlQgeS4JA39Vfwtp87l9je9UMd0dooSl/VVpOPNdC0SMOS55tfMgG2eX8qwNcdrKFQBX6IgMMpdjIK8yyh8i2rWhRqwnaX+n1NGnW4tkbxAoofpxkNAgk5Q8Hl78rE8rrr3nZmZ9QcXM4aMKdcg1DkpYUGdwnTZk0ycoT60K/e5vxenSl1dr183nm5RjSsJHtGDgVJKLlxvE3bZFl+HpV2dKkLNQshot9KTbyG54hMZqz4uxY3L8vbwc8PuSTfuHSsE6k1xtc6eWrLZ/oqio6BGrVBrtWT4jPT+jKizhiqjj6D+xVxk5tlw/dKN/A/VSkkKL/BfLtQ1Nqa4RgM/M7YLoVdkth5BLweajTihuUS0a+PwTno++iUOcHd8cmYqiAnqIwMNrUsuJJw4hSfysRHeiwvgUUjO3TV5m7fFj0g/knJWVwxtnS/sz6NpOstC2QTpF+Z3nWuBVQr+M4GHT/aE3Ru6nY9371pmvhmqVdSzv1hNilNhRKbC7qt5D5Y2Bt2Y0VqQHYHpvNL/5AUSl90/pVBZE/3cSEBJiCc7EGDUEvEWGcEG3pjotcw20ogjgmwNO1X+dEmH5pDbqbIDQA7HOV2po196FZwiyNXSDop15Qe7LLJR4jWS3Fjnccz8RvfEJn5qc5izOfQ1xjLFMAXq
 jJX/8KwF
 YNQq6K1p3tNxpMgqIn6BRUW9Q8e4D+Mw2EWsgHSwOVDfVrNy3zoXtX9P6PnzRvs24/j8zeSYHAJ15XHEBBevHnPB4HZNM1/sfzkyOHQ5P5gewAPWVns1Rr/BLi6lg/Itfi1IBYmhAQfhU6KGjK5o6ZXoXy5hOjXeUYFwMlAotDpetolCp0ZnToSnNzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Disabling the CXL regions ahead of a Secondary Bus Reset needs the set of
regions with a member endpoint below the Port being reset.

Add cxl_sbr_collect_regions() to walk the CXL port that owns the Downstream
Port and return every region with an endpoint below it, and
cxl_sbr_put_regions() to release the set.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/cxl/core/core.h      |  2 ++
 drivers/cxl/core/dport_sbr.c | 66 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index ac55f9e8160e..077a2af9cf0c 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -60,6 +60,8 @@ int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
 int cxl_region_disable(struct cxl_region *cxlr);
 void cxl_region_enable(struct cxl_region *cxlr);
 struct pci_dev;
+int cxl_sbr_collect_regions(struct pci_dev *dport_pci, struct xarray *regions);
+void cxl_sbr_put_regions(struct xarray *regions);
 void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
 			       struct xarray *hdm_state);
 
diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
index 0f398ab0d3a4..233499bc1fad 100644
--- a/drivers/cxl/core/dport_sbr.c
+++ b/drivers/cxl/core/dport_sbr.c
@@ -85,6 +85,72 @@ void cxl_region_enable(struct cxl_region *cxlr)
 		__func__, p->res, p->interleave_ways, p->interleave_granularity);
 }
 
+/*
+ * Collect the regions with a member endpoint routed through @dport_pci, the
+ * CXL Downstream Port about to be reset. cxl_rwsem.region keeps the topology
+ * stable for the duration of the walk only. Each collected region is pinned
+ * with get_device() so the object survives after the lock is dropped, since
+ * cxl_region_disable()/cxl_region_enable() run with the rwsem released (they
+ * unbind and rebind the region driver). Hence snapshot the set first.
+ */
+int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
+			    struct xarray *regions)
+{
+	struct cxl_region_ref *cxl_rr;
+	struct cxl_dport *dport;
+	unsigned long index;
+	int count = 0;
+	int rc;
+
+	struct cxl_port *port __free(put_cxl_port) =
+		find_cxl_port(&dport_pci->dev, &dport);
+	if (!port) {
+		pci_dbg(dport_pci, "no CXL port found for reset dport\n");
+		return 0;
+	}
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	xa_for_each(&port->regions, index, cxl_rr) {
+		struct cxl_region *cxlr = cxl_rr->region;
+		struct cxl_ep *ep;
+		unsigned long ep_index;
+
+		/* Skip unless a region endpoint sits below the reset dport. */
+		xa_for_each(&cxl_rr->endpoints, ep_index, ep)
+			if (ep->dport == dport)
+				break;
+		if (!ep) {
+			dev_dbg(&cxlr->dev, "%s: no endpoint below %s, region excluded\n",
+				__func__, dev_name(dport->dport_dev));
+			continue;
+		}
+
+		get_device(&cxlr->dev);
+		rc = xa_insert(regions, (unsigned long)cxlr, cxlr, GFP_KERNEL);
+		if (rc) {
+			put_device(&cxlr->dev);
+			return rc;
+		}
+		dev_dbg(&cxlr->dev, "%s: endpoint below %s, region collected\n",
+			__func__, dev_name(dport->dport_dev));
+		count++;
+	}
+
+	dev_dbg(&port->dev, "%d region(s) routed through %s\n", count,
+		dev_name(dport->dport_dev));
+	return 0;
+}
+
+void cxl_sbr_put_regions(struct xarray *regions)
+{
+	struct cxl_region *cxlr;
+	unsigned long index;
+
+	xa_for_each(regions, index, cxlr)
+		put_device(&cxlr->dev);
+	xa_destroy(regions);
+}
+
 /*
  * The reset cleared the HDM Decoder registers of every CXL component below
  * @dport_pci, so restore them from the settings the driver holds and from
-- 
2.55.0


