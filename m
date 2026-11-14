Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4FA606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9nbruIj
Received: by kanga.kvack.org (Postfix)
	id 503B46B05E4; Sat, 14 Nov 2026 15:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D4D6B05E5; Sat, 14 Nov 2026 15:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C526B05E6; Sat, 14 Nov 2026 15:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17DB36B05E4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AD22C0420
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:56 +0000 (UTC)
X-FDA: 85434813072.02.54DB485
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED844140002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9nbruIj;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjfLBEmDG/HlAMAHmMcXlPNLi05BAiSWM1z3+JIOepI=;
	b=1ctUgtJbscZ2l0m73BDLHG9FDNtLn1A2W/hxFmH6oGZkbRrlaVFp4YhHcnrU13ggPsrqOS
	tSBbNYH6fwGziDECrpiVpbGmo6B3fWMkvw57mw5ZZo5hVvrL84CcBIs94+Gp6rmyL9raY0
	3EmjBI+yIONkNBltmo1WQ+YeXwIVwqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686935;
	b=P89oHozC8EGURW4BbR3d5oqhaJou7SrmwlEK7Wg39v4NBulYU9Pz5a2ZK/U5zXBeigxMcy
	aLuI8M04Wz5x7tU8nVdfe3FA5FZv2H1WBX17QLgwOh1/uhe6PsYHF9fVzhAHn/VHwdrYlo
	Htr60JJMxvr8/xcbaJ4UmR7i2AKXuFc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9nbruIj;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 506D84237F;
	Sat, 14 Nov 2026 20:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744241F000C9;
	Sat, 14 Nov 2026 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686934;
	bh=GjfLBEmDG/HlAMAHmMcXlPNLi05BAiSWM1z3+JIOepI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9nbruIjrK5XwqkhqWXlVyW8eIabX/Paj7NTP4CJsKnlAikW5kLS+AN2q8eDdU274
	 uyJYJrdQlvFSXOXmTJ/uLAJBmiuQ5d34/525yWZObWb8x8FfWV5vkgPnYkw/8ns/5t
	 MyYs7OLoi5TyVS/4FzsDZflWGuwRGF5wPsFkNpSKyoMnzLnm7CvdeB7uFF802xQzDZ
	 QLjwgGMYHkszR5hR6YRV6vhujxhIjZpydnad6VmPhlIYAHzKuFdEZGZJJRjyHM66Vw
	 cN49qEv9qAmBs3/ybNJu/N7SaYlOQWVlPhCHtyw8jqcCcBGjzpmHYxHDvT8DBfPCyv
	 6emaUeYVjRjjg==
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
Subject: [PATCH v9 08/16] mm/mglru: lift youngest gen protection for higher priority
Date: Sun, 15 Nov 2026 04:07:55 +0800
Message-Id: <20261114200803.23129-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED844140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fbtpzcj39e79dyg5hgi7rwehm7514w9x
X-Rspam-User: 
X-HE-Tag: 1794686934-278912
X-HE-Meta: U2FsdGVkX19+QdkLw2BYVsIT0dLA3jA0A6pcw8qSiNPOQClGxLM+GA9nS0eUvqMsmBkt2E0nehYPvy0KPflLzJYPiaNYzjTGo1v4y6eiis+jpWxrSaixGyWKyyh0q70fRRDzLpJevNYwp9KUcJ3GEVTN7NBHo9Fxb/GA72LaLioIMfF33KzX1yAG52xUJsvW+4oWGPoA6ljBEOvDPyVQbbPmO7fKF0eslmF0jOUn9Z02Frxl7/MddlQlkA2oLadHHe9JFI7IQnc+TAmCko3t6DbObcu1Yw0J+P024iYAfsnQMx8y9lQMGK7cBaAKrYpKNKmDjvtB0p0e1UlC4CvTi6I9afagZNKlgerJSM9HoL79bL+nFeTEH1zBuEd+abjvmJmMITVo3azfhYyKrrzcRFTbXyZzpjXOqEe9t7OawP/hUF0ii9IQSw9bNlWioYVzcGXmtUGXiv0JMgKIk1FwShjYr3zWHsG7iRGSt9DQ5sml1Ei79QQrDpNHOPggiXy+kuOy0xUTUu9qxTb8OtKhbm3R+HJtsCZMllp4AUKcZEKut0jo9Nxc2VrmltNmUI1eGHV5//aqwtD0mWNIQSs5wDnvfMiQnSJ821qCOV4zIFqgCeljNyGALOWm/yaXxc78QYvF1aap5sXt4j1GuPh4JTi2LyWT2U9IGz4hdnkDUghro/CEGI0RIcjis8JlBLDPc6ATewi0BG93NmsAcZZk+sXG4EC3j0sZ+j26gnV4Eq7p7NdgHtfhiIYXyfbM8B5b5QbbzHPCCn3OoinyIxMg87na59R+yAIwQxSrvXrmForEIm4oOSVijNM58PMiS1+iHiMALN/EQB75zb0fQd0eWsACvMKPw6ttf/BdlMz+xTPYKCBD1SuXyPZCe4K6c01/NYKJtkkqxyYusgqc8auPIhLpA+CaEkjr6Zdb7akjisLANScnSujHZI74mOvyj8U1iM6F/5U98eO++CCdUpZ
 lP8H5sQj
 lfNG6ED+tRIDT8/54TKj9yLQaYyhocuE3d4hYkMVR9RHfqerT9JfrdVmknGHibxoXLkXRcSWVUk2pH8aXnBtOK/JjBzGRHOQNttVudd8JBBectQPaQfYkLOZCmDEjZbg4tUVSPGQMbMKpkkzIJtd7YkplH5p8Z9AY16EejABYEzAXq8uOzLbkbTb+JdE0g9s0loU1QRT6Q1A8POF0VdDCCqOxwsyDTN+XPJ9AElOsuOp8hcFQ6FG5GnJC5W52PbNv9YO7oSeb4WAKAt9Cr9S2BOQYufDzYSposNlIUYlriK87EKGNZOpy6j0YuTOtWsF9PdeqrGkVnvT1hcsZk4Qpj89qxf3Xn9uuPOqMFC/pRayWMzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The forced protection of younger generations contradicts the
goal of minimizing the I/O cost of reclaim. Under high memory
pressure, MGLRU can repeatedly trigger premature OOMs, while
the classic LRU does not.
The problem is that aging may fail to keep up with reclaim.
When this happens, reclaimers may all abort prematurely
because they see only empty generations or just two
generations remaining.
Proactive aging does not solve this problem either. The
number of threads performing proactive aging is limited,
while the number of concurrent reclaimers can be much
larger. This is a fundamental limitation of MGLRU. One
possible solution is to use an aging lock. However, the
aging lock introduces significant jitter under heavy memory
pressure and has been reported to cause noticeable lags
on Android.
Furthermore, the generation-based reclaim model can
conflict with the goal of swappiness, which is to minimize
I/O cost rather than blindly follow folio hotness.
The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`,
while reclaimers at the default priority could reclaim only
up to `lrugen->min_seq`.
This patch further refines generation protection based on
reclaim priority. At the default priority, reclaimers can
reclaim generations down to `lrugen->max_seq - MIN_NR_GENS`.
As reclaim priority increases, reclaimers are progressively
allowed to reclaim younger generations.
With this graduated protection, premature OOMs are no
longer observed, while swappiness is also respected.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 18cf1c084e78..b538abf02578 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4772,12 +4772,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
2.39.3 (Apple Git-146)


