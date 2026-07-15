Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF140C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942676B009B; Wed, 15 Jul 2026 17:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A616B009D; Wed, 15 Jul 2026 17:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809126B009E; Wed, 15 Jul 2026 17:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 430886B009B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 946AD1202E8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:45 +0000 (UTC)
X-FDA: 84992280450.26.AE883AF
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id B7EA7180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W4ZvuVsJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4IQFbUz6s95kRLqrSdr+Ok20IGsrl5IS8/CWWJOA9I=;
	b=0AawsrVPajbpeF+uAAOdQ6+usohnmpi7Klv8faPHMzMU7ganAliBABCE//yu6CMVFF1Qg2
	5sath/kapdcyP8ig+v++9TFFSFDOlgTQwYoZUQIm0UTJ/8yLkCZlvRkJPkzH/3/4PeuIDl
	xKihgKkAF7bq9IuOvR6rtaqjS38FP+4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W4ZvuVsJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150443;
	b=cmMGB9S1ZidWoXgiac468CvV1nO38XAfUEzE+Up5fEkoLXA5QVCQrCQvP518waO5Q/xG1k
	ULhzNgmHHDZZ2WlDcp4gAUfiQDUHiisk0fJLapPKONK4yldfEl6kztL5yH8GMkONVoz3M5
	+IriSDEbGYpDpmCD8j40+5+Jn/7OIJk=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c999f162c9aso3684720a12.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150442; x=1784755242; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4IQFbUz6s95kRLqrSdr+Ok20IGsrl5IS8/CWWJOA9I=;
        b=W4ZvuVsJlpV9qmsYsqKNdoF/Z8DUA2l2SvwMFvqwiavyX8vMkVeAU7L7D0439wA4Jn
         7KLRwOgIEwkXIGlS+FZlFmbNMZohij5O3gddFULHNYLPBUbrqJW3OY9dUBMGs4sWJuEz
         kkw4Z6ai9CqNRATqXWsZOR7qA0fm39d5zPHESEcwvs6uDd25IrmYRqj6pb7G+3dx4vH+
         TKqi9ex6+sr2T/2GmbpcxeeGprbFfdAOSdlI/2V/sFTUZkUdFDdDsNkZg2sQa57+BGCV
         k8+Uj5YPtjoOLJBkdSKXeTfjSgeiPraxR4xcz7GFXiW/a+24q7rOS6JuE2UHquuU43jW
         Norg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150442; x=1784755242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4IQFbUz6s95kRLqrSdr+Ok20IGsrl5IS8/CWWJOA9I=;
        b=A4NnXiRDMn/xULSCT3B+UMWs0As4s6j7A3hp1QFknnyEMcOcaKZyIkPZTX8yFKFlfp
         qJvSbFUaP9EuvVam6zBk/L6Nq72sdmoe6ZPCtJ30THHSU7iokUGneO31EgshSMt4Jdr0
         aQtjK1Y1DCzdNTpEikE93JFTnZtwCfkaGWpoh4JBMFliNBM24V8ZtAzg4cqZgcE2aKVI
         RUDA7+ScyWatgE5wohvLh1NpSva812Vw+TmYRzTAV9UKzh8zUGOkIZYlTBtvvBsCnam+
         LzBshgYe+5rJuaPgbM7UsEjLBVAyss0A3kYkeZDse283I/8SjatIZ5eHwz3Cxtn9SkPo
         zGYw==
X-Forwarded-Encrypted: i=1; AHgh+RpX0RhFUitlWPqj/K6qi0dYNCis9y1+LLqVJoyUJjD02mQ1e2oLFa2T1TkJgrDDosbkpxguqdXoHA==@kvack.org
X-Gm-Message-State: AOJu0YyB7iyr4pKc1a9XeSkbk2DWMBG4Yb06MH5XWOEpOlfEQizkgach
	K95Futnaq9pWNIqIG3vSMD5eJYyI2okdVaBiob8/VUy5UCP9bUgVoSkJ
