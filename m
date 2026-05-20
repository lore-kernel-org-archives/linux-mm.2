Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCA4CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D1B6B0005; Wed, 20 May 2026 17:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7526B0088; Wed, 20 May 2026 17:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7436B008A; Wed, 20 May 2026 17:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF93A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:49:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8297E8B33A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:06 +0000 (UTC)
X-FDA: 84789139092.02.34CE32A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A76B340009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egQBDAML;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779313744; a=rsa-sha256;
	cv=none;
	b=zXp09au5ffCi+NJjwxb8hIuEhOHI1qvTW2VKRq08Ysd/veiIRgcGbCppOfxX3kuHf8bPFI
	A1wZIwpAI8PTFJ4zj81NUygNWmli6P0FIaJp0o2l6l/deyPCgsOMBik42cJC/AtqWzPeGC
	3H+Y8Mz1c6Do/rO+3j9VToZZlXR8RJc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egQBDAML;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YDTE8Ml9PFGUMxCGCreHoqelKfkU87+CEpzIHuQtJGc=;
	b=nh9xrmzMHtatVt1ZhCVrvfEEgQSmmuwFbNYf/wS/RZg59rDZ7Au1dOssgCBspdY/zT8rPs
	KPKcyzJlrNqSU4ivv6GSRLAqTFVHLV5wWfJf05FIuK8wbTDnEJKihMXVqZR96ZPjca5613
	Ty27NSLsSd4KnDfzYmVIuyUyNbA+1/o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D23C140208;
	Wed, 20 May 2026 21:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CFE1F000E9;
	Wed, 20 May 2026 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779313743;
	bh=YDTE8Ml9PFGUMxCGCreHoqelKfkU87+CEpzIHuQtJGc=;
	h=From:Subject:Date:To:Cc;
	b=egQBDAMLGOY+XdtH/AQLcq/Q2nmU8EbryP41NDOA9k8jzK1uvkndrQ79kq+IH3u3g
	 lktnG3sFTujuM/CT9930xJK5Ny91j+SRCbxgX5sVTbN/cTCTefDObdiE/lmuatggyV
	 nSRFduup6/eYNEFShA8GfBhBKzO5fVFO71uMcl+o6Vyu5a3YcRC4EM7flS1a8C5a87
	 hmZJPA7GP9vXkrDPTrHPcgOnnqbTr4xm4w2Kn14lnN45SVMt+AvbubbNhGFhfT0vnm
	 ORPt1dgkhWJFh9A16hSjaO+V1FDBk4xod6xFZ9d/SUR+6eZQbxkYvWTtBKcwPAEkFH
	 kq+cIbNIUjreQ==
From: "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH RFC v3 0/4] exec: introduce task_exec_state for exec-time
 metadata
Date: Wed, 20 May 2026 23:48:51 +0200
Message-Id: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEMsDmoC/3WPy07EMAxFf2WUNRkl6SMpK6SR+AC2CFWO605Da
 TtKQiga9d/pYwMLlvfKPj6+s0DeUWCPpzvzlFxw07iG7OHEsIPxStw1a2ZKqFIUSvCvyfc8Quh
 rmgnrECESN5kSVWNsRkXG1tWbp9bNO/aVvTxf2NtRhk/7Thg34DZmIRC3HkbstmqAEMmfwRYtk
 tGgtUGrjQBRVCYHhZDnplU2lwCtbTdC50Kc/Peun+R+7jCV5WFKs4v1MPAkueS6tIgaVZ5VzVN
 PfqSP8+Svu11Sv7b/+zMpLnhFYAySFRWVfyjLsvwAy8tNHlABAAA=
X-Change-ID: 20260520-work-task_exec_state-83209d8b3e53
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=4935; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2xg4fbh48W9RBVH8Ko8XV8To66Gh0JP1aCu9Y/Dc35M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx6XgvsTnJfy0irOvU10ylsj3R3f0RUlsjCxa13dGZX
 npe/u3VjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImsFGNkmDdlJodLZtgvOQG1
 xv9G9ms7ziTOPL5mQ/Q3R91zGgo/rjMy9Er9TakxFkmOLrkfnilv51o0Qe3007kMGt2H/FxeBX9
 lAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: A76B340009
