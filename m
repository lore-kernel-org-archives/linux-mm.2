Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EC1D5C0F2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22816B008A; Tue, 16 Dec 2025 03:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFDB6B008C; Tue, 16 Dec 2025 03:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0106B0092; Tue, 16 Dec 2025 03:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8DFE6B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:49:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B567B9C33
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:49:31 +0000 (UTC)
X-FDA: 84224710542.24.1FF9717
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf15.hostedemail.com (Postfix) with ESMTP id 422BFA0006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:49:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=EZyfvSVs;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765874969; a=rsa-sha256;
	cv=none;
	b=zvLKFwKkJx1yKx9CEtKmOtOkUByEeMT31Y9I8cAf1Wb/QJHji604+/BEtu5RUVpeWHYO3e
	oHRp+0/VRGUL3qt+e4Z4jKu5obR7k+3ZazeQCgJ5IPZ3z/gi/sCAYhqpsF2kQAHiI3rj93
	m4nzq3its6fxx65hpLN8PUS2kQUV9K4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=EZyfvSVs;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765874969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t9GVMSE5QYBAq5Na9iKzheEhYI2L9XOqJpGx0SGLtLw=;
	b=eLARyNeeh/6cFUPRZiOWx3MX50ibHT6tQf/EhNZ9MAA/BGdget3DDiVOfqS3ViLB2QEn6X
	PXat+U6RNWyziP3CmJLNAwEiW0u1nt3a9yiPTTKGremd6iv0lWllrfOwW43eaBD81GqZB8
	Jsw5FpMt4SKBO4xzpOqKzbQV3m3MdVU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1765874969; x=1797410969;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t9GVMSE5QYBAq5Na9iKzheEhYI2L9XOqJpGx0SGLtLw=;
  b=EZyfvSVsG3o6Gqdyp/u/PiiPbis3WnizIVyXqZGrNHR43m7QCyUVJyGm
   iyjpbTjM/0x1sFCpvFmE7eFzLMOMj5fA8QDRCy1+TthbBIM+WdDQhc9LU
   iDif372MsJSaepI4CjgDYjnXjNGvVSiUIT52PTrsddE75pVag0Zl2uhza
   l39SSM2Ixzslc/TJbk+ehBLJNs9VPjQ7Ne/nY2+SyKYl5nZIODAxFiNen
   rA+9Ro8mwwGnmuGCO54plrB50ACSgydnOmaIdkk/IJY3dx2o1XZvk3LJQ
   TBoGnpoeEdb02tRt+to3XXEXVVUP2gYpXdHGiJ9lxCrGn7LproGj2jx7k
   A==;
X-CSE-ConnectionGUID: AB8P62TDTxCVBKRB7W9YBA==
X-CSE-MsgGUID: giJnBZetQTewkmJV4jC3yw==
X-IronPort-AV: E=Sophos;i="6.21,152,1763424000"; 
   d="scan'208";a="9165717"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 08:49:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:20952]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.21.145:2525] with esmtp (Farcaster)
 id e256b7ba-6e38-433a-93d4-84c8c1e4bf24; Tue, 16 Dec 2025 08:49:25 +0000 (UTC)
X-Farcaster-Flow-ID: e256b7ba-6e38-433a-93d4-84c8c1e4bf24
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 16 Dec 2025 08:49:25 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Tue, 16 Dec 2025
 08:49:23 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, Jason Miu
	<jasonmiu@google.com>, <linux-kernel@vger.kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH] kho: add support for deferred struct page init
