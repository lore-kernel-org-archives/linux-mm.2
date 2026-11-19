Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3F4606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqAmwIAD
Received: by kanga.kvack.org (Postfix)
	id 340236B06E5; Thu, 19 Nov 2026 17:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3186F6B0706; Thu, 19 Nov 2026 17:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B0A6B0707; Thu, 19 Nov 2026 17:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D57B16B06E5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:43:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E882A8B6E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:43:46 +0000 (UTC)
X-FDA: 85453347252.16.50927B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4020C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:43:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqAmwIAD;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128224;
	b=iujS2v5ouc+A4GL963Py+J9CfEdJjQ3ls6e3Sp3WQMV6KcDA6obETpDzw/6DHD8xqiOuAu
	oUGOnDdYznzdN37erBW3wvsWaFFLb5chnmOXS8LDzKXG4lY9QDjn709YAHkrQaXlHj7S7y
	Vw337GoFuWeAb29jMkfifbFYGFFaHL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRQovrukGv04cJ+t7fEPlO9r8OAb8ireDPkh8aF4iko=;
	b=SvKjfyAmR9GB09L/WWvq3QqeuLQwdmw6wfwTZe3EzXIjJKU2+Jw61YoiHankN8uRClZDHG
	f/xhXhKtA+FLsEraEvQY2DYnAopw08ZvFbuDX4NlJY3xbw5LA3uWKXC8VswBCU2titkPHM
	lDdL5Kl+FdYptSTSx05YGc0hfbRqhS4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqAmwIAD;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E86CE4379A;
	Thu, 19 Nov 2026 22:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1444F1F000C6;
	Thu, 19 Nov 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128223;
	bh=zRQovrukGv04cJ+t7fEPlO9r8OAb8ireDPkh8aF4iko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqAmwIADSCvztT4Xn5UwJrs8o5NaXnyeHoN0NceR94mxjJtP2Ow8aOP7YOjZyXGfJ
	 OFWly6MoIVQK86qBzpj57ETRgv3ZdXjULpBBNzh0qHnfqfxXRi1yc+R/bwaSsvCBU1
	 LQdrUFTCpcp2YKRXovU5VVGtljsldJ3CvAzCHpxCl4crYnVJEfnajIlZCOkiylRRVj
	 wPJ2wn9THlW/zIXMvk+APK0dUC6DJXDqAjWbbsCKSFDt2KCBLEDk8ybBHu1e9vqMWn
	 n55aNTP5IQtAZ8mO4KyGIeoNVZrfMPWXSFOptCjotNs/q6nL1I0YvGRdkGf+IG2CZN
	 2hG47lWkJCO6A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 03/14] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Fri, 20 Nov 2026 00:43:01 +0200
Message-ID: <20261119224312.1037966-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4020C0005
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: syfadhbfdzugrik9n6tyzwhffunerxyj
X-HE-Tag: 1795128224-686048
X-HE-Meta: U2FsdGVkX19UAx1ZtTttL+GEprQvITZnDZULe7PAVfWiMNOLISZEn+ESN8CSosCKBesKJ2sSkY6PUe4cmVdemX/jVGgI8scfA+DffSaOsRLmuSkpZvWp0768mBtqi8S1cyISFm4qHNaIYT3mtvJF6rmcUqXEVAM/FhoWtDrU63xrAz0fJBjC7daJkagcKwdqprWNTwJJOed6ci/yUx3GmZ7+QEQOFdH5xEG+pJ7npuHhPsezXa9UtdV2cqbAz0ElJ77z6JnmTxCsZEPgqcpcvJYnZuScWU7Soo+0fUs4IWSOPhwyEYimc18lteB8Y15oPm8WnyOQGKzYEDuUWsUTiDavqLYSVmzryzgiBqftBhzvvIoi+gh4XHL9ObxO8e8Vy/M5fYoFajyHXvcDbL2id3USVX3HxnY+AvNcUO4IhDyFKgMzlUDjsCnhmPkimtKzAuzQMLrWPi6xruHkYs9iExuorznRpF9k/mTYoYEDXAZqrKi0vgoZbCBn8fNbe1vO9SGI11MPzVv0TFZhBqwDk2zciBGOXecqooWwAp4DIRe7urvajLtsdunUcHNWzFc1GgMuAwsJXDwb292VWXoET4Se1f5glthlSWRCO98ErbHKGwHzGItHWzOYU4nkZnIkaWiNXnzhn4YS5+LYHT+wwk3qpKr1rKvKdRyMr9dCFhQL0gTw5B0j2IKqo1dn9IXed/FP48rG81yy6TZGGE8XkcvAbyz9LBitTQ5nenfUE7jxSHV8KXQtL8TxNKi2nOuChOTMDg/sLXFh/qLxv8TUT6jjgZ7nCUjhpDqXi286PyqFRT+NYJW7o1pgSZ85qEbsXWfVOhayooQLV6S33Hmn6p53dOuU8M+4E5uTo+xhqHvZm5lk5u+xPvjgWUheElj9V8n2XDk8a9jSQzqHvmMCmZXVAABebBuohclxl5kQFOXyGCM4Nmk769W2csSGTHr53OycX0uU0SKhhr2ZA3U
 OuUmS+V/
 FbYxTrx3bcKim94V6qISfPyjgykAOlrVEiHcN0fcKEcsqbT57FOq7b7sGY/5yrXYh6NbfFJBTA+sFMTnftjL76prOwCxOU6Cu+598+6WwNlT/ytmZyf3kfCcQSY07Ar/DwOWZPfnxnJBHBuGohBrg4LY6Lr3/5/WoPVxXmTjbdm+fQi+ZIoodK6V9zn8Zj6aB5yE3j3n3ta3aXuShZVs/XFUMmwPWyayrpol+IKMDSVtWAn4zkrf05MrwB4fu+YHE3hD5u4XB00bncMPsmaXgWBcnNjiSih29yd0oTjuCb73Wraaeq/qb5grGW2XP6An8Fj/KGnF81YHC1gzMMwubN9YYIVxJZ3I822Z7ZHP0BIlvTGKn8O2Dx55FqKDZPHWT1PC6wLN9yOZ/jHj/B5JNqoNO1eSOb4ItHKgYSQN5fermgaJMC+dOBZ2XyyUuhLIhovivKbjEdZF6sliBq6xwb+42zGuTv+f2EMiCOjFY+7uS/Ko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status once all processes in the root
namespace have terminated, without serializing normal fork() and exit()
paths inside the container.

Commit the bootstrap child reaper, bind pid_ns->rootns, and wake waiters
in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 38 +++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)

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
index 3f59415efadb..0557ce75195d 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -13,6 +13,8 @@
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 enum rootns_state {
@@ -41,6 +43,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -55,6 +60,16 @@ static inline bool is_rootns_file(struct file *file)
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
index 3bbf7677080e..bde7cf4baebe 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -183,3 +183,41 @@ bool is_rootns_file(struct file *file)
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
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	wake_up_poll(&c->waitq, EPOLLHUP);
+	put_rootns(c);
+}
-- 
2.47.3


