Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5C9C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E6D6B0093; Fri, 11 Sep 2026 21:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5256B0095; Fri, 11 Sep 2026 21:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3396B0096; Fri, 11 Sep 2026 21:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533786B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:24:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24318803C1
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:43 +0000 (UTC)
X-FDA: 85203365646.01.8858455
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24756100004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JeckwqeH;
	spf=pass (imf14.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176281;
	b=y8t99gF3fAhSWTlr/eHn0Ji/Is+oyoVvLAA9ouEonps3zv0D7I6YnhHU12S0ZTYA8fqFjV
	T7wZG2CyfHsNb9UrOrDq8U4XIPpx3wvmrFX0YeC/XhDEXLw/2xtF0Jes7sRsA0NMuT864O
	9Kq1LfeDbV4clscp2T+Nf+bAjZ9WAF0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JeckwqeH;
	spf=pass (imf14.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3um1GHR5C5Qsd5aY/274bfaH5ty2DkNyZEYAUe2jRHA=;
	b=gwnEqAnE+bWiWLNb48/PHVGFUI5oDOFvn+G8lUymWjJRACmcwDgzUUkMDoE2BgE1P5EaXp
	i53olQbi7pcgpOCnwFuzcwceKrCB+WLuSnG/Ze0M7gnKUcv41OhkP4i28rrpSWAq6CZhuY
	OIbsXzl7KF7UGzdnYngCxgwL5A9WlMQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=3um1GHR5C5Qsd5aY/274bfaH5ty2DkNyZEYAUe2jRHA=; b=JeckwqeHywAisQjsOiyyKmo8Ke
	RXfQCfI0IQDlxFUOcsXNHUb//0b6Qt1jTnfn6Q8IQGjiFGGazYz0R9ARNgt3iT5PYvqN/KHvRMxAd
	/EK8Kmedh1OnERsI27A2EUR5iLTbqVjv9WQpiZWIzzeOWn8OBSJscMYbqG5ioq7wTBb0lFYzsB+BE
	epSFqDSQ030N3BGIeUtq6ghbgn91iqsc11e84d/ixamDxobmGpoVVv+FC/s5KrDGm1p1/Xl4W0Lcm
	oQPATPtI2ns2PeMJLjljs8ATksWNa86xaMvTSv9hKqVp0KzhTCT5iOonBo2qqCIQ4wUP5p5NVUDrQ
	Kp1S210Q==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTZ-000xjI-0T; Sat, 12 Sep 2026 03:24:16 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v7 0/6] sched: Add support for long task name
Date: Fri, 11 Sep 2026 22:23:57 -0300
Message-Id: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23PTU7DMBAF4KtUXmNkj/+74h5VhWxnnBraBCUho
 qpyd5wiFJC7fNKbb2ZuZMQh40j2uxsZcM5j7rsSzNOOxJPvWqS5KZkAA80U13Tqu+s7Pfdd+9r
 5C9LgkpDKY2CSkzL1MWDKX3fxcPzJ42d4wzitzNo45XHqh+t95czX3q9uKn3mlFERwQJ67zjCS
 279Ofvn2F/Iys/wBwBZA7ACApIOTbkwygoQG6A51IAogHHWBa3ReucqQG6AefSCLABP2KRoDWu
 AV4DaAAsPAFUAlbyVwljwjFWA3gDHWQ3oAjSG+RQSdzKqf8CyLN8Gd9tFBgIAAA==
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24756100004
X-Stat-Signature: ewpb3kswjre3tq9wmqbihbge9n5etkjo
X-HE-Tag: 1789176281-113583
X-HE-Meta: U2FsdGVkX19/lS3GwPt7rgc0t6WJVS2LMraC4fSIT/3x9f6/oXq2PBvnp09arY3Mxn0aXeKsY6JotIlqFyRn08Q7SS7St+jszAdcVns1391DfKFJsk3sLi6SGu/v+AvEHduGbF92e2TlDYPpjD07hZ0WLa2qCeMq/OC0j+Y8ECJc1nSYstPYaO62mxAO1Z/C+PFfYPtg6lc/aCBHlH+/8k2YRSLY3fG+4nccWmSspmCEsKGzfSovwQWsBJt7Cm2a/HjhOIzudhOgvBx4FEB14gbXSfaf94cITI+s7Bs+c5O/1uKi3fwr9oycid8Aae5PocsZUzJ5LC+bHfVMCSktauTxaaNf4MYRSYsGgYwujSXCs6J/8kl5Ez5vaVbnA2TWGLyoE7+z07MQEj1Er9G1Ll5j3wowwydBKzfGIRnXPCIlKUZ07mZBg8oxG6kM0wK2bh5bhFIqJgI6U4ao1YGOMIBWQGqnYcb0Wttt2ncW0wljcIGBX1t236aOQ5ESQmDdldMin9SjH+nJtbjfx0YmiPpVbV6XdShyuXrSKj//WEXFhK8Z+RIvrHfpEg4drB1clwccNPjVevcWak024Det43UZy5ujnAc3duakj+Ucmx+LtMWDf2W1OGf3NPR6mYfepae1C6+XdKvC6RPLkJbiexZPQpdZBuQ+QgbUFcov9K9VEIPkuZel7oI2ipyEjohMfqs2bSfL4w5AqhkUeNM1aqgJGItsIE8Ih70+TnygoyU0FDsb/hAiMTcCDNRWRLYut/GUL7fplSbUqfm87poJHOQCYIoVt6rY/Gv7JQuOOEo8nKbGzLZk6DcQLCiCnuG7AyNH1MfAgDZaT/rOiafwqOagQD0V+UroGXyaGzaB5Gd840wzQIOlQl5FvqdRdCRNPz6jZix9lJRTOx7O/qJJ/MM0l+uyq8CGN6dy+0p7Hi5ZiC39Zar4u09FihUQz5OzrRN6QYMr7SzGJ6X+XoZ
 B8WQAAfC
 lOMJZ8iHrDnkHN0mzm6z8In87iTTZv6JAgHFPdmrvOcsN8YrQ8lSvoHUV4KEQIAXzC4kXkMeH1kd3Ha3BaXf9SxFT+XvHOSSxzUUVsUCS7DKI3glvfgFNJcZWNI3Vw5IEMCpI3DOb/rgjYo5jhJ0SCoW/yMsv73gUIiscwcYDAwBZyDrCjdVyIUSqFECtRi3S5qPcR8fQGbppZkYrs0Mx4biYKOkP+VYh+UJtngmYc2RqtBOQlzsLUoIkd3Dz+q+pjnDUNJJHBSGVQdYVGov+oKzDuhSGIR6cJvgZbNXfpX4G02ilnzNw/qQZH9U8GjgM9d6TNw6OAmsIF/Es8ji35cQp3vmoTcgb23gtfq7vwKBFzjE8XM6+7YYPDpgyvOBddXhGzF4lYwfUFU//OKDFtijVFsZOx54jXlL8D0zH5Yp2N6tC0lnIHOaOM9H8mwB6hheAqcDCEcpSwFzc3vXRebCSfA1s4fjJ2YYL4czNVRmvc0GA4fDhptIpSFW2+keCypcxmhIL2qknM10=
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
base-commit: 827751b699b79a6e569983359c02dce67f81b94c
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


