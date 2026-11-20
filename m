Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A14606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BxpoXDgc
Received: by kanga.kvack.org (Postfix)
	id 702246B05BA; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8EB6B05BB; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0EC6B05BC; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2546B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A227B160141
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:46 +0000 (UTC)
X-FDA: 85456361172.20.6EE4BD5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id 716E8C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BxpoXDgc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199984;
	b=xVcq/VAlJQWhQ1wVHmq0XOPnn9DH8ELWRs5iUnXsXNEZW+yflyQ1L6XK2x46xQ7qIW4nyd
	ByxtDAMBzNRAbdQB3XPuZQRYiaWnn9g+jXsU99jIju+DOUeLgse0p7CK93cBmhyRP2ZEiK
	4QhUV+v3eebQqhGMOSsraw6E8ar7c/8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lux1QnDe26RBrxt6XHdu4/sdgdMUB8ZuvQNESEmL/9E=;
	b=Y3nZjIyAYy39DJ7cWPgruo/v5wzy/0dtpNiRwRUB22nPHseSj+WGEl+UEgWSVXr+cOhB2X
	k6O/r6vuHWMk1oo6rB6bfPc0H8h/fjEiAaYYTO/Ir8YM5bj2BT+DmWRQlXLGYR4UqnB1iJ
	Srag22HekBVeJqXjhINXJq6pKzEGLVY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BxpoXDgc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199984; x=1826735984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gxx6eNi8ibUkgPJe3lE7LZkGi1dnXyn6J8jv49fC89M=;
  b=BxpoXDgcOVxtj1onvIL/h/uUtgnu3MpJIuTqFI20oIyx1p9mun3SkFqk
   7rC3rv9f34PIFsUhoGe2YkR9qTTt25NdW+3UOBXkVZGGQiSyOY4035mYP
   YHh0mSIY2Gnu3kGTs/D3Gv2TAiDbpEGMHZz9PmFQpngm6m8Ejfid21bAp
   erPpJldhkSXpxCL2X4OISrrEAis/n49YnJBFIldrRjYzrPUoaQHBHs2/c
   P/N5Pu3cXYio1rHy39Jx8FUj/Sxp22ae0wTe5PYHIn/aOycR4dSMwqP4u
   C+CWmHVai25vmA3ayszLWU3ZNXR0Cd7a0upDQ9vu47/LxuTdwvkuJHnQt
   g==;
