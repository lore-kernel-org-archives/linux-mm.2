Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA7A606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SioBXk9L
Received: by kanga.kvack.org (Postfix)
	id A3E7D6B075A; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F59C6B075C; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3226B075C; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 599DC6B075A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0E8F1C46FC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:48 +0000 (UTC)
X-FDA: 85470415296.08.44BD379
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16479140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SioBXk9L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534607;
	b=ETGU9DK37H1MZTZQHNgg4RTriDPvTqhvMcu8QRW6CzZJ0KhrsQut/iMc1Z7sjT3u0eYHFi
	O/KYbo/BSwJ3SVhDz7uX/soCuiVUL/vQTPD4pahJl7YtJHtWzFAUPhIZuGr9yd8KmcrTQQ
	DtDdEQQIeTy8Tg/XEHKGcsZqmK10UUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N++E4pV8FIbWrmNbMjepL9j7Rj9OozUVn9hIC9L/F8Y=;
	b=QEVRO0s2YxCe9dIbGmcJE3Ym6doJqCyeQPI8W2ktOlPnMLfQQOtf66+bw+hte/B+19+cj3
	W1PI65IbbeeI3BWyB6HoJkV1DTBzIl9xtUXkw2hfGqRBWFPA5x3QVBUAAzOQ5sPqm2uOMY
	Sh4EU/7kLhlBm9DHJoBzVXc3pgwD24g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SioBXk9L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5914342378;
	Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851981F000C6;
	Tue, 24 Nov 2026 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534605;
	bh=N++E4pV8FIbWrmNbMjepL9j7Rj9OozUVn9hIC9L/F8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SioBXk9LXlV+XCXAbx3ceUUcS73AYNwgUvJHDFU7vTJoowaZ1FNkoiqXmaPFhAsOr
	 5XJj8tZQGGmqbrqxsSdidwxd3yAXuLZf6JRbRLKLfzxbMEKBp/mALVjP4oN9NyUmyR
	 NcGqzFTUzutQj62MRcA82GYJvTP05H6zpExrbk5MZRz5ogn44xlR+S4OetSgnIdRVu
	 GBMhAmFtrdZA9IKNBuyHyv4VZ7dqtuPBdUDqtedUPi5bmz9EbsV6+WT8aKRc8Q+EqT
	 xTDenoY/s0T7peXAOtfY0jtSqyophi3KyEaEYbKrToyLFrJ6y6LdqzZJKEY3/PKHmP
	 qkDaO/HQzyiyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 02/27] mm/damon/core: implement data attribute report queue
