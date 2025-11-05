Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BFECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3986D8E0009; Wed,  5 Nov 2025 16:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3708F8E0002; Wed,  5 Nov 2025 16:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286208E0009; Wed,  5 Nov 2025 16:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 171B78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2652B9ABE
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:05 +0000 (UTC)
X-FDA: 84077780850.30.405EFB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10B96180016
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dtbAR/JO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376644; a=rsa-sha256;
	cv=none;
	b=vU8glcPURXY6I7BmJylY334H1yryQ0tKcoFwzHKsOTtT5TM7ORXo4V3FSZTp1HwuA+VC1O
	qTMDtlZKeqnRSM+vssmnHYtxGGGEMUdUXhPhZvp7m3vlj+GFlgV8+Vxr0IgC8o6KVNVzRv
	L5FPMf1DTz2uKXrobwjgP+x2DfEe2ag=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dtbAR/JO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KbRHAHejMA0mQr62kCLvQXM3weLqVxFVwaY0UNw5iaU=;
	b=SsTCBUN33Mvub+CecdPB56Jc2w1InJqzlF0wS2OeylMEjoH7DBxEvHChTJfqGmTke4HN5D
	TIBGdFqouOhdWbm/dh9ckJaVZWZXNAVgRa9OkwJPPVhJDEH6UDml8/g17PMGbf8Futg+NK
	hZaqkd6kaHlOyhWhn5BQlfXtY9mVfQc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF5DE401B3;
	Wed,  5 Nov 2025 21:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21204C4CEF5;
	Wed,  5 Nov 2025 21:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376642;
	bh=3lbd/EU2NQ8mLBwmqz/2m2jc7qv0uF70cLO4qQ/HcLI=;
	h=From:To:Cc:Subject:Date:From;
	b=dtbAR/JOu+tct/pxmTcYqviFrVXO6KQL6RNEt8EvVv6P33xPHb9dgHSk9ViufUw5h
	 kJ1uxg96GLeI8292NUvdAXLPsvexKzZTOvz/gqFR4B6Tf9OaddzbqXg2yQcuwzn5ku
	 NZ8Sz2aQ7UWT3Uo0jQ1QoNPnzhRVhti/SyAe56tyLNPuuhK+nf+q1QjFVpUI4PCL/l
	 xdV1u0DRnHSkyp4q84sPX72DQOu3N6R+ft0MWsYIMWFXcaMrhmv46DFunA41fPSuim
	 VgLUQjfA+k0lz49d9bWIB9ytxdlmtWzuFUN4GpAWzvETdfY0TBnWeKp8qSygESbq3Z
	 Ohs2vu0HGP3Lw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Eric Dumazet <edumazet@google.com>,
	Will Deacon <will@kernel.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Phil Auld <pauld@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Ingo Molnar <mingo@redhat.com>,
	cgroups@vger.kernel.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.com>,
	linux-pci@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	linux-block@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	netdev@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH 00/31 v4] cpuset/isolation: Honour kthreads preferred affinity
Date: Wed,  5 Nov 2025 22:03:16 +0100
Message-ID: <20251105210348.35256-1-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10B96180016
X-Stat-Signature: 8u4o6ikt6c5htmyb4mdy47rmb3bbh8ap
X-HE-Tag: 1762376643-268693
X-HE-Meta: U2FsdGVkX1/0TsE5hGWRSVb7DFHOjameY35rSJGm6PenF6tbaJ/zkQ30fLgpdlWrNQMXAsS3INYcBQPdJuVEEIqxDv+DWSSqgBmCuGW4UpXIB5SQhKqiZdl7+1z12yNeQzVRhjmjgfPWXcfO2pIdUl+yKJC3dtAfDkNEEs3tBc0KcjIqMfeyTG7L0InHnq/qOq/cnWtokh1KoWti9DVHhlohJNS2Gcvu18HW/01fnN6gcb2P+p7Wgy4IA3Ecy2DOByERyBdS/EvnlBSIFPbKUxg0iHcmondB3+jynqbKNsovNYx2B8yFWs8ERlshLEcTBOJTCOksmhiBU7OJegnz2eT6TG9K4FGzsn92GLNdAaDFowndv398Xjsq1vsImRMeQLYzOoElUeTglSJElSquzuzcPz2OnHBXPrApRBjrBM4U6AYLU0Ixgao60Wt0JW8osRIhXt7xZzEsefulwP7G5+RbiuRtIAma8UWElcPGTHe3hVLDBD5tQqa88gCedG8XIu3T3OxSdGUI3Tv2C8I5loNeJpfiQDTdC2ex4OzydFpypMLsuRtxPcJhrQd07uh18ZBc/DKbrfWSfB/WJaNH31ha07rtabWU9LeVEWqX02uc57VCdjqjMAtOrPlWVAIXtBEGqkpa0QXddjGBdZnMfg81ZBfc+uNLPv4wXzMOgsvAFtb0L6kLKyOI7YD6z7IRNj2pl4yikM1ClyvHl6D570B2+yGZNH0L2adi4cI72S3GyeH6/OXphBQgO9HFIMlfK3RNI6kYf2vvYo355h4lYN0cuYL8wItbeZ5kvKlIaTRIa4t1zZZKk4AKVPq9L490Bv86CXHWQF56ys0qSA8YAnZqJDqh7kaxa4BH0m0BqusPTvb+Pos9L94Y0ZwroXM9WaNcN6U663e6z3X5p4/13v4Ir79pn37zGoNAbSldsHDdcqvUS1e53WOGxsEqqVjdGFGPC07Ud2lhcvVl5v5
 F32RCCbI
 hFX4So9opH5rDSMF4Nf7WxkBewut6Y5dDhs6c3UjrHNTpLkF9kUQGe1AhjYVzqBlCqRc5xEuyqVnecnTlRrK+67AS1abnb4bLXrrdkz3yslh9lh+ixH802HAbad8B4GbgLOp0cjVPmR5nBYYkgvdNLxPrLBG+lp1L2PGWm1JCWZhmEzwMbhbQjI9uuldDxLndCq1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The kthread code was enhanced lately to provide an infrastructure which
