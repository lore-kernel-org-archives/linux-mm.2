Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2714A60A5BD5
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gF2J+16U
Received: by kanga.kvack.org (Postfix)
	id 5658F6B05C5; Sun, 22 Nov 2026 14:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516786B05C6; Sun, 22 Nov 2026 14:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405E26B05C7; Sun, 22 Nov 2026 14:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00E8D6B05C5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E261806FA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:03 +0000 (UTC)
X-FDA: 85463763126.28.E77D78C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E183C40006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gF2J+16U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376222;
	b=RLwp6R5Vx6U9tcKTMHyyRRO5cvLEb8Qc1latH6ScZTN7TamqfzigUFHsZUxMLNfr0NUXNV
	BvG3ki+fKdCKoILQzUyYwC5dAV0iqCxxyS3oXm9Z2nqJUtXVWpiaWSAX0DkaAejft53kNr
	980ONF0HeTMHtcZi3OrYmt+HYH6ikJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwK0kBI5FPDe2Km5ydmIo1Yx+Gsu/7X07W9R+yp2Gk4=;
	b=Jc6HaJ9soO8rvuYh03+x6YE8uEMcNrz8g3wW9eH1xmw/7XQOaS0BRNL8QYFdDbD/Lrg72A
	UMQ+inXW15NuS3Y5rIXcOibGCVQ/5Cu+oToJCfmK3+rcioPoWiqXsmgXhEZOyErRaSYAKn
	7NUWiwoNI6Tvf9baV9jm//hDBWTqrn4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gF2J+16U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 8065961DF2;
	Sun, 22 Nov 2026 19:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6000C1F000EE;
	Sun, 22 Nov 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376221;
	bh=XwK0kBI5FPDe2Km5ydmIo1Yx+Gsu/7X07W9R+yp2Gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gF2J+16USDEJ/HoS3CxmYfyZ3+XohOPn6KBqcnalnjfeoKgwCJ0mdeSq4XUpsqVQv
	 JHJwDi2vYYOZYXQ5K35Vg+mX/dPk8YwKeYtIHxhHJuVr23qNc45t5yuSN/jf8R98j7
	 Uv3upEuEiMrvoHiXxYP0BeSk2uk3iKHBclKHFP6mXU74k7521tf1lt9AogXlnGnRmz
	 +U+krMJNlW4DxTf2DQq/R3PR6NLvMwealjlxKekHwWMIr7Wew4cPJEPxHYUgEZSsAH
	 29wXcNeZl25oN/k1s/8woNjUV4AyajyX/1wY5j7GaaYiEwrZGSxzwE29Oj634xjyak
	 thRb7amQqFHBw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 15/26] exit: Support P_USERLAND in waitid()
