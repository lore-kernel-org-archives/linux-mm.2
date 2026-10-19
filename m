Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC0ECCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7316B00BD; Sun, 18 Oct 2026 21:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8456B00BE; Sun, 18 Oct 2026 21:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397B06B00BF; Sun, 18 Oct 2026 21:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1BA6B00BD
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:14:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98E501C3CF8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:54 +0000 (UTC)
X-FDA: 85337606508.15.A13D774
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC48F1C0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SwAzCgwI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372493;
	b=krJnZNyjI9jU+TP/Gaho/F4XK7Hhat4FVqzEoi1gZgnEcxKNaWkWq6VQshRBBU+ziGIu29
	rhB7k12YOeLhQ+W7yXmCjQGDDk+BeZdaETkORfgfvNy0moKQjkYhA1APYkHZBmdVI1/zNw
	DN2znzlwI5xOxon/3n+Fd3psg7yHXhM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SwAzCgwI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J29y68RABBwtPItFwE/Tw/yYInAbTL5GAQo5LD76s4c=;
	b=6froE0nkLSymzMvHqHBZ8LO5esxQ/R1QwX+vPuJ8Fw5HhwYHzmb4eRR11hKdCrb4BzD/4L
	hXEnegfhpJFyWVxbCZ5LKaDX+wI9+EiG6//vH5SIXbhOs0Klj5U+xXMl+adNgm6iwddZJ0
	sC8UxjfWkRH7i48WrXaja4zEdf5jG+Y=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so1238216e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372492; x=1792977292; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J29y68RABBwtPItFwE/Tw/yYInAbTL5GAQo5LD76s4c=;
        b=SwAzCgwIJOCUTTG/rLbZZmNe+FTZOVa/xix1l1c95FPk/6Z75Usa6pXCpnFx2Nc6Rl
         ChVH2ayFHSe0mgai16Ijie5UqNyYVA/H+z0VGLAgBtUUQOoo6BHNV6Msv0ak00ZvlqDm
         h/IkpypbSz9yyumYdUM/MU+F8FKT0weX0oOROE1/AGS8vQIASvek7dAy00QeCmh60psm
         6zRl1EdPHTmRedijPWMkF85tkbaQO5BqeI08pjOvxw+PNUNUyup24cQvM5uFc/5qc5Rf
         RPfZCfQ7Vm1fmvIUa4VFUTjKKYwJXItpjip+lGqyn3dtCWVLgnNnVgmqAZkMs0qb/lXR
         p7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372492; x=1792977292;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J29y68RABBwtPItFwE/Tw/yYInAbTL5GAQo5LD76s4c=;
        b=rNZ3r52BdPJ5o9tVK8bY97DS8XMdtgxVTcD/Wu/wgdg9J/k5/khu4rB0L+XQEQRSTP
         arRayE9RlUSRfCa0pwVVRZsjUYg12VJc88kItWXOmDwXgRDZfFqRE+r5LBC1amaAhcYE
         I6nAWKry51uwUDV7sFdH+i/p2/CWEU5a4P+JOyPpMXGCMymS2vQmGTcY6t4PzeXqHbM0
         lkE+eu9ChrsWGoxVnkozeutDbGKJUfBweumJPXLMkNFNVklgQJ2o8ZPz6LI2xkMFYMMu
         4VaZy0umuF0j2NZXQR0zT1kQ6DeJaVDk/EdO0Jq9qObfWv2jiIUMGYrEkshRfCYcVHOf
         oZMw==
X-Forwarded-Encrypted: i=1; AKwUvBxc4Yh25W9XP9c7H7sXto1CjsOg/HZC8ZvZy7kcqtsAJ1Jear5fkQlLJTLi56Hnds1pI8N/PZcnsw==@kvack.org
X-Gm-Message-State: AFq9FYIJM9KgFYMpCv2vLxz05pBVnuKvoSxbFTJBi1+Nts/x3F26eAEZ
	W4pUqlYkzqC+YLUhus8yVrITZJN2uNpwaYmPrB5M5051B1k/ixVG1mSRe4LM689M71s=
