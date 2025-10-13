Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EFFCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FD88E0049; Mon, 13 Oct 2025 16:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7B78E0036; Mon, 13 Oct 2025 16:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE318E0049; Mon, 13 Oct 2025 16:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7AE8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AE3013B619
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:01 +0000 (UTC)
X-FDA: 83994237642.11.7BDFD34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BDE738000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:31:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBF2yNcU;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nDleYTDsTpmd/c215HAnx8R/DyyOeWflleynV7veSrk=;
	b=UENp7jJZMh6dxxITYfMo+r/lLjc2nBP912VmZ2XrInmo1JXi/NV6sVeSB19lAcJH9Dp1WZ
	v1PJtRBPdgloRUGOBF+8Nm59S1/Ui3zhTeZtvU75SSRJzL+o06+tsN2jtuYVeKkMcy+412
	8BC2mD4BKXjoA9TNcKDcQUMcES0oWG8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBF2yNcU;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387519; a=rsa-sha256;
	cv=none;
	b=o4ZHAHdQ3hIdqy+i7SxovQlsGA/sJw+rtXsH09rbHZQY1+cNZsELXmQ8ADsb9/9ykuSe2D
	i/cgH5c6Vzo16hxIFnaPIQN7UKpyGpJLyQVFyRGXei5maq0qB94qdsNr//IqjvIgGnmyv1
	t5FjgAbUJOeCKitHxvzKRLo2W4vqabs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F26D5602DC;
	Mon, 13 Oct 2025 20:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EEFC4CEE7;
	Mon, 13 Oct 2025 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387518;
	bh=ysWVB1PH5yXaIm1/mguGEwYLxAYgw7ocXVK3fheEVQI=;
	h=From:To:Cc:Subject:Date:From;
	b=LBF2yNcUR6yjfrW50PCgHGc8AHAvBLQ9lrvJqA2WCQ37FrvKozfK4ptrCYuj1AVqK
	 z6xLAVCLuoIDZvrgr+0C+SCMd8qYe8A7C/Cf3X++Q67H89ylB379pqJbdfHeMTCE1N
	 KZf/I96mcxhrmHyctiuPatpj08zxohCD7+/aastyPBh1gSgRXhWXSZIaTY86mC93OK
	 KUAndnd+7NuK52jdhGUE2upP207tMgConuEtCVlypo9CFV2FAxTXtjRHDRb3FjhLQX
	 nDcM2xCjsiQV94+ABdYO/QPLEZKj8pdbSvjFzcU+/jqMNtaEDRurospUsKN1F/Xx3H
	 tw5a0zfkpfrcg==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Koutny <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Phil Auld <pauld@redhat.com>,
	linux-pci@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Will Deacon <will@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	linux-mm@kvack.org,
	Gabriele Monaco <gmonaco@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 00/33 v3] cpuset/isolation: Honour kthreads preferred affinity