X-Rspamd-Server: rspam03
X-Stat-Signature: 8kjm1fmbpksp9pzktmk89z8yzxos3pcw
X-HE-Tag: 1779313744-776800
X-HE-Meta: U2FsdGVkX1+CZRp+YVgKgtaNqpftu91vSlFGnDCqCeZQaXSw149w1dlrw10KpVSMkgK/h5zC/SAs/JYOfAdMQqB0MDuEcJP1buNkWgP+c8fF4fd7pPBq0nltHGwYj3op14c+8jrabLbKeJyLNAEdU70n3xBKQx4/EiFUj0yPJWZ+LKm2pfH8WbI8MAtv/ZdRk8K4tJBNKa8DI1+MCbARWxufM2oCkpJtzvpuLWOzGiOIWsTYNfNSIabnY4YCklqtEHUfK1wbYmzfI1TTpulovjIOHb0nkfomlN1nQ1SCDcWskkprCEk9FHsO4vdVXU+WJxbdfTOvxE/ojWY0rU8aHA0mN6eYn/91L/Kkp957LiACuAwquaLQBQqAIuQ2KERraHfKbDD8wwIQX60TOWBswSPfRmNyRcuKuz/i2dMnfHjTw4uPXtW8sWP30JM8adhINXQbu5p1goEqYQoSLQez7t/MnXs3uINPw8wsQXAG9V1hjG7RapgWXFYuhCrRjobm3u3RSuC1KuqnI/kElAgeBydL+K5hvC+caI2vEj6K5ci1H53D5VbWKHQSr/UUJQWdC55LFdK0e3gQfXZ5Qqb6/sIGBmB19vPj3pNSITN4jm+ovenDODiN29GuV5P0ZKxbCsYo5q2QMpxrVIfp148cSizR8by1xWFiBM08JdiSagwFJfnW9re3jJlnSu1flRgvKjB4V96Xdh1o9vxtUQAr58PPZZK6588CNafHKIdDmh88HcdBjRGeWe+4oDnxvujemPMJIO2M3F2xrkauWx+PtDITJ2SzYNX+jhlaxXkd8ZpStYkhtnPzXYE8PSSocfVBNZi8peYZ0FdHDIqHP0KqbcZtj5VbgdoyPjrlVGSlVqBk3JUoMLTnL0v+GF8btx01OQJaQKsVcuQryPZzQwCe+hll0TJuuTqV6DicRsjLwKoGrKfciMj8785vSdBWE28pKjf8b7u234yUxUt0v03
 RLVx9ULz
 /pZ0+zhX2S70e0T05dO7rd4PNgbaPwFe7OcTMYPxRe1vWhDG3hIgpywdq90VW/7UZy763o/zU8c6L/RBuXpFyeqlwdW2h9rlBEePST0dGvev1RhpL0CfnAQ2bt5JEGjjA+NlOk2hva2OCukD8/8drAicYVH6wXelY4IQPq2Y7sbMOwC8LYzhZlcVGDxovx+XNPYVCBtdjRmuiPBRLeFusPiQpWuKk8PxbB+STpKN754wpDZwmETYqgPieX0VB1QH6gvgS10akVs+eniaR0zR79rb66WthChiwXtXpRYdd04CWAYOzk3M7R5ln3BHAq6xFycW+d5SEBY4yCNHscSPtxZpsceIWYHfu8kG+YPc+Idv+X0Kn67Jx4pWe0/D7g/+9GQCnsghkipX20xRwnIGQJHg6hj8eYwPW/NvX57512PhV9BKOKbsimaSIBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series relocates the dumpable mode and the user_namespace
captured at execve() from mm_struct onto a new per-task
task_exec_state structure that stays attached to the task for its
full lifetime.

__ptrace_may_access() and several /proc owner / visibility checks
need to consult two pieces of state for any observable task,
including zombies that have already gone through exit_mm(): the
dumpable mode and the user namespace captured at execve(). Both
live on mm_struct today, which exit_mm() clears from the task long
before the task is reaped.

A reader that races with do_exit() observes task->mm == NULL and
either fails the check or falls back to init_user_ns - which denies
legitimate access to non-dumpable zombies that were running in a
nested user namespace.

