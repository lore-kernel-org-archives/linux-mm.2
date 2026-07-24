Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2C0C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E88B6B0098; Fri, 24 Jul 2026 18:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272B46B0099; Fri, 24 Jul 2026 18:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188AA6B009B; Fri, 24 Jul 2026 18:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D92AD6B0098
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5905914019F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:30 +0000 (UTC)
X-FDA: 85025044860.03.D028F8C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85DDF160011
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fS4w3l64;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZL7AIlq0MhT1K4P23mjl1bIfDpk6kn//PjdUqpevit0=;
	b=SP3rXenbtuVL3CnjMpRFGt+ghD0ptvvbDDBjusd7CkOqI9TyEJnN3Ycg3XX2LY49x0uU6J
	xB+H5mB16hcxcCN2Gjjy8rdorjSYA+/Ft1SLtjkeNABfNpF9Yz18ssnafvKt0SBEgnxwbn
	ryu0m0hA6Nu+tEP2oMum8x0Tm+inzrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930548;
	b=UouX853qu0pLDmuPvrAwO+IlcV2seeSvH+jnM4U5MEuR1SXuc92y4dggFICtJ9hJ4XMWOf
	oUbtW/SM/rumqcY3emNkTt+qs+qR4npK8iIXxYnLacbLdPdsKa3NqcJgeaq5zclWBkbfMv
	/jZESSwCKNyYFgPt5eIo/KYryrAYIm8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fS4w3l64;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38759bcd877so666344a91.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930547; x=1785535347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZL7AIlq0MhT1K4P23mjl1bIfDpk6kn//PjdUqpevit0=;
        b=fS4w3l64WQg1ht6MfNaWuv/yV0K0myloL9OdDxeJiFW2MK6zsJrvSVsmVWryPT2jZS
         Hej4EjPWE2DX5q4VH2F72UGAT34nMySSstxaSzTdN5z+ztm2zT4askedHLENGLNoP5NT
         MAZ34YlVYMYP7DTIOsWcbLRlqANeOu4WrGN0DapFRbB0bnGE8zTCl24TCuRD7irfg++s
         P6dBEELkcg2grZFU5gQAFCcADlZ0E9HX7SnN0NKJ0ixK6gqskycJVunnHvWdzMd+8PNT
         +N018LuvnptLcRN5m0Dw8W8TGW2HZvE35lKw4p+P88IuFHyhdch6srmRG9ph+ZVLe7vv
         ZRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930547; x=1785535347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZL7AIlq0MhT1K4P23mjl1bIfDpk6kn//PjdUqpevit0=;
        b=lkuzOKkNGkfHW+vwFmBpKuXT+ZQ0XBKJ9TKl+6GQLhc5BxnbZ06rbU/HPLJWcCKzeM
         jag+WBuruIL3Z69CX8uNudTUkuf0uJgv3l4PRYbG0pxK/6sPfbNtI7cBL9LumPkVET0W
         vRU+Zi5188n2NpiUtNCcLupU2Mx9ePUHnD3MUuN1KPxQ5pn6vpq81r7kbmJyjkG/R6ht
         JMGTXDDOSURP9baCrBWaWHDZ/6GRhhn8482jsE7YAREAkuKSER9gHj9Crro6QfccMV8n
         aOTTkueJPo/Ryj4R80wtQN/5GzpCASM8FyyiYseztBpvdlEZ6TGjiQUs4eyerIgYZ5MP
         DLKA==
X-Forwarded-Encrypted: i=1; AHgh+RpIdWu7AaagVsnky+SQg+dxEi1KlwJgVmNvxaD9tZBtFxg5vKW1xo73rjBTjchZZKhLoKA1Ftt9lA==@kvack.org
X-Gm-Message-State: AOJu0YyhZ4xKhULXh1eK7wTX/QaJz4eOFIBtYluNvxxhE5CTxEsCLjiN
	7zAxzdWqWzyLKXhjn9QXWrh1bi0vs2SSg6+JhngbZAXQ2AhkAI5yxGrj
