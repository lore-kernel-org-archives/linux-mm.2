Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A96EC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5496B00AE; Sat,  4 Jul 2026 19:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3961E6B00AF; Sat,  4 Jul 2026 19:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC396B00B0; Sat,  4 Jul 2026 19:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E11876B00AE
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62C471A05D9
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:14 +0000 (UTC)
X-FDA: 84952662228.22.87DB98D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93763100005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Abo2sGur;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsafSmJFi4yY0T+vpMQ3AUtMEkHeCj5xJ0OnO8eYDKg=;
	b=ZjDNoA9M7t7VTDLMxTKVkhSncR9nat4GC2mbv8FC9h2UwYoxChrvpkl/5TTdVGPf51jj0q
	G/VihrdRay+hCrlt/3MxdesA+YSmExDD4S0ZAEvoVYLDsqXsb6eg4Ydb9v96k1SkEd9xRM
	v6YNDPERqveZ9Sd//dEwTepm1fYjPOU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Abo2sGur;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207152;
	b=h9uS8e8PeuJHB4cohPgx9gpL+Gn/oK6iYsC2WuLhlSq8iyWE9ztGV0Jmv9JGv2GF5sGBpT
	v+l9SNaapku46E4gO+Rb1MJwLB7vrve0P4+iWURiOJhza2ZxkJt9DkOMaO2aq4FNElbK7d
	J59BGC0+jdyDoFgZ3sH8ydoaz+EFCwU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cad225673bso14400145ad.3
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207151; x=1783811951; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JsafSmJFi4yY0T+vpMQ3AUtMEkHeCj5xJ0OnO8eYDKg=;
        b=Abo2sGurKAP9e+h/jJ7mb6tm+kP4xt8eCGF/K2Ce9fIWh5o6/i86FWmrrg7GwAnxJ2
         ZXQyFIAWcHC9TsTuLJpymQ62Si4XIMPrMx9LQjGMmecfnjh/0jMT6YKV7b//CYlsZOGJ
         fIAE5TkPYYo3kC08opveFYFyWg6uhdOmX7RExqEKWuQELKEUIYvS7/um4FRLp3rKZhkC
         IbNZai7Q3TnVlgHQgcXPg0Jdpor1mmNCIoJvgJ0tavc3bAdtmSvID/8AZtmJlu8BE5ot
         vFDP7GbTM2z5Z3vuXGu4Z+EfvtQK2Ccjj9vfLhYGwSECEZnpeStsyvVHB5IpHTWZzCB7
         72ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207151; x=1783811951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JsafSmJFi4yY0T+vpMQ3AUtMEkHeCj5xJ0OnO8eYDKg=;
        b=KmVFpotTpTs+qYKVhion/UjZH1L1WqnvOUKdri+uX8NYhPlJLPgkaoILWfnHegmGq9
         1edimZDmpyfNUeG5CmSLc+T3LpT3B7jT8HNT0/xQVvPYPlW2n0WV1ZxbcPljMLjSaor2
         VtwmiF2hOtr6ae2LbGJAK9/pxISEx/bEd0YzMnu4gQnz0RUtaXKsPAjZhx2QNHto1YWR
         BBoN1X57BiC5nIaLxZ/wRYvISEy10qfS6fX372sFQ3KP/nhzjQtF3s7L26ipvRMsXdmd
         Ipy42pBVvJyRaST7AIAkpoI8DnOMokSVu4IMxALWQRAIvAtypnZNiEDSP+cLkNiNzcTq
         b/sw==
X-Forwarded-Encrypted: i=1; AHgh+RqaLiExseL8+QOD7lTskg3dLwroTKwf9XzzIU51u4Nqj1WHiSTmNR0Pf/6Evzcfc/3FGSdy/wB7gQ==@kvack.org
X-Gm-Message-State: AOJu0Yxg7Pgm0Z18Smzn1SszcU+hgQHg+5J32jw++dXEc5ZrH/TyBQD6
	imtdNUCNp5mbn+f54Z0s0P+byx5tjsXQKlbOp5R6QVPM2JrD+EAqD4xq