Date: Mon, 13 Oct 2025 22:31:13 +0200
Message-ID: <20251013203146.10162-1-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDE738000F
X-Stat-Signature: 6tydu7bqqwrrq685nz8ka36nbf3omhsc
X-Rspam-User: 
X-HE-Tag: 1760387519-825833
X-HE-Meta: U2FsdGVkX18qRfjVfQiI7jutYpTn0/jzXlbsPr8rBa1pajjzKCd+0iAst7VZdy/5D/XZE55tJ5EmBE+byOpVYQ/Mll8IvbwvH/XUkFydxKnLlxwRF92Hj/19SxJOPGiQzDaEFU0uRnCoZC/sRMsAd40ZavYX9r+AknwtUxxNZygyVuzRbGZrjMCr+L+Myevnfm7W8vqlugwqeviDigT8Eqs0uVuKENZmRrcXFtDPDKWO+NMiu8qvBubTffmti+0rTQMHkAV7PDElMDyqMAtf7/1IIyeXiB9SXCD7QqDk9Q6gaj8jP6LFCD75N+5had0bZRVpAvE92Ji0Te2MmjDjibvJ4RgMfih1qBHw1h3yprbCX5H7+4rCbWZb46W2uwb7oG6L7KcktbOo6yv+hP2nC4lSbe+0GcUDaom9W3D412T7Ra1Coe2Cd/JVbXTmWJuY7c1VSyEomV9QXEWAC3vIiWATq/PfP5m82OICgiwRHoFhOsjXRqlz0+bN9rbUjthn8k0Ha3zM5ygmPRvIgdHQhlcXNZCpJaliPhphp73TKJugjBN3EsNnWED+iiNwhmheJnTpMOJ1gw2nkmFmRLhugV8MXowfdxWq2YnpEenOiLztm8tGkOlRCQw8U9PFR5xNS65VlpfA6AIlctfqcTNVxna3tIokNxJ6bcGuVBkNohbtcHP5ZGwUT79XhjY829HtXLqKTfADVca1NciLhX7L8SENcD6SPWdikSgRgWsuMw4FVT0B+FFHG2btfHLn9uLUESQuLAvh1lv0I3opGizd1q7hlZAJigcYk22+OwZVe3+vjV5EN6NsfsL4byZs3DG+yC2kvkvxqF2fpD5IsBg6ikT4TD81/FOxLf4cWRN6CSQZTjp10lQaR+GX8gSVjLraDUlBey2j+T920b15kXcOTI4VH029tlEpsCjx/QyuF+zoP+Yzf347sD0MdAYIfyksxUcYQ7C/i9tvlq8aJFL
 mzULTl7x
 56Y7otL6SIYgBDqYxElmA4wlwtjW+GwmtQvk6F8u55+68SCy4OPSd3wIsPCZx4wl5E7h173K+sWE8MTd5xTLpEiBrWmklTTnzkgN3Tf6My1fKy5ttR/H+g5qKnrxT/Qi8QES9NRNc9zDwgLQLpmYlsuz/TYgTmJeuTNpF1y9QcacDODeyk0XvPgKVPnLzQH8M0+mb
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

Changes since v2:

* Keep static key (peterz)

* Handle PCI work flush

* Comment why RCU is held until PCI work is queued (Waiman)

* Add new tags

* Add CONFIG_LOCKDEP ifdeffery (Waiman)

* Rename workqueue_unbound_exclude_cpumask() to workqueue_unbound_housekeeping_update()
  and invert the parameter (Waiman)
  
* Fix a few changelogs that used to mention that HK_TYPE_KERNEL_NOISE
  must depend on HK_TYPE_DOMAIN. It's strongly advised but not mandatory (Waiman)
  
* Cherry-pick latest version of "cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping"
  (Waiman and Gabriele)

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	kthread/core-v3

HEAD: 4ba707cdced479592e9f461e1944b7fa6f75910f

Thanks,
	Frederic
---

Frederic Weisbecker (32):
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
      kthread: Add API to update preferred affinity on kthread runtime
      kthread: Document kthread_affine_preferred()
      genirq: Correctly handle preferred kthreads affinity
      doc: Add housekeeping documentation

Gabriele Monaco (1):
      cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping

 Documentation/cpu_isolation/housekeeping.rst | 111 +++++++++++++++
 arch/arm64/kernel/cpufeature.c               |  18 ++-
 block/blk-mq.c                               |   6 +-
 drivers/base/cpu.c                           |   2 +-
 drivers/pci/pci-driver.c                     |  71 +++++++---
 include/linux/cpu.h                          |   4 +
 include/linux/cpuhplock.h                    |   1 +
 include/linux/cpuset.h                       |   8 +-
 include/linux/kthread.h                      |   2 +
 include/linux/memcontrol.h                   |   4 +
 include/linux/mmu_context.h                  |   2 +-
 include/linux/pci.h                          |   3 +
 include/linux/percpu-rwsem.h                 |   1 +
 include/linux/sched/isolation.h              |   7 +-
 include/linux/vmstat.h                       |   2 +
 include/linux/workqueue.h                    |   2 +-
 init/Kconfig                                 |   1 +
 kernel/cgroup/cpuset.c                       | 134 +++++++++++++-----
 kernel/cpu.c                                 |  42 +++---
 kernel/irq/manage.c                          |  47 ++++---
 kernel/kthread.c                             | 195 +++++++++++++++++++--------
 kernel/sched/isolation.c                     | 137 +++++++++++++++----
 kernel/sched/sched.h                         |   4 +
 kernel/workqueue.c                           |  17 ++-
 mm/memcontrol.c                              |  25 +++-
 mm/vmstat.c                                  |  15 ++-
 net/core/net-sysfs.c                         |   2 +-
 27 files changed, 647 insertions(+), 216 deletions(-)

