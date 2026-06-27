Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B91AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4566B0098; Fri, 26 Jun 2026 21:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D860B6B0099; Fri, 26 Jun 2026 21:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73C76B009B; Fri, 26 Jun 2026 21:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA906B0098
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:22:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F6A1A0625
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:50 +0000 (UTC)
X-FDA: 84923943300.18.3C33DA0
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60AD6160003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JYeJSnZX;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523368;
	b=YJ3wUbsqjG43TIVTetx9fVkr6YGDIzw9/6FDXj2BhYKW/Inorz3wKiuZASYdpCnu5lH7ne
	diTRVWjKPatbx7ilsIx68g5hJfuG6x4qqq6328AfM5933npzS6PUNmKotl0s9hmERKAMkl
	IFvw4Bd9cfFGXQAsAGkeYpEwgXY8f30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yswF87AdudNlkEgsV8oWfEZga/XYLwGngCoYmrqp+BI=;
	b=VLDRXaDXbdXA6Leoe6v/sUncu5n8u/XHqrY7mwIH9Y7R7G8q3HL/r8zTMWUXQld201LZAc
	Z5RZy0zKDdsCsd0niEflbnaWLVyfRs9pIzLcNfgvHw+KsovB4TOJEwr+7EH13FHHnPC0NR
	nKLIpkAjDf8ADj4ipsGcdXJHuhCfHOA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JYeJSnZX;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-30c52f96f60so3296686eec.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523367; x=1783128167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yswF87AdudNlkEgsV8oWfEZga/XYLwGngCoYmrqp+BI=;
        b=JYeJSnZX+P00u5YSDxjAWtAnZDPL9eyjY15BwUenD4OLwWiVqOJuUNbZC17zFDpJvn
         F0zTpgtO35iOMOafvnPT3FobTE14L1Ple+aU+b8Iah/eZ819shLrJCcXNObn8lqoAt5S
         IK2DQ/lttesT9+04LSdK7y4p+j/mEyZoeLBMaSKNkDyqgKtr8/jnDq7xJCJDep0oJeeE
         VU/z/ykLtINCuIrFXLmTjca2gzgzFzNDoUlnnLSNJ9m/1G6PXKuqYtoD17EDzb+aYPHa
         WaEJgUStK5u8fU6BWZt8QChR6NFBfW7hM4rntM2y9xxBDzfRtkgF9IZjcMKpEH+bfoh3
         E8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523367; x=1783128167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yswF87AdudNlkEgsV8oWfEZga/XYLwGngCoYmrqp+BI=;
        b=TZJJu1XzrRXzvTEJ1qzn0hs08v2Bj3QTVyXb78j5GTLHclGQsUNIkUFYfl83uR6qPy
         wu5cZ9Ks2MlUiJX8VV2C8kP9sWOpktF3P2F8KKj6rrxjtEQNudfNrV3HCwlt6kX4tShs
         Ix9zyyMzEeLL6STWjxBPw5r78dLVrNGhTQtJGJirBCjr8MLrHzlEvh5TJL+W8+EkOrVw
         1rhS+xpn5SItJX1mkctMwIByP/H96wg9648Klf1tImzKHnthh/9teEkDQx5uKUDRofuK
         spq+aXyUZiY3L2qLPBi7F2x9b4H8y5C6z+l7eZrnG5BtVYvfpasoQ1bvXv8Y9YFN2nVw
         mQeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpgC4Oq/bwngp8maJkvL+fYOtqkUeuZHjSr/rVXH4s1n2twuJXKNN0xbmsCWQSUd+t6dtQBTn6R/A==@kvack.org
X-Gm-Message-State: AOJu0Yyd5Oq2VACP9OhqX9HxpXNVmXkJUoNRAVLoS2BdPNECPSKM1NEd
	o483f3S44W7QKS+BZmCSBWCaJUz90iyD53i4caYOZu6aMZERxezUHNaV
X-Gm-Gg: AfdE7clS0zYIRCbdHQGsbpJqbeGzcJ4VIdHCJj2I+8c4R/89Dv18QwmKRIxyXK46Rvx
	rPxfBh8wfXDyPU+WdO7z60MvxZbpdjDdKLw4zDj80GSjMpL9zJxiMQqxFfsnSKjQ/zMIS31XbQC
	RUVRVphMAMXfHk84Dw1zziJF8H/vCX6Q+dh1Ipf2Naqgzy8J5YmaA8EZWn5GYAfaqFoW5wqTbpe
	9kNmb4cMc7cQOIO8SxEJNUBPe9t1e7AyKf7FMaAN1htimYAL9xvr2QUhQ9Bz6AjE7xuqixBi+/c
	4GR5GcGYlwsOsfsb59LrNsxyj4+hkNgTZgSIiClRsuKoJRPQW7KfhM1UzUbRQnWkH5QaJwlMPSf
	ycORmd2mnkudRd93Huyg8XwwmcoVIP2juWRlxLqsucGZKlN87bh1Fs1xMamELkhf4r0lcbSnoFs
	HQUXxdGeciQVLeLYkvDLS73Ojg9v3cP8xDxgXiDhQJhNGG0ypB
X-Received: by 2002:a05:7301:5f03:b0:306:f474:7389 with SMTP id 5a478bee46e88-30cab36ed99mr2110787eec.25.1782523367053;
        Fri, 26 Jun 2026 18:22:47 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:45 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v4 0/6] seccomp: non-cooperative pinned-memfd argument redirect
