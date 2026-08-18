Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9FBCC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D036B018E; Tue, 18 Aug 2026 11:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDE16B018F; Tue, 18 Aug 2026 11:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC6E6B0190; Tue, 18 Aug 2026 11:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8454C6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:50:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1359EA1AB2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:50:00 +0000 (UTC)
X-FDA: 85114826160.11.C468F94
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43C50A0002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:49:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DjEm3XUR;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787068198;
	b=oDfMWEvGsQWp5KyCK2Ep91WRS6CV9QrK/zc5XYPGWMWWUlKEFBTCi8BL1kSeWsTw1bkGxB
	yg/ZmD1L7dTFWZRQP8/tUpE/vSgKGjOltW+EptDyooMUf82dp+9VTCBkOEh+aMS9Di+SMx
	ie1OVCeZcY9Up7oXQN+KIauavGPj3Qk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DjEm3XUR;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787068198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O29WTaUjniaazmvc0G9Gs9N2gTRaT/iDFSjz7U1NMko=;
	b=1eaJ4XYRo+IB4qS98ZVbUYz+1WUrbpX4thxVHCoWHFKB9d+hqWHRZ3gx0za6aD2fT9l7fr
	ecP7w4ubvY2FNKm804iJc0pODxdR2i8Iy91GgDK9wawxx/TmCMtCWzH20DmXE9VezUqb9d
	2lKh7Zc0ySiEKqNx7PWjrr34oX9kJyM=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-451a49abd8aso57967fac.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787068197; x=1787672997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O29WTaUjniaazmvc0G9Gs9N2gTRaT/iDFSjz7U1NMko=;
        b=DjEm3XUR7yTjCl4fQhNqBVCmkDPJye3+jJsYFfIJ+sZndR4+E3JwepaHYecb088wjN
         lmsK7NosDVD6+vxGM5oOpl78dPz/jM3EGEmPSsa+KVyg7UmbGffLfrcZW9ys8JX6CfY+
         MVMnEUwOxQ+UWx/v5nn17UK+iPAIHRpHPfEvzkUFVwM8vx5wvEEXLLZ9ULqjWijBo4qH
         tf1KfRKF364QOEf6qjwU00x9C1zoPohp5Fctb5GRS0IW3EMaR0jkSZ5ihhoXVTRA2mba
         7HOPu9N2K+OXF6tnapLPhABkKBMUuBwK+/k1ZFcwaiVT6WBXtSuyoAnbSkrexScvct6r
         GtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068197; x=1787672997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O29WTaUjniaazmvc0G9Gs9N2gTRaT/iDFSjz7U1NMko=;
        b=YPeEbFagoRdQuPxUrsshl+N2S0JENQ+layA5vtPy7cBC6m6wLHggUYHa5pWBjT6aYG
         /Nr3H7VZUoc4BUTFiI2bcphv2icUQ53BYuN9zHtvmxz613q+r9i3OVf8Y0fqrqdukRUR
         OcYXqQ0wP3vFQ0dV6cB4+LYeqyjVoxIYslYPq09cTQY54RTyEPebg0nDCABmz89hYmaQ
         KixRWQ0OG6r6MyCb+FygRE7Ez6SZvIyfs8vgSOO6IKUnFoBKGo9qbfrT4rF8oUm1SGuY
         b51fkUzbMurCaHE7O1bYGes6Y7kGE0DUxdMIJiTYqsh5M10GvCJOsTCY2CLVX0ZKU/E6
         2sKw==
X-Gm-Message-State: AOJu0Yxh1Lma/J9aSpCGVvsbgILDbcBXj0vSDe13FWfJvNyIVU0w4MDK
	0V7eIks8JhNYuuwkcdRGmVZEQG7ur1CZpHrzHiYWOn7F5YVBG0NlI618
