Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B0DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74726B009B; Fri, 24 Jul 2026 18:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7226B009D; Fri, 24 Jul 2026 18:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EC86B009E; Fri, 24 Jul 2026 18:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66D906B009B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE4C4A08CE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:34 +0000 (UTC)
X-FDA: 85025045028.12.F9C7901
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E676EC000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VB21aog5;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
	b=3njbVXMlJafnhtREkt1gQDBNXB4DeL6k00HECedLgdU0QHP7COiZNffG0z91qtHyVq0trk
	/XjCxO5Tkh5ZsLfXJmV7RnyWiBTEacxeo4SFw8HBD2iiVDsnjJ/juLvhRxs+fQqbmIGPDe
	gR/budAqApA7T37I6S5Tug4rUq3WNt4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VB21aog5;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930552;
	b=3BhRoMwMuw6gZrUBw6u+xInVV566BIUZCkF3z5EqBU0SibpJq4rOn0bp9Tn2z/KNHWjS1D
	1d/wLHByQrVPFIokG8ZpsxKTlwDGoovpNH5JYIXJ8U1wq9O+jFTKdflcgJ2bDKyb+aU23/
	Jy9CE5oy5JkgqrXbqIZ2pn/U+O9DKiI=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c999f162c9aso654588a12.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930552; x=1785535352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
        b=VB21aog5aIQGiFjEKbzujLno3vj2+7YlRXeUGKpwHU8yTSbvrB8Tw/TTCgLE7ldGVf
         7+T5crWv/HtiLdqwc9Lg5WD9skVDl1EjW6RJTQ8nGCIb344tStG6uupO1DKcWgdAdKtW
         JMGJ+RjPpswc/E6f04brqAZ+RUxtbTwSrjQZNQl0ThVSBUz1T1+jv2HKFUOJtA9bZAYv
         liHAvcdtXLP6rCn5JrhZnOmrcOucI6t2QklZjsGIFGRQ8kOVn/RynppY4n27OYYr7NPz
         CZKL7EJd39FIVLyqBEzhn9dBmNXugsm6ZoOpZ3U1RL1ymXE860sTJk0ti5crfLmo81GG
         cFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930552; x=1785535352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1GNNEUTrXfcasiBfiMqOJUDgRwUpOC+gV6LgyALCys=;
        b=p0BWCcRiYyN6r/CAZMJoIRSjERUzwgSgGPo2gVCfacxMICptO74Gje27+ZjwILtKUu
         p2h13rO/I2ecx5U0Gq4f6jkjyY2dgIygAMnsI+vnWTf9QbZ6Bfqd0XowDkz+goddOmdl
         MEbiXg2UB/deUA5rfMIDRieZD4spon2HcrGgydEtXGQpZOWaJtFUHJTuZ4MO1053TXRe
         JjtA/prrlE9SKrEdE8WhyPVcYVYKs1JFiNC8TGWPwoHeDUWLROGK5WI9UMdiRRVZ2TlI
         JDFIZdS5K9Ot7Nn5JHK81aOH5JQC0ydlw8PYo7db2708srAvsf3Ik6pZW6mwXzhYoraw
         1f+w==
X-Forwarded-Encrypted: i=1; AHgh+RoO76kZy4cfNTRpkcQ7ZjZ0kEFPiZYX0ru7OrLN06FLmjPqXYQADI678GmTmJIlxYUPAXAUkiGp1g==@kvack.org
X-Gm-Message-State: AOJu0YzihBO8jTnR8Sr1fU8rHehVfSWEz8T1GDmwyU5+HwHWj+0+uZ6L
	t/PyvkZVZB8HzrxJ4mYQybTnZAaicUID2hlfL4+Tn+YsTl0YFN+EHS4J
X-Gm-Gg: AR+sD12PST8myun5kyUJCjEmQ581/ihLbP5q6UykHOEhb4XH6nthx0+xM/ycDTJcztl
	l3sd7vD3WCGWY3VlZaEFp6J5g8EWED1uulTgp/D86bjFH2u9rPs+YeGHnDTChzkVlEjAXBMKGHm
	YOepJJMzRphbWiw1t3oT0tkZbO4kf5gTcdeSgE7sMoMmrd1vD0L+9ppJUYECmMMtcqie5zm2nrt
	J2WqUnp+cp+/9Po4r6QacO6TmydSSW59Cw1lGYaIENVI7su1pMP7kJ839FyaMBGq8kbK+GDQLqW
	Ky5HY4X+SUcoHHtvpV4Ood5TkPAQ/g6HJqNdUhH8N8eTIUCIUy1LFsrvi+9x9dGcpFWHKTl3XI3
	ILSuVvYtJRegv8PcXTumaa3OU2Pc6nDj8S8hcUz478UVM7+RXNTa4aX5upQXr3g7njmoMjVZv/i
	NBGp1KILlJNtbSWE+Spi6ZIsIedGVM/Zb1mw6C0MmbnSYelpE7vYVS4UEtjSLs