Date: Tue, 24 Nov 2026 07:36:08 -0800
Message-ID: <20261124153636.91854-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16479140003
X-Stat-Signature: rp56d3j57upo94ye5f93f7nj5w7y8go8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795534606-522833
X-HE-Meta: U2FsdGVkX18CAwL2oG685mN7jr80MdYRlj9Y6tI1PtL2W7O1qxJeEIb6LSn2Rb7KHPv2xzWCzuowEsC73J2Fz3JK7k/x4dYfR/0DxkmRHw9ivISlWf4Msib2UUh6N3FOludAstJ6YfWED2qmf5O4PM6aNh4UNmzwMJvpQ8h2M5LP2eh0q8mqqOrfr0ogYODz6RPs1HT1cvcii7rj/MdTDPQ8fG0EcBQNDbP7WD7q1AK/8r3JVGXk4Lqas3RPwlMEKWRcNMEfgyf8Hguaip7tEqb+T938yxQ4Z6b8rzgWl8MYK5PAWwOHSwk5aURvfVbZU3GTVaucT/MLglgJqOx1vh5ax/j+GkLPuzuv01OoPfhRaNRIVrncQbOq0cJE87mYimN9XlS1nkk2sLRcWHsvV6ga2jd9TzGNYD+r6DSbW7ToMCL9b1/QQSn8TIzhGydyNM5+E01I7vZ/+M5qH192NInhuSha5QsJH8eIk18jiIcfp+9tCHf3udeb9UJTME/wm2EOUZpHGm8DClmSoCUL5ob3irTzM4qsy2tK3M2esjIRT5X3KlBlEi+ItdyRB1C5QMvFpeM1HPurR5hW70HWL4zHhAA8sdcFLMqn0itTPqyfoICECM3hrMk0yw+31nVLvelTBJG6OJuL6XcxioOTxCbgH9vbaE78Lzg7v1PL/E9arqg2V1iOeuYtk5p5FyCy7vhifsvx6cadu5BvkRB9DL9vlxT5NLYcTI05Y4uxYz4qRsSYYYqUcoqTB2ehNjUCiyvLAsae3WbgzkrEK7izveMl+nxjC6wi6ZyyJ8wjMQrHqqdVE9cQtjtsrIlRDNGpWIIpcjk85PDp8ovuL6BVb/oSmWqq7uA82uoCGUIu4vbi6JT5BIw7YrRFoMaEiUqV1LjMCFppFx4+LcisS83K61WDocO7njS3chMfM6sYqSSNJ7vZurX+qRVcMAm9djx5ktfdLGT8uaxNKfyNW+p
 nv266HlF
 rMsRgUmxe/STYKw0na0CmY/LLpc+jxFpxbGY4qQcxYXIugr7+Gw8bBbDi+pRMOnodVDAP7NaWty0Kj8oJep899bLhHLu4h0r96PQ4MN0e5pQ9aWe2Eyk9lPUK+1/0BfJqJzt+/yMAmlzvNc+eczTMNpNHOj8BnZNwBsaT8q50S6nrZGzJYfJqzo8rwLiAOK79MbC14Ys0DdRQbof628fFxfi9LKbL2Jr+tn9guy395AIIKWyX8qAgLmVKVAMY1RlgkkN4TrZLH59cfDs3M1Z8WsrgqbJlQhfKa86X72JoN0CKde8KPuYtbSHEFxBxd0NiLs04hHMufcMrJE+8/KZpETpVtWg/rKj/SxpyF5aye1l7IpiKRzsJOA6v7y4ph6CaoizYJWVmAU3S/iKGSSyCB/cmKa8u7CC56AX4nfLlmDOZtvn3+BswisNlLnL2g7IweMaTV/3KcKrocDwrepEQyIu1UAmxQiYB4KuKFez0ohIXt/Pm90qPMpnsA7QCFQWVPAip1afXQmGwuGjwNXu1WdL9+dpNLIgn57knqRcVMr84w/Rn+rIQo5zF9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement DAMON core internal data structure for queuing received
data attribute reports.  Initialize the queue for up to 1,000 reports,
inside the DAMON init routine.  Destroy damon_region_cache and reset the
pointer for the queue setup failures.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 649a4ac968abf..8293b69169856 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2337,6 +2337,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
+/*
+ * struct damon_report_queue - &struct damon_report queue.
+ *
+ * @lock:	Represent if this queue is being used by someone.
+ * @tail:	Tail of the queue.
+ * @size:	Size of the queue.
+ * @nr_reports:	Number of reports stored in the queue.
+ * @reports:	Array of &struct damon_report.
+ */
+struct damon_report_queue {
+	atomic_t lock;
+	unsigned int tail;
+	unsigned int size;
+	unsigned int nr_reports;
+	struct damon_report *reports;
+};
+
+static struct damon_report_queue damon_report_queue;
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -4323,7 +4342,7 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed)
  */
 bool damon_initialized(void)
 {
-	return damon_region_cache != NULL;
+	return damon_region_cache;
 }
 
 static int __init damon_init(void)
@@ -4334,6 +4353,16 @@ static int __init damon_init(void)
 		return -ENOMEM;
 	}
 
+	damon_report_queue.size = 1000;
+	damon_report_queue.reports = kmalloc_objs(*damon_report_queue.reports,
+			1000, GFP_KERNEL);
+	if (!damon_report_queue.reports) {
+		pr_err("report queue alloc fail\n");
+		kmem_cache_destroy(damon_region_cache);
+		damon_region_cache = NULL;
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-- 
2.47.3

