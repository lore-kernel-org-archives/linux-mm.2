Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC4E606A332
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aujIHuk6
Received: by kanga.kvack.org (Postfix)
	id 15E416B05B3; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F9F6B05B4; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B846B05B5; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCB646B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31747405A9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
X-FDA: 85460344368.01.0B176D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 902F140010
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aujIHuk6;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294822;
	b=YJDRm2s7sanX0LlnCOcGhg0WG/o6cx8vx7Xv0QI1AfB1TIzSVHlyo5GtUwf4VxrsrdYSiw
	LTBqq8JI9T/3Wh0Hk6ldccJ1nMLyvtjBbZNda+8+UQJhvhQ3acEQea13P5r6bHRUR65etU
	GecfZWQPJwaY/b9TLDlhrQsrMiuCNP4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qODSwcOx8drR2fM0wupQ27EAjv8adfz4mjkG8/g/heQ=;
	b=VApWikaR/XTPZYaWQLg0R4NSI+JLqwF6PxTtX0bXQeMMRndR1l+576P03QkL2Ei+gL2cRz
	XWknkp+fO99E3qAGPomlz7kSLnx2IjxkF2H4fjEY/ia4p3Qx/76McRL2ILmiWNjy1ZcNeQ
	8AhI81pZIhDzTUx6H6vtZmy6FSSaoIc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aujIHuk6;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D26061CFC;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BA51F000D8;
	Sat, 21 Nov 2026 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294822;
	bh=qODSwcOx8drR2fM0wupQ27EAjv8adfz4mjkG8/g/heQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aujIHuk6lVyURbcrdaYhrf3EnzzJ2w76FvZPXEfe19u2bY8RsIomGM+iK+fHShoLf
	 kl3uhZ+6pvqGcuJP4w17CaThwSD5dkZWProPeRrCkG+FFL29yQAbfEMGxYlYTFicYN
	 Z8SKvLMsR1Ae1zkGRV7UwTdzohceM87UBZd5tciW8+9l3/UnV+yayKF/VZED5n1wV3
	 KFZJ0a7QNu+18ilyC0x1zcJYdYfGoptssJNtdZpjUrcpbLuQgcJu6My4NJ6wn8DNyO
	 bz+C/I5F/3KNpl4UEIogWlMyYnNOU8gGU1i1iU4eXiRtaCASpVhjtyU+un0XiOqBuL
	 2pAK7ayF1E3EA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 02/27] mm/damon/core: implement data attribute report queue
Date: Sat, 21 Nov 2026 12:59:46 -0800
Message-ID: <20261121210013.130397-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 902F140010
X-Stat-Signature: b19c7mh6wa983e1waa4c7j7tbn3qjsr5
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294822-517435
X-HE-Meta: U2FsdGVkX18GXmbt3YIY2PkEXfqdmWVi2lE9YF6rLnt4V11+J4UmGinWWPPd+qJo8FEfV9KxWkZJJnCgvPBM4/FLW4VkQ+BRGdWp2ZIOqaOZwhUTguug1J9BvXRyFls5XsAhEePff+g7VUsGZei2sGdOmYhZ8DVGhACOh24jJxFt8u51TRUWMVStgqg1f6Ohiq30esgZOpWQsjKqadxPmZ2urDXK2Np0EoREqw8+rsHGt4TSINDExyLGWq2Qwz4LeUYHVsvQ/glKzoqhfTgj4RBU9HEWvchTlwgWvI41arxkY/yj4j9aWM5pmiV6cJNr+4UbCtdU1uWTUThGaClEET/9bjZrxNM/mMUFhVsQALxI5nA+klZCgbrifFI9yCT7aWoa41yzIRqfy6UkJjNmLHLAaY1stnUNwYW7Jb04PdccG7RxfZME0j/S17qJRIRpccHemjMd4a2Hr3+LuGI33ogmJWuZn9Asjy4SHESYvzlvTrY2Nj1MUQ5scMj9W5JrWo2KkixtSYSMsxGU6jjXSxDHsS31D+uRnt4fZ4/XO6MfX/CfzZWBt33SrWZtZtT+v3oCEpYH65KcoyQn0IjUdQ75SUZ6qJemrAgyI45lKW0F4ijNSC4evxVWBRtUeREScDpHQ4hiyEgQJwlT3BkcxvOxK7RG1LTNr6hI9nWvQdy1fcDU28ZcwxVCIe8AiYQa5Jh9CCTzYVv5N8tmY2tX5LdT0+wZiE5fS4Jmcv6J9N24HBZw6hiFLacA6RWL244udrqQVVnLHwzaP1lrjCuNAOmZ1KLhVYUzur3qNd2VNNLNjkpL2ZhVJ16dwoYgKu6YA0XZwqcC1ZDFFG8X0rktB7WxezTZMk0REgZUOe9G05P0gn6rfxHr/+/HQHwWPfsGgL1NVv9/2NiwAfEb73cjkAAaPsXdUxnipvJ+ChEuY39aA28L3r2vZIhX9PAARzuwuYRdCPfeES1izALB2aX
 6KN2P43Z
 +v0Ys+Ed5W46OnyCiruAZQhJ/Zaq68Hh/yJ2fYza59+cNMMSIwxS9RyfJOCzEAqbRVA0fM3EQNu/pbljUpHTvrKPzR6e986hKh4zsAVNtWZqOQ+4BspENbaGvI3mKJUADDO3lNrSwdST7z6K7lS6FcTgCZ0Fru5JI44NSWgUo/V2N1Rb4ltriHmmbBE94RkSQuzys81chu+WmNrVVwIbPHfOT4Pmx+K28Xcsg5Io4BKwwOH4fzOO+ysaPQBtkqrE8S4R8gXtFis25rj/fYu4b16FlBTEHgg6HDPyA54mBjGO3VGpVJRu1F8mhL2o1yWjRu7Ktx3sZu4FWd6t+m2YgrKWr/eMI3LYtL+F6t6l4Lho97Y9ep33o5rnMGX0ItAsiW+nu9TmB7BtNoAI76UEqNgUWI3ETFUq9H9dLPlQbU87CzioDtiyBbDdv3Z7MpAuj3PF9KanmZv+MfUs=
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

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 986404b547ebd..b51741bb60e26 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2333,6 +2333,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
@@ -4307,7 +4326,7 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed)
  */
 bool damon_initialized(void)
 {
-	return damon_region_cache != NULL;
+	return damon_region_cache;
 }
 
 static int __init damon_init(void)
@@ -4318,6 +4337,16 @@ static int __init damon_init(void)
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

