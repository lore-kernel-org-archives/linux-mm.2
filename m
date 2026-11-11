Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CED606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QrrK/sCC
Received: by kanga.kvack.org (Postfix)
	id 14CA06B05D8; Wed, 11 Nov 2026 18:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5256B05D9; Wed, 11 Nov 2026 18:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0123B6B05DA; Wed, 11 Nov 2026 18:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D022B6B05D8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B827803FF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:25 +0000 (UTC)
X-FDA: 85424424330.25.40AD5E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF2531A0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QrrK/sCC";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swxfRysumHKmdMmk09THVTvxU/XqkcT5rR3pmvabELc=;
	b=qgspIsR9jOsfNH9NCLyVV9V7rF4ceU/nuFR9K+3WGCmY8jy5iDCy4IpgGJNNZIVO0XKoPn
	rrmtqfR0kxqwLZFl/2MQxOEjDsLGZNtBQmb1nNCGJ9p8SGdRLk+klnxNbNMd/bCKjmrF3k
	ilsJg+oWXio20pt/Vq6MQfeRn4/Bfzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439583;
	b=BmkL86V63/QUxT8KvXnZb9sIbMw3dRjmUCOwnh4V7nk4U/gL4/ENN94leFczBPw56lf6vI
	8xY5p3u6uYWW8u+hMcQjDjFjK/DiRk2ggvZxPCP52EIxa4twJHf15r9uTV1XhD7aWg+YGR
	ve7y3uG2Z26Udm1tsNawmKVIrcEkXKk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QrrK/sCC";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE89C411D2;
	Wed, 11 Nov 2026 23:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBC91F00A0A;
	Wed, 11 Nov 2026 23:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439582;
	bh=swxfRysumHKmdMmk09THVTvxU/XqkcT5rR3pmvabELc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrrK/sCCLjOIgmdgePgUyqMNRU1+qQAirKV+BoaR4zRuyKe2T4loL8LfpRU+lTwt8
	 lxBdSpuag6vPrgQUL6L9tinExL7Y4E+OY9E6jm/t9hfir7LUmLPviG1itn049cvys+
	 zIOZNd29LRWfxH6hFMGDx3eKzaS01Hi57sx5UyEeb/I5XxUCUr4TlWlBZQJkTCvYvm
	 XGXToKpzEHSZbmD7QRwpR1S7EGUKwJjmPONr+1U261ypvoM0xEvCTQlWuaEFycUlTW
	 P6r+0yalyvLYqkWLWX4Kw7I2hohrjIDq0FhyDf6wcXD/aOuJXYMm4FDNx5nOMqNd6H
	 XtKiqyEGsoEBQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
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
	linux-mm@kvack.org,
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
Subject: [PATCH v7 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
Date: Thu, 12 Nov 2026 07:25:49 +0800
Message-Id: <20261111232603.9934-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: s134gtxehpmk31kdop6ygr39zgmaigq4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BF2531A0007
X-Rspam-User: 
X-HE-Tag: 1794439583-315068
X-HE-Meta: U2FsdGVkX18MVMoOcqzr+xJxqc/dRr8P6flz39fEaqitS2KbL5229a1FKSWjEkh6juYY/AZNuXJb5WgO1DzMgHVMk+8UK0VSMm29MI/2e2vuzlrB6OE5IXUyeFIrQNIyjtcKQjxpPh6wI+IGj0JrTqWSxmCwgYxVxhXlZ2FQ6qS6KYw2DObCKerNP4+NykSt4Ixv2AQ+6WeEM4p4Ca8I1Wp+bPJ+VLYLowH2l54oTbiQEXjRJLA2Yq4q8DLDIZpkdIu14xbI0A4qtqMxs0jFzvhvafdJliRUzQbVLNZAX2MjoSFAKcoWHqZifCGtbui116Ubcb8yCCjJAvrjwcNdZdKqnZCiBlDcW0P9qKdhxc8ADoi1mG3WTJemfB7j0JoSXVBkHuJlxVYTo/EA6emMartvqtfAfC7zc8NUK49yO+YGXhB35OhJbAfF0ol6JNvG7ftnAFnWARTRMWOmphnNO4aJK/g034WCcvqSuMjEKqsZEqwjxsdIwHUgKbPvYHATp+Y7hBVns8owObKkV0lWWMWbuzm5Oo/s48w7L+jGSWBT86A1wUJeXgC1UM5zRdaxmMIg3o6y5vTu3eBnpgG+tZG/IlSCAdgAM+c0xYwm4JRiNWqDh0euDJpehTl11r8Fda0WmBcVj8UXg3k2AHD00e8ofjHGk+ez/XzTFCT5N+4b6H0S6xazzMFwOg9TOiOaPsEdTIgZBs1GXmuE3v4pZ7/zvkZbJws93UlfpO0djhFeUyugdLC49XqtJ4kcs7bcZjjXNylBmCMBGyBqjW2sRaJ2G5mVXYLj4Ll6bJ99KI6k1RmfVabyPXtQGEGAeUt5OiuNvnYu1qkZHSKLAb5ZqjJpwygQxpVzFnKc11ZbTjO26QpW2+svBmNp1/s2BH3bSY1klLr2kb42zPAmCtfTKp2WrJmttsvjoB3C94sw6x4JTv0I+ezNhGVjsZ3ixWmNNOpq5gJ4FvxEt/tUhtD
 VFB1Gdts
 XO/rEWcPYmUbfeIiY9fUg0RsfjsBFwcxqrxJE4S5TTGg2TTPsRz+HfBOT3JWnliuo0hGiYDmIQNG5abXOC/XBsHdCYpa4Q2r3qQuGDk2q73X0+b/scwVMxiMT2N5TG23YJPMdJijPMzbyL0nImQ3kHc3G68Lr0A2SvIa1qU/ZxxksXNBEX4ZE0UcLe6IlrPiZjrcT+4T0rf+0760GnYM1xIIrrpyw0YkqRcLiy11XTOXBFxJDbHV5rDSoJFzHVZyc+eZozgWqJ0QYnOpGk6sI5PBpe/SfbB8TI35XM9NIbeo+3XjTaNX0lTROFy0XHucjwtmdjUKr5Zw7G5fNbQmtEfEIHCbf9ZhBlX8BgOluK/OIHASxyuT7JwjmgPRikWJaqO1UgN2GS/KhkSxFq4BaafwYoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The search for the oldest populated generation of a type, previously
embedded in try_to_inc_min_seq(), is extracted into the new
lruvec_populated_min_seq() helper. It returns the oldest populated seq
of a given type, bounded by the given max_seq so the search never goes
beyond it.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index acc4efccda2f..4ac80968e634 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3991,30 +3991,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	return true;
 }
 
+/* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
+static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
+					      unsigned long max_seq)
+{
+	int gen, zone;
+	unsigned long min_seq;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	lockdep_assert_held(&lruvec->lru_lock);
+
+	min_seq = READ_ONCE(lrugen->min_seq[type]);
+	while (min_seq <= max_seq) {
+		gen = lru_gen_from_seq(min_seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			if (!list_empty(&lrugen->folios[gen][type][zone]))
+				return min_seq;
+		}
+		min_seq++;
+	}
+
+	return max_seq;
+}
+
 static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
+	unsigned long seq;
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
-	/* find the oldest populated generation */
+	/* Requires at least MIN_NR_GENS gens for basic functionality */
+	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		while (min_seq[type] + MIN_NR_GENS <= lrugen->max_seq) {
-			gen = lru_gen_from_seq(min_seq[type]);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-				if (!list_empty(&lrugen->folios[gen][type][zone]))
-					goto next;
-			}
-
-			min_seq[type]++;
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
-		}
-next:
-		;
 	}
 
 	/*
-- 
2.34.1


