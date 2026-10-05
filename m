Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFC6CA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 20:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7436E6B008C; Mon,  5 Oct 2026 16:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BA16B0093; Mon,  5 Oct 2026 16:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6590E6B0095; Mon,  5 Oct 2026 16:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3386B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:45:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C03D0A0420
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:45:51 +0000 (UTC)
X-FDA: 85289754102.13.EA03FB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CDC0CA000C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:45:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nnuELlo/";
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791233149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLFOoYWWtnRY6Ceo7GoZb6AHkD3ORrSQ4V9OneUN+Ow=;
	b=57CQCaiGQdh9vaGFhtuUk41gzRtKloEsat77roHZE5oOlJ6RBUiziLLKJk4TRGDBYL62ky
	vgAd6d0wi3hE2LRI8R97rtr8RQgjeZUase/GHpl3yE1YuXdpWF7iOxaAlKTN7pypCJQyXP
	88xDE45r3fKum/RAxaFakffqd5p8j4w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nnuELlo/";
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791233149;
	b=S1uoukbq9CzBL3nJjmx2czzNa5R5mAar4acCVohcjKLupXtkBJ0oBpq9k68iONn+kWaRoD
	u02LAStnnZKBw0lmJVLCLwUdQuDUtwPNnS1sKYqxVjXYwevqYPK3ka1//3H59MXso2oGqX
	6eYTgSZzu/rzi6x9svOhrDWbpJk4gMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD22043F9B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72251F008A1
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791233148;
	bh=NLFOoYWWtnRY6Ceo7GoZb6AHkD3ORrSQ4V9OneUN+Ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nnuELlo/mACSEwSUq3E6UHbBvwkqiJor4R5vdiUQ0PQ9PYoN3BmVH2v7zEKWsUfvs
	 PKPYRDW0hNp3HncNPCbgpu0D0BmbQlnqnBslDQdPWv+n7uSy+SXYSkKvbDZ/v7u6o2
	 otWP6/qYKlVDx3yKhcet53nAFnf12R4Qd2OVI/mP02xVfjMGN4eXYqStxf/liS5Hpq
	 0d6eQRLyA2QknqU+u4te6ymfN3uZCQzfbSHqxfmon8GYiUn04s9wRsAMPg/zofaDUB
	 vlqUqVdk8QAG0xQOt82im8ryWm1q3/QFQraLFWaqNiL3mzC49m/qFB+fA4bzfMPfCK
	 riRUoA1EOIxMQ==
Received: by mail-ej2-f40.google.com with SMTP id a640c23a62f3a-c2e417a5a81so370864666b.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 13:45:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxTorIs1YGE+ETZyqE/YrCtTjT7TxchWZboVQT8nDzapEGsG5DY4IyGzpe940ZcbqGnUWwgXaTaZw==@kvack.org
X-Gm-Message-State: AFuF++mV5mmMdyyyz8RjnusrFqw6rFsAjUjec0babNPwIUhPn3pDCJGZ
	mtosIsnZHvSf43C3fmNY6Xdlfgil97L0QEN1C48PwNS30a6ZNXru5MRawzv6LrkENrbPLv+kgzl
	faWxSA/3jFU5BBu5i5hcEK6DMdygTDaM=
X-Received: by 2002:a17:906:f594:b0:c29:53ba:a4cd with SMTP id
 a640c23a62f3a-c2e4ad13e7amr997364966b.11.1791233147408; Mon, 05 Oct 2026
 13:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com> <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
