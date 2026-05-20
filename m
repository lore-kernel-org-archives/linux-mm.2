Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04955CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A03A6B0005; Wed, 20 May 2026 10:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350B06B0088; Wed, 20 May 2026 10:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D7E6B008C; Wed, 20 May 2026 10:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17C786B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6FEEA0388
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:21 +0000 (UTC)
X-FDA: 84788066202.14.147211C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA45E14000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nJ/OxswS";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=utPcjL9Gqu1FrXe1Hs/3J8Gs10AmEMXhODG9jXxR3KU=;
	b=aYdIZGd9RNykBmHboF8IHvicldvbUiNkRF2+n3DXborAjVBP/8JYY0kPhTpbJWLM9ZzPgd
	A14ZUsIwLZGIw9MQ6/PFgP4yXipnfqiItm24QzRPEJ4FiFr7U0/EzaiY6e1d+XO/Oiuv0j
	/CcCmPfvDa1r7AC3DlCI7ScaMR5jzHs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nJ/OxswS";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288199; a=rsa-sha256;
	cv=none;
	b=jb5h5Svlfn36kiBMPlLYEc/yXvTEhOjeWsPVx6yDemwBoI5Cyp0MHZvuFEsATkqDEoNQb4
	0RTWlX6FEj0iEAHEcevDtrxrEUdcmSpekU+D6+9eyugEe0p8EqtYRvny0+CBVB9zrs/GM8
	aCXfTtK2xTqdGfOfETkUf31xMUgEetQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 545D060008;
	Wed, 20 May 2026 14:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5231F000E9;
	Wed, 20 May 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288199;
	bh=utPcjL9Gqu1FrXe1Hs/3J8Gs10AmEMXhODG9jXxR3KU=;
	h=From:Subject:Date:To:Cc;
	b=nJ/OxswSKWsUrqJzFSKuskFOap3z2iWkWvnh3TvE4bynVWtbX2vhYZmLM+XkoKoxp
	 J4ge34LyN3Ifq2joNK+YLdh/eQq7jsen03Jv8BGY7liP+3d7FHpF5aau46Y3Q+qMW6
	 SEzfnAvyS6bt/qT8abT9y7js30Cy64fGL0G20JzuyOdoTHfQ/eal04W4nL1bO1AqX+
	 vs/5rWPukzSAZ8FqWmHLcmTiCuazpX2n0+LglnP22eqLZ/5ywUF+32Y0+SzxZ/zqzm
	 fs5FmslEb8QEQhm2jgGQHyspBsEzCXYscYkO+CDAcXMIUBysWyOv2GQPS5YWj4QXfO
	 pgp0Sb6BIZHwQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past
 exit_mm()
Date: Wed, 20 May 2026 16:42:53 +0200
Message-Id: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG7IDWoC/yWO3U6EMBCFX2XTa7tpS6HFKxMTH8BbsyHTYbpUB
 ExbEbPh3eXn8pzM+eZ7sEQxUGLPlweLNIcUpnEL6unCsIPxTjy0W2ZKqEqUSvDfKfY8Q+obWgi
 blCETt4USdWtdQWXBtul3JB+WA/vB3t9e2e0s04/7JMw7cD9zkIi7CCN2ezVAyhSv4EqPZA0YY
 9EZK0CUtdWgELS2XjktAbzzO6ELKU/x79Cf5fHuNJXVaUpLyM0w8FlyyU3lEA0qXdTtS09xpK/
 rFO/stq7rP2Hnc/YKAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5200; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AUws9aHZdsbAKkBxvY3JCoS0OAegOw5lqEa47YHJVxM=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGoNyIOiFmGFxY8Lpu4qEHtR+LdW+pcgHRKusmhxT2cFLwR73
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmoNyIMACgkQkcYbwGV43KK/zAEA9qOp
 m5L0Otm6/jLdNv3OA66jav6w7NpXFuVPMLWFCEsBAN4qKYFzMVleO09KvH0uJPu1ZGMr2/KaE5i
 zUIRboFQI
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA45E14000F
X-Rspam-User: 
X-Stat-Signature: pzb7w58dsg3qijcfyn3s5f8ddo7knwgw
X-HE-Tag: 1779288199-401546
X-HE-Meta: U2FsdGVkX1/iUoSO+m1U0MhSuV6svpKEmya879YpYKSDAZIsfagqXUgDc1OCfv0Q/Ggl3SKUyCO80zfb0V9O1yW7OM35Ws0VSmDQegfeeJEBB6LXBe7hBauFU1cdy5MFTwt6W9/iuAGGb49nugXhlsuWV3tFy4vgXa8D+S2Dhqkma+PNEyqLrmFzHSe3wFoG0wpMbEeSAIbo2/zWdOlt/pVRbEaBoMT1sh6DqN9LEefxqw7MSbNk8Sc+VXCBBbttkew1NGCNTXQCee2CRXDCpA+t2N6c8yUQavFkefHI6hUflxgaLxDB0dveaZQCgfXUsw/iVUB0005tP/lHpyfvV19TEsaoy3d021ku8p79OWDmuuALcSDKPt3HYvIiXxYwyFCJDBp52jxum8K6EqMI+0oZ77NcMS2wDREx/D+r/4XRyr73hHx+IujlPfxF3fDISk0zxyGZMvTacp4tXxrbRq/8piswizOMD3z3fImxL/9lXPktKn2EaP/YW1SC2U9Hi4BExF2sZPKUBazg0OSaiPfStQdSo+cR4/8+/5uE0SLjVWTV9jn0VjnVUpBtdx2SYFawjHOJybcFrc2Vwa1xNLBVHvUGeQtdi5lmLzkQDH7B99TIQsQKi6zpFkpa8V5IYj2pt3Kos/c96I0OyyM62kRjdWxxfI0Q8/xlZj31GFPRS42Bbe4TXLI2XmTLk3UZvcdig0/JFgOtxvbHvKhuhx2Z6M4uddbh968UFLLx+fqqck2H3jumrgnO/D7TkKcGhl/sAqFb7NRDHeI/yJmMB6Ly9F99qhCtJsXM1juGO1HGHZleRZrAmko9awrBZYcC7elJW1kBK27ZUJh6M/5d+NiN4rrOe7ZHN9C50zJjBdl49803T37oFbeQIcdZYbNIEnomkUqYpGc3MN5F1vnbUD5xHGOYXDiDm4XEzgwAzLJzLEC8hYSfoL6mGG92JOkP1SO4WkQ0H/GKZ1t/z+Q
 neQ0pWbU
 bW0FBNWcm8lLOhkHp2rNQ9nn8PgZ+4ed2haxFS8TxAz3XaRB7+SSowyBY9doUiZH6G1sSOf/QvGMwcACz7sPLJxv8036G9ySWySEUOqR7PNVutNxgsJebOAzBTXmvg2jUIxVVwVG6RaNzRN0VaQtVnVhhtsHz49CzfraBHnTgJsA9oqwa4d2niuvgsE7kjC3WpTFb218iPi5CATWc9zWNrgwFDmbm8pNFQ9sZGk7qeBPP5HXehxcn+yEpHCw/2XcWRfzWwZ5fdNerEzLERht3DHa4tvSKLp+wM2Stgq4+x0P1BKb0ZPFjuxfj2NoELtO4M/1qWAlRDGh2ga2McmkCmAe82O2el/aW9zWGCgZOEeOrZ34=
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