X-Gm-Gg: AYBFou3X2EfwQge02UWuUkTtAgZJQtuRQMurSotbkbMczgH0+pnb+4CpTLFvSL4nqEW
	9OD72NCjjKluzZJ6BZyJSckNJKglBZNAVJt+cR97skgPR4CpoU7PbPY3eams/r+LjcgfrTx6LvG
	vVn1GKx6cMOJ02N7x9WUWlT8OkYhs9L95z5XgyPK3O8bdbz453QBD4txUq+9RF4SMCTjuP32kig
	zVhYnzB1t05a17/08jzj5o7Hbtf+c9f/a6bDZzEPx9qfTRgEjP4rQvO2U43bbwtE895+Rn6qpJ+
	f7GmIou+uiCIwAUpnU3wuxA9bP/UCeFQeR9OBwNJW1hjMq1o+Gdm7ypFwcPo2pYqt3JOo1PPx4+
	XAJP45f441+vdP0BPU44Mk2xqlMUpv69XLvTtYh18ki18qzsiLpKDNM6txYmuNeC+mLvHi/QmWQ
	rwkghtiDmcOGK36z55SiWxszCy5FJTrAgoYFpT944baiWD9PL/4Udh9pneqEhCDRSt7ah6z2sNv
	ObarPyx+ulh0KinX7P3I10feH6AgvqnXpGm37mmr5lsJr81qOrGG9EfLGCXxbWfapBZg69C2wfF
	id1mBbqpKjpGxTfnXTk=
X-Received: by 2002:a05:6122:6d10:b0:5cd:575f:9396 with SMTP id 71dfb90a1353d-5eaaa51809bmr2046551e0c.12.1792372491910;
        Sun, 18 Oct 2026 18:14:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:50 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large systems
Date: Sun, 18 Oct 2026 21:14:38 -0400
Message-ID: <20261019011446.834487-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: EC48F1C0005
X-Stat-Signature: 6apx856ehp3kkmw7shficawftqunmsx4
X-HE-Tag: 1792372492-445159
X-HE-Meta: U2FsdGVkX18FqXJfOEQaB8T3AC2jZ+ejdg6jgZWiC6KbC7kDBhFK/FH2fzYoXu1CnyTp3ntLXtUmvNAZMNFGfq7cQlooUcr2DKO6LXUKXA2vns2qVvsHr32ZaipQgIEv9oIaVm+Ocvs2N5QWfBNDWq0mN4O4u3YyYKAxmuE1bsf2/9YV9JpWDAYj0trNOamUm7DsWwq4WQb5SrvIH0yFC9bpLS9IHbZaJkeqeBw97nqXnIQ+hfbBkZGA8v+vpkuzU3fbi1SriUJ2zfsp1+TujxLcxX0LUo9p/4IINqBcGydrL+izmRg4sGctxKy5aUZpE4uTweR8aIYDqdxdXEsjEdnUlBeuEZZntUr+FY20RqES9SXUtg7/1jRob1wXNwwq0pbu0A0Y6oiqQ4oouzQ9JeAnLwdMa/oIBUvH5XC1rkISpiAtqBu+25tWu+WISQIAcWJXIkMbyXbpfAa7RHa8iOHwDgmlLvyvJkQ6ZgJBIqmjfHTiWkYpsRXfu/boMWVZ+8CCLGHuV+cy95g5tUEOF+rRAp734nk1J2MUAaryBthiXVgeH+7yoZgNHceq5I+dcUEsvfpQ/Vy+ep6+n9ZKxlL3F7PgCvbHv6lDRDv7hNvZzzhCSL1GrtVyU7zjRjjLWa0zHPFbZKqCmI9H2flo476bVspQeJALTUVZ4jGuPZvlqrbzlIt4oWp6NU7AFqdzuYwkzAX8gtJXcbARY/q3OtWqzoxk+ryNUXfgfSjL6nCB9jx5GBCskR5zzwd7aPnYJ5k0QRdAGLytsLIpaBU20KVl6n+i2O/qaQTaGApGbwSPa8kV7K3F3J5U/Fn6a85rA6nF/wC9pYkYErUcfQogJOQ4A987LtNvrzmpp34pXX5DzkQ5e5w3v8U/NuoGvvoVqRSqJOM2tBeisvr/AyDvLj9sbNo0tzuptB7TatC0DYv/B+dR2yDtChC8ANv2GzyyiYVm2pjG5YcPNdJSna8
 L+To+p8l
 7dsVRTbfc6AFeHUanxDiHgIbDxK4vGijWjXbh5lj1jsI+mX3TyC6cirP7cveczvFadqDN9wk0MKeE4OczbPPI2pEcBRi7P5tYyV8zPm1MLASfWRGRSP/pILj801IJlkt1Iqboa+p5omSHFec/8w3CSMvlYpGaHyEE6xi5SNOx4AcrT85XKYNeGNtd4JKjA8GGxF1WpahC89zdLlYX00lGx+fixifs3DEkdtKhLiJlJ+Fnj4zKCvp1HeOhwrWKJ/JdPn0UpCt1QJY1ixIWMa+fjzC/Wgakkq+CiCX6LkyK5sE3xlM2BdxvDuOZqnlA3Z9yDMFs9ek3L3tnG64rkseHD/HhltJ3Gd7GbMk6Wgybnp+hNkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For live update we require a fast CPU online and offline capability.
