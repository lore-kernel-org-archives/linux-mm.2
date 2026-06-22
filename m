Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E2FCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6934E6B008C; Mon, 22 Jun 2026 06:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BB76B0092; Mon, 22 Jun 2026 06:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A0E6B0095; Mon, 22 Jun 2026 06:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C71D6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:46:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFB0990622
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:46:40 +0000 (UTC)
X-FDA: 84907220160.08.B9BB700
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7772C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:46:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nzU+mGOE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782125198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCyqgOn/EsE21R3mLuqcUgbV6oo6AJhAXamoQT+ptD8=;
	b=MV0uFrxhhzN1rQEBgZm2tCNP/f5LBn/Kuwjyi3Bjyz1i5G6DEJIL2kHzeTUXrKNJPBrn3T
	55k1MXwSXY7yi8lp9VNUXnbQzyi+U2ylfZ234q1JdLXMyj3Eb8QhTu2p0jtu+KqPM4K4Bt
	IMqn6JCsFNZaaZgfJIMTIJB82G38GKU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nzU+mGOE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782125198;
	b=ut7v12rjsUZOXlWx+A2jm4DkCqvs02+qalDT5N1IWN1fCKdF3Gy9V5+eyyo/1bXJJUnOt5
	iYjRxYVI0dYvdAmdsx2F0Cmu0htTO4m+1Dtdo7fTaecZ+2DAFq/EhkhNiyjMOEWusKqjH9
	LS5J+heTh02nbR3SnI8L3JFvSBmxGo0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782125197; x=1813661197;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/hKgAevfumO8x7LfebeUyLh/erlFr2Hmr9kpKNVbH0Q=;
  b=nzU+mGOEqWcv1ZhOmQPh7A2Vpfo+LMNqc4tcIPxCOVAjg5E+B8987oJm
   CRk7qHz3x3v+O+oG7cXujRDkzL1gtlG6mhDITbvghfqBqcfJ18psAc+PI
   Tg6A1WV+wrBAYDeVjinRSZ8iVzEiuhmQJVGAURRe3kSmW2jMrs7sROlGE
   u8+D/V9jaSTcCF1v2EIm0ssuPCon5Qce2IQ+52WID3KKCx1hIbTl0AP50
   tBvVqFdniXMiI+R7HhzvDTzP1eZ59wlltT5mIxb+U8IVJjshC3XaerKJ+
   nuUFkH1Xgheje/msjZOEt2IJ3ymfBjkuClzZN1MPvQKC7KGcG7O1ntKDW
   A==;
X-CSE-ConnectionGUID: Vn8I+NA6SnWd3NWWL64RVQ==
X-CSE-MsgGUID: whXpijbrSnKUN0bRjtqeXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="93506240"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="93506240"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 03:46:35 -0700
X-CSE-ConnectionGUID: xNR2+KjtQLGBpSv9fyyNaQ==
X-CSE-MsgGUID: i0RzaMPlRGCEVMh1muYCuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="253099713"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.152])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 03:46:25 -0700
Date: Mon, 22 Jun 2026 13:46:22 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Paul Moore <paul@paul-moore.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Howells <dhowells@redhat.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>, audit@vger.kernel.org,
	bpf <bpf@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	"linux-perf-use." <linux-perf-users@vger.kernel.org>,
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
	kexec@lists.infradead.org, live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Power Management <linux-pm@vger.kernel.org>,
	rcu@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>, virtualization@lists.linux.dev,
	damon@lists.linux.dev, clang-built-linux <llvm@lists.linux.dev>,
	chengkaitao <chengkaitao@kylinos.cn>,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
