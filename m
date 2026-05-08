Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDE3CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7806B017C; Fri,  8 May 2026 11:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE726B017D; Fri,  8 May 2026 11:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3E26B017E; Fri,  8 May 2026 11:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9A26B017C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:15:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 960CD120177
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:15:08 +0000 (UTC)
X-FDA: 84744600696.08.850F7C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CD71040015
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:15:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Un9RRV3z;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778253306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6puLmfwo0JUKi+ScwU1XEK0lCS2ZAb5s57Qvn4Zuoc=;
	b=SspUmuyRszU6qAxots335uLt8Nk+DVrondHXBku0FKxlBcb+pooqdn665hdm/RvvIkgm1n
	hIugXdQnTn5T1X/ldpkCY4BzJ18W8Mw0GWgWH2x0Z7Xy/g09rC6FLD+ZUGp4kO/4zrrc/w
	lMLIgd1dbVaPnQc5JPt7fiXPKzl52EM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Un9RRV3z;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778253306; a=rsa-sha256;
	cv=none;
	b=op/dL5PP1+3WDNpTuxSkguErMQC2tcWZ2B39FjzF6GKBI8wu75GUi7PB67PI8kh8lHRrF4
	W89dMBB7c4pzHWzGYdkSRi0fdSg6RZLRZiQ/1kkukhFyxFJbBMzBph8pJWjMOu3278M9Ty
	CrHZ/hZ2OgWoB0At6ib3d9RSPdHsF3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BB606024D;
	Fri,  8 May 2026 15:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D8BC2BCF5;
	Fri,  8 May 2026 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778253305;
	bh=mhumYvyD+/uwFXTOvsTEGXrAqYN095YRK12Bho+zCN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Un9RRV3z524pe2eoobJaYqj8I0rbgPBi8jCkfV0/FD7vuSMI51oUvlD8v5afMZeBo
	 W4SUCd87Y6C6V4/x7LHF0rnljemyShs9IsoV7iAZXZqke0Fcy/mhIyoo4qYSZbj0cM
	 PJilKS8tHIXG3g9KnNVxWaWmX06cx543u7VmAY6YghHXbAAtsRVS8mInL/0Sx4edcC
	 se5yZ1XB1rRBZMwBEFs2MT97gg5ifAwUHGXKCsg1FN9Owr0wtq1N3CySIUcv1q95n6
	 EjB+QZxWd3hCvJjxnoRPWC61H/hDSk8CS768qMDT4iyPAp6hjLUIXOJPE+NdAACjeW
	 28I32vPYaJPQQ==
Date: Fri, 8 May 2026 16:14:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, roman.gushchin@linux.dev, 
	inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev, 
	dev.jain@arm.com, laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make
 mTHP more transparent
