Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A93C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44B96B0099; Wed, 26 Aug 2026 12:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDFD6B009B; Wed, 26 Aug 2026 12:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F516B009D; Wed, 26 Aug 2026 12:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8034E6B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AFBEA077D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:13 +0000 (UTC)
X-FDA: 85143935226.20.37078DB
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E957180008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J JCT6qt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gBuq2dbD;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761271;
	b=ATymUKy19E7lxM88XwmbUu3xmlKcfkoPvcjlFvXEptb21X9nnvwnYipD2CnIv5NrjUcp2N
	4mPwf2TatKzAROJN12IB0eMmaa4Wz+N6QK4DpRxThLi4BVxyJdlQCdtpLcNO8rzLqDz9dK
	kCRQO/id7yV+29AeSHXRDEz3MjVw380=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J JCT6qt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gBuq2dbD;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZqn9LaepqaNPDOa8Shpk8ydDkhLYpgCWjChGLGqhJo=;
	b=P5RyT39JHwehsRIXmfhC+iti5aGzxiw2KxOHyfPMolrcmw4h86g9A9r91E4GcYGpg8clHH
	dXs34tB6RqeAdUpLLCmg4Vl++xPhie+XyLhO9M/WuHMOiegN5TycM0d+EwJohjtHS9SZqt
	yNu7ZZWoma0bmtcSjU3Fejs9CNGqsvA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 0774BEC0113;
	Wed, 26 Aug 2026 12:21:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 26 Aug 2026 12:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787761271; x=
	1787847671; bh=PZqn9LaepqaNPDOa8Shpk8ydDkhLYpgCWjChGLGqhJo=; b=J
	JCT6qtw1TNo+6ZXJEUgoeGsTvCjHGxQqp1NcbZMgFYTLMf/Ryj5Hz7icUY3Pr/sc
	+7xVeds8ASJjsQjE9FcSIIboIFBK1fcUH+ztxFTpVN+WGMclCAPu9EgPhAZk04Nn
	QyJD7Pdma5BReYyxUOCmG8y/TrFz4uo9oOP2M5M50rTYdLS2eJEdkmrrJVq6N4jj
	HpBp6dZnxXI2PSe19rDVa530BLt4FlGOZukEfNJWOQoj5KWg4ySCC5bBQd7BOgad
	z4O8phZsYRu+e4eqsFYBMDOqVVJ39gXLG6vNJjd+L2KfMxLmkyOEKIdAhboQkPM/
	t2RI71aBc3lvc7Trz8omA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787761271; x=1787847671; bh=P
	Zqn9LaepqaNPDOa8Shpk8ydDkhLYpgCWjChGLGqhJo=; b=gBuq2dbDYWOj+PqoS
	5YnH1V7B2iONpL3uJRh34zzuEmsIeJ3nN5s96n7f4n7t03BhgGANMlpwuOyzLCUd
	BWUPg7cQdp65S5pDGR5moiuMNQbI8lvDyLQvizWzPtuV4yxQJzPYCUYNGXwMatCz
	6PC0g4/c/iUVwIw9UrosYun0yt3dTs05mfNnH7L5l/mDKSv5NBUU9YB2cP9ENbhy
	86/U+d0uUq86s9v/FiiiIHUVPSFSPmFBZYU0u7qVIZBxiWahCG66G3aOdtG2xpIp
	brIyM39rjo9oXv6C5QZuKg+ggJuXmUm/etuV08zKxNR7FPvwdzkxXG2E2zc+aYam
	2eA5Q==
X-ME-Sender: <xms:dhKPaiHzC0Z3IsWLOD-tzLBL7oICTxPjbjzxmEo9V_E50h8UQkY2Cg>
    <xme:dhKPavTpNplNagd-JgowgUm1vB5WglLQXxafq6fNfun3eIW_afPWVNj35uMtVG_GK
    kHohqxqkFVtKs7IRRPu16MDZt0ihi6ph5iaBJYmpEYAsmQT_-57u2YX>
