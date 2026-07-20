Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03665C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41AB6B00AA; Mon, 20 Jul 2026 08:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAE16B00AB; Mon, 20 Jul 2026 08:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9EC6B00AC; Mon, 20 Jul 2026 08:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE09E6B00AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:04:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33AE11A015C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:56 +0000 (UTC)
X-FDA: 85009023792.22.44D77EF
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id D818980004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MKkThkmp;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
	b=DxoheaVANsb1W4JPEDyV4sI/IXAmIEkDzkodjP8MQjxbqJ1oHtkZmykusX+0pq+CV9vv49
	hxoRCUfge8nlyCO5dJ8jSQMHMwWuo/U9hHXi1SKXFYWnB/Sai+u0jW0NxYxWivwb20sRQ2
	brh5EBqYPJtE8lDkdmht/Rh4NQJIXIY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MKkThkmp;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549094;
	b=jaGiGNzx3p+SK0hmDKTf5DOTsitc0sfnYqwvDobhxOFCjkl8lzrHTWrQ1Dx6NkgWnZl6s5
	VTRUtlXEjmYcd+tASdQMdKcwql2QRYgD1GeZU8uaomqOszsija+w7FYJzIlpu+8cUJAHpO
	fpqZtF1q4WusE1559xF8bh8eup8gSEE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549089; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
 b=MKkThkmpxcdr6LsNiQ1CwvAcMl5Bh809QG1scSnbHmo8zOENjkL4we8207B7Z4lWHKnkR9
 Wp9gMmhr0HGGO4Ac6UTuR3UWBzlMzs2016q9wCn+nGOrbObExBSP1kvatYto46qLgRfzn1
 i4c88r5e+alX7rC/VIF5Z0hkGfoH8PZD7rdXAEBM3tbvUZYLpbZY574mfVcYgKAaoO1tTT
 WvyEmJyXBlJ+lO1hhKAj2f1H8dA08WoRHeavYJ2CUcbljd75mKH2K5VrrcWe5su/MzsppL
 9h6No8WMDjVNP70NvlMr3TApC+0HPJArwgckKCBh/4zUrFFqsYNNr+nx/2ZPjA==
Subject: [PATCH v7 2/9] mm: factor zone-device page init helpers out of __init_zone_device_page
Date: Mon, 20 Jul 2026 20:02:52 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-4-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a5e0edf+993748+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: D818980004
X-Rspamd-Server: rspam01
X-Stat-Signature: 9g3wper6eykgb9pmpo8yyc9mode8fdxu
X-HE-Tag: 1784549093-485818
X-HE-Meta: U2FsdGVkX1/tLAD0uuycVmaPmfPQh/NJWHIoE/kV+e9BGGegiXsUYue10Op3dIS67XL/NuWRnLrSaNWgTyDbkPMVzkIm0p5111EAsN1JjaC0EZ4yncMJm2WKvD9aHjhlgk1xKdsp3HuwinVBUVsmYRxsPAmprTBxnVaB1BXw80HBZMer58xHYVm0K/fOrW/kms8eU/3YO+AHnykyDzotqgecRhN8s0x+FD6lWayTw8WAyFjE898B9UjWUbVeDGzKFhK+Nho58OvMFy5SiSO75wxH7wYnWChvnmIuNCGK37IR/CHONcEIOvN1sbNr4Jzyk40pabFxC3IZFRLRx68dp9oKjk9iobIrzevXqNhmF9SXOBAo+R/J6ksZYja1iwEwvgSjwyBdHkno6CgSb51FnrQSEMaIw/EDo0OhnXw1kstYsnYNJj0THMgtKnnhZCgQfmU5rIuTMtarq2nKKrMPJ+S4pvmdrct8zT6WfoPoydxqHfV6wW9crU3Owk6dmOcFJvt2eaVA2X99RHyuBKho55vKRN7kYxW7CPrvRZJEcgYu+iOcVHx46TmwjwCwNHerC2NtfpMca0ZO9pueTZ0/njefZvcmEoer4P9FxjR7Z2DvhBJt4m8XPVxvkiuaxVZ6IeTvd9cfwd+EZ4sjaErVTZYjjo2/VTTLw9tYajlRMo6aEMow4fj3YjLb84FJrU3/XBX6UznYVDGxv2gx3x+t9iy7Xa4/Ab0mvhwtZoIR2rVvGcmxMDRoUCw301cxNIR64APQ0/lRiGowSCHsrQy8pYctyGQYaMi/exc+Q31bvebN7I1K6BOiE1SLsnZ+dDEjUM4ExMxVXwSPK7pD5e3OYCDmTV4Lvn5sBKzUc1yNGL33NTDZGo9361SyV0ECHKlAQgYtZtmuL0uJZSLswcxPnan5zwkPgUruukIRfo1cdatC5/sXlPMp7FE98LIeU6br+4YObVR3gdF/uhjaZ3g
 mfXtYSvR
 GRbqdCjQgG2MJXn/WDf5zwxsbYUdCrADxYZzINkaZAbBLj86dedcvtsPL64SrOwF/U9vN14JlWN/nG3Efiz8adYOw1//gyw9jZNKjuVpCVtn4ENG3L/g+8Kvgtj044+6+XrcqSmTDHmySdOHkayNHWFhxLo3OwLC4EYzEj8p6js58tCAohBrPyjO3ZP3BWbd5XAyke4nPL28o6sORJj4i+3zdtY3m72ReoM1Z+Otexngkfd5mW3Z3pEP5xCMgdIh/CzSkRV14WN1zRhVVzbJmyxtmDR7naT32DT0aYN5Z5f01DskBiRxJcBtStRC+8aqGZm2M3mHTDBViIMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
move the common page initialization into __zone_device_page_init(), and
wrap the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..a70acb7431a6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when memmap_init_zone_device() must initialize the page
+ * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
+ * the free path, while the remaining ZONE_DEVICE types start from 0 here
+ * and raise the count again when the allocator or driver hands the page
+ * out.
+ */
+static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
+{
+	/*
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return true;
+	case MEMORY_DEVICE_GENERIC:
+		return false;
+	}
+
+	return false;
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
+}
 
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (pagemap_requires_refcount_reset(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
@@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

