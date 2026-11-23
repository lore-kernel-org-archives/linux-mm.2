Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A84F606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=M34GVqTx
Received: by kanga.kvack.org (Postfix)
	id 1DB916B05C7; Mon, 23 Nov 2026 08:52:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B40F6B05C8; Mon, 23 Nov 2026 08:52:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9A86B05C9; Mon, 23 Nov 2026 08:52:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4E886B05C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6842E16089F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:13 +0000 (UTC)
X-FDA: 85466522946.08.707A4A9
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 63B788000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=M34GVqTx;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441931;
	b=yI35GjvHsA4lJ7BcBAu14wImBxTso8N/tBG+7aglJq1hqbAgvj8H+Jk/HgUGLdPc0Stsci
	fYAWETkovoHabxQEKzvg1IN/YnjV9vFw2zJYXyBZMuxqbibrQtYuwHsXLnRO9NVeI2qp21
	+a9BY5tWiLVrDoeXBprA+hxYTbwtG5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3XbpV7aE8lPEF3WjasnioB+LmUiUo8YbJQhUQP3FUk=;
	b=v7iNpuUfT92KkO6LduLzz9Jb/QGqEIRPH5J0NNw+7bIrdkmi4FiFmTlbApBhV9JgubM9Oy
	OtScORB4hS72EobFJFgvaFA1n+p3oadXIxKXoUDzVEIL1TcbTcvF/kWZlWPNlE8M4et69m
	TBITKsBpO6p5LlF7qoNWzBhHoRtzZXM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=M34GVqTx;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso40560135e9.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441930; x=1796046730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t3XbpV7aE8lPEF3WjasnioB+LmUiUo8YbJQhUQP3FUk=;
        b=M34GVqTxjLAnaMHX9VtYE3ay3dcISxtoYRo95iAmwlwohovlDj/u/lvkTDyrlkLlXm
         6BBLvsjsoZkminxhF30iV21e7bz+nURpGAKlnV4P5Z322zlNNb+Fxgv4atpX11DQx1X+
         5W3REqd5JRTqvgW5OEEtm4ZDHfjMWAGAJt40FgWaVU3LvvgyhsVvAPLP2q9Vulh5lH1t
         VPeerpITc+4yJl8A4l7szEypR9dEkBNfjBvh0hnvBbFfRV8FVSbv4/AEuEJWT/HIfGB2
         AHt9ZBAeONDz0osMHBitdKFcpaFqhZ++ltGuPSBfFT6D0JrZG8QcCfBI+S1aqYvfneNF
         uxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441930; x=1796046730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t3XbpV7aE8lPEF3WjasnioB+LmUiUo8YbJQhUQP3FUk=;
        b=jbSPQHUM8nPjK0jzWqquaXGgS8FXUNZz2w549zWZWquW9cs2QqxT4Vh+toeMUrWhbS
         9Vh/X4F2LsSJZRd4cpi00WLY1HBxNsQKNPxbSLS/NA/p1UQzPOd925VHhEonOwW6Y/Ux
         rHq5LKHHH/8baUPkmHpvxhr0K1caDglyq97vltO5m9XmGSjTMYjWxRH8LkWxuCuhzNNi
         4gmylbriNuZdr+PQ/Ui/yAha/Hv//TTcFjcxyV3R6vEtxEHoM/WRJ7JmE2fpTNq2SOw+
         muT3D3bGFd6xJ4rlVqpy5Ub0zQSq5U/b+iCOkA/cZ+LhvROx6rMcizESDVrHvRP7B6dv
         JPCw==
X-Forwarded-Encrypted: i=1; AL+hErHwUR80RnDBTrOoJzA0O9lhcpZzKwCuDO+pHChggPTSOYWbGuxAxzSqQ3xsEMe8/AG8uEcmTYsQcA==@kvack.org
X-Gm-Message-State: APuU4Z+B7P5rQtrN7Kbf08jkDuRxvi5BrXPGE6PSCiXvduO/NVf62nZZ
	G/xZXQYMVruAFfg4xjv3uxV3wTjf61uYsLIK7pjVqwN/aUmbGwTtgMB685YSlB+YpVA=
