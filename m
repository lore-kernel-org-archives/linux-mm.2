Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10241C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90D46B0088; Tue, 15 Sep 2026 07:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41956B008C; Tue, 15 Sep 2026 07:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C327B6B0092; Tue, 15 Sep 2026 07:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EBB16B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:31:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 225F6C03C3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:24 +0000 (UTC)
X-FDA: 85215780888.11.4B1C005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39C71160003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:31:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7tiikKz;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789471882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CAJtKPFKPGeuK6/4FcUJJhXpcyxiLyxrGeWoP03hjX8=;
	b=kPGdHrgMuo3tC3vhtcgMVvjtXVV8aWYYik3gPE/FcaU++apElSOpkaoBFMWhaPve+B2rIX
	mAROMF9Cy0JvThoOXPC6AAptSOJWXuVLDxrp05O99Fo/cNuw3yUdAshKTcqzwtONGbxrSg
	z5pdnXdfbESjyv/U+ueSGpWLaTA24Js=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7tiikKz;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789471882;
	b=Z5fbz1Bd6lKdUjdnPcyBUuoLgZiAx5y14DBmqycGc3ok9XR7jp9mrjLGCgWHUu3rngaS2l
	rpn+WP0d1OxpBXh6vtjCBP2QSnYew2qJyqascon8ftlxLQV2J1vVVg5kP9fIFpYt+s8Ale
	mHsXPoyz90KbJPAAG3HqLvRTS0ZsQRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D6A840952;
	Tue, 15 Sep 2026 11:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7091F000FF;
	Tue, 15 Sep 2026 11:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789471881;
	bh=CAJtKPFKPGeuK6/4FcUJJhXpcyxiLyxrGeWoP03hjX8=;
	h=From:Subject:Date:To:Cc;
	b=E7tiikKzEgWbcjup28lG7XRiPSUJnQOmsnywq0ncyYHyQqJnTKt0FKdhc261bi9OH
	 0SlILqTj5qE3J8OEyDI9zqLYPy8psNZLLrF7QOW4W4UQnh0hGPOhQASSGdWdu6CXlB
	 AinpX1RK+sPUhsT5EBGslz/xjWU79vTK2oG+qEZWWfaWT7bIGAFoh926ly17QWcoIQ
	 QJCJXpfCSDC9mQet/UenNMcEEu3ND/zogF3V4a6m5lxpAeKrS/RkcQCtt28J4Htm15
	 ioCbMP38XAAhzbjEh1DggCyILiXq6YLqnQmybNy4sunfucifPnv8TR98hWLnUmAKl0
	 e5z5SrdGFsCyg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC POC 00/50] file: handle files on syscall exit
Date: Tue, 15 Sep 2026 13:30:46 +0200
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2Nyw6CMBBFf4XM2ml4iBG3JG41bo0LykylalrTC
 moI/24LLu/MveeM4Nlp9rBLRnA8aK+tCSFbJdB2jbkyagoZ8jTfpFVW4tu6OypCx2E5MPZGqy8
 q+yAmlNuKiqxcy4JSCIinY6U/M/4Mp32dHA81XJaH7+WN21eEx6psPKN0jWm7eIoaoUj8NWLWi
 EUjYhem6QdT5RjovQAAAA==
X-Change-ID: 20260915-work-fd-reserve-unify-folded-b89d3154b3d0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=11212; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tghJXnBoCORuUllyVM5kOenrKYvUcLA4//tYvMQ3Gwc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmZfVvdXbIn41vJt/oHZ9cvPhHnHXlduWLl4TSB5
 BsG1wzUO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSP4+R4aD04rbPT/bfPqP8
 9uSeOZ+ErR6x+W14vnzltXsvZhzbPcWOkeGY1wMZvuPZ2+W5eQ7v+q00SZHnk3fSzCfWYt9Z60S
 6GPkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39C71160003
