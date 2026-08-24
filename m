Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69633C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F836B009D; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9607A6B00A5; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8D86B00A3; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 523576B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBD0B1201B7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:34 +0000 (UTC)
X-FDA: 85136539908.23.A60133B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D744840003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="evkVSOi/";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rrYs1FTn1+fNq+SXDdkSW7HHYGKBPFlRq0xZ2JWlhM=;
	b=FCA2cW2LupeuAPQhq2AOlpZFD3Ou8MgiAVi0IqCKXWlWIPX9/WiFyrBMiMma9Yrhx1GsVf
	vLuDmZA2IkzvM4TdQo0e4rTKX/tB2OEBLvXgNb8C7IIth8dx3rOu8J0SUdMTJk+vtEhYRe
	bZeyE9l7o+r36BJK59wO8zMP/SfFsR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585193;
	b=x4ggV6FkyeE3YaUgXZP6eBD3I9iv6vMfF1AklVVYwaAPMEfIB/JZUVl2CLVQiJdb3hoTIm
	mVXi5VkrRTA+HR+NUmm8C73W/eV6KItUZFHd811DSc9fQY2Gy95whCHqPIffxJ81hLbAru
	i1cDJWdRZW3rpCBRvP1bgZM7gP5vh7g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="evkVSOi/";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 286C343FC5;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0181CC2BD00;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585192;
	bh=P+17iUIaKozZUszrRwBPon4mP56KzLJ6WpxOwu3K73M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=evkVSOi/AASgqhx0m0pslJmESHDQjSwT2XZ5pV4+3mjA4X+KiInpvYmecFJhALIbS
	 ghsOjUBgDXcgO130CF/TYN21VMOCSLCcHoohwcE8K/NZQcorYMpnF4hErX3gfwuejo
	 YCuNPm9Aq/8c4qqwNhZGY5FfvG6LYI1n0lpMd9KObZ4IWvEE1kHg2ofh8IHU/CBzoQ
	 KumQ4PKXKFDiKP7b7QR4VUN3G+7X6wtDGyjLTsag1D2l8xTTfqrhIkqkKuIUtcMlkT
	 yjG7KbW9n8iAzYgFdLhioROxcv8fCBtrFez5xXn8GwebSK6/X4zB9HDO1dR2KnVjCB
	 vO6iAX2jHYTUw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB982C61DB4;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:30 +0800
Subject: [PATCH v2 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-3-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=3250;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cPJ+z22jDdcCM3atcpqaDtz2zW4ZvNzKe4hDfgAQsCE=;
 b=yVbj2v8HH/FoZaiXjkE0G1SM5F9E68EtrLhFxk6egxlIGeT+4fZ0IJPVD9g/sfre3W6ZuzyaO
 qhoBG9o1nzMBvRIH/Nl/0QiyoXI6itIZ8RvOPdhjdo3dIHFQ9qA9Un2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: ere56dc8sb3bxq9pqqm7xg16kywtqu3q
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D744840003
X-HE-Tag: 1787585192-503175
X-HE-Meta: U2FsdGVkX1/cJdgevWHB2vv+y33a05ByK3l6YvSNvqr8Yw7zWpuzNMq7vaw8sL+5VpZbTEbV2EwCb61T2VDpB12EYH6ELrfy2nBaKI4r01bk0O0M14e5/Kytfnnv0zgxRuknlRQxJf8KlqU7MmuU3RfD/1h+A16CWy6gb/Q9OTj9ROhWOVFyFfy/xqwTuna1qFl0ZOyEG6opdcTXLx5SI4y8vk2qcCOw6r9bh6zlhFIPfxZlTSdflGgziJoyNejbqO2GAxbxF+S9SfHXoxMrERpRaRRInyjlJcbmvoT7B4OlmvUZCS82wMVrzvEXGV5vGlivIwvr/AVWez44cAoBAy8XV7IbrbMZUpWaB1OOI/5eoi8X6Qnufx5G6d4iO/iV/S6YaqpJBUf2baM5i2/9AN8K1vsG5R+ZK3EmNFIiMDHiYg93u4MXiJsGh/krxVk2VsgIKqMqIxQUuiI0awdkWq17UrE3yUPcR6V3o6GKxTLoKAHw2boIv5VBQefll9OOtkL7bvyCrcgbNymE+ee81w+DbMAh2AnFiJNf736Q/2MLbw/gt43mqssfgr8I7tawC1ZFudgy76XmeGRkjcL/8+WxiHIc7QDiXnam90KtZBntgwvwfTrrSlQ5hydx9n1OezpUyJZ8m/DwhLuenm0gHR2XfAhs+gM8D2wHz+m/0OX0mIxXhrU5tphi/78zUKmWkmouzFmSQZLptzrfZXXJFsVrH0HB41IkVFvYrLi4YA2/m0w8V7U5EAWfSGQKQ09Q+AEhRsYTr+zGZYAT9+wKA7SHRwJNwRhkWofTF0IgylshfP9dCKhDuePgP/xUMHvsqbm0oYRnQDz9bPZNh7PCN1goL/n36W2YTcemWXs+t8bWBtMJAOZf4PrxALHiPmLbVoHxy+Np/xw1PcSWcc9SeptZdHy/1Lz0nMhupl0vTzWKOU/ALvyYG24YvrGJWzRlZBgFAnkzveZfPWHCM2H
 f+zpPlMI
 U5W6cvl/yIRJF9/QNMB4dpksjMdmVah4b7nVh4ScFxygmWG09Yc/w9ScsQ/rKpLecy+FIxnYiTMqrNEeW/S4iBtLapzzhq+uOwtUhjoN29+nAyPSCFGBWq9OrTJMkzhCjys2QE394DtoTQuFbtDrSEbzMMTa3T+aao2shAXj21lt4RtMpBuPLgqMUOwwbSfTEo2YvudqDF1MmfGDW2Mh32TrwdFCTuhAM8npf/uwdWN4s5XhB3BgNClo0jDU4Tt0dMAe9X4E4yE3YzYBfF4FrDFibXDIJwcVIYmp4TbpB8zvDXOMRdUMOCId/t9duNIl307zvgDsxDiYXAljmpAUvEKMWd1t/BV2aDEMmdDiAP5Dyh3xsH99ZjP3DOZOOXcec3LgQPVdFn9pmUbekGfSRf+yDPDKJ/duEepoX/SRo9iuPRsCdmFCdnOos+kjXM1KPRtQ0mvl4uAl2Boc=
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

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 20 +++++++++++++++-----
 mm/migrate.c              |  6 +++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index edfaf2661812..7f91a89b5ba3 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -365,11 +365,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
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
 
@@ -398,8 +406,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
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
index 15b45832bcfa..96eda490ba43 100644
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
 
-	folio_migrate_refs(newfolio, folio);
+	/* Copy the reference state, including PG_referenced */
+	folio_migrate_lru_refs(newfolio, folio);
+
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.

-- 
2.55.0



