Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F59C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1B46B009B; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA456B00A9; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEF96B00AA; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8576B009B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B56481A015D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:13 +0000 (UTC)
X-FDA: 84998415306.28.5237259
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 056CA80004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZziVl43W;
	spf=pass (imf30.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SQbLtwyyQnS41Lf81MjzYNXmWdn7InQn4rtx16D5urg=;
	b=DiVpgY7M+gOwWRdxovxJax33Njx2R9yAktkyhfxXfV2vePNS9YGD56Xrx1ZnrXzPBWvApI
	NBTl9v36rpuNJSURY6rI1qTEPSxhbv8ThJfzwGdg+DXLbSUVGcuntCgfgmSmvcaZJxnYjF
	ahiCMtI2aQqTzo9icKdMWZI8f2WdRVk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZziVl43W;
	spf=pass (imf30.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296512;
	b=xIRwU796pTjyJtfeL+nHGsxDVIwsNKmLRBFxN7dL3JbCLVUUSqbYryf5/4WvwbWuurRFjp
	gAompwdplqApuZt8WK0Y3Cml2VfE6QzArYjHAl3QvTEAvUTbCvmv6DcITFLHEZMv9v5IVQ
	KUZYnxYL6FROS/jLUmewbx5BZRSTbGU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=SQbLtwyyQnS41Lf81MjzYNXmWdn7InQn4rtx16D5urg=; b=ZziVl43Wp3dN2wPbtDl2xTiQl+
	R2d1f0LSR9hNYqhxuNIhcTYyGdEnP0WErCoI/vAA4vmiltt4d9qxtT4AlvH0yi40xocaUC30I4PUy
	c5Ic+dsQS6NFVU70L9lDgb4zzD5Aq6ehpnJDud6dUgtpAOuszBfgf4etY/fXa9WwKhhZatc8qtKxo
	oT21D6+zJObV1Vf6K7xst2IkoXM6XcTmoEHapsHb+bsqjPDBN8YKRJ4CWfEOx4yWpbTBSFnx33j6+
	sfX7aNOEwa+htwvQh4/9RQlt1PQwFGtHHDZh2mzm+hIHpCIrf7nLsOSk+dYyUw87Mev1CBPRVCObJ
	pVa98aRg==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj1k-00GXeM-Vw; Fri, 17 Jul 2026 15:54:57 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v4 0/6] sched: Add support for long task name
Date: Fri, 17 Jul 2026 10:54:33 -0300
Message-Id: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XOTQ7CIBAF4KsY1mLKgFhceQ9jDOC04g+YUhubp
 ncXNEZNly95870ZSMTGYSTr2UAa7Fx0wacg5jNij9rXSN0hZQIFyGLJJG2D78/0Eny99/qK1Ki
 Ki6VGUwhG0tWtwco9XuJ2987xbk5o28zkxtHFNjT9a7JjuffRVxO9Y7Sg3EIJqLViCBtX64vTC
 xuuJPMd/AAgpgBkgEMlzSF9aMUE4F9AMpgCPAErVSojJZZaqT9gHMcnKtEB30MBAAA=
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
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 056CA80004
X-Stat-Signature: tf6ocus77kkhef4ouqatjf3awhp89dst
X-HE-Tag: 1784296510-351292
X-HE-Meta: U2FsdGVkX1/6xFOl6k0xfU0ganQJzpUh7av1pdGThtGP4b1xLa0KZy9bB3bSjvlwCiBoUEv371UxdYLkT/GRoiUF8+dwSnbF7Edt6u2EtUxduW5cTx249ZQw+k6Qw/kXb9mMECoaHDLSSs+ZfPHmro6UsEjd8lR9YW34c0Vkr3xSLBpIvr2Dlo/I2fWz3cKNhRBpGGR48a3dJ64dZUFGsDEF8U8ceHL5/BntFneyyCnfnJald7GNy4ro1/jDxvUtlCZ/9elJEk7visb3alk8KRS+X2AN92mqEHB5CFOIDOn+Cj+7qoWJ81uPNUirZHN+y+qvLPGePLVFcqGIJXxASdDEtKiVMGDMjiZF8Dlk52xV7RSpzTQHaMqF1iH3Zm8hPlYsxunPFKIHjgX8J5jN8bqO7VVIrOqCZIqzc9t2te9pkSoqxrxd7r4v1ei61ttFIEOqroBz+ElHkzEdUZFvIPsLcohPjFUfksu2jjCDN1unf2mBMO1r+SjnwlPgrLz2yFRDghB3VejIh/VcH7Xn379CuEDbZb6n85QZ+sXd+ECz+sy3FGmxUP56HJSDdUEVXmgDhs5Ctdja4IQbn1Nk4OFieri/o1aB3m4wFumPAjKx4QnZRtWCHSVPjP2L7kFte2/GV0iPDijq4aq8D2LA7Z8IDvlpPPzkhY1MLiOuI0yZIyLecH7Q1sRsD/825hXfjYT/fqt7eXtK7WdcVogC0H+0QCqA4lTbu1eEVQvqGWI8bBwns39X8PkVramcKWb4QyAC/3VeovfvBrsjXm5WjgFp9PhtyIk97umdzJfoe+Z6V5daVplMKLGoYL2sIUtjZrV67C0ZEiL9gdKN6lTEZSNqUatRgUY2q9PUB6Iy9PtnoMS9TDCbeQtFtYqT1bEMyE0zrlmGuJkZxA2ZPmx6Xmi3qsryOOtATxmKpk2Clr+epaf6XKX4ANb/dHWHI+0F7M/JS7pemkwVZJdSp9D
 I+TNtrGb
 WBAM9OB/NJXXGfIrSFuPE1PSJFe6Jnob8x0ivCp6+qqiVPW+/RfJYNOpbefRzhgo+fB2p+/O45S0FqyoqG8GXs/9yy/Udr5sMsjy7JiqgsEA6SPPC7081vGQsdL3A3pF1J+K1JWeRHjHtjrPZ9wdbifaT1fbm0OHJE7rRc81Ny4ngGZ1am4PTRNPGSrdd3Jn+si8SWtEPsuETPqE11tL9ut5jftlm7IQfX/OApzrOK5VyjxzUDjg0BDKLcaU3QwO+uR8BScPlLKVHgUNZBhvIfDZsxGFMn7oqfl0+RDf8DFZFjZCRKzq9kyY66WRvSx4JSM8v73pNddRP4B39kvC3TOtmlF9Mrn/p9Ob/cdSn+1GjB0uGH7RsC5l9gVl9/U4wVFebqXyGjE2IklRhThFh0IJYg/eT2s37X776d8kYSSkElauj9J/ReQoVX7w+e+x51RvmchB+zxHSQdHoqEvS9WvQENolbCQmajslja/WaPotvmIe7dreAXAk5x9yOUTlqEEBA02iPq1OJ9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  4 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  2 +-
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
 include/linux/sched.h                              | 29 +++++++----------
 include/linux/tracepoint.h                         |  4 +--
 include/trace/events/block.h                       | 10 +++---
 include/trace/events/coredump.h                    |  2 +-
 include/trace/events/f2fs.h                        |  4 +--
 include/trace/events/oom.h                         |  2 +-
 include/trace/events/osnoise.h                     |  2 +-
 include/trace/events/sched.h                       | 10 +++---
 include/trace/events/signal.h                      |  2 +-
 include/trace/events/task.h                        |  7 ++--
 include/uapi/linux/prctl.h                         |  3 ++
 kernel/audit.c                                     |  6 ++--
 kernel/auditsc.c                                   |  6 ++--
 kernel/printk/nbcon.c                              |  2 +-
 kernel/printk/printk.c                             |  4 +--
 kernel/sys.c                                       | 23 ++++++++++---
 lib/tests/string_kunit.c                           | 38 ++++++++++++++++++++++
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 ++-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  3 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 ++--
 tools/testing/selftests/prctl/set-process-name.c   | 36 ++++++++++++++++++++
 43 files changed, 172 insertions(+), 79 deletions(-)
---
base-commit: 481ed5dd3ed7136f627b8ec372ba39f5b2e7d27f
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


