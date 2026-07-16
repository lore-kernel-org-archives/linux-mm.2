Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67CEC4451A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0D26B0098; Thu, 16 Jul 2026 10:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139F76B0096; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F3F6B009E; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83D836B0099
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C4AA1201C8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:39:15 +0000 (UTC)
X-FDA: 84994897470.10.23F0BF9
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id 787DA40009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:39:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=XNl61S6r;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf12.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cw1rlTuFfFp7SknXN1+aFGRpA9XFW1cANtJlt4dCukU=;
	b=1DXZm9GcWBEBxaiygZvvPoG39paNFVsao1obdgdg2FMoTa7mTb/dXnpS3WB5qy3ZsgP8x6
	BFHoMbivpoDqsAjvoqYh2fdqiwK6QtE++j2xeCHf5T8et+NPaq7BwaSJ378EPjcrgN1SZ0
	z6AHBfrzEAeHfy+o3styRM6daKu2YdQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=XNl61S6r;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf12.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212753;
	b=5+AowHxFx3ETaLop5nHELeoDOMmwF9b6HtRcKTrYra0faRWpBdbKKnfWjFHN+d0qCfoE73
	z1RfvXGLX4EIEbczQ3r6A1TzkJKoYiFfOjavBl4UzWW8Rx+eq9kXhhX56M6aJcJ1wuDQG8
	2Btf7EsG6jENcrGAEIzuCf4KASOX/J4=
ARC-Seal: i=1; a=rsa-sha256; t=1784212452; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hy5rDNBZast0eykBaCv6ufiedcfgKRjR6aygvTFCz9TLz+7Ex+FiiuXoE/pX23/5DZINbhepeFFqaDX0bTciMNF6kgyMzXJ2rxo79QmKi6mZoAeFbwyWPEKUiesziMmE9V4zMMQoHdimz8mGwPppX7sfJ/I+RUZauyKckPdC3vI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212452; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Cw1rlTuFfFp7SknXN1+aFGRpA9XFW1cANtJlt4dCukU=; 
	b=n3i/Q8R4YmNAYHsFnpboyZz1ATCWLh+wgymzuF0CEIN6OSt258N/S8SssncUoaMCKr4iwDtCYIzxpLAJi4rjawMfUxN+AUw6OilC1CAS2erp62FSZiWLuxNmlhp8PH3MEe7nbW7kQ/G1+AQHDkvMjXaFVlTdMn0+8JXsAdx3I/0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212452;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Cw1rlTuFfFp7SknXN1+aFGRpA9XFW1cANtJlt4dCukU=;
	b=XNl61S6rk5rPBadEXOlRistorXRQ0OvlSyV1M08qb4pTY/UKcLfDPAu54kD5xlB0
	QXZxQZIQvg8WNBdNoNvXg4Ti4Nd92jFkLHa3EKrfowi1Fth/KzX8rRDKIPaq6r8Dvpk
	0meql2eoflsNpcBn/2EqTkKAUWhgQocgDFQ0Vr2U=
Received: by mx.zohomail.com with SMTPS id 1784212448529805.8984322688145;
	Thu, 16 Jul 2026 07:34:08 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 12/24] fork: let kernel callers create embryonic tasks