X-ME-Received: <xmr:dhKPaiRxZJoMFLYqiemS62JDvIzKWxVlVNGmsPJT8nx_qQrI2R9jFGWO3fc>
X-ME-Proxy-Cause: dmFkZTEpX8HBQysEAMlAbdyKFX4BLzWtS7+Qo1RjxAJeMJnS381384CQaxM92QA8W5J6jo
    7r0RHbsPcTs1IpTXqcOu2ofgimA8w2hMK3OeOMvPUWs2NDJNBlDL/23E29uU3eWq90a8Ny
    uayj7GqONoh0NEQ91mQ/H+TE3rTPuVZ+wfrdHbeyaEyRe40ZIUYJyXTHqnubEDskXnqfPu
    FIQsvLmT+4mxeisAsg0TmWv4Y7l9NdKef8tTMihpDmjKvNxij8lw310+ofBfGEkzSLqnuN
    AyozbfZUQr702Kz+RkXguKuGQfBCnKcQhC5EFdpLjS6L6jWqh1sGvO+4Vl+gX27JPRP8s5
    lSLckIYbxH/PtXTLtZPr2I496n1Z+5615svwkDFxhaNmgGpzGejMidUwbOUxLRdGuc2rZg
    w7EVq4D+yvMbxQ0bVxFYShdTuEeXaZWypH5RocS+FySPsN9RG8ZDbzvlUocKn67qn9YbT5
    m67TyzmbU49Yi0FJGi35Qm+jJUodzTwAIvcGJ25Find/PYmX3P1CefFAlt3ZqvUQWexH84
    GlGmeFWqYBMh43kqHoCd/fKRbITSkrbofIDfxV6HWHoS9gj+zSqQXSaqCKI329GRnYyGjV
    uuBti6l727veyF9VwljNVqtrv0A+Lea3+P/SoIQNmbyiZYUvBbW0UmRyQ0sw
X-ME-Proxy: <xmx:dhKPaiddQKIj37r_RakJb_-6ElPjFy0OR-u-ArK74qG17tMTafJS9g>
    <xmx:dhKPamdmzKedlfm6rrLJEChFZc-HJZPw0SYE4vlNZkOFTX1uq5fhew>
    <xmx:dhKPao-_JGxzGUylsIv3T4VYrdJ7I52r51lN-TdJ3AtTpPItm_Ddkw>
    <xmx:dhKPamMpM_ThHrwvuNcTpXjsCsubtDpaWzPa2MPdbH0wGQ3RanJxcw>
    <xmx:dxKPamO-VYWwj7r7ldMJSWsuH7fx-Zbo9LskAzojuJzBfZ7KXrKiCQl->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:10 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 2/5] mm/huge_memory: dequeue the deferred split after the split freeze
