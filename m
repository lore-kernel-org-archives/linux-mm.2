Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EBE3C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB536B00A2; Sat,  4 Jul 2026 19:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3116B00A4; Sat,  4 Jul 2026 19:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7736B00A5; Sat,  4 Jul 2026 19:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6B06B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF41D1205A0
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:01 +0000 (UTC)
X-FDA: 84952661682.10.3BC4813
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3BD8B80002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BH9WxXmI;
	spf=pass (imf30.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ouPRH6bwUsvKzcuc7nCFnf16gT6SDBFOnvZAEM2+bt4=;
	b=zceBPNz+q3oQeKOIiGujTJ9+dnM1dpbQD4hUYiASjZWiCGXdZeU0r00XS2QkBGTDLHKlzt
	385F7URzO8W6u9M7ohXSXSnygJFtD33vmYOxVdi3GXmT+3TirptG9TKAu+IEAY2k3Q00xy
	1NycQs+SLqMa4NG5/3m3/CaY+oGF1dI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BH9WxXmI;
	spf=pass (imf30.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207140;
	b=hpjgm5UFM9Pm70EgFquCaJg7MEwEBD74Sy/IzpQY0NY12Vg6QelPYCkZSPU0wEuwTPNQqU
	O6aVMkulh3MwfLJ71ZzWdELMJj3t/EVIBg/y0ShDlE1O9fVvIXMq/MN5vN9yQOvaWn+K7w
	5W0VVpcfcSogaslPoZERjUN0N3xdV+Y=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc891373e0so75465ad.2
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207139; x=1783811939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ouPRH6bwUsvKzcuc7nCFnf16gT6SDBFOnvZAEM2+bt4=;
        b=BH9WxXmItEpQWgauzmc4HnVDKRC6M3PTBCb4ZGJZesRRGBy2kpiur4FKQcm0+gz2w8
         Etg4nTSbfzaArGwpDqgAblxUXqp8vD4g7DTmbBSEN1fQp0xT/PdsMn781KKwaF14qAxm
         h/9HIW82q25CDF0n7x5SIy8pY2/EyRbnNEgOu9lBfkpnMXLqRnf3tAzP9g6wNK0F0FIk
         /YmMoW/dqwtH3yWabjiw+MnQt65bEM123UvKsHI8Q/jdigpJPlVoZD0zoIH+FeGsS4O1
         D2oReyeI3y8EFnD8NbLbEo/xizij0gXmQcvJlLkwXiLABBGRVdXwR5pyeI7yiIzc2n48
         YwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207139; x=1783811939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouPRH6bwUsvKzcuc7nCFnf16gT6SDBFOnvZAEM2+bt4=;
        b=B8TajGcLrcuf/cyu7eg0R36VeiMFQJzQgbHd70LBLsOCB+DNABT47MNKLYsj48fAVB
         a2lIlGcTR8tiq/2EgM0TEv9Zfk1b8OkGCnevo0+85YS7d7jvyBVDc1StHx0G8sw3O+F6
         wApC6lB6GWLjurlRQbdCwC8nflWy/j0h1BnLNbS0m77RuG5lm26AYciIPjS9m/mz5FFT
         YtjYHboJXt2RuLeI8kGGV45vsGsUVnrAq1fjEJ5HzT3Gf1FTEqmC4NssL+fXlqiWLEwo
         XflCDYPq4ORHPem6iT3MjTGpk+Pwm71Qzs5YByfPFPzMOTdvnmBRt8qMdaI+lgDAVpXH
         rzOw==
X-Forwarded-Encrypted: i=1; AFNElJ9Wk9kWlj1GSi4Grx4VmoLsCVWN7yJdUcDLyV64/2ASxxE5zOFxt05iTGoi1sqMCPU0ZDjirZvW0A==@kvack.org
X-Gm-Message-State: AOJu0YxtHtrKGLzoxXs7ZaIcLft1nYdgLoVcElWGaKtu5uTCLgnhu2uS
	MVGioxkoOA4lSIQ8JhBYDibiadfMhZzRFydzvsHZh283Ew9fLQbR8f1s
X-Gm-Gg: AfdE7cng09pjCi0Dg4/izE03PhHMFG2bGkJ/h4/5GXiUqAFLHPjwArvnWT8gLW1fQxZ
	f9itCDZh0/E0hkSlUgS2Ody9WK6r2aww+4XyxySpzo/r+b6SjXAXvCxF65EgWvhtAukCqzFArfu
	+PE5am4NsBoI8Mjde7gl61N99S9RZ/u0Toc4b78YgTWsLmBM0gggyuMVICGBrogiQ2GzhY7Xk4v
	/aS9HVl+YfvKNTqcqnGwG04Tc3HYcEo9qsFSP73Nd+V6gpqJBexgAMvdryec9JcBubY31f+hhgw
	R+rTPzBMyxujnV/obF14A1lo+NaBU1/+BrgV73H2KGWhTr3cNG1OCYGiURObtrgrZW7hO2gPla1
	drUiYO76yb8oTjTtIfTQ9MRYnn0ZGQFTP+YtMw+qnr11eZVQjslF1ynK+rOeo4pfMUAz0w9HMJ1
	URPnAeXLyauQQAavNjdoyebc6M46ab9omyKuX+XeMeHG7Fn57dNg==
X-Received: by 2002:a17:903:b0c:b0:2ca:6c8:abde with SMTP id d9443c01a7336-2cbb9e2f255mr42220875ad.18.1783207138946;
        Sat, 04 Jul 2026 16:18:58 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:18:58 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 0/7] seccomp: non-cooperative pinned-memfd argument redirect
Date: Sat,  4 Jul 2026 16:18:24 -0700
Message-ID: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3BD8B80002
X-Stat-Signature: 1787rsxdx58acxcf9g1sffapka6jt64n
X-HE-Tag: 1783207140-223453
X-HE-Meta: U2FsdGVkX1+rESfEYIr5sD5IM1Hf4H26dBo2dyfHljh7rwVIFJritHzkEIGLZIAdd15Zxqh8nApRd/V1Bz+qKmA8Jnm6fKfTQSoAg/1Iu3VSZSn6tv4pelCouPcBlI8m5Nni7dKNo6/XOcsLDkYKcgi/1kqSOna1w+Mw++sQ4ch/GI2nmdbY36T5bwKKUv2E2C5kst9D84joAcLfxBKvabAuYzp4/V9Yd1/7zc+uzi2prqh5wrOrXR+/0ZJ6h+WW2z1fGCPr0P6WN/O2EhZbmadQMhJtOxhprnMee9zfzpd7zI3bE9dqlhml83SipVD+nkXkaSVtklNsCphijd9ggzDHHPaDwU6Hh44n0w/YSitlARcOyA8Vvnw7PPfwbSncHFu3G2hG4jFnOSvbjob2lDFgz+cUOpZ+HKEbS0pTWUNdLqLMaZlkh16lt7h97sMSFyvKbZ8Sy1wgrsRMd6UoP3CsiL3mqlsduPzGNFsD/xjCarHc0Vy+DD3kUTYhMOZUssNhEmpGFCoRsjxvukuWMiTvlYWDMjMBwh9lvE9/Tcuj+6NXr2H6XJwnsxNDapB+LZebCIbjEXriknlG8tyNDn2SRRVzHpI+Luwyl1AOPP6iikMvhDnClMrGmiAtIWqzuyJ4D8lG06Fa5habJEAfeGr3XE0SV8fPgnDDoUSV2CwgZ1rC07EKbvbN3s18YhFZWyd/cY7h3cDpJ7s+yZJ/zfuIZW03x2q3yo060nanKcDhJqLAOf/7WgFLN7owXyLaUdWgLSu62Hol4ywCx0iBHdYrGjMKVHHHgBQ9VjRnB5ov44nzGlHgMWrMWJhifvIFziCjhB2sPsGMB5uEfm/rNb5W0MM+7/xAKysRX1nAMEee09EQrXYTBSDNA3BMtbWkJrG73Mz6IDBqoBc9YlhGIbg8t/1fyFPOXQtcAzKZBEJ8jzVUHDdUPXEAAAN5teOT7VKuasKcSErYkdcB762
 VZVBx1Y8
 3sMdNrzT15aX2UYpPcE7a/0OqDalUwRfOEjgZKef/vsm/Q4Q6A3EONDl9c9kkPHAtk+0Lb6MUe0BJTePl7177o7jPsJkV1p1cjrSDR4m3fD2iyEUihb/kptH83oiGAECzY54RgMynrnFyGAijOB3Xz9k1AuhyCmHHVRF0xNjIyif4L4qtTyB8OdAjGLO64opGP5ip8GNIDkpj7J1LhQbwv7xDgWFDdFxzHNH4B1YAPN2NMzAUgO3FATnxAo1Pl3z9B2oVsqqyYTPegdBu6yvrExpsfg9XXICLN9KNrw189qQktTVFNVA6icTFE/RlGw2gjj2qmcF2scBWU9aXzXtXRy8+MwrDaGNCU18y0xDmihzM17lw1xP2pUv846/q0H+GX98Ao9XtT7rT+nUFVYSAQIqC+ExPFJCxEG671V4Ee75GLOgvMu8o1CKm1xQVQUKLF/dxQ9nkE0KNAA19Ygy1kb5GEQCl9GibA8BjfH43PAbnMSI/umRAN4mlxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

The seccomp user-notification SECCOMP_USER_NOTIF_FLAG_CONTINUE response
carries an inherent TOCTOU: once the supervisor decides to let a syscall
continue, the target (or a CLONE_VM peer) can rewrite the memory behind a
pointer argument before the kernel reads it. This is documented in the
UAPI header and is why the notifier "cannot be used to implement a
security policy" today.

The cooperative way around this is for the target to map a shared memfd
and mseal() it during a trusted setup window, so the supervisor can hand
the kernel an immutable buffer. That window does not exist for the common
fork()+execve() sandbox model, where the supervisor wants to confine an
uncooperative (or legacy) binary it did not write.

This series lets the supervisor close the TOCTOU without any target-side
cooperation:

  - The kernel installs a sealed, read-only, MAP_SHARED mapping of a
    supervisor-owned memfd directly into the trapped task's mm
    (SECCOMP_IOCTL_NOTIF_PIN_INSTALL). The mapping is VM_SEALED at
    creation, so neither the target nor a CLONE_VM peer can unmap,
    remap, mprotect or MAP_FIXED-stomp it. The backing memfd must be
    write-sealed (F_SEAL_WRITE / F_SEAL_FUTURE_WRITE), so its bytes
    cannot be rewritten through any other reference either; the
    supervisor stages the argument data through its own pre-seal mapping.

  - The supervisor then resumes the syscall with selected argument
    registers rewritten (SECCOMP_IOCTL_NOTIF_SEND_REDIRECT), the pointer
    ones aimed into a pin. Each pointer substitution is validated so the
    whole access [ptr, ptr+len) lies inside a sealed, read-only pin of
    the supervisor's memfd that still lives in the target's current mm;
    original registers are restored at syscall exit for ABI compliance.

Because the data the kernel acts on lives in an immutable pin, the
target can no longer win the race. execve() is handled as a first-class
case: its pathname is copied from the pin before the old mm is torn
down, and the register-restore is skipped once the program image has
been replaced (detected via self_exec_id).

A redirected syscall is re-validated against the outer filters in the
target's filter chain, so an inner notifier cannot use a redirect to
smuggle a syscall past a policy an outer filter enforces (e.g. redirect
to a blocked unshare()); see patch 5.

sandlock [1], a non-cooperative seccomp sandbox supervisor, will use
this to enforce argument-level policy on uncooperative targets.

[1] https://github.com/multikernel/sandlock

Patch 1 adds the mm plumbing: __do_mmap(), a variant of do_mmap() that
targets a caller-supplied mm (do_mmap() stays a current->mm wrapper, so
no existing caller changes), and vm_mmap_remote()/vm_munmap_remote(),
high-level helpers for installing and removing the sealed pin. Patch 2
adds PIN_INSTALL, patch 3 adds the __NR_seccomp_* syscall aliases, patch
4 adds SEND_REDIRECT, patch 5 adds the outer-filter re-validation, patch
6 documents the ABI, and patch 7 adds selftests.

Changes since v4:
  - Fixed READ_IMPLIES_EXEC and VM warning in patch 1
  - Fixed TRACE re-validation case in patch 5
  - New patch 3: split the __NR_seccomp_* syscall aliases (arch-
    overridable, covering rt_sigreturn and the clone/fork family) into
    their own patch; x86 maps the compat (ia32) numbers.
  - SEND_REDIRECT now also refuses the clone/fork family (clone, clone3,
    fork, vfork) with -EOPNOTSUPP, not just rt_sigreturn: rewriting a
    task-creating syscall's registers has no use case and is unsafe.
  - Renamed vm_mmap_seal_remote() to vm_mmap_remote() and added the
    vm_munmap_remote() counterpart (patch 1).
  - vm_mmap_remote() now bounds the mapping within the target mm's own
    address space with an overflow-safe task_size check, including the
    caller-supplied fixed-address path.
  - Compat: for SECCOMP_ARCH_COMPAT targets, redirected pointer arguments
    are truncated to 32 bits before the pin range is validated.
  - Selftests: two new tests -- redirect_denied_syscalls (rt_sigreturn
    and the clone/fork family are all rejected with -EOPNOTSUPP) and
    redirect_revalidate_chain (the re-validation walks the entire outer
    filter stack, not just the nearest filter); plus error-path hardening
    so a broken kernel fails or skips rather than hanging.

Changes since v3:
  - Split the single seccomp patch into PIN_INSTALL (patch 2) and
    SEND_REDIRECT (patch 4) for reviewability.
  - New patch 5: re-validate a redirected syscall against the outer
    filters in the stack, closing the bypass Andy described (an inner
    notifier redirecting to a syscall an outer filter blocks, e.g.
    unshare()).
  - Signals: the argument restore now runs before signal/restart
    processing. It is queued as task_work with TWA_RESUME -- not the
    TWA_SIGNAL discussed on-list, which makes signal_pending() true for
    the whole redirected syscall and livelocks an interruptible one.
    TWA_RESUME still runs the restore at the top of get_signal(), before
    the signal frame is built and before any -ERESTART* rewind; on a
    restart the syscall re-traps seccomp and the supervisor is notified
    again. rt_sigreturn is refused (-EOPNOTSUPP).
  - At most one redirect-capable notifier may exist in a filter chain
    (-EBUSY); ordinary notifiers are unconstrained. Syscalls with
    complex signal/restart behaviour (nanosleep, futex(FUTEX_WAIT), ...)
    are out of scope and should not have their arguments redirected.
  - PIN_INSTALL: target_addr == 0 lets the kernel pick a free address in
    the target mm (avoids a racy userspace /proc/<pid>/maps scan), and a
    new offset field lets one memfd back several disjoint pins.
  - New patch 6: Documentation/userspace-api/seccomp_filter.rst.
  - Selftests expanded: install into a fresh post-execve mm, stateless
    churn, outer-filter re-validation, ABI/versioning, and a
    signal-ordering regression test.

Changes since v2:
  v3 was a redesign that dropped the v2 SECCOMP_IOCTL_NOTIF_INJECT
  approach (an in-kernel reimplementation of a syscall whitelist) in
  favour of redirecting the real syscall into a sealed pin, as suggested
  by Andy.

Changes since v1:
  v2 was a redesign that dropped the v1 SECCOMP_IOCTL_NOTIF_PIN_ARGS
  approach.

All pinned-memfd and redirect selftests pass (seccomp_bpf: 119/119).

Cong Wang (7):
  mm: add __do_mmap() and vm_mmap_remote()/vm_munmap_remote()
  seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
  seccomp: add __NR_seccomp_* aliases for rt_sigreturn and clone/fork
  seccomp: add kernel-installed pinned-memfd redirect
  seccomp: re-validate a redirected syscall against outer filters
  docs/seccomp: document pinned-memfd redirect ioctls
  selftests/seccomp: cover non-cooperative pinned-memfd install

 .../userspace-api/seccomp_filter.rst          |  109 ++
 arch/x86/include/asm/seccomp.h                |    6 +
 include/asm-generic/seccomp.h                 |   45 +
 include/linux/mm.h                            |    5 +
 include/linux/seccomp.h                       |   12 +-
 include/uapi/linux/seccomp.h                  |   87 ++
 kernel/seccomp.c                              |  511 ++++++-
 mm/internal.h                                 |    8 +
 mm/mmap.c                                     |   87 +-
 mm/nommu.c                                    |   22 +-
 mm/util.c                                     |   97 ++
 mm/vma.c                                      |   35 +-
 mm/vma.h                                      |    6 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1251 +++++++++++++++++
 14 files changed, 2231 insertions(+), 50 deletions(-)


base-commit: 87320be9f0d24fce67631b7eef919f0b79c3e45c
-- 
2.43.0


