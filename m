Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05147C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C97F6B008C; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A06B6B0092; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B60D6B0095; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24DE66B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9C5CA42F9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
X-FDA: 85180298994.06.6206113
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1C0E140008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDrIM7rl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1v91JPR+xsHrB9SneMclvDf4KDlGN89MU4CEXdnwM0=;
	b=fxYmEv/H89AhPBlXak2GsLr//uH2HFSwk3ZpnBMbRwBjn90hIpOrvFDShnMCED0rjb08A9
	OulSYJj0o+BZtbKX+41m1On5igR3HBu2gHiPzgAF0aE8KUMkUQAmSEKz/Mhpruo6zKGfaW
	e/BJJt8U8wFcBIndsiNlyibCNP34nPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627075;
	b=I8bFlXPKXASONBDsn3NF4E9MRoqBeYjgYX5VIC6GmTBDC+XcNI+7Xk2/rEDZqunW+WDdCo
	uWJLkUB6bfZswIRAGX6GG2Iy6wVaeiYce+aF/rfB7iVDTKNpr2bPGdC5qdHs0YckfUOQT2
	nS7u+Q6TYr5lZ4K5lOUqP9QFRmLkDxk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDrIM7rl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94C95447BF;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63932C2BD00;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=3pdquGeSj6n+GQGGIIIFigvsn6lEWaYHJl3YyE2XROo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RDrIM7rlajbUC6BVx67dmhbBLisSYKbuVEqOyU9e4whOu3kx1XnNeDOpmgk9LyRmp
	 H0lzxm52il+7a3+Pr2x/um4WtoEySrEoy2sZ3t8ts15MU7izyJKC+9E/rZw08Vptf6
	 cGdWIQSiTDl4Nd0QVqrJafBRMdrqY438aDrDUna6C+c1KOik3qOkHFe//gSRmIDFQt
	 gnVcIh7qKlBl0HMzO5ZGFukLUwLVNf1kRcEgPoPkUTxPnYm8cGq4j7JaNqWjyBxO2V
	 fRH/F8NAfu8Xfbmcs+Eeojvpa1frHP4RpvUsuUATE1FVq4IMCwH30NarIyJh5QS8qE
	 GcGm4k4jM+QLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49282C79F91;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:08 +0800
Subject: [PATCH v6 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-3-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627072; l=3640;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=s73E9hyvo5IPw9/tCNlmyxLf3NiRtB+N8OJZdDSwI9k=;
 b=uINzSH5t5848y9xwanmdSh4D/L8VsdRgq5aflXOeRO+VW00PL+BWbo5wxlZKp9Jutas0Iimq8
 mX5dn2F5oCXCsh5tpbGqAsdgVUlg5x0AAbahb6FJjk6COmEn4A0x3k5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1C0E140008
X-Stat-Signature: cgt6a996mbsttaci8tq6kk64xzn3bacp
X-Rspam-User: 
X-HE-Tag: 1788627075-8623
X-HE-Meta: U2FsdGVkX1+S0M91x2iMnnFaiWDbm5pKKduw1PfsEMQBVXOhgw8RhDFk8rnjvdU2MFRtkdj7xLkLR2ljiOEtiW6zAsc0gN1okA/R82D6aOpnhrrl1MEIGWZQDjNHVU24IDhtGN0lTjJbxG6HKpevQWT6Aacinz4FbauQ4MNQvoxIs8K2OO5pLWiG72MG8UVNqrMrpUUjqKmuNE99hYwqbgCglsTW3qkYcBpu6M1VucMa0JgOFJmFhnqQHfIkb3rpdJNUsd4LFC2hh5PyNSrE6oFSBTzAHQtazhKMIKmh1btHp1G2Kkr5P2N/K4PCiRpNnynlyKwnbvwYPmpEx80Ww4dIXfTeY2URmv5RoCr/6ztseAQWuDT1Rxj/qKUV/rtDPSIVRPUtBGwcskIp9v6AkrUL8K1NBlvevznkHazG9Vk0wK9WPMoUEvvWo5jXJr0KhQpY2VTLzt8o1WMeb8qZPIBmVQJkhZRUIXtNuwGlFPOZi1UQBkHjEHJratiR6GSCCOfNCRsMX2JD51xfpVSEVM189w1O//0qqRMmT8zKrM0G+w0YAy5RG9NOeELayJCtC3Bxu3lPJQ3v4yuYrrK1KVJ9kSVpm2BRmEwhfp9XGQPK10cKR2B7cH07OLb4N6gP05pYEVI2SR8XNCE2WjloNxLfAoqFCu3Hjfvc3X4FhqCt61D0f7j3zpq8zMb0Zs7OJzyJ5lG5sxRRWyaWnH8HsoeLUZfiJDGMOQop/FTLcu8FVIw9NlCNMNelsaiE65XXsXvHfzkAUm5Bjd5zfqbPEJYw8HdYcLJnKWEmnjB5Zn77hDhvceUFceCJWHCSUo+TySMhXG2S0B2UXxC9zAC6kaPKZy2uPb3WsrqoDTCh4jCeyzyjAXt/jrFJrTPk5PAvC0HXpkcH2NS9Q0QQuqnUwjZkTAt0if4+wfeehEt3n1UZ6faxbh5AmcJIre9H4HA26RbSGIM/tXykXXHmwes
 jbVRRMhm
 cRdD9y30aoa15gCzDrkfL4FandI1sOnKkgbLQ2Ag3zzNgdNQdDUjp8WpICDDeZnBMVOFiC5f9RdcYM9zYIW9SxYXmf8tNP9kxOuL4F4T3TyRame37DcWtybkcOwbLnXlxPyJthqr3vHfMHiLz/OZZF7SNXrUHrQj4tOGwITOG30W4fW0n9RoWNxILqFtBOebBElRePetnmz5lL12CL3gPRxol5rZBYWHbwiIQjTUgkm42qPhtAvm7cT/t/cA7loYvI3srBPzPx+gOmDV4IJYh1AlMe42dKOtBci4jKDOZuY2QfalvEPvNX+wwlHr248Lc73clrUqaIhYL2k1zrcylqz2wQsc05e3Nr/DIh833U9mqmYStZ4JqYBkf57MEawdb/GIfcFhBsqTHfRrzcI+HR2kKHmn5pXhQHbg3KCi2nP0GMbJR6N3ISf9L2dpEzlUds6IJ7B3/tysoKYMYbJL+a3fIBgdxIbJhuQkiUCgkHBDu+Zb0qP5oSYQh2FHQubWwmCuWottCAcy1sSLw0i3FR0M3CuyqS7cZYJTNDwyhScdDKjOZ2J/o2L+g2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately from the MGLRU
refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
PG_referenced and the refs counter bits together describe the
referenced status of a folio.

Consolidate the two: rename folio_migrate_refs() to
folio_migrate_lru_refs() and let it copy the complete referenced
status, i.e., the MGLRU refs count including PG_referenced, or just
PG_referenced for the active/inactive LRU. Drop the open-coded
PG_referenced copy so the referenced status is transferred in one
place. No behavior change is intended: under the active/inactive LRU
the extra bits are unused, so operating on them is a noop.

Transfer the reference state first, before the destination folio is
marked up to date, as a best effort to retain referenced status.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 20 +++++++++++++++-----
 mm/migrate.c              |  6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 3f4bd5b02b54..047295ae6e8a 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -373,11 +373,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -406,8 +414,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..a369d0c95c38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
-	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0



