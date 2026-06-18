Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAF4CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FDB6B0092; Thu, 18 Jun 2026 00:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7386B0093; Thu, 18 Jun 2026 00:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0596B0095; Thu, 18 Jun 2026 00:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17B5B6B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D09F1C4B0E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:41 +0000 (UTC)
X-FDA: 84891805362.21.C9E2EED
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1EAC140003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+z2Jkls;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758179;
	b=wF8xRw8LKUNagmq7TCjHpZ/ouuq1uOKF4kHX8HkrI9+tq2uUZiZ/SOOi/oy7AlDcXi9asT
	8nG0qpPMUMO7NUU5Nnilx3pmFbGJT6ma16HWPXOf1HEgrVunPWZ6jDRlh1AGITWrpd1M8B
	nMcyLrZhOIGGYAFcLNW1OfLDDS5+D4c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+z2Jkls;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTogXYNv78gwID3PJ713yHc97a0x/oZa3BlIEI1TXEw=;
	b=Po3K1iq8Sfl/cr4myd77PcXpgDmpJY1W07wutmvMPsXLnRRGKqVo1DDlKiP0ip2WHm3lw1
	21T7TdSDpo1qT22K2fYIq17/aFXmR+osZpN+UqVI4LOlzpfvw+5IIMBa23vYL0UPQWtoLV
	3SgiJqtVyDxBDMWRI/wuLfDryVQmy8s=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c85822059d8so365152a12.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758178; x=1782362978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTogXYNv78gwID3PJ713yHc97a0x/oZa3BlIEI1TXEw=;
        b=J+z2JklsNnkizEYP3YQBlaRKV1ZQOK2HdEw1DZnb7rpBh1SOCJVIRH3NdXqf6xp186
         W/gg0YfDK24ap9/j0THyk5SGqK00u07gQpkQe3e5U/Dy3E/tHswbhJyzrNbm3ArSSMyw
         16oH0l3XsrIC41nxlrnK9zhIryYVn0rdAYx8VIE1M+QAC+RYwVPltlRBy4L1jQMW+OXu
         cC9NyoCyI4bLd7eigerpFNdkLe182hNXQ+kp+NL+mm6Mx5NhEwfUMTNKdbOB25rLNIJ0
         8SxNHUuWoE0cxvoOkt5uL24fs1KLXKjY5EhItdTOGbCGJGf7PIOPb97uNM9AFnONUgYl
         fdww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758178; x=1782362978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fTogXYNv78gwID3PJ713yHc97a0x/oZa3BlIEI1TXEw=;
        b=rysBy928y6/2+JWbqYnoQYEf5ISawWwV98bv0AB/NDDFsWFRvLVjK0/X5CS92lf91z
         peJG6dhk/IgFQinRZH0ff6AefRRovN3J9VmmLUXyrjC6TZw0Ycpk9Acs51tHy5f+Psgu
         PShxKH35CjiabXsqKEy7KkGpIP3kfjCflN44o3Vp6yBtKdB1X6G2KWW53tztzOsSMkE6
         Ln24MCLZJiILOIJ1nFu4DI2OdZk1XuBqfD59hsd1v66BK74iblGHXaR7hzH1pPMIcaCz
         bmdkamUqJHYD0IJpeexSkrK1+SS+dQnCRhBGo6u7K+90hBMsjVxtft8SQJirQJ6kIEFH
         Npbg==
X-Gm-Message-State: AOJu0YwnZYv9tM5WBEux1J0pK6yk/UreVgH/kRU37pAtNb7S5QGke65M
	em52DY0J0CK64TAatcIG+yfveHNbfN2IaoImoBNX6pGTuqGY0qiZ6tDY
