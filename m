Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A21DC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDE06B0099; Wed,  2 Sep 2026 05:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E296B009B; Wed,  2 Sep 2026 05:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D476B009F; Wed,  2 Sep 2026 05:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 072636B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C7F7120151
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:05 +0000 (UTC)
X-FDA: 85168353690.14.1EF60F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DAD61C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ODwY/Ye6";
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342663;
	b=xnv9w8ay5dsqWgNCYRSYHomq2jXrS5uBTOAEL1k1h+VUn2TC1TGqeYq2Mo7+xVaqf1Dqhh
	7CCzZQTskgTmJjh34FzBXeG4Gbe9boylAq5MODSeVtTGzc6hjoCh06Ttm47v+rx5oEawZI
	bQ1yNOLQD3nqooUj6KmjABpG8/vNO+4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ODwY/Ye6";
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342663;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVVrNHkl5HQ1wA54iiruOVX8OD14foi6k8zb/9rdRyU=;
	b=6gA8+jvxHfTWUuc5mvZwJPcshTEVucTy39B2DqwRAPlWD0E39a9c/jzrbnwuuar0nZrmMW
	X+q0qKOu5Lu7F7RiiwsTZtBo27HXbewfiZ6TCC9fAqtaFyvOJbqxWCn8RrmuimVDCX8kpN
	B/HkjN1eMfItZCs5F9tg18af9k2gLJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53476447C9;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0954C2BCFA;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=ZFETDp6p9x9uvwIEd+HcIi3/dkthWZDx6+TpdJIY9to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ODwY/Ye631Rwhf/3uAzAk/Q5xTBhXfzqlhdZP675Mo8LmaAoMUt01xRD265D0dYau
	 5gMaJdSNbFmdYbWRn3I0OiknCFUs7Wv4w0jadRepdCkClmNVWj2MP6OoqbEcbewu4h
	 yKzozgREq4rkHWsf4WQMc/NdoLJ7kTbJrInFe4aSTiokhWvNkr/szwJYrPGH83g2wM
	 45YVqD5+87AbGav0rkRlf+kUsWsm0cQhDHL1RNVfleoRc5BHK6Gzt7AoHCRJRR20AL
	 M7iBBGyxhoQ3+8FFNUFjnTnxE7rFya1V7xhkWtJVfm+W/5NYb4chZ6p6wg2hcXl+CV
	 hzWhBMuugj/BQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF60C624D7;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:56 +0800
Subject: [PATCH v5 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-3-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=3683;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ox6zaP/QbfpF5dExxI36sjV5rWUkpJpYAOEG95FC1rw=;
 b=FEnfQvBL3/fmg1asiheJX1Ar9Ld/4KCcGnDdckAqj+CLkjyccsIX7u5VcGKPNX6YhMjrv98vM
 Hkt6CXlJifbB7kso51KMQSSbOdxbtfGM4GOe5GnDa2NksnCGAoAPNpT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8DAD61C0003
X-Stat-Signature: cz4ggnr4iak9nkpsez65qycgoeu84gb8
X-HE-Tag: 1788342663-151406
X-HE-Meta: U2FsdGVkX1+0tRwJBJaMD4KHAomj94VuuOxf3HfSHtbKHv0X5BzWQOdMLriz45R7TyeTESr3q06xSsFqL2w+boEYMkm0DGh8wUi6AIVdUP5/01qEX20DyzCXXcqN5LhQb8arxNlT8yr9Q62LpGtrM8nudRNhmZBKbWVW4lnhdLxdNB2q+CTK4/Nm6p0UlNePGiVBzNr6y3hHEhrV2RzyfSqaeYzr/WSG2nqxxxqsglWyZxX1FmV1daNRkh2N6ICQYLcYBDvRTrqsZQOzQuws0E4ud/+/Z+Xl5nQLhgSMxqtcv4/fph7AcCq/fpCuKH5XJsxKCpw8SyXQs2If+QeXvmkYo/bGuN0/vMq6OapQh/cB0t9HhJuV2U/r40QwMurFnxJ8hXfzi0yw2XeAe/olfWJdi58cXuw+08EGg/qzWrJ0B/2do0ULD49qowQuiRj/ZkOA6RzFOYNKvmiCNzxHqsHW7f5jSMPIRh1kaBlvL0FttHxY/eniEbwAY5RoBruhUYX2t9+Lg2Ztk9jVjYyi+AjpipGxbVmcFmQYqtoSJThShFsCuH7qhyXrlNyKyZP7vinTdmRoNhamQLxX+U0aS/mvI40Y54FW/yan0j3FWs9fqmUxqpsXCk1MwAxNHaApNQemg/D46m67X7uxmo7LH5yhMPW2bMSLyG2fuuJilu8G+cvJ/gfqRb1UtOo/VB7fUn2s6sVYUH8KeE7MuiKoA6ZWnwUEF5hlt9gnhV5T6KJtLBIgj8St6zehdZwWMAFlXD+gM5gPHqg7xqEoz1tqcKFKBcuNWCI2pbGL85OuYHDrt90+SXVErlPjMqXiM/J1Zlqxl9+WvDXSXN9IKCIopG+DwBgKDaObDHZBy08qz5pyBiYmxYfUAQMb9o/Ha4qbImKFP+PIl6/hxM/ZjhRVp5l9zEum/N1oPAuX7faIRRtdLFaqvaJUseqPlOYgITsem5U4j/uJs41b+1mso0U
 xKQmWnBu
 cO7boQFDmy0w/wzl7TFKsKhB+eSY7NE3VA8l6bOxR/LHIgWDoNNw9C7RoUOk7gJ9afzBqa30pl1W6pKDrkGj+5H8yTHCZuU0MihAN+YI3uHh4Xgw5pfOxh7makoZaBy2Vj6CsCSI0eWniHkBD42CoeqG+ErCHtpu05qg5w0tq74zowX0mqUgo24Tlq8Kbgf7QKQLtx9KxhJJVE4Cs4pIAceA5QqfJ/sfYWzegMG93JhTcJ1MKH3cXVntZF3QBvHpuaHmUNRU0KWke3gSJ+0jDQR34k1CZRWZw0523dUS1fep5jePdVKD9NAw7IYIYkcEkvezmVgi/aWM/4m/GWhgbjgRRo662wWQQoRHlYhTbNl8o5Y0GixbzHW0wmyZddPKsHaA6Gm7wL2s8iDmfW7up2E94PExGbsNL7QTyMImKI4rICCoAKh2SYTXKdgYLxYuyGCUuOsmMbgWKK9uL68IYCp/D0RyJOZNH1TME7Qbf1MyQhwtz5Ji9vAFzFWmry2ZguiXPjNt4T/RZw1VbMTiLhSBQrTyvupzW4Cy1bQn8nAHe4zqEZOwa1dQYMw==
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
marked uptodate, so a concurrent lockless reader cannot have its
reference update overwritten by the copy.

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



