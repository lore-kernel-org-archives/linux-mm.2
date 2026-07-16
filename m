Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D58C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7138A6B00E3; Thu, 16 Jul 2026 10:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECA76B00E5; Thu, 16 Jul 2026 10:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BD26B00E7; Thu, 16 Jul 2026 10:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5846B00E3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C883401E7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:36:03 +0000 (UTC)
X-FDA: 84994889406.16.6807CCB
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B0391A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:36:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Ye3rs0MS;
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212561;
	b=qYfFhHrUPjK7tiXCRbL/jgkixodhzoL/mD4qMXRBJSMJEPWbK0o2suULp6nx72AHE/MIee
	GJVpUcn73LjXkVLWvtaxTFehGTm+lSt2NEq5PSWNEYnxKENVT10PSWSFELUxi3l5WbbaRl
	dsGmvG5CyRWSMz9lHvnVuu8I041RyIc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Ye3rs0MS;
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WlGJlssUl95Sy+7ZPm60xZZ+Av02JpGkVDZJY42NWU=;
	b=Y//N8YL5gZ8W706vrmnrSNnoGoJW+tCHnEcfxOcsRi2gGtB3+XNeSpWPxjcwk+ZkKLiPnH
	SjTMk4P8j4x/sBwNItIj9wTNxxOhMQxkn1vi4Llfy23zmcLwcg+xpf5HOShqygCRdF/47J
	Qb5Cs3dH/ACdl8916rAuibpZsamqIFE=
ARC-Seal: i=1; a=rsa-sha256; t=1784212392; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jznrEKQdfJK9XlXLcrwXp+M8yZtQRw2PwL7zl54fcjtEVz6vmhH8bl0X+MXWpJRmWfCboECKYLXqtNARRLsmfdXi3brdOq6Promtrd0y2F4BlrHokWOsTFd4/Orz/69DXccypqrEurxZ7tNUYSAcpYwJ3i7YJP9tlZST0Q5/O+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212392; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4WlGJlssUl95Sy+7ZPm60xZZ+Av02JpGkVDZJY42NWU=; 
	b=Xkelz1J9SKXGI1ETZ7bxCTxKBpH53gqotNR/jBZjWm0bNQcP0Zp1nZ/m+pRm2NRriNMae33rGCEg4jXMgpkaEMyHP13mAMilGNDq3ewpAe7JFtV01FH0U1KbgUYf4qw49Ed4lChBM9z5T5zaYykg2e+U+3OSmfABS4R4clGuZV8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212392;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4WlGJlssUl95Sy+7ZPm60xZZ+Av02JpGkVDZJY42NWU=;
	b=Ye3rs0MS2ukDX+2xyNEMYeevu/o4eWER+D22wvIpwNj1OeTLZYWEJDP6z6/ijY0F
	sQGMAIOUEUfdNZnL9rP0A6OJnGPU/ervlYSefajfn/w4dJMHer5zULGF2HwEa/qoP3y
	FG5jUxQdbY8XSQe+/uAyWimxw2ApcipNIRHWj05c=
Received: by mx.zohomail.com with SMTPS id 1784212390537743.799194073505;
	Thu, 16 Jul 2026 07:33:10 -0700 (PDT)
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
Subject: [RFC PATCH 06/24] exec: expose execveat internals to process builders
Date: Thu, 16 Jul 2026 22:31:32 +0800
Message-ID: <35cbc4c456675c2613ed4682d88aad8af83370cf.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B0391A0008
X-Stat-Signature: 3hrqfofc9gqgsm33i4c8s4g9o4xj6tqs
X-HE-Tag: 1784212561-402320
X-HE-Meta: U2FsdGVkX19xvXpJcFbmKkycpDVgjJq96n8oLrowGqkjL0Q/h8xkjPfsJSNGAORUpkNTrLP6PnPFvRHPBMSJyxd89ZLqLvn3fvXbSnPUta8fgOf3qEkRB865L+RTzBiBIX7Ezf+zYqcJ1d8ASUUki4DbHiokqEfDUK+FZrODWTgrh0rDBsqVTM0ZtOX49JFnqIXXEAn4zgAfCBk7mGxDyRIpf+K11uOHye8ljXL7GPYMFfDUwgtzVvoiXUWCVN7tXw9gLNWWARWktm7aoo2iGUS6XE/MIlkDUiFah2s3raNn396t3qwWFjt3bFYcySfdeRoZGsW9ShxiYAc87couylvkEd64mGtWwur/kX6aRE7aNEIs20g41cf0H0ngM7m+1n+u0MuN5+IoEtcmNYPoicTcpyAbxd12QT1GouXXmmmnuQ7LYWXc1BtGFSW0X+Dj3C/5tsbsKE3JKGo+tF1slAm9DzOdTP0QdS/1bHcfjVTZFJz6WfhXRE068MGbKG+miNeg+Iqjlfe3nMsYafcJhdSgLu83BoBoz30126eJ2IJiFWXDgEPbzrTighGWMOesCnwg+n/NshA4+GIBl1E8O2ueTOvtBYsXj5jlChQj6674NTHIMGubzOrZB/8BTjGtSbhaqRXmNSzxtPPXTdYOdAuhPFA2i+6h23yZJU9GL4pgMib4e0L32XS6ilvGNIeP8xtm70ZO0iF3dHkSbO6GKla+1WHhpqG7UONfwzSwTVBzq9dk2YfJZXBnididbYMnVyKb4GAeynVWKWr1f/CiWzkPTMsKyGTUYSZEy5T6N8xKDWr5zI8PI9LDkLAfjCycTvYm2sItehkR3uOQYCseNLODdljFlhFRbXuYYCjS/b7XMvjY/jGF8y7fWgIYvA+Rm7jKBpsFcDjsqChVE/lwDvyftcnbbNNNrOnlsUZzjxeoiVHwKnMKgirZ2jC9GS4xT34x0Cj476tFpFXhunY
 hRQ5Olya
 c0oFoClvYnw9iFB/jqpgwu/iOI5xNbW3ZS2mVuDejfbmymC5ccvCOMylWie5IcZzUcBAi9cw7elNRxgDbNX7t9ukDSA2xKO+Ee4RMaDJuWxVoeBGrl0TKdeBtGsHDrTvJrCgxani1/K2s2sbMUPEfk91bWs13zThmNdVwkND1O9+lRE/QL4pO10kboI9VzuiEl9jM0HA/gdJZEo/Wf28gXhN5d3ke2DMVOB3lh4wnZRXmtvxnN8q/S/cEEBBgywzvFrtbyx8UISeQD9EKxVjTvD6gp/3kM1RVOquz3kqFLX3XcjTBPl+qMdr9gz+hTJx30ObEV7JRMViuWO9RJaCYLRhIZGjIMT5kSfRrAL8kyTu6Fyq/JdIET+geVKxPEvCcbKZtC02ccfAUXwfcf6opAIFF7CkT3FCQucXOw3kqGnrInA6ERxGvmGrvKANoVm0yzFvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move struct user_arg_ptr and its native and compat constructors to an
