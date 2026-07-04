Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14A8C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5046B00AB; Sat,  4 Jul 2026 19:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768E66B00AC; Sat,  4 Jul 2026 19:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CE26B00AD; Sat,  4 Jul 2026 19:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D60106B00AB
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BB101C3A7C
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:11 +0000 (UTC)
X-FDA: 84952662102.08.F46F3FE
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E2811C0002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MaSO00VF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207149;
	b=A71Zqb0MDKgUrbQpobqJ/62VlZ8YeL8oiDiT3jI8RtwEO20USd5bynxIbMN9dA0zXv01qc
	jPoQxKcyCN1w2np05+q3GCkppqXbnHfBXJWbeIOz426D95Xil0u7DsoiAPuAG17jERxaBS
	kA93QlpvLCa13lppgLcmzcJCK7C7qKc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MaSO00VF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJc3drDuHOW9VxklCDqaGfuIBDY3pDcEEx0eyxW0CZ0=;
	b=XgeJjeLaCsbV12F2Wd5/QgxFfQJ/+10IGRtq7EIH4rb1kz/Bm58oglQdaqj1asGLflKEL4
	rZNmuVv5QaqfrCIrD+ahX3uWu+03XlQhvQSeFMsqvUfhgunQCqHtFLVgIcQ6BpEZkUQVQw
	fpw+o7gpA61OYuochuckRbgaHZHn8QE=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c7c61b5292so24328525ad.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207148; x=1783811948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eJc3drDuHOW9VxklCDqaGfuIBDY3pDcEEx0eyxW0CZ0=;
        b=MaSO00VF0DoeSv1+TSOKsWNbeD1ox6M/pEJLvVn031caY1kHmLIY0uYst1z6iArsfH
         fvcNoZ+lCZTAKp60Q78sKMuktZ2bdBSkdZ0NMcoXGdyhWh3c5DHvUVOMyse5ihTotLHd
         hc1XQe89MeB3jteqOeYXJWfCy9MykRlGxfr2IOXnXgWAxU27e7fm2H1Haq76bmEi3pKj
         RPNzuSFsfoKcAb2MnJ55+pMfJVTEOp9lFqPYb+LvzImRehameyQpshil8Mj0o9z1FNlE
         K7+En+CCatUpYFOrUvoZpqyIaXOZAa+9lmUhhNeCY7oUlcEgU5HSKmeMV29fB3zOILwa
         BVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207148; x=1783811948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eJc3drDuHOW9VxklCDqaGfuIBDY3pDcEEx0eyxW0CZ0=;
        b=UMZCLlcSRHiQZVlXIEp5TAAqCwcNcRIJG4FViRfk8RVXzQqOUmf4sh5eZUml31gzM/
         eisNchf7/+r5BADfgHUVW2/JOewJl3MdrrKMClhUDThQyb1fApG2piW5vwOW0wza2TMi
         JfzBMU/DVvOVKD39mQR7VjTBSBL7zpkEImrC80h1Uj4Hl5iNQOMPmbqFgJeGBBJg8r+I
         DVPMLiYHEEQ2oERYbyyev614yDFwwJJpEF7j3FtI6hItL3OWxjUXP4vJtd3vCIhC2RG+
         Tgf9LijvaETO1ycPkNc/v3DOb5ZzSxVPhRDJURanEcTnRvo6Kh6gqZVH+LSo1KlB5BI3
         7gXg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd4+QYTFPoN5ZVPXv2TWEdim4UQ3AhwkrxXkZqxLC15ZWiRQ1cTaZ1GGOQA4NS3az2S8BzSnUj+A==@kvack.org
X-Gm-Message-State: AOJu0YzQfyVcbWL6hRSoTlB0sOTU6mTjL/IrUYF3+UzJ0PB5aFJ+0Tas
	A0QlX/pIT4JNCxjNBr9wmRsQ64T/OwHn+lxXs2dFvrbui3KJ1m1cwYV0
X-Gm-Gg: AfdE7ckNxJ16AhdcVPAlKT+VtMskJ953+NQjrOgpY01ZWJYnecWvpMZuendPTOMdePt
	OeW2toQ07oCKcIvZggjBL4G+Cl3uIuUXgpqE7W9KiDm747iel/P7bwCEhDv37FoFtQNAehRvZBY
	EYRNEm3FylXjUqbQowPoq/tO4imyYLjfgSOBIPesINC8Vbn2NYijcZ2tU3C8yiGt40fFn0QhNqN
	6b0laQiNyEYxQQF93p66PxYvq2I0avVBQ2dWVqKalMhg+oBzrfcBEZd953CpsXXEPRmo+JAh/le
	iM2Oh6GeVZaUOBlRed88hhUmWd7yaoankB1O2RgYCrucrLn6SDw5KvBHt1C32yllv7rs8u8XcW5
	aWlRMHbIS/54y7qTdKf0SIs7vl0tQqLDNHME3xtRs7MVNQTxd0MoF2hyV9Jfg+sjebMfB7DxXic
	ZVMkEdGCQ9m8XrIk3cmDQrFOxIQT4K24nSrbuIrUoNk/bLRyqcQw==
X-Received: by 2002:a17:902:ea0c:b0:2ca:329:3d96 with SMTP id d9443c01a7336-2cb97e432afmr43643505ad.3.1783207148218;
        Sat, 04 Jul 2026 16:19:08 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:07 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 4/7] seccomp: add kernel-installed pinned-memfd redirect
