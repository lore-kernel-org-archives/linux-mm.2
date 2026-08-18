Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29251C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D746B014F; Tue, 18 Aug 2026 01:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1747B6B0151; Tue, 18 Aug 2026 01:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30E16B0150; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C23366B014C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 589CA1C1EE4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:28 +0000 (UTC)
X-FDA: 85113285096.25.21E647C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F804100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LTGab89Q;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031506;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kWBHy4aewA0EfpP5VtKrYP+bc/BbVy13Oaa9PYOn4E=;
	b=FLbeKCxwbye7uhl3IXgKxSIJrJmLBmuGLvCoVDXP/OhMHBQjjtYVEqk/+eforPlO/VV+GY
	nvBkJenSRPuhzb2wi12eZLGbEA+VQkt/IQpna6rtWsHhwV02Ywaqf+xNGcSfxlWn6Lqltl
	ZSABNfqEjmEUSL0Lr0hDtyIkaYywhJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031506;
	b=mOlLmftC8AkOGaxjf0wqv9+QCqZ/f+OrRdYeIbcinuFOEKjAbu049ExujeIZ9VA3aRpDNC
	Mc5rFR7wLeqAVUe0r4GkqFX7bh05d7rR6y+utO/cC2pqq6BOL0GTl0eK7BBvio7nUj4IZk
	6zaqkDgsVyBDdTdZEylQNN6ItCJCFZQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LTGab89Q;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D574408A;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DC97C2BD04;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=vf7uUbNRQoieyYFfFFIOjDq7Zps04yMwcdb5rXbBTqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LTGab89QxsH+2wOkBE11hQkp5+C3ffibZSkFOVGgVBY/t9R6+5V4buuIn2akRMsBP
	 DbU4oKpvnnxkytOuhdWYLe7dU20+pv55FuTpEpH5YcKmCJs3HBuw2yd33R3EiWNMUH
	 WWicCJLDsSdCrC0DzserL9vFumBLpygQTm6dWtuHcKHnkMBzbxaJiA1oDhidQ/1Jfc
	 EcuXXm21Nl6RRTo8y2EymKXn9PNTOIGlUEBZXZC04C0O7Rh73UWzXN8s48k7Y2eRV1
	 jafAMoFq82epiQ7ItDOT0gw10W4uHFF6GtMs0hhINHVzxUCma9cK8j+HrK2BawiN+A
	 7Zt2GcdKD3Frg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C04C5DF80;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:09 +0800
