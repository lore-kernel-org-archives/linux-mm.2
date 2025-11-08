Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB10CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A72B8E0025; Fri,  7 Nov 2025 21:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758218E0006; Fri,  7 Nov 2025 21:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DD98E0025; Fri,  7 Nov 2025 21:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E69F8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:32:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDD061A0460
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:32:16 +0000 (UTC)
X-FDA: 84085865472.06.8D4F457
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8743C1C000C
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:32:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6LE4m8t;
	spf=pass (imf20.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762569135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7JCEQiLfoKvvq2YHFw8rJNGVkKgI5fqfxlo3zfC8tBs=;
	b=wQN5j0M7lDA9HC5CXwgybWjN/9qB7+ZHgmZUOTjQ/RvJK7rZOuruNDfwBok0HjWKzf6dP/
	slruVIrsdhPijxlNTog2PVVlBdBVWNI43tt0Q5t1sqNeQhw7VQzrp6apWLPRkujzDEze8w
	qpmg4xGbcA0RH9L7CMNTeWdKVm52Vbc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z6LE4m8t;
	spf=pass (imf20.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762569135; a=rsa-sha256;
	cv=none;
	b=ZV5jI0lh/HJhmJCLyZP37R1lLJ9Du+b2PG1cVlux6UibX3lmAFYgehzUdT7eYS4ncGUm13
	f2llfqdi4AdUUy/96NhQz8CHutqGdnt4WT7Uu4aFJK7FTlPpQ7z5wXzqcyYQqykwlAunfn
	yQhy1BQrX3K1u+zK8wXCwLg+WfUGD7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762569135; x=1794105135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4PFSerajliqupS2a5xNYcPtqhGnAJHkxq6WyZeB8aCY=;
  b=Z6LE4m8thy4O94xY8weCybuqN+UB6V9G6icySyNo5d0L1wHRgyYbETQm
   Q3L+0t2qFkOUIenQRQ/zdVK5llrkUCQ0ZzsbHOX2HbzF45aDtfVWgYIPx
   4yf5GNTsRKfCRE4jDCo4gNu2eeB/VL8cyebgnC3JPS5mw9nMoq/ufOdbd
   rZJlX40hkrTUwiWrmPWd8OteVs3BdZ1+l7c/AeprCeH7MPCe1aPTDCXfR
   FtoIkHNtQevkAOK3ZPTvY4FrxLs06UOW6MUMBLC6aKZNTVvdI0ukr3c/t
   AADrBMroSmgNqwYWPrrZXa3zOT9Lwt3TXjmtc7z0ZKzAz7nrwX5KqMwQ9
   g==;
X-CSE-ConnectionGUID: YHUScAboTL+xSXIi4QNyxA==
X-CSE-MsgGUID: OIb403f4Ta6lFXcYz8ZkJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64627111"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64627111"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 18:32:13 -0800
X-CSE-ConnectionGUID: CCbxNs0lS828VFxjak0q2g==
X-CSE-MsgGUID: TNf7zXetSx6PBYtu/7xDqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="193218027"
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa004.fm.intel.com with ESMTP; 07 Nov 2025 18:32:12 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: dave.hansen@linux.intel.com,
	peterz@infradead.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
Subject: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR collisions
Date: Fri,  7 Nov 2025 18:32:15 -0800
Message-ID: <20251108023215.2984031-1-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8743C1C000C
X-Stat-Signature: nk8993cn4sk9jrn8y9ywwcwecd9dm1st
X-Rspam-User: 
X-HE-Tag: 1762569134-885554
X-HE-Meta: U2FsdGVkX18+Ib8ECCnRBpcFSeHb65K+3Lb2+nF9DNge0fCqGGI8BCvuyJMkLmLA/Fbj24LvnQ48SW5dXF0P71W0QD+hmfNyNL11z5tBAmoJN74AR+Katx6nMNVfksosyKw9e/TliQXOb9Xch3qKlqSVxEbvUgOiJpDQL9VtmefylCg5t2LTlZ223wND3w15Z2F7sQ3wHluMTwpjWlghduV8pdK6tbxgGuojy9WoE1diDQfiwV2mRuKTivOZ59R0mGXH0A0qw6ro01OtkNk4/ay38zQNaisNbaAZME4ZY2XuOtQ45G+s8CvqJQpWMu/ROYoaKAVLLQsxMQ6eUt4EnkKZ4foIVjD5Ge6GL+jNBSWt9EmIHwJyT6l8U55yJTTAVWhMKsy2OGm1fsn2P/Rll0DUB4lvELFiqq44Xu75V7zNYfguo2qT3ig7nO9OeGk/4iIip6DJKkTVxQ7eyfXSN5gJ1+djDLSuX+Q6psNIwu4T3MJKM26Drw2b+s3UUtxc7tlWkD6fSbdiuC687dWkbH47yG4asYsRJjLQSQKWqtSOTv+aMxMB/XQOQVB+3Uheu+vmc/B0opLGjxRCznK/5uJkrFVJTu7wpEsWZJpYCG7t+/D2PXe/NFOUzEPUJAQOe1BPPqmxgghgSGdYo4AGdFthCdLQroKG0Jeo7N76sDMv1wYOS52Qm638ETsKFh1VzMU4rijOhohSNyZU8dEntmXUlwGfjBDbNPzC5fp9ucEPI4DfK9R65yrlqj/gqE64qI6BCA7cFDUAIusY7Bj/ozPI22mDdG4RiEabnQB3avxUAjHxpSkP/sFuggUqWKFFlbr6dyIGfOJUc4+Zsjk0EX2ICJGaJIXTKxHb98X1A9x1fATNqTd//Q/vWctL1p97K7sA9y8SSu6S1pnoNMECpSsQtBQimlpSU/E+CW02WPikSXX1Fviv6lfpZEuU3IfpWufZcXD1CogiWe/W33Y
 HjfHUJj8
 4zVg0EYkMcPt+m3C9rV7MThJ7HzMbkuKak1PuxBuE5kVAWb2nchLqeCO2g+Fo2t6yOk0bC/JrxRK/rpiJhE0vVQIlO/SlMIC85MAa8ght/kDn9f3PpSb2batcp5SoldQ8mA3wmWbF455bP64gDhSNXaQXJ8OI4QTfCbqifI5J8PrWEBDGvg/HxVo8nnmmh1XP9J0h3cBIJ2gIZEdO4WKVnHQ1fnQiUhxANZDwmI9eTHZgO3iCt+MRAwFw0MFsEM6Mg2va91MhUJ9lEOWvOVRDiY8VAbFk4bPPbZJkx44ArIjEkDWYKbpHBuPchET9JVlJwFz4Q0/NZPZefvtGU/Bn9pE2VjSIunh6/9Xx73VlyXVArYkbWs40KxCAYzmM1PSmD+TQPAfMj1xTUX+D/hbolUa8Xd4k2CGrYnCyz0NgKa1MeE0/lDJJz1CiRLt8RltqLdv3oUFt68c9DVDbaFJ07y3jrmCY1aAK0ZkGGz0hvnLKb05t7Ou1CDWzbGWFN0cdnmbt+1ObqmrLGpojudQQwcNtyLpF/ktUOOs/FFaj5GKCcJuwXPEkSkshyygU/W4lNvJV3yZjix7kMZXVrf7iyIa6F0H/nzHzA+GXDat7U4Em9EG2HNqHG7EcIN5XqtQ9haK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
is too narrow. ZONE_DEVICE, in general, lets any physical address be added
to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
or EFI Specific Purpose Memory, but also any PCI MMIO range for the
CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.

A potential path to recover entropy would be to walk ACPI and determine the
limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
smaller systems that could yield some KASLR address bits. This needs
additional investigation to determine if some limited ACPI table scanning
can happen this early without an open coded solution like
arch/x86/boot/compressed/acpi.c needs to deploy.

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/pci/Kconfig |  6 ------
 mm/Kconfig          | 12 ++++++++----
 arch/x86/mm/kaslr.c | 10 +++++-----
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index f94f5d384362..47e466946bed 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -207,12 +207,6 @@ config PCI_P2PDMA
 	  P2P DMA transactions must be between devices behind the same root
 	  port.
 
-	  Enabling this option will reduce the entropy of x86 KASLR memory
-	  regions. For example - on a 46 bit system, the entropy goes down
-	  from 16 bits to 15 bits. The actual reduction in entropy depends
-	  on the physical address bits, on processor features, kernel config
-	  (5 level page table) and physical memory present on the system.
-
 	  If unsure, say N.
 
 config PCI_LABEL
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..d17ebcc1a029 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1128,10 +1128,14 @@ config ZONE_DEVICE
 	  Device memory hotplug support allows for establishing pmem,
 	  or other device driver discovered memory regions, in the
 	  memmap. This allows pfn_to_page() lookups of otherwise
-	  "device-physical" addresses which is needed for using a DAX
-	  mapping in an O_DIRECT operation, among other things.
-
-	  If FS_DAX is enabled, then say Y.
+	  "device-physical" addresses which is needed for DAX, PCI_P2PDMA, and
+	  DEVICE_PRIVATE features among others.
+
+	  Enabling this option will reduce the entropy of x86 KASLR memory
+	  regions. For example - on a 46 bit system, the entropy goes down
+	  from 16 bits to 15 bits. The actual reduction in entropy depends
+	  on the physical address bits, on processor features, kernel config
+	  (5 level page table) and physical memory present on the system.
 
 #
 # Helpers to mirror range of the CPU page tables of a process into device page
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 3c306de52fd4..834641c6049a 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -115,12 +115,12 @@ void __init kernel_randomize_memory(void)
 
 	/*
 	 * Adapt physical memory region size based on available memory,
-	 * except when CONFIG_PCI_P2PDMA is enabled. P2PDMA exposes the
-	 * device BAR space assuming the direct map space is large enough
-	 * for creating a ZONE_DEVICE mapping in the direct map corresponding
-	 * to the physical BAR address.
+	 * except when CONFIG_ZONE_DEVICE is enabled. ZONE_DEVICE wants to map
+	 * any physical address into the direct-map. KASLR wants to reliably
+	 * steal some physical address bits. Those design choices are in direct
+	 * conflict.
 	 */
-	if (!IS_ENABLED(CONFIG_PCI_P2PDMA) && (memory_tb < kaslr_regions[0].size_tb))
+	if (!IS_ENABLED(CONFIG_ZONE_DEVICE) && (memory_tb < kaslr_regions[0].size_tb))
 		kaslr_regions[0].size_tb = memory_tb;
 
 	/*

base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.0


