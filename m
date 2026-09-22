Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1B1C982F0
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EEE6B00A4; Mon, 21 Sep 2026 20:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FE56B00A5; Mon, 21 Sep 2026 20:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855936B00A6; Mon, 21 Sep 2026 20:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605C46B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E28E6A0343
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:15 +0000 (UTC)
X-FDA: 85239521430.05.2756960
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E5C8C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ov6TRdKp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=baMDWWiEiQIL4KKRD6NK9Rm2PEbCcFAt14/9wp+zoEI=;
	b=uqgU192JNi79x402dKm+3127JdDsrBvdbiVFVGHnNYUtgkks9JZn8OiqnCsJnFmtR00Jvo
	HwnfrkoO/peAP9cq5/fTNSuPB7pNJeGTpuEanCwa0RCBjX4iqdI4moNZCKpZ5AAfkKfYwT
	V+OoULVasUfj2Hh51hwalxNMRhsDcI8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037133;
	b=Ue9Cw8KJr7/S91l9V47/6tspgioCP6MjzJoyWSNWIRVQGp+vu6x7P5lQygrzAzDxNoY06w
	oRdqwMwOf42/MJop9J0g3JyVtxjz356C38epZkkwZqJDj6CdRWoGLYf1O3IIKg3yVJoH4H
	mxS7UrfG1NGINOj5vGDQdbpQ/BsJV6M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ov6TRdKp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037132; x=1821573132;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wd3ZbLadIrxogGODGsbFUG0pKS13H7GZOCBaz6h5tGk=;
  b=Ov6TRdKpz6iKN3tmoqwpHDsGykb+R1wYNeR45AjEmrlYC3YIthYopL58
   yAsGnmN2bhFpDre7dOc9g1zCkm3gtt6WDf3d2aQiUuxS5sjPsgBKHO2Wx
   XqzR4hZ04s3MEcT2cFiiu0lPIuOOtp9U8zQ22hrVen2Cg2rgKIm0wtXok
   7diWIDZDTXOtTUoeNWWTQmReTJ0eTUG1hrXgxgQCqXWpJQoaMJE4m66V+
   apIR3x/SGJbarSrzx95WvqOn0J3M+0Fd34w556hz8nWnx3TT1FihOmVWk
   ODxOhftUMFiQpq8Q9/2YyO5ID/TVRDbfrQhjTOexj24uLVvaKJ1d6VuV/
   Q==;
X-CSE-ConnectionGUID: i52nCF1BR5mgniSOl/ur3Q==
X-CSE-MsgGUID: ol1Alki3QY+wUU+svkDXlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716609"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716609"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:10 -0700
X-CSE-ConnectionGUID: BDhRwhlWS2WlwcRAJYSMqg==
X-CSE-MsgGUID: /lnVmbWfSv+H+9fuhFCkJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671805"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:08 -0700
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
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/6] sched/cache: Fixes for cache aware scheduling
Date: Mon, 21 Sep 2026 17:37:21 -0700
Message-Id: <cover.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E5C8C0006
X-Stat-Signature: sbwqnpkgtauwjmp13osjzd764dibnc6d
X-HE-Tag: 1790037131-329492
X-HE-Meta: U2FsdGVkX1+XihF+KWGhh+ExL8ow+xKZuv9EjevaSsxdoslNs9rvt93zPgaqPBBJaqLooW5CdU0P7Do7crBfE5n+pty7t6uRgiztlfznuTqZfR8g0yE3Os8WVaKatUg+OAqptQThvvMDT4A29yYXzgLzU/wH3h/CBbh0uHkPHmvRVJJnkLvNlnFiP8O3W4wvLGqkCloASDpKOcrECzPOCH3FVJ0C8P+xrOD5k7QC3+we2swghT2L4NmRzs/x/FTAiqch6oASKB9SFiw7qN4Mqj/wpGH1Kf74BImiCS8mFocGpbe8uykH3SeQanoUg69OsWKSkxcfR4JjrmxMSEfDaCRrXb9zL3QJoLSJHhh73uF54qDfuI2M/X9Bz9X6rlTEMKeSOYc0NK4Hjz6SfXiaerJ1AWqe12kmqrI9HjTppvJmF4r4UJiy55iZcaXgDbhjgl2CvVef+7WNGrHrYVK/niU8gtfccgzDGD7hx6/dXaMnM753ek7t+tMD1MbvWR36DAz8cS8iE4caoZyb85YU4rvlx7cOurQbE4LfUKGenJAs2bFy1IYzl6ktqeKq2q8TJVkAus7GNSoLKpCIyx5BgnEKgNcXHGbwVuCwjjpJyglWTuVgSVhgIcPySS0ASM73XEAFZ3ulla2Nose1g501xOwUavet5FtsNFSzRYBu1gC2Z6wxtxY+BaY60e0ze49v8HJIDL5bZ+h3wUIfrDbrNzxLPADBEXiFZaiyr5GKP2p40VC3cn/nXSyLRh0tOtHtI0tFl8XcdFujZX/WQ18HWY3LHRSCWFBGo02DvqKR8re2kLfh7lWU8R5C0N/f8WobfdpS9LqaZPyLuv3x78ZAprUR48LJiRqEd9zJ+mHWiJIpu1mXD1k4dXCK4qZnAA2gVXHyf90mESNoyRDvoyHMBziTcpimmGKsdvHpdgsvX40622CZz7SvQggDdbVUb8yEoOU/DzvNYR09X8OH1X7
 fF8WzJ84
 hMgSPFPCv+zarXhBhqZsM2MoNo1JT77shc/hwtn7ga3zbFxHxhnAPMB5JY588llahsAdIw/vZZiO7J2XXasci/V5HUogu5vMthvBG7mgbo1fWYW6mNeMfwhBeqWOIC5TfYApwCTpePhUsnZi/uusWwleUbWy+fvP3+KAXOJEH2aepIESwhdi3Ag95C7GXPoN7cgh/jesDEC4CkzGFKED0TFugoZQWUjR+bH32JWzIOYswzUEbua95A0XLZ616HV5XyJVfFN78ecg6lfo536lKhGrW+PKq5VssSjonK6a22DfXeS1kerxwFtFydCQsCxz9hsZ3/2j832Ggl4+Kf6cJEMPDi3dS2b2ZPubh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is an update of the patches to fix cache aware scheduling issues
