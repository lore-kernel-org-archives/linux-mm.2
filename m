Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616D3C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6994C6B03E1; Tue, 18 Aug 2026 03:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649D66B03F1; Tue, 18 Aug 2026 03:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511C76B08EF; Tue, 18 Aug 2026 03:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257046B03E1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:36:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B54680AFD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:36:33 +0000 (UTC)
X-FDA: 85113582666.12.E94ACA0
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0269100008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:36:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjmt0fNl;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787038591;
	b=ORWhBG286JK8qLV1g67URBbsjD3hDp2BdZ3Ke8Q7NamphiwxCQ4ueNUPIPHlTQpGktWTat
	p7W7Zqavna17pySO8Ljnirm4fOc5gURV9btHMBC4Y3jl5evRT3Y54Itq1xf2pPadz3Npyt
	oeL6iziZ/YM4t4MXYdbPhB1/4wFFjf0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjmt0fNl;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787038591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA4rXRC20PbN1YuS6wZOV6o++xOt0Zef10yjQF/tkVk=;
	b=i8dDMWyfatFfCOzeLY6o51u3F7F651Y3ZidBnMVhN3sSIxzq4LYahYkIwzpMzmUYYekpW8
	2Fb2go1chQ3JCBcZtB1p2GilkvACGHXSx8R5k9o54WE/5cUQwQ0ur88ymiQCCPa1BbgnCT
	bfowIebLbal/CmQa/NrwiIT/Bam2Qhc=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso2838597a12.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787038590; x=1787643390; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xA4rXRC20PbN1YuS6wZOV6o++xOt0Zef10yjQF/tkVk=;
        b=cjmt0fNl/Hs6elD+2n7e1HXuRroku3EEFRIi96D7A3xyHe/bLGF/TAgU3zYUQUlwtx
         cPAS0cshiI33xtw3YBnHQ/pnCryRO/LwKoyNKG1XGb0T0rGIQsg7VXZ1qqzvdFBkIRGO
         6tmCqfCZ+Cr9+UepUks8v2LrJVAwe0GbWE0Loh0xHER78LNdXNrRQixiTuCXfFXZwxgA
         Rtt/UuFPIb2jweVQ9M5dX7HW9pszwy2p8S1PNE2puOdXDvmpfPqHiRAr21LiOpSnWaK3
         jbKqfREpZvtskOLKv1v3pOGCneRY4hA0IoeVmzDfJfyDlOosBUX983+MlsWR3JjzjlUO
         fV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038590; x=1787643390;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xA4rXRC20PbN1YuS6wZOV6o++xOt0Zef10yjQF/tkVk=;
        b=Ka+Vvvywn34Ek7fy2CWSQqQu+ShZgjYdBcFTGFGwqIxXJEvkAdOAtoVDawgXRkCHQ6
         xCZV92q5R50kjnV+l0n4jIKPVaLb/f/RByqor8cSk/L+N1slUnZYl1t7uBybsjqGzc8t
         XdDrnNlogc3GTrJ+mAWRQXuLx04xq7rZ3elTh03L5yULYCJUn1TsfqEkuQvhvuSSHKcX
         oSTA8SqiantUudL2sS6HYpr/oNo+ZGnlFfivlV3wJjA7DZXRNN9f53UfPLIQFt8+ArV4
         knxuvPFYupjlFqZa9s+A2F02dfiY/05XeJ3pMOK19GJyn2AkWDRcSnON0QlXfOsH68OR
         jiLw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3PWnPOo8YzarLzW4MiBmepeR5qiJDePzAOyN94nRwtFdPM1JkOxpcQabmOEJuxhWc9Pz8HDOC+A==@kvack.org
X-Gm-Message-State: AOJu0YxepZwXIKwK4R5XvluiCvVFGeirvJTsL+6pvIJGXphHOpKT8TGU
	cBTX1q/WxFHTkRm09jJxzNQbezYiwITtiHG4C9/A2xEQli9HePdVehub
