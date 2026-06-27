Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1C3C43327
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6916B00A5; Fri, 26 Jun 2026 21:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F136B00A7; Fri, 26 Jun 2026 21:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066436B00A8; Fri, 26 Jun 2026 21:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C59F16B00A5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:23:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A76D12064C
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:23:01 +0000 (UTC)
X-FDA: 84923943762.20.1DBBD57
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 659634000B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H4NnhONH;
	spf=pass (imf27.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523379;
	b=mMeTk6+dVsLo9aEPI+tn9cQgS7w/DmkBXPifY0CXzPR5cjyIcbuM6dqyIosxih2PmYd8yt
	kWNBl4bZUQK9GHeN7h4oEEqIcM1Ng6QdnhX2jNfwn5kGcJY1THIxICgDP7Lr2AF7CrphMX
	WjMFWocSNkGOxW/0oW12lngWOgU/Wyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnffDW3FKM5YM/EqmJp7noMm1eMG7pAWT9QkVPBAw3o=;
	b=JoTvwZl4sYEeikpICejuz7VgQrBdJ7Pjc8ygHCNwAn5X5iLqmIwa8A0gbj3Gga+e4F+aBT
	P7T5j2e1o56sUo9pxSUXAtbLWEDvzOyRFo2Mgeqhvhdd4fmMNvVuVbcFpBLhHPTfimbiQZ
	kaDCyJwdeVvIccD/ibSGYA3B7M2CaGQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H4NnhONH;
	spf=pass (imf27.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-137335bc3caso3016281c88.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523378; x=1783128178; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnffDW3FKM5YM/EqmJp7noMm1eMG7pAWT9QkVPBAw3o=;
        b=H4NnhONH44FSMH7m2Bn2RfW540/PKtewD08CH/xRu9ZS/3hxqCy4qup6mha4XE6QtI
         p+AdP4hD0Myluk4Nx6844kLlF53ZFRxSfEnWpkFV0RxMhyiCIJ+oguud5m2d3FZid3IX
         e+5HNkrOMZ7tExHnveOxRUjIzinrUZFRjrokCo3tHSBs6DvBFXAPczJzgvmp6sQII8zS
         cSi8xEOW7c9PvEXrG55ZpI0LuXBGJSUmj3XskG7Oo50UIpTAjj+bW3RDzcDcM9/3hPDu
         Ar7UK82lolH7Fo+9Fvi4zTE1g9fw9QNYhzCQ/8eUh8OiSC9izDzNeTofmFmFhOuCS1nt
         JaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523378; x=1783128178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wnffDW3FKM5YM/EqmJp7noMm1eMG7pAWT9QkVPBAw3o=;
        b=VYH1zrtTNrfFl+xABx3Bq00lXYswA8khGMsvJjWf1YvFaeJ/bD1dOvfPbN7lmCpwLY
         k4fgOfZwIcJOoWD79ByAruapCQfMI2vcfqa5LoiD8cM5hfnt1LTSCD6TTtloeIQhQ+cq
         ahohTpFdpyE275AwVFmsk7KqPTh/CgjFMggGzUbnzV63sEgyxN5ScFg5b8L3fS0sjvGx
         y9Hl+7AXjsJu7THIuEsJopHLgNMMRvMfee89Yc11+rMR7ZF+OJROYCs6NLwkL8SviW+y
         tn+5gpImuYCkbDyYR8Z5hK3IVhFcL2FSojDSDyNQ60QUKZxz8HwC/8KtLBTB5UoOgLLv
         8v9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq1a5nKrGkFtYBZ1RkjEQfoQkerpGIHdHAGdJbQf7PeYK36OKJ+NTiYFcvGxhKr19aEbTuQMgY5Ng==@kvack.org
X-Gm-Message-State: AOJu0YwlQp2pK2w/ASU8+fVZOd7urOSL53t8y9ZACKRZyP8dLscYuohO
	x883IB65u+fRoS6jEfPZfnxB0j6Gjb8WMaL1qBmvjOR6sHVlcJmho0io
X-Gm-Gg: AfdE7cnCaRpBGGjCB01dz6BHTzr31ea7htQ5dDwi4C88+CpBpPd3ssHXSAVE8+BoFd3
	1iLY8+xWh5zRMdelchTHJ+zQ/zk4LVIC3JnTc3iMVECqhJYmYAjm9laM7B6T/Bs1oyxTl6Y+NLg
	JGwGnBefnd9dSWJyOBuguY/KrhvEOjk+Pm8mh3KYodMVncTZAKDnXxuUcndXHUzMu1DbJeovlop
	JE+05RVHh/rvVhxJpT1KpKB3e/R+Y6UHheds1lDussk2fqwCqy0u59M/FrWmdW9wJ5vo89btjup
	GydWHQvKPatMIQ2FX2gCY6myAp2X/jklRbQP4ZFMylhKdhR2KcNH1T72qln8uEi28x4fevKvmAS
	3QTc20vV3JPSj6/XLTn1AhZk3gJOfzH5We+kOsmagH96nAKVkiXCqbg42AEyYMAwufY1iqSsu/L
	pwixvYU3jUBgND+08awcsLHFRU0EuAMNrJlRw4n0XkuF40khoI
X-Received: by 2002:a05:7300:e887:b0:30c:6847:c2de with SMTP id 5a478bee46e88-30c850a51dcmr8095341eec.29.1782523378139;
        Fri, 26 Jun 2026 18:22:58 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:57 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v4 6/6] docs/seccomp: document pinned-memfd redirect ioctls
Date: Fri, 26 Jun 2026 18:22:19 -0700
Message-ID: <20260627012219.1079851-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6yycwt34xjrpytttic96fbq9d8qrrt8w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 659634000B
X-HE-Tag: 1782523379-587481
X-HE-Meta: U2FsdGVkX1/g93Iyldu6gOCleFSx+SAHOHvYvRedg2ki88dvyBn10Yuqi208pTEYACqNPeGlMWGzFa4FY2mDG09J2bOLtfO4dgfUbkH5qEBC1ihO6Nr9lyLF8SIN+BnrKDfdiUMkbQdyhF5NrM3jj6VimLdykYxsXdeIZyc1AMYrmcGzYbtueep8jknZ2+A2aBTcqMFXMtjow/oGv38d/PskYaQoklO/1r8AmyhhK7Em7BbZ0gcBry+GcNTe3Y8UfAdqhuePyISOYcVlH3RDPVEc1vh7SevWImoVRhguIRBRuo1L0+jVsctNSzu5RLHCkt5U53TuKUN5TlhnsxnDUVKjX1zD4wQbzlqoH2mDVTmL2E/YdhEiqPozJihsq+eDxq8GlrIBTEUyULs6hPCiNLZq12EmXOv/lUyt5uftxyhVXa4YDVKW0ZTboTV1BcZ9YVR6v3E2EoLrOAQmvvtdO8F7t89UKT3Fq/semV9smtaHaMragFfN5I9qEmPXASdQTYhOKySw8JJ63hvBqfU5jYNiBUFjPromEj/qaSupOTZHX/dK35V7Mi8Yi8A2+NxPXWNJCXVQlGXtp9oTeZuWnnRjRonhWbqKtHpDC7PHcXQeA9Po56ZUbCRfDUaCaLBIS1aFxC+Fm1K87STWDx4tyIohMcvXPG+aXY/WoKuLE6CVx/bCK2E7djj8iaUjzZbz/vmzNA8ViRNNEGooDaOh5i3aiXGyVuQzgowxyvH5qyZOxRSpZ90iedVakcMHuPa+N64xUlPpYgW4H07EY5fF7gd/oLTHBJXFkLJo2r5J0uZJ3kPYgNzW54WUBUMT1+JQXiXrqJ9nStd3yXVevAAOALVwUtn3ni69+EThC6i+YbXurgi2/d+hd0wR4NbHPfVGR8a1vs9iJAbHA42MSmnhsThyJrhXfAIcofdUG5HI3NAY9PgJXylo1BWMgA5yVkHrPWgth2bko6If9aSm9Oe
 8d6JKoCr
 4qXYci1u0awH2vLoQfr0wGzG70RvF8Yyweb2vI5OBd54gFl1fH5EVRPUsF+sWVnCFIjdqvnQoA4YuKjxLb2a0SVguphr1QR4nwLadvakoNOqAf1hqqrot7ODM4+UZAh4Mz+QBl0+rlOAs/d1klL6CGSKejluAuv72snVJn1CGOf84tfJmFFI/ODhXmHNSUOMmkumpMD34VypTbHSCQKTM5A8hpzAQ4Eg+eBYOVrqUzWFe9CxcbUkiEZwyl3/m4jSGAOL7Cp4ldqnPPWJqIxQ5nlmHALt7rXAFAaA7CI1WemFb4QppXfWbuMgwSXNL9T2cWNdvcJjtoEiT/hAAUwx+1mj6bCVz+M+fmrT4YJDnQVaajOucJocRA6W3pdy5JhAuaAzYA+LhQ46bFgNWZCGgr49+t03bfCcTFousjWRjTbQtQWIvB/DS8m8E6nryq6nihImwabLPAjaCfW6LKKxPnF9H2g==
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
(rt_sigreturn is refused), the per-interruption re-notification of
restartable syscalls and the restart-block behaviour, the clone()/fork()
child caveat, and the ptrace syscall-stop semantics.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 .../userspace-api/seccomp_filter.rst          | 108 ++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index cff0fa7f3175..3a8ac7775da6 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -289,6 +289,114 @@ above in this document: all arguments being read from the tracee's memory
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
+- **clone()/fork().** A child keeps the substituted argument registers (the
+  restore is not inherited). Redirect ``clone()``/``fork()`` arguments only if
+  that is acceptable.
+
+- **ptrace.** A tracer sees the substituted arguments at the syscall-exit stop;
+  they are restored before the task resumes, so a ``PTRACE_SETREGS`` of a
+  substituted register at that stop is overwritten.
+
 Sysctls
 =======
 
-- 
2.43.0


