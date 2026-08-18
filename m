Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67964C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B37B6B0148; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878906B014F; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3A86B0148; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C3E6B014C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9341A0AF8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:27 +0000 (UTC)
X-FDA: 85113285054.19.E4B8AA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6F92140002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KpA3xO6c;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031505;
	b=5YsvIu7pjFKIZuR1LUW716oADIxKcKx0w1lewZw1TZAF+8BKaUY2qKuU4d39Rq9d32wNDE
	VkgxxtkvM9h7MqXpwJDh3m8VekqeoK+oXspoFW6ZqeADwzJPpxP30ydi5sjB71CcYwbQdC
	ajzmmAWl/s3BT3ejOiw8jUEe2E7NCUg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KpA3xO6c;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unwW2hLdMWlO9cwLMQaOAlPeEkk48X1s2wv8zXbjmXE=;
	b=z5rmUPTSUZvR621RHrE9UAqKLzkw5/Gndf0BR1+sbAjE17FCuMtWqOTFkUTqmde7B+FRv4
	59QYJr70RhQCywDPJG9cIQBUvAVW+QsZ133805rOcRuLzUZSnQFFoVH68h9LmoEoifYaNn
	eQAG8qY2+ftKThZew7rOTSd63QmfvVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BEEC4400E;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41221C2BCFD;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=/Dap8HX+JALspR15co61JO/ZEe5sgXMBY1Lvt6lrf0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KpA3xO6c41IaXbmqmCFFQNGgoiKoADBI9iIN5v1UtOj5mM5iCtENnL3NuKy0jae6Y
	 saGmVezGKNIRYu8komaX1eDr3C+spdAJdi1wB6tPXleDN8/7T++ZqESkDbPfmhxYuI
	 Cvk4cqMjQuRFLZjUHLHHWHfUWGXHRka/450fgn2lPYrZCMSNGaXWmxd/gieSKlnhFG
	 9N+cxxdoUt9gHa38bAozYxLZRWsDp0JirwdS5lk1u73wU9CUy9IP3HKh1y1g/W3NCK
	 M7Bc01TLYjpmzv/bWS4ZONcjF/ZmpCnl9/bf/VsWH6VDXHgoPn9FL5tnT/6nm9ZeaN
	 ZQPFwMA/qgt9A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8CCC5DF82;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:05 +0800
Subject: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=2602;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MnXqCrD+kNnVgk+e93wC9DHznJeWbyePZC5TTqXqepo=;
 b=11ce+XvCl2hD19O2/CuCgrvBrmVTUm6nz/9U0YfjPuhZy1wZ8IJb0amYtFNhwztQfIB/4LtWh
 dx0NKZPYnYMBdFtD1f5AZ3c3/MzE+JFMBVWgnVPkcoVz/2/dB4v2kvE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: A6F92140002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ajjpwkujj3kqs1cccwka67et9ggr6kxk
X-HE-Tag: 1787031505-275051
X-HE-Meta: U2FsdGVkX1/m7pRwbYpavscnbnFfuOUg3Tbg8tmxrFxqz7z2qct9zWAvhNjGEZhbnkIYnLisWjUIuHgKocYaeW7MNwZCWvP4jTfUp04Q14aak5CVcLeNBHXkBZIiWFvlwOT9NA2aedddVhBI2ay6916TJYDkOhGBmwrl2UBrQ/NBGD0OnVx7r2HqVD90EO+9XdzE3JZsSjQzYAY+WpliQeNr7jRJxkhbmawJXP6xabu2JHErGaKbizGYrCozW7CtX6qxyNPhXeeQ/URJRoap5+CxtlBcGozndgy86O9M+MLvMkRFEVy5lDDhLQrcpEfzupEh6TTc0rt/yg4wTezf+7dCG4m97culNzZ3g1CPrcO/6Wgbvt8MDrUWLyTTy8cJ3WuXrFHOYNU4EGVK3m00EEn0e66VaOOil9f6mzkU30W6IMnS6WSTMexFI8TP/afMuuWEUzJsd4n0OqPwofvSvaHQ07TtAkwZQJ8ivxSGf7TyOkVMaJ7lZrECNeW/1lksktB4DMn0aAcjQHaDVRjFJqHQ7mCfCQdhvQYZ3/drnBB2enSSe2BZnH47CpIrp1RXqd1rZU/vkJU39gsSqiiaaEaf/lHK+Z0euwF/3qmSm1k263jvnzdphLPRn5IiEECQfxAvWorWYN+W4RdwuVdoedU51J/uYULO8aH7D9wOTirl4UoF1UdIXZboG8xlSSG4T2o9JMZdHhebY/4YTaNmTtoSmvZAJy5TnKcx/FY+D8arsd8IcMpbXEG2locuWwf7eTrqsc/SzygxtztGE4pY2kHFk+UzuEd5Wfa5PvMEcdDbv2t4c2Pn+ZzotAKBIucY3HjCZs70bxlr4sQh3OppGpTABDZvyAzrxZvSPmSzum9zY3IQxNOu4aZIwr70Cc9JVkzX9qoCxDcC6QzjaLO1my9Tl9HbOPIgDFLPh2yIzMCtD5F1WlPTMDaApNcmB7L4T8Z8EnKdiDArkhS5voG
 1pUdkTPj
 6LbWZuJBkyezCm2hvYS+qodcNNhweL/Pyip+gLzA1XnXhFYcwOa55eAgxgjwmhkQetKTFtJrGbopTo+bGFVkmLUbfFcIhX4+sqpj7SNHVB8ad8KfH5ftSDpyD+NJlqEgy+gppnf/+eqAQhDlWQ6ZMt7DPh15jruN8KHcpIpS8Em4212sSd5nM66AAwBQhtxygCcXFlvoMouOQnOyizR7N7D5ZCh0L1uvkTv8mGhDYe3lVIeK4pliRj/2kn70ctcjFrppdKAW6ZW4IE+MUmKie0zli8yoXBm6c0kzTQQgNYjZS5j7k251ThcaRbZR7SziRQU/HJg/dmKyVD4BCvvjXkNPli90Yr6jivthJOrNE5cneiSwvPrKjHDHPncBUjiu8vSMOXY9uO8vzB8qsxPNmE5MRExqplFlNYQUsKl/1FgWI00Isc1n+Fwuoi+Sau1M1RWuAU6XmloWJNfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_migrate_flags() copies PG_referenced separately, while
folio_migrate_refs() copies the rest of the reference state. Make
folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
the MGLRU refs counter, in both LRU implementations, and drop the
open-coded copy so the reference state is transferred in one place.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 16 +++++++++++++---
 mm/migrate.c              |  4 ++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 93bf3fa221f8..df62daaa2ee7 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
+/**
+ * folio_migrate_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, including PG_referenced, or just PG_referenced for the
+ * active/inactive LRU.
+ */
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
-
-	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
+	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 #else /* !CONFIG_LRU_GEN */
 
@@ -401,6 +409,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
+	if (folio_test_referenced(old))
+		folio_set_referenced(new);
 }
 #endif /* CONFIG_LRU_GEN */
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..82307332711f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -776,8 +776,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 {
 	int cpupid;
 
-	if (folio_test_referenced(folio))
-		folio_set_referenced(newfolio);
 	if (folio_test_uptodate(folio))
 		folio_mark_uptodate(newfolio);
 	if (folio_test_clear_active(folio)) {
@@ -807,7 +805,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
+	/* Copy the reference state, including PG_referenced */
 	folio_migrate_refs(newfolio, folio);
+
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0