X-Stat-Signature: uefht445mbf4ruajzfuz9ta91g9a1o73
X-Rspam-User: 
X-HE-Tag: 1789471882-759658
X-HE-Meta: U2FsdGVkX1+QEzZEgk2Tue8s4aRYeKTiQmrqL7uOomh+5UcSAzFoYOqRLINcw79NbGAF/SGI1V6R/+WWkClO9go1A1AWuvg5rcTivlW3C83xvClq1bdFDrhLtDWmz3vMfk7aXOXIwG7BDwZ5aOfSpwg5EwqFM6J9yeXI0cznxIC9z9EdT1Bsfzs8JHiRqWGkWaJnI9HdTh8pqHtyirbj3wZ4x4kguZJCvluOz6LxmAlJgkfKHGuZeniqUOtwny+s0hb5le05hr/9QQ5hcbHSkQlaue4lXJ6aiWI9YALjnN6vIYq16Yo/+Q3SyizNhYhVLwkUrS31bcwTCshpXaEt+uNSiTR8L3rr6H5FeSmI61EuPRuqWsA3XJt5Jt/N3PegYnRtrKQ38OvLAiXmGKiu/0hPSPPD43++jMUxNekZfYZpAD57PALoNbvB8ZVJlVGRAjFO2JqJ7XqKSUH7rrzshsVNSAAX0tJSs6pSY+jr+D9Clp0NCLcUP8kmWHK9MYSHFm9JzW4S7de45Q1OMwT/KGpM6vZ8IiTcSkq+ObDPwewFep4EpLMl3YDfonMbsyDcaJ4svP8MfSlGz+Rt7eO7N+Wgad/mCp7a1D+cFKvEvxbygHOBf9ZYDl5L7SamiWz2Py4f8nLbUZm11lqO+NmqZZNYKK1MlYzECV10NG00WJtinXokQ2nCvht9XM/S4QaFXtlfY9LOSwFsQR17T2ZEoJ+S2mxD7P6uy8vuwJxhEO9IQve6wQzjT69CT0EHO04AsY6bzEESSWeLc3GLhbSPQIr5lPATroDHe/+5NGZy+CesrQ+/DEjX+Zpi/XNKMTFeh2x3S5KHXaif6FtS+TakV05KppNFKJe1B+O85ujLsacMpnYpWBup99q6QMC3Osdlpj/j3O4QFO2pRvgnAXkAgt2KDkqjefK5RFMtAEFT9Tqp55FutTAWk3Pmx1XLFMqg6Zm9OEX6qd24yQhwoUC
 +rc1pjve
 c4iH2rhsVLMs6nDYz6FmWDLaGoefgRddk1O3OubQaE07WCAC1CyyDJH9+4QdSD2VYmSPfAya+hFWw0h4HbcLE6xnn+j0tzmntJpDaXe3liTO6wEAGTWHUr21ix+AK/aEtSdKNxQbDP5JSa4gU/aB2XKAWKXRBZBtE4v8y+Cx5ym7JzvWrVbxMIhFkK3pFrbwmpIaeHcilp7WK4bc79ug7XIL2vIhgK66wifkotTTF33jLLWyo7Zqen3flhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

The idea in this series is old-ish and really never let go of me and so
I wanted to at least dump it onto the list once even if it's just for
illustrative purposes.

I still had parts of an implementation laying around that I started
montsh ago alongside FD_PREPARE()/FD_ADD(). I sat down and finished it.

We've spoken about this idea a few times over the years that we could
reserve fds and files on a task and then install or a clean them up on
syscall success or error and get rid of most of the complicated cleanup
dance that we have in a lot of code. In particular drm. It last came up
during the Rust file descriptor reservation discussion quite some time
ago.

TL;DR, this lets arch code handle fd install and cleanup. fd_prepare()
allocates a descriptor like get_unused_fd_flags() does and records it in
a slot on the task. fd_stage() attaches the file to that slot and
returns the number.

When the syscall returns success the exit path installs every staged
file. When it returns an error it drops the descriptors and the files.

So a caller reserves, hands the number to userspace whenever it wants,
creates the file, stages it and returns errors without unwinding
anything.

fd_prepare() returns the slot itself, as a const pointer. The
preexisting fd_prepare_fd() and fd_prepare_file() give access to the fd
and file.

get_unused_fd_flags() and fd_install() don't change. A descriptor is
only reserved where a caller asks for it. And open(), dup() and all
other syscalls that maximize speed simply use FD_ADD().

The task keeps two slots inline. For SCM_RIGHTS and multi-descriptor
ioctls a spill array is added. It stick with the task.

Reservations belong to the thread and the syscall that made them. A
child of fork() starts without any. A thread can't unshare its fdtagble
with outstanding reservations. Kernel threads never return to userspace
so nothing would commit. Anything left at exit is a bug and gets warned
about and dropped.

