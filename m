Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A080BD65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A166B0005; Wed, 17 Dec 2025 17:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014746B0089; Wed, 17 Dec 2025 17:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4166B008A; Wed, 17 Dec 2025 17:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBB6E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:48:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9036C58E38
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:48:04 +0000 (UTC)
X-FDA: 84230452488.07.971DC64
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6652A0011
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:48:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e0IbJjB9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766011682; a=rsa-sha256;
	cv=none;
	b=ir1bKMN+DV8p3FEGoULaatyUjRzWQA/LYaaP4EUnR6eObIlZ2ZXfTN0c8AVe9kW362SwMF
	ZjMdHZmwXyUc0nB+sV2Zu+ACY4LoxPVTnm+NU3BI7PVItTVCpD0QBgAyboiQQCWDESagMG
	B+kbw+1TpBJqsVUsscCmMybFu/kY7oM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e0IbJjB9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766011682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RM5A0ry/rHet8/v2ANKiOz9PZ8pj+yMbW8LuBQqTqb8=;
	b=j2WiHXuBMZShdt6eEQB8ooes/n64s94y6+3BB30nzC1YouDnWqtiYg+cqZFNq5VNiSOCUE
	h4JYITr95O4qk0Y5XK0Zx8VdeuMoRoozyABKvXg0BPB4qNHovwNQ1zdLv0JkCniaA/KO4D
	40TJl63yUNFHtMF7f39V/fYbH4F575k=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso2606586f8f.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766011681; x=1766616481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RM5A0ry/rHet8/v2ANKiOz9PZ8pj+yMbW8LuBQqTqb8=;
        b=e0IbJjB90aZyGfTfSR724wr6uFJ2xgpkLUwzQYvZr0TXjuk5TEXiGa5IQXbUELL2GD
         9x8dlcASashROqitAYYwwlYyX5NcPgYmoJ21stCRuFN+rIGY7G9zVW36DBi2tRyDBNXV
         l20/c6XvOyRrPZ9QSzq8M6sLwvOvbqvfa/LT19Soav1I4TtIceMxogozB+ggbK9GyBqt
         84VKLn9ijN1UsOJILRafoa2eHDmjAYxpzjJ0fLBYWFIclDPiSZNE38yO5nywu6eQQZ3+
         xyAYrc9ztHNvzEa0RP19L0iUQIsCQP/dgbtrCVfEvgyXtKzlJ1a/B+UpGK2q1GD0GtVs
         qzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766011681; x=1766616481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RM5A0ry/rHet8/v2ANKiOz9PZ8pj+yMbW8LuBQqTqb8=;
        b=XpoxABLiZK3N4LqWrEX3+dsYkO/t1MEiUtrGBeX7So3xg+KrbUWZPkhhWfQNhQnFsD
         PRCAfdBcoCdhBt6hgtc+5no0dhDvXjCCcBJJfAVuRcbSvMoSl+wmh+qM/XHIwp2Wiw9M
         XaaW70Lq1wurOjiku8y2/JCzmUHId0eZHJeG7hnXJJNWBpAjFoNWldqQORpqj6+oYO1J
         49pmBePcPTXoniB2qJT8OdP1li4N/zNP8odHPVIViOEHo5wMcNu2v6Rtoi6LauUj1QVD
         /igRSC+dKvJblh7raq40Y+gyaeV4w7S/mB0qLinF0AzHIg0W30N9T3H5gH6RHwIk7MLW
         haaw==
X-Gm-Message-State: AOJu0YxnVxD2vYQZ6hM8oZj+eepvN2DkLFzGrQwuugmI9QB2Q9Y7oJhW
	iu+ObSWazNXeoOlcG3g5XnUgOTmAu+vWFpDYuykYHOkBHk5YZGN8UeFj
