Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B60C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61C96B009E; Wed, 15 Jul 2026 17:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A546B009F; Wed, 15 Jul 2026 17:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F166B00A0; Wed, 15 Jul 2026 17:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93CBB6B009E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8D51A02F2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:48 +0000 (UTC)
X-FDA: 84992280576.13.8D2A312
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 22BB94000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gVFfX2mr;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
	b=mO1m6IMypthn3lW7O7MQiz5JPtj4gJ7ckj420O40yJnq8fbD3dpixxfv2NU8sNbNotRo5s
	pp5sbTbsBT2hrOBWyChohMvOreIWmWAb12M+0ayKhh2iClWDVeYoXoHByVDGObUCGvCCy/
	rwp/8ZcoEpX6iUiO4pZ1cSPnE683skI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gVFfX2mr;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150447;
	b=IFp6t6xhxkqfv9f6wGIuD/S9GCI2w9P7Mss34gsljjsbdeqekIlolnVRluEgQD+5EXuClE
	iyaIAT0WaLuKmUS0vOUrE0qy3SUJveC73aUV5dfyJiGWXCMMhpiQVhR2WyRe35tMOM0yGm
	+R/LEdsMfy00HilTAnwOGF4w6LoXNKk=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9d1fc053e0so2278914a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150446; x=1784755246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
        b=gVFfX2mrtBjkCX8SRnyCSF5l7WSaU1u/Diflm9K91Wdbw6EDeIexI25+T/cL9IluAf
         SZgDa+uUoLNFdTfw36ZEuS78vPKcyQbjl8OeSr1mVAJmGYmflrBgPEZrsnrbtU/+i70F
         6tPH2jX7eP/qmmtOyM7YDopRP3pX3AXzDMNzBlTK637JvB6DtUqwGws7iYil7bhFhONX
         Y683kmLgXVCwt4qtj9SHJVUatDQWglZVIHRiSnf3r/zmEyQ3h7nPobYEQU0kc0u6Wl8q
         aiHDLy2PAA2Z23yA4bSHSJ88sNycsTG68LU655Twcz4HFaaACTYMRD7SP8tcJVECtele
         f3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150446; x=1784755246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
        b=sJyOy4MMzqglFMeRCGGIvNtfY8w4hnjuUw4RPeHGMToeFp9dnRhCyLmjN4KBwvQCS/
         SLBJI/a1Tp89DssdXNPXy8gE+op9MHL1eMRlCNlgpwUlpM7HCBSkvc6dSVj5Hdtd8W8B
         dYkCP/nS+oBee6Q50TSZWX7Am8a/Ak2f214a445D2f8XnjmBEZ2Pb9JfuzupVoK+eVJu
         0gi82MszMRZeidrqRTb7Hl/WbjpBX12xRcqOBLk4OlHOWpmOmbrRL///byVf7MmQotgu
         V8lPBxVnTmqjjGfGBv4Y68efzUF355vEDKjhZfgK7pCPxl/GeB9gpyxvqc45umFYcaAI
         bLSw==
X-Forwarded-Encrypted: i=1; AHgh+Rqpa1XX2z9cy995kkV98AvqSYbVqmNZX1LO6Zr2E5kaJV/5EvXEXaIfWgrCr8usAnwm4af36OEyYw==@kvack.org
X-Gm-Message-State: AOJu0Yx9tPVFbIHIU66OwnHF5WpNatkac0tGnGiLLJi32EL4uR4FkCT1
	NsftcEWaSo6eD2xCU09oQIHZOYalw7h/vZZuFNXXjLw4PbIXRqAaYKNj
X-Gm-Gg: AfdE7cnfwg0yckbeLtQ3YzlhWaoLwhMaeqom5Dqb4PsPGHtnUaUazmzXFWhSFHrHb2u
	W3H4SYVSwAya/TTFrs1Ag0T6D/yNoNKl+P3TgJfmCvEpr8ZtK5a/NWMYyM3kopsVSfQZWHFgq++
	1c8WwDILII1gqhkMuGrN9UE5hAMFkWLQlC2s/i7k++MsOKbNNY9WmylSLk4kXTWFGc9G4iaVx0r
	zjjVQIXud6MYDlQnS/l5LCVIqHRlTUhdbe8kS4yANJiEyOZALGIgBSfU9wclmo4t1M4bM9lIrXl
	IFd3uiWifqDbzb/BElWDQ+q8W2O0EmNg6Kd3lF+znAHs6JWlaQGSr01Pz8u32pRjf88uYF6sydd
	XIqsveBycUzbIss8pjtI9T3shL0EBGr4HkshjyIaCZpceCtTeA03hVpktill6yYvqxUfFVw1o8n
	5sa3uv9i2t2x7N0W0noQ6kUyASQRPKofvGdGerfCmiXQxfEN3EWtcLMby09g==
