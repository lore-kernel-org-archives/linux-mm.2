Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AB9E92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22666B0095; Mon, 29 Dec 2025 09:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3536B0096; Mon, 29 Dec 2025 09:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DC76B0098; Mon, 29 Dec 2025 09:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C243F6B0095
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:55:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61A6A1413FD
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:55:50 +0000 (UTC)
X-FDA: 84272808060.10.9D741A2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 220A9140007
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:55:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=5x9c8EeesffbZC8AwsXH9JiWTAJOcy7qdkzfj48Zf/A=;
	b=U+CX/9mvjGUgFzFI2InGEVYvwh/um3h9S4AfEEsFhKDqkzZ/5ERJIswYoJkZHwvLfikD9n
	+85/DsttACCYOhS/18Sz41Y1Q46UzkFsMwv02/OhGjJwUqNtX+g53Wv8pBVOi6XC3MJfiD
	qzLQtWjrdzQc7/Axwi7CGsGFsP71fbY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020149; a=rsa-sha256;
	cv=none;
	b=nKi5WfDBxcSsHkfTVcPcgDU5FXzOSOsRLEIgo3oCjvg354hPrU4ukxt7mVZ9dvNzWumPzK
	Uy08VjwzN9zULYXLF33B0K+P4gnG0PF7WpH7woK/NMd8k6OaEbHLSn5CKMFgeecT3vLM67
	XH8hLj9FgcmUIWTi05z5JtAUI5soVSs=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dfzlg1dy2zJ46DY;
	Mon, 29 Dec 2025 22:54:55 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A3DD40570;
	Mon, 29 Dec 2025 22:55:44 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Dec 2025 17:55:43 +0300
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <sj@kernel.org>,
	<akpm@linux-foundation.org>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>
Subject: [RFC PATCH v1] mm: improve call_controls_lock
Date: Mon, 29 Dec 2025 14:55:32 +0000
Message-ID: <20251229145533.2437293-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam02
X-Stat-Signature: wujhbntmym37y5mq4abzzpg6fhgno671
X-Rspam-User: 
X-Rspamd-Queue-Id: 220A9140007
X-HE-Tag: 1767020147-749500
X-HE-Meta: U2FsdGVkX18S/TZ3Lwkcat15nVby5gymLud0uHnHPM8Q6sWyHj0G4pWilm2F+Yuo7UaXXBO2g0LINBJG74vdK021ruO54i1j8Dt+BzvasKrJASHS+BtoB4QMweyRRDl5lg9wlihTHcsMNha425XrEc8+vtoicfJxpb15EXGHQ+Vjvw1IwkQfPeHFdsgtigJaXVI7eX02mYWYLjX3Rn4CfeYoj+/ELGUg8gbZgRbNWexIwiSpC4FwS4LsUDeosxGjcrp0DZDQUhRMjiangfvqEgh+IoRYBG3oi8RSoUG5lIJfYFfN8W6FHvbqCXKLGi9WQiQcgFDtg14kTnau7Xvzp9fwdgbwDKkFxh0xV93I/Mea95syDygSt8UKXHmOUIEYnehP7tXmphCxW6xKkS9S/Vk9MtNhS2l2ZMnnSU5SO9nDcVmr+q4ccCuLDGIOqQmKQtV5xU/3bv9KN3dtAzilDoGlWCf0JeMWgtRoy1WBBe5Iq6UVg2qImE1aKw3/11Tg/JqY5UCvAebqzBbs/uTzq7l4YG7Ij38C3HrkLV4x1CtLCNrgkdgNBF3yDnJ+1HTxKmsfm3jIG47aq0eEz+BKhBHElePM5a5Rf826RruqvjUt6BAjPE+oFy3GTe8e99vfO+qzCH08DMelzOjhDBnMURV4KFM/y2iW4stMsQVBVOdnPjb55fpwf4RMm3sHulOMhAbgmOlCuxZkwHg2R9v8dCJSqXwvNeVhsm9gA09EVYPHZVrnQVQYABcfkN11OaswQ9xhYwGc0d5sD8MOd1Kht/+YkEbFnsHY2JoqZXTem0KqmruGSzVHnmKLIfrd+7P7ntOyHk+f0L/DSgoYBKp0m/vVGoh7COgqHIeZfjoMINhZvc+tIErxpm0p5/8zgb0Cw7cgd+N9LCz39j1s/T0Igg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a minor patch set for a call_controls_lock synchronization improvement.

Spinlocks are faster than mutexes, even when the mutex takes the fast
path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.

Initial benchmarking shows the following results


# bpftrace -e 'kprobe:kdamond_call { @start[tid] = nsecs; }
    kretprobe:kdamond_call /@start[tid]/
    { @ns[comm] = hist(nsecs - @start[tid]); delete(@start[tid]); }'

@ns[kdamond.0]:
[16K, 32K)            22 |@@@@@@@@@@@@                                        |
[32K, 64K)            90 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[64K, 128K)            0 |                                                    |
[128K, 256K)           1 |                                                    |

@ns[kdamond.0]:
[16K, 32K)            19 |@@@@@@@@                                            |
[32K, 64K)           118 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[64K, 128K)            0 |                                                    |
[128K, 256K)           1 |

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 17 ++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..43665e63a498 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -801,7 +801,7 @@ struct damon_ctx {
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
-	struct mutex call_controls_lock;
+	spinlock_t call_controls_lock;
 
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..a929bdf3bc7b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -539,7 +539,6 @@ struct damon_ctx *damon_new_ctx(void)
 
 	mutex_init(&ctx->kdamond_lock);
 	INIT_LIST_HEAD(&ctx->call_controls);
-	mutex_init(&ctx->call_controls_lock);
 	mutex_init(&ctx->walk_control_lock);
 
 	ctx->attrs.min_nr_regions = 10;
@@ -1457,9 +1456,9 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	control->canceled = false;
 	INIT_LIST_HEAD(&control->list);
 
-	mutex_lock(&ctx->call_controls_lock);
+	spin_lock(&ctx->call_controls_lock);
 	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
+	spin_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;
 	if (control->repeat)
@@ -2549,10 +2548,10 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 	int ret = 0;
 
 	while (true) {
-		mutex_lock(&ctx->call_controls_lock);
+		spin_lock(&ctx->call_controls_lock);
 		control = list_first_entry_or_null(&ctx->call_controls,
 				struct damon_call_control, list);
-		mutex_unlock(&ctx->call_controls_lock);
+		spin_unlock(&ctx->call_controls_lock);
 		if (!control)
 			break;
 		if (cancel) {
@@ -2561,9 +2560,9 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 			ret = control->fn(control->data);
 			control->return_code = ret;
 		}
-		mutex_lock(&ctx->call_controls_lock);
+		spin_lock(&ctx->call_controls_lock);
 		list_del(&control->list);
-		mutex_unlock(&ctx->call_controls_lock);
+		spin_unlock(&ctx->call_controls_lock);
 		if (!control->repeat) {
 			complete(&control->completion);
 		} else if (control->canceled && control->dealloc_on_cancel) {
@@ -2577,9 +2576,9 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 			struct damon_call_control, list);
 	if (!control || cancel)
 		return;
-	mutex_lock(&ctx->call_controls_lock);
+	spin_lock(&ctx->call_controls_lock);
 	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
+	spin_unlock(&ctx->call_controls_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
-- 
2.43.0



