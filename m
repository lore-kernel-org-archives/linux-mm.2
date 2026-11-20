Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66BF60A2629
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kShdmTW5
Received: by kanga.kvack.org (Postfix)
	id 072A96B05B8; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AC26B05B9; Fri, 20 Nov 2026 13:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1E06B05BA; Fri, 20 Nov 2026 13:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA0346B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:39:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51E68140148
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:44 +0000 (UTC)
X-FDA: 85456361088.22.5CBC6E2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0C395C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kShdmTW5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199982;
	b=NotXDsEQT7EZVN33hExcffp27YrXv/zUPRm8Q4GLl+udXGH5hlYNdUABLuArUO9/4i0xo4
	1GBJ5bFBLXG6b64lNYuURwtXY4BpaDyVeaoVYxmBYnnsJJJWbDo8yO2t78/idJte3BMbxw
	RCQKjP0zjyfvJcl5wi257vh57IelWfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZhWYiKMz0I909x14S6WTsCN17CSOKetN9y0mlG9X2U8=;
	b=Po/AM/Euum+2Utd/gtdtJALSMuqJGbyEFqg6lZNuk/1m0IFihJV/ZDU7lYqV8elkpdhhj/
	zFllr6981715vOYIwyCtIyvTdArt4z3Mn/JR5cjxVcj0fr+DZGlDmWfg08pG2iaJfJQbuT
	QDZgedGb9LXEQDYm5E9t2RW7QVRE+NA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kShdmTW5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199981; x=1826735981;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9YaEU0TvIY/OjSK1wIFdzU3b2/N0S3hNw7ve94G6eTo=;
  b=kShdmTW5YicsPyjMwPa/iieqCmYO5LgoTKNQHMJ65FGHFl/gKbZkystM
   kue7jMO/23s33wZsFw+NLm4+LdIniXXik5W1ByTyi71uhryxTMo43aEv2
   xS4u7s4lGvUjrNuOU9zUonfCebwTB7JYM/ZHOuaBnUQBffVEWjwwUvbfB
   20/WzoUFwqpnGkw1MpNYhYGacEfhynnUy32iMPqUovhAPXO16oGJDkmOG
   /kPKiDGjVj6ksZCIrZylBSVm51qeTcIe8E9SKfLAB4s4EWzRTMWzx0Dz0
   WSCPFwDzp3BgI1uQ0sNiqTejsfxeW3nuoCwPatapBbNbQztkN/hjdpx7t
   w==;
X-CSE-ConnectionGUID: pg6fVm0ORfSC/lBTDbn08Q==
X-CSE-MsgGUID: bJn+b0rTQ4a8Pagn9FMfUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931819"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931819"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
X-CSE-ConnectionGUID: ggHYqvJLTjixJLp2B4jDTg==
X-CSE-MsgGUID: zm1wqfjKRE2iZobvEAfJKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590711"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 0/3] fork,arm,x86,fs/resctrl: Fix stale resource group assignment on fork
Date: Fri, 20 Nov 2026 10:39:29 -0800
Message-ID: <cover.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0C395C0005
X-Stat-Signature: ryo7hpwpswdrb9hww7jct3qqmwh45orf
X-HE-Tag: 1795199980-941504
X-HE-Meta: U2FsdGVkX1+7lZau/9npN0cKKYLP9g7F2aHxiJkS8WSHAkGoJc+6D5Cq0ERGRGQIs5GkEqisR6D/8+75T1q1zoiiuW0f3Z6XCNqFgnWeHQBZnWztltAM33nbg5A5Dq7AFLdGEHifoLPCMu8mOyrlSqAW/vYW86hRZnsTOzebXep1uH3mdpad9Of3d/xX7qPZq+E3wxV85RdMJsGfmeoab/6wN1VZRCfH+mJmgMcO6asJZN1rV16EjyNHcv+vo/h09+nwJREWSgcif7Qkup9JO5yKaITVjzULsy/NEBx6kGM22p/386gMWfkmsJkO2qd78YJ3NXYH3VRnyof0NzCzkRViE3Yl5hB96EgHMePpRQzD1zWz8wudvzebYz4+7e0Xf1Nh4G6pfChlFXyTQ0YRB0UX97A/LuafwlgUIEz/c9PzLaGrxMl/COcfI20Xsq5A8wSAm+ute5Y3O8Ndgz1irlqB/jRqq2ULOADbLssgGGjPMW8MBSWzUwdMAr6L/Afyl4j23dQ7EB5BfqTJ9yl8HkYH1dZ2ggH1qw4ryQgFQIxTthWRwFUakQKQHy+kAIQyz1ZLvJNtI1gUDZs+lS2UxmpfNXKpSejLMdQX9lztkE52fGTa6gDivsdKPNm0wa1WFZ/Q5/+6X811CqVRuAj3s8OVP0h7PRfQO4by2v4CfLTb0TJNdEO78JKQgMr0XUqEQ6GkBCd3xuFBWtOwqI2ll5h6sN3iaX8CtPo1vq78aStTLOc1Tx3x9gGU43rEPxcWTKo9IPwTpbCVnZLlPq5ndZFjrg13ImFCT+JaVxynmUpdlJuq00/nEt3aKJ31VwxcyiTN8jqu2uTzxPGTZcMX6Mixdz8i6pjdjdvW1WolTBW5nfy4YurhJw5iHCJxPSFN6nCep8Jt9LTYpsV1QORh/gBWKeSiSRA9lu+WrF1V7M/mkl4A7o3gdZKBG9vc0OWmbW7Lcq/AcgKStNcPpt2
 EbaqKQ01
 luarox5M0QlC/nL9NyW9xM9/M6y/BgBMyUkoje/BpVUv3sHhdIbCUVtmND0bCNAlsv4VFSGPyaUGaxUkHctWz21Rkm2+e3RmJQVA5adwqjmkdkvl9EeK03cvj0DhAZHwr60pQMyD7ZKejQqfrARN55t3tk3d2u7sPjbFRzHjPGVPZ+hOR542JjRm1M47ckoKOiy1V5N5crMP6iIGSRUht1yUuQSVYAh1m7uIVCAHlqaKGeo9UBdoNkdUgGRR3MXWfk3q0gfALkNPUpCvOwVGAFsojRjLP8TJtf2pUhn4Yug1J5Qev3WLNPFVGVvhXkm9aVs9g0b2joGS7aH+CCQQ8/3xwJkvJo/wSx0AJt635SbMUq+d7Tn+hom3VeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Everybody,

