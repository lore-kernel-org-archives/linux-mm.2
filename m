Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9875CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2B06B0093; Fri, 12 Jun 2026 12:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B795B6B0095; Fri, 12 Jun 2026 12:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41876B0096; Fri, 12 Jun 2026 12:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937496B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F2698B905
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:03 +0000 (UTC)
X-FDA: 84871774806.13.D9C6CE0
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C11A140011
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fYXBXKlD;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bOoYxWO9Y/+YHiT5OUdexIFUjhWnAvvkqrCAkrMTBJc=;
	b=4NbrnEAu+iJUPX1WMAz1pFxTbFQeKdbIA5OmW5tC47sHVeGusevmbmreJVf11lINxG+/Pr
	p3PdsReODRvYmB1w5ad7SANSUmVIumR8xdn4iBYz9FTSqq690h0aGYv4a/MKa4eeQhjI/Q
	Zyi2At01GHa6EdpKmgjmOAYvk7taIrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281261;
	b=Cp5ViSmDJE8qyYWTlrNNCBd+OKspJNGa4NSeuL6VGDytAzVpS02Q53/IBxQRZ0NE4LjwAG
	UPdgZ0m1EFL6/DP/D/SmfKIP3k2lhQ2nGXyAYwc//s0YWbaDnm9o+5Bq8QLsuNgTsOpvjt
	EBZP69cyPSfskzGZrnahRolS/8NdzmE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fYXBXKlD;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bOoYxWO9Y/+YHiT5OUdexIFUjhWnAvvkqrCAkrMTBJc=; b=fYXBXKlDFX26r2yWhzPnm2Bnlb
	0xZddDx20/fDCi+EhQ2LyL0x4te5Rh9iRrp7QTttFEc8ItkziOWZG0W3AkEr1xC55uMagjGgr1/tw
	NPs1RBx2+Al9kmvbzEOgHGOjit1Zeuv4zYlbxeG5007wH3wGGax8+kTnMIwXgO664E5XuLANhBifc
	q671SbZweaVwykRQKjHnGUNjxZep75FyEjeSE+e2uf/G9NBQ6piDtWudiG3ZJhCmR97b49pkdD93F
	83y3I8WhdRSWi2aYgLUqI5GMomsdeXgxD1KndT6JcDHpuLRG99t/bGITzWqoz6hRaVYurxvCmYbfn
	v64gfD4w==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4cU-00GgP4-Mv; Fri, 12 Jun 2026 18:20:34 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v3 0/7] sched: Add support for long task name