X-Gm-Gg: AfdE7claMQKWAS/NnUFIEN8POtxbK6b20GwmzMh3/VFOZSfDr41aiIVL+vBhy6rD82V
	g8FiIVkpaazdb7Ufst5Wd47xNEYywtryikDoDy5OskltWtuqFyO4VPUIh7D24LrJe+rsfzEgTCb
	dmlRl+6KoSzDkdAcltd366TAlEZzyl2cN46YBGqSzOg8mgOshgPGSH0nEuxm7+b8+Flb+yMrwa8
	W05SS9knEwwi6tnWzuZqZcO+pCyY8SjTRgpwc8rBTMzl3BiuTvw7R06vkEJ1kiPJ5GsFo0LnRVg
	CpAI7vJZvtBaFh4s55NhlEK+JdQFEb9XZFpL4On5NB0Ud0jWZh8fMQYbZhIKmydKmo+PMK+90qf
	df8xYZo9CNoga6/RC8brymFClhreCuX5+swK2debAUpEQW89tYX0alMoNtxu4a7dlm+gEIieIxG
	OVG4LnfO55KP2glUpKg5R1JwUhG3L8Qjh1auZFB9DyjFeyICLJLJ4c1E6JYA==
X-Received: by 2002:a05:6a20:6a0f:b0:3bf:a8d7:4f4a with SMTP id adf61e73a8af0-3c34d71984fmr10712111637.40.1784150442469;
        Wed, 15 Jul 2026 14:20:42 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:41 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 5/8] seccomp: add kernel-installed pinned-memfd redirect
Date: Wed, 15 Jul 2026 14:20:04 -0700
Message-ID: <20260715212007.2382846-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B7EA7180003
X-Stat-Signature: h9e3ybiso3p9a8rpmet3qo4h53a17316
X-Rspam-User: 
X-HE-Tag: 1784150443-454458
X-HE-Meta: U2FsdGVkX18tJGO6Ubhox1O1c7HWBCQDZvDt+YifJkkzJoLqsZcDMNrusyMAZwMnPW1u9+UlZNnZ7qrOHA7cl0Xz9KzFMl2HlNwZ9EfBLqXXZMc2F9DWsuU50RRXLQkXIfuRgzsriLcLydNl30VvnxJbKQ8gQ737bOIadNLcCPJur050QKLcw82A8604LlYR3Lx1SYYYUXnG31V0N8/rwc8CiDE8ujO5DtPdGlzriQbZqY5gezNpBJJF33EXkdIwAlFGdnnF/yxIIF+obx++/d9rJO/eY+lPKknlIT57uI+nZrniCF5wpelOOX1WeSMhsWfgEhvK5iSA0ergDArxYD657itJyAx6kMatHQxyQUcuMl7V4FnGisN6a/K/I+eylGCBe+2jKrYthR3z2MxSpSWcOlR5xJYCIcxaimEigDz75Pn6UGWlZazH+gA4RiFYQd6GfzFeGqaWzK+l3/Yx36GmOdTtLo2dxZyGSJYim9TL25FD2lztgHkYQksQuqgDvVTyHpnil8CP5AwTT7ga7HQi/5n/3TFhaDQQQpXeXdDVV2MJ6WCzQFfSA3kp3S3LNHj3/IXSqItlbHvw241Edsg8++Q+24mArIxKKKd/hbuZRodSt63imam8z+t3k6qt7dqxuNoKVlQ/are9k7ta+rJMR90grH5T0jMXpCMJC4NfaSeAE/Um+8hu9gcyAZpBuhkM3SAU9xjrVeopSO2jm/mNzlmh2p14xyATRTtaHkq8yhVUSAV16xlx0LBYZUknf25BDmv7eh5suRRlT+UVtG/nBA3MWORHrrBZR9HF1j6rgA3nebBcaZPz+rXyQFUB8lnafV0vnIon7/GU0vD22x0iGTrvm6BrB+yR1Z+mr9Fjo9u5AUky0Wd+VfIbDL1axlKcw7nRV76OSKPYFRrEDZmCS5zQpzfvjsBXPXNIP2TD70yoY6/LMNwCvINOvtSD/w4uBsJdI7kKgzvcvMZ
 94CQ/8eP
 JUBqYrb9D2qXehQtH1DDhN0rafIyQCsym9LeXkG3XAD9k3TRaBFhYqKvakyi/EZpPWwJqg+S03UAE4DoQDiaWwVl1Yf2VSXcclm/4cBdpHQxA05nLnFzwzaqJJVoUSXvnsAY/EWvVXw1A44+Rfad3Y8NOIbeg7c0/RMHBEj3pwcKgpO1buK1kWDAjRVeM4tooRmgT0cGXo6UBctq9f3dex+4Ik8xAcGtbMYfu537oIthVPiUM8ruS29JbK85QWHtZioXOIY0o6HVfJg2N6NFcaD+h0P6WKufQ+qx3+ScRXLPXp615HW0mbZOTKbaq+LzFmirny1GRaZjl/fxlK/n1KvAM2UAm7JRSZJbIMbSqr0A8okbDc+3zOryqdT9fk9Mso4aV+rHkTvoVIRilx9pANBno611k3QQUSo5WPDoD3i13+q0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, which resumes a trapped syscall
