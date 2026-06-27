Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B94EC43327
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22A36B009F; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB456B00A2; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9386B00A4; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8BA56B009F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:22:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 601FEA0630
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:57 +0000 (UTC)
X-FDA: 84923943594.18.EC9C4DE
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8EE8240003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZ9rAEtN;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523375;
	b=5U9wY8i+gWgxLoxoBYnD+a47j1GPlTSA8vc7nvAeaj1ZXQYmDeBJtxOcDgM/vNnpcVlSF8
	aza45QPE/UwPrh24NUyfw3638ZevGBSbs4HhAfC+eUiNL/1/x7OyeTg07vnkiE53yi3pup
	A9xZM9ZGwmpC3JQPIQ5MJsIqDPvxUk8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuHf5Nai7POjL7ky2s3A0Iv46Ik6KsJ3W3/ak2RBXdA=;
	b=PIK8HH79Gr0B8S+P5W2sXCf0HHN8AlNkQ+hJUXKdK7Z4iMU6Z4EAYqKAQlU5avd/v5Yf9K
	u8Px9LN3wVZzrdis9G72BbvqFTAOK2NW9MvbB8v0h1/OuwOiHFoSm2R8UAEUs4EjU02Hmt
	1HqGuJZJA2TPnsczx7h+KfYEd02yiok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZ9rAEtN;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30bc806fcf8so2068130eec.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523374; x=1783128174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuHf5Nai7POjL7ky2s3A0Iv46Ik6KsJ3W3/ak2RBXdA=;
        b=cZ9rAEtNxPQhNLdSqeFc5SwRixsvV2HrCEb3wBnWtXCgo02ZpBFNIzbSx/hsPAlIyI
         IORP6TZSKhNAKKWk48UUzgLjCY/a3qz+7Wb0INwBVXl9j61FfojYkx4bQ910zXuE1f+y
         TrcOEtvI2HlUhpTdP2hXu+oP5+sYPe8GlZexye6uSqDyxJKs9VMt9Q2B0H50zvvHJKHI
         OqJ5PzsfOweAmhp0MfCAGkYuPk47Vgzzs7Dnk4nszp5aO9TSE3KkX9uNKZIT5r0Fhmvm
         P1xgpB2dtDd3Jccfbp8Sct9KVD6NwuK2k5sxLW4JpbSRUA+0FguhDzVsUBgpfjQ2rn/l
         VcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523374; x=1783128174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yuHf5Nai7POjL7ky2s3A0Iv46Ik6KsJ3W3/ak2RBXdA=;
        b=XI64d9eM+057PHaNEsmslA/3C/lv9wBerxrz4KOaJc/uNmOwQ9MPP8sPzpAcF+6eAS
         rMDk5oQP3D3o+lZyK7/Cpk4Bb7vQjI8bbEciyH3D/2FS/dmLShx200zLr2hJ0j4njs1J
         Yjo9DtGY5Pj7F/WgV5BIoIOnpbhMluTz1EaA7sOP7cTEjCJMIUXf4IfwbIn7uc8mpeJD
         7+lRKJ7X+I3e4OZwE61fz8LbdT0mqnvBQIAzeBd0QMOq2yMIrnEgcK9Xrj7eUjdUayx1
         pRjNaF8QtGFHNIA4NDKgnxJ/eQGoD+r9FohOwz0yzxrr22phjXOJE+SyxfIPa2CjkKAc
         DxYg==
X-Forwarded-Encrypted: i=1; AHgh+RoJYPTFo5n5664XwadiCNOuzlWo6OWwgXp3qEGKwH8+ChyMBtyzM+72ppCuNP8rfQ7iQfp3pC3h6Q==@kvack.org
X-Gm-Message-State: AOJu0YynldDAuL2Rw0jTQU0jijnLpoISGuavY6JGrD04qefLCWPNFOUc
	/wcmW8J3AqsE00mWF79jsLK7IQPzJ5o3RXG1t8O/7LUWDsVWryL0RzaPQ9nd2A==
