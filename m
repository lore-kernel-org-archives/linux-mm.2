Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D86CA5FA4
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21516B009B; Mon, 28 Sep 2026 04:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9006B009D; Mon, 28 Sep 2026 04:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A359D6B009E; Mon, 28 Sep 2026 04:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8367D6B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:20:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 239411C0818
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:20:20 +0000 (UTC)
X-FDA: 85262473800.18.107DC2B
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40CCD180003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:20:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1xp/mnR8th28pFedxjnt1uzWrVLyOBZo8JGLSJN9QQ=;
	b=XA4YIDubJAKzp9cvzfeio7584I+XQuExJDJpXHlhaeEtk/vCWTq06pI6csjRLMY3QmJ/Qf
	vVbSOLBsgbjuQEsK92ZzH/PbMeWChOiEsBqxECJRp+pPZHRfwcvOSPB116uQo5zMUPWMmS
	AVN5M6ObAPg5vxnSreLb2vxsZeo+aNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583618;
	b=BcgdAE1Xzvk3lfHitEojNbK7da+UsBvohe8i+79Qg01O1Rjt3hpNdBlRmBK7RUibdhp8PJ
	wOgk9oubyHuHHZgkMOa6RhWZArSFaVPAXZsYpj6biaqsl+VFpYEb7FNJW3BWE1gcLuFVBs
	lrgKROmTFzu0upny47vt7QrfZPbwGhY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 669973EC5D;
	Mon, 28 Sep 2026 08:20:13 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 1/4] block: do not issue background swap bios as root
Date: Mon, 28 Sep 2026 10:18:36 +0200
Message-ID: <20260928081900.4187482-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGtUmpjxhEfx2k/XMvfS2bDqEP9+dB5zZisGhxTwA8bQzLw3TIzq2waSv+gTQCne6+EBQmyW7bEzXaepF5Okak6AT+sDdJyFRS8JBxX5eWAn2dKQA+IxAW5YOKg6RuNOZXqSmdOPVtik4kDkXkMveBkIhwLfHH6+oJtYNWba4phVM5VwK3qK5PwYOtrhYesE5w8z8mqi5VPr4rtOenhStP9HwF40aqyUg3ojWVSxtNC6vSsJqOcXNUU4pC8KocXQZNj6qmJ4vmZaKB0nGV5McglAJybgGAm8g3dYpUDEI9WO4UM4y91lgaIcJNucAmybGIzNLZsbSjgKfmbti5QxXMMfUvFbT1AkH89G/MMj38j4q74p5XkbfKyohiHv9XRW4UD/pdec83V4NQkOXrvURbOT96oYYrYHDxmjFK1KjchHzgYg8zGemrbUaVE2vKPg16rjveWSO9xAGHGqh2ADS0qK/PcGf9ne04mTtbDtfkNij3DEXnMjJrdi8Taez2DFKDdhwBktDyq2o77Np8WcYQcvmTb1BxknF8+K9IJQOe8OcxYY8ciEPlX5n7qaSNaXmtsI1/dOMqnOv3F/LfNKoKqg8r98gWpdvostny/4LmW7Tli5vDVhPTM8H2Bd5lnbS74gF4KOUwMJJD9BuWbTC+IniWZc2wyvhDuRx60ETwFBg
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40CCD180003
X-Stat-Signature: 1m17dn85qwqh88b5hnegcyq4zuu3yzdi
X-HE-Tag: 1790583618-543837
X-HE-Meta: U2FsdGVkX1+oH279IYPszLVf42qjoJ1CTvOAtjB17b5b0P5aP61yqirzOkSc5qX5IZpz9VITDzRwdqe1Cp/Nkc1kVyb3Mj0tEA1zuE9XHTQ6Hp/C7tY3uQ+bhazYAv088PANO0J7GRAvPBZNt+SCWQy6Ih9SMw4hF6O71k2YAeqs5JBFsDlZfze9o0LG6q2awuoCihHSRkGC4IsOOOKlps8E4wzAzGoeA57GY70p+dz4YV4bK+3JLrZhJGLINEf5EGpKkylNJI/U7cCt8nSe1OLUAgFVzg66wiOrg7n2ldFcwOD+Aq06zgZyEmhC7k37pfa5GaUoIcY2cmEJyH5btq0j5IncnvT6jpUZuo8mAQ8bnlyYyohvKLMfKq56WzzNd8wwuZ8VxaADX1+N2XdewZ5tzvCiRc57JJkfnyhQz8iogmkb8JsMcHbWSTYkcLdYNCHMn/cqNvijB/6SuZvEm8B6zYachWroHBOKdQh1rP5rs8YXYVinAVqkpGa4T0CxnQp/5ybiC1TqZB2DSw0BRz86iYtgyIeceEDAg5mzqF6mP6mWYO2pTCW8ThgoT0kcYOTwuBCm/1rHeRo95TPwB4HJNVQHNIDv754dACVDZ5cMr+vUugGek5bfS6sVPbNM7MMDtDES4MkVvgUAzjkbomIEziXL1REVQxmT9lFKRSAmjMqKk91naloTLKm3VwQMXmRIAAu2CGUDvzjL31qqkvYC08/+30UhR70kD5dQGrlhOXALr9uONo2tX+20DR+mV/T7vXnOHoNzOHZuetvbJ8i6YiNQ7zZHR+6QPHSFHi1qZujGrczKZa4wJ2YHnjwua/PonYCFHsTVJpCrAwTJ7Sf3XyJsm8b9333e0K+BfG25q/2yRt0YgBZpAP9bs/Mm9/wFHuJIlPfbYrfsdI3+J8ZwgKxxojO+7c5QB0YfeUV2rjiv/SLqbcvXtALh0Efqxq596jAnOzEQzCazJ8y
 UxHKHcb0
 zjM3q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
the cgroup IO controllers, because reclaim cannot stall indefinitely on
swap writes. Some swap writes are not urgent though: zswap writeback is
best effort.

Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
for limit_swap_bios, which caps in-flight swap bios to avoid a memory
deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
encrypted device").

So let REQ_BACKGROUND, which already marks IO that is not urgent, opt a
swap bio out of being issued as root. No swap bio sets it today, so
nothing changes until a caller does.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 block/blk-cgroup.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e67c69839129..02009cb45495 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -242,10 +242,16 @@ void blkg_conf_close_bdev(struct blkg_conf_ctx *ctx)
  * the bio and attach the appropriate blkg to the bio.  Then we call this helper
  * and if it is true run with the root blkg for that queue and then do any
  * backcharging to the originating cgroup once the io is complete.
+ *
+ * A REQ_SWAP bio is issued as root because reclaim waits on it, unless it is
+ * also REQ_BACKGROUND, which marks it as not urgent.
  */
 static inline bool bio_issue_as_root_blkg(struct bio *bio)
 {
-	return (bio->bi_opf & (REQ_META | REQ_SWAP)) != 0;
+	blk_opf_t opf = bio->bi_opf;
+
+	return (opf & REQ_META) ||
+	       (opf & (REQ_SWAP | REQ_BACKGROUND)) == REQ_SWAP;
 }
 
 /**
-- 
2.53.0-Meta


