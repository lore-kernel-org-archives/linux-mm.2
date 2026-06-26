Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20104CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3FC6B0088; Thu, 25 Jun 2026 22:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5136B0099; Thu, 25 Jun 2026 22:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25636B009B; Thu, 25 Jun 2026 22:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE5666B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:06:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43A998D2CE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:06:52 +0000 (UTC)
X-FDA: 84920425464.27.0B5C007
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 403E618000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:06:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHh2+uFm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782439610;
	b=3D7JRyi7NDd49BMukilCYoo4vdYY9JPhsBtQUU9I3K0UMl3cnRdDtLajbqrCB/Ucra3iCW
	LaiQogpVQZolcEb1R9Hy55apxCol08lLakbZsTM0J/DP1KVGj8nl6vayCnj9+cN/6dVApj
	TdV3T5ckzwoWAOeLOoXr05eb2wn0rQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782439610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rsHOkASwl1S1CEEEKqfD3rOkMhH97Cd0VnIdzLWWzu8=;
	b=nH7BUXR5Lv8k40qOfu517x98eBvyV9ql3S0MpJBl5ebHcnu8I8a48Sg+WHWYMTHnDFeGtQ
	0YE8gV6L2uVOHt3lXtoaSDEgB5b/rNPqwQJkilQxXWd+K4qbC3racdQS6Q1CKCkY1J4kBt
	R/zajphnABw2C/GiQEm+51dcdHMMSzk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHh2+uFm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782439607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rsHOkASwl1S1CEEEKqfD3rOkMhH97Cd0VnIdzLWWzu8=;
	b=XHh2+uFmSCkYZmfLI2yVM7U3iFbIb+dj3Dj0FIt0iDa+cjdWMG3XDeKEddrbkktV5ZwpBN
	1AJNCcIBaIveETtQkeZSyrIVbZK2yF+Jl5M1hIMPk+lQhWUtl997X/VD54Lu19fcmv9jpk
	d1GDHr1+x0ctcsmX0AeUvlbJbU/OiTo=
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
Subject: [PATCH v6] mm: assert exclusive nid/zonenum bits at the page/folio access sites
Date: Fri, 26 Jun 2026 10:06:29 +0800
Message-ID: <20260626020629.1042041-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 403E618000A
X-Rspam-User: 
X-Stat-Signature: wnh8517yzy4cnn3izfns5rcot3y6td76
X-HE-Tag: 1782439610-674430
X-HE-Meta: U2FsdGVkX1++DpLEY+2bLqqFy5jcwfB+vVjM4G5oxeF1vOZTrI6iQCwxbcRi7lNBhhO1K8GJybSY/dk8y07B3HISY6nWkx4+8tyegMTZ8a7F7MKgCkVRFByVnZYFaVGSBkV5QMk59Fmrc1aNVZGaI3xq2L8Uv4FRZM1++Z0wq/rhREi3tWz0xjN93r+FaOw+n743UJG/x3niPVygc6onCym4TbD4MRn8kgn1Z9YbpxeAl+0PEP+X83h28jqgAtNH2NqDHI+ZUgMuf7/FSVh3oPs84XdtQMeuenEUaeiZQ/14rSgFwfy2Xbhm8717OkNzHJZao/3xBcP76Q8MEd5WlorvJb7sKRZPF2WeW2sLL+llrRdziqaSyathxu3NPDrWMa6mXdIxgmP/yG+L4MTJIkx/OM5zD2jG/aJp6yZZ9nLtGtdtMXdvUquHH1eF2mDUQ94UAiBvLHhVw/o4NfRY8CPTr7nfRkWFT+F2VZD8xlBUF5H8ctJSGrOO70mZfZni5n1nJcCi1rilTMlQMvLpQkkQ8YHr5k3B8Q08P5iXaK8kX1or9BHvi7pRUJ38jqs/GS4W6PxP+ytl+feHs/odhnkFB5ivtxjeG+ryELY7t/w0Odvju4WCeLz64kMJu3j67f1aBcmvDa0eS25vi25977tuEX33GZ6J2h/E3Z8YXma0+Xw41PjwBZjECOzo9qKDX8pjFe6sVBEMHmnVd0j1tJz6WLQ7hMblDSu0mYLtgUGHNdXXhTLUkFU3w+cue39Hx2GcSBE3MGWea7hOwiIAJYAvlBYVpYLxrwJNb+ZauvFJH4YkmeV//V0Z6gdkeQqgNodocMXqv6ZPT9JjKtw0NMNTT1iiPNkMnKy0pk1FigMySBAmfXaPe8rw//z0s34hCfyWI40r8SGucA3XJ1mgc/RA0VObvyLl/LWu+Ryo/iA9t/FNSEr7+TVvuV2M+nEWPoZh5WKrML+f+/qhf+Y
 lZCnhN2R
 GK/icdS3hAomalO1RO+hEl/Io+tk2H+Pygjnq6UYVNG9qt+NaZwsSsbCjD1b2XVKPgLyBGyzS/sJnBCZDMz0yHN09gy4R6v9Z/dPNL6B0EWh/En1G9NXQHWhHTMTjE+8EWlNBxpkLl3tjM2aVjf/Kyd8SvezAR2tBLigplpp8E5fGV3b8Ekmd4zPLeE6w7VKsCNJaJO/GUDtnPwM=
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

 include/linux/mm.h     | 21 +++++++++++++++++----
 include/linux/mmzone.h |  7 ++++++-
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..6cce6dc621a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2288,12 +2288,14 @@ static inline int page_zone_id(struct page *page)
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 int memdesc_nid(memdesc_flags_t mdf);
 #else
-static inline int memdesc_nid(memdesc_flags_t mdf)
-{
-	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
-}
+#define memdesc_nid(mdf)						\
+({									\
+	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);	\
+	(int)((mdf.f >> NODES_PGSHIFT) & NODES_MASK);			\
+})
 #endif
 
+#ifdef CONFIG_NUMA
 static inline int page_to_nid(const struct page *page)
 {
 	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
@@ -2303,6 +2305,17 @@ static inline int folio_nid(const struct folio *folio)
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


