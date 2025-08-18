Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09019CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F396B00D7; Mon, 18 Aug 2025 13:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99566B00D8; Mon, 18 Aug 2025 13:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A9F6B00D9; Mon, 18 Aug 2025 13:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB0A6B00D7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E71016096E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:31 +0000 (UTC)
X-FDA: 83790496902.01.107EF0B
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C99F40013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V99YPHhZ;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMXbpPyZn28wNi81Xy52IQ6/8O/P3CwcUXlLMg8zaio=;
	b=UGznTETtDXSmOpifIRUn9lVef0+F5aH2m8/Plg+ES84GNyd8l8Lc7hAKASFhswneiiJetr
	ei5Wktk46VLuHfFBxfYEFi1pEqUKyoOXurgdt99ij7WO8HDctPBQyoQ/SRhfIny3HF0Khp
	Cur322xOzvcA3uAad3rc36Gr+AUmH5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536549; a=rsa-sha256;
	cv=none;
	b=7JMWR7WmOOfhUdEifs63kytFN6rGLDEEEY00OUgmgAT7q6n423WanDarHo9OBl9ytIh5mV
	FErkzAzQioFxR3/RdevIyv5HEnzntCgFlWugVk8TwMEOEj2II4CL0/0H5m/OwLBq0cyoiv
	xz51J1b6CZosjo5sJnlpPsDpvGshhLw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V99YPHhZ;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMXbpPyZn28wNi81Xy52IQ6/8O/P3CwcUXlLMg8zaio=;
	b=V99YPHhZQ+9Z8uCLGLL9YKz0afO/2QEMrxwXJ5U+Jz6YIUa/0QAzy1yphb3RyW4jRP64q8
	BtPn2FKzKyGcaSeG+ltwX+S0XBJlvC7zRp5ZIN/+P0BbBr/JsoZeZDsv0ToPKeLFKTpxv5
	yDjDkKAMKljjERe5aBtchFJSAkvxJuo=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 11/14] sched: psi: refactor psi_trigger_create()
Date: Mon, 18 Aug 2025 10:01:33 -0700
Message-ID: <20250818170136.209169-12-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C99F40013
X-Stat-Signature: 1jzbpd6zkzd9mncfumjz6ek9ybiqdfrb
X-Rspam-User: 
X-HE-Tag: 1755536549-130602
X-HE-Meta: U2FsdGVkX1/F/nIDxlHGeO8+FK9CKZuDXR9pdBsbZCRXlm9kfzpaUDiAO342kuw9zRmXSvwwZqph2Ftb+Ey48y3tVzoyRX/mIx9Y1vb9RE+N2ZcTzayZn1rA63vP8AlnGshpniho4jnaivY+DUdBhkXNzXKm2/uE2Kst9fCLiGWMCM/30GzJQd8Gjg4Shv2pa3eiF9KMOqii4dGCyuTFPR+p6YPjel+nBmJB5ovP+xOv6RP7L2Yjsurtct3AlOjAxCWJjNkS+ZYV5vIaQudn60TX9zk9M3bQgFkAlg0GEGLqg9PFwmevjbf5AHt6aL/uFAW5q8mlgGtwPiziXgavFDbPxLfnKPnlmqoXUp51+J8TCjvZL8+RXF9J0fApbnLhnXSsIeUtvpNFBGUQ/LGrI+8sbB8/D52xLMUnhj7cD43ab/LPw+2nUaDm7k3k5QPuiitO6zL3512kKnKjUXJJIhbWzT38LSAZpnVy02ES0JzbEOH2ECOVtcjEwbjtU1uXLIdHw9e/glZ4gCkEZVElAQWNNwkrG8WWT6I3xztkc1VYoESuNCyaFcJ42nyCSf85F1KA7wtKkj+pytrGdax9JbaE20oxqtZQz0iDUgY2uBvUAhxI/3TZGZGZ+AAhVUYCcsIZs+cHA/KKCSPz+cB2D4t9cxdLVhpy8VFjG1bPkw0Qd75OL321RhT3eBAlm2buyxM0TbLcV9IAiXCat98o/B4zCqANlaJv637D9AKxPaGVg/NHWUyFydEOszwI+zk3CWIlDtgCYBE00ToOVRzNthbEh9sGbPo4Jvwcm+9DBjsJvRrUK18nUhGh92htkSzHVzyOmgCwVuYg9cEtplw6tnkx21/c5ffu4z7MkTbPfu2ZHdT4KrWUprXzMYRwFdCI+DKErU88+GkqVShOJJ/Dhee6pw0YJdOC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently psi_trigger_create() does a lot of things:
parses the user text input, allocates and initializes
the psi_trigger structure and turns on the trigger.
It does it slightly different for two existing types
of psi_triggers: system-wide and cgroup-wide.