X-Gm-Gg: Acq92OFZsuLzoLl3yExuWwzfy8T/iabZpSSM4r2pzY7jM9nZSEIHIm7OabQ4vLGRwxc
	SicE2UxcwYzeQNzA3ufahnKHB5QgDZl6h6EPrEAsAmYEJjG3iZ+Ns9D1qxx6oLa2rloAfQSEmmB
	uGWV0kY5jxzvjeWFrDjtx2GUQEdiglue8/85O/anA+/M0AZ2aOEpQqkEHla50zpHDlHvuEGdKC+
	Y/M/JLnYsA09FTda6dzvXJ5OEA29pCj1dWBq6OubNve6iKtSP1YAu8qnwIYxABTCeJ3VvLTSaJ8
	2XKyEDc9aXj0M+GDFSqlVGD3kt/NmUHlt2ubMDVyvYNpjBq7NbQQRQtVLta4T6eetFZNqv6LABk
	1a3b8MLd5vfxuEUJ+3glBVRO3lr51YWROj6MwVeaCM9R2xyjSYR057nDS/LtbQBRF4JuBuBfwbA
	N4Zj46JHIJ5o7co3u278BUqPADl0k1blrnzVqHLUGw
X-Received: by 2002:a05:6a20:e212:b0:3b5:6b5a:4f29 with SMTP id adf61e73a8af0-3b8b7cd8e45mr7178450637.30.1781758178441;
        Wed, 17 Jun 2026 21:49:38 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:49:38 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of shrink_worker()
Date: Thu, 18 Jun 2026 12:48:54 +0800
Message-Id: <20260618044857.69439-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1EAC140003
X-Rspam-User: 
X-Stat-Signature: h4gcmukgema8d7wcxtdy6mwo1cqg8ed8
X-HE-Tag: 1781758179-324423
X-HE-Meta: U2FsdGVkX1/HVtuijOuzyDtsBsFaJJU8W+6fvH3Kz/ODeToFMFKW6uYc1dxe17sR3sU3mERPAvE/7rWSTQhM/GnYhlJNQJX+4oaiFrXkFjSzHqI4EYwNF94ZsJlIcEUE6A7wzIth/T+5S2Yi0kgHsMcOuIaSyDqkE+aVccTSY6+sHYikxPBOegEG5YQrjVNqA3qABQUSTnsrNe1U/oYOI5x9bJIEQK6zP2+Ci3Z8/xyhyOrFXTxdjk2VDcAt7Wz0JYoorzOLPYQMlQ7TYmH2WTespm4fEUJDGd2r1F8isFWln+MVfzCbk3NefS05L+lvo9QqMBloScjL5Raa8vqjqar8OHV7neT1sWr2C4i6S4UDIRD65OkdgkP4yOIV5tsakdQQ3HGra81UOsCWxvUH280R9nn5kCuH839UnPKIgb7hP6nZvb9fKBGc3LT81kez3TFMPn+zX8HlCeYWGZKabjI0wz3Or/B4A7RSbbNLKFEXUhYOdjEPdLpdF7vlGGCdYGD78gp6p+z6pMmU6QBLQTiBHoDmf9YK/THsOpm2bIbDZvuWnhADIso/7mTP18lnTqTIDvQZSbdqCXC8Pm0hKWWjggX638qYrrt5EcsE1V1/VNmqX8eDBsg2rnvmASMbryLj8/SmPyrvcx356SrEk4db2KRaTCQiDLD3m8i0jxG/s4QDKhRA3YTWXAGgCP53rFsAt45ISt/+f/3saFeBoKM2B5/hGi1sZZLbBE4XiKHFYKqIuehAtx40+MrQmNou9/U1RqD74VyGKnkR2GvtPPZJaMBZVwdts+HxKULtO9MGlNR8/j7mQs4O2yKJLYC9lXjprQ04GeZqA4f9sWwhlOA/+wTcxDcWiatSS+hKtMfFC4mXtZK6gXFlSC4mDOo4a0d1OSG7ZaaB7skxjc1anhknfgZIPcpu326i8AIH8ZmVb7UZvtl0yAkrcljIQafc0qLPqJMsgEQXqladcCY
 cB0IQVl6
 O1yNcgAOzfq1B48ZeDrITp5mGeadoU+bHDPazTCFjCCEQ4awfIx54KRonUcCaTYB3RWbGFHtspWWHisQFPeFToJIgO6B3NdyGq9x7BjO0LMNz7EuLlpEzEFRSGE2aIP9bl/MSMXMmP8xCU9I81wWBsD664+M1arra8hfRF+GIehw1LKUIMdLOTOCrYExPMdUflF6b5U/aqRwkxsi1F7eZ/QpaRXo54rpT8qQ+UzQrxs1FV/FPakE1ZJX/37Qv7n6d0aYNSY4Qas1a/3zei/Lp5hCw+gv8ze5Y7Tx7DvhL0ThxZEM9hpbcddDXaKEpJiy65X1CQ+KgRr9v2wvBGe+ANu6/ZfguaS7k/6e5kbtHrGJ8gnM5NJt78bw6KXc20k6YCnRDUezY2NfmODqBnVVemaCVoYtkTWWVTzcKo+PeveqyNCnhO5AlU3gr2sVq3yVVUkd5YDF9GIsJx6dxwVyGVERFaOdAiaUgt6WVz0lq9IKkEGCePUMxw15KJyYqJwdxs1IbZOxcQPYzuTT3vEJzqBFbUNgpZjWzqXR6tdrpD0jV1lViw+OvwWljutKHqMPduVFZOSlskoMGcQm2lj1nBrDNIsO6drzzi3/J8QDSN4fpu3yHv43cV0IejQrfW/O2r+4FPPghRUbw9pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

