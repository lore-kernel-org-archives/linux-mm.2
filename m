Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8042DCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD4D800BB; Mon, 27 Oct 2025 19:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D9A8009B; Mon, 27 Oct 2025 19:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAAEB800BB; Mon, 27 Oct 2025 19:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA16F8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40BA212A143
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:59 +0000 (UTC)
X-FDA: 84045471678.06.5FFA6C2
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5ACE3A0008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cRZVPjq4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fpx83VmXhSXA3iZoTTu3uB82TfMzg8o1yaXlXxkl2ts=;
	b=4nnpzu0pqdka8gH17SaYiFFRCp26RIx/saEmyoy2BgVDx88t/zTUFCVLVo2cRwrFgzZMoT
	jt8WmiWTaLJzn+K5H04p8dfnM0uSzf4GTeSueAfoy4cN9vFcNTJFYE/q1Pdx8FniGeIcTy
	Dv+QcS/yChZy7fuFhjYyAL0z/WVcE7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607377; a=rsa-sha256;
	cv=none;
	b=cl0qeG8DxEgqlVqw/rAIGJvLz3JySv4MPENDTzENkUf+OdrcRwJWuvN5ILeuyEB4QVZWZS
	45fGu3pDSEBGLzd1D2oZKHqD3WvIlR7r0/IeeThs3h7QXz/cKqgu3mHB7Wr4zocnluvs8P
	hI4FlKhqbck+Ks6nkDSKB48E+Oc2XV0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cRZVPjq4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fpx83VmXhSXA3iZoTTu3uB82TfMzg8o1yaXlXxkl2ts=;
	b=cRZVPjq4veM1ffE3TOeNuzgakh/gbAZksO4T3TbNy/RutNjjqJYSAfqBF4g84QiCZcq1NW
	B8pdACdhed5GKS1MvdHPYgCxhVOy/J2nEB5HLV+QD7c/mH4Ar/zs8YWqsqWEBfyFebPut7
	H+87v9PRqNvgFfLoKSZSog6yHvzHY00=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 19/23] sched: psi: refactor psi_trigger_create()
Date: Mon, 27 Oct 2025 16:22:02 -0700
Message-ID: <20251027232206.473085-9-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ACE3A0008
X-Rspamd-Server: rspam02
X-Stat-Signature: zy9k6jmjgyamhzuaem34hqgxkqmectqo
X-HE-Tag: 1761607377-395086
X-HE-Meta: U2FsdGVkX1/CVB9Gew7FcfM/OFZtcrZXO5UT7awcL3GdxcXibp5wfGZm1lYWDnWJMlbphYgbDbjgpkVA2dl3n/nZxbn+4fj+YeNle+o2bQ9y8lb9BaJdVHDK1iRdGXrXq1+3XvjTgcjNp88CbyLZw3W51Z6ri58YjBt5vpfSLwrGAbfjSwRb5f9a1YpNF6Axu+vlWWrXLUH0b3X5gABGlOxMYEyldaiUpWjeQDwhfF63HjrE/ka/PSG5bwjafFb43HJC1scbtH03itDAgJOFIrEEdaGXHRl+rTgIAZFLsYzJCxW2bTO6/utwpsap9TdkYnMGe2Q65NwChKiQXb2tGMHH8UaPdbs03q8I91x0ubAUiv7imbIxbuIORb/NXahFdhkfkJqISwjVJoAW/nQUa/R2crFzZt6sSkOP7pUiB654VTSbHIv13qcCrtkztLNeic/9yeYUXU3YRlB7sctjLvCyAM0YHccv2jU3Xcr0Y5OkQrzXLYLQUaCZQYLR3ySs5HvGUFDGg3uj1wfyuAjZ+v7QNTRxQxvIsywr4VSqaxxOGfnZwKoXIYTnMOb3oYI2PJp1qlnOuvPz8wCFZCheb2q/HNMxJ04Newyr1QyxmnmzICDG8JuXUskqtRUYJUIUKbZyowyJIBF8BefmnWbieoJv5y+IQa1Tg4HVERBp+JW4SniCwoLBZKVPWIAhChWJahm+0A0LEA/9Hu9YeQSIrrJc23z/AR2z/4MqP2f03S8J1u4wBY3EbEpOMqFrqGp+CgQmCNIsP74Reoqk3UAP91afRyDUOCWLrvoot/LKQvg6pAUtRq3KHynZ+R+VxGujHhq/mQwJeXOq5GwTPMErP5NPrxhMTzA8w80bs7bfSOFNrI/6fj1CiryClqk6VdwwMevcmu99KIysvnTAaYc1Xc3PQ9ajqjVbUUmuCTn8D7J7UXhchWay2E2TLUE6E20qLCF/xuNHqrr3c3sfcci
 zrbwHlET
 wDIqOQ3U+ChGyiQmH858IkfWr4kwYzar0R8+em1+/A2vjABYqljtGTiCdCZDeSdvx/sy1xIstNI530kp8Sb0WjTTVPxMHxZic8W3Jl7VjzgoKuh5NLnFPNO8yArIdMcQj7hmRvdUwcj0l+kqFJy0voHs5nR+Hs93SMTYjuIWujUW8NkcSki5F4E7Nir7vWn7Eh3+EzAehHBgCE9fwd0QqeDpH7Io1at0vNdy21viokywCjguxfHihdsblY8OKKBirMW2q6wjz9pzY63VOR5feQe+FmrGsjERcZRgH
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

