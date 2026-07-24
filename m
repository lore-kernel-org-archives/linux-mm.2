Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2088C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D666B007B; Fri, 24 Jul 2026 18:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE696B0088; Fri, 24 Jul 2026 18:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE066B0092; Fri, 24 Jul 2026 18:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1BE6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFF70401AF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:18 +0000 (UTC)
X-FDA: 85025044356.10.DAEC766
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF4284000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO+79Yg2;
	spf=pass (imf17.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n6CRZO4TQnwktiK+/QOoKau6pbWNZvFfGLDoCZ5eJ/I=;
	b=R1gw0hmEmeeUge5BzuVb/CaAHHxx5ULvrWyjDET2/B0eA4vR5hi0mjykSPkc15ElAzNcsK
	BdWUJjk6cIfeyPVJx6o8+749SqFija8wNKXybTAu8UWemlrW5rYsLfRum+oDk/mbbDwfzz
	fHRy9RZaLKBUE1hXaM6xSfPK96fNHFM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO+79Yg2;
	spf=pass (imf17.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930536;
	b=VwJphgtBfvJI+Dch+SHVtyi9qiQ+IkcEtdQKqULxE4SMgZVaqG8GHRJtTCpWEQ1ZvlRY+j
	pGYB/v162oGw7zDezozOIxP6IYze/snoP4tn9PGCJ88sCmC3ZyyFTMEfGaFkwJwekAqeQT
	e8iojpZ2oWO9wtfwiM86/LQRFk7r4Tw=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so648084a91.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930536; x=1785535336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n6CRZO4TQnwktiK+/QOoKau6pbWNZvFfGLDoCZ5eJ/I=;
        b=iO+79Yg2rSxU5o74URgWgZOQ8brmW/TbDYSogMRkc+0GXN0nfqXJET+D6cF6q1n6Hv
         Nz00A2UwmO3OKBqi0u4PU26Vduovhzc+aBpuHRXTAKyDKbYXa4rxbgZhHyX/iCpvbENY
         48fwqi3oc5feo4Xy7kKWJpMWtB+jjdkrS/mVKiiawfSGru6KrPVDEq7g2mFqFUbFe2jg
         ytlNfPtkLaw0vXjqPhE5lexVF8FuB5M+GYSDr6LCIFHd2otoAaySG9xJQcyU5Rn6J7xW
         RmuWXk6EPKavr/SAP+kIgd3ERiSK1duSaIHn9Z3JHuyJL4DC/Ggua+6z7B+bywM1wlT/
         DI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930536; x=1785535336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n6CRZO4TQnwktiK+/QOoKau6pbWNZvFfGLDoCZ5eJ/I=;
        b=d54Sf5p0/xanYgolKHZ+zu4Z5LQ5xE9+QvoP0miZMeQjcVeXWaTPIdFVIWVadslYuU
         TQY1ipN22+3rx0ZWd2482HW9FWO3sVq1AZxWnpmHOZ/jzDWX+RwZHf2Xr+2sPdosqwwv
         oLQVi2bTbYijf6383o+gtUXvXXWNbDLsiSDs0k3/h6YC37DzRmItC5U6J5N6RFbWmJe6
         pEEWFY1KLL4EwhIJT5bEyx4TIK4mhipYREqKi4leXC16G+eghkxAYOhDAPRUwkcgt8jP
         93fGY5cBYDnqf4kpo2xW8zcsS6ax95FkRYo0dLrRdnNNR/o+wsakOXxD+ujx12LSWAix
         azFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrAyOWD1HJhacaynoouABzaSdicrY0g6n6v8bTdrhlqYCl82aKZ8PXJ3CLQu1hLYhffXbJz02+D6g==@kvack.org
X-Gm-Message-State: AOJu0YyhDARsfPbpmBFNFI4S1WMhxQjG2Y3we6RSGObwSkZEMCI7808R
	jM/qlg/49+PEqD9QSFhakWVO+wuPwqXX2qKCMmHoyc/IpeDnQ6Flf9qh
X-Gm-Gg: AR+sD10p970sEe1qP+HiHGUaLDVa4Yf1AiHmujC1+vH0mvfd9C/JpxA063Atose87XT
	ueVwZ0+6Mhd5fVpx0Q1tkxJTU1yKqDfUwB1GjyymD7h4oF4WYBemfdg8JtA7Q9O1N5m7rOSyNyG
	26QUBkL8OpXh2lAPVIlLLbzxoHsFqpvPawNOlsQQKXRPcSdzxeihjP3l17WaAg6btfF+E+OkZfX
	o/JBp7cBsaHH77fYvwqMI+eZCCJiF473npTGmP7JgOx0Z9G5DjDXuh2uPGaDdasrqXQXl6pIkC+
	V8QgcInz3kwF8edl+Apck2uAMRP5XcHZgLNKcxfS62FsI247avqTCorDKwYh30fbq0/gWZ4ujox
	8qKVGxNe8dUiiLThqGwiDejOzIomvnPeIYXgvn5nRooYzL7/srxT3eXQKv77NzZcFwIokTcW7T+
	sJIofInOul8pkri908XemxHEWBqMim0Pt9axPRk67xl1a20Y1YyNCJh7essJYl
X-Received: by 2002:a17:90b:55c3:b0:381:5a08:6291 with SMTP id 98e67ed59e1d1-38f29612543mr164935a91.20.1784930535581;
        Fri, 24 Jul 2026 15:02:15 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:14 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 0/8] seccomp: non-cooperative pinned-memfd argument redirect
Date: Fri, 24 Jul 2026 15:01:39 -0700
Message-ID: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF4284000A
X-Rspam-User: 
X-Stat-Signature: wdoha6e3otzr1sf5ftwekpnzzswkjgng
X-Rspamd-Server: rspam04
X-HE-Tag: 1784930536-350307
X-HE-Meta: U2FsdGVkX19zlvqKgKzQqRh68d5PDLPj5uzhh75qeKFshH4lAwedW6nIiuwDWSlGqicwnwk/D1QDzxGNHc9P44CdcBHFz1UNUf0JBuZASzapHPBpy24Wn5jivi4I+kjTh08nq/wUsuXK+YqnURonNNDldjAcEM+MDlu3EOybbLk45hpJmEb/fSldA+H8m8PKnY7JIEM6z7AD8UZX3EflJmJT7d3KVXYBbWqZq1bvbPj9vFldQM8eTcihpW2fkFfJeQ+WdzBL2DrDXS4xktDzKQQ139TEAvmIzf//PvT/i49GSxOy8p549diu8A0sIVeFFcnG26RHScf0wo0Rf5fsEOg8owZBozRcy1bvM86XTeTTrtwwRjHiq/iC9YwyrKVrxT4i+BzwMFOVfSCJPd6ZpkVG1sxslrTCYvtaWvUS9cIhyXq21W0LIPI+7YBvfGkibJaJNyI4xvF4sdmYBymnxfRLXa0/JT+3qeG6dZToX77XOxlYzXBZaJSL6eEa1MBudT+z+Z2pGA7DBlGz5U+AdeUqwQH6pJxM2otwpqXemVfyrv+/ZZCfHw6WcnEAitHRANMXa9iT/Ha3iLFR9uqNC5y9qftEh/jKRB5ymd+4Rmnq3gNl18GCGwibdmoBJkaGX3FpQoS5SCw/5hNxmhqAs9vtJS76ImSpQDRSwaxQWkXbim13AxZfY6sTl8jmpmoOJOYyRb/+Ntko2OOQXloJp2cH2GM42fXZSYsZVq32nti6bKsi1YTfeOdJIhw94BOjL7QrwpuF/Wta+gr9tJ7uThDvXCGk/phFTi5/sqr076ZTtz2/8bTN3IRPAYwN2e6O4fNUhtoB8GD5rUsdRdsPDydzKN9Njhyl0a20740WsSWqb0WbrUgFZB2fTDmRXPOBVWNeQYh8dImjmFabdiW3ZKXGaFE86rS37lvyYxViXr58otI8ZrPr4lGUsBzKQIXmhdNcT9xYmJ8CAewJoQl
 r+JOzOlc
 4OeS2efuBPPEDpHC1qSAx6lhySaF1g5f6NS97CREQQiYJt6rQhZFSlhb95jLSWxksuiO5iYgf7hW+k8OH1gTmBcYciGKhiw7BRgxCMhvS1kR/uCF0unIkffyKmcqw1JCp/1qIu4Nf6fSswoUG8+VrRFkYAIXMgjqLstts5z2uMuS9HgOPCDbKTAw+/9wxqHBYP4pBojCZJ+SysPysZJoILPqGTn2VntXs2s0e9eASEc+J1O60GMlDvd7/pC7TvfYpvrUSNjWCtjMQfkMCwZSgoTw15Wb0boV3BD6IwrxMnl9Hw0XCRar/jkoJCOtbg1UyfeO5sg1+MF77aGP0Gp+b56382qkdcspLMeVqIJ75P0ACW0wnp+ObBZNwchHlTJRPeECQQOSFugqEe9W7FyzDPHsEioYVzSZAMGAXWWpFAl86J3UjfV8pHt8ZmLhpSIoVD8iEuQcwrnMEWdTjwtu9nk6Z4FOuZDSoSVaxb72GhwIIxPLrrmIKt3Yu4w==
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

Changes since v6:
  - mm: vm_mmap_remote() now restricts the mmap flags it accepts to
    MAP_SHARED plus MAP_FIXED/MAP_FIXED_NOREPLACE, refusing anything
    else with -EOPNOTSUPP (patch 2).
  - seccomp: PIN_INSTALL now charges the pin against the target's
    RLIMIT_AS and rejects the install if it would exceed the limit
    (patch 3).
  - seccomp: seccomp_pin_check() now takes the target mm and
    mmap_read_lock once, validating all redirected pointer arguments
    against a single address-space snapshot instead of re-locking per
    pointer (patch 5).
  - Selftests: skip instead of failing when the kernel or arch lacks
    SECCOMP_FILTER_FLAG_REDIRECT, so the suite is clean on non-x86_64;
    fix a SIGPIPE on a target-attack failure path; correct an inaccurate
    comment and compact the per-test comments.

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
  - Renamed vm_mmap_seal_remote() and added the vm_mmap_remote()
    counterpart (patch 1).
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
 kernel/seccomp.c                              |  587 +++++-
 mm/huge_memory.c                              |   27 +-
 mm/internal.h                                 |    5 +
 mm/mmap.c                                     |  134 +-
 mm/mprotect.c                                 |    2 +-
 mm/nommu.c                                    |   27 +-
 mm/shmem.c                                    |   13 +-
 mm/util.c                                     |  117 ++
 mm/vma.c                                      |   62 +-
 mm/vma.h                                      |   18 +-
 sound/core/pcm_native.c                       |    3 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1569 +++++++++++++++++
 tools/testing/vma/include/dup.h               |    1 +
 tools/testing/vma/tests/mmap.c                |    8 +-
 69 files changed, 3011 insertions(+), 379 deletions(-)


base-commit: 48a5a7ab8d6ab7090564339e039c421f315de912
-- 
2.43.0