Date: Sun, 22 Nov 2026 21:35:28 +0200
Message-ID: <20261122193539.3334213-16-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E183C40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 95sd7fnoyiabgpzdh6xmhio6z6xruaza
X-HE-Tag: 1795376221-449095
X-HE-Meta: U2FsdGVkX1/lkjyFu776dztvP4aPUiyfSv7sG3DH8XX9P+FTbXWnkLPgm4QtwbH9XN2270WhcpOjoOH1jgia2RIXWerfDaAUwAmxPJ0wOFiRC05Kw3Ke0fw7vqi6a1O61H94ZBQywWe+yVf4e9w/+77jJGlcA+p/tYo1bhRA/No6KubOp6JRKKPf1l/fXz6OlmFmrJSzA9HEOL8FDlYx+7kj4HPNP9a+xXIT93QTc+iorHAhBx8bLAuJP/Gk5JdrCazKq3imd5RFYUDM8Ugge0YWISyWtnEt3frVm+MYfCjTObmMduQfZRPzXUOPtjs1BJddnKs2QU89QJYeJoJDD94Nmramt+dRiX0bX1MQYDamlohjbjL7c8PPalfCf4DTGh2qjtnrJtr7qlChikk+1Vu4i3e582IMmkMGtTD53jG43qZzJZ0OP2lRGUXgMCbnllPT0AuFglRJINukScNOl++DdbT2IWcNfxY4IR3j7cS6OxCGggJkfq5Cb2m/0C5Zemqhu6pkxBOvhb+H+oi+xXJGd1scTxfrjDzH3AjhSQArCb26RHFxYQk6aeGLn4GEazZWvIje1k5060wRNQ5BYRb69F7BrYj0gDGYSXuAHd0uez1ODyLaBiHvH+Oo57PLejOOw5q0nqt/BEbMWekWUG3b6+d7rGX87eKS4X6OB8MPh/eDi06+517L4abGiQXcezJQjEHnYPom2Kr/afdC+ud0C1cBgYVp9/2kOx/rh0XikcL0pvUgWCDpDMLO++0K9tFncueCRnersVnpgw376s6IHMtcOme7uNQyCuXmrkXoLe5S+YBYsTeLp+fTS6OfLo1g55dqq30ts/Jyg/bCBlSqK1GseIhQ36pxTjZKvTftQAhJ2nq5ePRbpgkdVq7U+2hMkZaKYJ7/e3/jNECmgA0nLJfxz+Osy8MPcCBZZ/hFEsddk90TRWytBWyRXm9pLyhetOyKAsT/leTExRn
 xlCP63nr
 kKECJ5ZwCqhlcy1yyeVgRP5PPLyk3eORsKVp62SB425m1CHDfXTBB0NtZdgpZadzEApi+zsaG0xCAq5d6jf9OxavbII/ANsg7GGTxMnC1m47v17036ZAil5uZD80jA0Jt+mzJ0A7C1+Wg3eMos8t4TIH2anEZHT2T5ChdKjiK8lLNl5nKNta9B0s472zQJwxYJqbV6jWhMJNHUVs5aq83vnIwIKaFGOo90KS4PhN35+EeAkbQj2FpXleU2n3aQ2BvPqJl6cYsw4LUVQgLoptxb24qEChdtEHCBvu6ksLZ8PkAsP/i5GBsZlMoa0+f4e0YzDGMSvp3Wrcw1+1iw1uaSa95XWLr4U3XetkiqXLv8JK8+1/3fKzbsPtqaSycQUVZypyrNcBs5hYX1AHuMqCb9ooQGXVxmlbNv++GPR4Cf+E+QoVvYMikJJs6w0HhHPlqD0sYa6DysML6oAEaeCX7CCaHjCGhrYtoUceZq2S4+wl+EL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a userland file descriptor cannot
wait on a userland init process forked by another process or observe
exit status multiple times across observers.

Add P_USERLAND to waitid() and wire kernel_waitid() to userland_waitid()
to wait freezably and interruptibly on a userland file descriptor until
the userland reaches USERLAND_DEAD and populate siginfo_t with init's
caller-visible TGID, munged UID, and exit status without consuming it.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h  | 10 +++++
 include/uapi/linux/wait.h |  1 +
 kernel/exit.c             |  4 ++
 kernel/userland.c         | 83 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index a92709957529..16988e10f623 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -16,8 +16,10 @@ struct file;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
+struct rusage;
 struct task_struct;
 struct user_namespace;
