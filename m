Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5977DC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6216B009E; Mon,  7 Sep 2026 04:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E1B6B009F; Mon,  7 Sep 2026 04:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593766B00A0; Mon,  7 Sep 2026 04:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD906B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:14:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5962C06A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:08 +0000 (UTC)
X-FDA: 85186253376.30.5B81961
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFF6F1C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fRc/27Rj";
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYCd3OAC6ugDwb5Q5pwl+ITTTc9U++zkBCViIWmyLfg=;
	b=5bT69eDzirBjOf3Y+jVd1iExizGXGvHxi5NoGkWzHxk1lC02FcCziuqyPgeCMj0opwyJ9Z
	4p5JFwhm9hD+E5ysjGw/WszQuTi9KSanld4xXMki0YZ9dbWOKOSQICzOrnqtaFlR/OcOe/
	UakFY/SFjLEbqdzMqromnt7jP/kEBjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768847;
	b=fjiTFGD1FcwdXUbWL5pxfDzvUi7aIsVpGXfvtcFaYorPHvO+5nNm45r/DOxYyAlD0M9Cy6
	cZEHkaiCuCl722EV93RkZVICAA7b/LhdVdvjlHVMAE4d+8XeMJ/PTQIBrOE8TT0EkptUjc
	hQ7eb5GxSqAeDALALQjaH/dtzxkksE4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fRc/27Rj";
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nMTgYk091e0ILTHhRnXGH4A+hErpEAVN/BDSGxT7uPw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768845; v=1; x=1789373645;
 b=fRc/27Rjb5/PrkOFN1fx1eZb0T5Uj4Qi6vPGV0FxSSZJ4oymS/zA0GU58VMKGHCBqAfkWM4h
 zFuuexu+23T9Nr22OHgWaPsDLqg49WrDyVwGLpG56T8jJMdPhKvWVlICc9BKOwB+MJGjF9wdp8w
 bm65RXoDeoZlBp/kUGh5J+pw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2e364529cd50751;
	Mon, 07 Sep 2026 08:14:04 +0000