However, sequentially offlining and onlining all application processors
on modern high-core-count x86 servers exposes a series of hardware and
algorithmic bottlenecks across arch/x86, the scheduler topology builder,
deadline bandwidth accounting, and vmstat.

This series addresses these bottlenecks, reducing the time to offline and
online all AP CPUs by 95.2% (21.0x faster) on a 2-socket, 480-CPU Intel
Xeon 6985P-C and by 59.8% (2.5x faster) on a 2-socket, 512-CPU AMD EPYC
9B45.

Benchmark workload (mean of 10 runs per step):

  # echo 1 > /sys/kernel/rcu_expedited
  # for i in {1..N}; do echo 0 > /sys/devices/system/cpu/cpu$i/online; done
  # for i in {1..N}; do echo 1 > /sys/devices/system/cpu/cpu$i/online; done
  # echo 0 > /sys/kernel/rcu_expedited

  2-socket, 480-CPU Intel Xeon 6985P-C (N=479):
    Offline:  40.40 s ->  3.09 s  (-92.4%, 13.1x faster)
    Online:   65.83 s ->  1.98 s  (-97.0%, 33.2x faster)
    Total:   106.23 s ->  5.07 s  (-95.2%, 21.0x faster)

  2-socket, 512-CPU AMD EPYC 9B45 (N=511):
    Offline:   4.53 s ->  2.30 s  (-49.2%,  2.0x faster)
    Online:    3.88 s ->  1.08 s  (-72.2%,  3.6x faster)
    Total:     8.41 s ->  3.38 s  (-59.8%,  2.5x faster)

  (On AMD EPYC 9B45, each 8-core CCD has a 32 MB L3 where WBINVD takes
   < 0.5 ms, offline uses acpi_idle rather than mwait_play_dead(), and
   Intel CMCI is unused, so Patches 1-3 do not affect AMD, which enters
   Patch 4 at 4.53 s offline / 3.92 s online / 8.45 s total. Without
   rcu_expedited=1, final 10-run mean total time with all 8 patches
   applied is 12.04 s on Intel and 15.99 s on AMD.)

