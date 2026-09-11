Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BD3C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F304C6B00B0; Fri, 11 Sep 2026 04:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01136B00B1; Fri, 11 Sep 2026 04:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17C96B00B2; Fri, 11 Sep 2026 04:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B56A86B00B0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:02:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DB50160134
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:18 +0000 (UTC)
X-FDA: 85200738756.16.0A744FF
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5C23E40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uBbKjQP2;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113736;
	b=wM1AioUktlwxOPiMWPuwl4hpaHuOyISkT9r5+wVtAdrQWmipHdsJIxJOMS+vvjT2D7DPGp
	5ggZUNyepUret3yaTbeyVz1lw31P8/EyCKEVd8BJvL846yuCiLOS2pGBbMJZAZIJLj1bLG
	NqogyfF4UMD5HOYRbWla/BiervTs2/U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uBbKjQP2;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmvM5O6QlxHFIfGeiOyXcANPGbZcs1vqxiFYf5ALZ6o=;
	b=MXxDgcruV9UnYgy7hTi5Kq49/2a0V6N9/8/E7e8OsQqGt+44cVzz5Pq1BfuR06jO7fvG28
	yoTr+0PfZZJmzHjsHLsJjjv7BBeCmz1u+/rNMBV+GRCcHJsxAB1anv82MUhVof7VYzeBvW
	ZPZSSkR0+3eNOz9ZheFXQzq66tf+RrY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qoSX5ca3+2R9T/SC58K8tjc6WdOgd2bgxhEA3kDokIM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113735; v=1; x=1789718535;
 b=uBbKjQP2EUFEE5hOrKY945vscJ8EiZRp/QjlrT/nUA2uof7ObFLnaQTzIwtMWoB5PtPeBbY8
 Hz6PB2TrYIwKc3fkuv1VVm53juNElXExAWWjrPSz8LRPnN2oVGZ9IB+rPFrpL6gltcZ+dyuDjxC
 KftX2UpgqD5WH7VnNstP7CiI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7d384f5229d115c0;
	Fri, 11 Sep 2026 08:02:14 +0000
X-Mizu-Trace-ID: 7d384f5229d115c0
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	x86@kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Oleg Nesterov <oleg@redhat.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
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
Subject: [PATCH v3 13/15] fs: convert process/thread iterators to for_each_*_rculock
Date: Fri, 11 Sep 2026 15:57:58 +0800
Message-Id: <20260911075800.491472-14-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5C23E40008
X-Rspam-User: 
X-Stat-Signature: fs4xsqf113sezf6kzowe1acjy6xex1fd
X-HE-Tag: 1789113736-265529
X-HE-Meta: U2FsdGVkX19z70hyDCnMmqvOOA8xdPABAByHvlTMYU56yHL3rOEaviTXAULD7cpwDr7lcMWZ9nQgPZ/EMInFZLjmshthU/wOAuLNVGD7gsRWcHIR+IT/mNGQ5siE/QmOZL6Gl73m/kwER0er1se3SZMw6SE0eAvEQb/dcBJX+13xRc+ig423X97COAReuEDMjkmspgn2fIibE2iT59pU5Vc8hJdmPgkkVgLgImGQpy3R5pFisyIPz0JvlK9iX97F7G52CPChDfcJkAlDMhYbB+uVW65Fl/YgHDemf1bhhVipjDRCQtRFKRxRiwDdnyjpylhzWzePDSoR+mvNDmQ9jj3WkqGIQByLndU7wmkI6tn9uCc202xciwCJ7Dv0C2IntV86uiudPDg1eV8P6WxdkRuunlKMwTAtDOExrpxA8PARtSXwsUTq11DesXrwFD0kuA04H0wR8MXDIeCXIkAE1u/r7XSnGHSSgds8KIPrx8CXL46h6I+NJHgaVJsiep7zPTUa1eMPGxzZaTNM60xgJ8M0W0bxrF0cpKaj5iQqWyhBKKcGUQLCvq3R9h8eq73TNwSp5mEv60saV2oFnLoZ6Zva1y0Gp9hSl41eWaPxUMXf0yicgw0jbYP0ZxjAEdCukeJh47zozADnmoDuobH/jyPjnfOEOqXN/gOXESHjsh4A/GUHiJuD0TvqN03yvCp2x42/BS89a+cjZGxc9aNBX6f3+qx4TVsMmlM9E/c+fwJ1HKzNVk8DTfe88HmYN3zS65qMxCZuyZOlq2HrBRtu4+B0Ol4g5o8aAEcmUesUyGb6HS0k9WWQQ6gHqG9Rqyu9+guz4zG6ouvAbWVlxy0N51SPjs3baRvgKNtaBFhjr/PwcCYR/xcuJ9mEdoIZUYjEkaah7HFS0lhtXEZjqzqSzcw8dJt5T5idq26z/u+a7cv7ZdIW9VLy+6bskgxVqQoO3k0A69xjzxdLFXDjRR+
 Og1QnM3r
 Gln55omHdtFBDkNFkDMH+NlBS7rzFKrhN2f7Vfm7G9hY9RHM2wdSQWe4TiSFUwhg1qkE9u5wlwSICKLSjJ786IJT7/aIZ8Phx7juvMJNMsIZLdu4xMwWsjWpD9g66peaK+W7phlvSBmVfzicJ9vyv0ysn+ng5jeG0GW7IdTlmpq0nB0QmlXv5zFbWvZr6iT4hgkIFDoS7nky9JIEoc8UMySelQLuijbUUC9gF9/WNFSmw8jPcC+3vyp4Rk3kEbLRQBuIE8kaJbtXK9qP91QtZhuE5yaX1wuyXDAXXif2yHZZNICD0elGMB5nOalg/Vn0aGp/l2hfcwyJh4qDY43IYq/WI5ZxOmEuHf3voFHhYdhxzphH8/eKqxvA6JXUbt/YL7GVYOoh4w2zmJ+aPmuFSOpuIddbbkVLXMlgWxbUiKVrkr11tFjXXaHE5JsAU/+irw8Lvh9gNEeblQKIEC5PP7N6Gb0CdIQ/t5ncLkxIOWz/MQVg=
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
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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


