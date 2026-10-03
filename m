Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0978CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA886B00A4; Fri,  2 Oct 2026 21:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AE46B00A5; Fri,  2 Oct 2026 21:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79786B00A6; Fri,  2 Oct 2026 21:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909B06B00A4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FA9F4089B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:13 +0000 (UTC)
X-FDA: 85279508706.12.4AC1757
Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35D071A0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=17kKT0bMr3KFMChqsfdAt885376fPpNxTHUYU4ojskI=;
	b=3ZBhbbTziP4SlfycjZn5e6nhmkCeVOVjfwRjiTYrfNhhwNUtbZZN/BzbBjlNcrygr5b2YN
	i/tpipE7mK8aShzCgwewN2GSVhvJoVBQjegIA+m/lscIizj+b70wDlGyBDHbhbHXOOYfYV
	/O/L0VjuJG+OAcss/RxG1UR/WxI1w7o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989211;
	b=5pesWpL7xGnNTuxmLclC9NkXQuy5WbH01430/sVItrDJChUeHMUgAjyPN9FVQAU7h/Gfjg
	ZbjWLnXtk93F3sKoYcpNk2jMvcSCdtoojS559TXr8ZdPNZUK0L/KovkrvJLyHoB1OZWqK6
	Z3839GEl9383xGV4CO2fAsf3P3DgZSg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2a189c04d7a24183;
	Sat, 03 Oct 2026 01:00:09 +0000
X-Mizu-Trace-ID: 2a189c04d7a24183
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 08/12] mm, swap: reclaim physical slots backing cache-only xswap entries
Date: Sat,  3 Oct 2026 08:58:56 +0800
Message-ID: <20261003005900.909710-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4kdouo7hcug38p7kjcsjb4kip1yfhiuh
X-Rspamd-Queue-Id: 35D071A0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790989210-786215
X-HE-Meta: U2FsdGVkX1830HUgheKxz8udTt34XwqLeelJ1LHcwtXIBtPyYGqcPp9D+X/xDV2FCB07MEQb8vwe7dnUDXjGxufzbh6OiTyFjrwFnjg91iVBUBWF6rEOT7EX3XQo1KhblUwuw8/UTND1g5yx8lMbtv4FbUF6H8edaYatPw95P4gVJSCrBdu5MyRwDS4Yd5gQGkbvjKwQx2Y/wMWO801ymImd9fMOu6hZXtTJdRsGfyweTTFtCKUZ6PGl3ewod47ad1C5OILq19Yj00gsR+un4OpYc3773SYHnZ8+W91xnDpEcgfuJrCapWqbu6ZyNNoUTNv0/CNGICWF5xtNO0aZ7ZGe5pI7ZnWSiLXTPYRyXzs9p4ipo7xO/XSvnyVlqNiNzud1r2z6NUsisHkOkTVAksC5D9gnKKHxauwl0yGMfynbqLPRUfdxwHLPu8E1CpwNsrNChXZH2IZV7RA8DtOTLXR8uCVdr5Co1nRKbLMlvmxlxbdjGfGYxrxPCc7vzSVnsfq499zxw87K3LUO2AOFk2UXrHd8V6cOvZgC5lTJGkyV/o+kd7e3oc+Tj0r73U1By+WXDydWTn0deOpFBs190KrGiGoleQ5N10nXCImWvanwhNZ4W+0BwOn2q3kQMTgvxHt7WIENydX9X2T7+dgLVVxOkgdazvzD0iX4rqageRC6U/jpcYEISMTWvW/FzzIP3A/t2Kol5kR0ylAG9YbcHKfPWlRJkhS8WV83wH/JmlWpg3J6peeTjInTUI9ohHGLA576vTAccpCWFozXMnDTCzZcalIvbIbVY6bMODDBC+OYZ6MW8J5mhA5IaZ+i5f8yunDGkrui/yD9T2NX+ozEDrdDnpYfMlpW5s4jNpUDfiq5ZvspGsjz6Lmp2vzptG75/PH7rwso/W/bYK4fyqv206y3Xdek3xmOLkRh0OUzlNCnj2WwPWZqvXd7AGXeVbTq5AE9V3mQ1FY/TIt6tcK
 6HYEQnrv
 ocYQP13sTU/e5ktMTm7GUE0TjzPdhSy6+Qk/1QlQFEcMJ8ypTkZ6YCk1WFn1WQ0gSQioXTbuNILk7teCUCdkekDDH7BXdVqx47RPNaaBYuK4SJboa4XXe3fLtL3SFpIqyOPIvT05Wy1YClGUiDOG2Tq+TLBhTUi2y9IozPQNK1Jsk06iOhlI7YLrDOHRUsk3Fx8OO1TIznbNoM2WnjF6NPi+3CfHvLjLuy2yXk3tSIf2cZG+mmrnZi2zmBrpeFgWhDdiUkQBxtB6RYg5/fXjMgtOAoNkJsLi+tsDh0geYaNuOqTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap count of an xswap entry can drop to 0 while its folio is still