X-Gm-Gg: AZFdTZdUbWRMcZLhgEJfWKUilf5EjoAnJ+DWlFY/X5u7AFhKP8IUogf0vZ3ppLnry43
	YNc+McHhOw8yg4CM36RbkYIum0DR67u60xqRpn0h3HX3fRQvnAThI6xMcBwJmMVXHS2hENA4Koz
	c43X7T5srm6hG6wgTRVeKiv8/ynJgwUNZEJa7cJH7/xFwTLHLRlf9n9sWm+ZPtc1Hq5URmEBMJG
	jv5QLqkqpu+mm+n1ItrRxT9vYs5ALBUa6/3u5XdmtAKHVH55/7AU5glcxDTOBPDpTDO4k6VRvUn
	SN8MwOxFpPfccJP9j+V/ZIhNd0ltd2SOKSyK9Ki+PNW1ES+PP0q92viEPV8IG2YccbKvrZFlzRC
	ifh+wGrKEB1F6M0AWnh72Ink+HOMg1nDYR2CiWPgG9uV86dQqcVZaw7KXyYl1Hm7sw5/QdUs8Xh
	/b3yf8UhWsJzAovBg3cTUuE6dd+es068aupqXIwNwFEzJ3GodybCw8Iw+Iww3+ZKNcOCshS8hUj
	5IoJqKaPEkbBmUnYSepKuKzjRVhO25gMKQWXounPiX18ufHja0hf/7RqWNVSoxxX1E6/16RBKI2
	Pu4Gk/wsAMZO8w7LBq850pr/6SIYn4drcRsw1od145+LPimGBuj/ncjsOQstG/pzRPS+IjSYX4w
	NSNZZ8urGzuKiE7z9ZSw5o7yBWRCIR9vc0B0hy8eApvX/ORtqZw4=
X-Received: by 2002:a05:600c:64c7:b0:4bb:68c4:2044 with SMTP id 5b1f17b1804b1-4bb887fe725mr225665445e9.11.1795441929971;
        Mon, 23 Nov 2026 05:52:09 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:09 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v4 5/5] mm/mglru: reschedule between memcg reclaim attempts
