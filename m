Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A32FCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D116B0098; Sat, 10 Oct 2026 06:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5546B009B; Sat, 10 Oct 2026 06:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC366B0098; Sat, 10 Oct 2026 06:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6070B6B0098
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:21:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE68F1C4216
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:25 +0000 (UTC)
X-FDA: 85306324530.19.3F6F149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED02D180008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDXUulI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791627684;
	b=zlJvGvgVxEnsETHeGniGSWzFG2PjoKx5JFMStVnmTn+tPEWd/bfojr9usw/yUeEnVcDROQ
	JbfDO+9qNdTC2tdJpILbe3nnjv2hrOCZeJklvCvaD8M/PMJC8qScNuAyJSsfjxaJKL4PKM
	marBgt8wOO/YIPKFqW4sU3dPtVaNHlw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDXUulI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uROs6GaDMxs86OEBThnihPrIZ8Du9+XXjsGvkVMbOQ=;
	b=SHzSG6LwSWh2nejHx2Ok8y1Iz5ER3OLAvzpRBr20pegRKSoTvwMtoo0UzQNclaxiLdLNSF
	2z1oxqV3sooCroCOamLL9OOrX2eAF5EpjWEJ8HliLWZi66CGU63wygUqpVka18DOt/oExG
	Kq8StQPdax+xzH4IWI523m5QuIFxS00=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCD014484C;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8313DC4AF0D;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791627681;
	bh=BiDhF0lWhO+RibDA9WeMERuRdkka0ag7+4GwzhkWFAU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TDXUulI1yj97mFsigwyY8lPT7DgDBxv8zQUTW/1lJ1QmZ1wTiSEV+5CeXrTNr5w77
	 5ASMnbKot0jieLm4m3lWhPa4kwzA5DGL0WcX7Mw3p3gdyGKFfqHDKiGt6Xp33rt2wE
	 St4QbvvaM5pvNYlT6MeoPNX5kEKpecYJiV6fvfRaewnZS60BN2rnXb6Wq2Y7TVUdxD
	 F3cwvyOYuBQoKDYsxi1AWYUD39dI+qGRYxUMyyowLaIauwybaezw/EZGzhLxADXpKu
	 LiqwVvzNTicPwltG0vlb/VnQlmuUTLY5r7k0zoiCedAAzM5gfzulFESfgEK7AFOBXm
	 lzotTP8kPSzOg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657DCCA9EC0;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Sat, 10 Oct 2026 18:20:53 +0800
Subject: [PATCH v3 4/4] pidfd: Add task path ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-pidfd-get-paths-v3-4-f245440b2b30@black-desk.cn>
References: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
In-Reply-To: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3684; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=+1T/PPCKeQZBRhmKsitYw/Ec11LSxu55a/COLMCLNMo=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqyhGeHSAru4tTGfalbmhoJcNYCzEfByYH/LxTw
 ceuZnHmKJqJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCasoRngAKCRB2HuYUOZmu
 i5twEADKSVdmpTk/nlZ00M+zdAAWq5/SBTf3ZXGeIyz2tgTjNQ2eIUOYGbg+Sy1YQmPJN4KfCEi
 EBLl26OkJC+9e21ly5xdiJF2opwxIM6FprQCfbAvvR0tYFo3M6YaBcXyhNJRJrMKFxZRtUCH3g8
 cFqLBHG0tDO0fwV6aad/1Y7Fl41Xm2eQX1DsBPwgBk3VqVHFiX+v8XO1Ml0p7YdBIXkJRr69gzQ
 xDOXqz5g9mlj+uFKJVORHK0/LN86AwA00XSrkxPWAGKkJ70eHJhScBwPlFHQHQaWKysfR95hYBx
 1dHy2E7U0N9Y0/pucsHV1ADMNBuFGnorz8bSVQ3blRYwYpCLM68esUqA4vbxv/xNfgcOb30dkWq
 M71eXmfaKuFDmb8CYrE0obRhgU99t4i8C+uJmAlNUe8roFQ1llVN3HlT6ywworrKBiY9rnKXJaF
 7cesgSX3fAg1oHxwk5iCbhu8WD8TAVyQcf3mcxOwmIcfgxWkSfulqzWQpS7ZMzhVTHoUEvEmOnM
 5WC2NJs2rzbhaR7fDzElKWOvmHIpKPiUC+osQx18XlH+lcQ0fd6ib7mmBZzpVNsKoSNwIGLMCym
 hShy2bj27Y6swxJQZUarquzHkgabidlDe/III2wz2oyUriSdk01Q7Iwz6WOhaooZi0Z+I6okj2m
 OGvuJ09FgJHBJJg==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Stat-Signature: ej3jfic6ajyotgwo6fhbphsptk6b4kh6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED02D180008