In order to support a new type of psi triggers, which
will be owned by a bpf program and won't have a user's
text description, let's refactor psi_trigger_create().

1. Introduce psi_trigger_type enum:
   currently PSI_SYSTEM and PSI_CGROUP are valid values.
2. Introduce psi_trigger_params structure to avoid passing
   a large number of parameters to psi_trigger_create().
3. Move out the user's input parsing into the new
   psi_trigger_parse() helper.
4. Move out the capabilities check into the new
   psi_file_privileged() helper.
5. Stop relying on t->of for detecting trigger type.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/psi.h       | 15 +++++--
 include/linux/psi_types.h | 33 ++++++++++++++-
 kernel/cgroup/cgroup.c    | 14 ++++++-
 kernel/sched/psi.c        | 87 +++++++++++++++++++++++++--------------
 4 files changed, 112 insertions(+), 37 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index e0745873e3f2..8178e998d94b 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -23,14 +23,23 @@ void psi_memstall_enter(unsigned long *flags);
 void psi_memstall_leave(unsigned long *flags);
 
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
-struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
-				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of);
+int psi_trigger_parse(struct psi_trigger_params *params, const char *buf);
+struct psi_trigger *psi_trigger_create(struct psi_group *group,
+				const struct psi_trigger_params *param);
 void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
 
