Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EB2607D6A5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2zOkQqV
Received: by kanga.kvack.org (Postfix)
	id 694986B05BB; Wed, 18 Nov 2026 14:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D1D6B05BC; Wed, 18 Nov 2026 14:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497946B05BD; Wed, 18 Nov 2026 14:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 120066B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5451E1A0885
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:03 +0000 (UTC)
X-FDA: 85449245406.30.CD1DE8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7392140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2zOkQqV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ctpsmhbyotylAB6OOcib6fh861mOu3WKscyAmfRUVA=;
	b=nY8FDXcPDC4R6xpuh4pT6bEDvdRjIBcxEoV0Z2S84CK80uVwLk6rdDw6lRMq/8rgxXyfXv
	AsZmWmRYfGu4SbGxcBseDI6eyKwOy0aG0Q+/hS2ntRZlB6IHj9OH4bItolS7zc4gXPT3On
	0JgN+Yt2hz2Zzj3rI4tvCXFvs1ydxWw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2zOkQqV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030561;
	b=jJFakjtIDnejvIJYVVuEpFrtPkwXxvempWhBc0aAqAyp8XRyEmy2lHNIM4qic0YjZ8In8m
	7SKyd3bby26vvOEl+M9OOTy0cjLBPSThbDo5xrIdGI1Rp5MKOCw57FcwAmL2nFmSl1xJDS
	Z7FL6THgRbUpsGJoAEJOn5Uwu/N1zjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id F2ED943862;
	Wed, 18 Nov 2026 19:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1CBE11F000C5;
	Wed, 18 Nov 2026 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030560;
	bh=0ctpsmhbyotylAB6OOcib6fh861mOu3WKscyAmfRUVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2zOkQqVHmHg8iLGsx+lhodz/2uGa4/pQ/+IWwTzHOXv/pIQEtrEW/+HDUrw8fkrz
	 aPNNXp3lQL/6iCKyi2k/hn3e7lmabJKG9vpto7CYqhUFUp1Z7KZQSkc/iTMpVJZH2W
	 CGWhf6XPYtgb9O/6q95TDrbn9wnuASgTJrWT9jzTZYvyeK5MZ/rL3R8cDllZcdg/Ug
	 M/EF/NVVPNa8jNdtBQn8ZehMQgIATNmIZ7Oj0xl60dCm7sbnBWiREOzw/SL7sPTFLm
	 cZOyp6FOY6JXcJtvgg+HjVKlogYjjB6xYZCFL32UvqSjKyKfwawshRBLjXBub4/8lW
	 m0DjyT8fFOp0A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 03/13] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Wed, 18 Nov 2026 21:35:29 +0200
Message-ID: <20261118193539.240065-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5fde618hdfw963dy185ogbd87ujaa41w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7392140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795030561-756662
X-HE-Meta: U2FsdGVkX1/Ifozi6sh2SsBBreqJ9GNuOc/qPN7dxkITzsqIJbJ7CuqUDEn0XibRwjJ3dyNxO3Xi0fa4VREDiuHqEV1qVN5YRyE3EloMeXkKc7AVci5KN2uvN1/poLX09Waw+VxlS0eWOxwFumc4sADxbCEs8sl18hpzbUkiAdgb/263JNSGHmOAxe72ZiXkHVK0oo5/5dMbv27gUdSHXZ5X+gz/7ZbbMObhpSuZ3eP9BpJytUMFvtDXYwBRCCLtOvkZwhCSJW9w8NwxgjzNu0FXFxE5yD0Xtd2ZiGsM9fahaCX4eBHXkeAVbJ0va2MIbWfLrTlEzYv6yp0XQ5opmWCq+Mth5q8QGnT52FwSTNr1du+9Nf2979TWJK+Ny7+lByA8iaKY5IH9tD9wlXsSuOpgSO1yB5qOvmUTbX8ulC1TD7S9IpzSuVHM4Cu07vIH8yTBpJGINU+sIY1lbUKeizcm8gm60wL5CTA8av+QmeMDRfugZKSkbU8mccv306TYSqSfJuO6jDHnIpq2YSnK5gibIzTfvLyc6abQChwE2BLSn88FBpcquQLNfMa8s7WLrKaaWNeRZIew6XB0BGYMhsMKs5Sx0TJ4ebuofbmYU1/PDY7EDIaSsrGWtjwiEZwnLj2f0t7yGI9FlLvUhJOxLmVSA+ixlRn2zVkvie3RMvv9Zy2KNPWSe4+t+AvgQ3v62Z3ym1rz0rmp+zoyH/jyk8lAyNKEZxC51z+eZI4sld6U1cdAiDM06tM/F/RXEG5nF2+yAwF0IkPZBtFu0il8hzexlwh9XcaOXm5e1ZYTTzXMLY4HdLY2QwVgyRDmlRuXErrNPFCNcodNn3NworC4pWQ0Tn1AATpaggUX+q7ZJR147JMDdDpwads9M/bbMQgkajGa/qAWMQHiGBXrDxPUZRR0nYwkxg3DpBhMn97npp2n0D+ZH9NFSlZANpFZXAWa1MudgnXfQpvLs1lBZXd
 63hT/Cuz
 kRX6YDTrk/lHvaAnD5pMcks4iwclQLgX3YBz/SkbUoGixblLbL/U6J7/MN80PCG6m44Ok8yT5/+8EBUewqVZAfmHwH8T98cu0NjAUDRJOyUM06S9yHfkPONgNnklijW5F9LHbQYX6Ep4Wf5In0EG21+zNynTSiVsAycBi9vDFJyax+K8RHdLjqnRuYk2GUUvPbIHycW9dLw0gkPkGq30RBwEsGgsN6cV23P+qOdhIncynTWCDGTrfiwBea4+nhlM50tfsqFy8R0Huq7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status and resource usage once all
processes in the root namespace have terminated, without serializing
normal fork() and exit() paths inside the container.

Commit the bootstrap child reaper, bind pid_ns->rootns, and wake waiters
in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 +++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 41 +++++++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..6fd959f4d0d4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct rootns;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index a1b2c3f8958b..2c34d6cd211a 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -14,6 +14,8 @@
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 enum rootns_state {
@@ -43,6 +45,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -57,6 +62,16 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct pid *pid,
+			       struct rootns *rootns)
+{
+}
+
+static inline void exit_rootns(struct pid_namespace *pid_ns,
+			       struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..08fc28ad1eed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/rootns.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			copy_rootns(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..081c27aa85bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	exit_rootns(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 4c08ac575f6c..4f40dac4225f 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -158,3 +158,44 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct pid *pid, struct rootns *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != ROOTNS_FORKING)
+			return;
+		ns_of_pid(pid)->rootns = get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_pid(pid));
+		WRITE_ONCE(c->state, ROOTNS_RUNNING);
+	}
+	wake_up_all(&c->waitq);
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	struct rusage rusage;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+	getrusage(leader, RUSAGE_BOTH, &rusage);
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		c->rusage = rusage;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	wake_up_poll(&c->waitq, EPOLLHUP);
+	put_rootns(c);
+}
-- 
2.47.3