in the swap cache, which leaves the physical slot redundant but occupied
until the folio leaves the cache. This happens when the page is faulted
back in during its write to the backend: do_swap_page() does not wait for
writeback, folio_free_swap() refuses a folio under writeback, and a
real-device write does not drop the cache when it completes.

Mark the slot with a cache-only bit in the swap table entry that points
back to the owner, set when the count drops to 0 and cleared when the
slot is reused. The physical reclaim scanner already walks full clusters;
make it free the slots with the bit set. It reads the bit directly,
without the xswap cluster lock, which would invert the lock order.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swap_table.h |  37 +++++++++++++--
 mm/swapfile.c   | 122 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 156 insertions(+), 3 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 22322519c3fe..40bab9890670 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -86,21 +86,52 @@ struct swap_memcg_table {
  * Pointer-tagged swap table entry: the reverse map from a physical slot to
  * the xswap entry it backs. Layout:
  *
- *   Pointer:  | xswap_type(8) | xswap_offset(53) |100|
+ *   Pointer:  |C| xswap_type(7) | xswap_offset(53) |100|
  *
  * The low three bits identify the entry: 0b000 is a free or bad slot, a
  * shadow entry ends in 0b01 and a cached folio in 0b10, which leaves
- * 0b100 as the only marker still free.
+ * 0b100 as the only marker still free. C is SWP_RMAP_CACHE_ONLY, the one
+ * bit left at the top.
  */
 #define SWP_TB_PTR_MARK			0b100UL
 #define SWP_TB_PTR_OFF_BITS		53
-#define SWP_TB_PTR_TYPE_BITS		8
+#define SWP_TB_PTR_TYPE_BITS		7
 #define SWP_TB_PTR_OFF_SHIFT		3
 #define SWP_TB_PTR_TYPE_SHIFT		(SWP_TB_PTR_OFF_SHIFT + \
 					 SWP_TB_PTR_OFF_BITS)
 #define SWP_TB_PTR_OFF_MASK		((1UL << SWP_TB_PTR_OFF_BITS) - 1)
 #define SWP_TB_PTR_TYPE_MASK		((1UL << SWP_TB_PTR_TYPE_BITS) - 1)
 
+/*
+ * Set when the xswap entry owning a physical slot has swap count 0 but its
+ * folio is still in the swap cache. The slot is redundant then, and the
+ * physical reclaim scanner may free it. The bit sits on the physical slot
+ * so that scanner can read it without the xswap cluster lock.
+ */
+#define SWP_RMAP_CACHE_ONLY		(1UL << (BITS_PER_LONG - 1))
+
+/* swp_type() must fit, and SWP_RMAP_CACHE_ONLY must own the top bit. */
+static_assert(BITS_PER_LONG - SWP_TYPE_SHIFT <= SWP_TB_PTR_TYPE_BITS,
+	      "xswap rmap type field is too narrow");
+static_assert(SWP_TB_PTR_TYPE_SHIFT + SWP_TB_PTR_TYPE_BITS == BITS_PER_LONG - 1,
+	      "xswap rmap fields do not pack");
+
+static inline void swap_rmap_mark_cache_only(struct swap_cluster_info *ci,
+					     unsigned int off)
+{
+	atomic_long_t *table = rcu_dereference_check(ci->table, true);
+
+	atomic_long_or(SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
+					      unsigned int off)
+{
+	atomic_long_t *table = rcu_dereference_check(ci->table, true);
+
+	atomic_long_and(~SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
 	return (swp_tb & (BIT(3) - 1)) == SWP_TB_PTR_MARK;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 45a871eb7bc2..5b33b2c78ee4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -109,6 +109,12 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 				       unsigned int slot);
 static void xswap_free_xs_table(struct swap_info_struct *si,
 				struct swap_cluster_info *ci);
+static void xswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int slot);
+static void xswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int start, unsigned int nr);
+static int xswap_reclaim_backing(struct swap_info_struct *si,
+				 unsigned long offset, swp_entry_t xentry);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -1325,6 +1331,18 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+#ifdef CONFIG_XSWAP
+			} else if (swp_tb_is_pointer(swp_tb) &&
+				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
+				spin_unlock(&ci->lock);
+				nr_reclaim = xswap_reclaim_backing(si, offset,
+						xswap_rmap_to_entry(swp_tb));
+				spin_lock(&ci->lock);
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
+					continue;
+				}
+#endif
 			}
 			offset++;
 		}