Date: Fri, 12 Jun 2026 13:20:13 -0300
Message-Id: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XO0QqCMBQG4FeJXbfYztSyq94jIrZ51JVu4UwS8
 d3bjKDw8of/fP+ZiMfOoCfHzUQ6HIw3zoYgthuia2krpKYImQCDjKU8o72z4502zlZXK1ukKi9
 FkkpULOEkXD06LM1rEc+XT/ZPdUPdRyY2auN7143L5MBj76vvV/rAKaNCwwFQypwjnEwlGyN32
 rUk8gP8AJCsAYiAgDJTRfhQJ3/APM9vg6TusQIBAAA=
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
X-Rspamd-Queue-Id: 2C11A140011
X-Stat-Signature: 6kz7q1ysqcnuncoo1exgxkgfym86mt1q
X-HE-Tag: 1781281260-512591
X-HE-Meta: U2FsdGVkX18B3x/wb8FO96b1fgglQ2NSz0hRSXgFgGvkcFskUGuq3P7oM7tiVhkYWVjkj2iqxuObP/9bQpiQgl+TxAHWfLiyNsrNtdNm8FWRx6J6Sw85h97Q7OiRTY2vNeTVdfFCYvtKtN8qNI2E7Xjd18xbNZIpjC2w4h/YPDQeZ88TX/cHcCOoY1SknSNB0NAjc20IKhqBIpXx4IiGNfQhNOkXqAZ2r/ZdPmrN8jn6qoIo9ZJUg7J5VgVjRKkXuqgsNYTNdx4ZYRASG46EpeDOR53U/sFdAQvk04lnMmIkijTzZuuIPIYHuwZZ11fpT0DoA5l8pOYa/qQIl0mZD8pBORETL66WZAYQCL2QNqIx6Wdtqzl88YBlgzZz3S5dpAA5origg9d6HfizWcT4HunUP2f74fxuMD+r50Ra7mNg9FWU6sDlX22W7ukw1nei3+0RdfqgMbhQ2PFZiC7Mywi3nsojB2bnaNsIzsT3VDX+hZsmwJlp8n+MuFXRfNciiCEJva91Kyy1TVIrkgu6i5KDEFPxSBCTetcjeQFanOBxz56mJofuEcyjNFMaWsoCIanFR4FN+ePCPpxvUoRDY3nuMGIFTUgqujyA+YTEagl3DMZxD3ZK1DOOgN2iimVUcjDQOkJyDzKq0otlM9xjPoxs8oSoSZhxk2m6vBfdEUZvtSqi50IY4XxcNj5fa/9oyXMHENOj28LyFH+lQ22MEbixlLhv/bqxYbqiZdfbLuw206UUb6LHcX53RcrHSemtLUIUljCCgO7Lr/jcjylZrbRSyeGgR/rRY+SiQNJvCFi0B8y76H92GcM2kyTaIa9vVDyAJB1wDU96j9WiFltKhXqEhqLe1Nf5n0SZmTL9BE/jyA1ssOX0hySmmRvmahUi641f4Ha/BF82rYyZDSNzstdqgyjo0cfS3p6RJUeX5w1uB0mqx7YXlge/sUbD1kq7kGE6RUxzq66tqbOlKd5
 lNYbNQgr
 cCma7andV7LWv3I8uwRMql58D0zNEoYsoF24g5Vst22FAULvIkbLh2RZnAxFXXBVfi+TOAkhK+Di4YIIH9ooSuZPEGKp4Sce/6oSg5ucifG2wZ6hhKtTmtWvJw0k8siXC5/k27E+b5ysBnxTR/Ac9vV/l8S2rkvySIHkoP3CL1JpEA5P74RAEVxjvTHOu57q4k56afPfsskvxlREIqEgWcmLicBuiaNnQSqrmQI8/yOKTaUsVhIQqzBO8GQzcX3wUL278vpAiDt2XXLeM69lAStLF4NxWp8mQnIA+nrVQVir8nGO2a2lIm275ChfrVb/bmUkKCpfl0glljPTy9K1uZddpif3xiGFhvBM82Hp+/2KDzaGEUIR9NS7MNsf9p4H0FVw3yquZpUarmvN4kzPLXa4Sg781QArcUu6zX4Gsncn3gr+bGY3j+ABZI+OTKI2qYfGBp/WJswY5wJZPEQdnBTzs9WpvIhYvzvGKO1UFKN9zAWiaNyxkAOMU35Walh7uwxYvn3gTGMgEEbI=
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
/proc/PID/{comm,stat,status}"). This work creates a new
PR_{SET,GET}_EXT_NAME that supports 64 bytes long names.

It also introduces a new function copy_task_comm() that ensures that the string
is always NUL-terminated despite of mismatching sizes of buffers. We can't just
use strscpy() because it proved to give some overhead[0] in tracing.

* Patchset

Patch 1 is just a minor comment update.

Patch 2 and 3 do some prep work in order to avoid buffer overflows around
the kernel, now that current->comm is bigger. It also make sure that if
the destination buffer is smaller than TASK_COMM_EXT_LEN, it will
be NUL-terminated.

Patch 4 adds a KUnit for the new function copy_task_comm()

Patch 5 sets current->comm length to TASK_COMM_EXT_LEN and take care of
making sure that current userspace APIs gets only TASK_COMM_LEN.

Patch 6 creates new prctl() to set and get all the TASK_COMM_EXT_LEN bytes.

Patch 7 adapts the existing selftest for this new interface.

* Testing

selftests/prctl/set-process-name.c survives this patchset, and it was extended
to the new interface. KUnit test was modified to support copy_task_comm().

I ran the same benchmark as at [0], and the result shows a increase of 0.7% of
overhead when running `perf stat -r 100 hackbench` with sched trace events
enabled (`trace-cmd start -e sched`):

Without this patchset:

 213,745,340 cycles:u # 0.119 GHz ( +-  0.33% )

After:

 215,111,672 cycles:u # 0.119 GHz ( +-  0.36% )

* Changes

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
André Almeida (7):
      sched: Update get_task_comm() comment
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
 include/linux/sched.h                              | 35 ++++++++++----------
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
 43 files changed, 178 insertions(+), 79 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


