Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16151C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AFE6B0821; Mon, 17 Aug 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022C56B0822; Mon, 17 Aug 2026 10:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EF66B0824; Mon, 17 Aug 2026 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE2086B0821
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:47:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43883C079C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:47:41 +0000 (UTC)
X-FDA: 85111040322.03.7C02A58
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf11.hostedemail.com (Postfix) with ESMTP id 46CCC40003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:47:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786978059;
	b=sa6kwAZN/GEsn2E4dQEYtrzT971SBADCl0rHBz6zRhI9N/UhBOY3awf8Q714PoaBIyQyTG
	fiKzqWgY7FT8ZwaXo5bZyTipHVO79eYo7vulkVOy+QOPoIhrxW6YrsaV3UxE6kbBFrZ7M8
	+DLtMAdA6PQanzVVbRhnYkrz1LddFKs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786978059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvEBRbH6jQos0xLUscD6wJtCYUlllr72FEKOShiX0jQ=;
	b=cN9Pc6KQ/QBy9FCueBl19Y0fhq21T3vyo02ytFZtz0ySo756IC8QIURyWQWSvE2hSIU1YE
	ejwbFqaj/n4i9pu6EdkqF38CiGZkTMOZcWg3Kq6Tqcc2LLPkwpY+bKftE1CyuOzVRrpGMs
	NWFdrUkl/K9mFd4Igv2U+RFiNyzQ5k8=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6ED123ECF9;
	Mon, 17 Aug 2026 14:47:31 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v1 1/2] mm/swap: refault on swap-in, not in the swap cache allocator
Date: Mon, 17 Aug 2026 16:46:12 +0200
Message-ID: <20260817144622.137133-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817144622.137133-1-alex@ghiti.fr>
References: <20260817144622.137133-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGKlGYOr7RljmYIahLVOlN7/DGWYHn1tFLmT0GMge8GBo3gW4hMYG92IsUBqVx9gR1onNB2TGZ1oWgnsqOxdw5QaqkhSwAALNrpzZCkR9tu3Dpy6QzodbVxkM+Dgq+ZVHea+AxfIGMKYDr0Qg/2j2Os5zR4NMKHXhP6ARVehINVcGDnJt09yRXOSbH5Zyl48EP99n/gWW02gFBJX7NjXAKtCj/xbKsbHtLqxJmUfdLMWv17BafXu3sR9y5JUbXkuhh1m996h7BPNRd2FrTBOFr6cyEBWKzMMdFx0xNPT24eK9aGtNjfer3cXv5oXCJkSgCoRPT7ZFdTwF/HYILHhrpXsFgSxU8qQJzKt06bY2j50JaYHzO1k7jH0/EDSoE6W0gskKoBB1kmRdVjXTaP6l+G6rK1EvIMnG4gZhobNjnwKYTqrajmX+j+seT5ysiCCPVFDWSerVnFy9PChM/XzltFkcYQOEiPDx//ONtf4Fpydjhda7J7zSG6wbFleVCpavt/9Bg54mgBVnPr5GYkajIEzr4eOW3o/OArcBeP1PmLs5f4Ks17U6ppKAiCn/5TXet5WmhZZ09NT4L320W7U8z1ROG3toffNU959eoLoVrosMjF5d2Rm7S6UCN2eqeM+wz2GblE+46ah0kI7BTdPAFEOcmyPc1oIuE3Rvh7lxalfw
X-Rspamd-Queue-Id: 46CCC40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: x5js8hmenyxkodt3xtubo5yqqbzofma4
X-HE-Tag: 1786978059-591515
X-HE-Meta: U2FsdGVkX1+VrqlxYGfNnFdM4ftZT1Y//D49Ciy8L+RFi8r/RyS04YG0apzvRLZwpE96xD+FecNI6SxlFoayuyrPybGjDYel4RQgCMctuRfVjNdFpEfY5vZagcA1SgHiFRl53MeW2iUa/sCDf5sO3qFZ8fOsNC/e79WbGAEL9ZswOnrLvGUnxxQjX3WxqWEFGo2UstODsLqvU9aFeKtV8TtURt8llGnoe1V6ApPQ57/fAiodmqMotg86z8VWHpbXBznqsxQ247H350nJXRWESAWVYeUEBs9gEifXKsIA7R+RssFKV+UfJS/dUH9lLEr5INFcc9RBguDghPeZ3+gyM1u474UMN3u1RaAIw5CoAP6Rf+7PLyW0edSnl3GaUSRQxJSCyCDp97T/fBqhIkhA6pksrGQwgPLxNNPX2q4xIPqueCiinHhsy+HlzBNQvLi14pKhj3o+RC0knRgfj4roiaa8MWmNLDMkArCR+bq4FrJxMeRZJAalitPw4PrXi8Aiqu0cDyRtJFze9erkQx1gld/59A1J5agXq/dUE5cgnSziCX56PdNR7dBRPDv4rJDWhnjD/GDdKTBnuOoZN5WF8TRPCce9gmci/VBuFwcdlfdOtXVQv87dNSZTYe6HxPjGj6J21fKco6h0xqoSKz09Snbc4M++vsbWAtkTu2zPaWJe7ika1SWvEmYPnY+bCKttj4jHPp5E7655pS18ap7AcRyCokKi1SDAO+W2e1nf7MTIsPim8imJSnxbfwmdZGfMw7m2Pbkbvo9O7NFKLVtEig0hUPPU4V8LRReM5y7ci9LjvC4KrWok+EPNvRZ/dwlDcQnuaYz3J0eMB1PRGhhNUkZUKhNiw9sb3ZYjU+sSbi7FSUHYFDLMVvl0mZb9tdRztPBrPhIpJGeH0k/7mOltaMHOI+usxVNs/7ECuvwis93rBv5HmVJFFydf3TwpOLF5dcN6pTKqJZlMcvEdwEq
 BWRflNZR
 Rd1fdqqdjSx4zAs/NSNUd+bxHQDNxiiCHy5v3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__swap_cache_alloc() calls workingset_refault() on every folio it
allocates into the swap cache. That is correct for a swap-in, but wrong
for a zswap writeback buffer, which is allocated through the same path
(swap_cache_alloc_folio()): the buffer is not a refault of anything, yet
it gets counted as one, inflating anon refault/activation.

Refaulting is a swap-in event, not an allocation event: move it out of
__swap_cache_alloc() into the swap-in callers.

The allocator has already put the folio on the LRU by the time the callers
refault, so workingset_refault() now has to activate an already-LRU folio:
folio_set_active() only sets the flag before LRU insertion and would be a
no-op here, so use folio_activate() when the folio is already on the LRU.
Existing callers pass not-yet-LRU folios and are unaffected.

Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 20 ++++++++++++++++++--
 mm/workingset.c |  5 ++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..0bb26d2ba2ba 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -477,8 +477,6 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* memsw uncharges swap when folio is added to swap cache */
 	memcg1_swapin(folio);
-	if (shadow)
-		workingset_refault(folio, shadow);
 
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
@@ -638,17 +636,26 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct swap_iocb **plug, bool readahead)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -678,17 +685,26 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	swap_read_folio(folio, NULL);
 	return folio;
 }
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..7c30cf091cbf 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -577,7 +577,10 @@ void workingset_refault(struct folio *folio, void *shadow)
 	if (!workingset_test_recent(shadow, file, &workingset, true))
 		goto out;
 
-	folio_set_active(folio);
+	if (unlikely(folio_test_lru(folio)))
+		folio_activate(folio);
+	else
+		folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
 	mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file, nr);
 
-- 
2.53.0-Meta