Message-ID: <ajkSftEbdGoiJXYs@ashevche-desk.local>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
 <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: w96mbfgz7swcqnskij7gii1w9yr59f18
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A7772C0003
X-Rspam-User: 
X-HE-Tag: 1782125197-199236
X-HE-Meta: U2FsdGVkX1+aeKkOUNDbkKZYElQ1JarGNsoRpX4i3x9XerBS1tJsw/BeR3BmSOHWzYySm3CszDc7wdcV3vUHYZBdK0yIt9GnthiXgcXdcptYlht+lSrdLrvGIEXkoQfufIuTqXwLgs9ZcBb5imwjUj19z2GPOV0lI/2ujhNEmmN8iVhELZd5QLyU2wPB+pnPi1VUG7XnrmYWe0wRbLJOsqDvc8IU/F8k18fswxheU4rbKq5P+pAS5KaBJAa0RFfmUXULr1tUPrqlTkOMqa5DDiCHfpptQgjDbIoAS+GVAdtP1y0BneLI4S6xYclc8gPg6sZAT51wfyYbh3vGB7SQ95FppNgeuCXvWy7lk8PqKnVCp9F2HWjKniVibyZpVn4hwVGmbL60VAcaAA/MKgXBuLXT1VLBv64Z0vfYHKuxx6EfwZLkpGd/1OjHQZWhVPKEsGIWG63qzwkDbBpeMfk4ZDSKeS9E4rAQuQqF/huNkOlnL8gjdt2vbX75hmodEgPLkY2riKvpUnY5AmzdiZ2g50Uf3sOgMSivD/E7NL/SsH2ZS1d8AKHcqW0U/gDqhwQlyFu2SXDoL8KUdqsbf9qqy9LHCI0G5ohOuvXztBBvntc4BTTICibTcXSw1F7Mf5nK7zD8KFIGUqK+kpIfprONxNPTt4CEE3zV5Utdh+fy33CER8RudHj82pDrepg4IxZ+BnH85tfjcbwVdKfcyO+6dTrNjOzcermmhMvQJ05E/gxxNiFq7w0/c9NB81T8fdqi/fzTG2OPlLqsms9B+NHOLt5OSqi/yxzCXfiQeojqmilRckJMwmcIqwzOyKa3YrFnBJlTom9C0dr9jTt6DUzRKUL0amJ34boWGFtkm0ZwO9tdM8MR/k9gRkWqMIgbfnimjgdRsZZVTXx0YEtKliI62iamkshPsKcZCfDn90ZRE+xI0hAZKjZJ6TW2G0/f8NZKEgDuIP49/QIo30QxmCQ
 od2i1pbm
 ILIHmu5W2WZQ8SZt9B761rMh1zeifXx61iubP1GTCOWh1niw7mIezFzYq0FOWJgulc6uDBEw4HsNApUEad4IeZ0zNfEUj5F32/54N4KJqDf/98Mx1a4ESJuPOXXf20MjMjQo56y9YmxF1VxQlhS+QieEdYPtMWLKvLvo4IW/hfgcURLYDG9j+zNtb/kBJ4Or4Kq7WCI2dM16Ktdby1hV0wKpKM/xFwVvZ+pkWWacwtPU2EqQx43y4oAAXWfNlSHsjWTnJE5vMoi8wvOLVLc1DU4qbPEOeNnQeF6rKYpP3pkhfI1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 02:15:01PM +0800, Kaitao Cheng wrote:
> 在 2026/6/22 13:28, Alexei Starovoitov 写道:
> > On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

...

