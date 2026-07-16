Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227F0C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2A66B00EF; Thu, 16 Jul 2026 10:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9256B00F0; Thu, 16 Jul 2026 10:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172036B00F1; Thu, 16 Jul 2026 10:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0D676B00EF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB9431401CE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:35:32 +0000 (UTC)
X-FDA: 84994888104.01.AE2F7ED
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 58F2A1C0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:35:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=W40agwh9;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wURXbIM83i/KM001FnsACgDfZj9qHrMeiWNQVSUpwNw=;
	b=q2+ACdZJjJq01gQkwzQoPB1L4WyP6yq7OElwkIYuM/MYlSNMvG7M0UixNzZNYRznSZ1hkn
	sY5UpgacN3l9evLs76S4TpFrGHsLX+/7YCwrkPP+3f/YeoClAld6WXbOFSUu5NoDI7gfOA
	yHE6Q4aHZaUTMrtg2ZltQRbAUluHpaQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=W40agwh9;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212531;
	b=oBZmZu1wokjD1Hyrfc05Z+ervMkD8PRAq0oEDgbwNioC3krOSOiH6uK3eKMTubcj0Tzoc1
	ZtMG9lnSmlaiZVgNRoVA0K0C9jeGlkd1er+JMf5je9eaKeNyQTBwuy5AvPxKtv/D7Dighk
	0UK0S9eYbGH4NrXglhORrCvljeLOiU4=
ARC-Seal: i=1; a=rsa-sha256; t=1784212384; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=b8F40UHI88oJ+h9SlDGv+TZAWYuh6HMgmPCy1ECs93EhJKSXPWvfWOEEIobgOd0supW/bczuM8sKj6QogvgVsgYdRpStanIRL2QUwr9C5LEwddgUMwCoqO5rCNEA4Y5H1go/k+rFczOZdPjAQNEDUzmejAssaRiQkEsH3piIPr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212384; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wURXbIM83i/KM001FnsACgDfZj9qHrMeiWNQVSUpwNw=; 
	b=XVZFji20ghNVUck8HXJ5I5EbAuTskTJY/sSDv6tX7i8jnMcCl1j7B8+pFQG3QURVMh35Waa+vx15S5Zd1UfbvksZ5NxSjLq+HtYpa8wqh8JFKdQojFTgBObxvLr0g6NCrkoKiq/mQv0vRlxOE8wLeIrBkCnYzItVIFT3lZyX0Vs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212384;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=wURXbIM83i/KM001FnsACgDfZj9qHrMeiWNQVSUpwNw=;
	b=W40agwh93u/3odCcnpcCuhZwftUiJ+CDv+Ow+DUOGJNzad7HZg1t85R5EJQ+2Z3q
	SvgJCMkXrJOZzDr9cJutf5fDp0eAz9wdZwNrxiqgg6jjGmwsZJusi782ZFseDFp9XTI
	D0QuvG/DRdqT+3axpJvPnEoURoUP4MD4txFPOP70=
