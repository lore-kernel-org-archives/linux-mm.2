Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA903FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558E66B008A; Mon,  4 May 2026 05:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5310A6B0092; Mon,  4 May 2026 05:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BA16B0093; Mon,  4 May 2026 05:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1DF6B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1F0B4035D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:38 +0000 (UTC)
X-FDA: 84729224916.03.662B2B8
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2065140010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KHJzFSXo;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3JNrBWg4;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHToxwgv5knqBTlwVbm55Ico/NITwpixj9Vnj9WYkao=;
	b=l7BIH/muxul7u0ZVkKeu2xldVQhPpqJNtO76pxZl8jKkgIgvTIarZgbwGPkXy/J6kl1cEx
	MGiFVOl/GcCkzwTskrlYwXTFVPiDsTtFSuZ8yfwKyFz5GQA9MHbnZb/Gku8mG6E8H4FfOc
	Kxo96YlRmCThOly8pHanuSCgASG7uR0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KHJzFSXo;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3JNrBWg4;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887217; a=rsa-sha256;
	cv=none;
	b=lo+8P7NBWptxd1pxfZCFtaJZLIYue7bmmRWivlTK1Aq48zINcPBGg5g0syPhLk9Kl0Fd7a
	hxwhXgYEd03CkTu9KPJCIWdMoa+Fdgkg69jJPz/83aNKkmV2LOjT6C7THsdVCxs7nEteFf
	yFD+eoq3zUs8BOYVte7REgBIjAd8G8g=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHToxwgv5knqBTlwVbm55Ico/NITwpixj9Vnj9WYkao=;
	b=KHJzFSXo8K9RwrWApixGzV0XEkity1pGDhE2I04yIGVqYXik2ObZ5MVMp5vEU/RgvdhH+n
	xnwkV3vZj/pBvofthYGrE+S/gesdCJAoSnOsnFd5Be69xApwwwbuAsCf6uLq/Wk273egAz
	HlWmUpAi6yYmXoHA34SwlvBhaEcBIuXpb2uXhkXSQZ6gWKRIkO3/yV0S27IJtm7/UXBd0f
	0a3QyTtfLtwjqgNEUTWQiZ87vfoScZ4EjfqqwLBpiyMdigOEuYw0Hi7MV6Rf+aPdkjjBvf
	56XrwPG6d9L4TFxe11mMQfvIqz3qMGp0Xpl/BFqWrExswaWyex/9esdzbWpOxg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHToxwgv5knqBTlwVbm55Ico/NITwpixj9Vnj9WYkao=;
	b=3JNrBWg4lE1cji7KDMZA96EMu1CCZeW+mQtJ3mU3dPORXJm9+LwS+RJJ6PD3Dbi4pvCKRp
	iMHUlYSzYh1t/oBg==
