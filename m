Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9002C982F0
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE286B00AB; Mon, 21 Sep 2026 20:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D859D6B00AC; Mon, 21 Sep 2026 20:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D9B6B00AD; Mon, 21 Sep 2026 20:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A35E56B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36052C0335
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:21 +0000 (UTC)
X-FDA: 85239521682.13.F80799F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1035A0005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhudifD4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037139;
	b=TRrL8ighJEbtzg0CmxbDwHD1/qIhPPUxj0ITV7bkyJ9DWbV4bs3uctQpvbASQEnZMdZYyz
	uYnv/bU0CD0+S4X25i4ywpy0ZSejTQ5H14U29UtiJzSwqwdSlEwKy/1UQT2o+TkyF4tV7R
	aF+hzOnaNeCm8aT2i5Dn9MVMInJKs1E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhudifD4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IULJpZCG9tj8NEvw4S+xft14SWENEW2FTN/IZm2oiys=;
	b=29Rm42elSOn21N4LMVpoFKODROV0e6jZDWUsKLW3Qzoe9OiJ/3G7/Po+hnJ5ZXFU6+X/Fv
	WBpUCt3hIMPA8GEUuJjYr9BYQhMz2Gf6NpT2+rJajwv7vtjAa68GAsbhI5yJbEe5cV8Cy5
	HwWY5/yhbN1LjLOxarBWSlQ8jE4g+ZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037139; x=1821573139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOlHJ5o3h0eTKEGfK5htB/gt/IweJdH5Z9ZDtcA9SHU=;
  b=FhudifD4556rpGjT5Cp4KrW82omp9ZPr1vgjyNzZPOuv5G8pQKfah8Gq
   8sFZTFg2ICiuXAbayqyagGQvwKtzns6NufKwl6qq3MHVW4oofmxSdj2NU
   8I9RtsAUx1lIVonKfxFqYaEzXAJI8Vg6B5W3hmLibe0GhbY5Yxie1AD2A
   aOvXTU7PDpNHvSl66bc/JtaFmKCvMvrwvC9yG8bhfNThVy2Nr520133Zl
   kt0XuAnqNWFHjrmcPY1vE8eykoIROUQNVMJj0ITUiSVbO1/dnnOGqECEv
   P/4a5rJv8y6ato2oVnDCms2OSeZvFY1PWnBnPsuqg2b6UzvLvt7phnTrr
   w==;
X-CSE-ConnectionGUID: SltfNbG9QBCqH1wHrEIJAw==
X-CSE-MsgGUID: 4KnFQTWUR82r/dvbx1eh8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716722"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716722"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:18 -0700
X-CSE-ConnectionGUID: FK5iBX5YTM+jt9J2U/V1QQ==
X-CSE-MsgGUID: dAaD2tWDQOCsMtP+fuKQ9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671907"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:17 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Chen Yu <yu.c.chen@intel.com>,
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
	Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH v2 5/6] sched/cache: Skip kernel thread for cache aware scheduling
Date: Mon, 21 Sep 2026 17:37:26 -0700
Message-Id: <058f0c6ea7b991c177a17de347fa3157f25489a7.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1035A0005
X-Stat-Signature: oproiz5hhjk5zyirpqnh61st5zd1hqyb
X-HE-Tag: 1790037138-797795
X-HE-Meta: U2FsdGVkX1/eWaf0xWU2Vf+YJeUdM6+wllhgOvc2+JOmnA52VBn2AQP98C5EZXJAImKkqZS6JTyrfDWD1YsfDJVEos+toFBbpsZZb1eJso4w2h9sP9CxWL5vcPR/HhVNUvLOxmuxoFgWqTT03kWbMC+FlgZ0WEWX2sYUfa+nvZeQfY8ZaW35wYOhWV7S1whpM3K3cWTz4EaujOaD9DeUWu3grW5Be6ITIsBRpVhdfRiFzJc+4X/CLp2vnYNBa3ksfTcAy0VF1Eqvbic2TC4UREH10/PdgM/RB9U0AgIrF+QAHvizWgeuJrnJLf/GEYuPLW4GD3kDSFzogaxMsIwtWCXxBHq146EMxnp6vLnSuIXUPipoFt3ReH65MXQo4M2Mq89TD30g8ElPFa6npwLsrc8i9WgrV4SKeel+LGqMGRF5ONj1HnzE4LOz/yKw383+brPikgEdT8AkENCcy2zdJr7Q06IJUrSkuSbsWt3mdWPC+1DbY8a9tBqkYKdpx/K4auRItbEOvVOhE43iPQJp8f4ji4BbW5eZ42oWYperHlEjKQyvREiBmFz7m4ZFUp90Lg8OOLK84ulrav+kAC8KMERhGuxbFzb1C1Hi96lrLPecgniGfgEzpIyNY+VggpbNymqiVuSWx8G8F6DubJz2ytM+vuXRLqBlvvEvOU8+K3HTs2dD0goVFiAqc5avZ0P+ngss9RpkHl5B01GjsDBxhQGjJmjS2LDkUWUM6VZ4mXg3o+Yn9Y59rAX7QX9BmP3rwSOZemvc7h9Srfr/zDPojXJSh6PrU5POp5SPUCpirC3dJbao6/ljm32kezXVOa36wVF0dSS0l7ZX0thne8eC06hdYNd3xDEMPRjaYV2IxmGji0iACbR6zMRH0UOwQ20xWdsGQiOMhSfj8OIh7XIkzT6X3ISdLcV7wkHh5PkLxkci2M1gmzRVDc6NhAqHbkKRwJNY8cTS6rgNin7Q6j1
 5z0gYd9l
 BpSJghqSypgnZ1UI5WfAYnDP82vNYY67dY3StkbSg+14s4Jr/tP3VK3yLy/vtRXPDrQslZ4Go3sJpMMu2sL5b8VS8n8Lb9huEEoJP8zorIqlD47jE6gYKTb3MH33WkOx4DSa0EHK7yO2/kVSVgUjxTWf2yc7LCt4sfzo9ltFRmX/A0iKLls4edZU2/8MhIepEyyRQXO89zM9VbN4qALtvPWFMCfaVP7PGcMfnVZrP1OHCToToFoxRcIL3MeidF2XZSJAQDACB+tczbcz8WBKNnufYEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Yu <yu.c.chen@intel.com>

Kernel thread should not be covered by cache aware scheduling as
it borrows the statistics from the user space thread. Filter the
kernel thread in account_mm_sched().

In theory a kernel thread does not have any valid
cache group, so !grp should gate the kernel thread.
Add the PF_KTHREAD check explicitly here for safety
reasons, to guard against future modifications and
to pair with task_tick_cache().

Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Cc: stable@kernel.org #7.2.x
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3e2d236be2a3..341d2f9ed72b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1805,8 +1805,14 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	/*
 	 * init_task, kthreads and user thread created
 	 * by user_mode_thread() don't have a cache group.
-	 */
-	if (!grp || !grp->pcpu_sched)
+	 * In theory a kernel thread does not have any valid
+	 * cache group, because sched_cache_fork() is not
+	 * invoked for a kernel thread - !grp should gate the
+	 * kernel thread. Add the PF_KTHREAD check explicitly
+	 * here for safety reasons, to guard against future
+	 * modifications and to pair with task_tick_cache().
+	 */
+	if (!grp || p->flags & PF_KTHREAD || !grp->pcpu_sched)
 		return;
 
 	pcpu_sched = per_cpu_ptr(grp->pcpu_sched, cpu_of(rq));
-- 
2.32.0


