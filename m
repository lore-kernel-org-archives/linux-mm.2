Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28E0C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4370D6B00AF; Sat,  4 Jul 2026 19:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3C16B00B0; Sat,  4 Jul 2026 19:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACB26B00B1; Sat,  4 Jul 2026 19:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D092C6B00AF
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5216F1A05DB
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:19 +0000 (UTC)
X-FDA: 84952662438.23.483F816
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0AE84A0008
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DzABs/ee";
	spf=pass (imf15.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82tiJlQOsrppX210mppl4/mvZUr9jLj2obLCUcO9bUw=;
	b=umbS1MGO3WxKowYaQ7v8RhXe4U754zvMjleKJftsSrp/8urcpPW3MVxicnr9XLcKTVHdMO
	urghgAZQ/7zELsOmP9T90VsfAYGJXiD8jmyf+6SBkxy7IESs2B5oPBr1vaLNIHUsb2bw3n
	ytdOv29xy36UOChiLU86OvFO7DmjgK4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DzABs/ee";
	spf=pass (imf15.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207157;
	b=hrO+Dmplv7IxTDZ+vBc8ii/E5Tb1SX5pmcltd3/EQoIbTHEZa+rwlfw4BR/IHfzE5uQEZn
	Mu43d7vOL7Fe7UiI2699ZrUhSAL4Lm4p7oekzpqBqALE6Pkh5r9lmOvobVPe8ckEwJynGw
	9rGGuNAz2TzBs+aETYIIXxIJud96ZGo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caced6038eso17734745ad.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207156; x=1783811956; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=82tiJlQOsrppX210mppl4/mvZUr9jLj2obLCUcO9bUw=;
        b=DzABs/eemgYVKvePOJ8cINovQop1fmKjZPKv6521Ke6smgZm1TSVZGUT2bfEEiJ/gr
         vQ37aEDO7lezTBAMSvGzrUWdGQbdKI9n/NEat9QBOfWpnVsiJb75LFcudyLZHMSDi2HG
         pemDWFfnR3YHw32WWJiiU7d/Jqnu8kMrRxdHKzKYPqn3LyQcAtIncYMipPOmK87hpi5z
         E2lhuhXzrkVuqyGC+PN840HXof/9a3mSKXcpUnvTGLCzoEvL9KNSEgRvwLiz3B+Vjjxe
         03GE47G6tfdFyWGkyb1IdTCnO8pvrK+qRutqEDkJKZreJek8lQ3YhOC9ILB0H7tzt1U1
         HPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207156; x=1783811956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=82tiJlQOsrppX210mppl4/mvZUr9jLj2obLCUcO9bUw=;
        b=es2d2cmadx1j3zixjUyThlKsSmgJUiGBcnpcoTrzBXKW1Y3Da8w2zT9XIvNEZ+PMOy
         8UPs2VWwTecUrD7s1JR47p7ilvIwCYGJAEN/SlCzeTPQl/lGleOFFgud7045HEn3Cu2A
         DQOTa+0IXi+AAmudg4/OOy2bnFvQndBQIWVZZ6d1ruzl/qJi9h0hLlPDM/ilp4iITMjN
         oP+aNAEiXPYWAfU2Y+aPx+wDoVSz9WuX47AK/COFginwqlExDvyvvpG9AbCBSTOj+0dc
         AwH/PlN49ZAJPLVfw1hJ/eblWADDx62PKvLAlYjqk/jfT+h3qjRDswQC7eD3NXPxQBG5
         /NGw==
X-Forwarded-Encrypted: i=1; AHgh+Rrx7aALuPD8SaDbq4uuMHBuUcwasr0kBUbqLuRyruDqaI7/gvqai+t8b4SHkknDGrkjrY1B01L5aQ==@kvack.org
X-Gm-Message-State: AOJu0YwBGVauZu46Osrq5YsZxkymgLfwUAh5EsdBZiugJNZ+5zooYa73
	DlKZkO6mC7u4myo21fc2wOYyWdfhBuXdg0o7acGu41Su4vc4xIJrvdlr
X-Gm-Gg: AfdE7cknypOQlZuoZMvlsHPL2BTx6UOfAQ1VLE9WHZlgAKZdolWsHkjzq7HNlfa3EBM
	jjiN3EsKBIIQKcZLLBndvtLsJlrjjL2hSUGGEtSLFP7y5iTz866z6Nelv9BBK5OpM9U12Zb0LhK
	xJasFwHMlz/CLgbipWwBVxW0o9F2FsoLQVoRrvTJxghkUiwZJ3mpPjLn29NTVcjS7qqOictCAjm
	D9paLn/IeAjU50TrKL11hOuovg9VUZEva1HQYlhKOmapxcQMUwixOMIOPJT6aElcuV2/SY6eTT2
	7ckQxydco8v1Ur7hpT3RwJp3+BUafCXrM47RhMZN2wiuSDKoD7QRD1P6Etoj9AZNmdPi1USX4fx
	ieJyVOZyGsvQ8e4OKTF8brjTQfRuzhDgj2gjqXjYgzSR7KpbKjzYgFj/ZB+9Fzx78+PeY5ti1w5
	ETckJEm9IoLVybuuVTP5E1rA+U4HxjVLcX6vYV3D+F3PNkPWFjwQ==
X-Received: by 2002:a17:903:19cb:b0:2cc:841d:cd7e with SMTP id d9443c01a7336-2cc841dd101mr5031765ad.21.1783207154485;
        Sat, 04 Jul 2026 16:19:14 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:12 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 7/7] selftests/seccomp: cover non-cooperative pinned-memfd install
Date: Sat,  4 Jul 2026 16:18:31 -0700
Message-ID: <20260704231831.354543-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0AE84A0008
X-Stat-Signature: 4ws9xkxz63cxagqcngtdbxuknosmamrx
X-HE-Tag: 1783207156-71636
X-HE-Meta: U2FsdGVkX1/T+lKGuNv1Iw37EtseNqWn15HapOHNb/sseTY3basXvTQk+1jJPU4eU1nzEZwJNOv4U8triwQiD1CHAUWLZrrQVO0EVGDUCiPsyGojK+1OdlvvQ42qpqlKk8R/LthrCKhY0wVJW6SSqi90YuZmthuepx76JVOWO8am/qkwy968W34R72gfqpWdm1vIy2nBFMxFl00e3dz6S8bgSQ2pFk26hHi8TaESwQO7gCuKatqq6mIBJuC75VwO0VzQTzNOb90Y4ODeee1y84cG9dHFlh0+2jsMpKWMD5cBztASNirfrOmXiPvdGtgDqD94EyJ1aIyrPd43qVUTk0WG+8mkXKdgtcVRUN0L53pIxeJ/lUBM2JcPZv4p2tzmqqJdAPxDH7AK/5/D6seN0GQ6RSaWPTcKpizgWYleYY+Zde6oNdKmSFhjNgGJEZ358LCc4n5EXIoxn39+HGWcDhkIDf2rna7d59b6bpdOPLHWODv4DlODix66XMgbLtNtL1lyVPDdE67B628MOsc/Sy5rGiGMfbDSiAmfKMRcw/1jnzQ6029usn0y7yFP1mzgtK1QfG+ZBIOWAjNQgSOixGUW6eecLcvs9QroJ769wszFo1S2//8l12xk5Di+IpowQgNaJ+o4RISQsU+Y88QegjN8huKYyZFjt7pRGm2DPiP6jPyzX+Bp88wXsN6mYTcMAwKhJFUWqY2rErEgwwHDOLiKrR41uuDQLpI1mr4tEtSIfRqImX9ii8C/Add7OCHA84BncyGptuDWfCyEXqUXVCw3N5FrqOmzFQAOi3IUfzwM2UDOO59nG4mSmSFqVyOurIxokk3VhCf7Ar2pOEr1d5etOUVMzVhrZKue7z4KSL0IxT+Npg8MfF5Jn4e6jAeRNqZUxH2SDEOjVl2lAdmaFiKOtiT57Gjel49zOuDU1Jt3oNKd+RRp4ZR+iC/WteG1HZ7wrw+ONXSKU38l/uM
 MMG5dIrk
 FO27uAjGdhX+Rnn5mUyagdG/r6w4GtN6E4miS4t9xSJP8JAZVwnhHTN0Fjo0EA1ur2MWxdPSHdbrAp+/rdVJgdEIXk80nOecxkRCeAmSjXt21XteUEceAuyc1XQLt281vU/zCZ/EwlhmPn+I9g5Qi0MbDtDpxkr1wjaJXRry9N4FZrnokRABS41aCJX5V4Hf9b7yysKkJA9vP0F/bGoHZcxON1NNLvbGRBrKCiNE/xDxjwaHXk1N5yToFVINQSJ9091+aVTa10Hus4Y8jZTIANiesKYKurpZcUWIEBVA/uUz91D/3yvB7KRnSUUkxKSO1Oa+Ct8CXevMVXMv6j3GuWqbrd222s1iZP1/ZErcaza1ZXSbEJ77xQkXDWlYvS+qO7J+YHRiZA/J+C6uzTvhElRD5P04+HxNaF5f0xkzGvtjinCYIuHDOmuxDbp5/9F0t4C+H5EEXRsEcyY9C50PyfrLJ6jLfXxLgaZJX0rstB6G86MfGe3Y4W2NIdtPmHOw/XHnz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add coverage for SECCOMP_IOCTL_NOTIF_PIN_INSTALL and
SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, where the kernel installs a sealed
PROT_READ MAP_SHARED mapping of the supervisor's memfd into the trapped
task's mm via vm_mmap_remote() and the supervisor redirects a pointer
argument into it.

The tests exercise the remote install and redirect on a bare forked
child (including the unsealed-memfd and out-of-pin rejection paths), the
full fork+execve flow with a detached SCM_RIGHTS supervisor and per-mm
rebind, stateless reuse across many short-lived targets, re-validation of
a redirect against the outer filter stack, the -EOPNOTSUPP denial of
syscalls whose register substitution is unsafe (rt_sigreturn and the
clone/fork family), and the original argument-register restore ABI
(including its ordering against signal frame setup).

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1251 +++++++++++++++++
 1 file changed, 1251 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 358b6c65e120..c5d915e83955 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -217,6 +217,10 @@ struct seccomp_metadata {
 #define SECCOMP_FILTER_FLAG_NEW_LISTENER	(1UL << 3)
 #endif
 
+#ifndef SECCOMP_FILTER_FLAG_REDIRECT
+#define SECCOMP_FILTER_FLAG_REDIRECT		(1UL << 6)
+#endif
+
 #ifndef SECCOMP_RET_USER_NOTIF
 #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
 
@@ -295,6 +299,35 @@ struct seccomp_notif_addfd_big {
 #define PTRACE_EVENTMSG_SYSCALL_EXIT	2
 #endif
 
+#ifndef SECCOMP_IOCTL_NOTIF_PIN_INSTALL
+struct seccomp_notif_pin_install {
+	__u64 id;
+	__u32 flags;
+	__u32 memfd;
+	__u64 target_addr;
+	__u64 size;
+	__u64 offset;
+};
+#define SECCOMP_IOCTL_NOTIF_PIN_INSTALL	SECCOMP_IOWR(5, \
+						struct seccomp_notif_pin_install)
+#endif
+
+#ifndef SECCOMP_IOCTL_NOTIF_SEND_REDIRECT
+#define SECCOMP_REDIRECT_FLAG_CONTINUE (1UL << 0)
+#define SECCOMP_REDIRECT_ARGS 6
+struct seccomp_notif_resp_redirect {
+	__u64 id;
+	__u32 flags;
+	__u32 args_mask;
+	__u32 ptr_mask;
+	__u32 memfd;
+	__u64 args[SECCOMP_REDIRECT_ARGS];
+	__u64 ptr_len[SECCOMP_REDIRECT_ARGS];
+};
+#define SECCOMP_IOCTL_NOTIF_SEND_REDIRECT	SECCOMP_IOW(6, \
+						struct seccomp_notif_resp_redirect)
+#endif
+
 #ifndef SECCOMP_USER_NOTIF_FLAG_CONTINUE
 #define SECCOMP_USER_NOTIF_FLAG_CONTINUE 0x00000001
 #endif
@@ -4368,6 +4401,1224 @@ TEST(user_notification_addfd_rlimit)
 	close(memfd);
 }
 