Date: Mon, 04 May 2026 11:33:19 +0200
Subject: [PATCH v6 03/11] umh: add dirfd parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-3-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=5541;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=6IQeujXtDmMJBXxwWbg/iZaGW/kWT5oGF6ONKpLUivo=;
 b=Bk32p7HowhqNBjsR8fXr53puXfLwSLesnkOi5si5O6aApY04poo5Gma1mEo9waYkeDsu9TM1O
 LsjNchuYUR8Ax8X2kZKRTRsO6Lg34ZsS7JyN6TSyV/RhqESvpp0PeIw
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2065140010
X-Stat-Signature: 6pm4yugh1jr6dez5s6j1a94ow75pzmui
X-HE-Tag: 1777887216-235231
X-HE-Meta: U2FsdGVkX1/zZMynZ7bKC8YXJRw+yNrRZokkxuuOY9edBDxnp4RCMFpdMo+iGzTw26qa7lrFw2LgAYvZRL3DzNBee1q5Src8QVIdIrfjyKs0dqi/RWZfgh8rGHoP/NuQheJIlOCTL50rY0FKkveqB1siSfvZSTk4MyGo+jEmqgs6hMfQQdcAl1U13UND0KVxmxN+0Qfb2RQOO4+l/MEIIyousouRMsC2nHnOjgYCsti1ZegXLp0NDUBkwhYJSOWAKEIwFsbtkQHphwbEIEOj06hmzMjgy25IVJod6RE0P0zwcoMR+K1eEainLTPks7TASlvvClF1n+JpcUYuUlHj7MTk4P/9jlLHh4Q9RcrzyhQxKCuR1i5WGDSvJ66GTZ1dDOLV+P09x5dlJxrpezbkAYlgOWjHm73Ix/mf5s3A43fDjC+kt+2ho6OphRd/72fiTzjRxoP9TtXLKyl3CnaS1wcUQSpRu6DYC63gxnZLHfrrIpVe7N31qljj8bj88rbU37cup6vcNOZ0SED8fhyw2aKVa1F8Ijd0AKGLUbrSfSacf0y6aRc9YuOXPNCVZIWAlYnyUuSIiRB2jgyjMlMIyAy2UzcD6qFqUWJG+msXMRJaDA78bNq5ur1o2/WWm2gKOYY4hKzQY9QQ7G5uyYb0qhgjvfGGMkfx8M+15myC1O3nZpbEAJm8F5AAmWxdDvj6ZhGK+4q18638XeKwZR7yW/X5YaJ8v4TLdXWZIpWil3yQqtlbHKSZ/TaCDYqsSVadmWU47Z7klaGqtPJxdnvnt8mYQN6Wspo8zT/wgcvQYuBEXTo47JJHFFXRN6Urqs8S1EfA7fiC5HOW8BG8SYMJGVZR3d9hgwCD8NcaARlEEu+VuPWnLWP9eRmAWE5v/aUqhbl11xcXCF7ZOiGhAFUhZ7qQAcwkjrtPc96mUwLXWeAqwJ9jqGGNNjvE7egWEbtqNSTSDxOdWAHCyXr0REl
 I8C5Wi2I
 sXrAAflV/xbDsKYktGEW/3C35EFpJa27UXzlJK6NDOVl5HMHelfJG/2eoHL5LxTrXZjgrNO4goruWvE4gv9oSLZ7aFGz4octiP1pDDJykWJC3GPQW+hVlczUUp0HyH8rh+PJiXPr1qmxomEK6oS6v1TU/Maze+ucuhHMDTuvJl1jUFktRqJSLFkQ6N9ViEKB49veYP6BIfF32pthBwosoKgAOM37W9VujZ4N+LHlx022orW6mydFLli0i3wYThWw1gKPkiPlA7pP+aUfnHnI5QlfYZQ9GnNFf22cbVG044CpjPwkp6WfuPvTe7JZeaCcoJBCV9d3CG+Tryz2ziHgB7qzGVo+aZZZuHrmx7D7ss723664exjTk51JJyHT8I/2SY5TIjecOdDGXIzM32/D8w8FvAr/yWdkX8Ue5JODu/HSCXAzRAEYReeHgkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow callers to specify the directory against which to resolve the
