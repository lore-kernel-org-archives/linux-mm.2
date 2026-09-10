Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA959C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885746B0096; Thu, 10 Sep 2026 13:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836CB6B0098; Thu, 10 Sep 2026 13:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725B56B0099; Thu, 10 Sep 2026 13:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA516B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A2AB405E6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:53 +0000 (UTC)
X-FDA: 85198567986.10.FD85DD1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9D1591C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nny3RGw2;
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789062051;
	b=oj8JADRuPLfBCrrFJEntNs4yrZX5XZ/jVLff9oIQb6Lv0CMIB5KIp50M0FB3HdkpK8Ir12
	moeg63fI+KIpI7eVuoYIO2DPtlofWrGtlw0UwK6ad8ceGDZ6YkkiD5ArKjJ+hyPAIkMN+O
	g4ZO9YQoL5O2azW85kjFM76n3uD0teM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nny3RGw2;
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789062051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MnV6smn+EV9zlD8FRIGg1FFdP6Bvk/Od9jDRkoKypWg=;
	b=gwjHk8mZTw2pj8NyIKI5BOUljcP1r7fKRF29g/g0le9IrZTmanDm7IY23SbfXkbJM2Xc/o
	nG2E3fAcB5p0HDoapNSjdRvmAglvBvaJMN22Ht9rey4ccsK/Nz9CCGY29xmOGPsYy1AtLP
	W+DqDfrhm3H9mhjKbgQq4k08AM4E0lY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789062051; x=1820598051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pw2ile9UJm9sSX8bIRs5HbF7n8pZFfyy9pU9RW/L6dY=;
  b=nny3RGw2r4WrDGxJZYOhjlxhI1w4I5nYqFjHN91jnWnq6dIG7B82BVk9
   YchezdMCk1WJNIRi+wOoFe+xO8uYDt9unJzpWXVE+NTDX812LJDdcO96F
   bY27h/qodE+/+97agngibMF8wLnQlSV6WeX8l9dWxsK+hefwmljC/yJRT
   TY1HvYdLL/tzHNvFUAkSmZWVsNPToDnkETkW2O1K7p2ZXQfd6X1Qekf9d
   BeR2xZp+T1Yk9g03qotPG6FwCE/CGtLhmchqsYyG7hKj0O1fS2GT/di7F
   FYAdtTYSb/X5snb0g8WPCpp3vwDelK35HyiVVTV+A+qZTiEmHrI0L7ovV
   g==;
X-CSE-ConnectionGUID: kHeuaIfcQ26m07uFI5NA5A==
X-CSE-MsgGUID: ag7DdTpQSj2eUkW1+nrhVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89453773"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89453773"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 10:40:49 -0700
X-CSE-ConnectionGUID: ykw0HvrzSzSnsZLcrRAFXg==
X-CSE-MsgGUID: qRKwknrZTm6tjcrtG2htfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275222006"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by orviesa003.jf.intel.com with ESMTP; 10 Sep 2026 10:40:49 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/4] sched/cache: Fixes for cache aware scheduling
Date: Thu, 10 Sep 2026 10:46:08 -0700
Message-Id: <cover.1789061845.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D1591C0006
X-Stat-Signature: yczk4r134g1q7o6icne6dzwuesdbjns8
X-HE-Tag: 1789062050-838346
X-HE-Meta: U2FsdGVkX18tqMZ58xbv2nvtMpY8TKtCgkuC6vqEey3KuAQKvBecIqAu+tgY4Nm1zYPOwpDBZ86dFPsOi219d3BcVXMs06N+hdD/bawUnG1qv5seW/11oivg+lCyDXiFMzBwcxmycTvMM53112zBNmKGrnSnqy2H8X4ufwyqGNrt2tq/pJiDOr9IoDeC5VFrx3lNppo0LMwKDdDvvjYbEPDvAAs294AxmWQJqiUQQFFLj6ZGhdpSjIngnQb+dttRVEy14AwZfPIIa5gXxtReu5wDgHQrCv6w8igerkRCH0cIcvYtfB/X7PgYirPFRNPxpeJN1SFOcFF+P3MRkH5J/uEuQ1fLnsbVOTUUzMQ8t2jUtF+ZIaVp5nwle1o6CsEedAZ3IzFIjGSwJH6+V+VgIaMATrVd+34lCIpzBO38tuG3LwW1C0iyjW2nWpQp6wZJpDu5ceso0SP57YMhY4jqEK/sLOslrbIpzJ96raO+8QKjCr+ym9jKSYkei/wsG6A105y7H76jfFy5jybD1j8IelCmWoLmo2XIOkXynWqk4R71fQbK9Cm+8MSOMQoijL1s+Q0SH9S8U4qswWTzVqSv2RSzwvOuJZxpvnd4krrIDCPYw8sQL9UjqJLzHVcSOu77v4Zw83uYIJBkDVIF7T7NM9JQFtVOcGjCdfJRYyLgPZHVTYAEsykJVH+zHlg4Sj4/pvpiRr/ObZVBjiBHsq0iS8L5eA7nGNKyJM1NVZT85/5xsMBpEFKKDo/uCRI1IVntWUO5MmT+4a3BI89rDgcndF4N1bRSwwNy+oYxKbvQEBLyDWCalySs1Tji0wnv64U+QdWO2HKcGCBu1/vqXdDTOfv/MU1XjMrMhg+QfmS3PEIg9jMm8i0gpwVwkh7+vDxPTAn05bnYOYQrvLAx8lrfrZOjt++gVPtl9hvzygO+k54+ErIJ8UZkKe7InRwBBZ/dyPqDLedwLwLpn6rbe1O
 sBMxxjmZ
 7j/jtdV3hS7DPNJ0BiCaZn/4SeG+WNcNOj6D6K/vLb+zMVA4dpIEFFNJOV1C6lLRVlViyOtFu5i3ZCMOWbxo0AiplouBD8oPTE12uqmQ2Gk4pAgA5OZexkSaxhPOhZZtrOQHfqMkKrU2lCRL4cxMu86lG4Mz/JzZbEyPPI2zOYVBmYt4hjO5MNoJqKe5D8J3TFW11Ti7zI0OPviAh3dnmH824ODeiGvICG9nQxazJxrum36f2uR3uZSf7ubln4StW9FrENK0tW4R4li1Nkv2Zzvgj/PZ4eZPr45Ou3Wu/7UgMNErpw15hYweUtInmtPIw+0Va4BTh1cnhiYsrSFaRvty+Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Cache aware scheduling went in for v7.2 and people have found a few
