Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77866C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9348F6B019E; Tue, 18 Aug 2026 09:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE886B019F; Tue, 18 Aug 2026 09:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7861C6B01A0; Tue, 18 Aug 2026 09:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7A96B019E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1EF114011A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:33 +0000 (UTC)
X-FDA: 85114429386.24.66D372A
Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id E75D420008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsZbVkrp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Qu+jbYRVUlFi2BrkShq72jnYg6UaIDp0e6XfDtA/q4=;
	b=MLoTecn9oAZIPUiFkZPEfUZj54hLrWj3hRJok6NXe9oUXiPqFfL6WZT8H4YLUhKeFqgzcW
	uP1Q22ookcKJu338ijC21e3gU/AbfiTbcoDgErFsDUvNKAX1yqxK+Rv9XYvjQ0+IM89RgG
	dYr8BuLhGPH8VZdcA9SPRpv4GD51qEI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsZbVkrp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058752;
	b=E0ofHlKssYmWQbbGTeK9x2d+1fdenmBI5ET4rhSa1hmGNG68ge8GDSJQfnIjdb6yZPEmOb
	p2+DSb5v64kDbM/MFoBXtBfRebLusXVYiVREHN26hdw01nzvTlmqpgF5Aa8fWvXyncC4FH
	iIzjca+lIrlMgXUgxf1mdVGpn5XesNs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FPWpaNmTRU+xlShU64gQ7An1URF32LkC2T1D7RJM8B8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058750; v=1; x=1787663550;
 b=TsZbVkrpP5B64dwF0c8m1t7ZxFYdVrYGp6cyFnUAcJInA4WH7S/LuuiX4mJZXq9prDhyuJAc
 1Z2EaJHFwtgJQ/CY1EKbyWuHPL1cIQaLqTFkMvrsjf8HeIwN4r7W82V7HbJQrWDLjAz44EYktZP
 vH4Q0hmboTY+YA5MsFMgY6eM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:1a::)
	by mta12.migadu.com with ESMTPS id 7c31fdcbe05a5cd5;
	Tue, 18 Aug 2026 13:12:30 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Alexandre Ghiti <alexghiti@fb.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 05/12] mm: zswap: add range lookup for large-folio swapin
Date: Tue, 18 Aug 2026 06:09:46 -0700
Message-ID: <20260818131202.494754-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E75D420008
X-Rspamd-Server: rspam07
X-Stat-Signature: smwn6zgbzzi7wkhz4nymunn8at5gom9e
X-HE-Tag: 1787058751-181580
X-HE-Meta: U2FsdGVkX1+9SzMGvy53ukqy7KjQdZoZGoRC2tuMmG6udlQKFNxG01NjZVOGXrfR0O7+G+IgBF/FvHaOA/j1CGc59mVy9ezSz+0jSQ40d5a0LuFeORS5zI2JNbmifkux+Hw1ZjNZtZAFKZn20S4wPQwYd1SXWsDJ3UJO+c0+LiJB5iIfssN+bAjndkP8J+IzYp8Q+WBwdLqmofNlb0EovChIB93wGnTw5077CoUcGZz6aOVsND55qkr8iULIw5oGycg6Pcuw2sXDTqxFBUCAxzQQgjnKDwe2v/K8adyJdhDIsbJh3694XA13oYKPXMbmmeFSbocVuhxiL+c9CSivoWyGHPVX8zyzTFWjVz1GyqkwSIfGrAuE38VhsH6IyUNyDewOpYMGvvmH40z57EBzCQBaguv8Idy7GBkWCT171ZmfQDG5yBJZo2MPOtWJQznRyV+Bt5U5sw1nYwzguqmrdNgwj+z1EVz2Brxa14U0NG8bhwMHI4SrZEAZ5DssNmfGQDFxh8gOWtBJsjuAg8sOx018LsoSv3DsLR3xC7SoIu/qeWNyhv+Yk1a04R7hJF03rz03rerA39uslayRLa55Flhv9zOnIAUsm5oIj2ZhkI4dCrF46peJ82u0tS+qKdQyvZzhJwW3LnX/c5Ncd15IZbmt+SbDyrG1NSz/6EtYI7wCrsOs4nLampyGYhUKv7qW9MM3fmAnzrhizuxh+VlP5kkVTvUNjMIfpsfdXG9Max/ldI991hW7pZUuOjRNNYnTWTf2lI9lzsdbw6z1+DZsZfZu+WnAk8fQRtoW4PrMVxYOpGm1cUV8vllO3Z9ZrLcHKEYR+KtPNxP9InuveXLwmzZAmZG6OKlmR5YUSHB83OL9J7DHph1y8lsY2LfKXIzl8onEKybFuBhPDcMo3sCsNud0RuhMLLZeHS6ZHptCQIwqwu/MwXn8YhUrEDsymiImV+o/8y+8QHwrPiBdhJv
 tEO0jlOZ
 E7iwUQuwv7VSyblh0yHb3DAsJOx867XG1PT+7b7QiCzw5edr2XQ/Z/zhlZobxG09ZcWCNkaQ/VUXTgPuzvFJS1DSO3Dupx/4pm8t8fcR/bNXvxZ5DLxdZxAaWErtK+hHsg0+uZ9iAu1hv94XX6dCx9n7OX4BcUbHQSf+hdRJSRhRSmPu+Wtx8FlzaHSTkL6ldzYMS30glbdiMevQne8EQ8P/o9E7Q6oMVUwJ4R02S1yccsu91+4/rzeqg56GfQ73UNzjSTOEJO7LiNmZmI6dhsz8wmJgnYpHmRan9G2+r8VqklVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexandre Ghiti <alexghiti@fb.com>