+/*
+ * Create a write-sealed memfd of @size for PIN_INSTALL and map a supervisor
+ * writable view, primed with @content. F_SEAL_FUTURE_WRITE keeps this
+ * pre-seal mapping writable (so the test can still stage content) while
+ * barring any other writable reference, as PIN_INSTALL requires. Returns
+ * the memfd.
+ */
+static int make_pin_memfd(struct __test_metadata *_metadata, const char *name,
+			  size_t size, char **sup_view, const char *content)
+{
+	int memfd = memfd_create(name, MFD_ALLOW_SEALING);
+
+	ASSERT_GE(memfd, 0);
+	ASSERT_EQ(0, ftruncate(memfd, size));
+	ASSERT_EQ(0, fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK | F_SEAL_GROW));
+
+	*sup_view = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
+			 memfd, 0);
+	ASSERT_NE(MAP_FAILED, *sup_view);
+	ASSERT_EQ(0, fcntl(memfd, F_ADD_SEALS, F_SEAL_FUTURE_WRITE));
+	memcpy(*sup_view, content, strlen(content) + 1);
+	return memfd;
+}
+
+/*
+ * Non-cooperative pinned-memfd: kernel installs a sealed PROT_READ
+ * MAP_SHARED mapping of the supervisor's memfd directly into the
+ * trapped task's mm. The target runs no mmap or mseal code itself —
+ * this exercises the same kernel path that a fork+execve sandbox
+ * supervisor would use to install a pin in the new image's fresh
+ * post-exec mm.
+ *
+ * Target child does nothing but call openat() on a bait path. The
+ * supervisor catches the trap, calls PIN_INSTALL (kernel does the
+ * mmap + seal in target's mm via vm_mmap_remote()), writes a
+ * safe path into its own memfd view, and SEND_REDIRECTs args[1]
+ * into the freshly installed pin. The child's openat resumes,
+ * reads from the sealed pin, and returns an fd to the safe path.
+ */
+TEST(user_notification_pinned_memfd_remote)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd, unsealed;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_pin_install pin = {};
+	struct seccomp_notif_pin_install unsealed_pin = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	char *sup_view;
+	const size_t PIN_SIZE = 4096;
+	const char *safe_path = "/dev/null";
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	memfd = make_pin_memfd(_metadata, "pinned-remote", PIN_SIZE,
+			       &sup_view, safe_path);
+
+	listener = user_notif_syscall(__NR_openat,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int fd;
+
+		/*
+		 * Target performs no setup. Just trap on openat. Kernel
+		 * (driven by the supervisor) will install the pin in this
+		 * process's mm at a kernel-chosen address behind our back,
+		 * and our openat will be redirected to read from there.
+		 */
+		fd = syscall(__NR_openat, AT_FDCWD,
+			     "/this/should/never/be/touched", O_RDONLY, 0);
+		if (fd < 0)
+			_exit(11);
+		_exit(0);
+	}
+
+	ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(req.data.nr, __NR_openat);
+
+	pin.id = req.id;
+	pin.memfd = memfd;
+	pin.target_addr = 0;
+	pin.size = PIN_SIZE;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_PIN_INSTALL, &pin)) {
+		if (errno == EINVAL) {
+			kill(pid, SIGKILL);
+			waitpid(pid, &status, 0);
+			SKIP(goto cleanup,
+			     "Kernel does not support pinned-memfd remote install");
+		}
+		TH_LOG("PIN_INSTALL failed: errno=%d", errno);
+	}
+
+	/* The kernel wrote a non-zero, page-aligned address back to us. */
+	EXPECT_NE(0, pin.target_addr);
+	EXPECT_EQ(0, pin.target_addr & (PIN_SIZE - 1));
+
+	/* Reject: the backing memfd must be write-sealed. */
+	unsealed = memfd_create("unsealed", MFD_ALLOW_SEALING);
+	ASSERT_GE(unsealed, 0);
+	ASSERT_EQ(0, ftruncate(unsealed, PIN_SIZE));
+	unsealed_pin.id = req.id;
+	unsealed_pin.memfd = unsealed;
+	unsealed_pin.size = PIN_SIZE;
+	EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_PIN_INSTALL,
+			    &unsealed_pin));
+	EXPECT_EQ(EINVAL, errno);
+	close(unsealed);
+
+	/* Reject: redirect outside any installed pin. */
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 1;
+	redir.ptr_mask = 1U << 1;
+	redir.memfd = memfd;
+	redir.ptr_len[1] = strlen(safe_path) + 1;
+	redir.args[1] = pin.target_addr + PIN_SIZE;	/* one byte past */
+	EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+			    &redir));
+	EXPECT_EQ(EFAULT, errno);
+
+	/* Reject: base is inside the pin but the extent runs past its end. */
+	redir.args[1] = pin.target_addr;
+	redir.ptr_len[1] = PIN_SIZE + 1;
+	EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+			    &redir));
+	EXPECT_EQ(EFAULT, errno);
+
+	/* Happy path: redirect into the kernel-installed pin. */
+	redir.args[1] = pin.target_addr;
+	redir.ptr_len[1] = strlen(safe_path) + 1;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+			   &redir)) {
+		/* Unblock the trapped child so waitpid() cannot hang. */
+		kill(pid, SIGKILL);
+	}
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		TH_LOG("child exit %d (11=openat fail)", WEXITSTATUS(status));
+	}
+
+cleanup:
+	munmap(sup_view, PIN_SIZE);
+	close(memfd);
+	close(listener);
+}
+
+/*
+ * Helper for the execve test: read up to @max bytes of a NUL-terminated
+ * string from @pid's mm at @addr into @out. Returns the length read
+ * (excluding the NUL), or -1 on failure or no NUL.
+ */
+static ssize_t read_remote_string(pid_t pid, unsigned long addr,
+				  char *out, size_t max)
+{
+	struct iovec local = { .iov_base = out, .iov_len = max };
+	struct iovec remote = { .iov_base = (void *)addr, .iov_len = max };
+	ssize_t n;
+	size_t i;
+
+	n = process_vm_readv(pid, &local, 1, &remote, 1, 0);
+	if (n <= 0)
+		return -1;
+	for (i = 0; i < (size_t)n; i++)
+		if (out[i] == '\0')
+			return (ssize_t)i;
+	return -1;
+}
+
+/*
+ * Send a file descriptor over a connected UNIX socket via SCM_RIGHTS.
+ * Used by the execve_scm test so the target child can hand its
+ * SECCOMP_FILTER_FLAG_NEW_LISTENER fd to the supervising parent
+ * without the parent having to inherit the seccomp filter itself.
+ */
+static int send_fd(int sock, int fd)
+{
+	char cbuf[CMSG_SPACE(sizeof(int))] = {};
+	char data = 'x';
+	struct iovec iov = { .iov_base = &data, .iov_len = 1 };
+	struct msghdr msg = {
+		.msg_iov = &iov, .msg_iovlen = 1,
+		.msg_control = cbuf, .msg_controllen = sizeof(cbuf),
+	};
+	struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
+
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+	memcpy(CMSG_DATA(cmsg), &fd, sizeof(int));
+	return sendmsg(sock, &msg, 0) < 0 ? -1 : 0;
+}
+
+static int recv_fd(int sock)
+{
+	char cbuf[CMSG_SPACE(sizeof(int))] = {};
+	char data;
+	struct iovec iov = { .iov_base = &data, .iov_len = 1 };
+	struct msghdr msg = {
+		.msg_iov = &iov, .msg_iovlen = 1,
+		.msg_control = cbuf, .msg_controllen = sizeof(cbuf),
+	};
+	struct cmsghdr *cmsg;
+	int fd;
+
+	if (recvmsg(sock, &msg, 0) < 0)
+		return -1;
+	cmsg = CMSG_FIRSTHDR(&msg);
+	if (!cmsg || cmsg->cmsg_level != SOL_SOCKET ||
+	    cmsg->cmsg_type != SCM_RIGHTS ||
+	    cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
+		return -1;
+	memcpy(&fd, CMSG_DATA(cmsg), sizeof(int));
+	return fd;
+}
+
+struct addr_range {
+	unsigned long start, end;
+};
+
+/*
+ * Parse /proc/<pid>/maps looking for the dynamic linker's executable
+ * mapping (glibc ld-linux-*.so, musl ld-musl-*.so, etc.). The trapped
+ * task's instruction_pointer falling in this range identifies a
+ * loader-bootstrap syscall (race-free, kernel-truth) so the supervisor
+ * can auto-allow it without inspecting argument content via the racy
+ * process_vm_readv path.
+ *
+ * Requires the supervisor not to be subject to the seccomp filter
+ * itself -- fopen() internally calls openat(). The execve_scm test
+ * structure (child installs filter, sends listener fd to parent via
+ * SCM_RIGHTS) satisfies that.
+ *
+ * Returns 0 on success with @out populated, -1 if not found.
+ */
+static int find_loader_text_range(pid_t pid, struct addr_range *out)
+{
+	char maps_path[64];
+	char line[512];
+	FILE *f;
+	int found = 0;
+
+	snprintf(maps_path, sizeof(maps_path), "/proc/%d/maps", pid);
+	f = fopen(maps_path, "r");
+	if (!f)
+		return -1;
+
+	while (fgets(line, sizeof(line), f)) {
+		unsigned long start, end;
+		char perms[8];
+		char *path;
+
+		if (sscanf(line, "%lx-%lx %7s", &start, &end, perms) != 3)
+			continue;
+		if (!strchr(perms, 'x'))
+			continue;
+		path = strchr(line, '/');
+		if (!path)
+			continue;
+		/*
+		 * Match common dynamic-linker basenames: ld-linux-*.so
+		 * (glibc), ld-musl-*.so (musl), ld-*.so (older glibc).
+		 */
+		if (strstr(path, "/ld-") || strstr(path, "/ld.so")) {
+			out->start = start;
+			out->end = end;
+			found = 1;
+			break;
+		}
+	}
+	fclose(f);
+	return found ? 0 : -1;
+}
+
+/*
+ * Non-cooperative pinned-memfd across a real execve, using the proper
+ * supervisor-isolation pattern: the child (target) installs the seccomp
+ * filter on itself and sends its listener fd to the parent (supervisor)
+ * via SCM_RIGHTS over a socketpair. The parent therefore does not carry
+ * the seccomp filter and can freely call openat() -- which is what makes
+ * the race-free, kernel-truth loader detection (req.data.instruction_pointer
+ * + /proc/<pid>/maps) actually usable.
+ *
+ * Phase 1: child does a pre-execve openat; the supervisor PIN_INSTALLs and
+ * SEND_REDIRECTs. Phase 2: child execve's, so the pre-execve pin VMA dies
+ * with the old mm. Phase 3: in the fresh post-execve mm the supervisor
+ * PIN_INSTALLs again (idempotent replace of the stale bookkeeping) and
+ * SEND_REDIRECTs, proving the full redirect mechanism survives an mm
+ * replacement, not just the install side.
+ */
+TEST(user_notification_pinned_memfd_execve_scm)
+{
+	pid_t pid;
+	int status, listener, memfd, sv[2];
+	struct seccomp_notif req = {};
+	struct seccomp_notif_pin_install pin = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	struct seccomp_notif_resp cont_resp = {};
+	char *sup_view;
+	const size_t PIN_SIZE = 4096;
+	const char *safe_path = "/dev/null";
+	const char *bait = "/seccomp_pinned_memfd_test_bait_scm";
+	bool post_exec_install_ok = false;
+	bool post_exec_redirect_done = false;
+	bool loader_known = false;
+	bool loader_check_attempted = false;
+	struct addr_range loader_range = {};
+	int phase = 0;
+	int trap_count = 0;
+	const int trap_limit = 200;
+
+	if (access("/bin/cat", X_OK) != 0)
+		SKIP(return, "/bin/cat not present");
+
+	memfd = make_pin_memfd(_metadata, "pin-execve-scm", PIN_SIZE,
+			       &sup_view, safe_path);
+
+	ASSERT_EQ(0, socketpair(AF_UNIX, SOCK_SEQPACKET, 0, sv));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		struct sock_filter filter[] = {
+			BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+				 offsetof(struct seccomp_data, nr)),
+			BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_openat,
+				 0, 1),
+			BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_USER_NOTIF),
+			BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+		};
+		struct sock_fprog prog = {
+			.len = (unsigned short)ARRAY_SIZE(filter),
+			.filter = filter,
+		};
+		int my_listener;
+		int fd;
+
+		close(sv[0]);
+		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0))
+			_exit(20);
+		my_listener = seccomp(SECCOMP_SET_MODE_FILTER,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT,
+				      &prog);
+		if (my_listener < 0)
+			_exit(21);
+		if (send_fd(sv[1], my_listener) < 0)
+			_exit(22);
+		close(my_listener);
+		close(sv[1]);
+
+		/* Pre-execve trap. */
+		fd = syscall(__NR_openat, AT_FDCWD,
+			     "/this/should/never/be/touched", O_RDONLY, 0);
+		if (fd < 0)
+			_exit(11);
+
+		execl("/bin/cat", "cat", bait, (char *)NULL);
+		_exit(12);
+	}
+
+	close(sv[1]);
+	listener = recv_fd(sv[0]);
+	close(sv[0]);
+	ASSERT_GE(listener, 0);
+
+	/*
+	 * Parent has the listener fd and does NOT have the seccomp
+	 * filter. fopen(/proc/<pid>/maps) below works without
+	 * deadlocking on the parent's own openat.
+	 */
+	for (;;) {
+		struct pollfd pfd = { .fd = listener, .events = POLLIN };
+		int pret = poll(&pfd, 1, 500);
+		pid_t reaped;
+		bool ip_in_loader;
+
+		if (pret < 0)
+			break;
+		if (pret == 0 || !(pfd.revents & POLLIN)) {
+			reaped = waitpid(pid, &status, WNOHANG);
+			if (reaped == pid)
+				break;
+			if (pfd.revents & (POLLHUP | POLLERR))
+				break;
+			continue;
+		}
+
+		memset(&req, 0, sizeof(req));
+		if (ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req) < 0) {
+			TH_LOG("NOTIF_RECV failed: errno=%d", errno);
+			break;
+		}
+		if (++trap_count > trap_limit) {
+			TH_LOG("trap_limit (%d) exceeded", trap_limit);
+			break;
+		}
+
+		if (phase == 0) {
+			pin.id = req.id;
+			pin.memfd = memfd;
+			pin.target_addr = 0;
+			pin.size = PIN_SIZE;
+			if (ioctl(listener,
+				  SECCOMP_IOCTL_NOTIF_PIN_INSTALL,
+				  &pin) != 0) {
+				TH_LOG("pre-exec PIN_INSTALL failed: errno=%d",
+				       errno);
+				if (errno == EINVAL)
+					SKIP(goto cleanup_scm,
+					     "Kernel lacks pinned-memfd remote");
+				goto cleanup_scm;
+			}
+
+			memset(&redir, 0, sizeof(redir));
+			redir.id = req.id;
+			redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+			redir.args_mask = 1U << 1;
+			redir.ptr_mask = 1U << 1;
+			redir.memfd = memfd;
+			redir.ptr_len[1] = strlen(safe_path) + 1;
+			redir.args[1] = pin.target_addr;
+			if (ioctl(listener,
+				  SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+				  &redir) != 0) {
+				TH_LOG("pre-exec SEND_REDIRECT failed: errno=%d",
+				       errno);
+				goto cleanup_scm;
+			}
+			phase = 1;
+			continue;
+		}
+
+		/*
+		 * Post-execve. Lazily resolve the loader range. The
+		 * supervisor's own openat (fopen on /proc/<pid>/maps)
+		 * doesn't trap because the filter lives on the child,
+		 * not on us.
+		 */
+		if (!loader_known && !loader_check_attempted) {
+			if (find_loader_text_range(req.pid,
+						   &loader_range) == 0)
+				loader_known = true;
+			loader_check_attempted = true;
+		}
+
+		ip_in_loader = loader_known &&
+			req.data.instruction_pointer >= loader_range.start &&
+			req.data.instruction_pointer <  loader_range.end;
+
+		if (ip_in_loader) {
+			memset(&cont_resp, 0, sizeof(cont_resp));
+			cont_resp.id = req.id;
+			cont_resp.flags = SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+			ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &cont_resp);
+			continue;
+		}
+
+		/* Program code: inspect the path to identify the bait. */
+		{
+			char path[PATH_MAX];
+			ssize_t n;
+
+			n = read_remote_string(req.pid, req.data.args[1],
+					       path, sizeof(path));
+			if (n < 0 || strcmp(path, bait) != 0) {
+				memset(&cont_resp, 0, sizeof(cont_resp));
+				cont_resp.id = req.id;
+				cont_resp.flags =
+					SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+				ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND,
+				      &cont_resp);
+				continue;
+			}
+
+			pin.id = req.id;
+			pin.memfd = memfd;
+			pin.target_addr = 0;
+			pin.size = PIN_SIZE;
+			if (ioctl(listener,
+				  SECCOMP_IOCTL_NOTIF_PIN_INSTALL,
+				  &pin) == 0) {
+				post_exec_install_ok = true;
+			} else {
+				TH_LOG("post-exec PIN_INSTALL failed: errno=%d",
+				       errno);
+				memset(&cont_resp, 0, sizeof(cont_resp));
+				cont_resp.id = req.id;
+				cont_resp.flags =
+					SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+				ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND,
+				      &cont_resp);
+				continue;
+			}
+
+			memset(&redir, 0, sizeof(redir));
+			redir.id = req.id;
+			redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+			redir.args_mask = 1U << 1;
+			redir.ptr_mask = 1U << 1;
+			redir.memfd = memfd;
+			redir.ptr_len[1] = strlen(safe_path) + 1;
+			redir.args[1] = pin.target_addr;
+			if (ioctl(listener,
+				  SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+				  &redir) == 0) {
+				post_exec_redirect_done = true;
+			} else {
+				TH_LOG("post-exec SEND_REDIRECT failed: errno=%d",
+				       errno);
+				memset(&cont_resp, 0, sizeof(cont_resp));
+				cont_resp.id = req.id;
+				cont_resp.flags =
+					SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+				ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND,
+				      &cont_resp);
+			}
+		}
+	}
+
+	if (waitpid(pid, &status, WNOHANG) == 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+	}
+	EXPECT_EQ(true, loader_known) {
+		TH_LOG("find_loader_text_range never resolved");
+	}
+	EXPECT_EQ(true, post_exec_install_ok);
+	EXPECT_EQ(true, post_exec_redirect_done);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+cleanup_scm:
+	if (waitpid(pid, &status, WNOHANG) == 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+	}
+	munmap(sup_view, PIN_SIZE);
+	close(memfd);
+	close(listener);
+}
+
+/*
+ * Stateless redirect validation must hold up across many short-lived
+ * targets over one listener, and must not accumulate per-target state.
+ *
+ * PIN_INSTALL records nothing: the installed VM_SEALED VMA is the only
+ * record, and SEND_REDIRECT re-validates the pointer against the live
+ * mapping (sealed, read-only, backed by the supervisor's memfd inode).
+ * So a supervisor servicing a long churn of targets keeps working with
+ * no bookkeeping to leak. Each iteration lets the kernel choose the pin
+ * address in the fresh target mm; every install/redirect must succeed, and
+ * kmemleak/KASAN over the loop confirms nothing accumulates.
+ */
+TEST(user_notification_pinned_memfd_churn)
+{
+	const size_t PIN_SIZE = 4096;
+	const char *safe_path = "/dev/null";
+	const int iters = 16;
+	int listener, memfd, i;
+	char *sup_view;
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	memfd = make_pin_memfd(_metadata, "pinned-reap", PIN_SIZE,
+			       &sup_view, safe_path);
+
+	listener = user_notif_syscall(__NR_openat,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	for (i = 0; i < iters; i++) {
+		struct seccomp_notif req = {};
+		struct seccomp_notif_pin_install pin = {};
+		struct seccomp_notif_resp_redirect redir = {};
+		int status;
+		pid_t pid;
+
+		pid = fork();
+		ASSERT_GE(pid, 0);
+		if (pid == 0) {
+			int fd = syscall(__NR_openat, AT_FDCWD,
+					 "/never/touched", O_RDONLY, 0);
+			_exit(fd < 0 ? 11 : 0);
+		}
+
+		ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+		EXPECT_EQ(req.data.nr, __NR_openat);
+
+		pin.id = req.id;
+		pin.memfd = memfd;
+		pin.target_addr = 0;
+		pin.size = PIN_SIZE;
+		EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_PIN_INSTALL,
+				   &pin)) {
+			if (errno == EINVAL) {
+				kill(pid, SIGKILL);
+				waitpid(pid, &status, 0);
+				SKIP(goto cleanup,
+				     "Kernel lacks pinned-memfd remote install");
+			}
+			TH_LOG("iter %d PIN_INSTALL failed: errno=%d", i, errno);
+		}
+
+		redir.id = req.id;
+		redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+		redir.args_mask = 1U << 1;
+		redir.ptr_mask = 1U << 1;
+		redir.memfd = memfd;
+		redir.ptr_len[1] = strlen(safe_path) + 1;
+		redir.args[1] = pin.target_addr;
+		EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+				   &redir)) {
+			kill(pid, SIGKILL);
+		}
+
+		EXPECT_EQ(waitpid(pid, &status, 0), pid);
+		EXPECT_EQ(true, WIFEXITED(status));
+		EXPECT_EQ(0, WEXITSTATUS(status)) {
+			TH_LOG("iter %d child exit %d (11=openat fail)",
+			       i, WEXITSTATUS(status));
+		}
+		/*
+		 * Target is dead now; its pin (this iter's mm, at the
+		 * kernel-chosen address) is stale. The next iteration's
+		 * PIN_INSTALL walk must reap it rather than leak the range +
+		 * mm + memfd reference.
+		 */
+	}
+
+cleanup:
+	munmap(sup_view, PIN_SIZE);
+	close(memfd);
+	close(listener);
+}
+
+#ifdef __NR_socket
+/*
+ * A redirect must not let an inner (more recently installed) filter's
+ * notifier smuggle a syscall past an outer filter. Two filters are
+ * stacked on the target:
+ *
+ *   outer (installed first):  socket(AF_INET, ...) -> RET_ERRNO(EACCES),
+ *                             everything else ALLOW.
+ *   inner (installed second): socket -> RET_USER_NOTIF.
+ *
+ * The child calls socket(AF_UNIX, ...), which the outer filter allows, so
+ * the inner notifier wins and fires. The supervisor SEND_REDIRECTs arg0
+ * to AF_INET. The kernel must then re-run the outer filter against the
+ * rewritten registers and block it with EACCES; without the outer-suffix
+ * re-validation the inner filter would have bypassed the outer policy.
+ */
+TEST(user_notification_redirect_outer_refilter)
+{
+	struct sock_filter outer_filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_socket, 0, 3),
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS, syscall_arg(0)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K,
+			 SECCOMP_RET_ERRNO | (EACCES & SECCOMP_RET_DATA)),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog outer_prog = {
+		.len = (unsigned short)ARRAY_SIZE(outer_filter),
+		.filter = outer_filter,
+	};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	int status, listener;
+	pid_t pid;
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Outer filter first => it becomes the outer/root of the stack. */
+	ASSERT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0, &outer_prog));
+
+	/* Inner USER_NOTIF filter second (innermost); returns the listener. */
+	listener = user_notif_syscall(__NR_socket,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int fd = syscall(__NR_socket, AF_UNIX, SOCK_STREAM, 0);
+
+		if (fd >= 0)
+			_exit(12);
+		if (errno != EACCES)
+			_exit(13);
+		_exit(0);
+	}
+
+	ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(req.data.nr, __NR_socket);
+	EXPECT_EQ(req.data.args[0], AF_UNIX);
+
+	/* Scalar redirect of arg0 (no pin needed): AF_UNIX -> AF_INET. */
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 0;
+	redir.args[0] = AF_INET;
+	ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, &redir);
+	if (ret < 0 && errno == EINVAL) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		close(listener);
+		SKIP(return, "Kernel lacks SECCOMP_IOCTL_NOTIF_SEND_REDIRECT");
+	}
+	EXPECT_EQ(0, ret);
+	if (ret)
+		kill(pid, SIGKILL);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 12:
+			TH_LOG("child exit 12: redirect bypassed the outer filter");
+			break;
+		case 13:
+			TH_LOG("child exit 13: socket failed with unexpected errno");
+			break;
+		default:
+			TH_LOG("child exit %d (unexpected)", WEXITSTATUS(status));
+		}
+	}
+
+	close(listener);
+}
+#endif /* __NR_socket */
+
+/*
+ * SEND_REDIRECT refuses syscalls whose register substitution would be unsafe
+ * and returns -EOPNOTSUPP: sigreturn (its frame restore fights the redirect
+ * restore) and the clone/fork family (a new child inherits the substituted
+ * registers with no restore). The trapped call is then answered with a plain
+ * error, so it never actually runs.
+ *
+ * The target installs the filter and hands the listener to the supervisor over
+ * a socketpair: a filter that traps fork/clone cannot be installed before the
+ * supervisor itself forks the target.
+ */
+TEST(user_notification_redirect_denied_syscalls)
+{
+	static const int denied[] = {
+		__NR_rt_sigreturn,
+		__NR_clone,
+		__NR_clone3,
+#ifdef __NR_fork
+		__NR_fork,
+#endif
+#ifdef __NR_vfork
+		__NR_vfork,
+#endif
+	};
+	unsigned int i;
+	long ret;
+
+	for (i = 0; i < ARRAY_SIZE(denied); i++) {
+		struct seccomp_notif req = {};
+		struct seccomp_notif_resp resp = {};
+		struct seccomp_notif_resp_redirect redir = {};
+		int sk[2], listener, status;
+		pid_t pid;
+
+		if (denied[i] < 0)
+			continue;
+
+		ASSERT_EQ(0, socketpair(AF_UNIX, SOCK_STREAM, 0, sk));
+
+		pid = fork();
+		ASSERT_GE(pid, 0);
+		if (pid == 0) {
+			close(sk[0]);
+			if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0))
+				_exit(1);
+			listener = user_notif_syscall(
+					denied[i],
+					SECCOMP_FILTER_FLAG_NEW_LISTENER |
+					SECCOMP_FILTER_FLAG_REDIRECT);
+			if (listener < 0)
+				_exit(2);
+			if (send_fd(sk[1], listener))
+				_exit(3);
+			syscall(denied[i], 0, 0, 0, 0, 0, 0);
+			_exit(0);
+		}
+
+		close(sk[1]);
+		listener = recv_fd(sk[0]);
+		if (listener < 0) {
+			waitpid(pid, &status, 0);
+			close(sk[0]);
+			SKIP(return, "SECCOMP_FILTER_FLAG_REDIRECT unsupported");
+		}
+
+		ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+		EXPECT_EQ(req.data.nr, denied[i]);
+
+		redir.id = req.id;
+		redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+		redir.args_mask = 1U << 0;
+		redir.args[0] = 0;
+		errno = 0;
+		ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, &redir);
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EOPNOTSUPP, errno) {
+			TH_LOG("nr %d: SEND_REDIRECT errno %d, want EOPNOTSUPP",
+			       denied[i], errno);
+		}
+
+		resp.id = req.id;
+		resp.error = -EPERM;
+		EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp));
+
+		EXPECT_EQ(waitpid(pid, &status, 0), pid);
+		EXPECT_EQ(true, WIFEXITED(status));
+		EXPECT_EQ(0, WEXITSTATUS(status)) {
+			TH_LOG("nr %d: child exit %d", denied[i],
+			       WEXITSTATUS(status));
+		}
+		close(listener);
+		close(sk[0]);
+	}
+}
+
+#ifdef __NR_socket
+/*
+ * Re-validation walks *every* filter outer to the notifier, not just the
+ * nearest. Stack (outer -> inner):
+ *
+ *   outer  (1st): socket(AF_INET) -> RET_ERRNO(EACCES), else ALLOW
+ *   middle (2nd): ALLOW everything
+ *   inner  (3rd): socket -> RET_USER_NOTIF (the redirector)
+ *
+ * The target calls socket(AF_UNIX); the inner notifier fires and the
+ * supervisor SEND_REDIRECTs arg0 to AF_INET. The outward walk must pass
+ * through the permissive middle filter and still reach the outer filter,
+ * which blocks the substituted call with EACCES. If the walk stopped at the
+ * first outer filter (middle, ALLOW), the redirect would slip past the outer
+ * policy. This exercises the iterative multi-filter walk that the single-outer
+ * outer_refilter test does not.
+ */
+TEST(user_notification_redirect_revalidate_chain)
+{
+	struct sock_filter outer_filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_socket, 0, 3),
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS, syscall_arg(0)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K,
+			 SECCOMP_RET_ERRNO | (EACCES & SECCOMP_RET_DATA)),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog outer_prog = {
+		.len = (unsigned short)ARRAY_SIZE(outer_filter),
+		.filter = outer_filter,
+	};
+	struct sock_filter allow_filter[] = {
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog allow_prog = {
+		.len = (unsigned short)ARRAY_SIZE(allow_filter),
+		.filter = allow_filter,
+	};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	int status, listener;
+	pid_t pid;
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* outer (root) -> middle (permissive) -> inner (notifier). */
+	ASSERT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0, &outer_prog));
+	ASSERT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0, &allow_prog));
+	listener = user_notif_syscall(__NR_socket,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int fd = syscall(__NR_socket, AF_UNIX, SOCK_STREAM, 0);
+
+		if (fd >= 0)
+			_exit(12);
+		if (errno != EACCES)
+			_exit(13);
+		_exit(0);
+	}
+
+	ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(req.data.nr, __NR_socket);
+	EXPECT_EQ(req.data.args[0], AF_UNIX);
+
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 0;
+	redir.args[0] = AF_INET;
+	ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, &redir);
+	if (ret < 0 && errno == EINVAL) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		close(listener);
+		SKIP(return, "Kernel lacks SECCOMP_IOCTL_NOTIF_SEND_REDIRECT");
+	}
+	EXPECT_EQ(0, ret);
+	if (ret)
+		kill(pid, SIGKILL);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 12:
+			TH_LOG("exit 12: walk stopped at middle; outer bypassed");
+			break;
+		case 13:
+			TH_LOG("exit 13: socket failed with unexpected errno");
+			break;
+		default:
+			TH_LOG("child exit %d (unexpected)", WEXITSTATUS(status));
+		}
+	}
+
+	close(listener);
+}
+#endif /* __NR_socket */
+
+#ifdef __x86_64__
+/*
+ * Load-bearing ABI check: after SEND_REDIRECT, the trapped task's
+ * redirected arg register must be restored to its original value
+ * before user-mode code resumes. The kernel's restore mechanism
+ * (task_work_add(TWA_RESUME) -> seccomp_redirect_restore_cb) is
+ * what guarantees this; without a test the property is just an
+ * assertion. Bypass libc's syscall() wrapper (which caller-saves
+ * arg values and would mask a restore bug) and capture the actual
+ * arg register immediately after the SYSCALL instruction.
+ *
+ * The child issues openat with RSI = sentinel_path. The supervisor
+ * SEND_REDIRECTs args[1] (RSI) to point into the pin. The kernel:
+ *   - saves the original RSI into the knotif
+ *   - writes the pin address into RSI via syscall_set_arguments()
+ *   - runs the syscall (kernel reads path from the pin)
+ *   - on syscall_exit_to_user_mode, fires task_work which calls
+ *     syscall_set_arguments() again with the saved original
+ *   - returns to user mode
+ *
+ * If task_work fires correctly, the child observes RSI == sentinel.
+ * If broken, RSI holds the pin address (the redirected value the
+ * kernel left in pt_regs).
+ */
+TEST(user_notification_pinned_memfd_abi)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_pin_install pin = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	char *sup_view;
+	const size_t PIN_SIZE = 4096;
+	const char *safe_path = "/dev/null";
+	/*
+	 * The "sentinel" is a real string the child can also pass as
+	 * the openat path. Its address is captured pre-syscall as RSI;
+	 * post-syscall RSI must equal the same address.
+	 */
+	static const char sentinel_path[] = "/seccomp_abi_sentinel";
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	memfd = make_pin_memfd(_metadata, "pin-abi", PIN_SIZE,
+			       &sup_view, safe_path);
+
+	listener = user_notif_syscall(__NR_openat,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		register long r10_val asm("r10") = 0;
+		unsigned long rsi_after;
+		long fd;
+
+		asm volatile(
+			"syscall\n\t"
+			"mov %%rsi, %[after]"
+			: "=a"(fd), [after] "=&r"(rsi_after)
+			: "0"((long)__NR_openat),
+			  "D"((long)AT_FDCWD),
+			  "S"((unsigned long)sentinel_path),
+			  "d"((long)O_RDONLY),
+			  "r"(r10_val)
+			: "rcx", "r11", "memory"
+		);
+
+		if (fd < 0)
+			_exit(11);
+		/*
+		 * Load-bearing check: RSI immediately post-SYSCALL must
+		 * still be the sentinel pointer the child passed in. The
+		 * kernel's REDIRECT-then-restore mechanism is the only
+		 * thing that guarantees this; a broken restore would leave
+		 * the pin address in RSI.
+		 */
+		if (rsi_after != (unsigned long)sentinel_path)
+			_exit(12);
+		_exit(0);
+	}
+
+	ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(req.data.nr, __NR_openat);
+	EXPECT_EQ(req.data.args[1], (unsigned long)sentinel_path);
+
+	pin.id = req.id;
+	pin.memfd = memfd;
+	pin.target_addr = 0;
+	pin.size = PIN_SIZE;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_PIN_INSTALL, &pin)) {
+		if (errno == EINVAL) {
+			kill(pid, SIGKILL);
+			waitpid(pid, &status, 0);
+			SKIP(goto cleanup,
+			     "Kernel lacks pinned-memfd remote install");
+		}
+	}
+
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 1;
+	redir.ptr_mask = 1U << 1;
+	redir.memfd = memfd;
+	redir.ptr_len[1] = strlen(safe_path) + 1;
+	redir.args[1] = pin.target_addr;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+			   &redir)) {
+		kill(pid, SIGKILL);
+	}
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 11:
+			TH_LOG("child exit 11: openat returned -errno");
+			break;
+		case 12:
+			TH_LOG("child exit 12: ABI violation -- RSI not restored after redirect");
+			break;
+		default:
+			TH_LOG("child exit %d (unexpected)", WEXITSTATUS(status));
+		}
+	}
+
+cleanup:
+	munmap(sup_view, PIN_SIZE);
+	close(memfd);
+	close(listener);
+}
+
+static void redir_sigusr1_handler(int signo)
+{
+	/* _exit() is async-signal-safe; bail with a distinct code if the
+	 * signal frame was clobbered so the handler sees the wrong signo.
+	 */
+	if (signo != SIGUSR1)
+		_exit(12);
+}
+
+/*
+ * Regression test: a redirect's deferred arg-register restore must run
+ * before a signal frame is built, not after.
+ *
+ * The restore is queued as a TWA_RESUME task_work. get_signal() runs
+ * task_work_run() before it dequeues a signal, so the restore executes
+ * before handle_signal() builds the handler frame (regs->di = signo,
+ * regs->si = &siginfo, regs->dx = &ucontext): the trapped syscall's
+ * original argument values are back in pt_regs first and never clobber
+ * the frame. A broken restore that instead ran after the frame was
+ * built would overwrite those registers and enter the handler with a
+ * corrupted signal number.
+ *
+ * The child traps on pause(), the supervisor redirects arg0 (RDI), and
+ * then interrupts it with SIGUSR1. The handler must observe
+ * signo == SIGUSR1, not the leaked original RDI sentinel.
+ */
+TEST(user_notification_redirect_signal_abi)
+{
+	pid_t pid;
+	long ret;
+	int status, listener;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	/* A recognizable original RDI the broken restore would leak in. */
+	const unsigned long RDI_SENTINEL = 0x5a5a5a5aUL;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	listener = user_notif_syscall(__NR_pause,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		struct sigaction sa = {
+			.sa_handler = redir_sigusr1_handler,
+		};
+		long rc;
+
+		if (sigaction(SIGUSR1, &sa, NULL))
+			_exit(10);
+
+		/* Raw pause() carrying a controlled RDI sentinel. */
+		asm volatile(
+			"syscall"
+			: "=a"(rc)
+			: "0"((long)__NR_pause),
+			  "D"(RDI_SENTINEL)
+			: "rcx", "r11", "memory");
+
+		if (rc != -EINTR)
+			_exit(11);
+		_exit(0);
+	}
+
+	ASSERT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(req.data.nr, __NR_pause);
+	EXPECT_EQ(req.data.args[0], RDI_SENTINEL);
+
+	/* Redirect arg0 (non-pointer); this arms the original-RDI restore. */
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 0;
+	redir.args[0] = 0;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT,
+			   &redir)) {
+		int einval = (errno == EINVAL);
+
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		if (einval)
+			SKIP(goto cleanup,
+			     "Kernel lacks SECCOMP_IOCTL_NOTIF_SEND_REDIRECT");
+		goto cleanup;
+	}
+
+	usleep(100000);
+	EXPECT_EQ(0, kill(pid, SIGUSR1));
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 10:
+			TH_LOG("child exit 10: sigaction failed");
+			break;
+		case 11:
+			TH_LOG("child exit 11: pause() did not return -EINTR");
+			break;
+		case 12:
+			TH_LOG("child exit 12: handler saw wrong signo (frame clobbered)");
+			break;
+		default:
+			TH_LOG("child exit %d (unexpected)", WEXITSTATUS(status));
+		}
+	}
+
+cleanup:
+	close(listener);
+}
+#endif /* __x86_64__ */
+
 #ifndef SECCOMP_USER_NOTIF_FD_SYNC_WAKE_UP
 #define SECCOMP_USER_NOTIF_FD_SYNC_WAKE_UP (1UL << 0)
 #define SECCOMP_IOCTL_NOTIF_SET_FLAGS  SECCOMP_IOW(4, __u64)
-- 
2.43.0


