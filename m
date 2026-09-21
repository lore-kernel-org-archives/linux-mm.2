Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C2DC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E862D6B00EF; Mon, 21 Sep 2026 05:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D956B00F0; Mon, 21 Sep 2026 05:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D176B00F1; Mon, 21 Sep 2026 05:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDA4F6B00EF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 332B6A05C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:55 +0000 (UTC)
X-FDA: 85237232430.24.41C1C5E
Received: from mta1.migadu.com (out-165.mta1.migadu.com [95.215.58.165])
	by imf09.hostedemail.com (Postfix) with ESMTP id 37895140008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nd2YedFb;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.165 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcNdv+jeQM0PUB4gEvMOPVpe39vh2JAVMrnB6EhVcfc=;
	b=MVoz2aBnJWXebMMerfuqPm/LJ6MAwsLTloYBr+CEezjv19DR9fhZ90989XeBymBkuyqVY7
	ADqaPuxF+HqFETM03r9DxeQrFdq/INGDL3y5/1LqG1QmPG2B2p0710ReBD5cC8DYJmk6Mo
	N0NzkPB7JQA1Fau81AaStcYq6j0TT/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982633;
	b=CtbwHWeDBt7JLgO+x/ALbbqltzhFF8ufPkKsTt0kTA2E6g72J8moNciwsHbKwPIY8JW6qt
	QZyt77Ngna+OaHKkjTa6Cjoem4Zz/ogqqyWfkWKe0fL/2Ouz5qyseGxVQ3CuVrhoMhSq34
	vfBgFNYYdRad4HhOM2GhGHLa6vFtTxk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nd2YedFb;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.165 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JmZnNdNWu/MHbh4iVosFA0RR44Xc7VFrViTR+zioOBM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982631; v=1; x=1790587431;
 b=Nd2YedFbPQlJZwOFSjV7Uav1emqVZ361evkMut/lCudxWrcDlALOhoLCj/G9YtZy8wXGtJmt
 RklNHbnUJowDBnTNpW+U4G5DdDrXXHXJJFKymF7cG9OY1nL4YNV2guE9JjCa4pv5UGBn1preh2d
 7erhcnbj+J4ll2DhHx9lRuG8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 24a1d58a18ab436c;
	Mon, 21 Sep 2026 09:23:51 +0000
X-Mizu-Trace-ID: 24a1d58a18ab436c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	paulmck@kernel.org,
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
Subject: [PATCH v4 10/15] sched: convert process/thread iterators to for_each_*_rculock
Date: Mon, 21 Sep 2026 17:20:56 +0800
Message-Id: <20260921092101.89285-11-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dbcsu15enr8f5446cj79bdtwm63jnq5q
X-Rspamd-Queue-Id: 37895140008
X-HE-Tag: 1789982632-891928
X-HE-Meta: U2FsdGVkX19n2aDWUeMafOoW5odrBd+pU6evHt3/ZyW2/0/PCIZ2BB7ZhaQ9nRNevqLR8GAnHd2mV4Pg33rfhKFR+b1tZYeMqsPz+rgygrrYiKV/5tRbz0Xxhb7Vhw+Kcz21uaZwGKW/U4W1JBdgN6U5gZkJYy1doB64+cxjgOJdTVRBwCZMWhIy3eLX2W2SJyyi6qI8PDzID+AOuVUCvzSzuwnXAC62+FImMCELYX1opzDhKNiESiNW6VSiM8HdxicmqXK/MggdMNQbJeNcgqBxeAfGTOYCQ33mtzWU8MnQxDWv6EKCjEGFNhma2ccU94LtAT0byU6e9skNlgd18WWApZ6HYJVwG/C1i4SoSZYP+WXnFHFBDqpK365stNI1axuyzaNgYg39N8FTNhz5Ydlbo+Aqq37DAlGZwS6i6QeymKQsicA0r1ML3nfj82D6SbC6kO8Mq/oNgwgb6QnVqfd79GEz17nYAesr1QN5OeQPJhwS9hxnPYg7rSo3MUODne8yN3RDZ2cEmexr9T7pikKaEwINdDRgUmT8azfOnk1bhshEattmv6aDL1nOBVpaw5Was4if5vVJ17XmdNtfQ6elfR/vs5I5gQrm/kaE0coAMTj6S3nrxhwP3sjk32wT4ljtvlJ4wpFvJ6SpQmL4bvJNIDVYuUoVmIfjLy5LgMKf4klfqFcyLl/2eNfD9VoQ7+POEg2mzx+ubcX4G+ZyNWMzRoKZiPBqVjzmODYUkVWyvJCOxRbObXVXWdvS+UcFe+5UwUeuTwKKS0N88RxrxEkB39Nvbfw45kQB4nu2D8OHuqTX8N5DxfUjhCxJuYph/p2RsmD7LJaqJBXM0zJt77zOX5gZr++F3C18SQwo7snS0JaI9qHQZi6SmTPbSTEXihquJUDmMWvc1anrx5ZroixTAo9RctaEZ7KK8PgQKcVdvvgPH6FIqxgo7961EwcPPkm62UIOpcUlQdBDh8C
 NhrckdVI
 Z9uOdUkmqDwY3xNM9dmy4Al40q3SwXqxPi4t5zazw/GcrMheh5J8Q1o+mwNpBhYDSY6OX17n00LUKeMa0UUiz692Zyyi507LZzvcBJjO1u9gAbS+RRUkHg7vo+OP+HdZG0n8U9gOfME9pJWDXpIMZVjSk1uiBCS6YEzqMcRUH9xgZ6O81dDoOWHZWlAqPffUdrP+qAScYIc3ttBqesTr18LBR7zSzYJ6WE4TIWw01wPvnsIEvxR1YvVIwtx0wfcEaqRXQ1AhrcSfZknMTfdHnsqCU4zifMx5x95wSK2knSkiWa8Dt4IvHKKA7ALqi9GJ4pOw53nSU9Bmtw/S4y78XZJWqUNRhzBjemkSGHlxrbNMFC4PdG8pgiOy1psJafB8g98e3NKlidQV5pM9oTkQQG/CZTUds0066wYKcr3L/S3llbdqlGLxSD9nqX1kdunvxDs97kc5LE2/PJmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
pairs combined with for_each_process_thread() loops in kernel/sched/
with for_each_process_thread_rculock(), which scopes the RCU read
lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c  | 3 +--
 kernel/sched/debug.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0697ed0f1c3d..fd5bdd2cb798 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2005,8 +2005,7 @@ static void uclamp_sync_util_min_rt_default(void)
 	smp_mb__after_spinlock();
 	read_unlock(&tasklist_lock);
 
-	guard(rcu)();
-	for_each_process_thread(g, p)
+	for_each_process_thread_rculock(g, p)
 		uclamp_update_util_min_rt_default(p);
 }
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 72236db67983..cdae165b98f7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1029,14 +1029,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 #endif
 		   "\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
 	}
-	rcu_read_unlock();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-- 
2.25.1


