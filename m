Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB0E606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HAnxMb7g
Received: by kanga.kvack.org (Postfix)
	id B75DC6B05B2; Tue, 17 Nov 2026 03:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26B06B05B4; Tue, 17 Nov 2026 03:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A602C6B05B2; Tue, 17 Nov 2026 03:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7DD6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:04:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B8581A037C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:36 +0000 (UTC)
X-FDA: 85443874152.05.4765D42
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E909100008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAnxMb7g;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794902674;
	b=qL7WLFn0ucAOB00dZ8+bsaEMQzOAb9PV/hNuIeDQGgaSBgwOlKyjwDF1nJkNk/m8gnVBQE
	ROOYn0XgFL/bjuZii7A4Fuuy1g+BwhjIs7Amb1mYPYznPKl4YnL3Ts0O8STSK51QfjbwBf
	kv25yp1JWfmO9yBxUgXd8qbWywX4y9w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAnxMb7g;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794902674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjhDYtdm4/pQJcy2Nq6/VwI3066PPOd59IcuMnYXHok=;
	b=XdPh/EyaCCclc2Tn6Xo8jn91L7QkQO6CHmfk9B0H+nLppYvXhD7jXqQn/I/Mb4wpxBzokN
	1eEOUdYPJtG/A09Rr20Ollx8DvV9MAuYp+iaZtUbDFhYBZlc3UHCup9in4yOrGZd5KanYX
	C19c1Ps9XyN+rjFgQD0XaxyAZBr/nZo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tIZd3eeHeKEfMcEKXFH5YHQpdMOXGI0H+yUu5ZTMA9E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794902673; v=1; x=1795507473;
 b=HAnxMb7gG7n9/CDjQ2lgY4jNGhnGQXAorlcDp5JPO6iaUb9qklCz+7BqgpGX+FxkiHXxFqST
 gXjVDMVvWS69YleOfAhqee/ffXnz+wCPpDD88l8t2CSyfcSLFyRms3J+70k8tYrLaWzjyEpmWZ6
 iWBTkicnQMvY2ejUk7QyH+8w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 86acde6d42413ff3;
	Tue, 17 Nov 2026 08:04:32 +0000
X-Mizu-Trace-ID: 86acde6d42413ff3
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
Subject: [PATCH 1/2] mm: memcg: fix zero throttle delay on 32-bit kernels
Date: Tue, 17 Nov 2026 16:04:20 +0800
Message-ID: <6931674296b98139f5e02821d66ad1855eba36c9.1794902513.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794902513.git.zhuhui@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4bufebyc5scy759ku1q8xtf789kc67iw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E909100008
X-HE-Tag: 1794902674-526336
X-HE-Meta: U2FsdGVkX1/YAT/kWyLRjk/6kSN3Ok25HK54za8zXr/Z3y/ZG+bTMhF5TWXU7cblcZS3n/sAbGJzTkum6Se433QZIEyUzBnf5F3ud+XBHvhPOtIjW3sJ0Ua9AMWCNUq/uj68+rTy58oocLKQO02RgOkA3WPfhxnCM+xkwEs05bts7y9Sg/B/1VVmVlS9juL1TiTNGjqkIpkaVLiSh2OqoIOebplX5XC4Rp9o9wXcUoP9ULmT1nMlFDEmxx7Mr/VqK9riKEeIs3aphwQRGpiKO1hsSM3FJR4duBo0rovzY8YIPpu37TbRXxifGSD8ZO9raxIiKyO01NvpFs2XNjl4UxMLRRPD3Z8YiOQ22DZZKNCPuTPcuEoDjagDXxJldfADhyQ/u78hOd/XxPAIhD+3yC/cVuL7++OC5kT3OVoq5lrFjnYAbMqIf30vRRO8SKE8LynHrs+vtoh4gPm6d2bNLV+S/uuWBA8J3g5Noh2isPt/pr8iyRQtvlAEDOB+abQ623XZEZ+Nr0nN4U835hFmJ9NIIUfS1gGHJf3bl9I4bxqq/wll1B5a07qqZnD23BzFcThtTqQBGqHV67XfOUZH5p6OIliCJ1pnyl00pMvi+UAml75Gigpaoq2w2Qp1YXJGXWvwQlYDy8MvtiuqzMCP7d90YXISyi3zEYuFrY40C85/khQF4xJiXLX5Bv/VZ4UFb1W1OqEUkEIYW5klNCKC5tgsS+t1gUD529IuiAbcWQJOPQ81sFx1PgEgdy45caAAGtIp80xLY/re7Tf2NBxqEAgRrDTY0qdvOGKZh1f/e3ijMiBAzAUekcWtc10r9tiaFVPB1SZ3w/pCG4pXp9+NAtMJipzfh6BMNhR9wNhSZeCNj8UVqp3T83PQxTrLzTCrV+g/SmGVPtUnqZI95B+sWVUnXO6wUa0PGzcXr3IiAy7WK/diZkVCMQsgbzeClm4CABfMmo9XaKjH8GQ6+H8
 TKzOpJie
 4riUAEKpiwe1HFzHkoazgEJxIkt5RSlXySLX5pQNBUM485U3UotAkEVD/p37O6leToIbI2Yalur6izBoAC4Op4Bc+z7gQ1PqLazB/V1/iRS6t9kgJx+zB1a+hLFyZtWEiy852cyhBJuHDADTcLU2WpBAUHleyhV6loUAkd2o94e7DYK14ODc+uuGyiTJ35ZjD8ly9+Sh5sOpR9IVMFhrkuCLl3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

calculate_high_delay() stores max_overage * max_overage * HZ, computed as
u64, into an unsigned long before shifting it right by 34 bits in total.
On 32-bit kernels the store truncates the value first, so the shift always
yields zero. Tasks over memory.high or memory.swap.high are then never
throttled, and the reclaim retry loop in __mem_cgroup_handle_over_high()
is skipped as well.

Keep the intermediate in u64 so the shifts see the full width, and clamp
to MEMCG_MAX_HIGH_DELAY_JIFFIES before narrowing to the unsigned long
return value: a truncated result would escape the caller's own min().
Nothing changes on 64-bit kernels, where clamping each term is equivalent
to clamping their sum, which the caller already does.

Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
Cc: stable@vger.kernel.org

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..1ba42724ed1e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2576,7 +2576,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
-	unsigned long penalty_jiffies;
+	u64 penalty_jiffies;
 
 	if (!max_overage)
 		return 0;
@@ -2601,7 +2601,13 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
 	 * larger the current charge patch is than that.
 	 */
-	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
+	penalty_jiffies = penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
+
+	/*
+	 * Clamp before narrowing to unsigned long: a truncated return value
+	 * would escape the caller's min() and look like a small delay.
+	 */
+	return min_t(u64, penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
 }
 
 /*
-- 
2.53.0


