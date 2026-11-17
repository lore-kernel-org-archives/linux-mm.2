Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F58606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lmfEcNYC
Received: by kanga.kvack.org (Postfix)
	id D22566B05B4; Tue, 17 Nov 2026 03:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3246B05B5; Tue, 17 Nov 2026 03:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2F86B05B6; Tue, 17 Nov 2026 03:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98DE76B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:04:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E3B71A0356
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:40 +0000 (UTC)
X-FDA: 85443874320.09.6FF75BB
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf18.hostedemail.com (Postfix) with ESMTP id 460C21C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lmfEcNYC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794902678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXF8oVQRnsv2ot54KZJo/sivs9IEK1CA2mVPqtmHEpE=;
	b=BRJajItKp/JhyhIpZ6jGFDC+oOLv5ZXMqUKrBHDt+LyjMQ+OKJrx4V8u2ZshdxtqD0IlrX
	VL2EKTCXZg/F9TF0Ssn0SCpcKKZiFGbMXr1BNjAmntJc5RnxVqjIfCteeq5gmLZFV6gzyD
	xUOhV/sRMYnCufy79fdB/XR/+DOrJAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lmfEcNYC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794902678;
	b=szGUKDczeCij2GBDPOKUfGLo+c9inDaNp9dJ+VESiB3/0dcKeJLYJ61DvbGOYLSZ1RMW/p
	1EodtwG7rPU2hHdaDAn0jHtcTpjVxgWNcUBpjcRhs6oEssZ98+X7H1mMWMepdyy5uldEd8
	lMU57IADHmXF3uMMXDl5hPvbPmXXT6o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tUoF/AF9aJL8T6z27kbc5MffrFYSSF3reZSFJQMzMtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794902676; v=1; x=1795507476;
 b=lmfEcNYCbZTd26bIDYO2TnJG/JHdK/UTeHJrWAv9/mpX1ujBe5n7AnpNLBSFWpfwlxbfNEEG
 7kDhevuwHoZoActQctm33DJVN2Mc6zlE5trLRzPWrxBI2lDcsYQBgCNxb+uTcsfj7uLTWLyPWh+
 qwfku+otFb//lzvlhCA9ua5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9847e282a775229b;
	Tue, 17 Nov 2026 08:04:36 +0000
