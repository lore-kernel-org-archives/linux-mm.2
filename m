Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40ABACEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8826B0005; Mon,  8 Dec 2025 01:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090696B0007; Mon,  8 Dec 2025 01:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1266B0008; Mon,  8 Dec 2025 01:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAC616B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:00:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69E0DC095D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:00:58 +0000 (UTC)
X-FDA: 84195255396.15.8FD8884
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFDFF80017
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:00:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aR2NDUD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765173656; a=rsa-sha256;
	cv=none;
	b=R23TokDY+Nh4jopgIcGtbco019+LLfs9+2z+uNp7Arwb/BuENEP4DMa8CnlV2R1VVy8A+n
	mDCkL9eG6Cd81dKRlPjzalXkJJUFg/RgEWpIWi2a54QVJEPtXKoWuYiXmYclpuZBmE6ySH
	7IaCE/lk4VlunMPueiWPbxCM0RiNlvw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aR2NDUD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765173656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g7J/YDQQZ73q/SxVb4kAtd4MfgYR+nLwZii4e9V0PbI=;
	b=kKViVqoACaP4zjb6pjifFi3iXBI7Xn+uvkqCNNtYGNn+l6i53wr4+APBL+Ijyr1OeRIPVk
	G9p9XukzgVvmuqz9DPxjYvubEj1aMO7hOGrZMeoTqHYRYnsnlnVH1y+5eWweNRodPCTdf5
	SqPmMM52RPbqd7Gg156NdJIzjVUDERo=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2956d816c10so47713305ad.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765173656; x=1765778456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7J/YDQQZ73q/SxVb4kAtd4MfgYR+nLwZii4e9V0PbI=;
        b=aR2NDUD0XY3ojtM8UR7Kf8Kf3wT2VuHiN7hdlS1lI92mc77yJf6Ar3JQaL/AzPV3Sn
         pyzB5bIWunZYbTHCMO7qQrHVhpCwTjTskj+AJI8Dp+dGLv29RDjRlwY6gldBXMgZ3P+e
         D+IVNlBG+BxqTDWHYAELIF2aInQBG1F6CWtRE7ZWh4K+28ThftAxzwk6goD3ko0NXjVf
         B2I79n/5Wksw2hSRjglrV3niOh80w5MlB47vJ3ot6stgpdzmb/P8e5cpMbo4Kkrm0wvQ
         X53CBjcItjFl2TLERZfESggpOJKh0VTmYC8T0IwsDHCxUHvoQuse9fsaKhl6LfHJQmiV
         cOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765173656; x=1765778456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7J/YDQQZ73q/SxVb4kAtd4MfgYR+nLwZii4e9V0PbI=;
        b=nWjCuH6fZPYNBePnLk1TnvPS0x9I+sS/CxP8mG4RJ/V5t83tJDXCTu8z0KA2PvoGcL
         F0wGWbYLDNcjE1h3jFhnvah2X+SnyOxquem0RzOyeyCJhbtb+daiQgUdueAucPA7imW9
         nz7Z2ohZLCmcNlwvHT3y4w/FOdPjXSaLXju/WjHIqRqcBlYcFOgM1yIBbE3RXFai1fIm
         wbaKechiq3IKW6XT7VPjzxOOyR0866s5cGnQSCJzVRrBp8mQwaQ7h+/ZppZ0HKPcYLkB
         stA8jqfKl6GW9AFcaSkIbpmHVBGMBFYeabhneSQebAJKm+YaqVqIxD4qT35YGAKhHOuk
         s6Tg==
X-Gm-Message-State: AOJu0YzYgWLHUYopbHg3aXkrcR+eaI0Aq3GeXASPDSWt8xOnxZlb+r09
	1ahVTaTC9z0CV4FZYw3oxLx+7frIlNCjhgvyIxFwoIyegVd7jq/MAiGa
