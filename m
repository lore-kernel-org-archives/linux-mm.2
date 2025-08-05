Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E87C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FF26B00BA; Tue,  5 Aug 2025 14:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3384F6B00BB; Tue,  5 Aug 2025 14:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8526B00BC; Tue,  5 Aug 2025 14:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2E86B00BA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:20:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2B3A114D35
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:33 +0000 (UTC)
X-FDA: 83743519146.28.3F3AA3A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43BE280011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="EBc/JuSa"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418032; a=rsa-sha256;
	cv=none;
	b=sQnhRad9P0lHT9Atg17pbIuK9JsWkdDa15ukTMmAgUCVQ+O7YkcATVxjgdLPaAPeLLI+v5
	x5FhDkXi8jip0bFKZkT8AzpPpfXcW/UyQYeTzvBJrwL2Azq2TsuQR29RsctDEK2e3VpR6T
	Ujj0x6ex5+maB/hH0t+HZcb3vdgNdd0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="EBc/JuSa";
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNjGV9gN6PoDyUk6Isq2vkrL6YRuQ0x8JZD0xDgeUCE=;
	b=HT3PZRNquT/zkrT8XndSH5lFv2R+aWJXDtkSOR+92rv8B2urtoTHDM2rMcmsdKQsYk3R54
	GTmhflucYfeGnIyORlubpOsnd/9jzCVeii42H5QlHOr6bBCQkUkfRhwFBXcTaH25LCBLYr
	mHjFShuzyujXl7RFlyP8DV26kXG2sq0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vNjGV9gN6PoDyUk6Isq2vkrL6YRuQ0x8JZD0xDgeUCE=; b=EBc/JuSaFzgqEc4LpSrKiFKVXt
	y2IRxM4ZOHhVNRiQbeHZMxev67fLpLIDe/Qr8myv2faSuc+dUa6GF+L1a7w6XKuWyIUaJIl1JZ9kq
	zrQEi7BQ5x7zRxGpLtZwn4y84hqKXUlNNIFXZH+iSvrdbQM0vQbKUqziJQyYKwZBCf8QhSUy8sOK4
	jY2jmaT/6qEjgDMH00gSnzu/WEUUmOHfs1oWtWYJakZ94Eejw+XP+tDsivrlKdleIxOq0R0fwcaCl
	6sf4nImJX9LXgGknklsOzAkC1PcrAXFxRSuDtMdgouMJ2V1qquwfc+i7/FJ449/gwo6NFzkeLC5im
	TVtLc2Xw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T6d-3n8b;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 11/11] mm: Add folio_is_pci_p2pdma()
Date: Tue,  5 Aug 2025 18:23:01 +0100
Message-ID: <20250805172307.1302730-12-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jq4bie93d1b8rhnxz4emwrd8whuohqhf
X-Rspam-User: 
X-Rspamd-Queue-Id: 43BE280011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754418032-197973
X-HE-Meta: U2FsdGVkX18HrxHeZPIMkps6qxNJnyN2AhLKPFVbvBij6Vp6IH+wdldDSeWVwk/R186jTVx9g+T6yaHYGEQeSAKIgg8/E1IMCeJqxdSfIWXrf60AhEEUMfEuEaLBcaOjI9eTMNsXSZWOxErGEDsMsj9HXjQ1jh4XoAUXKmyWCpgFNOPQVYl5PFcGmqgu3AQYFw7Uhe7Qo9VEDeGvdbty79wMo4KD9kXaZNlZ/eHNJ59/sDvVkd5Yh86YkDjvlt006YVFkkVDU5kfMI4dkcLLnx/cNtK3UnAb3W7+gf+/jpHnHt4pk+gjr/TSowtXntKd9n1oCSfJM8Hv+3IBbUN0gbvhfAMhtqX44s4a/0co7hL62BORqidcfF2HRH6dteNK44ALMKgOucw/vh1wOMxtPqNkOP3ReU9rcz3Wngk8s90CJXGh/rWDUhGAbf9U7lGWDFmXxbOsrM1thWh4KEOxSGJ7y+mOnrIh8WRCWt93h9JUXG8yCyiTLy10Ozm1vsUvJ2r9R534OXYIoEzSuNtOAh4pk8p7BCYFlq98HS18MUGgJPSxxGc72EFAZJHmKINgE5KvXZY3srv3apsrGDqY/yW1QQB+X/iXFtpMaLM2/YduKALQg8/0Rt5u/nSNW8YqrWreRZ9GxCmNelENsfERqpD83hSf3oYuJqOZn2ZQgqvtGOSQN/1r2u5BIW1ruGcibcgfYLPlq3x1159nj47o0Ym2ftZ++MQihxk23keK0j61PC+WAN/kuiZV7SUXkAF7pwAKF1mYJKVR87znovUeTjLgvY/u12AhyHaaQgR2IprypRI6AbpT5aB4fyWmj0iPXS/hSmxMCdLBu/6FRz3hc8qyKDOdeXlYroDnYhoN3y9+J8mhBzVwnRku8w1cR10TGXnm4zWhlgIhOX8A65C0nl/qNF2qKDDBlyQ80/h/AcPg3WZp8jJNRw9xnq3mb3+x3KWn9jiTVEZdrXNXBeS
 32mynu64
 NQaJCj4deGKlz7447wFvulPeBx+dHWrxYj+nj5Fuf0yn/M5zCPzX6uxe3foWIn/K9eszFchhRubMs/dXE+Q/Nl9F9vu4WR0k6coSzZ28yKbR8OGQnsKrqH9kUOzLpZvZoVKK9XSYoiodAWEfEcK91z+WtR7gl7Qa7Uw4u4A/3oygv6NKHvAwx7BhCG+jj/kE1lwRMxS2ONttey6JXNrj1G+tSWNogFWSMQFZUfXjkHLCw5CdX/DDLsQIm8wCak5O3Sj68vrF8/yQ92QkndPoQ2NLW8+E8Yy30+UaHY3xATlW/ZlGioMOc+vCW5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reimplement is_pci_p2pdma_page() in terms of folio_is_pci_p2pdma().  Moves
the page_folio() call from inside page_pgmap() to is_pci_p2pdma_page().
This removes a page_folio() call from try_grab_folio() which already
has a folio and can pass it in.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/memremap.h | 10 ++++++++--
 mm/gup.c                 |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 450d4bb6835c..aa1b6aa877a0 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -170,11 +170,17 @@ static inline bool is_device_private_page(const struct page *page)
 		folio_is_device_private(page_folio(page));
 }
 
+static inline bool folio_is_pci_p2pdma(const struct folio *folio)
+{
+	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+		folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
-		is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
+		folio_is_pci_p2pdma(page_folio(page));
 }
 
 static inline bool folio_is_device_coherent(const struct folio *folio)
diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..e02f8dc641df 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -148,7 +148,7 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
 	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return -ENOMEM;
 
-	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(&folio->page)))
+	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
 		return -EREMOTEIO;
 
 	if (flags & FOLL_GET)
-- 
2.47.2


