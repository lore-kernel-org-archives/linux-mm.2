Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373B3C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCAD6B00B9; Tue,  5 Aug 2025 14:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4896B00BA; Tue,  5 Aug 2025 14:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9DF6B00BB; Tue,  5 Aug 2025 14:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC32E6B00B9
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:20:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24CE8B700E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:31 +0000 (UTC)
X-FDA: 83743519062.12.CD47C2D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1AD2D10000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:20:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MXISGXoN
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmRaSx+23aVJBc5QHkJN21sxzJeYypAK/wqyWZV5lyo=;
	b=sdCEORsDW+U86jjXbPzFv6Pwh2Kvz2oegyIcQZk7Y/rktJ0xI5Dd8qmZITAsqZtseVd+i6
	ct+o9qPcf0X5D3vPfHYbM40WTQRK28t7qm8lnu3IWRYRYJxCovZkOBbMtb0CDNcM1NPvpW
	Ft3/Undk2n+whZcn74kILWwIdczoA0o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MXISGXoN;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418029; a=rsa-sha256;
	cv=none;
	b=ADV/1v7sGNzu6uirnCOE/bXBpTXk6LP314j3EEYTnQYDQ8lFU1vtYYTOS3bak6gi2u1GjD
	4r9XUlxeoaQ/Dvw40Gl0RFCsidApQKuJ4V+nDRR3voyifkrWlnLMCihU48iyET0Or6P8Dd
	5Eup2UNah/ZKS7hM9Di4f0/3GMHkKdA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SmRaSx+23aVJBc5QHkJN21sxzJeYypAK/wqyWZV5lyo=; b=MXISGXoNx3kTf//CUxfbAKfsUD
	tF5JQcUxb8ibXdmmkno+J4PbmvGGtOGnPuvM1OLESY3dRxj75e6O4+w+fJYU6l8wkVHhI+SV42ckN
	wWa77bVR8KGfBilH4RO5HtPuIiJX/Qh8w7b1EpkGbTg5sRYr1A1c6v1gn+f2VaXU88I6z6aJzI6ek
	WvOl7ZQUscYSCM2hX9tMB7zA7+8MK3zs8tLuS9OGeAqXNjMcnaHLSqC/ENNGhjnqFRGyMKhloJX/U
	5yYE/tdGS+ev41IIqM8TvFY4sZGtaoKxyvJHh/R/q6dTJLS8vGxWwzGiR3OiacqBUtUKbD7FsRyDv
	+5EasseA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNV-00000005T4T-2cLi;
	Tue, 05 Aug 2025 17:23:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm: Introduce memdesc_flags_t
