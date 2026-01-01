Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9B0EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569406B0088; Thu,  1 Jan 2026 17:14:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518726B0089; Thu,  1 Jan 2026 17:14:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8FB6B008A; Thu,  1 Jan 2026 17:14:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 307F46B0088
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A75C6141579
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:15 +0000 (UTC)
X-FDA: 84284799270.29.4258658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2374F40009
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r+AnEX/U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305654; a=rsa-sha256;
	cv=none;
	b=ON2RvN1K1wUThTaL75FqIwKo/A1JPP+wI/eusOTSgm8ugkhJOrpa3TUvzFLupbT9kF5EIo
	vJ6H+N+32HFRQIBnLPz+64WZ6czVYbUMcosbmHRbGVzPAxP3MyLXzzexZr30Gz+i9Y1SX/
	l/eCLMMoFiTrfKRvclCtaAgzSnNd7RQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r+AnEX/U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Is1ybNDhnjEDSsM3I0j9N19K5wdToOdUg+Lflu3Untc=;
	b=PackgHp9QNg5sfHclW8+B1q4Ge81wYtz/UmcPD7gQMWz9A/MZ/lfDvkhon6/SOpTkacT58
	IkJhqGR5YFKgvbKb183U4VHsv59gsP4RnvmOuXTWPHcBQkHfSMO+UDajxNdeN8dp0SnVoQ
	NNMJF5rM4z4P/FATJlMc3L1DktmaVQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8160F41A9B;
	Thu,  1 Jan 2026 22:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D868C4CEF7;
	Thu,  1 Jan 2026 22:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305652;
	bh=TkV0C834LNJT27mx2/Ayl0IxXi3IFIB0xDgB+kxqTGk=;
	h=From:To:Cc:Subject:Date:From;
	b=r+AnEX/Uh7pY3+P9PtZZEL/YIDn27sHbkqPtMSwNLRKHHMTms8Iih3doTf696xwnu
	 gEPlpuSiMxK4SXJxo4eSA8HJefbZZhMKsT1EF4NF5ytyce+tbp8wA33QjukE70v5oL
	 UeUMrHshVDmYFFB+rH5otwwzlN8jOnScbiMonmLog0e7JWiUXs7DCJJjEnsGDShFp7
	 T9eAqXR4tqZeHDiuR8a6MJx6IsPtATcbvcdT4Q6qbs9dBvxv5nSVFssetF1MBcynmq
	 OcDhyEwkROwIlr8GTTga8WovIiNHj94MbaZ+Yc4fvu65j6YAwxQYvgJLR/xHfZNysi
	 Tu6x4WAFW1OMA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michal Koutny <mkoutny@suse.com>,
	netdev@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-block@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Eric Dumazet <edumazet@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S . Miller" <davem@davemloft.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Simon Horman <horms@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	Jakub Kicinski <kuba@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Gabriele Monaco <gmonaco@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Will Deacon <will@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>
Subject: [PATCH 00/33 v6] cpuset/isolation: Honour kthreads preferred affinity
Date: Thu,  1 Jan 2026 23:13:25 +0100
Message-ID: <20260101221359.22298-1-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2374F40009
X-Rspamd-Server: rspam10
X-Stat-Signature: c3o61mn5mp7xuwcrsks1bqbycauhmq9p
X-HE-Tag: 1767305653-914247
X-HE-Meta: U2FsdGVkX1/WqztlCt+lSyPHtxy14xayhFRVusIWb8f55sYrvVAH6KfOciisaWWs659haPrc1KGwF43LVCQMPLt18/Ya7jEQzclaYelJpWOuTYPJOYMCliZ1CmjQFAwHgpCN/C/UBJkBnfqSpxY1VVE1Hbv1K1YxRdgoIxufrI41ElBOoCgiWOBE26ZKly+4M/deSBDibz2Nd+aZFh3mYtGxMGtkLuewyRSL6l5O2dbtCMMitFQf6VMRpqRaOol05Wxion+cP5cMzUVob6jCFyTUIyOBluVYwb0yWUK8d8Hj5psZB79c2SdzrtQnjo9IOELbw7EnUPmJ1iGa5CMDnb/ND4Vkz4QWkVix4eSY4kxzoaV2NSiFStnq/zjSmpRtFrdv8gIbISTeFGIWNp6IB9XtRT2ljR2owvyG54JA+jx091vDRb3eh4/EblbpOlUeNyhbEsrr0YK9o5taUmdpbEY3lKYRVou3Nqt5sl/DUDYVkjuTwV4Fn2/k9LuCjuiJxX4otYU5ZT28ftBZXMEyFBMpzYcKldgxZNV6jf85Dh/yyCL7XRFBqRaR8kAStdmp/ZcdkMMVMwl2F491Og8MD0TvBrtxDWQ5umAjo/5K+stLIUTEXoSpiEYYRYT57e6UipHcyW0FcnSvP8sthVnvhMfvornX4/OhMbxuqqxumYOxz/qK96YX3WBHow7wEz+Wr3JC3CiaHjjgEXSHbIcjZP6qAlOpxYZRQwx5QxN2zo4mbT6bkGnnyd8Skgij0gK9CSDUsYKIAC1g5XJ2eX/6srF6scHY+3Ft4OIH0KOGHXFFC3LuPxvC95LMVbh59bMNagawsGSgk23QhjjFTrJUcu33u+mlBEmjJbEL+ItYB59TqmH9abt2FelHdCtuZo9Bm6xHmRIgbLw=
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

