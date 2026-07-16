Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E10DC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A716B00DF; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3EB6B00E1; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D98F6B00E2; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2376A6B00DF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5C1F1201CE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:33:16 +0000 (UTC)
X-FDA: 84994882392.05.16EF21C
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id C66A21A000E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:33:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=N24KOIlz;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLgQRvjkegtFxDHYyQzzA8SOU5y1blwPrChppwxjEAg=;
	b=AVZufl7OSk2U7hPEB/hYezqiUxdZtpCegR1z/P0LhH4hrbOTr0nqNqs7TEJJcCp6C258iR
	nd6tO4Nv3EvROVK3hukFCUcDspi25SI/8Im0bBR/DdJS53rGbx9eZd0OV4KcTFMW87K8ZY
	lqNizN0IfZa6ggHHPq4jrPXmE0V0P5M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=N24KOIlz;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212395;
	b=0+vCLmDg58SRbgNWZfvQeRBXGmJ82iZJQX5CWxf//MyiUIPMIhPSip917Pz4SV5SpQrKr+
	MgkcSj3oYr1InKsOCSSF9R2cFz375xO5g0d7ylb6Q4PFEnwSuoomiiZTx12HkojGyVaJMh
	tiJykA5Xl8UtapfYr2Kh3ljouq929po=
ARC-Seal: i=1; a=rsa-sha256; t=1784212346; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZdJsE/0vEBbNiFKex0KPVSttsR7Q+XLYM59HOOE6NnjfxN48EVscoT6PFAvUOUryJjUioA7U6axJMNlhQQZD3nhTnEH2zd5mNrGamY2NeJZnHiLflFYF50/ig3Yr2knfOsCIKvBTHMpnIrmmQc83p2KLtaC+4q/9SmMOhZY3rN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212346; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vLgQRvjkegtFxDHYyQzzA8SOU5y1blwPrChppwxjEAg=; 
	b=nhOZOHQHgLC1lNxfAHlk5pJPevjCQBbZ1J8SVcVZRKzn1Bagho0HIQcPC55DCHubIo5qoldoxW1hh+gCuLWnpZKPGes0Q7KVxPh1dyBHmx9f5K+KWbWb5E3GT1Bxz66laJ2uM20ImuoYczTK6vE6FQl+vpil1zY75d5YVLAO0Mw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212346;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vLgQRvjkegtFxDHYyQzzA8SOU5y1blwPrChppwxjEAg=;
	b=N24KOIlzocgoLAYjb7tmRFLoKMnyOcUpMYFTPduMUo0Fy6nZgVA9KukniwBxo1lc
	WDDXubl2fxzluRy1cfdN6UXul6Ow7OQFtJduxPRZhtXtdJpElaiGM5Vgc8Q4VfD6B8v
	eaqdWXyfueurVyHM/vnJXsPRUYr7Zizo8pysCBQE=
