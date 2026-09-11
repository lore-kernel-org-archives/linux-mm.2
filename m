Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF35C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F49A6B00A0; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F226B00A2; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706F66B00A4; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B74F6B00A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3C4E8014A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:17 +0000 (UTC)
X-FDA: 85201300674.22.B56341E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0D211C0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUBR27Kk;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127115;
	b=xIC+MqWXfJNbeIpqpeIcC/G3VjS36yiP/KHiT4vcx8EFG10zSV5TAvD0ytJjd0w3pGLtEk
	qZmfsvldy3/L0LAQ8TsAbPPzmkjpTACN8rRMhcHD5gahVesMDCEVnL+5wchZIzE+QR3fxd
	2h7nAHKLGH9TJ2AsWPYt57d9WxyEnbw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUBR27Kk;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lc2MWH5SFayjpJFPmem8UZtEK4pEIaStMsmHX1XCMA=;
	b=VAUdY8fj79hOsIq6YhIVMLRH6DxXmtZz75TvueexJfmuyg5k9zA8KVax8K2UzJTzJF3GYM
	y3GwDmaw+8BVL3WYwtKZEBWP65Ovjok/4JzcLPDcujuXr9X5rRVGBLfTFsciJZZAycNljE
	bHFHY4Pi0f+BOGaCZQGA307YF0um8tI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E7B244857;
	Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1DA8C2BCB8;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127111;
	bh=NuIp+NhjV92s8t/xN+B7EwgddrsPlInZHRYqmQ/ruRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FUBR27Kkd0uKMWqT67rg/Sk8UnkBl/ppddUyJjKdL37QdPqrK1rp1H4EaD6e2udvR
	 rosAmtmd/Z4gw2MOna53twY4Gfq0gghgascE1wLfUkGdVN5rpAqZLCK6NRAOROsYQ1
	 PO3ykPJfI3zqeVGQtcU7wwEggqAhtmJJWZqDFQJRyKNhI+g07QQ/bTM4YSFs6USnJw
	 Ch4cCsMfBMUZTeEe7L8RsdFT3X8m33oV87EdH6w3cqF1kGy+3btD1VNTaVGYEev6M0
	 ogIFMHKjK9D1CsnsHiHk2ZHlL2Jm4XiGdJS+7htc9JQ6tNkmmqcRUi5C7mvL+HlFJh
	 yYKtU1RNmsLtg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF070C88E58;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:16 +0800
Subject: [PATCH RFC v2 13/15] mm/mglru: make folio_inc_lru_refs lruvec
 lockless
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-13-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127107; l=5413;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=qsSEp2ETBhYitLGlOVBAtq/PfXkJQgb2Hmat92vvGJg=;
 b=l8a+8v6n/1QzmI7ilkWtjQPVIgmIJTsD3dquNkK6HfeVXxZOTqeddMwskrazQKI3froEPK8Fo
 oMTMAJIVNsdAPPdbneLuKsC39Q+bijNPcrllJ2Ajiq3dP+S6HphaauW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0D211C0002
X-Stat-Signature: hfe8tdk8dqydpzix5g97yekqohnicihu
X-Rspam-User: 
X-HE-Tag: 1789127115-737695
X-HE-Meta: U2FsdGVkX1+4zLxnuhsF3mk4ucWhOnyE6lv2BlC1UgS9SmjgHCLhEqQQFXLSC4kE9PoSQnusmhB42PlVcOay3wl4xgOVy5h2n1BoZ7R3bPdtlpsk+4qebZwvixtgteavmIleYzEnO+bVjzOzHjmjNUSie+1rBnRgujhLykTo/2IWPrivnyqryACoK8qwAtE2ta0seYE3iO13ipAkC6T5pKprh03xLRT/oFuUAh/MqVI/Mc22RA8zNl3DT0tES0z88L/ueiQfNP5EfciT0Q4dawEs3nihNDHfz2Mra9tWSiuI/VEzq0Fbx77ruwF5DVCNhpKxWDKklVaTO/AX3FMsMClNjCGLRqZPZ34oMKzQOjUn0keesIELsOuIgIeYz80NAgR4t/OlD5DiDSh9Ac26piHxRWVEm1xVOV12QLtPzfATcOTkMUb60hbde+eXV2cvXCxYk+HGB3GwJQF2gBwz0keTv9mwOAoKu0kAOZuxDztuhgEEj8odMhg7kJoqCgVfQ1y7s20D8YuzZmWy440GMH9xchjtQkZQao0OuRVWp/vIbomy+rQoYOmnTaFVSbHWKrA222mW07BSYA/FON2D2agtW8hH+JK0WlDHnoAIDbOdQu+Oqv8paMmzxctvOx7rqSHLDrFZ6syGFM8aPkC90XAJQTEMa66/bfQogCsgaKPfEvAOj3CvQv2pVjHYvBh1oaLY8yPfJE945xUiBrBdYxI50niL2bBWPncQMjns6JVIkDW5g2KdoAhPQ8+0bt7Gw9C+t7pBkjuLd3Yza/zhvDrlW0gun46uiJPiFSpYToOru/vheRUYtmdT0VgldHW3gjilhTT5G5jRy5IRKFuvQ7WgZXAqsbpUn4wn+XkG23t3pLWgM/qFldu+8i+Ce5N3/2wacaTl3WBQXBtuey3QOYwSv57bUX5c6kK1GOyL0LPkEP0SYGGxBH7P75KhF/xRjaJSA7GfS9hndwBTW5y
 92o0Dw6d
 ClyCE3ZiJml4IerzzNdpOxgPdv+Q75I3dT6ttmj1HPTMCZXV4am3dxz8xDi/zr64zRlU6jOjtQXTRHo5oRw2UIjL/S2O5ppJC+WwYm7DtCyT9NBpOm+F91OThUmtgmKKWM6cBI8J7GP9N2WC5qDwPPSKVQkNPm12Cas9wTspc5NmIa5ubFUZMEJGozj5idL7UnegfPqYQqouwOSAfooelJB6lNkwJki+9z8+18SpJHfPcYLdIf6mXx/d99GLjflA9pv7DPhscePv+tIqICFhAJoiR0O9RPNleh9GDPOOCdEEmMr0ybIfN7cpgL10FY+E6YaJ3fnnVuQvQ92Frm1MlnWhmYMPsy7xXp479WYXPYGi3uPn5B0s8z6bRAxjeTpy6/LTp6mRbPWtL9SPOcacgfSKG89bZOb6AI93/Ih+0MjNVVnFiZcW6oU5yTwqB4KITTIwc4i5M4fbvS3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The lruvec spinlock in folio_inc_lru_refs was only taken to keep