X-Gm-Gg: AfdE7cmTAAgEuUbzW9rh4QlmD4t2xBEOideHHmS4DP5HT/lQ/fLFtZPiv1ydx0dLm70
	SxIVMUAV6s0NHmshyGGpr+lDC8DERMzO+ZV7RSvjEZ52R1y06dZOa1AXIUYEZd17YlMXLx1spCh
	CknzmIsDqLmGtyqnEiFmihzabtxPvJRJMQb8mbtGmIAe/3BfImYqjgXLPny3KtXmLTGkQIj8OZt
	XFz8EZoloYzOdXJRjCPvNxvvsXCpOE7D5K+i6pmR9YWPCBuS1H3E4j/NBxFpK5+aq9zqCli5luW
	y/73CNjk0JRkG2zXdUm7VwjLcN7iEeqXqyXGdq7VuN8G5Ew0L+icqFvMzJtSgdQV+N407N/41Gf
	DQiQLavDhaN1RIngLR4DTDNL5HPTsHjcjQ16e8BzbsvGhBCYb5FdEMVJAArgK3WcYNFxaiIonuo
	P84Escmh3jPyAG0Enau/Y/UJHp5V+QQaAVbORonr4b/JCSSSLX+JuQdNIcrAQ=
X-Received: by 2002:a05:693c:3b05:b0:30c:ab4d:da49 with SMTP id 5a478bee46e88-30cab4ddc47mr2241448eec.45.1782523374262;
        Fri, 26 Jun 2026 18:22:54 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:53 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v4 3/6] seccomp: add kernel-installed pinned-memfd redirect
Date: Fri, 26 Jun 2026 18:22:16 -0700
Message-ID: <20260627012219.1079851-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tfaeewtuxaoiwjcfooc7yirgsuzzdhrr
X-Rspamd-Queue-Id: 8EE8240003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782523375-190069
X-HE-Meta: U2FsdGVkX18KRR6A/O+9T/YeSNo9lvw3OY2ZS+3BzKDek217chfmcUj00l5KPuEGCVMYexjv6UD15mb3hg/wAgVayaSMWAtnTu5BqJ45HfIXm6bIslMZMgBEei+Y2SGpAlQRGk1XE3JFrEBpDpNMNks+z9bMyLTBgk8xnWY5zFCMz3yVhl/ZiClxsGzcHxIVG2jiN/Qf6nac47MYwVnPJO26WjHOrUX1WLgQb2BKD9SAGaAS+KbIeuc/S5JDamJE8VY137PAkinS8XAAUkkcqgEJyX9bhKVvzoE9kEHBZrQ8Kcea3he5jkJAaqfj9/Vf0ab2/XevB6X3TAomMRh7l5VFTJTvybQrnrW8vpEOcmIKI9+rIaIQaopaoyIGNe4P3h74PF6jhpRgzB0yLxTC/wBCyb4VSliDz0IAfiW6Lf1eVMtSnbG6vVEoFG5GqyQZAhWnGcC78Nj9k20aRHjooUKbsQ4e+W5Oplg5eYqh1NdFU3FMmgN4LtrGmN8NcUbg28o7jhtyCxSHmrdwWM7bHycO4L+jHavwtptp72/dCO8WRZRSqN47XL36OFw6ktZEhwKSeF4xHSivII3E+ogW3kgX6GGpm2Bwr6mvQNOUeUaWA60lZJ6Q+btsod+hSxOK5fSLcFJB0CGjSMqkBVIjZ9Y/A6/whT4MAYv2dWVHRu9zRbAJasK3wm+1RjFDxRxALJHkc4eTA6/axZC4pkOFrQ6Or00mMmtFSs+/8RPtnUY5y7mdWwVIX9rJ8ifOnPk70ZwXS3uo+h9CqJcga9hSSQXpwdere2tTYKMsL44arpiyvVEwbsU+LDR2aIl7G6eSWKUwxVQBN0MZGmra20c6tk1/rFj/MWCINC/eF5yLvhYN6u5W91EjXLMIkPPZ9mLfmTcPs/Xq55qW3HfJntO8jvhmx22T/Ou1N2ckK4kzr5dwPtltXKDeupKIDQIX2VaK13FbSMx4SOdjCMlvnep
 OxP4PBOb
 0byeOmGvezoJMTQ6IkERjd92lULbZ28k6zOJf+gk3Rfh90//mFOx/aD/FrCAGlaQ2tDQ7DVoIRBEatsPgUWHZyO2+uMSZtMBJ08tVm0XECxqb0YzWR6NmhJqJDOa7ivwwbvWeQYHsfCQXN5E1WcrjADshag2EoEkvolQZDjAuhLqbGMMcp+HUwyxSxXEd00Qe0EWTSuTZLMuUHjFZ2frfM0U4QpuqcN5qP2UCnZGinv0ZwxhhoYmc6VjgI3nepMt6q9gIKIZ04HrSFOgMg9c+ByoJZ2i1nXO+tbDpCq08Yj4M6n2OaNjM5CYJ6MoPd9/d01hUZ9q6SB79HuzxrsYiAoJDFB7zvMqNXf4IBqZ4NLbnTrPsUr43y79UsPm529Xa05WHEKEoliNBSFyzrDx9wcCXrJNrSgSLHWbEuEo4JWLeKxVs4WRLYgcBMpHoFFvlfqSQHYIcbpRKGcM+V/R3wRYxeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add SECCOMP_IOCTL_NOTIF_SEND_REDIRECT, which resumes a trapped syscall