Christian

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (50):
      file: install files on syscall exit
      entry: commit fds on syscall exit
      alpha: commit fds on syscall exit
      ARC: commit fds on syscall exit
      ARM: commit fds on syscall exit
      arm64: commit fds on syscall exit
      csky: commit fds on syscall exit
      hexagon: commit fds on syscall exit
      m68k: commit fds on syscall exit
      microblaze: commit fds on syscall exit
      MIPS: commit fds on syscall exit
      nios2: commit fds on syscall exit
      openrisc: commit fds on syscall exit
      parisc: commit fds on syscall exit
      sh: commit fds on syscall exit
      sparc: commit fds on syscall exit
      um: commit fds on syscall exit
      xtensa: commit fds on syscall exit
      file: require the syscall exit hook from every architecture
      file: warn when the descriptor table is unshared with slots
      io_uring: commit fds per request
      net: install SCM_RIGHTS descriptors when recvmsg() returns
      file: open-code receive_fd()'s immediate install
      file: make FD_ADD() a standalone immediate install
      file: reimplement FD_PREPARE() on the deferred fd_prepare() path
      dma-buf: stop unwinding sync file descriptors by hand
      drm/amdkfd: stop collecting CRIU dma-buf descriptors for a final install
      drm/msm: install the out-fence descriptor when the ioctl returns
      drm/virtio: install the out-fence descriptor when the ioctl returns
      drm/vmwgfx: install the out-fence descriptor when the ioctl returns
      vfio: install the migration data descriptor when the ioctl returns
      liveupdate: install the session descriptors when the ioctl returns
      io_uring/zcrx: install the exported descriptor when the request returns
      sctp: install the peeloff descriptor when the syscall returns
      ALSA: compress: install the task descriptors when the ioctl returns
      nitro_enclaves: install the enclave descriptor when the ioctl returns
      tpm: vtpm_proxy: install the server descriptor when the ioctl returns
      perf: stop putting the event descriptor back on failure
      seccomp: stop putting the listener descriptor back on failure
      KVM: stop putting descriptors back on failure
      KVM: guest_memfd: stop putting the descriptor back on failure
      drm: stop unwinding descriptors by hand
      drm/amdgpu: stop unwinding the fence descriptor by hand
      drm/etnaviv: install the out-fence descriptor when the ioctl returns
      accel/habanalabs: stop putting the dma-buf descriptor back on failure
      xen/gntdev-dmabuf: stop putting the descriptor back on failure
      iio: buffer: install the buffer descriptor when the ioctl returns
      misc: fastrpc: install the dma-buf descriptor when the ioctl returns
      iommufd: stop putting descriptors back on failure
      Drivers: hv: mshv: stop putting descriptors back on failure

 arch/alpha/include/asm/thread_info.h         |   2 +
 arch/alpha/kernel/entry.S                    |  24 ++-
 arch/alpha/kernel/ptrace.c                   |   3 +
 arch/arc/include/asm/thread_info.h           |   2 +
 arch/arc/kernel/entry.S                      |   5 +
 arch/arc/kernel/ptrace.c                     |   4 +
 arch/arm/include/asm/thread_info.h           |   2 +
 arch/arm/kernel/entry-common.S               |   2 +
 arch/arm/kernel/ptrace.c                     |   4 +
 arch/arm64/include/asm/thread_info.h         |   4 +-
 arch/arm64/kernel/ptrace.c                   |   4 +
 arch/csky/include/asm/thread_info.h          |   2 +
 arch/csky/kernel/entry.S                     |   9 +
 arch/csky/kernel/ptrace.c                    |   4 +
 arch/hexagon/include/asm/thread_info.h       |   2 +
 arch/hexagon/kernel/traps.c                  |   4 +
 arch/m68k/68000/entry.S                      |  10 ++
 arch/m68k/coldfire/entry.S                   |  12 ++
 arch/m68k/include/asm/thread_info.h          |   2 +
 arch/m68k/kernel/entry.S                     |   2 +
 arch/m68k/kernel/ptrace.c                    |   3 +
 arch/microblaze/include/asm/thread_info.h    |   5 +-
 arch/microblaze/kernel/ptrace.c              |   4 +
 arch/mips/include/asm/thread_info.h          |   5 +-
 arch/mips/kernel/ptrace.c                    |   4 +
 arch/nios2/include/asm/thread_info.h         |   2 +
 arch/nios2/kernel/entry.S                    |   5 +
 arch/nios2/kernel/ptrace.c                   |   3 +
 arch/openrisc/include/asm/thread_info.h      |   5 +-
 arch/openrisc/kernel/entry.S                 |   5 +-
 arch/openrisc/kernel/ptrace.c                |   4 +
 arch/parisc/include/asm/thread_info.h        |   2 +
 arch/parisc/kernel/entry.S                   |  12 ++
 arch/parisc/kernel/ptrace.c                  |   4 +
 arch/powerpc/platforms/cell/spufs/inode.c    |  12 +-
 arch/sh/include/asm/thread_info.h            |  10 +-
 arch/sh/kernel/entry-common.S                |   8 +-
 arch/sh/kernel/ptrace_32.c                   |   4 +
 arch/sparc/include/asm/thread_info_32.h      |   2 +
 arch/sparc/include/asm/thread_info_64.h      |   9 +-
 arch/sparc/kernel/entry.S                    |   2 +-
 arch/sparc/kernel/ptrace_32.c                |   4 +
 arch/sparc/kernel/ptrace_64.c                |   4 +
 arch/sparc/kernel/syscalls.S                 |   4 +-
 arch/um/include/asm/thread_info.h            |   2 +
 arch/um/kernel/ptrace.c                      |   4 +
 arch/xtensa/include/asm/thread_info.h        |   2 +
 arch/xtensa/kernel/entry.S                   |   5 +
 arch/xtensa/kernel/ptrace.c                  |   4 +
 drivers/accel/habanalabs/common/memory.c     |  13 +-
 drivers/char/tpm/tpm_vtpm_proxy.c            |  30 +---
 drivers/dma-buf/dma-buf.c                    |  33 ++--
 drivers/dma-buf/sw_sync.c                    |  40 ++---
 drivers/dma-buf/sync_file.c                  |  52 ++----
 drivers/gpio/gpiolib-cdev.c                  |  18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c       |  16 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c     |  67 ++------
 drivers/gpu/drm/drm_lease.c                  |  20 +--
 drivers/gpu/drm/drm_prime.c                  |  13 +-
 drivers/gpu/drm/drm_syncobj.c                |  44 ++---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c |  14 +-
 drivers/gpu/drm/msm/msm_gem_submit.c         |  22 +--
 drivers/gpu/drm/msm/msm_gem_vma.c            |  22 +--
 drivers/gpu/drm/msm/msm_perfcntr.c           |   6 +-
 drivers/gpu/drm/virtio/virtgpu_submit.c      |  32 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c      |  29 ++--
 drivers/hv/mshv_root_main.c                  |  27 +--
 drivers/hv/mshv_vtl_main.c                   |  20 +--
 drivers/iio/industrialio-buffer.c            |  26 +--
 drivers/iommu/iommufd/eventq.c               |  39 ++---
 drivers/media/mc/mc-request.c                |   6 +-
 drivers/misc/fastrpc.c                       |  19 +--
 drivers/misc/ntsync.c                        |   6 +-
 drivers/vfio/vfio_main.c                     |  25 +--
 drivers/virt/nitro_enclaves/ne_misc_dev.c    |  33 ++--
 drivers/xen/gntdev-dmabuf.c                  |  14 +-
 fs/eventfd.c                                 |   6 +-
 fs/eventpoll.c                               |   6 +-
 fs/exec.c                                    |   3 +
 fs/file.c                                    | 245 +++++++++++++++++++++++++--
 fs/namespace.c                               |  12 +-
 fs/nsfs.c                                    |   6 +-
 fs/xfs/xfs_handle.c                          |   6 +-
 include/linux/entry-common.h                 |   8 +-
 include/linux/file.h                         | 160 +++++------------
 include/linux/sched.h                        |  21 +++
 include/linux/thread_info.h                  |   2 +
 io_uring/io_uring.c                          |  27 +++
 io_uring/mock_file.c                         |   5 +-
 io_uring/zcrx.c                              |  25 +--
 kernel/bpf/bpf_iter.c                        |   6 +-
 kernel/bpf/token.c                           |   6 +-
 kernel/events/core.c                         |  31 ++--
 kernel/exit.c                                |   1 +
 kernel/fork.c                                |   3 +
 kernel/liveupdate/luo_core.c                 |  48 ++----
 kernel/liveupdate/luo_session.c              |  24 +--
 kernel/seccomp.c                             |  13 +-
 mm/userfaultfd.c                             |   6 +-
 net/core/scm.c                               |  13 +-
 net/handshake/netlink.c                      |  20 ++-
 net/kcm/kcmsock.c                            |   5 +-
 net/sctp/socket.c                            |  78 ++++-----
 sound/core/compress_offload.c                |  24 ++-
 virt/kvm/guest_memfd.c                       |  20 +--
 virt/kvm/kvm_main.c                          |  65 +++----
 106 files changed, 962 insertions(+), 861 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260915-work-fd-reserve-unify-folded-b89d3154b3d0


