Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9BDC5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93D86B0098; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C456B6B0093; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90FD6B009F; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7858E6B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C6E1A01F7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:52 +0000 (UTC)
X-FDA: 85075735626.01.7F48A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0611A1A0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rgVTuLkT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr+A2RvNRp2g2HCcH1WTVPXAce0IQX0OC1u3Cx668Kg=;
	b=1C7trxSUD6nco5tmIdGhe7dsLpwnxmoyr3qNjJhn4eR8y37XrvCL2mG8s1CIrSqX8auYsH
	qbCcXS2T1OPbuU6VvwxGinigVgXPhRb8HiYOqZeHK/1AgY2dfeywHqsIIzfTUZFzU7UBFP
	oowki+gy+JdBpK9ZCZ623noON74nb4g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rgVTuLkT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=lyI20ePQzbRUrC2GeizZlu72dUvXD0CAdE1e4gAHWjkvD097O0R0NyOUlRMEjAo5wSWNBg
	YUoV/kLavE1tXU6a7BjyoLVRHHHXmavtT96Ypa5PdJIeQt8BmqdtSpsPMCCJ5LBlBT79dO
	CfM4SQ4Mm/K6LyiJBeVyFFQN0ov/5tE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFA5B43EC8;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6B9EC2BCF7;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137469;
	bh=undGCia7Jer3tja6gd6S285qvFmBFMFl3F3plDrS6m4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rgVTuLkTOyhcFcADjCFH+C6byyBBhX5VCA0gmbW3+UZKMVp4qV/u1yH6nVUHPc+g0
	 oiS/I7KgGpcThf/gxy4EGjzSYObbdc+EswN5idanBquF6vIw2Ji2ulquf0wb34oW+H
	 nwuyaBShZ/vw996i6kmPzxRXYy97ZAIkt+jCOvJOsmGFr/M8wX00nf+YndR5nm/4Is
	 7eP7G/2zgnjqqgQb9QcqRIBu3yXHOPyqaWsP6qB0kz6qKFPsPvDaHTnR8wktgS5KBl
	 P8Tzk6uQAKTqD1DiEqS/Gm9396kSK5knTIQKbdKVB3dI1e2vDXYHwKJ0zySrWRd8cD
	 hKwWys3u/Dt5g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E7BC2A09B;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:03 +0800
Subject: [PATCH RFC 02/13] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-2-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=3532;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CYIc1grENaJdW23IuxAR2mIbHqlN5p0Qzr5lTwIiQZc=;
 b=vj4vHBRaXAz7etIULkvV5Z9u1GthgAv8ww+CrE7FRqFWnH9VEyTBmFrzx4yZFf+ogRTl2aZwi
 kvK0TKpok5OCsScuovbsRcozYfPLcz2WQHypWq0BmnDk24bUVXuYs+I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0611A1A0003
X-Stat-Signature: 6gkrx9ssz4zoqymitt37fzsz3w4xzyu4
X-Rspam-User: 
X-HE-Tag: 1786137470-821552
X-HE-Meta: U2FsdGVkX1+AfYP52Pa2uCgv0ogT+1C8ymar5j5nuBj14bbuxDTiFluKF34uBqUACUjqTp2jsevN8LpnIeVeuPzzodaosQr6ABNiBYn2Wh7tAfmfvUfHeXFaxwHoq8yMPq85DYm56qUn3votoLGkgYNZEuaRltcLJorz35nA22/oKKZg+gzH59sJzE3ijZZQt2VLHGJnP5REWlGbGTCKv2qg8JYP7nKEDd7nHGuxEWfKQ8ikUXkymJBP/9uEDJvO9qjwAz5/T+NEt+rMOaOAxb+1brJGxgF8pnOQL+IaYOJR92JQWnAmPPOK57bTi9cNsLIbmq/zbEMyvP4Ahlh2gd2s4FtOttmxLEqWvF38FXz30RX57dfZAzi6i1hWT8oLrKboAY7DbSQckRhVsOEA4iUj2bqUc8JEm7dL1T+GOAEi67lLSwKPJ0I+dnbATGkniF7ABh/mYTi+3ZzFzZpesNLsg8R5o20hnT59ZKbuI1RL5blXB76MEwrI8zc8kR3zlOqz5ze92eaVJrUlWdRw5PpllqoMo3XNSuVxtEcPMpgBK1cs+eseHsttB0Z1znDzO/8KejyN5cNor1pVzePkgi+utOb5b1u46O+oyIPG4F2/17kEfhWBNHWG8Virk6J0Fb1k/iugU2fdKdEM3f/7Xdu0tnUq2tCJglLtETXOquEZY3hrb2jxjCygzIrmCES+dnRT6gaXvRMykqSH70nuMHa7xFo9llB2n61UHIJ/4mtopoyodNEIn8enfjwtCNKLPa17fTR4mx+YkiVjGKwxIHcwmv5UzceqX8P90JZjeeGdEkH0LUmR9XEDwrsB+3+cEafcC0yt9ZEuxIlGN8Fw8cGZxH3ZzjEYmkLEspkX8JIVWAPDqVYzYCsQDcOc+d6w64b0+lUavJ7ZPTzXEMC4/zx0mIPDQ425pj66+5qcD6XcuA7jPsSzb8a1eRmwPgU/PRBlPVJ12YjIiLTwUeH
 jRGC1UXN
 l3uvKc3pUJoZULqJVemw9G3w9nBCtAQLitRjDwxE/5p5UdSuNoxpwKksXIeCQp/PS4cRqqhYF/IBH8Ou9ONjj0ktnFBMoMqz3xCRj1J1QD8rMqI27HR/OUdhyAdTdc5vwWhBs5gxrHzbhUwPbFbomVSxebLTlruQJDhz5Q6BmsJz2U273Ie8yfZHiQPIqkcvrohEOONZHuECo8qolIytoBlUh4HEgtW3zbHztoI2BVxDY3B8fH69jRnuNwW7T3IXhC29UH1ljyYuAa8tP3lQcTFcV5yVJ59KbeiwhpLSbsHqsQ15mU9YpX/Q1j1grfhAubAz05LKd8H8BIEzJgURbaJLr7xXCQ+OuGsZl/Vk8LDePNz53Brg8L+aSsfyUxpojuzisjYAxoVg5Oc9qNSX9XFpFqVYshiQ5yjnf3Px7vRZpmHSF0LXuksuprrY02cepAyVVcUmIaz+LAnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code only checks for this in __folio_freeze_and_split_unmapped,
after the folio ref has been frozen and the NR_SHMEM_THPS/NR_FILE_THPS
counters have been decremented, and returns -EINVAL without unfreezing
the folio or restoring the counters. That error path is fragile: if it
is ever taken, the folio is left frozen and stuck, the counters are
skewed, and the VM_WARN_ON_ONCE_FOLIO would fire for a state that is
actually legitimate.

Check for this case up front in folio_check_splittable and return
-EINVAL before any state is modified. Under DEBUG_VM, the existing
"Tried to split an unsplittable folio" warning in __folio_split
reports the rejection.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..2fa72158e063 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	bool is_anon = folio_test_anon(folio);
+	bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3901,7 +3904,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache) {
 		return -EINVAL;
 	}
 
@@ -3911,6 +3914,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping should only
+	 * be a shmem folio under IO, there is little benefit in splitting
+	 * them hence not supported. Reject it here up front: the split
+	 * routine cannot back out cleanly once the folio ref is frozen.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3983,14 +3995,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



