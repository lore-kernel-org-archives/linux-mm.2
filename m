Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4E9CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 00:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083078E0005; Mon, 29 Sep 2025 20:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E9B8E0002; Mon, 29 Sep 2025 20:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FC48E0005; Mon, 29 Sep 2025 20:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFC648E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:44:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60908C0543
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:44:19 +0000 (UTC)
X-FDA: 83944070238.12.46B202C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC28340004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:44:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFgJtw5A;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759193057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HCzBphx38re8+FZndYBdyelQ5jd8zKCpObxmFzyZ3zE=;
	b=fqLYHZ25aRv5x6a0XZodCKMlTXss+QMDeOhc5TJyaITVohJcRbDU4EFgAZqTbhWTVt570c
	1/HhQc5Hw0V02wTRC7E8wl4cxv4j1Fom9GLB0tUxdtT1g9YfZ2yswV0s74Bo1H3Wc6OuG5
	3jjL7qIzk5up0mTP4sPIE4rIgEuSbtU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759193057; a=rsa-sha256;
	cv=none;
	b=q/2xAhpOEy1WDgJpLmEinrIin4uMl8ln0oOizGRExvTUMfDrH22yWxYf1aYvohPIUJV9yZ
	yEyigDYCoaWNyReoTzw663oJ0pmnL/5/nBSbAwFObAUzPp6D5FUJoy95DAUZ8NUPE3zmKi
	yDMhc6zogScz339/BEMAXopiGfVbYPA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFgJtw5A;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7AE9602B2;
	Tue, 30 Sep 2025 00:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7868BC4CEF4;
	Tue, 30 Sep 2025 00:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759193056;
	bh=UG8UCbAm0S/mQH2S995hl54PecX4r3H8TVBvdoOGWy0=;
	h=From:To:Cc:Subject:Date:From;
	b=WFgJtw5ACgIRAyKx3TKKMwbhW2WgSueANdrKKbBKdBndFiq7YY5atdMu2O22g8QN1
	 yu+15Uc2wTr8dJIc8VNZlP5mGQf6Q5zfJO2YWMgfzwZdgYrHg9absTE3yyFSk6iExz
	 j5bRLRcB1/XBqJOaDqwy81kYqxdKW/M0YRCDY2QYVRFAYw02zcyMPigm6BLoyHaVb8
	 BZ29MuEK9lvrWETT4xLxojgvwUWqgJr9r0V13dn3yWY0BOns/PvvyFbJXk0lLkO23U
	 wz0aXjFsmt7nrXiMJCwxlnoBUvWj6bgS4REbPqTpJ67KcRA9C2Z8cCLnSBfRno8VdM
	 zeAbiqY3mfOdA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 5 . x" <stable@vger.kernel.org>,
	Hugh Dickins <hughd@google.com>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xinyu Zheng <zhengxinyu6@huawei.com>
Subject: [PATCH] mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
Date: Mon, 29 Sep 2025 17:44:09 -0700
Message-Id: <20250930004410.55228-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1f4cwp7cqowjz8j63seuoymtfbhq7dfw
X-Rspam-User: 
X-Rspamd-Queue-Id: DC28340004
X-Rspamd-Server: rspam10
X-HE-Tag: 1759193057-49626
X-HE-Meta: U2FsdGVkX1+d56xaMP9H0wLrCeUCptsqm4yF+UKpsX7Wa/GtVuGsqZ9sIZ5QXflSns/2RR6yYN9yzSR5nw3jZHPJdTTrA+kY5wxT4Xn+gVviyJ7BVkLtrOfac5cBu7GK7ypbTOoHXV/Oi8ZsjrM6KqJ34+jrLHeDQJ2nAnKWgRT54foaNKK/APKsf+BNJxWVRi4h+TexmvompnvYt0oViraCR5L9xPc7l5OCVnAUnLxRlgg7EVemdzeoq3GXXRf8dMoI8OVVS1FnBsAN2opnNU7Bw2eD3YhsF0rKJ9w0W6C8zfiDoJT8Uqkqo0lsGuPdcVaONwCw4JNkaGTY5XYpD06gfuB2p5ZmK2O3ihx7g/2nmjR5q/hSYxVZ9fbqxfekIiVrsxc9SdJ9RTp/0s4vgAMOI3+xlqQOuEbaAudI3Eb5CIQOabffnzahmRY1lFLJ3bpG11FOyxscQOa0nJ2eJ1Ip2X3Q/YWVQ9+LiD4ME+C9tdmAzkZD1ByqGMdAo+hZl38NPxAd9oOyHnHbowS6c6jRQod2gGmtTKV0h/ueyIh6ClQv1d5XiQHnGHcXfp+MAXIaO7TzZAN1yyVPk/rFX6qn84ltNVkMY6CcEnygamCn9EGZS1F12oaNrezM61Et15L5u2Px+pKOABzGdG5PqVNQNNJ1TGsAskRx1Tz/PprloIPDuvnuWqw52VO7CVekd5CUf5ugzSoBLgcM4O7ve8VxmT9qDVe7d8DeLGjAEeP7XfoAo5aK82PmFSg/cy673IVRwg6VM2j1JxrOwinU8obEw7YQWBxs/ND5RbGKTFFCeNMX2yKcDktKvR+lwFhdaFMlEbeoMEG3WywJM7mHRorhavDTk/drWxzTNwZECd7qT4BeGqgIVkKZcnE9vEbmZV7kMcnwPac32/S6USEFur8YgDvXsklVDCoqEbZcPC6cO3XKblPTZOHIZ5EYfjMIMDvsGBsJVN+1aU3cGXr
 UN3dhftg
 lHRn1pRtpGKG/6QaQBKMi2aJDh64pRwH01ZuSjeqoCYEEer7SGKC8ukPUblc/kp3uBpQCCp2oJJxAAZgy01AzCF7ovSGuWd6CrApJGPumLlxCn0M0mCiXRaiSRiYlesfX1dB4b1WNh+nSxq04EGiKk9BfdXifo4nckpD1be/CTcr8/QKKKnot3HxOUl/7DSfL3gEgYR680FXppoEs5Fjz7upLMEZI0BQx2el20k+UguT/riSXYEcpOoOzM6OUQXmJiKyV5ITp0ydffmRllkEQAHgRv9Eooh8ltD8a9VrBAwM+fzpIekKlB8pLNVscRULiLC4q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's virtual address space operation set implementation (vaddr) calls
pte_offset_map_lock() inside the page table walk callback function.
This is for reading and writing page table accessed bits.  If
pte_offset_map_lock() fails, it retries by returning the page table walk
callback function with ACTION_AGAIN.

pte_offset_map_lock() can continuously fail if the target is a pmd
migration entry, though.  Hence it could cause an infinite page table
walk if the migration cannot be done until the page table walk is
finished.  This indeed caused a soft lockup when CPU hotplugging and
DAMON were running in parallel.

Avoid the infinite loop by simply not retrying the page table walk.
DAMON is promising only a best-effort accuracy, so missing access to
such pages is no problem.

Reported-by: Xinyu Zheng <zhengxinyu6@huawei.com>
Closes: https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
Fixes: 7780d04046a2 ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails")
Cc: <stable@vger.kernel.org> # 6.5.x
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 8c048f9b129e..7e834467b2d8 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	if (!pte_present(ptep_get(pte)))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -481,10 +479,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;

base-commit: 3169a901e935bc1f2d2eec0171abcf524b7747e4
-- 
2.39.5

