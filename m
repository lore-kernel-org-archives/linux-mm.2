Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5FBCD6E63
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21078E0013; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A564B8E000B; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8A48E0016; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 582108E0013
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FE9B117A0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:54 +0000 (UTC)
X-FDA: 84105754908.19.AB19683
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13F34140018
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HW0Diu4b;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpAcD/oLPq11Em8U2aUUPhvE7TDEy/eV2uIu1sxtiDk=;
	b=pk6VyJ0fjp9EDWcW0WGK0KJxBR3FRjw8MXvz9dVI4IW19xuN4Kptt/H2LTBV5X2XHitF0E
	VplTeI28eU2uveGnt1GbSoz89BEGYh0W/dP4+7jLtcEG9V62yz4mj30Jw3S9NjoVVpxJvo
	5Z0MAloeCKb2YJ47vcyeatgv8BqKPYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042692; a=rsa-sha256;
	cv=none;
	b=Q/ngfsEVuQGpLwMe6MDuJeV+fhsfZhyHvXX+LVI5LWZtLV0ynRBBOvS+YkSDcmEtxqNM0J
	zRCn2YTyAA4pGtpI/DMyVHpL0LTUEZrORqK6KXAB+74+UI9v8a9Vb8I07478mnfxedDW7y
	MDOsoep6/dAuARbI/g7+3K+KkFr8X2A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HW0Diu4b;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=mpAcD/oLPq11Em8U2aUUPhvE7TDEy/eV2uIu1sxtiDk=; b=HW0Diu4bVj/JeQ5D+CgUIV3fOx
	39261YwcdBAzwkzckB4cr7NJBlYj/deWcibyQ0GEriWvJi43ZULPlCOMdqKvJLURZrAx8Xjd2fcyy
	E0iF6031uYRaPXmEYNnh2N1gRTjYJoMWZt4b9hBtaXF15JXC2yYqmxuP8ll+sE0kt9WE2I6obVGKB
	U7BqqTkV8lcdFVUqusAoXccSJ+NiCWEiTm+A3Wy2RBltnGrcgaEAFxZoRR8vPzIv4K+13nLyydVfc
	wDbH/49SdthpfTKRgsgCUQuRzkWftQyWcTTOhApx1Tyy8i5QmWKZqs9y5ARA5Pex/mebxccBk0jnk
	GV06zYMw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXwQ-00000007c8P-2I92;
	Thu, 13 Nov 2025 14:04:50 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm: Mark pagetable memory when allocated
Date: Thu, 13 Nov 2025 14:04:45 +0000
Message-ID: <20251113140448.1814860-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113140448.1814860-1-willy@infradead.org>
References: <20251113140448.1814860-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kaczoxog91g14ey3jxatdi56oufk1z57
X-Rspam-User: 
X-Rspamd-Queue-Id: 13F34140018
X-Rspamd-Server: rspam01
X-HE-Tag: 1763042691-247577
X-HE-Meta: U2FsdGVkX18/ValBai+xbBFWvkEgoeeEaFmBBsUi/9Cr8ome8b/IEHX/CNiK5VDgj5OCenY1cXZk7vD/YCPWHtXIuJ+rLeM3A5qJB9M9YkE8U0qXrv60DlIkeIWJSEnRUHC83k8jckjw9rcDLHutCs13NR06lQG6OA8YH4BP6Ocqgrxd38f6FQIMFWltYqSSVEKsL1xlyjRx83aWmIH0K2oGOjdDpkjD+wDPYxokZx0DDTwAbnncN+QkPA8LP3//R2wD0SoIaVI/nFIdEo+eDZRsy6zUIpS1wzshWF22Lj1CgyJyMUh011tMhCFYmmgPyeR2xGq0hV+k9tvIAsyO1+qgF1OHNYeOT5K5h446aCjppmybCoqlHanO2cFkJ7C7s5gyRyqfGzsGaPc6hHQu/jkyAv79vNMKlDuVB/31lR3QXaoG9ceIOBq6zSMoH1WN+PIWHqUXMTSHCqVDfpnhofGnRob/aY3yQvKywuIsYL/0DUjYpzWoloDaP7ndkhGmRtqZc0Q/kAiNRvo9LXQLz+equOl1/eGI/zuyYLdHzOo3D1D00QJza2XF07fsDT12ayYR9No4Gp7+EnQbjpbuw0v1jY6YGwA3zf0vmI/Jm9mFVIAuX0jr+BzyCxA3vk4jVXnMnOdL8/R0OYM5KFGVwDQ3Mb8mmkCiDkRZMMCAa/TUwjWHH4wAAgNxnwek6sK822dmeawpxc0NKzL6+w9OJMjmr/EI8GQGwUj9k18Id1qrxnxQLpy68w14R+jaklmUaer2wo7dJgKUU+KYYcdkTdxy8z0GeiMTbnN8Ek37tZ6tLUjG8GARdgQuKRYsXwiEvmXejHdDAgKroFOo3oycm5UlUug0Cj/Xgg4yhqVnq9d7gwdqayvGummJl3GEWCLlpCkqFE5J7xrgB9oGjSc5PgoGEjZsr2i9TZzMlk+dSyKlATgftK2GHF5HPjenh7RU8vnHB68EUbSiMrObalI
 QZTSp0b8
 Atx4c/PIYo6sIezuN3iKNv4JvH75C2EnOSu5lxYHwTq0/og4P7vdRX77yJj4ke7Ag7cmZL+FKGCpXCjb/6LUpHqbqlt3hPY5HnvBsxSeRLRwdbY3a6VMCWDJKWHFuFJZAqwfeLuYwa6eS96Tv5U1lVcbdEN1ZRz2wrHQVjhPsV973Il/LG9cET0yYLUDNpuE81CDSX+aPOg/ZP4+rk4hSwH5CulgvfbXOYzsUCnc4btmsaIqRPFRedG5yNUSOUjKv7Thur/QsW5df7SpelHcvtBLOKg+QU9oeq19NRm+5nLOwB4oDdy2cQt+56l5fah1BfxzZgq4Kimcn324VJv7PZYEG7v2nKN21m+6aqnc2YPaltf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the page type setting from the constructor to the allocation site.
Some of the architecture code is a little complex to reason about, but
I think this is all correct.  This makes __pagetable_ctor() empty, so
remove it.  While pagetable_pud_ctor() and higher levels are now empty,
leave them alone as there may be call to have them do something in future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 11 -----------
 mm/memory.c        |  2 ++
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17f783c04c87..3111344b8d05 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3082,15 +3082,9 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline void __pagetable_ctor(struct ptdesc *ptdesc)
-{
-	__SetPageTable(ptdesc_page(ptdesc));
-}
-
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	ptlock_free(ptdesc);
-	__ClearPageTable(ptdesc_page(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
@@ -3104,7 +3098,6 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 {
 	if (mm != &init_mm && !ptlock_init(ptdesc))
 		return false;
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3212,7 +3205,6 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3237,17 +3229,14 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
 
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
diff --git a/mm/memory.c b/mm/memory.c
index 35886fde189c..54480b12eb8c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7358,6 +7358,7 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 
 	pgdat = NODE_DATA(page_to_nid(page));
 	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
+	__SetPageTable(page);
 	return page_ptdesc(page);
 }
 
@@ -7379,6 +7380,7 @@ void pagetable_free(struct ptdesc *pt)
 		return;
 	}
 	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
+	__ClearPageTable(page);
 	free_frozen_pages(page, order);
 }
 
-- 
2.47.2