X-Gm-Gg: ASbGncv5qtiDVwJcmkCKMjoJd4EW1t6MoPvy7JSYRMbl3Qw4lGPnhjqM0YUjMYPaQ9C
	7ayxCED4ULZuuCmAG9ZG8UQb3KCj1pFIF3nMrEbTc84P3Xm5WwzTGaSiydGpwcErpl5k+jodb+V
	Q2QTUa/Rsf+34k2H6GsQpZ+9awESahnqJR8EXPCuSIKa4MZlvLV97ZK6OO3haKuJJLH3IG7hxdc
	wqJaz8DnGp/IuYXzrbPRmhwzVqlzwQw9wdEZ8lZJXN+bk7gzZxUQqLRjPcxoRXz4VYkOpSORjWU
	a1yj6YLPV9s5JIc0gAuu6T3Kqc7XhU8GSaWJ9nshGyNuSjmgY5CoojF7lTVVYFUofgLzQIusfVy
	oOhww9gATn1Z2DR0CdE65ejyEqTcps9zeCe/dJzJxyhW2tYlbu0JdCiTIaqvCeTYQ6fCJ0KUu/q
	XJMuQqveUxIR07WEBAWniQBW9vJL+Z7XkVxFMo0MWwt2g9/KQyZo3FKgwjrgo+S0c8epc=
X-Google-Smtp-Source: AGHT+IHXIrsIQkPW0r8bo+8VPEAaIOW9AaDvu1kQ2wNp/zv3km50T88Zq0l5Qov4Ovlwt8mRRYGeIw==
X-Received: by 2002:a17:902:e5c2:b0:295:6122:5c42 with SMTP id d9443c01a7336-29df5792c2bmr59443985ad.24.1765173655633;
        Sun, 07 Dec 2025 22:00:55 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:764b:de35:13a7:56dd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4cfcfasm110235295ad.41.2025.12.07.22.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 22:00:55 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+e008db2ac01e282550ee@syzkaller.appspot.com,
	Yu Zhao <yuzhao@google.com>
Subject: [PATCH] mm/workingset: fix crash from corrupted shadow entries in lru_gen
Date: Mon,  8 Dec 2025 11:30:45 +0530
Message-ID: <20251208060046.2933866-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ihdm63dah95qtu51spjxsdaqxfs9jd6n
X-Rspam-User: 
X-Rspamd-Queue-Id: CFDFF80017
X-Rspamd-Server: rspam01
X-HE-Tag: 1765173656-466115
X-HE-Meta: U2FsdGVkX18oSMb57xxcGQeeCnv4iTnpf7tjr7+hX6ZarUZ0x06To5iU1VTeN+rXY+nWTIlfs/EkpWmMkH7BUiih+aMtD6emGb9wOuzoFbhfMe9cTU99sZaUPeu+BPD0dCb8Ki9ypyjl8Y5Mcwzp844mzjw7MQ8qe2PgJ3tdD7mFJw3+dlnxUikuWsSm9F+Ej33Mcnfb0vr/nP8QHXIfnSl2b6JNryqcy7ciD9xYmRBWs9t2P2oCNxdj/bC04bPkk8m9wIg1hta+WKaAmRupXn14rEd1SwyCThBF1/M6UrDssC0MXOys908jkOgd8C57yNOd3FC5KF0cJQ6zyGYoLT1Z+/KFntlQs3bq48HVIy2U8wLO3hfVkilwMYaQRjXPeMvOTdOKT3hVroM7ntxK+oaOwWCe5OZGScfoTbVUV5V2b0vR1OVHSgcbSzNbeS/KsvSZDAw6xFEvBMCLrP296yLLsHRkUfk/r2d/c8yOYz01Cf6LKdNR6hcE9B9oamUt3UMaacaQO+SAsKfxjvwMJfPZ6qhUA10FDTSLNS4Oaew6HMkY0J7pNsTSJYkWCFxLX1m41Xry2mahMRMZxLz8yHwLtSYpA6aDNPLOH8ndEcVW3D0AltZUQEdzkEtZ/oNV10MkhPRVSg2Vaczkw8qGQM4chV800eabzNjW5nVdDy7eWCURWnXxh9KNxCetsaf4Ws84TnUwpRhK78U4ozeZ9Vg8KYT/dt/+fxoV69wVcSo6dI7Hf2a3Jo+9p5CcvO87/H/xeD5EalbNXHhco6PJnJSdUyjke+e4/wi9Cw7NZIVP0h6lIS0Pvs52PhqsZzvEHh7M5hz9aSfDQQ106pg4QsAh+Ozc3rH/nYADyZdHRH6stlU4/B+aJn3Om9VzbcqgrA0tKz4vCtr3+qZ2DB5IfrrosU7TFAtlxru1Rhee/oymWsXHNfcS9dyvd23Zbp4t+miIzxr5jeMDBeSncJg
 moZ1svyh
 V1Omew2JNALshkLPTbmS3Yfc3cq6ytl/sXK1sHuX+7HSsvDzB4fj0+jKz3owJ5sw96ykvGjU3mvTHRevGg3g11Y/meBu6tKtwzN96443tXSw/UiQOu3CrgGA7wSbHwZDBLCRoVaho5jt9aqcj2Q45zfUTMOuUc8TeO0f8tw37x2jff2eYWfVBDs2AiFmBo0J5BblXnlNDvSjWxbA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Syzbot reported crashes in lru_gen_test_recent() and subsequent NULL
