Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A045AC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9117C6B008A; Thu, 10 Sep 2026 12:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1A86B0092; Thu, 10 Sep 2026 12:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFB96B0093; Thu, 10 Sep 2026 12:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D791A6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:49:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29E281A05D3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:41 +0000 (UTC)
X-FDA: 85198438962.20.F5C3EA8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 402B220008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YUfuO00n;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wi6CY0IDclqxk/0dSLImYT2+x8arQgwxuPzYw0ZWXLk=;
	b=Gj7bMuPn2b8najS9mr1UTi6sCnXirrESu4tFvy4//BNgf5VO5H3u1pxKQRSk3/rQPz7CZ3
	UYN3j54evCjpWkvn/LZux31wmIu0+motf/q2AntdgUpAZ4zUVSdK/Ce5GCjpzx0t57N9JD
	aI0hC5omuURhXDdoC1D3NOrbUsj1LBs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YUfuO00n;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058979;
	b=BnaMkxtgpOiis6kpUrUMY4p8p/MrpdRfa48CC/REB/OD2DWPwKpmo2HW8hWxm6LB8CYa8V
	5/SRRmMEr9e2q51bQgzLjw7yMrKozHn+2WZXM2jvDVumVOjF1/LxslUYevBw8VCL2Dp/68
	VOwT85azPLgGcbdXTQfvD/rpPjO2+k4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=wi6CY0IDclqxk/0dSLImYT2+x8arQgwxuPzYw0ZWXLk=; b=YUfuO00n4mieQR7r1eIf3YWG5n
	LX3ldO/crxP/kKRkZzd1D6txD78TynbQdGAjVLyrXhzE+1tKYHBFIOxYOWcJtdsnIOe/OK/aMRnVf
	heBvNNwl1rJD8/zvwcIFCOPq0HC1MF7fZnH27Nk51faxNjLuNfEJQJtdu/w0rZlbsOrWxaJ9DKpj2
	DO68746VVq6cL2PtiC4gcXou4dywqKDBlxrYj2DR4nyYoS6HN4Sa0sN99k8GJvBc2sFZz2zsM7Y4S
	w6czDCnaID5U7kGmJq0gTepOCKPSVsbEBz+eF0S0RiC8mZvPgjrhYlnJylGQ7Dwpru39WcwHHYYKJ
	B4OG3vuQ==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hxr-000GV1-BE; Thu, 10 Sep 2026 18:49:31 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v6 0/6] sched: Add support for long task name