@@ -1935,6 +1953,10 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+#ifdef CONFIG_XSWAP
+			if (ci->xs_table)
+				xswap_mark_cache_only(ci, ci_off);
+#endif
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -2041,6 +2063,10 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+#ifdef CONFIG_XSWAP
+	if (ci->xs_table)
+		xswap_clear_cache_only(ci, ci_start, nr);
+#endif
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -3263,6 +3289,102 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 		xswap_free_phys_slot(psi, entry, phys);
 }
 
+/*
+ * Mark the physical slot backing xswap slot @slot as cache-only. Its folio
+ * is in the swap cache, so the physical copy is redundant. The physical
+ * cluster lock is needed: xswap_free_phys_slot() clears the rmap under it.
+ */
+static void xswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int slot)
+{
+	struct swap_cluster_info *pci;
+	swp_entry_t phys = { .val = ci->xs_table[slot] };
+
+	if (!phys.val)
+		return;			/* still in zswap, no backend */
+	pci = __swap_entry_to_cluster(phys);
+	spin_lock(&pci->lock);
+	swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
+	spin_unlock(&pci->lock);
+}
+
+/*
+ * Clear the cache-only mark of slots that were re-referenced. A slot that
+ * was cache-only had count 0, so count 1 is exactly the one to clear.
+ */
+static void xswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int start, unsigned int nr)
+{
+	unsigned int slot;
+
+	for (slot = start; slot < start + nr; slot++) {
+		struct swap_cluster_info *pci;
+		unsigned long swp_tb;
+		swp_entry_t phys;
+
+		swp_tb = __swap_table_get(ci, slot);
+		if (!swp_tb_is_folio(swp_tb) || swp_tb_get_count(swp_tb) != 1)
+			continue;
+		phys.val = ci->xs_table[slot];
+		if (!phys.val)
+			continue;
+		pci = __swap_entry_to_cluster(phys);
+		spin_lock(&pci->lock);
+		swap_rmap_clear_cache_only(pci, swp_cluster_offset(phys));
+		spin_unlock(&pci->lock);
+	}
+}
+
+/*
+ * Try to reclaim the physical slot backing cache-only @xentry. The physical
+ * cluster lock must not be held. Returns the folio size, negated if the free
+ * failed, or 0 if @offset turned out not to be the folio's slot.
+ */
+static int xswap_reclaim_backing(struct swap_info_struct *si,
+				 unsigned long offset, swp_entry_t xentry)
+{
+	struct swap_info_struct *xsi = __swap_entry_to_info(xentry);
+	struct swap_cluster_info *xci;
+	swp_entry_t first;
+	struct folio *folio;
+	unsigned long xoff, i;
+	int ret = 0;
+
+	folio = swap_cache_get_folio(xentry);
+	if (!folio)
+		return 0;
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return 0;
+	}
+
+	/*
+	 * The folio must own @xentry, and @offset must be the slot this device
+	 * holds for that page of the folio. Otherwise the rmap went stale.
+	 */
+	if (!folio_matches_swap_entry(folio, xentry))
+		goto out;
+	i = xentry.val - folio->swap.val;
+	xoff = swp_offset(folio->swap);
+	xci = swap_cluster_lock(xsi, xoff);
+	if (!xci)
+		goto out;
+	first = xswap_slot_backend(xci, xoff % SWAPFILE_CLUSTER);
+	swap_cluster_unlock(xci);
+	if (!first.val || swp_type(first) != si->type ||
+	    swp_offset(first) + i != offset)
+		goto out;
+
+	/* The run is ours: skip it all, whether or not the free succeeds. */
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -ret;
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * A written-back slot has no folio of its own here, so the unuse loop would
  * skip it. Resolve it through the reverse mapping and free both sides.
-- 
2.54.0