In preparation for sharing the writeback loop with proactive
writeback, move the memcg iteration into zswap_iter_global() and the
loop into zswap_try_to_writeback(lower, upper). shrink_worker() is
reduced to computing the accept threshold and invoking the helper.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 136 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 81 insertions(+), 55 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index d7d031dee4cd..e29f8a61412d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1380,61 +1380,75 @@ static long shrink_memcg(struct mem_cgroup *memcg,
 	return walk_arg.bytes_written;
 }
 
-static void shrink_worker(struct work_struct *w)
+/*
+ * Global iteration uses a global cursor to select from all online
+ * memcgs in a round-robin fashion.
+ *
+ * We save iteration cursor memcg into zswap_next_shrink,
+ * which can be modified by the offline memcg cleaner
+ * zswap_memcg_offline_cleanup().
+ *
+ * Since the offline cleaner is called only once, we cannot leave an
+ * offline memcg reference in zswap_next_shrink.
+ * We can rely on the cleaner only if we get online memcg under lock.
+ *
+ * If we get an offline memcg, we cannot determine if the cleaner has
+ * already been called or will be called later. We must put back the
+ * reference before returning from this function. Otherwise, the
+ * offline memcg left in zswap_next_shrink will hold the reference
+ * until the next run of shrink_worker().
+ */
+static struct mem_cgroup *zswap_iter_global(void)
 {
 	struct mem_cgroup *memcg;
-	int failures = 0, attempts = 0;
-	unsigned long thr;
-	long ret;
-
-	/* Reclaim down to the accept threshold */
-	thr = zswap_accept_thr_pages();
 
 	/*
-	 * Global reclaim will select cgroup in a round-robin fashion from all
-	 * online memcgs, but memcgs that have no pages in zswap and
-	 * writeback-disabled memcgs (memory.zswap.writeback=0) are not
-	 * candidates for shrinking.
+	 * Start from the next memcg after zswap_next_shrink.
+	 * When the offline cleaner has already advanced the cursor,
+	 * advancing the cursor here overlooks one memcg, but this
+	 * should be negligibly rare.
 	 *
-	 * Shrinking will be aborted if we encounter the following
-	 * MAX_RECLAIM_RETRIES times:
-	 * - No writeback-candidate memcgs found in a memcg tree walk.
-	 * - Shrinking a writeback-candidate memcg failed.
-	 *
-	 * We save iteration cursor memcg into zswap_next_shrink,
-	 * which can be modified by the offline memcg cleaner
-	 * zswap_memcg_offline_cleanup().
-	 *
-	 * Since the offline cleaner is called only once, we cannot leave an
-	 * offline memcg reference in zswap_next_shrink.
-	 * We can rely on the cleaner only if we get online memcg under lock.
-	 *
-	 * If we get an offline memcg, we cannot determine if the cleaner has
-	 * already been called or will be called later. We must put back the
-	 * reference before returning from this function. Otherwise, the
-	 * offline memcg left in zswap_next_shrink will hold the reference
-	 * until the next run of shrink_worker().
+	 * If we get an online memcg, keep the extra reference in case
+	 * the original one obtained by mem_cgroup_iter() is dropped by
+	 * zswap_memcg_offline_cleanup() while we are shrinking the
+	 * memcg.
 	 */
+	spin_lock(&zswap_shrink_lock);
 	do {
-		/*
-		 * Start shrinking from the next memcg after zswap_next_shrink.
-		 * When the offline cleaner has already advanced the cursor,
-		 * advancing the cursor here overlooks one memcg, but this
-		 * should be negligibly rare.
-		 *
-		 * If we get an online memcg, keep the extra reference in case
-		 * the original one obtained by mem_cgroup_iter() is dropped by
-		 * zswap_memcg_offline_cleanup() while we are shrinking the
-		 * memcg.
-		 */
-		spin_lock(&zswap_shrink_lock);
-		do {
-			memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
-			zswap_next_shrink = memcg;
-		} while (memcg && !mem_cgroup_tryget_online(memcg));
-		spin_unlock(&zswap_shrink_lock);
+		memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+		zswap_next_shrink = memcg;
+	} while (memcg && !mem_cgroup_tryget_online(memcg));
+	spin_unlock(&zswap_shrink_lock);
+
+	return memcg;
+}
+
+/*
+ * Walk the memcg tree and write back zswap pages until the
+ * (lower_pages, upper_pages) window closes, or abort encounter
+ * MAX_RECLAIM_RETRIES times of the following conditions:
+ * - No writeback-candidate memcgs found in a memcg tree walk.
+ * - Shrinking a writeback-candidate memcg failed.
+ *
+ * For shrink_worker(), it passes lower=thr and upper=zswap_total_pages().
+ * The @upper limit is refreshed in each iteration by re-evaluating
+ * zswap_total_pages(), and the window closes once the total falls
+ * below the threshold.
+ */
+static void zswap_try_to_writeback(unsigned long lower_pages,
+				   unsigned long upper_pages)
+{
+	int failures = 0, attempts = 0;
+	struct mem_cgroup *iter_memcg;
+
+	while (lower_pages < upper_pages) {
+		unsigned long batch_size;
+		long shrunk;
 
-		if (!memcg) {
+		cond_resched();
+
+		iter_memcg = zswap_iter_global();
+		if (!iter_memcg) {
 			/*
 			 * Continue shrinking without incrementing failures if
 			 * we found candidate memcgs in the last tree walk.
@@ -1443,12 +1457,16 @@ static void shrink_worker(struct work_struct *w)
 				break;
 
 			attempts = 0;
-			goto resched;
+			continue;
 		}
 
-		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
+		batch_size = min(upper_pages - lower_pages, NR_ZSWAP_WB_BATCH);
+		shrunk = shrink_memcg(iter_memcg, batch_size);
 		/* drop the extra reference */
-		mem_cgroup_put(memcg);
+		mem_cgroup_put(iter_memcg);
+
+		/* zswap total pages might have changed, refresh it. */
+		upper_pages = zswap_total_pages();
 
 		/*
 		 * There are no writeback-candidate pages in the memcg.
@@ -1456,15 +1474,23 @@ static void shrink_worker(struct work_struct *w)
 		 * with pages in zswap. Skip this without incrementing attempts
 		 * and failures.
 		 */
-		if (ret == -ENOENT)
+		if (shrunk == -ENOENT)
 			continue;
 		++attempts;
 
-		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
+		if (shrunk <= 0 && ++failures == MAX_RECLAIM_RETRIES)
 			break;
-resched:
-		cond_resched();
-	} while (zswap_total_pages() > thr);
+	}
+}
+
+static void shrink_worker(struct work_struct *w)
+{
+	unsigned long thr;
+
+	/* Reclaim down to the accept threshold */
+	thr = zswap_accept_thr_pages();
+
+	zswap_try_to_writeback(thr, zswap_total_pages());
 }
 
 /*********************************
-- 
2.34.1