Received: by mx.zohomail.com with SMTPS id 1784212343415557.0920836372659;
	Thu, 16 Jul 2026 07:32:23 -0700 (PDT)
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
Subject: [RFC PATCH 01/24] pidfd: add spawn builder uapi
Date: Thu, 16 Jul 2026 22:31:27 +0800
Message-ID: <0ee77dd90ea5d00b66a3e017488ab64f610cf41a.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C66A21A000E
X-Stat-Signature: 84qzcrcsm5jegyq6z59f8hk9gifnt1n9
X-HE-Tag: 1784212394-417660
X-HE-Meta: U2FsdGVkX19RcESH/vCr0bSpZmRAXb/HHikG2R5BTZAZ4BNIvcq7hmzJGzPgFig2/8uf5TyG8QAXTPxYxuvQpd6XyC6a6FEFKjWjMJD92hHOGEAKeNtpoHYX8jk5eWO01kyYMJU4y9fKgaPdZf3e2VSjSmSZPpEz6F6FK39o14NL6YqzvzR63JsD0/7UkACG41Dsyw2UKtswxbJa4vvZypAOt109WOkV1wCW84zpuhagqN3NJKkwCAeHDi+42d2h0rdlvLXcahXTVkS3VfnHDhXFa0ejAa+V1DOiEP1nNvZ94pmb6711mFEzMwRpQ+5GpiKqhfFLPoyJuvXebf7VsS8zGEqOOZ65YIaIjYF+IoCQD2V8K43RinWHBg9asz2aNDP8j+zZ1TfC3F4KEhTy4eZEU67NEjOpvrPDuHZj8FONuBeM3KB9RUEbbSLiwR3LiBL49hfwyGGWqFSSGjzgXibeLsMVnu1XgusLtpVWaizPHFUKZEakfN/wQia7tSaqqQaxqADAjW9nMLKhD+QfH6foEj8DCynWZCtFQHqZWRGV+YgJv03s/0H2//B+SIG+rsONOFQw4LALF6D6Gi5c5YWpp+lobNCQsBBMfoEEbfmYM4z7QqREY/ePGvgxtX0foXPKYvXFMHC92yrmTwWUePXd3wEST3OEiVmI2wWmbXhS9e/KvTdT+gtdXLIVDMI2FERP9V8Jfl9qjhHHmpFkKXlFsLmd89mErjF7f8PEcsAv/fo3PZbe3YwUcBH/pRFWRHXRy57714TeHQY2Pa6hmZkiMdUwuRB5WDifTW8TaiGIHo4ux+Uvh25H+AgRUWoWYu7jBKCNxdr6uCEAcvFWFHj9tmC4bbZqCA15Ug/HfLKsFlpuQtqi6muuDhU5UNPnS9L+SBaekSC+1XU9+MTH8/iQEEeyQBLLjUGPpRVUPDfxFtGywIv0bbfrKlUq+7fAA+uzsYtg73ALbHK/L2J
 wVquM931
 +hFs2l8Bi7vL7tdjJSNi7du3W8l/wc6wSg4qJCUdQfaSpuyNsGpAl+MQZKqOAlCT2fTR/GIi3sHKMys/Wf9w2eoj+75YJdA6ttZRYCTYTz5N5DuToMQ3XjfvTixqwmWYne6oKQyJ3MFqdqu910skcSSb297tgWFS2E8PJmkTZZYihGl/xerN0zRVNi+i4beNEiyZi05z6riQgh2CthkHCZfgk8yFZZYLmpuoK47y714dXV4ORkT6MLDhbjHhstyZQYiHdV7LFoUybjGNDi2wf0Gopn6s9OWWv8fU0EGWBL/LWKEi3gyO0PI2Yd/FK8MYX9D998cSS6BlrdFTWH2PyCieDvaAyoLEXImLtTXWCX3FgHTgnEhqo7QtBgriv2jFL+D30aQj5cdfzEiPLKD8TwTheXcW4CyxZCLmEu7t/Sni+G5ohD64p//FNtrKiHotlhNaLWYjl4ipHPrwY4q4Ycm6LPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define PIDFD_EMPTY, the fsconfig-style configuration command and path
key, and versioned run arguments for pidfd spawn builders. Add the
initial ordered file-action records.

Store userspace pointers in full-width aligned containers on every ABI.
Keep flags and reserved fields zero so later kernels can extend the
structures without changing their initial layout.

Suggested-by: Christian Brauner <brauner@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                            |  2 ++
 include/uapi/linux/pidfd.h             |  1 +
 include/uapi/linux/pidfd_spawn.h       | 49 ++++++++++++++++++++++++++
 tools/include/uapi/linux/pidfd_spawn.h | 49 ++++++++++++++++++++++++++
 4 files changed, 101 insertions(+)
 create mode 100644 include/uapi/linux/pidfd_spawn.h
 create mode 100644 tools/include/uapi/linux/pidfd_spawn.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8729cea57c3dd..b63bc1ee0171f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21287,7 +21287,9 @@ M:	Christian Brauner <christian@brauner.io>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git
+F:	include/uapi/linux/pidfd_spawn.h
 F:	samples/pidfd/
+F:	tools/include/uapi/linux/pidfd_spawn.h
 F:	tools/testing/selftests/clone3/
 F:	tools/testing/selftests/pidfd/
 K:	(?i)pidfd
diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 0919246a1611c..cad5b722e9f0e 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -10,6 +10,7 @@
 /* Flags for pidfd_open().  */
 #define PIDFD_NONBLOCK	O_NONBLOCK
 #define PIDFD_THREAD	O_EXCL
