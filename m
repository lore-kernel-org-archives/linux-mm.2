Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3180CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216988E0003; Thu,  6 Nov 2025 15:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE078E0002; Thu,  6 Nov 2025 15:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1524D8E0003; Thu,  6 Nov 2025 15:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 056AD8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:15:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A27861A0261
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:14:59 +0000 (UTC)
X-FDA: 84081285918.13.1586DC6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 48BAF40010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:14:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HfqbTHd9;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762460098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T6b2ZC2mItlX98u9W2vYWnG1HHbArdr6k9iacuvglYE=;
	b=E2lOKiHmtv2/geXzBHmcMM6qTQW874VU+eppZ6ZRU0EguqKigQcKQoV3Pif7UjdoLMIvAf
	d6i0hnbAmEG1BeO8ji8VTgZS7Tgo8Wkkiu6QUsfVIgkyJxdalhqaMllcTdK7h9/94n8PrR
	KT0/JKpYWA8z2xmm4MayNOAzKbpCeXo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HfqbTHd9;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762460098; a=rsa-sha256;
	cv=none;
	b=CGSL3wX5p20pJM2vYx2zWtZU42/563gsZaL09FD+a7A5TTJ2YqRpjK7Ijx1wQJ0aKEfzof
	G1VJfjqPq7i3Vharo9uA8bc5BgR7u/NLB2OYQsulNOiwrApK9S+E4nfogQJsIP7tWsTHLz
	D/yi0jGU+e1JG/WHs4aUQsx9JG+/DqA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=T6b2ZC2mItlX98u9W2vYWnG1HHbArdr6k9iacuvglYE=; b=HfqbTHd9Xy3YT1DLSzrclTNSsX
	u6zYBL3gDVJAUEMVTBZShnnbmO6gozivcaB2/meOn5yxWLqyjkJKd765sZ6cB0bSmKdPiTSO8DWkC
	Vs3eKyUAJVJym7KVpeMbFjikV3ZmtxLLW3LyINJmEfW4kXBJrNvd4W/HQsx1jB2zEWTgfloaG8V5I
	3qWkVmAoTmSuE1qcq3mIo0Bkom7evSih2rukWNyPlT0cI0mDIT0nWcuFQqvHTugt+z81XhOwuCVb1
	utwxROZajwHxNWVMifu8UFBvfVTY2qoIWQ5QzF2KfFDd7wfqopuBf2z7H6P6kfK1YlMsMMe/cb4Qb
	JxZiLGpw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6Nh-00000009cTE-3gkh;
	Thu, 06 Nov 2025 20:14:53 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 1/3] hugetlb: Optimise hugetlb_folio_init_tail_vmemmap()
Date: Thu,  6 Nov 2025 20:14:48 +0000
Message-ID: <20251106201452.2292631-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48BAF40010
X-Stat-Signature: sk4aryn66i466tyocp7ed9jponfzzq77
X-Rspam-User: 
X-HE-Tag: 1762460097-807322
X-HE-Meta: U2FsdGVkX18/3kleCZUAhe3/4808BfN3d0N52rtLKCPFVsglaWHJ+f1bsVQnZsvOdX17F8TP/mvOPlfcVbfDi8RDkwg7uX/XgN14tZA6gehbCzH8O8jfMN0odwdLYpktfYoG17U3HCaShnKi8ekX6nktwSowO4JRk0Ye2IGqaI0GY3o1m9r5XBkvTXKglTSO4jT2IMf0D8CiWfbO7/faIbudWsuhnmpLeHi3YDOe7ejeLTesmbzx/Ffr6K38+SUX8owXKi0rEVUKky/aksdiLF8FyHGBFb100UmEtZCZ7daAjDBImwGs8ucT2xYXLHlASvE4ttkhjQTm9zFgkZQLdO5DC1NeNWRK0RE0KKJOkGD9Qb2BMg5Sr+Qp+5id4BW6ktozMJcSLbWigN/mXADiO5PpCc7fn3EhFkJwIvmumt/W4Ul1TH/4bdxBAKYjshXcLdD6Oh9Y0x2grggjJ2br/MvuKrzlZ6jv1QFtaamZPXHnXydYUtOTjtnVInqwmcqDIcNxbBXiX4R1+CTWbYo8vDNHBpYAQ1bihmAzaepsAkw2aZ55wbGR+rau3CvhwvaPNag49HjKLjXC7hh5j+3H6V7X5gQ+vBgk6DpLHTIg53R9Bt/BAhnIMwTP1ZHnntubJUAP78oWGd/zeLgT/ptiklC8zQgYJpH41/Y/G+MeV67OyXKJxPVDQdYdmL/XEMep/joQLpFavaPdbjJ5FPebEcmwA5RRlOu9iL+y5FTq+gMo1UVlfsbFyY9VwI9un0iKlWtubosvHhOHd/88v6Kf08AanxWQuDNp5yy23s9RnZWyUDnmdI9oGaAVSOPXhmO8vTogtJNSdRoOLq1/pnxyEYhf8SOTpoXflIiPqEbZGUhZ87v8OF7AF878UTWCbWV4BxaqPUvUmBI2Kw9KUA/xqt/3dAcIQ+MmSvCoRz6BpSLZ3sR6xds/4RPEQCGfJsduox6mTc0zp7FReTFu4dj
 onc56uKr
 HPcrjGucsLfCue0P+lmiqLXpLRB/wKO60/LtV5BxdKcS7ttEDMP7IWzmWWvygiuAbwiRXeGN99dx2rM3Sh6dGfoe7UG1Nhn9UDcHDvaFjt/dndpYfMhJ0RvhKXEVhSh/F1A1K48DBr0Uez7UYYUuGBu9pTPcZI9pLz6aZbu87+n9ekPmovQQA7SeXu7z3eOZo33iv68bbItKmP+Aq+4dPughI6z/4VBJYQC0m4SkHvv3JXEEZFbsfmlwrDmWwuWOrayUJbd2Tv5dSsO5c7uezEJs5cc1lxTROaPerIrMK9v6um5vlUFhkt4R/3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

Also we should use &folio->page instead of casting from folio to page

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..993f984993cd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3215,7 +3215,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
-	enum zone_type zone = zone_idx(folio_zone(folio));
+	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
@@ -3248,7 +3248,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
-	prep_compound_head((struct page *)folio, huge_page_order(h));
+	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
 static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-- 
2.47.2