X-Gm-Gg: AR+sD10sbQt9NtFzuYuYuadcishsiRgz0nN0S2kXoqsMeokPJwH0fHz41oAaseZCYlF
	knarNw/gS0fM6FwcbPfuH16WEZL8JrMWNwxCdn3Gq8aI8Rs835bzEm1WeT9EhjYcwDP9U/BqYH5
	NxQwj8jljoOa+SWjKjLyP9aGUIE/eN7d7uUga9b8BrQuBjrRzZFaFMkIrSgpxlpPLajD/nfWE/q
	jMijp8B0Xg3KxocGYrGMgGqPzlQCgt/sODV1WUN8VwQip8c6h3brYFbgEqSMAokp7BNByDQXa0q
	2CNJRFs23UOF5tuSYw+T8omU88KS1gu5MOiDTbUVZAmBhXQnpBj5DRsoetEw7wPdu2UbYjvNDbz
	7R5wrbqqeB5UhJBLkBb2ij7kjQtDWoWTzyoquUf+X9a7p8I0TE5ky0RxlpN/LWrvE0PafIRhTsX
	K3BQuDTz3bw6yHxiBi9+iiSXFptesoznLgfhXGC865dIr65/yYH0FMz0llXQug6EBXM36r+U9uC
	UPEXX0=
X-Received: by 2002:a05:6a00:408b:b0:82f:2b0:2809 with SMTP id d2e1a72fcca58-84fde3651cemr32909513b3a.1.1787038589851;
        Tue, 18 Aug 2026 00:36:29 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851c2fc690bsm306141b3a.14.2026.08.18.00.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:36:29 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
Date: Tue, 18 Aug 2026 15:35:21 +0800
Message-ID: <20260818073546.832476-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0269100008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jbtsuj4ubcodfhr7uu6wbs5879ckpts6
X-HE-Tag: 1787038591-366245
X-HE-Meta: U2FsdGVkX1+wZJFZAhjKLTLYPQhcmeJlyZ5FRvPdFVjeX1i9cWWPii0pzW6eqAf81GR5d5Uf70700LYK2E7fNxlt+5pMoka3XIN2UxQh9C7eHI0nssEOqmuXCcdvkByyIlzq2WkDWlwPr4GLbKcZDQSfGdkbB/COazy/MPAQ1Fw540vnkIX/50nceVPRHY7joDPsqGwTDeWXPMtDOeKDA6DNCuQRlbOnNjiI6V61k6Cn9gGLckrMkOAsBq5H/VHswRRbenUf6pWB1S1J296LNhi1BNyY6wxtiNE69lAwDN1qpwK5TQ/sRjO2iqOWm9hUhpF65bwiG2aWSz6TVDfxmufIznlKlNgEqOGpIVAkTZeT11gggBTmfRGHnE1OTaSfjcapz+e7Pi7we+hQjp4n9c4b0L1VvmHy054+buq72uhn3TLnOjcW3iIi1hMt3p46NYqQUK3/csbSFMnTYPeYJKrViXHPXjvPH2Uso3LSnqtfc4SReAklYjm4pq/0eb0+YAnnjljO3A7N/AWT7/wK6bxiHeZjLu7xPfpobJlhxh6t+EjBcTsN/rdzQ24DTK49LP82UcZ6TAvJfdeUhMv4zpMpKDWAh9GmR3SjzjLcAUnnW61k1qhviVpYfjhQvi/zeXnHhuwNXtG4NMSbppG8rRxQZrAQw4EM4Sm6jqAhx0jTxw4niazkXaNfjKCUGSFngiuC982HnJSFYWpey6Y6rNwH2BDfrus1uWR6wsUb9EF6C6TQtNvXyqRVJgXjUd6D8ZyBCX9gT5+vpN8oTnhiUvb8g/FPMkQtmLCBjlasLKDu/6OjOLYkAL0TNthWl+1pDcTDqieS0zsm9e6PRSibe2/28xCYr8q2cswTtXp6uRQa8swvu/L/HSLvDA12I4YomxyKqT/FNWOk5Os4CnLkaSdWzjp7bRJPgd0QNsqSLYbHgf+Dz0NbVv0jNTpjC+9uGGAxZWUgds8zHC/F7VT
 XcfmCnhe
 i4RHVr/yZMdjBcYImAJi5bBJ6GeckZdApQW/gttx9vUTpKKCkw+FYvAHRucK1WzvgvMTJRQsS6WXCogUY0U7uSjx+Dmyoo6d2YuwSHcWb4yFEvLyO8o+Dx68F9NlJ0I3D16lHiiRt0pAzs0QXAqY5onAtbyppKsO6W8Ta5WZMNxCkiwPPwx8TligCoLeajC1GqtdABTtwo8vFVVT7Imwkd4i1Y/x9jZAlpw4S6ejVfV91vgWFoCEQHVm/hpeHjNha35YXerWJY+PF0Z4ArN2UvG563nVdtnz1zTbgAXkQlJ/nPNObx+QMwZTjBl50KHjToJ0BDcJOTEPWUh1ZdAs75tilyGH5dUnq9Gaf9blusg96znHAfN1aYAzigvX+ftLPkaTHXjSZZ3zON1wNIpSmoWsucWeFAls4401dsjh7O7bSoOCKz8LrJacHXyxBe9Umk4UTNQockTnn9xFvnHJGSKMnQZe/DuzJILok/bWqkS8wfolvgCLpD4aOIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 09:56:34 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

