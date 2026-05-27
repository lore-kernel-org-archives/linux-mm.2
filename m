Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB95CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9AE6B0005; Wed, 27 May 2026 04:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A976B008A; Wed, 27 May 2026 04:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B893D6B008C; Wed, 27 May 2026 04:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7A076B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:58:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BD5B8F9E3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:58:49 +0000 (UTC)
X-FDA: 84812599578.11.1EFE35E
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf13.hostedemail.com (Postfix) with ESMTP id 308C02000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:58:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=ZE5FET2t;
	spf=pass (imf13.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779872327; a=rsa-sha256;
	cv=none;
	b=H32hetDMa0Amz2iPwGsvyUTVbp520ezEGVZ1NyCafMCZhtK6hDObfkbqoBszTmeHuQtiVy
	kTqTJDRBeqAQoqvH6EHB0ewIT7nl3ogYDHuALPPmp1/aIceo5PTmHw6hkwVkP2VpA30TcC
	/4hSjKYUCBF+8+/Lhyu7Tgq0UXZJ3QU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=ZE5FET2t;
	spf=pass (imf13.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779872327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fmzrGz9uA/PRb6gELqWbm0O/pBg7jSRrWCpQlkVQy7o=;
	b=iZLF6EkmOZx5pBf3v4QQyJdYjP/e3fOWdBJzjP9jkQJaFvqMAIodLm7qHgMbLxhB0o+BQO
	CvRMQ6AqZsQwtRBk9oNnXmD0EAqJoFBH8hSvVCI29tRG8vLFaWditV11Ba4gT36xk1xYXc
	0wuNdVv2zaN1B3ctjcCurDE8RdomfKE=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 64R8uY8K074539;
	Wed, 27 May 2026 16:56:34 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gQNfx5GvDz2LpCmd;
	Wed, 27 May 2026 16:52:41 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 27 May 2026 16:56:31 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen
	<axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand
	<david@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>,
        Barry Song <baohua@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [RFC PATCH] mm/mglru: improve positive_ctrl_err for low refault samples
Date: Wed, 27 May 2026 16:56:22 +0800
Message-ID: <20260527085622.1298437-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 64R8uY8K074539
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1779872207;
	bh=fmzrGz9uA/PRb6gELqWbm0O/pBg7jSRrWCpQlkVQy7o=;
	h=From:To:Subject:Date;
	b=ZE5FET2tCGG2vyrY6LXbrTJBn01+UTaxoApKSgoHhbqvyIjf04d5f1PM9q3JpyQrq
	 3TOYy33qvYJPwCvm6pWtxS8KrUCLqAsFXDvoqTSvQqoS+YLgI8yUnu9JfsH0Jk7dvv
	 Bs6rgpSn1uARg0E+5kRAPy3BERZ1+0vpv/ANhiNJo55/b5XuJqtsYq2pMxXzO/beVK
	 Cw4Iwg3ks1WOrUzAIQPj+PmP8+1LUlw5oSbA1ybXLb/crTZBhOQxOI3zYTV/XBSGx6
	 Y0zSR5NQdA8jrlt8dCwit82co8MWiiF0a1sp19qHQdatm9zlp8rRWS/iww2yzRW9bc
	 Gh/B/zPUtS1Lw==
X-Rspam-User: 
X-Rspamd-Queue-Id: 308C02000C
X-Rspamd-Server: rspam03
X-Stat-Signature: ia1xst5y7u8xqbu88xxyaubtbe5ifu5w
X-HE-Tag: 1779872325-588552
X-HE-Meta: U2FsdGVkX1+lxsqlHDCoWtN8R4zwv8qEzPp/8ajvdQKTZV4hpztweP7LgQGuSqJwjs5BGrAod8PQeIklM8gWdF/Qr0RVq7HYJh+kL5DpNWteZgK1DuOmrOH0BJYDgiWGs4YcF8/hVQgkPJrRM3vzfazZ38kPYgXDUWIDSBKpNjEZZx7cwGR09tlz8NN8CVkL7MQ24hrs7jbY3jhtD+xhUZyPYvK7HdNtbklrQfLCavTiiYrzyxTt/SKDxUjUxYxenm2iKUvERrSBrWSoOk7gQ6v7k1rZyusk9Wp6+qcgvuLBSH+/5eBdNZblJKKAXz8C7V5d+pUNFRhj7ojmWYijaRDmRneZYX7+yh+aoJEkYihexKPtBclNtMOoKgvMx0GxzBrT8TfIRh5eR/EiWA8F9PACj/5NNV+6fPPmpWaLrytf3FbU/Bp+7nx6jmm03EVb4DYD5kTATtj7CyPPt1fQugRNLSgeaL4Pt8DqvxeU3gjkfMn4ilUR8fMp/tCrp8r2ozaLO90Y9l90OAWSh12uDnS5Heqhj1PK2vJmkzxpON/ZNrQ7mtUG5K76SHt2wAcMbOXdmn0T8QOUFLRKCitiGlgbXbVYjSYPca+YUaUo3ug4T/OdbondWYlqH5JALntl04C0vPPY1QXmpIXL78QhLCg3P/s2gZz4fQGALasqWl0wUSaPQeUE72ZA5xAOxzp0OKldk/LdtSLCgqOjEJwJAjEx8JGRcJiZW4HqYjVnwXyFS146YE5FdLWT1YHHFGibl71BjOwBoCEb7ATC1lSbbUFaNUY7pfuNuyeS1xhg/bivqk3sz68o2QWEJlhpGNE2Dxs5JJmaqaBQGvSIaRDWPmj4eHm22epzxRKFE9fslj0i5Ht6vRnQcHGVmZIh6gESqhRxIWpEadSovKU0oj8rMenh/jrDWR7A5AAZn+YfmSqRXbPmyJ/m5rDwBUdrSInXtSq5zEacmJ6ohMpC+tV
 OuX1Uocp
 7l/Hhtwc8Hj6db8etFiCVANd8Xwud/Ik+Xv1H6hl6G8Zz6jTF04dpMOPCMhLKLpyFhksLlOTzPvqckQVLOtivmImLLRYz45R/dv7YPw8X4zURAxhtCHqMceJ5FGsP/l09kTdw3kgEDosRWvPwnyF3617BYn4n78VM5tEccl5E2wBMrf4+mx2riMsgmqnVALg+MfyMOSYXX+z/PthyYqFJR8FeEbrntOBPjym7G3YrzOPEZLpyaFqIwqp2VdNP7JjhHEec0u32ZU0iRW34e35gc7BAfFFfMzxYkNsvhR4g3zKEFb0wK2Prgrhg+0+kCVuJ2oetUqFBVeVyQ5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The memory.stat under per-pid memcg & MGLRU[1] observed in android
system which means current type selection by judging the refault rate
almost failed since file page's refault count remains 0 which will
shortcut to file by 'pv->refaulted < MIN_LRU_BATCH'. The reason could be
both of small lruvec size and bypass of the file refault count when it
refaulted in another memcg.
Refine the MGLRU PID comparison when lruvecs lack enough refault
statistics, using gain-aware fallbacks which is simply respect the
swappiness and historical integral value without affecting the usual
refault-rate path under sustained reclaim pressure.

[1]
/sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1123 steal_direct=32 pgactive=58
/sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2491 steal_direct=64 pgactive=48
/sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1355 steal_direct=0 pgactive=1
/sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=3 active_anon=1 refault_file=0 active_file=0 steal_kswapd=1162 steal_direct=4 pgactive=3987
/sys/fs/cgroup/system/uid_1027/memory.stat: refault_anon=1 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1157 steal_direct=14 pgactive=1517
/sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1461 steal_direct=0 pgactive=247
/sys/fs/cgroup/system/uid_1046/pid_1251/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1643 steal_direct=18 pgactive=2914
/sys/fs/cgroup/system/uid_1047/pid_724/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=8924 steal_direct=449 pgactive=3753
/sys/fs/cgroup/system/uid_1047/pid_789/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=3864 steal_direct=157 pgactive=3062
/sys/fs/cgroup/apps/uid_10090/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1285 steal_direct=32 pgactive=36
/sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1126 steal_direct=32 pgactive=70
/sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2474 steal_direct=69 pgactive=52
/sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=3264 steal_direct=10 pgactive=861
/sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1447 steal_direct=32 pgactive=21
/sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1354 steal_direct=0 pgactive=2
/sys/fs/cgroup/system/uid_1000/pid_471/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1296 steal_direct=4 pgactive=65
/sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=18 active_anon=3 refault_file=0 active_file=0 steal_kswapd=1286 steal_direct=4 pgactive=3979
/sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1462 steal_direct=0 pgactive=246
/sys/fs/cgroup/system/uid_1041/memory.stat: refault_anon=17 active_anon=5 refault_file=0 active_file=0 steal_kswapd=4429 steal_direct=30 pgactive=5239
/sys/fs/cgroup/system/uid_1041/pid_820/memory.stat: refault_anon=12 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2441 steal_direct=17 pgactive=2034
/sys/fs/cgroup/system/uid_1041/pid_839/memory.stat: refault_anon=5 active_anon=5 refault_file=0 active_file=0 steal_kswapd=1357 steal_direct=10 pgactive=2055
/sys/fs/cgroup/system/uid_1047/pid_1166/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1577 steal_direct=70 pgactive=1130
/sys/fs/cgroup/system/uid_1047/pid_732/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=7661 steal_direct=115 pgactive=3681
/sys/fs/cgroup/system/uid_1047/pid_799/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2847 steal_direct=62 pgactive=3573
/sys/fs/cgroup/apps/uid_10129/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1153 steal_direct=18 pgactive=42
/sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2336 steal_direct=210 pgactive=49
/sys/fs/cgroup/apps/uid_10165/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1491 steal_direct=43 pgactive=525
/sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2229 steal_direct=108 pgactive=863
/sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1299 steal_direct=163 pgactive=23
/sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1323 steal_direct=32 pgactive=2
/sys/fs/cgroup/system/uid_0/pid_1203/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2927 steal_direct=12 pgactive=252
/sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=1359 steal_direct=34 pgactive=253
/sys/fs/cgroup/system/uid_1047/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=4269 steal_direct=55 pgactive=6308
/sys/fs/cgroup/system/uid_1047/pid_721/memory.stat: refault_anon=0 active_anon=0 refault_file=0 active_file=0 steal_kswapd=2745 steal_direct=44 pgactive=2761

Assisted-by: Cursor:GPT-5.x
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..5fecfaa392d8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3179,14 +3179,62 @@ static void reset_ctrl_pos(struct lruvec *lruvec, int type, bool carryover)
 	}
 }
 