1. x86 WBINVD, CMCI rediscovery, and MTRR rendezvous (Patches 1-4):

   On processors with large shared last-level caches (such as the 504 MB
   L3 per socket on Xeon 6985P-C), CPU hotplug is initially dominated by
   full coherence-domain cache flushes (WBINVD), each taking ~85-115 ms
   per CPU while stalling active cores:

   - Patch 1 removes the obsolete WBINVD from trampoline_start, which was
     added in the 1990s for Sequent NUMA-Q hardware (removed in commit
     b5660ba76b41 ("x86, platforms: Remove NUMAQ")). Per the Intel SDM
     and AMD APM, INIT preserves cache contents and leaves CR0.CD and
     CR0.NW unchanged. Removing it cuts 479-CPU online time on Intel from
     65.83 s to 11.14 s (-83.1%) and total time from 106.23 s to 51.60 s
     (-51.4%).

   - Patch 2 skips the redundant WBINVD before MWAIT in mwait_play_dead()
     during runtime CPU offline when entering a C-state deeper than
     C1/C1E/C2 while another CPU sharing the same package and LLC remains
     online (unless cache_state_incoherent is set). Architectural MWAIT
     C-states deeper than C1/C1E/C2 flush core-private L1/L2 caches to the
     LLC on C-state entry and maintain cache coherency while the package
     remains powered, just like normal idle in intel_idle. Skipping it
     except on the last online CPU of an LLC cuts 479-CPU offline time on
     Intel from 40.46 s to 11.42 s (-71.8%) and total time from 51.60 s to
     22.50 s (-56.4%).

   - Patch 3 bounds cmci_rediscover() on CPU teardown. Currently,
     cmci_rediscover() broadcasts an IPI via on_each_cpu() to all online
     CPUs, serializing them on cmci_discover_lock while reading up to 32
     MCA MSRs. Because any disabled MCA bank is shared at most with an
     SMT sibling, L2 cluster peer, or die/package peer, probing a single
     online topology peer via smp_call_function_single() (or returning
     immediately when no shared banks were orphaned) reduces 479-CPU
     offline time on Intel from 11.42 s to 9.63 s (-15.7%) and total time
     from 22.50 s to 20.74 s (-7.8%).

   - Patch 4 skips the stop_machine_from_inactive_cpu() all-CPU
     rendezvous (and the AP's cache disable/flush and MTRR reprogramming
     in cache_cpu_init()) in cache_ap_online() when the AP's hardware
     MTRR MSRs already match mtrr_state (which cache_aps_init() already
     programmed during initial boot and warm reset preserves). This cuts
     online time on Intel from 11.11 s to 8.69 s (-21.8%; total 20.74 s
     -> 18.54 s, -10.6%) and on AMD from 3.92 s to 3.15 s (-19.6%; total
     8.45 s -> 7.66 s, -9.3%).

2. Scheduler domains, deadline accounting, and vmstat (Patches 5-8):

   Once the x86 hardware bottlenecks are removed, CPU hotplug on both
   Intel and AMD is dominated by O(N^2) and O(N^3) work inside
   partition_sched_domains_locked(), build_sched_domains(), and
   refresh_zone_stat_thresholds():

   - Patch 5 avoids redundant O(N^3) group weight, SMT core-mask, and
     asym_prefer_cpu recomputations in init_sched_groups_capacity() by
     caching those fields on struct sched_group_capacity, reuses
     already-initialized sgc instances in init_overlap_sched_group(), and
     allocates sdd->sg, sdd->sgc, and d->sds lazily on demand. This cuts
     total hotplug time on Intel from 18.54 s to 9.20 s (-50.4%) and on
     AMD from 7.66 s to 5.29 s (-30.9%).

   - Patch 6 eliminates three O(N^2) dl_server bandwidth walks per
     hotplug step. Because fair_server is enabled on every runqueue by
     default, rq_attach_root() performs O(N^2) remote extra_bw updates
     when attaching def_root_domain during teardown and again when
     attaching the new root_domain during build, followed by a nested
     O(N^2) loop in dl_clear_root_domain(). Dropping the redundant
     __dl_server_attach_root() calls in rq_attach_root() and converting
     dl_clear_root_domain() to two linear O(N) passes cuts
     dl_clear_root_domain() at ~500 CPUs from 1.8-5.5 ms to < 65 us,
     reducing total hotplug time by 30.5% on Intel (9.20 s -> 6.39 s)
     and 18.7% on AMD (5.29 s -> 4.30 s).

   - Patch 7 eliminates per-CPU bitmap scans over already-covered groups
     in build_sched_groups(), reuses temporary per-CPU domain pointer
     arrays across rebuilds instead of calling alloc_percpu() and
     free_percpu() on every hotplug step, reuses precomputed domain/child
     span weights, and hoists LLC size calculations. This cuts total
     hotplug time by 15.0% on Intel (6.39 s -> 5.43 s) and 19.5% on AMD
     (4.30 s -> 3.46 s).

   - Patch 8 avoids unconditionally zeroing and rewriting every online
     CPU's per-CPU stat_threshold in refresh_zone_stat_thresholds() on
     every hotplug step (since calculate_normal_threshold() only changes
     at powers of two and is clamped once num_online_cpus() >= 64),
     reducing refresh_zone_stat_thresholds() by ~88-91% on Intel and ~51%
     on AMD, and bringing total hotplug time down to 5.07 s on Intel
     (-6.6%) and 3.38 s on AMD (-2.3%).

