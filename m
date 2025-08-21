Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39B6CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076F78E001C; Thu, 21 Aug 2025 14:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026C18E0001; Thu, 21 Aug 2025 14:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA71D8E001C; Thu, 21 Aug 2025 14:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D97248E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:00:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 729721386B8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:00:02 +0000 (UTC)
X-FDA: 83801528244.20.938212A
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41DA120006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:00:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PXFRDMHy;
	spf=pass (imf13.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAejoY8V8yKY210FgQYVrnGosOJpV+P2BaPXX7POKoM=;
	b=5u7B11STVWphCCHbqHKg18NnSRonVEkR11Tdl7m53ujsLg4Nf4H3x0J1a/YS0nwjNMKMeW
	k+3JQWfqkAy4UhBMWBp7Xh23emb9fvT3hd4W3jXlBd4ft1GbLMklIYRIYC/7EDiSsFqcIq
	RKJxq+b2inlp/5GcEhWifqaNWtiAbGQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PXFRDMHy;
	spf=pass (imf13.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799200; a=rsa-sha256;
	cv=none;
	b=bHHlRUnNjbX8cHTSdrwJawKw/ZYkFgZFGsvPNhU8/DtNC/OTj+YOtoIdPdUZtJzF7zb+dP
	Dj4O4hqgjhSAeD0/5e49wTO6hzt5nus327WbAvIB2tqoX+dVyXVhFLJgoYL5T49BRUxP0m
	VdHHCYIX6a2otxZoZvoQw7yyOuBsToU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755799200; x=1787335200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAejoY8V8yKY210FgQYVrnGosOJpV+P2BaPXX7POKoM=;
  b=PXFRDMHy9wIa+DItM0v7GGhxrvWjSz51RF+5bkhSc3V/IfiX2ohcJTXq
   s8/UU7yuyVzIuY8v6FlXNTlnAlH0D7A/nnv1lpqROfpP4oo2lMTS/rCNp
   MjcYcTpB7nHR3micdTaX4XMFoZYylC/AZfM5hFnIF/rSgSGV4BmcEJcqP
   NEyKnCcXi5nLOHR6DJ30Kn8h+Cf07Q3S+K+jNBRw248wbGowuCTslrFMp
   WGHlvqyAZcjGXWmbvoM0YSMq9w7Xl6ryUETg+YM2opzDbbQzQlY1tkVws
   rSc5XlYszbTlBt9DpJe0Td2PCoPwDguHbgaOTsOPF56CXLcCPOEAEDRKE
   A==;
X-CSE-ConnectionGUID: YrrezCWoR5CjuQvlqk0NUg==
X-CSE-MsgGUID: vpO2okg8Q9eLRPjnNyfjuA==
X-IronPort-AV: E=Sophos;i="6.17,309,1747699200"; 
   d="scan'208";a="1451197"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:59:57 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:61839]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.67:2525] with esmtp (Farcaster)
 id 107f8fd8-d666-4959-a00a-c9bafbb3e9e6; Thu, 21 Aug 2025 17:59:57 +0000 (UTC)
X-Farcaster-Flow-ID: 107f8fd8-d666-4959-a00a-c9bafbb3e9e6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 21 Aug 2025 17:59:56 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Thu, 21 Aug 2025
 17:59:54 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