X-Gm-Gg: AY/fxX5+f/6hW4mXMNYDJ37yYwMfDhDrgjP/VpR6tJH9OA7CR4o0USGxGbcr7XPktfp
	LuFd+xYeeRdo81VrNrkkxfvOg9CN9G8eFv+6Tnc64cRNXkpVpfKmbp/Wd1HhP7V88HMW4aiGvMY
	EVccJuzkBk4CVhmw849gRCNyYD52e1Ho5w+XsmV2YXvFEh9tKBKHPahW2oQEX5IIy7UY9jH1aK0
	qQm0gusj6I43HiRCudPm7Q0P7lO7snrkug1jkvRX9w7Jzl0TOTxbUsAspRBEGsYftE2e58zzZP5
	O4BQ1IKh71c/Kkw/K69SPZP0hjgZ5yb7qLuOia7gfbFhkzuiH4ugNEXjiAT86Ash9g9LUCyj0e1
	Z74n4OoSfQ7y5quceewZt2ZQ6yh3UjKFsC+D+bCQKNPFyroFqUJL48oPVILB0DXSAqLqyPbufKm
	/9tUAN8LQUl3NiIJlgtyb4P2fXncZXTKinl3AZvwoybUlg+ssx6QFrkeJy37l/NksH16KbqAY6F
	B2AzChj1xXJTEwLqQ==
X-Google-Smtp-Source: AGHT+IEB2l6tfD3XeJHwE80Whf4bXvEZxnYGVb9EVsSMnweCainL0lhHxj7ZDmUSjDOO+eBPu8gK6w==
X-Received: by 2002:a5d:5f94:0:b0:430:f5ab:dc83 with SMTP id ffacd0b85a97d-430f5abdf74mr16393355f8f.11.1766011680951;
        Wed, 17 Dec 2025 14:48:00 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324493fe32sm1446960f8f.14.2025.12.17.14.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:48:00 -0800 (PST)
From: klourencodev@gmail.com
To: damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	Kevin Lourenco <klourencodev@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2] mm/damon: fix typos in comments
Date: Wed, 17 Dec 2025 23:46:10 +0100
Message-ID: <20251217224610.8814-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6652A0011
X-Rspamd-Server: rspam03
X-Stat-Signature: 4z6oos7sdt8wncfe4zsg3i4fkd8zm3bj
X-Rspam-User: 
X-HE-Tag: 1766011682-15413
X-HE-Meta: U2FsdGVkX1+YdzSmmSs78/srhvQfxucPnYe5EM7jiGJSMDQPxaeIZmUYWELWtWQPHDdQZJMMriEp4QP7obZo3YuoDz/DF+vQcWM183izVRTkmGfWYzIuGVRxqPDeiGsF89F+9g6sTeciAAooXd2sprqkK+AFzkwGD5/ad8yMdnlaYvHq+k0RrJIZfj0oHgNs8MXqHC65UO3xB2j7BKtdi3H+Pa6TBMwkdRgfKHUvs1pfbHQp9QN3mSFslPmxD8y7TcFaMMyN9kZjkOr7pDpeYg8hNtKcOPA6xKXbDhbd0p1Q1TJ8Qbcs7gDVOaRLqbS8LdvYTneW0z8btzOfl6oKvm8lIYRM+6mCiqQuUaKza2HZy62dwGha1OY1xkKRL+Pr7bAohL873MWR5klsN0LinHU8GfvVCVdxwnMySkKcJmbrDBMAeXeXKKaRead6ABLIPOsqeuRKYfuEY8TTtQ8j1A69DnBqKIyIKI4kDLthd/mEZrJEommJQPdD2E1Dxnuv1Ivcb6HmLDtYYj3JP2j1Rwusj5oaWml0KhvQz361OIGVUZl1hjkncKaFoy+5/ZmZKESR6jf9TXMJF3ZhMjVAPaBmFARt3deXRowSVIqtLh+Wh0oFhRysONji5Q/ZeAk5+yMhr9YH5yiW/0UsJTttQvf5N4LgmuxH/8JGgIMe0cCNGwbzkt9ovwBYlsEZbnnWptwZvEvYrjzyy5vmnnXbykmGoXz8QiGia3upz9rdvxPXmkfMAe5FklB81bVIHmzCbQsKF9u66/k9QQp5r/yOsvABg2mziy0YiAv0g7iJP5xFe2tX2mzTbo6z/DhwplmZ6UdYjE0UyXoVfM57sKZiD5BMQjDaLAP7h9YTN9ODhxrXPNINg+PtjrzdwczSBai9+mN/rQ/HhaT9VVhPBqv2MOzrDNewiYJ/jVgs2cSt3NB4ZuTIXkROWTLGwcW+CjYtlRLbNGOzp3Dit2ZBAOL
 m29SaiP0
 +NRCOIHxd0UYsLMzudoP+vPOWXlZhGQwKHamGCH4DNcpgNYue0/6DHXqW//29+jgvXz8jUX92vcD31l95gmO1tg9KCAAakzEwyRogW7R7E73jqe9at+nUGmYhXGfIoEPhdLj9lIPUZ8HDmATZEjsEX8CGjnlDFIt2zjruJXF0v7eh5OULOurm+vaLc7wPqK5E97CbYqWFdi8YAfrjpvj/eAxxpvmxYesPuwsFSddvQ0rdBx6Wkny8sJldkb3cU3CDZ56QWSA+dvYGyplR1QH0vbEKv3/dMGH2dVswEEEhpAiv8BFSr4cesHK+PXgP2kbsY7ar7vQyW2kTe3Xfzg43Ck9Ltjmy+1wdMKUkyf5dBoIFLicb23RZL0ZrqdpLJVAB8y0qp1lx9xTikkVu2jU9h4tHbqC19oX/gDqu7qNEm1PaVZlt1/k02lz7Au1u19aX2g/9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

