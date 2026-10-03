Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78215CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32076B009F; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02006B00A3; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28F86B00A0; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7333E6B009E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D895F140939
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:23 +0000 (UTC)
X-FDA: 85281310926.02.B32023F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD1624000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpVRXogh;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWcy9aHLhO/C0CtyirfNutIjWwpXi0LZzF8rwtQozlA=;
	b=aku3s6szxzykagCPUC0TllPY92FKy2dut2hak0s7wtKdeWJ9Wj9mkdkEpKRfLCnNdGjJTX
	f0p1N1xMYgSWq9vBnzGyeC6OGOrKuooK5yIfDxobIaez5v8lp239GcvkB7JCnNXx38eIo+
	lsN2EVVHe0kuUvzv2Qg6xcZ86QOyCpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpVRXogh;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=Lg7tDnrJvqmULApCt15U7KUJsSd9HikIHmqd0YsmHLE9df7YQOtBYMOneaBwKCohHiqsLm
	1YS73jsnFUnq7+XLiNw+4HHnF2mf1IzTgeCjV6D1IWnKDIt+tdshIo0Opfv/q9X2M7KlM5
	cCPeP7D1xkCKmr7yljZPtrhYLkMz1IQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 649634484F;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00189C4DDED;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=42V+uITw6MjQQMoMxbIrGu4Hi72bHJMAM4ypuL7oh+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BpVRXoghll8YHkO1SgwzMF4RNF/SU7MygpBo41PLphbYeexcjudDSicznakCvpyFV
	 JxhiuiXTfHYmnMcZKp2ytja6d2rjl+h4OeFxS5ypV9K7iuNGp3yTC0Ru3XTEFO7Ub8
	 yUTipHY11SMkbIRTwIxEAtQ/B2TPwhA8DDJWdw+PInZ0USuk3cdD+piWIFtgqp/Ku4
	 RDr4UJ6SnIPG4Ljrp31TUC90RzUQlTwntgbstBWhs+fplJ+ZWp4n84+wBO+d0Q5dEu
	 NwGNUcUBOinR55+1c6LBAGz+2iW1h2Wzy6B+MNIZYRmDOq3vAeQhLJYnm1PZd2Y6QU
	 ZPkUnZzs5rb0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4BDCA5FDD;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:18 +0800
Subject: [PATCH RFC v3 07/17] mm/mglru, gup: mark folios referenced via a
 fast helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-7-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
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
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=2592;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5AncpLOwflF4jOn/EOaNo3fTgfYKqH470JIgcu/pOiM=;
 b=9gy9gY62fvvWoGoWLviT7CZaEDj9kkpXZ7nsxmG1oOPz/BlJzQ4bruJBxqe988UFTXxGFfLe0
 8U7hvT4TANnCxbHbM7Xc0bOqxGYXddfxVOZQwf6oA+z4YpmpHTkSlNH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: psgeoke9xeqig6wf86nrj7rb6w6y6kme
X-Rspamd-Queue-Id: DD1624000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791032121-189705
X-HE-Meta: U2FsdGVkX18+MH8L+NQae2BSIU0nwQ+C2lTGdQ1VE/Wh8i7CG0VYuf1kz95etg2WpEpw0MypJpo0p+qYvIuZEFh/tfRxITNnGsK3iwrmA2yf3f+zeU+2wq5GOv0SdQVN1kU79z7EIdB4z1djD/mkT++fgw7/2pPpS8cNO98HD94OYUhHMfPbMPL9dXEiLhvEfV3tA0xAYfkU/Jo9ASaGQN9OCm5ktQ3RjThgMcU3pn1a6MC5YCdF/K5XLxhtUe+BAKL21XPu8xeciMzyFqlyzCiCLQRmQ24MtWK5t8kD/7vnK/8sluCel1T7XqNxVTIHDjdIfgrYdBkVC+OiSvMEpZB0Z+xfWiEnQukfUURhmkrWKpOR7BRx8y9zGQRqOEulJtFxil7No1WGEUfyfilo8pojNzGebjSiP5cp7O5WyFLTS5s3mjS1IX7EG2V81CDrg7eGYASLpB4my2pIEw40qv1APxsIMRho8eovbK4pUECyPvC7xwR6G8A9P2UYdtBFTNEsUxsgOulVVnCXXTK9i0T6l7OMqjP8Ch9Ml5Rww5PR1xFlr76Ofgvma9Psq+ucXVZulO/1B6Ys8uXCtWixnKmzTi0rrSy1vx196NVYvgwh8W2N2J4rM++59Kr2NVu4y5hA/F4MPdNkXp1ddQ8c5IdrBSQ5ERLLWMsgH+dvZJq+MP0pdpo4fQnc7qZPNzsN2QR6a/Cjf0OQZLRx1nDfjnaPBcJvPoIwaeNqTMX+FTznT5C+IVDIWkXe1HIDqoGNAddgOCnj1idNWUlhgapNEQbwpXq7ANLmextFqQlP7JO9cngIPoBV0sigyQrM8E2JzAl8vXjxe4YkagtPLClUP/ReDznS6DLoCclHm09q0NBpvtX0mwyy7rMwG8BjkPujyeX4HnVojvzNXsCOlxUHvaD9qAKn0LeOl2jkesMRV/xZ97kS4kC0Q/+sH+giPOd9zGGOPQ/YqACucaWtusG
 oxFwgLKN
 Mm1buVHQFSIeHtAc+TnQEiszfZSS78N+a/JhweGS3TTXzcYuO+VELBdyC6AT4axGj0grMAK8nziOvsaXQKPyG0P7+FJ+ZuSuykgXY/MX+2o7JHygxu9HfSznYgIugY9hb8etDQ87gQf7KZVUiWs56oOGDsLfRyBauQD2XXggEuZ6impYSwUwCImj5ZUHOFoL8WBVv5E1nq6KBSJcaw6MV0QlDdHhZGplJ+u9D/MbUldbLdJC+XlqSWH2C5Yyvz1XmA/NdnlrgslOmQRR6uLLeGNxjGiVq5/9dFej6XHxMrvsh87FyzNsBvXV+2PafXo0Ks+C8VtJDjKyjqiCmnxJgKa4f285KCrAshJwuevCu8LqzqELSBRArboAB/KQplKdw/HDSfY+TK3qoSK7wcpTLNo9ExvzoAoHy5HIRb71AtKeUQsapa4eM1ttSTdF7CIfb64Ab
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update, promotion, and guarteens
no other complex operations in following commits.

Convert the gup fast-path sites. No behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 48a945c2cbaf..cb54913aa184 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -439,6 +439,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 8e9ef5ee7498..87a61c67ce2d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2895,7 +2895,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2964,7 +2964,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3006,7 +3006,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.55.0



