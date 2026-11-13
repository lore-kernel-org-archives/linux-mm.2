Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C333B606A89B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hSsQEHar
Received: by kanga.kvack.org (Postfix)
	id 705B26B05CE; Fri, 13 Nov 2026 13:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4BB6B05CF; Fri, 13 Nov 2026 13:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A61E6B05D1; Fri, 13 Nov 2026 13:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3500D6B05CE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8D77A0257
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:02 +0000 (UTC)
X-FDA: 85431003084.25.25626EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07C6E180009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSsQEHar;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5jCGWK0mMVJUZnlxb/Lm2+++2Og+50SQZcmUWnLKIY=;
	b=r4AKiI6mcGzHWs13f2I5bY64DN6Q3cDWFozfmRmmlY3y8W/p9ItHu9nX1jm0PFEjgmn0Fm
	hymMknFDD+ayipDxxJInrPWgkpymqn8JkGARr+39mPrLUkA7KyCvt1doninc9MG06KH08z
	yddl9DjMRUo48vjf0K3HtVPmglFdZ8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596221;
	b=dMttkla3axpgbQKWe1oCmzHwuO+E3dlnWcVaY/lPsAKHYAxN0AxU3DWSCn9SdEX4dVoCZW
	Ki70Spy8JvypZfhKUqgD08aC+hXaXmdmH54US6jqCg84gYMTZdAIsVODfzPW3ABUF+nHGU
	Fc0+4MEbjGFI5CJVKLBtb/m4rIvbI+I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSsQEHar;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A6E54631C;
	Fri, 13 Nov 2026 18:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A91F000C4;
	Fri, 13 Nov 2026 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596220;
	bh=S5jCGWK0mMVJUZnlxb/Lm2+++2Og+50SQZcmUWnLKIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSsQEHarvAkvCU45KeaGeDjcWDMOqt3OZAJvXxoHb+LNXMMCikLCUgF7KeB4Hmmu/
	 fINAm+gwafUcWqYxD60C6gieAY5asMO/WHIqwagOJDD0sYpoDNnob1E9WnJ9d9eAwK
	 opug0lrdGWffL8JQoJSwWKWmCG9kCZx4u0FJ++6jLCQijP/Ry09OAkC1dwK01sArTW
	 JSVXVtA8Hu2P5U+MShtJFIU/zi4NJXZR/JYEJqN+PcNgTV7YzWVOq3w0A0TGMzT+D0
	 Q3GIub7JiUzQo7LBQhjZU9Y4PobLZ/6uKAHSPgHV32FgbCursDerf93GyW1zFOJKgM
	 t3HUS1ujSx6KQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v8 14/16] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
Date: Sat, 14 Nov 2026 02:55:39 +0800
Message-Id: <20261113185541.70203-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i3to1koyc8fko81jjkd6rxhujc5ayqpg
X-Rspamd-Queue-Id: 07C6E180009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596220-362513
X-HE-Meta: U2FsdGVkX1+xE9df0ipQMnvqFF3FxHaXYHAKDdOO2fDs9Ufg3lYeERF2S2Pgsp8v9t8kqvckjaHWoIJPkNQuupTShdd51L1T4/kAESXZ/7xvzGODVDQJf+z/8T+HxL2RXLtSY7mR4LGQSgzwz1/SM1YGvhnX9XCxL1Vo2OfZBmG5mObHtn+LQjf4eLf1Ck/XV2PkuogqAiYgraLAETwKC1wtbn+1Tp06dbiZcwtBHE0AFfbCLZwQn5SkSv725t8DfUu01ztKF2XFtUbq9m9uW4dXMYzYepv7LYRZBruRjgzp/jA9grN8zP6jxCJdpPXMh7pJjiQZXL47AZfgLVikoJ7gycWw0Q1MALy1GTP+vp6kMML6zG+CtPHQVWQZqIJYSmMrLPBc9/moYj4p3sx9gCiB10/SgN0fYjC2bVnK0ZbK65TFHJZtizZuvxE7pUPhaz8L6KfhzorjZzQQjZ/w4G/r4hgBs+cvDBLWKt3WM3NXqdK1VNEav21/+mdcgDuxuN0mYkoOXK3G0BVvqewYmODbhNh0rQJx8UpCREn19qxgvdmxDKe+RzyyUDyn4BpvM0wBJ2XDVdH99NEERlRVjyLE9AZ0hcGn96uVXMzVoEi+aQrlHTLINyLEn5OxfZCTfdmWxXYG01UPQJTseTfhKAzX7krvkq43P5EhDQFNN6BKOegiSxgzxaGdq05aV3FGQO6lEtr8PEeYUtjW0zBlwae6JDK17Yq52+B/Een+9CS3RFvpRtpIlne2/x4ZF1rhpPpFsclTZsrTA+pJJGBJYf7YkOrjZqlMIC597U5cfd6hg5VLxC8mXEEMwmBWH8NJb5PoUflPxacOYbW6SQAauDmOUDUmD2n3laSRHvLr6UrBuGRZM09g1MBYqkNemtfokCBWIJ2FzjSXRQIp4OjqMFlrWwuHI45N66vA6aWmd0mr7pgYJryOiyBSzA3UAyp2z5gCg38bLGDS28ZgKs+
 rqYmi10s
 YvwfrlhdR2ol0cPpBnDsW7wNMVuTX9zOrdOplbieE5cWF+4tRaSgMu2tHNOWtOD3Y8EtTU75pGNXTo4WlTTFk3sfKwSw1dlaxtGohpq53let12SttjdVRmcI0igsKf6vM1BbfpRzh7hYD8I2pjzt8sn7ce8GWaHR+xJLMqyVi6qwZJ6VZ41mqCgDMNJhsGQbzWUXdc3DinE8be2AssW4HcP/1mEalWpJgk1FsANNr85oTRcIZY+ApHcWIbQ6NzMTU2tsPKADpcLpzMfIkH4hiqGGGAuTJmxWwNekZ6upgyf5w2cG+87Dhi9+ACEdKgGRrt/fbIk1uO19ZIn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gaofei Lyu <lyugaofei@xiaomi.com>

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2595f3fbe1b6..b1a36dae6da6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4899,8 +4899,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
  * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
  * cancel the scan budget natually.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -4957,7 +4957,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5154,7 +5159,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5914,7 +5919,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 			return 0;
 
 		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
-- 
2.39.3 (Apple Git-146)


