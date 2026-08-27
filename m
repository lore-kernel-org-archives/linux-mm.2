Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0B3C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC5E6B0088; Thu, 27 Aug 2026 19:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D016B008A; Thu, 27 Aug 2026 19:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BA36B008C; Thu, 27 Aug 2026 19:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68DC46B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B07380210
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:19 +0000 (UTC)
X-FDA: 85148647878.14.172843B
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id B13FF100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dRSBBvhX;
	spf=pass (imf05.hostedemail.com: domain of 3xMiQaggKCPMnoZqZinYbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--stevensd.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3xMiQaggKCPMnoZqZinYbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873477;
	b=ZAdgg8zbxZv3aN4fB+nkaMySsvv8lj8OkFHhWZp5NWvZ9D8Ie/ljQUPGXhvXPcqh7QjRp+
	Ty1Q92bwKp0QVyHz+RrMeFxq+0zG/h5qAvhJeL7zB54IYdsyAwQuvVYxzuHL/EWCmO8aCH
	XCmDJD1/eZVVDvotcN9nEVeUMtPfuEU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dRSBBvhX;
	spf=pass (imf05.hostedemail.com: domain of 3xMiQaggKCPMnoZqZinYbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--stevensd.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3xMiQaggKCPMnoZqZinYbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ByhfPFFYRyQOKzwOCdD7VT4FkrQ9JW/PGTIdcjTJE7E=;
	b=5WGWlHzCuUS6D2NkvqxhOhR/4YiGT9QyoCvlw5UoNhYQ2seKq+ySE3hFeANn/ivtPBSghE
	ym7Z3VLU4WNq3JcpbIMsoXNLft7RVFu6Qz2r8a32VuifhjYhrh/gg+F6tN4iRtFUCbEZfH
	LrSK7f46/EMBVFIF+Hfi+EY+kBtnW6Q=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf1c86963bso18305855ad.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873476; x=1788478276; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ByhfPFFYRyQOKzwOCdD7VT4FkrQ9JW/PGTIdcjTJE7E=;
        b=dRSBBvhXfMlHTyOigZrK2lrsF4Cx81jlwi1QcN3A8xM5bZBAoza7/TVqKF/ED0ZC4+
         nP8+7o8/j5nLaZuGgB0EK+7rhsVsNiSpOXtxosy2qME6ofHgc49XrukCF7jY7L8y+W1O
         G4Gf9k0mCfdgk43hNk+xwf7XsNXAHe4oZ/BhPngCdbgd1+Le6IISquQpi2Vaucb60fZi
         9DEOqFRYdk11d+kbTy64Rr0fiiNA6gur6P0J/xCGjMyGAsCxe5O9Kpc76LaD1RwnUa2p
         BTbmFtPEYIzidFPEJUA3EBRDC69kuLHoP45Y2Bh9eOPs2xJMAFwuD2tST5Jb48gIyd4n
         GCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873476; x=1788478276;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ByhfPFFYRyQOKzwOCdD7VT4FkrQ9JW/PGTIdcjTJE7E=;
        b=D99oDzB+vksaz1IWZ9ErCS6duIFMhAvaHEWbu63aevIly2TkGNn/vodf9aaep4dNN+
         Cnu9UK6WgJWC+iGNMYwMOeymkSjgOtCK7ITLNAX+rlqg+0DNmXB1+rPBikqwuuCzAqHg
         iOoyO789AoROyz8KcFdee32e7wf6d4Ne9LDjdamd0t2tKoo/KLchh3TQfEbMmo+MgWuw
         OERF673Y1erRek7hPdqcdOFWkftXRMn0HBUAQOgYQ0wKUQCWzDYiJ0BKRZoiuXCM1UfH
         fPJDgWBKjZZLqWTpfuQoYXdZsDtTrhmhbm4W3ATdJKiXxDqn25IxC892a7/YM2t8Pnto
         rbvw==
X-Forwarded-Encrypted: i=1; AHgh+RrhKziNls1ROLVBDXVqs9ccWVATzburzEq251cehPuNUDzay61re6qi49b086UAYYVQ0qQShOT+ow==@kvack.org
X-Gm-Message-State: AFuF++mNRcfHzOGfjy3b4al+fGiEfu33qfbEctCNvF/zZdrGPn8A3WaJ
	pHnUMDzDwvg/vBrJRaJ8aG4nrMVcPajUQmQcYw2TRJAGzvlDkGRSCg1umra4jHq8fueSFkEfhOp
	WN6lp1gCA4lnriw==
X-Received: from dybnj45.prod.google.com ([2002:a05:7300:d0ad:b0:322:61cd:851e])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ebc4:b0:2d6:f80c:6ff1 with SMTP id d9443c01a7336-2d726784320mr120542355ad.9.1787873476188;
 Thu, 27 Aug 2026 16:31:16 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-1-stevensd@google.com>
Subject: [RFC 00/10] Reclaimable kernel stacks
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B13FF100003
X-Stat-Signature: 9ra3aq6m4899c48nefe7stny7yw3i8yi
X-Rspam-User: 
X-HE-Tag: 1787873477-542184
X-HE-Meta: U2FsdGVkX1+Wg5MS62o3S0XpnZcWh3Cuvvqi70n4vK/WYhHlV4u5FAnr0Ow8KV+cp+hNpEszyBHK7YXtofBbP89nnpt24RhALZhtQdOqPMCz28V4P+4FjpauybiwJJ5LKHZ1GVDE7QD3TJncU1+48NnTozw5+UvYdb38+pbudnQ0qUle9uNY9PSaDyKJ7OZ0HjiNt8FvjgQJzOujBwCHVpCp/ZXcZJEL3itr+HKVEeHbL5gzv55ZZPKYHiKgpsANOKSh9ZUbaaTg8iBu4TjSXuBVpCOi3ZbxKvqaP1tX2V7PYWgfl+d/+KH4JS+GrAldsm9kEkBdiO4wvhvslGeqo8yQmWyor0qoyeplwT0vJe1/e6ww41jmua71N+mRVMST8tHodgEA8c+CVQiKVeLSAa95pVkGL0ldIHo4J1BV/xuFy73wTUhJWvCMb5mt6W/Gl4xnYPUY7/aeW41xlBLSaXBKd5TdWpqzcOI7iy4Xi77nIEoG8Icy/JEC6FRBTA3WcHuwNqKzvYYW16UnjJ9TK7A9CaKm8XJChdx8QPfWXoVYNGCXukaZlxRbxIBiO3bNk0Vv2ssymegN183OGq12am3PWoEBtU0bSDQBm98lfwJhfZa3fI52RXFLbGjVqPkFtn1BLvqhQyc22qR8WfHVSuZFFsZq2bL5VPhZ8kahL84iN5NSRdvwOSfhibBwfkQmEKu/pJ6+QQ2/4uScWz2sc89JeKaDOiGiGBUZQTDqESrRJ5bEAjk5liYh5BS5VNqB0wHJCxcXNtlo3xvGGvL8hlsrOkTaOsrN80Y12U6RAIUP16KPL0aa1te/joL6F8F0XXzxYKSLir5wICqpSEHOaERPe9A+YqIga/Xq6H30K+I7YmV3ayzzPymrdLzywWFJVVbUih/ye5DQq43yx8gFw4/j2zUuER6HRDMimyUpx2MfdmH2WqOv2lj8rXRiSvTQ04wDnsVkaANTPKfbFuC
 gUnWfuSB
 D1Y0D1vSNHdpRMwtSXhB+n86czarrvIjUHJi3I0lRlvD4nRN/RcapfEXzV/kHOvzOd+O3ZWAMZJ/yfi9wB3ZFHJpYdOI5nMaanoPHsW2mG/x/bhLdvxXnar2WN4LBuxhzPyK6/IlWk7SIPbfU0SXBDRazj7x1GRV3nH5FiEINSPTt0PUusKnXflraXQLOb+c7L4PoLQzfPrRo7s1i5vj5jK3LZtiOWUkQSl4d4GIC+Uww56Cbscqi4lZPVnAzlvJW2Xz8bJm9GSJp3D95UesjZQtzUJv78INxpVbAC7CuQ7AGPXTCPXGWxc+ToQyvymkkIcTcR3Td//C8jMRZ4XT6n9+IvQpYV4GNVqfsnTcFz2JNUdnW6ezavNoe6QMG/QMe9Uc+76YzWtSktf6e3ezWDNzvviUZqEeLKFVnLK/IpVw7AWgxalUZ6+08fTFROQ4FDVBDU/PgGXPccgGJCn2zxpCCeOlZ4ShGjoc48wWel9H4TdKs7jwKaCdleRtBmrr5z9wi7uXTgXhv1qHw0fVePuiK2Pvy10xkgD0t9X49NsfhNqWeT5xl/ZFcaD9/GhT1Pc5MWS8Z+C5jfk9vRZOGGt4JO7oJ5HXzicuGQUK6GkNGs4MqURe1CskAyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC is a different approach to reducing kernel stack usage from the
earlier dynamic kernel stack RFC [1]. This patch series aims to reduce
the cost of kernel stacks by partially reclaiming stacks of blocked
tasks when it is safe to do so.

On Android, system processes typically have 2000-3000 threads. App
processes add 1000s more threads on top of this. The number of app
processes varies based on device RAM size, but the end result is that
1-2% of system RAM is consumed by kernel stacks. However, most of these
threads spend extended periods of time blocked. As such, reclaiming
blocked kernel stacks can reduce total kernel stack memory usage by
upwards of 50% in various multi-tasking test cases.

When a task is blocked, we know exactly where the top of its stack is
and can reclaim any pages past that point. Since any accesses to that
portion of the stack are bugs like use-after-return or buffer overflow,
turning those invalid accesses into hard crashes could even be
considered a positive.

Tracking blocked state and when it is safe to reclaim a stack is done
via a series of hooks in the scheduler. The actual reclaim of stacks is
done asynchronously in a shrinker.

Once a task's stack has been reclaimed, it cannot be rescheduled until
its stack is repopulated. Although there can be a repopulation fast path
within the scheduler, reliably allocating memory to repopulate the stack
requires a fallback path that defers the repopulation and wakeup to a
workqueue context that can use GFP_KERNEL.

The primary challenge is avoiding reclaim deadlocks. If a task blocks
while holding a lock used by direct reclaim and then has its stack
reclaimed, using GFP_KERNEL to reallocate its stack risks deadlock. To
avoid this, only tasks which are known not to hold any locks upon which
reclaim depends are considered eligible for stack reclaim. Automatically
inferring this property is not feasible, so instead a new
PF_RECLAIMABLE_STACK task flag is used to annotate blocking locations
that are known safe. While annotating all safe blocking locations is not
feasible, the vast majority of userspace threads block using a fairly
small number of syscalls - futex, epoll, nanosleep, etc. The 10
annotations added in this series cover >95% of userspace threads on
Android based on my testing. Since missing annotations are leaving an
optimization on the table rather than an actual bug, other annotations
can be added later as needed.

Although reclaimable stacks will not cause reclaim to deadlock, it does
introduce a dependency on needing to allocate memory before an OOM
victim can exit, as reclaimed stacks need to be repopulated before their
tasks can run. While the OOM reaper will still be able to immediately
free the victim's mm, the freeing of non-mm memory may be delayed. This
can lead to more OOM kills. While this is not a significant concern on
Android due to the reliance on lmkd over the kernel OOM killer, it may
be a concern on other systems.

This RFC was developed primarily on 6.18 and 7.1 based kernels. I have
done fairly heavy stress testing, but it has not yet been deployed to
any production systems. If initial feedback on the RFC is somewhat
positive, I will work on deploying it to production systems for further
stability and performance testing as well as resolving the handful of
TODOs left in the RFC.

[1] https://lore.kernel.org/linux-mm/20260424191456.2679717-1-stevensd@google.com/

David Stevens (10):
  Add !MEMCG memcg_list_lru_alloc implementation
  mm/vmalloc: Skip vmallocinfo NUMA stats for VM_SPARSE
  fork: refactor vmap stack alloc/free into helpers
  mm: vmalloc: support creating aligned vm areas
  fork: allocate reclaimable stacks with VM_SPARSE
  Reclaim memory from blocked kernel stacks
  Reclaim stacks via a shrinker
  Set PF_RECLAIMABLE_STACK in various places
  x86: Enable reclaimable stacks
  arm64: Enable reclaimable stacks

 arch/Kconfig                       |  18 +
 arch/arm64/Kconfig                 |   1 +
 arch/arm64/include/asm/processor.h |   5 +
 arch/x86/Kconfig                   |   1 +
 arch/x86/include/asm/processor.h   |   5 +
 drivers/android/binder/thread.rs   |  14 +
 fs/eventpoll.c                     |   3 +
 fs/pipe.c                          |  28 +-
 fs/select.c                        |   3 +
 include/linux/list_lru.h           |   7 +-
 include/linux/sched.h              |  44 +-
 include/linux/sched/task_stack.h   |  23 +
 include/linux/vmalloc.h            |   2 +
 kernel/Makefile                    |   2 +
 kernel/fork.c                      | 140 +++++-
 kernel/futex/waitwake.c            |   3 +
 kernel/sched/core.c                |  18 +-
 kernel/sched/sched.h               |   3 +
 kernel/signal.c                    |  36 +-
 kernel/stack_shrinker.c            | 760 +++++++++++++++++++++++++++++
 kernel/stack_shrinker.h            |  58 +++
 kernel/time/hrtimer.c              |   3 +
 mm/vmalloc.c                       |  27 +-
 rust/kernel/task.rs                |  16 +
 24 files changed, 1175 insertions(+), 45 deletions(-)
 create mode 100644 kernel/stack_shrinker.c
 create mode 100644 kernel/stack_shrinker.h


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0.897.gb25b4bd76c-goog


