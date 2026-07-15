Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4788C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D006B0093; Wed, 15 Jul 2026 17:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68956B0095; Wed, 15 Jul 2026 17:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30036B0096; Wed, 15 Jul 2026 17:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA876B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0122B1C0257
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:37 +0000 (UTC)
X-FDA: 84992280156.18.ED955BD
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 52B644000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m7+2K+Ua;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150436;
	b=L4ik6NFlfnM49OuFRbWQeFJNnMg3eKXJUmSFGzh7NhpwVHkcg0tBRsqTGqtpzCdxKbv+LA
	r9Toch4B7U47W+hGht0oUiPnzEIVpfFKugk+yFTgy6/puvtEa/At9jtX3SqYDOPIqNBUIv
	8T5+HsJ4i5YjjcaEztVLoMSl2phSFW8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m7+2K+Ua;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uvApJC4hlWJ2HRy6vNlmo9w7JR5aRmbiePyhaflAwRM=;
	b=N90QImDhhCdFK4TXedAqxmJv/0bfuNTk8oWtzouT9r8IwmNONWZwFzgpRUavNWFzfhVoaG
	HbiZn4nw+1jYJhzbLTw2QTB9nAICErmv2NsyDzqOs4L+go0mhDYSkvQLWGFe7np0EnR+6l
	z17eDw4sJG1GNZVclLVfy6jS99oxUYE=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-caf45fc5202so3429802a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150435; x=1784755235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uvApJC4hlWJ2HRy6vNlmo9w7JR5aRmbiePyhaflAwRM=;
        b=m7+2K+UaXfa9WvOAfhcXmWO/Yxs1ijbIl1g63dHqD9LNeMNV7PYlvmQ5hJJiaa8o7w
         gBCjd8/znp1dFvD01ZY0wSblhXMb5cj2bzcwupv/jHNv65jxgxjvfxhais9i5JotA8at
         XGP+EjJEzSlNS3Hrccbwpqhaf3ZX4hpWWBXu9AC93a/dMfAMaLBTMrlONAJqztcSuwvU
         GH4Y5pNDF7vFheEU9YT5B4rbPFraShIPJbUHPSgj9ejXMWviIqOCIXhChy7Zex47ExRE
         nw+A2BxZi2tbcSGivm5c5IAOGh6LR5VvTJGzDDDw8oQYuU8pVu5BfSPbjH7TDHgmeGef
         M3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150435; x=1784755235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uvApJC4hlWJ2HRy6vNlmo9w7JR5aRmbiePyhaflAwRM=;
        b=jbRynod2XXkM7QYKnn9v0DzxWmakL9pllsyuWZC8QxyKNXpiJAck3uJvcn4S4ZsHRe
         luABUn7+cjAlwjyxFAKuimFtj83acaNU3hjA+DSab39ciTIfuDGUuPHINtVToX3PndBh
         Eon2nGT5ThcYtCUSPu5pGGoVlMIqT2BIus8l2wSv/Z48X9GseKs6zzUg291XXOqHmLs7
         97y31koQfZS9B+sV6Dm9F/QexxogHRWCTGWgDC3WqEtGaLpY8tg4r24u3fbi8pb40o/w
         4i6v4dryIw8HmHxShbFIeFfBHgUpmqGfsg0HzKnlPocYtnY8qWUTFaf/lyupBwiVz34x
         Smsw==
X-Forwarded-Encrypted: i=1; AHgh+RoSoMApM7t1oHlWS8N1OG2lbZDmYvS8qOEiTfElmJc2gJclzYtoyOXq6MO49r5LAwfVT5VflzsmPw==@kvack.org
X-Gm-Message-State: AOJu0YyDpmwdp4Ha1tNHyyeLNF88aPOBn3+PtXhh1p8z3B2/6i2gct5c
	GuQR1qPZhblCFEqTWGyWuFZGPmklPmt3C+IVpz10Lf5+FA/y6567Eg3f