A large folio reaches zswap_load() only when the caller expects
the whole range to be on disk. Zswap still stores large folios as
independent order-0 entries, so reconstructing a large folio from
zswap entries would risk returning partially initialized data.

Teach zswap_load() to scan the covered range. If no slot is in zswap,
return -ENOENT so swap_read_folio() reads the backing device. If any
slot is still in zswap, fail the large-folio read so the caller can
fall back to per-page swapin.

Return -EIO rather than -EINVAL for that conflict. Large-folio loads
are now valid requests; the error means zswap cannot safely satisfy
the request from partial per-page compressed state, not that the
request is unsupported. Existing callers only distinguish -ENOENT,
so this is a semantic clarification rather than a behavioral change.

Add zswap_is_present() so PMD swap-entry consumers can make the same
range decision before attempting PMD-order swapin. Also use it from
__swap_cache_add_check() for multi-page insertions while holding the
swap cluster lock. That check runs before folio allocation and again
immediately before swap-cache insertion, closing the race with zswap
writeback and rejecting mixed zswap/disk backing with -EBUSY.

Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/zswap.h |  6 ++++++
 mm/swap_state.c       | 10 ++++++++++
 mm/zswap.c            | 46 +++++++++++++++++++++++++++++++------------
 3 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e1..cd9efcf9dec94 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b76eb3d876fd7..15e200d6966b9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,6 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
+#include <linux/zswap.h>
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -191,6 +192,15 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	if (nr == 1)
 		return 0;
 
+	/*
+	 * The cluster lock serializes swap-cache insertion with zswap
+	 * writeback. Reject mixed zswap/disk backing before allocating a
+	 * large folio and recheck it before adding the folio to swap cache.
+	 */
+	if (zswap_is_present(swp_entry(swp_type(targ_entry),
+				       round_down(swp_offset(targ_entry), nr)), nr))
+		return -EBUSY;
+
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..32671dc2bf84d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1571,6 +1571,23 @@ bool zswap_store(struct folio *folio)
 	return ret;
 }
 
+/**
+ * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
+ */
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	struct xarray *tree = swap_zswap_tree(entry);
+	unsigned long index = offset;
+
+	if (!nr || zswap_never_enabled())
+		return false;
+
+	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
+}
+
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
@@ -1578,13 +1595,9 @@ bool zswap_store(struct folio *folio)
  * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
  * of the following error codes:
  *
- *  -EIO: if the swapped out content was in zswap, but could not be loaded
- *  into the page due to a decompression failure. The folio is unlocked, but
- *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
- *  will SIGBUS).
- *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
+ *  -EIO: if the swapped out content was in zswap but could not be handed
+ *  back, either because decompression failed or because a slot in a
+ *  large-folio range is unexpectedly still in zswap. The folio is unlocked,
  *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
  *  do_swap_page() will SIGBUS).
  *
@@ -1605,13 +1618,20 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * A large folio reaches zswap_load() only when its whole range is
+	 * expected to be on disk: PMD swap-entry consumers split before
+	 * calling into PMD-order swapin whenever any slot is still in zswap.
+	 * Confirm the range is entirely absent from zswap and return -ENOENT
+	 * so the caller reads it from disk; if a slot is unexpectedly still in
+	 * zswap, fail the read rather than return partially-initialized data.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(zswap_is_present(swp,
+						  folio_nr_pages(folio)))) {
+			folio_unlock(folio);
+			return -EIO;
+		}
+		return -ENOENT;
 	}
 
 	entry = xa_load(tree, offset);
-- 
2.53.0-Meta


