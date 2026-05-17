Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B37CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C586B0092; Sun, 17 May 2026 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3916B0093; Sun, 17 May 2026 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A094C6B0095; Sun, 17 May 2026 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9826B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54E151A064C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:09 +0000 (UTC)
X-FDA: 84777768978.23.DF2BE01
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7024620007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fOI6QLnB;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u/M76BVWshst0Dnbf2AQffTJs1u+H1d3HT0aS1ycKRg=;
	b=0s80CT2koWms/kmlaOHPWapAfbj5n5t5POlIHnVVdbaClyUVHrWG6Pi6ruI83f5XxFASOw
	k2lxevA8gkcER6BppgDeCmtp1XgC6AC5BIHHEZdp4LoMR3EzcwvolZCCygxm8LwkRWV/OV
	AEW6EGPxsU4Wc6QEYEqETXbLL36MHpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043027; a=rsa-sha256;
	cv=none;
	b=AFKGMjyyznBYU68txusnwb8MhYyyOcldggB2arDdLkkiPv9+qF0uqZkbwMCd6TW7IOGhNX
	2t6IMo4hk8XQAlsHFVZhreIK9mv9q6vv/z88D/8ifRQV29FRP6028314DYLTqGAhXkHb/U
	QXiIWWF+z7FEfTaf4/FmmN4mCfp2Xtw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fOI6QLnB;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u/M76BVWshst0Dnbf2AQffTJs1u+H1d3HT0aS1ycKRg=; b=fOI6QLnB4Ih/4IdsVYjISfhu/4
	hzrDurlfv8WolmAwZe+jkKOB8aVnTx59RIZqG5taVB3ify87Ag7J80gCz3EtaD//z/JVjl2rzXpyj
	djKSPyaMl/+0XsdCXlhwF3kVME7Ofx4sxGnZBzfnYcVTwYPQVZMU2Qlxqa6B6XpTatBaTAEbYKlQf
	lbYV3NFwLRcf91mkkCNgp8wIhDPtAbkcVIrjdX66NzBJo7rsq7TcKJZVi1KB1hQsfvbk3hbmDCJbq
	Dp6DYWqSfE6FKx72GyZK5Kx/8M452/3Hu4PHC059ZyPywIlR3pUk2JrNFZjelQFoflzkAxb+RQ068
	IyVw0h9Q==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgM3-001cLz-GY; Sun, 17 May 2026 20:36:47 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH 0/6] sched: Add support for long task name
Date: Sun, 17 May 2026 15:36:10 -0300
Message-Id: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0Mz3ZL8vMps3Zz8vPT4vMTcVN0kyzRjE9PE1CQDE0MloK6CotS0zAq
 widGxEH5xaVJWanIJyBil2loAAZxdQnMAAAA=
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7024620007
X-Stat-Signature: hf31b13gubirfdyjewb4xs6b117nh47i
X-Rspam-User: 
X-HE-Tag: 1779043027-803645
X-HE-Meta: U2FsdGVkX18B6iyN1Tug1ZfZxzOZvGq5+FrL/C429bj/Rvi1+burbNvkYUcQb8ICygN6gP1KcWbceDEl8kfmP76ja/UJkrPNC9HMJxUPHILfyg1loEueOw0+tGfJF8Hrp5TwmUX63JY8sM8sGrh77Lpe38KNpxuuHd9ax1MboXszf2CJSQSj53jUKUwHDM8Hf7LUo0WKE5FfYKLIt4P6DJhdzfednqszkXqlmcFDj2OFM3Rq72FOdqm6YWtlF7Pu4ejSG0vgMws8M/14QtOf3b8loS8us2gBaO+xsALhfj5m855EWVY3rTLzjjPC/ckgL6WDxzDwAd2zAH5+mKoLYxpLUr9OVHdbsgMr8bf2xm5LFm1ORWz6xWMhmttiKfhuFE6mn98BZs/f3HwQBRrdTuyId5UiS9gOq3R1rZdewp+nbepYGfotidKv+/EU5w3qDGz7YkaNrPGxfxg6Cs3RAbkHHv4TtQ4fwzR8pa35oLvRycHiYRlNsTRYVZ8aaaZYKZDwqmXszhtO4Xk85fE2U0JWvye2Z1CTC9uT3sAhe5Kl20pqH1jbI5Y9GsnxQqM7H1tL1CK2ZXV7xevqWtb1Ccyubba/Bc/yKUa4tTu2dSbYquPM57nJhdl0msrvbc3YWhdcPVS/dlRmI/pEu0VybHdUeCYDsIDc3MfRATUdHJw4Azwf+QgpfL0XnZDrbbXRyb2Dn+l2s5QUl6mb3o66+Dz5Z1T7Ybmb/+KBmUsv9d4s2KeAHUqlb1R1B3xWZuIp6X0qBhxD14Tivm/H9d48Vgui2OynFslLNH291LcssCpAuttZXjuODLVncK5tWLmuPkDpf9t60ebtlhYk2tA03BNaI5+nHh1CLJHaaPWtJgjFwpJDVbBucoZMpwGVVP7VEaj5vTnpBxmNL99rUMRt2+lCzhO6uFoVlTifK+fGDKr+RX7cLOWuqgaPn8ssg2wmrdw4wWQianidrhOzvhS
 gauMFIUW
 tAhF6enfppjMdaR/yx+4aURI9sYzDcsyIyNPhZZqlLa+Kit7w6F88t6ve8XZVzjKBf5PHEeTq3KicjEn0FAnqLQ5h9mHAwU34M2m4Gp6YyNMQqBr5BV0H6Wa7Phq2DjbhOA7Wl0v/GyCiH06VC0HePgIV/0gwHHYTc1QSwA8erngUB1XuNsPl5wzqdezlQ+PsHeTrK4cBMjlhTZtAeBVJH392T5tGA9dpTqnYDbvwDBuhuOqBB3o8fadH7G4rdy2ZxNnIJU9eswU8ukDQ64wdeava6yOIhhygFvxdDZqJrUUyZHZwL/qWa28RdsGmVgvdIQvXSk7yXjBciMt5hmuJNgRdb7rzW5Afd59267K/At+Ah/vuPpT2fsCs0cvkEfuj/fbRUeI+YFf/1MMretYnZ2b9zzsDOc2Rx8NqaCNr982gkyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks,

This is a fresh re-spin of the work done by Bhupesh at 
https://lore.kernel.org/lkml/20250821102152.323367-1-bhupesh@igalia.com/

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

Since Bhupesh's v8:
 - Truncate userspace return to 16 bytes for old interfaces (PR_GET_NAME,
   /proc/PID/comm/)
 - Replace __cstr_array_copy() with new strtostr()
 - Add new interface prctl(PR_{SET,GET}_EXT_NAME)
 - Adapt selftest to this patchset

---
André Almeida (6):
      sched: Update get_task_comm() comment
      treewide: Get rid of get_task_comm()
      string: Introduce strtostr() for safe and performance string copies
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
 include/linux/string.h                             | 28 +++++++++++++++++
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
 net/netfilter/nf_tables_api.c                      |  2 +-
 security/integrity/integrity_audit.c               |  3 +-
 security/ipe/audit.c                               |  2 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 +++--
 tools/bpf/bpftool/pids.c                           |  4 +--
 .../selftests/bpf/test_kmods/bpf_testmod-events.h  |  2 +-
 tools/testing/selftests/prctl/set-process-name.c   | 36 ++++++++++++++++++++++
 45 files changed, 152 insertions(+), 84 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260516-tonyk-long_name-b9f345aeb041

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


