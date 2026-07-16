Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D457FC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27EB6B00BF; Thu, 16 Jul 2026 10:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0436B00C2; Thu, 16 Jul 2026 10:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EA46B00C3; Thu, 16 Jul 2026 10:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51F1E6B00BF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57720C01D7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:32:35 +0000 (UTC)
X-FDA: 84994880670.29.60B941C
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A9E6180003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:32:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=N4AokULL;
	spf=pass (imf06.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212353;
	b=anE4P1hv9K9lZAgwdGA5Ybb3Ua3SpbfETT1lnTT9EM06vvukYWUy8IQuEk/EagDD5CuqSf
	KUeZQELes84rwjMIwHoV2YeCduaXouUnEwe6egqn/W1/4pXY9WVfLmYQQLehm0DAl/CO+W
	Rnw/n4xdE8IjuNwhziMjM5KFgdGB4JI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=N4AokULL;
	spf=pass (imf06.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5oCdwe2KWEGMRTpHEX8MzuIoOidrsrJEQ6Hx6ATmCPI=;
	b=qGcV5cEnHieg1Ltw7kwzez34pzuIijYUGlbMLCQPkhgT5HVcZSieoqV1HCWhMERW0aEyyn
	HZS1Zfr3T3baWbWhKdU14sH8sZx/bOLSvj29nAABOa4XV7gYW1fIJ+F8AsuT3DY0MZgCK9
	gexi0LGZNU+kY4Bs1UPQLn4uzwz7FnQ=
ARC-Seal: i=1; a=rsa-sha256; t=1784212336; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fZCIBYJFR2T1GZORZZ84y0hqKpA/34zUnKSZwzkphIVuYmkrRhUdfXRsO8Pbc9A83TfXCJ8nac8Ds8iqRSVNQZ0H88vhPEqud3CRULPWgZnZ/k5AzXIXFegcWelBtw4bgRHmt5o7McK04G1+1xnUob4Y2/W28MwKX07Vda+CR5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212336; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=5oCdwe2KWEGMRTpHEX8MzuIoOidrsrJEQ6Hx6ATmCPI=; 
	b=MfVsHkw0i5Wb/dMkMNhDCgRsN8i0su2QCG0Q3V5Xx5VNICtohIDANpP+5xmRaHXCKU9GcMQvUwoXl66UTCump4BCZayoeSvdEdQ4GkzubjkyyftJ/TYQWQpys9hK+ec4GQz46/det+8cij5/2nWuMmInfxOgT+t9AZIfqqlpq3M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212336;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=5oCdwe2KWEGMRTpHEX8MzuIoOidrsrJEQ6Hx6ATmCPI=;
	b=N4AokULLXMzramfa4Qwvgx87YW5ak5NKY5sxmc59Wmono8RbzWZvxq9cL6jp4Vh5
	P/n/xkQaRTpbIbcF7MNHyjS/LU3zcd2S3Yah0w4sQblDit9SIyY/fxxjAr1OZpa5BxD
	h+Dnf+UTQao3VVbhKI7BSteq3GqKAgzb2xxAObKs=
Received: by mx.zohomail.com with SMTPS id 1784212333383352.21801644814866;
	Thu, 16 Jul 2026 07:32:13 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
Date: Thu, 16 Jul 2026 22:31:26 +0800
Message-ID: <cover.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A9E6180003
X-Stat-Signature: zqs58ztkczarryyidxapoenwsfm59yua
X-HE-Tag: 1784212353-775185
X-HE-Meta: U2FsdGVkX18NP5u4BzIvbOXKj97E9Y8b+iZ3E95ngLbEvb6kjy2AaXwTZwfm4w+G3OAVe7zFHrIYvd4ioILkwHgeUhEDut8ANNT9tuUGCO1svFUpdpr6Z0/G7j/riSgaLexbMc4DNIxgH1WFEFpAVSC2kWOLenZXJUhdhRQhNoTKUrG0NnECYfCwDW3FR4sFdC+4Acvp8Mhslv7WSAlPqbFFvqjWtYR88Fhm+5csrPeHgBTmw+nAH5VwcwZewaZYqf052wAkqNopt0Gi8wlKbwoZQIj2R/ET4EkQSQ15nzex7Oe9BjAfzdI2oXMBHQo+Un3D/Ifpgo8VffyDHl8eLvZfRLut7A7RWSfSf4cq4t2zIIC7UTatycYioQDmGkuTq0NQK2V2JrdQ94QHXv5sN79D9+Z8xJXRlUDNreRg+rHaDEzO1ez+9n14ko8UQzgp6efxt+cOUUT4J1qcUeJQJhQe041ieZEAI2tj/1oSWfy596zYysxIB3q6GD7AQMvoZKiMerUAwW1T/9P9HA5Pf1E+OyZ5V01HCq/a+QnauER9lobIS9QrdifoC1X4mdWo6RORoKrAdtST9BSoMvMRCqkWbvQgSjn5rsflpVOwTDWKPBqVuY+/TozGNqwlq8+AQn3XwP3svkjv3Uzk9mMRzvxcXMfQ5Csdhd/2G/QOIptETblR0Xwvs3Pab5bkw4r++ONbQ25IT/m78HziHbNz76Npz2m5RfT3mSTSr9mrbjA7q85w34oFb7IIn5mksULJnI9BWEtce1vOnVh5n8TcE9EVmyf0imd07gw4dp9NR3kuA0jinnmPkRIsoLi/2pxutPYNfIzCJSwnFWhJfm1DMg1MkFw9WQnCHp5Wr5Hca+/1Jl5ReyPKDkcLtxEUub9vtZqf9bdReXIUP1GHqvmbmWq9pXXcubzBeMF69btAaGTqOwbbbunEXkSV4o5lniOZgVk2M50XF3x85Hg6aKF
 F3iQidlQ
 4gx2Jhb1jjTQsnxT6shnSO80kOx1B4yOuX7iNJx4Tt/G10Ep6N3xEZV9QlMv99ZP53f6xQ91YqbLAKu+RTUsxj/yAccIF/8y8l8bX5DHYdsk+3XayvC1vQ24JSs4RIAGzvoK0EztLtoSo4D3xHf77yl1x36uCUWMy0srrrO76E55SPhBsXnFWI5tw5iD3ayG+7UDw64TWRDSKocLoimT7Hh6pG47vB+fn1M2eVDhzDM1omQNYnGpZMq5O+h3TIsfm2SN79lv9yJ7z111X11Bytg19Tv+iI+i4e3uPWMUpXmmMJvxOoLJoUA2JfrIcJsYd5O1L+mR0xZwiBvF5Jt+d+c/5EzKzG1iUup9omGjjmHoEFt5U4n7x8kGKDkHAj6TyEkS4Q10lzj4JCMxzhwfoDoFIDVZDCmnb7XXCj79bQ5t2BlJNJjhUFWncu4QFkKJNAvvmofJhqtOC23LGxw09O/cVgpHvB1laeBsQ1lK2p+9ckAFceZQ431jAIi8KytGzm0onq1HF3K8aNiFhuWMS2Lxm8QMI8uRbokz7l9Tez4kEnTpFCH/aMu2JTL1G4Y8R46AajCeCuDdQcYX344VZkKPL5bNmXIgGTGXr0gI2QQPGiN1gUMqxm60y0tzpbctU4pZxSeIsu+Iu3ln0OHJicJiuW++ULAlqjw6AW7kOv/ZY065+eIWsDp6OWfj7fVhoCp9xZJE99i7nCYyyW4s21XLpUFbBolbEBW316RflwV4R/edGa7GewnaBMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This RFC follows feedback on my earlier spawn_template RFC [1]. That
proposal made caching the primary interface; this one starts with general
process construction. Christian suggested a pidfd/pidfs exec builder
modeled after fsconfig(), with enough semantics for userspace to implement
posix_spawn() [2], and Kees agreed [3].

This RFC is based on linux-next next-20260710 and depends on two pidfs
fixes that I sent separately:

  * pidfs: preserve thread pidfds reopened by file handle
    https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.beauty/
  * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
    https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.beauty/

The initial implementation is source-based. The executable path can be
provided with the final run request:

    struct pidfd_spawn_run_args run = {
        .path = (unsigned long)"/usr/bin/rg",
        .argv = (unsigned long)argv,
        .envp = (unsigned long)envp,
    };

    fd = pidfd_open(0, PIDFD_EMPTY);
    pidfd_spawn_run(fd, &run, sizeof(run));

Alternatively, the path can be staged before the final run step:

    struct pidfd_spawn_run_args run = {
        .argv = (unsigned long)argv,
        .envp = (unsigned long)envp,
    };

    fd = pidfd_open(0, PIDFD_EMPTY);
    pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
                 PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
    pidfd_spawn_run(fd, &run, sizeof(run));

pidfd_open(0, PIDFD_EMPTY) creates a taskless future pidfd with a stable
pidfs inode, but no task, PID, or process-count charge. pidfd_spawn_run()
creates the task and PID; after publication the same fd is the child pidfd,
and a numeric pidfd resolves to the same inode. Live-task operations return
-ESRCH before publication. A terminal pre-task failure wakes poll/epoll
with POLLERR | POLLHUP.

Source-based mode follows posix_spawn-style defaults. At run time it
samples the caller's cwd, root, umask, fd table, signal dispositions and
blocked mask, and namespaces.
Non-FD_CLOEXEC descriptors remain unless an action changes them; file and
filesystem state are private child copies before actions. Configuration and
run stay bound to the creating mm_struct, exact credential object, and
child PID namespace, so SCM_RIGHTS does not delegate launch authority.

The first authorized run claims the builder before copying its payload, so
later failures are terminal. Pre-task failure leaves the fd taskless;
setup or exec failure leaves it as the child pidfd and exits the child with
status 127. PIDFD_GET_INFO with PIDFD_INFO_EXIT distinguishes them.
Success returns the positive child PID in the caller's PID namespace.

The RFC supports ordered DUP2, CLOSE_RANGE, and FCHDIR actions in
extensible UAPI records. This exercises child-private fd and cwd setup, but
is not the complete posix_spawn() action or attribute surface.

Between task publication and successful exec, the child is explicitly
embryonic and may not have a valid userspace register frame. Ptrace and
pidfd_getfd() are denied, procfs treats the PID as absent to other tasks,
and coredump information reports PIDFD_COREDUMP_SKIP. The child can use its
own proc entries during executable lookup. Setup runs as initial child task
work, and successful exec releases this state before exec events are
published.

Seccomp sees pidfd_spawn_run(), not separate file-action or exec syscalls,
and cannot inspect the path or action records behind the run pointer. An
exec-only denylist that allows unknown syscalls therefore does not block
this initial exec; policy must filter the builder syscall as a unit. Should
later expansion provide an immutable restriction profile or action mask
that seccomp can reason about, or is the coarse syscall boundary
preferable?

LSM exec checks and inherited seccomp state remain active. Child setup uses
a dedicated AUDIT_PIDFD_SPAWN transaction, not a synthetic AUDIT_SYSCALL.
Should it be selected through the source pidfd_spawn_run() exit rule? An
existing rule naming only execve() or execveat() does not select it.
For source/child correlation, could an auxiliary record carry
the source PID plus the stable pidfs inode? An already traced source is
rejected before the claim; ptrace auto-attach is not implemented.

The implementation still uses CLONE_VM | CLONE_VFORK plus exec internally.
Mateusz suggested that an initial implementation might start with vfork to
get the API off the ground [4]. That is what this RFC does. It does not yet
construct a pristine target process without first inheriting source state.

Missing posix_spawn() pieces include open and close file actions, resetids,
signal masks/defaults, process groups, sessions, scheduler attributes,
affinity, cgroup placement, PATH lookup/posix_spawnp(), and exec by fd. The
RFC also does not include pristine/no-source creation or the executable
metadata/template cache from my earlier work.

John Ericson described a real, partially initialized process that remains
unscheduled while callers install its state, and linked an exploratory
FreeBSD proc_new()/proc_setfd()/proc_start() refactoring [5]. This RFC
implements the source-based mode first; a lower-authority pristine/no-source
mode would be explicit follow-up work.

Direct process construction is not unprecedented. XNU's posix_spawn path
does not inherit the parent's address space [6], and Windows
CreateProcess() accepts explicit startup state [7]. Josh's io_uring_spawn
LPC slides list "set up process from scratch" as future work and provide
useful performance context [8]; I am not using those numbers as a claim for
this RFC.

If the direction is acceptable, I plan to continue toward:

  * the complete file-action and attribute set needed by posix_spawn();
  * pristine target-process construction and an explicit no-source mode;
  * PATH/posix_spawnp support, if it belongs on the kernel side; and
  * an optional executable/template layer for workloads such as agent tool
    calling and compiler drivers.

The exposed UAPI surface is intentionally limited so the state model and
kernel/userspace boundary can be reviewed first. If maintainers would
prefer more posix_spawn semantics or backend work in this RFC, please say
so and I will adjust the split.

Codex GPT-5.5 and GPT-5.6-sol provided substantial assistance across design
conceptualization, implementation, patch splitting, code review, development
of self-test cases, and test planning and execution.

Thanks to Christian, Kees, Mateusz, Gabriel, Josh, Andy, John, and others
for the review and direction.

[1]: https://patchew.org/linux/20260528095235.2491226-1-me%40linux.beauty/
[2]: https://lore.kernel.org/all/20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner/
[3]: https://lore.kernel.org/all/202606011254.5FCBD65@keescook/
[4]: https://lore.kernel.org/all/vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt/
[5]: https://lore.kernel.org/all/ce71d6df-6851-4e4b-9603-1d55d8d522b8@app.fastmail.com/
[6]: https://github.com/apple-oss-distributions/xnu/blob/f6217f891ac0bb64f3d375211650a4c1ff8ca1ea/bsd/kern/kern_exec.c#L4039
[7]: https://learn.microsoft.com/en-us/windows/win32/procthread/creating-processes
[8]: https://lpc.events/event/16/contributions/1213/attachments/1012/1945/io-uring-spawn.pdf


Li Chen (24):
  pidfd: add spawn builder uapi
  libfs: allow custom validation of stashed inode data
  pidfs: add taskless future pidfd inodes
  pidfd: create taskless spawn builders
  pidfd: add spawn builder path configuration
  exec: expose execveat internals to process builders
  fork: expose vfork completion helper
  pidfs: attach pids to future pidfd files
  fork: let process builders supply preallocated pids
  pidfs: publish future pidfd files
  pidfd: add spawn builder state tracking
  fork: let kernel callers create embryonic tasks
  fork: let new tasks start with task work
  pidfd: create and execute spawn builder tasks
  fork: keep embryonic tasks hidden until exec completes
  audit: add pidfd spawn child contexts
  pidfd: audit child spawn execution
  pidfd: make spawn builder execution signal-safe
  file: expose spawn file-action helpers
  pidfd: add initial spawn file actions
  pidfd: consume spawn builders on the first run attempt
  pidfd: expose spawn builder system calls
  selftests/pidfd: cover pidfd spawn builders
  Documentation: describe pidfd spawn builders

 Documentation/userspace-api/index.rst         |    1 +
 Documentation/userspace-api/pidfd_spawn.rst   |  247 ++++
 MAINTAINERS                                   |    6 +
 arch/alpha/kernel/syscalls/syscall.tbl        |    2 +
 arch/arm/tools/syscall.tbl                    |    2 +
 arch/arm64/tools/syscall_32.tbl               |    2 +
 arch/m68k/kernel/syscalls/syscall.tbl         |    2 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |    2 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |    2 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |    2 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |    2 +
 arch/parisc/kernel/syscalls/syscall.tbl       |    2 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |    2 +
 arch/s390/kernel/syscalls/syscall.tbl         |    2 +
 arch/sh/kernel/syscalls/syscall.tbl           |    2 +
 arch/sparc/kernel/syscalls/syscall.tbl        |    2 +
 arch/x86/entry/syscalls/syscall_32.tbl        |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl        |    2 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |    2 +
 fs/Makefile                                   |    2 +-
 fs/coredump.c                                 |    4 +-
 fs/exec.c                                     |   30 +-
 fs/exec_internal.h                            |   40 +
 fs/file.c                                     |   11 +-
 fs/internal.h                                 |    3 +
 fs/libfs.c                                    |    5 +-
 fs/open.c                                     |    7 +-
 fs/pidfd_spawn.c                              | 1095 +++++++++++++++
 fs/pidfs.c                                    |  478 ++++++-
 fs/proc/base.c                                |   11 +-
 fs/proc/internal.h                            |   18 +-
 include/linux/audit.h                         |   31 +
 include/linux/pid.h                           |   13 +
 include/linux/pidfd_spawn.h                   |    9 +
 include/linux/pidfs.h                         |   28 +
 include/linux/sched.h                         |   21 +
 include/linux/sched/task.h                    |    6 +
 include/linux/syscalls.h                      |    7 +
 include/uapi/asm-generic/unistd.h             |    8 +-
 include/uapi/linux/audit.h                    |    1 +
 include/uapi/linux/pidfd.h                    |    1 +
 include/uapi/linux/pidfd_spawn.h              |   49 +
 kernel/audit.h                                |    1 +
 kernel/auditsc.c                              |  105 +-
 kernel/fork.c                                 |   26 +-
 kernel/nsproxy.c                              |   11 +-
 kernel/pid.c                                  |   41 +-
 kernel/ptrace.c                               |    4 +
 kernel/signal.c                               |    2 +-
 scripts/syscall.tbl                           |    2 +
 tools/include/uapi/asm-generic/unistd.h       |    8 +-
 tools/include/uapi/linux/pidfd_spawn.h        |   49 +
 .../arch/alpha/entry/syscalls/syscall.tbl     |    2 +
 .../perf/arch/arm/entry/syscalls/syscall.tbl  |    2 +
 .../arch/arm64/entry/syscalls/syscall_32.tbl  |   11 +
 .../arch/mips/entry/syscalls/syscall_n64.tbl  |    2 +
 .../arch/parisc/entry/syscalls/syscall.tbl    |    2 +
 .../arch/powerpc/entry/syscalls/syscall.tbl   |    2 +
 .../perf/arch/s390/entry/syscalls/syscall.tbl |    2 +
 tools/perf/arch/sh/entry/syscalls/syscall.tbl |    2 +
 .../arch/sparc/entry/syscalls/syscall.tbl     |    2 +
 .../arch/x86/entry/syscalls/syscall_32.tbl    |    2 +
 .../arch/x86/entry/syscalls/syscall_64.tbl    |    2 +
 .../arch/xtensa/entry/syscalls/syscall.tbl    |    2 +
 tools/scripts/syscall.tbl                     |    2 +
 tools/testing/selftests/landlock/audit.h      |    6 +-
 tools/testing/selftests/pidfd/.gitignore      |    9 +
 tools/testing/selftests/pidfd/Makefile        |   25 +-
 tools/testing/selftests/pidfd/config          |    6 +
 .../pidfd/pidfd_spawn_accounting_test.c       |  428 ++++++
 .../pidfd/pidfd_spawn_actions_test.c          |  474 +++++++
 .../selftests/pidfd/pidfd_spawn_audit_test.c  |  521 +++++++
 .../selftests/pidfd/pidfd_spawn_common.c      |  512 +++++++
 .../selftests/pidfd/pidfd_spawn_common.h      |   59 +
 .../selftests/pidfd/pidfd_spawn_compat.c      |  221 +++
 .../selftests/pidfd/pidfd_spawn_exec_test.c   |  301 ++++
 .../selftests/pidfd/pidfd_spawn_policy_test.c |  294 ++++
 .../selftests/pidfd/pidfd_spawn_race_test.c   |  923 ++++++++++++
 .../pidfd/pidfd_spawn_security_test.c         | 1242 +++++++++++++++++
 .../selftests/pidfd/pidfd_spawn_test.c        |  550 ++++++++
 80 files changed, 7938 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/userspace-api/pidfd_spawn.rst
 create mode 100644 fs/exec_internal.h
 create mode 100644 fs/pidfd_spawn.c
 create mode 100644 include/linux/pidfd_spawn.h
 create mode 100644 include/uapi/linux/pidfd_spawn.h
 create mode 100644 tools/include/uapi/linux/pidfd_spawn.h
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.h
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_compat.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_test.c

-- 
2.52.0