Received: by mx.zohomail.com with SMTPS id 1784212381524503.8460858206049;
	Thu, 16 Jul 2026 07:33:01 -0700 (PDT)
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
Subject: [RFC PATCH 05/24] pidfd: add spawn builder path configuration
Date: Thu, 16 Jul 2026 22:31:31 +0800
Message-ID: <650cf9dd6ed58ee90617f72f7743262787c822c7.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58F2A1C0003
X-Stat-Signature: g5b8eq3hyqe87ypr8qmqkwrq97j3xgpu
X-HE-Tag: 1784212529-435744
X-HE-Meta: U2FsdGVkX18Jn74AR9ZuMpX/1e0XfYaS9QNdKryCmslLEl8ot3xPcfm/vp21zR5hdsoy6WtduILD52B2qfmQT36aO34EB2OSANzsvtkGiPrqWawP79MwI4eTg5EcDfTrDGxgoXQKRr67/wTeHPyx0SnOK1lGMlI7WbHnYVfaR6wEfqop1nXUOx3RRDNGXIv9kibIazQCBYw/stfFZ0mzN45lDMLNnoXaHVaNp/nygEd8dSlumsdvWWl3a4mlDlC5Du2Q0G0gWpGSnT9a8ulRLCFR3DUgEci5WqGDYOmgvgQS1FVwUb97j8Ad4Kzbfp8F/kTichJz+ZeWMavNW3n/WdyanBymzffWmNXdqPpH8d77Xrvkh+myJTFjoFsctxcjlQVUOjIrs+sVEOrqyL6Iv/lCqHoRXS9aVbzaCCLxpEgjaZ8VHEE+kYCICJk1+OcRXK9nJauXrSnKtm1hB6O6MilkhauJ2hK3z8cUC4oYn4VQGpnGCfFwP8zY3nVVwroTUgOF9yjLmlHcVmybimsIf79BhSQnyswg+c0D46ymhvgqf6ovnnikS6zDdk9EsBGhQTGLdMQx93RismM8l++Mo7tdsYdspRXaIGknmYN49whOvs4EpVQQfm4MpeZvPNwBKkcPklNWrnrNnCFt6/W0QtqgYGZ+wSrXFvaaVU5+r4Kx9TIHskmVgOaWMNOxpvrQ8J4iZi4qZ9eMaTdegZ15xTTROpQT1kknXrS1O3qAgNtn9q0sKly9TrKQlp2Ze1wyN4EQ7hU8MmnnGoNd/jd7/dPnq9danGPX8ZdfsxoA+peWGcdUjVOK2KIkFnqmj139mBbJNpFUSwMSjoUU8X4pZgOh26en0nvzgDFDTx2X3qhUs7raDPMKK1Rln2TYHcSj9OgQYBrMTXxjK3XDxc+G7HHWPLhFYsvoRceLGcz3cXuuyK0y465BuDLMM9h3AhaOxmqhVZl3Yz/kpMDWw/l
 1Sb8tayP
 a39yxEfLC9e2NNRC3KSUSy4TsmZEsizdxnVJnbSJ2JlQ+Egcp0GW8fljZtA/CiJP187qzj+bZhVyRJ8Ss8IAvyUf5Nyu6eik8Np9zBGn3VFy+bLy0KDS4hopYrOrfJoruBhc6CriMwEB5vpAnCES4MTiUB4welayJXGcofCy/kPChOfaOLbf2f6S/5Xfds9pOG31752QihDa71O46lhXyOx/Uz3y7iCmQVpQYVXHi2AOAQDg7XWSJ6XT3XBFNB3PW+rRAO6o5U2HrHGYAmPIo8zRyRRSGqcCJDAhaTS+ivHGqy4QuTOBBfSk41byIx3Kd97LT//x7DetSjvxy14Q6zYjcZz1e0C8hemVQR55Al4Vh2zjwJLvew+JMGZkPLemuHNGz/nlen2yaA6MAnq19mZJKhfHhy8UOThxxGJGLuVrfmOx9OqWEO4Roc9p/J2wbJciL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an fsconfig-style pidfd_config() implementation and the initial path
string key. The builder inode retains configuration, which userspace may
replace before the child is created.

Bind configuration authority to the creator mm, credential object, and
child PID namespace. Passing the fd alone therefore does not delegate
launch authority to a different process context.

Accept absolute and relative executable paths. A later run operation
resolves relative paths from the child working directory without PATH
search. Keep the syscall unreachable until the complete spawn state machine
is wired later in the series.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index ff2b0cb6365a5..46207c8e8139f 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -3,24 +3,47 @@
  * pidfd-backed process spawn builders
  */
 
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
 #include <linux/pid.h>
+#include <linux/pid_namespace.h>
 #include <linux/pidfd_spawn.h>
 #include <linux/pidfs.h>
 #include <linux/refcount.h>
+#include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
 #include <uapi/linux/pidfd.h>
 
+#define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
+
 struct pidfd_spawn_state {
+	/* Serializes configuration and payload teardown. */
+	struct mutex lock;
 	refcount_t count;
 	struct pid *pid;
+	struct mm_struct *creator_mm;
+	const struct cred *creator_cred;
+	struct pid_namespace *creator_pid_ns;
+	char *staged_path;
 };
 
 static void pidfd_spawn_state_put(struct pidfd_spawn_state *state);
 
 static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 {
+	kfree(state->staged_path);
+	if (state->creator_mm)
+		mmdrop(state->creator_mm);
+	if (state->creator_cred)
+		put_cred(state->creator_cred);
+	if (state->creator_pid_ns)
+		put_pid_ns(state->creator_pid_ns);
 	put_pid(state->pid);
 	kfree(state);
 }