Date: Sat,  4 Jul 2026 16:18:28 -0700
Message-ID: <20260704231831.354543-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E2811C0002
X-Rspam-User: 
X-Stat-Signature: xckozgkudynuf4jrqqfq59munz86358f
X-Rspamd-Server: rspam03
X-HE-Tag: 1783207149-868445
X-HE-Meta: U2FsdGVkX18l8CI+lc5bnAsOXAlw4HkE+jCgwEkPKsOcz5CKe/dmjLRc+ZHVz3LvVHoAy0VJFKA3OxRSfZ4F9+xjP1a/9Z6JsXowXylWeXIVJSEPdn4NnnIJz7Eb6nk1GB4EjkH9GxVYNddkPCg43PfHBsRRsW2MTHhDtgvoR8JvZ8nJKXlG+K51h41PDLMuYcTC39muAi8lxWmgeL27jOzBLKtVOofN9v0woIEb/j3Ouv8PzkOzDdBQ3BskqLdbQ8NxLL4jTBQqXajJy0/ZyifEyqrsnb0CMjlLMy5EsHPDeeXui7fHOE7deFxsd2WWGutCLsbgIjdtxqef12DGkM1PH6vOf60drU7TBAm8ijbuYXqOpnQV6yAeyj+qTi7ep4vYiT3mcMB7MrWYmSjtzqZnPtXCfQsGaY78f6ye5kt4B9MFLLmhGuYdrdRiW/YzrLpc8JGxUT51YGnN3cKBnuIhqkr6Q8BBhe2S6IVGU5HlTra8YdHER/e2NNH/yYWVsas6caJgVZrRKvGcaw5rrNshxN7GyFPJdM63ute0YTrlWQwJ8TuwQvEXqQXd8BXUqJb38dXRKPo04DRjgcrgkwX+PN7US+zzJcOL+K8hyamAOp4D3b/WJ6U8Wl8qsY++jblXEDkaRLk540KSwAFY6dD6iVRPIZxplNtmp2OoAwIiEosNZ7FZyIkoIFH5XgMo9BSHVJL02WqPI5aP1XAn2ATY9EnhaJnYbQZjPSU3eAgg7hXTRbQK1qBOUeM9h02h0V3J6fippOCnKsULYMVBuCOfo+np1arVLCDJrMeTh7QGCZAmkFnuEbIuiV++BpBuebSttPDLxTe/QpPl1PE2ohJV7Ggwfa+9mJB3BatV5eLgThkfQ2VhXS6QsdiBzkqeA+iskcwQzuArL2O0WfUB/NkL6CyZ1pCnX/4KeZIeV6jG9XEdEsqIe85XFFj3fqXrrONss//uyBjCeZByBcz
 4d7sh5qn
 0hH6MpXzmqIMGCZpyDX7J8ZHrnjazNSvriijhiTf0uU6E555TXQ2IxdFyOMwsIRcSE83ak+xa4OVmNes6qDOuThw/v5Nq1UC8G+8wPUBFumLZhZvTjBLgQdo6Hy3gYpP8xjRybRDzjgAZrsdTYVZA064FUjwTWLv6rZwycTwS4VLsGU8BpjglSq28HYUX0OK59N0l5gB0Rcz/qvIDKkb4/cwBBOC74UBCSQjOIt/wa/jwYrwIdMwDQ/JnzpruZBSIf+mAYueLcKPbkI3zuOiaAZF8swnf/ySqKuicOe0S1rktFEhrpn4jFDE2pr/2GK19Yr2NW/duZB+GecdvNn0UrVMzxhmxpyYkn8dufZodH1omOWxnGWqYe78GvR4RQH63y86iOMXA4tXn0un6uPTW3Fuzo/2FYnCQMJzeDNL/tWksWfgD1YOoRV/qP6eau3R4c+Jt6Q4M4SaCqaDKs9k2hv+xjK2V/OgQQVud
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

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/seccomp.h      |   7 +-
 include/uapi/linux/seccomp.h |  55 ++++++-
 kernel/seccomp.c             | 290 +++++++++++++++++++++++++++++++++++
 3 files changed, 350 insertions(+), 2 deletions(-)

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
index 1c0b3bb71379..c5a01ae097d1 100644
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
@@ -1941,6 +1953,277 @@ static long seccomp_notify_pin_install(struct seccomp_filter *filter,
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
+	if (seccomp_redirect_is_sigreturn(knotif->data) ||
+	    seccomp_redirect_is_task_create(knotif->data)) {
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
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1968,6 +2251,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_PIN_INSTALL):
 		return seccomp_notify_pin_install(filter, buf,
 						  _IOC_SIZE(cmd));
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_SEND_REDIRECT):
+		return seccomp_notify_send_redirect(filter, buf,
+						    _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
@@ -2107,6 +2393,10 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
 		return -EINVAL;
 
+	if ((flags & SECCOMP_FILTER_FLAG_REDIRECT) &&
+	    ((flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) == 0))
+		return -EINVAL;
+
 	/* Prepare the new filter before holding any locks. */
 	prepared = seccomp_prepare_user_filter(filter);
 	if (IS_ERR(prepared))
-- 
2.43.0