fs-private header. Expose do_execveat_common() within fs so a process
builder can enter the normal exec path without synthesizing a userspace
execveat() syscall.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS        |  1 +
 fs/exec.c          | 28 ++++------------------------
 fs/exec_internal.h | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 24 deletions(-)
 create mode 100644 fs/exec_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d7f94f09f414..85b1306cb2ff3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9757,6 +9757,7 @@ F:	Documentation/userspace-api/ELF.rst
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
+F:	fs/exec_internal.h
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
 F:	include/linux/binfmts.h
diff --git a/fs/exec.c b/fs/exec.c
index d5993cedc829a..1a256ba26425e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -76,6 +76,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "exec_internal.h"
 
 #include <trace/events/sched.h>
 
@@ -291,17 +292,6 @@ static int bprm_mm_init(struct linux_binprm *bprm)
 	return err;
 }
 
-struct user_arg_ptr {
-#ifdef CONFIG_COMPAT
-	bool is_compat;
-#endif
-	union {
-		const char __user *const __user *native;
-#ifdef CONFIG_COMPAT
-		const compat_uptr_t __user *compat;
-#endif
-	} ptr;
-};
 
 static const char __user *get_user_arg_ptr(struct user_arg_ptr argv, int nr)
 {
@@ -1805,10 +1795,9 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
-static int do_execveat_common(int fd, struct filename *filename,
-			      struct user_arg_ptr argv,
-			      struct user_arg_ptr envp,
-			      int flags)
+int do_execveat_common(int fd, struct filename *filename,
+		       struct user_arg_ptr argv,
+		       struct user_arg_ptr envp, int flags)
 {
 	int retval;
 
@@ -1935,10 +1924,6 @@ void set_binfmt(struct linux_binfmt *new)
 }
 EXPORT_SYMBOL(set_binfmt);
 
-static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
-{
-	return (struct user_arg_ptr){.ptr.native = p};
-}
 
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
@@ -1963,11 +1948,6 @@ SYSCALL_DEFINE5(execveat,
 
 #ifdef CONFIG_COMPAT
 
-static inline struct user_arg_ptr compat_arg(const compat_uptr_t __user *p)
-{
-	return (struct user_arg_ptr){.is_compat = true, .ptr.compat = p};
-}
-
 COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
 	const compat_uptr_t __user *, envp)
diff --git a/fs/exec_internal.h b/fs/exec_internal.h
new file mode 100644
index 0000000000000..bf6a873e98426
--- /dev/null
+++ b/fs/exec_internal.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _FS_EXEC_INTERNAL_H
+#define _FS_EXEC_INTERNAL_H
+
+#include <linux/compat.h>
+#include <linux/compiler_types.h>
+#include <linux/types.h>
+
+struct filename;
+
+struct user_arg_ptr {
+#ifdef CONFIG_COMPAT
+	bool is_compat;
+#endif
+	union {
+		const char __user *const __user *native;
+#ifdef CONFIG_COMPAT
+		const compat_uptr_t __user *compat;
+#endif
+	} ptr;
+};
+
+static inline struct user_arg_ptr
+native_arg(const char __user *const __user *p)
+{
+	return (struct user_arg_ptr){.ptr.native = p};
+}
+
+#ifdef CONFIG_COMPAT
+static inline struct user_arg_ptr compat_arg(const compat_uptr_t __user *p)
+{
+	return (struct user_arg_ptr){.is_compat = true, .ptr.compat = p};
+}
+#endif
+
+int do_execveat_common(int fd, struct filename *filename,
+		       struct user_arg_ptr argv,
+		       struct user_arg_ptr envp, int flags);
+
+#endif /* _FS_EXEC_INTERNAL_H */
-- 
2.52.0


