Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69339EFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B113A6B0092; Tue, 24 Feb 2026 00:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8D96B0093; Tue, 24 Feb 2026 00:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA9E6B0095; Tue, 24 Feb 2026 00:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 899F26B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:12:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 460EA140471
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:48 +0000 (UTC)
X-FDA: 84478180416.02.20616B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id C998A1A000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TluUqlJoO0JDaYOrPvbW1pMETA1lm1IMn4MgEDIXoB4=;
	b=wM/uE0YVngS4FoZt7sZTG5bQuJErMdryPlrBGcV/MXsHG9QvNENhuLMzPMovtN/2ccj3PQ
	4sILxrSK+wSotvXARfahveZ0ZvJB93tLOxClJqW50iiz1qcxQrgmnHANfBXe61Zu0njXK2
	3LPd4sPCsDZVcD2nrlnh8sehPVgqcUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909966; a=rsa-sha256;
	cv=none;
	b=Q89NK/cIlo9JarU0PLn9EmH3xMNODDdtI9HdGUdklB+htLld0Hf6byUMbDry+fRYabAABJ
	b8Hn0YyxJ/AesfaD+9TV35LVbNm+EGQeoWUGAoiuylsZb6zDEzOOjNXfq4+4l378ANkvmb
	Fl7YoQu2aO1+LNTbueMZiSum+efvBbU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA859339;
	Mon, 23 Feb 2026 21:12:39 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 63A333F7BD;
	Mon, 23 Feb 2026 21:12:40 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Subject: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard pgtable accessors
Date: Tue, 24 Feb 2026 10:41:41 +0530
Message-ID: <20260224051153.3150613-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: oim8f31kgachu8e6kajjawncp7aq7bww
X-Rspamd-Queue-Id: C998A1A000B
X-Rspam-User: 
X-HE-Tag: 1771909966-328245
X-HE-Meta: U2FsdGVkX18ECSIpiHn925CHaxqGlcavvyh1OF6GWwDiBlvrwC5LtlEY1fqOn4vIhf93TCieqlN77jSW6xnj2Vc5ciclcUAEGvBKu0Dvt3t8A4720QbG1LRSvz/XPk+SUTwdHZPBA17Y1xAClTO+bGOwDcTiKlwP8SplNB4VZCG1bGnHkzU0T84Nz7+luUh1u8IjK3ffaJiw2JVVQVJ0zikP0gLpmwFKHftuNCG2Ay3xgfFNS4TXU4PPyOZEBMeu5+lemN8ZTeQrMO+O3Jq1IJV43GxBhSGUjYvFpKkSsXV/RV1iCerydMExDDcNKvSjJrAj8YsreSCuKkHrJowmF5vImjxanXUeVjv1RyC3xuWwnZU1OHhof/iRNNdN8a0+rJFIep8qd8DUM7YKg9uk1cQwsnK3Pz0qp9hBKw2B+ONyoLM5hereCWGlhm4YfaGPCYS9zRIXT6CTrAPVk2AEywwJRNoAwdFNjIrI/+4Wsh0bavjH6Az5LPSC6NxmeGvfVDpo644qMh1gAZ+dWsZhICcduYfzSLK3X+TvPLHyc/Sqh4HlehKfw/cW5TBvOktiZxU8fXA+GpQHcpiLW+wYoBjZYwbCYEg47MkgBFQHfCQpA/PXH/0lf8bVZW/4wVNSrElwt8tg6HAj4HKs8IDwBSgFuOLyV5EVsWlkuRskEtFudcDKOYomRayCcmTIJBcsAkeDFvkdDFpr2mjMFMYqcDn/E1NKbf6MwyfYa4U1Vajge7mEopSAgpodByPQsbdnEaWKwQrfSirXQC5/kEiLPC3qHlL/YhiDGec5Af/8pit5Lm9Kx7PWzjOEh2KSoF8XvyL0x3+jwGvkSfRzw+xjXBK5hN38HJ22E9h+0gedaFtqCyyh+dLQAFcvu74XyudsZedq2www2Wc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
anyways default into READ_ONCE() in cases where platform do not override.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ac70d68217b6..4ee151cd2c6d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8422,7 +8422,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep, pte;
 
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		return 0;
 
@@ -8430,7 +8430,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return pgd_leaf_size(pgd);
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (!p4d_present(p4d))
 		return 0;
 
@@ -8438,7 +8438,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return p4d_leaf_size(p4d);
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return 0;
 
-- 
2.43.0


