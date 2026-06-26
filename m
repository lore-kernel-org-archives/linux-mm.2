Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA30CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC576B00C4; Thu, 25 Jun 2026 23:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5AA6B00C6; Thu, 25 Jun 2026 23:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3CA6B00C7; Thu, 25 Jun 2026 23:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81F106B00C4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:20:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 076DD1A0314
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:20:31 +0000 (UTC)
X-FDA: 84920611062.21.ADC8220
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 422A11C0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:20:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fZbEO1tL;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782444029;
	b=UjhNFFaP9o4AXkrxMEtsEF61MRij22Ck3jCtD6yblp64q0jA1P3f9uH+wcJ6erfST9EBzB
	bnf6cpiG0lI4AH/tD5BsxZkq2DSo2t5jIeC94buARpA0L3PMmxMLXpchOhPblcz7lCXTMd
	9LFZbyP8KBxHAFC189ycVGyZvdlP2BI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782444029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z+jrTmuUXWf0qKSmtsfEFj8rLfN5Zd2Qr+1+6/wY3MU=;
	b=iAYflomDq6K5G0i90uYniLV1D6w+7DVrj/753v8Yz0br8H0QLx9Xhn9SgdraqB6/GwGazm
	4ls6uuhV2Gf1azkp2XW+1RIGXCAcy/OW25t1Mn6RtXD6OuQdn62uTWrqT+SYq8CjAXi/BP
	kiQU4PgAEIujGkfSIlJFnu5u979ctUE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fZbEO1tL;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782444027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z+jrTmuUXWf0qKSmtsfEFj8rLfN5Zd2Qr+1+6/wY3MU=;
	b=fZbEO1tL0dvVBk98/Btdrsm1UwIe1ZFNJUZ8qZowfMyzeyh+IIqt23QNbfU4olfZu6PFNE
	7ZEvTsDK6jr2tLHVEhkq4LRbFkAAUeSjeM0gmbNU2VQ63AqtHnC1AHbAZhmkCiXgYBBoOM
	MsauUDvBbHj2LyidwUALvJ9W0Da4D6Y=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v7] mm: assert exclusive nid/zonenum bits at the page/folio access sites
Date: Fri, 26 Jun 2026 11:20:12 +0800
Message-ID: <20260626032012.1049667-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xxs6zuwq57tyt98uad3qrfac38efcm7a
X-Rspam-User: 
X-Rspamd-Queue-Id: 422A11C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782444029-325542
X-HE-Meta: U2FsdGVkX1+Jyex7wpTd5s7SNEPXZm+YkTqW60RbEKrvYiQrV5Q9rx1WFTBSga22sBSjiIxZ04vYX0zP+R73ihqTQLa7XTo2QEkW7UVqU5WMMdASLSwf5YkM1ggVdBdzheoWBJk3NRe0iZ/bd6myk6uzs8wYP4R7dnBAP2TMv1S6od6nphM/MtgkpxVfRtNwdwy2vYwmZi3rVG+wro7Zn1hSKCmoJNHXXn7lyJE9BAgxJktpbyXvqoxwwHsUpdvXhaAeNDxLnVgLxo/Tnf5Xvq206fGr5m+INtiqrzekKRNPwFkcFibbka8QogQSmSytPYwJ0lSc+sGOgCmzKeL+Nd5VjhbnGl0f+PZ/wsMyI0djEbVI7VEOiSruGWiF2YNF+isttksnIPHR/YSQJY2C0msj+cL1hydLz9doS+E8C4MSV10B14PUzP1JNDA4VEw9iK0OwXNiSPmXnL09EKAN+8n53MVZs9dwEGM94fxNrii7IPgJpph32eTc8ZZAuExP8GAjJwHfnbGYN1EXDHD4BOq/mqZVTCyBBHLh+4LpeMk+agXg77bcpxATTjRgNipr/OKCz/pR6I4qpCii9OLEi3G9tAa54h9eNL+xRWnIY+XK56gW0Ou0F6h+WSAnNzNi5XfqAPfBxor5nNR6XpO07jYlR1vKCaIY2mFa9lif5i84MahyLVIoMwqUOi9GlX8toe3cURWEeNY8R0eqj0jKHur63o/EnNNOY8nofBnM8SNgMCyBOSdqyOljMZpTes7ax5f4U94b2xJ7+omyC4h8UWSXYQK9gYDuE6pMTFQvL8ly6ZfMgd+mwZzBfRUYpF9YbqX2xKdxwsMGLxBas1aeu2rm46eq+vtnaxMzDFsFhftOBuPHlq/39YoiJJD3FC7qSBGTrD7N+9b5i3u5huBCKInkF/j33s8PuxfR7/fWUqtU2j5hmqRSVFK/i9o8qnKe6ybHlzfg8ray9BEeLQH
 yeaaMsam
 S+4D2HuOY9mAupPA/lhdCyefucYuo67o7GSgipVzenIX2lI8dOhUQZh5sKASlNWYUpqnlGJNyguAPL/FFapPg2L56915J+32P9F91xY/mxwk49498t1kaU+7G9/FkTrxvbaQ/ODJS4S+06sbj9mMylqUsCySKR9pkIwJdLOyY0bHE42bUHgZMM65j1RTG009WY7SED+r6W6P1M20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id and zone id occupy fixed bit-ranges of page->flags that