(like SECCOMP_USER_NOTIF_FLAG_CONTINUE) with selected argument registers
rewritten to point into a pin installed by SECCOMP_IOCTL_NOTIF_PIN_INSTALL.
This closes the user-notification TOCTOU for fork+execve sandboxes: the
kernel acts on an immutable, supervisor-controlled sealed mapping instead
of memory a CLONE_VM peer can rewrite after the check.

The feature is gated behind SECCOMP_FILTER_FLAG_REDIRECT, declared at
listener creation (it requires SECCOMP_FILTER_FLAG_NEW_LISTENER) and
required by both ioctls. At most one redirect-capable filter may exist in
a chain (-EBUSY otherwise), so a redirect has a single, unambiguous
register fixup.

The supervisor supplies an args_mask, a ptr_mask and replacement values.
Each pointer substitution is validated by seccomp_pin_check(): the access
[args[i], args[i] + ptr_len[i]) must lie in a single VM_SEALED, read-only,
MAP_SHARED VMA still backed by the named memfd. The kernel keeps no
bookkeeping; after execve or exit the VMA is gone and validation returns
-EFAULT.

Original arg registers are saved and restored at user-mode return (via a
TWA_RESUME task_work, so a restartable syscall is not turned into a
livelock), preserving the caller-saved arg-register ABI. The restore is
skipped after a successful execve. rt_sigreturn is refused (-EOPNOTSUPP):
it restores the whole register frame and takes no arguments to substitute.

The whole redirect path is now gated by SECCOMP_ARCH_REDIRECT, the opt-in
arch declares once its deny list syscall numbers are complete and verified.
Only x86_64 opts in so far.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/seccomp.h      |   7 +-
 include/uapi/linux/seccomp.h |  55 +++++-
 kernel/seccomp.c             | 313 +++++++++++++++++++++++++++++++++++
 3 files changed, 373 insertions(+), 2 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index a91d1fc8a2b8..5d53f8fce508 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -10,7 +10,8 @@
 					 SECCOMP_FILTER_FLAG_SPEC_ALLOW | \
 					 SECCOMP_FILTER_FLAG_NEW_LISTENER | \
 					 SECCOMP_FILTER_FLAG_TSYNC_ESRCH | \
-					 SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV)
+					 SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV | \
+					 SECCOMP_FILTER_FLAG_REDIRECT)
 
 /* sizeof() the first published struct seccomp_notif_addfd */
 #define SECCOMP_NOTIFY_ADDFD_SIZE_VER0 24
@@ -21,6 +22,10 @@
 #define SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER1 40		/* adds @offset */
 #define SECCOMP_NOTIFY_PIN_INSTALL_SIZE_LATEST SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER1
 
+/* sizeof() the first published struct seccomp_notif_resp_redirect */
+#define SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_VER0 120
+#define SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_LATEST SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_VER0
+
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index d3249294788b..bb5875f72556 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -25,6 +25,12 @@
 #define SECCOMP_FILTER_FLAG_TSYNC_ESRCH		(1UL << 4)
 /* Received notifications wait in killable state (only respond to fatal signals) */
 #define SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV	(1UL << 5)