In-Reply-To: <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 5 Oct 2026 13:45:33 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
X-Gm-Features: AclHuK9bsxnzrNzCEGYxM5xbrCEvC4kIDgtRMWmkPhx27BYSlzrkiZ8zssPr8fA
Message-ID: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: James Houghton <jthoughton@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CDC0CA000C
X-Stat-Signature: agjkc3xazr38omeankma8nkf9j334o5r
X-HE-Tag: 1791233149-269420
X-HE-Meta: U2FsdGVkX1+vveUJzFG0IcuISekkhyAYZUfQaU8HuRVcByi/wN50A+HMaMI9SaVZ/XOJkf1ZODD5PMXT09ArWQcKDRt/dVBadUN/UsIxssSul1Cu9X+ljThsln0LyavjMtwPWwdCIgLiHdja8Jn6anaJcnlN41/HfN9EwTk7FgcH8Z6v1vADT0A86I1JOoyXzCSN1r0LL7Zb59caXzj29u0m4Ar0mlwaFLIKFdJfnFRHFSHkkEE7KRG5wRZAgk2vmqirWB+LtjamL6ZOewP8Q/Ge3oirA6oN34qE35l/VPUtjdA+IW5RwCEBj2vC/I1sOEax5/U2iLfgSzaMy8kiSNziyqnaLESWjeEdsEhnjlilfuZB1VwkdvCz9pd/P+yJVuaHN2ESuci51PgayhLytesWohF85+aliqvrMK3NWa+dE5fKAkzMc7AHUPM8gk7dNwu5eQcrHW4Oa8pBe80e3wnKBoQoqnhva9IBCT0/qJRc7cuOxSTYWGA/ldjMpSvL7f7MXHou1Zo1Y7kV9xI+xHA2wyKyJcpCeb0ewsFOsi33ReeX3rfGNyem1S9DWGAI3s7FQ7xyk6czHETwz0VVSSPTSuE3gh7F9M1aH3MOR8ZAjx+ZXg+ujdmlh0xQMLdkUoBZ97cIGrEOj95opCJ+QA6JDyMf7x01cMYX6MNAkipUWhTZRFEiRcJRCmnR3rEK7xnhlmbHj0bcc9mJmI+D+nvOgtBPmYCPsWjuDxGfrEO9hYnier88r5GV4nzm/BmBfzB6pjBNPE4LcfHAdX69WdtLKK7Ey8GIsPsaxz9ln46YQdBA89PzNT7djAN8u510ReOcd8xknt5DcUFel3DetJzS8Mqd9jBntwh9SSDt+ZF/h1ly56bI2VELp8XtopjXj2MMcAP5v0QbFTqnQJ/39gzsBa14vHgQbTyhXFBeqNIgEct6ZVxuJgp5LesA8IQvx/8clZWKa5lYhpJuCvs
 ZGs2Ak1T
 LkE3sqn+MrY8OT8S3WayV5Z3k3awzxriDsP/V1HbFuo6I1ep7KeFk1ZxYwsInYiGqlwgAGRqrSjclVJ0zmHwuhffVGrqjccuMx8s4Dhw88UQS+vjR07oyQGAj2fPtHIjCrNVq4VqdVs1oYcVK9HaDU7q41G8SVvU3saA27kzsAIV0wp/CT0udwgXxCDYTUX2zzikiGMuurkngdjlLdo41gLQS7o/NkBPf1r+Sa2RS2Ah8SXFEKC+96j6SORkwIHxLYmgo/rikviKay1kIgvSkGAda6MqDcWzZtny8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I added some instrumentation to prepare_scan_control() and have been
> seeing that the OOM gets triggered in this pathway:
> a) the memcg is created with memory.max set to unlimited. 512 M gets
> faulted in. The new anon folios get put on the inactive list. Nothing
> reclaims them yet
> b) userspace then sets memory.max to half of memory.current (~271M
> from ~542 M currently used). This causes memory_max_write() to trigger
> reclaim logic
> c) the folios have already moved to the active list (my
> instrumentation shows 122684 active vs. 179 inactive) when reclaim
> does the scanning, which means the only way for pages to be reclaimed
> is for pages to get deactivated from the active list back to the
> inactive list.
> d) prepare_scan_control() (which decides if the pages get deactivated)
> reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> (the 2s flusher hasn't yet triggered since when the memcg was
> created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> still zero. The real values are all still sitting in per-cpu buffers
> that haven't yet been flushed. My instrumentation shows:
>         inactive_anon       rstat: 0    actual: 179
>         active_anon          rstat: 0    actual: 122684  (~479 MB)
> e) the deactivation logic in prepare_scan_control() is:
>
>                 refaults = lruvec_page_state(target_lruvec,
>                                 WORKINGSET_ACTIVATE_ANON);
>                 if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
>                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
>                         sc->may_deactivate |= DEACTIVATE_ANON;
>                 else
>                         sc->may_deactivate &= ~DEACTIVATE_ANON;
>
> The if check fails:
>      refaults != prev refaults: 0 != 0      (false)
>      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> inactive_ratio < 0     ( false)
>
> DEACTIVATE_ANON gets cleared
>
> f) pages don't get moved from the active list to the inactive list, so
> reclaim ends up freeing nothing. memory_max_write() goes through all
> MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> (but it's all on the active list).
>
> I saw that the skipped_deactivate retry did fire (on 858 of 4264
> scans), but not enough to get the memory.current back under the halved
> memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> and OOMed.
>
>
> imo I think the best fix would be
> a) for non-root memcgs, revert back to the non-ratelimited version
> (mem_cgroup_flush_stats())
> b) for root-memcgs (which if flushed will flush every cgroup on the
> machine), don't use rstat at all and use the existing node counters
> instead (which is what the non-memcg case already uses).
> mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> stat in the same call. For the root lruvec, the node counter reflects
> the same value and doesn't need any flushing. It has an error bound of
> 125 pages/cpu at most, but this is tighter than what we currently have
> with the ratelimited version.