Date: Tue,  5 Aug 2025 18:22:51 +0100
Message-ID: <20250805172307.1302730-2-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AD2D10000A
X-Rspamd-Server: rspam06
X-Stat-Signature: uyptjquweqofuhqx9bpmuterepp1xu69
X-HE-Tag: 1754418028-958087
X-HE-Meta: U2FsdGVkX1/RcLuir1Qr5QUtnS7Zfxw6EQHFleiZ/juJBmh3OhJY2KTJgVPNNBaNoDXwxj0YqyhK03wQXjLQtUIyCgin8ul+AhmLGw++dIoCijmQ9HBpcDAWMIRZhgSB93ZdcazF7gvMjmyWaPPrCc9ilz06L883XPnA2QRCU/6YcmBtLsyr9TU/+L4kq4hGMOzUPOJMFrKLCswCBEnQl89a8HHAJKpwZ5nP4pDBDCduYQJ9WacTD15p+0pOBer4dlGe7b4Lw/MiKY9QLiVPK9d9xYn9JsRCpQj+HPp8ajlE9YxjjByhp5TiPjnuhBs9r3IhN1MhrfUkzjbANfyFBUgy5pPcO2PSwuNophUYYwKBDXCH0jbnMYRksRRcyLpd37czy4ne1U7OGnj8NfXV2p8B1Pj8cm5iLWjJnqdVztt4IoDma90ejLXPAC7vrEdqnJ2KfUxgLHCE4bOGpePVXXv/7yEQqwJaeS0kBZ745DMch0yWW5tSK2PQWocf+ZulhyQbLKeSPv/oiad6uzAfvcvOgkHLKAK0tnAEIBzdq1E5Bg+tYx6ry0InepWKhDWAl5/BTut214CHnNb2QLhLCowqAxu4ttKU2wZS1EcJp8/DTuDlHrFC1+RfaKF3+WdZMdqbxA80Un4z1YwAXNEw0a/ppg+LjlljrReuwHHeGB2Y3hWyIpxfXTaQ+Ty1CuSLJj17A3AyUdgk3o7Fm6TrjZv8RHq1zxEAFHEkcJyRhSPPyhOOVHibP+5kfnDyixhVmwFLMqqr0HbBstctQrg3nNF3JfNr9jctB2tz3SBXGTgyZ+WwtJz8Vb8P26n2y87o5ARDrD5PKb52Wx3y2Km5RzJQJX7fXG/ig0BoXPhHUmhA0TiTEBQLPUbKRhqaiTRJHSw0wGaU1w/2x/FHp7crxDl30GjwPIqk2XfEgEqfz8EaN+rloYcfpw0nktj/qTO03OF1Ovjr78pvv0dsx6H
 6UMlj2ho
 s2vrrN3IEYgA2VrGAb9nkeI57JmRheQ0Xy31L5zQgARh1mNxQGJoa1MMfkSJF1lb1aMhThvk5dQIdt7PdlRSLpDFAYcWKDx3oNoSzuwdGQxh4pf+1s8839lDezaauWXjGF44fSUISJlgXJ0KZPaa9R43AD/WaBrWxRcuXD2DqfPase6llSCPWobCm7ecjJZvmP3IMg9c+48/tXX7VEum+BXKRAuyymrT+daPvSxWkd2HcoIsAF8qurqv5vO1yNHsenJYhMR8VOtiZgcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrap the unsigned long flags in a typedef.  In upcoming patches, this
