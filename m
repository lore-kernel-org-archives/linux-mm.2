Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242D9C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CFC6B009F; Fri, 11 Sep 2026 04:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364B06B00A0; Fri, 11 Sep 2026 04:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B846B00A1; Fri, 11 Sep 2026 04:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086896B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:00:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67225140137
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:00:29 +0000 (UTC)
X-FDA: 85200734178.04.9DE3024
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 604EB18000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:00:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RDyI7eaN;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113627;
	b=rKFbk7bIxfl6tR62RIZbHhbiRuP46crR7ZI3cduFMiUYpgmGJI+0gaUrXmwRhovbrowkMK
	zPq47CpCHUXCvLbwknnVs5l+p2O9GdSmsKqCsewrmcMs04iaiZ1lis/+ikuuy46pD9Xga6
	h9BhpV2FZ8Q/hmmWY0qMTCjiD1oYg6A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RDyI7eaN;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21c7LBpS0iuNdAdp2UUxz/FizKv0dbnN52MpXyxi7GI=;
	b=JfayF2p/26XTgRolz1avQVmB5Y6f1gctSfV5QrO7DwxOBSVkb+nDel4xrl5kQCq3EUIYoJ
	ZeN4FTI8IWf45TchAS3Uth5DtNfih0QAF5fb9EV7A8mDyeVznFo/7pNwLCiNYFsbwo2fyM
	c+V+KAKQPxdNBAbx0jwbPMSWBx1mesw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3Bhv7ooPs5BmI+z9HsPTzdGyyICD44dDZ6H03uBSzOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113626; v=1; x=1789718426;
 b=RDyI7eaNTOGIMLMjkQCsB+pcnkWFA0PC+iMZyZsJDfn8aJjINLZtSpdjtpnSHdwb7IjsX5Se
 HI1beyyiFz2Q2oWYQhoihIiG5242gvgaOT2TzQlWl1fkN8xDQ/pbX48g03SzUyYNAfODC4YTUNy
 GdtNK5kUXCWjqFOtxYL3sVcw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 430f4ef2b443db4c;
	Fri, 11 Sep 2026 08:00:00 +0000
X-Mizu-Trace-ID: 430f4ef2b443db4c
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
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 07/15] hung_task: convert process/thread iterators to for_each_*_rculock
Date: Fri, 11 Sep 2026 15:57:52 +0800
Message-Id: <20260911075800.491472-8-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 604EB18000D
X-Stat-Signature: htgobgpetih7t9gbb8y5patomp7zpxi6
X-HE-Tag: 1789113627-131822
X-HE-Meta: U2FsdGVkX1+xwllsESGadp1B5ulz9qYbTvmjAAaxKm06tmoe4xNBFUAAaTMbq3O8/tQMJtAeq+WnkW59FZWjK2yQADwvQj8Dqg2Y7sWOqpmpprUYJLgz8Ja5k5KNc8gokttgFlyd41t9ZZDb5xWSXSLys6I0otTObsjYdPX4aII46IbrUKVa1Rm8FlZaJdWpXQoz+CBbZTZ0aPlpq9GZ2m6k5D6EAthSFrwE6B7fBtyXYemoocTjk+ZFnVDJq1MxYJNSIVMWjqyer4917HgEcws5CJdqumt7eFwqlYEibo9onoPwpBBKbm/87gwquXoPmwMJn4FY9VMbaZIrdawvCHiNS1q7w6O5Ngm0Prv5CM9S4ZP4j7fRalfB5WsW4CR/oyAJr78KRFGye2JZTry7a9JBQELjTlnGh7cH61MUZa5i6mEYciFtpBHD9RWdb4cQecFpgDGVO0ATRxKEw36t8v5IA3IdqoGDJBggX2o7d77vyMdsgbi6ggp7ubtrgjer4xGwNrc0fBZTMmtBdH5hHr4fmG7GCSNTCTzIzJzorfMkIENbVEg9MO98sRyPNpfJxE4iMAuV8L60wD1yalSXQ4gFXo67v7dBfi90PjFp//V5Xa2RCNS7Qw1HApjT2/nsZJ4ZUXj526kcyStIEJFWheXme4y4AX5SsjcpaqxpH7Uh0MZ1iwnHhpmmU/JY90PiHe/ozygS2McLNl8XnPQpRwvTa6wJnjxdEht2tSTmUMUNr8oSsqfjdkZtOcMwJhTSoqWNwwhVghAn/FxgHncgVlNfT4gAI/Yffl6NhTTyDkgHAFPMCjVecfZZENul5x1n2cQSSiy0zWPGhJat29an3hAXuJoHXXUC8KvXkVdcTq6sSQ/dJVH/IoZw+aHwHdtVd1Jxs7WuBaGz8VYzO5/x4VdO36XuUbcN2kQP+awSiyjwSAm0hEC5Ui8HCuLEgQX3awp742F9c7v+gVtHatJ
 XSH51OOA
 w6qH3pyTMlTHH14jyWswvWfZLWqfaWGbWXwjJ/w3jOjB+Xa9v1clEDZLTXJyaSuDLkWPMxc7VZh7khjevs2BO6aESKcZl48905evcZPcxEq2+DcGMQfxj7nbhQySGhyzo172S9f3xO2mAqaV7I37XMPqvYJWVcIkHVEQV0htPxCuj9j8iwddKnv5elVT1hVvv2Z9b8fxxAvguwrJfyfqAcZi4Ibpmh3BvrIlj31sFjkQeQ7/9trfNhCvJjwAq2nbNktvaZhefvRja1bE0lYCsxNsX7SWtB2ON+qM2QDevlTOhzlwBjBC8PmpMQBYxqg4WXdAMbEWhpPDKgh5BPhsKkz1R67HfHm+nEjgbJrvBvp79AUGp0WLDfkVAJ+n8iEqT47volpYBwyCnOJd7K4tH3dlpGgnY6SjUPQwwLlb9jpuzgSwgGsBFHsWIlKhD6qZ3bsk2pcG/UqcBaDa01vsSe46NFlBVGB/9Pw8QMqKwu2xppGE=
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
Changes in v3:
  - Split from kernel/ patch in v2 (Peter Zijlstra, Steven Rostedt)

Changes in v2:
  - Rename *_rcu to *_rculock
  - Rename stale 'unlock:' label to 'out:' in hung_task.c (Günther Noack)
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