task_exec_state is RCU-protected, refcounted, freed via call_rcu()
from free_task(). init_task uses a static instance with refcount 2
so it is never freed.

mm_struct loses ->user_ns and the dumpability bits in ->flags.
MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* layout exposed via
/proc/<pid>/coredump_filter stays stable.  task->user_dumpable and its
exit_mm() snapshot are removed.

task_exec_state is the privilege domain established by an execve(), not
a property of the address space. Following the model Linus sketched in
[1]:

  - Every clone() variant - thread, process, vfork(), io_uring
    worker - refcount-shares the parent's exec_state.  No
    dup-on-fork.
  - Only execve() in the child allocates a fresh instance.
  - Credential changes (setresuid, capset, ...) and
    prctl(PR_SET_DUMPABLE) update dumpability on the shared
    exec_state.

The entire fork subtree of one execve shares one exec_state; a
child enters a new privilege domain only by execve()ing into one.

Behavioral changes:

(1) Dumpability lowering on credential changes now propagates
    across the fork subtree.

    Pre-series, set_dumpable() on commit_creds() targeted
    mm->flags, which was per-mm: shared by CLONE_VM threads but
    private to fork()-without-CLONE_VM children. Under the new
    model the write targets the shared task_exec_state, so a
    privilege drop in any task in the subtree lowers dumpability
    for the entire subtree, including non-CLONE_VM siblings.

    Same-uid ptrace shedding and /proc visibility for the
    "root-launched daemon drops to a service uid" pattern (sshd,
    polkitd, dbus-daemon, NetworkManager, ...) is preserved.

(3) Kernel threads that briefly use a user mm via
    kthread_use_mm() no longer inherit dumpability from the
    borrowed mm. Kthreads are not ptraceable (PF_KTHREAD
    short-circuits __ptrace_may_access), so this is observable
    only via /proc surfaces that a sufficiently privileged reader
    can reach.

[1] https://lore.kernel.org/r/CAHk-=wj+NgoDH3GSicJ140SV8OoDd71pLmL3fgFEsTcgoMC6Og@mail.gmail.com

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
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
Christian Brauner (5):
      sched/coredump: introduce enum task_dumpable
      exec: introduce struct task_exec_state and relocate dumpable
      ptrace: add ptracer_access_allowed()
      exec_state: relocate dumpable information
      cred: switch dumpability lowering to task_exec_state

 arch/arm64/kernel/mte.c          |   6 +--
 drivers/firmware/efi/efi.c       |   1 -
 fs/coredump.c                    |  22 +++-----
 fs/exec.c                        |  39 +++++++-------
 fs/pidfs.c                       |  22 ++++----
 fs/proc/base.c                   |  39 ++++++--------
 include/linux/binfmts.h          |   2 +
 include/linux/coredump.h         |   4 ++
 include/linux/mm_types.h         |   9 ++--
 include/linux/ptrace.h           |   1 +
 include/linux/sched.h            |   7 +--
 include/linux/sched/coredump.h   |  47 ++++-------------
 include/linux/sched/exec_state.h |  31 +++++++++++
 init/init_task.c                 |  10 ++++
 kernel/Makefile                  |   2 +-
 kernel/cred.c                    |  25 +++++----
 kernel/exec_state.c              | 108 +++++++++++++++++++++++++++++++++++++++
 kernel/exit.c                    |   1 -
 kernel/fork.c                    |  15 +++---
 kernel/kthread.c                 |   1 -
 kernel/ptrace.c                  |  62 ++++++++++++----------
 kernel/sys.c                     |   6 +--
 mm/init-mm.c                     |   1 -
 23 files changed, 289 insertions(+), 172 deletions(-)
---
base-commit: ab5fce87a778cb780a05984a2ca448f2b41aafbf
change-id: 20260520-work-task_exec_state-83209d8b3e53