+/*
+ * positive_ctrl_err() - return true if SP is hotter than PV
+ *
+ * Drives MGLRU type and tier selection in get_type_to_scan() and
+ * get_tier_idx(). A true return means the setpoint is hotter than the process
+ * variable and reclaim should favor the other type or a higher tier.
+ *
+ * With reliable refault statistics on both sides, compare refault rates. That
+ * path dominates on large lruvecs under sustained memory pressure, including
+ * the node-level lruvec when memcg is disabled.
+ *
+ * Small memcg leaf lruvecs often lack reliable refault statistics: few pages,
+ * infrequent reclaim, and counters reset on generation advance. Treating a
+ * low PV refault count as unconditional evidence that SP is hotter ignores
+ * swappiness and tier gain and confuses "no samples yet" with "cold". Using
+ * the rate comparison when only SP lacks samples skews the ratio. The
+ * low-sample paths below apply gain-aware fallbacks and apply defaulting to SP
+ * is hotter when neither side has eviction history.
+ */
 static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
 {
+	unsigned long pv_ref = pv->refaulted;
+	/* Used by the rate comparison (SP only) and the total fallback (both). */
+	unsigned long sp_total = sp->total + MIN_LRU_BATCH;
+	unsigned long pv_total = pv->total + MIN_LRU_BATCH;
+
+	/* Both sides: compare refault rates. */
+	if (sp->refaulted >= MIN_LRU_BATCH && pv->refaulted >= MIN_LRU_BATCH)
+		goto compare_rates;
+
+	/*
+	 * SP only: PV refault count is not statistically meaningful; treat PV
+	 * refaults as zero and use the rate comparison (yields SP hotter).
+	 */
+	if (sp->refaulted >= MIN_LRU_BATCH) {
+		pv_ref = 0;
+		goto compare_rates;
+	}
+
+	/* PV only: trust PV refault signal; SP is not hotter. */
+	if (pv->refaulted >= MIN_LRU_BATCH)
+		return false;
+
+	/* Neither side has eviction history, pv is colder */
+	if (!sp->total && !pv->total)
+		return true;
+
+	/* Neither side has enough refaults: compare gain-weighted totals. */
+	return sp->gain * pv_total <= pv->gain * sp_total;
+
+compare_rates:
 	/*
-	 * Return true if the PV has a limited number of refaults or a lower
-	 * refaulted/total than the SP.
+	 * Rate comparison with margin on SP total and refault only; PV total is
+	 * not padded so a meaningful PV refault rate is preserved when sampled.
 	 */
-	return pv->refaulted < MIN_LRU_BATCH ||
-	       pv->refaulted * (sp->total + MIN_LRU_BATCH) * sp->gain <=
+	return pv_ref * sp_total * sp->gain <=
 	       (sp->refaulted + 1) * pv->total * pv->gain;
 }
 
-- 
2.25.1


