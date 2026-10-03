Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1E4CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985C06B00B3; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912656B00B4; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7898C6B00B5; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEB76B00B4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1438160497
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:54 +0000 (UTC)
X-FDA: 85279412148.01.014239F
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F76F40006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JBnXw7ib;
	spf=pass (imf12.hostedemail.com: domain of 3n0rAagoKCJI5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3n0rAagoKCJI5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp+JasK82C1RW+o2wrGx0jSXA4z4FWd0AFKo27jNBek=;
	b=PEA4GcSRBB3YyigYjf1T9/TAq+WKMZNvxM2bg2fIy745RBe7DgneFksx9X3SpxegeOo+eZ
	rLEB3c4Xt6KsVm6Uj4BID1/4Zh4562jFyMB25c8et6fxZ8+Fu5aXB/g6i7BTMMR5aPCpCW
	5Q+oav+zh2Z1q+EayA1IFde9gVNpcfk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JBnXw7ib;
	spf=pass (imf12.hostedemail.com: domain of 3n0rAagoKCJI5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3n0rAagoKCJI5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986913;
	b=3ji5WwNQUMp7+w1VbFvAGSaEGj5tHLRojMq07+an/zAKuBqMpCOp0gavlMY00lPF0hwuUy
	anGTovWVLDOd6CuOGZHJtgipXm4qj5zCd7+XXOC3x6OWycvz5dIXeQElK7fC94B8F120G5
	ZeGH4BWcw3QI2/zXy9tFQ6GaF9Lj+bI=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so107005ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986912; x=1791591712; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qp+JasK82C1RW+o2wrGx0jSXA4z4FWd0AFKo27jNBek=;
        b=JBnXw7ib2co44RKd112HvBsfVtxmqGnM6a5tfh4dnL9Fa9R2RAh/+vRk8nJG9v4oCw
         muC6f/vX4FnLBZC1AQAssEY4XFYhKVk+3px2mL3faE5vkDUWffHjO5uo94NVufFIk7Ql
         CxrieP6KcvTn/q5bqElt7UcnWBSxxvDihrZdnaLGh6/c9QHkj6iacY1OMJngbFUj4DrI
         4OzdyMizWxKNq7/aq5jnjTRTMo2X0elAnD2fDqDoRQ4dhiLs65tpL0IxdXBUpzovHKK8
         gWCTuJXQuMJeUnc4BisCvtt5H5hZ/CvhFdcRzR5viCHBb+pDLCgnvai8zUh2TNjktYdm
         jMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986912; x=1791591712;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qp+JasK82C1RW+o2wrGx0jSXA4z4FWd0AFKo27jNBek=;
        b=fLhGagnZWnK4MpoLYOwGIkaj+Nldmhy7tWRbECG3J3nC0of5FjFYLZhZSp84JSmlPC
         rCexnR5pJ1BZUm2CWYf7be0/R6c7GFA74IqgPUVNSYZFtbbGefx7PxhIEnAtQ31xFrVF
         oVAXwBlLOuIo5gIfbO15sCpojYHXtyMLrAwIPMRodQmSZ7LePiwxNEoMnPBnZlJO6siB
         Fq5PujqaKu4kZ0Tqvc5Yt3bb0f4z2kLOyCODRkbJ9Pa+JOHeVFsmOL7YRpAq1WQv78/r
         U6YOmPNpsufr3AD6kKDIXBRHFlGA2tGsZOqb/897gCKv7g4x6o+NWROldPUlgjyS/omH
         4yGA==
X-Forwarded-Encrypted: i=1; AKwUvBxOAL40ViZbNH5nK8qN69hsnNnvB3MXvF3gnT/HqFgMDrqe5pZRgkj0GdHOf+MaTzq73jl8j/rQSw==@kvack.org
X-Gm-Message-State: AFq9FYJD0RScOe0Vwh1lOCuTxqngqRm1mPoq+2ztIAIlH/G6+bD3C5RU
	SqAjG2a8ZM/G43eGX8hfCWHN1GEwX3NOt8XdDzdWXtVVeCX5itmw9viwbpuCl4/mGQL1Td6KyL9
	tg8de0/sbUDm5ifePtkAWPQ==
X-Received: from plpv6.prod.google.com ([2002:a17:902:9a06:b0:2df:660d:f283])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:37c6:b0:2cf:8131:75e8 with SMTP id d9443c01a7336-2e49b4e29edmr36276715ad.13.1790986911618;
 Fri, 02 Oct 2026 17:21:51 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:22 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-20-jthoughton@google.com>
Subject: [PATCH v2 19/20 DO-NOT-MERGE] hugetlb_vmemmap: Add fault injection
 for in-place vmemmap PMD splits
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0F76F40006
X-Stat-Signature: 9ugtoknb3mwpynq1uuk3bk53rxu7mutc
X-HE-Tag: 1790986912-445865
X-HE-Meta: U2FsdGVkX1/00gppH8nft5H9ofyA+qpCiFgMrW1DqL3x0RiIzYFcIaWcNDaHUiok8vVnajPH0g51X9lDn7HeWPj2wv8sMWcuJCmTyKKCTIBraeN39B705RXBAtyiMYxSQcjMcC5DzuQ5I9yowAUVR692wzJwmsHyz8+UzYJnFt2lZ7F473NTsYq/XxfBcl+Z29zyDEPL7FEZDAQNdrAMBxHNqW0Kyn8Hzm/88YVisXMA4DRAE8aWCtm5wnPIN/CFBvuz90HURVUEQol4cL1WBIr48/E8GmuCiTWRJ8zyfG4sqUrfvWzuIPrml7/w6HfkLBDsRxxXOwqFM4Z0dF2SUNv8SNBtCdnQYFXLckKbsVxkWH+nFM0niEE4ce/9vF7DrHwShiSKdL+H/u+JlklUcMAgKK7+kHaMAO0JWNDYmlmWQye20vAWv5e/SnDL4IEtbombUqwlUqfyrJHYZOfvISX/5Q3vo9GHgutntlvk0Ep/wh213A2V7kCtoF141VCFhYRSmU+V2g+1cb6CFb1O1f50X03mEQyQSuEas1AcRi+9IsFhUEjsZLznNpTncfpLRgNxyyR1xYiAgmYIIgj/yb9b4J8Dd9YIarF3YU5UTNZmtcxzModeL/TFG1wl7Deq9Z+nO555d8VpqquvtpLSd5DC8y+cxr9U947vU8hoK/0PmUZcqPCWuExlOWUa7bHwUbSKsQO/SVvsqh91RpKyH+R9SHHsyF5e5gmikmvlAPaiOGVJ3wNJgqgRm31J9E/++s5wEc5l8bEgIN8qDYBIOGC6gWjL0C9012U+NpQjEIaJBY32uSRnEmyLJn69+k+oAsa3UIV/82J7gT/+Q5ZUFleVtB7UlEwfzEj56r/fLcIDEXtWgTPnlBl3BZ3bCbZ2hW5eqHxVq/ahcoAwfBnDFKjR+zcJkQRGwMW/FhSLZfk2bgGApXjbXJs/zdNxzVwJkukAPElLUWecivCWANo
 yA93AHCa
 Lck/olqvtJ+/zL7nScW6cv6rVqhg4kfh303kElfBt5z5MG8hDrvV0O7Y4bKQTF7DdSKLnKpNbMcEgd+9TVhWtpGLVGQkWAmDpGFABjbCGRAZeRxMiPHwUrUNOXxjzRmg7klAYI8Krz7MKioiSQN7CMzr90A6yW/R40Fm2Czyn3goQxunR631ZL9fPVWohmdzk9dJLgK2XPeaw0yzIz3+aAxTMU3JpGTRCsoHJ4Xpro+AYcn8kP+XsdRPJwGfgXVewvLi172KB/OlQg96fHTSXOOs9AVciw6pZsTYUG8TXVvSPq3q0w+bVsEisI/QZwfENMMTgJ55OC4GzJyZyXMJOe9BkhQTcAu/nTzH9aVKAyMvcyJIdxFn0Jr0J7MG3b6vjEW+F/T+1oPG/w403FIIlB6DG8PmP20qpmyeNNP91yBWvd6jF2Y5c+x7kjgy7yuvSQ7wFtIKmLVkbLZzb3Xo+aPkHQS3PbPXzJPvhR2S2b0WwRajyPkQI0F1ML8FSUFOO737G0oFdQ9qWPd+R8xjTAIxjK8C6ITwmmLG+DuNg6IUPSMa8TAYQJxcWqM/NmvAyVoNCd5bULy4TpYxxZsG8Qv3uRW2spos4V+MpWzwboHtt5KTtOp9jmVNp9VJ4N+wkw/xHffwzOlx50f7E7VTDhby7GOxR5oWzJKJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Like try_update_vmemmap_pte(), try_populate_vmemmap_pmd() may fail,
e.g. on arm64 when replacing the block mapping keeps racing with
hardware access flag updates. HVO handles such failures by not
optimizing the folio.

Add a fault-injection capability, fail_hugetlb_vmemmap_pmd, alongside
fail_hugetlb_vmemmap_pte. When a fault is injected, the PMD split fails
with -EAGAIN without touching the page tables.

It can be configured through debugfs or through the
fail_hugetlb_vmemmap_pmd= boot option. Since vmemmap PMDs are only split
once, the boot option is the most effective way to exercise this path.

Assisted-by: LLM
Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../fault-injection/fault-injection.rst       |  8 +++++---
 lib/Kconfig.debug                             |  4 ++--
 mm/hugetlb_vmemmap.c                          | 20 ++++++++++++++++++-
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 403206645fa4..5cfabea811da 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -16,10 +16,11 @@ Available fault injection capabilities
 
   injects page allocation failures. (alloc_pages(), get_free_pages(), ...)
 
-- fail_hugetlb_vmemmap_pte
+- fail_hugetlb_vmemmap_pte, fail_hugetlb_vmemmap_pmd
 
-  injects failures of the in-place vmemmap PTE remaps done by HugeTLB vmemmap
-  optimization. (try_update_vmemmap_pte())
+  injects failures of the in-place vmemmap PTE remaps and PMD splits done by
+  HugeTLB vmemmap optimization. (try_update_vmemmap_pte(),
+  try_populate_vmemmap_pmd())
 
 - fail_usercopy
 
@@ -269,6 +270,7 @@ use the boot option::
 	failslab=
 	fail_page_alloc=
 	fail_hugetlb_vmemmap_pte=
+	fail_hugetlb_vmemmap_pmd=
 	fail_usercopy=
 	fail_make_request=
 	fail_futex=
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 96cd1f1da94a..7abda377c737 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2072,8 +2072,8 @@ config FAIL_HUGETLB_VMEMMAP
 	help
 	  Provide fault-injection capability for the in-place vmemmap page
 	  table updates done by HugeTLB vmemmap optimization (HVO), i.e.
-	  try_update_vmemmap_pte(). This exercises the rollback and
-	  partially-optimized folio paths.
+	  try_update_vmemmap_pte() and try_populate_vmemmap_pmd(). This
+	  exercises the rollback and partially-optimized folio paths.
 
 config FAULT_INJECTION_USERCOPY
 	bool "Fault injection capability for usercopy functions"
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 9e0f52474bdb..f50880dd79a2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -53,6 +53,7 @@ struct vmemmap_remap_walk {
 
 #ifdef CONFIG_FAIL_HUGETLB_VMEMMAP
 static DECLARE_FAULT_ATTR(fail_hugetlb_vmemmap_pte);
+static DECLARE_FAULT_ATTR(fail_hugetlb_vmemmap_pmd);
 
 static int __init setup_fail_hugetlb_vmemmap_pte(char *str)
 {
@@ -60,11 +61,19 @@ static int __init setup_fail_hugetlb_vmemmap_pte(char *str)
 }
 __setup("fail_hugetlb_vmemmap_pte=", setup_fail_hugetlb_vmemmap_pte);
 
+static int __init setup_fail_hugetlb_vmemmap_pmd(char *str)
+{
+	return setup_fault_attr(&fail_hugetlb_vmemmap_pmd, str);
+}
+__setup("fail_hugetlb_vmemmap_pmd=", setup_fail_hugetlb_vmemmap_pmd);
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 static int __init fail_hugetlb_vmemmap_debugfs(void)
 {
 	fault_create_debugfs_attr("fail_hugetlb_vmemmap_pte", NULL,
 				  &fail_hugetlb_vmemmap_pte);
+	fault_create_debugfs_attr("fail_hugetlb_vmemmap_pmd", NULL,
+				  &fail_hugetlb_vmemmap_pmd);
 	return 0;
 }
 late_initcall(fail_hugetlb_vmemmap_debugfs);
@@ -80,8 +89,17 @@ static int hvo_update_vmemmap_pte(unsigned long addr, pte_t *ptep, pte_t pte)
 		return -EAGAIN;
 	return try_update_vmemmap_pte(addr, ptep, pte);
 }
+
+static int hvo_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
+				    pte_t *pgtable)
+{
+	if (should_fail(&fail_hugetlb_vmemmap_pmd, PMD_SIZE))
+		return -EAGAIN;
+	return try_populate_vmemmap_pmd(addr, pmdp, pgtable);
+}
 #else
 #define hvo_update_vmemmap_pte		try_update_vmemmap_pte
+#define hvo_populate_vmemmap_pmd	try_populate_vmemmap_pmd
 #endif /* CONFIG_FAIL_HUGETLB_VMEMMAP */
 
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
@@ -113,7 +131,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	if (likely(pmd_leaf(*pmd))) {
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
-		ret = try_populate_vmemmap_pmd(start, pmd, pgtable);
+		ret = hvo_populate_vmemmap_pmd(start, pmd, pgtable);
 		if (ret)
 			goto free;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