Date: Thu, 21 Aug 2025 17:59:00 +0000
Message-ID: <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1755721529.git.epetron@amazon.de>
References: <cover.1755721529.git.epetron@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: adho7yunfuko1jg8rogzfzd8nut534za
X-Rspam-User: 
X-Rspamd-Queue-Id: 41DA120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755799200-244754
X-HE-Meta: U2FsdGVkX1/pGV7s9EaNUgHSlEiFZB7PpemN6PT7/qMFL2Zi+3Ni0G9xp/IazHKAyO/g2U2sGZVtNIpmEVfSnc9e5rqejnn9G5Xp5woD9BA3kuWco5ilGpDtx3UX2J16zZADTU2wvPme04unTkkjmgMyYXmDH1I5Fxr5FBjqe8GYXXnmay84bxcXvJMOexILTFrtTwHAmviPmPWlLbLu8RWUeKl7feiiWl4Vdtz0f4XwgmO5mrl6NRpf0mDbWVTxLc6cHHi22CHOtVKDtbZ8b7PGNSZIf0yr1gUlbjiTDyzcap7k2YHMMDWxpWyjrgixhbKTncbNZX0F0sjNXTRUlHOF2Cfr0Tk6cwtAM6xtGYMGhrviKwYHq4IPHaBduB11Um6tX+xR0wDeBoF//FxRE7Zt13sW3Krhrhw/0VqPCtJRmYvsLXDH6gFQm5vMJbH1DSQYdOx7th/HhIXHlQGz4FmyH+C6da0mP/8m1UaujJfq//ms1XcqR+zF4bf5l4sT8pDiBenD9lc9uHGKvohcZeoEhdVjw/OhfUrNckkABNQk7S6G63sGpS+YZhb7dTC5ln0sC9M1gOcGiffH8YSxamU+FIZffNb87ogCdjLVGV2KG56hYnXG93rx1ny988j3o3rRFrPHiwdDKPwYFvkh/bvJ5pa76aRCbULCoeu9DnO/5EJzbY7RvawW8Dh8MhuHYtUQ8zMHy7lti5a6J7t6o7nTFc8fymUzPitsEqrL5l6lpzTIpe7dA+HJunmyaeW83SEZw+ZwyhdNdYErhuOzOCC7wpBUGFkwsyvSOOmJHZYU7nuAVBXlB1P/EqnNoqZrU7xnJhBLoAp0WgZn3wMI4Iw1JpUJuEvmb0wivl8+e6oPAwu20dGHn/jTIjcKqzfsygM3w45Oi4DwebPz+LW0s2r61LdqZnpfmBlcc1oSZ0vb9uynuixHxR4Ea5R89LN1tdDM01hVukHEmyeOPNV
 yLp+IeEg
 +zGwnpPdXIp/tNSinO6eWxJLT1BUezLte2z0eA0yUKs4uFgqpOaAithZP/eg1cPFFkEMeBvh41e1jzXOJOlrFeYc1ISJtlthhYbGnQ8IDHplCrmEd+YV2R4IsKeJd75sv5PGs5AH8XevYzoqInl9XIMdqm/hXlgD9VvHpd+pQVDcQWylq2+sYvzwYCYPXtZ8VH6b5B2/F8Fz121PnTPMprMV3Xy+BjwRWssnhoc/R7pTJjCTmib3EuBNBqGA9ptFJ10df+oCm2z9Micyfie0p5k9Xhb/aUOp2ryUlQWAC8dq01poeYUZJt8/OCADS3Nkv905rtJJ+y1sY8jpJbkKjMRw3sXDidt3EVnmlrMr4CUM38ZW1n/qM1OO6ADk0DWNOshIXzc1fRK5Fu3rhfthTZqEKwYkBdPk87G+EC859L9Aj+hiOTOOp5CrT9xowE4F+bBmMD4LQspP9xarWOWaupZH46JhQB7DRMJtuODlWFO/GPAbOrOzPS1Mj/Wrwen8p8IfhC2c5fMOCVdDriVDF1DD/oAPCuRZjbZ6kwhKwCA01dDHLD9SKUnJSI2SO+AnV0DSk6rGNRZx7WBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
early during device tree scanning. After kexec, the new kernel
exclusively uses this region for memory allocations during boot up to
the initialization of the page allocator

However, when booting with EFI, EFI's reserve_regions() uses
memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
rebuilding them from EFI data. This destroys KHO scratch regions and
their flags, thus causing a kernel panic, as there are no scratch
memory regions.

Instead of wholesale removal, iterate through memory regions and only
remove non-KHO ones. This preserves KHO scratch regions, which are
good known memory, while still allowing EFI to rebuild its memory map.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
Changes in v3:
	- Improve the code comments, by stating that the scratch regions are
	good known memory

Changes in v2:
	- Replace the for loop with for_each_mem_region
	- Fix comment indentation
	- Amend commit message to specify that scratch regions
	are known good regions

 drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index a00e07b853f2..a65c2d5b9e7b 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/fwnode.h>
 #include <linux/init.h>
+#include <linux/kexec_handover.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
 #include <linux/of.h>
@@ -164,12 +165,32 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	/*
-	 * Discard memblocks discovered so far: if there are any at this
-	 * point, they originate from memory nodes in the DT, and UEFI
-	 * uses its own memory map instead.
+	 * Discard memblocks discovered so far except for KHO scratch
+	 * regions. Most memblocks at this point originate from memory nodes
+	 * in the DT and UEFI uses its own memory map instead. However, if
+	 * KHO is enabled, scratch regions, which are good known memory
+	 * must be preserved.
 	 */
 	memblock_dump_all();
-	memblock_remove(0, PHYS_ADDR_MAX);
+
+	if (is_kho_boot()) {
+		struct memblock_region *r;
+
+		/* Remove all non-KHO regions */
+		for_each_mem_region(r) {
+			if (!memblock_is_kho_scratch(r)) {
+				memblock_remove(r->base, r->size);
+				r--;
+			}
+		}
+	} else {
+		/*
+		 * KHO is disabled. Discard memblocks discovered so far:
+		 * if there are any at this point, they originate from memory
+		 * nodes in the DT, and UEFI uses its own memory map instead.
+		 */
+		memblock_remove(0, PHYS_ADDR_MAX);
+	}
 
 	for_each_efi_memory_desc(md) {
 		paddr = md->phys_addr;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