helper's filename. Enables the running of helpers from private mounts.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 fs/coredump.c               | 2 +-
 include/linux/umh.h         | 3 ++-
 kernel/module/kmod.c        | 2 +-
 kernel/umh.c                | 9 ++++++---
 lib/kobject_uevent.c        | 2 +-
 security/keys/request_key.c | 2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index bb6fdb1f458e..45df2387be3d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1015,7 +1015,7 @@ static bool coredump_pipe(struct core_name *cn, struct coredump_params *cprm,
 		helper_argv[argi] = cn->corename + argv[argi];
 	helper_argv[argi] = NULL;
 
-	sub_info = call_usermodehelper_setup(helper_argv[0], helper_argv, NULL,
+	sub_info = call_usermodehelper_setup(AT_FDCWD, helper_argv[0], helper_argv, NULL,
 					     GFP_KERNEL, umh_coredump_setup,
 					     NULL, cprm);
 	if (!sub_info)
diff --git a/include/linux/umh.h b/include/linux/umh.h
index daa6a7048c11..6670b9ff85d4 100644
--- a/include/linux/umh.h
+++ b/include/linux/umh.h
@@ -20,6 +20,7 @@ struct file;
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
+	int dirfd;
 	const char *path;
 	char **argv;
 	char **envp;
@@ -34,7 +35,7 @@ extern int
 call_usermodehelper(const char *path, char **argv, char **envp, int wait);
 
 extern struct subprocess_info *
-call_usermodehelper_setup(const char *path, char **argv, char **envp,
+call_usermodehelper_setup(int dirfd, const char *path, char **argv, char **envp,
 			  gfp_t gfp_mask,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
 			  void (*cleanup)(struct subprocess_info *), void *data);
diff --git a/kernel/module/kmod.c b/kernel/module/kmod.c
index a25dccdf7aa7..a85c57a707af 100644
--- a/kernel/module/kmod.c
+++ b/kernel/module/kmod.c
@@ -95,7 +95,7 @@ static int call_modprobe(char *orig_module_name, int wait)
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
+	info = call_usermodehelper_setup(AT_FDCWD, modprobe_path, argv, envp, GFP_KERNEL,
 					 NULL, free_modprobe_argv, NULL);
 	if (!info)
 		goto free_module_name;
diff --git a/kernel/umh.c b/kernel/umh.c
index bab134fa8c36..5cdcba6005d9 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -106,7 +106,7 @@ static int call_usermodehelper_exec_async(void *data)
 	commit_creds(new);
 
 	wait_for_initramfs();
-	retval = kernel_execve(AT_FDCWD, sub_info->path,
+	retval = kernel_execve(sub_info->dirfd, sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);
 out:
@@ -331,6 +331,7 @@ static void helper_unlock(void)
 
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
+ * @dirfd: directory to resolve path against
  * @path: path to usermode executable
  * @argv: arg vector for process
  * @envp: environment for process
@@ -352,7 +353,7 @@ static void helper_unlock(void)
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
-struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
+struct subprocess_info *call_usermodehelper_setup(int dirfd, const char *path, char **argv,
 		char **envp, gfp_t gfp_mask,
 		int (*init)(struct subprocess_info *info, struct cred *new),
 		void (*cleanup)(struct subprocess_info *info),
@@ -366,8 +367,10 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
 	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
 
 #ifdef CONFIG_STATIC_USERMODEHELPER
+	sub_info->dirfd = AT_FDCWD;
 	sub_info->path = CONFIG_STATIC_USERMODEHELPER_PATH;
 #else
+	sub_info->dirfd = dirfd;
 	sub_info->path = path;
 #endif
 	sub_info->argv = argv;
@@ -484,7 +487,7 @@ int call_usermodehelper(const char *path, char **argv, char **envp, int wait)
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+	info = call_usermodehelper_setup(AT_FDCWD, path, argv, envp, gfp_mask,
 					 NULL, NULL, NULL);
 	if (info == NULL)
 		return -ENOMEM;
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index ddbc4d7482d2..426ac83f1d2a 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -628,7 +628,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			goto exit;
 
 		retval = -ENOMEM;
-		info = call_usermodehelper_setup(env->argv[0], env->argv,
+		info = call_usermodehelper_setup(AT_FDCWD, env->argv[0], env->argv,
 						 env->envp, GFP_KERNEL,
 						 NULL, cleanup_uevent_env, env);
 		if (info) {
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index a7673ad86d18..f6f3d4bc0bda 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -101,7 +101,7 @@ static int call_usermodehelper_keys(const char *path, char **argv, char **envp,
 {
 	struct subprocess_info *info;
 
-	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
+	info = call_usermodehelper_setup(AT_FDCWD, path, argv, envp, GFP_KERNEL,
 					  umh_keys_init, umh_keys_cleanup,
 					  session_keyring);
 	if (!info)

-- 
2.53.0