Message-ID: <af376QFXC36uf7kp@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260508150055.680136-1-vernon2gm@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD71040015
X-Rspam-User: 
X-Stat-Signature: 47oxgndywjqt4bwkew5emzxct3hrthcy
X-HE-Tag: 1778253306-789004
X-HE-Meta: U2FsdGVkX19TFvp333IM8RzAvjvO9IdbPfpIvcnbH1Rscu6GwDEotAfyGwBbnmokC1BlnC8yZBPTJ0cb19l4qidqboXZ2rh4N0ItfmoOKwzS8EjNn043E0z1Snukzu+okCzsPqKyCz8is2y/io3y/WBQmbZdvKcukJEBj5s+XjcUPysxtRIbPrRcZfVfGzQbN2HLHON4C9y0C91yCvpMz93F2c6YJ0ZtLLxJDZKny9NvOajySO3ezKtEnZ225Puk2Cj8TzLM/nIJxWLcNElQ24j/0wN3LVpzjQcwkREf5eFdTx1qTOJAEIY1SSryTZ/SaGpcP82ZEC81bmVGoMQ5OCh7Z0yAGJMpDLqiD3Ptkg++JCd1KQElm8BP6cdM/kvoKina9fXbHReCYpu6kDi7cuNdSD2rXAYTut7sIB7OEg0m/7MnzDUrdqUl2ul6LBs0KUrBUSs3X/OhPGBK9/soU559cMHJxmgtT6APskjdcdbdc9J+bK5p4Obe/S6EbS7iFCFdl+PAat0/+/MCN4W04bfu3QpaoRigzy/axIMUfgA0N158JPJmlRWg80iyvpgo0Mns6LYuhMHsXNEyfdmc/fpXGBR3ncMmQkumHWd05UDVsMDEr8pWVsxLORm1Lr9rnrUwKXzT0+MHNO6RYAo2ny1LSyK0+JJrscGeptrZYRtMSHCdTL5aMU8qaXzxG/60xYUrXn4BU1b6trwaUJN/jOKPYX8rGit0ISYw3vi3Yq5nqNBUoScPCV371eXmFED97O7y/r/pIljFUY7Weo/D0qDhrosPrzV1ODVtZhGtPhjIkJhl1cwrOfEt0pVCItBS4q6fGuyi+oZo4d/cryXj0bwP1gVX5XlTXVC2Jma7C3Hzjaw6tuTRYpeaDMXXRX1Q/HfDk3cfFFDM5PT9U8MsVRNptEyKThf0ZK1NfHG6v6cokcpHftDtI6MA6c4pZXGmWC+SRBM3oIA26xWQ1r3
 zWhrBsGG
 OpocQAsndRSy3K06BRFC5/0l1Zta/ITBrUaJxqzh/GWM3+60a40jRSLmtbS0cSww0FXg7sOMpH6UUpNXxwa8hpqhMI7HQGlGOUGOZIOwVJnAJRFJJTyJMM+elkt50xI4MFmZofPkf8alef6DJpVsKzjs8qWNWjZ717ou5ZTbHGXfoCbrOFcOgQmAcsm36BmSloTOxtI+EtLrQWnwkj9fJhmNqJ4mCMDEh9saM1Sp32D1IaIjFNcxno1vTk6qm8zz/0ubzdg688mvQ2X8njqpqFRSgV+rYitWoccDcYt4f97Q9SwOrnbaURoqZmbh2K/qOKVRD+u6FB0EQYGzHzkNrH2MBtQDFLIa9tk2SVXDlrLib2RN/8sLnC9rLLYhvzmrJtkjAj4EFtD6kla0U+gQiVXxMSrBKI0EohRDbpES+BpLoDE+iCpjpX/995uyb8QcaidEFAl5szWcQfWe7ATGvlwbXvPf6OpQ4fa+qcswcZbePXAj9Ho1hIINddgInhV69NjZxwHaFMn1LJuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the series, but overall it's got to be no to this until THP and mTHP
are in more stable shape.

And this is an RFC, you're trying to make really fundamental changes here, it's
almost... rude to do that out of the blue non-RFC'd (unless you're a maintainer
perhaps).

Right now the THP code base is a total mess and mTHP support is not even
properly merged yet (khugepaged support outstanding).

BPF interfaces are permanent, we've tried the 'experimental' thing before, it
doesn't work and we'll not be able to yank it later.

I've said it before, but we really truly need to get THP into better shape
before we can tolerate large new changes, let alone an user-exported interface.

So can we defer this until we're in better shape, and then send that as an RFC
first please?

