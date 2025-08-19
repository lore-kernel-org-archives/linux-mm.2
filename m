Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9C2CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646238E0006; Tue, 19 Aug 2025 19:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DBB8E0001; Tue, 19 Aug 2025 19:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533E78E0006; Tue, 19 Aug 2025 19:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 429C68E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:26:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A398C0224
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:26:13 +0000 (UTC)
X-FDA: 83795092626.15.092DB57
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5DE7140003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:26:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=KnpbVD6f;
	spf=pass (imf23.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755645971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cd20LjcxPOsEg21zYy/cmh2I9QA1AIBt6CLKTzRjH7g=;
	b=Cx6Q4FHRtwQ7IV6rD4aEzjJUd4J5HjD+K6PhGUW5vYhCLSPiE/QFFfFFGCjY2NeWazbVsx
	bKaFsIBfF0L32R8zPruSVhXVBqLaV4F+26NlTuVnWJFAA1IZGzf5PBMX4AgTO5hbJ2KysQ
	Y0rlkN9wPgFWpZKAUQLO+f6e7ACs1mw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=KnpbVD6f;
	spf=pass (imf23.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755645971; a=rsa-sha256;
	cv=none;
	b=HiCf00tsKsyZl2R7JeFOnxXA3drd3hK6Bn+Un+FtzMadu9JoPk3/2012f4RUFrjt900MNY
	7X8D8KHuFw7PvhYyv0aeikJqmVwC0PATjXXjIpjIzoDk5CQEN+0OpxbyGH7mPs61JtshIa
	bP8wdBTGVVkl6uXTG5+aD0RRMcBpcTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755645970; x=1787181970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cd20LjcxPOsEg21zYy/cmh2I9QA1AIBt6CLKTzRjH7g=;
  b=KnpbVD6fOmEb3c4Q++WgGYpalpbQNfLt2KP3eB6dkv1VCYEed7bVE22f
   nK62bNOl8TmvNNt9gKu0eRckdBOWKRETsfeDC/TT2hACWb15bmWPuCg8u
   2izG2Jn/6DOJvn6jCWK1vaTJ830FNqW4zexp/VmvdEvWqrgpXVoARG4sz
   qmQBfuWGt5CtheUisrfN1P8lLr9u4w+As210ncUuylN9xPmz4Nyx2Gme1
   V6/3Kiz1QA/iKbhgWUkHN9neX6BMBdn5owXE3xfaM8SBfyji9A6hmoOCS
   vGBhW0X5Dy8Hw3RMvUyBZFGb2MOtObGspFCwcg2mUsdef7ytnevzEuwSC
   w==;
X-CSE-ConnectionGUID: vgDJ3wGLRkyBdDWeMGCc+w==
X-CSE-MsgGUID: znqb36LARvCDQs2S0Xz73Q==
X-IronPort-AV: E=Sophos;i="6.17,302,1747699200"; 
   d="scan'208";a="1403455"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 23:26:08 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:8848]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.170:2525] with esmtp (Farcaster)
 id 1f517b9c-a5d9-4ed2-9cc8-20113cac2a08; Tue, 19 Aug 2025 23:26:07 +0000 (UTC)
X-Farcaster-Flow-ID: 1f517b9c-a5d9-4ed2-9cc8-20113cac2a08
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 19 Aug 2025 23:26:07 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Tue, 19 Aug 2025
 23:26:05 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v2 2/2] efi: Support booting with kexec handover (KHO)
