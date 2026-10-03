Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F18C1CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06106B0098; Sat,  3 Oct 2026 08:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EF36B009B; Sat,  3 Oct 2026 08:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4A06B009D; Sat,  3 Oct 2026 08:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54E0A6B0098
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F7A61209DD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:22 +0000 (UTC)
X-FDA: 85281310884.18.C010176
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3C2D3A0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STOPC0bI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032120;
	b=XLkVCSb6s2XS0BWrfT+2VRhjlCs9gbjRojOBjIdwdtR1OB1FGkJ6afk3SGEZHD+nn9eGfn
	meZ2Jm9srnv4/GRnF0cwfTz3neBv6DUV+uKUmL9XBv8P54eTher3Z+gKxH8jnvquVwwAjd
	Kxi7FMdE1YxcgqgaV/k8FrnH6dnYZtM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STOPC0bI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032120;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Y/1Kd1sydr2k5VtqM3+SOMmFOQrOqHCIdv7DADZ958=;
	b=sWH1p5PRcd6ftYV6JT9/DRXbu/RLUT1PIWtV0YdXr4AKpxpvLnFYANhLRneTkipme2REk2
	BJ7f9yZPoivFu6NUewzbmVm9GxaszRyRWOW1iTVM7qqtSUumRHdf0gDCiGZ7/+fnRdVHHZ
	6fokraool1F9FzwveCStNaGYhZowLPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57C8544849;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDEDAC2BCF4;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=ZRD/kCcVuHZQDqg5mbhpmJKk0TiU6XWkItSIbwi+L9g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=STOPC0bIo8KvfjMj38NAT+6+V4NJMtF2C5eRyGeaNQXEL/3NQwh+Xw0dhShmxzvoE
	 UmDy2yFt+SqdKuEzqDoAEa6TJuUSMTr1KUirT9PLh30RAjI7KsLdMtybhgUovMDwFs
	 sfb0tUODeR2IGdS6QkDOzB+rvoq/eHGPOS2Q4Qe4dCcClotE3sDqboaPs7oRd38s5a
	 G18RnOAcLJ/DucVVFC7Jm1nxuZNU4PVfpytGLYOa70hAgPLz4U0kUb0qMvy57BC56u
	 Wkt3+4DF88jIPBNFTu8AGPqAQr2e/mA49GfZbNb9K3stPZwVUhe43acQ6NCFcY82HY
	 PAjtMkSgLAgZw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96C2CA5FC1;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:17 +0800
Subject: [PATCH RFC v3 06/17] mm/mglru: move add/del LRU size accounting
 out of lru_gen_update_size()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-6-cbd4546a5bd9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=3145;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tydNlIbKPUEe7cYecg10FArqCQ2eP0NAEruvw3Q2wpM=;
 b=29E0XoaWedMYGtUli3qfltJ82WB5gIidfNyKqjhWucGKtVtddDxkcWSajQ6lP4h6eJ1aACRYe
 Q2ORcIkUCnMAxCVNHc9SHpjpX9MwulBiriTjKcijWby2MItha4beY10
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: kph56944pchxurme3xw3cn5jpbo8e7jd
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C2D3A0003
X-HE-Tag: 1791032120-163142
X-HE-Meta: U2FsdGVkX18IWegyrZDuqPiuzAarVH1BO3cc6j9n88ruWtuJdQ8ckdb8u6apH9Vus1o3ApWTPrwgqBinv4JMtNjKQ/4b2E+1rBjIGFfmeZtYQWYq07COP9q21F5O3MqG86nxKzPo/WRmqz1YCMoyItoBUEvug1yiFw4wsz4FFvNzGSRjQtZcUpYOvVaEIv6qX3aAlS6q4mFAzv37zuA8uhQD++UWEM+4j8ut1mQ6EVDTND7C/LZa+r+dbCgg4yAJcMGKfrJRoyaRieOE48HWMQQ3jeMb5+G7RLIMS3bbGrxU9H4eYIYcRjt/TOwzW4YAyOk6HuAsrtqRY1KY2+xH7scXQTj5IRKIQdDfJEobgbzSatlzwzB/NXO0Gq6yEe/vXAxsWRxTlekdvkPGdIoZzCrLdb9hBS6FDJ4a3nnPppRLDkBHsPkISTbkZCtxCt7oGhhKRqpJgO+uQNVowdXRXDHEKKIsngHWz8UfxNI/j3CM3X2u7p8ools4O8BhSwVRn4XXE1Kp61arBd/oL95zRdoOnGzMFOOyarWwk/YgbRWIRJWkiUEPxvxgOFMqJUiIJGJgFoEWvFZYSM6F32rN0d3e9STvqf/2BlB77thGIKzbUBBFVGHOiLCsrUIESBFn510rUuGi5LFDNx9cYxWCwzF07opqc5xVhcHjS4eUPrz+D4Eew5UTqOwrFRDzx97Hxcrr89QVr/+Ny+WGYWiaMfLegnGNIHV5w2OtISuve8tdCQXwWR6SYM10I5GIHJQ/f6NgoIwGU9rGblAeJN4nJgFwkJvmuAYPJDe6ULCwO9Mc4MbDXSiNiqXa27bhVxB7PM4wySSjv/OMJ9sFoupBtK1qY7sLbUB978OTq+bERpaqA/m46XtCzJL/CIDes7zceBiUqvLMPNCXmv5ayYe5zvyp6P+fXZWsIwdx1874wmwLmUK0TK/xmek+PD+aReUOB6P7pa7dtuWAidrkQ1x
 VwUEHTFE
 KCzzyp4S0VNLWKB95HDRF0EhcfYbpEaoXsW1w43ra36C5n8cX/KX3s8FJQK4V73q9mD+OUuqVp4NG1XYb1oVswh7gTw+aRirRPhdQ37FSHBzWzco55+5fZRnePzvUd4kbzLq3RW/MNr1InwgqSrPKlwBP3QyK8H1Ku0JQ8qLMgXCw1TywSy5XmXWXrhH5uiUUSD1V8j1DzktaxK4ohEkeU/4dXDKygLajZATuvuSQjJzxvQP7w3XEjKHYGYBgWUEmZNzWGFev1MsM7sXjDcf5bYYdg+e0YdGnyv9djFu6JmxC+ealdm+hCNrxp9sN1BkMOX1j9oBXTFS6p48H/4JuOvYzwn3qnwHTOBvrVqkk/2Or4Cq+zCswl8sM7CYjfY9HtHybjj2m36mlGHePQl67bBlfJqDtmTGjc2Ul1P8guO/3KmnRSxMpIZfKwFiX43ZGjWzfvWvs53Vhigi02jvIyJ6120ULwx4qUZbN3Bt/u5J+FrpGsj/tub8+pQ==
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
index a3a302e22a47..48a945c2cbaf 100644
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



