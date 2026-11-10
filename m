Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F0760A3824
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cJF4Ilz8
Received: by kanga.kvack.org (Postfix)
	id 8F6C26B05BF; Tue, 10 Nov 2026 15:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD6E6B05C0; Tue, 10 Nov 2026 15:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3F56B05C1; Tue, 10 Nov 2026 15:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52F516B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3102B120A27
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:19 +0000 (UTC)
X-FDA: 85420329078.11.1C00B5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86D1F8000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJF4Ilz8;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342077;
	b=jqVoipOXj6eTgtkVu9kdZlno7v5+EPPojapoERmWmrYMiMLM99/4onAz/gfoOS9G4wx0oN
	E1O5EexpyXB1fPE8A0mCOa79g0bgh1HD9zLmQR+8Po+E9/udXM83jT7tJCei5QpAMVJoRL
	siZrqU2W9yQQs+EsN9LdgZtcjwpkXg4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJF4Ilz8;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OH2cxkpB3Ld+M2g+10ggUTvOmk8yrs6YSxeZbA61Jms=;
	b=Z1JCqadigiDUfQkf3upYUgM4AfrJ13/m81Iog6y+RfNdx0eAmyOnBTLKJK3BQXKPyl0owb
	Jgr7TWf6HhE9gqJy6dek8Hqm0F6GhaqElL/ObfG+YyG/ZBY3ByyxD/mrUtK8+urrCMqah4
	8awqrnAGaBYyz92fbIVvma6aLHD/MHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CED79413B9;
	Tue, 10 Nov 2026 20:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EB81F008A2;
	Tue, 10 Nov 2026 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342076;
	bh=OH2cxkpB3Ld+M2g+10ggUTvOmk8yrs6YSxeZbA61Jms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJF4Ilz8gOTkzfxWbbrdX1udDZ7ZSAs9PQ22EX05xNTfdVoSWtRTaMQVcLPvGitVr
	 a6F3d5eRG8PQg7xCYhQbTihaMBbQ7cTPMtOpFwJRcxmVmvEAJLQYwG/VGZMant2pbE
	 CPVzT0EACkiJBC7D+FXzV4u7tE414RghPXNa/KjQBPiaqogdn7mz0wLBvDdf+ejenV
	 pJCuOZ+OH7zH10mzJ7+/45Q9bStKccnzi930BXcljEalLWlPEZzPZ08TpcPZQXv6Gp
	 ffSfhs8CURSaiFaLxemRtCrr209Bpqg/QfMna56p5/fRojxDrnZs9d+XZdszkUkd4J
	 fQcochjRvXO8Q==
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
Subject: [PATCH v6 08/15] mm/mglru: lift youngest gen protection for higher priority
Date: Wed, 11 Nov 2026 04:20:18 +0800
Message-Id: <20261110202025.25736-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5oo8gpfcu1qfkhk1s3x9ynnejzrhcokz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86D1F8000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342077-354998
X-HE-Meta: U2FsdGVkX1/gUZMg2hSrr9f2whlCcBTu1tAMzoKEd+xUAt0qXYMJvfxzreSgG6tv/y9pcQkLKH3g50xZKg4BfRU1/sP5z+gtgJeaKfTWcupKbafG9qtY6LFeJ4Iudvl6vxDs4PvVEetzm6M1Pt38biVeypkucfJLAmelMnHZ7ZvkIiyUHA+bnRvrg9vXbevHuFHFE9DRu/G7QLmBUYyiCS3kywc2g60FgSRZZ5Ml+Q7hsZnWnmM+6UVhEJkZv7cEeYnBm2aZDdYgw8B4tecSlnbLQZWC9PMmppmQdZoTKAsGORKGz7vG/LTcDr2FhP6PsR001IN8TzOK88H4WOol9Y5aihcbzuTDFGmDJzK69dNe8UxqM1XqrGLHPZikbad+XkflE8yr6hhhAl++8x/KYUCoRaeMv47WlGSo2YThXJldqCBG+m3klnUENNGg+ceVvH2Qz7VIpdTDz0YpA7l0NjmD9EeSHQ7IsEmqPzOmNxdTE6mtYhyLrnyq8u4QLAdqhyGvhTT4xtUxqVrVPG7YbiKtHzLi+lsBqEPuvADMD5NWQWFwi/cu5AQqagiK886TAUfNmZA5/qHBAd2fT5QYJJVpl4LsTn8D3ie6ze2kg5W8nYE2OWAwph807pziFd+cFRf8xyCQXnjTVuAYGN3/dBDdWuZqarIY33LUKTZhybvaplUoQ7ckFJfWD7pOkzGo1BnFLPaKXcjLRyNC29078p4u/dk0tooUMNchTIXrAEeSeGLIsc44ZCMgYjaMdrnmwr2HMMo0YojwIRh1xEbwsAWachmHhXDzJCW2bmqJaDBhIOfqUBk2UdgPR01GjR7BS/6/W7/5eZj3GHGMdIrIW4B2PbuWUgb30H/w+y67BhbqT7qPwXqJaW6Vv/z0ZEymrDeHm3wcbxLI5iBszBe0WANPIEWILv6JfV6SEFFs8A24PYdErfheBUj1lA8QXmJcUuGKDat5FKrpKdCPVcw
 veqemLoW
 zOZI638x+MPxPL0E4yyu66c8+VvabunOCsw368vb4IGC80TfQykMeOEr23h2P6xu/3mXnarO30zSo142nP4AmSqFZiOKSb+pBJCkeY/B+DiILWS11idH79turFMtNIH87/Hhi8Tgtc9NI0ORDVNB1uPHErMTrzN5IySK9epr963B1Dzzji7LTIIpm9aEemW34gMa0naouCoqt9H9FNXFPo/P0Ii4+GHPEyBFZY7mgi5m9eCy4y/uUxQsb60iQikpz9kcd0tqauj3SRRDw0t95X0yJgQuWZaSmoi9LsoOETPG7QLu6A7wVXCyx6FjXX/NVM3BjDuKRMOdn08IjhKjPqmfHpVrv40XKiRIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The forced protection of younger gens is in contradict of the goal of
minimizing the IO cost for reclaim. And under high pressure, MGLRU runs
into premature OOM constantly, where classical LRU never goes OOM.

The problem is when aging can't catch up with reclaimer, reclaimers will
all abort early seeing there is only empty gens, or only two gens left.
Proactive aging won't help eigher because there will be limited threads
doing aging, but there could be unlimited threads doing reclaim, which
is a fundommental limitation of MGLRU. One way to avoid this is to use a
aging lock, like in commit .... However, aging lock caused several
jitter when under huge pressure, and was reported to be causing
obserable lags already on Android.

What's more, the gen model somehow contradicts with the goal of
swappiness, which aim to reduce IO cost instead of following hotness
blindly.

So instead, let's lift the protection based on priority. With default
priority, we still fully respect the MIN_NR_GEN protection. But as the
priority raised, allow it to reclaim younger gens step by step.

OOM is gone, and swappiness is fair after this commit.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6b325fe73436..0731059b169d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4767,12 +4767,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
-- 
2.34.1


