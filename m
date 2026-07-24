Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDC1C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CF26B009E; Fri, 24 Jul 2026 18:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66ABF6B009F; Fri, 24 Jul 2026 18:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447FA6B00A0; Fri, 24 Jul 2026 18:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092336B009E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C7A91401A8
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:37 +0000 (UTC)
X-FDA: 85025045154.15.E92D295
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 94E0240007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TaBA2uhS;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKyxT8v03tfemxpC4Cf8boPeiHU+d+LC0S9/PzgfnXI=;
	b=xl7YU0RtiCqs6gHEc6XxchuoHSQL8xo4TZANiIzRvuy6fo7O+2ubJa0VTfTfRO1v3q4HDK
	Z1uXCrkCWef+hJtL1EdQiHFUkmZK0cO2ieH0Vzrl0Er+ewP13176hOHfbymJQ4hHgdGvPk
	gTirtcEuT0vaFup4ic3RxVxen6QSjZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930555;
	b=37GSseoJgmPLoSqfGi6OmRcBWgpJx35mlZsVOhVc9PKWnZeOvL21KiwuBFpkpFZCYCws8W
	HkfVlx0yeKHbNj3Aavtxgz4v6b/292CKSA/xjlHWtnFMEMUcsPUaweT4jx/1O5gWrmc5zl
	nsRQwvp7P3ZGLNY3rkhEl79UDdBGQhM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TaBA2uhS;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so683360a12.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930554; x=1785535354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FKyxT8v03tfemxpC4Cf8boPeiHU+d+LC0S9/PzgfnXI=;
        b=TaBA2uhSsofPAhiSOgG5/bx8JbsF4GtjablHW3WMR2hYp5QwrlBUfqp1hNaIfH5DN8
         KjG7VvPY/4B9J+K944DLYvPzXDUVYl0wh1acVgSC4qj6YfbXpgC1TucyxmN5JulPMQ98
         CpT5c3Y2almNFsf/q4U0IFYMZj2PC4yxocl7dDXTiIBLW8MjLvwe3e3ipxmzqvAAE4HF
         6ZXU1UvCdZHMZoIcXI8CJFfQZfMP3Knm0Jum5qSseEDpAAvWRACNRXQCPfeX1VSbd+6J
         oZ1DgmaYwbAdf6C/lh8a1SJkjC9uhTCa+elqEUGD1VBybL6dCP8MsQ32jhkWQX5hZOZw
         rn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930554; x=1785535354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FKyxT8v03tfemxpC4Cf8boPeiHU+d+LC0S9/PzgfnXI=;
        b=hasZBEVayRJoxym6G1CUvSdG0poglGdRLQs1wxf9ojRBX2e9Lc1vNGugdrw1d+2Qbn
         pdsEWKQjYENWZCp2h0rWkwOzl47EkGypJoeI8wsT/Kc3i/HF1XTyFpbCF3pI43Hh2Mm8
         +pIWYaSLaYWPKDEb/f4YfBbZCwG3ACbzFp7auR8iQNUt5NMnX+myLoaJYsiq8IXCMYfX
         I5UQPomCpg9QC5XETbGIsoWDLSXCKyVXbHuATQOVnL1UmFGsbIW4Zb+suItMK/pqtNWS
         4SANQjqLvt8xCKFJL59InfSNRI+wEVysJN8IUOvlSrlrV1BjwIjIxTl4Sh6IlxGDXjiB
         S3iw==
X-Forwarded-Encrypted: i=1; AHgh+Rpmr184NIDQgIQ3jtci3cyr+D7pLCogczjka4bwj2xOOVTWQHBur4qaysKRThw7+PqUlwzXyJEt+g==@kvack.org
X-Gm-Message-State: AOJu0YzuQbp3Us/4FGiJpEyYxVK85IJ0DhHC6xCL2J5KBDLvgg1QzZ2i
	5g5+539XMnHsmA+0kH+o8FRf2YqsbbhuDnlTH0sFURzmqLDL8KWmgqFO