X-HE-Tag: 1791627683-164587
X-HE-Meta: U2FsdGVkX18240PsZt6jVmrKAwHBhS8Lwq3DnjaBp9rWr0QS+usG+fdoZLE+1jHGCNveDvLG2VM6xOeqHfblowqDb0gtGPNHNhQ9JIjZAtu06eZiCZRqsfwR9DVqzuFezHuxDYM+9UoC7OSiq+UPRZ2a55iHCj7Apv54OPFQx3GApT99HQju4W4zxGlM1G2TtJgL+Ty1EkS32N8WbSIWNSFOVpbKBZzk5miaSk8bevbl4NFyqq8DyPup5Qq8dzftlDiHR1mWiZ3cGbszb80uUOuwvJzUmmZgEitKSboVp4dZLA3fq6uQK1GgL+JJXDBf4hU6JPwLqJiooiXtUw2XvgA1sM746Y1kP+p0bVENAjskujO1G2sei8GMRRvhZK1hKswtzRv3B4scIzvW/oStWNDOMyEy2sdx//bZy8WxV2xzDtzTuFVaurHp8Z/ve2VUGD9CbhcM9hsGK8sWAcwP4EHGRkt2F70JrZfFJHIsqAYeiP/wri5w1HuTFgBjoDDinnXoGnuXckTwIGfeIuye06Sg0+CA/DCSmBt+RRqNSdgyI9lrrTQdTG2eyh+WfHh9MPj/pRo9t+8R4skEWVV/vBsdb6zmbR2tZhVQtqc+tt+ULU6ReKrWAZaPqqK5nuLIC1j3akRSvwBLBhyyQzE6Vnv0/8PP3s/wYUgwzpDx59Znkl+Gi3d6u2dkNtxeSKnEk0/9pv/U5zEQ1sDcufyep7F8F9gnWCje/aR5QDh7YdkwU/RUGVo5KpPOaFKOxQTGQ0yjxICaf65HtLGIp9llWzgFLyVxFT1r28jIF8USQ4tAUSA6vucTRk8FiV7e15NgCsa56mAOMDtyWqKjumKyYBfN4Kr6JuhBPNJOJb2Ch3TWS7jhvBgu6yOiK3uNgvnQneGzMdp7S70TpYV2YItYKLzNpdK9UYlHSpOra2R2MnUTe6SCruk7XExTfdeXSJTr5qYHeGNs+HBu2oxKbDC
 6XGgqFZR
 djVgft6Q44KWYTSeEfdnpmxh8sp6p9+bxdNDotoddHv3poybHQXv1ug41p/QA/sHcx3vxnEBV80LnsUhnoQYOoQajd2xqEvKh0BNAdcf7H9DRr3X4QgJ/YFPjryf2ss3rzMGR9SmWAhBbD0JTdXxKOCw236vXn2MW3D94Hs1Sc5pb2BKdkd4NDdA0G+N8dtviXQVOy99b5PaeexdF32amK9svn0gjF6aWR88W+cB4056s75l6L7b5Q07IVnzlacVz5Ub9pNvOboZsEtxMcO+KixAk9wcyv+lAV3ZSbfvwYlMsgDSA5CwDRyuQrYDT2DCM3MRWOCA4aHbA75eQ34T4FONlKIxdNmOZyUZEOg9Mpw4g23NVOQiE9OiouAT2ZWN+6qD1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Linxuan <me@black-desk.cn>

Add PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT to return
close-on-exec O_PATH file descriptors referencing the target task's
executable, working directory, and root directory.

The ioctls acquire the target through the shared task acquisition
helper and are thus subject to the same checks as the namespace
ioctls. The target is sampled while holding exec_update_lock so that
the access check and the path read cannot race with execve().

This allows userspace to obtain stable path references from a pidfd
without requiring procfs.

Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c                 | 38 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/pidfd.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 82ab4dee55e5..e945c77bdc0e 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -4,6 +4,7 @@
 #include <linux/exportfs.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/cgroup.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -510,6 +511,9 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
 	case PIDFD_GET_UTS_NAMESPACE:
 	case PIDFD_GET_USER_NAMESPACE:
 	case PIDFD_GET_PID_NAMESPACE:
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
 		return true;
 	}
 
@@ -687,9 +691,31 @@ static struct ns_common *pidfd_get_namespace(struct pid *pid,
 	return ns_common;
 }
 
+static int pidfd_get_task_path(struct pid *pid, unsigned int cmd,
+			       unsigned long arg, struct path *path)
+{
+	CLASS(pidfd_task_locked, task)(pid, arg);
+
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+		return get_task_exe_path(task, path);
+	case PIDFD_GET_CWD:
+		return get_task_pwd(task, path);
+	case PIDFD_GET_ROOT:
+		return get_task_root(task, path);
+	}
+
+	return -EINVAL;
+}
+
 static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ns_common *ns_common = NULL;
+	struct path path __free(path_put) = {};
+	int error;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -707,6 +733,18 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
 		return pidfd_info(file, cmd, arg);
 
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
+		error = pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
+		if (error)
+			return error;
+
+		return FD_ADD(O_CLOEXEC,
+			      dentry_open(&path, O_PATH, current_cred()));
+	}
+
 	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
 	if (IS_ERR(ns_common))
 		return PTR_ERR(ns_common);
diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 0919246a1611..95ce1819f423 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -121,4 +121,11 @@ struct pidfd_info {
 #define PIDFD_GET_UTS_NAMESPACE               _IO(PIDFS_IOCTL_MAGIC, 10)
 #define PIDFD_GET_INFO                        _IOWR(PIDFS_IOCTL_MAGIC, 11, struct pidfd_info)
 
+/* Return an O_PATH file descriptor for the target task's executable. */
+#define PIDFD_GET_EXE                         _IO(PIDFS_IOCTL_MAGIC, 12)
+/* Return an O_PATH file descriptor for the target task's working directory. */
+#define PIDFD_GET_CWD                         _IO(PIDFS_IOCTL_MAGIC, 13)
+/* Return an O_PATH file descriptor for the target task's root directory. */
+#define PIDFD_GET_ROOT                        _IO(PIDFS_IOCTL_MAGIC, 14)
+
 #endif /* _UAPI_LINUX_PIDFD_H */

-- 
2.55.0