Date: Fri, 26 Jun 2026 18:22:13 -0700
Message-ID: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mknkdux8y11wsi1trmf5q7oswcdgj7au
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 60AD6160003
X-HE-Tag: 1782523368-221424
X-HE-Meta: U2FsdGVkX1/5u810WUv9q8J1xXz3LwNmzcvDjtxtdYD5PisY7OwcixmBNsDElu45nbdXaxzRgMq3KIfSLxSTzrzNCErJKIi3VuVP1oZ+vVPD4PJ1dQPoxW491K9AP7ceKy4lZ293PiC7VlF0F1WuMMUxy3hcPLbnT8UYZitI5zViDFUjQQdywhVNkUKpJZqJuFdkWC2pbd5wSkZD+xxiVUl42/4PnkNL/d4FHD17UewFpLuDb6EIXROfadCCT13/h32xlEkwIik2QB9hXHOWrJLNoyh30TBEYmud2xxJfP6Y+4bWaCK6xl24qgKhR1yw8PuBxTcEXe40JDDost/vJMznDkXYYgx2WoVs4G2QqAfhNc0s4DyxcxMUkj38V8n4cnW6qItLFZ422K0G9klYH0tJeeCqf1f9ogDqbnEJa01WnZCzmJPyHMmwbS+IoBtCkx/A4YoN+2FmuPsYnnRB0eel2kXGKzuckKNhsk9HSV5IfVA9pHvhlCmZT0Ve7QvTpHVRUvZyOt1/EBU1p/hV8A+RNVvDlX6petOW3v6BhOmHWYp47a57Rh7xs6OEs5DX2vExTO92AWkYwjhZPHSdnKJMOL+paul0Hv2QmmXLZT93kT2ltwhsahUHYTKQPv8uRzg2DRf2M/RM4Xpk/We3yfCcUFMIRCfP+bJfWxUDkroJ1U5AfP3YANBVEJ0EHALNRvjrD+yeHXh04ihFZmBgQhhjyvqGm+BasCuf6BL1+s3HN4w5pnZoYjewBqA2UZZaxxr30jXoVryY5oVhvysOH/yXY8Ldu02CqMvn8bUFi+9FpHMfoSHJx6t4+v1gvEZPSgbenQpilxhU6WphvT6nek52pUi8N44uIcbpkg2zXrAblXW4t3yroUZjDkCZyRfMtIHrA7V5PA/mWdso4Y6ut36STC4hp7lVTw+fytUZsSKIxhiF1i0oynMd3e8Nt+uhaQYZlLtT+lQm2mkbQBX
 MCIvk6as
 VkCxb+ZdJTSpTkVaa/A9QuPyisu7cusVRIodPAkj42abuRy2I1M62R78P7A+Jl782+q/b/5gctdorsU1Gpv7sfdjXG3OeSbGDQVzc4F5r6bDSHYjxjTT+RKj5y6CGvZ7dgrvKPGRAtiFF4TA22YrjZIQ5qu2MsulCgllK6OQkZRUb+0O7mXWWHle7ENuTpgwGbKLq6w1MdWB6j2TbxYSNuifNoyZwvp2VFno38fNUyOQpsWBYxT9Z/kVKh+70HrKhVxbkhFD74Iy0cYg6Gax2AsJ0ZXd6QZW9MDgeUICN+Z99Lhoh3qPybie9bvQkBV4pzAc40KyhKorFse4L3pR1jX7Mceo/qKtbHDU+9JuN73JXgBc49vFCWKjA/qlAo+FTyEALCAeEtU1miaYtvRbJz5mfyw+HkMzLlqXbD9iz2z/TmjlNcuX72ZQM5SRS9C13lZP0tgiMsxGGe+OkStj+kQ2gW0cqAzgLhhTghVg97CykhVZiHcpoobOEBtS8dwnq9oR5DrLLe/vBX4xmGdKZP9NgNw==
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
to a blocked unshare()); see patch 4.

sandlock [1], a non-cooperative seccomp sandbox supervisor, will use
this to enforce argument-level policy on uncooperative targets.

[1] https://github.com/multikernel/sandlock

Patch 1 adds the mm plumbing: __do_mmap(), a variant of do_mmap() that
targets a caller-supplied mm (do_mmap() stays a current->mm wrapper, so
no existing caller changes), and vm_mmap_seal_remote(), a high-level
helper for installing the sealed pin. Patch 2 adds PIN_INSTALL, patch 3
adds SEND_REDIRECT, patch 4 adds the outer-filter re-validation, patch 5
adds selftests, and patch 6 documents the ABI.

Changes since v3:
  - Split the single seccomp patch into PIN_INSTALL (patch 2) and
    SEND_REDIRECT (patch 3) for reviewability.
  - New patch 4: re-validate a redirected syscall against the outer
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

All pinned-memfd and redirect selftests pass.

---
Cong Wang (6):
  mm: add __do_mmap() and vm_mmap_seal_remote()
  seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
  seccomp: add kernel-installed pinned-memfd redirect
  seccomp: re-validate a redirected syscall against outer filters
  selftests/seccomp: cover non-cooperative pinned-memfd install
  docs/seccomp: document pinned-memfd redirect ioctls

 .../userspace-api/seccomp_filter.rst          |  108 ++
 include/linux/mm.h                            |    3 +
 include/linux/seccomp.h                       |   12 +-
 include/uapi/linux/seccomp.h                  |  126 ++
 kernel/seccomp.c                              |  446 ++++++-
 mm/internal.h                                 |    8 +
 mm/mmap.c                                     |   63 +-
 mm/nommu.c                                    |   12 +-
 mm/util.c                                     |   62 +
 mm/vma.c                                      |   35 +-
 mm/vma.h                                      |    6 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 1027 +++++++++++++++++
 12 files changed, 1874 insertions(+), 34 deletions(-)


base-commit: ab9de95c9cf952332ab79453b4b5d1bfca8e514f
-- 
2.43.0