mm_struct loses ->user_ns and the dumpability bits in ->flags.
MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* layout exposed via
/proc/<pid>/coredump_filter stays stable. task->user_dumpable and its
exit_mm() snapshot are removed.

task_exec_state is the privilege domain established by an execve()
[1]. Within a thread group it is shared via refcount; across thread
groups each task has its own:

  - CLONE_VM siblings (thread-group members, io_uring workers)
    refcount-share the parent's exec_state.
  - Non-CLONE_VM clones (fork(), vfork() without CLONE_VM)
    allocate a fresh exec_state inheriting the parent's dumpable
    mode and user_ns.
  - execve() in the child allocates a fresh instance and installs
    it under task_lock + exec_update_lock via
    task_exec_state_replace().
  - Credential changes (setresuid, capset, ...) and
    prctl(PR_SET_DUMPABLE) update dumpability on the current
    task's exec_state, i.e. on the thread group's shared instance.

Behavioral change:

Kernel threads that briefly use a user mm via kthread_use_mm() no
longer inherit dumpability from the borrowed mm. Kthreads are not
ptraceable (PF_KTHREAD short-circuits __ptrace_may_access), so this
is observable only via /proc surfaces that a sufficiently privileged
reader can reach.

[1] https://lore.kernel.org/r/CAHk-=wj+NgoDH3GSicJ140SV8OoDd71pLmL3fgFEsTcgoMC6Og@mail.gmail.com

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v3:
- Restore alloc-fresh-and-inherit semantics for non-CLONE_VM clones.
  CLONE_VM siblings still refcount-share; fork() and other
  non-CLONE_VM clones get a fresh exec_state that inherits the
  parent's dumpable mode and user_ns. The v2 "every clone
  refcount-shares" model would have let any forked process in an
  Android zygote64 subtree influence dumpability of its siblings
  via prctl(PR_SET_DUMPABLE).
- Link to v2: https://patch.msgid.link/20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org

Changes in v2:
- Drop dup-on-fork for non-CLONE_VM clones: every clone() variant
  refcount-shares the parent's task_exec_state; only execve()
  allocates a fresh one.  See "Behavioral changes" in the cover
  letter for the implications.
- Switch commit_creds() to update dumpability on the new
  task_exec_state (instead of dropping the set_dumpable() call
  entirely as in v1).  Drops the explicit smp_wmb()/smp_rmb() pair
  - RCU acquire/release on the cred pointer provides the ordering.
- Link to v1: https://patch.msgid.link/20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org

---
Christian Brauner (Amutable) (4):
      sched/coredump: introduce enum task_dumpable
      exec: introduce struct task_exec_state
      ptrace: add ptracer_access_allowed()
      exec_state: relocate dumpable information

 arch/arm64/kernel/mte.c          |   6 +-
 drivers/firmware/efi/efi.c       |   1 -
 fs/coredump.c                    |  22 +++-----
 fs/exec.c                        |  39 ++++++-------
 fs/pidfs.c                       |  23 +++-----
 fs/proc/base.c                   |  39 ++++++-------
 include/linux/binfmts.h          |   2 +
 include/linux/coredump.h         |   4 ++
 include/linux/mm_types.h         |   9 ++-
 include/linux/ptrace.h           |   1 +
 include/linux/sched.h            |   6 +-
 include/linux/sched/coredump.h   |  47 ++++------------
 include/linux/sched/exec_state.h |  29 ++++++++++
 init/init_task.c                 |  10 ++++
 kernel/Makefile                  |   2 +-
 kernel/cred.c                    |   3 +-
 kernel/exec_state.c              | 116 +++++++++++++++++++++++++++++++++++++++
 kernel/exit.c                    |   1 -
 kernel/fork.c                    |  32 +++++++++--
 kernel/kthread.c                 |   1 -
 kernel/ptrace.c                  |  53 ++++++++++++------
 kernel/sys.c                     |   6 +-
 mm/init-mm.c                     |   1 -
 23 files changed, 301 insertions(+), 152 deletions(-)
---
base-commit: ab5fce87a778cb780a05984a2ca448f2b41aafbf
change-id: 20260520-work-task_exec_state-83209d8b3e53