+/*
+ * Declares that this listener's notifier may issue
+ * SECCOMP_IOCTL_NOTIF_PIN_INSTALL / SECCOMP_IOCTL_NOTIF_SEND_REDIRECT. At most
+ * one such filter may exist in a task's filter chain. Requires NEW_LISTENER.
+ */
+#define SECCOMP_FILTER_FLAG_REDIRECT		(1UL << 6)
 
 /*
  * All BPF programs must return a 32-bit value.
@@ -139,7 +145,9 @@ struct seccomp_notif_addfd {
 
 /**
  * struct seccomp_notif_pin_install - have the kernel install a sealed
- * MAP_SHARED mapping of @memfd into the trapped task's mm at @target_addr.
+ * MAP_SHARED mapping of @memfd into the trapped task's mm at @target_addr,
+ * which SECCOMP_IOCTL_NOTIF_SEND_REDIRECT can then use as a target for
+ * substituted pointer arguments.
  *
  * The supervisor owns @memfd and the kernel installs the mapping without
  * target-side cooperation. It is read-only and VM_SEALED, so the target and
@@ -168,6 +176,45 @@ struct seccomp_notif_pin_install {
 	__u64 offset;
 };
 
+#define SECCOMP_REDIRECT_ARGS 6
+
+/**
+ * struct seccomp_notif_resp_redirect - resume the trapped syscall with
+ * substituted arg-register values, optionally pointing into an installed
+ * pinned-memfd region.
+ *
+ * Like SECCOMP_USER_NOTIF_FLAG_CONTINUE the syscall runs, but the kernel
+ * first rewrites the arg registers in @args_mask. Pointer substitutions
+ * (@ptr_mask) are validated against the trapped task's live mapping of
+ * @memfd, so a target that has exited or execve()d simply fails validation.
+ * Original registers are restored at syscall exit, skipped after a successful
+ * execve whose fresh register file must not be clobbered.
+ *
+ * @id: The ID of the seccomp notification this response consumes.
+ * @flags: SECCOMP_REDIRECT_FLAG_*. CONTINUE must be set.
+ * @args_mask: Bit i set means args[i] replaces arg register i before the
+ *             syscall runs.
+ * @ptr_mask: Subset of @args_mask. Bit i set means args[i] is a pointer whose
+ *            access [args[i], args[i] + ptr_len[i]) must lie inside a single
+ *            VM_SEALED, read-only mapping of @memfd. Scalars (in @args_mask
+ *            but not @ptr_mask) are written verbatim.
+ * @memfd: Supervisor-side fd for the backing memfd. Consulted only when
+ *         @ptr_mask is non-zero.
+ * @args: Replacement values for the arg registers.
+ * @ptr_len: For each bit set in @ptr_mask, the byte length of the access at
+ *           args[i]; must be non-zero and args[i] + ptr_len[i] must not
+ *           overflow. Must be 0 where @ptr_mask bit i is clear.
+ */
+struct seccomp_notif_resp_redirect {
+	__u64 id;
+	__u32 flags;
+	__u32 args_mask;
+	__u32 ptr_mask;
+	__u32 memfd;
+	__u64 args[SECCOMP_REDIRECT_ARGS];
+	__u64 ptr_len[SECCOMP_REDIRECT_ARGS];
+};
+
 #define SECCOMP_IOC_MAGIC		'!'
 #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
 #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
@@ -188,4 +235,10 @@ struct seccomp_notif_pin_install {
 #define SECCOMP_IOCTL_NOTIF_PIN_INSTALL	SECCOMP_IOWR(5, \
 						struct seccomp_notif_pin_install)
 
+#define SECCOMP_IOCTL_NOTIF_SEND_REDIRECT	SECCOMP_IOW(6, \
+						struct seccomp_notif_resp_redirect)
+
+/* Valid flags for struct seccomp_notif_resp_redirect. */
+#define SECCOMP_REDIRECT_FLAG_CONTINUE (1UL << 0)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 12135c5df9b1..17fe4c360839 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -211,6 +211,9 @@ static inline void seccomp_cache_prepare(struct seccomp_filter *sfilter)
  * @log: true if all actions except for SECCOMP_RET_ALLOW should be logged
  * @wait_killable_recv: Put notifying process in killable state once the
  *			notification is received by the userspace listener.
+ * @redirect_capable: true if installed with SECCOMP_FILTER_FLAG_REDIRECT, so
+ *		      this filter's notifier may issue SEND_REDIRECT. At most
+ *		      one filter in a stack may be redirect-capable.
  * @prev: points to a previously installed, or inherited, filter
  * @prog: the BPF program to evaluate
  * @notif: the struct that holds all notification related information