Changes since v5:

* Add more tags

* Fix leaked destroy_work_on_stack() (Zhang Qiao, Waiman Long)

* Comment schedule_drain_work() synchronization requirement (Tejun)

* s/Revert of/Inverse of (Waiman Long)

* Remove housekeeping_update() needless (for now) parameter (Chen Ridong)

* Don't propagate housekeeping_update() failures beyond allocations (Waiman Long)

* Whitespace cleanup (Waiman Long)


git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	kthread/core-v6

HEAD: 811e87ca8a0a1e54eb5f23e71896cb97436cccdc

Happy new year,
	Frederic
---

Frederic Weisbecker (33):
      PCI: Prepare to protect against concurrent isolated cpuset change
      cpu: Revert "cpu/hotplug: Prevent self deadlock on CPU hot-unplug"
      memcg: Prepare to protect against concurrent isolated cpuset change
      mm: vmstat: Prepare to protect against concurrent isolated cpuset change
      sched/isolation: Save boot defined domain flags
      cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
      driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
      net: Keep ignoring isolated cpuset change
      block: Protect against concurrent isolated cpuset change
      timers/migration: Prevent from lockdep false positive warning
      cpu: Provide lockdep check for CPU hotplug lock write-held
      cpuset: Provide lockdep check for cpuset lock held
      sched/isolation: Convert housekeeping cpumasks to rcu pointers
      cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
      sched/isolation: Flush memcg workqueues on cpuset isolated partition change
      sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
      PCI: Flush PCI probe workqueue on cpuset isolated partition change
      cpuset: Propagate cpuset isolation update to workqueue through housekeeping
      cpuset: Propagate cpuset isolation update to timers through housekeeping
      timers/migration: Remove superfluous cpuset isolation test
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

 Documentation/core-api/housekeeping.rst | 111 ++++++++++++++++++++++
 Documentation/core-api/index.rst        |   1 +
 arch/arm64/kernel/cpufeature.c          |  18 +++-
 block/blk-mq.c                          |   6 +-
 drivers/base/cpu.c                      |   2 +-
 drivers/pci/pci-driver.c                |  71 ++++++++++----
 include/linux/cpu.h                     |   4 +
 include/linux/cpuhplock.h               |   1 +
 include/linux/cpuset.h                  |   8 +-
 include/linux/kthread.h                 |   1 +
 include/linux/memcontrol.h              |   4 +
 include/linux/mmu_context.h             |   2 +-
 include/linux/pci.h                     |   3 +
 include/linux/percpu-rwsem.h            |   1 +
 include/linux/sched/isolation.h         |  16 +++-
 include/linux/vmstat.h                  |   2 +
 include/linux/workqueue.h               |   2 +-
 init/Kconfig                            |   1 +
 kernel/cgroup/cpuset.c                  |  68 +++++++-------
 kernel/cpu.c                            |  42 ++++-----
 kernel/kthread.c                        | 160 +++++++++++++++++++++-----------
 kernel/sched/isolation.c                | 141 +++++++++++++++++++++++-----
 kernel/sched/sched.h                    |   4 +
 kernel/time/timer_migration.c           |  25 +++--
 kernel/workqueue.c                      |  17 ++--
 mm/memcontrol.c                         |  31 ++++++-
 mm/vmstat.c                             |  15 ++-
 net/core/net-sysfs.c                    |   2 +-
 28 files changed, 557 insertions(+), 202 deletions(-)