Hi Ravi,

I've been building on your RFC [1] to add ARM SPE support to DAMON,
and wanted to share what we've implemented and where things stand.

Your series provides the vendor- and PMU-agnostic reporting substrate,
including the per-CPU SPSC ring and kdamond drain:

> This series introduces a vendor and PMU-agnostic substrate inside DAMON
> that consumes hardware-sampled access reports through the standard
> perf-event interface.  Userspace selects the PMU through sysfs (raw
> type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> IBS Op sampling.
> 
> Why a unified perf-event substrate
> 
> Earlier hardware-sampled access-monitoring proposal [1] took an AMD IBS
> specific module path backend, owning its own probe configuration,
> sysfs knobs, and lifecycle.
> 
> SeongJae Park has previously highlighted the advantage of Akinobu
> Mita's perf-event proposal [2]: let DAMON register kernel-counter perf
> events and consume samples from any sampling PMU that perf core knows
> about.  This series builds on that direction with the changes we
> needed to run it cross-vendor:
> 
>   - a per-CPU lockless ring between the NMI sample handler and the
>     kdamond drain,
>   - per-CPU events that follow CPU hotplug cleanly,
>   - events fire only while the monitor is running -- created disabled,
>     armed when kdamond starts, disarmed and drained when it stops,
>   - all-or-nothing init across CPUs: a partial-CPU create failure rolls
>     the whole event back rather than leaving silent gaps,
>   - safe handling of vendor sample-validity flags so a stale or
>     unpopulated address is never mistaken for a valid sample.
> 
> What the series adds
> 
> Patch 1 introduces the substrate's data types: a per-event
> configuration struct and a per-context list to hang them on.  A
> CONFIG_PERF_EVENTS=n build folds to no-op stubs.
> 
> Patch 2 exposes those types through sysfs.  Each entry maps to one
> perf event and lets userspace pick the PMU and how to sample it: the
> raw PMU type/config, addressing flags, and period or frequency.  The
> defaults are tuned for Intel PEBS; userspace overrides them for other
> PMUs.
> 
> Patch 3 wires the sysfs apply path so configured events get attached
> to the running monitoring context.
> 
> Patch 4 is the core of the series.  It replaces the mutex-protected
> report queue with a per-CPU lockless ring fed from NMI by the perf
> overflow handler and drained once per sample tick by the kdamond.
> Drained reports are matched to monitored regions by binary search
> over a per-tick snapshot.  The patch also wires the per-event
> lifecycle into kdamond: events arm when the monitor starts, disarm
> and drain when it stops, roll back cleanly when per-CPU init fails on
> some CPUs, and a second context that asks for the substrate while
> it is in use is rejected with -EBUSY.

ARM SPE delivers samples through the AUX trace buffer rather than the
regular perf overflow callback, so `perf_event_create_kernel_counter()`
does not provide a way to consume the SPE AUX trace stream directly.
To close this gap, we developed two pieces:

1. A perf AUX kernel-consumer API [2] that allows in-kernel code to
   consume AUX trace data.

2. A DAMON ARM SPE AUX backend [3] that feeds the decoded access reports
   into `damon_report_access()`.  This is a transport layer and does not
   change DAMON's matching logic; it provides another way for hardware
   samples to enter the existing reporting pipeline.

While bringing up the SPE backend, we kept hitting the same question:
"why does the PMU report zero accesses?"  The answer could be anywhere in
the pipeline — event creation, binding, enabling, the PMU itself, the
ring, or the drain — and without per-stage visibility, the only practical
way to debug this was to add printk instrumentation throughout the
pipeline.

So we also developed a lightweight PMU-agnostic observability framework
[4] that instruments the pipeline with per-CPU monotonic counters and
tracepoints.  It immediately helped diagnose the initial SPE issue:
event creation, binding and enabling all passed, while the PMU produced
no samples.  This pointed to a PMU-level issue rather than a DAMON
pipeline issue, and confirmed that SPE needed an AUX-based backend.

We used the framework throughout the AUX backend development to verify
each stage of the pipeline.  With the completed AUX backend, the same
framework showed a functional end-to-end pipeline: 27/0/0 selftest
results, 47,248 callbacks, with all seven stages observed as expected.

One interesting observation is that the framework's ring counters showed
32,087 dropped reports.  This is about 68% of the 47,248 callbacks.  The
current `DAMON_REPORT_RING_SIZE=256` and drain interval were designed
around much lower sampling rates, while SPE can produce
samples at a much higher rate.  On the current Kunpeng 920 setup, the SPE
sample rate can fill the 256-entry ring much faster than the
current drain interval.

This looks more like a throughput/rate mismatch than a correctness
issue with the reporting path.  For high-rate PMUs such as SPE, do you
think the ring size or drain interval should eventually be tunable?

The observability framework is PMU-agnostic and is posted as a standalone
series [4], so that other PMU backends can reuse the same instrumentation.

The relationship between the pieces is roughly:

Ravi's hardware-sampled reporting infrastructure
                    |
          +---------+---------+
          |                   |
    perf overflow        ARM SPE AUX
          |                   |
          |             AUX kernel consumer
          |                   |
          |              SPE AUX backend
          |                   |
          +---------+---------+
                    |
          damon_report_access()
                    |
                report ring
                    |
                kdamond drain

The observability framework is orthogonal to these transport paths and
can observe both of them.

Everything has been tested on Kunpeng 920 (256 CPUs, ARM SPE).  The DAMON
AUX backend [3] and the observability framework [4] are separate RFC
series, both based on the infrastructure from [1].

Would appreciate any feedback on the approach, especially on extending
the reporting infrastructure from perf overflow samples to AUX-based
PMUs.

Thanks for the foundation — the per-CPU reporting and drain
infrastructure provided a useful base for the AUX path.

[1] https://lore.kernel.org/linux-mm/20260529165640.820-1-ravis.opensrc@gmail.com/
[2] https://lore.kernel.org/all/20260814144927.489172-1-kunwu.chan@linux.dev/
[3] https://lore.kernel.org/all/20260816142222.689624-1-kunwu.chan@linux.dev/
[4] https://lore.kernel.org/all/20260818061031.827057-1-kunwu.chan@linux.dev/


> 
> Patch 5 is the perf-event backend.  Two stateless overflow handlers
> (one vaddr-keyed, one paddr-keyed) are picked at event creation time
> and submit samples into the per-CPU ring.  Vendor-specific sample
> validity is honored at this layer.
> 
> Patch 6 adds a tracepoint at every node_eligible_mem_bp quota-goal
> evaluation so userspace can watch goal convergence without polling
> sysfs.
> 
> Userspace setup model
> 
> Userspace selects the sampling PMU by pointing the perf event's
> `type` / `config` at it, and chooses the scheme topology that suits
> the address space the PMU reports on.  No module load or unload step
> is involved; `echo on > state` arms the substrate, `echo off > state`
> disarms it.
> 
> Two configurations were used for validation.
> 
> Configuration A: AMD IBS Op, paddr ops, system-wide PULL+PUSH tiering
> 
>   IBS Op stamps samples with physical addresses, so DAMON reasons over
>   every backing page in the system regardless of which task or guest
>   touched it -- the substrate becomes a system-wide tiering controller.
> 
>   Setup (abridged; `D=/sys/kernel/mm/damon/admin/kdamonds/0`):
> 
>     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
>     echo 1     > $D/contexts/nr_contexts
>     echo paddr > $D/contexts/0/operations
> 
>     # Two regions, one per NUMA node (DRAM + CXL).  PA ranges
>     # are derived per host from /proc/iomem; omitted here.
>     echo 1 > $D/contexts/0/targets/nr_targets
>     echo 2 > $D/contexts/0/targets/0/regions/nr_regions
>     echo <DRAM_LO> > $D/contexts/0/targets/0/regions/0/start
>     echo <DRAM_HI> > $D/contexts/0/targets/0/regions/0/end
>     echo <CXL_LO>  > $D/contexts/0/targets/0/regions/1/start
>     echo <CXL_HI>  > $D/contexts/0/targets/0/regions/1/end
> 
>     # IBS Op event, period-based, paddr-stamped:
>     PE=$D/contexts/0/monitoring_attrs/sample/perf_events
>     echo 1 > $PE/nr_perf_events
>     echo $(cat /sys/bus/event_source/devices/ibs_op/type) > $PE/0/type
>     echo 0      > $PE/0/config
>     echo 1      > $PE/0/sample_phys_addr
>     echo 0      > $PE/0/freq
>     echo 262144 > $PE/0/sample_period
>     echo 0      > $PE/0/exclude_kernel
>     echo 0      > $PE/0/exclude_hv
> 
>     # PULL scheme: migrate_hot toward DRAM, gated on
>     # node_eligible_mem_bp(nid=DRAM) goal target_value=TARGET_BP.
>     # addr filter restricts source to the CXL range.
>     # PUSH scheme: migrate_hot toward CXL, gated on
>     # node_eligible_mem_bp(nid=CXL) target_value=10000-TARGET_BP.
>     # addr filter restricts source to the DRAM range.
>     # Both schemes are migrate_hot; they converge from opposite
>     # directions on the same hot working set.
> 
>     echo on > $D/state
> 
>   Userspace tunes the steady-state DRAM:CXL split by writing the goal
>   `target_value`s; DAMON's quota autotuner drives migration intensity
>   to match.
> 
>   Workload: a QEMU/KVM guest pinned to one NUMA node, running 32
>   multichase multiload threads each touching a 4 GiB working set
>   (~128 GiB aggregate) with the memcpy-libc kernel.  The guest sees
>   a flat single-NUMA layout and has no direct view of the host's
>   tiering topology, yet its hot pages are migrated to DRAM and cold
>   pages pushed to CXL by host-side DAMON acting on IBS-stamped
>   physical addresses -- the application inside the guest benefits
>   from tiering it never had to be aware of.  Validated on AMD Turin
>   (132-CPU EPYC).  The configuration converged to its target ratio
>   in seconds and remained stable for 7+ hours continuously, with no
>   perf core auto-throttle and no measurable drift in the achieved
>   interleave ratio.
> 
> Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID weighted-dest
> 
>   PEBS reports vaddr samples in the context of the running task.
>   DAMON's vaddr ops monitors a specific PID.
> 
>   Setup (abridged):
> 
>     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
>     echo 1     > $D/contexts/nr_contexts
>     echo vaddr > $D/contexts/0/operations
> 
>     echo 1     > $D/contexts/0/targets/nr_targets
>     echo $PID  > $D/contexts/0/targets/0/pid_target
>     echo 0     > $D/contexts/0/targets/0/regions/nr_regions
> 
>     # PEBS MEM_LOAD_RETIRED.L3_MISS, frequency-based, vaddr-stamped:
>     echo 1      > $PE/nr_perf_events
>     echo 4      > $PE/0/type           # PERF_TYPE_RAW
>     echo 0x20d1 > $PE/0/config         # umask=0x20 event=0xd1
>     echo 0      > $PE/0/sample_phys_addr
>     echo 1      > $PE/0/freq
>     echo 5003   > $PE/0/sample_freq
>     echo 2      > $PE/0/precise_ip
>     echo 1      > $PE/0/wakeup_events
> 
>     # Single migrate_hot scheme with two weighted destinations
>     # (DRAM + CXL).  Userspace tunes the steady-state interleave by
>     # writing dests/{0,1}/weight.
> 
>     echo on > $D/state
> 
>   Workload: 32 multichase multiload threads with a 4 GiB working set
>   each (~128 GiB aggregate) running directly on the host, monitored
>   by DAMON via the multiload PID.  Validated on Intel Granite Rapids
>   (144-CPU).  Convergence is fast and the system is stable.
> 
> [1] https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.opensrc@gmail.com/
> [2] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
> 
> Ravi Jonnalagadda (6):
>   mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
>     list
>   mm/damon/sysfs-sample: expose perf_events configuration via sysfs
>   mm/damon/sysfs: install perf_events on apply
>   mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
>   mm/damon/vaddr: implement perf-event access check
>   mm/damon: add damos_node_eligible_mem_bp tracepoint
> 
>  include/linux/damon.h        |  80 +++++
>  include/trace/events/damon.h |  49 +++
>  mm/damon/core.c              | 403 ++++++++++++++++++++----
>  mm/damon/ops-common.h        |  39 +++
>  mm/damon/sysfs-common.h      |   6 +
>  mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
>  mm/damon/sysfs.c             |   3 +
>  mm/damon/vaddr.c             | 267 ++++++++++++++++
>  8 files changed, 1370 insertions(+), 56 deletions(-)
> 
> 
> base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
> -- 
> 2.43.0
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)