X-Mizu-Trace-ID: 9847e282a775229b
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Down <chris@chrisdown.name>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: memcg: fix memory.high throttle lost to u64 overflow
Date: Tue, 17 Nov 2026 16:04:21 +0800
Message-ID: <f1cfcbc31ade9851c3c09db6bfd190682a130245.1794902513.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794902513.git.zhuhui@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 460C21C0002
X-Rspam-User: 
X-Stat-Signature: 53gqm57fsgdpk5s8ojtngr8jew8fb8wz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794902678-348139
X-HE-Meta: U2FsdGVkX19O2d5QWe2mXSkjEt4kmgqcnmZxReutHkNIAn6OupepRGgnuZRykw/BvoAaCpU7wST/Mt+ZMFZTYpixsnNbdWAO3JLMtDGVsUbm/+Calf6z2cvpjVMGEgXxo3BGS/Taz6zYnnHgBzqlLrMs9JBavAzsIJaoq+ormESTMsBJqUnwaQ/56oLtsiozbn6g4rhCU1tIq8St5/gIxxKgCprvnRyZtxEY203/viQZ+/wnJwBR6aZfBtS/KDx061/emyBrE5J11NkdugGSOl6nY8p4DB28N7D1sq3drrabD19IRI/pWByW63pt8b/a0B4G7EgmQqiXp5KF/ter9X+5sAhfP15EaDl3o2ax+6FXF6OpbR8dWiehtp5Uq+M1kYY+00d4KQcT1iy1ZNw2cfOuD8yjHDTjOyUAO3g3vnXZuJoxyJVC6wt7P/4XxmA8DUnRwMLGU4WNDstccVh07FJlb+r3TJhacldt0vV4v/bWK0q83dAgzdc66SDjUKmPCn8qCXG3Hy+tpXBLaZURGl+JovqVSAwQXFWbuok6qeEWN3XceO/SC3sqYKv43rCCZFjdz7kaHkyv3USEhrVZnSVrYwBKObosFazcAxy3yn4xmuB2B0HtRkDBVvvUl+xHr3/aeWBFrrgmnx6u7kzMB7O6L2a69FZ3GS9JTXW/QdzRaLThmM+R55zDSIYuG8pLzlIG9Gtp4rLWGBgKFnXdFI0V5xGyY5UzdCcv3cTJCdIjLyOhFP2s1rDn/GQ2XW9vKTdPLjuqUr0JBLvYaFPbgmwRyB5MOLx/A6iyjbdyqXAqqDqpko5JbrOG6CvX1ThVi29txsbtsvWhzwHaM14/4X/1SR6rjwpBTmUG9lEpT4KsS10MIrhh0o4y4s79a/yMTfLt7o2MQSAgIey0F7tCIDqcYSDffTEUS6Dgn0rMSY8+zAYxvXfmSgMmk9ZyqXVkzoSwxsWj91aap2zjsBJ
 iXXs26Et
 4X3m3q3Yv2X/tbmXwJPofwx2Mj+4e34YUr3fuDAhaamYiZqzlM/m+fdUZ5mc3yPiorxs2tRexWkMMKFDtzatrNH3PGhNOlKzYFuWGC2HQeKSoabgfYpFdUU4UBI9h7gEHEeAtiUc49z2EEWQ3xxMxtyiCxmywpYW+DxwwOEtx4WYFISo4qPPiE6uzIoeMKDPgdAChhrEFjyS0VeMTqsQRw96E6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

calculate_high_delay() squares max_overage and scales it by HZ in u64.
max_overage is the ratio ((usage - high) << 20) / high, and memory.high has
no lower bound, so the product wraps once a cgroup is about 130x over its
limit (at HZ=1000). The wrapped value is arbitrary and can be exactly zero:
with memory.high set to one page and usage at 2049 pages, one page past the
8M mark, max_overage is 2^31, the product wraps to zero and the penalty
comes out 0 jiffies instead of the 2 seconds the formula calls for. The
caller then takes its "penalty_jiffies <= HZ / 100" exit, skipping both the
throttle and the reclaim retry loop.

Clamp the overage to MEMCG_MAX_DELAY_OVERAGE before squaring it. The bound
keeps the product within u64 for any supported HZ, and by then the delay
has long saturated at MEMCG_MAX_HIGH_DELAY_JIFFIES, so no penalty is
shortened.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ba42724ed1e..aeec1bbabb26 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2521,6 +2521,15 @@ static void high_irq_work_func(struct irq_work *work)
  #define MEMCG_DELAY_PRECISION_SHIFT 20
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
+/*
+ * Cap for the overage passed to calculate_high_delay(). Squaring a larger
+ * overage and scaling it by HZ overflows u64, and the wrapped product may
+ * come out zero, skipping the throttle entirely. At the cap the square
+ * still fits in u64 for any HZ, and the delay has long saturated at
+ * MEMCG_MAX_HIGH_DELAY_JIFFIES, so clamping never shortens it.
+ */
+#define MEMCG_MAX_DELAY_OVERAGE (1ULL << 26)
+
 static u64 calculate_overage(unsigned long usage, unsigned long high)
 {
 	u64 overage;
@@ -2581,6 +2590,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	if (!max_overage)
 		return 0;
 
+	max_overage = min_t(u64, max_overage, MEMCG_MAX_DELAY_OVERAGE);
+
 	/*
 	 * We use overage compared to memory.high to calculate the number of
 	 * jiffies to sleep (penalty_jiffies). Ideally this value should be
-- 
2.53.0


