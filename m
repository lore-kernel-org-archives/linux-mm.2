Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56F6C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5236B00ED; Mon, 21 Sep 2026 05:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCB76B00EE; Mon, 21 Sep 2026 05:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E30C6B00EF; Mon, 21 Sep 2026 05:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44FA16B00ED
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 851D41605D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:11 +0000 (UTC)
X-FDA: 85237230582.08.69AC2EF
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id AADC740004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D9oKassi;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WveanIwZrUWrtGq+GmvS/4OvhcB1L/zfZWWHGMu85ZY=;
	b=nof5sy95eYlaHVpZgvGLTLUvnvpWIyDW3O8SoemLyVBzS+nI16qowI9gfq9ULlhLUtkAC4
	S/cjpaZ9deQpkRefJE0s4JFUsFgMD0ekoPgcHpt9sflvJNv9J8+P37FF0wD80SiIcCo3XB
	tLHSWduco9zHSwp3GTAECunX4y6L5PQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D9oKassi;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982589;
	b=YTSrIBnorwi6id9W2QjYzSkTZ3KfoP7TPS0dEF4oudB4XTgMc53geh/qc0MjSQieaQrXY8
	0pzeHeCxuMKSwH/ZClSU2IEX8QqByJsZBbuvNCjPfAV5judRzOcWA02EHiQBv5g7f9kyEf
	FrErrlDZ2OsLRjh4szZ4GHT9o5BdaVA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=66wflbyis4BetWzKnN/o4fNs3siEXCRm0GuSiVvDJXk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982588; v=1; x=1790587388;
 b=D9oKassi8FGfFTqHza0cIFeIN+4H+uuY20i2nfNdFOhWsqPLrfrXKez6NoTGByO3MB3Es2Dj
 QmMw+w10l3It6/ORf8KaIKeRqbAeqzz0Oa7gJzrNQe/iWWwO3QPIUDpM7VEBgiaKfrpvG7uouqF
 DCfUE+CZSkS6GWrAyHEvjhk0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 515370f5e6daff6a;
	Mon, 21 Sep 2026 09:23:08 +0000
X-Mizu-Trace-ID: 515370f5e6daff6a
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com
Subject: [PATCH v4 07/15] hung_task: convert process/thread iterators to for_each_*_rculock
Date: Mon, 21 Sep 2026 17:20:53 +0800
Message-Id: <20260921092101.89285-8-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AADC740004
X-Stat-Signature: 7npjch6e7o6cn9yjdwi4t8ck4uahe75k
X-Rspam-User: 
X-HE-Tag: 1789982589-337717
X-HE-Meta: U2FsdGVkX19q4HWdFfqYpvpHjTtVs1IRuqaTcBnCaO0aGPwhOmSqSP6aMFj+GoC1nMk8DLz8LSl7zk0ZgPSSsL/r/eHk2rHGbBJ8L9h4Qamx7I/hX3PQvxSgUElgWQIQQWu5sdJVYd+uiyha3byKyrTjiG+WT1U+qhYGq69OxcRlPKe0Y8DCr2b502fcGwc80xR+yZGSlfWTl5O6sCGwrtwSK2s5vU4yyX3j+NOZ6+QdVOFyUJDkMozxazb3EqHlxJ63CABOIEp+IYiW/oQn69eXWT6bFdtSw9OZahofaX3VSxjYrTvCt4MRSU2JzoFKgsvyvRyg2ZuYp79fphoHqP0lCPtDhnq3zt8GJsBKz9bb9f7+abMMEnhBvmDMXcCd5l3EVjovBeolnobdhdLpfDqC2tvVwzz++c+5QssZsQQvNaDw7Xuo4bIgzVKHVkJm7d64oEEk+p1gxYv9Bsi3h96F8EwL7yoWBluOnndF/1/wDOc0yhW7Wg+pvuQm4gowNeLwPPcngn5VJYSmywPU7yi6aq3y4AaonPklF/duwYGq7jJ2Eii4QAgnqFDaGLgAGotiXr3xPSgqrSEWCCyxVUZIm8zomodxnrocyDMBDPxqLfHttl4Yzm/nUpJTsp2ncr4pZxdtKHWVwNs10Q5JUylUieZ+J1B2dfX1/Yf/2sWgBnFS9TxoCnfLIOVArUJi+qgBPrFpMhEBZa79tZgDYexG3qD475h3XgjGoyuzguLHpG9YzDR4QIqnJR08yYG5BR/6IWjTaUpm7mvilvdkPCgP8lAp9+/PlKisir72+/E9zAbZwFs0bWA0HYPf7VUh1/jZXXlycd3jJWLmV+9SoYM8MXbPOGHc32eAZzQPbc70j2e8RHkhIeAteHWv7eSsPLYBW5IEfh00CR/lPM0yBqkTzNTe9pYjWABKnFLtxgaba3cwrYO+1lZC/OrlKF4qWRCGkNamtmuMNzVvEup
 aLSaDdT+
 HrGPfIgElA7AaQs8xc1FhSq9akr+JuBm2f7QeWp97+/ukrPvWBFlme0p1dxrz59PKfNsZGS7uHYder6tJC5ojOJJh3m5qEvcUz4+J8SX6Fo2FhkwCC96UvQOsNhAU+nBR/EL3+encl1Z0j8bxGYpLpOr3JaPHCc1F4VxO1pIaMCoVNNBLLlbyI46MJ/91TOWgRT18By6cBgyBGLL8aJBDfPdABjNCiRotZuDpWQjHHrZFQw3uZOldghvkKKkOVw8DiltkwChiLvWEPs1lVj/mjQkWWZCL9OELyxGFbQp6Lk3YuuBoHUwtAblzFdRXx3cK+k2THv+Q7N2d/8jYTD2ZcgfJ0XccO5jggmq32sIR5w6VfbtmQjiobuVHAxcNGJCEsvbPqZR7/hTkyIzgg6Wm/usVe9xPzulZGsScK9ZZD7Z3y2ITQk5DrGxI+B9tKWvrsPEh1DDPb3stmeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/hung_task.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/hung_task.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 6fcc94ce4ca9..73a5ad3be9a8 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 		return;
 
 	this_round_count = 0;
-	rcu_read_lock();
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (!max_count--)
-			goto unlock;
+			goto out;
 		if (time_after(jiffies, last_break + HUNG_TASK_LOCK_BREAK)) {
 			if (!rcu_lock_break(g, t))
-				goto unlock;
+				goto out;
 			last_break = jiffies;
 		}
 
@@ -337,9 +336,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 			hung_task_info(t, timeout, this_round_count);
 		}
 	}
- unlock:
-	rcu_read_unlock();
-
+out:
 	if (!this_round_count)
 		return;
 
-- 
2.25.1


