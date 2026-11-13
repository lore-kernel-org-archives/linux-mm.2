Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9CE60A263B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dgFw4HCZ
Received: by kanga.kvack.org (Postfix)
	id F20FF6B05B7; Fri, 13 Nov 2026 13:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1586B05B8; Fri, 13 Nov 2026 13:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07FF6B05BA; Fri, 13 Nov 2026 13:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B634C6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A38B16020B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:01 +0000 (UTC)
X-FDA: 85431000522.26.20D03DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DB2F1C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:55:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgFw4HCZ;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNYIb67MUpeEJ0PFi1nZbo5wGpgGw6DkZELvIC4TsPQ=;
	b=BYCRshIiU3QoKggdD048POlwG4pEEwPbnUce97foqWkO1728Q/OOc47diTE2zAYn+I1Kac
	pK9DOLqkQk3sL9ujepc4EtPji7xGlGjgqUPkbl9fmJCRAskK3YCMnq5WvtLZLttB16gTiN
	25L9qHbPyesoyVKpL4R5mM8YOos/ekY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596159;
	b=lE+BcYpqc7+AMOyK1NUT6+7DOKKnOyudUrKZsYOozPQiTP2MGHASIpVsaCyII/cN0Zm2GS
	rjRpH08sr7BG4fKVci7d9EPX5Q0JVq1jIV14RpOMj7IX+HE65CJmJzxp9LKGb7sBwo88bM
	ZA034V2Bj2R4WK1I2SRi4qcK7CnTTmU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgFw4HCZ;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3645363295;
	Fri, 13 Nov 2026 18:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B77D1F000C9;
	Fri, 13 Nov 2026 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596158;
	bh=PNYIb67MUpeEJ0PFi1nZbo5wGpgGw6DkZELvIC4TsPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgFw4HCZ4fsJyhyLhfylPMBXNgtxSzrqNk1UfRBwwxQlAzlE4OxkmGxnjN9s2Xtqz
	 IQ9jLD3rppf7Kfao8rT3oLpRHRJh4ZwuNi2FKD6k/GFC+C6ZgzELFx4dTcavDvNqrL
	 7WdwCBT7EL7S/UcJUbiVQ3BAoE6u6Qn2qvkzUvxiRuazNF4MJ5AKlo60OHbNfsHdqa
	 xO8lxPdtqaLUKPKHKxPFa3Ov/upx8p7gXj7ACrRRznbuLKbg4UuWfZ8fIgIwu8w+4n
	 LFtQdkCl2yNCoiC0/jne37467DSSUwTk9ud3zXNNSjtGNRamJKUP3E2/2MHFMV0mUK
	 fMOvQFY12GWxQ==
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
Subject: [PATCH v8 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
Date: Sat, 14 Nov 2026 02:55:27 +0800
Message-Id: <20261113185541.70203-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: bui65zxik3uek6ht5ug39t33wqh11sqx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9DB2F1C0004
X-Rspam-User: 
X-HE-Tag: 1794596159-969178
X-HE-Meta: U2FsdGVkX19lTQrFSyslk+UlXj2GsmT7QfyULpCuuQWwVcROiRSN1/Xh5HNbkYH9BQplshmVMyzOXuHgMa3HyvsfGzpbU7voFgdfMIWYXY0Fz7dClP68aXqEEffWNClpYrzPJDONMgStqPS5LvlHpsJPkpqNSYM0wfBX0pRrh4ig+vS65Ga0TQYJA4No4kd+M+Coz5n311P239Is9pMekMZnjS7913UqnmsFC47hgZ9E0WXhiemLPy1bx4DYajw7qhziFykV6UJ4TMiX8cCxsUjwjZFVRa9XPeScoTC/untk1UjWU05hN5ceXRM1efcKZk1sUEIwbcZtRbUWrFsr3YniphH13pxFP9gGAnlAlgRTrYUP5QKJQxAtvNc/5vkDC2l00Be8o6YBjx6Om2IV/OqMn9OiKX8HinaWMofO9FKkA3L/uhyK8G5G12SmXT33QAtSGlazphtLxIcZN0268JmzufOdOPLSWysQp2X05WaPM34Gs/lrc2pTdWNJuR40Q8RKa0na9KD68+KC770EnZ9LXqsLKuJ1JC1cp5qil7bQ5KoQWIqcE+X/xT4mcqQUWrcOAlTWFxwBJh3+VC1E1Pk7dQYedO+MOfgooPMOqNDLEIPPWJ8g1QyocPjegAqj2/NMggSaEZESuNmtQDVFZM9YAh2HJ27oNcVXTJQGCFB7u1lmy3Ut8MPdM9sPCUOTqQc2ciL0XiXXiUYZBP0EQiSnVpKamXRO2DiqN8jmjL5aPqJukAUZMQMs9ITVTJsQmb0foOa9J6dLBNQQar7DsHAS8eWIBtOtxCS/zs+/cvJJZcMFdi4VcWlXrDZso7OnLJvooIDqFW22VBCcu3pZCOQXGNTl6b6231NI7l3LxImdZeG5f9haDjl9F4FWgJ8+ALCm6MzwqYbYJLNVLi6LUK+S2q8K39I9dvBNDpqcBuBdC2TNqBzpCL90WrdCZVzpk40zrQs5Pk2cVHkRFNt
 V8swB03N
 LYh08GZwWaWJhjSKRJy+TlXii1B4DLwm3Wknq7LK/wKv6Zjem6NDU4OYsUus+pZZ8oOjvGwwRpd6D9dhm1mkT+0i88vi6kS55AChbosXV15FEptnQW+cxsA5HZFTUlwce1YzZFoZmDeFwf0fkPCTdab7wMznW9go16IIwgDjZthYbQuw7oYFxC8U5d1WdGsWqoRRStyfLhYOWMketo9pY13Q1D5v2Bn1FEWASyXZi2AQYnYw/d2vk09515QG1XXOxDLBQkus4XszA6In7HKhQo7sHO+FbVTetEcLhtUYAb++DbPScs+q4LFefYsI4Lr68dEt4RI7s5ZBGo67KA2QYInUCi192khhUm7+TzVPpUCWwcHa8riwgj7BsjQoELMwF2AOJ/dFuKfcoNrlqntbih2tpkg==
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
 mm/vmscan.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 400f87fc51e1..27dfbd3ff02b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3992,30 +3992,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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
@@ -4027,8 +4042,6 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
 		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
 			min_seq[LRU_GEN_ANON] = seq;
 		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
-- 
2.39.3 (Apple Git-146)