Date: Thu, 10 Sep 2026 13:49:22 -0300
Message-Id: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23PTW7DIBAF4KtErEsFA+Ynq94jiirAg0Ob2JVxr
 UaR716cqnIrsnzSm29mbiTjmDCT/e5GRpxTTkNfgnrakXByfYc0tSUTYKBYwxWdhv76Ts9D373
 27oLU2yhk49AzyUmZ+hgxpq+7eDj+5Pzp3zBMK7M2TilPw3i9r5z52vvVdaXPnDIqAhhA5yxHe
 EmdOyf3HIYLWfkZ/gAgawBWQEBUvi0XBlkBYgMUhxoQBdDWWK8UGmdtBcgN0I9ekAXgEdsYjGY
 t8ApoNsDAA6ApQBOdkUIbcIz9A5Zl+QZJpA9lxQEAAA==
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 402B220008
X-Stat-Signature: mwdpagk8bwcdsfn3eubhe33f7g3jeosj
X-Rspam-User: 
X-HE-Tag: 1789058979-956620
X-HE-Meta: U2FsdGVkX19QqWhN2zaIJxzF3mDlcCSy8FQhfwmV1jbnNohtlf7Px5AAue5/BSPoBGVv1N8VZbU/qdkJC9RMq3WfMLSo2rzs7DZsTSFLO8uZksW4JQuYz3mxSTW8VtQsCQrP0h0mPFnBt/VE5RDAvUbPf6pTB0PLD5nr7m3q43vzDRTiEiJcgfoO4W6fbtjD/aX9F8dK4KLG1MyXs2u1ST2zMY2oK6h9jp3gts6fHL1TBpO2Yhi4zVJEGFwdWbQd15CdV4UFdQ7c7uYwcCIiXG7IyCHqHpDSx0fKoZWt5qrzEzRbSvhR4leFRyB0rlZ4dZVH3o9dmm7YlSGwBmqFDyAe0r/Nm4BL3Oy2JywSxztQUF0ZdO7nfsyo8pj3/LlCCFeiueLGj3HK6JHtqplmyL251t9CqRejyikAwEu+IlyvWy+yzdvUytwHhSSRQ7NMliQgsA9eTLEUzC8Wrowcf2WCVpQwiNyjEaw/087mPJH290UeqzQPcqTUCkZ1GuoMRIz1jL4DaiGH1Crl8DNZGR5glWzzYzPfVK1jQy/9joaK/Ro9sGexmDuP7L6CZcQDQFFEGKNKNdbmr+6NzVLtVpiscu0bdcVPhw3oXcLxIIh0Du9xAJigFXq5dCDMf3pJwP8CuUnuZTGYDLwjZR23CQmdVyYiZ3CX5c/Uhs/d32oT9GdAwcryemejuij+royQklA+a2Xbrq4tTlz8GgBsPC39EKoyLSZgh0YPSAUjre1PSSBocPYP/pUxarV5l36Vbe3WdfUJjnkXsnnoIm1UJxidMV9JHvVqw8rMfgXxDDFrUSWfT0yHeB0SOyCbPiKKmokgN2q2gE9wxtZ67DMmgReFs3tg6cIWiybiQZy3HYWZNCCQOA+X6/FrJ1s3gFSY0ukvK5wqAo5/p8TrAZeWd2Cs/V7uMnxyUjAkCmtRTLK20tuUDiWMUTIyvvlyag+bqfymrrq96igRdEQ92CN
 JmwRILBN
 yWEXdpTHP+bWAdzZ/VM8R6rD/vcTEUP2BPEayvs71wspGcuPWdOkL65+5IXeaJKztdKidPzG/NoHDqiWEhPeuv+CL+UqDSsSkiSJsxsqoR2u4c4hTFYartsZc1o6eshR5E2mwaePJsimiT/UEnAB8gCPkt40XE7BZ2263FAj5cqB8owr1XtrNnVVcp91ocUCk+al8uMpU3kxgxImKQg63fR9qFpOgKuQ4YiiZuS4MZ4DOK2eFw0gTHKNjDOYemxUvcO11r/8Db60j7zwlJD15CEXkluhyaP9M7Jw9CglobId50IJdjWWNqg4kWO9e2aQ+8kgFDktilITR6q6JayvbcPTYOUczyV59eOTJpnVJ8Dt8wBvhqwhbNwOI6RShwZqRi7u+TsPePwKvSPaVrSID8FJmLNFcfh4sTdiK6rh0ZpgPngw/2N7Wx/6AMtG+B+L+Fcy/62er6n8SMdmgI8dWn1L4cxL7XoN8LZJjDLnKdOyi9Ym57Wz2z22cPBG3nd0oDMVQ4ezJOGV1r/E=
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
 include/linux/sched.h                              | 33 ++++++--------
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
 kernel/sys.c                                       | 23 ++++++++--
 kernel/trace/blktrace.c                            |  6 ++-
 lib/tests/string_kunit.c                           | 38 ++++++++++++++++
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 +-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  3 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 +--
 security/smack/smack_access.c                      |  4 +-
 security/smack/smack_lsm.c                         |  4 +-
 .../selftests/bpf/test_kmods/bpf_testmod-events.h  |  2 +-
 tools/testing/selftests/prctl/set-process-name.c   | 53 ++++++++++++++++++++--
 48 files changed, 198 insertions(+), 91 deletions(-)
---
base-commit: 50d05c7c76c96b90462f24debacca971d2e86713
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


