Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16606C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262696B00A7; Mon,  7 Sep 2026 04:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ECAA6B00A9; Mon,  7 Sep 2026 04:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C0E6B00AA; Mon,  7 Sep 2026 04:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAD836B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:15:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B3081C25F9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:21 +0000 (UTC)
X-FDA: 85186256442.25.66922A7
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A7EF100007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gLPhPDDj;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768919;
	b=UVOpg4DSid29awYH0Rgz4QHC55Z444BzMhuLTleoPYGp99XjVmveog1jwOaTNQIiMzre6O
	BwNxKXYsnxJAxLf0GNpLeeKl+2tGxrUsLV/t9TtoxnCqaORryEQ/hXrK+LQyi229OFbXAm
	TuRNUXb+Gqf/yvxoMWumb19Cs61wrSU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m71/e0TQ/yIIwFJR1TIxcMdB78/X6bYH+SgEwIrQz6k=;
	b=OzuefJqSN044IIFnhVGUWyzqfzDi+oFgld6jAN8lI5BKwwGD14rXqUFAcOm41LQBoiQbnf
	1RKFHfEMNfJOpAjp/JyKthyHyJIIZG375hkwuevEIs/7MXuMwzX58nUNROX888ha3jew+z
	11tjA47Qkwp0tfGNUpYwTWkRJQSwl4U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gLPhPDDj;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dQwY3gP5992iA8WFv3nEtraOYZnGKkWp4+ZsJMlQB8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768918; v=1; x=1789373718;
 b=gLPhPDDj5LILH9XrPJwI6KC3TtpjjsjDRkMyRrYpv+MW3lkFBltvAzmfG2MThsTZ2jqc32DD
 HNkuUR5z6VW8HdLv6dSkniipkk6CpJjiVa1AYlTLgaVP9EAfFktT4eZ7ibaz+DlxJJM8xe1wzB4
 6gCp5nc8r1+nRD+2ADa3HXis=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b383245cc3c82e7c;
	Mon, 07 Sep 2026 08:15:06 +0000
X-Mizu-Trace-ID: b383245cc3c82e7c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	x86@kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	sj@kernel.org,
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
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v2 6/8] fs: convert process/thread iterators to for_each_*_rculock
Date: Mon,  7 Sep 2026 16:13:32 +0800
Message-Id: <20260907081334.1152889-7-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A7EF100007
X-Stat-Signature: uucra8kgwkfjhy87zwgr3ugcrkjfi9po
X-HE-Tag: 1788768919-712106
X-HE-Meta: U2FsdGVkX19uXtzOLBq2ejwB4kMx+MrrWwAU8Nw64KwJH2yNJqQvsx9KEgDFdfFZFCoqqVnrk7gic00NnijDNdMWgIIGqbnCUyq5fAzABziLLDBtI4gd+7+jlXPb0O/7gGnXYWTATMKRQ8ZXIRAvlr75Mw4EBE28+jn2+QhLQAvaWgc+WrBalFrBlw6b+GShbFc1/2Yxi3CMlXDgaCCg5dIoq7WmtO5mEvzikm4ymtj8MKu1r1FGUwNsuFt1/lDIw4FYiGEJ6cjwmQaNcnKOpJneP2ve/KrMErH2X1LjlcnS5dihAHSYpXKDhmN9yHBeAek17fJtQZ98aYp2GN4z5aWypBeEqG4eouvch7LlU3I4rdGouPu0egy9uFr9PwQQgboIqqRTKla3B4892O/51oN02Zvyugf9nvn6snLQIXuL2c4RYPHEFYD8kWGmnIlcn9wwBXqSW+N146CC/42K0077rXHfrGSwmtVzg/UPtTHW82IdoFjtsHNMw5mAeV80yNk8G8QoP43tE4gDncyAeNYcan5eVEiAnRD4YZSErWw0EgX2RJ8izh38AWtahjmy0i64kkhRiJ32y5Q3JvJtIpvqSMhCSPcxeZEwy+cbDhaJCLK0RynCnPtAKMu8ogewniaUKuslMHVkTwyB4srxh99q57QF9HnILsiyEHSxbLlmynAZHlxn5pWbyYVpJS211+/IE/CBJyVy02dRljomTEzq08a0Cfd6/XvqI0z0FFS8MG1emV4dqLIlB+JLt9qt9jm7OOWoxFqY8OdUxZII+jqWcb+qlHAH8WQ8g0pY6RP/TVFpT0U4RgeduyKpU7Kp9XlfUIz/7P4zJF7r34CVttKKhztyjILA2OzOF+pT4P+yTTKPFBahcwzmJWEAUdeNZHmKNbRibfNHWNo0CUYgJnp+dQhoQjgiS1mBkq/Bs3fYkDztJK6rsYXw+bGDZiaKged1re2HM5r/ecKIxTb
 eZ048c2q
 vMgzED4USlkI3AuH9uU08YEqFCh/imU6Ph1/fQrjoFcph3LO+M7x4uixoMlkNcgPX5T8rAGxzfVXqryRQfas9MaiXjm+L+MqcpOb8RGzGUObjbk7K0WNICO2Z9u//CVKnwhIJSBuZruxjVe8qJBGBccS6MSorx8aIYcBVFyF8eZDGU0/ozMb1yaCZPrN5nu+48VLfB3LwV4ApM1ixGmNPyr/gqblHzTBiOqqhnbz9g5q34YA+LzPUWlgPoiE9dFRgydfvopqp9Bd+/KD1x4ewvT67VDx88oWbKwv2G3ryTwOt8Pj/Li6rkysH9myZcNtJNni5QSgfE05dO0ovrVPua6uQ/ErumOBUL05BGtEuMk1o+xJ1AaOgOmaHHUid5DwwsodVud59npY/dWzl70nOOptg/8eALpTJrpSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
with for_each_process() and for_each_process_thread() loops in fs/
with the for_each_*_rculock() macros, which scope the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 fs/proc/base.c        | 4 +---
 fs/resctrl/rdtgroup.c | 8 ++------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62..3de4f4557e4c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1160,8 +1160,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 	if (mm) {
 		struct task_struct *p;
 
-		rcu_read_lock();
-		for_each_process(p) {
+		for_each_process_rculock(p) {
 			if (same_thread_group(task, p))
 				continue;
 
@@ -1177,7 +1176,6 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 			}
 			task_unlock(p);
 		}
-		rcu_read_unlock();
 		mmdrop(mm);
 	}
 err_unlock:
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e8..b14df8b23f1a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -709,14 +709,12 @@ int rdtgroup_tasks_assigned(struct rdtgroup *r)
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	rcu_read_lock();
-	for_each_process_thread(p, t) {
+	for_each_process_thread_rculock(p, t) {
 		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
 			ret = 1;
 			break;
 		}
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -826,15 +824,13 @@ static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
 	struct task_struct *p, *t;
 	pid_t pid;
 
-	rcu_read_lock();
-	for_each_process_thread(p, t) {
+	for_each_process_thread_rculock(p, t) {
 		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
 			pid = task_pid_vnr(t);
 			if (pid)
 				seq_printf(s, "%d\n", pid);
 		}
 	}
-	rcu_read_unlock();
 }
 
 static int rdtgroup_tasks_show(struct kernfs_open_file *of,
-- 
2.25.1


