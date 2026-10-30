Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B175D606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=merHimPz
Received: by kanga.kvack.org (Postfix)
	id 3B6B56B05BE; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330DB6B05C1; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8426B05BF; Fri, 30 Oct 2026 17:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDB1D6B05BD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65DD5A071A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:10 +0000 (UTC)
X-FDA: 85380608460.13.346AD04
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4BAC7C0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=merHimPz;
	spf=pass (imf22.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=98Zg2ryBevM0iXTIrP7ThkPU0eYtwuN1rGZku1ALSfg=;
	b=4trDW1LvAkmLQ12Hcnok9TmTKWAVl7WZ41ZyMneQBpJVcKmd+8vAOmMN9r2scj9XXANuLO
	6VAuIOikhBArpMwERbSXZRYQkMCe4TcWnXRSSCpNviZavQXMdJCeChA/y2bcuAMnphdL5P
	ARnDit6rUmiJnOl0RXDB7iqkzoKsvOc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=merHimPz;
	spf=pass (imf22.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396348;
	b=gs1/6dnCCYuS9ZAbRcJ4hXn7ObQDZ0Sr9UCFi0IofHZuL+CiiUsX4sBW0P3EIQcXtGGASe
	nb5vHoyWGjhzPo3sGX/hTyBvCb7c6Es+5yD+mmqrNagu3YAYwyJUy5qMr+CJY8J2dStQdd
	9FdExmdxeoQ647YpDvwliJ59ogxoxk0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=98Zg2ryBevM0iXTIrP7ThkPU0eYtwuN1rGZku1ALSfg=; b=merHimPzSNwhSnc5pMpFPpZXdt
	yiIV76dGM8SzaCzgZl4iqldOmuRj+3RiJZow4dGGypGS6eK+U+GjvFjeFoXc/6tEt6aowX/uDF+kq
	XSf2LpEzdVgMKmNZcabpJDg8dgcuHBdy55qIHGqXHH5Vws6BNRJhzyEkXGQo68mBkk+nb6uk6ZIcR
	nLnWBhgJCJRlOc66zMM9VmC7odpNwzlmnYYqkVwxZXNvC8OPZ+F0VNDV6PtQrdjwBmbY8S+vufbyS
	Zp500fUEl5LyvK0Hzc0nFHLyB442FcUJITPC54r5ZnlrCmwHxRpMNskpwAXMMLqlBjX6FRYztypLK
	PffmCHYQ==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJ8-00FNmU-TU; Fri, 30 Oct 2026 22:38:43 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v8 0/6] sched: Add support for long task name
Date: Fri, 30 Oct 2026 18:38:31 -0300
Message-Id: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23QS07DMBAG4KtUXmPkGb9ZcQ+EkOOMW0OboCREV
 FXujlOEUuQuf2nmm8eFjTRkGtnT7sIGmvOY+64E97Bj8RC6PfHclsxQoBEaDJ/67vzBj323f+v
 CiXjjk1Q6UCMUsNL1OVDK31fx5fU3j1/NO8VpZdaKQx6nfjhfR86w1v3pttJn4ILLiA4pBA+Ez
 3kfjjk8xv7EVn7GGwBVDeAKSEymacuGUVWA3AADWAOyANY73xhDLnhfAWoD7L0TVAEgUZuis6J
 FqAC9AQ7vALoAOgWnpHUYhKgAswEeRA2YArRWhNQk8CrqCrC3ANSAXZ+oCIhAGxXoH7Asyw+tK
 IC1RwIAAA==
X-Change-ID: 20260516-tonyk-long_name-b9f345aeb041
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BAC7C0006
X-Stat-Signature: i4yq33b8ns45idbon4mc1z5g933ja39p
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793396348-398660
X-HE-Meta: U2FsdGVkX1+iZLLF0Cdmg4D9lvBf+l90XjTGMWW0llEe8BQK0QcG5pXVZv9PoCi207hjmQVMLxyV4ny5BxgmKOIqriRdDVI2fWniB4NDtV3jXRy77A8EqgsFaZtxH7KKJzxHfyYmWwnPIScKI8eOS0onMl83QV4k9/RRlY8kep18nRXLih0iu9oAKYz7WIv2AmJjHRiQWhSpNmBpCN4ySJm7gF4zpXndZX1358TqHBIOa/4OX/4uylVlmgWU2wZ/eU+0zj3worxi3n7PabfyB142gJmfuPlFyHN4NPFvR/9g1TpAApvvE5ggP0i/z4LPnIG1oxQVUxywcvweF4FIkWVPyo3FkOAyaOwd5jpoUUxNq5aPusBcEjIgSooN+GtbWwIdgseIUqNHeN//KmIOVzfTzhM0a+WNooNRZLzXyOeYxMYxbHwzQAWXGQyPTpixBEaIxo4CWymQV3JRH6Xf0OpyeaupjtKiRlMsgsZhjP2cpaXwakg2Y0xkFYsuEul37UWkw8YRb0TVEJSXuIwAtfQfw1GlqXBqhZyZONA35rsVNUZAroRuo7ENURBP7bhsMpEstdz7yRanhVL+MQHkXtG7tdCa+0IhNjQ3eF9tfYnfRFVhp9PoelRBawci+o3tw3XxSmXCHQvsRVyM1c3Qb7oG33l4DqQe4AFX84rM0lTp5XVO7LBMXbXvMW22ZEXhPA/WFdw69r3xF+Yiv870D8O+pE8ZAnOJw7vs/35ABAbazvdf98dAg3vjisxMiKdhkrsUDHdpSsQ3maSkGcC5F5G6q0kCW/ZX6ZDcP+9y5MSBewEt1kuYOZX/boo+qpg81KF4j7OctufvJodAmCv8CrkRmWnH6HmvT/J4cEYRSF5hscLq/RQ8kN9nSiwInwXyZr7yae8h9p6tAaHXkCOhJIeRMsVwctHqH2mbLNR76tEHjKUDXQsrsE1xnWnZ+5IOYkbUTfpmEIfv/O3vfnq
 DCczLz4G
 PTo5KLHbjyOEtc0qgE5i15rAlx3IwWcyMInF3WQVcUHULQ1RMreK5l98Nf+wAYFF/3qahGIOTmcQtOxjX/K+JBzi1fC1hC4K/gV96Rl6rObHO4N1ZVmZb09XNr/JqNUE0vE1yX7Tc5SZ7DYstZIwBsoODCkOJnzTJG5kIjZucsrRBr7KQ+J0vK6/8sBkzcGg8NVZjy5NfsFEYlqO8i+qsbq4NU/Z3FG1vIdUB4y+oAQwsFR7DPoQg4HOsvEBZRQARoZWbi7OHSGSn3pSHgY7GbKWyM/4xPBvoyohPpjjLHMo3s/HppXvHPSagK1d6hmiE7Qy3XX6xpjsM1lNselYDQlnSxsyZCCMIFv8J8u6iKooCk2c4wLWSfP6f+75ZwDDNZX5IBQZCbn+QWvlvZVBRdppJNyEJUkUgIPSe0d1cSPEYk6CfK4Ch1ma+RYVquJD86kwl3nJryOpTx8GA4NxV4B4om3Fq/tgBvvZ0TtRK+jc5SqGegtv69LJrEhUfQnW43L2XgLu3E4/8onw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

* Use case

When debugging and tracing complex programs with hundreds of threads, 16 bytes
long thread names are not enough anymore. cmd_line can show a lot of
characters, but it's not affected by pthread_setname_np() or
prctl(PR_SET_NAME), so let's give the same love kthreads got with commit
6b59808bfe48 ("workqueue: Show the latest workqueue name in 
/proc/PID/{comm,stat,status}"). This patchset creates a new
PR_{SET,GET}_EXT_NAME that supports 64 bytes long names.

It also introduces a new function copy_task_comm() that ensures that the string
is always NUL-terminated despite of mismatching sizes of buffers. We can't just
use strscpy() because it proved to give some overhead [0] in tracing.

* Patchset

Patch 1 and 2 do some prep work in order to avoid buffer overflows around
the kernel, now that current->comm is bigger. It also make sure that if
the destination buffer is smaller than TASK_COMM_EXT_LEN, it will
be NUL-terminated.

Patch 3 adds a KUnit for the new function copy_task_comm()

Patch 4 sets current->comm length to TASK_COMM_EXT_LEN and take care of
making sure that current userspace APIs gets only TASK_COMM_LEN.

Patch 5 creates new prctl() to set and get all the TASK_COMM_EXT_LEN bytes.

Patch 6 adapts the existing selftest for this new interface.

* Testing

selftests/prctl/set-process-name.c survives this patchset, and it was extended
to the new interface. KUnit test was modified to support copy_task_comm().

I ran the same benchmark as at [0], and no significant change was found.

* Changes

Changes in v8:
- Rebased on top of 7.4 and collected tags
- Added a explanation about out of bounds read at patch 4/6.
- Link to v7: https://patch.msgid.link/20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com

Changes in v7:
- Fixed build errors (for good): bpf test and security/smack
- Link to v6: https://patch.msgid.link/20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com

Since v6:
- Fix build error in security/
- Fix size of comm buffer for i915 and blktrace
- Fix KUnit test logic
- Link to v5: https://patch.msgid.link/20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com

Since v4:
- Remove copy_task_comm() calls for structs other than struct task_struct
- copy_task_comm(): Add checks for len > TASK_COMM_LEN and len < 0
- Link to v4: https://patch.msgid.link/20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com

Since v3:
 - Simplify Get rid of get_task_comm() commit
 - Simplify copy_task_comm(): just do a memcpy + NUL char at the end
 - Link to v3: https://patch.msgid.link/20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com

Since v2:
 - Add a custom function copy_task_comm() that uses memcpy when possible and
 fallback to strscpy(). It always ensures that the string in NUL-terminated
 - Add KUnit test for the new function
 - Link to v2: https://patch.msgid.link/20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com

Since v1:
 - Replace new strtostr() with strscpy()
 - Don't replace memcpy in tools/
 - Link to v1: https://patch.msgid.link/20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com

[0] https://lore.kernel.org/lkml/20260526190625.3f4aca0a@gandalf.local.home/

---
André Almeida (6):
      treewide: Get rid of get_task_comm()
      treewide: Replace memcpy(..., current->comm) with copy_task_comm()
      lib/string_kunit: Add test for copy_task_comm()
      sched: Extend task command name with TASK_COMM_EXT_LEN
      prctl: Add support for long user thread names
      selftests: prctl: Add test for long thread names

 drivers/connector/cn_proc.c                        |  2 +-
 drivers/dma-buf/sw_sync.c                          |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  2 +-
 .../gpu/drm/i915/display/intel_display_driver.c    |  4 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  4 +-
 drivers/gpu/drm/lima/lima_ctx.c                    |  2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  2 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |  2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  2 +-
 drivers/hwtracing/stm/core.c                       |  2 +-
 drivers/tty/tty_audit.c                            |  2 +-
 fs/binfmt_elf.c                                    |  2 +-
 fs/binfmt_elf_fdpic.c                              |  2 +-
 fs/proc/array.c                                    |  2 +-
 include/linux/coredump.h                           |  2 +-
 include/linux/sched.h                              | 33 ++++++-------
 include/linux/tracepoint.h                         |  4 +-
 include/trace/events/block.h                       | 10 ++--
 include/trace/events/coredump.h                    |  2 +-
 include/trace/events/f2fs.h                        |  4 +-
 include/trace/events/oom.h                         |  2 +-
 include/trace/events/osnoise.h                     |  2 +-
 include/trace/events/sched.h                       | 10 ++--
 include/trace/events/signal.h                      |  2 +-
 include/trace/events/task.h                        |  4 +-
 include/uapi/linux/prctl.h                         |  3 ++
 kernel/audit.c                                     |  6 ++-
 kernel/auditsc.c                                   |  6 ++-
 kernel/printk/printk.c                             |  2 +-
 kernel/sys.c                                       | 23 +++++++--
 kernel/trace/blktrace.c                            |  6 ++-
 lib/tests/string_kunit.c                           | 38 +++++++++++++++
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 +-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  3 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 +--
 security/smack/smack_access.c                      |  4 +-
 security/smack/smack_lsm.c                         |  4 +-
 .../selftests/bpf/test_kmods/bpf_testmod-events.h  |  2 +-
 tools/testing/selftests/prctl/set-process-name.c   | 57 +++++++++++++++++++---
 48 files changed, 200 insertions(+), 93 deletions(-)
---
base-commit: 4dd16e31135ea8437a720222df34e8745f385d6d
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