X-Received: by 2002:a05:6a21:4d8f:b0:3b2:a809:ffe with SMTP id adf61e73a8af0-3c11000c533mr22415567637.14.1784150446023;
        Wed, 15 Jul 2026 14:20:46 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:44 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 7/8] docs/seccomp: document pinned-memfd redirect ioctls
Date: Wed, 15 Jul 2026 14:20:06 -0700
Message-ID: <20260715212007.2382846-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22BB94000B
X-Stat-Signature: 46amqsmyd4skkkug15ij4detuhjkopdb
X-HE-Tag: 1784150446-954160
X-HE-Meta: U2FsdGVkX19JdcyrWqZMV1LXLHArD+1eX3lwtmLLbpcJVv7wFitDT2mWdfWjX3hFW3AhZrHfMDRg6dVynMZ9H2GLmWM1isGu3z1AkwTDxFA9tGUCHghhjzty+aY1LwgGg+6IQd9ImnJMF6o775SQ/pqnKbBN8259ojshjAQZhV0lFwtT3IRXPGuinFYm6YucQv6zGrRhl8fOfUX7K612qP4Zez1+f+KSaL9TrfXKsh9ZmsYouQ3i8z30okfIB3+kLjn8KuJX5K4M1Pw8hGmQRZ2Sac4i9J8hOz6MraKz3HAHxqZPJsckfkAETlMkL2p/8ntnm+eAhWcFswG5aorX6U9X9KfDJ1fZMk5h5xqMuq3DGqxupYsKqbxy77C9n5ZBoT0+HwFAaNtYADK/6WePYlR/i/d8PDZPC7WcSefmtXfxMSOhyyifTjiSKM3rqflvO/UJgVzaGDGuccsw77sNROkXfGiIOq4ocL9qiqRpyucOigfMWoUvv1qNs4COxatGv5x9f1EGiDw1bIPtexOW1ZiondQvrSaSqZevYK73UVk1+547ukoy24OT4jnBOKCZWpeUrce0q3iLhbLLMY15YsFdxU+nq99Hr/flyZCpkmjI5Ggrg5NJRk7lUBvxJSr0N3sy8RtT/SUHXzEp24TZKNbnS0T60o4hv1JJnNTjgUBjF6UdPr76+jv7wKzy8h2iChiKkXf01hK+N6w20xAiQm5HkdXEX5BWgBJ9joUYRVHIX1zTA8EsAr4kklqp9YRHys3L5eBX9hmhNfA1RcTCri9NMlwvACEoBk4tjezxafyHh9RxvGfvmo6QegdTXH62vB0GrV394gtaFvi6Vfhj1tS7Rt51BUL1ch6v8q1l1y2/DeT5ROVum50ndgZp+oEBG9BlwTV2R19nzYGJF4L4dVLfj/qqdeeDf1LfGul4KBkoLz4OwNuurH3c/Pi2yFZ3yWewksKE5wxgDqAlbIr
 yvJSLfJ/
 3amvjiS+GffPQDrSwP0Tvyj+KpsRoxUW00gZb+BMgmrGj5/Ws6u5M9iVs8U6Eo/ZAwhwNqaosd7PfvJgOgBfqtB7oQS5bYJBBiMZRaBnxowHQttJk5xfHepDm46LouQZTz1k87EcxQ0lEyNHcqo3+rgK2afOKGjysFLO8nc8GmpJ5wnK3E79G8043xE8IGbH17gVFTaY4VXkZindUu0ZHPqDr/e1nWybAKE+v9sN+QMeg2094bKPB/lTqaYJzpWj+ILOzdemrD1CHsKyGYQFQNo1GDdu0IN84NOovoT5m4j658Y0hoIEsmxYMqfHRH1vBbHdhUvd+ai2jvUKOzjDJy0e/XYUq7yw8QZyU3NYw15YgBB+wUm9QXSZ3LExX92dmDcF1B9bGwEWgwMoRKiby7+S+V9PQBf/9OH544TKWZvFgeIc=
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
index cff0fa7f3175..be2c338224ac 100644
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
+overwrite it, and lasts until the target calls ``execve()`` or exits.
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


