Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3B6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699BB6B0173; Thu,  2 Jul 2026 21:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6723B6B0176; Thu,  2 Jul 2026 21:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC056B0178; Thu,  2 Jul 2026 21:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07BB36B0173
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD2798CEEF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:16:14 +0000 (UTC)
X-FDA: 84944943468.23.0BC9FE4
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E8211C000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:16:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rNgU7ybt;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783023372;
	b=IFybOeChg8V74skBVBGAM6PoBnasl2kO8b7P2Xonbuud7s+90Elf71moe+r5XVZVlTt3xC
	WLNDAXuqIPrh0M87bv/cYbRbsf0GblZMCdmgX8efIo3navAvVib9RY0/JgMfRRy9wnpYzz
	gxK5TaFAKi+br7PuKky+Pdsg7/fo3TE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783023372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmYpiJGo1yl3FmbXB66UdXuPm3pvTnT7eXs8/XbJup0=;
	b=1Nmri1To0/lw8SK5+6NjYx2KGTI5OJNTqF8XIU3mXg2UwulG9ukrBsAP61OOTaYFBDKm6a
	/3ejDv/AXCbkdIjIxqMBLGaTA5hbkKOnop3MFJie46tOELef3unseWEIRfx1LAVcwMmedO
	A8H3q72dCZzOLVV1YeeRG9AoM04IjSw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rNgU7ybt;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c2a76536bso16410051cf.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 13:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783023371; x=1783628171; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tmYpiJGo1yl3FmbXB66UdXuPm3pvTnT7eXs8/XbJup0=;
        b=rNgU7ybtCh0Nz2at2jaRpOMldtiHGAH3lJveGsSjIOTsCN0R1ZZeIwwcitBamstj2B
         Su18C/ksPjYYW9ieDhVDeOt3yjB/x5Q3UD1VCF8eU0TtPdJ2+O+u1oOBVdSp7EPBwqL0
         VazyKhqLwI45MV5ugLZ8GY2B5WNQSpqrxm97J0oKBL5HGLVCAJMJwdpj1vMjBV3oyjiI
         BzLcyndwzrgXYsHfBtDgheJAKXGwTpl+8HEocxAMx0rIfzAMEDml8qDy2PRHKkEvL+TN
         HOe4Shi6KhNFgJC2r0k9ZCL3hOQXrqOAT9rWIcejEqxWr7ZowMrwzltArzkPh2f2aHo+
         n2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783023371; x=1783628171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tmYpiJGo1yl3FmbXB66UdXuPm3pvTnT7eXs8/XbJup0=;
        b=tAS3PUQLtU3dbs8E4pHSnc2aRt2svUuIfqSGF8ofaPs/+ZLGvjZxG48YdqOx2nssG3
         WOxLxnoE+yL3P7OW9QEWUDTWiRka/qZar0dX5jaAuGOE+jkrz4MiwD+7RqEa9KRS62KP
         JVFT7YHFHt9eQ9bBQdGoPh8DztM6lA9Y2qoqcn8MccCifkJImXJadWAodoWOMzI832vk
         c7RflczppMR8whg+/9j/F8RxvtgVvn0IWP+9bZCowdP1Im2lc8zjAV6kM2RFIDHMikIr
         lh6coA2uY4cUHrXSUkhLE5g69q9lPkgSXKN+QNsy0HL1Ztq+GSfePzaLF2b9Sm/HNHAu
         U4ow==
X-Gm-Message-State: AOJu0Ywk+PeLWAW//grjIgfJovvv1meKfpoIz4Or962An1nsQ1iwMMW8
	zaRr8lgF2Ukb/kPsQEbXPBgdVRAIg1wSdS9xXRtgO38Puuv9w1ehkVerL2c70QPSIC6vCs++mm/
	Z/IGMSEQ=
