Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC26CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34166B00BC; Fri, 29 May 2026 12:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B686B00BD; Fri, 29 May 2026 12:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48406B00BE; Fri, 29 May 2026 12:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D472A6B00BC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B47F1C0320
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:01 +0000 (UTC)
X-FDA: 84821062242.05.FDA7F80
Received: from mail-oo1-f67.google.com (mail-oo1-f67.google.com [209.85.161.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id C91771A0003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:56:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ca4CHy1J;
	spf=pass (imf19.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.161.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=61y2RUu4XsaORgnhBsj3LdYfK6rAcceIjq+Qt3FiRdA=;
	b=B9Ftgvy/Kk+y0jECjRazdPPobAQMSUW2e8bMqp+bESYmnXurrE624dZE5Cx/bijQGkEh0j
	1cTaLQb0iyrgdGXD2kH8qFJOKjZm5IozmZ3FmddgL+RYY7647TOPzXGUqmkAo9zFpCZaVq
	wlAN9lkHMsFmTbGbx6KbUXNEPddPZ48=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ca4CHy1J;
	spf=pass (imf19.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.161.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073819; a=rsa-sha256;
	cv=none;
	b=3Q41FPU1Dbu8Sce7bSSTKnQz3zqMvjNWvAixsHL6wFGHZNZiLQuqxRM/VstJ05XLURWWOP
	8CdMkB06Vdhq4Wb7Hp+Z9H/sY6PHeyfubJ/7mgkr8mtD+KXOqRRWEM4mUbbF5NeoXrYkNh
	mGTmWtVlgdAyHpqihNj5AE/WBcNKIt4=
Received: by mail-oo1-f67.google.com with SMTP id 006d021491bc7-69d78547957so4211428eaf.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073819; x=1780678619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=61y2RUu4XsaORgnhBsj3LdYfK6rAcceIjq+Qt3FiRdA=;
        b=Ca4CHy1JVg8ttkLbMTc5I/D56ezPmELxnRhtryE33vtr/UimnRd5w8ppCY9YTPtIPy
         5MVn8/iu0atYkscEa0EXYljLDcYSKssRZUQlqX1jr2XpscXGBDX3aNieT1q/QL1UV51m
         ttlvrV/wl8ao3oU2o93jK1iGuieR+3f7aP/KO380eqyyesj1zMCIhVXYs7GPFARPNsEB
         S7LMZAGEpMcvgf2Md18Zh3xKhNUiXJ8ozvjpDTy2ikLRvFv7DnhAuGI8e99EXz40ukH6
         JCK6ZoS26EfYAMnr5V5o5396evNSdhNuD7q/r0AZIC5M0dSmYdqzmY3GL1Pj6awAu7+E
         nvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073819; x=1780678619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61y2RUu4XsaORgnhBsj3LdYfK6rAcceIjq+Qt3FiRdA=;
        b=sowjyv4yoG3kAZVZTsJcBE/9dhvgB2E9cdIPDnQkWfk5a9tzyXDXI7PyMw8HYMKKNH
         faXTQQjgcdk3ggUiY8pbeWszfrO7yXBUmb7g1wn6tRUcXndxSFDVl+UnrpKvJNN3H62T
         E+KE6lB9GoT2RMFD2G3CdDnsKHCcRObsf32dng1tNfzjIcDLcL0fj9jlxlHVQop80ybG
         XKH1z11UhiUU3dU/33U9vDA5VA1ExXCwugS7Jiv2vlq8OolUuFTjCkYoRm4Lm24oV0cs
         pJ/QMV2vg4ahmNFKVwOaiAPRkehQWKY0sl37dUzsVQPNlyN21MlpdpKVQ76xsyWCtMee
         y02Q==
X-Forwarded-Encrypted: i=1; AFNElJ+Ni4nSfYsRLts0V83mKHi0aMh61L87VNX4mKv6S3Qg19n4Z64NcO7Jmx5yu1iwUZwT//csp4PqoQ==@kvack.org
X-Gm-Message-State: AOJu0YxfI1BP9OtKw3zVCvXv6TGiYoLKcJnGFlkiuUoBNyyau6JaogAi
	d2SiOnT8Q86R87PEQehi/nWh/AqGLG0RsrhAm97wA80CnhIof9tsfC0=
X-Gm-Gg: Acq92OGB69/PGzEW1xKAguVeZY7X9+gsJL3PtXbUR52RWkb6gNbaUXow8Zvn1V4g0jO
	CojK3d8gWJ9BE/VtI20UHH4SLT3CcBqa8sDM71G87nTbqPjWGZdd/W7v+koGTmQGfZ7wUt5JT3C
	pXbe1IdYtqTGpgKimEvVmPN8QlJF+/Y51cXSJbe4JZ/8GWOZrCUFKDoSxcxU6yBY6CgX/NZvZRn
	ZhmRKMpJ6tIHYIFWZhK+zlKMMGdcm4tkxYDNKOuPHb7uZM6xdPfKrtsOJGd2VwhGkz1VIIaLjWq
	T7enbhZZ3JS/2tBmL1+rU8EALrGthbK5B3NXr1tKMefy4rdmqtfWujruI+b7YMORK0V+QFhfO0w
	D6F5gpbuiqv5llks/AfecM0r00AH35kkp0IveO8PCTqDH/DbFOZ1Q152QENt/LqxxSvkXfdUDGo
	s3KxJ2GhYLc2Ge4p+MXGlSQTlaXQRWHuTpnJ7C093ThY5fFBL+HBWuc0galtc8U0hDmwpvPHPCd
	Y7c2p/OUR9R
X-Received: by 2002:a05:6820:1985:b0:696:1a98:bd5 with SMTP id 006d021491bc7-69e0ff17ff1mr94887eaf.19.1780073818589;
        Fri, 29 May 2026 09:56:58 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e069b0ea8sm1442784eaf.12.2026.05.29.09.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:56:58 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
Date: Fri, 29 May 2026 09:56:34 -0700
Message-ID: <20260529165640.820-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uf364ooi7mjcyj4g6mnb5obuedmaumsw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C91771A0003
X-HE-Tag: 1780073819-723390
X-HE-Meta: U2FsdGVkX1+aVQYQlDZxY/ELgXrBrH/1RYMM05B/w3OQpIVmvARDEcvH8k17J2jFwsVhaKdDq16HmGk+9gCpg7TA8a6GWeOANwPZoGnrBqEAqeznngRDh5KSltb01uziOuhQ6wXtJziPrPDxYQUdkz8UExMk0rDycn7vScUyMHz4yNcsTAEcbgAqCMnGIx1TT30jOE3bu0ED+S1n1V4VuZu4bCplRPAoRcurPyeMqNjDbjRS0hmjXKppTAEYw2Hl8Cxwqyy+cIpJ8KSRf756E70fwjWUrc0GspTcgYlIQ5FhPzsBbAQFhGR37nj9Dx31mYQeMCbkRWs2KW8RjKYO8PodW0Ey3hiI1iOd9i8J7d3Mn48pKGuAIOaYBoqx/OeN6zrqBUfDQ6q5MFa1U0WOZCYskO9W+sf03J7zDs6IvKj4ELkoKeqSq0AQ983DIl2Cld4krZSNmRQQZPlu4x2gV+akymjUqdh4VdvsKPBZUmv4TEdwtr8tbKeM+PCBbbBJRMuZx05vXXJ5opfIp8LqMYi9CsECiubVFoFKkKwRo77elzPs3YDL2f9qa5qwrIh0qXG7FGStAzEU8qh4ycC+A06XtD/9JWbluDb2goZjQ3ZGsv+6if6MCL3YIwX48k0lUqwX9LW0y5VraHWrnk7OUhexHd0+g0YV3Ae5KZlufXpaAlqeaGx2isCurKN6CPklXLP77BJt1jHX3eLwcLexYXVrRHLfbTFABcyo+jypZ5ECfhc6vMjNHDbo+P0KmIhUR5vWsAFSIKV4MgKbvPgC1D3+GyBeQfUZR2ZmjVSRT4Iuua7gWMwn+diXEQNUH+iv7/jIc6cA6szAtRgMpwPGA2JjOSUHNd82V6EwCCy4R4QoLQLV6hJ1mjCXRcph0EkUiAwDjrAjBU087TWQ+26SlfZq/4Zd8KZln6sIeWCmcBggwAU4I9fSgsdYQBs3ZFY+/GF7xGoqYGqR6Ohpjix
 TT99LMLo
 7/dwstz0rShGK3nc0NTS6fLH/UQOSVAQSR2kMKG6OiTV+qx1urqL7n/EQbbjT3/gMX1i0p0zYZHj8p8Ti1jDDtT+A1fnHh919nq7x3GPTLEriYImNNxL1phmXWYGXUO4uif8Avhzv4BFbL9EUyR/N5OMwE99YI8yM9TY9c+nf8OdtPGIjLzfMTUsj63c/USejENt/uWAmv9Xuu+zwYV6c1HFzMShFGdO0b0+ze6AefAgh+fQd4UrqSoXk7ALDjzQJjxqVXibwVh3eWXa1Fd6gCSH0yrQr1szUUK7wRTnb3+yb/fSwcJsoEqKFwL4L7F5qkB+aWI4eqhdvDHw+14JKtUiTbd5mTYzztVSz/xBAdP8rsfINeiGkwnfMv9bhdjlrhmEQvyNDhMR3I8mxfTrsfsrtAh+W1MT6Z0Pw4CMyI8F9WEZ2GhG3HxNG1XpoC+h8HVF3I+ew+DY6ItlM0eCVu7q536u/mxAF2nUaKI+4kADrgk/pratXmX5v/HPe2skiDsiCXJCSXJIQXomfEfXNiaRcvU2nqbaEB+ROJotROgLzueh+gPzvX10aNerVMJT3ZZo2aXC22wXBVz+wPtLU6zaXtXqOjfdr8BeARGCHI3E06zN3jp4dAqoFJd2+p7y808VRJ2hLAbxSRui1dfX30rzF3ZVMPelp+HONEW+KxfCQxT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a vendor and PMU-agnostic substrate inside DAMON
that consumes hardware-sampled access reports through the standard
perf-event interface.  Userspace selects the PMU through sysfs (raw
type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
IBS Op sampling.

Why a unified perf-event substrate

Earlier hardware-sampled access-monitoring proposal [1] took an AMD IBS
specific module path backend, owning its own probe configuration,
sysfs knobs, and lifecycle.

SeongJae Park has previously highlighted the advantage of Akinobu
Mita's perf-event proposal [2]: let DAMON register kernel-counter perf
events and consume samples from any sampling PMU that perf core knows
about.  This series builds on that direction with the changes we
needed to run it cross-vendor:

  - a per-CPU lockless ring between the NMI sample handler and the
    kdamond drain,
  - per-CPU events that follow CPU hotplug cleanly,
  - events fire only while the monitor is running -- created disabled,
    armed when kdamond starts, disarmed and drained when it stops,
  - all-or-nothing init across CPUs: a partial-CPU create failure rolls
    the whole event back rather than leaving silent gaps,
  - safe handling of vendor sample-validity flags so a stale or
    unpopulated address is never mistaken for a valid sample.

What the series adds

Patch 1 introduces the substrate's data types: a per-event
configuration struct and a per-context list to hang them on.  A
CONFIG_PERF_EVENTS=n build folds to no-op stubs.

Patch 2 exposes those types through sysfs.  Each entry maps to one
perf event and lets userspace pick the PMU and how to sample it: the
raw PMU type/config, addressing flags, and period or frequency.  The
defaults are tuned for Intel PEBS; userspace overrides them for other
PMUs.

Patch 3 wires the sysfs apply path so configured events get attached
to the running monitoring context.

Patch 4 is the core of the series.  It replaces the mutex-protected
report queue with a per-CPU lockless ring fed from NMI by the perf
overflow handler and drained once per sample tick by the kdamond.
Drained reports are matched to monitored regions by binary search
over a per-tick snapshot.  The patch also wires the per-event
lifecycle into kdamond: events arm when the monitor starts, disarm
and drain when it stops, roll back cleanly when per-CPU init fails on
some CPUs, and a second context that asks for the substrate while
it is in use is rejected with -EBUSY.

Patch 5 is the perf-event backend.  Two stateless overflow handlers
(one vaddr-keyed, one paddr-keyed) are picked at event creation time
and submit samples into the per-CPU ring.  Vendor-specific sample
validity is honored at this layer.

Patch 6 adds a tracepoint at every node_eligible_mem_bp quota-goal
evaluation so userspace can watch goal convergence without polling
sysfs.

Userspace setup model

Userspace selects the sampling PMU by pointing the perf event's
`type` / `config` at it, and chooses the scheme topology that suits
the address space the PMU reports on.  No module load or unload step
is involved; `echo on > state` arms the substrate, `echo off > state`
disarms it.

Two configurations were used for validation.

Configuration A: AMD IBS Op, paddr ops, system-wide PULL+PUSH tiering

  IBS Op stamps samples with physical addresses, so DAMON reasons over
  every backing page in the system regardless of which task or guest
  touched it -- the substrate becomes a system-wide tiering controller.

  Setup (abridged; `D=/sys/kernel/mm/damon/admin/kdamonds/0`):

    echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
    echo 1     > $D/contexts/nr_contexts
    echo paddr > $D/contexts/0/operations

    # Two regions, one per NUMA node (DRAM + CXL).  PA ranges
    # are derived per host from /proc/iomem; omitted here.
    echo 1 > $D/contexts/0/targets/nr_targets
    echo 2 > $D/contexts/0/targets/0/regions/nr_regions
    echo <DRAM_LO> > $D/contexts/0/targets/0/regions/0/start
    echo <DRAM_HI> > $D/contexts/0/targets/0/regions/0/end
    echo <CXL_LO>  > $D/contexts/0/targets/0/regions/1/start
    echo <CXL_HI>  > $D/contexts/0/targets/0/regions/1/end

    # IBS Op event, period-based, paddr-stamped:
    PE=$D/contexts/0/monitoring_attrs/sample/perf_events
    echo 1 > $PE/nr_perf_events
    echo $(cat /sys/bus/event_source/devices/ibs_op/type) > $PE/0/type
    echo 0      > $PE/0/config
    echo 1      > $PE/0/sample_phys_addr
    echo 0      > $PE/0/freq
    echo 262144 > $PE/0/sample_period
    echo 0      > $PE/0/exclude_kernel
    echo 0      > $PE/0/exclude_hv

    # PULL scheme: migrate_hot toward DRAM, gated on
    # node_eligible_mem_bp(nid=DRAM) goal target_value=TARGET_BP.
    # addr filter restricts source to the CXL range.
    # PUSH scheme: migrate_hot toward CXL, gated on
    # node_eligible_mem_bp(nid=CXL) target_value=10000-TARGET_BP.
    # addr filter restricts source to the DRAM range.
    # Both schemes are migrate_hot; they converge from opposite
    # directions on the same hot working set.

    echo on > $D/state

  Userspace tunes the steady-state DRAM:CXL split by writing the goal
  `target_value`s; DAMON's quota autotuner drives migration intensity
  to match.

  Workload: a QEMU/KVM guest pinned to one NUMA node, running 32
  multichase multiload threads each touching a 4 GiB working set
  (~128 GiB aggregate) with the memcpy-libc kernel.  The guest sees
  a flat single-NUMA layout and has no direct view of the host's
  tiering topology, yet its hot pages are migrated to DRAM and cold
  pages pushed to CXL by host-side DAMON acting on IBS-stamped
  physical addresses -- the application inside the guest benefits
  from tiering it never had to be aware of.  Validated on AMD Turin
  (132-CPU EPYC).  The configuration converged to its target ratio
  in seconds and remained stable for 7+ hours continuously, with no
  perf core auto-throttle and no measurable drift in the achieved
  interleave ratio.

Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID weighted-dest

  PEBS reports vaddr samples in the context of the running task.
  DAMON's vaddr ops monitors a specific PID.

  Setup (abridged):

    echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
    echo 1     > $D/contexts/nr_contexts
    echo vaddr > $D/contexts/0/operations

    echo 1     > $D/contexts/0/targets/nr_targets
    echo $PID  > $D/contexts/0/targets/0/pid_target
    echo 0     > $D/contexts/0/targets/0/regions/nr_regions

    # PEBS MEM_LOAD_RETIRED.L3_MISS, frequency-based, vaddr-stamped:
    echo 1      > $PE/nr_perf_events
    echo 4      > $PE/0/type           # PERF_TYPE_RAW
    echo 0x20d1 > $PE/0/config         # umask=0x20 event=0xd1
    echo 0      > $PE/0/sample_phys_addr
    echo 1      > $PE/0/freq
    echo 5003   > $PE/0/sample_freq
    echo 2      > $PE/0/precise_ip
    echo 1      > $PE/0/wakeup_events

    # Single migrate_hot scheme with two weighted destinations
    # (DRAM + CXL).  Userspace tunes the steady-state interleave by
    # writing dests/{0,1}/weight.

    echo on > $D/state

  Workload: 32 multichase multiload threads with a 4 GiB working set
  each (~128 GiB aggregate) running directly on the host, monitored
  by DAMON via the multiload PID.  Validated on Intel Granite Rapids
  (144-CPU).  Convergence is fast and the system is stable.

[1] https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.opensrc@gmail.com/
[2] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com

Ravi Jonnalagadda (6):
  mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
    list
  mm/damon/sysfs-sample: expose perf_events configuration via sysfs
  mm/damon/sysfs: install perf_events on apply
  mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
  mm/damon/vaddr: implement perf-event access check
  mm/damon: add damos_node_eligible_mem_bp tracepoint

 include/linux/damon.h        |  80 +++++
 include/trace/events/damon.h |  49 +++
 mm/damon/core.c              | 403 ++++++++++++++++++++----
 mm/damon/ops-common.h        |  39 +++
 mm/damon/sysfs-common.h      |   6 +
 mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
 mm/damon/sysfs.c             |   3 +
 mm/damon/vaddr.c             | 267 ++++++++++++++++
 8 files changed, 1370 insertions(+), 56 deletions(-)


base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
-- 
2.43.0


