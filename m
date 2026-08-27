Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD51DC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516126B0088; Thu, 27 Aug 2026 14:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FE46B008A; Thu, 27 Aug 2026 14:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A146B0092; Thu, 27 Aug 2026 14:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E40D36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BC271C025A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:34 +0000 (UTC)
X-FDA: 85147872348.02.909F485
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 506DC1C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ss+YEE4b;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf20.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lW5yUPVESWNp8FJ60ucl8RG8n/LJobsXvM0l0Jreta8=;
	b=AUMJRMrTF0uUWXXCQfaMNbu/azVWb5NGibMG8vVKuNEtSS6aINEREZW3SyWrxKmBnz0nvU
	1oUoaFrjyZwBep5Jn7Eyy92ZuxAuU0Y5rfVycMyL4CPFShm7+vfsjXSPcxOqBq3lWZtFlr
	IWvX2KUkLseTnq/otBCxxzEnWxoLyJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855012;
	b=EyZ7VE8eY40EYbMSj0gj72WrNm/BrLPsPh3KK2XvL3SRLncUPI7Ynh1WC9Aj8+Tg0ZufPi
	NXU31omAdu0J4qa417t+g4txOnbfuFpJv1JuvNiR12XiwZI3d65Kt39uAZzwxj3svt0Bsm
	W9rhcsde+o9SPL4uIFvsMH8WXIcwJS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ss+YEE4b;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf20.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=lW5yUPVESWNp8FJ60ucl8RG8n/LJobsXvM0l0Jreta8=; b=ss+YEE4b/aZyxI4zRVBqSur/8v
	Fc85AUt8epJqduW4+yRAI2hbrSKRfL+YgA+hpmpTYZqKe4LY2lA60lulc4/I8/XwchM0EgOxcuOu+
	kO09vhl3rg/Dyg3xzRfrsnZ+eU6HE5ZWP08df2XhtDekUWbiQoC/71/llCxH0K64Zp3oidfGsRxqQ
	cPa9x3aRlEkQSEtb+pWKH6Z2S8WIPdEtL/a08HrMFp7cj/M6fZq2yN8JTpfeCsNl/7ItPOh8PBPea
	mO2Y7aDq+4DeQTU4FjpaPnX51CfSaxcUTQjwxG0jtU4t6rTTYkBTUcK90srBFdeLweMm3Up721GTk
	VDY+LmmA==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzekx-00AOUg-3S; Thu, 27 Aug 2026 20:23:19 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v5 0/6] sched: Add support for long task name
