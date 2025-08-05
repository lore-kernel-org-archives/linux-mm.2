Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2794CC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33366B009C; Tue,  5 Aug 2025 14:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0AF26B009D; Tue,  5 Aug 2025 14:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EB76B009F; Tue,  5 Aug 2025 14:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AACAA6B009C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:00:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 604B5134324
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:00:31 +0000 (UTC)
X-FDA: 83743468662.03.72D7FE3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41FB280011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:00:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XKXPlRRV
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754416829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW5LZER+hp3OWb6Qm0dYISrY7Z43oLDV4N/MV1Pnvb0=;
	b=IKiQhrhKEggoRfuQmcnF98RHRl58nJXEpoJb0Z84wshBUga+xYM57ZijYIRBE73rNzwRND
	uzWm7+kHLR+E73wlX3JTd6/ZCiMiv4q95ZpA7gMET+nVxST/kUiUnNERA61COJ7UTL2E1K
	Z5uJj8f8A2ZLM5RoXz2Du1sbkdjtCJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754416829; a=rsa-sha256;
	cv=none;
	b=b/uOiv8MggE00DlKDhBylmgBQ92Sms1Ub5RFhl1KkSbe2j4IRN8opJVIi0SOFXRVew4/wC
	Dv4NjS1rJnrf0jc0PQW+bGheeaQAdNkcQ428i0n/9x6rsOe+bJZ2og3O6/G0OUat7owPiy
	A9hnDrlvN4ZFF2eN8NX+SauNoBgUCxY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XKXPlRRV;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jW5LZER+hp3OWb6Qm0dYISrY7Z43oLDV4N/MV1Pnvb0=; b=XKXPlRRVFTsoiWSchoR/pu7aGR
	l1r7zKR7hR04Hx2PffgF0E+S9g4OGkX/aGP5n3EA+AWvVTmF3fNBLaoHXKvilR53MTsOK9C6GYjB+
	m/PYXaF1nGKSBiRJfyJfs97aaYFVT1Tv7EbI+JnEeaahW/KN29On2kII1Kk9nHs0sTgQfVyy3nhb1
	PdNab13qcvzW58KBde/goTIFvgeq9j5L1CCHMnoA3Co0sXUak+uxmnchiLVpyMpalfvXY8777Uepm
	qKYkJk/CLGGwTLQXNlFwtg9lQwUHl/LOkhvXD/sM8Y+R6+VlN8yQW/2FVO2P6/QHU6lfQ2/hnILuj
	HGTs/OEg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T6R-3E7y;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 10/11] mm: Reimplement folio_is_fsdax()
Date: Tue,  5 Aug 2025 18:23:00 +0100
Message-ID: <20250805172307.1302730-11-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41FB280011
X-Stat-Signature: mez7t5gh33zdidougtjxzmtz6toxgwye
X-Rspam-User: 
X-HE-Tag: 1754416829-294817
X-HE-Meta: U2FsdGVkX18tQJMfCSkfDt1MAAZIdynhghohww97/FSpgJ0mclohSrqiAmVHjodXQdy8o/fY9CH/NlU8QzaeJlbPbq3wBY2ZCyRhnW+Z0G/7MgYRKrKYlWIqFBSyppjZ5VAboqMeHjf7ABsPeGwYtjsXQk6vv9MLKDI24AFixsYBlQIMWokCa4DBHr3CryA0mCVUl6WSuj0NUjGNLXhuR5+ypEOY1oTbFO7tP6qGiVkNKK/dH1ID6qCe6itpxAAX1H3vbxxZtHFzRWWM7NROqMHz6zUmLDMM6tLfdaSiy/XtVL1cBaW5C/KHefmfqOuGXzXsrDvE1J8bmhrMfnSk5BWO3ZvgeFJsp7/t2IY9CH43nMAI9+KFgoj6nLuMwQQ9bCberotg8o7uRDvmUXp80ALaK7ez3wSBDfDEpfaTUFxXSlRzoednNzelWoAQ+HR43apt5No98KuEUNpTRDWkRH3VFHwaoVRlHUAjrm7Guu0k/xkLdzu0Pzaicrbkdqj2AYcVuKI29PY0H0XF1mr0GV0kVMANR1xFm4pi4M6+zZJyWgKdySdCD3w5AmlAnQLFIh+xMu7gPtXrW7m1bfZgTs7XgEqFvV3uv84/wVKAm7gWjHKu7NORFRKYuTZ5kecpPkk9wxAY8EghQApa2ApLBx+NasgeeKdE7cgTs/iZBUUIiqgxiiIopXJVccjQ+opi6seiwAZw/b4vM26ey1fZ4kNMutDYjS7IZU5zJ9NpDEuvUpZSvES6TrHVz/NCWq4YchwRoqruR1d9GAMBmVEFpvD2j0iuSNMK0j1E4Lut62yDMjcUmsPnt+AKzRUyFy+SkR5r5hLwIjmtjZqA/dKDS4yveoCFS75x8APb6mXSzmcUjvlUoQ76oHjvCOP0f6ZGBLklF0gn3Y+cdPFJ/ABn+O7+pc1B9Al6voqenrxpcHIzq99cEFaj4pviq3r66/JGKNtgqoOBo2H/UxEMnhL
 35B/8Lkk
 2nKOF+NL+I/HQh59JDBLmK/PzIILAT3tHOnOcjwLdBcPmQh3FzUiP8q51RUDKTfnLdHEbprhmlfQBHSY5SiEHozA7yQ3kAhqvtlprygq8wV68o9Run6YoA8JIAb7FPsj1k55w8UJ25lSPy8t57IT8oQTUtKp+4cMRu9KGgwu0LjeeLXwMEFDet5kIh9RKvDiP+c1nXawy6P3XzVlzzUD/5IdLXMwVBYHxc/0yGFo9c9NoGMae7i7q8fAQV3+H0pR/SYko6lcO3pAvIes=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For callers of folio_is_fsdax(), we save a folio->page->folio conversion.
Callers of is_fsdax_page() simply move the conversion of page->folio
from the implementation of page_pgmap() to is_fsdax_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/memremap.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 06d29794abe6..450d4bb6835c 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -188,15 +188,15 @@ static inline bool is_device_coherent_page(const struct page *page)
 	return folio_is_device_coherent(page_folio(page));
 }
 
-static inline bool is_fsdax_page(const struct page *page)
+static inline bool folio_is_fsdax(const struct folio *folio)
 {
-	return is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_FS_DAX;
+	return folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_FS_DAX;
 }
 
-static inline bool folio_is_fsdax(const struct folio *folio)
+static inline bool is_fsdax_page(const struct page *page)
 {
-	return is_fsdax_page(&folio->page);
+	return folio_is_fsdax(page_folio(page));
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-- 
2.47.2


