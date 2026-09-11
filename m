Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD97C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C3A6B0092; Fri, 11 Sep 2026 03:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6F56B0093; Fri, 11 Sep 2026 03:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAE26B0095; Fri, 11 Sep 2026 03:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72F8E6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:58:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14F0C40129
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:39 +0000 (UTC)
X-FDA: 85200729558.12.03C3F68
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf11.hostedemail.com (Postfix) with ESMTP id 028B740007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YDo04jKQ;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwqjY1uH9twd1rFa96GCSIwqkODhjQwzj2w/OTsoXSU=;
	b=lQ45WQHeisPJe9hPDQl765A9hhE4twK+rQmtw4Zw1jkYelSfHCmuGajzSKWkwUExjLiwK9
	cBvNk/qEnyqR1v/1UZ9Aig0+QzlvF4KWfgz3ClAELdhsgIcCEmhdoPXiyYYNkmtHEa6h2X
	1Ux6DuXkY4aA77kyxjMP3Yh1AB+FHnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113517;
	b=aTei0Zdnp77CwdgeBmcdlRgO/DLqLEuwj1J3pf7j3lCupdm2+rOXxiiEUvaseQq52ycELy
	jvMDapnLl2A8X3J5ypV8Fw5orK5+70bWVAXiQ4blyZLIwyYcmqWI5yjGqpEaqwnb11CJDU
	EughWQrBusYUE4JaMY4vGDIVL306J0o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YDo04jKQ;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Go12g+R4uFq+BJOyGZXb1onOnQjq2C3kX1LePEwX1Iw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113515; v=1; x=1789718315;
 b=YDo04jKQh3Y3S/7i66rcYtGSc3d7mvbF64LTRqP+Bg0FwPAfDTuo6bmkKDAwMAxUsAZx7or2
 zMu+dH4a9q3u1OXnj6JEFkEU58VsCzOFCH1suvqM1aJ/NisObpY0vo7gaGIpYNr5XcjgYdsh60x
 t3glJoKXrukMfMOVzZIr/wDI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7120d82fe4ac0fd4;
	Fri, 11 Sep 2026 07:58:35 +0000
X-Mizu-Trace-ID: 7120d82fe4ac0fd4
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christian Brauner <brauner@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH v3 01/15] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Fri, 11 Sep 2026 15:57:46 +0800
Message-Id: <20260911075800.491472-2-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6mxo4oxjnc9hjjyhozqrx98eewffb5jh
X-Rspamd-Queue-Id: 028B740007
X-HE-Tag: 1789113516-609736
X-HE-Meta: U2FsdGVkX19eXcNdvk436x60dHVoX4vkcHPcqhi3RVkYXYFKJev7Y9uSVCYV85IKAwYJWrvlBt9LcjacwTH5obNx1YkTCPJ3nORLHIOvj/qaTv6ptrwAKC72414UUfwKD4PKmbYdGYAyVB+049tz1KS9XPReSAPCPpy5Q45qdCgiSaFcvVuDmz38WfrSuRS7x9Sf7O28Jr4buo1k3UKTuTfmufzWli7RwbJbMiz8RvihwxmwYd8ggJQL/znKA+oRfA0PJjz4UzUi4NBr5ZjTghs2DsFHziM+XQydx3+jp/inRwcJ48Sf3nYHEsSQdgz7hRdfIp+lsESIrUr3R8naxN3RJ+RKhl6Y0KKDW36qdCqdTYQf87NbZgVeWejBSASy405LP0x6sD5MSDbuUaAY/bZ/jj8Pjd+9uceLUuB9nl4oLd1Hag2TyCXN1dfw9X4SC8IsHaUTi/hbmhismMyC1KPXeCaobp2vNCYCtb6twhOLKwuZ4ntVw+BGG6gosKosvV+O7Vi9dXQJXkgQcxke0YghtGaWosyGyOCZcg+IrHFo+dHmpaP2xkinbJkaL6ZU+yCXGLlAZhWBwDe6E6okYhonvrx+fkB3RTRTeN+QcbJsEnbG0OSQU3nig9pRUPyhZWaInsQD7yFw8B2rSwFMnM7OJjZzlKAuMcW97q8jfaN2LVt5T20qqh8s2PYl+/H60vXmo0R3zu4RZwIcvpRN1+Ops2yE+b+pBl2qpUSpycv8O/CYSJ2NZFy86eETNximdgm29bEY4hBVribVaUGLBBL3M7HFpcIGfHsF0RV75rpps47aGiMNIWux7oavYVG8XHTaL+9/L4EvqyIvg58C0kC94UADjnYv2Y/iHL5szDsxHiBftAiTVyLeKA/S3COePNl+CH7bOe4nuISvOH/Pt6rtpq4jARZRrZ/eG+lM+AHj4W3jVmtO+ELqJ+9OVdJU/BAKAFv/G2SXB5S3lf9
 Ne9FFs/D
 2evUGARNp+169isfoI09xMQymlSc0p2tsZUZRtgor0KywuCusOA+SY5bP9BmM8t+VhxsJEc3oSbTMXg1bdTEr2n35HXHQTSPsdq/R1tXo3Tod4MfecSDLbIwVAQMLhnbOtCqXyxLPs2ONj4a+a69S4WheeKE/xGtG1664/qhXYwF0ePjf2KMo0/7OeuVCVQXqhgzuP1Az9jqjpX+99EEEavsg3Vg9ZIm2RB/HhtQqLndBt7CQUfxyBLcxWaVKTfTz9A4DuI/+P191wm31zSTESByOnqT+Yx9xY6nyNX2r/VqIfVoDo32EayHNOFeFVIjiaCGBaLzsTGh356wz223O5YVtctLILHunQi7fX+Oa0jNXt/qhK5cNI6lPPM13X+RBQtVwOEviCVvGlAFOFhBQKY2bLaTXSh0x2479mH6PAfBqkewdbCCUvRVP3yFRHCJLYP/rIw74f9lp/JBviexK68Li1SptqMBOlCBHcZ4F6xR6ffpQQftGXQ9Ku/+PjWJB3ewKLLG/UDY9VVU=
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
Changes in v3:
  - Indent loop body to show scoped_guard scope (Lorenzo Stoakes)

Changes in v2:
  - Rename macros from *_rcu to *_rculock (Steven Rostedt, Thomas Gleixner)
  - Improve comment on for_each_process_thread_rculock() double loop
  - Change prefix from mm: to sched: (Michal Hocko)
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


