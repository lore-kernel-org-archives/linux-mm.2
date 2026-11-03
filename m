Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E568960A5BDD
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=og5bCNnC
Received: by kanga.kvack.org (Postfix)
	id 064126B05B2; Tue,  3 Nov 2026 09:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0160E6B05B3; Tue,  3 Nov 2026 09:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46036B05B4; Tue,  3 Nov 2026 09:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C07DD6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F17680482
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:08 +0000 (UTC)
X-FDA: 85394087856.25.AA0CFB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E33840007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=og5bCNnC;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wcfm4NJTkbtPoo0W4PeJYWfvmalPaASf+2pIVtyvhx8=;
	b=QWM+quy9Px0brh35K6lYjHRYfR8qBcN2ZdniEmdZxdEHglgBabSGusT0BNIjAdOhgpeq8X
	qGKx7sOIz/0ASfqYZtEx6BkwR8qhS3wXksw5mzxd+dzqtC/SykJb4GyCtIgImUBNBwyDnl
	ulra3sJL+w1Ob5VshYSlh6ibQK0Gneg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717286;
	b=A28WIFahGRothV/ZH7DivEBotzv872VS69hMHV8a+dc2aT3SMOjqHK3VLi90vDnJArMTzH
	C+09X73pzBWRjUIeEI96iO9jtB+fJWjaZRpFap68SP4J6MOLIAt7Kl/uByj4h1RmlsiuHM
	ZK+tOdA+LiVd9JYXzAO/iovpxonFjmM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=og5bCNnC;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1EE24055F;
	Tue,  3 Nov 2026 14:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478AE1F000C1;
	Tue,  3 Nov 2026 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717285;
	bh=Wcfm4NJTkbtPoo0W4PeJYWfvmalPaASf+2pIVtyvhx8=;
	h=From:Subject:Date:To:Cc;
	b=og5bCNnCWypgCWUiGfXpt76OPxMNmpziIPcsV9Zs5WXVFaTldbfNdS4SVH5zwQHNz
	 OjqAfGiEzma5i4WL0gLpzl24H9P8dQavzNaT5aaije6CnIww4V462jcJhFBBVmyTaF
	 l1B+fIXqiY+axDuZBtkIDZMHCO2YItflbVfoiPhhhtNq/3u7V2qvVGQ8SwVaFjvzqs
	 V4aaXA9o8YoZvc8DAtwx9fDkdYbvSQvVOR28KfbxWOdiaOF7qFNDSyyjdTI35uamTm
	 HXE3+ZFWtyerrJw8EwjYQxymxyuwoxsAVAlzc+5WKGI0ivodCEhqOsxeH2g2jQf0W4
	 X2/UXPsn5b30w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH for-next-fixes v2 0/5] memcg,slab: kmalloc_nolock() fixes
Date: Tue, 03 Nov 2026 14:47:49 +0000
Message-Id: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABX06WoC/yWMwQ6CQAxEf4X0bBNSdBf9FeMB1wIV3DVbNCSEf
 7fCZZKXmTcLKGdhhUuxQOavqKRoQIcCQt/EjlEexkAludLREYdXM44pYEyWA7Yys2I4e+dPFdX
 eV2DqO/NWmHmFNmWMPE/7Fm57r5/7k8P0/4Z1/QFNLHSfiAAAAA==
X-Change-ID: 20260624-kmalloc-nolock-fixes-c97675328773
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: pbea8o6rea57cxf6ax6gtfp89r5mktia
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9E33840007
X-Rspam-User: 
X-HE-Tag: 1793717286-964502
X-HE-Meta: U2FsdGVkX1+K0QgkRpaXXV3VV66m8JhZThNgJXxzewgqxHE4aeDrsDK3cdeiBnhiezw3ilrohn7LeDdl6+qhg2XEJPW7Vr9ioYkjRGfRuGDz2PmVeiDn8M2UiQUEDRKK6V73pEox7T3Ptt5gwSf6qhHuGpwF1wPnC8cwBaZKun0XyUraFOsdZQeKjeaX2/6p+bZTwzD+ZYdMCQP416TZIjxF+D+CosEe14jkUmLDcqR1VfmM5gSZkUiz+NyY3T4vXfk7mzxDhk3BhW+qsmb6kOtOtmdOIlKe9B/OA9gq68cMPe1j//4LUNw/DF7iza/a/pcs8Zow3sJCZag3SeOL0I802PpDjw+50zfJ1euQd9Xd+tazXSRjJqrX8wW9T5ErziTCyF12R9f+IWEiSf30wv02TjilzEticoGanS4GnQz0/OewTmmXkSPe7VOpjS9+/0ZKXk1KhBbfPLzYRf3EqeVypWn7gYgfWlk227vKgz0W9Ews2qv00ZDszVN0u/ECZp8Ha4DRp3SlbmaRcrTP96UUd1L8bKoztk96AfQEOUFESUw45aCu7YyECh/fFcUwYn3jbpAUBRMZR/jbdrbBZ5IgeYtCNS4DasPzBwtfdSq44kR0QFaff4q/yuG/7bGyVICNnEUuG6OyO4ut3qhwDgeOEjC+zzr+nhdN5ut/44Cxg0MqZUU/j+CekjBPmU81D28fhi0hblzPT+FJQHKOopzzLQDtKKgi3G8c/xtIQgJR90mzJO8zhgBVuLM0oFRAH+vX8pywCO4JEW0RKECZu0UpQ3N0sNVG5ojDFdZQTsDOlZV+w/6eBTahvXQRJ+2SqGMqLt4JWGzhdZCxKDoOI4xBZVZlIArDFgN27tTriKLtRP1RVE15Skuuts8AQfajGxSH7zI3ksh+EEdao6vvCRwpIdB5eBg2xftwcnMA/zlWIg9UWkG6JQFsNjuVduQDUUEGlPceVnfFGSYvfuY
 8y905Ctr
 Nb8IMSz6Efxdq3WD06EoR9uFQImkyVqQan+/BjBfIh9OND7i1nH96b6PlNBSQBkXpKQSJ8xFGo9KsrLGvkqPpxLvtGMmOcT0BdoTSk452nl80EVCv1IJnsytdvE7r8Uh2AABcU0/C7NKu89A6fAAN+tms0uc7A0jA4+3Ievm3Gpt5l77k1gcEv958UmlVo5nwb8GQfYC6h7A+P4uukOc4/pCNCVeGD5MSogeggyRpodwsNbznBu1PaCzkmtKN9+tOU5K1Wu0a0iG7LAu3SNulyrx5ex8X1ETQ4MG0AFe/BSI6h3Cx3y3ao8ZwkioD6xwtUAZ1qw9bKmS+NwXI/4IwP+MS5Adg/q+CTUgh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patchset fixes three kmalloc_nolock() bugs.

