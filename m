Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45305606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OV+NJkwn
Received: by kanga.kvack.org (Postfix)
	id 084746B05D2; Sat, 21 Nov 2026 20:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034766B05D3; Sat, 21 Nov 2026 20:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17F36B05D4; Sat, 21 Nov 2026 20:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B39356B05D2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37C23160611
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:43 +0000 (UTC)
X-FDA: 85460997846.06.CE6C371
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83C78120005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OV+NJkwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310381;
	b=xoYAS7E8WbAueQRACu/992JLF/wEvTDufXmNUewBvJ9siGO4IVC2VKFNidyLacvbd867+8
	TQCfFX7OrgYKD2mmMd+7TyNxb4FPDilX93lIPz8SNBtTdHho4NheyDzFYsoXr74Piag1LC
	dVuxYOOkqESHHVBCFXER6znXeGVdaGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nnd9Mpx4dombIEvV8tXK4eBED7UhcMoyEMT76MD3It8=;
	b=Ms4bHw1VBFqo/ZjtDPRWK7zaI6yXwCXoLax7g3BSXYlY4E/s7T3p0jSpSKoBCbdaR93NIG
	CJUGN/wFGDs/C5NA7CQdZyCcgYTSVJ6KzKH8NzK3sBZX7dmhgfW9kn1b7sk3s3QaL8NKOg
	JotFLtY5AdrpOkHbrN6WIEIF/cGY5Rw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OV+NJkwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D424845A5C;
	Sun, 22 Nov 2026 01:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 162B31F000D0;
	Sun, 22 Nov 2026 01:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310380;
	bh=Nnd9Mpx4dombIEvV8tXK4eBED7UhcMoyEMT76MD3It8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OV+NJkwnqwOths6j5XJDXZNdnnRpJ51uvNVMeQ3qegP0gdgzSZGIdPblQcUU4oewr
	 EqnnQ8MD5uqJe9c2XUNTzZTZ+ynT+sf/ONljL//GkmRFHSEjeHfQ7QUSfQaCODSveG
	 UEPfLjyuPPYO3kvYc2eT3pYl4S6qpmEr6XCH6hi8dVUbemqL3z/qPIh1DsTdyivXMH
	 OWkvP3yLTVxvPXo2zV59fWgDG85xI1NcHD3haQwfz9oyl8jWIjnAyJpx6L5XTFxOar
	 P/V6hp6dxL9S0rEeAR40WDHxqLBJU6TI9eC2bSxNZikO1C++bv4lXLIr25mmYxgoyV
	 XqQvWclwIQAHA==
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
Subject: [RFC PATCH v6 21/26] security: Add userland LSM hooks
Date: Sun, 22 Nov 2026 03:18:04 +0200
Message-ID: <20261122011809.2667684-22-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 83C78120005
X-Stat-Signature: g9kact1nxtzkc53pz1ak46faxipygusq
X-HE-Tag: 1795310381-474548
X-HE-Meta: U2FsdGVkX1+oVrgmoPjjqxxsYWMr7+ae+FwPOdU0kM/xkNxtYO6BZ0mNr/3CDAOp8qLr5DQH1LRyyyEpGbxqlSTT5UT6/+EKjRuJMjmnj9Aqb4Qm54PEt+qwSMx94PhmSjCR6AzSCo+em4bjR1HzUkLlvTKkliF0kFqCGpCW5OEPnDo+lX9g42rT8yaonqw9Hjyno98pRP1f213FNAIIrjnFbPfiwJngvT5WTmnVVkxJheqtU1Vrw0RRGAIx/PH/CEI/NBTWDHlUEFMxZ4SC2AnqdMLALzmOAbcO+D+Ql8UhQOV8W9LEOK4S6o+JPW3uKfVZ9gLaTTu7PECRgMmhVeOEeS9kengNM3TJQLkUWGtzNFI/0yeAza+nD1EJufSRf5Bf+11kDpj/VanG5vmnoH0vUb2GFtCrMCUzL7OdyOmPSqB8D5RhMez4+PaAQ0KFfkLhKi5Qc8k4CZrSzNdJXPd1vcNy/qCxUk9AG3deo1EqNAmd+xnldWYaJfTNEYA1eGZBCU6VLT7/YGYWeW/VA/0cul4FmWn/eB4wAh1cwu2qRr1jj0LH8DwDf8RXmDFMMlKpmdqI/Og1fyqDEzm/swGgg8x/AH6q9tu46etLzeMqKrq/NgwhjPWo4iTSUjnvK4sRk/MdJ8xTh6UTMObV8IG8wgKRvY2QYfMYFu8dsmzvK2fYeQAQ1MaXbPxJgtqChKjn6A/T4lg8lMvIOCDD9wlWmr1FSCvu5vmGeohRbpGvDV4IaV3lKUZz5ASIDQabT20l+dE7okwf8twy9ryFfvh1Rmvs9RjAGFk4IdT7e/0XoeoHxGqvmI0t4Gdh3FF3PNJvjQY+uI6G+54OQSv2PbUJAGpYf3F9YdPh+KfQGgvi+O/t5A4Ri+FB4BIpdgpjsbQ0aRt9v9eozqKRhFv8cJt51v1ON4qo44MS8Ti/P/YjhfUfgB2dJMmHms7enr9jaySdNu011jYP+Opsui5
 HM0soe1K
 ING03Uxp93bmufOU8BPMgaA1aXWuC/+XfGnqMKXYMhpi0Okcqlk2xzwwAsnEH0gQ5yTFatndbMu4nPEHP0lfmw94umn/xGUgLElNgn+TPPS7J4//wvxjgpftJZzxSqvYRr0Rgx/HMx7y2mBMVZQPwra+pyvoYVh8JMz/N4ihF++lL1TlCQ4YnJXGUxOnheBle2DkjgkoCGD9jxAZzQFbXWiLdBrYjh3GJeZ28osfi7CN1v3aUmxbooFisfiZwEWV8nniR/kY1KIY49RHXLNH1TfCLFh2tmkJO7krQHPnh8l69uBwVT8yuW9n6eeJxtyqf7raWpv5in43LTrG5J2LXFv9kIIeMH4NmOPUwkXXv8rMixJF54hAXQcpurqAxpXLDbwnHBetgyNaDNC/Wlx9ADqCA3Cu8A4LT3++BsCr2ixnIFfY=
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
index 3d24789ce7c2..d472f14dd435 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -33,6 +33,9 @@ enum userland_state {
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
index 283b90869d2c..8fc84acc1994 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -33,15 +33,13 @@
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
@@ -53,6 +51,15 @@ void userland_put(struct userland *c)
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
@@ -129,6 +136,7 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	struct ns_common *old_time_children = NULL;
 	struct ns_common *old_ns = NULL;
 	struct ns_common *ns;
+	int ret;
 
 	if (arg > INT_MAX)
 		return -EBADF;
@@ -162,6 +170,10 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = security_userland_share(c, ns);
+	if (ret)
+		return ret;
+
 	scoped_guard(spinlock, &c->lock) {
 		if (c->state != USERLAND_INIT)
 			return -EBUSY;
@@ -306,6 +318,7 @@ int userland_send_signal(struct file *file, int sig,
 	bool any_perm = false;
 	int other_err = 0;
 	struct pid *pid;
+	int ret;
 	int nr;
 
 	if (info || flags || sig < 0 || !valid_signal(sig))
@@ -315,6 +328,10 @@ int userland_send_signal(struct file *file, int sig,
 	if (READ_ONCE(userland->state) != USERLAND_RUNNING)
 		return -ESRCH;
 
+	ret = security_userland_kill(userland, sig);
+	if (ret)
+		return ret;
+
 	scoped_guard(rcu) {
 		read_lock(&tasklist_lock);
 		idr_for_each_entry(&pid_ns->idr, pid, nr) {
@@ -480,20 +497,20 @@ static struct userland *userland_create(unsigned int flags)
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
@@ -504,10 +521,14 @@ static struct userland *userland_create(unsigned int flags)
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
 
@@ -594,6 +615,10 @@ int userland_prepare_fork(struct kernel_clone_args *args)
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