Date: Mon, 23 Nov 2026 14:52:00 +0100
Message-ID: <20261123135200.4086519-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123135200.4086519-1-max.kellermann@ionos.com>
References: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63B788000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8ahft3e367d77heftux4jzz93zhprjjb
X-HE-Tag: 1795441931-34744
X-HE-Meta: U2FsdGVkX18x3NPOrGXUprJgCjBJFwSbMLs9Z7R/MCIUJWZURPL5t3wrLlV1OxfHL8rSqREXK3GhATBnmg4YUUh1zMCJrDhtI7RbF0Tx//fbI0JJIHgM4o52KgcRwN2GPlY48EK8jyDh0Zl72cL8PL3mF7cAWRUvFxTdVpEXkAQg/+x8K4UbiNfg37hY5ayVqPA1ICdMFCu/h1ZNEIVfj3/At+PXng7OnhoA1A14735CZ/QyqMcnRWAmwmRuyhvxow2jyLKtXE6uRUz0ZskssHJWW1mtFDUc4B95AQuRaC6dG/xvcRe9C89gOWxUuO86eROSSOY5i/cDt4pgv4B/JdOr6Wz6CVMHrmHhlwWRxPPYQxKocFzQ1o3HDMY3zCiEVOPuvtYLKoofI+j916Z65XsFeNL68HJw9OPD0obt3tAbe6HyGRjEEaoBqhdWVH0ZRJSgYEh8BEZGUOW1aXoGDA3fK4rOBDYDUOdvUA/t4TXW93txnJsetLTx/rBqJWFTuM/Lj/qHxzALyFgY/k7VCFUKU5xx0m1eZze/IzYNXjMTHkpIHNcF3mimqTELDmfcBToEchgn/HJ8+KbOOdCUt0AXKR+8Hey+tIDGQkpCvQtmsD8r8cnXjWmIXlxx/P+Fv5AVJ0UztbUxs2hDhszziZAzTgOi54FIhQY5qFXCOHaQmr7pdDrryqc/L+q7BuTdH95lylg54/jzhf5Nlv65ON2SZUeXVwhUL6Mo0uE+KS+vMb20LgP7vaXH+ph9E9n5OzybdLMDvgrfQo5kCrDS6DZXBp4irQkNc3bCHAGqxI8MXdpjfFbPfp1Aeq5lqYKwrqD1tLWfEE8WGj/vT6541tbc+GcsiDeAYTSQ5AEbC9Z5UkwBPjD0Qez0tWUnn5sid3rWyRftpb/3yfaiUiWk2Lh4eRoyGL/4+JuwgDYvBEH34b2p/bP9/52gn+iOtpmHBE4xFrPnvnFUJSTVLQE
 pMS/nQEQ
 tyWdbJFGkGwuFJvUPhthSjeT1WNX0YVjcSjEVCqxY2zq9EXDU+u8HInSXEXZ6lrMfhG8c78xSXIv7u4AuekIwU2ODzC2ZAQSk8YpP/UKgRGrII5FmDRllHQlClhRu+YPUGaKJ8334ladfQfEt8lFF8+6yb5kcOzNlIgEJDAFftWEsQ/A8cegCVG2RaDPKn9Uj7dS1BmdD7gWyoHvznSNrS03TIKHtpp+H2CRvjyvRJ15m1S+Wlh7/CKhmycKko9G9GxaGfxOkRY5JenEOKQwtUktnyWDzcEWvFCmd1elraoeVZwgAJR3sq0B7h6P4vUi8sN6ng3ffOMM1qyjEinAGujdIeGuzy9F6b9rM4OKzsV3kZGe5n8TLngviN9+jrdV1CGoleXDthwcnOgNi0IMTUHZ8cH0MUm8y0Oq+x7kedCTBYh0DwusCRyz7CIi7cCqL5GT3AXfeVAw8FoLH28Q5og97NHaoRM0XfGnv+9kkOjw09Ol7K/nHhTYImz8Cd8+AoEmi28wfKiC/9rt9H/kiV4GGOY/U/oGP1zyfm1GYgP3kXWhnivP3XE9eA4MRKljs3+MYvLVwfPkgVeAZ1vyQUg+OTYrOtZdPktn9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shrink_one() can return immediately for empty or protected memcgs, and
try_to_shrink_lruvec() can break out before reaching its
cond_resched().  A scan through many memcgs can repeatedly rotate
entries without giving other runnable tasks a scheduling opportunity.

Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
does) after shrink_one(), while the memcg reference still pins the
cursor and before reacquiring the RCU read lock.  Also call it between
bins and nulls-marker retries, covering scans that skip every entry.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b9715acf2f22..f8259de7f592 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5403,6 +5403,9 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
 	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
 restart:
+	/* Yield between bins/retries that contain only skipped entries. */
+	cond_resched_tasks_rcu_qs();
+
 	op = 0;
 	memcg = NULL;
 
@@ -5433,6 +5436,14 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		op = shrink_one(lruvec, sc);
 
+		/*
+		 * Empty or protected memcgs can bypass the
+		 * rescheduling points in page reclaim.  The memcg
+		 * reference pins our cursor while we yield outside
+		 * the RCU read-side critical section.
+		 */
+		cond_resched_tasks_rcu_qs();
+
 		rcu_read_lock();
 
 		if (should_abort_scan(lruvec, sc))
-- 
2.53.0