On Fri, May 08, 2026 at 11:00:51PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Hi all,
>
> Background
> ==========
>
> As is well known, a system can simultaneously run multiple different
> scenarios. However, THP is not beneficial in every scenario — it is only
> most suitable for memory-intensive applications that are not sensitive
> to tail latency. For example, Redis, which is sensitive to tail latency,
> is not suitable for THP. But in practice, due to Redis issues, the
> entire THP functionality is often turned off, preventing other scenarios
> from benefiting from it.
>
> There are also some embedded scenarios (e.g. Android) that directly use
> 2MB THP, where the granularity is too large. Therefore, we introduced
> mTHP in v6.8, which supports multiple-size THP. In practice, however, we
> still globally fix a single mTHP size and are unable to automatically
> select different mTHP sizes based on different scenarios.
>
> After testing, it was found that
>
> - When the system has a lot of free memory, it is normal for Redis to
>   use mTHP. performance degradation in Redis only occurs when the system
>   is under high memory pressure.
> - Additionally, when a large number of small-memory processes use mTHP,
>   memory waste is prone to occur, and performance degradation may also
>   happen during fast memory allocation/release.
>
> Previously, "Cgroup-based THP control"[1] was proposed, but it had the
> following issues.
>
> - It breaks the cgroup hierarchy property.
> - Add new THP knobs, making sysadmin's job more complex
>
> Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
> following issues.
>
> - It didn't address the issue on the per-process mode.
> - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
>   the same objective, there is no need to add two mechanisms for the
>   same purpose.
> - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
>   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dying
>   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
>   implementation.
> - Unclear ABI stability guarantees.

Not unclear, any BPF interface is permament.

> - The test cases are too simplistic, lacking eBPF cases similar to real
>   workloads such as sched_ext.
>
> If I miss some thing, please let me know. Thanks!
>
> Solution
> ========
>
> This series will solve all the problems mentioned above.
>
> 1. Using cgroup-bpf to customize mTHP size for different scenarios
> 2. Use a cgroup eBPF program to monitor all sub-cgroups. Sub-cgroups
>    under the same parent-cgroup adopt the same eBPF program. Only multiple
>    sibling-cgroups (where the parent-cgroup has no attached eBPF program)
>    are supported to attach multiple different eBPF programs without
>    breaking the hierarchy property of the cgroup.
> 3. Automatically select different mTHP sizes for different cgroups,
>    let's focus on making them truly transparent.

I don't see how cgroup level control is transparent :) this overall seems like
THP control at cgroup level by the back door, and I thought the cgroup people
were adamently against that.

Personally I think we should actually allow less 'transparent' THP but that's a
debatable subject obviously.

> 4. Design mthp_ext case to address real workload issues and further
>    clear/stabilize the ABI.
>
> The main functions of the mthp_ext are as follows:
>
> - When sub-cgroup is under high memory pressure (default, full 100ms 1s),
>   it will automatically fallback to using 4KB.
> - When the anon+shmem memory usage of sub-cgroup falls below the minimum
>   memory (default 16MB), small-memory processes will automatically
>   fallback to using 4KB.
> - Under normal conditions, when there is no memory pressure and the
>   anon+shmem memory usage exceeds the minimum memory, all mTHP sizes
>   shall be utilized by kernel.
> - Monitor the root-cgroup (/sys/fs/cgroup) directory by default, with
>   support for specifying any cgroup directory.

This seems like something prescriptive rather than 'bpf lets you make a
decision' and cgroup-level THP behaviour changes? It seems really out of scope.

