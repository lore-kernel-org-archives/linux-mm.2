Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83048606AD8D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xq3b6n8w
Received: by kanga.kvack.org (Postfix)
	id 789F06B05D2; Sun, 22 Nov 2026 14:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715126B05D3; Sun, 22 Nov 2026 14:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DABF6B05D4; Sun, 22 Nov 2026 14:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 385416B05D2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C757016070E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:28 +0000 (UTC)
X-FDA: 85463764176.04.AFFEBA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 266BE40007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xq3b6n8w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376247;
	b=FmR+ftbG3O/kGLdGsDmFzKupy07iFsUQVm4IKRW203B0O/b0gEWS7dQbAB+5AccpSEe28x
	o4gmA2yKnR/ydkqDlE2ko8mbq/G4Dq0UIGps2ck05eA2qwn9G8sVPcs7ju+O/cf0ShJhu2
	6MtO3WmzOAqBS7TsF4GSTyd9QbhmEZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Po0UTofwVcN49w2TPBs2Sh5Xkkd18b3WmLdf69QyzI=;
	b=Hx6zy21nWlotdKbhtVHak6425IxfiLpJmvk4NNAkk1UNdbFkllB40Pf6uUZRrtPtxFEOnP
	hq+6wyJnnnhl0eChK9dhKErRao9WHt5ioM45TLOGWfDrydBFJ3d0eUs76wRS8DU+ekWc/A
	XU5nTwLV0jNQS4HJzu7tVA6+oq1sBWk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xq3b6n8w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 8ED70436CE;
	Sun, 22 Nov 2026 19:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A21051F000EB;
	Sun, 22 Nov 2026 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376246;
	bh=0Po0UTofwVcN49w2TPBs2Sh5Xkkd18b3WmLdf69QyzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xq3b6n8wczeX6bcEtdN8cCH7JhZ4EhymQVumjmGdh4f2hgTvNu4fOMm72bXXy3uj9
	 x9hE7lkWcwKsMamJC5/qm9QmNnW5m26AOYjo+582xRDqvIG8usSeMoAcaZdPHUHkW5
	 gE1gnioj/EdzfWXcDb+RIOxrDe3QFzjnzIa15tD4hK4WOTVxlglCcLJsSUrOjbo4Fw
	 HSFZg6g3q0z5c7MAhlLjvO/Ezhuz1ZCo5I/30A0z97/OiK2bYbziT+mpWyb05PyBZR
	 T33JJzXlIo8muXhyC4gjJuT0YvasYqIYnby2cjWNMaH6ZHKlODA/qEiXxy+6jw6B08
	 3rNnOKjquS4Dw==
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
Subject: [RFC PATCH v7 21/26] security: Add userland LSM hooks
Date: Sun, 22 Nov 2026 21:35:34 +0200
Message-ID: <20261122193539.3334213-22-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 266BE40007
X-Stat-Signature: mda3onwf4gauxm5xnbx5mgtwgeqrdpu5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795376247-10040
X-HE-Meta: U2FsdGVkX196YrwWK6cxUWVkTkZDx51b+59cvX/8a9a0jmsQHmTAni0RfuOoTo7L+7vwCxyJiqzt+q9cQfYwlHZq8gdt8IMxokF9GDBFBeP+N92MyFhCgThB6PQDJcy+QT7M0hjZN5WYT1tTWlTbNQGWOhdOfSQ0NgMCRE+xgcTMjMmV9tefL16xjTl8hsp7uKso397TuoM7lCUrGOWM3piMJPOHl2VxAesg+2dLcVhAiYnaoWXaMlIA7aa7zsRHQUja4jiZTl0tFlG+R+0EnX/QQv31inhincw2gzVqM2Qk5GCFlZbGNZ/2qfXCiZtA8NkJ4iXCrrP+3lnu97S9QhkvZSskbHPjqkRlBzTHT3EFxx7pb92UGoG2SmXSaqoCvPrFWZwY+sW9XQTTm22r5lt77/b5uNtRs2ztkuTJ4a1/QiVJ9krYnVbmRwU4oYC6S76jIvTx44Th69V3jRjApe/I/lb48aJHbK6ChwEKiU6dyPI9Zc7y7rR5iR/OITUkw6oEifAn0NjgHWChRRagN71xeBUJWVB+ldFkoIn5I1poVYfH/o2wTBIQGXmtVCYiDsBdbFh0WuFBSmtJh4GUI9ENOh6zgPfdQrWTy2eT2rTELFYcSYt2NMO8CXPEp/Cu1j72T8oh7kX5ZihsJv868Dq0aIsAqG9hTSnGQXP2jr0jnFl3bAJxlt5iRuN4wctlLNfLnrbPo6yYxKX1BswhyFHGrH7+08Jtex4HE9WSL2l4IaDqJkMMJedGUGEwQifGATyn9Tv3skkrkNOUpegwFhbGls0G2JUaZSFsl9jyvmeXIzEx9GN0RbWTU8rhSEQBkW4eHavwe2sO+tJi4wja9kAp/+nJBwHSbPkOo/d712rU3hGBtA1YaGaj1BtLHXhKjrffbLkSsPDb+tqALsgn3rDBOtVgQXKAOvg4eN04kVMLiA51nmeTw0FAhXfafixG9uNtE+Gel24rU8SubBO
 BxkiKR4G
 LQPqL9zDI1gFY+tW/vgJjwH+LnVQpsC2pNQxwa+yPEU+RrdIY2YOWStwQiXlsiR5O8gcLufL+ob5eG6u6JKK1gfyw/vWkOjlILAoIYHogdneHHj0I0iECBtXx4SXgPUGyrYqd7kcaEJCEZAA1fR6sfEzNWWsfK34l8+b1TWEqh710ghGLGPMah/DwKoy/Fg1bLHingDUV8twGau/53EPOzNobxqFrhaWODJSzE0YDGyZzytaA4nfqQdat9tKZfvx1JBtwuJ+6vXRoBBMt8LnWZtDHKfu2EmzZiIRLFsGw9wdGG0h0Qs+uspvMu4x6k4EmOwP3a424AFX/kR8N7LOtkZX//Fkjqg73MDsS43F4NSfjkVfJQVM76Irh7MEZQFoz5nxMUXXfRJMmqSpFElWhU/T7zLd/NknN+XAQuXAT7l2Ho3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Security modules need visibility into userland creation, teardown,