Subject: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031501; l=1891;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VAAQ2yiZ5J1ZoI2nmEdgdm+eoSsfABEBNy6fHJoC/Ao=;
 b=vfv8/0vJNXjl4xfANa0zvplr3gsB8l5c6I3ZE3bYCfgQRy1JPhuV/RfkOve+UzP3ZSo3ThysQ
 4bzJd3exJcxDOzcNw7VQ6D4JMMsKi6+5BvFKSfMgZ+wrxOLJtBX/l/a
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: jry8zeu86b6sfqda7o7hxtgnifr9qid7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F804100003
X-HE-Tag: 1787031506-37001
X-HE-Meta: U2FsdGVkX1/naOWHkmcP206DCkEOwQYCkKBt1jt9PsoEj+wIr70J7pC0PJNRbpTuannawJgHpbqv+4gvkD5E5WXC7amfvMPXYi/aKGAa6VK3OMuV3VAlwcj2vk3UGvPZvJDMMsNvkTpEXELJyVf9g+eWsKyzeqzzLnzJ8xaStouJXpmkRYf4U/wttwO9kKV/GAyAS23ASX7pOeoziOgVoEYNg7CUlHWbOIEDDjc4Wq22Gu8O/XgnEH3kiaYCVETZ/6ZZ5YcuPbrIdLkLX/4ESfhuhFPJVndI1+hHfwkOpM2Fc/gQfribVxAL7v6ZPVm3pzITacjMws6ceHdkhAyRJyVH2Sc6Aa+KsF3a0Rj1BwEZxFPn4KQwRj0xQzNW2O6oeA65IC77eR3+1CHPo7D+de7ssbhzZG0PqifJCehDxXirN5WPcWek9nD836qyR5C/CUklh/mZ+y6DjyIiLIDkgnfgBnRErmEWRlZOkjSu0Br8F1ToGWg9nxO7w9WHWMzd4rG6OH9H7vPGnyggsZOfqH96ROdYMsgg812S+hDiI54gm6e+UNwSwihSUhyOQWoXNWxZ4lZPwfNTliYd+a7VMfzAQ7uTAoxGkTMEEaHoes4kyfGgjUpY0Dpy5H3CDI1mLY0Hss6xw2LWGx08enjJyKfqGLwPT6EYaFQt3KFdYjDZMMVk/rDksRxvjV+j4E65uGq8zMxObEDE50hHAnldkY7/69q45wYc0uEc/HtT6x1e9Su23t+uqCk5wt/mc4MUwuJ/NdMz6VSyScKvug0WXX3RjD8cMxnLPHHDmYRelQLYFHnUWCWiEbxkisPGwtK4ZPQlGwN2ypCbFc5vhFxIwdc4DgN2vUeF2Ox5CGjZdsUFH0zu0sEbHrDAMlgDsGBoMhMkyYZKZe47hsPEjNIfUbuELsqR1+znhdPIvvm1m7VJFhRXiCD0QRgdNfVm5ZFGaECtXiA+o59luonJl1H
 z4cNe/kY
 Xg4G80N01HSFUlVpZ3RJs3zKH8EtdqjpoasVO5A05yOPgVrpLGnr8gNL8nfq61Smr7CSHiaEEd0HvuUBLdyax5cIrteu/Xpt6Q6wXScMGlcuZWzsz4OVwHCHcM+HhOruUb4I9OTUgpuExgTg2W8qU0n6kNeDsZCcxif2xSbNf32FE8wLoLWi+mgBjZwKVt0EqVap2AW1Ur4fCy44nVvVwi7AkC2KIubbkf8OVTljBE8A0JMfRz5JGNPj9e9KNSQT4WZnrpt82cjfiMxJka+7SkLs3LaepN8c8+mb9XnlEXSpKbcsy3IsBk2BzoGxaNW3axW+eNBG8rwhobRN4ydBAkWQsFTu3yho3r5uBqoqgRgJYatT5Q+Ff9KbdQ3V5via5Y34cL/T02Be4iqq7Y2Zbd9cIaj4zKt54tDaODZKFYZ9yZb5DHTOoEhjr1EFDoxNvLDSBVTiUdzl7ooY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper should never be called for an off-list folio, and it always
expects the folio to be in the oldest generation before doing any
cmpxchg. Add a sanity check for the off-list case: if it is ever
violated, bail out and keep the folio flags untouched to minimize the
damage, instead of silently treating the folio as if it were in the
oldest generation and promoting it updating the flags to an unexpected
status.

Also rename the variables to clearly distinguish the folio's current
gen from the oldest gen.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7169cac60869..7e3ae0c6cba3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = lru_gen_from_flags(old_flags);
+		old_gen = lru_gen_from_flags(old_flags);
+		/* This helper should never be called for off-list folios */
+		VM_WARN_ON_ONCE(old_gen < 0);
+		if (old_gen < 0)
+			return min_gen;
 
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
-			return new_gen;
+		if (old_gen != min_gen)
+			return old_gen;
 
 		new_flags = old_flags;
-		new_gen = (old_gen + 1) % MAX_NR_GENS;
+		new_gen = (min_gen + 1) % MAX_NR_GENS;
 		lru_gen_set_flags(&new_flags, new_gen);
 		lru_refs_set_flags(&new_flags, 0);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));

-- 
2.55.0