are set once at page init and never modified afterwards, so they can
never overlap with the low PG_locked/PG_waiters bits touched by the
folio lock path.

ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
used to check a by-value copy of the flags word, not the actual shared
page->flags/folio->flags being modified concurrently, so it didn't
reliably assert anything about the real race.

For zonenum, move the assertion out of memdesc_zonenum() into
page_zonenum() and folio_zonenum(), where flags is dereferenced
directly from the page/folio.

For nid, turn memdesc_nid() into a macro instead, so the mdf argument
is expanded as the caller's own flags expression
(PF_POISONED_CHECK(page)->flags or folio->flags) rather than copied
into a function parameter, letting ASSERT_EXCLUSIVE_BITS() check the
real page->flags/folio->flags directly.

On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
folded to a constant, so page->flags/folio->flags was never actually
read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
folded away, so doing it unconditionally would add a pointless read
of page->flags/folio->flags and a check that can never fire. Keep
page_to_nid()/folio_nid() as plain "return 0" static inline stubs
under CONFIG_NUMA=n instead.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v7:
According to the comments of Sashiko, restrict the memdesc_nid() macro
to CONFIG_NUMA, keeping a plain "return 0" static inline stub otherwise,
and re-add a local page pointer in page_to_nid() to avoid evaluating
PF_POISONED_CHECK(page) twice.
v6:
According to the comments of David, turn memdesc_nid() from a static
inline function into a macro so ASSERT_EXCLUSIVE_BITS() can check the
caller's page->flags/folio->flags directly.
v5:
According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
ZONES_WIDTH != 0 (for zonenum).
According to the comments of David, avoid calling
PF_POISONED_CHECK(page) twice in page_to_nid().
According to the warning of lkp, switch the CONFIG_NUMA=n
page_to_nid()/folio_nid() stubs from macros to static inline functions.
v4:
According to the comments of Andrew and Sashiko, set
page_to_nid()/folio_nid() as static inline stubs returning 0
under CONFIG_NUMA=n.
v3:
According to the comments of Andrew and Sashiko, move
ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
into the page/folio call sites.
v2:
According to the comments of David, remove useless comments and use
ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
page_to_nid().

 include/linux/mm.h     | 25 +++++++++++++++++++++++--
 include/linux/mmzone.h |  7 ++++++-
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..63fcf277b675 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2288,21 +2288,42 @@ static inline int page_zone_id(struct page *page)
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 int memdesc_nid(memdesc_flags_t mdf);
 #else
+#ifdef CONFIG_NUMA
+#define memdesc_nid(mdf)						\
+({									\
+	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);	\
+	(int)((mdf.f >> NODES_PGSHIFT) & NODES_MASK);			\
+})
+#else
 static inline int memdesc_nid(memdesc_flags_t mdf)
 {
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
+	return 0;
 }
 #endif
 
+#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	const struct page *p = PF_POISONED_CHECK(page);
+
+	return memdesc_nid(p->flags);
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
 	return memdesc_nid(folio->flags);
 }
+#else
+static inline int page_to_nid(const struct page *page)
+{
+	return 0;
+}
+
+static inline int folio_nid(const struct folio *folio)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_NUMA_BALANCING
 /* page access time bits needs to hold at least 4 seconds */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..1b4336098113 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1274,17 +1274,22 @@ static inline bool zone_is_empty(const struct zone *zone)
 
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 {
-	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
 	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+#if ZONES_WIDTH != 0
+	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
+#endif
 	return memdesc_zonenum(page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
+#if ZONES_WIDTH != 0
+	ASSERT_EXCLUSIVE_BITS(folio->flags, ZONES_MASK << ZONES_PGSHIFT);
+#endif
 	return memdesc_zonenum(folio->flags);
 }
 
-- 
2.43.0


