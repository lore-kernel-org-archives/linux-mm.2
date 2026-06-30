Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E982FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E189E6B00C6; Mon, 29 Jun 2026 21:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2156B00C7; Mon, 29 Jun 2026 21:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69B36B00C8; Mon, 29 Jun 2026 21:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7C86B00C6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:29:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 197BB1C1EC3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:32 +0000 (UTC)
X-FDA: 84934846584.05.CC4F205
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0E9FE20002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C20zHS3o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782970;
	b=P+B1pKjjZVCrc/ohaAAB/Is0adxmbcv393UvEMxjhh4PIrOnbmiQtUwrhSuyAp7NFMPik/
	bl35XkmmUBX/U20hf9GZCtm/FVMXsie3GufPH2BWj2OMe7XPMDVYPpRWQqgXPnzsK3w+Ue
	VTApV4oEhOPwyZcP1IzFchfJ5FtqwAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZTtenTdtqeMl8/RBjWbQbC1t0UZUIUeSy0y7m2XWyto=;
	b=qr+HvxRhymkxozK6ZdOvzIADUwdrMfbmhhEw/68oVO8Z4rsIqOq0kzn7cJY1FKEXdGCzJL
	bZzt1cg9RRWTSWd1lnO6p3f7hwK7fRVQHA/fY+YdmhEaptZNEglO1SjigkOQmg2iH2uXBD
	lKS5YUoeilk7KpGvaUV0c2t4Huokp9I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C20zHS3o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782782967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZTtenTdtqeMl8/RBjWbQbC1t0UZUIUeSy0y7m2XWyto=;
	b=C20zHS3ofClI+RO9BptHadFBGWaiyExfg4Xzr/Nv0lG0SG4BPjlT7e/mGg1ZSsjKpbSOmY
	V0zb2ABpN/7otH11xxDOxAjPbDcsJvQO9SZaenkeJTXYxGUgPhvXvu4FvFYbsw6z5xfqB8
	oQT/I80r/WzV8i2xfFPLcDFsTKFW2/Y=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] memcg: bail out reclaim when memcg is dying
Date: Tue, 30 Jun 2026 09:29:00 +0800
Message-ID: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E9FE20002
X-Rspam-User: 
X-Stat-Signature: 7p7w7yxuehapryc1t93ho5ta5fwott7e
X-HE-Tag: 1782782969-545923
X-HE-Meta: U2FsdGVkX1+7jgH9lpGN16GFhAUQ1WyTa+QL7VOYUDR801yGqq4MU0Ren5gf5Mga3CKGEYvSg9MjoOSqCHbRyLu4OMWm8NH6T3wNHqylg5BQjhcwstVCxdQXlZi00t9MapgG/d+rZv61vtLq+eIRmr10wkzEVan50ec0DfgSCrQuGdd5Ma2eKYT/8aIUyc2TNWjJiQBJdG3WSsgmm3lXnt6poKLHU4OoHR8xF5ZC+nXQFhZJglSzaMhzAj8kQMVL1UjTo1M5ZO/q1HAmpcXX2bHPYNrGgzWLXxz3S31DDAPTGgOnVHmgoJfbwWcn4IJwgi59uqY1loMs76VDMlzF0J+Hu8HPL45ByuSU4ppyeccPxz5eYe0DeViU152PICx7YiBYfs82hPSAzlvhli9CpuwDNY1KtebIc4Te+u/7+cdUE0s+Mb8022ayb41qFkLvXhk2CSta6f0Jo9sGxAzkVzdqGfDg2DOpELO+a3SXHQLn9fstIBR0LRMg6BQtyMU/meTBSLDlOaYugEfNJLv1nlLBLdzIuV4Ekyv4eMUCSIY82lmE8mzvKntS5BcC1BVd+gVRwMIlUA7cfGgy7Ujp9NlTsSNnvuxDH7R4/NarWtr3lCphFre4UYAqFNvMsxBNwO5OfXzIyWX48pdGNM9olFYjjoQyX5T5BPUe8t9y4aplYJDZdO53b7OQrsNOcIZUWV9TgyJZh3TjPPjeEw9ciRfQNm0V4GtnMpkUJfuf+7gsdJ985SIF5QE9owjAFpL8fXqFdPe9kE3yyjtCvonZQ6hOvyX6+WiUw1QXnZR9X9oo+3Pv2jWDaqvzlOXnyz4xe+oiTdsD5phePUsuchBQQOdVL1BE3vg78A5WgFiOSTEqI2cvrbwXR4jng5NmGnS+D/tjd2zzZpcb1Peqgi/f2fsF6TOWNdzkVmrwNGGjxvpu9NTbfjjg0MhCCeVjcyYm0t4p09TwWZwsMg6OrEK
 iTHaH5h/
 m7/hdcjJEhgkc/NMYq6DjuPdNGrxtuG5E//hQGlWKX08R2vAr77T+A0UMwEdKX3Dxet8P9/Yb+q1ELY5Mxm/pOU6v6l4t84DgKEXBlCxPMyZFlCAos7My7/NLW2qZXezsfpCWyejwkcViOZ1JjLOW+itfYFUyd/cjiIVQ+X0tRxLwhJWIJf58FdAf/zDQw3shWAudjQint7a7XfeCMYNSKRj9fpbtd43IJnjJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series mitigates a system-wide stall we hit when a cgroup is
removed while one of its memory control files is doing synchronous
reclaim.

Problem Description
===================

