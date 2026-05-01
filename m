Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8459DCD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08826B00A2; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F816B00A1; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DAD6B00A7; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0DF6B00A2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F32A1A02AF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
X-FDA: 84720079038.21.F74780F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F031D100003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BE+GeB87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rq3k2XTdg6cImabKQKEuI9IyD8Cz5SatAtQ//YItQZs=;
	b=rrMU4HAtqi2VvoqY4YBvSQyJhF0hO4HEfsCqTJmmP9gi9RWF2gXp+zP+EtjX2uauqlspLj
	q6I+xXen5L0TcTkVyv3QFlresXB6tjC8A832jBRlNLl09K2ZMqqHc0TL+FJckRKe1iU2wJ
	9dmCDceMqBOys0AFzIxh1k7Hgs9Dc6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669457; a=rsa-sha256;
	cv=none;
	b=6JeZ0dd8CehQJ8I7TxHMciDV47R3p54vVw46cJpMC/BVhApyV4s0Pi4Q9LqkvWSZ+drIwn
	Lldej6hJY8CHC/IpWRCNsTxmhCRbPoJkwE14EQnHVMhE2Ggp5qfeZDsX+dfKQeg9PV6PW+
	JmFUviq7TawYpcvy8y6PZhtsw7E2oBc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BE+GeB87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFA01446C5;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB408C2BCB8;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=Fz1qR5iuVNG5vOBxWH0sEBLOHYRtiFoBzzSrTgox+z0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BE+GeB87tufb+uHZvkRCAVG8CivOBSoMa+3eAcx34P5M6XspGI3INJkn6PLa/SDHe
	 swrCgxxleaV3B/fQXrKH0nGbeJ6n9wboggkX7nAShmnNlSXQo+d32mpCirntzpgjcn
	 uRimT6GAQp6wY0VclAb0dzIa2yeaVY7RjnBOtDv1ZxOiZc8mKr2Q/6nDmqrZDd3XOm
	 VFoYYFBZt+8y+qcAAJctH8Uv+kzb/YWxOqTR+7ddMzgVQorjLUwMY+zKu9LBILgLQH
	 nZexJYJE1gl6v9mzA5cUEwoXKxw49QegF/daMfDIOsWRWhBkTnVTWqki//1rFDH2Mg
	 10rn0Rk1auBJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A32CD3425;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:57 +0800
Subject: [PATCH RFC 11/32] mm/smap: report workingset folios as referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-11-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=2528;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bAs41qLSTJXf0JYRd4i0pQir7expLyGkScY1vBkRC/o=;
 b=P/ANv6ue43Q6QQ4noPOswZ0RUbI8N/S5PXWVt7oIEUIJ76Te+R11GKtYDMIKwrJ7cy95eHrZz
 xhljUlaTrpYApGqZAapScC6xKAxGJukXEyEYE+cWzQ3vic4cOQSp0Lf
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F031D100003
X-Stat-Signature: nqqdcz3yxpfjupy54gz9nrxh5mtd15u1
X-Rspam-User: 
X-HE-Tag: 1777669456-243666
X-HE-Meta: U2FsdGVkX19reqI9X3J1DP8BBN4tQAwiCZd97r7zEthXu6pixRd5mmExH0f4aBbfrUcdLY41Cgm/ZfleziFsRh7oWKcUFTNIyWE3WSEYzfKEwfyczU8F5aYvMyMhoxyjzo7MLegnAZ6oti/00REvu7QBWkjQ6lu7Xfgt+MIs7flIpL9Qe3smQzQV69VOiXoOgia0ri0DvWUxWxeZZKjtu0sUly4bAQI8msdMgUXQN0lOQz4opr/ZxzxFDy/HAnGCGqgFW66Wrc8jLlOdUKIZleKDRev4CGg6/CspUxF7QJNTHvQZlMTSiMRs816mtCVeAIlE+nO0tSevGMV2WFVzHggR78RPXKEClVMYBz2CDXKG24aG6rLkBELoQWlCkApLAPb7zVLn2qI8YzL5069Xn0cUsRSsTri+qC9dOoZ0n3f0FxVEF1XD3bzia1Cx6qyxf46YXnh96oVMLe1KrUDlqJqs3BMFcLQRPGT1HawMzbatHFJZJijkjWBdlUWHguZ+YHyrhDQYvlgRtPSN/PuTwi0Vtmn0O+eTJwxcTW34u8u8o1rWothGXmFOp+lQif1XDEix1qA9Z+NLDvZXvyGO8IVXsFnG0Pf51+babIS0TiUG3/TpckSoO+VvTWAwQp43XhvxyRgtZkqpnuk8gasCdnA8/GXR5pApzpouYq8OnzuAFgFfCvS/im4XIxC1/6n7zZJFePLJWy/rPHy6GWesLEsVXNGclvtT0a8keWJ9fRYgWzBwuZCDbeiBGYwuJxZsw/aZUO0kmSgqIJsJF//IwcQvdL6QZPbtWEHBQkXnrUNrJ1v0KwcHpvAxvF1UYUBc2DS89sd4v7t0DW0A5mKxRSu81JsVF9k6U72ELfgVAV5wjqXs9ySiK8FyYgEyKozI2aASx2jnmRpgbofsmoSwf4n6pKQqhKXKreXt+WzJPNtJ5UKdQ8X1FncgKc+FO/oPonkSFf1F8hMKckxKt9i
 KpP8ZQja
 X5oI2LS57T/LBMR3kBL193Db+psl2gSgbKjd0lFl8D0fvl3NZi5gem12hdRVxET4AJi0No7WKwzysBpWfH7hmjQE+kafwA2n/gaJGMJNdNXegzjk4WPwXikgFfC7RIq7VCAUfszwuOvc+aeq5cV9fUlQHhgBc4UBfgKJbElfkRN0ActtOCe9ab7aXS+9nEtFw9ljVYK5G8wFvMhpOQKmUt4XhMZQRNKHRNw7DfeFj+0hRa9XE0um/rFJAvSQT97bh1DSKIpMo1MXXtoG6bED+7RiiiXAkdc6LXzaCdgXGL5Sng1rjgRYk9jiMq5eOqyVrdUxdFgNXWdK8kP4s8HBh9Vr8ERIjwV7CTMy1pQ0qJ7ddE6fLxwI3fm8drw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, switch smap to use the folio refs count API so smap will
report all folio with referenced count >= 1 as "Referenced". Current
smap checking PG_referenced is causing folios to flick between
referenced and not-reference status, because for both MGLRU and
active/inactive LRU, PG_referenced may got cleared on second access.
(Increase of LRU referenced times count for MGLRU, and movig to active
list active/inactive all clears that bit).

After this, we will have a more reliable and useful reading for MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751b9ba160fb..617f457c75bb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -913,6 +913,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_is_referenced(folio);
+	else
+		return folio_is_referenced_by_bit(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced_by_bit(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -939,7 +955,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1701,7 +1717,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1730,7 +1746,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();

-- 
2.54.0