X-Gm-Gg: AfdE7cnbNxXRO/IcVWXFNTJ1m9hYPC/zOoN+TxJO1pw+Od9o4zPue7u4EXJqgFVXcf6
	lFXLg+bg10yH+Fi27MroRVxhHaFABxtT4Hl5sSB3Lfm2lez0xjxzh4qxqvMgJbNpv4hDPC+KVfD
	iJkFiSC4TUGJ67ucKkGV2Jkreafj5qtwzdNJ4DG7K5T7nLPyHhFY6WN8m5vXXdKRIcW0JLDOYgE
	Pdm0sLtd+ConNdhzqZmmpSz1x3Frq+Consns01Ch+BV7g7gkru4hpoEDXrwlsit0bNjMNotxYEr
	7/OZT1apykdXU7wEgF0FNCWiDUKj15B3HN7vXjMejwSWY/WyHEmx4z86Jznr+dmzSy7x0eHsU+S
	AnNXXGLAKqk5ChrfrT7h2pDYO6Re0Vo03zDjltGFRwiB/Neu3dhJtBZra3K0DKJbVGpcx5LlOfd
	xsBodKS3Pq8Y2R5OVTe/7jdM9456i2FHvzFMBvN715hXk8CsL6dF5xLmU+EQ==
X-Received: by 2002:a05:6a20:c6c9:b0:3bd:3800:7538 with SMTP id adf61e73a8af0-3c35707e50dmr8171448637.33.1784150434746;
        Wed, 15 Jul 2026 14:20:34 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:33 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>,
	Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v6 0/8] seccomp: non-cooperative pinned-memfd argument redirect
Date: Wed, 15 Jul 2026 14:19:59 -0700
Message-ID: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52B644000F
X-Rspam-User: 
X-Stat-Signature: u6m95gsr5sniyckjhjg8f5wh1wf3wp7c
X-Rspamd-Server: rspam03
X-HE-Tag: 1784150436-404361
X-HE-Meta: U2FsdGVkX18Qj52/cY6LSkUrkfZfadQbER1cN9QJAOh3zvTcY6WoPmqW5lpReMxmvWANRpm3hMYzzs5IfG7w14th0fBBfkJqK4Tg8OJrGfx4ngCcshxiYx4KeCOmS8YG5JYBQiNtwVxkKmXnyy1+PDoOqpOT6SkHzK4QEJM5U7+BRwyBUKGuCSsM6GAvs8P6bNK40vsbdTondgCYN1mYhAYI89X1KPfrUaMNmz6JaB6r0kM0M8WHX55KpToA/MZ8mqk9V+WUs8acwbaFi1E7tEiIWRbfPp99DDEaqczcW0F6K3Ubdzzvx6v/IxpTH3kOjSZ6f+WNfPehdcYfVLLBbBXjZ/nDOnsrUuk5husQfcnQ3CYMaEFQkBxyCNOWfCFE9cky8OUjt9mJHHwgCViOlZAHBIXr7rcmVsbZ7mZ0pGc4JnkACSDkEnHTXQvVIVT8aVdZCsBMEeh3WTdahh19itxS2NbG9r9iMEOUfqTGw+7juxDmNwglhKhbnES/NkUh1C/4/7pXR+LzeZUghUFLKF5PCI8Q7oCU4TjbRT5Zm911scj/5ibIEgVxXeIWmY+aKXg/yvgkYbxvU6X0u0yEZF/64Ktsff4kTGuXm3zrsxGy5qnAm2706nZPNo5XxrHamoH+kVLLj1Ot6govZKt9/7GIlbK77tBRzavJphIudnOWMa0C9VSDy4OiJb+4iOhzS6TRQgWoUjB/qX8XtfVYGDRjrOiQOsYgEZdU0spvbOor6IDRMmXIgy+n0qnyCW+QvCWkMZqK2hUdHmd9x5aZ9PZs4KcDCCQomRwGxiU3HJ5WpmjhHUcIIgGOATl8CFVdf9OyTIx4IGDltyc2L1Ht4P2c9Sq/Gf+XuknkWjvqgqPhHYpKaulCnTJQIbkeZbWlRLk8KyQRDS63ksLVRkfDQVSBTBNNeakAFFtK5GfF+yySPAeX8Cy7Qv6i4tbJxDRDCDWsoxYvxQ8kZh+fK7H
 5t9ePTKr
 osiagSM55ldCIbqw3kekQVrzALOS1xA6IpLAPt2Dqfja6zTqAtAf+4Wk6awTU++QwmFFqfmP0MMRB/dmta1jq3D28i4tXfvNxbozK1T4haw9kehtL0JgOK9CppUJ3ff/1LYDgnKLuI2LTh8GTIaj9iulUb2c5YploUcRRd/hk2vGerPmPbS3nTcHz72eAJP1u/gg0B7az8PazMWuyvajJUN/GTN4QsgJA4OCh9i3Bq1p9I0yZLy7cbCz9rV7VZz77APyHeWAjsm4zAGjHAQ0z+6qy/ndh0rsE4XtxFGPjs8vaCNEL9jS6DABUjLHEISqKXPqqRNRw4f1CguFYEU06Xc8XkophvdevyHHbU4g8R/SCWFVuGhhVOG0GTohAQ6M3l/muD/SIRTrRXcVRcRekEbKZQRMQhVM3sNBrXs+xq82BQ7gXUKYV+h/MHIdOLDlRSPaGnjQuf8M63yDpJrfgMkHLGXwYBRnocwxHtZs5Z7vsW34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
