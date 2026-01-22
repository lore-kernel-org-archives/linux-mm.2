Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025FBC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0266B0174; Thu, 22 Jan 2026 07:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EA06B0176; Thu, 22 Jan 2026 07:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3705E6B0177; Thu, 22 Jan 2026 07:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 246DC6B0174
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:18:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E96A01A028C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:18:05 +0000 (UTC)
X-FDA: 84359501730.08.962FAE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 40468180005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:18:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8OKixc2;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769084284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=l/jbOXRz2UxbzZ3+gwMR/HUDE0ALp1ml2pDzU1///BE=;
	b=o1NbpP9vZGi5T8ThuxlsJPbpJ6T3CW9mXTtLfv/w1vSlH6cesvBNWgIFe3tpDhUv5fA+Z1
	YGO/fXd7WaGcooOX66Q/nsGy77a5r0ZX5A7f+cXydN+02mZVwPRZyl8nYkue04d7A5Kg7P
	OaIy70v9EZJYCMrDz02e95un8L7ZeGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769084284; a=rsa-sha256;
	cv=none;
	b=vQqkUWv5PImC/q6ASCNpOMBJzkIbQgo98IWzc+XpGPCENPJc3EsZCTomLNtSz93N2Bxrid
	5FoA7JFXv0F61Vc2qTMtOkwKaokzmJQium3Vo9EcNaucpjfm/D9ZSGOxYAl+wWbeMEP7hg
	ny3yDzipYIUCMHP3aWYkol/ofcPf8dk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r8OKixc2;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E0B3437E5;
	Thu, 22 Jan 2026 12:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7F2C116C6;
	Thu, 22 Jan 2026 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769084283;
	bh=+pKK6YqjCMJk2Ik3AjBYzI1PBFwRJgM5oBdefe1/cHs=;
	h=From:To:Cc:Subject:Date:From;
	b=r8OKixc2G/2NXhTyA+0uVZl/ZDMOjEaHITQyYQCFBafsKOn+b2PIkFccWozlddAlO
	 18YXHZZ+97eI/p7OC3F3DFcXbmIq+sgDcaBuyEr4pQ2+GoJPXFRMZ6EvWWC3FWH7Rw
	 hjc+jZt6nUszsq4VmpQo/p2ZD+okWpNpMOKCmMILuTjRUZ4/JtCvD4m4ekFCO+ENNb
	 UXDj+c8/WvFNyXlkBPNoHIfhJlVtjbyhyfXYcRBAguuMLVvs8LDXIHalDDpV+cBZkJ
	 PmuO/M7TiCItvBHXcog3MVE4QoAAYSi05Ii2Dzxkz8Eb3dzpDe98c3AXLfw4aPy+l8
	 /yPeLZe254KUw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <ptyadav@amazon.de>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] kho: cleanup error handling in kho_populate()
Date: Thu, 22 Jan 2026 14:17:57 +0200
Message-ID: <20260122121757.575987-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40468180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4o9ekm5y61pzggrbw5ziocbjywzw7jx6
X-HE-Tag: 1769084284-851093
X-HE-Meta: U2FsdGVkX1/vcGw0L67nmci1zmSUxNs6LcMC4ChZlQZQS+w+AESWaj692dPNDHIclGtlEd8gTIiXZn3yGDJlJjPbIItq9mhex5weAON59d7BHTKL8GYjcR12A3M5pJLNk18M0GgSdf3zqw8ce66+XtswPsECspnWBM1myjW9pa/F9Qd8ItSzpSPinSw1Hh5IVhFGkS/V4xfaBBBBPsIRvwarViVE5pJ6glh+Zyu/M9z7OpXSMMqAr0KYdLsXNynfU0eOTr0eq4+aid/DCgOn6HvhTnVTOxHKAaS+Pm76qGnCZQDcSJuCG6oTqAwC9uYWCPflgSg3zr+UD5Q+OMMJudpRcMO+Z1s0DxqjLiVIEDekM8Xpp79X4WQUL2SoDy8S4QN5j+Fteg6kW3BxTnJ+Ti8upYvwjc/I8Gi/ACzQiesbX9hQPgYPiwkpPZFOuHFyjbIkY1Qh7sx3EzieKUzZYbzhKf0n95Aa497GoJXDrDsTNcaBICXIQiaDQbCvSysoSR1V2E4NU0BYFYBKYM0wAJkKGIqtL5Y5e4t8OzmAy/mOmGXuu5/0K1/schyQk5M6F7RnPfjqGvrQag3ho06q9cbJNlukWXw5kCC7FoP0RjkwOiO8jjG7Nk3mheQilAZUGSxeYCqnjyq781ApbBjFir6S8NK80MFaKSLwxmIeWta1rwiNENzm0iuDlSDA7avVw1Hot6+hxVfRMxcSBnfAm5YOplS7GmUGDMq/grlpLtYhr0jbS+70sjzRUxLCojOebb3DR6q9tk5xhZJT2TOMh13VxeqNJxEW2ZSVUr+7VhjsHMq9+iDv/1pJV45CjVyn3yz/Ifro26iCOygTBWUSVzU62RDZGBocvLaQ41ZAHYW7NduJ67npJ3hGQqZ2mDYWHsECq6lpOGdd2SYU98GPZg1VMVIAAJnbSJ4Ffeu87W3qrWvzTAejDx22caSq0WgbNeFpoeygHp71lgdfCpp
 JvjpHm4S
 nwSfKnXYsgtl9y/2YqyBY2DQ40GRAh3w1E81ZSUByQU5VObJoRddT6HXn36Z83UH2HYfYI89mn4U/fr244e09lEvwQoKeeByBW8GXm60caKQ1k1HX180WB21ffIUg7sUckeQDOPSmX/lwNeBdKAAElt0WSLTtUyUXo5/NuyFHUSMZHRHywYkzlh+vj51vXb9NwDpm+Ryls/TGLAKen85CAgawwnAyQ4BhAqbY5tXmQOQbZgVL4+WzzB/g54EaltbwJHv7yNPu3Us9LCHjUeahdtoH+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

* use dedicated labels for error handling instead of checking if a pointer
  is not null to decide if it should be unmapped
* drop assignment of values to err that are only used to print a numeric
  error code, there are pr_warn()s for each failure already so printing a
  numeric error code in the next line does not add anything useful

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 39 +++++++++++++-----------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d4482b6e3cae..e248ce2e04b7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1441,46 +1441,40 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
-	int err = 0;
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
+	int err;
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
-		err = -EFAULT;
-		goto out;
+		goto err_report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
 			fdt_phys, err);
-		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
 			fdt_phys, KHO_FDT_COMPATIBLE, err);
-		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys) {
-		err = -ENOENT;
-		goto out;
-	}
+	if (!mem_map_phys)
+		goto err_unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
 			scratch_phys, scratch_len);
-		err = -EFAULT;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	/*
@@ -1497,7 +1491,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		if (WARN_ON(err)) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto out;
+			goto err_unmap_scratch;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
 	}
@@ -1519,13 +1513,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
-out:
-	if (fdt)
-		early_memunmap(fdt, fdt_len);
-	if (scratch)
-		early_memunmap(scratch, scratch_len);
-	if (err)
-		pr_warn("disabling KHO revival: %d\n", err);
+	return;
+
+err_unmap_scratch:
+	early_memunmap(scratch, scratch_len);
+err_unmap_fdt:
+	early_memunmap(fdt, fdt_len);
+err_report:
+	pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */

base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.51.0


