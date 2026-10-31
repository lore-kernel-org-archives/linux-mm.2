Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C1E606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=USXIeLot
Received: by kanga.kvack.org (Postfix)
	id EBA376B05B4; Sat, 31 Oct 2026 06:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E9C6B05B5; Sat, 31 Oct 2026 06:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4B36B05B6; Sat, 31 Oct 2026 06:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD4806B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2315BC097C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:39 +0000 (UTC)
X-FDA: 85382565198.18.4BD83E1
Received: from outbound.st.icloud.com (st-2005f-snip4-8.eps.apple.com [57.103.79.101])
	by imf08.hostedemail.com (Postfix) with ESMTP id 25EB6160007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=USXIeLot;
	spf=pass (imf08.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.101 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442937;
	b=ftV5xQlw0py3RtgaQWM3MASyD+emn3BuEIUutuKTwTESmU73d3gVSiyo/HS68RjZl0u9EP
	ev1wEBMLAM/bCy6nkzByoz0AidJKLhhtJMj7yATEaU2s/f34NIIr6sy+LDVCrK74Orl3bT
	tfzIFPnmq8aVAuNgxRFXkwUk5UxPLoc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=USXIeLot;
	spf=pass (imf08.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.101 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ockA7pWwrd8ty7m04Gh0mCQqXQOtB7h/gZ9m0oTr92I=;
	b=R9HiS3G8YHp8X5GRKTeGD4DCdSV6EVdE7MGFd5n1jfqcJKRy7EdTfXCq3KXsfNFRXB7C8V
	atWSO58mVWVEoBE+7dtc8fwGjKg31cexkq1nzpenJMk3lpdiUFA8eeTIVKgmDwpNeaKqgW
	v+QHLJxgdHQGTw30I02RsDstc1FYGJc=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id 06DFB1800161;
	Sat, 31 Oct 2026 10:35:31 +0000 (UTC)
X-ICL-RepId: 01a19187-64b1-7b63-910c-6ff2da70c644
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UBQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442936; x=1824978936; bh=ockA7pWwrd8ty7m04Gh0mCQqXQOtB7h/gZ9m0oTr92I=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=USXIeLotntMkGLwpgCfpHhtuXWLKgt1P9u6d+LkXVr5icwk7xs4fOlb5UqIt2dEKdnkacGdiSA4q4VkXX086KTLB8UawyiTLj1Xuqkyffcvmp2jYP84d4RgSj+GUFpp/Zf49aSRSEgUeiEZERS2SsEmuuT8CqmE63hOJsk/AISoRai0F8WlyMUOKFo+GbSgpUCbdoli9lyI8eCex/SnFSjIaq2AfavJxqzDqbW2cuwAclteXtQiLwV47HFnCcDv0ucKTlr8bZEZXHCy8oQJTo7TH1L5JxhfwlO/77iReMP7vULFUAVpjSn7i1ISVa6Zl95s1q0GcKSYyObvTOMPLBQ==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 3A7ED180016E;
	Sat, 31 Oct 2026 10:35:24 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sat, 31 Oct 2026 18:35:09 +0800
Subject: [PATCH v6 2/5] mm/vmscan: extract folio reclaim freeing from
 shrink_folio_list()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-batch-tlb-flush-v6-2-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfXzO6S4kXRYFvV
 txFbYVLwCGTaduPmWv3Kf8/r4V2WWEzdDk8f1z68e1XWSApfBw1yWMNngBVe/81M0F9mEph31bS
 5O4q9JTFfWntF+pCqAdpyhckPqNOUKOKLkElP7GrvRN+tlpJTReIeBb3V/3sILmvyccdeJcgkbD
 l3jiAB4noUrLZU1T5K44WhW+rVF0XHmvXDveWaQBKq1ga1j+8YF/aQJOKHqfhdSA+KLWU/bv1Oi
 ACdw1m+AqhAI/W7P0LuDwE0kbwxx31yeqDDqKegpVYmhcZnisjqn+X0DSnzvxWW8219c+NUT3iX
 81xJeGgxefw6+YvudKUAi72t+dZB+8c0Q7FenBKPXuGXi9QxkH1a+oIuj1jP/0=
X-Authority-Info-Out: v=2.4 cv=f9VFxeyM c=1 sm=1 tr=0 ts=6ae5c476
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=EPQIOOZaMlKGRMgr7b0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YG_Z6xdjLfhVGAbttUcYUq24AIlbLRIy
X-Proofpoint-ORIG-GUID: YG_Z6xdjLfhVGAbttUcYUq24AIlbLRIy
X-JNJ: AAAAAAABCJD/1JsXszSrshDSTh8sXN7ENl6pUx04kK1KxG7Ola8M8SE+cSkNUpZmCQrrvw
 6kINmZUIXqaBNzxfOPknU4aNXHyax1qmiRnHs/BkV/EI2UtSSV0OLZiSLnPsuSwOZVfMjy
 uAsoNtW+WpFBYq0+ZwN42syxRFKlvAV3bTVD4wVMmX5zhL6U2kkkd6npnytEzm58USPXvY
 yHchq6sCnGHva2xd8uwuPaZ1QCrJOR3YJiXz52rt2yLzHoIuPTFgpMm1OeGFH4sZYYSiAX
 hQqv70aitF3tTKHr8sbSBzgDDK2SXIG14ZjXUdqorQkoQ4JTMTM4Hho0+Hr4MBv6Fk14x6
 rd3cxWrrkd5lqzDMvVunnFT5bqaeg5mL+bqJFa57Sr8OlW3N6SjCnzrIv1a9WDYHC3OGQl
 maiA0g1K7V+nxwKYzeZKa2MOCqUzf7M1zb/hLItvdvVleWsGHlSwy0GDUBpgAFs14hqE5x
 fQWAAV6sbPoB4TaXW8DqawdhWvPf6HpvOomDAyWVWCTXZdEG0vQdjqXsCHtktFXNDPJHlc
 Uarm+asagw7yS40rTzRbcWY+7LXbV5kwE3wuK6Ax5oIzYFM0uHhVd5JPcvcoKnIWFxK0q7
 7LDiv/C1rYTAWEaQp0aCq394AXxlz+X/czbFH4tKqYYEvgdGdXJozXCPUuZ4TcPXL+CQIT
 UoFBPOAjxrTtf/5FEkIb6sq+A6uIUvwtoblNYEWITuLO38r/LutEKzcXIdE/cYHyi4ZIF+
 tICDIUam1OZ/HJssgo4WKOP/q2LzRKkl7MoSUjUgFzbwG4safY0y3yzOhgpsdjW5OmP19f
 zoYNcZBAqlKHcr5GJiSv/OStVaWNETEwTVowfDbDoRtLa0oDUYxE2Ti0yRR32iY9b0af1u
 o8zunmMKzs1XIIMukHPRyvx+KsRHRh5uGJLxm0H6BKtTe3
X-Rspam-User: 
X-Rspamd-Queue-Id: 25EB6160007
X-Stat-Signature: 8okrb5x87bp7i5spqg8az3xocokcr754
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793442937-66835
X-HE-Meta: U2FsdGVkX1//Xtcon84MdcGaaDgSLThJ639RxjMtJJdgyL1vyjv4oT7q00QUzAm60pyf4dUZhyUVs8TOTD4o29vuDqDiYtc5tVn4KzrpJORjJb5CqyGdQSr9x/Y83d/t6y+WOGjikAi/9gCecf8xEmyxvqtLOwZ9UI0RcV7XNa0QksvRhz+WMIL3iV1hy7oLZHOAqRMAOcYotGuDnGpQmA+d0t0nUYCsSI9Ifh9l+fiYm+/fwyPgyQI7kHCyQcaqz/mumRbQpFnVFlCl07cSsCNDqO3d9FLDau9TXy6BEb5DfOr8jV7nsCO/8qcflUyZ1EytDC6kZe5BiVefsNQqkPoexmTEFbREdUfpHQPa8R88A2vKjdej7HpXsHaelj/UpEpQn06hoO8y26/b3qUQU3QCm79gcoI4ttf/J9KPbYXc5ZRGWK44TILDr4XvQGQy9eX8Mv7QgC2ZD8t7mjSqGURqN9BxDD5fhmQxTDVQgTHxEK/o7tPd0yQUCMv3nGLUBdoSE3VfkObjr9kpXXLURvioC9iMK5CbBEYlTgzwS6Eatwc6NtulbbjLcEYwHMS+X3Q/kWgjezsgsenHed6Z4BKXPZGD3zjDJtbHzli5GCJ7rFuUzuanfPjpe1UbxsJtdo5nIeT/3Cu6mfRQ49Or9DEpA/FwylSikVabf72St9tYFTPzVdBCZium2+8R3xCFpkXVMhRiHHaC/qA5Va9bmM7pUz5q9jWf8+cmpEWB45nZvXLVrS6qmIIhZ/57Xo1aLLTRkj8two89VzC2Zy8UVq4nbSQGH6tzHQsSEgvPFztdvn+4VRClDUaDr8Vq5Ke9v6WcqIUFDOU0Q1tC3fQodk9FdP179hMQody219w24D/dVWzB42yPuCvH9Gc38tA34MlP6eTG+5cpXxldkRltR5W4SgmWGZ03Ji4erebgxxtlQo5+6Qf1mBmPmQfqz3FL27GJyDSBWoxBIDh0dzh
 G8yG1Nqj
 8NxniuO8nkX1hIkrP5Yg0URbgzPOgPJTDs5pVbOeZzIlFvg1bolZbp+OQyRSnLl4Xy0aAS3XbpwLnMnfhq8wd65NNEU3+HCLM6pZudkfcdipn4Fk6qrxH7YHJOw2kVy+uZhPhsU07BWqpPdKE7JXEDuV0BnTzuxrgJhjGPzJDGS4XjtQVKXInqbkQ7xNa1iN4iQAfSLjoIdFcomfrPJAKLNxqFKYvUx2nDok0TdIx/BUsgmFzUWain0MG4Uq/AyixuzxNm1L1hzFYmnWCpXou5okWvuKxHTKa63GfxV0paw7p50ic3GMD2r9NUq5F/yFQ3U/dgyxVSqGujkWv5IePTPLGktrhVJP8MNqLIADmr/hTNtTTpP9hLR221cBVhWx9wck/0GMBKCUw4FVCB1ms0eRe/sHRi7Pd8qW1cgJG/phm0QiKi2NTxyY7dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained folio-freeing section:
buffer release, lazyfree, __remove_mapping(), and folio_batch draining.
Extract it into folio_try_reclaim_free() to reduce the size of
shrink_folio_list() and make the freeing step independently readable.

Return an explicit result so the caller retains the distinction between
activating a folio, keeping it on the inactive list, and reclaiming it.
The helper leaves the folio locked when it returns ACTIVATE or KEEP and
consumes it when it returns DONE.

Group retained folios, deferred frees and the reclaimed count in a
reclaim_folio_state shared by the reclaim paths. Initialize it once
per shrink_folio_list() invocation, including demotion retries.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 201 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 116 insertions(+), 85 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 54f6a9e62715..9ac125f2e317 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1177,6 +1177,106 @@ static void folio_activate_locked(struct folio *folio,
 	}
 }
 
+/* Results accumulated across a shrink_folio_list() invocation. */
+struct reclaim_folio_state {
+	struct list_head ret_folios;
+	struct folio_batch free_folios;
+	unsigned int nr_reclaimed;
+};
+
+enum folio_reclaim_result {
+	FOLIO_RECLAIM_KEEP,
+	FOLIO_RECLAIM_ACTIVATE,
+	FOLIO_RECLAIM_DONE,
+};
+
+/*
+ * Called with the folio locked. KEEP and ACTIVATE leave it locked and
+ * owned by the caller. DONE consumes the caller's reference; the caller
+ * must not access the folio again, even if freeing is deferred.
+ */
+static enum folio_reclaim_result folio_try_reclaim_free(struct folio *folio,
+		struct reclaim_folio_state *state,
+		struct scan_control *sc)
+{
+	const unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer mappings
+	 * associated with this folio. If we succeed we try to free
+	 * the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it is
+	 * possible for a folio to have the dirty flag set, but it
+	 * is actually clean (all its buffers are clean).  This
+	 * happens if the buffers were written out directly, with
+	 * bh_submit(). ext3 will do this, as well as the blockdev
+	 * mapping.  filemap_release_folio() will discover that
+	 * cleanness and will drop the buffers and mark the folio
+	 * clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.  These
+	 * are the folios which were not successfully invalidated in
+	 * truncate_cleanup_folio().  We try to drop those buffers
+	 * here and if that worked, and the folio is no longer
+	 * mapped into process address space (refcount == 1) it can
+	 * be freed.  Otherwise, leave the folio on the LRU so it is
+	 * swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask))
+			return FOLIO_RECLAIM_ACTIVATE;
+
+		if (!mapping && folio_ref_count(folio) == 1) {
+			folio_unlock(folio);
+			if (folio_put_testzero(folio))
+				goto free_it;
+
+			/*
+			 * Rare race with speculative reference. The
+			 * speculative reference will free this folio
+			 * shortly, so we may increment nr_reclaimed here
+			 * and leave it off the LRU.
+			 */
+			state->nr_reclaimed += nr_pages;
+			return FOLIO_RECLAIM_DONE;
+		}
+	}
+
+	if (folio_test_lazyfree(folio)) {
+		/* follow __remove_mapping for reference */
+		if (!folio_ref_freeze(folio, 1))
+			return FOLIO_RECLAIM_KEEP;
+		/*
+		 * The folio has only one reference left, which is
+		 * from the isolation. After the caller puts the
+		 * folio back on the lru and drops the reference, the
+		 * folio will be freed anyway. It doesn't matter
+		 * which lru it goes on. So we don't bother checking
+		 * the dirty flag here.
+		 */
+		count_vm_events(PGLAZYFREED, nr_pages);
+		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
+	} else if (!mapping || !__remove_mapping(mapping, folio, true,
+							sc->target_mem_cgroup))
+		return FOLIO_RECLAIM_KEEP;
+
+	folio_unlock(folio);
+free_it:
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+	state->nr_reclaimed += nr_pages;
+
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(&state->free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(&state->free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(&state->free_folios);
+	}
+	return FOLIO_RECLAIM_DONE;
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1185,15 +1285,15 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct reclaim_stat *stat, bool ignore_references,
 		struct mem_cgroup *memcg)
 {
-	struct folio_batch free_folios;
-	LIST_HEAD(ret_folios);
+	struct reclaim_folio_state state = {};
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0, nr_demoted = 0;
+	unsigned int nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_io_ctx ctx = {};
 
-	folio_batch_init(&free_folios);
+	INIT_LIST_HEAD(&state.ret_folios);
+	folio_batch_init(&state.free_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1564,83 +1664,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		/*
-		 * If the folio has buffers, try to free the buffer
-		 * mappings associated with this folio. If we succeed
-		 * we try to free the folio as well.
-		 *
-		 * We do this even if the folio is dirty.
-		 * filemap_release_folio() does not perform I/O, but it
-		 * is possible for a folio to have the dirty flag set,
-		 * but it is actually clean (all its buffers are clean).
-		 * This happens if the buffers were written out directly,
-		 * with bh_submit(). ext3 will do this, as well as
-		 * the blockdev mapping.  filemap_release_folio() will
-		 * discover that cleanness and will drop the buffers
-		 * and mark the folio clean - it can be freed.
-		 *
-		 * Rarely, folios can have buffers and no ->mapping.
-		 * These are the folios which were not successfully
-		 * invalidated in truncate_cleanup_folio().  We try to
-		 * drop those buffers here and if that worked, and the
-		 * folio is no longer mapped into process address space
-		 * (refcount == 1) it can be freed.  Otherwise, leave
-		 * the folio on the LRU so it is swappable.
-		 */
-		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
-				goto activate_locked;
-			if (!mapping && folio_ref_count(folio) == 1) {
-				folio_unlock(folio);
-				if (folio_put_testzero(folio))
-					goto free_it;
-				else {
-					/*
-					 * rare race with speculative reference.
-					 * the speculative reference will free
-					 * this folio shortly, so we may
-					 * increment nr_reclaimed here (and
-					 * leave it off the LRU).
-					 */
-					nr_reclaimed += nr_pages;
-					continue;
-				}
-			}
-		}
-
-		if (folio_test_lazyfree(folio)) {
-			/* follow __remove_mapping for reference */
-			if (!folio_ref_freeze(folio, 1))
-				goto keep_locked;
-			/*
-			 * The folio has only one reference left, which is
-			 * from the isolation. After the caller puts the
-			 * folio back on the lru and drops the reference, the
-			 * folio will be freed anyway. It doesn't matter
-			 * which lru it goes on. So we don't bother checking
-			 * the dirty flag here.
-			 */
-			count_vm_events(PGLAZYFREED, nr_pages);
-			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
-		} else if (!mapping || !__remove_mapping(mapping, folio, true,
-							 sc->target_mem_cgroup))
+		switch (folio_try_reclaim_free(folio, &state, sc)) {
+		case FOLIO_RECLAIM_ACTIVATE:
+			goto activate_locked;
+		case FOLIO_RECLAIM_KEEP:
 			goto keep_locked;
-
-		folio_unlock(folio);
-free_it:
-		/*
-		 * Folio may get swapped out as a whole, need to account
-		 * all pages in it.
-		 */
-		nr_reclaimed += nr_pages;
-
-		folio_unqueue_deferred_split(folio);
-		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
-			try_to_unmap_flush();
-			free_unref_folios(&free_folios);
+		case FOLIO_RECLAIM_DONE:
+			continue;
 		}
-		continue;
 
 activate_locked_split:
 		/*
@@ -1654,7 +1685,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 keep_locked:
 		folio_unlock(folio);
 keep:
-		list_add(&folio->lru, &ret_folios);
+		list_add(&folio->lru, &state.ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
 	}
@@ -1662,7 +1693,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
-	nr_reclaimed += nr_demoted;
+	state.nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
@@ -1693,15 +1724,15 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
 
-	mem_cgroup_uncharge_folios(&free_folios);
+	mem_cgroup_uncharge_folios(&state.free_folios);
 	try_to_unmap_flush();
-	free_unref_folios(&free_folios);
+	free_unref_folios(&state.free_folios);
 
-	list_splice(&ret_folios, folio_list);
+	list_splice(&state.ret_folios, folio_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 
 	swap_write_submit(&ctx);
-	return nr_reclaimed;
+	return state.nr_reclaimed;
 }
 
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,

-- 
2.56.0