X-Gm-Gg: AfdE7cnm3rrN8CVIm3o6ywl0GdoaybPKkgoiGedmfYjyFN6cVZYPwyDGXboMxW1J9sQ
	Dxn2q6L2pmEl7lCtCrz/hvLYtx0varFsaATiYM2pp6/eup13aJ/OgVsjXS/96o+iD5L0hOAR/Xb
	390dkb1T2q1oynnfSoJiJ5MaqjQNkfob2clYZtGy9YGKffcuNBluuWLcmKz1qeK/vCtIdLv3edr
	ZuXc3kIykXfzdy0QwVYb0/z573Da7/vq+HFht8P0ZMh9UM8LyfUVZzWNG9OfvnbMWh7vc4oI8/1
	YbCVa239hUTqGMBCza4JpAijOqDEacM2QMqv/JzLFebOpPt3GgksL70/BVM71U6vMgo6lSsRtcL
	ZNyab+cpH9Znz7ND54Mes4HvWqgzjO7+mWbf06kZY84YUoKReS66Ioh8ANUdbOltToztFE1cIA3
	GaRJvXkJEkhkR67ZKpFYZvNnyQLnMZYFedSBMCx3G88DBNy7GQGg==
X-Received: by 2002:a17:903:2284:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2cb97e4428fmr47808265ad.10.1783207151480;
        Sat, 04 Jul 2026 16:19:11 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:10 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 6/7] docs/seccomp: document pinned-memfd redirect ioctls
Date: Sat,  4 Jul 2026 16:18:30 -0700
Message-ID: <20260704231831.354543-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93763100005
X-Stat-Signature: przrtwo5mikdd15tf4mee9neknzotg95
X-HE-Tag: 1783207152-382074
X-HE-Meta: U2FsdGVkX1/Z9qJmYw7T11aml0/vAACiO/VEVG9C7ZfzjOEcOpoVMH1dLbOAOoYRdG1tKwelLk8joFCR8/GRPuwpvKbk/LA/FtUuCoKI0XmTAp76QF8VE2US5H3NO+K9IrxWOOa3eVptANjNbbYNeKkjpCYbkz8Vf4JvQEMz1r6g1DA2pTEuRrbvsAi1ZDlR8R34GB+YhIgVAQiwsrRBfDx55D8b2VD4QVaQXHXLn1Tcoz1BStfmgeQ3jeK5IGhkKP4u4n3969dIyiPjh7qOCKKaF8oOudmogyIBM4lKt8ltGVJS89YOrhxL99okjLHYPxcJiZlFsclbBj6fuu74Uk8eN7HVr2fFEVu9ofZD4VhRv1VuKPfEuH5jtdvSZSDrOQVfE5pni3OPJQ0JNo3rThcRdApemL6QL6BD3JU3LBWsy0vcpBivMfYTc5CnLGYuTH76adfeDyInLBWVx+8Qh1TQZYED+8QmAIXMQb/9dxXjU4TsaUjfEmXe8/7y5pg22lV7LHsu4rDCSuQQmSw84rf4F1bGRI1Ct9ECGpNrjoXaM0y5BNYBTa42zscMw+RzKolT1Hl6KOsZXLgY4oqNtWu+OPNbwDP+U68mRQ5K/cfEH55R5swk9Rv9NdNwqkqP/kE+Z9QV8/bwjiDLcAot/JHBUNL9xSjygKlgcjmYJN59RF4xJ7z6BBLeRuD/l2yrSuSS3NNN7sgYXacxcVURrdB4CJUkc1XcecLeqGOGKDnDuz1Ya0AAD9nVOam7pgRx/M7xwWYXSsApRxwtEpegsuQpAMmT3r0RXYzoBpGbqgPHhgKJRpDb++agnflBDuO8i5nmYAYoDf3WmA2Ul9EpULqaIaoK2+D4GK3q4KL7Fe/mb/WloG4eqy3hxkh0bLS9Bh/8fSJE+Udl7EWJBDBwaGvA4qlTKhV6HuS2/vveB8JAjdhNITHUqyS7ii3cFD4LjLCNmWtNj+mMtKSzY5X
 ky3VBX8m
 aThUMs/u4ukvMdKwkgPoV1C1d3l7LhiPOmrPWYMGsxpw6pt2KZag71PqDl+ebWQ7DsgPaiHaLZ3ftAQktfPf4tGnKPiPbD+V0PjjiDpSibx1UEudkj1VMo0kpagJtkGidNLXAdg987ZvwUgE7R0r+4Mqi1VXGWmNT8BtQfeIhw1kWS5w9wdiaF5skY2rg4pm13D5T8UjVl9lONWYZRJr44RknYnLMY47BZv9fzVXjTX1SBxED0JUNbHwoyOjTyuq/JwcjshFKpN6Kyl0fAh32vPYyTIa9x7FhYftfzg2COXpKaMfaDNPM0Zk3QBxmF2HjmaQ0lZJXBGcjgU7ORwHbNPGxPctku5x7bxytMK6TzTX7Kp+sHlWD5EvKYHbM3HPJD5IsM7nmsd5JONeYJS5d+OmnY6jBor6vY8TnmSsHlSiud+Didv+oiHD6zpE5ABUozX0zErZDww7rARey8HmYe90Etw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Document SECCOMP_IOCTL_NOTIF_PIN_INSTALL and
