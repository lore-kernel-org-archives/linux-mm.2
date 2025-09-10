Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79406CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2FD8E0025; Wed, 10 Sep 2025 11:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A598E0006; Wed, 10 Sep 2025 11:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC79D8E0025; Wed, 10 Sep 2025 11:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1098E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:34:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 455115BD53
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:34:59 +0000 (UTC)
X-FDA: 83873738718.03.B29019A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98FAC4000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:34:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhQLMmvm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757518497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nRhvh92md5YLQu0jiJRzH2Mud3pm9hiYLYtMu8GjEyE=;
	b=wwxV3TzRoTE//wzAT+vkLGDRxYMd0uX2C+xaU/oodWl0q1Qqt5+4F9bgacXe+GyPK7RklP
	5y2oq/38lGLhQ/zRFhSl0CtBOz3wP8Pz5/jJQpWnx23hemw7EhFnSkVyKUXkcFPYi6iKic
	POdowv4Tm51n4ytTI4mkNvnV5cGwsJ8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhQLMmvm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757518497; a=rsa-sha256;
	cv=none;
	b=hCaN5M4bed6OmBzvrvH7DObwdykTNjnZ9tISUYcNi7zv8M/v+9YK6Lv2MBmWVVHVZYrW7S
	tE7Iv80g8kccofFWaQ2sQhsjtkEamRgd1fgOafBBcrIgKcoKlmu+1bAIpUjFJPPcj8KDCT
	auNyLNGKhTNPRPAKePRbC6qgHZlS7Vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF35440B1;
	Wed, 10 Sep 2025 15:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557A1C4CEEB;
	Wed, 10 Sep 2025 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757518496;
	bh=ylywEWdpuWY9ksOD7npdckXIkyDG0CoNTtEKj9xRWlw=;
	h=From:To:Cc:Subject:Date:From;
	b=rhQLMmvm6dRoXeNpFCfCLVpoY7KvfC8BQX1DDVQqPnV+bvyH28j+DR3zV5mNbG15k
	 qII2i91velnS0+nJmr0iQjTnd1tzaXScjDorFCIqvs0rH/xxjofCBUdJWiHvW4F+G6
	 ugswwcbJzFRZGRl2CqG1tCXrMAenb8EFyarnsSanweQl1BsoXWnzlZ/+Pac0y+5Kdl
	 wHduKm9o9OU3V/y5/Cuv7Wh1LpDiBF7l3vJPhld6lR4lX2gTvzJhWWoTcgnVQr3dD/
	 SpRiF5H8Shzux16IcqivEpu60ih9iK6IJKRCPO/N1gpPtAz/wIT8YFOZ01/9O4SnXb
	 F5ocWTAWcmZKw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH] kho: make sure folio being restored is actually from KHO
Date: Wed, 10 Sep 2025 17:34:40 +0200
Message-ID: <20250910153443.95049-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98FAC4000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8tpo5ogqnsouzym7p1nkqy74k3oac8gi
X-HE-Tag: 1757518497-496501
X-HE-Meta: U2FsdGVkX1+Qg/sJ4lCEfuVB1NjOBE013Vfhun9vUIisqNBtR6EOY998SBNCZfXl1OwK3QUAhaVj3tIC4m0w8GyvneOvrhgUHFEchhDiugmWcj99s/cxRk9XAKn0tFD3YnAzPn8Q791H9cWglslhEDLLxVMOMyWcUhb6sUQgKSPan1A4aI7sqTLEGwrn6+9opZrM3EFWzsVJlhcPuksP97zsAqe6H125kuj6hfPGB4NdfCK4YOAzmEC+q6RQV6QzKE1yy9gLOT7PpEVDZrKK9qBn6oblauO/hjRjPZ/LhfLYAmBpd/2mYXS9G7/9U2QFig7C9imgsl9GreJMZYTxfUHVlaOhBG7bIFG6koRReva1XA3CWp9yR/564jIZ2U6p9uITi2pi1MUnAFW/uuf4Wm1cfKnE0vljd94rfenJvzcL/p9kxNZRk9gmBct3ili6lCiWbl//aO/RSxjgzI6UvzKdoV8gll6H6tFUC6VhJf8MXg69MMa/o8gKksGWtuYZVysIFXEMkQk2PoRSooiQAUk4rADpWQmeDTzQdRBRTewdDeC0qvYlguDlSpUB0xABvbXy/l8IhXBmyUsLPExlizUL8V/dpBplAe5sDlqEdcJjBt+b+LqBGaIksm81PDWD0bY/1kskOFla0DmHs83qjVxazQiyqQNdXdDq5OnCcmhSYQmwScoFutvCByaHzC75Ir/qKwOtpZ9zHSSpcp5pTmaj0VJFirGBBP+Z3UqWXbQIfabwS83SPqsD1kWUeSw0grTO+YTaRQz5RgwnFQfp9bhAkmuTBXaPBFpjcuJ/MFi7H+msnlm9Pzsma0cPeCxlwTKnKDQdN4SFEEGw5nneFgNS9DzEDGMOrZ+X0g7p0IGdKKRzHj7p4BDo04aiK+Hyy/EU7JxZv8fhplGkczluuyP88FQUTwjbnvyQlWMToPdatzOafv4gqfA4V1cmqT6zFgqRZ8eLmB6yOvMnuQw
 Q5wxnodp
 NLYO2MydQ+6QcE2UNGWYGT8E/AGDx0cFa8heUH+hG9QueP/ou1ePT41HeRXtouNu5n3z0WjnzLIUJ4tAUw3oNDWewsfh5CRWpFCp2FKninZT75s2luyh8FTPlCrM1dEhJvqC/RswiBOoBpRoNLFymF0PRr9tCVoEJ9fcdg99p5PEMCk3ACq25tSzqJ58MEQ3EQwul
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring a folio using kho_restore_folio(), no sanity checks are
done to make sure the folio actually came from a kexec handover. The
caller is trusted to pass in the right address. If the caller has a bug
and passes in a wrong address, an in-use folio might be "restored" and
returned, causing all sorts of memory corruption.

Harden the folio restore logic by stashing in a magic number in
page->private along with the folio order. If the magic number does not
match, the folio won't be touched. page->private is an unsigned long.
The union kho_page_info splits it into two parts, with one holding the
order and the other holding the magic number.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd7..68eb3c28abe41 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -32,6 +32,22 @@
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
 
+#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
+
+/*
+ * KHO uses page->private, which is an unsigned long, to store page metadata.
+ * Use it to store both the magic and the order.
+ */
+union kho_page_info {
+	unsigned long page_private;
+	struct {
+		unsigned int order;
+		unsigned int magic;
+	};
+};
+
+static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
+
 static bool kho_enable __ro_after_init;
 
 bool kho_is_enabled(void)
@@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned long order;
+	union kho_page_info info;
 
 	if (!page)
 		return NULL;
 
-	order = page->private;
-	if (order > MAX_PAGE_ORDER)
+	info.page_private = page->private;
+	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)
 		return NULL;
 
-	kho_restore_page(page, order);
+	kho_restore_page(page, info.order);
 	return page_folio(page);
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
@@ -341,10 +357,13 @@ static void __init deserialize_bitmap(unsigned int order,
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
 		struct page *page = phys_to_page(phys);
+		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
 		memblock_reserved_mark_noinit(phys, sz);
-		page->private = order;
+		info.magic = KHO_PAGE_MAGIC;
+		info.order = order;
+		page->private = info.page_private;
 	}
 }
 

base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3