namespace sharing, process entry, and userland-wide signal delivery so
policies can attach per-userland security state and mediate operations
on userland file descriptors.

Add lbs_userland and userland->security blob management alongside
security_userland_alloc(), security_userland_free(),
security_userland_share(), security_userland_clone(), and
security_userland_kill().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/lsm_hook_defs.h |  8 ++++
 include/linux/lsm_hooks.h     |  3 ++
 include/linux/security.h      | 37 ++++++++++++++++++
 include/linux/userland.h      |  3 ++
 kernel/userland.c             | 43 ++++++++++++++++-----
 security/lsm_init.c           |  6 +++
 security/security.c           | 72 +++++++++++++++++++++++++++++++++++
 7 files changed, 163 insertions(+), 9 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..be858bfdc534 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -480,3 +480,11 @@ LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
 LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
 LSM_HOOK(int, 0, bdev_setintegrity, struct block_device *bdev,
 	 enum lsm_integrity_type type, const void *value, size_t size)
+
+#ifdef CONFIG_USERLAND
+LSM_HOOK(int, 0, userland_alloc, struct userland *userland, unsigned int flags)
+LSM_HOOK(void, LSM_RET_VOID, userland_free, struct userland *userland)
+LSM_HOOK(int, 0, userland_share, struct userland *userland, struct ns_common *ns)
+LSM_HOOK(int, 0, userland_clone, struct userland *userland)
+LSM_HOOK(int, 0, userland_kill, struct userland *userland, int sig)
+#endif /* CONFIG_USERLAND */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 13621e9e233e..7c18370ac427 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -121,6 +121,9 @@ struct lsm_blob_sizes {
 	unsigned int lbs_bpf_map;
 	unsigned int lbs_bpf_prog;
 	unsigned int lbs_bpf_token;
+#ifdef CONFIG_USERLAND
+	unsigned int lbs_userland;
+#endif
 };
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..2638ee1aa397 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -84,6 +84,7 @@ struct audit_krule;
 struct ns_common;
 struct user_namespace;
 struct timezone;
+struct userland;
 
 enum lsm_event {
 	LSM_POLICY_CHANGE,
@@ -2469,4 +2470,40 @@ static inline void security_initramfs_populated(void)
 }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_USERLAND
