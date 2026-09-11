Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D911DC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBF86B00AA; Fri, 11 Sep 2026 04:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3BE6B00AB; Fri, 11 Sep 2026 04:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9606B00AC; Fri, 11 Sep 2026 04:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1236B00AA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA4CF16012F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:39 +0000 (UTC)
X-FDA: 85200737118.28.B324C08
Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE6F3160007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITKbw41G;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP7mr6oESMtqUcAcuw5C2lFLegyp5i5MPRclWIMnKdY=;
	b=2Zhk+3PPjBjW9xDqhBHW4YCAKRtCQdWh70Gl+EGTX7XRHnB972Bsar3lmqD6da/qOZtYYK
	Uhqgn46lBpkP1VkfdDB+Are0U3RXGr1nXWfJYMJKtc58vrWaXd5AUbkIbbeoob9ed1xaDN
	tmfZqAVWuk75NOxCsqo9ss+0j4orRoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113697;
	b=lEWiZJRrBnMo2t+eGlo+DMM8zyvMmdmoT0PaMkLo2RLLRSL4FggR8vtsbuXbmD+BFHtybh
	l49ropyMHXQbOiOFM4O3TQ9VwW2m4Jl2OMWsBvU8LmQFQhXC36BJe+8niHhnaHS4z62NSR
	PU62EL7cvmyWcvxknKPN8K0hbfKg/44=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITKbw41G;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IUi1QxJJO9OkJwG+5y62kZo0PP6tS0vKjCkbB/pQE7o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113696; v=1; x=1789718496;
 b=ITKbw41GIqoryyNdtt8qpmC83viNLQyMmuoZW8dWz8JcJc0unVQ8J/nZdm9KxTFgnButgmGJ
 wiCYmtwrdxbb97eNtf9+weSiTGw+PYTAPRWcmIxdXGmrRf7AdeO2fEl1oddISNtk4J+GRgfSs0j
 TvtyaW+rSUFOPeoVoko6zkWc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e9627d939de7aa3b;
	Fri, 11 Sep 2026 08:01:34 +0000
X-Mizu-Trace-ID: e9627d939de7aa3b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
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
Subject: [PATCH v3 11/15] tracing/fgraph: convert process/thread iterator to for_each_process_thread_rculock
Date: Fri, 11 Sep 2026 15:57:56 +0800
Message-Id: <20260911075800.491472-12-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 43re4fk71h5ripjt1uriewozhynq1kfi
X-Rspamd-Queue-Id: AE6F3160007
X-HE-Tag: 1789113697-230972
X-HE-Meta: U2FsdGVkX19m7v04r0GjBCp/ynxECNtu3Kbc/6wj4SZGN4JdYeRaQoiStStFRFaQqqseCukuCO1n/qZwYhxXQkTe7wXvVE7onG4kbzTatGRJkQLnoEeOggg24LxY4VCWbi/M4amoJLAnpnHNWA2XyIPSB2/tAjr6B3MKGvbMAX9C+pY3A/+YCiJDkcM52XLvJueg5QNKnRzEjBrFx1xV4OXBUE0d+UPPh+sNu7UxeHQIo9ljshJxowkiJnzjax9d9X0KJ4f3NNcLSAZUtUgZ6q8N5i/CiBYuik5OIVAHYr2cNLbtKBrrlc8EzCydB1DpUc04BW6DNC7JN7MryQk5NCg6S1fEadCHxpWOReZFyNkq+84hWw+/jIHrFTBpjaI0klcIUsrAB73FV5nVsmdnxDeIRovQF/eIypLIYGbAYvyN4Uw67CGATWeHHxQw8em/8DlI8N12cLTIqt1LHnT9VFbCSySY3Di2GxPgMe3vdf8+iY0pzIJ2t0aG2HIaWf1o7iejDl8bUKMkmkhva9gWCEet+ud38mjOV5rsPh85SX1amlrefwT53W1x2Hxv8cenm+W61ewetqE6yIpi5EMFLwsSeESVn8QQMHpz8KZkwHiSh3UmqvT/p0uhn2WruS9RX6RK6uLqfMw5ZmAxwYqo/nc+cbR/EnTprtXvmeWH9I7L6czUJV+fcHpFdK0ZH8I6ZrW8SynoauX4YxaPpHQMHRaFw80RQKFAJmkjC+hkbaDQPwpVtWxZFvSTPmuwo+IYjRj7vrSP6aRYU+srRQ78pHWwSQsztEtTtGondos5vHz84YMGT8HjVzczoBf8VXdb2AteC/9OSKpfmLwnv3BfvRtKOc7EQAfcC6ANhjWptkICne/1tWn9EUXcZC1B9G8W+cJMKUtiITj3bHbZXPB6mt8w37Jr680qwuvNKZTD/w/6UQ8s4O6adESRP79GCsCcH/UIYjnQ/TUYlk2YrL5
 n6wNP6rj
 4XGDx9LgL00Qb+FUU5TuWTB6K9WbYvXK2mKdfnPlXB9XnQiKXkfXTgQC+2V/tmwSewgsTgdv+EjUAMQoPtho76KMZtCb8nSnXnHNE+GQ/hIC0ZPsZmyjuovXElCothGjSbbysUilytgnMbs+Lqh4ZmXkoehGNFW1/bSlcxlsOj2vhr6Yhd6ShJnlnNYvUp9E4drkeMoxDBXis3H4iG3exzilGIK5l20HJs2B1UWxL6L3hG4cpdjc/fAbodK6WUoyc27zKR9Xp4b1XegYqmP7KqX+dfRtN3+baEVGywA0kuusFc6wh9mkQzPJ1vbfIlTJ6Bm99g4UBWO3Ng8B/59MDjncy1x4jnnusJtfQCiLFL7+mYXj3hnGUbg/wnfbKPnBDnZtRVEke252oRc7lhoS0a+1l/p8Ho6mqubU1L1uPm+CJRw0qp8LIYK3rwLGfYDgYetrmhczlDilHni0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/trace/fgraph.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
Changes in v3:
  - Split from kernel/ patch in v2 (Peter Zijlstra, Steven Rostedt)

Changes in v2:
  - Rename *_rcu to *_rculock
 kernel/trace/fgraph.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 40d373d65f9b..f797ce119223 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1057,11 +1057,10 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 		}
 	}
 
-	rcu_read_lock();
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (start == end) {
 			ret = -EAGAIN;
-			goto unlock;
+			goto free;
 		}
 
 		if (t->ret_stack == NULL) {
@@ -1074,9 +1073,6 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 			t->ret_stack = ret_stack_list[start++];
 		}
 	}
-
-unlock:
-	rcu_read_unlock();
 free:
 	for (i = start; i < end; i++)
 		kmem_cache_free(fgraph_stack_cachep, ret_stack_list[i]);
-- 
2.25.1