+#define PIDFD_EMPTY	(1U << 27)
 #ifdef __KERNEL__
 #include <linux/sched.h>
 #define PIDFD_STALE CLONE_PIDFD
diff --git a/include/uapi/linux/pidfd_spawn.h b/include/uapi/linux/pidfd_spawn.h
new file mode 100644
index 0000000000000..46d61e72435cc
--- /dev/null
+++ b/include/uapi/linux/pidfd_spawn.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_PIDFD_SPAWN_H
+#define _UAPI_LINUX_PIDFD_SPAWN_H
+
+#include <linux/types.h>
+
+#define PIDFD_SPAWN_RUN_SIZE_VER0	64
+#define PIDFD_SPAWN_ACTION_SIZE_VER0	32
+
+/* Commands for pidfd_config(). */
+#define PIDFD_CONFIG_SET_STRING	0
+
+/* String keys for pidfd_config(). */
+#define PIDFD_CONFIG_KEY_PATH	"path"
+
+struct pidfd_spawn_run_args {
+	__u32 flags;
+	__u32 nr_actions;
+	/* The next four fields are full-width userspace virtual addresses. */
+	__aligned_u64 path;
+	__aligned_u64 argv;
+	__aligned_u64 envp;
+	__aligned_u64 actions;
+	__u32 action_size;
+	__u32 reserved0;
+	__u64 reserved[2];
+};
+
+enum pidfd_spawn_action_type {
+	PIDFD_SPAWN_ACTION_DUP2 = 0,
+	PIDFD_SPAWN_ACTION_CLOSE_RANGE = 1,
+	PIDFD_SPAWN_ACTION_FCHDIR = 2,
+};
+
+struct pidfd_spawn_action {
+	__u32 type;
+	__u32 flags;
+	/*
+	 * DUP2 uses fd as the source and newfd as the destination.
+	 * CLOSE_RANGE uses fd as the first and newfd as the last descriptor.
+	 * FCHDIR uses fd as the directory descriptor and requires newfd to be 0.
+	 */
+	__u32 fd;
+	__u32 newfd;
+	__u64 reserved[2];
+};
+
+#endif /* _UAPI_LINUX_PIDFD_SPAWN_H */
diff --git a/tools/include/uapi/linux/pidfd_spawn.h b/tools/include/uapi/linux/pidfd_spawn.h
new file mode 100644
index 0000000000000..46d61e72435cc
--- /dev/null
+++ b/tools/include/uapi/linux/pidfd_spawn.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_PIDFD_SPAWN_H
+#define _UAPI_LINUX_PIDFD_SPAWN_H
+
+#include <linux/types.h>
+
+#define PIDFD_SPAWN_RUN_SIZE_VER0	64
+#define PIDFD_SPAWN_ACTION_SIZE_VER0	32
+
+/* Commands for pidfd_config(). */
+#define PIDFD_CONFIG_SET_STRING	0
+
+/* String keys for pidfd_config(). */
+#define PIDFD_CONFIG_KEY_PATH	"path"
+
+struct pidfd_spawn_run_args {
+	__u32 flags;
+	__u32 nr_actions;
+	/* The next four fields are full-width userspace virtual addresses. */
+	__aligned_u64 path;
+	__aligned_u64 argv;
+	__aligned_u64 envp;
+	__aligned_u64 actions;
+	__u32 action_size;
+	__u32 reserved0;
+	__u64 reserved[2];
+};
+
+enum pidfd_spawn_action_type {
+	PIDFD_SPAWN_ACTION_DUP2 = 0,
+	PIDFD_SPAWN_ACTION_CLOSE_RANGE = 1,
+	PIDFD_SPAWN_ACTION_FCHDIR = 2,
+};
+
+struct pidfd_spawn_action {
+	__u32 type;
+	__u32 flags;
+	/*
+	 * DUP2 uses fd as the source and newfd as the destination.
+	 * CLOSE_RANGE uses fd as the first and newfd as the last descriptor.
+	 * FCHDIR uses fd as the directory descriptor and requires newfd to be 0.
+	 */
+	__u32 fd;
+	__u32 newfd;
+	__u64 reserved[2];
+};
+
+#endif /* _UAPI_LINUX_PIDFD_SPAWN_H */
-- 
2.52.0


