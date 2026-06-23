Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A05CCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478756B0088; Tue, 23 Jun 2026 02:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4296B6B008A; Tue, 23 Jun 2026 02:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3182F6B008C; Tue, 23 Jun 2026 02:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 068BD6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:28:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69C3A8D95D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:28:47 +0000 (UTC)
X-FDA: 84910199094.05.7A50D80
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61869140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:28:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IdTW5MBS;
	spf=pass (imf09.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782196125;
	b=OToQitPu6qcxmiUMG/VM5dNM+g1EoK5HOLGzZEY2xw9uOIpRoG5UD/vpMFyhxaouhXi6c2
	geDOeCSRVpSCVhKcpf0qnhcHeRYk/hnq1pCYcMuuGD3O4ewbD5Ck7lFttP9GPm1Ss2DJwD
	mo3MIM1bu8xocHc9QLZ1K4DaeYdgiao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782196125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E6PGLy8bRZ4LM0S8hHpE/Y/YUCNvl+OFBFABUP2H23E=;
	b=Cdu8zJeHBm8E5Ify6hKxTn6ORkTrDWgUQuFBvdfn7E1KI4AVacK73iMDjcaKs3iC7m8wj0
	l4TF3nx0UqpaRehXopE061fERlbRAaFKRuss8QOCYzghzhVFQRP8UKf2myPnLO1WjBZZDL
	e+J6OErugGb4UqucGv13eKV0JvKYocI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IdTW5MBS;
	spf=pass (imf09.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782196123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E6PGLy8bRZ4LM0S8hHpE/Y/YUCNvl+OFBFABUP2H23E=;
	b=IdTW5MBSADxS8XZ0gHcWA1wGgaLk8bwhNf/HRGpWJAGM5WPrWEGrPy/z3rQlH52bjeGixp
	XWpMTvaaA/ZVCWTwd12p7mbJDZXrwx2CAvKFxNfnFWfLas9Tv/u08dxgnFqGD9040mBWsk
	HVmeFbXjuySevsa+5qOTMe/t+YUJpfU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: yingfu.zhou@shopee.com,
	jiayuan.chen@linux.dev,
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
Subject: [PATCH 0/3] memcg: bail out reclaim when memcg is dying
Date: Tue, 23 Jun 2026 14:27:53 +0800
Message-ID: <20260623062800.298514-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fiwsa4io3zfj95oyn8j3e1wcci7m1r3u
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 61869140002
X-HE-Tag: 1782196125-764794
X-HE-Meta: U2FsdGVkX1/IYzRUAXhTn7TvKF3CYOBbvyvm034KnyrzNPGyCRXcM0WsyOvDSZoXFuoL/mnA/GwSk/rkoFbcDzuxp8dhpNte/bXdfv9kOFgDgUth5yhQLlJiinPIksMXJ49jFfj1ZOXQcYAYisPpCkNwAbTh9yvkFjFBJ4WjIu7MEPmDCmzR/1BjHursbjjkKQsjSmgxszKh6fmjLlJS4G34E06NQYnusFfli74IPL+OVD7xMp1V7yHnEvJUDtPnFCmjbLZ5khZCr8dMwTl4Rssyp5BYXbihvG7BG6u+OCBz/gjnqdogE1DMU1sByurp3c4DMpoPokhQwULRsaivOOahxspD5O/5j+xa1Q+Cb/Xc6s/z8xlOYeVKRDyDO7t8+cLaZyitzgMo2SsZ9ZKVVQW/6wQXCBWKA1cPgTgCGH49qVOMqYnvHtzfNjJ4wrFhRnAzLhe4vFporGakbkVQWALk1vjSarybt97fQyuVH5BWGIuaOCOx90EQyCSo6h/IBm9utJVqOsYlq25smGyz0oPFEIsktDjmeikCb0oswNo1IjT/YSfqruG2GM+x+qinK8YhXv+3HD+d2ETLwZTxYgDeES8FZhXw3fZ6fUVDz7MlFnwZyQOfjjTJ6dMp6Xi4YClgo0mb80R37y1RMjG2lOASXlWvmZ0/aAwqC9gPX/OYbKnJ7pbQR8CDogRaiyJgq/zVY+unEYgbZ4CgxzTKIdPmJSEX3GdpRC3fEn43eNzyLINN+6BiIizfax6A1MQwr1wi18TcZ84CtYG0sMz7UAs/vZaeh7nNMom9ezPBIxU3TyLM7tqSZL1GA0DgLVs9kr0FKoZVoIBnK9K0X269vrXjSOMlF9C0e2Xr/lZ9gNkGt7isQ6XVtPmgfDLWj2mhmhZQE5/bO2driPyNsL4211TdwSP+Xp/vnJfhaCPfTrLR00giwRHDoq4zLK8ra9k147fwAJ8+LskB117aDfN
 vJ6rqx9o
 Bq77sFslk6E53xjGhFDN9YSxYQ+DUQ7gTQHUVMVXo/ksQX1wWQ34l/0wBbsm9GgB/BW85F/A/d+rg3TA1Qkg9SVCiuj1cDUBPUbhClZPcaM0KG6jis/mhvW0Z7vNkC35da0v1PtFMd9QQjSLuZRXgfaDDtRIkpX3h9shk6OX9nQ1WuTBPoMrdiqYdlH50AYtBf5Nsur4znOzFaTo=
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
in-flight reclaim loop is therefore guaranteed to observe it. This series
checks memcg_is_dying() in the three reclaim loops (memory.high,
memory.max and proactive reclaim) and bails out early, so the writer
drops the active reference promptly and the remover can make progress.

Unlike the no-progress guard (MAX_RECLAIM_RETRIES), which only fires when
reclaim makes zero progress, the dying check also covers the slow swap
I/O and thrashing cases, where reclaim keeps succeeding a little and the
loop would otherwise never converge.

This is orthogonal to commit c8e6002bd611 ("memcg: introduce
non-blocking limit setting option"): O_NONBLOCK lets a caller avoid the
synchronous reclaim up front, while this series handles the case where
reclaim is already running when the cgroup starts being removed.

The legacy (v1) reclaim loops in mem_cgroup_force_empty() and
mem_cgroup_resize_max() share the same pattern but are left out for now.

Jiayuan Chen (3):
  memcg: bail out memory.high when memcg is dying
  memcg: bail out memory.max when memcg is dying
  memcg: bail out proactive reclaim when memcg is dying

 mm/memcontrol.c | 6 ++++++
 mm/vmscan.c     | 3 +++
 2 files changed, 9 insertions(+)

-- 
2.43.0


