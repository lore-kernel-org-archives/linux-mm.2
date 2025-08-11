Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059A4C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995146B0105; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CC46B0106; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9F26B0107; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77C346B0105
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2DD91DD7B6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:39 +0000 (UTC)
X-FDA: 83763543318.19.9AB1B54
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D8101C000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=n9X43tgx;
	spf=pass (imf21.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kbvwlNZUn0Q7xGqd2td/p5wrTa01tYFtoJ3G9wHE7i0=;
	b=h763/15fn/edc373SK8WimJr/nx+0z9yL9ILhD9SyXJNA60F9pOd7A48/2vmXO+ADgVLib
	WyZHkM0A+iSkCjCSzQWmixFH2m0jqexS/7xNX1Jf4enlf8Q/K6h4oknhtoToaJ6P7sV58M
	+LTUY3EUgLEGqYXyqBYmZJUezpYNBcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894798; a=rsa-sha256;
	cv=none;
	b=A2MHaR624VoFzYgLy4glDCpD+GcWH3xf1dcpHkACQcErwIr5ms0/BV02KLOs6GohwgjjaW
	c1im68FRo1U2M5T6oMDzmCtfW1Tp4w4YU0oH8xHcT6ju5QuRpIjwMJN6e+QTWUUfuu3d0/
	ern/4f5pWdEBDyu93/16ck16hTk5pZ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=n9X43tgx;
	spf=pass (imf21.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kbvwlNZUn0Q7xGqd2td/p5wrTa01tYFtoJ3G9wHE7i0=; b=n9X43tgxYR31C4cKiAzLXMY6Co
	6yQPeegFMzxG1w66CbnCCZvVEIIFMyqBdZfyAArl0Cg3xE40xucrDzkTqY+mUEjZtqVyPLgMFxwKU
	cSct/cbsmeilH656OUb5FBU+nlbn2I6EJqr76OkcslpQmRfe1QXb9EpmQTtA/C+40tSHA7fdP7aLt
	lusqiBGmjevyUK8LozbceXxtULYAJkCzsqRAsZcKXRF+xSgCrxi2g9zOmyNQAOR4Cgg7HleTo+a34
	xralwBwKEoooA7s5PykDrjAfuz08Y7NqoZ+wB21Fl3/b8fzyLs2nHcRZZGlnO87WSybnGWQIo5Z9N
	1lB0rz+A==;
Received: from [223.233.69.163] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1ulMIZ-00Cdun-Hh; Mon, 11 Aug 2025 08:46:23 +0200
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
Subject: [PATCH v7 0/4] Add support for long task name
Date: Mon, 11 Aug 2025 12:16:05 +0530
Message-Id: <20250811064609.918593-1-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D8101C000E
X-Stat-Signature: ga6sqx6txy8hkyxtw9buzy7eq8wgmyc3
X-Rspam-User: 
X-HE-Tag: 1754894797-755663
X-HE-Meta: U2FsdGVkX19oHavAX/hQ1XPdXeMvynDlNMegRlvfHbkz1sruBPy6NXpoWO2Z0FBCUG8w9buC7pi1wiRHHSMJ4xuLxyAiGgF2WDdaM0n76GKu4KBTpbnNkyDle/ycli6sNXU+4IrgI4iHV2qumEJpNZvChf9jEXyBoNVPjS+uS70C5cPCq7CVZkEJvl1oahmQpsSYIxUqPyBZKd/O7o1faz3Ui2vdfVPReB2QcSm661ya0h/E/jn8E8/6oh7FdOtyFHUZLS+ezyjHS3rLAT5+US/QfAz1kp46svxYc2OMuP6lRvjoY6tAUmqLxqTezZSC44/LSFSKnWktCh7BA8Qz6yAUDBfhg3cVPf30TGxQ1LHaj0QOq9DSGylqRIA2xxrjeDxU1z4UGrXwoDsoQTDj/6i7ZM09O09xVz0PMnxA5VGI/+ag834QKS6V13gRK8XpTHp2+47EyYvc9+a+9cD7e4DohCptPFegO2My4hjGCMrWyN0d280UgXwij4R5uqmSC+POp0QHh+2Kb5OfzQ92Y0FDuhH5BKIkCCvMT0c4nx2nCbBBQ01tyinez/KQP5BGxNdNzgxRxksuaxjzivojiXJqGOFLz7g83uv7LGbOOWTfoOTs+Vq5RrwNU6pjkeC0ugwrzfyt/fN5U4Xt0OUhrIqLKPYPe9hvEBAreuvPt2V+l2U4b1GErM//HQh0AX5Nka19cXWjVM3gM6e/JcUs0QqCHNHkdqWtSuGrAdkKTlSFZhLZgKcLHx78/8KtfTPxMGq0qNEQ5gpOBDbI/5h9f4fxONVZwNo0lVVhkBXS4H45KSEnfYNwBkFrN71Zy44dYpYXbn5NgnHlhIb3qL9ubLr2Cqnwj9ekBtEjtBG7S8tG+f793K23yn0Bi9HJunSz268ZRMfE9tmJXX1wSZUOhkYJNhhzSfsFqCk9JNC/Owe7eMemroKke7DD9hbMgil2HsUUAOU36CcEORmYEj/
 yujXvoHf
 0E6wpdguEJ+bVDwtQCsDiD91gVTJRHgt4NlSXscFt2qQ4WG9i+HnhMuMFX+IBWfBtdYuzQkmnDO3oCDr6191+c4wVQhpxJSTjcodXa06T6wMiSQALqBCvzlOEHj7g0c/TILkEGeAnYJnkjLSkXq/iLW2lCbKG1PJJl+BpidP6/W16lN9+TDp1FR7MRnrCP129oAnDBGjMe1v3MwDoh8WyAaHmN3XLAC7OcQOsNl3cE/vK0fk9PBRaLy0eF57zHpCve7FLPLQabZoLRfLgpYWOO7A8Z+WubYymJBvhs9y48K6UsmtuPa1ZOYlZUOosjGORrKLbSroHrqij+FAGA1VJw+n/r+PpB816enNKGT3GPOOlP3wWzt4hhMIVXepypFMeNM66BUTG0mMJ8DLnzSrLxn8s5539ZpLMEw2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Bhupesh (4):
  exec: Remove obsolete comments
  include: Set tsk->comm length to 64 bytes
  treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
  treewide: Switch memcpy() users of 'task->comm' to a more safer
    implementation

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
 include/linux/sched.h                         | 50 ++++++++++++-------
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
 40 files changed, 91 insertions(+), 83 deletions(-)

-- 
2.38.1