Date: Tue, 16 Dec 2025 08:49:12 +0000
Message-ID: <20251216084913.86342-1-epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 422BFA0006
X-Stat-Signature: jbe651pzk6y914x6gyc5oaoxscqjuz4c
X-Rspam-User: 
X-HE-Tag: 1765874969-793451
X-HE-Meta: U2FsdGVkX1+kmMtKFVv7JqPojc2VnBmG4GdgViQkqfhCq5cP4RGFt6gULhSaSy1AtUvgedkQvkWb7n4hOv88MfrdDOWUMoGk7tBpduAQhUHUef0Q6cbPdNxvp9TvCpo+z0VT9POgc5aQdUXt7yGh1YDkSQHhcJMax95+iDE33lkfdYzwrv5UHFHXdkGBSJoblWxugEU8rhNqsr7ga3S7UTRPIuSUHRiz3FEdYt5/tPi2GX9TaMvM9V3xnKXvJ5m3vH43K9t/BsxpaR36t+wbqISlVwBYzwQwSaE3w+z9mexcqrKJFnwyLDOZ6LW9M85l65B57fTenLJYOrWuIi6Vd6Jbwr1SpOMoQWg5b6AU4xbuDq+SzkwdBtlG6RiMhibY4XsEBQFPrKxpoSf/Efarj0ktXuNofz+0JI2kQJ2BmN0G5ax++tMdssVpHcJQiIy5RPlv1BdUNTLCCqTS8nLKTmvGWWkGbLl5K68O0BEdOqa0Mcx/WMrmBZqcwSX1H3yiIak1E6LnZsXqr25TMLVfa85BRxWIQzEpNFQqfqqETC1KVZTACMeR0GJvkF3/gTAPlvzUzWoyz2X1vyPcFg/U5h9bylLbP81OXBuJNztZRr+Y4gBPR9OZLgviHniXMM8FjNDIJpXX0lJNgQxi+EL0hfILAf0b5C00ZXebAlLT0t71qT6kPGiyk2VhnPXZKO6WINTHbpYANosKCZfVFyKEZiJ39k5rw6xgZJ0MV7xsn+TTY1AnCx02TSDLMuh3/S2H0yzNerfFEjMsMXztwoC9MWmM5G2qZtlOS8GBp8ISVray9MDzlkdQ91xJ2V4r+Jy5W69XqfOlqtWFNivaM54NEDjJS4t0EBxupNMPnbevnR1FdlaQI4P/rWCOp1HDilD4e6xkd/H0stnWVfpO6THCiX1E5MfyiYM1ttm6UY8t5AjmX87pjUipK/Vl92mz1M/3IWDTFFlpPpKH5LzS36N
 vOx/Pv+u
 aeFBKtCyxH6MoP1DStM1QZlw2xMuE6sJODr4FL6B7fkCBxL2GdnxQnY3kfEAuksl1zhHRXd/rSZm6YHWMq3ZtUEsUgVo4/2sBlx7KyzXfY+52InQ+lEYKMpOLWjmfO8vSVDilfQ2Vg34gM6wbcmvCqMCmiKPMxcTOGeWsI11kIb2ugLpCVpcRfq0Syl4b3otg20r8tVoR0aOkQKLUblN0ll049h0iyCaegh7Q2V4KFp2cq8Rq6+JiXILPpCzd5FlThKnV24VVcTTwrdMUjbZKiHXYMAXHJfp5NXwtzpyZO6ixxlYhNw7eSSCnau2rPjcmGP5Tvxr4228DRYZkNca/YwI2buWIy6WuTSo1TM0m1tnRngulW/d4KzdhhiNhbtsexwG46MqlHnG8LIQCmQxWuP5LqVKV6d0qxVlx6khNFCOQ1vPTUOkCUBYKM5P6Jv8UmKencB/0NBa6Thbe+bcgbUBTlwxX+qqnVwBLWquYc0O1atIMjZRDoY8zU5t+O2xRDPKn7NT1PIBFPUw0BzppE3uEN0/3d8dPvkNE0U0/cxMbeiFqv0nVNVaTk/k627x3/i9jiH5lIyZ+8fyMf/r0hdhFx/P3d9TmRMje
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
initialization is deferred to parallel kthreads that run later
in the boot process.

During KHO restoration, `deserialize_bitmap()` writes metadata for
each preserved memory region. However, if the struct page has not been
initialized, this write targets uninitialized memory, potentially
leading to errors like:
```
BUG: unable to handle page fault for address: ...
```

Fix this by introducing `kho_get_preserved_page()`,  which ensures
all struct pages in a preserved region are initialized by calling
`init_deferred_page()` which is a no-op when deferred init is disabled
or when the struct page is already initialized.

Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO")
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
### Notes
@Jason, this patch should act as a temporary fix to make KHO play nice
with deferred struct page init until you post your ideas about splitting
"Physical Reservation" from "Metadata Restoration".

### Testing
In order to test the fix, I modified the KHO selftest, to allocate more
memory and do so from higher memory to trigger the incompatibility. The
branch with those changes can be found in:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init

In future patches, we might want to enhance the selftest to cover
this case as well. However, properly adopting the test for this
is much more work than the actual fix, therefore it can be deferred to a
follow-up series.

In addition attempting to run the selftest for arm (without my changes)
fails with:
```
ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
Bail out! ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
./tools/testing/selftests/kho/vmtest.sh: line 113: 61609 Aborted
```
I have not looked it up further, but can also do so as part of a
selftest follow-up.

 kernel/liveupdate/Kconfig          |  2 --
 kernel/liveupdate/kexec_handover.c | 19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index d2aeaf13c3ac..9394a608f939 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..78cfe71e6107 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -439,6 +439,23 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 	return err;
 }
 
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory
+ * regions may not be initialized yet at the time KHO deserializes preserved
+ * memory. This function ensures all struct pages in the region are initialized.
+ */
+static struct page *__init kho_get_preserved_page(phys_addr_t phys,
+						  unsigned int order)
+{
+	unsigned long pfn = PHYS_PFN(phys);
+	int nid = early_pfn_to_nid(pfn);
+
+	for (int i = 0; i < (1 << order); i++)
+		init_deferred_page(pfn + i, nid);
+
+	return pfn_to_page(pfn);
+}
+
 static void __init deserialize_bitmap(unsigned int order,
 				      struct khoser_mem_bitmap_ptr *elm)
 {
@@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
 		int sz = 1 << (order + PAGE_SHIFT);
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
+		struct page *page = kho_get_preserved_page(phys, order);
 		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
-- 
2.43.0




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


