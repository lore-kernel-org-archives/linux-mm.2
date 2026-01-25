Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061EBD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A946B0005; Sun, 25 Jan 2026 17:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A616B0089; Sun, 25 Jan 2026 17:45:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BD86B008A; Sun, 25 Jan 2026 17:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D17E66B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:45:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A8FBD32AC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:45:55 +0000 (UTC)
X-FDA: 84371970270.24.BA3DC44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 148AE8000A
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:45:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqJjGl8d;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KHDLLePAqkz6NbXL8RNmHMi3VnthXTVysTGEVg0CEEE=;
	b=6ih+MuufMrqrsatkamdX49LlqAr0mrC5CtLVrGfDudsFRR/p5a+u2zJLakzBT5dVTJwvBs
	nO6ZDwupSiBWM8Bp0eDJMVteKBvVbdktXnM+6WlfEKuVK+slw3MMFfIBcMDKteeXFV1/t4
	n5faU9BUt+9GzXYR4wmL0J6Oazmn8IE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bqJjGl8d;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381154; a=rsa-sha256;
	cv=none;
	b=5hizAfIsEeTDG9wHIG5k0YIVjzW3MMGQGQNTbg468gu5+8kHyi1DSXxZB41tU2WPDodmIU
	g3WHxdrBJYSujK62SQrZ+/F3ltz7598nzZb6gDXdZjkDLU7suPij2u3uCdUmgMsSrVhO17
	U8VmXThwhSLz7phtaVU+JOX0Ssmv7mg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10E89600C3;
	Sun, 25 Jan 2026 22:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E9CC4CEF1;
	Sun, 25 Jan 2026 22:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381152;
	bh=S9vFWXhyg0MkV+tLx10WmLW7gf6qdVccxzNBP8JiVGU=;
	h=From:To:Cc:Subject:Date:From;
	b=bqJjGl8d8RkkxkNvm/b5FIs/lRTASegJ/2eEoGWhYNy0srWYwoejNbrqxkPu2klYU
	 YVq84UWjZ3KVHkLb3wiIOu7FCgNo9VHkTwG0W5/o3u0kyD0fL7JbFhVEcrQng2LmLu
	 GVLMOXatTuZeWFep6DqNIoVnejZ4E/K2VMt5H8ZAnwsZqEtHinrP8j40M6aXuquMs/
	 N9lYLDQOFUPXs0x7iEoCWmgFUKARoa0cHptC3IKwrxOrHarVuA9cjNpuHWpvl5jM3u
	 NSMHi06NAeCcQIlPkr7hsC+VTZfuiOtGbaerDSPBNtMwoBS2MYvO7k1/vIxRHuoYi2
	 Y3KSPEiKGXnXA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	cgroups@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Will Deacon <will@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chen Ridong <chenridong@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Jens Axboe <axboe@kernel.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	linux-block@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	netdev@vger.kernel.org