Correct minor spelling mistakes in several files under mm/damon.
No functional changes.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c             | 6 +++---
 mm/damon/lru_sort.c         | 2 +-
 mm/damon/reclaim.c          | 2 +-
 mm/damon/stat.c             | 2 +-
 mm/damon/tests/core-kunit.h | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 68dd2f7acba2..da4820110e48 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -284,7 +284,7 @@ struct damos_filter *damos_new_filter(enum damos_filter_type type,
 }
 
 /**
- * damos_filter_for_ops() - Return if the filter is ops-hndled one.
+ * damos_filter_for_ops() - Return if the filter is ops-handled one.
  * @type:	type of the filter.
  *
  * Return: true if the filter of @type needs to be handled by ops layer, false
@@ -1586,7 +1586,7 @@ static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
 	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
 		10000;
 	/*
-	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
+	 * adaptation_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
 	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
 	 */
 	if (adaptation_bp <= 10000)
@@ -2756,7 +2756,7 @@ static int kdamond_fn(void *data)
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-				 * if caluse.
+				 * if clause.
 				 */
 				ctx->next_aggregation_sis =
 					next_aggregation_sis;
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 49b4bc294f4e..9388b091deb7 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_LRU_SORT is running are not
  * applied by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT
- * reads values of parametrs except ``enabled`` again.  Once the re-reading is
+ * reads values of parameters except ``enabled`` again.  Once the re-reading is
  * done, this parameter is set as ``N``.  If invalid parameters are found while
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 36a582e09eae..8463a5a5032f 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
  * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
- * of parametrs except ``enabled`` again.  Once the re-reading is done, this
+ * of parameters except ``enabled`` again.  Once the re-reading is done, this
  * parameter is set as ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index ef0a1195a584..5e18b164f6d8 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Shows data access monitoring resutls in simple metrics.
+ * Shows data access monitoring results in simple metrics.
  */
 
 #define pr_fmt(fmt) "damon-stat: " fmt
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 8cb369b63e08..f59ae7ee19a0 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1159,7 +1159,7 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	damos_set_filters_default_reject(&scheme);
 	/*
 	 * A core-handled allow-filter is installed.
-	 * Rejct by default on core layer filtering stage due to the last
+	 * Reject by default on core layer filtering stage due to the last
 	 * core-layer-filter's behavior.
 	 * Allow by default on ops layer filtering stage due to the absence of
 	 * ops layer filters.
-- 
2.47.3