(like SECCOMP_USER_NOTIF_FLAG_CONTINUE) with selected argument registers
substituted to point into a pin installed by
SECCOMP_IOCTL_NOTIF_PIN_INSTALL. This closes the user-notification TOCTOU
for fork+execve sandboxes: the data the kernel acts on lives in an
immutable, supervisor-controlled sealed mapping rather than in memory a
CLONE_VM peer can rewrite after the check.

Installing immutable mappings into and rewriting the argument registers of
another task is security-sensitive, so the feature is gated behind a new
SECCOMP_FILTER_FLAG_REDIRECT that a listener must declare at creation time
(it requires SECCOMP_FILTER_FLAG_NEW_LISTENER). Both
SECCOMP_IOCTL_NOTIF_PIN_INSTALL and SECCOMP_IOCTL_NOTIF_SEND_REDIRECT
require it. At most one redirect-capable filter may exist in a task's
filter chain (-EBUSY otherwise), so a redirected syscall has a single,
unambiguous one-deep register fixup.

The supervisor supplies an args_mask (which arg registers to replace), a
ptr_mask (which of those are pointers) and replacement values. Each
pointer substitution is validated by seccomp_pin_check(), which re-derives
authorization from the live mapping: the access
[args[i], args[i] + ptr_len[i]) must lie within a single VM_SEALED,
read-only VMA still backed by the named memfd. The kernel keeps no
bookkeeping of its own; after an execve or exit the VMA is gone and
validation simply fails with -EFAULT.

The kernel saves the trapped task's original arg registers into a small
heap record, writes the substituted values via syscall_set_arguments(),
and queues a task_work that restores the originals at user-mode return,
preserving the caller-saved arg-register ABI invariant for callers that
expect register contents to survive across a syscall. The restore is
skipped after a successful execve, whose fresh register frame must not be
clobbered.

The task_work uses TWA_RESUME, not TWA_SIGNAL. TWA_SIGNAL sets
TIF_NOTIFY_SIGNAL, which would make signal_pending() true for the whole
redirected syscall (the work is queued before the target resumes), so an
interruptible syscall would bail out with -ERESTARTSYS before doing any
work, restart, re-trap and be redirected again -- a livelock. TWA_RESUME
does not feed signal_pending(), yet the restore still runs before signal
delivery and before any restart: get_signal() runs task_work_run() at its
top, before it dequeues a signal and before arch_do_signal_or_restart()
rewinds the instruction pointer. So on a restartable syscall
(-ERESTARTSYS, -ERESTARTNOINTR, -ERESTARTNOHAND) the original arguments
are back in pt_regs before the rewind; the syscall re-executes with the
original arguments, re-traps seccomp and is redirected again. The
supervisor therefore sees the syscall once per interruption and must
answer each notification the same way.

rt_sigreturn is refused (-EOPNOTSUPP): it restores the entire register
frame from the user signal stack, which the restore task_work would then
corrupt, and it takes no arguments to substitute anyway.

The kernel-side capability is identical to what the trapped task would
have done with its own (peer-uncorrupted) arguments. No per-syscall
kernel-mode entrypoints are added; the substituted syscall runs in the
trapped task's context against sealed pages whose contents are
supervisor-controlled.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/seccomp.h      |   7 +-
 include/uapi/linux/seccomp.h |  74 +++++++++-
 kernel/seccomp.c             | 254 +++++++++++++++++++++++++++++++++++
 3 files changed, 333 insertions(+), 2 deletions(-)

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
index cc34188f8aeb..d6888691633c 100644
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
  * The supervisor owns @memfd. The kernel installs the mapping into
  * the trapped task's address space without target-side cooperation