X-Received: by 2002:a05:6a21:6e96:b0:3c0:9c1a:8941 with SMTP id adf61e73a8af0-3c67e17d26dmr101841637.73.1784930551744;
        Fri, 24 Jul 2026 15:02:31 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:30 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 7/8] docs/seccomp: document pinned-memfd redirect ioctls
Date: Fri, 24 Jul 2026 15:01:46 -0700
Message-ID: <20260724220147.214396-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E676EC000E
X-Rspamd-Server: rspam01
X-Stat-Signature: nsethsru1a943f44e3aspfnowba16ir9
X-HE-Tag: 1784930552-702416
X-HE-Meta: U2FsdGVkX1/1WsVzQaN7sS8rkmQ611NCJ/FzMNhOWsPaq4KAqt9zOUiy5pbkDgxsggv/ADAH6qvtJ45SlfA7vacp8NhM5VKGlOVb7PNfw3G9XMYtq6mAlqut3A2ub7kBeG4pScjJGjso5wKK4UM6wDKrlC7FfrU74XDqYroAFDmNRayJfKJqP9a/S4ETUU9qO7xaj0vFD3inv4iSVxxLDZUhwWwOxMvjzsAWVAYzwdKPDOiOaI4DxGLAEkS58f36BAA90hdZwg14s/abzxBE1WdR9F0LbZ6O//Uo9QUwR0pq/qNkvOZt09hscKqc/nWBIUJ3py8/H4DVAlkr2lDnNij0ir/OYHyiLfH+Xa/wPKPMQrmvTgJXDSQ8CxlTiJ9/OTNiJmUASyxlVoUVtVp8VhsasEmTvc9+AL9bs8Z5Y/7fnDBODgA936U3RbeyV8QqOiGZ+7RZ0w7OmBvVtpGSZxgOZFOXGE8A2TijrdKF29LB4Shb8P+MHAnh+tJWMVpJzckqYlROkVnVzOImqlAyNtGNQOyXCN5IHmsgJi04+L1DQ3tYz2QGaskMumpd4vsy/UHAJ0qqbukrt1E1FOx8zT3UXYHdNPL+bPx71SrkMCL9NjAxNjuK9SHayb/LF9bt1phhXQj7w+V8uDCEWhfixtBX8WWgjsnLNNDHnMSHMUYHI1Qa6/UFeQsQxSUl3EyvG+9mp0k22u3Xr3n/UoB7J2uiIkb//JMClx3mkf2jcZs5JwrKnXvgulzqrapTSVpKpC/qUFhEQvXJY9C18LLz1+zJGKIaZuqBgRb9zh6eM/+85/2la5sEz+7EjyO/qIuqDcad+liL/WsFa2sw8v7y5GIKfNto9TZUxUdECj+A7iSULba6WHgFPouFb0tQ3rjlBxDEBO7RxTdfzA/qFgBYloMsW0GTr7v9Ofm6ro4C/eajTHdjxpw4lGrI/nAjrCx4x7LhKB9MubPxl6oPW5M
 u9WyUzjS
 NbeM+zexm/MwMZ0SShAs/gYzDYXWRlwCVV916h1GKTZEdIt9A51LbEuqrEQ3mFw9iNfQwqU+RX8bn+/CefVrRGMyde+k9GI88KXBOnvIExGaiGgbRmYH5UC+LJbzbLr47vBnbiq+QBACn7qHrpdDUdGHloZ2Y90K9P+5A0GepNO976rSbJ5mEA2n1t4c41qTC6a0Rv+91TmC22Sx+Q4kCdavkmyLQ1ldr6nqzPx/S9YS4X/DmCa3tIZEVs84oOvc+ojS621dkEE2jok9fuTEWlFV4kFJqkiDu5vaVEZRt+6QssoBZYIe6X2vhtuG26h5ZUJ4cr4mDaqrD2Kp7vSuix3WcolmmIWrQPtAbg3jTDhR+vEdW7klOiffWKY/Wk6jE4NUsbZyP2l3IN6UnCqH0o0GajwTZoJ5MN7+2h5HqKEgqd3KZClw9MR5ZCqyFB/0tsQJVup9F6OGz2p4DGwZ+0/FTHuq6wyUrrsFc
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