@@ -232,6 +235,7 @@ struct seccomp_filter {
 	refcount_t users;
 	bool log;
 	bool wait_killable_recv;
+	bool redirect_capable;
 	struct action_cache cache;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
@@ -952,6 +956,13 @@ static long seccomp_attach_filter(unsigned int flags,
 		}
 	}
 
+	if (flags & SECCOMP_FILTER_FLAG_REDIRECT) {
+		for (walker = current->seccomp.filter; walker;
+		     walker = walker->prev)
+			if (walker->redirect_capable)
+				return -EBUSY;
+	}
+
 	/* Set log flag, if present. */
 	if (flags & SECCOMP_FILTER_FLAG_LOG)
 		filter->log = true;
@@ -960,6 +971,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	if (flags & SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV)
 		filter->wait_killable_recv = true;
 
+	/* Set redirect-capable flag, if present. */
+	if (flags & SECCOMP_FILTER_FLAG_REDIRECT)
+		filter->redirect_capable = true;
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -1937,6 +1952,292 @@ static long seccomp_notify_pin_install(struct seccomp_filter *filter,
 	return ret;
 }
 
+#ifdef SECCOMP_ARCH_REDIRECT
+static bool seccomp_pin_check(struct task_struct *target,
+			      struct file *memfd_file, u64 ptr, u64 len)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	bool ok = false;
+	u64 end;
+
+	if (!len)
+		return false;
+	end = ptr + len;
+	if (end < ptr)
+		return false;
+
+	mm = get_task_mm(target);
+	if (!mm)
+		return false;
+
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, ptr);
+	/*
+	 * The access must lie in a single sealed, read-only, MAP_SHARED,
+	 * memfd-backed VMA. VM_SHARED is required so the bytes the kernel reads
+	 * are the memfd's own pages: a MAP_PRIVATE mapping would resolve to
+	 * anonymous COW copies the target could have written before sealing it
+	 * read-only, defeating the guarantee.
+	 */
+	if (vma && end <= vma->vm_end && (vma->vm_flags & VM_SEALED) &&
+	    (vma->vm_flags & VM_SHARED) && !(vma->vm_flags & VM_WRITE) &&
+	    vma->vm_file && file_inode(vma->vm_file) == file_inode(memfd_file))
+		ok = true;
+	mmap_read_unlock(mm);
+
+	mmput(mm);
+	return ok;
+}
+
+struct seccomp_redirect_restore {
+	struct callback_head twork;
+	unsigned long orig_args[SECCOMP_REDIRECT_ARGS];
+	u32 args_mask;		/* bit i: arg i was substituted, restore it */
+	u64 self_exec_id;	/* snapshot to detect an intervening execve */
+};
+
+/*
+ * If a syscall is redirected by more than one filter, one restore is
+ * queued per redirect, each recording the args as they stood at its own
+ * redirect. Correct restoration relies on task_work running LIFO:
+ * the first redirect captured the true original and queued first, runs
+ * last, so it wins.
+ */
+static void seccomp_redirect_restore_cb(struct callback_head *cb)
+{
+	struct seccomp_redirect_restore *r =
+		container_of(cb, struct seccomp_redirect_restore, twork);
+	unsigned long args[SECCOMP_REDIRECT_ARGS];
+	long ret, err;
+	int i;
+
+	if (READ_ONCE(current->self_exec_id) != r->self_exec_id) {
+		kfree(r);
+		return;
+	}
+
+	err = syscall_get_error(current, current_pt_regs());
+	ret = syscall_get_return_value(current, current_pt_regs());
+
+	syscall_get_arguments(current, current_pt_regs(), args);
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+		if (r->args_mask & (1U << i))
+			args[i] = r->orig_args[i];
+	syscall_set_arguments(current, current_pt_regs(), args);
+
+	syscall_set_return_value(current, current_pt_regs(), err, ret);
+
+	kfree(r);
+}
+
+/*
+ * sigreturn/rt_sigreturn restore the entire register frame from the user
+ * signal stack; the SEND_REDIRECT register-restore (run from task_work at
+ * user-mode return) would corrupt that frame, and the syscall takes no
+ * arguments to substitute anyway. Refuse to redirect any of them, including
+ * the compat variants (legacy sigreturn and rt_sigreturn are distinct
+ * numbers). x32 rt_sigreturn carries __X32_SYSCALL_BIT and is not matched
+ * here; the deprecated x32 ABI is out of scope for redirect.
+ */
+static bool seccomp_redirect_is_sigreturn(const struct seccomp_data *sd)
+{
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_COMPAT)
+		return sd->nr == __NR_seccomp_sigreturn_32 ||
+		       sd->nr == __NR_seccomp_rt_sigreturn_32;
+#endif
+	return sd->nr == __NR_seccomp_sigreturn ||
+	       sd->nr == __NR_seccomp_rt_sigreturn;
+}
+
+/*
+ * clone/fork-family syscalls copy the trapped task's register frame into the
+ * new child, which gets no restore task_work of its own. A redirected task
+ * creation would leave the child in user space with the substituted (pinned)
+ * values still in its caller-saved arg registers, breaking the ABI the restore
+ * preserves for the parent. There is no use case for redirecting task creation,
+ * so refuse it. Syscalls absent on an arch resolve to -1 and never match.
+ */
+static bool seccomp_redirect_is_task_create(const struct seccomp_data *sd)
+{
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_COMPAT)
+		return sd->nr == __NR_seccomp_clone_32 ||
+		       sd->nr == __NR_seccomp_clone3_32 ||
+		       sd->nr == __NR_seccomp_fork_32 ||
+		       sd->nr == __NR_seccomp_vfork_32;
+#endif
+	return sd->nr == __NR_seccomp_clone ||
+	       sd->nr == __NR_seccomp_clone3 ||
+	       sd->nr == __NR_seccomp_fork ||
+	       sd->nr == __NR_seccomp_vfork;
+}
+
+static bool seccomp_redirect_deny(const struct seccomp_data *sd)
+{
+	return arch_seccomp_redirect_deny(sd) ||
+	       seccomp_redirect_is_sigreturn(sd) ||
+	       seccomp_redirect_is_task_create(sd);
+}
+
+static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
+					 struct seccomp_notif_resp_redirect __user *uresp,
+					 unsigned int size)
+{
+	unsigned long args[SECCOMP_REDIRECT_ARGS];
+	struct seccomp_redirect_restore *restore;
+	struct seccomp_notif_resp_redirect resp;
+	struct file *memfd_file = NULL;
+	struct seccomp_knotif *knotif;
+	struct pt_regs *target_regs;
+	long ret;
+	int i;
+
+	BUILD_BUG_ON(sizeof(resp) < SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(resp) != SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_LATEST);
+
+	if (!filter->redirect_capable)
+		return -EPERM;
+
+	if (size < SECCOMP_NOTIFY_RESP_REDIRECT_SIZE_VER0 || size >= PAGE_SIZE)
+		return -EINVAL;
+
+	ret = copy_struct_from_user(&resp, sizeof(resp), uresp, size);
+	if (ret)
+		return ret;
+
+	if (!(resp.flags & SECCOMP_REDIRECT_FLAG_CONTINUE))
+		return -EINVAL;
+	if (resp.flags & ~SECCOMP_REDIRECT_FLAG_CONTINUE)
+		return -EINVAL;
+	if (resp.args_mask & ~((1U << SECCOMP_REDIRECT_ARGS) - 1))
+		return -EINVAL;
+	if (resp.ptr_mask & ~resp.args_mask)
+		return -EINVAL;
+	if (!resp.args_mask)
+		return -EINVAL;
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++) {
+		if (resp.ptr_mask & (1U << i)) {
+			if (!resp.ptr_len[i])
+				return -EINVAL;
+		} else if (resp.ptr_len[i]) {
+			return -EINVAL;
+		}
+	}
+	if (resp.ptr_mask) {
+		memfd_file = fget(resp.memfd);
+		if (!memfd_file)
+			return -EBADF;
+	}
+
+	restore = kzalloc_obj(*restore, GFP_KERNEL_ACCOUNT);
+	if (!restore) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	init_task_work(&restore->twork, seccomp_redirect_restore_cb);
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		goto out_free;
+
+	knotif = find_notification(filter, resp.id);
+	if (!knotif) {
+		ret = -ENOENT;
+		goto out_unlock_free;
+	}
+	if (knotif->state != SECCOMP_NOTIFY_SENT) {
+		ret = -EINPROGRESS;
+		goto out_unlock_free;
+	}
+
+	if (seccomp_redirect_deny(knotif->data)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock_free;
+	}
+
+#ifdef SECCOMP_ARCH_COMPAT
+	if (knotif->data->arch == SECCOMP_ARCH_COMPAT) {
+		for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+			if (resp.ptr_mask & (1U << i))
+				resp.args[i] = (u32)resp.args[i];
+	}
+#endif
+
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++) {
+		if (!(resp.ptr_mask & (1U << i)))
+			continue;
+		if (!seccomp_pin_check(knotif->task, memfd_file,
+				       resp.args[i], resp.ptr_len[i])) {
+			ret = -EFAULT;
+			goto out_unlock_free;
+		}
+	}
+
+	target_regs = task_pt_regs(knotif->task);
+	syscall_get_arguments(knotif->task, target_regs, args);
+
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+		restore->orig_args[i] = args[i];
+	restore->args_mask = resp.args_mask;
+	restore->self_exec_id = READ_ONCE(knotif->task->self_exec_id);
+
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+		if (resp.args_mask & (1U << i))
+			args[i] = resp.args[i];
+	syscall_set_arguments(knotif->task, target_regs, args);
+
+	/*
+	 * Use TWA_RESUME, not TWA_SIGNAL. TWA_SIGNAL sets TIF_NOTIFY_SIGNAL,
+	 * which makes signal_pending() true for the entire redirected syscall
+	 * An interruptible syscall would then bail out with -ERESTARTSYS before
+	 * doing any work, restart, re-trap and get redirected again, it is a
+	 * livelock. TWA_RESUME does not feed signal_pending(), and the restore
+	 * still runs before signal delivery: get_signal() runs task_work_run()
+	 * before it dequeues a signal, so the original args are back in pt_regs
+	 * before handle_signal() builds the sigframe or the -ERESTART* path
+	 * rewinds for restart.
+	 */
+	ret = task_work_add(knotif->task, &restore->twork, TWA_RESUME);
+	if (ret) {
+		for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+			args[i] = restore->orig_args[i];
+		syscall_set_arguments(knotif->task, target_regs, args);
+		goto out_unlock_free;
+	}
+
+	knotif->state = SECCOMP_NOTIFY_REPLIED;
+	knotif->error = 0;
+	knotif->val = 0;
+	knotif->flags = SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+	if (filter->notif->flags & SECCOMP_USER_NOTIF_FD_SYNC_WAKE_UP)
+		complete_on_current_cpu(&knotif->ready);
+	else
+		complete(&knotif->ready);
+
+	mutex_unlock(&filter->notify_lock);
+	if (memfd_file)
+		fput(memfd_file);
+	return 0;
+
+out_unlock_free:
+	mutex_unlock(&filter->notify_lock);
+out_free:
+	if (memfd_file)
+		fput(memfd_file);
+	kfree(restore);
+	return ret;
+}
+#else /* !SECCOMP_ARCH_REDIRECT */
+static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
+					 struct seccomp_notif_resp_redirect __user *uresp,
+					 unsigned int size)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* SECCOMP_ARCH_REDIRECT */
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1964,6 +2265,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_PIN_INSTALL):
 		return seccomp_notify_pin_install(filter, buf,
 						  _IOC_SIZE(cmd));
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_SEND_REDIRECT):
+		return seccomp_notify_send_redirect(filter, buf,
+						    _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
@@ -2103,6 +2407,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
 		return -EINVAL;
 
+#ifndef SECCOMP_ARCH_REDIRECT
+	/* Redirect denylist inputs are not verified on this arch. */
+	if (flags & SECCOMP_FILTER_FLAG_REDIRECT)
+		return -EINVAL;
+#endif
+	if ((flags & SECCOMP_FILTER_FLAG_REDIRECT) &&
+	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
+		return -EINVAL;
+
 	/* Prepare the new filter before holding any locks. */
 	prepared = seccomp_prepare_user_filter(filter);
 	if (IS_ERR(prepared))
-- 
2.43.0