+static inline bool psi_file_privileged(struct file *file)
+{
+	/*
+	 * Checking the privilege here on file->f_cred implies that a privileged user
+	 * could open the file and delegate the write to an unprivileged one.
+	 */
+	return cap_raised(file->f_cred->cap_effective, CAP_SYS_RESOURCE);
+}
+
 #ifdef CONFIG_CGROUPS
 static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
 {
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index f1fd3a8044e0..cea54121d9b9 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -121,7 +121,38 @@ struct psi_window {
 	u64 prev_growth;
 };
 
+enum psi_trigger_type {
+	PSI_SYSTEM,
+	PSI_CGROUP,
+};
+
+struct psi_trigger_params {
+	/* Trigger type */
+	enum psi_trigger_type type;
+
+	/* Resources that workloads could be stalled on */
+	enum psi_res res;
+
+	/* True if all threads should be stalled to trigger */
+	bool full;
+
+	/* Threshold in us */
+	u32 threshold_us;
+
+	/* Window in us */
+	u32 window_us;
+
+	/* Privileged triggers are treated differently */
+	bool privileged;
+
+	/* Link to kernfs open file, only for PSI_CGROUP */
+	struct kernfs_open_file *of;
+};
+
 struct psi_trigger {
+	/* Trigger type */
+	enum psi_trigger_type type;
+
 	/* PSI state being monitored by the trigger */
 	enum psi_states state;
 
@@ -137,7 +168,7 @@ struct psi_trigger {
 	/* Wait queue for polling */
 	wait_queue_head_t event_wait;
 
-	/* Kernfs file for cgroup triggers */
+	/* Kernfs file for PSI_CGROUP triggers */
 	struct kernfs_open_file *of;
 
 	/* Pending event flag */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a723b7dc6e4e..9cd3c3a52c21 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3872,6 +3872,12 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
+	struct psi_trigger_params params;
+	int err;
+
+	err = psi_trigger_parse(&params, buf);
+	if (err)
+		return err;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
@@ -3887,7 +3893,13 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
 	}
 
 	psi = cgroup_psi(cgrp);
-	new = psi_trigger_create(psi, buf, res, of->file, of);
+
+	params.type = PSI_CGROUP;
+	params.res = res;
+	params.privileged = psi_file_privileged(of->file);
+	params.of = of;
+
+	new = psi_trigger_create(psi, &params);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
 		return PTR_ERR(new);
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ad04a5c3162a..e1d8eaeeff17 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -489,7 +489,7 @@ static void update_triggers(struct psi_group *group, u64 now,
 
 		/* Generate an event */
 		if (cmpxchg(&t->event, 0, 1) == 0) {
-			if (t->of)
+			if (t->type == PSI_CGROUP)
 				kernfs_notify(t->of->kn);
 			else
 				wake_up_interruptible(&t->event_wait);
@@ -1281,74 +1281,87 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 	return 0;
 }
 
-struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
-				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of)
+int psi_trigger_parse(struct psi_trigger_params *params, const char *buf)
 {
-	struct psi_trigger *t;
-	enum psi_states state;
-	u32 threshold_us;
-	bool privileged;
-	u32 window_us;
+	u32 threshold_us, window_us;
 
 	if (static_branch_likely(&psi_disabled))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	/*
-	 * Checking the privilege here on file->f_cred implies that a privileged user
-	 * could open the file and delegate the write to an unprivileged one.
-	 */
-	privileged = cap_raised(file->f_cred->cap_effective, CAP_SYS_RESOURCE);
+		return -EOPNOTSUPP;
 
 	if (sscanf(buf, "some %u %u", &threshold_us, &window_us) == 2)
-		state = PSI_IO_SOME + res * 2;
+		params->full = false;
 	else if (sscanf(buf, "full %u %u", &threshold_us, &window_us) == 2)
-		state = PSI_IO_FULL + res * 2;
+		params->full = true;
 	else
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
+
+	params->threshold_us = threshold_us;
+	params->window_us = window_us;
+	return 0;
+}
+
+struct psi_trigger *psi_trigger_create(struct psi_group *group,
+				       const struct psi_trigger_params *params)
+{
+	struct psi_trigger *t;
+	enum psi_states state;
+
+	if (static_branch_likely(&psi_disabled))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	state = params->full ? PSI_IO_FULL : PSI_IO_SOME;
+	state += params->res * 2;
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-	if (res == PSI_IRQ && --state != PSI_IRQ_FULL)
+	if (params->res == PSI_IRQ && --state != PSI_IRQ_FULL)
 		return ERR_PTR(-EINVAL);
 #endif
 
 	if (state >= PSI_NONIDLE)
 		return ERR_PTR(-EINVAL);
 
-	if (window_us == 0 || window_us > WINDOW_MAX_US)
+	if (params->window_us == 0 || params->window_us > WINDOW_MAX_US)
 		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Unprivileged users can only use 2s windows so that averages aggregation
 	 * work is used, and no RT threads need to be spawned.
 	 */
-	if (!privileged && window_us % 2000000)
+	if (!params->privileged && params->window_us % 2000000)
 		return ERR_PTR(-EINVAL);
 
 	/* Check threshold */
-	if (threshold_us == 0 || threshold_us > window_us)
+	if (params->threshold_us == 0 || params->threshold_us > params->window_us)
 		return ERR_PTR(-EINVAL);
 
 	t = kmalloc(sizeof(*t), GFP_KERNEL);
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 
+	t->type = params->type;
 	t->group = group;
 	t->state = state;
-	t->threshold = threshold_us * NSEC_PER_USEC;
-	t->win.size = window_us * NSEC_PER_USEC;
+	t->threshold = params->threshold_us * NSEC_PER_USEC;
+	t->win.size = params->window_us * NSEC_PER_USEC;
 	window_reset(&t->win, sched_clock(),
 			group->total[PSI_POLL][t->state], 0);
 
 	t->event = 0;
 	t->last_event_time = 0;
-	t->of = of;
-	if (!of)
+
+	switch (params->type) {
+	case PSI_SYSTEM:
 		init_waitqueue_head(&t->event_wait);
+		break;
+	case PSI_CGROUP:
+		t->of = params->of;
+		break;
+	}
+
 	t->pending_event = false;
-	t->aggregator = privileged ? PSI_POLL : PSI_AVGS;
+	t->aggregator = params->privileged ? PSI_POLL : PSI_AVGS;
 
-	if (privileged) {
+	if (params->privileged) {
 		mutex_lock(&group->rtpoll_trigger_lock);
 
 		if (!rcu_access_pointer(group->rtpoll_task)) {
@@ -1401,7 +1414,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
 	 * being accessed later. Can happen if cgroup is deleted from under a
 	 * polling process.
 	 */
-	if (t->of)
+	if (t->type == PSI_CGROUP)
 		kernfs_notify(t->of->kn);
 	else
 		wake_up_interruptible(&t->event_wait);
@@ -1481,7 +1494,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	if (t->of)
+	if (t->type == PSI_CGROUP)
 		kernfs_generic_poll(t->of, wait);
 	else
 		poll_wait(file, &t->event_wait, wait);
@@ -1530,6 +1543,8 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	size_t buf_size;
 	struct seq_file *seq;
 	struct psi_trigger *new;
+	struct psi_trigger_params params;
+	int err;
 
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
@@ -1543,6 +1558,10 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
 	buf[buf_size - 1] = '\0';
 
+	err = psi_trigger_parse(&params, buf);
+	if (err)
+		return err;
+
 	seq = file->private_data;
 
 	/* Take seq->lock to protect seq->private from concurrent writes */
@@ -1554,7 +1573,11 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 		return -EBUSY;
 	}
 
-	new = psi_trigger_create(&psi_system, buf, res, file, NULL);
+	params.type = PSI_SYSTEM;
+	params.res = res;
+	params.privileged = psi_file_privileged(file);
+
+	new = psi_trigger_create(&psi_system, &params);
 	if (IS_ERR(new)) {
 		mutex_unlock(&seq->lock);
 		return PTR_ERR(new);
-- 
2.50.1