@@ -31,6 +54,15 @@ static void pidfd_spawn_state_put(struct pidfd_spawn_state *state)
 		pidfd_spawn_free_state(state);
 }
 
+static void pidfd_spawn_state_put_cleanup(struct pidfd_spawn_state *state)
+{
+	if (!IS_ERR_OR_NULL(state))
+		pidfd_spawn_state_put(state);
+}
+
+DEFINE_FREE(pidfd_spawn_state, struct pidfd_spawn_state *,
+	    pidfd_spawn_state_put_cleanup(_T))
+
 static void pidfd_spawn_state_release(void *data)
 {
 	pidfd_spawn_state_put(data);
@@ -50,17 +82,140 @@ static const struct pidfs_future_file_ops pidfd_spawn_future_ops = {
 	.release = pidfd_spawn_state_release,
 };
 
+static struct pidfd_spawn_state *
+pidfd_spawn_state_get_file(struct file *file)
+{
+	struct pidfd_spawn_state *state;
+
+	state = pidfs_future_file_data(file, &pidfd_spawn_future_ops);
+	if (!state || !refcount_inc_not_zero(&state->count))
+		return ERR_PTR(state ? -ESRCH : -EINVAL);
+	return state;
+}
+
+static bool pidfd_spawn_same_creator(struct pidfd_spawn_state *state)
+{
+	return current->mm == state->creator_mm &&
+	       current_cred() == state->creator_cred &&
+	       current->nsproxy->pid_ns_for_children == state->creator_pid_ns;
+}
+
+static struct filename *pidfd_spawn_get_path(const char __user *value)
+{
+	CLASS(filename, name)(value);
+
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+
+	return no_free_ptr(name);
+}
+
+static char *pidfd_spawn_copy_path(const char __user *value)
+{
+	struct filename *name __free(putname) = NULL;
+	char *path;
+
+	name = pidfd_spawn_get_path(value);
+	if (IS_ERR(name))
+		return ERR_CAST(name);
+	path = kstrdup(name->name, GFP_KERNEL_ACCOUNT);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
+
+	return path;
+}
+
+static int pidfd_spawn_state_set_path(struct pidfd_spawn_state *state,
+				      const char __user *value)
+{
+	char *path __free(kfree) = NULL;
+	char *old __free(kfree) = NULL;
+
+	path = pidfd_spawn_copy_path(value);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		if (!pidfd_spawn_same_creator(state))
+			return -EPERM;
+
+		old = state->staged_path;
+		state->staged_path = no_free_ptr(path);
+	}
+	return 0;
+}
+
+static int pidfd_spawn_state_set_string(struct pidfd_spawn_state *state,
+					const char *key,
+					const void __user *value)
+{
+	if (!strcmp(key, PIDFD_CONFIG_KEY_PATH))
+		return pidfd_spawn_state_set_path(state, value);
+
+	return -EOPNOTSUPP;
+}
+
+SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
+		const char __user *, ukey, const void __user *, uvalue,
+		int, aux)
+{
+	char *key __free(kfree) = NULL;
+	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
+	int ret;
+
+	switch (cmd) {
+	case PIDFD_CONFIG_SET_STRING:
+		if (!ukey || !uvalue || aux)
+			return -EINVAL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	state = pidfd_spawn_state_get_file(fd_file(f));
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	key = strndup_user(ukey, PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	switch (cmd) {
+	case PIDFD_CONFIG_SET_STRING:
+		ret = pidfd_spawn_state_set_string(state, key, uvalue);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
 int pidfd_empty_open(unsigned int flags)
 {
 	struct pidfd_spawn_state *state;
 	struct file *pidfile;
 	int pidfd;
 
+	if (!current->mm)
+		return -EINVAL;
+
 	state = kzalloc_obj(*state, GFP_KERNEL_ACCOUNT);
 	if (!state)
 		return -ENOMEM;
 
+	mutex_init(&state->lock);
 	refcount_set(&state->count, 1);
+	mmgrab(current->mm);
+	state->creator_mm = current->mm;
+	state->creator_cred = get_current_cred();
+	state->creator_pid_ns =
+		get_pid_ns(current->nsproxy->pid_ns_for_children);
 
 	pidfile = pidfs_alloc_future_file("[pidfd_spawn]", state,
 					  &pidfd_spawn_future_ops,
-- 
2.52.0


