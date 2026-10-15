Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A87BCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE2A6B00AD; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D91D6B00B0; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6006B00AA; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0ED6B00AA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 047634010C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:00 +0000 (UTC)
X-FDA: 85325664522.07.F5E1672
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EF1E540014
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O0c+xTaO;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088159;
	b=k8l4b5JXwRvD1Un8gsHHpRm5r1Pro2txrOrJRow3CafDJsZXObek43l8FIMTou6Tu661tp
	sK1iFNnNPsoaiWZXll7hyN973wIVZSf3tNW1UkNWahhuAhNYMJDAeuh4FQYZJEdkewLnWi
	8fjV/Awg9u5OZcLNk7BtD5CIPPTLFLY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O0c+xTaO;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pWK8Y6xboq2ahXDiisGrc3uftD3QVhYAYx28ZaoZXU=;
	b=QTQjqHzvvsrjQrPck6bUppClmhMnpSU3c2SP3rzbFmzsmpei8IKM6k56dyjm/aZu+20e2T
	yYXz+CyJ/2r2oiBWg6hPccM6iyccIusON3ej+dDSH6PT4F1ugawGtNjEac6cf+ezHgTLfo
	yuCGCyWZ+fiRGFTdTPEP1f4hXl5+E3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE33240A9A;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93E98C4AF48;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=aXanTrv/q1uzORNQ0D7X/HNSQWLDCgGjHvyMIPDoJMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O0c+xTaOezeSAIpT8j/CsXqvpM9BMqBpSJtUVXUk8NK9s390HXMkwjqEQCckxETGq
	 TFbxK366KbU8AmdBLEuVJ8VIPTLQvOxx5bbxpTlPUGzII5KO9UEffCYZ2TrXDuhTu3
	 Myoaf3hCv5wruPYq+iFS7Of07Iv/R3AEtpqgjsKVM834ufUH2vVF55DVQ/Yy9vXYaH
	 N2A8pEWKL3oPgIRgh4pGBRGwTr9KOKs3FPyfistQGo9yvB4QKprmulZv4FbBnhNQ8t
	 jR64YoreNIle3uwxSQ3Foyufx4Dd2EaqkJCRE5N5317FOuXiaaoBjRtoxrnnWYOAy1
	 pfavLGAA+JSwA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BD1CCA464;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:55 +0800
Subject: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out of
 lru_gen_update_size()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=3201;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=R/1YuK+DuWVnDJLZi3UVamo0/HdrkSNNWuBiwaeVr3w=;
 b=2XLndrLsif/WtrelNCXSnsafTuNoASKjH8a8Rr0KhO6jbM9NO93sfCEV4tVmH61jPs7137Vv2
 m5xLqJfCA4/BdxGQmIqtwu86gcbOIJVwUzpuYsoIQ563tkjn20h4A8R
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: n31ujokqwwb7id7zpmhce7uusczazp9y
X-Rspamd-Queue-Id: EF1E540014
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792088158-456498
X-HE-Meta: U2FsdGVkX19B3fss/JUXVoNs/uC65RS7Ql4eew2QSBZiR0c4MhI5pA7wTquz5VyZHDChEFMw5r1dy49bWqbaJQyxXOzFzHV1RmnGxuThUU7fLCUevxG86B5rg5ZWtqoRBvJMuEqCobtkIvBv/z8ha8++A2NL6/eqvHR4rzmMomK5T/g6aQQo40ftz+lAbtHS6i18rVk9p5TUBrY4tTNxT1ynVNQC9pzWsn3qx9y9P7GlRGyGRjDrN5Rn9dvln7YaWOhOjLTkTNvq2u2xDH2OAB83Rilj21ba8aXI2gb7IAxlGzVijMuIHjoj8x3AEEyqMPIJmf3yBQKc+LQuDOJu8Lcj+tVd6Io7zoMkEGDhRERcA+J3scIZWrjY5c8PrkJVSTR56p2WL2M4hgy8/IWAby3i5EMNPVAOGJg2f7kO8hwA6Qrsn6tqTNB5YybmN5aAbkkac3ZqWSghTYSdwvBv6zIcW+bVKZe6gAo38Zk1lUEccMmoAOddBmJI4HUiCMrtfhScgCR3H5tbzZvpIbo2kL+61iE4KHF/tEknUAiUdT0zQWeXrcFEnOFCR2FPk7dQcS3WCpM408lh4Z/so2JyXSihbwYC8L1zoWcVtEjoOiMhwpvOK2ZvVWPvHj/ih1eypK9xB0SLoKbsAi0O4MldtGScMpaFBcEL/DDjp7vZwRVOAV0Kk6gHsIwDoWltAS0Og7EwnaoXA3gyZsrIBc5HHVSz/hZbePCzT7cMJyNYpO18HSp3xR6i/UH0ADMYBCa4yPz1GjIg4kdRlCia4gx4X7l74Uhj6fRqpGjs/5mP6Zeo4qQstJHdPQs6ZOy6k5FpI7cH4wmnhYjT3uiZEdwnVP5wUtpQKlhz3ekRtqT2zMxr+LPgyqTRDwq5LbUu+4g3zazKoCFRbXqK6ROC39izeotK6MPaxGfJ8NuBlz2oSNSUu0NI48+uF58HYXgotshJr6yVQ7jKYkFUMj1AhJ3
 LdcDYVuR
 CRISWhMic/4d1876SUo42TSbrC9Y2pI4JFcRxHd/eLb5F1F79YcYNL0gL4Nw8TdlrpDhLOnvwJsPt8iR3TsYWy2gRI8EnteWC/bqxjwzE0m6PjL1M4aMoftnCaiy/VfH2fAHRUnitOz29TKAtrL0RWHLxjEGjg/funztsQ3TubHPDU5B6t4rIY6XUUFUmjfRQKEBKE3sAor3TANem7sL5SACGiFXd3Bt3VD5uNmI/BdU9xvEB+DST33R6HkwfXM3hCE2sOMhnAyx5U0rCWrp0/pujE87Yl0vRa5cOI7OASYrNNZ3vqEI2MuC1lFOVp+K/OT8BhXFt/HVFt+L0V0qEm+NRYpArBb1l9p87D9F8LmehatybDfYEOMevzAaPcQVC/bYotZqPfA5sC89HJzuehvuFz7qlh7X7IEB5X2AmYUtPst512RoE0h3miTUIuy5KdtYOyKF4HYpMzvimvEjbegloTGkOaJ6RyCEu+0pdvJ78e7gKj8m90ryrXwe4NosEeHx4V+QlvZA0TaHDUZv8CptHjfnIJOgix+IbdNGRYAFQYgg=
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index cfcbe4a9aa85..65415eeac802 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -313,21 +313,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
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
@@ -381,6 +369,8 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -396,6 +386,10 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -409,6 +403,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -422,6 +419,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;

-- 
2.56.0



