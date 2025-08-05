Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63424C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C848E0017; Tue,  5 Aug 2025 13:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D163F8E0001; Tue,  5 Aug 2025 13:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C3A8E0017; Tue,  5 Aug 2025 13:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B04B68E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:40:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A9E11D41A8
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:40:31 +0000 (UTC)
X-FDA: 83743418262.15.510D373
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 766E240010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:40:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ijas3yNc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754415629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9zkUJWn3L/Bdv/TtFzilIuXbjjC+Jpf6xeZZoPGoqQ=;
	b=hZOu/C7OFjrCoAyGXbcySaXH/jykoi+UoElwOY0IvgiWPiP6O9YBKk8LCfT/P03mvHiu8H
	ZfelZkq/UHRlqxARX1wDm3ny8UM/HnNY6XKcONn7UzLNx7XNgpGdPtCxjzvDOuvESrhJCv
	D9yRKXp/XFlhbAchVDT9WW0gQrXMxfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754415629; a=rsa-sha256;
	cv=none;
	b=r1TH0TsqUd65Jp2bsr1lHpcXGDogNCEfdZi9wxa361Li6C89BUtyMGpth0CYMbqXuiI4bP
	xQfrZyN5+zTaEnCTCFILqS18ba+OcYJjWpMXZE1ijH/XusB092mXVrADg83I19G7ZaO3c4
	ml7oUMjxwBMEMS7sJnoo6WoaR4JExqQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ijas3yNc;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=m9zkUJWn3L/Bdv/TtFzilIuXbjjC+Jpf6xeZZoPGoqQ=; b=ijas3yNcdFpyycjKfDQHFh2Hff
	uleiPP4tqex1yol/50mPrPFMDvSgAPu0W583yj444QG6T2tsQiX0W1rahZH1u1mGz/5xsBifwZT7a
	Y8Ffi3eOuGxz/SozNiSm9lmeVTgQMdJ6pIHhlA83fvC5yUPaitpY5Rzyo2K9TSfMKhhI3MnXVc/4A
	d2yD5hpkGDY22UfG4Br2UcDOhvB9nr3WIt2LOLVkc2nQkL8zdzbgoYtM9WJepa2BK1hiVAOuKcXMK
	Hv8hD/qULVARKdUaNIAn04qyk9NpvWv2XvuAgM0MQuitMNCaVdvuNwpV+9iDNThGR7LpUvMvxCox+
	LX3Kz8jA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNV-00000005T4i-3C5G;
	Tue, 05 Aug 2025 17:23:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm: Convert page_to_section() to memdesc_section()
Date: Tue,  5 Aug 2025 18:22:52 +0100
Message-ID: <20250805172307.1302730-3-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 766E240010
X-Stat-Signature: 89ddogkdzxzryigz99yw4691bxogbuzh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754415629-63885
X-HE-Meta: U2FsdGVkX1+y8rGwZc10SHaWcMPd3vH3RSK/68XWLbcRzv7mMVD+zpQ4+ESMByHAU3vcwopeyTEwb0nQw6JlYd4xwGyifYOepWKa/8/ejCoxrsYyt9WUPjUMKHBv43Y6U37II2gYuOjLGBs26OWgWPnavzWGIKFagZ1ks6jjS+yQmByhkTn8Fl+LH6qMN4gHVHCY4OR6f3yPljdqcX+vdj811LvQWMcug4VHPTL6O560nC9N0Ah7Mq/Gd2lwceke7S9LTk77a0EGlGsSDzoCTuNED80SjBo6aB7beRa7l6UVTxH9D6w9LT7vf6NjLrrvTPfAf0enIzcOdJvaHJJURYb0z2H+qzm+tNRXrvKanW1vgM1G/ByWmBwUtsRXM2mu7X8LjIQoQ/hEj1UKyUUdyeMe/DhWCNnkFTrycy8qtrfHmxTluXo04gOGQsWpPa9x5BTxc2hrOhFa/sU9mbt4Qne298VxtXxWLbqr3Q7r18J2V859RXQrB0AzV7UDH6EzrUSsyB7vX96NKk2pxWIpm/ahoyMW4Qw+SuIVIN7UVvYLxJ/zFkSxjX/ZYvK7wt3WHFbxN3pr4AGnOTuSyRh5oZnhb4vvyC5AXjrBVSOnLHSoTgEE1St4Refcy/xNGNjJOa0ns2AUbUATXvm0m5/vmp+SfYC8KRTPvil42Ycik6ee2I7HAEO1Q5D1Pj9hzQonuaxcGs5qBk8wrF+g4dMNW5/TkgYTU9t3vyxRwaWeRkpDLf89v0m+FTKej/c0KOgnQeM+e/sq2db/mrNjrzbmtNoQoCFPw56LK++Zj+VbBn4FCMogj200qNlXdIxBT2uIPLiW6nCMiTEh5CHYqAB8pemi0Cq7BlDhKV83KfTxX+Q9EUBr+kS0hcksvfrlMFVsf2/CJv3u1atkjKZzKMZRahtcQ2AVcrBeDsFKQXrO/Ggdgi91GZ8flAHSJo1U0rN5Eu0fY/QnoczBn9UamkV
 xNXGCO/k
 Q17GOplDdK0Md+NHh/NwAUADoPvC4uAOrY2ne+INW1ChwDUnkOmDGft9WeuhZ3GOFFV81V9gOdYNlVXNzACV1b95hTxJuHouVzTwv59J1k1OgVVGAEPz2WxrJgqYVERyok50NGU+2vzVlwIYz4c8l5svYsRc4RFl0UvBd1CVu1cp20pcqmCnRGrvVNW58enFia3LX1AHJZS1ggsnaAQo731+J0zj3T36ROO7NLjZLy+uzjNhEv02xBpvcfF88W57SFCvKx1yZ3tPuTbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass in the memdesc_flags_t instead of a pointer to the page.  This will
allow us to remove a few conversions to struct page in upcoming patches.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/asm-generic/memory_model.h | 2 +-
 include/linux/mm.h                 | 4 ++--
 mm/sparse.c                        | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 74d0077cc5fa..efa6610acbc7 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned long pfn)
  */
 #define __page_to_pfn(pg)					\
 ({	const struct page *__pg = (pg);				\
-	int __sec = page_to_section(__pg);			\
+	int __sec = memdesc_section(__pg->flags);		\
 	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 779822a829a9..bfdec5ad3afb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1757,9 +1757,9 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
-static inline unsigned long page_to_section(const struct page *page)
+static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
-	return (page->flags.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
+	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #endif
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 3c012cf83cc2..6c1d400f8962 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -45,7 +45,7 @@ static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 
 int page_to_nid(const struct page *page)
 {
-	return section_to_node_table[page_to_section(page)];
+	return section_to_node_table[memdesc_section(page->flags)];
 }
 EXPORT_SYMBOL(page_to_nid);
 
-- 
2.47.2


