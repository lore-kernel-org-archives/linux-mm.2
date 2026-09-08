Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA82C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD366B0098; Mon,  7 Sep 2026 23:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8E76B0099; Mon,  7 Sep 2026 23:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3748F6B009B; Mon,  7 Sep 2026 23:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3E826B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:41:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E711160340
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:48 +0000 (UTC)
X-FDA: 85189195896.01.D5C5EC6
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D20118000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TV/1aYmT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x85G6XSZMPbShpb2Stt/88wFe29r9gOddAkxFMBCHY=;
	b=YfygHABwtwt4IkBp1JEyLXkWVXcN2Us0h7Bd9k/erIA3l77A7oTuhjRq6513R/hQyM3IGg
	PrDzkHJBV3qaPJ4/cYiDaATbZqCAMo7jBUQ0nA5HR05+jbBGnXM0ZtM9bHoGl6CXoFzgUO
	Wbb5MUPzG3wFWEyMy0yenlSzQiZOBB4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TV/1aYmT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838906;
	b=zJAp1CfXukS5X39UcqdWGP2hZXBJLpZqjplkizW2AJymwnR20WvI71T5OGItdYfjRsX4V3
	hrXYFIjTIo38z8FtTaYjw99z8S9mY7z3XNpfDMigl8dCC5qDLjb1GozxsyM7IQJAI/1aUD
	L1umhhvXCFzeZjq8qctYUelDkpi3MRU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fjfBBGmsJJ56y0JVyIG84X0Pp//85lfIIw3IuGHXEuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838905; v=1; x=1789443705;
 b=TV/1aYmTB6zEuD+B0PHKtv1u1K1lnMpW6hxK9r8KoQP47BTsSpXlj2wqw9OdbBdeosF/HZdE
 2Cu8FFePzLLpExSt6G6D82Epdu6UzLk6PfbIemxvKwvJ3A/RlCcmJamleL8jPjJsAIlZrEFg+BT
 Ww8fDQfzKzNL4msglA59OX3Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 20f6f116f302dedc;
	Tue, 08 Sep 2026 03:41:45 +0000
X-Mizu-Trace-ID: 20f6f116f302dedc
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v4 3/4] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Tue,  8 Sep 2026 11:41:13 +0800
Message-ID: <9ffdbdfc96312e3e13cb8f056bfe26649492d949.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D20118000B
X-Stat-Signature: os9g4oid5unqefcip8frxx4d878okxj6
X-Rspam-User: 
X-HE-Tag: 1788838906-310578
X-HE-Meta: U2FsdGVkX1/x1kgWxTPjzYReKKsITeHQMNBH9v5w48TqamkTlBuScCsSJpe7usN97SdxD9v53wMY6A/BzSP8hcAcCO+MLsE8c/6ByAe0ludEL9g1FFSxphTfZtUmZARJV3fJUAdzsDeGqqSDE8LgNQZBxn8DOapMxOiOgH91vHMflEPxkL4vEpBbwLxKmdZj1pMJJbyYtmmarvusW7sJgEIkPPTTfoW3klfQv2CPrezBKemsBtSm0fmqv2SWyPiYeRmebpbB/EiKHng1d0vSJ718HEbRrvmarrtGOSVUAkhCDzXanykwtkH2dUNt2qfUr9DbFRnqWYBZ9gqq30rncGAOZDHikUwlsUu+fikR7hjTWC0JSgjHqMp5AOfpe/prp/XaF2fWO+BVjD0ZxNJVS+lyfJTw+h4IX+DcOfn8yvg2MdEdT+LZptL4kvBSFg0DSuwsGR7nFdCb2l/ftijm08rHutbtHNf5Cj0lKURPkzPY76F3WIa16SEIIhpoT+ZiHepaErKxM7vGL3Jg2wtSkyw9O6VCRgwBb56twS4p01FQLXI7nGyFBN8cApldipREgD8D/IKX3FAV/oUxBY7cVtvUTlbm9neHjKbl7VmXnTrdTmqp6GIniocicWH3HCMj7wHjaLCOvo2DeUpDxHoulrCwr36bBsGF6vWE0uZGUkm8p15y3aCCJAqg/b6TcRRranNC+FsQ/K2araIe71XEwVCu2Dd9Gm1l3e1wcMUhV75oqsC0YfQ27/21eyrNcT1Nw66mMzyW0/Cn6Pp/pjbsx9LnwXNuDOw6wgBxes5SY3dDcAKUdeSW6IYqUf1WnE+nPoEztifEzY7CZfvhEh8F1ETaT4L1cF48u6EBpjpoAXDidPGhje2cOJouT49byiGtmMULJSII5hAtFoPfJHpIr3Qa4QiCL57zfhXW3yRiBH/uBocm2yoFfpTYA5hvcReheOoC+hoI6+ie7i68uRL
 P8hYe+4h
 oldd59EUad38IdMLawAZA8CvDE9p0dncKwCOkL3h6RNCjUol6+QpM/4t2kKVEO61PLH8ZswytiJuSzIT85T3QEinOJSn9COYN7tRgZwcm09hOUQa9o2TbkkyGopwRKttENk0JfK1ZyyDQKo3ULdcODBpciQvIC/zChKD+4mCh5eC3YKA6IkbGCUtdhdj84IXfaIz3XwGFq6oSWeV6pCB5gS36L9DkT6MooFhQGGqu5iDjIow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ace9fe2b46084..9995f3d2aae1b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -853,6 +853,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -864,6 +875,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.43.0