things wrong with it since.  We collect the fixes in this series
so it is easier to track. Two keep tasks from
being stranded outside, or yanked away from, their preferred LLC; two
fix a use after free.  Patches 1-2 stand alone, 3 and 4 go together.

Patch 1: alb_break_llc() compares nr_pref_llc_running with
cfs.h_nr_runnable, but those count different sets - one follows queued
tasks, the other drops delay-dequeued ones.  With DELAY_DEQUEUE the
equality stops holding and active balance pulls a task off its preferred
LLC.  So fix the counter.  Reported by Zhan Xusheng:
https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/

Patch 2 (Lu Wang): the stopper doing active load balance builds a fresh
lb_env that doesn't inherit migration_type, so can_migrate_task() can
move a task *out* of its preferred LLC.  A new LBF_ACTIVE_LB_LLC flag
and picking the stopper callback at kick time keep the intent; passing
migration_type through the stopper would muddy delayed dequeue.  v4:
https://lore.kernel.org/lkml/20260903020656.3793626-1-wanglu.priv@gmail.com/

Patches 3-4 are for the use after free Hyunwoo Kim caught with KASAN:
https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/
account_mm_sched() reaches the stats via p->mm->sc_stat, but a task can
be switching mm on one CPU while another is inside account_mm_sched(),
so the mm and the stats inside it can go away underneath.  Locking the
rq in the mm free path felt like the wrong trade, so patch 4 pulls
sched_cache_stat out of mm_struct into a refcounted, RCU freed
sched_cache_group - just moving code - and patch 5 does the real fix:
each task takes its own reference (copy_mm(), exec_mmap(), dropped in
exit_mm()), so the group outlives any mm switch.  Same Fixes: tag and
Hyunwoo's Tested-by on both; they want to go in together.

Nice side effect: the group no longer follows the address space,
so a user defined group, or cgroup or numa_group could own it later.
These are also the grouping by prctl RFC's first two patches, sent here
so the fix isn't held up by that discussion.

BTW, there are two other issues in discussion currently and need
a bit more work:
1. Incorrect donor context being passed to task_tick_cache().  
https://lore.kernel.org/lkml/20260909092901.2989564-1-sh_def@163.com/
It is currently under discussion and is not included in this series.
2. Cache aware scheduling interfering with ITMT.
https://lore.kernel.org/lkml/20260810033742.1688718-1-yu.c.chen@intel.com/
https://lore.kernel.org/lkml/2fe2c681-b748-41fa-8b56-1169c86cefbc@intel.com/ 

Applies on sched/urgent branch. 

Tim Chen and Chen Yu

Lu Wang (1):
  sched/cache: Honor migrate_llc_task semantics in active load balance

Tim Chen (3):
  sched/cache: Keep nr_pref_llc_running in the runnable domain
  sched/cache: Decouple sched_cache_group from mm
  sched/cache: Introduce task_struct->sched_cache_grp

 fs/exec.c                    |  14 ++
 include/linux/mm_types.h     |  15 +-
 include/linux/sched.h        |  11 +-
 kernel/exit.c                |  28 +++-
 kernel/fork.c                |  23 +++
 kernel/sched/build_utility.c |   4 +
 kernel/sched/cache_sched.c   |  39 +++++
 kernel/sched/fair.c          | 297 ++++++++++++++++++++++++++---------
 kernel/sched/sched.h         |   3 +
 9 files changed, 340 insertions(+), 94 deletions(-)
 create mode 100644 kernel/sched/cache_sched.c

-- 
2.32.0


