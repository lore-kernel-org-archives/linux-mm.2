Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88BD4CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D64B6B0092; Sun, 24 May 2026 18:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560246B0095; Sun, 24 May 2026 18:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475996B0096; Sun, 24 May 2026 18:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 355D06B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF4C41A0D94
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:05 +0000 (UTC)
X-FDA: 84803782770.30.FBF84EB
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA6EB1C0006
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=eQAQTleM;
	spf=pass (imf21.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rPAf6r/sNcWrx/pEdoeLsIcJ1f8m+6kcb2x0t2HuoY0=;
	b=Na/gaTr761vZSxpyLvRB04+tW+O9m3p48Lw4fnKEN5pxcIdQngraGaCcg5YMd5Gg48yCHJ
	mmw1mzYCHQfvrk3GcKLJJu8pMg0NC6Vy4vaHi8dmCZC40ugTh3zWrSPgqVaAqsKKEFMjPa
	VU4rPpAx66OeOA6v899G6UhArtr5/AM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=eQAQTleM;
	spf=pass (imf21.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662404; a=rsa-sha256;
	cv=none;
	b=QdyVD+eued5H1cbGMroimLB27Sg9FdOOGyaPxr0gb3vgBwPELnqlMQK022LkT5ayWgndyG
	WYCcVo5jDnnc6EgTeFpoqEuXzBdqFg98+jGVGjXcWxxi6FvGrwHWIk2GlxIdjmhGI987A1
	tKXG1TH9y0aM4ifx5Otq3ANzvqmwpRI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rPAf6r/sNcWrx/pEdoeLsIcJ1f8m+6kcb2x0t2HuoY0=; b=eQAQTleMH6UrDBeNfNOi2Iq//Y
	mT9lqrYfVuiI2w5yYT/9aUVVcWRuVb7NOr9J40vvVJIFJqt2f2QT40YJxoe7XbXEUJQ4OhvnuQpNu
	+LBw6uRuCluv0sXKoeudqPub3P2t4X11l7LknndvYFCHgvx0mCXbDgtLee9gw81YFCUDa8kX7A3AM
	HhzOmQ21JZESzS6E723s5msv9lB2FKa7zxh/Rq350d+zPPHwdA2a8G3ux4AdB6+plzRgh1IJDldz6
	qwnvq4LeklbLWKk7NmMg289m9MDcxtR4Vo8E+BBf221SQPFhoLfxbLoINfkVoPJrmkq5v8rPVynel
	MOeKS3qg==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHTx-007fJn-1s; Mon, 25 May 2026 00:39:41 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v2 0/6] sched: Add support for long task name
Date: Sun, 24 May 2026 19:38:50 -0300
Message-Id: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNyw6CMBBFf4XM2pq2PBRX/ochZqgDjEJrWiQSw
 r8LGFcuT3LuuRME8kwBTtEEngYO7OwCeheBadDWJPi2MGipM5mqTPTOjg/ROltfLXYkyryKkxS
 plImCZfX0VPF7K16KL4dXeSfTr5nVaDj0zo/b5aBW71c//NUHJaSIjT5qQswV6TPX2DLujeugm
 Of5AxRifqTBAAAA
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
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA6EB1C0006
X-Stat-Signature: zc4hhoyuhfz64rm9jmnq9cbpgk6zd64k
X-HE-Tag: 1779662403-650393
X-HE-Meta: U2FsdGVkX1+ZaTpkKKG4EuXjBtl+TeDscgVKiPcVxI57JxtPYxVKasKtRnGQKk0sRHlZVmuL+guAYUX8VLeW/A7fs+8F9/DUCy+UW4MznsON56hOIQ9hzc26xEaSCe+3PiJ8k/eZ/T2wEYs3pJZJs8qMsl4d2Z/n1obU5xEDtxKAxr20KAUnD4sk7HSq++kJ21oomXoI54IPITiztra765N0kjyqqDixueX4tw1X5287gx7WpBHZAiqttZthOBJIgTLdVnd3sSQ5r8RybKTdauK+nB8uABRXEQlyxxj57VoqNj4ThEZa/O72sen72Rllwh0K6Z735AxkjxNb3GlSTFEKNhK1We84AKGaTgs82422HJsnUvEzSiW5rFhRMl4CiZOf5XYHWgm+VLjNbJh+e+zspX49CLinRs5e0s96rZDE5CGYD2FxOq+phDY6G4ugp3yMvQIBfN2NoXAz6wnMCqMwfqNOkvGYJcr39CXvwU8R4H5tuZcUHbdoc382nnWGzSEYIj+4SvbOY/w0iDWe5/l+RrR6UFbl7u1QQjzNIQLStbbYG5zumnKXw55vverI+NIakG0/IvutEEGCSBgyZdhntdGXtpskfEOVxtm6zozqtxVoexhFq62Vx4pYvKbuzzY79mwpv0sXS7zd0/galHVpQbv/SfQzBXkBk8i6tWeoR6M5biGU/gpazTzqnemTPcUGThqf/fKvq5fIHXMVc2VG+3qO7zNjCAi6AXEvydfSG8UIwCUUfvngAYpA1aJLPi/6LWXOrb2YxUQa+0NIHIxYja/tgntoKC2d6amAU8+y1eAw3b55yCokK2FvBrjnZVFcQCeONAENOobggwCky+JMFBOIg1mQqPwol/E4riE9K41bDDK+73kHeqeA8+bhUAQG8yn2Ay5LuDeprpeFiRGmqzy1WQSJH3In7diTD8wY+QqcHcWRm93ofoJvvKIbc4NfvxoA8l6wgyBTDSC
 Oo9njMdl
 JA4H9mgbyDx2sATCJqNVJt8T7U7ef2DxR16zCOJx7eebaGUAOau18z1pkCVXpFJj8SfK7e2PJS9Dr+lXfqzVLtle8/+i0lWiTj146pntEYzC1K5LB+47ZS+reEfWUR3MUdRK1rfAhCs/KQP6plRBXokmz14xj4XqUfhwaLq4zepv16S6WY/laZBrxBO1kdUTn+qGfhwCt8s+Q5RzNFUVQFMFshE23sZxXLVKTGbXfDaIwS9b/n6uwGdZLenwUPeJ3H7iRUdSv8Tl+Vaqs8rajTkeV4eI9Xa2N5x/cLHNIz05h/ukzyVZfI+eMR1rQEK1HNpFQNp0mLuGT7zlLsOGBxNHKA5DtZ8ktoL8zFAGACFKm2gNvjMN9ZTdXE9fiHIQW/yCdifTV6DQLifrUM9CCR/ftid4c2wq9z4n4iKtzkcZ0nxfaSrCxGxCCt69QSQ6CV+G6g0SJA6vY4pLvcmwC6XcL6J3kw/ErUJR7WC4fu2fJOqT2MA0jINylgh1ByjmMBeA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Use case

When debugging and tracing complex programs with hundreds of threads, 16
long thread names are not enough anymore. cmd_line can show a lot of
characters, but it's not affected by pthread_setname_np() or
prctl(PR_SET_NAME), so let's give the same love kthreads got with commit
6b59808bfe48 ("workqueue: Show the latest workqueue name in 
/proc/PID/{comm,stat,status}"). This work creates a new
PR_{SET,GET}_EXT_NAME that supports 64 byte long names.

* Patchset

Patch 1 is just a minor comment update.

Patch 2 and 3 do some prep work in order to avoid buffer overflows around
the kernel, now that current->comm is bigger. It also make sure that if
the destination buffer is smaller than TASK_COMM_EXT_LEN, it will
be NUL-terminated.

Patch 4 sets current->comm length to TASK_COMM_EXT_LEN and take care of
making sure that current userspace APIs gets only TASK_COMM_LEN.

Patch 5 creates new prctl() to set and get all the TASK_COMM_EXT_LEN bytes.

Patch 6 adapts the existing selftest for this new interface.

* Testing

selftests/prctl/set-process-name.c survives this patchset, and it was extended
to the new interface. Care was taken to make sure the old interfaces still
return 16 bytes, to avoid buffer overflow.

This patchset also survived some basic trace-cmd tests, but any advise or
how to stress even more all those string copies is very welcomed.

* Changes

Since v1:
 - Replace new strtostr() with strscpy()
 - Don't replace memcpy in tools/
 - Link to v1: https://patch.msgid.link/20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com

Since Bhupesh's v8:
 - Truncate userspace return to 16 bytes for old interfaces (PR_GET_NAME,
   /proc/PID/comm/)
 - Replace __cstr_array_copy() with new strtostr()
 - Add new interface prctl(PR_{SET,GET}_EXT_NAME)
 - Adapt selftest to this patchset
 - https://lore.kernel.org/lkml/20250821102152.323367-1-bhupesh@igalia.com/

---
André Almeida (6):
      sched: Update get_task_comm() comment
      treewide: Get rid of get_task_comm()
      treewide: Replace memcpy(..., current->comm) with strscpy()
      sched: Extend task command name to 64 bytes
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
 include/linux/sched.h                              | 24 ++-------------
 include/linux/tracepoint.h                         |  4 +--
 include/trace/events/block.h                       | 10 +++---
 include/trace/events/coredump.h                    |  2 +-
 include/trace/events/f2fs.h                        |  4 +--
 include/trace/events/oom.h                         |  2 +-
 include/trace/events/osnoise.h                     |  2 +-
 include/trace/events/sched.h                       | 10 +++---
 include/trace/events/signal.h                      |  2 +-
 include/trace/events/task.h                        |  4 +--
 include/uapi/linux/prctl.h                         |  3 ++
 kernel/audit.c                                     |  6 ++--
 kernel/auditsc.c                                   |  6 ++--
 kernel/printk/nbcon.c                              |  2 +-
 kernel/printk/printk.c                             |  4 +--
 kernel/sys.c                                       | 23 +++++++++++---
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 ++-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  3 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 +++--
 tools/testing/selftests/prctl/set-process-name.c   | 36 ++++++++++++++++++++++
 42 files changed, 124 insertions(+), 81 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