+#ifdef CONFIG_SECURITY
+int security_userland_alloc(struct userland *userland, unsigned int flags);
+void security_userland_free(struct userland *userland);
+int security_userland_share(struct userland *userland, struct ns_common *ns);
+int security_userland_clone(struct userland *userland);
+int security_userland_kill(struct userland *userland, int sig);
+#else
+static inline int security_userland_alloc(struct userland *userland,
+					  unsigned int flags)
+{
+	return 0;
+}
+
+static inline void security_userland_free(struct userland *userland)
+{
+}
+
+static inline int security_userland_share(struct userland *userland,
+					  struct ns_common *ns)
+{
+	return 0;
+}
+
+static inline int security_userland_clone(struct userland *userland)
+{
+	return 0;
+}
+
+static inline int security_userland_kill(struct userland *userland, int sig)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_USERLAND */
+
 #endif /* ! __LINUX_SECURITY_H */
diff --git a/include/linux/userland.h b/include/linux/userland.h
index a9b99642c46e..eecee199fad7 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -61,6 +61,9 @@ enum userland_state {
 struct userland {
 	refcount_t		usage;
 	int			exit_code;
+#ifdef CONFIG_SECURITY
+	void			*security;
+#endif
 	struct user_namespace	*user_ns;
 	struct nsproxy		*ns;
 	struct pid		*init_pid;
diff --git a/kernel/userland.c b/kernel/userland.c
index 2375442733b6..0a6c6179f629 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -40,15 +40,13 @@
 #include <linux/uts_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/idr.h>
+#include <linux/security.h>
 #include <uapi/linux/userland.h>
 
 #include "exit.h"
 
-void userland_put(struct userland *c)
+static void userland_free(struct userland *c)
 {
-	if (!c || !refcount_dec_and_test(&c->usage))
-		return;
-
 	if (c->ns)
 		put_nsproxy(c->ns);
 	if (c->init_pid)
@@ -60,6 +58,15 @@ void userland_put(struct userland *c)
 	kfree(c);
 }
 
+void userland_put(struct userland *c)
+{
+	if (!c || !refcount_dec_and_test(&c->usage))
+		return;
+
+	security_userland_free(c);
+	userland_free(c);
+}
+
 static __poll_t userland_poll(struct file *file, poll_table *wait)
 {
 	struct userland *userland = file->private_data;
@@ -136,6 +143,7 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	struct ns_common *old_time_children = NULL;
 	struct ns_common *old_ns = NULL;
 	struct ns_common *ns;
+	int ret;
 
 	if (arg > INT_MAX)
 		return -EBADF;
@@ -167,6 +175,10 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = security_userland_share(c, ns);
+	if (ret)
+		return ret;
+
 	scoped_guard(spinlock, &c->lock) {
 		if (c->state != USERLAND_INIT)
 			return -EBUSY;
@@ -315,6 +327,7 @@ int userland_send_signal(struct file *file, int sig,
 	bool any_perm = false;
 	int other_err = 0;
 	struct pid *pid;
+	int ret;
 	int nr;
 
 	if (info || flags || sig < 0 || !valid_signal(sig))
@@ -324,6 +337,10 @@ int userland_send_signal(struct file *file, int sig,
 	if (READ_ONCE(userland->state) != USERLAND_RUNNING)
 		return -ESRCH;
 
+	ret = security_userland_kill(userland, sig);
+	if (ret)
+		return ret;
+
 	scoped_guard(rcu) {
 		read_lock(&tasklist_lock);
 		idr_for_each_entry(&pid_ns->idr, pid, nr) {
@@ -489,20 +506,20 @@ static struct userland *userland_create(unsigned int flags)
 	user_ns = userland_create_user_ns();
 	if (IS_ERR(user_ns)) {
 		ret = PTR_ERR(user_ns);
-		goto err_put;
+		goto err_free;
 	}
 	c->user_ns = user_ns;
 	ns_ref_active_get(user_ns);
 
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
 		ret = -EPERM;
-		goto err_put;
+		goto err_free;
 	}
 
 	ns = create_new_namespaces(clone_flags, current, user_ns, NULL);
 	if (IS_ERR(ns)) {
 		ret = PTR_ERR(ns);
-		goto err_put;
+		goto err_free;
 	}
 
 	if (ns->time_ns != ns->time_ns_for_children) {
@@ -513,10 +530,14 @@ static struct userland *userland_create(unsigned int flags)
 	c->ns = ns;
 	nsproxy_ns_active_get(ns);
 
+	ret = security_userland_alloc(c, flags);
+	if (ret < 0)
+		goto err_free;
+
 	return c;
 
-err_put:
-	userland_put(c);
+err_free:
+	userland_free(c);
 	return ERR_PTR(ret);
 }
 
@@ -610,6 +631,10 @@ int userland_prepare_fork(struct kernel_clone_args *args)
 	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
 		return -EXDEV;
 
+	ret = security_userland_clone(userland);
+	if (ret)
+		return ret;
+
 	ret = mnt_ns_get_root(userland->ns->mnt_ns, &root);
 	if (ret)
 		return ret;
diff --git a/security/lsm_init.c b/security/lsm_init.c
index 8d5ecea99c46..b1af1d922c58 100644
--- a/security/lsm_init.c
+++ b/security/lsm_init.c
@@ -316,6 +316,9 @@ static void __init lsm_prepare(struct lsm_info *lsm)
 	lsm_blob_size_update(&blobs->lbs_bpf_map, &blob_sizes.lbs_bpf_map);
 	lsm_blob_size_update(&blobs->lbs_bpf_prog, &blob_sizes.lbs_bpf_prog);
 	lsm_blob_size_update(&blobs->lbs_bpf_token, &blob_sizes.lbs_bpf_token);
+#ifdef CONFIG_USERLAND
+	lsm_blob_size_update(&blobs->lbs_userland, &blob_sizes.lbs_userland);
+#endif
 }
 
 /**
@@ -460,6 +463,9 @@ int __init security_init(void)
 		lsm_pr("blob(bpf_map) size %d\n", blob_sizes.lbs_bpf_map);
 		lsm_pr("blob(bpf_prog) size %d\n", blob_sizes.lbs_bpf_prog);
 		lsm_pr("blob(bpf_token) size %d\n", blob_sizes.lbs_bpf_token);
+#ifdef CONFIG_USERLAND
+		lsm_pr("blob(userland) size %d\n", blob_sizes.lbs_userland);
+#endif
 	}
 
 	if (blob_sizes.lbs_file)
diff --git a/security/security.c b/security/security.c
index 4727b8347fc4..8c3a5df21938 100644
--- a/security/security.c
+++ b/security/security.c
@@ -30,6 +30,7 @@
 #include <linux/overflow.h>
 #include <linux/perf_event.h>
 #include <linux/fs.h>
+#include <linux/userland.h>
 #include <net/flow.h>
 #include <net/sock.h>
 
@@ -5795,3 +5796,74 @@ void security_initramfs_populated(void)
 {
 	call_void_hook(initramfs_populated);
 }
+
+#ifdef CONFIG_USERLAND
+/**
+ * security_userland_alloc() - Allocate LSM blob and check userland creation
+ * @userland: the new userland
+ * @flags: creation flags passed to userland_open()
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int security_userland_alloc(struct userland *userland, unsigned int flags)
+{
+	int rc;
+
+	rc = lsm_blob_alloc(&userland->security, blob_sizes.lbs_userland,
+			    GFP_KERNEL);
+	if (unlikely(rc))
+		return rc;
+
+	rc = call_int_hook(userland_alloc, userland, flags);
+	if (unlikely(rc))
+		security_userland_free(userland);
+
+	return rc;
+}
+
+/**
+ * security_userland_free() - Release LSM blob from @userland
+ * @userland: the userland being freed
+ */
+void security_userland_free(struct userland *userland)
+{
+	call_void_hook(userland_free, userland);
+	kfree(userland->security);
+	userland->security = NULL;
+}
+
+/**
+ * security_userland_share() - Check permission to share @ns into @userland
+ * @userland: the target userland
+ * @ns: the namespace being shared
+ *
+ * Return: 0 if permission is granted, negative error code on failure.
+ */
+int security_userland_share(struct userland *userland, struct ns_common *ns)
+{
+	return call_int_hook(userland_share, userland, ns);
+}
+
+/**
+ * security_userland_clone() - Check permission to spawn into @userland
+ * @userland: the target userland
+ *
+ * Return: 0 if permission is granted, negative error code on failure.
+ */
+int security_userland_clone(struct userland *userland)
+{
+	return call_int_hook(userland_clone, userland);
+}
+
+/**
+ * security_userland_kill() - Check permission to signal @userland
+ * @userland: the target userland
+ * @sig: signal number (or 0 for permission probe)
+ *
+ * Return: 0 if permission is granted, negative error code on failure.
+ */
+int security_userland_kill(struct userland *userland, int sig)
+{
+	return call_int_hook(userland_kill, userland, sig);
+}
+#endif /* CONFIG_USERLAND */
-- 
2.47.3


