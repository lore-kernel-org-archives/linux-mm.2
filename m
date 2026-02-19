Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F197E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 05:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332DD6B0088; Thu, 19 Feb 2026 00:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E07F6B0089; Thu, 19 Feb 2026 00:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC546B008A; Thu, 19 Feb 2026 00:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2C16B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:49:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA1CB1C465
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:49:43 +0000 (UTC)
X-FDA: 84460129446.11.A03D8A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A5CBC0002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:49:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771480182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7rV/lAXNbUqLszq/OvG0p6hLe4ZaSnskVTcW4MS2a1Y=;
	b=5iLynMQoNBLkTzeaIbF/uv7n8BEJ0XRPlJKLXMAEF7LmH3SjjPXeK/YUCntJSRbksgoY7o
	T4KNWnJvHDYu/64W2GgfvosoGo4vpEDb2DoidY7Pj7kz4O5GIZ+PQCHf+vdJWStnWyLzMe
	ftlGmfSJMr7VGuVkijEbIZKryAh8qos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771480182; a=rsa-sha256;
	cv=none;
	b=WIThcJY0NaoyN15nsLOe31k6iOGz4bly3U/g2c6n8N2S+4lOgVqwsxY5ONmJD8wXl1+OcZ
	Tr91VgSnfcNvNQtpqPTaX7nRNW3ELWl+T7SboxEfW5eyJzdkvGjV3kXkgxOmVItCMXx0jN
	/gd7R50MLyez5HvWtgoT/aCJYcMXENA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2ABD339;
	Wed, 18 Feb 2026 21:49:34 -0800 (PST)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 593673F632;
	Wed, 18 Feb 2026 21:49:37 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH] khugepaged: convert redundant check to WARN_ON
Date: Thu, 19 Feb 2026 11:18:27 +0530
Message-Id: <20260219054827.4111334-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A5CBC0002
X-Stat-Signature: cge4kgt3jr8s8icxbfjnsr1bs5e7z1yw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771480181-788938
X-HE-Meta: U2FsdGVkX1++oRlRUFFAKD54ojZPhWCm0nBEkHzBEOW1KaRdIooyF/CSFMBOjUF88mxUKmYv5LcovpT5Z+G/3hZwGyZSnvMn15EVerIB/xoBLQAvRT5uPdF3S5AAdKIvLTQdCMnXycw6lihfHzRGe91CZIhPcr7KiZEGREcPXh8m9bnoOCaikNL+hUpwJ3CeuC1obGXtd4Um9coqyiatrmC2xpne/34zGsPPfwG55s63BafSXW82PbvAxgKKotGO6hU5y6dQGYfO+CcEPZf6ELhr/LCwwwrMa4fUsx+LM4PH63m6X7k4YOceaGRT6uhhv4rr5aJfys/Yj1pBPPJUuM2gYwx/zDKv0kTkX2x/EZaXogRibtatTMht7Z4yWhR7qtoEuy4cXdhGpXAiW74KikFcItaI1iSvqYjN49BumPrchWnYRtCjN4ZBEEHn5j7xMmk0EoYF9pRDsUGD5gPuCUAxPeEwQyTx7bBtv6cVIntyAlcteHpJD3U9K9R2EtILVPFa7mEh8NlX4LVs+hcoPfTyS+YM/7ud4It7KCdCFk4b3GLWCaxj6Q7aQrMWmXz3qmTu0Ml648a743Ao4Usr1ioN0k3jG0Pv1q8IwWseIAlc17HvtSYmXlWOemsmQjMKGUk4z2Y0Qx6pEl34tPnN6bVaHQkNhGLGrQ8XDwq9+N5sDaGRNrDdn2Li/wTPhMQ4q4zGCc2gaRqvhFcQ5C7P4QWJBe2oHAMMLjem4peP4SGPunSIE9uYtliJP/oDhYPp4L4Ohy+DDJoTOkhtQO/WM96IKiHZ4o7D3G9RNKdpQCVM/M1fztkTnUGnlAAoDXbOXER5yd+DXlGnveppTH+WCF32XUhHKGi3kUJNO0zh62it+69xePPKTKadyzoSgDslmOiBZrVpQX2XMgJSwglxfYu3fBB6a9cXMKmPt/deeX2SGoygzNb/PO7nEzv2XfYROztrTPEeZklw+c4kcg6
 cjC7gN1F
 nMzVyN8lcQ4BX0NWKImQTRiFiY2WD4r2yPteDA7rm3NB/57tB7s4bdZMMi7w726K7MSDxp4BCqHBsAmeQShoKmQNwj8fpsxE0CZil8GOiVz/RHYKgQWwqWM5faueToVm1EP8frFdey00FqsQP1RolxVJ0HUVgiMCmZiJhpT8l1xb95GyALs7SMKcvXaw/6WA1Td6C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.

Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
iterate on the xarray, have the invariant that
start <= folio->index < start + HPAGE_PMD_NR ... (i)
A folio is always naturally aligned in the pagecache, therefore
folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
offsets in the VMA are aligned to the order,
=> IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)

Combining (i), (ii) and (iii), the claim is proven.

Therefore, convert this to a VM_WARN_ON.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Based on mm-unstable (d9982f38eb6e). mm-selftests pass.

 mm/khugepaged.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c469..f27cbb4d1f62c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2000,8 +2000,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+			VM_WARN_ON(folio->index != start);
+
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
@@ -2329,8 +2330,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+			VM_WARN_ON(folio->index != start);
+
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
-- 
2.34.1