X-Gm-Gg: AR+sD10asCRSgh+UclF5lPtWmm4sLzn2BhdDJpHT8rG85xtActqDIjLByH5YQ0fJ+uy
	nFSo5hwk0SR+TZAC1KI3MwHUs6S5WjDil4dohfsRdSNBSTLjzCWD/7pFRc052uulr4/lhi35NpM
	5dfI9N7pcu/SeRLKPsbTh6yDZE1lv9gXqTmpdA3ak7RkTvxmCtH5yTFcdbAGuvAsMN1yI0W3yH5
	C79OCrj5VQkrkkfSrsWwnaihLhIkoS4IEJdevoFTyj2egFd7He3ShsWHX5OHegd+oBX6+Vm3WRi
	U7g8sBi42Vb52y1RY1Cx7fIS+ts4AyIequevAHAPnsqJEay1oqY8t6PXJM7Lm7fEw7BNjoCYHml
	lFpCKwlU77YFifpSX39Nhu8OsnajoQeHKXPaMEM/iLvaey50gFgOfd2fgS9mLkaMofNMbjhPi9T
	KVrANUDAyzOtpYyfTqi9kIBxjExrON27xngns3BKNnvRXFhx/sHNudp1IdG9mM
X-Received: by 2002:a17:90b:4b86:b0:38e:a555:8fc3 with SMTP id 98e67ed59e1d1-38f2965654bmr216020a91.41.1784930547299;
        Fri, 24 Jul 2026 15:02:27 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:25 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 5/8] seccomp: add kernel-installed pinned-memfd redirect
Date: Fri, 24 Jul 2026 15:01:44 -0700
Message-ID: <20260724220147.214396-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85DDF160011
X-Stat-Signature: ktmt35rcmh4uk1nr15s5eppte3esnf6e
X-HE-Tag: 1784930548-67428
X-HE-Meta: U2FsdGVkX19tUmoCLRU9srbuqq3xSRjp6AhpEYu92psfe7+qHvw4GiTOUyBZgAZ2IZUTnBbQXunh2wQJW8YlwILRnuCNHV1jSJHd362QAXjl96I1J1VtlkEbjeizOkzCvKi7ouTRZI0fUWZYudUHiMvyRzvV5teENq0L4tK1BXuC5u3su1uSFH2Yrp2fvAJVdEQhUibJVgMfblAhDaoMMnrERtYQ5Q5maV+K2v+c3cSVpSlkaYyU2fTJMl+4uVt4n3UBfzvdX7KmZxaoLoxyqetMil6B0furFM65JOvHh+QTQ/pexdqPOxXqm0E04GE8UmHCfoJrwy5h0knD7FYimtoRxEaQxEG0m3eWftOiVU6quFgcCZtAYlpnSZG/bG3oCdstBDTAfcgBvuq3IJMt2RUMsOcK3Iys017hM7YmQR3vDV7Zm5gMjXr1cenunJ11w5PfbMuoag8EePD6bWK8ksU1XTQ8QpNADJQfGN62Ua3RZVYYMafiEIk6MQrQgwgaEu5pObuB0rygPvhPLUbt1xOqJNcqEGUSXBvNPE4uzUTi7QMRepB83Qze8ODMVl2dqWlDcJQf0UrqbIcnB13bNJ+x/KrB+oZe8QJOPJVIrx8fNn84lYWbsSIpUrQqbjU+oYogGaHMA96lf4pzKIdT5L+XbRyVVOFiXd31HfjvpQh6G+M2V56im7dWtGIlSEO4cQ4k5usZ7gKnfGS7ypbQ2KdH8qp+kei11T1YzjokSkJLzL4dNRNqLF0LrtltUm0kNnvd7UeKytuBaYZJsI0XUBqhPhQHaQ1p6Erkau/OcOohWya0xRVHLip/bSKbJrVxia1TvcyeDZ0R0Jr0B+vjkKVJlh146eYWkOFGD/PcXBkla950seC9OtqnOBhbI+yra9DQbC8q9o7kXpOPhFk6qvzouvOkgV1ECHnuvrjvG9frh9exjVRJEmoDD3aVV4QjGGOVR07+yzPBnUzfEI/
 D1bsTnmM
 K/mjIYEYmYXCyikRDyxJsVBHaLlHIMQmwuZ2/brVTDcwLE2gcnrqsp2c9XjxXi09aEKHEKN/e+U+j1O4iyaYGWS4+1bXtGFqcvwP65FLBW1xs/prODktgTyBz27HPyrxr1G/qpFx7ZlqoietnjWG0FcV6I01wJRVgO3CMp2sUzIaF5EVkwHBdmsRq0Q04oBqQCbVDYEduWq7C0jVip4O6KBannB0FQdjIO4u91OeUnsZoHJYRPOQvnXEo3a3X9oeAZswmWBf8rc+QUGqBtHKuoZi+FXNf1dbxk1Dm8gFK8wefV5z8gDaOqWW+4k88PA5acKvGLv5zOLwVVADdSnfimKvFV8D4eOAnE03ki2zXPaS64m8XFrZnSj864FCe0+WlnctkoGuEAgqV78DaXuYHNTKU3UysnaIkdsMHhfSGQ9Orum3nrSpVreIDxAD2Qy3IaxNkJ4Zh2A4AFDoxbvkdsNbtvnZdG4EDKAfO
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
 kernel/seccomp.c             | 320 +++++++++++++++++++++++++++++++++++
 3 files changed, 380 insertions(+), 2 deletions(-)

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
index e894af0e7c78..f23dbee12ab7 100644
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
@@ -1946,6 +1961,299 @@ static long seccomp_notify_pin_install(struct seccomp_filter *filter,
 	return ret;
 }
 
