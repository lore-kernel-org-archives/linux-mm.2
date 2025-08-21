Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBA8CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3396B00CF; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B640A6B00D0; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AEB6B00D2; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 917D66B00CF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42E081163B9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:16 +0000 (UTC)
X-FDA: 83800374672.18.3DDA57D
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B87980009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=M2sHXqfv;
	spf=pass (imf02.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5fAj2cSbhfdyl5wHRo8bodfmrhTv6+ffnCJX2SNkoj4=;
	b=GLAs9uXnAjrVoQKqdcEmBC3WIbVkLsLG115ODeBXWYgfSrx23N8+JL6xP1KU8EYfoWDSFm
	42m+WooKG5k9fOAqxtqEaF9Amk9VxbMa27pOhCI8MeC7rfWNuyCFrXkOYPKqomFd8xlZXY
	ugkhTJFzlCU0zUoYQMYvYOvgPM54IaM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=M2sHXqfv;
	spf=pass (imf02.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771734; a=rsa-sha256;
	cv=none;
	b=pn0zlPiWxrTSc6CIsHBNuZF4USZW9oF3FCxuOoJesBJTxKcDWgv33UXmOTYmd6ruRkjASJ
	Jf3Z9miUVeQx903VpWd7uDTnQMC2tcbMBWKtB7WD2arnL+JA6PVaL7Iu8Emy0ZHZ2SYM2J
	W8YeY35YDeheml8vYj6ak+ic/+LLZt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5fAj2cSbhfdyl5wHRo8bodfmrhTv6+ffnCJX2SNkoj4=; b=M2sHXqfvSZ0Xbt0+4tJpX5Vgqu
	azYJNE9aicGjX/G54/xT9PSWa1l68fPWtER5Dgfm+zxrtwGOviydnOnxZCMilJmC/dXszDBIsXSaS
	BfaofoeTPPaRj2L65W6VxMDz+kV+VxqADd3IlHW33XebnKohuzZ9axvc7eEOKqgcPu+gO11N/21fG
	YxGJv9EPnNZtZry9q2xZUqlBig8K42MXV9F7TR8HJXuTd58Hlu0nNJKFw4+WaOMv+fY08/Myhxkv7
	nCLMxTPzh+dKbzb6WatptwO30pRffs/pprgcQsFDHg9gRsxeUjNVc/RgCPaJmUgsS6zVtVXVQqIs4
	dJM65gpA==;
Received: from [223.233.68.152] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1up2Qk-00HBmV-9u; Thu, 21 Aug 2025 12:22:02 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v8 0/5] Add support for long task name
Date: Thu, 21 Aug 2025 15:51:47 +0530
Message-Id: <20250821102152.323367-1-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7okfat8rjjuhq8gi4bqryxiw1k9rx1fw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B87980009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755771734-435336
X-HE-Meta: U2FsdGVkX18CKOXE4WpMv2Xy0T8El+krOzWM/0paE0t59UpQsjUTNeIkrm3mCYeioVUUIYUPHp2KNuNyAvFxqlmGvBEiCoJt7zYZuC/i9OQH6+SPggfSIWylwYYKGqHDdp6aj8VwOnr6oAr60BvB23CI0g28T9P+DMVKYRzz8QlaH7kHSDqtdf+95KMyEC5njVVBh7fdTGEqobHWe8k9RMSGv5t53iY0ppxd7D64SJHQoiyD683bqg0gw3T5SIUONHdlUAhtGuI0O268zaNMAnzPmut0pFBkZdbsHyyQd6E6/YPKlLL6mY/9O9sVwDd6B51aCa0ao50SotTadrl39VntJTXR+ol/sJvecrgmvoXwfraqbKlK6VOzyMLh1kE7MrOXvuztpiTkbRvZBec39PJ92uRQOmaYdsVvW7Jxd3UMJq1+Oz+AORtvKZSK+SZBH4lXV6APNkMnyK37DlNcOzB14SUQH4lqpF0gSdQO0se2859GBqqMpG9wmQym4cxt4syLpwcdXRIJ5QZ79kCjIOBtkBiIhCoSJ2h3UmtoTAkoJlWYBud9CE6Uj8UniLgmFTUsWR3ZpVer7W21FdzMSlQAKwMbTTG0DNwf1uhmDg3Hj849ISqEK4Aq7yejj/Mwx9ZOcfvAu30TOT4FKrbo1OikgnH/AsWD04eLYyguE1yp2hcKeutao510oYJv2+mLxNcU/BaIGOgnw688J4ZxE58ii3G3OrxGYJ+Zpg9cYhdpUgCvfSaSsPRVpC89+CQ2dPJjyJ6EyhQvF8NmgT6okMIpRIu6Ckm8g2CtIVu43QncMoK+Hqzd+glT9gUm/AAUYPokU13FwSWUGchvgcVvwX2Q6k9QKQ7eGTIJQNf8TrzwSVwiIf8jKkQOUpxK4u+n1k7UFg+NZpq1bc7Kb3NI1TBSfeElu6xEzMcmq3dn+hW1eWYhJwE+uPSdf1nhUUXbwp/AOpdJ4dFsTZaiHOn
 rPymgygo
 8XSx9ymnbJL5wJWH2BPu4+xfvzcjWnqePCsgBuB2NT4cUS66TRmh/TgPbZTMfaP85zF4f1oUaD5nac/R7K4UYrGmSlN1arQk1DSoOGQiCa/V3xuUdBV/Skw2TKQUDsuOBmwm2FkLRYzDHudeSAo48ty9lfSy7kOHqe5nj65sesetWFraC+k1fDBMhjUdS/hB0dVBltWBP0NfyzQfVApe6d/yWxDlzZbUP1l9iamIA/P3cNayaj4tFiAa/d2v+RcJLRo09DvF2+Hn1Jz+4Kzj2PmGIkcZEmYnSHhmIek7J8Wu7UmtB+X3+uVUut9DiwBqhfpcIBORJ+LV7a46+MAcGokT0OsoWqvueUckl92PVB2XrJred4gVgEkUDo99E2uK1ovCaUllHeW+eV+zaWiS2DU7VLOKPUKfj9DSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v7:
================
- v7 can be seen here: https://lore.kernel.org/all/20250811064609.918593-1-bhupesh@igalia.com/
- As suggested by Andy used '--base' option with git-format to indicate the version of
  'linux-next/master' this patchset is rebased on. Also used the 'Link'
  tag in the commit log.
- Also added a new [PATCH 5/5] to replace BUILD_BUG_ON() with static_assert() inside
  'set_task_comm()'.

Changes since v6:
================
- v6 can be seen here: https://lore.kernel.org/all/20250724123612.206110-1-bhupesh@igalia.com/
- As suggested by Linus, we got rid of 'get_task_comm()' entirely and replaced it with
  'strscpy_pad()' implementation.
- Also changed the current memcpy() use-cases which use 'current->comm' to copy the task name over
  to local copies, to call a wrappper like "get_task_array()".
- Collected 'Reviewed-by' from Kees for [PATCH 1/4].

Changes since v5:
================
- v5 can be seen here: https://lore.kernel.org/lkml/20250716123916.511889-1-bhupesh@igalia.com/ 
- As suggested by Linus, replaced 'tsk->comm' with 'tsk->comm_str' locally, and verified basic
  thread names and then changed 'tsk->comm_str' back to 'tsk->comm'. So essentially now 'tsk->comm'
  is TASK_COMM_EXT_LEN i.e. 64-bytes long.

Changes since v4:
================
- v4 can be seen here: https://lore.kernel.org/lkml/20250521062337.53262-1-bhupesh@igalia.com/ 
- As suggested by Kees, replaced tsk->comm with tsk->comm_str, inside 'task_struct'
  where TASK_COMM_EXT_LEN is 64-bytes.

Changes since v3:
================
- v3 can be seen here: https://lore.kernel.org/lkml/20250507110444.963779-1-bhupesh@igalia.com/
- As suggested by Petr and Steven, used 'comm_ext' name instead of
  'real_comm'. Correspondingly the macro name is changed to 'TASK_COMM_EXT_LEN'
  for the 64-byte extended comm.
- Rebased this patchset on linux-next/master, which contain the following patch from
  Steven now:
       155fd6c3e2f0 ("tracing/sched: Use __string() instead of fixed lengths for task->comm")
- Accordingly, v4 drops the changes done for 'trace/sched' events in v3,
  but retains the 'safe' memcpy' changes for other kernel trace users.

Changes since v2:
================
- v2 can be seen here: https://lore.kernel.org/lkml/20250331121820.455916-1-bhupesh@igalia.com/
- As suggested by Yafang and Kees, picked Linus' suggested approach for
  this version (see: <https://lore.kernel.org/all/CAHk-=wjAmmHUg6vho1KjzQi2=psR30+CogFd4aXrThr2gsiS4g@mail.gmail.com/>).
- Dropped kthreads patch from this version. It would be sent out
  separately, if we have a consensus on this approach.

Changes since v1:
================
- v1 can be seen here: https://lore.kernel.org/lkml/20250314052715.610377-1-bhupesh@igalia.com/
- As suggested by Kees, added [PATCH 3/3] to have a consistent
  'full_name' entry inside 'task_struct' which both tasks and
  kthreads can use.
- Fixed the commit message to indicate that the existing ABI
  '/proc/$pid/task/$tid/comm' remains untouched and a parallel
  '/proc/$pid/task/$tid/full_name' ABI for new (interested) users.

While working with user-space debugging tools which work especially
on linux gaming platforms, I found that the task name is truncated due
to the limitation of TASK_COMM_LEN.

Now, during debug tracing, seeing truncated names is not very useful,
especially on gaming platforms where the number of tasks running can
be very high.

This patchset does not touch 'TASK_COMM_LEN' at all, i.e.
'TASK_COMM_LEN' and the 16-byte design remains untouched.

Via this patchset, Linus suggested 'tsk->comm' is made 64-byte long
and equal to TASK_COMM_EXT_LEN.

To avoid any surprises / bug,s I replaced 'tsk->comm' with
'tsk->comm_str' locally inside 'task_struct' and checked compilation
of code and basic working of thread names:

       struct task_struct {
	       ..............
               char    comm_str[TASK_COMM_EXT_LEN];
	       ..............
       };

       where TASK_COMM_EXT_LEN is 64-bytes.

Once done, I changed the name back to 'tsk->comm'.

To ensure that the existing ABI and userspace continues to work
as intended, we ensure that:

- Existing users of 'get_task_comm'/ 'set_task_comm' will get 'tsk->comm'
  truncated to a maximum of 'TASK_COMM_LEN' (16-bytes) to maintain ABI,
- New / Modified users of 'get_task_comm'/ 'set_task_comm' will get
 'tsk->comm' supported up to a maximum of 'TASK_COMM_EXT_LEN' (64-bytes).

Note, that the existing users have not been modified to migrate to
'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
dealing with only a 'TASK_COMM_LEN' long 'tsk->comm_str'.

After this change, gdb is able to show full name of the task, using a
simple app which generates threads with long names [see 1]:
  # gdb ./threadnames -ex "run info thread" -ex "detach" -ex "quit" > log
  # cat log

  NameThatIsTooLongForComm[4662]

[1]. https://github.com/lostgoat/tasknames

Bhupesh (5):
  exec: Remove obsolete comments
  include: Set tsk->comm length to 64 bytes
  treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
  treewide: Switch memcpy() users of 'task->comm' to a more safer
    implementation
  include: Replace BUILD_BUG_ON with static_assert in 'set_task_comm()'

 drivers/connector/cn_proc.c                   |  2 +-
 drivers/dma-buf/sw_sync.c                     |  2 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c  |  2 +-
 .../drm/amd/amdgpu/amdgpu_eviction_fence.c    |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c       |  2 +-
 .../gpu/drm/amd/amdgpu/amdgpu_userq_fence.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c  |  2 +-
 drivers/gpu/drm/lima/lima_ctx.c               |  2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c       |  2 +-
 drivers/gpu/drm/panthor/panthor_gem.c         |  2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c        |  2 +-
 drivers/hwtracing/stm/core.c                  |  2 +-
 drivers/tty/tty_audit.c                       |  2 +-
 fs/bcachefs/thread_with_file.c                |  2 +-
 fs/binfmt_elf.c                               |  2 +-
 fs/binfmt_elf_fdpic.c                         |  2 +-
 fs/ocfs2/cluster/netdebug.c                   |  1 -
 fs/proc/array.c                               |  2 +-
 include/linux/coredump.h                      |  2 +-
 include/linux/sched.h                         | 51 ++++++++++++-------
 include/linux/tracepoint.h                    |  4 +-
 include/trace/events/block.h                  | 10 ++--
 include/trace/events/oom.h                    |  2 +-
 include/trace/events/osnoise.h                |  2 +-
 include/trace/events/sched.h                  | 13 +++--
 include/trace/events/signal.h                 |  2 +-
 include/trace/events/task.h                   |  4 +-
 kernel/audit.c                                |  6 ++-
 kernel/auditsc.c                              |  6 ++-
 kernel/sys.c                                  |  2 +-
 mm/kmemleak.c                                 |  6 ---
 net/bluetooth/hci_sock.c                      |  2 +-
 net/netfilter/nf_tables_api.c                 |  2 +-
 security/integrity/integrity_audit.c          |  3 +-
 security/ipe/audit.c                          |  2 +-
 security/landlock/domain.c                    |  2 +-
 security/lsm_audit.c                          |  7 +--
 tools/bpf/bpftool/pids.c                      |  6 +--
 .../bpf/test_kmods/bpf_testmod-events.h       |  2 +-
 40 files changed, 92 insertions(+), 83 deletions(-)


base-commit: 5303936d609e09665deda94eaedf26a0e5c3a087
-- 
2.38.1