+struct waitid_info;
 
 /**
  * enum userland_state - Userland lifecycle states
@@ -73,6 +75,8 @@ bool userland_is_file(struct file *file);
 void userland_copy(struct task_struct *tsk, struct pid *pid,
 		   struct userland *userland);
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -92,6 +96,12 @@ static inline void userland_exit(struct pid_namespace *pid_ns,
 				 struct task_struct *tsk)
 {
 }
+
+static inline long userland_waitid(int upid, struct waitid_info *infop,
+				   int options, struct rusage *ru)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
index 85b809fc9f11..edd39c2cab96 100644
--- a/include/uapi/linux/wait.h
+++ b/include/uapi/linux/wait.h
@@ -18,6 +18,7 @@
 #define P_PID		1
 #define P_PGID		2
 #define P_PIDFD		3
+#define P_USERLAND	4
 
 
 #endif /* _UAPI_LINUX_WAIT_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..5b0bd3a9187c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -71,6 +71,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/uaccess.h>
 #include <linux/pidfs.h>
+#include <linux/userland.h>
 
 #include <uapi/linux/wait.h>
 
@@ -1803,6 +1804,9 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 	struct wait_opts wo;
 	long ret;
 
+	if (which == P_USERLAND)
+		return userland_waitid(upid, infop, options, ru);
+
 	ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru);
 	if (ret)
 		return ret;
diff --git a/kernel/userland.c b/kernel/userland.c
index 279b92e7b7f8..3ded663b71af 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/userland.h>
@@ -40,6 +41,8 @@
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
+#include "exit.h"
+
 void userland_put(struct userland *c)
 {
 	if (!c || !refcount_dec_and_test(&c->usage))
@@ -213,6 +216,86 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	return 0;
 }
 
+/**
+ * DOC: P_USERLAND
+ *
+ * ``waitid(P_USERLAND, userland_fd, infop, options, NULL)`` waits freezably until
+ * ``userland_fd`` reaches ``USERLAND_DEAD`` (unless ``WNOHANG`` or ``O_NONBLOCK`` is
+ * set) and writes init's exit information into ``infop`` without consuming it.
+ * ``options`` must include ``WEXITED`` and may include ``WNOHANG`` and
+ * ``WNOWAIT``; ``rusage`` must be ``NULL``, and the caller must run in an
+ * ancestor active PID namespace.
+ */
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru)
+{
+	struct pid_namespace *pid_ns;
+	unsigned int f_flags;
+	struct userland *userland;
+	bool nonblock;
+	int status;
+	kuid_t uid;
+	long ret;
+
+	if (upid < 0 || ru)
+		return -EINVAL;
+	if (options & ~(WEXITED | WNOHANG | WNOWAIT))
+		return -EINVAL;
+	if (!(options & WEXITED))
+		return -EINVAL;
+
+	CLASS(fd, f)(upid);
+	if (fd_empty(f) || !userland_is_file(fd_file(f)))
+		return -EBADF;
+
+	f_flags = READ_ONCE(fd_file(f)->f_flags);
+	nonblock = (options & WNOHANG) || (f_flags & O_NONBLOCK);
+	userland = fd_file(f)->private_data;
+	pid_ns = task_active_pid_ns(current);
+
+	if (!pidns_is_ancestor(userland->ns->pid_ns_for_children, pid_ns))
+		return -ECHILD;
+	for (;;) {
+		enum userland_state state;
+
+		scoped_guard(spinlock, &userland->lock) {
+			state = userland->state;
+			if (state == USERLAND_INIT)
+				return -ECHILD;
+			if (state == USERLAND_DEAD) {
+				ret = pid_nr_ns(userland->init_pid, pid_ns);
+				if (ret <= 0)
+					return -ECHILD;
+				status = userland->exit_code;
+				uid = userland->init_uid;
+			}
+		}
+		if (state == USERLAND_DEAD)
+			break;
+		if (nonblock)
+			return (options & WNOHANG) ? 0 : -EAGAIN;
+
+		ret = wait_event_freezable(userland->waitq,
+					   READ_ONCE(userland->state) ==
+					   USERLAND_DEAD ||
+					   READ_ONCE(userland->state) ==
+					   USERLAND_INIT);
+		if (ret)
+			return ret;
+	}
+
+	if ((status & 0x7f) == 0) {
+		infop->cause = CLD_EXITED;
+		infop->status = status >> 8;
+	} else {
+		infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		infop->status = status & 0x7f;
+	}
+	infop->pid = ret;
+	infop->uid = from_kuid_munged(current_user_ns(), uid);
+	return ret;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
-- 
2.47.3


