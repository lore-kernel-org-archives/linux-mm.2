Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2BFEFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14B76B00A8; Tue, 24 Feb 2026 00:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A96E6B00AC; Tue, 24 Feb 2026 00:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893F46B00A8; Tue, 24 Feb 2026 00:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72CDD6B00A8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 411EB1A02B9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:32 +0000 (UTC)
X-FDA: 84478182264.25.2BA0894
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2E22180007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771910010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOEwIWusDbe8S1uUS1OdbREcgKoyemqsvN0/9H335jE=;
	b=pvE/V9oPTTHi+aOMO3G6sBMPsqbx6PIY2Plj8Dh6HDdCa/H8oLRGgcQwxFvGERidf23k8g
	hYAx7fKJ6hKLRsJZ+P3f3fT4HOtzsklwDgGNGWxHdJrPUbqGirurAgc7GFasxYo2VS2cbH
	R2SA/9EbJ4m2bO0eEhou5pfGSLvWSgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771910010; a=rsa-sha256;
	cv=none;
	b=f/DioaRlK+5EGsGe+V+tKgQ3IS/gBPysV9Xtwsw8vYaeErVygoY6nrWCHCAaPpfkaLWNYu
	P2wSYxVg3kF5XFRR5Vs1ECQfL+KBJ6Nn1Zo2NYqT34PwGHL4vvJ+FgvgSeA1Db7A1uTPId
	ZznbF0QSNU6ViZfWDQJDfS20CEB9dUU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E431A14BF;
	Mon, 23 Feb 2026 21:13:23 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 032283F7BD;
	Mon, 23 Feb 2026 21:13:25 -0800 (PST)
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
	linux-mm@kvack.org
Subject: [RFC V1 13/16] arm64/mm: Override read-write accessors for vm_page_prot
Date: Tue, 24 Feb 2026 10:41:50 +0530
Message-ID: <20260224051153.3150613-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mzcp875b3okuazs1r7ozfzg84fqrnuzr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2E22180007
X-HE-Tag: 1771910010-397633
X-HE-Meta: U2FsdGVkX1/X5IO1s/Upx2HyTKq5Evg7qbYJrBDO5NMG/0uJccliHHhoZpjQ+2OZCbUpuDmiHzUBHJRHFN7c5uPFj3nTn/4dsngKpzDVJL8BW/U6WpWACvz8GC6jA1Q0pQh4pytmKDBW8WuuO2F8dXWBV3+sZM4J6k6OdofzKp3H21nzqKZDgtaqmwPhVRvAFRVWp4rfqW6XByQBHlq2A5oe5nggq4UNt6f8SIT3tPXTHcWTn1Ee/yM6WbiOBlvzu6K0tFON896QS5ko+Yee+z2CSEov5YqJb7hefxxVyICod35zRqfavIikJ/5dQzjLbniTFtchdv+QrTzQkkS8isx6twwkvUzXF++uJ1FHHTuwaqvzHGLfOgaX0RXB+QJeFEK8WM1sK5pj4W7vf/IwZ++qm5vBkZ7I4+1B0P23vl1jDJkgbgPVwgZn4GMIEaN0Y51zbxNlWBG8jh2SOU2TENKE++MnrnkEs2fpnMTzDJNDKCdjBGgB5iV6YOTD0NcrC6SBlcR40Utz2a3l9egMH+cYlEZBLde3Akcf1AtFY6vrlgfpSjE+b6HeX2EHVsZ6UaJf4D7/UHFpHjw6m47frw6JAC7Aiyw8u6hKgUOtiCokL+RUo//0NrWALdra5coHvBvX8ZRxsvxkUVg6oJQ+v4h+MY4qDk75WrwVtqES+GaY+moDl696PY01eeKPFw1aEybGOgGPbm9NRNEyQNRDNVet7naxXaJ8GNcFYqJRK76PygmwnLMB/nYKSFeOMF3YldJ5lPrHJXmUlFsILWO9HmHK+i3/DSdYNV+W/5sE5N/m0EkLmRzVUC04dXb6wHFuxG8ofTk9LigvY/B6YqchH3Zh/Vt2SUSD2oJLnu/yEWvwvO4s2K1SZOZFCC1z1Ofv8wL/rihBTDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Override pgprot_[read|write]_once() accessors using ptdesc_[get|set]()
providing required single copy atomic operation for vma->vm_page_prot.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c4142b734112..b39d3d3c5dfc 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 	return ptdesc_get(*pgdp);
 }
 
+#define pgprot_read_once pgprot_read_once
+static inline pgprot_t pgprot_read_once(pgprot_t *prot)
+{
+	return ptdesc_get(*prot);
+}
+
+#define pgprot_write_once pgprot_write_once
+static inline void pgprot_write_once(pgprot_t *prot, pgprot_t val)
+{
+	ptdesc_set(*prot, val);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
-- 
2.43.0