Date: Thu, 27 Aug 2026 15:22:59 -0300
Message-Id: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23P0U4DIRAF0F9peBYDA8suPvkfpjHADlu0BbNsN
 zbN/rtQY6rBx5vcOTNzJRnngJk87a5kxjXkkGIJ3cOOuIOJE9IwlkyAgWIdV3RJ8fJOjylOr9G
 ckFrthewMWiY5KVMfM/rweRNf9t85n+0buqUytXEIeUnz5bZy5bX3o/eNvnLKqHAwABqjOcJzm
 MwxmEeXTqTyK/wCQLYAVECAV3YsFzrZAOIOKA4tIArQ60FbpXAwWjeAvAP9fy/IAnCPo3dDz0b
 gf4Bt274AOov+54QBAAA=
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
X-Rspamd-Queue-Id: 506DC1C0009
X-Stat-Signature: 6sfcywm6pbh1r1ami3dhmykkx3thfh7s
X-Rspam-User: 
X-HE-Tag: 1787855012-834513
X-HE-Meta: U2FsdGVkX18CCviwTlkqyErsY6zSLKz7WHeE9ABMfdhwy36vpBG8KhkfViRE2+riJ2JjUrs01g0aR+tyLGdBJFEmuv38gpOyIeDHRQ7e5jgvyWAIn0QyAwhr5i+Pg4hgrvzfryx4/ZmPGUUJ8HfFpA5eH8HmbKAayQGmzDTNjxA3i3ivBj1XOD11NRjrXaDKaixwa04Q/GC25skLUB0sP3AqCubnxTZRQfvB83ZQ50ewsIa8QM23KOj0xGL/C8k2clPvyM9Cp6FZD34pirXEnq4WL1tyY9nXAxg1O5oY8VmLBCeTxw9nrt6AYI/MUh62x4Vd4TkJ484AR4F33nyPCuZDwcFRrUWmAXOvPYZIXHKvJ2NG1H4+UqxlVSIFJYc8pTYn+/OIbBpkc0ry3EAhDC3O8tJbSewzzsCMwq1Cx58Uuo+y1ikrSBeVKRKCXXjqFsf8ygCav+LkKPAKe6SnLjLr33cHl1AUVcwehUHP2j0ERhHiH3W2xiyh67ucmD0ANQRWiecwOCCKC0wzDL0dChJj8xnhL9cXofWxFele0iz4mQCiZHMc18Q8Kq2hfxAfdiJuzOad2X1HUsHZJy8BKtNe3rkn14b9YuZifrE59y149vlhphGe3TnNIQH0g49r0kjwwfPK4QfpF+KKZe3AUPaMmXPFCNEVwTsb0ve8jJIqug4hr5F7knbkUCmvbpnZPVDBcECTA+k3W55OMD0PakGQ+X7WQFPTLaqUUKADChAdLt3GSsE3q9bwrIU5lGcbXmh9vU5l8dOJ3FqjC8dBQjOIdBDKPkdGasNO+eDfgZRvu7HyIRmDmFKF6Onq9gyb7I9tqoc8L33RXZDnMBEDS4o8XxKRCZkHSESitG9rIQIyhPZP5TMcNGHdgJGWvUW/CotDQHoI9UWXzC/ScIOHOUdnxcHSUYEWJy5o3LzjQwTxzAHHEwtbfPRthFNYZfP54maQb9EqgoVqIdv/mI1
 Azg4xi9g
 3ul7rNwJNXw5eWyBZrs2EEoFkDkhygAw904W3+xMja4VUF6qXbFEyript88jc06XhddDsu77F0xqb4K0gHKcD6InPYY1P1bTJXwxfERijxfJ5DP9taMsv3AYjZHmEQYvlSHnBBpWi45/bUO1JB1ehclX96fOLQR38cxvw5UMIL5wyjbBqI9YbW4ETdiye0ByL3plpbA/a/DFJuJ6zBPIMHq53RM3H7dKVtce71mWRj6mxe1tBiBgU6eEHH9sIxmlZCsZ5EnhXX2QUUbEulKZ3A85JYHSbZ4j2NadI5pcGVTTs+yMZJ1DwxzUcTLH/WeH6+6ujAIiFuw2TxjItCBqPdDpSG9wbv5bhIQtMQKxigfRKMQCSWthz/yd0pUpon7IatNd/AsTl+nRwenI5QDjIPWdw3sid/UMADn7DhFCbx49HF8vI9KkRQLv8jMVzqMJ6pJX9848JMGUCMaNRIVGFXMUOAXIZ2c03F6LsgHVkAeF7F/QCKZRZKIrk5t+vdK0c9uHWBmxW9lcdRw8=
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
 include/linux/sched.h                              | 33 +++++++++----------
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
 kernel/printk/printk.c                             |  2 +-
 kernel/sys.c                                       | 23 ++++++++++---
 lib/tests/string_kunit.c                           | 38 ++++++++++++++++++++++
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 ++-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  3 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 ++--
 tools/testing/selftests/prctl/set-process-name.c   | 37 +++++++++++++++++++++
 42 files changed, 173 insertions(+), 76 deletions(-)
---
base-commit: 73e3f0710014fe6d4ed98cfc02292f6121db7558
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