X-Gm-Gg: AR+sD13gXJ0AHjO99LjmNADm9aSpjlxgNEZgs+bQFUhcX8XDSDuH47jF8iGyYfsed9t
	M0iUvbypVc9ZwRLIIuasjJMn11XQ66cE7VfuSxizfTAxXO2TVLPUSjBgqM48lEzWtDWgP5ySJAK
	bAzFMpFoLa14RCqAQVOEWJNm4hxJDequIdUyw8ndf683JeLMW4jAAJ1yrlZlTtTcSfth3qyKCea
	jx6sZVUc8xbQcLwtIkiL11SmZ2WA4NRn6mk068gSOdWgQXYw+m5AjHVSbTjpcgdUrKz+oSaeAyF
	IQV5DDrc8DgQinAOCE3z6I5QKF1ueYXp98iTV7lMZTZtT3wqKvMWLa/Mmi7bDK3zX+Y0QSUhHdI
	uu3pTSyNfwLCBn7AH1V+n+oYKUrhXnkx57qZU6YySLXRPqm4io/KmPDyvy2zlsegcEi/ibONNhP
	YJFmKaIwgLeHQlR21hVbXu1O7gnn5TlzvqVjimV0841O8D1TsXWxOAwtPH2Sej
X-Received: by 2002:a05:6a20:4323:b0:3c0:9c19:65b1 with SMTP id adf61e73a8af0-3c67e1780bemr109759637.73.1784930553882;
        Fri, 24 Jul 2026 15:02:33 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:32 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 8/8] selftests/seccomp: cover non-cooperative pinned-memfd install
Date: Fri, 24 Jul 2026 15:01:47 -0700
Message-ID: <20260724220147.214396-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94E0240007
X-Stat-Signature: m7rk33ek4nkjq4da5kt5ch8bhbqbfhqe
X-HE-Tag: 1784930555-892927
X-HE-Meta: U2FsdGVkX19Lfncot2MiJ5SUkbbx5VjonB14Fc721STABREwLTWULQYxxeuEy6P/gvCRXVFzdGjGz7yd5GH1Dzx8o6APHyMQRaJ6VsnZNE53vS/s0plvIOX5Q9FbgyzJ+TU+jzqOJZUbZ5HaUdIzoWRlG865U5w1+v8Jj3OaBt4g91zF3XxT8JPx03acIEBcPZTL5HzxxD/ERms2UTcm31C8p2/ocHEV0Ix1zNleX7B3YcwBsSMg0r1ovlWgudHx0Ad9XypjKrAnR8umqDVGKkKEKNLAOlYXsmLVEsYuhd+0do/nt8BttpOPMg5BN5dZPXb1KSkjrItoIKShVfz73ZL2AtpXcJ2zVZYECUaX0hp/BYypbUoITaqyXbqzUyDlReHVD6JEtQjG76FUBpcPsCZkdU8Kg57URNkLek72IpeQILzxEyRvUkOmPAImOwrarH+stC8TVKdOV1Rfp2TT/52ZOixI9VOARrdtA1yfRURrfn6mbJmhKoUCC9hNtoijg44AKXiNjZAquirKCREwhewufklmvsLGjHo0swLySIXv1l1k9/sKnfh/7A3jqQdtnkHDiPWpEqyrcjS59aUxqLTyRvC1+k5IASoRBk+KDqOM4DeHs5symOHgCKYSfO83vAVjNE2MLhj7CvOHj2mQRz8np4CcgUNCIjbn+3oXhEs+S2wrn8KrYY4PtzXPNHVflivoNPMHIoh26ca55o+BEs0N3A4BPZnOyPMPdkDbJATaa2VS/RNd+xRjRHygymgOL5mhg9Z9ZtNwLN4NUogIQNN91nreQ2DTo8RplDmGxQiEcEZENagkUU5orDvsB91i/7RFJnm5EpSSQRz2Ca5dackGn7nhybBvOf8L5PFlR9y1L4YMnLeDt/la/uvwMtMxcDn7WIEDh9IHnQzddgs1T/7NeGPNxUegeh9oX6CHQPYRrkXCbXr5j+z2fw5sZsUr8H/1ERADTBpRUCal9rv
 KB7MVghu
 CYz3ZxHc3UK1MGuHLw3WrDeGaAtMocOe3MoJCs0QdyGCkqdFUxrCls4Bxk0990qkGhKDYp5Q3qohySNj7wrR3OwPsxohaKIFaYgKgdgzGpbWVidyukpz9tiIwd5KaOFL6wwGgIUghoXyLEubaDjAWpj9ZAUWIwh3HbB0pRt4jZL1V6pJCgrm5Ly+YZqBuuM/Lx3qI7tCx09GIkKH66FMR/nouAI3CdLLyWaZD6RfvGthVi2n963gtJ4ho6mnJCqlMB73U+8Gjt7tYQCiwJgZuoPwWgLVfvaRW6ZM4LvrMhhwlEj9kHMTz3oqPijvAMUu8gI4mA8K4+gukuLaQYlwILMxP/snld/8QvCRzvictpEn0zuA5j04NUcYMgCxPbBoCpJoxITcYRCHJW9YVMydnj7ggN4PtXWFhO65M23vfvxgdlQQEgGz3ix3b5JWk0bW5kv+CwpuXdZOUYm9s26D7ro/nV74SnCsTjntw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add 11 tests for SECCOMP_IOCTL_NOTIF_PIN_INSTALL and