to a blocked unshare()); see patch 6.

sandlock [1], a non-cooperative seccomp sandbox supervisor, will use
this to enforce argument-level policy on uncooperative targets.

[1] https://github.com/multikernel/sandlock

Patch 1 passes the target mm through the get_unmapped_area family, so a
placement can be computed in another task's address space. Patch 2 adds
__do_mmap(), a variant of do_mmap() that targets a caller-supplied mm
(do_mmap() stays a current->mm wrapper, so no existing caller changes),
and vm_mmap_remote()/vm_munmap_remote(), high-level helpers for
installing and removing the sealed pin. Patch 3 adds PIN_INSTALL, patch
4 adds the __NR_seccomp_* syscall aliases, patch 5 adds SEND_REDIRECT,
patch 6 adds the outer-filter re-validation, patch 7 documents the ABI,
and patch 8 adds selftests.

Changes since v5:
  - New patch 1: pass the target mm through the get_unmapped_area
    family, split out of the old mm patch.
  - The __NR_seccomp_* aliases (patch 4) are now gated behind a
    SECCOMP_ARCH_REDIRECT opt-in
  - Reworked the re-validation (patch 6) into a self-contained walk,
    seccomp_redirect_revalidate(), instead of re-entering
    __seccomp_filter() with ugly goto's.
  - Selftests: two new tests. redirect_outer_trace: an attached tracer
    must not receive a PTRACE_EVENT_SECCOMP for the substituted call
    and the target sees ENOSYS. redirect_outer_notify: an outer
    listener-less USER_NOTIF verdict still blocks the substituted call
    with ENOSYS.
  - Fixed other reasonable issues reported by sashiko
  - Fixed document warnings reported by kernel test robot

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

All pinned-memfd and redirect selftests pass (seccomp_bpf: 121/121).