SECCOMP_IOCTL_NOTIF_SEND_REDIRECT in the userspace API guide: the
SECCOMP_FILTER_FLAG_REDIRECT opt-in and the single-redirector
restriction, the two response structures, and how the pair closes the
user-notification TOCTOU for non-cooperative fork+execve sandboxes.

Also spell out the scope the implementation deliberately enforces or
relies on: read-only input pointers only, same-syscall-number only
(rt_sigreturn and the clone/fork family are refused), the per-interruption
re-notification of restartable syscalls and the restart-block behaviour,
and the ptrace syscall-stop semantics.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 .../userspace-api/seccomp_filter.rst          | 109 ++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index cff0fa7f3175..e868a2900574 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -289,6 +289,115 @@ above in this document: all arguments being read from the tracee's memory
 should be read into the tracer's memory before any policy decisions are made.
 This allows for an atomic decision on syscall arguments.
 
+Non-cooperative pinned-memfd redirect
+=====================================
+
+The TOCTOU described above means ``SECCOMP_USER_NOTIF_FLAG_CONTINUE`` cannot
+enforce a policy on pointer arguments: after the supervisor inspects the
+target's memory and lets the syscall continue, the target (or a thread sharing
+its address space) can rewrite that memory before the kernel reads it. The
+cooperative workaround, the target ``mmap()`` + ``mseal()``-ing a shared
+buffer, is unavailable in the fork+execve sandbox model, where the supervisor
+confines a binary it did not write.
+
+Two ioctls let the supervisor close this race without target cooperation. The
+redirect step (below) requires a listener created with
+``SECCOMP_FILTER_FLAG_REDIRECT`` (in addition to
+``SECCOMP_FILTER_FLAG_NEW_LISTENER``). Because it rewrites another task's
+registers, at most one such listener may exist in a task's filter chain; a
+second fails with ``-EBUSY``:
+
+.. code-block:: c
+
+    fd = seccomp(SECCOMP_SET_MODE_FILTER,
+                 SECCOMP_FILTER_FLAG_NEW_LISTENER | SECCOMP_FILTER_FLAG_REDIRECT,
+                 &prog);
+
+``ioctl(SECCOMP_IOCTL_NOTIF_PIN_INSTALL)`` installs a sealed mapping of a
+supervisor-owned ``memfd`` directly into the trapped task's address space:
+
+.. code-block:: c
+
+    struct seccomp_notif_pin_install {
+        __u64 id;
+        __u32 flags;       /* reserved, must be 0 */
+        __u32 memfd;
+        __u64 target_addr;
+        __u64 size;
+        __u64 offset;      /* page-aligned offset into memfd */
+    };
+
+``id`` names an active notification (the trapped task to install into).
+``target_addr``, ``size`` and ``offset`` are page-aligned; ``offset`` selects
+where in ``memfd`` the mapping starts, so one memfd can back several pins. If
+``target_addr`` is ``0`` the kernel picks a free address and writes it back;
+otherwise an existing mapping there yields ``-EEXIST``. The pin is read-only
+and sealed, the target and its threads cannot unmap, move, reprotect or
+overwrite it, and lasts until the target ``execve()``s or exits.
+
+``memfd`` must be write-sealed (``F_SEAL_WRITE`` or ``F_SEAL_FUTURE_WRITE``)
+or the ioctl returns ``-EINVAL``; otherwise the target could rewrite the pin's
+bytes through a separate writable handle to the same memfd.
+``F_SEAL_FUTURE_WRITE`` still lets the supervisor update the contents through
+its own mapping made before the seal.
+
+``ioctl(SECCOMP_IOCTL_NOTIF_SEND_REDIRECT)`` then resumes the trapped syscall
+like ``SECCOMP_USER_NOTIF_FLAG_CONTINUE``, but with selected argument
+registers replaced:
+
+.. code-block:: c
+
+    struct seccomp_notif_resp_redirect {
+        __u64 id;
+        __u32 flags;      /* SECCOMP_REDIRECT_FLAG_CONTINUE must be set */
+        __u32 args_mask;  /* which arg registers to replace */
+        __u32 ptr_mask;   /* which of those are pointers into a pin */
+        __u32 memfd;      /* the pin's backing memfd */
+        __u64 args[6];    /* replacement values */
+        __u64 ptr_len[6]; /* validated access length for each pointer arg */
+    };
+
+Each bit in ``ptr_mask`` (a subset of ``args_mask``) marks ``args[i]`` as a
+pointer; the access ``[args[i], args[i] + ptr_len[i])`` must lie within a
+single read-only pin of ``memfd`` in the target, or the ioctl returns
+``-EFAULT``. ``ptr_len[i]`` must be non-zero for those bits and ``0``
+otherwise. Bits in ``args_mask`` but not ``ptr_mask`` are scalar replacements
+written verbatim, e.g. to set the length register that goes with a redirected
+pointer. The original registers are restored at syscall exit, so the
+substitution is invisible to the target and the TOCTOU is closed.
+
+Scope and limitations
+---------------------
+
+The redirect mechanism is deliberately narrow and is *not* a general syscall
+rewriting facility:
+
+- **Read-only input pointers only.** A pin is read-only, so only an argument
+  the syscall *reads* (a pathname, a ``sockaddr``) may be redirected into it.
+  Aiming an output or in/out argument at a pin makes the syscall fail with
+  ``-EFAULT`` when it writes back.
+
+- **Same syscall only.** A redirect replaces arguments, never the syscall
+  number. ``rt_sigreturn()`` (and its compat variant) cannot be redirected and
+  return ``-EOPNOTSUPP``.
+
+- **Signals and restarts.** The redirected syscall really runs, so it can be
+  interrupted and restarted. On a restart the original arguments are restored
+  and the syscall re-traps, so the supervisor is notified again and must answer
+  consistently. Syscalls the kernel restarts without re-trapping (e.g.
+  ``nanosleep()``, ``futex(FUTEX_WAIT)``) keep the substituted arguments --
+  safe for read-only inputs, but a reason not to redirect arguments of syscalls
+  that block or wait.
+
+- **clone()/fork().** The task-creation family (``clone``, ``clone3``,
+  ``fork``, ``vfork``) cannot be redirected and returns ``-EOPNOTSUPP``. A new
+  child inherits the substituted argument registers but not the restore, so it
+  would return to user space with the pinned values still in its registers.
+
+- **ptrace.** A tracer sees the substituted arguments at the syscall-exit stop;
+  they are restored before the task resumes, so a ``PTRACE_SETREGS`` of a
+  substituted register at that stop is overwritten.
+
 Sysctls
 =======
 
-- 
2.43.0


