Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E60FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9521C6B009E; Mon,  4 May 2026 05:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D99D6B00A1; Mon,  4 May 2026 05:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B4C6B00A0; Mon,  4 May 2026 05:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4496B009E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B3DEA02EB
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:43 +0000 (UTC)
X-FDA: 84729225126.18.6B1EDC6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E722180005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4fiTe258;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ya8hyzbQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54QuLJcpe0mdHxqir8B4oCgM7uiPnZyrpfVJkv2VNTQ=;
	b=X+pyTCPFcRL7qlr1RSTd7m5M29QZ2aCJOLOUFMTusgj11cWOT/N0NT3FjBaG3V4BSGP4HC
	JdU6wny7XTVJ3aiVbtIiI6EyJwpxr9URcCB1COEvXCjAsCuV8FZfeQP0ACbkZKzAF6/noF
	UVeWroBvMOh0RPNn+VEnEd/D212yECs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887221; a=rsa-sha256;
	cv=none;
	b=sc4pSp73LPUFh+1s7BC2H7jJF55rXKGAqeS6h9fwee2CeotATbDRO/XiSCjmJuStckIlxI
	br/+thuTRZHYHR0z5O4ALldX1HjwvvzmZWskP+ol0+iEfMNYD29/8oJDh9PRYrUKk43S7D
	8hyC2oGrRWZjj44c3A6ZZdyr69/rlEo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4fiTe258;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ya8hyzbQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=54QuLJcpe0mdHxqir8B4oCgM7uiPnZyrpfVJkv2VNTQ=;
	b=4fiTe258PXM0AU2nF7sr5EciL3AdNsNqw81aKrsuxiSBuO4QWf6cAgiMuXLDkBqdvK/XKu
	Ijh3JsX+2dnvAA7LEJpd3cMm46MSUJw5WXC1RTCOLsH2Yswj6DGbHBNmSLGncTETXbrxTG
	B7uwGflbsgYNglEpYOTQ+8l/Dv67mXhK16xU+rzb0T0b4WpETfUPPNPuKNBvOeR/Suw2UY
	96NZZQKjHOOj8/2Fm3c8UNkb70iz1uCEWY6vurHFQLmvXaQucDFopVFYbyPCYPlhA9Tfnj
	+3g8IyKdCIKcMtfF5sd7lSHjIHCKrH0vup+LBZ6I9zlA1WLT5dKKLzAm0dINiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=54QuLJcpe0mdHxqir8B4oCgM7uiPnZyrpfVJkv2VNTQ=;
	b=Ya8hyzbQcKEwRoNDtlD4uUE03ky+hH7RSJQxS5sQvYcq4X0VjPDSsiV9I/5Dbl6forYmpQ
	LVR3IRbfPh4yaiBg==
