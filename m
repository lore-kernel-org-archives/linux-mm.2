Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22EBCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745426B0088; Thu, 15 Oct 2026 11:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6936B008A; Thu, 15 Oct 2026 11:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5CC6B008C; Thu, 15 Oct 2026 11:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37EBA6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A32891A0574
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:38 +0000 (UTC)
X-FDA: 85325255316.17.BA7E6C1
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF0B11C0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YYk8F8Hk;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078416;
	b=6QiQCj6cQlu3YYfeVHg1u7Nzab+37Q52DqiM7A2vmr1Cq7cprNCr+gTZFORWTzsRUYqA7+
	GPodLsy17IvF3Rv1IQqwiyIBqE0auOJQbU+uhxESk10fTTebbFAbsZKgNI/CjAgzC4ty2s
	zKmmyGos2SfT2tZ9bCyF1H2U21FzBkI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YYk8F8Hk;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IWqiGzk/pYHC1ZT+qsWV7wuDwiIjMUnX6pd7W6OrNuo=;
	b=BsM6m6XBo/azrId3iGhg+NlJTIqB9x348kK0f2cF6FVhDX6+/CsbZZpK3txH2BowkFOiw+
	XnMjX5vT9/abY+WON3pWwbp9VuOW6Oh78iYNDJUT7KIr6p6F0u9miFA1X7sTR9hELLUwVz
	/XBRKvXSU5j/v3dj2WwMLqHCS1eLgQA=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7c19c6721a3so3463155137.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078416; x=1792683216; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IWqiGzk/pYHC1ZT+qsWV7wuDwiIjMUnX6pd7W6OrNuo=;
        b=YYk8F8HkyEpABVm7FNGF1DrvDdqLQJkdlS5bfQglm14lr4nNBmooBR++ibiiszVgVA
         Th0Srbp9O7lwvuGWv5iC6cIGR7r0w9tqybPqxgLd31kmV9HdM7sm2jsn+b4YIlcgSTbI
         t/OW9KU5sfD8nW5zLL+TFic7/UOsOwKYdiVezYfruY7nliFMxMkqrpdZWRcvoDpNj++D
         lakagQVC2ua5ZjmWkYjKsRJMTcM0Di5AzkjhqPLkGAm67ntQ1rqTRg4o7I7n1W3Uilab
         S1TGVn89QpFg8pxhk5SCcReZhHw+m1SZA4DQNavUszhs+dHjvUhYY+fiD2gJiszoFz/M
         owkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078416; x=1792683216;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IWqiGzk/pYHC1ZT+qsWV7wuDwiIjMUnX6pd7W6OrNuo=;
        b=1YrpNJeyaukQygUoQejovIpD77U38DeFpb8i3LPyf645RaxCYhVZJs8jBFOLTvenzG
         vyQ4tdBHG3rmbXIRrnJq0SCV0WPSJL4ttugThw6vyv2gUhaF2z0B8VkN5PA+NZssMfrz
         kEkT6mnOR6fBkuFf5N53yGlRjTQFOTgQDCBGN4WCdwmHB4XDYffzLNBkeG3GvNW76sP7
         AdwNOGh91ZHBXve1fAt8Fn/lk9znOptE5726IOx8Xr9nmLFioH8ezBAADo2dPhzWtvbx
         YzvgmVuTgwhnHXBTlxBfBdjXYv188zlQtL8zP1ARrakHjHeBKL9gtd1NdUBdaNc8iq3X
         bAIA==
X-Forwarded-Encrypted: i=1; AKwUvByRW88LnOwgcQMxGFcTsP5ZpJJXNK+Gq7mqWq7T/pVHQVsIEwAZyKHOq4tj1Z2h7bjpiYnqpKLrDg==@kvack.org
X-Gm-Message-State: AFq9FYKUvvfoKQMBxwHBahU4pXQPB/Dkf+7Gc39frlAI1B2RMEMxNQox
	x9VTEx8CUqedB9qo0v6SOIQpxiiSdq3ml5f9gUa5aZxSY0wzYrurwHgmXfDAKp1tuyc=
X-Gm-Gg: AYBFou1Da1VKCAXEq+sxdtZ8eJV3V4531bzXbcsQXGJ57nmU7Ajg1Tkv3XafXVIoyKt
	aAafXhcQLeJ69prBaVKGEFBiEi+F77LY/FGj/QHFcoRUPNrhdZUVg12tG/dErsETCxF9z/jvPI1
	RX6SLGEYFAk21OyuqH27utrnygEZ2pY6zQzTbG5m7DzDJ2eFCaS95C4ZcgN/kd0nAjh361mWLtu
	ij5z+L6ZOjvlQQPWw1Rm1pOeCF0rMyxsaebAFJbCstp7BnBCRto2TBnhEWURvSC0FtzHgQTxdVY
	83GG5AOyN6/ri4b8UITXj6KfyoIbWb4pHaHA8B/1/mMEGTPyiWzv7ANZ9dO2WhQ2LU1tgMDukbs
	6+18tpBJ76Y0vjJG205TMhigog1lJebMs+B2lyHR0Ii53z5sTOBAOsUMvBEm1p3M0QI6PavsfXl
	eZ2RFdmL9tyD3XQZdIdYDC/1X4OzB+K1GxPXygxYbqv5H4LhpiSZ20ca9yQ4k5GGjYeV5XW0HqF
	AVIE5xAaSlw2BO3ciFqzjFm4kjm2nMMQONzwfu3BbsB2vZTVEgI76GvoXAlHzHUXDuoyG7C6HFB
	GD/1ogrmoV+yT4s6NkM=