X-Gm-Gg: AfdE7ckpDF/sHW3DxpXTPWBK4yFDTGhbyOzmBO/go+LMUxx0KIkIhs1HqhXmfhfvJSP
	JvL7KUnMmHIKfiQeoFo9VM9MK00QheWLDqjdqKKVCiBBwGWmJE48Q7bDwGctQlP53/jhm3NIsOB
	hAxVwk6QR6y0wk9crV7j9vixPb7qDjhglj0UAusGarkWFrf7G6HABLe6XbQ493Ai2nkiV3hqKVS
	fysr95ml6jJbSs1fg1IC/p7of6AQFv88a0qm8jG2nuNEMtM1fbNbdOBOgc24M1w3MYb/fj+Nx8E
	Vu/AELCcLxziepiVY7LA8U0ZxMkyLxBsiQKhrdjlWzU8uQd4CXA2dq8vpZzvpS8XzLrIcHxVIlN
	CfEfDs1f5KBdDs6pkki/XCbXgrwwUoBLfcbd+zz1MhF0NvwytecLvb+6X0VVqLpXiD/FHyaQZb/
	+5Yu1MKPPjfyGFrurK5seT8A==
X-Received: by 2002:a05:622a:1812:b0:517:7e6e:708f with SMTP id d75a77b69052e-51c26b0f4bamr108570591cf.52.1783023370904;
        Thu, 02 Jul 2026 13:16:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c30c15822sm22003851cf.15.2026.07.02.13.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 13:16:09 -0700 (PDT)
Date: Thu, 2 Jul 2026 16:16:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: linux-mm@kvack.org, nphamcs@gmail.com, yosryahmed@google.com,
	shakeel.butt@linux.dev, hawk@kernel.org, akpm@linux-foundation.org,
	zhouchengming@bytedance.com
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in
 zswap_shrinker_count()
Message-ID: <akbHBZP9HxOJMtQB@cmpxchg.org>
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702180908.150136-1-yunzhao@cloudflare.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3E8211C000C
X-Stat-Signature: d9iwixd4dyh1hwe63rnbjd7iaicib9m9
X-Rspam-User: 
X-HE-Tag: 1783023372-693507
X-HE-Meta: U2FsdGVkX19DaDP4ZyzeNEofcLJa20/fWRS3Hxmq5ybRrEpHzIlMCeYrdjGt3a5IT8YjBOqjAGqGtzmLR3kgyjsZV6qyvzfoViH9h8QW7RIDv5umao2L5TRESeYavVJb3epSknRWXLhmvV0xOKhY0VpklegHR70LLVcBPqRtY4jk/T7xSLYigqDoURCww/UHNGgEiVOej9MWeJXV1g5s2FqEORgL4lX4RACrsDcfJdsK35LKcUXmbVgToa0SHmiMTU5RKCWfyQ1AqG7PWYtgPYXALo3Xn4DlO1zrFWOpY0WkdlPRsmxidjoRz5bxJ8qMOi+KiVDPVZIahVz7ICKqk860X/6L8uFh+Qm9MTHez2ZPULbOh56PsnMOmsARLOA5xdbtG1MvsgkYHLzTWrs8AgxFsA+EyRTsN/nueWqZuBOAEZrdjlXtDmewTWRXyR381KgUYx1nXM/swup890X3z5NgIeqst2QNkEdDiMeKHtcC972pA28mEHwA16yi1R6o8gTk6DPuF97+StxBBOM0pfCCnpQAdF5p8SuYOx6V3zNiVpdwRBODlkScFoDe9tvbnWodO8A/vCEjvWdE3kzEmBZRJFN+g15ILihPmA8P3FVO09KejN0uR7KfLs3Jwp1xjGmmlXohbRvutZixAETQzEPNCBhOLq1QLZ+4bM/9AoWqlXbgt/J0a5pUnxd1L5tx9L1LqrsSIsCa7X3mLmi+6O4nW8E4NCXJna5g7kwA1690rVtjNvaX/dPkl0aC076FixvAan8SmhjDRPZnb+YVcRtqw/wqIRIjVVnORpB6t6OdWEg7K5gPpVnsthn66JOlRTTPbaPFfdSyv0zxKKEpUi0NZD/aK3/YQq/ITrGyIC3LLB6u0trn2IGy32/T5URINVrpkFR0aAWZmb0i0sqlfiJ0GJxSIMRjqkT7ExpSUb+ZbUoRPjCbm3RW+9Mh1sTJNqL8OENRXdHGmtu9tis
 VRb7Z7un
 ghpp7zEaomh7Vk6TNt9XwEyGuxOt6//KiOYrlYZYukjlHAnlAp00a43oCSOJxLbybeVyODZt+90bsz8+84/4mIWvZDoT7CRB8JVkcbHg3XfArpYuX3mOSDK6ZU2v1Vj3XOxeDxTU+mKJvn1KrLt88o0x3wZt1ohUCLZZV+KiidLkAgFUZ1K/eSkTXfBKT0M2+WOPkTfpa9CKZ1BXcJJv9K4LFNGp100ALoKeK58MUTSk6jgsPHvUa/8mJfY29z+4hQCeJTfu0LBwJR6lG0u5wkEki1qo3u8FLaqjZI1lKSNEWM/5iXlG6rLEiYe2UKdRLdY7+Olf/c5eFqjr251UIYub0y2DJmTS972aiQHD0FKQFG2ughZn2H+6K8YfgP9ZNcX84DeYjZo/7flt+8OA+hyHvVn5Qz06Iddu8aXhYXW2eKJzAawNNiqZ5god8yQAALL1K2xx4NId0m3WZ6bRlV5aBKAaO1Xkfxt/PFJ7VzqESojrJ7LZ5Q2qZ9PM4/NIWMogCYi8f3j06ztOGn+a8aRXA2b0LwkiCvyZhpwnZcU2bhzbmZtmcl3jA1CQqFJ66kO2ZYIm6eTRchOtrWD4tWHgzhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