Changelog:
v2:
- Rebased onto tip/master.
- Patch 2:
  - In addition to cpuhp_tasks_frozen, also flush in mwait_play_dead()
    when the target MWAIT state is C1/C1E/C2, when no online CPU remains
    in the same package and LLC, or when cache_state_incoherent is set, so
    shallow C-states and packages offlined at runtime do not retain dirty
    cache lines across wbinvd_on_all_cpus(), subsequent S3/S4 sleep, or
    kexec.
- Patch 5 (Suggested by K Prateek Nayak):
  - Key sdd->sgc lookup in init_overlap_sched_group() by group_balance_cpu
    via a new find_group_balance_cpu() helper instead of
    cpumask_first(sg_span) with a child-span equality check, allowing
    overlap groups to reuse sched_group_capacity even when the group span
    differs from the child domain span.
  - Pass group_balance_cpu into build_balance_mask() and iterate via
    for_each_cpu_from().
  - Use atomic_set(&sgc->ref, 1) directly on the init_overlap_sched_group()
    allocation slow path.
- Patch 6:
  - Wire !CONFIG_CPUSETS cpuset_lock(), cpuset_unlock(), and
    lockdep_assert_cpuset_lock_held() to sched_domains_mutex so concurrent
    SCHED_DEADLINE sched_setattr() calls are serialized against
    dl_rebuild_rd_accounting().
  - Skip TASK_DEAD tasks on inactive CPUs in dl_add_task_root_domain() so
    their pending 0-lag bandwidth is not leaked on the active root domain
    when inactive_task_timer() fires on def_root_domain.
  - Combine the two writes to rq->dl.extra_bw in dl_clear_root_domain()
    into a single WRITE_ONCE() assignment.
- Patch 7 (Suggested by Tim Chen):
  - Add lockdep_assert_cpus_held() to __sdt_free_percpu() and clarify in
    the commit log that sched_init_numa() / sched_reset_numa() are
    serialized against domain rebuilds by the CPU hotplug lock.
  - Add a comment and WARN_ON_ONCE() checks in __sdt_alloc() and
    __sds_alloc() verifying that reused per-CPU pointer slots in cpu_map
    are NULL at the start of a domain build.
Link: https://lore.kernel.org/all/20261015153331.1872641-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (8):
  x86/realmode: Remove unnecessary WBINVD from AP startup trampoline
  x86/smp: Remove unnecessary WBINVD from mwait_play_dead()
  x86/mce/intel: Bound cmci_rediscover() to a single topology peer
  x86/cacheinfo, mtrr: Skip stop_machine rendezvous in cache_ap_online()
    when MTRRs match
  sched/topology: Avoid redundant O(N^3) group capacity walks and unused
    allocations in build_sched_domains()
  sched/deadline, topology: Avoid O(N^2) dl_server bandwidth walks
    during root_domain rebuilds
  sched/topology: Avoid redundant percpu allocations and bitmap walks in
    build_sched_domains()
  mm/vmstat: Avoid redundant per-CPU stat_threshold writes in
    refresh_zone_stat_thresholds()

 arch/x86/include/asm/mtrr.h          |   2 +
 arch/x86/kernel/cpu/cacheinfo.c      |   7 +
 arch/x86/kernel/cpu/mce/intel.c      |  57 +++-
 arch/x86/kernel/cpu/mtrr/generic.c   |  49 ++++
 arch/x86/kernel/smpboot.c            |  46 +++-
 arch/x86/realmode/rm/trampoline_32.S |   2 -
 arch/x86/realmode/rm/trampoline_64.S |   1 -
 include/linux/cpuset.h               |  23 +-
 include/linux/sched/deadline.h       |   1 -
 kernel/sched/deadline.c              |  93 ++++---
 kernel/sched/sched.h                 |  10 +-
 kernel/sched/topology.c              | 394 ++++++++++++++++++---------
 mm/vmstat.c                          |  58 ++--
 13 files changed, 524 insertions(+), 219 deletions(-)


base-commit: aacd2a9507b9fad8eb505c0e493b88779fe35d74
-- 
2.56.0.176.g3575e65682-goog