+#ifdef SECCOMP_ARCH_REDIRECT
+static bool seccomp_pin_access_ok(struct mm_struct *mm, struct file *memfd_file,
+				  u64 ptr, u64 len)
+{
+	struct vm_area_struct *vma;
+	u64 end = ptr + len;
+
+	if (!len || end < ptr)
+		return false;
+
+	vma = vma_lookup(mm, ptr);
+	if (!vma || end > vma->vm_end)
+		return false;
+	/*
+	 * The access must lie in a single sealed, read-only, MAP_SHARED,
+	 * memfd-backed VMA. VM_SHARED is required so the bytes the kernel reads
+	 * are the memfd's own pages: a MAP_PRIVATE mapping would resolve to
+	 * anonymous COW copies the target could have written before sealing it
+	 * read-only, defeating the guarantee.
+	 */
+	if (!(vma->vm_flags & VM_SEALED) || !(vma->vm_flags & VM_SHARED) ||
+	    (vma->vm_flags & VM_WRITE))
+		return false;
+	if (!vma->vm_file)
+		return false;
+	return file_inode(vma->vm_file) == file_inode(memfd_file);
+}
+
+static bool seccomp_pin_check(struct task_struct *target,
+			      struct file *memfd_file, u32 ptr_mask,
+			      const u64 *args, const u64 *ptr_len)
+{
+	struct mm_struct *mm;
+	bool ok = true;
+	int i;
+
+	mm = get_task_mm(target);
+	if (!mm)
+		return false;
+
+	mmap_read_lock(mm);
+	for (i = 0; i < SECCOMP_REDIRECT_ARGS; i++) {
+		if (!(ptr_mask & (1U << i)))
+			continue;
+		if (!seccomp_pin_access_ok(mm, memfd_file, args[i],
+					   ptr_len[i])) {
+			ok = false;
+			break;
+		}
+	}
+	mmap_read_unlock(mm);
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
+	if (resp.ptr_mask &&
+	    !seccomp_pin_check(knotif->task, memfd_file, resp.ptr_mask,
+			       resp.args, resp.ptr_len)) {
+		ret = -EFAULT;
+		goto out_unlock_free;
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
@@ -1973,6 +2281,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_PIN_INSTALL):
 		return seccomp_notify_pin_install(filter, buf,
 						  _IOC_SIZE(cmd));
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_SEND_REDIRECT):
+		return seccomp_notify_send_redirect(filter, buf,
+						    _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
@@ -2112,6 +2423,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
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


