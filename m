Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2DEC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6431C6B008C; Tue,  1 Sep 2026 20:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4956B0092; Tue,  1 Sep 2026 20:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E22C6B0095; Tue,  1 Sep 2026 20:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26FE86B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:04:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8C82A4443
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:04:01 +0000 (UTC)
X-FDA: 85166874282.24.4439EDC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0272180005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:03:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YnHnTPCq;
	spf=pass (imf02.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788307439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=44KTaN/YULf537RgBxBPwFFkEqGnozQ5O6/TZ20azEo=;
	b=WOmczFIMcb0gcJzPE965wmXihCzfg2jdtcgnzPqjG1GY/OsiSzomhYmCm4rQumwO7ALHoQ
	wEtQr1deT7r1fd1LrOZXgyHjjhleoASqRyP0FpbTsIaKigu6uE8f2DnM+EWswDUx11L6u8
	qtOvx4a0ozrhGUexrlN+8CEgdHCLbKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YnHnTPCq;
	spf=pass (imf02.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788307439;
	b=ZxB1CahOLta+DH8wYy81KqmG7jWs1qxVKZehD+T2FyNIpNG1JuYNr1W7bFt+xd76lYPJW4
	LYuNG7b/2ko55fcC2WjsFH/n0FQ4aS7Rp8yaZsXZwZ17PDYL43rXXd96gl6kScXXvQE2AX
	0RUaM+mzXIs2MBjbqCQXHKLtkHy1ToQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788307439; x=1819843439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Hd8A6gB5lahNUpw/WDMdphG7dWhWn6ip3TPO4ByWZ/c=;
  b=YnHnTPCq+/cWRYJTHZU8QMn+jMmW7ub7QnIT/38/Z4fEP4D+/i/DEvYA
   wJx+bYK2zJYxntdNgdEI3n3qmwcforZXvhWP/E+aTqYFrBPyDmv+l1sJ7
   5xXH+fdkChkLWgRor18cxzcQfCL1tjD7uS+i8gpW38EKbqyevbykyClCb
   g6tOW6Kundp8AYMpKmivDDlyYt4nCMxSZRTD8ZFDKrxZDXbhwIwVxtuyk
   TcxTpNaB0CfXUsEf4zqRX7a16uM45St+jC3zT00fH6c+GQ3xDPy8KjSKV
   Cy1/tWLefiEexPqu7/zrskVcVXfEvD57i1Qvicb4LbZGub/1VUrGbQWuf
   g==;
X-CSE-ConnectionGUID: W1uX9MvRT76Y5fTRksGrPg==
X-CSE-MsgGUID: rh76BVHJSTyLSz2IL8ADbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="106272949"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="106272949"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 17:03:57 -0700
X-CSE-ConnectionGUID: A891lACmSr6vX68K/xTIaQ==
X-CSE-MsgGUID: Jo8/543/RG+x0y6iJGIbUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="265531779"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 01 Sep 2026 17:03:31 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"chen . yu @ linux . dev" <chen.yu@linux.dev>
Subject: [PATCH 0/2] sched/cache: Fix use after free mm access in account_mm_sched()
Date: Tue,  1 Sep 2026 17:08:54 -0700
Message-Id: <cover.1788305725.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n9qyt3zwyey7su9q5tu57fhfr8b98owr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0272180005
X-Rspam-User: 
X-HE-Tag: 1788307438-3233
X-HE-Meta: U2FsdGVkX1/9dVdU2aMDlrFYicVS7uBt9PY4toD20/pnH7ANEJm2D2Zdn8ZpZIEeUasKvH+qEQNaxoCyBAEPbjAB9By1NHfVwd7Yxi68j3MkbB9rzIxwU9csPuYi/DzRIuJUdPvkZ5jny/SEXPTAnaxHDDgKrwfw4sDT1tjBhKYS3lauhh7dmB0yNhOlUlpe0gZIaburk368n7/ZwfTDwub+a7zflXINzrMZ0JXC71h1jurm7SfjiHmX91c8mupd7ob8QXiZfk5Xrd05rdirdqOm0/o3mv/MDyWlVd7uABZTxDImeuLiJRaXNx2qG00N8Zayr8kM1Vl9fGjMvab1ko810rZbDSctMqHQKduiKGaSvbBQHqMbgYbrS66KPZvCPmsY9e1ZVtSMGuqnNWK+uY5SNK05clhvRvJkvi1pdWLtiD7C8hX/AbhVKJKAMFW80d0iHrpLjX4dqNTzFtBOAgmuY7UK94vrkbU3JdEeSXtyQMqJviwAbZfTzZOla5PrnsDPcSREsYfSTnhm8tT9IScd0aSAjejhyGiIbiNEG0927ndT2coJWGyCMVwHTutHY0Mi/zjFSVKTVr3zapK8Ko96fK4alIglIlU1T6V+fRIjEXsOM1xnQuF5BEmEo37pJvgEwHejSmiWkdsPv6OJHmh/rJGBpYeepDONlJd1Kew14fWSDMPur/9pxUIjruJNoHsHLC0jEp1sQSzS9twAjQ0K29wEjl6EiW7693p8antQmzCr4ss+Rdn70WHAfWEk89qzFFJ28ytAVEAweWD+VAMyD0tiyxIL7fYiqSeeCoItQt7F8w1UJOqilsL12UaoesUqe6Xgjp0ScXM5A5XKJoGFUYutvElhpd9Uy4acu17IhspIxpn1cLnxavf4Byty9qaO7n6iHuwRVVq6k4V9fH7uD5+R38bqjw9Ja3hpXi50eMBDjSAfqR9uZM02k5Jqg0yQE9mv9YcGwQeVaYK
 t9dcbY4O
 b030BhglLKPMhq0H45PTcLyBoUPepw9K1JS8wGTvLplYSRwlYMiKIHl0hobQVsI5dzAOO/MuPjIfBDkL/dVsbyeZELuXbB1G3DoNCwy7flkR15ssRF0vWkI7E4Mm4JiRQF8W7zb9Ov7stwlPD+dNa0mOElYftFK+FNktzDQ6jcWenyUuZMrL/KVwkXhsUi/4TaZLtN7sGMTVmh2p/WX0FtXoRnFbKaNb+Ao4wQ5TEQf6hFSLDMHrjcdmgIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hyunwoo Kim reported a KASAN use-after-free in account_mm_sched():

  https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/

Cache-aware scheduling keeps its per-address-space statistics inside the
mm:

        struct mm_struct {
                ...
                struct sched_cache_stat sc_stat;
        };

so their lifetime is the mm's lifetime.  mm_alloc_sched() allocates
sc_stat.pcpu_sched from mm_init(), and mm_destroy_sched() frees it from
__mmdrop().

The scheduler, though, reaches that object from contexts that hold no
reference on the mm:

  - account_mm_sched() runs from update_curr() holding only the rq lock,
    and dereferences rq->curr->mm.

  - the load-balance predicates - can_migrate_llc_task() ->
    invalid_llc_nr() / exceed_llc_capacity() - and the task_cache_work()
    LLC occupancy scan read p->mm of *remote* tasks.

Nothing on those paths keeps the mm alive, so an exit, or an exec_mmap()
installing a new mm, can free pcpu_sched underneath a concurrent reader.

Serializing the two sides - taking the rq lock in the mm teardown path -
would put a scheduler lock in the middle of __mmdrop(), which is a lot
of coupling to pay for a statistics object.  Give the object its own
lifetime instead.

Patch 1 lifts sched_cache_stat out of mm_struct, renames it
sched_cache_group, and turns it into a refcounted object freed via
call_rcu(); the mm now merely points at it.

Patch 2 gives every task its own reference in
task_struct->sched_cache_grp - taken in copy_mm() and exec_mmap(),
dropped in exit_mm() - and converts the scheduler to read
p->sched_cache_grp rather than p->mm->sc_stat.  Readers access
the sched_cache_grp without worry that it was freed as it
has a ref count on the object.

The two patches are one fix.  Patch 1 does not stand alone, so they need
to be applied, and backported, as a pair.

A welcome side effect of the decoupling is that the group is no longer
welded to an address space, so a later series can key it on a cgroup, a
core-scheduling cookie or a numa_group instead of on a single mm.

These are the first two patches of the cache-aware prctl RFC series

  https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.com/

reposted on their own with the changelogs rewritten and minor updates around the
use-after-free, so that they can be considered ahead of the rest of that
series.  Hyunwoo confirmed the splat is gone; his Tested-by is on both
patches.

Tim

---

Tim Chen (2):
  sched/cache: Decouple sched_cache_group from mm
  sched/cache: Introduce task_struct->sched_cache_grp

 fs/exec.c                    |  14 +++
 include/linux/mm_types.h     |  15 +--
 include/linux/sched.h        |  11 +-
 kernel/exit.c                |  28 ++++--
 kernel/fork.c                |  23 +++++
 kernel/sched/build_utility.c |   4 +
 kernel/sched/cache_sched.c   |  39 ++++++++
 kernel/sched/fair.c          | 188 ++++++++++++++++++++++-------------
 kernel/sched/sched.h         |   3 +
 9 files changed, 239 insertions(+), 86 deletions(-)
 create mode 100644 kernel/sched/cache_sched.c

-- 
2.32.0


