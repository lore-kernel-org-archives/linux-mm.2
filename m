Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB5FC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18A26B00B5; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C545D6B00BC; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8876B00B5; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 630AA6B00B9
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7DC31A019C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:13 +0000 (UTC)
X-FDA: 83743374666.07.D38812C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id E67371C001B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vojxy6vg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+h+A4ihG2tRbfuSMI1760Z5cp88AtCYmFyaZ3livwfQ=;
	b=jWPq2Uq94OX2wkCQCtD3bOTu9N7vzx7UC8uZufeGKgpHy2C73Ga5hsWv8s9J4qei37maYc
	h6YZrGd/0/tpX1FFx1A4Xs0nG9moPDMfj3FQsUChERw4F9O7dIREZuzuSRZlSzA/56q2AG
	Drk1pJq2Hot98ETCFOt12fTPXbLzKZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414592; a=rsa-sha256;
	cv=none;
	b=8r2cJOJQUjyDJPvIQ5B2yL5hyL/tFq9SDwU0UsM0eXVUNbtdUagqI1KWti2M3oonDeiJY3
	xbjKcsoWZi+22UmXWliLndm26NVwO5MP8xnZfncVyt/YHuyI6yoLNgBSQy1Ey+0dMaF11u
	qX/DF5YZtZochVAcAAAdYA0nXH9t9JM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vojxy6vg;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=+h+A4ihG2tRbfuSMI1760Z5cp88AtCYmFyaZ3livwfQ=; b=vojxy6vgTud8UF80zfQ8o39qAt
	SWqq+raw+x1JGwu+HevLP1TWgrHYfyvvWlmQnJ49IjMYhrDDtCbkK7z9RKpVO/lBHb5AChrVkKZN1
	FyClv6OIiKcbnYJvRA2wt7mUDLufluozuj8xzUM3R31F2E8YLD/KBrwVTkrUCrAtCc9Gs10EXs0v+
	bavDDg4SDrH+wnjOs2PIct0jqrgNMwJjMrzp9SYZ+78Xd49+5ZojwjXOp1mn1pxSjj0c4OCplRFuO
	6U5Kpqg2KutKIpJND7meOId64foz1IxLj6XyAw62WPFYNlWE2gzdLfLNItRBSeHaFA5u80EntmztG
	UDdGfhvg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T5e-1fB1;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm: Reimplement folio_is_device_private()
Date: Tue,  5 Aug 2025 18:22:58 +0100
Message-ID: <20250805172307.1302730-9-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E67371C001B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 77r86yrwz3s4nsr1qnwqruq4ujkob98o
X-HE-Tag: 1754414591-143927
X-HE-Meta: U2FsdGVkX18TQgHlM0EBAK38Jy2h+K6CJRzA2lqXMIiNdDuLKQyBquLfmPHsnQvpMECFkBpDmuh30/UB1/pVA9ws8JmWcsNTWHUUYVB39kC024pveRXZBFvCqT9F18htALrrg+MvFwpaN/asbEiEJ8ksGFzAqqDp0bXKEgqEtlPSgndq1zP3YX9aHaJ59LYVWGzYIQ3ecRocOIx18SciQWeU7j6JJNCqY62tvlVFNjkQdOqmIAq2rXHZposxqNK0ND5LXfl1301DHTJHgWCf97Aqgbon/LwH/3XJjZot0Oyz0hcB+mXEJnUcfawiYOO/142T1FWPe2mdlVbx8H9vOw288hJrUj51wcq+VHLtegfeHNej1rgLCr+p2wTUpJAOvuq21iLO6mdvsLZd6WXdH7iJ5btFKP2pqLfxMJaWfgheEQqz+4KgSy9nqUXLKjFMe3LlTXSbF+iNjQGXjzTnz5cAiXb6HJaspgzCUrNPlha+TdLmEVxlh8qHWNYeS95eArpyKxw3JTgtH8gCeDd+CjQF1DyY5N5VuoiAq5RE8PhIT6DHmo/kLrz55LuLtSYtaIuEekFKyoJiKFsjPhXqB2ZtdwOg3L6vvds3MeRywCu/hDk4VLu2+2b8ilOxdYyD/gwntHIN4/eNAbpSP4xfXezh+3Zd08YOq1ikSfD1UZlVebarzcLDjj+P3qw7bk3JILUAy4sqkwFigLCaqDGtU4b3SzYZ341cfxBaWhN8/md3LMqGRqCVgDs7YcEPjY6rY8YTf5N3wvAWQg1ixI0OoqvhfjiEFHWWaKKZIIgGbCs+kuQim++Mb0CunK3iiF+r1D/waN7nICOJh69OVTsp2VF1rAK9udYJ+F354nC2Isb5Dl/U6TaDjjDF0GwBOXwhugRaGThtom9Cq6vZ7Oyq4NYE8OKUdCshkms/g+N4jWW1ZIKR6BaB4DLOTi89eS7/cAMl9rZWo7QAtJTewBw
 yi3LVD0m
 wJlWqnnP5fafsWkCgbLVQRdUjbiylbBD1fe8QORLsB3JNlSaMvPQyJtzx7eW6wNuJdqffkDvQU+2wxBCsgNV3flauzAdN3+TIhQ1NSjWja5/kBkfsETcSb88Z0skLiJXXTRZSptykWcJT1F3hiLUHi0AcfbMF4XNgDIy/PjqdUZHZIrEL3E+BH22jUdBDJwbUE9AHYJmoXsK75+4bsM3RQNvNYzVsDDpYdD5OxIpitBdmQfquD2WEfrKeIwdPDAEWOs+6v/lrprSgulM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For callers of folio_is_device_private(), we save a folio->page->folio
conversion.  Callers of is_device_private_page() simply move the
conversion of page->folio from the implementation of page_pgmap()
to is_device_private_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/memremap.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4aa151914eab..5d18cb7a70e5 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -157,16 +157,17 @@ static inline unsigned long pgmap_vmemmap_nr(struct dev_pagemap *pgmap)
 	return 1 << pgmap->vmemmap_shift;
 }
 
-static inline bool is_device_private_page(const struct page *page)
+static inline bool folio_is_device_private(const struct folio *folio)
 {
 	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
-		is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
+		folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
-static inline bool folio_is_device_private(const struct folio *folio)
+static inline bool is_device_private_page(const struct page *page)
 {
-	return is_device_private_page(&folio->page);
+	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+		folio_is_device_private(page_folio(page));
 }
 
 static inline bool is_pci_p2pdma_page(const struct page *page)
-- 
2.47.2