found in v7.2.

We collect the fixes in this series so it is easier to track. We have
added two new fixes for issues found since v1 of this series.

Patch 1: alb_break_llc() compares nr_pref_llc_running with
cfs.h_nr_runnable, but those count different sets - one follows queued
tasks, the other drops delay-dequeued ones.  With DELAY_DEQUEUE the
equality stops holding and active balance pulls a task off its preferred
LLC.  So fix the counter.  Reported by Zhan Xusheng:
https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/

v1->v2: Minor code rearrangements in set_delayed().

Patch 2 (Lu Wang): the stopper doing active load balance builds a fresh
lb_env that doesn't inherit migration_type, so can_migrate_task() can
move a task *out* of its preferred LLC.  A new LBF_ACTIVE_LB_LLC flag
and picking the stopper callback at kick time keep the intent; passing
migration_type through the stopper would muddy delayed dequeue.  v4:
https://lore.kernel.org/lkml/20260903020656.3793626-1-wanglu.priv@gmail.com/

v1->v2: No change.

Patches 3-4 are for the use after free Hyunwoo Kim caught with KASAN:
https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/
account_mm_sched() reaches the stats via p->mm->sc_stat, but a task can
be switching mm on one CPU while another is inside account_mm_sched(),
so the mm and the stats inside it can go away underneath.  Locking the
rq in the mm free path felt like the wrong trade, so patch 4 pulls
sched_cache_stat out of mm_struct into a refcounted, RCU freed
sched_cache_group - just moving code - and patch 4 does the real fix:
each task takes its own reference (copy_mm(), exec_mmap(), dropped in
exit_mm()), and leverage call_rcu() to to protect
against UAF in account_mm_sched() so the group outlives any mm switch.
Zehnghui Yu also independentaly found this issue with memory poison.
https://lore.kernel.org/all/343a7e07-7fad-4979-9c9b-82ec038c293c@linux.dev/

@Hyunwoo and @Zhenhui, will appreciated you can test these patches
and add your Tested-by

Nice side effect: the group no longer follows the address space,
so a user defined group, or cgroup or numa_group could own it later.
These are also the grouping by prctl RFC's first two patches, sent here
so the fix isn't held up by that discussion.

v1->v2: Put cache aware related code in process exit/fork/copy in
its own functions

Patch 5 This patch makes sure kernel threads are excluded from cache
aware scheduling consideration.

v1->v2: Split from previous patch 3 as suggested by Peter Z.

Patch 6 is a new patch to fix an issue of undercomputing the LLC size
during CPU hot plug events.  The LLC size was used for estimating
if a process's memory footprint will fit a LLC. 
https://lore.kernel.org/all/20260916134432.11767-1-davichazbh@gmail.com/

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

Chen Yu (1):
  sched/cache: Skip kernel thread for cache aware scheduling

Davi Chaves Azevedo (1):
  sched/cache: Refresh LLC capacity across CPU hotplug

Lu Wang (1):
  sched/cache: Honor migrate_llc_task semantics in active load balance

Tim Chen (3):
  sched/cache: Keep nr_pref_llc_running in the runnable domain
  sched/cache: Decouple sched_cache_group from mm
  sched/cache: Introduce task_struct->sched_cache_grp

 drivers/base/cacheinfo.c       |  11 +-
 fs/exec.c                      |   1 +
 include/linux/mm_types.h       |  15 +-
 include/linux/sched.h          |  21 ++-
 include/linux/sched/topology.h |   4 +-
 kernel/exit.c                  |  28 +--
 kernel/fork.c                  |   2 +
 kernel/sched/build_utility.c   |   4 +
 kernel/sched/cache_sched.c     | 106 +++++++++++
 kernel/sched/fair.c            | 310 ++++++++++++++++++++++++---------
 kernel/sched/sched.h           |   3 +
 kernel/sched/topology.c        |  22 ++-
 12 files changed, 394 insertions(+), 133 deletions(-)
 create mode 100644 kernel/sched/cache_sched.c

