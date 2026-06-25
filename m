Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22741CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7816B00D3; Thu, 25 Jun 2026 03:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167876B00D4; Thu, 25 Jun 2026 03:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0563F6B00D5; Thu, 25 Jun 2026 03:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB7516B00D3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:19:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A0201A04FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:19:03 +0000 (UTC)
X-FDA: 84917583366.30.0C82C42
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 616FE100004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:19:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PqO7Ml3w;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782371941;
	b=EVdfQEZ0ubXiV6zjRmh/2UqDJPudl9ll/xnfLXYLWOLla8RYn90BLwR+DYiI1YXrur0mX3
	Bji3DDAv6E35JbrSw9Cd7V1TVN4BNxntL/CSFL8H166LwNsCUCZxyK2I2gzai2z2FQQ8B8
	ppNX+AD4k0rT02zWpkFx65L3/j3kqK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DtqYjf8o+h1s++eJw/fsOV0DeEGdtcrbKOFqYGZRieA=;
	b=JHJMK/uuBiMBcKMmU4q3v+c7DgQCQwT3gNH63vnAADT1sGe+/4TTcotdqsZxEiu9p4YtVv
	SUCqT5eCXyVWPi+mSqPpXWW33adYkDVXPAw4r81rwQkkkYdOmxfZoHshKjbpO1BNjnm0Yy
	UJ0ASpl4T841t/PwnTiRpXuAVRB7vw8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PqO7Ml3w;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782371940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DtqYjf8o+h1s++eJw/fsOV0DeEGdtcrbKOFqYGZRieA=;
	b=PqO7Ml3wa+JfLzJlv1ArftxG904CUk8YpV39I/r32sfJPKf8Dh5TmPp4LIGyjUkNT4HLER
	koF9sKb7na0DZIsLR919G6MgcnoYfz3sQ5G9usEglaOj1Zg6fqSeL6/Wmti0IpRdk2eBFE
	SXlSyPzwWGsAyMLGryujVQ0+JwwGtSw=
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
Subject: [PATCH v5] mm: assert exclusive nid/zonenum bits at the page/folio access sites
Date: Thu, 25 Jun 2026 15:18:30 +0800
Message-ID: <20260625071830.996043-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ronaphiy3yn6u9uox5zmgk15rp71d1hr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 616FE100004
X-HE-Tag: 1782371941-387612
X-HE-Meta: U2FsdGVkX18SCArNR0LBgQy8+oFBtQd7z/VwF7GUN3aNXrxaw5XUx7OrrzP3etOXaVB38zpJa9KxNbicSr5iwltGbnylYcQ8aqGwwqQOc4p0oyzjI9yPg6Y4QZ0BeI0C3moU8FRDpKP0XhVV4Rodh1HFvIBjbyqmYqFJctoUia6oHCXoGahyUJL4DuWLl67cqsVRggK4xMS+c2LR08xGflB7caVO9hWdRJpJxaBoEWhtqpyBjiBKJ/FF/tFez3K8v/vz5LUVxIH+7eRlJ0y1vjB43MG/aV6Q6mccSi54r8PIIQhUHT1B4lKZ6gX+OjZbXbHK8HcZJsbKcOAPLJMVgPekDlZkZIl4ePdZLKXOXvyY7hWRcE8cnW3Yr1cpJdcRP8ry1BJQsW7IgeX4uAA7lbmxaENz3EmVu57OvXvkNNS32k1xeI4vXsxeelX3iwxbRvOTRkpvmgQ8Ezb3m1Lmv9B867WyfHvlwkaJYcfAg7gKvvHp3wLW641I7WG9SKafRpK0VUfTjgiAAnXQCaCXFgttWSl2OztwCSdmAU9nd0Uc+jUoJXzi5uzs00BGJnawkofS0Q3H/XTcbLnsCsiiSAEsupbeQzdrLio3gMG0eWRUSnmHcxqP5QGly7aZ8tYn2pomwYVNe24ShHqxJqGZsdxiWO7TB3EL62fnXbDG2mNr6VX3pnpTFiaN1PV9Zv/5CiFG61pwxJU5JMSl4rkDcxmtL/JWSAI07HSFIbj3/3uTihccEFXxGNjdoiOiTMtx51zPF+x1AxHcKPEcf+n+LAd5p9knMfKO6tdnXEWWUEKUa7AkAqAqDEYjixiOA+45MctTnR6QQOhU2iD/h930XhVwqCAXFXZI5XkwBcgdEIiHZqvIMZ2IiJMo6LlBzSYff2bzJwsutRPbMzGjx0wHb4yomSMhB4LP10ybOcuMJ58/Y3hzOJ2Xn1NIdhq7eiD2mA4NQ0WLn0OSi049P37
 5UxyvwDx
 glIAyZUmQ5mYTjY0DGzlcRHsDFa5T46t7LCBz/qLDZ2ZF2TIaRmTNw4J2B4GRdUKpsvmpHFrpWiBUQgkxYkwV9hVCUsIbGSD9IufdTXFZV7FENEaFyHYGvcHecDqywPG2TLLjWZLCyBXnuMwt3x9QBZYPMQ5jJelgX96hiybFU7Li8LLjIH9lUvlM8FazR9/OlYClYeow24RVyET0uNjcIEl3zaiaxOZyW653cJB5Als46qhjs0VJvLRj6BM/73cNVrKYurDMOT+TGlY=
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
checks a by-value copy of the flags word, not the actual shared
page->flags/folio->flags being modified concurrently, so it doesn't
reliably assert anything about the real race. Move the assertion to
page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
flags is dereferenced directly from the page/folio.

On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
folded to a constant, so page->flags/folio->flags was never actually
read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
folded away, so doing it unconditionally would add a pointless read
of page->flags/folio->flags and a check that can never fire. Keep
page_to_nid()/folio_nid() as plain "return 0" static inline stubs
under CONFIG_NUMA=n instead.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changelog:
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

 include/linux/mm.h     | 23 ++++++++++++++++++++++-
 include/linux/mmzone.h |  7 ++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..772bd1fc6fe7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2294,15 +2294,36 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
 }
 #endif
 
+#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	const struct page *p = PF_POISONED_CHECK(page);
+
+#ifndef NODE_NOT_IN_PAGE_FLAGS
+	ASSERT_EXCLUSIVE_BITS(p->flags, NODES_MASK << NODES_PGSHIFT);
+#endif
+	return memdesc_nid(p->flags);
 }
 
 static inline int folio_nid(const struct folio *folio)
 {
+#ifndef NODE_NOT_IN_PAGE_FLAGS
+	ASSERT_EXCLUSIVE_BITS(folio->flags,
+			      NODES_MASK << NODES_PGSHIFT);
+#endif
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