X-Gm-Gg: AR+sD13M/1tYaeAT1f4q+RanonrYYdaF3ejlfYYw89m9TB1yLtp3g5S4BAZKELDtu46
	41YowXdwjReoIBdbzMIxLFiQ4liIXlOCJshsNNPUe+j3x4kvSBuqG1dGqI2Ij3wDEs+GoAZnHNC
	BGF79JgfqqY5ZNQr7P6ydghNbdkXkdKzEeYUYbG+3wM+9WAzhAvAL0gfSZrLazgltIRt/KpZCXZ
	+d/lTcDbigDIfR+CjshThZbgs2zxcDEsFu3YURBv8sLMNeNHu2vN+9Q2Gw4v9ihO/AyvJX1IEMy
	cLDXqfUamMwp2o5UTCNaQUf4sPpDEYosOx3FWlHglrobVMlwLswhG1h7hZqOgMRuy/kk0vsB1Fh
	UW+YNWzO41u3w4cadojIbHsp5iL6ZiOEs33/EtGbuhXhJwVFBFCAogfJORUbldEa4j2DyyCubQM
	h98yxj+3l3WQ+lVrhP4RgXL4sRymF+Sfq6AcehZKWlNv4Mt0eL1WPqfi8sX+ANBvlZUpoZzthJH
	6gRhtB2IzqYJanNLH4=
X-Received: by 2002:a05:6820:1795:b0:6a3:bdc5:591a with SMTP id 006d021491bc7-6b0d6919fd2mr29904034eaf.32.1787068196884;
        Tue, 18 Aug 2026 08:49:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1166bc727sm5033553eaf.11.2026.08.18.08.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 08:49:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: liuqiqi@kylinos.cn
Cc: linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 08:49:53 -0700
Message-ID: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43C50A0002
X-Rspam-User: 
X-Stat-Signature: 6gpmamnz489mkdr4gq3tfcj5mdgkyans
X-Rspamd-Server: rspam06
X-HE-Tag: 1787068198-116787
X-HE-Meta: U2FsdGVkX19Vvlvc6st2kia4GAHGQNXeFSQ5BdkVMGrRim0+Wa61wgba6jMqVxBncwII2X7yTELJMntljlfSJcqTbp85ihpMCme9VAIeGQohg2bQF12HL70SjEt76y42/aYSInMM3yMqdNEjPI9+yn+2+rr5vVP3Bbec33GlmFGTLtf72rOiOLikOq+5wb1/jV8Eb5pjTLBHVUoLVLskKewErLEQsH5fellDGOw3wZdMneQBncA/xu5gTOt2o1SCvd31KqY23Kds53nyccV2tYV8kO1S4hUxlDZWpkjDLe+UtAthnDmNN4j3oCBxHrux3y5NJtNDMwkPAr2jqhY0U/ZSqmGnmXH7disR0IC9sAe6Hz5NhCaLpOYvphZSAjHcbkRJOiwz+yDBNGHj5bvgtXOzKs/5KLK8Fb7I/cqHUmb6Fw//pAs3wdSRO6dF0P4rGAx5xcFsEHv4E1qOsOQg+yEvMLO0fH0eFQoG6yj9SgnxEnVdyDJNl2Kl5r9sSaXlMM8A9N/zt9N6QxNOy9H16nTU2SukFpodU9LchiTrlK4oz0+DlLQRigWeoUtoA8UNVUPT4MSEpDTyyTDEXljlRrNpegCb3Vp3uKdFnIKYQPTL0Myc42xfySeoSXWLKUirzB5hDtf+/NXJVTixmFb+RvOL6iCGCS7EzgyCrtN1OfkpHL8l26XiAOpgHV+EvElI6R/jFX7WAkHzoi50KIDqr1QCXvhkB7yeNp2gMK4t3d58FbtHlIFuz2W47svgkni2v6XoBrM5NoZHyrMAHjdQzP+h+We4bsn6CIGCy2xSDdOOduhzkd9N6mGLDsh381nquA/8FK/D7XeTZ3yuhMGB0MS4O5MmJvgwKb4fGI7toKbbY2S4uXwBHL2VdCt3hr5W8hDCwdReVfLAPJ9RHBNzmM+WFvK+rjCGAZF2W10UVZGHo3ZCDBHRfHD3gQ4tuxmlfn+qr1ZCsCAVHk/2keB
 Wd3/J3/5
 MFLYV3CmUUBUTaQx/P4KUtzvm0s3jdi1Pd/A+23YAzYo99DAyzxFKVr/Drf5rcpd7qJAyyKg3+OhDedxrtu17a/WTHA3BS0wpBGVNprmqaYPpA+b8TcJqdaGV+fnzcWz1egSzBJwFdcrVVB9kqKkN4TareCObM/BnTp8bgbhee09JrnPuIuG/mgAftoqDRJ6UVPSpES+zjeq/3gb661d51xyuxneGyNed78wIZkdlu7WA2Lz8k3WZKfggifz6JLuhXTf/qb6rPaM+ld8NRrFm+DVODXe7Z6K2j7LeT8/t2zjI8DqX47xTLF6Br1T4GPeGyEEyNvPt+DACYvFH1ZJfaHVgmhqPF0OYFi1ffrKljRJcKo960ZQwVIA0K3CLCka6BWrV+fJrRITRi5ggsQya/wlyVloyasfjjky0wzifvCFLIHG5qgOKT3kM2qDicDJaoauMDvJmeJcofAqUcBnGebhf664h8B4INpQ4T1XhIYf4I795G6QcLK8DFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 10:31:13 +0800 liuqiqi@kylinos.cn wrote:

> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> This RFC introduces per-tier memory cgroup accounting. Each cgroup
> tracks its memory usage per memory tier (e.g. DRAM, CXL), exposed
> through a new memory.tier control file that reports per-tier usage
> and accepts independent high (soft) and max (hard) limits per tier.
> By default these limits are auto-derived from memory.high / memory.max
> based on per-tier capacity ratios, and can be manually overridden.
> 
> The implementation integrates with the existing memory tiering and
> demotion infrastructure. Per-tier usage (anonymous and file) is tracked
> via dedicated page counters, and cross-tier migrations (e.g. demotion
> from DRAM to CXL) correctly re-account charges. When a tier hits its
> high limit, async reclaim is triggered within that tier's NUMA nodes;
> exceeding max enforces reclaim scoped to the tier's own nodes, or OOM.
> 
> The feature is fully opt-in. When disabled, no extra counters or
> charge/uncharge paths are created, memory.tier reads empty, and there
> is no measurable overhead.
> 
> Why per-tier limits?
> -------------------
> 
> On tiered memory systems, memory.max constrains total usage but cannot
> express "keep fast-tier usage under X". Without per-tier limits, a
> workload can monopolise DRAM, pushing other cgroups onto slower tiers.
> This series gives each cgroup independent high (soft) and max (hard)
> limits per tier, exposed and set through a new memory.tier file.
> 
> By default those limits auto-derive from memory.high / memory.max by
> capacity ratio; writing memory.tier pins a tier.
> 
> This series takes a different approach from Joshua Hahn's toptier RFC [1],
> tracking a separate page_counter per (memcg, tier) for N-tier support and
> exposing writable per-tier limits under a cgroup mount option.

Hi Qiqi,

Thanks for sending the series. I'm glad that there is additional interest
in making tiered limits in the system. In this series, I do see a lot
of duplicate work with my work here [2]. It looks like you cited [1]
which is an older version of the series that I sent out. Notably the
new version has N-tier support and a cgroup mount option.

Also consider my series in [3] where I am moving stock to the
page_counter level. It's been a while, but I'm hoping to send out a new
version of that series next week.

With all of that considered, I wanted to know what differences your RFC
here has with my series. From where I stand, the only difference I can
see was making the limits exposed / writable, which was an explicit
design decision that I made to de-clutter the memcg tuning space and
try to make the mechanism as transparent to the user as possible.

The other parts of the series (per-tier reclaim, per-tier-memcg
page_counter accounting, auto-scaling high/max from memory.high/max)
seems to be the same as my series.

Rather than duplicate our effort I think it would be best to foucs all
of our effort and the maintainers' effort into discussing the design
decisions for the series.

Joshua