Date: Mon, 04 May 2026 11:33:26 +0200
Subject: [PATCH v6 10/11] kunit: uapi: Introduce preinit executable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-10-712d3d526d97@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=4914;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=CX9mDSQHReDHwq7Y7h5slKzIlaWwgoLVwu8rW9SRZP4=;
 b=rOUneMbzF1f113+9Wt2C9L8BsiwD6Dzs1kpZ+t+eIdHAn5qh6FHYThaZdNzBgRt7wbUS+4RoP
 isGDCOYJAILCmFNroiCghjSkp5vq1Kt9kPuoxp+L8KlkpBK1EnCvsKx
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E722180005
X-Rspamd-Server: rspam04
X-Stat-Signature: oucyhwmhbw9jan8ggq3nwinwouiujf39
X-HE-Tag: 1777887221-262916
X-HE-Meta: U2FsdGVkX18/XEsBNWaTJcsHn9Z7LN4yWSYJ8T5FmzremlHMW7RXjj25YfzeOKkv6pETOE2IkeQ4+mtYVikiQGVuY0SABS+U9z+UT2nsjpfW54ggN9lTuoliE/ySmUXWxkOpNUss93l6WKXeUlMa+MrS54pq4YU7cJKfoCpOhyaEo4nDap0w+ODDRUwn+WIpDESkGkAKahYVxCprwNUNCiTiGQ/R1xVqcf8yrPwlS0HDWLLcoXR/1QklTlIVabvt35cq9p3H96YbMAWql2CjG5WEYKV2fpIHLqh7WF/+cp/w41LSzCaUowxXwxjEMSdfD5fLzHFMDN90ueDC6xCl8erj7wJu/idG6TpPQDO7+kRXqhOWVENZZy56Kodu/tJjpCju0SD8S66HtPZ27IWVBOUHOFAwbShMMLJIZdFnYSI27j4Xay6U9Xj5plTf8C7gzFZU+v9qF60y7TYuepaU3W35MJ6IiwTgsQD4IEcDf/yzyfL85OqDrCtpDKIKOINwNAPwnzM+SjPy2j5MLEFpi5gqrGplLKhPDa/QCEykuiaJ68VwGzkPGw6+SYb9R6W/EJZP+35f2CWZcWVkoJwwerEWfWuRdJSbG0jfyAPjRV6ftWVph+gr3jHHqq+smq44WVcAXtXjv+IQfqHqa01f4c4LAcntvxAVoMff93Ajd9+//kz+ePkxoRhIcGsrrjxkRs+KromgawX3vx9zj5TpMaHkVy3VV4dXTlC5r2K9TkVZKTWMlo9gCE2q06TQ2+tEBqIeTHKC2zvkefsS0V2+eNHtPRbiBevSer1MtbVgP4K2+nklf6Wf5WrHz9mnOJu866v8vgvSHIGSOKtoJwbvN1fwApQscSHf3bVYc7YSclj8BxUw2MoF37erzAUwjCmqmrdtgNS5tKvoezzk2ryCcAWTa5wYw2R4bhEC5Nc3pSE6w4Dd6yBIe5SJyyUraCrpgGvUpeI94nkt49ht+D3
 JKurDn8V
 96OiCoP0+vucdk2g3K4au1Bem8m5dZ32nTbphEpuuqh3fvAEfyTYushWl87D+05gO52MbbnavYRCsDbH6QmkaO1ca1NObW7uHnPUqu7Tt+2IiedcR7J23MgGbjisV7gPs8cr207LZ/tO4z9S7k54/u37Z64V9alWa21SgTQ7MbjKMS/ytoZ7LXj17NT96dV37apxaK2Gk6aFr6OldiKrUJxww50R8TOOnBPmAluUONUgj2O1UeYpaJUCDbMuOMIg9x4ztLbzoJA4t68aSLvh+DpOEcYOTypNObn9SDTOr88jrK1T45HGZruRRm/DUwdiojNfJCRRj5vAIKR3bBherQ4jWHYpdpg9NLyXw3n9SnXZK7aZbFfEaVAHxaogYLNcWtcdsQ/IWnx4oTW79tQ1xmEyc9KXmbpQ7/hHAnuLjskQkvrWGKB65lqeLvDXvVSKe19/pJTB9n2wuuC4JbEOa+cRKWnM/KZk7dcF7oKNrdNFJEmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UAPI selftests may expect a "normal" userspace environment.
For example the normal kernel API pseudo-filesystems should be mounted.
This could be done from kernel code but it is non-idiomatic.

Add a preinit userspace executable which performs these setup steps
before running the final test executable.
This preinit executable is only ever run from the kernel.
Give it access to autoconf.h and kconfig.h to adapt itself to the
tested kernel.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
---
 MAINTAINERS              |  1 +
 lib/kunit/Makefile       |  5 ++++
 lib/kunit/kunit-uapi.c   | 11 +++++---
 lib/kunit/uapi-preinit.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b7358d89df70..4e8cf9fa7aa9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14401,6 +14401,7 @@ S:	Maintained
 F:	include/kunit/uapi.h
 F:	lib/kunit/kunit-example-uapi.c
 F:	lib/kunit/kunit-uapi.c
+F:	lib/kunit/uapi-preinit.c
 
 KVM PARAVIRT (KVM/paravirt)
 M:	Paolo Bonzini <pbonzini@redhat.com>
diff --git a/lib/kunit/Makefile b/lib/kunit/Makefile
index 2434470e9985..05991d69aa70 100644
--- a/lib/kunit/Makefile
+++ b/lib/kunit/Makefile
@@ -14,8 +14,13 @@ kunit-objs +=				test.o \
 					device.o \
 					platform.o
 
+userprogs +=				uapi-preinit
+uapi-preinit-userccflags +=		-static $(NOLIBC_USERCFLAGS)
 obj-$(CONFIG_KUNIT_UAPI) +=		kunit-uapi.o
 