Jedrzej reported that a newly created resource group can start out with tasks
in it, before any task has been assigned to it. He created the reproducer in
patch 3 to demonstrate this.

Hitting this needs a fork() to overlap the removal of the resource group the
forking task belongs to. A system that forks heavily while monitor groups are
created and removed around it will eventually do both at once.

Removing a resctrl resource group moves the group's tasks to another group by
walking the task list, and then frees the group's CLOSID and RMID. A task
created while that walk runs escapes it: fork() copies the parent's CLOSID
and RMID early in copy_process(), before the new task is linked onto the task
list, and the walk holds tasklist_lock for read so the new task cannot join
the list until the walk has finished.

The new task is thus left with the CLOSID and RMID of a resource group that no
longer exists, and passes them on to every task it creates.

Once the freed CLOSID and RMID are handed to a resource group created later the
strays appear in that group's tasks file, their memory accesses are counted in
its monitoring data, and they are subject to its allocation policy, while the
group intended for them does not control or monitor them.

Series layout
=============

Patch 1 depicts the race.

resctrl has no fork() hook today. Patch 1 adds one, resctrl_copy_process(),
called from copy_process() while tasklist_lock is held for write, which is the
lock the task list walk is serialized against. Considering klp_copy_process(),
this seems to match the custom used to address an issue with this shape.

  1   Add resctrl_copy_process() and assign a task's CLOSID and RMID
      with tasklist_lock held
  2   Record the new tasklist_lock requirement with lockdep
  3   Reproducer, not for inclusion

Why is this an RFC?
===================

- resctrl_copy_process() runs on every fork(), so
  resctrl_arch_copy_closid_rmid() is a static inline on x86 but is
  out-of-line for MPAM. The note below patch 1 describes what was
  attempted to make it inline for MPAM and asks the MPAM maintainers
  what shape it should take there.

- Patch 1 touches kernel/fork.c. It adds a single call inside the
  existing write_lock_irq(&tasklist_lock) region of copy_process(),
  immediately after klp_copy_process() on which it is modelled.

How was this tested?
====================
The issue can be reproduced using Jedrzej's script found in patch #3. On
my test system the issue is encountered on a single run. With these fixes
the reproducer did not encounter the issue in 100 runs.

What remains?
=============
On x86 the CLOSID and RMID are separate values in struct task_struct and
__resctrl_sched_in() reads them without a lock, so a task can still be
labelled with a mismatched pair for the duration of a move. Unlike the
fork case, which is permanent and invisible to every later walk of the
task list, that window is transient and the pair is corrected at the next
context switch. MPAM stores the two as a single value.

The series is based on v7.4-rc3.

Any feedback is appreciated.

Thank you.

Reinette

Jedrzej Wasiukiewicz (1):
  NOT_FOR_INCLUSION: selftests/resctrl: Tasks keep using removed RMID
    after fork() reproducer

Reinette Chatre (2):
  fork,arm,x86,fs/resctrl: Fix stale resource group assignment vs
    copy_process()
  arm,x86/resctrl: Assert tasklist_lock is held when setting CLOSID and
    RMID

 arch/arm64/include/asm/mpam.h                 |   6 +
 arch/x86/include/asm/resctrl.h                |  11 ++
 drivers/resctrl/mpam_resctrl.c                |   8 ++
 fs/resctrl/rdtgroup.c                         |  21 +++
 include/linux/arm_mpam.h                      |   1 +
 include/linux/resctrl.h                       |  28 ++++
 kernel/fork.c                                 |   3 +
 .../selftests/resctrl/stray_tasks_repro.sh    | 122 ++++++++++++++++++
 8 files changed, 200 insertions(+)
 create mode 100755 tools/testing/selftests/resctrl/stray_tasks_repro.sh


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.0