> Patch structure
> ---------------
> 
>   1/8  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   2/8  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   3/8  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   4/8  mm/memcontrol: add per-tier charge and uncharge
>   5/8  mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   6/8  mm/memcontrol: add memory.tier control file
>   7/8  mm/memcontrol: auto-derive tier high/max from memory.high/max
>   8/8  cgroup: add memory_tiered_limits cgroup mount option
> 
> Patches 1-2 are infrastructure (helpers in memory-tiers and vmscan).
> Patches 3-5 add the core accounting: counter lifecycle (3),
> per-page charge/uncharge (4), and stock batching (5).
> Patch 6 adds the userspace file. Patch 7 adds auto-derivation. Patch 8
> gates everything behind a mount option + kernel cmdline, so the feature
> adds no measurable overhead when not opted in.
> 
> Usage
> -----
> 
> Boot with:
> 
>   cgroup_memory_tiered_limits=1
> 
> Or remount at runtime (affects newly created cgroups only):
> 
>   mount -o remount,memory_tiered_limits /sys/fs/cgroup
> 
> Per-tier limits and usage can then be read from and written to
> memory.tier.
> 
> Scope and limitations
> ---------------------
> 
> - Only LRU folios (anonymous and file pages) are tier-accounted. Kernel
>   memory and socket buffers are not yet accounted per tier; support for
>   these is planned as follow-up work.
> - Per-tier memory.min and memory.low protections are not implemented.
>   These can be added later by extending the per-tier interface to
>   expose and enforce min/low protection.
> - The command-line parameter mirrors cgroup_favordynmods; automatic
>   enablement via the cgroup mount path is left to userspace.
> 
> Testing
> -------
> 
> Tested on QEMU with fake NUMA (DRAM tier 4 + CXL tier 22), with
> cgroup_memory_tiered_limits=1 on the kernel command line and demotion
> enabled.
> 
> Set up a cgroup, apply per-tier limits, and run a memory-intensive
> workload:
> 
>   $ mkdir /sys/fs/cgroup/mycgroup
>   $ cd /sys/fs/cgroup/mycgroup
>   $ echo "tier4.high=200000000" > memory.tier
>   $ echo "tier4.max=300000000" > memory.tier
>   $ echo 1 > /sys/kernel/mm/numa/demotion_enabled
>   $ cgexec -g memory:/mycgroup ~/stream --ntimes 5 --malloc &
>   $ cat memory.tier
>   tier4.current=296488960
>   tier4.high=199999488
>   tier4.max=299999232
>   tier22.current=1625464832
>   tier22.high=max
>   tier22.max=max
> 
> DRAM (tier4) usage stays under tier4.max (hard limit, no OOM) but exceeds
> tier4.high (soft limit, suggesting that async reclaim is in progress);
> CXL (tier22) absorbs the overflow via demotion.
> 
> Also verified:
>   - tierN.current tracks per-tier usage (anon + file).
>   - Cross-tier migration (demotion) correctly re-accounts.
>   - memory.high / memory.max auto-derives tierN.high / tierN.max.
>   - Manual override (writing a number to memory.tier) pins the limit.
>   - Tier max enforcement triggers reclaim scoped to the tier's nodes.
>   - Feature fully off (no mount option): no counters, no charge/uncharge,
>     memory.tier exists but reads empty.
> 
> Open questions
> --------------
> 
> - Should kmem/slab tier accounting be included in this series or deferred
>   to a follow-up?
> - Should per-tier memory.min and memory.low protection be part of this
>   series or left for later?
> 
> [1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Qiqi Liu (8):
>   mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
>   mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
>   mm/memcontrol: add per-tier page counter infrastructure and lifecycle
>   mm/memcontrol: add per-tier charge and uncharge
>   mm/memcontrol: add per-cpu stock for tier charge/uncharge
>   mm/memcontrol: add memory.tier control file
>   mm/memcontrol: auto-derive tier high/max from memory.high/max
>   cgroup: add memory_tiered_limits cgroup mount option
> 
>  include/linux/cgroup-defs.h  |   5 +
>  include/linux/memcontrol.h   |  26 ++
>  include/linux/memory-tiers.h |  12 +
>  include/linux/swap.h         |   6 +
>  kernel/cgroup/cgroup.c       |  21 +
>  mm/memcontrol.c              | 786 ++++++++++++++++++++++++++++++++++-
>  mm/memory-tiers.c            |  58 +++
>  mm/vmscan.c                  |  26 +-
>  8 files changed, 936 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.0

[2] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
[3] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/