In order to support a new type of PSI triggers, which
will be owned by a BPF program and won't have a user's
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

This commit is a pure refactoring and doesn't bring any
functional changes.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/psi.h       | 15 +++++--
 include/linux/psi_types.h | 33 ++++++++++++++-
 kernel/cgroup/cgroup.c    | 14 ++++++-
 kernel/sched/psi.c        | 88 +++++++++++++++++++++++++--------------
 4 files changed, 113 insertions(+), 37 deletions(-)

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
index dd10c22299ab..aa5ed39592cb 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -119,7 +119,38 @@ struct psi_window {
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
+	/* Resource to be monitored */
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
 
@@ -135,7 +166,7 @@ struct psi_trigger {
 	/* Wait queue for polling */
 	wait_queue_head_t event_wait;
 
-	/* Kernfs file for cgroup triggers */
+	/* Kernfs file for PSI_CGROUP triggers */
 	struct kernfs_open_file *of;
 
 	/* Pending event flag */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6ae5f48cf64e..836b28676abc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4000,6 +4000,12 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
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
@@ -4015,7 +4021,13 @@ static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
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
index 59fdb7ebbf22..73fdc79b5602 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -511,7 +511,7 @@ static void update_triggers(struct psi_group *group, u64 now,
 
 		/* Generate an event */
 		if (cmpxchg(&t->event, 0, 1) == 0) {
-			if (t->of)
+			if (t->type == PSI_CGROUP)
 				kernfs_notify(t->of->kn);
 			else
 				wake_up_interruptible(&t->event_wait);
@@ -1292,74 +1292,88 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
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
+		t->of = NULL;
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
@@ -1412,7 +1426,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
 	 * being accessed later. Can happen if cgroup is deleted from under a
 	 * polling process.
 	 */
-	if (t->of)
+	if (t->type == PSI_CGROUP)
 		kernfs_notify(t->of->kn);
 	else
 		wake_up_interruptible(&t->event_wait);
@@ -1492,7 +1506,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	if (t->of)
+	if (t->type == PSI_CGROUP)
 		kernfs_generic_poll(t->of, wait);
 	else
 		poll_wait(file, &t->event_wait, wait);
@@ -1541,6 +1555,8 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	size_t buf_size;
 	struct seq_file *seq;
 	struct psi_trigger *new;
+	struct psi_trigger_params params;
+	int err;
 
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
@@ -1554,6 +1570,10 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
 	buf[buf_size - 1] = '\0';
 
+	err = psi_trigger_parse(&params, buf);
+	if (err)
+		return err;
+
 	seq = file->private_data;
 
 	/* Take seq->lock to protect seq->private from concurrent writes */
@@ -1565,7 +1585,11 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
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
2.51.0


