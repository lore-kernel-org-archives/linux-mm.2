Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B14606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AV7bX8G8
Received: by kanga.kvack.org (Postfix)
	id C76CB6B09E1; Thu, 22 Oct 2026 18:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47776B09E2; Thu, 22 Oct 2026 18:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FAD6B09E3; Thu, 22 Oct 2026 18:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9054D6B09E1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C9C9140232
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:57 +0000 (UTC)
X-FDA: 85351637994.16.F179A90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B72F100004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AV7bX8G8;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xtd1xmqUkU6Igt+6PgHWcxy4mu3ymMXyv97LOgthK8w=;
	b=EnZX+aW7AEJ4teW8KoNkRG0QY6iRD1Dt0MSS7tV7r8Q5zdKblUZSv0t0qaSYRZoSmmQa9p
	YuPuZUmMR04OHwvyTy/JWMK3dtvrSgNgDJh3wUuC8f3EJxUaZ1UrbRCQgJtT2P9v4rxS2X
	dmdgs6crrwefbr6mm1TXg6iXoyBc6Ag=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AV7bX8G8;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706575;
	b=rVYMEWwl3T1dfFT19djAYN4Q1WNEOh+fEONiRfhb5A7IVZR27fm64V39Mw29kocYJtYuOu
	4yCgzjMgz06MhW7ofTjCouM4kahBW5+QgqXggNEgTIsMQmdaCsgRfWi8/BZZzDaIMS0mk/
	SU4oJ/S4mdJjR5ynQrt4AoqQRG7mRVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC66C41FB3;
	Thu, 22 Oct 2026 22:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E071F01828;
	Thu, 22 Oct 2026 22:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706574;
	bh=Xtd1xmqUkU6Igt+6PgHWcxy4mu3ymMXyv97LOgthK8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AV7bX8G8qO+jPFJMCJchpU5Oxq6KakoU5XMJmOIykVfOWwcLLi0QMTeaYuHmBbCfJ
	 28RmdlIdWlJstd8VwovBPzlODL5xzctWu2Z1WRtB9BIFLUCQLvd0wN2ufTIB6Arffc
	 CQeEoi4tttYpx8E0H0h7nHppoBtl2cUW66ffz1f5OqR3eoabvlzt1x6duhwaJc+Df7
	 g9gY9heqnLREMii6/LLfM6xT75pYLYhcUK+hDSk2kblYOTtFFC/y8tGnuJ5FooVC4q
	 MOmmcE9iEkNcMRVDA0whmeFHNTdX4/VBQp6s/UPaefwadSV8aIokbObs4dWYPZO987
	 00HiS1ZDVOv3w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 08/14] mm/mglru: lift youngest gen protection for higher priority
Date: Fri, 23 Oct 2026 06:01:57 +0800
Message-Id: <20261022220203.91911-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B72F100004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ry6b9giq3647es3b5kqc6xe7quhsptmr
X-HE-Tag: 1792706575-153359
X-HE-Meta: U2FsdGVkX18G78zelz2AfMHcOqAUu58I5LRp+r2zrx+bRsEekWzV7NYFhX/VS23CXHLN7fJpkRbQ3fXlP9nU8g64IQFIBFFbQ82nI37SBfKxcl/Y+4ubth0Nm0qiwf+jnqW+HRNxiC7QUzZcY2NM5KXzzdQzNf2BD/ZPOKMhMx9puUsoODmI6OMeK3p9/q7R1U60psx67JwbNiFXR5wtbBh52BS9pvGbCViBhvUkVpt700YLefI8NDEfKAJgrb7tj5vPcsVgIGCZ0Uh9iIGOYc37xLJ3+4c14ADoMAOOvdIxnaEw9pqL5wDYPMcVlv2+2fxCS0bF+WAolTRbkQYp19tdbk+/ano17ZcYZXXyGxfyMron8dVeNIa9+1/jwN+OYU+m5nmc5YZEk4qR24TiQqlPLFiTkxXTkkCe4TtACAFXSk5leAPBMxrqt0ejfdv2I/I3UFeD9+sHZXBDM1JY/nZ4+SxWqpOaaa9YXkzIjZoh53WXcreVgII2oD8PqE+8rJC+WVvjOSB8SWoZqdnWGOG/VmP/vj0iMzfV+LSilGXp8oUlr3zujc3Oyj2yE9js8PvRUnVhBOkpX937UHRw5VwlrgzPZKAnaXP9ouAA8p+wEGd8hNdvHw4Y3fXyBISUcQuC/8K4r+22wTKphTCeKLVK67i+ynlwQxBXGkhUWpYa4iFJxxzC30EeQkWGTtY1QXQRE3lDwwSJKi43EX+HBR3gPajJecndpKMpOWSEYAgtCfokcM3PKqSoKCr2Rycwuj3f7UMbjRd8i6M2rTDdWf8z0VSjB7Utzx3SjP+19EjgLQuifWu5uqhuAI6HkPaSzlMtJwNm2Td8mqt8eY/XysNjjlJY/O8D2pdy1R5VmltTLXzqbfaj4zYjtYx3bk5dWBZU5fSTKgXGF8RLNJx1lL+M6lSOj983YohM/UQ58zM/7KLmnjqTH1nwXfbk7LIEI0eSYqCJGK+mrxnbL1f
 zBwAHAyE
 TksMObVvmlyqVou8Qx+XeiNws/NGW83B+kgR3p+BFUz3yQ9GHoLZuI6rLgJ2tPCW4kyyT5/I7lwL/rdDiMrO0xOztxIb9AaX0POGh07qfYPw24IZfP/m723uoj2eQoWsW5wO/GKCp9NlIhOIlxAi9+Kltzhf6oUwviEyzny1XeQ7X07SVRIWqK17jORQG4euceX57H3oIvuHcDce8NF5w2szBdAtxClIFRTBnShJhylbnb3p7pMnTIAISywvyDWFpIQvEQ8tbNQqZy6+wP0tFLimnrVPvrpzlvNmCK/HIyO7HfSSl0fqTcq5KkY38HbnS2mZ2yx1W7Wqd8G0=
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
swappiness, which aim to reduce IO cost intead of following hotness
blindly.

So instead, let's lift the protection based on priority. With default
priority, we still fully respect the MIN_NR_GEN protection. But as the
priority raised, allow it to reclaim younger gens step by step.

OOM is gone, and swappiness is fair after this commit.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0e37f5c8f355..12aca97be56b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4929,12 +4929,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