1. obj_cgroup_put() takes spinlocks in the release path when it drops
   the last reference, but it can be called from any context.

2. A spinlock may be taken in the following path and may lead
   to deadlock:

   kmalloc_nolock()
   -> slab_post_alloc_hook()
   -> memcg_slab_post_alloc_hook()
   -> memcg_alloc_abort_single().

3. irq_work_sync() is called without synchronization for rcuwait
   (on PREEMPT_RT or some architectures), potentially causing a
   hang.

Bug 1 was reported by lockdep, and bugs 2 [1] and 3 [2] were
reported by Sashiko.

Patch 1 only touches mm/memcontrol.c and no later patche depends on
it, so it can go through to the memcg tree.

Deferring obj_cgroup_release()
==============================

RFC v1 skipped the stock drain in __refill_obj_stock() when spinning is
not allowed. Making sure "obj_cgroup_put() is not called in a restricted
context that doesn't allow spinning." is easy to get wrong.

v2 makes obj_cgroup_release() safe in any context instead (as mentioned
in cover letter of the RFC v1). The release callback only queues the
objcg (llist_add() + irq_work_queue(), both NMI-safe) and the release
runs from irq_work.

This also fixes a performance regression in RFC v1 in a free-heavy
kmalloc_nolock() microbenchmark.

Changes in v2
=============

- Rebased onto the latest slab/for-next-fixes.

- Rebasing the series, writing patch 1 and 5, and verification was
  assisted by AI and carefully reviewed by Harry Yoo.

- Patch 1: replaced with the new approach described above.

- Patch 2:
  - Now introduces the allow_spin local variables itself
    (previously added by the old patch 1).
  - Addressed v1 review comments from Vlastimil (thanks!):
    - restored the blank lines.

- Patch 3 (new): call debug_locks and KCSAN checks in kfree_nolock()
  regardless of allow_spin, as they acquire a spinlock only when
  reporting a bug.

- Patch 5 (patch 4 in v1): Introduce a mutex for
  deferred_work_barrier() as it can no longer reuse slab_mutex. In v1
  the only caller was kmem_cache_destroy(). The barrier is now also
  called from kvfree_rcu_barrier() and friends, which are usable outside
  mm where slab_mutex is not visible. Dropped Vlastimil's Acked-by
  accordingly.

- Dropped the Cc: stable tags to avoid intrusive backports for unlikely
  issues in practice [3].

- Link to v1: https://lore.kernel.org/20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org

[1] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
[2] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
[3] https://lore.kernel.org/1816e94b-87e0-4276-8ff7-1fb651326ab3@kernel.org

---
Harry Yoo (Meta) (5):
      mm/memcontrol: defer obj_cgroup_release() to irq_work
      mm/slab: handle allow_spin in slab_free_hook() instead of open coding
      mm/slab: call debug_locks and KCSAN checks in kfree_nolock()
      mm/slab: fix a deadlock in memcg_alloc_abort_single()
      mm/slab: serialize deferred_work_barrier()

 include/linux/memcontrol.h |   2 +
 mm/memcontrol.c            |  27 +++++++++--
 mm/slub.c                  | 112 ++++++++++++++++++++++++++-------------------
 3 files changed, 91 insertions(+), 50 deletions(-)
---
base-commit: 03a176b9248c4513bb705ed3d931af3a7e9c2a08
change-id: 20260624-kmalloc-nolock-fixes-c97675328773

Best regards,
--  
Cheers,
Harry / Hyeonggon