> global cgroup rstat lock synchronously. On machines with many CPUs and
> NUMA nodes, this creates severe lock contention in the kswapd reclaim
> path:
> 
>   - Multiple kswapd threads (one per NUMA node) run concurrently.
>   - do_shrink_slab() invokes zswap_shrinker_count() for each
>     memcg-aware shrinker pass.
>   - Each call flushes the full cgroup rstat hierarchy under the global
>     lock.
> 
> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
> running production workloads with zswap enabled, perf shows 2.88% of
> kernel cycles in osq_lock contention from this path:
> 
>      2.88%  [k] osq_lock
>               --__mutex_lock.constprop.0
>                   --__cgroup_rstat_lock
>                       --cgroup_rstat_flush_locked
>                           --cgroup_rstat_flush
>                               --zswap_shrinker_count
>                                   do_shrink_slab
>                                   shrink_slab
>                                   shrink_node
>                                   balance_pgdat
>                                   kswapd
> 
> 84% of kswapd kernel cycles are spent in
> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
> page reclaim (shrink_lruvec).
> 
> Controlled A/B on identical hardware and workload:
> 
>   shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
>   shrinker=N: 0.00% osq_lock, memory PSI 0.57%
> 
> eBPF-based rstat lock wait measurement across 8 production metals
> confirms the contention splits cleanly along shrinker enablement:
> 
>   shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
>   shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)
> 
> zswap_shrinker_count() only produces a heuristic estimate, scaled by
> compression ratio via mult_frac(). The actual writeback happens in
> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
> 
> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
> the periodic 2-second flusher is one full cycle late. This matches the
> approach already used in prepare_scan_control() (mm/vmscan.c) for the
> same reclaim path.
> 
> After applying this patch, rstat flush latency and lock wait time on
> shrinker=Y machines dropped to the same level as shrinker=N controls,
> while the zswap shrinker continues to function (pool size remains
> bounded under the max_pool_percent cap).
> 
> Previously discussed:
>   - Chengming Zhou (Dec 2023): rstat contention from
>     zswap_shrinker_count [1]
>   - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
>     flush [2]
>   - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
>     flushers [3]
>   - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
> 
> [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/
> [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/
> [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/
> 
> Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
> Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
> Tested-by: Yunzhao Li <yunzhao@cloudflare.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

A lot can happen in 2s, but I agree doing this every time is
silly. vmscan has been good with 2s for a while, so this should be
fine as well. We can re-evaluate if we run into weird behavior.