concurrent aging from corrupting the size counters.  This is no
longer needed: the per-generation counters are atomic, and the
active/inactive ABI counters are updated per folio and linearized by
the CAS on the folio flags, so concurrent aging can no longer corrupt
them.  The same argument already allowed folio_reset_lru_refs() to
drop the lock.

Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
read lock around the lruvec lookup, and drop the spinlock entirely.

Also simplify the post-CAS accounting guards: gen is only assigned
non-negative values after the old_gen < 0 early exit, so gen != old_gen
implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
The active/inactive ABI update keeps its gen >= 0 check because an
off-LRU folio has no lruvec to update.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 10 +++++-----
 mm/vmscan.c               | 30 ++++++++++++++++--------------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 686294fe81b8..bca00599dec6 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct folio *folio)
 	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
-static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
-				       int old_gen, int new_gen)
+static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
+		struct folio *folio, int old_gen, int new_gen)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen, refs;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 240a8747490a..9deeb40fd5f3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -960,16 +960,8 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 		gen = old_gen;
 		if (old_gen < 0)
 			goto out;
-		/*
-		 * Lock the lruvec if the folio is on-list. We are already
-		 * doing lazy promotion so in theory we don't need this,
-		 * but for now, concurrent aging would still corrupt the
-		 * size counters.  This is a temporary limitation and
-		 * will be lifted very soon, so the lock here is not a
-		 * performance concern.
-		 */
 		if (!lruvec) {
-			lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
+			lruvec = folio_lruvec_live_get(folio);
 			lrugen = &lruvec->lrugen;
 		}
 		max_seq = READ_ONCE(lrugen->max_seq);
@@ -1001,9 +993,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 			lru_set_gen_flags(&new_flags, gen);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	if (gen != old_gen)
-		lru_gen_update_size(lruvec, folio, old_gen, gen);
-	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
+	if (gen != old_gen) {
+		lru_gen_update_size(lruvec, file, folio, old_gen, gen);
+		/*
+		 * Gen can only go forward while on list, so concurrent aging
+		 * is fine, except when multiple aging increase max_seq cross
+		 * the sliding window border causing hotness inversion. In that
+		 * very unlikely case, just activate the folio.
+		 */
+		if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_NR_GENS))
+			folio_activate(folio);
+	}
+
+	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
 		enum lru_list lru = file * LRU_INACTIVE_FILE;
 
 		__update_lru_size(lruvec, lru + lru_refs_is_active(old_refs),
@@ -1012,7 +1014,7 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 				  folio_zonenum(folio), nr_pages);
 	}
 	if (lruvec)
-		lruvec_unlock_irq(lruvec);
+		folio_lruvec_live_put(lruvec);
 }
 
 /**
@@ -3590,7 +3592,7 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 
 	new_gen = __folio_inc_gen(lruvec, folio, old_gen, &gen_increased);
 	if (gen_increased)
-		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+		lru_gen_update_size(lruvec, type, folio, old_gen, new_gen);
 
 	return new_gen;
 }

-- 
2.55.0