Subject: [PATCH 00/33 v7] cpuset/isolation: Honour kthreads preferred affinity
Date: Sun, 25 Jan 2026 23:45:07 +0100
Message-ID: <20260125224541.50226-1-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: t6a9sscajkczxpgmy6qbxpcia44t1ebn
X-Rspam-User: 
X-Rspamd-Queue-Id: 148AE8000A
X-HE-Tag: 1769381153-954131
X-HE-Meta: U2FsdGVkX1/kjLf75usOuD1boWUEbXpaTOJ2CRQPXeVnrhy024vBhjgCIi0aNWN6+qhjSEIh+9K51OSangnVrZVypmg+ydHJyi9W8vEQHzxBXNl7S/uG2/dHIq7k/h9u0RkwPrD7XrMp550t0Zgvfc5l+TgscGzH+gmccN4t9xd7qmBZMT0wsACvvYkAAGykr0d9jvxqntjstPb6a2Ihr4XLdnSuhYpmlIXphLnTfsYL6CSGKAh/WLSuZrqO2DAyeRqsGXwhgbHeK2rKHzetPIEzafI1/vsAI+lTV+RTEWZq3b5GUh5ahuSbAVF8AMNEXSlOVbvu1Ih9lAUbxHWlAlx5S2+2fJvBsxPZTUF8j/jaluMzxvzAiZlBMJ1emJTYZ3yu+sQXQI1M7rYfRHXxOHs8c5ijAmOtkdbi1xFbSKS7H8ygewBteh883GeBZXOGR4Pf5ppybVXMRDPD6zN+twnymrtS5sgYH0CE04jtwKxyAC7aDMgpEulEnnAkFNppGpQE65uoRFugtGsZ5Pgebx91ZGJBd2eroIXwRxutS5OO2btN/cAFWHu7S3yg8VhsIHs2tuPIemFi2/dmDq67Mepcb5aDzF7DU1og+5dAQ85KoGaHgrj8SPR3GtEKXgtdUmgo8zoz0lzBAGj9wWt6Z0vFqM00ZPbEfZ3qQB+wJzSVLvcEEKKqOsh3rfiRI8TjDhQEb10LZsIblqeyjTHHNpFO0G9rG5K6rKnIW3dHtB5aJNvnRFLkhd2ROIDKof5O5vE4duAdyxH3i1ktyoZ8aWhdIeVcX0iJ8LRI3zN78+QWE74dZD5DnUcFkmomtKRy7k7T2eCaDQ1joB6pR9kHLKArTpg1VrN3SQAj+Rbup9kCT3nbpPcosaLedugWXfOGh4GuQJmtEV1CRJZnowvarhgWf29ZGaowGq00cSbC3awbTqVDZzLrW/b0SI7i21vblwMa8trg5uUaAqisHzC
 UoHnKMD6
 WDP4cscucBb9zW086FSKScxAid8ZX+jYrxhE2em/wvljSilbfpZe4uuanPCx4K6VHf40X1/VnYlYgD3STs3QAH6nxwncgn/tnQ30KoA1G51CqokdRhWDVM0PKcL29gXDRzBkk+T+wO/FnsN+B1vBFciWuI7v6MyUB0lq6fDD2BmhiiWfpld4h1aYWT2NEoPopsFeM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here is just a few changes sinces v6:

- More tags

- Fix raw access to __rcu pointer (Simon Horman, Waiman)

- Fix cpu_hotplug_lock deadlock and use correct static branch API
  (Chen Ridong)

- Fix a few changelogs that got the set rules between HK_TYPE_DOMAIN
  HL_TYPE_KERNEL_NOISE wrong.

- Simplify arm64 mismatched 32 bits support (Will Deacon)

If all goes well, my plan is to make the pull request myself for the
upcoming merge window.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	kthread/core-v7

HEAD: dcbe41f43e2cb32fbdbaf73b7745739e018b35dc

Thanks,
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

 Documentation/arch/arm64/asymmetric-32bit.rst |  12 +-
 Documentation/core-api/housekeeping.rst       | 111 ++++++++++++++++++
 Documentation/core-api/index.rst              |   1 +
 arch/arm64/kernel/cpufeature.c                |   6 +-
 block/blk-mq.c                                |   6 +-
 drivers/base/cpu.c                            |   2 +-
 drivers/pci/pci-driver.c                      |  71 +++++++++---
 include/linux/cpuhplock.h                     |   1 +
 include/linux/cpuset.h                        |   8 +-
 include/linux/kthread.h                       |   1 +
 include/linux/memcontrol.h                    |   4 +
 include/linux/mmu_context.h                   |   2 +-
 include/linux/pci.h                           |   3 +
 include/linux/percpu-rwsem.h                  |   1 +
 include/linux/sched/isolation.h               |  16 ++-
 include/linux/vmstat.h                        |   2 +
 include/linux/workqueue.h                     |   2 +-
 init/Kconfig                                  |   1 +
 kernel/cgroup/cpuset.c                        |  53 +++------
 kernel/cpu.c                                  |  42 +++----
 kernel/kthread.c                              | 160 +++++++++++++++++---------
 kernel/sched/isolation.c                      | 145 ++++++++++++++++++-----
 kernel/sched/sched.h                          |   4 +
 kernel/time/timer_migration.c                 |  25 ++--
 kernel/workqueue.c                            |  17 +--
 mm/memcontrol.c                               |  31 ++++-
 mm/vmstat.c                                   |  15 ++-
 net/core/net-sysfs.c                          |   2 +-
 28 files changed, 538 insertions(+), 206 deletions(-)