Date: Tue, 19 Aug 2025 23:22:46 +0000
Message-ID: <9e80381d4fafc71d6e0c64d69a8b3ac9c8949865.1755643201.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1755643201.git.epetron@amazon.de>
References: <cover.1755643201.git.epetron@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uaejgkzm5j98e98ydxx4nufeq9kd3x3f
X-Rspam-User: 
X-Rspamd-Queue-Id: D5DE7140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755645970-541765
X-HE-Meta: U2FsdGVkX18zHK6IVEtXz1rVR5qr1V3xS2Lrlzg+4GsQZzRJ4ZtOWu1ZZ91E7U0mfJYYb8Rqfz89sD1GqqUmUtTcy6zFNzlzLwT6+7bjrjz2iwUF4XNvayLDXUk/A1PCsChuakJlggPuKHaR+StXDoCFtW136QG/lKCByU8Mo+GfE98rNuMVGB36Iyx78m8KUlmAFibKB/S0VzibtYVVMetPJ7NxSmvvFtbWIlxALuQMl/z0s9w3tDjJVVhbd7/OSMzq2pl8tghR0EZzuSFIb0is25bYIR7+Ia1QNcWhzx5hH8wOWTsL8/vXR7+tJb4qMtsRAJgXsYWWFtOz1rbY+qDjVsb7zDexoVUsVAisCVpBU0wQNfSIrbCipbIR56X05fzGBwsBbTFltDiXguwwKLBZWMwyjd2/08zd6nzfa5aXAGTISGK98Dk7OjBRqvw/6jXGRfhFv/u+hWRV+bwl8XkIGtjn2kMAAihu62UNCeKF7/Q+9IEiw7+Ozcd4lJwKiNyC5KZ08zWjs/oxshRwY1rzupfP77vUfH64dQNDhdmomayDFdJWP0Nz38ooueaeiQyAyZnBA9MabIH4zXuaXYDDTbK5Aak033MrQXzdiTsP5pEDeYCECXQMGtMQNa1R1A+CL1l69eCnzglejn5KXb1B1WNVDqMuVolTOGXvlIp3Q1bWJrudGuNCpqOabj77lCrHklkbpdLnDvrGiRkPJ3NxErNTQZKUd7excCO3Oudj/NaSTuv2f1PFlO9Y/6+m2rJ0QwgJJQpbB7q+SIwDxb4zEo9asb+NerqAM23M38M/d6nJE61GMeZlWWWy3OVotOrnWWlcDO7Y8F3KQFdAuzddc0ROOtEPcZ3phU/YUmq/fejF7pzevC7lD2ZuPb5l+3H7D3fPkW6m7UgCq6g6078lpCV2eaFSFdHg7cjjZiCTZgTh1RfFhyGZUhMibTzb3Jmat+b3RNrmby1Hm8u
 3nPRxrwE
 dl/LTsfwL21FWCEGTG7xiOgLYH76jH0M+R+w3ptKUVMx3iFv+7Tt5x3efBWYoJN6RAx0TpahZTSFkDfYUpXFD4JmrUixS7qVtZD1KknYS19pLzUxa+Qn2zYr3wFrxQAIkg3LwSSwU+qDp4zCRUvOZHqnl3/qjAEZeQNtgotWtgz/uJKCg/ELZ8/3bLFHUalF/sV1XXbY9x6NeI1Cb9VnoPxuSGP9AT5gNP3bSIZLGukx0fTFOOfTA3TWo/5TEuUtA1eVx5+U24IsKHoLcJjYkjlX8a1wyNRZC4PTLaqYowVnN2bhJNMQnkZxMl+TCIdkdO6tLIXZffeK5a/SI8rgDN7bSHVWNMvl6XBEsYVE9ZK1Qwip61RM0CAPPnUz4T3LoQPIsh2SwB7Jd085hflve3IA3kZRrktmOIRELjoTfpbeCa/o/iQLGj4TNhs4bByKVoW6RhgBZsGL+JHvqmP8LpMjaX0mYyFOzd2R40PLgmftmsbV3jXUwY6u81HaaJeaYPcvC
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

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
Changes in v2:
	- Replaced the for loop with for_each_mem_region
	- Fixed comment indentation
	- Amended commit message to specify that scratch regions
	are known good regions

 drivers/firmware/efi/efi-init.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index a00e07b853f2..99f7eecc320f 100644
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
@@ -164,12 +165,31 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	/*
-	 * Discard memblocks discovered so far: if there are any at this
-	 * point, they originate from memory nodes in the DT, and UEFI
-	 * uses its own memory map instead.
+	 * Discard memblocks discovered so far except for KHO scratch
+	 * regions. Most memblocks at this point originate from memory nodes
+	 * in the DT and UEFI uses its own memory map instead. However, if
+	 * KHO is enabled, scratch regions must be preserved.
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