X-CSE-ConnectionGUID: bnUsgNDsS2GIOkUg8mydcQ==
X-CSE-MsgGUID: ZT9LtPgbRrm28bZhsAQ0uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931853"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931853"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
X-CSE-ConnectionGUID: PXy/A7cZQa2ZgNBSIucFlQ==
X-CSE-MsgGUID: RujFk1/vTdWmbdc2AQZ3tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590719"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
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
Subject: [RFC PATCH 2/3] arm,x86/resctrl: Assert tasklist_lock is held when setting CLOSID and RMID
Date: Fri, 20 Nov 2026 10:39:31 -0800
Message-ID: <164d1c3a9f8b281cd038f2e80badb1d94ba3d3c8.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 716E8C0005
X-Stat-Signature: grntuyd9wiaur896ijdxfqszfoo8on4k
X-HE-Tag: 1795199984-563056
X-HE-Meta: U2FsdGVkX19ILbY5ehlC6XIP+RyIs/vWKsP7HWjtH6c6o9dZ81Owiqp6yZVDN7AADfTGCZuJ9tHlM4eCFvmJBikE4rrYFLEdw0W0HsY3pA+WyJYpbqDMxWL1G3esguSywS3hbFDqkRgRWfUHt+OsMlltex4hIDdZRMdRS1NljYPRsr2zYf/ZCeDHQSmPsOoT8K43oyyWHlFAB1xQGUOFJfRjJzDyefkiakYSc3eo+YCfOM5whnnkU0D9ZMi0Ux74N5SJgntSIKw0/UjjIOAsiDsWnXSmuP0Mer02suZIFl4x7Hu0iohQ1g0Xv+WZaP/W35WAZRX7yDeLbsLmFu3pxRfOynSjYnpz7xb5/iiM0tOHKE3AxvenTBiCtYulenP5ApXIv2o3vMkWvlbEKKFIGYxkOybsvkax6LSxyrjj30qmptSec2agZZ1qVNihtMv0iRpM3Ymg4ODmxOfA7mIzne/8mHV10jspyWT6F8YmjGnV3yOEEbB3iNTZyuCw+n5acP/bEY0210aZgMMVz9jOmBgJ8c50lNOTU+NH1Yho6gO7TafhLbk8LGgTYOOJhcOPie6hHamy+6VnkgbWmUohiShZRcpcfvR8NqyYkjrSxvKnSCAG4ymEmS/oMfkvwRywoB1rFo41zUAa6Gno42lliIuvKFdW8AJR5pkFivlNt6EaIi1V40Ck8xBz1QgAiTrdoh+q6LUG4UqG44Wce1LLhKBJ8eIl10wyYoyehd9nHBkOFBtiBSZwcMU7Hcon3LrPjoJGnc7e+DfANZPmKO5++XcRgF96lHWg3n+jhR5ysHRmlUjyTRdzTP0PQmgBa51NdpfI9ZkFfzGVl6szi48Umax0M2EZ46zhSY3z0uCQARwp6PLepuLKZ2JcvuNtMiDu4T8YSnrdErbk2cfl3a2Irg7m7wJtyLBFiqhaocpRPb4bHp6yeGnUFCOC7vm2VG2sj+3YMc355Qolx5Y+k4t
 7ekYDBFt
 lce8nmP+W5c8+otoAg5cFf1vPRqrMtDODmW6dkuK9pFFeziM7XqIus1tPH6pRekBTTwqqLGf0+x8dtToF6cVJt5aWY1u/Sc8gmCV4j21oiKX353EjdSMrN5PsaMMeaz9JOXZWB5jhZN9MxZZGEOv6IA0NA41SprlHau/4pnTGW1eAR6N3f4wk73ciU4cP6ZA5k5wt7TLrNcKM3YhZUC8jvYDHP3Iu6cqZVctmeBCP1/wTD7b27vyBqQz8Yis0f4Kfvf9cws6/DNT3UJTJcEhVpeE7SEGXu+JcCoR8wIH8VD8YCrh+g4FNUVDN+gtg6u0rEkvgLkWqEp2/j0EnQXsbVcd/bRdYmCqPQ0KpGSlCJ2AGAx+wsYrI8vuDmUhpBTZ3rVzwkG94L7rIfTaPbN0Fbbiwz+pvYchqY9ZC/kCcH8KjO6eaxK2m99JW99tWbmMPC4PPdP8ze/VaRN8u/V2hYna23z8LWpStSHzJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

resctrl_arch_set_closid_rmid() assigns a task's CLOSID and RMID. All of
its callers hold tasklist_lock for read, which is what lets
resctrl_copy_process() read both values as intended.

Each architecture declares resctrl_arch_set_closid_rmid() itself, so
there is no shared declaration in which to record that requirement.
Record it in the implementations instead.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/include/asm/resctrl.h | 4 ++++
 drivers/resctrl/mpam_resctrl.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 199ca9af0089..48bf22fb6b47 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -5,9 +5,11 @@
 #ifdef CONFIG_X86_CPU_RESCTRL
 
 #include <linux/jump_label.h>
+#include <linux/lockdep.h>
 #include <linux/percpu.h>
 #include <linux/resctrl_types.h>
 #include <linux/sched.h>
+#include <linux/sched/task.h>
 
 #include <asm/msr.h>
 
@@ -149,6 +151,8 @@ static inline void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid,
 static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
 						u32 closid, u32 rmid)
 {
+	lockdep_assert_held(&tasklist_lock);
+
 	WRITE_ONCE(tsk->closid, closid);
 	WRITE_ONCE(tsk->rmid, rmid);
 }
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 7aea58fca85b..4e6ffe273863 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -332,6 +332,8 @@ void resctrl_arch_sync_cpu_closid_rmid(void *info)
 
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
 {
+	lockdep_assert_held(&tasklist_lock);
+
 	WARN_ON_ONCE(closid > U16_MAX);
 	WARN_ON_ONCE(rmid > U8_MAX);
 
-- 
2.56.0