pointer dereferences in the page cache code:

  Oops: general protection fault in lru_gen_test_recent+0xfc/0x370
  KASAN: probably user-memory-access in range [0x0000000000004e00-0x0000000000004e07]

And later:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor instruction fetch in kernel mode
  RIP: 0010:0x0
  Call Trace:
   filemap_read_folio+0xc8/0x2a0

Investigation revealed that unpack_shadow() can extract an invalid node ID
from shadow entries, causing NODE_DATA(nid) to return NULL for pgdat. In
the reported case, the shadow value was 0x0000000000000041, which is
suspiciously small and indicates corruption.

When this NULL pgdat is passed to mem_cgroup_lruvec(), it leads to crashes
when dereferencing memcg->nodeinfo. The corrupted state also propagates
through the call chain causing subsequent crashes in page cache code.

The root cause of shadow entry corruption is unclear and may indicate a
deeper issue in xarray management, page cache eviction/refault race
conditions, or memory corruption. However, regardless of the source, the
code should handle corrupted entries defensively.

Fix this by:
1. Checking if pgdat is NULL in lru_gen_test_recent() after unpacking the
   shadow entry, and setting *lruvec to NULL to signal corruption.
2. Adding a NULL check for lruvec in lru_gen_refault() to catch and skip
   processing of corrupted entries before the corruption propagates further.

This prevents the immediate crash while the root cause of shadow corruption
can be investigated separately.

Reported-by: syzbot+e008db2ac01e282550ee@syzkaller.appspot.com
Closes: https://syzkaller.appspot.com/bug?extid=e008db2ac01e282550ee
Fixes: b1a71694fb00c ("mm/mglru: rework refault detection")
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/workingset.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index e9f05634747a..0ec205a1ae92 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -270,7 +270,14 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	struct pglist_data *pgdat;
 
 	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
-
+	/*
+	 * If pgdat is NULL, the shadow entry contains an invalid node ID.
+	 * Set lruvec to NULL so caller can detect and skip processing.
+	 */
+	if (unlikely(!pgdat)) {
+		*lruvec = NULL;
+		return false;
+	}
 	memcg = mem_cgroup_from_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -294,9 +301,8 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	rcu_read_lock();
 
 	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
-	if (lruvec != folio_lruvec(folio))
+	if (!lruvec || lruvec != folio_lruvec(folio))
 		goto unlock;
-
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
 
 	if (!recent)
-- 
2.43.0