>
> Performance
> ===========
>
> The below is some performance test results, testing on x86_64 machine
> (AMD Ryzen9 9950X 16C32T, 32G memory, 8G zram).
>
> NOTE: The following always/never labels indicate setting all mTHP sizes
> to always/never. Detailed test script reference[4].
>
> redis results
> ~~~~~~~~~~~~~
>
> command: redis-benchmark --csv -r 3000000 -n 3000000 -d 1024 -c 16 -P 32 -t set
>
> When cgroup memory.high=max, no memory pressure, seems only noise level
> changes, mthp_ext no regression.
>
> | redis-noBGSAVE | always      | never                | always+mthp_ext     |
> |----------------|-------------|----------------------|---------------------|
> | rps            | 1431307.083 | 1224004.250 (-14.5%) | 1420053.873 (-0.8%) |
> | avg_latency_ms | 0.216       | 0.256       (-18.5%) | 0.218       (-0.9%) |
> | p95_latency_ms | 0.612       | 0.708       (-15.7%) | 0.615       (-0.5%) |
> | p99_latency_ms | 0.682       | 0.812       (-19.1%) | 0.692       (-1.5%) |
>
> | redis-BGSAVE   | always      | never                | always+mthp_ext    |
> |----------------|-------------|----------------------|--------------------|
> | rps            | 1429093.707 | 1231569.587 (-13.8%) | 1431075.330 (0.1%) |
> | avg_latency_ms | 0.216       | 0.255       (-18.1%) | 0.216       (0.0%) |
> | p95_latency_ms | 0.618       | 0.706       (-14.2%) | 0.615       (0.5%) |
> | p99_latency_ms | 0.684       | 0.823       (-20.3%) | 0.684       (0.0%) |
>
> When cgroup memory.high=2G, high memory pressure, mthp_ext RPS improve by
> 3450%, while significantly reducing the tail latency by 99%.
>
> | redis-noBGSAVE | always    | never                | always+mthp_ext      |
> |----------------|-----------|----------------------|----------------------|
> | rps            | 24932.790 | 976610.893 (3817.0%) | 885337.250 (3450.9%) |
> | avg_latency_ms | 13.173    | 0.326        (97.5%) | 0.367        (97.2%) |
> | p95_latency_ms | 23.028    | 0.786        (96.6%) | 1.511        (93.4%) |
> | p99_latency_ms | 366.762   | 1.183        (99.7%) | 2.975        (99.2%) |
>
> | redis-BGSAVE   | always    | never                 | always+mthp_ext      |
> |----------------|-----------|-----------------------|----------------------|
> | rps            | 50551.567 | 1026720.293 (1931.0%) | 892643.707 (1665.8%) |
> | avg_latency_ms | 6.581     | 0.310         (95.3%) | 0.365        (94.5%) |
> | p95_latency_ms | 16.730    | 0.772         (95.4%) | 1.447        (91.4%) |
> | p99_latency_ms | 311.551   | 1.140         (99.6%) | 2.988        (99.0%) |
>
> unixbench results
> ~~~~~~~~~~~~~~~~~
>
> command: ./Run -c 1 shell8
>
> mthp_ext improved by 5.99%.
>
> | unixbench shell8 | always  | never           | always+mthp_ext |
> |------------------|---------|-----------------|-----------------|
> | Score            | 22916.8 | 24304.0 (6.05%) | 24289.9 (5.99%) |
>
> kernbench results
> ~~~~~~~~~~~~~~~~~
>
> When cgroup memory.high=max, no memory pressure, seems only noise level
> changes, mthp_ext no regression.
>
>                             always                 never               always+mthp_ext
> Amean     user-32    19702.39 (   0.00%)    18428.90 *   6.46%*    19706.73 (  -0.02%)
> Amean     syst-32     1159.55 (   0.00%)     2252.43 * -94.25%*     1177.48 *  -1.55%*
> Amean     elsp-32      703.28 (   0.00%)      699.10 *   0.59%*      703.99 *  -0.10%*
> BAmean-95 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> BAmean-95 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> BAmean-95 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
> BAmean-99 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> BAmean-99 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> BAmean-99 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
>
> When cgroup memory.high=2G, high memory pressure, mthp_ext improved by 26%.
>
>                             always                 never               always+mthp_ext
> Amean     user-32    20250.65 (   0.00%)    18368.91 *   9.29%*    18681.27 *   7.75%*
> Amean     syst-32    12778.56 (   0.00%)     9636.99 *  24.58%*     9392.65 *  26.50%*
> Amean     elsp-32     1377.55 (   0.00%)     1026.10 *  25.51%*     1019.40 *  26.00%*
> BAmean-95 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> BAmean-95 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> BAmean-95 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
> BAmean-99 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> BAmean-99 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> BAmean-99 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
>
> TODO
> ====
>
> - mthp_ext handles different "enum tva_type" values. For example, for
>   small-memory processes, only 4KB is used in TVA_PAGEFAULT, while
>   TVA_KHUGEPAGED/TVA_FORCED_COLLAPSE continues to collapse all mthp
>   size. Under high memory pressure, only 4KB is used for
>   TVA_PAGEFAULT/TVA_KHUGEPAGED, while TVA_FORCED_COLLAPSE continues to
>   collapse all mthp size.
> - selftest
>
> If there are additional scenarios, please let me know as well, so I can
> conduct further prototype verification tests to make mTHP more
> transparent and further clear/stabilize the BPF-THP ABI.
>
> If any of the above the strategies can be integrated into the kernel,
> please let me know. I would be delighted to incorporate these strategies
> into the kernel.
>
> This series is based on mm-new + "mm: BPF OOM"[3] first four patches.