> >>  block/bfq-iosched.c                 |  17 +-
> >>  block/blk-cgroup.c                  |  12 +-
> >>  block/blk-flush.c                   |   4 +-
> >>  block/blk-iocost.c                  |  18 +-
> >>  block/blk-mq.c                      |   8 +-
> >>  block/blk-throttle.c                |   4 +-
> >>  block/kyber-iosched.c               |   4 +-
> >>  block/partitions/ldm.c              |   8 +-
> >>  block/sed-opal.c                    |   4 +-
> >>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
> >>  include/linux/llist.h               |  81 +++++++--
> >>  init/initramfs.c                    |   5 +-
> >>  io_uring/cancel.c                   |   6 +-
> >>  io_uring/poll.c                     |   3 +-
> >>  io_uring/rw.c                       |   4 +-
> >>  io_uring/timeout.c                  |   8 +-
> >>  io_uring/uring_cmd.c                |   3 +-
> >>  kernel/audit_tree.c                 |   4 +-
> >>  kernel/audit_watch.c                |  16 +-
> >>  kernel/auditfilter.c                |   4 +-
> >>  kernel/auditsc.c                    |   4 +-
> >>  kernel/bpf/arena.c                  |  10 +-
> >>  kernel/bpf/arraymap.c               |   8 +-
> >>  kernel/bpf/bpf_local_storage.c      |   3 +-
> >>  kernel/bpf/bpf_lru_list.c           |  25 ++-
> >>  kernel/bpf/btf.c                    |  18 +-
> >>  kernel/bpf/cgroup.c                 |   7 +-
> >>  kernel/bpf/cpumap.c                 |   4 +-
> >>  kernel/bpf/devmap.c                 |  10 +-
> >>  kernel/bpf/helpers.c                |   8 +-
> >>  kernel/bpf/local_storage.c          |   4 +-
> >>  kernel/bpf/memalloc.c               |  16 +-
> >>  kernel/bpf/offload.c                |   8 +-
> >>  kernel/bpf/states.c                 |   4 +-
> >>  kernel/bpf/stream.c                 |   4 +-
> >>  kernel/bpf/verifier.c               |   6 +-
> >>  kernel/cgroup/cgroup-v1.c           |   4 +-
> >>  kernel/cgroup/cgroup.c              |  54 +++---
> >>  kernel/cgroup/dmem.c                |  12 +-
> >>  kernel/cgroup/rdma.c                |   8 +-
> >>  kernel/events/core.c                |  44 +++--
> >>  kernel/events/uprobes.c             |  12 +-
> >>  kernel/exit.c                       |   8 +-
> >>  kernel/fail_function.c              |   4 +-
> >>  kernel/gcov/clang.c                 |   4 +-
> >>  kernel/irq_work.c                   |   4 +-
> >>  kernel/kexec_core.c                 |   4 +-
> >>  kernel/kprobes.c                    |  16 +-
> >>  kernel/livepatch/core.c             |   4 +-
> >>  kernel/livepatch/core.h             |   4 +-
> >>  kernel/liveupdate/kho_block.c       |   4 +-
> >>  kernel/liveupdate/luo_flb.c         |   4 +-
> >>  kernel/locking/rwsem.c              |   2 +-
> >>  kernel/locking/test-ww_mutex.c      |   2 +-
> >>  kernel/module/main.c                |  11 +-
> >>  kernel/padata.c                     |   4 +-
> >>  kernel/power/snapshot.c             |   8 +-
> >>  kernel/power/wakelock.c             |   4 +-
> >>  kernel/printk/printk.c              |  11 +-
> >>  kernel/ptrace.c                     |   4 +-
> >>  kernel/rcu/rcutorture.c             |   3 +-
> >>  kernel/rcu/tasks.h                  |   9 +-
> >>  kernel/rcu/tree.c                   |   6 +-
> >>  kernel/resource.c                   |   4 +-
> >>  kernel/sched/core.c                 |   4 +-
> >>  kernel/sched/ext.c                  |  22 +--
> >>  kernel/sched/fair.c                 |  28 +--
> >>  kernel/sched/topology.c             |   4 +-
> >>  kernel/sched/wait.c                 |   4 +-
> >>  kernel/seccomp.c                    |   4 +-
> >>  kernel/signal.c                     |  11 +-
> >>  kernel/smp.c                        |   4 +-
> >>  kernel/taskstats.c                  |   8 +-
> >>  kernel/time/clockevents.c           |   6 +-
> >>  kernel/time/clocksource.c           |   4 +-
> >>  kernel/time/posix-cpu-timers.c      |   4 +-
> >>  kernel/time/posix-timers.c          |   3 +-
> >>  kernel/torture.c                    |   3 +-
> >>  kernel/trace/bpf_trace.c            |   4 +-
> >>  kernel/trace/ftrace.c               |  49 +++--
> >>  kernel/trace/ring_buffer.c          |  25 ++-
> >>  kernel/trace/trace.c                |  12 +-
> >>  kernel/trace/trace_dynevent.c       |   6 +-
> >>  kernel/trace/trace_dynevent.h       |   5 +-
> >>  kernel/trace/trace_events.c         |  35 ++--
> >>  kernel/trace/trace_events_filter.c  |   4 +-
> >>  kernel/trace/trace_events_hist.c    |   8 +-
> >>  kernel/trace/trace_events_trigger.c |  17 +-
> >>  kernel/trace/trace_events_user.c    |  16 +-
> >>  kernel/trace/trace_stat.c           |   4 +-
> >>  kernel/user-return-notifier.c       |   3 +-
> >>  kernel/workqueue.c                  |  16 +-
> >>  mm/backing-dev.c                    |   8 +-
> >>  mm/balloon.c                        |   8 +-
> >>  mm/cma.c                            |   4 +-
> >>  mm/compaction.c                     |   4 +-
> >>  mm/damon/core.c                     |   4 +-
> >>  mm/damon/sysfs-schemes.c            |   4 +-
> >>  mm/dmapool.c                        |   4 +-
> >>  mm/huge_memory.c                    |   8 +-
> >>  mm/hugetlb.c                        |  56 +++---
> >>  mm/hugetlb_vmemmap.c                |  16 +-
> >>  mm/khugepaged.c                     |  14 +-
> >>  mm/kmemleak.c                       |   7 +-
> >>  mm/ksm.c                            |  25 +--
> >>  mm/list_lru.c                       |   4 +-
> >>  mm/memcontrol-v1.c                  |   8 +-
> >>  mm/memory-failure.c                 |  12 +-
> >>  mm/memory-tiers.c                   |   4 +-
> >>  mm/migrate.c                        |  23 ++-
> >>  mm/mmu_notifier.c                   |   9 +-
> >>  mm/page_alloc.c                     |   8 +-
> >>  mm/page_reporting.c                 |   2 +-
> >>  mm/percpu.c                         |  11 +-
> >>  mm/pgtable-generic.c                |   4 +-
> >>  mm/rmap.c                           |  10 +-
> >>  mm/shmem.c                          |   9 +-
> >>  mm/slab_common.c                    |  14 +-
> >>  mm/slub.c                           |  33 ++--
> >>  mm/swapfile.c                       |   4 +-
> >>  mm/userfaultfd.c                    |  12 +-
> >>  mm/vmalloc.c                        |  24 +--
> >>  mm/vmscan.c                         |   7 +-
> >>  mm/zsmalloc.c                       |   4 +-
> >>  124 files changed, 875 insertions(+), 681 deletions(-)
> > 
> > Not sure what you were thinking, but this diff stat
> > is not landable.
> 
> [PATCH v3 1/7] and [PATCH v3 2/7] contain the main logic and can
> be merged directly. They are also compatible with the old API.
> [PATCH v3 3/7] through [PATCH v3 7/7] are just simple interface
> replacements and do not change any functional logic. They can be
> left unmerged for now; individual modules can pick them up later
> if needed.
> 
> In v2, Andy Shevchenko mentioned: "If it's done by Linus himself
> during the day when he prepares -rc1, it's fine."

Yes, but you need to get his blessing first to go with this.
Have you communicated with him on this?

> Even so, the
> changes in this patch series are indeed quite large and touch
> almost every subsystem. I have only converted part of them for
> now, so I wanted to send this out first and see what people think.

That's why it's better to provide a script to convert (e.g., coccinelle)
instead of tons of patches.

-- 
With Best Regards,
Andy Shevchenko



