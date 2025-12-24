Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D38E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1F26B0005; Wed, 24 Dec 2025 08:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EE36B0088; Wed, 24 Dec 2025 08:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3708C6B008A; Wed, 24 Dec 2025 08:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25A886B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:45:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE833B72BE
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:35 +0000 (UTC)
X-FDA: 84254487030.01.187D161
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1ACCF2000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVp068q6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583934; a=rsa-sha256;
	cv=none;
	b=62V4aD6M3YT5iTwGlKZ1Q8AjGybq6N8PN6pJOxSdVcQC4Ddp8dnP4y2fxFSZ5JonJmGf20
	JzeWWTxApKDB7PfJsWCWAoBfVvL3GYo1wGKL59s5vRGh1/k5LKpNdtYUwnfr3fctsTqewD
	k3CFTEHnQ0bn1PS5Lmq930UWrlBgADI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVp068q6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iq1+jwMZ9tlCi0hkNsGw1dAsvEQiAfO+JMYot7TdvGo=;
	b=FzdW/kFHagqxjjpSZJyb9zyTMzIbKlAUDjGzZq9pX/Qr7siSfCr+ygcK+S8J7fp4+pHsfL
	pGTPyyix81Rfg1zOWPZYjoK4GOPxc35S2qnaBsE1gNgAORVEXqhq+7gilDP7hv59okmA1u
	UalGeQ1JHPxqCnh0JlCKIAFadrx5LPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BE2F4193F;
	Wed, 24 Dec 2025 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CBCC4CEFB;
	Wed, 24 Dec 2025 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583932;
	bh=tK3Yaoy6unJ5tHzgM+8i6RExHWgxXGyyr5alAshg1RU=;
	h=From:To:Cc:Subject:Date:From;
	b=uVp068q6+NoKI3AKxIIX51WZN2Jzi9fLoN+QB2SdXLQh+BvI82O1SnOAi1wUKysT8
	 2Gx+3lcLrUemOtTJfD8eE18TmmMX6fiZpABw/ahwtYlpSgDTztcpI3oTtMB4pAiqNN
	 m9kPVJBaJKsTFZhIULeXcmgaJ3C6o961eLzaKyONSEN2pM707fPKDmk4q+psrAQ1w4
	 VZ5iQe3+kpmbe/0RT5cv6YrpbsRyyUv24PXxW7FHAa1lgeGs0QXk5XeA4+7uk5NxWG
	 sViGJtbTDgVkVGUDDjT0nXcwqYbxz/XbwOshBOTOQxUIawvq7Ufnn7f1TTgRtyVqPN
	 5Z2zHqnJrj31w==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Chen Ridong <chenridong@huawei.com>,
	Michal Koutny <mkoutny@suse.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 00/33 v5] cpuset/isolation: Honour kthreads preferred affinity
Date: Wed, 24 Dec 2025 14:44:47 +0100
Message-ID: <20251224134520.33231-1-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ACCF2000B
X-Rspamd-Server: rspam10
X-Stat-Signature: drc5amttdd1sy6cp8zj5pdizra9pay4u
X-HE-Tag: 1766583933-232418
X-HE-Meta: U2FsdGVkX1+Alj90x6cFYkT6coyiHlLVTlstu+XaylrfCjsKf8E0PNUO9NcpPSqptL9yk9vikP0bwMBHkDuih+7RLwx8EK0OToEvSIwqWdKPTZhvkhND0LoUzeF69fUAJKFo5oWeS4sllziZO9LEa/RD85GTdRp0wu9wjEAHpmL/sG350n9otjlKya4CwijqTiyp9wWbnUScbdXseCMAx0lZcYAevR6wQ04VQvVMiI8dt4q6MLpvi0aFNmpKuOrWLq3R7fZ9tNZ8xwSHomhcxC219ov/NZlhGS0oaylVZqoc3VQRmwSBhnXbbZ0mK+A8wmzs3cVML+HR96RKnpCCnopnyX7b4Kp7uy6XT9gxai0Xw1GoUr/BChJUkYRo2zO5NfKlrcXfZPqdl0cnXWizSKtBXOq65mpaLfEdeJQs8QCZArwZVW1kBWjK1gUHFdiFX4duG5hunNn6OM3Stm4El7K0bm+n03/04jCubSqhbXJ7HAPgI9cY6iSs8ItKDbVUAcyVXPImbF9/TzQ8dwbR2g7Do0ViHZ5uekqegYMn2pYD8wjThKQsv2f+zmz/7QXdI96x9fPEfnZ60v+AKNkNTBN7paUthkjN9hf9535z9+bTGczFqCqxeGGFJKF/RMF8DpEDJMX3fb34fjUOvpRiFS/paWOvYewSsqrt3OKzrPfFUv0AQHpaTfl7LXMGTPk8iNIxpIFnzvIKkK4+xWXdqjbr5jbVSU9yyuCz2irocL57/10IbAddLKqO5mU4oF4eopovEMeNe6OmaCSbbovybXmN/0OfVRlfbUzziIl8n8Iq04tRxG45BcWKEFaJgXEFKpM1zPA8pUixvp+cyvWh6nTjeo4BUK7UZqw8DTe1XH51OVNMmFeUuEfO0mRY8DdieszODRMLoD93tcVJHv5eByKFOzHKXywN4IpX3PSfTsi32PUuPs5vFihr5F96a75CpW9Y7GoFnuU+T0EKP1U
 VstU6RIC
 vMVPdAjD+jQU3Wwl7N5H+Y7Mv+hEp+UkciTlW0CR/GZZWKCUF1CA1S4p9PmKyjWtuWUoWaveJZX2Kvw3X2ciVkh2Wo+mD3fp0AujMWWZdSRjstEUnSNMl1D5GDbmhu0bOMAMfCkA3DPnPZv85zZEmqqAw4S2UOYnxFRkTCSj3UAx3vjH7avCqiD71LBmtPAXKiiqA2c0RU9iee9qcRVq7J8EXLF5FR6AYhgoybs3vj535cQo=
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

Changes since v4:

* Add more tags

* Rebase on v6.19-rc2 with latest cpuset changes

* Accomodate timers migration isolation

* Rename housekeeping_update() parameter from mask to isol_mask (Chen Ridong)

* Link housekeeping documentation to core-api

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	kthread/core-v5

HEAD: 3c0ee047f05f361f215521424f5e789dfffcafc1

Merry Christmas,
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
 kernel/sched/isolation.c                | 144 +++++++++++++++++++++++-----
 kernel/sched/sched.h                    |   4 +
 kernel/time/timer_migration.c           |  25 +++--
 kernel/workqueue.c                      |  17 ++--
 mm/memcontrol.c                         |  25 ++++-
 mm/vmstat.c                             |  15 ++-
 net/core/net-sysfs.c                    |   2 +-
 28 files changed, 554 insertions(+), 202 deletions(-)