Again, this really should have been an RFC, a 'TODO' section shouldn't exist in
a non-RFC series.

>
> Thank you very much for your comments and discussions.
>
> [1] https://lore.kernel.org/linux-mm/20241030083311.965933-1-gutierrez.asier@huawei-partners.com
> [2] https://lore.kernel.org/linux-mm/20251026100159.6103-1-laoar.shao@gmail.com
> [3] https://lore.kernel.org/linux-mm/20260127024421.494929-1-roman.gushchin@linux.dev
> [4] https://github.com/vernon2gh/app_and_module/tree/main/mthp_ext
>
> V1 -> V2:
> - Rebase on mm-new, run all performance tests again.
> - Register eBPF programs only when no mthp_ops exists in all sub-cgroup, do not
>   destroy the cgroup hierarchy property.
> - Fix newly created cgroups silently bypass the hierarchical BPF mTHP policy.
> - Fix bpf_mthp_choose() UAF due to improper SRCU locking.
> - Add bounds check in bpf_cgroup_stall() and fix return type to u64.
> - Check cgroup_psi() return value.
> - Fix spurious mTHP fallback during initial cgroup scan due to zero-init
>   info->stall.
> - Fix info->order being set to 0 when no processes are running in the cgroup.
> - Fix Compilation fails when CONFIG_CGROUPS=y && CONFIG_PSI=n.
> - Fix NULL pointer dereference of st_link.
> - FIx infinite loop in trigger_scan() when read() returns an error.
> - Fix integer overflow in FROM_MB() macro.
> - Fix setup_psi_trigger() fail, but masks the error code.
>
> V1 : https://lore.kernel.org/linux-mm/20260503165024.1526680-1-vernon2gm@gmail.com/

All well and good, but I don't see any actual review there, another reason to
send this kind of thing as an RFC first please :)


>
> Vernon Yang (4):
>   psi: add psi_group_flush_stats() function
>   bpf: add bpf_cgroup_{flush_stats,stall} function
>   mm: introduce bpf_mthp_ops struct ops
>   samples: bpf: add mthp_ext
>
>  MAINTAINERS                     |   3 +
>  include/linux/bpf_huge_memory.h |  52 +++++
>  include/linux/cgroup-defs.h     |   1 +
>  include/linux/huge_mm.h         |   6 +
>  include/linux/psi.h             |   5 +
>  kernel/bpf/helpers.c            |  34 ++++
>  kernel/cgroup/cgroup.c          |   2 +
>  kernel/sched/psi.c              |  34 +++-
>  mm/Kconfig                      |  14 ++
>  mm/Makefile                     |   1 +
>  mm/bpf_huge_memory.c            | 168 ++++++++++++++++
>  samples/bpf/.gitignore          |   1 +
>  samples/bpf/Makefile            |   7 +-
>  samples/bpf/mthp_ext.bpf.c      | 148 ++++++++++++++
>  samples/bpf/mthp_ext.c          | 339 ++++++++++++++++++++++++++++++++
>  samples/bpf/mthp_ext.h          |  30 +++
>  16 files changed, 836 insertions(+), 9 deletions(-)
>  create mode 100644 include/linux/bpf_huge_memory.h
>  create mode 100644 mm/bpf_huge_memory.c
>  create mode 100644 samples/bpf/mthp_ext.bpf.c
>  create mode 100644 samples/bpf/mthp_ext.c
>  create mode 100644 samples/bpf/mthp_ext.h
>
> --
> 2.53.0
>