Writing to memory.high, memory.max or memory.reclaim runs reclaim
synchronously in the writer's context, looping until the usage drops
below the target (or, for memory.reclaim, until the requested amount has
been reclaimed). On a large cgroup this can take a long time. The
latency is especially bad when reclaim has to perform swap I/O, where it
is bound by the swap device write bandwidth, and under thrashing it is
effectively unbounded - each round reclaims a few pages that the
workload immediately faults back in, so the loop keeps making "progress"
and never converges.

The legacy (v1) reclaim loops in memory.limit_in_bytes,
memory.memsw.limit_in_bytes and memory.force_empty share the same
pattern.

These writes go through cgroup_file_write(), which does not take
cgroup_mutex and does not pin the css. Instead, kernfs guarantees the
node (and thus the css) stays alive for the duration of the operation by
holding an active reference. So while the reclaim loop runs, the active
reference on the file is held.

If another task removes the same cgroup in parallel, cgroup_rmdir()
takes cgroup_mutex and then blocks in kernfs_drain() waiting for that
active reference to drain. Because cgroup_mutex is held throughout the
wait, every other task that needs it piles up behind the remover - in
our case the whole machine ground to a halt, with hung_task reports for
the remover and for unrelated tasks merely reading /proc/<pid>/cgroup:

INFO: task cgdelete:366634 blocked for more than 159 seconds.
      Not tainted 6.6.102+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
 <TASK>
 __schedule+0x3da/0x1650
 schedule+0x58/0x100
 kernfs_drain+0xe6/0x150
 __kernfs_remove.part.0+0xd0/0x200
 kernfs_remove_by_name_ns+0x75/0xd0
 cgroup_addrm_files+0x325/0x410
 css_clear_dir+0x50/0xf0
 cgroup_destroy_locked+0xdf/0x1e0
 cgroup_rmdir+0x2d/0xd0
 kernfs_iop_rmdir+0x53/0x90
 vfs_rmdir+0x98/0x240
 do_rmdir+0x172/0x1b0
 __x64_sys_rmdir+0x42/0x70
 x64_sys_call+0xeb0/0x2210
 do_syscall_64+0x56/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2


INFO: task systemd-journal:2352 blocked for more than 182 seconds.
      Not tainted 6.6.102+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
 <TASK>
 __schedule+0x3da/0x1650
 schedule+0x58/0x100
 schedule_preempt_disabled+0xe/0x20
 __mutex_lock.constprop.0+0x3bb/0x640
 __mutex_lock_slowpath+0x13/0x20
 mutex_lock+0x3c/0x50
 proc_cgroup_show+0x4d/0x380
 proc_single_show+0x53/0xe0
 seq_read_iter+0x12f/0x4b0
 seq_read+0xcd/0x110
 vfs_read+0xb1/0x360
 ? __seccomp_filter+0x368/0x590
 ksys_read+0x73/0x100
 __x64_sys_read+0x19/0x30
 x64_sys_call+0x18d3/0x2210
 do_syscall_64+0x56/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2

The system recovers only once the reclaim finally finishes and releases
the active reference. The reclaim itself is pointless here: the cgroup
is being torn down and its remaining pages will be reparented to the
parent anyway.

Even though we check signal_pending(current) in the reclaim loop, the
typical symptom is that cat /proc/<pid>/cgroup gets stuck.
By the time someone looks for which task is actually stuck in reclaim,
the hung task timeout has already been hit. This makes the problem
particularly nasty to debug from a hung-task report alone, because the
blocked tasks shown are often the victims, not the reclaim writer itself.

Our Mitigation
==============

cgroup destruction sets CSS_DYING in kill_css_sync() *before*
css_clear_dir() triggers the kernfs_drain() that blocks the remover. The
in-flight reclaim loop is therefore guaranteed to observe it before
starting another reclaim iteration. This series checks memcg_is_dying()
in the v2 reclaim loops (memory.high, memory.max and proactive reclaim)
and the v1 reclaim loops (memory.limit_in_bytes,
memory.memsw.limit_in_bytes and memory.force_empty), and bails out early,
so the writer drops the active reference promptly and the remover can
make progress.

Unlike the no-progress guard (MAX_RECLAIM_RETRIES), which only fires when
reclaim makes zero progress, the dying check also covers the slow swap
I/O and thrashing cases, where reclaim keeps succeeding a little and the
loop would otherwise never converge.

For memory.reclaim, bailing out because the memcg is dying means the
requested reclaim amount was not satisfied, so the write returns -EAGAIN.

This is orthogonal to commit c8e6002bd611 ("memcg: introduce
non-blocking limit setting option"): O_NONBLOCK lets a caller avoid the
synchronous reclaim up front, while this series handles the case where
reclaim is already running when the cgroup starts being removed.

Changes since v1:
  - Return -EAGAIN from memory.reclaim when the memcg is dying.
  - Add the same bailout to the legacy v1 reclaim loops.

v1:
  https://lore.kernel.org/linux-mm/20260623062800.298514-1-jiayuan.chen@linux.dev/

Jiayuan Chen (4):
  memcg: bail out memory.high when memcg is dying
  memcg: bail out memory.max when memcg is dying
  memcg: bail out proactive reclaim when memcg is dying
  memcg-v1: bail out reclaim when memcg is dying

 mm/memcontrol-v1.c | 6 ++++++
 mm/memcontrol.c    | 6 ++++++
 mm/vmscan.c        | 3 +++
 3 files changed, 15 insertions(+)

-- 
2.43.0