@@ -198,6 +206,61 @@ struct seccomp_notif_pin_install {
 
 #define SECCOMP_IOCTL_NOTIF_SET_FLAGS	SECCOMP_IOW(4, __u64)
 
+/* Valid flags for struct seccomp_notif_resp_redirect. */
+#define SECCOMP_REDIRECT_FLAG_CONTINUE (1UL << 0)
+
+/*
+ * Number of syscall argument registers a redirect response may
+ * substitute (matches struct seccomp_data::args[]).
+ */
+#define SECCOMP_REDIRECT_ARGS 6
+
+/**
+ * struct seccomp_notif_resp_redirect - resume the trapped syscall with
+ * substituted arg-register values, optionally pointing into previously
+ * installed pinned-memfd regions.
+ *
+ * Like SECCOMP_USER_NOTIF_FLAG_CONTINUE the syscall actually runs, but the
+ * kernel first rewrites the arg registers selected by @args_mask. Each
+ * pointer substitution (@ptr_mask) is validated against the trapped task's
+ * current address space: the whole access [args[i], args[i] + ptr_len[i])
+ * must lie inside a single VM_SEALED, read-only mapping of @memfd. No per-pin
+ * bookkeeping is kept; authorization is re-derived from the live mapping, so
+ * a target that has exited or execve()d (its mapping gone) simply fails
+ * validation. Original registers are saved and restored at syscall exit for
+ * ABI compliance - except after a successful execve, whose new register file
+ * is left untouched (the redirect still applies, as execve copies the
+ * pathname from the immutable pin before the old mm is gone, closing that
+ * TOCTOU too).
+ *
+ * @id: The ID of the seccomp notification this response consumes.
+ * @flags: SECCOMP_REDIRECT_FLAG_*. CONTINUE must be set.
+ * @args_mask: Bit i set means args[i] replaces the trapped task's
+ *             corresponding arg register before the syscall runs.
+ * @ptr_mask: Subset of @args_mask. Bit i set means args[i] is a pointer and
+ *            the access [args[i], args[i] + ptr_len[i]) is validated to lie
+ *            entirely inside a single VM_SEALED, read-only mapping of @memfd.
+ *            Scalar replacements (in @args_mask but not @ptr_mask) are
+ *            written verbatim.
+ * @memfd: Supervisor-side fd for the backing memfd whose sealed mapping the
+ *         pointer substitutions must fall within. Consulted only when
+ *         @ptr_mask is non-zero.
+ * @args: Replacement values for the arg registers.
+ * @ptr_len: For each bit set in @ptr_mask, ptr_len[i] is the byte length of
+ *           the access starting at args[i]; it must be non-zero and args[i] +
+ *           ptr_len[i] must not overflow. For every i whose bit is clear in
+ *           @ptr_mask it must be 0.
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
 /*
  * Install a sealed memfd-backed pin in the trapped task's mm without
  * target-side cooperation. The supervisor owns the backing memfd;
@@ -208,4 +271,13 @@ struct seccomp_notif_pin_install {
 #define SECCOMP_IOCTL_NOTIF_PIN_INSTALL	SECCOMP_IOWR(5, \
 						struct seccomp_notif_pin_install)
 
+/*
+ * Resume the trapped syscall with substituted arg-register values
+ * pointing into an installed pin. The kernel saves and restores the
+ * original registers at syscall exit so the caller observes ABI-
+ * correct register preservation.
+ */
+#define SECCOMP_IOCTL_NOTIF_SEND_REDIRECT	SECCOMP_IOW(6, \
+						struct seccomp_notif_resp_redirect)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index fa0fb3c960a8..7d499e422ba1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -233,6 +233,7 @@ struct seccomp_filter {
 	refcount_t users;
 	bool log;
 	bool wait_killable_recv;
+	bool redirect_capable;
 	struct action_cache cache;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
@@ -953,6 +954,13 @@ static long seccomp_attach_filter(unsigned int flags,
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
@@ -961,6 +969,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	if (flags & SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV)
 		filter->wait_killable_recv = true;
 
+	/* Set redirect-capable flag, if present. */
+	if (flags & SECCOMP_FILTER_FLAG_REDIRECT)
+		filter->redirect_capable = true;
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -1937,6 +1949,237 @@ static long seccomp_notify_pin_install(struct seccomp_filter *filter,
 	return ret;
 }
 
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
+	/*
+	 * The access must lie in a single sealed, read-only, memfd-backed VMA.
+	 * Read-only so no CLONE_VM peer can rewrite the bytes the kernel is
+	 * about to read; VM_SEALED keeps the mapping itself immutable.
+	 */
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, ptr);
+	if (vma && end <= vma->vm_end && (vma->vm_flags & VM_SEALED) &&
+	    !(vma->vm_flags & VM_WRITE) &&
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
+static void seccomp_redirect_restore_cb(struct callback_head *cb)
+{
+	struct seccomp_redirect_restore *r =
+		container_of(cb, struct seccomp_redirect_restore, twork);
+	unsigned long args[SECCOMP_REDIRECT_ARGS];
+	int i;
+
+	if (READ_ONCE(current->self_exec_id) != r->self_exec_id) {
+		kfree(r);
+		return;
+	}
+
+	syscall_get_arguments(current, current_pt_regs(), args);
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++)
+		if (r->args_mask & (1U << i))
+			args[i] = r->orig_args[i];
+	syscall_set_arguments(current, current_pt_regs(), args);
+	kfree(r);
+}
+
+/*
+ * rt_sigreturn restores the entire register frame from the user signal
+ * stack; the SEND_REDIRECT register-restore (run from task_work at user-mode
+ * return) would corrupt that frame, and the syscall takes no arguments to
+ * substitute anyway. Refuse to redirect it, including the compat variant.
+ */
+static bool seccomp_redirect_is_sigreturn(const struct seccomp_data *sd)
+{
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_COMPAT)
+		return sd->nr == __NR_seccomp_sigreturn_32;
+#endif
+	return sd->nr == __NR_seccomp_sigreturn;
+}
+
+static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
+					 struct seccomp_notif_resp_redirect __user *uresp,
+					 unsigned int size)
+{
+	struct seccomp_notif_resp_redirect resp;
+	struct seccomp_knotif *knotif;
+	struct seccomp_redirect_restore *restore;
+	struct file *memfd_file = NULL;
+	struct pt_regs *target_regs;
+	unsigned long args[SECCOMP_REDIRECT_ARGS];
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
+
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++) {
+		if (resp.ptr_mask & (1U << i)) {
+			if (!resp.ptr_len[i])
+				return -EINVAL;
+		} else if (resp.ptr_len[i]) {
+			return -EINVAL;
+		}
+	}
+
+	restore = kzalloc_obj(*restore, GFP_KERNEL_ACCOUNT);
+	if (!restore)
+		return -ENOMEM;
+	init_task_work(&restore->twork, seccomp_redirect_restore_cb);
+
+	/* The backing memfd is only consulted to validate pointer args. */
+	if (resp.ptr_mask) {
+		memfd_file = fget(resp.memfd);
+		if (!memfd_file) {
+			kfree(restore);
+			return -EBADF;
+		}
+	}
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
+	if (seccomp_redirect_is_sigreturn(knotif->data)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock_free;
+	}
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
+	/*
+	 * Save original pt_regs args (target is parked in
+	 * seccomp_do_user_notification, so its pt_regs is stable) and
+	 * write substituted values. The trapped task's task_work fires
+	 * at user-mode return, restoring originals for ABI compliance.
+	 */
+	target_regs = task_pt_regs(knotif->task);
+	syscall_get_arguments(knotif->task, target_regs, args);
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
+	 * (the work is queued here, before the target resumes and runs it).
+	 * An interruptible syscall would then bail out with -ERESTARTSYS before
+	 * doing any work, restart, re-trap and get redirected again -- a
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
+	/*
+	 * Mark REPLIED with FLAG_CONTINUE so the wait-loop exit path
+	 * runs the syscall normally.
+	 */
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
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1964,6 +2207,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_PIN_INSTALL):
 		return seccomp_notify_pin_install(filter, buf,
 						  _IOC_SIZE(cmd));
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_SEND_REDIRECT):
+		return seccomp_notify_send_redirect(filter, buf,
+						    _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
@@ -2103,6 +2349,14 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
 		return -EINVAL;
 
+	/*
+	 * SECCOMP_FILTER_FLAG_REDIRECT declares intent to redirect via the
+	 * listener notifier, so it requires a listener.
+	 */
+	if ((flags & SECCOMP_FILTER_FLAG_REDIRECT) &&
+	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
+		return -EINVAL;
+
 	/* Prepare the new filter before holding any locks. */
 	prepared = seccomp_prepare_user_filter(filter);
 	if (IS_ERR(prepared))
-- 
2.43.0