X-Mizu-Trace-ID: e2e364529cd50751
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Ye Liu <liuye@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Yi Tao <escape@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	ljs@kernel.org,
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
Subject: [PATCH v2 1/8] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Mon,  7 Sep 2026 16:13:27 +0800
Message-Id: <20260907081334.1152889-2-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFF6F1C0003
X-Stat-Signature: jmhojqxi55ran1jfsz9ss4yuwfdx4otj
X-HE-Tag: 1788768846-871670
X-HE-Meta: U2FsdGVkX1/z/bpKclO1SJj1S8ejJ3GvGPqPtFDEY38fpdgwwmZw4kXDClSTTs92RkSbcUNzQA7gHQTjfLvds98cKL5AbYsuB9n35MZVDDgCl2MwIMmNwK6iLM/1rJHMLHSaOAFGS2nh11PFNEs5X/0eN1cTCRhokXMF7sKCdTkmQm7kPunH15wb+sTdVF2/9SEWtOOVHBksS/Kw4RDvp9m++gfGlKbHd8urQnxTxwoKytYmd6n8frdTQj/DlZ+MA9u+nDMelq2zVJyooviNlwF6py6q3dZHb5h1FaLRWhwKPxicyriU/nXgnMoH5XQDCp2/1eNmFJ7I2+PpzGn1SmCBjyBdGtaVTBbIUSjZwSJn8num+zN2PqctaSpb0EESy8CV5Lb2hyWXLhh9tUME9pL6r9cIiEDt6GPAozpIJd7aAdZxpbnzstjUx13gXk3HpBu4XMLrPCSBU2WTVmxsuRUwhWjwaDnV1bpommd9UecXVWf18e81zVWK0znBy0cnYomXxhPsJ5Dkb8yFyruiV+5s/smdtOkks/MdPthdCURdsSPgJtsBZevkEwQCp46Eh76WpztbIx9asCFBIAVsWF5rjG9G4xcTD1vYUbJiySAOVeT70vRGWIoeufhWS28+5AVnCDL/PjGg8lDeUzMIo0bncwkwoPOTMXw3jp4TJRuZpzMlShrs7kcmz4gJrVQbmuNHGjSbhUhLTP7dC13qJilNHnFtTMk9h4AciOsvQ2JUILS1Bj+/zAFeyK5PQtL79OCY5ERDZVwkmCo51A6bx4xUC8+I6GGwvf6ZsVPC3F6TTar5ZC+BVbTXS4FVM9zCKL8nTjYNPCr6XyXekIF0IcrLTXgjCkOV2EBzu1OpRX9ygcrunNjKJ1UqzcP938hTUTpcxnha0+GBTvrxH6DZympaQBdSp7G9/mi2iakcNa4R4jGIfbSXRWajylVfVSg6RJBN+lvl4pWrD7LFz5K
 u5GDHm3A
 vFU9EmRCDD4GtCDWqbh4XutjiKZrOMnvvpyezixY9jOD7StGBYE1S6jvgPcI34DMDJCjz6IgCAcK8FzahLv4vZHaH9Y+fiGKHenDk+6rsuzIg0QxUkz8UykD/8Cv7jwVNzlLnFBAUdE5cPTOemphXhEW/eoHVuClV/UOY52kwWuiVZ/N7nQxc8TAnLvFUV0G55aPqPMAX5okd4Pu4JWqxcLI/Bhly4HJqr84c3A8w2njuUQCmVXpTDh66nOl2SXKpZvNjBHeER+W8uq9BA2TXAsTq8iyr9zapkuNZLI6bAZDRqFVM5Py2Drph3Bn5gDWdNSqGOvThQ/t1ATyv+H08w4ACUjoM6YcorUD0rQxx6tydvUKSCog0kh5w7c5lFo5DL63T5qoRc8FYMxlAtq51U4IQLmgunXUAa/TFaZI6HvLWkif/RCoR3FnywXthxZXTrS8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Introduce for_each_process_rculock(), for_each_thread_rculock() and
for_each_process_thread_rculock() macros that acquire the RCU read
lock before the iteration starts and release it when the loop is left,
so that the RCU read-side critical section is scoped to the loop body
instead of an externally managed rcu_read_lock()/rcu_read_unlock()
pair.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changes in v2:
  - Rename macros from *_rcu to *_rculock (Steven Rostedt, Thomas Gleixner)
  - Improve comment on for_each_process_thread_rculock() double loop
  - Change prefix from mm: to sched: (Michal Hocko)
 include/linux/sched/signal.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 584ae88b435e..110ea9f131f3 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SCHED_SIGNAL_H
 #define _LINUX_SCHED_SIGNAL_H
 
+#include <linux/cleanup.h>
 #include <linux/rculist.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -663,6 +664,30 @@ extern bool current_is_single_threaded(void);
 #define for_each_process_thread(p, t)	\
 	for_each_process(p) for_each_thread(p, t)
 
+/*
+ * Variants of for_each_process(), for_each_thread() and
+ * for_each_process_thread() that automatically acquire and release the
+ * RCU read lock via scoped_guard(rcu).  The lock is held for the
+ * duration of the loop and released on exit, including via break,
+ * goto, or return.
+ */
+#define for_each_process_rculock(p) \
+	scoped_guard(rcu) \
+	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
+
+#define for_each_thread_rculock(p, t) \
+	scoped_guard(rcu) \
+	__for_each_thread((p)->signal, t)
+
+/*
+ * Double loop: 'break' only exits the inner for_each_thread() loop.
+ * Use 'goto' to exit both loops; the RCU read lock is released
+ * automatically when the scoped_guard scope is left.
+ */
+#define for_each_process_thread_rculock(p, t) \
+	scoped_guard(rcu) \
+	for_each_process(p) for_each_thread(p, t)
+
 typedef int (*proc_visitor)(struct task_struct *p, void *data);
 void walk_process_tree(struct task_struct *top, proc_visitor, void *);
 
-- 
2.25.1