+CFLAGS_kunit-uapi.o :=			-Wa,-I$(obj)
+$(obj)/kunit-uapi.o: $(obj)/uapi-preinit
+
 ifeq ($(CONFIG_KUNIT_DEBUGFS),y)
 kunit-objs +=				debugfs.o
 endif
diff --git a/lib/kunit/kunit-uapi.c b/lib/kunit/kunit-uapi.c
index 7f0309a827a5..702d26878ccd 100644
--- a/lib/kunit/kunit-uapi.c
+++ b/lib/kunit/kunit-uapi.c
@@ -33,6 +33,8 @@ enum {
 	KSFT_SKIP	= 4,
 };
 
+KUNIT_UAPI_EMBED_BLOB(kunit_uapi_preinit, "uapi-preinit");
+
 static struct vfsmount *kunit_uapi_mount_fs(const char *name)
 {
 	struct file_system_type *type;
@@ -158,18 +160,17 @@ static int kunit_uapi_run_executable_in_mount(struct kunit *test,
 					      const struct kunit_uapi_blob *executable,
 					      struct vfsmount *mnt)
 {
-	const char *executable_target = kunit_uapi_executable_target(executable);
 	struct kunit_uapi_usermodehelper_ctx ctx = {
 		.test	= test,
 		.mnt	= mnt,
 	};
 	struct subprocess_info *info;
 	const char *const argv[] = {
-		executable_target,
+		kunit_uapi_executable_target(executable),
 		NULL
 	};
 
-	info = call_usermodehelper_setup(AT_FDCWD, executable_target, (char **)argv, NULL,
+	info = call_usermodehelper_setup(AT_FDCWD, kunit_uapi_preinit.path, (char **)argv, NULL,
 					 GFP_KERNEL, kunit_uapi_usermodehelper_init, NULL, &ctx);
 	if (!info)
 		return -ENOMEM;
@@ -192,6 +193,10 @@ static int kunit_uapi_run_executable(struct kunit *test, const struct kunit_uapi
 	if (err)
 		return err;
 
+	err = kunit_uapi_write_executable(mnt, &kunit_uapi_preinit);
+	if (err)
+		return err;
+
 	err = kunit_uapi_run_executable_in_mount(test, executable, mnt);
 	if (err)
 		return err;
diff --git a/lib/kunit/uapi-preinit.c b/lib/kunit/uapi-preinit.c
new file mode 100644
index 000000000000..686737ea3c76
--- /dev/null
+++ b/lib/kunit/uapi-preinit.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit Userspace environment setup.
+ *
+ * Copyright (C) 2026, Linutronix GmbH.
+ * Author: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
+ *
+ * This is *userspace* code.
+ */
+
+#include <sys/mount.h>
+#include <sys/stat.h>
+
+#include "../../tools/testing/selftests/kselftest.h"
+
+#define KUNIT_UAPI_CHDIR_FD 3
+
+static int setup_api_mount(const char *target, const char *fstype)
+{
+	int ret;
+
+	ret = mkdir(target, 0755);
+	if (ret && errno != EEXIST)
+		return -errno;
+
+	ret = mount("none", target, fstype, 0, NULL);
+	if (ret && errno != EBUSY)
+		return -errno;
+
+	return 0;
+}
+
+static void exit_failure(const char *stage, int err)
+{
+	/* If preinit fails synthesize a failed test report. */
+	ksft_print_header();
+	ksft_set_plan(1);
+	ksft_test_result_fail("Failed during test setup: %s: %s\n", stage, strerror(-err));
+	ksft_finished();
+}
+
+int main(int argc, char **argv, char **envp)
+{
+	int ret;
+
+	ret = fchdir(KUNIT_UAPI_CHDIR_FD);
+	close(KUNIT_UAPI_CHDIR_FD);
+	if (ret)
+		exit_failure("fchdir", ret);
+
+	ret = setup_api_mount("/proc", "proc");
+	if (ret)
+		exit_failure("mount /proc", ret);
+
+	ret = setup_api_mount("/sys", "sysfs");
+	if (ret)
+		exit_failure("mount /sys", ret);
+
+	ret = setup_api_mount("/dev", "devtmpfs");
+	if (ret)
+		exit_failure("mount /dev", ret);
+
+	ret = execve(argv[0], argv, envp);
+	if (ret)
+		exit_failure("execve", ret);
+
+	return 0;
+}

-- 
2.53.0