SECCOMP_IOCTL_NOTIF_SEND_REDIRECT:

  - pinned_memfd_remote: basic install + redirect, plus the unsealed
    memfd and out-of-pin rejection paths
  - pinned_memfd_target_cannot_unmap: the sealed pin survives the
    target's munmap/mprotect/mremap/MAP_FIXED attacks (all EPERM)
  - pinned_memfd_execve_scm: SCM_RIGHTS supervisor handoff and re-pin
    in the fresh post-execve mm
  - pinned_memfd_churn: one listener serves many short-lived targets,
    no per-target state
  - redirect_outer_refilter, redirect_revalidate_chain: a redirect is
    re-validated by every outer filter, not just the nearest
  - redirect_outer_trace, redirect_outer_notify: outer TRACE and
    USER_NOTIF verdicts over a redirected call fail closed with ENOSYS;
    the tracer must not get a PTRACE_EVENT_SECCOMP for the substituted
    call, and a listener-less outer USER_NOTIF must still block it
  - redirect_denied_syscalls: EOPNOTSUPP for rt_sigreturn and the
    clone/fork family
  - pinned_memfd_abi, redirect_signal_abi: the original arg register is
    restored before returning to user mode, and before any signal frame
    is built

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1569 +++++++++++++++++
 1 file changed, 1569 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 358b6c65e120..6122dc58f897 100644
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
@@ -4368,6 +4401,1542 @@ TEST(user_notification_addfd_rlimit)
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
+ * Non-cooperative pinned-memfd: the target only traps on openat(); the
+ * supervisor PIN_INSTALLs a sealed mapping of its memfd into the target mm and
+ * SEND_REDIRECTs args[1] into it, so the openat reads the supervisor's path.
+ * Also covers the unsealed-memfd and out-of-pin rejections.
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(goto cleanup, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+ * The pin is VM_SEALED: a target that learns its address can read it but must
+ * not unmap, move, reprotect or MAP_FIXED-stomp it. That is what keeps a
+ * redirected pointer aimed at supervisor-controlled bytes for the whole call.
+ */
+TEST(user_notification_pinned_memfd_target_cannot_unmap)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_pin_install pin = {};
+	struct seccomp_notif_resp_redirect redir = {};
+	char *sup_view;
+	int addrpipe[2];
+	const size_t PIN_SIZE = 4096;
+	const char *safe_path = "/dev/null";
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ASSERT_EQ(0, pipe(addrpipe));
+
+	/*
+	 * The parent writes the pin address to the child through addrpipe.
+	 * If the child has already exited (e.g. a failed redirect), that
+	 * write must fail cleanly rather than kill the parent with SIGPIPE.
+	 */
+	signal(SIGPIPE, SIG_IGN);
+
+	memfd = make_pin_memfd(_metadata, "pin-nounmap", PIN_SIZE,
+			       &sup_view, safe_path);
+
+	listener = user_notif_syscall(__NR_openat,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER |
+				      SECCOMP_FILTER_FLAG_REDIRECT);
+	if (listener < 0 && errno == EINVAL)
+		SKIP(goto cleanup, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		unsigned long pin_addr;
+		char *p;
+		int fd;
+
+		close(addrpipe[1]);
+
+		/* Trap; the supervisor installs+seals the pin and redirects. */
+		fd = syscall(__NR_openat, AT_FDCWD,
+			     "/this/should/never/be/touched", O_RDONLY, 0);
+		if (fd < 0)
+			_exit(11);
+
+		/* Learn where the kernel installed the pin. */
+		if (read(addrpipe[0], &pin_addr, sizeof(pin_addr)) !=
+		    sizeof(pin_addr))
+			_exit(12);
+		p = (char *)pin_addr;
+
+		/* Mapped and readable: it holds the redirected path. */
+		if (*p != '/')
+			_exit(13);
+
+		/* Sealed: unmap must fail and tear nothing down. */
+		if (munmap((void *)pin_addr, PIN_SIZE) == 0)
+			_exit(20);
+		if (errno != EPERM)
+			_exit(21);
+
+		/* Sealed: cannot reprotect it (even to PROT_NONE). */
+		if (mprotect((void *)pin_addr, PIN_SIZE, PROT_NONE) == 0)
+			_exit(22);
+		if (errno != EPERM)
+			_exit(23);
+
+		/* Sealed: cannot move or resize it. */
+		if (mremap((void *)pin_addr, PIN_SIZE, PIN_SIZE * 2,
+			   MREMAP_MAYMOVE) != MAP_FAILED)
+			_exit(24);
+		if (errno != EPERM)
+			_exit(25);
+
+		/* Sealed: cannot be replaced by a MAP_FIXED mapping. */
+		if (mmap((void *)pin_addr, PIN_SIZE, PROT_READ,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) !=
+		    MAP_FAILED)
+			_exit(26);
+		if (errno != EPERM)
+			_exit(27);
+
+		/* Survived every attack, still mapped and readable. */
+		if (*p != '/')
+			_exit(28);
+		_exit(0);
+	}
+
+	close(addrpipe[0]);
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
+	redir.id = req.id;
+	redir.flags = SECCOMP_REDIRECT_FLAG_CONTINUE;
+	redir.args_mask = 1U << 1;
+	redir.ptr_mask = 1U << 1;
+	redir.memfd = memfd;
+	redir.ptr_len[1] = strlen(safe_path) + 1;
+	redir.args[1] = pin.target_addr;
+	EXPECT_EQ(0, ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, &redir)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		goto cleanup;
+	}
+
+	/* Hand the target the pin address so it can try to attack it. */
+	EXPECT_EQ(sizeof(pin.target_addr),
+		  write(addrpipe[1], &pin.target_addr, sizeof(pin.target_addr)));
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		TH_LOG("child exit %d (>=20 = seal breach)",
+		       WEXITSTATUS(status));
+	}
+
+cleanup:
+	close(addrpipe[1]);
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
+ * Pinned-memfd across a real execve. The child installs the filter on itself
+ * and hands the listener to the parent over SCM_RIGHTS, so the parent (not
+ * filtered) can read /proc/<pid>/maps for race-free loader detection. The
+ * supervisor PIN_INSTALLs+SEND_REDIRECTs before execve, then again in the
+ * fresh post-execve mm (the old pin VMA died with the old mm), proving the
+ * redirect survives an mm replacement, not just the install side.
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
+	if (listener < 0) {
+		/* Child exits 21 when the kernel lacks the REDIRECT flag. */
+		if (waitpid(pid, &status, 0) == pid && WIFEXITED(status) &&
+		    WEXITSTATUS(status) == 21)
+			SKIP(goto cleanup_scm,
+			     "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
+	}
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
+ * One listener serves many short-lived targets. PIN_INSTALL keeps no
+ * per-target state (the sealed VMA is the only record, re-validated at
+ * SEND_REDIRECT), so every install/redirect must succeed across the loop with
+ * nothing accumulating (run under kmemleak/KASAN to confirm).
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(goto cleanup, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+ * A redirect must not smuggle a syscall past an outer filter. Stack: outer
+ * blocks socket(AF_INET) with EACCES (else ALLOW), inner notifies on socket.
+ * The child calls socket(AF_UNIX) (outer allows, inner fires); the supervisor
+ * SEND_REDIRECTs arg0 to AF_INET. The kernel must re-run the outer filter
+ * against the rewritten args and block it with EACCES.
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(return, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+ * SEND_REDIRECT returns -EOPNOTSUPP for syscalls whose register substitution
+ * is unsafe: sigreturn (frame restore fights the redirect restore) and the
+ * clone/fork family (the child would inherit substituted regs with no
+ * restore). The target installs the filter and hands the listener over a
+ * socketpair, since a filter trapping fork/clone can't be installed before
+ * the supervisor forks the target.
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
+ * Re-validation walks *every* outer filter, not just the nearest. Stack:
+ * outer blocks socket(AF_INET) with EACCES, middle ALLOWs all, inner notifies.
+ * After the redirect to AF_INET, the walk must pass the permissive middle and
+ * still reach the outer EACCES; stopping at the middle would slip it past.
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(return, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+
+/*
+ * An outer TRACE verdict over a redirected syscall fails closed: a tracer
+ * rewrite can't be re-composed mid-walk, so the kernel skips the call with
+ * -ENOSYS (as if no tracer) and fires no PTRACE_EVENT_SECCOMP. Stack: outer
+ * TRACEs socket(AF_INET) (else ALLOW), inner notifies. The traced child calls
+ * socket(AF_UNIX); after the redirect to AF_INET the child must see ENOSYS and
+ * the tracer a plain exit, not a seccomp event stop.
+ */
+TEST(user_notification_redirect_outer_trace)
+{
+	struct sock_filter outer_filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_socket, 0, 3),
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS, syscall_arg(0)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_TRACE | 0x23),
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(return, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int fd;
+
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL))
+			_exit(14);
+		if (raise(SIGSTOP))
+			_exit(15);
+
+		fd = syscall(__NR_socket, AF_UNIX, SOCK_STREAM, 0);
+		if (fd >= 0)
+			_exit(12);
+		if (errno != ENOSYS)
+			_exit(13);
+		_exit(0);
+	}
+
+	/* Tracer handshake: enable PTRACE_EVENT_SECCOMP reporting. */
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(SIGSTOP, WSTOPSIG(status));
+	ASSERT_EQ(0, ptrace(PTRACE_SETOPTIONS, pid, NULL,
+			    PTRACE_O_TRACESECCOMP));
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, pid, NULL, 0));
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
+	if (ret < 0 && (errno == EINVAL || errno == EOPNOTSUPP)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		close(listener);
+		SKIP(return, "Kernel lacks SECCOMP_IOCTL_NOTIF_SEND_REDIRECT");
+	}
+	EXPECT_EQ(0, ret);
+
+	/*
+	 * A plain exit, not a ptrace stop: the tracer must never see a
+	 * PTRACE_EVENT_SECCOMP for the substituted call.
+	 */
+	EXPECT_EQ(pid, waitpid(pid, &status, 0));
+	EXPECT_EQ(true, WIFEXITED(status)) {
+		if (WIFSTOPPED(status) &&
+		    status >> 8 == (SIGTRAP | (PTRACE_EVENT_SECCOMP << 8)))
+			TH_LOG("tracer got PTRACE_EVENT_SECCOMP for the redirected call");
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+	}
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 12:
+			TH_LOG("child exit 12: redirected socket ran past the outer TRACE filter");
+			break;
+		case 13:
+			TH_LOG("child exit 13: socket failed with unexpected errno (want ENOSYS)");
+			break;
+		default:
+			TH_LOG("child exit %d (unexpected)", WEXITSTATUS(status));
+		}
+	}
+
+	close(listener);
+}
+
+/*
+ * An outer USER_NOTIF verdict over a redirected syscall, where the outer
+ * filter has no listener (installed without NEW_LISTENER): it resolves like
+ * any listener-less USER_NOTIF, skipping with -ENOSYS. Stack: outer notifies
+ * on socket(AF_INET) (no listener, else ALLOW), inner notifies (the
+ * redirector). After the redirect to AF_INET the child must see ENOSYS.
+ *
+ * (An outer filter with a live listener is also reachable -- only a second
+ * redirect-capable filter is rejected with EBUSY, not a second plain listener
+ * -- and drives the walk's notify path; not covered here.)
+ */
+TEST(user_notification_redirect_outer_notify)
+{
+	struct sock_filter outer_filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_socket, 0, 3),
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS, syscall_arg(0)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_USER_NOTIF),
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(return, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+		if (errno != ENOSYS)
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
+	if (ret < 0 && (errno == EINVAL || errno == EOPNOTSUPP)) {
+		kill(pid, SIGKILL);
+		waitpid(pid, &status, 0);
+		close(listener);
+		SKIP(return, "Kernel lacks SECCOMP_IOCTL_NOTIF_SEND_REDIRECT");
+	}
+	EXPECT_EQ(0, ret);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 12:
+			TH_LOG("child exit 12: redirect ran past the outer USER_NOTIF filter");
+			break;
+		case 13:
+			TH_LOG("child exit 13: socket failed with unexpected errno (want ENOSYS)");
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
+ * ABI check: after SEND_REDIRECT the redirected arg register must be restored
+ * before user mode resumes (via task_work_add(TWA_RESUME) ->
+ * seccomp_redirect_restore_cb). Raw asm bypasses libc's syscall() wrapper
+ * (which caller-saves args and would mask a restore bug) and captures RSI
+ * right after the SYSCALL. The child openat's with RSI = sentinel_path; the
+ * supervisor redirects RSI into the pin. A correct restore leaves RSI ==
+ * sentinel; a broken one leaves the pin address.
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(goto cleanup, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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
+ * The redirect's deferred arg-register restore must run before a signal frame
+ * is built. get_signal() runs task_work_run() before dequeuing a signal, so
+ * the TWA_RESUME restore lands before handle_signal() sets up the handler
+ * frame (regs->di = signo, ...); a restore running after would clobber it. The
+ * child traps on pause() with a sentinel in RDI, the supervisor redirects
+ * arg0, then sends SIGUSR1; the handler must see signo == SIGUSR1.
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
+	if (listener < 0 && errno == EINVAL)
+		SKIP(goto cleanup, "Kernel lacks SECCOMP_FILTER_FLAG_REDIRECT");
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


