Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D3FC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D906B008C; Mon, 24 Aug 2026 22:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7236B0092; Mon, 24 Aug 2026 22:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5EF6B0095; Mon, 24 Aug 2026 22:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDCC6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:26:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A355A33FB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:26:46 +0000 (UTC)
X-FDA: 85138203612.14.BF9F1E8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5B44180006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:26:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D2X4E4rC;
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zY9nF2RQ3gTikZfjKcS1scrUKxgxGYtG8WcgkyAvxNg=;
	b=DycaeOA67F9hkLc1T56bHDnUyVuknRTKj0YKvusZIrKvNhA3obsMXRRg9Vwraad/c8dMnY
	fawcqlitK2P6ESMrqmF3i/KxL32jUrjQap3a5vwqUVwfsHiQ9AR7aq+uILlQ1aTz9XU3ub
	A3G6xcK3PtpLK1rQrJOTVNtwmh/gwMs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D2X4E4rC;
	spf=pass (imf16.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624804;
	b=DsZ7bMCo+TyEK06xeufDgFugO3Ru8ggLK2xQJqElWRR7p5wirrwF4G/96zgox5tuo+AXH3
	4I8qnHIo7JmDaUxHCIreASwV6gZ43vEE7WZux8caAjvrcz85iJRDdxtJhLCIQ5P/sshSdq
	UlSVWrc5SGDh0loz4Q0xXL5Iw9KNQgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624803; x=1819160803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=59oDA8OxqCcTABs6FaXD4uZZ6h0YHjbqVgHwIRKfCEk=;
  b=D2X4E4rCfwC+oXSwXyTV/kSd01RNoQnV7Fr3B08ZImMWA+jHwsZvJNCd
   rgcNhgs+c1xEN1GML1XYLWoBPPu67oLNA7NO50LAmgvey8JEJl2HXsrqM
   LcLpt/wWcL3xtXq23kqjJb4oU/glT5+mo/A+hHwfTFDhDer9LfsWYFaX9
   h/cprzZcz6PkHwRJSI1sgp9upDFAmbvxKZqUZdMonwBsXkm8kyrNOaJ9d
   xsYw5m8p+tNUVq9KJgeUwXMFmb3bdNvXIe1O/vqyyBY3GOXscuqfgqH3N
   TXMVRLWUzopx47hMra2b5XvU3s5u5c3QZIzrF/iOCHXQqm8oroxPfjZpC
   g==;
X-CSE-ConnectionGUID: v6usFiojRhisWD1u2et8XA==
X-CSE-MsgGUID: uoFyE5TVRDuhojOJ2sSxnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98760923"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98760923"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:26:41 -0700
X-CSE-ConnectionGUID: qw57hyDPQVqR+IkyCbQLew==
X-CSE-MsgGUID: yqTxaTRTTP67lZe80asckg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390022"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:26:34 -0700
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
Subject: [PATCH v2 00/13] Make SBR work for CXL Downstream Ports
Date: Tue, 25 Aug 2026 04:26:15 +0200
Message-ID: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5B44180006
X-Stat-Signature: 44xs17mh6fu54rgs8fwtau3bqpat1y6w
X-Rspam-User: 
X-HE-Tag: 1787624803-346393
X-HE-Meta: U2FsdGVkX18ClwuadEGuXn71OoIGsBFEabHJuPCa1eGtpNLYJHGbzmCBP3Hf6346q6Oyrad4p7EWbc4eTkmBn2gqMiKJ9tafPfCmJtH0pvkhkIKnfttwwI2PYXmC2yxQDE0V8CL9BonOnIfVkcYTCD+lTMWvxSNdE2l/Hevrfb6Zn5qAVkxaL8bn3wTBfF3JzoFWN90wyKkcBbPyupjgTmB/jTTfnEmsKnBmfg+6RXdRmrVApql5anqQR1zaY9VChlsCN8ZrhRADSeBTecxcYtdZrCMLO1Y8dhrQ6NRHLCmWYip6GlFEwr9VPmfrrV8D2Kty/s4fr9WcY8SmesbYlOapS4f/mdzLz/FAbe9q37jI2exYeXDmVgb92+1MMNizG/RCpaSvOW45V5MfS6J4ffyTPXuVdkVBx6o0bf4krzuXXQYQ0BfrmlJvqxvrBbadvIWMWVQKC37I9UTgMwwbG3lkNv6VYAC9DRJsfp3PhbL5SnwxacgAM7de+khPJv3OcRdqVxpxdSwFhJeax3ftkg629G6zrGinz6KvdGZjdSjExKRDinoyfzOl2e6v0F0tXYGILiIx0EcgZfMY8cu+7Boo5zCU4tfAS+3srbd6XSqG8S4u2zLQaRx+RP382SJ+uKI0wOJrtzT4wkk1H212w7gyI+nRl3+VgsH33jLfRekod0RYMKazQWzGRclL7qxv+0MXlOxhRWAJlTZhrYTK7+6LAzQFXcRSZM0C7GjMTBYT9WlMUNjBqnH4JzAXOcVYTK1pk/9FHola6y106yHr2OtixqkvR3sFe+ec2kxfgp3LnofVhvntAw7jcrk+dVTyYKUvHFOhoSsc1JexFLfN+OTvEi481pm92kTUhTD5TroF9+Zk5WBga4cgXAELqYjJGYt7cjaCS0o8lYdFtgjZS8VBhwSjMI0M7aVTfTkhgR7e0kjihxqJPJcnp0gxcB/SUlguLh55Z+eO9L+qxk0
 2ltWjbpG
 CN5yfT6bRKktzX+pXyOcpmqH+HuQwZUj4mAtZRNy6QPpnhp1ufEt263Nqyv8/DJo91XeVyOOdULfVenD0dHvBqWTCNzYMbAQ1hfMvOOsCtPBx9KnRTvaz49fc+10NcfDYGSiABBDHvJ4WB0GLtr4xtnynOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset (SBR), a Link Down or a Downstream Port
Containment (DPC) event on a CXL Downstream Port clears the Downstream
Component's captured Bus Number. CXL r4.0 sec 8.1.5.1 notes that, if the
Component then sources its Power Management (PM) Initialization traffic
with Requester Bus = 0, a Port with Access Control Services (ACS) Source
Validation (SV) enabled may reject the Component's CREDIT_RTN IP2PM
message, PM Initialization may fail to complete, and that "another
Secondary Bus Reset alone will not facilitate recovery". PCIe r7.0 sec
6.12.1.1 makes the rejection an error that is reported as ACS Violation.

The Implementation Note under sec 8.1.5.1 gives the sequence that avoids
it: save and clear Bus Master Enable and ACS SV, generate the SBR, wait
for Port PM Initialization Complete, restore both bits, continue device
re-initialization. This series takes a step further to a preventive
measure that avoids the ACS Violation in the first place, not after
failure.

Patches 1-5 restore HDM Decoder registers below a reset CXL Downstream
Port.

Patches 6-8 disable and re-enable the CXL Regions around the reset:
offline memory, invalidate CPU caches for its range, collect the set of
regions the CXL DPort which is SBR andunbind the driver.

Patch 9 disable and re-enable CXL regions across a Downstream Port reset
and registers the CXL region callbacks for a Downstream Port bus. We
want the reset to be called only when the CXL driver is loaded.

Patch 10 calls the CXL operations from pci_bridge_secondary_bus_reset().

Patch 11 issues the same sequence from dpc_reset_link().

Patches 12 and 13 gives root a sysfs attribute that conrols whether the
SBR is allowed to be unmasked and prevents kernel from unmasking SBR on
its own.

What user space finds after an SBR of a CXL Downstream Port: the dax
device returns under the same name, the region's HPA range, interleave
geometry and decoder programming are restored, and the media content is
unchanged for PMEM. System RAM comes back registered but offline.

Fabio M. De Francesco (13):
  cxl/pci: Make the HDM and Mem_Enable writes callable from cxl_core
  cxl/hdm: Add cxl_decoder_recommit() to restore one HDM decoder
  cxl/hdm: Add cxl_endpoint_enable_hdm_decode() to restore CXL.mem
    decode
  cxl/hdm: Reprogram the HDM Decoders below a CXL Port
  cxl/core: Restore the HDM decoders below a reset Downstream Port
  drivers/base/memory: Add cxl_offline_memory() to offline a physical
    range
  cxl/core: Add region disable and enable for a Downstream Port reset
  cxl/core: Collect the CXL regions routed through a Downstream Port
  PCI/CXL: Register CXL region callbacks for a Downstream Port bus reset
  PCI/CXL: Clear ACS SV across an SBR of a CXL Downstream Port
  PCI/DPC: Issue the CXL recovery SBR from DPC without offlining memory
  PCI/CXL: Add cxl_unmask_sbr to permit an SBR of a CXL Downstream Port
  PCI/CXL: Refuse an SBR of a CXL Downstream Port without the unmask
    consent

 Documentation/ABI/testing/sysfs-bus-pci |  16 +
 drivers/base/memory.c                   |  36 +++
 drivers/cxl/core/Makefile               |   2 +-
 drivers/cxl/core/core.h                 |  28 ++
 drivers/cxl/core/dport_sbr.c            | 374 ++++++++++++++++++++++++
 drivers/cxl/core/hdm.c                  | 341 +++++++++++++++++++++
 drivers/cxl/core/pci.c                  |  19 +-
 drivers/cxl/core/port.c                 |   4 +-
 drivers/cxl/core/ras.c                  |  10 +
 drivers/cxl/core/region.c               |   6 +-
 drivers/pci/pci-sysfs.c                 |  31 ++
 drivers/pci/pci.c                       | 254 +++++++++++++++-
 drivers/pci/pci.h                       |  15 +
 drivers/pci/pcie/dpc.c                  |  46 ++-
 include/linux/aer.h                     |   9 +
 include/linux/memory.h                  |   5 +
 include/linux/pci.h                     |  16 +
 include/uapi/linux/pci_regs.h           |   2 +
 tools/testing/cxl/Kbuild                |   2 +-
 19 files changed, 1193 insertions(+), 23 deletions(-)
 create mode 100644 drivers/cxl/core/dport_sbr.c

-- 
2.55.0