Date: Thu, 16 Jul 2026 22:31:38 +0800
Message-ID: <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: cgojmxq87zsbeu7m6hrur9f8mir7uia5
X-Rspamd-Queue-Id: 787DA40009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784212753-299406
X-HE-Meta: U2FsdGVkX18Rb0uOseq5uK3idzogigbdeqTB9be70vRtbPXcJGyrrtw12aANX//HRPhZ+wqs0NbJfCJcNwa6Bl0RSH1AYdxVErXx/r3uNDz4NFs+9q2nvrRo57gP8r8BZ+I9rq+L/t+9WM5xUgNwAWVraviklqIXzdzZOD4FrjnE7/vxVk2j2M9SVgwXKilvfJfL/eV1BQ+Kv5V8d8YMAcixXVH06tRLtkcUxxxyCNPjiVAm0KyzVW0u4gr0a2NBBB+/XAuN3kUbR2vPwICn2TVk+ISQdeT8OGI+pTfCBZ2E3ceNjdL7SsCTOgnvrNz8tlTW+XbOYdWa1IK0O/fpJjMUQB2TOQZE/Hyjs/wK5xrlZgNmUIZv8X/6YMgbY+Na2WZqPR+JqEcEzt6zb6LnRMdfcRxxVlMZUY+w6CHmfiyhIRaK2ECvGR9Emv3ioWBGqrJlcKOV5wyfNd8AvRaXZScxmUhHRFsK6ObCNh7+HDXIYbfxwFi1VS3FhK7JbVqPBaZutZDncI+X4+6ScHMdoxCJ63zLfKXt+aSYs/DxcMW0ynx8a9KKE6M+ncBHFavSb2mN14qBSZGtA9dJTSCekHe4rOpTqMptHpwMakVVgx+LABbYYiZy6jB8hUMXjajBOZ1Yx8X/O1iDlmtiIXjpsy0PbXZXek2/HJZctqmpDVJvi4Vnq0QXCTyNp42LkjHjgq8RYQbmGsftToarfVaHJ9GfdeVe5XT2NZKpBa6rgsBFASUpNG1zmW3m2IymIR1TeE4HabicRYhLXu5yFRGOJ4n8BcnAkf/dJLExwA8UeBC/LkLeL/oAizUGlFOg5LX+cYL6zVm3pMwj+9P8vMWAHnhOLvVtCBfxd+nh8floKRwzy8DKBhdvBXIKCMd1hNx3ftrwP+ktaH3bKf+MjP2B8WrD8WjA3ob/uae7LcMPu2r182sebZGTHCA+pxnASRJOFW+jQI3nE9lfdhnGKxG
 kwiwe5JA
 k4EVxVZXDCwFIh8xbYkCK6ID2jd13n1DfYqOAgEBnm/7/oNzK/H0fkLMgGyLnppTHxvJS8WIQIN25KIZatnffvklYuEHFygD3JTzMY2azDYMgWrCnVBnaVXDKRSUEUUfCc+FjS+KUlE4UywQceYMnk2SI9AZh5nrSQqHB+EEuOmSz+dD1OXogBBGGZsnlxWk2m0pygEULPAMZBWzLp2hPLh/k+Pl4gK5lSXgS+4AXIIP6mcL4XgfGoUYIX0kiL7Cyzg+CU0yyILomPGtwY2cPv89XOfrkEIdCRxzspkLw3gr6aRwxWT9j/0mLPZKu8OC4Vb7TxrJmKVxKk4AbFPw3ezn9IBLN8Y0MrKMeDRCpm7GV4KKIRF0JfOnYGMKEQp0GsPI7rRfqTjSfNw+eB2qDk+fhEZ1EpZrF2fvcJTlVzX3Shi9CWl7Z+8roZBCGxKvl8vIF2ufIgjFF/2DAtmkOoDp8deieT/UrEsQCwGw9udXKne4l9MotOjUD6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel-created task can become visible before it has installed a new
executable image or a valid userspace register frame. Exposing such a task
through ptrace can disclose kernel setup state.

Add a task-local embryonic flag and an internal clone argument for callers
that need this lifecycle. Reject ptrace access until the creator clears the
flag. Clear it with release ordering and observe it with acquire ordering.
This orders visibility of the completed exec state with the transition.

Existing fork, vfork, clone, and kernel-thread callers leave the argument
unset and retain their current behavior.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched.h      | 21 +++++++++++++++++++++
 include/linux/sched/task.h |  1 +
 kernel/fork.c              |  1 +
 kernel/ptrace.c            |  4 ++++
 4 files changed, 27 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 908aff695ef86..031ae92884c3c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1863,6 +1863,7 @@ static __always_inline bool is_user_task(struct task_struct *task)
 #define PFA_SPEC_IB_DISABLE		5	/* Indirect branch speculation restricted */
 #define PFA_SPEC_IB_FORCE_DISABLE	6	/* Indirect branch speculation permanently restricted */
 #define PFA_SPEC_SSB_NOEXEC		7	/* Speculative Store Bypass clear on execve() */
+#define PFA_EMBRYONIC_EXEC		8	/* No valid user register frame */
 
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -1905,6 +1906,26 @@ TASK_PFA_CLEAR(SPEC_IB_DISABLE, spec_ib_disable)
 TASK_PFA_TEST(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 TASK_PFA_SET(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 
+/* Clearing this bit publishes the register and security state from exec. */
+static inline bool task_is_embryonic_exec(struct task_struct *p)
+{
+	return test_bit_acquire(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
+/* The task is private during copy_process(), so no publication barrier. */
+static inline void task_init_embryonic_exec(struct task_struct *p, bool set)
+{
+	if (set)
+		__set_bit(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+	else
+		__clear_bit(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
+static inline void task_clear_embryonic_exec(struct task_struct *p)
+{
+	clear_bit_unlock(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
 static inline void
 current_restore_flags(unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 92b4e3bc31e66..5b7facf12b33b 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -45,6 +45,7 @@ struct kernel_clone_args {
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+	bool embryonic_exec;
 	unsigned int kill_seq;
 };
 
diff --git a/kernel/fork.c b/kernel/fork.c
index d16405c037c2f..e3ade83b2d4e2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2138,6 +2138,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_exec_state(clone_flags, p);
 	if (retval)
 		goto bad_fork_free;
+	task_init_embryonic_exec(p, args->embryonic_exec);
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d041645d9d17d..36eb9b154a397 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
 	guard(rcu)();
 	if (ptrace_parent(tsk) != current)
 		return false;
+	if (task_is_embryonic_exec(tsk))
+		return false;
 	es = task_exec_state_rcu(tsk);
 	return READ_ONCE(es->dumpable) == TASK_DUMPABLE_OWNER ||
 	       ptracer_capable(tsk, es->user_ns);
@@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		WARN(1, "denying ptrace access check without PTRACE_MODE_*CREDS\n");
 		return -EPERM;
 	}
+	if (task_is_embryonic_exec(task))
+		return -EPERM;
 
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
-- 
2.52.0