manages the preferred affinity of unbound kthreads (node or custom
cpumask) against housekeeping constraints and CPU hotplug events.

One crucial missing piece is cpuset: when an isolated partition is
created, deleted, or its CPUs updated, all the unbound kthreads in the
top cpuset are affine to _all_ the non-isolated CPUs, possibly breaking
their preferred affinity along the way

Solve this with performing the kthreads affinity update from cpuset to
the kthreads consolidated relevant code instead so that preferred
affinities are honoured.

The dispatch of the new cpumasks to workqueues and kthreads is performed
by housekeeping, as per the nice Tejun's suggestion.

As a welcome side effect, HK_TYPE_DOMAIN then integrates both the set
from isolcpus= and cpuset isolated partitions. Housekeeping cpumasks are
now modifyable with specific synchronization. A big step toward making
nohz_full= also mutable through cpuset in the future.

Changes since v3:

- Spelling issues all over the place (Bjorn Helgaas, Simon Horman

- Comment each HK_TYPE_* (Valentin Schneider)

- Keep static branch in housekeeping_test_cpu() (Waiman Long)

- Use rcu_dereference_all_check() to also check preemption disabled
  (Chen Ridong)

- Use cpumask_size() for allocation (Waiman Long)

- Fix inverted branch on update (Phil Auld)

- Set WQ_PERCPU to memcg workqueue (Waiman Long)

- Remove linux/cpuset.h include from include/linux/sched/isolation.h
  (Waiman Long)

- Comment why unbound kthreads aren't updated on CPU online (Waiman Long)

- Remove genirq related patches (handled in another patch after discussion
  with Thomas Gleixner)

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	kthread/core-v4

HEAD: 9ba457a61e09fb17a4698879367b7e6593c256d2

Thanks,
	Frederic
---

Frederic Weisbecker (30):
      PCI: Prepare to protect against concurrent isolated cpuset change
      cpu: Revert "cpu/hotplug: Prevent self deadlock on CPU hot-unplug"
      memcg: Prepare to protect against concurrent isolated cpuset change
      mm: vmstat: Prepare to protect against concurrent isolated cpuset change
      sched/isolation: Save boot defined domain flags
      cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
      driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
      net: Keep ignoring isolated cpuset change
      block: Protect against concurrent isolated cpuset change
      cpu: Provide lockdep check for CPU hotplug lock write-held
      cpuset: Provide lockdep check for cpuset lock held
      sched/isolation: Convert housekeeping cpumasks to rcu pointers
      cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
      sched/isolation: Flush memcg workqueues on cpuset isolated partition change
      sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
      PCI: Flush PCI probe workqueue on cpuset isolated partition change
      cpuset: Propagate cpuset isolation update to workqueue through housekeeping
      cpuset: Remove cpuset_cpu_is_isolated()
      sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
      PCI: Remove superfluous HK_TYPE_WQ check
      kthread: Refine naming of affinity related fields
      kthread: Include unbound kthreads in the managed affinity list
      kthread: Include kthreadd to the managed affinity list
      kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management
      sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN
      sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN
      kthread: Honour kthreads preferred affinity after cpuset changes
      kthread: Comment on the purpose and placement of kthread_affine_node() call
      kthread: Document kthread_affine_preferred()
      doc: Add housekeeping documentation

Gabriele Monaco (1):
      cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping

 Documentation/cpu_isolation/housekeeping.rst | 111 +++++++++++++++++++
 arch/arm64/kernel/cpufeature.c               |  18 ++-
 block/blk-mq.c                               |   6 +-
 drivers/base/cpu.c                           |   2 +-
 drivers/pci/pci-driver.c                     |  71 ++++++++----
 include/linux/cpu.h                          |   4 +
 include/linux/cpuhplock.h                    |   1 +
 include/linux/cpuset.h                       |   8 +-
 include/linux/kthread.h                      |   1 +
 include/linux/memcontrol.h                   |   4 +
 include/linux/mmu_context.h                  |   2 +-
 include/linux/pci.h                          |   3 +
 include/linux/percpu-rwsem.h                 |   1 +
 include/linux/sched/isolation.h              |  16 ++-
 include/linux/vmstat.h                       |   2 +
 include/linux/workqueue.h                    |   2 +-
 init/Kconfig                                 |   1 +
 kernel/cgroup/cpuset.c                       | 134 +++++++++++++++-------
 kernel/cpu.c                                 |  42 +++----
 kernel/kthread.c                             | 160 ++++++++++++++++++---------
 kernel/sched/isolation.c                     | 138 ++++++++++++++++++-----
 kernel/sched/sched.h                         |   4 +
 kernel/workqueue.c                           |  17 +--
 mm/memcontrol.c                              |  25 ++++-
 mm/vmstat.c                                  |  15 ++-
 net/core/net-sysfs.c                         |   2 +-
 26 files changed, 596 insertions(+), 194 deletions(-)