Date: Wed, 26 Aug 2026 17:20:58 +0100
Message-ID: <20260826162101.1314941-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162101.1314941-1-kirill@shutemov.name>
References: <20260826162101.1314941-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E957180008
X-Stat-Signature: fiyf3bxbecpdknrnusn8me53jketu31x
X-Rspam-User: 
X-HE-Tag: 1787761271-347257
X-HE-Meta: U2FsdGVkX18sBSClrqyOXkF58NYzdgkPW9oy2QTx7V8FWG0mXvcrCTbw/j55umMmhlhXjSJW6lntq9OXF5svW6Bqtake/nghtBpTSr5dSMeEoKJdWRtgm5AsXupO3hGkkR84DQpX16enIH9uMrAMBkzdoRKm+raWu5b+IorWKH8eTZ/rQD4NaAFuzFwEolZeOzTYRF2Rn3/ZSar9Ifh9K7mJV9QBaxpwfTrMiupmpbyWl9UtLHHr30ToPqRYzqFx/8ELexx3GU30fZhx1K5eHy3iUgicvDyI/aMUvoWoBSw+r3HGepqDwbCzGiWd/wetAWlXGwXY9H1K9ewx71LjzM1RBJTFiT/MxwBkzPzVGAOOmwG3Pts4RN5lWnK2vsx7GovCsOKaAqIuXJ/BoTmhS68ecx61aLg1jtMwdm7VvRI3rFo9vu1gxmzQXBB5s8LmW34wOf0LAOa/t/qXQZGIvywGSUQVmjrYGiFntMAwiKmm0N9+LCnf93hQZKqdbgaeW2ysJKZJd8DcKjAzUGxRVKbzpDWeIWK4tIyZyAFDAzx1A4DIV/j3pRQ/ZWthE32LR85iCwa4vdXcphsrZAk97MnZS+QwwKcxtTXMo/an+LM/X2JAmf2JuS+8FxY1wT7ad5MbylK6dNNgnclcG6EByZ3COeRQjFwSp/0RgNZ3SgdS32dqqnsKuU54V5ntcG3NUqWXqgiALjm/k3M+nKYVN9GmNxJkZ/BDrtDGYfXWHn0KhAMIgVAQSUOMyj6qxzbLbcCt8NkenIOulF49FjReakk/eeMsIRDmlbOOF/zYgw0iuw0nnyNm6r3/RKhxLXjUeGDvV9qYcO/WJOklHYLybaNk18HYnRg6Y5/Spc+E7OdQPgx51VPbbl4u1eCo7GNrpv2KBGyKfidg/4iVDETHP3LvwkSEY9MqXQewEV/v7+MJwCa03GGNnShSEpkR/MwZ3H16Hbl2MxEbjGFRlJY
 6Nc/fwaV
 XLQzdXaxF0uwUuVfavYPZvfGzxDUKKE4aH1I3Mf0KmH+YdahQufvMCfzLuxBi9W1Rdi//88QJOUG4yL/a0hq6mmM6hm+D4LD4DPh62E3mhL0RPWu0jyhEfDR5C1ZUXcy92aV3R3DDqLnN9fDPafZYUf506rAVKfPcRagJS7cDpUkC8QZHD5cF6F/rmgjddsh7k5FBsFGXLb901gjgFx86rZkV6//TjyLXLLBSxqupDOZ3aKkQpvlIP7umko6SjgUBPB3P0rENiQ4pDgDSeY8f8t9UHKiQ/ILgEhUYRR6JPPNrOJJpz7su8zCemLmcqtjq/YsrkKvOJJ4TRQ5E9fz0+bD8OcJfVY9JRJqAvW7+hQQQpr4VuCBEvo5MFQTbc2uLuwVgXjTd+lPI/B9whFM14JsX5QgiknrzYT1efbgJCB023zxiBFB3GXdS14dqGcFAbHHjw7M2Aw5BujhS+3lVpAXGCpenarf0PA7QuS0xQ13H5m692SdqHAfjKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
across the freeze. It is only there to stop deferred_split_scan() from
touching the folio under split.

With deferred_split_isolate() fixed, the workaround can be dropped.

Unqueue the folio after folio_ref_freeze(), the way
__folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
zero refcount and a memcg still set, and both hold there.

If the split is called from deferred_split_scan(), the unqueue is a
no-op -- the folio is already removed from the list. But
PG_partially_mapped is still set, so it has to be cleared here or
MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6281ed993243..c84e8cbc986d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3931,41 +3931,27 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
-	struct list_lru_one *lru;
-	bool dequeue_deferred;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
-	/*
-	 * If this folio can be on the deferred split queue, lock out
-	 * the shrinker before freezing the ref. If the shrinker sees
-	 * a 0-ref folio, it assumes it beat folio_put() to the list
-	 * lock and must clean up the LRU state - the same dequeue we
-	 * will do below as part of the split.
-	 */
-	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
-	if (dequeue_deferred) {
-		struct mem_cgroup *memcg;
 
-		rcu_read_lock();
-		memcg = folio_memcg(folio);
-		lru = list_lru_lock(&deferred_split_lru,
-				    folio_nid(folio), &memcg);
-	}
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 
-		if (dequeue_deferred) {
-			__list_lru_del(&deferred_split_lru, lru,
-				       &folio->_deferred_list, folio_nid(folio));
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(old_order,
-					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_lru_unlock(lru);
-			rcu_read_unlock();
+		/* Take off the deferred split queue while frozen and memcg set */
+		folio_unqueue_deferred_split(folio);
+
+		/*
+		 * deferred_split_scan() takes the folio off the queue before it
+		 * splits it, so the unqueue above finds an empty list and
+		 * leaves PG_partially_mapped set.
+		 * Clear it here: the flag does not survive the split.
+		 */
+		if (folio_test_partially_mapped(folio)) {
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(old_order,
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
 
 		if (mapping) {
@@ -4067,10 +4053,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		if (dequeue_deferred) {
-			list_lru_unlock(lru);
-			rcu_read_unlock();
-		}
 		return -EAGAIN;
 	}
 
-- 
2.54.0