Cong Wang (8):
  mm: pass the target mm parameter through get_unmapped_area family
  mm: add __do_mmap() and vm_mmap_remote()/vm_munmap_remote()
  seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
  seccomp: add __NR_seccomp_* aliases for rt_sigreturn and clone/fork
  seccomp: add kernel-installed pinned-memfd redirect
  seccomp: re-validate a redirected syscall against outer filters
  docs/seccomp: document pinned-memfd redirect ioctls
  selftests/seccomp: cover non-cooperative pinned-memfd install

 Documentation/filesystems/locking.rst         |    2 +-
 Documentation/filesystems/vfs.rst             |    2 +-
 .../userspace-api/seccomp_filter.rst          |  109 ++
 arch/alpha/kernel/osf_sys.c                   |   21 +-
 arch/arc/mm/mmap.c                            |    7 +-
 arch/arm/mm/mmap.c                            |   19 +-
 arch/csky/abiv1/mmap.c                        |    7 +-
 arch/loongarch/mm/mmap.c                      |   28 +-
 arch/mips/mm/mmap.c                           |   28 +-
 arch/parisc/kernel/sys_parisc.c               |   28 +-
 arch/powerpc/include/asm/book3s/64/slice.h    |    3 +-
 arch/powerpc/mm/book3s64/slice.c              |   28 +-
 arch/s390/mm/mmap.c                           |   25 +-
 arch/sh/mm/mmap.c                             |   21 +-
 arch/sparc/include/asm/pgtable_64.h           |    6 +-
 arch/sparc/kernel/sys_sparc_32.c              |    7 +-
 arch/sparc/kernel/sys_sparc_64.c              |   32 +-
 arch/x86/include/asm/elf.h                    |    2 +-
 arch/x86/include/asm/seccomp.h                |   15 +-
 arch/x86/kernel/cpu/sgx/driver.c              |   13 +-
 arch/x86/kernel/sys_x86_64.c                  |   32 +-
 arch/x86/kernel/uprobes.c                     |    4 +-
 arch/x86/mm/mmap.c                            |    4 +-
 arch/xtensa/kernel/syscall.c                  |    8 +-
 drivers/char/mem.c                            |   15 +-
 drivers/dax/device.c                          |   11 +-
 drivers/gpu/drm/drm_gem.c                     |    9 +-
 drivers/gpu/drm/drm_gem_dma_helper.c          |    4 +-
 drivers/media/v4l2-core/v4l2-dev.c            |    3 +-
 drivers/mtd/mtdchar.c                         |    3 +-
 drivers/video/fbdev/core/fb_chrdev.c          |    3 +-
 fs/cramfs/inode.c                             |    3 +-
 fs/hugetlbfs/inode.c                          |    9 +-
 fs/proc/inode.c                               |   15 +-
 fs/ramfs/file-mmu.c                           |    5 +-
 fs/ramfs/file-nommu.c                         |    6 +-
 fs/romfs/mmap-nommu.c                         |    3 +-
 include/asm-generic/seccomp.h                 |   30 +
 include/drm/drm_gem.h                         |    3 +-
 include/drm/drm_gem_dma_helper.h              |    3 +-
 include/linux/bpf.h                           |    3 +-
 include/linux/fs.h                            |    5 +-
 include/linux/huge_mm.h                       |   18 +-
 include/linux/hugetlb.h                       |    6 +-
 include/linux/mm.h                            |   31 +-
 include/linux/proc_fs.h                       |    5 +-
 include/linux/sched/mm.h                      |   37 +-
 include/linux/seccomp.h                       |   12 +-
 include/linux/shmem_fs.h                      |    5 +-
 include/uapi/linux/seccomp.h                  |   87 +
 io_uring/memmap.c                             |    8 +-
 io_uring/memmap.h                             |    3 +-
 ipc/shm.c                                     |    8 +-
 kernel/bpf/arena.c                            |    5 +-
 kernel/bpf/syscall.c                          |    8 +-
 kernel/seccomp.c                              |  571 +++++-
 mm/huge_memory.c                              |   27 +-
 mm/internal.h                                 |    6 +
 mm/mmap.c                                     |  132 +-
 mm/mprotect.c                                 |    2 +-
 mm/nommu.c                                    |   27 +-
 mm/shmem.c                                    |   13 +-
 mm/util.c                                     |  106 ++
 mm/vma.c                                      |   62 +-
 mm/vma.h                                      |   18 +-
 sound/core/pcm_native.c                       |    3 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1615 +++++++++++++++++
 67 files changed, 3025 insertions(+), 374 deletions(-)


base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
-- 
2.43.0


