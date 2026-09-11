Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC9CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8703D6B00A1; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C0E6B00A2; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6CC6B00A1; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 134CF6B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 738131A01F1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
X-FDA: 85201300590.26.20E0E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7050018000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DDx/Gj/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127113;
	b=ZVAPbruw+zqOhQW3XMIfNBEal0Bton7hu4ulRTX51jmM284nlwDdwyxRV9tcQkBfwq3SCK
	lqNp3fUcLzmpISfVOINNmsSnyI49x4gdC/4E/l8caZyL6Eq8I/fQvPM/1LkLbAK22LIrzG
	3BMJDnT6C+ew2WJHH7kcaQjXBZKeReM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DDx/Gj/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ST9z8WEsHokutGefY8h3ll89LcjEKDxTtdxy22IX0w=;
	b=S7xnwOhY0yCU4rW0KasXyJbwP1K31uznFdp7IU3fVO4rwqzWrIGKs6oSrOW+ZTCWgrirEr
	Cnyh3CuewqIp7vaxc66aYmIV6bJGna/nttjBrDg3UfbqMT143YJ+Yd57+iPrHj4wLJsABo
	CFKj+5HBnPUqjlm8KYiTUt/rN7tWCi8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B8924481B;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F542C4AF0C;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=ZJOo7deY76UhsFn6arvsRMMDlkiEzUg2v00o2VvyZ2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DDx/Gj/Cl5F5eMuMF+4TILwUuA19BUHAMXv83ffsd51xzgaR/toJkVeFZX5xw3swT
	 iOAI8wCmuRmpI3WWJBPRRD687me2QMhvLGXfGOj0f/0E35Y6j6WO1NyRuG97msI/1u
	 kx4zXeltv4i9W8JBOylSmqvkdigOUWlueTyvMp7fOnOys/+Qvs2hprIapL1/ibAr/1
	 s5TBX5kACMdwbGTZ4V/F2odNbG73203hLVtVdmz4cXbAt9Dvw3N0kC9bR3iE3gbD5r
	 xwNMaLBnfcyPHH/82aSrMbjCeIzF+K+tWiYRqUhw0P3FtgSPHV6UoKqVQLOrfs229V
	 tq2ICqO0+h2aQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C785C88E4C;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:09 +0800
Subject: [PATCH RFC v2 06/15] mm/mglru: move add/del LRU size accounting
 out of lru_gen_update_size()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-6-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=3145;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=B7AzDMJ6t8nkJcGeyGE0me87jhZAEGVPGztsFzfkMfg=;
 b=xxTtaDGa4ISWsL/T1TW0p167TaoyFSfS6uG+HC3qcQDGtO3GQyR2AANtkxwyXOQZhNsnAO/VD
 HpDXsIZHIwvCmmDvoezx5yEL4rqWXvrwg5P2rFInv6Wl+B6YI7hh3g0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7050018000A
X-Stat-Signature: y7d5ujthwo389imgk7jwrgrzq469xxqu
X-HE-Tag: 1789127113-811431
X-HE-Meta: U2FsdGVkX19qWiCFVpA7A6UEHxpw979Wym0Z49DBmBPH2nwS+1w2uS//p+FsvBqX5yebZmvtt3NGnOapB29wuekaPVOrf1y/qwmRp9kY1eFedUrjmHrYE/RCX4d+t6Q9VJUKHOcknXppg06AACT64zgtA8lpkf4b4BSYp7IOprUriMYYP+CLC1PgQE/9LqOKFvpvGxM/sw8Nuf9VetYiZxOYAr0F/kJ2gnmtlDB9pPPzBBKgcWzzybxNn0DVSXOdb+DGilrEbG0yXaVuO6Aw45TELMGXXFWCDhO3ZxgG0mJaB4gyeu5WmdcKTO6k9pzrAbFMTR/8RGTepYa6OPF+rji++rA3NQS25yoyU/y/JRJD4jyaEd4iFtI1eBNfoRj/8zIgOn1OKpGjEyIL6BLpEKWliAiVblQ6nhfFMRK046Nya5vxwIRCv6RNViobdxyzmsCRBrqa/jQXXu5vTZ2iuRZir6RveGBw8HHGH/CDyRojy3xUqgfhK6NbaV6WLNGxOlsKEWP0mju6YoDZwL6QrmkmVDl9IhKHJZqU+xDaZsUJsCn43AhWsIXoMvUEMEWCcpUJu/TTSxKBwzQ+deofENaCflxTklmICoozocs5hK5nG09NlvBsXHwMmsSRKTbxvkarBqYaW5gTsabn9O0r8ot9kjVu0ePQ9xoAZws849FOqhqLoIwck6Zf8/QN3EhKB8d0Xr15+5KgF4zwpUgL0xRO8uuFnSZzf9allB0pr4R+JS7kM0ha37t4uvSPd5R8SlQtMdhxyII+fq4Ns2O+KWxh84DmGvBc6n9OgiiGf6DXsLaBd67QNAVE7HsQE395xSyk67YXYD1SW68UTyDBT6JUPYXNoeLM47ZzqaH5I8qHpZKWYYcHJue9Prc3pz3KxNSsFdG9VO0xC4H2kycPoQaxnp6GPZWRlyMSmxeTGtAYOphwY0N4XW4jQPjyXgzgc1Q2iEXe62k30aGct8L
 jXyow6D3
 P9fLsf0GIuf6L830Or+SUVEm9AnajW8TSpfH3XZnhmM/wME/MPleSP3486PBSmj4D0bpk5TlHL/bmmu9F6yc19pMogKs3SiSLeSJSFf78F/V1yJr9Xy1ZhP+Lkkhf2HeVMQSWYuDZHJjfbEt2+xN7J9cnLQ5plUAmvyGoUCmoZQ+iLdAjP5K7XVGDdW4C2AX3NVt22G3m74Bxb12eYDILEVxoZFeOQl0YE/jNpYYVl/4hHn00NzezWpiS6KeU8+5BuefYLNeVDY6ec5BD/9Oe3+wQG38wffg10GZh6zUGKQTmqAYn4kziLMqdi6QR8bGg96LpMes/f6/uTwjjxKgoz4hGeJ6dkfHau2tPn0fNVlN5KKjKAbfFeSHeD3zawkEcftkZwLHVQr2g/fv7+XOReNViy5yfv6duoK8KaNMV2LQ7vj7tj8SThqqKxpewoh1eDeuXW/i/jcYh5+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.  lru_gen_update_size() now only
updates the per-generation counters plus the promotion move; the
addition and deletion active/inactive accounting move to
lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
and can apply the active-window test directly.

The unevictable case is untouched: unevictable folios never enter
lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
before.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 5a62b83b4168..8700563dade8 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -298,21 +298,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	if (new_gen >= 0)
 		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
-	/* addition */
-	if (old_gen < 0) {
-		if (lru_gen_is_active(lruvec, new_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, delta);
+	/* return now if not a promotion */
+	if (old_gen < 0 || new_gen < 0)
 		return;
-	}
-
-	/* deletion */
-	if (new_gen < 0) {
-		if (lru_gen_is_active(lruvec, old_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, -delta);
-		return;
-	}
 
 	/* promotion */
 	if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruvec, new_gen)) {
@@ -366,6 +354,8 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -381,6 +371,10 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -394,6 +388,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -407,6 +404,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;

-- 
2.55.0