X-Received: by 2002:a05:6102:c09:b0:78e:1e0f:ea42 with SMTP id ada2fe7eead31-7cb3971582emr7015724137.2.1792078415811;
        Thu, 15 Oct 2026 08:33:35 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:35 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 0/8] x86, sched, mm: Speed up CPU hotplug on large systems
Date: Thu, 15 Oct 2026 11:33:23 -0400
Message-ID: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF0B11C0005
X-Rspam-User: 
X-Stat-Signature: 5u9hchw8yx4955kdi33cjyqrq7w8kfyy
X-HE-Tag: 1792078416-177725
X-HE-Meta: U2FsdGVkX1981VE7DbDdXDcOPD4hXXOznSlWL58Orch2ODamyU45rcYkz80CUWl5W7NhrkGMgzcG7w7A6DQ6nhaQ8MHu+Nj8vUNg4t2KK/gtS1ORJVph/JA123vehE+UtTyo5IqE+KrW1BNt1aWZ6nHPTAMI0FwCi1Bz2pPVwzA4Kap+l7JhUx1GRDK2NuPhoGW6HpoxQY9BBw5+oeWg2HusXf1nF3vrAYPEHyIhn+sLv07GAL1gHxlYtJQq5OWnh731dqyUby3CCPT9IYCsFTaDMRDco92VXa7KjJlgVGz7Uyt+OQvp9BRIC8ksoq2OkPyNu6mgI7NcvihcEykEXxG/RFrU/wvPHGQfPPtfckuQG5Xet60hJWL6L1+k4kBbuqap2XaNeeq8FZatTU/s9cGfovPHazO7xBMFyugDAgPaOO2KbEOHsvKBjWhsS+itFjcgUjZkpXpAVtDMUuHNzIXZ2NBFtD3W/eV7m3C+spnCK0vy/Tw199eOlFD+yLnevGA77CW6yn4rW3b3mSVagngiACGwaw2kSbt/307E2PxXtrV3t+58nuM4QLj0CWHZklysZky5GdXcpmJwt8CGQeNWD0HuZb7C1ov26a8tGPjtQCaau71EsDtR6CbXvDBEIm7PxptihRVOXr+cFACFkl/OUtwc/jtepKHUiLvgs4P6ao1myqJ/jcWKEdj5WX/a445MWv2poN8XdI5tM2bcPFAfMNk7wnH14nXCpq8c/pjKceh1r1WgcTfQJU+fT0hE6ZyRjC7vomw0IqIq4nh334izeWjUGoXcvsk8085bvGKkwLa0pbdGzBmGXFpYf3qtKSB/1cDpgCbR2oecDb5G+ibRth9qAvXamtMwZry8TdIirKAYpsC8BKpcUdeUFlmoxQL/QsTubx0M3qUrFoSUbNFalSP23Y3n8HnN8iAhVj9tXbGh8o7qsUZCshMI1Lzv55gJiydkNHoouI6pSfm
 tVt4m9h5
 TbC1oJdk6VzDBjvStcIpWyywGV7p9AzqzPO+2JrZU1oSxLIEg5K89AzekKt0GdSI4FUBgAOrZ1UzH3DgaQMi4vFy4O5xzotD1bUYlvQRmRXyQQrNl7sGuh8VCkr/owvFahOyczZz8NoJp9Y+kYrUjcySaqb8mbjUaXY2kgh2WbVyPGY0wo+huOofaripuj7F5LawUMlBQFzDr4TAR6H0Z/deo29u5s05O7Pr9pHmTgA57iW+9a8XEyJETOsoDgzOzg37gX0mYWmdOf92pjCpU7Yk3xA==
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
     during runtime CPU offline (retaining it when cpuhp_tasks_frozen is
     set for system sleep). Architectural MWAIT C-states maintain cache
     coherency while the package remains powered and flush core-private
     L1/L2 caches to the LLC on C-state entry, just like normal idle in
     intel_idle. Skipping it for runtime offline cuts 479-CPU offline
     time on Intel from 40.46 s to 11.42 s (-71.8%) and total time from
     51.60 s to 22.50 s (-56.4%).

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

2. Scheduler domain rebuilds, deadline accounting, and vmstat (Patches 5-8):

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
 arch/x86/kernel/cpu/mce/intel.c      |  57 ++++-
 arch/x86/kernel/cpu/mtrr/generic.c   |  49 ++++
 arch/x86/kernel/smpboot.c            |  16 +-
 arch/x86/realmode/rm/trampoline_32.S |   2 -
 arch/x86/realmode/rm/trampoline_64.S |   1 -
 include/linux/cpuset.h               |   6 +-
 include/linux/sched/deadline.h       |   1 -
 kernel/sched/deadline.c              |  89 ++++---
 kernel/sched/sched.h                 |  10 +-
 kernel/sched/topology.c              | 339 ++++++++++++++++-----------
 mm/vmstat.c                          |  58 ++---
 13 files changed, 422 insertions(+), 215 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.56.0.385.gd3acb90ef8-goog

