Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDB4C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E58E6B00E2; Mon, 21 Sep 2026 05:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD906B00E3; Mon, 21 Sep 2026 05:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4586B00E4; Mon, 21 Sep 2026 05:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 195C86B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:21:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62AF41205A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:40 +0000 (UTC)
X-FDA: 85237226760.26.21CECB2
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 608B7100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hn0kkM5t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baMGKrR6Wto4B3ILzLDHBP4j+6BIAR/gKBU79/GVwOg=;
	b=MBVsrlRgG9aWfticOvA2shetIxD99BNJguZ2q3d9iNtDaWWhwFe5iqjBeycwI9e8I9LFkY
	IuhZJIz7DG58msfvxYGAebyEeC4rLE/uxeKhX1jWa+IxfVdQM4TzQbzTALEAb4KXQFRjEe
	ciqD7ZZ+6bW5URCjGU0lIr6eaYX1IXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982498;
	b=8GGuLsWOaoDmsYPu25j6ibdM8EZypJJBZb3p3uWlwY8JMsbyH+LL4xzcI5SJ7wQlBdYkJd
	K9DWn10QTwmt9m8zXXhopeHDdir//Q6cP0V6npWfDhS5kt2EZlsE6RzelewWBf54ADdbFb
	wkbLCnf57gRpFpFUso9lKtDPJ/kq/Nk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hn0kkM5t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=deuDjh4KY/glu2qz4/gRNLs6D8kmr7YlUzYiZcAnK9k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982497; v=1; x=1790587297;
 b=Hn0kkM5t0LQGesojiXX8pLshJw36jegkjkCKaGlgNu2xCAE4WaKEhUgUckbHz/Xvy0O5TSDF
 YwFM1v2sQSvWzgCsRc2OJgnU4bm6GyU9TGNpZdaK/ACJJ1lxpYJwPtUNpw9wiaoGP68wqjp3N21
 yN+1G4ZWXyfYrwGBN41dGcMY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8d62996ef121fa9e;
	Mon, 21 Sep 2026 09:21:36 +0000
X-Mizu-Trace-ID: 8d62996ef121fa9e
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christian Brauner <brauner@kernel.org>,
	Ye Liu <liuye@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	akpm@linux-foundation.org,
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
Subject: [PATCH v4 01/15] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Mon, 21 Sep 2026 17:20:47 +0800
Message-Id: <20260921092101.89285-2-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 608B7100002
X-Stat-Signature: 7ocouxpimjmgmtri639yyuz3t3p9enjb
X-HE-Tag: 1789982498-992374
X-HE-Meta: U2FsdGVkX18EbjzfczruFjqq4wR6G4unObntRoQHwuB0LxCKH/PzEBisffAOIaJ/rkuHI2ihEGzoUJJQbXgqysqX1KJeA3pKIiM+ZAUXAsSfcfjcy+nFJ5Nlw5HV9De2aghMMaK25rOGMLtBMSFaYn/1AfCV6GGVPNQQhF03GudOfCgrV08e8f7p8uEV/2KQCxliCS4NT2OtOiNWz9QOKyzCp86AC4JStZYIyeliuhBR1phSPdupB2Fb5Idc5jrvHq3pm78CgX8UdZ97Q6+EozGDhufmDrtl5IlbAwQ78aT901fOZPNoqVcKcs/Yb4BeCpSVTsxkHv814kC60Dg5ll2XRLdajD16COLu/wDohFm66jFjW9dT043El0mcR0K3rW7M1NShImjZiIyxqzSRgZlo9H6VPdSRpQ/z082s+hf4qat1Ela3clawWBZ26aPjxCgVkH/62DxNhjrVkbUz5on553u2r6LO9AkZT4vZ9Lbo21Mlep7ouQxN95eA4dbR9QDgUq9W0DBBmIImMBB0yhrqq4tQN0cyOSLwTUDlOcCyhytwBNMdoDF1k769KGk+IFRfGzi3alu8pSfCcgHueGNBQYgUQWP5+B66nbPeOR5/yMTp9liPo6BMRt3Zcp+IhD2hW6SjZfIkdPpoTe/fuInV2amu4mw1uOBrNRE8kDCQ2b9MIKIy6DTejvW9TLS0y3istTm1psce5XKQWfaumTLHFK1jvfD3bmXAy6doItlAE2D96a3elkRgxUvGn1Msi/1DNYEMJawZ2u67Ur8AhiDp3QNgg1gI/m1ZA5omEartkCS/OUwbSdeuSQE49/VCnUV2dpIDWIwHWkKF1BWN23+MWKp1aL4KrdTWSWpVB2mVajW5Uo4K9CmDKW3xlVyb+d2YAVNGq+HFzxu4dupWndo8mOhP5MPaxGljz+PERBGNkrePbaXvSA/Hn3Kv7bWT3Mqc+xyr1DBoopz1Az7
 Qjbnb94Z
 Hc02rQyqtaEmuvxh+/FQXzZXzUqpFVDGJMnb+5kzqnAgen2dZfuxgPHlLn94nmBcjme4zaEgM3n44kOjB0bCClJQM4kxEKvlD0mEOjYucmRnoYqNt+ctNlvUinwollkOx39jFJRh7IDQ/7zekG2UW9yvAEeUhM85gfbvohK1RWA1mtKVMr1YWuwQpRgx87sxjqolvv3WZsj/2YaONyNuxGcjCIenKdyQT6DAo9tLUPErd/Q/dj4FB97IaBvcXtEgppd8phj9/+hm4kV90QzJ75UxhoSiAOEcA6Gd45VjQBe/PgHwltYoAYDazKMjIFPHqOXxtDz1+XC77ad4ArrvKDuYq2jU9RX8bCcrnAqot37f6PlKY+I5qNsoAZNDQK32SGKHUZ49RtuombszGQ2rkiwgdyuxm7xVGSvvDosMDG5u2wOqFPvpwHuKXQUmERf5mgrqtV2HQfzbKF4ITWSEFnEneh65Yb8imIF6EeGgWWGTxfYy5TeumiU61q+okIzO+m/Ww
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
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/sched/signal.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 584ae88b435e..ea23c7e9db33 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SCHED_SIGNAL_H
 #define _LINUX_SCHED_SIGNAL_H
 
+#include <linux/cleanup.h>
 #include <linux/rculist.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -663,6 +664,31 @@ extern bool current_is_single_threaded(void);
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
+		for (p = &init_task ; (p = next_task(p)) != &init_task ; )
+
+#define for_each_thread_rculock(p, t) \
+	scoped_guard(rcu) \
+		__for_each_thread((p)->signal, t)
+
+/*
+ * Double loop: 'break' only exits the inner for_each_thread() loop.
+ * Use 'goto' to exit both loops; the RCU read lock is released
+ * automatically when the scoped_guard scope is left.
+ */
+#define for_each_process_thread_rculock(p, t) \
+	scoped_guard(rcu) \
+		for_each_process(p) \
+			for_each_thread(p, t)
+
 typedef int (*proc_visitor)(struct task_struct *p, void *data);
 void walk_process_tree(struct task_struct *top, proc_visitor, void *);
 
-- 
2.25.1