will provide a strong hint that you can't just pass a random unsigned
long to functions which take this as an argument.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/x86/mm/pat/memtype.c       |  6 ++---
 fs/fuse/dev.c                   |  2 +-
 fs/gfs2/glops.c                 |  2 +-
 fs/jffs2/file.c                 |  4 ++--
 fs/nilfs2/page.c                |  2 +-
 fs/proc/page.c                  |  4 ++--
 fs/ubifs/file.c                 |  6 ++---
 include/linux/mm.h              | 32 +++++++++++++-------------
 include/linux/mm_inline.h       | 12 +++++-----
 include/linux/mm_types.h        |  8 +++++--
 include/linux/mmzone.h          |  2 +-
 include/linux/page-flags.h      | 40 ++++++++++++++++-----------------
 include/linux/pgalloc_tag.h     |  7 +++---
 include/trace/events/page_ref.h |  4 ++--
 mm/filemap.c                    |  8 +++----
 mm/huge_memory.c                |  4 ++--
 mm/memory-failure.c             | 12 +++++-----
 mm/mmzone.c                     |  4 ++--
 mm/page_alloc.c                 | 12 +++++-----
 mm/swap.c                       |  8 +++----
 mm/vmscan.c                     | 18 +++++++--------
 mm/workingset.c                 |  2 +-
 22 files changed, 102 insertions(+), 97 deletions(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index c09284302dd3..b68200a0e0c6 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -126,7 +126,7 @@ __setup("debugpat", pat_debug_setup);
 
 static inline enum page_cache_mode get_page_memtype(struct page *pg)
 {
-	unsigned long pg_flags = pg->flags & _PGMT_MASK;
+	unsigned long pg_flags = pg->flags.f & _PGMT_MASK;
 
 	if (pg_flags == _PGMT_WB)
 		return _PAGE_CACHE_MODE_WB;
@@ -161,10 +161,10 @@ static inline void set_page_memtype(struct page *pg,
 		break;
 	}
 
-	old_flags = READ_ONCE(pg->flags);
+	old_flags = READ_ONCE(pg->flags.f);
 	do {
 		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
-	} while (!try_cmpxchg(&pg->flags, &old_flags, new_flags));
+	} while (!try_cmpxchg(&pg->flags.f, &old_flags, new_flags));
 }
 #else
 static inline enum page_cache_mode get_page_memtype(struct page *pg)
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index e80cd8f2c049..8a89f0aa1d4d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -935,7 +935,7 @@ static int fuse_check_folio(struct folio *folio)
 {
 	if (folio_mapped(folio) ||
 	    folio->mapping != NULL ||
-	    (folio->flags & PAGE_FLAGS_CHECK_AT_PREP &
+	    (folio->flags.f & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
 	       1 << PG_referenced |
 	       1 << PG_lru |
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index fe0faad4892f..0c0a80b3baca 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -40,7 +40,7 @@ static void gfs2_ail_error(struct gfs2_glock *gl, const struct buffer_head *bh)
 	       "AIL buffer %p: blocknr %llu state 0x%08lx mapping %p page "
 	       "state 0x%lx\n",
 	       bh, (unsigned long long)bh->b_blocknr, bh->b_state,
-	       bh->b_folio->mapping, bh->b_folio->flags);
+	       bh->b_folio->mapping, bh->b_folio->flags.f);
 	fs_err(sdp, "AIL glock %u:%llu mapping %p\n",
 	       gl->gl_name.ln_type, gl->gl_name.ln_number,
 	       gfs2_glock2aspace(gl));
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index dd3dff95cb24..b697f3c259ef 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -230,7 +230,7 @@ static int jffs2_write_begin(const struct kiocb *iocb,
 			goto release_sem;
 		}
 	}
-	jffs2_dbg(1, "end write_begin(). folio->flags %lx\n", folio->flags);
+	jffs2_dbg(1, "end write_begin(). folio->flags %lx\n", folio->flags.f);
 
 release_sem:
 	mutex_unlock(&c->alloc_sem);
@@ -259,7 +259,7 @@ static int jffs2_write_end(const struct kiocb *iocb,
 
 	jffs2_dbg(1, "%s(): ino #%lu, page at 0x%llx, range %d-%d, flags %lx\n",
 		  __func__, inode->i_ino, folio_pos(folio),
-		  start, end, folio->flags);
+		  start, end, folio->flags.f);
 
 	/* We need to avoid deadlock with page_cache_read() in
 	   jffs2_garbage_collect_pass(). So the folio must be
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 806b056d2260..56c4da417b6a 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -167,7 +167,7 @@ void nilfs_folio_bug(struct folio *folio)
 	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
 	       "mapping=%p ino=%lu\n",
 	       folio, folio_ref_count(folio),
-	       (unsigned long long)folio->index, folio->flags, m, ino);
+	       (unsigned long long)folio->index, folio->flags.f, m, ino);
 
 	head = folio_buffers(folio);
 	if (head) {
diff --git a/fs/proc/page.c b/fs/proc/page.c
index ba3568e97fd1..771e0b6bc630 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -163,7 +163,7 @@ u64 stable_page_flags(const struct page *page)
 	snapshot_page(&ps, page);
 	folio = &ps.folio_snapshot;
 
-	k = folio->flags;
+	k = folio->flags.f;
 	mapping = (unsigned long)folio->mapping;
 	is_anon = mapping & FOLIO_MAPPING_ANON;
 
@@ -238,7 +238,7 @@ u64 stable_page_flags(const struct page *page)
 	if (u & (1 << KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
-		u |= kpf_copy_bit(ps.page_snapshot.flags, KPF_HWPOISON, PG_hwpoison);
+		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
 #endif
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index e75a6cec67be..ca41ce8208c4 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -107,7 +107,7 @@ static int do_readpage(struct folio *folio)
 	size_t offset = 0;
 
 	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
-		inode->i_ino, folio->index, i_size, folio->flags);
+		inode->i_ino, folio->index, i_size, folio->flags.f);
 	ubifs_assert(c, !folio_test_checked(folio));
 	ubifs_assert(c, !folio->private);
 
@@ -600,7 +600,7 @@ static int populate_page(struct ubifs_info *c, struct folio *folio,
 	pgoff_t end_index;
 
 	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
-		inode->i_ino, folio->index, i_size, folio->flags);
+		inode->i_ino, folio->index, i_size, folio->flags.f);
 
 	end_index = (i_size - 1) >> PAGE_SHIFT;
 	if (!i_size || folio->index > end_index) {
@@ -988,7 +988,7 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
 	int err, len = folio_size(folio);
 
 	dbg_gen("ino %lu, pg %lu, pg flags %#lx",
-		inode->i_ino, folio->index, folio->flags);
+		inode->i_ino, folio->index, folio->flags.f);
 	ubifs_assert(c, folio->private != NULL);
 
 	/* Is the folio fully outside @i_size? (truncate in progress) */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 349f0d9aad22..779822a829a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -973,7 +973,7 @@ static inline unsigned int compound_order(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (!test_bit(PG_head, &folio->flags))
+	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
 	return folio_large_order(folio);
 }
@@ -1503,7 +1503,7 @@ static inline bool is_nommu_shared_mapping(vm_flags_t flags)
  */
 static inline int page_zone_id(struct page *page)
 {
-	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
+	return (page->flags.f >> ZONEID_PGSHIFT) & ZONEID_MASK;
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -1511,7 +1511,7 @@ int page_to_nid(const struct page *page);
 #else
 static inline int page_to_nid(const struct page *page)
 {
-	return (PF_POISONED_CHECK(page)->flags >> NODES_PGSHIFT) & NODES_MASK;
+	return (PF_POISONED_CHECK(page)->flags.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
@@ -1586,14 +1586,14 @@ static inline void page_cpupid_reset_last(struct page *page)
 #else
 static inline int folio_last_cpupid(struct folio *folio)
 {
-	return (folio->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
+	return (folio->flags.f >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 }
 
 int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->flags |= LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
+	page->flags.f |= LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
 }
 #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
 
@@ -1689,7 +1689,7 @@ static inline u8 page_kasan_tag(const struct page *page)
 	u8 tag = KASAN_TAG_KERNEL;
 
 	if (kasan_enabled()) {
-		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
+		tag = (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
 		tag ^= 0xff;
 	}
 
@@ -1704,12 +1704,12 @@ static inline void page_kasan_tag_set(struct page *page, u8 tag)
 		return;
 
 	tag ^= 0xff;
-	old_flags = READ_ONCE(page->flags);
+	old_flags = READ_ONCE(page->flags.f);
 	do {
 		flags = old_flags;
 		flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
 		flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
-	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
+	} while (unlikely(!try_cmpxchg(&page->flags.f, &old_flags, flags)));
 }
 
 static inline void page_kasan_tag_reset(struct page *page)
@@ -1753,13 +1753,13 @@ static inline pg_data_t *folio_pgdat(const struct folio *folio)
 #ifdef SECTION_IN_PAGE_FLAGS
 static inline void set_page_section(struct page *page, unsigned long section)
 {
-	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
-	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
+	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
+	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
 static inline unsigned long page_to_section(const struct page *page)
 {
-	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
+	return (page->flags.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #endif
 
@@ -1964,14 +1964,14 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 
 static inline void set_page_zone(struct page *page, enum zone_type zone)
 {
-	page->flags &= ~(ZONES_MASK << ZONES_PGSHIFT);
-	page->flags |= (zone & ZONES_MASK) << ZONES_PGSHIFT;
+	page->flags.f &= ~(ZONES_MASK << ZONES_PGSHIFT);
+	page->flags.f |= (zone & ZONES_MASK) << ZONES_PGSHIFT;
 }
 
 static inline void set_page_node(struct page *page, unsigned long node)
 {
-	page->flags &= ~(NODES_MASK << NODES_PGSHIFT);
-	page->flags |= (node & NODES_MASK) << NODES_PGSHIFT;
+	page->flags.f &= ~(NODES_MASK << NODES_PGSHIFT);
+	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
 static inline void set_page_links(struct page *page, enum zone_type zone,
@@ -2013,7 +2013,7 @@ static inline long compound_nr(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (!test_bit(PG_head, &folio->flags))
+	if (!test_bit(PG_head, &folio->flags.f))
 		return 1;
 	return folio_large_nr_pages(folio);
 }
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..150302b4a905 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -143,7 +143,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 
 static inline int folio_lru_refs(struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags);
+	unsigned long flags = READ_ONCE(folio->flags.f);
 
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
@@ -156,7 +156,7 @@ static inline int folio_lru_refs(struct folio *folio)
 
 static inline int folio_lru_gen(struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags);
+	unsigned long flags = READ_ONCE(folio->flags.f);
 
 	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
@@ -268,7 +268,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -293,7 +293,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -304,9 +304,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags) & LRU_REFS_MASK;
+	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
 
-	set_mask_bits(&new->flags, LRU_REFS_MASK, refs);
+	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
 }
 #else /* !CONFIG_LRU_GEN */
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 08bc2442db93..15bb1c3738c0 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -33,6 +33,10 @@ struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;
 
+typedef struct {
+	unsigned long f;
+} memdesc_flags_t;
+
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -71,7 +75,7 @@ struct mem_cgroup;
 #endif
 
 struct page {
-	unsigned long flags;		/* Atomic flags, some possibly
+	memdesc_flags_t flags;		/* Atomic flags, some possibly
 					 * updated asynchronously */
 	/*
 	 * Five words (20/40 bytes) are available in this union.
@@ -382,7 +386,7 @@ struct folio {
 	union {
 		struct {
 	/* public: */
-			unsigned long flags;
+			memdesc_flags_t flags;
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..b4852269da0e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1172,7 +1172,7 @@ static inline bool zone_is_empty(struct zone *zone)
 static inline enum zone_type page_zonenum(const struct page *page)
 {
 	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
-	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
+	return (page->flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8e4d6eda8a8d..822b3ba48163 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -217,7 +217,7 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	 * cold cacheline in some cases.
 	 */
 	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
-	    test_bit(PG_head, &page->flags)) {
+	    test_bit(PG_head, &page->flags.f)) {
 		/*
 		 * We can safely access the field of the @page[1] with PG_head
 		 * because the @page is a compound page composed with at least
@@ -325,14 +325,14 @@ static __always_inline int PageTail(const struct page *page)
 
 static __always_inline int PageCompound(const struct page *page)
 {
-	return test_bit(PG_head, &page->flags) ||
+	return test_bit(PG_head, &page->flags.f) ||
 	       READ_ONCE(page->compound_head) & 1;
 }
 
 #define	PAGE_POISON_PATTERN	-1l
 static inline int PagePoisoned(const struct page *page)
 {
-	return READ_ONCE(page->flags) == PAGE_POISON_PATTERN;
+	return READ_ONCE(page->flags.f) == PAGE_POISON_PATTERN;
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -349,8 +349,8 @@ static const unsigned long *const_folio_flags(const struct folio *folio,
 	const struct page *page = &folio->page;
 
 	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
-	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
-	return &page[n].flags;
+	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
+	return &page[n].flags.f;
 }
 
 static unsigned long *folio_flags(struct folio *folio, unsigned n)
@@ -358,8 +358,8 @@ static unsigned long *folio_flags(struct folio *folio, unsigned n)
 	struct page *page = &folio->page;
 
 	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
-	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
-	return &page[n].flags;
+	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
+	return &page[n].flags.f;
 }
 
 /*
@@ -449,37 +449,37 @@ FOLIO_CLEAR_FLAG(name, page)
 #define TESTPAGEFLAG(uname, lname, policy)				\
 FOLIO_TEST_FLAG(lname, FOLIO_##policy)					\
 static __always_inline int Page##uname(const struct page *page)		\
-{ return test_bit(PG_##lname, &policy(page, 0)->flags); }
+{ return test_bit(PG_##lname, &policy(page, 0)->flags.f); }
 
 #define SETPAGEFLAG(uname, lname, policy)				\
 FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void SetPage##uname(struct page *page)		\
-{ set_bit(PG_##lname, &policy(page, 1)->flags); }
+{ set_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define CLEARPAGEFLAG(uname, lname, policy)				\
 FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void ClearPage##uname(struct page *page)		\
-{ clear_bit(PG_##lname, &policy(page, 1)->flags); }
+{ clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define __SETPAGEFLAG(uname, lname, policy)				\
 __FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void __SetPage##uname(struct page *page)		\
-{ __set_bit(PG_##lname, &policy(page, 1)->flags); }
+{ __set_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
 __FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline void __ClearPage##uname(struct page *page)	\
-{ __clear_bit(PG_##lname, &policy(page, 1)->flags); }
+{ __clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
 FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestSetPage##uname(struct page *page)	\
-{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
+{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define TESTCLEARFLAG(uname, lname, policy)				\
 FOLIO_TEST_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestClearPage##uname(struct page *page)	\
-{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
+{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define PAGEFLAG(uname, lname, policy)					\
 	TESTPAGEFLAG(uname, lname, policy)				\
@@ -848,7 +848,7 @@ static __always_inline bool folio_test_head(const struct folio *folio)
 static __always_inline int PageHead(const struct page *page)
 {
 	PF_POISONED_CHECK(page);
-	return test_bit(PG_head, &page->flags) && !page_is_fake_head(page);
+	return test_bit(PG_head, &page->flags.f) && !page_is_fake_head(page);
 }
 
 __SETPAGEFLAG(Head, head, PF_ANY)
@@ -1172,28 +1172,28 @@ static __always_inline int PageAnonExclusive(const struct page *page)
 	 */
 	if (PageHuge(page))
 		page = compound_head(page);
-	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 static __always_inline void __ClearPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 #ifdef CONFIG_MMU
@@ -1243,7 +1243,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
+	return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
 }
 
 #undef PF_ANY
diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
index 8a7f4f802c57..38a82d65e58e 100644
--- a/include/linux/pgalloc_tag.h
+++ b/include/linux/pgalloc_tag.h
@@ -107,7 +107,8 @@ static inline bool get_page_tag_ref(struct page *page, union codetag_ref *ref,
 	if (static_key_enabled(&mem_profiling_compressed)) {
 		pgalloc_tag_idx idx;
 
-		idx = (page->flags >> alloc_tag_ref_offs) & alloc_tag_ref_mask;
+		idx = (page->flags.f >> alloc_tag_ref_offs) &
+			alloc_tag_ref_mask;
 		idx_to_ref(idx, ref);
 		handle->page = page;
 	} else {
@@ -149,11 +150,11 @@ static inline void update_page_tag_ref(union pgtag_ref_handle handle, union code
 		idx = (unsigned long)ref_to_idx(ref);
 		idx = (idx & alloc_tag_ref_mask) << alloc_tag_ref_offs;
 		do {
-			old_flags = READ_ONCE(page->flags);
+			old_flags = READ_ONCE(page->flags.f);
 			flags = old_flags;
 			flags &= ~(alloc_tag_ref_mask << alloc_tag_ref_offs);
 			flags |= idx;
-		} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
+		} while (unlikely(!try_cmpxchg(&page->flags.f, &old_flags, flags)));
 	} else {
 		if (WARN_ON(!handle.ref || !ref))
 			return;
diff --git a/include/trace/events/page_ref.h b/include/trace/events/page_ref.h
index fe33a255b7d0..ea6b5c4baf3d 100644
--- a/include/trace/events/page_ref.h
+++ b/include/trace/events/page_ref.h
@@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_template,
 
 	TP_fast_assign(
 		__entry->pfn = page_to_pfn(page);
-		__entry->flags = page->flags;
+		__entry->flags = page->flags.f;
 		__entry->count = page_ref_count(page);
 		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
@@ -77,7 +77,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_and_test_template,
 
 	TP_fast_assign(
 		__entry->pfn = page_to_pfn(page);
-		__entry->flags = page->flags;
+		__entry->flags = page->flags.f;
 		__entry->count = page_ref_count(page);
 		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..2e63f98c9520 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1140,10 +1140,10 @@ static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync,
 	 */
 	flags = wait->flags;
 	if (flags & WQ_FLAG_EXCLUSIVE) {
-		if (test_bit(key->bit_nr, &key->folio->flags))
+		if (test_bit(key->bit_nr, &key->folio->flags.f))
 			return -1;
 		if (flags & WQ_FLAG_CUSTOM) {
-			if (test_and_set_bit(key->bit_nr, &key->folio->flags))
+			if (test_and_set_bit(key->bit_nr, &key->folio->flags.f))
 				return -1;
 			flags |= WQ_FLAG_DONE;
 		}
@@ -1226,9 +1226,9 @@ static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
 					struct wait_queue_entry *wait)
 {
 	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
-		if (test_and_set_bit(bit_nr, &folio->flags))
+		if (test_and_set_bit(bit_nr, &folio->flags.f))
 			return false;
-	} else if (test_bit(bit_nr, &folio->flags))
+	} else if (test_bit(bit_nr, &folio->flags.f))
 		return false;
 
 	wait->flags |= WQ_FLAG_WOKEN | WQ_FLAG_DONE;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..6b5f8b0db6c4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3310,8 +3310,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
-		new_folio->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_folio->flags |= (folio->flags &
+		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		new_folio->flags.f |= (folio->flags.f &
 				((1L << PG_referenced) |
 				 (1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3047b9ac667e..718eb37bd077 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1693,10 +1693,10 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 	 * carried out only if the first check can't determine the page status.
 	 */
 	for (ps = error_states;; ps++)
-		if ((p->flags & ps->mask) == ps->res)
+		if ((p->flags.f & ps->mask) == ps->res)
 			break;
 
-	page_flags |= (p->flags & (1UL << PG_dirty));
+	page_flags |= (p->flags.f & (1UL << PG_dirty));
 
 	if (!ps->mask)
 		for (ps = error_states;; ps++)
@@ -2123,7 +2123,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
 
-	page_flags = folio->flags;
+	page_flags = folio->flags.f;
 
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
@@ -2384,7 +2384,7 @@ int memory_failure(unsigned long pfn, int flags)
 	 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
 	 * status correctly, we save a copy of the page flags at this time.
 	 */
-	page_flags = folio->flags;
+	page_flags = folio->flags.f;
 
 	/*
 	 * __munlock_folio() may clear a writeback folio's LRU flag without
@@ -2730,13 +2730,13 @@ static int soft_offline_in_use_page(struct page *page)
 				putback_movable_pages(&pagelist);
 
 			pr_info("%#lx: %s migration failed %ld, type %pGp\n",
-				pfn, msg_page[huge], ret, &page->flags);
+				pfn, msg_page[huge], ret, &page->flags.f);
 			if (ret > 0)
 				ret = -EBUSY;
 		}
 	} else {
 		pr_info("%#lx: %s isolation failed, page count %d, type %pGp\n",
-			pfn, msg_page[huge], page_count(page), &page->flags);
+			pfn, msg_page[huge], page_count(page), &page->flags.f);
 		ret = -EBUSY;
 	}
 	return ret;
diff --git a/mm/mmzone.c b/mm/mmzone.c
index f9baa8882fbf..0c8f181d9d50 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -99,14 +99,14 @@ int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 	unsigned long old_flags, flags;
 	int last_cpupid;
 
-	old_flags = READ_ONCE(folio->flags);
+	old_flags = READ_ONCE(folio->flags.f);
 	do {
 		flags = old_flags;
 		last_cpupid = (flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 
 		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 		flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
-	} while (unlikely(!try_cmpxchg(&folio->flags, &old_flags, flags)));
+	} while (unlikely(!try_cmpxchg(&folio->flags.f, &old_flags, flags)));
 
 	return last_cpupid;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..b6c040f7be85 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -950,7 +950,7 @@ static inline void __free_one_page(struct page *page,
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
+	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -1043,7 +1043,7 @@ static inline bool page_expected_state(struct page *page,
 			page->memcg_data |
 #endif
 			page_pool_page_is_pp(page) |
-			(page->flags & check_flags)))
+			(page->flags.f & check_flags)))
 		return false;
 
 	return true;
@@ -1059,7 +1059,7 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
 		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & flags)) {
+	if (unlikely(page->flags.f & flags)) {
 		if (flags == PAGE_FLAGS_CHECK_AT_PREP)
 			bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag(s) set";
 		else
@@ -1358,7 +1358,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 		int i;
 
 		if (compound) {
-			page[1].flags &= ~PAGE_FLAGS_SECOND;
+			page[1].flags.f &= ~PAGE_FLAGS_SECOND;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 			folio->_nr_pages = 0;
 #endif
@@ -1372,7 +1372,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 					continue;
 				}
 			}
-			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (folio_test_anon(folio)) {
@@ -1391,7 +1391,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 	}
 
 	page_cpupid_reset_last(page);
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
diff --git a/mm/swap.c b/mm/swap.c
index 3632dd061beb..d2a23aa8d5ac 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -387,14 +387,14 @@ static void __lru_cache_activate_folio(struct folio *folio)
 
 static void lru_gen_inc_refs(struct folio *folio)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
+	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	if (folio_test_unevictable(folio))
 		return;
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio)) {
-		set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_referenced));
+		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return;
 	}
 
@@ -406,7 +406,7 @@ static void lru_gen_inc_refs(struct folio *folio)
 		}
 
 		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
-	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
+	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -418,7 +418,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(&folio->flags, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
 	lrugen = &folio_lruvec(folio)->lrugen;
 	/* whether can do without shuffling under the LRU lock */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7de11524a936..edb3c992b117 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -888,11 +888,11 @@ static bool lru_gen_set_refs(struct folio *folio)
 {
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
-		set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_referenced));
+		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return false;
 	}
 
-	set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(PG_workingset));
+	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
 	return true;
 }
 #else
@@ -3257,13 +3257,13 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
 /* promote pages accessed through page tables */
 static int folio_update_gen(struct folio *folio, int gen)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
+	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
-		set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_referenced));
+		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return -1;
 	}
 
@@ -3274,7 +3274,7 @@ static int folio_update_gen(struct folio *folio, int gen)
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
-	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
+	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
@@ -3285,7 +3285,7 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclai
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
+	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
@@ -3302,7 +3302,7 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclai
 		/* for folio_end_writeback() */
 		if (reclaiming)
 			new_flags |= BIT(PG_reclaim);
-	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
+	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 
@@ -4553,7 +4553,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags, LRU_REFS_MASK, 0);
+		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
 	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
@@ -4766,7 +4766,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		/* don't add rejected folios to the oldest generation */
 		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(PG_active));
+			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);
diff --git a/mm/workingset.c b/mm/workingset.c
index 6e7f4cb1b9a7..68a76a91111f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -318,7 +318,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
-		set_mask_bits(&folio->flags, LRU_REFS_MASK, (refs - 1UL) << LRU_REFS_PGOFF);
+		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, (refs - 1UL) << LRU_REFS_PGOFF);
 unlock:
 	rcu_read_unlock();
 }
-- 
2.47.2