This seems like the right thing to do. If we have global stats, we
should avoid a rstat flush. I actually wonder if we should start
systematically eliminating root flushes, and if that ends up being
good enough to keep everything else as-is for in-kernel flushers. The
flush in zswap_shrinker_count() is also a good candidate, we already
use global stats when memcg is disabled there as well.

>
> commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> reclaim") was what switched vmscan to using ratelimited flushing. The
> reason for this was to fix the stalls from concurrent reclaimers
> contending on the rstat lock. For the Cloudflare case, kswapd threads
> were contending on the rstat lock on 8 numa-node machines. That's the
> global path (eg sc->target_mem_cgroup is NULL,
> mem_cgroup_flush_stats() turns it into root, so this flush essentially
> ends up flushing every cgroup on the machine), which gets addressed by
> adding the fix in b), which takes kswapd and global direct reclaim off
> rstat entirely. For the non-root memcg case, the flushing is bounded
> by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> memcg's stats_updates only accumulates its own subtree's updates, so
> it takes a lot longer for it to be exceeded than the root's does).
>
> I ran some benchmarks to get a rough idea of what a) costs. I set up a
> workload that allocates 512M of anon memory in a memcg with memory.max
> set to half of that to trigger reclaim continuously. I varied the
> number of threads touching the memory, so that N of them hit
> memory.max and enter direct reclaim on the same memcg at once. I used
> bpftrace to measure the time spent inside css_rstat_flush() and
> shrink_node() and used those two numbers to get a percentage for how
> much of reclaim is spent in flushing. These are the numbers I saw:
>
> # threads      flush as % of shrink_node()
> 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> 64              ratelimited: 0.16%       non-ratelimited: 2.52%
>
> Between the ratelimited and the non-ratelimited runs, walltime and
> pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> pgsteal within 0.2%).
>
> I also measured the lock contention. At 16 and 64 threads, 15-20% of
> __css_rstat_lock() acquisitions hit a contended trylock with the
> non-ratelimited version. At 16 threads, the mean flush time rises
> about 8% and at 64 it roughly triples from the single-thread case
> (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> effect of this on wall time or pgsteal between the non-ratelimited and
> the ratelimited version, and the percentage of reclaim time spent
> flushing stayed at 2-3%. I think that's because css_rstat_flush()
> takes and drops the lock once per cpu rather than holding it across
> the walk.
>
> I also ran it with 32 actively churning sub-cgroups under the reclaim
> target, since css_rstat_flush() walks the descendants that have
> pending updates. I saw that per-flush cost rises slightly (~24 us to
> 27 us) but the share of reclaim time spent flushing went down rather
> than up (4.1% to 3.2%), because reclaim gets more expensive faster
> than flushing does. I don't have a ratelimited baseline at 32 children
> though, because with the ratelimited version, all the runs I tried
> OOMed. I think this is an alternative repro to the OOM issue but
> doesn't need/have KVM dependencies, so if this would be useful to
> clean up and send as a standalone C repro, please let me know.

It might be useful if it can be added as a selftest or similar, so
that such regressions can be caught more easily in the future?

>
> (Also btw (this is a bit tangential to this OOM issue, but somewhat
> semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> checking really does anything in practice. On my benchmark runs, the
> "refaults != prev_refaults" check evaluates to false in pretty much
> every scan. Even with flushing working properly, it didn't trigger on
> 1673718 of 1674912 samples, even though the cgroup was thrashing the
> whole time (a separate run of the same workload counted 6371860 anon
> refaults vs 6523 activations). I think it's because reclaim is
> scanning faster than the refaults counter advances, so it'll almost
> always see no change. I'm not sure how much this matters in practice,
> but I think effectively in that check above in prepare_scan_control(),
> deactivation relies entirely on the inactive_is_low() check.)

I am also not sure about this one. I am not sure if reclaim moving
faster than refaults is something universal, it seems like it would be
workload-specific. Johannes is the person that comes to mind when I
think about these heuristics, so maybe he has an opinion about this?
:)

>
> What do you all think about adding a) and b) as the fix for this issue?

I generally agree. Doesn't really matter much, but I think we should
do (b) then (a) to avoid reintroducing the regression temporarily?

>
> Thanks,
> Joanne
>

